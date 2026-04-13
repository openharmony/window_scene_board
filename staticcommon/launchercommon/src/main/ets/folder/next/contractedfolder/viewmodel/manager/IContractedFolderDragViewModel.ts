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

import { image } from '@kit.ImageKit';
import { SnapshotType } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { FolderDragItem, GridLayoutItemInfo } from '../../../../../TsIndex';

/**
 * 折叠态文件夹View组件的控制接口，由Feature层里的ViewModel实现
 */
export interface IContractedFolderDragViewModel {
  /**
   * 初始化拖拽相关的Listener
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   */
  registerListener(msg: string, folderId: string): void;

  /**
   * 取消注册拖拽相关的Listener
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   */
  unregisterListener(msg: string, folderId: string): void;

  /**
   * 文件夹开始拖拽
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param event 拖拽事件
   * @param isDock 是否拖拽dock区文件夹
   */
  dragStart(msg: string, folderId: string, event: DragEvent): DragItemInfo;

  /**
   * 文件夹结束拖拽
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   */
  dragEnd(msg: string, folderId: string): void;

  /**
   * 展开态拖拽应用离开文件夹
   *
   * @param msg 用于DFX的日志
   * @param folderId 文件夹id
   * @param dragItemInfo 拖拽的元素
   */
  dragLeave(msg: string, folderId: string, dragItemInfo: GridLayoutItemInfo): void;

  /**
   * 文件夹准备拖拽
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param preDragStatus 准备拖拽的状态
   */
  preDrag(msg: string, folderId: string, preDragStatus: PreDragStatus): void;

  /**
   * 获取拖拽预览的option参数
   *
   * @param msg 用于DFX的日志打印
   * @param radius 圆角值
   * @returns 拖拽预览option
   */
  getDragPreviewOption(msg: string, radius: number, isSolidColor: boolean): DragPreviewOptions;

  /**
   * 获取拖拽的截图
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param type 截图类型
   * @returns 截图
   */
  getDragSnapshot(msg: string, folderId: string, type: SnapshotType): image.PixelMap | undefined;

  /**
   * 释放截图
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   */
  releaseDragSnapshot(msg: string, folderId: string): void;

  /**
   * 文件夹拖出应用后落位
   *
   * @param msg 用于DFX的日志
   * @param folderId 文件夹id
   * @param type 落位类型
   * @param param 落位参数
   */
  drop(msg: string, folderId: string, type: number, param: FolderDragItem): void;

  /**
   * 创建一个新的文件夹
   *
   * @param msg 用于DFX的日志打印
   * @param endItem 合成文件夹首个元素
   * @param items 合成文件夹的非首个元素的其他元素列表
   */
  createNewFolder(msg: string, endItem: GridLayoutItemInfo, items: GridLayoutItemInfo[]): GridLayoutItemInfo;

  /**
   * 拖拽覆盖文件夹
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param isShow 是否显示状态
   */
  onFolderCovered(msg: string, folderId: string, isShow: boolean): void;
}