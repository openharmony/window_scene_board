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
import { CommonUtils } from '@ohos/basicutils';
import { BaseObj } from '../constants/BaseType';
import { LIMIT_DEFAULT, WBaseProperty, WDefault, WLimitValue, WProperty } from '../constants/WidgetPropertyConst';
import { IBaseState } from '../interface/IBaseState';
import { BindBaseStateV2 } from './BindBaseStateV2';
import { LimitMap } from '../utils/LimitMap';
import { INestableState } from '../interface/INestableState';

/**
 * 线性渐变颜色参数
 */
export interface LinearGradient {
  angle?: number | string;
  direction?: GradientDirection;
  colors: Array<[ResourceColor, number]>;
  repeating?: boolean;
}

/**
 * 组件属性状态集
 */
@ObservedV2
export abstract class WidgetPropertyStateV2<T extends WidgetPropertyStateV2<T>> extends BindBaseStateV2
  implements INestableState<T> {
  // 子组件状态集
  @Trace private childrenState: LimitMap<string, T> = new LimitMap();
  // 状态属性值限制集
  @Trace private limitValue: LimitMap<string, WLimitValue> = new LimitMap();
  // 是否赋值子组件属性
  @Trace private isSetChildState: boolean = false;
  // 透明度
  @Trace private alpha?: number;
  // 平移
  @Trace private tranX?: number;
  @Trace private tranY?: number;
  @Trace private tranZ?: number;
  // 缩放
  @Trace private scaleX?: number;
  @Trace private scaleY?: number;
  @Trace private scaleZ?: number;
  // 缩放中心点
  @Trace private scaleCenterX?: number | string;
  @Trace private scaleCenterY?: number | string;
  // 旋转轴 1标示开启
  @Trace private rotateX?: number;
  @Trace private rotateY?: number;
  @Trace private rotateZ?: number;
  // 旋转视角高度
  @Trace private rotatePerspective?: number;
  // 旋转角度
  @Trace private rotateAngle?: number;
  // 旋转中心点
  @Trace private rotateCenterX?: number | string;
  @Trace private rotateCenterY?: number | string;
  @Trace private rotateCenterZ?: number | string;
  // 组件大小
  @Trace private width?: number | string;
  @Trace private height?: number | string;
  // 组件背景大小
  @Trace private bgWidth?: number | string;
  @Trace private bgHeight?: number | string;
  // 组件切割开启
  @Trace private isClip?: boolean;
  // 组件裁剪区域
  @Trace private clipWidth?: number | string;
  @Trace private clipHeight?: number | string;
  @Trace private clipOffsetX?: number;
  @Trace private clipOffsetY?: number;
  // 圆角
  @Trace private borderRadiusTL?: number;
  @Trace private borderRadiusTR?: number;
  @Trace private borderRadiusBL?: number;
  @Trace private borderRadiusBR?: number;
  // 外间距
  @Trace private marginL?: number;
  @Trace private marginR?: number;
  @Trace private marginT?: number;
  @Trace private marginB?: number;
  // 内间距
  @Trace private paddingL?: number;
  @Trace private paddingR?: number;
  @Trace private paddingT?: number;
  @Trace private paddingB?: number;
  // 字体大小
  @Trace private fontSize?: Length;
  // 字体颜色
  @Trace private fontColor?: ResourceColor;
  // 字体样式
  @Trace private fontFamily?: ResourceStr;
  // 字重
  @Trace private fontWeight?: number | FontWeight | string;
  // 字体特性
  @Trace private fontFeature?: string;
  // 文本最大行数
  @Trace private maxLines?: number;
  // 文本超长时模式
  @Trace private textOverflow?: TextOverflow;
  // 文本最小字体大小
  @Trace private minFontSize?: number | string | Resource;
  // 文本最大字体大小
  @Trace private maxFontSize?: number | string | Resource;
  // 文本最小缩放值
  @Trace private minFontScale?: number | Resource;
  // 文本最大缩放值
  @Trace private maxFontScale?: number | Resource;
  // 可拖拽
  @Trace private draggable?: boolean;
  // 绘制缓存
  @Trace private renderGroup?: boolean;
  // 组件模糊开启
  @Trace private useEffect?: boolean;
  // 内容模糊半径
  @Trace private blur?: number;
  // 边缘模糊半径
  @Trace private linearBlur?: number;
  // 线性渐变颜色
  @Trace private linearGradient?: LinearGradient;
  // 背景模糊样式
  @Trace private bgBlurStyle?: BlurStyle;
  // 组件层级
  @Trace private zIndex?: number;
  // 组件位置
  @Trace private position?: Position;
  // 组件偏移位置
  @Trace private offset?: Position;
  // 组件锚点
  @Trace private markAnchor?: Position;
  // 组件可见性
  @Trace private visibility?: Visibility;
  // 组件对齐方式
  @Trace private alignContent?: Alignment;
  // 转场动效
  @Trace private transition?: TransitionEffect;
  // 组件id
  @Trace private id?: string;
  // 共享元素ID
  @Trace private geometryId?: string;
  // 组件内容混合
  @Trace private blendMode?: BlendMode;
  // 相对布局规则
  @Trace private alignRules?: AlignRuleOption;
  // 图片填充颜色
  @Trace private _fillColor?: ResourceColor;
  // 图片颜色过滤器
  @Trace private _colorFilter?: ColorFilter;
  // 背景颜色
  @Trace private bgColor?: ResourceColor;
  // 前景颜色
  @Trace private fgColor?: ResourceColor;
  // 提亮数值
  @Trace private brightness?: number;
  // 前景提亮参数
  @Trace private fgBrightness?: BrightnessOptions;
  // 背景提亮参数
  @Trace private bgBrightness?: BackgroundBrightnessOptions;
  // 内部接口，背景提亮参数
  @Trace private bgBrightnessInner?: BrightnessOptions;
  // EffectComponent背景模糊参数
  @Trace private bgEffect?: BackgroundEffectOptions;
  // 图片亮度
  @Trace private lightUpEffect?: number;
  // 点击缩放效果
  @Trace private _clickEffect?: ClickEffect;
  // 光投影效果
  @Trace private _pointLight?: PointLightStyle;
  // 组件是否可交互，默认可交互
  @Trace private _isEnable?: boolean;
  // 组件点击事件
  @Trace private _onClick?: () => void;
  // 组件无障碍等级
  @Trace private _accessibilityLevel: string = 'no';
  // 组件无障碍播报文本
  @Trace private _accessibilityText?: Resource;
  // 组件条目间距
  @Trace private _itemSpace?: string | number;
  // 文本组件行高
  @Trace private _lineHeight?: number;
  // 组件阴影参数
  @Trace private _shadow?: ShadowOptions | ShadowStyle;
  // 组件动态手势
  @Trace private _gestureModifier?: GestureModifier;
  // Image图片资源
  @Trace private _imgSrc?: PixelMap | ResourceStr | DrawableDescriptor;

  private getLimit(property: WProperty): WLimitValue | undefined {
    // 优先动态限制值
    let limit = this.limitValue.get(property);
    if (limit) {
      return limit;
    }
    // 默认限制值
    return LIMIT_DEFAULT.get(property);
  }

  private getValidValue(property: WProperty, oriValue?: number): number | undefined {
    if (oriValue) {
      // 限制最小、最大值
      let limit = this.getLimit(property);
      let min = limit?.minValue as number;
      if (CommonUtils.isNumber(min) && oriValue < min) {
        return min;
      }
      let max = limit?.maxValue as number;
      if (CommonUtils.isNumber(max) && oriValue > max) {
        return max;
      }
    }
    return oriValue;
  }

  private equalsPosition(ori?: Position, dest?: Position): boolean {
    let oriX = ori?.x ?? WDefault.INVALID_VALUE;
    let oriY = ori?.y ?? WDefault.INVALID_VALUE;
    let destX = dest?.x ?? WDefault.INVALID_VALUE;
    let destY = dest?.y ?? WDefault.INVALID_VALUE;
    return oriX === destX && oriY === destY;
  }

  private checkSetChildProperty(property: WProperty, value?: BaseObj): boolean {
    // 子组件直接赋值
    if (this.isSetChildState) {
      this.childrenState.forEach((child) => {
        child.setStateValue(property, value);
      });
      return true;
    }
    return false;
  }

  /**
   * 子类目标实例
   *
   * @returns 子类实例
   */
  protected abstract getTarInstance(): T;

  /**
   * 复写BindBaseState，赋值函数初始化
   */
  protected initSetMethods(): void {
    this.addSetMethod(WBaseProperty.BEGIN_CHILD_SET, this.beginChildSet);
    this.addSetMethod(WBaseProperty.END_CHILD_SET, this.endChildSet);
    this.addSetMethod(WBaseProperty.ALPHA, this.setAlpha);
    this.addSetMethod(WBaseProperty.TRAN_X, this.setTranX);
    this.addSetMethod(WBaseProperty.TRAN_Y, this.setTranY);
    this.addSetMethod(WBaseProperty.TRAN_Z, this.setTranZ);
    this.addSetMethod(WBaseProperty.SCALE_X, this.setScaleX);
    this.addSetMethod(WBaseProperty.SCALE_Y, this.setScaleY);
    this.addSetMethod(WBaseProperty.SCALE_Z, this.setScaleZ);
    this.addSetMethod(WBaseProperty.SCALE_CENTER_X, this.setScaleCenterX);
    this.addSetMethod(WBaseProperty.SCALE_CENTER_Y, this.setScaleCenterY);
    this.addSetMethod(WBaseProperty.ROTATE_X, this.setRotateX);
    this.addSetMethod(WBaseProperty.ROTATE_Y, this.setRotateY);
    this.addSetMethod(WBaseProperty.ROTATE_Z, this.setRotateZ);
    this.addSetMethod(WBaseProperty.ROTATE_PERSPECTIVE, this.setRotatePerspective);
    this.addSetMethod(WBaseProperty.ROTATE_ANGLE, this.setRotateAngle);
    this.addSetMethod(WBaseProperty.ROTATE_CENTER_X, this.setRotateCenterX);
    this.addSetMethod(WBaseProperty.ROTATE_CENTER_Y, this.setRotateCenterY);
    this.addSetMethod(WBaseProperty.ROTATE_CENTER_Z, this.setRotateCenterZ);
    this.addSetMethod(WBaseProperty.WIDTH, this.setWidth);
    this.addSetMethod(WBaseProperty.HEIGHT, this.setHeight);
    this.addSetMethod(WBaseProperty.BG_WIDTH, this.setBgWidth);
    this.addSetMethod(WBaseProperty.BG_HEIGHT, this.setBgHeight);
    this.addSetMethod(WBaseProperty.CLIP_ENABLE, this.setClip);
    this.addSetMethod(WBaseProperty.CLIP_W, this.setClipWidth);
    this.addSetMethod(WBaseProperty.CLIP_H, this.setClipHeight);
    this.addSetMethod(WBaseProperty.CLIP_OFFSET_X, this.setClipOffsetX);
    this.addSetMethod(WBaseProperty.CLIP_OFFSET_Y, this.setClipOffsetY);
    this.addSetMethod(WBaseProperty.BORDER_RADIUS, this.setBorderRadius);
    this.addSetMethod(WBaseProperty.BORDER_RADIUS_TL, this.setBorderRadiusTL);
    this.addSetMethod(WBaseProperty.BORDER_RADIUS_TR, this.setBorderRadiusTR);
    this.addSetMethod(WBaseProperty.BORDER_RADIUS_BL, this.setBorderRadiusBL);
    this.addSetMethod(WBaseProperty.BORDER_RADIUS_BR, this.setBorderRadiusBR);
    this.addSetMethod(WBaseProperty.MARGIN_L, this.setMarginL);
    this.addSetMethod(WBaseProperty.MARGIN_R, this.setMarginR);
    this.addSetMethod(WBaseProperty.MARGIN_T, this.setMarginT);
    this.addSetMethod(WBaseProperty.MARGIN_B, this.setMarginB);
    this.addSetMethod(WBaseProperty.PADDING_L, this.setPaddingL);
    this.addSetMethod(WBaseProperty.PADDING_R, this.setPaddingR);
    this.addSetMethod(WBaseProperty.PADDING_T, this.setPaddingT);
    this.addSetMethod(WBaseProperty.PADDING_B, this.setPaddingB);
    this.addSetMethod(WBaseProperty.FONT_SIZE, this.setFontSize);
    this.addSetMethod(WBaseProperty.FONT_COLOR, this.setFontColor);
    this.addSetMethod(WBaseProperty.FONT_FAMILY, this.setFontFamily);
    this.addSetMethod(WBaseProperty.FONT_WEIGHT, this.setFontWeight);
    this.addSetMethod(WBaseProperty.FONT_FEATURE, this.setFontFeature);
    this.addSetMethod(WBaseProperty.MAX_LINES, this.setMaxLines);
    this.addSetMethod(WBaseProperty.TEXT_OVERFLOW, this.setTextOverflow);
    this.addSetMethod(WBaseProperty.MIN_FONT_SIZE, this.setMinFontSize);
    this.addSetMethod(WBaseProperty.MAX_FONT_SIZE, this.setMaxFontSize);
    this.addSetMethod(WBaseProperty.MIN_FONT_SCALE, this.setMinFontScale);
    this.addSetMethod(WBaseProperty.MAX_FONT_SCALE, this.setMaxFontScale);
    this.addSetMethod(WBaseProperty.DRAGGABLE, this.setDraggable);
    this.addSetMethod(WBaseProperty.RENDER_GROUP, this.setRenderGroup);
    this.addSetMethod(WBaseProperty.USE_EFFECT, this.setUseEffect);
    this.addSetMethod(WBaseProperty.BLUR, this.setBlur);
    this.addSetMethod(WBaseProperty.LINEAR_BLUR, this.setLinearBlur);
    this.addSetMethod(WBaseProperty.LINEAR_GRADIENT, this.setLinearGradient);
    this.addSetMethod(WBaseProperty.BG_BLUR_STYLE, this.setBgBlurStyle);
    this.addSetMethod(WBaseProperty.Z_INDEX, this.setZIndex);
    this.addSetMethod(WBaseProperty.POSITION, this.setPosition);
    this.addSetMethod(WBaseProperty.OFFSET, this.setOffset);
    this.addSetMethod(WBaseProperty.MARK_ANCHOR, this.setMarkAnchor);
    this.addSetMethod(WBaseProperty.VISIBILITY, this.setVisibility);
    this.addSetMethod(WBaseProperty.ALIGN_CONTENT, this.setAlignContent);
    this.addSetMethod(WBaseProperty.TRANSITION, this.setTransition);
    this.addSetMethod(WBaseProperty.WIDGET_ID, this.setWidgetId);
    this.addSetMethod(WBaseProperty.GEOMETRY_ID, this.setGeometryId);
    this.addSetMethod(WBaseProperty.BLEND_MODE, this.setBlendMode);
    this.addSetMethod(WBaseProperty.ALIGN_RULES, this.setAlignRules);
    this.addSetMethod(WBaseProperty.FILL_COLOR, this.setFillColor);
    this.addSetMethod(WBaseProperty.COLOR_FILTER, this.setColorFilter);
    this.addSetMethod(WBaseProperty.BACKGROUND_COLOR, this.setBgColor);
    this.addSetMethod(WBaseProperty.FOREGROUND_COLOR, this.setFgColor);
    this.addSetMethod(WBaseProperty.FG_BRIGHTNESS, this.setFgBrightness);
    this.addSetMethod(WBaseProperty.BRIGHTNESS, this.setBrightness);
    this.addSetMethod(WBaseProperty.BG_BRIGHTNESS, this.setBgBrightness);
    this.addSetMethod(WBaseProperty.BG_BRIGHTNESS_INNER, this.setBgBrightnessInner);
    this.addSetMethod(WBaseProperty.BG_EFFECT, this.setBgEffect);
    this.addSetMethod(WBaseProperty.LIGHT_UP_EFFECT, this.setLightUpEffect);
    this.addSetMethod(WBaseProperty.CLICK_EFFECT, this.setClickEffect);
    this.addSetMethod(WBaseProperty.POINT_LIGHT, this.setPointLight);
    this.addSetMethod(WBaseProperty.ENABLE, this.setEnable);
    this.addSetMethod(WBaseProperty.ON_CLICK, this.setOnClick);
    this.addSetMethod(WBaseProperty.ACCESSIBILITY_LEVEL, this.setAccessibilityLevel);
    this.addSetMethod(WBaseProperty.ACCESSIBILITY_TEXT, this.setAccessibilityText);
    this.addSetMethod(WBaseProperty.ITEM_SPACE, this.setItemSpace);
    this.addSetMethod(WBaseProperty.LINE_HEIGHT, this.setLineHeight);
    this.addSetMethod(WBaseProperty.SHADOW, this.setShadow);
    this.addSetMethod(WBaseProperty.GESTURE_MODIFIER, this.setGestureModifier);
    this.addSetMethod(WBaseProperty.IMG_SRC, this.setImgSrc);
  }

  /**
   * 复写BindBaseState，取值函数初始化
   */
  protected initGetMethods(): void {
    this.addGetMethod(WBaseProperty.ALPHA, this.getAlpha);
    this.addGetMethod(WBaseProperty.TRAN_X, this.getTranX);
    this.addGetMethod(WBaseProperty.TRAN_Y, this.getTranY);
    this.addGetMethod(WBaseProperty.TRAN_Z, this.getTranZ);
    this.addGetMethod(WBaseProperty.SCALE_X, this.getScaleX);
    this.addGetMethod(WBaseProperty.SCALE_Y, this.getScaleY);
    this.addGetMethod(WBaseProperty.SCALE_Z, this.getScaleZ);
    this.addGetMethod(WBaseProperty.SCALE_CENTER_X, this.getScaleCenterX);
    this.addGetMethod(WBaseProperty.SCALE_CENTER_Y, this.getScaleCenterY);
    this.addGetMethod(WBaseProperty.ROTATE_X, this.getRotateX);
    this.addGetMethod(WBaseProperty.ROTATE_Y, this.getRotateY);
    this.addGetMethod(WBaseProperty.ROTATE_Z, this.getRotateZ);
    this.addGetMethod(WBaseProperty.ROTATE_PERSPECTIVE, this.getRotatePerspective);
    this.addGetMethod(WBaseProperty.ROTATE_ANGLE, this.getRotateAngle);
    this.addGetMethod(WBaseProperty.ROTATE_CENTER_X, this.getRotateCenterX);
    this.addGetMethod(WBaseProperty.ROTATE_CENTER_Y, this.getRotateCenterY);
    this.addGetMethod(WBaseProperty.ROTATE_CENTER_Z, this.getRotateCenterZ);
    this.addGetMethod(WBaseProperty.WIDTH, this.getWidth);
    this.addGetMethod(WBaseProperty.HEIGHT, this.getHeight);
    this.addGetMethod(WBaseProperty.BG_WIDTH, this.getBgWidth);
    this.addGetMethod(WBaseProperty.BG_HEIGHT, this.getBgHeight);
    this.addGetMethod(WBaseProperty.CLIP_ENABLE, this.isClipEnable);
    this.addGetMethod(WBaseProperty.CLIP_W, this.getClipWidth);
    this.addGetMethod(WBaseProperty.CLIP_H, this.getClipHeight);
    this.addGetMethod(WBaseProperty.CLIP_OFFSET_X, this.getClipOffsetX);
    this.addGetMethod(WBaseProperty.CLIP_OFFSET_Y, this.getClipOffsetY);
    this.addGetMethod(WBaseProperty.BORDER_RADIUS_TL, this.getBorderRadiusTL);
    this.addGetMethod(WBaseProperty.BORDER_RADIUS_TR, this.getBorderRadiusTR);
    this.addGetMethod(WBaseProperty.BORDER_RADIUS_BL, this.getBorderRadiusBL);
    this.addGetMethod(WBaseProperty.BORDER_RADIUS_BR, this.getBorderRadiusBR);
    this.addGetMethod(WBaseProperty.MARGIN_L, this.getMarginL);
    this.addGetMethod(WBaseProperty.MARGIN_R, this.getMarginR);
    this.addGetMethod(WBaseProperty.MARGIN_T, this.getMarginT);
    this.addGetMethod(WBaseProperty.MARGIN_B, this.getMarginB);
    this.addGetMethod(WBaseProperty.PADDING_L, this.getPaddingL);
    this.addGetMethod(WBaseProperty.PADDING_R, this.getPaddingR);
    this.addGetMethod(WBaseProperty.PADDING_T, this.getPaddingL);
    this.addGetMethod(WBaseProperty.PADDING_B, this.getPaddingB);
    this.addGetMethod(WBaseProperty.FONT_SIZE, this.getFontSize);
    this.addGetMethod(WBaseProperty.FONT_COLOR, this.getFontColor);
    this.addGetMethod(WBaseProperty.FONT_FAMILY, this.getFontFamily);
    this.addGetMethod(WBaseProperty.FONT_WEIGHT, this.getFontWeight);
    this.addGetMethod(WBaseProperty.FONT_FEATURE, this.getFontFeature);
    this.addGetMethod(WBaseProperty.MAX_LINES, this.getMaxLines);
    this.addGetMethod(WBaseProperty.TEXT_OVERFLOW, this.getTextOverflow);
    this.addGetMethod(WBaseProperty.MIN_FONT_SIZE, this.getMinFontSize);
    this.addGetMethod(WBaseProperty.MAX_FONT_SIZE, this.getMaxFontSize);
    this.addGetMethod(WBaseProperty.MIN_FONT_SCALE, this.getMinFontScale);
    this.addGetMethod(WBaseProperty.MAX_FONT_SCALE, this.getMaxFontScale);
    this.addGetMethod(WBaseProperty.DRAGGABLE, this.isDraggable);
    this.addGetMethod(WBaseProperty.RENDER_GROUP, this.isRenderGroup);
    this.addGetMethod(WBaseProperty.USE_EFFECT, this.isUseEffect);
    this.addGetMethod(WBaseProperty.BLUR, this.getBlur);
    this.addGetMethod(WBaseProperty.LINEAR_BLUR, this.getLinearBlur);
    this.addGetMethod(WBaseProperty.LINEAR_GRADIENT, this.getLinearGradient);
    this.addGetMethod(WBaseProperty.BG_BLUR_STYLE, this.getBgBlurStyle);
    this.addGetMethod(WBaseProperty.Z_INDEX, this.getZIndex);
    this.addGetMethod(WBaseProperty.POSITION, this.getPosition);
    this.addGetMethod(WBaseProperty.OFFSET, this.getOffset);
    this.addGetMethod(WBaseProperty.MARK_ANCHOR, this.getMarkAnchor);
    this.addGetMethod(WBaseProperty.VISIBILITY, this.getVisibility);
    this.addGetMethod(WBaseProperty.ALIGN_CONTENT, this.getAlignContent);
    this.addGetMethod(WBaseProperty.TRANSITION, this.getTransition);
    this.addGetMethod(WBaseProperty.WIDGET_ID, this.getWidgetId);
    this.addGetMethod(WBaseProperty.GEOMETRY_ID, this.getGeometryId);
    this.addGetMethod(WBaseProperty.BLEND_MODE, this.getBlendMode);
    this.addGetMethod(WBaseProperty.ALIGN_RULES, this.getAlignRules);
    this.addGetMethod(WBaseProperty.FILL_COLOR, this.getFillColor);
    this.addGetMethod(WBaseProperty.COLOR_FILTER, this.getColorFilter);
    this.addGetMethod(WBaseProperty.BACKGROUND_COLOR, this.getBgColor);
    this.addGetMethod(WBaseProperty.FOREGROUND_COLOR, this.getFgColor);
    this.addGetMethod(WBaseProperty.BRIGHTNESS, this.getBrightness);
    this.addGetMethod(WBaseProperty.FG_BRIGHTNESS, this.getFgBrightness);
    this.addGetMethod(WBaseProperty.BG_BRIGHTNESS, this.getBgBrightness);
    this.addGetMethod(WBaseProperty.BG_BRIGHTNESS_INNER, this.getBgBrightnessInner);
    this.addGetMethod(WBaseProperty.BG_EFFECT, this.getBgEffect);
    this.addGetMethod(WBaseProperty.LIGHT_UP_EFFECT, this.getLightUpEffect);
    this.addGetMethod(WBaseProperty.CLICK_EFFECT, this.getClickEffect);
    this.addGetMethod(WBaseProperty.POINT_LIGHT, this.getPointLight);
    this.addGetMethod(WBaseProperty.ENABLE, this.isEnable);
    this.addGetMethod(WBaseProperty.ON_CLICK, this.getOnClick);
    this.addGetMethod(WBaseProperty.ACCESSIBILITY_LEVEL, this.getAccessibilityLevel);
    this.addGetMethod(WBaseProperty.ACCESSIBILITY_TEXT, this.getAccessibilityText);
    this.addGetMethod(WBaseProperty.ITEM_SPACE, this.getItemSpace);
    this.addGetMethod(WBaseProperty.LINE_HEIGHT, this.getLineHeight);
    this.addGetMethod(WBaseProperty.SHADOW, this.getShadow);
    this.addGetMethod(WBaseProperty.GESTURE_MODIFIER, this.getGestureModifier);
    this.addGetMethod(WBaseProperty.IMG_SRC, this.getImgSrc);
  }

  /**
   * 复写IBaseState，限制属性类型
   *
   * @param property 属性类型
   * @param value 属性赋值
   * @returns 链式
   */
  public setStateValue(property: WProperty, value?: BaseObj): IBaseState {
    return super.setStateValue(property, value);
  }

  /**
   * 复写IBaseState，限制属性类型
   *
   * @param property 属性类型
   * @param scene 取值场景
   * @returns 取得值
   */
  public getStateValue(property: WProperty, scene?: BaseObj): BaseObj | undefined {
    return super.getStateValue(property, scene);
  }

  public addChildState(childState: T): T {
    this.childrenState.set(childState.getStateId(), childState);
    return this.getTarInstance();
  }

  public removeChildState(childStateName: string): T {
    this.childrenState.delete(childStateName);
    return this.getTarInstance();
  }

  public getChildState(childStateName: string): T | undefined {
    return this.childrenState.get(childStateName);
  }

  public setLimitValue(property: WProperty, limit?: WLimitValue): T {
    if (limit) {
      this.limitValue.set(property, limit);
    } else {
      this.limitValue.delete(property);
    }
    return this.getTarInstance();
  }

  public clearProperty(property: WProperty): T {
    this.setStateValue(property, undefined);
    return this.getTarInstance();
  }

  public beginChildSet(): T {
    this.isSetChildState = true;
    return this.getTarInstance();
  }

  public endChildSet(): T {
    this.isSetChildState = false;
    return this.getTarInstance();
  }

  public setAlpha(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.ALPHA, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.ALPHA, value);
    if (this.alpha !== validValue) {
      this.alpha = validValue;
      this.notifyStateChange(WBaseProperty.ALPHA);
    }
    return this.getTarInstance();
  }

  public getAlpha(): number | undefined {
    return this.alpha;
  }

  public setTranX(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.TRAN_X, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.TRAN_X, value);
    if (this.tranX !== validValue) {
      this.tranX = validValue;
      this.notifyStateChange(WBaseProperty.TRAN_X);
    }
    return this.getTarInstance();
  }

  public getTranX(): number | undefined {
    return this.tranX;
  }

  public setTranY(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.TRAN_Y, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.TRAN_Y, value);
    if (this.tranY !== validValue) {
      this.tranY = validValue;
      this.notifyStateChange(WBaseProperty.TRAN_Y);
    }
    return this.getTarInstance();
  }

  public getTranY(): number | undefined {
    return this.tranY;
  }

  public setTranZ(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.TRAN_Z, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.TRAN_Z, value);
    if (this.tranZ !== validValue) {
      this.tranZ = validValue;
      this.notifyStateChange(WBaseProperty.TRAN_Z);
    }
    return this.getTarInstance();
  }

  public getTranZ(): number | undefined {
    return this.tranZ;
  }

  public setScaleX(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.SCALE_X, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.SCALE_X, value);
    if (this.scaleX !== validValue) {
      this.scaleX = validValue;
      this.notifyStateChange(WBaseProperty.SCALE_X);
    }
    return this.getTarInstance();
  }

  public getScaleX(): number | undefined {
    return this.scaleX;
  }

  public setScaleY(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.SCALE_Y, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.SCALE_Y, value);
    if (this.scaleY !== validValue) {
      this.scaleY = validValue;
      this.notifyStateChange(WBaseProperty.SCALE_Y);
    }
    return this.getTarInstance();
  }

  public getScaleY(): number | undefined {
    return this.scaleY;
  }

  public setScaleZ(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.SCALE_Z, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.SCALE_Z, value);
    if (this.scaleZ !== validValue) {
      this.scaleZ = validValue;
      this.notifyStateChange(WBaseProperty.SCALE_Z);
    }
    return this.getTarInstance();
  }

  public getScaleZ(): number | undefined {
    return this.scaleZ;
  }

  public setScaleCenterX(value?: number | string): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.SCALE_CENTER_X, value)) { 
      return this.getTarInstance();
    }
    if (this.scaleCenterX !== value) {
      this.scaleCenterX = value;
      this.notifyStateChange(WBaseProperty.SCALE_CENTER_X);
    }
    return this.getTarInstance();
  }

  public getScaleCenterX(): number | string | undefined {
    return this.scaleCenterX;
  }

  public setScaleCenterY(value?: number | string): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.SCALE_CENTER_Y, value)) { 
      return this.getTarInstance();
    }
    if (this.scaleCenterY !== value) {
      this.scaleCenterY = value;
      this.notifyStateChange(WBaseProperty.SCALE_CENTER_Y);
    }
    return this.getTarInstance();
  }

  public getScaleCenterY(): number | string | undefined {
    return this.scaleCenterY;
  }

  public setRotateX(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.ROTATE_X, value)) { 
      return this.getTarInstance();
    }
    if (this.rotateX !== value) {
      this.rotateX = value;
      this.notifyStateChange(WBaseProperty.ROTATE_X);
    }
    return this.getTarInstance();
  }

  public getRotateX(): number | undefined {
    return this.rotateX;
  }

  public setRotateY(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.ROTATE_Y, value)) { 
      return this.getTarInstance();
    }
    if (this.rotateY !== value) {
      this.rotateY = value;
      this.notifyStateChange(WBaseProperty.ROTATE_Y);
    }
    return this.getTarInstance();
  }

  public getRotateY(): number | undefined {
    return this.rotateY;
  }

  public setRotateZ(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.ROTATE_Z, value)) { 
      return this.getTarInstance();
    }
    if (this.rotateZ !== value) {
      this.rotateZ = value;
      this.notifyStateChange(WBaseProperty.ROTATE_Z);
    }
    return this.getTarInstance();
  }

  public getRotateZ(): number | undefined {
    return this.rotateZ;
  }

  public setRotatePerspective(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.ROTATE_PERSPECTIVE, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.ROTATE_PERSPECTIVE, value);
    if (this.rotatePerspective !== validValue) {
      this.rotatePerspective = validValue;
      this.notifyStateChange(WBaseProperty.ROTATE_PERSPECTIVE);
    }
    return this.getTarInstance();
  }

  public getRotatePerspective(): number | undefined {
    return this.rotatePerspective;
  }

  public setRotateAngle(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.ROTATE_ANGLE, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.ROTATE_ANGLE, value);
    if (this.rotateAngle !== validValue) {
      this.rotateAngle = validValue;
      this.notifyStateChange(WBaseProperty.ROTATE_ANGLE);
    }
    return this.getTarInstance();
  }

  public getRotateAngle(): number | undefined {
    return this.rotateAngle;
  }

  public setRotateCenterX(value?: number | string): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.ROTATE_CENTER_X, value)) { 
      return this.getTarInstance();
    }
    if (this.rotateCenterX !== value) {
      this.rotateCenterX = value;
      this.notifyStateChange(WBaseProperty.ROTATE_CENTER_X);
    }
    return this.getTarInstance();
  }

  public getRotateCenterX(): number | string | undefined {
    return this.rotateCenterX;
  }

  public setRotateCenterY(value?: number | string): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.ROTATE_CENTER_Y, value)) { 
      return this.getTarInstance();
    }
    if (this.rotateCenterY !== value) {
      this.rotateCenterY = value;
      this.notifyStateChange(WBaseProperty.ROTATE_CENTER_Y);
    }
    return this.getTarInstance();
  }

  public getRotateCenterY(): number | string | undefined {
    return this.rotateCenterY;
  }

  public setRotateCenterZ(value?: number | string): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.ROTATE_CENTER_Z, value)) { 
      return this.getTarInstance();
    }
    if (this.rotateCenterZ !== value) {
      this.rotateCenterZ = value;
      this.notifyStateChange(WBaseProperty.ROTATE_CENTER_Z);
    }
    return this.getTarInstance();
  }

  public getRotateCenterZ(): number | string | undefined {
    return this.rotateCenterZ;
  }

  public setWidth(value?: number | string): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.WIDTH, value)) { 
      return this.getTarInstance();
    }
    if (this.width !== value) {
      this.width = value;
      this.notifyStateChange(WBaseProperty.WIDTH);
    }
    return this.getTarInstance();
  }

  public getWidth(): number | string | undefined {
    return this.width;
  }

  public setHeight(value?: number | string): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.HEIGHT, value)) { 
      return this.getTarInstance();
    }
    if (this.height !== value) {
      this.height = value;
      this.notifyStateChange(WBaseProperty.HEIGHT);
    }
    return this.getTarInstance();
  }

  public getHeight(): number | string | undefined {
    return this.height;
  }

  public setBgWidth(value?: number | string): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.BG_WIDTH, value)) {
      return this.getTarInstance();
    }
    if (this.bgWidth !== value) {
      this.bgWidth = value;
      this.notifyStateChange(WBaseProperty.BG_WIDTH);
    }
    return this.getTarInstance();
  }

  public getBgWidth(): number | string | undefined {
    return this.bgWidth;
  }

  public setBgHeight(value?: number | string): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.BG_HEIGHT, value)) {
      return this.getTarInstance();
    }
    if (this.bgHeight !== value) {
      this.bgHeight = value;
      this.notifyStateChange(WBaseProperty.BG_HEIGHT);
    }
    return this.getTarInstance();
  }

  public getBgHeight(): number | string | undefined {
    return this.bgHeight;
  }

  public setClip(value?: boolean): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.CLIP_ENABLE, value)) { 
      return this.getTarInstance();
    }
    if (this.isClip !== value) {
      this.isClip = value;
      this.notifyStateChange(WBaseProperty.CLIP_ENABLE);
    }
    return this.getTarInstance();
  }

  public isClipEnable(): boolean | undefined {
    return this.isClip;
  }

  public setClipWidth(value?: number | string): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.CLIP_W, value)) { 
      return this.getTarInstance();
    }
    if (this.clipWidth !== value) {
      this.clipWidth = value;
      this.notifyStateChange(WBaseProperty.CLIP_W);
    }
    return this.getTarInstance();
  }

  public getClipWidth(): number | string | undefined {
    return this.clipWidth;
  }

  public setClipHeight(value?: number | string): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.CLIP_H, value)) { 
      return this.getTarInstance();
    }
    if (this.clipHeight !== value) {
      this.clipHeight = value;
      this.notifyStateChange(WBaseProperty.CLIP_H);
    }
    return this.getTarInstance();
  }

  public getClipHeight(): number | string | undefined {
    return this.clipHeight;
  }

  public setClipOffsetX(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.CLIP_OFFSET_X, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.CLIP_OFFSET_X, value);
    if (this.clipOffsetX !== validValue) {
      this.clipOffsetX = validValue;
      this.notifyStateChange(WBaseProperty.CLIP_OFFSET_X);
    }
    return this.getTarInstance();
  }

  public getClipOffsetX(): number | undefined {
    return this.clipOffsetX;
  }

  public setClipOffsetY(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.CLIP_OFFSET_Y, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.CLIP_OFFSET_Y, value);
    if (this.clipOffsetY !== validValue) {
      this.clipOffsetY = validValue;
      this.notifyStateChange(WBaseProperty.CLIP_OFFSET_Y);
    }
    return this.getTarInstance();
  }

  public getClipOffsetY(): number | undefined {
    return this.clipOffsetY;
  }

  public setBorderRadiusTL(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.BORDER_RADIUS_TL, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.BORDER_RADIUS_TL, value);
    if (this.borderRadiusTL !== validValue) {
      this.borderRadiusTL = validValue;
      this.notifyStateChange(WBaseProperty.BORDER_RADIUS_TL);
    }
    return this.getTarInstance();
  }

  public getBorderRadiusTL(): number | undefined {
    return this.borderRadiusTL;
  }

  public setBorderRadiusTR(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.BORDER_RADIUS_TR, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.BORDER_RADIUS_TR, value);
    if (this.borderRadiusTR !== validValue) {
      this.borderRadiusTR = validValue;
      this.notifyStateChange(WBaseProperty.BORDER_RADIUS_TR);
    }
    return this.getTarInstance();
  }

  public getBorderRadiusTR(): number | undefined {
    return this.borderRadiusTR;
  }

  public setBorderRadiusBL(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.BORDER_RADIUS_BL, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.BORDER_RADIUS_BL, value);
    if (this.borderRadiusBL !== validValue) {
      this.borderRadiusBL = validValue;
      this.notifyStateChange(WBaseProperty.BORDER_RADIUS_BL);
    }
    return this.getTarInstance();
  }

  public getBorderRadiusBL(): number | undefined {
    return this.borderRadiusBL;
  }

  public setBorderRadiusBR(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.BORDER_RADIUS_BR, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.BORDER_RADIUS_BR, value);
    if (this.borderRadiusBR !== validValue) {
      this.borderRadiusBR = validValue;
      this.notifyStateChange(WBaseProperty.BORDER_RADIUS_BR);
    }
    return this.getTarInstance();
  }

  public getBorderRadiusBR(): number | undefined {
    return this.borderRadiusBR;
  }

  public clearBorderRadius(): T {
    return this.setBorderRadius();
  }

  public setBorderRadius(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.BORDER_RADIUS, value)) { 
      return this.getTarInstance();
    }
    return this.setBorderRadiusTL(value).setBorderRadiusTR(value)
      .setBorderRadiusBL(value).setBorderRadiusBR(value);
  }

  public setMarginL(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.MARGIN_L, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.MARGIN_L, value);
    if (this.marginL !== validValue) {
      this.marginL = validValue;
      this.notifyStateChange(WBaseProperty.MARGIN_L);
    }
    return this.getTarInstance();
  }

  public getMarginL(): number | undefined {
    return this.marginL;
  }

  public setMarginR(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.MARGIN_R, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.MARGIN_R, value);
    if (this.marginR !== validValue) {
      this.marginR = validValue;
      this.notifyStateChange(WBaseProperty.MARGIN_R);
    }
    return this.getTarInstance();
  }

  public getMarginR(): number | undefined {
    return this.marginR;
  }

  public setMarginT(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.MARGIN_T, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.MARGIN_T, value);
    if (this.marginT !== validValue) {
      this.marginT = validValue;
      this.notifyStateChange(WBaseProperty.MARGIN_T);
    }
    return this.getTarInstance();
  }

  public getMarginT(): number | undefined {
    return this.marginT;
  }

  public setMarginB(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.MARGIN_B, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.MARGIN_B, value);
    if (this.marginB !== validValue) {
      this.marginB = validValue;
      this.notifyStateChange(WBaseProperty.MARGIN_B);
    }
    return this.getTarInstance();
  }

  public getMarginB(): number | undefined {
    return this.marginB;
  }

  public setPaddingL(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.PADDING_L, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.PADDING_L, value);
    if (this.paddingL !== validValue) {
      this.paddingL = validValue;
      this.notifyStateChange(WBaseProperty.PADDING_L);
    }
    return this.getTarInstance();
  }

  public getPaddingL(): number | undefined {
    return this.paddingL;
  }

  public setPaddingR(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.PADDING_R, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.PADDING_R, value);
    if (this.paddingR !== validValue) {
      this.paddingR = validValue;
      this.notifyStateChange(WBaseProperty.PADDING_R);
    }
    return this.getTarInstance();
  }

  public getPaddingR(): number | undefined {
    return this.paddingR;
  }

  public setPaddingT(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.PADDING_T, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.PADDING_T, value);
    if (this.paddingT !== validValue) {
      this.paddingT = validValue;
      this.notifyStateChange(WBaseProperty.PADDING_T);
    }
    return this.getTarInstance();
  }

  public getPaddingT(): number | undefined {
    return this.paddingT;
  }

  public setPaddingB(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.PADDING_B, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.PADDING_B, value);
    if (this.paddingB !== validValue) {
      this.paddingB = validValue;
      this.notifyStateChange(WBaseProperty.PADDING_B);
    }
    return this.getTarInstance();
  }

  public getPaddingB(): number | undefined {
    return this.paddingB;
  }

  public setFontSize(value?: Length): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.FONT_SIZE, value)) { 
      return this.getTarInstance();
    }
    if (this.fontSize !== value) {
      this.fontSize = value;
      this.notifyStateChange(WBaseProperty.FONT_SIZE);
    }
    return this.getTarInstance();
  }

  public getFontSize(): Length | undefined {
    return this.fontSize;
  }

  public setFontColor(value?: ResourceColor): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.FONT_COLOR, value)) { 
      return this.getTarInstance();
    }
    if (this.fontColor !== value) {
      this.fontColor = value;
      this.notifyStateChange(WBaseProperty.FONT_COLOR);
    }
    return this.getTarInstance();
  }

  public getFontColor(): ResourceColor | undefined {
    return this.fontColor;
  }

  public setFontFamily(value?: ResourceStr): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.FONT_FAMILY, value)) { 
      return this.getTarInstance();
    }
    if (this.fontFamily !== value) {
      this.fontFamily = value;
      this.notifyStateChange(WBaseProperty.FONT_FAMILY);
    }
    return this.getTarInstance();
  }

  public getFontFamily(): ResourceColor | undefined {
    return this.fontFamily;
  }

  public setFontWeight(value?: number | FontWeight | string): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.FONT_WEIGHT, value)) { 
      return this.getTarInstance();
    }
    if (this.fontWeight !== value) {
      this.fontWeight = value;
      this.notifyStateChange(WBaseProperty.FONT_WEIGHT);
    }
    return this.getTarInstance();
  }

  public getFontWeight(): number | FontWeight | string | undefined {
    return this.fontWeight;
  }

  public setFontFeature(value?: string): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.FONT_FEATURE, value)) { 
      return this.getTarInstance();
    }
    if (this.fontFeature !== value) {
      this.fontFeature = value;
      this.notifyStateChange(WBaseProperty.FONT_FEATURE);
    }
    return this.getTarInstance();
  }

  public getFontFeature(): string | undefined {
    return this.fontFeature;
  }

  public setMaxLines(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.MAX_LINES, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.MAX_LINES, value);
    if (this.maxLines !== validValue) {
      this.maxLines = validValue;
      this.notifyStateChange(WBaseProperty.MAX_LINES);
    }
    return this.getTarInstance();
  }

  public getMaxLines(): number | undefined {
    return this.maxLines;
  }

  public setTextOverflow(value?: TextOverflow): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.TEXT_OVERFLOW, value)) { 
      return this.getTarInstance();
    }
    if (this.textOverflow !== value) {
      this.textOverflow = value;
      this.notifyStateChange(WBaseProperty.TEXT_OVERFLOW);
    }
    return this.getTarInstance();
  }

  public getTextOverflow(): TextOverflow | undefined {
    return this.textOverflow;
  }

  public setMinFontSize(value?: number | string | Resource): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.MIN_FONT_SIZE, value)) {
      return this.getTarInstance();
    }
    if (this.minFontSize !== value) {
      this.minFontSize = value;
      this.notifyStateChange(WBaseProperty.MIN_FONT_SIZE);
    }
    return this.getTarInstance();
  }

  public getMinFontSize(): number | string | Resource | undefined {
    return this.minFontSize;
  }

  public setMaxFontSize(value?: number | string | Resource): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.MAX_FONT_SIZE, value)) {
      return this.getTarInstance();
    }
    if (this.maxFontSize !== value) {
      this.maxFontSize = value;
      this.notifyStateChange(WBaseProperty.MAX_FONT_SIZE);
    }
    return this.getTarInstance();
  }

  public getMaxFontSize(): number | string | Resource | undefined {
    return this.maxFontSize;
  }

  public setMinFontScale(value?: number | Resource): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.MIN_FONT_SCALE, value)) { 
      return this.getTarInstance();
    }
    if (this.minFontScale !== value) {
      this.minFontScale = value;
      this.notifyStateChange(WBaseProperty.MIN_FONT_SCALE);
    }
    return this.getTarInstance();
  }

  public getMinFontScale(): number | Resource | undefined {
    return this.minFontScale;
  }

  public setMaxFontScale(value?: number | Resource): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.MAX_FONT_SCALE, value)) { 
      return this.getTarInstance();
    }
    if (this.maxFontScale !== value) {
      this.maxFontScale = value;
      this.notifyStateChange(WBaseProperty.MAX_FONT_SCALE);
    }
    return this.getTarInstance();
  }

  public getMaxFontScale(): number | Resource | undefined {
    return this.maxFontScale;
  }

  public setDraggable(value?: boolean): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.DRAGGABLE, value)) { 
      return this.getTarInstance();
    }
    if (this.draggable !== value) {
      this.draggable = value;
      this.notifyStateChange(WBaseProperty.DRAGGABLE);
    }
    return this.getTarInstance();
  }

  public isDraggable(): boolean | undefined {
    return this.draggable;
  }

  public setRenderGroup(value?: boolean): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.RENDER_GROUP, value)) { 
      return this.getTarInstance();
    }
    if (this.renderGroup !== value) {
      this.renderGroup = value;
      this.notifyStateChange(WBaseProperty.RENDER_GROUP);
    }
    return this.getTarInstance();
  }

  public isRenderGroup(): boolean | undefined {
    return this.renderGroup;
  }

  public setUseEffect(value?: boolean): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.USE_EFFECT, value)) { 
      return this.getTarInstance();
    }
    if (this.useEffect !== value) {
      this.useEffect = value;
      this.notifyStateChange(WBaseProperty.USE_EFFECT);
    }
    return this.getTarInstance();
  }

  public isUseEffect(): boolean | undefined {
    return this.useEffect;
  }

  public setBlur(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.BLUR, value)) {
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.BLUR, value);
    if (this.blur !== validValue) {
      this.blur = validValue;
      this.notifyStateChange(WBaseProperty.BLUR);
    }
    return this.getTarInstance();
  }

  public getBlur(): number | undefined {
    return this.blur;
  }

  public setLinearBlur(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.LINEAR_BLUR, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.LINEAR_BLUR, value);
    if (this.linearBlur !== validValue) {
      this.linearBlur = validValue;
      this.notifyStateChange(WBaseProperty.LINEAR_BLUR);
    }
    return this.getTarInstance();
  }

  public getLinearBlur(): number | undefined {
    return this.linearBlur;
  }

  public setLinearGradient(value?: LinearGradient): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.LINEAR_GRADIENT, value)) {
      return this.getTarInstance();
    }
    if (this.linearGradient !== value) {
      this.linearGradient = value;
      this.notifyStateChange(WBaseProperty.LINEAR_GRADIENT);
    }
    return this.getTarInstance();
  }

  public getLinearGradient(): LinearGradient | undefined {
    return this.linearGradient;
  }

  public setBgBlurStyle(value?: BlurStyle): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.BG_BLUR_STYLE, value)) {
      return this.getTarInstance();
    }
    if (this.bgBlurStyle !== value) {
      this.bgBlurStyle = value;
      this.notifyStateChange(WBaseProperty.BG_BLUR_STYLE);
    }
    return this.getTarInstance();
  }

  public getBgBlurStyle(): BlurStyle | undefined {
    return this.bgBlurStyle;
  }

  public setZIndex(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.Z_INDEX, value)) { 
      return this.getTarInstance();
    }
    let validValue = this.getValidValue(WBaseProperty.Z_INDEX, value);
    if (this.zIndex !== validValue) {
      this.zIndex = validValue;
      this.notifyStateChange(WBaseProperty.Z_INDEX);
    }
    return this.getTarInstance();
  }

  public getZIndex(): number | undefined {
    return this.zIndex;
  }

  public setPosition(value?: Position): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.POSITION, value)) { 
      return this.getTarInstance();
    }
    if (!this.equalsPosition(this.position, value)) {
      this.position = value;
      this.notifyStateChange(WBaseProperty.POSITION);
    }
    return this.getTarInstance();
  }

  public getPosition(): Position | undefined {
    return this.position;
  }

  public setOffset(value?: Position): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.OFFSET, value)) { 
      return this.getTarInstance();
    }
    if (!this.equalsPosition(this.offset, value)) {
      this.offset = value;
      this.notifyStateChange(WBaseProperty.OFFSET);
    }
    return this.getTarInstance();
  }

  public getOffset(): Position | undefined {
    return this.offset;
  }

  public setMarkAnchor(value?: Position): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.MARK_ANCHOR, value)) {
      return this.getTarInstance();
    }
    if (!this.equalsPosition(this.markAnchor, value)) {
      this.markAnchor = value;
      this.notifyStateChange(WBaseProperty.MARK_ANCHOR);
    }
    return this.getTarInstance();
  }

  public getMarkAnchor(): Position | undefined {
    return this.markAnchor;
  }

  public setVisibility(value?: Visibility): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.VISIBILITY, value)) { 
      return this.getTarInstance();
    }
    if (this.visibility !== value) {
      this.visibility = value;
      this.notifyStateChange(WBaseProperty.VISIBILITY);
    }
    return this.getTarInstance();
  }

  public getVisibility(): Visibility | undefined {
    return this.visibility;
  }

  public setAlignContent(value?: Alignment): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.ALIGN_CONTENT, value)) {
      return this.getTarInstance();
    }
    if (this.alignContent !== value) {
      this.alignContent = value;
      this.notifyStateChange(WBaseProperty.ALIGN_CONTENT);
    }
    return this.getTarInstance();
  }

  public getAlignContent(): Alignment | undefined {
    return this.alignContent;
  }

  public setTransition(value?: TransitionEffect): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.TRANSITION, value)) { 
      return this.getTarInstance();
    }
    if (this.transition !== value) {
      this.transition = value;
      this.notifyStateChange(WBaseProperty.TRANSITION);
    }
    return this.getTarInstance();
  }

  public getTransition(): TransitionEffect | undefined {
    return this.transition;
  }

  public setWidgetId(value?: string): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.WIDGET_ID, value)) { 
      return this.getTarInstance();
    }
    if (this.id !== value) {
      this.id = value;
      this.notifyStateChange(WBaseProperty.WIDGET_ID);
    }
    return this.getTarInstance();
  }

  public getWidgetId(): string | undefined {
    return this.id;
  }

  public setGeometryId(value?: string): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.GEOMETRY_ID, value)) { 
      return this.getTarInstance();
    }
    if (this.geometryId !== value) {
      this.geometryId = value;
      this.notifyStateChange(WBaseProperty.GEOMETRY_ID);
    }
    return this.getTarInstance();
  }

  public getGeometryId(): string | undefined {
    return this.geometryId;
  }

  public setBlendMode(value?: BlendMode): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.BLEND_MODE, value)) {
      return this.getTarInstance();
    }
    if (this.blendMode !== value) {
      this.blendMode = value;
      this.notifyStateChange(WBaseProperty.BLEND_MODE);
    }
    return this.getTarInstance();
  }

  public getBlendMode(): BlendMode | undefined {
    return this.blendMode;
  }

  public setAlignRules(value?: AlignRuleOption): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.ALIGN_RULES, value)) {
      return this.getTarInstance();
    }
    if (this.alignRules !== value) {
      this.alignRules = value;
      this.notifyStateChange(WBaseProperty.ALIGN_RULES);
    }
    return this.getTarInstance();
  }

  public getAlignRules(): AlignRuleOption | undefined {
    return this.alignRules;
  }

  public setFillColor(value?: ResourceColor): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.FILL_COLOR, value)) {
      return this.getTarInstance();
    }
    if (this._fillColor !== value) {
      this._fillColor = value;
      this.notifyStateChange(WBaseProperty.FILL_COLOR);
    }
    return this.getTarInstance();
  }

  public getFillColor(): ResourceColor | undefined {
    return this._fillColor;
  }

  public setColorFilter(value?: ColorFilter): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.COLOR_FILTER, value)) {
      return this.getTarInstance();
    }
    if (this._colorFilter !== value) {
      this._colorFilter = value;
      this.notifyStateChange(WBaseProperty.COLOR_FILTER);
    }
    return this.getTarInstance();
  }

  public getColorFilter(): ColorFilter | undefined {
    return this._colorFilter;
  }

  public setBgColor(value?: ResourceColor): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.BACKGROUND_COLOR, value)) { 
      return this.getTarInstance();
    }
    if (this.bgColor !== value) {
      this.bgColor = value;
      this.notifyStateChange(WBaseProperty.BACKGROUND_COLOR);
    }
    return this.getTarInstance();
  }

  public getBgColor(): ResourceColor | undefined {
    return this.bgColor;
  }

  public setFgColor(value?: ResourceColor): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.FOREGROUND_COLOR, value)) {
      return this.getTarInstance();
    }
    if (this.fgColor !== value) {
      this.fgColor = value;
      this.notifyStateChange(WBaseProperty.FOREGROUND_COLOR);
    }
    return this.getTarInstance();
  }

  public getFgColor(): ResourceColor | undefined {
    return this.fgColor;
  }

  public setBrightness(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.BRIGHTNESS, value)) {
      return this.getTarInstance();
    }
    if (this.brightness !== value) {
      this.brightness = value;
      this.notifyStateChange(WBaseProperty.BRIGHTNESS);
    }
    return this.getTarInstance();
  }

  public getBrightness(): number | undefined {
    return this.brightness;
  }

  public setFgBrightness(value?: BrightnessOptions): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.FG_BRIGHTNESS, value)) {
      return this.getTarInstance();
    }
    if (this.fgBrightness !== value) {
      this.fgBrightness = value;
      this.notifyStateChange(WBaseProperty.FG_BRIGHTNESS);
    }
    return this.getTarInstance();
  }

  public getFgBrightness(): BrightnessOptions | undefined {
    return this.fgBrightness;
  }

  public setBgBrightness(value?: BackgroundBrightnessOptions): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.BG_BRIGHTNESS, value)) {
      return this.getTarInstance();
    }
    if (this.bgBrightness !== value) {
      this.bgBrightness = value;
      this.notifyStateChange(WBaseProperty.BG_BRIGHTNESS);
    }
    return this.getTarInstance();
  }

  public getBgBrightness(): BackgroundBrightnessOptions | undefined {
    return this.bgBrightness;
  }

  public setBgBrightnessInner(value?: BrightnessOptions): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.BG_BRIGHTNESS_INNER, value)) {
      return this.getTarInstance();
    }
    if (this.bgBrightnessInner !== value) {
      this.bgBrightnessInner = value;
      this.notifyStateChange(WBaseProperty.BG_BRIGHTNESS_INNER);
    }
    return this.getTarInstance();
  }

  public getBgBrightnessInner(): BrightnessOptions | undefined {
    return this.bgBrightnessInner;
  }

  public setBgEffect(value?: BackgroundEffectOptions): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.BG_EFFECT, value)) {
      return this.getTarInstance();
    }
    if (this.bgEffect !== value) {
      this.bgEffect = value;
      this.notifyStateChange(WBaseProperty.BG_EFFECT);
    }
    return this.getTarInstance();
  }

  public getBgEffect(): BackgroundEffectOptions | undefined {
    return this.bgEffect;
  }

  public setLightUpEffect(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.LIGHT_UP_EFFECT, value)) { 
      return this.getTarInstance();
    }
    if (this.lightUpEffect !== value) {
      this.lightUpEffect = value;
      this.notifyStateChange(WBaseProperty.LIGHT_UP_EFFECT);
    }
    return this.getTarInstance();
  }

  public getLightUpEffect(): number | undefined {
    return this.lightUpEffect;
  }

  public setClickEffect(value?: ClickEffect): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.CLICK_EFFECT, value)) {
      return this.getTarInstance();
    }
    if (this._clickEffect !== value) {
      this._clickEffect = value;
      this.notifyStateChange(WBaseProperty.CLICK_EFFECT);
    }
    return this.getTarInstance();
  }

  public getClickEffect(): ClickEffect | undefined {
    return this._clickEffect;
  }

  public setPointLight(value?: PointLightStyle): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.POINT_LIGHT, value)) {
      return this.getTarInstance();
    }
    if (this._pointLight !== value) {
      this._pointLight = value;
      this.notifyStateChange(WBaseProperty.POINT_LIGHT);
    }
    return this.getTarInstance();
  }

  public getPointLight(): PointLightStyle | undefined {
    return this._pointLight;
  }

  public setEnable(value?: boolean): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.ENABLE, value)) {
      return this.getTarInstance();
    }
    if (this._isEnable !== value) {
      this._isEnable = value;
      this.notifyStateChange(WBaseProperty.ENABLE);
    }
    return this.getTarInstance();
  }

  public isEnable(): boolean | undefined {
    return this._isEnable;
  }

  public setOnClick(value?: () => void): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.ON_CLICK, value)) {
      return this.getTarInstance();
    }
    if (this._onClick !== value) {
      this._onClick = value;
      this.notifyStateChange(WBaseProperty.ON_CLICK);
    }
    return this.getTarInstance();
  }

  public getOnClick(): (() => void) | undefined {
    return this._onClick;
  }

  public setAccessibilityLevel(value?: string): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.ACCESSIBILITY_LEVEL, value)) {
      return this.getTarInstance();
    }
    if (this._accessibilityLevel !== value) {
      this._accessibilityLevel = value ?? 'no';
      this.notifyStateChange(WBaseProperty.ACCESSIBILITY_LEVEL);
    }
    return this.getTarInstance();
  }

  public getAccessibilityLevel(): string {
    return this._accessibilityLevel;
  }

  public setAccessibilityText(value?: Resource): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.ACCESSIBILITY_TEXT, value)) {
      return this.getTarInstance();
    }
    if (this._accessibilityText !== value) {
      this._accessibilityText = value;
      this.notifyStateChange(WBaseProperty.ACCESSIBILITY_TEXT);
    }
    return this.getTarInstance();
  }

  public getAccessibilityText(): Resource | undefined {
    return this._accessibilityText;
  }

  public setItemSpace(value?: string | number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.ITEM_SPACE, value)) {
      return this.getTarInstance();
    }
    if (this._itemSpace !== value) {
      this._itemSpace = value;
      this.notifyStateChange(WBaseProperty.ITEM_SPACE);
    }
    return this.getTarInstance();
  }

  public getItemSpace(): string | number | undefined {
    return this._itemSpace;
  }

  public setLineHeight(value?: number): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.LINE_HEIGHT, value)) {
      return this.getTarInstance();
    }
    if (this._lineHeight !== value) {
      this._lineHeight = value;
      this.notifyStateChange(WBaseProperty.LINE_HEIGHT);
    }
    return this.getTarInstance();
  }

  public getLineHeight(): number | undefined {
    return this._lineHeight;
  }

  public setShadow(value?: ShadowOptions | ShadowStyle): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.SHADOW, value)) {
      return this.getTarInstance();
    }
    if (this._shadow !== value) {
      this._shadow = value;
      this.notifyStateChange(WBaseProperty.SHADOW);
    }
    return this.getTarInstance();
  }

  public getShadow(): ShadowOptions | ShadowStyle | undefined {
    return this._shadow;
  }

  public setGestureModifier(value?: GestureModifier): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.GESTURE_MODIFIER, value)) {
      return this.getTarInstance();
    }
    if (this._gestureModifier !== value) {
      this._gestureModifier = value;
      this.notifyStateChange(WBaseProperty.GESTURE_MODIFIER);
    }
    return this.getTarInstance();
  }

  public getGestureModifier(): GestureModifier | undefined {
    return this._gestureModifier;
  }

  public setImgSrc(value?: PixelMap | ResourceStr | DrawableDescriptor): T {
    // 子组件赋值
    if (this.checkSetChildProperty(WBaseProperty.IMG_SRC, value)) {
      return this.getTarInstance();
    }
    if (this._imgSrc !== value) {
      this._imgSrc = value;
      this.notifyStateChange(WBaseProperty.IMG_SRC);
    }
    return this.getTarInstance();
  }

  public getImgSrc(): PixelMap | ResourceStr | DrawableDescriptor | undefined {
    return this._imgSrc;
  }
}
 