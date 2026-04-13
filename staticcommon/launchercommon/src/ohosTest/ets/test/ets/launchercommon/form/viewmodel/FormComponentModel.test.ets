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

import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
} from '@ohos/hypium';
import { FormComponentModel } from '../../../../../../../main/ets/form/model/FormComponentModel';
import { FormComponentEvent } from '../../../../../../../main/ets/form/viewmodel/FormComponentEvent';
import { FormComponentVm } from '../../../../../../../main/ets/form/viewmodel/FormComponentVm';
import { CardItemInfo, GridLayoutItemInfo } from '../../../../../../../main/ets/TsIndex';

export default function FormComponentModelTest() {
  describe('FormComponentModelTest', () => {
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

    it('test_FormComponentModel_registerViewData_unRegisterViewData', 0, () => {
      let instance: FormComponentModel = FormComponentModel.getInstance();
      let formInfo: CardItemInfo = new CardItemInfo();
      formInfo.cardId = 'test';
      let viewData: FormComponentEvent = new FormComponentEvent(new FormComponentVm());
      instance.unRegisterViewData(formInfo, viewData);
      expect(instance).not().assertNull();
      instance.registerViewData(formInfo, viewData);
      expect(instance).not().assertNull();
      instance.registerViewData(formInfo, viewData);
      expect(instance).not().assertNull();
      instance.unRegisterViewData(formInfo, viewData);
      expect(instance).not().assertNull();
    });

    it('test_FormComponentModel_hideForm_showForm', 0, () => {
      let instance: FormComponentModel = FormComponentModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.abilityName = 'openharmony';
      info.area = [1, 2];
      instance.hideForm(info);
      expect(instance).not().assertNull();
      instance.showForm(info);
      expect(instance).not().assertNull();
    });

    it('test_FormComponentModel_setFormOpacity', 0, () => {
      let instance: FormComponentModel = FormComponentModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.abilityName = 'openharmony';
      info.area = [1, 2];
      instance.setFormOpacity(info, 1);
      expect(instance).not().assertNull();
    });

    it('test_FormComponentModel_isInScreenRotateAni', 0, () => {
      const formComponentModel: FormComponentModel = FormComponentModel.getInstance();
      formComponentModel.setIsScreenRotateAni(true);
      expect(formComponentModel.isInScreenRotateAni()).assertTrue();
    });

    it('test_FormComponentModel_getComponentSize1', 0, () => {
      const formComponentModel: FormComponentModel = FormComponentModel.getInstance();
      expect(formComponentModel.getComponentSize(0, 0 , true)).not().assertNull();
    });

    it('test_FormComponentModel_getComponentSize2', 0, () => {
      const formComponentModel: FormComponentModel = FormComponentModel.getInstance();
      expect(formComponentModel.getComponentSize(0, 0 , false)).not().assertNull();
    });
  })
}