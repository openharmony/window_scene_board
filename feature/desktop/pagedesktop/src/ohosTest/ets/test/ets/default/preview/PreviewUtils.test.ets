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
import { GridLayoutItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when
} from '@ohos/hypium';
import { PreviewUtils } from '../../../../../../main/ets/default/preview/PreviewUtils';

export default function PreviewUtilsTest() {
  describe('PreviewUtilsTest', () => {
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
    it('should_return_true_when_input_is_undefined', 0, () => {
      const result: ESObject = PreviewUtils.checkStrIsEmpty('');
      expect(result).assertTrue();
    });

    it('should_return_true_when_input_is_null', 0, () => {
      const result: ESObject = PreviewUtils.checkStrIsEmpty('');
      expect(result).assertTrue();
    });

    it('should_return_true_when_input_is_empty_string', 0, () => {
      const result: ESObject = PreviewUtils.checkStrIsEmpty("");
      expect(result).assertTrue();
    });

    it('should_return_true_when_input_is_whitespace_string', 0, () => {
      const result: ESObject = PreviewUtils.checkStrIsEmpty("   ");
      expect(result).assertTrue();
    });

    it('should_return_false_when_input_is_non_empty_string', 0, () => {
      const result: ESObject = PreviewUtils.checkStrIsEmpty("hello");
      expect(result).assertFalse();
    });

    it('should_return_false_for_isVoiceAbilityForm', 0, () => {
      const bundleName: ESObject = 'com.ohos.suggestion';
      const abilityName: ESObject = 'ParentFormAbility';
      const result: ESObject = PreviewUtils.isVoiceAbilityForm(bundleName, abilityName);
      expect(result).assertFalse();
    });

    it('should_return_false_when_bundleName_does_not_match', 0, () => {
      const bundleName: ESObject = "com.example.someotherbundle";
      const abilityName: ESObject = 'ParentFormAbility';
      const result: ESObject = PreviewUtils.isVoiceAbilityForm(bundleName, abilityName);
      expect(result).assertFalse();
    });

    it('should_return_false_when_abilityName_does_not_match', 0, () => {
      const bundleName: ESObject = 'com.ohos.suggestion';
      const abilityName: ESObject = "com.example.someotherability";
      const result: ESObject = PreviewUtils.isVoiceAbilityForm(bundleName, abilityName);
      expect(result).assertFalse();
    });

    it('should_return_false_when_both_do_not_match', 0, () => {
      const bundleName: ESObject = "com.example.someotherbundle";
      const abilityName: ESObject = "com.example.someotherability";
      const result: ESObject = PreviewUtils.isVoiceAbilityForm(bundleName, abilityName);
      expect(result).assertFalse();
    });

    it('should_return_true_when_device_is_bar_and_form_is_not_transparent', 0, async (done: Function) => {
      let formItem: ESObject = new GridLayoutItemInfo();
      formItem.isTransparent = false;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isBarPhone);
      when(mockFunc)().afterReturn(true);
      const result: ESObject = PreviewUtils.isFormSupportShadow(formItem);
      expect(result).assertTrue();
      mocker.verify('isBarPhone', []).atLeast(1);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isBarPhone);
      done();
    });

    it('should_return_false_when_device_is_not_bar_and_form_is_not_transparent', 0, async (done: Function) => {
      let formItem: ESObject = new GridLayoutItemInfo();
      formItem.isTransparent = false;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isBarPhone);
      when(mockFunc)().afterReturn(false);
      const result: ESObject = PreviewUtils.isFormSupportShadow(formItem);
      expect(result).assertFalse();
      mocker.verify('isBarPhone', []).atLeast(1);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isBarPhone);
      done();
    });

    it('should_return_false_when_device_is_bar_and_form_is_transparent', 0, async (done: Function) => {
      let formItem: ESObject = new GridLayoutItemInfo();
      formItem.isTransparent = true;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isBarPhone);
      when(mockFunc)().afterReturn(true);
      const result: ESObject = PreviewUtils.isFormSupportShadow(formItem);
      expect(result).assertFalse();
      mocker.verify('isBarPhone', []).atLeast(1);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isBarPhone);
      done();
    });

    it('should_return_false_when_device_is_not_bar_and_form_is_transparent', 0, async (done: Function) => {
      let formItem: ESObject = new GridLayoutItemInfo();
      formItem.isTransparent = true;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isBarPhone);
      when(mockFunc)().afterReturn(false);
      const result: ESObject = PreviewUtils.isFormSupportShadow(formItem);
      expect(result).assertFalse();
      mocker.verify('isBarPhone', []).atLeast(1);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isBarPhone);
      done();
    });
  })
}