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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit } from '@ohos/hypium';
import { LockscreenFormConfig } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import OuterScreenLockFormViewModel from '@ohos/screenlockwidget/src/main/ets/form/vm/OuterScreenLockFormViewModel';

class getResultClass {
  static getResult1(callBack: Function): void {
    callBack();
  }
};

export default function OuterScreenLockFormViewModelTest() {
  describe('OuterScreenLockFormViewModelTest', () => {
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

    it('should_return_a_Want_object_with_correct_parameters', 0, async (done: Function) => {
      const want: Want = OuterScreenLockFormViewModel.getFromWant();
      const SCREEN_LOCK: number = 6;
      const FORM_LOCATION_KEY = 'ohos.extra.param.key.form_location';
      expect(want.parameters?.[FORM_LOCATION_KEY]).assertEqual(SCREEN_LOCK);
      done();
    });

    it('test_registerRouterProxy_should_return', 0, () => {
      let outerScreenLockFormViewModel: OuterScreenLockFormViewModel = new OuterScreenLockFormViewModel();
      let result: boolean = false;
      let formId: string = 'res';
      getResultClass.getResult1(() => {
        outerScreenLockFormViewModel.registerRouterProxy(formId);
        result = true;
      })
      expect(result).assertEqual(true);
    });

    it('assertFormPanelHeightViewModelInitOnScreenLock', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let outerScreenLockFormViewModel: OuterScreenLockFormViewModel = new OuterScreenLockFormViewModel();
      outerScreenLockFormViewModel.viewModelInitOnScreenLock([]);

      expect(outerScreenLockFormViewModel.formConfigs.length).assertEqual(0);
    });

    it('test_initFormConfigInfo_should_return', 0, () => {
      let outerScreenLockFormViewModel: OuterScreenLockFormViewModel = new OuterScreenLockFormViewModel();
      let initFormConfigs: LockscreenFormConfig[] = [];
      outerScreenLockFormViewModel.initFormConfigInfo(initFormConfigs);
      expect(outerScreenLockFormViewModel.formConfigs).not().assertNull();
    });

    it('should_not_clear_any_configs_when_current_has_no_configs_not_in_pre', 0, async (done: Function) => {
      let viewModel: OuterScreenLockFormViewModel = new OuterScreenLockFormViewModel();
      let currentConfigs: LockscreenFormConfig[] = [];
      let preConfigs: LockscreenFormConfig[] = [];
      viewModel.clearUnUsedFormConfigs(currentConfigs, preConfigs);
      expect(viewModel.toBeDelCardIDS).assertDeepEquals([]);
      done();
    });

    it('should_handle_empty_current_and_pre_configs', 0, async (done: Function) => {
      let viewModel: OuterScreenLockFormViewModel = new OuterScreenLockFormViewModel();
      viewModel.clearUnUsedFormConfigs();
      expect(viewModel.toBeDelCardIDS).assertDeepEquals([]);
      done();
    });

    it('test_initFormConfigInfo_should_return_ON', 0, () => {
      let outerScreenLockFormViewModel: OuterScreenLockFormViewModel = new OuterScreenLockFormViewModel();
      let mLockscreenFormConfig: LockscreenFormConfig = new LockscreenFormConfig();
      mLockscreenFormConfig.positionX = 1;
      mLockscreenFormConfig.positionY = 2;
      let initFormConfigs: LockscreenFormConfig[] = [mLockscreenFormConfig];
      outerScreenLockFormViewModel.initFormConfigInfo(initFormConfigs);
      expect(outerScreenLockFormViewModel.formConfigs).not().assertNull();
    });
  });
}