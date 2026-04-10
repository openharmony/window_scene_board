/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import notificationManager from '@ohos.notificationManager';
import { BusinessError } from '@ohos.base';
import dataPreferences from '@ohos.data.preferences';
import Intl from '@ohos.intl';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { PcHiSysEventMgr, TIP_RESULT } from '../../../common/manager/PcHiSysEventMgr';

const TAG: string = 'PinExpiryNotificationController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const SCREEN_LOCK_PIN_ONE_DAY: number = 1 * 24 * 60 * 60 * 1000;
const SCREEN_LOCK_PIN_VALIDITY_PERIOD: number = 15 * SCREEN_LOCK_PIN_ONE_DAY;
const PIN_EXPIRY_NTF_ID: number = 1124;
const PIN_NTF_SEND_TIME: string = 'PIN_NTF_SEND_TIME';

export class PinExpiryNotificationController {
  private static instance?: PinExpiryNotificationController = undefined;

  public static getInstance(): PinExpiryNotificationController {
    if (!PinExpiryNotificationController.instance) {
      PinExpiryNotificationController.instance = new PinExpiryNotificationController();
    }
    return PinExpiryNotificationController.instance;
  }

  public publishNotification(pinValidityPeriod: number): boolean {
    try {
      let preferences = dataPreferences.getPreferencesSync(GlobalContext.getContext(), { name: TAG });
      let pinNtfSendTime: number = preferences.getSync(PIN_NTF_SEND_TIME, 0) as number;
      let isTwentyFourHours: boolean = new Date().getTime() - pinNtfSendTime < SCREEN_LOCK_PIN_ONE_DAY;
      let isFifteenDays: boolean = pinValidityPeriod > 0 && pinValidityPeriod <= SCREEN_LOCK_PIN_VALIDITY_PERIOD;

      if (!isFifteenDays || isTwentyFourHours) {
        return false;
      }
    } catch (err) {
      log.showError(` getPreferencesSync error, BusinessError code is ${(err as BusinessError).code}`);
      return false;
    }
    let title: string = '';
    try {
      title = GlobalContext.getContext().resourceManager.getStringSync($r('app.string.pwd_expire_tips_title'));
    } catch (err) {
      log.showError(` getStringSync error, BusinessError code is ${(err as BusinessError).code}`);
      return false;
    }
    let text: string = this.setPwdExpiryNoticeText(pinValidityPeriod);
    let notificationRequest: notificationManager.NotificationRequest = {
      id: PIN_EXPIRY_NTF_ID,
      notificationSlotType: notificationManager.SlotType.SOCIAL_COMMUNICATION,
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: title,
          text: text
        }
      }
    };
    try {
      notificationManager.publish(notificationRequest, (err: BusinessError) => {
        if (err) {
          PcHiSysEventMgr.userPinTimeTip(TIP_RESULT.USER_PIN_TIP_PUBLISH_TIMEOUT);
          log.showError(`PinExpiryNotificationController publishNotification error: ${err}`);
          return;
        }
        PcHiSysEventMgr.userPinTimeTip(TIP_RESULT.USER_PIN_TIP_PUBLISH_SUCCESS);
        log.showInfo(`PinExpiryNotificationController publishNotification Succeeded.`);
      });
    } catch (err) {
      log.showError(
        `PinExpiryNotificationController publishNotification BusinessError code is ${(err as BusinessError).code}`);
      return false;
    }
    return true;
  }

  private setPwdExpiryNoticeText(days: number): string {
    let today: Date = new Date();
    let preferences: dataPreferences.Preferences | null = null;
    try {
      preferences = dataPreferences.getPreferencesSync(GlobalContext.getContext(), { name: TAG });
      preferences.putSync(PIN_NTF_SEND_TIME, today.getTime());
      preferences.flush(() => {
      });
    } catch (err) {
      log.showError(` getPreferencesSync error, BusinessError code is ${(err as BusinessError).code}`);
    }
    let date: Date = new Date(today.setTime(today.getTime() + days));
    let dateFormat: Intl.DateTimeFormat = new Intl.DateTimeFormat();
    let content: string = '';
    try {
      content = GlobalContext.getContext().resourceManager.getStringSync($r('app.string.pwd_expire_tips_text'));
    } catch (err) {
      log.showError(` getStringSync error, BusinessError code is ${(err as BusinessError).code}`);
    }
    return content.replace('%s', `${dateFormat.format(date)}`);
  }
}