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
import { ResUtils } from '@ohos/windowscene';

const TAG = 'PromptUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class PromptUtil {
  public static getWillLockTxt(freezingTime: number, remainTimes: number): string {
    let freezingTimeNm: string = PromptUtil.getFreezingTimeNm(freezingTime);
    let lockTxt = ResUtils.getInnerPluralByResource($r('app.plural.psd_incorrect_will_locked1'), remainTimes);
    let promptText = $r('app.string.psd_incorrect_will_locked', lockTxt, freezingTimeNm);
    log.showInfo('changePrompt end');
    return ResUtils.getInnerString(promptText);
  }

  public static getFreezingTimeNm(freezingMillisecond: number): string {
    let minute = Math.floor(freezingMillisecond / (60 * 1000));
    let second = Math.round((freezingMillisecond % (60 * 1000)) / 1000);
    log.showInfo(`getFreezingTimeNm start, getFreezingTimeNm minute:${minute}, getFreezingTimeNm second:${second}`);
    let timeName = '';
    if (minute !== 0) {
      let strTipMinute: string = ResUtils.getInnerPluralByResource($r('app.plural.psd_incorrect_will_locked2'), minute);
      timeName += strTipMinute;
    }
    if (second !== 0) {
      if (!!timeName) {
        timeName += ' ';
      }
      let strTipSecond: string = ResUtils.getInnerPluralByResource($r('app.plural.psd_incorrect_will_locked3'), second);
      timeName += strTipSecond;
    }
    log.showInfo(`getFreezingTimeNm end ${timeName}`);
    return timeName;
  }
}