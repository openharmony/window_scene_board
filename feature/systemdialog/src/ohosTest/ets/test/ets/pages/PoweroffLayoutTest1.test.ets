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
import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import rpc from '@ohos.rpc';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import inputConsumer from '@ohos.multimodalInput.inputConsumer';
import PowerOffStyleConstants from '../../../main/ets/common/PoweroffStyleConstants';
import { poweroffController } from '../../../main/ets/controller/PoweroffController';
import { PowerOffSysEventUtil, ShutdownPanelState } from '../../../main/ets/common/PowerOffSysEventUtil';
import { PowerOffTaskPoolUtil } from '../../../main/ets/common/PowerOffTaskPoolUtil';
import { AnimationManager } from '../../../main/ets/common/AnimationManager';
import { accessibility } from '@kit.AccessibilityKit';
import { config } from '@kit.AccessibilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { PowerOnSchedule } from '../../../main/ets/pages/PowerOnSchedule';
import { DeviceHelper } from '../../../main/ets/BaseCommonIndex';
import { LogDomain, LogHelper } from '../../../main/ets/BaseCommonIndex';
import { CustomPromise } from '../../../main/ets/BaseCommonIndex';
import { ResourceUtil } from '../../../main/ets/common/ResourceUtil';
import { PowerOffFind } from '../../../main/ets/pages/PowerOffFind';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../main/ets/pages/PoweroffLayout';
import { PoweroffLayout } from '../../../../../main/ets/pages/PoweroffLayout';

export default function Test() {
  describe('handleConfirmPowerOff_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_connectServiceAbility_when_isCheckedPowerOn_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowWarn: Function = mocker.mockFunc(LogHelper, LogHelper.showWarn);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockShowWarn)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockIsFinished: CustomPromise = new CustomPromise();
      let mockIsFinishedResolver: Function = mockIsFinished.resolve;

      let powerOffTaskPoolUtilMock: PowerOffTaskPoolUtil = PowerOffTaskPoolUtil.create();
      let mockPowerOffTaskPoolUtil: Function = mocker.mockFunc(powerOffTaskPoolUtilMock, powerOffTaskPoolUtilMock.powerOff);
      when(mockPowerOffTaskPoolUtil)().afterReturnNothing();

      let powerOnScheduleMock: PowerOnSchedule = new PowerOnSchedule();
      powerOnScheduleMock.isCheckedPowerOn = false;
      powerOnScheduleMock.isFinished = mockIsFinished;

      await powerOnScheduleMock.handleConfirmPowerOff();

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showWarn);
      mocker.ignoreMock(powerOffTaskPoolUtilMock, powerOffTaskPoolUtilMock.powerOff);
    });

    it('should_not_call_connectServiceAbility_when_isCheckedPowerOn_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowWarn: Function = mocker.mockFunc(LogHelper, LogHelper.showWarn);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockShowWarn)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockIsFinished: CustomPromise = new CustomPromise();
      let mockIsFinishedResolver: Function = mockIsFinished.resolve;

      let powerOffTaskPoolUtilMock: PowerOffTaskPoolUtil = PowerOffTaskPoolUtil.create();
      let mockPowerOffTaskPoolUtil: Function = mocker.mockFunc(powerOffTaskPoolUtilMock, powerOffTaskPoolUtilMock.powerOff);
      when(mockPowerOffTaskPoolUtil)().afterReturnNothing();

      let powerOnScheduleMock: PowerOnSchedule = new PowerOnSchedule();
      powerOnScheduleMock.isCheckedPowerOn = true;
      powerOnScheduleMock.isFinished = mockIsFinished;

      await powerOnScheduleMock.handleConfirmPowerOff();

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showWarn);
      mocker.ignoreMock(powerOffTaskPoolUtilMock, powerOffTaskPoolUtilMock.powerOff);
    });

    it('should_call_PowerOffTaskPoolUtil_powerOff_when_isCheckedPowerOn_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowWarn: Function = mocker.mockFunc(LogHelper, LogHelper.showWarn);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockShowWarn)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockIsFinished: CustomPromise = new CustomPromise();
      let mockIsFinishedResolver: Function = mockIsFinished.resolve;

      let powerOffTaskPoolUtilMock: PowerOffTaskPoolUtil = PowerOffTaskPoolUtil.create();
      let mockPowerOffTaskPoolUtil: Function = mocker.mockFunc(powerOffTaskPoolUtilMock, powerOffTaskPoolUtilMock.powerOff);
      when(mockPowerOffTaskPoolUtil)().afterReturnNothing();

      let powerOnScheduleMock: PowerOnSchedule = new PowerOnSchedule();
      powerOnScheduleMock.isCheckedPowerOn = false;
      powerOnScheduleMock.isFinished = mockIsFinished;

      await powerOnScheduleMock.handleConfirmPowerOff();

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showWarn);
      mocker.ignoreMock(powerOffTaskPoolUtilMock, powerOffTaskPoolUtilMock.powerOff);
    });

    it('should_call_PowerOffTaskPoolUtil_powerOff_when_isCheckedPowerOn_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowWarn: Function = mocker.mockFunc(LogHelper, LogHelper.showWarn);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockShowWarn)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockIsFinished: CustomPromise = new CustomPromise();
      let mockIsFinishedResolver: Function = mockIsFinished.resolve;

      let powerOffTaskPoolUtilMock: PowerOffTaskPoolUtil = PowerOffTaskPoolUtil.create();
      let mockPowerOffTaskPoolUtil: Function = mocker.mockFunc(powerOffTaskPoolUtilMock, powerOffTaskPoolUtilMock.powerOff);
      when(mockPowerOffTaskPoolUtil)().afterReturnNothing();

      let powerOnScheduleMock: PowerOnSchedule = new PowerOnSchedule();
      powerOnScheduleMock.isCheckedPowerOn = true;
      powerOnScheduleMock.isFinished = mockIsFinished;

      await powerOnScheduleMock.handleConfirmPowerOff();

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showWarn);
      mocker.ignoreMock(powerOffTaskPoolUtilMock, powerOffTaskPoolUtilMock.powerOff);
    });

    it('should_set_customPopup_to_true_and_false_after_3000ms', 0, () => {
      let powerOnSchedule: PowerOnSchedule = new PowerOnSchedule();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(powerOnSchedule, powerOnSchedule.showToastTip);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      powerOnSchedule.showToastTip("test message");
      expect(powerOnSchedule.customPopup).assertEqual(true);
      PowerOffSysEventUtil.notifySystemEvent(PowerOffSysEventUtil.ShutdownPanelState, ShutdownPanelState.POWEROFF_COUNTDOWN);
      expect(powerOnSchedule.customPopup).assertEqual(false);
      mocker.ignoreMock(powerOnSchedule, powerOnSchedule.showToastTip);
    });

    it('should_set_customPopup_to_false_when_ PowerOffSysEventUtil_notifySystemEvent_is_called', 0, () => {
      let powerOnSchedule: PowerOnSchedule = new PowerOnSchedule();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(powerOnSchedule, powerOnSchedule.showToastTip);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      powerOnSchedule.showToastTip("test message");
      expect(powerOnSchedule.customPopup).assertEqual(true);
      PowerOffSysEventUtil.notifySystemEvent(PowerOffSysEventUtil.ShutdownPanelState, ShutdownPanelState.POWEROFF_COUNTDOWN);
      expect(powerOnSchedule.customPopup).assertEqual(false);
      mocker.ignoreMock(powerOnSchedule, powerOnSchedule.showToastTip);
    });

    it('should_set_customPopup_to_false_when_ PowerOffTaskPoolUtil_execute_is_called', 0, () => {
      let powerOnSchedule: PowerOnSchedule = new PowerOnSchedule();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(powerOnSchedule, powerOnSchedule.showToastTip);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      powerOnSchedule.showToastTip("test message");
      expect(powerOnSchedule.customPopup).assertEqual(true);
      PowerOffTaskPoolUtil.execute(() => {
        expect(powerOnSchedule.customPopup).assertEqual(false);
      });
      mocker.ignoreMock(powerOnSchedule, powerOnSchedule.showToastTip);
    });

    it('should_set_customPopup_to_false_when_ PowerOffTaskPoolUtil_execute_is_called_with_callback', 0, () => {
      let powerOnSchedule: PowerOnSchedule = new PowerOnSchedule();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(powerOnSchedule, powerOnSchedule.showToastTip);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      powerOnSchedule.showToastTip("test message");
      expect(powerOnSchedule.customPopup).assertEqual(true);
      PowerOffTaskPoolUtil.execute(() => {
        expect(powerOnSchedule.customPopup).assertEqual(false);
      }, () => {
        expect(powerOnSchedule.customPopup).assertEqual(false);
      });
      mocker.ignoreMock(powerOnSchedule, powerOnSchedule.showToastTip);
    });

    it('should_set_customPopup_to_false_when_ PowerOffTaskPoolUtil_execute_is_called_with_delay', 0, () => {
      let powerOnSchedule: PowerOnSchedule = new PowerOnSchedule();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(powerOnSchedule, powerOnSchedule.showToastTip);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      powerOnSchedule.showToastTip("test message");
      expect(powerOnSchedule.customPopup).assertEqual(true);
      PowerOffTaskPoolUtil.execute(() => {
        expect(powerOnSchedule.customPopup).assertEqual(false);
      }, 5000);
      mocker.ignoreMock(powerOnSchedule, powerOnSchedule.showToastTip);
    });

    it('should_set_customPopup_to_false_when_ PowerOffTaskPoolUtil_execute_is_called_with_delay_and_callback', 0, () => {
      let powerOnSchedule: PowerOnSchedule = new PowerOnSchedule();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(powerOnSchedule, powerOnSchedule.showToastTip);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      powerOnSchedule.showToastTip("test message");
      expect(powerOnSchedule.customPopup).assertEqual(true);
      PowerOffTaskPoolUtil.execute(() => {
        expect(powerOnSchedule.customPopup).assertEqual(false);
      }, 5000, () => {
        expect(powerOnSchedule.customPopup).assertEqual(false);
      });
      mocker.ignoreMock(powerOnSchedule, powerOnSchedule.showToastTip);
    });

    it('should_set_customPopup_to_false_when_ PowerOffTaskPoolUtil_execute_is_called_with_PowerOffTaskPoolUtil_Priority', 0, () => {
      let powerOnSchedule: PowerOnSchedule = new PowerOnSchedule();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(powerOnSchedule, powerOnSchedule.showToastTip);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      powerOnSchedule.showToastTip("test message");
      expect(powerOnSchedule.customPopup).assertEqual(true);
      PowerOffTaskPoolUtil.execute(() => {
        expect(powerOnSchedule.customPopup).assertEqual(false);
      }, PowerOffTaskPoolUtil.Priority.LOW);
      mocker.ignoreMock(powerOnSchedule, powerOnSchedule.showToastTip);
    });

    it('should_set_customPopup_to_false_when_ PowerOffTaskPoolUtil_execute_is_called_with_PowerOffTaskPoolUtil_Priority_and_callback', 0, () => {
      let powerOnSchedule: PowerOnSchedule = new PowerOnSchedule();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(powerOnSchedule, powerOnSchedule.showToastTip);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      powerOnSchedule.showToastTip("test message");
      expect(powerOnSchedule.customPopup).assertEqual(true);
      PowerOffTaskPoolUtil.execute(() => {
        expect(powerOnSchedule.customPopup).assertEqual(false);
      }, PowerOffTaskPoolUtil.Priority.LOW, () => {
        expect(powerOnSchedule.customPopup).assertEqual(false);
      });
      mocker.ignoreMock(powerOnSchedule, powerOnSchedule.showToastTip);
    });

    it('should_set_customPopup_to_false_when_ PowerOffTaskPoolUtil_execute_is_called_with_PowerOffTaskPoolUtil_Priority_and_delay', 0, () => {
      let powerOnSchedule: PowerOnSchedule = new PowerOnSchedule();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(powerOnSchedule, powerOnSchedule.showToastTip);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      powerOnSchedule.showToastTip("test message");
      expect(powerOnSchedule.customPopup).assertEqual(true);
      PowerOffTaskPoolUtil.execute(() => {
        expect(powerOnSchedule.customPopup).assertEqual(false);
      }, 5000, PowerOffTaskPoolUtil.Priority.LOW);
      mocker.ignoreMock(powerOnSchedule, powerOnSchedule.showToastTip);
    });


    it('should_log_info_and_set_isOffFindEnabled_when_status_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      poweroffLayout.handleOffFindEnabledStatus(true);

      expect(poweroffLayout.isOffFindEnabled).assertTrue();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_and_set_isOffFindEnabled_when_status_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      poweroffLayout.handleOffFindEnabledStatus(false);

      expect(poweroffLayout.isOffFindEnabled).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_phone_landscape_height_when_isPhoneLandscape_is_true', 0, () => {
      let context = getContext(this);
      let mocker: MockKit = new MockKit();
      let poweroffControllerMock: any = {};
      poweroffControllerMock.isPhoneLandscape = true;
      when(mocker.mockFunc(poweroffController, poweroffController.isPhoneLandscape))(ArgumentMatchers.any).afterReturn(poweroffControllerMock);
      let result = PowerOffFind.getMaxHeight();
      expect(result).assertEqual(PowerOffStyleConstants.POWEROFF_MAX_HEIGHT_PHONE_LANDSCAPE);
    });

    it('should_return_option_max_height_when_isPhoneLandscape_is_false', 0, () => {
      let context = getContext(this);
      let mocker: MockKit = new MockKit();
      let poweroffControllerMock: any = {};
      poweroffControllerMock.isPhoneLandscape = false;
      when(mocker.mockFunc(poweroffController, poweroffController.isPhoneLandscape))(ArgumentMatchers.any).afterReturn(poweroffControllerMock);
      let result = PowerOffFind.getMaxHeight();
      expect(result).assertEqual(PowerOffStyleConstants.POWEROFF_MAX_HEIGHT_OPTION);
    });


  });