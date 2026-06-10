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
import { CheckEmptyUtils } from '@ohos/basicutils';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import { CommonConstants, RecentMissionsModel } from '../../../../../../main/ets/TsIndex';

export default function RecentMissionsModelTest() {
  describe('RecentMissionsModelTest', () => {
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
    it('RecentMissionsModel_test_getInstance', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      globalThis.RecentMissionsModelInstance = null;
      const model = RecentMissionsModel.getInstance();
      expect(globalThis.RecentMissionsModelInstance).not().assertUndefined();
      expect(globalThis.RecentMissionsModelInstance).assertEqual(model);
    })

    it('test_getHapAbilityInfoAsync', 0, async(done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try {
      const model = RecentMissionsModel.getInstance();
      let bundleName = 'anyBundleNotExists';
      let module = 'anyModuleNotExists';
      let retValue = await model.getHapAbilityInfoAsync('', '');
      expect(retValue).assertNull();

      retValue = await model.getHapAbilityInfoAsync('', module);
      expect(retValue).assertNull();

      retValue = await model.getHapAbilityInfoAsync(bundleName, '');
      expect(retValue).assertNull();

      retValue = await model.getHapAbilityInfoAsync(bundleName, module);
      expect(retValue).assertNull();

      bundleName = CommonConstants.NOTEPAD_BUNDLE;
      retValue = await model.getHapAbilityInfoAsync(bundleName, module);
      expect(retValue).assertNull();
      } catch (e) {}
      done();
    })

    it('test_RecentMissionsModel_getHapAbilityInfoAsync', 0, async (done: Function) => {
      let bundleName: string = CommonConstants.NOTEPAD_BUNDLE;
      let moduleName: string = 'anyModuleNotExists';
      const instance: RecentMissionsModel = RecentMissionsModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result = await instance.getHapAbilityInfoAsync(bundleName, moduleName);
      expect(result).assertEqual(null);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })
  })
}
