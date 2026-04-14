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
  Cache2RdbHelper,
  CommonConstants,
  FolderCommonUtil,
  FolderLayoutCacheManager,
  GridLayoutItemInfo,
  LauncherLayoutCacheUtil,
  RdbStoreManager
} from '../../../../../TsIndex';
import { BaseFolderDataUpdator } from './BaseFolderDataUpdator';
import { FoldersData } from './FoldersData';

const TAG = 'DesktopFolderDataUpdator';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 桌面文件夹数据管理：文件夹数据更新是，负责将更新数据同步到总的缓存入口桌面布局，包括GridLayoutItemInfo的列表与角标更新，快捷方式更新的通知，数据库更新
 */
export class DesktopFolderDataUpdator extends BaseFolderDataUpdator {
  private static instance: DesktopFolderDataUpdator;
  private cacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();

  private constructor() {
    super();
  }

  public static getInstance(): DesktopFolderDataUpdator {
    if (!DesktopFolderDataUpdator.instance) {
      DesktopFolderDataUpdator.instance = new DesktopFolderDataUpdator();
    }
    return DesktopFolderDataUpdator.instance;
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
    const folderId: string = folder.folderId as string;
    this.updateItemToFolder(folderId, items, isDrag);
    let folderList: GridLayoutItemInfo[] = FolderCommonUtil.getFilterAppListInFolder(folder);
    folderList.push(...items);
    const layoutInfo: GridLayoutItemInfo[][] = FolderCommonUtil.translateFolderLayout(folderList);
    FolderCommonUtil.updateFolderAppLocation(folderList);
    this.cacheManager.updateFolderLayoutInfoByFolderId(folderId, layoutInfo, msg);
    this.cacheManager.updateBadgeNumberByFolderId(FolderCommonUtil.calculateBadgeNum(folderList), folderId, msg);
    if (isDrag) {
      let cacheHelper = Cache2RdbHelper.getInstance();
      items.forEach(item => {
        cacheHelper.addItem(CommonConstants.DRAG_RDB_EVENT, item);
      });
    }
  }

  private updateItemToFolder(folderId: string, items: GridLayoutItemInfo[], isDrag: boolean): void {
    const releaseLock = Cache2RdbHelper.getInstance().addLock(CommonConstants.DRAG_RDB_EVENT, 'addAppsToFolder');
    RdbStoreManager.getInstance()
      .queryItemByInfoId(folderId)
      .then((rdbFolderItem: GridLayoutItemInfo) => {
        log.showWarn(` query folderData id  ${rdbFolderItem.id} folderId ${rdbFolderItem.folderId}`);
        if (!rdbFolderItem) {
          return;
        }
        items.forEach(item => item.container = rdbFolderItem.id);
        if (!isDrag) {
          LauncherLayoutCacheUtil.addInfoToFolderCallBack(folderId, items);
        }
      })
      .catch((error: Error) => {
        log.showWarn(`get folder from rdb error:${error?.message}`);
      })
      .finally(() => {
        releaseLock?.();
      });
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
    // 新增的文件夹写库并更新文件夹内应用的container
    // 可能存在写库失败，但是原有逻辑未处理
    folder.layoutInfo = FolderCommonUtil.translateFolderLayout(folderApps);
    FolderCommonUtil.updateFolderAppLocation(folderApps);
    const releaseLock = cache2Rdb.addLock(CommonConstants.DRAG_RDB_EVENT, 'create New Folder by Drag');
    this.cacheManager.insertItemWithoutLayoutInfo(folder, msg, true)
      .then(line => {
        log.showInfo(`insert new folder id:${line}`);
        folder.id = line;
        folderApps.forEach(item => item.container = line);
        if (isInsertLayout) {
          LauncherLayoutCacheUtil.addInfoToFolderCallBack(folder.folderId, folderApps);
        }
      })
      .catch((error: Error) => {
        log.showWarn(`insert new folder to rdb error:${error?.message}`);
      })
      .finally(() => {
        releaseLock?.();
      });
    let badgeNum: number = 0;
    if (!isInsertLayout) {
      folderApps.forEach((item: GridLayoutItemInfo) => {
        item.badgeNumber as number > 0 && (badgeNum += item.badgeNumber as number);
        cache2Rdb.addItem(CommonConstants.DRAG_RDB_EVENT, item);
      }, 0);
    }
    this.cacheManager.updateBadgeNumberByFolderId(badgeNum, folder.folderId ?? '', msg);
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
    this.cacheManager.deleteGridLayoutItemByItemId(folderId, msg, true);
    if (remainItem) {
      remainItem.areaType = CommonConstants.TYPE_AREA_DESKTOP;
      remainItem.container = CommonConstants.CONTAINER_DESKTOP;
      this.cacheManager.insertGridLayoutItemAndUpdatePosition(remainItem, msg, true);
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
    let layout: GridLayoutItemInfo[][] = FolderCommonUtil.translateFolderLayout(layoutInfo);
    FolderCommonUtil.updateFolderAppLocation(layoutInfo);
    this.cacheManager.updateFolderLayoutInfoByFolderId(folderId, layout, msg);
    this.cacheManager.updateBadgeNumberByFolderId(FolderCommonUtil.calculateBadgeNum(layoutInfo), folderId, msg);
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
    this.cacheManager.updateFolderItemLayoutInfoByFolderIdList(layoutInfoGroupByFolderId, msg, isOperateDb,
      needReFreshView);
    log.showInfo('%{public}s updateFolder to delete cache for folder %{public}s', msg, folderId);
  }
}