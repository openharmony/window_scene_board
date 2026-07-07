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
  ArgumentMatchers
} from '@ohos/hypium'
import systemparameter from '@ohos.systemparameter';
import {
  AppItemInfo,
  CommonConstants,
  DeliverUtil,
  DockItemInfo,
  FolderViewModel,
  GridLayoutItemInfo,
  LayoutViewModel,
  LegacyInfo,
  GridLayoutUtil,
  NotHarmonyUtil,
  FolderModel,
  FolderLayoutCacheManager,
  LaunchLayoutCacheManager,
  AppGalleryDownloadManager,
  AppModel,
  AppStatus,
  FolderData,
  InstalledDialogType,
  DialogConfig,
} from '../../../../../../main/ets/TsIndex';
import { CheckEmptyUtils, ArrayUtils, CommonUtils } from '@ohos/basicutils';
import { SCBSceneSessionManager, StartAbilityUtil } from '@ohos/windowscene';
import { image } from '@kit.ImageKit';
import { AppInstallUtils } from '../../../../../../main/ets/appinstall/AppInstallUtils';
import { DesktopLayoutCacheData } from '../../../../../../main/ets/cache/layout/DesktopLayoutCacheData';

function initGridLayoutItemInfos(): GridLayoutItemInfo[][] {
  let layoutInfos: GridLayoutItemInfo[][] = [];
  // 应用
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

  let gridLayoutApp1: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutApp1.typeId = CommonConstants.TYPE_APP;
  gridLayoutApp1.infoId = '50';
  gridLayoutApp1.infoName = '应用市场';
  gridLayoutApp1.bundleName = 'com.ohos.appgallery';
  gridLayoutApp1.abilityName = 'MainAbility';
  gridLayoutApp1.moduleName = 'entry';
  gridLayoutApp1.container = 48;
  gridLayoutApp1.row = 0;
  gridLayoutApp1.column = 0;
  gridLayoutApp1.area = [1, 1];
  layoutInfos[0] = [gridLayoutApp, gridLayoutApp1];
  return layoutInfos;
}

function initFolderGridLayoutItemInfo(): GridLayoutItemInfo {
  let gridLayoutFolderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutFolderItem.typeId = CommonConstants.TYPE_APP;
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
  gridLayoutFolderItem1.typeId = CommonConstants.TYPE_APP;
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
  gridLayoutFolder.typeId = CommonConstants.TYPE_FOLDER;
  gridLayoutFolder.infoId = '1715654262380';
  gridLayoutFolder.infoName = '应用';
  gridLayoutFolder.bundleName = '';
  gridLayoutFolder.folderName = '应用';
  gridLayoutFolder.abilityName = '';
  gridLayoutFolder.moduleName = '';
  gridLayoutFolder.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutFolder.page = 1;
  gridLayoutFolder.row = 4;
  gridLayoutFolder.column = 2;
  gridLayoutFolder.area = [2, 2];
  gridLayoutFolder.layoutInfo = [];

  gridLayoutFolder.layoutInfo[0] = [gridLayoutFolderItem, gridLayoutFolderItem1];

  return gridLayoutFolder;
}

function initAppItemInfo(): AppItemInfo {
  let appName = 'anyAppNameAsYouLike';
  let appIconId = 10;
  let bundleName = 'anyBundleNameAsYouLike';
  let abilityName = 'anyAbilityName';
  let downloadProgress = 20;
  let appStatus = 0;
  let appItemInfo: AppItemInfo = {
    appName,
    appIconId,
    bundleName,
    abilityName,
    downloadProgress,
    appStatus
  };
  return appItemInfo;
}

function initDhItemInfos(): GridLayoutItemInfo[]{
  let dhItemInfos: GridLayoutItemInfo[] =[];
  let gridLayoutEasyAbroadApp: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutEasyAbroadApp.typeId = CommonConstants.TYPE_APP;
  gridLayoutEasyAbroadApp.infoId = '37f7caf8-eff6-46ab-aefe-0f9786e47669';
  gridLayoutEasyAbroadApp.infoName = '电召PLUS';
  gridLayoutEasyAbroadApp.bundleName = 'macao.taxi.passager';
  gridLayoutEasyAbroadApp.abilityName = 'MainAbility';
  gridLayoutEasyAbroadApp.moduleName = 'phone';
  gridLayoutEasyAbroadApp.container = 66;
  gridLayoutEasyAbroadApp.page = 0;
  gridLayoutEasyAbroadApp.row = 1;
  gridLayoutEasyAbroadApp.column = 0;
  gridLayoutEasyAbroadApp.areaType = 0;
  gridLayoutEasyAbroadApp.area = [1, 1];
  gridLayoutEasyAbroadApp.intent =
    '{"legacyInfo":{"pkgName":"macao.taxi.passager","pkgLableName":"电召PLUS","pkgSignature":"8c6e07f87c9db98fde934f69bdaaf653ef1176b0e0aa5959de87b34203a8d5f3","versionCode":"2025052303","versionName":"3.3.7","installSource":"com.ohos.abroad"},"targetModuleUrl":"","requestBundleName":"__WAIT_FOR_HARMONY_BUNDLENAME__macao.taxi.passager__1750122530100","installSource":"com.ohos.abroad","appType":0,"maskState":0}';

  let gridLayoutdeliverApp: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutdeliverApp.typeId = CommonConstants.TYPE_APP;
  gridLayoutdeliverApp.infoId = 'a1a6df81-66c7-428c-b340-66f3610356d8';
  gridLayoutdeliverApp.infoName = '掌上穿越火线';
  gridLayoutdeliverApp.bundleName = 'com.tencent.qt.sns';
  gridLayoutdeliverApp.abilityName = 'MainAbility';
  gridLayoutdeliverApp.moduleName = 'phone';
  gridLayoutdeliverApp.container = -100;
  gridLayoutdeliverApp.page = 0;
  gridLayoutdeliverApp.row = 0;
  gridLayoutdeliverApp.areaType = 0;
  gridLayoutdeliverApp.column = 1;
  gridLayoutdeliverApp.area = [1, 1];
  gridLayoutdeliverApp.intent =
    '{"legacyInfo":{"pkgName":"com.tencent.qt.sns","pkgLableName":"掌上穿越火线","pkgSignature":"90eec83fcadc14edefe83d33d6578ad6111957a3975b7a2a2eddfbd262a96a5d","versionCode":"2103290004","versionName":"3.29.0","installSource":"com.deliver.appstore.lite"},"targetModuleUrl":"","requestBundleName":"__WAIT_FOR_HARMONY_BUNDLENAME__com.tencent.qt.sns__1750157767972","installSource":"com.deliver.appstore.lite","appType":0,"maskState":0}';

  // 克隆应用文件夹
  let gridLayoutdeliverFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutdeliverFolder.id = 48;
  gridLayoutdeliverFolder.typeId = CommonConstants.TYPE_FOLDER;
  gridLayoutdeliverFolder.infoId = '1715654262381';
  gridLayoutdeliverFolder.infoName = '${app_others}';
  gridLayoutdeliverFolder.bundleName = '';
  gridLayoutdeliverFolder.folderName = '${app_others}';
  gridLayoutdeliverFolder.abilityName = '';
  gridLayoutdeliverFolder.moduleName = '';
  gridLayoutdeliverFolder.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutdeliverFolder.page = 1;
  gridLayoutdeliverFolder.row = 4;
  gridLayoutdeliverFolder.column = 2;
  gridLayoutdeliverFolder.area = [2, 2];
  gridLayoutdeliverFolder.layoutInfo = [];
  gridLayoutdeliverFolder.intent = '{"installSource":"com.deliver.appstore.lite"}';

  // 应用文件夹
  let gridLayoutAboardFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutAboardFolder.id = 48;
  gridLayoutAboardFolder.typeId = CommonConstants.TYPE_FOLDER;
  gridLayoutAboardFolder.infoId = '1715654262382';
  gridLayoutAboardFolder.infoName = '应用';
  gridLayoutAboardFolder.bundleName = '';
  gridLayoutAboardFolder.folderName = '应用';
  gridLayoutAboardFolder.abilityName = '';
  gridLayoutAboardFolder.moduleName = '';
  gridLayoutAboardFolder.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutAboardFolder.page = 1;
  gridLayoutAboardFolder.row = 4;
  gridLayoutAboardFolder.column = 2;
  gridLayoutAboardFolder.area = [2, 2];
  gridLayoutAboardFolder.layoutInfo = [];
  gridLayoutAboardFolder.intent = '{"installSource":"com.ohos.abroad"}';

  // 未鸿蒙化文件夹
  let gridLayoutNotHarmonyFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutAboardFolder.id = 48;
  gridLayoutAboardFolder.typeId = CommonConstants.TYPE_FOLDER;
  gridLayoutAboardFolder.infoId = '1715654262383';
  gridLayoutAboardFolder.infoName = '${not_harmony_apps}';
  gridLayoutAboardFolder.bundleName = '';
  gridLayoutAboardFolder.folderName = '${not_harmony_apps}';
  gridLayoutAboardFolder.abilityName = '';
  gridLayoutAboardFolder.moduleName = '';
  gridLayoutAboardFolder.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutAboardFolder.page = 1;
  gridLayoutAboardFolder.row = 4;
  gridLayoutAboardFolder.column = 2;
  gridLayoutAboardFolder.area = [2, 2];
  gridLayoutAboardFolder.layoutInfo = [];
  gridLayoutAboardFolder.intent = '{"NotHarmonyFolder":"1715654262383"}';
  dhItemInfos.push(gridLayoutEasyAbroadApp, gridLayoutdeliverApp, gridLayoutdeliverFolder, gridLayoutAboardFolder,
    gridLayoutNotHarmonyFolder);
  return dhItemInfos;
}

export default function DeliverUtilTest() {
  let layoutInfos: GridLayoutItemInfo[][] = initGridLayoutItemInfos();
  let dhItemInfos: GridLayoutItemInfo[] = initDhItemInfos();
    describe('DeliverUtilTest', () => {
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


    it('test_addAddIconToLayoutInfo01', 0, () => {
      let method: string = 'method';
      try {
        DeliverUtil.addAddIconToLayoutInfo(layoutInfos, method);
      } catch (error) {
      }
      expect(method).assertEqual('method');
    });

    it('test_addAddIconToLayoutInfo02', 0, () => {
      let mocker: MockKit = new MockKit();
      let layoutViewModel = LayoutViewModel.getInstance();
      let queryGridLayoutInfo: Function = mocker.mockFunc(layoutViewModel, layoutViewModel.isSimpleLauncherMode);
      when(queryGridLayoutInfo)(ArgumentMatchers.any).afterReturn(true);
      let method: string = 'method';
      try {
        expect(DeliverUtil.addAddIconToLayoutInfo(layoutInfos, method) === undefined).assertTrue();
      } catch (error) {
      }
      mocker.ignoreMock(layoutViewModel, layoutViewModel.isSimpleLauncherMode);
    });

    it('test_addAddIconToLayoutInfo03', 0, () => {
      let mocker: MockKit = new MockKit();
      let isContainerFolder: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerFolder);
      when(isContainerFolder)(ArgumentMatchers.any).afterReturn(false);

      let isLayoutFull: Function = mocker.mockFunc(FolderViewModel, FolderViewModel.isLayoutFull);
      when(isLayoutFull)(ArgumentMatchers.any).afterReturn(true);

      let method: string = 'method';
      try {
        expect(DeliverUtil.addAddIconToLayoutInfo(layoutInfos, method) === undefined).assertTrue();
      } catch (error) {
      }
      mocker.ignoreMock(DeliverUtil, DeliverUtil.isContainerFolder);
      mocker.ignoreMock(FolderViewModel, FolderViewModel.isLayoutFull);
    });

    it('test_addAddIcon01', 0, () => {
      let folderItem: GridLayoutItemInfo = initFolderGridLayoutItemInfo();
      let ret: GridLayoutItemInfo = new GridLayoutItemInfo();
      try {
        ret = DeliverUtil.addAddIcon(folderItem, 'method');
      } catch (error) {
      }
      expect(ret).not().assertNull();
    });

    it('test_addAddIcon02', 0, () => {
      let mocker: MockKit = new MockKit();
      let layoutViewModel = LayoutViewModel.getInstance();
      let queryGridLayoutInfo: Function = mocker.mockFunc(layoutViewModel, layoutViewModel.isSimpleLauncherMode);
      when(queryGridLayoutInfo)(ArgumentMatchers.any).afterReturn(true);
      try {
        let folderItem: GridLayoutItemInfo = initFolderGridLayoutItemInfo();
        let ret: GridLayoutItemInfo = DeliverUtil.addAddIcon(folderItem, 'method');
        expect(ret).not().assertNull();
      } catch (error) {
      }
      mocker.ignoreMock(layoutViewModel, layoutViewModel.isSimpleLauncherMode);
    });

    it('test_addAddIcon03', 0, () => {
      AppStorage.setOrCreate<boolean>('isAddIconHidden', true);
      let ret: GridLayoutItemInfo = DeliverUtil.addAddIcon(new GridLayoutItemInfo(), 'method');
      expect(ret).not().assertNull();
      AppStorage.setOrCreate<boolean>('isAddIconHidden', false);
    });

    it('test_addAddIcon04', 0, () => {
      let ret: GridLayoutItemInfo = DeliverUtil.addAddIcon(undefined, 'method');
      expect(ret).not().assertNull();
    });

    it('test_addAddIcon05', 0, () => {
      let folderItem: GridLayoutItemInfo = initFolderGridLayoutItemInfo();
      folderItem.layoutInfo = [];
      let ret: GridLayoutItemInfo = DeliverUtil.addAddIcon(folderItem, 'method');
      expect(ret).not().assertNull();
    });

    it('test_delAddIcon01', 0, () => {
      let folderItem: GridLayoutItemInfo = initFolderGridLayoutItemInfo();
      let ret: GridLayoutItemInfo = DeliverUtil.delAddIcon(folderItem, 'method');
      expect(ret).not().assertNull();
    });

    it('test_delAddIcon02', 0, () => {
      let mocker: MockKit = new MockKit();
      let layoutViewModel = LayoutViewModel.getInstance();
      let queryGridLayoutInfo: Function = mocker.mockFunc(layoutViewModel, layoutViewModel.isSimpleLauncherMode);
      when(queryGridLayoutInfo)(ArgumentMatchers.any).afterReturn(true);
      let folderItem: GridLayoutItemInfo = initFolderGridLayoutItemInfo();
      let ret: GridLayoutItemInfo = DeliverUtil.delAddIcon(folderItem, 'method');
      expect(ret).not().assertNull();
      mocker.ignoreMock(layoutViewModel, layoutViewModel.isSimpleLauncherMode);
    });

    it('test_delAddIcon03', 0, () => {
      let folderItem: GridLayoutItemInfo = initFolderGridLayoutItemInfo();
      folderItem.layoutInfo = [];
      let ret: GridLayoutItemInfo = DeliverUtil.delAddIcon(folderItem, 'method');
      expect(ret).not().assertNull();
    });

    it('test_delAddIconFromLayoutInfo', 0, () => {
      let ret: GridLayoutItemInfo[][] = DeliverUtil['delAddIconFromLayoutInfo'](layoutInfos, 'method');
      expect(ret.length).assertLargerOrEqual(0);
    });

    it('test_isLastAppAddIcon01', 0, () => {
      let folderItem: GridLayoutItemInfo = initFolderGridLayoutItemInfo();
      let ret: boolean = DeliverUtil['isLastAppAddIcon'](folderItem);
      expect(ret).assertTrue();
    });

    it('test_isLastAppAddIcon02', 0, () => {
      let mocker: MockKit = new MockKit();
      let layoutViewModel = LayoutViewModel.getInstance();
      let queryGridLayoutInfo: Function = mocker.mockFunc(layoutViewModel, layoutViewModel.isSimpleLauncherMode);
      when(queryGridLayoutInfo)(ArgumentMatchers.any).afterReturn(true);
      try {
        let folderItem: GridLayoutItemInfo = initFolderGridLayoutItemInfo();
        let ret: boolean = DeliverUtil['isLastAppAddIcon'](folderItem);
        expect(ret).assertFalse();
      } catch (error) {
      }
      mocker.clear(layoutViewModel);
    });

    it('test_removeRecentSpecialApp', 0, () => {
      let bundleName: string = 'com.deliver.iapps';
      expect(DeliverUtil['removeRecentSpecialApp'](bundleName) === undefined).assertTrue();
    });

    it('test_refreshFolder01', 0, () => {
      let item = new GridLayoutItemInfo();
      item.folderId = '17202413';
      item.intent = '{"installSource":"com.ohos.abroad"}';
      DeliverUtil.setContainerFolderMapInDesktop(item);

      expect(DeliverUtil.refreshFolder() === undefined).assertTrue();
    });

    it('test_refreshFolder02', 0, () => {
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      try {
        expect(DeliverUtil.refreshFolder() === undefined).assertTrue();
      } catch (error) {
      }
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    });

    it('test_refreshFolderAppsInDock01', 0, () => {
      expect(DeliverUtil.refreshFolderAppsInDock() === undefined).assertTrue();
    });

    it('test_refreshFolderAppsInDock02', 0, () => {
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      try {
        let needDeletedApps: AppItemInfo[] = [];
         expect(DeliverUtil.refreshFolderAppsInDock() === undefined).assertTrue();
      } catch (error) {
      }
      mocker.clear(CheckEmptyUtils);
    });

    it('test_translateFolderLayout', 0, () => {
      let folderItem: GridLayoutItemInfo = initFolderGridLayoutItemInfo();
      let appInfos: GridLayoutItemInfo[] = [folderItem];
      let ret: GridLayoutItemInfo[][] = DeliverUtil['translateFolderLayout'](appInfos);
      expect(ret.length).assertLargerOrEqual(0);
    });

    it('test_setInstallSourceAndIntent01', 0, () => {
      let appItemInfo: AppItemInfo = initAppItemInfo();
      let intent: string = '{"installSource":"com.ohos.abroad"}';
      expect(DeliverUtil['setInstallSourceAndIntent'](appItemInfo, intent) === undefined).assertTrue();
    });

    it('test_setInstallSourceAndIntent02', 0, () => {
      let intent: string = '{"installSource":"com.ohos.abroad"}';
      expect(DeliverUtil['setInstallSourceAndIntent'](new AppItemInfo(), intent) === undefined).assertTrue();
    });

    it('test_setInstallSourceAndIntent03', 0, () => {
      let appItemInfo: AppItemInfo = initAppItemInfo();
      expect(DeliverUtil['setInstallSourceAndIntent'](appItemInfo, '') === undefined).assertTrue();
    });

    it('test_getInstallSourceByBundleName', 0, () => {
      let bundleName: string = 'com.ohos.abroad';
      let source: string = DeliverUtil['getInstallSourceByBundleName'](bundleName);
      expect(source).not().assertNull();
    });

    it('test_getContainerFolderName', 0, () => {
      let appItemInfo: AppItemInfo = initAppItemInfo();
      let source: string = DeliverUtil['getContainerFolderName'](appItemInfo);
      expect(source).not().assertNull();
    });

    it('test_setContainerFolderMapInDock', 0, () => {
      let dockItem: DockItemInfo = new DockItemInfo();
      expect(DeliverUtil['setContainerFolderMapInDock'](dockItem) === undefined).assertTrue();
    });

    it('test_isHaveDeliverApps', 0, () => {
      let result: boolean = DeliverUtil['isHaveDeliverApps']();
      expect(result).assertFalse();
    });

    it('test_getCloneGridLayoutItemIntent', 0, () => {
      let legacyInfo: LegacyInfo = {
        'pkgName': 'com.openharmony.pingduoduo',
        'pkgLableName': '拼多多',
        'pkgSignature': '123456789',
        'backup': 0
      };
      let waitForSystemKey: string = 'waitForSystemKey';
      let enterpriseLink: string = 'enterpriseLink';
      let result: string =
        DeliverUtil['getCloneGridLayoutItemIntent'](legacyInfo, waitForSystemKey, enterpriseLink, 0);
      expect(result).not().assertNull();
    });

    it('test_setContainerAppNameCache01', 0, () => {
      let intent: string = '{"installSource":"com.ohos.abroad"}';
      expect(DeliverUtil['setContainerAppNameCache'](new GridLayoutItemInfo(), intent) === undefined).assertTrue();
    });

    it('test_setContainerAppNameCache02', 0, () => {
      let gridLayoutFolderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutFolderItem.typeId = CommonConstants.TYPE_APP;
      gridLayoutFolderItem.infoId = '50';
      gridLayoutFolderItem.infoName = '应用市场';
      gridLayoutFolderItem.bundleName = 'com.ohos.appgallery';
      gridLayoutFolderItem.abilityName = 'MainAbility';
      gridLayoutFolderItem.moduleName = 'entry';
      gridLayoutFolderItem.container = 48;
      gridLayoutFolderItem.row = 0;
      gridLayoutFolderItem.column = 0;
      gridLayoutFolderItem.area = [1, 1];
      gridLayoutFolderItem.appName = '应用市场';
      let intent: string = '{"installSource":"com.ohos.abroad"}';
      expect(DeliverUtil['setContainerAppNameCache'](gridLayoutFolderItem, intent) === undefined).assertTrue();
    });

    it('test_addAddIconForResidentList01', 0, () => {
      let mocker: MockKit = new MockKit();
      let layoutViewModel = LayoutViewModel.getInstance();
      let queryGridLayoutInfo: Function = mocker.mockFunc(layoutViewModel, layoutViewModel.isSimpleLauncherMode);
      when(queryGridLayoutInfo)(ArgumentMatchers.any).afterReturn(true);
      try {
        expect(DeliverUtil.addAddIconForResidentList('17202413') === undefined).assertTrue();
      } catch (error) {
      }
      mocker.ignoreMock(layoutViewModel, layoutViewModel.isSimpleLauncherMode);
    });

    it('test_copyDesktopOldDataToIntent01', 0, () => {
      let item: GridLayoutItemInfo = initFolderGridLayoutItemInfo();
      item.id = 0;
      item.intent = '';
      item.extend1 = '-999';
      expect(DeliverUtil.copyDesktopOldDataToIntent(item) === undefined).assertTrue();
    });

    it('test_copyDockOldDataToIntent01', 0, () => {
      let gridLayoutFolderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutFolderItem.typeId = CommonConstants.TYPE_APP;
      gridLayoutFolderItem.infoId = '50';
      gridLayoutFolderItem.infoName = '应用市场';
      gridLayoutFolderItem.bundleName = 'com.ohos.appgallery';
      gridLayoutFolderItem.abilityName = 'MainAbility';
      gridLayoutFolderItem.moduleName = 'entry';
      gridLayoutFolderItem.container = 48;
      gridLayoutFolderItem.row = 0;
      gridLayoutFolderItem.column = 0;
      gridLayoutFolderItem.area = [1, 1];

      let item: DockItemInfo = new DockItemInfo();
      item.id = 0;
      item.intent = '';
      item.extend1 = '-999';
      item.layoutInfo = [];
      item.layoutInfo[0] = [gridLayoutFolderItem];
      expect(DeliverUtil.copyDockOldDataToIntent(item) === undefined).assertTrue();
    });

    it('test_isSupportDeliver', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let oldParam: string = systemparameter.getSync('const.app_eco.support_ohos', 'default');
      let newParam: string = systemparameter.getSync('persist.ohos_fusion_mgr.ctl.support_ohos', 'default');
      if (oldParam === 'true' || newParam === 'true') {
        expect(DeliverUtil.isSupportDeliver()).assertEqual(true);
      } else {
        expect(DeliverUtil.isSupportDeliver()).assertEqual(false);
      }
    })
    it('test_isSupportAppType', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let bundleName: string = 'abc123';
      expect(DeliverUtil.isSupportAppType(bundleName)).assertEqual(false);

      bundleName = 'com.ohos.sceneboard';
      expect(DeliverUtil.isSupportAppType(bundleName)).assertInstanceOf('Boolean');
    })

    it('test_isSupportAppTypeInOut', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let bundleName: string  = 'abc123';
      expect(DeliverUtil.isSupportAppTypeInOut(bundleName)).assertEqual(false);

      bundleName  = 'com.ohos.sceneboard';
      expect(DeliverUtil.isSupportAppTypeInOut(bundleName)).assertInstanceOf('Boolean');
    })

    it('test_setIsCreateFolder', 0, () => {
      let folderInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderInfo.layoutInfo = [];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let list: GridLayoutItemInfo[] = [];
      list.push(item);
      folderInfo.layoutInfo.push(list);
      folderInfo.folderId = '17202412';
      folderInfo.intent = '{"installSource":"com.ohos.abroad"}';
      DeliverUtil.setContainerFolderMapInDesktop(folderInfo);
      DeliverUtil.setIsCreateFolder(true);
      let ret: boolean = DeliverUtil.isCreateFolder(folderInfo);
      expect(ret).assertTrue();
    });

    it('test_isDisableOperationsOnFolder', 0, () => {
      let folderId = '17202412';
      let item = new GridLayoutItemInfo();
      item.folderId = folderId;
      item.intent = '{"installSource":"com.ohos.abroad"}';
      DeliverUtil.setContainerFolderMapInDesktop(item);
      let ret: boolean = DeliverUtil.isDisableOperationsOnFolder(folderId);
      expect(ret).assertTrue();
      ret = DeliverUtil.isDisableOperationsOnFolder('17202433');
      expect(ret).assertFalse();
    });

    it('test_checkFolderIsReleased', 0, () => {
      let folderId = '17202412';
      let item = new GridLayoutItemInfo();
      item.folderId = folderId;
      item.intent = '{"installSource":"com.ohos.abroad"}';
      DeliverUtil.setContainerFolderMapInDesktop(item);
      let ret: boolean = DeliverUtil.checkFolderIsReleased(folderId, 0);
      expect(ret).assertTrue();
      ret = DeliverUtil.checkFolderIsReleased(folderId, 1);
      expect(ret).assertFalse();
      ret = DeliverUtil.checkFolderIsReleased('17202433', 0);
      expect(ret).assertTrue();
      ret = DeliverUtil.checkFolderIsReleased('17202433', 1);
      expect(ret).assertTrue();
    });

    it('test_checkFolderIsOneMoreApps', 0, () => {
      let folderId = '17202412';
      let item = new GridLayoutItemInfo();
      item.folderId = folderId;
      item.intent = '{"installSource":"com.ohos.abroad"}';
      DeliverUtil.setContainerFolderMapInDesktop(item);
      let ret: boolean = DeliverUtil.checkFolderIsOneMoreApps(folderId, 2);
      expect(ret).assertTrue();
      ret = DeliverUtil.checkFolderIsOneMoreApps(folderId, 0);
      expect(ret).assertFalse();
      ret = DeliverUtil.checkFolderIsOneMoreApps(folderId, 1);
      expect(ret).assertTrue();
      ret = DeliverUtil.checkFolderIsOneMoreApps('17202433', 2);
      expect(ret).assertTrue();
      ret = DeliverUtil.checkFolderIsOneMoreApps('17202433', 0);
      expect(ret).assertFalse();
      ret = DeliverUtil.checkFolderIsOneMoreApps('17202433', 1);
      expect(ret).assertFalse();
    });

    it('test_isCreateFolder', 0, () => {
      let folderInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderInfo.layoutInfo = [];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let list: GridLayoutItemInfo[] = [];
      list.push(item);
      folderInfo.layoutInfo.push(list);
      folderInfo.folderId = '17202412';
      folderInfo.intent = '{"installSource":"com.ohos.abroad"}';
      DeliverUtil.setContainerFolderMapInDesktop(folderInfo);
      DeliverUtil.setIsCreateFolder(true);
      let ret: boolean = DeliverUtil.isCreateFolder(folderInfo);
      expect(ret).assertTrue();
      folderInfo.folderId = '17202413';
      ret = DeliverUtil.isCreateFolder(folderInfo);
      expect(ret).assertFalse();
    });

    it('test_isShowToast', 0, () => {
      let ret: boolean = DeliverUtil.isShowToast();
      expect(ret).assertInstanceOf('Boolean');
    });

    it('test_addAddIcon', 0, () => {
      let fileInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let folderId = '17202412';
      fileInfo.folderId = folderId;
      fileInfo.intent = '{"installSource":"com.ohos.abroad"}';
      DeliverUtil.setContainerFolderMapInDesktop(fileInfo);
      fileInfo.folderId = folderId;
      let ret: GridLayoutItemInfo = DeliverUtil.addAddIcon(fileInfo, '');
      expect(ret).not().assertNull();
      fileInfo.folderId = '17202413';
      ret = DeliverUtil.addAddIcon(fileInfo, '');
      expect(ret).not().assertNull();
    });

    it('test_delAddIcon', 0, () => {
      let fileInfo: GridLayoutItemInfo = new GridLayoutItemInfo()
      let folderId = '17202412';
      fileInfo.folderId = folderId;
      fileInfo.intent = '{"installSource":"com.ohos.abroad"}';
      DeliverUtil.setContainerFolderMapInDesktop(fileInfo);
      fileInfo.folderId = folderId;
      let ret: GridLayoutItemInfo = DeliverUtil.delAddIcon(fileInfo, '');
      expect(ret).not().assertNull();
      fileInfo.folderId = '17202413';
      ret = DeliverUtil.delAddIcon(fileInfo, '');
      expect(ret).not().assertNull();
    });

    it('test_delAddIconForOpenFolderData', 0, () => {
      let fileInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let folderId = '17202412';
      fileInfo.folderId = folderId;
      fileInfo.intent = '{"installSource":"com.ohos.abroad"}';
      DeliverUtil.setContainerFolderMapInDesktop(fileInfo);
      fileInfo.folderId = folderId;
      let ret: GridLayoutItemInfo = DeliverUtil.delAddIconForOpenFolderData(fileInfo);
      expect(ret).not().assertNull();
      fileInfo.folderId = '17202413';
      ret = DeliverUtil.delAddIconForOpenFolderData(fileInfo);
      expect(ret).not().assertNull();
    });

    it('test_addAddIconForResidentList', 0, () => {
      let item = new GridLayoutItemInfo();
      item.folderId = '17202413';
      item.intent = '{"installSource":"com.ohos.abroad"}';
      DeliverUtil.setContainerFolderMapInDesktop(item);
      DeliverUtil.addAddIconForResidentList('17202413');
      let ret = true;
      expect(ret).assertTrue();
    });

    it('test_delAddIconForResidentList', 0, () => {
      let fileInfo: DockItemInfo = {
        bundleName: '',
        abilityName: '',
        appIconId: 0,
        downloadProgress: 0,
        appStatus: undefined,
        iconResource: undefined,
        callerName: undefined,
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: ''
      };
      let item = new GridLayoutItemInfo();
      item.folderId = '17202413';
      item.intent = '{"installSource":"com.ohos.abroad"}';
      DeliverUtil.setContainerFolderMapInDesktop(item);
      DeliverUtil.delAddIconForResidentList([fileInfo], 0);
      let ret = true;
      expect(ret).assertTrue();
    });

    it('test_handleOnClicked', 0, () => {
      DeliverUtil.handleOnClicked('17202412');
      let ret = true;
      expect(ret).assertTrue();
    });

    it('test_isLastAppAddIcon', 0, () => {
      let fileInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let folderId = '17202412';
      fileInfo.folderId = folderId;
      fileInfo.intent = '{"installSource":"com.ohos.abroad"}';
      DeliverUtil.setContainerFolderMapInDesktop(fileInfo);
      fileInfo.folderId = folderId;
      let ret = DeliverUtil.isLastAppAddIcon(fileInfo);
      expect(ret).assertFalse();
      fileInfo.folderId = '17202413';
      ret = DeliverUtil.isLastAppAddIcon(fileInfo);
      expect(ret).assertFalse();
    });

    it('test_getAddIconGeometryId', 0, () => {
      let ret = DeliverUtil.getAddIconGeometryId();
      expect(ret).not().assertNull();
    });

    it('test_setAppBundleNameFoundInDock', 0, () => {
      let appBundleName = 'com.ohos.settings';
      DeliverUtil.setAppBundleNameFoundInDock(appBundleName);
      let ret: boolean = DeliverUtil.isAppBundleNameFoundInDock(appBundleName);
      expect(ret).assertTrue();
    });

    it('test_isAppBundleNameFoundInDock', 0, () => {
      let appBundleName = 'com.ohos.settings';
      DeliverUtil.setAppBundleNameFoundInDock(appBundleName);
      let ret: boolean = DeliverUtil.isAppBundleNameFoundInDock('com.ohos.photos');
      expect(ret).assertFalse();
    });

    it('test_isDragLeaveDisabled', 0, () => {
      let isDragLeave: boolean = false;
      DeliverUtil.setIsDragLeaveDisabled(isDragLeave);
      let ret: boolean = DeliverUtil.isDragLeaveDisabled();
      expect(ret).assertFalse();
    });

    it('test_setIsDragLeaveDisabled', 0, () => {
      let isDragLeave: boolean = true;
      DeliverUtil.setIsDragLeaveDisabled(isDragLeave);
      let ret: boolean = DeliverUtil.isDragLeaveDisabled();
      expect(ret).assertTrue();
    });

    it('test_isRemoveDeliverApp', 0, () => {
      let bundleName = DeliverUtil.APPMARKET_BUNDLE_NAME;
      let result = DeliverUtil.isRemovedDeliverApp(bundleName);
      expect(result).assertTrue();
      result = DeliverUtil.isRemovedDeliverApp('com.deliver.iapps.appsss');
      expect(result).assertFalse();
    });

    it('test_isContainerPkg', 0, () => {
      let bundleName = DeliverUtil.DELIVER_APPSTORE_PKG;
      let result = DeliverUtil.isContainerPkg(bundleName);
      expect(result).assertTrue();
      result = DeliverUtil.isContainerPkg('com.deliver.iapps.appsss');
      expect(result).assertFalse();
    });

    it('test_isContainerFolder', 0, () => {
      let folderId = '17202412';
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.folderId = folderId;
      item.intent = '{"installSource":"com.ohos.abroad"}';
      DeliverUtil.setContainerFolderMapInDesktop(item);
      let ret: boolean = DeliverUtil.isContainerFolder(folderId);
      expect(ret).assertTrue();
      ret = DeliverUtil.isContainerFolder('12121');
      expect(ret).assertFalse();
    });

    it('test_isContainerItem', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.intent = '{"installSource":"com.ohos.abroad"}';
      let ret: boolean = DeliverUtil.isContainerItem(item.intent);
      expect(ret).assertTrue();
      item = new GridLayoutItemInfo();
      item.intent = '{"installSource":"com.ohos.abroad11"}';
      DeliverUtil.isContainerItem(item.intent);
      expect(ret).assertTrue();
    });

    it('test_setContainerFolderMap', 0, () => {
      let folderId = '17202412';
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.folderId = folderId;
      item.intent = '{"installSource":"com.ohos.abroad"}';
      DeliverUtil.setContainerFolderMapInDesktop(item);
      let ret: boolean = DeliverUtil.isContainerFolder(folderId);
      expect(ret).assertTrue();
      ret = DeliverUtil.isContainerFolder('12121');
      expect(ret).assertFalse();
    });

    it('test_copyDesktopOldDataToIntent', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.id = 0;
      item.intent = 'default';
      DeliverUtil.copyDesktopOldDataToIntent(item);
      let ret = true;
      expect(ret).assertTrue();
    });

    it('test_copyDockOldDataToIntent', 0, () => {
      let item: DockItemInfo = new DockItemInfo();
      item.id = 0;
      item.intent = 'default';
      DeliverUtil.copyDockOldDataToIntent(item);
      let ret = true;
      expect(ret).assertTrue();
    });

    it('test_getInstallSourceByIntent', 0, () => {
      let intent = '{"installSource":"com.ohos.abroad"}';
      let installSource = DeliverUtil.getInstallSourceByIntent(intent);
      expect(installSource).assertEqual('com.ohos.abroad');
    });

    it('test_isStartWaitHMContainerApp', 0, () => {
      let bundleName = "com.ohos.abroad";
      let ret = DeliverUtil.isStartWaitHMContainerApp(bundleName);
      expect(ret).assertFalse();
    });

    it('test_getAppItemByBundleName', 0, () => {
      let bundleName = "com.ohos.abroad";
      let appItem = DeliverUtil.getAppItemByBundleName(bundleName);
      expect(appItem).assertUndefined();
    });

    it('test_isContainerHapExist', 0, () => {
      let ret = DeliverUtil.isContainerHapExist();
      expect(ret).assertFalse();
    });

    it('test_removeWaitHMDownloadTask', 0, () => {
      let bundleName = "com.ohos.abroad";
      expect(DeliverUtil.removeWaitHMDownloadTask(bundleName) === undefined).assertTrue();
    });

    it('test_isCreateFolder_null', 0, () => {
      expect(DeliverUtil.isCreateFolder(undefined) === false).assertTrue();
    });

    it('test_isShowToast_1', 0, () => {
      DeliverUtil['isShowToastRepeat'] = false;
      expect(DeliverUtil.isShowToast() === true).assertInstanceOf('Boolean');
    });

    it('test_addAddIcon_1', 0, () => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const dockItemInfo: DockItemInfo = new DockItemInfo();
      let layoutViewModel: LayoutViewModel = LayoutViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(layoutViewModel, layoutViewModel.isSimpleLauncherMode);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc1: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isFolderItemValid);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc2: Function = mocker.mockFunc(NotHarmonyUtil, NotHarmonyUtil.isNotHarmonyFolderById);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      try {
        DeliverUtil.addAddIcon(dockItemInfo, '1');
      } catch (error) {
      }
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      dockItemInfo.layoutInfo = [];
      try {
        DeliverUtil.addAddIcon(dockItemInfo, '1');
      } catch (error) {
      }
      dockItemInfo.layoutInfo = [[gridLayoutItemInfo]];
      let mockFunc3: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerFolder);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc4: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(false);
      try {
        DeliverUtil.addAddIcon(dockItemInfo, '1');
      } catch (error) {
      }
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc5: Function =
        mocker.mockFunc(DeliverUtil['editModeState'], DeliverUtil['editModeState'].isInEditMode);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(true);
      try {
        expect(dockItemInfo).not().assertNull();
      } catch (error) {
      }
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc6: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isAddIcon);
      when(mockFunc6)(ArgumentMatchers.any).afterReturn(true);
      try {
        DeliverUtil.addAddIcon(dockItemInfo, '1');
      } catch (error) {
      }
      when(mockFunc6)(ArgumentMatchers.any).afterReturn(false);
      try {
        DeliverUtil.addAddIcon(dockItemInfo, '1');
      } catch (error) {
      }
      mocker.clear(layoutViewModel);
      mocker.clear(GridLayoutUtil);
      mocker.clear(NotHarmonyUtil);
      mocker.clear(DeliverUtil);
      mocker.clear(DeliverUtil['editModeState']);
      mocker.clearAll();
    });

    it('test_addAddIconToLayoutInfo_1', 0, () => {
      AppStorage.set('disappearLastAppData', {
        hiddenAppKeyName: '1',
        folderId: '1'
      });
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.keyName = '1'
      let layoutInfo: GridLayoutItemInfo[][] = [[gridLayoutItemInfo]];
      let layoutViewModel: LayoutViewModel = LayoutViewModel.getInstance();
      let folderModel: FolderModel = FolderModel.getInstance()
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(layoutViewModel, layoutViewModel.isSimpleLauncherMode);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc1: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerFolder);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc3: Function =
        mocker.mockFunc(DeliverUtil['editModeState'], DeliverUtil['editModeState'].isInEditMode);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      try {
        DeliverUtil.addAddIconToLayoutInfo(layoutInfo, '1', '1');
      } catch (error) {
      }
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(folderModel, folderModel.getFolderOpenLayout);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn({
        column: 1,
        row: 1
      });
      try {
        DeliverUtil.addAddIconToLayoutInfo(layoutInfo, '1', '1');
        DeliverUtil.addAddIconToLayoutInfo(layoutInfo, '1', '2');
      } catch (error) {
      }
      when(mockFunc2)(ArgumentMatchers.any).afterReturn({
        column: 1,
        row: 3
      });
      try {
        DeliverUtil.addAddIconToLayoutInfo(layoutInfo, '1', '1');
        DeliverUtil.addAddIconToLayoutInfo(layoutInfo, '1', '2');
      } catch (error) {
      }
      expect(gridLayoutItemInfo).not().assertNull();
      mocker.clear(layoutViewModel);
      mocker.clear(DeliverUtil);
      mocker.clear(folderModel);
      mocker.clear(DeliverUtil['editModeState']);
      mocker.clearAll();
    });

    it('test_delAddIcon_1', 0, () => {
      let layoutViewModel: LayoutViewModel = LayoutViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(layoutViewModel, layoutViewModel.isSimpleLauncherMode);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc1: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isFolderItemValid);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      try {
        DeliverUtil.delAddIcon({
          layoutInfo: []
        }, '');
        expect(layoutViewModel).not().assertNull();
      } catch (error) {
      }
      mocker.clear(layoutViewModel);
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    });

    it('test_delAddIconForOpenFolderData_1', 0, () => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let gridLayoutItemInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.layoutInfo = [[gridLayoutItemInfo1]];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isAddIcon);
      let mockFunc1: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.delAddIcon);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo);
      try {
        expect(DeliverUtil.delAddIconForOpenFolderData(gridLayoutItemInfo)).not().assertNull();
      } catch (error) {
      }
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      try {
        expect(DeliverUtil.delAddIconForOpenFolderData(gridLayoutItemInfo)).not().assertNull();
      } catch (error) {
      }
      mocker.clear(GridLayoutUtil);
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    });

    it('test_addAddIconForResidentList_1', 0, () => {
      let layoutViewModel: LayoutViewModel = LayoutViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(layoutViewModel, layoutViewModel.isSimpleLauncherMode);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc1: Function = mocker.mockFunc(NotHarmonyUtil, NotHarmonyUtil.isNotHarmonyFolderById);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      try {
        DeliverUtil.addAddIconForResidentList('1');
      } catch (error) {
      }
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      try {
        DeliverUtil.addAddIconForResidentList('1');
      } catch (error) {
      }
      expect(layoutViewModel).not().assertNull();
      mocker.clear(layoutViewModel);
      mocker.clear(NotHarmonyUtil);
      mocker.clearAll();
    });

    it('test_addAddIconForResidentList_2', 0, () => {
      AppStorage.set('residentList', [
        {
          appId: '1',
          layoutInfo: [
            {
              id: 1
            }
          ]
        }
      ]);
      let layoutViewModel: LayoutViewModel = LayoutViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(layoutViewModel, layoutViewModel.isSimpleLauncherMode);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc1: Function = mocker.mockFunc(NotHarmonyUtil, NotHarmonyUtil.isNotHarmonyFolderById);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isAddIcon);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(1);
      try {
        DeliverUtil.addAddIconForResidentList('1');
      } catch (error) {
      }
      expect(layoutViewModel).not().assertNull();
      mocker.clear(layoutViewModel);
      mocker.clear(NotHarmonyUtil);
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    });

    it('test_isMatchContainerHapExist_1', 0, () => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.bundleName = '1';
      gridLayoutItemInfo.intent = JSON.stringify({
        installSource: 'com.deliver.appstore.lite'
      })
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DeliverUtil, DeliverUtil['isdeliverHapExist']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc2: Function = mocker.mockFunc(DeliverUtil, DeliverUtil['isEasyAbroadExist']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      try {
        expect(DeliverUtil.isMatchContainerHapExist(gridLayoutItemInfo)).assertInstanceOf('Boolean');
        gridLayoutItemInfo.intent = JSON.stringify({
          installSource: 'com.ohos.abroad'
        });
        expect(DeliverUtil.isMatchContainerHapExist(gridLayoutItemInfo)).assertInstanceOf('Boolean');
        gridLayoutItemInfo.intent = JSON.stringify({
          installSource: 'nice'
        });
        expect(DeliverUtil.isMatchContainerHapExist(gridLayoutItemInfo)).assertInstanceOf('Boolean');
      } catch (error) {
      }
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    });

    it('test_delAddIconForResidentList_1', 0, () => {
      let dockItemInfo: DockItemInfo = new DockItemInfo();
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.typeId = 1000;
      dockItemInfo.layoutInfo = [[gridLayoutItemInfo]];
      DeliverUtil.delAddIconForResidentList([dockItemInfo], 0)
      expect(dockItemInfo).not().assertNull();
    });

    it('test_handleOnClicked_1', 0, () => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.intent = JSON.stringify({
        installSource: 'com.ohos.abroad'
      });
      gridLayoutItemInfo.folderId = '2'
      let dockItemInfo: DockItemInfo = new DockItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.getDeliverStartStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn('1001');
      let mockFunc1: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.verifyContainerAppIdentifier);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      try {
        DeliverUtil.handleOnClicked('1')
        DeliverUtil.setContainerFolderMapInDesktop(gridLayoutItemInfo);
        DeliverUtil.handleOnClicked('2')
      } catch (error) {
      }
      when(mockFunc)(ArgumentMatchers.any).afterReturn('1000');
      try {
        DeliverUtil.handleOnClicked('1')
        expect(dockItemInfo).not().assertNull();
      } catch (error) {
      }
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    });

    it('test_getTargetBundleName_1', 0, () => {
      const appItemInfo: AppItemInfo = new AppItemInfo()
      DeliverUtil['getTargetBundleName'](true);
      const appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(appItemInfo);
      try {
        expect(DeliverUtil['getTargetBundleName'](true)).assertEqual(DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME_REAL);
        expect(DeliverUtil['getTargetBundleName'](false)).assertEqual(DeliverUtil.DELIVER_APP_BUNDLE_NAME_REAL);
      } catch (error) {
      }
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        expect(DeliverUtil['getTargetBundleName'](true)).assertEqual(DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME);
        expect(DeliverUtil['getTargetBundleName'](false)).assertEqual(DeliverUtil.DELIVER_APP_BUNDLE_NAME);
      } catch (error) {
      }
      mocker.clear(appModel);
      mocker.clearAll();
    });

    it('test_isLastAppAddIcon_1', 0, () => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.layoutInfo = [[]];
      expect(DeliverUtil.isLastAppAddIcon(gridLayoutItemInfo)).assertFalse;
    });

    it('test_getAddIconGeometryId_1', 0, () => {
      const deliverUtil: DeliverUtil = new DeliverUtil();
      deliverUtil['addIconGeometryId '] = '1';
      expect(DeliverUtil.getAddIconGeometryId()).assertInstanceOf('String');
    });

    it('test_removeRecentSpecialApp_1', 0, () => {
      const sCBSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const deliverUtil: DeliverUtil = new DeliverUtil();
      try {
        DeliverUtil.removeRecentSpecialApp('good');
      } catch (error) {
      }
      expect(deliverUtil).not().assertNull();
      let mocker: MockKit = new MockKit();
      let mockFunc2: Function = mocker.mockFunc(ArrayUtils, ArrayUtils.isEmpty);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      try {
        DeliverUtil.removeRecentSpecialApp('com.deliver.iapps');
      } catch (error) {
      }
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      try {
        DeliverUtil.removeRecentSpecialApp('com.deliver.iapps');
      } catch (error) {
      }
      expect(sCBSceneSessionManager).not().assertNull();
      mocker.clear(ArrayUtils);
      mocker.clearAll();
    });

    it('test_translateFolderLayout_1', 0, () => {
      let folderModel: FolderModel = FolderModel.getInstance();
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.bundleName = '2';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderModel, folderModel.getFolderOpenLayout);
      when(mockFunc)(ArgumentMatchers.any).afterReturn({
        column: 1,
        row: 1
      });
      try {
        expect(DeliverUtil.translateFolderLayout([gridLayoutItemInfo])).not().assertNull();
      } catch (error) {
      }
      when(mockFunc)(ArgumentMatchers.any).afterReturn({
        column: 1,
        row: 2
      });
      try {
        expect(DeliverUtil.translateFolderLayout([gridLayoutItemInfo])).not().assertNull();
      } catch (error) {
      }
      mocker.clear(folderModel);
      mocker.clearAll();
    });

    it('test_translateFolderLayout_2', 0, () => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const folderModel: FolderModel = FolderModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(folderModel, folderModel.getFolderOpenLayout);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn({
        column: 1,
        row: 1,
        id: 2,
        layout: '1',
        name: '2',
        checked: true
      });
      try {
        expect(DeliverUtil.translateFolderLayout([gridLayoutItemInfo, gridLayoutItemInfo, gridLayoutItemInfo]))
          .not()
          .assertNull();
      } catch (error) {
      }
      when(mockFunc1)(ArgumentMatchers.any).afterReturn({
        column: 1,
        row: 1,
        id: 1,
        layout: '1',
        name: '2',
        checked: true
      });
      try {
        expect(DeliverUtil.translateFolderLayout([gridLayoutItemInfo, gridLayoutItemInfo, gridLayoutItemInfo]))
          .not()
          .assertNull();
      } catch (error) {
      }
      mocker.clear(folderModel);
      mocker.clearAll();
    });

    it('test_isContainerItem_1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        expect(DeliverUtil.isContainerItem('name')).assertInstanceOf('Boolean');
      } catch (error) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_setInstallSourceAndIntent_1', 0, () => {
      let appItemInfo: AppItemInfo = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        DeliverUtil.setInstallSourceAndIntent(appItemInfo, 'name');
        expect(appItemInfo).not().assertNull();
      } catch (error) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_getContainerFolderName_1', 0, () => {
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.installSource = 'com.ohos.abroad';
      expect(DeliverUtil.getContainerFolderName(appItemInfo)).assertInstanceOf('String');
    });

    it('test_getContainerFolderName_2', 0, () => {
      const appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.installSource = '100000';
      appItemInfo.callerName = 'com.ohos.dataclone';
      expect(DeliverUtil.getContainerFolderName(appItemInfo)).assertEqual('${app_others}');
    });

    it('test_setContainerFolderMapInDesktop_1', 0, () => {
      try {
        DeliverUtil.setContainerFolderMapInDesktop(null);
        let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridLayoutItemInfo.folderId = 'niceName';
        gridLayoutItemInfo.intent = JSON.stringify({
          installSource: ''
        });
        DeliverUtil.setContainerFolderMapInDesktop(gridLayoutItemInfo);
        expect(gridLayoutItemInfo).not().assertNull();
      } catch (err) {
        console.log(JSON.stringify(err));
      }
    });

    it('test_setContainerFolderMapInDock_1', 0, () => {
      try {
        let dockItemInfo: DockItemInfo = new DockItemInfo();
        dockItemInfo.appId = 'someTime';
        DeliverUtil.setContainerFolderMapInDock(null);
        dockItemInfo.intent = JSON.stringify({
          installSource: 'goodDay'
        });
        DeliverUtil.setContainerFolderMapInDock(dockItemInfo);
        expect(dockItemInfo).not().assertNull();
      } catch (err) {
        console.log(JSON.stringify(err));
      }
    });

    it('test_isHaveDeliverApps_1', 0, () => {
      try {
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        try {
          DeliverUtil['containerFolderMap'].set('someTime', 'good');
          expect(DeliverUtil.isHaveDeliverApps()).assertInstanceOf('Boolean');
        } catch (error) {
        }
        mocker.clear(DeliverUtil);
        mocker.clearAll();
      } catch (err) {
        console.log(JSON.stringify(err));
      }
    });

    it('test_getCloneGridLayoutItemIntent_1', 0, () => {
      const legacyInfo: LegacyInfo = new LegacyInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        expect(DeliverUtil.getCloneGridLayoutItemIntent(legacyInfo, '1', '1')).assertInstanceOf('String');
      } catch (error) {
      }
      mocker.clear(CommonUtils);
      mocker.clearAll();
    });

    it('test_getCloneGridLayoutItemIntent_2', 0, () => {
      const legacyInfo: LegacyInfo = new LegacyInfo();
      expect(DeliverUtil.getCloneGridLayoutItemIntent(legacyInfo, '1', '1', 2)).assertInstanceOf('String');
    });


    it('test_isContainerAppUninstallAble_1', 0, () => {
      const intent: string = JSON.stringify({
        installSource: 'com.deliver.appstore.lite11'
      });
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerItem);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      try {
        expect(DeliverUtil.isContainerAppUninstallAble(intent, true)).assertInstanceOf('Boolean');
      } catch (error) {
      }
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    });


    it('test_isContainerAppUninstallAble_2', 0, () => {
      const intent: string = JSON.stringify({
        nameStr: '1'
      })
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc2: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.getDeliverStartStatus);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(DeliverUtil.DELIVER_START_FINISHED_CODE);
      try {
        expect(DeliverUtil.isContainerAppUninstallAble(intent, true)).assertTrue();
        expect(DeliverUtil.isContainerAppUninstallAble(intent, false)).assertFalse();
      } catch (error) {
      }
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    });

    it('test_getContainerFolder_1', 0, () => {
      try {
        expect(DeliverUtil.getContainerFolder('')).assertInstanceOf('String');
        DeliverUtil['containerFolderMap'].set('name', '1');
        expect(DeliverUtil.getContainerFolder('name')).assertInstanceOf('String');
      } catch (err) {
        console.log(JSON.stringify(err));
      }
    });

    it('test_getAppItemByBundleName_1', 0, () => {
      let launchLayoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(launchLayoutCacheManager, launchLayoutCacheManager.getAllSameBundleNameAppItem);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([1]);
      try {
        expect(DeliverUtil.getAppItemByBundleName('1')).not().assertNull();
      } catch (error) {
      }
      mocker.clear(launchLayoutCacheManager);
      mocker.clearAll();
    });

    it('test_isContainerHapExist_1', 0, () => {
      expect(DeliverUtil.isContainerHapExist('com.deliver.appstore.lite')).assertInstanceOf('Boolean');
      expect(DeliverUtil.isContainerHapExist('com.ohos.abroad')).assertInstanceOf('Boolean');
    });

    it('test_isContainerHapExist_2', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DeliverUtil, DeliverUtil['isdeliverHapExist']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(DeliverUtil, DeliverUtil['isEasyAbroadExist']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      try {
        expect(DeliverUtil.isContainerHapExist(DeliverUtil.DELIVER_APPSTORE_PKG)).assertFalse();
        expect(DeliverUtil.isContainerHapExist(DeliverUtil.ABROAD_APP_PKG)).assertFalse();
        expect(DeliverUtil.isContainerHapExist(DeliverUtil.DELIVER_APPSTORE_CLASS)).assertFalse();
      } catch (error) {
      }
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      try {
        expect(DeliverUtil.isContainerHapExist(DeliverUtil.DELIVER_APPSTORE_CLASS)).assertTrue();
      } catch (error) {
      }
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    });

    it('test_cancelDownloadTask_1', 0, () => {
      const appInstallUtil: AppInstallUtils = AppInstallUtils.getInstance();
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      DeliverUtil['cancelDownloadTask'](gridLayoutItemInfo);
      gridLayoutItemInfo.appStatus = 9;
      gridLayoutItemInfo.bundleName = '1';
      gridLayoutItemInfo.intent = JSON.stringify({
        requestBundleName: '1'
      });
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appInstallUtil, appInstallUtil.cancelTask);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn('1');
      try {
        DeliverUtil['cancelDownloadTask'](gridLayoutItemInfo);
        expect(gridLayoutItemInfo).not().assertNull();
      } catch (error) {
      }
      mocker.clear(appInstallUtil);
      mocker.clearAll();
    });

    it('test_isDisableOperationsOnFolder_1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      try {
        expect(DeliverUtil.isDisableOperationsOnFolder('1', 'good')).assertTrue();
      } catch (error) {
      }
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      try {
        expect(DeliverUtil.isDisableOperationsOnFolder('1', 'good')).assertFalse();
      } catch (error) {
      }
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    });

    it('test_refreshFolderAppsInDesktop_1', 0, () => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      const appItemInfo: AppItemInfo = new AppItemInfo();
      const appModel: AppModel = AppModel.getInstance();
      const folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppList);
      let mockFunc2: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectAllFoldersWithAppCheck);
      let mockFunc3: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.translateFolderLayout);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn([appItemInfo]);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([gridLayoutItemInfo]);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn([[gridLayoutItemInfo]]);
      try {
        DeliverUtil['containerFolderMap'].clear();
        DeliverUtil['containerFolderMap'].set('goodName', 'goodName');
      } catch (error) {
      }
      gridLayoutItemInfo.layoutInfo = undefined;
      let mockFunc4: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectGridLayoutItemByFolderId);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo);
      try {
       DeliverUtil.refreshFolder();
      } catch (error) {
      }
      gridLayoutItemInfo.layoutInfo = [[gridLayoutItemInfoOther]];
      try {
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo);
      DeliverUtil.refreshFolder();
      } catch (error) {
      }
      expect(appModel).not().assertNull();
      mocker.clear(appModel);
      mocker.clear(folderLayoutCacheManager);
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    });

    it('test_refreshFolderAppsInDock_1', 0, (done: Function) => {
      try {
        const appModel: AppModel = AppModel.getInstance();
        const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        const dockItemInfo: DockItemInfo = new DockItemInfo();
        const appItemInfo: AppItemInfo = new AppItemInfo();
        let mocker: MockKit = new MockKit();
        let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(undefined);
        let mockFunc2: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.translateFolderLayout);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn([[GridLayoutItemInfo]]);
        try {
          DeliverUtil['containerFolderMap'].clear();
          DeliverUtil['containerFolderMap'].set('good', 'good');
        } catch (error) {
        }
        dockItemInfo.appId = 'good1';
        dockItemInfo.bundleName = '99999';
        AppStorage.set('residentList', [dockItemInfo]);
        DeliverUtil.refreshFolderAppsInDock();
        dockItemInfo.appId = 'good';
        AppStorage.set('residentList', [dockItemInfo]);
        DeliverUtil.refreshFolderAppsInDock();
        dockItemInfo.layoutInfo = [[gridLayoutItemInfo]];
        AppStorage.set('residentList', [dockItemInfo]);
        try {
          DeliverUtil.refreshFolderAppsInDock();
        } catch (error) {
        }
        expect(appModel).not().assertNull();
        mocker.clear(appModel);
        mocker.clear(DeliverUtil);
        mocker.clearAll();
        done();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    });

    it('test_isContainerFolder_1', 0, () => {
      DeliverUtil['containerFolderMap'].clear();
      DeliverUtil['containerFolderMap'].set('nameStr', 'good');
      expect(DeliverUtil.isContainerFolder('good', 'nameStr')).assertTrue();
    });

    it('test_getInstallSourceByBundleName_1', 0, () => {
      expect(DeliverUtil['getInstallSourceByBundleName']('com.ohos.abroad')).assertInstanceOf('String');
    });

    it('test_getContainerFolderNameForDialog_1', 0, () => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.intent = JSON.stringify({
        installSource: 'com.deliver.appstore.lite1'
      });
      gridLayoutItemInfo.callerName = 'com.ohos.dataclone';
      expect(DeliverUtil.getContainerFolderNameForDialog(gridLayoutItemInfo)).assertInstanceOf('String');
      gridLayoutItemInfo.callerName = 'com.ohos.dataclone_1';
      expect(DeliverUtil.getContainerFolderNameForDialog(gridLayoutItemInfo)).assertInstanceOf('String');
    });

    it('test_getInstallSourceByIntent_1', 0, () => {
      const intent: string = JSON.stringify({
        installSource: '1'
      });
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      expect(DeliverUtil.getInstallSourceByIntent(intent)).assertInstanceOf('String');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_setContainerAppNameCache_1', 0, () => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const intent: string = '1'
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      try {
        DeliverUtil.setContainerAppNameCache(gridLayoutItemInfo, intent);
        expect(gridLayoutItemInfo).not().assertNull();
      } catch (error) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_isStartWaitHMContainerApp_1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.getAppItemByBundleName);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc2: Function = mocker.mockFunc(DeliverUtil, DeliverUtil['judgeWaitHMAndMaskStatus']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc3: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerItem);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc4: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.getInstallSourceByIntent);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn('1');
      let mockFunc5: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerHapExist);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(true);
      try {
        expect(DeliverUtil.isStartWaitHMContainerApp('intent')).assertTrue();
      } catch (error) {
      }
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(false);
      try {
        expect(DeliverUtil.isStartWaitHMContainerApp('intent')).assertFalse();
      } catch (error) {
      }
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    });

    it('test_judgeWaitHMAndMaskStatus_1', 0, () => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.appStatus = AppStatus.WAIT_FOR_HARMONY;
      gridLayoutItemInfo.bundleName = '1';
      gridLayoutItemInfo.intent = JSON.stringify({
        maskState: 2
      });
      expect(DeliverUtil['judgeWaitHMAndMaskStatus'](gridLayoutItemInfo)).assertTrue();
    });

    it('test_removeWaitHMDownloadTask', 0, () => {
      let bundleName = "com.ohos.abroad";
      expect(DeliverUtil.removeWaitHMDownloadTask(bundleName) === undefined).assertTrue();
    });

    it('test_removeWaitHMDownloadTask_1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        DeliverUtil.removeWaitHMDownloadTask('com.deliver.appstore.lite');
      } catch (error) {
      }
      expect(mocker).not().assertNull();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_removeWaitHMDownloadTask_2', 0, () => {
      try {
        const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        const dockItemInfo: DockItemInfo = new DockItemInfo();
        const folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
        let mocker: MockKit = new MockKit();
        let mockFunc1: Function =
          mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectGridLayoutItemByFolderId);
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(undefined)
        try {
          DeliverUtil['containerFolderMap'].clear();
          DeliverUtil['containerFolderMap'].set('com.deliver.appstore.lite', 'com.deliver.appstore.lite');
        } catch (error) {
        }
        dockItemInfo.appId = 'com.deliver.appstore.lite';
        AppStorage.set('residentList', [dockItemInfo]);
        DeliverUtil.removeWaitHMDownloadTask('com.deliver.iapps');
        dockItemInfo.appId = 'com.deliver.appstore.lite_1';
        AppStorage.set('residentList', [dockItemInfo]);
        DeliverUtil.removeWaitHMDownloadTask('com.deliver.iapps');
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo);
        try {
          DeliverUtil.removeWaitHMDownloadTask('com.deliver.iapps');
        } catch (error) {
        }
        expect(mocker).not().assertNull();
        mocker.clear(folderLayoutCacheManager);
        mocker.clear(CheckEmptyUtils);
        mocker.clearAll();
      } catch (err) {
        console.log(JSON.stringify(err));
      }
    })

    it('test_removeContainerFolder', 0, () => {
      let bundleName = "com.ohos.abroad";
      expect(DeliverUtil.removeContainerFolder(bundleName) === undefined).assertTrue();
    });

    it('test_isCustomizedFolder', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(NotHarmonyUtil, NotHarmonyUtil.isNotHarmonyFolderById);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let ret = DeliverUtil.isCustomizedFolder(false, CommonConstants.TYPE_FOLDER, '1');
      expect(ret).assertTrue();
      mocker.clear(CheckEmptyUtils);
    })

    it('test_removeContainerFolder_1', 0, () => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const folderData: FolderData = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeliverUtil, DeliverUtil['checkRemoveContainerFolder']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc1: Function = mocker.mockFunc(folderData, folderData['getFolderItemByFolderId']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        DeliverUtil.removeContainerFolder('1');
      } catch (error) {
      }
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo);
      let mockFunc2: Function = mocker.mockFunc(DeliverUtil, DeliverUtil['isdeliverPkg']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      try {
        DeliverUtil.removeContainerFolder('1');
      } catch (error) {
      }
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      try {
        DeliverUtil.removeContainerFolder('1');
      } catch (error) {
      }
      expect(gridLayoutItemInfo).not().assertNull();
      mocker.clear(DeliverUtil);
      mocker.clear(folderData);
      mocker.clearAll();
    });

    it('test_checkRemoveContainerFolder_1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeliverUtil, DeliverUtil['getDeliverStartStatus']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(DeliverUtil.DELIVER_APP_BUNDLE_NAME);
      let mockFunc1: Function = mocker.mockFunc(DeliverUtil, DeliverUtil['isEasyAbroadPkg']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc2: Function = mocker.mockFunc(DeliverUtil, DeliverUtil['isdeliverPkg']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      try {
        expect(DeliverUtil['checkRemoveContainerFolder']('1')).assertFalse();
      } catch (error) {
      }
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    });

    it('test_deleteCacheDefaultAppSort_1', 0, () => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      DeliverUtil['checkRemoveContainerFolder'](DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME);
      DeliverUtil['checkRemoveContainerFolder'](DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME_REAL);
      expect(gridLayoutItemInfo).not().assertNull();
    });

    it('test_getInstallSourceByGridLayoutInfoOrFolder_1', 0, () => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      DeliverUtil['containerFolderMap'].set(DeliverUtil.ABROAD_APP_PKG, DeliverUtil.ABROAD_APP_PKG);
      expect(DeliverUtil['getInstallSourceByGridLayoutInfoOrFolder'](gridLayoutItemInfo, DeliverUtil.ABROAD_APP_PKG))
        .assertEqual(DeliverUtil.ABROAD_APP_PKG);
      expect(DeliverUtil['getInstallSourceByGridLayoutInfoOrFolder'](gridLayoutItemInfo,
        DeliverUtil.DELIVER_APPSTORE_PKG)).assertEqual(DeliverUtil.DELIVER_APPSTORE_PKG);
    })

    it('test_startdeliverAutoEnterLakeAbility_1', 0, () => {
      let bundleName: string = 'bundleName';
      let appIcon: string = 'appIcon';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeliverUtil, DeliverUtil['getRealIconAndScale']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(appIcon);
      let mockFunc1: Function = mocker.mockFunc(StartAbilityUtil, StartAbilityUtil['StartAbilityUtil']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing();
      try {
        DeliverUtil.startdeliverAutoEnterLakeAbility(bundleName, appIcon);
      } catch (error) {
      }
      expect(appIcon).not().assertNull();
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    });

    it('test_getRealIconAndScale_1', 0, () => {
      let path: string = 'path';
      let imagePixelMap: image.PixelMap | null = null;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeliverUtil, DeliverUtil['loadImageFromDisk']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(imagePixelMap);
      expect(DeliverUtil['getRealIconAndScale'](path)).assertEqual('');
      expect(imagePixelMap).assertNull();
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    });

    it('test_loadImageFromDisk_1', 0, () => {
      let path: string = '';
      let format: image.PixelMapFormat = image.PixelMapFormat.RGBA_8888;
      expect(DeliverUtil['loadImageFromDisk'](path, format)).assertEqual('');
    });

    it('test_getFolderTypeByFolderId', 0, () => {
      let result1 = DeliverUtil.getFolderTypeByFolderId('');
      expect(result1).assertEqual(DeliverUtil.FOLDER_TYPE_NOTFOLDER);

      let result2 = DeliverUtil.getFolderTypeByFolderId('0');
      expect(result2).assertEqual(DeliverUtil.FOLDER_TYPE_COMMON);
    });

    it('test_getAppType', 0, () => {
      let item1 = null;
      let result1 = DeliverUtil.getAppType(item1);
      expect(result1).assertEqual(DeliverUtil.APPTYPE_TYPE_NONE);

      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.appStatus = AppStatus.INSTALLED;
      item2.intent = '{"installSource":"com.deliver.appstore.lite"}';
      let result2 = DeliverUtil.getAppType(item2);
      expect(result2).assertEqual(DeliverUtil.APPTYPE_TYPE_DELIVER);

      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.appStatus = AppStatus.INSTALLED;
      item3.intent = '{"installSource":"com.ohos.abroad"}';
      let result3 = DeliverUtil.getAppType(item3);
      expect(result3).assertEqual(DeliverUtil.APPTYPE_TYPE_EASY);

      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.appStatus = AppStatus.WAIT_FOR_HARMONY;
      let result4 = DeliverUtil.getAppType(item4);
      expect(result4).assertEqual(DeliverUtil.APPTYPE_TYPE_NOTHARMONY);

      let item5: GridLayoutItemInfo = new GridLayoutItemInfo();
      item5.appStatus = AppStatus.INSTALLED;
      let result5 = DeliverUtil.getAppType(item5);
      expect(result5).assertEqual(DeliverUtil.APPTYPE_COMMON);
    });

    it('test_leavingLakeStartAppGalleryDetail_1', 0, () => {
      let hapBundleName = 'com.luyun.everydaydiary';
      let packageName = 'com.luyun.diary';
      expect(DeliverUtil.leavingLakeStartAppGalleryDetail(hapBundleName, packageName) === undefined).assertTrue();
    });

    it('test_leavingLakeStartAppGalleryDetail_2', 0, () => {
      let hapBundleName = 'com.demo.hap';
      let packageName = 'com.demo';
      expect(DeliverUtil.leavingLakeStartAppGalleryDetail(hapBundleName, packageName) === undefined).assertTrue();
    });

    it('test_checkInstallSource_1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFuncSupportDeliver: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(mockFuncSupportDeliver)(ArgumentMatchers.any).afterReturn(true);
      let mockFuncSupportAppType: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportAppType);
      when(mockFuncSupportAppType)(ArgumentMatchers.any).afterReturn(true);
      let gridLayoutInfo = new GridLayoutItemInfo();
      gridLayoutInfo.bundleName = 'com.demo.test';
      expect(DeliverUtil.checkInstallSource(gridLayoutInfo, true) === undefined).assertTrue();
      mocker.clear(mockFuncSupportDeliver);
      mocker.clear(mockFuncSupportAppType);
      mocker.clearAll();
    });

    it('test_checkInstallSource_2', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFuncSupportDeliver: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      when(mockFuncSupportDeliver)(ArgumentMatchers.any).afterReturn(true);
      let mockFuncSupportAppType: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportAppType);
      when(mockFuncSupportAppType)(ArgumentMatchers.any).afterReturn(true);
      let appItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.demo.test';
      expect(DeliverUtil.checkInstallSource(appItemInfo, false) === undefined).assertTrue();
      mocker.clear(mockFuncSupportDeliver);
      mocker.clear(mockFuncSupportAppType);
      mocker.clearAll();
    });

    it('test_canFolderItemDragOut', 0, () => {
      let folderId = '17202412';
      let item = new GridLayoutItemInfo();
      item.folderId = folderId;
      item.intent = '{"installSource":"com.ohos.abroad"}';
      DeliverUtil.setContainerFolderMapInDesktop(item);
      let ret: boolean = DeliverUtil.canFolderItemDragOut(folderId, 'com.deliver.appstore');
      expect(ret).assertFalse();
      ret = DeliverUtil.canFolderItemDragOut('17202412', 'com.deliver.appstore');
      expect(ret).assertFalse();
      ret = DeliverUtil.canFolderItemDragOut('17202433', 'com.deliver.appstore');
      expect(ret).assertFalse();
      ret = DeliverUtil.canFolderItemDragOut('17212433', 'com.deliver.appstore');
      expect(ret).assertFalse();
    });

    it('test_canFolderItemDragOut_1', 0, () => {
      let folderId = '17202412';
      let item = new GridLayoutItemInfo();
      item.folderId = folderId;
      item.intent = '{"installSource":"com.deliver.appstore.lite"}';
      DeliverUtil.setContainerFolderMapInDesktop(item);
      let ret: boolean = DeliverUtil.canFolderItemDragOut(folderId, 'com.deliver.appstore');
      expect(ret).assertFalse();
      ret = DeliverUtil.canFolderItemDragOut('17202433', 'com.deliver.appstore');
      expect(ret).assertFalse();
      ret = DeliverUtil.canFolderItemDragOut('17212433', 'com.deliver.appstore');
      expect(ret).assertFalse();
    });

    it('test_canFolderItemDragOut_2', 0, () => {
      let folderId = '17202412';
      let item = new GridLayoutItemInfo();
      item.folderId = folderId;
      item.intent = '{"installSource":"com.deliver.appstore.lite"}';
      DeliverUtil.setContainerFolderMapInDesktop(item);
      let ret: boolean = DeliverUtil.canFolderItemDragOut(folderId, 'com.deliver.appstore');
      expect(ret).assertFalse();
      item = new GridLayoutItemInfo();
      item.folderId = '17202413';
      item.intent = '{"installSource":"com.ohos.abroad"}';
      DeliverUtil.setContainerFolderMapInDesktop(item);
      ret = DeliverUtil.canFolderItemDragOut('17202413', 'com.deliver.appstore');
      expect(ret).assertFalse();
      ret = DeliverUtil.canFolderItemDragOut('17202433', 'com.deliver.appstore');
      expect(ret).assertFalse();
      ret = DeliverUtil.canFolderItemDragOut('17212433', 'com.deliver.appstore');
      expect(ret).assertFalse();
    });

    it('test_verifyContainerAppIdentifier_1', 0, () => {
      let result1 = DeliverUtil.verifyContainerAppIdentifier('');
      expect(result1).assertFalse();

      let result2 = DeliverUtil.verifyContainerAppIdentifier(DeliverUtil.DELIVER_APP_BUNDLE_NAME);
      expect(result2).assertFalse();
    });

    it('test_verifyContainerAppIdentifier_2', 0, () => {
      let result1 = DeliverUtil.verifyContainerAppIdentifier(undefined);
      expect(result1).assertFalse();

      let result2 = DeliverUtil.verifyContainerAppIdentifier(DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME);
      expect(result2).assertFalse();
    });

    it('test_handleOnClicked_2', 0, () => {
      let dockItemInfo: DockItemInfo = new DockItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.getDeliverStartStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn('888');
      let mockFunc1: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.verifyContainerAppIdentifier);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      try {
        DeliverUtil.handleOnClicked('111')
        let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridLayoutItemInfo.folderId = '33333333';
        gridLayoutItemInfo.intent = JSON.stringify({
          installSource: 'com.deliver.appstore.lite'
        });
        DeliverUtil.setContainerFolderMapInDesktop(gridLayoutItemInfo);
        DeliverUtil.handleOnClicked('33333333')
      } catch (error) {
      }
      when(mockFunc)(ArgumentMatchers.any).afterReturn('1000');
      try {
        DeliverUtil.handleOnClicked('111')
        expect(dockItemInfo).not().assertNull();
      } catch (error) {
      }
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    });

    it('test_getTargetBundleName_2', 0, () => {
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      let appInfo: AppItemInfo = new AppItemInfo()
      DeliverUtil['getTargetBundleName'](true);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(appInfo);
      let isEasyAbroadFolder: boolean = true;
      try {
        expect(DeliverUtil['getTargetBundleName'](isEasyAbroadFolder)).assertEqual('com.ohos.abroad');
        expect(DeliverUtil['getTargetBundleName'](!isEasyAbroadFolder)).assertEqual('com.deliver.tong');
      } catch (error) {
      }
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        expect(DeliverUtil['getTargetBundleName'](isEasyAbroadFolder)).assertEqual('com.ohos.abroadHarmony.temp');
        expect(DeliverUtil['getTargetBundleName'](!isEasyAbroadFolder)).assertEqual('com.deliver.iapps');
      } catch (error) {
      }
      mocker.clear(appModel);
      mocker.clearAll();
    });

    it('test_getAddIconGeometryId_2', 0, () => {
      let deliverUtil: DeliverUtil = new DeliverUtil();
      deliverUtil['addIconGeometryId'] = 'id1';
      expect(DeliverUtil.getAddIconGeometryId()).assertInstanceOf('String');

      let instance: DeliverUtil = new DeliverUtil();
      instance['addIconGeometryId'] = 'id22';
      expect(DeliverUtil.getAddIconGeometryId()).assertInstanceOf('String');

      let instance2: DeliverUtil = new DeliverUtil();
      instance2['addIconGeometryId'] = 'id33';
      expect(DeliverUtil.getAddIconGeometryId()).assertInstanceOf('String');

      let instance3: DeliverUtil = new DeliverUtil();
      instance3['addIconGeometryId'] = 'id44';
      expect(DeliverUtil.getAddIconGeometryId()).not().assertNull();

      let ret = DeliverUtil.getAddIconGeometryId();
      expect(ret).not().assertNull();
    });

    it('test_removeRecentSpecialApp_2', 0, () => {
      try {
        DeliverUtil.removeRecentSpecialApp('wwwsss');
      } catch (error) {
      }
      let deliverUtil: DeliverUtil = new DeliverUtil();
      expect(deliverUtil).not().assertNull();
      let mocker: MockKit = new MockKit();
      let func: Function = mocker.mockFunc(ArrayUtils, ArrayUtils.isEmpty);
      when(func)(ArgumentMatchers.any).afterReturn(true);
      try {
        DeliverUtil.removeRecentSpecialApp('com.ohos.abroad');
      } catch (error) {
      }
      when(func)(ArgumentMatchers.any).afterReturn(false);
      try {
        DeliverUtil.removeRecentSpecialApp('com.deliver.iapps');
      } catch (error) {
      }
      let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(scbSceneSessionManager).not().assertNull();

      let bundleName1: string = 'com.deliver.iapps';
      expect(DeliverUtil['removeRecentSpecialApp'](bundleName1) === undefined).assertTrue();

      let bundleName2: string = 'com.deliver.tong';
      expect(DeliverUtil['removeRecentSpecialApp'](bundleName2) === undefined).assertTrue();
      mocker.clear(ArrayUtils);
      mocker.clearAll();
    });

    it('test_translateFolderLayout_2', 0, () => {
      let model: FolderModel = FolderModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(model, model.getFolderOpenLayout);
      when(mockFunc)(ArgumentMatchers.any).afterReturn({
        column: 3,
        row: 3
      });
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.bundleName = '11';
      try {
        expect(DeliverUtil.translateFolderLayout([gridLayoutItemInfo])).not().assertNull();
      } catch (error) {
      }
      when(mockFunc)(ArgumentMatchers.any).afterReturn({
        column: 2,
        row: 4
      });
      let gridLayoutItemInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo2.bundleName = '44';
      try {
        expect(DeliverUtil.translateFolderLayout([gridLayoutItemInfo2])).not().assertNull();
      } catch (error) {
      }
      mocker.clear(model);
      mocker.clearAll();
    });

    it('test_translateFolderLayout_3', 0, () => {
      let folderModel: FolderModel = FolderModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderModel, folderModel.getFolderOpenLayout);
      when(mockFunc)(ArgumentMatchers.any).afterReturn({
        id: 3,
        layout: '2',
        name: '233',
        column: 2,
        row: 3,
        checked: true
      });
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      try {
        expect(DeliverUtil.translateFolderLayout([itemInfo, itemInfo, itemInfo]))
          .not()
          .assertNull();
      } catch (error) {
      }
      when(mockFunc)(ArgumentMatchers.any).afterReturn({
        id: 4,
        layout: '1',
        name: '2',
        column: 1,
        row: 1,
        checked: true
      });
      let itemInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      try {
        expect(DeliverUtil.translateFolderLayout([itemInfo2, itemInfo2, itemInfo2]))
          .not()
          .assertNull();
      } catch (error) {
      }
      mocker.clear(folderModel);
      mocker.clear(itemInfo);
      mocker.clear(itemInfo2);
      mocker.clearAll();
    });

    it('test_isContainerItem_2', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        expect(DeliverUtil.isContainerItem('name')).assertInstanceOf('Boolean');
      } catch (error) {
      }
      try {
        expect(DeliverUtil.isContainerItem('name2')).not().assertEqual('sss');
      } catch (error) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_setInstallSourceAndIntent_2', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let appItemInfo: AppItemInfo = new AppItemInfo();
      try {
        DeliverUtil.setInstallSourceAndIntent(appItemInfo, `{'installSource:com.deliver.appstore.lite'}`);
        expect(appItemInfo).not().assertNull();
      } catch (error) {
      }
      let appItemInfo2: AppItemInfo = new AppItemInfo();
      try {
        DeliverUtil.setInstallSourceAndIntent(appItemInfo2, `{'installSource:com.ohos.abroad'}`);
      } catch (error) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('test_getContainerFolderName_3', 0, () => {
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.installSource = 'com.xxx.abroad.xxx';
      expect(DeliverUtil.getContainerFolderName(appItemInfo)).assertInstanceOf('String');
    });

    it('test_getContainerFolderName_4', 0, () => {
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.installSource = '10086';
      appItemInfo.callerName = 'com.deliver.tong';
      expect(DeliverUtil.getContainerFolderName(appItemInfo)).assertEqual('${app_others}');

      let appItemInfo2: AppItemInfo = new AppItemInfo();
      appItemInfo2.installSource = 'com.deliver.appstore.lite';
      appItemInfo2.callerName = 'com.ohos.dataclone';
      expect(DeliverUtil.getContainerFolderName(appItemInfo2)).not().assertEqual('com.xxx');
    });

    it('test_setContainerFolderMapInDesktop_2', 0, () => {
      try {
        DeliverUtil.setContainerFolderMapInDesktop(null);
        let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridLayoutItemInfo.folderId = '14765231465';
        gridLayoutItemInfo.intent = JSON.stringify({
          installSource: 'com.deliver.appstore.lite'
        });
        DeliverUtil.setContainerFolderMapInDesktop(gridLayoutItemInfo);
        expect(gridLayoutItemInfo).not().assertNull();
      } catch (err) {
        console.log(JSON.stringify(err));
      }

      try {
        let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        itemInfo.intent = JSON.stringify({
          installSource: 'com.deliver.appstore.lite'
        });
        itemInfo.folderId = 'folderId123546';
        itemInfo.infoName = '456';
        DeliverUtil.setContainerFolderMapInDesktop(itemInfo);
      } catch (error) {
        console.log(JSON.stringify(error));
      }
    });

    it('test_setContainerFolderMapInDock_2', 0, () => {
      try {
        DeliverUtil.setContainerFolderMapInDock(null);
        let dockItemInfo: DockItemInfo = new DockItemInfo();
        dockItemInfo.appId = 'appId475621';
        dockItemInfo.intent = JSON.stringify({
          installSource: 'com.deliver.appstore.lite'
        });
        DeliverUtil.setContainerFolderMapInDock(dockItemInfo);
        expect(dockItemInfo).assertInstanceOf('DockItemInfo');
        expect(dockItemInfo).not().assertNull();
      } catch (err) {
        console.log(JSON.stringify(err));
      }
    });

    it('test_isHaveDeliverApps_2', 0, () => {
      try {
        try {
          DeliverUtil['containerFolderMap'].set('com.ohos.abroad', 'folderId125463');
          expect(DeliverUtil.isHaveDeliverApps()).assertInstanceOf('Boolean');
          expect(DeliverUtil['containerFolderMap']).not().assertNull();
        } catch (error) {
        }
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        mocker.clear(DeliverUtil);
        mocker.clearAll();
      } catch (err) {
        console.log(JSON.stringify(err));
      }
    });

    it('test_getCloneGridLayoutItemIntent_3', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let legacyInfo: LegacyInfo = new LegacyInfo();
        expect(DeliverUtil.getCloneGridLayoutItemIntent(legacyInfo, 'waitForSystemKey1', 'enterpriseLink1'))
          .assertInstanceOf('String');
      } catch (error) {
      }
      mocker.clear(CommonUtils);
      mocker.clearAll();
    });

    it('test_getCloneGridLayoutItemIntent_4', 0, () => {
      try {
        let legacyInfo: LegacyInfo = new LegacyInfo();
        expect(DeliverUtil.getCloneGridLayoutItemIntent(legacyInfo, 'waitForSystemKey4', 'enterpriseLink4'))
          .assertInstanceOf('String');
      } catch (error) {
      }
    });

    it('test_isContainerAppUninstallAble_3', 0, () => {
      try {
        let intent: string = JSON.stringify({
          installSource: 'com.ohos.abroad123'
        });
        let res = DeliverUtil.isContainerAppUninstallAble(intent, true);
        expect(res).assertInstanceOf('Boolean');
      } catch (error) {
      }
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerItem);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    });

      it('test_checkFolderbyInstallSource_01', 0, () => {
        try {
          let result: boolean = DeliverUtil.checkFolderbyInstallSource(dhItemInfos[0]);
          expect(result).assertEqual(false);
        } catch (e) {
          expect(JSON.stringify(e)).assertInstanceOf('String');
        }
      });

      it('test_checkFolderbyInstallSource_02', 0, () => {
        try {
          let folderItem: GridLayoutItemInfo = initFolderGridLayoutItemInfo();
          let result: boolean = DeliverUtil.checkFolderbyInstallSource(folderItem);
          expect(result).assertEqual(false);
        } catch (e) {
          expect(JSON.stringify(e)).assertInstanceOf('String');
        }
      });

      it('test_checkFolderbyInstallSource_03', 0, () => {
        try {
          let result: boolean = DeliverUtil.checkFolderbyInstallSource(dhItemInfos[4]);
          expect(result).assertEqual(false);
        } catch (e) {
          expect(JSON.stringify(e)).assertInstanceOf('String');
        }
      });

      it('test_checkFolderbyInstallSource_04', 0, () => {
        try {
          let result: boolean = DeliverUtil.checkFolderbyInstallSource(dhItemInfos[2], DeliverUtil.DELIVER_APPSTORE_PKG);
          expect(result).assertEqual(true);
        } catch (e) {
          expect(JSON.stringify(e)).assertInstanceOf('String');
        }
      });

      it('test_checkFolderbyInstallSource_05', 0, () => {
        try {
          let result: boolean = DeliverUtil.checkFolderbyInstallSource(dhItemInfos[2], DeliverUtil.ABROAD_APP_PKG);
          expect(result).assertEqual(false);
        } catch (e) {
          expect(JSON.stringify(e)).assertInstanceOf('String');
        }
      });

      it('test_checkFolderbyInstallSource_06', 0, () => {
        try {
          let result: boolean = DeliverUtil.checkFolderbyInstallSource(dhItemInfos[3], DeliverUtil.ABROAD_APP_PKG);
          expect(result).assertEqual(false);
        } catch (e) {
          expect(JSON.stringify(e)).assertInstanceOf('String');
        }
      });

    it('test_isHideDhRemoveMenu_01', 0, () => {
      try {
        let result: boolean = DeliverUtil.isHideDhRemoveMenu('test');
        expect(result).assertEqual(false);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_isHideDhRemoveMenu_02', 0, () => {
      try {
        let result: boolean = DeliverUtil.isHideDhRemoveMenu(DeliverUtil.DELIVER_APP_BUNDLE_NAME_REAL);
        expect(result).assertEqual(false);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_isHideDhRemoveMenu_03', 0, () => {
      try {
        DesktopLayoutCacheData['mGridLayoutItemList'] = dhItemInfos;
        let result: boolean = DeliverUtil.isHideDhRemoveMenu(DeliverUtil.DELIVER_APP_BUNDLE_NAME_REAL);
        expect(result).assertEqual(false);
        DesktopLayoutCacheData['mGridLayoutItemList'] = [];
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_isHideDhRemoveMenu_04', 0, () => {
      try {
        let result: boolean = DeliverUtil.isHideDhRemoveMenu(DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME_REAL);
        expect(result).assertEqual(false);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_isHideDhRemoveMenu_05', 0, () => {
      try {
        DesktopLayoutCacheData['mGridLayoutItemList'] = dhItemInfos;
        let result: boolean = DeliverUtil.isHideDhRemoveMenu(DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME_REAL);
        expect(result).assertEqual(false);
        DesktopLayoutCacheData['mGridLayoutItemList'] = [];
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_getStringByDialogType_1', 0, () => {
      try {
        let installedDialogType: InstalledDialogType = InstalledDialogType.OPEN;
        let result: DialogConfig = DeliverUtil.getStringByDialogType(installedDialogType);
        expect(result.content).assertEqual('app.string.open_harmony_app_dialog_content');
        expect(result.primaryButton).assertEqual('app.string.deliver_app_dialog_cancel');
        expect(result.secondaryButton).assertEqual('app.string.deliver_app_dialog_open');
        expect(result.fontColor).assertEqual('sys.color.ohos_id_color_text_primary_activated');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_getStringByDialogType_2', 0, () => {
      try {
        let installedDialogType: InstalledDialogType = InstalledDialogType.UNINSTALL;
        let result: DialogConfig = DeliverUtil.getStringByDialogType(installedDialogType);
        expect(result.content).assertEqual('app.string.uninstall_deliver_app_dialog_content');
        expect(result.primaryButton).assertEqual('app.string.cancel');
        expect(result.secondaryButton).assertEqual('app.string.uninstall');
        expect(result.fontColor).assertEqual('sys.color.ohos_id_color_warning');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_getStringByDialogType_3', 0, () => {
      try {
        let installedDialogType: InstalledDialogType = InstalledDialogType.FORCE_UNINSTALL;
        let result: DialogConfig = DeliverUtil.getStringByDialogType(installedDialogType);
        expect(result.content).assertEqual('app.string.uninstall_deliver_app_dialog_content');
        expect(result.primaryButton).assertEqual('app.string.cancel');
        expect(result.secondaryButton).assertEqual('app.string.uninstall');
        expect(result.fontColor).assertEqual('sys.color.ohos_id_color_warning');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
  })
}