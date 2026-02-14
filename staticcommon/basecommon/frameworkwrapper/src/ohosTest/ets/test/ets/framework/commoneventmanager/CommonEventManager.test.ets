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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'

import commonEvent from '@ohos.commonEvent';
import commonEventManager from '@ohos.commonEventManager';
import {
  getCommonEventManager,
  POLICY
} from '../../../../../../main/ets/commoneventmanager/CommonEventManager'

export function CommonEventManagerTest() {
  let TIME_SUBSCRIBE_INFO: commonEventManager.CommonEventSubscribeInfo = {
    events: [
      commonEvent.Support.COMMON_EVENT_TIME_CHANGED, // 时间被设置
      commonEvent.Support.COMMON_EVENT_TIMEZONE_CHANGED, // 时区变化
      commonEvent.Support.COMMON_EVENT_TIME_TICK,// 当前时间变化
    ],
  };
  let manager = getCommonEventManager(
    'CommonEventManagerTest',
    TIME_SUBSCRIBE_INFO,
    () => onEventCallBack(),
    (isSubscribe) => isSubscribe
  );

  describe('CommonEventManagerTest', () => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterEach((): void => {
    });

    afterAll((): void => {
    });

    it('CommonEventManagerTest_subscriberCommonEvent', 0, async (done: Function) => {
      await manager.subscriberCommonEvent();
      manager.applyPolicy([POLICY.SCREEN_POLICY]);
      manager.applyPolicy([POLICY.SCREEN_POLICY]);
      expect(true).assertTrue();
      done();
    })

    it('CommonEventManagerTest_unSubscriberCommonEvent', 0, (): void => {
      manager.unSubscriberCommonEvent();
      manager.release();
      manager.applyPolicy([POLICY.SCREEN_POLICY]);
      manager.release();
      expect(true).assertTrue();
    })
  })
}

function onEventCallBack() {
}
