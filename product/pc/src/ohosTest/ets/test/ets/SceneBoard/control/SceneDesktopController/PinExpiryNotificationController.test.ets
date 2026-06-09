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

import { hilog } from '@kit.PerformanceAnalysisKit';
import {
  describe, beforeEach,
  afterEach, it,
  expect, MockKit,
} from '@ohos/hypium';

import {
  PinExpiryNotificationController
} from '@ohos/pcbase/src/main/ets/SceneBoard/control/SceneDesktopController/PinExpiryNotificationController';


const TAG: string = 'PinExpiryNotificationControllerTest';

export default function PinExpiryNotificationControllerTest() {
  describe('PinExpiryNotificationControllerTest', () => {
    let controller: PinExpiryNotificationController;
    let mocker: MockKit;

    beforeEach(() => {
      controller = new PinExpiryNotificationController();
      mocker = new MockKit();
    });

    afterEach(() => {
    });

    it('theInstanceOnSubsequent', 0, () => {
      const instance1: PinExpiryNotificationController = PinExpiryNotificationController.getInstance();
      const instance2: PinExpiryNotificationController = PinExpiryNotificationController.getInstance();
      expect(instance1).assertDeepEquals(instance2);
    });

    it('publishNotificationTest1', 0, () => {
      const result: boolean = controller.publishNotification(0);
      expect(result).assertFalse();
    });

    it('publishNotificationTest2', 0, () => {
      const result: boolean = controller.publishNotification(10);
      expect(result).assertFalse();
    });

    it('testSetPwdExpiryNoticeText', 0, (): void => {
      try {
        (controller as object)['setPwdExpiryNoticeText'](0);
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'setPwdExpiryNoticeText error' + e);
      }
    });
  });

}