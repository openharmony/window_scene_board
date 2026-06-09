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

import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { AccessibilityUtil } from '../../accessibility/AccessibilityUtil';
import { LiveTimerData } from '../data/extend/LiveTimerData';
import { LiveViewData } from '../data/LiveViewData';
import { LiveViewCommonConstants, TimeItem } from './LiveConstants';

const TAG: string = 'LiveAccessibilityUtil';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class LiveAccessibilityUtil {
  /**
   * 判断当前是否在无障碍模式下
   */
  public static isAccessibilityMode(): boolean {
    return AccessibilityUtil.isAccessibilityMode();
  }

  /**
   * 获取计时器屏幕朗读文本
   */
  public static getTImeAccessibilityText(timeData?: LiveTimerData): string {
    if (!LiveAccessibilityUtil.isAccessibilityMode()) {
      return '';
    }

    let hour = 0;
    let minute = 0;
    let second = 0;

    if (timeData?.initialTime) {
      let dateFormat = new Date();
      dateFormat.setHours(0, 0, 0, 0);
      let secondCount = 0;
      if (timeData.isCountDown) {
        secondCount = Math.ceil(timeData.initialTime / LiveViewCommonConstants.ONE_SECOND_TO_MILLISECOND);
      } else {
        secondCount = Math.floor(timeData.initialTime / LiveViewCommonConstants.ONE_SECOND_TO_MILLISECOND);
      }
      dateFormat.setSeconds(secondCount);
      minute = dateFormat.getMinutes();
      second = dateFormat.getSeconds();
      if (secondCount < LiveViewCommonConstants.MAX_TIME_TEXT) {
        hour = dateFormat.getHours() + TimeItem.HOUR_ITEM * Math.floor(secondCount / LiveViewCommonConstants.MAX_DAY_TIME);
      }
    }

    let result = '';
    try {
      let minuteStr = ResUtils.getInnerPluralByResource($r('app.plural.cc_accessibility_str_timer_str_minute'), minute);
      let secondStr = ResUtils.getInnerPluralByResource($r('app.plural.cc_accessibility_str_timer_str_second'), second);
      if (hour > 0) {
        let hourStr = ResUtils.getInnerPluralByResource($r('app.plural.cc_accessibility_str_timer_str_hour'), hour);
        result = ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_timer_str_hour_to_minute_to_second'),
          hourStr, minuteStr, secondStr);
      } else {
        result = ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_timer_str_minute_to_second'),
          minuteStr, secondStr);
      }
    } catch (e) {
      log.error('getTImeAccessibilityText error:', e);
    }

    return result;
  }

  public static getAccessibilityAppName(liveViewData: LiveViewData): string {
    let name = '';
    if (liveViewData?.customerAccessibilityText) {
      name = liveViewData.customerAccessibilityText;
    } else if (liveViewData?.appName?.value) {
      name = liveViewData.appName.value;
    }
    return name;
  }
}
