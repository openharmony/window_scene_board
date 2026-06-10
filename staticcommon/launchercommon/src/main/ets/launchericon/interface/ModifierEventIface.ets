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

/**
 * Modifier 事件类接口
 */
export interface ModifierEventIface {
  /**
   * 初始化Touch事件
   * @param instance Modifier实例
   */
  initTouchEvent(instance?: CommonAttribute): void;

  /**
   * 初始化click事件
   * @param instance Modifier实例
   */
  initClickEvent(instance?: CommonAttribute): void;

  /**
   * 初始化拖拽事件
   * @param instance Modifier实例
   */
  initDragEvent(instance?: CommonAttribute): void

  /**
   * 初始化手势判断事件
   * @param instance Modifier实例
   */
  initGestureJudgeBeginEvent(instance?: CommonAttribute): void;

  /**
   * 初始化长按事件
   * @param instance
   */
  initLongPressGestureEvent(instance?: CommonAttribute): void;

  /**
   * 初始化菜单事件
   * @param instance
   */
  initMenuEvent(instance?: CommonAttribute): void;
}
