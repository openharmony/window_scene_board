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

import { FileUtils } from '@ohos/basicutils'
import { afterAll, afterEach,
  ArgumentMatchers,
  beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium'
import { CloneItemInfo, LegacyInfo } from '../../../../../../../main/ets/constants/CommonConstants'
import { CloneItemInfoManager } from '../../../../../../../main/ets/transformdata/manager/CloneItemInfoManager'
import { TransferRelationModel } from '../../../../../../../main/ets/model/TransferRelationModel'
import { AppTransformItem } from '../../../../../../../main/ets/transformdata/transfromitem/AppTransformItem'
import { AppItemInfo, BackupFavoriteInfo,
  CommonConstants,
  AppReservePolicyType,
  dataConvert,
  GridLayoutItemInfo,
  LocalHapMigrateInfo,
  PackageInfo,
  transferRelationManager,
  ShortcutViewModel,
  ShortcutInfo,
  NotHarmonyUtil} from '../../../../../../../main/ets/TsIndex'
import { PackageRelation, IntentParseUtil } from '../../../../../../../main/ets/utils/IntentParseUtil'

export default function AppTransformItemTest() {
  describe('AppTransformItemTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('assert_isSupportInohos', 0, () => {
      let appTransformItem: AppTransformItem = new AppTransformItem(new BackupFavoriteInfo());
      let result: boolean = appTransformItem.isSupportInohos();
      expect(result).assertTrue();
    })

    it('assert_transformBackupInfoToGridInfo01', 0, async () => {
      let appTransformItem: AppTransformItem = new AppTransformItem(new BackupFavoriteInfo());
      let gridLayoutInfo: GridLayoutItemInfo[] = await appTransformItem.transformBackupInfoToGridInfo();
      expect(gridLayoutInfo.length).assertLargerOrEqual(0);
    })

    it('assert_transformBackupInfoToGridInfo02_7', 0, async () => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.contacts';
      appInfo.abilityName = 'com.ohos.contacts.MainAbility';
      appInfo.moduleName = 'entry';
      appInfo.typeId = CommonConstants.TYPE_APP;
      appInfo.badgeNumber = 0;
      appInfo.appIconId = 100663798;
      appInfo.appLabelId = 1;
      appInfo.keyName = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry';
      dataConvert.setAppItemInfoList([appInfo]);

      let transferRelationModels: Array<TransferRelationModel> = [];
      let config: string = '\[{"sourcePackageName":"com.openharmony.contacts","sourceClassName":"com.ohos.contacts.activities.PeopleActivity",' +
        '"targetBundleName":"com.ohos.contacts","targetModuleName":"entry","targetAbilityName":"com.ohos.contacts.MainAbility"}\]';
      let jsonArray = JSON.parse(config) as TransferRelationModel[];
      for (const jsonEle of jsonArray) {
        let transferRelationModel: TransferRelationModel = new TransferRelationModel(jsonEle);
        transferRelationModels.push(transferRelationModel);
      }
      const mocker: MockKit = new MockKit();
      const getTransInfos: Function = mocker.mockFunc(transferRelationManager, transferRelationManager.getTransInfoForClass);
      when(getTransInfos)(ArgumentMatchers.any).afterReturn(transferRelationModels[0]);

      let backupInfo: BackupFavoriteInfo = {
        id: 0,
        title: '联系人',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 0,
      };
      backupInfo.intent = '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;' +
        'launchFlags=0x10200000;component=com.openharmony.contacts/com.ohos.contacts.activities.PeopleActivity;end';
      let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await appTransformItem.transformBackupInfoToGridInfo();
      expect(gridLayoutInfo.length).assertLargerOrEqual(0);
      mocker.clear(transferRelationManager);
      mocker.clearAll();
    })

    it('assert_transformBackupInfoToGridInfo03_7', 0, async () => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.contacts';
      appInfo.abilityName = 'com.ohos.contacts.MainAbility';
      appInfo.moduleName = 'entry';
      appInfo.typeId = CommonConstants.TYPE_APP;
      appInfo.badgeNumber = 0;
      appInfo.appIconId = 100663798;
      appInfo.appLabelId = 1;
      appInfo.keyName = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry';
      dataConvert.setAppItemInfoList([appInfo]);

      let transferRelationModels: Array<TransferRelationModel> = [];
      let config: string = '\[{"sourcePackageName":"com.openharmony.contacts","sourceClassName":"com.ohos.contacts.activities.PeopleActivity",' +
        '"targetBundleName":"com.ohos.contacts","targetModuleName":"entry","targetAbilityName":"com.ohos.contacts.MainAbility"}\]';
      let jsonArray = JSON.parse(config) as TransferRelationModel[];
      for (const jsonEle of jsonArray) {
        let transferRelationModel: TransferRelationModel = new TransferRelationModel(jsonEle);
        transferRelationModels.push(transferRelationModel);
      }
      const mocker: MockKit = new MockKit();
      const getTransInfos: Function = mocker.mockFunc(transferRelationManager, transferRelationManager.getTransInfoForClass);
      when(getTransInfos)(ArgumentMatchers.any).afterReturn(transferRelationModels[0]);

      let backupInfo: BackupFavoriteInfo = {
        id: 0,
        title: '联系人',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 2,
        cellY: 2,
        spanX: 1,
        spanY: 1,
        itemType: 0,
      };
      backupInfo.intent = '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;' +
        'launchFlags=0x10200000;component=com.openharmony.contacts/com.ohos.contacts.activities.PeopleActivity;end';
      let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await appTransformItem.transformBackupInfoToGridInfo();
      expect(gridLayoutInfo.length).assertLargerOrEqual(0);
    })

    it('assert_transformBackupInfoToGridInfo04', 0, async () => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.contacts';
      appInfo.abilityName = 'com.ohos.contacts.MainAbility';
      appInfo.moduleName = 'entry';
      appInfo.typeId = CommonConstants.TYPE_APP;
      appInfo.badgeNumber = 0;
      appInfo.appIconId = 100663798;
      appInfo.appLabelId = 1;
      appInfo.keyName = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry';
      dataConvert.setAppItemInfoList([appInfo]);

      let transferRelationModels: Array<TransferRelationModel> = [];
      let config: string = '\[{"sourcePackageName":"com.openharmony.contacts","sourceClassName":"com.ohos.contacts.activities.PeopleActivity",' +
        '"targetBundleName":"com.ohos.contacts","targetModuleName":"entry","targetAbilityName":"com.ohos.contacts.MainAbility"}\]';
      let jsonArray = JSON.parse(config) as TransferRelationModel[];
      for (const jsonEle of jsonArray) {
        let transferRelationModel: TransferRelationModel = new TransferRelationModel(jsonEle);
        transferRelationModels.push(transferRelationModel);
      }
      const mocker: MockKit = new MockKit();
      const getTransInfos: Function = mocker.mockFunc(transferRelationManager, transferRelationManager.getTransInfosForPackage);
      when(getTransInfos)(ArgumentMatchers.any).afterReturn(transferRelationModels[0]);

      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '联系人',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 2,
        cellY: 2,
        spanX: 1,
        spanY: 1,
        itemType: 1,
      };
      backupInfo.intent = '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;' +
        'launchFlags=0x10200000;component=com.openharmony.contacts/com.ohos.contacts.activities.PeopleActivity;end';
      let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await appTransformItem.transformBackupInfoToGridInfo();
      expect(gridLayoutInfo.length).assertLargerOrEqual(0);
    })

    it('assert_transformBackupInfoToGridInfoOnClone01', 0, async () => {
      let appTransformItem: AppTransformItem = new AppTransformItem(new BackupFavoriteInfo());
      let gridLayoutInfo: GridLayoutItemInfo[] = await appTransformItem.transformBackupInfoToGridInfoOnClone();
      expect(gridLayoutInfo.length).assertEqual(0);
    })

    it('assert_transformBackupInfoToGridInfoOnClone02_7', 0, async () => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.contacts';
      appInfo.abilityName = 'com.ohos.contacts.MainAbility';
      appInfo.moduleName = 'entry';
      appInfo.typeId = CommonConstants.TYPE_APP;
      appInfo.badgeNumber = 0;
      appInfo.appIconId = 100663798;
      appInfo.appLabelId = 1;
      appInfo.keyName = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry';
      dataConvert.setAppItemInfoList([appInfo]);

      let transferRelationModels: Array<TransferRelationModel> = [];
      let config: string = '\[{"sourcePackageName":"com.openharmony.contacts","sourceClassName":"com.ohos.contacts.activities.PeopleActivity",' +
        '"targetBundleName":"com.ohos.contacts","targetModuleName":"entry","targetAbilityName":"com.ohos.contacts.MainAbility"}\]';
      let jsonArray = JSON.parse(config) as TransferRelationModel[];
      for (const jsonEle of jsonArray) {
        let transferRelationModel: TransferRelationModel = new TransferRelationModel(jsonEle);
        transferRelationModels.push(transferRelationModel);
      }

      const mocker: MockKit = new MockKit();
      const getTransInfos: Function = mocker.mockFunc(transferRelationManager, transferRelationManager.getTransInfoForClass);
      when(getTransInfos)(ArgumentMatchers.any).afterReturn(transferRelationModels[0]);

      let backupInfo: BackupFavoriteInfo = {
        id: 0,
        title: '联系人',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 0,
      };
      backupInfo.intent = '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;' +
        'launchFlags=0x10200000;component=com.openharmony.contacts/com.ohos.contacts.activities.PeopleActivity;end';
      let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await appTransformItem.transformBackupInfoToGridInfoOnClone();
      expect(gridLayoutInfo.length).assertLargerOrEqual(0);
    })

    it('assert_transformBackupInfoToGridInfoOnClone03_7', 0, async () => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.contacts';
      appInfo.abilityName = 'com.ohos.contacts.MainAbility';
      appInfo.moduleName = 'entry';
      appInfo.typeId = CommonConstants.TYPE_APP;
      appInfo.badgeNumber = 0;
      appInfo.appIconId = 100663798;
      appInfo.appLabelId = 1;
      appInfo.keyName = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry';
      dataConvert.setAppItemInfoList([appInfo]);

      let transferRelationModels: Array<TransferRelationModel> = [];
      let config: string = '\[{"sourcePackageName":"com.openharmony.contacts","sourceClassName":"com.ohos.contacts.activities.PeopleActivity",' +
        '"targetBundleName":"com.ohos.contacts","targetModuleName":"entry","targetAbilityName":"com.ohos.contacts.MainAbility"}\]';
      let jsonArray = JSON.parse(config) as TransferRelationModel[];
      for (const jsonEle of jsonArray) {
        let transferRelationModel: TransferRelationModel = new TransferRelationModel(jsonEle);
        transferRelationModels.push(transferRelationModel);
      }
      const mocker: MockKit = new MockKit();
      const getTransInfos: Function = mocker.mockFunc(transferRelationManager, transferRelationManager.getTransInfoForClass);
      when(getTransInfos)(ArgumentMatchers.any).afterReturn(transferRelationModels[0]);

      let cloneItemInfo: CloneItemInfo = {
        bundleName: 'com.openharmony.contacts',
        packageName: 'com.ohos.contacts.activities.PeopleActivity',
        iconUri: ''
      };
      let cloneItemInfoManager: CloneItemInfoManager = CloneItemInfoManager.getInstance();
      const getCloneItemInfo: Function = mocker.mockFunc(cloneItemInfoManager, cloneItemInfoManager.getCloneItemInfoByPackageName);
      when(getCloneItemInfo)(ArgumentMatchers.any).afterReturn(cloneItemInfo);

      let backupInfo: BackupFavoriteInfo = {
        id: 0,
        title: '联系人',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 0,
      };
      backupInfo.intent = '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;' +
        'launchFlags=0x10200000;component=com.openharmony.contacts/com.ohos.contacts.activities.PeopleActivity;end';
      let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await appTransformItem.transformBackupInfoToGridInfoOnClone();
      expect(gridLayoutInfo.length).assertLargerOrEqual(0);
    })

    it('assert_transformBackupInfoToGridInfoOnClone04', 0, async () => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.contacts';
      appInfo.abilityName = 'com.ohos.contacts.MainAbility';
      appInfo.moduleName = 'entry';
      appInfo.typeId = CommonConstants.TYPE_APP;
      appInfo.badgeNumber = 0;
      appInfo.appIconId = 100663798;
      appInfo.appLabelId = 1;
      appInfo.keyName = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry';
      dataConvert.setAppItemInfoList([appInfo]);

      let transferRelationModels: Array<TransferRelationModel> = [];
      let config: string = '\[{"sourcePackageName":"com.openharmony.contacts","sourceClassName":"com.ohos.contacts.activities.PeopleActivity",' +
        '"targetBundleName":"com.ohos.contacts","targetModuleName":"entry","targetAbilityName":"com.ohos.contacts.MainAbility"}\]';
      let jsonArray = JSON.parse(config) as TransferRelationModel[];
      for (const jsonEle of jsonArray) {
        let transferRelationModel: TransferRelationModel = new TransferRelationModel(jsonEle);
        transferRelationModels.push(transferRelationModel);
      }
      const mocker: MockKit = new MockKit();
      const getTransInfos: Function = mocker.mockFunc(transferRelationManager, transferRelationManager.getTransInfosForPackage);
      when(getTransInfos)(ArgumentMatchers.any).afterReturn(transferRelationModels[0]);

      let cloneItemInfoManager: CloneItemInfoManager = CloneItemInfoManager.getInstance();
      const getCloneItemInfo: Function = mocker.mockFunc(cloneItemInfoManager, cloneItemInfoManager.getCloneItemInfoByPackageName);
      when(getCloneItemInfo)(ArgumentMatchers.any).afterReturn(null);

      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '联系人',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 1,
      };
      backupInfo.intent = '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;' +
        'launchFlags=0x10200000;component=com.openharmony.contacts/com.ohos.contacts.activities.PeopleActivity;end';
      let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await appTransformItem.transformBackupInfoToGridInfoOnClone();
      expect(gridLayoutInfo.length).assertEqual(0);
    })

    it('assert_transformBackupInfoToGridInfoOnClone05_7', 0, async () => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.contacts';
      appInfo.abilityName = 'com.ohos.contacts.MainAbility';
      appInfo.moduleName = 'entry';
      appInfo.typeId = CommonConstants.TYPE_APP;
      appInfo.badgeNumber = 0;
      appInfo.appIconId = 100663798;
      appInfo.appLabelId = 1;
      appInfo.keyName = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry';
      dataConvert.setAppItemInfoList([appInfo]);

      let transferRelationModels: Array<TransferRelationModel> = [];
      let config: string = '\[{"sourcePackageName":"com.openharmony.contacts","sourceClassName":"com.ohos.contacts.activities.PeopleActivity",' +
        '"targetBundleName":"com.ohos.contacts","targetModuleName":"entry","targetAbilityName":"com.ohos.contacts.MainAbility"}\]';
      let jsonArray = JSON.parse(config) as TransferRelationModel[];
      for (const jsonEle of jsonArray) {
        let transferRelationModel: TransferRelationModel = new TransferRelationModel(jsonEle);
        transferRelationModels.push(transferRelationModel);
      }
      const mocker: MockKit = new MockKit();
      const getTransInfos: Function = mocker.mockFunc(transferRelationManager, transferRelationManager.getTransInfoForClass);
      when(getTransInfos)(ArgumentMatchers.any).afterReturn(transferRelationModels[0]);

      let cloneItemInfo: CloneItemInfo = {
        bundleName: 'com.ohos.contacts',
        packageName: 'com.ohos.contacts.MainAbility',
        iconUri: ''
      };
      let cloneItemInfoManager: CloneItemInfoManager = CloneItemInfoManager.getInstance();
      const getCloneItemInfo: Function = mocker.mockFunc(cloneItemInfoManager, cloneItemInfoManager.getCloneItemInfoByPackageName);
      when(getCloneItemInfo)(ArgumentMatchers.any).afterReturn(cloneItemInfo);

      let backupInfo: BackupFavoriteInfo = {
        id: 0,
        title: '联系人',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 0,
      };
      backupInfo.intent = '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;' +
        'launchFlags=0x10200000;component=com.openharmony.contacts/com.ohos.contacts.activities.PeopleActivity;end';
      let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await appTransformItem.transformBackupInfoToGridInfoOnClone();
      expect(gridLayoutInfo.length).assertLargerOrEqual(0);
    })

    it('assert_transformBackupInfoToGridInfoOnClone06_7', 0, async () => {
      let backupInfo = new BackupFavoriteInfo();
      backupInfo.intent = '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;' +
        'launchFlags=0x10200000;component=com.xunmeng.pinduoduo/.ui.activity.MainFrameActivity;end';
      let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await appTransformItem.transformBackupInfoToGridInfoOnClone();
      expect(gridLayoutInfo.length).assertLargerOrEqual(0);
    })

    it('test_dealWithThirdAppItemInfo', 0, () => {
      let backupInfo: BackupFavoriteInfo = {
        id: 0,
        title: '联系人',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 0,
      };
      backupInfo.intent = '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;' +
        'launchFlags=0x10200000;component=com.openharmony.contacts/com.ohos.contacts.activities.PeopleActivity;end';
      let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);

      let localHapMigrateInfo: LocalHapMigrateInfo = {
        'sourceModule': 'sourceModule',
        'sourceModules': ['sourceModules'],
        'targetModule': 'targetModule',
        'migrateData': 'migrateData',
        'sourceModuleSignature': 'sourceModuleSignature',
        'type': 0,
        'targetModuleUrl': 'targetModuleUrl',
        'source': 'source',
        'sources': ['sources'],
        'target': 'target',
        'isValid': (): boolean => { return false }
      };
      let gridApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridApp.typeId = CommonConstants.TYPE_APP;
      gridApp.infoId = '60';
      gridApp.infoName = '设置';
      gridApp.bundleName = 'com.ohos.settings';
      gridApp.abilityName = 'com.ohos.settings.MainAbility';
      gridApp.moduleName = 'phone_settings';
      gridApp.container = CommonConstants.CONTAINER_DESKTOP;
      gridApp.badgeNumber = 3;
      gridApp.page = 0;
      gridApp.row = 0;
      gridApp.column = 1;
      gridApp.area = [1, 1];
      expect(appTransformItem['dealWithThirdAppItemInfo'](localHapMigrateInfo, gridApp) === undefined).assertTrue();
    })

    it('test_buildNotHmAppInfo', 0, () => {
      let backupInfo: BackupFavoriteInfo = {
        id: 0,
        title: '联系人',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 0,
      };
      backupInfo.intent = '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;' +
        'launchFlags=0x10200000;component=com.openharmony.contacts/com.ohos.contacts.activities.PeopleActivity;end';
      let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);

      let packageRelation: PackageRelation = {
        'packageName': 'packageName',
        'className': 'className',
        'shortcutId': 'xxxx',
      };
      let packageInfo: PackageInfo = {
        appName: 'appName',
        appScanSourceDir: 'appScanSourceDir',
        packageName: 'packageName',
        primaryCpuAbi: 'primaryCpuAbi',
        secondaryCpuAbi: 'secondaryCpuAbi',
        sign: 'sign',
        version: 'version',
        versionName: 'versionName',
        isValid: (): boolean => { return false }
      };
      let gridApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridApp.typeId = CommonConstants.TYPE_APP;
      gridApp.infoId = '60';
      gridApp.infoName = '设置';
      gridApp.bundleName = 'com.ohos.settings';
      gridApp.abilityName = 'com.ohos.settings.MainAbility';
      gridApp.moduleName = 'phone_settings';
      gridApp.container = CommonConstants.CONTAINER_DESKTOP;
      gridApp.badgeNumber = 3;
      gridApp.page = 0;
      gridApp.row = 0;
      gridApp.column = 1;
      gridApp.area = [1, 1];
      expect(appTransformItem['buildNotHmAppInfo'](gridApp, packageRelation, packageInfo) === undefined).assertTrue();
    })

    it('test_getCancelRestoreLauncherMap', 0, () => {
      try {
        let packageInfo: PackageInfo = {
          appName: 'appName',
          appScanSourceDir: 'appScanSourceDir',
          packageName: '',
          primaryCpuAbi: 'primaryCpuAbi',
          secondaryCpuAbi: 'secondaryCpuAbi',
          sign: 'sign',
          version: 'version',
          versionName: 'versionName',
          isValid: (): boolean => {
            return false
          }
        };
        expect(packageInfo.isValid()).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getCancelRestoreLauncherMap_02', 0, () => {
      try {
        const packageInfo: PackageInfo = new PackageInfo(new Object());
        packageInfo.packageName = '';
        expect(packageInfo.isValid()).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_dealWithAppItemInfo', 0, async () => {
      let backupInfo: BackupFavoriteInfo = {
        id: 0,
        title: '联系人',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 0,
      };
      backupInfo.intent = '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;' +
        'launchFlags=0x10200000;component=com.openharmony.contacts/com.ohos.contacts.activities.PeopleActivity;end';
      let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);

      let packageRelation: PackageRelation = {
        'packageName': 'packageName',
        'className': 'className',
        'shortcutId': 'xxxx',
      };
      let appItemInfo: AppItemInfo = {
        appIconId: 0,
        abilityName: 'abilityName',
        appName: 'appName',
        bundleName: 'bundleName'
      };
      let gridApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridApp.typeId = CommonConstants.TYPE_APP;
      gridApp.infoId = '60';
      gridApp.infoName = '设置';
      gridApp.bundleName = 'com.ohos.settings';
      gridApp.abilityName = 'com.ohos.settings.MainAbility';
      gridApp.moduleName = 'phone_settings';
      gridApp.container = CommonConstants.CONTAINER_DESKTOP;
      gridApp.badgeNumber = 3;
      gridApp.page = 0;
      gridApp.row = 0;
      gridApp.column = 1;
      gridApp.area = [1, 1];
      expect(await appTransformItem['dealWithAppItemInfo'](gridApp, appItemInfo, packageRelation) === undefined)
        .assertTrue();
    })

    it('test_transformBackupInfoToGridInfo_1', 0, async () => {
      const backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
      let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);
      const packageRelation: PackageRelation = {
        packageName: '1',
        className: '1',
        shortcutId: 'xxxx',
      }
      AppTransformItem['notShowDesktopAppSet'].add('1');
      const mocker: MockKit = new MockKit();
      const funct1: Function = mocker.mockFunc(IntentParseUtil, IntentParseUtil.getComponentByIntent);
      when(funct1)(ArgumentMatchers.any).afterReturn(packageRelation);
      const result: GridLayoutItemInfo[] = await appTransformItem.transformBackupInfoToGridInfo();
      expect(result.length).assertEqual(0);
      mocker.clear(IntentParseUtil);
      mocker.clearAll();
    })

    it('test_transformBackupInfoToGridInfo_2_7', 0, async () => {
      try {
        const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridLayoutItemInfo.bundleName = 'com.ohos.parentcontrol';
        const backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
        let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);
        const localHapMigrateInfo: LocalHapMigrateInfo = new LocalHapMigrateInfo(new Object());
        dataConvert.setCurUserId(1);
        const packageRelation: PackageRelation = {
          packageName: '223231',
          className: '44444444444',
          shortcutId: 'xxxx',
        }
        const mocker: MockKit = new MockKit();
        const funct1: Function = mocker.mockFunc(IntentParseUtil, IntentParseUtil.getComponentByIntent);
        when(funct1)(ArgumentMatchers.any).afterReturn(packageRelation);
        const funct2: Function = mocker.mockFunc(appTransformItem, appTransformItem['buildGridInfoByBackupInfo']);
        when(funct2)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo);
        const funct3: Function = mocker.mockFunc(appTransformItem, appTransformItem['getAppItemInfoByIntent']);
        when(funct3)(ArgumentMatchers.any).afterReturn(null);
        const funct4: Function = mocker.mockFunc(appTransformItem['transformAppManager'],
          appTransformItem['transformAppManager']['getMigrateByBundleAndType']);
        when(funct4)(ArgumentMatchers.any).afterReturn(localHapMigrateInfo);
        const funct8: Function = mocker.mockFunc(appTransformItem,
          appTransformItem['dealWithThirdAppItemInfo']);
        when(funct8)(ArgumentMatchers.any).afterReturn(undefined);
        const result: GridLayoutItemInfo[] = await appTransformItem.transformBackupInfoToGridInfo();
        expect(result.length).assertLargerOrEqual(0);
        gridLayoutItemInfo.bundleName = 'nice';
        const result1: GridLayoutItemInfo[] = await appTransformItem.transformBackupInfoToGridInfo();
        expect(result1.length).assertLargerOrEqual(0);
        when(funct4)(ArgumentMatchers.any).afterReturn(null);
        const funct5: Function = mocker.mockFunc(appTransformItem['transformAppManager'],
          appTransformItem['transformAppManager']['getAppReservePolicy']);
        when(funct5)(ArgumentMatchers.any).afterReturn(AppReservePolicyType.UNDEFINED);
        const result2: GridLayoutItemInfo[] = await appTransformItem.transformBackupInfoToGridInfo();
        expect(result2.length).assertLargerOrEqual(0);
        when(funct5)(ArgumentMatchers.any).afterReturn(AppReservePolicyType.RESERVE);
        gridLayoutItemInfo.appIndex = 0;
        const result3: GridLayoutItemInfo[] = await appTransformItem.transformBackupInfoToGridInfo();
        expect(result3.length).assertLargerOrEqual(0);
        gridLayoutItemInfo.appIndex = 3;
        const result4: GridLayoutItemInfo[] = await appTransformItem.transformBackupInfoToGridInfo();
        expect(result4.length).assertLargerOrEqual(0);
        mocker.clear(IntentParseUtil);
        mocker.clear(appTransformItem['transformAppManager']);
        mocker.clear(appTransformItem);
        mocker.clearAll();
      }catch(err){
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('test_dealWithThirdAppItemInfo_1', 0,  () => {
      const backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
      let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const localHapMigrateInfo: LocalHapMigrateInfo = new LocalHapMigrateInfo(new Object());
      localHapMigrateInfo.sourceModule = '1.1'
      const appItemInfo:AppItemInfo = new AppItemInfo();
      localHapMigrateInfo.targetModule = '1';
      appItemInfo.bundleName = '1';
      gridLayoutItemInfo.appIndex = 0;
      dataConvert.setAppItemInfoList([appItemInfo]);
      dataConvert.setOldIconPath('123');
      appTransformItem['dealWithThirdAppItemInfo'](localHapMigrateInfo,gridLayoutItemInfo);
      gridLayoutItemInfo.appIndex = 2;
      localHapMigrateInfo.type = 1;
      const mocker: MockKit = new MockKit();
      const funct1: Function = mocker.mockFunc(FileUtils, FileUtils.isExist);
      when(funct1)(ArgumentMatchers.any).afterReturn(false);
      appTransformItem['dealWithThirdAppItemInfo'](localHapMigrateInfo,gridLayoutItemInfo);
      localHapMigrateInfo.type = 0;
      when(funct1)(ArgumentMatchers.any).afterReturn(true);
      appTransformItem['dealWithThirdAppItemInfo'](localHapMigrateInfo,gridLayoutItemInfo);
      expect(gridLayoutItemInfo.iconResource?.startsWith('file')).assertTrue();
      mocker.clear(FileUtils);
      mocker.clearAll();
    })

    it('test_dealWithAppItemInfo_1_7', 0,  () => {
      const backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
      let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const appItemInfo:AppItemInfo = new AppItemInfo();
      const packageRelation: PackageRelation = {
        packageName: '1.jpg',
        className: '44444444444',
        shortcutId: 'xxxx',
      }
      dataConvert.setOldIconPath('123');
      gridLayoutItemInfo.appIndex = 10;
      const mocker: MockKit = new MockKit();
      const funct1: Function = mocker.mockFunc(FileUtils, FileUtils.isExist);
      when(funct1)(ArgumentMatchers.any).afterReturn(true);
      appTransformItem['dealWithAppItemInfo'](gridLayoutItemInfo,appItemInfo,packageRelation);
      gridLayoutItemInfo.iconResource = '';
      when(funct1)(ArgumentMatchers.any).afterReturn(false);
      appTransformItem['dealWithAppItemInfo'](gridLayoutItemInfo,appItemInfo,packageRelation);
      expect(appTransformItem instanceof AppTransformItem).assertTrue();
      mocker.clear(FileUtils);
      mocker.clearAll();
    })

    it('test_buildNotHmAppInfo_1', 0,  () => {
      const backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
      backupInfo.title = 'title';
      let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.bundleName = 'ggg'
      const packageInfo:PackageInfo = new PackageInfo(new Object());
      packageInfo.sign = '1';
      packageInfo.appScanSourceDir = '1';
      packageInfo.version = '1';
      packageInfo.versionName = '1';
      packageInfo.primaryCpuAbi = '1';
      packageInfo.secondaryCpuAbi = '1';
      const packageRelation: PackageRelation = {
        packageName: '1.jpg',
        className: '44444444444',
        shortcutId: 'xxxx',
      }
      dataConvert.setOldIconPath('123');
      gridLayoutItemInfo.appIndex = 10;
      const mocker: MockKit = new MockKit();
      const funct1: Function = mocker.mockFunc(FileUtils, FileUtils.isExist);
      when(funct1)(ArgumentMatchers.any).afterReturn(true);
      const funct2: Function = mocker.mockFunc(appTransformItem['transformAppManager'], appTransformItem['transformAppManager'].isTasteFreshApp);
      when(funct2)(ArgumentMatchers.any).afterReturn(true);
      appTransformItem['buildNotHmAppInfo'](gridLayoutItemInfo,packageRelation,undefined);
      appTransformItem['buildNotHmAppInfo'](gridLayoutItemInfo,packageRelation,packageInfo);
      when(funct1)(ArgumentMatchers.any).afterReturn(false);
      when(funct2)(ArgumentMatchers.any).afterReturn(false);
      appTransformItem['buildNotHmAppInfo'](gridLayoutItemInfo,packageRelation,undefined);
      appTransformItem['buildNotHmAppInfo'](gridLayoutItemInfo,packageRelation,packageInfo);
      expect(gridLayoutItemInfo.iconResource?.startsWith('file')).assertTrue();
      mocker.clear(FileUtils);
      mocker.clear(appTransformItem['transformAppManager']);
      mocker.clearAll();
    })

    it('test_dealWithUnInstalledAppItem_1', 0,  () => {
      const backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
      let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);
      const mapObject:Map<string,Object> = new Map();
      mapObject.set('legacyInfo',[]);
      const cloneItemInfo:CloneItemInfo = {
        bundleName: '4444',
        packageName: '2222.1',
        iconUri: '1111',
        callerName:'888',
        title:'0000',
        intent: JSON.stringify(mapObject)
      }
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.appIndex = 1;
      const mocker: MockKit = new MockKit();
      const funct1: Function = mocker.mockFunc(FileUtils, FileUtils.isExist);
      when(funct1)(ArgumentMatchers.any).afterReturn(true);
      appTransformItem['dealWithUnInstalledAppItem'](cloneItemInfo,gridLayoutItemInfo);
      when(funct1)(ArgumentMatchers.any).afterReturn(false);
      appTransformItem['dealWithUnInstalledAppItem'](cloneItemInfo,gridLayoutItemInfo);
      mapObject.clear();
      cloneItemInfo.intent = JSON.stringify(mapObject);
      appTransformItem['dealWithUnInstalledAppItem'](cloneItemInfo,gridLayoutItemInfo);
      expect(gridLayoutItemInfo.iconResource === '1111').assertTrue();
      mocker.clear(FileUtils);
      mocker.clearAll();
    })

    it('test_getAppItemInfoByIntent_1', 0,  () => {
      const obj:Object = new Object();
      const backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
      let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);
      const transferRelationModel:TransferRelationModel = new TransferRelationModel(obj);
      transferRelationModel['targetBundleName'] = '1';
      const packageRelation: PackageRelation = {
        packageName: '1.jpg',
        className: '44444444444',
        shortcutId: 'xxxx',
      }
      const appItemInfo:AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = '1';
      appItemInfo.appIndex = undefined;
      dataConvert.setAppItemInfoList([appItemInfo]);
      expect(appTransformItem['getAppItemInfoByIntent'](null,0)).assertNull();
      const mocker: MockKit = new MockKit();
      const funct1: Function = mocker.mockFunc(transferRelationManager, transferRelationManager.getTransInfosForPackage);
      when(funct1)(ArgumentMatchers.any).afterReturn([transferRelationModel]);
      expect(appTransformItem['getAppItemInfoByIntent'](packageRelation,0)).not().assertNull();
      expect(appTransformItem['getAppItemInfoByIntent'](packageRelation,1)).not().assertNull();
      mocker.clear(transferRelationManager);
      mocker.clearAll();
    })

    it('test_isdeliverFolderApp_0_7', 0,  () => {
      const backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
      let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);
      const legacyInfo: LegacyInfo = new LegacyInfo();
      let bundleName: string = 'bundleName';
      const mocker: MockKit = new MockKit();
      const funct1: Function = mocker.mockFunc(appTransformItem['transformAppManager'],
        appTransformItem['transformAppManager']['isdeliverApp']);
      const funct2: Function = mocker.mockFunc(appTransformItem['transformAppManager'],
        appTransformItem['transformAppManager']['isOtherdeliverApp']);
      const funct3: Function = mocker.mockFunc(NotHarmonyUtil, NotHarmonyUtil.isSupport64);

      when(funct1)(ArgumentMatchers.any).afterReturn(false);
      when(funct2)(ArgumentMatchers.any).afterReturn(false);

      when(funct1)(ArgumentMatchers.any).afterReturn(true);
      when(funct2)(ArgumentMatchers.any).afterReturn(false);
      when(funct3)(ArgumentMatchers.any).afterReturn(false);

      when(funct1)(ArgumentMatchers.any).afterReturn(false);
      when(funct2)(ArgumentMatchers.any).afterReturn(true);
      when(funct3)(ArgumentMatchers.any).afterReturn(false);

      when(funct1)(ArgumentMatchers.any).afterReturn(true);
      when(funct2)(ArgumentMatchers.any).afterReturn(false);
      when(funct3)(ArgumentMatchers.any).afterReturn(true);
      expect(appTransformItem instanceof AppTransformItem).assertTrue();
      mocker.clear(NotHarmonyUtil);
      mocker.clearAll();
    })

    it('test_dealShortCutToGridLayoutItem_normal_7', 0, async () => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.parentcontrol';
      appInfo.abilityName = 'SceneUIAbility';
      appInfo.moduleName = 'parentcontrol.phone';
      appInfo.typeId = CommonConstants.TYPE_APP;
      appInfo.badgeNumber = 0;
      appInfo.keyName = 'com.ohos.parentcontrolSceneUIAbilityparentcontrol.phone';
      dataConvert.setAppItemInfoList([appInfo]);

      let transferRelationModels: Array<TransferRelationModel> = [];
      let config: string =
        '\[{"sourcePackageName":"com.openharmony.parentcontrol.parent","sourceClassName":"com.openharmony.parentcontrol.parent.ui.activity.HomeActivity",' +
          '"targetBundleName":"com.ohos.parentcontrol","targetModuleName":"parentcontrol.phone","targetAbilityName":"SceneUIAbility","appIndex": "0","shortCutId": "remoteguard_shortcut"}\]';
      let jsonArray = JSON.parse(config) as TransferRelationModel[];
      for (const jsonEle of jsonArray) {
        let transferRelationModel: TransferRelationModel = new TransferRelationModel(jsonEle);
        transferRelationModels.push(transferRelationModel);
      }
      const mocker: MockKit = new MockKit();
      const getTransInfos: Function =
        mocker.mockFunc(transferRelationManager, transferRelationManager.getTransInfoForClass);
      when(getTransInfos)(ArgumentMatchers.any).afterReturn(transferRelationModels[0]);

      let cloneItemInfo: CloneItemInfo = {
        bundleName: 'com.openharmony.parentcontrol.parent',
        packageName: 'com.openharmony.parentcontrol.parent.ui.activity.HomeActivity',
        iconUri: ''
      };
      let cloneItemInfoManager: CloneItemInfoManager = CloneItemInfoManager.getInstance();
      const getCloneItemInfo: Function =
        mocker.mockFunc(cloneItemInfoManager, cloneItemInfoManager.getCloneItemInfoByPackageName);
      when(getCloneItemInfo)(ArgumentMatchers.any).afterReturn(cloneItemInfo);

      let backupInfo: BackupFavoriteInfo = {
        id: 0,
        title: '家长助手',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 0,
      };
      backupInfo.intent = '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;' +
        'launchFlags=0x10200000;component=com.openharmony.parentcontrol.parent/com.openharmony.parentcontrol.parent.ui.activity.HomeActivity;end';
      let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await appTransformItem.transformBackupInfoToGridInfoOnClone();
      expect(gridLayoutInfo.length).assertLargerOrEqual(0);
      expect(gridLayoutInfo[0].typeId).assertEqual(CommonConstants.TYPE_SHORTCUT_ICON);
    })

    it('test_dealShortCutToGridLayoutItem_abnormal_7', 0, async () => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.parentcontrol';
      appInfo.abilityName = 'SceneUIAbility';
      appInfo.moduleName = 'parentcontrol.phone';
      appInfo.typeId = CommonConstants.TYPE_APP;
      appInfo.badgeNumber = 0;
      appInfo.keyName = 'com.ohos.parentcontrolSceneUIAbilityparentcontrol.phone';
      dataConvert.setAppItemInfoList([appInfo]);

      let transferRelationModels: Array<TransferRelationModel> = [];
      let config: string =
        '\[{"sourcePackageName":"com.openharmony.parentcontrol.parent","sourceClassName":"com.openharmony.parentcontrol.parent.ui.activity.HomeActivity",' +
          '"targetBundleName":"com.ohos.parentcontrol","targetModuleName":"parentcontrol.phone","targetAbilityName":"SceneUIAbility","appIndex": "0","shortCutId": "remoteguard_shortcut1"}\]';
      let jsonArray = JSON.parse(config) as TransferRelationModel[];
      for (const jsonEle of jsonArray) {
        let transferRelationModel: TransferRelationModel = new TransferRelationModel(jsonEle);
        transferRelationModels.push(transferRelationModel);
      }
      const mocker: MockKit = new MockKit();
      const getTransInfos: Function =
        mocker.mockFunc(transferRelationManager, transferRelationManager.getTransInfoForClass);
      when(getTransInfos)(ArgumentMatchers.any).afterReturn(transferRelationModels[0]);

      let cloneItemInfo: CloneItemInfo = {
        bundleName: 'com.openharmony.parentcontrol.parent',
        packageName: 'com.openharmony.parentcontrol.parent.ui.activity.HomeActivity',
        iconUri: ''
      };
      let cloneItemInfoManager: CloneItemInfoManager = CloneItemInfoManager.getInstance();
      const getCloneItemInfo: Function =
        mocker.mockFunc(cloneItemInfoManager, cloneItemInfoManager.getCloneItemInfoByPackageName);
      when(getCloneItemInfo)(ArgumentMatchers.any).afterReturn(cloneItemInfo);

      let backupInfo: BackupFavoriteInfo = {
        id: 0,
        title: '家长助手',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 0,
      };
      backupInfo.intent = '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;' +
        'launchFlags=0x10200000;component=com.openharmony.parentcontrol.parent/com.openharmony.parentcontrol.parent.ui.activity.HomeActivity;end';
      let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await appTransformItem.transformBackupInfoToGridInfoOnClone();
      expect(gridLayoutInfo.length).assertLargerOrEqual(0);
      expect(gridLayoutInfo[0].typeId).assertEqual(CommonConstants.TYPE_APP);
    })

    it('test_setMultiMappingRelationship_1', 0,  () => {
      let backupInfo: BackupFavoriteInfo = {
        id: 0,
        title: '家长助手',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 0,
      };
      backupInfo.intent = '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;' +
        'launchFlags=0x10200000;component=com.openharmony.parentcontrol.parent/com.openharmony.parentcontrol.parent.ui.activity.HomeActivity;end';
      let appTransformItem: AppTransformItem = new AppTransformItem(backupInfo);
      let localHapMigrateInfo: LocalHapMigrateInfo = new LocalHapMigrateInfo(new Object());
      localHapMigrateInfo.sourceModules = ['module1', 'module2'];
      localHapMigrateInfo.sourceModule = 'com.openharmony.hwonekeylock';
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(appTransformItem['setMultiMappingRelationship'](localHapMigrateInfo, item) === undefined).assertTrue();
    })

    it('test_isInPrivateSpaceBlockList_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(dataConvert, dataConvert.getCurUserId);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(100);

        let appTransformItem: AppTransformItem = new AppTransformItem(new BackupFavoriteInfo());
        appTransformItem['isInPrivateSpaceBlockList']('');
        expect(appTransformItem instanceof AppTransformItem).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(dataConvert);
      mock.clearAll();
    })

    it('test_isInPrivateSpaceBlockList_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(dataConvert, dataConvert.getCurUserId);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(101);

        let appTransformItem: AppTransformItem = new AppTransformItem(new BackupFavoriteInfo());
        appTransformItem['isInPrivateSpaceBlockList']('com.ohos.parentcontrol');
        expect(appTransformItem instanceof AppTransformItem).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(dataConvert);
      mock.clearAll();
    })

    it('test_isInPrivateSpaceBlockList_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(dataConvert, dataConvert.getCurUserId);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(101);

        let appTransformItem: AppTransformItem = new AppTransformItem(new BackupFavoriteInfo());
        appTransformItem['isInPrivateSpaceBlockList']('com.ohos.parentcontrol_test123');
        expect(appTransformItem instanceof AppTransformItem).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(dataConvert);
      mock.clearAll();
    })

    it('test_dealShortCutToGridLayoutItem_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function =
          mock.mockFunc(ShortcutViewModel.getInstance(), ShortcutViewModel.getInstance().getShortcutByBundleName);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([]);

        let appItemInfo: AppItemInfo = new AppItemInfo();
        appItemInfo.bundleName = 'com.ohos.contacts';
        let gridApp: GridLayoutItemInfo = new GridLayoutItemInfo();
        let appTransformItem: AppTransformItem = new AppTransformItem(new BackupFavoriteInfo());
        appTransformItem['dealShortCutToGridLayoutItem'](appItemInfo, gridApp);
        expect(appTransformItem instanceof AppTransformItem).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ShortcutViewModel.getInstance());
      mock.clearAll();
    })

    it('test_dealShortCutToGridLayoutItem_02', 0, () => {
      let mock = new MockKit();
      try {
        let shortcutInfo = {
          id: '1',
          bundleName: 'bundleName',
          appIndex: 0,
          sourceType: 0,
          iconId: 0,
          labelId: 0,
        } as ShortcutInfo;
        let list: ShortcutInfo[] = [shortcutInfo];
        let mockFunc: Function =
          mock.mockFunc(ShortcutViewModel.getInstance(), ShortcutViewModel.getInstance().getShortcutByBundleName);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(list);

        let appItemInfo: AppItemInfo = new AppItemInfo();
        appItemInfo.bundleName = 'com.ohos.contacts';
        appItemInfo.shortcutId = '2';
        let gridApp: GridLayoutItemInfo = new GridLayoutItemInfo();
        let appTransformItem: AppTransformItem = new AppTransformItem(new BackupFavoriteInfo());
        appTransformItem['dealShortCutToGridLayoutItem'](appItemInfo, gridApp);
        expect(appTransformItem instanceof AppTransformItem).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ShortcutViewModel.getInstance());
      mock.clearAll();
    })

    it('test_dealShortCutToGridLayoutItem_03', 0, () => {
      let mock = new MockKit();
      try {
        let shortcutInfo = {
          id: '1',
          bundleName: 'bundleName',
          appIndex: 0,
          sourceType: 0,
          iconId: 0,
          labelId: 0,
        } as ShortcutInfo;
        let list: ShortcutInfo[] = [shortcutInfo];
        let mockFunc: Function =
          mock.mockFunc(ShortcutViewModel.getInstance(), ShortcutViewModel.getInstance().getShortcutByBundleName);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(list);

        let mockFunc2: Function = mock.mockFunc(dataConvert, dataConvert.isShortcutInBMS);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc3: Function = mock.mockFunc(ShortcutViewModel.getInstance(), ShortcutViewModel.getInstance().addShortcutToBMS);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(1);

        let appItemInfo: AppItemInfo = new AppItemInfo();
        appItemInfo.bundleName = 'com.ohos.contacts';
        appItemInfo.shortcutId = '1';
        let gridApp: GridLayoutItemInfo = new GridLayoutItemInfo();
        let appTransformItem: AppTransformItem = new AppTransformItem(new BackupFavoriteInfo());
        appTransformItem['dealShortCutToGridLayoutItem'](appItemInfo, gridApp);
        expect(appTransformItem instanceof AppTransformItem).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ShortcutViewModel.getInstance());
      mock.clear(dataConvert);
      mock.clearAll();
    })

    it('test_dealShortCutToGridLayoutItem_04', 0, () => {
      let mock = new MockKit();
      try {
        let shortcutInfo = {
          id: '1',
          bundleName: 'bundleName',
          appIndex: 0,
          sourceType: 0,
          iconId: 0,
          labelId: 0,
        } as ShortcutInfo;
        let list: ShortcutInfo[] = [shortcutInfo];
        let mockFunc: Function =
          mock.mockFunc(ShortcutViewModel.getInstance(), ShortcutViewModel.getInstance().getShortcutByBundleName);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(list);

        let mockFunc2: Function = mock.mockFunc(dataConvert, dataConvert.isShortcutInBMS);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let appItemInfo: AppItemInfo = new AppItemInfo();
        appItemInfo.bundleName = 'com.ohos.contacts';
        appItemInfo.shortcutId = '1';
        let gridApp: GridLayoutItemInfo = new GridLayoutItemInfo();
        let appTransformItem: AppTransformItem = new AppTransformItem(new BackupFavoriteInfo());
        appTransformItem['dealShortCutToGridLayoutItem'](appItemInfo, gridApp);
        expect(appTransformItem instanceof AppTransformItem).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ShortcutViewModel.getInstance());
      mock.clear(dataConvert);
      mock.clearAll();
    })




  })
}