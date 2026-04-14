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
import RdbStoreConfig from '@ohos/frameworkwrapper/src/main/ets/service/db/RdbStoreConfig';
import { DockItemInfo } from '../../bean/DockItemInfo';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { RdbStoreManager } from '../../db/RdbStoreManager';
import { ResidentLayoutCacheMgr } from '../../dock/cache/ResidentLayoutCacheMgr';
import { ResultCode, ShortcutLimitInfo } from '../../launchericon/viewmodel/ShortcutViewModel';
import { AppShortcutLimitSourceType, AppShortcutLimitUtils } from '../../utils/AppShortcutLimitUtils';

const TAG = 'DockLayoutCacheManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default class DockLayoutCacheManager {

  private static instance: DockLayoutCacheManager;

  static getInstance(): DockLayoutCacheManager {
    if (DockLayoutCacheManager.instance == null) {
      DockLayoutCacheManager.instance = new DockLayoutCacheManager();
    }
    return DockLayoutCacheManager.instance;
  }

  /**
   * 更新应用快捷方式加桌上限
   *
   * @param shortcutList 加桌上限设置信息数组
   * @returns 错误码
   */
  public async updateShortcutLimitInfoByShortcutList(shortcutList: Array<ShortcutLimitInfo>): Promise<ResultCode> {
    let resultCode: ResultCode = ResultCode.FAILED_OTHER;
    if (CheckEmptyUtils.isEmptyArr(shortcutList)) {
      log.showWarn('setShortcutLimit: shortcutList is empty');
      return resultCode;
    }
    const needUpdateLimitShortcutList: ShortcutLimitInfo[] = shortcutList
      .filter((shortcutLimitItem) => shortcutLimitItem.bundleName && Number.isInteger(shortcutLimitItem.maxNum) &&
        shortcutLimitItem.maxNum >= 0);
    if (CheckEmptyUtils.isEmptyArr(needUpdateLimitShortcutList)) {
      log.showWarn('setShortcutLimit: formatNormalShortcutList is empty');
      return resultCode;
    }
    const updateItemList: Array<GridLayoutItemInfo> = this.getDockShortcutLimitInfoByList(needUpdateLimitShortcutList);
    let rdbUpdateSuccessCount: number = 0;
    try {
      if (await RdbStoreManager.getInstance().batchUpdateShortcutItemLimitInfo(updateItemList,
        RdbStoreConfig.gridLayoutInfo.tableName)) {
        rdbUpdateSuccessCount++;
      }
      if (await RdbStoreManager.getInstance().batchUpdateShortcutItemLimitInfo(updateItemList,
        RdbStoreConfig.simpleLayoutInfo.tableName)) {
        rdbUpdateSuccessCount++;
      }
    } catch (err) {
      log.showError(`updateShortcutIconCacheInfo error, code: ${err?.code},
            message: ${err?.message}`);
    }
    resultCode = rdbUpdateSuccessCount > 0 ? ResultCode.SUCCESS : ResultCode.FAILED_OTHER;
    return resultCode;
  }

  /**
   * 通过传入的shortcutLimitList，查找并更新dock内对应的主应用的intent中shortcutLimit的值
   * @param shortcutLimitList 设置的shortcutLimit数组
   * @returns 查找到的主应用的gridLayoutItemInfo
   */
  public getDockShortcutLimitInfoByList(shortcutLimitList: ShortcutLimitInfo[]): GridLayoutItemInfo[] {
    let dockLayoutItemList: DockItemInfo[] | undefined = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    const updateItemList = dockLayoutItemList ?
      AppShortcutLimitUtils.getShortcutLimitUpdateItem(dockLayoutItemList,
        shortcutLimitList, AppShortcutLimitSourceType.DOCK_SOURCE) : undefined;
    return updateItemList ?? [];
  }

  /**
   * 获取指定应用的快捷方式加桌上限数量
   *
   * @param bundleName 应用bundleName
   * @returns undefined 代表没有设置过，走系统逻辑
   */
  public getShortCountLimitByBundleName(bundleName: string): number | undefined {
    let dockLayoutItemList: DockItemInfo[] | undefined = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    const limit : number | undefined = AppShortcutLimitUtils.getShortCountLimitByBundleName(bundleName
      , dockLayoutItemList, AppShortcutLimitSourceType.DOCK_SOURCE);
    log.showWarn(`shortcutBundleName: ${bundleName} limit: ${limit}`);
    return limit;
  }
}