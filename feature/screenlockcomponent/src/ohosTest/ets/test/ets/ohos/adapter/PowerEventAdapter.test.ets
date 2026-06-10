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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import { WakeUpReason } from '@ohos/screenlockcommon/src/main/ets/services/ScreenOnOffService'
import { VerifyDataManager } from '@ohos/screenlockcommon/src/main/ets/TsIndex'
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper'
import { PowerEventAdapter } from '../../../../../../main/ets/adapter/PowerEventAdapter'
import { CoreStateTypeUtils } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm'
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy'

export default function PowerEventAdapterTest() {
  describe('PowerEventAdapterTest', () => {
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

    it('test_handlePreBright', 0, () => {
      let powerEventAdapter = new PowerEventAdapter(ScreenLockFsmProxy.getInstance(114));
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(CoreStateTypeUtils, CoreStateTypeUtils.isInScreenOff);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (powerEventAdapter as object)['handlePreBright']();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (powerEventAdapter as object)['handlePreBright']();
      let r = CoreStateTypeUtils.isInScreenOff(0);
      expect(r).not().assertNull();
      mocker.clear(CoreStateTypeUtils);
    })
  })
}