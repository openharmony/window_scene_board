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
import { sSCBOobeManager } from '@ohos/windowscene'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import { HandleResult, SlServerHelper } from '@ohos/screenlockcommon/src/main/ets/TsIndex'
import { SlServiceEventAdapter } from '../../../../../../main/ets/adapter/SlServiceEventAdapter'
import { CoreStateTypeUtils } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm'
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy'

export default function SlServiceEventAdapterTest() {
  describe('SlServiceEventAdapterTest', () => {
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

    it('test_handleLockRequestEvent', 0, () => {
      let sl = new SlServiceEventAdapter(ScreenLockFsmProxy.getInstance(114));
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(SlServerHelper.getInstance(), SlServerHelper.getInstance().isScreenLockDisabled);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (sl as object)['handleLockRequestEvent']();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (sl as object)['handleLockRequestEvent']();
      let mockFunc1 = mocker.mockFunc(CoreStateTypeUtils, CoreStateTypeUtils.isInUnlockPage);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      (sl as object)['handleLockRequestEvent']();
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      (sl as object)['handleLockRequestEvent']();
      expect(CoreStateTypeUtils.isInUnlockPage(0)).not().assertNull();
      mocker.clear(CoreStateTypeUtils);
      mocker.clear(SlServerHelper.getInstance());
    })

    it('test_handleUnlockRequestCallback', 0, () => {
      let sl = new SlServiceEventAdapter(ScreenLockFsmProxy.getInstance(114));
      let mocker = new MockKit();
      let mockFunc1 = mocker.mockFunc(CoreStateTypeUtils, CoreStateTypeUtils.isInUnlockPage);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      (sl as object)['handleUnlockRequestCallback']((result: HandleResult)=>{});
      expect(CoreStateTypeUtils.isInUnlockPage(0)).assertEqual(true);
      mocker.clear(CoreStateTypeUtils);
    })
  })
}