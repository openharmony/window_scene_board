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

import { sensor } from '@kit.SensorServiceKit';
import { PCSysDialogManager } from '../../../../../../main/ets/pages/pc/PCSysDialogManager';
import {
  SysDialogZOrder,
  UiExtNodeAngle,
  GestureState,
  GestureConstant,
  RotateState,
  SysDialogParamsKey
} from '../../../../../../main/ets/common/Constants';
import SystemDialogController from '../../../../../../main/ets/controller/Controller';
import {
  DialogDataEvent,
  ISystemDialogData,
  ReceiveEventInfo
} from '../../../../../../main/ets/common/DialogDataEvent';
import { SystemDialogEventUtil, SystemDialogState } from '../../../../../../main/ets/common/SysDialogEventUtil';
import {
  BackPressPriority,
  baseStateMgr,
  DeviceHelper,
  EventConstants,
  EventManager,
  EvtBus,
  IState,
  localEventManager,
  LogDomain,
  LogHelper,
  OnStateChangeListener,
  StateType,
  SysDialogType,
  windowManager
} from '../../../../../../main/ets/BaseCommonIndex';
import { ResourceUtil } from '../../../../../../main/ets/common/ResourceUtil';
import { display } from '@kit.ArkUI';
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

export default function Test() {
  describe('registerBackPressListener_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_registerBackPressListener_when_registerBackPressListener_is_called', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let pcSysDialogManager: PCSysDialogManager = new PCSysDialogManager();
      pcSysDialogManager.registerBackPressListener(null, null);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_showInfo_when_unregisterBackPressListener_is_called', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      PCSysDialogManager.unregisterBackPressListener();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_sysDialogMgrPC_unregisterBackPressListener_when_unregisterBackPressListener_is_called', 0, () => {
      let mocker: MockKit = new MockKit();
      let pcSysDialogManager: PCSysDialogManager = PCSysDialogManager.INSTANCE;

      PCSysDialogManager.unregisterBackPressListener();

    });

    it('should_set_isOrientationLandscape_to_true_when_orientation_is_LANDSCAPE_or_LANDSCAPE_INVERTED', 0, () => {
      let mocker: MockKit = new MockKit();


      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();


      let pcssd: PCSysDialogManager = new PCSysDialogManager();
      pcssd.refreshOrientation();

      expect(pcssd.isOrientationLandscape).assertEqual(true);

      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_set_isOrientationLandscape_to_false_when_orientation_is_not_LANDSCAPE_or_LANDSCAPE_INVERTED', 0, () => {
      let mocker: MockKit = new MockKit();


      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();


      let pcssd: PCSysDialogManager = new PCSysDialogManager();
      pcssd.refreshOrientation();

      expect(pcssd.isOrientationLandscape).assertEqual(false);

      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_log_error_when_refreshOrientation_fails', 0, () => {
      let mocker: MockKit = new MockKit();


      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();


      let pcssd: PCSysDialogManager = new PCSysDialogManager();
      pcssd.refreshOrientation();

      expect(pcssd.isOrientationLandscape).assertEqual(false);

      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });


    it('should_return_immediately_when_not_super_fold_machine', 0, () => {
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(DeviceHelper, DeviceHelper.isBigScreenMachine))(ArgumentMatchers.any).afterReturn(false);

      let preProcessFromFoldDevice: () => void = () => {
        PCSCBSysDialog.preProcessFromFoldDevice();
      };

      expect(preProcessFromFoldDevice).assertNothing();

      mocker.ignoreMock(DeviceHelper, DeviceHelper.isBigScreenMachine);
    });

    it('should_execute_all_steps_when_super_fold_machine', 0, () => {
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(DeviceHelper, DeviceHelper.isBigScreenMachine))(ArgumentMatchers.any).afterReturn(true);

      let mockOnFoldStatusChangeListener: OnStateChangeListener = {
        onStateChanged: (state: IState) => {
        }
      };

      let mockRegisterStateChangeListener: Function = mocker.mockFunc(baseStateMgr, baseStateMgr.registerStateChangeListener);
      when(mockRegisterStateChangeListener)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(() => {});

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(() => {});

      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockShowError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(() => {});

      PCSCBSysDialog.preProcessFromFoldDevice();

      mocker.ignoreMock(DeviceHelper, DeviceHelper.isBigScreenMachine);
      mocker.ignoreMock(baseStateMgr, baseStateMgr.registerStateChangeListener);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_handle_error_when_registering_state_change_listener_fails', 0, () => {
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(DeviceHelper, DeviceHelper.isBigScreenMachine))(ArgumentMatchers.any).afterReturn(true);

      let mockOnFoldStatusChangeListener: OnStateChangeListener = {
        onStateChanged: (state: IState) => {
        }
      };

      let mockRegisterStateChangeListener: Function = mocker.mockFunc(baseStateMgr, baseStateMgr.registerStateChangeListener);
      when(mockRegisterStateChangeListener)(ArgumentMatchers.any, ArgumentMatchers.any).afterThrow("Error");

      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockShowError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(() => {});

      PCSCBSysDialog.preProcessFromFoldDevice();

      mocker.ignoreMock(DeviceHelper, DeviceHelper.isBigScreenMachine);
      mocker.ignoreMock(baseStateMgr, baseStateMgr.registerStateChangeListener);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_true_when_display_is_folded_or_half_folded', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockDisplay: display.Display = display.getDefaultDisplaySync();

      let result = PCSysDialogManager.isFoldedOrHalf();
      expect(result).assertEqual(true);

    });

    it('should_return_false_when_display_is_not_folded_or_half_folded', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockDisplay: display.Display = display.getDefaultDisplaySync();

      let result = PCSysDialogManager.isFoldedOrHalf();
      expect(result).assertEqual(false);

    });

    it('should_return_false_when_display_throws_error', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockDisplay: display.Display = display.getDefaultDisplaySync();

      let result = PCSysDialogManager.isFoldedOrHalf();
      expect(result).assertEqual(false);

    });

    it('should_log_error_when_sensor_on_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowError: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockShowError)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let sensorMock: sensor.SensorService = sensor.createSensorService();
      let errorMock: Error = new Error('Sensor error');
      when(mocker.mockFunc(sensorMock, sensorMock.on))(ArgumentMatchers.any, ArgumentMatchers.anyFunction, ArgumentMatchers.any).afterThrow(errorMock);

      let controller: SystemDialogController = new SystemDialogController();
      controller.registerKeyboardState();

      mocker.ignoreMock(logHelper, logHelper.showError);
      mocker.ignoreMock(sensorMock, sensorMock.on);
    });

    it('should_log_info_when_sensor_on_succeeds', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let sensorMock: sensor.SensorService = sensor.createSensorService();
      when(mocker.mockFunc(sensorMock, sensorMock.on))(ArgumentMatchers.any, ArgumentMatchers.anyFunction, ArgumentMatchers.any).afterReturnNothing();

      let controller: SystemDialogController = new SystemDialogController();
      controller.registerKeyboardState();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(sensorMock, sensorMock.on);
    });

    it('should_set_isKeyboardOn_to_true_when_sensor_data_is_valid', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let sensorMock: sensor.SensorService = sensor.createSensorService();
      let successMock: Function = (callback: Function) => {
        callback({ status: 1 << 2 }); // bit2为1，表示键盘在位
      };
      when(mocker.mockFunc(sensorMock, sensorMock.on))(ArgumentMatchers.any, ArgumentMatchers.anyFunction, ArgumentMatchers.any).afterAction(successMock);

      let controller: SystemDialogController = new SystemDialogController();
      controller.registerKeyboardState();

      expect(controller.isKeyboardOn).assertTrue();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(sensorMock, sensorMock.on);
    });

    it('should_set_isKeyboardOn_to_false_when_sensor_data_is_invalid', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let sensorMock: sensor.SensorService = sensor.createSensorService();
      let successMock: Function = (callback: Function) => {
        callback({ status: 0 }); // bit2为0，表示键盘不在位
      };
      when(mocker.mockFunc(sensorMock, sensorMock.on))(ArgumentMatchers.any, ArgumentMatchers.anyFunction, ArgumentMatchers.any).afterAction(successMock);

      let controller: SystemDialogController = new SystemDialogController();
      controller.registerKeyboardState();

      expect(controller.isKeyboardOn).assertFalse();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(sensorMock, sensorMock.on);
    });


    it('should_return_rotateHeight_when_isBigScreenMachine_is_false_and_isOrientationLandscape_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let deviceHelper: DeviceHelper = DeviceHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(deviceHelper, deviceHelper.isBigScreenMachine);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(deviceHelper, deviceHelper.isOrientationLandscape);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(false);

      let testObj: PCSysDialogManager = new PCSysDialogManager();
      testObj.rotateHeight = '100%';
      testObj.isFold = false;
      testObj.isKeyboardOn = false;

      const result = testObj.getRealHeight();
      expect(result).assertEqual('100%');

      mocker.ignoreMock(deviceHelper, deviceHelper.isBigScreenMachine);
      mocker.ignoreMock(deviceHelper, deviceHelper.isOrientationLandscape);
    });

    it('should_return_rotateHeight_when_isBigScreenMachine_is_true_and_isOrientationLandscape_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let deviceHelper: DeviceHelper = DeviceHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(deviceHelper, deviceHelper.isBigScreenMachine);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(deviceHelper, deviceHelper.isOrientationLandscape);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(false);

      let testObj: PCSysDialogManager = new PCSysDialogManager();
      testObj.rotateHeight = '50%';
      testObj.isFold = false;
      testObj.isKeyboardOn = false;

      const result = testObj.getRealHeight();
      expect(result).assertEqual('50%');

      mocker.ignoreMock(deviceHelper, deviceHelper.isBigScreenMachine);
      mocker.ignoreMock(deviceHelper, deviceHelper.isOrientationLandscape);
    });

    it('should_return_50_when_isBigScreenMachine_is_false_and_isOrientationLandscape_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let deviceHelper: DeviceHelper = DeviceHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(deviceHelper, deviceHelper.isBigScreenMachine);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(deviceHelper, deviceHelper.isOrientationLandscape);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(true);

      let testObj: PCSysDialogManager = new PCSysDialogManager();
      testObj.rotateHeight = '100%';
      testObj.isFold = false;
      testObj.isKeyboardOn = false;

      const result = testObj.getRealHeight();
      expect(result).assertEqual('50%');

      mocker.ignoreMock(deviceHelper, deviceHelper.isBigScreenMachine);
      mocker.ignoreMock(deviceHelper, deviceHelper.isOrientationLandscape);
    });

    it('should_return_50_when_isBigScreenMachine_is_true_and_isOrientationLandscape_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let deviceHelper: DeviceHelper = DeviceHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(deviceHelper, deviceHelper.isBigScreenMachine);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(deviceHelper, deviceHelper.isOrientationLandscape);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(true);

      let testObj: PCSysDialogManager = new PCSysDialogManager();
      testObj.rotateHeight = '100%';
      testObj.isFold = false;
      testObj.isKeyboardOn = false;

      const result = testObj.getRealHeight();
      expect(result).assertEqual('50%');

      mocker.ignoreMock(deviceHelper, deviceHelper.isBigScreenMachine);
      mocker.ignoreMock(deviceHelper, deviceHelper.isOrientationLandscape);
    });

    it('should_return_50_when_isBigScreenMachine_is_false_and_isKeyboardOn_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let deviceHelper: DeviceHelper = DeviceHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(deviceHelper, deviceHelper.isBigScreenMachine);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(deviceHelper, deviceHelper.isOrientationLandscape);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(false);

      let testObj: PCSysDialogManager = new PCSysDialogManager();
      testObj.rotateHeight = '100%';
      testObj.isFold = false;
      testObj.isKeyboardOn = true;

      const result = testObj.getRealHeight();
      expect(result).assertEqual('50%');

      mocker.ignoreMock(deviceHelper, deviceHelper.isBigScreenMachine);
      mocker.ignoreMock(deviceHelper, deviceHelper.isOrientationLandscape);
    });

    it('should_return_100_when_isBigScreenMachine_is_true_and_isKeyboardOn_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let deviceHelper: DeviceHelper = DeviceHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(deviceHelper, deviceHelper.isBigScreenMachine);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(deviceHelper, deviceHelper.isOrientationLandscape);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(false);

      let testObj: PCSysDialogManager = new PCSysDialogManager();
      testObj.rotateHeight = '100%';
      testObj.isFold = false;
      testObj.isKeyboardOn = true;

      const result = testObj.getRealHeight();
      expect(result).assertEqual('100%');

      mocker.ignoreMock(deviceHelper, deviceHelper.isBigScreenMachine);
      mocker.ignoreMock(deviceHelper, deviceHelper.isOrientationLandscape);
    });

    it('should_return_100_when_isBigScreenMachine_is_false_and_isFold_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let deviceHelper: DeviceHelper = DeviceHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(deviceHelper, deviceHelper.isBigScreenMachine);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(deviceHelper, deviceHelper.isOrientationLandscape);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(false);

      let testObj: PCSysDialogManager = new PCSysDialogManager();
      testObj.rotateHeight = '100%';
      testObj.isFold = true;
      testObj.isKeyboardOn = false;

      const result = testObj.getRealHeight();
      expect(result).assertEqual('100%');

      mocker.ignoreMock(deviceHelper, deviceHelper.isBigScreenMachine);
      mocker.ignoreMock(deviceHelper, deviceHelper.isOrientationLandscape);
    });



  });
}