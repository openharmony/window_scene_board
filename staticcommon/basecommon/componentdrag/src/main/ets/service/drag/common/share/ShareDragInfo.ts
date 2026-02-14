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

import { DragGridItem, DragGridInfo, DragScene } from '../type/CommonTypes';

const EMPTY_INFO: DragGridInfo = {
  dragItem: [],
  from: DragScene.UNKNOWN,
  to: DragScene.UNKNOWN,
};

/**
 * 拖拽行为信息数据共享类
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
    return this.dragInfo ?? EMPTY_INFO;
  }

  /**
   * 获取拖拽元素
   *
   * @returns 拖拽元素
   */
  public getDragItem(): DragGridItem[] {
    return this.getDragInfo().dragItem;
  }

  /**
   * 获取拖拽开始场景
   *
   * @returns 拖拽场景
   */
  public getDragFrom(): DragScene {
    return this.getDragInfo().from;
  }

  /**
   * 获取拖拽结束场景
   *
   * @returns 拖拽场景
   */
  public getDragTo(): DragScene {
    return this.getDragInfo().to ?? DragScene.UNKNOWN;
  }
}