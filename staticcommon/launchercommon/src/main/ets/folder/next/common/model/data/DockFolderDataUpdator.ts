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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  AppModel,
  Cache2RdbHelper,
  CommonConstants,
  DockItemInfo,
  FolderCommonUtil,
  GridLayoutItemInfo, RdbStoreManager,
  ResidentLayoutCacheMgr } from '../../../../../TsIndex';
import { BaseFolderDataUpdator } from './BaseFolderDataUpdator';
import { FoldersData } from './FoldersData';

const TAG = 'DockFolderDataUpdator';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 桌面文件夹数据管理：文件夹数据更新是，负责将更新数据同步到总的缓存入口桌面布局，包括GridLayoutItemInfo的列表与角标更新，快捷方式更新的通知，数据库更新
 */
export class DockFolderDataUpdator extends BaseFolderDataUpdator {
  private static instance: DockFolderDataUpdator;

  private constructor() {
    super();
  }

  public static getInstance(): DockFolderDataUpdator {
    if (!DockFolderDataUpdator.instance) {
      DockFolderDataUpdator.instance = new DockFolderDataUpdator();
    }
    return DockFolderDataUpdator.instance;
  }

  /**
   * 添加应用到文件夹中
   *
   * @param msg 用于DFX日志打印
   * @param items 添加的元素
   * @param folderData 文件夹对象
   */
  public addItemsToFolder(msg: string, items: GridLayoutItemInfo[], folderData: FoldersData, isDrag: boolean): void {
    let folder: GridLayoutItemInfo = folderData.getGridInfo();
    log.showInfo('%{public}s: add items length %{public}d to folder %{public}s', msg, items.length, folder.folderId);
    let folderList: GridLayoutItemInfo[] = FolderCommonUtil.getFilterAppListInFolder(folder);
    folderList.push(...items);
    folder.layoutInfo = FolderCommonUtil.translateFolderLayout(folderList);
    FolderCommonUtil.updateFolderAppLocation(folderList);
    let badgeNum: number = folder.badgeNumber as number;
    const releaseLock = Cache2RdbHelper.getInstance().addLock(CommonConstants.DRAG_RDB_EVENT, 'add to folder');
    RdbStoreManager.getInstance().queryRecordByInfoId(folder.folderId ?? '').then(
      (rdbFolderItem: GridLayoutItemInfo | undefined) => {
      if (!rdbFolderItem) {
        return;
      }
      items.forEach(item => item.container = rdbFolderItem.id);
    }).catch((error: Error) => {
      log.showWarn(`get dock folder from rdb error:${error?.message}`);
    }).finally(() => {
      releaseLock?.();
    });
    items.forEach(item => {
      badgeNum += item.badgeNumber as number;
      Cache2RdbHelper.getInstance().addItem(CommonConstants.DRAG_RDB_EVENT, item);
    });
    folder.badgeNumber = badgeNum;
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let findIdx: number = residentList.findIndex(item => item.keyName === folder.folderId);
    if (findIdx >= 0) {
      residentList[findIdx].layoutInfo = folder.layoutInfo ;
      residentList[findIdx].badgeNumber = folder.badgeNumber;
    }
    ResidentLayoutCacheMgr.getInstance().updateAllDockItems(msg, residentList, false);
  }

  /**
   * 新增一个文件夹
   *
   * @param msg 用于DFX日志打印
   * @param folder 文件夹对象
   * @param folderApps 文件夹的应用列表
   * @param isInsertLayout 是否单独执行文件夹应用列表更新到数据库操作（拖拽创建文件夹，拖拽会调数据库操作添加应用列表）
   */
  public createFolder(msg: string, folder: GridLayoutItemInfo, folderApps: GridLayoutItemInfo[],
    isInsertLayout: boolean): void {
    const cache2Rdb = Cache2RdbHelper.getInstance();
    folder.layoutInfo = FolderCommonUtil.translateFolderLayout(folderApps);
    FolderCommonUtil.updateFolderAppLocation(folderApps);
    const releaseLock = cache2Rdb.addLock(CommonConstants.DRAG_RDB_EVENT, 'insert folder');
    RdbStoreManager.getInstance().insertItemWithoutLayoutInfo(folder).then((id: number) => {
      log.showInfo(`insert new folder id:${id}`);
      folder.id = id;
      let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      let findItem: DockItemInfo | undefined = residentList.find(item => item.keyName === folder.folderId);
      if (findItem) {
        log.showInfo('%{public}s, replace the folder %{public}s in dock', msg, folder.folderId)
        findItem.id = folder.id;
      }
      folderApps.forEach(item => item.container = id);
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems(msg, residentList, false);
    }).catch((error: Error) => {
      log.error('insert folder error', error);
    }).finally(() => {
      releaseLock?.();
    });
    folderApps.forEach((item: GridLayoutItemInfo) => {
      cache2Rdb.addItem(CommonConstants.DRAG_RDB_EVENT, item);
    }, 0);
  }

  /**
   * 根据id删除文件夹，并将剩余的应用替换到桌面
   *
   * @param msg 用于DFX日志
   * @param folderId 文件夹id
   * @param container 文件夹所在的位置
   * @param remainItem 文件夹删除最后剩余的一个元素
   */
  public deleteFolderById(msg: string, folderId: string, remainItem?: GridLayoutItemInfo | undefined): void {
    log.showInfo('%{public}s, delete folder %{public}s in dock', msg, folderId);
    let residentCacheMgr: ResidentLayoutCacheMgr = ResidentLayoutCacheMgr.getInstance();
    let residentList: DockItemInfo[] = residentCacheMgr.getAllDockItems();
    let findIndex: number = residentList.findIndex(item => item.keyName === folderId);
    if (findIndex < 0) {
      log.showError(' findIndex not found');
      return;
    }
    if (remainItem) {
      RdbStoreManager.getInstance().deleteItemByInfoId(folderId);
      const lastItem: DockItemInfo = AppModel.getInstance().gridLayoutToDockItem(remainItem);
      lastItem.container = CommonConstants.CONTAINER_DOCK;
      lastItem.areaType = CommonConstants.TYPE_AREA_DOCK;
      residentList.splice(findIndex, 1, lastItem);
      residentCacheMgr.updateAllDockItems(TAG.concat('_del_else'), residentList, true);
    } else {
      residentList.splice(findIndex, 1);
      residentCacheMgr.updateAllDockItems(TAG.concat('_else_if'), residentList, true);
    }
  }

  /**
   * 更新文件夹布局
   *
   * @param msg 用于DFX日志
   * @param folderId 文件夹id
   * @param layoutInfo 布局列表
   */
  public updateFolderLayout(msg: string, folderId: string, layoutInfo: GridLayoutItemInfo[]): void {
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let findIndex: number = residentList.findIndex(item => item.keyName === folderId);
    if (findIndex < 0) {
      log.showError('the findIndex not found');
      return;
    }
    let layout: GridLayoutItemInfo[][] = FolderCommonUtil.translateFolderLayout(layoutInfo);
    FolderCommonUtil.updateFolderAppLocation(layoutInfo);
    residentList[findIndex].layoutInfo = layout;
    residentList[findIndex].badgeNumber = FolderCommonUtil.calculateBadgeNum(layoutInfo);
    ResidentLayoutCacheMgr.getInstance().updateAllDockItems(msg, residentList, false);
  }

  /**
   * 更新文件夹布局信息
   *
   * @param folderId 文件夹id
   * @param layoutInfoGroupByFolderId 需要更新的文件夹map, key是文件夹folderId, value是更新后的文件夹layoutInfo
   * @param msg 维测信息
   * @param isOperateDb true需要数据库操作，false不需要
   * @param needReFreshView 是否需要刷新桌面文件夹
   */
  public updateFolderItemLayoutInfoByFolderIdList(
    folderId: string,
    layoutInfoGroupByFolderId: Map<string, GridLayoutItemInfo[][]>,
    msg: string,
    isOperateDb?: boolean,
    needReFreshView?: boolean): void {
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let isUpdate: boolean = false;
    layoutInfoGroupByFolderId.forEach((newLayoutInfo: GridLayoutItemInfo[][], folderId: string) => {
      let folderItem: DockItemInfo | undefined = residentList.find(item => item.keyName === folderId);
      if (folderItem) {
        folderItem.layoutInfo = newLayoutInfo;
        isUpdate = true;
      }
      if (isOperateDb) {
        RdbStoreManager.getInstance().addInfoToDockFolder(folderId, newLayoutInfo.flat());
      }
    });
    if (isUpdate) {
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems(msg, residentList, false);
    }
    log.showInfo('update folder %{public}s in dock isDb %{public}s: %{public}s', folderId, isOperateDb, msg);
  }
}