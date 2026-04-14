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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import insightIntent from '@ohos.app.ability.insightIntent';
import { notificationCcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/NotificationCcmConfig';
import { IntentCodeConstants, NtfCheckIntentParam } from '../../../../main/ets/intent/IntentCodeConstant';
import { SmartNotificationUtil } from '@ohos/systemuicommon/src/main/ets/utils/SmartNotificationUtil';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { notificationManager } from '@kit.NotificationKit';
import { NotificationConfigEntity } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationCheckSettingUtils } from '../../../../main/ets/intent/NotificationCheckSettingUtils';
export default function NotificationCheckSettingUtilsTest() {
  describe('checkPageAvailable_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_success_when_isHiddenNtfEntrance_throws_error', 0, async () => {
      let appBundleName: string = "com.ohos.test";
      let mocker: MockKit = new MockKit();
      let mockIsHiddenNtfEntrance: Function = mocker.mockFunc(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
      when(mockIsHiddenNtfEntrance)(ArgumentMatchers.anyString).afterThrow("error");

      let mockLogInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockLogWarn: Function = mocker.mockFunc(LogHelper, LogHelper.showWarn);
      when(mockLogWarn)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      const result = NotificationCheckSettingUtils.checkPageAvailable(appBundleName);
      expect(result.code).assertEqual(IntentCodeConstants.SUCCESS);
      expect(result.result.isSupport).assertEqual(true);
      mocker.ignoreMock(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showWarn);
    });

    it('should_return_success_when_isHiddenNtfEntrance_returns_false', 0, async () => {
      let appBundleName: string = "com.ohos.test";
      let mocker: MockKit = new MockKit();
      let mockIsHiddenNtfEntrance: Function = mocker.mockFunc(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
      when(mockIsHiddenNtfEntrance)(ArgumentMatchers.anyString).afterReturn(false);

      let mockLogInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockLogWarn: Function = mocker.mockFunc(LogHelper, LogHelper.showWarn);
      when(mockLogWarn)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      const result = NotificationCheckSettingUtils.checkPageAvailable(appBundleName);
      expect(result.code).assertEqual(IntentCodeConstants.SUCCESS);
      expect(result.result.isSupport).assertEqual(true);
      mocker.ignoreMock(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showWarn);
    });

    it('should_return_success_when_isHiddenNtfEntrance_returns_true', 0, async () => {
      let appBundleName: string = "com.ohos.test";
      let mocker: MockKit = new MockKit();
      let mockIsHiddenNtfEntrance: Function = mocker.mockFunc(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
      when(mockIsHiddenNtfEntrance)(ArgumentMatchers.anyString).afterReturn(true);

      let mockLogInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockLogWarn: Function = mocker.mockFunc(LogHelper, LogHelper.showWarn);
      when(mockLogWarn)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      const result = NotificationCheckSettingUtils.checkPageAvailable(appBundleName);
      expect(result.code).assertEqual(IntentCodeConstants.SUCCESS);
      expect(result.result.isSupport).assertEqual(false);
      mocker.ignoreMock(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showWarn);
    });
  });
  describe('checkSettingItemAvailable_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_itemName_is_APP_NTF_CONFIG_HIDE_BANNER_CONTENT_and_isSupportSmartNtf_returns_true', 0, async () => {
      let itemName: string = NtfCheckIntentParam.APP_NTF_CONFIG_HIDE_BANNER_CONTENT;
      let appBundleName: string = 'testBundleName';
      let mocker: MockKit = new MockKit();
      let mockSmartNtfFunc: Function = mocker.mockFunc(SmartNotificationUtil, SmartNotificationUtil.isSupportSmartNtf);
      when(mockSmartNtfFunc)().afterReturn(true);
      const result = await NotificationCheckSettingUtils.checkSettingItemAvailable(itemName, appBundleName);
      expect(result.isSupport).assertEqual(true);
      mocker.ignoreMock(SmartNotificationUtil, SmartNotificationUtil.isSupportSmartNtf);
    });

    it('should_return_false_when_itemName_is_APP_NTF_CONFIG_HIDE_BANNER_CONTENT_and_isSupportSmartNtf_returns_false', 0, async () => {
      let itemName: string = NtfCheckIntentParam.APP_NTF_CONFIG_HIDE_BANNER_CONTENT;
      let appBundleName: string = 'testBundleName';
      let mocker: MockKit = new MockKit();
      let mockSmartNtfFunc: Function = mocker.mockFunc(SmartNotificationUtil, SmartNotificationUtil.isSupportSmartNtf);
      when(mockSmartNtfFunc)().afterReturn(false);
      const result = await NotificationCheckSettingUtils.checkSettingItemAvailable(itemName, appBundleName);
      expect(result.isSupport).assertEqual(false);
      mocker.ignoreMock(SmartNotificationUtil, SmartNotificationUtil.isSupportSmartNtf);
    });

    it('should_return_true_when_itemName_is_APP_NTF_NOTIFY_ALLOW_and_isHiddenNtfEntrance_returns_false', 0, async () => {
      let itemName: string = NtfCheckIntentParam.APP_NTF_NOTIFY_ALLOW;
      let appBundleName: string = 'testBundleName';
      let mocker: MockKit = new MockKit();
      let mockHiddenNtfFunc: Function = mocker.mockFunc(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
      when(mockHiddenNtfFunc)(ArgumentMatchers.anyString).afterReturn(false);
      const result = await NotificationCheckSettingUtils.checkSettingItemAvailable(itemName, appBundleName);
      expect(result.isSupport).assertEqual(true);
      mocker.ignoreMock(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
    });

    it('should_return_false_when_itemName_is_APP_NTF_NOTIFY_ALLOW_and_isHiddenNtfEntrance_returns_true', 0, async () => {
      let itemName: string = NtfCheckIntentParam.APP_NTF_NOTIFY_ALLOW;
      let appBundleName: string = 'testBundleName';
      let mocker: MockKit = new MockKit();
      let mockHiddenNtfFunc: Function = mocker.mockFunc(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
      when(mockHiddenNtfFunc)(ArgumentMatchers.anyString).afterReturn(true);
      const result = await NotificationCheckSettingUtils.checkSettingItemAvailable(itemName, appBundleName);
      expect(result.isSupport).assertEqual(false);
      mocker.ignoreMock(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
    });

    it('should_return_true_when_itemName_is_APP_NTF_NOTIFY_PINTOP_and_isHiddenNtfEntrance_returns_false', 0, async () => {
      let itemName: string = NtfCheckIntentParam.APP_NTF_NOTIFY_PINTOP;
      let appBundleName: string = 'testBundleName';
      let mocker: MockKit = new MockKit();
      let mockHiddenNtfFunc: Function = mocker.mockFunc(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
      when(mockHiddenNtfFunc)(ArgumentMatchers.anyString).afterReturn(false);
      const result = await NotificationCheckSettingUtils.checkSettingItemAvailable(itemName, appBundleName);
      expect(result.isSupport).assertEqual(true);
      mocker.ignoreMock(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
    });

    it('should_return_false_when_itemName_is_APP_NTF_NOTIFY_PINTOP_and_isHiddenNtfEntrance_returns_true', 0, async () => {
      let itemName: string = NtfCheckIntentParam.APP_NTF_NOTIFY_PINTOP;
      let appBundleName: string = 'testBundleName';
      let mocker: MockKit = new MockKit();
      let mockHiddenNtfFunc: Function = mocker.mockFunc(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
      when(mockHiddenNtfFunc)(ArgumentMatchers.anyString).afterReturn(true);
      const result = await NotificationCheckSettingUtils.checkSettingItemAvailable(itemName, appBundleName);
      expect(result.isSupport).assertEqual(false);
      mocker.ignoreMock(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
    });

    it('should_return_true_when_itemName_is_APP_NTF_NOTIFY_LOCK_SCREEN_and_isHiddenNtfEntrance_returns_false', 0, async () => {
      let itemName: string = NtfCheckIntentParam.APP_NTF_NOTIFY_LOCK_SCREEN;
      let appBundleName: string = 'testBundleName';
      let mocker: MockKit = new MockKit();
      let mockHiddenNtfFunc: Function = mocker.mockFunc(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
      when(mockHiddenNtfFunc)(ArgumentMatchers.anyString).afterReturn(false);
      const result = await NotificationCheckSettingUtils.checkSettingItemAvailable(itemName, appBundleName);
      expect(result.isSupport).assertEqual(true);
      mocker.ignoreMock(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
    });

    it('should_return_false_when_itemName_is_APP_NTF_NOTIFY_LOCK_SCREEN_and_isHiddenNtfEntrance_returns_true', 0, async () => {
      let itemName: string = NtfCheckIntentParam.APP_NTF_NOTIFY_LOCK_SCREEN;
      let appBundleName: string = 'testBundleName';
      let mocker: MockKit = new MockKit();
      let mockHiddenNtfFunc: Function = mocker.mockFunc(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
      when(mockHiddenNtfFunc)(ArgumentMatchers.anyString).afterReturn(true);
      const result = await NotificationCheckSettingUtils.checkSettingItemAvailable(itemName, appBundleName);
      expect(result.isSupport).assertEqual(false);
      mocker.ignoreMock(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
    });

    it('should_return_true_when_itemName_is_APP_NTF_NOTIFY_BANNER_and_isHiddenNtfEntrance_returns_false', 0, async () => {
      let itemName: string = NtfCheckIntentParam.APP_NTF_NOTIFY_BANNER;
      let appBundleName: string = 'testBundleName';
      let mocker: MockKit = new MockKit();
      let mockHiddenNtfFunc: Function = mocker.mockFunc(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
      when(mockHiddenNtfFunc)(ArgumentMatchers.anyString).afterReturn(false);
      const result = await NotificationCheckSettingUtils.checkSettingItemAvailable(itemName, appBundleName);
      expect(result.isSupport).assertEqual(true);
      mocker.ignoreMock(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
    });

    it('should_return_false_when_itemName_is_APP_NTF_NOTIFY_BANNER_and_isHiddenNtfEntrance_returns_true', 0, async () => {
      let itemName: string = NtfCheckIntentParam.APP_NTF_NOTIFY_BANNER;
      let appBundleName: string = 'testBundleName';
      let mocker: MockKit = new MockKit();
      let mockHiddenNtfFunc: Function = mocker.mockFunc(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
      when(mockHiddenNtfFunc)(ArgumentMatchers.anyString).afterReturn(false);
      const result = await NotificationCheckSettingUtils.checkSettingItemAvailable(itemName, appBundleName);
      expect(result.isSupport).assertEqual(true);
      mocker.ignoreMock(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
    });
  });

  describe('checkSpecificCategoryType_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_false_when_hiddenNtfEntrance_is_true_and_slotAvailable_is_false', 0, async () => {
      let appBundleName: string = "com.example.app";
      let category: number = 1;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(true);
      const result = await NotificationCheckSettingUtils.checkSpecificCategoryType(appBundleName, category);
      expect(result).assertEqual(false);
      mocker.ignoreMock(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
    });

    it('should_return_true_when_hiddenNtfEntrance_is_false_and_slotAvailable_is_true', 0, async () => {
      let appBundleName: string = "com.example.app";
      let category: number = 1;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(notificationManager, notificationManager.getSlotsByBundle);
      let slots: notificationManager.NotificationSlot[] = [{ notificationType: 1 }];
      when(mockfunc2)(ArgumentMatchers.anyObj).afterReturn(slots);
      const result = await NotificationCheckSettingUtils.checkSpecificCategoryType(appBundleName, category);
      expect(result).assertEqual(true);
      mocker.ignoreMock(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
      mocker.ignoreMock(notificationManager, notificationManager.getSlotsByBundle);
    });

    it('should_return_false_when_hiddenNtfEntrance_is_true_and_slotAvailable_is_true', 0, async () => {
      let appBundleName: string = "com.example.app";
      let category: number = 1;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(notificationManager, notificationManager.getSlotsByBundle);
      let slots: notificationManager.NotificationSlot[] = [{ notificationType: 1 }];
      when(mockfunc2)(ArgumentMatchers.anyObj).afterReturn(slots);
      const result = await NotificationCheckSettingUtils.checkSpecificCategoryType(appBundleName, category);
      expect(result).assertEqual(false);
      mocker.ignoreMock(notificationCcmConfig, notificationCcmConfig.isHiddenNtfEntrance);
      mocker.ignoreMock(notificationManager, notificationManager.getSlotsByBundle);
    });
  });
}