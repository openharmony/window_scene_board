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
import { DragGridItem, DragGridInfo, DragType } from '../type/CommonTypes';

/**
 * 拖拽行为信息数据共享类
 *
 * @since 2024/04/10
 */
export class ShareDragInfo {
  private dragInfo: DragGridInfo;

  /**
   * 设置拖拽行为信息
   *
   * @param info 拖拽行为信息（拖拽元素及拖拽类型）
   */
  public setDragInfo(info: DragGridInfo): void {
    this.dragInfo = info;
  }

  /**
   * 获取拖拽相关信息
   *
   * @returns 拖拽行为信息
   */
  public getDragInfo(): DragGridInfo {
    return this.dragInfo;
  }

  /**
   * 获取拖拽元素
   *
   * @returns 拖拽元素
   */
  public getDragItem(): DragGridItem {
    return this.dragInfo?.dragItem;
  }

  /**
   * 获取拖拽类型
   *
   * @returns 拖拽类型
   */
  public getDragType(): DragType {
    if (this.dragInfo && this.dragInfo.dragType) {
      return this.dragInfo.dragType;
    }
    return DragType.NOT_IN_DRAG;
  }
}