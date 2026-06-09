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
import { CheckEmptyUtils, CommonUtils } from '@ohos/basicutils'
import { ObjectCopyUtil } from '@ohos/componenthelper'
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers } from '@ohos/hypium'
import { DesktopLayoutCacheData } from '../../../../../../../main/ets/cache/layout/DesktopLayoutCacheData'
import {
  AppItemInfo,
  AppStatus,
  BadgeItemInfo,
  CommonConstants,
  DefaultDesktopLayoutInfo,
  FolderData,
  FolderLayoutCacheManager,
  FolderLayoutStruct,
  FolderModel,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LauncherLayoutCacheUtil,
  NotHarmonyUtil,
  PageDesktopModel} from '../../../../../../../main/ets/TsIndex'

export default function FolderLayoutCacheManagerTest() {
  describe('FolderLayoutCacheManagerTest', () => {
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
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      // 条件1
      let layoutCacheManager1: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(layoutCacheManager).assertEqual(layoutCacheManager1);
    })

    it('Folder_setListener_not_mode', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let func: Function = () => {
      };
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].setListener);
      layoutCacheManager.setListener(func);
      mocker.verify('setListener', [func]).once();
      mocker.clear(layoutCacheManager['layoutCacheData']);
    })

    it('Folder_judgeSamePageItem_yes_bool01', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let current: GridLayoutItemInfo = new GridLayoutItemInfo();
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      current.typeId = CommonConstants.TYPE_APP;
      current.page = 0;
      current.keyName = keyName;
      current.cardId = '2'
      current.formStackId = '2'
      current.folderId = '2'
      current.shortcutId = '2'
      current.area = [1, 2]
      current.infoId = infoId;
      current.bundleName = bundleName;
      current.row = 0;
      current.column = 0;
      let target: GridLayoutItemInfo = new GridLayoutItemInfo();
      target.typeId = CommonConstants.TYPE_APP;
      target.page = 1;
      let bool: boolean = layoutCacheManager['judgeSamePageItem'](current, target);
      expect(bool).assertFalse();
    })

    it('Folder_judgeSamePageItem_yes_bool02', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let current: GridLayoutItemInfo = new GridLayoutItemInfo();
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      current.typeId = CommonConstants.TYPE_APP;
      current.page = 0;
      current.keyName = keyName;
      let target: GridLayoutItemInfo = new GridLayoutItemInfo();
      target.page = 0;
      target.keyName = keyName;
      current.typeId = CommonConstants.TYPE_APP;
      target.typeId = CommonConstants.TYPE_APP;
      let bool: boolean = layoutCacheManager['judgeSamePageItem'](current, target);
      expect(bool).assertTrue();
    })

    it('Folder_judgeSamePageItem_yes_bool03', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let current: GridLayoutItemInfo = new GridLayoutItemInfo();
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      current.typeId = CommonConstants.TYPE_APP;
      current.page = 0;
      current.keyName = keyName;
      current.cardId = '2'
      let target: GridLayoutItemInfo = new GridLayoutItemInfo();
      target.page = 0;
      target.keyName = keyName;
      target.cardId = '2';
      current.typeId = CommonConstants.TYPE_CARD;
      target.typeId = CommonConstants.TYPE_CARD;
      let bool: boolean = layoutCacheManager['judgeSamePageItem'](current, target);
      expect(bool).assertTrue();
    })

    it('Folder_judgeSamePageItem_yes_bool04', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let current: GridLayoutItemInfo = new GridLayoutItemInfo();
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      current.typeId = CommonConstants.TYPE_APP;
      current.page = 0;
      current.keyName = keyName;
      current.cardId = '2'
      current.formStackId = '2'
      current.folderId = '2'
      current.shortcutId = '2'
      current.area = [1, 2]
      current.infoId = infoId;
      current.bundleName = bundleName;
      current.row = 0;
      current.column = 0;
      let target: GridLayoutItemInfo = new GridLayoutItemInfo();
      target.page = 0;
      target.keyName = keyName;
      target.cardId = '2';
      target.formStackId = '2';
      current.typeId = CommonConstants.TYPE_FORM_STACK;
      target.typeId = CommonConstants.TYPE_FORM_STACK;
      let bool: boolean = layoutCacheManager['judgeSamePageItem'](current, target);
      expect(bool).assertTrue();
    })

    it('Folder_judgeSamePageItem_yes_bool05', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let current: GridLayoutItemInfo = new GridLayoutItemInfo();
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      current.typeId = CommonConstants.TYPE_APP;
      current.page = 0;
      current.keyName = keyName;
      current.cardId = '2'
      current.formStackId = '2'
      current.folderId = '2'
      current.shortcutId = '2'
      current.area = [1, 2]
      current.infoId = infoId;
      current.bundleName = bundleName;
      current.row = 0;
      current.column = 0;
      let target: GridLayoutItemInfo = new GridLayoutItemInfo();
      target.page = 0;
      target.keyName = keyName;
      target.cardId = '2';
      target.formStackId = '2';
      target.folderId = '2';
      target.area = [1, 2];
      current.typeId = CommonConstants.TYPE_FOLDER;
      target.typeId = CommonConstants.TYPE_FOLDER;
      let bool: boolean = layoutCacheManager['judgeSamePageItem'](current, target);
      expect(bool).assertTrue();
    })

    it('Folder_judgeSamePageItem_yes_bool06', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let current: GridLayoutItemInfo = new GridLayoutItemInfo();
      let infoId: string = '1';
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      current.typeId = CommonConstants.TYPE_APP;
      current.page = 0;
      current.keyName = keyName;
      current.cardId = '2'
      current.formStackId = '2'
      current.folderId = '2'
      current.shortcutId = '2'
      current.area = [1, 2]
      current.infoId = infoId;
      current.bundleName = bundleName;
      current.row = 0;
      current.column = 0;
      let target: GridLayoutItemInfo = new GridLayoutItemInfo();
      target.page = 0;
      target.keyName = keyName;
      target.cardId = '2';
      target.formStackId = '2';
      target.folderId = '2';
      target.area = [1, 2];
      target.shortcutId = '2';
      current.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      target.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      layoutCacheManager['judgeSamePageItem'](current, target);

      current.typeId = CommonConstants.TYPE_AREA_DESKTOP;
      target.typeId = CommonConstants.TYPE_AREA_DESKTOP;
      let bool: boolean = layoutCacheManager['judgeSamePageItem'](current, target);
      expect(bool).assertTrue();
    })

    it('Folder_judgeSamePageItem_yes_bool07', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let current: GridLayoutItemInfo = new GridLayoutItemInfo();
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      current.typeId = CommonConstants.TYPE_APP;
      current.page = 0;
      current.keyName = keyName;
      current.cardId = '2'
      let target: GridLayoutItemInfo = new GridLayoutItemInfo();
      target.page = 0;
      target.keyName = keyName;
      target.cardId = '3';
      current.typeId = CommonConstants.TYPE_CARD;
      target.typeId = CommonConstants.TYPE_CARD;
      let bool: boolean = layoutCacheManager['judgeSamePageItem'](current, target);
      expect(bool).assertFalse();
    })

    it('Folder_selectAllFoldersWithAppCheck', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        let gird: number = layoutCacheManager.selectAllFoldersWithAppCheck([]).length;
        expect(gird).assertEqual(0);
      }catch{};
    })

    it('Folder_deleteGridLayoutItemByItemId', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.deleteGridLayoutItemByItemId('1', '2');
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_deleteGridLayoutItemByFolderIdList', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.deleteGridLayoutItemByFolderIdList([1], '张三');
        layoutCacheManager.deleteGridLayoutItemByFolderIdList([1], '张三', true);
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_deleteGridLayoutItemByIndex', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.deleteGridLayoutItemByIndex(1, '张三');
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_deleteGridLayoutItemByItemList', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.deleteGridLayoutItemByItemList(1, '张三');
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_deleteAndReplaceItem', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.deleteAndReplaceItem(1, 1, new GridLayoutItemInfo(), '张三');
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_deleteFolderAndUpdateAppItemToDesktop', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.deleteFolderAndUpdateAppItemToDesktop(1, new GridLayoutItemInfo(), '张三');
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_updateFolderItemLayoutInfoByFolderId', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.updateFolderItemLayoutInfoByFolderId('张三', [], [], '1');
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_updateFolderItemLayoutInfoByFolderIdList', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.updateFolderItemLayoutInfoByFolderIdList(new Map(), '1');
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_updateBadgeNumberInFolder', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.updateBadgeNumberInFolder(new BadgeItemInfo(), '1');
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_updateFolderSizeByFolderItem', 0, () => {
      try {
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.updateFolderSizeByFolderItem(new GridLayoutItemInfo(), '1');
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_updateFolderName', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.updateFolderName('1', '2', true, '4');
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_convertFolderSize', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.convertFolderSize(new GridLayoutItemInfo(), true, '4');
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_insertAppItemToFolderLastItemByFolderId', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.insertAppItemToFolderLastItemByFolderId('李四', new GridLayoutItemInfo(), 'true');
        expect(layoutCacheManager).not().assertNull();
      }catch{}
    })

    it('Folder_updateLastFolderItemToDesktop', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.updateLastFolderItemToDesktop(new GridLayoutItemInfo(), '张三');
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_insertGridLayoutItemListFromFolder', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.insertGridLayoutItemListFromFolder([], '张三');
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_insertAppListToFolderByFolderId', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.insertAppListToFolderByFolderId('张三', []);
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_deleteGridLayoutItemByBundleNameAndType', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.deleteGridLayoutItemByBundleNameAndType('张三', 9, '测试');
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_deleteGridLayoutItemById', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.deleteGridLayoutItemById(new GridLayoutItemInfo(), '测试');
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_deleteGridLayoutItemByPosition', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.deleteGridLayoutItemByPosition(9, 9, 9, '测试');
        expect(layoutCacheManager).not().assertNull();
      }catch{}
    })

    it('Folder_deleteAppItemByKeyName', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.deleteAppItemByKeyName('张三', '测试');
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_updateGridLayoutItemPositionById', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.updateGridLayoutItemPositionById(new GridLayoutItemInfo(), '测试');
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_insertGridLayoutItemInfo', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.insertGridLayoutItemInfo(new GridLayoutItemInfo(), '测试');
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_insertGridLayoutItemInfoAsync', 0, async (done: Function) => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        await layoutCacheManager.insertGridLayoutItemInfoAsync(new GridLayoutItemInfo(), '测试');
        expect(layoutCacheManager).not().assertNull();
        done();
      }catch{};
    })

    it('Folder_insertGridLayoutItemAndUpdatePosition', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.insertGridLayoutItemAndUpdatePosition(new GridLayoutItemInfo(), '测试');
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_updateLayoutAfterDeletePages', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.updateLayoutAfterDeletePages([1], '测试');
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('Folder_updateLayoutAfterAddPage', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        let len: number = layoutCacheManager.updateLayoutAfterAddPage(1, 1, '测试').length;
        expect(len).assertEqual(0);
      }catch{};
    })

    it('Folder_updateLayoutAfterDeletePage', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        layoutCacheManager.updateLayoutAfterDeletePage(1, 1, '测试');
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('selectSameAppAndFolder00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp]];
        demoFolder.folderId = '1';
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let res: GridLayoutItemInfo = layoutCacheManager.selectGridLayoutItemByFolderId('1');
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(demoApp.infoId).assertEqual(infoId);
      }catch{};
    })

    it('selectGridLayoutItemByPosition00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let res: GridLayoutItemInfo = layoutCacheManager.selectGridLayoutItemByPosition(0, 0, 1);
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res).assertEqual(demoFolder);
      }catch{};
    })

    it('selectGridLayoutItemByIndex00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let res: GridLayoutItemInfo = layoutCacheManager.selectGridLayoutItemByIndex(0);
        let res1: GridLayoutItemInfo = layoutCacheManager.selectGridLayoutItemByIndex(-1);
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res).assertEqual(demoFolder);
      }catch{};
    })

    it('selectGridLayoutItemByIndex01', 1, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        layoutInfoList.push(demoApp);
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let res: GridLayoutItemInfo = layoutCacheManager.selectGridLayoutItemByIndex(0);
        let res1: GridLayoutItemInfo = layoutCacheManager.selectGridLayoutItemByIndex(-1);
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res).assertEqual(undefined);
      }catch{};
    })

    it('selectAllFoldersWithAppCheck00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        demoApp.appStatus = AppStatus.INSTALLED
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp, demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let installApp: AppItemInfo = new AppItemInfo();
        installApp.keyName = keyName;
        let res: GridLayoutItemInfo[] = layoutCacheManager.selectAllFoldersWithAppCheck([installApp]);
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res.length).assertEqual(1);
      }catch{};
    })

    it('selectGridLayoutItemsByAppList00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        demoApp.appStatus = AppStatus.INSTALLED
        layoutInfoList.push(demoApp);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);

        let res: GridLayoutItemInfo[] = layoutCacheManager.selectGridLayoutItemsByAppList([demoApp]);
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res.length).assertEqual(1);
      }catch{};
    })

    it('selectFolderByContainApp00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        demoApp.appStatus = AppStatus.INSTALLED
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let res: GridLayoutItemInfo[] = layoutCacheManager.selectFolderByContainApp(bundleName);
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res.length).assertLargerOrEqual(0);
      }catch{};
    })

    it('deleteGridLayoutItemByItemId00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        demoApp.appStatus = AppStatus.INSTALLED
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        demoFolder.container = -100;
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        layoutCacheManager.deleteGridLayoutItemByItemId('1', 'DT', true);
        let res: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res.length).assertEqual(0);
      }catch{}
    })
    it('deleteGridLayoutItemByItemId01', 1, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        demoApp.appStatus = AppStatus.INSTALLED
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        demoFolder.container = -100;
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        layoutCacheManager.deleteGridLayoutItemByItemId('2', 'DT', true);
        let res: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res.length).assertEqual(1);
      }catch{}
    })

    it('deleteGridLayoutItemByIndex00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        demoApp.appStatus = AppStatus.INSTALLED
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        demoFolder.container = -100;
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        layoutCacheManager.deleteGridLayoutItemByIndex(0, 'DT', true);
        layoutCacheManager.deleteGridLayoutItemByItemId(-1, 'DT', true);
        let res: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res.length).assertEqual(0);
      }catch{}
    })

    it('deleteGridLayoutItemByItemList00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        demoApp.appStatus = AppStatus.INSTALLED
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        demoFolder.container = -100;
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        layoutCacheManager.deleteGridLayoutItemByItemList([demoFolder], 'DT', true);
        layoutCacheManager.deleteGridLayoutItemByItemList([], 'DT', true);
        let res: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res.length).assertEqual(0);
      }catch{}
    })

    it('deleteAndReplaceItem00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        demoApp.appStatus = AppStatus.INSTALLED
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        demoFolder.container = -100;
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        layoutCacheManager.deleteAndReplaceItem(-1, 1, demoApp, 'DT', true);
        layoutCacheManager.deleteAndReplaceItem(0, 1, demoApp, 'DT', true);
        let res: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
        let item: GridLayoutItemInfo | undefined = undefined;
        if (res.length >= 1) {
          item = res[0];
        }
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(item).assertEqual(demoApp);
      }catch{};
    })

    it('deleteFolderAndUpdateAppItemToDesktop00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        demoApp.appStatus = AppStatus.INSTALLED
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        demoFolder.container = -100;
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        layoutCacheManager.deleteFolderAndUpdateAppItemToDesktop(0, demoApp, 'DT', true);
        layoutCacheManager.deleteFolderAndUpdateAppItemToDesktop(0, null, 'DT', true);
        layoutCacheManager.deleteFolderAndUpdateAppItemToDesktop(-1, demoApp, 'DT', true);
        let res: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
        let item: GridLayoutItemInfo | undefined = undefined;
        if (res.length >= 1) {
          item = res[0];
        }
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(item).assertUndefined();
      }catch{}
    })

    it('updateFolderItemLayoutInfoByFolderId00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        demoApp.appStatus = AppStatus.INSTALLED
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        demoFolder.container = -100;
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        layoutCacheManager.updateFolderItemLayoutInfoByFolderId('1', [[demoApp]], [demoApp], 'DT', true);
        layoutCacheManager.updateFolderItemLayoutInfoByFolderId('0', [[demoApp]], [demoApp], 'DT', true);
        layoutCacheManager.updateFolderItemLayoutInfoByFolderId('1', [[demoApp]], [], 'DT', true);
        let res: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
        let item: GridLayoutItemInfo | undefined = undefined;
        if (res.length >= 1) {
          item = res[0];
        }
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(item).assertEqual(demoFolder);
      }catch{};
    })

    it('updateBadgeNumberInFolder00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        demoApp.badgeNumber = 5;
        demoApp.appStatus = AppStatus.INSTALLED
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp, demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        demoFolder.container = -100;
        demoFolder.badgeNumber = 10;
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let badgeInfo: BadgeItemInfo = new BadgeItemInfo();
        badgeInfo.bundleName = bundleName;
        badgeInfo.badgeNumber = 3;
        layoutCacheManager.updateBadgeNumberInFolder(null, 'DT', true);
        layoutCacheManager.updateBadgeNumberInFolder(badgeInfo, 'DT', true);
        let res: string = 'test';
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res).assertEqual('test');
      }catch{};
    })

    it('updateBadgeNumberByFolderId00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        demoApp.appStatus = AppStatus.INSTALLED
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp, demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        demoFolder.container = -100;
        demoFolder.badgeNumber = 10;
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        layoutCacheManager.updateBadgeNumberByFolderId(-1, '1', 'DT');
        layoutCacheManager.updateBadgeNumberByFolderId(5, '1', 'DT');
        let res: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
        let item: GridLayoutItemInfo | undefined = undefined;
        if (res.length >= 1) {
          item = res[0];
        }
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(item?.badgeNumber).assertEqual(5);
      }catch{};
    })

    it('updateFolderSizeByFolderItem00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        demoApp.appStatus = AppStatus.INSTALLED
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp, demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        demoFolder.container = -100;
        demoFolder.badgeNumber = 10;
        demoFolder.area = [1, 1]
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let folderApp: GridLayoutItemInfo = new GridLayoutItemInfo();
        folderApp.area = [1, 1]
        folderApp.folderId = '1';
        layoutCacheManager.updateFolderSizeByFolderItem(null, 'DT', true);
        layoutCacheManager.updateFolderSizeByFolderItem(folderApp, 'DT', true);
        let res: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
        let item: GridLayoutItemInfo | undefined = undefined;
        if (res.length >= 1) {
          item = res[0];
        }
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(item?.area?.length).assertEqual(2);
      }catch{};
    })

    it('updateFolderName00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        demoApp.appStatus = AppStatus.INSTALLED
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp, demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        demoFolder.container = -100;
        demoFolder.badgeNumber = 10;
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        layoutCacheManager.updateFolderName('test', '1', true, 'DT', true);
        layoutCacheManager.updateFolderName('test01', '2', true, 'DT', true);
        let res: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
        let item: GridLayoutItemInfo | undefined = undefined;
        if (res.length >= 1) {
          item = res[0];
        }
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(item?.folderName).assertEqual('test');
      }catch{};
    })

    it('updateFolderLayoutInfoByFolderId00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        demoApp.appStatus = AppStatus.INSTALLED
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp, demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        demoFolder.container = -100;
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        layoutCacheManager.updateFolderLayoutInfoByFolderId('1', [], 'DT', true);
        layoutCacheManager.updateFolderLayoutInfoByFolderId('1', [], 'DT');
        let res: string = 'test'

        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res).assertEqual('test');
      }catch{};
    })

    it('convertFolderSize00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        demoApp.appStatus = AppStatus.INSTALLED
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp, demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        demoFolder.container = -100;
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let newFolder: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoFolder);
        layoutCacheManager.convertFolderSize(null, true, 'DT', true);
        layoutCacheManager.convertFolderSize(newFolder, false, 'DT', true);
        let resList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');

        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(resList.length).assertEqual(2);
      }catch{}
    })

    it('updateLastFolderItemToDesktop00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        demoApp.appStatus = AppStatus.INSTALLED
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp, demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        demoFolder.container = -100;
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let newFolder: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoFolder);
        layoutCacheManager.updateLastFolderItemToDesktop(null, 'DT', true);
        layoutCacheManager.updateLastFolderItemToDesktop(newFolder, 'DT', true);
        let resList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');

        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(resList.length).assertEqual(2);
      }catch{};
    })

    it('insertGridLayoutItemListFromFolder00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        demoApp.appStatus = AppStatus.INSTALLED
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp, demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        demoFolder.container = -100;
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        let addList: GridLayoutItemInfo[] = [demoApp, demoFolder];
        layoutCacheManager.insertGridLayoutItemListFromFolder([], 'DT', true);
        layoutCacheManager.insertGridLayoutItemListFromFolder(addList, 'DT', true);
        let resList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');

        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(resList.length).assertEqual(3);
      }catch{};
    })

    it('insertAppItemToFolder00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        demoApp.appStatus = AppStatus.INSTALLED
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp, demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        demoFolder.container = -100;
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        layoutCacheManager.insertAppItemToFolder('1', null, 'DT');
        layoutCacheManager.insertAppItemToFolder('2', null, 'DT');
        layoutCacheManager.insertAppItemToFolder('1', demoApp, 'DT');
        let newApp: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoApp);
        newApp.page = 1;
        layoutCacheManager.insertAppItemToFolder('1', newApp, 'DT');
        let resList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(resList.length).assertEqual(1);
      }catch{};
    })

    it('insertAppItemToFolderLastItemByFolderId00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
        demoApp.appStatus = AppStatus.INSTALLED
        let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
        demoFolder.typeId = CommonConstants.TYPE_FOLDER;
        demoFolder.layoutInfo = [[demoApp, demoApp]];
        demoFolder.folderId = '1';
        demoFolder.page = 0;
        demoFolder.column = 1;
        demoFolder.row = 0;
        demoFolder.container = -100;
        layoutInfoList.push(demoFolder);
        defaultLayout.layoutInfo = layoutInfoList;

        // 条件1
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
        layoutCacheManager.reInit(layoutCacheData);
        layoutCacheManager.insertAppItemToFolderLastItemByFolderId('1', null, 'DT', true);
        layoutCacheManager.insertAppItemToFolderLastItemByFolderId('2', null, 'DT', true);
        layoutCacheManager.insertAppItemToFolderLastItemByFolderId('1', demoApp, 'DT', true);
        let resList: GridLayoutItemInfo[] = layoutCacheManager.getAllGridLayoutItemList('DT');
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(resList.length).assertEqual(1);
      }catch{};
    })

    it('isAppExistNotDragOutFolder00', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
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
      let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoFolder.typeId = CommonConstants.TYPE_FOLDER;
      demoFolder.layoutInfo = [[demoApp]];
      demoFolder.folderId = '1';
      layoutInfoList.push(demoFolder);
      defaultLayout.layoutInfo = layoutInfoList;
      let mocker: MockKit = new MockKit();
      try{
        let result = layoutCacheManager.isAppExistNotDragOutFolder(bundleName);
        expect(result).assertTrue();
      } catch (e) {
      }
    })

    it('test_FolderLayoutCacheManager_updateFolderAppLocation', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        itemInfo.bundleName = 'com';
        itemInfo.abilityName = 'openharmony';
        itemInfo.row = 1;
        itemInfo.column = 1;
        itemInfo.page = 1;
        itemInfo.area = [2, 1];
        layoutCacheManager['updateFolderAppLocation']([itemInfo]);
        expect(itemInfo.bundleName).assertEqual('com');
      }catch{};
    })

    it('test_FolderLayoutCacheManager_updateFolderAppLocation', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_ADD;
      info.area = [2, 1];
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com';
      itemInfo.abilityName = 'openharmony';
      itemInfo.row = 1;
      itemInfo.column = 1;
      itemInfo.folderId = '996';
      itemInfo.typeId = CommonConstants.TYPE_FOLDER;
      itemInfo.area = [2, 1];
      itemInfo.layoutInfo = [[info]];
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList)
        when(mockFunc)().afterReturn([]);
        layoutCacheManager['insertAppListToFolderByFolderId']('996', [itemInfo], true, true);
        expect(itemInfo.typeId).assertEqual(CommonConstants.TYPE_FOLDER);
        when(mockFunc)().afterReturn([itemInfo]);
        layoutCacheManager['insertAppListToFolderByFolderId']('996', [itemInfo], true, true);
        expect(itemInfo.typeId).assertEqual(CommonConstants.TYPE_FOLDER);
        info.typeId = CommonConstants.TYPE_FOLDER;
        itemInfo.layoutInfo = [[info]];
        layoutCacheManager['insertAppListToFolderByFolderId']('996', [itemInfo], true, true);
        expect(itemInfo.typeId).assertEqual(CommonConstants.TYPE_FOLDER);
      } catch (e){};
      mocker.clear(layoutCacheManager['layoutCacheData']);
    })

    it('test_FolderLayoutCacheManager_insertAppItemToFolderLastItemByFolderId', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      let mocker: MockKit = new MockKit();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com';
      itemInfo.abilityName = 'openharmony';
      itemInfo.row = 1;
      itemInfo.column = 1;
      itemInfo.folderId = '996';
      itemInfo.typeId = CommonConstants.TYPE_FOLDER;
      itemInfo.area = [2, 1];
      itemInfo.layoutInfo = [[info]];
      let layout: FolderLayoutStruct = {
        id: 1,
        layout: '996',
        name: '996',
        row: 1,
        column: 1,
        checked: true,
      };
      try {
        layoutCacheManager['insertAppItemToFolderLastItemByFolderId']('996', null, '007', true);
        expect(itemInfo.typeId).assertEqual(CommonConstants.TYPE_FOLDER);
        layoutCacheManager['insertAppItemToFolderLastItemByFolderId']('996', itemInfo, '007', true);
        expect(itemInfo.typeId).assertEqual(CommonConstants.TYPE_FOLDER);
        let mockFunc: Function = mocker.mockFunc(FolderModel.getInstance(), FolderModel.getInstance().getFolderOpenLayout)
        when(mockFunc)().afterReturn(layout);
        layoutCacheManager['insertAppItemToFolderLastItemByFolderId']('996', itemInfo, '007', true);
        expect(itemInfo.typeId).assertEqual(CommonConstants.TYPE_FOLDER);
        info.typeId = CommonConstants.TYPE_ADD;
        itemInfo.layoutInfo = [[info]];
        layoutCacheManager['insertAppItemToFolderLastItemByFolderId']('996', itemInfo, '007', true);
        expect(itemInfo.typeId).assertEqual(CommonConstants.TYPE_FOLDER);
      } catch (e) {}
      mocker.clear(FolderModel.getInstance());
    })

    it('test_FolderLayoutCacheManager_insertAppToFolderWithoutContainer', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com';
      itemInfo.abilityName = 'openharmony';
      itemInfo.row = 1;
      itemInfo.column = 1;
      itemInfo.folderId = '996';
      itemInfo.typeId = CommonConstants.TYPE_FOLDER;
      itemInfo.area = [2, 1];
      itemInfo.layoutInfo = [[info]];
      itemInfo.intent = 'installsource';
      itemInfo.container = -100;
      layoutCacheManager['insertAppToFolderWithoutContainer'](itemInfo.intent, itemInfo.container);
      expect(itemInfo.typeId).assertEqual(CommonConstants.TYPE_FOLDER);
    })

    it('test_FolderLayoutCacheManager_insertAppItemToFolder', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.page = 1;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com';
      itemInfo.abilityName = 'openharmony';
      itemInfo.row = 1;
      itemInfo.column = 1;
      itemInfo.page = 1;
      itemInfo.folderId = '996';
      itemInfo.typeId = CommonConstants.TYPE_FOLDER;
      itemInfo.area = [2, 1];
      itemInfo.layoutInfo = [[info]];
      layoutCacheManager.insertAppItemToFolder('996', itemInfo, '007');
      expect(itemInfo.bundleName).assertEqual('com');
    })

    it('test_FolderLayoutCacheManager_insertAppItemToFolderCache', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.bundleName = 'com';
        info.abilityName = 'openharmony';
        info.row = 1;
        info.column = 1;
        info.page = 0;
        info.folderId = '996';
        info.typeId = CommonConstants.TYPE_FOLDER;
        info.area = [2, 1];
        let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        itemInfo.bundleName = 'com';
        itemInfo.abilityName = 'openharmony';
        itemInfo.row = 1;
        itemInfo.column = 1;
        itemInfo.page = 0;
        itemInfo.folderId = '996';
        itemInfo.typeId = CommonConstants.TYPE_FOLDER;
        itemInfo.area = [2, 1];
        itemInfo.layoutInfo = [[info]];
        layoutCacheManager['insertAppItemToFolderCache'](null, info);
        expect(itemInfo.column).assertEqual(1);
        layoutCacheManager['insertAppItemToFolderCache'](itemInfo, info);
        expect(itemInfo.column).assertEqual(1);
      }catch{};
    })

    it('test_FolderLayoutCacheManager_insertGridLayoutItemListFromFolder', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.bundleName = 'com';
        info.abilityName = 'openharmony';
        info.row = 1;
        info.column = 1;
        info.page = 0;
        info.folderId = '996';
        info.typeId = CommonConstants.TYPE_FOLDER;
        info.area = [2, 1];
        layoutCacheManager['insertGridLayoutItemListFromFolder'](null, '', false);
        expect(layoutCacheManager).not().assertNull();
        layoutCacheManager['insertGridLayoutItemListFromFolder']([info], '996', false);
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('test_FolderLayoutCacheManager_updateLastFolderItemToDesktop', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.bundleName = 'com';
        info.abilityName = 'openharmony';
        info.row = 1;
        info.column = 1;
        info.page = 0;
        info.folderId = '996';
        info.typeId = CommonConstants.TYPE_FOLDER;
        info.area = [2, 1];
        layoutCacheManager['updateLastFolderItemToDesktop'](null, '', false);
        expect(layoutCacheManager).not().assertNull();
        layoutCacheManager['updateLastFolderItemToDesktop'](info, '996', false);
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('test_FolderLayoutCacheManager_convertFolderSize', 0, () => {
      try{
        let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.bundleName = 'com';
        info.abilityName = 'openharmony';
        info.row = 1;
        info.column = 1;
        info.page = 0;
        info.folderId = '996';
        info.typeId = CommonConstants.TYPE_FOLDER;
        info.area = [2, 1];
        layoutCacheManager['convertFolderSize'](null, true, '', false);
        expect(layoutCacheManager).not().assertNull();
        layoutCacheManager['convertFolderSize'](info, true, '996', false);
        expect(layoutCacheManager).not().assertNull();
      }catch{};
    })

    it('test_FolderLayoutCacheManager_updateFolderSizeByFolderItem', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.page = 0;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList)
        when(mockFunc)(ArgumentMatchers.any).afterReturn([info]);
        layoutCacheManager.updateFolderSizeByFolderItem(null, '996', false);
        expect(info.typeId).assertEqual(CommonConstants.TYPE_FOLDER);
      } catch (e) {
      }
      mocker.clear(layoutCacheManager['layoutCacheData']);
    })

    it('test_FolderLayoutCacheManager_updateAppBadgeInFolder', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.page = 0;
      info.appIndex = 9;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com';
      itemInfo.abilityName = 'openharmony';
      itemInfo.row = 1;
      itemInfo.column = 1;
      itemInfo.page = 0;
      itemInfo.folderId = '996';
      itemInfo.typeId = CommonConstants.TYPE_FOLDER;
      itemInfo.area = [2, 1];
      itemInfo.layoutInfo = [[info]];
      let badgeInfo: BadgeItemInfo = new BadgeItemInfo();
      badgeInfo.id = 7;
      badgeInfo.bundleName = 'com';
      badgeInfo.badgeNumber = 9;
      badgeInfo.isShow = true;
      badgeInfo.userId = 7;
      badgeInfo.appIndex = 9;
      badgeInfo.badgeUpdateTaskStatus = true;
      let mocker: MockKit = new MockKit();
      try{
        let result: undefined = (layoutCacheManager['updateAppBadgeInFolder'](null, badgeInfo) as undefined);
        expect(result).assertEqual(undefined);
        let mockFunc: Function = mocker.mockFunc(FolderData.getInstance(), FolderData.getInstance().isFolderOpen);
        let mockFunc1: Function = mocker.mockFunc(FolderData.getInstance(), FolderData.getInstance().getOpenFolderId);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([info]);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn('996');
        let result1: GridLayoutItemInfo = (layoutCacheManager['updateAppBadgeInFolder'](itemInfo, badgeInfo) as GridLayoutItemInfo);
        expect(result1.folderId).assertEqual('996');
      } catch (e) {
      }
      mocker.clear(FolderData.getInstance());
    })

    it('test_FolderLayoutCacheManager_updateBadgeNumberInFolder', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.page = 0;
      info.appIndex = 9;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com';
      itemInfo.abilityName = 'openharmony';
      itemInfo.row = 1;
      itemInfo.column = 1;
      itemInfo.page = 0;
      itemInfo.folderId = '996';
      itemInfo.typeId = CommonConstants.TYPE_ADD;
      itemInfo.area = [2, 1];
      let badgeInfo: BadgeItemInfo = new BadgeItemInfo();
      badgeInfo.id = 7;
      badgeInfo.bundleName = 'com';
      badgeInfo.badgeNumber = 9;
      badgeInfo.isShow = true;
      badgeInfo.userId = 7;
      badgeInfo.appIndex = 9;
      badgeInfo.badgeUpdateTaskStatus = true;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      let mockFunc1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      let mockFunc2: Function = mocker.mockFunc(layoutCacheManager, layoutCacheManager['updateAppBadgeInFolder']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([info, itemInfo]);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(info);
      let result: GridLayoutItemInfo = layoutCacheManager['updateBadgeNumberInFolder'](badgeInfo, '996', true);
      expect(result.bundleName).assertEqual('com');
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clear(CheckEmptyUtils);
      mocker.clear(layoutCacheManager);
    })

    it('test_FolderLayoutCacheManager_updateFolderItemLayoutInfoByFolderIdList', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.page = 0;
      info.appIndex = 9;
      info.folderId = 'info';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      let map: Map<string, GridLayoutItemInfo[][]> = new Map();
      map.set('info', [[info]]);
      try{
        layoutCacheManager['updateFolderItemLayoutInfoByFolderIdList'](map, '996', true, true);
        expect(info.typeId).assertEqual(CommonConstants.TYPE_FOLDER);
        layoutCacheManager['updateFolderItemLayoutInfoByFolderIdList'](map, '996', false, false);
        expect(info.typeId).assertEqual(CommonConstants.TYPE_FOLDER);
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        layoutCacheManager['updateFolderItemLayoutInfoByFolderIdList'](map, '996', false, false);
        expect(info.typeId).assertEqual(CommonConstants.TYPE_FOLDER);
      } catch (e) {}
      mocker.clear(CheckEmptyUtils);
    })

    it('test_FolderLayoutCacheManager_deleteFolderAndUpdateAppItemToDesktop', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.page = 0;
      info.appIndex = 9;
      info.folderId = 'info';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      layoutCacheManager.deleteFolderAndUpdateAppItemToDesktop(1, info, '名字', false);
      expect(info.typeId).assertEqual(CommonConstants.TYPE_FOLDER);
    })

    it('test_FolderLayoutCacheManager_deleteGridLayoutItemByIndex', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      layoutCacheManager.deleteGridLayoutItemByIndex(1, '名字', false);
      expect(layoutCacheManager).not().assertNull();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(PageDesktopModel.getInstance(), PageDesktopModel.getInstance().deleteBlankPageFromLayoutInfo);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      layoutCacheManager.deleteGridLayoutItemByIndex(1, '名字', true);
      expect(layoutCacheManager).not().assertNull();
      mocker.clear(PageDesktopModel.getInstance());
    })

    it('test_FolderLayoutCacheManager_deleteGridLayoutItemByFolderIdList', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.page = 0;
      info.appIndex = 9;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com';
      itemInfo.abilityName = 'openharmony';
      itemInfo.row = 1;
      itemInfo.column = 1;
      itemInfo.page = 0;
      itemInfo.folderId = '996';
      itemInfo.typeId = CommonConstants.TYPE_ADD;
      itemInfo.area = [2, 1];
      let mocker: MockKit = new MockKit();
      try{
        let mockFunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([info, itemInfo]);
        layoutCacheManager.deleteGridLayoutItemByFolderIdList(['996', '007'], '名字', true);
        expect(itemInfo.typeId).assertEqual(CommonConstants.TYPE_ADD);
        layoutCacheManager.deleteGridLayoutItemByFolderIdList(['003', '005'], '名字', false);
        expect(itemInfo.typeId).assertEqual(CommonConstants.TYPE_ADD);
      } catch (e){};
      mocker.clear(layoutCacheManager['layoutCacheData']);
    })

    it('test_FolderLayoutCacheManager_deleteGridLayoutItemByItemId', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      layoutCacheManager.deleteGridLayoutItemByItemId(1, '名字', true);
      expect(layoutCacheManager).not().assertNull();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      layoutCacheManager.deleteGridLayoutItemByItemId(1, '名字', false);
      expect(layoutCacheManager).not().assertNull();
      mocker.clear(CheckEmptyUtils);
    })

    it('test_FolderLayoutCacheManager_selectFolderByKeyName', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.keyName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.page = 0;
      info.appIndex = 9;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com';
      itemInfo.abilityName = 'openharmony';
      itemInfo.keyName = 'openharmony';
      itemInfo.row = 1;
      itemInfo.column = 1;
      itemInfo.page = 0;
      itemInfo.folderId = '996';
      itemInfo.typeId = CommonConstants.TYPE_ADD;
      itemInfo.area = [2, 1];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      let mockFunc1: Function = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.layoutInfoToList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([info, itemInfo]);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn([info]);
      let result: GridLayoutItemInfo = (layoutCacheManager.selectFolderByKeyName('openharmony') as GridLayoutItemInfo);
      expect(result.keyName).assertEqual('openharmony');
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clear(LauncherLayoutCacheUtil);
    })

    it('test_FolderLayoutCacheManager_selectFolderByBundleNameAndAbilityName', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.keyName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.page = 0;
      info.appIndex = 9;
      info.folderId = '996';
      info.moduleName = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com';
      itemInfo.abilityName = 'openharmony';
      itemInfo.keyName = 'openharmony';
      itemInfo.row = 1;
      itemInfo.column = 1;
      itemInfo.page = 0;
      itemInfo.folderId = '996';
      itemInfo.moduleName = '996';
      itemInfo.typeId = CommonConstants.TYPE_ADD;
      itemInfo.area = [2, 1];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      let mockFunc1: Function = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.layoutInfoToList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([info, itemInfo]);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn([info, itemInfo]);
      let result: GridLayoutItemInfo = (layoutCacheManager.selectFolderByBundleNameAndAbilityName('com', 'openharmony', '996', CommonConstants.TYPE_FOLDER) as GridLayoutItemInfo);
      expect(result.typeId).assertEqual(CommonConstants.TYPE_FOLDER);
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clear(LauncherLayoutCacheUtil);
    })

    it('test_FolderLayoutCacheManager_selectFolderByContainShortCut', 0, () => {
      let layoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.keyName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.page = 0;
      info.appIndex = 9;
      info.folderId = '996';
      info.moduleName = '996';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.area = [2, 1];
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com';
      itemInfo.abilityName = 'openharmony';
      itemInfo.keyName = 'openharmony';
      itemInfo.row = 1;
      itemInfo.column = 1;
      itemInfo.page = 0;
      itemInfo.folderId = '996';
      itemInfo.moduleName = '996';
      itemInfo.typeId = CommonConstants.TYPE_ADD;
      itemInfo.area = [2, 1];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(layoutCacheManager['layoutCacheData'], layoutCacheManager['layoutCacheData'].getGridLayoutItemList);
      let mockFunc1: Function = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.layoutInfoToList);
      let mockFunc2: Function = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.isSameShortcutApp);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([info, itemInfo]);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn([itemInfo]);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      let result: GridLayoutItemInfo = (layoutCacheManager.selectFolderByContainShortCut(itemInfo) as GridLayoutItemInfo);
      expect(result.typeId).assertEqual(CommonConstants.TYPE_FOLDER);
      mocker.clear(layoutCacheManager['layoutCacheData']);
      mocker.clear(LauncherLayoutCacheUtil);
    })
  })
}