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

import { TsCommonEventSubscribe } from '../../api/TsCommonEventSubscribe';
import base, { AsyncCallback } from '@ohos.base';
import { commonEventManager } from '@kit.BasicServicesKit';
import { TsLog } from '@ohos/themeservicebase/Index';
import { themeTrialService } from '../ThemeTrialServiceImpl';

/**
 * 云端模式切换事件
 */
const COMMON_EVENT_CLOUD_CHANGE: string = 'com.ohos.CloudChange';
const CLOUD_CHANGE_TYPE_ENTER: number = 1;
const CLOUD_CHANGE_TYPE_EXIT: number = 0;
const CLOUD_PARAM_KEY_TYPE: string = 'type';

const TAG: string = 'SubscribeCloudChangeImpl';

/**
 * 监听云端模式退切换事件
 */
export class SubscribeCloudChangeImpl implements TsCommonEventSubscribe {
  getSubscribeInfo(userId?: number): commonEventManager.CommonEventSubscribeInfo {
    const subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [COMMON_EVENT_CLOUD_CHANGE],
      userId: userId,
    };
    return subscribeInfo;
  }

  getCallback(): AsyncCallback<commonEventManager.CommonEventData> {
    const callback: AsyncCallback<commonEventManager.CommonEventData> =
      (err: base.BusinessError, eventData: commonEventManager.CommonEventData) => {
        if (err || eventData === undefined) {
          TsLog.error(TAG, `Failed to receive commonEvent ${eventData?.event}`, err);
          return;
        }
        if (eventData.event !== COMMON_EVENT_CLOUD_CHANGE) {
          TsLog.info(TAG, `Unknown event = ${eventData.event}`);
          return;
        }
        if (!eventData.parameters) {
          TsLog.info(TAG, `Unknown parameters`);
          return;
        }
        TsLog.info(TAG, `Receive event = ${eventData.event}`);
        if (eventData.parameters[CLOUD_PARAM_KEY_TYPE] === CLOUD_CHANGE_TYPE_ENTER) { //进入云端
          themeTrialService().stopTimer();
        } else if (eventData.parameters[CLOUD_PARAM_KEY_TYPE] === CLOUD_CHANGE_TYPE_EXIT) { //退出云端
          themeTrialService().restartTimer();
        } else {
          TsLog.info(TAG, `Unknown parameters type: ${eventData.parameters[CLOUD_PARAM_KEY_TYPE]}`);
          return;
        }
      }
    return callback;
  }
}
