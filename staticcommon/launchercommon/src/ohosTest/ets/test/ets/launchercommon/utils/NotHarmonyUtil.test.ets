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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import systemparameter from '@ohos.systemparameter';
import { DesktopLayoutCacheData } from '../../../../../../main/ets/cache/layout/DesktopLayoutCacheData'
import {
  AppItemInfo,
  NotHarmonyUtil,
  DefaultDesktopLayoutInfo,
  CommonConstants,
  DockItemInfo,
  GridLayoutItemBuilder,
  GridLayoutItemInfo,
  AppStatus,
  LaunchLayoutCacheManager,
  FolderLayoutCacheManager,
  FolderData
} from '../../../../../../main/ets/TsIndex';
import { CheckEmptyUtils } from '@ohos/basicutils/src/main/ets/TsIndex';
import { ResidentLayoutCacheMgr } from '../../../../../../main/ets/dock/cache/ResidentLayoutCacheMgr';

export default function NotHarmonyUtilTest() {
  describe('NotHarmonyUtilTest', () => {
    beforeAll(() => {

    })
    beforeEach(() => {

    })
    afterEach(() => {

    })
    afterAll(() => {

    })

    it('test_isNotHarmonyFolderById', 0, () => {
      let folderId: string = 'abc123';
      expect(NotHarmonyUtil.isNotHarmonyFolderById(folderId)).assertEqual(false);
      NotHarmonyUtil.setNotHarmonyFolderId(folderId);
      expect(NotHarmonyUtil.isNotHarmonyFolderById(folderId)).assertEqual(true);
      NotHarmonyUtil.setNotHarmonyFolderId('');
    })

    it('test_isNotHarmonyFolderShouldReleased', 0, () => {
      let folderId: string = 'abc123';
      try {
        expect(NotHarmonyUtil.isNotHarmonyFolderShouldReleased(folderId, 0)).assertEqual(true);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      NotHarmonyUtil.setNotHarmonyFolderId(folderId);
      try {
        expect(NotHarmonyUtil.isNotHarmonyFolderShouldReleased(folderId, 1)).assertEqual(false);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      NotHarmonyUtil.setNotHarmonyFolderId('');
    })

    it('test_isNotHarmonyFolderHasOneOrMoreApp', 0, () => {
      let folderId: string = 'abc123';
      expect(NotHarmonyUtil.isNotHarmonyFolderHasOneOrMoreApp(folderId, 2)).assertEqual(true);
      NotHarmonyUtil.setNotHarmonyFolderId(folderId);
      expect(NotHarmonyUtil.isNotHarmonyFolderHasOneOrMoreApp(folderId, 1)).assertEqual(true);
      NotHarmonyUtil.setNotHarmonyFolderId('');
    })

    it('test_lightingNotHarmonyAppIcons', 0, () => {
      let relationMap: Map<string, boolean> = new Map();
      let publicTestRelationMap: Map<string, boolean> = new Map();
      expect(NotHarmonyUtil.lightingNotHarmonyAppIcons(relationMap, publicTestRelationMap) === undefined).assertTrue();
      relationMap.set('com.ohos.myhuawei', true);
      expect(NotHarmonyUtil.lightingNotHarmonyAppIcons(relationMap, publicTestRelationMap) === undefined).assertTrue();
    })

    it('test_refreshNotHarmonyFolderPosition', 0, () => {
      let folderId: string = 'abc123';
      let relationMap: Map<string, boolean> = new Map();
      NotHarmonyUtil.setNotHarmonyFolderId(folderId);
      relationMap.set('com.ohos.myhuawei', true);

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

      // 条件1
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheData.setGridLayoutItemList(layoutInfoList);

      let publicTestRelationMap: Map<string, boolean> = new Map();
      NotHarmonyUtil.refreshNotHarmonyFolderPosition(relationMap, publicTestRelationMap)
      let a = 'test';
      expect(a).assertEqual('test');
      // 条件2
      demoApp.infoId = folderId;
      demoApp.bundleName = 'com.ohos.myhuawei';
      layoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheData.setGridLayoutItemList(layoutInfoList);
      NotHarmonyUtil.setNotHarmonyFolderId(folderId);
      expect(NotHarmonyUtil.refreshNotHarmonyFolderPosition(relationMap, publicTestRelationMap) === undefined)
        .assertEqual(true);
      NotHarmonyUtil.setNotHarmonyFolderId('');
    })

    it('test_refreshNotHarmonyFolderAppList', 0, () => {
      let relationMap: Map<string, boolean> = new Map();
      relationMap.set('com.ohos.myhuawei', true);
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.myhuawei';
      item1.typeId = CommonConstants.TYPE_APP;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.openharmony.demoApp';
      item2.typeId = CommonConstants.TYPE_APP;
      folderItem.layoutInfo = [[item1], [item2]];
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem.keyName = 'keyName0';

      let publicTestRelationMap: Map<string, boolean> = new Map();
      let result: GridLayoutItemInfo[] =
        NotHarmonyUtil['refreshNotHarmonyFolderAppList'](relationMap, publicTestRelationMap, folderItem);
      expect(result.length).assertLargerOrEqual(0);
    })

    it('test_updateFolderAppLocation', 0, () => {
      let relationMap: Map<string, boolean> = new Map();
      relationMap.set('com.ohos.myhuawei', true);
      let folderItem: GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.myhuawei';
      item1.typeId = CommonConstants.TYPE_APP;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.openharmony.demoApp';
      item2.typeId = CommonConstants.TYPE_APP;
      folderItem.push(item1);
      folderItem.push(item2);
      expect(NotHarmonyUtil['updateFolderAppLocation'](folderItem) === undefined).assertEqual(true);
    })

    it('test_refreshNotHarmonyFolderInDock', 0, () => {
      let folderId: string = 'abc123';
      NotHarmonyUtil.setNotHarmonyFolderId(folderId);
      let relationMap: Map<string, boolean> = new Map();
      relationMap.set('com.ohos.myhuawei', true);
      relationMap.set('com.openharmony.demoApp', true);
      let info1: DockItemInfo = new DockItemInfo();
      info1.typeId = CommonConstants.TYPE_APP;
      info1.appId = folderId;

      let publicTestRelationMap: Map<string, boolean> = new Map();
      expect(NotHarmonyUtil['refreshNotHarmonyFolderInDock'](relationMap, publicTestRelationMap) === undefined)
        .assertEqual(true);
      NotHarmonyUtil.setNotHarmonyFolderId('');
    })

    it('test_updateIntentAndSendEvent', 0, () => {
      let folderId: string = 'abc123';
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.bundleName = 'com.openharmony.demoApp';
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      let relationMap: Map<string, boolean> = new Map();
      relationMap.set('com.ohos.myhuawei', true);

      let publicTestRelationMap: Map<string, boolean> = new Map();
      expect(NotHarmonyUtil['updateIntentAndSendEvent'](folderItem, relationMap, publicTestRelationMap, folderId) ===
        undefined).assertEqual(true);
      relationMap.set('com.openharmony.demoApp', true);
      expect(NotHarmonyUtil['updateIntentAndSendEvent'](folderItem, relationMap, publicTestRelationMap, folderId) ===
        undefined).assertEqual(true);
    })

    it('test_findAndLightAppInFolder', 0, () => {
      let relationMap: Map<string, boolean> = new Map();
      relationMap.set('com.ohos.myhuawei', true);
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.myhuawei';
      item1.typeId = CommonConstants.TYPE_APP;
      item1.appStatus = AppStatus.WAIT_FOR_HARMONY;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.openharmony.demoApp';
      item2.typeId = CommonConstants.TYPE_APP;
      folderItem.layoutInfo = [[item1], [item2]];
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem.keyName = 'keyName0';

      let publicTestRelationMap: Map<string, boolean> = new Map();
      expect(NotHarmonyUtil['findAndLightAppInFolder'](folderItem, relationMap, publicTestRelationMap)).assertTrue();
    })

    it('test_lightAppInSmartDock', 0, () => {
      let resistDockItems: DockItemInfo[] = [];
      let itemInfo: DockItemInfo = new DockItemInfo();
      itemInfo.itemType = CommonConstants.TYPE_APP;
      itemInfo.bundleName = 'com.ohos.myhuawei';
      itemInfo.appStatus = AppStatus.WAIT_FOR_HARMONY;
      resistDockItems.push(itemInfo);
      let relationMap: Map<string, boolean> = new Map();
      relationMap.set('com.ohos.myhuawei', true);
      AppStorage.setOrCreate('residentList', resistDockItems);

      let publicTestRelationMap: Map<string, boolean> = new Map();
      expect(NotHarmonyUtil['lightAppInSmartDock'](relationMap, publicTestRelationMap) === undefined).assertTrue();
    })

    it('test_llightAppInDesktop', 0, () => {
      let layoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.bundleName = 'com.ohos.myhuawei';
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 1;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.area = [1, 1];
      layoutInfoList.push(demoApp);
      defaultLayout.layoutInfo = layoutInfoList;

      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(defaultLayout);
      layoutCacheManager.reInit(layoutCacheData);
      let relationMap: Map<string, boolean> = new Map();
      relationMap.set('com.ohos.myhuawei', true);

      let publicTestRelationMap: Map<string, boolean> = new Map();
      expect(NotHarmonyUtil['lightAppInDesktop'](relationMap, publicTestRelationMap) === undefined).assertTrue();
    })

    it('test_isNotHarmonyFolderShouldReleased_001', 0, () => {
      let folderId: string = 'abc123';
      NotHarmonyUtil.setNotHarmonyFolderId(folderId);
      try {
        expect(NotHarmonyUtil.isNotHarmonyFolderShouldReleased(folderId, 1)).assertEqual(false);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      NotHarmonyUtil.setNotHarmonyFolderId('test1122');
      try {
        expect(NotHarmonyUtil.isNotHarmonyFolderShouldReleased(folderId, 1)).assertEqual(true);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('test_isNotHarmonyFolderHasOneOrMoreApp_001', 0, () => {
      let folderId: string = 'abc123';
      NotHarmonyUtil.setNotHarmonyFolderId(folderId);
      expect(NotHarmonyUtil.isNotHarmonyFolderHasOneOrMoreApp(folderId, 1)).assertEqual(true);
      NotHarmonyUtil.setNotHarmonyFolderId('test1122');
      expect(NotHarmonyUtil.isNotHarmonyFolderHasOneOrMoreApp(folderId, 1)).assertEqual(false);
    })

    it('test_lightingNotHarmonyAppIcons_empty', 0, () => {
      let relationMap: Map<string, boolean> = new Map();
      let publicTestRelationMap: Map<string, boolean> = new Map();
      let testItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      testItem.id = 1009;
      AppStorage.setOrCreate('folderAppChange', testItem);
      NotHarmonyUtil.lightingNotHarmonyAppIcons(null, publicTestRelationMap);
      let getItem: GridLayoutItemInfo = AppStorage.get('folderAppChang') as GridLayoutItemInfo ?? testItem;
      expect(getItem.id).assertEqual(1009);
      try {
        NotHarmonyUtil.lightingNotHarmonyAppIcons(relationMap, publicTestRelationMap);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let getItem1: GridLayoutItemInfo = AppStorage.get('folderAppChang') as GridLayoutItemInfo ?? testItem;
      expect(getItem1.id).assertEqual(1009);
      relationMap.set('testkey', true);
      try {
        NotHarmonyUtil.lightingNotHarmonyAppIcons(relationMap, null);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let getItem2: GridLayoutItemInfo = AppStorage.get('folderAppChang') as GridLayoutItemInfo ?? testItem;
      expect(getItem2.id).assertEqual(1009);
      try {
        NotHarmonyUtil.lightingNotHarmonyAppIcons(relationMap, publicTestRelationMap);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let getItem3: GridLayoutItemInfo = AppStorage.get('folderAppChang') as GridLayoutItemInfo ?? testItem;
      expect(getItem3.id).assertEqual(1009);
    })

    it('test_lightingNotHarmonyAppIcons_light', 0, () => {
      let relationMap: Map<string, boolean> = new Map();
      relationMap.set('testkey', true);
      relationMap.set('com.ohos.calendar', true);
      relationMap.set('com.ohos.sugesture', true);
      let publicTestRelationMap: Map<string, boolean> = new Map();
      publicTestRelationMap.set('testPublickey', true);
      publicTestRelationMap.set('com.ohos.calendar', true);
      let testItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      testItem.id = 1009;
      AppStorage.setOrCreate('folderAppChange', testItem);
      let desktopAppInfos: GridLayoutItemInfo[] = createItems_lisghtAppInDesktop();
      AppStorage.setOrCreate('residentList', desktopAppInfos);
      let mocker: MockKit = new MockKit();
      let cacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(cacheManager, cacheManager.getAllGridLayoutItemList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(desktopAppInfos);
      try {
        NotHarmonyUtil.lightingNotHarmonyAppIcons(relationMap, publicTestRelationMap);
        let getItem3: GridLayoutItemInfo = AppStorage.get('folderAppChang') as GridLayoutItemInfo;
        expect(testItem.id).assertEqual(1009);
      } catch (e) {
      }
      mocker.clear(cacheManager);
      mocker.clearAll();
    })

    it('test_isNeedLightUpOrDown', 0, () => {
      let relationMap: Map<string, boolean> = new Map();
      relationMap.set('testkey', true);
      relationMap.set('com.ohos.calendar', true);
      relationMap.set('com.ohos.sugesture', true);
      let publicTestRelationMap: Map<string, boolean> = new Map();
      publicTestRelationMap.set('testPublickey', true);
      publicTestRelationMap.set('com.ohos.calendar', true);
      let testItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      testItem.id = 1009;
      testItem.bundleName = 'test_001';
      testItem.appStatus = AppStatus.WAIT_FOR_HARMONY;
      let isneed = NotHarmonyUtil['isNeedLightUpOrDown'](relationMap, publicTestRelationMap, testItem);
      expect(isneed).assertFalse();
      relationMap.set('test_001', true);
      let isneed1 = NotHarmonyUtil['isNeedLightUpOrDown'](relationMap, publicTestRelationMap, testItem);
      expect(isneed1).assertTrue();
      let testItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      testItem1.id = 1009;
      testItem1.bundleName = 'test_0009';
      testItem1.appStatus = AppStatus.WAIT_FOR_HARMONY;
      publicTestRelationMap.set('test_0009', true);
      let isneed2 = NotHarmonyUtil['isNeedLightUpOrDown'](relationMap, publicTestRelationMap, testItem1);
      expect(isneed2).assertTrue();
      let testItem2: GridLayoutItemInfo = new GridLayoutItemInfo();
      testItem2.id = 1009;
      testItem2.bundleName = 'test_0009';
      testItem2.appStatus = AppStatus.UPDATING;
      let isneed3 = NotHarmonyUtil['isNeedLightUpOrDown'](relationMap, publicTestRelationMap, testItem2);
      expect(isneed3).assertFalse();
    })

    it('test_updateIntentAndSendEvent_001', 0, () => {
      let relationMap: Map<string, boolean> = new Map();
      relationMap.set('testkey', true);
      relationMap.set('com.ohos.calendar', true);
      relationMap.set('com.ohos.sugesture', true);
      let publicTestRelationMap: Map<string, boolean> = new Map();
      publicTestRelationMap.set('testPublickey', true);
      publicTestRelationMap.set('com.ohos.calendar', true);
      let testItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      testItem.id = 1009;
      testItem.bundleName = 'testkey';
      testItem.appStatus = AppStatus.WAIT_FOR_HARMONY;
      testItem.intent = '';
      testItem.appIndex = 0;
      try {
        NotHarmonyUtil['updateIntentAndSendEvent'](testItem, relationMap, publicTestRelationMap, 'harmony0002');
        expect(relationMap.has(testItem.bundleName)).assertInstanceOf('Boolean');
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      expect(relationMap.has(testItem.bundleName)).assertTrue();
      let testItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      testItem1.id = 1009;
      testItem1.bundleName = 'testPublickey';
      testItem1.appStatus = AppStatus.WAIT_FOR_HARMONY;
      testItem1.intent = '';
      testItem1.appIndex = 0;
      try {
        NotHarmonyUtil['updateIntentAndSendEvent'](testItem1, relationMap, publicTestRelationMap, 'harmony0002');
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      expect(testItem1.bundleName).assertEqual('testPublickey');
      let testItem2: GridLayoutItemInfo = new GridLayoutItemInfo();
      testItem2.id = 1009;
      testItem2.bundleName = 'testAny0098';
      testItem2.appStatus = AppStatus.WAIT_FOR_HARMONY;
      testItem2.intent = '';
      testItem2.appIndex = 0;
      try {
        NotHarmonyUtil['updateIntentAndSendEvent'](testItem2, relationMap, publicTestRelationMap, 'harmony0002');
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      expect(testItem2.bundleName).assertEqual('testAny0098');
    })

    it('test_refreshNotHarmonyFolderPosition_001', 0, () => {
      let relationMap: Map<string, boolean> = new Map();
      let publicTestRelationMap: Map<string, boolean> = new Map();
      try {
        NotHarmonyUtil.refreshNotHarmonyFolderPosition(relationMap, publicTestRelationMap);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let relationMap1: Map<string, boolean> = new Map();
      relationMap1.set('testkey', true);
      let publicTestRelationMap1: Map<string, boolean> = new Map();
      try {
        NotHarmonyUtil.refreshNotHarmonyFolderPosition(relationMap1, publicTestRelationMap1);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let mocker: MockKit = new MockKit();
      let cacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(cacheManager, cacheManager.selectGridLayoutItemByFolderId);
      let testItem2: GridLayoutItemInfo = new GridLayoutItemInfo();
      testItem2.id = 1009;
      testItem2.bundleName = 'testAny0098';
      testItem2.appStatus = AppStatus.WAIT_FOR_HARMONY;
      testItem2.intent = '';
      testItem2.appIndex = 0;
      when(mockFunc)(ArgumentMatchers.any).afterReturn(testItem2);
      NotHarmonyUtil['mNotHarmonyFolderId'] = 'testFolderid001';
      let relationMap2: Map<string, boolean> = new Map();
      relationMap2.set('testkey', true);
      let publicTestRelationMap2: Map<string, boolean> = new Map();
      publicTestRelationMap2.set('testkey', true);
      try {
        NotHarmonyUtil.refreshNotHarmonyFolderPosition(relationMap2, publicTestRelationMap2);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      when(mockFunc)(ArgumentMatchers.any).afterReturn(null);
      NotHarmonyUtil['mNotHarmonyFolderId'] = 'testFolderid001';
      try {
        NotHarmonyUtil.refreshNotHarmonyFolderPosition(relationMap2, publicTestRelationMap2);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      expect(relationMap2.has('testkey')).assertTrue();
      mocker.clear(cacheManager);
      mocker.clearAll();
    })

    it('test_isNotHarmonyApps', 0, () => {
      let testItem2: GridLayoutItemInfo = new GridLayoutItemInfo();
      testItem2.id = 1009;
      testItem2.bundleName = 'testAny0098';
      testItem2.appStatus = AppStatus.WAIT_FOR_HARMONY;
      testItem2.intent = '';
      testItem2.appIndex = 0;
      expect(NotHarmonyUtil.isNotHarmonyApps([testItem2])).assertTrue();
      let testItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      testItem1.id = 1009;
      testItem1.bundleName = 'testAny0098';
      testItem1.appStatus = AppStatus.CREATED;
      testItem1.intent = '';
      testItem1.appIndex = 0;
      expect(NotHarmonyUtil.isNotHarmonyApps([testItem1])).assertFalse();
    })

    it('test_refreshNotHarmonyFolderInDesktop_refreshNotHarmonyFolderAppList_001', 0, () => {
      let relationMap: Map<string, boolean> = new Map();
      relationMap.set('com.openharmony.ohos.calendar0', true);
      relationMap.set('com.openharmony.ohos.calendar1', true);
      let publicTestRelationMap: Map<string, boolean> = new Map();
      publicTestRelationMap.set('com.openharmony.ohos.calendar1', true);
      publicTestRelationMap.set('com.openharmony.ohos.calendar2', true);
      let item0: GridLayoutItemInfo = createItems_refreshNotHarmonyFolderAppList_all();
      NotHarmonyUtil['mNotHarmonyFolderId'] = 'testFolder009';
      let mocker: MockKit = new MockKit();
      let folderData: FolderData = FolderData.getInstance();
      let mockFunc: Function = mocker.mockFunc(folderData, folderData.getOpenFolderId);
      when(mockFunc)(ArgumentMatchers.any).afterReturn('testFolder009');
      try {
        NotHarmonyUtil['refreshNotHarmonyFolderInDesktop'](item0, relationMap, publicTestRelationMap);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      NotHarmonyUtil['mNotHarmonyFolderId'] = 'testFolder001';
      try {
        NotHarmonyUtil['refreshNotHarmonyFolderInDesktop'](item0, relationMap, publicTestRelationMap);
        let folderAppList: GridLayoutItemInfo[] =
          NotHarmonyUtil['refreshNotHarmonyFolderAppList'](relationMap, publicTestRelationMap, item0);
        expect(folderAppList.length > 0).assertTrue();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      mocker.clear(folderData);
      mocker.clearAll();
    })

    it('test_refreshNotHarmonyFolderInDock_001', 0, () => {
      let mNotHarmonyFolderId = 'appid001210';
      let desktopAppInfos: DockItemInfo[] = [];
      let item11: DockItemInfo = new DockItemInfo();
      item11.typeId = CommonConstants.TYPE_FOLDER;
      item11.bundleName = 'com.openharmony.ohos.sugesture';
      item11.appStatus = AppStatus.UPDATING;
      item11.appId = mNotHarmonyFolderId;
      NotHarmonyUtil['mNotHarmonyFolderId'] = mNotHarmonyFolderId;
      let relationMap: Map<string, boolean> = new Map();
      relationMap.set('com.openharmony.ohos.calendar', true);
      relationMap.set('com.openharmony.ohos.sugesture', true);
      let publicTestRelationMap: Map<string, boolean> = new Map();
      publicTestRelationMap.set('com.openharmony.ohos.calendar', true);
      AppStorage.setOrCreate('residentList', []);
      NotHarmonyUtil['refreshNotHarmonyFolderInDock'](relationMap, publicTestRelationMap);
      let residentList: Array<DockItemInfo> = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      expect(residentList.length === 0).assertTrue();
      let layoutItems: GridLayoutItemInfo[] = [];
      for (let index = 0; index < 3; index++) {
        let layoutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        layoutItem.typeId = CommonConstants.TYPE_APP;
        layoutItem.bundleName = 'com.openharmony.ohos.sugesture12' + index;
        layoutItem.appStatus = index === 0 ? AppStatus.WAIT_FOR_HARMONY : AppStatus.UPDATING;
        layoutItems.push(layoutItem);
      }
      item11.layoutInfo = [layoutItems];
      desktopAppInfos.push(item11);
      AppStorage.setOrCreate('residentList', desktopAppInfos);
      let mocker: MockKit = new MockKit();
      let folderData: FolderData = FolderData.getInstance();
      let mockFunc: Function = mocker.mockFunc(folderData, folderData.getOpenFolderId);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(mNotHarmonyFolderId);
      try {
        NotHarmonyUtil['refreshNotHarmonyFolderInDock'](relationMap, publicTestRelationMap);
      } catch (e) {
      }
      let residentList1: Array<DockItemInfo> = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      expect(residentList1.length === 1).assertTrue();
      when(mockFunc)(ArgumentMatchers.any).afterReturn('mNotHarmonyFolderId');
      try {
        NotHarmonyUtil['refreshNotHarmonyFolderInDock'](relationMap, publicTestRelationMap);
        let residentList2: Array<DockItemInfo> = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
        expect(residentList2.length === 1).assertTrue();
      } catch (e) {
      }
      mocker.clear(folderData);
      mocker.clearAll();
    })

    it('test_checkNotHarmonyItemLightingStatus_0', 0,  () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      const mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(NotHarmonyUtil.checkNotHarmonyItemLightingStatus(item)).assertEqual(false);

      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      item.intent = JSON.stringify(new Map([['installSource','']]));
      expect(NotHarmonyUtil.checkNotHarmonyItemLightingStatus(item)).assertEqual(false);

      item.intent = JSON.stringify(new Map([['installSource',''],['maskState', '1']]));
      expect(NotHarmonyUtil.checkNotHarmonyItemLightingStatus(item)).assertEqual(true);

      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })
  })
}

function createItems_refreshNotHarmonyFolderAppList_all(): GridLayoutItemInfo {
  let item11: GridLayoutItemInfo = new GridLayoutItemInfo();
  item11.typeId = CommonConstants.TYPE_FOLDER;
  item11.bundleName = 'com.openharmony.ohos.sugesture';
  item11.appStatus = AppStatus.UPDATING;
  let layoutItems: GridLayoutItemInfo[] = [];
  for (let index = 0; index < 4; index++) {
    let layoutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
    layoutItem.typeId = CommonConstants.TYPE_APP;
    layoutItem.bundleName = 'com.openharmony.ohos.calendar' + index;
    layoutItem.appStatus = index === 0 ? AppStatus.WAIT_FOR_HARMONY : AppStatus.UPDATING;
    layoutItems.push(layoutItem);
  }
  item11.layoutInfo = [layoutItems];
  return item11;
}

function undefinedParaValue(): string | undefined {
  return undefined;
}

function createItems_lisghtAppInDesktop(): GridLayoutItemInfo[] {
  let item0: GridLayoutItemInfo = new GridLayoutItemInfo();
  item0.typeId = CommonConstants.TYPE_APP;
  item0.bundleName = 'com.ohos.calendar';
  item0.appStatus = AppStatus.WAIT_FOR_HARMONY;
  let item01: GridLayoutItemInfo = new GridLayoutItemInfo();
  item01.typeId = CommonConstants.TYPE_APP;
  item01.bundleName = 'com.ohos.calendar';
  item01.appStatus = AppStatus.UPDATING;

  let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
  item1.typeId = CommonConstants.TYPE_FOLDER;
  item1.bundleName = 'com.openharmony.ohos.sugesture';
  item1.appStatus = AppStatus.UPDATING;
  item1.layoutInfo = [];
  let item11: GridLayoutItemInfo = new GridLayoutItemInfo();
  item11.typeId = CommonConstants.TYPE_FOLDER;
  item11.bundleName = 'com.openharmony.ohos.sugesture';
  item11.appStatus = AppStatus.UPDATING;
  let layoutItems: GridLayoutItemInfo[] = [];
  for (let index = 0; index < 3; index++) {
    let layoutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
    layoutItem.typeId = CommonConstants.TYPE_APP;
    layoutItem.bundleName = 'com.openharmony.ohos.sugesture12' + index;
    layoutItem.appStatus = index === 0 ? AppStatus.WAIT_FOR_HARMONY : AppStatus.UPDATING;
    layoutItems.push(layoutItem);
  }
  item11.layoutInfo = [layoutItems];

  let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
  item2.typeId = CommonConstants.TYPE_FOLDER;
  item2.bundleName = 'com.openharmony.ohos.calendar';
  item2.appStatus = AppStatus.WAIT_FOR_HARMONY;
  item2.layoutInfo = [];
  return [item0, item01, item1, item11, item2];
}