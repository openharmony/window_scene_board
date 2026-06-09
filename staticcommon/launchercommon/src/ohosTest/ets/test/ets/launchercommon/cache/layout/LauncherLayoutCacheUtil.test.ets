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
import {
  AppItemInfo,
  AppModel,
  AppStatus,
  BadgeItemInfo,
  CardItemInfo,
  CommonConstants,
  DeleteItemType,
  GridLayoutItemInfo,
  LayoutDescription,
  RdbStoreManager,
  PageUpdateItem
} from '../../../../../../../main/ets/TsIndex'
import { LauncherLayoutCacheUtil } from '../../../../../../../main/ets/cache/layout/LauncherLayoutCacheUtil'
import DefaultDesktopLayoutInfo from '../../../../../../../main/ets/configs/DefaultDesktopLayoutInfo';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { GridOccupyStatus, GridOccupyStatusEnum } from '@ohos/componentdrag';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ArrayList, HashMap } from '@kit.ArkTS';

function getNullObject(): GridLayoutItemInfo | null | DefaultDesktopLayoutInfo {
  return null;
}

export default function LauncherLayoutCacheUtilTest() {
  describe('LauncherLayoutCacheUtilTest', () => {
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
    it('isSameAppOrSmallFolder00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
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
      demoApp.shortcutId = 'shortcutId';
      // 条件1
      let res: boolean = LauncherLayoutCacheUtil.isSameAppOrSmallFolder(demoApp, bundleName, keyName, '0', 0);
      demoApp.appIndex = 1;
      res = LauncherLayoutCacheUtil.isSameAppOrSmallFolder(demoApp, bundleName, keyName, '0', 0);
      demoApp.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      res = LauncherLayoutCacheUtil.isSameAppOrSmallFolder(demoApp, bundleName, keyName, '0', 0, 'shortcutId');
      demoApp.typeId = CommonConstants.TYPE_FUNCTION;
      res = LauncherLayoutCacheUtil.isSameAppOrSmallFolder(demoApp, bundleName, keyName, '0', 0);
      demoApp.typeId = CommonConstants.TYPE_FOLDER;
      demoApp.folderId = '0';
      res = LauncherLayoutCacheUtil.isSameAppOrSmallFolder(demoApp, bundleName, keyName, '0', 0);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(res).assertEqual(true);
    })
    it('isSameAppOrSmallFolder01', 1, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
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
      let item = getNullObject() as GridLayoutItemInfo
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      // 条件1
      let res: boolean = LauncherLayoutCacheUtil.isSameAppOrSmallFolder(item, bundleName, keyName, '0', 0);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(res).assertEqual(false);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('isSameShortcutApp00', 0, () => {
      let item = getNullObject() as GridLayoutItemInfo;
      let res: boolean = false;
      try {
        res = LauncherLayoutCacheUtil.isSameShortcutApp(item, '', '', 0);
        expect(res).assertEqual(false);
        let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
        let bundleName: string = 'bundleName';
        let shortcutId: string = '1';
        let appIndex: number = 1;
        demoApp.bundleName = bundleName;
        demoApp.shortcutId = shortcutId;
        demoApp.appIndex = appIndex;
        res = LauncherLayoutCacheUtil.isSameShortcutApp(demoApp, bundleName, shortcutId, appIndex);
        expect(res).assertEqual(true);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }

    })

    it('isSameAppByBundleName00', 0, () => {
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      let bundleName: string = 'com.openharmony.demoApp';
      let shortcutId: string = '1';
      let appIndex = undefined;
      demoApp.bundleName = bundleName;
      demoApp.shortcutId = shortcutId;
      demoApp.appIndex = 0;
      demoApp.typeId = CommonConstants.TYPE_APP
      let res: boolean = LauncherLayoutCacheUtil.isSameAppByBundleName(demoApp, bundleName, appIndex);
      expect(res).assertEqual(true);
      demoApp.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      res = LauncherLayoutCacheUtil.isSameAppByBundleName(demoApp, bundleName, 1);
      expect(res).assertEqual(false);
    })

    it('layoutInfoToList00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
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
      let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoFolder.typeId = CommonConstants.TYPE_FOLDER;
      demoFolder.layoutInfo = [[demoApp]];

      try {
        // 条件1
        let resList: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.layoutInfoToList(demoFolder);
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(resList.length).assertEqual(1);
      } catch (err) {}
      demoApp.typeId = CommonConstants.TYPE_ADD;
      demoFolder.layoutInfo = [[demoApp]];
      try {
        let resList = LauncherLayoutCacheUtil.layoutInfoToList(demoFolder);
        expect(resList.length).assertEqual(0);
      }catch (err){}
      demoFolder.layoutInfo = undefined;
      try {
        let resList = LauncherLayoutCacheUtil.layoutInfoToList(demoFolder);
        expect(resList.length).assertEqual(0);
      }catch (err){}
    })

    it('printDuplicateInfo00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
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
      demoApp.area = [4, 6];
      demoApp.keyName = keyName;

      // 条件1
      LauncherLayoutCacheUtil.printDuplicateInfo(0, 6, 4, [demoApp]);
      let res: string = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(res).assertEqual('test');
    })

    it('updateAppBadgeInFolder00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
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
      let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoFolder.typeId = CommonConstants.TYPE_FOLDER;
      demoFolder.layoutInfo = [[demoApp]];
      demoFolder.badgeNumber = 10;
      demoApp.badgeNumber = 5;
      let badgeInfo: BadgeItemInfo = new BadgeItemInfo();
      badgeInfo.badgeNumber = 3;

      // 条件1
      LauncherLayoutCacheUtil.updateAppBadgeInFolder(demoFolder, demoApp, badgeInfo);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(demoFolder.badgeNumber).assertEqual(8);
    })
    it('updateAppBadgeInFolder01', 1, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
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
      let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoFolder.typeId = CommonConstants.TYPE_FOLDER;
      demoFolder.layoutInfo = [[demoApp]];
      demoFolder.badgeNumber = 10;
      demoApp.badgeNumber = 5;
      let badgeInfo: BadgeItemInfo = new BadgeItemInfo();
      badgeInfo.badgeNumber = 3;
      try {
        LauncherLayoutCacheUtil.updateAppBadgeInFolder(demoFolder, null, badgeInfo);
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(demoFolder.badgeNumber).assertEqual(10);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })
    it('updateAppBadgeInFolder02', 2, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
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
      let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoFolder.typeId = CommonConstants.TYPE_FOLDER;
      demoFolder.layoutInfo = [[demoApp]];
      demoFolder.badgeNumber = 10;
      demoApp.badgeNumber = 0;
      let badgeInfo: BadgeItemInfo = new BadgeItemInfo();
      badgeInfo.badgeNumber = 3;

      // 条件1
      LauncherLayoutCacheUtil.updateAppBadgeInFolder(demoFolder, demoApp, badgeInfo);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(demoFolder.badgeNumber).assertEqual(13);
      demoFolder.badgeNumber = -1;
      LauncherLayoutCacheUtil.updateAppBadgeInFolder(demoFolder, demoApp, badgeInfo);
      expect(demoFolder.badgeNumber).assertEqual(3);
    })

    it('test_updateFolderAppPackageInfo', 0, () => {
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.bundleName = 'bundleName';
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = 'keyName';
      demoApp.appStatus = AppStatus.WAIT_FOR_HARMONY;
      let newApp: AppItemInfo = new AppItemInfo();
      newApp.keyName = 'keyName';
      newApp.bundleName = 'newBundle';
      newApp.applicationLabelId = 1;
      newApp.appIconId = 1;
      newApp.appLabelId = 1;
      newApp.installTime = '1';
      newApp.moduleName = 'moduleName';
      newApp.appIconId = 1000;
      newApp.appName = 'appName';
      newApp.appStatus = AppStatus.INSTALLED;
      newApp.applicationName = 'applicationName';
      LauncherLayoutCacheUtil.updateFolderAppPackageInfo(demoApp, newApp);
      newApp.appStatus = AppStatus.PENDING;
      LauncherLayoutCacheUtil.updateFolderAppPackageInfo(demoApp, newApp);
      expect(demoApp.applicationName).assertEqual('applicationName');
    })

    it('test_isAddableForRotate', 0, () => {
      let layoutInfo = new DefaultDesktopLayoutInfo();
      layoutInfo.layoutDescription = new LayoutDescription();
      layoutInfo.layoutDescription.row = 1;
      layoutInfo.layoutDescription.column = 1;
      let ret = LauncherLayoutCacheUtil.isAddableForRotate(null, 1, 1, 1);
      expect(ret).assertEqual(false);
      ret = LauncherLayoutCacheUtil.isAddableForRotate(layoutInfo, 1, 1, 1);
      expect(ret).not().assertNull();
    })

    it('filterDuplicateElement00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
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
      let newApp: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoApp);
      let newApp1: GridLayoutItemInfo = ObjectCopyUtil.deepClone(demoApp);
      newApp1.page = -1;
      let gridItemList: GridLayoutItemInfo[] = [];
      gridItemList.push(demoApp);
      gridItemList.push(newApp);
      gridItemList.push(newApp1);
      let description: LayoutDescription = new LayoutDescription();
      description.pageCount = 2;
      description.row = 6;
      description.column = 4;
      description.maxPage = 3
      try {
        // 条件1
        let res: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.filterDuplicateElement(gridItemList, description);
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(res.length).assertEqual(1);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('updateCardLayoutInfo00', 0, () => {
      LauncherLayoutCacheUtil.updateCardLayoutInfo([], new GridLayoutItemInfo());
      let res: string = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(res).assertEqual('test');
    })

    it('updateCardLayoutInfo01', 0, () => {
      LauncherLayoutCacheUtil.updateCardLayoutInfo([], new GridLayoutItemInfo(), new GridLayoutItemInfo());

      let cardItemInfo: CardItemInfo = new CardItemInfo();
      cardItemInfo.id = 'infoId';
      cardItemInfo.bundleName = 'com.ohos.clock';
      cardItemInfo.page = 0;
      cardItemInfo.row = 0;
      cardItemInfo.cardName = 'card1000';
      cardItemInfo.moduleName = 'module1000';
      cardItemInfo.area = [1, 1];
      cardItemInfo.cardId = '1000';

      let itemInfo = new GridLayoutItemInfo();
      itemInfo.cardId = '100';
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      LauncherLayoutCacheUtil.updateCardLayoutInfo([cardItemInfo], itemInfo);

      itemInfo.cardId = '1000';
      LauncherLayoutCacheUtil.updateCardLayoutInfo([cardItemInfo], itemInfo);
      expect(itemInfo.formRefreshDate).not().assertNull();

      let stackLayoutInfo = new GridLayoutItemInfo();
      LauncherLayoutCacheUtil.updateCardLayoutInfo([cardItemInfo], itemInfo, stackLayoutInfo);
      expect(stackLayoutInfo.formRefreshDate).not().assertNull();
    })

    it('test_setIsPadPortrait', 0, () => {
      LauncherLayoutCacheUtil.setIsPadPortrait(true);
      expect(LauncherLayoutCacheUtil.getIsPadPortrait()).assertTrue();

      let layoutInfo = new DefaultDesktopLayoutInfo();
      LauncherLayoutCacheUtil.setPortraitDesktopLayoutInfo(layoutInfo);
      LauncherLayoutCacheUtil.setLandscapeDesktopLayoutInfo(layoutInfo);
      expect(true).assertTrue();
    });

    it('test_callBackFunctions1', 0, async (done: Function) => {
      LauncherLayoutCacheUtil.setIsPadPortrait(true);
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      let layoutInfo = new DefaultDesktopLayoutInfo();
      layoutInfo.layoutDescription = new LayoutDescription();
      layoutInfo.layoutDescription.row = 0;
      layoutInfo.layoutDescription.column = 0;
      layoutInfo.layoutInfo = [itemInfo];
      LauncherLayoutCacheUtil.setPortraitDesktopLayoutInfo(layoutInfo);
      const updateInfo: GridLayoutItemInfo[] = [itemInfo];
      try {
        LauncherLayoutCacheUtil.setPortraitDesktopLayoutInfo(layoutInfo);
        const updateInfo: GridLayoutItemInfo[] = [itemInfo];
        await LauncherLayoutCacheUtil.insertGridLayoutItemCallBack(itemInfo);
        await LauncherLayoutCacheUtil.insertItemWithoutLayoutInfo(itemInfo);
        LauncherLayoutCacheUtil.insertGridLayoutListCallBack(updateInfo);
        LauncherLayoutCacheUtil.insertNewInstalledAppCallBack(itemInfo);
        LauncherLayoutCacheUtil.addInfoToFolderCallBack('1234', updateInfo);
        LauncherLayoutCacheUtil.patchUpdateGridLayoutPositionCallBack(updateInfo);

        LauncherLayoutCacheUtil.updateFolderSizeCallBack([itemInfo]);
        LauncherLayoutCacheUtil.updateItemToDesktopCallBack([itemInfo]);
        LauncherLayoutCacheUtil.updateItemWithContainerCallBack([itemInfo]);
        LauncherLayoutCacheUtil.updateBadgeByBundleNameCallBack();
        LauncherLayoutCacheUtil.updateDownloadAppCallBack();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      expect(true).assertTrue();
      done();
    })

    it('test_callBackFunctions2', 0, () => {
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      itemInfo.abilityName = 'TestAbility';
      itemInfo.folderId = '1';
      itemInfo.folderName = 'folderName';
      let gridlayoutItems: GridLayoutItemInfo[] = [itemInfo];

      LauncherLayoutCacheUtil.insertGridLayoutItemCallBack(itemInfo);
      LauncherLayoutCacheUtil.insertNewFormStackInfoCallBack(itemInfo, gridlayoutItems);
      LauncherLayoutCacheUtil.insertGridLayoutListCallBack(gridlayoutItems);
      LauncherLayoutCacheUtil.insertNewInstalledAppCallBack(itemInfo);
      LauncherLayoutCacheUtil.addInfoToFolderCallBack('1234', gridlayoutItems);

      itemInfo.area = [1, 1];
      itemInfo.typeId = CommonConstants.TYPE_FOLDER;
      LauncherLayoutCacheUtil.deleteFolderItemCallBack(itemInfo);
      expect(true).assertTrue();
    })

    it('test_callBackFunctions3', 0, () => {
      LauncherLayoutCacheUtil.setIsPadPortrait(false);
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      itemInfo.abilityName = 'TestAbility';
      itemInfo.folderId = '1';
      itemInfo.folderName = 'folderName';
      itemInfo.infoId = '';
      let pageUpdateItems: PageUpdateItem[] = [
        { startPage: 1, endPage: 2, step: 1 }
      ];
      let gridlayoutItems: GridLayoutItemInfo[] = [itemInfo];
      let item = getNullObject() as GridLayoutItemInfo;
      LauncherLayoutCacheUtil.deleteGridLayoutItemByKeyNameCallBack(itemInfo);
      LauncherLayoutCacheUtil.patchDeleteGridLayoutItemCallBack([itemInfo]);
      LauncherLayoutCacheUtil.deleteGridLayoutItemByInfoIdCallBack();
      LauncherLayoutCacheUtil.deleteFormByFormIdCallback();
      LauncherLayoutCacheUtil.deleteFormInfoByBundleCallback();
      LauncherLayoutCacheUtil.deleteFormInFormStackByNameAndContainer(item, 0);
      LauncherLayoutCacheUtil.patchUpdateGridLayoutPages([]);
      LauncherLayoutCacheUtil.patchUpdateGridLayoutPages(pageUpdateItems, gridlayoutItems);
      expect(true).assertTrue();
    })

    it('test_callBackFunctions4', 0, () => {
      LauncherLayoutCacheUtil.setIsPadPortrait(false);
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      itemInfo.abilityName = 'TestAbility';
      itemInfo.folderId = '1';
      itemInfo.folderName = 'folderName';
      itemInfo.typeId = CommonConstants.TYPE_FOLDER;
      LauncherLayoutCacheUtil.deleteAndReplaceItemCallBack(itemInfo, itemInfo);
      LauncherLayoutCacheUtil.updateFolderNameCallBack(itemInfo);
      LauncherLayoutCacheUtil.updateFormPositionCallBack();
      LauncherLayoutCacheUtil.addInfoToFormStackCallBack();
      LauncherLayoutCacheUtil.updateFormInfoByIdChange(null);
      LauncherLayoutCacheUtil.updateItemToFormStackCallback();
      LauncherLayoutCacheUtil.updateCardIdOfFormStack();
      expect(true).assertTrue();
    })

    it('test_selectIdByFormStackId', 0, async (done: Function) => {
      let ret = await LauncherLayoutCacheUtil.selectIdByFormStackId('');
      expect(ret).assertEqual(-1);
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.id = 1;
      itemInfo.formStackId = 'formStackId';
      let list: GridLayoutItemInfo[] = [itemInfo];
      let rdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbStoreManager, rdbStoreManager.queryGridLayoutByType);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(list);
      ret = await LauncherLayoutCacheUtil.selectIdByFormStackId('formStackId');
      expect(ret).assertEqual(1);
      ret = await LauncherLayoutCacheUtil.selectIdByFormStackId('test');
      expect(ret).assertEqual(-1);
      when(mockFunc)(ArgumentMatchers.any).afterThrow('error');
      ret = await LauncherLayoutCacheUtil.selectIdByFormStackId('formStackId');
      expect(ret).assertEqual(-1);
      mocker.clear(rdbStoreManager);
      mocker.clearAll();
      done();
    })

    it('test_deleteFolderItemCallBack', 0, () => {
      LauncherLayoutCacheUtil.setIsPadPortrait(true);

      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      itemInfo.abilityName = 'TestAbility';
      itemInfo.folderId = '1';
      itemInfo.folderName = 'folderName';
      itemInfo.container = 5200;
      itemInfo.typeId = 1;
      itemInfo.area = [1, 1];

      let appItem = new GridLayoutItemInfo();
      appItem.bundleName = 'com.test.name';
      appItem.moduleName = 'test_module';
      appItem.abilityName = 'TestAbility';
      appItem.folderId = '1';
      appItem.folderName = 'folderName';
      appItem.container = -100;
      appItem.typeId = 3;
      appItem.area = [1, 1];

      try {
        LauncherLayoutCacheUtil.deleteAndReplaceItemCallBack(itemInfo, itemInfo);
        let item = getNullObject() as GridLayoutItemInfo
        LauncherLayoutCacheUtil.deleteFolderItemCallBack(item);
        LauncherLayoutCacheUtil.deleteFolderItemCallBack(appItem, false);
        LauncherLayoutCacheUtil.deleteFolderItemCallBack(itemInfo, true);
        expect(LauncherLayoutCacheUtil.getIsPadPortrait()).assertTrue();
        LauncherLayoutCacheUtil.addInfoToFormStackCallBack(itemInfo);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('test_deleteShortcutItemCallBack', 0, () => {
      LauncherLayoutCacheUtil.setIsPadPortrait(true);
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      itemInfo.abilityName = 'TestAbility';
      itemInfo.folderId = 'id80287934523';
      itemInfo.folderName = 'folderName';
      let gridlayoutItems: GridLayoutItemInfo[] = [itemInfo];
      try {
        LauncherLayoutCacheUtil.deleteShortcutItemCallBack(gridlayoutItems);
        expect(LauncherLayoutCacheUtil.getIsPadPortrait()).assertTrue();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('test_updateFormInfoByIdCallBack', 0, async (done: Function) => {
      let cardItemInfo: CardItemInfo = new CardItemInfo();
      cardItemInfo.id = 'infoId';
      cardItemInfo.bundleName = 'com.ohos.clock';
      cardItemInfo.page = 0;
      cardItemInfo.row = 0;
      cardItemInfo.column = 0;
      cardItemInfo.area = [1, 1];
      cardItemInfo.typeId === CommonConstants.TYPE_FOLDER;
      LauncherLayoutCacheUtil.setIsPadPortrait(false);
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      itemInfo.page = 0;
      itemInfo.row = 0;
      itemInfo.column = 0;
      itemInfo.typeId === CommonConstants.TYPE_FOLDER;
      let info: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      info.layoutInfo = [itemInfo];
      LauncherLayoutCacheUtil.setPortraitDesktopLayoutInfo(info);
      LauncherLayoutCacheUtil.setIsPadPortrait(true);
      await LauncherLayoutCacheUtil.updateFormInfoByIdChange(cardItemInfo);
      expect(LauncherLayoutCacheUtil.getIsPadPortrait()).assertTrue();
      done();
    })

    it('test_updateFormPositionCallBack', 0, () => {
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      itemInfo.abilityName = 'TestAbility';
      itemInfo.folderId = '1';
      itemInfo.folderName = 'folderName';
      LauncherLayoutCacheUtil.setIsPadPortrait(true);
      LauncherLayoutCacheUtil.updateFormPositionCallBack(itemInfo);
      expect(LauncherLayoutCacheUtil.getIsPadPortrait()).assertTrue();
    })

    it('test_deleteFormInfoByPositionCallback_01', 0, () => {
      LauncherLayoutCacheUtil.setIsPadPortrait(true);
      LauncherLayoutCacheUtil.deleteFormInfoByPositionCallback(1, 0, 0, false, false);
      expect(LauncherLayoutCacheUtil.getIsPadPortrait()).assertTrue();
    })

    it('test_deleteFormInfoByPositionCallback_02', 0, () => {
      LauncherLayoutCacheUtil.setIsPadPortrait(true);
      LauncherLayoutCacheUtil.deleteFormInfoByPositionCallback(1, 0, 0, false, true);
      expect(LauncherLayoutCacheUtil.getIsPadPortrait()).assertTrue();
    })

    it('test_insertGridLayoutItemCallBack_mock', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunc1)().afterReturn(true);
      LauncherLayoutCacheUtil.insertGridLayoutItemCallBack(null);
      expect(true).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_deleteAppItemCallBack_mock', 0, () => {
      let item: DeleteItemType = new TestDeleteItemType();
      item.bundleName = ' com.ohos.calendar';
      item.moduleName = 'main';
      item.abilityName = 'MainAbility';
      item.keyName = 'test key';

      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      itemInfo.abilityName = 'TestAbility';
      itemInfo.folderId = '1';
      itemInfo.folderName = 'folderName';
      item.deleteByDockDrop = false;

      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunc1)().afterReturn(false);
      LauncherLayoutCacheUtil.deleteAppItemCallBack(item, [itemInfo]);
      expect(true).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_deleteAppItemCallBack_mock01', 0, async (done: Function) => {
      let item: DeleteItemType = new TestDeleteItemType();
      item.bundleName = ' com.ohos.calendar';
      item.moduleName = 'main';
      item.abilityName = 'MainAbility';
      item.keyName = 'test key';
      item.appIndex = 0

      let itemInfoA = new GridLayoutItemInfo();
      itemInfoA.bundleName = 'com.test.name';
      itemInfoA.moduleName = 'test_module';
      itemInfoA.abilityName = 'TestAbility';
      itemInfoA.folderId = '1';
      itemInfoA.folderName = 'folderName';
      itemInfoA.appIndex = 0;
      itemInfoA.typeId = 0;
      item.deleteByDockDrop = false;

      let itemInfoB = new GridLayoutItemInfo();
      itemInfoB.bundleName = 'com.test.name';
      itemInfoB.moduleName = 'test_module';
      itemInfoB.abilityName = 'TestAbility';
      itemInfoB.folderId = '1';
      itemInfoB.folderName = 'folderName';
      itemInfoB.appIndex = 0;
      itemInfoB.typeId = 1;
      item.deleteByDockDrop = false;

      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunc1)().afterReturn(true);
      LauncherLayoutCacheUtil.deleteAppItemCallBack(item, [itemInfoA, itemInfoB], true);
      let ret = await RdbStoreManager.getInstance().deleteInfoByBundle(item.bundleName, 0, item.appIndex, true);
      ret = await RdbStoreManager.getInstance().deleteInfoByBundle(item.bundleName, 1, item.appIndex, true);
      expect(itemInfoB).not().assertUndefined();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
      done();
    })

    it('test_isFreeForGridLayoutItem', 0, () => {
      let bundleName: string = 'com.openharmony.demoApp';
      let keyName: string = 'com.openharmony.demoAppPhoneEntryAbility';
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.infoId = '1';
      item.bundleName = bundleName;
      item.typeId = CommonConstants.TYPE_APP;
      item.page = 1;
      item.row = 0;
      item.column = 0;
      item.area = [1, 1];
      item.keyName = keyName;
      let status: GridOccupyStatus = new GridOccupyStatus(0, 0, GridOccupyStatusEnum.FREE);
      let ret: boolean = LauncherLayoutCacheUtil['isFreeForGridLayoutItem'](item, status);
      expect(ret).assertInstanceOf('Boolean');
    })

    it('test_isAddable', 0, () => {
      let layoutInfo = new DefaultDesktopLayoutInfo();
      let ret = LauncherLayoutCacheUtil.isAddable(layoutInfo.layoutInfo, new GridLayoutItemInfo(), 0);
      expect(ret).assertTrue();

      let description: LayoutDescription = new LayoutDescription();
      description.pageCount = 2;
      description.row = 0;
      description.column = 0;
      description.maxPage = 3

      layoutInfo.layoutDescription = description;
      ret = LauncherLayoutCacheUtil.isAddable(layoutInfo.layoutInfo, new GridLayoutItemInfo(), 0);
      expect(ret).assertTrue();

      description.pageCount = 2;
      description.row = 0;
      description.column = 2;
      description.maxPage = 3
      ret = LauncherLayoutCacheUtil.isAddable(layoutInfo.layoutInfo, new GridLayoutItemInfo(), 0);
      expect(ret).assertInstanceOf('Boolean');
    })

    it('test_isAddable01', 0, () => {
      let layoutInfo = new DefaultDesktopLayoutInfo();
      let description: LayoutDescription = new LayoutDescription();
      description.pageCount = 2;
      description.row = 2;
      description.column = 0;
      description.maxPage = 3
      layoutInfo.layoutDescription = description;

      let ret = LauncherLayoutCacheUtil.isAddable(layoutInfo.layoutInfo, new GridLayoutItemInfo(), 0);
      expect(ret).assertInstanceOf('Boolean');

      description.row = 2;
      description.column = 2;
      ret = LauncherLayoutCacheUtil.isAddable(layoutInfo.layoutInfo, new GridLayoutItemInfo(), 0);
      expect(ret).assertInstanceOf('Boolean');

      description.row = 2;
      description.column = 1;
      ret = LauncherLayoutCacheUtil.isAddable(layoutInfo.layoutInfo, new GridLayoutItemInfo(), 0);
      expect(ret).assertTrue();
    })

    it('test_getLargeCardArea', 0, () => {
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      itemInfo.page = 1;
      itemInfo.area = [3, 3];

      let layoutInfo = new DefaultDesktopLayoutInfo();
      layoutInfo.layoutInfo = [itemInfo];
      let ret = LauncherLayoutCacheUtil['getLargeCardArea'](layoutInfo, 1);
      expect(ret).assertEqual(9);

      itemInfo.area = [1, 1];
      ret = LauncherLayoutCacheUtil['getLargeCardArea'](layoutInfo, 1);
      expect(ret).assertEqual(0);

      itemInfo.page = 10;
      ret = LauncherLayoutCacheUtil['getLargeCardArea'](layoutInfo, 1);
      expect(ret).assertEqual(0);
    })

    it('test_getRotateLayout', 0, () => {
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      let desktopLayoutInfo = new DefaultDesktopLayoutInfo();
      desktopLayoutInfo.layoutDescription = new LayoutDescription();
      desktopLayoutInfo.layoutDescription.row = 0;
      desktopLayoutInfo.layoutDescription.column = 0;
      desktopLayoutInfo.layoutDescription.maxPage = 1;
      desktopLayoutInfo.layoutDescription.pageCount = 1;
      desktopLayoutInfo.layoutInfo = [itemInfo];

      LauncherLayoutCacheUtil.getRotateLayout(desktopLayoutInfo, true);
      LauncherLayoutCacheUtil.setIsPadPortrait(true);
      LauncherLayoutCacheUtil.getRotateLayout(desktopLayoutInfo, true, [1]);
      expect(desktopLayoutInfo).not().assertNull();
    })

    it('test_getRotateLayout1', 0, () => {
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      let desktopLayoutInfo = new DefaultDesktopLayoutInfo();
      desktopLayoutInfo.layoutDescription = new LayoutDescription();
      desktopLayoutInfo.layoutDescription.row = 0;
      desktopLayoutInfo.layoutDescription.column = 0;
      desktopLayoutInfo.layoutDescription.maxPage = 1;
      desktopLayoutInfo.layoutDescription.pageCount = 1;
      desktopLayoutInfo.layoutInfo = [itemInfo];
      LauncherLayoutCacheUtil.getRotateLayout(desktopLayoutInfo, true, [], [2, 2]);
      LauncherLayoutCacheUtil.setIsPadPortrait(true);
      LauncherLayoutCacheUtil.getRotateLayout(desktopLayoutInfo, true, [1]);
      expect(desktopLayoutInfo).not().assertNull();
    })

    it('test_getRotateLayout2', 0, () => {
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      let desktopLayoutInfo = new DefaultDesktopLayoutInfo();
      desktopLayoutInfo.layoutDescription = new LayoutDescription();
      desktopLayoutInfo.layoutDescription.row = 1;
      desktopLayoutInfo.layoutDescription.column = 1;
      desktopLayoutInfo.layoutDescription.maxPage = 1;
      desktopLayoutInfo.layoutDescription.pageCount = 1;
      desktopLayoutInfo.layoutInfo = [itemInfo];
      LauncherLayoutCacheUtil.getRotateLayout(desktopLayoutInfo, true, [], [2, 2], true);
      LauncherLayoutCacheUtil.setIsPadPortrait(true);
      LauncherLayoutCacheUtil.getRotateLayout(desktopLayoutInfo, true, [1]);
      expect(desktopLayoutInfo).not().assertNull();
    })

    it('test_getLazyRotateLayout', 0, () => {
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      itemInfo.page = 1;
      itemInfo.area = [3, 3];
      let layoutInfo = new DefaultDesktopLayoutInfo();
      layoutInfo.layoutInfo = [itemInfo];
      let ret = LauncherLayoutCacheUtil['getLazyRotateLayout'](layoutInfo, false, [2, 2], true);
      expect(ret).not().assertNull();

      let ret1 = LauncherLayoutCacheUtil['getLazyRotateLayout'](layoutInfo, false, [2, 2], false);
      expect(ret1).not().assertNull();
    })

    it('test_sortLayoutInfo', 0, () => {
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      itemInfo.page = 1;
      itemInfo.area = [3, 3];

      let layoutInfo = new DefaultDesktopLayoutInfo();
      layoutInfo.layoutInfo = [itemInfo];

      let ret = LauncherLayoutCacheUtil['sortLayoutInfo'](layoutInfo, 1);
      expect(ret.length).assertLargerOrEqual(0);

      ret = LauncherLayoutCacheUtil['sortLayoutInfo'](layoutInfo, 1000);
      expect(ret.length).assertLargerOrEqual(0);
    })

    it('test_regularSort', 0, () => {
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();

      let list: ArrayList<GridLayoutItemInfo> = new ArrayList();
      LauncherLayoutCacheUtil['regularSort'](list);
      list.add(item1);
      LauncherLayoutCacheUtil['regularSort'](list);

      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      list.add(item2);
      item1.row = 1;
      item1.column = 2;
      item2.row = 2;
      item2.column = 2;
      LauncherLayoutCacheUtil['regularSort'](list);
      expect(list.length).assertLarger(0);
    })

    it('test_regularSort01', 0, () => {
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();

      let list: ArrayList<GridLayoutItemInfo> = new ArrayList();
      list.add(null);
      list.add(null);
      LauncherLayoutCacheUtil['regularSort'](list);

      list.clear();
      list.add(null);
      list.add(item1);
      LauncherLayoutCacheUtil['regularSort'](list);

      list.clear();
      list.add(item1);
      list.add(null);
      LauncherLayoutCacheUtil['regularSort'](list);

      list.clear();
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.row = 5;
      item1.column = 2;
      item2.row = 2;
      item2.column = 2;
      item2.row = 1;
      list.add(item1);
      list.add(item2);
      LauncherLayoutCacheUtil['regularSort'](list);
      expect(list.length).assertLarger(0);

      list.clear();
      item1.row = 1;
      item2.row = 1;
      item1.column = 1;
      item2.column = 2;
      list.add(item1);
      list.add(item2);
      LauncherLayoutCacheUtil['regularSort'](list);
      expect(list.length).assertLarger(0);

      list.clear();
      item1.row = 1;
      item2.row = 1;
      item1.column = 3;
      item2.column = 2;
      list.add(item1);
      list.add(item2);
      LauncherLayoutCacheUtil['regularSort'](list);
      expect(list.length).assertLarger(0);

      list.clear();
      item1.row = 1;
      item2.row = 1;
      item1.column = 3;
      item2.column = 3;
      list.add(item1);
      list.add(item2);
      LauncherLayoutCacheUtil['regularSort'](list);
      expect(list.length).assertLarger(0);
    })

    it('test_regularSort02', 0, () => {
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      let list: ArrayList<GridLayoutItemInfo> = new ArrayList();
      list.add(item1);
      list.add(item2);
      LauncherLayoutCacheUtil['regularSort'](list);
      expect(list.length).assertLarger(0);

      list.clear();
      item1.row = 1;
      item2.row = 1;
      list.add(item1);
      list.add(item2);
      LauncherLayoutCacheUtil['regularSort'](list);
      expect(list.length).assertLarger(0);
    })

    it('test_regularSort02', 0, () => {
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      let list: ArrayList<GridLayoutItemInfo> = new ArrayList();
      list.add(item1);
      list.add(item2);
      LauncherLayoutCacheUtil['regularSort'](list);
      expect(list.length).assertLarger(0);

      list.clear();
      item1.row = 1;
      item2.row = 1;
      list.add(item1);
      list.add(item2);
      LauncherLayoutCacheUtil['regularSort'](list);
      expect(list.length).assertLarger(0);
    })

    it('test_checkIfClockCard', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = 1;
      item.bundleName = 'com.ohos.totemweather';
      item.cardName = 'ClockWeatherCard';
      let ret = LauncherLayoutCacheUtil['checkIfClockCard'](item);
      expect(ret).assertEqual(true);
    })

    it('test_startFinalSort', 0, () => {
      let extraItemMap: HashMap<string, GridLayoutItemInfo> = new HashMap();
      let list: ArrayList<GridLayoutItemInfo> = new ArrayList();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'bundleName';
      item.moduleName = 'moduleName';
      item.page = 1;
      list.add(item);
      let array: GridLayoutItemInfo[] = [];
      LauncherLayoutCacheUtil['startFinalSort'](false, 0, list, array, extraItemMap);
      LauncherLayoutCacheUtil['startFinalSort'](true, 0, list, array, extraItemMap);
      expect(array.length).assertLarger(0);
      LauncherLayoutCacheUtil['startFinalSort'](true, 1000, list, array, extraItemMap);
      LauncherLayoutCacheUtil['startFinalSort'](true, 1, list, array, extraItemMap);
      expect(array.length).assertLarger(0);
    })

    it('test_setExtraItemPosition', 0, () => {
      let extraItemMap: HashMap<string, GridLayoutItemInfo> = new HashMap();
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      itemInfo.page = 1;
      extraItemMap.set('test_module', itemInfo);

      let itemInfo1 = new GridLayoutItemInfo();
      itemInfo1.bundleName = 'com.test.other';
      itemInfo1.moduleName = 'test_module';
      itemInfo1.page = 1;
      extraItemMap.set('test_module2', itemInfo1);

      let layoutInfo = new DefaultDesktopLayoutInfo();
      layoutInfo.layoutDescription = new LayoutDescription();
      layoutInfo.layoutDescription.row = 0;
      layoutInfo.layoutDescription.column = 0;
      layoutInfo.layoutDescription.maxPage = 1;
      layoutInfo.layoutDescription.pageCount = 1;
      layoutInfo.layoutInfo = [itemInfo,itemInfo1];
      let layoutInfoCopied = ObjectCopyUtil.deepClone(layoutInfo);
      LauncherLayoutCacheUtil['setExtraItemPosition'](layoutInfo, layoutInfoCopied, extraItemMap);
      expect(true).assertTrue();
      layoutInfo.layoutDescription.maxPage = 5;
      layoutInfo.layoutDescription.pageCount = 1;
      LauncherLayoutCacheUtil['setExtraItemPosition'](layoutInfo, layoutInfoCopied, extraItemMap);
      expect(extraItemMap.length).assertEqual(2);
    })

    it('test_showErrorInfo', 0, () => {
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'item1.bundleName';
      item2.bundleName = 'item2.bundleName';
      let list1: Array<GridLayoutItemInfo> = new Array();
      let list2: Array<GridLayoutItemInfo> = new Array();
      list1.push(item1);
      list2.push(item2);

      let pageList: Array<Array<GridLayoutItemInfo>> = new Array();
      pageList.push(list1);
      pageList.push(list2);

      LauncherLayoutCacheUtil['showErrorInfo'](0, pageList);
      LauncherLayoutCacheUtil['showErrorInfo'](10, pageList);
      expect(pageList.length).assertLarger(0);
    })

    it('test_getGridSize', 0, () => {
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      itemInfo.area = undefined;
      let grid: TestGridArgs = LauncherLayoutCacheUtil['getGridSize'](itemInfo);
      itemInfo.area = [2, 3];
      grid = LauncherLayoutCacheUtil['getGridSize'](itemInfo);
      expect(grid.gridColumn).assertEqual(itemInfo.area[0]);
    })

    it('test_canPlaceIcon', 0, () => {
      let desktop: number[][] = [[1, 2, 3], [2, 3, 4]];
      let ret = LauncherLayoutCacheUtil['canPlaceIcon'](desktop, 0, 0, 1, 1);
      expect(ret).assertInstanceOf('Boolean');

      desktop = [[0, 0, 0], [0, 0,]];
      ret = LauncherLayoutCacheUtil['canPlaceIcon'](desktop, 0, 0, 1, 1);
      expect(ret).assertInstanceOf('Boolean');
    })

    it('test_placeIcon', 0, () => {
      let desktop: number[][] = [[0, 0, 0, 0, 0], [0, 0, 0, 0, 0]];
      let position: TestPosition = {
        i: 0, j: 0
      };
      let itemInfo = new GridLayoutItemInfo();
      LauncherLayoutCacheUtil['placeIcon'](desktop, position, 0, 1, itemInfo);
      expect(itemInfo.row).assertLargerOrEqual(0)
    })

    it('test_getFinalSortLayout', 0, () => {
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      itemInfo.page = 2;
      itemInfo.row = 1;
      itemInfo.column = 1;
      itemInfo.area = [1, 1];
      let itemInfo1 = new GridLayoutItemInfo();
      itemInfo1.bundleName = 'com.test.name';
      itemInfo1.moduleName = 'test_module';
      itemInfo1.page = 2;
      itemInfo1.row = 2;
      itemInfo1.column = 2;
      itemInfo1.area = [0, 0];
      let desktopLayoutInfo = new DefaultDesktopLayoutInfo();
      desktopLayoutInfo.layoutDescription = new LayoutDescription();
      desktopLayoutInfo.layoutDescription.row = 0;
      desktopLayoutInfo.layoutDescription.column = 0;
      desktopLayoutInfo.layoutDescription.maxPage = 1;
      desktopLayoutInfo.layoutDescription.pageCount = 1;
      desktopLayoutInfo.layoutInfo = [itemInfo, itemInfo1];

      let array: ArrayList<GridLayoutItemInfo> = LauncherLayoutCacheUtil['getFinalSortLayout'](desktopLayoutInfo, 2);
      expect(array.length).assertLarger(-1);
      itemInfo1.area = [2, 2];
      desktopLayoutInfo.layoutInfo = [itemInfo, itemInfo1];
      array = LauncherLayoutCacheUtil['getFinalSortLayout'](desktopLayoutInfo, 2);
      expect(array.length).assertLarger(1);
      array = LauncherLayoutCacheUtil['getFinalSortLayout'](desktopLayoutInfo, 2000);
      expect(array.length).assertEqual(0);
      itemInfo.area = [1];
      itemInfo1.area = [1];
      desktopLayoutInfo.layoutInfo = [itemInfo, itemInfo1];
      array = LauncherLayoutCacheUtil['getFinalSortLayout'](desktopLayoutInfo, 2);
      expect(array.length).assertEqual(2);
    })

    it('test_tryRegularSort', 0, () => {
      let item1 = new GridLayoutItemInfo();
      let item2 = new GridLayoutItemInfo();
      LauncherLayoutCacheUtil['tryRegularSort'](item1, item2);
      item1.row = 0;
      LauncherLayoutCacheUtil['tryRegularSort'](item1, item2);
      LauncherLayoutCacheUtil['tryRegularSort'](item2, item1);
      item2.row = 0;
      LauncherLayoutCacheUtil['tryRegularSort'](item2, item1);

      item1.row = 0;
      item2.row = 10;
      expect(LauncherLayoutCacheUtil['tryRegularSort'](item2, item1)).assertEqual(1);
      item1.row = 10;
      item2.row = 0;
      expect(LauncherLayoutCacheUtil['tryRegularSort'](item2, item1)).assertEqual(-1);
    })

    it('test_tryRegularSort01', 0, () => {
      let item1 = new GridLayoutItemInfo();
      let item2 = new GridLayoutItemInfo();
      item1.row = 1;
      item2.row = 1;
      item1.column = 1;
      item2.column = 1;
      expect(LauncherLayoutCacheUtil['tryRegularSort'](item1, item2)).assertEqual(0);

      item1.column = 12;
      item2.column = 1;
      expect(LauncherLayoutCacheUtil['tryRegularSort'](item1, item2)).assertEqual(1);
      item1.column = 0;
      item2.column = 11;
      expect(LauncherLayoutCacheUtil['tryRegularSort'](item1, item2)).assertEqual(-1);
    })

    it('test_findPageItems', 0, () => {
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      itemInfo.page = 2;
      itemInfo.row = 1;
      itemInfo.column = 1;

      let desktopLayoutInfo = new DefaultDesktopLayoutInfo();
      desktopLayoutInfo.layoutDescription = new LayoutDescription();
      desktopLayoutInfo.layoutDescription.row = 0;
      desktopLayoutInfo.layoutDescription.column = 0;
      desktopLayoutInfo.layoutDescription.maxPage = 1;
      desktopLayoutInfo.layoutDescription.pageCount = 1;
      desktopLayoutInfo.layoutInfo = [itemInfo];
      let ret = LauncherLayoutCacheUtil['findPageItems'](desktopLayoutInfo, 2);
      expect(ret.length).assertEqual(1);

      ret = LauncherLayoutCacheUtil['findPageItems'](desktopLayoutInfo, 2345);
      expect(ret.length).assertEqual(0);
    })

    it('test_getChangedLayout', 0, () => {
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      itemInfo.page = 2;
      itemInfo.row = 1;
      itemInfo.column = 1;

      let desktopLayoutInfo = new DefaultDesktopLayoutInfo();
      desktopLayoutInfo.layoutDescription = new LayoutDescription();
      desktopLayoutInfo.layoutDescription.row = 0;
      desktopLayoutInfo.layoutDescription.column = 0;
      desktopLayoutInfo.layoutDescription.maxPage = 1;
      desktopLayoutInfo.layoutDescription.pageCount = 1;
      desktopLayoutInfo.layoutInfo = [];
      desktopLayoutInfo.layoutInfo.push(itemInfo);

      let itemCurrent = new GridLayoutItemInfo();
      itemCurrent.bundleName = 'com.test.current';
      itemCurrent.moduleName = 'test_module';
      itemCurrent.page = 2;
      itemCurrent.row = 1;
      itemCurrent.column = 1;
      let currentDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      currentDesktopLayoutInfo.layoutDescription = new LayoutDescription();
      currentDesktopLayoutInfo.layoutDescription.row = 0;
      currentDesktopLayoutInfo.layoutDescription.column = 0;
      currentDesktopLayoutInfo.layoutDescription.maxPage = 1;
      currentDesktopLayoutInfo.layoutDescription.pageCount = 1;
      currentDesktopLayoutInfo.layoutInfo = [];
      currentDesktopLayoutInfo.layoutInfo.push(itemCurrent);

      let ret = LauncherLayoutCacheUtil['getChangedLayout'](desktopLayoutInfo, currentDesktopLayoutInfo);
      expect(ret).not().assertNull();
    })

    it('test_isSameLayout', 0, () => {
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = 'infoId';
      demoApp.bundleName = 'bundleName';
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = 'keyName';
      let layoutMap: HashMap<string, GridLayoutItemInfo> = new HashMap();
      let ret = LauncherLayoutCacheUtil['isSameLayout'](demoApp, layoutMap);
      expect(ret).assertFalse();

      let info:DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      info.layoutInfo = [demoApp];
      LauncherLayoutCacheUtil['createLayoutMap'](info,layoutMap);

      ret = LauncherLayoutCacheUtil['isSameLayout'](demoApp, layoutMap);
      expect(ret).assertTrue();

      demoApp.area = [1];
      info.layoutInfo = [demoApp];
      LauncherLayoutCacheUtil['createLayoutMap'](info,layoutMap);
      ret = LauncherLayoutCacheUtil['isSameLayout'](demoApp, layoutMap);
      expect(ret).assertFalse();
    })

    it('test_isSameLayout01', 0, () => {
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = 'infoId';
      demoApp.bundleName = 'bundleName';
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      demoApp.keyName = 'keyName';

      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.infoId = 'infoId';
      item.bundleName = 'bundleName';
      item.typeId = CommonConstants.TYPE_APP;
      item.page = 1000;
      item.row = 0;
      item.column = 0;
      item.area = [1, 1];
      item.keyName = 'keyName';
      let info: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      info.layoutInfo = [item];
      let layoutMap: HashMap<string, GridLayoutItemInfo> = new HashMap();
      LauncherLayoutCacheUtil['createLayoutMap'](info, layoutMap);

      let ret = LauncherLayoutCacheUtil['isSameLayout'](demoApp, layoutMap);
      expect(ret).assertFalse();

      layoutMap.clear();
      item.page = demoApp.page;
      item.row = 111;
      item.column = 222;
      LauncherLayoutCacheUtil['createLayoutMap'](info, layoutMap);
      ret = LauncherLayoutCacheUtil['isSameLayout'](demoApp, layoutMap);
      expect(ret).assertFalse();

      layoutMap.clear();
      item.page = demoApp.page;
      item.row = demoApp.row;
      item.column = demoApp.column;
      demoApp.area = [1, 123];
      LauncherLayoutCacheUtil['createLayoutMap'](info, layoutMap);
      ret = LauncherLayoutCacheUtil['isSameLayout'](demoApp, layoutMap);
      expect(ret).assertFalse();
    })

    it('test_addOldUpdatePage', 0, () => {
      let updatePages: number[] = [4, 2, 4, 2];
      let fromPage: number = 3;
      let ret = LauncherLayoutCacheUtil['addOldUpdatePage'](updatePages, fromPage);
      updatePages = [1, 4, 4, 2];
      ret = LauncherLayoutCacheUtil['addOldUpdatePage'](updatePages, fromPage);
      updatePages = [1, 2, 2, 2];
      ret = LauncherLayoutCacheUtil['addOldUpdatePage'](updatePages, fromPage);
      expect(ret.length).assertLarger(0);
    })

    it('test_getAppItemListPage', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.infoId = 'infoId';
      item.bundleName = 'bundleName';
      item.typeId = CommonConstants.TYPE_APP;
      item.page = 1000;
      item.row = 0;
      item.column = 0;
      item.area = [1, 1];
      item.keyName = 'keyName';
      let item2 = ObjectCopyUtil.deepClone(item);
      item2.page = 1000;
      let itemList: GridLayoutItemInfo[] = [item, item2];
      let ret = LauncherLayoutCacheUtil['getAppItemListPage'](itemList);
      expect(ret.length).assertEqual(1);
    })

    it('test_getItemByPosition', 0, () => {
      let ret = LauncherLayoutCacheUtil['getItemByPosition'](0, 0, 0);
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.infoId = 'infoId';
      item.bundleName = 'bundleName';
      item.typeId = CommonConstants.TYPE_APP;
      item.page = 1000;
      item.row = 0;
      item.column = 0;
      item.area = [1, 1];
      item.keyName = 'keyName';
      let info: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      info.layoutInfo = [item];
      LauncherLayoutCacheUtil.setPortraitDesktopLayoutInfo(info);
      ret = LauncherLayoutCacheUtil['getItemByPosition'](1000, 0, 0, CommonConstants.TYPE_APP);
      expect(ret).assertEqual(item);
    });

    it('test_addPageAndSetPosition', 0, () => {
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.test.name';
      item1.moduleName = 'test_module';
      item1.page = 1;
      item1.row = 1;
      item1.column = 1;

      let list: GridLayoutItemInfo[] = [item1];
      let pageList: GridLayoutItemInfo[][] = [[]];
      pageList.push(list);

      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      itemInfo.page = 2;
      itemInfo.row = 1;
      itemInfo.column = 1;

      let desktopLayoutInfo = new DefaultDesktopLayoutInfo();
      desktopLayoutInfo.layoutDescription = new LayoutDescription();
      desktopLayoutInfo.layoutDescription.row = 0;
      desktopLayoutInfo.layoutDescription.column = 0;
      desktopLayoutInfo.layoutDescription.maxPage = 1;
      desktopLayoutInfo.layoutDescription.pageCount = 1;
      desktopLayoutInfo.layoutInfo = [itemInfo];
      let layoutInfoCopied = ObjectCopyUtil.deepClone(desktopLayoutInfo);

      LauncherLayoutCacheUtil['addPageAndSetPosition'](pageList, 1, desktopLayoutInfo, layoutInfoCopied);
      expect(desktopLayoutInfo.layoutDescription.pageCount).assertLarger(1);
    });


    it('test_insertNewFormStackInfoCallBack', 0, async (done: Function) => {
      LauncherLayoutCacheUtil.setIsPadPortrait(true);
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      itemInfo.abilityName = 'TestAbility';
      itemInfo.folderId = 'id80287934523';
      itemInfo.folderName = 'folderName';
      itemInfo.page = 1;
      let gridlayoutItems: GridLayoutItemInfo[] = [itemInfo];
      let needInsertLayoutInfo: GridLayoutItemInfo[] = [];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.changeItemsIfPortrait);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(gridlayoutItems);
      try {
        await LauncherLayoutCacheUtil.insertNewFormStackInfoCallBackFun(itemInfo, gridlayoutItems, gridlayoutItems);
        LauncherLayoutCacheUtil.setIsPadPortrait(false);
        await LauncherLayoutCacheUtil.insertNewFormStackInfoCallBackFun(itemInfo, gridlayoutItems,
          needInsertLayoutInfo);
        expect(LauncherLayoutCacheUtil['isPadPortrait']).assertFalse();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clearAll();
      done();
    });

    it('test_updateLayoutInfo', 0, () => {
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.test.name';
      itemInfo.moduleName = 'test_module';
      let extraItemMap: HashMap<string, GridLayoutItemInfo> = new HashMap();
      let desktopLayoutInfo = new DefaultDesktopLayoutInfo();
      desktopLayoutInfo.layoutDescription = new LayoutDescription();
      desktopLayoutInfo.layoutDescription.row = 0;
      desktopLayoutInfo.layoutDescription.column = 0;
      desktopLayoutInfo.layoutDescription.maxPage = 1;
      desktopLayoutInfo.layoutDescription.pageCount = 1;
      desktopLayoutInfo.layoutInfo = [itemInfo];

      let gridLayoutItemInfo: GridLayoutItemInfo[] = [];
      LauncherLayoutCacheUtil['updateLayoutInfo'](desktopLayoutInfo, 0, gridLayoutItemInfo, extraItemMap);
      expect(gridLayoutItemInfo.length).assertLargerOrEqual(0);
    })


    it('test_updateIconPositionClockExclusive', 0, () => {
      let area = [4, 2];
      let column: number = 1;
      let row: number = 1;
      let list: ArrayList<GridLayoutItemInfo> = new ArrayList();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'com.ohos.totemweather';
      item.moduleName = 'moduleName';
      item.cardName ='ClockWeatherCard';
      item.page = 1;
      item.typeId = 1;
      item.area = [1, 1];
      list.add(item);
      let sortType = 'sortType';
      let extraItemMap: HashMap<string, GridLayoutItemInfo> = new HashMap();
      let ret = LauncherLayoutCacheUtil['updateIconPositionClockExclusive'](area, column, row, list, sortType, extraItemMap);
      expect(ret).assertTrue();
      sortType = 'regular';
      ret = LauncherLayoutCacheUtil['updateIconPositionClockExclusive'](undefined, column, row, list, sortType, extraItemMap);
      expect(ret).assertTrue();
    });

    it('test_updateIconPositionClockExclusive02', 0, () => {
      let area = [4, 2];
      let column: number = 1;
      let row: number = 1;
      let list: ArrayList<GridLayoutItemInfo> = new ArrayList();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'com.ohos.totemweather';
      item.moduleName = 'moduleName';
      item.cardName ='ClockWeatherCard';
      item.page = 1;
      item.typeId = 2;
      item.area = [1, 1];
      list.add(item);
      let sortType = 'sortType';
      let extraItemMap: HashMap<string, GridLayoutItemInfo> = new HashMap();
      let ret = LauncherLayoutCacheUtil['updateIconPositionClockExclusive'](area, column, row, list, sortType, extraItemMap);
      expect(ret).assertFalse();
      sortType = 'regular';
      ret = LauncherLayoutCacheUtil['updateIconPositionClockExclusive'](area, column, row, list, sortType, extraItemMap);
      expect(ret).assertFalse();
    });

    it('test_updateIconPosition', 0, () => {
      let column: number = 1;
      let row: number = 1;
      let list: ArrayList<GridLayoutItemInfo> = new ArrayList();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'com.ohos.totemweather';
      item.moduleName = 'moduleName';
      item.cardName ='ClockWeatherCard';
      item.page = 1;
      item.typeId = 2;
      item.area = [4, 4];
      list.add(item);
      let sortType = 'final';
      let extraItemMap: HashMap<string, GridLayoutItemInfo> = new HashMap();
      let ret = LauncherLayoutCacheUtil['updateIconPosition'](column, row, list, sortType, extraItemMap);
      expect(ret).assertFalse();
      sortType = 'sortType';
      ret = LauncherLayoutCacheUtil['updateIconPosition'](column, row, list, sortType, extraItemMap);
      expect(ret).assertFalse();
    });

    it('test_checkClockCardExistAndRowExclusive', 0, () => {
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.ohos.totemweather';
      itemInfo.moduleName = 'moduleName';
      itemInfo.cardName = 'ClockWeatherCard';
      itemInfo.page = 2;
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
      let item = getNullObject() as DefaultDesktopLayoutInfo;
      let ret = LauncherLayoutCacheUtil['checkClockCardExistAndRowExclusive'](item, 1);
      expect(ret).assertEqual(undefined);
      ret = LauncherLayoutCacheUtil['checkClockCardExistAndRowExclusive'](desktopLayoutInfo, 1);
      expect(ret).not().assertNull();
      itemInfo.cardName = 'ClockWeatherCard';
      desktopLayoutInfo.layoutInfo = [itemInfo];
      ret = LauncherLayoutCacheUtil['checkClockCardExistAndRowExclusive'](desktopLayoutInfo, 2);
      expect(ret).not().assertNull();
      itemInfo.typeId = 2;
      desktopLayoutInfo.layoutInfo = [itemInfo];
      ret = LauncherLayoutCacheUtil['checkClockCardExistAndRowExclusive'](desktopLayoutInfo, 1);
      expect(ret).assertEqual(undefined);
      itemInfo.typeId = 1;
      itemInfo.row = 1;
      desktopLayoutInfo.layoutInfo = [itemInfo];
      ret = LauncherLayoutCacheUtil['checkClockCardExistAndRowExclusive'](desktopLayoutInfo, 1);
      expect(ret).assertEqual(undefined);
    });

    it('test_padPortraitToLandscapeDown', 0, () => {
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
      LauncherLayoutCacheUtil['padPortraitToLandscapeDown'](desktopLayoutInfo, true, [0, 1]);
      desktopLayoutInfo.layoutDescription.row = 10;
      itemInfo.row = 5;
      LauncherLayoutCacheUtil['padPortraitToLandscapeDown'](desktopLayoutInfo, false, [0, 1]);
      LauncherLayoutCacheUtil['padPortraitToLandscapeDown'](desktopLayoutInfo, true, [0, 1]);
      expect(desktopLayoutInfo.layoutInfo[0].row).assertEqual(9);
      itemInfo.area = [-1, -1];
      itemInfo.row = 0;
      desktopLayoutInfo.layoutInfo = [itemInfo];
      LauncherLayoutCacheUtil['padPortraitToLandscapeDown'](desktopLayoutInfo, true, [0, 1]);
      LauncherLayoutCacheUtil['padPortraitToLandscapeDown'](desktopLayoutInfo, false, [0, 1]);
      expect(desktopLayoutInfo.layoutInfo[0].row).assertEqual(0);
    })

    it('test_addItemsFromLayoutCache', 0, () => {
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
      let list = [itemInfo]
      let extraItemMap: HashMap<string, GridLayoutItemInfo> = new HashMap();
      LauncherLayoutCacheUtil['addItemsFromLayoutCache'](desktopLayoutInfo, desktopLayoutInfo, 1, list, extraItemMap);
      expect(list.length).assertEqual(1);
      LauncherLayoutCacheUtil['addItemsFromLayoutCache'](desktopLayoutInfo, desktopLayoutInfo, 0, list, extraItemMap);
      expect(list.length).assertEqual(2);
    });

    it('test_getIsLazyRotate', 0, () => {
      LauncherLayoutCacheUtil.setIsLazyRotate(false);
      expect(LauncherLayoutCacheUtil.getIsLazyRotate()).assertFalse();
    });

    it('test_setIsLazyRotate', 0, () => {
      LauncherLayoutCacheUtil.setIsLazyRotate(true);
      expect(LauncherLayoutCacheUtil.getIsLazyRotate()).assertTrue();
    });

    it('test_getLazyRotateChangeItemsForCache', 0, () => {
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.row = 0;
      itemInfo.column = 0;
      itemInfo.page = 0;

      LauncherLayoutCacheUtil.setIsLazyRotate(true);
      LauncherLayoutCacheUtil.setIsDefaultPortrait(true);
      LauncherLayoutCacheUtil.setIsPadPortrait(true);
      const items: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.getLazyRotateChangeItemsForCache([itemInfo]);
      expect(items).not().assertNull();
    });

    it('test_findLazyRotatePosition', 0, () => {
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.row = 0;
      itemInfo.column = 0;
      itemInfo.page = 0;
      itemInfo.area = [1, 1];
      let info = new GridLayoutItemInfo();
      info.row = 0;
      info.column = 0;
      info.page = 0;
      info.area = [1, 1];

      LauncherLayoutCacheUtil.setIsLazyRotate(true);
      LauncherLayoutCacheUtil.setIsDefaultPortrait(true);
      LauncherLayoutCacheUtil.setIsPadPortrait(true);
      LauncherLayoutCacheUtil.findLazyRotatePosition([itemInfo], info);
      expect(info.row).assertInstanceOf('Number');
    });

    it('test_changeCachePortrait', 0, () => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const items: GridLayoutItemInfo[] = [itemInfo];
      itemInfo.row = 0;
      itemInfo.column = 0;
      itemInfo.page = 0;

      LauncherLayoutCacheUtil.setIsLazyRotate(true);
      LauncherLayoutCacheUtil.setIsDefaultPortrait(true);
      LauncherLayoutCacheUtil.setIsPadPortrait(true);
      LauncherLayoutCacheUtil.changeCachePortrait(items);
      expect(items).not().assertNull();
    });

    it('test_changeLazyRotateSettings', 0, () => {
      LauncherLayoutCacheUtil.setIsLazyRotate(true);
      LauncherLayoutCacheUtil.setIsDefaultPortrait(true);
      LauncherLayoutCacheUtil.setIsPadPortrait(false);
      LauncherLayoutCacheUtil.putIsFirstRotate(true);
      LauncherLayoutCacheUtil.changeLazyRotateSettings([]);
      expect(LauncherLayoutCacheUtil.getIsFirstRotate()).assertFalse();
    });

    it('test_findCardAnotherStatusPosition', 0, () => {
      const itemInfo = new GridLayoutItemInfo();
      itemInfo.row = 0;
      itemInfo.column = 0;
      itemInfo.page = 0;
      itemInfo.area = [1, 1];
      const cardInfo = new CardItemInfo();
      cardInfo.row = 0;
      cardInfo.column = 0;
      cardInfo.page = 0;
      LauncherLayoutCacheUtil.updateCardAnotherStatusPosition([itemInfo], cardInfo);
      LauncherLayoutCacheUtil.setIsLazyRotate(true);
      LauncherLayoutCacheUtil.updateCardAnotherStatusPosition([itemInfo], cardInfo);
      cardInfo.area = [2, 2];
      LauncherLayoutCacheUtil.updateCardAnotherStatusPosition([itemInfo], cardInfo);
      LauncherLayoutCacheUtil.setIsPadPortrait(true);
      LauncherLayoutCacheUtil.updateCardAnotherStatusPosition([itemInfo], cardInfo);
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_isOuterFormOutOfLayoutBound', 0, () => {
      const itemInfo = new GridLayoutItemInfo();
      itemInfo.row = 0;
      itemInfo.column = 0;
      itemInfo.page = 0;
      itemInfo.typeId = 1;
      itemInfo.area = [2, 4];
      expect(LauncherLayoutCacheUtil.isOuterFormOutOfLayoutBound(itemInfo, true)).assertFalse();
      expect(LauncherLayoutCacheUtil.isOuterFormOutOfLayoutBound(itemInfo, false)).assertFalse();
      itemInfo.area = [4, 5];
      expect(LauncherLayoutCacheUtil.isOuterFormOutOfLayoutBound(itemInfo, true)).assertTrue();
      expect(LauncherLayoutCacheUtil.isOuterFormOutOfLayoutBound(itemInfo, false)).assertFalse();
    });

    class TestDeleteItemType implements DeleteItemType {
      bundleName: string | undefined = undefined;
      keyName: string | undefined = undefined;
      abilityName?: string | undefined;
      moduleName?: string | undefined;
      folderId?: string | undefined;
      deleteByDockDrop?: boolean | undefined;
    }

    class TestGridArgs {
      gridColumn: number = 0;
      gridRow: number = 0;
    }

    class TestPosition {
      i: number = 0;
      j: number = 0;
    }
  })
}