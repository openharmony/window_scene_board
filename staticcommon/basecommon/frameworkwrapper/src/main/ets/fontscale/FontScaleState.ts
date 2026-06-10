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

import { ResUtilProxy } from '../utils/ResUtilProxy';

@Observed
export class FontScaleState {
  public static systemUIMaxScale: number = 2;
  public static timeMaxScale: number = 1;
  public static cardMaxScale: number = 1.75;
  public static capsuleMaxScale: number = 1.15;
  public static tipMaxScale: number = 2;
  public static cardTipMaxScale: number = 1;
  public static FONT_SCALE = 'font_scale';
  public static FONT_SCALE_DEFAULT = '1';
  public static recentUIMaxScale: number = 1.3;
  public static systemUIOuterHomeFoldScale: number = 1;
  /**
   * 系统fp字体扩大倍数
   */
  fontSizeScale: number = 1;

  /**
   * 获取字体、行高使用大小（vp）
   */
  public getScaleSize(font: Resource | number, isIgnoreFontScaleState: boolean = false): string {
    if (typeof font === 'number') {
      return font * this.getFontScale(isIgnoreFontScaleState) + 'vp';
    }

    return ResUtilProxy.getInstance().getNumber(font) * this.getFontScale(isIgnoreFontScaleState) + 'vp';
  }

  public getCapSize(font: number): string {
      return font * this.getCapsuleMaxFont() + 'vp';
  }

  public getCardSize(font: number): string {
      return font * this.getCardMaxFont() + 'vp';
  }

  public getCardTipSize(font: Resource | number): string {
    if (typeof font === 'number') {
      return font * this.getCardTipMaxFont() + 'vp';
    }
    return ResUtilProxy.getInstance().getNumber(font) * this.getCardTipMaxFont() + 'vp';
  }

  /**
   * 获取字体放大倍数（systemUI限制在2倍,扩展可折叠设备实况卡片为1倍）
   * isIgnoreFontScaleState默认为false，如果是true则不响应大字体
   */
  public getFontScale(isIgnoreFontScaleState: boolean = false): number {
    return Math.min(isIgnoreFontScaleState ? FontScaleState.systemUIOuterHomeFoldScale :
    FontScaleState.systemUIMaxScale, this.fontSizeScale);
  }

  /**
   * 获取字体放大倍数（UX设计稿 沉浸卡片限制在1.75倍）
   */
  public getCardMaxFont(): number {
    return Math.min(FontScaleState.cardMaxScale, Number(this.fontSizeScale));
  }

  /**
   * 获取字体放大倍数（UX设计稿 锁屏胶囊限制在1.15倍）
   */
  public getCapsuleMaxFont(): number {
    return Math.min(FontScaleState.capsuleMaxScale, Number(this.fontSizeScale));
  }

  /**
   * 获取字体放大倍数（UX设计稿 沉浸提示语限制在1倍）
   */
  public getCardTipMaxFont(): number {
    return Math.min(FontScaleState.cardTipMaxScale, Number(this.fontSizeScale));
  }

  /**
   * 获取字体、行高使用大小（vp）
   */
  public getRecentScaleSize(font: Resource | number): string {
    if (typeof font === 'number') {
      return font * this.getRecentFontScale() + 'vp';
    }

    return ResUtilProxy.getInstance().getNumber(font) * this.getRecentFontScale() + 'vp';
  }

  /**
   * 获取字体放大倍数（recent限制在1.3倍）
   */
  public getRecentFontScale(): number {
    return Math.min(FontScaleState.recentUIMaxScale, this.fontSizeScale);
  }

  public setFontScaleSize(font: Resource | number, fontSizeScale: number): string {
    if (typeof font === 'number') {
      return font * fontSizeScale + 'vp';
    }
    return ResUtilProxy.getInstance().getNumber(font) * fontSizeScale + 'vp';
  }
}