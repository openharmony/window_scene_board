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
import { DeviceModeEnum, RotationConstants } from '@ohos/commonconstants';
import { DisplayEvent, SCBRotateChangeReason, SCBScreenProperty, SCBScreenSessionManager } from '@ohos/windowscene';
import { EmergencyThermalAppType } from '../../../main/ets/constants/DeviceModeType';
import { CutoutVm } from '../../../main/ets/statusbar/vm/CutoutVm';
import { InnerEventUtil } from '../../../main/ets/utils/InnerEventUtil';
import { Singleton } from '../../../main/ets/utils/Singleton';
import { display } from '@kit.ArkUI';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { CustomPromise } from '@ohos/frameworkwrapper';
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
import { DeviceInfoVm } from '../../../main/ets/vm/DeviceInfoVm';

export default function DeviceInfoVmTest() {
  describe('init_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_register_screen_rotate_change_callbacks_and_handle_display_event_successfully', 0, async () => {
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockRegisterScreenRotateChangeCallbacks: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().registerScreenRotateChangeCallbacks);
      when(mockRegisterScreenRotateChangeCallbacks)(ArgumentMatchers.anyFunction, ArgumentMatchers.anyNumber)
        .afterReturnNothing();

      let mockHandleDisplayEvent: Function = mocker.mockFunc(deviceinfovm, deviceinfovm.handleDisplayEvent);
      when(mockHandleDisplayEvent)(ArgumentMatchers.anyObj).afterReturnNothing();

      let mockLogHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockLogHelperError)(ArgumentMatchers.any).afterReturnNothing();

      deviceinfovm.init();

      expect(deviceinfovm.width).assertEqual(0);
      expect(deviceinfovm.height).assertEqual(0);
      expect(deviceinfovm.realRotateAngle).assertEqual(RotationConstants.ROTATION_90);
      expect(deviceinfovm.isLandscape).assertEqual(false);
      expect(deviceinfovm.isExpand).assertEqual(false);
      expect(deviceinfovm.deviceMode).assertEqual(DeviceModeEnum.BASE_MODE);
      expect(deviceinfovm.emergencyModelTrustAppList).assertDeepEquals([]);
      expect(deviceinfovm.verticalScreenWidth).assertEqual(0);
      expect(deviceinfovm.isPortraitMiddleCutout).assertEqual(true);

      mocker.ignoreMock(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().registerScreenRotateChangeCallbacks);
      mocker.ignoreMock(deviceinfovm, deviceinfovm.handleDisplayEvent);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_handle_display_event_and_register_screen_rotate_change_callbacks_with_error', 0, async () => {
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockRegisterScreenRotateChangeCallbacks: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().registerScreenRotateChangeCallbacks);
      when(mockRegisterScreenRotateChangeCallbacks)(ArgumentMatchers.anyFunction, ArgumentMatchers.anyNumber)
        .afterThrow("Error");

      let mockHandleDisplayEvent: Function = mocker.mockFunc(deviceinfovm, deviceinfovm.handleDisplayEvent);
      when(mockHandleDisplayEvent)(ArgumentMatchers.anyObj).afterReturnNothing();

      let mockLogHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.error);
      when(mockLogHelperError)([ArgumentMatchers.any]).afterReturnNothing();

      deviceinfovm.init();

      expect(deviceinfovm.width).assertEqual(0);
      expect(deviceinfovm.height).assertEqual(0);
      expect(deviceinfovm.realRotateAngle).assertEqual(RotationConstants.ROTATION_90);
      expect(deviceinfovm.isLandscape).assertEqual(false);
      expect(deviceinfovm.isExpand).assertEqual(false);
      expect(deviceinfovm.deviceMode).assertEqual(DeviceModeEnum.BASE_MODE);
      expect(deviceinfovm.emergencyModelTrustAppList).assertDeepEquals([]);
      expect(deviceinfovm.verticalScreenWidth).assertEqual(0);
      expect(deviceinfovm.isPortraitMiddleCutout).assertEqual(true);

      mocker.ignoreMock(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().registerScreenRotateChangeCallbacks);
      mocker.ignoreMock(deviceinfovm, deviceinfovm.handleDisplayEvent);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_call_SCBScreenSessionManager_unRegisterScreenRotateChangeCallbacks_when_unInit_is_called', 0,
      async () => {
        let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
        let mocker: MockKit = new MockKit();
        let scbScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
        let mockfunc: Function =
          mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.unRegisterScreenRotateChangeCallbacks);
        when(mockfunc)(ArgumentMatchers.anyFunction).afterReturnNothing();

        deviceinfovm.unInit();

        mocker.ignoreMock(scbScreenSessionManager, scbScreenSessionManager.unRegisterScreenRotateChangeCallbacks);
      });

    it('should_call_SCBScreenSessionManager_unRegisterScreenRotateChangeCallbacks_with_correct_parameters', 0,
      async () => {
        let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
        let mocker: MockKit = new MockKit();
        let scbScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
        let mockfunc: Function =
          mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.unRegisterScreenRotateChangeCallbacks);
        when(mockfunc)(ArgumentMatchers.anyFunction).afterReturnNothing();

        let callback: Function = (screenProperty: SCBScreenProperty, reason: SCBRotateChangeReason) => {
          expect(reason).assertEqual(SCBRotateChangeReason.UNSPECIFIED);
          expect(screenProperty).assertUndefined();
        };

        deviceinfovm.unInit();

        mocker.ignoreMock(scbScreenSessionManager, scbScreenSessionManager.unRegisterScreenRotateChangeCallbacks);
      });

    it('should_return_true_when_deviceMode_is_EMERGENCY_MODE', 0, () => {
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      deviceinfovm.deviceMode = DeviceModeEnum.EMERGENCY_MODE;
      expect(deviceinfovm.isEmergencyMode()).assertTrue();
    });

    it('should_return_true_when_deviceMode_is_THERMAL_SAFE_MODE', 0, () => {
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      deviceinfovm.deviceMode = DeviceModeEnum.THERMAL_SAFE_MODE;
      expect(deviceinfovm.isEmergencyMode()).assertTrue();
    });

    it('should_return_false_when_deviceMode_is_not_EMERGENCY_MODE_or_THERMAL_SAFE_MODE', 0, () => {
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      deviceinfovm.deviceMode = DeviceModeEnum.BASE_MODE;
      expect(deviceinfovm.isEmergencyMode()).assertFalse();
    });

    it('should_return_true_when_emergencyMode_is_false_and_bundleName_is_trusted', 0, () => {
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(deviceinfovm, deviceinfovm.isEmergencyMode);
      when(mockfunc)().afterReturn(false);
      const result = deviceinfovm.isShowNotification("trusted.bundle");
      expect(result).assertEqual(true);
      mocker.ignoreMock(deviceinfovm, deviceinfovm.isEmergencyMode);
    });

    it('should_return_true_when_emergencyMode_is_true_and_bundleName_is_trusted', 0, () => {
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(deviceinfovm, deviceinfovm.isEmergencyMode);
      when(mockfunc)().afterReturn(true);
      const result = deviceinfovm.isShowNotification("trusted.bundle");
      expect(result).assertEqual(true);
      mocker.ignoreMock(deviceinfovm, deviceinfovm.isEmergencyMode);
    });

    it('should_return_false_when_emergencyMode_is_true_and_bundleName_is_untrusted', 0, () => {
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(deviceinfovm, deviceinfovm.isEmergencyMode);
      when(mockfunc)().afterReturn(true);
      const result = deviceinfovm.isShowNotification("untrusted.bundle");
      expect(result).assertEqual(false);
      mocker.ignoreMock(deviceinfovm, deviceinfovm.isEmergencyMode);
    });

    it('should_return_true_when_emergencyMode_is_true_and_bundleName_is_null', 0, () => {
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(deviceinfovm, deviceinfovm.isEmergencyMode);
      when(mockfunc)().afterReturn(true);
      const result = deviceinfovm.isShowNotification(null);
      expect(result).assertEqual(true);
      mocker.ignoreMock(deviceinfovm, deviceinfovm.isEmergencyMode);
    });

    it('should_return_true_when_emergencyMode_is_false_and_bundleName_is_null', 0, () => {
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(deviceinfovm, deviceinfovm.isEmergencyMode);
      when(mockfunc)().afterReturn(false);
      const result = deviceinfovm.isShowNotification(null);
      expect(result).assertEqual(true);
      mocker.ignoreMock(deviceinfovm, deviceinfovm.isEmergencyMode);
    });

    it('should_return_true_when_emergencyMode_is_true_and_bundleName_is_empty', 0, () => {
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(deviceinfovm, deviceinfovm.isEmergencyMode);
      when(mockfunc)().afterReturn(true);
      const result = deviceinfovm.isShowNotification("");
      expect(result).assertEqual(true);
      mocker.ignoreMock(deviceinfovm, deviceinfovm.isEmergencyMode);
    });

    it('should_return_true_when_emergencyMode_is_false_and_bundleName_is_empty', 0, () => {
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(deviceinfovm, deviceinfovm.isEmergencyMode);
      when(mockfunc)().afterReturn(false);
      const result = deviceinfovm.isShowNotification("");
      expect(result).assertEqual(true);
      mocker.ignoreMock(deviceinfovm, deviceinfovm.isEmergencyMode);
    });

    it('should_return_true_when_emergencyMode_is_true_and_bundleName_is_undefined', 0, () => {
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(deviceinfovm, deviceinfovm.isEmergencyMode);
      when(mockfunc)().afterReturn(true);
      const result = deviceinfovm.isShowNotification(undefined);
      expect(result).assertEqual(true);
      mocker.ignoreMock(deviceinfovm, deviceinfovm.isEmergencyMode);
    });

    it('should_return_true_when_emergencyMode_is_false_and_bundleName_is_undefined', 0, () => {
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(deviceinfovm, deviceinfovm.isEmergencyMode);
      when(mockfunc)().afterReturn(false);
      const result = deviceinfovm.isShowNotification(undefined);
      expect(result).assertEqual(true);
      mocker.ignoreMock(deviceinfovm, deviceinfovm.isEmergencyMode);
    });

    it('should_return_true_when_emergencyMode_is_true_and_bundleName_is_not_in_trusted_list', 0, () => {
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(deviceinfovm, deviceinfovm.isEmergencyMode);
      when(mockfunc)().afterReturn(true);
      deviceinfovm.emergencyModelTrustAppList = ["trusted.bundle1", "trusted.bundle2"];
      const result = deviceinfovm.isShowNotification("untrusted.bundle");
      expect(result).assertEqual(false);
      mocker.ignoreMock(deviceinfovm, deviceinfovm.isEmergencyMode);
    });

    it('should_return_true_when_emergencyMode_is_false_and_bundleName_is_not_in_trusted_list', 0, () => {
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(deviceinfovm, deviceinfovm.isEmergencyMode);
      when(mockfunc)().afterReturn(false);
      deviceinfovm.emergencyModelTrustAppList = ["trusted.bundle1", "trusted.bundle2"];
      const result = deviceinfovm.isShowNotification("untrusted.bundle");
      expect(result).assertEqual(true);
      mocker.ignoreMock(deviceinfovm, deviceinfovm.isEmergencyMode);
    });

    it('should_return_true_when_emergencyMode_is_true_and_trusted_list_is_empty', 0, () => {
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(deviceinfovm, deviceinfovm.isEmergencyMode);
      when(mockfunc)().afterReturn(true);
      deviceinfovm.emergencyModelTrustAppList = [];
      const result = deviceinfovm.isShowNotification("untrusted.bundle");
      expect(result).assertEqual(true);
      mocker.ignoreMock(deviceinfovm, deviceinfovm.isEmergencyMode);
    });

    it('should_log_info_when_set_device_mode_called', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      deviceinfovm.setDeviceMode(DeviceModeEnum.BASE_MODE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_device_mode_and_log_info', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      deviceinfovm.setDeviceMode(DeviceModeEnum.BASE_MODE);

      expect(deviceinfovm.deviceMode).assertEqual(DeviceModeEnum.BASE_MODE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_device_mode_and_call_begin_rotation_when_reason_is_rotate_begin', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      let mockBeginRotation: Function = mocker.mockFunc(deviceinfovm, deviceinfovm.beginRotation);
      when(mockBeginRotation)().afterReturnNothing();

      deviceinfovm.setDeviceMode(DeviceModeEnum.BASE_MODE);
      deviceinfovm.onRegisterRotateChangeEvent({
        rotation: RotationConstants.ROTATION_90
      } as SCBScreenProperty, SCBRotateChangeReason.ROTATE_BEGIN);

      expect(deviceinfovm.deviceMode).assertEqual(DeviceModeEnum.BASE_MODE);
      expect(deviceinfovm.realRotateAngle).assertEqual(RotationConstants.ROTATION_90);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(deviceinfovm, deviceinfovm.beginRotation);
    });

    it('should_set_device_mode_and_call_end_rotation_when_reason_is_rotate_end', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      let mockEndRotation: Function = mocker.mockFunc(deviceinfovm, deviceinfovm.endRotation);
      when(mockEndRotation)().afterReturnNothing();

      deviceinfovm.setDeviceMode(DeviceModeEnum.BASE_MODE);
      deviceinfovm.onRegisterRotateChangeEvent({
        rotation: RotationConstants.ROTATION_90
      } as SCBScreenProperty, SCBRotateChangeReason.ROTATE_END);

      expect(deviceinfovm.deviceMode).assertEqual(DeviceModeEnum.BASE_MODE);
      expect(deviceinfovm.realRotateAngle).assertEqual(RotationConstants.ROTATION_90);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(deviceinfovm, deviceinfovm.endRotation);
    });

    it('should_set_device_mode_and_call_update_expand_status_when_device_mode_is_ heated_ventilation', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      deviceinfovm.setDeviceMode(DeviceModeEnum.HEATED_VENTILATION);

      expect(deviceinfovm.deviceMode).assertEqual(DeviceModeEnum.HEATED_VENTILATION);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_device_mode_and_call_update_expand_status_when_device_mode_is_ heating', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      deviceinfovm.setDeviceMode(DeviceModeEnum.HEATING);

      expect(deviceinfovm.deviceMode).assertEqual(DeviceModeEnum.HEATING);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_device_mode_and_call_update_expand_status_when_device_mode_is_ ventilation', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      deviceinfovm.setDeviceMode(DeviceModeEnum.VENTILATION);

      expect(deviceinfovm.deviceMode).assertEqual(DeviceModeEnum.VENTILATION);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_device_mode_and_call_update_expand_status_when_device_mode_is_ mechanical_ventilation', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      deviceinfovm.setDeviceMode(DeviceModeEnum.MECHANICAL_VENTILATION);

      expect(deviceinfovm.deviceMode).assertEqual(DeviceModeEnum.MECHANICAL_VENTILATION);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_device_mode_and_call_update_expand_status_when_device_mode_is_ mechanical_ventilation_2', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      deviceinfovm.setDeviceMode(DeviceModeEnum.mechanicalVentilation);
      expect(deviceinfovm.deviceMode).assertEqual(DeviceModeEnum.MECHANICAL_VENTILATION);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_emergency_app_list_when_input_is_valid', 0, () => {
      let emergencyAppList: EmergencyThermalAppType[] = [
        { appItem: { bundleName: 'com.example.app1' } },
        { appItem: { bundleName: 'com.example.app2' } }
      ];
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      deviceinfovm.setEmergencyAppList(emergencyAppList);
      expect(deviceinfovm.emergencyModelTrustAppList).assertDeepEquals(['com.example.app1', 'com.example.app2']);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_empty_emergency_app_list_when_input_is_null', 0, () => {
      let emergencyAppList: EmergencyThermalAppType[] = null;
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      deviceinfovm.setEmergencyAppList(emergencyAppList);
      expect(deviceinfovm.emergencyModelTrustAppList).assertDeepEquals([]);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_setting_emergency_app_list', 0, () => {
      let emergencyAppList: EmergencyThermalAppType[] = [
        { appItem: { bundleName: 'com.example.app1' } },
        { appItem: { bundleName: 'com.example.app2' } }
      ];
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      deviceinfovm.setEmergencyAppList(emergencyAppList);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_update_device_info_when_display_event_is_handled', 0, () => {
      let emergencyAppList: EmergencyThermalAppType[] = [
        { appItem: { bundleName: 'com.example.app1' } },
        { appItem: { bundleName: 'com.example.app2' } }
      ];
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      deviceinfovm.setEmergencyAppList(emergencyAppList);
      let displayEvent: DisplayEvent = {
        display: {
          bounds: { width: 100, height: 200 },
          scbScreenProperty: { rotation: 0 }
        }
      };
      deviceinfovm.handleDisplayEvent(displayEvent);
      expect(deviceinfovm.width).assertEqual(100);
      expect(deviceinfovm.height).assertEqual(200);
      expect(deviceinfovm.realRotateAngle).assertEqual(0);
      expect(deviceinfovm.isLandscape).assertEqual(false);
      expect(deviceinfovm.verticalScreenWidth).assertEqual(0);
      expect(deviceinfovm.orientation).assertEqual(display.Orientation.PORTRAIT);
      expect(deviceinfovm.isPortraitMiddleCutout).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_update_device_info_when_rotate_event_is_handled', 0, () => {
      let emergencyAppList: EmergencyThermalAppType[] = [
        { appItem: { bundleName: 'com.example.app1' } },
        { appItem: { bundleName: 'com.example.app2' } }
      ];
      let deviceinfovm: DeviceInfoVm = DeviceInfoVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      deviceinfovm.setEmergencyAppList(emergencyAppList);
      let screenProperty: SCBScreenProperty = { rotation: 90 };
      let reason: SCBRotateChangeReason = SCBRotateChangeReason.ROTATE_BEGIN;
      deviceinfovm.onRegisterRotateChangeEvent(screenProperty, reason);
      expect(deviceinfovm.realRotateAngle).assertEqual(90);
      expect(deviceinfovm.orientationReason).assertEqual(reason);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });
}