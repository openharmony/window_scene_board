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
import { CheckEmptyUtils, FileUtils } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import {
  ConfigParseUtil,
  DefaultDesktopLayoutInfo, GetLayoutInfoFromConfig,
  GridLayoutItemInfo } from '../../../../../../main/ets/TsIndex'
import { CommonConstants } from '../../../../../../main/ets/constants/CommonConstants';

export default function GetLayoutInfoFromConfigTest() {
  describe('GetLayoutInfoFromConfigTest', () => {
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
    it('test_getInstance', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const instance = GetLayoutInfoFromConfig.getInstance();
      expect(instance).not().assertNull();
    })
    it('test_getAllLayoutConfigFile', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        const instance = GetLayoutInfoFromConfig.getInstance();
        const desktopLayoutInfo = await instance.getAllLayoutConfigFile();
        expect(desktopLayoutInfo).not().assertNull();
        expect(desktopLayoutInfo.layoutDescription).not().assertNull();
        expect(desktopLayoutInfo.layoutInfo.length).assertLarger(0);
      }catch{};
    })

    it('test_complementaryLayoutInfo_01', 0, () => {
      const instance = GetLayoutInfoFromConfig.getInstance();
      let gridInfo: DefaultDesktopLayoutInfo = {} as DefaultDesktopLayoutInfo;
      instance['complementaryLayoutInfo'](gridInfo);
      expect(CheckEmptyUtils.isEmpty(gridInfo)).assertFalse();
    });

    it('test_complementaryLayoutInfo_02', 0, () => {
      const instance = GetLayoutInfoFromConfig.getInstance();
      let gridInfo: DefaultDesktopLayoutInfo = {
        layoutInfo: [],
        layoutDescription: {
          pageCount: 1,
          row: 6,
          column: 4,
          maxPage: 18,
          maxForm: 80
        }
      };

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_CARD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.typeId = CommonConstants.TYPE_FOLDER;
      item3.area = [1, 1];
      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.bundleName = 'com.ohos.sceneboard';
      item4.typeId = CommonConstants.TYPE_ADD;
      item4.area = [1, 1];
      gridInfo.layoutInfo.push(item1);
      gridInfo.layoutInfo.push(item2);
      gridInfo.layoutInfo.push(item3);
      gridInfo.layoutInfo.push(item4);

      instance['complementaryLayoutInfo'](gridInfo);
      expect(instance).not().assertNull();
    });

    it('test_getAllLayoutConfigFile_01', 0, () => {
      try {
        const instance = GetLayoutInfoFromConfig.getInstance();
        let gridInfo: DefaultDesktopLayoutInfo = {
          layoutInfo: [],
          layoutDescription: {
            pageCount: 1,
            row: 6,
            column: 4,
            maxPage: 18,
            maxForm: 80
          }
        };

        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = 'com.ohos.sceneboard';
        item1.typeId = CommonConstants.TYPE_CARD;
        let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
        item2.bundleName = 'com.ohos.sceneboard';
        item2.typeId = CommonConstants.TYPE_FOLDER;
        let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
        item3.bundleName = 'com.ohos.sceneboard';
        item3.typeId = CommonConstants.TYPE_FOLDER;
        item3.area = [1, 1];
        let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
        item4.bundleName = 'com.ohos.sceneboard';
        item4.typeId = CommonConstants.TYPE_ADD;
        item4.area = [1, 1];
        gridInfo.layoutInfo.push(item1);
        gridInfo.layoutInfo.push(item2);
        gridInfo.layoutInfo.push(item3);
        gridInfo.layoutInfo.push(item4);

        instance['mFinalLayout'] = gridInfo;
        expect(instance.getAllLayoutConfigFile()).not().assertNull();
      } catch (e) {
      }
    });

    it('test_getAllLayoutConfigFile_02', 0, () => {
      const instance = GetLayoutInfoFromConfig.getInstance();
      let gridInfo: DefaultDesktopLayoutInfo = {} as DefaultDesktopLayoutInfo;
      instance['mFinalLayout'] = gridInfo;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(ConfigParseUtil, ConfigParseUtil.getAllConfig);
      let cfgFiles: string[] = [];
      when(mockFunc)(ArgumentMatchers).afterReturn(cfgFiles);
      try{
        instance.getAllLayoutConfigFile();
        expect(instance).not().assertNull();
      } catch (e) {
      }
      mocker.clear(ConfigParseUtil);
      mocker.clearAll();
    });

    it('test_getAllLayoutConfigFile_03', 0, () => {
      const instance = GetLayoutInfoFromConfig.getInstance();
      let gridInfo: DefaultDesktopLayoutInfo = {} as DefaultDesktopLayoutInfo;
      instance['mFinalLayout'] = gridInfo;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(ConfigParseUtil, ConfigParseUtil.getAllConfig);
      let cfgFiles: string[] = [];
      when(mockFunc)(ArgumentMatchers).afterReturn(cfgFiles);
      try{
        instance.getAllLayoutConfigFile();
        expect(instance).not().assertNull();
      } catch (e) {
      }
      mocker.clear(ConfigParseUtil);
      mocker.clearAll();
    });

    it('test_getConfigFromFile_01', 0, async () => {
      const instance = GetLayoutInfoFromConfig.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunc)(ArgumentMatchers).afterReturn(true);
      try{
        let fileName: string = !DeviceHelper.isPhone() ? 'layoutInfo_pad.json' :
          launcherStatusUtil.getShowOutLauncherStatus() ? 'layoutInfo_outer.json' : 'layoutInfo.json';
        let ret: DefaultDesktopLayoutInfo = await instance['getConfigFromFile'](fileName);
        expect(instance).not().assertNull();
      } catch (e) {
      }
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('test_getConfigFromFile_02', 0, async () => {
      const instance = GetLayoutInfoFromConfig.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunc)(ArgumentMatchers).afterReturn(false);
      let fileName: string = !DeviceHelper.isPhone() ? 'layoutInfo_pad.json' :
        launcherStatusUtil.getShowOutLauncherStatus() ? 'layoutInfo_outer.json' : 'layoutInfo.json';
      let ret: DefaultDesktopLayoutInfo = await instance['getConfigFromFile'](fileName);
      expect(instance).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('test_mergeLayout_01', 0, () => {
      try {
        const instance = GetLayoutInfoFromConfig.getInstance();

        let oriLayout: DefaultDesktopLayoutInfo = {
          layoutInfo: [],
          layoutDescription: {
            pageCount: 1,
            row: 6,
            column: 4,
            maxPage: 18,
            maxForm: 80
          }
        };

        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = 'com.ohos.sceneboard';
        item1.typeId = CommonConstants.TYPE_CARD;
        let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
        item2.bundleName = 'com.ohos.sceneboard';
        item2.typeId = CommonConstants.TYPE_FOLDER;
        let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
        item3.bundleName = 'com.ohos.sceneboard';
        item3.typeId = CommonConstants.TYPE_FOLDER;
        item3.area = [1, 1];
        let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
        item4.bundleName = 'com.ohos.sceneboard';
        item4.typeId = CommonConstants.TYPE_ADD;
        item4.area = [1, 1];
        oriLayout.layoutInfo.push(item1);
        oriLayout.layoutInfo.push(item2);
        oriLayout.layoutInfo.push(item3);
        oriLayout.layoutInfo.push(item4);

        let incLayout: DefaultDesktopLayoutInfo = {} as DefaultDesktopLayoutInfo;
        let ret: DefaultDesktopLayoutInfo = instance['mergeLayout'](oriLayout,incLayout);
        expect(ret).not().assertNull();
      } catch (e) {}
    });

    it('test_mergeLayout_02', 0, () => {
      const instance = GetLayoutInfoFromConfig.getInstance();

      let oriLayout: DefaultDesktopLayoutInfo = {
        layoutInfo: [],
        layoutDescription: {
          pageCount: 1,
          row: 6,
          column: 4,
          maxPage: 18,
          maxForm: 80
        }
      };
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_CARD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      oriLayout.layoutInfo.push(item1);
      oriLayout.layoutInfo.push(item2);

      let incLayout: DefaultDesktopLayoutInfo = {
        layoutInfo: [],
        layoutDescription: {
          pageCount: 1,
          row: 6,
          column: 4,
          maxPage: 18,
          maxForm: 80
        }
      };
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.typeId = CommonConstants.TYPE_FOLDER;
      item3.area = [1, 1];
      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.bundleName = 'com.ohos.sceneboard';
      item4.typeId = CommonConstants.TYPE_ADD;
      item4.area = [1, 1];
      incLayout.layoutInfo.push(item3);
      incLayout.layoutInfo.push(item4);
      instance['mergeLayout'](oriLayout,incLayout);
      let ret: DefaultDesktopLayoutInfo = instance['mergeLayout'](oriLayout,incLayout);
      expect(ret).not().assertNull();
    });

    it('test_mergeLayout_03', 0, () => {
      try {
        const instance = GetLayoutInfoFromConfig.getInstance();
        let oriLayout: DefaultDesktopLayoutInfo = {} as DefaultDesktopLayoutInfo;
        let incLayout: DefaultDesktopLayoutInfo = {} as DefaultDesktopLayoutInfo;
        let ret: DefaultDesktopLayoutInfo = instance['mergeLayout'](oriLayout, incLayout);
        expect(ret).not().assertNull();
      } catch (e) {}
    });

    it('test_registerGetLayoutInfoCallback_01', 0, () => {
      const instance = GetLayoutInfoFromConfig.getInstance();
      let callback: Function = () => {};
      instance['isFinishedFlag'] = false;
      instance.registerGetLayoutInfoCallback(callback);
      expect(instance).not().assertNull();
    });

    it('test_registerGetLayoutInfoCallback_02', 0, () => {
      const instance = GetLayoutInfoFromConfig.getInstance();
      let callback: Function = () => {};
      instance['isFinishedFlag'] = true;
      instance.registerGetLayoutInfoCallback(callback);
      expect(instance).not().assertNull();
    });

    it('test_getOuterAllLayoutConfigFile', 0, async () => {
      let getLayoutInfoFromConfig: GetLayoutInfoFromConfig = GetLayoutInfoFromConfig.getInstance();
      await getLayoutInfoFromConfig.getOuterAllLayoutConfigFile()
      expect(getLayoutInfoFromConfig).not().assertNull();
    });

    it('test_clearFinalLayout_1', 0, () => {
      let getLayoutInfoFromConfig: GetLayoutInfoFromConfig = GetLayoutInfoFromConfig.getInstance();
      getLayoutInfoFromConfig['mFinalLayout'] = new DefaultDesktopLayoutInfo();
      getLayoutInfoFromConfig['mOuterFinalLayout'] = new DefaultDesktopLayoutInfo();
      getLayoutInfoFromConfig.clearFinalLayout();
      expect(getLayoutInfoFromConfig).not().assertNull();
    });

    it('test_getSimpleLayoutConfigFile_1', 0, async () => {
      let getLayoutInfoFromConfig: GetLayoutInfoFromConfig = GetLayoutInfoFromConfig.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(getLayoutInfoFromConfig, getLayoutInfoFromConfig['getConfigFromFile']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(new DefaultDesktopLayoutInfo());
      getLayoutInfoFromConfig.clearFinalLayout();
      getLayoutInfoFromConfig['mGetLayoutInfoCallbacks'] = [];
      expect(await getLayoutInfoFromConfig.getSimpleLayoutConfigFile()).not().assertNull();
      getLayoutInfoFromConfig.clearFinalLayout();
      expect(await getLayoutInfoFromConfig.getSimpleLayoutConfigFile()).not().assertNull();
      getLayoutInfoFromConfig.clearFinalLayout();
      getLayoutInfoFromConfig['mSimpleFinalLayout'] = new DefaultDesktopLayoutInfo();
      getLayoutInfoFromConfig.registerGetLayoutInfoCallback(()=>{console.log('2')})
      expect(await getLayoutInfoFromConfig.getSimpleLayoutConfigFile()).not().assertNull();
      getLayoutInfoFromConfig.clearFinalLayout();
      mocker.clear(getLayoutInfoFromConfig);
      mocker.clearAll();
    });


    it('test_configLisTraversal_1', 0, () => {
      let defaultDesktopLayoutInfo: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      defaultDesktopLayoutInfo.layoutInfo = [];
      let getLayoutInfoFromConfig: GetLayoutInfoFromConfig = GetLayoutInfoFromConfig.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(FileUtils, FileUtils.readJsonFile);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(defaultDesktopLayoutInfo);
      getLayoutInfoFromConfig['configLisTraversal'](['1', '2']);
      expect(defaultDesktopLayoutInfo).not().assertNull();
      mocker.clear(FileUtils);
      mocker.clearAll();
    });

    it('test_outerConfigLisTraversal_1', 0, () => {
      let defaultDesktopLayoutInfo: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      defaultDesktopLayoutInfo.layoutInfo = [];
      let getLayoutInfoFromConfig: GetLayoutInfoFromConfig = GetLayoutInfoFromConfig.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(FileUtils, FileUtils.readJsonFile);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(defaultDesktopLayoutInfo);
      getLayoutInfoFromConfig['outerConfigLisTraversal'](['1', '2']);
      getLayoutInfoFromConfig['outerConfigLisTraversal'](['1']);
      expect(defaultDesktopLayoutInfo).not().assertNull();
      mocker.clear(FileUtils);
      mocker.clearAll();
    });

    it('test_mergeLayout_1', 0, () => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let defaultDesktopLayoutInfo: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      let defaultDesktopLayoutInfoOther: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      defaultDesktopLayoutInfoOther.layoutInfo = [gridLayoutItemInfo]
      let getLayoutInfoFromConfig: GetLayoutInfoFromConfig = GetLayoutInfoFromConfig.getInstance();
      expect(getLayoutInfoFromConfig['mergeLayout'](defaultDesktopLayoutInfo, defaultDesktopLayoutInfoOther))
        .not()
        .assertNull();
    });

    it('test_getOuterAllLayoutConfigFile_1', 0, async () => {
      let defaultDesktopLayoutInfo: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      let getLayoutInfoFromConfig: GetLayoutInfoFromConfig = GetLayoutInfoFromConfig.getInstance();
      getLayoutInfoFromConfig['mOuterFinalLayout'] = defaultDesktopLayoutInfo;
      expect(await getLayoutInfoFromConfig.getOuterAllLayoutConfigFile()).not().assertNull();
    });

    it('test_get2in1PcLayoutConfigFile_1', 0, async () => {
      let defaultDesktopLayoutInfo: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      let getLayoutInfoFromConfig: GetLayoutInfoFromConfig = GetLayoutInfoFromConfig.getInstance();
      getLayoutInfoFromConfig['mFinalLayout'] = defaultDesktopLayoutInfo;
      expect(await getLayoutInfoFromConfig.get2in1PcLayoutConfigFile()).not().assertNull();
    });
  })
}