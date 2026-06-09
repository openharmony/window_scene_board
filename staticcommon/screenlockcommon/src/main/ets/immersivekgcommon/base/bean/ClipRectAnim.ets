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
 * 矩形裁切动效计算器
 */
export class ClipRectAnim implements AnimatableArithmetic<ClipRectAnim> {
  // 是否开启矩形切割效果
  private _isRectClipEnable: boolean = true;

  // 未开启矩形切割时，通用切割参数
  private _comClip?: boolean | RectAttribute;

  // 裁切宽度
  private _clipWidth?: number;

  // 裁切高度
  private _clipHeight?: number;

  // 裁切横向偏移
  private _clipOffsetX?: number = 0;

  // 裁切竖向偏移
  private _clipOffsetY?: number = 0;

  // 裁切四周圆角
  private _clipRadius?: number = 0;

  /**
   * 矩形切割是否开启
   *
   * @returns true开启
   */
  get isRectClipEnable(): boolean {
    return this._isRectClipEnable;
  }

  /**
   * 未开启矩形切割时，通用切割参数
   *
   * @returns 通用切割参数
   */
  get comClip(): boolean | RectAttribute | undefined {
    return this._comClip;
  }

  /**
   * 裁切宽度，默认100%
   *
   * @returns 裁切宽度
   */
  get clipWidth(): number | string {
    // 宽度按最大值处理
    if (this._clipWidth === 0) {
      return '100%';
    }
    return this._clipWidth ?? '100%';
  }

  /**
   * 裁切高度，默认100%
   *
   * @returns 裁切高度
   */
  get clipHeight(): number | string {
    // 高度按最大值处理
    if (this._clipHeight === 0) {
      return '100%';
    }
    return this._clipHeight ?? '100%';
  }

  /**
   * 裁切横向偏移
   *
   * @returns 横向偏移
   */
  get clipOffsetX(): number {
    return this._clipOffsetX ?? 0;
  }

  /**
   * 裁切竖向偏移
   *
   * @returns 竖向偏移
   */
  get clipOffsetY(): number {
    return this._clipOffsetY ?? 0;
  }

  /**
   * 裁切圆角
   *
   * @returns 圆角
   */
  get clipRadius(): number {
    return this._clipRadius ?? 0;
  }

  /**
   * 矩形切割是否开启
   *
   * @param isEnable true开启
   * @returns 链式
   */
  buildRectClipEnable(isEnable: boolean): ClipRectAnim {
    this._isRectClipEnable = isEnable;
    return this;
  }

  /**
   * 未开启矩形切割时，通用切割参数
   *
   * @param clipParam 切割参数
   * @returns 链式
   */
  buildComClipParam(clipParam?: boolean | RectAttribute): ClipRectAnim {
    this._comClip = clipParam;
    return this;
  }

  /**
   * 裁切宽度
   *
   * @param clipWidth 裁切宽度
   * @returns 链式
   */
  buildClipWidth(clipWidth?: number): ClipRectAnim {
    this._clipWidth = clipWidth ?? 0;
    return this;
  }

  /**
   * 裁切高度
   *
   * @param clipHeight 裁切高度
   * @returns 链式
   */
  buildClipHeight(clipHeight?: number): ClipRectAnim {
    this._clipHeight = clipHeight ?? 0;
    return this;
  }

  /**
   * 裁切横向偏移
   *
   * @param clipOffsetX 裁切横向偏移
   * @returns 链式
   */
  buildClipOffsetX(clipOffsetX?: number): ClipRectAnim {
    this._clipOffsetX = clipOffsetX ?? 0;
    return this;
  }

  /**
   * 裁切竖向偏移
   *
   * @param clipOffsetY 裁切竖向偏移
   * @returns 链式
   */
  buildClipOffsetY(clipOffsetY?: number): ClipRectAnim {
    this._clipOffsetY = clipOffsetY ?? 0;
    return this;
  }

  /**
   * 裁切圆角
   *
   * @param clipRadius 裁切圆角
   * @returns 链式
   */
  buildClipRadius(clipRadius?: number): ClipRectAnim {
    this._clipRadius = clipRadius ?? 0;
    return this;
  }

  plus(rhs: ClipRectAnim): ClipRectAnim {
    return new ClipRectAnim()
      .buildRectClipEnable(this._isRectClipEnable)
      .buildComClipParam(this._comClip)
      .buildClipWidth(this.clipPlus(rhs._clipWidth, this._clipWidth))
      .buildClipHeight(this.clipPlus(rhs._clipHeight, this._clipHeight))
      .buildClipOffsetX(this.clipPlus(rhs._clipOffsetX, this._clipOffsetX))
      .buildClipOffsetY(this.clipPlus(rhs._clipOffsetY, this._clipOffsetY))
      .buildClipRadius(this.clipPlus(rhs._clipRadius, this._clipRadius));
  }

  subtract(rhs: ClipRectAnim): ClipRectAnim {
    return new ClipRectAnim()
      .buildRectClipEnable(this._isRectClipEnable)
      .buildComClipParam(this._comClip)
      .buildClipWidth(this.clipSubtract(this._clipWidth, rhs._clipWidth))
      .buildClipHeight(this.clipSubtract(this._clipHeight, rhs._clipHeight))
      .buildClipOffsetX(this.clipSubtract(this._clipOffsetX, rhs._clipOffsetX))
      .buildClipOffsetY(this.clipSubtract(this._clipOffsetY, rhs._clipOffsetY))
      .buildClipRadius(this.clipSubtract(this._clipRadius, rhs._clipRadius));
  }

  multiply(scale: number): ClipRectAnim {
    return new ClipRectAnim()
      .buildRectClipEnable(this._isRectClipEnable)
      .buildComClipParam(this._comClip)
      .buildClipWidth(this._clipWidth !== undefined ? this._clipWidth * scale : 0)
      .buildClipHeight(this._clipHeight !== undefined ? this._clipHeight * scale : 0)
      .buildClipOffsetX(this._clipOffsetX !== undefined ? this._clipOffsetX * scale : 0)
      .buildClipOffsetY(this._clipOffsetY !== undefined ? this._clipOffsetY * scale : 0)
      .buildClipRadius(this._clipRadius !== undefined ? this._clipRadius * scale : 0);
  }

  equals(rhs: ClipRectAnim): boolean {
    return this._isRectClipEnable === rhs._isRectClipEnable && this._comClip === rhs._comClip &&
      this._clipWidth === rhs._clipWidth && this._clipHeight === rhs._clipHeight &&
      this._clipOffsetX === rhs._clipOffsetX && this._clipOffsetY === rhs._clipOffsetY &&
      this._clipRadius === rhs._clipRadius;
  }

  private clipPlus(clipA?: number, clipB?: number): number | undefined {
    let result: number | undefined = undefined;
    if (clipA !== undefined && clipB !== undefined) {
      result = clipA + clipB;
    }
    return result;
  }

  private clipSubtract(clipA?: number, clipB?: number): number | undefined {
    let result: number | undefined = undefined;
    if (clipA !== undefined && clipB !== undefined) {
      result = clipA - clipB;
    }
    return result;
  }
}