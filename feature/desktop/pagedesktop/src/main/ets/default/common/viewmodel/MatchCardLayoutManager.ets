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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils';
import {
  AppItemInfo,
  CommonConstants,
  DockItemInfo,
  FolderManager,
  FolderData,
  FolderModel,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LauncherLayoutCacheUtil,
  LaunchLayoutCacheManager,
  LayoutDescription,
  LayoutViewModel,
  RdbStoreManager,
  ResidentLayoutCacheMgr,
  scbBlankPositionUtils,
  SettingsModel
} from '@ohos/launchercommon';
import { BusinessType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { PageDesktopViewModel } from './PageDesktopViewModel';
import { MatchCardDataManager } from '@ohos/launchercommon/src/main/ets/model/MatchCardDataManager';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { BigFolderViewModel } from '@ohos/bigfolder/src/main/ets/default/viewmodel/BigFolderViewModel';

const TAG = 'MatchCardLayoutManager';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const NUM_TWO: number = 2;
const DELAY_FIVE_SECONDS: number = 5000;

export class MatchCardLayoutManager {
  private static readonly PRELOAD_TOPAPPS_FOLDER_NAME = '${folder_name_preload}';
  private mFirstAppNotFound: AppItemInfo | null = null;
  private mIsFinishedInitLayout: boolean = false;
  private static instance: MatchCardLayoutManager;

  static getInstance(): MatchCardLayoutManager {
    if (!MatchCardLayoutManager.instance) {
      MatchCardLayoutManager.instance = new MatchCardLayoutManager();
    }
    return MatchCardLayoutManager.instance;
  }

  /**
   * 识别桌面布局加载完成场景，并触发随卡业务
   */
  public setIsFinishedInitLayout(): void {
    this.mIsFinishedInitLayout = true;
    this.handleWaitAddFolderApps();
  }

  /**
   * 处理新安装的随卡应用, 添加到精品应用文件夹
   *
   * @param appInfo 识别到的随卡应用
   */
  public doAddToFolderAction(appInfo: AppItemInfo): void {
    // 如果桌面布局已加载完成则直接添加到精品应用文件夹，否则等待
    if (this.mIsFinishedInitLayout) {
      if (!MatchCardDataManager.checkIsWaitingAddFolderApp(appInfo)) {
        this.addToTopAppsFolder([appInfo]);
      }
    } else {
      MatchCardDataManager.updateWaitAddFolderApps(appInfo);
    }
  }

  /**
   * 处理由于桌面布局未加载完成前无法及时处理的随卡应用
   */
  private handleWaitAddFolderApps(): void {
    this.addToTopAppsFolder(MatchCardDataManager.getWaitAddFolderApps());
  }

  /**
   * 添加随卡预装应用到精品应用文件夹
   *
   * @param appItemInfos 随卡安装应用列表
   */
  private addToTopAppsFolder(appItemInfos: AppItemInfo[]): void {
    if (CheckEmptyUtils.isEmptyArr(appItemInfos)) {
      return;
    }
    if (this.addToTopAppsFolderInDesktop(appItemInfos)) {
      log.showInfo(TAG, 'addToTopAppsFolderInDesktop success');
      return;
    }
    if (this.addToTopAppsFolderInDock(appItemInfos)) {
      log.showInfo(TAG, 'addToTopAppsFolderInDock success');
      return;
    }
    if (appItemInfos.length > 1) {
      //如果添加随卡应用数大于或者等于2个,在桌面创建精品应用文件夹一起放
      this.createTopAppsFolderToDesktop(appItemInfos);
      return;
    }
    if (appItemInfos.length === 1) {
      log.showInfo(TAG, 'Start createTopAppsFolderWithFirstMatchCardApp');
      this.createTopAppsFolderWithFirstMatchCardApp(appItemInfos);
    }
  }

  /**
   * 目标应用图标与首个随卡应用图标形成精品应用文件夹
   *
   * @param appItemInfos 目标应用图标列表
   */
  private createTopAppsFolderWithFirstMatchCardApp(appItemInfos: AppItemInfo[]): void {
    if (!this.mFirstAppNotFound) {
      this.mFirstAppNotFound = appItemInfos[0];
      setTimeout(() => {
        if (this.mFirstAppNotFound) {
          this.insertMatchCardAppToDesktop(this.mFirstAppNotFound);
        }
      }, DELAY_FIVE_SECONDS);
    } else {
      this.deleteFirstAppNotFound(this.mFirstAppNotFound.keyName ?? '');
      appItemInfos.push(this.mFirstAppNotFound);
      this.mFirstAppNotFound = null;
      this.createTopAppsFolderToDesktop(appItemInfos);
    }
  }

  /**
   * 添加应用图标到桌面文件夹
   *
   * @param appItemInfos 需添加的应用列表
   * @returns 添加成功返回true，否则false
   */
  private addToTopAppsFolderInDesktop(appItemInfos: AppItemInfo[]): boolean {
    let gridLayoutItemList: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance().getGridLayoutItemList(false);
    let folderInDesktop: GridLayoutItemInfo | undefined = this.findToTopAppsFolderInDesktop(gridLayoutItemList);
    if (!folderInDesktop) {
      log.showWarn(TAG, 'addToTopAppsFolderInDesktop return, folderInDesktop is empty!');
      return false;
    }
    appItemInfos.forEach((item: AppItemInfo) => {
      let appItem: GridLayoutItemInfo = GridLayoutUtil.buildGridLayoutInfoFromItemInfo(item, 0, 0, 0);
      appItem.area = [1, 1];
      appItem.typeId = CommonConstants.TYPE_APP;
      if (!folderInDesktop) {
        return;
      }
      log.showWarn(TAG, 'addToTopAppsFolderInDesktop folderId %{public}s bundleName %{public}s',
        folderInDesktop.folderId, appItem.bundleName);
      this.updateTopAppsFolderLayout(folderInDesktop, appItem);
    });
    this.updateFolderAndInsertDBInDesktop(gridLayoutItemList, folderInDesktop, appItemInfos);
    return true;
  }

  /**
   * 将应用图标更新到桌面文件夹缓存和数据库
   *
   * @param gridLayoutItemList 桌面布局缓存
   * @param folderInDesktop 桌面文件夹信息
   * @param appItemInfos 需更新的的应用图标信息
   */
  private updateFolderAndInsertDBInDesktop(gridLayoutItemList: GridLayoutItemInfo[],
    folderInDesktop: GridLayoutItemInfo, appItemInfos: AppItemInfo[]): void {
    if (!folderInDesktop || !folderInDesktop.layoutInfo) {
      return;
    }
    let folderLayout: GridLayoutItemInfo[] = folderInDesktop.layoutInfo.flat();
    BigFolderViewModel.getInstance().updateFolderAppLocation(folderLayout);
    FolderManager.getInstance().updateFolderItems('update matchCard folder in deskTop', folderInDesktop, folderLayout);
    LaunchLayoutCacheManager.getInstance().updateLayoutListCacheAndPrebuild(gridLayoutItemList, false);
    PageDesktopViewModel.getInstance().lightPagingFiltering(true);
    FolderData.getInstance().refreshView('updateFolderAndInsertDBInDesktop', folderInDesktop.folderId, false);
    RdbStoreManager.getInstance().addInfoToFolder(folderInDesktop.folderId, folderInDesktop.layoutInfo.flat())
      .then(() => {
        MatchCardDataManager.deleteAppsFromMatchCardAppList(appItemInfos);
      }).catch((err: Error) => {
      log.showError(TAG, `addInfoToFolder error: ${err.toString()}`);
    });
  }

  /**
   * 添加应用到Dock区文件夹
   *
   * @param appItemInfos 需更新的应用图标信息
   * @returns 更新成功返回true，否则false
   */
  private addToTopAppsFolderInDock(appItemInfos: AppItemInfo[]): boolean {
    let residentList: DockItemInfo[] | undefined = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    if (CheckEmptyUtils.isEmptyArr(residentList)) {
      return false;
    }
    let folderIndexInDock: number = this.findToTopAppsFolderIndexInDock(residentList);
    if (folderIndexInDock === CommonConstants.INVALID_VALUE) {
      log.showWarn(TAG, 'addToTopAppsFolderInDock return, folderIndexInDock === -1');
      return false;
    }
    let folderInDock: DockItemInfo = residentList[folderIndexInDock];
    if (CheckEmptyUtils.isEmpty(folderInDock)) {
      log.showWarn(TAG, 'addToTopAppsFolderInDock return, folderInDock is empty!');
      return false;
    }
    let newResidentList: DockItemInfo[] = this.updateResidentList(appItemInfos, residentList, folderInDock);
    let folderApps: GridLayoutItemInfo[] | undefined = newResidentList[folderIndexInDock].layoutInfo?.flat();
    if (!folderApps) {
      log.showWarn(TAG, 'folderApps is empty!');
      return false;
    }
    RdbStoreManager.getInstance().addInfoToDockFolder(folderInDock.appId, folderApps).then(() => {
      SettingsModel.getInstance().setResidentList(newResidentList);
      LayoutViewModel.getInstance().updateResidentDockLayout('DeskTopMatchCard', newResidentList);
      let dockGridItem: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(folderInDock);
      const dockItems: GridLayoutItemInfo[] = dockGridItem.layoutInfo?.flat() ?? [];
      FolderManager.getInstance().updateFolderItems('update matchCard folder in dock', dockGridItem, dockItems);
      MatchCardDataManager.deleteAppsFromMatchCardAppList(appItemInfos);
    }).catch((err: Error) => {
      log.showError(TAG, `addInfoToDockFolder error: ${err.toString()}`);
    });
    return true;
  }

  /**
   * 将应用图标更新到Dock区文件夹缓存
   *
   * @param appItemInfos 需更新的应用图标信息
   * @param residentList Dock区缓存列表
   * @param folderInDock Dock区目标文件夹
   * @returns 更新后的Dock区缓存列表
   */
  private updateResidentList(appItemInfos: AppItemInfo[], residentList: DockItemInfo[],
    folderInDock: DockItemInfo): Array<DockItemInfo> {
    let folderApps: GridLayoutItemInfo[] | undefined = folderInDock.layoutInfo?.flat();
    appItemInfos.forEach((appItemInfo) => {
      let gridlayoutItem: GridLayoutItemInfo = GridLayoutUtil.buildGridLayoutInfoFromItemInfo(appItemInfo, 0, 0, 0);
      gridlayoutItem.area = [1, 1];
      gridlayoutItem.typeId = CommonConstants.TYPE_APP;
      folderApps?.push(gridlayoutItem);
    });
    let newResidentList: DockItemInfo[] = [];
    for (let i = 0; i < residentList.length; i++) {
      let dockItemInfo = residentList[i];
      if (!dockItemInfo?.layoutInfo || dockItemInfo.layoutInfo.length === 0) {
        newResidentList.push(dockItemInfo);
        continue;
      }
      let resident = dockItemInfo;
      if (dockItemInfo.typeId === CommonConstants.TYPE_FOLDER && (dockItemInfo.appId === folderInDock.appId)) {
        BigFolderViewModel.getInstance().updateFolderAppLocation(folderApps);
        resident.layoutInfo = BigFolderViewModel.getInstance().translateFolderLayout(folderApps);
        newResidentList.push(resident);
        continue;
      }
      newResidentList.push(dockItemInfo);
    }
    return newResidentList;
  }

  /**
   * 在桌面查找精品应用文件夹
   *
   * @param gridLayoutItemList 桌面布局缓存
   * @returns 桌面精品文件夹GridLayoutItemInfo信息
   */
  private findToTopAppsFolderInDesktop(gridLayoutItemList: GridLayoutItemInfo[]): GridLayoutItemInfo | undefined {
    return gridLayoutItemList.find((item) => {
      return item.typeId === CommonConstants.TYPE_FOLDER &&
        item.folderName === MatchCardLayoutManager.PRELOAD_TOPAPPS_FOLDER_NAME;
    });
  }

  /**
   * 在Dock区查找精品应用文件夹
   *
   * @param DockItemInfo Dock布局缓存
   * @returns Dock区精品文件夹DockItemInfo信息
   */
  private findToTopAppsFolderIndexInDock(residentList: DockItemInfo[]): number {
    return residentList.findIndex(item =>
    item.itemType === CommonConstants.TYPE_FOLDER &&
      item.appName === MatchCardLayoutManager.PRELOAD_TOPAPPS_FOLDER_NAME);
  }

  /**
   * 优先在桌面上新增1x1的文件夹，空间不够就弹toast提示
   *
   * @param appItemInfos 随卡安装应用
   */
  private createTopAppsFolderToDesktop(appItemInfos: AppItemInfo[]): void {
    if (appItemInfos.length < NUM_TWO) {
      return;
    }
    let firstApp: AppItemInfo = appItemInfos[0];
    let secondApp: AppItemInfo = appItemInfos[1];
    let topAppsFolder: GridLayoutItemInfo = this.makeTopAppsFolder([firstApp, secondApp]);
    let targetItem: GridLayoutItemInfo | undefined = this.findPlaceAndBuildItem(topAppsFolder);
    if (targetItem) {
      log.showInfo(TAG, `createTopAppsFolderToDesktop, start insert db.`);
      LaunchLayoutCacheManager.getInstance()
        .insertFolderLayoutInfoAsync(targetItem, BusinessType.BUSINESS_BASIC_DESKTOP, true).then(() => {
        log.showInfo(TAG, `createTopAppsFolderToDesktop, insert db end.`);
        PageDesktopViewModel.getInstance().lightPagingFiltering(true);
        FolderData.getInstance().refreshView('createTopAppsFolderToDesktop', topAppsFolder.folderId, false);
        MatchCardDataManager.deleteAppFromMatchCardAppList(firstApp.bundleName);
        MatchCardDataManager.deleteAppFromMatchCardAppList(secondApp.bundleName);
        appItemInfos.splice(0, NUM_TWO);
        if (appItemInfos.length > 0) {
          this.addToTopAppsFolderInDesktop(appItemInfos);
        }
      }).catch((err: Error) => {
        log.showError(TAG, `insertFolderLayoutInfoAsync error: ${err.toString()}`);
      });
    } else {
      log.showWarn(TAG, `not space to add topAppsFolder 1x1 to desktop`);
      PageDesktopViewModel.getInstance().showNoSpaceToast();
    }
  }

  /**
   * 添加应用图标到文件夹时更新文件夹缓存
   *
   * @param folderInDesktop 目标文件夹
   * @param appItem 添加的应用信息
   */
  private updateTopAppsFolderLayout(folderInDesktop: GridLayoutItemInfo, appItem: GridLayoutItemInfo): void {
    if (!folderInDesktop.layoutInfo) {
      return;
    }
    const lastPageItems: GridLayoutItemInfo[] = folderInDesktop.layoutInfo[folderInDesktop.layoutInfo.length - 1];
    if (!CheckEmptyUtils.isEmpty(lastPageItems[lastPageItems.length - 1]) &&
      lastPageItems[lastPageItems.length - 1].typeId === CommonConstants.TYPE_ADD) {
      lastPageItems[lastPageItems.length - 1] = appItem;
    } else {
      const openFolderConfig = FolderModel.getInstance().getFolderOpenLayout();
      if (lastPageItems.length === openFolderConfig.column * openFolderConfig.row) {
        folderInDesktop.layoutInfo.push([appItem]);
      } else {
        lastPageItems.push(appItem);
      }
    }
  }

  /**
   * 创建精品应用文件夹
   *
   * @param appItemInfos 创建文件夹所需的应用图标信息
   * @returns 文件夹GridLayoutItemInfo信息
   */
  private makeTopAppsFolder(appItemInfos: AppItemInfo[]): GridLayoutItemInfo {
    let gridLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
    gridLayoutInfo.typeId = CommonConstants.TYPE_FOLDER;
    gridLayoutInfo.folderId = new Date().getTime().toString();
    gridLayoutInfo.bundleName = gridLayoutInfo.folderId;
    gridLayoutInfo.folderName = MatchCardLayoutManager.PRELOAD_TOPAPPS_FOLDER_NAME;
    gridLayoutInfo.container = CommonConstants.CONTAINER_DESKTOP;
    gridLayoutInfo.area = [1, 1];
    let gridlayoutItems: GridLayoutItemInfo[] = [];
    appItemInfos.forEach((appInfo => {
      let appItem: GridLayoutItemInfo = GridLayoutUtil.buildGridLayoutInfoFromItemInfo(appInfo, 0, 0, 0);
      appItem.area = [1, 1];
      appItem.typeId = CommonConstants.TYPE_APP;
      gridlayoutItems.push(appItem);
    }));
    gridLayoutInfo.layoutInfo = [gridlayoutItems];
    log.showWarn(TAG, 'make topAppsFolder');
    return gridLayoutInfo;
  }

  /**
   * 在桌面寻找空位并构建小文件夹占位信息
   *
   * @param item 目标小文件夹
   * @returns 更新占位信息后的小文件夹
   */
  private findPlaceAndBuildItem(item: GridLayoutItemInfo): GridLayoutItemInfo | undefined {
    const layoutDescription: LayoutDescription = LaunchLayoutCacheManager.getInstance().selectLayoutDescription(false);
    let startFindPage: number = 0;
    let pageCount: number = 0;
    pageCount = layoutDescription.pageCount;
    // 从第二屏开始查找空白位置
    startFindPage = scbBlankPositionUtils.getFindBlankStartPage(layoutDescription.maxPage, false);
    let first: number;
    let second: number;
    let isPad = DeviceHelper.isPad();
    if (isPad) {
      first = layoutDescription.column;
      second = layoutDescription.row;
    } else {
      first = layoutDescription.row;
      second = layoutDescription.column;
    }
    let targetItem: GridLayoutItemInfo | undefined;
    //从第二屏到最后一屏查找空位
    for (let i = startFindPage; i < pageCount; i++) {
      targetItem = this.getAvailableLocation(first, second, isPad, i, item);
      if (targetItem) {
        break;
      }
    }
    if (!targetItem) {
      //如果所有屏都未找到空位,新建一屏
      pageCount = DeviceHelper.isFoldButNotSmallFoldProduct() && (pageCount < NUM_TWO) ? NUM_TWO : pageCount;
      log.showInfo(TAG, `findLocationForNewFolder pageCount:${pageCount}, bundlerName: ${item.bundleName} add new page`);
      if (pageCount < layoutDescription.maxPage && !DeviceHelper.isPC()) {
        targetItem = this.updateGridLayoutInfoPosition(item, pageCount, 0, 0);
        LaunchLayoutCacheManager.getInstance()
          .updatePageCount(pageCount + 1, BusinessType.BUSINESS_BASIC_DESKTOP, true, false);
      }
    }
    //如果当前所有屏未找到空位，且当前已满屏，返回null
    return targetItem;
  }

  private getAvailableLocation(first: number, second: number, isPad: boolean, page: number,
    item: GridLayoutItemInfo): GridLayoutItemInfo | undefined {
    let rowOffset: number = 0;
    if (DeviceHelper.isPad() && (page === 0)) {
      rowOffset = 3;
    }
    for (let y = rowOffset; y < first; y++) {
      for (let x = 0; x < second; x++) {
        let positionX = isPad ? y : x;
        let positionY = isPad ? x : y;
        if (LaunchLayoutCacheManager.getInstance().isPositionValid(item, page, positionX, positionY, false)) {
          log.showInfo(TAG, `getAvailableLocation pagex:${page} x:${positionX} y:${positionY}`);
          return this.updateGridLayoutInfoPosition(item, page, positionX, positionY);
        }
      }
    }
    return undefined;
  }

  /**
   * 添加应用图标到桌面布局
   *
   * @param item 目标应用图标信息
   */
  private insertMatchCardAppToDesktop(item: AppItemInfo): void {
    let appItem: GridLayoutItemInfo = GridLayoutUtil.buildGridLayoutInfoFromItemInfo(item, 0, 0, 0);
    appItem.area = [1, 1];
    appItem.typeId = CommonConstants.TYPE_APP;
    let targetItem: GridLayoutItemInfo | undefined = this.findPlaceAndBuildItem(appItem);
    if (targetItem) {
      log.showInfo(TAG, `add app to desktop, start`);
      if (LaunchLayoutCacheManager.getInstance()
        .insertGridLayoutItemInfo(targetItem, BusinessType.BUSINESS_BASIC_DESKTOP, true, false)) {
        PageDesktopViewModel.getInstance().lightPagingFiltering(true);
        MatchCardDataManager.deleteAppFromMatchCardAppList(item.bundleName);
      }
    } else {
      log.showInfo(TAG, 'show toast add app to desktop max');
      PageDesktopViewModel.getInstance().showNoSpaceToast();
    }
  }

  /**
   * 更新GridLayoutItemInfo组件位置布局信息
   *
   * @param item 目标组件
   * @param page 所在页
   * @param col 所在列
   * @param row 所在行
   * @returns 组件位置布局信息
   */
  private updateGridLayoutInfoPosition(item: GridLayoutItemInfo, page: number, col: number,
    row: number): GridLayoutItemInfo {
    let newGridLayoutItem: GridLayoutItemInfo = ObjectCopyUtil.deepClone(item) as GridLayoutItemInfo;
    newGridLayoutItem.page = page;
    newGridLayoutItem.column = col;
    newGridLayoutItem.row = row;
    return newGridLayoutItem;
  }

  /**
   * 指定时间内未等到第二个应用安装，后续形成文件夹删除桌面重复图标
   *
   * @param keyName 待删除的重复图标的keyName
   */
  private deleteFirstAppNotFound(keyName: string): void {
    let gridLayoutItemList: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance().getGridLayoutItemList(false);
    let deleteItem: GridLayoutItemInfo | undefined = gridLayoutItemList.find(item => item.keyName === keyName);
    if (CheckEmptyUtils.isEmpty(deleteItem)) {
      log.showWarn(TAG, 'deleteFirstAppNotFound return, firstAppNotFound not insert to desk.');
      return;
    }
    let filter = (item: GridLayoutItemInfo): boolean => item.keyName !== keyName;
    let newGridLayoutItemList: GridLayoutItemInfo[] = gridLayoutItemList.filter(filter);
    LaunchLayoutCacheManager.getInstance().updateCache(newGridLayoutItemList);
    try {
      LauncherLayoutCacheUtil.deleteGridLayoutItemByKeyNameCallBack(deleteItem);
    } catch (error) {
      log.showInfo(TAG, 'deleteFirstAppNotFound with error %{public}s', error.message);
    }
  }
}