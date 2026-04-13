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

/**
 * 分隔符拖拽事件
 */
export interface IDividerDragEvent {
  /**
   * 拖拽中事件
   *
   * @param event 手势事件
   * @returns 区域宽度
   */
  onActionUpdate: (event?: GestureEvent) => number;

  /**
   * 拖拽结束事件
   *
   * @param layoutWidth 当前预期宽度
   * @param event 手势事件
   * @returns 最终区域宽度
   */
  onActionEnd: (layoutWidth: number, event?: GestureEvent) => number;
}

