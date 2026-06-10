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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import {
  AppListInfoCacheManager,
  CommonConstants,
  DefaultDesktopLayoutInfo,
  DesktopDataLoader,
  DockItemInfo,
  GetLayoutInfoFromConfig,
  GridLayoutItemInfo
} from '../../../../../../main/ets/TsIndex'

export default function DesktopDataLoaderTest() {
  describe('DesktopDataLoaderTest', () => {
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

    it('DesktopDataLoaderTest_loadFromJsonConfig', 0, async (done: Function) => {
      let desktopLayout: number = 1;
      let loader: DesktopDataLoader = new DesktopDataLoader(desktopLayout);
      let testResult = new DefaultDesktopLayoutInfo();
      let mocker: MockKit = new MockKit();
      let config = GetLayoutInfoFromConfig.getInstance();
      let mockfunc = mocker.mockFunc(config, config.getSimpleLayoutConfigFile);
      when(mockfunc)().afterReturn(testResult);
      let result: DefaultDesktopLayoutInfo = await loader.loadFromJsonConfig();
      expect(result.layoutInfo.length === 0).assertTrue();
      mocker.clear(config);
      done();
    });

    it('DesktopDataLoaderTest_loadFromJsonConfig_getAllLayout', 0, async (done: Function) => {
      let desktopLayout: number = 0;
      let loader: DesktopDataLoader = new DesktopDataLoader(desktopLayout);
      let testResult = new DefaultDesktopLayoutInfo();
      let mocker: MockKit = new MockKit();
      let config = GetLayoutInfoFromConfig.getInstance();
      let mockfunc = mocker.mockFunc(config, config.getAllLayoutConfigFile);
      when(mockfunc)().afterReturn(testResult);
      let result: DefaultDesktopLayoutInfo = await loader.loadFromJsonConfig();
      expect(result.layoutInfo.length === 0).assertTrue();
      mocker.clear(config);
      done();
    });

    it('DesktopDataLoaderTest_loadDesktopLayout', 0, async (done: Function) => {
      let gridInfo0: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridInfo0.row = 1;
      gridInfo0.column = 1;
      gridInfo0.typeId = CommonConstants.TYPE_FORM_STACK;
      gridInfo0.area = [0, 0];
      let girdLayoutItemInfo = new GridLayoutItemInfo();
      gridInfo0.layoutInfo = [[girdLayoutItemInfo]];
      let gridInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridInfo.row = 1;
      gridInfo.column = 1;
      gridInfo.typeId = CommonConstants.TYPE_FORM_STACK;
      gridInfo.area = [0, 0];
      let gridInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridInfo1.row = 1;
      gridInfo1.column = 2;
      gridInfo1.typeId = CommonConstants.TYPE_CARD;
      gridInfo1.bundleName = 'com.ohos.suggestion1111';
      gridInfo1.abilityName = 'ParentFormAbility1111';
      gridInfo1.area = [1, 0];
      let gridInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridInfo2.row = 1;
      gridInfo2.column = 2;
      gridInfo2.typeId = CommonConstants.TYPE_CARD;
      gridInfo2.bundleName = 'com.ohos.suggestion';
      gridInfo2.abilityName = 'ParentFormAbility';
      gridInfo2.area = [1, 1];
      let gridInfo3: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridInfo3.row = 1;
      gridInfo3.column = 2;
      gridInfo3.typeId = CommonConstants.TYPE_FOLDER;
      gridInfo3.bundleName = 'com.ohos.suggestion';
      gridInfo3.abilityName = 'ParentFormAbility';
      gridInfo3.area = [1, 1];
      let desktopLayout: number = 1;
      let loader: DesktopDataLoader = new DesktopDataLoader(desktopLayout);
      let mocker: MockKit = new MockKit();
      let mockfunc = mocker.mockFunc(loader, loader.loadGridLayoutItemsFromRdb);
      when(mockfunc)().afterReturn([gridInfo0, gridInfo, gridInfo1, gridInfo2,gridInfo3]);
      try {
        let res1 = await loader.loadDesktopLayout();
        expect(res1).assertTrue();
      } catch (e) {}
      let mockfuncSmartDock = mocker.mockFunc(loader, loader.loadSmartDockItemsFromRdb);
      let dockItemInfos: DockItemInfo[] = [];
      for (let index = 0; index < 3; index++) {
        let dockItem: DockItemInfo = new DockItemInfo();
        dockItemInfos.push(dockItem);
      }
      when(mockfunc)().afterReturn([]);
      when(mockfuncSmartDock)().afterReturn(dockItemInfos);
      try {
        let res2 = await loader.loadDesktopLayout();
        expect(res2).assertTrue();
      } catch (e) {}
      mocker.clear(loader);
      mocker.clearAll();
      done();
    })

    it('DesktopDataLoaderTest_loadDesktopLayout_empty', 0, async (done: Function) => {
      let desktopLayout: number = 1;
      let loader: DesktopDataLoader = new DesktopDataLoader(desktopLayout);
      let mocker: MockKit = new MockKit();
      try {
        let mockfunc = mocker.mockFunc(loader, loader.loadGridLayoutItemsFromRdb);
        when(mockfunc)().afterReturn([]);
        let mockfuncSmartDock = mocker.mockFunc(loader, loader.loadSmartDockItemsFromRdb);
        when(mockfuncSmartDock)().afterReturn([]);
        let res = await loader.loadDesktopLayout();
        expect(res).assertFalse();
      } catch (e) {}
      mocker.clear(loader);
      mocker.clearAll();
      done();
    })
  })
}