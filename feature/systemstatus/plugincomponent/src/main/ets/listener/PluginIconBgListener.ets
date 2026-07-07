/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
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