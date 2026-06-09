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
import { ResUtils } from '@ohos/windowscene';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ConfigurationEvent, GlobalContext } from '@ohos/frameworkwrapper';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import { InnerEventUtil } from '../../../main/ets/utils/InnerEventUtil';
import { i18n } from '@kit.LocalizationKit';
import { Singleton } from '../../../main/ets/utils/Singleton';
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
import { ResourceVm } from '../../../main/ets/vm/ResourceVm';

export default function ResourceVmTest() {
  describe('init_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_init_language_and_font_size_and_subscribe_to_configuration_event_when_no_error_occurs', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockLogHelperError)(ArgumentMatchers.any).afterReturnNothing();

      let mockInitLanguage: Function = mocker.mockFunc(resourcevm, resourcevm.initLanguage);
      when(mockInitLanguage)().afterReturnNothing();

      let mockInitFontSize: Function = mocker.mockFunc(resourcevm, resourcevm.initFontSize);
      when(mockInitFontSize)().afterReturnNothing();

      let mockSubscribeToConfigurationEvent: Function =
        mocker.mockFunc(InnerEventUtil, InnerEventUtil.subscribeToConfigurationEvent);
      when(mockSubscribeToConfigurationEvent)().afterReturnNothing();

      resourcevm.init();

      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(resourcevm, resourcevm.initLanguage);
      mocker.ignoreMock(resourcevm, resourcevm.initFontSize);
      mocker.ignoreMock(InnerEventUtil, InnerEventUtil.subscribeToConfigurationEvent);
    });

    it('should_log_error_when_init_language_throws_error', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockLogHelperError)(ArgumentMatchers.any).afterReturnNothing();

      let mockInitLanguage: Function = mocker.mockFunc(resourcevm, resourcevm.initLanguage);
      when(mockInitLanguage)().afterThrow("Error");

      let mockInitFontSize: Function = mocker.mockFunc(resourcevm, resourcevm.initFontSize);
      when(mockInitFontSize)().afterReturnNothing();

      let mockSubscribeToConfigurationEvent: Function =
        mocker.mockFunc(InnerEventUtil, InnerEventUtil.subscribeToConfigurationEvent);
      when(mockSubscribeToConfigurationEvent)().afterReturnNothing();

      resourcevm.init();

      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(resourcevm, resourcevm.initLanguage);
      mocker.ignoreMock(resourcevm, resourcevm.initFontSize);
      mocker.ignoreMock(InnerEventUtil, InnerEventUtil.subscribeToConfigurationEvent);
    });

    it('should_log_error_when_init_font_size_throws_error', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockLogHelperError)(ArgumentMatchers.any).afterReturnNothing();

      let mockInitLanguage: Function = mocker.mockFunc(resourcevm, resourcevm.initLanguage);
      when(mockInitLanguage)().afterReturnNothing();

      let mockInitFontSize: Function = mocker.mockFunc(resourcevm, resourcevm.initFontSize);
      when(mockInitFontSize)().afterThrow("Error");

      let mockSubscribeToConfigurationEvent: Function =
        mocker.mockFunc(InnerEventUtil, InnerEventUtil.subscribeToConfigurationEvent);
      when(mockSubscribeToConfigurationEvent)().afterReturnNothing();

      resourcevm.init();

      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(resourcevm, resourcevm.initLanguage);
      mocker.ignoreMock(resourcevm, resourcevm.initFontSize);
      mocker.ignoreMock(InnerEventUtil, InnerEventUtil.subscribeToConfigurationEvent);
    });

    it('should_log_error_when_subscribe_to_configuration_event_throws_error', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockLogHelperError)(ArgumentMatchers.any).afterReturnNothing();

      let mockInitLanguage: Function = mocker.mockFunc(resourcevm, resourcevm.initLanguage);
      when(mockInitLanguage)().afterReturnNothing();

      let mockInitFontSize: Function = mocker.mockFunc(resourcevm, resourcevm.initFontSize);
      when(mockInitFontSize)().afterReturnNothing();

      let mockSubscribeToConfigurationEvent: Function =
        mocker.mockFunc(InnerEventUtil, InnerEventUtil.subscribeToConfigurationEvent);
      when(mockSubscribeToConfigurationEvent)().afterThrow("Error");

      resourcevm.init();

      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(resourcevm, resourcevm.initLanguage);
      mocker.ignoreMock(resourcevm, resourcevm.initFontSize);
      mocker.ignoreMock(InnerEventUtil, InnerEventUtil.subscribeToConfigurationEvent);
    });

    it('should_return_correct_length_when_fontSize_is_valid', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(resourcevm, resourcevm.getFontSize);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new Length(10, "vp"));
      const result = resourcevm.getCapsuleSize(10);
      expect(result).assertDeepEquals(new Length(10, "vp"));
      mocker.ignoreMock(resourcevm, resourcevm.getFontSize);
    });

    it('should_return_default_length_when_fontSize_is_invalid', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(resourcevm, resourcevm.getFontSize);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new Length(16, "vp"));
      const result = resourcevm.getCapsuleSize(null);
      expect(result).assertDeepEquals(new Length(16, "vp"));
      mocker.ignoreMock(resourcevm, resourcevm.getFontSize);
    });

    it('should_return_capsule_size_when_fontScale_is_greater_than_1', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      resourcevm.fontScale = 1.5;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(resourcevm, resourcevm.getFontSize);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new Length(10, "vp"));
      const result = resourcevm.getCapsuleSize(10);
      expect(result).assertDeepEquals(new Length(10, "vp"));
      mocker.ignoreMock(resourcevm, resourcevm.getFontSize);
    });

    it('should_return_capsule_size_when_fontScale_is_less_than_1', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      resourcevm.fontScale = 0.5;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(resourcevm, resourcevm.getFontSize);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new Length(10, "vp"));
      const result = resourcevm.getCapsuleSize(10);
      expect(result).assertDeepEquals(new Length(10 / 0.5, "vp"));
      mocker.ignoreMock(resourcevm, resourcevm.getFontSize);
    });

    it('should_return_capsule_size_when_fontScale_is_1', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      resourcevm.fontScale = 1;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(resourcevm, resourcevm.getFontSize);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new Length(10, "vp"));
      const result = resourcevm.getCapsuleSize(10);
      expect(result).assertDeepEquals(new Length(10, "vp"));
      mocker.ignoreMock(resourcevm, resourcevm.getFontSize);
    });

    it('should_return_capsule_size_when_fontScale_is_close_to_1', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      resourcevm.fontScale = 1.000001;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(resourcevm, resourcevm.getFontSize);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new Length(10, "vp"));
      const result = resourcevm.getCapsuleSize(10);
      expect(result).assertDeepEquals(new Length(10, "vp"));
      mocker.ignoreMock(resourcevm, resourcevm.getFontSize);
    });

    it('should_return_capsule_size_when_fontScale_is_greater_than_CAPSULE_MAX_SCALE', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      resourcevm.fontScale = 1.2;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(resourcevm, resourcevm.getFontSize);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new Length(10, "vp"));
      const result = resourcevm.getCapsuleSize(10);
      expect(result).assertDeepEquals(new Length(10, "vp"));
      mocker.ignoreMock(resourcevm, resourcevm.getFontSize);
    });

    it('should_return_capsule_size_when_fontScale_is_less_than_CAPSULE_MAX_SCALE', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      resourcevm.fontScale = 1.05;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(resourcevm, resourcevm.getFontSize);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new Length(10, "vp"));
      const result = resourcevm.getCapsuleSize(10);
      expect(result).assertDeepEquals(new Length(10 / 1.05, "vp"));
      mocker.ignoreMock(resourcevm, resourcevm.getFontSize);
    });

    it('should_return_capsule_size_when_fontSize_is_zero', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(resourcevm, resourcevm.getFontSize);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new Length(0, "vp"));
      const result = resourcevm.getCapsuleSize(0);
      expect(result).assertDeepEquals(new Length(0, "vp"));
      mocker.ignoreMock(resourcevm, resourcevm.getFontSize);
    });

    it('should_return_capsule_size_when_fontSize_is_negative', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(resourcevm, resourcevm.getFontSize);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new Length(-10, "vp"));
      const result = resourcevm.getCapsuleSize(-10);
      expect(result).assertDeepEquals(new Length(-10, "vp"));
      mocker.ignoreMock(resourcevm, resourcevm.getFontSize);
    });

    it('should_return_capsule_size_when_fontSize_is_fraction', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(resourcevm, resourcevm.getFontSize);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new Length(0.5, "vp"));
      const result = resourcevm.getCapsuleSize(0.5);
      expect(result).assertDeepEquals(new Length(0.5, "vp"));
      mocker.ignoreMock(resourcevm, resourcevm.getFontSize);
    });

    it('should_return_correct_font_size_when_fontSize_is_number', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(resourcevm, resourcevm.getFontScale);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(1.5);

      const result = resourcevm.getFontSize(10, 2.0);
      expect(result).assertEqual('12vp');
      mocker.ignoreMock(resourcevm, resourcevm.getFontScale);
    });

    it('should_return_correct_font_size_when_fontSize_is_Resource', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(resourcevm, resourcevm.getFontScale);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(1.5);

      let mockfunc2: Function = mocker.mockFunc(resourcevm, resourcevm.getNumber);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(10);

      let res: Resource = {
        id: 1, name: 'test'
      };
      const result = resourcevm.getFontSize(res, 2.0);
      expect(result).assertEqual('12vp');
      mocker.ignoreMock(resourcevm, resourcevm.getFontScale);
      mocker.ignoreMock(resourcevm, resourcevm.getNumber);
    });

    it('should_return_correct_font_size_when_maxScale_is_undefined', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(resourcevm, resourcevm.getFontScale);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(1.0);

      let mockfunc2: Function = mocker.mockFunc(resourcevm, resourcevm.getNumber);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(10);

      let res: Resource = {
        id: 1, name: 'test'
      };
      const result = resourcevm.getFontSize(res);
      expect(result).assertEqual('10vp');
      mocker.ignoreMock(resourcevm, resourcevm.getFontScale);
      mocker.ignoreMock(resourcevm, resourcevm.getNumber);
    });

    it('should_return_correct_font_size_when_maxScale_is_zero', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(resourcevm, resourcevm.getFontScale);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(1.0);

      let mockfunc2: Function = mocker.mockFunc(resourcevm, resourcevm.getNumber);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(10);

      let res: Resource = {
        id: 1, name: 'test'
      };
      const result = resourcevm.getFontSize(res, 0.0);
      expect(result).assertEqual('10vp');
      mocker.ignoreMock(resourcevm, resourcevm.getFontScale);
      mocker.ignoreMock(resourcevm, resourcevm.getNumber);
    });

    it('should_return_correct_font_size_when_maxScale_is_negative', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(resourcevm, resourcevm.getFontScale);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(1.0);

      let mockfunc2: Function = mocker.mockFunc(resourcevm, resourcevm.getNumber);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(10);

      let res: Resource = {
        id: 1, name: 'test'
      };
      const result = resourcevm.getFontSize(res, -2.0);
      expect(result).assertEqual('10vp');
      mocker.ignoreMock(resourcevm, resourcevm.getFontScale);
      mocker.ignoreMock(resourcevm, resourcevm.getNumber);
    });

    it('should_return_correct_font_size_when_maxScale_is_greater_than_fontScale', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(resourcevm, resourcevm.getFontScale);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(1.0);

      let mockfunc2: Function = mocker.mockFunc(resourcevm, resourcevm.getNumber);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(10);

      let res: Resource = {
        id: 1, name: 'test'
      };
      const result = resourcevm.getFontSize(res, 2.0);
      expect(result).assertEqual('12vp');
      mocker.ignoreMock(resourcevm, resourcevm.getFontScale);
      mocker.ignoreMock(resourcevm, resourcevm.getNumber);
    });

    it('should_return_correct_font_size_when_maxScale_is_less_than_fontScale', 0, async () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(resourcevm, resourcevm.getFontScale);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(1.0);

      let mockfunc2: Function = mocker.mockFunc(resourcevm, resourcevm.getNumber);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(10);

      let res: Resource = {
        id: 1, name: 'test'
      };
      const result = resourcevm.getFontSize(res, 0.5);
      expect(result).assertEqual('10vp');
      mocker.ignoreMock(resourcevm, resourcevm.getFontScale);
      mocker.ignoreMock(resourcevm, resourcevm.getNumber);
    });

    it('should_return_fontScale_when_maxScale_is_greater_than_fontScale', 0, () => {
      let resourcevm: ResourceVm = new ResourceVm();
      resourcevm.fontScale = 1.5;
      const result = resourcevm.getFontScale(2);
      expect(result).assertEqual(1.5);
    });

    it('should_return_maxScale_when_fontScale_is_greater_than_maxScale', 0, () => {
      let resourcevm: ResourceVm = new ResourceVm();
      resourcevm.fontScale = 0.5;
      const result = resourcevm.getFontScale(1);
      expect(result).assertEqual(1);
    });

    it('should_return_fontScale_when_maxScale_is_equal_to_fontScale', 0, () => {
      let resourcevm: ResourceVm = new ResourceVm();
      resourcevm.fontScale = 1;
      const result = resourcevm.getFontScale(1);
      expect(result).assertEqual(1);
    });

    it('should_return_fontScale_when_maxScale_is_less_than_fontScale', 0, () => {
      let resourcevm: ResourceVm = new ResourceVm();
      resourcevm.fontScale = 2;
      const result = resourcevm.getFontScale(1);
      expect(result).assertEqual(1);
    });

    it('should_return_string_when_res_is_string', 0, () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(GlobalContext.getContext()?.resourceManager,
        GlobalContext.getContext()?.resourceManager.getPluralStringByNameSync);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyNumber).afterReturn("test string");
      const result = resourcevm.getPluralString("testRes", 1);
      expect(result).assertEqual("test string");
      mocker.ignoreMock(GlobalContext.getContext()?.resourceManager,
        GlobalContext.getContext()?.resourceManager.getPluralStringByNameSync);
    });

    it('should_return_string_when_res_is_Resource', 0, () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(GlobalContext.getContext()?.resourceManager,
        GlobalContext.getContext()?.resourceManager.getPluralStringValueSync);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn("test string");
      const result = resourcevm.getPluralString({
        id: 1
      } as Resource, 1);
      expect(result).assertEqual("test string");
      mocker.ignoreMock(GlobalContext.getContext()?.resourceManager,
        GlobalContext.getContext()?.resourceManager.getPluralStringValueSync);
    });

    it('should_return_default_string_when_res_is_invalid', 0, () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();
      const result = resourcevm.getPluralString(null as any, 1);
      expect(result).assertEqual("test string");
    });

    it('should_return_number_when_res_is_string', 0, () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();

      const result = resourcevm.getResNumber("test");
      expect(result).assertEqual(123);

      mocker.ignoreMock(GlobalContext.getContext().resourceManager,
        GlobalContext.getContext().resourceManager.getNumberByName);
    });

    it('should_return_number_when_res_is_Resource', 0, () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(GlobalContext.getContext().resourceManager,
        GlobalContext.getContext().resourceManager.getNumber);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(456);

      let res: Resource = {
        id: 123
      };
      const result = resourcevm.getResNumber(res);
      expect(result).assertEqual(456);

      mocker.ignoreMock(GlobalContext.getContext().resourceManager,
        GlobalContext.getContext().resourceManager.getNumber);
    });

    it('should_return_number_when_res_is_Resource_with_language', 0, () => {
      let resourcevm: ResourceVm = new ResourceVm();
      let mocker: MockKit = new MockKit();

      let mockfunc2: Function = mocker.mockFunc(i18n, i18n.setLanguage);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper.info);
      when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockfunc4: Function = mocker.mockFunc(LogDomain, LogDomain.info);
      when(mockfunc4)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockfunc5: Function = mocker.mockFunc(systemParameterEnhance, systemParameterEnhance.get);
      when(mockfunc5)(ArgumentMatchers.anyString).afterReturn("en");

      let mockfunc6: Function = mocker.mockFunc(InnerEventUtil, InnerEventUtil.send);
      when(mockfunc6)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockfunc7: Function = mocker.mockFunc(Singleton, Singleton.get);
      when(mockfunc7)(ArgumentMatchers.anyString).afterReturn(GlobalContext.getContext());

      let res: Resource = {
        id: 123
      };
      resourcevm.onConfigurationEvent({
        config: {
          language: "en"
        }
      });
      const result = resourcevm.getResNumber(res);

      mocker.ignoreMock(GlobalContext.getContext().resourceManager,
        GlobalContext.getContext().resourceManager.getNumber);
      mocker.ignoreMock(i18n, i18n.setLanguage);
      mocker.ignoreMock(LogHelper, LogHelper.info);
      mocker.ignoreMock(LogDomain, LogDomain.info);
      mocker.ignoreMock(systemParameterEnhance, systemParameterEnhance.get);
      mocker.ignoreMock(InnerEventUtil, InnerEventUtil.send);
      mocker.ignoreMock(Singleton, Singleton.get);
    });
  });
}