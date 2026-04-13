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
import appLock from '@hms.security.appLock';
import osAccount from '@ohos.account.osAccount';
import { Singleton } from '../../../main/ets/utils/Singleton';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { AppProtectedStatusVm } from '../../../main/ets/vm/AppProtectedStatusVm';
export default function AppProtectedStatusVmTest() {
  describe('isProtected_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_false_when_app_is_not_protected', 0, () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      const result = appprotectedstatusvm.isProtected("com.example.app", 1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_true_when_app_is_protected', 0, () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      appprotectedstatusvm.protectedAppSet.add("com.example.app_1");
      const result = appprotectedstatusvm.isProtected("com.example.app", 1);
      expect(result).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_false_when_app_is_protected_but_not_in_set', 0, () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      appprotectedstatusvm.protectedAppSet.add("com.example.app_2");
      const result = appprotectedstatusvm.isProtected("com.example.app", 1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_true_when_app_is_protected_and_in_set', 0, () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      appprotectedstatusvm.protectedAppSet.add("com.example.app_1");
      const result = appprotectedstatusvm.isProtected("com.example.app", 1);
      expect(result).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_false_when_app_is_not_protected_and_not_in_set', 0, () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      const result = appprotectedstatusvm.isProtected("com.example.app", 1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_init_protected_app_list_start', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_init_protected_app_list_end', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_error_when_init_protected_app_list_err', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_call_initUserId_when_init_protected_app_list_start', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_register_appProtectedStateChange_listener_when_init_protected_app_list_start', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_initProtectedStateMap_when_init_protected_app_list_start', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockfunc2: Function = mocker.mockFunc(appprotectedstatusvm, appprotectedstatusvm.initUserId);
      when(mockfunc2)().afterReturnNothing();
      let mockfunc3: Function = mocker.mockFunc(appprotectedstatusvm, appprotectedstatusvm.initProtectedStateMap);
      when(mockfunc3)().afterReturn(Promise.resolve());

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(appprotectedstatusvm, appprotectedstatusvm.initUserId);
      mocker.ignoreMock(appprotectedstatusvm, appprotectedstatusvm.initProtectedStateMap);
    });

    it('should_handle_error_when_init_protected_app_list_err', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_return_false_when_app_is_not_protected', 0, () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      const result = appprotectedstatusvm.isProtected("com.example.app", 1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_true_when_app_is_protected', 0, () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      appprotectedstatusvm.protectedAppSet.add("com.example.app_1");
      const result = appprotectedstatusvm.isProtected("com.example.app", 1);
      expect(result).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_false_when_app_is_protected_but_not_in_set', 0, () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      appprotectedstatusvm.protectedAppSet.add("com.example.app_2");
      const result = appprotectedstatusvm.isProtected("com.example.app", 1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_true_when_app_is_protected_and_in_set', 0, () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      appprotectedstatusvm.protectedAppSet.add("com.example.app_1");
      const result = appprotectedstatusvm.isProtected("com.example.app", 1);
      expect(result).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_false_when_app_is_not_protected_and_not_in_set', 0, () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      const result = appprotectedstatusvm.isProtected("com.example.app", 1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_init_protected_app_list_start', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_init_protected_app_list_end', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_error_when_init_protected_app_list_err', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_call_initUserId_when_init_protected_app_list_start', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_register_appProtectedStateChange_listener_when_init_protected_app_list_start', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_initProtectedStateMap_when_init_protected_app_list_start', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockfunc2: Function = mocker.mockFunc(appprotectedstatusvm, appprotectedstatusvm.initUserId);
      when(mockfunc2)().afterReturnNothing();
      let mockfunc3: Function = mocker.mockFunc(appprotectedstatusvm, appprotectedstatusvm.initProtectedStateMap);
      when(mockfunc3)().afterReturn(Promise.resolve());

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(appprotectedstatusvm, appprotectedstatusvm.initUserId);
      mocker.ignoreMock(appprotectedstatusvm, appprotectedstatusvm.initProtectedStateMap);
    });

    it('should_handle_error_when_init_protected_app_list_err', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_return_false_when_app_is_not_protected', 0, () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      const result = appprotectedstatusvm.isProtected("com.example.app", 1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_true_when_app_is_protected', 0, () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      appprotectedstatusvm.protectedAppSet.add("com.example.app_1");
      const result = appprotectedstatusvm.isProtected("com.example.app", 1);
      expect(result).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_false_when_app_is_protected_but_not_in_set', 0, () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      appprotectedstatusvm.protectedAppSet.add("com.example.app_2");
      const result = appprotectedstatusvm.isProtected("com.example.app", 1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_true_when_app_is_protected_and_in_set', 0, () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      appprotectedstatusvm.protectedAppSet.add("com.example.app_1");
      const result = appprotectedstatusvm.isProtected("com.example.app", 1);
      expect(result).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_false_when_app_is_not_protected_and_not_in_set', 0, () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      const result = appprotectedstatusvm.isProtected("com.example.app", 1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_init_protected_app_list_start', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_init_protected_app_list_end', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_error_when_init_protected_app_list_err', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_call_initUserId_when_init_protected_app_list_start', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_register_appProtectedStateChange_listener_when_init_protected_app_list_start', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_initProtectedStateMap_when_init_protected_app_list_start', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockfunc2: Function = mocker.mockFunc(appprotectedstatusvm, appprotectedstatusvm.initUserId);
      when(mockfunc2)().afterReturnNothing();
      let mockfunc3: Function = mocker.mockFunc(appprotectedstatusvm, appprotectedstatusvm.initProtectedStateMap);
      when(mockfunc3)().afterReturn(Promise.resolve());

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(appprotectedstatusvm, appprotectedstatusvm.initUserId);
      mocker.ignoreMock(appprotectedstatusvm, appprotectedstatusvm.initProtectedStateMap);
    });

    it('should_handle_error_when_init_protected_app_list_err', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_call_initProtectedStateMap_when_init_protected_app_list_start', 0, async () => {
      let appprotectedstatusvm: AppProtectedStatusVm = new AppProtectedStatusVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockfunc2: Function = mocker.mockFunc(appprotectedstatusvm, appprotectedstatusvm.initUserId);
      when(mockfunc2)().afterReturnNothing();
      let mockfunc3: Function = mocker.mockFunc(appprotectedstatusvm, appprotectedstatusvm.initProtectedStateMap);
      when(mockfunc3)().afterReturn(Promise.resolve());

      await appprotectedstatusvm.init();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(appprotectedstatusvm, appprotectedstatusvm.initUserId);
      mocker.ignoreMock(appprotectedstatusvm, appprotectedstatusvm.initProtectedStateMap);
    });

  });
}
