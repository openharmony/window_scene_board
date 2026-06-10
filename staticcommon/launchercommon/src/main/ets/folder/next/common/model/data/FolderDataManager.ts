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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import GridLayoutInfoColumns from '../../../../../db/column/GridLayoutInfoColumns';
import {
  CommonConstants,
  DockItemInfo,
  FolderCommonConstants,
  FolderLayoutCacheManager,
  GridLayoutItemInfo,
  RdbStoreManager,
  ResidentLayoutCacheMgr,
  SettingsModel,
} from '../../../../../TsIndex';
import { BaseFolderDataUpdator } from './BaseFolderDataUpdator';
import { DesktopFolderDataUpdator } from './DesktopFolderDataUpdator';
import { DockFolderDataUpdator } from './DockFolderDataUpdator';
import { FoldersData } from './FoldersData';
import { FolderCommonUtil } from '../../FolderCommonUtil';

const TAG = 'FolderDataManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹数据管理：文件夹数据更新是，负责将更新数据同步到总的缓存入口桌面布局，包括GridLayoutItemInfo的列表与角标更新，快捷方式更新的通知，数据库更新
 */
export class FolderDataManager {
  private static instance: FolderDataManager;
  private cacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
  private foldersData: Map<string, FoldersData> = new Map<string, FoldersData>();

  private constructor() {
    this.initialFolderData();
    this.cacheManager.setFoldersData(this.foldersData);
  }

  public static getInstance(): FolderDataManager {
    if (!FolderDataManager.instance) {
      FolderDataManager.instance = new FolderDataManager();
    }
    return FolderDataManager.instance;
  }

  private initialFolderData(): void {
    this.foldersData.clear();
    let folders = this.getFoldersFromDesktop();
    if (!folders) {
      log.showWarn('cannot get folders data from model?');
      return;
    }
    folders.forEach((folder: FoldersData) => {
      let grid = folder.getGridInfo();
      if (!grid.folderId) {
        log.showWarn('find null folder-id in model, ignore it');
        return;
      }
      this.foldersData.set(grid.folderId, folder);
    });
  }

  private createFolderData(folder: GridLayoutItemInfo): FoldersData {
    return new FoldersData(folder);
  }

  private dockItemToFolderItem(dock: DockItemInfo): FoldersData {
    let folder = new GridLayoutItemInfo();
    folder.itemType = CommonConstants.TYPE_FOLDER;
    folder.typeId = CommonConstants.TYPE_FOLDER;
    folder.folderId = dock.keyName;
    folder.bundleName = dock.bundleName;
    folder.moduleName = dock.moduleName;
    folder.abilityName = dock.abilityName;
    folder.appIconId = dock.appIconId;
    folder.appLabelId = dock.appLabelId;
    folder.applicationLabelId = dock.applicationLabelId;
    folder.appName = dock.appName;
    folder.folderName = dock.appName;
    folder.areaType = dock.areaType;
    folder.keyName = dock.keyName;
    folder.layoutInfo = dock.layoutInfo;
    folder.container = CommonConstants.CONTAINER_SMARTDOCK;
    folder.area = [1, 1];
    folder.row = dock.row;
    folder.column = dock.column;
    folder.badgeNumber = dock.badgeNumber;
    folder.isInDock = true;
    folder.id = dock.id;
    return this.createFolderData(folder);
  }

  /*
   * 兼容当前dock数据不归一的方案；dock文件夹数据归一后要删除
   */
  private getFolderFromDock(folderId: string): FoldersData | undefined {
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let dockItem: DockItemInfo | undefined = residentList.find((item) =>
    item.keyName === folderId
    );
    return dockItem ? this.dockItemToFolderItem(dockItem) : undefined;
  }

  /**
   * 获取桌面的全部文件夹
   *
   * @returns 桌面的全部文件夹
   */
  private getFoldersFromDesktop(): FoldersData[] {
    let result: FoldersData[] = [];
    let allFoldersOnDesktop: GridLayoutItemInfo[] = this.cacheManager.selectFoldersOnDesktop(false);
    log.showDebug('select all the folders on desktop %{public}d', allFoldersOnDesktop.length);
    allFoldersOnDesktop.forEach(folder => result.push(this.createFolderData(folder)));
    return result;
  }

  /**
   * 获取文件夹数据更新管理器
   *
   * @param isDock 刷新的区域：dock或桌面
   * @returns
   */
  public getFolderUpdator(isDock: boolean): BaseFolderDataUpdator {
    if (isDock) {
      return DockFolderDataUpdator.getInstance();
    } else {
      return DesktopFolderDataUpdator.getInstance();
    }
  }

  /**
   * 更新FoldersData数据
   *
   * @param folderId 文件夹id
   * @param data 文件夹Data
   */
  public updateFoldersData(folderId: string, data: FoldersData): void {
    this.foldersData.set(folderId, data);
  }

  /**
   * 清除文件夹缓存
   *
   * @param msg 用于DFX日志
   * @param folderId 文件夹id
   */
  public deleteCacheById(msg: string, folderId: string): void {
    log.showInfo('%{public}s, delete folder cache %{public}s', msg, folderId);
    this.foldersData.delete(folderId);
  }

  /**
   * 根据文件夹id获取文件夹
   *
   * @param folderId 文件夹id
   * @returns 单个文件夹
   */
  public getFolder(folderId: string): FoldersData {
    if (CheckEmptyUtils.checkStrIsEmpty(folderId)) {
      log.showError('select folder fail with error folderId %{public}s', folderId);
      return new FoldersData(FolderCommonUtil.getEmptyFolderData());
    }
    let folder: FoldersData = this.foldersData.get(folderId) as FoldersData;
    if (folder && folder.getGridInfo().id) {
      return folder;
    }
    log.showInfo(`trying to get folder(${folderId})`);
    let folderItem: GridLayoutItemInfo | undefined = this.cacheManager.selectGridLayoutItemByFolderId(folderId, false);
    if (folderItem) {
      folder = this.createFolderData(folderItem);
      this.foldersData.set(folderId, folder);
      return folder;
    }
    log.showInfo(`folder(${folderId}) is not in desktop, trying to get from dock`);
    folder = this.getFolderFromDock(folderId) as FoldersData;
    if (folder) {
      this.foldersData.set(folderId, folder);
      return folder;
    } else {
      log.showError('the folder %{public}s is not find', folderId);
      return new FoldersData(FolderCommonUtil.getEmptyFolderData());
    }
  }

  /**
   * 查询全部的文件夹
   *
   * @returns 文件夹列表
   */
  public getFolders(): FoldersData[] {
    let result: FoldersData[] = [];
    let allFolders: GridLayoutItemInfo[] = this.cacheManager.selectAllFolders(false);
    log.showDebug('select all the folders %{public}d', allFolders.length);
    allFolders.forEach(folder => result.push(this.createFolderData(folder)));
    return result;
  }

  /**
   * 更新文件夹名字
   *
   * @param msg 用于DFX的日志
   * @param folderId 文件夹id
   * @param folderName 文件夹名字
   */
  public updateFolderName(msg: string, folderId: string, folderName: string): void {
    // 更新dock栏文件夹名称
    const residentList = SettingsModel.getInstance().getResidentList();
    for (const dockItem of residentList) {
      if (dockItem.typeId === CommonConstants.TYPE_FOLDER && dockItem.bundleName === folderId) {
        dockItem.appName = folderName;
        SettingsModel.getInstance().setResidentList(residentList);
        RdbStoreManager.getInstance()
          .updateGridInfoById(dockItem.bundleName, GridLayoutInfoColumns.INFO_NAME, dockItem.appName);
      }
    }
    this.cacheManager.updateFolderName(folderName, folderId, false, msg, true);
  }

  /**
   * 文件夹大小转换
   *
   * @param folderItem 文件夹元素
   * @param isConvertToSmall 转换成小文件夹
   * @param msg 用于DFX日志
   * @param isOperateDb true执行数据库操作
   */
  public convertFolderSize(folderItem: GridLayoutItemInfo, isConvertToSmall: boolean, msg: string,
    isOperateDb: boolean = true): void {
    this.foldersData.delete(folderItem.folderId as string);
    log.showInfo('%{public}s, delete folder %{public}s cache', msg, folderItem?.folderId);
    this.cacheManager.convertFolderSize(folderItem, isConvertToSmall, msg, isOperateDb);
  }

  /**
   * 更新文件夹大小
   *
   * @param msg 用于DFX日志
   * @param folderItem 文件夹item
   * @param isDb true执行数据库操作
   */
  public updateFolderSize(msg: string, folderItem: GridLayoutItemInfo, isDb: boolean): void {
    this.cacheManager.updateFolderSizeByFolderItem(folderItem, msg, isDb);
  }
}