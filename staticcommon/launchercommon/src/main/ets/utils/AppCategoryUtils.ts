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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
// import { appInfoManager } from '@kit.StoreKit';
import rdb from '@ohos.data.rdb';
import AppCategoryInfoColumns, { AppCategoryInfoEnums } from '../db/column/AppCategoryInfoColumns';
import { ResourceManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import GridLayoutUtil from './GridLayoutUtil';
import { CommonConstants } from '../constants/CommonConstants';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { LaunchLayoutCacheManager } from '../cache/layout/LaunchLayoutCacheManager';
import { DockItemInfo } from '../bean/DockItemInfo';
import { ResidentLayoutCacheMgr } from '../dock/cache/ResidentLayoutCacheMgr';

const TAG = 'AppCategoryUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 应用分类信息工具类
 */
export class AppCategoryUtils {
  /**
   * 从Item中提取出bundleName
   *
   * @param items 待获取bundleName的元素
   * @returns 元素的bundleName集合
   */
  public static getBundleNameList(items: GridLayoutItemInfo[] | DockItemInfo[]): string[] {
    if (!items || items.length === 0) {
      log.showInfo('getBundleNameList items is null');
      return [];
    }
    let bundleNames: string[] = [];
    for (let i = 0; i < items.length; i++) {
      let item = items[i] as GridLayoutItemInfo;
      if (!item) {
        continue;
      }
      if (GridLayoutUtil.isIconType(item.typeId)) {
        bundleNames.push(item.bundleName);
      } else if (item.typeId === CommonConstants.TYPE_FOLDER) {
        let folderApps: GridLayoutItemInfo[] = item.layoutInfo?.flat() ?? [];
        for (let j = 0; j < folderApps?.length; j++) {
          bundleNames.push(folderApps[j].bundleName);
        }
      }
    }
    log.showInfo(`getBundleNameList bundleNames.length: ${bundleNames.length}`);
    return bundleNames;
  }

  /**
   * 将 appInfoManager.AppCategoryInfo 转化为 ValuesBucket
   *
   * @param appCatInfo 待转化元素
   * @returns 转化结果
   */
  // public static toValuesBucket(appCatInfo: appInfoManager.AppCategoryInfo): rdb.ValuesBucket {
  //   if (appCatInfo == null) {
  //     log.showError('toValuesBucket error, appCatInfo is null');
  //     return {};
  //   }
  //   return {
  //     [AppCategoryInfoEnums.BUNDLE_NAME]: appCatInfo.bundleName,
  //     [AppCategoryInfoEnums.SECONDARY_CATEGORY_ID]: appCatInfo.secondaryCategoryId
  //   };
  // }

  /**
   * 将 ResultSet 转换为 appInfoManager.AppCategoryInfo
   *
   * @param resultSet data from db
   * @returns 应用的分类信息
   */
  // public static fromResultSet(resultSet: rdb.ResultSet): appInfoManager.AppCategoryInfo | undefined {
  //   if (resultSet != null) {
  //     const appCategoryInfo = {
  //       bundleName: resultSet.getString(resultSet.getColumnIndex(AppCategoryInfoColumns.BUNDLE_NAME)),
  //       primaryCategoryId: 0,
  //       secondaryCategoryId: resultSet.getLong(resultSet.getColumnIndex(AppCategoryInfoColumns.SECONDARY_CATEGORY_ID)),
  //       appQueryCode: 0
  //     } as appInfoManager.AppCategoryInfo;
  //     return appCategoryInfo;
  //   }
  //   return undefined;
  // }

  /**
   * 获取桌面和dock区所有应用的bundleName
   *
   * @returns 所有应用的bundleName
   */
  public static getAllAppBundleNames(): string[] {
    let gridItems: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList('AppCategory');
    let dockItems: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let gridItemBundleNames = AppCategoryUtils.getBundleNameList(gridItems);
    let dockItemBundleNames = AppCategoryUtils.getBundleNameList(dockItems);
    return gridItemBundleNames.concat(dockItemBundleNames);
  }

  /**
   * 替换资源字符串后，获取智能命名后的文件夹名称
   * (智能命名后的文件夹名称格式:'#'+应用分类名称的CodeID，如分类名称为工具，则结果为 '#app_category_tools'，需要使用该方法获取最终的名称)
   *
   * @param originFolderName 原始的资源字符串
   * @returns 智能命名后的文件夹名称
   */
  public static getIntelFolderName(originFolderName: string): string {
    log.showInfo(`getIntelFolderName originFolderName: ${originFolderName}`);
    let tempNameArr: string[] = originFolderName.split('#');
    let nameArrSize: number = tempNameArr.length;
    if (nameArrSize === 2) {
      if (CheckEmptyUtils.checkStrIsEmpty(tempNameArr[1])) {
        log.showError('getIntelFolderName, tempNameArr[1] is null');
        return '';
      }
      return ResourceManager.getInstance().getStringByName(tempNameArr[1]);
    }
    if (nameArrSize === 3) {
      if (CheckEmptyUtils.checkStrIsEmpty(tempNameArr[1]) || CheckEmptyUtils.checkStrIsEmpty(tempNameArr[2])) {
        log.showError('getIntelFolderName, tempNameArr[1] or tempNameArr[2] is null');
        return '';
      }
      let appCatName1 = ResourceManager.getInstance().getStringByName(tempNameArr[1]);
      let appCatName2 = ResourceManager.getInstance().getStringByName(tempNameArr[2]);
      if (CheckEmptyUtils.checkStrIsEmpty(appCatName1) || CheckEmptyUtils.checkStrIsEmpty(appCatName2)) {
        log.showError('getIntelFolderName, appCatName1 or appCatName2 is null');
        return '';
      }
      let folderName = ResUtils.getInnerStringNumS($r('app.string.folder_intelligent_name'), appCatName1, appCatName2);
      return folderName;
    }
    return '';
  }
}