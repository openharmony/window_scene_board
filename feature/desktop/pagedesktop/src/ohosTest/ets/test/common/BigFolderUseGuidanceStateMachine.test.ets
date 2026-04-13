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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from "@ohos/hypium";
import {
  BigFolderUseGuidanceStateMachine,
  StateEnum
} from "../../../../main/ets/default/service/impl/BigFolderUseGuidanceStateMachine";

export default function BigFolderUseGuidanceStateMachineTest() {
  describe('BigFolderUseGuidanceStateMachineTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });

    it('reportFolderNaviNoTrig', 0, () => {
      let instance: BigFolderUseGuidanceStateMachine = BigFolderUseGuidanceStateMachine.getInstance();
      instance.reportFolderNaviNoTrig();
      expect(instance).not().assertNull();
    });

    it('changeState', 0, () => {
      let instance: BigFolderUseGuidanceStateMachine = BigFolderUseGuidanceStateMachine.getInstance();
      instance.changeState(StateEnum.REMIND_ALREADY);
      expect(instance).not().assertNull();
    });

    it('getState', 0, () => {
      let instance: BigFolderUseGuidanceStateMachine = BigFolderUseGuidanceStateMachine.getInstance();
      instance.getState();
      expect(instance).not().assertNull();
    });

    it('getcheckCount', 0, () => {
      let instance: BigFolderUseGuidanceStateMachine = BigFolderUseGuidanceStateMachine.getInstance();
      instance.getCheckCount();
      expect(instance).not().assertNull();
    });

    it('increasecheckCount', 0, () => {
      let instance: BigFolderUseGuidanceStateMachine = BigFolderUseGuidanceStateMachine.getInstance();
      instance.increaseCheckCount();
      expect(instance).not().assertNull();
    });

    it('setRemindAlreadyState', 0, () => {
      let instance: BigFolderUseGuidanceStateMachine = BigFolderUseGuidanceStateMachine.getInstance();
      instance.setRemindAlreadyState();
      expect(instance).not().assertNull();
    });

    it('canStart', 0, () => {
      let instance: BigFolderUseGuidanceStateMachine = BigFolderUseGuidanceStateMachine.getInstance();
      instance.canStart();
      expect(instance).not().assertNull();
    });

  })
}
