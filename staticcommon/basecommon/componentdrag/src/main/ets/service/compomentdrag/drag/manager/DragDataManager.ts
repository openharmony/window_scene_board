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
import { ShareDataManager } from '../../common/share/ShareDataManager';
import { ShareDragInfo } from '../../common/share/ShareDragInfo';
import { ShareDragStatus } from '../../common/share/ShareDragStatus';
import { DragGridItem, DragType } from '../../common/type/CommonTypes';
import { SingletonHelper } from '@ohos/basicutils';

const TAG = 'Drag-DragDataManager';

/**
 * 拖拽信息共享类，仅对外开放
 *
 * @since 2024/04/10
 */
export class DragDataManager {
  private shareDragInfo: ShareDragInfo = ShareDataManager.getInstance(ShareDragInfo, 'ShareDragInfo');
  private shareDragStatus: ShareDragStatus = ShareDataManager.getInstance(ShareDragStatus, 'ShareDragStatus');

  /**
   * 获取拖拽状态
   *
   * @returns 是否处于拖拽状态
   */
  public isDragging(): boolean {
    return this.shareDragStatus.isDragging();
  }

  /**
   * 获取拖拽元素
   *
   * @returns 拖拽元素
   */
  public getDragItem(): DragGridItem {
    return this.shareDragInfo.getDragItem();
  }

  /**
   * 获取拖拽类型
   *
   * @returns 拖拽类型
   */
  public getDragType(): DragType {
    return this.shareDragInfo.getDragType();
  }
}

export const dragDataManager: DragDataManager = SingletonHelper.getInstance(DragDataManager, TAG);