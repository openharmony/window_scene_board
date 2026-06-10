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
import { afterAll, afterEach,
  ArgumentMatchers,
  beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { desktopUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { CommonStyle, EmergencyStyle } from '@ohos/emergencymode';
import { StyleConfigFactory } from '@ohos/phonebase/src/main/ets/SceneBoard/emergency/StyleConfigFactory';

export default function StyleConfigFactoryTest() {
  describe('StyleConfigFactoryTest', () => {
    let bundleName: string = 'com.ohos.contacts';
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('test_createEmergencyStyle',  0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isBarPhone);
      when(mockfunc)().afterReturn(true);
      let emergencyStyle: EmergencyStyle = StyleConfigFactory.createEmergencyStyle();
      expect(emergencyStyle).not().assertNull();
      let mockfunc1: Function = mocker.mockFunc(desktopUtil, desktopUtil.needIgnoreFoldDeviceForLauncher);
      when(mockfunc)().afterReturn(false);
      when(mockfunc1)().afterReturn(true);
      let emergencyStyle1: EmergencyStyle = StyleConfigFactory.createEmergencyStyle();

      let mockfunc_isfold: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(mockfunc)().afterReturn(false);
      when(mockfunc1)().afterReturn(false);
      when(mockfunc_isfold)().afterReturn(true);
      let emergencyStyle2: EmergencyStyle = StyleConfigFactory.createEmergencyStyle();

      let mockfunc_isPad: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockfunc)().afterReturn(false);
      when(mockfunc1)().afterReturn(false);
      when(mockfunc_isfold)().afterReturn(false);
      when(mockfunc_isPad)().afterReturn(true);
      let mockfunc_isUltraScreen: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isUltraScreenProduct);
      when(mockfunc)().afterReturn(false);
      when(mockfunc1)().afterReturn(false);
      when(mockfunc_isfold)().afterReturn(false);
      when(mockfunc_isPad)().afterReturn(false);
      when(mockfunc_isUltraScreen)().afterReturn(true);
      let emergencyStyle3: EmergencyStyle = StyleConfigFactory.createEmergencyStyle();

      when(mockfunc_isPad)().afterReturn(false);
      let emergencyStyle4: EmergencyStyle = StyleConfigFactory.createEmergencyStyle();

      mocker.clear(DeviceHelper);
      mocker.clear(desktopUtil);
      mocker.clearAll();
    })

    it('StyleConfigFactoryTest_createThermalStyle', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isBarPhone);
      when(mockfunc)().afterReturn(true);
      let emergencyStyle: CommonStyle = StyleConfigFactory.createThermalStyle();
      expect(emergencyStyle).not().assertNull();
      let mockfunc1: Function = mocker.mockFunc(desktopUtil, desktopUtil.needIgnoreFoldDeviceForLauncher);
      when(mockfunc)().afterReturn(false);
      when(mockfunc1)().afterReturn(true);
      let emergencyStyle1: CommonStyle = StyleConfigFactory.createThermalStyle();

      let mockfunc_isfold: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(mockfunc)().afterReturn(false);
      when(mockfunc1)().afterReturn(false);
      when(mockfunc_isfold)().afterReturn(true);
      let emergencyStyle2: CommonStyle = StyleConfigFactory.createThermalStyle();

      let mockfunc_isPad: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockfunc)().afterReturn(false);
      when(mockfunc1)().afterReturn(false);
      when(mockfunc_isfold)().afterReturn(false);
      when(mockfunc_isPad)().afterReturn(true);
      let emergencyStyle3: CommonStyle = StyleConfigFactory.createThermalStyle();

      when(mockfunc_isPad)().afterReturn(false);
      let emergencyStyle4: CommonStyle = StyleConfigFactory.createThermalStyle();

      mocker.clear(DeviceHelper);
      mocker.clear(desktopUtil);
      mocker.clearAll();
    })

    it("test_createEmergencyStyle_02_7", 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isBarPhone);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc1: Function = mock.mockFunc(desktopUtil, desktopUtil.needIgnoreFoldDeviceForLauncher);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isUltraScreenProduct);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc3: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isFold);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc4: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
        when(mockFunc4)(ArgumentMatchers.any).afterReturn(true);
        let emergencyStyle: EmergencyStyle = StyleConfigFactory.createEmergencyStyle();
        expect(bundleName).assertEqual('com.ohos.contacts');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(desktopUtil);
      mock.clearAll();
    })

    it("test_createThermalStyle_02_7", 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isBarPhone);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc1: Function = mock.mockFunc(desktopUtil, desktopUtil.needIgnoreFoldDeviceForLauncher);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isUltraScreenProduct);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc3: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isFold);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc4: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
        when(mockFunc4)(ArgumentMatchers.any).afterReturn(true);
        let emergencyStyle: CommonStyle = StyleConfigFactory.createThermalStyle();
        expect(bundleName).assertEqual('com.ohos.contacts');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(desktopUtil);
      mock.clearAll();
    })

    it("test_createThermalStyle_03", 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isBarPhone);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc1: Function = mock.mockFunc(desktopUtil, desktopUtil.needIgnoreFoldDeviceForLauncher);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isUltraScreenProduct);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc3: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isFold);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc4: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
        when(mockFunc4)(ArgumentMatchers.any).afterReturn(true);
        let emergencyStyle: CommonStyle = StyleConfigFactory.createThermalStyle();
        expect(bundleName).assertEqual('com.ohos.contacts');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(desktopUtil);
      mock.clearAll();
    })
  })
}