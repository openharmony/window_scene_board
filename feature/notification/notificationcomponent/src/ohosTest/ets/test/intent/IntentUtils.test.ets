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
import systemparameter from '@ohos.systemParameterEnhance';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import { NotificationConstants } from '../../../../main/ets/common/NotificationConstants';
import { osAccount } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import { NotificationExceptionCode } from '../../../../main/ets/maintenance/NotificationExceptionCode';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { IntentUtils } from '../../../../main/ets/intent/IntentUtils';
export default function IntentUtilsTest() {
  describe('isSupportSwing_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_systemparameter_getSync_returns_1', 0, () => {
      let mocker: MockKit = new MockKit();

      const result = IntentUtils.isSupportSwing();
      expect(result).assertEqual(true);

    });

    it('should_return_false_when_systemparameter_getSync_throws_error', 0, () => {
      let mocker: MockKit = new MockKit();

      const result = IntentUtils.isSupportSwing();
      expect(result).assertEqual(false);

    });

    it('should_return_false_when_systemparameter_getSync_returns_0', 0, () => {
      let mocker: MockKit = new MockKit();

      const result = IntentUtils.isSupportSwing();
      expect(result).assertEqual(false);

    });
  });

  describe('isSupportFace_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_false_when_isFaceEnrolled_throws_error', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(IntentUtils, IntentUtils.isFaceEnrolled);
      when(mockfunc)().afterThrow('err');

      const result = await IntentUtils.isSupportFace();
      expect(result).assertEqual(false);

      mocker.ignoreMock(IntentUtils, IntentUtils.isFaceEnrolled);
    });

    it('should_return_false_when_getSecureValue_returns_0', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc1)('face_bind_with_lock', '1').afterReturn('0');

      const result = await IntentUtils.isSupportFace();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_true_when_isFaceEnrolled_returns_true_and_getSecureValue_returns_1', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(IntentUtils, IntentUtils.isFaceEnrolled);
      when(mockfunc)().afterReturn(true);

      let mockfunc1: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc1)('face_bind_with_lock', '1').afterReturn('1');

      const result = await IntentUtils.isSupportFace();
      expect(result).assertEqual(true);

      mocker.ignoreMock(IntentUtils, IntentUtils.isFaceEnrolled);
      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_getSecureValue_returns_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(IntentUtils, IntentUtils.isFaceEnrolled);
      when(mockfunc)().afterReturn(true);

      let mockfunc1: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc1)('face_bind_with_lock', '1').afterReturn(null);

      const result = await IntentUtils.isSupportFace();
      expect(result).assertEqual(false);

      mocker.ignoreMock(IntentUtils, IntentUtils.isFaceEnrolled);
      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isFaceEnrolled_returns_false', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(IntentUtils, IntentUtils.isFaceEnrolled);
      when(mockfunc)().afterReturn(false);

      let mockfunc1: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc1)('face_bind_with_lock', '1').afterReturn('1');

      const result = await IntentUtils.isSupportFace();
      expect(result).assertEqual(false);

      mocker.ignoreMock(IntentUtils, IntentUtils.isFaceEnrolled);
      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });

    it('should_return_false_when_isFaceEnrolled_returns_true_and_getSecureValue_returns_0', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(IntentUtils, IntentUtils.isFaceEnrolled);
      when(mockfunc)().afterReturn(true);

      let mockfunc1: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockfunc1)('face_bind_with_lock', '1').afterReturn('0');

      const result = await IntentUtils.isSupportFace();
      expect(result).assertEqual(false);

      mocker.ignoreMock(IntentUtils, IntentUtils.isFaceEnrolled);
      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
    });
  });

  describe('getIntentAbilityContext_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_undefined_when_intentPageContext_is_not_found', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      const result = IntentUtils.getIntentAbilityContext();
      expect(result).assertUndefined();
      mocker.ignoreMock(AppStorage, AppStorage.get);
    });

    it('should_return_context_when_intentPageContext_is_found', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      let mockContext: common.UIAbilityContext = {} as common.UIAbilityContext;
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(mockContext);
      const result = IntentUtils.getIntentAbilityContext();
      expect(result).assertInstanceOf(common.UIAbilityContext);
      mocker.ignoreMock(AppStorage, AppStorage.get);
    });
  });

  describe('isFaceEnrolled_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_face_enrollment_is_successful', 0, async () => {
      let mocker: MockKit = new MockKit();
      let userIdentityManager: osAccount.UserIdentityManager = new osAccount.UserIdentityManager();
      let mockfunc: Function = mocker.mockFunc(userIdentityManager, userIdentityManager.getAuthInfo);
      let enrolledCredInfo: osAccount.EnrolledCredInfo = {
        "credType": 1,
        "credId": "123",
        "credName": "test"
      };
      let enrolledCredInfoArray: osAccount.EnrolledCredInfo[] = [enrolledCredInfo];
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(enrolledCredInfoArray));

      const result = await IntentUtils.isFaceEnrolled();
      expect(result).assertTrue();
      mocker.ignoreMock(userIdentityManager, userIdentityManager.getAuthInfo);
    });

    it('should_return_false_when_face_enrollment_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let userIdentityManager: osAccount.UserIdentityManager = new osAccount.UserIdentityManager();
      let mockfunc: Function = mocker.mockFunc(userIdentityManager, userIdentityManager.getAuthInfo);
      let enrolledCredInfoArray: osAccount.EnrolledCredInfo[] = [];
      when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(enrolledCredInfoArray));

      const result = await IntentUtils.isFaceEnrolled();
      expect(result).assertFalse();
      mocker.ignoreMock(userIdentityManager, userIdentityManager.getAuthInfo);
    });

    it('should_return_false_when_getAuthInfo_throws_error', 0, async () => {
      let mocker: MockKit = new MockKit();
      let userIdentityManager: osAccount.UserIdentityManager = new osAccount.UserIdentityManager();
      let mockfunc: Function = mocker.mockFunc(userIdentityManager, userIdentityManager.getAuthInfo);
      when(mockfunc)(ArgumentMatchers.any).afterThrow("Error");

      const result = await IntentUtils.isFaceEnrolled();
      expect(result).assertFalse();
      mocker.ignoreMock(userIdentityManager, userIdentityManager.getAuthInfo);
    });
  });
}