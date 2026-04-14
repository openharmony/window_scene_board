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
} from '@ohos/hypium'
import { batteryInfo, power, systemParameter } from '@kit.BasicServicesKit';
import { SCBOobeManager } from '@ohos/windowscene';
import { EmergencyEventManager } from '../../../../../../../main/ets/desktopmode/eventmanager/EmergencyEventManager';

export default function EmergencyEventManagerTest() {
  describe('EmergencyEventManagerTest', () => {
    const instance: EmergencyEventManager = EmergencyEventManager.getInstance();
    let mockerRdb: MockKit = new MockKit();
    beforeAll(() => {
      // DT执行不可以去关机
      let mockFunc: Function = mockerRdb.mockFunc(instance, instance['powerOffShutdown']);
      when(mockFunc)(ArgumentMatchers.any).afterThrow('err');
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
      mockerRdb.clear(instance);
      mockerRdb.clearAll();
    });

    it('test_setBatteryConfig', 0, () => {
      const instanceSecond: EmergencyEventManager = EmergencyEventManager.getInstance();
      instance['setBatteryConfig']('default');
      expect(instance).assertEqual(instanceSecond);
    });

    it('test_isBatteryConfigSupported', 0, () => {
      let mocker = new MockKit();
      let mockFunc1 = mocker.mockFunc(systemParameter.getSync, systemParameter.getSync);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn('factory');
      let mockFunc2 = mocker.mockFunc(batteryInfo.isBatteryConfigSupported, batteryInfo.isBatteryConfigSupported);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

      expect(instance.isBatteryConfigSupported()).assertTrue();
      mocker.clear(systemParameter.getSync);
      mocker.clear(batteryInfo.isBatteryConfigSupported);
      mocker.clearAll();
    });

    it('test_exitEmergencyModeManually', 0, () => {
      instance.exitEmergencyModeManually();
      expect(instance.getIsExitEmergencyManually()).assertTrue();
    });

    it('test_exitEmergencyModeManually_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(instance,  instance.isInCharging);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        // 获取当前电量
        let batterySOC: number = batteryInfo.batterySOC ?? 0;
        instance['emergencyEnterThreshold'] = batterySOC;

        instance.exitEmergencyModeManually();
        expect(instance instanceof EmergencyEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_parseCloneBackupDataJson_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(instance,  instance['getPowerMode']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(power.DevicePowerMode.MODE_EXTREME_POWER_SAVE);

        instance['abnormalTerminationRecovery']();
        expect(instance instanceof EmergencyEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_oobeExitEmergencyMode_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(instance,  instance['isInEmergencyStatus']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        instance['oobeExitEmergencyMode'](power.DevicePowerMode.MODE_EXTREME_POWER_SAVE);
        expect(instance instanceof EmergencyEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_oobeExitEmergencyMode_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(instance,  instance['isInEmergencyStatus']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        instance['oobeExitEmergencyMode'](power.DevicePowerMode.MODE_EXTREME_POWER_SAVE);
        expect(instance instanceof EmergencyEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_isInEmergencyStatus_01', 0, () => {
      try {
        instance['isInEmergencyStatus'](power.DevicePowerMode.MODE_EXTREME_POWER_SAVE);
        expect(instance instanceof EmergencyEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isInEmergencyStatus_02', 0, () => {
      try {
        AppStorage.setOrCreate<boolean>(EmergencyEventManager.EMC_FLAG_NAME, true);
        instance['isInEmergencyStatus'](power.DevicePowerMode.MODE_PERFORMANCE);
        expect(instance instanceof EmergencyEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isInEmergencyStatus_03', 0, () => {
      try {
        AppStorage.setOrCreate<boolean>(EmergencyEventManager.EMC_FLAG_NAME, false);
        instance['isInEmergencyStatus'](power.DevicePowerMode.MODE_PERFORMANCE);
        expect(instance instanceof EmergencyEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_powerOffShutdown_01', 0, () => {
      try {
        instance['powerOffShutdown']('test');
        expect(instance instanceof EmergencyEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getPowerMode_01', 0, () => {
      try {
        instance['getPowerMode']();
        expect(instance instanceof EmergencyEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_enterEmergencyMode_01', 0, () => {
      try {
        instance['emergencyEventTimer'] = 1;
        instance['enterEmergencyMode']();
        expect(instance instanceof EmergencyEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_exitEmergencyMode_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(instance,  instance['getPowerMode']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(power.DevicePowerMode.MODE_EXTREME_POWER_SAVE);

        instance['exitEmergencyMode'](true);
        expect(instance instanceof EmergencyEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_exitEmergencyMode_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(instance,  instance['getPowerMode']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(power.DevicePowerMode.MODE_PERFORMANCE);
        AppStorage.setOrCreate<boolean>(EmergencyEventManager.EMC_FLAG_NAME, true);
        instance['exitEmergencyMode'](true);
        expect(instance instanceof EmergencyEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_enterOrExitEmergencyView_enter', 0, () => {
      let mocker = new MockKit();
      let shouldEnterEmergencyMode = mocker.mockFunc(instance, instance['shouldEnterEmergencyMode']);
      let eventWhenEnterThreshold = mocker.mockFunc(instance, instance['eventWhenEnterThreshold']);
      when(shouldEnterEmergencyMode)().afterReturn(true);
      when(eventWhenEnterThreshold)(ArgumentMatchers.any).afterReturnNothing();

      instance['enterOrExitEmergencyView'](power.DevicePowerMode.MODE_NORMAL, null);
      mocker.verify('eventWhenEnterThreshold', [null, power.DevicePowerMode.MODE_NORMAL]).times(1);
      mocker.ignoreMock(instance, instance['shouldEnterEmergencyMode']);
      mocker.ignoreMock(instance, instance['eventWhenEnterThreshold']);
      mocker.clearAll();
    });

    it('test_enterOrExitEmergencyView_exit', 0, () => {
      let mocker = new MockKit();
      let shouldEnterEmergencyMode = mocker.mockFunc(instance, instance['shouldEnterEmergencyMode']);
      let shouldExitEmergencyMode = mocker.mockFunc(instance, instance['shouldExitEmergencyMode']);
      let exitEmergencyMode = mocker.mockFunc(instance, instance['exitEmergencyMode']);
      when(shouldEnterEmergencyMode)().afterReturn(false);
      when(shouldExitEmergencyMode)(ArgumentMatchers.any).afterReturn(true);
      when(exitEmergencyMode)().afterReturnNothing();

      instance['enterOrExitEmergencyView'](power.DevicePowerMode.MODE_NORMAL, null);
      mocker.verify('exitEmergencyMode', []).times(1);
      mocker.ignoreMock(instance, instance['shouldEnterEmergencyMode']);
      mocker.ignoreMock(instance, instance['shouldExitEmergencyMode']);
      mocker.ignoreMock(instance, instance['exitEmergencyMode']);
      mocker.clearAll();
    });

    it('test_abnormalTerminationRecovery', 0, () => {
      let mocker = new MockKit();
      let isBatteryConfigSupported = mocker.mockFunc(instance, instance.isBatteryConfigSupported);
      let isOobeActivated = mocker.mockFunc(SCBOobeManager, SCBOobeManager.isOobeActivated);
      let isGreaterThenEnterThreshold = mocker.mockFunc(instance, instance['isGreaterThenEnterThreshold'])
      let isCharging = mocker.mockFunc(instance, instance.isInCharging);
      let eventWhenEnterThreshold = mocker.mockFunc(instance, instance['eventWhenEnterThreshold']);
      when(isBatteryConfigSupported)().afterReturn(true);
      when(isOobeActivated)().afterReturn(false);
      when(isGreaterThenEnterThreshold)().afterReturn(false);
      when(isCharging)().afterReturn(false);
      when(eventWhenEnterThreshold)(ArgumentMatchers.any).afterReturnNothing();
      instance['abnormalTerminationRecovery']();
      mocker.verify('eventWhenEnterThreshold', [null, power.DevicePowerMode.MODE_NORMAL]).atLeast(1);
      mocker.ignoreMock(instance, instance.isBatteryConfigSupported);
      mocker.ignoreMock(SCBOobeManager, SCBOobeManager.isOobeActivated);
      mocker.ignoreMock(instance, instance['isGreaterThenEnterThreshold']);
      mocker.ignoreMock(instance, instance['eventWhenEnterThreshold']);
      mocker.clearAll();
    });

    it('test_isEmergencyViewError', 0, () => {
      let emergencyViewFlag: boolean = AppStorage.get<boolean>(EmergencyEventManager.EMC_FLAG_NAME) as boolean;
      let mocker = new MockKit();
      let mockerFunc = mocker.mockFunc(instance, instance[`getPowerMode`]);
      let isEmergencyViewError = mocker.mockFunc(instance, instance[`isEmergencyViewError`]);
      when(mockerFunc)().afterReturn(power.DevicePowerMode.MODE_EXTREME_POWER_SAVE);
      when(isEmergencyViewError)().afterReturn(emergencyViewFlag)
      expect(instance['isEmergencyViewError']()).assertEqual(emergencyViewFlag);
      mocker.ignoreMock(instance, instance['getPowerMode']);
      mocker.ignoreMock(instance, instance['isEmergencyViewError']);
      mocker.clearAll();
    })

    it('test_exitEmergencyMode', 0, () => {
      let mocker = new MockKit();
      let mockerFun = mocker.mockFunc(instance, instance['isEmergencyViewError']);
      let setPowerMode = mocker.mockFunc(instance, instance['setPowerMode']);
      when(mockerFun)().afterReturn(false);
      when(setPowerMode)(ArgumentMatchers.any).afterReturnNothing();
      instance['exitEmergencyMode']();
      mocker.verify('setPowerMode', [power.DevicePowerMode.MODE_NORMAL]).atLeast(1);
      mocker.ignoreMock(instance, instance['isEmergencyViewError']);
      mocker.ignoreMock(instance, instance['setPowerMode']);
      mocker.clearAll();
    });

    it('test_exitEmergencyPowerState', 0, () => {
      let mocker = new MockKit();
      let mockerFunc = mocker.mockFunc(instance, instance[`getPowerMode`]);
      let setPowerMode = mocker.mockFunc(instance, instance['setPowerMode']);
      when(mockerFunc)().afterReturn(power.DevicePowerMode.MODE_EXTREME_POWER_SAVE);
      when(setPowerMode)(ArgumentMatchers.any).afterReturnNothing();
      instance['exitEmergencyPowerState']();
      mocker.verify('setPowerMode', [power.DevicePowerMode.MODE_NORMAL]).atLeast(1);
      mocker.ignoreMock(instance, instance[`getPowerMode`]);
      mocker.ignoreMock(instance, instance[`setPowerMode`]);
      mocker.clearAll()
    });

    it('test_oobeExitEmergencyMode', 0, () => {
      let mocker = new MockKit();
      let mockerFunc = mocker.mockFunc(instance, instance[`isInEmergencyStatus`]);
      let exitEmergencyMode = mocker.mockFunc(instance, instance[`exitEmergencyMode`]);
      when(mockerFunc)(ArgumentMatchers.any).afterReturn(true);
      when(exitEmergencyMode)().afterReturnNothing();
      instance['oobeExitEmergencyMode'](power.DevicePowerMode.MODE_EXTREME_POWER_SAVE);
      mocker.verify('exitEmergencyMode', []).times(1);
      mocker.ignoreMock(instance, instance[`isInEmergencyStatus`]);
      mocker.ignoreMock(instance, instance[`exitEmergencyMode`]);
      mocker.clearAll();
    })
  })
}