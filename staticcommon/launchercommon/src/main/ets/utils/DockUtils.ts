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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ScenePanelState } from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import display from '@ohos.display';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { DockItemInfo } from '../bean/DockItemInfo';
import { AppStatus, CommonConstants } from '../constants/CommonConstants';
import { FolderModel, GridLayoutItemInfo, RdbStoreManager } from '../TsIndex';

const TAG = 'DockUtils';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Dock utils
 */
export class DockUtils {
  private static isIntegratedDockEnable: boolean = systemParameterEnhance.getSync('persist.pad.integrated.dock.enabled', 'false') === 'true';
  /**
   * 判断设备是否存在合一dock
   * 目前折叠屏存在
   * @returns 是否存在合一dock
   */
  public static isExistIntegratedDock(): boolean {
    if (DeviceHelper.isPad()) {
      return DockUtils.isIntegratedDockEnable;
    }
    let isFoldable: boolean = false;
    try {
      isFoldable = DeviceHelper.isFoldButNotSmallFoldProduct();
    } catch (error) {
      log.showError(`isExistIntegratedDock get display.isFoldable failed, error: ${error}`);
    }
    log.showDebug(`isExistIntegratedDock isFoldable is ${isFoldable}`);
    return isFoldable;
  }

  /**
   * 判断设备当前状态是否支持显示全量dock，full dock = resident + divider + recent
   * 目前折叠屏展开态支持全量dock
   * @returns 是否支持全量dock
   */
  static isSupportFullDock(): boolean {
    if (DeviceHelper.isPad()) {
      return DockUtils.isIntegratedDockEnable;
    }
    let isFoldable: boolean = false;
    try {
      isFoldable = DeviceHelper.isFoldButNotSmallFoldProduct();
    } catch (error) {
      log.showError(`isSupportFullDock get display.isFoldable failed, error: ${error}`);
    }
    if (!isFoldable) {
      return false;
    }
    let foldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
    try {
      foldStatus = display.getFoldStatus();
    } catch (error) {
      log.showError(`isSupportFullDock get display.getFoldStatus failed, error: ${error}`);
    }
    log.showInfo(`isSupportFullDock foldStatus is ${foldStatus}`);
    if (foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED || foldStatus === display.FoldStatus.FOLD_STATUS_HALF_FOLDED) {
      return true;
    }
    return false;
  }

  /**
   * 判断设备当前状态是否支持应用内dock
   * 目前折叠屏展开态、PAD在全屏、分屏、悬浮窗状态可显示合一dock
   * @returns 是否支持合一dock
   */
  public static isSupportIntegratedDock(): boolean {
    if (!DockUtils.isSupportFullDock()) {
      return false;
    }
    // 桌面不显示、recent不显示、全屏可显示、分屏完成态可显示（分屏完成状态是FULLSCENE）、待分屏状态不可显示（待分屏状态是SPLIT）、悬浮窗可显示
    let scenePanelState: number | undefined = AppStorage.get<number>('scenePanelState');
    log.showInfo(`current scene panel state is ${scenePanelState}`);
    if (scenePanelState === ScenePanelState.HOME || scenePanelState === ScenePanelState.RECENT || scenePanelState === ScenePanelState.SPLIT) {
      return false;
    }
    return true;
  }

  /**
   * 获取dock栏元素的组件id
   *
   * @param dockItemInfo dock栏元素信息
   * @param tag dock区域标识
   * @returns dock栏元素的组件id
   */
  public static getDockItemId(dockItemInfo: DockItemInfo,
    tag: string = CommonConstants.RESIDENT_LAYOUT_APP_TAG): string {
    if (CheckEmptyUtils.isEmpty(dockItemInfo)) {
      log.showError(`getDockItemId fail, item is invalid.`);
      return '';
    }
    return `${tag}${dockItemInfo.bundleName}` +
      `${dockItemInfo.appIndex ? dockItemInfo.appIndex : ''}${dockItemInfo.shortcutId ?? ''}`;
  }

  /**
   * 获取打印入参的一些信息，方便定位定界
   * @param dataList 入参
   * @returns
   */
  public static getPrintParam(dataList: Array<DockItemInfo>): string {
    if (CheckEmptyUtils.isEmptyArr(dataList)) {
      return '';
    }
    const nameList: Array<string> = [];
    dataList.forEach(item => {
      nameList.push(DockUtils.getPrintDockParam(item));
    });
    const names = nameList.join('_');
    return names;
  }

  /**
   * 获取打印入参的一些信息，方便定位定界
   * @param data 入参
   * @returns
   */
  public static getPrintDockParam(data: DockItemInfo): string {
    if (CheckEmptyUtils.isEmpty(data)) {
      return '';
    }
    return data.keyName ?? 'null' + ':' + data.appStatus ?? 'null' + ':' + data.container ?? 'null';
  }

  /**
   * 将dock区小文件夹内的布局按页排序
   *
   * @param dockItem 需要排序的dock区小文件夹
   */
  public static formatFolderInfo(dockItem: DockItemInfo): void {
    let column: number = FolderModel.getInstance().getFolderOpenLayout()?.column;
    let row: number = FolderModel.getInstance().getFolderOpenLayout()?.row;
    const allCount = column * row;
    if (dockItem.layoutInfo && dockItem.layoutInfo[0].length > allCount) {
      let folderLayoutInfoList: GridLayoutItemInfo[][] = [];
      let integer = Math.floor(dockItem.layoutInfo[0].length / allCount);
      let remainder = dockItem.layoutInfo[0].length % allCount;
      for (let i = 0; i < integer; i++) {
        folderLayoutInfoList.push(dockItem.layoutInfo[0].slice(i * allCount, (i + 1) * allCount));
      }
      if (remainder !== 0) {
        folderLayoutInfoList.push(dockItem.layoutInfo[0].slice(integer * allCount, integer * allCount + remainder));
      }
      (dockItem.layoutInfo as object[]).splice(0, 1);
      dockItem.layoutInfo = folderLayoutInfoList;
    }
  }

  /**
   * 更新应用
   * @param newApp
   */
  public static updateNewInstalledApp(newApp: GridLayoutItemInfo | DockItemInfo): void {
    if (newApp) {
      let originItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      originItem.bundleName = newApp.bundleName;
      originItem.appName = newApp.appName;
      originItem.applicationName = newApp.applicationName;
      originItem.applicationLabelId = newApp.applicationLabelId;
      originItem.appIconId = newApp.appIconId;
      originItem.appLabelId = newApp.appLabelId;
      originItem.isUninstallAble = newApp.isUninstallAble;
      originItem.isSystemApp = newApp.isSystemApp;
      originItem.installTime = newApp.installTime;
      originItem.moduleName = newApp.moduleName;
      originItem.abilityName = newApp.abilityName;
      originItem.appIndex = newApp.appIndex;
      originItem.appStatus = AppStatus.INSTALLED;
      originItem.intent = newApp.intent;
      log.showInfo(`originItem.moduleName = ${originItem.moduleName}, originItem.abilityName = ${originItem.abilityName}`);
      RdbStoreManager.getInstance().updateNewInstalledGridInfo(originItem, false);
    }
  }

  /**
   * 获取当前设备是否支持recent区（从RecentDockModel中迁移的逻辑）
   * @returns
   */
  public static getSupportRecentDockState(): boolean {
    if (DeviceHelper.isPhone() && !DeviceHelper.isFoldButNotSmallFoldProduct()) {
      return false;
    }
    return true;
  }
}