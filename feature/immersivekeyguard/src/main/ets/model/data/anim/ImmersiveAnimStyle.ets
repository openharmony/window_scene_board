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
 * 组件动效样式类型
 */
export enum AnimStyleType {
  /**
   * 组件圆角
   */
  RADIUS = 'viewRadius',

  /**
   * 组件顶部内间距
   */
  PADDING_TOP = 'viewPaddingTop',

  /**
   * 组件左侧内间距
   */
  PADDING_LEFT = 'viewPaddingLeft',

  /**
   * 组件顶部外间距
   */
  MARGIN_TOP = 'viewMarginTop',

  /**
   * 组件左侧外间距
   */
  MARGIN_LEFT = 'viewMarginLeft',

  /**
   * 组件右侧外间距
   */
  MARGIN_RIGHT = 'viewMarginRight',

  /**
   * 组件现有竖向位移
   */
  TRAN_Y = 'viewTranY',

  /**
   * 组件透明度
   */
  ALPHA = 'viewAlpha'
}

/**
 * 沉浸动效组件默认UI样式
 */
export class ImmersiveAnimStyle {
  /**
   * 设置样式值
   *
   * @param type 样式类型
   * @param value 对应值
   * @returns 链式
   */
  bindStyle(type: AnimStyleType, value?: number): ImmersiveAnimStyle {
    Reflect.set(this, type, value);
    return this;
  }

  /**
   * 获取对应样式值
   *
   * @param type 样式类型
   * @returns 值
   */
  getStyleValue(type: AnimStyleType): number | undefined {
    return Reflect.get(this, type) as number;
  }

  /**
   * 获取对应样式值
   *
   * @param type 样式类型
   * @param defaultValue 样式类型
   * @returns 值
   */
  getValueDefault(type: AnimStyleType, defaultValue: number = 0): number {
    return this.getStyleValue(type) ?? defaultValue;
  }
}