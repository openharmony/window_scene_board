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

export interface AppIconContextMenuIface {
  /**
   * 是否显示菜单内容
   * @returns boolean, true 显示, false 隐藏
   */
  showContextMenu: () => boolean;

  /**
   * 获取菜单内容builder
   * @returns CustomBuilder
   */
  getContentBuilder: () => CustomBuilder;

  /**
   * 获取鼠标右键菜单的配置信息
   * @param placement 菜单位置
   * @returns ContextMenuOptions
   */
  getRightClickMenuOptions: (placement: Placement) => ContextMenuOptions;

  /**
   * 获取手势长按菜单的配置信息
   * @returns ContextMenuOptions
   */
  getLongPressMenuOptions: () => ContextMenuOptions;

  /**
   * 菜单隐藏回调
   */
  onMenuDisappear: () => void;

  /**
   * 菜单显示回调
   */
  onMenuAppear: () => void;
}