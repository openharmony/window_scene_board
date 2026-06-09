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

import { FolderDataManager } from './data/FolderDataManager';
import { DragAppToFolderData, DragCoveredItem, FoldersData } from './data/FoldersData';
import {
  CommonConstants,
  DisappearLastAppData,
  FolderViewModel,
  GridLayoutItemInfo,
  LauncherLayoutCacheUtil
} from '../../../../TsIndex';
import {
  FolderCommonConstants,
  FolderDataRefreshType,
  FolderLifeCyclePriority
} from '../FolderCommonConstant';
import { FolderDataLifeCycleEventManager } from './lifecycle/FolderDataLifeCycleEventManager';
import { FolderCommonUtil } from '../FolderCommonUtil';
import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';
import { HiDfxEventUtil } from '@ohos/frameworkwrapper';

const TAG = 'FolderManager';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 文件夹Model层数据管理统一入口：负责更新文件夹业务缓存的文件夹数据、截图更新、展开态缓存节点更新、触发业务回调执行
 */
export class FolderManager {
  private static instance: FolderManager;
  private folderDataMgr: FolderDataManager = FolderDataManager.getInstance();
  private lifeCycle: FolderDataLifeCycleEventManager = FolderDataLifeCycleEventManager.getInstance();
  private mUninstallFolderAppItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  private mDisappearData: DisappearLastAppData = new DisappearLastAppData();
  private mOpenedFolder: GridLayoutItemInfo | undefined = undefined;
  private mClosingFolder: GridLayoutItemInfo | undefined = undefined;
  private mDragItemFolder: GridLayoutItemInfo | undefined = undefined;
  private mDragAppToFolder: DragAppToFolderData = new DragAppToFolderData();
  private mExitAppItem: GridLayoutItemInfo | undefined = undefined;
  private mLastAnimateInfo: GridLayoutItemInfo | undefined = undefined;
  /* 用于文件夹合成的动效数据 */
  private mDragCoverItem: DragCoveredItem = new DragCoveredItem();
  private mOpenedFolderId: string = '';
  private mDragLeaveFolderId: string = FolderCommonConstants.INVALID_FOLDER_ID;
  private mResizeFolderId: string = FolderCommonConstants.INVALID_FOLDER_ID;
  private multiDropFolderId: string = '';
  private mIsSqueezing: boolean = false;
  private mIsFolderClosing: boolean = false;
  private mIsFolderChanging: boolean = false;
  private mIsOpenFolderIconTouchEnabled: boolean = false;
  private mThemeStyle: string = '';
  private mDesktopIconChange: number = 0;
  private mSelectedItemNames: string[] = [];
  private mPageIndex: number = 0;
  private mExitIndex: number = 0;

  public static getInstance(): FolderManager {
    if (!FolderManager.instance) {
      FolderManager.instance = new FolderManager();
    }
    return FolderManager.instance;
  }

  private constructor() {
  }

  /**
   * 注册文件夹数据生命周期监听事件
   * @param obs 监听事件
   */
  public registerDataLifeListener(obs: FolderDataListener): void {
    this.lifeCycle.register(obs);
  }

  /**
   * 去注册文件夹数据生命周期监听事件
   * @param obs 监听事件
   */
  public unregisterDataLifeListener(obs: FolderDataListener): void {
    this.lifeCycle.unregister(obs);
  }

  /**
   * 根据文件夹id去注册文件夹数据生命周期监听事件
   *
   * @param folderId 文件夹id
   */
  public unregisterByFolderId(folderId: string): void {
    this.lifeCycle.unregisterByFolderId(folderId);
  }

  /**
   * 获取指定文件夹数据，特别的，这里持有的是cache缓存数据，请不要修改；长期持有时需要监听数据生命周期随时增删
   *
   * @param folderId 文件夹ID
   * @returns 文件夹数据
   */
  public getFolder(folderId: string): FoldersData {
    return this.folderDataMgr.getFolder(folderId);
  }

  /**
   * 获取所有文件夹数据，特别的，这里持有的是cache缓存数据，请不要修改；长期持有时需要监听数据生命周期随时增删
   * @returns 文件夹数据
   */
  public getFolders(): FoldersData[] {
    return this.folderDataMgr.getFolders();
  }

  /**
   * 获取小文件夹
   *
   * @returns 小文件夹列表
   */
  public getSmallFolders(): FoldersData[] {
    return this.folderDataMgr.getFolders().filter(folderData => folderData.isSmall());
  }

  /**
   * 查找指定文件夹内的应用信息数组的拷贝
   *
   * @param folder 指定文件夹信息
   * @return 文件夹内一维化的列表
   */
  public getItemsInFolder(folder: GridLayoutItemInfo): GridLayoutItemInfo[] {
    let want: GridLayoutItemInfo | undefined = undefined;
    if (folder !== this.mOpenedFolder) {
      want = this.getFolder(folder.folderId as string).getGridInfo();
    } else {
      want = folder;
    }
    if (want && want.layoutInfo) {
      return want.layoutInfo.flat();
    }
    return [];
  }

  /**
   * 获取当前卸载的文件夹应用
   *
   * @returns 卸载的文件夹应用数据
   */
  public getUninstallFolderAppItem(): GridLayoutItemInfo {
    return this.mUninstallFolderAppItem;
  }

  /**
   * 设置当前解散的应用数据
   *
   * @param disappearLastAppData 解散的数据
   */
  public setDisappearLastAppData(disappearLastAppData: DisappearLastAppData): void {
    this.mDisappearData = disappearLastAppData;
  }

  /**
   * 获取当前解散的应用数据
   *
   * @returns 解散的数据
   */
  public getDisappearLastAppData(): DisappearLastAppData {
    return this.mDisappearData;
  }

  /**
   * 设置文件夹展开态当前页page
   *
   * @param pageIndex 页数
   */
  public setPageIndex(pageIndex: number): void {
    if (this.mPageIndex === pageIndex) {
      return;
    }
    this.mPageIndex = pageIndex;
  }

  /**
   * 获取文件夹展开态当前页page
   *
   * @returns pageIndex 页数
   */
  public getPageIndex(): number {
    return this.mPageIndex;
  }

  /**
   * 设置当前卸载的文件夹应用，并触发更新卸载应用item的回调
   *
   * @param item 卸载的item
   */
  public updateUninstallFolderAppItem(item: GridLayoutItemInfo): void {
    this.mUninstallFolderAppItem = item;
    AppStorage.setOrCreate('unInstallItemInfo', this.mUninstallFolderAppItem);
  }

  /**
   * 判断桌面文件夹（不分大小）数量是否超过16个,超过16个故障上报
   *
   * @return void
   */
  public folderNunmIsMore(): void {
    let allDolderNum: number = this.getFolders().length + 1;
    if (allDolderNum <= CommonConstants.FOLDER_MAX_NUM) {
      log.showInfo(TAG, 'folder num %{public}d', allDolderNum);
      return;
    }
    HiDfxEventUtil.reportFolderNumIsMore(allDolderNum);
  }

  /**
   * 遍历所有文件夹删除指定应用及关联快捷方式、分身
   *
   * @param msg 用于DFX日志打印
   * @param deleteItem 删除的元素
   * @param folders 文件夹
   * @param isDelRelate 是否删除应用管理的快捷方式与分身，true需要删除，false不需要删除
   */
  public batchDeleteInFolders(msg: string, delItems: GridLayoutItemInfo[], folders: FoldersData[],
    isDelRelate: boolean): void {
    if (CheckEmptyUtils.isEmptyArr(delItems)) {
      log.showWarn(TAG, 'the deleteItems is empty');
      return;
    }
    folders.forEach(folder => {
      const folderId: string = folder.getFolderId();
      if (folder.isEmptyGrid()) {
        log.showWarn(TAG, '(%{public}s), the folder %{public}s is empty', msg, folderId);
        return;
      }
      const folderItem: GridLayoutItemInfo = folder.getGridInfo();
      const items: GridLayoutItemInfo[] = FolderCommonUtil.filterListAfterUninstall(folderItem, delItems, isDelRelate);
      const folderSize: number = items.length;
      const isRelease: boolean = FolderCommonUtil.isNeedReleased(items, folderId);
      if (folderSize === folder.getItems().length && !isRelease) {
        log.showInfo(TAG, '(%{public}s) not update for folder %{public}s layout not change', msg, folderId);
        return;
      }
      if (isRelease) {
        const remainItem: GridLayoutItemInfo | undefined = folderSize > 0 ? items[0] : undefined;
        this.removeFolder(msg, folderItem, remainItem);
      } else {
        const isDock: boolean = folderItem.container === CommonConstants.CONTAINER_DOCK;
        this.updateFolderLayout(msg, folderId, items, items, isDock);
      }
    });
    if (isDelRelate) {
      delItems.forEach(deleteItem => {
        LauncherLayoutCacheUtil.deleteItemInRdb(deleteItem);
      });
    }
  }

  /**
   * 删除文件夹，如果剩余一个应用，则应用继承原文件的位置
   *
   * @param msg DFX日志
   * @param folderItem 文件夹item
   * @param remainApp 删除文件夹后，剩余的一个应用
   */
  public removeFolder(msg: string, folderItem: GridLayoutItemInfo, remainApp?: GridLayoutItemInfo): void {
    if (remainApp) {
      remainApp.page = folderItem.page;
      remainApp.column = folderItem.column;
      remainApp.row = folderItem.row;
      remainApp.landscapePage = folderItem.landscapePage;
      remainApp.landscapeColumn = folderItem.landscapeColumn;
      remainApp.landscapeRow = folderItem.landscapeRow;
      remainApp.portraitPage = folderItem.portraitPage;
      remainApp.portraitColumn = folderItem.portraitColumn;
      remainApp.portraitRow = folderItem.portraitRow;
      log.showInfo(TAG, `(${msg}) remain item ${this.getInfo(remainApp)}`);
    }
    let isDock: boolean = (folderItem.container === CommonConstants.CONTAINER_DOCK);
    this.folderDataMgr.getFolderUpdator(isDock).deleteFolderById(msg, folderItem.folderId as string, remainApp);
    this.folderDataMgr.deleteCacheById(msg, folderItem.folderId as string);
    this.lifeCycle.notifyRemoveFolder(folderItem);
  }

  /**
   * 添加应用列表到文件夹中
   *
   * @param msg DFX日志
   * @param addItems 添加的应用列表
   * @param folderId 文件夹id
   */
  public addItemsToFolder(msg: string, addItems: GridLayoutItemInfo[], folderId: string, isDrag: boolean): boolean {
    let folderData: FoldersData = this.folderDataMgr.getFolder(folderId);
    if (folderData.isEmptyGrid()) {
      log.showWarn(TAG, 'add to folder (%{public}s) error: (%{public}s)', folderId, msg);
      return false;
    }
    let folderItem: GridLayoutItemInfo = folderData.getGridInfo();
    if (FolderViewModel.isFolderFull(folderItem)) {
      log.showWarn(TAG, 'dragOneAppToFolder folder (%{public}s) full', msg);
      return false;
    }
    addItems.forEach(item => log.showInfo(TAG, `(${msg}) add item ${this.getInfo(item)}`));
    this.folderDataMgr.getFolderUpdator(folderItem.container === CommonConstants.CONTAINER_DOCK)
      .addItemsToFolder(msg, addItems, folderData, isDrag);
    this.folderDataMgr.updateFoldersData(folderId, folderData);
    // 通知添加应用到文件夹回调
    this.lifeCycle.notifyAddToFolder(folderId, addItems);
    return true;
  }

  /**
   * 创建一个文件夹
   *
   * @param msg 用于DFX日志打印
   * @param folder 文件夹
   * @param folderApps 文件夹应用列表
   * @param isInsertLayout 是否单独执行文件夹布局应用插入操作
   */
  public createFolder(msg: string, folder: GridLayoutItemInfo, folderApps: GridLayoutItemInfo[], refreshType: number,
    isInsertLayout: boolean): void {
    this.folderNunmIsMore();
    if (!folder || CheckEmptyUtils.isEmptyArr(folderApps)) {
      log.showError(TAG, 'create folder error with invalid parameter');
      return;
    }
    folderApps.forEach(folderApp => log.showInfo(TAG, `(${msg}) create folder appItem: ${this.getInfo(folderApp)}`));
    let isDock: boolean = (refreshType === FolderDataRefreshType.DOCK);
    this.folderDataMgr.getFolderUpdator(isDock).createFolder(msg, folder, folderApps, isInsertLayout);
    // 通知合成应用的回调
    this.lifeCycle.notifyCreateFolder(folder);
  }

  /**
   * 更新文件夹的布局，会触发展开态缓存节点的检测更新，与小文件下载背板状态的刷新, 不会触发DB更新
   *
   * @param msg 用于DFX日志打印
   * @param folderId 文件夹id
   * @param layoutInfo 更新的布局
   * @param updateItems 更新元素
   * @param isDock true更新dock文件夹，false更新桌面
   */
  public updateFolderLayout(msg: string, folderId: string, layoutInfo: GridLayoutItemInfo[],
    updateItems: GridLayoutItemInfo[], isDock: boolean = false): void {
    log.showInfo(TAG, '(%{public}s) update folder %{public}s layout size %{public}d', msg, folderId, layoutInfo.length);
    layoutInfo = FolderCommonUtil.getFilterAddIconList(layoutInfo);
    if (this.mOpenedFolder?.folderId === folderId) {
      const newlayout: GridLayoutItemInfo[][] = FolderCommonUtil.translateFolderLayout(layoutInfo);
      this.mOpenedFolder.layoutInfo = newlayout;
    }
    this.folderDataMgr.getFolderUpdator(isDock).updateFolderLayout(msg, folderId, layoutInfo);
    this.folderDataMgr.deleteCacheById(msg, folderId);
    this.lifeCycle.notifyUpdateFolder(folderId, updateItems);
  }

  /**
   * 更新文件夹布局，会触发展开态缓存节点的检测更新，与小文件下载背板状态的刷新, DB更新操作
   *
   * @param msg 用于DFX日志
   * @param folderId 文件夹id
   * @param layoutInfo 布局
   * @param isDb 是否执行DB操作
   */
  public updateFolderLayoutWithDb(msg: string, folderId: string, layoutInfo: GridLayoutItemInfo[],
    isDb: boolean): void {
    const folder: FoldersData = this.getFolder(folderId);
    if (folder.isEmptyGrid()) {
      log.showWarn('(%{public}s) update folder error as folder %{public}s is empty', msg, folderId);
      return;
    }
    const folderItem: GridLayoutItemInfo = folder.getGridInfo();
    layoutInfo = FolderCommonUtil.getFilterAddIconList(layoutInfo);
    const map: Map<string, GridLayoutItemInfo[][]> = new Map();
    let updateLayout: GridLayoutItemInfo[][] = FolderCommonUtil.translateFolderLayout(layoutInfo);
    FolderCommonUtil.updateFolderAppLocation(layoutInfo);
    if (this.mOpenedFolder?.folderId === folderId) {
      this.mOpenedFolder.layoutInfo = updateLayout;
    }
    map.set(folderId, updateLayout);
    this.folderDataMgr.getFolderUpdator(folderItem.container === CommonConstants.CONTAINER_DOCK)
      .updateFolderItemLayoutInfoByFolderIdList(folderId, map, msg, isDb, false);
    this.folderDataMgr.deleteCacheById(msg, folderId);
    this.lifeCycle.notifyUpdateFolder(folderId, layoutInfo);
  }

  /**
   * 更新文件夹内部元素item包名等信息，不会触发展开要态缓存节点更新和小文件夹下载背板状态的更新， 不会触发DB更新
   *
   * @param msg DFX的日志
   * @param updateFolder 更新的文件夹
   * @param updateInfo 更新的文件夹元素，展开态节点缓存管理更新这里传入的updateInfo元素节点
   */
  public updateFolderItems(msg: string, updateFolder: GridLayoutItemInfo, updateInfo: GridLayoutItemInfo[]): void {
    log.showInfo(TAG, 'appItem in folder %{public}s is update for (%{public}s)', updateFolder.folderId, msg);
    updateInfo.forEach(item => log.showInfo(TAG, `update folder item ${this.getInfo(item)}`));
    let folder: FoldersData = this.getFolder(updateFolder.folderId as string);
    folder.getGridInfo().layoutInfo = updateFolder.layoutInfo;
    this.lifeCycle.notifyUpdateFolderItems(updateFolder.folderId ?? '', updateInfo);
  }

  private getInfo(item: GridLayoutItemInfo): string {
    return `update folder item typeId[${item.typeId}], iconId[${item.appIconId}], appStatus[${item.appStatus}],` +
      `iconResource[${item.iconResource}], moduleName[${item.moduleName}], container[${item.container}]` +
      `abilityName[${item.abilityName}], appName[${item.appName}]`;
  }

  /**
   * 更新展开态文件夹布局
   *
   * @param msg 用于DFX日志打印
   * @param folderId 文件夹id
   * @param updateAppList 更新的应用列表
   * @param isDb 是否执行数据库更新操作
   */
  public updateOpenFolderLayout(msg: string, updateAppList: GridLayoutItemInfo[], isDb: boolean): void {
    if (!this.mOpenedFolder) {
      log.showError(TAG, 'update open folder layout error with null');
      return;
    }
    updateAppList = FolderCommonUtil.getFilterAddIconList(updateAppList);
    log.showInfo(TAG, 'update openFolder %{public}s layout length %{public}d: (%{public}s), isDb:%{public}s',
      this.mOpenedFolder.folderId, updateAppList.length, msg, isDb);
    const newLayout: GridLayoutItemInfo[][] = FolderCommonUtil.translateFolderLayout(updateAppList);
    FolderCommonUtil.updateFolderAppLocation(updateAppList);
    this.mOpenedFolder.layoutInfo = newLayout;
    // 通知缓存更新
    const map: Map<string, GridLayoutItemInfo[][]> = new Map();
    map.set(this.mOpenedFolder.folderId as string, newLayout);
    this.folderDataMgr.getFolderUpdator(this.mOpenedFolder.container === CommonConstants.CONTAINER_DOCK)
      .updateFolderItemLayoutInfoByFolderIdList(this.mOpenedFolder.folderId as string, map, msg, isDb, false);
    this.folderDataMgr.deleteCacheById(msg, this.mOpenedFolder.folderId as string);
    this.lifeCycle.notifyUpdateOpenFolder(this.mOpenedFolder);
  }

  /**
   * 更新文件夹名字
   *
   * @param folderId 文件夹id
   * @param folderName 文件夹名字
   */
  public updateFolderName(folderId: string, folderName: string): void {
    this.folderDataMgr.updateFolderName('modify folder name', folderId, folderName);
    this.lifeCycle.notifyUpdateFolderName(folderId);
  }

  /**
   * 设置dock去拖拽覆盖的元素
   *
   * @param dragCoveredItem 拖拽覆盖元素信息
   */
  public setDragCoveredItem(dragCoveredItem: DragCoveredItem, folderId: string): void {
    let dragAppToFolder: DragAppToFolderData = new DragAppToFolderData();
    dragAppToFolder.appPositionX = dragCoveredItem.dragItemInfoX;
    dragAppToFolder.appPositionY = dragCoveredItem.dragItemInfoY;
    dragAppToFolder.appKeyName = dragCoveredItem.dragItemInfo?.keyName as string;
    dragAppToFolder.folderId = folderId;
    this.mDragAppToFolder = dragAppToFolder;
    this.mDragCoverItem = dragCoveredItem;
  }

  /**
   * 获取拖拽覆盖的元素
   *
   * @returns mDragCoverItem
   */
  public getDragCoverItem(): DragCoveredItem {
    return this.mDragCoverItem;
  }

  /**
   * 清除拖拽覆盖元素的item信息
   */
  public clearDragCoverItem(): void {
    this.mDragCoverItem = new DragCoveredItem();
    this.mDragAppToFolder = new DragAppToFolderData();
  }

  /**
   * 设置退出到堆叠处应用的item
   *
   * @param item应用
   */
  public setExitAppItem(item: GridLayoutItemInfo | undefined): void {
    this.mExitAppItem = item;
  }

  /**
   * 获取退出到堆叠处应用的item
   *
   * @returns item
   */
  public getExitAppItem(): GridLayoutItemInfo | undefined {
    return this.mExitAppItem;
  }

  /**
   * 设置动效节点的item信息
   *
   * @param item
   */
  public setLastAnimateInfo(item: GridLayoutItemInfo | undefined): void {
    this.mLastAnimateInfo = item;
  }

  /**
   * 获取动效节点的item
   *
   * @returns GridLayoutItemInfo
   */
  public getLastAnimateInfo(): GridLayoutItemInfo | undefined {
    return this.mLastAnimateInfo;
  }

  /**
   * 设置多选落位的文件夹id
   *
   * @param folderId 文件夹id
   */
  public setMultiDropFolderId(folderId: string): void {
    this.multiDropFolderId = folderId;
  }

  /**
   * 获取多选落位的文件夹id
   *
   * @returns 文件夹id
   */
  public getMultiDropFolderId(): string {
    return this.multiDropFolderId;
  }

  /**
   * 设置打开的文件夹id
   *
   * @param folderId 文件夹id
   */
  public setOpenFolderId(folderId: string): void {
    log.showInfo(TAG, `setOpenFolderId folderId:${folderId}`);
    this.mOpenedFolderId = folderId;
  }

  /**
   * 返回打开的文件夹id
   *
   * @returns
   */
  public getOpenFolderId(): string {
    return this.mOpenedFolderId;
  }

  /**
   * 设置当前拖拽离开的文件夹id
   *
   * @param folderId 文件夹id
   */
  public setDragLeaveFolderId(folderId: string): void {
    this.mDragLeaveFolderId = folderId;
  }

  /**
   * 获取当前拖拽离开的文件夹id
   *
   * @returns 文件夹id
   */
  public getDragLeaveFolderId(): string {
    return this.mDragLeaveFolderId;
  }

  /**
   * 设置打开的文件夹
   *
   * @param openedFolder 打开的文件夹
   */
  public setOpenedFolder(openedFolder: GridLayoutItemInfo): void {
    this.mOpenedFolder = openedFolder;
  }

  /**
   * 获取正在打开状态的文件夹folder信息
   * 特别注意，调用者不要修改返回的变量内容，也不要时间持有，避免文件夹删除后，访问到失效的数据
   *
   * @returns 正在打开状态的文件夹folder信息
   */
  public getOpenedFolder(): GridLayoutItemInfo {
    if (this.mOpenedFolder) {
      return this.mOpenedFolder;
    }
    return this.mClosingFolder ?? FolderCommonUtil.getEmptyFolderData();
  }

  /**
   * 设置关闭中的文件夹
   *
   * @param folder
   */
  public setClosingFolder(folder: GridLayoutItemInfo): void {
    this.mClosingFolder = folder;
  }

  /**
   * 返回关闭中的文件夹
   *
   * @returns 文件夹的item
   */
  public getClosingFolder(): GridLayoutItemInfo {
    return this.mClosingFolder as GridLayoutItemInfo;
  }

  /**
   * 设置文件夹拖拽的元素
   *
   * @param dragItem 拖拽的元素
   */
  public setDragItemFolder(dragItem?: GridLayoutItemInfo): void {
    this.mDragItemFolder = dragItem;
  }

  /**
   * 获取文件夹拖拽的元素
   *
   * @returns DragItemFromFolder
   */
  public getDragItemFolder(): GridLayoutItemInfo | undefined {
    return this.mDragItemFolder;
  }

  /**
   * 设置当前要拖拽到文件夹中应用的item
   *
   * @param item 拖拽到文件夹中的应用
   */
  public setDragAppToFolder(item: DragAppToFolderData): void {
    this.mDragAppToFolder = item;
  }

  /**
   * 获取当前要拖拽到文件夹中的应用
   *
   * @returns 拖拽的应用
   */
  public getDragAppToFolder(): DragAppToFolderData {
    return this.mDragAppToFolder;
  }

  /**
   * 设置当前挤位状态
   *
   * @param isSqueezing
   */
  public setIsSqueezing(isSqueezing: boolean): void {
    this.mIsSqueezing = isSqueezing;
  }

  /**
   * 获取当前挤位状态
   *
   * @returns mIsSqueezing
   */
  public getIsSqueezing(): boolean {
    return this.mIsSqueezing;
  }

  /**
   * 设置是否文件夹关闭中
   *
   * @param isFolderClosing
   */
  public setIsFolderClosing(isFolderClosing: boolean): void {
    this.mIsFolderClosing = isFolderClosing;
  }

  /**
   * 获取文件夹是否关闭中
   *
   * @returns mIsFolderClosing
   */
  public isFolderClosing(): boolean {
    return this.mIsFolderClosing;
  }

  /**
   * 获取文件夹是否处于已打开的状态
   *
   * @returns true已打开
   */
  public isFolderOpen(): boolean {
    return (this.mOpenedFolder !== undefined) ? true : false;
  }

  /**
   * 设置文件夹是否在打开关闭动效中
   *
   * @param isFolderChanging
   */
  public setIsFolderChanging(isFolderChanging: boolean): void {
    this.mIsFolderChanging = isFolderChanging;
  }

  /**
   * 获取文件夹是否在动效中的状态
   *
   * @returns true 打开关闭动效中
   */
  public isCanOpenFolderDragDrop(): boolean {
    return !this.mIsFolderChanging;
  }

  /**
   * 设置展开态图标是否可处理touch事件
   *
   * @param isOpenFolderIconTouchEnabled
   */
  public setIsOpenFolderIconTouchEnabled(isOpenFolderIconTouchEnabled: boolean): void {
    this.mIsOpenFolderIconTouchEnabled = isOpenFolderIconTouchEnabled;
  }

  /**
   * 获取当前展开态图标是否可处理touch事件
   *
   * @returns
   */
  public getIsOpenFolderIconTouchEnabled(): boolean {
    return this.mIsOpenFolderIconTouchEnabled;
  }

  /**
   * 设置主题风格
   *
   * @param themeStyle 主题风格
   */
  public setThemeStyle(themeStyle: string): void {
    this.mThemeStyle = themeStyle;
  }

  /**
   * 获取当前主题风格
   *
   * @returns 主题风格
   */
  public getThemeStyle(): string {
    return this.mThemeStyle;
  }

  /**
   * 设置图标大小
   *
   * @param desktopIconChange 图标大小
   */
  public setDesktopIconChange(desktopIconChange: number): void {
    this.mDesktopIconChange = desktopIconChange;
  }

  /**
   * 获取图标大小
   *
   * @returns 图标大小
   */
  public getDesktopIconChange(): number {
    return this.mDesktopIconChange;
  }

  /**
   * 设置多选选中元素的keyname列表
   *
   * @param selectNames 选中元素的keyname列表
   */
  public setSelectItemNames(selectNames: string[]): void {
    this.mSelectedItemNames = selectNames;
  }

  /**
   * 获取多选选中元素的keyname列表
   *
   * @returns 选择元素的keyname列表
   */
  public getSelectItemNames(): string[] {
    return this.mSelectedItemNames;
  }

  /**
   * 设置调整大小的文件夹id
   *
   * @param folderId 文件夹id
   */
  public setResizeFolderId(folderId: string): void {
    this.mResizeFolderId = folderId;
  }

  /**
   * 获取调整大小的文件夹id
   *
   * @returns 调整大小的文件夹id
   */
  public getResizeFolderId(): string {
    return this.mResizeFolderId;
  }

  /**
   * 设置退出到文件夹中应用的位置index
   *
   * @param index 位置index
   */
  public setExitIndex(index: number): void {
    this.mExitIndex = index;
  }

  /**
   * 获取应用退出到文件夹的index
   *
   * @returns
   */
  public getExitIndex(): number {
    return this.mExitIndex;
  }

  /**
   * 获取文件夹列表内应用所在的索引
   * @param item 目标应用
   * @returns 图标在列表中的索引
   */
  public getIndexInFolder(item: GridLayoutItemInfo, folder: GridLayoutItemInfo): number {
    if (!folder || !folder.layoutInfo) {
      return 0;
    }
    let findIndex = folder.layoutInfo.flat().findIndex((idx) => {
      return item?.keyName === idx?.keyName;
    });
    if (findIndex < 0) {
      log.showError(TAG, 'item %{public}s is not found in folder %{public}s', item.keyName, folder.folderId);
      return 0;
    }
    let maxPerPage = FolderCommonUtil.getOpenFolderMaxPerPage();
    if (maxPerPage === 0) {
      log.showError(TAG, `maxPerPage is 0 error,findIndex = ${findIndex}`);
      return findIndex;
    }
    return findIndex % maxPerPage;
  }

  /**
   * 获取文件夹列表内应用所在的页
   * @param item 目标应用
   * @returns 图标所在的page页码
   */
  public getPageIndexInFolder(item: GridLayoutItemInfo, folder: GridLayoutItemInfo): number {
    if (!folder || !folder.layoutInfo) {
      return 0;
    }
    let findIndex = folder.layoutInfo.flat().findIndex((idx) => {
      return item?.keyName === idx?.keyName;
    });
    if (findIndex < 0) {
      log.showError(TAG, 'item %{public}s is not found in folder %{public}s', item.keyName, folder.folderId);
      return 0;
    }
    let maxPerPage = FolderCommonUtil.getOpenFolderMaxPerPage();
    if (maxPerPage === 0) {
      log.showError(TAG, `maxPerPage is 0 error,findIndex = ${findIndex}`);
      return findIndex;
    }
    return Math.floor(findIndex / maxPerPage);
  }

  /**
   * 新增插入文件夹，转换文件夹
   *
   * @param folderItem 文件夹item
   * @param isConvertToSmall 是否转换成小文件
   * @param msg 用于DFX的日志
   * @param isOperateDb true执行数据库操作
   */
  public convertFolderSize(folderItem: GridLayoutItemInfo, isConvertToSmall: boolean, msg: string,
    isOperateDb: boolean = true): void {
    this.folderDataMgr.convertFolderSize(folderItem, isConvertToSmall, msg, isOperateDb);
  }

  /**
   * 更新文件夹的大小size
   *
   * @param msg 用于DFX的日志
   * @param folderItem 文件夹item
   */
  public updateFolderSize(msg: string, folderItem: GridLayoutItemInfo, isDb?: boolean): void {
    this.folderDataMgr.updateFolderSize(msg, folderItem, isDb || false);
  }

  /**
   * 清除文件夹缓存
   *
   * @param folderId 文件夹id
   */
  public deleteFolderCache(msg: string, folderId: string): void {
    this.folderDataMgr.deleteCacheById(msg, folderId);
  }
}

/*
 * 文件夹数据更新的相关生命周期事件，请在ViewModel层使用；允许在回调中修改Model；刷新View
 * 注册实例的方法比注册回调不容易写出内存泄漏
 */
export interface FolderDataListener {
  /* 监听的文件夹Id，如果为空，则监听全量文件夹操作 */
  folderId?: string;

  /* 触发刷新的区域类型桌面或dock */
  refreshType?: number;

  /* 系列callback的唯一名称 */
  description: string;

  /* 回调优先级 */
  priority: FolderLifeCyclePriority;

  /* 获取描述信息，DFX用 */
  getDescription?: () => string;

  /* 新增文件夹 */
  createFolder?: (folder: GridLayoutItemInfo) => void;

  /* 添加应用到文件夹的回调 */
  addToFolder?: (folderId: string, addItems: GridLayoutItemInfo[]) => void;

  /* 删除文件夹 */
  removeFolder?: (folder: GridLayoutItemInfo) => void;

  /* 修改文件夹内容，比如名称、位置、内部图标顺序等 */
  updateFolder?: (folderId: string, updateItems: GridLayoutItemInfo[]) => void;

  /* 更新展开态文件夹 */
  updateOpenFolder?: (updateFolder: GridLayoutItemInfo) => void;

  /* 修改文件内元素二级属性变更，比如包名、图标资源等 */
  updateFolderItems?: (folderId: string, modifiedItems: GridLayoutItemInfo[]) => void;

  /* 更新文件夹名字 */
  updateFolderName?: (folderId: string) => void;
}