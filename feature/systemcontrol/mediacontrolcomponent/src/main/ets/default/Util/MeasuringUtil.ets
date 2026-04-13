/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { globalStorage } from '../Util/GlobalStorage';
import Constants from '../Util/Constants';

const TAG: string = 'MeasuringUtil_debug';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

export default class MeasuringUtil {

  /**
   * get height number for mediacards showing
   */
  static getMediaCardHeight(listSize: number, isShowDev: boolean): number {

    // number for component size, temp set here and will change to constant in future
    let progressBarHeight: number = DeviceHelper.isPC() ? 0 : 40;
    return ((12 + 24 + 12 + 264 + 16 + 40 + 40 + 40 + 40 + 12) +
      (isShowDev ? 0 : (73 * (((listSize > Constants.SESSION_LIST_SIZE_LIMIT_NUM) ?
      Constants.SESSION_LIST_SIZE_LIMIT_NUM : listSize) - 1))));
  }

  static getDeviceCardContentHeight(listSize: number): number {
    // 设备高度 + 设备间距
    return listSize * Constants.PC_DEVICE_ITEM_HEIGHT + (listSize - 1) * Constants.PC_DEVICE_ITEM_GUTTER;
  }

  /**
   * get height number for both mediaCards and deviceCards
   */
  static getTotalHeight(sessionListSize: number, deviceListSize: number, isShowDev: boolean): number {
    log.showInfo(' get total height start: ' + sessionListSize + '|' + deviceListSize + '|' + isShowDev);
    let mediaCardHeight: number = isShowDev ? 240 : 500;
    let gapSize: number = 12;
    let deviceCardHeight: number = 56 * deviceListSize + 8 + 28;
    log.showInfo(' get total height : ' + mediaCardHeight + '|' + gapSize + '|' + deviceCardHeight);
    return mediaCardHeight + (isShowDev ? (gapSize + deviceCardHeight) : 0);
  }

  static getHeight(fontsize: number, oldHeight: number, maxFontScale: number, fontScale:number,
    isProgress: boolean = false, isHour: boolean = false): number {
    if (fontScale <= 1) {
      return oldHeight;
    }
    let height: number = oldHeight;
    if (fontScale >= maxFontScale) {
      fontScale = maxFontScale;
    } else if (fontScale <= 1) {
      fontScale = 1;
    }
    if (isProgress) {
      if (isHour) {
        return (fontScale === 1.15) ? 48 : (fontScale === 1.3) ? 54 : 60;
      }
      return (fontScale === 1.15) ? 32 : (fontScale === 1.3) ? 36 : 40;
    }
    if (fontScale >= 1.75) {
      if (fontsize === 16) {
        return fontScale === 1.75 ? (oldHeight + 16) : (oldHeight + 22);
      } else if (fontsize === 14) {
        return fontScale === 1.75 ? (oldHeight + 13) : (oldHeight + 19);
      } else if (fontsize === 18) {
        return fontScale === 1.75 ? 46 : 52;
      }
    }
    oldHeight = fontScale === 1 ? oldHeight : (oldHeight + (fontsize === 18 ? fontScale * 2 : fontScale))
    height = Math.ceil(oldHeight + fontsize * (fontScale - 1));
    return height;
  }

  static getHeightMore(fontsize: number, oldHeight: number, maxFontScale: number, fontScale:number,
    count: number): number {
    if (fontScale <= 1) {
      return oldHeight;
    }
    let height: number = oldHeight;
    for (let i = 0; i < count; i++) {
      height = MeasuringUtil.getHeight(fontsize, oldHeight, maxFontScale, fontScale)
    }
    return height;
  }

  static getFontSize(fontsize: number | Resource, maxFontScale: number, fontScale:number):number | string {
    let realFontSize: number;
    if (typeof (fontsize) === 'number') {
      realFontSize = fontsize;
    } else {
      realFontSize = ResUtils.getConvertNumber(fontsize);
    }
    if (fontScale <= maxFontScale) {
      return realFontSize;
    } else {
      return realFontSize * maxFontScale + 'vp'
    }
  }
}