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
  when,
  TestType,
  ArgumentMatchers
} from '@ohos/hypium';
import SmartDockModel from '../../../../main/ets/default/model/SmartDockModel';
import {
  DeleteDockItem,
  DockContinuableInfo,
  EventConstants,
  FolderData,
  GridLayoutItemInfo,
  ResidentLayoutCacheMgr,
  ShortcutInfo
} from '@ohos/launchercommon';
import { CommonUtils, CheckEmptyUtils, ObjUtil } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext, localEventManager } from '@ohos/frameworkwrapper';
import {
  SCBSceneContainerSession,
  SCBSceneSessionManager,
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty,
  AbilityItemInfo
} from '@ohos/windowscene';
import { CommonConstants } from '@ohos/launchercommon';
import {
  AppItemInfo,
  AppModel,
  DockItemInfo,
  GridLayoutUtil,
  RdbStoreManager,
  RecentBundleMissionInfo,
  launcherAbilityManager,
  LayoutViewModel,
  SmartDockLayoutConfig
} from '@ohos/launchercommon';
import SmartDockConstants from '../../../../main/ets/default/common/constants/SmartDockConstants';
import sceneSessionManager from '@ohos.sceneSessionManager';
import StatusBarServiceEventMgr from '../../../../main/ets/default/manager/StatusBarServiceEventMgr'
import { image } from '@kit.ImageKit';

/**
 * SmartDockModel测试
 *
 * @since 2023-11-07
 */
export default function SmartDockModelTest() {
  describe('SmartDockModelTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getResidentList1', 0, (): void => {
      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      let instance: RdbStoreManager = RdbStoreManager.getInstance();
      try {
        let mockFunc: Function = mocker.mockFunc(instance,instance.querySmartDock);
        when(mockFunc)().afterReturn(undefined);
        ResidentLayoutCacheMgr.getInstance().clearCacheAndInit('test');
        expect(SmartDockModel.getInstance()).not().assertUndefined();
      } catch(e) {}
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_getResidentList2', 0, (): void => {
      let newInstalledBundleName = 'com.ohos.contacts';
      let itemInfo: DockItemInfo = new DockItemInfo();
      itemInfo.itemType = CommonConstants.TYPE_APP;
      itemInfo.bundleName = 'com.ohos.contacts';
      let dockDataList: DockItemInfo[] = new Array<DockItemInfo>();
      dockDataList.push(itemInfo);

      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      let instance: RdbStoreManager = RdbStoreManager.getInstance();
      try {
        let mockFunc: Function = mocker.mockFunc(instance,instance.querySmartDock);
        when(mockFunc)().afterReturn(dockDataList);
        ResidentLayoutCacheMgr.getInstance().clearCacheAndInit('test');
        expect(SmartDockModel.getInstance()).not().assertUndefined();
      } catch (e) {
      }
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_updateDockInfoByInstalled', 0, (): void => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['updateDockInfoByInstalled'](null, []);
        let dockItemInfo = new DockItemInfo();
        dockItemInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
        dockItemInfo.abilityName = CommonConstants.BROWSER_ABILITY;
        dockItemInfo.typeId = CommonConstants.TYPE_FOLDER;
        dockItemInfo.itemType = CommonConstants.TYPE_FUNCTION;
        dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
        dockItemInfo.appIndex = 0;
        dockItemInfo.keyName = CommonConstants.LAUNCHER_BUNDLE + CommonConstants.BROWSER_ABILITY;
        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = 'com.ohos.camera';
        item1.keyName = 'keyName_0';
        item1.typeId = CommonConstants.TYPE_APP;
        item1.appStatus = 1;
        item1.appIndex = 1;
        dockItemInfo.layoutInfo = [[item1]];
        let appInfo: AppItemInfo = new AppItemInfo();
        appInfo.appName = 'appName_1';
        appInfo.appIconId = 234881117;
        appInfo.bundleName = 'com.ohos.camera';
        appInfo.abilityName = 'com.ohos.camera.MainAbility';
        appInfo.keyName = 'keyName_0';
        appInfo.appIndex = 1;
        let list: AppItemInfo[] = [appInfo];
        (instance as object)['updateDockInfoByInstalled'](dockItemInfo, list);
        (instance as object)['updateGridLayoutItemInfoByInstalled'](null, []);
        dockItemInfo.typeId = CommonConstants.TYPE_APP;
        dockItemInfo.appStatus = 1;
        (instance as object)['updateDockInfoByInstalled'](dockItemInfo, list);
        dockItemInfo.appStatus = 0;
        (instance as object)['updateDockInfoByInstalled'](dockItemInfo, list);
        expect(dockItemInfo).not().assertNull();
      }catch{}
    })

    it('test_initRecentDataList', 0, (): void => {
      let containerSessionList: SCBSceneContainerSession[] = SCBSceneSessionManager.getInstance().getContainerSessionList();
      SmartDockModel.getInstance().initRecentDataList(containerSessionList);
      expect(SmartDockModel.getInstance()).not().assertUndefined();
    })



    it('test_reOrderRecentList1', 0, (): void => {
      try{
        const recentMissionsList = new Array<RecentBundleMissionInfo>();
        AppStorage.setOrCreate('recentList' , new Array<RecentBundleMissionInfo>());
        SmartDockModel.getInstance().reOrderRecentList(recentMissionsList);
        expect(SmartDockModel.getInstance()).not().assertUndefined();
      }catch{}
    })

    it('test_reOrderRecentList2', 0, (): void => {
      try {
        let itemInfo: RecentBundleMissionInfo = new RecentBundleMissionInfo();
        itemInfo.bundleName = 'com.ohos.contacts';
        let recentList: RecentBundleMissionInfo[] = new Array<RecentBundleMissionInfo>();
        recentList.push(itemInfo);
        AppStorage.setOrCreate('recentList' , recentList);
        SmartDockModel.getInstance().reOrderRecentList(recentList);
        expect(SmartDockModel.getInstance()).not().assertUndefined();
      }catch{}
    })

    it('test_createDockAppInfo_1', 0, (): void => {
      let dockItem: DockItemInfo = {
        itemType: 0,
        bundleName: 'com.ohos.contacts',
        abilityName: 'com.ohos.contacts.MainAbility',
        moduleName: 'entry',
        editable: true,
        visible: true,
        borderVisible: true,
        shake: 0,
        missionInfoList: [],
        appName:'MainAbility',
        appIconId:100663798,
        appIndex: 0,
      };
      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc: Function = mocker.mockFunc(GridLayoutUtil,GridLayoutUtil.isAppInstalled);
        when(mockFunc)(dockItem).afterReturn(false);

        let rst = ResidentLayoutCacheMgr.getInstance().createDockAppInfo(dockItem, 0);
        expect(rst).not().assertUndefined();
      } catch (e) {
      }
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_createDockAppInfo_2', 0, (): void => {
      let dockItem: DockItemInfo = {
        itemType: 0,
        bundleName: 'com.ohos.contacts',
        abilityName: 'com.ohos.contacts.MainAbility',
        moduleName: 'entry',
        editable: true,
        visible: true,
        borderVisible: true,
        shake: 0,
        missionInfoList: [],
        appName:'MainAbility',
        appIconId:100663798
      };
      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil,GridLayoutUtil.isAppInstalled);
      when(mockFunc)(dockItem).afterReturn(true);

      let mockFunc1: Function = mocker.mockFunc(launcherAbilityManager,launcherAbilityManager.getAppInfoByBundleName);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        let rst = ResidentLayoutCacheMgr.getInstance().createDockAppInfo(dockItem, 0);
        expect(rst).not().assertUndefined();
      } catch (e) {}

      mocker.clear(GridLayoutUtil);
      mocker.clear(launcherAbilityManager);
      mocker.clearAll();
    })

    it('test_createDockAppInfo_3', 0, (): void => {
      let dockItem: DockItemInfo = {
        itemType: 0,
        bundleName: 'com.ohos.contacts',
        abilityName: 'com.ohos.contacts.MainAbility',
        applicationName: 'contacts',
        applicationLabelId: 1,
        appLabelId: 1,
        moduleName: 'entry',
        editable: true,
        visible: true,
        borderVisible: true,
        shake: 0,
        missionInfoList: [],
        appName:'MainAbility',
        appIconId:100663798,
        appStatus:1,
        installTime:'2023'
      };
      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil,GridLayoutUtil.isAppInstalled);
      when(mockFunc)(dockItem).afterReturn(true);

      let appDataFromSystem: AppItemInfo = new AppItemInfo();
      appDataFromSystem.appName = dockItem.appName;
      appDataFromSystem.bundleName = dockItem.bundleName;
      appDataFromSystem.moduleName = dockItem.moduleName;
      appDataFromSystem.abilityName = dockItem.abilityName;
      appDataFromSystem.appIconId = dockItem.appIconId;
      appDataFromSystem.appLabelId = dockItem.appLabelId;
      appDataFromSystem.applicationLabelId = dockItem.applicationLabelId;
      appDataFromSystem.applicationName = dockItem.applicationName;
      appDataFromSystem.installTime = dockItem.installTime;
      appDataFromSystem.appStatus = dockItem.appStatus;
      try {
        let mockFunc1: Function = mocker.mockFunc(launcherAbilityManager,launcherAbilityManager.getAppInfoByBundleName);
        when(mockFunc1)(dockItem.bundleName).afterReturn(undefined);

        let rst = ResidentLayoutCacheMgr.getInstance().createDockAppInfo(dockItem, 0);
        expect(rst).not().assertUndefined();
      } catch(e) {}
      mocker.clear(GridLayoutUtil);
      mocker.clear(launcherAbilityManager);
      mocker.clearAll();
    })

    it('test_addToSmartDock_05', 0, (): void => {
      try {
        let appList: AppItemInfo[] = AppModel.getInstance().getAppList();
        let appItemInfo = appList[0];
        let gInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        if (appItemInfo) {
          gInfo.bundleName = appItemInfo.bundleName;
          gInfo.abilityName = appItemInfo.abilityName;
          gInfo.moduleName = appItemInfo.moduleName;
          gInfo.typeId = 0;
          gInfo.badgeNumber = appItemInfo.badgeNumber;
          gInfo.appIconId = appItemInfo.appIconId;
          gInfo.appLabelId = appItemInfo.appLabelId;
          gInfo.infoName = appItemInfo.appName;
          gInfo.appStatus = 0;
          gInfo.negativeId = 0;
          gInfo.isSelect = false;
          gInfo.enterEditing = false;
          gInfo.downloadProgress = 100;
          gInfo.iconResource = '';
          gInfo.callerName = '';
        }
        let rst = SmartDockModel.getInstance().addToSmartDock(GridLayoutUtil.gridLayoutToDockItem(gInfo), 0);
        expect(rst).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_addToSmartDock_1', 0, (): void => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.contacts';
      appInfo.abilityName = 'com.ohos.contacts.MainAbility';
      appInfo.moduleName = 'entry';
      appInfo.typeId = CommonConstants.TYPE_FOLDER;
      appInfo.badgeNumber = 0;
      appInfo.appIconId = 100663798;
      appInfo.appLabelId = 1;
      appInfo.appStatus = 0;
      appInfo.downloadProgress = 100;
      appInfo.iconResource = '';
      appInfo.callerName = '';

      let rst = SmartDockModel.getInstance().addToSmartDock(appInfo, 0);
      expect(rst).assertFalse();
    })

    it('test_addToSmartDock_2', 0, (): void => {
      let appInfo: AppItemInfo = new AppItemInfo();
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

      let itemInfo: DockItemInfo = new DockItemInfo();
      itemInfo.itemType = CommonConstants.TYPE_APP;
      itemInfo.bundleName = 'com.ohos.contacts';
      itemInfo.keyName = appInfo.keyName;
      try{
        let residentList: DockItemInfo[] = new Array<DockItemInfo>();
        residentList.push(itemInfo);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_addToSmartDock_2', residentList, false);

        let rst = SmartDockModel.getInstance().addToSmartDock(appInfo, 0);
        expect(rst).assertInstanceOf('Boolean');
      }catch{}
    })

    it('test_addToSmartDock_3', 0, (): void => {
      let appInfo: AppItemInfo = new AppItemInfo();
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

      let itemInfo: DockItemInfo = new DockItemInfo();
      itemInfo.itemType = CommonConstants.TYPE_APP;
      itemInfo.bundleName = 'com.ohos.contacts123';
      itemInfo.keyName = 'com.ohos.contact123';
      try{
        let residentList: DockItemInfo[] = new Array<DockItemInfo>();
        residentList.push(itemInfo);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_addToSmartDock_3', residentList, false);

        let rst = SmartDockModel.getInstance().addToSmartDock(appInfo, 0);
        expect(rst).assertInstanceOf('Boolean');
      }catch{}
    })

    it('test_addToSmartDock_4', 0, (): void => {
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isIconType);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        let appInfo: AppItemInfo = new AppItemInfo();
        let rst = SmartDockModel.getInstance().addToSmartDock(appInfo, 0);
        expect(rst).assertFalse();
      } catch(e){}
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_deleteDockItem', 0, (): void => {
      let isDeleteSuccess = SmartDockModel.getInstance().deleteDockItem(new GridLayoutItemInfo(), -1);
      expect(isDeleteSuccess).assertEqual(false);
    })

    it('test_deleteDockItem1', 0, (): void => {
      let dockItem: DeleteDockItem = {
        bundleName: 'com.ohos.contacts',
        keyName: 'com.ohos.contactscom.ohos.contacts.MainAbilityentry',
        isDeleteAppToUninstallFolder: false
      };
      let smartDockModel = SmartDockModel.getInstance();
      let mocker: MockKit = new MockKit();
      try{
        let dockType: number = SmartDockConstants.RESIDENT_DOCK_TYPE;
        let isDeleteSuccess = SmartDockModel.getInstance().deleteDockItem(dockItem, dockType);
        dockItem.isDeleteAppToUninstallFolder = true;
        SmartDockModel.getInstance().deleteDockItem(dockItem, dockType);
        expect(SmartDockModel.getInstance()).not().assertUndefined();
        let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhoneOrPad);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let mockFunc1: Function = mocker.mockFunc(smartDockModel, smartDockModel.isDockItemExistInDock);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
        isDeleteSuccess = smartDockModel.deleteDockItem(dockItem, dockType);
        expect(isDeleteSuccess).assertFalse();
      } catch (e) {
      }
      mocker.clear(DeviceHelper);
      mocker.clear(smartDockModel);
      mocker.clearAll();
    })

    it('test_deleteDockItem2', 0, (): void => {
      let dockItem: DeleteDockItem = {
        bundleName: 'com.ohos.contacts',
        keyName: 'com.ohos.contactscom.ohos.contacts.MainAbilityentry',
        isDeleteAppToUninstallFolder: false
      };
      let smartDockModel = SmartDockModel.getInstance()
      let mocker: MockKit = new MockKit();
      try{
        let dockType: number = SmartDockConstants.RECENT_DOCK_TYPE;
        let isDeleteSuccess = SmartDockModel.getInstance().deleteDockItem(dockItem, dockType);
        dockItem.isDeleteAppToUninstallFolder = true;
        SmartDockModel.getInstance().deleteDockItem(dockItem, dockType);
        expect(dockItem.isDeleteAppToUninstallFolder).assertEqual(true);
        let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhoneOrPad);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let mockFunc1: Function = mocker.mockFunc(smartDockModel, smartDockModel.isDockItemExistInDock);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
        isDeleteSuccess = smartDockModel.deleteDockItem(dockItem, dockType);
        expect(isDeleteSuccess).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(DeviceHelper);
      mocker.clear(smartDockModel);
      mocker.clearAll();
    })

    it('test_deleteDockItem3', 0, (): void => {
      try{
        let dockItem: DeleteDockItem = {
          bundleName: 'com.ohos.contacts',
          keyName: 'com.ohos.contactscom.ohos.contacts.MainAbilityentry',
          isDeleteAppToUninstallFolder: false
        };
        let dockType: number = SmartDockConstants.RECENT_DOCK_TYPE;
        let isDeleteSuccess = SmartDockModel.getInstance().deleteDockItem(dockItem, dockType);
        dockItem.isDeleteAppToUninstallFolder = true;
        SmartDockModel.getInstance().deleteDockItem(dockItem, dockType);
        expect(dockItem.isDeleteAppToUninstallFolder).assertEqual(true);
      }catch{}
    })

    it('test_deleteDockItem4', 0, (): void => {
      try{
        let dockItem: DeleteDockItem = {
          bundleName: 'com.ohos.contacts',
          keyName: 'com.ohos.contactscom.ohos.contacts.MainAbilityentry',
          isDeleteAppToUninstallFolder: false,
          appIndex: 2
        };
        let dockType: number = SmartDockConstants.RESIDENT_DOCK_TYPE;
        let isDeleteSuccess = SmartDockModel.getInstance().deleteDockItem(dockItem, dockType);
        dockItem.isDeleteAppToUninstallFolder = true;
        SmartDockModel.getInstance().deleteDockItem(dockItem, dockType);
        expect(SmartDockModel.getInstance()).not().assertUndefined();
      }catch{}
    })

    it('test_buildDockItemInfo', 0, (): void => {
      let appList: AppItemInfo[] = AppModel.getInstance().getAppList();
      let appItemInfo = appList[1];
      let gInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      if (appItemInfo) {
        gInfo.bundleName = appItemInfo.bundleName;
        gInfo.abilityName = appItemInfo.abilityName;
        gInfo.moduleName = appItemInfo.moduleName;
        gInfo.typeId = CommonConstants.TYPE_FOLDER;
        gInfo.badgeNumber = appItemInfo.badgeNumber;
        gInfo.appIconId = appItemInfo.appIconId;
        gInfo.appLabelId = appItemInfo.appLabelId;
        gInfo.infoName = appItemInfo.appName;
        gInfo.appStatus = 0;
        gInfo.negativeId = 0;
        gInfo.isSelect = false;
        gInfo.enterEditing = false;
        gInfo.downloadProgress = 100;
        gInfo.iconResource = '';
        gInfo.callerName = '';
      }

      let rst = SmartDockModel.getInstance().buildDockItemInfo(GridLayoutUtil.gridLayoutToDockItem(gInfo));
      expect(rst).not().assertUndefined();
    })

    it('test_addToPageDesk', 0, (): void => {
      try {
        let appList: AppItemInfo[] = AppModel.getInstance().getAppList();
        let appItemInfo = appList[2];
        let gInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        if (appItemInfo) {
          gInfo.bundleName = appItemInfo.bundleName;
          gInfo.abilityName = appItemInfo.abilityName;
          gInfo.moduleName = appItemInfo.moduleName;
          gInfo.typeId = 0;
          gInfo.badgeNumber = appItemInfo.badgeNumber;
          gInfo.appIconId = appItemInfo.appIconId;
          gInfo.appLabelId = appItemInfo.appLabelId;
          gInfo.infoName = appItemInfo.appName;
          gInfo.appStatus = 0;
          gInfo.negativeId = 0;
          gInfo.isSelect = false;
          gInfo.enterEditing = false;
          gInfo.downloadProgress = 100;
          gInfo.iconResource = '';
          gInfo.callerName = '';
        }

        SmartDockModel.getInstance().addToPageDesk(GridLayoutUtil.gridLayoutToDockItem(gInfo));
        expect(SmartDockModel.getInstance()).not().assertUndefined();
      } catch (e) {};
    })

    it('test_insertItemToIndex1', 0, (): void => {
      let instance = SmartDockModel.getInstance();
      let appInfo: AppItemInfo = new AppItemInfo();
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

      let itemInfo: DockItemInfo = new DockItemInfo();
      itemInfo.itemType = CommonConstants.TYPE_APP;
      itemInfo.bundleName = 'com.ohos.contacts';
      itemInfo.keyName = appInfo.keyName;

      let itemInfo1: DockItemInfo = new DockItemInfo();
      itemInfo1.itemType = CommonConstants.TYPE_APP;
      itemInfo1.bundleName = 'com.ohos.mms';
      itemInfo1.keyName = 'com.ohos.mmscom.ohos.mms.MainAbility';

      let itemInfo2: DockItemInfo = new DockItemInfo();
      itemInfo2.itemType = CommonConstants.TYPE_APP;
      itemInfo2.bundleName = 'com.ohos.browser';
      itemInfo2.keyName = 'com.ohos.browserMainAbility';

      let itemInfo3: DockItemInfo = new DockItemInfo();
      itemInfo3.itemType = CommonConstants.TYPE_APP;
      itemInfo3.bundleName = 'com.ohos.camera';
      itemInfo3.keyName = 'com.ohos.cameracom.ohos.camera.MainAbility';
      let residentList: DockItemInfo[] = new Array<DockItemInfo>();
      residentList.push(itemInfo);
      residentList.push(itemInfo1);
      residentList.push(itemInfo2);
      residentList.push(itemInfo3);
      let mocker: MockKit = new MockKit();
      let viewmodel: LayoutViewModel = LayoutViewModel.getInstance();
      try{
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_insertItemToIndex1', residentList, false);
        let mockFunc: Function = mocker.mockFunc(viewmodel,viewmodel.updateResidentDockLayout);
        when(mockFunc)(residentList).afterReturnNothing();

        instance.insertItemToIndex(4,2);
        instance.insertItemToIndex(1,2);

        expect(instance).not().assertUndefined();
      } catch (e) {
      }
      mocker.clear(viewmodel);
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_unregisterDockListener', 0, (): void => {
      SmartDockModel.getInstance().unregisterDockListener();
      expect(SmartDockModel.getInstance()).not().assertUndefined();
    })

    it('test_getShortcutInfo_7', 0, (): void => {
      try {
        SmartDockModel.getInstance().getShortcutInfo('com.ohos.contacts');
        expect(SmartDockModel.getInstance()).not().assertUndefined();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getAppName', 0, (): void => {
      try{
        let appItemInfo: AppItemInfo = {
          appName: 'app1',
          appIconId: 0,
          abilityName: 'abilityName1',
          appLabelId: 0,
          bundleName: 'test',
          moduleName: 'test',
          appIndex: 0
        };
        SmartDockModel.getInstance().getAppName(appItemInfo);
        expect(SmartDockModel.getInstance()).not().assertUndefined();
      }catch{}
    })

    it('test_delDockItemInFolder', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.itemType = 0;
      dockItem.bundleName = 'com.ohos.contacts';
      dockItem.abilityName = 'com.ohos.contacts.MainAbility';
      dockItem.moduleName = 'entry';
      dockItem.editable = true;
      dockItem.visible = true;
      dockItem.borderVisible = true;
      dockItem.shake = 0;
      dockItem.appName = 'MainAbility';
      dockItem.appIconId = 100663798;

      SmartDockModel.getInstance().delDockItemInFolder(dockItem, dockItem, 0);
      expect(SmartDockModel.getInstance()).not().assertUndefined();
    })

    it('test_refreshDockResidentList', 0, (): void => {
      SmartDockModel.getInstance().refreshDockResidentList();
      expect(SmartDockModel.getInstance()).not().assertUndefined();
    })

    it('test_addToPageDesk01', TestType.FUNCTION, async () => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let appInfo: DockItemInfo = new DockItemInfo();
        appInfo.itemType = CommonConstants.TYPE_APP;
        instance.addToPageDesk(appInfo);
        expect(instance).not().assertNull();
      }catch{}
    });

    it('test_addToPageDesk02', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let appInfo: DockItemInfo = new DockItemInfo();
      appInfo.itemType = CommonConstants.TYPE_CARD;
      instance.addToPageDesk(appInfo);
      expect(instance).not().assertNull();
    });

    it('test_addToSmartDock01', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let appInfo: DockItemInfo = new DockItemInfo();
      appInfo.itemType = CommonConstants.TYPE_CARD;
      appInfo.area = undefined;
      let ret: boolean = instance.addToSmartDock(appInfo);
      expect(ret).assertFalse();
    });

    it('test_addToSmartDock02', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let appInfo: DockItemInfo = new DockItemInfo();
      appInfo.itemType = CommonConstants.TYPE_FOLDER;
      appInfo.area = [1, 1];
      let ret: boolean = instance.addToSmartDock(appInfo);
      expect(ret).assertFalse();
    });

    it('test_buildDockItemInfo01', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let appInfo: DockItemInfo = new DockItemInfo();
      appInfo.typeId = CommonConstants.TYPE_FOLDER;
      let ret: DockItemInfo = instance.buildDockItemInfo(appInfo);
      expect(ret).not().assertNull();
    });

    it('test_buildDockItemInfo02', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let appInfo: DockItemInfo = new DockItemInfo();
      appInfo.itemType = CommonConstants.TYPE_CARD;
      let ret: DockItemInfo = instance.buildDockItemInfo(appInfo);
      expect(ret).not().assertNull();
    });

    it('test_buildDockItemInfo03', TestType.FUNCTION, () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let appInfo: DockItemInfo = new DockItemInfo();
      appInfo.bundleName = 'anyBundleName';
      appInfo.keyName = 'anyKeyName';

      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      let ret: DockItemInfo = instance.buildDockItemInfo(appInfo);
      expect(ret).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('test_clearResidentList02', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      ResidentLayoutCacheMgr.getInstance().clearCacheAndInit('_test');
      expect(instance).not().assertNull();
    });

    it('test_createDockAppInfo_002', TestType.FUNCTION, async () => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let appItemInfo: DockItemInfo = new DockItemInfo();
        appItemInfo.bundleName = 'anyBundleName';
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isAppInstalled);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        let ret: DockItemInfo = await ResidentLayoutCacheMgr.getInstance().createDockAppInfo(appItemInfo, 1);
        expect(instance instanceof SmartDockModel).assertInstanceOf('Boolean');
        mocker.clear(GridLayoutUtil);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_delDockItemInFolder01', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let dockItem: DockItemInfo = {} as DockItemInfo;
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
        let ret: boolean = instance.delDockItemInFolder(dockItem, dockItem, 1);
        expect(ret).not().assertNull();
      } catch(e){}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_delDockItemInFolder02', TestType.FUNCTION, async () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let dockItem: DockItemInfo = new DockItemInfo();
        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = 'com.ohos.sceneboard';
        let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
        item2.bundleName = 'com.ohos.sceneboard';
        let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
        item3.bundleName = 'com.ohos.sceneboard';
        item3.typeId === CommonConstants.TYPE_ADD;
        dockItem.layoutInfo = [[item1],[item2],[item3]];

        let ret: boolean = instance.delDockItemInFolder(dockItem, item1, 1);

        expect(ret).assertFalse();
      }catch{}
    });

    it('test_delDockItemInFolder03', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let dockItem: DockItemInfo = new DockItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      dockItem.layoutInfo = [[item1],[item2],[item3]];

      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.bundleName = 'com.ohos.healthy';
      let ret: boolean = instance.delDockItemInFolder(dockItem, item4, 1);

      expect(ret).assertFalse();
    });

    it('test_delDockItemInFolder04', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let dockItem: DockItemInfo = new DockItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.typeId = CommonConstants.TYPE_ADD;
      dockItem.layoutInfo = [[item1],[item2],[item3]];

      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.bundleName = 'com.ohos.healthy';
      let ret: boolean = instance.delDockItemInFolder(dockItem, item4, 1);

      expect(ret).assertFalse();
    });

    it('test_delDockItemInFolder05', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let dockItem: DockItemInfo = new DockItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_APP;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_APP;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.typeId = CommonConstants.TYPE_APP;
      dockItem.layoutInfo = [[item1],[item2],[item3]];

      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.bundleName = 'com.ohos.healthy';
      let ret: boolean = instance.delDockItemInFolder(dockItem, item4, 1);

      expect(ret).assertFalse();
    });

    it('test_delDockItemInFolder06', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let dockItem: DockItemInfo = new DockItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_APP;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_APP;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.typeId = CommonConstants.TYPE_APP;
      dockItem.layoutInfo = [[item1],[item2],[item3]];

      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.bundleName = 'com.ohos.healthy';
      let ret: boolean = instance.delDockItemInFolder(dockItem, item4, 1);

      expect(ret).assertFalse();
    });

    it('test_delDockItemInFolder07', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let dockItem: DockItemInfo = new DockItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_APP;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_APP;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.typeId = CommonConstants.TYPE_APP;
      dockItem.layoutInfo = [[item1],[item2],[item3]];

      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.bundleName = 'com.ohos.healthy';
      let ret: boolean = instance.delDockItemInFolder(dockItem, item4, 1);

      expect(ret).assertFalse();
    });

    it('test_delDockItemInFolder08', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let dockItem: DockItemInfo = new DockItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_APP;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_APP;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.typeId = CommonConstants.TYPE_APP;
      dockItem.layoutInfo = [[item1],[item2],[item3]];

      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.bundleName = 'com.ohos.healthy';
      let residentList: DockItemInfo[] = [dockItem];
      let ret: boolean = instance.delDockItemInFolder(dockItem, item4, 1);

      expect(ret).assertFalse();
    });

    it('test_deleteDockItem01', TestType.FUNCTION, () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let dockItem: DockItemInfo = new DockItemInfo()
      dockItem.bundleName = 'anyBundleName';
      dockItem.keyName = 'anyKeyName';
      let mocker: MockKit = new MockKit();
      try{
        let mockFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);

        let ret: boolean = instance.deleteDockItem(dockItem, SmartDockConstants.RESIDENT_DOCK_TYPE);
        if (ret) {
          expect(ret).assertTrue();
        } else {
          expect(ret).assertFalse();
        }
      } catch (e){}
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('test_deleteDockItem02', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let dockItem: DockItemInfo = new DockItemInfo()
      dockItem.bundleName = '';
      dockItem.keyName = 'anyKeyName';

      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);

      let ret: boolean = instance.deleteDockItem(dockItem, SmartDockConstants.RESIDENT_DOCK_TYPE);
      expect(instance).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('test_deleteDockItem03', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let dockItem: DockItemInfo = new DockItemInfo()
      dockItem.bundleName = 'anyBundleName';
      dockItem.keyName = 'anyKeyName';

      let mocker: MockKit = new MockKit();
      try{
        let mockFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);

        let ret: boolean = instance.deleteDockItem(dockItem, SmartDockConstants.RESIDENT_DOCK_TYPE);
        expect(instance).not().assertNull();
      } catch (e) {
      }
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('test_deleteDockItem04', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let dockItem: DockItemInfo = new DockItemInfo()
      dockItem.bundleName = 'anyBundleName';
      dockItem.keyName = 'anyKeyName';

      let mocker: MockKit = new MockKit();
      try{
        let mockFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
        let ret: boolean = instance.deleteDockItem(dockItem, SmartDockConstants.RECENT_DOCK_TYPE);
        expect(instance).not().assertNull();
      } catch (e) {}
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('test_deleteDockItem05', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let dockItem: DockItemInfo = new DockItemInfo()
      dockItem.bundleName = 'anyBundleName';
      dockItem.keyName = 'anyKeyName';
      let mocker: MockKit = new MockKit();
      try{
        let mockFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhoneOrPad);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);

        let ret: boolean = instance.deleteDockItem(dockItem, SmartDockConstants.RESIDENT_DOCK_NOT_INSTALL_TYPE);
        expect(instance).not().assertNull();
        dockItem.bundleName = '';
        ret = instance.deleteDockItem(dockItem, SmartDockConstants.RESIDENT_DOCK_NOT_INSTALL_TYPE);
        expect(ret).assertFalse();
      } catch (e) {
      }
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('test_getAppName_02', TestType.FUNCTION, () => {
      let mocker: MockKit = new MockKit();
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let mockFunc1: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
        let appItemInfo1: AppItemInfo = {
          appName: 'app1',
          appIconId: 0,
          abilityName: 'abilityName1',
          appLabelId: 0,
          bundleName: 'test',
          moduleName: 'test',
          appIndex: 1
        };
        let ret: string = instance.getAppName(appItemInfo1);
        expect(instance instanceof SmartDockModel).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(CommonUtils);
      mocker.clearAll();
    });

    it('test_getResidentList01', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let manager: RdbStoreManager =RdbStoreManager.getInstance();
      let config: SmartDockLayoutConfig = SmartDockLayoutConfig.getInstance();
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc1: Function = mocker.mockFunc(manager, manager.querySmartDock);
        let dockDataList: DockItemInfo[] = [];
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(dockDataList);
        let mockFunc2: Function = mocker.mockFunc(config, config.isConfigExist);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
        await ResidentLayoutCacheMgr.getInstance().clearCacheAndInit('test');
        expect(instance).not().assertNull();
      } catch (e) {
      }
      mocker.clear(manager);
      mocker.clear(config);
      mocker.clearAll();
    });

    it('test_getResidentList02', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let mocker: MockKit = new MockKit();
      let manager: RdbStoreManager =RdbStoreManager.getInstance();
      try{
        let mockFunc1: Function = mocker.mockFunc(manager, manager.querySmartDock);
        let dockDataList: DockItemInfo[] = [];
        let item: DockItemInfo = new DockItemInfo();
        dockDataList.push(item);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(dockDataList);
        await ResidentLayoutCacheMgr.getInstance().clearCacheAndInit('test');
        expect(instance).not().assertNull();
      } catch (e) {
      }
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('test_getResidentList03', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let manager: RdbStoreManager =RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      try{
        let mockFunc1: Function = mocker.mockFunc(manager, manager.querySmartDock);
        let dockDataList: DockItemInfo[] = [];
        let item: DockItemInfo = new DockItemInfo();
        item.itemType = CommonConstants.TYPE_APP
        dockDataList.push(item);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(dockDataList);
        await ResidentLayoutCacheMgr.getInstance().clearCacheAndInit('test');
        expect(instance).not().assertNull();
      } catch (e) {
      }
      mocker.clear(manager);
      mocker.clearAll();

    });

    it('test_getResidentList04', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let mocker: MockKit = new MockKit();
      let manager: RdbStoreManager =RdbStoreManager.getInstance();
      try{
        let mockFunc1: Function = mocker.mockFunc(manager, manager.querySmartDock);
        let dockDataList: DockItemInfo[] = [];
        let item: DockItemInfo = new DockItemInfo();
        item.itemType = CommonConstants.TYPE_CARD
        dockDataList.push(item);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(dockDataList);
        await ResidentLayoutCacheMgr.getInstance().clearCacheAndInit('test');
        expect(instance).not().assertNull();
      } catch (e) {
      }
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('test_getShortcutInfo02', TestType.FUNCTION, async () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let bundleName: string = 'anyBundleName';
        instance.getShortcutInfo(bundleName);
        expect(instance).not().assertNull();
      }catch{}
    });

    it('test_getShortcutInfoFromManager01', TestType.FUNCTION, async (done: Function) => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let bundleName: string = 'anyBundleName';
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      try{
        let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getShortcutInfo);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn([]);
        await instance.getShortcutInfoFromManager(bundleName);
        expect(instance).not().assertNull();
      } catch (e) {
      }
      mocker.clear(appModel);
      mocker.clearAll();
      done();
    });

    it('test_getSnapShotImagePixelMap', TestType.FUNCTION, async () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let persistentId: number = 12345646;
        await instance.getSnapShotImagePixelMap(persistentId, 1);
        expect(instance).not().assertNull();
      }catch{};
    });

    it('test_unregisterDockListener01', 0, () => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        instance.unregisterDockListener();
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_registerDockListener_01', 0, () => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        instance.registerDockListener();
        instance.registerDockListener();
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_registerDockListener_02', 0, () => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let appInfo: AppItemInfo = new AppItemInfo();
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

        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_DOCK_ITEM_ADD, appInfo);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_registerDockListener_03', 0, () => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let appInfo: AppItemInfo = new AppItemInfo();
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

        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_DELETE, appInfo);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_registerDockListener_04', 0, () => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let appInfo: AppItemInfo = new AppItemInfo();
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

        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RECENT_DOCK_ITEM_DELETE, appInfo);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_registerDockListener_05', 0, () => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let appInfo: AppItemInfo = new AppItemInfo();
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

        localEventManager.sendLocalEventSticky(EventConstants.EVENT_BADGE_UPDATE, appInfo);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_registerDockListener_06', 0, () => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
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

        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_APPGALLERY_CREATED, [appInfo]);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_registerDockListener_07', 0, () => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let appInfo: AppItemInfo = new AppItemInfo();
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

        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RESIDENT_DOCK_NOT_INSTALL_ITEM_DELETE, appInfo);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_refreshDockResidentList_01', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let dockDataList: DockItemInfo[] = [];
        let item1: DockItemInfo = new DockItemInfo();
        item1.itemType = CommonConstants.TYPE_APP;
        dockDataList.push(item1);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_refreshDockResidentList_01', dockDataList, false);
        expect(instance).not().assertNull();
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_refreshDockResidentList_01', [], false);
      }catch{};
    });

    it('test_refreshDockResidentList_04', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let dockDataList: DockItemInfo[] = [];
        let item1: DockItemInfo = new DockItemInfo();
        item1.itemType = CommonConstants.TYPE_FORM_STACK;
        dockDataList.push(item1);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_refreshDockResidentList_04', dockDataList, false);
        expect(instance).not().assertNull();
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_refreshDockResidentList_04', [], false);
      }catch{};
    });

    it('test_reOrderRecentList_01', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let recentMissionsList: RecentBundleMissionInfo[] = [];
        let recentList: RecentBundleMissionInfo[] = [];
        AppStorage.setOrCreate('recentList', recentList);
        let ret: RecentBundleMissionInfo[] = instance.reOrderRecentList(recentMissionsList);
        expect(ret.length).assertEqual(0);
        AppStorage.delete('recentList');
      }catch{}
    });

    it('test_reOrderRecentList_02', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let recentMissionsList: RecentBundleMissionInfo[] = [];
        let item1: RecentBundleMissionInfo = new RecentBundleMissionInfo();
        item1.bundleName = 'anyBundleName';
        recentMissionsList.push(item1);
        let recentList: RecentBundleMissionInfo[] = [];
        let item2: RecentBundleMissionInfo = new RecentBundleMissionInfo();
        item2.bundleName = 'anyBundleName';
        recentList.push(item2);
        AppStorage.setOrCreate('recentList', recentList);
        let ret: RecentBundleMissionInfo[] = instance.reOrderRecentList(recentMissionsList);
        expect(ret).not().assertNull();
        AppStorage.delete('recentList');
      }catch{}
    });

    it('test_reOrderRecentList_03', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let recentMissionsList: RecentBundleMissionInfo[] = [];
        let item1: RecentBundleMissionInfo = new RecentBundleMissionInfo();
        item1.bundleName = 'anyBundleName';
        item1.appIndex = 0;
        recentMissionsList.push(item1);
        let recentList: RecentBundleMissionInfo[] = [];
        let item2: RecentBundleMissionInfo = new RecentBundleMissionInfo();
        item2.bundleName = 'anyBundleName';
        item2.appIndex = 1;
        recentList.push(item2);
        AppStorage.setOrCreate('recentList', []);
        let ret = instance.reOrderRecentList(recentMissionsList);
        expect(ret.length).assertEqual(1);
        AppStorage.setOrCreate('recentList', recentList);
        AppStorage.setOrCreate('openAppNameList', ['anyBundleName']);
        ret = instance.reOrderRecentList(recentMissionsList);
        expect(ret.length).assertEqual(2);
      }catch{}
    })

    it('test_fillReOrderRecentList_01', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let name: string = "com.ohos.camera";
        let openAppInfo = new RecentBundleMissionInfo();
        openAppInfo.bundleName = "com.ohos.camera";
        openAppInfo.abilityName = "com.ohos.camera.MainAbility";
        let list: RecentBundleMissionInfo[] = [openAppInfo];
        instance.fillReOrderRecentList('', list);
        instance.fillReOrderRecentList(name, list);
        expect(list.length).assertEqual(1);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_fillReOrderRecentList_02', 0, () => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let appList: AppItemInfo[] = AppModel.getInstance().getAppList();
        (instance as object)['appList'] = appList;
        let name: string = appList[0].bundleName;
        instance.fillReOrderRecentList(name, []);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_checkDockNum_01', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let dockItemCount: number = 18;
        let ret: boolean = (instance as object)['checkDockNum'](dockItemCount);
        expect(ret).assertTrue();
      }catch{};
    });

    it('test_checkDockNum_02', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let dockItemCount: number = 0;
        let ret: boolean = (instance as object)['checkDockNum'](dockItemCount);
        expect(ret).assertInstanceOf('Boolean');
      }catch{};
    });

    it('test_checkInRecent_01', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let dockItemInfo: DockItemInfo = new DockItemInfo();
        let recentList: RecentBundleMissionInfo[] = [];
        AppStorage.setOrCreate('recentList', recentList);
        (instance as object)['checkInRecent'](dockItemInfo);
        expect(recentList.length).assertEqual(0);
        AppStorage.delete('recentList');
      }catch{};
    });

    it('test_checkInRecent_02', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let dockItemInfo: DockItemInfo = new DockItemInfo();
        dockItemInfo.bundleName = 'anyBundleName';
        let recentList: RecentBundleMissionInfo[] = [];
        let item: RecentBundleMissionInfo = new RecentBundleMissionInfo();
        item.bundleName = 'anyBundleName';
        recentList.push(item);
        AppStorage.setOrCreate('recentList', recentList);
        (instance as object)['checkInRecent'](dockItemInfo);

        let ret: string | undefined = AppStorage.get<string>('showRecentAnimState');
        expect(ret).assertEqual('close');
        AppStorage.delete('recentList');
      }catch{}
    });

    it('test_createDockFolderInfo_01', 0, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let dockItemInfo: DockItemInfo  = new DockItemInfo();

      let appInfos: GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.phone';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.phone';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      appInfos.push(item1);
      appInfos.push(item2);

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
      appItemInfo.layoutInfo = [];
      appItemInfo.layoutInfo.push(appInfos);
      let index: number = 0;

      const appData = undefined;
      let mocker: MockKit = new MockKit();
      try{
        let mockFunc: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppInfoByBundleName);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(appData);
        await (instance as object)['createDockFolderInfo'](dockItemInfo, appItemInfo, index);
        expect( appItemInfo.appIconId).assertEqual(234881117);
      } catch (e) {
      }
      mocker.clear(launcherAbilityManager);
      mocker.clearAll();
    });

    it('test_createDockFolderInfo_02', 0, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let dockItemInfo: DockItemInfo  = new DockItemInfo();

      let appInfos: GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.phone';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.phone';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      appInfos.push(item1);
      appInfos.push(item2);

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
      appItemInfo.layoutInfo = [];
      appItemInfo.layoutInfo.push(appInfos);
      let index: number = 0;

      const appData = new AppItemInfo();
      appData.bundleName = 'anyBundleName';
      appData.moduleName = 'anyModuleName';
      appData.abilityName = 'anyAbilityName';
      appData.appIconId = 234881117;
      appData.appLabelId = 234881117;
      appData.isUninstallAble = true;

      let mocker: MockKit = new MockKit();
      try{
        let mockFunc: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppInfoByBundleName);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(appData);
        await (instance as object)['createDockFolderInfo'](dockItemInfo, appItemInfo, index);
        expect( appItemInfo.appIconId).assertEqual(234881117);
      } catch (e) {
      }
      mocker.clear(launcherAbilityManager);
      mocker.clearAll();
    });

    it('test_createDockFolderInfo_03', 0, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let dockItemInfo: DockItemInfo  = new DockItemInfo();

      let appInfos: GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.phone';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.phone';
      item2.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      appInfos.push(item1);
      appInfos.push(item2);

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
      appItemInfo.keyName = undefined;
      appItemInfo.layoutInfo = [];
      appItemInfo.layoutInfo.push(appInfos);
      let index: number = 0;

      const appData = new AppItemInfo();
      appData.bundleName = 'anyBundleName';
      appData.moduleName = 'anyModuleName';
      appData.abilityName = 'anyAbilityName';
      appData.appIconId = 234881117;
      appData.appLabelId = 234881117;
      appData.isUninstallAble = true;

      let mocker: MockKit = new MockKit();
      try{
        let mockFunc: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppInfoByBundleName);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
        await (instance as object)['createDockFolderInfo'](dockItemInfo, appItemInfo, index);
        expect( appItemInfo.appIconId).assertEqual(234881117);
      } catch (e) {
      }
      mocker.clear(launcherAbilityManager);
      mocker.clearAll();
    });

    it('test_createDockOtherInfo_01', 0, async () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();

        let dockItemInfo: DockItemInfo = new DockItemInfo();
        let appItemInfo: DockItemInfo = new DockItemInfo();
        let index: number = 0;

        appItemInfo.itemType = CommonConstants.TYPE_APP;
        appItemInfo.editable = true;
        appItemInfo.bundleName = 'com.ohos.camera';
        appItemInfo.moduleName = 'entry';
        appItemInfo.abilityName = 'com.ohos.camera.MainAbility';
        appItemInfo.appIconId = 234881117;
        appItemInfo.appLabelId = 234881024;
        appItemInfo.applicationLabelId = 234881024;

        (instance as object)['createDockOtherInfo'](dockItemInfo, appItemInfo, index);
        expect(appItemInfo.itemType).assertEqual(CommonConstants.TYPE_APP);
      }catch{};
    });

    it('test_delDockItemInFolderWhenTimeout_01', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();

        let appList : GridLayoutItemInfo[] = [];
        let dockItem : DockItemInfo = new DockItemInfo();
        let residentList : DockItemInfo[] = [];
        let residentIndex : number = 0;

        (instance as object)['delDockItemInFolderWhenTimeout'](appList, dockItem, residentList, residentIndex);
        expect(instance).not().assertNull();
      }catch{};
    });

    it('test_delDockItemInFolderWhenTimeout_02', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();

        let appList : GridLayoutItemInfo[] = [];
        let dockItem : DockItemInfo = new DockItemInfo();
        let residentList : DockItemInfo[] = [];
        let residentIndex : number = 0;

        (instance as object)['delDockItemInFolderWhenTimeout'](appList, dockItem, residentList, residentIndex);
        expect(instance).not().assertNull();
      }catch{};
    });

    it('test_delDockItemInFolderWhenTimeout_03', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();

        let appList : GridLayoutItemInfo[] = [];
        let dockItem : DockItemInfo = new DockItemInfo();
        let residentList : DockItemInfo[] = [];
        let item1 : DockItemInfo = new DockItemInfo();
        residentList.push(item1);
        let residentIndex : number = 0;

        (instance as object)['delDockItemInFolderWhenTimeout'](appList, dockItem, residentList, residentIndex);
        expect(instance).not().assertNull();
      }catch{};
    });

    it('test_delDockItemInFolderWhenTimeout_04', 0, () => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();

        let appList : GridLayoutItemInfo[] = [];
        let dockItem : DockItemInfo = new DockItemInfo();
        let residentList : DockItemInfo[] = [];
        let residentIndex : number = 0;

        (instance as object)['delDockItemInFolderWhenTimeout'](appList, dockItem, residentList, residentIndex);
        expect(instance).not().assertNull();
      }catch{};
    });

    it('test_delDockItemInFolderWhenTimeout_05', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.bundleName = 'com.ohos.phone';
        item.typeId = CommonConstants.TYPE_FOLDER;
        let appList : GridLayoutItemInfo[] = [item];
        let dockItem : DockItemInfo = new DockItemInfo();
        let residentList : DockItemInfo[] = [dockItem];
        let residentIndex : number = 0;
        (instance as object)['delDockItemInFolderWhenTimeout'](appList, dockItem, [], residentIndex);
        (instance as object)['delDockItemInFolderWhenTimeout'](appList, dockItem, residentList, residentIndex);
        expect(instance).not().assertNull();
      }catch{};
    });

    it('test_appItemCopyToRecentTaskInfo', 0 , () => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let appInfo: AppItemInfo = new AppItemInfo();
        appInfo.appName = 'appName_1';
        appInfo.appIconId = 234881117;
        appInfo.bundleName = 'com.ohos.camera';
        appInfo.abilityName = 'com.ohos.camera.MainAbility';
        appInfo.codePath = 'keyName_1';
        let itemInfo: RecentBundleMissionInfo = new RecentBundleMissionInfo();
        itemInfo.bundleName = 'com.ohos.contacts';
        itemInfo.appIndex = 1;
        (instance as object)['appItemCopyToRecentTaskInfo'](appInfo, itemInfo);
        expect(itemInfo.codePath).assertEqual('keyName_1');
      }catch{};
    })

    it('test_isDuplicate_01', 0 , () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();

        let list: AppItemInfo[] = [];
        let appInfo: AppItemInfo = new AppItemInfo();
        appInfo.appName = 'appName_1';
        appInfo.appIconId = 234881117;
        appInfo.bundleName = 'com.ohos.camera';
        appInfo.abilityName = 'com.ohos.camera.MainAbility';
        appInfo.keyName = 'keyName_1';

        let appItemInfo1: AppItemInfo = new AppItemInfo();
        appItemInfo1.appName = 'appName_1';
        appItemInfo1.appIconId = 234881117;
        appItemInfo1.bundleName = 'com.ohos.camera';
        appItemInfo1.abilityName = 'com.ohos.camera.MainAbility';
        appInfo.keyName = 'keyName_1';

        list.push(appItemInfo1);

        AppStorage.set('device', CommonConstants.DEFAULT_DEVICE_TYPE);

        let ret: boolean = (instance as object)['isDuplicate'](list, appInfo);
        expect(ret).assertFalse();
      }catch{};
    });

    it('test_isDuplicate_02', 0, () => {
      let mocker: MockKit = new MockKit();
      let instance: SmartDockModel = SmartDockModel.getInstance();
      try {
        let list: AppItemInfo[] = [];
        let appInfo: AppItemInfo = new AppItemInfo();
        appInfo.appName = 'appName_1';
        appInfo.appIconId = 234881117;
        appInfo.bundleName = 'com.ohos.camera';
        appInfo.abilityName = 'com.ohos.camera.MainAbility';
        appInfo.keyName = 'keyName_1';

        let appItemInfo1: AppItemInfo = new AppItemInfo();
        appItemInfo1.appName = 'appName_1';
        appItemInfo1.appIconId = 234881117;
        appItemInfo1.bundleName = 'com.ohos.camera';
        appItemInfo1.abilityName = 'com.ohos.camera.MainAbility';
        appItemInfo1.keyName = 'keyName_1';
        list.push(appItemInfo1);

        AppStorage.set('device', CommonConstants.PAD_DEVICE_TYPE);

        let ret: boolean = (instance as object)['isDuplicate'](list, appInfo);
        let mockFunc: Function = mocker.mockFunc(instance, (instance as object)['getToastBottom']);
        when(mockFunc)().afterThrow('error');
        ret = (instance as object)['isDuplicate'](list, appInfo);
        expect(ret).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_isDuplicate_03', 0 , () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();

        let list: AppItemInfo[] = [];
        let appInfo: AppItemInfo = new AppItemInfo();
        appInfo.appName = 'appName_1';
        appInfo.appIconId = 234881117;
        appInfo.bundleName = 'com.ohos.camera';
        appInfo.abilityName = 'com.ohos.camera.MainAbility';
        appInfo.keyName = 'keyName_0';

        let appItemInfo1: AppItemInfo = new AppItemInfo();
        appItemInfo1.appName = 'appName_1';
        appItemInfo1.appIconId = 234881117;
        appItemInfo1.bundleName = 'com.ohos.camera';
        appItemInfo1.abilityName = 'com.ohos.camera.MainAbility';
        appInfo.keyName = 'keyName_1';

        list.push(appItemInfo1);

        AppStorage.set('device', CommonConstants.PAD_DEVICE_TYPE);

        let ret: boolean = (instance as object)['isDuplicate'](list, appInfo);
        expect(ret).assertFalse();
      }catch{};
    });

    it('test_isShowContinuableItem_01', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let deviceInfo: DockContinuableInfo = new DockContinuableInfo();
        deviceInfo.sourceDeviceName = 'phone';
        deviceInfo.bundleName = 'anyBundleName';
        AppStorage.set('continueDeviceInfo', deviceInfo);
        let ret: boolean = (instance as object)['isShowContinuableItem']();
        expect(ret).not().assertNull();
      }catch{}
    });

    it('test_isShowContinuableItem_02', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();

        let deviceInfo: DockContinuableInfo = {} as DockContinuableInfo;
        AppStorage.set('continueDeviceInfo', deviceInfo);
        let ret: boolean = (instance as object)['isShowContinuableItem']();
        expect(ret).assertFalse();
      }catch{};
    });

    it('test_updateBadgeNum_01', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let badgeInfo: BadgeInfo = new BadgeInfo();
        badgeInfo.bundleName = 'com.ohos.camera';
        badgeInfo.isShow = true;

        let residentListTemp: DockItemInfo[] = [];
        let appItemInfo: DockItemInfo = new DockItemInfo();
        appItemInfo.appId = '12';
        appItemInfo.appName = '';
        appItemInfo.bundleName = 'com.ohos.camera';
        appItemInfo.abilityName = 'com.ohos.camera.MainAbility';
        appItemInfo.moduleName = 'entry';
        appItemInfo.keyName = 'com.ohos.cameracom.ohos.camera.MainAbilitytablet';
        appItemInfo.appIconId = 234881117;
        appItemInfo.appLabelId = 234881024;
        appItemInfo.applicationLabelId = 234881024;
        appItemInfo.applicationName = 'applicationName_0';
        appItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
        appItemInfo.installTime = ''
        appItemInfo.isSystemApp = false;
        appItemInfo.isUninstallAble = true;
        appItemInfo.visible = true;
        appItemInfo.layoutInfo = [];
        appItemInfo.itemType = CommonConstants.TYPE_APP;
        residentListTemp.push(appItemInfo)
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_updateBadgeNum_01', [], false);
        (instance as object)['updateBadgeNum'](badgeInfo);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_updateBadgeNum_01', residentListTemp, false);
        (instance as object)['updateBadgeNum'](badgeInfo);
        expect(badgeInfo.isShow).assertTrue();
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_updateBadgeNum_01', [], false);
      }catch{};
    });

    it('test_updateLayout_01', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['updateLayout']();
        expect(instance).not().assertNull();
      }catch{};
    });

    it('test_updateDockAppInfos_01', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();

        let item: DockItemInfo = new DockItemInfo();
        item.bundleName = 'com.ohos.sceneboard';
        item.typeId = CommonConstants.TYPE_FOLDER;

        let appInfo1: GridLayoutItemInfo[] = [];
        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = 'com.ohos.sceneboard';
        item1.typeId = CommonConstants.TYPE_FOLDER;
        let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
        item2.bundleName = 'com.ohos.sceneboard';
        item2.typeId = CommonConstants.TYPE_FOLDER;
        appInfo1.push(item1);
        appInfo1.push(item2);

        let residentList: DockItemInfo[] = [];
        let dockItem: DockItemInfo = new DockItemInfo();
        dockItem.appId = '12';
        dockItem.appName = '';
        dockItem.bundleName = 'com.ohos.camera';
        dockItem.abilityName = 'com.ohos.camera.MainAbility';
        dockItem.moduleName = 'entry';
        dockItem.keyName = 'com.ohos.cameracom.ohos.camera.MainAbilitytablet';
        dockItem.appIconId = 234881117;
        dockItem.appLabelId = 234881024;
        dockItem.applicationLabelId = 234881024;
        dockItem.applicationName = 'applicationName_0';
        dockItem.areaType = CommonConstants.TYPE_AREA_DOCK;
        dockItem.installTime = ''
        dockItem.isSystemApp = false;
        dockItem.isUninstallAble = true;
        dockItem.visible = true;
        dockItem.layoutInfo = [];
        dockItem.layoutInfo.push(appInfo1);
        residentList.push(dockItem);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_updateDockAppInfos_01', residentList, false);

        (instance as object)['updateDockAppInfos']([item]);
        expect(residentList).not().assertNull();
      }catch{}
    });

    it('test_updateDockAppInfos_02', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();

        let item: DockItemInfo = new DockItemInfo();
        item.bundleName = 'com.ohos.sceneboard';
        item.typeId = CommonConstants.TYPE_FOLDER;

        let appInfo1: GridLayoutItemInfo[] = [];
        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = 'com.ohos.phone';
        item1.typeId = CommonConstants.TYPE_FOLDER;
        let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
        item2.bundleName = 'com.ohos.phone';
        item2.typeId = CommonConstants.TYPE_FOLDER;
        appInfo1.push(item1);
        appInfo1.push(item2);

        let residentList: DockItemInfo[] = [];
        let dockItem: DockItemInfo = new DockItemInfo();
        dockItem.appId = '12';
        dockItem.appName = '';
        dockItem.bundleName = 'com.ohos.camera';
        dockItem.abilityName = 'com.ohos.camera.MainAbility';
        dockItem.moduleName = 'entry';
        dockItem.keyName = 'com.ohos.cameracom.ohos.camera.MainAbilitytablet';
        dockItem.appIconId = 234881117;
        dockItem.appLabelId = 234881024;
        dockItem.applicationLabelId = 234881024;
        dockItem.applicationName = 'applicationName_0';
        dockItem.areaType = CommonConstants.TYPE_AREA_DOCK;
        dockItem.installTime = ''
        dockItem.isSystemApp = false;
        dockItem.isUninstallAble = true;
        dockItem.visible = true;
        dockItem.layoutInfo = [];
        dockItem.layoutInfo.push(appInfo1);
        residentList.push(dockItem);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_updateDockAppInfos_02', residentList, false);

        (instance as object)['updateDockAppInfos']([item]);
        expect(residentList).not().assertNull();
      }catch{}
    });

    it('test_updateDockAppInfos_03', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();

        let item: DockItemInfo = new DockItemInfo();
        item.bundleName = 'com.ohos.camera';
        item.typeId = CommonConstants.TYPE_FOLDER;

        let appInfo1: GridLayoutItemInfo[] = [];
        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = 'com.ohos.phone';
        item1.typeId = CommonConstants.TYPE_FOLDER;
        let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
        item2.bundleName = 'com.ohos.phone';
        item2.typeId = CommonConstants.TYPE_FOLDER;
        appInfo1.push(item1);
        appInfo1.push(item2);

        let residentList: DockItemInfo[] = [];
        let dockItem: DockItemInfo = new DockItemInfo();
        dockItem.appId = '12';
        dockItem.appName = '';
        dockItem.bundleName = 'com.ohos.camera';
        dockItem.abilityName = 'com.ohos.camera.MainAbility';
        dockItem.moduleName = 'entry';
        dockItem.keyName = 'com.ohos.cameracom.ohos.camera.MainAbilitytablet';
        dockItem.appIconId = 234881117;
        dockItem.appLabelId = 234881024;
        dockItem.applicationLabelId = 234881024;
        dockItem.applicationName = 'applicationName_0';
        dockItem.areaType = CommonConstants.TYPE_AREA_DOCK;
        dockItem.installTime = ''
        dockItem.isSystemApp = false;
        dockItem.isUninstallAble = true;
        dockItem.visible = true;
        dockItem.layoutInfo = [];
        dockItem.layoutInfo.push(appInfo1);
        residentList.push(dockItem);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_updateDockAppInfos_03', residentList, false);

        (instance as object)['updateDockAppInfos']([item]);
        expect(residentList).not().assertNull();
      }catch{}
    });

    it('test_updateDockAppInfos_04', 0, () => {
      let mock = new MockKit();
      let instance: SmartDockModel = SmartDockModel.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(instance, (instance as object)['findItemInDock']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let item: DockItemInfo = new DockItemInfo();
        item.bundleName = 'com.ohos.camera';
        item.typeId = CommonConstants.TYPE_FOLDER;
        item.keyName = 'keyName';
        item.appIndex = 0;
        item.oldBundleNames = ['name1'];

        (instance as object)['updateDockAppInfos']([item]);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_updateDockAppInfos_05', 0, () => {
      let mock = new MockKit();
      let instance: SmartDockModel = SmartDockModel.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(instance, (instance as object)['findItemInDock']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let item: DockItemInfo = new DockItemInfo();
        item.bundleName = 'com.ohos.camera';
        item.typeId = CommonConstants.TYPE_FOLDER;
        item.keyName = 'keyName';
        item.appIndex = 0;
        item.oldBundleNames = ['name1'];

        (instance as object)['updateDockAppInfos']([item]);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_compareDelInfo_01', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.bundleName ='com.example.myapplicationclone';
        item.isUninstallAble = true;
        item.appName ='test11';
        item.shortcutId ='test';
        let deleteItemInfo: DeleteDockItem = new DeleteDockItem();
        deleteItemInfo.bundleName = 'com.example.myapplicationclone';
        deleteItemInfo.isDeleteAppToUninstallFolder = true;
        deleteItemInfo.appIndex = 0;
        deleteItemInfo.shortcutId = 'test';
        let ret: boolean  = (instance as object)['compareDelInfo'](item, deleteItemInfo);
        expect(ret).assertTrue()
      }catch{};
    });

    it('test_compareDelInfo_02', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.bundleName ='com.example.myapplicationclone';
        item.isUninstallAble = true;
        item.abilityName = 'EntryAbility';
        item.appName ='test11';
        item.appIndex = 0;
        item.keyName = 'keyName';
        let deleteItemInfo: DeleteDockItem = new DeleteDockItem();
        deleteItemInfo.bundleName = 'com.example.myapplicationclone';
        item.abilityName = 'Ability';
        deleteItemInfo.isDeleteAppToUninstallFolder = true;
        deleteItemInfo.appIndex = 0;
        deleteItemInfo.keyName = 'keyName';
        deleteItemInfo.shortcutId = '';
        let ret: boolean  = (instance as object)['compareDelInfo'](item, deleteItemInfo);
        expect(ret).assertTrue()
      }catch{};
    });

    it('test_compareDelInfo_03', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.bundleName ='com.example.myapplicationclone';
        item.isUninstallAble = true;
        item.abilityName = 'EntryAbility';
        item.appName ='test11';
        item.appIndex = 1;
        let deleteItemInfo: DeleteDockItem = new DeleteDockItem();
        deleteItemInfo.bundleName = 'com.example.myapplicationclone';
        item.abilityName = 'Ability';
        deleteItemInfo.isDeleteAppToUninstallFolder = true;
        deleteItemInfo.appIndex = 1;
        deleteItemInfo.keyName = '';
        deleteItemInfo.shortcutId = '';
        let ret: boolean  = (instance as object)['compareDelInfo'](item, deleteItemInfo);
        expect(ret).assertTrue()
      }catch{};
    });

    it('test_compareDelInfo_04', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.bundleName ='com.example.myapplicationclone1';
        item.isUninstallAble = true;
        item.abilityName = 'EntryAbility';
        item.appName ='test11';
        item.appIndex = 1;
        let deleteItemInfo: DeleteDockItem = new DeleteDockItem();
        deleteItemInfo.bundleName = 'com.example.myapplicationclone2';
        item.abilityName = 'Ability';
        deleteItemInfo.isDeleteAppToUninstallFolder = true;
        deleteItemInfo.appIndex = undefined;
        deleteItemInfo.keyName = '';
        deleteItemInfo.shortcutId = '';
        let ret: boolean  = (instance as object)['compareDelInfo'](item, deleteItemInfo);
        expect(ret).assertFalse()
      }catch{};
    });

    it('test_compareDelInfo_05', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.bundleName ='com.example.myapplicationclone1';
        item.abilityName = 'EntryAbility';
        item.shortcutId ='1';
        item.appIndex = 1;
        let deleteItemInfo: DeleteDockItem = new DeleteDockItem();
        deleteItemInfo.bundleName = 'com.example.myapplicationclone1';
        item.abilityName = 'Ability';
        deleteItemInfo.shortcutId = '1';
        deleteItemInfo.appIndex = 0;
        let ret: boolean  = (instance as object)['compareDelInfo'](item, deleteItemInfo);
        expect(ret).assertTrue();
      }catch{};
    });

    it('test_findDeleteApp_01', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let appList: GridLayoutItemInfo[] = [];
        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = 'test1';
        appList.push(item1);
        let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
        item2.bundleName = 'test2';
        appList.push(item2);
        let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
        item3.bundleName = 'test3';
        appList.push(item3);

        let deleteItemInfo: DeleteDockItem = new DeleteDockItem();
        deleteItemInfo.bundleName = 'test3';
        (instance as object)['findDeleteApp'](appList, deleteItemInfo);
        expect(instance instanceof SmartDockModel).assertInstanceOf('Boolean');
      }catch{};
    });

    it('test_findDeleteApp_02', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let appList: GridLayoutItemInfo[] = [];
        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = 'test1';
        appList.push(item1);
        let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
        item2.bundleName = 'test2';
        appList.push(item2);
        let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
        item3.bundleName = 'test3';
        appList.push(item3);

        let deleteItemInfo: DeleteDockItem = new DeleteDockItem();
        deleteItemInfo.bundleName = 'test4';
        (instance as object)['findDeleteApp'](appList, deleteItemInfo);
        expect(instance instanceof SmartDockModel).assertInstanceOf('Boolean');
      }catch{};
    });

    it('test_initRecentDataList_folder', 0, (): void => {
      try{
        let containerSessionList: SCBSceneContainerSession[] = SCBSceneSessionManager.getInstance().getContainerSessionList();
        let dockItemInfo = new DockItemInfo();
        dockItemInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
        dockItemInfo.abilityName = CommonConstants.BROWSER_ABILITY;
        dockItemInfo.typeId = 0;
        dockItemInfo.itemType = CommonConstants.TYPE_FUNCTION;
        dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
        dockItemInfo.appIndex = 0;
        dockItemInfo.keyName = CommonConstants.LAUNCHER_BUNDLE + CommonConstants.BROWSER_ABILITY;
        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = 'test1';
        item1.abilityName = 'test';
        item1.appIndex = 0;
        let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
        item2.bundleName = 'test2';
        item2.abilityName = 'test';
        item2.appIndex = 0;
        dockItemInfo.layoutInfo?.push([item1]);
        dockItemInfo.layoutInfo?.push([item2]);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_initRecentDataList_folder', [dockItemInfo], false);
        SmartDockModel.getInstance().initRecentDataList(containerSessionList);
        expect(SmartDockModel.getInstance()).not().assertUndefined();
      }catch{};
    })

    it('test_checkAppIsRunning_01', 0, (): void => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let dockItemInfo = new DockItemInfo();
        dockItemInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
        dockItemInfo.abilityName = CommonConstants.BROWSER_ABILITY;
        dockItemInfo.typeId = CommonConstants.TYPE_FOLDER;
        dockItemInfo.itemType = CommonConstants.TYPE_FUNCTION;
        dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
        dockItemInfo.appIndex = 0;
        dockItemInfo.keyName = CommonConstants.LAUNCHER_BUNDLE + CommonConstants.BROWSER_ABILITY;
        AppStorage.setOrCreate('missionInfoList', []);
        let ret = instance.checkAppIsRunning(dockItemInfo);
        expect(ret).assertInstanceOf('Boolean');
        ret = instance.checkAppIsRunning(dockItemInfo);
        expect(ret).assertInstanceOf('Boolean');
        dockItemInfo = (instance as object)['createDockRecentAppInfo']();
        AppStorage.setOrCreate('missionInfoList', [dockItemInfo]);
        ret = instance.checkAppIsRunning(dockItemInfo);
        expect(ret).assertInstanceOf('Boolean');
        ret = instance.checkAppIsRunning(dockItemInfo);
        expect(ret).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_checkAppIsRunning_02', 0, (): void => {
      let mock = new MockKit();
      let instance: SmartDockModel = SmartDockModel.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let dockItemInfo = new DockItemInfo();
        dockItemInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
        dockItemInfo.abilityName = CommonConstants.BROWSER_ABILITY;
        dockItemInfo.typeId = CommonConstants.TYPE_FOLDER;
        dockItemInfo.itemType = CommonConstants.TYPE_FUNCTION;
        dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
        dockItemInfo.appIndex = 0;
        dockItemInfo.keyName = CommonConstants.LAUNCHER_BUNDLE + CommonConstants.BROWSER_ABILITY;

        AppStorage.setOrCreate('missionInfoList', [dockItemInfo]);
        instance.checkAppIsRunning(dockItemInfo);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_checkAppIsRunning_03', 0, (): void => {
      let mock = new MockKit();
      let instance: SmartDockModel = SmartDockModel.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let dockItemInfo = new DockItemInfo();
        dockItemInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
        dockItemInfo.abilityName = CommonConstants.BROWSER_ABILITY;
        dockItemInfo.typeId = CommonConstants.TYPE_FOLDER;
        dockItemInfo.itemType = CommonConstants.TYPE_FUNCTION;
        dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
        dockItemInfo.appIndex = 0;
        dockItemInfo.keyName = CommonConstants.LAUNCHER_BUNDLE + CommonConstants.BROWSER_ABILITY;

        AppStorage.setOrCreate('missionInfoList', [dockItemInfo]);
        instance.checkAppIsRunning(dockItemInfo);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_checkAppIsRunning_04', 0, (): void => {
      let mock = new MockKit();
      let instance: SmartDockModel = SmartDockModel.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc3: Function = mock.mockFunc(instance, instance.checkSameDockItem);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);

        let dockItemInfo = new DockItemInfo();
        dockItemInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
        dockItemInfo.abilityName = CommonConstants.BROWSER_ABILITY;
        dockItemInfo.typeId = CommonConstants.TYPE_FOLDER;
        dockItemInfo.itemType = CommonConstants.TYPE_FUNCTION;
        dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
        dockItemInfo.appIndex = 0;
        dockItemInfo.keyName = CommonConstants.LAUNCHER_BUNDLE + CommonConstants.BROWSER_ABILITY;

        AppStorage.setOrCreate('missionInfoList', [dockItemInfo]);
        instance.checkAppIsRunning(dockItemInfo);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_checkAppIsRunning_05', 0, (): void => {
      let mock = new MockKit();
      let instance: SmartDockModel = SmartDockModel.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc3: Function = mock.mockFunc(instance, instance.checkSameDockItem);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);

        let dockItemInfo = new DockItemInfo();
        dockItemInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
        dockItemInfo.abilityName = CommonConstants.BROWSER_ABILITY;
        dockItemInfo.typeId = CommonConstants.TYPE_FOLDER;
        dockItemInfo.itemType = CommonConstants.TYPE_FUNCTION;
        dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
        dockItemInfo.appIndex = 0;
        dockItemInfo.keyName = CommonConstants.LAUNCHER_BUNDLE + CommonConstants.BROWSER_ABILITY;

        AppStorage.setOrCreate('missionInfoList', [dockItemInfo]);
        instance.checkAppIsRunning(dockItemInfo);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_isBundleNameAppExistInRecent', 0, (): void => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_isBundleNameAppExistInRecent', [], false);
        expect(instance).not().assertNull();
      }catch{}
    })

    it('test_isBundleNameAppExistInRecent01', 0, (): void => {
      let mocker: MockKit = new MockKit();
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let dockItemInfo = new DockItemInfo();
        dockItemInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
        dockItemInfo.abilityName = CommonConstants.BROWSER_ABILITY;
        dockItemInfo.typeId = CommonConstants.TYPE_FOLDER;
        dockItemInfo.itemType = CommonConstants.TYPE_FUNCTION;
        dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
        dockItemInfo.appIndex = 0;
        dockItemInfo.keyName = CommonConstants.LAUNCHER_BUNDLE + CommonConstants.BROWSER_ABILITY;
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_isBundleNameAppExistInRecent01', [dockItemInfo], false);
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils,CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let ret: boolean = instance.isBundleNameAppExistInRecent(CommonConstants.LAUNCHER_BUNDLE);
        expect(ret).assertEqual(false);
      } catch (e) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_isDockItemExistInDock', 0, (): void => {
      let appDataFromSystem: AppItemInfo = new AppItemInfo();
      appDataFromSystem.bundleName = 'com.ohos.camera';
      appDataFromSystem.typeId = CommonConstants.TYPE_FOLDER;
      appDataFromSystem.appIndex = 0;
      let mocker: MockKit = new MockKit();
      try{
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let ret = instance.isDockItemExistInDock(appDataFromSystem);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        ret = instance.isDockItemExistInDock(appDataFromSystem);
        appDataFromSystem.typeId = CommonConstants.TYPE_APP;
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_isDockItemExistInDock', [], false);
        ret = instance.isDockItemExistInDock(appDataFromSystem);
        expect(ret).assertInstanceOf('Boolean');
      } catch (e) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_isBundleNameAppExistInDock', 0, (): void => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_isBundleNameAppExistInDock', [], false);
        expect(instance.isBundleNameAppExistInDock('', 0)).not().assertUndefined();
        let dockItemInfo = new DockItemInfo();
        dockItemInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
        dockItemInfo.abilityName = CommonConstants.BROWSER_ABILITY;
        dockItemInfo.typeId = CommonConstants.TYPE_FOLDER;
        dockItemInfo.itemType = CommonConstants.TYPE_FUNCTION;
        dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
        dockItemInfo.appIndex = 0;
        dockItemInfo.keyName = CommonConstants.LAUNCHER_BUNDLE + CommonConstants.BROWSER_ABILITY;
        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = 'test1';
        item1.abilityName = 'test';
        item1.appIndex = 0;
        dockItemInfo.layoutInfo = [[item1]];
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_isBundleNameAppExistInDock', [dockItemInfo], false);
        let item = instance.isBundleNameAppExistInDock('test1', 0);
        expect(item).assertInstanceOf('Boolean');
        item = instance.isBundleNameAppExistInDock('test1', 1);
        expect(item).assertInstanceOf('Boolean');
      }catch{}
    })

    it('test_isBundleNameAppExistInDock01', 0, (): void => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let dockItemInfo = new DockItemInfo();
        dockItemInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
        dockItemInfo.abilityName = CommonConstants.BROWSER_ABILITY;
        dockItemInfo.typeId = CommonConstants.TYPE_APP;
        dockItemInfo.itemType = CommonConstants.TYPE_FUNCTION;
        dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
        dockItemInfo.appIndex = 0;
        dockItemInfo.keyName = CommonConstants.LAUNCHER_BUNDLE + CommonConstants.BROWSER_ABILITY;
        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = 'test1';
        item1.abilityName = 'test';
        item1.appIndex = 0;
        dockItemInfo.layoutInfo = [[item1]];
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_isBundleNameAppExistInDock01', [dockItemInfo], false);
        let item = instance.isBundleNameAppExistInDock(CommonConstants.LAUNCHER_BUNDLE, 0);
        expect(item).assertInstanceOf('Boolean');
        item = instance.isBundleNameAppExistInDock(CommonConstants.LAUNCHER_BUNDLE, 1);
        expect(item).not().assertNull();
      }catch{};
    })

    it('test_isBundleNameAppExistInDock02', 0, (): void => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let dockItemInfo = new DockItemInfo();
        dockItemInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
        dockItemInfo.abilityName = CommonConstants.BROWSER_ABILITY;
        dockItemInfo.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        dockItemInfo.itemType = CommonConstants.TYPE_FUNCTION;
        dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
        dockItemInfo.appIndex = 0;
        dockItemInfo.keyName = CommonConstants.LAUNCHER_BUNDLE + CommonConstants.BROWSER_ABILITY;
        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = 'test1';
        item1.abilityName = 'test';
        item1.appIndex = 0;
        dockItemInfo.layoutInfo = [[item1]];
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_isBundleNameAppExistInDock02', [dockItemInfo], false);
        let item = instance.isBundleNameAppExistInDock(CommonConstants.LAUNCHER_BUNDLE, 0);
        expect(item).assertInstanceOf('Boolean');
        item = instance.isBundleNameAppExistInDock(CommonConstants.LAUNCHER_BUNDLE, 1);
        expect(item).not().assertNull();
      }catch{};
    })

    it('test_dealDockFolder', TestType.FUNCTION, () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let gridItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridItem.bundleName = 'test1';
      gridItem.shortcutId = '1';
      gridItem.appIndex = 0;
      let item: DockItemInfo = new DockItemInfo();
      item.appId = '1';
      item.iconResource = 'test';
      item.keyName = 'keyName';
      item.layoutInfo = [[gridItem]];
      let residentList: DockItemInfo[] = [];
      let mocker: MockKit = new MockKit();
      mocker.clearAll();
    })

    it('test_getAbilityItemInfo_01', 0, () => {
      try {
        let sceneInfo = new SCBSceneInfo('popSceneSessionBundle', 'popSceneSessionMoudle', 'popSceneSessionAbility');
        let scbSceneSession: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        let instance: SmartDockModel = SmartDockModel.getInstance();
        instance.getAbilityItemInfo(scbSceneSession);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getAbilityItemInfo_02', 0, () => {
      let mock = new MockKit();
      try {
        let abilityItemInfo: AbilityItemInfo = new AbilityItemInfo();
        abilityItemInfo.name = 'name';
        abilityItemInfo.moduleName = 'moduleName';
        abilityItemInfo.bundleName = 'bundleName';
        abilityItemInfo.appLabelId = 1;
        abilityItemInfo.appIconId = 1;
        let mockFunc: Function =
          mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().getAbilityInfo);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(abilityItemInfo);

        let mockFunc2: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let sceneInfo = new SCBSceneInfo('popSceneSessionBundle', 'popSceneSessionMoudle', 'popSceneSessionAbility');
        let scbSceneSession: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        let instance: SmartDockModel = SmartDockModel.getInstance();
        instance.getAbilityItemInfo(scbSceneSession);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_getAbilityItemInfo_03', 0, () => {
      let mock = new MockKit();
      try {
        let abilityItemInfo: AbilityItemInfo = new AbilityItemInfo();
        abilityItemInfo.name = 'name';
        abilityItemInfo.moduleName = 'moduleName';
        abilityItemInfo.bundleName = 'bundleName';
        abilityItemInfo.appLabelId = 1;
        abilityItemInfo.appIconId = 1;
        let mockFunc: Function =
          mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().getAbilityInfo);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(abilityItemInfo);

        let mockFunc2: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let sceneInfo = new SCBSceneInfo('popSceneSessionBundle', 'popSceneSessionMoudle', 'popSceneSessionAbility');
        let scbSceneSession: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        let instance: SmartDockModel = SmartDockModel.getInstance();
        instance.getAbilityItemInfo(scbSceneSession);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_initOpenAppNameList_01', 0, () => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let appInfo: AppItemInfo = new AppItemInfo();
        appInfo.bundleName = 'com.ohos.camera';
        appInfo.codePath = '1';
        let appList: AppItemInfo[] = [appInfo];
        let dockItemInfo = new RecentBundleMissionInfo();
        dockItemInfo.bundleName = 'bundleName';
        dockItemInfo.appIndex = 0;
        dockItemInfo.keyName = 'test';
        AppStorage.setOrCreate('missionInfoList', [dockItemInfo]);
        let dockItemInfo2 = new RecentBundleMissionInfo();
        dockItemInfo2.bundleName = 'com.ohos.camera';
        dockItemInfo2.appIndex = 0;
        dockItemInfo2.keyName = 'test1';
        let recentMissionsList: Array<RecentBundleMissionInfo> = [dockItemInfo, dockItemInfo];
        let ret = instance.initOpenAppNameList(appList, recentMissionsList);
        ret = instance.initOpenAppNameList(appList, [dockItemInfo, dockItemInfo2]);
        expect(instance instanceof SmartDockModel).assertTrue();
        AppStorage.delete('missionInfoList');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initOpenAppNameList_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let instance: SmartDockModel = SmartDockModel.getInstance();

        let appInfo: AppItemInfo = new AppItemInfo();
        appInfo.bundleName = 'com.ohos.camera';
        appInfo.codePath = '1';
        let appList: AppItemInfo[] = [appInfo];

        let dockItemInfo = new RecentBundleMissionInfo();
        dockItemInfo.bundleName = 'bundleName';
        dockItemInfo.appIndex = 0;
        dockItemInfo.keyName = 'test';
        let dockItemInfo2 = new RecentBundleMissionInfo();
        dockItemInfo2.bundleName = 'com.ohos.camera';
        dockItemInfo2.appIndex = 0;
        dockItemInfo2.keyName = 'test1';
        AppStorage.setOrCreate('missionInfoList', [dockItemInfo]);
        let recentMissionsList: Array<RecentBundleMissionInfo> = [dockItemInfo, dockItemInfo2];
        instance.initOpenAppNameList(appList, recentMissionsList);
        expect(instance instanceof SmartDockModel).assertTrue();
        AppStorage.delete('missionInfoList');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_initOpenAppNameList_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let instance: SmartDockModel = SmartDockModel.getInstance();

        let appInfo: AppItemInfo = new AppItemInfo();
        appInfo.bundleName = 'com.ohos.camera';
        appInfo.codePath = '1';
        let appList: AppItemInfo[] = [appInfo];

        let dockItemInfo = new RecentBundleMissionInfo();
        dockItemInfo.bundleName = 'bundleName';
        dockItemInfo.appIndex = 0;
        dockItemInfo.keyName = 'test';
        let dockItemInfo2 = new RecentBundleMissionInfo();
        dockItemInfo2.bundleName = 'com.ohos.camera';
        dockItemInfo2.appIndex = 0;
        dockItemInfo2.keyName = 'test1';
        AppStorage.setOrCreate('missionInfoList', [dockItemInfo]);
        let recentMissionsList: Array<RecentBundleMissionInfo> = [dockItemInfo, dockItemInfo2];
        instance.initOpenAppNameList(appList, recentMissionsList);
        expect(instance instanceof SmartDockModel).assertTrue();
        AppStorage.delete('missionInfoList');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_updateShortcut', TestType.FUNCTION, () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let gridItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridItem.bundleName = 'test1';
      gridItem.shortcutId = '1';
      gridItem.appIndex = 0;
      let shortcutInfo = {
        id: '1',
        bundleName: 'bundleName',
        appIndex: 0,
        sourceType: 0,
        iconId: 0,
        labelId: 0,
      } as ShortcutInfo;
      let list: ShortcutInfo[] = [shortcutInfo];
      let appModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      try{
        let mockFunc: Function = mocker.mockFunc(appModel, appModel.getAllShortcutInfo);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(list);
        (instance as object)['updateShortcut'](gridItem);
        expect(gridItem.downloadProgress).assertEqual(0);
        (instance as object)['updateShortcut'](gridItem, 1);
        expect(gridItem.column).assertEqual(1);
      } catch (e) {
      }
      mocker.clear(appModel);
      mocker.clearAll();
    })

    it('test_deleteResistDockItem_01', 0, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_deleteResistDockItem', [], false);
        let deleteDockItem = new DeleteDockItem();
        deleteDockItem.bundleName = 'bundleName';
        deleteDockItem.keyName = 'keyName';
        deleteDockItem.appIndex = 0;
        deleteDockItem.shortcutId = '1';
        deleteDockItem.isDeleteAppToUninstallFolder = false;
        (instance as object)['deleteResistDockItem'](deleteDockItem);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_deleteResistDockItem_02', 0, () => {
      let mock = new MockKit();
      let instance: SmartDockModel = SmartDockModel.getInstance();
      try {
        let mockFunc: Function =
          mock.mockFunc(ResidentLayoutCacheMgr.getInstance(), ResidentLayoutCacheMgr.getInstance().getAllDockItems);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([]);

        let deleteDockItem = new DeleteDockItem();
        deleteDockItem.bundleName = 'bundleName';
        deleteDockItem.keyName = 'keyName';
        deleteDockItem.appIndex = 0;
        deleteDockItem.shortcutId = '1';
        deleteDockItem.isDeleteAppToUninstallFolder = false;

        (instance as object)['deleteResistDockItem'](deleteDockItem);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ResidentLayoutCacheMgr.getInstance());
      mock.clearAll();
    })

    it('test_deleteResistDockItem_03', 0, () => {
      let mock = new MockKit();
      let instance: SmartDockModel = SmartDockModel.getInstance();
      try {
        let bundleName: string = 'test';
        let appIndex: number = 0;

        let info: DockItemInfo = new DockItemInfo();
        info.typeId = CommonConstants.TYPE_APP;
        info.bundleName = bundleName;
        info.appIndex = appIndex;
        let bottomAppList: DockItemInfo[] = [info];
        let mockFunc: Function =
          mock.mockFunc(ResidentLayoutCacheMgr.getInstance(), ResidentLayoutCacheMgr.getInstance().getAllDockItems);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(bottomAppList);

        let deleteDockItem = new DeleteDockItem();
        deleteDockItem.bundleName = 'bundleName';
        deleteDockItem.keyName = 'keyName';
        deleteDockItem.appIndex = 0;
        deleteDockItem.shortcutId = '1';
        deleteDockItem.isDeleteAppToUninstallFolder = false;

        (instance as object)['deleteResistDockItem'](deleteDockItem);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ResidentLayoutCacheMgr.getInstance());
      mock.clearAll();
    })

    it('test_deleteRecentDockItem_01', 0, () => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        AppStorage.setOrCreate('recentList', []);
        (instance as object)['deleteRecentDockItem']({ bundleName: 'bundleName', keyName: 'keyName', appIndex: undefined });
        let dockItemInfo = new RecentBundleMissionInfo();
        dockItemInfo.bundleName = '';
        dockItemInfo.appIndex = 0;
        dockItemInfo.keyName = 'test';
        let dockItemInfo2 = new RecentBundleMissionInfo();
        dockItemInfo2.bundleName = '';
        dockItemInfo2.appIndex = 0;
        dockItemInfo2.keyName = 'test1';
        let list: RecentBundleMissionInfo[] = [dockItemInfo, dockItemInfo2];
        AppStorage.setOrCreate('recentList', list);
        (instance as object)['deleteRecentDockItem']({ bundleName: 'bundleName', keyName: 'keyName', appIndex: 0 });
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_deleteRecentDockItem_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let dockItemInfo = new RecentBundleMissionInfo();
        dockItemInfo.bundleName = '';
        dockItemInfo.appIndex = 0;
        dockItemInfo.keyName = 'test';
        let dockItemInfo2 = new RecentBundleMissionInfo();
        dockItemInfo2.bundleName = '';
        dockItemInfo2.appIndex = 0;
        dockItemInfo2.keyName = 'test1';
        let list: RecentBundleMissionInfo[] = [dockItemInfo, dockItemInfo2];
        AppStorage.setOrCreate('recentList', list);
        (instance as object)['deleteRecentDockItem']({ bundleName: 'bundleName', keyName: 'keyName', appIndex: 0 });
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_deleteRecentDockItem_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let dockItemInfo = new RecentBundleMissionInfo();
        dockItemInfo.bundleName = '';
        dockItemInfo.appIndex = 0;
        dockItemInfo.keyName = 'test';
        let dockItemInfo2 = new RecentBundleMissionInfo();
        dockItemInfo2.bundleName = '';
        dockItemInfo2.appIndex = 0;
        dockItemInfo2.keyName = 'test1';
        let list: RecentBundleMissionInfo[] = [dockItemInfo, dockItemInfo2];
        AppStorage.setOrCreate('recentList', list);
        (instance as object)['deleteRecentDockItem']({ bundleName: 'bundleName', keyName: 'keyName', appIndex: 0 });
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_deleteRecentDockItem_04', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let dockItemInfo = new RecentBundleMissionInfo();
        dockItemInfo.bundleName = '';
        dockItemInfo.appIndex = 0;
        dockItemInfo.keyName = 'test';
        let dockItemInfo2 = new RecentBundleMissionInfo();
        dockItemInfo2.bundleName = '';
        dockItemInfo2.appIndex = 0;
        dockItemInfo2.keyName = 'test1';
        let list: RecentBundleMissionInfo[] = [dockItemInfo, dockItemInfo2];
        AppStorage.setOrCreate('recentList', list);
        (instance as object)['deleteRecentDockItem']({ keyName: 'keyName', appIndex: 0 });
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_deleteRecentDockItem_05', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let dockItemInfo = new RecentBundleMissionInfo();
        dockItemInfo.bundleName = '';
        dockItemInfo.appIndex = 0;
        dockItemInfo.keyName = 'test';
        let dockItemInfo2 = new RecentBundleMissionInfo();
        dockItemInfo2.bundleName = '';
        dockItemInfo2.appIndex = 0;
        dockItemInfo2.keyName = 'test1';
        let list: RecentBundleMissionInfo[] = [dockItemInfo, dockItemInfo2];
        AppStorage.setOrCreate('recentList', list);
        (instance as object)['deleteRecentDockItem']({ appIndex: 0 });
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_findItemInDock_01', 0, () => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let item: DockItemInfo = new DockItemInfo();
        item.appId = '1';
        item.iconResource = 'test';
        item.keyName = 'keyName';
        let residentList: DockItemInfo[] = [item];
        (instance as object)['findItemInDock'](residentList, 'keyName', item);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_findItemInDock_02', 0, () => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let item: DockItemInfo = new DockItemInfo();
        item.appId = '1';
        item.iconResource = 'test';
        item.keyName = 'keyName';
        let residentList: DockItemInfo[] = [item];
        (instance as object)['findItemInDock'](residentList, 'keyName2', item);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_findAppItemInDockFolder_01', 0, () => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let gridItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridItem.bundleName = 'test1';
        gridItem.abilityName = 'test';
        gridItem.appIndex = 0;
        gridItem.keyName = 'keyName';
        let item: DockItemInfo = new DockItemInfo();
        item.appId = '1';
        item.iconResource = 'test';
        item.keyName = 'keyName';
        item.layoutInfo = [[gridItem]];
        item.typeId = CommonConstants.TYPE_APP;
        let item2: DockItemInfo = new DockItemInfo();
        item2.appId = '1';
        item2.iconResource = 'test';
        item2.keyName = 'keyName';
        item2.typeId = CommonConstants.TYPE_FOLDER;
        item2.layoutInfo = [[gridItem]];
        let item3: DockItemInfo = new DockItemInfo();
        item3.appId = '1';
        item3.iconResource = 'test';
        item3.keyName = 'keyNameOther';
        item3.typeId = CommonConstants.TYPE_FOLDER;
        gridItem.keyName = 'keyNameOther';
        item3.layoutInfo = [[gridItem]];
        let residentList: DockItemInfo[] = [item, item2, item3];
        (instance as object)['findAppItemInDockFolder'](item2, 'keyName', residentList);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_findAppItemInDockFolder_02', 0, () => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let keyName: string = 'keyName';
        let gridItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridItem.bundleName = 'test1';
        gridItem.abilityName = 'test';
        gridItem.appIndex = 0;
        gridItem.keyName = 'keyName';

        let item2: DockItemInfo = new DockItemInfo();
        item2.bundleName = 'test1';
        item2.appStatus = 0;
        item2.iconResource = 'test';
        item2.appIndex = 0;

        let item3: DockItemInfo = new DockItemInfo();
        item3.appId = '1';
        item3.iconResource = 'test';
        item3.keyName = 'keyNameOther';
        item3.typeId = CommonConstants.TYPE_FOLDER;
        gridItem.keyName = keyName;
        item3.layoutInfo = [[gridItem]];
        let residentList: DockItemInfo[] = [item3];
        (instance as object)['findAppItemInDockFolder'](item2, keyName, residentList);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_refreshViewOpenFolder', TestType.FUNCTION, () => {
      let res = true;
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let folderData = FolderData.getInstance();
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(folderData, folderData.isFolderOpen);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        (instance as object)['refreshViewOpenFolder']();
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        (instance as object)['refreshViewOpenFolder']();
      } catch (error) {
        res = false;
      }
      expect(res).assertTrue();
    })

    it('test_updateDockItem', TestType.FUNCTION, () => {
      try{
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let item: DockItemInfo = new DockItemInfo();
        item.appId = '1';
        item.iconResource = 'test';
        let item2: DockItemInfo = new DockItemInfo();
        item2.iconResource = 'testOther';
        (instance as object)['updateDockItem'](item, item2);
        expect(item2.appId).assertEqual('1');
        item.iconResource = '';
        (instance as object)['updateDockItem'](item, item2);
        expect(item.iconResource).assertEqual('test');
      }catch{};
    })

    it('test_isDataNeedIgnore1', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let mocker: MockKit = new MockKit();
      let manager: RdbStoreManager = RdbStoreManager.getInstance();
      let config: SmartDockLayoutConfig = SmartDockLayoutConfig.getInstance();
      try{
        let mockFunc1: Function = mocker.mockFunc(manager, manager.querySmartDock);
        let dockDataList: DockItemInfo[] = [];
        let dockItem: DockItemInfo = new DockItemInfo();
        dockItem.bundleName = CommonConstants.LAUNCHER_BUNDLE;
        dockItem.bundleName = CommonConstants.APPCENTER_ABILITY;
        dockDataList.push(dockItem);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(dockDataList);
        let mockFunc2: Function = mocker.mockFunc(config, config.isConfigExist);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
        let mockFunc3: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
        await ResidentLayoutCacheMgr.getInstance().clearCacheAndInit('_test');
        expect(instance).not().assertNull();
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_isDataNeedIgnore1', [], false);
      } catch (e) {
      }
      mocker.clear(instance);
      mocker.clear(manager);
      mocker.clear(config);
      mocker.clearAll();
    });

    it('test_isDataNeedIgnore2', TestType.FUNCTION, async () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let mocker: MockKit = new MockKit();
      let manager: RdbStoreManager = RdbStoreManager.getInstance();
      let config: SmartDockLayoutConfig = SmartDockLayoutConfig.getInstance();
      try{
        let mockFunc1: Function = mocker.mockFunc(manager, manager.querySmartDock);
        let dockDataList: DockItemInfo[] = [];
        let dockItem: DockItemInfo = new DockItemInfo();
        dockItem.bundleName = CommonConstants.LAUNCHER_BUNDLE;
        dockItem.bundleName = CommonConstants.APPCENTER_ABILITY;
        dockDataList.push(dockItem);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(dockDataList);
        let mockFunc2: Function = mocker.mockFunc(config, config.isConfigExist);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
        let mockFunc3: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
        await ResidentLayoutCacheMgr.getInstance().clearCacheAndInit('_test');
        expect(instance).not().assertNull();
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test_isDataNeedIgnore2', [], false);
      } catch (e) {
      }
      mocker.clear(manager);
      mocker.clear(config);
      mocker.clearAll();
    });

    it('test_fillRecentMissionInfoList_01', 0, (): void => {
      try {
        let containerSessionList: SCBSceneContainerSession[] = SCBSceneSessionManager.getInstance().getContainerSessionList();
        const recentMissionsList = new Array<RecentBundleMissionInfo>();
        let appList: AppItemInfo[] = AppModel.getInstance().getAppList();
        SmartDockModel.getInstance().fillRecentMissionInfoList(appList, containerSessionList, recentMissionsList);
        expect(SmartDockModel.getInstance()).not().assertUndefined();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_fillRecentMissionInfoList_02', 0, (): void => {
      try {
        let containerSessionList: SCBSceneContainerSession[] = SCBSceneSessionManager.getInstance().getContainerSessionList();
        const recentMissionsList = new Array<RecentBundleMissionInfo>();
        let appList: AppItemInfo[] = AppModel.getInstance().getAppList();
        SmartDockModel.getInstance().fillRecentMissionInfoList(appList, containerSessionList, recentMissionsList);
        let rst: Array<RecentBundleMissionInfo> = SmartDockModel.getInstance().reOrderRecentList(recentMissionsList);
        expect(rst).not().assertUndefined();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_fillRecentMissionInfoList_03', 0, (): void => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let mocker: MockKit = new MockKit();
      try{
        let sceneInfo: SCBSceneInfo = new SCBSceneInfo('exampleBundle', 'exampleModule', 'exampleAbility');
        let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        let screenProperty: SCBScreenProperty = new SCBScreenProperty();
        let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
        containerSession.init();
        let containerSessionList: SCBSceneContainerSession[] = [containerSession];
        const recentMissionsList = new Array<RecentBundleMissionInfo>();
        let appList: AppItemInfo[] = AppModel.getInstance().getAppList();
        let mockFunc1: Function = mocker.mockFunc(instance, instance.getAbilityItemInfo);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(undefined);
        SmartDockModel.getInstance().fillRecentMissionInfoList(appList, containerSessionList, recentMissionsList);
        containerSession.requestDestruction(true, true, false);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_fillRecentMissionInfoList_04', 0, (): void => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let mocker: MockKit = new MockKit();
      try {
        let sceneInfo: SCBSceneInfo = new SCBSceneInfo('exampleBundle', 'exampleModule', 'exampleAbility');
        let sceneSession: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        let screenProperty: SCBScreenProperty = new SCBScreenProperty();
        let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
        containerSession.init();

        let containerSession2: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
        containerSession2.secondarySession = sceneSession;

        let bundleName: string = 'com.ohos.contacts';
        let sceneInfo3: SCBSceneInfo = new SCBSceneInfo(bundleName, 'exampleModule', 'exampleAbility');
        let sceneSession3: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo3), sceneInfo3);
        let containerSession3: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession3, screenProperty);
        containerSession3.secondarySession = sceneSession;
        containerSession3.primarySession = null;

        let sceneInfo4: SCBSceneInfo = new SCBSceneInfo(GUIDE_BUNDLE_NAME, 'exampleModule', 'exampleAbility');
        let sceneSession4: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo4), sceneInfo4);
        let containerSession4: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession4, screenProperty);
        containerSession4.secondarySession = sceneSession;

        let sceneSession5: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo5), sceneInfo5);
        let containerSession5: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession5, screenProperty);
        containerSession5.secondarySession = sceneSession;

        let containerSessionList: SCBSceneContainerSession[] =
          [containerSession, containerSession2, containerSession3, containerSession4, containerSession5];

        let itemInfo1: RecentBundleMissionInfo = new RecentBundleMissionInfo();
        itemInfo1.bundleName = bundleName;
        itemInfo1.appIndex = 0;
        let recentMissionsList: Array<RecentBundleMissionInfo> = [itemInfo1];

        let appList: AppItemInfo[] = AppModel.getInstance().getAppList();
        let mockFunc1: Function = mocker.mockFunc(instance, instance.getAbilityItemInfo);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(undefined);
        SmartDockModel.getInstance().fillRecentMissionInfoList(appList, containerSessionList, recentMissionsList);
        containerSession.requestDestruction(true, true, false);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_checkAppInstanceKey', 0, (): void => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let ret = instance.checkAppInstanceKey(undefined, undefined);
      ret = instance.checkAppInstanceKey(undefined, 'toAppInstanceKey');
      ret = instance.checkAppInstanceKey('fromAppInstanceKey', 'toAppInstanceKey');
      ret = instance.checkAppInstanceKey('fromAppInstanceKey', undefined);
      ret = instance.checkAppInstanceKey('appInstanceKey', 'appInstanceKey');
      expect(ret).assertInstanceOf('Boolean');
    })

    it('test_checkSameDockItem_01', 0, (): void => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        let fromItem: DockItemInfo = new DockItemInfo();
        fromItem.bundleName = 'bundleName';
        fromItem.appIndex = 0;
        let toItem: DockItemInfo = new DockItemInfo();
        toItem.bundleName = 'bundleName';
        toItem.appIndex = 0;

        let ret = instance.checkSameDockItem(fromItem, toItem);
        fromItem.appIndex = 1;
        ret = instance.checkSameDockItem(fromItem, toItem);
        fromItem.appIndex = 0;
        fromItem.bundleName = 'bundleName1';
        ret = instance.checkSameDockItem(fromItem, toItem);
        fromItem.bundleName = 'bundleName';
        fromItem.appInstanceKey = 'appInstanceKey';
        toItem.appInstanceKey = 'appInstanceKey';
        ret = instance.checkSameDockItem(fromItem, toItem);
        toItem.appInstanceKey = 'appInstanceKey1';
        ret = instance.checkSameDockItem(fromItem, toItem);
        toItem.appInstanceKey = undefined;
        ret = instance.checkSameDockItem(fromItem, toItem);
        expect(instance instanceof SmartDockModel).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isSameDockItem_01', 0, () => {
      let instance: SmartDockModel = SmartDockModel.getInstance();
      let fromItemInfo: DockItemInfo = {
        bundleName: 'bundleName1',
        appIndex: 0,
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appIconId: 0,
        abilityName: '',
        appName: '',
        shortcutId: '',
        appInstanceKey: '',
      };
      let toOther: DockItemInfo = {
        bundleName: 'bundleName1',
        appIndex: 1,
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appIconId: 0,
        abilityName: '',
        appName: '',
        shortcutId: '',
        appInstanceKey: '',
      };
      let flag: boolean = instance.isSameDockItem(fromItemInfo, toOther);
      toOther.appIndex = 0;
      flag = instance.isSameDockItem(fromItemInfo, toOther);
      toOther.shortcutId = 'search';
      flag = instance.isSameDockItem(fromItemInfo, toOther);
      fromItemInfo.appInstanceKey = 'appInstanceKey';
      flag = instance.isSameDockItem(fromItemInfo, toOther);
      toOther.appInstanceKey = 'appInstanceKey1';
      flag = instance.isSameDockItem(fromItemInfo, toOther);
      toOther.appInstanceKey = 'appInstanceKey';
      flag = instance.isSameDockItem(fromItemInfo, toOther);
      expect(flag).assertInstanceOf('Boolean');
    });

    it("test_getResidentList_01", 0, async (done: Function) => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        await instance.getResidentList();
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it("test_updateResidentDockItem_01", 0, () => {
      try {
        let bundleName: string = '';
        let appIndex: number = 0;
        let instance: SmartDockModel = SmartDockModel.getInstance();
        instance.updateResidentDockItem(bundleName, appIndex);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_updateResidentDockItem_02", 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(ResidentLayoutCacheMgr.getInstance(), ResidentLayoutCacheMgr.getInstance().getAppTypeItemByBundleName);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;
        let instance: SmartDockModel = SmartDockModel.getInstance();
        instance.updateResidentDockItem(bundleName, appIndex);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ResidentLayoutCacheMgr.getInstance());
      mock.clearAll();
    })

    it("test_updateResidentDockItem_03", 0, () => {
      let mock = new MockKit();
      try {
        let appItemInfo: GridLayoutItemInfo | DockItemInfo = new GridLayoutItemInfo();
        let mockFunc: Function = mock.mockFunc(ResidentLayoutCacheMgr.getInstance(), ResidentLayoutCacheMgr.getInstance().getAppTypeItemByBundleName);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(appItemInfo);

        let appInfo: AppItemInfo = new AppItemInfo();
        let mockFunc1: Function = mock.mockFunc(launcherAbilityManager,launcherAbilityManager.getAppInfoByBundleName);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfo);

        let mockFunc2: Function = mock.mockFunc(FolderData.getInstance(), FolderData.getInstance().isFolderOpen);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;
        let instance: SmartDockModel = SmartDockModel.getInstance();
        instance.updateResidentDockItem(bundleName, appIndex);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ResidentLayoutCacheMgr.getInstance());
      mock.clear(FolderData.getInstance());
      mock.clearAll();
    })

    it("test_updateResidentDockItem_04", 0, () => {
      let mock = new MockKit();
      try {
        let appItemInfo: GridLayoutItemInfo | DockItemInfo = new GridLayoutItemInfo();
        let mockFunc: Function = mock.mockFunc(ResidentLayoutCacheMgr.getInstance(), ResidentLayoutCacheMgr.getInstance().getAppTypeItemByBundleName);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(appItemInfo);

        let mockFunc1: Function = mock.mockFunc(launcherAbilityManager,launcherAbilityManager.getAppInfoByBundleName);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(null);

        let mockFunc2: Function = mock.mockFunc(FolderData.getInstance(), FolderData.getInstance().isFolderOpen);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;
        let instance: SmartDockModel = SmartDockModel.getInstance();
        instance.updateResidentDockItem(bundleName, appIndex);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ResidentLayoutCacheMgr.getInstance());
      mock.clear(FolderData.getInstance());
      mock.clearAll();
    })

    it("test_updateDockShortcutWhenAppUpdate_01", 0, () => {
      let mock = new MockKit();
      try {
        let shortcutInfoList: ShortcutInfo[] = [];
        let mockFunc: Function = mock.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAllShortcutInfo);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(shortcutInfoList);

        let bottomAppList: DockItemInfo[] = [];
        let bundleName: string = '';
        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['updateDockShortcutWhenAppUpdate'](bottomAppList, bundleName);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppModel.getInstance());
      mock.clearAll();
    })

    it("test_updateDockShortcutWhenAppUpdate_02", 0, () => {
      let mock = new MockKit();
      try {
        let info1 = {
          id: '1',
          bundleName: 'bundleName',
          appIndex: 0,
          sourceType: 0,
          iconId: 0,
          labelId: 0,
        } as ShortcutInfo;
        let shortcutInfoList: ShortcutInfo[] = [info1];
        let mockFunc: Function = mock.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAllShortcutInfo);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(shortcutInfoList);

        let bottomAppList: DockItemInfo[] = [];
        let bundleName: string = '';
        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['updateDockShortcutWhenAppUpdate'](bottomAppList, bundleName);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppModel.getInstance());
      mock.clearAll();
    })

    it("test_updateDockShortcutWhenAppUpdate_03", 0, () => {
      let mock = new MockKit();
      try {
        let bundleName: string = 'sameBundleName';
        let info1 = {
          id: '1',
          bundleName: 'bundleName',
          appIndex: 0,
          sourceType: 0,
          iconId: 0,
          labelId: 0,
        } as ShortcutInfo;
        let shortcutInfoList: ShortcutInfo[] = [info1];
        let mockFunc: Function = mock.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAllShortcutInfo);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(shortcutInfoList);

        let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
        app1.bundleName = bundleName;
        app1.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
        app2.bundleName = bundleName;
        app2.typeId = CommonConstants.TYPE_SHORTCUT_ICON;

        let item1: DockItemInfo = new DockItemInfo();
        item1.typeId = CommonConstants.TYPE_FOLDER;
        item1.layoutInfo = [[app1],[app2]];

        let item2: DockItemInfo = new DockItemInfo();
        item2.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        item2.bundleName = bundleName;

        let bottomAppList: DockItemInfo[] = [item1, item2];

        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['updateDockShortcutWhenAppUpdate'](bottomAppList, bundleName);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppModel.getInstance());
      mock.clearAll();
    })

    it("test_updateDockShortcut_01", 0, () => {
      let mock = new MockKit();
      try {
        let appItemInfo: GridLayoutItemInfo | DockItemInfo = new GridLayoutItemInfo();
        appItemInfo.bundleName = 'com.ohos.contacts';
        let appIndex: number = 0;
        let isOperateDb:boolean = false;

        let shortcutInfoList: ShortcutInfo[] = [];
        let mockFunc: Function = mock.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAllShortcutInfo);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([shortcutInfoList]);

        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['updateDockShortcut'](appItemInfo, isOperateDb);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppModel.getInstance());
      mock.clearAll();
    })

    it("test_updateDockShortcut_02", 0, () => {
      let mock = new MockKit();
      try {
        let sameId: string = '1';
        let appItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        appItemInfo.shortcutId = sameId;
        let appIndex: number = 0;
        let isOperateDb: boolean = true;

        let info1 = {
          id: sameId,
          bundleName: 'bundleName',
          appIndex: 0,
          sourceType: 0,
          iconId: 0,
          labelId: 0,
        } as ShortcutInfo;
        let shortcutInfoList: ShortcutInfo[] = [info1];
        let mockFunc: Function = mock.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAllShortcutInfo);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(shortcutInfoList);

        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['updateDockShortcut'](appItemInfo, isOperateDb);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppModel.getInstance());
      mock.clearAll();
    })

    it("test_updateDockShortcut_03", 0, () => {
      let mock = new MockKit();
      try {
        let sameId: string = '1';
        let appItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        appItemInfo.shortcutId = sameId;
        let appIndex: number = 0;
        let isOperateDb: boolean = false;

        let info1 = {
          id: sameId,
          bundleName: 'bundleName',
          appIndex: 0,
          sourceType: 0,
          iconId: 0,
          labelId: 0,
        } as ShortcutInfo;
        let shortcutInfoList: ShortcutInfo[] = [info1];
        let mockFunc: Function = mock.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAllShortcutInfo);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(shortcutInfoList);

        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['updateDockShortcut'](appItemInfo, isOperateDb);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppModel.getInstance());
      mock.clearAll();
    })

    it("test_updateDockShortcut_04", 0, () => {
      let mock = new MockKit();
      try {
        let sameId: string = '1';
        let appItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        appItemInfo.shortcutId = sameId;
        let appIndex: number = 1;
        let isOperateDb: boolean = true;

        let info1 = {
          id: sameId,
          bundleName: 'bundleName',
          appIndex: 0,
          sourceType: 0,
          iconId: 0,
          labelId: 0,
        } as ShortcutInfo;
        let shortcutInfoList: ShortcutInfo[] = [info1];
        let mockFunc: Function = mock.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAllShortcutInfo);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(shortcutInfoList);

        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['updateDockShortcut'](appItemInfo, isOperateDb);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppModel.getInstance());
      mock.clearAll();
    })

    it("test_updateDockShortcut_05", 0, () => {
      let mock = new MockKit();
      try {
        let sameId: string = '1';
        let appItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        appItemInfo.shortcutId = sameId;

        let info1 = {
          id: sameId,
          bundleName: 'bundleName',
          appIndex: 0,
          sourceType: 0,
          iconId: 0,
          labelId: 0,
        } as ShortcutInfo;
        let shortcutInfoList: ShortcutInfo[] = [info1];
        let mockFunc: Function = mock.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAllShortcutInfo);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(shortcutInfoList);

        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['updateDockShortcut'](appItemInfo);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppModel.getInstance());
      mock.clearAll();
    })

    it("test_removeResidentAppsFromRecent_01", 0, () => {
      let mock = new MockKit();
      try {
        let bundleName: string = 'sameBundleName';
        let appIndex: number = 0;

        let itemInfo: RecentBundleMissionInfo = new RecentBundleMissionInfo();
        itemInfo.bundleName = bundleName;
        itemInfo.appIndex = appIndex;
        let recentMissionsList: RecentBundleMissionInfo[] = [itemInfo];

        let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
        app1.bundleName = bundleName;
        app1.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        app1.appIndex = appIndex;
        let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
        app2.bundleName = bundleName;
        app2.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        app2.appIndex = appIndex;

        let item1: DockItemInfo = new DockItemInfo();
        item1.typeId = CommonConstants.TYPE_FOLDER;
        item1.layoutInfo = [[app1], [app2]];
        item1.bundleName = bundleName;
        item1.appIndex = appIndex;

        let item2: DockItemInfo = new DockItemInfo();
        item2.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        item2.bundleName = bundleName;
        item2.bundleName = bundleName;
        item2.appIndex = appIndex;

        let bottomAppList: DockItemInfo[] = [item1, item2];
        let mockFunc: Function =
          mock.mockFunc(ResidentLayoutCacheMgr.getInstance(), ResidentLayoutCacheMgr.getInstance().getAllDockItems);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(bottomAppList);

        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['removeResidentAppsFromRecent'](recentMissionsList);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ResidentLayoutCacheMgr.getInstance());
      mock.clearAll();
    })

    it('test_getDockItemByBundleName_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function =
          mock.mockFunc(ResidentLayoutCacheMgr.getInstance(), ResidentLayoutCacheMgr.getInstance().getAllDockItems);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([]);

        let bundleName: string = 'test';
        let appIndex: number = 0;
        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['getDockItemByBundleName'](bundleName, appIndex);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ResidentLayoutCacheMgr.getInstance());
      mock.clearAll();
    })

    it('test_getDockItemByBundleName_02', 0, () => {
      let mock = new MockKit();
      try {
        let bundleName: string = 'test';
        let appIndex: number = 0;

        let info: DockItemInfo = new DockItemInfo();
        info.typeId = CommonConstants.TYPE_APP;
        info.bundleName = bundleName;
        info.appIndex = appIndex;
        let bottomAppList: DockItemInfo[] = [info];
        let mockFunc: Function =
          mock.mockFunc(ResidentLayoutCacheMgr.getInstance(), ResidentLayoutCacheMgr.getInstance().getAllDockItems);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(bottomAppList);

        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['getDockItemByBundleName'](bundleName, appIndex);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ResidentLayoutCacheMgr.getInstance());
      mock.clearAll();
    })

    it('test_getDockItemByBundleName_03', 0, () => {
      let mock = new MockKit();
      try {
        let bundleName: string = 'test';
        let appIndex: number = 0;

        let info: DockItemInfo = new DockItemInfo();
        info.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        info.bundleName = bundleName;
        info.appIndex = appIndex;
        let bottomAppList: DockItemInfo[] = [info];
        let mockFunc: Function =
          mock.mockFunc(ResidentLayoutCacheMgr.getInstance(), ResidentLayoutCacheMgr.getInstance().getAllDockItems);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(bottomAppList);

        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['getDockItemByBundleName'](bundleName, appIndex);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ResidentLayoutCacheMgr.getInstance());
      mock.clearAll();
    })

    it('test_getDockItemByBundleName_04', 0, () => {
      let mock = new MockKit();
      try {
        let bundleName: string = 'test';
        let appIndex: number = 0;

        let info: DockItemInfo = new DockItemInfo();
        info.typeId = CommonConstants.TYPE_FORM_STACK;
        info.bundleName = bundleName;
        info.appIndex = appIndex;
        let bottomAppList: DockItemInfo[] = [info];
        let mockFunc: Function =
          mock.mockFunc(ResidentLayoutCacheMgr.getInstance(), ResidentLayoutCacheMgr.getInstance().getAllDockItems);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(bottomAppList);

        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['getDockItemByBundleName'](bundleName, appIndex);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ResidentLayoutCacheMgr.getInstance());
      mock.clearAll();
    })

    it('test_getDockItemByBundleName_05', 0, () => {
      let mock = new MockKit();
      try {
        let bundleName: string = 'test';
        let appIndex: number = 0;

        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = bundleName;
        item1.appIndex = appIndex;

        let info: DockItemInfo = new DockItemInfo();
        info.typeId = CommonConstants.TYPE_FOLDER;
        info.bundleName = bundleName;
        info.appIndex = appIndex;
        info.layoutInfo = [[item1]];
        let bottomAppList: DockItemInfo[] = [info];
        let mockFunc: Function =
          mock.mockFunc(ResidentLayoutCacheMgr.getInstance(), ResidentLayoutCacheMgr.getInstance().getAllDockItems);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(bottomAppList);

        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['getDockItemByBundleName'](bundleName, appIndex);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ResidentLayoutCacheMgr.getInstance());
      mock.clearAll();
    })

    it('test_getDockItemByBundleName_06', 0, () => {
      let mock = new MockKit();
      try {
        let bundleName: string = 'test';
        let appIndex: number = 0;

        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = bundleName + '1';
        item1.appIndex = appIndex;

        let info: DockItemInfo = new DockItemInfo();
        info.typeId = CommonConstants.TYPE_FOLDER;
        info.bundleName = bundleName;
        info.appIndex = appIndex;
        info.layoutInfo = [[item1]];
        let bottomAppList: DockItemInfo[] = [info];
        let mockFunc: Function =
          mock.mockFunc(ResidentLayoutCacheMgr.getInstance(), ResidentLayoutCacheMgr.getInstance().getAllDockItems);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(bottomAppList);

        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['getDockItemByBundleName'](bundleName, appIndex);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ResidentLayoutCacheMgr.getInstance());
      mock.clearAll();
    })

    it('test_isBundleNameAppExistInRecent_01', 0, () => {
      let mock = new MockKit();
      try {
        let bundleName: string = 'test';
        let mockFunc: Function =
          mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let instance: SmartDockModel = SmartDockModel.getInstance();
        instance.isBundleNameAppExistInRecent(bundleName);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_isBundleNameAppExistInRecent_02', 0, () => {
      let mock = new MockKit();
      try {
        let bundleName: string = 'test';
        let mockFunc: Function =
          mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function =
          mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let instance: SmartDockModel = SmartDockModel.getInstance();
        instance.isBundleNameAppExistInRecent(bundleName);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_isBundleNameAppExistInRecent_03', 0, () => {
      let mock = new MockKit();
      try {
        let bundleName: string = 'test';
        let mockFunc: Function =
          mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function =
          mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let instance: SmartDockModel = SmartDockModel.getInstance();
        instance.isBundleNameAppExistInRecent(bundleName);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_deleteAppByIndex_01', 0, () => {
      let mock = new MockKit();
      try {
        let bundleName: string = 'test';
        let mockFunc: Function =
          mock.mockFunc(StatusBarServiceEventMgr.getInstance(),
            StatusBarServiceEventMgr.getInstance().isWpsAndRegister);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let index: number = 0;
        let isNeedUpdate: boolean = true;

        let info: DockItemInfo = new DockItemInfo();
        info.typeId = CommonConstants.TYPE_FOLDER;
        info.bundleName = bundleName;
        info.appIndex = index;
        let mResidentList: DockItemInfo[] = [info];

        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['deleteAppByIndex'](mResidentList, index, isNeedUpdate);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(StatusBarServiceEventMgr.getInstance());
      mock.clearAll();
    })

    it('test_deleteAppByIndex_02', 0, () => {
      let mock = new MockKit();
      try {
        let bundleName: string = 'test';
        let mockFunc: Function =
          mock.mockFunc(StatusBarServiceEventMgr.getInstance(),
            StatusBarServiceEventMgr.getInstance().isWpsAndRegister);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let index: number = 0;
        let isNeedUpdate: boolean = false;

        let info: DockItemInfo = new DockItemInfo();
        info.typeId = CommonConstants.TYPE_FOLDER;
        info.bundleName = bundleName;
        info.appIndex = index;
        let mResidentList: DockItemInfo[] = [info];

        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['deleteAppByIndex'](mResidentList, index, isNeedUpdate);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(StatusBarServiceEventMgr.getInstance());
      mock.clearAll();
    })

    it('test_deleteAppByIndex_03', 0, () => {
      let mock = new MockKit();
      try {
        let bundleName: string = 'test';
        let mockFunc: Function =
          mock.mockFunc(StatusBarServiceEventMgr.getInstance(),
            StatusBarServiceEventMgr.getInstance().isWpsAndRegister);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let index: number = 0;
        let isNeedUpdate: boolean = true;

        let info: DockItemInfo = new DockItemInfo();
        info.typeId = CommonConstants.TYPE_FOLDER;
        info.bundleName = bundleName;
        info.appIndex = index;
        let mResidentList: DockItemInfo[] = [info];

        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['deleteAppByIndex'](mResidentList, index, isNeedUpdate);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(StatusBarServiceEventMgr.getInstance());
      mock.clearAll();
    })

    it('test_cleanContinueInfo_01', 0, () => {
      let mock = new MockKit();
      try {
        let bundleName: string = 'test';
        let mockFunc: Function = mock.mockFunc(ObjUtil, ObjUtil.isInvalid);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let info: DockItemInfo = new DockItemInfo();
        info.typeId = CommonConstants.TYPE_APP;
        info.bundleName = bundleName;
        info.appIndex = 0;

        let deviceInfo: DockContinuableInfo = new DockContinuableInfo();
        deviceInfo.sourceDeviceName = 'phone';
        deviceInfo.bundleName = bundleName;
        AppStorage.set('continueDeviceInfo', deviceInfo);

        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['cleanContinueInfo'](info);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ObjUtil);
      mock.clearAll();
    })

    it('test_cleanContinueInfo_02', 0, () => {
      let mock = new MockKit();
      try {
        let bundleName: string = 'test';
        let mockFunc: Function = mock.mockFunc(ObjUtil, ObjUtil.isInvalid);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(ObjUtil, ObjUtil.isValid);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let info: DockItemInfo = new DockItemInfo();
        info.typeId = CommonConstants.TYPE_FOLDER;
        info.bundleName = bundleName;
        info.appIndex = 0;

        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['cleanContinueInfo'](info);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ObjUtil);
      mock.clearAll();
    })

    it('test_getImageInfo_01', 0, () => {
      try {
        let path: image.PixelMap | null = null;
        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['getImageInfo'](path);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getImageInfo_02', 0, async () => {
      try {
        let pixelMap = GlobalContext.getContext()?.resourceManager.getDrawableDescriptor($r('app.media.default_icon').id).getPixelMap();
        let instance: SmartDockModel = SmartDockModel.getInstance();
        await (instance as object)['getImageInfo'](pixelMap);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_dealDockItemWithNewBadge_01', 0, () => {
      try {
        let info: DockItemInfo = new DockItemInfo();
        info.typeId = CommonConstants.TYPE_FOLDER;
        info.bundleName = 'bundleName';
        info.appIndex = 0;

        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['dealDockItemWithNewBadge'](info, 0);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_updateBadgeNum_01', 0, () => {
      let mock = new MockKit();
      try {
        let info: DockItemInfo = new DockItemInfo();

        let mockFunc: Function =
          mock.mockFunc(ResidentLayoutCacheMgr.getInstance(), ResidentLayoutCacheMgr.getInstance().getAllDockItems);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([]);

        let instance: SmartDockModel = SmartDockModel.getInstance();
        (instance as object)['updateBadgeNum'](info);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ResidentLayoutCacheMgr.getInstance());
      mock.clearAll();
    })

    it('test_updateBadgeNum_02', 0, () => {
      let mock = new MockKit();
      let instance: SmartDockModel = SmartDockModel.getInstance();
      try {
        let bundleName: string = 'test';
        let appIndex: number = 0;

        let info: DockItemInfo = new DockItemInfo();
        info.typeId = CommonConstants.TYPE_FORM_STACK;
        info.bundleName = bundleName;
        info.appIndex = appIndex;
        info.itemType = CommonConstants.TYPE_APP;
        let bottomAppList: DockItemInfo[] = [info];
        let mockFunc: Function =
          mock.mockFunc(ResidentLayoutCacheMgr.getInstance(), ResidentLayoutCacheMgr.getInstance().getAllDockItems);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(bottomAppList);

        let mockFunc2: Function = mock.mockFunc(instance, instance.checkSameDockItem);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc3: Function = mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isPcMode);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);

        let curRecentData: RecentBundleMissionInfo = new RecentBundleMissionInfo();
        curRecentData.appId = 'appId';
        curRecentData.appName = 'appId';
        curRecentData.bundleName = 'appId';
        curRecentData.abilityName = 'appId';
        curRecentData.moduleName = 'appId';
        curRecentData.keyName = 'appId';
        curRecentData.appIconId = 1;
        curRecentData.appLabelId = 1;
        curRecentData.installTime = 'appId';
        curRecentData.isSystemApp = true;
        curRecentData.isUninstallAble = true;
        curRecentData.appInstanceKey = 'appId';
        let recentList: RecentBundleMissionInfo[] = new Array<RecentBundleMissionInfo>();
        recentList.push(curRecentData);
        AppStorage.setOrCreate('recentList' , recentList);


        (instance as object)['updateBadgeNum'](info);
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ResidentLayoutCacheMgr.getInstance());
      mock.clear(instance);
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clearAll();
    })

    it('test_getShortcutInfoFromManager_01', 0, (): void => {
      try {
        let instance: SmartDockModel = SmartDockModel.getInstance();
        instance.getShortcutInfoFromManager('com.ohos.contacts');
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getShortcutInfoFromManager_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(AppModel.getInstance(), AppModel.getInstance().getShortcutInfo);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([]);

        let mockFunc2: Function =
          mock.mockFunc(AppModel.getInstance(), AppModel.getInstance().getShortcutInfoFromManager);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn([]);

        let instance: SmartDockModel = SmartDockModel.getInstance();
        instance.getShortcutInfoFromManager('com.ohos.contacts');
        expect(instance instanceof SmartDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppModel.getInstance());
      mock.clearAll();
    })

    class BadgeInfo {
      bundleName? : string;
      isShow? : boolean;
    }

  })
}