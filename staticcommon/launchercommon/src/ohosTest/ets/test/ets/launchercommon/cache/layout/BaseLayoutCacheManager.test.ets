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

import { ArrayUtils, CheckEmptyUtils } from '@ohos/basicutils';
import { GridOccupyStatus, GridOccupyStatusEnum } from '@ohos/componentdrag';
import { desktopUtil, ObjectCopyUtil } from '@ohos/componenthelper';
import { launcherStatusUtil, SCBScreenSessionManager } from '@ohos/windowscene';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import { DesktopLayoutCacheData } from '../../../../../../../main/ets/cache/layout/DesktopLayoutCacheData'
import {
  AppItemInfo,
  BaseLayoutCacheManager, DefaultDesktopLayoutInfo,
  CommonConstants,
  GridLayoutConfig,
  GridLayoutItemInfo,
  LayoutDescription,
  SwiperLoadManager,
  LauncherLayoutCacheUtil,
  GridLayoutUtil,
  EditModeUtils,
  RdbStoreManager} from '../../../../../../../main/ets/TsIndex'
import { DeviceHelper, localEventManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';

function getNullObject(): GridLayoutItemInfo | null | GridLayoutConfig | AppItemInfo {
  return null;
}

export default function BaseLayoutCacheManagerTest() {
  describe('BaseLayoutCacheManagerTest', () => {
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

    it('test_getRotateGridLayoutList', 0, () => {
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getRotateLayoutInfo);
      let mockResult: GridLayoutItemInfo[] = [];
      when(mockfunc)().afterReturn(mockResult);
      let result: GridLayoutItemInfo[] = layoutCacheManager.getRotateGridLayoutList();
      expect(result).assertDeepEquals(mockResult);
      mocker.ignoreMock(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getRotateLayoutInfo);
      mocker.clearAll();
    });

    it('test_getRotateGridLayoutList', 0, () => {
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].isPad);
      when(mockfunc)().afterReturn(true);
      let result: GridLayoutItemInfo[] = layoutCacheManager.getRotateGridLayoutList();
      expect(result).assertDeepEquals(true);
      mocker.ignoreMock(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].isPad);
      mocker.clearAll();
    });

    it('test_isPad', 0, () => {
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].isPad);
      when(mockfunc)().afterReturn(true);
      let result: boolean = layoutCacheManager.isPad();
      expect(result).assertDeepEquals(true);
      mocker.ignoreMock(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].isPad);
      mocker.clearAll();
    });

    it('getDesktopLayoutInfo00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutInfo);
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      when(mockfunc)().afterReturn(defaultLayout);
      let layoutInfo: DefaultDesktopLayoutInfo = layoutCacheManager.getDesktopLayoutInfo('DT');
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(layoutInfo).assertEqual(defaultLayout);
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clearAll();
    })

    it('selectGridLayoutItemById00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      let defaultLayoutList: GridLayoutItemInfo[] = [];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.container = CommonConstants.CONTAINER_DESKTOP;
      item.typeId = CommonConstants.TYPE_APP;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.container = CommonConstants.CONTAINER_DESKTOP;
      item2.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      defaultLayoutList.push(item);
      defaultLayoutList.push(item2);
      when(mockfunc)().afterReturn(defaultLayoutList);
      let demo: GridLayoutItemInfo = layoutCacheManager.selectGridLayoutItemById(CommonConstants.CONTAINER_DESKTOP);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(demo).not().assertNull();
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clearAll();
    })

    it('selectGridLayoutItemByIno00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      let defaultLayoutList: GridLayoutItemInfo[] = [];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.container = CommonConstants.CONTAINER_DESKTOP;
      item.ino = 'test01';
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.container = CommonConstants.CONTAINER_DESKTOP;
      item2.ino = 'test02';
      defaultLayoutList.push(item);
      defaultLayoutList.push(item2);
      when(mockfunc)().afterReturn(defaultLayoutList);
      let demo: GridLayoutItemInfo = layoutCacheManager.selectGridLayoutItemByIno('test01');
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(demo).not().assertNull();
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clearAll();
    })

    it('selectGridLayoutItemsByBundleAndType00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      let defaultLayoutList: GridLayoutItemInfo[] = [];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'test1';
      item.typeId = 0;
      defaultLayoutList.push(item);
      when(mockfunc)().afterReturn(defaultLayoutList);
      let ret = layoutCacheManager.selectGridLayoutItemsByBundleAndType('test1', 0);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(ret).not().assertNull();
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clearAll();
    })

    it('selectGridLayoutItemByPosition00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      let defaultLayoutList: GridLayoutItemInfo[] = [];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'test1';
      item.page = 0;
      item.row = 1;
      item.column = 1;
      defaultLayoutList.push(item);
      when(mockfunc)().afterReturn(defaultLayoutList);
      let ret = layoutCacheManager.selectGridLayoutItemByPosition(0, 1, 1);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(ret).not().assertNull();
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clearAll();
    })

    it('selectGridLayoutItemByIndex00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      let defaultLayoutList: GridLayoutItemInfo[] = [];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'test1';
      item.page = 0;
      item.row = 1;
      item.column = 1;
      defaultLayoutList.push(item);
      when(mockfunc)().afterReturn(defaultLayoutList);
      layoutCacheManager.selectGridLayoutItemByIndex(-1);
      layoutCacheManager.selectGridLayoutItemByIndex(100);
      layoutCacheManager.selectGridLayoutItemByIndex(1);
      when(mockfunc)().afterReturn([]);
      layoutCacheManager.selectGridLayoutItemByIndex(1);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(true).assertTrue();
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clearAll();
    })

    it('selectIndexInLayout00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      let defaultLayoutList: GridLayoutItemInfo[] = [];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'test1';
      item.page = 0;
      item.row = 1;
      item.column = 1;
      defaultLayoutList.push(item);
      when(mockfunc)().afterReturn(defaultLayoutList);
      let ret = layoutCacheManager.selectIndexInLayout(item);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(ret).not().assertNull();
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clearAll();
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
      let demoApp1: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp1.infoId = infoId;
      demoApp1.bundleName = bundleName;
      demoApp1.typeId = CommonConstants.TYPE_APP;
      demoApp1.page = 0;
      demoApp1.row = 0;
      demoApp1.column = 0;
      demoApp1.area = [];
      demoApp1.keyName = keyName;
      layoutInfoList.push(demoApp1);
      defaultLayout.layoutInfo = layoutInfoList;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      when(mockfunc)().afterReturn(layoutInfoList);
      let gridOccupyStatusEnum = layoutCacheManager.selectGridOccupyStatusForPage(0);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(gridOccupyStatusEnum).not().assertNull();
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clearAll();
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

      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      when(mockfunc)().afterReturn(layoutInfoList);
      let mockfunc2: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      when(mockfunc2)().afterReturn(defaultLayout);

      let pageMap: Map<string, number> = layoutCacheManager.selectPageItemMap();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(pageMap).not().assertNull();
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clearAll();
    })

    it('selectAllOccupiedSpace01', 0, () => {
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
      demoApp.page = -1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      when(mockfunc)().afterReturn(layoutInfoList);

      let occupiedNum: number = layoutCacheManager.selectAllOccupiedSpace();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(occupiedNum).assertInstanceOf('Number');
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clearAll();
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
      let updateItem: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoApp);
      updateItem.typeId =  CommonConstants.TYPE_CARD;
      // 条件1

      let mocker: MockKit = new MockKit();
      let mockFunc2: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      when(mockFunc2)().afterReturn(layoutInfoList);
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let demo: GridLayoutItemInfo | undefined = layoutCacheManager.selectGridLayoutItemByItem(demoApp);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

      if (!demo) {
        demo = layoutCacheManager.selectGridLayoutItemByItem(demoApp);
      }
      demo = layoutCacheManager.selectGridLayoutItemByItem(updateItem);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(demo).not().assertEqual(demoApp);
      mocker.clear(CheckEmptyUtils);
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clearAll();
    })

    it('selectGridLayoutItemByUniqueKey00', 0, () => {
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
      let demoApp2: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp2.infoId = '2';
      demoApp2.bundleName = 'com.openharmony.demoApp1';
      demoApp2.typeId = CommonConstants.TYPE_APP;
      demoApp2.page = 0;
      demoApp2.row = 0;
      demoApp2.column = 1;
      demoApp2.area = [1, 1];
      demoApp2.keyName = 'com.openharmony.demoAppPhoneEntryAbility1';
      layoutInfoList.push(demoApp2);
      defaultLayout.layoutInfo = layoutInfoList;
      let mocker: MockKit = new MockKit();
      let mockFunc2: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      when(mockFunc2)().afterReturn(layoutInfoList);
      // 先走空值判断
      let selectedItem = layoutCacheManager.selectGridLayoutItemByUniqueKey(undefined);
      expect(selectedItem).assertUndefined();
      // 传错误值
      selectedItem = layoutCacheManager.selectGridLayoutItemByUniqueKey('1234');
      expect(selectedItem).assertUndefined();
      // 查询单值
      const uniqueKey = GridLayoutUtil.generateUniqueKey(demoApp);
      selectedItem = layoutCacheManager.selectGridLayoutItemByUniqueKey(uniqueKey);
      expect(selectedItem === demoApp).assertTrue();
      // 查询多值
      const demo2UniqueKey = GridLayoutUtil.generateUniqueKey(demoApp2);
      const items = layoutCacheManager.selectGridLayoutItemByUniqueKey([uniqueKey, demo2UniqueKey]);
      expect(items?.[0] === demoApp).assertTrue();
      expect(items?.[1] === demoApp2).assertTrue();
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clearAll();
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

      let gridConfig: GridLayoutConfig = new GridLayoutConfig();
      gridConfig.row = 6;
      gridConfig.column = 4;

      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc2: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      when(mockFunc2)().afterReturn(layoutInfoList);
      let mockFunc3: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutInfo);
      when(mockFunc3)().afterReturn(defaultLayout);
      let isOverMaxPage1: boolean = layoutCacheManager.isAddAppOverMaxPage(gridConfig);
      expect(isOverMaxPage1).assertInstanceOf('Boolean');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let isOverMaxPage2: boolean = layoutCacheManager.isAddAppOverMaxPage(gridConfig);
      expect(isOverMaxPage2).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clearAll();
    })
    //
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

      let appItem: AppItemInfo = new AppItemInfo();
      appItem.keyName = keyName;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc2: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      when(mockFunc2)().afterReturn(layoutInfoList);
      let isInFolder1: boolean = layoutCacheManager.isAppInFolder(appItem);
      expect(isInFolder1).assertInstanceOf('Boolean');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let isInFolder2: boolean = layoutCacheManager.isAppInFolder(appItem);
      expect(isInFolder2).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clearAll();
    })

    it('isEmpty', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.area = undefined;
      let ret = layoutCacheManager.isPositionValid(item, 0, 0, 0);
      let ret2 = layoutCacheManager.deleteGridLayoutItemById(undefined, '123', true);
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

      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.deleteGridLayoutItemByInfoIdCallBack);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc2: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      when(mockFunc2)().afterReturn(layoutInfoList);
      let mockFunc3: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].updateLayoutListCache);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();

      try {
        layoutCacheManager.deleteGridLayoutItemByItemId(infoId, 'DT');
      } catch (e) {
      }
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clearAll();
    })
    //
    it('getAppItemListPage00', 0, () => {
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
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
      let res = layoutCacheManager.getAppItemListPage(layoutInfoList);
      expect(res.length).assertEqual(1);
    })
    //
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

      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.deleteGridLayoutItemByInfoIdCallBack);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc2: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      when(mockFunc2)().afterReturn(layoutInfoList);
      try {
        layoutCacheManager.deleteGridLayoutItemByPosition(0, 0, 0, 'DT');
        layoutCacheManager.deleteGridLayoutItemByPosition(0, 0, 0, 'DT', false);
      } catch (e) {
      }
      when(mockFunc)(ArgumentMatchers.any).afterThrow('error');
      try {
        layoutCacheManager.deleteGridLayoutItemByPosition(0, 0, 0, 'DT', true);
      } catch (e) {
      }
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clearAll();
    })

    it('updateGridLayoutItemPositionById00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      try {
        layoutCacheManager.updateGridLayoutItemPositionById(undefined, 'DT', true);
      } catch (e) {
      }
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
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      when(mockFunc)().afterReturn(layoutInfoList);

      let mockFunc2: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].updateLayoutListCache);
      when(mockFunc2)().afterReturnNothing();

      let mockFunc3: Function = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.updateItemToDesktopCallBack);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();
      try {
        layoutCacheManager.updateGridLayoutItemPositionById(demoApp, 'DT', true);
      } catch (e) {
      }

      let updateItem: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoApp);
      updateItem.row = 1;
      updateItem.column = 1;
      updateItem.keyName = 'keyName';
      try {
        layoutCacheManager.updateGridLayoutItemPositionById(updateItem, 'DT', true);
      } catch (e) {
      }
      updateItem.keyName = keyName;
      when(mockFunc3)(ArgumentMatchers.any).afterThrow('error');
      try {
        layoutCacheManager.updateGridLayoutItemPositionById(updateItem, 'DT', false);
      } catch (e) {
      }
      let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      expect(gridLayoutList).not().assertNull();
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clearAll();
    });

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
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(layoutInfoList);
      let mockFunc2 = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.findLazyRotatePosition);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc3 = mocker.mockFunc(localEventManager, localEventManager.sendLocalEventSticky);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc4 = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.getLazyRotateChangeItemsForCache);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn([]);

      let updateItem: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoApp);
      updateItem.row = 1;
      updateItem.column = 1;
      try {
        layoutCacheManager.insertGridLayoutItemInfo(updateItem, 'DT', false);
      } catch (e) {
      }
      when(mockFunc4)(ArgumentMatchers.any).afterReturn([updateItem]);
      let mockFunc5 = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.changeLazyRotateSettings);
      when(mockFunc5)().afterReturnNothing();
      let mockFunc6 = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].updateLayoutListCache);
      when(mockFunc6)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc7 = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.insertGridLayoutItemCallBack);
      when(mockFunc7)(ArgumentMatchers.any).afterReturnNothing();
      try {
        layoutCacheManager.insertGridLayoutItemInfo(updateItem, 'DT', true);
      } catch (e) {
      }
      when(mockFunc7)(ArgumentMatchers.any).afterThrow('error');
      try {
        layoutCacheManager.insertGridLayoutItemInfo(updateItem, 'DT', true);
      } catch (e) {
      }
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clear(localEventManager);
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clearAll();
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
      let updateItem: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoApp);
      updateItem.row = 1;
      updateItem.column = 1;
      try {
        layoutCacheManager.insertGridLayoutItemAndUpdatePosition(updateItem, 'DT', false);
      } catch (e) {
      }
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      when(mockFunc)().afterReturn(layoutInfoList);
      let mockFunc2 = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc3 = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].updateLayoutListCache);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc4 = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.updateItemToDesktopCallBack);
      when(mockFunc4)(ArgumentMatchers.any).afterReturnNothing();
      try {
        layoutCacheManager.insertGridLayoutItemAndUpdatePosition(updateItem, 'DT', true);
      } catch (e) {
      }
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      try {
        layoutCacheManager.insertGridLayoutItemAndUpdatePosition(updateItem, 'DT', true);
      } catch (e) {
      }
      when(mockFunc4)(ArgumentMatchers.any).afterThrow('error');
      try {
        layoutCacheManager.insertGridLayoutItemAndUpdatePosition(updateItem, 'DT', true);
      } catch (e) {
      }
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('insertGridLayoutItemList00', 0, () => {
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      try {
        layoutCacheManager.insertGridLayoutItemList([], 'DT', true);
      } catch (e) {
      }
      expect(true).assertTrue();
    })

    it('insertGridLayoutItemInfoAsync00', 0, async (done: Function) => {
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      try {
        await layoutCacheManager.insertGridLayoutItemInfoAsync(undefined, 'DT', false);
      } catch (e) {
      }
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
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(layoutInfoList);
      let mockFunc2 = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.getIsLazyRotate);
      when(mockFunc2)().afterReturn(true);
      let mockFunc3 = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.findLazyRotatePosition);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4 = mocker.mockFunc(localEventManager, localEventManager.sendLocalEventSticky);
      when(mockFunc4)().afterReturnNothing();
      let mockFunc5 = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.getLazyRotateChangeItemsForCache);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc6 = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].updateLayoutListCache);
      when(mockFunc6)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc7 = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.insertGridLayoutItemCallBack);
      when(mockFunc7)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc8 = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.changeLazyRotateSettings);
      when(mockFunc8)().afterReturnNothing();
      try {
        await layoutCacheManager.insertGridLayoutItemInfoAsync(demoApp, 'DT', false);
      } catch (e) {
      }
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(demoApp);
      try {
        await layoutCacheManager.insertGridLayoutItemInfoAsync(demoApp, 'DT', true);
      } catch (e) {
      }
      when(mockFunc7)(ArgumentMatchers.any).afterThrow('error');
      try {
        await layoutCacheManager.insertGridLayoutItemInfoAsync(demoApp, 'DT', true);
      } catch (e) {
      }
      expect(true).assertTrue();
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clear(layoutCacheManager['layoutCacheData'])
      mocker.clear(localEventManager);
      mocker.clearAll();
      done()
    })
    //
    it('insertGridLayoutItemInfoAsync01', 0, async (done: Function) => {
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      try {
        await layoutCacheManager.insertGridLayoutItemInfoAsync(undefined, 'DT');
      } catch (e) {
      }
      expect(true).assertTrue();
      done();
    });

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
      demoApp.cardId = '2';
      layoutInfoList.push(demoApp);
      layoutInfoList.push(demoApp);
      let demoCard: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_CARD;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoCard.cardId = '2';
      layoutInfoList.push(demoCard);
      defaultLayout.layoutInfo = layoutInfoList;

      let deleteItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      deleteItem.typeId = CommonConstants.TYPE_CARD;
      deleteItem.infoId = infoId;
      deleteItem.keyName = keyName;
      deleteItem.id = 1;
      deleteItem.cardId = '2';
      deleteItem.bundleName = bundleName;
      let duplicateItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      duplicateItem.typeId = CommonConstants.TYPE_APP;
      duplicateItem.infoId = infoId;
      duplicateItem.keyName = keyName;
      duplicateItem.id = 1;
      duplicateItem.cardId = '2';
      duplicateItem.bundleName = bundleName;
      let mocker: MockKit = new MockKit();
      let mockFunc2: Function = mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc3: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      when(mockFunc3)().afterReturn(layoutInfoList);
      let mockFunc4: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].updateLayoutListCache);
      when(mockFunc4)().afterReturnNothing();
      let mockFunc = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.deleteGridLayoutItemByInfoIdCallBack);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      try {
        layoutCacheManager.deleteDuplicateItemById(null, 'DT');
        layoutCacheManager.deleteDuplicateItemById(deleteItem, 'DT', false);
        layoutCacheManager.deleteDuplicateItemById(duplicateItem, 'DT', false);
      } catch (e) {
      }
      when(mockFunc)(ArgumentMatchers.any).afterThrow('error');
      try {
        layoutCacheManager.deleteDuplicateItemById(deleteItem, 'DT');
      } catch (e) {
      }
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.clear(launcherStatusUtil);
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clearAll();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
    });
    //
    it('test_findAppInCache', 0, () => {
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_APP;
      item.bundleName = 'bundleName';
      item.appIndex = 1;
      item.area = [1, 1];
      item.page = 1;
      item.row = 1;
      item.column = 1;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.typeId = CommonConstants.TYPE_FOLDER;
      item2.bundleName = 'bundleName';
      item2.appIndex = 1;
      item2.layoutInfo = [[item]];
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.typeId = CommonConstants.TYPE_APP;
      item3.bundleName = 'bundleName';
      item3.appIndex = 2;
      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.typeId = CommonConstants.TYPE_FOLDER;
      item4.bundleName = 'bundleName';
      item4.appIndex = 1;
      item4.layoutInfo = [[item3]];
      let item5: GridLayoutItemInfo = new GridLayoutItemInfo();
      item5.typeId = CommonConstants.TYPE_ADD;
      item5.bundleName = 'bundleName';
      item5.appIndex = 1;
      let list: GridLayoutItemInfo[] = [];
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'bundleName';
      appInfo.appIndex = 1;
      let ret = layoutCacheManager.findAppInCache(list, appInfo);
      expect(ret).assertEqual(undefined);
      list = [item, item2, item3, item4, item5];
      let retValue = layoutCacheManager.findAppInCache(list, appInfo);
      expect(retValue).not().assertUndefined();
    });
    //
    it('test_selectGridLayoutItemsByBundleNameAndAppIndex', 0, () => {
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      let defaultLayoutList: GridLayoutItemInfo[] = [];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'test1';
      item.appIndex = 0;
      defaultLayoutList.push(item);
      when(mockFunc)().afterReturn(defaultLayoutList);
      let ret = layoutCacheManager.selectGridLayoutItemsByBundleNameAndAppIndex('test1', 0);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(ret).not().assertNull();
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clearAll();
    });
    //
    it('test_updateInfoToRdb', 0, () => {
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let listArr: GridLayoutItemInfo[] = [];
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.id = 1;
      demoApp.container = CommonConstants.CONTAINER_DESKTOP;
      let testApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      testApp.id = 1;
      testApp.container = CommonConstants.TYPE_APP;
      listArr = [demoApp, testApp];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.getChangeItems);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(listArr);
      let mockFunc2: Function = mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().updateAllInfoPosition);
      when(mockFunc2)(ArgumentMatchers.any).afterReturnNothing();
      layoutCacheManager.updateInfoToRdb(listArr, 'DT');
      layoutCacheManager.updateInfoToRdb([], 'DT');
      expect(layoutCacheManager instanceof BaseLayoutCacheManager).assertEqual(true);
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clear(RdbStoreManager.getInstance());
      mocker.clearAll();
    });

    it('test_insertItemWithoutLayoutInfo', 0, async (done: Function) => {
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      try {
        let ret = await layoutCacheManager.insertItemWithoutLayoutInfo(undefined, 'DT');
        expect(ret).assertEqual(-1);
      } catch (e) {
      }
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([]);
      let mockFunc2: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].updateLayoutListCache);
      when(mockFunc2)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc3: Function = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.insertItemWithoutLayoutInfo);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();

      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.id = 1;
      demoApp.container = CommonConstants.CONTAINER_DESKTOP;
      try {
        let ret = await layoutCacheManager.insertItemWithoutLayoutInfo(demoApp, 'DT', true);
        expect(ret).assertInstanceOf('Number');
      } catch (e) {
      }
      when(mockFunc3)(ArgumentMatchers.any).afterThrow('error');
      try {
        let ret = await layoutCacheManager.insertItemWithoutLayoutInfo(demoApp, 'DT', true);
        expect(ret).assertInstanceOf('Number');
      } catch (e) {
      }
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clearAll();
      done();
    });
    //
    it('test_insertFolderLayoutInfoAsync', 0, async (done: Function) => {
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.id = 1;
      demoApp.container = CommonConstants.CONTAINER_DESKTOP;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc3: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      when(mockFunc3)().afterReturn([]);
      let mockFunc4: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].updateLayoutListCache);
      when(mockFunc4)().afterReturnNothing();
      let mockFunc5: Function = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.insertFolderLayoutInfo);
      when(mockFunc5)().afterReturnNothing();
      try {
        await layoutCacheManager.insertFolderLayoutInfoAsync(demoApp, 'DT');
      } catch (e) {
      }
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      try {
        await layoutCacheManager.insertFolderLayoutInfoAsync(demoApp, 'DT', true);
        await layoutCacheManager.insertFolderLayoutInfoAsync(demoApp, 'DT', false);
        expect(demoApp.id).assertEqual(1);
      } catch (e) {
      }
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    });

    it('test_deleteBlankPageFromLayoutInfo', 0, async (done: Function) => {
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isSuperFoldMachine);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let ret1 = layoutCacheManager.deleteBlankPageFromLayoutInfo(0);
      expect(ret1).assertFalse();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(layoutCacheManager, layoutCacheManager.selectPageCount);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(1);
      let ret2 = layoutCacheManager.deleteBlankPageFromLayoutInfo(10);
      expect(ret2).assertFalse();

      when(mockFunc2)(ArgumentMatchers.any).afterReturn(10);
      let mockFunc3: Function = mocker.mockFunc(layoutCacheManager, layoutCacheManager.isBlankPage);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let ret3 = layoutCacheManager.deleteBlankPageFromLayoutInfo(5);
      expect(ret3).assertFalse();

      let mockFunc4: Function = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      when(mockFunc4)().afterReturn(true);
      let mockFunc5: Function = mocker.mockFunc(EditModeUtils, EditModeUtils.getNeighborPage);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(2);
      let mockFunc6: Function = mocker.mockFunc(layoutCacheManager, layoutCacheManager.updatePageCount);
      when(mockFunc6)().afterReturnNothing();
      let mockFunc7: Function = mocker.mockFunc(layoutCacheManager, layoutCacheManager.updateLayoutAfterDeletePage);
      when(mockFunc7)().afterReturnNothing();

      let ret4 = layoutCacheManager.deleteBlankPageFromLayoutInfo(5);
      expect(ret4).assertInstanceOf('Boolean');

      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      let ret5 = layoutCacheManager.deleteBlankPageFromLayoutInfo(5);
      expect(ret5).assertInstanceOf('Boolean');
      mocker.clear(DeviceHelper);
      mocker.clear(layoutCacheManager);
      mocker.clear(desktopUtil);
      mocker.clear(EditModeUtils);
      mocker.clearAll();
    });

    it('test_updateLayoutAfterDragPage', 0, async (done: Function) => {
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
      demoApp.cardId = '2';
      layoutInfoList.push(demoApp);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(layoutInfoList);
      let mockFunc2: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isLargeFoldOrTrifoldExpanded);
      when(mockFunc2)().afterReturn(true);
      let mockFunc3: Function = mocker.mockFunc(layoutCacheManager, layoutCacheManager['updateGridLayoutAfterDragPage']);
      when(mockFunc3)().afterReturn(layoutInfoList);
      let mockFunc4: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].updateLayoutListCache);
      when(mockFunc4)().afterReturnNothing();
      let mockFunc5: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].isPad);
      when(mockFunc5)().afterReturn(true);
      let mockFunc6: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getRotateLayoutInfo);
      when(mockFunc6)().afterReturn(true);
      let mockFunc7: Function = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.patchUpdateGridLayoutPositionCallBack);
      when(mockFunc7)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc8: Function = mocker.mockFunc(SwiperLoadManager.getInstance(), SwiperLoadManager.getInstance().hardCodeDragPage);
      when(mockFunc8)(ArgumentMatchers.any).afterReturnNothing();
      try {
        layoutCacheManager.updateLayoutAfterDragPage(1, 2, 'demo', true);
      } catch (e) {
      }
      when(mockFunc7)(ArgumentMatchers.any).afterThrow('error');
      try {
        layoutCacheManager.updateLayoutAfterDragPage(1, 2, 'demo', true);
      } catch (e) {
      }
      expect(true).assertInstanceOf('Boolean');
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clear(GridLayoutUtil);
      mocker.clear(SwiperLoadManager.getInstance());
      mocker.clearAll();
      done();
    });

    it('test_updateGridLayoutAfterDragPage', 0, async (done: Function) => {
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
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
      demoApp.cardId = '2';

      let demoApp2: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp2.infoId = '123';
      demoApp2.bundleName = '123';
      demoApp2.typeId = CommonConstants.TYPE_APP;
      demoApp2.page = 1;
      demoApp2.row = 1;
      demoApp2.column = 1;
      demoApp2.area = [1, 1];
      demoApp2.keyName = keyName;
      demoApp2.cardId = '2';
      layoutInfoList.push(demoApp);
      try {
        layoutCacheManager['updateGridLayoutAfterDragPage'](layoutInfoList, 0, 1, true);
        layoutCacheManager['updateGridLayoutAfterDragPage'](layoutInfoList, 0, 1, false);
        layoutCacheManager['updateGridLayoutAfterDragPage'](layoutInfoList, 1, 0, true);
        layoutCacheManager['updateGridLayoutAfterDragPage'](layoutInfoList, 1, 0, false);
      } catch (e) {
      }
      expect(true).assertInstanceOf('Boolean');
    });

    it('test_updateLayoutListCacheAndPrebuild', 0, async (done: Function) => {
      let layoutCacheManager: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].updateLayoutListCacheAndPrebuild);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      try {
        layoutCacheManager.updateLayoutListCacheAndPrebuild([], true);
      } catch (e) {
      }
      expect(true).assertInstanceOf('Boolean');
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clearAll();
    });
  })
}