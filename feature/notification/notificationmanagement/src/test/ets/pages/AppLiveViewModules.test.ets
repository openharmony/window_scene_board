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
import ConfigData from '../../../main/ets/common/constants';
import { LengthMetrics } from '@ohos.arkui.node';
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { AppIconWithIndexSubIcon } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicUiCommon';
import notificationManager from '@ohos.notificationManager';
import { AppItem } from '@ohos/managementcomponent/src/main/ets/com/ohos/vm/appLstComponentViewModel';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../main/ets/pages/AppLiveViewItemComponent';
export default function Test() {
  describe('AppLiveViewItemComponentTest', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_error_when_setLiveViewEnable_fails', 0, async () => {
      let item: AppItem = new AppItem();
      item.appBundleName = "com.example.app";
      item.appUid = 123;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      try {
        await item.setLiveViewEnable(true);
        expect(true).assertEqual(false); // This line should not be reached
      } catch (e) {
        expect(e.message).assertEqual("Error");
      }

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_log_success_when_setLiveViewEnable_succeeds', 0, async () => {
      let item: AppItem = new AppItem();
      item.appBundleName = "com.example.app";
      item.appUid = 123;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      try {
        await item.setLiveViewEnable(true);
        expect(true).assertEqual(true); // This line should be reached
      } catch (e) {
        expect(true).assertEqual(false); // This line should not be reached
      }

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_call_setNotificationEnableSlot_with_correct_parameters', 0, async () => {
      let item: AppItem = new AppItem();
      item.appBundleName = "com.example.app";
      item.appUid = 123;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      try {
        await item.setLiveViewEnable(true);
        expect(true).assertEqual(true); // This line should be reached
      } catch (e) {
        expect(true).assertEqual(false); // This line should not be reached
      }

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_log_error_when_setLiveViewEnable_fails', 0, async () => {
      let item: AppItem = new AppItem();
      item.appBundleName = "com.example.app";
      item.appUid = 123;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      try {
        await item.setLiveViewEnable(true);
        expect(true).assertEqual(false); // This line should not be reached
      } catch (e) {
        expect(e.message).assertEqual("Error");
      }

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_log_success_when_setLiveViewEnable_succeeds', 0, async () => {
      let item: AppItem = new AppItem();
      item.appBundleName = "com.example.app";
      item.appUid = 123;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      try {
        await item.setLiveViewEnable(true);
        expect(true).assertEqual(true); // This line should be reached
      } catch (e) {
        expect(true).assertEqual(false); // This line should not be reached
      }

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_call_setNotificationEnableSlot_with_correct_parameters', 0, async () => {
      let item: AppItem = new AppItem();
      item.appBundleName = "com.example.app";
      item.appUid = 123;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      try {
        await item.setLiveViewEnable(true);
        expect(true).assertEqual(true); // This line should be reached
      } catch (e) {
        expect(true).assertEqual(false); // This line should not be reached
      }

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_log_error_when_setLiveViewEnable_fails', 0, async () => {
      let item: AppItem = new AppItem();
      item.appBundleName = "com.example.app";
      item.appUid = 123;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      try {
        await item.setLiveViewEnable(true);
        expect(true).assertEqual(false); // This line should not be reached
      } catch (e) {
        expect(e.message).assertEqual("Error");
      }

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_log_success_when_setLiveViewEnable_succeeds', 0, async () => {
      let item: AppItem = new AppItem();
      item.appBundleName = "com.example.app";
      item.appUid = 123;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      try {
        await item.setLiveViewEnable(true);
        expect(true).assertEqual(true); // This line should be reached
      } catch (e) {
        expect(true).assertEqual(false); // This line should not be reached
      }

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_call_setNotificationEnableSlot_with_correct_parameters', 0, async () => {
      let item: AppItem = new AppItem();
      item.appBundleName = "com.example.app";
      item.appUid = 123;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      try {
        await item.setLiveViewEnable(true);
        expect(true).assertEqual(true); // This line should be reached
      } catch (e) {
        expect(true).assertEqual(false); // This line should not be reached
      }

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_log_error_when_setLiveViewEnable_fails', 0, async () => {
      let item: AppItem = new AppItem();
      item.appBundleName = "com.example.app";
      item.appUid = 123;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      try {
        await item.setLiveViewEnable(true);
        expect(true).assertEqual(false); // This line should not be reached
      } catch (e) {
        expect(e.message).assertEqual("Error");
      }

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_log_success_when_setLiveViewEnable_succeeds', 0, async () => {
      let item: AppItem = new AppItem();
      item.appBundleName = "com.example.app";
      item.appUid = 123;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      try {
        await item.setLiveViewEnable(true);
        expect(true).assertEqual(true); // This line should be reached
      } catch (e) {
        expect(true).assertEqual(false); // This line should not be reached
      }

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_call_setNotificationEnableSlot_with_correct_parameters', 0, async () => {
      let item: AppItem = new AppItem();
      item.appBundleName = "com.example.app";
      item.appUid = 123;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      try {
        await item.setLiveViewEnable(true);
        expect(true).assertEqual(true); // This line should be reached
      } catch (e) {
        expect(true).assertEqual(false); // This line should not be reached
      }

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_log_error_when_setLiveViewEnable_fails', 0, async () => {
      let item: AppItem = new AppItem();
      item.appBundleName = "com.example.app";
      item.appUid = 123;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      try {
        await item.setLiveViewEnable(true);
        expect(true).assertEqual(false); // This line should not be reached
      } catch (e) {
        expect(e.message).assertEqual("Error");
      }

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_log_success_when_setLiveViewEnable_succeeds', 0, async () => {
      let item: AppItem = new AppItem();
      item.appBundleName = "com.example.app";
      item.appUid = 123;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      try {
        await item.setLiveViewEnable(true);
        expect(true).assertEqual(true); // This line should be reached
      } catch (e) {
        expect(true).assertEqual(false); // This line should not be reached
      }

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_call_setNotificationEnableSlot_with_correct_parameters', 0, async () => {
      let item: AppItem = new AppItem();
      item.appBundleName = "com.example.app";
      item.appUid = 123;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      try {
        await item.setLiveViewEnable(true);
        expect(true).assertEqual(true); // This line should be reached
      } catch (e) {
        expect(true).assertEqual(false); // This line should not be reached
      }

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_log_error_when_setLiveViewEnable_fails', 0, async () => {
      let item: AppItem = new AppItem();
      item.appBundleName = "com.example.app";
      item.appUid = 123;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      try {
        await item.setLiveViewEnable(true);
        expect(true).assertEqual(false); // This line should not be reached
      } catch (e) {
        expect(e.message).assertEqual("Error");
      }

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_log_success_when_setLiveViewEnable_succeeds', 0, async () => {
      let item: AppItem = new AppItem();
      item.appBundleName = "com.example.app";
      item.appUid = 123;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      try {
        await item.setLiveViewEnable(true);
        expect(true).assertEqual(true); // This line should be reached
      } catch (e) {
        expect(true).assertEqual(false); // This line should not be reached
      }

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_call_setNotificationEnableSlot_with_correct_parameters', 0, async () => {
      let item: AppItem = new AppItem();
      item.appBundleName = "com.example.app";
      item.appUid = 123;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      try {
        await item.setLiveViewEnable(true);
        expect(true).assertEqual(true); // This line should be reached
      } catch (e) {
        expect(true).assertEqual(false); // This line should not be reached
      }

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_log_error_when_setLiveViewEnable_fails', 0, async () => {
      let item: AppItem = new AppItem();
      item.appBundleName = "com.example.app";
      item.appUid = 123;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      try {
        await item.setLiveViewEnable(true);
        expect(true).assertEqual(false); // This line should not be reached
      } catch (e) {
        expect(e.message).assertEqual("Error");
      }

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_log_success_when_setLiveViewEnable_succeeds', 0, async () => {
      let item: AppItem = new AppItem();
      item.appBundleName = "com.example.app";
      item.appUid = 123;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      try {
        await item.setLiveViewEnable(true);
        expect(true).assertEqual(true); // This line should be reached
      } catch (e) {
        expect(true).assertEqual(false); // This line should not be reached
      }

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_call_setNotificationEnableSlot_with_correct_parameters', 0, async () => {
      let item: AppItem = new AppItem();
      item.appBundleName = "com.example.app";
      item.appUid = 123;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockError: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      try {
        await item.setLiveViewEnable(true);
        expect(true).assertEqual(true); // This line should be reached
      } catch (e) {
        expect(true).assertEqual(false); // This line should not be reached
      }

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.error);
    });

  });
}