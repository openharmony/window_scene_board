/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
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