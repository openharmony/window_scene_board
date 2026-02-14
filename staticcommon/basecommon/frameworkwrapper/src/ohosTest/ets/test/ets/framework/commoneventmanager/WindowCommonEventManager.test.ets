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
import { hilog } from '@kit.PerformanceAnalysisKit';
import {
  windowCommonEventManager
} from '../../../../../../main/ets/commoneventmanager/WindowCommonEventManager'
import base from '@ohos.base';
import commonEventManager from '@ohos.commonEventManager';

const TAG = 'WindowCommonEventManagerTest';

export function WindowCommonEventManagerTest() {
  const MOVE_SUPER_LAUNCHER_APP_BACKGROUND_EVENT = 'move_super_launcher_app_background';
  const SUPER_LANUCHER_QUIT_APP_EVENT = 'super_launcher_quit_app';
  let subscriber: commonEventManager.CommonEventSubscriber;
  let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: [MOVE_SUPER_LAUNCHER_APP_BACKGROUND_EVENT, SUPER_LANUCHER_QUIT_APP_EVENT]
  };
  let callBack = (err: base.BusinessError, data: commonEventManager.CommonEventSubscriber) => {
    if (err) {
      hilog.info(0x01b00, TAG, 'callBack error' + err);
      return;
    }
    subscriber = data;
  };
  describe('WindowCommonEventManagerTest', () => {
    beforeAll((): void => {
      hilog.info(0x01b00, TAG, 'beforeAll WindowCommonEventManagerTest createSubscriber');
      commonEventManager.createSubscriber(subscribeInfo, callBack);
    });

    beforeEach((): void => {
    });

    afterEach((): void => {
    });

    afterAll((): void => {
    });

    it('WindowCommonEventManagerTest_reg_unreg', 0, (): void => {
      windowCommonEventManager.registerCommonEvent(null, null);
      windowCommonEventManager.unregisterCommonEvent(null, null);
      let localCallBack = (err: base.BusinessError, eventData: commonEventManager.CommonEventData): void => {
        hilog.info(0x01b00, TAG, 'localCallBack');
      };
      try {
        windowCommonEventManager.registerCommonEvent(subscriber, null);
      } catch (error) {
      }
      try {
        windowCommonEventManager.unregisterCommonEvent(subscriber, null);
      } catch (error) {
      }
      try {
        windowCommonEventManager.registerCommonEvent(subscriber, localCallBack);
      } catch (error) {
      }
      try {
        windowCommonEventManager.unregisterCommonEvent(subscriber, localCallBack);
      } catch (error) {
      }
      expect(true).assertTrue();
    })
  })
}