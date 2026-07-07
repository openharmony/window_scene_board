/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { CheckEmptyUtils, CommonUtils, LogDomain, LogHelper, StartType } from '@ohos/basicutils';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { DeviceHelper, RdbStoreConfig, ResourceManager } from '@ohos/frameworkwrapper';
import { AppItemInfo } from '../../bean/AppItemInfo';
import { DockItemInfo } from '../../bean/DockItemInfo';
import { ShortcutInfo } from '../../bean/ReceiveEventInfo';
import { DesktopFileInfo } from '../../bean/DesktopFileInfo';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import LayoutDescription from '../../bean/LayoutDescription';
import { GridLayoutConfig } from '../../configs/GridLayoutConfigs';
import DefaultDesktopLayoutInfo from '../../configs/DefaultDesktopLayoutInfo';
import {
  AppStatus,
  BusinessType,
  CommonConstants,
  DeleteItemType,
  DesktopLayoutState,
  DownloadInfoItem
} from '../../constants/CommonConstants';
import { StyleConstants } from '../../constants/StyleConstants';
import { ResultCode, ShortcutLimitInfo, ShortcutViewModel } from '../../launchericon/viewmodel/ShortcutViewModel';
import { FolderConstants } from '../../constants/FolderConstants';
import { RdbStoreManager } from '../../db/RdbStoreManager';
import GridLayoutUtil from '../../utils/GridLayoutUtil';
import { BaseLayoutCacheManager } from './BaseLayoutCacheManager';
import { ILayoutCacheManager } from './ILayoutCacheManager';
import { LauncherLayoutCacheUtil } from './LauncherLayoutCacheUtil';
import { AppShortcutLimitSourceType, AppShortcutLimitUtils } from '../../utils/AppShortcutLimitUtils';
import { ResidentLayoutCacheMgr, FolderManager } from '../../TsIndex';
import { FormCommonUtil } from '../../utils/FormCommonUtil';
import { LauncherLayoutCacheConfig } from '../LauncherLayoutCacheConfig';
import { launcherStatusUtil } from '@ohos/windowscene';
import { FolderData, FolderLayoutInOpen, FolderModel } from '../../TsIndex';
import { NumberConstants } from '@ohos/commonconstants';

const TAG = 'LaunchLayoutCacheManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const POSITION_INFO_INDEX_TWO = 2;
const SHORTCUT_LIMIT_KEY = 'shortcutLimit';

export class LaunchLayoutCacheManager extends BaseLayoutCacheManager implements ILayoutCacheManager {
  private static instance: LaunchLayoutCacheManager;

  private folderPageAppNum: number = 0;
  private folderColumn: number = 0;
  private folderRow: number = 0;
  private cacheAppCenterList: AppItemInfo[] = [];

  protected constructor() {
    super();
  }

  static getInstance(): LaunchLayoutCacheManager {
    // PC使用LauncherLayoutCacheConfig获取LaunchLayoutCacheManager，SuperFoldLayoutCacheManager为Hpr
    if (LauncherLayoutCacheConfig.getInstance().hasLayoutCacheManager()) {
      let layoutCacheManager: LaunchLayoutCacheManager | undefined =
        LauncherLayoutCacheConfig.getInstance().getLayoutCacheManager();
      if (layoutCacheManager) {
        return layoutCacheManager;
      }
    }
    if (LaunchLayoutCacheManager.instance == null) {
      LaunchLayoutCacheManager.instance = new LaunchLayoutCacheManager();
    }
    return LaunchLayoutCacheManager.instance;
  }

  clearDesktopData(label: string): void {
    log.showInfo('clearDesktopData from %{public}s', label);
    this.layoutCacheData.clearCache();
  }

  /**
   * 根据bundleName查询应用的所有图标
   *
   * @param bundleName 应用的bundleName
   * @returns 相同bundleName应用的所有图标
   */
  selectSameApp(bundleName: string, appIndex?: number): GridLayoutItemInfo[] {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(false);
    return this.selectSameAppWithCache(gridLayoutItemList, bundleName, appIndex);
  }

  public selectSameAppWithCache(gridLayoutItemList: GridLayoutItemInfo[], bundleName: string,
    appIndex?: number): GridLayoutItemInfo[] {
    if (CheckEmptyUtils.isEmptyArr(gridLayoutItemList)) {
      log.showWarn(TAG, 'deleteShortcutItem error, gridLayoutItemList is empty');
      return [];
    }
    return gridLayoutItemList.filter(item => LauncherLayoutCacheUtil.isSameAppByBundleName(item,
      bundleName, appIndex ?? 0));
  }

  /**
   * 获取布局缓存中的快捷方式信息
   *
   * @param bundleName 包名
   * @param appIndex 分身
   * @param shortcutInfoList BMS快捷方式信息
   * @param isOuter 是否外屏
   * @returns 布局缓存中的快捷方式信息
   */
  public getShortcutInfoFromLayoutCache(bundleName: string, appIndex: number, shortcutInfoList: ShortcutInfo[] = [],
    isOuter?: boolean): GridLayoutItemInfo[] {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    if (CheckEmptyUtils.isEmptyArr(gridLayoutItemList)) {
      log.showWarn('The layout cache is empty.');
      return [];
    }
    let shortcutCacheList: GridLayoutItemInfo[] = [];
    let updateFolderMaps: Map<GridLayoutItemInfo, GridLayoutItemInfo[]> = new Map();
    gridLayoutItemList.forEach(item => {
      if (this.isUpdateShortcutInfo(item, bundleName, appIndex, shortcutInfoList)) {
        shortcutCacheList.push(item);
      }
      let updateShortcuts: GridLayoutItemInfo[] = []
      item.layoutInfo?.flat().forEach(layoutItem => {
        if (this.isUpdateShortcutInfo(layoutItem, bundleName, appIndex, shortcutInfoList)) {
          updateShortcuts.push(layoutItem);
          shortcutCacheList.push(layoutItem);
        }
      });
      if (updateShortcuts.length > 0) {
        updateFolderMaps.set(item, updateShortcuts);
      }
    });
    updateFolderMaps.forEach((updateItems: GridLayoutItemInfo[], folderItem: GridLayoutItemInfo) => {
      FolderManager.getInstance().updateFolderItems('update shortcut in folder', folderItem, updateItems);
    })
    return shortcutCacheList;
  }

  /**
   * 是否更新了快捷方式
   */
  private isUpdateShortcutInfo(item: GridLayoutItemInfo, bundleName: string, appIndex: number,
    shortcutInfoList: ShortcutInfo[]): boolean {
    if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON && item.bundleName === bundleName &&
      item.appIndex === (appIndex ?? 0)) {
      for (let shortcutInfo of shortcutInfoList) {
        if (shortcutInfo.bundleName === item.bundleName && shortcutInfo.id === item.shortcutId) {
          item.appIconId = shortcutInfo.iconId ?? 0;
          item.appLabelId = shortcutInfo.labelId;
          item.appStatus = AppStatus.INSTALLED;
          let addShortcut: ShortcutInfo = ObjectCopyUtil.simpleClone(shortcutInfo);
          addShortcut.appIndex = item.appIndex ?? CommonConstants.MAIN_APP_INDEX;
          ShortcutViewModel.getInstance().addShortcutToBMS(addShortcut);
          return true;
        }
      }
      // 克隆场景应用内加桌的快捷方式，BMS查询不到，需要点亮
      item.appStatus = AppStatus.INSTALLED;
      return true;
    }
    return false;
  }

  /**
   * 移除单个快捷图标
   *
   * @param appItem 移除图标item
   * @param isOperateDb 是否操作数据库
   */
  deleteShortcutItem(appItem: AppItemInfo, isOperateDb: boolean = true, isOuter?: boolean): void {
    log.showInfo(`deleteShortcutItem ${appItem?.shortcutId}`);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    if (CheckEmptyUtils.isEmptyArr(gridLayoutItemList)) {
      log.showWarn(TAG, 'deleteShortcutItem error, gridLayoutItemList is empty');
      return;
    }
    let deleteItemList: GridLayoutItemInfo[] = gridLayoutItemList.filter(item => LauncherLayoutCacheUtil
      .isSameShortcutApp(item, appItem.bundleName, appItem.shortcutId ?? '', appItem.appIndex ?? 0));
    let filter =
      (item: GridLayoutItemInfo): boolean =>!LauncherLayoutCacheUtil.isSameShortcutApp(item, appItem.bundleName,
        appItem.shortcutId ?? '', appItem.appIndex ?? 0);
    // 更新缓存
    gridLayoutItemList = gridLayoutItemList.filter(filter);
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, isOuter);
    // 删除数据库
    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.deleteShortcutItemCallBack(deleteItemList, isOuter);
      } catch (error) {
        log.showError('deleteShortcutItem with error %{public}s', error.message);
      }
    }
  }

  selectSameAppOuter(bundleName: string): GridLayoutItemInfo[] {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(true);
    if (CheckEmptyUtils.isEmptyArr(gridLayoutItemList)) {
      log.showWarn(TAG, 'selectSameApp error, gridLayoutItemList is empty');
      return [];
    }
    return gridLayoutItemList.filter(item => (item.bundleName === bundleName));
  }

  getOuterList(): GridLayoutItemInfo[] {
    return this.layoutCacheData.getGridLayoutItemList(true);
  }

  getOuterInfo(): DefaultDesktopLayoutInfo {
    return this.layoutCacheData.getGridLayoutInfo(true);
  }

  public findSameOuterAppIcon(appItem: AppItemInfo): GridLayoutItemInfo[] | undefined {
    if (CommonUtils.isInvalid(appItem)) {
      log.showError(`findSameOuterAppIcon, appItem is invalid.`);
      return undefined;
    }
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(true);
    return gridLayoutItemList.filter(item => LauncherLayoutCacheUtil
      .isSameShortcutApp(item, appItem.bundleName, appItem.shortcutId ?? '', appItem.appIndex ?? 0));
  }

  /**
   * 更加DeleteItem删除布局元素
   *
   * @param appItem deleteItem删除的应用
   * @param label 业务标识
   * @param isOperateDb true需要数据库操作，false不需要, isOuter true为外屏
   */
  deleteSameAppAndFolder(appItem: DeleteItemType, label: string, isOperateDb: boolean = true,
    isOuter?: boolean): void {
    if (CheckEmptyUtils.isEmpty(appItem)) {
      log.showWarn('deleteSameAppAndFolder error as the appItem is null');
      return;
    }
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    let deleteItemList: GridLayoutItemInfo[] = gridLayoutItemList.filter(item => LauncherLayoutCacheUtil
      .isSameAppOrSmallFolder(item, appItem.bundleName ?? '', appItem.keyName ?? '', appItem.folderId ?? '',
        appItem.appIndex, appItem.shortcutId));
    log.showWarn('deleteGridLayoutItemsByDeleteItem with bundleName %{public}s from business %{public}s, ' +
      'db %{public}s, deleteItemList length:%{public}d',
      appItem.bundleName, label, isOperateDb, deleteItemList.length);
    if (deleteItemList.length === 0) {
      gridLayoutItemList.forEach(item => {
        if (item.bundleName === appItem.bundleName) {
          log.showInfo(`already exist itemInfo.bundleName: ${item.bundleName},
         itemInfo.appIndex: ${item.appIndex}, itemInfo.keyName: ${item.keyName}`);
          return;
        }
      });
      return;
    }
    let filter = (item: GridLayoutItemInfo): boolean => !LauncherLayoutCacheUtil
      .isSameAppOrSmallFolder(item, appItem.bundleName ?? '', appItem.keyName ?? '', appItem.folderId ?? '',
        appItem.appIndex, appItem.shortcutId);
    gridLayoutItemList = gridLayoutItemList.filter(filter);
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, isOuter);
    LauncherLayoutCacheUtil.changeLazyRotateSettings(gridLayoutItemList);
    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.deleteAppItemCallBack(appItem, deleteItemList, isOuter);
      } catch (error) {
        log.showError('deleteGridLayoutItemsByDeleteItem with error %{public}s', error.message);
      }
    }
  }

  /**
   * 获取所有桌面元素（包含文件夹内的元素）
   * @returns
   */
  private getGridLayoutItemsIncludingFolderContents(): GridLayoutItemInfo[] {
    let result: GridLayoutItemInfo[] = [];
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    for (const item of gridLayoutItemList) {
      result.push(item);
      if (item.typeId === CommonConstants.TYPE_REGION_FOLDER) {
        let subItems = item.layoutInfo?.flat();
        if (!subItems) {
          continue;
        }
        for (const subItem of subItems) {
          result.push(subItem);
        }
      }
    }
    return result;
  }

  /**
   * isGridInfoHasMedia
   *
   * @param fileInfo 文件对象
   * @returns ture
   */
  isGridInfoHasMedia(fileInfo: DesktopFileInfo): boolean {
    if (CheckEmptyUtils.isEmpty(fileInfo)) {
      log.showInfo('isGridInfoHasMedia error as the fileInfo is null');
      return false;
    }
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    for (let item of gridLayoutItemList) {
      if (item.typeId !== CommonConstants.TYPE_FILE_FOLDER) {
        continue;
      }
      if (item?.ino === fileInfo.ino) {
        return true;
      }
    }
    return false;
  }

  /**
   * 检查是否存在位置重复的元素
   *
   * @param isOuter 是否是外屏
   * @returns true表示布局元素位置重复
   */
  checkIfDuplicatePosition(isOuter?: boolean): boolean {
    const mPositionInfo: number[][] = [];
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    for (let i = 0; i < gridLayoutItemList.length; i++) {
      let tmpArea = gridLayoutItemList[i].area;
      if (!tmpArea || CheckEmptyUtils.isEmptyArr(tmpArea) ||
        tmpArea.length !== StyleConstants.DEFAULT_2) {
        log.showInfo(`the GridLayoutItemInfo is invalid area %{public}s, column %{public}d, row %{public}d, page %{public}d`,
          gridLayoutItemList[i].area, gridLayoutItemList[i].column, gridLayoutItemList[i].row, gridLayoutItemList[i].page);
        continue;
      }
      for (let j = 0; j < tmpArea[1]; j++) {
        for (let k = 0; k < tmpArea[0]; k++) {
          const position: number[] = [];
          position[0] = gridLayoutItemList[i].page ?? 0;
          position[1] = (gridLayoutItemList[i].row ?? 0) + j;
          position[POSITION_INFO_INDEX_TWO] = (gridLayoutItemList[i].column ?? 0) + k;
          mPositionInfo.push(position);
        }
      }
    }
    for (let i = 0; i < mPositionInfo.length; i++) {
      for (let j = mPositionInfo.length - 1; j > 0 && j > i; j--) {
        if (mPositionInfo[i][0] === mPositionInfo[j][0] &&
          mPositionInfo[i][1] === mPositionInfo[j][1] &&
          mPositionInfo[i][POSITION_INFO_INDEX_TWO] === mPositionInfo[j][POSITION_INFO_INDEX_TWO]) {
          LauncherLayoutCacheUtil.printDuplicateInfo(mPositionInfo[i][0], mPositionInfo[i][1],
            mPositionInfo[i][POSITION_INFO_INDEX_TWO], gridLayoutItemList);
          return true;
        }
      }
    }
    return false;
  }

updateLayoutIfDuplicate(): void {}

  /**
   * 检查布局是否合理
   *
   * @returns true-合理
   */
  checkIfLayoutRationality(gridConfig: GridLayoutConfig): boolean {
    if (CheckEmptyUtils.isEmpty(gridConfig)) {
      log.showWarn('checkIfLayoutRationality error as the gridConfig is null');
      return false;
    }
    const column: number = gridConfig.column;
    const row: number = gridConfig.row;
    // verify whether the layoutInfo's page and row and column is more than standard.
    if (this.ifPageOrColumnRowOutOfBound(row, column)) {
      log.showError('ifLayoutRationality pageOrColumnRowOutOfBound');
      return false;
    }
    return true;
  }

  /**
   * 是否元素超过布局大小
   * @param row 行
   * @param column 列
   * @returns true-超过布局大小
   */
  ifPageOrColumnRowOutOfBound(row: number, column: number): boolean {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    for (let i = 0; i < gridLayoutItemList.length; i++) {
      // page negative or column row are bigger than legal num
      if (LauncherLayoutCacheUtil.isOutOfLayoutBound(gridLayoutItemList[i], row, column) ||
        (gridLayoutItemList[i].page ?? 0) < 0) {
        log.showError('layout has invalid page or column or row. maxColumn:%{public}d, maxRow:%{public}d. ' +
          'layout info is {page:%{public}d, column:%{public}d, row:%{public}d, width:%{public}d, height:%{public}d, ' +
          'typeId:%{public}d, bundleName:%{public}s, cardId:%{public}s, folderId:%{public}s, formStackId:%{public}s}',
          column, row, gridLayoutItemList[i].page, gridLayoutItemList[i].column, gridLayoutItemList[i].row,
          gridLayoutItemList[i].area?.[0], gridLayoutItemList[i].area?.[1], gridLayoutItemList[i].typeId,
          gridLayoutItemList[i].bundleName, gridLayoutItemList[i].cardId, gridLayoutItemList[i].folderId,
          gridLayoutItemList[i].formStackId);
        return true;
      }
    }
    return false;
  }

  /**
   * 检查是否新安装应用
   *
   * @param appItem 应用item
   * @param isOuter 是否是外屏
   * @returns tru新应用
   */
  checkIfNewInstalledApp(appItem: GridLayoutItemInfo, isPad: boolean, isOuter: boolean): boolean {
    if (CheckEmptyUtils.isEmpty(appItem)) {
      log.showWarn('checkIfNewInstalledApp error as the appItem is null');
      return false;
    }
    if (appItem.typeId !== CommonConstants.TYPE_APP) {
      log.showWarn('checkIfNewInstalledApp false as the item is not a app');
      return false;
    }
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    let portraitSign: boolean = !this.updateIfNewInstalledApp(appItem, gridLayoutItemList, true, isOuter);
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, isOuter);
    if (isPad) {
      // 如果是pad, 更新旋转后的缓存
      let rotateLayoutInfo: DefaultDesktopLayoutInfo | null =
        this.layoutCacheData.getPadPortraitMode() ? this.layoutCacheData.getLandscapeLayoutInfo() :
        this.layoutCacheData.getPortraitLayoutInfo();
      if (rotateLayoutInfo) {
        let rotateItemList = rotateLayoutInfo.layoutInfo;
        if (rotateItemList && rotateItemList.length > 0) {
          this.updateIfNewInstalledApp(appItem, rotateItemList, false, isOuter);
        }
      }
    }
    return portraitSign;
  }

  /**
   * 检查是否新安装应用
   *
   * @param appItem 应用item
   * @param isOuter 是否是外屏
   * @returns tru新应用
   */
  updateIfNewInstalledApp(appItem: GridLayoutItemInfo, gridLayoutItemList: GridLayoutItemInfo[],
    isOperateDb: boolean, isOuter: boolean): boolean {
    let sign: boolean = false;
    for (let j = 0; j < gridLayoutItemList.length; j++) {
      if (appItem.typeId === gridLayoutItemList[j].typeId &&
        appItem.bundleName === gridLayoutItemList[j].bundleName &&
        appItem.appIndex === gridLayoutItemList[j].appIndex &&
        !GridLayoutUtil.isAppInstalled(gridLayoutItemList[j])) {
        // if the app is installing and was successfully installed, change its layout info like keyName in order to placeholder
        this.updateLayoutInfoByAppInfo(gridLayoutItemList[j], appItem, BusinessType.BUSINESS_BASIC_DESKTOP,
          isOperateDb);
        sign = true;
        break;
      } else if (appItem.typeId === gridLayoutItemList[j].typeId &&
        appItem.typeId === CommonConstants.TYPE_APP &&
        appItem.keyName === gridLayoutItemList[j].keyName) {
        gridLayoutItemList[j].badgeNumber = appItem.badgeNumber;
        sign = true;
        break;
      } else if (gridLayoutItemList[j].typeId === CommonConstants.TYPE_FOLDER) {
        sign = this.updateNewAppInFolder(appItem, gridLayoutItemList[j], isOperateDb, isOuter);
        if (sign) {
          break;
        }
      }
    }
    return sign;
  }

  private updateNewAppInFolder(appItem: GridLayoutItemInfo, folderItem: GridLayoutItemInfo,
    isOperateDb: boolean, isOuter: boolean): boolean {
    let folderElement: GridLayoutItemInfo | undefined = undefined;
    let foldLayoutList = folderItem.layoutInfo?.flat();
    folderElement = foldLayoutList?.find(item => {
      return item.bundleName === appItem.bundleName && item.appIndex === appItem.appIndex && item.typeId === appItem.typeId;
    });
    if (folderElement) {
      this.updateLayoutInfoByAppInfo(folderElement, appItem, BusinessType.BUSINESS_BASIC_DESKTOP, isOperateDb);
      FolderManager.getInstance().updateFolderItems('updateIfNewInstalledApp', folderItem, [appItem]);
      return true;
    }
    return false;
  }

  /**
   * 更新新下载的应用信息
   *
   * @param itemInLayout 布局中item
   * @param appInfo 新的item信息
   * @param label 业务标识
   * @param isOperateDb true需要数据库操作，false不需要
   */
  updateLayoutInfoByAppInfo(itemInLayout: GridLayoutItemInfo, appInfo: GridLayoutItemInfo, label: string,
    isOperateDb: boolean = true): void {
    if (CheckEmptyUtils.isEmpty(itemInLayout) || CheckEmptyUtils.isEmpty(appInfo)) {
      log.showWarn('updateLayoutInfoByAppInfo error as the item is null');
      return;
    }
    if (itemInLayout.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      log.showInfo('item type is shortCut icon');
      return;
    }
    log.showWarn(`updateLayoutInfoByAppInfo update item %{public}s from %{public}s db: %{public}s`,
      appInfo.bundleName, label, isOperateDb);

    let isUpdate: boolean = !GridLayoutUtil.isAppInstalled(itemInLayout);
    itemInLayout.appStatus = AppStatus.INSTALLED;

    itemInLayout.badgeNumber = appInfo.badgeNumber;
    itemInLayout.moduleName = appInfo.moduleName;
    itemInLayout.abilityName = appInfo.abilityName;
    itemInLayout.keyName = appInfo.keyName;
    itemInLayout.appIconId = appInfo.appIconId;
    itemInLayout.appLabelId = appInfo.appLabelId;
    itemInLayout.isUninstallAble = appInfo.isUninstallAble;
    itemInLayout.isSystemApp = appInfo.isSystemApp;
    itemInLayout.appIndex = appInfo.appIndex;
    itemInLayout.appName = appInfo.appName;
    itemInLayout.iconResource = undefined;

    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.insertNewInstalledAppCallBack(itemInLayout);
      } catch (error) {
        log.showError('updateLayoutInfoByAppInfo with error %{public}s', error.message);
      }
    }
  }

  /**
   * 更新桌面布局大小设置
   *
   * @param gridConfig 布局大小config
   * @param label 业务标识
   * @param isOuter 是否是外屏
   */
  updateLayoutDescriptionRowAndColumn(gridConfig: GridLayoutConfig, isPad: boolean, label: string,
    isOuter?: boolean): void {
    if (CheckEmptyUtils.isEmpty(gridConfig) || gridConfig.column <= 0 || gridConfig.row <= 0) {
      log.warn(`the gridconfig is error`);
      return;
    }
    log.showInfo(`updateLayoutDescriptionRowAndColumn with row %{public}d col: %{public}d from %{public}s`,
      gridConfig.row, gridConfig.column, label);
    let gridLayoutInfo = this.layoutCacheData.getGridLayoutInfo(isOuter);
    gridLayoutInfo.layoutDescription.column = gridConfig.column;
    gridLayoutInfo.layoutDescription.row = gridConfig.row;
    this.layoutCacheData.setGridLayoutInfo(gridLayoutInfo, isOuter);
  }

  /**
   * 更新布局卡片中缓存数据
   *
   * @param formInfoList 卡片列表
   * @param label 业务标识
   */
  updateFormsCacheInfoByFormList(formInfoList: GridLayoutItemInfo[], label: string, isOuter?: boolean): void {
    if (CheckEmptyUtils.isEmptyArr(formInfoList)) {
      return;
    }
    log.showWarn(`updateFormsCacheInfoByFormList form size %{public}d from %{public}s`, formInfoList.length, label,
      isOuter);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    this.updateFormsCacheByFormList(formInfoList, gridLayoutItemList);
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, isOuter);
    if (this.layoutCacheData.isPad()) {
      let gridLayoutItemListRotate: GridLayoutItemInfo[] = this.layoutCacheData.getRotateLayoutInfo();
      this.updateFormsCacheByFormList(formInfoList, gridLayoutItemListRotate);
    }
  }

  private updateFormsCacheByFormList(formInfoList: GridLayoutItemInfo[], gridLayoutItemList: GridLayoutItemInfo[]): void {
    let formList: GridLayoutItemInfo[] = gridLayoutItemList.filter(item => item.typeId === CommonConstants.TYPE_CARD);
    let formStackList: GridLayoutItemInfo[] = gridLayoutItemList.filter(item => item.typeId === CommonConstants.TYPE_FORM_STACK);
    formStackList?.forEach(formStack => {
      if (formStack.layoutInfo) {
        formList = formList?.concat(formStack.layoutInfo[0]);
      }
    });
    for (const formItem of formInfoList) {
      if (CheckEmptyUtils.checkStrIsEmpty(formItem.cardId)) {
        continue;
      }
      let formInLayout: GridLayoutItemInfo | undefined = formList.find(item => item.typeId ===
        CommonConstants.TYPE_CARD && item.cardId === formItem.cardId);
      if (formInLayout) {
        formInLayout.appLabelId = formItem.appLabelId;
        formInLayout.isTransparent = formItem.isTransparent;
        formInLayout.formConfigAbility = formItem.formConfigAbility;
      }
    }
  }

  /**
   *更新应用快捷方式加桌上限
   *
   * @param shortcutList 加桌上限设置数组
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
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(false);
    let updateItemList: Array<GridLayoutItemInfo> = AppShortcutLimitUtils.getShortcutLimitUpdateItem(gridLayoutItemList,
      needUpdateLimitShortcutList, AppShortcutLimitSourceType.GRID_SOURCE);
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, false);

    if (CheckEmptyUtils.isEmptyArr(updateItemList)) {
      log.showWarn('setShortcutLimit: needUpdateShortcutList is empty');
      return resultCode;
    }
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
   * 根据列表更新应用缓存
   *
   * @param appInfoList 应用列表
   * @param label 业务标识
   * @param isOuter 是否是外屏
   */
  updateAppCacheInfoByAppList(appInfoList: GridLayoutItemInfo[], label: string, isOuter?: boolean): void {
    if (CheckEmptyUtils.isEmptyArr(appInfoList)) {
      return;
    }
    log.showInfo(`updateAppCacheInfoByAppList form size %{public}d from %{public}s`, appInfoList.length, label);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    for (const appItem of appInfoList) {
      let appItemInLayout: GridLayoutItemInfo | undefined = gridLayoutItemList
        .find(item => item.typeId === CommonConstants.TYPE_APP && item.keyName === appItem.keyName);
      if (appItemInLayout) {
        appItemInLayout.appName = appItem.appName;
        appItemInLayout.appIconId = appItem.appIconId;
        appItemInLayout.appLabelId = appItem.appLabelId;
        appItemInLayout.isSystemApp = appItem.isSystemApp;
        appItemInLayout.isUninstallAble = appItem.isUninstallAble;
        appItemInLayout.applicationName = appItem.applicationName;
        appItemInLayout.applicationLabelId = appItem.applicationLabelId;
        appItemInLayout.installTime = appItem.installTime;
        appItemInLayout.appStatus = AppStatus.INSTALLED;
      }
    }
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, isOuter);
  }

  /**
   * 检查和删除不在文件和文件夹中的应用
   *
   * @param desktopFiles 文件列表
   * @param label 业务标识
   * @param callBack 业务回调操作
   */
  checkAndDeleteNotInFileAndFolder(desktopFiles: DesktopFileInfo[], updatedFileItems: GridLayoutItemInfo[],
    deletedItems: GridLayoutItemInfo[], label: string): void {
    log.showInfo(`checkAndDeleteNotInFileAndFolder with fileInfo size ${desktopFiles.length} from ${label}`);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    const oldLength = gridLayoutItemList.length;
    gridLayoutItemList = gridLayoutItemList.filter((item: GridLayoutItemInfo) =>
    this.isFileInDesktopFiles(desktopFiles, updatedFileItems, deletedItems, item));
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList);
    if (gridLayoutItemList.length < oldLength) {
      // 删除时更新isFirstRotate
      LauncherLayoutCacheUtil.changeLazyRotateSettings(gridLayoutItemList);
    }
  }

  private isFileInDesktopFiles(desktopFiles: DesktopFileInfo[], updatedFileItems: GridLayoutItemInfo[],
    deletedItems: GridLayoutItemInfo[], fileItem: GridLayoutItemInfo): boolean {
    if (fileItem.typeId !== CommonConstants.TYPE_FILE_FOLDER &&
      fileItem.typeId !== CommonConstants.TYPE_REGION_FOLDER) {
      return true;
    }
    for (const fileInfo of desktopFiles) {
      if (fileItem.ino !== fileInfo.ino) {
        continue;
      }
      log.showInfo(`layoutCacheData fileItem: ${fileItem.ino}, appIconId: ${fileItem.appIconId}`);
      // update if file or folder change
      let isNeedUpdate: boolean = GridLayoutUtil.isFileFolderItemModified(fileInfo, fileItem);
      if (isNeedUpdate) {
        fileItem.appIconId = fileInfo.thumbnail ?? 0;
        fileItem.fileFolderName = fileInfo.fileName;
        fileItem.uri = fileInfo.uri;
        fileItem.size = fileInfo.size;
        fileItem.ctime = fileInfo.ctime;
        fileItem.mtime = fileInfo.mtime;
        if (fileItem.typeId === CommonConstants.TYPE_REGION_FOLDER) {
          fileItem.infoName = fileInfo.fileName;
          fileItem.folderName = fileInfo.fileName;
          fileItem.uri = fileInfo.uri;
        }
        updatedFileItems.push(fileItem);
      }
      return true;
    }
    if (fileItem.typeId === CommonConstants.TYPE_FILE_FOLDER) {
      RdbStoreManager.getInstance().deleteFileFolderItem(fileItem.ino ?? '');
    }
    deletedItems.push(fileItem);
    return false;
  }

  /**
   * 更新文件夹中应用缓存信息
   *
   */
  updateAppStatusInFolderByInstalledApps(callback: (info: GridLayoutItemInfo) => void): void {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    let folderList: GridLayoutItemInfo[] = gridLayoutItemList.filter(item => item.typeId === CommonConstants.TYPE_FOLDER);
    folderList.forEach((info: GridLayoutItemInfo) => {
      callback?.(info);
    });
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList);
  }

  /**
   * 更新一个应用的布局信息
   *
   * @param item 更新的应用信息
   * @param label 业务标识
   * @param isOperateDb isNeedOperationDb true需要数据库操作，false不需要
   * @returns 是否更新成功
   */
  updateOneAppLayoutInfo(item: GridLayoutItemInfo, label: string, isOperateDb: boolean = true, isOuter?: boolean): boolean {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showWarn('updateOneAppLayoutInfo error as the item is null');
      return false;
    }
    log.showWarn('updateOneAppLayoutInfo bundleName %{public}s from %{public}s, db: %{public}s', item.bundleName,
      label, isOperateDb);
    let downloadInfo: DownloadInfoItem = {
      bundleName: item.bundleName,
      appStatus: item.appStatus,
      iconResource: item.iconResource,
      appIndex: item.appIndex,
      intent: item.intent ?? ''
    };
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    log.showInfo(`item.keyName: ${item.bundleName + item.abilityName + item.moduleName + item.appIndex}`);
    let findInDesktop = this.findAndReplaceAppByKeyname(gridLayoutItemList, item.keyName ?
      item.keyName : AppItemInfo.getKeyName(item), item);
    if (!findInDesktop && item.oldBundleNames && !CheckEmptyUtils.isEmptyArr(item.oldBundleNames)) {
      log.showInfo('updateOneAppLayoutInfo oldBundleNames %{public}s ', item.oldBundleNames[0]);
      findInDesktop = this.findAndReplaceAppByKeyname(gridLayoutItemList, item.oldBundleNames[0] + item.appIndex, item);
    }
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, isOuter);

    if (findInDesktop && isOperateDb) {
      try {
        LauncherLayoutCacheUtil.updateDownloadAppCallBack(downloadInfo);
      } catch (error) {
        log.showError('updateOneAppLayoutInfo with error %{public}s', error.message);
      }
    }
    log.showWarn('replacesInstalledAppInfo %{public}s findInDesktop: %{public}s', item.keyName, findInDesktop);
    return findInDesktop;
  }

  private findAndReplaceAppByKeyname(gridLayoutItemList: GridLayoutItemInfo[], keyName: string,
    item: GridLayoutItemInfo): boolean {
    let findInDesktop: boolean = false;
    for (let i = 0; i < gridLayoutItemList.length; i++) {
      if (gridLayoutItemList[i].typeId === CommonConstants.TYPE_APP &&
        gridLayoutItemList[i].keyName === keyName) {
        findInDesktop = true;
        this.updateGridLayoutItem(item, gridLayoutItemList[i]);
        break;
      } else if (gridLayoutItemList[i].typeId === CommonConstants.TYPE_FOLDER) {
        findInDesktop = this.replaceItemInFolder(gridLayoutItemList[i], keyName, item);
        if (findInDesktop) {
          break;
        }
      }
    }
    return findInDesktop;
  }

  private replaceItemInFolder(folderItem: GridLayoutItemInfo, keyName: string, item: GridLayoutItemInfo): boolean {
    let inFolderIndex: number =
      folderItem.layoutInfo?.flat().findIndex(itemInFolder => itemInFolder.keyName === keyName) ?? -1;
    if (folderItem.layoutInfo && inFolderIndex !== -1) {
      const isFolderOpenLayout4x4: boolean =
        FolderModel.getInstance().getFolderLayoutInOpen() === FolderLayoutInOpen.FOLDER_OPEN_LAYOUT_4x4;
      let size: number = isFolderOpenLayout4x4 ? FolderConstants.NUM_4X4_OPEN_FOLDER_ICON_PRE_PAGE :
      FolderConstants.NUM_3X4_OPEN_FOLDER_ICON_PRE_PAGE;
      //计算在第几页第几个
      log.showInfo('findAndReplaceAppByKeyname size %{public}d', size);
      const page: number = Math.floor(inFolderIndex / size);
      const appIndex: number = inFolderIndex % size;
      this.updateGridLayoutItem(item, folderItem.layoutInfo[page][appIndex]);
      FolderManager.getInstance().updateFolderItems('findAndReplaceAppByKeyname', folderItem, [item]);
      return true;
    }
    return false;
  }

  private updateGridLayoutItem(item: GridLayoutItemInfo, gridLayoutItem: GridLayoutItemInfo): void {
    if (!item.iconResource) {
      item.iconResource = gridLayoutItem.iconResource;
    }
    item.container = gridLayoutItem.container;
    ObjectCopyUtil.simpleClone(item, gridLayoutItem);
    log.showInfo(`updateGridLayoutItem: ${JSON.stringify(gridLayoutItem)}`);
  }

  /**
   * 根据id批量更新item的位置，包括行、列、页
   *
   * @param updateItems 更新的item信息
   * @param label 业务的标识
   * @param isDrag 是否是拖拽场景
   * @param isOperateDb true需要数据库操作，false不需要
   */
  updateGridLayoutItemsPositionById(updateItems: GridLayoutItemInfo[], label: string, isDrag: boolean = true,
    isOperateDb: boolean = true, isOuter: boolean = false): void {
    if (CheckEmptyUtils.isEmptyArr(updateItems)) {
      log.showWarn('updateGridLayoutItemsPositionById failure as the updateItems is null from %{public}s, db: %{public}s',
        label, isOperateDb);
      return;
    }
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    const map: Map<string, GridLayoutItemInfo> = new Map();
    updateItems.forEach((value: GridLayoutItemInfo) => map.set(GridLayoutUtil.generateUniqueKey(value, isOuter
      ), value));
    let updateInfo: GridLayoutItemInfo[] = [];
    gridLayoutItemList.forEach((value: GridLayoutItemInfo) => {
      const updateItem: GridLayoutItemInfo | undefined = map.get(GridLayoutUtil.generateUniqueKey(value, isOuter));
      if (updateItem && (!isDrag ||
        (value.row !== updateItem.row || value.column !== updateItem.column || value.page !== updateItem.page))) {
        let isItemDragOverPage: boolean = this.isOverPageDragForRotate(value, updateItem);
        value.row = updateItem.row;
        value.column = updateItem.column;
        value.page = updateItem.page;
        if (isItemDragOverPage) {
          value = LauncherLayoutCacheUtil.updateListIfLazyRotateMode([value], gridLayoutItemList, 'updateGridLayoutItemsPositionById')[0];
        }
        if (CheckEmptyUtils.isEmpty(value)) {
          log.showWarn(`updateGridLayoutItemsPositionById return cannot find rotate positon!`);
          return;
        }
        this.updateItemPosition(value, updateItem);
        updateInfo.push(value);
      }
    });
    if (label === BusinessType.BUSINESS_DRAG && (!LauncherLayoutCacheUtil.getIsFirstRotate() ||
      LauncherLayoutCacheUtil.getSuperFoldLazyRotate())) {
      LauncherLayoutCacheUtil.changeLazyRotateSettings(gridLayoutItemList);
      updateInfo = LauncherLayoutCacheUtil.getLazyRotateChangeItemsForCache(updateInfo);
      LauncherLayoutCacheUtil.getLazyRotateChangeItemsForCache(updateItems);
    }
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, isOuter);
    log.showWarn(`updateGridLayoutItemsPositionById item length ${updateItems.length}` +
      ` update length ${updateInfo.length} from ${label}, isOuter = ${isOuter}`);
    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.updateItemToDesktopCallBack(updateItems, isOuter);
      } catch (error) {
        log.showError(`updateGridLayoutItemsPositionById with error ${error.message}`);
      }
    }
  }

  private updateItemPosition(updateInfo: GridLayoutItemInfo, updateItem: GridLayoutItemInfo): void {
    if (LauncherLayoutCacheUtil.getIsFirstRotate()) {
      return;
    }
    updateItem.landscapeRow = updateInfo.landscapeRow;
    updateItem.landscapeColumn = updateInfo.landscapeColumn;
    updateItem.landscapePage = updateInfo.landscapePage;
    updateItem.portraitRow = updateInfo.portraitRow;
    updateItem.portraitColumn = updateInfo.portraitColumn;
    updateItem.portraitPage = updateInfo.portraitPage;
  }


  private isOverPageDragForRotate(dragItem: GridLayoutItemInfo, updateItem: GridLayoutItemInfo): boolean {
    return !LauncherLayoutCacheUtil.getIsFirstRotate() && dragItem.page !== updateItem.page;
  }

  /**
   * 整体更新gridLayoutItemList
   *
   * @param updateItems 更新的item信息
   * @param label 业务的标识
   * @param isOperateDb true需要数据库操作，false不需要
   */
  updateGridLayoutItems(updateItems: GridLayoutItemInfo[], label: string, isOperateDb: boolean = true): void {
    if (CheckEmptyUtils.isEmptyArr(updateItems)) {
      log.showWarn('updateGridLayoutItems failure as the updateItems is null from %{public}s, db: %{public}s',
        label, isOperateDb);
      return;
    }
    if (label === BusinessType.BUSINESS_BASIC_DESKTOP && LauncherLayoutCacheUtil.getIsLazyRotate() &&
      DeviceHelper.isSuperFoldMachine()) {
      // 右键排序业务适配双缓存
      updateItems = LauncherLayoutCacheUtil.getLazyRotateChangeItemsForCache(updateItems);
      LauncherLayoutCacheUtil.changeLazyRotateSettings(updateItems);
    }
    this.layoutCacheData.updateLayoutListCache(updateItems);
    log.showWarn(`updateGridLayoutItems item length ${updateItems.length} from ${label}`);
    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.updateItemToDesktopCallBack(updateItems);
      } catch (error) {
        log.showError(`updateGridLayoutItems with error ${error.message}`);
      }
    }
  }

  /**
   * 查询桌面对应页数的所有信息
   *
   * @param pageIndex 桌面页数
   * @returns 桌面对应页数的所有信息
   */
  public selectGridLayoutItemsByPage(pageIndex: number): GridLayoutItemInfo[] {
    return this.layoutCacheData.getGridLayoutItemList().filter((value: GridLayoutItemInfo) => value.page === pageIndex);
  }

  /**
   * 查询桌面应用信息包括文件夹
   *
   * @param bundleName 应用包名
   * @returns 桌面应用信息
   */
  public isBundleNameExistInDeskTopOrDock(bundleName: string): boolean {
    log.showInfo('isBundleNameExistInDeskTopOrDock in');
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    let findInDesktop: boolean = false;
    for (let i = 0; i < gridLayoutItemList.length; i++) {
      if (gridLayoutItemList[i].typeId === CommonConstants.TYPE_APP &&
        gridLayoutItemList[i].bundleName === bundleName) {
        findInDesktop = true;
        break;
      } else if (gridLayoutItemList[i].typeId === CommonConstants.TYPE_FOLDER) {
        let inFolderIndex: number = -1;
        inFolderIndex =
          gridLayoutItemList[i].layoutInfo?.flat().
          findIndex(itemInFolder => itemInFolder.bundleName === bundleName) ?? -1;
        if (inFolderIndex !== -1) {
          findInDesktop = true;
          break;
        }
      }
    }
    log.showInfo('LaunchLayoutCacheManager::findInDesktop: %{public}s', findInDesktop);
    if (!findInDesktop) {
      let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      if (CheckEmptyUtils.isEmptyArr(residentList)) {
        log.showInfo('isBundleNameExistInDeskTopOrDock residentList is empty');
        return false;
      }
      let appInDockIndex: number = residentList.findIndex(item => {
        if (item.itemType === CommonConstants.TYPE_APP) {
          return item.bundleName === bundleName;
        }
        if (item.itemType === CommonConstants.TYPE_FOLDER) {
          return item.layoutInfo?.flat().findIndex(item => item.bundleName === bundleName);
        }
        return false;
      });
      log.showInfo('LaunchLayoutCacheManager::isBundleNameExistInDeskTopOrDock: %{public}d', appInDockIndex);
      return appInDockIndex !== CommonConstants.INVALID_VALUE;
    }
    return findInDesktop;
  }

  /**
   * 布局重排
   *
   * @param callBack 业务操作回调
   * @param isOuter 是否是外屏
   * @returns 需要重新找位的应用列表
   */
  reArrangeLayoutInfo(desktopModel: number, isOuter?: boolean): GridLayoutItemInfo[] {
    let idx = 0;

    // 卡片重排前进行脏卡校验，若为脏卡直接从布局中删除，极限场景（80张卡）耗时<5ms
    let deleteForms: GridLayoutItemInfo[] = [];
    let gridLayoutList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter).filter(item => {
      if (item.typeId === CommonConstants.TYPE_CARD && !FormCommonUtil.isFormValid(item)) {
        log.showError(`card ${item.bundleName}-${item.cardName} not installed, delete it!`);
        deleteForms.push(item);
        return false;
      }
      return true;
    });
    if (deleteForms.length > 0) {
      LauncherLayoutCacheUtil.deleteLayoutInfoById(deleteForms, isOuter);
    }

    for (let i = 0; i < gridLayoutList.length; i++) {
      if (desktopModel === DesktopLayoutState.SIMPLE_LAUNCHER_MODEL &&
        gridLayoutList[i].typeId === CommonConstants.TYPE_CARD) {
        gridLayoutList[i].area = CommonConstants.SIMPLE_MODEL_CARD_SIZE;
      }
      while (idx < i && (gridLayoutList[i].typeId === CommonConstants.TYPE_FOLDER ||
        gridLayoutList[i].typeId === CommonConstants.TYPE_CARD ||
        gridLayoutList[i].typeId === CommonConstants.TYPE_REGION_FOLDER)) {
        if (gridLayoutList[idx].typeId !== CommonConstants.TYPE_FOLDER &&
          gridLayoutList[idx].typeId !== CommonConstants.TYPE_CARD &&
          gridLayoutList[idx].typeId !== CommonConstants.TYPE_REGION_FOLDER) {
          let tmpInfo = gridLayoutList[i];
          gridLayoutList[i] = gridLayoutList[idx];
          gridLayoutList[idx] = tmpInfo;
        }
        idx++;
      }
    }

    let layoutDescription: LayoutDescription = this.layoutCacheData.getGridLayoutInfo(isOuter).layoutDescription;
    let duplicateElements: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.filterDuplicateElement(gridLayoutList, layoutDescription);
    let deleteElements: GridLayoutItemInfo[] = [];
    // 缓存中清除重复位置元素
    gridLayoutList = gridLayoutList.filter(item => {
      if (duplicateElements.indexOf(item) >= 0) {
        deleteElements.push(item);
        return false;
      }
      return true;
    });
    log.showWarn(`the duplicate list size ${deleteElements.length}, gridLayoutList size ${gridLayoutList.length}`);
    this.layoutCacheData.updateLayoutListCache(gridLayoutList, isOuter);
    return deleteElements;
  }

  /**
   * 根据页签区域大小获取应用信息
   *
   * @param pageNum 页签
   * @param areaNum 区域
   * @returns 过滤后的应用信息
   */
  selectItemListByPageAndArea(pageNum: number | undefined, areaNum: number[] | undefined): GridLayoutItemInfo[] {
    let gridLayoutItemList = this.layoutCacheData.getGridLayoutItemList(false);
    if (pageNum === undefined) {
      log.showWarn('selectItemListByPageAndArea failure as no page number provided');
      return [];
    }
    if (!areaNum || CheckEmptyUtils.isEmptyArr(areaNum) || areaNum.length !== 2) {
      log.showWarn('selectItemListByPageAndArea failure as the value of areaNum is invalid');
      return [];
    }
    return gridLayoutItemList.filter(gridLayoutItem => gridLayoutItem.page === pageNum &&
      gridLayoutItem.area?.[0] === areaNum[0] && gridLayoutItem.area[1] === areaNum[1]);
  }

  /**
   * 从桌面缓存中查找对象
   * @param bundleName
   * @param appIndex
   * @param typeId
   * @param isOuter
   * @returns
   */
  public findAppFromCache(bundleName: string, appIndex: number, typeId: number,
    isOuter?: boolean): GridLayoutItemInfo | undefined {
    let gridLayoutItemList = this.getAllGridLayoutItemList(BusinessType.BUSINESS_BASIC_DESKTOP, isOuter);
    if (!gridLayoutItemList) {
      return undefined;
    }
    // 在桌面上查找
    let findApp = gridLayoutItemList.find((item) => item.bundleName === bundleName && item.appIndex === appIndex &&
      item.typeId === typeId);
    if (findApp) {
      return findApp;
    }
    // 桌面文件夹中查找
    for (let i = 0; i < gridLayoutItemList.length; i++) {
      if (gridLayoutItemList[i].typeId === CommonConstants.TYPE_FOLDER) {
        let findApp =
          gridLayoutItemList[i].layoutInfo?.flat().find(item => item.bundleName === bundleName &&
            item.appIndex === appIndex && item.typeId === typeId);
        if (findApp) {
          return findApp;
        }
      }
    }
    return findApp;
  }

  getAllSameBundleNameAppItem(bundleName: string): GridLayoutItemInfo[] {
    let desktopLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(false);
    return this.getAllSameBundleNameAppItemGivenCache(bundleName, desktopLayoutItemList);
  }

  protected getAllSameBundleNameAppItemGivenCache(bundleName: string,
    desktopLayoutItemList: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    log.showInfo(`getAllSameBundleNameAppItem bundleName: ${bundleName} start`);
    let result: GridLayoutItemInfo[] = [];
    let dockLayoutItemList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    dockLayoutItemList?.forEach(dockItem => {
      let gridItemInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      if (CheckEmptyUtils.isEmpty(gridItemInfo)) {
        log.showWarn('gridItemInfo is empty');
        return;
      }
      if (gridItemInfo.typeId === CommonConstants.TYPE_APP && gridItemInfo.bundleName === bundleName) {
        result.push(gridItemInfo);
      } else if (gridItemInfo.typeId === CommonConstants.TYPE_FOLDER) {
        let sameAppList: GridLayoutItemInfo[] = gridItemInfo.layoutInfo?.flat().filter(itemInFolder =>
          itemInFolder && itemInFolder.typeId === CommonConstants.TYPE_APP &&
          itemInFolder.bundleName === bundleName) ?? [];
        sameAppList.forEach(sameApp => {
          result.push(sameApp);
        });
      }
    });
    desktopLayoutItemList.forEach(item => {
      if (CheckEmptyUtils.isEmpty(item)) {
        log.showWarn('desktopLayoutItemList item is empty');
        return;
      }
      if (item.typeId === CommonConstants.TYPE_APP && item.bundleName === bundleName) {
        result.push(item);
      } else if (item.typeId === CommonConstants.TYPE_FOLDER) {
        let sameAppList: GridLayoutItemInfo[] = item.layoutInfo?.flat().filter(itemInFolder =>
          itemInFolder && itemInFolder.typeId === CommonConstants.TYPE_APP &&
          itemInFolder.bundleName === bundleName) ?? [];
        sameAppList.forEach(sameApp => {
          result.push(sameApp);
        });
      }
    });
    this.cacheAppCenterList?.forEach(item => {
      if (CheckEmptyUtils.isEmpty(item)) {
        log.showWarn('appCenterLayoutItemList item is empty');
        return;
      }
      if (item.typeId === CommonConstants.TYPE_APP && item.bundleName === bundleName) {
        let gridItemInfo: GridLayoutItemInfo = GridLayoutUtil.appItemInfoToGridLayout(item);
        result.push(gridItemInfo);
      }
    });
    log.showInfo(`getAllSameBundleNameAppItem bundleName: ${bundleName}, result: ${JSON.stringify(result)}`);
    return result.sort((a, b) => (a.appIndex ?? 0) - (b.appIndex ?? 0));
  }

  public registerAppcenter(appCenterLayoutItemList: AppItemInfo[]): void {
    this.cacheAppCenterList = appCenterLayoutItemList;
  }

  /**
   * 查找桌面所有缓存中快捷方式的信息
   * @param bundleName 快捷方式包名
   * @returns GridLayoutItemInfo[] 同一个bundleName下桌面所有快捷方式
   */
  public getAllSameBundleNameShortcut(bundleName: string): GridLayoutItemInfo[] {
    let desktopLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(false);
    return this.getAllSameBundleNameShortcutCache(bundleName, desktopLayoutItemList);
  }

  protected getAllSameBundleNameShortcutCache(bundleName: string,
    desktopLayoutItemList: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    log.showInfo(`getAllSameBundleNameShortcut bundleName: ${bundleName} start`);
    let result: GridLayoutItemInfo[] = [];
    let dockLayoutItemList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    dockLayoutItemList?.forEach(dockItem => {
      let gridItemInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      if (CheckEmptyUtils.isEmpty(gridItemInfo)) {
        log.showWarn('gridItemInfo is empty');
        return;
      }
      if (gridItemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON && gridItemInfo.bundleName === bundleName) {
        result.push(gridItemInfo);
      } else if (gridItemInfo.typeId === CommonConstants.TYPE_FOLDER) {
        let sameAppList: GridLayoutItemInfo[] = gridItemInfo.layoutInfo?.flat().filter(itemInFolder =>
          itemInFolder && itemInFolder.typeId === CommonConstants.TYPE_SHORTCUT_ICON &&
          itemInFolder.bundleName === bundleName) ?? [];
        sameAppList.forEach(sameApp => {
          result.push(sameApp);
        });
      }
    });
    desktopLayoutItemList.forEach(item => {
      if (CheckEmptyUtils.isEmpty(item)) {
        log.showWarn('desktopLayoutItemList item is empty');
        return;
      }
      if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON && item.bundleName === bundleName) {
        result.push(item);
      } else if (item.typeId === CommonConstants.TYPE_FOLDER) {
        let sameAppList: GridLayoutItemInfo[] = item.layoutInfo?.flat().filter(itemInFolder =>
          itemInFolder && itemInFolder.typeId === CommonConstants.TYPE_SHORTCUT_ICON &&
          itemInFolder.bundleName === bundleName) ?? [];
        sameAppList.forEach(sameApp => {
          result.push(sameApp);
        });
      }
    });
    this.cacheAppCenterList?.forEach(item => {
      if (CheckEmptyUtils.isEmpty(item)) {
        log.showWarn('appCenterLayoutItemList item is empty');
        return;
      }
      if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON && item.bundleName === bundleName) {
        let gridItemInfo: GridLayoutItemInfo = GridLayoutUtil.appItemInfoToGridLayout(item);
        result.push(gridItemInfo);
      }
    });
    log.showInfo(`getAllSameBundleNameAppItem bundleName: ${bundleName}, result: ${JSON.stringify(result)}`);
    return result;
  }

  /**
   * 遍历桌面应用及桌面文件夹获取应用信息
   * @param keyName 应用的唯一标记
   * @param folderId 文件夹的folderId
   * @returns index=0 表示应用相关信息  , index=1表示应用所在文件夹相关信息
   */
  public getDesktopAppInfo(keyName: string, typeIds: StartType[], folderId?: string, page?: number): GridLayoutItemInfo[] {
    log.showInfo(`getDesktopAppByKeyNameAndFolder keyName:${keyName}, folderId:${folderId}`);
    const gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();

    for (let appOrFolder of gridLayoutItemList) {
      if (!appOrFolder) {
        continue;
      }
      if (page !== undefined && appOrFolder.page !== page) {
        continue;
      }
      if (appOrFolder.keyName === keyName && !folderId && appOrFolder?.typeId !== undefined &&
        typeIds.includes(appOrFolder.typeId)) {
        log.showInfo(`appInfo keyName:${keyName}, apppage:${appOrFolder.page},` +
          ` approw:${appOrFolder.row}, appcolumn:${appOrFolder.column}`);
        return [appOrFolder];
      } else if (appOrFolder.typeId === CommonConstants.TYPE_FOLDER &&
        (!folderId || appOrFolder.folderId === folderId)) {
        const result = this.getAppInfoInFolder(appOrFolder, typeIds, keyName);
        if (!CheckEmptyUtils.isEmptyArr(result)) {
          return result;
        }
      }
    }
    return [];
  }

  /**
   *
   * 遍历桌面应用及桌面文件夹获取item对象
   */
  public getGridLayoutItemList(isOuter?: boolean): GridLayoutItemInfo[] {
    return this.getAllGridLayoutItemList('DeskTop', isOuter);
  }

  /**
   * 遍历dock应用及dock文件夹获取应用信息
   * @param keyName 应用的唯一标记
   * @param folderId 文件夹的folderId
   * @returns index=0 表示应用相关信息  , index=1表示应用所在文件夹相关信息
   */
  public getDockAppInfo(keyName: string, typeIds: StartType[], folderId?: string): GridLayoutItemInfo[] {
    log.showInfo(`getDockAppByKeyNameAndFolder keyName:${keyName}, folderId:${folderId}`);
    let dockItems = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    for (let appOrFolder of dockItems) {
      if (!appOrFolder) {
        continue;
      }
      if (appOrFolder.keyName === keyName && !folderId && appOrFolder?.typeId !== undefined &&
        typeIds.includes(appOrFolder.typeId)) {
        let gridItem = new GridLayoutItemInfo();
        gridItem.fillInfoWithAppItem(appOrFolder);
        log.showInfo(`appInfo keyName:${keyName}, apppage:${appOrFolder.page},` +
          ` approw:${appOrFolder.row}, appcolumn:${appOrFolder.column}`);
        return [gridItem];
      } else if (appOrFolder.typeId === CommonConstants.TYPE_FOLDER &&
        (!folderId || appOrFolder?.keyName === folderId)) {
        // folderId有值且appOrFolder?.keyName !== folderId，无需向下遍历
        let gridItem = new GridLayoutItemInfo();
        gridItem.fillInfoWithAppItem(appOrFolder);
        gridItem.folderId = appOrFolder?.keyName;
        gridItem.layoutInfo = appOrFolder?.layoutInfo;
        log.showInfo('appInfo keyName:%{public}s, folderpage:%{public}d, folderrow:%{public}d, ' +
          'foldercolumn:%{public}d, area1:%{public}d, area2:%{public}d, folderId:%{public}s', keyName,
          gridItem.page, gridItem.row, gridItem.column, gridItem.area?.[0], gridItem.area?.[1], gridItem.folderId);
        const result = this.getAppInfoInFolder(gridItem, typeIds, keyName);
        if (!CheckEmptyUtils.isEmptyArr(result)) {
          return result;
        }
      }
    }
    return [];
  }

  /**
   * 遍历指定文件夹获取应用信息
   * @param gridItem 指定文件夹的数据
   * @param keyName 应用的唯一标记
   * @returns index=0 表示应用相关信息  , index=1表示应用所在文件夹相关信息
   */
  private getAppInfoInFolder(gridItem: GridLayoutItemInfo,
                             typeIds: StartType[], keyName: string): GridLayoutItemInfo[] {
    log.showInfo(`gridItem.folderId:${gridItem.folderId}`);
    if (!gridItem.layoutInfo || CheckEmptyUtils.isEmptyArr(gridItem.layoutInfo)) {
      return [];
    }
    let folderIndex: number = -1;
    for (let layoutInfoElement of gridItem.layoutInfo) {
      if (CheckEmptyUtils.isEmptyArr(layoutInfoElement)) {
        continue;
      }
      for (let layoutInfoElementElement of layoutInfoElement) {
        if (CheckEmptyUtils.isEmpty(layoutInfoElementElement)) {
          continue;
        }
        folderIndex ++;
        if (layoutInfoElementElement.keyName === keyName && layoutInfoElementElement?.typeId !== undefined &&
          typeIds.includes(layoutInfoElementElement.typeId)) {
          layoutInfoElementElement.page = Math.floor(folderIndex / this.folderPageAppNum);
          let pageIndex = folderIndex - layoutInfoElementElement.page * this.folderPageAppNum;
          layoutInfoElementElement.row = Math.floor(pageIndex / this.folderColumn);
          layoutInfoElementElement.column = pageIndex - layoutInfoElementElement.row * this.folderColumn;
          log.showInfo('appInfo keyName:%{public}s, folderpage:%{public}d, folderrow:%{public}d, ' +
            'foldercolumn:%{public}d, apppage:%{public}d, approw:%{public}d, appcolumn:%{public}d, index:%{public}d',
            keyName, gridItem.page, gridItem.row, gridItem.column, layoutInfoElementElement.page,
            layoutInfoElementElement.row, layoutInfoElementElement.column, folderIndex);
          return [layoutInfoElementElement, gridItem];
        }
      }
    }
    return [];
  }

  /**
   * 设置展开态文件夹的参数
   * @param folderPageAppNum 一页图标数
   * @param folderColumn 一行图标数
   * @param folderRow 一列图标数
   */
  public setOpenFolderParam(folderPageAppNum: number, folderColumn: number, folderRow: number): void {
    this.folderPageAppNum = folderPageAppNum;
    this.folderColumn = folderColumn;
    this.folderRow = folderRow;
  }

  /**
   * 更新内缓存
   *
   * @param gridLayoutItemList 缓存列表
   * @returns 相同bundleName应用的所有图标
   */
  public updateCache(gridLayoutItemList: GridLayoutItemInfo[]): void {
    if (CheckEmptyUtils.isEmptyArr(gridLayoutItemList)) {
      return;
    }
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, false);
  }

  /**
   * 获取指定应用的快捷方式加桌上限数量
   *
   * @param bundleName 应用bundleName
   * @returns undefined 代表没有设置过，走系统逻辑
   */
  public getShortCountLimitByBundleName(bundleName: string): number | undefined {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(false);
    const limit : number | undefined = AppShortcutLimitUtils.getShortCountLimitByBundleName(bundleName
    , gridLayoutItemList, AppShortcutLimitSourceType.GRID_SOURCE);
    log.showWarn(`shortcutBundleName: ${bundleName} limit: ${limit}`);
    return limit;
  }

  /**
   * Get All Apps
   *
   * @returns appList
   */
  public getAllApps(): GridLayoutItemInfo[] {
    let appList:GridLayoutItemInfo[] = [];
    let allApps: GridLayoutItemInfo[] = [...this.getAllGridLayoutItemList(BusinessType.BUSINESS_FOLDER)];
    let dockLayoutItemList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();

    dockLayoutItemList?.forEach((dockItem) => {
      let gridItemInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      if (!CheckEmptyUtils.isEmpty(gridItemInfo)) {
        allApps.push(gridItemInfo);
      }
    });

    for (const item of allApps) {
      appList.push(item);
      if (item.typeId === CommonConstants.TYPE_FOLDER) {
        this.appendFolderAppsToList(item, appList);
      }
    }

    appList = appList.filter((item: GridLayoutItemInfo) => (item.typeId === CommonConstants.TYPE_APP && item.appStatus === AppStatus.INSTALLED) ||
      item.typeId === CommonConstants.TYPE_SHORTCUT_ICON);

    return appList;
  }

  /**
   * Parse Folder Info and Set App List
   *
   * @param appList appList
   * @param folderItem folderItem
   */
  public appendFolderAppsToList(folderItem: GridLayoutItemInfo, appList: GridLayoutItemInfo[]): void {
    let subItems = folderItem.layoutInfo?.flat();
    if (subItems) {
      for (const subItem of subItems) {
        if (appList.findIndex(app => app.keyName === subItem.keyName) === -1) {
          appList.push(subItem);
        }
      }
    }
  }
}