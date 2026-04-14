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

export interface ILiveHeadsUpSwipeVm {
  /**
   * 是否触摸中
   */
  isTouching: boolean;
  /**
   * 开始横滑
   */
  onHorizontalPanStart(event: GestureEvent): void;
  /**
   * 更新横滑
   */
  onHorizontalPanUpdate(event: GestureEvent): void;
  /**
   * 结束横滑
   */
  onHorizontalPanEnd(event: GestureEvent): Promise<void>;
  /**
   * 取消横滑
   */
  onHorizontalPanCancel(): void;
  /**
   * 开始竖滑
   */
  onVerticalPanStart(event: GestureEvent): void;
  /**
   * 更新竖滑
   */
  onVerticalPanUpdate(event: GestureEvent): void;
  /**
   * 结束竖滑
   */
  onVerticalPanEnd(event: GestureEvent): Promise<void>;
  /**
   * 取消竖滑
   */
  onVerticalPanCancel(): void;
}