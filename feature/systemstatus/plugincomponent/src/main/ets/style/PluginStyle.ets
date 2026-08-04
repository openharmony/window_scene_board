/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
 */
/**
 * plugin组件资源样式
 *
 * @since 2022-11-06
 */

export class PluginStyle {
  /**
   * 图标包裹层宽度
   */
  public iconContainerWidth: Length = 0;
  /**
   * 图标包裹层高度
   */
  public iconContainerHeight: Length = 0;
  /**
   * 图标包裹层圆角
   */
  public iconContainerRadius: Length = 0;
  /**
   * 图标包裹层内边距(vp)
   * 用于自适应图标计算图标宽度
   */
  public iconContainerPadding: number = 0;
  /**
   * 图标包裹层左侧外边距
   */
  public iconContainerLeftMargin: Length = 0;
  /**
   * 图标包裹层右侧外边距
   */
  public iconContainerRightMargin: Length = 0;
  /**
   * 图标根容器左侧外边距
   */
  public rootContainerLeftMargin: Length = 0;
  /**
   * 图标根容器右侧外边距
   */
  public rootContainerRightMargin: Length = 0;
  /**
   * 图标是否需要背景
   */
  public isNeedIconBg: boolean = false;
  /**
   * 图标背景宽度
   */
  public iconBgWidth: Length = 0;
  /**
   * 图标背景高度
   */
  public iconBgHeight: Length = 0;
  /**
   * 图标背景内间距(vp)
   * 用于自适应图标计算背景宽度
   */
  public iconBgPadding: number = 0;
  /**
   * 图标背景圆角
   */
  public iconBgRadius: Length = 0;
  /**
   * 图标背景横向偏移量
   */
  public iconBgOffsetX: Length = 0;
  /**
   * 图标背景无状态栏时颜色
   */
  public bgColorNone: ResourceColor = '#00000000';
  /**
   * 图标背景选中时颜色
   */
  public bgColorSelected: ResourceColor = '#00000000';
  /**
   * 图标背景hover时颜色
   */
  public bgColorHovered: ResourceColor = '#00000000';
  /**
   * 图标宽度
   */
  public iconWidth: Length = 0;
  /**
   * 图标高度
   */
  public iconHeight: Length = 0;
  /**
   * 图标是否允许消费touch事件
   */
  public iconEnable: boolean = false;
  /**
   * the border width
   */
  public borderWidth: number = 0;
  /**
   * the inner border color
   */
  public innerBorderColor: string = '#00000000'
  /**
   * the outer border color
   */
  public outerBorderColor: string = '#00000000'
  /**
   * the blur radius
   */
  public blurRadius: number = 0;
  /**
   * the saturation
   */
  public saturation: number = 0;
  /**
   * the background color
   */
  public bgColor: string = '#0000000'
  /**
   * the container whether or not visible
   */
  public innerContainerVisible: boolean = false;

  /**
   * 当前背景颜色
   *
   * @param isSelected 是否选中
   * @param isHovered 是否hover
   */
  public getCurrentBgColor(isSelected: boolean, isHovered: boolean, isClicked: boolean): ResourceColor {
    // 优先选中状态
    if (isSelected || isClicked) {
      return this.bgColorSelected;
    }
    // 其次hover状态
    if (isHovered) {
      return this.bgColorHovered;
    }
    return this.bgColorNone;
  }
}