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
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { describe, expect, it, TestType } from '@ohos/hypium';
import { TsLog } from '@ohos/themeservicebase/Index';
import { CommonEvent } from '../../../../../main/ets/util/CommonEvent';

const TAG: string = 'CommonEvent.test';

let subscriber: commonEventManager.CommonEventSubscriber;

export default function CommonEventTest() {
  describe('CommonEventTest', () => {
    it('test001_recv_success', TestType.FUNCTION, async () => {
      TsLog.info(TAG, `test001_recv_success...`);
      let result: boolean = await getSubscribeResult();
      expect(result).assertTrue();
      TsLog.info(TAG, `test001_recv_success.`);
    })
  })
}

function getSubscribeResult(): Promise<boolean> {
  return new Promise<boolean>(async (resolve) => {
    const event: string = 'com.ohos.ThemeService.OHOSTest';
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [event],
      publisherPermission: `ohos.permission.ACTIVATE_THEME_PACKAGE`
    };
    subscriber = await commonEventManager.createSubscriber(subscribeInfo);
    TsLog.debug(TAG, `subscriber:${JSON.stringify(subscriber)}`);
    commonEventManager.subscribe(subscriber, (err: BusinessError, eventData: commonEventManager.CommonEventData) => {
      resolve(true);
      TsLog.info(TAG, `recv eventData success ,err:${err}  eventData:${JSON.stringify(eventData)}`);
      commonEventManager.unsubscribe(subscriber);
    });
    CommonEvent.publish(event).finally(() => {
      setTimeout(() => {
        resolve(false);
        TsLog.warning(TAG, `recv eventData timeout`);
        commonEventManager.unsubscribe(subscriber);
      }, 10 * 1000);
    });
  });
}
