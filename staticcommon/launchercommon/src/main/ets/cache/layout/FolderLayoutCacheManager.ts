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

import { CheckEmptyUtils, LogDomain, LogHelper, CommonUtils } from '@ohos/basicutils';
import { localEventManager } from '@ohos/frameworkwrapper';
import { AppItemInfo } from '../../bean/AppItemInfo';
import BadgeItemInfo from '../../bean/BadgeItemInfo';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { AppStatus, BusinessType, CommonConstants } from '../../constants/CommonConstants';
import { EventConstants } from '../../constants/EventConstants';
import { FolderModel } from '../../folder/FolderModel';
import { BaseLayoutCacheManager } from './BaseLayoutCacheManager';
import { DesktopLayoutCacheData } from './DesktopLayoutCacheData';
import { ILayoutCacheManager } from './ILayoutCacheManager';
import { LauncherLayoutCacheUtil } from './LauncherLayoutCacheUtil';
import { GridLayoutUtil, PageDesktopModel, RdbStoreManager,
  DockItemInfo,
  NotHarmonyUtil,
  ResidentLayoutCacheMgr,
  FolderManager,
  DesktopUtils,
} from '../../TsIndex';
import { FoldersData } from '../../folder/next/common/model/data/FoldersData';

const TAG = 'FolderLayoutCacheManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class FolderLayoutCacheManager extends BaseLayoutCacheManager implements ILayoutCacheManager {
  private static instance: FolderLayoutCacheManager;
  private mfoldLayoutChangeListener: Function = (list: GridLayoutItemInfo[]) => {};
  private waitAddFordleInfos: GridLayoutItemInfo[] = [];
  private foldersData: Map<string, FoldersData> = new Map<string, FoldersData>();
  private folderCacheListener: () => void = () => this.foldersData.clear();

  static getInstance(): FolderLayoutCacheManager {
    if (FolderLayoutCacheManager.instance == null) {
      FolderLayoutCacheManager.instance = new FolderLayoutCacheManager();
    }
    return FolderLayoutCacheManager.instance;
  }

  private constructor() {
    super();
  }

  setListener(foldLayoutChangeListener: Function) : void {
    this.mfoldLayoutChangeListener = foldLayoutChangeListener;
    this.layoutCacheData.setListener(this.mfoldLayoutChangeListener);
  }

  public reInit(layoutCacheData: DesktopLayoutCacheData): void {
    super.reInit(layoutCacheData);
    this.foldersData.clear();
    layoutCacheData.setFolderCacheListener(this.folderCacheListener);
    layoutCacheData.setListener(this.mfoldLayoutChangeListener);
    layoutCacheData.updateLayoutListCacheAndPrebuild(layoutCacheData.getGridLayoutItemList());
  }

  /**
   * 设置文件夹数据
   *
   * @param foldersData 文件夹数据
   */
  public setFoldersData(foldersData: Map<string, FoldersData>): void {
    log.showInfo('init folder cache');
    this.foldersData = foldersData;
  }

  selectGridLayoutItemByFolderId(folderId: string, isOuter?: boolean): GridLayoutItemInfo | undefined {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    return gridLayoutItemList.find(item => item.typeId === CommonConstants.TYPE_FOLDER && item.folderId === folderId);
  }

  selectGridLayoutItemByPosition(page: number, row: number, col: number): GridLayoutItemInfo | undefined {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    return gridLayoutItemList.find(item => item.typeId === CommonConstants.TYPE_FOLDER && item.page === page &&
      item.row === row && item.column === col);
  }

  selectGridLayoutItemByIndex(index: number): GridLayoutItemInfo | undefined {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    if (index < 0 || index >= gridLayoutItemList.length || CheckEmptyUtils.isEmptyArr(gridLayoutItemList)) {
      return undefined;
    }
    let folderItem = gridLayoutItemList[index];
    if (folderItem.typeId !== CommonConstants.TYPE_FOLDER) {
      return undefined;
    }
    return folderItem;
  }

  selectAllFolders(isOuter?: boolean): GridLayoutItemInfo[] {
    const gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    const residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let folders = gridLayoutItemList.filter(item => item.typeId === CommonConstants.TYPE_FOLDER);
    residentList.forEach(item => {
      if (item.typeId === CommonConstants.TYPE_FOLDER) {
        let gridItem: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(item);
        gridItem.folderId = gridItem.keyName;
        folders.push(gridItem);
      }
    });
    return folders;
  }

  selectIndexInLayoutForAllApps(item: GridLayoutItemInfo): number {
    let folders: GridLayoutItemInfo[] = this.selectAllFolders();
    return folders.findIndex(folder => folder.folderId === item.folderId);
  }

  /**
   * 查询桌面上的文件夹
   *
   * @returns 桌面的文件夹
   */
  public selectFoldersOnDesktop(isOuter?: boolean): GridLayoutItemInfo[] {
    const gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    let folders = gridLayoutItemList.filter(item => item.typeId === CommonConstants.TYPE_FOLDER);
    return folders;
  }

  /**
   * 根据folderId获取index
   *
   * @param folderId 文件夹的folderId
   * @returns 在布局中的index
   */
  selectIndexByFolderId(folderId: string): number {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    return gridLayoutItemList.findIndex(item => item.folderId === folderId);
  }

  /**
   * 查询并检查已安装应用的文件夹
   *
   * @param installedAppInfoList 已安装应用列表
   * @param isOuter 是否是外屏
   * @returns 文件夹列表
   */
  selectAllFoldersWithAppCheck(installedAppInfoList: AppItemInfo[], isOuter: boolean): GridLayoutItemInfo[] {
    let folderList: GridLayoutItemInfo[] = [];
    if (CheckEmptyUtils.isEmptyArr(installedAppInfoList)) {
      log.showWarn('selectAllFoldersWithAppCheck error as the');
      return folderList;
    }
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    let newItemList: GridLayoutItemInfo[] = this.getNewItemList(gridLayoutItemList, installedAppInfoList, folderList);
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(newItemList, isOuter);
    return folderList;
  }

  private getNewItemList(gridLayoutItemList: GridLayoutItemInfo[], installedAppInfoList: AppItemInfo[],
    folderList: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    return gridLayoutItemList.filter(item => {
      if (item.typeId !== CommonConstants.TYPE_FOLDER) {
        return true;
      } else {
        if (!item.layoutInfo) {
          return false;
        }
        // 去除文件夹中未安装的应用后文件夹中至少需要有2个应用
        item.layoutInfo = item.layoutInfo.map(folderPage =>
        folderPage.filter(itemInPage => itemInPage.typeId !== CommonConstants.TYPE_APP ||
          itemInPage.appStatus !== AppStatus.INSTALLED ||
        installedAppInfoList.some(app => {
          return app.keyName === itemInPage.keyName;
        })
        ));
        if (item.layoutInfo.flat().length >= CommonConstants.FOLDER_APP_VALUE &&
          (NotHarmonyUtil.isNotHarmonyFolderByIntent(item.intent) || item.folderName === '${not_harmony_apps}')) {
          log.showInfo('init custom folder in desktop');
          let map: Map<string, Object> = CommonUtils.jsonStrToMap(item.intent);
          if (!map.has(NotHarmonyUtil.NOT_HARMONY_FOLDER_KEY_NAME_FOR_INTENT)) {
            let intentMap: Map<string, string> = new Map();
            intentMap.set(NotHarmonyUtil.NOT_HARMONY_FOLDER_KEY_NAME_FOR_INTENT, item.folderId ?? '');
            item.intent = CommonUtils.mapToJonStr(intentMap);
            RdbStoreManager.getInstance().updateFolderIntentByInfoId(item.folderId ?? '', item.intent);
          }
          NotHarmonyUtil.setNotHarmonyFolderId(item.folderId ?? '');
          NotHarmonyUtil.queryAndLightDeliverApp(item.layoutInfo?.flat());
        }
        let isCanHaveOneAppFolder = item.layoutInfo.flat().length === CommonConstants.FOLDER_APP_VALUE &&
        NotHarmonyUtil.isNotHarmonyFolderById(item?.folderId);
        let isFolder = item.layoutInfo.flat().length > CommonConstants.FOLDER_APP_VALUE || isCanHaveOneAppFolder;
        if (isFolder) {
          folderList.push(item);
        } else {
          log.showInfo(`itemsInFolder count less 2, folderId: ${item.folderId}, count: ${item.layoutInfo.flat().length}`);
        }
        return isFolder;
      }
    });
  }

  /**
   * 根据应用列表查询item
   *
   * @param appInfos 应用列表
   * @returns item 列表
   */
  selectGridLayoutItemsByAppList(appInfos: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(false);
    let res: GridLayoutItemInfo[] = [];
    for (const appInfo of appInfos) {
      for (const item of gridLayoutItemList) {
        if (item.typeId === CommonConstants.TYPE_APP &&
          appInfo.keyName === item.keyName) {
          res.push(item);
          break;
        }
      }
    }
    return res;
  }

  /**
   * 查询快捷图标所在的文件夹
   */
  selectFolderByContainShortCut(shortcut: GridLayoutItemInfo): GridLayoutItemInfo | undefined {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    let folderList: GridLayoutItemInfo[] = gridLayoutItemList.filter(item => item.typeId === CommonConstants.TYPE_FOLDER);
    let res: GridLayoutItemInfo | undefined = undefined;
    for (const item of folderList) {
      const folderAppList: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.layoutInfoToList(item);
      let app: GridLayoutItemInfo | undefined = folderAppList.find(appItem => LauncherLayoutCacheUtil
        .isSameShortcutApp(shortcut, appItem.bundleName, appItem.shortcutId ?? '', appItem.appIndex ?? 0));
      if (app) {
        res = item;
        break;
      }
    }
    return res;
  }

  /**
   * 查询应用所在文件夹
   *
   * @param bundleName 应用包名
   * @returns 文件夹
   */
  selectFolderByContainApp(bundleName: string): GridLayoutItemInfo[] {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(false);
    let folderList: GridLayoutItemInfo[] = gridLayoutItemList.filter(item => item.typeId === CommonConstants.TYPE_FOLDER);
    let result: GridLayoutItemInfo[] = [];
    for (const item of folderList) {
      const folderAppList: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.layoutInfoToList(item);
      let app: GridLayoutItemInfo | undefined = folderAppList.find(appItem => appItem.bundleName === bundleName);
      if (app) {
        result.push(item);
      }
    }
    return result;
  }

  /**
   * 根据UniqueKey查询应用
   *
   * @param uniqueKey 唯一id
   * @returns 结果
   */
  selectFolderByGenerateUniqueKey(uniqueKey: string): GridLayoutItemInfo[] {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(false);
    let folderList: GridLayoutItemInfo[] =
      gridLayoutItemList.filter(item => item.typeId === CommonConstants.TYPE_FOLDER);
    let result: GridLayoutItemInfo[] = [];
    for (const item of folderList) {
      const folderAppList: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.layoutInfoToList(item);
      let app: GridLayoutItemInfo | undefined =
        folderAppList.find(appItem => GridLayoutUtil.generateUniqueKey(appItem) === uniqueKey);
      if (app) {
        result.push(app);
        break;
      }
    }
    return result;
  }

  /**
   * 查询应用所在文件夹
   *
   * @param bundleName 应用包名
   * @returns 文件夹
   */
  selectFolderByBundleNameAndAbilityName(bundleName: string, abilityName: string,
                                         modeuleName: string, typeId: number): GridLayoutItemInfo | undefined {
    let gridLayoutItemList = this.layoutCacheData.getGridLayoutItemList();
    let folderList: GridLayoutItemInfo[] = gridLayoutItemList.filter(item => item.typeId === CommonConstants.TYPE_FOLDER);
    let res: GridLayoutItemInfo | undefined = undefined;
    for (const item of folderList) {
      const folderAppList: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.layoutInfoToList(item);
      let app: GridLayoutItemInfo | undefined = folderAppList.find(appItem =>
        appItem.bundleName === bundleName && appItem.abilityName === abilityName &&
        appItem.moduleName === modeuleName && appItem.typeId === typeId);
      if (app) {
        res = item;
        break;
      }
    }

    return res;
  }

  /**
   * 查询应用所在文件夹
   *
   * @param keyName 应用keyName
   * @returns 文件夹
   */
  selectFolderByKeyName(keyName: string): GridLayoutItemInfo | undefined {
    let folderList: GridLayoutItemInfo[] = this.selectAllFolders();
    let res: GridLayoutItemInfo | undefined = undefined;
    for (const item of folderList) {
      const folderAppList: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.layoutInfoToList(item);
      let app: GridLayoutItemInfo | undefined = folderAppList.find(appItem => appItem.keyName === keyName);
      if (app) {
        res = item;
        break;
      }
    }
    return res;
  }

  deleteGridLayoutItemByItemId(id: string | number, label: string, isOperateDb: boolean = true): void {
    log.showInfo('deleteFolderItemByFolderId with id %{public}s from %{public}s db %{public}s',
      String(id), label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    let deleteItem = gridLayoutItemList.find(item => item.folderId === id && id !== undefined);
    if (CheckEmptyUtils.isEmpty(deleteItem)) {
      log.showWarn('deleteGridLayoutItemByItemId error with null item');
      return;
    }
    let filter = (item: GridLayoutItemInfo): boolean => item.folderId !== id;
    let newGridLayoutItemList: GridLayoutItemInfo[] = gridLayoutItemList.filter(filter);
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(newGridLayoutItemList);
    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.deleteFolderItemCallBack(deleteItem);
      } catch (error) {
        log.showError(`deleteFolderItemByFolderId with error %{public}s`, error.message);
      }
    }
  }

  private judgeSamePageItem(currentItem: GridLayoutItemInfo, targetItem: GridLayoutItemInfo): boolean {
    if (currentItem.typeId !== targetItem.typeId || currentItem.page !== targetItem.page) {
      return false;
    }
    if (currentItem.typeId === CommonConstants.TYPE_APP && currentItem.keyName === targetItem.keyName) {
      return true;
    }
    if (currentItem.typeId === CommonConstants.TYPE_CARD && currentItem.cardId === targetItem.cardId) {
      return true;
    }
    if (currentItem.typeId === CommonConstants.TYPE_CARD && currentItem.cardId === targetItem.cardId) {
      return true;
    }
    if (currentItem.typeId === CommonConstants.TYPE_FORM_STACK && currentItem.formStackId === targetItem.formStackId) {
      return true;
    }
    if (currentItem.typeId === CommonConstants.TYPE_FOLDER && currentItem.folderId === targetItem.folderId &&
      currentItem.area && targetItem.area && currentItem.area[0] === targetItem.area[0] &&
      currentItem.area[1] === targetItem.area[1]) {
      return true;
    }
    if (currentItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON && currentItem.shortcutId === targetItem.shortcutId) {
      return true;
    }
    return false;
  }

  /**
   * 根据folderId批量删除桌面元素
   * @param folderIdList 需要删除的folderId数组
   * @param label 调用方信息
   * @param isOperateDb 是否要写入数据库
   */
  public deleteGridLayoutItemByFolderIdList(folderIdList: Array<string | number>, label: string, isOperateDb: boolean = true): void {
    log.showInfo('deleteFolderItemByFolderId with id %{public}s from %{public}s db %{public}s',
      String(folderIdList.toString()), label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    const deleteItemList: GridLayoutItemInfo[] = [];
    let newGridLayoutItemList: GridLayoutItemInfo[] = gridLayoutItemList.filter(item => {
      if (item.folderId && folderIdList.includes(item.folderId)) {
        deleteItemList.push(item);
        return false;
      } else {
        return true;
      }
    });
    if (CheckEmptyUtils.isEmptyArr(deleteItemList)) {
      log.showWarn('deleteGridLayoutItemByFolderIdList error with null item');
      return;
    }
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(newGridLayoutItemList);
    // 更新folder控件缓存
    folderIdList.forEach((folderId: string | number) => {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_FOLDER_UPDATE_LAYOUT, folderId);
    });
    if (isOperateDb) {
      try {
        deleteItemList.forEach((deleteItem: GridLayoutItemInfo) => {
          LauncherLayoutCacheUtil.deleteFolderItemCallBack(deleteItem);
        });
      } catch (error) {
        log.showError(`deleteFolderItemByFolderId with error %{public}s`, error.message);
      }
    }
  };

  /**
   * 根据index删除文件夹
   */
  deleteGridLayoutItemByIndex(index: number, label: string, isOperateDb: boolean = true):
    GridLayoutItemInfo | undefined {
    log.showInfo('deleteGridLayoutItemByIndex index %{public}d from %{public}s, db: %{public}s',
      index, label, isOperateDb);
    let deleteInfo: GridLayoutItemInfo | undefined;
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(false);
    if (index >= gridLayoutItemList.length || index < 0) {
      log.showWarn('deleteGridLayoutItemByIndex error with index out of range');
      return deleteInfo;
    }
    let deleteFolderItem = gridLayoutItemList[index];
    deleteInfo = gridLayoutItemList.splice(index, 1)[0];
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(gridLayoutItemList, false);

    if (isOperateDb) {
      let ret: boolean = PageDesktopModel.getInstance().deleteBlankPageFromLayoutInfo(deleteFolderItem.page ?? -1,
        false);
      if (ret) {
        const curPageIndex = PageDesktopModel.getInstance().getPageIndex(false);
        log.showInfo(`folder dismiss delete blankPage, CurPageIndex = ${curPageIndex}`);
        PageDesktopModel.getInstance().setPageIndex((curPageIndex > 0) ? (curPageIndex - 1) : curPageIndex, false);
      }
      try {
        LauncherLayoutCacheUtil.deleteFolderItemCallBack(deleteFolderItem);
      } catch (error) {
        log.showError('deleteFolderItemByIndex with error %{public}s', error.message);
      }
    }
    return deleteInfo;
  }

  /**
   * 根据指定列表删除数据
   *
   * @param appListInfo 删除的应用列表
   * @param label 业务标识
   * @param isOperateDb true需要数据库操作，false不需要
   */
  deleteGridLayoutItemByItemList(appListInfo: GridLayoutItemInfo[], label: string, isOperateDb: boolean = true): void {
    log.showInfo(`deleteGridLayoutItemByItemList from business %{public}s, db: %{public}s`, label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    if (CheckEmptyUtils.isEmptyArr(appListInfo)) {
      log.showWarn('deleteGridLayoutItemByItemList failure as the appListInfo is null');
      return;
    }
    let deleteItems: GridLayoutItemInfo[] = [];
    for (let i = 0; i < appListInfo.length; i++) {
      const index = gridLayoutItemList.indexOf(appListInfo[i]);
      if (index !== CommonConstants.INVALID_VALUE) {
        deleteItems.push(gridLayoutItemList[index]);
        gridLayoutItemList.splice(index, 1);
      }
    }
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(gridLayoutItemList);
    if (isOperateDb && !CheckEmptyUtils.isEmptyArr(deleteItems)) {
      try {
        LauncherLayoutCacheUtil.patchDeleteGridLayoutItemCallBack(deleteItems);
      } catch (error) {
        log.showError(`deleteGridLayoutItemByItemList with error %{public}s`, error.message);
      }
    }
  }

  /**
   * 删除和替换item
   *
   * @param startNum 开始位置
   * @param deleteCount 删除数量
   * @param replaceItem 替换的item
   * @param label 业务标识
   * @param isOperateDb true需要数据库操作，false不需要
   */
  deleteAndReplaceItem(startNum: number, deleteCount: number, replaceItem: GridLayoutItemInfo,
    label: string, isOperateDb: boolean = true): void {
    log.showInfo('deleteAndReplaceItem from %{public}d deleteCount %{public}d from %{public}s OperationDb %{public}s',
      startNum, deleteCount, label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    if (startNum < 0 || startNum >= gridLayoutItemList.length) {
      log.showWarn('deleteAndReplaceItem error with the index out of range');
      return;
    }
    let deleteFolderItem: GridLayoutItemInfo = gridLayoutItemList[startNum];
    gridLayoutItemList.splice(startNum, deleteCount, replaceItem);
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(gridLayoutItemList);
    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.deleteFolderItemCallBack(deleteFolderItem, true);
      } catch (error) {
        log.showError(`deleteAndReplaceItem with error %{public}s`, error.message);
      }
    }
  }

  /**
   * 删除文件夹并将应用更新到桌面
   *
   * @param index 布局中的位置
   * @param appItem 应用item
   * @param label 业务标识
   * @param isOperateDb true需要数据库操作，false不需要
   */
  deleteFolderAndUpdateAppItemToDesktop(index: number, appItem: GridLayoutItemInfo | undefined, label: string,
    isOperateDb: boolean = true): void {
    if (!appItem) {
      // 允许一个应用的文件夹，在应用卸载后，文件夹内不存在应用，不需要更新应用到桌面并且要删除文件夹的信息
      this.deleteGridLayoutItemByIndex(index, BusinessType.BUSINESS_FOLDER, isOperateDb);
      return;
    }
    log.showInfo(`deleteFolderAndUpdateAppItemToDesktop from %{public}d bundleName %{public}d,from %{public}s Db %{public}s`,
      index, appItem.bundleName, label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(false);
    if (index < 0 || index >= gridLayoutItemList.length) {
      log.showWarn('deleteFolderAndUpdateAppItemToDesktop error with the index out of range');
      return;
    }
    let deleteItem: GridLayoutItemInfo = gridLayoutItemList[index];
    gridLayoutItemList.splice(index, 1);
    // 桌面元素替换，应用复用文件夹当前桌面位置信息
    appItem.page = deleteItem.page;
    appItem.column = deleteItem.column;
    appItem.row = deleteItem.row;
    appItem.container = CommonConstants.CONTAINER_DESKTOP;
    gridLayoutItemList.push(appItem);
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(gridLayoutItemList, false);

    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.deleteFolderAndUpdateAppToDesktopCallBack(deleteItem, appItem);
      } catch (error) {
        log.showError(`deleteFolderAndUpdateAppItemToDesktop with error %{public}s`, error.message);
      }
    }
  }

  /**
   * 更新文件夹布局信息
   *
   * @param folderId 文件夹id
   * @param folderLayoutInfo 文件夹布局信息
   * @param updateAppInfos 更新文件夹内应用信息
   * @param msg 维测信息
   * @param isOperateDb true需要数据库操作，false不需要
   */
  updateFolderItemLayoutInfoByFolderId(folderId: string, folderLayoutInfo: Array<GridLayoutItemInfo[]>,
    updateAppInfos: GridLayoutItemInfo[], msg: string, isOperateDb: boolean = true, isOuter?: boolean): void {
    log.showInfo(`updateFolderItemLayoutInfoByFolderId folderId %{public}s, from %{public}s OperationDb %{public}s`,
      folderId, msg, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    let filter =
      (item: GridLayoutItemInfo): boolean => item.typeId === CommonConstants.TYPE_FOLDER && item.folderId === folderId;
    let folderItem: GridLayoutItemInfo = gridLayoutItemList.find(filter);
    if (CheckEmptyUtils.isEmpty(folderItem)) {
      log.showWarn('updateFolderItemLayoutInfoByFolderId error as the folder is not find in layout');
      return;
    }
    if (!LauncherLayoutCacheUtil.checkIfNeedFindRotatePosition(gridLayoutItemList, folderItem)) {
      folderItem = LauncherLayoutCacheUtil.updateListIfLazyRotateMode([folderItem], gridLayoutItemList, 'updateFolderItemLayoutInfoByFolderId')[0];
    }
    if (CheckEmptyUtils.isEmpty(folderItem)) {
      log.showWarn('updateFolderItemLayoutInfoByFolderId updateListIfLazyRotateMode fail return!');
      return;
    }
    folderItem.layoutInfo = folderLayoutInfo;
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(gridLayoutItemList, isOuter);
    FolderManager.getInstance().updateFolderItems('update layout in folder', folderItem, []);
    if (isOperateDb && !CheckEmptyUtils.isEmptyArr(updateAppInfos)) {
      try {
        LauncherLayoutCacheUtil.addInfoToFolderCallBack(folderItem?.folderId, updateAppInfos);
      } catch (error) {
        log.showError(`deleteAndReplaceItem with error %{public}s`, error.message);
      }
    }
  }
  /**
   * 更新文件夹布局信息
   *
   * @param layoutInfoGroupByFolderId 需要更新的文件夹map, key是文件夹folderId, value是更新后的文件夹layoutInfo
   * @param msg 维测信息
   * @param isOperateDb true需要数据库操作，false不需要
   * @param needReFreshView 是否需要刷新桌面文件夹
   */
  updateFolderItemLayoutInfoByFolderIdList(
    layoutInfoGroupByFolderId: Map<string, GridLayoutItemInfo[][]>,
    msg: string,
    isOperateDb: boolean = true,
    needReFreshView: boolean = true
  ): void {
    log.showInfo(`updateFolderItemLayoutInfoByFolderIdList,folderCount: ${layoutInfoGroupByFolderId.size}, ` +
      `OperationDb: ${isOperateDb}, needRefeash: ${needReFreshView} callby: ${msg}`);
    const desktopItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    const refreshFolderIdList: string[] = [];
    layoutInfoGroupByFolderId.forEach((newLayoutInfo: GridLayoutItemInfo[][], folderId: string) => {
      if (CheckEmptyUtils.isEmpty(newLayoutInfo)) {
        log.showWarn('updateFolderItemLayoutInfoByFolderIdList error, the updateAppInfo is null');
        return;
      }
      const cacheFolder: GridLayoutItemInfo | undefined = desktopItemList.find(item => {
        return item.typeId === CommonConstants.TYPE_FOLDER && item.folderId === folderId;
      });
      if (!cacheFolder) {
        log.showWarn(`updateFolderItemLayoutInfoByFolderIdList error, folder(${folderId}) is not find in layout`);
        return;
      }
      cacheFolder.layoutInfo = newLayoutInfo;
      refreshFolderIdList.push(folderId);
    });
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(desktopItemList);
    if (isOperateDb) {
      refreshFolderIdList.forEach((folderId: string) => {
        try {
          LauncherLayoutCacheUtil.addInfoToFolderCallBack(folderId, layoutInfoGroupByFolderId.get(folderId)?.flat());
        } catch (error) {
          log.showError(`deleteAndReplaceItem with error %{public}s`, error.message);
        }
      });
    }
  }

  /**
   * 更新文件夹中应用的角标
   *
   * @param badgeInfo 角标信息
   * @param label 业务标识
   * @param isOperateDb true需要数据库操作，false不需要
   * @returns 更新的应用
   */
  updateBadgeNumberInFolder(badgeInfo: BadgeItemInfo, label: string, isOperateDb: boolean = true):
    GridLayoutItemInfo | undefined {
    let appInfo: GridLayoutItemInfo | undefined = undefined;
    if (CheckEmptyUtils.isEmpty(badgeInfo)) {
      log.showWarn('updateBadgeNumberInFolder error as the badgeInfo is null');
      return appInfo;
    }
    log.showInfo('updateBadgeNumberInFolder bundleName %{public}s from %{public}s DB: %{public}s',
      badgeInfo.bundleName, label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    for (let i = 0; i < gridLayoutItemList.length; i++) {
      if (appInfo) {
        break;
      }
      if (gridLayoutItemList[i].typeId === CommonConstants.TYPE_FOLDER) {
        appInfo = this.updateAppBadgeInFolder(gridLayoutItemList[i], badgeInfo);
      }
    }

    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList);
    if (isOperateDb && appInfo) {
      try {
        LauncherLayoutCacheUtil.updateBadgeByBundleNameCallBack(appInfo, appInfo.badgeNumber);
      } catch (error) {
        log.showError(`updateBadgeNumberInFolder with error %{public}s`, error.message);
      }
    }
    return appInfo;
  }

  private updateAppBadgeInFolder(folderItem: GridLayoutItemInfo, badgeInfo: BadgeItemInfo): GridLayoutItemInfo | undefined {
    let res: GridLayoutItemInfo | undefined = undefined;
    let appInfo: GridLayoutItemInfo | undefined = undefined;
    if (!folderItem || !folderItem.layoutInfo) {
      log.showWarn('updateAppBadgeInFolder error as the folderItem is null');
      return res;
    }
    for (let j = 0; j < folderItem.layoutInfo.length; j++) {
      appInfo = folderItem.layoutInfo[j].find(item => {
        return item.bundleName === badgeInfo.bundleName && item.appIndex === badgeInfo.appIndex;
      });

      if (appInfo) {
        LauncherLayoutCacheUtil.updateAppBadgeInFolder(folderItem, appInfo, badgeInfo);
        res = appInfo;
        break;
      }
    }
    return res;
  }

  /**
   * 文件夹更新角标
   *
   * @param badgeNumber 角标数量
   * @param folderId 文件夹id
   * @param label 业务标识
   */
  updateBadgeNumberByFolderId(badgeNumber: number, folderId: string, label: string): void {
    log.showInfo(`updateBadgeNumberAfterAppAdded badgeNumber %{public}d, from %{public}s`, badgeNumber, label);
    if (badgeNumber < 0) {
      log.showInfo(`the badgeNumber not need to update`);
      return;
    }
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(false);
    let folderItem: GridLayoutItemInfo | undefined = gridLayoutItemList.find(item => item.typeId === CommonConstants.TYPE_FOLDER &&
      item.folderId === folderId);
    if (!folderItem) {
      log.showWarn('the folder %{public}s is not find', folderId);
      return;
    }
    folderItem.badgeNumber = badgeNumber;
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, false);
  }

  /**
   * 根据FolderItem更新文件夹大小、位置
   *
   * @param folderItem 新的folderItem
   * @param label 业务标识
   * @param isOperateDb true需要数据库操作，false不需要
   */
  updateFolderSizeByFolderItem(folderItem: GridLayoutItemInfo, label: string, isOperateDb: boolean = true,
    isOuter?: boolean): void {
    if (CheckEmptyUtils.isEmpty(folderItem)) {
      log.showWarn('updateFolderSizeByFolderItem error as the folderItem is null');
      return;
    }
    log.showInfo(`updateFolderSizeByFolderItem by %{public}s from %{public}s, db %{public}s, isOuter %{public}s`,
      folderItem.folderId, label, isOperateDb, isOuter);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    for (let i = 0; i < gridLayoutItemList.length; i++) {
      let mArea = gridLayoutItemList[i].area;
      if (gridLayoutItemList[i].folderId === folderItem.folderId && folderItem.area && mArea) {
        gridLayoutItemList[i].row = folderItem.row;
        gridLayoutItemList[i].column = folderItem.column;
        mArea[0] = folderItem.area[0];
        mArea[1] = folderItem.area[1];
        break;
      }
    }
    // 文件夹变形场景需要校验横竖屏能否放下，否则重排该页布局
    if (!LauncherLayoutCacheUtil.getIsFirstRotate()) {
      let checkList = gridLayoutItemList.filter(item => item.folderId !== folderItem.folderId);
      if (!LauncherLayoutCacheUtil.checkIfElementsIsAddable(checkList, folderItem.page ?? -1, folderItem)) {
        LauncherLayoutCacheUtil.forceRotatePage(gridLayoutItemList, folderItem.page ?? -1, folderItem, false);
      }
    }
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, isOuter);
    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.updateFolderSizeCallBack([folderItem], false, isOuter);
      } catch (error) {
        log.showError(`updateFolderSizeByFolderItem with error %{public}s`, error.message);
      }
    }
  }

  /**
   * 更新文件夹名字
   *
   * @param folderName 文件夹名字
   * @param folderId 文件夹id
   * @param label 业务标识
   * @param isInit true indicates folder is new created
   * @param isOperateDb true需要数据库操作，false不需要
   */
  updateFolderName(folderName: string, folderId: string, isInit: boolean, label: string,
    isOperateDb: boolean = true): void {
    log.showInfo('updateFolderName with name from %{public}s db %{public}s', label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    let filter =
      (item: GridLayoutItemInfo): boolean => item.typeId === CommonConstants.TYPE_FOLDER && item.folderId === folderId;
    let folderItem: GridLayoutItemInfo | undefined = gridLayoutItemList.find(filter);
    if (!folderItem) {
      log.showWarn('updateFolderName error as the folder is not find');
      return;
    }
    folderItem.folderName = folderName;
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList);
    if (this.layoutCacheData.isPad()) {
      let rotateList: GridLayoutItemInfo[] = this.layoutCacheData.getRotateLayoutInfo();
      let landscapeFolderItem: GridLayoutItemInfo | undefined = rotateList.find(filter);
      if (landscapeFolderItem) {
        landscapeFolderItem.folderName = folderName;
      }
    }
    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.updateFolderNameCallBack(folderItem, isInit);
      } catch (error) {
        log.showError('updateFolderName with error %{public}s', error.message);
      }
    }
  }

  /**
   * 根据文件夹id更新文件夹布局
   *
   * @param folderId 文件夹id
   * @param folderLayoutInfo 文件夹布局信息
   * @param label 业务标识
   * @param isOperateDb isOperateDb true需要数据库操作，false不需要
   */
  updateFolderLayoutInfoByFolderId(folderId: string, folderLayoutInfo: GridLayoutItemInfo[][],
    label: string, isOperateDb: boolean = true): void {
    log.showInfo(`updateFolderLayoutInfoByFolderId with folderId %{public}s from %{public}s db %{public}s`, folderId, label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    let folderItem: GridLayoutItemInfo | undefined = gridLayoutItemList.find(item => item.typeId === CommonConstants.TYPE_FOLDER &&
      item.folderId === folderId);
    if (!folderItem) {
      log.showWarn('the folder %{public}s is not find in desktop', folderId);
      return;
    }
    folderItem.layoutInfo = folderLayoutInfo;
    this.updateAddIcon(folderId, folderItem);
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(gridLayoutItemList);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_FOLDER_UPDATE_LAYOUT, folderId);
  }

  private updateAddIcon(folderId: string, folderItem: GridLayoutItemInfo): void {
    if (GridLayoutUtil.isSmallFolder(folderItem)) {
      return;
    }
  }

  /**
   * 大小文件夹
   *
   * @param folderItem 文件夹item
   * @param isConvertToSmall true转为小文件夹，false转大文件夹
   * @param label 业务标识
   * @param isOperateDb true需要数据库操作，false不需要
   */
  convertFolderSize(folderItem: GridLayoutItemInfo, isConvertToSmall: boolean, label: string, isOperateDb: boolean = true): void {
    if (CheckEmptyUtils.isEmpty(folderItem)) {
      log.showWarn('convertFolderSize failure as the null item');
      return;
    }
    log.showInfo('convertFolderSize item bundleName %{public}s, from %{public}s db %{public}s',
      folderItem.bundleName, label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    if (folderItem.typeId === CommonConstants.TYPE_FOLDER) {
      folderItem = LauncherLayoutCacheUtil.updateListIfLazyRotateMode([folderItem], gridLayoutItemList, 'convertFolderSize')[0];
      if (CheckEmptyUtils.isEmpty(folderItem)) {
        log.showWarn('convertFolderSize failure as the null item after LazyRotateMode!');
        return;
      }
    }
    folderItem.infoId = folderItem.folderId;
    gridLayoutItemList.push(folderItem);
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(gridLayoutItemList);
    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.updateFolderSizeCallBack([folderItem], isConvertToSmall);
      } catch (error) {
        log.showError('convertFolderSize with error %{public}s', error.message);
      }
    }
  }

  /**
   * 更新文件夹size异常
   *
   * @param msg DFX的日志打印
   * @param updateItem 更新的item
   * @param isDb 是否执行数据库操作
   */
  updateFolderSize(msg: string, updateItem: GridLayoutItemInfo, isDb: boolean = true): void {
    if (CheckEmptyUtils.isEmpty(updateItem)) {
      log.showWarn('convertFolderSize failure as the null item');
      return;
    }
    log.showInfo('%{public}s : convert Folder Size %{public}s, from %{public}s db %{public}s',
      msg, updateItem.area, updateItem.folderId, isDb);
    let folderItem: GridLayoutItemInfo | undefined = this.selectGridLayoutItemByFolderId(updateItem.folderId ?? '');
    if (!folderItem) {
      log.showWarn('convertFolderSize failure for not find the folderItem');
      return;
    }
    folderItem.container = updateItem.container;
    folderItem.column = updateItem.column;
    folderItem.row = updateItem.row;
    folderItem.area = updateItem.area;
    if (isDb) {
      try {
        LauncherLayoutCacheUtil.updateFolderSizeCallBack([folderItem]);
      } catch (error) {
        log.showError('convert folder with error %{public}s', error.message);
      }
    }
  }

  /**
   * 文件夹最后一个应用更新到桌面
   *
   * @param appItem 最后一个应用
   * @param label 业务标识
   * @param isOperateDb true需要数据库操作，false不需要
   */
  updateLastFolderItemToDesktop(appItem: GridLayoutItemInfo, label: string, isOperateDb: boolean = true): void {
    if (CheckEmptyUtils.isEmpty(appItem)) {
      log.showInfo('updateLastFolderItemToDesktop failure as the null item');
      return;
    }
    log.showInfo('updateLastFolderItemToDesktop item bundleName %{public}s, from %{public}s db: %{public}s',
      appItem.bundleName, label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    if (!LauncherLayoutCacheUtil.getIsFirstRotate()) {
      let updateGridLayoutItemList: GridLayoutItemInfo[] = gridLayoutItemList.filter(item => {
        return !(item.row === appItem.row && item.column === appItem.column && item.typeId === CommonConstants.TYPE_FOLDER);
      })
      appItem = LauncherLayoutCacheUtil.updateListIfLazyRotateMode([appItem], updateGridLayoutItemList, 'updateLastFolderItemToDesktop')[0];
      if (CheckEmptyUtils.isEmpty(appItem)) {
        log.showWarn('updateLastFolderItemToDesktop failure as the null item after LazyRotateMode!');
        return;
      }
    }
    gridLayoutItemList.push(appItem);
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(gridLayoutItemList);
    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.updateItemToDesktopCallBack([appItem]);
      } catch (error) {
        log.showError('updateLastFolderItemToDesktop with error %{public}s', error.message);
      }
    }
  }

  /**
   * 将文件夹中元素更新到桌面
   *
   * @param gridLayoutItemList 更新的appItem列表
   * @param label 业务标识
   * @param isOperateDb true需要数据库操作，false不需要
   */
  insertGridLayoutItemListFromFolder(gridLayoutItemList: GridLayoutItemInfo[], label: string, isOperateDb: boolean = true): void {
    if (CheckEmptyUtils.isEmpty(gridLayoutItemList)) {
      log.showInfo('insertGridLayoutItemListFromFolder error');
      return;
    }
    log.showInfo('insertGridLayoutItemListFromFolder size %{public}d, from %{public}s db: %{public}s',
      gridLayoutItemList.length, label, isOperateDb);
    let gridLayout = this.layoutCacheData.getGridLayoutItemList();
    gridLayoutItemList = LauncherLayoutCacheUtil.updateListIfLazyRotateMode(gridLayoutItemList, gridLayout, 'insertGridLayoutItemListFromFolder');
    if (CheckEmptyUtils.isEmpty(gridLayoutItemList)) {
      log.showInfo('insertGridLayoutItemListFromFolder failure as the null item after LazyRotateMode!');
      return;
    }
    for (const item of gridLayoutItemList) {
      gridLayout.push(item);
    }
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(gridLayout);
    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.updateItemToDesktopCallBack(gridLayoutItemList);
      } catch (error) {
        log.showError('insertGridLayoutItemListFromFolder with error %{public}s', error.message);
      }
    }
  }

  private insertAppItemToFolderCache(folderItem: GridLayoutItemInfo, appItem: GridLayoutItemInfo): void {
    if (!folderItem || !folderItem.layoutInfo || appItem.page === undefined) {
      return;
    }
    if (!folderItem.layoutInfo[appItem.page]) {
      folderItem.layoutInfo[appItem.page] = [];
    }
    folderItem.layoutInfo[appItem.page].push(appItem);
  }

  /**
   * 当文件夹id落库后，落库前收集的没有container的应用列表waitAddFordleInfos需要写入对应文件夹并写入数据库
   *
   * @param folderIntent 文件夹inetnt
   * @param container 待插入文件夹的container
   */
  insertAppToFolderWithoutContainer(folderIntent: string, container: number): void {
    try {
      if (!container || CheckEmptyUtils.isEmptyArr(this.waitAddFordleInfos)) {
        return;
      }
      let targetInfo: GridLayoutItemInfo[] = [];
      this.waitAddFordleInfos = this.waitAddFordleInfos.filter(waitAppItem =>
      !targetInfo.some(targetAppItem => targetAppItem.bundleName === waitAppItem.bundleName));
      log.info('insertAppToFolderWithoutContainer waitAddFordleInfoslength = %{public}d, targetInfolength = %{public}d',
        this.waitAddFordleInfos.length, targetInfo.length);
      if (!CheckEmptyUtils.isEmptyArr(targetInfo)) {
        LauncherLayoutCacheUtil.insertGridLayoutListCallBack(targetInfo, false);
      }
    } catch (error) {
      log.showError('insertAppItemToFolder with error %{public}s', error.message);
    }
  }

  /**
   * 插入应用到文件夹最后位置
   *
   * @param folderId 文件夹id
   * @param appItem 插入应用item
   * @param label 业务标识
   * @param isOperateDb true需要数据库操作，false不需要
   */
  insertAppItemToFolderLastItemByFolderId(folderId: string, appItem: GridLayoutItemInfo, label: string,
    isOperateDb: boolean = true): void {
    if (CheckEmptyUtils.isEmpty(appItem)) {
      log.showInfo('insertAppItemToFolderLastItemByFolderId error as the appItem is null');
      return;
    }
    log.showInfo('insertAppItemToFolderLastItemByFolderId folderId %{public}s bundleName %{public}s from %{public}s db %{public}s',
      folderId, appItem.bundleName, label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    let folderItem: GridLayoutItemInfo | undefined = gridLayoutItemList.find(item =>
    item.typeId === CommonConstants.TYPE_FOLDER && item.folderId === folderId);
    if (!folderItem || !folderItem.layoutInfo) {
      return;
    }

    const lastPageItems: GridLayoutItemInfo[] = folderItem.layoutInfo[folderItem.layoutInfo.length - 1];
    if (!CheckEmptyUtils.isEmpty(lastPageItems[lastPageItems.length - 1]) &&
      lastPageItems[lastPageItems.length - 1].typeId === CommonConstants.TYPE_ADD) {
      lastPageItems[lastPageItems.length - 1] = appItem;
    } else {
      const openFolderConfig = FolderModel.getInstance().getFolderOpenLayout();
      if (openFolderConfig && lastPageItems.length === openFolderConfig.column * openFolderConfig.row) {
        folderItem.layoutInfo.push([appItem]);
      } else {
        lastPageItems.push(appItem);
      }
      let folderLayout: GridLayoutItemInfo[] = folderItem.layoutInfo.flat();
      log.showInfo(`addOneAppToFolder ${JSON.stringify(folderItem?.folderId)}  ${folderLayout.length}`);
      this.updateFolderAppLocation(folderLayout);
    }
    FolderManager.getInstance().updateFolderItems('insertAppItemToFolderLastItemByFolderId', folderItem, [appItem]);
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(gridLayoutItemList);

    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.addInfoToFolderCallBack(folderId, [appItem]);
      } catch (error) {
        log.showError('insertAppItemToFolderLastItemByFolderId with error %{public}s', error.message);
      }
    }
  }

  /**
   * 多选落位大文件夹插入应用到文件夹
   * insertAppItemToFolderLastItemByFolderId方法在多选图标落位时，每个图标都执行了一次，带来了大量的数据库插入及桌面refresh，在此方法中将其统一为整个多选落位中只执行一次，以优化性能
   * @param folderId 文件夹id
   * @param apps 多选落位的全部图标
   * @param isRefreshView true需要刷新桌面，false不需要
   * @param isOperateDb true需要数据库操作，false不需要
   */
  insertAppListToFolderByFolderId(
    folderId: string,
    apps: GridLayoutItemInfo[],
    isRefreshView: boolean = true,
    isOperateDb: boolean = true
  ): void {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(false);
    let folderItem: GridLayoutItemInfo | undefined = gridLayoutItemList.find(item =>
    item.typeId === CommonConstants.TYPE_FOLDER && item.folderId === folderId);
    if (!folderItem || !folderItem.layoutInfo) {
      return;
    }
    const validApps = this.getValidInsertApp(apps, folderItem);
    validApps.forEach((appInfo: GridLayoutItemInfo) => {
      if (!folderItem?.layoutInfo) {
        return;
      }
      const lastPageItems: GridLayoutItemInfo[] = folderItem.layoutInfo[folderItem.layoutInfo.length - 1];
      log.showInfo('insertAppItemToFolderLastItemByFolderId folderId %{public}s bundleName %{public}s',
        folderId, appInfo.bundleName);
      if (!CheckEmptyUtils.isEmpty(lastPageItems[lastPageItems.length - 1]) &&
        lastPageItems[lastPageItems.length - 1].typeId === CommonConstants.TYPE_ADD) {
        lastPageItems[lastPageItems.length - 1] = appInfo;
      } else {
        const openFolderConfig = FolderModel.getInstance().getFolderOpenLayout();
        if (openFolderConfig && lastPageItems.length === openFolderConfig.column * openFolderConfig.row) {
          folderItem.layoutInfo.push([appInfo]);
        } else {
          lastPageItems.push(appInfo);
        }
      }
    });
    let folderLayout: GridLayoutItemInfo[] = folderItem.layoutInfo.flat();
    log.showInfo(`folderLayout.length ${folderLayout.length}`);
    this.updateFolderAppLocation(folderLayout);
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(gridLayoutItemList, false);
    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.addInfoToFolderCallBack(folderId, folderItem.layoutInfo.flat());
      } catch (error) {
        log.showError('insertAppItemToFolderLastItemByFolderId with error %{public}s', error.message);
      }
    }
  }

  private getValidInsertApp(apps: GridLayoutItemInfo[], folderItem: GridLayoutItemInfo): GridLayoutItemInfo[] {
    if (apps.length === 0) {
      return [];
    }
    const appKeys = new Set<string>();
    folderItem.layoutInfo?.flat().forEach((appInfo: GridLayoutItemInfo) => {
      appKeys.add(DesktopUtils.getItemKey(appInfo));
    });
    const validApps: GridLayoutItemInfo[] = [];
    apps.forEach((appInfo: GridLayoutItemInfo) => {
      if (CheckEmptyUtils.isEmpty(appInfo)) {
        log.showInfo('getValidInsertApp error as the appItem is null');
        return;
      }
      // 存在长度为0的场景, 需要去掉
      if (appInfo.bundleName.length === 0) {
        log.showInfo('getValidInsertApp bundleName invalid');
        return;
      }
      const key = DesktopUtils.getItemKey(appInfo);
      if (!appKeys.has(key)) {
        log.showInfo(`getValidInsertApp ${key} repeated`);
        return;
      }
      appKeys.add(key);
      validApps.push(appInfo);
    });
    return validApps;
  }

  /**
   * 判断应用是否在不可拖入拖出文件夹内
   *
   * @param bundleName 应用的包名
   */
  public isAppExistNotDragOutFolder(bundleName: string): boolean {
    let allFolders: GridLayoutItemInfo[] = this.selectAllFolders();
    if (CheckEmptyUtils.isEmptyArr(allFolders)) {
      return false;
    }
    for (let i = 0; i < allFolders.length; i++) {
      if (NotHarmonyUtil.isNotHarmonyFolderById(allFolders[i].folderId)) {
        let findResult: boolean = allFolders[i].layoutInfo?.flat().findIndex(item => item.bundleName === bundleName &&
          item.typeId === CommonConstants.TYPE_APP) !== CommonConstants.INVALID_VALUE;
        if (findResult) {
          return findResult;
        }
      }
    }
    return false;
  }

  /**
   * 更新文件夹应用位置
   *
   * @param layoutList 文件夹中应用列表
   */
  private updateFolderAppLocation(layoutList: GridLayoutItemInfo[]): void {
    let folderOpenColumn: number | undefined = FolderModel.getInstance().getFolderOpenLayout()?.column;
    let folderOpenRow: number | undefined = FolderModel.getInstance().getFolderOpenLayout()?.row;
    if (!folderOpenColumn || !folderOpenRow) {
      return;
    }
    for (let i = 0; i < layoutList.length; i++) {
      layoutList[i].column = i % folderOpenColumn;
      layoutList[i].row = Math.floor(i / folderOpenColumn % folderOpenRow);
      layoutList[i].page = Math.floor(i / (folderOpenColumn * folderOpenRow));
    }
  }

  /**
   * 更新文件夹预加载节点
   */
  public updateFolderLayoutPrebuild(): void {
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(this.layoutCacheData.getGridLayoutItemList());
  }

  deleteGridLayoutItemByBundleNameAndType(bundleName: string, typeId: number, label: string,
                                          isOperateDb: boolean = true): void {
    super.deleteGridLayoutItemByBundleNameAndType(bundleName, typeId, label, isOperateDb);
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(this.layoutCacheData.getGridLayoutItemList());
  }

  deleteGridLayoutItemById(deleteItem: GridLayoutItemInfo, label: string, isOperateDb: boolean = true): void {
    super.deleteGridLayoutItemById(deleteItem, label, isOperateDb);
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(this.layoutCacheData.getGridLayoutItemList());
  }

  deleteGridLayoutItemByPosition(page: number, row: number, col: number, label: string,
                                 isOperateDb: boolean = true): void {
    super.deleteGridLayoutItemByPosition(page, row, col, label, isOperateDb);
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(this.layoutCacheData.getGridLayoutItemList());
  }

  deleteAppItemByKeyName(keyName: string, label: string, isNeedOperationDb: boolean = true, isOuter?: boolean): void {
    super.deleteAppItemByKeyName(keyName, label, isNeedOperationDb, isOuter);
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(this.layoutCacheData.getGridLayoutItemList());
  }

  updateGridLayoutItemPositionById(updateItem: GridLayoutItemInfo, label: string, isOperateDb: boolean = true): void {
    super.updateGridLayoutItemPositionById(updateItem, label, isOperateDb);
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(this.layoutCacheData.getGridLayoutItemList());
  }

  insertGridLayoutItemInfo(gridlayoutItem: GridLayoutItemInfo, label: string, isOperateDb: boolean = true): boolean {
    super.insertGridLayoutItemInfo(gridlayoutItem, label, isOperateDb);
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(this.layoutCacheData.getGridLayoutItemList());
    return true;
  }

  async insertGridLayoutItemInfoAsync(gridlayoutItem: GridLayoutItemInfo, label: string, isOperateDb: boolean = true, isOuter?: boolean): Promise<void> {
    await super.insertGridLayoutItemInfoAsync(gridlayoutItem, label, isOperateDb, isOuter);
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(this.layoutCacheData.getGridLayoutItemList());
  }

  insertGridLayoutItemAndUpdatePosition(gridLayoutItem: GridLayoutItemInfo, label: string,
                                        isOperateDb: boolean = true): void {
    super.insertGridLayoutItemAndUpdatePosition(gridLayoutItem, label, isOperateDb);
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(this.layoutCacheData.getGridLayoutItemList());
  }

  updateLayoutAfterDeletePages(blankPages: number[], label: string, isNeedOperationDb: boolean = true): void {
    super.updateLayoutAfterDeletePages(blankPages, label, isNeedOperationDb);
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(this.layoutCacheData.getGridLayoutItemList());
  }

  updateLayoutAfterAddPage(pageAddIndex: number, pageAddNum: number, label: string, isOperateDb: boolean = true,
    isSwiperToNewPage: boolean = true, updateItems?: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    let ret: GridLayoutItemInfo[] = super.updateLayoutAfterAddPage(pageAddIndex, pageAddNum, label, isOperateDb,
      isSwiperToNewPage, updateItems);
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(this.layoutCacheData.getGridLayoutItemList());
    return ret;
  }

  updateLayoutAfterDeletePage(pageDeleteIndex: number, pageDeleteNum: number, label: string,
                              isNeedOperationDb: boolean = true): void {
    super.updateLayoutAfterDeletePage(pageDeleteIndex, pageDeleteNum, label, isNeedOperationDb);
    this.layoutCacheData.updateLayoutListCacheAndPrebuild(this.layoutCacheData.getGridLayoutItemList());
  }
}