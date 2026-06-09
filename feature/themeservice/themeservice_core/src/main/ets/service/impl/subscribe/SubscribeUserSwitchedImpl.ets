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

import { commonEventManager } from '@kit.BasicServicesKit';
import base, { AsyncCallback } from '@ohos.base';
import { JsonUtils, ObjectUtils, TsLog } from '@ohos/themeservicebase/Index';
import { TsCommonEventSubscribe } from '../../api/TsCommonEventSubscribe';
import { themeTrialService } from '../ThemeTrialServiceImpl';
import { tsTimer } from '../TsTimerImpl';

const TAG: string = 'SubscribeUserSwitchedImpl';

/**
 * 系统账号前后台切换监听
 * 主空间/隐私空间切换
 */
export class SubscribeUserSwitchedImpl implements TsCommonEventSubscribe {
  private userId: Nullable<number>;

  getSubscribeInfo(userId?: number): commonEventManager.CommonEventSubscribeInfo {
    this.userId = userId;
    const subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [
        commonEventManager.Support.COMMON_EVENT_USER_FOREGROUND, // 切换到前台
        commonEventManager.Support.COMMON_EVENT_USER_BACKGROUND// 切换到后台
      ],
      userId: userId,
    };
    return subscribeInfo;
  }

  getCallback(): AsyncCallback<commonEventManager.CommonEventData> {
    const callback: AsyncCallback<commonEventManager.CommonEventData> =
      (err: base.BusinessError, eventData: commonEventManager.CommonEventData) => {
        if (err || eventData === undefined || ObjectUtils.isNull(eventData)) {
          TsLog.error(TAG, `Failed to receive commonEvent ${eventData?.event}`, err);
          return;
        }
        if (!this.userId || !eventData.code || eventData.code !== this.userId) {
          return;
        }
        TsLog.info(TAG, `Receive event = ${JsonUtils.stringify(eventData)}`);
        switch (eventData.event) {
          case commonEventManager.Support.COMMON_EVENT_USER_FOREGROUND: // 切换到前台
            TsLog.info(TAG, `Switch to the foreground`);
            themeTrialService().onInit();
            break;
          case commonEventManager.Support.COMMON_EVENT_USER_BACKGROUND: // 切换到后台
            TsLog.info(TAG, `Switch to background`);
            tsTimer.get().cleanTimer();
            break;
          default:
            TsLog.info(TAG, `Unknown event = ${eventData.event}`);
            break;
        }
      }
    return callback;
  }
}