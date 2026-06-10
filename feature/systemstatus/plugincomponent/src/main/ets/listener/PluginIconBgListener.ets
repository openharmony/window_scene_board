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

import { PluginBaseListener } from './PluginBaseListener';

/**
 * PluginIconBackgroundComponent组件通信监听器
 *
 * @since 2022-10-27
 */
export interface PluginIconBgListener extends PluginBaseListener {
  /**
   * 选中状态切换
   *
   * @param isSelected是否选中
   */
  onSelectedChange(isSelected: boolean): void;

  /**
     * click事件
     */
  onClicked(): void;

  /**
   * hover状态切换
   *
   * @param isHovered是否hover
   */
  onHoveredChange(isHovered: boolean): void;
}