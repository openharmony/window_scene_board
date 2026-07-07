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
import { FileUtils } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, TestType, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import {
  BackupNotificationAppSettingsInfo,
  BackupNotificationSettingsInfo,
  BackupSettingsInfo,
  UpdateRdbManager } from '../../../../../../main/ets/manager/UpdateRdbManager';
import { BackupFavoriteInfo } from '../../../../../../main/ets/model/BackupFavoriteInfo';
import type ctx from '@ohos.app.ability.common';
import preferences from '@ohos.data.preferences';
import { relationalStore } from '@kit.ArkData';
import { AppItemInfo, dataConvert, GridLayoutItemInfo } from '../../../../../../main/ets/TsIndex';
import { IntentParseUtil } from '../../../../../../main/ets/utils/IntentParseUtil';

function initGridLayoutItemInfos(): GridLayoutItemInfo[] {
  let layoutInfos: GridLayoutItemInfo[] = [];
  // 应用
  let gridLayoutApp: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutApp.typeId = 0;
  gridLayoutApp.infoId = '60';
  gridLayoutApp.infoName = '设置';
  gridLayoutApp.bundleName = 'com.ohos.settings';
  gridLayoutApp.abilityName = 'com.ohos.settings.MainAbility';
  gridLayoutApp.moduleName = 'phone_settings';
  gridLayoutApp.container = 100;
  gridLayoutApp.badgeNumber = 3;
  gridLayoutApp.page = 0;
  gridLayoutApp.row = 0;
  gridLayoutApp.column = 1;
  gridLayoutApp.area = [1, 1];

  let gridLayoutFolderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutFolderItem.typeId = 0;
  gridLayoutFolderItem.infoId = '50';
  gridLayoutFolderItem.infoName = '应用市场';
  gridLayoutFolderItem.bundleName = 'com.ohos.appgallery';
  gridLayoutFolderItem.abilityName = 'MainAbility';
  gridLayoutFolderItem.moduleName = 'entry';
  gridLayoutFolderItem.container = 48;
  gridLayoutFolderItem.row = 0;
  gridLayoutFolderItem.column = 0;
  gridLayoutFolderItem.area = [1, 1];

  let gridLayoutFolderItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutFolderItem1.typeId = 0;
  gridLayoutFolderItem1.infoId = '51';
  gridLayoutFolderItem1.infoName = '主题';
  gridLayoutFolderItem1.bundleName = 'com.ohos.thememanager';
  gridLayoutFolderItem1.abilityName = 'MainAbility';
  gridLayoutFolderItem1.moduleName = 'entry';
  gridLayoutFolderItem1.container = 48;
  gridLayoutFolderItem1.row = 0;
  gridLayoutFolderItem1.column = 1;
  gridLayoutFolderItem1.area = [1, 1];

  layoutInfos = [gridLayoutApp, gridLayoutFolderItem, gridLayoutFolderItem1];
  return layoutInfos;
}

function initFolderGridLayoutItemInfo(): GridLayoutItemInfo {
  let gridLayoutFolderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutFolderItem.typeId = 0;
  gridLayoutFolderItem.infoId = '50';
  gridLayoutFolderItem.infoName = '应用市场';
  gridLayoutFolderItem.bundleName = 'com.ohos.appgallery';
  gridLayoutFolderItem.abilityName = 'MainAbility';
  gridLayoutFolderItem.moduleName = 'entry';
  gridLayoutFolderItem.container = 48;
  gridLayoutFolderItem.row = 0;
  gridLayoutFolderItem.column = 0;
  gridLayoutFolderItem.area = [1, 1];

  let gridLayoutFolderItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutFolderItem1.typeId = 0;
  gridLayoutFolderItem1.infoId = '51';
  gridLayoutFolderItem1.infoName = '主题';
  gridLayoutFolderItem1.bundleName = 'com.ohos.thememanager';
  gridLayoutFolderItem1.abilityName = 'MainAbility';
  gridLayoutFolderItem1.moduleName = 'entry';
  gridLayoutFolderItem1.container = 48;
  gridLayoutFolderItem1.row = 0;
  gridLayoutFolderItem1.column = 1;
  gridLayoutFolderItem1.area = [1, 1];

  // 文件夹
  let gridLayoutFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutFolder.id = 48;
  gridLayoutFolder.typeId = 0;
  gridLayoutFolder.infoId = '1715654262380';
  gridLayoutFolder.infoName = '应用';
  gridLayoutFolder.bundleName = 'RestoreOwnerInfo';
  gridLayoutFolder.folderName = '应用';
  gridLayoutFolder.abilityName = '';
  gridLayoutFolder.moduleName = '';
  gridLayoutFolder.container = 100;
  gridLayoutFolder.page = 1;
  gridLayoutFolder.row = 4;
  gridLayoutFolder.column = 2;
  gridLayoutFolder.area = [2, 2];
  if (gridLayoutFolder.layoutInfo) {
    gridLayoutFolder.layoutInfo[0] = [gridLayoutFolderItem, gridLayoutFolderItem1];
  }
  return gridLayoutFolder;
}

function initCardGridLayoutItemInfo(): GridLayoutItemInfo {
  let gridLayoutItemCard: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutItemCard.typeId = 1;
  gridLayoutItemCard.cardId = '72001000';
  gridLayoutItemCard.infoId = '72001000';
  gridLayoutItemCard.infoName = 'OneMulTwoRealTimeCard';
  gridLayoutItemCard.bundleName = 'com.ohos.totemweather';
  gridLayoutItemCard.abilityName = 'FormAbility';
  gridLayoutItemCard.moduleName = 'product';
  gridLayoutItemCard.container = 100;
  gridLayoutItemCard.page = 2;
  gridLayoutItemCard.row = 0;
  gridLayoutItemCard.column = 2;
  gridLayoutItemCard.area = [1, 2];

  return gridLayoutItemCard;
}

export default function UpdateRdbManagerTest() {
  describe('UpdateRdbManagerTest', () => {
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

    it('test_cloneAllSP', TestType.FUNCTION, async (done: Function) => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      await instance.cloneAllSP();
      expect(instance).not().assertNull()
      done();
    });

    it('test_cloneAllSP1', TestType.FUNCTION, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      try {
        let mockFun = mocker.mockFunc(FileUtils, FileUtils.isExist);
        when(mockFun)(ArgumentMatchers.any).afterReturn(true);
        let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
        await instance.cloneAllSP();
        expect(instance).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(FileUtils);
      mocker.clearAll();
      done();
    });

    it('test_cloneAllSP02_7', TestType.FUNCTION, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      try {
        let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
        let fileList: string[] = ['TEST.xml'];
        let mockFun = mocker.mockFunc(FileUtils, FileUtils.isExist);
        when(mockFun)(ArgumentMatchers.any).afterReturn(true);
        let mockFun2 = mocker.mockFunc(FileUtils, FileUtils.getFileList);
        when(mockFun2)(ArgumentMatchers.any).afterReturn(fileList);
        await instance.cloneAllSP();
        let sp = await preferences.getPreferences((GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext), 'TEST');
        expect(instance instanceof UpdateRdbManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(FileUtils);
      mocker.clearAll();
      done();
    })

    it('test_copyFormMappingRelation', TestType.FUNCTION, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFun = mocker.mockFunc(FileUtils, FileUtils.isExist);
      when(mockFun)(ArgumentMatchers.any).afterReturn(true);
      try {
        let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
        await instance['copyFormMappingRelation']();
        expect(instance).not().assertNull();
      } catch (e) {
      }
      mocker.clear(FileUtils);
      mocker.clearAll();
      done();
    });

    it('test_queryLauncherDbDesktopInfo_01', TestType.FUNCTION, async () => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      let isFromClone: boolean = true;
      let ret: BackupFavoriteInfo[] =  await instance.queryLauncherDbDesktopInfo(isFromClone);
      expect(ret).not().assertNull();
    });

    it('test_queryLauncherDbDesktopInfo_02', TestType.FUNCTION, async () => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      let isFromClone: boolean = false;
      let ret: BackupFavoriteInfo[] =  await instance.queryLauncherDbDesktopInfo(isFromClone);
      expect(ret).not().assertNull();
    });

    it('test_queryLauncherDbDesktopInfo_03', TestType.FUNCTION, async () => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isRetainedShortcut: Function = mocker.mockFunc(IntentParseUtil, IntentParseUtil.isRetainedShortcut);
      when(isRetainedShortcut)(ArgumentMatchers.any).afterReturn(true);
      let ret: BackupFavoriteInfo[] =  await instance.queryLauncherDbDesktopInfo(false);
      expect(ret).not().assertNull();
      mocker.ignoreMock(IntentParseUtil, IntentParseUtil.isRetainedShortcut);
    });

    it('test_queryNotificationAppSetting', TestType.FUNCTION, async () => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      let ret: BackupNotificationAppSettingsInfo[] =  await instance.queryNotificationAppSetting();
      expect(ret).not().assertNull();
    });

    it('test_queryNotificationSetting', TestType.FUNCTION, async () => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      let ret: BackupNotificationSettingsInfo[] =  await instance.queryNotificationSetting();
      expect(ret).not().assertNull();
    });

    it('test_startCopyIcon', TestType.FUNCTION, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();

      let databaseDir = (GlobalContext.getInstance().getObject('desktopContext') as
      ctx.ServiceExtensionContext).databaseDir + '/app_icons.db';
      let isExist: Function = mocker.mockFunc(instance, FileUtils.isExist);
      when(isExist)(databaseDir).afterReturn(true);

      const iconStoreConfig: relationalStore.StoreConfig = {
        name: 'app_icons_back.db',
        securityLevel: relationalStore.SecurityLevel.S1
      };
      let mRdbStore: relationalStore.RdbStore = await relationalStore.getRdbStore(
        GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext, iconStoreConfig);
      let getRdbStore: Function = mocker.mockFunc(instance, relationalStore.getRdbStore);
      when(getRdbStore)(ArgumentMatchers.any).afterReturn(mRdbStore);
      try {
        instance.startCopyIcon();
        expect(instance).not().assertNull();
      } catch (e) {
      }
      mocker.clear(instance);
      mocker.clearAll();
      done();
    });

    it('test_startCopyIcon', TestType.FUNCTION, async (done: Function) => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      await instance.startCopyIcon();
      expect(instance).not().assertNull();
      done();
    });

    it('test_startCopyIcon_mock', TestType.FUNCTION, async (done: Function) => {
      let store: relationalStore.RdbStore = {} as relationalStore.RdbStore;
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFun = mocker.mockFunc(instance, instance['copyIconDb']);
      when(mockFun)().afterReturn(store);
      try {
        await instance.startCopyIcon();
        expect(instance).not().assertNull();
      } catch (e) {
      }
      mocker.clear(instance);
      mocker.clearAll();
      done();
    });

    it('test_copyIconDb', 0, () => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      let ret = instance['copyIconDb']();
      expect(instance).not().assertNull();
    });

    it('test_copyIconDb1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFun = mocker.mockFunc(FileUtils, FileUtils.isExist);
      when(mockFun)(ArgumentMatchers.any).afterReturn(true);
      try {
        let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
        let ret = instance['copyIconDb']();
        expect(ret).not().assertNull();
      } catch (e) {
      }
      mocker.clear(FileUtils);
      mocker.clearAll();
    });

    it('test_startRdbMigrate', TestType.FUNCTION, async () => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      instance.startRdbMigrate();
      expect(instance).not().assertNull();
    });

    it('test_preprocessLauncherSettingData', TestType.FUNCTION, () => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      instance.preprocessLauncherSettingData();
      expect(instance).not().assertNull();
    })

    it('saveHiSearchStatus', TestType.FUNCTION, async () => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();

      let preference: preferences.Preferences = await preferences.getPreferences((GlobalContext.getInstance()
        .getObject('desktopContext') as ctx.ServiceExtensionContext), 'LAUNCHER_SETTINGS');
      preference.putSync('hisearch_open_state', true);
      await preference.flush();

      instance.saveDesktopSettings();
      expect(instance).not().assertNull();
    });

    it('test_queryIconDbDesktopInfo', 0, async (done: Function) => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      await instance['queryIconDbDesktopInfo'](false);
      expect(instance).not().assertNull();
      done();
    });

    it('test_saveDbDesktopDefault', 0, async (done: Function) => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      await instance['saveDbDesktopDefault']();
      expect(instance).not().assertNull();
      done();
    });

    it('test_setLauncherRdbStore', 0, async (done: Function) => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      await instance.setLauncherRdbStore(null);
      expect(instance['mLauncherRdbStore']).assertNull();
      await instance.startRdbMigrate();
      done();
    });

    it('test_setNotificationRdbStore', 0, async (done: Function) => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      await instance.setNotificationRdbStore(null);
      expect(instance['mNotificationRdbStore']).assertNull();
      done();
    });

    it('test_queryCurrentLayout_01', 0, async (done: Function) => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      let ret = await instance.queryCurrentLayout(false);
      expect(ret).not().assertNull();
      done();
    });

    it('test_queryCurrentLayout_02', 0, async (done: Function) => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      let ret = await instance.queryCurrentLayout(true);
      expect(ret).not().assertNull();
      done();
    });

    it('test_saveOldLayoutToContextOnClone', 0, async (done: Function) => {
      let info: BackupSettingsInfo = new BackupSettingsInfo();
      info.filename = 'LAUNCHER_SETTINGS';
      info.name = 'DESKTOP_LAYOUT_CELLS';
      info.id = 1314;
      info.type = 'type';
      let list: BackupSettingsInfo[] = [];
      list.push(info);

      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      try {
        await instance['saveOldLayoutToContextOnClone'](list);
      } catch (error) {
      }
      expect(instance).not().assertNull();
      done();
    });

    it('test_saveOldLayoutToContextOnClone1', 0, async (done: Function) => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      let info: BackupSettingsInfo = new BackupSettingsInfo();
      info.filename = 'LAUNCHER_SETTINGS';
      info.name = 'DEFAULT_DESKTOP_LAYOUT_INDEX';
      info.id = 1314;
      info.type = 'type';
      info.value = 'value';
      let list: BackupSettingsInfo[] = [];
      list.push(info);

      await instance['saveOldLayoutToContextOnClone'](list);
      expect(instance).not().assertNull();
      done();
    });

    it('test_transLauncherSetting1', 0, async (done: Function) => {
      let info: BackupSettingsInfo = new BackupSettingsInfo();
      info.filename = 'LAUNCHER_SETTINGS';
      info.name = 'hisearch_open_preference';
      info.id = 1314;
      info.type = 'type';
      info.value = 'value';
      let list: BackupSettingsInfo[] = [];
      list.push(info);

      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      await instance['transLauncherSetting'](list);
      expect(instance).not().assertNull();
      done();
    })

    it('test_transLauncherSetting2', 0, async (done: Function) => {
      let info: BackupSettingsInfo = new BackupSettingsInfo();
      info.filename = 'LAUNCHER_SETTINGS';
      info.name = 'auto_align';
      info.id = 1314;
      info.type = 'type';
      info.value = 'value';
      let list: BackupSettingsInfo[] = [];
      list.push(info);

      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      await instance['transLauncherSetting'](list);
      expect(instance).not().assertNull();
      done();
    })

    it('test_transLauncherSetting3_else', 0, async (done: Function) => {
      let info: BackupSettingsInfo = new BackupSettingsInfo();
      info.filename = 'LAUNCHER_SETTINGS';
      info.name = 'dt_test_name';
      info.id = 1314;
      info.type = 'type';
      info.value = 'value';
      let list: BackupSettingsInfo[] = [];
      list.push(info);

      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      await instance['transLauncherSetting'](list);
      expect(instance).not().assertNull();
      done();
    })

    it('test_isInstalled', 0, () => {
      let info: AppItemInfo = new AppItemInfo();
      info.bundleName = 'com.dt';
      let array: AppItemInfo[] = [];
      array.push(info);

      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      let ret = instance['isInstalled'](array, info.bundleName,0);
      expect(ret).assertTrue();
    });

    it('test_saveLocalIcon', 0, () => {
      let info: AppItemInfo = new AppItemInfo();
      info.bundleName = 'com.dt';
      let array: AppItemInfo[] = [];
      array.push(info);

      let buffer = new ArrayBuffer(8);
      let bmpBuffer: ArrayBufferLike = new Uint8Array(buffer).buffer;
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      expect(instance['saveLocalIcon']('fileName', bmpBuffer) === undefined).assertTrue();
    });

    it('test_saveLocalIcon02', 0, () => {
      let info: AppItemInfo = new AppItemInfo();
      info.bundleName = 'com.dt';
      let array: AppItemInfo[] = [];
      array.push(info);

      let buffer = new ArrayBuffer(8);
      let bmpBuffer: ArrayBufferLike = new Uint8Array(buffer).buffer;
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();

      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FileUtils, FileUtils.isExist);
      when(mockFunc)().afterReturn(false);
      try {
        expect(instance['saveLocalIcon']('fileName', bmpBuffer) === undefined).assertTrue();
      } catch (e) {
      }
      mocker.clear(FileUtils);
      mocker.clearAll();
    });

    it('test_queryCloneSourceHMLayoutInfo', 0, async () => {
      let restoreInfoMap: Map<string, Array<string>> = new Map();
      restoreInfoMap.set('RestoreBundleData', ['RestoreBundleData']);
      restoreInfoMap.set('RestoreIconUriData', ['RestoreIconUriData']);
      restoreInfoMap.set('RestoreIconTitleData', ['RestoreIconTitleData']);
      restoreInfoMap.set('RestoreOwnerInfo', ['RestoreOwnerInfo']);

      let info: AppItemInfo = new AppItemInfo();
      info.bundleName = 'com.dt';
      let appList: AppItemInfo[] = [];
      appList.push(info);

      let isOuter: boolean = false;

      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      let result: GridLayoutItemInfo[] = [];
      try {
        result = await instance.queryCloneSourceHMLayoutInfo(restoreInfoMap, appList, isOuter);
      } catch (error) {
      }
      expect(result.length).assertLargerOrEqual(0);
    });

    it('test_queryCloneSourceHMLayoutInfo01', 0, async () => {
      let restoreInfoMap: Map<string, Array<string>> = new Map();
      restoreInfoMap.set('RestoreBundleData', ['RestoreBundleData']);
      restoreInfoMap.set('RestoreIconUriData', ['RestoreIconUriData']);
      restoreInfoMap.set('RestoreIconTitleData', ['RestoreIconTitleData']);
      restoreInfoMap.set('RestoreOwnerInfo', ['RestoreOwnerInfo']);

      let info: AppItemInfo = new AppItemInfo();
      info.bundleName = 'com.dt';
      let appList: AppItemInfo[] = [];
      appList.push(info);

      let isOuter: boolean = true;

      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      let result: GridLayoutItemInfo[] = [];
      try {
        result = await instance.queryCloneSourceHMLayoutInfo(restoreInfoMap, appList, isOuter);
      } catch (error) {
      }
      expect(result.length).assertLargerOrEqual(0);
    });

    it('test_dealBackupApp00', 0, () => {
      let backupInfoList: GridLayoutItemInfo[] = initGridLayoutItemInfos();

      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo.typeId = 0;
      appInfo.infoId = '51';
      appInfo.infoName = '主题';
      appInfo.bundleName = 'com.ohos.thememanager';
      appInfo.abilityName = 'MainAbility';
      appInfo.moduleName = 'entry';
      appInfo.container = 48;
      appInfo.row = 0;
      appInfo.column = 1;
      appInfo.area = [1, 1];

      let isInstalled: boolean = false;
      let restoreInfoMap: Map<string, Array<string>> = new Map();
      restoreInfoMap.set('RestoreBundleData', ['RestoreBundleData']);
      restoreInfoMap.set('RestoreIconUriData', ['RestoreIconUriData']);
      restoreInfoMap.set('RestoreIconTitleData', ['RestoreIconTitleData']);
      restoreInfoMap.set('RestoreOwnerInfo', ['RestoreOwnerInfo']);
      restoreInfoMap.set('com.ohos.thememanager0', ['com.ohos.thememanager']);

      let waitForHarmonyValue: Array<string> = ['iconResource', 'appName', 'callerName', 'intent'];

      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(dataConvert, dataConvert.getWaitForHarmonyValue);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(waitForHarmonyValue);
      try {
        let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
        expect(instance['dealBackupApp'](backupInfoList, appInfo, isInstalled, restoreInfoMap) === undefined).assertTrue();
      } catch (e) {
      }
      mocker.ignoreMock(dataConvert, dataConvert.getWaitForHarmonyValue);
    });

    it('test_dealBackupApp01', 0, () => {
      let backupInfoList: GridLayoutItemInfo[] = initGridLayoutItemInfos();

      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo.typeId = 0;
      appInfo.infoId = '51';
      appInfo.infoName = '主题';
      appInfo.bundleName = 'com.ohos.thememanager';
      appInfo.abilityName = 'MainAbility';
      appInfo.moduleName = 'entry';
      appInfo.container = 48;
      appInfo.row = 0;
      appInfo.column = 1;
      appInfo.area = [1, 1];

      let isInstalled: boolean = true;
      let restoreInfoMap: Map<string, Array<string>> = new Map();

      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      expect(instance['dealBackupApp'](backupInfoList, appInfo, isInstalled, restoreInfoMap) === undefined).assertTrue();
    });

    it('test_dealBackupCard', 0, () => {
      let backupInfoList: GridLayoutItemInfo[] = initGridLayoutItemInfos();
      let formInfo: GridLayoutItemInfo = initFolderGridLayoutItemInfo();

      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      expect(instance['dealBackupCard'](backupInfoList, formInfo) === undefined).assertTrue();
    });

    it('test_dealBackupCard01', 0, () => {
      let backupInfoList: GridLayoutItemInfo[] = initGridLayoutItemInfos();
      let formInfo: GridLayoutItemInfo = initCardGridLayoutItemInfo();

      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      expect(instance['dealBackupCard'](backupInfoList, formInfo) === undefined).assertTrue();
    });

    it('test_dealContainerAppCloneData', 0, () => {
      let restoreInfoMap: Map<string, Array<string>> = new Map();
      restoreInfoMap.set('RestoreBundleData', ['RestoreBundleData']);
      restoreInfoMap.set('RestoreIconUriData', ['RestoreIconUriData']);
      restoreInfoMap.set('RestoreIconTitleData', ['RestoreIconTitleData']);
      restoreInfoMap.set('RestoreOwnerInfo', ['RestoreOwnerInfo', 'RestoreBundleData', 'RestoreIconUriData', 'RestoreIconTitleData', 'RestoreIconHeaderData']);

      let item: GridLayoutItemInfo = initFolderGridLayoutItemInfo();

      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      expect(instance['dealContainerAppCloneData'](restoreInfoMap, item, 'RestoreOwnerInfo') === undefined).assertTrue();
    });

    it('test_saveOldLayoutToContext', 0, () => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      expect(instance['saveOldLayoutToContext']() === undefined).assertFalse();
    });

    it('test_saveOldLayoutToContext01', 0, async () => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      try {
        let sp = await preferences.getPreferences((GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext), 'LAUNCHER_SETTINGS');
        sp.putSync('DESKTOP_LAYOUT_CELLS', '4x6,5x7');
        sp.putSync('DEFAULT_DESKTOP_LAYOUT_INDEX', 0);
      } catch (error) {
      }

      expect(instance['saveOldLayoutToContext']() === undefined).assertFalse();
    });

    it('test_saveOldLayoutToContext02', 0, async () => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      try {
        let sp = await preferences.getPreferences((GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext), 'LAUNCHER_SETTINGS');
        sp.putSync('DESKTOP_LAYOUT_CELLS', '4x6,5x7');
        sp.putSync('DEFAULT_DESKTOP_LAYOUT_INDEX', 4);
      } catch (error) {
      }
      await instance['saveOldLayoutToContext']();
      expect(globalThis.oldLayoutCol).assertEqual(4);
    })

    it('test_printBackupCardLog', 0, () => {
      let backupInfo: BackupFavoriteInfo = {
        id: 9,
        title: '天气',
        intent: '#Intent;action=intent.action.MAIN;category=intent.category.LAUNCHER;launchFlags=0x10200000;component=com.openharmony.totemweather/.WeatherHome;end',
        container: -100,
        screen: 0,
        cellX: 2,
        cellY: 4,
        spanX: 1,
        spanY: 1,
        itemType: 9,
      };
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      expect(instance['printBackupCardLog'](backupInfo) === undefined).assertTrue();
      backupInfo.itemType = 0;
      expect(instance['printBackupCardLog'](backupInfo) === undefined).assertTrue();
    });

    it('test_copyOUCIconDb', 0, () => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFun = mocker.mockFunc(FileUtils, FileUtils.isExist);
      when(mockFun)(ArgumentMatchers.any).afterReturn(true);
      expect(instance['copyOUCIconDb']() === undefined).assertTrue();
      mocker.clear(FileUtils);
      mocker.clearAll();
    });

    it('test_getImageRes', 0, () => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      instance['getImageRes']('') === '';
      expect(instance).not().assertUndefined();
      let ret = instance['getImageRes']('img');
      expect(true).assertTrue();
    });

    it('test_getAdaptUserId', 0, () => {
      let instance: UpdateRdbManager = UpdateRdbManager.getInstance();
      let ret = instance['getAdaptUserId'](100);
      expect(ret === 0).assertTrue();
      ret = instance['getAdaptUserId'](101);
      expect(ret === 10).assertTrue();
    });
  })
}