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
 * 该类定义是从 SCBTransitionController.ts 中迁移过来的
 */
export class RectInfo {
  /**
   * Indicates form positionX
   */
  left: number = 0;

  /**
   * Indicates form positionY.
   */
  top: number = 0;

  /**
   * Indicates form formItemWidth.
   */
  right: number = 0;

  /**
   * Indicates form formItemHeight.
   */
  bottom: number = 0;

  /**
   * Indicates form formItemHeight.
   */
  height?: number = 0;

  /**
   * Indicates form formItemWidth.
   */
  width?: number = 0;

  /**
   * Indicates form formItemRadius.
   */
  radius?: number;

  public toString(): string {
    return `rect left:${this.left}, top:${this.top}, right:${this.right}, bottom:${this.bottom}, width:${this.width}, height:${this.height}`;
  }

  /**
   * 判断rectInfo矩阵是否竖向
   */
  public isVertical?(): boolean | undefined {
    let width = this.right - this.left;
    let height = this.bottom - this.top;
    if (width === 0 || height === 0) {
      return undefined;
    }
    return width < height;
  }

  /**
   * 设置宽度值
   *
   * @param width 宽
   * @returns RectInfo
   */
  public setWidth(width: number): RectInfo {
    this.width = width;
    return this;
  }

  /**
   * 设置高度值
   *
   * @param height 高
   * @returns RectInfo
   */
  public setHeight(height: number): RectInfo {
    this.height = height;
    return this;
  }

  public constructor(left: number = 0, top: number = 0, width: number = 0, height: number = 0) {
    this.left = left;
    this.top = top;
    this.width = width;
    this.height = height;
    this.right = left + width;
    this.bottom = top + height;
  }
}