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

import { NotificationBase } from '../../model/NotificationBase';

export interface INotificationSwipeVm {
  /**
   * 横向偏移量
   * @returns
   */
  offsetX: number;

  /**
   * 左滑阈值
   * @param itemWidth
   */
  setLeftThreshold(threshold: number): void;

  /**
   * 右滑阈值
   * @param itemWidth
   */
  setRightThreshold(threshold: number): void;

  /**
   * 重置偏移
   */
  resetOffsetX(isResetCurrent?: boolean): void;

  /**
   * 删除通知滑动
   * @returns
   */
  removeNtf(): void;

  /**
   * 获取滑动手势handler
   * @returns
   */
  getPanGestureHandler(): PanGestureHandler;

  /**
   * 获取滑动无障碍说明
   * @returns
   */
  getSwipeAccessibilityDescription(): string;

  /**
   * 获取滑动无障碍说明
   * @returns
   */
  getRemoveAccessibilityId(removeNtf: NotificationBase): string;
}