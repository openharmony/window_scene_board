/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * 文本固定UI样式
 */
@Observed
export class ImmersiveTextStyle {
  /**
   * 文本字体大小
   */
  @Track private fontSize?: number | string | Resource;
  /**
   * 文本字体颜色
   */
  @Track private fontColor?: ResourceColor;
  /**
   * 文本字重
   */
  @Track private fontWeight?: number | FontWeight | string;

  private constructor() {
  }

  /**
   * 设置字体大小
   *
   */
  setFontSize(fontSize?: number | string | Resource): ImmersiveTextStyle {
    this.fontSize = fontSize;
    return this;
  }

  /**
   * 获取字体大小
   *
   */
  getFontSize(): number | string | Resource | undefined {
    return this.fontSize;
  }

  /**
   * 设置字体颜色
   *
   */
  setColor(color?: ResourceColor): ImmersiveTextStyle {
    this.fontColor = color;
    return this;
  }

  /**
   * 获取字体颜色
   *
   */
  getColor(): ResourceColor | undefined {
    return this.fontColor;
  }

  /**
   * 设置字重
   *
   */
  setTextWeight(weight?: number | FontWeight | string): ImmersiveTextStyle {
    this.fontWeight = weight;
    return this;
  }

  /**
   * 获取字重
   *
   */
  getTextWeight(): number | FontWeight | string | undefined {
    return this.fontWeight;
  }

  static wrapper(): ImmersiveTextStyle {
    return new ImmersiveTextStyle();
  }
}
