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

import { DeviceHelper } from '@ohos/frameworkwrapper';
import { FormComponentConfig } from '../../../../../../../main/ets/form/model/FormComponentConfig';
import { formInfo } from '@kit.FormKit';
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
  ArgumentMatchers,
} from '@ohos/hypium';
import { Size } from '@kit.ArkUI';


export default function FormComponentConfigTest() {
  describe('FormComponentConfigTest', () => {
    it('FormComponentConfigTest001', 0, () => {
      const ins = FormComponentConfig.getInstance();
      expect(ins instanceof FormComponentConfig).assertTrue();
    });

    it('FormComponentConfigTest002', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, (DeviceHelper as object)['isPad']);
      when(mockFunc)().afterReturn(true);
      const ins = FormComponentConfig.getInstance();
      expect((ins as object)['standardDimensionSize'] === undefined).assertFalse();
      expect((ins as object)['standardDimensionSize'].get(1).height === 53).assertTrue();
      expect((ins as object)['standardDimensionSize'].get(formInfo.FormDimension.Dimension_2_2).width === 160).assertTrue();
      expect((ins as object)['standardDimensionSize'].get(formInfo.FormDimension.Dimension_2_2).height === 160).assertTrue();
      mocker.clear(DeviceHelper);
    });

    it('FormComponentConfigTest003', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, (DeviceHelper as object)['isPad']);
      when(mockFunc)().afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(DeviceHelper, (DeviceHelper as object)['isPc']);
      when(mockFunc2)().afterReturn(true);
      const ins = FormComponentConfig.getInstance();
      expect((ins as object)['standardDimensionSize'] === undefined).assertFalse();
      expect((ins as object)['standardDimensionSize'].get(formInfo.FormDimension.Dimension_1_2).height === 64).assertTrue();
      expect((ins as object)['standardDimensionSize'].get(formInfo.FormDimension.Dimension_2_2).width === 180).assertTrue();
      expect((ins as object)['standardDimensionSize'].get(formInfo.FormDimension.Dimension_2_2).height === 180).assertTrue();
      mocker.clear(DeviceHelper);
    });

    it('FormComponentConfigTest004', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, (DeviceHelper as object)['isPad']);
      when(mockFunc)().afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(DeviceHelper, (DeviceHelper as object)['isPc']);
      when(mockFunc2)().afterReturn(false);
      const ins = FormComponentConfig.getInstance();
      expect((ins as object)['standardDimensionSize'] === undefined).assertFalse();
      expect((ins as object)['standardDimensionSize'].get(formInfo.FormDimension.Dimension_1_2).height === 54).assertTrue();
      expect((ins as object)['standardDimensionSize'].get(formInfo.FormDimension.Dimension_2_2).width === 140).assertTrue();
      expect((ins as object)['standardDimensionSize'].get(formInfo.FormDimension.Dimension_2_2).height === 140).assertTrue();
      mocker.clear(DeviceHelper);
    });

    it('FormComponentConfigTest005', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, (DeviceHelper as object)['isPad']);
      when(mockFunc)().afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(DeviceHelper, (DeviceHelper as object)['isPc']);
      when(mockFunc2)().afterReturn(false);
      const ins = FormComponentConfig.getInstance();
      expect(ins.getFormComponentDisplayStyle(100, {width: 0, height: 0}).displayRate === 1).assertTrue();
      expect(ins.getFormComponentDisplayStyle(formInfo.FormDimension.Dimension_1_2,
        {width: 70, height: 54}).displayRate === 0.5).assertFalse();
      expect(ins.getFormComponentDisplayStyle(formInfo.FormDimension.Dimension_1_2,
        {width: 140, height: 27}).displayRate === 0.5).assertFalse();
      mocker.clear(DeviceHelper);
    });

  });
}