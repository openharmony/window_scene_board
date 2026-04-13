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

import display from '@ohos.display';
import { ArrayUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'ScreenLockCutOutUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 锁屏挖孔适配公共方法
 *
 * @since 2023-1-5
 */
export class ScreenLockCutOutUtil {
  public static buttonMaxLength: number = 76;

  public static async getMarginToAdaptCut(adaptCutMargin: AdaptCutMargin): Promise<void> {
    if (CommonUtils.isInvalid(adaptCutMargin)) {
      log.showWarn('param adaptCutMargin is invalid');
      return;
    }
    try {
      let localDisplay: display.Display | undefined = display.getDefaultDisplaySync();
      let cutInfo: display.CutoutInfo | undefined = await localDisplay?.getCutoutInfo();
      let boundRects: Array<display.Rect> | undefined = cutInfo?.boundingRects;

      if (ArrayUtils.isEmpty(boundRects)) { // 获取不到挖孔信息，使用默认值
        log.showWarn('The boundRects is empty.');
        ScreenLockCutOutUtil.refreshMarginToDefault(adaptCutMargin);
      } else if (ScreenLockCutOutUtil.isTrackScreen(boundRects, localDisplay)) { // 跑道屏，如P40Pro, P30, Mate40Pro
        adaptCutMargin.marginTop = px2vp(boundRects[0].top);
        adaptCutMargin.marginLeft = px2vp(boundRects[0].left + boundRects[0].width) + 16;
        adaptCutMargin.marginRight = 24;
      } else if (ScreenLockCutOutUtil.isCameraInUpperLeftCorner(boundRects, localDisplay)) { // 挖孔在左上角
        adaptCutMargin.marginLeft = px2vp(boundRects[0].left + boundRects[0].width) + 16;
        adaptCutMargin.marginTop = DeviceHelper.isPadOr2in1PcType() ? 24 : 16;
        adaptCutMargin.marginRight = 24;
      } else if (ScreenLockCutOutUtil.isCameraInUpperRightCorner(boundRects, localDisplay)) { // 挖孔在右上角
        adaptCutMargin.marginRight = px2vp(localDisplay.width - boundRects[0].left) + 16;
        adaptCutMargin.marginTop = DeviceHelper.isPadOr2in1PcType() ? 24 : 16;
        adaptCutMargin.marginLeft = 24;
      } else {
        ScreenLockCutOutUtil.refreshMarginToDefault(adaptCutMargin);
      }
      if (ScreenLockCutOutUtil.isMiddleScreen(boundRects, localDisplay)) {
        ScreenLockCutOutUtil.buttonMaxLength = px2vp(boundRects[0].left) - 24 - 8;
      }
    } catch (err) {
      log.showInfo(`getCutoutInfo failed as err: ${err}`);
    }
  }

  private static refreshMarginToDefault(adaptCutMargin: AdaptCutMargin): void {
    adaptCutMargin.marginRight = 24;
    adaptCutMargin.marginTop = DeviceHelper.isPadOr2in1PcType() ? 24 : 16;
    adaptCutMargin.marginLeft = 24;
  }

  private static isTrackScreen(boundRects: Array<display.Rect>, display: display.Display): boolean {
    return boundRects[0].top !== 0 && boundRects[0].height !== 0 &&
      boundRects[0].left < display.width / 4 && boundRects[0].width / boundRects[0].height >= 2;
  }

  private static isMiddleScreen(boundRects: Array<display.Rect>, display: display.Display): boolean {
    return boundRects[0].top !== 0 && boundRects[0].height !== 0 &&
      boundRects[0].left + boundRects[0].width > display.width / 2 && boundRects[0].left < display.width / 2 &&
      boundRects[0].top < display.height / 4;
  }

  public static isCameraInUpperLeftCorner(boundRects: Array<display.Rect>, display: display.Display): boolean {
    return boundRects[0].left < display.width / 4 && boundRects[0].top < display.height / 4;
  }

  public static isCameraInUpperRightCorner(boundRects: Array<display.Rect>, display: display.Display): boolean {
    return boundRects[0].top !== 0 && boundRects[0].left > display.width * 3 / 4 &&
      boundRects[0].top < display.height / 4;
  }

  public static isCameraInUpper(boundRects: Array<display.Rect>, display: display.Display): boolean {
    return boundRects[0].top < display.height / 4;
  }
}

export interface AdaptCutMargin {
  marginTop: number;
  marginLeft: number;
  marginRight: number;
}