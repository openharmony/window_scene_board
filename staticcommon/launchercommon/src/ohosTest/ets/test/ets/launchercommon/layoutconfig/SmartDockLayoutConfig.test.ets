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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit,
  ArgumentMatchers,
  when} from '@ohos/hypium'
import {
  CommonConstants,
  DefaultDesktopLayoutInfo, DockItemInfo,
  GetLayoutInfoFromConfig,
  GridLayoutItemInfo,
  SmartDockLayoutConfig } from '../../../../../../main/ets/TsIndex';

export default function SmartDockLayoutConfigTest() {
  describe('SmartDockLayoutConfigTest', () => {
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
      const smartDockLayoutConfig = SmartDockLayoutConfig.getInstance();
      expect(smartDockLayoutConfig).not().assertNull();
    })

    it('SmartDockLayoutConfigTest_persistConfig', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const smartDockLayoutConfig = SmartDockLayoutConfig.getInstance();
      smartDockLayoutConfig.persistConfig();
      expect(smartDockLayoutConfig.isConfigExist()).assertTrue();
    })

    it('test_getAllLayoutConfigFile_01', 0, async () => {
      let instance: SmartDockLayoutConfig = SmartDockLayoutConfig.getInstance();
      let ret: DefaultDesktopLayoutInfo = await instance['getAllLayoutConfigFile']();
      expect(instance).not().assertNull();
    });

    it('test_getDockLayoutInfo_01', 0, async () => {
      let instance: SmartDockLayoutConfig = SmartDockLayoutConfig.getInstance();

      let configLayoutInfo: DefaultDesktopLayoutInfo = {
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
      configLayoutInfo.layoutInfo.push(item1);
      configLayoutInfo.layoutInfo.push(item2);

      let mocker: MockKit = new MockKit();
      let config: GetLayoutInfoFromConfig = GetLayoutInfoFromConfig.getInstance();
      let mockFunc: Function = mocker.mockFunc(config, config.getAllLayoutConfigFile);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(configLayoutInfo);

      let ret:DockItemInfo[] = await instance.getDockLayoutInfo();
      expect(instance).not().assertNull();
      mocker.clear(config);
      mocker.clearAll();
    });

    it('test_getDockLayoutInfo_02', 0, async () => {
      let instance: SmartDockLayoutConfig = SmartDockLayoutConfig.getInstance();
      let configLayoutInfo: DefaultDesktopLayoutInfo = {} as DefaultDesktopLayoutInfo;
      let mocker: MockKit = new MockKit();
      let config: GetLayoutInfoFromConfig = GetLayoutInfoFromConfig.getInstance();
      let mockFunc: Function = mocker.mockFunc(config, config.getAllLayoutConfigFile);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(configLayoutInfo);

      let ret:DockItemInfo[] = await instance.getDockLayoutInfo();
      expect(instance).not().assertNull();
      mocker.clear(config);
      mocker.clearAll();
    });

    it('test_convertAppLayout2DockLayout_01', 0, () => {
      let instance: SmartDockLayoutConfig = SmartDockLayoutConfig.getInstance();

      let configLayoutInfo: DefaultDesktopLayoutInfo = {
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
      configLayoutInfo.layoutInfo.push(item1);
      configLayoutInfo.layoutInfo.push(item2);
      let ret:DockItemInfo[] = instance['convertAppLayout2DockLayout'](configLayoutInfo.layoutInfo);
      expect(instance).not().assertNull();
    });

    it('test_convertAppLayout2DockLayout_02', 0, () => {
      let instance: SmartDockLayoutConfig = SmartDockLayoutConfig.getInstance();
      let configLayoutInfo: DefaultDesktopLayoutInfo = {} as DefaultDesktopLayoutInfo;
      let ret:DockItemInfo[] = instance['convertAppLayout2DockLayout'](configLayoutInfo.layoutInfo);
      expect(instance).not().assertNull();
    });

  })
}