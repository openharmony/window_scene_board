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
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  Level,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';

import dataConvert from '../../../../../../main/ets/transformdata/DataConvert';
import { CloneItemInfo, SceneType } from '../../../../../../main/ets/constants/CommonConstants';
import type { BackupFavoriteInfo } from '../../../../../../main/ets/model/BackupFavoriteInfo';
import GridLayoutItemInfo from '../../../../../../main/ets/bean/GridLayoutItemInfo';
import { BaseTransformItem } from '../../../../../../main/ets/transformdata/transfromitem/BaseTransformItem';
import {
  AppItemInfo,
  AppStatus,
  BackupSceneBundleVersionName, CardItemInfo, CommonConstants,
  FormModel,
  FormRelationManager,
  LauncherLayoutCacheUtil,
  RdbStoreManager} from '../../../../../../main/ets/TsIndex';
import { CheckEmptyUtils, FileUtils } from '@ohos/basicutils';
import { TransformItemFactory } from '../../../../../../main/ets/transformdata/transfromitem/TransformItemFactory';
import { DeliverUtil } from '../../../../../../main/ets/utils/DeliverUtil';
import { CloneItemInfoManager } from '../../../../../../main/ets/transformdata/manager/CloneItemInfoManager';

function initGridLayoutItemInfos(): GridLayoutItemInfo[] {
  let layoutInfos: GridLayoutItemInfo[] = [];

  let gridLayoutAppApp1: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutAppApp1.typeId = CommonConstants.TYPE_APP;
  gridLayoutAppApp1.infoId = '37f7caf8-eff6-46ab-aefe-0f9786e47669';
  gridLayoutAppApp1.infoName = '电召PLUS';
  gridLayoutAppApp1.bundleName = 'macao.taxi.passager';
  gridLayoutAppApp1.abilityName = 'MainAbility';
  gridLayoutAppApp1.moduleName = 'phone';
  gridLayoutAppApp1.container = 66;
  gridLayoutAppApp1.page = 0;
  gridLayoutAppApp1.row = 1;
  gridLayoutAppApp1.column = 0;
  gridLayoutAppApp1.area = [1, 1];
  gridLayoutAppApp1.intent =
    '{"legacyInfo":{"pkgName":"macao.taxi.passager","pkgLableName":"电召PLUS","pkgSignature":"8c6e07f87c9db98fde934f69bdaaf653ef1176b0e0aa5959de87b34203a8d5f3","versionCode":"2025052303","versionName":"3.3.7","installSource":"com.ohos.abroad"},"targetModuleUrl":"","requestBundleName":"__WAIT_FOR_HARMONY_BUNDLENAME__macao.taxi.passager__1750122530100","installSource":"com.ohos.abroad","appType":0,"maskState":0}';


  let gridLayoutAppApp2: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutAppApp2.typeId = CommonConstants.TYPE_APP;
  gridLayoutAppApp2.infoId = '37f7caf8-eff6-46ab-aefe-0f9786e47669';
  gridLayoutAppApp2.infoName = '香港航班资讯';
  gridLayoutAppApp2.bundleName = 'com.eks.hkflight';
  gridLayoutAppApp2.abilityName = 'MainAbility';
  gridLayoutAppApp2.moduleName = 'phone';
  gridLayoutAppApp2.container = 66;
  gridLayoutAppApp2.page = 0;
  gridLayoutAppApp2.row = 0;
  gridLayoutAppApp2.column = 1;
  gridLayoutAppApp2.area = [1, 1];
  gridLayoutAppApp2.intent =
    '{"legacyInfo":{"pkgName":"com.eks.hkflight","pkgLableName":"香港航班资讯","pkgSignature":"","versionCode":"","versionName":"","installSource":"com.ohos.abroad"},"targetModuleUrl":"","requestBundleName":"__WAIT_FOR_HARMONY_BUNDLENAME__com.eks.hkflight__1750477794802","installSource":"com.ohos.abroad","appType":0,"maskState":0}';

  let gridLayoutdeliverApp1: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutdeliverApp1.typeId = CommonConstants.TYPE_APP;
  gridLayoutdeliverApp1.infoId = '37f7caf8-eff6-46ab-aefe-0f9786e47669';
  gridLayoutdeliverApp1.infoName = '电召PLUS';
  gridLayoutdeliverApp1.bundleName = 'macao.taxi.passager';
  gridLayoutdeliverApp1.abilityName = 'MainAbility';
  gridLayoutdeliverApp1.moduleName = 'phone';
  gridLayoutdeliverApp1.container = -100;
  gridLayoutdeliverApp1.row = 0;
  gridLayoutdeliverApp1.column = 0;
  gridLayoutdeliverApp1.area = [1, 1];
  gridLayoutdeliverApp1.intent =
    '{"legacyInfo":{"pkgName":"macao.taxi.passager","pkgLableName":"电召PLUS","pkgSignature":"8c6e07f87c9db98fde934f69bdaaf653ef1176b0e0aa5959de87b34203a8d5f3","versionCode":"2025052303","versionName":"3.3.7","installSource":"com.deliver.appstore.lite"},"targetModuleUrl":"","requestBundleName":"__WAIT_FOR_HARMONY_BUNDLENAME__macao.taxi.passager__1750122530100","installSource":"com.deliver.appstore.lite","appType":0,"maskState":0}';

  let gridLayoutdeliverApp2: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutdeliverApp2.typeId = CommonConstants.TYPE_APP;
  gridLayoutdeliverApp2.infoId = 'a1a6df81-66c7-428c-b340-66f3610356d8';
  gridLayoutdeliverApp2.infoName = '掌上穿越火线';
  gridLayoutdeliverApp2.bundleName = 'com.tencent.qt.sns';
  gridLayoutdeliverApp2.abilityName = 'MainAbility';
  gridLayoutdeliverApp2.moduleName = 'phone';
  gridLayoutdeliverApp2.container = -100;
  gridLayoutdeliverApp2.page = 0;
  gridLayoutdeliverApp2.row = 0;
  gridLayoutdeliverApp2.column = 1;
  gridLayoutdeliverApp2.area = [1, 1];
  gridLayoutdeliverApp2.intent = '{"legacyInfo":{"pkgName":"com.tencent.qt.sns","pkgLableName":"掌上穿越火线","pkgSignature":"90eec83fcadc14edefe83d33d6578ad6111957a3975b7a2a2eddfbd262a96a5d","versionCode":"2103290004","versionName":"3.29.0","installSource":"com.deliver.appstore.lite"},"targetModuleUrl":"","requestBundleName":"__WAIT_FOR_HARMONY_BUNDLENAME__com.tencent.qt.sns__1750157767972","installSource":"com.deliver.appstore.lite","appType":0,"maskState":0}';

  let gridLayoutApp: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutApp.typeId = CommonConstants.TYPE_APP;
  gridLayoutApp.infoId = '60';
  gridLayoutApp.infoName = '设置';
  gridLayoutApp.bundleName = 'com.ohos.settings';
  gridLayoutApp.abilityName = 'com.ohos.settings.MainAbility';
  gridLayoutApp.moduleName = 'phone_settings';
  gridLayoutApp.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutApp.badgeNumber = 3;
  gridLayoutApp.page = 0;
  gridLayoutApp.row = 0;
  gridLayoutApp.column = 1;
  gridLayoutApp.area = [1, 1];
  layoutInfos =
    [gridLayoutAppApp1, gridLayoutAppApp2, gridLayoutdeliverApp1, gridLayoutdeliverApp2, gridLayoutApp];
  return layoutInfos;
}

function initCloneItemInfos(): CloneItemInfo[] {
  let cloneItemInfos: CloneItemInfo[] = [];
  let abnormalAppinfo: CloneItemInfo = {
    bundleName: 'com.alipay.mobile.client',
    packageName: 'com.eg.harmony.AlipayGphone',
    iconUri: 'file://com.ohos.sceneboard/data/storage/el1/base/haps/phone_sceneboard/files/RestoreIconData/com.alipay.mobile.client.png',
    title: '支付宝',
    callerName: 'com.ohos.dataclone',
    isUsed: false,
    appIndex: 7,
    isInContainer: false,
    appType: 0
  } as CloneItemInfo;

  let appAppinfo1: CloneItemInfo = {
    bundleName: 'macao.taxi.passager',
    packageName: 'macao.taxi.passager',
    iconUri: 'file://com.ohos.sceneboard/data/storage/el1/base/haps/phone_sceneboard/files/RestoreIconData/macao.taxi.passager.png',
    title: '电召PLUS',
    callerName: 'com.ohos.dataclone',
    isUsed: false,
    appIndex: 0,
    isInContainer: false,
    intent: '{"legacyInfo":{"pkgName":"macao.taxi.passager","pkgLableName":"电召PLUS","pkgSignature":"8c6e07f87c9db98fde934f69bdaaf653ef1176b0e0aa5959de87b34203a8d5f3","versionCode":"2025052303","versionName":"3.3.7","installSource":"com.ohos.abroad"},"targetModuleUrl":"","requestBundleName":"__WAIT_FOR_HARMONY_BUNDLENAME__macao.taxi.passager__1750122530100","installSource":"com.ohos.abroad","appType":0,"maskState":0}',
    appType: 0
  } as CloneItemInfo;

  let appAppinfo2: CloneItemInfo = {
    bundleName: 'com.eks.hkflight',
    packageName: 'com.eks.hkflight',
    iconUri: 'file://com.ohos.sceneboard/data/storage/el1/base/haps/phone_sceneboard/files/RestoreIconData/com.eks.hkflight.png',
    title: '香港航班资讯',
    callerName: 'com.ohos.dataclone',
    isUsed: false,
    appIndex: 0,
    isInContainer: false,
    intent: '{"legacyInfo":{"pkgName":"com.eks.hkflight","pkgLableName":"香港航班资讯","pkgSignature":"","versionCode":"","versionName":"","installSource":"com.ohos.abroad"},"targetModuleUrl":"","requestBundleName":"__WAIT_FOR_HARMONY_BUNDLENAME__com.eks.hkflight__1750477794802","installSource":"com.ohos.abroad","appType":0,"maskState":0}',
    appType: 0
  } as CloneItemInfo;

  let deliverAppinfo1: CloneItemInfo = {
    bundleName: 'macao.taxi.passager',
    packageName: 'macao.taxi.passager',
    iconUri: 'file://com.ohos.sceneboard/data/storage/el1/base/haps/phone_sceneboard/files/RestoreIconData/macao.taxi.passager.png',
    title: '电召PLUS',
    callerName: 'com.ohos.dataclone',
    isUsed: false,
    appIndex: 0,
    isInContainer: false,
    intent: '{"legacyInfo":{"pkgName":"macao.taxi.passager","pkgLableName":"电召PLUS","pkgSignature":"8c6e07f87c9db98fde934f69bdaaf653ef1176b0e0aa5959de87b34203a8d5f3","versionCode":"2025052303","versionName":"3.3.7","installSource":"com.deliver.appstore.lite"},"targetModuleUrl":"","requestBundleName":"__WAIT_FOR_HARMONY_BUNDLENAME__macao.taxi.passager__1750122530100","installSource":"com.deliver.appstore.lite","appType":0,"maskState":0}',
    appType: 0
  } as CloneItemInfo;

  let deliverAppinfo2: CloneItemInfo = {
    bundleName: 'com.tencent.qt.sns',
    packageName: 'com.tencent.qt.sns',
    iconUri: 'file://com.ohos.sceneboard/data/storage/el1/base/haps/phone_sceneboard/files/RestoreIconData/com.tencent.qt.sns.png',
    title: '掌上穿越火线',
    callerName: 'com.ohos.dataclone',
    isUsed: false,
    appIndex: 0,
    isInContainer: false,
    intent: '{"legacyInfo":{"pkgName":"com.tencent.qt.sns","pkgLableName":"掌上穿越火线","pkgSignature":"90eec83fcadc14edefe83d33d6578ad6111957a3975b7a2a2eddfbd262a96a5d","versionCode":"2103290004","versionName":"3.29.0","installSource":"com.deliver.appstore.lite"},"targetModuleUrl":"","requestBundleName":"__WAIT_FOR_HARMONY_BUNDLENAME__com.tencent.qt.sns__1750157767972","installSource":"com.deliver.appstore.lite","appType":0,"maskState":0}',
    appType: 0
  } as CloneItemInfo;

  cloneItemInfos =
    [abnormalAppinfo, appAppinfo1, appAppinfo2, deliverAppinfo1, deliverAppinfo2];
  return cloneItemInfos;
}

function initAppItemInfos(): AppItemInfo[] {
  let appItemInfos: AppItemInfo[] = [];
  let appItemInfo1: AppItemInfo = new AppItemInfo();
  appItemInfo1.typeId = CommonConstants.TYPE_APP;
  appItemInfo1.bundleName = 'macao.taxi.passager';
  appItemInfo1.abilityName = 'MainAbility';
  appItemInfo1.moduleName = 'phone';
  appItemInfo1.area = [1, 1];

  let appItemInfo2: AppItemInfo = new AppItemInfo();
  appItemInfo2.typeId = CommonConstants.TYPE_APP;
  appItemInfo2.bundleName = 'com.eks.hkflight';
  appItemInfo2.abilityName = 'MainAbility';
  appItemInfo2.moduleName = 'phone';
  appItemInfo2.area = [1, 1];

  appItemInfos = [appItemInfo1, appItemInfo2];
  return appItemInfos;
}

function initBackupFavoriteInfos(): BackupFavoriteInfo[] {
  let backupFavoriteInfos: BackupFavoriteInfo[] = [];
  let backupInfo1: BackupFavoriteInfo = {
    id: 1,
    title: '支付宝',
    intent: '#Intent;action=harmony.intent.action.MAIN;category=harmony.intent.category.LAUNCHER;launchFlags=0x10200000;component=com.eg.harmony.AlipayGphone/.AlipayLogin;end',
    container: -100,
    screen: 1,
    cellX: 3,
    cellY: 3,
    spanX: 1,
    spanY: 1,
    itemType: 0,
    profileId: 0,
  };

  let backupInfo2: BackupFavoriteInfo = {
    id: 2,
    title: '电召PLUS',
    intent: '#Intent;action=harmony.intent.action.MAIN;category=harmony.intent.category.LAUNCHER;launchFlags=0x10200000;component=macao.taxi.passager/io.dcloud.PandoraEntry;end',
    container: -100,
    screen: 1,
    cellX: 3,
    cellY: 3,
    spanX: 1,
    spanY: 1,
    itemType: 0,
    profileId: 0,
  };

  let backupInfo3: BackupFavoriteInfo = {
    id: 3,
    title: '香港航班资讯',
    intent: '#Intent;action=harmony.intent.action.MAIN;category=harmony.intent.category.LAUNCHER;launchFlags=0x10200000;component=com.eks.hkflight/io.dcloud.PandoraEntry;end',
    container: -100,
    screen: 1,
    cellX: 3,
    cellY: 3,
    spanX: 1,
    spanY: 1,
    itemType: 0,
    profileId: 0,
  };

  let backupInfo4: BackupFavoriteInfo = {
    id: 3,
    title: '淘宝',
    intent: '',
    container: -100,
    screen: 1,
    cellX: 3,
    cellY: 3,
    spanX: 1,
    spanY: 1,
    itemType: 0,
    profileId: 0,
  };
  backupFavoriteInfos = [backupInfo1, backupInfo2, backupInfo3, backupInfo4];
  return backupFavoriteInfos;
}

export default function DataConvertTest() {
  let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();
  let cloneItemInfos: CloneItemInfo[] = initCloneItemInfos();
  let appItemInfos: AppItemInfo[] = initAppItemInfos();
  let backupFavoriteInfos: BackupFavoriteInfo[] = initBackupFavoriteInfos();
  describe('DataConvertTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('test_convertData01', Level.LEVEL0, async (done: Function) => {
      try {
        let backupTransformItemList: BaseTransformItem [] = [];
        backupTransformItemList.push(TransformItemFactory.getInstance().getTransformItem(backupFavoriteInfos[0]));
        CloneItemInfoManager['cloneItemInfoList'] = [];
        let result: GridLayoutItemInfo[] = await dataConvert.convertData(backupTransformItemList,
          BackupSceneBundleVersionName.HWLAUNCHER_TO_ohos);
        expect(result.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it('test_convertData026', Level.LEVEL0, async (done: Function) => {
      try {
        let backupTransformItemList: BaseTransformItem [] = [];
        backupTransformItemList.push(TransformItemFactory.getInstance().getTransformItem(backupFavoriteInfos[0]));
        CloneItemInfoManager['cloneItemInfoList'] = [cloneItemInfos[0]];
        let result: GridLayoutItemInfo[] = await dataConvert.convertData(backupTransformItemList,
          BackupSceneBundleVersionName.HWLAUNCHER_TO_ohos);
        expect(result.length).assertLargerOrEqual(0);
        CloneItemInfoManager['cloneItemInfoList'] = [];
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it('test_convertData03', Level.LEVEL0, async (done: Function) => {
      try {
        let backupTransformItemList: BaseTransformItem [] = [];
        backupTransformItemList.push(TransformItemFactory.getInstance().getTransformItem(backupFavoriteInfos[3]));
        let result: GridLayoutItemInfo[] = await dataConvert.convertData(backupTransformItemList,
          BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
        expect(result.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })


    it('test_convertData04', Level.LEVEL0, async (done: Function) => {
      let backupInfo: BackupFavoriteInfo = {
        id: 9,
        title: '天气',
        intent: '#Intent;action=harmony.intent.action.MAIN;category=harmony.intent.category.LAUNCHER;launchFlags=0x10200000;component=com.openharmony.harmony.totemweather/.WeatherHome;end',
        container: -100,
        screen: 0,
        cellX: 2,
        cellY: 4,
        spanX: 1,
        spanY: 1,
        itemType: 9,
      };
      let backupTransformItemList: BaseTransformItem [] = [];
      backupTransformItemList.push(TransformItemFactory.getInstance().getTransformItem(backupInfo));
      let result: GridLayoutItemInfo[] = await dataConvert.convertData(backupTransformItemList,
        BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
      expect(result.length).assertEqual(0);
      done();
    })

    it('test_convertData05', Level.LEVEL0, async (done: Function) => {
      let backupInfo: BackupFavoriteInfo = {
        id: 9,
        title: '天气',
        intent: '#Intent',
        container: -100,
        screen: 0,
        cellX: 2,
        cellY: 4,
        spanX: 1,
        spanY: 1,
        itemType: 9,
      };
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      let baseTransformItem: BaseTransformItem  = new BaseTransformItem(backupInfo);
      const mocker: MockKit = new MockKit();
      const gridLayoutItemInfo: Function = mocker.mockFunc(baseTransformItem, baseTransformItem.transformBackupInfoToGridInfoOnClone);
      when(gridLayoutItemInfo)(ArgumentMatchers.any).afterReturn([info]);
      let backupTransformItemList: BaseTransformItem [] = [];
      backupTransformItemList.push(TransformItemFactory.getInstance().getTransformItem(backupInfo));
      let result: GridLayoutItemInfo[] = await dataConvert.convertData(backupTransformItemList,
        BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
      expect(result.length).assertEqual(0);
      mocker.clear(baseTransformItem);
      mocker.clearAll();
      done();
    })

    it('test_convertData06', Level.LEVEL0, async (done: Function) => {
      let backupInfo: BackupFavoriteInfo = {
        id: 9,
        title: '天气',
        intent: '#Intent',
        container: -100,
        screen: 0,
        cellX: 2,
        cellY: 4,
        spanX: 1,
        spanY: 1,
        itemType: 9,
      };
      let backupTransformItemList: BaseTransformItem [] = [];
      backupTransformItemList.push(TransformItemFactory.getInstance().getTransformItem(backupInfo));
      let result: GridLayoutItemInfo[] = await dataConvert.convertData(backupTransformItemList,
        BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
      expect(result.length).assertEqual(0);
      done();
    })

    it('test_isExitInShortcutList_01', Level.LEVEL0, () => {
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      const mocker: MockKit = new MockKit();
      try{
        const isSupportInohos: Function = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.isSameShortcutApp);
        when(isSupportInohos)().afterReturn(true);
        let result: boolean = dataConvert['isExitInShortcutList']([info], info);
        expect(result).assertFalse();
      }catch(e){}
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clearAll();
    })

    it('test_isExitInShortcutList_02_7', 0, () => {
      const mocker: MockKit = new MockKit();
      try {
        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.infoId = 'infoId';
        info.bundleName = 'bundleName_dt_test';
        info.typeId = 3;
        info.page = 1;
        info.row = 0;
        info.column = 0;
        info.area = [1, 1];
        info.cardId = '1000';

        const mockFunction: Function =
          mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.isSameShortcutApp);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
        let result: boolean = dataConvert['isExitInShortcutList']([info], info);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clearAll();
    })

    it('DataConvert_dealWithInstalledCardAndStack_01', Level.LEVEL0, async (done: Function) => {
      let info_01: GridLayoutItemInfo = new GridLayoutItemInfo();
      info_01.typeId = CommonConstants.TYPE_CARD;
      let info_02: GridLayoutItemInfo = new GridLayoutItemInfo();
      info_02.typeId = CommonConstants.TYPE_FORM_COMBINE;
      const mocker: MockKit = new MockKit();
      try{
        const isSupportInohos: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(isSupportInohos)().afterReturn(false);
        let result: GridLayoutItemInfo[] = await dataConvert['dealWithInstalledCardAndStack']([info_01, info_02]);
        expect(result.length).assertEqual(0);
      }catch(e){}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('DataConvert_dealWithInstalledCardAndStack_02', Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      try {
        let info_01: GridLayoutItemInfo = new GridLayoutItemInfo();
        info_01.typeId = CommonConstants.TYPE_CARD;
        const isSupportInohos: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(isSupportInohos)().afterReturn(false);
        let result: GridLayoutItemInfo[] = await dataConvert['dealWithInstalledCardAndStack']([info_01]);
        expect(result.length).assertInstanceOf('Number');
      } catch (e) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('DataConvert_dealWithInstalledCardAndStack_03', Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      try{
        let info_01: GridLayoutItemInfo = new GridLayoutItemInfo();
        info_01.typeId = CommonConstants.TYPE_CARD;
        const isSupportInohos: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(isSupportInohos)().afterReturn(true);
        let result: GridLayoutItemInfo[] = await dataConvert['dealWithInstalledCardAndStack']([info_01]);
        expect(result.length).assertInstanceOf('Number');
      } catch (e) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('DataConvert_filterAbnormalCard', Level.LEVEL0, () => {
      let info_01: GridLayoutItemInfo = new GridLayoutItemInfo();
      info_01.cardId = '0';
      let info_02: GridLayoutItemInfo = new GridLayoutItemInfo();
      info_02.cardId = '1';
      const mocker: MockKit = new MockKit();
      try{
        const isSupportInohos: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(isSupportInohos)().afterReturn(true);
        let result: GridLayoutItemInfo[] = dataConvert['filterAbnormalCard']([info_01, info_02]);
        expect(result.length).assertLargerOrEqual(0);
      }catch(e){}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('DataConvert_dealWithFormStack_01', Level.LEVEL0, () => {
      let info_01: GridLayoutItemInfo = new GridLayoutItemInfo();
      info_01.cardId = '0';
      let info_02: GridLayoutItemInfo = new GridLayoutItemInfo();
      info_02.cardId = '1';
      let list: GridLayoutItemInfo[] = [info_01, info_02];
      const mocker: MockKit = new MockKit();
      const isSupportInohos: Function = mocker.mockFunc(dataConvert, dataConvert.getCardFromStack);
      when(isSupportInohos)().afterReturn([]);
      try {
        dataConvert['dealWithFormStack']([], []);
        expect(list.length).assertLargerOrEqual(0);
      } catch (e) {}
      mocker.clear(dataConvert);
      mocker.clearAll();
    })

    it('DataConvert_dealWithFormStack_02', Level.LEVEL0, () => {
      let info_01: GridLayoutItemInfo = new GridLayoutItemInfo();
      info_01.cardId = '0';
      let info_02: GridLayoutItemInfo = new GridLayoutItemInfo();
      info_02.cardId = '1';
      let list: GridLayoutItemInfo[] = [info_01, info_02];
      const mocker: MockKit = new MockKit();
      const isSupportInohos: Function = mocker.mockFunc(dataConvert, dataConvert.getCardFromStack);
      when(isSupportInohos)().afterReturn(list);
      try {
        dataConvert['dealWithFormStack']([], []);
        expect(dataConvert.getCurUserId()).assertEqual(100);
      } catch (e) {}
      mocker.clear(dataConvert);
      mocker.clearAll();
    })

    it('DataConvert_convertToCardItemInfo', Level.LEVEL0, () => {
      let info_01: GridLayoutItemInfo = new GridLayoutItemInfo();
      info_01.cardId = '0';
      info_01.container = CommonConstants.CONTAINER_DESKTOP;
      let info_02: CloneItemInfo = {
        bundleName: 'com.openharmony',
        packageName: 'com.openharmony',
        iconUri: ''
      };
      let result: CardItemInfo = dataConvert['convertToCardItemInfo'](info_01, info_02);
      expect(result).not().assertUndefined();
    })

    it('DataConvert_convertToDefaultCard', Level.LEVEL0, () => {
      try {
        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.area = [2, 2];
        let placeholderCard: CardItemInfo = new CardItemInfo();
        placeholderCard.cardId = '007';
        let result: GridLayoutItemInfo = dataConvert['convertToDefaultCard'](info, placeholderCard);
        expect(result).not().assertUndefined();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('DataConvert_getDefaultCardType_01', Level.LEVEL0, () => {
      try {
        let result: number = dataConvert['getDefaultCardType'](null);
        expect(result).assertEqual(0);
        result = dataConvert['getDefaultCardType']([2, 1]);
        expect(result).assertEqual(0);
        result = dataConvert['getDefaultCardType']([2, 2]);
        expect(result).assertEqual(2);
        result = dataConvert['getDefaultCardType']([4, 4]);
        expect(result).assertEqual(4);
        result = dataConvert['getDefaultCardType']([8, 8]);
        expect(result).assertEqual(0);
      } catch (e) {
      }
    })

    it('DataConvert_getFindItemByRestoreData', Level.LEVEL0, () => {
      let bundleName: string = 'com.openharmony';
      let info: CloneItemInfo = {
        bundleName: 'com.openharmony',
        packageName: 'com.openharmony',
        iconUri: ''
      };
      dataConvert['restoreInfo'] = [info];
      let result: CloneItemInfo = dataConvert['getFindItemByRestoreData'](bundleName, 0);
      expect(result).assertEqual(info);
    })

    it('test_filterAppAndCardNotInstallation016', Level.LEVEL0, async (done: Function) => {
      try {
        let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridLayout.typeId = 0;
        gridLayout.infoId = 'gridLayoutInfoId';
        gridLayout.appName = 'gridLayoutAppName';
        gridLayout.bundleName = 'gridLayoutBundleName';
        gridLayout.keyName = 'gridLayoutKeyName';
        gridLayout.folderName = 'gridLayoutFolderName'
        gridLayout.abilityName = 'gridLayoutAbilityName';
        gridLayout.moduleName = 'gridLayoutModuleName';
        gridLayout.appIconId = 1;
        gridLayout.appLabelId = 2;
        gridLayout.badgeNumber = 3;
        gridLayout.row = 4;
        gridLayout.column = 5;
        gridLayout.area = [6, 7];
        gridLayout.areaType = 8;
        let gridLayoutItemInfos: GridLayoutItemInfo[] = [gridLayout];

        let restoreInfoMap: Map<string, Array<string>> = new Map();
        restoreInfoMap.set('gridLayoutBundleName', ['gridLayoutBundleName']);
        let appList: AppItemInfo[] = [gridLayout as object as AppItemInfo];

        let result: GridLayoutItemInfo[] = await dataConvert.filterAppAndCardNotInstallation(gridLayoutItemInfos,
          restoreInfoMap, appList);
        expect(result.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it('test_filterAppAndCardNotInstallation02', Level.LEVEL0, async (done: Function) => {
      let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayout.typeId = 1;
      gridLayout.infoId = 'gridLayoutInfoId';
      gridLayout.appName = 'gridLayoutAppName';
      gridLayout.bundleName = 'gridLayoutBundleName';
      gridLayout.keyName = 'gridLayoutKeyName';
      gridLayout.folderName = 'gridLayoutFolderName'
      gridLayout.abilityName = 'gridLayoutAbilityName';
      gridLayout.moduleName = 'gridLayoutModuleName';
      gridLayout.appIconId = 1;
      gridLayout.appLabelId = 2;
      gridLayout.badgeNumber = 3;
      gridLayout.row = 4;
      gridLayout.column = 5;
      gridLayout.area = [2, 2];
      gridLayout.areaType = 1;
      let gridLayoutItemInfos: GridLayoutItemInfo[] = [gridLayout];
      try {
        let restoreInfoMap: Map<string, Array<string>> = new Map();
        restoreInfoMap.set('bundleNameNotExists', ['bundleNameNotExists']);
        let appList: AppItemInfo[] = [gridLayout as object as AppItemInfo];
        // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
        let result: GridLayoutItemInfo[] = await dataConvert.filterAppAndCardNotInstallation(gridLayoutItemInfos,
          restoreInfoMap, appList);
        // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
        expect(result.length).assertLargerOrEqual(0);
      } catch (e) {
      }
      done();
    })

    it('test_filterAppAndCardNotInstallation036', 0, async (done: Function) => {
      try {
        let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridLayout.typeId = 0;
        gridLayout.infoId = 'gridLayoutInfoId';
        gridLayout.appName = 'gridLayoutAppName';
        gridLayout.bundleName = 'gridLayoutBundleName';
        gridLayout.keyName = 'gridLayoutKeyName';
        gridLayout.folderName = 'gridLayoutFolderName'
        gridLayout.abilityName = 'gridLayoutAbilityName';
        gridLayout.moduleName = 'gridLayoutModuleName';
        gridLayout.appIconId = 1;
        gridLayout.appLabelId = 2;
        gridLayout.badgeNumber = 3;
        gridLayout.row = 4;
        gridLayout.column = 5;
        gridLayout.area = [2, 2];
        gridLayout.areaType = 0;
        let gridLayoutItemInfos: GridLayoutItemInfo[] = [gridLayout];

        let restoreInfoMap: Map<string, Array<string>> = new Map();
        restoreInfoMap.set('bundleNameNotExists', ['bundleNameNotExists']);
        let appList: AppItemInfo[] = [gridLayout as object as AppItemInfo];

        let result: GridLayoutItemInfo[] = await dataConvert.filterAppAndCardNotInstallation(gridLayoutItemInfos,
          restoreInfoMap, appList);
        expect(result.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it('test_filterAppAndCardNotInstallation046', 0, async (done: Function) => {
      try {
        let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridLayout.typeId = 0;
        gridLayout.infoId = 'gridLayoutInfoId';
        gridLayout.appName = 'gridLayoutAppName';
        gridLayout.bundleName = 'gridLayoutBundleName';
        gridLayout.keyName = 'gridLayoutKeyName';
        gridLayout.folderName = 'gridLayoutFolderName'
        gridLayout.abilityName = 'gridLayoutAbilityName';
        gridLayout.moduleName = 'gridLayoutModuleName';
        gridLayout.appIconId = 1;
        gridLayout.appLabelId = 2;
        gridLayout.badgeNumber = 3;
        gridLayout.row = 4;
        gridLayout.column = 5;
        gridLayout.area = [2, 2];
        gridLayout.areaType = 0;
        let gridLayoutItemInfos: GridLayoutItemInfo[] = [gridLayout];

        let restoreInfoMap: Map<string, Array<string>> = new Map();
        restoreInfoMap.set('bundleNameNotExists', ['bundleNameNotExists']);
        let appList: AppItemInfo[] = [gridLayout as object as AppItemInfo];

        let result: GridLayoutItemInfo[] = await dataConvert.filterAppAndCardNotInstallation(gridLayoutItemInfos,
          restoreInfoMap, appList);
        expect(result.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it('test_filterAppAndCardNotInstallation05', Level.LEVEL0, async (done: Function) => {
      try {
        let layoutItems: GridLayoutItemInfo[] = [];
        let info1: GridLayoutItemInfo = new GridLayoutItemInfo();
        info1.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        layoutItems.push(info1);
        let info2: GridLayoutItemInfo = new GridLayoutItemInfo();
        info2.typeId = CommonConstants.TYPE_FOLDER;
        info2.folderId = 'info2';
        layoutItems.push(info2);
        let result: GridLayoutItemInfo[] =
          await dataConvert.filterAppAndCardNotInstallation(layoutItems, new Map(), []);
        expect(result.length).assertLargerOrEqual(0);
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_filterAppAndCardNotInstallation06', Level.LEVEL0, async (done: Function) => {
      try {
        let result: GridLayoutItemInfo[] = await dataConvert.filterAppAndCardNotInstallation([], new Map(), []);
        expect(result.length).assertLargerOrEqual(0);
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_deleteSceneBoardFormRelationInfoByBundleName_04', 0, () => {
      let bundleName: string = 'bundleName';
      let layoutInfo: GridLayoutItemInfo[] = [];
      let layout1: GridLayoutItemInfo = new GridLayoutItemInfo();
      layout1.typeId = CommonConstants.TYPE_CARD;
      layout1.layoutInfo = [[]];
      let layout2: GridLayoutItemInfo = new GridLayoutItemInfo();
      layout2.typeId = CommonConstants.TYPE_FORM_STACK;
      layout2.layoutInfo = [[]];

      layoutInfo.push(layout1);
      layoutInfo.push(layout2);

      let remainingStackInfos: GridLayoutItemInfo[] = [];
      let grid:GridLayoutItemInfo = new GridLayoutItemInfo();
      grid.layoutInfo = [];
      remainingStackInfos.push(grid);

      let deleteFormAndStackInfos: GridLayoutItemInfo[] = [];

      let sceneBoardFormMap: Map<string, CardItemInfo[]> = new Map();
      let relationCards: CardItemInfo[] = [];
      let cardItemInfo1: CardItemInfo = new CardItemInfo();
      cardItemInfo1.cardId = '1';
      let cardItemInfo2: CardItemInfo = new CardItemInfo();
      cardItemInfo2.cardId = '2';
      relationCards.push(cardItemInfo1, cardItemInfo2);

      sceneBoardFormMap.set('bundleName', relationCards);
      let mocker: MockKit = new MockKit();
      try{
        let mockFunc: Function = mocker.mockFunc(FormRelationManager.getInstance(), FormRelationManager.getInstance().getSceneBoardFormRelationModelMap);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(sceneBoardFormMap);
        FormRelationManager.getInstance().deleteSceneBoardFormRelationInfoByBundleName(bundleName, layoutInfo, remainingStackInfos, deleteFormAndStackInfos);

        expect(bundleName).assertEqual('bundleName');
      }catch(e){}
      mocker.clear(dataConvert);
      mocker.clearAll();
    });

    it('test_deleteSceneBoardFormRelationMapByCardId01', Level.LEVEL0, async () => {
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.bundleName = 'com.gtja.junhong.hm.next';
      cardItem.moduleName = 'default';
      cardItem.abilityName = 'EntryFormAbility';
      cardItem.cardName = 'marketwidget';
      cardItem.cardDimension = 2;
      cardItem.cardId = '12345678';
      cardItem.appName = '国泰君安君弘';
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', [cardItem]);
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const cardId: string = '';
      FormRelationManager.getInstance().deleteSceneBoardFormRelationMapByCardId(cardId);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('test_deleteSceneBoardFormRelationMapByCardId02', Level.LEVEL0, async () => {
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.bundleName = 'com.gtja.junhong.hm.next';
      cardItem.moduleName = 'default';
      cardItem.abilityName = 'EntryFormAbility';
      cardItem.cardName = 'marketwidget';
      cardItem.cardDimension = 2;
      cardItem.cardId = '12345678';
      cardItem.appName = '国泰君安君弘';
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', [cardItem]);
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const cardId: string = '12345678';
      FormRelationManager.getInstance().deleteSceneBoardFormRelationMapByCardId(cardId);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('test_deleteSceneBoardFormRelationMapByBundleName01', Level.LEVEL0, async () => {
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.bundleName = 'com.gtja.junhong.hm.next';
      cardItem.moduleName = 'default';
      cardItem.abilityName = 'EntryFormAbility';
      cardItem.cardName = 'marketwidget';
      cardItem.cardDimension = 2;
      cardItem.cardId = '12345678';
      cardItem.appName = '国泰君安君弘';
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', [cardItem]);
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = 'bundleNameNotExists';
      FormRelationManager.getInstance().deleteSceneBoardFormRelationMapByBundleName(bundleName);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('test_deleteSceneBoardFormRelationMapByBundleName02', Level.LEVEL0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = '';
      FormRelationManager.getInstance().deleteSceneBoardFormRelationMapByBundleName(bundleName);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('test_isSceneBoardCard01', Level.LEVEL0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = 'bundleNameNotExists';
      const formName: string = 'formNameNotExists';
      let result: boolean = FormRelationManager.getInstance().isSceneBoardCard(bundleName, formName);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(result).assertFalse();
    })

    it('test_isSceneBoardCard02', Level.LEVEL0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = '';
      const formName: string = '';
      let result: boolean = FormRelationManager.getInstance().isSceneBoardCard(bundleName, formName);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(result).assertFalse();
    })

    it('test_isSceneBoardCard03', Level.LEVEL0, async () => {
      const bundleName: string = CommonConstants.LAUNCHER_BUNDLE;
      const formName: string = 'SceneBoard_2_1_Card';
      let result: boolean = FormRelationManager.getInstance().isSceneBoardCard(bundleName, formName);
      expect(result).assertTrue();
    })

    it('test_getAppNameByCardId01', Level.LEVEL0, async () => {
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.bundleName = 'com.gtja.junhong.hm.next';
      cardItem.moduleName = 'default';
      cardItem.abilityName = 'EntryFormAbility';
      cardItem.cardName = 'marketwidget';
      cardItem.cardDimension = 2;
      cardItem.cardId = '12345678';
      cardItem.appName = '国泰君安君弘';
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', [cardItem]);
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const cardId: string = '';
      let result: string = FormRelationManager.getInstance().getAppNameByCardId(cardId);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(result).assertEqual('');
    })

    it('test_getAppNameByCardId02', Level.LEVEL0, async () => {
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.bundleName = 'com.gtja.junhong.hm.next';
      cardItem.moduleName = 'default';
      cardItem.abilityName = 'EntryFormAbility';
      cardItem.cardName = 'marketwidget';
      cardItem.cardDimension = 2;
      cardItem.cardId = '12345678';
      cardItem.appName = '国泰君安君弘';
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', [cardItem]);
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const cardId: string = '12345678';
      let result: string = FormRelationManager.getInstance().getAppNameByCardId(cardId);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(result).assertEqual('国泰君安君弘');
    })

    it('test_deleteSceneBoardFormRelationInfoByBundleName01', Level.LEVEL0, async () => {
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.bundleName = 'com.gtja.junhong.hm.next';
      cardItem.moduleName = 'default';
      cardItem.abilityName = 'EntryFormAbility';
      cardItem.cardName = 'marketwidget';
      cardItem.cardDimension = 2;
      cardItem.cardId = '12345678';
      cardItem.appName = '国泰君安君弘';
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', [cardItem]);

      let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayout.typeId = 1;
      gridLayout.infoId = '12345678';
      gridLayout.appName = '国泰君安君弘';
      gridLayout.bundleName = 'com.gtja.junhong.hm.next';
      gridLayout.keyName = 'com.gtja.junhong.hm.next_KeyName';
      gridLayout.abilityName = 'EntryFormAbility';
      gridLayout.moduleName = 'default';
      gridLayout.appIconId = 1;
      gridLayout.appLabelId = 2;
      gridLayout.badgeNumber = 3;
      gridLayout.row = 4;
      gridLayout.column = 5;
      gridLayout.area = [2, 2];
      gridLayout.areaType = 1;

      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = 'com.gtja.junhong.hm.next';
      FormRelationManager.getInstance().deleteSceneBoardFormRelationInfoByBundleName(bundleName, [gridLayout], [], []);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('test_deleteSceneBoardFormRelationInfoByBundleName02', Level.LEVEL0, async () => {
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', []);

      let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayout.typeId = 1;
      gridLayout.infoId = '12345678';
      gridLayout.appName = '国泰君安君弘';
      gridLayout.bundleName = 'com.gtja.junhong.hm.next';
      gridLayout.keyName = 'com.gtja.junhong.hm.next_KeyName';
      gridLayout.abilityName = 'EntryFormAbility';
      gridLayout.moduleName = 'default';
      gridLayout.appIconId = 1;
      gridLayout.appLabelId = 2;
      gridLayout.badgeNumber = 3;
      gridLayout.row = 4;
      gridLayout.column = 5;
      gridLayout.area = [2, 2];
      gridLayout.areaType = 1;

      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = 'com.gtja.junhong.hm.next';
      FormRelationManager.getInstance().deleteSceneBoardFormRelationInfoByBundleName(bundleName, [gridLayout], [], []);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('test_deleteSceneBoardFormRelationInfoByBundleName03', Level.LEVEL0, async () => {
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', []);

      let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayout.typeId = 1;
      gridLayout.infoId = '12345678';
      gridLayout.appName = '国泰君安君弘';
      gridLayout.bundleName = 'com.gtja.junhong.hm.next';
      gridLayout.keyName = 'com.gtja.junhong.hm.next_KeyName';
      gridLayout.abilityName = 'EntryFormAbility';
      gridLayout.moduleName = 'default';
      gridLayout.appIconId = 1;
      gridLayout.appLabelId = 2;
      gridLayout.badgeNumber = 3;
      gridLayout.row = 4;
      gridLayout.column = 5;
      gridLayout.area = [2, 2];
      gridLayout.areaType = 1;

      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = 'bundleNameNotExists';
      FormRelationManager.getInstance().deleteSceneBoardFormRelationInfoByBundleName(bundleName, [gridLayout], [], []);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('test_deleteSceneBoardFormRelationInfoByBundleName04', Level.LEVEL0, async () => {
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.bundleName = 'com.gtja.junhong.hm.next';
      cardItem.moduleName = 'default';
      cardItem.abilityName = 'EntryFormAbility';
      cardItem.cardName = 'marketwidget';
      cardItem.cardDimension = 2;
      cardItem.cardId = '12345678';
      cardItem.appName = '国泰君安君弘';
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', [cardItem]);


      let card1: GridLayoutItemInfo = new GridLayoutItemInfo();
      card1.typeId = 1;
      card1.infoId = '12345677';
      card1.appName = '国泰君安君弘';
      card1.bundleName = 'com.gtja.junhong.hm.next';
      card1.keyName = 'com.gtja.junhong.hm.next_KeyName';
      card1.abilityName = 'EntryFormAbility';
      card1.moduleName = 'default';
      card1.appIconId = 1;
      card1.appLabelId = 2;
      card1.badgeNumber = 3;
      card1.row = 4;
      card1.column = 5;
      card1.area = [2, 2];
      card1.areaType = 1;

      let card2: GridLayoutItemInfo = new GridLayoutItemInfo();
      card1.typeId = 1;
      card1.infoId = '12345678';
      card1.appName = '国泰君安君弘';
      card1.bundleName = 'com.gtja.junhong.hm.next';
      card1.keyName = 'com.gtja.junhong.hm.next_KeyName';
      card1.abilityName = 'EntryFormAbility';
      card1.moduleName = 'default';
      card1.appIconId = 1;
      card1.appLabelId = 2;
      card1.badgeNumber = 3;
      card1.row = 4;
      card1.column = 5;
      card1.area = [2, 2];
      card1.areaType = 1;


      let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayout.typeId = 6;
      gridLayout.infoId = '1234567891011';
      gridLayout.formStackId = '1234567891011';
      gridLayout.keyName = 'com.gtja.junhong.hm.next_stack_KeyName';
      gridLayout.row = 4;
      gridLayout.column = 5;
      gridLayout.area = [2, 2];
      gridLayout.areaType = 6;
      gridLayout.layoutInfo = [[card1], [card2]];

      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = 'com.gtja.junhong.hm.next';
      FormRelationManager.getInstance().deleteSceneBoardFormRelationInfoByBundleName(bundleName, [gridLayout], [], []);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('test_updateFormAndStackInfoByBundleName01', Level.LEVEL0, async () => {
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.bundleName = 'com.gtja.junhong.hm.next';
      cardItem.moduleName = 'default';
      cardItem.abilityName = 'EntryFormAbility';
      cardItem.cardName = 'marketwidget';
      cardItem.cardDimension = 2;
      cardItem.cardId = '12345678';
      cardItem.appName = '国泰君安君弘';
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', [cardItem]);

      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = 'bundleNameNotExists';
      let cardItems: CardItemInfo[] = FormRelationManager.getInstance().updateFormAndStackInfoByBundleName(bundleName);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(cardItems.length).assertEqual(0);
    })

    it('test_updateFormAndStackInfoByBundleName02', Level.LEVEL0, async () => {
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.bundleName = 'com.gtja.junhong.hm.next';
      cardItem.moduleName = 'default';
      cardItem.abilityName = 'EntryFormAbility';
      cardItem.cardName = 'marketwidget';
      cardItem.cardDimension = 2;
      cardItem.cardId = '12345678';
      cardItem.appName = '国泰君安君弘';
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', [cardItem]);

      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = 'com.gtja.junhong.hm.next';
      let cardItems: CardItemInfo[] = FormRelationManager.getInstance().updateFormAndStackInfoByBundleName(bundleName);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(cardItems.length).assertEqual(1);
    })

    it('test_updateFormAndStackInfoByBundleName03', Level.LEVEL0, async () => {
      FormRelationManager.getInstance().setSceneBoardFormRelation('com.gtja.junhong.hm.next', []);

      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const bundleName: string = 'com.gtja.junhong.hm.next';
      let cardItems: CardItemInfo[] = FormRelationManager.getInstance().updateFormAndStackInfoByBundleName(bundleName);
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(cardItems.length).assertEqual(0);
    })

    it('test_getSceneBoardFormRelationModelMap', 0, () => {
      let ret = FormRelationManager.getInstance().getSceneBoardFormRelationModelMap();
      expect(ret).not().assertNull();
      FormRelationManager.getInstance().clearSceneBoardFormRelationModel();
      ret = dataConvert['getSceneBoardFormRelationModelMap']();
      expect(ret).not().assertNull();
    })

    it('test_getSceneBoardFormRelationModelMap_mock1', 0, () => {
      const mocker: MockKit = new MockKit();
      try{
        const mockFunction: Function = mocker.mockFunc(FileUtils, FileUtils.isExist);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(false);

        FormRelationManager.getInstance().clearSceneBoardFormRelationModel();
        let ret = FormRelationManager.getInstance().getSceneBoardFormRelationModelMap();
        expect(ret).not().assertNull();
      }catch(e){}
      mocker.clear(FileUtils);
      mocker.clearAll();
    })

    it('test_getSceneBoardFormRelationModelMap_mock2', 0, () => {
      const mocker: MockKit = new MockKit();
      try{
        const mockFunction: Function = mocker.mockFunc(FileUtils, FileUtils.isExist);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(true);

        const mockFun1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFun1)(ArgumentMatchers.any).afterReturn(true);

        FormRelationManager.getInstance().clearSceneBoardFormRelationModel();
        let ret = FormRelationManager.getInstance().getSceneBoardFormRelationModelMap();
        expect(ret).not().assertNull();
      }catch(e){}
      mocker.clear(FileUtils);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_DataConvert_convertData', 0, async (done: Function) => {
      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '淘宝',
        intent: '#Intent;action=harmony.intent.action.MAIN;category=harmony.intent.category.LAUNCHER;launchFlags=0x10200000;component=com.taobao.taobao/com.taobao.tao.welcome.Welcome;end',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 1,
      };
      let backupInfo1: BackupFavoriteInfo = {
        id: 1,
        title: '淘宝',
        intent: '#Intent;action=harmony.intent.action.MAIN;category=harmony.intent.category.LAUNCHER;launchFlags=0x10200000;component=com.taobao.taobao/com.taobao.tao.welcome.Welcome;end',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 1,
      };
      const mocker: MockKit = new MockKit();
      let baseTransformItem: BaseTransformItem = new BaseTransformItem(backupInfo);
      try{
        let baseTransformItem1: BaseTransformItem = new BaseTransformItem(backupInfo1);
        const mockFunction: Function = mocker.mockFunc(baseTransformItem, baseTransformItem.transformBackupInfoToGridInfo);
        when(mockFunction)(ArgumentMatchers.any).afterReturn([new GridLayoutItemInfo()]);
        let result: GridLayoutItemInfo[] = await dataConvert.convertData([baseTransformItem, baseTransformItem1], '996');
        expect(result.length).assertInstanceOf('Number');
      } catch (e) {}
      mocker.clear(baseTransformItem);
      mocker.clearAll();
      done();
    })

    it('test_DataConvert_dealWithSingleUniqueShortcut', 0, () => {
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.infoId = 'infoId';
      info.bundleName = 'bundleName_dt_test';
      info.typeId = 3;
      info.page = 1;
      info.row = 0;
      info.column = 0;
      info.area = [1, 1];
      info.cardId = '1000';
      const mocker: MockKit = new MockKit();
      try{
        const mockFunction: Function = mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().queryGridLayoutByType);
        const mockFunction1: Function = mocker.mockFunc(dataConvert, dataConvert['isExitInShortcutList']);
        when(mockFunction)(ArgumentMatchers.any).afterReturn([info]);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
        dataConvert['dealWithSingleUniqueShortcut']([info], [info]);
        expect(info.infoId).assertEqual('infoId');
      }catch(e){}
      mocker.clear(RdbStoreManager.getInstance());
      mocker.clear(dataConvert);
      mocker.clearAll();
    })



    it('test_DataConvert_dealWithFormStack', 0, () => {
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.infoId = 'infoId';
      info.bundleName = 'bundleName_dt_test';
      info.typeId = 3;
      info.page = 1;
      info.row = 0;
      info.column = 0;
      info.area = [1, 1];
      info.cardId = '1000';
      info.container = 1;
      const mocker: MockKit = new MockKit();
      try {
        const mockFunction: Function = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil['getCardFromStack']);
        when(mockFunction)(ArgumentMatchers.any).afterReturn([info]);
        dataConvert['dealWithFormStack']([info], [info]);
        expect(info.container).assertEqual(1);
      } catch (e) {}
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clearAll();
    })

    it('test_DataConvert_dealWithInstalledCard', 0, () => {
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.infoId = 'infoId';
      info.bundleName = 'bundleName_dt_test';
      info.typeId = 3;
      info.page = 1;
      info.row = 0;
      info.column = 0;
      info.area = [1, 1];
      info.cardId = '1000';
      info.container = CommonConstants.CONTAINER_DESKTOP;
      const mocker: MockKit = new MockKit();
      try{
        const mockFunction: Function = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil['deleteDuplicateCards']);
        when(mockFunction)(ArgumentMatchers.any).afterReturn([]);
        let result: GridLayoutItemInfo[] = dataConvert['dealWithInstalledCard']([info], [info], [info]);
        expect(result.length).assertEqual(0);
        when(mockFunction)(ArgumentMatchers.any).afterReturn([info]);
        let result1: GridLayoutItemInfo[] = dataConvert['dealWithInstalledCard']([info], [info], [info]);
        expect(result1.length).assertEqual(1);
      }catch(e){}
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clearAll();
    })

    it('test_DataConvert_getDefaultCardType_02', 0, () => {
      const mocker: MockKit = new MockKit();
      try{
        const mockFunction: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
        let result: number = dataConvert['getDefaultCardType']([]);
        expect(result).assertEqual(0);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
        let result1: number = dataConvert['getDefaultCardType']([2, 1]);
        expect(result1).assertEqual(1);
        let result2: number = dataConvert['getDefaultCardType']([2, 2]);
        expect(result2).assertLargerOrEqual(0);
        let result3: number = dataConvert['getDefaultCardType']([4, 2]);
        expect(result3).assertEqual(3);
        let result4: number = dataConvert['getDefaultCardType']([4, 4]);
        expect(result4).assertEqual(4);
        let result5: number = dataConvert['getDefaultCardType']([1, 1]);
        expect(result5).assertEqual(0);
      } catch (e) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_DataConvert_getDefaultCardType_03', 0, async (done: Function) => {
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.infoId = 'infoId';
      info.bundleName = '007';
      info.moduleName = '007';
      info.abilityName = '007';
      info.typeId = CommonConstants.TYPE_APP;
      info.page = 1;
      info.row = 0;
      info.column = 0;
      info.area = [1, 1];
      info.cardId = '1000';
      info.container = CommonConstants.CONTAINER_DESKTOP;
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.bundleName = '007';
      cardItem.moduleName = '007';
      cardItem.abilityName = '007';
      cardItem.cardName = '007';
      cardItem.cardDimension = 7;
      cardItem.cardId = '007';
      cardItem.appName = '007';
      const mocker: MockKit = new MockKit();
      try{
        const mockFunction: Function = mocker.mockFunc(FormModel.getInstance(), FormModel.getInstance().getFormsInfoByBundleName);
        when(mockFunction)(ArgumentMatchers.any).afterReturn([cardItem]);
        let result: boolean = await dataConvert['isCardInstalled'](info);
        expect(result).assertTrue();
      }catch(e){}
      mocker.clear(FormModel.getInstance());
      mocker.clearAll();
      done();
    })

    it('test_getWaitForHarmonyBundleName_01', 0, () => {
      try {
        const HARMONY_QQ_BUNDLENAME = 'com.tencent.mqq';
        let result: string = dataConvert['getWaitForHarmonyBundleName'](HARMONY_QQ_BUNDLENAME);
        expect(result.length > 0).assertTrue()
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getWaitForHarmonyBundleName_02', 0, () => {
      try {
        const WAIT_FOR_SYSTEM_APP_KEYNAME: string = 'com.tencent.mobileqq';
        let result: string = dataConvert['getWaitForHarmonyBundleName'](WAIT_FOR_SYSTEM_APP_KEYNAME);
        expect(result.length > 0).assertTrue()
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_DataConvert_clearCatchOfCardFrame', 0, () => {
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.infoId = 'infoId';
      info.bundleName = '007';
      info.moduleName = '007';
      info.abilityName = '007';
      info.typeId = CommonConstants.TYPE_APP;
      info.page = 1;
      info.row = 0;
      info.column = 0;
      info.id = 0;
      info.area = [1, 1];
      info.cardId = '1000';
      info.container = CommonConstants.CONTAINER_DESKTOP;
      let info1: GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.infoId = 'infoId';
      info1.bundleName = '007';
      info1.moduleName = '007';
      info1.abilityName = '007';
      info1.typeId = CommonConstants.TYPE_APP;
      info1.page = 1;
      info1.row = 0;
      info1.column = 0;
      info1.id = 0;
      info1.area = [1, 1];
      info1.cardId = '50';
      info1.container = CommonConstants.CONTAINER_DESKTOP;
      const mocker: MockKit = new MockKit();
      try{
        const mockFunction: Function = mocker.mockFunc(dataConvert['reservedCardIdList'], dataConvert['reservedCardIdList'].findIndex);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(CommonConstants.INVALID_VALUE);
        dataConvert['clearCatchOfCardFrame']([info], [info1]);
        expect(dataConvert).not().assertNull();
        info1.cardId = '1000';
        dataConvert['clearCatchOfCardFrame']([info], [info1]);
        expect(dataConvert).not().assertNull();
      }catch(e){}
      mocker.clear(dataConvert['reservedCardIdList']);
      mocker.clearAll();
    })

    it('test_DataConvert_getLocationOfUniqueItem', 0, () => {
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.infoId = 'infoId';
      info.bundleName = '007';
      info.moduleName = '007';
      info.abilityName = '007';
      info.typeId = CommonConstants.TYPE_APP;
      info.page = 1;
      info.row = 0;
      info.column = 0;
      info.id = CommonConstants.DOCK_SPACE;
      info.area = [1, 1];
      info.cardId = '1000';
      info.container = CommonConstants.CONTAINER_SMARTDOCK;
      const mocker: MockKit = new MockKit();
      try{
        const mockFunction: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        const mockFunction1: Function = mocker.mockFunc(dataConvert['appListBeforeConvert'], dataConvert['appListBeforeConvert'].findIndex);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(-1);
        let result: string = dataConvert['getLocationOfUniqueItem'](info);
        expect(result).assertEqual('');
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(0);
        dataConvert['appListBeforeConvert'] = [info];
        let result1: string = dataConvert['getLocationOfUniqueItem'](info);
        expect(result1).assertInstanceOf('String');
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(-1);
        info.container = CommonConstants.DOCK_SPACE;
        dataConvert['appListBeforeConvert'] = [info];
        dataConvert['folderListBeforeConvert'] = [info];
        let result2: string = dataConvert['getLocationOfUniqueItem'](info);
        expect(result2).assertInstanceOf('String');
        info.id = 0;
        let result3: string = dataConvert['getLocationOfUniqueItem'](info);
        expect(result3).assertInstanceOf('String');
      }catch(e){}
      mocker.clear(CheckEmptyUtils);
      mocker.clear(dataConvert['appListBeforeConvert']);
      mocker.clearAll();
    })

    it('test_preloadBeforeConvert1', 0, () => {
      dataConvert['preloadBeforeConvert'](BackupSceneBundleVersionName.HWLAUNCHER_TO_ohos);
      let path: string = dataConvert.getOldIconPath('');
      expect(CheckEmptyUtils.checkStrIsEmpty(path)).assertFalse();
    })

    it('test_preloadBeforeConvert2', 0, () => {
      dataConvert['preloadBeforeConvert'](BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
      let path: string = dataConvert.getOldIconPath('com.wuba.life');
      expect(CheckEmptyUtils.checkStrIsEmpty(path)).assertFalse();
    })

    it('test_saveNotHaveIconPackageNames', 0, () => {
      let packageName: string = 'com.wuba.life';
      dataConvert.saveNotHaveIconPackageNames(packageName);
      dataConvert.setCurUserId(0);
      dataConvert.incCardCount();
      dataConvert.incAppCount();
      dataConvert.incWidgetCount();
      dataConvert.saveMisShortCutArr(packageName);
      dataConvert.saveMisWidgetArr(packageName);
      dataConvert.saveMisCardArr(packageName);
      dataConvert.saveLostAppNameArr(packageName);
      dataConvert.saveMisAppNameArr(packageName);
      dataConvert.setAppItemInfoList([new AppItemInfo()]);
      expect(dataConvert.getCurUserId()).assertEqual(0);
    })

    it('test_updateHarmonyAppName1', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_CARD;
      item.appStatus = AppStatus.PENDING;
      dataConvert.updateHarmonyAppName(item);
      expect(item.appStatus >= 0).assertTrue();
    })

    it('test_updateHarmonyAppName2', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_APP;
      item.appStatus = AppStatus.PENDING;
      let result: GridLayoutItemInfo[] = [];
      result.push(item);
      dataConvert['updateHarmonyAppNames'](result);
      expect(item.appStatus >= 0).assertTrue();
    })

    it('test_getIdFromContainer', 0, () => {
      dataConvert['getIdFromContainer'](null);
      dataConvert['getIdFromContainer'](CommonConstants.CONTAINER_SMARTDOCK);
      let num: number = dataConvert['getIdFromContainer'](CommonConstants.CONTAINER_DESKTOP);
      expect(num > 0).assertTrue();
    })

    it('test_isInContainerFolder_01', 0, () => {
      try {
        let bundleName: string = 'com.openharmony.dt.test';
        dataConvert.isInContainerFolder(bundleName);
        dataConvert.setOldIconPath('');
        dataConvert.getOldIconPath('');
        let path: string = dataConvert.getOldIconPath(bundleName);
        expect(CheckEmptyUtils.checkStrIsEmpty(path)).assertFalse();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getOldIconUri_01', 0, () => {
      try {
        let bundleName: string = 'com.openharmony';
        dataConvert.getOldIconUri('');
        dataConvert.setOldIconPath('');
        let uri: string = dataConvert.getOldIconUri(bundleName);
        expect(uri.length >= 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_filterTwinAppOfUnownedApps_01', 0, () => {
      try {
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.typeId = CommonConstants.TYPE_APP;
        item.appIndex = CommonConstants.MAIN_APP_INDEX + 1;
        item.container = CommonConstants.CONTAINER_DESKTOP;
        let backupInfoArr: GridLayoutItemInfo[] = [];
        backupInfoArr.push(item);
        dataConvert.filterTwinAppOfUnownedApps(backupInfoArr);
        expect(backupInfoArr.length >= 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getLetterFromPage_01', 0, () => {
      try {
        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.container = CommonConstants.CONTAINER_DESKTOP;
        info.page = 1;
        dataConvert['getLetterFromPage'](info);
        expect(info.page > 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getLetterFromPage_02', 0, () => {
      try {
        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.container = undefined;
        info.page = 1;
        dataConvert['getLetterFromPage'](info);
        expect(info.page > 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getWaitForHarmonyValue_01', 0, () => {
      try {
        const HARMONY_QQ_BUNDLENAME: string = 'com.tencent.mqq.abc123';
        let result: string[] = dataConvert.getWaitForHarmonyValue(HARMONY_QQ_BUNDLENAME, undefined, new Map());
        expect(result.length >= 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })


    it('test_getWaitForHarmonyValue_02', 0, () => {
      try {
        const HARMONY_QQ_BUNDLENAME: string = 'com.tencent.mqq';
        const WAIT_FOR_HARMONY_QQ_KEYNAME: string = 'com.tencent.mobileqq';
        let map: Map<string, Array<string>> = new Map();
        map.set(WAIT_FOR_HARMONY_QQ_KEYNAME, ['996', '007']);
        let result: string[] = dataConvert.getWaitForHarmonyValue(HARMONY_QQ_BUNDLENAME, undefined, map);
        expect(result.length >= 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getWaitForHarmonyValue_03', 0, () => {
      try {
        const HARMONY_QQ_BUNDLENAME: string = 'com.tencent.mqq';
        const WAIT_FOR_HARMONY_QQ_KEYNAME: string = 'com.tencent.mobileqq';
        let map: Map<string, Array<string>> = new Map();
        map.set(WAIT_FOR_HARMONY_QQ_KEYNAME + '1', ['996', '007']);
        let result: string[] = dataConvert.getWaitForHarmonyValue(HARMONY_QQ_BUNDLENAME, 1, map);
        expect(result.length >= 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getCardFromStack_01', 0, () => {
      try {
        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        let result: GridLayoutItemInfo[] = dataConvert.getCardFromStack(info, []);
        expect(result.length >= 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getCardFromStack_02', Level.LEVEL0, () => {
      try {
        let id: number = 1;
        let formStack: GridLayoutItemInfo = new GridLayoutItemInfo();
        formStack.id = id;
        formStack.container = 1;
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.id = 2;
        item.container = id;
        item.cardId = '1';
        item.cardName = '1';
        item.area = [1, 1];
        let list: GridLayoutItemInfo[] = [item];
        let result: GridLayoutItemInfo[] = dataConvert.getCardFromStack(formStack, list);
        expect(result.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_deleteDuplicateCards_01', 0, () => {
      try {
        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.cardName = '1';
        info.bundleName = '1';
        let info2: GridLayoutItemInfo = new GridLayoutItemInfo();
        info2.cardName = '';
        info2.bundleName = '2';
        let result: GridLayoutItemInfo[] = dataConvert.deleteDuplicateCards([info], [info, info2]);
        expect(result.length).assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getBackupCards_01', 0, async (done: Function) => {
      try {
        let info1: GridLayoutItemInfo = new GridLayoutItemInfo();
        info1.id = 1;
        info1.typeId = CommonConstants.TYPE_CARD;
        let info2: GridLayoutItemInfo = new GridLayoutItemInfo();
        info1.id = 2;
        info2.typeId = CommonConstants.TYPE_FORM_COMBINE;
        info2.layoutInfo = [[new GridLayoutItemInfo()]];
        let list: GridLayoutItemInfo[] = [info1, info2];
        let ret = await dataConvert['getBackupCards'](list);
        expect(ret.length >= 0).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initIconNameCache_01', 0, async (done: Function) => {
      try {
        await dataConvert['initIconNameCache']();
        dataConvert.getAppItemInfoList();
        dataConvert['reportHiSysEventAndClearCache']();
        expect(dataConvert.incCurrentTime()).assertInstanceOf('Number');
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_queryAndSaveCurUserId_01', 0, async (done: Function) => {
      try {
        dataConvert.setCurUserId(0);
        await dataConvert['queryAndSaveCurUserId']();
        expect(dataConvert.getCurUserId()).assertInstanceOf('Number');
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_collectingSpecialElements_01', 0, () => {
      try {
        let backupInfoArr: GridLayoutItemInfo[] = [];
        let info1: GridLayoutItemInfo = new GridLayoutItemInfo();
        info1.typeId = CommonConstants.TYPE_CARD;
        backupInfoArr.push(info1);
        let info2: GridLayoutItemInfo = new GridLayoutItemInfo();
        info2.typeId = CommonConstants.TYPE_APP;
        info2.appStatus = AppStatus.WAIT_FOR_HARMONY;
        info2.intent = '';
        info2.bundleName = 'com.openharmony';
        backupInfoArr.push(info2);
        let speciaItemMap = dataConvert['collectingSpecialElements'](backupInfoArr, '');
        expect(speciaItemMap.size >= 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })


    it('test_dealWithSpecialElement_01', 0, () => {
      try {
        let result: GridLayoutItemInfo[] = [];
        let info2: GridLayoutItemInfo = new GridLayoutItemInfo();
        info2.typeId = CommonConstants.TYPE_APP;
        info2.appStatus = AppStatus.WAIT_FOR_HARMONY;
        info2.intent = '';
        info2.bundleName = 'com.openharmony';
        result.push(info2);
        result =  dataConvert['dealWithSpecialElement'](result, SceneType.FROM_HW_LAUNCHER);
        expect(result.length >= 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getLocationOfUniqueItem_01', 0, () => {
      try {
        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        let res: string = dataConvert['getLocationOfUniqueItem'](info);
        expect(res).assertInstanceOf('String');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getLocationOfUniqueItem_02', 0, () => {
      try {
        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.typeId = CommonConstants.TYPE_APP;
        info.container = CommonConstants.CONTAINER_DESKTOP;
        let res: string = dataConvert['getLocationOfUniqueItem'](info);
        expect(res).assertInstanceOf('String');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getLocationOfUniqueItem_03', 0, () => {
      try {
        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.typeId = CommonConstants.TYPE_APP;
        info.container = CommonConstants.CONTAINER_RECENT;
        info.keyName = 'com.openharmony.sys';
        let res: string = dataConvert['getLocationOfUniqueItem'](info);
        expect(res).assertInstanceOf('String');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getLocationOfUniqueItem_04', 0, () => {
      try {
        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.typeId = CommonConstants.TYPE_CARD;
        info.container = CommonConstants.CONTAINER_RECENT;
        info.keyName = 'com.openharmony.sys';
        let res: string = dataConvert['getLocationOfUniqueItem'](info);
        expect(res).assertInstanceOf('String');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_dealWithSpecialFolder_01', 0, () => {
      try {
        let backupInfoArr: GridLayoutItemInfo[] = [];
        let newSpecialAppMap: Map<string, GridLayoutItemInfo> = new Map();
        let oldSpecialAppList: Map<string, GridLayoutItemInfo> = new Map();
        let installSource: string = '';
        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.intent = '';
        backupInfoArr.push(info);
        let res: GridLayoutItemInfo[] =
          dataConvert['dealWithSpecialFolder'](backupInfoArr, newSpecialAppMap, oldSpecialAppList, installSource);
        expect(res.length >= 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_dealWithSpecialFolder_02', 0, () => {
      try {
        let backupInfoArr: GridLayoutItemInfo[] = [];
        let newSpecialAppMap: Map<string, GridLayoutItemInfo> = new Map();
        let oldSpecialAppList: Map<string, GridLayoutItemInfo> = new Map();
        let installSource: string = 'not_empty';
        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.intent = '';
        backupInfoArr.push(info);
        let res: GridLayoutItemInfo[] =
          dataConvert['dealWithSpecialFolder'](backupInfoArr, newSpecialAppMap, oldSpecialAppList, installSource);
        expect(res.length >= 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_dealWithSingleUniqueApp_01', 0, async (done: Function) => {
      try {
        let appList: AppItemInfo[] =[];
        let info1: AppItemInfo = new AppItemInfo();
        info1.bundleName = 'bundleName1';
        info1.appIndex = 0;
        info1.typeId =  CommonConstants.TYPE_APP;
        appList.push(info1);

        let info2: AppItemInfo = new AppItemInfo();
        info2.bundleName = 'bundleName2';
        info2.codePath === DeliverUtil.ohos_APPLICATION;
        appList.push(info1);

        let backupInfoArr: GridLayoutItemInfo[] = [];
        let existAppSet: Set<String> = new Set();
        await dataConvert['dealWithSingleUniqueApp'](backupInfoArr,existAppSet,appList);
        expect("1").assertInstanceOf('String');
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getIntent_01', 0, () => {
      try {
        let bundleName: string = 'test_bundleName';
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.bundleName = bundleName;
        let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
        item2.appStatus = AppStatus.PENDING;
        dataConvert['appListBeforeConvert'].push(item2);
        let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
        item3.appStatus = AppStatus.INSTALLED;
        item3.bundleName = bundleName;
        dataConvert['appListBeforeConvert'].push(item3);
        let res: string | undefined = dataConvert['getIntent'](item);
        res = "1";
        expect(res).not().assertUndefined();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getAppApp_01', 0, () => {
      try {
      let targetGridLayoutItem: GridLayoutItemInfo[] = [layoutInfos[4]];
      dataConvert['restoreInfo'] = [];
      let result: GridLayoutItemInfo[] = dataConvert['getAppApp'](targetGridLayoutItem);
      expect(result).assertEqual(targetGridLayoutItem);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      dataConvert['restoreInfo'] = [];
    });

    it('test_getAppApp_02', 0, () => {
      try {
        let targetGridLayoutItem: GridLayoutItemInfo[] = [layoutInfos[4]];
        dataConvert['restoreInfo'] = [cloneItemInfos[0]];
        let result: GridLayoutItemInfo[] = dataConvert['getAppApp'](targetGridLayoutItem);
        expect(result).assertEqual(targetGridLayoutItem);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      dataConvert['restoreInfo'] = [];
    });

    it('test_getAppApp_03', 0, () => {
      try {
        let targetGridLayoutItem: GridLayoutItemInfo[] = [layoutInfos[4]];
        dataConvert['restoreInfo'] = [cloneItemInfos[0], cloneItemInfos[3]];
        let result: GridLayoutItemInfo[] = dataConvert['getAppApp'](targetGridLayoutItem);
        expect(result).assertEqual(targetGridLayoutItem);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      dataConvert['restoreInfo'] = [];
    });

    it('test_getAppApp_04', 0, () => {
      try {
        let targetGridLayoutItem: GridLayoutItemInfo[] = [layoutInfos[4]];
        dataConvert['restoreInfo'] = [cloneItemInfos[0], cloneItemInfos[2]];
        let result: GridLayoutItemInfo[] = dataConvert['getAppApp'](targetGridLayoutItem);
        dataConvert['existAppSet'] = new Set(['com.eks.hkflight0']);
        expect(result).assertEqual(targetGridLayoutItem);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      dataConvert['restoreInfo'] = [];
      dataConvert['existAppSet'] = new Set();
    });

    it('test_getAppApp_05', 0, () => {
      try {
        let targetGridLayoutItem: GridLayoutItemInfo[] = [layoutInfos[4]];
        dataConvert['restoreInfo'] = [cloneItemInfos[0], cloneItemInfos[1]];
        let result: GridLayoutItemInfo[] = dataConvert['getAppApp'](targetGridLayoutItem);
        dataConvert['existAppSet'] = new Set(['com.eks.hkflight0']);
        expect(result.length).assertEqual(2);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      dataConvert['restoreInfo'] = [];
      dataConvert['existAppSet'] = new Set();
    });

    it('test_replaceTotalInstalledApp_01', 0, () => {
      try {
        let appKeyName: string = 'com.tencent.qt.sns0';
        let singleItemInfoList: AppItemInfo[] = [];
        layoutInfos[3].appIndex = undefined;
        dataConvert['replaceTotalInstalledApp'](appKeyName,[],singleItemInfoList,[]);
        dataConvert['appListBeforeConvert'] = [layoutInfos[0],layoutInfos[3]];
        dataConvert['replaceTotalInstalledApp'](appKeyName,[],singleItemInfoList,[]);
        layoutInfos[3].appIndex = 0;
        dataConvert['appListBeforeConvert'] = [layoutInfos[3]];
        dataConvert['replaceTotalInstalledApp'](appKeyName,[],singleItemInfoList,[]);
        layoutInfos[0].appIndex = undefined;
        let targetGridLayoutItem: GridLayoutItemInfo[] = [layoutInfos[0]];
        dataConvert['replaceTotalInstalledApp'](appKeyName,targetGridLayoutItem,singleItemInfoList,[]);
        layoutInfos[0].appIndex = 0;
        dataConvert['replaceTotalInstalledApp'](appKeyName,targetGridLayoutItem,singleItemInfoList,[]);
        expect(singleItemInfoList.length).assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      dataConvert['appListBeforeConvert'] = [];
    })

    it('test_replaceTotalInstalledApp_02', 0, () => {
      try {
        let appKeyName: string = 'macao.taxi.passager0';
        let singleItemInfoList: AppItemInfo[] = [];
        dataConvert['restoreInfo'] = [cloneItemInfos[0], cloneItemInfos[2], cloneItemInfos[1]];
        dataConvert['appListBeforeConvert'] = [layoutInfos[4], layoutInfos[0]];
        let targetGridLayoutItem: GridLayoutItemInfo[] = [layoutInfos[4], layoutInfos[0]];
        let appListFromBms: AppItemInfo[] = appItemInfos;
        dataConvert['replaceTotalInstalledApp'](appKeyName, targetGridLayoutItem, singleItemInfoList, appListFromBms);
        dataConvert['appListBeforeConvert'] = [layoutInfos[4], layoutInfos[2]];
        targetGridLayoutItem = [layoutInfos[4], layoutInfos[0]];
        dataConvert['backUpType'] = SceneType.FROM_HW_LAUNCHER;
        dataConvert['replaceTotalInstalledApp'](appKeyName, targetGridLayoutItem, singleItemInfoList, appListFromBms);
        expect(singleItemInfoList.length).assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      dataConvert['appListBeforeConvert'] = [];
      dataConvert['restoreInfo'] = [];
      dataConvert['backUpType'] = -1;
    })

    it('test_replaceTotalInstalledApp_03', 0, () => {
      try {
        let appKeyName: string = 'macao.taxi.passager0';
        let singleItemInfoList: AppItemInfo[] = [];
        dataConvert['restoreInfo'] = [cloneItemInfos[0], cloneItemInfos[2], cloneItemInfos[3]];
        dataConvert['appListBeforeConvert'] = [layoutInfos[4], layoutInfos[0]];
        let targetGridLayoutItem: GridLayoutItemInfo[] = [layoutInfos[4], layoutInfos[2]];
        let appListFromBms: AppItemInfo[] = appItemInfos;
        dataConvert['backUpType'] = SceneType.FROM_SCENE_BOARD;
        dataConvert['replaceTotalInstalledApp'](appKeyName, targetGridLayoutItem, singleItemInfoList, appListFromBms);
        dataConvert['appListBeforeConvert'] = [layoutInfos[4], layoutInfos[2]];
        dataConvert['backUpType'] = SceneType.FROM_HW_LAUNCHER;
        dataConvert['replaceTotalInstalledApp'](appKeyName, targetGridLayoutItem, singleItemInfoList, appListFromBms);
        expect(singleItemInfoList.length).assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      dataConvert['appListBeforeConvert'] = [];
      dataConvert['restoreInfo'] = [];
      dataConvert['backUpType'] = -1;
    })

    it('test_dealOhosSuperAdditionApps_01', 0, async (done: Function) => {
      try {
        let result: GridLayoutItemInfo[] = [];
        await dataConvert['dealOhosSuperAdditionApps'](result);
        expect(result.length).assertEqual(0);
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_dealOhosSuperAdditionApps_02', 0, async (done: Function) => {
      try {
        let backupInfoArr: GridLayoutItemInfo[] = [];
        let info1: GridLayoutItemInfo = new GridLayoutItemInfo();
        info1.container = CommonConstants.CONTAINER_UNIQUE_SINGLE;
        backupInfoArr.push(info1);
        let info2: GridLayoutItemInfo = new GridLayoutItemInfo();
        info1.typeId  = CommonConstants.TYPE_CARD;
        backupInfoArr.push(info2);
        let info3: GridLayoutItemInfo = new GridLayoutItemInfo();
        info3.bundleName  = 'com.ss.ohos.ugc.aweme.lite';
        backupInfoArr.push(info3);
        await dataConvert['dealOhosSuperAdditionApps'](backupInfoArr);
        expect(backupInfoArr.length).assertEqual(3);
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_buildHmSuperAdditionApp', 0, async (done: Function) => {
      try {
        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.bundleName  = 'com.ss.ohos.ugc.aweme.lite';
        let addInfoMap: Map<string, GridLayoutItemInfo> = new Map<string, GridLayoutItemInfo>();
        await dataConvert['buildHmSuperAdditionApp'](info, '', addInfoMap);
        await dataConvert['buildHmSuperAdditionApp'](info, 'com.ss.hm.ugc.aweme', addInfoMap);
        expect(addInfoMap.size).assertLargerOrEqual(0);
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_checkNeedUpdateAddInfo', 0, () => {
      let info1: GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.container = -100;
      let info2: GridLayoutItemInfo = new GridLayoutItemInfo();
      info2.container = -101;
      expect(dataConvert['checkNeedUpdateAddInfo'](info1, info2)).assertEqual(false);
      info2.container = 10;
      expect(dataConvert['checkNeedUpdateAddInfo'](info1, info2)).assertEqual(false);
      info2.container = -100;
      info1.page = 2;
      info2.page = 3;
      expect(dataConvert['checkNeedUpdateAddInfo'](info1, info2)).assertEqual(false);
      info2.page = 2;
      info1.row = 2;
      info2.row = 3;
      expect(dataConvert['checkNeedUpdateAddInfo'](info1, info2)).assertEqual(false);
      info2.row = 2;
      info1.column  = 2;
      info2.column  = 3;
      expect(dataConvert['checkNeedUpdateAddInfo'](info1, info2)).assertEqual(false);
    })

    it('test_isNotHarmonyManyToOne', 0, () => {
      expect(dataConvert['isNotHarmonyManyToOne']('')).assertEqual(false);
      expect(dataConvert['isNotHarmonyManyToOne']('com.ss.hm.ugc.aweme')).assertEqual(false);
    })
  })
}
