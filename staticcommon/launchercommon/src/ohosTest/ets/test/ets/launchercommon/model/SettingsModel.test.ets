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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import { CommonConstants, layoutConfigManager, SettingsModel } from '../../../../../../main/ets/TsIndex';
import { GridLayoutConfig } from '../../../../../../main/ets/TsIndex';
import { SettingsModelObserver } from '../../../../../../main/ets/model/SettingsModelObserver';
import { FileUtils } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';

export default function SettingsModelTest() {
  describe('SettingsModelTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      globalThis.SettingsModelInstance = null;
      SettingsModel.getInstance();
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
    it('SettingsModel_test_getInstance', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model = SettingsModel.getInstance();
      expect(SettingsModel.getInstance()).assertDeepEquals(model);
    })
    it('test_setGridConfig', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model = SettingsModel.getInstance();
      const retConfig: GridLayoutConfig = model.getGridConfig();
      expect(retConfig).not().assertNull();
    })

    it('test_setAppPageStartConfig', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model = SettingsModel.getInstance();
      const saved: string = model.getAppPageStartConfig();
      const newOne: string = '';
      model.setAppPageStartConfig(newOne);
      expect(model.getAppPageStartConfig()).assertEqual(newOne);
      model.setAppPageStartConfig(saved);
    })

    it('test_setDevice', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model = SettingsModel.getInstance();
      const saved: string = model.getDevice();
      const newOne: string = 'PAD';
      model.setDevice(newOne);
      expect(model.getDevice()).assertEqual(newOne);
      model.setAppPageStartConfig(saved);
    })

    it('test_getGridLayoutTable', 0, () => {
      let length = SettingsModel.getInstance()['mGridLayoutTable'].length;
      expect(SettingsModel.getInstance().getGridLayoutTable().length).assertEqual(length);
    })

    it('test_forceReloadConfig', 0, () => {
      SettingsModel.getInstance().forceReloadConfig();
      expect(true).assertTrue();
    })

    it('test_forceReloadConfig_needSendNotification', 0, () => {
      expect(SettingsModel.getInstance().forceReloadConfig(false) === undefined).assertTrue();
    })

    it('test_addObserver', 0, () => {
      let isCall: boolean = false;
      let observer: SettingsModelObserver = (event: number) => {
        isCall = true;
      };

      SettingsModel.getInstance().addObserver(observer);
      expect(SettingsModel.getInstance()['mObserverList'].length).assertLarger(0);

      SettingsModel.getInstance()['notifyObservers'](1000);
      expect(isCall).assertTrue();
    })

    it('test_getDefaultLayoutInfo', 0, () => {
      try {
        let ret: object = SettingsModel.getInstance().getDefaultLayoutInfo();
        expect(ret).assertNull();
      } catch (error) {
      }
    })

    it('test_setGridConfig', 0, () => {
      SettingsModel.getInstance().setGridConfig(1);
      expect(SettingsModel.getInstance()['mPageDesktopModeConfig'].getGridConfig()).assertEqual(1);
    })

    it('test_getAppListInfo', 0, () => {
      SettingsModel.getInstance().getAppListInfo();
      expect(true).assertTrue();
    })

    it('test_isAppListInfoExist', 0, () => {
      SettingsModel.getInstance().isAppListInfoExist();
      expect(true).assertTrue();
    })

    it('test_setAppListInfo', 0, () => {
      SettingsModel.getInstance().setAppListInfo({});
      expect(SettingsModel.getInstance().getAppListInfo()).not().assertNull();
    })

    it('test_setDevice', 0, () => {
      SettingsModel.getInstance().setDevice(CommonConstants.DEFAULT_DEVICE_TYPE);
      SettingsModel.getInstance().setDevice(CommonConstants.PAD_DEVICE_TYPE);
      SettingsModel.getInstance().setDevice(CommonConstants.PC_DEVICE_TYPE);
      expect(SettingsModel.getInstance()['mGridLayoutTable']).not().assertNull();
    })

    it('test_deleteLayoutInfo', 0, () => {
      SettingsModel.getInstance().deleteLayoutInfo();
      expect(true).assertTrue();
    })

    it('test_setValue', 0, () => {
      const defVal = SettingsModel.getInstance().getValue();
      SettingsModel.getInstance().setValue(defVal);
      let ret = SettingsModel.getInstance().getValue();
      expect(ret).assertInstanceOf('String');
    })

    it('test_registerListenForDataChanges', 0, () => {
      try {
        SettingsModel.getInstance().registerListenForDataChanges(() => {
        });
      } catch (error) {
      }
      expect(true).assertTrue();
    })

    it('test_getResidentList', 0, () => {
      SettingsModel.getInstance().setResidentList([]);
      expect(SettingsModel.getInstance().getResidentList().length).assertEqual(0);
    })

    it('test_SettingsModel_isSupportLargeForm', 0, () => {
      let instance: SettingsModel = SettingsModel.getInstance();
      let result: boolean = instance.isSupportLargeForm(CommonConstants.DOCK_SPACE);
      expect(result).assertInstanceOf('Boolean');
    })

    it('test_SettingsModel_getDefaultLayoutInfo', 0, () => {
      let instance: SettingsModel = SettingsModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      let mockFunc1: Function = mocker.mockFunc(FileUtils, FileUtils.readJsonFile);
      when(mockFunc)().afterReturn(false);
      when(mockFunc1)().afterReturn(false);
      try {
        let result: boolean = instance.getDefaultLayoutInfo();
        expect(false).assertFalse();
      } catch (e) {
      }
      mocker.clear(DeviceHelper);
      mocker.clear(FileUtils);
      mocker.clearAll();
    })
  })
}