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

import { DragGridInfo, DragGridLayout, DragCallbackParams } from './CommonTypes';

/**
 * drag模块类型
 */
export enum DragManagerMode {
  /**
   * 拖拽元素模式
   */
  ITEM = 0,

  /**
   * 拖拽热区模式
   */
  AREA = 1,
}

/**
 * 拖拽管理模块参数
 */
export interface DragParams {
  /**
   * 拖拽模式
   */
  mode: DragManagerMode;

  /**
   * 被拖ITEM唯一标识，用于监听拖拽状态
   */
  key?: string;

  /**
   * ITEM模式下拖拽行为相关信息
   */
  dragInfo?: DragGridInfo;

  /**
   * AREA模式下布局相关信息
   */
  dragLayout?: DragGridLayout;

  /**
   * 被拖ITEM起拖回调
   *
   * @param params 拖拽相关回调参数
   */
  itemDragStartCallback?: (params: DragCallbackParams) => void;

  /**
   * 被拖ITEM松手回调
   *
   * @param params 拖拽相关回调参数
   */
  itemDragEndCallback?: (params: DragCallbackParams) => void;

  /**
   * 被拖ITEM进入热区回调
   *
   * @param params 拖拽相关回调参数
   */
  areaDragEnterCallback?: (params: DragCallbackParams) => void;

  /**
   * 被拖ITEM离开热区回调
   *
   * @param params 拖拽相关回调参数
   */
  areaDragLeaveCallback?: (params: DragCallbackParams) => void;

  /**
   * 被拖ITEM在热区松手回调
   *
   * @param params 拖拽相关回调参数
   */
  areaDragDropCallback?: (params: DragCallbackParams) => void;
}

/**
 * 拖拽监听器的优先级
 */
export enum DragListenerPriority {
  /**
   * 优先级低，回调延迟执行，优化起拖性能
   */
  LOW = 0,

  /**
   * 优先级高，回调立即执行
   */
  HIGH = 1,
}

/**
 * 拖拽事件监听器
 */
export interface DragListener {
  /**
   * 监听器id
   */
  id: string;

  /**
   * 监听器的优先级
   */
  priority: DragListenerPriority;

  /**
   * 拖拽开始回调
   *
   * @param info 拖拽行为信息
   */
  dragStart?: (info: DragGridInfo) => void;

  /**
   * 拖拽结束回调
   *
   * @param info 拖拽行为信息
   */
  dragEnd?: (info: DragGridInfo) => void
}