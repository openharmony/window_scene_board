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

  });