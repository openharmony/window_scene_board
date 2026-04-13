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

/**
 * 动效参数默认值
 */
export enum AnimValue {
  VALUE_MAX = 1.0,
  VALUE_MIN = 0,
  VALUE_BLUE_MAX = 1000.0,

  /**
   * 组件点击缩放默认值
   */
  DEFAULT_CLICK_SCALE = 0.9
}

/**
 * 动效属性名称
 */
enum PropertyName {
  /**
   * 透明度
   */
  NAME_ALPHA = 'alpha',

  /**
   * X轴缩放
   */
  NAME_SCALE_X = 'scaleX',

  /**
   * Y轴缩放
   */
  NAME_SCALE_Y = 'scaleY',

  /**
   * Z轴缩放
   */
  NAME_SCALE_Z = 'scaleZ',

  /**
   * 缩放原点坐标X
   */
  NAME_SCALE_PIVOT_X = 'scalePivotX',

  /**
   * 缩放原点坐标Y
   */
  NAME_SCALE_PIVOT_Y = 'scalePivotY',

  /**
   * X轴平移
   */
  NAME_TRAN_X = 'translationX',

  /**
   * Y轴平移
   */
  NAME_TRAN_Y = 'translationY',

  /**
   * Z轴平移
   */
  NAME_TRAN_Z = 'translationZ',

  /**
   * 沿X轴旋转，0未开启，1开启
   */
  NAME_ROTATION_X = 'rotationX',

  /**
   * 沿Y轴旋转，0未开启，1开启
   */
  NAME_ROTATION_Y = 'rotationY',

  /**
   * 沿Z轴旋转，0未开启，1开启
   */
  NAME_ROTATION_Z = 'rotationZ',

  /**
   * 旋转原点坐标X
   */
  NAME_ROTATION_PIVOT_X = 'rotationPivotX',

  /**
   * 旋转原点坐标Y
   */
  NAME_ROTATION_PIVOT_Y = 'rotationPivotY',

  /**
   * 旋转原点坐标Z
   */
  NAME_ROTATION_PIVOT_Z = 'rotationPivotZ',

  /**
   * 旋转视角高度
   */
  NAME_ROTATION_PERSPECTIVE = 'rotationPerspective',

  /**
   * 旋转角度
   */
  NAME_ROTATION_ANGLE = 'rotationAngle',

  /**
   * 组件宽度
   */
  NAME_WIDTH = 'animWidth',

  /**
   * 组件高度
   */
  NAME_HEIGHT = 'animHeight',

  /**
   * 文本字体大小
   */
  NAME_FONT_SIZE = 'fontSize',

  /**
   * 左上角圆角
   */
  NAME_BORDER_RADIUS_TL = 'borderRadiusTopLeft',

  /**
   * 右上角圆角
   */
  NAME_BORDER_RADIUS_TR = 'borderRadiusTopRight',

  /**
   * 左下角圆角
   */
  NAME_BORDER_RADIUS_BL = 'borderRadiusBottomLeft',

  /**
   * 右下角圆角
   */
  NAME_BORDER_RADIUS_BR = 'borderRadiusBottomRight',

  /**
   * 外边距left
   */
  NAME_MARGIN_LEFT = 'marginLeft',

  /**
   * 外边距right
   */
  NAME_MARGIN_RIGHT = 'marginRight',

  /**
   * 外边距top
   */
  NAME_MARGIN_TOP = 'marginTop',

  /**
   * 外边距bottom
   */
  NAME_MARGIN_BOTTOM = 'marginBottom',

  /**
   * 切割X轴起始点
   */
  NAME_CLIP_OFFSET_X = 'clipOffsetX',

  /**
   * 切割Y轴起始点
   */
  NAME_CLIP_OFFSET_Y = 'clipOffsetY',

  /**
   * 切割宽度
   */
  NAME_CLIP_WIDTH = 'clipWidth',

  /**
   * 切割高度
   */
  NAME_CLIP_HEIGHT = 'clipHeight',

  /**
   * 点击缩放值
   */
  NAME_CLICK_EFFECT_SCALE = 'clickEffectScale',

  /**
   * 模糊半径
   */
  NAME_BLUR = 'blur',

  /**
   * 边缘模糊
   */
  NAME_LINEAR_BLUR = 'linearBlur',

  /**
   * 层级
   */
  NAME_INDEX = 'index',

  /**
   * 内容模糊半径
   */
  NAME_CONTENT_BLUR_RADIUS = 'contentBlurRadius',

  /**
   * 文本透明度
   */
  NAME_TEXT_ALPHA = 'textAlpha',

  /**
   * 图标透明度
   */
  NAME_ICON_ALPHA = 'iconAlpha',

  /**
   * 内容透明度
   */
  NAME_CONTENT_ALPHA = 'contentAlpha',

  /**
   * 内容偏移X
   */
  NAME_CONTENT_CLIP_OFFSET_X = 'contentClipOffsetX',

  /**
   * 内容偏移Y
   */
  NAME_CONTENT_CLIP_OFFSET_Y = 'contentClipOffsetY'
}

/**
 * 动效属性类型
 * 方便传参及处理动效过滤
 */
export enum PropertyType {
  /**
   * 透明度
   */
  ALPHA = 0x01,

  /**
   * X轴缩放
   */
  SCALE_X = 0x02,

  /**
   * Y轴缩放
   */
  SCALE_Y = 0x04,

  /**
   * Z轴缩放
   */
  SCALE_Z = 0x08,

  /**
   * 缩放原点坐标X
   */
  SCALE_PIVOT_X = 0x10,

  /**
   * 缩放原点坐标Y
   */
  SCALE_PIVOT_Y = 0x20,

  /**
   * X轴平移
   */
  TRAN_X = 0x40,

  /**
   * Y轴平移
   */
  TRAN_Y = 0x80,

  /**
   * Z轴平移
   */
  TRAN_Z = 0x100,

  /**
   * 沿X轴旋转，0未开启，1开启
   */
  ROTATION_X = 0x200,

  /**
   * 沿Y轴旋转，0未开启，1开启
   */
  ROTATION_Y = 0x400,

  /**
   * 沿Z轴旋转，0未开启，1开启
   */
  ROTATION_Z = 0x800,

  /**
   * 旋转原点坐标X
   */
  ROTATION_PIVOT_X = 0x1000,

  /**
   * 旋转原点坐标Y
   */
  ROTATION_PIVOT_Y = 0x2000,

  /**
   * 旋转原点坐标Z
   */
  ROTATION_PIVOT_Z = 0x4000,

  /**
   * 旋转视角高度
   */
  ROTATION_PERSPECTIVE = 0x8000,

  /**
   * 旋转角度
   */
  ROTATION_ANGLE = 0x10000,

  /**
   * 组件宽度
   */
  WIDTH = 0x20000,

  /**
   * 组件高度
   */
  HEIGHT = 0x40000,

  /**
   * 文本字体大小
   */
  FONT_SIZE = 0x80000,

  /**
   * 左上角圆角
   */
  BORDER_RADIUS_TL = 0x100000,

  /**
   * 右上角圆角
   */
  BORDER_RADIUS_TR = 0x200000,

  /**
   * 左下角圆角
   */
  BORDER_RADIUS_BL = 0x400000,

  /**
   * 右下角圆角
   */
  BORDER_RADIUS_BR = 0x800000,

  /**
   * 外边距left
   */
  MARGIN_LEFT = 0x1000000,

  /**
   * 外边距right
   */
  MARGIN_RIGHT = 0x2000000,

  /**
   * 外边距top
   */
  MARGIN_TOP = 0x4000000,

  /**
   * 外边距bottom
   */
  MARGIN_BOTTOM = 0x8000000,

  /**
   * 切割X轴起始点
   */
  CLIP_OFFSET_X = 0x10000000,

  /**
   * 切割Y轴起始点
   */
  CLIP_OFFSET_Y = 0x20000000,

  /**
   * 切割宽度
   */
  CLIP_WIDTH = 0x40000000,

  /**
   * 切割高度
   */
  CLIP_HEIGHT = 0x80000000,

  /**
   * 组件点击缩放值
   */
  CLICK_EFFECT_SCALE = 0x100000000,

  /**
   * 模糊半径
   */
  BLUR = 0x200000000,

  /**
   * 边缘模糊
   */
  LINEAR_BLUR = 0x400000000,

  /**
   * 层级
   */
  INDEX = 0x800000000,

  /**
   * 内容模糊半径
   */
  CONTENT_BLUR_RADIUS = 0x1000000000,

  /**
   * 文本透明度
   */
  TEXT_ALPHA = 0x2000000000,

  /**
   * 文本透明度
   */
  ICON_ALPHA = 0x4000000000,

  /**
   * 内容透明度
   */
  CONTENT_ALPHA = 0x8000000000,

  /**
   * 胶囊内容偏移X
   */
  CONTENT_CLIP_OFFSET_X = 0x10000000000,

  /**
   * 胶囊内容偏移Y
   */
  CONTENT_CLIP_OFFSET_Y = 0x20000000000
}

/**
 * 属性默认值
 */
export interface PropertyDefaultValue {
  /**
   * 属性名称
   */
  propertyName: string;

  /**
   * 属性初始值
   */
  initValue?: number;

  /**
   * 限制最小值
   */
  minValue?: number;

  /**
   * 限制最大值
   */
  maxValue?: number;
}

/**
 * 属性类型-属性默认值映射关系
 */
export const PROPERTY_MAP: Map<PropertyType, PropertyDefaultValue> = new Map([
  // 透明度0~1
  [PropertyType.ALPHA, {
    propertyName: PropertyName.NAME_ALPHA,
    minValue: AnimValue.VALUE_MIN,
    maxValue: AnimValue.VALUE_MAX
  }],
  // 缩放不允许负数
  [PropertyType.SCALE_X, {
    propertyName: PropertyName.NAME_SCALE_X,
    minValue: AnimValue.VALUE_MIN
  }],
  // 缩放不允许负数
  [PropertyType.SCALE_Y, {
    propertyName: PropertyName.NAME_SCALE_Y,
    minValue: AnimValue.VALUE_MIN
  }],
  // 缩放不允许负数
  [PropertyType.SCALE_Z, {
    propertyName: PropertyName.NAME_SCALE_Z,
    initValue: AnimValue.VALUE_MAX,
    minValue: AnimValue.VALUE_MIN
  }],
  [PropertyType.SCALE_PIVOT_X, {
    propertyName: PropertyName.NAME_SCALE_PIVOT_X,
    minValue: AnimValue.VALUE_MIN
  }],
  [PropertyType.SCALE_PIVOT_Y, {
    propertyName: PropertyName.NAME_SCALE_PIVOT_Y,
    minValue: AnimValue.VALUE_MIN
  }],
  [PropertyType.TRAN_X, {
    propertyName: PropertyName.NAME_TRAN_X,
    initValue: AnimValue.VALUE_MIN
  }],
  [PropertyType.TRAN_Y, {
    propertyName: PropertyName.NAME_TRAN_Y,
    initValue: AnimValue.VALUE_MIN
  }],
  [PropertyType.TRAN_Z, {
    propertyName: PropertyName.NAME_TRAN_Z,
    initValue: AnimValue.VALUE_MIN
  }],
  // 1标示旋转开启
  [PropertyType.ROTATION_X, {
    propertyName: PropertyName.NAME_ROTATION_X,
    initValue: AnimValue.VALUE_MAX
  }],
  // 1标示旋转开启
  [PropertyType.ROTATION_Y, {
    propertyName: PropertyName.NAME_ROTATION_Y,
    initValue: AnimValue.VALUE_MAX
  }],
  // 1标示旋转开启
  [PropertyType.ROTATION_Z, {
    propertyName: PropertyName.NAME_ROTATION_Z,
    initValue: AnimValue.VALUE_MAX
  }],
  [PropertyType.ROTATION_PIVOT_X, {
    propertyName: PropertyName.NAME_ROTATION_PIVOT_X,
    minValue: AnimValue.VALUE_MIN
  }],
  [PropertyType.ROTATION_PIVOT_Y, {
    propertyName: PropertyName.NAME_ROTATION_PIVOT_Y,
    minValue: AnimValue.VALUE_MIN
  }],
  [PropertyType.ROTATION_PIVOT_Z, {
    propertyName: PropertyName.NAME_ROTATION_PIVOT_Z,
    minValue: AnimValue.VALUE_MIN
  }],
  [PropertyType.ROTATION_PERSPECTIVE, {
    propertyName: PropertyName.NAME_ROTATION_PERSPECTIVE
  }],
  [PropertyType.ROTATION_ANGLE, {
    propertyName: PropertyName.NAME_ROTATION_ANGLE,
    initValue: AnimValue.VALUE_MIN
  }],
  [PropertyType.WIDTH, {
    propertyName: PropertyName.NAME_WIDTH,
    minValue: AnimValue.VALUE_MIN
  }],
  [PropertyType.HEIGHT, {
    propertyName: PropertyName.NAME_HEIGHT,
    minValue: AnimValue.VALUE_MIN
  }],
  [PropertyType.FONT_SIZE, {
    propertyName: PropertyName.NAME_FONT_SIZE,
    minValue: AnimValue.VALUE_MIN
  }],
  [PropertyType.BORDER_RADIUS_TL, {
    propertyName: PropertyName.NAME_BORDER_RADIUS_TL,
    minValue: AnimValue.VALUE_MIN
  }],
  [PropertyType.BORDER_RADIUS_TR, {
    propertyName: PropertyName.NAME_BORDER_RADIUS_TR,
    minValue: AnimValue.VALUE_MIN
  }],
  [PropertyType.BORDER_RADIUS_BL, {
    propertyName: PropertyName.NAME_BORDER_RADIUS_BL,
    minValue: AnimValue.VALUE_MIN
  }],
  [PropertyType.BORDER_RADIUS_BR, {
    propertyName: PropertyName.NAME_BORDER_RADIUS_BR,
    minValue: AnimValue.VALUE_MIN
  }],
  [PropertyType.MARGIN_LEFT, {
    propertyName: PropertyName.NAME_MARGIN_LEFT
  }],
  [PropertyType.MARGIN_RIGHT, {
    propertyName: PropertyName.NAME_MARGIN_RIGHT
  }],
  [PropertyType.MARGIN_TOP, {
    propertyName: PropertyName.NAME_MARGIN_TOP
  }],
  [PropertyType.MARGIN_BOTTOM, {
    propertyName: PropertyName.NAME_MARGIN_BOTTOM
  }],
  [PropertyType.CLIP_OFFSET_X, {
    propertyName: PropertyName.NAME_CLIP_OFFSET_X,
    initValue: AnimValue.VALUE_MIN
  }],
  [PropertyType.CLIP_OFFSET_Y, {
    propertyName: PropertyName.NAME_CLIP_OFFSET_Y,
    initValue: AnimValue.VALUE_MIN
  }],
  [PropertyType.CLIP_WIDTH, {
    propertyName: PropertyName.NAME_CLIP_WIDTH,
    minValue: AnimValue.VALUE_MIN
  }],
  [PropertyType.CLIP_HEIGHT, {
    propertyName: PropertyName.NAME_CLIP_HEIGHT,
    minValue: AnimValue.VALUE_MIN
  }],
  // 点击缩放
  [PropertyType.CLICK_EFFECT_SCALE, {
    propertyName: PropertyName.NAME_CLICK_EFFECT_SCALE,
    minValue: AnimValue.VALUE_MIN,
    maxValue: AnimValue.VALUE_MAX
  }],
  [PropertyType.BLUR, {
    propertyName: PropertyName.NAME_BLUR,
    minValue: AnimValue.VALUE_MIN,
    maxValue: AnimValue.VALUE_BLUE_MAX
  }],
  [PropertyType.LINEAR_BLUR, {
    propertyName: PropertyName.NAME_LINEAR_BLUR,
    minValue: AnimValue.VALUE_MIN,
    maxValue: AnimValue.VALUE_BLUE_MAX
  }],
  [PropertyType.INDEX, {
    propertyName: PropertyName.NAME_INDEX
  }],
  [PropertyType.CONTENT_BLUR_RADIUS, {
    propertyName: PropertyName.NAME_CONTENT_BLUR_RADIUS,
    minValue: AnimValue.VALUE_MIN,
    maxValue: AnimValue.VALUE_BLUE_MAX
  }],
  [PropertyType.TEXT_ALPHA, {
    propertyName: PropertyName.NAME_TEXT_ALPHA,
    initValue: AnimValue.VALUE_MAX,
    minValue: AnimValue.VALUE_MIN,
    maxValue: AnimValue.VALUE_MAX,
  }],
  [PropertyType.ICON_ALPHA, {
    propertyName: PropertyName.NAME_ICON_ALPHA,
    initValue: AnimValue.VALUE_MAX,
    minValue: AnimValue.VALUE_MIN,
    maxValue: AnimValue.VALUE_MAX,
  }],
  [PropertyType.CONTENT_ALPHA, {
    propertyName: PropertyName.NAME_CONTENT_ALPHA,
    initValue: AnimValue.VALUE_MAX,
    minValue: AnimValue.VALUE_MIN,
    maxValue: AnimValue.VALUE_MAX
  }],
  [PropertyType.CONTENT_CLIP_OFFSET_X, {
    propertyName: PropertyName.NAME_CONTENT_CLIP_OFFSET_X,
    initValue: AnimValue.VALUE_MIN
  }],
  [PropertyType.CONTENT_CLIP_OFFSET_Y, {
    propertyName: PropertyName.NAME_CONTENT_CLIP_OFFSET_Y,
    initValue: AnimValue.VALUE_MIN
  }]
]);