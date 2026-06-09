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
import { DomainName, LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import settings from '@ohos.settings';
import ctx from '@ohos.app.ability.common';
import accessibility from '@ohos.accessibility';
import { BusinessError } from '@ohos.base';
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
import { AccessibilityManager } from '../../../main/ets/common/AccessibilityManager';

export default function AccessibilityManagerTest() {
  describe('init_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_register_accessibility_mode_listener_when_init_is_called', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibility, accessibility.registerAccessibilityModeListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(accessibility, accessibility.registerAccessibilityModeListener);
    });

    it('should_handle_error_when_settings_getValueSync_throws_exception', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(settings, settings.getValueSync);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterThrow(new BusinessError('error'));

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(settings, settings.getValueSync);
    });

    it('should_register_accessibility_mode_listener_when_init_is_called01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibility, accessibility.registerAccessibilityModeListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(accessibility, accessibility.registerAccessibilityModeListener);
    });

    it('should_handle_error_when_settings_getValueSync_throws_exception01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(settings, settings.getValueSync);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterThrow(new BusinessError('error'));

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(settings, settings.getValueSync);
    });
    it('should_register_accessibility_mode_listener_when_init_is_called02', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibility, accessibility.registerAccessibilityModeListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(accessibility, accessibility.registerAccessibilityModeListener);
    });

    it('should_handle_error_when_settings_getValueSync_throws_exception02', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(settings, settings.getValueSync);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterThrow(new BusinessError('error'));

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(settings, settings.getValueSync);
    });
    it('should_register_accessibility_mode_listener_when_init_is_called03', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibility, accessibility.registerAccessibilityModeListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(accessibility, accessibility.registerAccessibilityModeListener);
    });

    it('should_handle_error_when_settings_getValueSync_throws_exception03', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(settings, settings.getValueSync);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterThrow(new BusinessError('error'));

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(settings, settings.getValueSync);
    });
    it('should_register_accessibility_mode_listener_when_init_is_called04', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibility, accessibility.registerAccessibilityModeListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(accessibility, accessibility.registerAccessibilityModeListener);
    });

    it('should_handle_error_when_settings_getValueSync_throws_exception04', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(settings, settings.getValueSync);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterThrow(new BusinessError('error'));

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(settings, settings.getValueSync);
    });
    it('should_register_accessibility_mode_listener_when_init_is_called05', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibility, accessibility.registerAccessibilityModeListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(accessibility, accessibility.registerAccessibilityModeListener);
    });

    it('should_handle_error_when_settings_getValueSync_throws_exception05', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(settings, settings.getValueSync);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterThrow(new BusinessError('error'));

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(settings, settings.getValueSync);
    });
    it('should_register_accessibility_mode_listener_when_init_is_called06', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibility, accessibility.registerAccessibilityModeListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(accessibility, accessibility.registerAccessibilityModeListener);
    });

    it('should_handle_error_when_settings_getValueSync_throws_exception06', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(settings, settings.getValueSync);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterThrow(new BusinessError('error'));

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(settings, settings.getValueSync);
    });
    it('should_register_accessibility_mode_listener_when_init_is_called07', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibility, accessibility.registerAccessibilityModeListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(accessibility, accessibility.registerAccessibilityModeListener);
    });

    it('should_handle_error_when_settings_getValueSync_throws_exception07', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(settings, settings.getValueSync);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterThrow(new BusinessError('error'));

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(settings, settings.getValueSync);
    });
    it('should_register_accessibility_mode_listener_when_init_is_called08', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibility, accessibility.registerAccessibilityModeListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(accessibility, accessibility.registerAccessibilityModeListener);
    });

    it('should_handle_error_when_settings_getValueSync_throws_exception08', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(settings, settings.getValueSync);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterThrow(new BusinessError('error'));

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(settings, settings.getValueSync);
    });
    it('should_register_accessibility_mode_listener_when_init_is_called09', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibility, accessibility.registerAccessibilityModeListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(accessibility, accessibility.registerAccessibilityModeListener);
    });

    it('should_handle_error_when_settings_getValueSync_throws_exception09', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(settings, settings.getValueSync);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterThrow(new BusinessError('error'));

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(settings, settings.getValueSync);
    });
    it('should_register_accessibility_mode_listener_when_init_is_called10', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibility, accessibility.registerAccessibilityModeListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(accessibility, accessibility.registerAccessibilityModeListener);
    });

    it('should_handle_error_when_settings_getValueSync_throws_exception10', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(settings, settings.getValueSync);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterThrow(new BusinessError('error'));

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(settings, settings.getValueSync);
    });
    it('should_register_accessibility_mode_listener_when_init_is_called11', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibility, accessibility.registerAccessibilityModeListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(accessibility, accessibility.registerAccessibilityModeListener);
    });

    it('should_handle_error_when_settings_getValueSync_throws_exception11', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(settings, settings.getValueSync);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterThrow(new BusinessError('error'));

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(settings, settings.getValueSync);
    });
    it('should_register_accessibility_mode_listener_when_init_is_called12', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibility, accessibility.registerAccessibilityModeListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(accessibility, accessibility.registerAccessibilityModeListener);
    });

    it('should_handle_error_when_settings_getValueSync_throws_exception12', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(settings, settings.getValueSync);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterThrow(new BusinessError('error'));

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(settings, settings.getValueSync);
    });
    it('should_register_accessibility_mode_listener_when_init_is_called13', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibility, accessibility.registerAccessibilityModeListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(accessibility, accessibility.registerAccessibilityModeListener);
    });

    it('should_handle_error_when_settings_getValueSync_throws_exception13', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(settings, settings.getValueSync);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterThrow(new BusinessError('error'));

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(settings, settings.getValueSync);
    });
    it('should_register_accessibility_mode_listener_when_init_is_called14', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibility, accessibility.registerAccessibilityModeListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(accessibility, accessibility.registerAccessibilityModeListener);
    });

    it('should_handle_error_when_settings_getValueSync_throws_exception14', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(settings, settings.getValueSync);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterThrow(new BusinessError('error'));

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(settings, settings.getValueSync);
    });
    it('should_register_accessibility_mode_listener_when_init_is_called15', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibility, accessibility.registerAccessibilityModeListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(accessibility, accessibility.registerAccessibilityModeListener);
    });

    it('should_handle_error_when_settings_getValueSync_throws_exception15', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(settings, settings.getValueSync);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterThrow(new BusinessError('error'));

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(settings, settings.getValueSync);
    });
    it('should_register_accessibility_mode_listener_when_init_is_called06', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibility, accessibility.registerAccessibilityModeListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(accessibility, accessibility.registerAccessibilityModeListener);
    });

    it('should_handle_error_when_settings_getValueSync_throws_exception06', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(settings, settings.getValueSync);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterThrow(new BusinessError('error'));

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(settings, settings.getValueSync);
    });
    it('should_register_accessibility_mode_listener_when_init_is_called06', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibility, accessibility.registerAccessibilityModeListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(accessibility, accessibility.registerAccessibilityModeListener);
    });

    it('should_handle_error_when_settings_getValueSync_throws_exception06', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(settings, settings.getValueSync);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterThrow(new BusinessError('error'));

      let context: ctx.Context = new ctx.Context();
      AccessibilityManager.init(context);

      mocker.ignoreMock(settings, settings.getValueSync);
    });

    it('should_register_accessibility_mode_listener_successfully', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let context: ctx.Context = new ctx.Context();
      let accessibilityManager: AccessibilityManager = new AccessibilityManager(context);
      accessibilityManager.registerAccessibilityModeListener();

      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_handle_error_when_refreshIsAccessibilityMode_throws_exception', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let context: ctx.Context = new ctx.Context();
      let accessibilityManager: AccessibilityManager = new AccessibilityManager(context);
      let mockRefreshFunc: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.refreshIsAccessibilityMode);
      when(mockRefreshFunc)().afterThrow("Error in refreshIsAccessibilityMode");

      accessibilityManager.registerAccessibilityModeListener();

      mocker.ignoreMock(logHelper, logHelper.error);
      mocker.ignoreMock(accessibilityManager, accessibilityManager.refreshIsAccessibilityMode);
    });

    it('should_handle_error_when_registerKeyObserver_throws_exception', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let context: ctx.Context = new ctx.Context();
      let accessibilityManager: AccessibilityManager = new AccessibilityManager(context);
      let mockRefreshFunc: Function = mocker.mockFunc(accessibilityManager, accessibilityManager.refreshIsAccessibilityMode);
      when(mockRefreshFunc)().afterReturnNothing();

      let mockRegisterFunc: Function = mocker.mockFunc(settings, settings.registerKeyObserver);
      when(mockRegisterFunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterThrow("Error in registerKeyObserver");

      accessibilityManager.registerAccessibilityModeListener();

      mocker.ignoreMock(logHelper, logHelper.error);
      mocker.ignoreMock(accessibilityManager, accessibilityManager.refreshIsAccessibilityMode);
      mocker.ignoreMock(settings, settings.registerKeyObserver);
    });
  });
}

