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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { hideBannerNtfContentObj } from '../main/ets/model/HideBannerNtfContentObj';
import swingability from '@ohos.swingability';
import { BusinessError } from '@kit.BasicServicesKit';
import { notificationCcmConfig, SystemUICommonUtil } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import { SmartNotificationUtil } from '@ohos/systemuicommon/src/main/ets/utils/SmartNotificationUtil';
import { NotificationExceptionCode } from '../main/ets/maintenance/NotificationExceptionCode';
import { StatisticsMaintenance } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsMaintenance';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { SwingTrackVm } from '../main/ets/model/SwingTrackVm';
export default function SwingTrackVmTest() {
  describe('register_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_when_swing_register_success', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertTrue();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
    });

    it('should_log_error_when_swing_register_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockFunc = mocker.mockFunc(swingability, swingability.on);
      when(mockFunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterThrow("Error");

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      mocker.ignoreMock(swingability, swingability.on);
    });

    it('should_log_crash_when_swing_register_throws_exception', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockFunc = mocker.mockFunc(swingability, swingability.on);
      when(mockFunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterThrow(new Error("Exception"));

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      mocker.ignoreMock(swingability, swingability.on);
    });

    it('should_log_info_when_swing_register_success', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertTrue();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
    });

    it('should_log_error_when_swing_register_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockFunc = mocker.mockFunc(swingability, swingability.on);
      when(mockFunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterThrow("Error");

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      mocker.ignoreMock(swingability, swingability.on);
    });

    it('should_log_crash_when_swing_register_throws_exception', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockFunc = mocker.mockFunc(swingability, swingability.on);
      when(mockFunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterThrow(new Error("Exception"));

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      mocker.ignoreMock(swingability, swingability.on);
    });
    it('should_log_info_when_swing_register_success', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertTrue();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
    });

    it('should_log_error_when_swing_register_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockFunc = mocker.mockFunc(swingability, swingability.on);
      when(mockFunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterThrow("Error");

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      mocker.ignoreMock(swingability, swingability.on);
    });

    it('should_log_crash_when_swing_register_throws_exception', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockFunc = mocker.mockFunc(swingability, swingability.on);
      when(mockFunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterThrow(new Error("Exception"));

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      mocker.ignoreMock(swingability, swingability.on);
    });
    it('should_log_info_when_swing_register_success', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertTrue();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
    });

    it('should_log_error_when_swing_register_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockFunc = mocker.mockFunc(swingability, swingability.on);
      when(mockFunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterThrow("Error");

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      mocker.ignoreMock(swingability, swingability.on);
    });

    it('should_log_crash_when_swing_register_throws_exception', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockFunc = mocker.mockFunc(swingability, swingability.on);
      when(mockFunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterThrow(new Error("Exception"));

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      mocker.ignoreMock(swingability, swingability.on);
    });
    it('should_log_info_when_swing_register_success', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertTrue();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
    });

    it('should_log_error_when_swing_register_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockFunc = mocker.mockFunc(swingability, swingability.on);
      when(mockFunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterThrow("Error");

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      mocker.ignoreMock(swingability, swingability.on);
    });

    it('should_log_crash_when_swing_register_throws_exception', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockFunc = mocker.mockFunc(swingability, swingability.on);
      when(mockFunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterThrow(new Error("Exception"));

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      mocker.ignoreMock(swingability, swingability.on);
    });
    it('should_log_info_when_swing_register_success', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertTrue();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
    });

    it('should_log_error_when_swing_register_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockFunc = mocker.mockFunc(swingability, swingability.on);
      when(mockFunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterThrow("Error");

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      mocker.ignoreMock(swingability, swingability.on);
    });

    it('should_log_crash_when_swing_register_throws_exception', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockFunc = mocker.mockFunc(swingability, swingability.on);
      when(mockFunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterThrow(new Error("Exception"));

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      mocker.ignoreMock(swingability, swingability.on);
    });
    it('should_log_info_when_swing_register_success', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertTrue();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
    });

    it('should_log_error_when_swing_register_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockFunc = mocker.mockFunc(swingability, swingability.on);
      when(mockFunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterThrow("Error");

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      mocker.ignoreMock(swingability, swingability.on);
    });

    it('should_log_crash_when_swing_register_throws_exception', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockFunc = mocker.mockFunc(swingability, swingability.on);
      when(mockFunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterThrow(new Error("Exception"));

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      mocker.ignoreMock(swingability, swingability.on);
    });
    it('should_log_info_when_swing_register_success', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertTrue();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
    });

    it('should_log_error_when_swing_register_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockFunc = mocker.mockFunc(swingability, swingability.on);
      when(mockFunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterThrow("Error");

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      mocker.ignoreMock(swingability, swingability.on);
    });

    it('should_log_crash_when_swing_register_throws_exception', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let hideBannerNtfContentObjMock: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      when(hideBannerNtfContentObjMock)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let swingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockFunc = mocker.mockFunc(swingability, swingability.on);
      when(mockFunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyObj).afterThrow(new Error("Exception"));

      swingTrackVm.register();

      expect(swingTrackVm.isRegistered).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.updateRegisterSwing);
      mocker.ignoreMock(swingability, swingability.on);
    });

  });
}