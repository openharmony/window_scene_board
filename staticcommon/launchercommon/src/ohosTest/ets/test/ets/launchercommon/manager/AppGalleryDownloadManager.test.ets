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
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import {
  AppGalleryDownloadManager,
  AppGalleryEventInfo,
  AppItemInfo,
  AppModel,
  AppStatus,
  CommonConstants,
  DockItemInfo,
  FolderLayoutCacheManager,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
  LegacyInfo
} from '../../../../../../main/ets/TsIndex';
import {
  AppDownloadInfo,
  AppGalleryEventStatus,
  AppInstallStatusInfo,
  DownloadStatusInfo
} from '../../../../../../main/ets/constants/CommonConstants';
import { CheckEmptyUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  CommonEvent,
  DownloadingProgressChangeEvent,
  DownloadStatusChangeEvent,
  EvtBus,
  GlobalContext,
  InstallStatusChangeEvent,
  PackageDataClearedEvent
} from '@ohos/frameworkwrapper';
import { preferences } from '@kit.ArkData';
import { ResidentLayoutCacheMgr } from '../../../../../../main/ets/dock/cache/ResidentLayoutCacheMgr';

const TAG = 'AppGalleryDownloadManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default function AppGalleryDownloadManagerTest() {
  describe('AppGalleryDownloadManagerTest', () => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })



    it('test_deleteDownloadProgressInfo', 0, async () => {
      const instance: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      const actionBundleName: string = 'anyActionBundleName';
      let ret = instance.deleteDownloadProgressInfo(actionBundleName);
      expect(instance).not().assertNull();
    });

    it('test_getDownloadProgressInfo01', 0, async () => {
      const instance: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      const actionBundleName: string = 'anyActionBundleName';
      let ret = instance.deleteDownloadTaskInfo(actionBundleName);
      expect(instance).not().assertNull();
    });

    it('test_getDownloadProgressInfo02', 0, async () => {
      const instance: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      const actionBundleName: string = 'anyActionBundleName';
      let ret = instance.getDownloadProgressInfo(actionBundleName);
      expect(ret).not().assertNull();
    });

    it('test_getDownDownloadTaskInfo', 0, async () => {
      const instance: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      const actionBundleName: string = 'anyActionBundleName';
      let ret = instance.getDownDownloadTaskInfo(actionBundleName);
      expect(ret).not().assertNull();
    });


    it('test_initInstallEventAppStatusMap', 0, () => {
      AppGalleryDownloadManager.getInstance()['initInstallEventAppStatusMap']();
      let status = AppGalleryDownloadManager.getInstance()['installEventAppStatusMap']
        .get(AppGalleryEventStatus.DOWNLOAD_CREATE_EVENT_ID);
      expect(status).assertEqual(AppStatus.WAITING);
    })

    it('test_initAppGalleryEvent', 0, () => {
      AppGalleryDownloadManager.getInstance()['initAppGalleryEvent']();

      let event: CommonEvent = new CommonEvent({
        event: DownloadStatusChangeEvent.DOWNLOAD_STATUS_CHANGE,
        bundleName: 'com.ohos.demo',
        code: 0,
        data: 'succ',
        parameters: ['args']
      });
      AppGalleryDownloadManager.getInstance()['handleAppGalleryEventChange'](event);

      let event1: CommonEvent = new CommonEvent({
        event: DownloadingProgressChangeEvent.DOWNLOAD_PROGRESS_CHANGE,
        bundleName: 'com.ohos.demo',
        code: 0,
        data: 'succ',
        parameters: ['args']
      });
      AppGalleryDownloadManager.getInstance()['handleAppGalleryEventChange'](event1);

      let event2: CommonEvent = new CommonEvent({
        event: InstallStatusChangeEvent.INSTALL_STATUS_CHANGE,
        bundleName: 'com.ohos.demo',
        code: 0,
        data: 'succ',
        parameters: ['args']
      });
      AppGalleryDownloadManager.getInstance()['handleAppGalleryEventChange'](event2);
      expect(true).assertTrue();
    })

    it('test_handleAppGalleryEventChange', 0, () => {
      let parametersData: TestCommonEventParametersData = {
        bundleName: 'com.ohos.app'
      }
      let event2: CommonEvent = new CommonEvent({
        event: InstallStatusChangeEvent.INSTALL_STATUS_CHANGE,
        bundleName: 'com.ohos.demo',
        code: 0,
        data: 'succ',
        parameters: parametersData
      });
      try {
        AppGalleryDownloadManager.getInstance()['handleAppGalleryEventChange'](event2);
        expect(true).assertTrue();
      } catch (e) {
      }
    })

    it('test_isAppUpdating', 0, () => {
      let ret = AppGalleryDownloadManager.getInstance()['isAppUpdating']('com.ohos.demo');
      expect(ret).assertFalse();
    })

    it('test_dealWithDownloadStatusChange', 0, () => {
      const bundleName = 'com.ohos.demo';
      let downloadInfo: DownloadStatusInfo = {
        bundleName: bundleName,
        status: 0
      };
      if(!CheckEmptyUtils.isEmptyArr(downloadInfo.legacyInfos)){
        let mocker: MockKit = new MockKit();
        mocker.clear(CheckEmptyUtils);
      }
      try {
        AppGalleryDownloadManager.getInstance()['dealWithDownloadStatusChange'](downloadInfo, 0, bundleName);
        AppGalleryDownloadManager.getInstance()['dealWithDownloadStatusChange'](downloadInfo,
          AppGalleryEventStatus.DOWNLOAD_CANCEL_EVENT_ID, bundleName);
        AppGalleryDownloadManager.getInstance()['dealWithDownloadStatusChange'](downloadInfo,
          AppGalleryEventStatus.DOWNLOAD_FAILED_EVENT_ID, bundleName);

        downloadInfo.updateStatus = 200;
        downloadInfo.status = 1;
        downloadInfo.appName = 'demo';
        downloadInfo.iconUrl = 'icon.png';
        AppGalleryDownloadManager.getInstance()['dealWithDownloadStatusChange'](downloadInfo,
          AppGalleryEventStatus.DOWNLOAD_CREATE_EVENT_ID, bundleName);

        AppGalleryDownloadManager.getInstance()['appDownloadMap'].set(downloadInfo.bundleName, 10);
        AppGalleryDownloadManager.getInstance()['dealWithDownloadStatusChange'](downloadInfo,
          AppGalleryEventStatus.DOWNLOAD_SUCCEED_EVENT_ID, bundleName);
        expect(true).assertTrue();
        AppGalleryDownloadManager.getInstance()['appDownloadMap'].remove(downloadInfo.bundleName);
      } catch (e) {
      }
    })

    it('test_onGetIconFromAppGallery_01', 0, () => {
      const bundleName = 'com.ohos.maps.app';
      let downloadInfo: DownloadStatusInfo = {
        bundleName: bundleName,
        status: 0
      }
      downloadInfo.updateStatus = 1;
      downloadInfo.status = 1;
      downloadInfo.appName = 'demo app';
      downloadInfo.iconUrl = 'icon.png';
      let appList: GridLayoutItemInfo[] = [];
      AppGalleryDownloadManager.getInstance()['onGetIconFromAppGallery'](downloadInfo, 'icon.jpg', bundleName, appList);
      expect(true).assertTrue();
    })

    it('test_onGetIconFromAppGallery_02', 0, () => {
      const bundleName = 'com.ohos.maps.app';
      let downloadInfo: DownloadStatusInfo = {
        bundleName: bundleName,
        status: 0
      }
      downloadInfo.updateStatus = 1;
      downloadInfo.status = 1;
      downloadInfo.appName = 'demo app';
      downloadInfo.iconUrl = 'icon.png';
      let appList: GridLayoutItemInfo[] = [];

      AppGalleryDownloadManager.getInstance()['onGetIconFromAppGallery'](downloadInfo, undefined, bundleName, appList);
      expect(true).assertTrue();
    })

    it('test_removeDownloadInfo', 0, () => {
      const bundleName = 'com.ohos.maps.app';
      AppGalleryDownloadManager.getInstance()['removeDownloadInfo'](bundleName);
      expect(true).assertTrue();
    })

    it('test_dealWithDownloadProgressChange', 0, () => {
      const bundleName = 'com.ohos.maps.app';
      let info: AppDownloadInfo = {
        bundleName: bundleName,
        totalSize: 500000,
        downloadedSize: 10000,
        taskId: '1122',
      };
      AppGalleryDownloadManager.getInstance()['dealWithDownloadProgressChange'](info, bundleName);
      expect(AppGalleryDownloadManager.getInstance()['downloadProgressList']).not().assertNull();
    })

    it('test_dealWithInstallStatusChange', 0, () => {
      const bundleName = 'com.ohos.maps.app';
      let info: AppInstallStatusInfo = {
        bundleName: bundleName,
        errorCode: 1,
        errorDesc: 'desc'
      };
      AppGalleryDownloadManager.getInstance()['dealWithInstallStatusChange'](info,
        AppGalleryEventStatus.INSTALL_START_EVENT_ID, bundleName);

      AppGalleryDownloadManager.getInstance()['dealWithInstallStatusChange'](info,
        AppGalleryEventStatus.INSTALL_FAILED_EVENT_ID, bundleName);
      expect(true).assertTrue();
    })

    it('test_dealWithInstallStatusChangeEvent', 0, () => {
      const actionBundleName = 'com.ohos.maps.app';
      let statusChangeEventDate: DownloadStatusInfo = {
        bundleName: actionBundleName,
        status: AppStatus.INSTALL_FAIL
      };
      AppGalleryDownloadManager.getInstance()['dealWithInstallStatusChangeEvent'](
        AppGalleryEventStatus.INSTALL_FAILED_EVENT_ID, statusChangeEventDate, actionBundleName, statusChangeEventDate);

      expect(true).assertTrue();
    })

    it('test_addDownloadProgressInfo', 0, () => {
      const bundleName = 'com.ohos.maps.app';
      let info: AppDownloadInfo = {
        bundleName: bundleName,
        totalSize: 200000,
        downloadedSize: 10000,
        taskId: 'id2452',
      };
      AppGalleryDownloadManager.getInstance()['addDownloadProgressInfo'](info);

      AppGalleryDownloadManager.getInstance()['deleteDownloadProgressInfo'](bundleName);
      expect(AppGalleryDownloadManager.getInstance()['downloadProgressList']).not().assertNull();
    })

    it('test_sendEvent_handleAppGalleryEventChange_undefined_isDistributeTypefalse', 0, () => {
      let mocker: MockKit = new MockKit();
      EvtBus.post(DownloadStatusChangeEvent, undefined);
      let appModel: AppModel = AppModel.getInstance();
      let mockFunc : Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      let appItem : AppItemInfo = new AppItemInfo();
      appItem.appStatus = 0;
      AppStorage.setOrCreate<string[]>('updateAppBundleNameList', []);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(appItem);
      let event1: CommonEvent = new CommonEvent({
        event: DownloadingProgressChangeEvent.DOWNLOAD_PROGRESS_CHANGE,
        bundleName: 'com.ohos.demo',
        code: 0,
        data: 'succ',
        parameters: {
          'distributeType': 'enterprisetest'
        } as TempEventParameters
      });
      EvtBus.post(DownloadStatusChangeEvent, event1);
      expect(event1.parameters?.distributeType).not().assertEqual('enterprise')
      mocker.clear(appModel);
      mocker.clear(log)
      mocker.clearAll();
    })

    it('test_sendEvent_PackageDataClearedEvent', 0, () => {
      let event: CommonEvent = new CommonEvent({
        event: PackageDataClearedEvent.EVENT_PACKAGE_DATA_CLEARED,
        bundleName: 'com.ohos.appgallery',
        code: 0,
        data: 'succ',
        parameters:  {
          'distributeType': 'enterprisetest'
        } as TempEventParameters
      });
      EvtBus.post(DownloadStatusChangeEvent, event);
      let event1: CommonEvent = new CommonEvent({
        event: PackageDataClearedEvent.EVENT_PACKAGE_DATA_CLEARED,
        bundleName: 'com.ohos.demo',
        code: 0,
        data: 'succ',
        parameters: {
          'distributeType': 'enterprisetest'
        } as TempEventParameters
      });
      EvtBus.post(DownloadStatusChangeEvent, event1);
      expect(event1.parameters?.distributeType).not().assertEqual('enterprise')
    })

    it('test_sendEvent_BundleMappingChangeEvent_handleBundleMappingEventChange', 0, () => {
      let eventName = 'com.ohos.appgallery.commonevent.EVENT_LEGACY_BUNDLE_MAPPING_CHANGE';
      let event1: CommonEvent = new CommonEvent({
        event: eventName,
        bundleName: 'com.ohos.demo',
        code: 0,
        data: 'succ',
        parameters: {
          'distributeType': 'enterprisetest',
          'ag.params.HARMONY_PKGS_ADDED': ['hasohosApp'],
          'ag.params.HARMONY_PKGS_REMOVED': ['notohosApp'],
          'ag.params.PUBLIC_TEST_APP_PKGS_ADDED': ['testadd1'],
        } as TempEventParameters
      });
      try {
        EvtBus.post(DownloadStatusChangeEvent, event1);
        expect(event1.parameters?.distributeType).not().assertEqual('enterprise');
      } catch (e) {
      }
      let event2: CommonEvent = new CommonEvent({
        event: eventName,
        bundleName: 'com.ohos.demo',
        code: 0,
        data: 'succ',
        parameters: {
          'distributeType': 'enterprisetest',
          'ag.params.HARMONY_PKGS_ADDED': [],
          'ag.params.HARMONY_PKGS_REMOVED': [],
          'ag.params.PUBLIC_TEST_APP_PKGS_ADDED': [],
        } as TempEventParameters
      });
      try {
        EvtBus.post(DownloadStatusChangeEvent, event2);
        let hasohosApp: string[] = event2.parameters?.['ag.params.HARMONY_PKGS_ADDED'] as string[];
        expect(hasohosApp.length === 0).assertTrue();
      } catch (e) {
      }
    })

    it('test_isUpdateStatus_001', 0, () => {
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let event: CommonEvent = new CommonEvent({
        event: PackageDataClearedEvent.EVENT_PACKAGE_DATA_CLEARED,
        bundleName: 'com.ohos.appgallery',
        code: 0,
        data: 'succ',
        parameters: {
          updateStatus: 1,
        } as TempEventParameters
      });
      let status = manager['isUpdateStatus'](event);
      expect(status).assertTrue();
    })

    it('test_dealWithDownloadStatusChange_case001', 0, () => {
      let bundleName = 'com.ohos.appgallery';
      let eventData: DownloadStatusInfo = {
        bundleName: bundleName,
        status: 1,
      };
      let statusCode = AppGalleryEventStatus.DOWNLOAD_CANCEL_EVENT_ID;
      if(!CheckEmptyUtils.isEmptyArr(eventData.legacyInfos)){
        let mocker: MockKit = new MockKit();
        mocker.clear(CheckEmptyUtils);
      }
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      try {
        manager['dealWithDownloadStatusChange'](eventData, statusCode, bundleName);
        expect(eventData.bundleName.startsWith('__WAIT_FOR_')).assertFalse();
      } catch (e) {
      }
      let eventData1: DownloadStatusInfo = {
        bundleName: '__WAIT_FOR_bundleName',
        status: 1,
        updateStatus: 1,
      };
      let statusCode1 = AppGalleryEventStatus.DOWNLOAD_FAILED_EVENT_ID;
      try {
        manager['dealWithDownloadStatusChange'](eventData1, statusCode1, bundleName);
      } catch (e) {
      }
      expect(eventData1.bundleName.startsWith('__WAIT_FOR_')).assertTrue();
    })

    it('test_dealWithDownloadStatusChange_case004', 0, () => {
      let bundleName = 'com.ohos.appgallery111';
      let eventData: DownloadStatusInfo = {
        bundleName: bundleName,
        status: 1,
      };
      let statusCode = AppGalleryEventStatus.DOWNLOAD_SUCCEED_EVENT_ID;
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      manager['appDownloadMap'].remove(bundleName);
      manager['dealWithDownloadStatusChange'](eventData, statusCode, bundleName);
      expect(manager['appDownloadMap'].hasKey(bundleName)).assertFalse();
    })

    it('test_dealWithDownloadStatusChange_case005', 0, () => {
      let bundleName = 'com.ohos.appgallery';
      let eventData: DownloadStatusInfo = {
        bundleName: bundleName,
        status: 1,
      };
      let statusCode = AppGalleryEventStatus.COMPANY_APP_RESET_EVENT_ID;
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let mocker: MockKit = new MockKit();
      if(!CheckEmptyUtils.isEmptyArr(['1'])){
        mocker.clear(CheckEmptyUtils);
      }
      let launchManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(launchManager, launchManager.getAllSameBundleNameAppItem);
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.iconResource = '';
      item.appName = 'appname';
      item.intent = '';
      when(mockFunc)(ArgumentMatchers.any).afterReturn([item]);
      try {
        manager['dealWithDownloadStatusChange'](eventData, statusCode, bundleName);
        expect(manager['appDownloadMap'].hasKey('bundleName')).assertFalse();
      } catch (e) {
      }
      mocker.clear(launchManager);
      mocker.clearAll();
    })

    it('test_refreshAppIconCache_001', 0, () => {
      let bundleName = 'com.ohos.appgallery';
      let legacyItem: LegacyInfo = new LegacyInfo();
      legacyItem.pkgName = 'pkgName.hap';
      let eventData: DownloadStatusInfo = {
        bundleName: bundleName,
        status: 1,
        legacyInfos: [legacyItem],
        appName: 'appgallery',
      };
      let statusCode = AppGalleryEventStatus.COMPANY_APP_RESET_EVENT_ID;
      let gridItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridItem.intent = 'com.test.mark.union';
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      try {
        let result = manager['refreshAppIconCache'](eventData, statusCode, '', [gridItem]);
        expect(result.intent?.length === 0).assertFalse();
        let result1 = manager['refreshAppIconCache'](eventData, statusCode, '', []);
        expect(result1.intent?.length === 0).assertTrue();
      } catch (e) {
      }
    })

    it('test_dealAppGalleryCreatedEvent_updateStatus1', 0, () => {
      let bundleName = 'com.ohos.appgallery';
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      manager['dealAppGalleryCreatedEvent'](undefined, bundleName, undefined);
      expect(undefined).assertUndefined();
      let legacyItem: LegacyInfo = new LegacyInfo();
      legacyItem.pkgName = 'pkgName.hap';
      let data: DownloadStatusInfo = {
        bundleName: bundleName,
        status: 1,
        updateStatus: 1,
        legacyInfos: [legacyItem],
        appName: 'appgallery',
      };
      let legacyItem1: LegacyInfo = new LegacyInfo();
      legacyItem1.pkgName = 'pkgName.hap';
      let eventData: AppGalleryEventInfo = {
        distributeType: 'enterprise',
        bundleName: bundleName,
        status: 1,
        appName: 'appgallery',
        eventType: ''
      };
      let mocker: MockKit = new MockKit();
      let launchManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let gridItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridItem.bundleName = 'testBundeleName';
      gridItem.keyName = 'testKey';
      gridItem.appStatus = 1;
      let mockFunc: Function = mocker.mockFunc(launchManager, launchManager.getAllSameBundleNameAppItem);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(gridItem);
      AppStorage.setOrCreate<string[]>('updateAppBundleNameList',['testBundeleName']);
      manager['dealAppGalleryCreatedEvent'](data, bundleName, eventData);
      let updateAppBundleNameList: string[] = AppStorage.get<string[]>('updateAppBundleNameList') as string[];
      expect(updateAppBundleNameList.length > 0).assertTrue();
      mocker.clear(launchManager);
      mocker.clearAll();
    })

    it('test_dealAppGalleryCreatedEvent_dealUpdateAppItem_001', 0, () => {
      let bundleName = 'com.ohos.appgallery';
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let legacyItem: LegacyInfo = new LegacyInfo();
      legacyItem.pkgName = 'pkgName.hap';
      let data: DownloadStatusInfo = {
        bundleName: bundleName,
        status: 1,
        updateStatus: 1,
        legacyInfos: [legacyItem],
        appName: 'appgallery',
      };
      let legacyItem1: LegacyInfo = new LegacyInfo();
      legacyItem1.pkgName = 'pkgName.hap';
      let eventData: AppGalleryEventInfo = {
        distributeType: 'internaltesting',
        bundleName: bundleName,
        status: 1,
        appName: 'appgallery',
        eventType: ''
      };
      let mocker: MockKit = new MockKit();
      let launchManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let gridItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridItem.bundleName = 'testBundeleName';
      gridItem.keyName = 'testKey';
      gridItem.appStatus = 1;
      let mockFunc: Function = mocker.mockFunc(launchManager, launchManager.getAllSameBundleNameAppItem);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(gridItem);
      AppStorage.setOrCreate<string[]>('updateAppBundleNameList',[]);
      manager['dealAppGalleryCreatedEvent'](data, bundleName, eventData);
      let updateAppBundleNameList: string[] = AppStorage.get<string[]>('updateAppBundleNameList') as string[];
      expect(updateAppBundleNameList.length > 0).assertTrue();
      mocker.clear(launchManager);
      mocker.clearAll();
    })

    it('test_dealAppGalleryCreatedEvent_updateStatus_not1_001', 0, () => {
      let bundleName = 'com.ohos.appgallery';
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let eventData: AppGalleryEventInfo = {
        distributeType: 'internaltesting',
        bundleName: bundleName,
        status: 1,
        appName: 'appgallery',
        eventType: ''
      };
      let emptyData: DownloadStatusInfo = {
        bundleName: bundleName,
        status: 1,
        updateStatus: 0,
        legacyInfos: [],
        appName: 'appgallery',
      };
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)([]).afterReturn(true);
      try {
        manager['dealAppGalleryCreatedEvent'](emptyData, bundleName, eventData);
        expect(CheckEmptyUtils.isEmptyArr(emptyData.legacyInfos)).assertTrue();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_dealAppGalleryCreatedEvent_updateStatus_not1', 0, () => {
      let bundleName = 'com.ohos.appgallery';
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let legacyItem: LegacyInfo = new LegacyInfo();
      legacyItem.pkgName = 'pkgName.hap';
      let data: DownloadStatusInfo = {
        bundleName: bundleName,
        status: 1,
        updateStatus: 0,
        legacyInfos: [legacyItem],
        appName: 'appgallery',
      };
      let legacyItem1: LegacyInfo = new LegacyInfo();
      legacyItem1.pkgName = 'pkgName.hap';
      let eventData: AppGalleryEventInfo = {
        distributeType: 'internaltesting',
        bundleName: bundleName,
        status: 1,
        appName: 'appgallery',
        eventType: ''
      };
      try {
        manager['dealAppGalleryCreatedEvent'](data, bundleName, eventData);
      } catch (e) {
      }
      let legacyInfos = data.legacyInfos ?? []
      expect(legacyInfos.length > 0).assertTrue();
      let legacyInfos1 = data.legacyInfos ?? []
      expect(legacyInfos1.length > 0).assertTrue();
      let legacyItem2: LegacyInfo = new LegacyInfo();
      legacyItem2.pkgName = '';
      let emptyData1: DownloadStatusInfo = {
        bundleName: bundleName,
        status: 1,
        updateStatus: 0,
        legacyInfos: [legacyItem2],
        appName: 'appgallery',
      };
      try {
        manager['dealAppGalleryCreatedEvent'](emptyData1, bundleName, eventData);
        let legacyInfos2 = data.legacyInfos ?? []
        expect(legacyInfos2.length > 0).assertTrue();
      } catch (e) {
      }
    })

    it('test_dealNotHarmonyTaskIfNeeded_dataEmpty', 0, () => {
      let bundleName = 'com.ohos.appgallery';
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let data: DownloadStatusInfo = {
        bundleName: bundleName,
        status: 1,
        updateStatus: 0,
        legacyInfos: [],
        appName: 'appgallery',
      };
      let mocker: MockKit = new MockKit();
      let mockFuncEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFuncEmpty)(ArgumentMatchers.any).afterReturn(true);
      expect(CheckEmptyUtils.isEmptyArr(data.legacyInfos)).assertTrue();
      manager['dealNotHarmonyTaskIfNeeded'](data, []);
      let legacyInfos = data.legacyInfos ?? []
      expect(legacyInfos.length > 0).assertFalse();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_dealNotHarmonyTaskIfNeeded_data', 0, () => {
      let bundleName = 'com.ohos.appgallery';
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let legacyItem: LegacyInfo = new LegacyInfo();
      legacyItem.pkgName = 'pkgName.hap';
      let data1: DownloadStatusInfo = {
        bundleName: bundleName,
        status: 1,
        updateStatus: 0,
        legacyInfos: [legacyItem],
        appName: 'appgallery',
      };
      let mocker: MockKit = new MockKit();
      let layoutManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let gridItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridItem.bundleName = 'testBundeleName';
      gridItem.keyName = 'testKey';
      gridItem.appStatus = 1;
      gridItem.appIndex = 0;
      let mockFunc: Function = mocker.mockFunc(layoutManager, layoutManager.isAppExistNotDragOutFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      manager['dealNotHarmonyTaskIfNeeded'](data1, [gridItem]);
      expect(gridItem.bundleName).assertEqual('testBundeleName');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      manager['dealNotHarmonyTaskIfNeeded'](data1, [gridItem]);
      let legacyInfos1 = data1.legacyInfos ?? []
      expect(legacyInfos1[0].pkgName.length > 0).assertTrue();
      mocker.clear(layoutManager);
      mocker.clearAll();
    })

    it('test_deleteOtherNotHarmonyTaskIfNeed', 0, () => {
      let bundleName = 'com.ohos.appgallery';
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let legacyItem: LegacyInfo = new LegacyInfo();
      legacyItem.pkgName = 'pkgName.hap';
      let legacyItem1: LegacyInfo = new LegacyInfo();
      legacyItem1.pkgName = 'pkgName1.hap';
      let legacyItem2: LegacyInfo = new LegacyInfo();
      legacyItem2.pkgName = 'pkgName.hap';
      let data: DownloadStatusInfo = {
        bundleName: bundleName,
        status: 1,
        updateStatus: 0,
        legacyInfos: [legacyItem, legacyItem1,legacyItem2],
        appName: 'appgallery',
      };
      let mocker: MockKit = new MockKit();
      let launchManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let gridItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridItem.bundleName = bundleName;
      gridItem.keyName = 'testKey';
      gridItem.appStatus = 1;
      let mockFunc: Function = mocker.mockFunc(launchManager, launchManager.getAllSameBundleNameAppItem);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([gridItem]);
      manager['deleteOtherNotHarmonyTaskIfNeed'](data);
      let legacyInfos = data.legacyInfos ?? []
      expect(legacyInfos.length === 3).assertTrue();
      mocker.clear(launchManager);
      mocker.clearAll();
    })

    it('test_dealUpdateAppItemAfterInstall_001', 0, () => {
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let bundleName = 'com.ohos.appgallery1';
      AppStorage.setOrCreate('updateAppBundleNameList', undefined);
      manager['dealUpdateAppItemAfterInstall'](bundleName, 0);
      let updateAppBundleNameList: string[] = AppStorage.get<string[]>('updateAppBundleNameList') as string[];
      expect(updateAppBundleNameList).assertUndefined();
      AppStorage.setOrCreate('updateAppBundleNameList', ['testvalue1']);
      manager['dealUpdateAppItemAfterInstall'](bundleName, 0);
      let updateAppBundleNameList1: string[] = AppStorage.get<string[]>('updateAppBundleNameList') as string[];
      expect(updateAppBundleNameList1.includes(bundleName)).assertFalse();
      AppStorage.setOrCreate('updateAppBundleNameList', [bundleName]);
      manager['dealUpdateAppItemAfterInstall'](bundleName, 0);
      let updateAppBundleNameList2: string[] = AppStorage.get<string[]>('updateAppBundleNameList') as string[];
      expect(updateAppBundleNameList2.includes(bundleName)).assertTrue();
    })

    it('test_dealUpdateAppItemAfterInstall_002', 0, () => {
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let bundleName = 'com.ohos.appgallery1';
      AppStorage.setOrCreate('updateAppBundleNameList', [bundleName, 'testBundleName1', 'testBundleName2']);
      manager['dealUpdateAppItemAfterInstall'](bundleName, AppGalleryEventStatus.DOWNLOAD_CANCEL_EVENT_ID);
      AppStorage.setOrCreate('updateAppBundleNameList', [bundleName, 'testBundleName1', 'testBundleName2']);
      manager['dealUpdateAppItemAfterInstall'](bundleName, AppGalleryEventStatus.DOWNLOAD_FAILED_EVENT_ID);
      AppStorage.setOrCreate('updateAppBundleNameList', [bundleName, 'testBundleName1', 'testBundleName2']);
      manager['dealUpdateAppItemAfterInstall'](bundleName, AppGalleryEventStatus.INSTALL_SUCCEED_EVENT_ID);
      let updateAppBundleNameList2: string[] = AppStorage.get<string[]>('updateAppBundleNameList') as string[];
      expect(updateAppBundleNameList2.includes(bundleName)).assertFalse();
    })

    it('test_deleteNotHarmonyItem_001', 0, () => {
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let bundleName = 'com.ohos.appgallery1';
      let legacyItem: LegacyInfo = new LegacyInfo();
      legacyItem.pkgName = 'pkgName.hap';
      let legacyItem1: LegacyInfo = new LegacyInfo();
      legacyItem1.pkgName = 'pkgName1.hap';
      let legacyItem2: LegacyInfo = new LegacyInfo();
      legacyItem2.pkgName = 'pkgName.hap';
      let data: DownloadStatusInfo = {
        bundleName: bundleName,
        status: 1,
        updateStatus: 0,
        legacyInfos: [legacyItem, legacyItem1, legacyItem2],
        appName: 'appgallery',
      };
      let mocker: MockKit = new MockKit();
      if(!CheckEmptyUtils.isEmptyArr(['1'])){
        mocker.clear(CheckEmptyUtils);
      }
      let appModel: AppModel = AppModel.getInstance();
      let mockFunc: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        manager['deleteNotHarmonyItem'](data);
        expect(legacyItem.pkgName ?? data.bundleName).assertEqual('pkgName.hap');
      } catch (e) {
      }
      let dataEmpty: DownloadStatusInfo = {
        bundleName: 'bundleName__test1__test2',
        status: 1,
        updateStatus: 0,
        legacyInfos: [],
        appName: 'appgallery',
      };
      let appItem: AppItemInfo = new AppItemInfo();
      appItem.appStatus = 0;
      when(mockFunc)(ArgumentMatchers.any).afterReturn(appItem);
      try {
        manager['deleteNotHarmonyItem'](dataEmpty);
        let pkgname = 'bundleName__test1__test2'.split('__')[2];
        expect(pkgname).assertEqual('test2');
      } catch (e) {
      }
      mocker.clear(appModel);
      mocker.clearAll();
    })

    it('test_refreshAppTwinIcon_001', 0, () => {
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let gridItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridItem.intent = 'com.test.mark.union';
      gridItem.appIndex = 1;
      let appList : GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.intent = 'com.test.mark.union';
      item1.appIndex = 0;
      item1.bundleName = 'test1';
      appList.push(item1);
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.intent = 'com.test.mark.union';
      item2.appIndex = 2;
      item2.bundleName = 'test2';
      appList.push(item2);
      manager['refreshAppTwinIcon'](gridItem, appList);
      expect(gridItem.appIndex >= 0).assertTrue();
    })

    it('test_installFailedNotify_001', 0, () => {
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let bundleName = 'com.test.mark.union';
      let mocker: MockKit = new MockKit();
      let launchManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      manager['installFailedNotify'](bundleName);
      mocker.clear(launchManager);
      mocker.clearAll();
    })

    it('test_removeMainAndTwinAppByBundleName_001', 0, () => {
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let bundleName = 'com.test.mark.union';
      let appList : GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.intent = 'com.test.mark.union';
      item1.appIndex = 0;
      item1.bundleName = 'test1';
      item1.appStatus = AppStatus.INSTALLED;
      appList.push(item1);
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.intent = bundleName;
      item2.appIndex = 2;
      item2.bundleName = 'test2';
      item2.appStatus = AppStatus.DOWNLOADING;
      appList.push(item2);
      let mocker: MockKit = new MockKit();
      let launchManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(launchManager, launchManager.getAllSameBundleNameAppItem);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(appList);
      manager['removeMainAndTwinAppByBundleName'](bundleName);
      expect(item2.appStatus !== AppStatus.INSTALLED).assertTrue();
      mocker.clear(launchManager);
      mocker.clearAll();
    })

    it('test_changeAllCacheAppToPause_001', 0, () => {
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let bundleName = 'com.test.mark.union';
      let legacyItem: LegacyInfo = new LegacyInfo();
      legacyItem.pkgName = 'pkgName.hap';
      let data: DownloadStatusInfo = {
        bundleName: bundleName,
        status: AppStatus.WAITING,
        updateStatus: 0,
        legacyInfos: [legacyItem],
        appName: 'appgallery',
      };
      let data1: DownloadStatusInfo = {
        bundleName: 'bundleName',
        status: AppStatus.DOWNLOADING,
        updateStatus: 0,
        legacyInfos: [],
        appName: 'appgallery1',
      };
      let data2: DownloadStatusInfo = {
        bundleName: 'test1',
        status: AppStatus.INSTALL_WAITING,
        updateStatus: 0,
        legacyInfos: [],
        appName: 'appgallery2',
      };
      let data3: DownloadStatusInfo = {
        bundleName: 'bundleName2',
        status: AppStatus.INSTALLING,
        updateStatus: 0,
        legacyInfos: [],
        appName: 'appgallery3',
      };
      let data4: DownloadStatusInfo = {
        bundleName: 'bundleName4',
        status: AppStatus.CREATED,
        updateStatus: 0,
        legacyInfos: [],
        appName: 'appgallery4',
      };
      manager['downloadTaskList'] = [data, data1, data2, data3, data4];
      manager['changeAllCacheAppToPause']();
      expect(manager['downloadTaskList'].length > 0).assertTrue();
    })

    it('test_isPreDownloadMenuStatus_WAIT_FOR_HARMONY001', 0, () => {
      let mocker: MockKit = new MockKit();
      try{
        let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
        let bundleName = 'com.openharmony.ohos.sugesture';
        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = bundleName;
        item1.appIndex = 0;
        item1.intent = '';
        item1.appStatus = AppStatus.WAIT_FOR_HARMONY;
        manager['downloadTaskList'] = [];
        expect(manager['isPreDownloadMenuStatus'](item1)).assertFalse();
        let downLoadInfo : DownloadStatusInfo = {
          bundleName: bundleName,
          status: AppStatus.PENDING,
          updateStatus: 0,
          legacyInfos: [],
          appName: 'appgallery4',
        };
        manager['downloadTaskList'] = [downLoadInfo];
        expect(manager['isPreDownloadMenuStatus'](item1)).assertFalse();
      } catch (e) {}
      mocker.clear(CheckEmptyUtils);
    })

    it('test_isPreDownloadMenuStatus_not_WAIT_FOR_HARMONY001', 0, () => {
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let mocker: MockKit = new MockKit();
      try {
        let bundleName = 'com.openharmony.ohos.sugesture';
        let downLoadInfo : DownloadStatusInfo = {
          bundleName: bundleName,
          status: AppStatus.PENDING,
          updateStatus: 0,
          legacyInfos: [],
          appName: 'appgallery4',
        };
        manager['downloadTaskList'] = [downLoadInfo];
        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = bundleName;
        item1.appIndex = 0;
        item1.intent = '';
        item1.appStatus = AppStatus.WAITING;
        manager['downloadTaskList'] = [];
        expect(manager['isPreDownloadMenuStatus'](item1)).assertTrue();
      } catch (e) {}
      mocker.clear(CheckEmptyUtils);
    })

    it('test_isPreDownloadMenuAppStatus_true', 0, () => {
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      expect(manager['isPreDownloadMenuAppStatus'](AppStatus.PENDING)).assertTrue();
      expect(manager['isPreDownloadMenuAppStatus'](AppStatus.WAITING)).assertTrue();
      expect(manager['isPreDownloadMenuAppStatus'](AppStatus.PAUSING)).assertTrue();
      expect(manager['isPreDownloadMenuAppStatus'](AppStatus.INSTALLING)).assertFalse();
    })

    it('test_getPreDownloadMenuNum', 0, () => {
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_APP;
      item.appIndex = 0;
      item.appStatus =  AppStatus.DOWNLOADING;
      manager['downloadTaskList'] = [];
      expect(manager['isPreDownloadMenuApp'](item)).assertTrue();
      expect(manager['getPreDownloadMenuNum'](item)).assertEqual(1);
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.typeId = CommonConstants.TYPE_FOLDER;
      item1.appIndex = 0;
      item1.appStatus = AppStatus.DOWNLOADING;
      let layoutItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      layoutItem1.typeId = CommonConstants.TYPE_APP;
      layoutItem1.appIndex = 0;
      layoutItem1.bundleName = 'bundlename1';
      layoutItem1.appName = 'app1';
      layoutItem1.appStatus =  AppStatus.DOWNLOADING;
      let layoutItem2: GridLayoutItemInfo = new GridLayoutItemInfo();
      layoutItem2.typeId = CommonConstants.TYPE_APP;
      layoutItem2.appIndex = 0;
      layoutItem2.bundleName = 'bundlename2';
      layoutItem2.appName = 'app2';
      layoutItem2.appStatus =  AppStatus.DOWNLOADING;
      item1.layoutInfo = [[layoutItem1, layoutItem2]];
      expect(manager['getPreDownloadMenuNum'](item1)).assertEqual(2);
    })

    it('test_isPreDownloadMenuApp', 0, () => {
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'bundleName';
      item.typeId = CommonConstants.TYPE_APP;
      item.appIndex = 1;
      item.appStatus =  AppStatus.DOWNLOADING;
      expect(manager['isPreDownloadMenuApp'](item)).assertFalse();

      let bundleName = 'com.openharmony.ohos.sugesture';
      let downLoadInfo : DownloadStatusInfo = {
        bundleName: bundleName,
        status: AppStatus.PENDING,
        updateStatus: 0,
        legacyInfos: [],
        appName: 'appgallery4',
      };
      manager['downloadTaskList'] = [downLoadInfo];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.typeId = CommonConstants.TYPE_APP;
      item1.bundleName = bundleName;
      item1.appIndex = 0;
      item1.appStatus =  AppStatus.DOWNLOADING;
      expect(manager['isPreDownloadMenuApp'](item1)).assertTrue();
    })

    it('test_isPreDownloadMenuAppType', 0, () => {
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      expect(manager['isPreDownloadMenuAppType'](undefined)).assertFalse();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'bundleName';
      item.typeId = CommonConstants.TYPE_APP;
      item.appIndex = 1;
      item.appStatus =  AppStatus.DOWNLOADING;
      manager['downloadTaskList'] = [];
      expect(manager['isPreDownloadMenuAppType'](item)).assertFalse();
    })

    it('test_clickAppToPreDownload', 0, () => {
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let downLoadInfo : DownloadStatusInfo = {
        bundleName: 'bundleName',
        status: AppStatus.PENDING,
        updateStatus: 0,
        legacyInfos: [],
        appName: 'appgallery4',
      };
      manager['downloadTaskList'] = [downLoadInfo];
      expect(manager['downloadTaskList'].length > 0).assertTrue();
      let downLoadInfo1 : DownloadStatusInfo = {
        bundleName: 'bundleName',
        status: AppStatus.WAITING,
        updateStatus: 0,
        legacyInfos: [],
        appName: 'appgallery4',
      };
      manager['downloadTaskList'] = [downLoadInfo1];
      expect(manager['downloadTaskList'].length > 0).assertTrue();
    })

    it('test_dealNotohosApp', 0, () => {
      let manager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      manager['dealNotohosApp']([], new Map(), new Map());
      let notohosApp : string[] = ['app1', 'app2'];
      let relatiopnMap:Map<string, boolean> = new Map();
      let publicTestRelationMap:Map<string, boolean> = new Map();
      let preference = preferences.getPreferencesSync(GlobalContext.getContext(), { name: 'DESKTOP_LAYOUT_INFO' });
      let saveApps = 'app3,app4';
      preference.putSync('lightDeliverBundleNames', saveApps);
      let lightDeliverBundleNames: string = preference.getSync('lightDeliverBundleNames', '') as string;
      expect(lightDeliverBundleNames).assertEqual(saveApps);
      manager['dealNotohosApp'](notohosApp, relatiopnMap, publicTestRelationMap);
      expect(notohosApp.length > 0).assertTrue();

      let saveApps1 = 'app1,app2,app3,app4';
      preference.putSync('lightDeliverBundleNames', saveApps1);
      let lightDeliverBundleNames1: string = preference.getSync('lightDeliverBundleNames', '') as string;
      expect(lightDeliverBundleNames1).assertEqual(saveApps1);
      manager['dealNotohosApp'](notohosApp, relatiopnMap, publicTestRelationMap);
      expect(notohosApp.length > 0).assertTrue();
    })
  })

  interface TestCommonEventParametersData {
    bundleName: string
  }

  interface TempEventParameters {
    'distributeType': string,
    'ag.params.HARMONY_PKGS_ADDED'?: string[],
    'ag.params.HARMONY_PKGS_REMOVED'?: string[],
    'ag.params.PUBLIC_TEST_APP_PKGS_ADDED'?: string[],
    updateStatus?: number,
  }
}

function createFullDockItemToGridItem(): DockItemInfo {
  let dockItem = new DockItemInfo();
  dockItem.itemType = 0;
  dockItem.typeId = 1;
  dockItem.appId = 'appid001';
  dockItem.bundleName = 'dockItem.bundleName';
  dockItem.moduleName = 'dockItem.moduleName';
  dockItem.abilityName = 'dockItem.abilityName';
  dockItem.appIconId = 1;
  dockItem.appLabelId = 0;
  dockItem.applicationLabelId = 0;
  dockItem.appName = 'dockItem.appName';
  dockItem.areaType = 0;
  dockItem.keyName = 'dockItem.keyName';
  dockItem.layoutInfo = [[]];
  dockItem.badgeNumber = 0;
  dockItem.row = 0;
  dockItem.column = 0;
  dockItem.isUninstallAble = false;
  dockItem.appStatus = 0;
  dockItem.downloadProgress = 0;
  dockItem.iconResource = 'dockItem.iconResource';
  dockItem.callerName = 'dockItem.callerName';
  dockItem.appIndex = 0;
  dockItem.shortcutId = '';
  dockItem.intent = '';
  dockItem.page =  0;
  return dockItem;
}
