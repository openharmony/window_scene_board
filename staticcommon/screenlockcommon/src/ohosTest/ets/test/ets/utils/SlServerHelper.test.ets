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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { LockEventType, LockOperateResult, SlServerHelper } from '../../../../../main/ets/TsIndex'
import { AuthType } from '../../../../../main/ets/utils/AccountHelper'

export default function SlServerHelperTest() {
  describe('SlServerHelperTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('SlServerHelperTest_sendScreenLockEvent', 0, () => {
      let slServer = SlServerHelper.getInstance();
      (slServer as object)['_currentUserActive'] = false;
      slServer.sendScreenLockEvent(LockEventType.LOCK_SCREEN_RESULT, LockOperateResult.Success)
      expect(slServer).not().assertNull();
    })

    it('SlServerHelperTest_setScreenLockAuthState', 0, () => {
      let slServer = SlServerHelper.getInstance();
      slServer.setScreenLockAuthState(AuthType.PIN, 10, true);
      slServer.setScreenLockAuthState(AuthType.PIN, 10, false);
      slServer.setScreenLockAuthState(AuthType.FINGERPRINT, 10, true);
      slServer.setScreenLockAuthState(AuthType.FINGERPRINT, 10, false);
      slServer.setScreenLockAuthState(AuthType.FACE, 10, true);
      slServer.setScreenLockAuthState(AuthType.FACE, 10, false);
      slServer.setScreenLockAuthState(AuthType.DOMAIN, 10, false);
      expect(slServer).not().assertNull();
    })

    it('SlServerHelperTest_getSwitchAccountAuthState', 0, () => {
      let slServer = SlServerHelper.getInstance();
      slServer.getSwitchAccountAuthState(10);
      expect(slServer).not().assertNull();
    })

    it('SlServerHelperTest_handleSlException', 0, () => {
      let slServer = SlServerHelper.getInstance();
      (slServer as object)['_restartTimeoutId'] = 10;
      (slServer as object)['handleSlException']();
      expect(slServer).not().assertNull();
    })

    it('SlServerHelperTest_handleSlException_02', 0, () => {
      let slServer = SlServerHelper.getInstance();
      (slServer as object)['_restartTimeoutId'] = 0;
      (slServer as object)['handleSlException']();
      expect(slServer).not().assertNull();
    })

    it('test_isScreenLockDisabled_return', 0, (): void => {
      let slServer = SlServerHelper.getInstance();
      let result = slServer.isScreenLockDisabled();
      expect(result).not().assertNull();
      slServer.onSystemEvent();
    })

    it('test_getStrongAuth_return', 0, (): void => {
      let slServer = SlServerHelper.getInstance();
      let result = slServer.getStrongAuth();
      expect(result).not().assertNull();
      let userId: number = 10;
      slServer.getStrongAuth(userId);
    })

    it('test_getScreenLockAuthState_return', 0, (): void => {
      let slServer = SlServerHelper.getInstance();
      let result = slServer.getScreenLockAuthState();
      expect(result).not().assertNull();
      let userId: number = 10;
      slServer.getScreenLockAuthState(userId);
    })
  })
}