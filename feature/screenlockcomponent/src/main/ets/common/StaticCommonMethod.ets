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

import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG: string = 'Common-StaticCommonMethod';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export interface ColorAndAlpha {
  alpha: number;
  color: string;
}

export default class StaticCommonMethod {
  static splitTransparencyColor(colorWithAlpha: string): ColorAndAlpha {
    if (!/^#([0-9A-Fa-f]{8})$/.test(colorWithAlpha)) {
      log.showWarn('Invalid color format. Expected format: #RRGGBBAA');
      return {
        alpha: 0,
        color: colorWithAlpha,
      };
    }

    // 提取透明度部分（最后两位）和实际颜色部分（前六位）
    const color = `#${colorWithAlpha.substring(3)}`;
    let alpha: number = 0;
    try {
      alpha = parseInt(colorWithAlpha.substring(1, 3), 16) / 255;
    } catch (err) {
      log.showWarn('splitTransparencyColor parseInt fail');
    }
    return {
      alpha: alpha,
      color: color,
    };
  }

  static getDefColOfGadget(isLightWallpaper: boolean = false): ColorAndAlpha {
    const finalColor = isLightWallpaper ? '#3C3C3C' : '#FFFFFF';
    const finalAlpha = 0.85;
    return {
      alpha: finalAlpha,
      color: finalColor,
    }
  }
}