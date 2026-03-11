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

import { LogDomain, LogHelper } from './LogHelper';
import { effectKit } from '@kit.ArkGraphics2D';
import { ConfigurationConstant } from '@kit.AbilityKit';

const TAG = 'SolidColorAlgorithmUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 纯色模式颜色计算算法工具类
 */
export class SolidColorAlgorithmUtils {
  /**
   * 用于分档视效纯色方案中，去掉原有的模糊提亮后，需要将背景色和原有的提亮参数结合，计算出一个纯色
   *
   * @param option 提亮参数
   * @param pickColor 背景颜色
   * @returns 计算得到的提亮后的颜色
   */
  public static calSolidColor(option: BrightnessOptions, pickColor: effectKit.Color): effectKit.Color | undefined {
    if (!option || !pickColor) {
      log.showWarn(`calSolidColor option:${option}, pickColor:${pickColor}`);
      return pickColor;
    }
    const lightenedColor: effectKit.Color = {
      red: SolidColorAlgorithmUtils.calculateLightenedColor(option, pickColor.red / 255),
      green: SolidColorAlgorithmUtils.calculateLightenedColor(option, pickColor.green / 255),
      blue: SolidColorAlgorithmUtils.calculateLightenedColor(option, pickColor.blue / 255),
      alpha: 0
    };

    const posRGB: effectKit.Color = {
      red: option.posRGB[0],
      green: option.posRGB[1],
      blue: option.posRGB[2],
      alpha: 0
    };

    const negRGB: effectKit.Color = {
      red: option.negRGB[0],
      green: option.negRGB[1],
      blue: option.negRGB[2],
      alpha: 0
    };

    const adjustedColor = SolidColorAlgorithmUtils.adjustColorWithSaturationAndOffset(lightenedColor,
      option.saturation, posRGB, negRGB);
    return SolidColorAlgorithmUtils.finalColorCheck(adjustedColor);
  }

  /**
   * 根据提亮参数，将RGB中的每个颜色值转换提亮后的新值
   *
   * @param option 提亮参数
   * @param colorValue RGB的三个数值
   * @returns 计算后的RGB数值
   */
  private static calculateLightenedColor(option: BrightnessOptions, colorValue: number): number {
    return option.cubicCoeff * Math.pow(colorValue, 3) +
      option.quadCoeff * Math.pow(colorValue, 2) +
      option.rate * colorValue + option.lightUpDegree;
  }

  /**
   * 计算饱和度
   *
   * @param srcColor 原有颜色
   * @param saturation 饱和度
   * @returns 计算后的颜色
   */
  private static calculateBaseColor(srcColor: effectKit.Color, saturation: number): number {
    return srcColor.red * 0.2412016 * (1.0 - saturation) +
      srcColor.green * 0.6922296 * (1.0 - saturation) +
      srcColor.blue * 0.0665688 * (1.0 - saturation);
  }

  /**
   * 根据饱和度和颜色差值调整RGB的值
   *
   * @param srcColor 原有颜色
   * @param saturation 饱和度
   * @param posRGB 正向RGB值
   * @param negRGB 负向RGB值
   * @returns 调整后的RGB色值
   */
  private static adjustColorWithSaturationAndOffset(
    srcColor: effectKit.Color,
    saturation: number,
    posRGB: effectKit.Color,
    negRGB: effectKit.Color
  ): effectKit.Color {
    const base = SolidColorAlgorithmUtils.calculateBaseColor(srcColor, saturation);

    const rn = base + srcColor.red * saturation;
    const gn = base + srcColor.green * saturation;
    const bn = base + srcColor.blue * saturation;

    const deltaRed = rn - srcColor.red;
    const resRed = deltaRed >= 0 ? srcColor.red + deltaRed * posRGB.red : srcColor.red + deltaRed * negRGB.red;

    const deltaGreen = gn - srcColor.green;
    const resGreen =
      deltaGreen >= 0 ? srcColor.green + deltaGreen * posRGB.green : srcColor.green + deltaGreen * negRGB.green;

    const deltaBlue = bn - srcColor.blue;
    const resBlue = deltaBlue >= 0 ? srcColor.blue + deltaBlue * posRGB.blue : srcColor.blue + deltaBlue * negRGB.blue;

    return { red: resRed * 255, green: resGreen * 255, blue: resBlue * 255, alpha: 0 };
  }

  /**
   * 最终的颜色校验，保证RGB值都在0~255以内
   *
   * @param adjustedColor 需要校验的颜色
   * @returns 调整至0~255以内的RGB颜色
   */
  private static finalColorCheck(adjustedColor: effectKit.Color): effectKit.Color {
    return {
      red: Math.floor(Math.min(255.0, Math.max(0.0, adjustedColor.red))),
      green: Math.floor(Math.min(255.0, Math.max(0.0, adjustedColor.green))),
      blue: Math.floor(Math.min(255.0, Math.max(0.0, adjustedColor.blue))),
      alpha: 0
    };
  }

  /**
   * 颜色调整算法，将颜色从RGB转换为LCH空间，调整后再转换回来
   *
   * @param pickColor 原始颜色
   * @param curMode 当前深浅色模式
   * @returns 调整后的颜色
   */
  public static adjustRGB(pickColor: effectKit.Color, curMode: number): number[] {
    // 1. 提取原始RGB值
    const rgb: number[] = [
      pickColor?.red ?? 0,
      pickColor?.green ?? 0,
      pickColor?.blue ?? 0
    ];

    if (curMode === undefined) {
      return rgb;
    }

    // 2. 转换颜色空间：RGB → Lab → LCH
    const lab = SolidColorAlgorithmUtils.rgb2lab(rgb);
    const lch = SolidColorAlgorithmUtils.lab2lch(lab);

    // 3. 在LCH空间进行颜色调整
    const adjustedLCH = SolidColorAlgorithmUtils.adjustLCH(lch, curMode);

    // 4. 转换回RGB颜色空间
    const adjustedLab = SolidColorAlgorithmUtils.lch2lab(adjustedLCH);
    const editedRGB = SolidColorAlgorithmUtils.lab2rgb(adjustedLab);

    return editedRGB;
  }

  /**
   * 在LCH颜色空间对颜色进行调整，规则由UX提供，根据深浅色模式调整算法存在差别
   *
   * @param lch LCH颜色空间的颜色，每一项分别表示明度、色度和色调
   * @param mode 深浅色模式
   * @returns 调整后的LCH颜色值
   */
  private static adjustLCH(lch: number[], mode: ConfigurationConstant.ColorMode): number[] {
    let light = lch[0];
    let chroma = lch[1];
    let hue = lch[2];
    if (mode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      light = Math.max(light, 35);
      if (chroma > 25) {
        if (lch[2] < 45 || lch[2] > 313) {
          light = Math.max(light, 65);
          chroma = Math.min(chroma, 35);
        } else {
          light = Math.max(light, 50);
          chroma = Math.min(chroma, 50);
        }
      }
      light = Math.min(light, 77)
    } else if (mode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      light = Math.min(light, 90);
      if (chroma > 25) {
        if (lch[2] < 45 || lch[2] > 313) {
          light = Math.max(light, 65);
          chroma = Math.min(chroma, 45);
        } else {
          light = Math.max(light, 75);
          chroma = Math.min(chroma, 55);
        }
      }
    } else {
      log.showWarn(`None of the Light or Dark Mode enabled, mode: ${mode}`);
    }
    return [light, chroma, hue];
  }

  private static rgb2lab(rgb: number[]): number[] {
    let rgbNormalized: number[] = [rgb[0] / 255, rgb[1] / 255, rgb[2] / 255];

    for (let i = 0; i < rgbNormalized.length; i++) {
      if (rgbNormalized[i] > 0.04045) {
        rgbNormalized[i] = Math.pow((rgbNormalized[i] + 0.055) / 1.055, 2.4);
      } else {
        rgbNormalized[i] = rgbNormalized[i] / 12.92;
      }
    }

    let xyzArray: number[] = [
      (rgbNormalized[0] * 0.4124564 + rgbNormalized[1] * 0.3575761 + rgbNormalized[2] * 0.1804375) / 0.95047,
      (rgbNormalized[0] * 0.2126729 + rgbNormalized[1] * 0.7151522 + rgbNormalized[2] * 0.0721750) / 1.00000,
      (rgbNormalized[0] * 0.0193339 + rgbNormalized[1] * 0.1191920 + rgbNormalized[2] * 0.9503041) / 1.08883
    ];

    for (let i = 0; i < xyzArray.length; i++) {
      if (xyzArray[i] > 0.008856) {
        xyzArray[i] = Math.pow(xyzArray[i], 1 / 3);
      } else {
        xyzArray[i] = xyzArray[i] * 7.787037 + 16 / 116;
      }
    }

    let labL = 116 * xyzArray[1] - 16;
    let labA = 500 * (xyzArray[0] - xyzArray[1]);
    let labB = 200 * (xyzArray[1] - xyzArray[2]);

    return [labL, labA, labB];
  }

  private static lab2rgb(lab: number[]): number[] {
    let xyzY = (lab[0] + 16) / 116;
    let xyzX = lab[1] / 500 + xyzY;
    let xyzZ = xyzY - lab[2] / 200;
    let xyzArray: number[] = [xyzX, xyzY, xyzZ];

    for (let i = 0; i < xyzArray.length; i++) {
      let temp = Math.pow(xyzArray[i], 3);
      if (temp > 0.008856) {
        xyzArray[i] = temp;
      } else {
        xyzArray[i] = (xyzArray[i] - 16 / 116) / 7.787037;
      }
    }

    xyzArray[0] *= 0.95047;
    xyzArray[1] *= 1.00000;
    xyzArray[2] *= 1.08883;

    let rgbArray: number[] = [
      xyzArray[0] * 3.2404542 - xyzArray[1] * 1.5371385 - xyzArray[2] * 0.4985314,
      -xyzArray[0] * 0.9692660 + xyzArray[1] * 1.8760108 + xyzArray[2] * 0.0415560,
      xyzArray[0] * 0.0556434 - xyzArray[1] * 0.2040259 + xyzArray[2] * 1.0572252
    ];

    for (let i = 0; i < rgbArray.length; i++) {
      if (rgbArray[i] > 0.0031308) {
        rgbArray[i] = 1.055 * Math.pow(rgbArray[i], 1 / 2.4) - 0.055;
      } else {
        rgbArray[i] = 12.92 * rgbArray[i];
      }
    }

    for (let i = 0; i < rgbArray.length; i++) {
      rgbArray[i] = (Math.max(0, Math.min(1, rgbArray[i])) * 255);
    }
    return rgbArray;
  }

  private static lab2lch(lab: number[]): number[] {
    let light = lab[0];
    let chroma = Math.sqrt(Math.pow(lab[1], 2) + Math.pow(lab[2], 2));
    let hue = Math.atan2(lab[2], lab[1]);
    if (hue > 0) {
      hue = (hue / Math.PI * 180);
    } else {
      hue = (360 - Math.abs(hue) / Math.PI * 180);
    }

    return [light, chroma, hue];
  }

  private static lch2lab(lch: number[]): number[] {
    let radian = lch[2] / 180 * Math.PI;
    let labL = lch[0];
    let labA = lch[1] * Math.cos(radian);
    let labB = lch[1] * Math.sin(radian);
    return [labL, labA, labB];
  }
}