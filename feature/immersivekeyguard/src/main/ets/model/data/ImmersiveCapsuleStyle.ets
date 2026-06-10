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
 * 沉浸胶囊固定UI样式
 */
import { ImmersiveCapsuleConstants as CapConst } from '../../common/constants/ImmersiveCapsuleConstants';

@Observed
export class ImmersiveCapsuleStyle {
  /**
   * 胶囊阴影样式
   */
  public shadeStyle?: ShadowOptions | ShadowStyle;

  /**
   * 胶囊背景模糊效果
   */
  public backgroundEffect?: BackgroundEffectOptions;

  /**
   * 胶囊宽度，默认无
   */
  public width?: number | string;

  /**
   * 胶囊容器宽度，默认无
   */
  public rootWidth?: number | string;

  /**
   * 胶囊高度，默认无
   */
  public height?: number | string;

  /**
   * 胶囊容器高度，默认无
   */
  public rootHeight?: number | string;

  /**
   * 外间距
   */
  public margin?: Margin | number;

  /**
   * 圆角
   */
  public borderRadius?: number | BorderRadiuses;

  /**
   * 按钮数量
   */
  public btnCount: number = 1;

  /**
   * 透明度
   */
  public alpha?: number;

  /**
   * 背景模糊颜色
   */
  public effectColor: ResourceColor = $r('app.color.immersive_capsule_effect_color');

  /**
   * 提亮压暗
   */
  public isDarken: boolean = false;

  /**
   * 胶囊图标点击监听
   */
  public onIconClick?: () => void;

  /**
   * 胶囊点击监听
   */
  public onClick?: () => void;

  /**
   * 胶囊长按监听
   */
  public onLongClick?: () => void;
}

export class CapStyleBuilder {
  /**
   * 阴影样式，默认值
   */
  private shadeStyle: ShadowOptions | ShadowStyle = {
    radius: 50,
    color: $r('app.color.immersive_capsule_shade_style_color'),
    offsetX: 0,
    offsetY: 8
  };

  /**
  * 胶囊背景模糊效果，默认值
  */
  private backgroundEffect: BackgroundEffectOptions = {
    policy: 1,
    radius: 80,
    saturation: 1.00,
    brightness: 1.08,
  };

  /**
   * 背景模糊颜色
   */
  private effectColor: ResourceColor = $r('app.color.immersive_capsule_effect_color');


  /**
   * 胶囊宽度，默认无
   */
  private width?: number | string;

  /**
   * 胶囊容器宽度，默认无
   */
  private rootWidth?: number | string;

  /**
   * 胶囊高度，默认无
   */
  private height?: number | string;

  /**
   * 胶囊容器高度，默认无
   */
  private rootHeight?: number | string;

  /**
   * 外间距，默认无
   */
  private margin?: Margin | number;

  /**
   * 圆角，默认24
   */
  private borderRadius: number | BorderRadiuses = CapConst.CAPSULE_RADIUS;

  /**
   * 透明度，默认不透明
   */
  private alpha: number = 1.0;

  /**
   * 提亮压暗
   */
  private isDarken: boolean = false;

  /**
   * 胶囊图标点击监听
   */
  private onIconClick?: () => void;

  /**
   * 胶囊点击监听
   */
  private onClick?: () => void;

  /**
   * 胶囊长按监听
   */
  private onLongClick?: () => void;

  /**
   * 私有构造
   */
  private constructor() {
  }

  /**
   * 绑定阴影样式
   *
   * @param style 阴影样式
   * @returns 链式
   */
  bindShadeStyle(style: ShadowOptions | ShadowStyle): CapStyleBuilder {
    this.shadeStyle = style;
    return this;
  }

  /**
   * 绑定背景模糊参数
   *
   * @param options 模糊参数
   * @returns 链式
   */
  bindBgEffect(options: BackgroundEffectOptions): CapStyleBuilder {
    this.backgroundEffect = options;
    return this;
  }

  /**
   * 绑定宽度
   *
   * @param width 宽度
   * @returns 链式
   */
  bindWidth(width: number | string): CapStyleBuilder {
    this.width = width;
    return this;
  }

  /**
   * 绑定容器宽度
   *
   * @param width 宽度
   * @returns 链式
   */
  bindRootWidth(width: number | string): CapStyleBuilder {
    this.rootWidth = width;
    return this;
  }

  /**
   * 绑定高度
   *
   * @param height 高度
   * @returns 链式
   */
  bindHeight(height: number | string): CapStyleBuilder {
    this.height = height;
    return this;
  }

  /**
   * 绑定容器高度
   *
   * @param height 高度
   * @returns 链式
   */
  bindRootHeight(height: number | string): CapStyleBuilder {
    this.rootHeight = height;
    return this;
  }

  /**
   * 绑定外间距
   *
   * @param margin 外间距
   * @returns 链式
   */
  bindMargin(margin: Margin | number): CapStyleBuilder {
    this.margin = margin;
    return this;
  }

  /**
   * 绑定圆角
   *
   * @param radius 圆角
   * @returns 链式
   */
  bindBoardRadius(radius: number | BorderRadiuses): CapStyleBuilder {
    this.borderRadius = radius;
    return this;
  }

  /**
   * 绑定透明度
   *
   * @param alpha 透明度
   * @returns 链式
   */
  bindAlpha(alpha: number): CapStyleBuilder {
    this.alpha = alpha;
    return this;
  }

  /**
   * 绑定胶囊背景模糊颜色
   *
   * @param alpha 透明度
   * @returns 链式
   */
  bindEffectColor(effectColor: ResourceColor): CapStyleBuilder {
    this.effectColor = effectColor;
    return this;
  }

  /**
   * 提亮压暗标识
   */
  bindIsDarken(isDarken: boolean): CapStyleBuilder {
    this.isDarken = isDarken;
    return this;
  }

  /**
   * 绑定胶囊图标点击事件
   *
   * @param click 监听
   * @returns 链式
   */
  bindIconClick(click: () => void): CapStyleBuilder {
    this.onIconClick = click;
    return this;
  }

  /**
   * 绑定胶囊点击事件
   *
   * @param click 监听
   * @returns 链式
   */
  bindClick(click: () => void): CapStyleBuilder {
    this.onClick = click;
    return this;
  }

  /**
   * 绑定胶囊长按事件
   *
   * @param click 监听
   * @returns 链式
   */
  bindLongClick(click: () => void): CapStyleBuilder {
    this.onLongClick = click;
    return this;
  }

  /**
   * 构建沉浸胶囊UI样式
   *
   * @returns UI样式
   */
  build(): ImmersiveCapsuleStyle {
    let style = new ImmersiveCapsuleStyle();
    style.shadeStyle = this.shadeStyle;
    style.backgroundEffect = this.backgroundEffect;
    style.width = this.width;
    style.rootWidth = this.rootWidth;
    style.height = this.height;
    style.rootHeight = this.rootHeight;
    style.margin = this.margin;
    style.borderRadius = this.borderRadius;
    style.alpha = this.alpha;
    style.isDarken = this.isDarken;
    style.effectColor = this.effectColor;
    style.onIconClick = this.onIconClick;
    style.onClick = this.onClick;
    style.onLongClick = this.onLongClick;
    return style;
  }

  /**
   * 创建构造器
   *
   * @returns 构造器
   */
  static builder(): CapStyleBuilder {
    return new CapStyleBuilder();
  }
}