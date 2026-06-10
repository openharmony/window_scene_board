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
import { SceneBoardCoreStateFsm } from '../../../../../../../main/ets/manager/fsm/SceneBoardCoreStateFsm';
import { CoreEventType } from '../../../../../../../main/ets/manager/fsm/SceneBoardStateConfig';
import { StateFsm } from '../../../../../../../main/ets/manager/fsm/StateFsm';

export function SceneBoardCoreStateFsmTest() {
  describe('SceneBoardCoreStateFsmTest', () => {
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

    it('init_test', 0, () => {
      let fsm: StateFsm = new SceneBoardCoreStateFsm();
      fsm.init();
      fsm.transfer(CoreEventType.ENTER_DESKTOP);
      fsm.transfer(CoreEventType.OPEN_DESKTOP_FOLDER);
      fsm.transfer(CoreEventType.OPEN_CONTROL_CENTER);
      fsm.transfer(CoreEventType.CLOSE_DESKTOP_FOLDER);
      fsm.transfer(CoreEventType.ENTER_SCREEN_LOCK);
      fsm.transfer(CoreEventType.OPEN_CONTROL_CENTER);
      fsm.transfer(CoreEventType.ENTER_AOD);
      expect(fsm.currentState.stateType).not().assertUndefined();
    })
  })
}