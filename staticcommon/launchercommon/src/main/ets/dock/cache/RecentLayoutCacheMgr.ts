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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  AppModel,
  CommonDockModel,
  DockItemInfo,
  DockUtils,
  GetHideAppsFromConfig,
  launcherAbilityManager,
  RdbStoreManager,
  ResidentLayoutCacheMgr } from '../../TsIndex';
import { BaseDockLayoutCacheMgr } from './BaseDockLayoutCacheMgr';

const TAG = 'RecentLayoutCacheMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 *  手机recent缓存数据管理类
 */
export class RecentLayoutCacheMgr extends BaseDockLayoutCacheMgr {

  protected static instance: RecentLayoutCacheMgr;

  protected mAppModel: AppModel;

  protected visibleCount: number | undefined;

  private constructor() {
    super();
    this.mAppModel = AppModel.getInstance();
  }

  /**
   * getInstance
   * @returns 当前对象
   */
  public static getInstance(): RecentLayoutCacheMgr {
    if (!RecentLayoutCacheMgr.instance) {
      RecentLayoutCacheMgr.instance = new RecentLayoutCacheMgr();
      RecentLayoutCacheMgr.instance.init();
      if (DeviceHelper.isPhoneOrPad()) {
        RecentLayoutCacheMgr.instance.initVisibleCount().then(() => {}).catch((reason: Error) => {
          log.showError(`initVisibleCount error: ${reason}`);
        });
      }
    }
    return RecentLayoutCacheMgr.instance;
  }

  /**
   * 获取所有recent区数据
   * @returns 当前recent区缓存
   */
  getAllDockItems(): DockItemInfo[] {
    return this.dockCacheData ?? [];
  }

  /**
   * 更新所有recent区数据，第三个入参isOperateDb决定是否入库
   * @param from 更新来源
   * @param dockItems 数据
   * @param isOperateDb 是否操作数据库，默认入库
   */
  updateAllDockItems(from: string, dockItems: DockItemInfo[], isOperateDb: boolean = true): void {
    let paramLog = DockUtils.getPrintParam(dockItems);
    log.showInfo(`updateAllDockItems from: ${from}, param: ${paramLog}, isOperateDb: ${isOperateDb}`);
    this.dockCacheData = dockItems;
    // trigger component update
    AppStorage.setOrCreate('recentDockList', dockItems);
    if (isOperateDb) {
      this.updateRecentDock(dockItems);
    }
  }

  private updateRecentDock(recentDockList: DockItemInfo[]): void {
    // 先清空原来的数据，然后把数据增加进去
    RdbStoreManager.getInstance().deleteAllRecentDockData().then(() => {
      RdbStoreManager.getInstance().insertIntoRecentDock(recentDockList).then(() => {
        log.showInfo('updateRecentDock success.');
      }).catch((err: Error) => {
        log.showError(`updateRecentDock error: ${err.toString()}`);
      });
    });
  }

  /**
   * 初始化resident区的缓存数据
   * @param isFirst
   * @returns
   */
  private async init(): Promise<void> {
    // query rdb data
    let dockDataList: DockItemInfo[] = await CommonDockModel.getInstance().queryRecentDock();
    if (CheckEmptyUtils.isEmptyArr(dockDataList)) {
      log.showInfo('init from rdb length is 0');
      return;
    }
    let dockItemInfoList: DockItemInfo[] = [];
    // 避免数据不准确 存在重复数据
    let hasContained: string[] = [];
    for (let i = 0; i < dockDataList.length; i++) {
      let dockItemInfo = await ResidentLayoutCacheMgr.getInstance().createDockAppInfo(dockDataList[i], i);
      if (!dockItemInfo || hasContained.indexOf(dockItemInfo.keyName ?? '') >= 0 ||
        launcherAbilityManager.isIgnoreApp(dockDataList[i])) {
        continue;
      }
      hasContained.push(dockItemInfo.keyName ?? '');
      dockItemInfoList.push(dockItemInfo);
    }
    dockItemInfoList = GetHideAppsFromConfig.getInstance().filterHideApp(dockItemInfoList);
    this.updateAllDockItems(TAG.concat('_init'), dockItemInfoList, true);
  }

  /**
   * 初始化visibleCount
   * @returns
   */
  private async initVisibleCount() : Promise<void> {
    this.visibleCount = await this.queryRecentDockInfo();
    if (!CheckEmptyUtils.isEmpty(this.visibleCount)) {
      this.updateVisibleCount(this.visibleCount);
    }
  }

  /**
   * 获取最大可见数量
   * @returns 返回可见数量
   */
  public getVisibleCount(): number {
    return this.visibleCount ?? 0;
  }

  /**
   * 更新可见数量
   * @param mVisibleCount
   * @param isOperateDb 是否入库，默认是
   */
  public updateVisibleCount(mVisibleCount: number, isOperateDb: boolean = true): void {
    this.visibleCount = mVisibleCount;
    AppStorage.setOrCreate<number>('visibleCount', this.visibleCount);
    if (isOperateDb) {
      this.updateRecentVisibleCount(this.visibleCount);
    }
  }

  private updateRecentVisibleCount(visibleCount: number): void {
    RdbStoreManager.getInstance().insertIntoRecentDockInfo(visibleCount).then((result) => {
      log.showInfo('updateRecentDockInfo success.');
    }).catch((err: Error) => {
      log.showError(`updateRecentDockInfo error: ${err.toString()}`);
    });
  }

  private async queryRecentDockInfo(): Promise<number> {
    // query rdb data
    return await RdbStoreManager.getInstance().queryRecentDockInfo() as number;
  }
}