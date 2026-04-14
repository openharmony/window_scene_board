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

const DIVIDE = 2;

/**
 * 组件位置
 */
export interface ComponentPosition {
  /**
   * 全局横坐标
   */
  globalX?: number;

  /**
   * 全局纵坐标
   */
  globalY?: number;

  /**
   * 组件宽度
   */
  width?: number;

  /**
   * 组件高度
   */
  height?: number;

  /**
   * 组件圆角半径
   */
  radius?: number;
}

/**
 * 位置属性
 */
export enum PosProperty {
  GLOBAL_X = 'globalX',
  GLOBAL_Y = 'globalY',
  WIDTH = 'width',
  HEIGHT = 'height',
  RADIUS = 'radius',
}

/**
 * 装饰器
 */
export class CmpPosWrapper {
  /**
   * 组件位置
   */
  private position?: ComponentPosition;

  /**
   * 私有构造
   *
   * @param pos 组件位置
   */
  private constructor(pos?: ComponentPosition) {
    this.position = pos;
  }

  /**
   * 获取组件圆角
   */
  getCmpRadius(): number {
    return this.position?.radius ?? 0;
  }

  /**
   * 获取组件全局横坐标
   *
   * @returns 横坐标
   */
  getCmpGlobalX(): number {
    return this.position?.globalX ?? 0;
  }

  /**
   * 中心点横坐标
   *
   * @returns 横坐标
   */
  getCmpCenterX(): number {
    return this.getCmpGlobalX() + this.getCmpWidth() / DIVIDE;
  }

  /**
   * 获取组件全局纵坐标
   *
   * @returns 纵坐标
   */
  getCmpGlobalY(): number {
    return this.position?.globalY ?? 0;
  }

  /**
   * 中心点纵坐标
   *
   * @returns 纵坐标
   */
  getCmpCenterY(): number {
    return this.getCmpGlobalY() + this.getCmpHeight() / DIVIDE;
  }

  /**
   * 获取组件宽度
   *
   * @returns 宽
   */
  getCmpWidth(): number {
    return this.position?.width ?? 0;
  }

  /**
   * 获取组件高度
   *
   * @returns 高
   */
  getCmpHeight(): number {
    return this.position?.height ?? 0;
  }

  /**
   * 更新位置属性值
   *
   * @param property 属性
   * @param value 属性值
   * @returns true有更新
   */
  updatePosProperty(property: PosProperty, value?: number): boolean {
    // 无效值
    if (!value) {
      return false;
    }
    if (!this.position) {
      return false;
    }
    if (Reflect.get(this.position, property) !== value) {
      Reflect.set(this.position, property, value);
      return true;
    }
    return false;
  }

  /**
   * 位置有效性
   *
   * @returns true有效
   */
  isPosValid(): boolean {
    return this.getCmpWidth() > 0 && this.getCmpHeight() > 0;
  }

  /**
   * 位置字串打印
   *
   * @returns 位置字串
   */
  toString(): string {
    return `CmpPosWrapper{width=${this.position?.width} height=${this.position?.height} x=${this.position?.globalX} y=${this.position?.globalY} radius=${this.position?.radius}}`;
  }

  /**
   * 装饰组件位置对象
   *
   * @param pos 组件位置
   * @returns 装饰器
   */
  static wrapper(pos?: ComponentPosition): CmpPosWrapper {
    return new CmpPosWrapper(pos);
  }
}