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

import { Log } from '@ohos/basicutils/src/main/ets/utils/Log';
import WallpaperConstants from '@ohos/commonconstants/src/main/ets/constants/WallpaperConstants';

export class GrayscaleUtil {
  /**
   * 计算颜色的灰阶值
   *
   * @param red  红
   * @param green 绿
   * @param blue 蓝
   * @param alpha 透明度
   * @returns 颜色的灰阶值
   */
  public static calGrayscale(red: number, green: number, blue: number, alpha: number): string {
    Log.showDebug('WallpaperColorManager', `red:${red},green:${green},blue:${blue}`);
    let y: number = (0.299 * red + 0.587 * green + 0.114 * blue);
    let u: number = (-0.147 * red - 0.289 * green + 0.436 * blue);
    let v: number = (0.615 * red - 0.515 * green - 0.100 * blue);
    let adjustY: number = y;
    if (y > 127.5) {
      adjustY = 255.0 - y;
    }
    let q: number = -adjustY / 106.5 + 0.262;
    let s1: number = -(q / 2.0);
    let s2: number = Math.sqrt(Math.pow(s1, 2) + 0.02);
    let t: number = GrayscaleUtil.pow((s1 + s2), 1.0 / 3.0) + GrayscaleUtil.pow((s1 - s2), 1.0 / 3.0) + 0.291;
    y = (y < 127.5)
      ? (y + 38 * Math.pow((1 - t), 3))
      : (y - 26 * Math.pow((1 - t), 3));
    let r: number = Math.round(y + 1.14 * v);
    let g: number = Math.round(y - 0.39 * u - 0.58 * v);
    let b: number = Math.round(y + 2.03 * u);
    Log.showDebug('WallpaperColorManager', `r:${r},g:${g},b:${b}`);
    return GrayscaleUtil.convertRGBA2ResourceColor(r, g, b, alpha);
  }

  private static convertRGBA2ResourceColor(red: number, green: number, blue: number, alpha: number): string {
    let r: string = GrayscaleUtil.dec2Hex(red, WallpaperConstants.NUMBER_2, WallpaperConstants.PREFIX_0);
    let g: string = GrayscaleUtil.dec2Hex(green, WallpaperConstants.NUMBER_2, WallpaperConstants.PREFIX_0);
    let b: string = GrayscaleUtil.dec2Hex(blue, WallpaperConstants.NUMBER_2, WallpaperConstants.PREFIX_0);
    let a: string = GrayscaleUtil.dec2Hex(alpha, WallpaperConstants.NUMBER_2, WallpaperConstants.PREFIX_0);
    return `${WallpaperConstants.COLOR_PREFIX}${a}${r}${g}${b}`;
  }

  private static dec2Hex(decNumber: number, bit: number, padString: string): string {
    if (decNumber > WallpaperConstants.NUMBER_255) {
      decNumber = WallpaperConstants.NUMBER_255;
    }
    if (decNumber < 0) {
      decNumber = 0;
    }
    return decNumber.toString(WallpaperConstants.NUMBER_16).padStart(bit, padString);
  }

  private static pow(x: number, y: number): number {
    return (x < 0) ? -Math.pow(-x, y) : Math.pow(x, y);
  }
}