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
import { GridOccupyStatusEnum, ObjectCopyUtil } from '@ohos/basicutils'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { DesktopLayoutCacheData } from '../../../../../main/ets/cache/layout/DesktopLayoutCacheData'
import {
  AppItemInfo,
  BaseLayoutCacheManager,
  CommonConstants,
  DefaultDesktopLayoutInfo,
  GridLayoutConfig,
  GridLayoutItemInfo,
  LayoutDescription } from '../../../../../main/ets/TsIndex'


export default function BaseLayoutCacheDateManagerTest() {
  describe('BaseLayoutCacheDateManagerTest', () => {
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
    it('getInstance00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      // 条件1
      let layoutCacheManager1: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(layoutCacheManager).assertEqual(layoutCacheManager1);
    })

    it('reInit00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let lengthA: number = defaultLayout.layoutInfo.length;
      let lengthB: number = layoutCacheManager.getAllGridLayoutItemList('DT').length;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(lengthA).assertEqual(lengthB);
    })

    it('getAllGridLayoutItemList00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let lengthA: number = layoutCacheManager.getAllGridLayoutItemList('DT').length;
      let lengthB: number = layoutCacheManager.getAllGridLayoutItemList('DT').length;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(lengthA).assertEqual(lengthB);
    })

    it('getDesktopLayoutInfo00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let layoutInfo: DefaultDesktopLayoutInfo = layoutCacheManager.getDesktopLayoutInfo('DT');
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(layoutInfo).assertEqual(defaultLayout);
    })

    it('selectGridLayoutItemById00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = 'com.openharmony.demoApp';
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let demo: GridLayoutItemInfo = layoutCacheManager.selectGridLayoutItemById(infoId);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(demo).assertEqual(demoApp);
    })

    it('selectGridLayoutItemsByBundleName00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let demoList: GridLayoutItemInfo[] = layoutCacheManager.selectGridLayoutItemsByBundleName(bundleName);
      let resLength: number = demoList.length;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(resLength).assertEqual(1);
    })

    it('selectContainerGridLayoutItem00', 0, () => {
      const containerId = 999;
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let demoContainerItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoContainerItem.id = containerId;
      layoutInfoList.push(demoContainerItem);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let demoItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoItem.container = containerId;
      expect(layoutCacheManager.selectContainerGridLayoutItem(demoItem)).not().assertUndefined();
    })

    it('selectContainerGridLayoutItem01', 0, () => {
      const containerId = 999;
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let demoContainerItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoContainerItem.id = containerId;
      layoutInfoList.push(demoContainerItem);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let demoItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoItem.container = undefined;
      expect(layoutCacheManager.selectContainerGridLayoutItem(demoItem)).assertUndefined();
    })

    it('selectGridLayoutItemsByType00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let demoList: GridLayoutItemInfo[] = layoutCacheManager.selectGridLayoutItemsByType(CommonConstants.TYPE_APP);
      let resLength: number = demoList.length;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(resLength).assertEqual(1);
    })

    it('selectGridLayoutItemsByBundleAndType00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let demoList: GridLayoutItemInfo[] = layoutCacheManager.selectGridLayoutItemsByBundleAndType(bundleName, CommonConstants.TYPE_APP);
      let resLength: number = demoList.length;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(resLength).assertEqual(1);
    })

    it('selectGridLayoutItemByPosition00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let demo: GridLayoutItemInfo = layoutCacheManager.selectGridLayoutItemByPosition(0, 0, 0);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(demo).assertEqual(demoApp);
    })

    it('selectGridLayoutItemByIndex00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let demo: GridLayoutItemInfo = layoutCacheManager.selectGridLayoutItemByIndex(-1)
      if (!demo) {
        demo = layoutCacheManager.selectGridLayoutItemByIndex(0);
      }
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(demo).assertEqual(demoApp);
    })

    it('selectIndexInLayout00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let index: number = layoutCacheManager.selectIndexInLayout(demoApp);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(index).assertEqual(0);
    })

    it('selectSameAppAndFolder00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let resList: GridLayoutItemInfo[] = layoutCacheManager.selectSameAppAndFolder(keyName, bundleName, '0', 0);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(resList.length).assertEqual(1);
    })

    it('selectPageCount00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let pageCount: number = layoutCacheManager.selectPageCount();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(pageCount).assertEqual(1);
    })

    it('selectMaxPageCount00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let maxPage: number = layoutCacheManager.selectMaxPageCount();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(maxPage).assertEqual(18);
    })

    it('selectLayoutDescription00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let description: LayoutDescription = layoutCacheManager.selectLayoutDescription();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(description).assertEqual(defaultLayout.layoutDescription);
    })

    it('selectGridOccupyStatusForPage00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let gridOccupyStatusEnum: GridOccupyStatusEnum[][] = layoutCacheManager.selectGridOccupyStatusForPage(0);
      let occupied: string = gridOccupyStatusEnum[0][0];
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(occupied).assertEqual('O');
    })

    it('selectPageItemMap00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let pageMap: Map<string, number> = layoutCacheManager.selectPageItemMap();
      let num: number | undefined = pageMap.get('0');
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(num).assertEqual(1);
    })

    it('selectAllOccupiedSpace00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let occupiedNum: number = layoutCacheManager.selectAllOccupiedSpace();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(occupiedNum).assertEqual(1);
    })

    it('selectAllOccupiedSpace00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let occupiedNum: number = layoutCacheManager.selectAllOccupiedSpace();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(occupiedNum).assertEqual(1);
    })

    it('selectGridLayoutItemByItem00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let demo: GridLayoutItemInfo | undefined = layoutCacheManager.selectGridLayoutItemByItem(null);
      if (!demo) {
        demo = layoutCacheManager.selectGridLayoutItemByItem(demoApp);
      }
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(demo).assertEqual(demoApp);
    })

    it('isBlankPage00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let isBlank: boolean = layoutCacheManager.isBlankPage(0);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(isBlank).assertEqual(false);
    })

    it('isAddAppOverMaxPage00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let gridConfig: GridLayoutConfig = new GridLayoutConfig();
      gridConfig.row = 6;
      gridConfig.column = 4;
      let isOverMaxPage: boolean = layoutCacheManager.isAddAppOverMaxPage(null, -1);
      if (isOverMaxPage) {
        isOverMaxPage = layoutCacheManager.isAddAppOverMaxPage(gridConfig, -1);
      }
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(isOverMaxPage).assertEqual(false);
      // 条件2
      let isOverMaxPage2: boolean = layoutCacheManager.isAddAppOverMaxPage(gridConfig, 0);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(isOverMaxPage2).assertEqual(false);
    })

    it('isAppInFolder00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoFolder.typeId = CommonConstants.TYPE_FOLDER;
      demoFolder.layoutInfo = [[demoApp]];
      layoutInfoList.push(demoFolder);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let appItem: AppItemInfo = new AppItemInfo();

      let isInFolder: boolean = layoutCacheManager.isAppInFolder(null);
      if (!isInFolder) {
        appItem.keyName = 'keyName';
        isInFolder = layoutCacheManager.isAppInFolder(appItem)
      }
      if (!isInFolder) {
        appItem.keyName = keyName;
        isInFolder = layoutCacheManager.isAppInFolder(appItem);
      }
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(isInFolder).assertEqual(true);
    })

    it('isPositionValid00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let isValid: boolean = layoutCacheManager.isPositionValid(null, 0, 0, 0);
      if (!isValid) {
        item.area = [7, 7];
        isValid = layoutCacheManager.isPositionValid(item, 0, 7, 7);
      }
      if (!isValid) {
        item.area = [1, 1];
        isValid = layoutCacheManager.isPositionValid(item, 0, 0, 0);
      }
      if (!isValid) {
        isValid = layoutCacheManager.isPositionValid(item, 0, 1, 1);
      }

      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(isValid).assertEqual(true);
    })

    it('isPositionOccupied00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);

      let isOccupied: boolean = layoutCacheManager.isPositionOccupied(0, 0, 0);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(isOccupied).assertEqual(true);
    })

    it('isPositionOccupied00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);

      let isOccupied: boolean = layoutCacheManager.isPositionOccupied(0, 1, 1);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(isOccupied).assertEqual(false);
    })

    it('deleteGridLayoutItemByBundleNameAndType00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.deleteGridLayoutItemByBundleNameAndType('bundleName', CommonConstants.TYPE_APP, 'DT', true);
      layoutCacheManager.deleteGridLayoutItemByBundleNameAndType(bundleName, CommonConstants.TYPE_APP, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let resLength: number = gridLayoutList.length
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(resLength).assertEqual(0);
    })

    it('deleteGridLayoutItemById00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);

      let deleteItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      deleteItem.typeId = CommonConstants.TYPE_APP;
      deleteItem.infoId = infoId;
      deleteItem.keyName = keyName;
      layoutCacheManager.deleteGridLayoutItemById(null, 'DT', true);
      layoutCacheManager.deleteGridLayoutItemById(deleteItem, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let resLength: number = gridLayoutList.length
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(resLength).assertEqual(0);
    })

    it('deleteGridLayoutItemByItemId00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);

      layoutCacheManager.deleteGridLayoutItemByItemId(infoId, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let resLength: number = gridLayoutList.length
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(resLength).assertEqual(0);
    })

    it('deleteGridLayoutItemByPosition00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);

      layoutCacheManager.deleteGridLayoutItemByPosition(-1, 0, 0, 'DT', true);
      layoutCacheManager.deleteGridLayoutItemByPosition(0, 0, 0, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let resLength: number = gridLayoutList.length
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(resLength).assertEqual(0);
    })

    it('deleteAppItemByKeyName00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);

      layoutCacheManager.deleteAppItemByKeyName('keyName', 'DT', true);
      layoutCacheManager.deleteAppItemByKeyName(keyName, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let resLength: number = gridLayoutList.length
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(resLength).assertEqual(0);
    })

    it('updateGridLayoutItemPositionById00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let updateItem: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoApp);
      updateItem.row = 1;
      updateItem.column = 1;

      layoutCacheManager.updateGridLayoutItemPositionById(null, 'DT', true);
      updateItem.keyName = 'keyName';
      layoutCacheManager.updateGridLayoutItemPositionById(updateItem, 'DT', true);
      updateItem.keyName = keyName;
      layoutCacheManager.updateGridLayoutItemPositionById(updateItem, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(res).assertEqual(updateItem);
    })

    it('insertGridLayoutItemInfo00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let updateItem: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoApp);
      updateItem.row = 1;
      updateItem.column = 1;
      layoutCacheManager.insertGridLayoutItemInfo(null, 'DT', true);
      layoutCacheManager.insertGridLayoutItemInfo(updateItem, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(gridLayoutList.length).assertEqual(2);
    })

    it('insertGridLayoutItemAndUpdatePosition00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let updateItem: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoApp);
      updateItem.row = 1;
      updateItem.column = 1;

      layoutCacheManager.insertGridLayoutItemAndUpdatePosition(null, 'DT', true);
      layoutCacheManager.insertGridLayoutItemAndUpdatePosition(updateItem, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let resLength: number = gridLayoutList.length;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(resLength).assertEqual(2);
    })

    it('updatePageCount00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);

      layoutCacheManager.updatePageCount(-1, 'DT', true);
      layoutCacheManager.updatePageCount(2, 'DT', true);
      let pageCount: number = layoutCacheManager.selectPageCount();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(pageCount).assertEqual(2);
    })

    it('updateLayoutAfterDeletePages00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
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
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterDeletePages([], 'DT', true);
      layoutCacheManager.updateLayoutAfterDeletePages([0], 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(0);
    })

    it('updateLayoutAfterAddPage00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
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
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterAddPage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(2);
    })

    it('updateLayoutAfterDeletePage00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
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
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterDeletePage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(0);
    })

    it('deleteDuplicateItemById00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      layoutInfoList.push(demoApp);
      let demoCard: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoApp);
      demoCard.typeId = CommonConstants.TYPE_CARD;
      demoCard.cardId = 2;
      layoutInfoList.push(demoCard);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);

      let deleteItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      deleteItem.typeId = CommonConstants.TYPE_APP;
      deleteItem.infoId = infoId;
      deleteItem.keyName = keyName;
      layoutCacheManager.deleteDuplicateItemById(null, 'DT', true);
      layoutCacheManager.deleteDuplicateItemById(deleteItem, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let resLength: number = gridLayoutList.length
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(resLength).assertEqual(0);
    })

    it('updateLayoutAfterAddPage01', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 2;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterAddPage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(2);
    })

    it('updateLayoutAfterAddPage02', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
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
      demoApp.row = 1;
      demoApp.column = 1;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterAddPage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(2);
    })

    it('updateLayoutAfterAddPage03', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 3;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterAddPage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(2);
    })

    it('updateLayoutAfterAddPage04', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 3;
      demoApp.row = 1;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterAddPage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(2);
    })

    it('updateLayoutAfterAddPage05', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 3;
      demoApp.row = 2;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterAddPage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(2);
    })

    it('updateLayoutAfterAddPage06', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 3;
      demoApp.row = 0;
      demoApp.column = 1;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterAddPage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(2);
    })

    it('updateLayoutAfterAddPage07', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 3;
      demoApp.row = 0;
      demoApp.column = 2;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterAddPage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(2);
    })

    it('updateLayoutAfterAddPage08', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 2;
      demoApp.row = 2;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterAddPage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(2);
    })

    it('updateLayoutAfterAddPage09', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 2;
      demoApp.row = 3;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterAddPage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(2);
    })

    it('updateLayoutAfterAddPage10', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 2;
      demoApp.row = 0;
      demoApp.column = 3;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterAddPage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(2);
    })

    it('updateLayoutAfterAddPage11', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
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
      demoApp.row = 2;
      demoApp.column = 2;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterAddPage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(2);
    })

    it('updateLayoutAfterAddPage12', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
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
      demoApp.row = 3;
      demoApp.column = 2;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterAddPage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(2);
    })

    it('updateLayoutAfterAddPage13', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 4;
      demoApp.row = 1;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterAddPage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(2);
    })

    it('updateLayoutAfterAddPage14', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 4;
      demoApp.row = 2;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterAddPage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(2);
    })

    it('updateLayoutAfterAddPage15', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 4;
      demoApp.row = 3;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterAddPage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(2);
    })

    it('updateLayoutAfterAddPage16', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 4;
      demoApp.row = 0;
      demoApp.column = 1;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterAddPage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(2);
    })

    it('updateLayoutAfterAddPage17', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 4;
      demoApp.row = 0;
      demoApp.column = 2;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterAddPage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(2);
    })

    it('updateLayoutAfterAddPage18', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 4;
      demoApp.row = 0;
      demoApp.column = 3;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterAddPage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(2);
    })

    it('updateLayoutAfterAddPage19', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 4;
      demoApp.row = 1;
      demoApp.column = 1;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterAddPage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(2);
    })

    it('updateLayoutAfterAddPage20', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 4;
      demoApp.row = 2;
      demoApp.column = 2;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      layoutCacheManager.updatePageCount(2, 'DT', true);

      layoutCacheManager.updateLayoutAfterAddPage(0, 1, 'DT', true);
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (gridLayoutList.length >= 1) {
        res = gridLayoutList[0];
      }
      let page: number | undefined = res ? res.page : -1;
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(page).assertEqual(2);
    })
  })
}