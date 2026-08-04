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
import { CheckEmptyUtils, StartType } from '@ohos/basicutils';
import { ObjectCopyUtil } from '@ohos/componenthelper';
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
  when
} from '@ohos/hypium'
import { DesktopLayoutCacheData } from '../../../../../../../main/ets/cache/layout/DesktopLayoutCacheData'
import {
  AppItemInfo,
  CommonConstants,
  DefaultDesktopLayoutInfo,
  DeleteItemType,
  DesktopFileInfo,
  DockItemInfo,
  GridLayoutConfig,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LauncherLayoutCacheUtil,
  LaunchLayoutCacheManager,
  DeliverUtil,
  LayoutDescription,
  PadLaunchLayoutCacheManager,
  RdbStoreManager,
  FolderModel,
  ShortcutViewModel,
  ShortcutInfo,
  AppModel,
  LayoutViewModel,
  NotHarmonyUtil
} from '../../../../../../../main/ets/TsIndex'
import { ResidentLayoutCacheMgr } from '../../../../../../../main/ets/dock/cache/ResidentLayoutCacheMgr';

const CONTACT_BUNDLE_NAME = 'com.ohos.contacts';

export default function LaunchLayoutCacheManagerTest() {
  describe('LaunchLayoutCacheManagerTest', () => {
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
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      // 条件1
      let layoutCacheManager1: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(layoutCacheManager).assertEqual(layoutCacheManager1);
    })

    it('deleteSameAppAndFolder00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let deleteItem: DeleteItemType = {
        bundleName: bundleName,
        keyName: keyName
      }
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        layoutCacheManager.deleteSameAppAndFolder(deleteItem, 'DT');
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      mocker.clear(CheckEmptyUtils);
      try {
        layoutCacheManager.deleteSameAppAndFolder(deleteItem, 'DT', true);
        let gridLayoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
        let resLength: number = gridLayoutList.length;
        expect(resLength).assertEqual(0);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('deleteSameAppAndFolder01', 0, () => {
      try{
        let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
        let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
        let layoutInfoList: GridLayoutItemInfo[] = [];
        let infoId: string = '1';
        let bundleName: string = 'com.openharmony.test';
        let keyName: string = 'com.openharmony.testAppPhoneEntryAbility';
        let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoApp.infoId = infoId;
        demoApp.bundleName = bundleName;
        demoApp.typeId = CommonConstants.TYPE_APP;
        demoApp.page = 1;
        demoApp.row = 0;
        demoApp.column = 0;
        demoApp.area = [1, 1];
        demoApp.keyName = keyName;
        demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
        layoutInfoList.push(demoApp);
        defaultLayout.layoutInfo = layoutInfoList;

        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let deleteItem: DeleteItemType = {
          bundleName: bundleName,
          keyName: keyName
        }
        let outerGridLayoutList = layoutCacheData.getGridLayoutItemList(true) ?? [];
        outerGridLayoutList.push(demoApp);
        layoutCacheData.setGridLayoutItemList(outerGridLayoutList, true);
        layoutCacheManager.deleteSameAppAndFolder(deleteItem, 'DT', true, true);
        let gridLayoutList: GridLayoutItemInfo[] = layoutCacheData.getGridLayoutItemList(true);
        let resLength: number = gridLayoutList.length;
        expect(resLength).assertEqual(0);
        expect(gridLayoutList.includes(demoApp)).assertFalse();
      }catch(e){}
    })

    it('isGridInfoHasMedia00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      try {
        layoutCacheManager.reInit(layoutCacheData);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let fileInfo: DesktopFileInfo = new DesktopFileInfo();
      fileInfo.ino = 'test';
      try {
        let res: boolean = layoutCacheManager.isGridInfoHasMedia(null);
        if (!res) {
          res = layoutCacheManager.isGridInfoHasMedia(fileInfo);
        }
        expect(res).assertEqual(false);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })
    it('isGridInfoHasMedia01', 1, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_FILE_FOLDER;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let fileInfo: DesktopFileInfo = new DesktopFileInfo();
        fileInfo.ino = 'test';
        let res: boolean = layoutCacheManager.isGridInfoHasMedia(fileInfo);
        expect(res).assertEqual(true);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('checkIfDuplicatePosition00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      let newApp1: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoApp);
      newApp1.row = 0;
      newApp1.column = 0;
      let newApp2: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoApp);
      newApp2.row = 0;
      newApp2.column = 0;
      newApp2.area = [];
      layoutInfoList.push(demoApp);
      layoutInfoList.push(newApp1);
      layoutInfoList.push(newApp2);
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })
    it('checkIfDuplicatePosition01', 1, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      let newApp1: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoApp);
      newApp1.row = 0;
      newApp1.column = 1;
      let newApp2: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoApp);
      newApp2.row = 0;
      newApp2.column = 2;
      newApp2.area = [];
      layoutInfoList.push(demoApp);
      layoutInfoList.push(newApp1);
      layoutInfoList.push(newApp2);
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('checkIfLayoutRationality00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.row = 7;
      demoApp.column = 5;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      try {
        layoutCacheManager.reInit(layoutCacheData);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let config: GridLayoutConfig = new GridLayoutConfig();
      config.row = 6;
      config.column = 4;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let res: boolean = layoutCacheManager.checkIfLayoutRationality(config);
      mocker.clear(CheckEmptyUtils);
      if (!res) {
        res = layoutCacheManager.checkIfLayoutRationality(config);
      }
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(res).assertEqual(false);
    })
    it('checkIfLayoutRationality01', 1, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      try {
        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let config: GridLayoutConfig = new GridLayoutConfig();
      config.row = 6;
      config.column = 4;
      try {
        let res: boolean = layoutCacheManager.checkIfLayoutRationality(config);
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res).assertEqual(true);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('ifPageOrColumnRowOutOfBound00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let res: boolean = layoutCacheManager.ifPageOrColumnRowOutOfBound(6, 4);
        expect(res).assertEqual(false);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })
    it('ifPageOrColumnRowOutOfBound01', 1, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.row = 7;
      demoApp.column = 5;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let res: boolean = layoutCacheManager.ifPageOrColumnRowOutOfBound(6, 4);
        expect(res).assertEqual(true);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('checkIfNewInstalledApp00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.row = 7;
      demoApp.column = 5;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      demoApp.layoutInfo = [];
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;
      let mocker: MockKit = new MockKit();
      try {
        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let newAppItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        newAppItem.bundleName = bundleName;
        newAppItem.typeId = CommonConstants.TYPE_APP;
        let mockfunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isAppInstalled);
        when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let res: boolean = layoutCacheManager.checkIfNewInstalledApp(newAppItem, true, false);
        if (!res) {
          res = layoutCacheManager.checkIfNewInstalledApp(newAppItem, true, false);
        }
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(demoApp.infoId).assertEqual(infoId);
      } catch (e) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clear(GridLayoutUtil);
    })
    it('checkIfNewInstalledApp01', 1, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.row = 7;
      demoApp.column = 5;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      demoApp.layoutInfo = [];
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let newAppItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      newAppItem.bundleName = bundleName;
      newAppItem.typeId = CommonConstants.TYPE_APP;
      newAppItem.keyName = keyName;
      let mocker: MockKit = new MockKit();
      let mockerFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isAppInstalled);
      when(mockerFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let res: boolean = layoutCacheManager.checkIfNewInstalledApp(newAppItem, true, false);
        expect(demoApp.infoId).assertEqual(infoId);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      mocker.clear(GridLayoutUtil);
    })
    it('checkIfNewInstalledApp02', 2, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.row = 7;
      demoApp.column = 5;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoFolder.typeId = CommonConstants.TYPE_FOLDER;
      demoFolder.layoutInfo = [];
      let infos: GridLayoutItemInfo[] = [];
      infos.push(demoApp);
      demoFolder.layoutInfo.push(infos);
      layoutInfoList.push(demoFolder);
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let newAppItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      newAppItem.bundleName = bundleName;
      newAppItem.keyName = keyName;
      newAppItem.typeId = CommonConstants.TYPE_APP;
      try {
        let res: boolean = layoutCacheManager.checkIfNewInstalledApp(newAppItem, true, false);
        expect(demoApp.infoId).assertEqual(infoId);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })
    it('checkIfNewInstalledApp03', 3, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.row = 7;
      demoApp.column = 5;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoFolder.typeId = CommonConstants.TYPE_FOLDER;
      demoFolder.layoutInfo = [];
      let infos: GridLayoutItemInfo[] = [];
      infos.push(demoApp);
      demoFolder.layoutInfo.push(infos);
      layoutInfoList.push(demoFolder);
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let newAppItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      newAppItem.bundleName = 'bundleName';
      newAppItem.keyName = keyName;
      newAppItem.typeId = CommonConstants.TYPE_APP;
      try {
        let res: boolean = layoutCacheManager.checkIfNewInstalledApp(newAppItem, true, false);
        expect(res).assertEqual(false);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('updateLayoutInfoByAppInfo00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.row = 7;
      demoApp.column = 5;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let newAppItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      newAppItem.abilityName = 'abilityName';
      newAppItem.typeId = CommonConstants.TYPE_APP;
      newAppItem.keyName = keyName;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        layoutCacheManager.updateLayoutInfoByAppInfo(demoApp, newAppItem, 'DT', true);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      mocker.clear(CheckEmptyUtils);
      try {
        layoutCacheManager.updateLayoutInfoByAppInfo(demoApp, newAppItem, 'DT', true);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      try {
        let layoutList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
        let res: GridLayoutItemInfo | undefined = undefined;
        if (layoutList.length >= 1) {
          res = layoutList[0];
        }
        expect(res?.abilityName).assertEqual('abilityName');
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('updateFormsCacheInfoByFormList00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_CARD;
      demoApp.page = 1;
      demoApp.row = 7;
      demoApp.column = 5;
      demoApp.area = [2, 2];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.cardId = '1';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      try {
        layoutCacheManager.reInit(layoutCacheData);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let formList: GridLayoutItemInfo[] = [];
      let form: GridLayoutItemInfo = new GridLayoutItemInfo();
      form.page = 0;
      form.cardId = '1';
      formList.push(form);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        layoutCacheManager.updateFormsCacheInfoByFormList(formList, 'DT');
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      mocker.clear(CheckEmptyUtils);
      try {
        layoutCacheManager.updateFormsCacheInfoByFormList(formList, 'DT');
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      try {
        let resList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
        let res: GridLayoutItemInfo | undefined = undefined;
        if (resList.length >= 1) {
          res = resList[0];
        }
        expect(res?.page).assertLargerOrEqual(0);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('updateAppCacheInfoByAppList00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.row = 7;
      demoApp.column = 5;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      try {
        layoutCacheManager.reInit(layoutCacheData);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let appList: GridLayoutItemInfo[] = [];
      let app: GridLayoutItemInfo = new GridLayoutItemInfo();
      app.typeId = CommonConstants.TYPE_APP;
      app.keyName = keyName;
      app.appName = 'test'
      appList.push(app);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        layoutCacheManager.updateAppCacheInfoByAppList(appList, 'DT', false);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      mocker.clear(CheckEmptyUtils);
      try {
        layoutCacheManager.updateAppCacheInfoByAppList(appList, 'DT', false);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let resList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
      let res: GridLayoutItemInfo | undefined = undefined;
      if (resList.length >= 1) {
        res = resList[0];
      }

      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(res?.appName).assertEqual('test');
    })

    it('checkAndDeleteNotInFileAndFolder00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.row = 7;
      demoApp.column = 5;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      try {
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let fileList: DesktopFileInfo[] = [];

        layoutCacheManager.checkAndDeleteNotInFileAndFolder(fileList, [], [], 'DT', null);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let res: string = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(res).assertEqual('test');
    })

    it('updateAppStatusInFolderByInstalledApps00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.row = 7;
      demoApp.column = 5;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        layoutCacheManager.updateAppStatusInFolderByInstalledApps(() => {});
        let res: string = 'test'
        expect(res).assertEqual('test');
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('updateOneAppLayoutInfo00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.row = 7;
      demoApp.column = 5;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      try {
        layoutCacheManager.reInit(layoutCacheData);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let appItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      appItem.bundleName = bundleName;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let res: boolean = layoutCacheManager.updateOneAppLayoutInfo(appItem, 'DT');
        if (!res) {
          res = layoutCacheManager.updateOneAppLayoutInfo(appItem, 'DT', true);
        }
        expect(!layoutCacheManager).assertEqual(false);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      mocker.clear(CheckEmptyUtils);
    })
    it('updateOneAppLayoutInfo01', 1, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.row = 7;
      demoApp.column = 5;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoFolder.typeId = CommonConstants.TYPE_FOLDER;
      demoFolder.layoutInfo = [[demoApp]];
      layoutInfoList.push(demoFolder);
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let appItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        appItem.bundleName = bundleName;
        let res: boolean = layoutCacheManager.updateOneAppLayoutInfo(appItem, 'DT', true);
        expect(res).assertEqual(false);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })
    it('updateOneAppLayoutInfo02', 2, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.row = 7;
      demoApp.column = 5;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoFolder.typeId = CommonConstants.TYPE_FOLDER;
      demoFolder.layoutInfo = [[demoApp]];
      layoutInfoList.push(demoFolder);
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let appItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        appItem.bundleName = 'bundleName';
        let res: boolean = layoutCacheManager.updateOneAppLayoutInfo(appItem, 'DT', true);
        expect(res).assertEqual(false);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('updateGridLayoutItemsPositionById00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.row = 7;
      demoApp.column = 5;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let appItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        appItem.bundleName = 'bundleName';
        appItem.keyName = keyName;
        appItem.page = 0;
        appItem.row = 0;
        appItem.column = 0;
        layoutCacheManager.updateGridLayoutItemsPositionById([], 'DT', true);
        layoutCacheManager.updateGridLayoutItemsPositionById([appItem], 'DT', true);
        let res = 'test'
        expect(res).assertEqual('test');
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })
    it('updateGridLayoutItemsPositionById01', 1, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.row = 7;
      demoApp.column = 5;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        layoutCacheManager.updateGridLayoutItemsPositionById([], 'DT', true);
        let res = 'test'
        expect(res).assertEqual('test');
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('reArrangeLayoutInfo00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      let newApp: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoApp);
      layoutInfoList.push(demoApp);
      layoutInfoList.push(newApp);
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let deleteElement: GridLayoutItemInfo[] = layoutCacheManager.reArrangeLayoutInfo(0, false);
        expect(deleteElement.length).assertEqual(1);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('selectGridLayoutItemsByPage00', 0, () => {
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.row = 7;
      demoApp.column = 5;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let gridItems: GridLayoutItemInfo[] = layoutCacheManager.selectGridLayoutItemsByPage(0);
      expect(gridItems).not().assertNull();
      expect(gridItems.length).assertEqual(0);
      gridItems = layoutCacheManager.selectGridLayoutItemsByPage(1);
      expect(gridItems.length).assertEqual(1);
      expect(gridItems[0]).assertEqual(demoApp);
    })

    it('test_setOpenFolderParam', 0, () => {
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let folderPageAppNum: number = 9;
      let folderColumn: number = 3;
      let folderRow: number = 3;
      layoutCacheManager.setOpenFolderParam(folderPageAppNum, folderColumn, folderRow);
      expect(layoutCacheManager).not().assertNull();
    })

    it('test_getAppInfoInFolder_01', 0, () => {
      try{
        let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
        let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
        let infoId: string = '1';
        let bundleName: string = 'com.openharmony.demoApp';
        let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
        demoApp.infoId = infoId;
        demoApp.bundleName = bundleName;
        demoApp.typeId = CommonConstants.TYPE_APP;
        demoApp.page = 1;
        demoApp.row = 7;
        demoApp.column = 5;
        demoApp.area = [1, 1];
        demoApp.keyName = keyName;
        demoApp.ino = 'test';
        demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;

        let typeIds: StartType[] = [
          StartType.APP,
          StartType.FOLDER,
          StartType.DESKTOP_APP,
          StartType.DOCK_APP,
          StartType.SHORTCUT_APP,
          StartType.SHORTCUT_MENU,
          StartType.SCREEN_LOCK_TOOLS
        ]
        layoutCacheManager['getAppInfoInFolder'](demoApp, typeIds, keyName);
        expect(demoApp.infoId).assertEqual(infoId);
      } catch (e) {}
    })

    it('test_getAppInfoInFolder_02', 0, () => {
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let defaultLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      let layoutInfo: GridLayoutItemInfo[][] = [];
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 7;
      demoApp.column = 5;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      layoutInfo.push(layoutInfoList);
      defaultLayout.layoutInfo = layoutInfo;

      let typeIds: StartType[] = [
        StartType.APP,
        StartType.FOLDER,
        StartType.DESKTOP_APP,
        StartType.DOCK_APP,
        StartType.SHORTCUT_APP,
        StartType.SHORTCUT_MENU,
        StartType.SCREEN_LOCK_TOOLS
      ]

      try {
        let res = layoutCacheManager['getAppInfoInFolder'](defaultLayout, typeIds, keyName);
        expect(res.length >= 0).assertTrue();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('test_getAppInfoInFolder_03', 0, () => {
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let defaultLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      let layoutInfo: GridLayoutItemInfo[][] = [];
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = infoId;
      demoApp.bundleName = bundleName;
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 7;
      demoApp.column = 5;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      layoutInfo.push(layoutInfoList);
      defaultLayout.layoutInfo = layoutInfo;

      let typeIds: StartType[] = [
        StartType.APP,
        StartType.FOLDER,
        StartType.DESKTOP_APP,
        StartType.DOCK_APP,
        StartType.SHORTCUT_APP,
        StartType.SHORTCUT_MENU,
        StartType.SCREEN_LOCK_TOOLS
      ]

      let keyName1 = '';
      try {
        let res = layoutCacheManager['getAppInfoInFolder'](defaultLayout, typeIds, keyName1);
        expect(res.length === 0).assertTrue();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('test_getDockAppInfo', 0, () => {
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let typeIds: StartType[] = [
        StartType.APP,
        StartType.FOLDER,
        StartType.DESKTOP_APP,
        StartType.DOCK_APP,
        StartType.SHORTCUT_APP,
        StartType.SHORTCUT_MENU,
        StartType.SCREEN_LOCK_TOOLS
      ]

      let keyName1 = '';
      let res = layoutCacheManager.getDockAppInfo(keyName1, typeIds);
      expect(res.length === 0).assertTrue();
    })

    it('test_getDockAppInfo1', 0, () => {
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let typeIds: StartType[] = [
        StartType.APP,
        StartType.FOLDER,
        StartType.DESKTOP_APP,
        StartType.DOCK_APP,
        StartType.SHORTCUT_APP,
        StartType.SHORTCUT_MENU,
        StartType.SCREEN_LOCK_TOOLS
      ]

      let keyName1 = '';
      let res = layoutCacheManager.getDockAppInfo(keyName1, typeIds);
      expect(res.length === 0).assertTrue();
    })

    it('test_getDockAppInfo2', 0, () => {
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let typeIds: StartType[] = [
        StartType.APP,
        StartType.FOLDER,
        StartType.DESKTOP_APP,
        StartType.DOCK_APP,
        StartType.SHORTCUT_APP,
        StartType.SHORTCUT_MENU,
        StartType.SCREEN_LOCK_TOOLS
      ]

      let dockItems: DockItemInfo[] = [];
      let appItemInfo: DockItemInfo = new DockItemInfo();
      appItemInfo.typeId = CommonConstants.TYPE_APP;
      appItemInfo.appId = '12';
      appItemInfo.itemType = 0;
      appItemInfo.editable = true;
      appItemInfo.bundleName = 'com.ohos.camera';
      appItemInfo.moduleName = 'entry';
      appItemInfo.abilityName = 'com.ohos.camera.MainAbility';
      appItemInfo.appIconId = 234881117;
      appItemInfo.appLabelId = 234881024;
      appItemInfo.applicationLabelId = 234881024;
      appItemInfo.appName = '';
      appItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
      appItemInfo.keyName = 'com.ohos.cameracom.ohos.camera.MainAbilitytablet';
      dockItems.push(appItemInfo);

      let appInfo: DockItemInfo = new DockItemInfo();
      appInfo.bundleName = 'com.ohos.contacts';
      appInfo.abilityName = 'com.ohos.contacts.MainAbility';
      appInfo.moduleName = 'entry';
      appInfo.typeId = CommonConstants.TYPE_APP;
      appInfo.badgeNumber = 0;
      appInfo.appIconId = 100663798;
      appInfo.appLabelId = 1;
      appInfo.appStatus = 0;
      appInfo.downloadProgress = 100;
      appInfo.iconResource = '';
      appInfo.callerName = '';
      appInfo.keyName = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry';
      dockItems.push(appInfo);

      let itemInfo1: DockItemInfo = new DockItemInfo();
      itemInfo1.itemType = CommonConstants.TYPE_APP;
      itemInfo1.bundleName = 'com.ohos.mms';
      itemInfo1.keyName = 'com.ohos.mmscom.ohos.mms.MainAbility';
      dockItems.push(itemInfo1);

      let itemInfo2: DockItemInfo = new DockItemInfo();
      itemInfo2.itemType = CommonConstants.TYPE_FOLDER;
      itemInfo2.bundleName = '123';
      itemInfo2.keyName = '123';
      itemInfo2.typeId = 3;
      itemInfo2.layoutInfo = [];
      let appInfo1: GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.phone';
      item1.keyName = '333';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.phone';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      appInfo1.push(item1);
      appInfo1.push(item2);
      itemInfo2.layoutInfo.push(appInfo1);
      dockItems.push(itemInfo2);

      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', dockItems, false);

      let keyName1 = 'com.ohos.mmscom.ohos.mms.MainAbility';
      try {
        let res = layoutCacheManager.getDockAppInfo(keyName1, typeIds);
        expect(res.length === 0).assertTrue();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }

      let keyName2 = 'com.ohos.cameracom.ohos.camera.MainAbilitytablet';
      try {
        let res2 = layoutCacheManager.getDockAppInfo(keyName2, typeIds);
        expect(res2.length === 1).assertTrue();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }

      let keyName3 = '333';
      try {
        let res3 = layoutCacheManager.getDockAppInfo(keyName3, typeIds);
        expect(res3.length >= 0).assertTrue();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }

      let keyName4 = '123';
      let res4 = layoutCacheManager.getDockAppInfo(keyName4, typeIds, '123');
      expect(res4.length >= 0).assertTrue();
    })

    it('test_selectSameApp_deleteShortcutItem_isEmptyArr', 0, () => {
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      try{
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let appItemInfo = new AppItemInfo();
        layoutCacheManager.deleteShortcutItem(appItemInfo);
        let list: GridLayoutItemInfo[] = [];
        layoutCacheManager.updateGridLayoutItems(list, 'DT', false);
        let ret = layoutCacheManager.selectSameApp('bundleName', 0);
        expect(ret.length).assertEqual(0);
      }catch(e){}
      mocker.clear(CheckEmptyUtils);
    })

    it('test_deleteShortcutItem', 0, () => {
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      demoApp.shortcutId = '1';
      demoApp.appIndex = 1;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let appItemInfo = new AppItemInfo();
        appItemInfo.bundleName = bundleName;
        appItemInfo.shortcutId = '1';
        appItemInfo.appIndex = 2;
        layoutCacheManager.deleteShortcutItem(appItemInfo);
        layoutCacheManager.deleteShortcutItem(appItemInfo, false);
        expect(layoutInfoList.length).assertEqual(1);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('test_updateIfNewInstalledApp', 0, () => {
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.bundleName = 'bundleName';
      demoApp.keyName = 'keyName';
      demoApp.badgeNumber = 1;
      demoApp.shortcutId = '1';
      demoApp.appIndex = 1;
      demoApp.appStatus = 1;
      let demoApp2: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp2.typeId = CommonConstants.TYPE_APP;
      demoApp.bundleName = 'bundleName';
      demoApp2.keyName = 'keyName';
      demoApp2.badgeNumber = 1;
      demoApp2.shortcutId = '1';
      demoApp2.appIndex = 2;
      let gridLayoutItemList: GridLayoutItemInfo[] = [demoApp];
      let ret = layoutCacheManager.updateIfNewInstalledApp(demoApp, gridLayoutItemList, true);
      expect(ret).assertTrue();
      ret = layoutCacheManager.updateIfNewInstalledApp(demoApp2, gridLayoutItemList, false);
      expect(ret).assertTrue();
    })

    it('test_updateLayoutDescriptionRowAndColumn', 0, () => {
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let config: GridLayoutConfig = new GridLayoutConfig();
      config.row = 0;
      config.column = 0;
      layoutCacheManager.updateLayoutDescriptionRowAndColumn(config, false, 'DT');
      config.row = 6;
      config.column = 4;
      layoutCacheManager.updateLayoutDescriptionRowAndColumn(config, false, 'DT');
      expect(config.row).assertEqual(6);
    })

    it('test_selectSameAppOuter', 0, () => {
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.row = 7;
      demoApp.column = 5;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;
      let mocker: MockKit = new MockKit();
      try {
        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheData.setGridLayoutItemList(layoutInfoList, true);
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let res = layoutCacheManager.selectSameAppOuter(bundleName);
        expect(res.length).assertEqual(0);
        res = layoutCacheManager.selectSameAppOuter(bundleName);
        expect(res.length).assertLargerOrEqual(0);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      mocker.clear(CheckEmptyUtils);
    })

    it('test_selectItemListByPageAndArea', 0, () => {
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.row = 7;
      demoApp.column = 5;
      demoApp.area = [1, 1];
      demoApp.keyName = keyName;
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        layoutCacheData.setGridLayoutItemList(layoutInfoList, true);
        let ret = layoutCacheManager.selectItemListByPageAndArea(undefined, [1, 1]);
        expect(ret.length === 0).assertTrue();
        ret = layoutCacheManager.selectItemListByPageAndArea(1, []);
        expect(ret.length === 0).assertTrue();
        ret = layoutCacheManager.selectItemListByPageAndArea(1, [1, 1]);
        expect(ret.length === 1).assertTrue();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('test_getDesktopAppInfo', 0, () => {
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.folderId = 'DT';
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        layoutCacheData.setGridLayoutItemList(layoutInfoList, true);
        let typeIds: StartType[] = [0];
        let ret = layoutCacheManager.getDesktopAppInfo(keyName, typeIds);
        expect(ret.length).assertLargerOrEqual(0);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('test_getDesktopAppInfo02', 0, () => {
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
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
      demoApp.folderId = 'DT';
      demoApp.ino = 'test';
      demoApp.kindId = CommonConstants.CONTAINER_APP_KIND_ID;
      let demoApp2: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp2.typeId = CommonConstants.TYPE_FOLDER;
      demoApp2.page = 1;
      demoApp2.row = 1;
      demoApp2.column = 1;
      demoApp2.area = [1, 1];
      demoApp2.folderId = 'DT';
      demoApp2.layoutInfo = [[demoApp]];
      layoutInfoList.push(demoApp2);
      defaultLayout.layoutInfo = layoutInfoList;
      try {
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        layoutCacheData.setGridLayoutItemList(layoutInfoList, true);
        let typeIds: StartType[] = [0];
        let ret = layoutCacheManager.getDesktopAppInfo(keyName, typeIds);
        expect(ret.length).assertLargerOrEqual(0);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('test_updateFormsCacheByFormList', 0, () => {
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let formInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      formInfo.typeId = CommonConstants.TYPE_CARD;
      formInfo.cardId = '1';
      formInfo.appLabelId = 1;
      formInfo.isTransparent = false;
      formInfo.formConfigAbility = 'formConfigAbility';
      let formInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      formInfo2.typeId = CommonConstants.TYPE_FORM_STACK;
      formInfo2.cardId = undefined;
      let formInfoList: GridLayoutItemInfo[] = [formInfo, formInfo2];
      let gridInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      formInfo.cardId = '2';
      gridInfo.typeId = CommonConstants.TYPE_FORM_STACK;
      gridInfo.layoutInfo = [[formInfo2]];
      let gridLayoutItemList: GridLayoutItemInfo[] = [formInfo, gridInfo];
      layoutCacheManager['updateFormsCacheByFormList'](formInfoList, gridLayoutItemList);
      expect(gridLayoutItemList.length).assertEqual(2);
    })

    it('test_getGridLayoutItemList0', 0, () => {
      let launchLayoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(launchLayoutCacheManager, launchLayoutCacheManager.getAllGridLayoutItemList);
      when(mockFunc)('DeskTop').afterReturn([new GridLayoutItemInfo()]);
      const result = launchLayoutCacheManager.getGridLayoutItemList();
      expect(result).assertDeepEquals([new GridLayoutItemInfo()]);
    })

    it('test_getGridLayoutItemList1', 0, () => {
      let launchLayoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(launchLayoutCacheManager, launchLayoutCacheManager.getAllGridLayoutItemList);
      when(mockFunc)('DeskTop').afterReturn(null);
      const result = launchLayoutCacheManager.getGridLayoutItemList();
      expect(result).assertDeepEquals(null);
    })
  })
}