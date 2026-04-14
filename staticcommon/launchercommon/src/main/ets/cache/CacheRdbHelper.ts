/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { LogDomain, LogHelper, SingleContext } from '@ohos/basicutils';
import { localEventManager } from '@ohos/frameworkwrapper';
import { DockItemInfo } from '../bean/DockItemInfo';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { CommonConstants } from '../constants/CommonConstants';
import { EventConstants } from '../constants/EventConstants';
import GridLayoutUtil from '../utils/GridLayoutUtil';
import { LaunchLayoutCacheManager } from './layout/LaunchLayoutCacheManager';
import { ResidentLayoutCacheMgr } from '../TsIndex';

const TAG = 'Cache2RdbHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class Cache2RdbHelper {
  private static _instance: Cache2RdbHelper | null = null;
  private eventMap: Map<string, Cache2RdbEvent> = new Map();

  public static getInstance(): Cache2RdbHelper {
    if (!Cache2RdbHelper._instance) {
      Cache2RdbHelper._instance = new Cache2RdbHelper();
    }
    return Cache2RdbHelper._instance;
  }

  public createEvent(eventId: string): boolean {
    if (this.eventMap.has(eventId)) {
      log.showInfo(`event:${eventId} exist`);
      return false;
    }
    this.eventMap.set(eventId, new Cache2RdbEvent(eventId));
    log.showInfo(`create new Cache2RdbEvent ${eventId}`);
    return true;
  }

  public addItem(eventId: string, item: GridLayoutItemInfo): boolean {
    const event = this.eventMap.get(eventId);
    if (!event) {
      return false;
    }
    event.addItem(item);
    return true;
  }

  public setChangedPage(eventId: string, changedPageSet: Set<number>): boolean {
    const event = this.eventMap.get(eventId);
    if (!event) {
      return false;
    }
    event.setChangedPage(changedPageSet);
    return true;
  }

  public deleteItem(eventId: string, item: GridLayoutItemInfo, msg: string): boolean {
    const event = this.eventMap.get(eventId);
    if (!event) {
      return false;
    }
    return event.deleteItem(item, msg);
  }

  public addLock(eventId: string, msg: string): (() => void) | undefined {
    const event = this.eventMap.get(eventId);
    if (!event) {
      return undefined;
    }
    return event.addLock(msg);
  }

  public async executeEvent(eventId: string, isOuter?: boolean, ctx?: SingleContext): Promise<boolean> {
    const event = this.eventMap.get(eventId);
    if (!event) {
      return false;
    }

    let res: boolean = false;
    try {
      res = await event.execute(isOuter, ctx);
    } catch (error) {
      log.error('executeEvent error', error);
    }
    event.release();
    this.eventMap.delete(eventId);
    return res;
  }
}

class Cache2RdbEvent {
  private itemSet: Set<string> = new Set();
  private folderOrStackTypeId = [CommonConstants.TYPE_FOLDER, CommonConstants.TYPE_FORM_STACK];
  private lockList: Map<Promise<void>, string> = new Map();
  private isExecuted: boolean = false;
  private changedPage: Set<number> = new Set();

  constructor(eventName: string) {
    this._unique = eventName;
  }

  private _unique: string = '';

  public get unique(): string {
    return this._unique;
  }

  public addItem(item: GridLayoutItemInfo): void {
    const uniqueKey: string = GridLayoutUtil.generateUniqueKey(item);
    if (!uniqueKey) {
      log.showWarn('add invalid item: %{public}s', item.keyName);
      return;
    }
    this.itemSet.add(uniqueKey);
  }

  public setChangedPage(changedPage: Set<number>): void {
    changedPage.forEach(item => this.changedPage.add(item));
  }

  public deleteItem(item: GridLayoutItemInfo, msg: string): boolean {
    const uniqueKey: string = GridLayoutUtil.generateUniqueKey(item);
    if (uniqueKey) {
      log.showWarn(`delete item:${item.keyName} by:${msg}`);
      return this.itemSet.delete(uniqueKey);
    }
    return false;
  }

  public addLock(msg: string): (() => void) | undefined {
    if (this.isExecuted) {
      log.showInfo(`can't add lock to executed event; event:${this.unique} lock:${msg}`);
      return undefined;
    }
    let lockResolve: (() => void) | undefined;
    const lock = new Promise<void>((resolve) => {
      lockResolve = resolve;
    });
    this.lockList.set(lock, msg);
    log.showInfo(`add lock success; event:${this.unique} lock:${msg} size:${this.lockList.size}`);
    return lockResolve;
  }

  public async execute(isOuter?: boolean, ctx?: SingleContext): Promise<boolean> {
    if (this.isExecuted) {
      log.showInfo(`can't execute again. event:${this.unique}`);
      return false;
    }
    log.showInfo(`event execute; event:${this.unique}`);
    this.isExecuted = true;
    await this.waitForUnLock();

    const cacheMgr = LaunchLayoutCacheManager.getInstance();
    const beforeCount: number = cacheMgr.selectPageCount();
    log.showInfo(`before excute update rdb after drag, page count is ${beforeCount}`);
    // 写库前需要删除本事件中出现的空白页，并同步添加所涉及的改动元素
    const extraUpdateItems: GridLayoutItemInfo[] = cacheMgr.deleteBlankPageByCache(this.changedPage, isOuter);
    log.showInfo(`need updateItems's length is ${extraUpdateItems.length}`);
    extraUpdateItems.forEach((item: GridLayoutItemInfo) => this.addItem(item));
    const afterCount: number = cacheMgr.selectPageCount();
    log.showInfo(`after excute update rdb after drag, page count is ${afterCount}`);

    if (extraUpdateItems.length > 0 || beforeCount !== afterCount) {
      log.showInfo(`deleted blankPage; event:${this.unique}`);
      // 删除空白页后需要刷新布局
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
    }

    if (this.itemSet.size === 0) {
      log.showWarn(`execute interrupt! no changed cacheItem; event:${this.unique}`);
      return false;
    }

    const updatedCacheItemList: GridLayoutItemInfo[] = [];
    const desktopGridItemList: GridLayoutItemInfo[] =
      cacheMgr.getAllGridLayoutItemList(`Cache2RdbEvent:${this.unique}`);

    this.updateCacheList(desktopGridItemList, updatedCacheItemList);
    log.showInfo(`traversal desktop finish; event:${this.unique}`);

    const dockGridItemList: GridLayoutItemInfo[] = [];
    const residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    residentList.forEach((item: DockItemInfo) => dockGridItemList.push(GridLayoutUtil.dockItemToGridLayout(item)));
    this.updateCacheList(dockGridItemList, updatedCacheItemList);
    log.showInfo(`traversal dock finish; event:${this.unique}`);
    this.printChangedItem(updatedCacheItemList);
    cacheMgr.updateInfoToRdb(updatedCacheItemList, this.unique, ctx);
    return true;
  }

  public release(): void {
    if (this.itemSet.size !== 0) {
      this.itemSet.forEach((key: string) => {
        log.showWarn('cannot update item: %{public}s', key);
      });
    }
    this.itemSet.clear();
    this.lockList.clear();
  }

  private async waitForUnLock(): Promise<void> {
    if (this.lockList.size === 0) {
      log.showInfo(`lock list is empty; event:${this.unique}`);
      return;
    }
    log.showInfo(`start waitForLock event:${this.unique} lockList:${Array.from(this.lockList.values()).toString()}`);
    const overTimeHandler: Promise<void> = new Promise((resolve, reject) => {
      setTimeout(() => {
        reject();
      }, 500);
    });
    const lockList = Array.from(this.lockList.keys());
    const waitLock = Promise.all(lockList.map(lock => {
      return lock.then(
        () => log.showInfo(`lock release lock:${this.lockList.get(lock)}`),
        () => log.showInfo(`lock reject lock:${this.lockList.get(lock)}`)
      ).finally(() => this.lockList.delete(lock));
    }));
    await Promise.race([overTimeHandler, waitLock])
      .then(() => log.showWarn(`all lock release; event:${this.unique}`))
      .catch(() => log.showWarn(`some lock overTime :${Array.from(this.lockList.values()).toString()}`));
    this.lockList.clear();
    log.showInfo(`event:${this.unique} all lock release or overTime`);
    return;
  }

  private printChangedItem(itemList: GridLayoutItemInfo[], limit: number = 10): void {
    let count = 0;
    while (count < itemList.length) {
      let arr = itemList.slice(count, count + limit);
      count += limit;
      log.showInfo(`changed cacheItems: ${
        arr.map(item =>`${item.bundleName}_${item.row}_${item.column}_${item.page}_${item.container}`).toString()
      }`);
    }
  }

  private updateCacheList(layoutInfo: GridLayoutItemInfo[], updatedCacheItemList: GridLayoutItemInfo[]): void {
    layoutInfo.forEach((item: GridLayoutItemInfo) => {
      const uniqueKey = GridLayoutUtil.generateUniqueKey(item);
      if (this.itemSet.has(uniqueKey)) {
        updatedCacheItemList.push(item);
        this.itemSet.delete(uniqueKey);
      }

      if (item.typeId !== undefined && this.folderOrStackTypeId.includes(item.typeId)) {
        this.updateCacheList(item.layoutInfo?.flat() ?? [], updatedCacheItemList);
      }
    });
  }
}