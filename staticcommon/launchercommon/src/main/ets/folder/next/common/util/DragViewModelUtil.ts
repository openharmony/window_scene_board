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

import GridLayoutItemInfo from '../../../../bean/GridLayoutItemInfo';
import { FolderDataRefreshType } from '../FolderCommonConstant';
import { DragCoveredItem } from '../model/data/FoldersData';

/**
 * 文件夹拖拽业务的工具类
 */
export class DragViewModelUtil {
  /**
   * 获取拖拽业务的参数
   *
   * @param dragItems 拖拽的元素
   * @param x 多选落位的位移量x
   * @param y 多选落位的位移量y
   * @returns 拖拽业务参数
   */
  public static getDragParams(dragItems: GridLayoutItemInfo[], endItem?: GridLayoutItemInfo, dragItemType?: number,
    x?: number, y?: number): FolderDragItem {
    return new FolderDragItem(dragItems, endItem, dragItemType, x, y);
  }
}

/**
 * 拖拽参数信息封装类，用于DragViewModel业务类
 */
export class FolderDragItem {
  // 拖拽的元素
  private dragItems: GridLayoutItemInfo[] = [];

  // 拖拽覆盖的元素
  private endItem?: GridLayoutItemInfo;

  // 多选拖拽落位位移X
  private dropX?: number;

  // 多选拖拽落位位移Y
  private dropY?: number;

  /* 拖拽元素来源 */
  private dragItemType: number | undefined;

  /* 拖拽创建文件夹时的item */
  private createFolderInfo: GridLayoutItemInfo | undefined;

  /* 用于存储dock区文件夹刷新后 布局元素 */
  private appList: GridLayoutItemInfo[] = [];

  /* 更新dock区的数据 */
  isDock: boolean = false;

  /* 拖拽覆盖的元素 */
  dragCoverItem: DragCoveredItem | undefined;

  /* 刷新区域 */
  refreshType: number = FolderDataRefreshType.DESKTOP;

  constructor(items: GridLayoutItemInfo[], endItem?: GridLayoutItemInfo, dragItemType?: number, dropX?: number, dropY?: number) {
    this.dragItems = items;
    if (dropX) {
      this.dropX = dropX;
    }
    if (dropY) {
      this.dropY = dropY;
    }
    if (endItem) {
      this.endItem = endItem;
    }
    if (dragItemType) {
      this.dragItemType = dragItemType;
    }
  }

  /**
   * 获取拖拽的元素
   *
   * @returns 拖拽元素列表
   */
  public getDragItems(): GridLayoutItemInfo[] {
    return this.dragItems;
  }

  /**
   * 获取松手落位的x方向位置
   *
   * @returns
   */
  public getDropX(): number | undefined {
    return this.dropX;
  }

  /**
   * 获取松手落位的y方向位置
   *
   * @returns
   */
  public getDropY(): number | undefined {
    return this.dropY;
  }

  /**
   * 获取拖拽松手时，被覆盖的元素
   *
   * @returns 覆盖元素
   */
  public getEndItem(): GridLayoutItemInfo {
    return this.endItem as GridLayoutItemInfo;
  }

  /**
   * 设置创建的文件夹元素
   *
   * @param folder 文件夹
   */
  public setCreateFolderInfo(folder: GridLayoutItemInfo): void {
    this.createFolderInfo = folder;
  }

  /**
   * 获取创建的文件夹
   *
   * @returns
   */
  public getCreateFolderInfo(): GridLayoutItemInfo {
    return this.createFolderInfo as GridLayoutItemInfo;
  }

  /**
   * 获取拖拽item来源
   *
   * @returns
   */
  public getDragItemType(): number | undefined {
    return this.dragItemType;
  }

  /**
   * 设置刷新区域
   *
   * @param type 区域类型
   * @returns 当前对象
   */
  public setRefreshType(type: number): FolderDragItem {
    this.refreshType = type;
    return this;
  }

  /**
   * 设置文件夹中应用元素
   *
   * @param items 应用列表
   */
  public setAppList(items: GridLayoutItemInfo[]): void {
    this.appList = items;
  }

  /**
   * 获取文件夹中应用元素
   *
   * @returns
   */
  public getAppList(): GridLayoutItemInfo[] {
    return this.appList;
  }
}