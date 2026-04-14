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
import { describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  Level} from '@ohos/hypium';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import context from '@ohos.app.ability.common';
import { EsDockEventManager } from '../../../../../main/ets/extmode/viewmodel/event/EsDockEventManager';
import { GlobalContext } from '@ohos/frameworkwrapper';

const TAG = 'EsDockEventManagerTest';

export default function EsDockEventManagerTest() {
  describe('PcSmartDockModelTest', () => {
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

    it('test_EsDockEventManagerTest_getInstance_should_return_single_instance', Level.LEVEL0, (): void => {
      let instance1 = EsDockEventManager.getInstance();
      expect(instance1).not().assertNull();
    })

    it('test_EsDockEventManagerTest_initInner_0', Level.LEVEL0, (): void => {
      let instance = EsDockEventManager.getInstance();
      (instance as object)['initInner']();
      expect(instance instanceof EsDockEventManager).assertTrue();
    })

  })
}