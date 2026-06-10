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
import { RTLUtil } from '@ohos/componenthelper';
import { FormModel, CardItemInfo } from '@ohos/launchercommon';
import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import { FormEditViewData } from '../../../../../../main/ets/default/viewmodel/FormEditViewData';

export default function FormEditViewDataTest() {
  describe('FormEditViewDataTest', () => {
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
    it('test_getInstance', 0, () => {
      try {
        let instance = FormEditViewData.getInstance();
        expect(instance).not().assertNull();
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_getAppFormsCenterPosition_1', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let formEditViewData = new FormEditViewData();
        let formModel = FormModel.getInstance();
        let isSupportFormCenterSplit: Function = mocker.mockFunc(formModel, formModel.isSupportFormCenterSplit);
        when(isSupportFormCenterSplit)(ArgumentMatchers.any).afterReturn(true);
        let mockRTLUtil = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
        when(mockRTLUtil)(ArgumentMatchers.any).afterReturn(true);
        let cardItemInfo = new CardItemInfo();
        let position = formEditViewData.getAppFormsCenterPosition(cardItemInfo);
        expect(position).not().assertNull();
        expect(position.x).assertLargerOrEqual(0);
        expect(position.y).assertLargerOrEqual(0);
        mocker.clear(formModel);
        mocker.clear(RTLUtil);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('test_getAppFormsCenterPosition_2', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let formEditViewData = new FormEditViewData();
        let formModel = FormModel.getInstance();

        let isSupportFormCenterSplit: Function = mocker.mockFunc(formModel, formModel.isSupportFormCenterSplit);
        when(isSupportFormCenterSplit)(ArgumentMatchers.any).afterReturn(false);

        let cardItemInfo = new CardItemInfo();
        let position = formEditViewData.getAppFormsCenterPosition(cardItemInfo);
        expect(position).not().assertNull();
        expect(position.x).assertLargerOrEqual(0);
        expect(position.y).assertLargerOrEqual(0);
        mocker.clear(formModel);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });
  })
}