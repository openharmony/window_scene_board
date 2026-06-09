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
import { GlobalContext } from '@ohos/frameworkwrapper';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  ArgumentMatchers,
  when,
  Level
} from '@ohos/hypium'
import { CommonConstants, ILayoutConfig, SmartDockModeConfig } from '../../../../../../main/ets/TsIndex';

interface testDefaultConfig {
  persist: boolean;
}

export default function SmartDockModeConfigTest() {
  describe('SmartDockModeConfigTest', () => {
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
    it('SmartDockModeConfigTest_persistConfig', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const smartDockModeConfig = SmartDockModeConfig.getInstance();
      smartDockModeConfig.persistConfig();
      expect(smartDockModeConfig.isConfigExist()).assertTrue();
    })
    it('SmartDockModeConfigTest_deleteConfig', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const smartDockModeConfig = SmartDockModeConfig.getInstance();
      smartDockModeConfig.deleteConfig();
      expect(smartDockModeConfig.isConfigExist()).assertFalse();
    })

    it('testSmartDockModeConfigTest_initConfig', Level.LEVEL0, () => {
      const instance = SmartDockModeConfig.getInstance();
      const mocker: MockKit = new MockKit();
      mocker.mockFunc(instance, instance['loadPersistConfig']);
      instance.initConfig();
      mocker.verify('loadPersistConfig', []).once();
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('testSmartDockModeConfigTest_getConfigLevel', Level.LEVEL0, () => {
      const instance = SmartDockModeConfig.getInstance();
      expect(instance.getConfigLevel()).assertEqual(CommonConstants.LAYOUT_CONFIG_LEVEL_COMMON);
    })

    it('testSmartDockModeConfigTest_getConfigType', Level.LEVEL0, () => {
      const instance = SmartDockModeConfig.getInstance();
      expect(instance.getConfigType()).assertEqual(CommonConstants.LAYOUT_CONFIG_TYPE_MODE);
    })

    it('testSmartDockModeConfigTest_getConfigName', Level.LEVEL0, () => {
      const instance = SmartDockModeConfig.getInstance();
      expect(instance.getConfigName()).assertEqual(SmartDockModeConfig.SMART_DOCK_MODE_CONFIG);
    })

    it('testSmartDockModeConfigTest_forceReloadConfig', Level.LEVEL0, () => {
      const instance = SmartDockModeConfig.getInstance();
      const mocker: MockKit = new MockKit();
      mocker.mockFunc(instance, instance.initConfig);
      instance.forceReloadConfig();
      mocker.verify('initConfig', []).once();
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('testSmartDockModeConfigTest_getFeatureName', Level.LEVEL0, () => {
      const instance = SmartDockModeConfig.getInstance();
      expect(instance.getFeatureName()).assertEqual(ILayoutConfig['COMMON_FEATURE_NAME']);
    })

    it('testSmartDockModeConfigTest_loadPersistConfig', Level.LEVEL0, () => {
      const instance = SmartDockModeConfig.getInstance();
      const defaultConfig = {} as testDefaultConfig
      expect(instance['loadPersistConfig']()).assertDeepEquals(defaultConfig);
    })

    it('testSmartDockModeConfigTest_getConfigFileAbsPath', Level.LEVEL0, () => {
      const mocker: MockKit = new MockKit();
      const instance = SmartDockModeConfig.getInstance();
      const filesDir = '<root>'
      const getObject = mocker.mockFunc(GlobalContext.getInstance(), GlobalContext.getInstance().getObject);
      const appGet = mocker.mockFunc(AppStorage, AppStorage.get);
      when(getObject)('desktopContext').afterReturn({
        filesDir
      });
      when(appGet)('device').afterReturn('device');
      expect(instance.getConfigFileAbsPath()).assertEqual(`${filesDir}/${instance.getConfigName()}device.json`);
      mocker.clear(AppStorage);
      mocker.clear(GlobalContext.getInstance());
      mocker.clearAll();
    })

    it("test_getPersistConfigJson", 0, () => {
      try {
        const instance = SmartDockModeConfig.getInstance();
        expect(instance['getPersistConfigJson']).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })
  })
}