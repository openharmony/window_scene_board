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
 * 组件属性默认值
 */
export enum WDefault {
  MIN_VALUE = 0,
  MAX_VALUE = 1,
  INVALID_VALUE = -1,
  DIVIDE = 2,
}

/**
 * 组件动效属性默认值
 */
export class WAnimDefault {
  public static readonly DEFAULT_ANIM_SCENE: string = 'default_anim_scene';
  public static readonly TIMER_TIMEOUT: number = 5000;
  public static readonly MAX_ANIM_COUNT: number = 2147483647;
}

/**
 * 组件动效场景
 */
export interface WAnimScene {
  isAnimating: boolean; // 动效开启状态
  animScene?: string; // 动效场景
  isForceRemove?: boolean; // 是否开启计时强制移除动效场景
}

/**
 * 组件基础属性类型
 */
export enum WBaseProperty {
  BEGIN_CHILD_SET = 'beginChildSet',
  END_CHILD_SET = 'endChildSet',
  ALPHA = 'alpha',
  TRAN_X = 'tranX',
  TRAN_Y = 'tranY',
  TRAN_Z = 'tranZ',
  SCALE_X = 'scaleX',
  SCALE_Y = 'scaleY',
  SCALE_Z = 'scaleZ',
  SCALE_CENTER_X = 'scaleCenterX',
  SCALE_CENTER_Y = 'scaleCenterY',
  ROTATE_X = 'rotateX',
  ROTATE_Y = 'rotateY',
  ROTATE_Z = 'rotateZ',
  ROTATE_PERSPECTIVE = 'rotatePerspective',
  ROTATE_ANGLE = 'rotateAngle',
  ROTATE_CENTER_X = 'rotateCenterX',
  ROTATE_CENTER_Y = 'rotateCenterY',
  ROTATE_CENTER_Z = 'rotateCenterZ',
  WIDTH = 'width',
  HEIGHT = 'height',
  BG_WIDTH = 'bgWidth',
  BG_HEIGHT = 'bgHeight',
  CLIP_ENABLE = 'isClip',
  CLIP_W = 'clipWidth',
  CLIP_H = 'clipHeight',
  CLIP_OFFSET_X = 'clipOffsetX',
  CLIP_OFFSET_Y = 'clipOffsetY',
  BORDER_RADIUS = 'borderRadiusAll',
  BORDER_RADIUS_TL = 'borderRadiusTL',
  BORDER_RADIUS_TR = 'borderRadiusTR',
  BORDER_RADIUS_BL = 'borderRadiusBL',
  BORDER_RADIUS_BR = 'borderRadiusBR',
  MARGIN_L = 'marginL',
  MARGIN_R = 'marginR',
  MARGIN_T = 'marginT',
  MARGIN_B = 'marginB',
  PADDING_L = 'paddingL',
  PADDING_R = 'paddingR',
  PADDING_T = 'paddingT',
  PADDING_B = 'paddingB',
  FONT_SIZE = 'fontSize',
  FONT_COLOR = 'fontColor',
  FONT_FAMILY = 'fontFamily',
  FONT_WEIGHT = 'fontWeight',
  FONT_FEATURE = 'fontFeature',
  MAX_LINES = 'maxLines',
  TEXT_OVERFLOW = 'textOverflow',
  MIN_FONT_SIZE = 'minFontSize',
  MAX_FONT_SIZE = 'maxFontSize',
  MIN_FONT_SCALE = 'minFontScale',
  MAX_FONT_SCALE = 'maxFontScale',
  DRAGGABLE = 'draggable',
  RENDER_GROUP = 'renderGroup',
  USE_EFFECT = 'useEffect',
  BLUR = 'blur',
  LINEAR_BLUR = 'linearBlur',
  LINEAR_GRADIENT = 'linearGradient',
  BG_BLUR_STYLE = 'bgBlurStyle',
  Z_INDEX = 'zIndex',
  POSITION = 'position',
  OFFSET = 'offset',
  MARK_ANCHOR = 'markAnchor',
  VISIBILITY = 'visibility',
  ALIGN_CONTENT = 'alignContent',
  TRANSITION = 'transition',
  WIDGET_ID = 'widgetId',
  GEOMETRY_ID = 'geometryId',
  BLEND_MODE = 'blendMode',
  ALIGN_RULES = 'alignRules',
  FILL_COLOR = 'fillColor',
  COLOR_FILTER = 'colorFilter',
  BACKGROUND_COLOR = 'backgroundColor',
  FOREGROUND_COLOR = 'foregroundColor',
  ENABLE_BRIGHT = 'enableBright',
  BRIGHTNESS = 'brightness',
  FG_BRIGHTNESS = 'fgBrightness',
  BG_BRIGHTNESS = 'bgBrightness',
  BG_BRIGHTNESS_INNER = 'bgBrightnessInner',
  BG_EFFECT = 'bgEffect',
  LIGHT_UP_EFFECT = 'lightUpEffect',
  CLICK_EFFECT = 'clickEffect',
  POINT_LIGHT = 'pointLight',
  ENABLE = 'isEnable',
  ON_CLICK = 'onClick',
  ACCESSIBILITY_LEVEL = 'accessibilityLevel',
  ACCESSIBILITY_TEXT = 'accessibilityText',
  ITEM_SPACE = 'itemSpace',
  LINE_HEIGHT = 'lineHeight',
  SHADOW = 'shadow',
  GESTURE_MODIFIER = 'gestureModifier',
  IMG_SRC = 'imgSrc',
}

/**
 * 组件动效属性类型
 */
export enum WAnimProperty {
  ANIM_SCENE = 'animScene',
  ANIMATING = 'isAnimating',
}

/**
 * 组件样式属性类型
 */
export enum WStyleProperty {
  SIZE_BP_SPLICE = 'sizeBpSplice', // 屏幕断点
  CONFIG_ID = 'styleConfigId', // 样式配置标识
}

/**
 * 组件状态值限制
 */
export class WLimitValue {
  public minValue?: number;
  public maxValue?: number;

  public buildMinValue(minValue?: number): WLimitValue {
    this.minValue = minValue;
    return this;
  }

  public buildMaxValue(maxValue?: number): WLimitValue {
    this.maxValue = maxValue;
    return this;
  }

  public static wrapper(): WLimitValue {
    return new WLimitValue();
  }
}

// 组件属性默认限制值
export const LIMIT_DEFAULT: Map<WProperty, WLimitValue> = new Map([
  [WBaseProperty.ALPHA, WLimitValue.wrapper().buildMinValue(WDefault.MIN_VALUE).buildMaxValue(WDefault.MAX_VALUE)],
  [WBaseProperty.SCALE_X, WLimitValue.wrapper().buildMinValue(WDefault.MIN_VALUE)],
  [WBaseProperty.SCALE_Y, WLimitValue.wrapper().buildMinValue(WDefault.MIN_VALUE)],
  [WBaseProperty.SCALE_Z, WLimitValue.wrapper().buildMinValue(WDefault.MIN_VALUE)],
  [WBaseProperty.WIDTH, WLimitValue.wrapper().buildMinValue(WDefault.MIN_VALUE)],
  [WBaseProperty.HEIGHT, WLimitValue.wrapper().buildMinValue(WDefault.MIN_VALUE)],
  [WBaseProperty.FONT_SIZE, WLimitValue.wrapper().buildMinValue(WDefault.MIN_VALUE)],
  [WBaseProperty.CLIP_W, WLimitValue.wrapper().buildMinValue(WDefault.MIN_VALUE)],
  [WBaseProperty.CLIP_H, WLimitValue.wrapper().buildMinValue(WDefault.MIN_VALUE)],
  [WBaseProperty.BORDER_RADIUS_TL, WLimitValue.wrapper().buildMinValue(WDefault.MIN_VALUE)],
  [WBaseProperty.BORDER_RADIUS_TR, WLimitValue.wrapper().buildMinValue(WDefault.MIN_VALUE)],
  [WBaseProperty.BORDER_RADIUS_BL, WLimitValue.wrapper().buildMinValue(WDefault.MIN_VALUE)],
  [WBaseProperty.BORDER_RADIUS_BR, WLimitValue.wrapper().buildMinValue(WDefault.MIN_VALUE)],
  [WBaseProperty.BLUR, WLimitValue.wrapper().buildMinValue(WDefault.MIN_VALUE)],
  [WBaseProperty.LINEAR_BLUR, WLimitValue.wrapper().buildMinValue(WDefault.MIN_VALUE)],
  [WBaseProperty.MAX_LINES, WLimitValue.wrapper().buildMinValue(WDefault.MAX_VALUE)],
]);

// 组件全属性类型
export type WProperty = WBaseProperty | WAnimProperty | WStyleProperty;