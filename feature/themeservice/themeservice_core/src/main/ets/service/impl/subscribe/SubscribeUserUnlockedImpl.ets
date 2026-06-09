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
import { ContextUtil, ObjectUtils, TsLog } from '@ohos/themeservicebase';
import { TsCommonEventSubscribe } from '../../api/TsCommonEventSubscribe';
import { themeSearchService } from '../ThemeSearchServiceImpl';

const TAG: string = 'SubscribeUserUnlockedImpl';

/**
 * 冷启动开机首次解锁
 */
export class SubscribeUserUnlockedImpl implements TsCommonEventSubscribe {
  getSubscribeInfo(userId?: number | undefined): commonEventManager.CommonEventSubscribeInfo {
    const subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [commonEventManager.Support.COMMON_EVENT_USER_UNLOCKED],
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
        TsLog.info(TAG, `Receive event = ${eventData.event}`);
        themeSearchService.get().init(true);
      }
    return callback;
  }
}