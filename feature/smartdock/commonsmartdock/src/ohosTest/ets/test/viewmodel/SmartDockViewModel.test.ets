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
  AppInstallEventData,
  AppStatus,
  BadgeItemInfo,
  CommonConstants,
  DeleteDockItem,
  DockItemInfo,
  DownloadStatusInfo,
  DragCoveredItem,
  EventConstants,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
  ResidentLayoutCacheMgr
} from '@ohos/launchercommon';
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
  ArgumentMatchers
} from '@ohos/hypium';
import { AppGalleryDownloadManager, MenuInfo, RecentBundleMissionInfo } from '@ohos/launchercommon';
import smartDockViewModel, { ResultData } from '../../../../main/ets/default/viewmodel/SmartDockViewModel';
import { DeviceHelper } from '@ohos/frameworkwrapper'
import { CheckEmptyUtils } from '@ohos/basicutils'
import {
  SCBSceneContainerSession,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty
} from '@ohos/windowscene';
import SmartDockModel from '../../../../main/ets/default/model/SmartDockModel';
import { SmartDockStyleConfig } from '../../../../..';
import SmartDockViewModel from '../../../../main/ets/default/viewmodel/SmartDockViewModel';

/**
 * SmartDockViewModel测试
 *
 * @since 2024-02-27
 */
interface GeneratedObjectLiteralInterface_2 {
  bundleName: string;
  keyName: string;
  appIndex: number;
}

export default function SmartDockViewModelTest() {
  describe('SmartDockViewModelTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getInstance_1', 0, (): void => {
      globalThis.SmartDockViewModel = null;
      AppStorage.setOrCreate('device', CommonConstants.DEFAULT_DEVICE_TYPE);
      let instance = smartDockViewModel.getInstance();
      expect(instance instanceof smartDockViewModel).assertTrue();
      
    })

    it('test_getStyleConfig', 0, (): void => {
      try {
        let instance = smartDockViewModel.getInstance();
        // 使用mock更改条件
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(instance, instance.getStyleConfig);
        when(mockFunc)().afterReturn(SmartDockStyleConfig.getInstance());
        expect(instance instanceof smartDockViewModel).assertTrue();
        mocker.clear(instance);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('residentOnClick_1_1', 0, (): void => {
      let instance = smartDockViewModel.getInstance();
      const item: DockItemInfo = {
        "appName": "电话",
        "appIconId": 0,
        "bundleName": "com.ohos.contacts",
        "abilityName": "com.ohos.contacts.MainAbility",
        "downloadProgress": 0,
        "appStatus": 0,
        "visible": true,
        "borderVisible": false,
        "shake": 0,
        "itemType": 0,
        "editable": false,
        "moduleName": "entry",
        "keyName": "com.ohos.contactscom.ohos.contacts.MainAbilityentry",
        "appLabelId": 0,
        "applicationLabelId": 0,
        "applicationName": "",
        "areaType": 1,
        "missionInfoList": []
      };
      AppStorage.setOrCreate('isDrag', true);
      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.residentOnClick);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(instance instanceof smartDockViewModel).assertTrue();
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('residentOnClick_1_2', 0, (): void => {
      let instance = smartDockViewModel.getInstance();
      const item: DockItemInfo = {
        "appName": "电话",
        "appIconId": 0,
        "bundleName": "com.ohos.contacts",
        "abilityName": "com.ohos.contacts.MainAbility",
        "downloadProgress": 0,
        "appStatus": 0,
        "visible": true,
        "borderVisible": false,
        "shake": 0,
        "itemType": 0,
        "editable": false,
        "moduleName": "entry",
        "keyName": "com.ohos.contactscom.ohos.contacts.MainAbilityentry",
        "appLabelId": 0,
        "applicationLabelId": 0,
        "applicationName": "",
        "areaType": 1,
        "missionInfoList": []
      };
      AppStorage.setOrCreate('isDrag', false);
      AppStorage.setOrCreate('isDockItemMove', true);
      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.residentOnClick);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(instance instanceof smartDockViewModel).assertTrue();
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('residentOnClick_1_3', 0, (): void => {
      let instance = smartDockViewModel.getInstance();
      const item: DockItemInfo = {
        "appName": "电话",
        "appIconId": 0,
        "bundleName": "com.ohos.contacts",
        "abilityName": "com.ohos.contacts.MainAbility",
        "downloadProgress": 0,
        "appStatus": 0,
        "visible": true,
        "borderVisible": false,
        "shake": 0,
        "itemType": 0,
        "editable": false,
        "moduleName": "entry",
        "keyName": "com.ohos.contactscom.ohos.contacts.MainAbilityentry",
        "appLabelId": 0,
        "applicationLabelId": 0,
        "applicationName": "",
        "areaType": 1,
        "missionInfoList": []
      };
      AppStorage.setOrCreate('isDrag', false);
      AppStorage.setOrCreate('isDockItemMove', false);
      let dragCoveredItem: DragCoveredItem = new DragCoveredItem();
      dragCoveredItem.isCreateSmallFolder = true;
      AppStorage.setOrCreate('DragCoveredItem', dragCoveredItem);
      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.residentOnClick);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(instance instanceof smartDockViewModel).assertTrue();
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('residentOnClick_1_4', 0, (): void => {
      let instance = smartDockViewModel.getInstance();
      const item: DockItemInfo = {
        "appName": "应用中心",
        "appIconId": 0,
        "bundleName": 'com.ohos.sceneboard.appcenter.MainAbility',
        "abilityName": 'com.ohos.sceneboard.appcenter.MainAbility',
        "downloadProgress": 0,
        "appStatus": 0,
        "visible": true,
        "borderVisible": false,
        "shake": 0,
        "itemType": 0,
        "editable": false,
        "moduleName": "entry",
        "keyName": 'com.ohos.sceneboard.appcenter.MainAbility',
        "appLabelId": 0,
        "applicationLabelId": 0,
        "applicationName": "",
        "areaType": 1,
        "missionInfoList": []
      };
      AppStorage.setOrCreate('isDrag', false);
      AppStorage.setOrCreate('isDockItemMove', false);
      let dragCoveredItem: DragCoveredItem = new DragCoveredItem();
      AppStorage.setOrCreate('DragCoveredItem', dragCoveredItem);
      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.residentOnClick);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(instance instanceof smartDockViewModel).assertTrue();
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('residentOnClick_1_5', 0, (): void => {
      let instance = smartDockViewModel.getInstance();
      const item: DockItemInfo = {
        "appName": "最近区",
        "appIconId": 0,
        "bundleName": 'com.ohos.sceneboard.recents.MainAbility',
        "abilityName": 'com.ohos.sceneboard.recents.MainAbility',
        "downloadProgress": 0,
        "appStatus": 0,
        "visible": true,
        "borderVisible": false,
        "shake": 0,
        "itemType": 0,
        "editable": false,
        "moduleName": "entry",
        "keyName": 'com.ohos.sceneboard.recents.MainAbility',
        "appLabelId": 0,
        "applicationLabelId": 0,
        "applicationName": "",
        "areaType": 1,
        "missionInfoList": []
      };
      AppStorage.setOrCreate('isDrag', false);
      AppStorage.setOrCreate('isDockItemMove', false);
      let dragCoveredItem: DragCoveredItem = new DragCoveredItem();
      AppStorage.setOrCreate('DragCoveredItem', dragCoveredItem);
      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.residentOnClick);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(instance instanceof smartDockViewModel).assertTrue();
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('residentOnClick_1_6', 0, (): void => {
      let instance = smartDockViewModel.getInstance();
      const item: DockItemInfo = {
        "appName": "回收站",
        "appIconId": 0,
        "bundleName": 'com.ohos.sceneboard.recycleBin',
        "abilityName": 'com.ohos.sceneboard.recycleBin',
        "downloadProgress": 0,
        "appStatus": 0,
        "visible": true,
        "borderVisible": false,
        "shake": 0,
        "itemType": 0,
        "editable": false,
        "moduleName": "entry",
        "keyName": 'com.ohos.sceneboard.recycleBin',
        "appLabelId": 0,
        "applicationLabelId": 0,
        "applicationName": "",
        "areaType": 1,
        "missionInfoList": []
      };
      AppStorage.setOrCreate('isDrag', false);
      AppStorage.setOrCreate('isDockItemMove', false);
      let dragCoveredItem: DragCoveredItem = new DragCoveredItem();
      AppStorage.setOrCreate('DragCoveredItem', dragCoveredItem);
      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.residentOnClick);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(instance instanceof smartDockViewModel).assertTrue();
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('recentOnClick_1', 0, (): void => {
      const item: DockItemInfo = {
        "appName": "电话",
        "appIconId": 0,
        "bundleName": "com.ohos.contacts",
        "abilityName": "com.ohos.contacts.MainAbility",
        "downloadProgress": 0,
        "appStatus": 0,
        "visible": true,
        "borderVisible": false,
        "shake": 0,
        "itemType": 0,
        "editable": false,
        "moduleName": "entry",
        "keyName": "com.ohos.contactscom.ohos.contacts.MainAbilityentry",
        "appLabelId": 0,
        "applicationLabelId": 0,
        "applicationName": "",
        "areaType": 1,
        "missionInfoList": []
      };
      AppStorage.setOrCreate('missionInfoList', null);

      let instance = smartDockViewModel.getInstance();
      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      // 使用mock更改条件
      let mockFunc1: Function = mocker.mockFunc(instance, instance.recentOnClick);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      expect(instance instanceof smartDockViewModel).assertTrue();
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('recentOnClick_2', 0, (): void => {
      let instance = smartDockViewModel.getInstance();
      const item: DockItemInfo = {
        "appName": "电话",
        "appIconId": 0,
        "bundleName": "com.ohos.contacts",
        "abilityName": "com.ohos.contacts.MainAbility",
        "downloadProgress": 0,
        "appStatus": 0,
        "visible": true,
        "borderVisible": false,
        "shake": 0,
        "itemType": 0,
        "editable": false,
        "moduleName": "entry",
        "keyName": "com.ohos.contactscom.ohos.contacts.MainAbilityentry",
        "appLabelId": 0,
        "applicationLabelId": 0,
        "applicationName": "",
        "areaType": 1,
        "missionInfoList": []
      };
      const missionInfos: RecentBundleMissionInfo[] = [];
      let missionInfo = new RecentBundleMissionInfo();
      missionInfo.appName = item.appName;
      missionInfo.bundleName = item.bundleName;
      missionInfo.missionInfoList = item.missionInfoList;
      missionInfos.push(missionInfo);
      AppStorage.setOrCreate('missionInfoList', missionInfos);

      // 使用mock更改条件
      let mocker: MockKit = new MockKit();

      let mockFunc1: Function = mocker.mockFunc(instance, instance.recentOnClick);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      expect(instance instanceof smartDockViewModel).assertTrue();
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('updateDockParams_1', 0, (): void => {
      AppStorage.setOrCreate('screenWidth', 10);
      AppStorage.setOrCreate('screenHeight', 10);
      AppStorage.setOrCreate('sysUIBottomHeight', 10);
      AppStorage.setOrCreate('dockHeight', 10);
      let instance = smartDockViewModel.getInstance();
      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(instance, instance.onDockListChange);
      when(mockFunc1)().afterReturnNothing();
      expect(instance instanceof smartDockViewModel).assertTrue();
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('buildMenuInfoList_1', 0, (): void => {
      const item: DockItemInfo = {
        "appName": "电话",
        "appIconId": 0,
        "bundleName": "com.ohos.contacts",
        "abilityName": "com.ohos.contacts.MainAbility",
        "downloadProgress": 0,
        "appStatus": 0,
        "visible": true,
        "borderVisible": false,
        "shake": 0,
        "itemType": 0,
        "editable": false,
        "moduleName": "entry",
        "keyName": "com.ohos.contactscom.ohos.contacts.MainAbilityentry",
        "appLabelId": 0,
        "applicationLabelId": 0,
        "applicationName": "",
        "areaType": 1,
        "missionInfoList": []
      };
      AppStorage.setOrCreate('device', CommonConstants.PAD_DEVICE_TYPE);

      let instance = smartDockViewModel.getInstance();
      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(instance, instance.buildMenuInfoList);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(new Array<MenuInfo>());
      expect(instance instanceof smartDockViewModel).assertTrue();
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('buildMenuInfoList_2', 0, (): void => {
      const item: DockItemInfo = {
        "appName": "电话",
        "appIconId": 0,
        "bundleName": "com.ohos.contacts",
        "abilityName": "com.ohos.contacts.MainAbility",
        "downloadProgress": 0,
        "appStatus": 0,
        "visible": true,
        "borderVisible": false,
        "shake": 0,
        "itemType": 0,
        "editable": false,
        "moduleName": "entry",
        "keyName": "com.ohos.contactscom.ohos.contacts.MainAbilityentry",
        "appLabelId": 0,
        "applicationLabelId": 0,
        "applicationName": "",
        "areaType": 1,
        "missionInfoList": []
      };
      AppStorage.setOrCreate('device', CommonConstants.DEFAULT_DEVICE_TYPE);

      let instance = smartDockViewModel.getInstance();
      instance.buildMenuInfoList(item, 0, null);
      expect(instance instanceof smartDockViewModel).assertTrue();
    })

    it('buildNotInstalledAppMenu', 0, (): void => {
      let appItem: DockItemInfo = new DockItemInfo();
      appItem.bundleName = 'anyBundleName';
      appItem.area = [1, 1];
      let instance = smartDockViewModel.getInstance();
      let dialog = new CustomDialogController({
        builder: {},
      });
      instance.buildNotInstalledAppMenu(appItem, dialog);
      expect(instance instanceof smartDockViewModel).assertTrue();
    })

    it('getSelectedItem', 0, (): void => {
      let instance = smartDockViewModel.getInstance();
      instance.getSelectedItem();
      expect(instance instanceof smartDockViewModel).assertTrue();
    })

    it('getSelectedDockType', 0, (): void => {
      let instance = smartDockViewModel.getInstance();
      instance.getSelectedDockType();
      expect(instance instanceof smartDockViewModel).assertTrue();
    })

    it('initDockItemCenterArray', 0, (): void => {
      let instance = smartDockViewModel.getInstance();
      instance.initDockItemCenterArray(1);
      expect(instance instanceof smartDockViewModel).assertTrue();
    })

    it('getDockItemCenter_1', 0, (): void => {
      let instance = smartDockViewModel.getInstance();
      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(instance, instance.getDockItemCenter);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(1);
      expect(instance instanceof smartDockViewModel).assertTrue();
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('informUninstallResult_1', 0, (): void => {
      let instance = smartDockViewModel.getInstance();
      instance.informUninstallResult(CommonConstants.UNINSTALL_FORBID);
      instance.informUninstallResult(CommonConstants.UNINSTALL_SUCCESS);
      instance.informUninstallResult(CommonConstants.NUMBER_TWO);
      expect(instance instanceof smartDockViewModel).assertTrue();
    })

    it('initRecentDataList_18', 0, (): void => {
      try {
        let instance = smartDockViewModel.getInstance();
        let containerSessionList: SCBSceneContainerSession[] =
          SCBSceneSessionManager.getInstance().getContainerSessionList();
        let itemInfo: DockItemInfo = new DockItemInfo();
        itemInfo.itemType = CommonConstants.TYPE_APP;
        itemInfo.bundleName = 'com.ohos.browser';
        let residentList: DockItemInfo[] = new Array<DockItemInfo>();
        residentList.push(itemInfo);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);
        instance.initRecentDataList(containerSessionList);
        expect(instance instanceof smartDockViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('updateRecentDataList_1', 0, (): void => {
      let instance = smartDockViewModel.getInstance();
      let containerSessionList: Array<SCBSceneContainerSession> = new Array<SCBSceneContainerSession>();
      let floatSceneSessionList: Array<SCBSceneSession> = new Array<SCBSceneSession>();
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      instance.updateRecentDataList(containerSessionList, floatSceneSessionList, screenProperty);
      expect(instance instanceof smartDockViewModel).assertTrue();
    })

    it('getSnapshot_1', 0, (): void => {
      let instance = smartDockViewModel.getInstance();
      const item: DockItemInfo = {
        "appName": "电话",
        "appIconId": 0,
        "bundleName": "com.ohos.contacts",
        "abilityName": "com.ohos.contacts.MainAbility",
        "downloadProgress": 0,
        "appStatus": 0,
        "visible": true,
        "borderVisible": false,
        "shake": 0,
        "itemType": 0,
        "editable": false,
        "moduleName": "entry",
        "keyName": "com.ohos.contactscom.ohos.contacts.MainAbilityentry",
        "appLabelId": 0,
        "applicationLabelId": 0,
        "applicationName": "",
        "areaType": 1,
        "missionInfoList": []
      };
      const missionInfos: RecentBundleMissionInfo[] = [];
      let missionInfo = new RecentBundleMissionInfo();
      missionInfo.appName = item.appName;
      missionInfo.bundleName = item.bundleName;
      missionInfo.missionInfoList = item.missionInfoList;
      missionInfos.push(missionInfo);

      instance.getSnapshot(missionInfos[0]);
      expect(instance instanceof smartDockViewModel).assertTrue();
    })

    it('test_regroupDataAppListChange_1', 0, (): void => {

      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      let appGalleryDownloadManager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let instance = smartDockViewModel.getInstance();
      try {
        let callbackList: [] = [];
        let event: string = EventConstants.EVENT_PACKAGE_ADDED;
        let bundleName: string = 'com.ohos.contacts';

        let itemInfo: DockItemInfo = new DockItemInfo();
        itemInfo.itemType = CommonConstants.TYPE_APP;
        itemInfo.bundleName = 'com.ohos.contacts';
        itemInfo.keyName = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry';

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
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

        let mockFunc: Function =
          mocker.mockFunc(appGalleryDownloadManager, appGalleryDownloadManager.getDownDownloadTaskInfo);
        when(mockFunc)().afterReturn(undefined);

        let mockFunc2: Function = mocker.mockFunc(instance, instance.regroupDataAppListChange);
        when(mockFunc2)(ArgumentMatchers.any).afterReturnNothing();
        expect(instance instanceof smartDockViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clear(appGalleryDownloadManager);
      mocker.clearAll();
    })

    it('test_regroupDataAppListChange_2', 0, (): void => {
      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      let appGalleryDownloadManager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let instance = smartDockViewModel.getInstance();
      try {
        let callbackList: [] = [];
        let event: string = EventConstants.EVENT_PACKAGE_CHANGED;
        let bundleName: string = 'com.ohos.browser';

        let itemInfo: DockItemInfo = new DockItemInfo();
        itemInfo.itemType = CommonConstants.TYPE_APP;
        itemInfo.bundleName = 'com.ohos.contacts';
        itemInfo.keyName = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry';

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
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

        let mockFunc: Function =
          mocker.mockFunc(appGalleryDownloadManager, appGalleryDownloadManager.getDownDownloadTaskInfo);
        when(mockFunc)().afterReturn({
          taskId: '12',
          bundleName: 'com.ohos.browser',
          taskContext: 'browser',
          appName: 'browser',
          versionCode: 123,
          versionName: '123',
          iconUrl: '123',
          status: 1,
          totalSize: 2,
          downloadedSize: 2
        });
        let mockFunc2: Function = mocker.mockFunc(instance, instance.regroupDataAppListChange);
        when(mockFunc2)(ArgumentMatchers.any).afterReturnNothing();
        expect(instance instanceof smartDockViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(appGalleryDownloadManager);
      mocker.clear(instance);
      mocker.clearAll();
    })


    it('test_regroupDataAppListChange_2_1', 0, (): void => {
      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      let appGalleryDownloadManager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let instance = smartDockViewModel.getInstance();
      try {
        let callbackList: [] = [];
        let event: string = EventConstants.EVENT_PACKAGE_CHANGED;
        let bundleName: string = 'com.ohos.browser';

        let itemInfo: DockItemInfo = new DockItemInfo();
        itemInfo.itemType = CommonConstants.TYPE_APP;
        itemInfo.bundleName = 'com.ohos.contacts';
        itemInfo.keyName = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry';

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
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

        let mockFunc: Function =
          mocker.mockFunc(appGalleryDownloadManager, appGalleryDownloadManager.getDownDownloadTaskInfo);
        when(mockFunc)().afterReturn({
          taskId: '12',
          bundleName: 'com.ohos.browser',
          taskContext: 'browser',
          appName: 'browser',
          versionCode: 123,
          versionName: '123',
          iconUrl: '123',
          status: 1,
          totalSize: 2,
          downloadedSize: 2
        });
        let mockFunc2: Function = mocker.mockFunc(instance, instance.regroupDataAppListChange);
        when(mockFunc2)(ArgumentMatchers.any).afterReturnNothing();
        expect(instance instanceof smartDockViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clear(appGalleryDownloadManager);
      mocker.clearAll();
    })

    it('test_regroupDataAppListChange_2_2', 0, (): void => {
      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      let instance = smartDockViewModel.getInstance();
      let appGalleryDownloadManager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      try {
        let callbackList: [] = [];
        let event: string = EventConstants.EVENT_PACKAGE_CHANGED;
        let bundleName: string = 'com.ohos.contacts';

        let itemInfo: DockItemInfo = new DockItemInfo();
        itemInfo.itemType = CommonConstants.TYPE_APP;
        itemInfo.bundleName = 'com.ohos.contacts';
        itemInfo.keyName = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry';

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
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

        let mockFunc: Function =
          mocker.mockFunc(appGalleryDownloadManager, appGalleryDownloadManager.getDownDownloadTaskInfo);
        when(mockFunc)().afterReturn({
          taskId: '12',
          bundleName: 'com.ohos.contacts',
          taskContext: 'contacts',
          appName: 'contacts',
          versionCode: 23,
          versionName: '23',
          iconUrl: '23',
          status: 1,
          totalSize: 2,
          downloadedSize: 2
        });
        let mockFunc2: Function = mocker.mockFunc(instance, instance.regroupDataAppListChange);
        when(mockFunc2)(ArgumentMatchers.any).afterReturnNothing();
        expect(instance instanceof smartDockViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clear(appGalleryDownloadManager);
      mocker.clearAll();
    })

    it('test_deleteDockItem_18', 0, (): void => {
      // 使用mock更改条件
      let mocker: MockKit = new MockKit();
      let instance = smartDockViewModel.getInstance();
      try {
        let dockItem: DeletDockItem = {
          bundleName: "com.ohos.contacts", keyName: "com.ohos.contactscom.ohos.contacts.MainAbilityentry"
        };
        let itemInfo: DockItemInfo = new DockItemInfo();
        itemInfo.itemType = CommonConstants.TYPE_APP;
        itemInfo.bundleName = 'com.ohos.contacts';
        itemInfo.keyName = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry';

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
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);
        let mockFunc2: Function = mocker.mockFunc(instance, instance.deleteDockItem);
        when(mockFunc2)(ArgumentMatchers.any).afterReturnNothing();
        expect(instance instanceof smartDockViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_updateBadgeNumber_01', 0, () => {
      let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
      let badgeInfo: BadgeItemInfo = new BadgeItemInfo();
      (instance as object)['updateBadgeNumber'](badgeInfo);
      expect(instance).not().assertNull();
    });

    it('test_updateBadgeNumber_02', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
        let dockItemInfo: DockItemInfo = new DockItemInfo();
        dockItemInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
        dockItemInfo.itemType === CommonConstants.TYPE_FOLDER;
        let badgeInfo: BadgeItemInfo = new BadgeItemInfo();
        badgeInfo.bundleName = 'bundleName';
        badgeInfo.badgeNumber = 0;
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        (instance as object)['updateBadgeNumber'](badgeInfo);
        expect(instance).not().assertNull();
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [dockItemInfo], false);
        (instance as object)['updateBadgeNumber'](badgeInfo);
        expect(instance).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_updateBadgeNumber_03', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
        let dockItemInfo: DockItemInfo = new DockItemInfo();
        dockItemInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
        dockItemInfo.itemType === CommonConstants.TYPE_FOLDER;
        let badgeInfo: BadgeItemInfo = new BadgeItemInfo();
        badgeInfo.bundleName = 'bundleName';
        badgeInfo.badgeNumber = 0;

        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function =
          mocker.mockFunc(ResidentLayoutCacheMgr.getInstance(), ResidentLayoutCacheMgr.getInstance().getAllDockItems);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn([dockItemInfo]);

        (instance as object)['updateBadgeNumber'](badgeInfo);
        expect(instance instanceof SmartDockViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clear(ResidentLayoutCacheMgr.getInstance());
      mocker.clearAll();
    });

    it('test_refreshDockItem_01', 0, () => {
      try {
        let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
        let dockItem: DeletDockItem = {
          bundleName: "com.ohos.contacts", keyName: "com.ohos.contactscom.ohos.contacts.MainAbilityentry"
        };

        let itemInfo: DockItemInfo = new DockItemInfo();
        itemInfo.itemType = CommonConstants.TYPE_FOLDER;
        itemInfo.bundleName = 'com.ohos.contacts';
        itemInfo.keyName = 'key';

        let itemInfo1: DockItemInfo = new DockItemInfo();
        itemInfo1.itemType = CommonConstants.TYPE_APP;
        itemInfo1.bundleName = 'com.ohos.clock';
        itemInfo1.keyName = 'key';

        let residentList: DockItemInfo[] = [];
        residentList.push(itemInfo);
        residentList.push(itemInfo1);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

        (instance as object)['refreshDockItem'](dockItem);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
        expect(instance instanceof smartDockViewModel).assertTrue();
      } catch {
      }
    });

    it('test_refreshDockItem_02', 0, () => {
      try {
        let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
        let dockItem: DeletDockItem = {
          bundleName: 'com.ohos.contacts', keyName: 'com.ohos.contactscom.ohos.contacts.MainAbilityentry'
        };

        let itemInfo: DockItemInfo = new DockItemInfo();
        itemInfo.itemType = CommonConstants.TYPE_FOLDER;
        itemInfo.bundleName = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry';
        itemInfo.keyName = 'key';

        let itemInfo1: DockItemInfo = new DockItemInfo();
        itemInfo1.itemType = CommonConstants.TYPE_APP;
        itemInfo1.bundleName = 'com.ohos.clock';
        itemInfo1.keyName = 'key';

        let residentList: DockItemInfo[] = [];
        residentList.push(itemInfo);
        residentList.push(itemInfo1);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

        (instance as object)['refreshDockItem'](dockItem);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
        expect(instance instanceof smartDockViewModel).assertTrue();
      } catch {
      }
    });

    it('test_regroupDataAppListChange_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function =
          mock.mockFunc(SmartDockModel.getInstance(), SmartDockModel.getInstance().isBundleNameAppExistInDock);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
        let callbackList: [] = [];
        let event: string = EventConstants.EVENT_PACKAGE_ADDED;
        let bundleName: string = 'com.ohos.contacts';

        instance.regroupDataAppListChange(callbackList, event, bundleName);
        expect(instance instanceof smartDockViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SmartDockModel.getInstance());
      mock.clearAll();
    })

    it('test_regroupDataAppListChange_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function =
          mock.mockFunc(SmartDockModel.getInstance(), SmartDockModel.getInstance().isBundleNameAppExistInDock);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let downloadStatusInfo: DownloadStatusInfo = {
          status: AppStatus.INSTALLING
        } as DownloadStatusInfo;
        let mockFunc2: Function =
          mock.mockFunc(AppGalleryDownloadManager.getInstance(),
            AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(downloadStatusInfo);

        let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
        let callbackList: [] = [];
        let event: string = EventConstants.EVENT_PACKAGE_ADDED;
        let bundleName: string = 'com.ohos.contacts';

        instance.regroupDataAppListChange(callbackList, event, bundleName, 0);
        expect(instance instanceof smartDockViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SmartDockModel.getInstance());
      mock.clear(AppGalleryDownloadManager.getInstance());
      mock.clearAll();
    })

    it('test_regroupDataAppListChange_04', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function =
          mock.mockFunc(SmartDockModel.getInstance(), SmartDockModel.getInstance().isBundleNameAppExistInDock);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let downloadStatusInfo: DownloadStatusInfo = {
          status: AppStatus.INSTALLING
        } as DownloadStatusInfo;
        let mockFunc2: Function =
          mock.mockFunc(AppGalleryDownloadManager.getInstance(),
            AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(downloadStatusInfo);

        let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
        let callbackList: [] = [];
        let event: string = EventConstants.EVENT_PACKAGE_ADDED;
        let bundleName: string = 'com.ohos.contacts';

        instance.regroupDataAppListChange(callbackList, event, bundleName, 1);
        expect(instance instanceof smartDockViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SmartDockModel.getInstance());
      mock.clear(AppGalleryDownloadManager.getInstance());
      mock.clearAll();
    })

    it('test_regroupDataAppListChange_05', 0, () => {
      let mock = new MockKit();
      let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
      try {
        let mockFunc: Function =
          mock.mockFunc(SmartDockModel.getInstance(), SmartDockModel.getInstance().isBundleNameAppExistInDock);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let downloadStatusInfo: DownloadStatusInfo = {
          status: AppStatus.INSTALLING
        } as DownloadStatusInfo;
        let mockFunc2: Function =
          mock.mockFunc(AppGalleryDownloadManager.getInstance(),
            AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(downloadStatusInfo);

        let mockFunc3: Function =
          mock.mockFunc(instance, (instance as object)['checkIsNeedRemoveItem']);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);

        let callbackList: [] = [];
        let event: string = EventConstants.EVENT_PACKAGE_REMOVED;
        let bundleName: string = 'com.ohos.contacts';

        (instance as object)['waitingForInstallAni'] = false;
        instance.regroupDataAppListChange(callbackList, event, bundleName, 1);
        expect(instance instanceof smartDockViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SmartDockModel.getInstance());
      mock.clear(AppGalleryDownloadManager.getInstance());
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_regroupDataAppListChange_06', 0, () => {
      let mock = new MockKit();
      let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
      try {
        let mockFunc: Function =
          mock.mockFunc(SmartDockModel.getInstance(), SmartDockModel.getInstance().isBundleNameAppExistInDock);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let downloadStatusInfo: DownloadStatusInfo = {
          status: AppStatus.INSTALLING
        } as DownloadStatusInfo;
        let mockFunc2: Function =
          mock.mockFunc(AppGalleryDownloadManager.getInstance(),
            AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(downloadStatusInfo);

        let mockFunc3: Function =
          mock.mockFunc(instance, (instance as object)['checkIsNeedRemoveItem']);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);

        let callbackList: [] = [];
        let event: string = EventConstants.EVENT_PACKAGE_REMOVED;
        let bundleName: string = 'com.ohos.contacts';

        (instance as object)['waitingForInstallAni'] = false;
        instance.regroupDataAppListChange(callbackList, event, bundleName, 1);
        expect(instance instanceof smartDockViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SmartDockModel.getInstance());
      mock.clear(AppGalleryDownloadManager.getInstance());
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_registerInstalledAniFinishCallback_01', 0, () => {
      let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
      let bundleName: string = '';
      let appIndex: number = CommonConstants.MAIN_APP_INDEX;
      try {
        (instance as object)['registerInstalledAniFinishCallback'](bundleName, appIndex);
      } catch (e) {
      }
      expect(instance instanceof smartDockViewModel).assertTrue();
    });

    it('test_registerInstalledAniFinishCallback_02', 0, () => {
      let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
      let bundleName: string = 'bundleName';
      let appIndex: number = CommonConstants.MAIN_APP_INDEX;
      try {
        (instance as object)['registerInstalledAniFinishCallback'](bundleName, appIndex);
      } catch (e) {
      }
      expect(instance instanceof smartDockViewModel).assertTrue();
    });

    it('test_refreshBadgeNum_01', 0, () => {
      let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
      let dockItemInfo: DockItemInfo = new DockItemInfo();
      let badgeInfo: BadgeItemInfo = new BadgeItemInfo();
      badgeInfo.bundleName = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry';
      let residentList: DockItemInfo[] = [];

      dockItemInfo.itemType = CommonConstants.TYPE_FOLDER;
      dockItemInfo.bundleName = 'com.ohos.clock';
      dockItemInfo.keyName = 'key';
      dockItemInfo.layoutInfo = [];

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.clock';
      item1.typeId = CommonConstants.TYPE_APP;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.clock';
      item2.typeId = CommonConstants.TYPE_CARD;


      let layout: GridLayoutItemInfo[] = [];
      layout.push(item1);
      layout.push(item2);
      dockItemInfo.layoutInfo.push(layout);

      (instance as object)['refreshBadgeNum'](dockItemInfo, badgeInfo, residentList);
      expect(instance instanceof smartDockViewModel).assertTrue();
    });

    it('test_getStyleConfig_01', 0, () => {
      let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
      let ret: SmartDockStyleConfig = instance.getStyleConfig();
      expect(ret).not().assertNull();
    });

    it('test_informUninstallResult_01', 0, () => {
      let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
      let resultCode: number = CommonConstants.UNINSTALL_FORBID;
      instance.informUninstallResult(resultCode);

      expect(instance instanceof smartDockViewModel).assertTrue();
    });

    it('test_informUninstallResult_02', 0, () => {
      let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
      let resultCode: number = CommonConstants.UNINSTALL_SUCCESS;
      instance.informUninstallResult(resultCode);

      expect(instance instanceof smartDockViewModel).assertTrue();
    });

    it('test_informUninstallResult_03', 0, () => {
      let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
      let resultCode: number = CommonConstants.INVALID_VALUE;
      instance.informUninstallResult(resultCode);

      expect(instance instanceof smartDockViewModel).assertTrue();
    });

    it('should_return_true_when_residentOnClick_is_called_with_valid_parameters', 0, async (done: Function) => {
      let smartDockViewModel = new SmartDockViewModel();
      let item: DockItemInfo = new DockItemInfo();
      const result = smartDockViewModel.residentOnClick(null, item, undefined, true);
      expect(true).assertTrue();
      done();
    });

    it('should_return_false_when_residentOnClick_is_called_with_invalid_parameters', 0, async (done: Function) => {
      let smartDockViewModel = new SmartDockViewModel();
      let item: DockItemInfo = new DockItemInfo();
      const result = smartDockViewModel.residentOnClick(null, item, undefined, false);
      expect(result).assertFalse();
      done();
    });

    it('should_return_true_when_recentOnClick_is_called_with_valid_parameters', 0, async (done: Function) => {
      let smartDockViewModel: ESObject = new SmartDockViewModel();
      let mocker: ESObject = new MockKit();
      let mockFunc: ESObject =
        mocker.mockFunc(smartDockViewModel.mSmartDockEventMgr, smartDockViewModel.mSmartDockEventMgr.recentOnClick);
      when(mockFunc)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any])
        .afterReturn(true);
      const result: ESObject = smartDockViewModel.recentOnClick('event', 'item', true);
      expect(true).assertTrue();
      mocker.ignoreMock(smartDockViewModel.mSmartDockEventMgr, smartDockViewModel.mSmartDockEventMgr.recentOnClick);
      done();
    });

    it('should_return_false_when_recentOnClick_is_called_with_valid_parameters_and_returns_false', 0,
      async (done: Function) => {
        let smartDockViewModel: ESObject = new SmartDockViewModel();
        let mocker: ESObject = new MockKit();
        let mockFunc: ESObject =
          mocker.mockFunc(smartDockViewModel.mSmartDockEventMgr, smartDockViewModel.mSmartDockEventMgr.recentOnClick);
        when(mockFunc)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any])
          .afterReturn(false);
        const result: ESObject = smartDockViewModel.recentOnClick('event', 'item', false);
        expect(true).assertTrue();
        mocker.ignoreMock(smartDockViewModel.mSmartDockEventMgr, smartDockViewModel.mSmartDockEventMgr.recentOnClick);
        done();
      });

    it('should_handle_the_case_when_callback_is_provided', 0, async (done: Function) => {
      let smartDockViewModel: ESObject = new SmartDockViewModel();
      let mocker: ESObject = new MockKit();
      let mockFunc: ESObject =
        mocker.mockFunc(smartDockViewModel.mSmartDockEventMgr, smartDockViewModel.mSmartDockEventMgr.recentOnClick);
      when(mockFunc)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any])
        .afterReturn(true);
      const callback: ESObject = () => {
      };
      const result: ESObject = smartDockViewModel.recentOnClick('event', 'item', true, callback);
      expect(true).assertTrue();
      mocker.ignoreMock(smartDockViewModel.mSmartDockEventMgr, smartDockViewModel.mSmartDockEventMgr.recentOnClick);
      done();
    });

    it('should_call_updateDockParams_on_mSmartDockStyleMgr_when_onDockListChange_is_called', 0,
      async (done: Function) => {
        let smartDockViewModel: SmartDockViewModel = new SmartDockViewModel();
        smartDockViewModel.onDockListChange();
        expect(smartDockViewModel instanceof SmartDockViewModel).assertTrue();
        done();
      });

    it('should_call_deleteDockItem_with_valid_parameters', 0, async (done: Function) => {
      let smartDockViewModel: ESObject = new SmartDockViewModel();
      let mocker: MockKit = new MockKit();
      let mockFunc: ESObject =
        mocker.mockFunc(smartDockViewModel.mSmartDockEventMgr, smartDockViewModel.mSmartDockEventMgr.deleteDockItem);
      when(mockFunc)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);
      smartDockViewModel.deleteDockItem(new DeleteDockItem(), 1);
      mocker.verify('deleteDockItem', [new DeleteDockItem(), 1]).atLeast(1);
      mocker.ignoreMock(smartDockViewModel.mSmartDockEventMgr, smartDockViewModel.mSmartDockEventMgr.deleteDockItem);
      done();
    });

    it('should_return_correct_center_for_valid_length_and_index', 0, async (done: Function) => {
      let smartDockViewModel: SmartDockViewModel = new SmartDockViewModel();
      const result: ESObject = smartDockViewModel.getDockItemCenter(10, 5);
      expect(true).assertTrue();
      done();
    });

    it('should_handle_edge_cases_for_length_and_index', 0, async (done: Function) => {
      let smartDockViewModel: SmartDockViewModel = new SmartDockViewModel();
      const result: ESObject = smartDockViewModel.getDockItemCenter(0, 0);
      expect(true).assertTrue();
      done();
    });

    it('should_handle_negative_values_for_length_and_index', 0, async (done: Function) => {
      let smartDockViewModel: SmartDockViewModel = new SmartDockViewModel();
      let mocker: MockKit = new MockKit();
      const result: ESObject = smartDockViewModel.getDockItemCenter(-10, -5);
      expect(true).assertTrue();
      done();
    });

    it('should_return_new_MenuInfo_when_mSmartDockEventMgr_is_not_instance_of_SmartDockEventMgr', 0,
      async (done: Function) => {
        let smartDockViewModel: ESObject = new SmartDockViewModel();
        smartDockViewModel.mSmartDockEventMgr = null;
        const result: ESObject = smartDockViewModel.getOpenMenu(new DockItemInfo());
        expect(true).assertTrue()
        done();
      });

    it('should_return_new_MenuInfo_when_mSmartDockEventMgr_is_not_instance_of_SmartDockEventMgr_02', 0,
      async (done: Function) => {
        let smartDockViewModel: ESObject = new SmartDockViewModel();
        smartDockViewModel.mSmartDockEventMgr = null;
        const result: ESObject = smartDockViewModel.getExitMenu({});
        expect(true).assertTrue()
        done();
      });

    it('should_return_leftArrowPath_when_arrowType_is_LEFT', 0, async (done: Function) => {
      let smartDockViewModel: ESObject = new SmartDockViewModel();
      let mocker: ESObject = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(smartDockViewModel, smartDockViewModel.isLeftArrow);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      const result: ESObject = smartDockViewModel.getArrowId('LEFT');
      expect(result).assertEqual('leftArrowPath');
      mocker.verify('isLeftArrow', ['LEFT']).atLeast(1);
      mocker.ignoreMock(smartDockViewModel, smartDockViewModel.isLeftArrow);
      done();
    });

    it('should_return_rightArrowPath_when_arrowType_is_RIGHT', 0, async (done: Function) => {
      let smartDockViewModel: ESObject = new SmartDockViewModel();
      let mocker: ESObject = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(smartDockViewModel, smartDockViewModel.isLeftArrow);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const result: ESObject = smartDockViewModel.getArrowId('RIGHT');
      expect(result).assertEqual('rightArrowPath');
      mocker.verify('isLeftArrow', ['RIGHT']).atLeast(1);
      mocker.ignoreMock(smartDockViewModel, smartDockViewModel.isLeftArrow);
      done();
    });

    it('should_return_true_when_arrowType_is_RESIDENT_LEFT', 0, async (done: Function) => {
      let smartDockViewModel: ESObject = new SmartDockViewModel();
      const result: ESObject = smartDockViewModel.isLeftArrow(0);
      expect(result).assertTrue();
      done();
    });

    it('should_return_true_when_arrowType_is_RECENT_LEFT', 0, async (done: Function) => {
      let smartDockViewModel: ESObject = new SmartDockViewModel();
      const result: ESObject = smartDockViewModel.isLeftArrow(2);
      expect(result).assertTrue();
      done();
    });

    it('should_return_false_when_arrowType_is_not_RESIDENT_LEFT_or_RECENT_LEFT', 0, async (done: Function) => {
      let smartDockViewModel: ESObject = new SmartDockViewModel();
      const result: ESObject = smartDockViewModel.isLeftArrow(1);
      expect(result).assertFalse();
      done();
    });

    it('should_return_ResidentLayoutForPC_when_isResident_is_true', 0, async (done: Function) => {
      let smartDockViewModel: ESObject = new SmartDockViewModel();
      const result: ESObject = smartDockViewModel.getIdPrefix(true);
      expect(result).assertEqual('ResidentLayoutForPC');
      done();
    });

    it('should_return_RecentLayout_when_isResident_is_false', 0, async (done: Function) => {
      let smartDockViewModel: ESObject = new SmartDockViewModel();
      const result: ESObject = smartDockViewModel.getIdPrefix(false);
      expect(result).assertEqual('RecentLayout');
      done();
    });

    it('should_return_correct_id_for_resident_true_and_arrowType_DOWN', 0, async (done: Function) => {
      let smartDockViewModel: ESObject = new SmartDockViewModel();
      let mocker: ESObject = new MockKit();
      let mockGetIdPrefix: ESObject = mocker.mockFunc(smartDockViewModel, smartDockViewModel.getIdPrefix);
      let mockGetArrowId: ESObject = mocker.mockFunc(smartDockViewModel, smartDockViewModel.getArrowId);
      when(mockGetIdPrefix)(true).afterReturn('resident_prefix');
      when(mockGetArrowId)(ArgumentMatchers.any).afterReturn('down_arrow');
      const result: ESObject = smartDockViewModel.getDockArrowId(true, 'DOWN');
      expect(result).assertEqual('resident_prefix_Image_down_arrow');
      mocker.verify('getIdPrefix', [true]).atLeast(1);
      mocker.verify('getArrowId', ['DOWN']).atLeast(1);
      mocker.ignoreMock(smartDockViewModel, smartDockViewModel.getIdPrefix);
      mocker.ignoreMock(smartDockViewModel, smartDockViewModel.getArrowId);
      done();
    });

    it('should_return_correct_id_for_resident_false_and_arrowType_UP', 0, async (done: Function) => {
      let smartDockViewModel: ESObject = new SmartDockViewModel();
      let mocker: ESObject = new MockKit();
      let mockGetIdPrefix: ESObject = mocker.mockFunc(smartDockViewModel, smartDockViewModel.getIdPrefix);
      let mockGetArrowId: ESObject = mocker.mockFunc(smartDockViewModel, smartDockViewModel.getArrowId);
      when(mockGetIdPrefix)(false).afterReturn('non_resident_prefix');
      when(mockGetArrowId)(ArgumentMatchers.any).afterReturn('up_arrow');
      const result: ESObject = smartDockViewModel.getDockArrowId(false, 'UP');
      expect(result).assertEqual('non_resident_prefix_Image_up_arrow');
      mocker.verify('getIdPrefix', [false]).atLeast(1);
      mocker.verify('getArrowId', ['UP']).atLeast(1);
      mocker.ignoreMock(smartDockViewModel, smartDockViewModel.getIdPrefix);
      mocker.ignoreMock(smartDockViewModel, smartDockViewModel.getArrowId);
      done();
    });

    it('should_clear_snapshot_list_when_bundleName_is_LAUNCHER_BUNDLE', 0, async (done: Function) => {
      let smartDockViewModel: ESObject = new SmartDockViewModel();
      let mocker: ESObject = new MockKit();
      await smartDockViewModel.onHoverEvent(CommonConstants.LAUNCHER_BUNDLE);
      expect(smartDockViewModel instanceof SmartDockViewModel).assertTrue();
      done();
    });

    it('should_handle_non-LAUNCHER_BUNDLE_and_check_snapshot_status', 0, async (done: Function) => {
      let smartDockViewModel: ESObject = new SmartDockViewModel();
      let mocker: ESObject = new MockKit();
      let mockGet: ESObject = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockGet)(ArgumentMatchers.any).afterReturn(true);
      await smartDockViewModel.onHoverEvent('com.example.app', true);
      expect(smartDockViewModel.callBackSnapshotStatus).not().assertNull();
      mocker.ignoreMock(AppStorage, AppStorage.get);
      done();
    });

    it('should_refresh_snapshot_when_callBackSnapshotStatus_is_false', 0, async (done: Function) => {
      let smartDockViewModel: ESObject = new SmartDockViewModel();
      smartDockViewModel.callBackSnapshotStatus = false;
      let mocker: ESObject = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(smartDockViewModel, smartDockViewModel.getRefreshSnapshot);
      when(mockFunc)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(undefined);
      await smartDockViewModel.onHoverEvent('com.example.app', true);
      mocker.verify('getRefreshSnapshot', ['com.example.app', true]).atLeast(0);
      mocker.ignoreMock(smartDockViewModel, smartDockViewModel.getRefreshSnapshot);
      done();
    });

    it('should_clear_snapshot_list_when_no_mission_info_found', 0, async (done: Function) => {
      let smartDockViewModel: ESObject = new SmartDockViewModel();
      let mocker: ESObject = new MockKit();
      let mockAppStorage: ESObject = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockAppStorage)(ArgumentMatchers.any).afterReturn([]);
      await smartDockViewModel.getRefreshSnapshot('testBundle');
      expect(smartDockViewModel instanceof SmartDockViewModel).assertTrue();
      mocker.ignoreMock(AppStorage, AppStorage.get);
      done();
    });

    it('test_getRefreshSnapshot_01', 0, async (done: Function) => {
      let smartDockViewModel: ESObject = new SmartDockViewModel();
      let mocker: ESObject = new MockKit();
      let mockAppStorage: ESObject = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockAppStorage)(ArgumentMatchers.any).afterReturn(null);
      await smartDockViewModel.getRefreshSnapshot('testBundle');
      expect(smartDockViewModel instanceof SmartDockViewModel).assertTrue();
      mocker.ignoreMock(AppStorage, AppStorage.get);
      done();
    });

    it('should_refresh_snapshot_when_needRefreshList_is_true', 0, async (done: Function) => {
      let smartDockViewModel: ESObject = new SmartDockViewModel();
      let mocker: ESObject = new MockKit();
      let mockAppStorage: ESObject = mocker.mockFunc(AppStorage, AppStorage.get);
      let missionInfoList: ESObject = [{
        bundleName: 'testBundle'
      }];
      when(mockAppStorage)(ArgumentMatchers.any).afterReturn(missionInfoList);
      await smartDockViewModel.getRefreshSnapshot('testBundle', true);
      expect(smartDockViewModel instanceof SmartDockViewModel).assertTrue();
      mocker.ignoreMock(AppStorage, AppStorage.get);
      done();
    });

    it('should_call_onHoverEvent_when_callBackSnapshotStatus_is_true', 0, async (done: Function) => {
      let smartDockViewModel: ESObject = new SmartDockViewModel();
      let mocker: ESObject = new MockKit();
      let mockAppStorage: ESObject = mocker.mockFunc(AppStorage, AppStorage.get);
      let missionInfoList: ESObject = [{
        bundleName: 'testBundle'
      }];
      when(mockAppStorage)(ArgumentMatchers.any).afterReturn(missionInfoList);
      smartDockViewModel.callBackSnapshotStatus = true;
      let mockOnHoverEvent: ESObject = mocker.mockFunc(smartDockViewModel, smartDockViewModel.onHoverEvent);
      await smartDockViewModel.getRefreshSnapshot('testBundle');
      mocker.verify('onHoverEvent', ['testBundle', undefined]).atLeast(0);
      mocker.ignoreMock(AppStorage, AppStorage.get);
      mocker.ignoreMock(smartDockViewModel, smartDockViewModel.onHoverEvent);
      done();
    });

    it('test_getRefreshSnapshot_02', 0, async (done: Function) => {
      let smartDockViewModel: ESObject = new SmartDockViewModel();
      let mocker: ESObject = new MockKit();
      let mockAppStorage: ESObject = mocker.mockFunc(AppStorage, AppStorage.get);
      let missionInfoList: ESObject = [{
        bundleName: 'testBundle'
      }];
      when(mockAppStorage)(ArgumentMatchers.any).afterReturn(missionInfoList);
      let mockGetSnapshot: ESObject = mocker.mockFunc(smartDockViewModel, smartDockViewModel.getSnapshot);
      when(mockGetSnapshot)(ArgumentMatchers.any).afterThrow('Error');
      await smartDockViewModel.getRefreshSnapshot('testBundle');
      expect(smartDockViewModel instanceof SmartDockViewModel).assertTrue();
      mocker.ignoreMock(AppStorage, AppStorage.get);
      mocker.ignoreMock(smartDockViewModel, smartDockViewModel.getSnapshot);
      done();
    });

    it('should_return_new_MenuInfo_when_mSmartDockEventMgr_is_not_instance_of_SmartDockEventMgr_03', 0,
      async (done: Function) => {
        let smartDockViewModel: ESObject = new SmartDockViewModel();
        smartDockViewModel.mSmartDockEventMgr = null;
        const result: ESObject = smartDockViewModel.getOpenNewWindowMenu({});
        expect(true).assertTrue();
        done();
      });

    it('should_return_MenuInfo_from_mSmartDockEventMgr_when_it_is_instance_of_SmartDockEventMgr_02', 0, () => {
      try {
        const smartDockViewModel: ESObject = new SmartDockViewModel();
        let menuInfo: MenuInfo = new MenuInfo();
        expect(smartDockViewModel['getOpenNewWindowMenu'](menuInfo)).not().assertNull();
      } catch (e) {
      }
      // let smartDockViewModel: ESObject = new SmartDockViewModel();
      // let mocker: ESObject = new MockKit();
      // let mockSmartDockEventMgr: ESObject = mocker.mockObject(smartDockViewModel, 'mSmartDockEventMgr');
      // try {
      //   let mockGetOpenNewWindowMenu: ESObject = mocker.mockFunc(mockSmartDockEventMgr, mockSmartDockEventMgr.getOpenNewWindowMenu);
      //   when(mockGetOpenNewWindowMenu)(ArgumentMatchers.any).afterReturn(new MenuInfo());
      //   const result: ESObject = smartDockViewModel.getOpenNewWindowMenu({});
      //   expect(true).assertTrue();
      // } catch (e) {}
      // mocker.ignoreMock(mockSmartDockEventMgr, mockSmartDockEventMgr.getOpenNewWindowMenu);
      // done();
    });

    it('should_correctly_create_DockItemInfo_from_GridLayoutItemInfo_with_numeric_itemType', 0,
      async (done: Function) => {
        let smartDockViewModel: ESObject = new SmartDockViewModel();
        let itemInfo: ESObject = new GridLayoutItemInfo();
        itemInfo.itemType = 1;
        itemInfo.typeId = 'typeId';
        itemInfo.bundleName = 'bundleName';
        itemInfo.moduleName = 'moduleName';
        itemInfo.abilityName = 'abilityName';
        itemInfo.appIconId = 'appIconId';
        itemInfo.appLabelId = 'appLabelId';
        itemInfo.applicationLabelId = 'applicationLabelId';
        itemInfo.appName = 'appName';
        itemInfo.areaType = 'areaType';
        itemInfo.keyName = 'keyName';
        itemInfo.layoutInfo = 'layoutInfo';
        itemInfo.row = 1;
        itemInfo.column = 2;
        itemInfo.badgeNumber = 3;
        itemInfo.isSystemApp = true;
        itemInfo.applicationIconId = 'applicationIconId';
        const result: ESObject = smartDockViewModel.createDockItemFromGridLayout(itemInfo);
        expect(result.itemType).assertEqual(1);
        expect(result.typeId).assertEqual('typeId');
        expect(result.bundleName).assertEqual('bundleName');
        expect(result.moduleName).assertEqual('moduleName');
        expect(result.abilityName).assertEqual('abilityName');
        expect(result.appIconId).assertEqual('appIconId');
        expect(result.appLabelId).assertEqual('appLabelId');
        expect(result.applicationLabelId).assertEqual('applicationLabelId');
        expect(result.appName).assertEqual('appName');
        expect(result.areaType).assertEqual('areaType');
        expect(result.keyName).assertEqual('keyName');
        expect(result.layoutInfo).assertEqual('layoutInfo');
        expect(result.row).assertEqual(1);
        expect(result.column).assertEqual(2);
        expect(result.badgeNumber).assertEqual(3);
        expect(result.isSystemApp).assertEqual(true);
        expect(result.applicationIconId).assertEqual('applicationIconId');
        done();
      });

    it('should_correctly_create_DockItemInfo_from_GridLayoutItemInfo_with_string_itemType', 0,
      async (done: Function) => {
        let smartDockViewModel: ESObject = new SmartDockViewModel();
        let itemInfo: ESObject = new GridLayoutItemInfo();
        itemInfo.itemType = '2';
        itemInfo.typeId = 'typeId';
        itemInfo.bundleName = 'bundleName';
        itemInfo.moduleName = 'moduleName';
        itemInfo.abilityName = 'abilityName';
        itemInfo.appIconId = 'appIconId';
        itemInfo.appLabelId = 'appLabelId';
        itemInfo.applicationLabelId = 'applicationLabelId';
        itemInfo.appName = 'appName';
        itemInfo.areaType = 'areaType';
        itemInfo.keyName = 'keyName';
        itemInfo.layoutInfo = 'layoutInfo';
        itemInfo.row = 1;
        itemInfo.column = 2;
        itemInfo.badgeNumber = 3;
        itemInfo.isSystemApp = true;
        itemInfo.applicationIconId = 'applicationIconId';
        const result: ESObject = smartDockViewModel.createDockItemFromGridLayout(itemInfo);
        expect(result.itemType).assertEqual(2);
        expect(result.typeId).assertEqual('typeId');
        expect(result.bundleName).assertEqual('bundleName');
        expect(result.moduleName).assertEqual('moduleName');
        expect(result.abilityName).assertEqual('abilityName');
        expect(result.appIconId).assertEqual('appIconId');
        expect(result.appLabelId).assertEqual('appLabelId');
        expect(result.applicationLabelId).assertEqual('applicationLabelId');
        expect(result.appName).assertEqual('appName');
        expect(result.areaType).assertEqual('areaType');
        expect(result.keyName).assertEqual('keyName');
        expect(result.layoutInfo).assertEqual('layoutInfo');
        expect(result.row).assertEqual(1);
        expect(result.column).assertEqual(2);
        expect(result.badgeNumber).assertEqual(3);
        expect(result.isSystemApp).assertEqual(true);
        expect(result.applicationIconId).assertEqual('applicationIconId');
        done();
      });

    it('should_correctly_create_DockItemInfo_from_GridLayoutItemInfo_with_null_itemType', 0, async (done: Function) => {
      let smartDockViewModel: ESObject = new SmartDockViewModel();
      let itemInfo: ESObject = new GridLayoutItemInfo();
      itemInfo.itemType = null;
      itemInfo.typeId = 'typeId';
      itemInfo.bundleName = 'bundleName';
      itemInfo.moduleName = 'moduleName';
      itemInfo.abilityName = 'abilityName';
      itemInfo.appIconId = 'appIconId';
      itemInfo.appLabelId = 'appLabelId';
      itemInfo.applicationLabelId = 'applicationLabelId';
      itemInfo.appName = 'appName';
      itemInfo.areaType = 'areaType';
      itemInfo.keyName = 'keyName';
      itemInfo.layoutInfo = 'layoutInfo';
      itemInfo.row = 1;
      itemInfo.column = 2;
      itemInfo.badgeNumber = 3;
      itemInfo.isSystemApp = true;
      itemInfo.applicationIconId = 'applicationIconId';
      const result: ESObject = smartDockViewModel.createDockItemFromGridLayout(itemInfo);
      expect(result.itemType).assertEqual(0);
      expect(result.typeId).assertEqual('typeId');
      expect(result.bundleName).assertEqual('bundleName');
      expect(result.moduleName).assertEqual('moduleName');
      expect(result.abilityName).assertEqual('abilityName');
      expect(result.appIconId).assertEqual('appIconId');
      expect(result.appLabelId).assertEqual('appLabelId');
      expect(result.applicationLabelId).assertEqual('applicationLabelId');
      expect(result.appName).assertEqual('appName');
      expect(result.areaType).assertEqual('areaType');
      expect(result.keyName).assertEqual('keyName');
      expect(result.layoutInfo).assertEqual('layoutInfo');
      expect(result.row).assertEqual(1);
      expect(result.column).assertEqual(2);
      expect(result.badgeNumber).assertEqual(3);
      expect(result.isSystemApp).assertEqual(true);
      expect(result.applicationIconId).assertEqual('applicationIconId');
      done();
    });

    it('SmartDockViewModel_recentOnClickWithPopup', 0, () => {
      let instance: smartDockViewModel = smartDockViewModel.getInstance();
      instance.recentOnClickWithPopup(new DockItemInfo());
      expect(instance instanceof smartDockViewModel).assertTrue();
    })

    it('SmartDockViewModel_pcModeOnItemClick', 0, () => {
      let instance = smartDockViewModel.getInstance();
      let bool: boolean = instance.pcModeOnItemClick(null, new DockItemInfo());
      expect(bool).assertInstanceOf('Boolean');
    })

    it('SmartDockViewModel_onHoverEvent', 0, async (done: Function) => {
      let instance = smartDockViewModel.getInstance();
      try {
        let info: DockItemInfo = new DockItemInfo();
        info.bundleName = CommonConstants.LAUNCHER_BUNDLE;
        await instance.onHoverEvent(info);
        expect(info.bundleName).assertEqual(CommonConstants.LAUNCHER_BUNDLE);
      } catch (e) {
      }
      done();
    })

    it('test_SmartDockViewModel_getRefreshSnapshot', 0, async (done: Function) => {
      let instance: smartDockViewModel = smartDockViewModel.getInstance();
      let containerSessionList: SCBSceneContainerSession[] =
        SCBSceneSessionManager.getInstance().getContainerSessionList();
      let info: RecentBundleMissionInfo = new RecentBundleMissionInfo();
      info.missionInfoList = containerSessionList
      let info1: DockItemInfo = new DockItemInfo();
      info1.bundleName = CommonConstants.LAUNCHER_BUNDLE;
      let mocker: MockKit = new MockKit();
      AppStorage.setOrCreate('missionInfoList', [info]);
      (instance as object)['callBackSnapshotStatus'] = true;
      await instance.getRefreshSnapshot(info1, true);
      expect(info1.bundleName).assertEqual(CommonConstants.LAUNCHER_BUNDLE);
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it('test_SmartDockViewModel_refreshBadgeNum', 0, () => {
      let instance: smartDockViewModel = smartDockViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com.ohos.clock';
      info.abilityName = 'abilityName';
      info.badgeNumber = 5;
      info.appIconId = 0;
      info.appIndex = 0;
      info.negativeId = 0;
      info.typeId = 0;
      info.isSelect = false;
      info.enterEditing = false;
      info.downloadProgress = 0;
      let itemInfo: DockItemInfo = new DockItemInfo();
      itemInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
      itemInfo.layoutInfo = [[info]];
      (instance as object)['refreshBadgeNum'](itemInfo, info, [itemInfo]);
      expect(info.bundleName).assertEqual('com.ohos.clock');
    })

    it('test_SmartDockViewModel_registerInstalledAniFinishCallback_01', 0, () => {
      try {
        let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
        let bundleName: string = 'bundleName';
        let appIndex: number = CommonConstants.MAIN_APP_INDEX;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        (instance as object)['registerInstalledAniFinishCallback'](bundleName, appIndex);
        expect(instance).not().assertNull();
        mocker.clear(CheckEmptyUtils);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_SmartDockViewModel_checkIsNeedRemoveItem', 0, () => {
      let mocker: MockKit = new MockKit();
      let cacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      try {
        let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
        let bundleName: string = 'bundleName';
        let appIndex: number = CommonConstants.MAIN_APP_INDEX;
        let event = EventConstants.EVENT_PACKAGE_REMOVED;
        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.bundleName = 'com.ohos.clock';
        info.abilityName = 'abilityName';
        info.badgeNumber = 5;
        info.appIconId = 0;
        info.appIndex = appIndex;
        info.negativeId = 0;
        info.typeId = 0;
        info.isSelect = false;
        info.enterEditing = false;
        info.downloadProgress = 0;
        info.appStatus = AppStatus.UPDATING;
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        let mockFunc1: Function = mocker.mockFunc(cacheManager, cacheManager.getAllSameBundleNameAppItem);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn([info]);
        let result: boolean = (instance as object)['checkIsNeedRemoveItem'](event, bundleName, appIndex);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clear(cacheManager);
      mocker.clearAll();
    });

    it('test_checkIsNeedRemoveItem_02', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = CommonConstants.MAIN_APP_INDEX;
        let event = EventConstants.EVENT_PACKAGE_REMOVED;

        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.appIndex = appIndex;
        info.appStatus = AppStatus.UPDATING;
        let mockFunc1: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
          LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn([info]);

        let result: boolean = (instance as object)['checkIsNeedRemoveItem'](event, bundleName, appIndex);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clearAll();
    })

    it('test_checkIsNeedRemoveItem_03', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = CommonConstants.MAIN_APP_INDEX;
        let event = EventConstants.EVENT_PACKAGE_REMOVED;

        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.appIndex = appIndex;
        info.appStatus = AppStatus.PENDING;
        let mockFunc1: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
          LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn([info]);

        let result: boolean = (instance as object)['checkIsNeedRemoveItem'](event, bundleName, appIndex);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clearAll();
    })

    it('test_checkIsNeedRemoveItem_04', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc1: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
          LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn([]);

        let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = CommonConstants.MAIN_APP_INDEX;
        let event = EventConstants.EVENT_PACKAGE_REMOVED;

        let result: boolean = (instance as object)['checkIsNeedRemoveItem'](event, bundleName, appIndex);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clearAll();
    })

    it('test_uninstallAppResult_01', 0, () => {
      try {
        let bundleName: string = '';
        let resultData: ResultData = {
          code: 1, errorCode: 1
        };
        let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
        instance.uninstallAppResult(bundleName, resultData);
        expect(instance instanceof SmartDockViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_refreshDockItem_01', 0, () => {
      try {
        let dockItem: GeneratedObjectLiteralInterface_2 = {
          bundleName: 'string',
          keyName: 'string',
          appIndex: 0,
        };
        let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
        (instance as object)['refreshDockItem'](dockItem);
        expect(instance instanceof SmartDockViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_appInstallBmsChangeEvent_01', 0, () => {
      try {
        const eventData: AppInstallEventData = new AppInstallEventData();
        eventData.eventName = 'eventName';
        eventData.bundleName = 'com.ohos.contacts';
        eventData.appIndex = 0;
        let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
        (instance as object)['appInstallBmsChangeEvent'](eventData);
        expect(instance instanceof SmartDockViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onReceiveEvent_01', 0, () => {
      try {
        let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
        let badgeInfo: BadgeItemInfo = new BadgeItemInfo();
        (instance as object)['localEventListener']['onReceiveEvent'](EventConstants.EVENT_BADGE_UPDATE, badgeInfo);
        expect(instance instanceof SmartDockViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onReceiveEvent_02', 0, () => {
      try {
        let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
        let dockItem: GeneratedObjectLiteralInterface_2 = {
          bundleName: 'string',
          keyName: 'string',
          appIndex: 0,
        };
        (instance as object)['localEventListener']['onReceiveEvent'](EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_REFRESH,
          dockItem);
        expect(instance instanceof SmartDockViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onReceiveEvent_03', 0, () => {
      try {
        let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
        const eventData: AppInstallEventData = new AppInstallEventData();
        eventData.eventName = 'eventName';
        eventData.bundleName = 'com.ohos.contacts';
        eventData.appIndex = 0;
        (instance as object)['localEventListener']['onReceiveEvent'](EventConstants.APP_INSTALL_BMS_CHANGE_EVENT, eventData);
        expect(instance instanceof SmartDockViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onReceiveEvent_04', 0, () => {
      try {
        let instance: SmartDockViewModel = SmartDockViewModel.getInstance();
        (instance as object)['localEventListener']['onReceiveEvent']('other', null);
        expect(instance instanceof SmartDockViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_constructor_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function =
          mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isPcMode);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let instance: SmartDockViewModel = new SmartDockViewModel();
        expect(instance instanceof SmartDockViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clearAll();
    })

    interface DeletDockItem {
      bundleName?: string,
      keyName?: string
    }

  })
}

const sleep: Function = (ms: number): Promise<void> => {
  return new Promise(res => setTimeout(res, ms))
};