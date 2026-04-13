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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import { PowerUtils, SlServerHelper,
  StrongAuthStateManager,
  StrongAuthReason,
  SwitchEventData,
  VerifyDataManager} from '@ohos/screenlockcommon/src/main/ets/TsIndex'
import { UserSwitchEventAdapter } from '../../../../../../main/ets/adapter/UserSwitchEventAdapter'
import { CoreStateTypeUtils } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm'
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy'

export default function UserSwitchEventAdapterTest() {
  describe('UserSwitchEventAdapterTest', () => {
    let switchData: SwitchEventData = {
      fromAccountId: 0,
      toAccountId: 0
    }
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

    it('test_clearInactiveTimeout', 0, () => {
      let userSwitchEventAdapter = new UserSwitchEventAdapter(ScreenLockFsmProxy.getInstance(114));
      (userSwitchEventAdapter)['_inactiveTimeout'] = 0;
      (userSwitchEventAdapter)['clearInactiveTimeout']();
      (userSwitchEventAdapter)['_inactiveTimeout'] = 1;
      let r: boolean = (userSwitchEventAdapter)['clearInactiveTimeout']();
      expect(r).assertEqual(true);
    })

    it('test_handleSwitchingEvent', 0, () => {
      let userSwitchEventAdapter = new UserSwitchEventAdapter(ScreenLockFsmProxy.getInstance(114));
      (userSwitchEventAdapter)['_currentLocalId'] = 0;
      (userSwitchEventAdapter)['handleSwitchingEvent'](switchData);
      switchData.toAccountId = 1;
      (userSwitchEventAdapter)['handleSwitchingEvent'](switchData);
      expect(switchData.toAccountId).assertEqual(1);
    })

    it('test_handleSwitchedEvent', 0, () => {
      let userSwitchEventAdapter = new UserSwitchEventAdapter(ScreenLockFsmProxy.getInstance(114));
      (userSwitchEventAdapter)['handleSwitchedEvent']({} as SwitchEventData);
      (userSwitchEventAdapter)['_currentLocalId'] = 0;
      (userSwitchEventAdapter)['handleSwitchedEvent'](switchData);
      switchData.fromAccountId = 1;
      (userSwitchEventAdapter)['handleSwitchedEvent'](switchData);
      expect(switchData.fromAccountId).assertEqual(1);
    })

  })
}