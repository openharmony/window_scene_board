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
import { FileUtils } from '@ohos/basicutils'
import { GlobalContext } from '@ohos/frameworkwrapper'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit,
  ArgumentMatchers,
  when} from '@ohos/hypium'
import {
  AppItemInfo,
  AppModel,
  DefaultDesktopLayoutInfo,
  GetLayoutInfoFromConfig,
  GridLayoutItemInfo,
  LayoutDescription} from '@ohos/launchercommon/src/main/ets/TsIndex'
import OuterPhonePageDesktopLayoutConfig from '@ohos/phonebase/src/main/ets/common/OuterPhonePageDesktopLayoutConfig'

export default function OuterPhonePageDesktopLayoutConfigTest() {
  describe('OuterPhonePageDesktopLayoutConfigTest', () => {
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
    it('OuterPhonePageDesktopLayoutConfigTest_getInstance', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      globalThis.outerPhonePageDesktopLayoutConfig = null;
      let instance: OuterPhonePageDesktopLayoutConfig = OuterPhonePageDesktopLayoutConfig.getInstance();
      expect(globalThis.outerPhonePageDesktopLayoutConfig).not().assertEqual(instance);
      expect(instance).assertEqual(OuterPhonePageDesktopLayoutConfig.getInstance());
    })

    it('OuterPhonePageDesktopLayoutConfigTest_loadPersistConfig', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let res = true;
      try {
        let instance: OuterPhonePageDesktopLayoutConfig = OuterPhonePageDesktopLayoutConfig.getInstance();
        instance.loadPersistConfig();
      } catch (error) {
        res = false;
      }
      expect(res).assertTrue();
    })

    it('OuterPhonePageDesktopLayoutConfigTest_getConfigLevel', 0, () => {
      let instance: OuterPhonePageDesktopLayoutConfig = OuterPhonePageDesktopLayoutConfig.getInstance();
      expect(instance.getConfigLevel()).assertEqual('product');
    })

    it('OuterPhonePageDesktopLayoutConfigTest_loadPersistConfig_0', 0, () => {
      let instance: OuterPhonePageDesktopLayoutConfig = OuterPhonePageDesktopLayoutConfig.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function   = mocker.mockFunc(FileUtils, FileUtils.readStringFromFile);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(instance.mGridLayoutInfo.layoutDescription.row).assertEqual(6);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(instance.mGridLayoutInfo.layoutDescription.column).assertEqual(4);
      mocker.clear(FileUtils);
      mocker.clearAll();
    })

    it('OuterPhonePageDesktopLayoutConfigTest_getGridLayoutInfo_01', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const config = OuterPhonePageDesktopLayoutConfig.getInstance();
      expect(config.getGridLayoutInfo().layoutDescription.column).assertEqual(4);
    });

    it('OuterPhonePageDesktopLayoutConfigTest_getGridLayoutInfo_02', 0, () => {
      const PageDesktopLayoutConfigInstance: OuterPhonePageDesktopLayoutConfig =
        OuterPhonePageDesktopLayoutConfig.getInstance();
      const gridLayoutInfo: DefaultDesktopLayoutInfo = PageDesktopLayoutConfigInstance.getGridLayoutInfo();
      expect(gridLayoutInfo).assertEqual(PageDesktopLayoutConfigInstance.getGridLayoutInfo());
    });

    it('OuterPhonePageDesktopLayoutConfigTest_updateGridLayoutInfo', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const config = OuterPhonePageDesktopLayoutConfig.getInstance();
      config.deleteConfig();
      config.updateGridLayoutInfo(DefaultDesktopLayoutInfo.getDefaultLayoutInfo());
      expect(config.getGridLayoutInfo().layoutInfo.length).assertEqual(0);
    });

    it('OuterPhonePageDesktopLayoutConfigTest_updateLayoutDescription', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        const config = OuterPhonePageDesktopLayoutConfig.getInstance();
        config.deleteConfig();
        config.updateLayoutDescription(DefaultDesktopLayoutInfo.getDefaultLayoutInfo());
        expect(config.mGridLayoutInfo.layoutDescription.row).assertEqual(6);
        expect(config.getGridLayoutInfo().layoutDescription.column).assertEqual(4);
      }catch(e){}
    });

    it('OuterPhonePageDesktopLayoutConfigTest_refreshLayoutAfterRecover', 0, () => {
      const config = OuterPhonePageDesktopLayoutConfig.getInstance();
      config.refreshLayoutAfterRecover()
      expect(GlobalContext.getInstance().getObject('backupStatus')).assertInstanceOf('Boolean');
      expect(AppStorage.get('isCloneStatus')).assertInstanceOf('Boolean');
    });

    it('OuterPhonePageDesktopLayoutConfigTest_refreshLayoutAfterRecover02', 0, () => {
      const config = OuterPhonePageDesktopLayoutConfig.getInstance();
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.ohos.totemweather';
      itemInfo.moduleName = 'moduleName';
      itemInfo.cardName ='ClockWeatherCard';
      itemInfo.page = 0;
      itemInfo.row = 0;
      itemInfo.column = 1;
      itemInfo.typeId = 1;
      itemInfo.area = [1, 1];
      let itemInfo2 = new GridLayoutItemInfo();
      itemInfo2.bundleName = 'com.ohos.totemweather';
      itemInfo2.moduleName = 'moduleName';
      itemInfo2.cardId ='ClockWeatherCard';
      itemInfo2.page = 0;
      itemInfo2.row = 0;
      itemInfo2.column = 1;
      itemInfo2.typeId = 6;
      itemInfo2.area = [1, 1];
      itemInfo2.layoutInfo = [[itemInfo]];
      let list: GridLayoutItemInfo[] = [itemInfo, itemInfo2];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(globalThis.RdbStoreManagerInstance, globalThis.RdbStoreManagerInstance.querySettingsPageCount);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(0);
      let mockFunc2: Function = mocker.mockFunc(globalThis.RdbStoreManagerInstance, globalThis.RdbStoreManagerInstance.queryGridLayoutInfo);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(list);
      config.refreshLayoutAfterRecover()
      expect(GlobalContext.getInstance().getObject('backupStatus')).assertInstanceOf('Boolean');
      mocker.clear(globalThis.RdbStoreManagerInstance);
      mocker.clearAll();
    });

    it('OuterPhonePageDesktopLayoutConfigTest_filterOuterDbList', 0, async (done:Function) => {
      let res = true;
      try {
        let instance: OuterPhonePageDesktopLayoutConfig = OuterPhonePageDesktopLayoutConfig.getInstance();
        let itemInfo = new GridLayoutItemInfo();
        itemInfo.bundleName = 'com.ohos.totemweather';
        itemInfo.moduleName = 'moduleName';
        itemInfo.appIndex = 0;
        itemInfo.page = 0;
        itemInfo.row = 0;
        itemInfo.column = 1;
        itemInfo.typeId = 1;
        itemInfo.area = [1, 1];
        let itemInfo2 = new GridLayoutItemInfo();
        itemInfo2.bundleName = 'com.ohos.totemweather';
        itemInfo2.moduleName = 'moduleName';
        itemInfo2.appIndex = 0;
        itemInfo2.page = 0;
        itemInfo2.row = 0;
        itemInfo2.column = 1;
        itemInfo2.typeId = 7;
        itemInfo2.area = [1, 1];
        itemInfo2.layoutInfo = [[itemInfo]];
        let list: GridLayoutItemInfo[] = [itemInfo, itemInfo2];
        await instance['filterOuterDbList'](list, list);
      } catch (error) {
        res = false;
      }
      expect(res).assertTrue();
      done();
    });

    it('OuterPhonePageDesktopLayoutConfigTest_loadOuterLayoutInfoFromConfig', 0, async (done:Function) => {
      let instance: OuterPhonePageDesktopLayoutConfig = OuterPhonePageDesktopLayoutConfig.getInstance();
      let getLayoutInfoFromConfig = GetLayoutInfoFromConfig.getInstance();
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.ohos.totemweather';
      itemInfo.moduleName = 'moduleName';
      itemInfo.cardName ='ClockWeatherCard';
      itemInfo.page = 0;
      itemInfo.row = 0;
      itemInfo.column = 1;
      itemInfo.typeId = 1;
      itemInfo.area = [1, 1];
      let desktopLayoutInfo = new DefaultDesktopLayoutInfo();
      desktopLayoutInfo.layoutDescription = new LayoutDescription();
      desktopLayoutInfo.layoutDescription.row = 0;
      desktopLayoutInfo.layoutDescription.column = 0;
      desktopLayoutInfo.layoutDescription.maxPage = 1;
      desktopLayoutInfo.layoutDescription.pageCount = 1;
      desktopLayoutInfo.layoutInfo = [itemInfo];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(getLayoutInfoFromConfig, getLayoutInfoFromConfig.getOuterAllLayoutConfigFile);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(desktopLayoutInfo);
      instance['loadOuterLayoutInfoFromConfig'](1);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.clear(getLayoutInfoFromConfig);
      mocker.clearAll();
      done();
    });

    it('OuterPhonePageDesktopLayoutConfigTest_initLayoutCache', 0, () => {
      let res = true;
      try {
        let instance: OuterPhonePageDesktopLayoutConfig = OuterPhonePageDesktopLayoutConfig.getInstance();
        instance['initLayoutCache']();
      } catch (error) {
        res = false;
      }
      expect(res).assertInstanceOf('Boolean');
    });

    it('OuterPhonePageDesktopLayoutConfigTest_checkAppOuterList', 0, () => {
      let res = true;
      try {
        let instance: OuterPhonePageDesktopLayoutConfig = OuterPhonePageDesktopLayoutConfig.getInstance();
        let newApp: AppItemInfo = new AppItemInfo();
        newApp.keyName = 'keyName';
        newApp.bundleName = 'bundleName';
        newApp.appIndex = 0;
        newApp.appStatus = 0;
        let list: AppItemInfo[] = [newApp];
        let itemInfo = new GridLayoutItemInfo();
        itemInfo.bundleName = 'com.ohos.totemweather';
        itemInfo.moduleName = 'moduleName';
        itemInfo.abilityName ='abilityName';
        itemInfo.appIndex = 0;
        itemInfo.page = 0;
        itemInfo.row = 0;
        itemInfo.column = 1;
        itemInfo.typeId = 1;
        itemInfo.area = [1, 1];
        let itemInfo2 = new GridLayoutItemInfo();
        itemInfo2.bundleName = 'com.ohos.totemweather';
        itemInfo2.moduleName = 'moduleName';
        itemInfo2.abilityName ='abilityName';
        itemInfo2.appIndex = 0;
        itemInfo2.page = 0;
        itemInfo2.row = 0;
        itemInfo2.column = 1;
        itemInfo2.typeId = 0;
        itemInfo2.area = [1, 1];
        let desktopLayoutInfo = new DefaultDesktopLayoutInfo();
        desktopLayoutInfo.layoutDescription = new LayoutDescription();
        desktopLayoutInfo.layoutDescription.row = 0;
        desktopLayoutInfo.layoutDescription.column = 0;
        desktopLayoutInfo.layoutDescription.maxPage = 1;
        desktopLayoutInfo.layoutDescription.pageCount = 1;
        desktopLayoutInfo.layoutInfo = [itemInfo, itemInfo2];
        let appModel = AppModel.getInstance();
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(appModel, appModel.getAppList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(list);
        let mockFunc2: Function = mocker.mockFunc(appModel, appModel.getAppInfoByKeyName);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(newApp);
        instance.mGridLayoutInfo = desktopLayoutInfo;
        instance['checkAppOuterList']();
        mocker.clear(appModel);
        mocker.clearAll();
      } catch (error) {
        res = false;
      }
      expect(res).assertTrue();
    });
  })
}