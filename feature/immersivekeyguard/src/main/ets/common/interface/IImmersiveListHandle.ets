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

import { IImmersiveGraftVm } from './IImmersiveGraftVm';
import { IImmGestureEventVm } from './IImmGestureEventVm';
import { IImmLifeCycleVm } from './IImmLifeCycleVm';

/**
 * 沉浸列表模块触摸事件处理
 */
export interface IImmersiveListHandle extends IImmersiveGraftVm, IImmGestureEventVm, IImmLifeCycleVm {
  /**
   * 列表触摸事件回调处理
   *
   * @param event 触摸事件
   */
  onListTouchEvent(event: TouchEvent): void;

  /**
   * 条目事件拦截回调
   *
   * @param event 事件
   * @param itemKey 条目标识
   * @returns 事件拦截模式
   */
  onItemTouchIntercept(event: TouchEvent, itemKey?: string): HitTestMode;

  /**
   * 手势触发时回调
   *
   * @param direction 手势方向
   * @param event 手势事件
   */
  onGestureStart(direction: PanDirection, event: GestureEvent): void;

  /**
   * 手势更新时回调
   *
   * @param direction 手势方向
   * @param event 手势事件
   */
  onGestureUpdate(direction: PanDirection, event: GestureEvent): void;

  /**
   * 手势结束时回调
   *
   * @param direction 手势方向
   * @param isCancel 是否为取消手势
   * @param event 手势事件
   */
  onGestureEnd(direction: PanDirection, isCancel: boolean, event?: GestureEvent): void;

  /**
   * 列表开始滑动回调
   */
  scrollStart(): void;

  /**
   * 列表滑动触顶、触底回调
   */
  scrollReachStartEnd(): void;

  /**
   * 列表滚动帧生效前回调
   *
   * @param offset 滚动偏移
   */
  scrollFrameBegin(offset: number): void;

  /**
   * 列表滚动生效时回调
   *
   * @param offset 滚动偏移
   * @param isResolveWait 是否释放等待
   */
  scrollList(offset: number, isResolveWait?: boolean): void;
}