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
import { LogHelper } from '@ohos/basicutils'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import { PowerButtonManager } from '../../../../../main/ets/manager/PowerButtonManager'

export default function PowerButtonManagerTest() {
  describe('PowerButtonManagerTest', () => {
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

    it('atc_should_log_error_when_getPowerKeyConfigArray_throws_exception', 0, async () => {
      let powerbuttonmanager: PowerButtonManager = new PowerButtonManager();
      let manager = powerbuttonmanager as object;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(manager, manager['getPowerKeyConfigArray']);
      when(mockfunc)().afterThrow("Error on load effects file, error message");
      powerbuttonmanager.init();
      expect(powerbuttonmanager).not().assertUndefined();
      mocker.ignoreMock(manager, manager['getPowerKeyConfigArray']);
    });

    it('atc_should_return_powerKeyCenterPixelConfigArray_is_null', 0, () => {
      let powerbuttonmanager: PowerButtonManager = new PowerButtonManager();
      let manager = powerbuttonmanager as object;
      manager['powerKeyConfigArray'] = undefined;
      const result: ESObject = powerbuttonmanager.getCurrentPowerKeyCenterPowerButton();
      expect(result).not().assertUndefined();
    });

    it('atc_should_return_display_match_error_when_powerKeyConfigArray_is_empty', 0, () => {
      let powerbuttonmanager: PowerButtonManager = new PowerButtonManager();
      let manager = powerbuttonmanager as object;
      manager['powerKeyConfigArray'] = [];
      const result: ESObject = powerbuttonmanager.getCurrentPowerKeyCenterPowerButton();
      expect(result).assertEqual('no display match, please check config!');
    });

    it('atc_should_return_more_than_one_display_match_error_when_powerKeyConfigArray_has_more_than_one_element', 0, () => {
      let powerbuttonmanager: PowerButtonManager = new PowerButtonManager();
      let manager = powerbuttonmanager as object;
      manager['powerKeyConfigArray'] =  [
        { defaultRotation: 0, displayWidth: 100, displayHeight: 100 },
        { defaultRotation: 0, displayWidth: 100, displayHeight: 100 }
      ];
      const result: ESObject = powerbuttonmanager.getCurrentPowerKeyCenterPowerButton();
      expect(result).not().assertUndefined();
    });

    it('atc_should_return_postionRotated_when_powerKeyConfigArray_has_one_element_and_display_match', 0, () => {
      let powerbuttonmanager: PowerButtonManager = new PowerButtonManager();
      let manager = powerbuttonmanager as object;
      manager['powerKeyConfigArray'] =  [
        { defaultRotation: 0, displayWidth: 100, displayHeight: 100 }
      ];
      const result: ESObject = powerbuttonmanager.getCurrentPowerKeyCenterPowerButton();
      expect(result).not().assertUndefined();
    });

    it('atc_should_return_postionRotated_when_powerKeyConfigArray_has_one_element_and_display_match_with_rotation', 0, () => {
      let powerbuttonmanager: PowerButtonManager = new PowerButtonManager();
      let manager = powerbuttonmanager as object;
      manager['powerKeyConfigArray'] =  [
        { defaultRotation: 1, displayWidth: 100, displayHeight: 100 }
      ];
      const result: ESObject = powerbuttonmanager.getCurrentPowerKeyCenterPowerButton();
      expect(result).not().assertUndefined();
    });

    it('atc_should_return_postionRotated_when_powerKeyConfigArray_has_one_element_and_display_match_with_rotation_90', 0, () => {
      let powerbuttonmanager: PowerButtonManager = new PowerButtonManager();
      let manager = powerbuttonmanager as object;
      manager['powerKeyConfigArray'] = [
        { defaultRotation: 1, displayWidth: 100, displayHeight: 100 }
      ];
      const result: ESObject = powerbuttonmanager.getCurrentPowerKeyCenterPowerButton();
      expect(result).not().assertUndefined();
    });

    it('atc_should_return_postionRotated_when_powerKeyConfigArray_has_one_element_and_display_match_with_rotation_270', 0, () => {
      let powerbuttonmanager: PowerButtonManager = new PowerButtonManager();
      let manager = powerbuttonmanager as object;
      manager['powerKeyConfigArray'] = [
        { defaultRotation: 3, displayWidth: 100, displayHeight: 100 }
      ];
      const result: ESObject = powerbuttonmanager.getCurrentPowerKeyCenterPowerButton();
      expect(result).not().assertUndefined();
    });

    it('atc_should_return_error_message_when_powerKeyConfigArray_has_one_element_and_display_not_match', 0, () => {
      let powerbuttonmanager: PowerButtonManager = new PowerButtonManager();
      let manager = powerbuttonmanager as object;
      manager['powerKeyConfigArray'] = [
        { defaultRotation: 0, displayWidth: 100, displayHeight: 100 }
      ];
      const result: ESObject = powerbuttonmanager.getCurrentPowerKeyCenterPowerButton();
      expect(result).assertEqual('no display match, please check config!');
    });

    it('atc_should_return_error_message_when_powerKeyConfigArray_has_one_element_and_display_not_match_with_rotation', 0, () => {
      let powerbuttonmanager: PowerButtonManager = new PowerButtonManager();
      let manager = powerbuttonmanager as object;
      manager['powerKeyConfigArray'] = [
        { defaultRotation: 1, displayWidth: 100, displayHeight: 100 }
      ];
      const result: ESObject = powerbuttonmanager.getCurrentPowerKeyCenterPowerButton();
      expect(result).assertEqual('no display match, please check config!');
    });

    it('atc_should_return_error_message_when_powerKeyConfigArray_has_one_element_and_display_not_match_with_rotation_90', 0, () => {
      let powerbuttonmanager: PowerButtonManager = new PowerButtonManager();
      let manager = powerbuttonmanager as object;
      manager['powerKeyConfigArray'] = [
        { defaultRotation: 1, displayWidth: 100, displayHeight: 100 }
      ];
      const result: ESObject = powerbuttonmanager.getCurrentPowerKeyCenterPowerButton();
      expect(result).assertEqual('no display match, please check config!');
    });

    it('atc_should_return_error_message_when_powerKeyConfigArray_has_one_element_and_display_not_match_with_rotation_270', 0, () => {
      let powerbuttonmanager: PowerButtonManager = new PowerButtonManager();
      let manager = powerbuttonmanager as object;
      manager['powerKeyConfigArray'] = [
        { defaultRotation: 3, displayWidth: 100, displayHeight: 100 }
      ];
      const result: ESObject = powerbuttonmanager.getCurrentPowerKeyCenterPowerButton();
      expect(result).assertEqual('no display match, please check config!');
    });

    it('atc_should_return_postionRotated_when_powerKeyConfigArray_has_one_element_and_display_match_with_rotation_90_270', 0, () => {
      let powerbuttonmanager: PowerButtonManager = new PowerButtonManager();
      let manager = powerbuttonmanager as object;
      manager['powerKeyConfigArray'] = [
        { defaultRotation: 1, displayWidth: 100, displayHeight: 100 }
      ];
      const result: ESObject = powerbuttonmanager.getCurrentPowerKeyCenterPowerButton();
      expect(result).not().assertUndefined();
    });

    it('atc_should_return_postionRotated_when_powerKeyConfigArray_has_one_element_and_display_match_with_rotation_270_90', 0, () => {
      let powerbuttonmanager: PowerButtonManager = new PowerButtonManager();
      let manager = powerbuttonmanager as object;
      manager['powerKeyConfigArray'] = [
        { defaultRotation: 3, displayWidth: 100, displayHeight: 100 }
      ];
      const result: ESObject = powerbuttonmanager.getCurrentPowerKeyCenterPowerButton();
      expect(result).not().assertUndefined();
    });

    it('atc_should_return_postionRotated_when_powerKeyConfigArray_has_one_element_and_display_match_with_rotation_90_270_90', 0, () => {
      let powerbuttonmanager: PowerButtonManager = new PowerButtonManager();
      let manager = powerbuttonmanager as object;
      manager['powerKeyConfigArray'] = [
        { defaultRotation: 1, displayWidth: 100, displayHeight: 100 }
      ];
      const result: ESObject = powerbuttonmanager.getCurrentPowerKeyCenterPowerButton();
      expect(result).not().assertUndefined();
    });

    it('atc_should_return_postionRotated_when_powerKeyConfigArray_has_one_element_and_display_match_with_rotation_270_90_270', 0, () => {
      let powerbuttonmanager: PowerButtonManager = new PowerButtonManager();
      let manager = powerbuttonmanager as object;
      manager['powerKeyConfigArray'] = [
        { defaultRotation: 3, displayWidth: 100, displayHeight: 100 }
      ];
      const result: ESObject = powerbuttonmanager.getCurrentPowerKeyCenterPowerButton();
      expect(result).not().assertUndefined();
    });
  })
}