/**
 * Copyright (c) 2023-Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { CheckEmptyUtils, Log} from '@ohos/basicutils';
import { StyleConstants } from '../constants/StyleConstants';

const TAG = 'ColorUtil';
// 计算对比度的3色系数
const LUMINANCE_RATIO_RED = 0.2126;
const LUMINANCE_RATIO_GREEN = 0.7152;
const LUMINANCE_RATIO_BLUE = 0.0722;

// 计算对比度常量
const CONTRAST_CONST = 0.05;
// 相对亮度
const RELATIVE_LUMINANCE: number = 220;
// 阴影颜色RGB(5,5,5)
const SHADOW_RGB_COLOR_VALUE = 5;
// 计算阴影alpha的常量
const SHADOW_ALPHA_CONST = 0.5;

const NUMBER_255 = 255.0;

export class ColorUtil {
  /**
   * 转换RGBA->ResourceColor.string
   *
   * @param red 红
   * @param green 绿
   * @param blue 蓝
   * @param alpha 不透明度(默认0xFF)
   * @return ResourceColor.string
   */
  public static convertRGBA2ResourceColor(red: number, green: number, blue: number, alpha: number = NUMBER_255): string {
    if (CheckEmptyUtils.isEmpty(red) || CheckEmptyUtils.isEmpty(green) || CheckEmptyUtils.isEmpty(blue)) {
      Log.showError(TAG, 'convertColor2ResourceColor: Invalid input parameter.');
      return '';
    }

    return `#${ColorUtil.dec2Hex(alpha, StyleConstants.DEFAULT_2, '0')}${ColorUtil.dec2Hex(red, StyleConstants.DEFAULT_2, '0')}` +
      `${ColorUtil.dec2Hex(green, StyleConstants.DEFAULT_2, '0')}${ColorUtil.dec2Hex(blue, StyleConstants.DEFAULT_2, '0')}`;
  }

  private static dec2Hex(decNumber: number, bit: number, padString: string): string {
    return decNumber.toString(StyleConstants.DEFAULT_16).padStart(bit, padString);
  }

  /**
   * 计算与白色的对比度
   *
   * @param luminance 相对亮度
   * @returns 与白色的对比度
   */
  public static contrast2White(luminance: number): number {
    let whiteL = ColorUtil.rgb2Luminance(
      NUMBER_255,
      NUMBER_255,
      NUMBER_255
    );
    return ColorUtil.contrast(whiteL, luminance);
  }

  /**
   * 计算指定亮度、指定颜色下的不透明度
   *
   * @param red 红
   * @param green 绿
   * @param blue 蓝
   * @param luminance 亮度
   * @returns 不透明度
   */
  public static calAlphaFromRGBAndLuminance(red: number, green: number, blue: number, luminance: number): number {
    return StyleConstants.DEFAULT_2 - (luminance * StyleConstants.DEFAULT_2) /
      (LUMINANCE_RATIO_RED * red + LUMINANCE_RATIO_GREEN * green + LUMINANCE_RATIO_BLUE * blue);
  }


  /**
   * 计算对比度
   *
   * @param luminance1 相对明度
   * @param luminance2 相对明度
   * @returns 对比度
   */
  public static contrast(luminance1: number, luminance2: number): number {
    return (luminance1 + CONTRAST_CONST) / (luminance2 + CONTRAST_CONST);
  }

  /**
   * 根据RGB的值计算相对亮度
   *
   * @param red 红
   * @param green 绿
   * @param blue 蓝
   * @return rgb值相对亮度值
   */
  public static rgb2Luminance(red: number, green: number, blue: number): number {
    if (CheckEmptyUtils.isEmpty(red) || CheckEmptyUtils.isEmpty(green) || CheckEmptyUtils.isEmpty(blue)) {
      Log.showError(TAG, 'rgb2Luminance: Invalid input parameter.');
      return 0;
    }
    let rsRGB = red / NUMBER_255;
    let gsRGB = green / NUMBER_255;
    let bsRGB = blue / NUMBER_255;
    return (LUMINANCE_RATIO_RED * ColorUtil.normalization(rsRGB) + LUMINANCE_RATIO_GREEN * ColorUtil.normalization(gsRGB) +
      LUMINANCE_RATIO_BLUE * ColorUtil.normalization(bsRGB));
  }

  private static normalization(colorValue: number): number {
    if (colorValue <= 0.03928) {
      return colorValue / 12.92;
    } else {
      return Math.pow(((colorValue + 0.055) / 1.055), 2.4);
    }
  }

  /**
   * 根据RGB计算文字阴影的alpha
   * @param red 红
   * @param green 绿
   * @param blue 蓝
   * @returns 文字阴影的透明度
   */
  public static rgb2ShadowAlpha(red: number, green: number, blue: number): number {
    return (red * LUMINANCE_RATIO_RED + green * LUMINANCE_RATIO_GREEN + blue * LUMINANCE_RATIO_BLUE - RELATIVE_LUMINANCE) /
      ((SHADOW_ALPHA_CONST * (red - SHADOW_RGB_COLOR_VALUE)) * LUMINANCE_RATIO_RED +
        (SHADOW_ALPHA_CONST * (green - SHADOW_RGB_COLOR_VALUE)) * LUMINANCE_RATIO_GREEN +
        (SHADOW_ALPHA_CONST * (blue - SHADOW_RGB_COLOR_VALUE)) * LUMINANCE_RATIO_BLUE);
  }
}