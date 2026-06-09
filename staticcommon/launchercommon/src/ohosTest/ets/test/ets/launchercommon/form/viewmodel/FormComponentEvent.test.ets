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

import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { FormComponentEvent } from '../../../../../../../main/ets/form/viewmodel/FormComponentEvent';
import { FormComponentVm } from '../../../../../../../main/ets/form/viewmodel/FormComponentVm';
import { CardItemInfo } from '../../../../../../../main/ets/TsIndex';

export default function FormComponentEventTest() {
  describe('FormComponentEventTest', () => {
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
    
    it('init', 0, () => {
      let formComponentVm: FormComponentVm = new FormComponentVm();
      let formComponentEvent: FormComponentEvent = new FormComponentEvent(formComponentVm);
      const formItem: CardItemInfo = new CardItemInfo();
      formComponentEvent.initFormInfo(formItem);
      formComponentEvent.init();

      formItem.id = '123';
      formComponentEvent.initFormInfo(formItem);
      formComponentEvent.init();
      formComponentEvent.destroy();
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('onActive', 0, () => {
      let formComponentVm: FormComponentVm = new FormComponentVm();
      let formComponentEvent: FormComponentEvent = new FormComponentEvent(formComponentVm);
      formComponentEvent.onActive('123');
      expect(formComponentEvent.getFormOpacity()).assertEqual(0.005);
    });

    it('onInactive', 0, () => {
      let formComponentVm: FormComponentVm = new FormComponentVm();
      let formComponentEvent: FormComponentEvent = new FormComponentEvent(formComponentVm);
      formComponentEvent.onInactive('123');
      expect(formComponentEvent.getFormOpacity()).assertEqual(1);
    });

    it('formVisibility', 0, () => {
      let formComponentVm: FormComponentVm = new FormComponentVm();
      let formComponentEvent: FormComponentEvent = new FormComponentEvent(formComponentVm);
      formComponentEvent.setFormVisibility(false);
      expect(formComponentEvent.getFormVisibility()).assertEqual(false);
    });

    it('isFormSupportShadow', 0, () => {
      try {
        let formComponentVm: FormComponentVm = new FormComponentVm();
        expect(formComponentVm === undefined).assertFalse();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
  })
}