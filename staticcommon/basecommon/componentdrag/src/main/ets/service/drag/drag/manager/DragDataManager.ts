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
import { LogDomain, LogHelper } from '@ohos/basicutils';

import { ShareDataManager } from '../../common/share/ShareDataManager';
import { ShareDragInfo } from '../../common/share/ShareDragInfo';
import { ShareDragStatus } from '../../common/share/ShareDragStatus';
import { DragGridItem, DragScene } from '../../common/type/CommonTypes';

const TAG = 'Drag-DragDataManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 拖拽信息共享类，仅对外开放
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
  public getDragItem(): DragGridItem[] {
    return this.shareDragInfo.getDragItem();
  }

  /**
   * 获取拖拽开始场景
   *
   * @returns 拖拽场景
   */
  public getDragFrom(): DragScene {
    return this.shareDragInfo.getDragFrom();
  }

  /**
   * 获取拖拽数据管理类单例
   *
   * @returns 单例
   */
  static getInstance(): DragDataManager {
    if (globalThis.DragDataManager == null) {
      globalThis.DragDataManager = new DragDataManager();
    }
    return globalThis.DragDataManager;
  }
}