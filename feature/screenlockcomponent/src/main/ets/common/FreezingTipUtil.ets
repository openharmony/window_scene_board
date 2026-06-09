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
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import Constants from './Constants';

const TAG = 'FreezingTipUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export default class FreezingTipUtil {
  public static async getFreezingTimeStr(freezingMillisecond: number): Promise<string> {
    log.showInfo('getFreezingTimeStr start');
    let minute = Math.floor(freezingMillisecond / (Constants.SECOND_TO_MINUTE * Constants.MILLISECOND_TO_SECOND));
    log.showInfo(`getFreezingTimeStr minute:${minute}`);
    let second = Math.ceil((freezingMillisecond % (Constants.SECOND_TO_MINUTE * Constants.MILLISECOND_TO_SECOND)) /
      Constants.MILLISECOND_TO_SECOND);
    log.showInfo(`getFreezingTimeStr second:${second}`);

    let timeName = '';
    if (minute !== 0) {
      let strTipMinute: string = await ResUtils.getInnerPlural($r('app.plural.psd_incorrect_will_locked2'), minute);
      timeName += strTipMinute;
    }
    if (second !== 0) {
      if (!!timeName) {
        timeName += ' ';
      }
      let strTipSecond: string = await ResUtils.getInnerPlural($r('app.plural.psd_incorrect_will_locked3'), second);
      timeName += strTipSecond;
    }
    log.showInfo(`getFreezingTimeStr end ${timeName}`);
    return timeName;
  }
}