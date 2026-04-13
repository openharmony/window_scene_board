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
import { DeviceModeEnum, RotationConstants } from '@ohos/commonconstants';
import { DisplayEvent, SCBRotateChangeReason, SCBScreenProperty, SCBScreenSessionManager } from '@ohos/windowscene';
import { EmergencyThermalAppType } from '../../../main/ets/constants/DeviceModeType';
import { CutoutVm } from '../../../main/ets/statusbar/vm/CutoutVm';
import { InnerEventUtil } from '../../../main/ets/utils/InnerEventUtil';
import { Singleton } from '../../../main/ets/utils/Singleton';
import { display } from '@kit.ArkUI';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { CustomPromise } from '@ohos/frameworkwrapper';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { DeviceInfoVm } from '../../../main/ets/vm/DeviceInfoVm';
export default function DeviceInfoVmTest() {
  describe('isEmergencyMode_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

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
    
  });
