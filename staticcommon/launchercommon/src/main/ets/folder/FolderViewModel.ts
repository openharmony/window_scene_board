/**
 * Copyright (c) 2023-Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { BusinessType, CommonConstants } from '../constants/CommonConstants';
import { EventConstants } from '../constants/EventConstants';
import type { DockItemInfo } from '../bean/DockItemInfo';
import { FolderModel } from './FolderModel';
import { PageDesktopModel } from '../pagedesktop/model/PageDesktopModel';
import { RdbStoreManager } from '../db/RdbStoreManager';
import { promptAction } from '@kit.ArkUI';

import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  ObjUtil,
} from '@ohos/basicutils';
import { DeviceHelper, localEventManager, ResourceManager, } from '@ohos/frameworkwrapper';
import { desktopUtil } from '@ohos/componenthelper';
import { ResUtils, SCBScreenSessionManager, } from '@ohos/windowscene';
import { BaseViewModel } from '../base/BaseViewModel';
import type GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import GridLayoutInfoColumns from '../db/column/GridLayoutInfoColumns';
import { SettingsModel } from '../model/SettingsModel';
import GridLayoutUtil from '../utils/GridLayoutUtil';
import type { FolderAppItemInfo } from './FolderItemInfo';
import { FolderLayoutCacheManager } from '../cache/layout/FolderLayoutCacheManager';
import { FolderData } from './model/FolderData';
import { AppItemInfo, Cache2RdbHelper, ResidentLayoutCacheMgr, StyleConstants } from '../TsIndex';
import { AppCategoryInfoManager } from '../manager/AppCategoryInfoManager';
import { AppCategoryUtils } from '../utils/AppCategoryUtils';

const TAG = 'FolderViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export abstract class FolderViewModel extends BaseViewModel {
  protected readonly mSettingsModel: SettingsModel;
  protected readonly mFolderModel: FolderModel;
  protected readonly mPageDesktopModel: PageDesktopModel;
  protected readonly mFolderLayout: FolderLayoutCacheManager;
  private foldStatusChangeCallbacksInFolder: Set<Function> = new Set<Function>();

  private folderLayoutChangeCallback: Map<string, FolderLayoutChangeListener[]> = new Map();

  protected constructor() {
    super();
    this.mSettingsModel = SettingsModel.getInstance();
    this.mFolderModel = FolderModel.getInstance();
    this.mPageDesktopModel = PageDesktopModel.getInstance();
    this.mFolderLayout = FolderLayoutCacheManager.getInstance();
  }

  /**
   * 自定义拖拽多个应用进文件夹
   * 原addAppsToFolder方法中对每一个app都执行了一遍搜索桌面全局获取文件夹，搜索文件夹内全部图标以筛选被移除的图标，更新桌面图标的操作
   * 对性能影响较大，故在此将其中可抽出的方法进行抽出重写
   * @param apps 多个应用的数组
   * @param folderId 文件夹的id
   */
  public addAppsToFolder(apps: GridLayoutItemInfo[], folderId: string, isRefreshView: boolean = true,
    isOperateDb: boolean = true): void {
    // 获取桌面图标
    let appListInfo: GridLayoutItemInfo[] = this.mSettingsModel.getAppListInfo();
    // 获取文件夹
    let folderItem: GridLayoutItemInfo | undefined = this.mFolderLayout.selectGridLayoutItemByFolderId(folderId, false);
    if (!folderItem) {
      log.showInfo(`do not find the folderItem as folderId ${folderId}`);
      return;
    }
    if (FolderViewModel.isFolderFull(folderItem)) {
      log.showInfo('addOneAppToFolder folder full: ' + folderItem.folderName);
      return;
    }
    const releaseLock = Cache2RdbHelper.getInstance().addLock(CommonConstants.DRAG_RDB_EVENT, 'addAppsToFolder');
    RdbStoreManager.getInstance()
      .queryItemByInfoId(folderItem.folderId ?? '')
      .then((rdbFolderItem: GridLayoutItemInfo) => {
        log.showWarn(` query folderData ${JSON.stringify(rdbFolderItem)}`);
        if (!rdbFolderItem) {
          return;
        }
        apps.forEach(item => item.container = rdbFolderItem.id);
      })
      .catch((error: Error) => {
        log.showWarn(`get folder from rdb error:${error?.message}`);
      })
      .finally(() => {
        releaseLock?.();
      });


    let needInsertAppList: GridLayoutItemInfo[] = [];
    apps.forEach((appInfo: GridLayoutItemInfo) => {
      // 依次将拖拽选中的图标从桌面图标中移除
      appListInfo = appListInfo.filter(item => item.keyName !== appInfo.keyName);
      // 文件夹中是否已存在此图标
      let isAppExist: boolean | undefined = folderItem?.layoutInfo?.flat().
        find((item) => item.keyName === appInfo.keyName) !== undefined;
      if (isAppExist) {
        log.showInfo('not addOneAppToFolder as the app is exist in this folder');
        return;
      }
      // 更新角标
      let badgeNum: number = 0;
      if (folderItem?.badgeNumber && folderItem.badgeNumber > 0) {
        badgeNum = folderItem.badgeNumber + (appInfo.badgeNumber ?? 0);
      } else {
        badgeNum = (appInfo.badgeNumber ?? 0);
      }
      needInsertAppList.push(appInfo);
      Cache2RdbHelper.getInstance().addItem(CommonConstants.DRAG_RDB_EVENT, appInfo);
      this.mFolderLayout.updateBadgeNumberByFolderId(badgeNum, folderId, BusinessType.BUSINESS_FOLDER);
    });
    // 依次在文件夹里插入图标
    if (!folderItem.layoutInfo) {
      return;
    }
    const lastPageItems: GridLayoutItemInfo[] = folderItem.layoutInfo[folderItem.layoutInfo.length - 1];
    if (CheckEmptyUtils.isEmpty(lastPageItems)) {
      log.showInfo(`addOneAppToFolder lastPageItems empty`);
      return;
    }
    this.mFolderLayout.insertAppListToFolderByFolderId(folderId, needInsertAppList, isRefreshView, isOperateDb);
    // 更新桌面图标
    this.mSettingsModel.setAppListInfo(appListInfo);
    this.deleteAppLayoutItems(apps);
  }

  /**
   * Update Folder App Location.
   *
   * @param folderAppInfo folderAppInfo
   */
  public updateFolderAppLocation(folderAppInfo?: GridLayoutItemInfo[]): void {
    if (!folderAppInfo) {
      return;
    }
    let folderOpenColumn = FolderModel.getInstance().getFolderOpenLayout()?.column;
    let folderOpenRow = FolderModel.getInstance().getFolderOpenLayout()?.row;
    for (let i = 0; i < folderAppInfo.length; i++) {
      if (!folderOpenColumn || !folderOpenRow) {
        continue;
      }
      folderAppInfo[i].column = i % folderOpenColumn;
      folderAppInfo[i].row = Math.floor(i / folderOpenColumn % folderOpenRow);
      folderAppInfo[i].page = Math.floor(i / (folderOpenColumn * folderOpenRow));
    }
  }

  /**
   * 注册文件夹名称变更监听
   * @param info 文件夹item信息
   * @param listener 文件夹重命名监听接口实例
   */
  registerFolderLayoutChangeListener(info: GridLayoutItemInfo, listener: FolderLayoutChangeListener): void {
    if (info && info.folderId) {
      const callbacks: FolderLayoutChangeListener[] = this.folderLayoutChangeCallback.get(info.folderId) || [];
      callbacks.push(listener);
      this.folderLayoutChangeCallback.set(info.folderId, callbacks);
    }
  }

  /**
   * 反注册文件夹名称变更监听
   * @param info 文件夹item信息
   * @param listener 文件夹重命名监听接口实例
   */
  unregisterFolderLayoutChangeListener(info: GridLayoutItemInfo, listener: FolderLayoutChangeListener): void {
    if (info && info.folderId) {
      let callbacks: FolderLayoutChangeListener[] = this.folderLayoutChangeCallback.get(info.folderId) || [];
      callbacks = callbacks.filter(item => item !== listener);
      this.folderLayoutChangeCallback.set(info.folderId, callbacks);
    }
  }

  /**
   * Modify folder name.
   *
   * @param folderInfo folderInfo
   * @param isInit true indicates folder is new created
   */
  public modifyFolderName(folderInfo: GridLayoutItemInfo, isInit: boolean = false, isOperateDb: boolean = true): void {
    log.showDebug(`modifyFolderName isInit:${isInit}`);

    // 更新dock栏文件夹名称
    const residentList = this.mSettingsModel.getResidentList();
    for (const dockItem of residentList) {
      if (dockItem.typeId === CommonConstants.TYPE_FOLDER && dockItem.bundleName === folderInfo.folderId) {
        dockItem.appName = folderInfo.folderName ?? '';
        this.mSettingsModel.setResidentList(residentList);
        if (!isOperateDb) {
          continue;
        }
        this.dealRdbStoreManager(isInit, dockItem);
      }
    }
    // 通知对应文件夹名称变更
    this.renameCallback(folderInfo);
    FolderLayoutCacheManager.getInstance().updateFolderName(
      folderInfo.folderName ?? '', folderInfo.folderId ?? '', isInit, BusinessType.BUSINESS_FOLDER, isOperateDb);
    FolderData.getInstance().refreshView('modifyFolderName', folderInfo.folderId ?? '');
  }

  private dealRdbStoreManager(isInit: boolean, dockItem: DockItemInfo): void {
    if (isInit) {
      if (dockItem.layoutInfo) {
        RdbStoreManager.getInstance().insertFolderLayout(GridLayoutUtil.dockItemToGridLayout(dockItem),
          dockItem.layoutInfo.flat());
      }
    } else {
      RdbStoreManager.getInstance().updateGridInfoById(dockItem.bundleName, GridLayoutInfoColumns.INFO_NAME,
        dockItem.appName);
    }
  }

  // 通知对应文件夹名称变更
  private renameCallback(folderInfo: GridLayoutItemInfo): void {
    for (const layoutChangeCallback of this.folderLayoutChangeCallback.get(folderInfo.folderId ?? '') || []) {
      layoutChangeCallback?.rename?.(folderInfo.folderName ?? '');
    }
  }

  /**
   * 获取合成文件夹的应用的二级分类id（id个数小于等于2时，返回有效的id集合）
   *
   * @param targetItem 目标元素
   * @param dragItems 拖拽元素
   * @returns 应用二级分类id的集合
   */
  protected getAppCatIdInFolder(targetItem: GridLayoutItemInfo, dragItems: GridLayoutItemInfo[] | DockItemInfo[]):
    number[] {
    let instance = AppCategoryInfoManager.getInstance();
    let targetItemCatId = instance.readCatIdFromCache(targetItem.bundleName);
    let bundleNames = AppCategoryUtils.getBundleNameList(dragItems);
    let appCatIdList: number[] = [];
    if (targetItemCatId == null || !bundleNames || bundleNames.length === 0) {
      log.showWarn('getAppCatIdInFolder, targetItemCatId or bundleName is null');
      return appCatIdList;
    }
    let catIdSet: Set<number> = new Set();
    catIdSet.add(targetItemCatId);
    for (let bundleName of bundleNames) {
      let catId = instance.readCatIdFromCache(bundleName);
      if (catId == null) {
        log.showWarn(`bundleName = ${bundleName}, categoryId is null`);
        return appCatIdList;
      }
      catIdSet.add(catId);
      if (catIdSet.size > 2) {
        log.showInfo('the number of categoryId in folder exceeds 2');
        return appCatIdList;
      }
    }
    let dragItemsCatId: number = -1;
    if (catIdSet.size === 1) {
      dragItemsCatId = targetItemCatId;
      appCatIdList = [targetItemCatId];
    } else if (catIdSet.size === 2) {
      dragItemsCatId = Array.from(catIdSet)[1];
      appCatIdList = [targetItemCatId, dragItemsCatId];
    }
    log.showInfo(`getAppCatIdInFolder, targetItemCatId: ${targetItemCatId}, dragItemsCatId: ${dragItemsCatId}`);
    return appCatIdList;
  }

  /**
   * Generate folder name.
   *
   * @returns the folder name.
   */
  protected generateFolderName(): string {
    log.showDebug('generateFolderName start');
    const folderList = this.getAllFolderList();
    const folderNamePrefix: string = '${new_folder_name}';
    let folderName = folderNamePrefix;
    let suffixNumberList: number[] = [];
    const isNumberRegExp = new RegExp('^[1-9][0-9]*$');
    folderList.forEach((element, index, self) => {
      const suffixNumber = this.getFolderNameSuffixNumber(element.folderName ?? '', folderNamePrefix, isNumberRegExp);
      if (!Number.isNaN(suffixNumber)) {
        suffixNumberList.push(suffixNumber);
      }
    });

    const residentList = this.mSettingsModel.getResidentList();
    residentList.forEach((dockItem, index, self) => {
      if (dockItem.typeId === CommonConstants.TYPE_FOLDER) {
        const suffixNumber = this.getFolderNameSuffixNumber(dockItem.appName, folderNamePrefix, isNumberRegExp);
        if (!Number.isNaN(suffixNumber)) {
          suffixNumberList.push(suffixNumber);
        }
      }
    });

    // 去重后排序
    const uniqueSuffixNumberList = Array.from(new Set(suffixNumberList));
    uniqueSuffixNumberList.sort((suffix1: number, suffix2: number) => {
      return suffix1 - suffix2;
    });

    let nameNumber = 1;
    for (let i = 0; i < uniqueSuffixNumberList.length; i++) {
      if (uniqueSuffixNumberList[i] !== nameNumber) {
        break;
      }
      nameNumber++;
    }
    folderName = folderNamePrefix + nameNumber;
    log.showDebug(`generateFolderName folderName:${folderName}`);
    return folderName;
  }

  private getFolderNameSuffixNumber(folderName: string, folderNamePrefix: string, isNumberRegExp: RegExp): number {
    if (!folderName) {
      return Number.NaN;
    }
    if (folderName.startsWith(folderNamePrefix) && isNumberRegExp.test(folderName.substring(folderNamePrefix.length))) {
      return Number(folderName.substring(folderNamePrefix.length));
    }
    return Number.NaN;
  }

  /**
   * Get new folder name.
   *
   * @returns new folder name.
   */
  public abstract getNewFolderName(): Promise<string>;

  /**
   * Get all folders in PageDesktop.
   *
   * @returns an array contains all folders.
   */
  private getAllFolderList(): GridLayoutItemInfo[] {
    log.showDebug('getAllFolderList start');
    const folderList: GridLayoutItemInfo[] = this.mFolderLayout.selectGridLayoutItemsByType(CommonConstants.TYPE_FOLDER);
    AppStorage.setOrCreate('allFolderList', folderList);
    return folderList;
  }

  public static isFolderInCurrentPageOfDesktop(folderPage: number): boolean {
    let currentPage: number = desktopUtil.getPageIndexValue();
    if (SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()) {
      return Math.floor(currentPage / 2) === Math.floor(folderPage / 2);
    }
    return currentPage === folderPage;
  }

  /**
   * Get folder name after replace resource string.
   *
   * @returns folder name after replace i18n value.
   */
  public getRealFolderName(originFolderName: string): string {
    if (ObjUtil.isInvalid(originFolderName)) {
      log.showWarn('getRealFolderName, originFolderName is invalid');
      return originFolderName;
    }
    let isIntelFolder: boolean = originFolderName.startsWith('#');
    if (isIntelFolder) {
      let realFoldrName = AppCategoryUtils.getIntelFolderName(originFolderName);
      log.showInfo(`getRealFolderName realFoldrName: ${realFoldrName}`);
      if (!CheckEmptyUtils.checkStrIsEmpty(realFoldrName)) {
        return realFoldrName;
      }
    }
    let reg: RegExp = /^\$\{([^{}]+)\}(.*)/;
    let ret: RegExpMatchArray | null = originFolderName.match(reg);
    if (ret) {
      if (ret.length === 2) {
        return ResourceManager.getInstance().getStringByName(ret[1]);
      } else if (ret.length === 3 ) {
        return ResourceManager.getInstance().getStringByName(ret[1], parseInt(ret[2]) || 1);
      }
    }
    return originFolderName.trim();
  }

  /**
   * Delete apps in PageDesktop.
   *
   * @param appListInfo the apps to delete
   */

  public deleteAppLayoutItems(appListInfo: GridLayoutItemInfo[], folderAppInfo = [], isOuter?: boolean): void {
    for (let i = 0; i < appListInfo.length; i++) {
      this.mFolderLayout.deleteAppItemByKeyName(appListInfo[i].keyName ?? '', BusinessType.BUSINESS_FOLDER, false,
        isOuter);
    }
    // 先执行文件夹消失动效，再刷新页面
    if (this.isFolderDisappearing()) {
      setTimeout(() => {
        if (folderAppInfo.length > 0) {
          this.updateFolderAppLocation(folderAppInfo);
        }
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
      }, CommonConstants.FOLDER_MISSION_TIMEOUT);
    } else {
      if (folderAppInfo.length > 0) {
        this.updateFolderAppLocation(folderAppInfo);
      }
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_ADD_TO_FOLDER, null);
    }
  }

  public registerFolderStatusChangeListener(listener: Function): void {
    if (!listener && DeviceHelper.isFoldButNotSmallFoldProduct()) {
      return;
    }
    this.foldStatusChangeCallbacksInFolder.add(listener);
  }

  public unregisterFolderStatusChangeListener(listener: Function): void {
    if (!listener && DeviceHelper.isFoldButNotSmallFoldProduct()) {
      return;
    }
    this.foldStatusChangeCallbacksInFolder.delete(listener);
  }

  public reLayoutFolder(): void {
    this.reLayoutResident();
    this.foldStatusChangeCallbacksInFolder?.forEach((listener: Function) => {
      listener?.();
    });
  }

  private reLayoutResident(): void {
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let newResidentList: Array<DockItemInfo> = [];
    for (let i = 0; i < residentList.length; i++) {
      let mLayoutInfo = residentList[i].layoutInfo;
      if (residentList[i].typeId !== CommonConstants.TYPE_FOLDER || !mLayoutInfo || mLayoutInfo.length === 0) {
        newResidentList.push(residentList[i]);
        continue;
      }
      // 修改文件内部布局
      let folderApps: GridLayoutItemInfo[] = mLayoutInfo.flat();
      this.updateFolderAppLocation(folderApps);
      residentList[i].layoutInfo = this.translateFolderLayout(folderApps);
      newResidentList.push(residentList[i]);
      RdbStoreManager.getInstance().addInfoToFolder(residentList[i].appId ?? '', folderApps);
    }
    this.mSettingsModel.setResidentList(newResidentList);
    ResidentLayoutCacheMgr.getInstance().updateAllDockItems(TAG.concat('_reLayout'), residentList, true);
  }

  /**
   * translate appInfos to FolderLayout
   * appInfos是一维数组，folderItem.layoutInfo是二维分页
   *
   * @param {GridLayoutItemInfo[]} appInfos.
   * @return {GridLayoutItemInfo[][]} folderItem layout
   */
  public translateFolderLayout(appInfos: GridLayoutItemInfo[]): GridLayoutItemInfo[][] {
    let folderLayout: GridLayoutItemInfo[][] = [];
    let folderOpenColumn = this.mFolderModel.getFolderOpenLayout()?.column ?? 0;
    let folderOpenRow = this.mFolderModel.getFolderOpenLayout()?.row ?? 0;
    const allCount = folderOpenColumn * folderOpenRow;
    if (appInfos.length > allCount && allCount > 0) {
      let integer = Math.floor(appInfos.length / allCount);
      let remainder = appInfos.length % allCount;
      for (let i = 0; i < integer; i++) {
        folderLayout.push(appInfos.slice(i * allCount, (i + 1) * allCount));
      }
      if (remainder !== 0) {
        folderLayout.push(appInfos.slice(integer * allCount, integer * allCount + remainder));
      }
    } else {
      folderLayout = [appInfos];
    }
    return folderLayout;
  }

  /**
   * 是否在文件夹解散过程中
   */
  public isFolderDisappearing(): boolean {
    let disappearLastAppData: DisappearLastAppData | undefined = AppStorage.get('disappearLastAppData');
    let isDisappearFolderIdValid: boolean = typeof disappearLastAppData?.folderId !== 'undefined';
    let isDisappearFolderIdNotEmpty: boolean = disappearLastAppData?.folderId !== '';
    log.showInfo('isDisappearFolderIdValid = %{public}s, isDisappearFolderIdNotEmpty = %{public}s',
      isDisappearFolderIdValid, isDisappearFolderIdNotEmpty);
    return isDisappearFolderIdValid && isDisappearFolderIdNotEmpty;
  }

  /**
   * 设置文件夹解散全局变量
   */
  public setDisappearFolderData(folderId: string, lastAppKeyName: string, hiddenAppKeyName: string): void {
    log.showInfo('setDisappearFolderData, folderId=%{public}s', folderId);
    let isFolderIdEmpty: boolean = CheckEmptyUtils.checkStrIsEmpty(folderId);
    if (isFolderIdEmpty || folderId === CommonConstants.INVALID_FOLDER_ID) {
      log.showError('Invalid FolderId, isFolderIdEmpty = %{public}s', isFolderIdEmpty);
      return;
    }
    const disappearLastAppData: DisappearLastAppData = {
      folderId: folderId,
      lastAppKeyName: lastAppKeyName,
      hiddenAppKeyName: hiddenAppKeyName,
    };
    AppStorage.setOrCreate('disappearLastAppData', disappearLastAppData);
  }

  public isFolderClose(): boolean {
    let openFolderStatus: number = AppStorage.get<number>('openFolderStatus') as number;
    let openFolderId: string | undefined = AppStorage.get('openFolderId');
    return openFolderId === '-1' && openFolderStatus === CommonConstants.OPEN_FOLDER_STATUS_TRANSITION_START;
  }

  /**
   * 获取文件夹最大应用数量
   */
  public static getMaxAppCount(): number {
    let numPerPage: number = StyleConstants.DEFAULT_FOLDER_OPEN_ROW_SIZE * StyleConstants.DEFAULT_FOLDER_OPEN_COL_SIZE;
    if (DeviceHelper.isFold() || DeviceHelper.isPad()) {
      numPerPage = StyleConstants.DEFAULT_FOLDER_OPEN_ROW_SIZE_EXPENDED * StyleConstants.DEFAULT_FOLDER_OPEN_COL_SIZE;
    }
    return numPerPage * StyleConstants.FOLDER_APP_MAX_PAGES;
  }

  /**
   * 将布局元素中包含的空元素过滤掉.
   *
   * @returns 返回不包含空白元素的布局列表.
   */
  public static filterEmptyItemInLayout(layout: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    if (ObjUtil.isInvalid(layout)) {
      log.showInfo('filterEmptyItemInLayout is empty');
      return [];
    }
    let res: GridLayoutItemInfo[] = layout.filter((item: GridLayoutItemInfo, index: number) => {
      if (ObjUtil.isInvalid(item)) {
        log.showInfo('filterEmptyItemInLayout item invalid, index: ' + index);
        return false;
      }
      return true;
    });
    return res;
  }

  /**
   * 将文件夹布局元素中包含的空元素过滤掉.
   *
   * @returns 返回不包含空白元素的文件夹布局列表.
   */
  public static filterEmptyItemInFolder(layout: FolderAppItemInfo[]): FolderAppItemInfo[] {
    if (ObjUtil.isInvalid(layout)) {
      log.showInfo('filterEmptyItemInFolder is empty');
      return [];
    }
    let res: FolderAppItemInfo[] = layout.filter((item: FolderAppItemInfo, index: number) => {
      if (ObjUtil.isInvalid(item)) {
        log.showInfo('filterEmptyItemInFolder item invalid, index: ' + index);
        return false;
      }
      return true;
    });
    return res;
  }

  /**
   * 判断一个文件夹是否已满
   */
  public static isFolderFull(itemInfo: GridLayoutItemInfo): boolean {
    if (ObjUtil.isInvalid(itemInfo)) {
      return false;
    }
    if (itemInfo.typeId !== CommonConstants.TYPE_FOLDER) {
      return false;
    }
    return FolderViewModel.isLayoutFull(itemInfo.layoutInfo);
  }

  /**
   * 多选拖拽进文件夹时判断一个文件夹是否能装下拖拽图标
   *
   * @param itemInfo 落位所在位置的图标
   * @param dragItems 拖拽图标
   * @returns 文件夹是否能装下拖拽图标
   */
  public static canFolderDropIn(itemInfo: GridLayoutItemInfo, dragItems: GridLayoutItemInfo[]): boolean {
    let limit: number = FolderViewModel.getMaxAppCount();
    if (ObjUtil.isInvalid(itemInfo)) {
      return false;
    }
    // 落位图标生成文件夹场景
    if (GridLayoutUtil.isIconType(itemInfo.typeId)) {
      if (dragItems.length + 1 <= limit) {
        return true;
      }
      return false;
    }
    // 落位文件夹场景
    let items: GridLayoutItemInfo[] = itemInfo.layoutInfo?.flat() ?? [];
    let appCount: number = items.length;
    return (appCount + dragItems.length) <= limit;
  }

  /**
   * 判断要拖入的应用是不是在文件夹布局内
   */
  public static isInFolder(itemInfo: GridLayoutItemInfo, dragItemInfo: GridLayoutItemInfo): boolean {
    if (ObjUtil.isInvalid(itemInfo) || ObjUtil.isInvalid(dragItemInfo)) {
      return false;
    }
    if (itemInfo.typeId !== CommonConstants.TYPE_FOLDER) {
      return false;
    }

    let items: GridLayoutItemInfo[] = itemInfo.layoutInfo?.flat() ?? [];
    let dragKeyName: string = AppItemInfo.getKeyName(dragItemInfo);
    let index: number = items.findIndex((item: GridLayoutItemInfo) => {
      return AppItemInfo.getKeyName(item) === dragKeyName;
    });
    return index >= 0;
  }

  /**
   * 判断应用能否拖入到文件夹内
   */
  public static canDragIn(itemInfo: GridLayoutItemInfo, dragItemInfo: GridLayoutItemInfo): boolean {
    if (FolderViewModel.isInFolder(itemInfo, dragItemInfo)) {
      return true;
    };
    return !FolderViewModel.isFolderFull(itemInfo);
  }

  /**
   * 判断二维数组布局是否为满文件夹
   */
  public static isLayoutFull(layoutInfo: GridLayoutItemInfo[][] | undefined): boolean {
    let limit: number = FolderViewModel.getMaxAppCount();
    return FolderViewModel.getAppCountWithoutAdd(layoutInfo) >= limit;
  }

  public static showToast(resId: string): void {
    try {
      promptAction.showToast({
        message: $r(resId)
      });
    } catch (err) {
      log.showError('showToast failed: ${public}d: %{public}s', err.code, err.message);
    }
  }

  /**
   * 获取一个二维数组布局的应用数量，排除掉最后一个ADD
   */
  public static getAppCountWithoutAdd(layoutInfo: GridLayoutItemInfo[][] | undefined): number {
    let items: GridLayoutItemInfo[] = layoutInfo?.flat() ?? [];
    let appCount: number = items.length;
    if (items[appCount - 1]?.typeId === CommonConstants.TYPE_ADD) {
      return appCount - 1;
    }
    return appCount;
  }
}

/**
 * 文件夹重命名监听
 */
export interface FolderLayoutChangeListener {
  rename?: (name: string) => void
}

export class DisappearLastAppData {
  folderId: string = '';
  lastAppKeyName: string | undefined = '';
  hiddenAppKeyName: string = '';
  restApp?: GridLayoutItemInfo | undefined = undefined;
  uninstallApp?: GridLayoutItemInfo | undefined = undefined;
}

export enum SmallFolderRegion {
  LEFT_UP_REGION = 0,
  RIGHT_UP_REGION = 1,
  LEFT_DOWN_REGION = 2,
  RIGHT_DOWN_REGION = 3
};
