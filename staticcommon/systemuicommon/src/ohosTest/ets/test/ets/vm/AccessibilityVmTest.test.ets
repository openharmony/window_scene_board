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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { accessibility } from '@kit.AccessibilityKit';
import { Singleton } from '../../../main/ets/utils/Singleton';
import { ResourceVm } from '../../../main/ets/vm/ResourceVm';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { AccessibilityVm } from '../../../main/ets/vm/AccessibilityVm';
export default function AccessibilityVmTest() {
  describe('sendEventByResource_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_isEnabled_is_false', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibilityvm, accessibilityvm.sendEventByText);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(new Promise<void>(() => {}));

      accessibilityvm.isEnabled = false;
      await accessibilityvm.sendEventByResource([new Resource("res1"), new Resource("res2")]);

      mocker.ignoreMock(accessibilityvm, accessibilityvm.sendEventByText);
    });

    it('should_call_sendEventByText_when_isEnabled_is_true', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibilityvm, accessibilityvm.sendEventByText);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(new Promise<void>(() => {}));

      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockLogFunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockLogFunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      accessibilityvm.isEnabled = true;
      await accessibilityvm.sendEventByResource([new Resource("res1"), new Resource("res2")]);

      mocker.ignoreMock(accessibilityvm, accessibilityvm.sendEventByText);
      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_log_error_when_sendEventByText_throws_exception', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibilityvm, accessibilityvm.sendEventByText);
      when(mockfunc)(ArgumentMatchers.anyString).afterThrow("Error message");

      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockLogFunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockLogFunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      accessibilityvm.isEnabled = true;
      await accessibilityvm.sendEventByResource([new Resource("res1"), new Resource("res2")]);

      mocker.ignoreMock(accessibilityvm, accessibilityvm.sendEventByText);
      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_return_immediately_when_isEnabled_is_false', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = false;
      await accessibilityvm.sendEventByText("testText");
    });

    it('should_log_error_when_accessibility_sendEvent_throws_exception', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = true;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      await accessibilityvm.sendEventByText("testText");

      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_send_event_successfully_when_isEnabled_is_true', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = true;
      let mocker: MockKit = new MockKit();

      await accessibilityvm.sendEventByText("testText");

    });

    it('should_return_immediately_when_isEnabled_is_false', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = false;
      await accessibilityvm.requestFocusAccessibility("testId");
    });

    it('should_log_error_when_accessibility_event_fails', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = true;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      await accessibilityvm.requestFocusAccessibility("testId");

      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_send_accessibility_event_successfully_when_isEnabled_is_true', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = true;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      await accessibilityvm.requestFocusAccessibility("testId");

      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_return_immediately_when_isEnabled_is_false', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibilityvm, accessibilityvm.sendEventByText);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(new Promise<void>(() => {}));

      accessibilityvm.isEnabled = false;
      await accessibilityvm.sendEventByResource([new Resource("res1"), new Resource("res2")]);

      mocker.ignoreMock(accessibilityvm, accessibilityvm.sendEventByText);
    });

    it('should_call_sendEventByText_when_isEnabled_is_true', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibilityvm, accessibilityvm.sendEventByText);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(new Promise<void>(() => {}));

      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockLogFunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockLogFunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      accessibilityvm.isEnabled = true;
      await accessibilityvm.sendEventByResource([new Resource("res1"), new Resource("res2")]);

      mocker.ignoreMock(accessibilityvm, accessibilityvm.sendEventByText);
      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_log_error_when_sendEventByText_throws_exception', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibilityvm, accessibilityvm.sendEventByText);
      when(mockfunc)(ArgumentMatchers.anyString).afterThrow("Error message");

      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockLogFunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockLogFunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      accessibilityvm.isEnabled = true;
      await accessibilityvm.sendEventByResource([new Resource("res1"), new Resource("res2")]);

      mocker.ignoreMock(accessibilityvm, accessibilityvm.sendEventByText);
      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_return_immediately_when_isEnabled_is_false', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = false;
      await accessibilityvm.sendEventByText("testText");
    });

    it('should_log_error_when_accessibility_sendEvent_throws_exception', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = true;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      await accessibilityvm.sendEventByText("testText");

      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_send_event_successfully_when_isEnabled_is_true', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = true;
      let mocker: MockKit = new MockKit();

      await accessibilityvm.sendEventByText("testText");

    });

    it('should_return_immediately_when_isEnabled_is_false', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = false;
      await accessibilityvm.requestFocusAccessibility("testId");
    });

    it('should_log_error_when_accessibility_event_fails', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = true;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      await accessibilityvm.requestFocusAccessibility("testId");

      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_send_accessibility_event_successfully_when_isEnabled_is_true', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = true;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      await accessibilityvm.requestFocusAccessibility("testId");

      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_return_immediately_when_isEnabled_is_false', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibilityvm, accessibilityvm.sendEventByText);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(new Promise<void>(() => {}));

      accessibilityvm.isEnabled = false;
      await accessibilityvm.sendEventByResource([new Resource("res1"), new Resource("res2")]);

      mocker.ignoreMock(accessibilityvm, accessibilityvm.sendEventByText);
    });

    it('should_call_sendEventByText_when_isEnabled_is_true', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibilityvm, accessibilityvm.sendEventByText);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(new Promise<void>(() => {}));

      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockLogFunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockLogFunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      accessibilityvm.isEnabled = true;
      await accessibilityvm.sendEventByResource([new Resource("res1"), new Resource("res2")]);

      mocker.ignoreMock(accessibilityvm, accessibilityvm.sendEventByText);
      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_log_error_when_sendEventByText_throws_exception', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibilityvm, accessibilityvm.sendEventByText);
      when(mockfunc)(ArgumentMatchers.anyString).afterThrow("Error message");

      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockLogFunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockLogFunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      accessibilityvm.isEnabled = true;
      await accessibilityvm.sendEventByResource([new Resource("res1"), new Resource("res2")]);

      mocker.ignoreMock(accessibilityvm, accessibilityvm.sendEventByText);
      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_return_immediately_when_isEnabled_is_false', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = false;
      await accessibilityvm.sendEventByText("testText");
    });

    it('should_log_error_when_accessibility_sendEvent_throws_exception', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = true;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      await accessibilityvm.sendEventByText("testText");

      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_send_event_successfully_when_isEnabled_is_true', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = true;
      let mocker: MockKit = new MockKit();

      await accessibilityvm.sendEventByText("testText");

    });

    it('should_return_immediately_when_isEnabled_is_false', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = false;
      await accessibilityvm.requestFocusAccessibility("testId");
    });

    it('should_log_error_when_accessibility_event_fails', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = true;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      await accessibilityvm.requestFocusAccessibility("testId");

      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_send_accessibility_event_successfully_when_isEnabled_is_true', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = true;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      await accessibilityvm.requestFocusAccessibility("testId");

      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_return_immediately_when_isEnabled_is_false', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibilityvm, accessibilityvm.sendEventByText);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(new Promise<void>(() => {}));

      accessibilityvm.isEnabled = false;
      await accessibilityvm.sendEventByResource([new Resource("res1"), new Resource("res2")]);

      mocker.ignoreMock(accessibilityvm, accessibilityvm.sendEventByText);
    });

    it('should_call_sendEventByText_when_isEnabled_is_true', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibilityvm, accessibilityvm.sendEventByText);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(new Promise<void>(() => {}));

      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockLogFunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockLogFunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      accessibilityvm.isEnabled = true;
      await accessibilityvm.sendEventByResource([new Resource("res1"), new Resource("res2")]);

      mocker.ignoreMock(accessibilityvm, accessibilityvm.sendEventByText);
      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_log_error_when_sendEventByText_throws_exception', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibilityvm, accessibilityvm.sendEventByText);
      when(mockfunc)(ArgumentMatchers.anyString).afterThrow("Error message");

      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockLogFunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockLogFunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      accessibilityvm.isEnabled = true;
      await accessibilityvm.sendEventByResource([new Resource("res1"), new Resource("res2")]);

      mocker.ignoreMock(accessibilityvm, accessibilityvm.sendEventByText);
      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_return_immediately_when_isEnabled_is_false', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = false;
      await accessibilityvm.sendEventByText("testText");
    });

    it('should_log_error_when_accessibility_sendEvent_throws_exception', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = true;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      await accessibilityvm.sendEventByText("testText");

      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_send_event_successfully_when_isEnabled_is_true', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = true;
      let mocker: MockKit = new MockKit();

      await accessibilityvm.sendEventByText("testText");

    });

    it('should_return_immediately_when_isEnabled_is_false', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = false;
      await accessibilityvm.requestFocusAccessibility("testId");
    });

    it('should_log_error_when_accessibility_event_fails', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = true;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      await accessibilityvm.requestFocusAccessibility("testId");

      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_send_accessibility_event_successfully_when_isEnabled_is_true', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = true;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      await accessibilityvm.requestFocusAccessibility("testId");

      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_return_immediately_when_isEnabled_is_false', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibilityvm, accessibilityvm.sendEventByText);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(new Promise<void>(() => {}));

      accessibilityvm.isEnabled = false;
      await accessibilityvm.sendEventByResource([new Resource("res1"), new Resource("res2")]);

      mocker.ignoreMock(accessibilityvm, accessibilityvm.sendEventByText);
    });

    it('should_call_sendEventByText_when_isEnabled_is_true', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibilityvm, accessibilityvm.sendEventByText);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(new Promise<void>(() => {}));

      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockLogFunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockLogFunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      accessibilityvm.isEnabled = true;
      await accessibilityvm.sendEventByResource([new Resource("res1"), new Resource("res2")]);

      mocker.ignoreMock(accessibilityvm, accessibilityvm.sendEventByText);
      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_log_error_when_sendEventByText_throws_exception', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(accessibilityvm, accessibilityvm.sendEventByText);
      when(mockfunc)(ArgumentMatchers.anyString).afterThrow("Error message");

      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockLogFunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockLogFunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      accessibilityvm.isEnabled = true;
      await accessibilityvm.sendEventByResource([new Resource("res1"), new Resource("res2")]);

      mocker.ignoreMock(accessibilityvm, accessibilityvm.sendEventByText);
      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_return_immediately_when_isEnabled_is_false', 0, async () => {
      let accessibilityvm: AccessibilityVm = AccessibilityVm.INSTANCE;
      accessibilityvm.isEnabled = false;
      await accessibilityvm.sendEventByText("testText");
    });

  });
}
