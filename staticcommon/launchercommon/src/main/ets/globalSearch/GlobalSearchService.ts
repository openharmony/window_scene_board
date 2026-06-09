/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { SearchEvents } from './SearchEvents';
import { EventConstants } from '../constants/EventConstants';
import { GlobalSearchStoreManager } from './GlobalSearchStoreManager';
import { AppModel } from '../model/AppModel';
import {
  LogDomain,
  LogHelper,
  CheckEmptyUtils,
} from '@ohos/basicutils';
import { ResourceManager, localEventManager, IconResourceManager } from '@ohos/frameworkwrapper';
import util from '@ohos.util';
import image from '@ohos.multimedia.image';
import { SearchItemInfo } from '../bean/SearchItemInfo';
import type { AppItemInfo } from '../bean/AppItemInfo';
import { ReceiveEventInfo } from '../TsIndex';

const TAG = 'GlobalSearchService';
const HEXADECIMAL_VALUE = 36;
const MAX_INSERT_VALUE = 1;
const START_SUR_VALUE = 2;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * GlobalSearchService Tool
 *
 * @since 2023-08-15
 */
export class GlobalSearchService {
  private static mInstance: GlobalSearchService;

  protected mGlobalSearchStoreManager = GlobalSearchStoreManager.getInstance();

  protected mAppModel = AppModel.getInstance();

  private mResourceManager = ResourceManager.getInstance();

  private constructor() {
  }
  /**
   * globalSearchService instance
   *
   * @return globalSearchService instance
   */
  static getInstance(): GlobalSearchService {
    if (!GlobalSearchService.mInstance) {
      GlobalSearchService.mInstance = new GlobalSearchService();
    }
    return GlobalSearchService.mInstance;
  }

  /**
   * init
   */
  init(): void {
    log.showInfo('init');
    this.mAppModel.getAppList(() => {
      this.setAppList();
    });
    this.subscribeAppEvent();
  }

  /**
   * set app data to db
   */
  async setAppList(): Promise<void> {
    log.showInfo('start setAppList......');
    const appInfoList: AppItemInfo[] = this.mAppModel.getAppList();
    let searchItemList: SearchItemInfo[] = [];
    let updateSearchItemList: SearchItemInfo[] = [];
    for (let appInfo of appInfoList) {
      let convertInfo: SearchItemInfo | undefined = await this.convertToSearchItemInfo(appInfo);
      let searchRecords = await this.mGlobalSearchStoreManager.searchApp(appInfo.bundleName);
      if (convertInfo && !CheckEmptyUtils.isEmptyArr(searchRecords)) {
        updateSearchItemList.push(convertInfo);
      } else if (convertInfo) {
        searchItemList.push(convertInfo);
      }
      if (searchItemList.length === MAX_INSERT_VALUE) {
        await this.mGlobalSearchStoreManager.insertSysAppBatch(searchItemList);
        searchItemList = [];
      }
      if (updateSearchItemList.length === MAX_INSERT_VALUE) {
        await this.mGlobalSearchStoreManager.updateSysAppBatch(updateSearchItemList);
        updateSearchItemList = [];
      }
    }
    if (searchItemList.length > 0) {
      await this.mGlobalSearchStoreManager.insertSysAppBatch(searchItemList);
    }
    if (updateSearchItemList.length > 0) {
      await this.mGlobalSearchStoreManager.updateSysAppBatch(updateSearchItemList);
    }
    await this.mGlobalSearchStoreManager.releaseService();
  }


  /**
   * subscribe app event
   */
  private subscribeAppEvent(): void {
    log.showInfo('subscribeAppEvent start');
    // 订阅者信息
    localEventManager.registerEventListener(this.appListChangeListener, [
      SearchEvents.EVENT_SEARCH_PACKAGE_ADDED,
      SearchEvents.EVENT_SEARCH_PACKAGE_CHANGED,
      SearchEvents.EVENT_SEARCH_PACKAGE_REMOVED,
      SearchEvents.EVENT_SEARCH_PACKAGE_CLICK,
      SearchEvents.EVENT_SEARCH_PACKAGE_LANGUAGE_CHANGED
    ]);
  }

  /**
   * publish app click event
   *
   * @param {AppItemInfo} appInfo
   */
  async publishAppClickEvent(appInfo: AppItemInfo): Promise<void> {
    log.showInfo('publishAppClickEvent start');
    if (CheckEmptyUtils.isEmpty(appInfo)) {
      log.showWarn('publishAppClickEvent appInfo is null');
      return;
    }
    localEventManager.sendLocalEventSticky(SearchEvents.EVENT_SEARCH_PACKAGE_CLICK, appInfo);
  }

  /**
   * convert app event
   *
   * @param {string} event
   * @param {AppItemInfo} mOperationItemInfo
   */
  publishSearchEvent(event: string, mOperationItemInfo: AppItemInfo): Promise<void> {
    log.showInfo('publishSearchEvent start');
    if (mOperationItemInfo === undefined) {
      log.showWarn('appItemInfo is undefined');
      return;
    }
    let options = {
      parameters: {}
    };
    let searchEvent = '';
    if (event === EventConstants.EVENT_PACKAGE_REMOVED) {
      searchEvent = SearchEvents.EVENT_SEARCH_PACKAGE_REMOVED;
    } else {
      if (event === EventConstants.EVENT_PACKAGE_CHANGED) {
        searchEvent = SearchEvents.EVENT_SEARCH_PACKAGE_CHANGED;
      } else {
        searchEvent = SearchEvents.EVENT_SEARCH_PACKAGE_ADDED;
      }
    }
    localEventManager.sendLocalEventSticky(searchEvent, mOperationItemInfo);
  }

  /**
   * app event callback
   */
  private readonly appListChangeListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: AppItemInfo): void => {
      log.showInfo('appListChangeListener rec event:%{public}s', event);
      if (CheckEmptyUtils.isEmpty(params) && event !== SearchEvents.EVENT_SEARCH_PACKAGE_LANGUAGE_CHANGED) {
        log.showInfo('appListChangeListener params is null ');
        return;
      }
      switch (event) {
        case SearchEvents.EVENT_SEARCH_PACKAGE_REMOVED:
          this.removeItemInfo(params.bundleName);
          break;
        case SearchEvents.EVENT_SEARCH_PACKAGE_ADDED:
          this.addItemInfo(params);
          break;
        // case SearchEvents.EVENT_SEARCH_PACKAGE_CLICK:
        case SearchEvents.EVENT_SEARCH_PACKAGE_CHANGED:
          this.updateItemInfo(params);
          break;
        case SearchEvents.EVENT_SEARCH_PACKAGE_LANGUAGE_CHANGED:
          this.updateGlobalSearchAppDataWhenLanguageChange();
          break;
        default:
          break;
      }
    }
  };

  private updateGlobalSearchAppDataWhenLanguageChange(): void {
    log.showInfo('listener event is update applist');
    this.mAppModel.getAppList(() => {
      this.setAppList();
    });
  }

  private async removeItemInfo(bundleName: string): Promise<void> {
    log.showInfo('listener event is remove');
    const searchRecords = await this.mGlobalSearchStoreManager.searchApp(bundleName);
    if (!CheckEmptyUtils.isEmptyArr(searchRecords)) {
      await this.mGlobalSearchStoreManager.deleteRecordBatch(searchRecords);
    }
    await this.mGlobalSearchStoreManager.releaseService();
  }

  private async addItemInfo(params: AppItemInfo): Promise<void> {
    let searchItemList: SearchItemInfo[] = [];
    log.showInfo('listener event is add');
    let convertInfo: SearchItemInfo | undefined = await this.convertToSearchItemInfo(params);
    if (convertInfo === undefined) {
      log.showError('searchItemInfo is undefined');
      return;
    }
    searchItemList.push(convertInfo);
    const searchRecords = await this.mGlobalSearchStoreManager.searchApp(params.bundleName);
    if (CheckEmptyUtils.isEmptyArr(searchRecords)) {
      await this.mGlobalSearchStoreManager.insertSysAppBatch(searchItemList);
    }
    await this.mGlobalSearchStoreManager.releaseService();
  }

  private async updateItemInfo(params: AppItemInfo): Promise<void> {
    log.showInfo('listener event is update');
    let searchItemList: SearchItemInfo[] = [];
    let convertInfo: SearchItemInfo | undefined = await this.convertToSearchItemInfo(params);
    if (convertInfo === undefined) {
      log.showError('searchItemInfo is undefined');
      return;
    }
    const searchRecords = await this.mGlobalSearchStoreManager.searchApp(params.bundleName);
    if (CheckEmptyUtils.isEmptyArr(searchRecords)) {
      log.showError('searchRecords is null');
      return;
    }
    searchItemList.push(convertInfo);
    await this.mGlobalSearchStoreManager.updateSysAppBatch(searchItemList);
    await this.mGlobalSearchStoreManager.releaseService();
  }

  private async convertToSearchItemInfo(info: AppItemInfo): Promise<SearchItemInfo | undefined> {
    if (CheckEmptyUtils.isEmpty(info)) {
      log.showInfo('convertToSearchItemInfo searchItemInfo is null ');
      return undefined;
    }
    const searchItemInfo: SearchItemInfo = new SearchItemInfo();
    if (CheckEmptyUtils.isEmpty(info.appIconId) || CheckEmptyUtils.isEmpty(info.bundleName) ||
      CheckEmptyUtils.isEmpty(info.moduleName)) {
      log.showInfo('appIconId or bundleName or moduleName is null ');
      return undefined;
    }
    let icon = await IconResourceManager.getInstance().getCombIcon(info.bundleName, info.moduleName, info.abilityName,
    undefined, 'CombIcon_GlobalSearchService');
    searchItemInfo.appName = info.appName;
    searchItemInfo.appName = await IconResourceManager.getInstance().getAppName(info.appLabelId, info.bundleName,
      info.moduleName, info.appName);
    searchItemInfo.bundleName = info.bundleName;
    searchItemInfo.abilityName = info.abilityName;
    searchItemInfo.contentType = 'APP';
    searchItemInfo.identifier = info.bundleName;
    searchItemInfo.lcationId = 0;
    searchItemInfo.lastClickTime = new Date().getTime();
    searchItemInfo.icon = icon;
    log.showInfo('convertToSearchItemInfo end');
    return searchItemInfo;
  }

  /**
   * generate a non duplicate ID
   *
   * @param {string} idLength
   */
  private getUUID(): string {
    let id = Date.now().toString(HEXADECIMAL_VALUE);
    id += Math.random().toString(HEXADECIMAL_VALUE).substring(START_SUR_VALUE);
    return id;
  }

  /**
   * destroy
   */
  destroy(): void {
    this.unSubscribeAppEvent();
  }

  private unSubscribeAppEvent(): void {
    log.showDebug('unSubscribeAppEvent');
    localEventManager.unregisterEventListener(this.appListChangeListener);
  }
}