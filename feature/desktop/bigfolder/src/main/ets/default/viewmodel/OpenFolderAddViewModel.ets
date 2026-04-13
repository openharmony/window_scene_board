/*
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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ResourceManager, HiSysEventUtil, localEventManager } from '@ohos/frameworkwrapper';
import { PinyinSort } from '@ohos/frameworkpinyin';
import { BusinessType, AppStatus } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import {
  AppCategoryInfoManager,
  AppModel,
  CommonConstants,
  DockItemInfo,
  FolderLayoutCacheManager,
  FolderOperationFlag,
  FolderManager,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LaunchLayoutCacheManager,
  ResidentLayoutCacheMgr,
  FolderCommonUtil,
  ContractedFolderCommonViewModel,
  LayoutViewModel,
  PageDesktopModel,
  LayoutDescription,
  EventConstants,
  FoldersData,
  FolderCommonConstants,
  RdbStoreManager
} from '@ohos/launchercommon';
import FolderAddDialogConstant from '../common/constants/FolderAddDialogConstant';
import { BigFolderViewModel } from './BigFolderViewModel';
import { GridPositionFindUtil, ItemLocation } from '@ohos/launchercommon/Index';

const TAG = 'OpenFolderAddViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
export const folderAddSheetOther: string = 'folder_add_sheet_other';
export const sheetTitleRecommended: string = 'sheet_title_recommended';

/**
 * 文件夹添加应用ViewModel
 */
export class OpenFolderAddViewModel {
  private static sInstance: OpenFolderAddViewModel;
  private folderViewModel: BigFolderViewModel = BigFolderViewModel.getInstance();
  private cacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
  private folderCacheMgr: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
  private mFolderMgr: FolderManager = FolderManager.getInstance();

  /**
   * 获取单例
   */
  static getInstance(): OpenFolderAddViewModel {
    if (OpenFolderAddViewModel.sInstance === undefined) {
      OpenFolderAddViewModel.sInstance = new OpenFolderAddViewModel();
    }
    return OpenFolderAddViewModel.sInstance;
  }

  /**
   * 获取文件夹名称
   */
  getRealFolderName(folderName: string): string {
    return this.folderViewModel.getRealFolderName(folderName);
  }

  /**
   * 获取Dialog中Grid的列显示属性
   *
   * @returns 列显示属性
   */
  getColumnsTemplate(): string {
    let columnsTemplate = '';
    for (let index = 0; index < this.getDialogGridColumns(); index++) {
      columnsTemplate += '1fr ';
    }
    return columnsTemplate.trim();
  }

  /**
   * 获取Dialog中Grid列数
   *
   * @returns Grid列数
   */
  getDialogGridColumns(): number {
    return this.folderViewModel.getAddListColumn();
  }

  /**
   * 获取‘已有应用’
   *
   * @returns ‘已有应用’数据
   */
  getContainsItemList(): GridLayoutItemInfo[] {
    const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    let itemList: GridLayoutItemInfo[] = openFolderData.layoutInfo?.flat() ?? [];
    if (itemList.length > 0 && GridLayoutUtil.isAddIcon(itemList[itemList.length - 1])) {
      itemList.pop();
    }
    return itemList;
  }

  /**
   * 更新选择的元素到文件夹中
   *
   * @param checkedApps 选择的元素
   * @param folderItem 更新的文件夹
   */
  public refreshFolderApps(checkedApps: GridLayoutItemInfo[], folderItem: GridLayoutItemInfo): void {
    this.updateFolderAppList(checkedApps, folderItem);
    OpenFolderAddViewModel.getInstance().reportEvent();
  }

  /**
   * 更新文件夹数据
   *
   * @param checkedList 文件夹中应用数据
   */
  public updateFolderAppList(checkedList: GridLayoutItemInfo[], folderItem: GridLayoutItemInfo): void {
    if (CheckEmptyUtils.isEmpty(folderItem) || CheckEmptyUtils.isEmpty(folderItem.folderId) ||
      folderItem.folderId === FolderCommonConstants.INVALID_FOLDER_ID) {
      log.showError('dialog add item error with error folderInfo');
      return;
    }
    let isRelease = FolderCommonUtil.isNeedReleased(checkedList, folderItem.folderId);
    log.showInfo('update folder %{public}s to release: %{public}s checkedAppLength: %{public}d', folderItem.folderId,
      isRelease, checkedList.length);
    if (isRelease) {
      this.releaseFolder(checkedList, folderItem);
      ContractedFolderCommonViewModel.getInstance().closeFolder('dialog release', FolderOperationFlag.IMMEDIATELY);
    } else {
      this.updateAllFolder(checkedList, folderItem);
    }
  }

  private updateAllFolder(checkedList: GridLayoutItemInfo[], folderItem: GridLayoutItemInfo): void {
    let items: GridLayoutItemInfo[] = FolderCommonUtil.getFilterAppListInFolder(folderItem);
    // 从当前文件夹移除到桌面元素
    let moveOutItems: GridLayoutItemInfo[] = this.getMoveOutItems(checkedList, items);
    // 从桌面，dock区或文件夹移入到文件夹
    let moveInItems: GridLayoutItemInfo[] = this.getMoveInItems(checkedList, items);
    let itemInFolder: GridLayoutItemInfo[] = [];
    let itemInDock: GridLayoutItemInfo[] = [];
    let itemInDesktop: GridLayoutItemInfo[] = [];
    moveInItems.forEach(item => {
      if (!item.container || item.container === CommonConstants.CONTAINER_DESKTOP) {
        itemInDesktop.push(item);
      } else if (item.container === CommonConstants.CONTAINER_DOCK) {
        itemInDock.push(item);
      } else {
        itemInFolder.push(item);
      }
    });
    log.showInfo('dialog add moveOutLength: %{public}d, moveInLength: %{public}d itemInFolder: %{public}d itemInDock:' +
      ' %{public}d', moveOutItems.length, moveInItems.length, itemInFolder.length, itemInDock.length);
    // 删除空白页
    let pages: number[] = this.getAppFromDesktopPages(itemInDesktop);
    // 删除桌面元素
    this.deleteItemInDesktop(itemInDesktop);
    // 删除dock元素
    this.deleteItemInDock(itemInDock);
    // 删除文件夹中元素
    this.deleteItemInFolder(folderItem, itemInFolder);
    // 添加元素到文件夹
    checkedList = this.reArrangeList(folderItem, checkedList);
    if (folderItem.id) {
      this.addToFolder(folderItem, checkedList);
    } else {
      this.addFolderAfterSelectId(folderItem, checkedList)
    }
    // 文件夹中移除元素添加到桌面
    this.addToDesktop(moveOutItems);
    this.deleteBlankPage(pages);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
  }

  private releaseFolder(checkedList: GridLayoutItemInfo[], folderItem: GridLayoutItemInfo): void {
    let items: GridLayoutItemInfo[] = FolderCommonUtil.getFilterAppListInFolder(folderItem);
    let moveOutItems: GridLayoutItemInfo[] = this.getMoveOutItems(checkedList, items);
    if (folderItem.container === CommonConstants.CONTAINER_DOCK) {
      this.releaseOnDock(checkedList, folderItem);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_DELETE, folderItem);
      // 移除元素添加到桌面
      this.addToDesktop(moveOutItems);
    } else {
      this.folderCacheMgr.deleteGridLayoutItemByItemId(folderItem.folderId, 'from folder by ReleaseFolder', true);
      // 移除元素添加到桌面
      checkedList.push(...moveOutItems);
      this.addToDesktop(checkedList);
    }
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
  }

  private addToDesktop(moveOutItems: GridLayoutItemInfo[]): void {
    if (moveOutItems.length <= 0) {
      return;
    }
    let curPage: number = PageDesktopModel.getInstance().getPageIndex();
    let maxPageCount: number = LaunchLayoutCacheManager.getInstance().selectLayoutDescription().maxPage;
    this.findBlankPosition(curPage, maxPageCount, moveOutItems);
  }

  private releaseOnDock(appInfos: GridLayoutItemInfo[], folderItem: GridLayoutItemInfo): void {
    if (!appInfos || appInfos.length !== CommonConstants.FOLDER_APP_VALUE) {
      return;
    }
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let folderIndex: number = residentList.findIndex((item) => {
      return item.keyName === folderItem.keyName;
    });
    log.showInfo('dockAddItem folderIndex: %{public}d', folderIndex);
    if (folderIndex >= 0) {
      residentList.splice(folderIndex, 0, AppModel.getInstance().gridLayoutToDockItem(appInfos[0]));
      LayoutViewModel.getInstance().updateResidentDockLayout(TAG.concat('_addItem'), residentList);
    }
  }

  private deleteItemInDesktop(itemInDesktop: GridLayoutItemInfo[]): void {
    for (let i = 0; i < itemInDesktop.length; i++) {
      this.folderCacheMgr.deleteAppItemByKeyName(itemInDesktop[i].keyName, BusinessType.BUSINESS_FOLDER, false, false);
    }
  }

  private deleteItemInDock(itemInDock: GridLayoutItemInfo[]): void {
    let dockItems: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    for (let i = 0; i < itemInDock.length; i++) {
      dockItems = dockItems.filter(item => item.keyName !== itemInDock[i].keyName);
    }
    ResidentLayoutCacheMgr.getInstance().updateAllDockItems('dialog add', dockItems, false);
  }

  private deleteItemInFolder(folderItem: GridLayoutItemInfo, itemInFolder: GridLayoutItemInfo[]): void {
    let folderMgr: FolderManager = FolderManager.getInstance();
    let folders: FoldersData[] =
      folderMgr.getFolders().filter(folder => folder.getGridInfo().folderId !== folderItem.folderId);
    folderMgr.batchDeleteInFolders('dialog add', itemInFolder, folders, true);
  }

  private addFolderAfterSelectId(folderItem: GridLayoutItemInfo, checkedList: GridLayoutItemInfo[]): void {
    let folderId: string =
      (folderItem.container === CommonConstants.CONTAINER_DOCK ? folderItem.keyName : folderItem.folderId) as string;
    RdbStoreManager.getInstance().queryRecordByInfoId(folderId).then(
      (rdbFolderItem: GridLayoutItemInfo | undefined) => {
      if (rdbFolderItem && rdbFolderItem.id) {
        folderItem.id = rdbFolderItem.id;
      }
      this.addToFolder(folderItem, checkedList);
    });
  }

  private addToFolder(folderItem: GridLayoutItemInfo, checkedList: GridLayoutItemInfo[]): void {
    log.showInfo('add item length %{public} to folder id %{public}d', checkedList.length, folderItem.id);
    checkedList.forEach(appInfo => appInfo.container = folderItem.id);
    const openFolderId: string = this.mFolderMgr.getOpenedFolder().folderId as string;
    if (folderItem.folderId === openFolderId) {
      this.mFolderMgr.updateOpenFolderLayout('dialogAdd refresh', checkedList, true);
    } else {
      this.mFolderMgr.updateFolderLayoutWithDb('dialogAdd refresh', folderItem.folderId, checkedList, true);
    }
  }

  /**
   * 保证文件原有元素顺序不变
   *
   * @param folderItem 文件夹item
   * @param checkAppList 已选应用列表
   * @returns
   */
  private reArrangeList(folderItem: GridLayoutItemInfo, checkAppList: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    let originItems: GridLayoutItemInfo[] = folderItem.layoutInfo?.flat() ?? [];
    let newItemList: GridLayoutItemInfo[] = [];
    originItems.forEach(item => {
      let idx: number = checkAppList.findIndex(element => GridLayoutUtil.generateUniqueKey(element) ===
      GridLayoutUtil.generateUniqueKey(item));
      if (idx >= 0) {
        newItemList.push(checkAppList[idx]);
        checkAppList.splice(idx, 1);
      }
    });
    newItemList.push(...checkAppList);
    return newItemList;
  }

  private getMoveOutItems(checkedList: GridLayoutItemInfo[], items: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    let result: GridLayoutItemInfo[] = [];
    items.forEach(item => {
      if (checkedList.findIndex(checkedItem => GridLayoutUtil.generateUniqueKey(item) ===
      GridLayoutUtil.generateUniqueKey(checkedItem)) < 0) {
        result.push(item);
      }
    });
    return result;
  }

  private getMoveInItems(checkedList: GridLayoutItemInfo[], items: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    let result: GridLayoutItemInfo[] = [];
    checkedList.forEach(item => {
      if (items.findIndex(checkedItem => GridLayoutUtil.generateUniqueKey(item) ===
      GridLayoutUtil.generateUniqueKey(checkedItem)) < 0) {
        result.push(item);
      }
    });
    return result;
  }

  // 获取从桌面添加到文件夹中的应用所在桌面时的页码集合
  private getAppFromDesktopPages(appInfos: GridLayoutItemInfo[]): number[] {
    let pages: number[] = [];
    for (let appInfo of appInfos) {
      if (appInfo.container === CommonConstants.CONTAINER_DESKTOP && appInfo.page !== undefined &&
        !pages.includes(appInfo.page)) {
        pages.push(appInfo.page);
      }
    }
    log.showInfo(`getFromDesktopPages: ${pages}`);
    return pages;
  }

  /**
   * 删除空白页
   */
  private deleteBlankPage(desktopPages: number[]): void {
    log.showInfo('deleteBlankPage start');
    let pageCount: number = this.folderCacheMgr.selectPageCount();
    for (let i = pageCount - 1; i >= 0; i--) {
      if (desktopPages.includes(i)) {
        PageDesktopModel.getInstance().deleteBlankPageFromLayoutInfo(i);
      }
    }
    log.showInfo('deleteBlankPage end');
  }

  /**
   * 从当前屏开始找位：
   * 1、当前屏及以后，有空位，更新缓存和数据；
   * 2、无空位，未满18屏，新增一屏；
   * 3、满18屏，从首屏后一屏至当前屏找空位
   * 4、无空位，合并或加入文件夹
   *
   * @param curPage 当前页数
   * @param maxPageCount 最大页数
   * @param appsAddToDesktop 需要添加到桌面的所有应用
   */
  private findBlankPosition(curPage: number, maxPageCount: number, appsAddToDesktop: GridLayoutItemInfo[]): void {
    let nextIndex: number = this.batchFindBlankPosition(curPage, maxPageCount, appsAddToDesktop);
    if (nextIndex >= appsAddToDesktop.length) {
      return;
    }
    appsAddToDesktop.splice(0, nextIndex);
    log.showInfo('find position for restApp %{public}d after delete %{public}d', appsAddToDesktop.length, nextIndex);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_BATCH_UPDATE_ITEM_POSITION, appsAddToDesktop);
  }

  /**
   * 从当前屏到指定屏开始找位，不处理满屏后添加到文件夹场景：
   *
   * @param startPage 开始页
   * @param endPage 结束页
   * @param appsAddToDesktop 需要添加到桌面的所有应用
   */
  private batchFindBlankPosition(startPage: number, endPage: number, appsAddToDesktop: GridLayoutItemInfo[]): number {
    let startIdx: number = 0;
    let pageCount: number = this.cacheManager.selectPageCount();
    let layoutDescription: LayoutDescription = this.cacheManager.selectLayoutDescription();
    let maxRow: number = layoutDescription.row;
    let maxCol: number = layoutDescription.column;
    let maxPage: number = layoutDescription.maxPage;
    let locationItemList: GridLayoutItemInfo[] = [];
    const itemLocation: ItemLocation = GridPositionFindUtil.getStartFindItemLocation(startPage, 0, 0);
    while (startIdx < appsAddToDesktop.length && itemLocation.curPage <= endPage && itemLocation.curPage < maxPage) {
      let item: GridLayoutItemInfo = appsAddToDesktop[startIdx];
      // 处理超过18屏或结束页
      if (itemLocation.curPage >= maxPage || itemLocation.curPage > endPage) {
        break;
      }
      // 当前最后一屏新建页情况直接遍历赋值找位
      if (itemLocation.curPage >= pageCount) {
        GridPositionFindUtil.findBlankPositionWithoutVerify(maxRow, maxCol, itemLocation);
        let gridLayout: GridLayoutItemInfo = GridLayoutUtil
          .buildGridLayoutInfoFromItemInfo(item, itemLocation.findPage, itemLocation.findCol, itemLocation.findRow);
        locationItemList.push(gridLayout);
        startIdx++
        continue;
      }
      // 从已有页数空位找位放置true需要循环遍历继续找位，false已经找位成功
      let isNeedFindPosition: boolean = true;
      while (isNeedFindPosition) {
        // 超过18屏或结束页
        if (itemLocation.curPage >= maxPage || itemLocation.curPage > endPage) {
          isNeedFindPosition = true;
          break;
        }
        // 当前最后一屏新建页直接变量赋值找位
        if (itemLocation.curPage >= pageCount) {
          GridPositionFindUtil.findBlankPositionWithoutVerify(maxRow, maxCol, itemLocation);
          isNeedFindPosition = false;
          break;
        }
        isNeedFindPosition =
          !GridPositionFindUtil.findBlankPositionFromOnePage(maxRow, maxCol, maxPage, item, itemLocation);
      }
      if (!isNeedFindPosition) {
        let gridLayout: GridLayoutItemInfo = (item.typeId === CommonConstants.TYPE_APP) ? GridLayoutUtil
          .buildGridLayoutInfoFromItemInfo(item, itemLocation.findPage, itemLocation.findCol, itemLocation.findRow) :
          GridLayoutUtil.updateGridLayoutInfoPosition(item, itemLocation.findPage, itemLocation.findCol,
          itemLocation.findRow);
        gridLayout.container = CommonConstants.CONTAINER_DESKTOP;
        gridLayout.areaType = CommonConstants.TYPE_AREA_DESKTOP;
        locationItemList.push(gridLayout);
        startIdx++;
      }
    }
    if (!CheckEmptyUtils.isEmptyArr(locationItemList)) {
      this.cacheManager.insertGridLayoutItemList(locationItemList, BusinessType.BUSINESS_BASIC_DESKTOP, true);
      let curPage: number = this.cacheManager.selectPageCount();
      this.cacheManager.updatePageCount(Math.max(itemLocation.findPage + 1, curPage),
        BusinessType.BUSINESS_BASIC_DESKTOP, true);
    }
    return startIdx;
  }

  translateList(checkedList: GridLayoutItemInfo[]): GridLayoutItemInfo[][] {
    return this.folderViewModel.translateFolderLayout(checkedList);
  }

  /**
   * 数据打点
   */
  reportEvent(): void {
    const folderId: string = this.mFolderMgr.getOpenFolderId();
    const isCardFolder: boolean = GridLayoutUtil.isBigFolder(this.mFolderMgr.getOpenedFolder());
  }

  private categorizeApps(allApps: FolderAddItemInfo[], categorizedApps: FolderAddItemInfo[],
    recommendedCategories : Map<number | undefined, string>, includeOthers: boolean) {

    let index = 0;
    recommendedCategories.forEach((catName, catId) => {
      const folderAddItemIfo = new FolderAddItemInfo();
      folderAddItemIfo.type = FolderAddItemInfoType.Title;
      folderAddItemIfo.catName = catName;
      folderAddItemIfo.subTitlePaddingTop = index ? '15vp' : '1vp';

      const categoryApps = allApps.filter(app => app.catId === catId);
      allApps = allApps.filter(app => app.catId !== catId)
      categorizedApps.push(folderAddItemIfo, ...categoryApps)
      index++;
    })
    if (includeOthers) {
      if (categorizedApps.length > 0) {
        const folderAddItemIfo = new FolderAddItemInfo();
        folderAddItemIfo.type = FolderAddItemInfoType.Title;
        folderAddItemIfo.catName = folderAddSheetOther;
        categorizedApps.push(folderAddItemIfo);
      }
      categorizedApps.push(...allApps);
    }
    this.getSheetTitle(categorizedApps);
  }

  private getSheetTitle(categorizedApps: FolderAddItemInfo[]): void {
    if (categorizedApps.findIndex((item) => item.type === FolderAddItemInfoType.Title) > -1) {
      const folderAddItemIfo = new FolderAddItemInfo();
      folderAddItemIfo.type = FolderAddItemInfoType.Title;
      folderAddItemIfo.catName = sheetTitleRecommended;
      categorizedApps.unshift(folderAddItemIfo);
    }
  }

  public getAllFolderAddItemInfos(containsList: GridLayoutItemInfo[], includeOthers: boolean): FolderAddItemInfo[] {
    let appList: FolderAddItemInfo[] = [];
    const folderAddItemInfos: FolderAddItemInfo[] = [];
    this.addOtherApp(appList, containsList);
    this.setFolderAddItemInfoCatId(appList);
    this.checkApps(appList, containsList);
    const recommendedCategories = this.getRecommendedCategoryMap(containsList);
    this.categorizeApps(appList, folderAddItemInfos, recommendedCategories, includeOthers);
    return folderAddItemInfos;
  }

  private setFolderAddItemInfoCatId(appList: FolderAddItemInfo[]): void {
    appList.forEach((item: FolderAddItemInfo) => {
      item.catId = AppCategoryInfoManager.getInstance().readCatIdFromCache(item.itemInfo.bundleName);
    });
  }

  public getRecommendedCategoryMap(containAppList: GridLayoutItemInfo[]): Map<number | undefined, string> {
    const catIdMap: Map<number | undefined, string> = new Map();
    const appList: FolderAddItemInfo[] = [];
    this.addContainsApp(appList, containAppList);
    this.setFolderAddItemInfoCatId(appList);

    const uniqueCatIds = new Set(appList.filter((item) => item.catId !== undefined &&
      AppCategoryInfoManager.getInstance().catIdExist(item.catId))
      .map((item) => item.catId?.toString()));
    if (uniqueCatIds.size > 2 || uniqueCatIds.size === 0) {
      return new Map();
    } else {
      const sortedCatIds = Array.from(uniqueCatIds).sort();
      sortedCatIds.forEach(catId => catIdMap.set(parseInt(catId!),
        AppCategoryInfoManager.getInstance().getAppCatName(parseInt(catId!)) ?? ''));
      return catIdMap;
    }
  }

  public isFolderContainAnyCategory(folderItem: GridLayoutItemInfo): boolean {
    const appList: GridLayoutItemInfo[] = [];
    this.appendFolderAppsToList(folderItem, appList);
    const categoryMap: Map<number | undefined, string> = this.getRecommendedCategoryMap(appList);
    return categoryMap.size ? true : false;
  }

  private sortGridLayoutItemInfos(gridLayoutInfoList: GridLayoutItemInfo[]): void {
    const pinyinSort: PinyinSort = new PinyinSort();
    const resourceManager: ResourceManager = ResourceManager.getInstance();

    const cacheKeys: Map<string, string> = new Map();
    gridLayoutInfoList.forEach((gridLayoutInfo) => {
      cacheKeys.set(gridLayoutInfo.keyName ?? '', this.getAppName(gridLayoutInfo, resourceManager));
    });

    gridLayoutInfoList.sort((a: GridLayoutItemInfo, b: GridLayoutItemInfo) => {
      return pinyinSort.sortByParameter(cacheKeys.get(a.keyName) ?? '', cacheKeys.get(b.keyName) ?? '');
    });
  }

  private getAppName(gridLayoutInfo : GridLayoutItemInfo, resourceManager: ResourceManager) : string {
    let appName = gridLayoutInfo.appName;
    if (!appName) {
      const cacheKey: string = `${gridLayoutInfo.appLabelId}${gridLayoutInfo.bundleName}${gridLayoutInfo.moduleName}`;
      appName = resourceManager.getAppResourceCache(cacheKey, 'name') as string;
    }
    if(!appName) {
      appName = resourceManager.getBundleAppName(gridLayoutInfo.bundleName);
    }
    return appName ?? '';
  }

  private getAllApps(): GridLayoutItemInfo[] {
    const appList:GridLayoutItemInfo[] = this.cacheManager.getAllApps();
    this.sortGridLayoutItemInfos(appList);
    return appList;
  }

  public appendFolderAppsToList(folderItem: GridLayoutItemInfo, appList: GridLayoutItemInfo[]): void {
    this.cacheManager.appendFolderAppsToList(folderItem, appList);
  }

  private checkApps(appList: FolderAddItemInfo[], containsList: GridLayoutItemInfo[]): void {
    const reversedContains = [...containsList].reverse();
    reversedContains.forEach((item: GridLayoutItemInfo) => {
      const index = appList.findIndex(app => app.itemInfo.keyName === item.keyName);
      if (index !== -1) {
        appList[index].isChecked = true;
        const element = appList.splice(index, 1);
        appList.unshift(...element);
      }
    });
  }

  /**
   * 添加‘已有应用’
   *
   * @param appList Dialog列表数据
   * @param containsList 已有应用
   */
  private addContainsApp(appList: FolderAddItemInfo[], containsList: GridLayoutItemInfo[]): void {
    containsList.forEach((item: GridLayoutItemInfo) => {
      let containItem: FolderAddItemInfo = new FolderAddItemInfo();
      containItem.isChecked = true;
      containItem.itemInfo = item;
      appList.push(containItem);
    });
  }

  /**
   * 添加‘其他应用’
   *
   * @param appList Dialog列表数据
   */
  private addOtherApp(appList: FolderAddItemInfo[], containsList: GridLayoutItemInfo[]): void {
    let allAppList: GridLayoutItemInfo[] = this.getAllApps();

    if (allAppList?.length > 0) {
      allAppList.forEach((item: GridLayoutItemInfo) => {
        return;
      });
    }

    containsList.forEach((item: GridLayoutItemInfo) => {
      if (item.appStatus !== AppStatus.INSTALLED) {
        let containItem: FolderAddItemInfo = new FolderAddItemInfo();
        containItem.itemInfo = item;
        appList.push(containItem);
      }
    });
  }
}

export enum FolderAddItemInfoType {
  Title = 'title',
  GridItem = 'gridItem'
}

/**
 * 文件夹+号 dialog 中的数据Bean
 */
@Observed
export class FolderAddItemInfo {
  public type: FolderAddItemInfoType = FolderAddItemInfoType.GridItem;
  public isChecked: boolean = false;
  public itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
  public catId: number | undefined;
  public catName: string | undefined;
  public subTitlePaddingTop: string = FolderAddDialogConstant.DEFAULT_SUBTITLE_TOP_PADDING;
}