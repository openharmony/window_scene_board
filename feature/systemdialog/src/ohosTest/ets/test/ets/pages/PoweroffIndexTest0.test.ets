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

    it('should_log_info_when_status_is_true', 0, () => {
      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      poweroffLayout.handleOffFindEnabledStatus(true);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_status_is_false', 0, () => {
      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      poweroffLayout.handleOffFindEnabledStatus(false);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_false_when_foldStatus_is_FOLD_STATUS_UNKNOWN', 0, () => {
      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      let result = poweroffLayout.getExpandVal(display.FoldStatus.FOLD_STATUS_UNKNOWN);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_foldStatus_is_FOLD_STATUS_FOLDED', 0, () => {
      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      let result = poweroffLayout.getExpandVal(display.FoldStatus.FOLD_STATUS_FOLDED);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_foldStatus_is_not_FOLD_STATUS_UNKNOWN_or_FOLD_STATUS_FOLDED', 0, () => {
      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      let result = poweroffLayout.getExpandVal(display.FoldStatus.FOLD_STATUS_EXPANDED);
      expect(result).assertEqual(true);
    });

    it('should_execute_when_display_is_foldable_and_not_small_fold_product_and_not_xt_product_type', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockDisplayIsFoldable: Function = mocker.mockFunc(display, display.isFoldable);
      let mockDeviceHelperIsSmallFoldProduct: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      let mockLayoutUtilsIsXTProductType: Function = mocker.mockFunc(LayoutUtils, LayoutUtils.isXTProductType);

      when(mockDisplayIsFoldable)().afterReturn(true);
      when(mockDeviceHelperIsSmallFoldProduct)().afterReturn(false);
      when(mockLayoutUtilsIsXTProductType)().afterReturn(false);

      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      poweroffLayout.aboutToAppear();

      mocker.ignoreMock(display, display.isFoldable);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      mocker.ignoreMock(LayoutUtils, LayoutUtils.isXTProductType);
    });

    it('should_execute_when_is_xt_product_type_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockLayoutUtilsIsXTProductType: Function = mocker.mockFunc(LayoutUtils, LayoutUtils.isXTProductType);

      when(mockLayoutUtilsIsXTProductType)().afterReturn(true);

      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      poweroffLayout.aboutToAppear();

      mocker.ignoreMock(LayoutUtils, LayoutUtils.isXTProductType);
    });

    it('should_execute_when_is_outer_home_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockLayoutUtilsIsXTProductType: Function = mocker.mockFunc(LayoutUtils, LayoutUtils.isXTProductType);

      when(mockLayoutUtilsIsXTProductType)().afterReturn(false);

      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      poweroffLayout.isOuterHome = true;
      poweroffLayout.aboutToAppear();

      mocker.ignoreMock(LayoutUtils, LayoutUtils.isXTProductType);
    });

    it('should_execute_when_display_throws_error_on_foldStatusChange', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockDisplayOn: Function = mocker.mockFunc(display, display.on);
      let mockLogHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);

      when(mockDisplayOn)('foldStatusChange', ArgumentMatchers.anyFunction).afterThrow('error');
      when(mockLogHelperError)('foldStatusChange on error', 'error').afterReturnNothing();

      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      poweroffLayout.aboutToAppear();

      mocker.ignoreMock(display, display.on);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_execute_when_poweroff_controller_throws_error_on_registerCommentEvent', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockPoweroffControllerRegisterCommentEvent: Function = mocker.mockFunc(poweroffController, poweroffController.registerCommentEvent);
      let mockLogHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);

      when(mockPoweroffControllerRegisterCommentEvent)().afterThrow('error');
      when(mockLogHelperError)('foldStatusChange on error', 'error').afterReturnNothing();

      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      poweroffLayout.aboutToAppear();

      mocker.ignoreMock(poweroffController, poweroffController.registerCommentEvent);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_execute_when_poweroff_controller_returns_true_for_isEmergencyOrThermalSafeMode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockPoweroffControllerGetEmergencyAndThermalSafeMode: Function = mocker.mockFunc(poweroffController, poweroffController.getEmergencyAndThermalSafeMode);

      when(mockPoweroffControllerGetEmergencyAndThermalSafeMode)().afterReturn(true);

      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      poweroffLayout.aboutToAppear();

      mocker.ignoreMock(poweroffController, poweroffController.getEmergencyAndThermalSafeMode);
    });

    it('should_execute_when_poweroff_controller_returns_false_for_isEmergencyOrThermalSafeMode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockPoweroffControllerGetEmergencyAndThermalSafeMode: Function = mocker.mockFunc(poweroffController, poweroffController.getEmergencyAndThermalSafeMode);

      when(mockPoweroffControllerGetEmergencyAndThermalSafeMode)().afterReturn(false);

      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      poweroffLayout.aboutToAppear();

      mocker.ignoreMock(poweroffController, poweroffController.getEmergencyAndThermalSafeMode);
    });

    it('should_execute_when_poweroff_controller_returns_true_for_isXTProductType', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockPoweroffControllerGetEmergencyAndThermalSafeMode: Function = mocker.mockFunc(poweroffController, poweroffController.getEmergencyAndThermalSafeMode);

      when(mockPoweroffControllerGetEmergencyAndThermalSafeMode)().afterReturn(false);

      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      poweroffLayout.aboutToAppear();

      mocker.ignoreMock(poweroffController, poweroffController.getEmergencyAndThermalSafeMode);
    });

    it('should_execute_when_poweroff_controller_returns_false_for_isXTProductType', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockPoweroffControllerGetEmergencyAndThermalSafeMode: Function = mocker.mockFunc(poweroffController, poweroffController.getEmergencyAndThermalSafeMode);

      when(mockPoweroffControllerGetEmergencyAndThermalSafeMode)().afterReturn(false);

      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      poweroffLayout.aboutToAppear();

      mocker.ignoreMock(poweroffController, poweroffController.getEmergencyAndThermalSafeMode);
    });

    it('should_execute_when_poweroff_controller_returns_true_for_isOuterHome', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockPoweroffControllerGetEmergencyAndThermalSafeMode: Function = mocker.mockFunc(poweroffController, poweroffController.getEmergencyAndThermalSafeMode);

      when(mockPoweroffControllerGetEmergencyAndThermalSafeMode)().afterReturn(false);

      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      poweroffLayout.aboutToAppear();

      mocker.ignoreMock(poweroffController, poweroffController.getEmergencyAndThermalSafeMode);
    });

    it('should_execute_when_poweroff_controller_returns_false_for_isOuterHome', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockPoweroffControllerGetEmergencyAndThermalSafeMode: Function = mocker.mockFunc(poweroffController, poweroffController.getEmergencyAndThermalSafeMode);

      when(mockPoweroffControllerGetEmergencyAndThermalSafeMode)().afterReturn(false);

      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      poweroffLayout.aboutToAppear();

      mocker.ignoreMock(poweroffController, poweroffController.getEmergencyAndThermalSafeMode);
    });
    it('should_log_info_and_unRegisterCommonEvent_when_isXTProductType_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let poweroffController: PoweroffController = PoweroffController.INSTANCE;
      let mockUnRegisterCommonEvent: Function = mocker.mockFunc(poweroffController, poweroffController.unRegisterCommonEvent);
      when(mockUnRegisterCommonEvent)().afterReturnNothing();

      let layoutUtils: LayoutUtils = LayoutUtils.INSTANCE;
      let mockIsXTProductType: Function = mocker.mockFunc(layoutUtils, layoutUtils.isXTProductType);
      when(mockIsXTProductType)().afterReturn(true);

      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      poweroffLayout.aboutToDisappear();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(poweroffController, poweroffController.unRegisterCommonEvent);
      mocker.ignoreMock(layoutUtils, layoutUtils.isXTProductType);
    });

    it('should_log_error_when_display_off_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowError: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let poweroffController: PoweroffController = PoweroffController.INSTANCE;
      let mockUnRegisterCommonEvent: Function = mocker.mockFunc(poweroffController, poweroffController.unRegisterCommonEvent);
      when(mockUnRegisterCommonEvent)().afterReturnNothing();

      let mockIsXTProductType: Function = mocker.mockFunc(layoutUtils, layoutUtils.isXTProductType);
      when(mockIsXTProductType)().afterReturn(false);

      let mockDisplay: display = display;
      let mockIsFoldable: Function = mocker.mockFunc(mockDisplay, mockDisplay.isFoldable);
      when(mockIsFoldable)().afterReturn(true);

      let mockDeviceHelper: DeviceHelper = DeviceHelper.INSTANCE;
      let mockIsSmallFoldProduct: Function = mocker.mockFunc(mockDeviceHelper, mockDeviceHelper.isSmallFoldProduct);
      when(mockIsSmallFoldProduct)().afterReturn(true);

      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      poweroffLayout.aboutToDisappear();

      mocker.ignoreMock(logHelper, logHelper.showError);
      mocker.ignoreMock(poweroffController, poweroffController.unRegisterCommonEvent);
      mocker.ignoreMock(layoutUtils, layoutUtils.isXTProductType);
      mocker.ignoreMock(mockDisplay, mockDisplay.isFoldable);
      mocker.ignoreMock(mockDeviceHelper, mockDeviceHelper.isSmallFoldProduct);
    });

    it('should_not_log_error_when_display_off_fails_but_isSmallFoldProduct_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowError: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let poweroffController: PoweroffController = PoweroffController.INSTANCE;
      let mockUnRegisterCommonEvent: Function = mocker.mockFunc(poweroffController, poweroffController.unRegisterCommonEvent);
      when(mockUnRegisterCommonEvent)().afterReturnNothing();

      let mockIsXTProductType: Function = mocker.mockFunc(layoutUtils, layoutUtils.isXTProductType);
      when(mockIsXTProductType)().afterReturn(false);

      let mockDisplay: display = display;
      let mockIsFoldable: Function = mocker.mockFunc(mockDisplay, mockDisplay.isFoldable);
      when(mockIsFoldable)().afterReturn(true);

      let mockDeviceHelper: DeviceHelper = DeviceHelper.INSTANCE;
      let mockIsSmallFoldProduct: Function = mocker.mockFunc(mockDeviceHelper, mockDeviceHelper.isSmallFoldProduct);
      when(mockIsSmallFoldProduct)().afterReturn(true);

      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      poweroffLayout.aboutToDisappear();

      mocker.ignoreMock(logHelper, logHelper.showError);
      mocker.ignoreMock(poweroffController, poweroffController.unRegisterCommonEvent);
      mocker.ignoreMock(layoutUtils, layoutUtils.isXTProductType);
      mocker.ignoreMock(mockDisplay, mockDisplay.isFoldable);
      mocker.ignoreMock(mockDeviceHelper, mockDeviceHelper.isSmallFoldProduct);
    });

    it('should_not_log_error_when_display_off_fails_but_isFoldable_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowError: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let poweroffController: PoweroffController = PoweroffController.INSTANCE;
      let mockUnRegisterCommonEvent: Function = mocker.mockFunc(poweroffController, poweroffController.unRegisterCommonEvent);
      when(mockUnRegisterCommonEvent)().afterReturnNothing();

      let mockIsXTProductType: Function = mocker.mockFunc(layoutUtils, layoutUtils.isXTProductType);
      when(mockIsXTProductType)().afterReturn(false);

      let mockDisplay: display = display;
      let mockIsFoldable: Function = mocker.mockFunc(mockDisplay, mockDisplay.isFoldable);
      when(mockIsFoldable)().afterReturn(false);

      let mockDeviceHelper: DeviceHelper = DeviceHelper.INSTANCE;
      let mockIsSmallFoldProduct: Function = mocker.mockFunc(mockDeviceHelper, mockDeviceHelper.isSmallFoldProduct);
      when(mockIsSmallFoldProduct)().afterReturn(false);

      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      poweroffLayout.aboutToDisappear();

      mocker.ignoreMock(logHelper, logHelper.showError);
      mocker.ignoreMock(poweroffController, poweroffController.unRegisterCommonEvent);
      mocker.ignoreMock(layoutUtils, layoutUtils.isXTProductType);
      mocker.ignoreMock(mockDisplay, mockDisplay.isFoldable);
      mocker.ignoreMock(mockDeviceHelper, mockDeviceHelper.isSmallFoldProduct);
    });

    it('should_log_info_when_status_is_true', 0, () => {
      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      poweroffLayout.handleOffFindEnabledStatus(true);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_status_is_false', 0, () => {
      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      poweroffLayout.handleOffFindEnabledStatus(false);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_return_false_when_foldStatus_is_FOLD_STATUS_UNKNOWN', 0, () => {
      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      let result = poweroffLayout.getExpandVal(display.FoldStatus.FOLD_STATUS_UNKNOWN);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_foldStatus_is_FOLD_STATUS_FOLDED', 0, () => {
      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      let result = poweroffLayout.getExpandVal(display.FoldStatus.FOLD_STATUS_FOLDED);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_foldStatus_is_not_FOLD_STATUS_UNKNOWN_or_FOLD_STATUS_FOLDED', 0, () => {
      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      let result = poweroffLayout.getExpandVal(display.FoldStatus.FOLD_STATUS_EXPANDED);
      expect(result).assertEqual(true);
    });

    it('should_log_info_when_status_is_true', 0, () => {
      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      poweroffLayout.handleOffFindEnabledStatus(true);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_status_is_false', 0, () => {
      let poweroffLayout: PoweroffLayout = new PoweroffLayout();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      poweroffLayout.handleOffFindEnabledStatus(false);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });