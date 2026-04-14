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

import { clockWidgetConfigManager } from '../../clock/common/ClockWidgetConfigManager';
import { UDFontAdapterUtil } from '../../clock/common/UDFontAdapterUtil';
import {
  ClockLayout,
  ClockTextAlign,
  AestheticColorArgs
} from '../../common/WidgetParam';

const DIMENSION_4_4_GRID_AMOUNT_X: number = 4;
const DIMENSION_4_4_GRID_AMOUNT_Y: number = 4;
export const DIMENSION_4_2_GRID_AMOUNT_X: number = 2;
const DIMENSION_4_2_GRID_AMOUNT_Y: number = 4;
export const DIMENSION_4_3_GRID_AMOUNT_Y: number = 3;
const DIMENSION_2_4_GRID_AMOUNT_X: number = 4;
export const DIMENSION_2_4_GRID_AMOUNT_Y: number = 2;
export const CLOCK_DEFAULT_FOREGROUND_COLOR: string = '#FFFFFF';
export const CLOCK_DEFAULT_FONT_FAMILY: string = 'HarmonyHeiTi';
const CLOCK_HEIGHT_MAP: Map<ClockLayout, number> = new Map([
  [ClockLayout.DIMENSION_4_4, DIMENSION_4_4_GRID_AMOUNT_Y],
  [ClockLayout.DIMENSION_4_2, DIMENSION_4_2_GRID_AMOUNT_Y],
  [ClockLayout.DIMENSION_2_4, DIMENSION_2_4_GRID_AMOUNT_Y],
])

export interface AnyClockInterface {
  x?: number;
  y?: number;
  layout?: ClockLayout;
  alignment?: ClockTextAlign;
  clockStrokeColor?: string;
  clockFontFamily?: string;
  isDof?: boolean; // 景深时钟样式
  isClockTextShadowEnabled?: boolean;
  isClockTextBlurEffectEnabled?: boolean;
  isClockDateVisible?: boolean;
  isClockLunarVisible?: boolean;
  isClockSignatureVisible?: boolean;
  clockSignatureText?: string;
  clockDegreeNumber?: number;
}

@Observed
export class AnyClock {
  public layout: ClockLayout;
  public x: number;
  public y: number;
  public alignment: ClockTextAlign;
  public clockStrokeColor: string;
  public clockFontFamily: string;
  public isDof: boolean; // 景深时钟样式
  public dofClockLayout?: ClockLayout; // 景深时钟样式
  public dofClockX?: number; // 景深时钟X坐标
  public dofClockY?: number; // 景深时钟X坐标

  public isClockTextShadowEnabled: boolean;
  public isClockTextBlurEffectEnabled: boolean;
  public isClockDateVisible: boolean;
  public isClockLunarVisible: boolean;
  public isClockSignatureVisible: boolean;
  public clockSignatureText: string;
  public clockDegreeNumber: number;
  public aestheticColorArgs?: AestheticColorArgs;
  public isLightWallpaper?: boolean;
  public isPosterShadow?: boolean = false;

  constructor(args?: AnyClockInterface) {
    this.x = args?.x ?? 0;
    this.y = args?.y ?? 0;
    // clockFontFamily赋值需要在layout之前，因为layout更新触发布局参数刷新，对于艺术签名而言，布局参数刷新依赖于正确的字体
    this.clockFontFamily = args?.clockFontFamily ?? CLOCK_DEFAULT_FONT_FAMILY;
    if (typeof args?.layout !== 'undefined') {
      this.layout = args!.layout;
    } else {
      this.layout = UDFontAdapterUtil.isUD() ? ClockLayout.DEFAULT_CLOCK_LAYOUT : ClockLayout.DIMENSION_4_4;
    }
    if (typeof args?.alignment !== 'undefined') {
      this.alignment = args!.alignment;
    } else {
      this.alignment = ClockTextAlign.CENTER;
    }
    this.clockDegreeNumber = args?.clockDegreeNumber ?? 0;
    this.clockStrokeColor = args?.clockStrokeColor ?? CLOCK_DEFAULT_FOREGROUND_COLOR;

    this.isDof = args?.isDof ?? false;
    if (this.isDof) {
      this.dofClockLayout = this.layout;
      this.dofClockX = this.x;
      this.dofClockY = this.y;
    }
    if (typeof args?.isClockTextShadowEnabled !== 'undefined') {
      this.isClockTextShadowEnabled = args!.isClockTextShadowEnabled;
    } else {
      this.isClockTextShadowEnabled = true;
    }
    if (typeof args?.isClockTextBlurEffectEnabled !== 'undefined') {
      this.isClockTextBlurEffectEnabled = args!.isClockTextBlurEffectEnabled;
    } else {
      this.isClockTextBlurEffectEnabled = true;
    }
    if (typeof args?.isClockDateVisible !== 'undefined') {
      this.isClockDateVisible = args!.isClockDateVisible;
    } else {
      this.isClockDateVisible = true;
    }
    if (typeof args?.isClockLunarVisible !== 'undefined') {
      this.isClockLunarVisible = args!.isClockLunarVisible;
    } else {
      this.isClockLunarVisible = true;
    }
    if (typeof args?.isClockSignatureVisible !== 'undefined') {
      this.isClockSignatureVisible = args!.isClockSignatureVisible;
    } else {
      this.isClockSignatureVisible = false;
    }
    this.clockSignatureText = args?.clockSignatureText ?? '';
  }

  getGridAmountWidth(layout: ClockLayout = this.layout): number {
    if (layout === ClockLayout.DIMENSION_4_4) {
      return DIMENSION_4_4_GRID_AMOUNT_X;
    } else if (layout === ClockLayout.DIMENSION_4_2) {
      return DIMENSION_4_2_GRID_AMOUNT_X;
    } else if (layout === ClockLayout.DIMENSION_2_4) {
      return DIMENSION_2_4_GRID_AMOUNT_X;
    }
    let grid = clockWidgetConfigManager.getExpandClockGridType(layout);
    return grid?.gridWidthAmount ?? DIMENSION_4_4_GRID_AMOUNT_X;
  }

  getGridAmountHeight(layout: ClockLayout = this.layout): number {
    let height = CLOCK_HEIGHT_MAP.get(layout);
    if (height !== undefined) {
      return height;
    }
    let grid = clockWidgetConfigManager.getExpandClockGridType(layout);
    return grid?.gridHeightAmount ?? DIMENSION_4_4_GRID_AMOUNT_Y;
  }

  toString(): string {
    return `{ "x":${this.x},"y":${this.y},"layout":${this.layout}, "clockDegree:"${this.clockDegreeNumber},"alignment":${this.alignment},"clockStrokeColor":${this.clockStrokeColor},"clockFontFamily":${this.clockFontFamily},"isClockTextShadowEnabled":${this.isClockTextShadowEnabled},"isClockTextBlurEffectEnabled":${this.isClockTextBlurEffectEnabled},"isClockDateVisible":${this.isClockDateVisible},"isClockLunarVisible":${this.isClockLunarVisible},"isClockSignatureVisible":${this.isClockSignatureVisible},"clockSignatureText length":${this.clockSignatureText?.length},"aestheticColorArgs":{ "radius": ${this.aestheticColorArgs?.radius},"saturation": ${this.aestheticColorArgs?.saturation},"brightness": ${this.aestheticColorArgs?.brightness},"needColor": ${this.aestheticColorArgs?.needColor},"isShadow": ${this.aestheticColorArgs?.isShadow},"isChangeColor": ${this.aestheticColorArgs?.isChangeColor} },"isLightWallpaper":${this.isLightWallpaper ??
      ''}},"isPosterShadow":${this.isPosterShadow}}`;
  }

  public updateDofState(): void {
    let isDof = true;

    if (this.layout !== this.dofClockLayout || this.x !== this.dofClockX || this.y !== this.dofClockY) {
      isDof = false;
    }

    this.isDof = isDof;
  }

  /**
   * 深拷贝AnyClock
   * @param newClock 数据来源
   * @returns 拷贝后的对象
   */
  public deepClone(newClock: AnyClock): AnyClock {
    if (!newClock) {
      return this;
    }
    this.layout = newClock.layout;
    this.x = newClock.x;
    this.y = newClock.y;
    this.alignment = newClock.alignment;
    this.clockStrokeColor = newClock.clockStrokeColor;
    this.clockFontFamily = newClock.clockFontFamily;
    this.isDof = newClock.isDof;
    this.dofClockLayout = newClock.dofClockLayout;
    this.dofClockX = newClock.dofClockX;
    this.dofClockY = newClock.dofClockY;
    this.isClockTextShadowEnabled = newClock.isClockTextShadowEnabled;
    this.isPosterShadow = newClock.isPosterShadow;
    this.isClockTextBlurEffectEnabled = newClock.isClockTextBlurEffectEnabled;
    this.isClockDateVisible = newClock.isClockDateVisible;
    this.isClockLunarVisible = newClock.isClockLunarVisible;
    this.isClockSignatureVisible = newClock.isClockSignatureVisible;
    this.clockSignatureText = newClock.clockSignatureText;
    this.clockDegreeNumber = newClock.clockDegreeNumber;
    if (newClock.aestheticColorArgs) {
      this.aestheticColorArgs = {
        radius: newClock.aestheticColorArgs.radius,
        saturation: newClock.aestheticColorArgs.saturation,
        brightness: newClock.aestheticColorArgs.brightness,
        needColor: newClock.aestheticColorArgs.needColor,
        isShadow: newClock.aestheticColorArgs.isShadow,
        isChangeColor: newClock.aestheticColorArgs.isChangeColor,
      }
    }
    this.isLightWallpaper = newClock.isLightWallpaper;
    return this;
  }
}
