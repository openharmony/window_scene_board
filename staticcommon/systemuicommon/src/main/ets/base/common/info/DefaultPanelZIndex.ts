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
 * 面板默认层级
 */
export enum DefaultPanelZIndex {
  /**
   * 普通应用面板层级
   */
  PANEL_SCENE_PANEL = 100,

  /**
   * 悬浮球面板
   */
  PANEL_FLOATING_BALL = 995,

  /**
   * banner面板
   */
  PANEL_BANNER = 1904,

  /**
   * 锁屏面板
   */
  PANEL_SCREEN_LOCK = 2000,

  /**
   * 手势面板
   */
  PANEL_GESTURE_TOP_BAR = 2125,

  /**
   * 通知、控制中心面板
   */
  PANEL_DROPDOWN = 2201,

  /**
   * 状态栏面板
   */
  PANEL_STATUS_BAR = 2202,

  /**
   * 打开通知设置弹窗，设置状态栏层级，状态栏层级比通知、控制中心面板层级高，状态栏层级需降级
   * 关闭通知设置弹窗，重置状态栏层级
   */
  PANEL_STATUS_BAR_LOWER = 2200
}