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

import { CheckEmptyUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { CommonConstants, DockItemInfo, GridLayoutItemInfo } from '../TsIndex';
import { ShortcutLimitInfo } from '../launchericon/viewmodel/ShortcutViewModel';

const TAG = 'AppShortcutLimitUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);
const SHORTCUT_LIMIT_KEY = 'shortcutLimit';

export enum AppShortcutLimitSourceType {
  GRID_SOURCE = 'gridSource',
  DOCK_SOURCE = 'dockSource'
}

/**
 * 应用分类信息工具类
 */
export class AppShortcutLimitUtils {

  /**
   * 判断是否是相同的应用(不包括快捷方式)
   *
   * @param itemInfo GridLayoutItemInfo
   * @param bundleName 图标bundleName
   * @returns true: 相同， false：不同
   */
  public static isSameAppNoShortcutByBundleName(itemInfo: GridLayoutItemInfo | DockItemInfo, bundleName: string, appIndex: number): boolean {
    return itemInfo.typeId === CommonConstants.TYPE_APP &&
      itemInfo.bundleName === bundleName && itemInfo.appIndex === (appIndex ?? 0);
  }

  /**
   * make the folder layoutInfo into list
   *
   * @param folderInfo
   */
  public static layoutInfoToList(folderInfo: GridLayoutItemInfo | DockItemInfo): GridLayoutItemInfo[] {
    let appInfo: GridLayoutItemInfo[] = [];
    if (!folderInfo.layoutInfo) {
      return appInfo;
    }
    for (let i = 0; i < folderInfo.layoutInfo.length; i++) {
      for (let j = 0; j < folderInfo.layoutInfo[i].length; j++) {
        if (CheckEmptyUtils.isEmpty(folderInfo.layoutInfo[i][j])) {
          continue;
        }
        if (folderInfo.layoutInfo[i][j].typeId !== CommonConstants.TYPE_ADD) {
          appInfo = appInfo.concat(folderInfo.layoutInfo[i][j]);
        }
      }
    }
    return appInfo;
  }

  /**
   * 根据传入的数组，获得所有的应用信息
   * @param appList Array<GridLayoutItemInfo | DockItemInfo>
   * @returns
   */
  public static getAllAppListContainFolder(appList: Array<GridLayoutItemInfo | DockItemInfo>): Array<GridLayoutItemInfo> {
    let allGridLayoutItemList: Array<GridLayoutItemInfo> = [];
    if (!CheckEmptyUtils.isEmptyArr(appList)) {
      appList.forEach((layoutItem) => {
        if (layoutItem.typeId !== CommonConstants.TYPE_FOLDER) {
          allGridLayoutItemList.push(layoutItem as GridLayoutItemInfo);
        } else {
          allGridLayoutItemList = allGridLayoutItemList.concat(AppShortcutLimitUtils.layoutInfoToList(layoutItem));
        }
      });
    }
    return allGridLayoutItemList;
  }

  /**
   * 获取指定应用的快捷方式加桌上限数量
   *
   * @param bundleName 应用bundleName
   * @returns undefined 代表没有设置过，走系统逻辑
   */
  public static getShortCountLimitByBundleName(bundleName: string,
    sourceLayoutItem: Array<GridLayoutItemInfo | DockItemInfo>, sourceType: AppShortcutLimitSourceType):
    number | undefined {
    let limit: number | undefined = undefined;
    if (!CheckEmptyUtils.isEmptyArr(sourceLayoutItem)) {
      limit = AppShortcutLimitUtils.getShortCutLimitNumForAppList(sourceLayoutItem, bundleName);
      log.showWarn(`getShortCutLimit ${sourceType === AppShortcutLimitSourceType.GRID_SOURCE ? 'deskCash' : 'dockCash'}
      num:${limit}`);
    }
    log.showWarn(`shortcutBundleName: ${bundleName} limit: ${limit}`);
    return limit;
  }

  /**
   * 根据传入的应用列表，筛选并更新shortcutLimit
   *
   * @param itemList
   * @param shortcutList
   * @returns
   */
  public static getShortcutLimitUpdateItem(itemList: Array<DockItemInfo | GridLayoutItemInfo>,
    shortcutList:ShortcutLimitInfo[], source: AppShortcutLimitSourceType): Array<GridLayoutItemInfo> {
    let updateItemList: Array<GridLayoutItemInfo> = [];
    let allGridLayoutItemList: Array<GridLayoutItemInfo | DockItemInfo> =
      AppShortcutLimitUtils.getAllAppListContainFolder(itemList);
    for (const shortcut of shortcutList) {
      let appItemInLayout: GridLayoutItemInfo | DockItemInfo | undefined = allGridLayoutItemList
        .find(item => item.bundleName === shortcut.bundleName && item.appIndex === 0 && item.typeId === CommonConstants.TYPE_APP);
      if (appItemInLayout) {
        let intentMap: Map<string, Object> = CommonUtils.jsonStrToMap(appItemInLayout.intent);
        intentMap.set(SHORTCUT_LIMIT_KEY, shortcut.maxNum);
        appItemInLayout.intent = CommonUtils.mapToJonStr(intentMap);
        updateItemList.push(appItemInLayout as GridLayoutItemInfo);
        log.showWarn(`updateShortcutLimit ${source === AppShortcutLimitSourceType.GRID_SOURCE
          ? 'desk cash' : 'dock cash'} : ${appItemInLayout.bundleName} limit:${shortcut.maxNum}`);
      }
    }
    return updateItemList;
  }

  /**
   * 根据bundleName获得对应应用的加桌上限设置
   *
   * @param appList 应用列表
   * @param bundleName 目标应用bundleName
   * @returns
   */
  public static getShortCutLimitNumForAppList(appList: Array<GridLayoutItemInfo | DockItemInfo>, bundleName: string):
  number | undefined {
    let allAppList: Array<GridLayoutItemInfo | DockItemInfo> = [];
    let limit: number | undefined = undefined;
    appList.forEach((layoutItem) => {
      if (layoutItem.typeId !== CommonConstants.TYPE_FOLDER) {
        allAppList.push(layoutItem);
      } else {
        allAppList = allAppList.concat(AppShortcutLimitUtils.layoutInfoToList(layoutItem));
      }
    });
    const shortcutList: Array<GridLayoutItemInfo | DockItemInfo> = allAppList
      .filter(item => AppShortcutLimitUtils.isSameAppNoShortcutByBundleName(item, bundleName, 0));
    const intent = !CheckEmptyUtils.isEmptyArr(shortcutList) ?
    CommonUtils.jsonStrToMap(shortcutList[0].intent).get(SHORTCUT_LIMIT_KEY) : undefined;
    if (intent !== undefined) {
      limit = intent as number;
    }
    return limit;
  }
}