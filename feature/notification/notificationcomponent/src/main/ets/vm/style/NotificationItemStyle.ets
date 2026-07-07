/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
 */

/**
 * 通知项UI属性样式
 */
@Observed
export class NotificationItemStyle {
  /**
   * 通知按钮文本颜色
   */
  public actionButtonFontColor: ResourceColor = $r('app.color.ntf_action_font_color');

  /**
   * 通知按钮悬停背景色
   */
  public actionButtonBgColorHover: ResourceColor = $r('app.color.ntf_action_bg_hover_color');

  /**
   * 通知按钮按压背景色
   */
  public actionButtonBgColorPress: ResourceColor = $r('app.color.ntf_action_bg_selected_color');

  /**
   * 通知隐藏应用名高度
   */
  public hideNtfContentAppNameHeight?: Length | null;
  /**
   * 通知隐藏内容边距
   */
  public hideNtfContentMargin?: Margin | Length | null;

  /**
   * 是否禁用条目横滑
   */
  public isDisableSwipe?: boolean;

  /**
   * 条目数据更新动效
   */
  public itemUpdateAnim?: AnimateParam;

  /**
   * 通知项阴影
   */
  public shadow?: ShadowOptions | null;

  /**
   * 初始阴影
   */
  private oriShadow?: ShadowOptions;

  /**
   * 切换阴影
   */
  private chShadow?: ShadowOptions;

  /**
   * 设置阴影效果
   *
   * @param shadow 阴影
   */
  public setShadowOptions(shadow?: ShadowOptions): void {
    this.shadow = shadow;
    if (shadow) {
      this.oriShadow = shadow;
      this.chShadow = {
        radius: (shadow.radius as number) + 1,
        color: shadow.color,
        offsetX: shadow.offsetX,
        offsetY: shadow.offsetY
      };
    } else {
      this.oriShadow = undefined;
      this.chShadow = undefined;
    }
  }

  /**
   * 设置单个通知隐藏样式
   *
   * @param shadow 应用标题高度
   * @param margin 隐藏内容外边距
   */
  public setHideNtfContentStyle(appNameHeight?: Length, margin?: Margin | Length): void {
    this.hideNtfContentAppNameHeight = appNameHeight;
    this.hideNtfContentMargin = margin;
  }

  /**
   * 动态切换阴影，用于刷新阴影
   */
  public changeShadow(): void {
    if (this.shadow) {
      let isOri = this.shadow === this.oriShadow;
      this.shadow = isOri ? this.chShadow : this.oriShadow;
    }
  }
}