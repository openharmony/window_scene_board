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

import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'ColorUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const WHITE = 'FFFFFF';
const BLACK = '000000';
const colorPattern = new RegExp('^#[0-9a-fA-F]{6}$|^#[0-9a-fA-F]{8}$');
// 检测字符串是否rgb
const rgbRegex = new RegExp('/^rgb\\(\\s*(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5])\\s*,' +
  '\\s*(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5])\\s*,\\s*(\\d{1,2}|1\\d\\d|2[0-4]\\d|25[0-5])\\s*\\)$/');

interface Color {
  alpha: string;
  red: number;
  green: number;
  blue: number;
}

/**
 * 处理颜色的工具类
 */
export class ColorUtil {
  /**
   * 解析传入的颜色字串，输出对应的反色
   *
   * @param color 传入的颜色，只允许#AARRGGBB或#RRGGBB
   * @param defaultValue 入参异常时返回的缺省颜色
   * @returns 背景色对应的互补色，透明度跟随传入的颜色
   */
  public static getContrastColor(color: string, defaultValue: string): string {
    if (!colorPattern.test(color)) {
      log.showInfo(`Invalid color:${color}`);
      return defaultValue;
    }

    let colorValue: Color = this.getColorValue(color);
    let result;
    if ((colorValue.red * 0.299 + colorValue.green * 0.587 + colorValue.blue * 0.114) > 186) {
      result = '#' + colorValue.alpha + BLACK;
    } else {
      result = '#' + colorValue.alpha + WHITE;
    }

    return result;
  }

  /**
   * 是否使用浅色
   *
   * @param color 传入的颜色，只允许#AARRGGBB或#RRGGBB
   * @returns 是否使用浅色
   */
  public static checkUseLightColor(color: string): boolean {
    if (!colorPattern.test(color)) {
      log.showInfo(`Invalid color:${color}`);
      return false;
    }

    let colorValue: Color = this.getColorValue(color);
    if ((colorValue.red * 0.299 + colorValue.green * 0.587 + colorValue.blue * 0.114) > 186) {
      return false;
    } else {
      return true;
    }
  }

  public static isRGBColor(str: string): boolean {
    return rgbRegex.test(str);
  }

  /**
   * 检测rgb颜色深浅
   * @param color
   * @returns
   */
  public static checkUseLightColorRGB(color: string): boolean {
    if (color === null) {
      return false;
    }
    const RgbValue = color.replace('rgb(', '').replace(')', '');
    const RgbValueArray: number[] = RgbValue.split(',').map((item) => parseInt(item));
    // 参考深浅色计算公式参数
    const degree = RgbValueArray[0] * 0.299 + RgbValueArray[1] * 0.587 + RgbValueArray[2] * 0.114;
    return degree > 186;
  }

  private static getColorValue(color: string): Color {
    let colorValue: Color;
    const colorStr = color.substring(1);
    if (colorStr.length === 6) {
      colorValue = {
        alpha: 'FF',
        red: parseInt(colorStr.substring(0, 2), 16),
        green: parseInt(colorStr.substring(2, 4), 16),
        blue: parseInt(colorStr.substring(4, 6), 16),
      };
    } else {
      colorValue = {
        alpha: colorStr.substring(0, 2),
        red: parseInt(colorStr.substring(2, 4), 16),
        green: parseInt(colorStr.substring(4, 6), 16),
        blue: parseInt(colorStr.substring(6, 8), 16),
      };
    }
    return colorValue;
  }
}