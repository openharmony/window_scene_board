/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
/**
 * menu组件资源样式
 *
 * @since 204-3-27
 */

export class MenuStyle {
  /**
   * 菜单默认宽度
   */
  public defaultMenuWidth: Length = 160;

  /**
   * 菜单项默认高度
   */
  public defaultMenuHeight: Length = 40;

  /**
   * 菜单底板圆角
   */
  public menuContainerRadius: Length = 16;

  /**
   * 菜单项交互底板圆角
   */
  public menuItemRadius: Length = 12;

  /**
   * 菜单上方外边距
   */
  public menuTopMargin: Length = 2;

  /**
   * 菜单底板右侧内边距
   */
  public menuContainerRightPadding: Length = 4;

  /**
   * 菜单底板左侧内边距
   */
  public menuContainerLeftPadding: Length = 4;

  /**
   * 菜单底板上方内边距
   */
  public menuContainerTopPadding: Length = 4;

  /**
   * 菜单底板下方内边距
   */
  public menuContainerBottomPadding: Length = 4;

  /**
   * 菜单退出项
   */
  public exitItemText: ResourceStr = $r('app.string.exit');
}