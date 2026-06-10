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
import { ColorType } from '../../editsheet/models/MainColor';
import { ClockConstants } from './ClockConstants';
import { slWallpaperMgr } from '@ohos/screenlockcommon';

const TAG = 'ClockColorUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class ClockColorUtil {

  /**
   * 基于当前壁纸亮度判定为亮色或暗色
   *
   * @param brightness 当前壁纸亮度，高于1时为暗色壁纸
   * @returns ColorType: LIGHT浅色, DARK深色
   */
  public static getColorType(brightness: number | undefined): ColorType {
    log.showInfo(TAG, `Update clock color type with brightness: ${brightness}`);

    if (!brightness || brightness < 0) {
      return slWallpaperMgr.getSlWallpaperState().isLightWallpaper ? ColorType.DARK : ColorType.LIGHT;
    }
    return brightness >= ClockConstants.BRIGHT_NESS_DEFAULT ? ColorType.LIGHT : ColorType.DARK;
  }

}