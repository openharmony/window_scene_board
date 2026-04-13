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
import {
  AppItemInfo,
  DockItemInfo,
  GridLayoutItemInfo,
  GridLayoutUtil,
  RdbStoreManager,
  SceneMsgEnum
} from '../../TsIndex';
import { PreInstallUtils } from '../../utils/PreInstallUtils';
import { AbstractGridLayoutCorrector } from './AbstractGridLayoutCorrector';
import { AppStatus, CommonConstants } from '../../constants/CommonConstants';

const TAG = 'BundleChangeCorrector';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class BundleChangeCorrector extends AbstractGridLayoutCorrector {
  private mInstalledApps: AppItemInfo[] = [];

  private mDockItemList: GridLayoutItemInfo[] = [];

  constructor(installedApps: AppItemInfo[], dockItemList: DockItemInfo[]) {
    super();
    this.mInstalledApps = installedApps;
    this.mDockItemList = dockItemList as object[] as GridLayoutItemInfo[];
  }

  handleData(gridLayoutInfo: GridLayoutItemInfo[], isOuter?: boolean): void {
    try {
      if (CheckEmptyUtils.isEmptyArr(this.mInstalledApps) || isOuter) {
        return;
      }
      let iconBundleMapFormBMS: Map<String, BundleData> = this.getIconBundleMap(this.mInstalledApps);
      let iconBundleMapFromDesktop: Map<String, BundleData> = this.getIconBundleMap(this.getAllDesktopApp(gridLayoutInfo));
      let deleteElement: GridLayoutItemInfo[] = [];
      // 桌面区缓存中应用包名变化更新检测
      this.dealDesktopData(gridLayoutInfo, iconBundleMapFormBMS, iconBundleMapFromDesktop, deleteElement,
        isOuter ?? false);
      // dock区缓存应用包名变化更新检测
      this.dealDesktopData(this.mDockItemList, iconBundleMapFormBMS, iconBundleMapFromDesktop, deleteElement,
        isOuter ?? false);

      // 删除包名异常的数据
      this.deleteAbnormalDesktopData(deleteElement, gridLayoutInfo, isOuter);
      log.showInfo('the filtered layoutItem size %{public}d and deleteElement size %{public}d',
        gridLayoutInfo.length, deleteElement.length);
    } catch (error) {
      log.showError('BundleChangeCorrector error %{public}s', error.message);
    }
  }

  private dealDesktopData(dataList: GridLayoutItemInfo[], iconBundleMapFormBMS: Map<String, BundleData>,
    iconBundleMapFromDesktop: Map<String, BundleData>, deleteElement: GridLayoutItemInfo[], isOuter: boolean): void {
    log.showInfo('start dealDesktopData length: %{public}d delete size: %{public}d', dataList.length, deleteElement.length);
    dataList.filter((element) => {
      if (element.typeId === CommonConstants.TYPE_APP) {
        return this.dealAppItemData(element, iconBundleMapFormBMS, iconBundleMapFromDesktop, deleteElement, isOuter);
      } else {
        element.layoutInfo = element.layoutInfo?.map(folderPage =>
        folderPage.filter(itemInPage => this.dealAppItemData(itemInPage, iconBundleMapFormBMS,
          iconBundleMapFromDesktop, deleteElement, isOuter)));
        return true;
      }
    });
    log.showInfo('end dealDesktopData length: %{public}d delete size: %{public}d', dataList.length, deleteElement.length);
  }

  /**
   * 处理应用数据
   *
   * @param element 桌面应用元素
   * @param iconBundleMapFormBMS BMS所有包名列表
   * @param iconBundleMapFromDesktop 桌面所有包名列表
   * @param deleteElement 待删除的应用列表
   * @param isOuter 是否外屏
   * @returns true数据正常不需要率
   */
  private dealAppItemData(element: GridLayoutItemInfo, iconBundleMapFormBMS: Map<String, BundleData>,
    iconBundleMapFromDesktop: Map<String, BundleData>, deleteElement: GridLayoutItemInfo[], isOuter?: boolean): boolean {
    if (!this.isNormalInstalledApp(element)) {
      return true;
    }
    let result: boolean = this.compareAndUpdateDesktopDataByBMSData(element, iconBundleMapFormBMS,
      iconBundleMapFromDesktop, isOuter);
    if (!result) {
      deleteElement.push(element);
    }
    return result;
  }

  /**
   * 是否是普通已安装图标
   *
   * @param appItem 图标
   * @returns
   */
  private isNormalInstalledApp(appItem: GridLayoutItemInfo): boolean {
    return appItem.typeId === CommonConstants.TYPE_APP && GridLayoutUtil.isAppInstalled(appItem) &&
      appItem.appStatus !== AppStatus.WAIT_FOR_HARMONY;
  }

  /**
   * 比较桌面与BMS应用包名信息
   *
   * @param element 桌面数据库中应用
   * @param iconBundleMapFormBMS BMS所有包名列表
   * @param iconBundleMapFromDesktop 桌面所有包名列表
   * @returns true正常数据不过滤，false异常数据，桌面数据库需删除
   */
  private compareAndUpdateDesktopDataByBMSData(element: GridLayoutItemInfo, iconBundleMapFormBMS: Map<String, BundleData>,
    iconBundleMapFromDesktop: Map<String, BundleData>, isOuter?: boolean): boolean {
    let desktopData = iconBundleMapFromDesktop.get(this.getIconBundleKey(element));
    let bmsData = iconBundleMapFormBMS.get(this.getIconBundleKey(element));
    if (!bmsData) {
      // 判断预装应用是否需要置灰
      if (PreInstallUtils.checkIsNeedInstallApp(element)) {
        log.showInfo('the preInstall %{public}s appIndex %{public}d need to install', element.bundleName, element.appIndex);
        return true;
      } else {
        log.showInfo('the %{public}s appIndex %{public}d is not installed', element.bundleName, element.appIndex);
        return false;
      }
    }
    if (bmsData.getSize() > 1) {
      return this.checkAndUpdateDesktopDataWithMultiBundle(bmsData, element);
    } else if (bmsData.getSize() === 1) {
      let appItem: AppItemInfo | GridLayoutItemInfo = bmsData.getItemList()[0];
      return this.checkAndUpdateDesktopDataWithOneBundle(appItem, desktopData, element, isOuter);
    } else {
      log.showError('the %{public}s appIndex %{public}d init error', element.bundleName, element.appIndex);
      return false;
    }
  }

  /**
   * 同bundleName应用在bms有多个的情况，直接删掉未匹配的
   *
   * @param bmsData bms侧数据
   * @param element 桌面的应用
   * @returns true不删除，false需要删除
   */
  private checkAndUpdateDesktopDataWithMultiBundle(bmsData: BundleData, element: GridLayoutItemInfo): boolean {
    let result: boolean = bmsData.getItemList().findIndex(item => item.keyName === element.keyName) >= 0;
    if (!result) {
      log.showError('the multiIcon is not match, keyName %{public}s', element.keyName);
    }
    return result;
  }

  /**
   * 同bundleName应用在bms有1个的情况，按规则匹配删除
   *
   * @param appItem BMS的应用
   * @param desktopData 桌面数据库与appItem的bundleName相同的数据
   * @param element 当前元素
   * @param isOuter 是否是外屏
   * @returns true正常数据不删除，false异常数据需要删除
   */
  private checkAndUpdateDesktopDataWithOneBundle(appItem: AppItemInfo | GridLayoutItemInfo,
    desktopData: BundleData | undefined,
    element: GridLayoutItemInfo, isOuter?: boolean): boolean {
    let result: boolean = false;
    if (!desktopData) {
      log.showInfo('the %{public}s is not init', element.bundleName);
      return true;
    }

    if (desktopData.getSize() > 1) {
      result = (appItem?.keyName === element.keyName);
      log.showInfo('the %{public}s match result %{public}s, oldKeyName %{public}s newKeyName %{public}s',
        element.bundleName, result, element.keyName, appItem?.keyName);
    } else if (desktopData.getSize() === 1) {
      if (appItem?.keyName !== element.keyName) {
        log.showWarn('the %{public}s not match, oldKeyName %{public}s newKeyName %{public}s',
          element.bundleName, element.keyName, appItem?.keyName);
        element.abilityName = appItem?.abilityName;
        element.moduleName = appItem?.moduleName;
        element.keyName = appItem?.keyName;
        RdbStoreManager.getInstance().updateNewInstalledGridInfo(element, isOuter);
      }
      result = true;
    } else {
      log.showError('the %{public}s index %{public}d is not find in desktop', element.bundleName, element.appIndex);
      result = false;
    }
    return result;
  }

  /**
   * 删除桌面包名异常的数据
   *
   * @param deleteItems 删除的元素
   * @param gridLayoutInfo 桌面数据列表
   * @param isOuter 是否是外屏
   */
  private deleteAbnormalDesktopData(deleteItems: GridLayoutItemInfo[], gridLayoutInfo: GridLayoutItemInfo[],
    isOuter?: boolean): void {
    deleteItems.forEach(element => {
      let index: number = gridLayoutInfo.findIndex(item => item.keyName === element.keyName);
      if (index >= 0) {
        log.showInfo('deleteAbnormalDesktopData keyName %{public}s, type %{public}d, index %{public}d',
          gridLayoutInfo[index].keyName, gridLayoutInfo[index].typeId, index);
        gridLayoutInfo.splice(index, 1);
      }
      RdbStoreManager.getInstance()
        .deleteGridLayoutByCondition(element, element.container, isOuter, SceneMsgEnum.DELETE_ABNORMAL_DESKTOP_DATA);
    });
  }

  private getAllDesktopApp(gridLayoutInfo: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    let allApps: GridLayoutItemInfo[] = [];
    gridLayoutInfo.forEach((item) => {
      if (this.isNormalInstalledApp(item)) {
        allApps.push(item);
      } else {
        let folderLayoutList: GridLayoutItemInfo[] = item.layoutInfo?.flat() ?? [];
        folderLayoutList = folderLayoutList.filter(itemInFolder => this.isNormalInstalledApp(itemInFolder));
        allApps.push(...folderLayoutList);
      }
    });
    this.mDockItemList.forEach(item => {
      if (this.isNormalInstalledApp(item)) {
        allApps.push(item);
      } else {
        let folderLayoutList: GridLayoutItemInfo[] = item.layoutInfo?.flat() ?? [];
        folderLayoutList = folderLayoutList.filter(itemInFolder => this.isNormalInstalledApp(itemInFolder));
        allApps.push(...folderLayoutList);
      }
    });
    return allApps;
  }

  private getIconBundleMap(installedApps: AppItemInfo[] | GridLayoutItemInfo[]): Map<String, BundleData> {
    let iconBundleMap = new Map<String, BundleData>();
    installedApps.forEach((installedApp: AppItemInfo | GridLayoutItemInfo) => {
      let bundleKey: String = this.getIconBundleKey(installedApp);
      if (iconBundleMap.has(bundleKey)) {
        let bundleData: BundleData | undefined = iconBundleMap.get(bundleKey);
        if (!bundleData) {
          return;
        }
        bundleData.addItem(installedApp);
        iconBundleMap.set(bundleKey, bundleData);
      } else {
        iconBundleMap.set(bundleKey, new BundleData(installedApp));
      }
    });
    return iconBundleMap;
  }

  private getIconBundleKey(item: GridLayoutItemInfo | AppItemInfo): String {
    return `${item.bundleName}_${item.appIndex}`;
  }
}

export class BundleData {
  private itemList: (GridLayoutItemInfo | AppItemInfo)[] = [];

  constructor(item: GridLayoutItemInfo | AppItemInfo) {
    this.itemList.push(item);
  }

  public addItem(newItem: GridLayoutItemInfo | AppItemInfo): void {
    this.itemList.push(newItem);
  }

  public getSize(): number {
    return this.itemList.length;
  }

  public getItemList(): (GridLayoutItemInfo | AppItemInfo)[] {
    return this.itemList;
  }
}