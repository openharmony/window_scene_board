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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { DesktopLayoutCacheData } from '../../../../../../../main/ets/cache/layout/DesktopLayoutCacheData'
import { CommonConstants, DefaultDesktopLayoutInfo, GridLayoutItemInfo } from '../../../../../../../main/ets/TsIndex'

export default function DesktopLayoutCacheDataTest() {
  describe('DesktopLayoutCacheDataTest', () => {
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
    it('setGridLayoutItemList00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);

      try {
        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheData.setGridLayoutItemList(layoutInfoList);
        let resList: GridLayoutItemInfo[] = layoutCacheData.getGridLayoutItemList();
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(resList.length).assertEqual(1);
      } catch (e) {}
    })

    it('getGridLayoutItemList00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      try {
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheData.setGridLayoutItemList([])
        let resList: GridLayoutItemInfo[] = layoutCacheData.getGridLayoutItemList();
        layoutCacheData.setGridLayoutItemList(layoutInfoList);
        resList = layoutCacheData.getGridLayoutItemList();
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(resList.length).assertEqual(1);
      } catch (e) {}
    })

    it('getGridLayoutInfo00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheData.setGridLayoutInfo(null);
      let layoutInfo: DefaultDesktopLayoutInfo = layoutCacheData.getGridLayoutInfo();
      layoutCacheData.setGridLayoutInfo(defaultLayout);
      layoutInfo = layoutCacheData.getGridLayoutInfo();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(layoutInfo).assertEqual(defaultLayout);
    })

    it('setGridLayoutInfo00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheData.setGridLayoutInfo(defaultLayout);
      let layoutInfo: DefaultDesktopLayoutInfo = layoutCacheData.getGridLayoutInfo();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(layoutInfo).assertEqual(defaultLayout);
    })

    it('updateLayoutListCache00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      try {
        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheData.updateLayoutListCache([]);
        let resList: GridLayoutItemInfo[] = layoutCacheData.getGridLayoutItemList();
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(resList.length).assertEqual(0);
      } catch (e) {}
    })

    it('test_getPortraitLayoutInfo00', 0, () => {
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);

      layoutCacheData.setPortraitLayoutInfo(defaultLayout);
      let info: DefaultDesktopLayoutInfo = layoutCacheData.getPortraitLayoutInfo();
      expect(info).assertDeepEquals(defaultLayout);
    })

    it('test_getLandscapeLayoutInfo00', 0, () => {
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);

      layoutCacheData.setLandscapeLayoutInfo(defaultLayout);
      let info: DefaultDesktopLayoutInfo = layoutCacheData.getLandscapeLayoutInfo();
      expect(info).assertDeepEquals(defaultLayout);
    })

    it('test_changePadPortraitMode00', 0, () => {
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = 'id';
      demoApp.bundleName = 'com.hw.clock';
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = 'key_test';
      layoutInfoList.push(demoApp);

      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      defaultLayout.layoutInfo = layoutInfoList;
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheData.setLandscapeLayoutInfo(defaultLayout);
      layoutCacheData.changePadPortraitMode(false);
      expect(layoutCacheData['mGridLayoutItemList']).not().assertNull();

      layoutCacheData.setPortraitLayoutInfo(defaultLayout);
      layoutCacheData.changePadPortraitMode(true);
      expect(layoutCacheData['mGridLayoutItemList']).not().assertNull();
    })

    it('test_setListener', 0, () => {
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheData.setListener(null);
      expect(layoutCacheData['mfoldLayoutChangeListener']).assertNull()
    })

    it('test_updateLayoutListCacheAndPrebuild', 0, () => {
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = 'id';
      demoApp.bundleName = 'com.hw.clock';
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = 'key_test';
      layoutInfoList.push(demoApp);

      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheData.updateLayoutListCacheAndPrebuild(layoutInfoList);
      expect(layoutCacheData['mGridLayoutItemList']).not().assertNull()
    })

    it('test_getRotateLayoutInfo_getRotateLayout', 0, () => {
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheData.setIsPad(false);
      layoutCacheData.setLandscapeLayoutInfo(defaultLayout);
      let ret = layoutCacheData.getRotateLayoutInfo();
      expect(ret.length).assertEqual(0);
      layoutCacheData.setIsPad(true);
      layoutCacheData.setPadPortraitMode(true);
      let res = layoutCacheData.getRotateLayout();
      expect(res.layoutInfo.length).assertEqual(0);
    })

    it('test_setGridLayoutInfo_getGridLayoutInfo', 0, () => {
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      try {
        layoutCacheData.setGridLayoutInfo(defaultLayout, true);
        expect(layoutCacheData['mOuterLayoutInfo']).not().assertNull();
        layoutCacheData.getGridLayoutInfo(true);
        layoutCacheData.setGridLayoutInfo(null);
        let ret = layoutCacheData.getGridLayoutInfo();
        expect(ret.layoutInfo.length).assertEqual(0);
      } catch (e) {}
    })

    it('test_getGridLayoutItemList', 0, () => {
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      try {
        layoutCacheData.clearCache();
        let ret = layoutCacheData.getGridLayoutItemList(true);
        expect(ret.length).assertEqual(0);
      } catch (e) {}
    })
  })
}