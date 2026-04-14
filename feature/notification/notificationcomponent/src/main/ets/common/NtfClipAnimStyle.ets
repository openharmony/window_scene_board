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
 * 通知条目切割动效参数
 */
export class NtfClipAnimStyle implements AnimatableArithmetic<NtfClipAnimStyle> {
  /**
   * 裁切动效默认开启
   */
  private isClipAnimEnable: boolean = true;

  /**
   * 裁切宽度
   */
  public clipWidth: number = 0;

  /**
   * 裁切高度
   */
  public clipHeight: number = 0;

  /**
   * 裁切横向偏移
   */
  public clipOffsetX: number = 0;

  /**
   * 裁切竖向偏移
   */
  public clipOffsetY: number = 0;

  /**
   * 裁切圆角
   */
  public clipRadius: number = 0;

  /**
   * 是否是简单裁剪(即.clip(true)属性)
   */
  public simpleClipEnable: boolean = false;

  /**
   * 是否开启形状裁切
   *
   * @returns true开启裁切
   */
  public isRectClipEnable(): boolean {
    return this.isClipAnimEnable;
  }

  /**
   * 简单裁剪是否开启
   *
   * @returns true 启用简单裁剪
   */
  public isSimpleClipEnable(): boolean {
    return this.simpleClipEnable;
  }

  /**
   * 设置裁切开关
   *
   * @param isClipEnable true开启
   * @returns 链式
   */
  public buildClipEnable(isClipEnable: boolean): NtfClipAnimStyle {
    this.isClipAnimEnable = isClipEnable;
    return this;
  }

  /**
   * 设置裁切宽度
   *
   * @param clipWidth 裁切宽度
   * @returns 链式
   */
  public buildWidth(clipWidth: number): NtfClipAnimStyle {
    this.clipWidth = clipWidth;
    return this;
  }

  /**
   * 设置裁切高度
   *
   * @param clipHeight 裁切高度
   * @returns 链式
   */
  public buildHeight(clipHeight: number): NtfClipAnimStyle {
    this.clipHeight = clipHeight;
    return this;
  }

  /**
   * 设置裁切横向偏移
   *
   * @param offsetX 横向偏移
   * @returns 链式
   */
  public buildOffsetX(offsetX: number): NtfClipAnimStyle {
    this.clipOffsetX = offsetX;
    return this;
  }

  /**
   * 设置裁切竖向偏移
   *
   * @param offsetY 竖向偏移
   * @returns 链式
   */
  public buildOffsetY(offsetY: number): NtfClipAnimStyle {
    this.clipOffsetY = offsetY;
    return this;
  }

  /**
   * 设置裁切圆角
   *
   * @param radius 圆角
   * @returns 链式
   */
  public buildRadius(radius: number): NtfClipAnimStyle {
    this.clipRadius = radius;
    return this;
  }

  /**
   * 设置简单裁剪参数
   *
   * @param enable 是否启用简单裁剪
   * @returns true表示启用
   */
  public buildSimpleClipEnable(enable: boolean): NtfClipAnimStyle {
    this.isClipAnimEnable = false;
    this.simpleClipEnable = enable;
    return this;
  }

  /**
   * 复写AnimatableArithmetic
   */
  public plus(rhs: NtfClipAnimStyle): NtfClipAnimStyle {
    const ret = new NtfClipAnimStyle()
      .buildWidth(rhs.clipWidth + this.clipWidth)
      .buildHeight(rhs.clipHeight + this.clipHeight)
      .buildOffsetX(rhs.clipOffsetX + this.clipOffsetX)
      .buildOffsetY(rhs.clipOffsetY + this.clipOffsetY)
      .buildRadius(rhs.clipRadius + this.clipRadius);
    if (this.simpleClipEnable === rhs.simpleClipEnable) {
      ret.simpleClipEnable = this.simpleClipEnable;
    }
    if (this.isClipAnimEnable === rhs.isClipAnimEnable) {
      ret.isClipAnimEnable = this.isClipAnimEnable;
    }
    return ret;
  }

  /**
   * 复写AnimatableArithmetic
   */
  public subtract(rhs: NtfClipAnimStyle): NtfClipAnimStyle {
    const ret = new NtfClipAnimStyle()
      .buildWidth(this.clipWidth - rhs.clipWidth)
      .buildHeight(this.clipHeight - rhs.clipHeight)
      .buildOffsetX(this.clipOffsetX - rhs.clipOffsetX)
      .buildOffsetY(this.clipOffsetY - rhs.clipOffsetY)
      .buildRadius(this.clipRadius - rhs.clipRadius);
    if (this.simpleClipEnable === rhs.simpleClipEnable) {
      ret.simpleClipEnable = this.simpleClipEnable;
    }
    if (this.isClipAnimEnable === rhs.isClipAnimEnable) {
      ret.isClipAnimEnable = this.isClipAnimEnable;
    }
    return ret;
  }

  /**
   * 复写AnimatableArithmetic
   */
  public multiply(scale: number): NtfClipAnimStyle {
    const ret = new NtfClipAnimStyle()
      .buildWidth(this.clipWidth * scale)
      .buildHeight(this.clipHeight * scale)
      .buildOffsetX(this.clipOffsetX * scale)
      .buildOffsetY(this.clipOffsetY * scale)
      .buildRadius(this.clipRadius * scale);
    ret.simpleClipEnable = this.simpleClipEnable;
    ret.isClipAnimEnable = this.isClipAnimEnable;
    return ret;
  }

  /**
   * 复写AnimatableArithmetic
   */
  public equals(rhs: NtfClipAnimStyle): boolean {
    if (this.isRectClipEnable() !== rhs.isRectClipEnable()) {
      return false;
    } else if (this.isRectClipEnable()) {
      return this.clipWidth === rhs.clipWidth && this.clipOffsetX === rhs.clipOffsetX &&
        this.clipHeight === rhs.clipHeight && this.clipOffsetY === rhs.clipOffsetY;
    } else {
      return this.isSimpleClipEnable() === rhs.isSimpleClipEnable();
    }
  }
}

// 默认裁切样式
export const DEFAULT_CLIP: NtfClipAnimStyle = new NtfClipAnimStyle().buildClipEnable(false);