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

import { GridLayoutItemInfo } from '../../../../../TsIndex';
import { FoldersData } from './FoldersData';

/**
 * 文件夹数据管理：文件夹数据更新是，负责将更新数据同步到总的缓存入口桌面布局，包括GridLayoutItemInfo的列表与角标更新，快捷方式更新的通知，数据库更新
 */
export class BaseFolderDataUpdator {
  /**
   * 添加应用到文件夹中
   *
   * @param msg 用于DFX日志打印
   * @param items 添加的元素
   * @param folderData 文件夹对象
   */
  public addItemsToFolder(msg: string, items: GridLayoutItemInfo[], folderData: FoldersData, isDrag: boolean): void {};

  /**
   * 新增一个文件夹
   *
   * @param msg 用于DFX日志打印
   * @param folder 文件夹对象
   * @param folderApps 文件夹的应用列表
   * @param isInsertLayout 是否单独执行文件夹应用列表更新到数据库操作（拖拽创建文件夹，拖拽会调数据库操作添加应用列表）
   */
  public createFolder(msg: string, folder: GridLayoutItemInfo, folderApps: GridLayoutItemInfo[],
    isInsertLayout: boolean): void {};

  /**
   * 根据id删除文件夹，并将剩余的应用替换到桌面
   *
   * @param msg 用于DFX日志
   * @param folderId 文件夹id
   * @param container 文件夹所在的位置
   * @param remainItem 文件夹删除最后剩余的一个元素
   */
  public deleteFolderById(msg: string, folderId: string, remainItem?: GridLayoutItemInfo): void {};

  /**
   * 更新文件夹布局
   *
   * @param msg 用于DFX日志
   * @param folderId 文件夹id
   * @param layoutInfo 布局列表
   */
  public updateFolderLayout(msg: string, folderId: string, layoutInfo: GridLayoutItemInfo[]): void {};

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
    isOperateDb: boolean = true,
    needReFreshView: boolean = true
  ): void {}
}