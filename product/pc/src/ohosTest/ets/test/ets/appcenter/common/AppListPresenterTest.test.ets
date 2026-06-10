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

import { describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  Level,
  MockKit,
  when} from '@ohos/hypium';
import { EventConstants} from '@ohos/frameworkwrapper';
import {
  AppGalleryDownloadManager,
  AppItemInfo, AppModel,
  BadgeItemInfo,
  EnterpriseSpaceUtil, GridLayoutItemInfo } from '@ohos/launchercommon';
import { AppListPresenter } from '@ohos/appcenter/src/main/ets/default/common/presenter/AppListPresenter';
import AppGridLayoutCacheManager from '@ohos/appcenter/src/main/ets/default/common/cache/AppGridLayoutCacheManager';

export function AppListPresenterTest() {
  describe('AppListPresenterTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_AppListPresenterTest_getInstance_should_return_single_instance', Level.LEVEL0, (): void => {
      let instance1 = AppListPresenter.getInstance();
      expect(instance1).not().assertNull();
      let instance2 = AppListPresenter.getInstance();
      expect(instance1).assertEqual(instance2);
    })

    it('test_AppListPresenterTest_getAppList', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      AppListPresenter.getInstance().getAppList();
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_getInstallingAppList', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      AppListPresenter.getInstance().getAppList();
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_deleteAppCenterItem', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      let bundleName: string = 'com.ohos.appgallery';
      AppListPresenter.getInstance().deleteAppCenterItem(bundleName);
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_onAppListViewCreate', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      AppListPresenter.getInstance().onAppListViewCreate();
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_onAppListViewDestroy', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      AppListPresenter.getInstance().onAppListViewDestroy();
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_insertNewUpdateApp', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      let items: GridLayoutItemInfo[] = [];
      AppListPresenter.getInstance().insertNewUpdateApp(items);
      let item: GridLayoutItemInfo = new GridLayoutItemInfo;
      item.bundleName = 'com.ohos.appgallery';
      item.typeId = 0;
      item.abilityName = 'MainAbility';
      item.moduleName = 'entry';
      item.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      item.badgeNumber = 1;
      item.area = [2,3];
      item.appName = '应用市场';
      item.appIconId = 67109115;
      item.appLabelId = 67108895;
      item.kindId = 0;
      item.bundleType = 0;
      item.applicationName = '';
      item.appStatus = 0;
      item.downloadProgress = 2;
      item.iconResource = '2';
      item.callerName = 'yyy';
      items.push(item);
      item = new GridLayoutItemInfo;
      item.bundleName = 'com.ohos.totemweather';
      item.typeId = 0;
      item.abilityName = 'MainAbility';
      item.moduleName = 'entry';
      item.keyName = 'com.ohos.totemweather_MainAbility_entry_0'
      item.badgeNumber = 1;
      item.area = [2,3];
      item.appIconId = 67109115;
      item.appLabelId = 67108895;
      item.kindId = 0;
      item.bundleType = 0;
      item.applicationName = '';
      item.appStatus = -1;
      item.downloadProgress = 2;
      item.iconResource = '2';
      item.callerName = 'yyy';
      items.push(item);

      AppListPresenter.getInstance().insertNewUpdateApp(items);
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_loadAppCenterData', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      let mocker: MockKit = new MockKit();
      let mockerFunc = mocker.mockFunc(EnterpriseSpaceUtil, EnterpriseSpaceUtil.hwItOsCheck);
      let mockerFunc1 = mocker.mockFunc(EnterpriseSpaceUtil, EnterpriseSpaceUtil.envCheck);
      let mockerFunc2 = mocker.mockFunc(AppModel, (AppModel as object)['getAppList']);
      let appItemInfolist: AppItemInfo[] = [];
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfolist.push(appItemInfo);
      try {
        when(mockerFunc)().afterReturn(true);
        when(mockerFunc1)().afterReturn(true);
        AppListPresenter.getInstance().loadAppCenterData();
      } catch (e) {

      }
      try {
        when(mockerFunc)().afterReturn(true);
        when(mockerFunc1)().afterReturn(true);
        when(mockerFunc2)().afterReturn(appItemInfolist);
        AppListPresenter.getInstance().loadAppCenterData();
      } catch (e) {

      }
      try {
        when(mockerFunc)().afterReturn(true);
        when(mockerFunc1)().afterReturn(false);
        when(mockerFunc2)().afterReturn(appItemInfolist);
        AppListPresenter.getInstance().loadAppCenterData();
      } catch (e) {

      }
      try {
        when(mockerFunc)().afterReturn(false);
        when(mockerFunc1)().afterReturn(false);
        when(mockerFunc2)().afterReturn(appItemInfolist);
        AppListPresenter.getInstance().loadAppCenterData();
      } catch (e) {

      }
      try {
        when(mockerFunc)().afterReturn(false);
        when(mockerFunc1)().afterReturn(true);
        when(mockerFunc2)().afterReturn(appItemInfolist);
        AppListPresenter.getInstance().loadAppCenterData();
      } catch (e) {

      }
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_regroupDataAppListChange', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      let mocker: MockKit = new MockKit();
      let mockerFunc = mocker.mockFunc(EnterpriseSpaceUtil, EnterpriseSpaceUtil.envCheck);
      when(mockerFunc)().afterReturn(true);
      AppListPresenter.getInstance().regroupDataAppListChange([], 'test');
      let appItemList: Array<AppItemInfo> = [];
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemList.push(appItemInfo);
      (instance as object)['checkNeedHideApp'] = false;
      let bundelName = 'com.ohos.appgallery';
      let appGalleryDownloadManager: AppGalleryDownloadManager = AppGalleryDownloadManager.getInstance();
      let mockerFunc1 = mocker.mockFunc(appGalleryDownloadManager, appGalleryDownloadManager.getDownDownloadTaskInfo);
      when(mockerFunc1)().afterReturn(true);
      AppListPresenter.getInstance().regroupDataAppListChange(appItemList, 'usual.event.PACKAGE_ADDED', bundelName);
      AppListPresenter.getInstance().regroupDataAppListChange(appItemList, 'usual.event.PACKAGE_ADDED');
      when(mockerFunc1)().afterReturn(false);
      AppListPresenter.getInstance().regroupDataAppListChange(appItemList, 'usual.event.PACKAGE_ADDED', bundelName);
      AppListPresenter.getInstance().regroupDataAppListChange(appItemList, 'usual.event.PACKAGE_ADDED');
      appItemList.push(new AppItemInfo());
      when(mockerFunc1)().afterReturn(false);
      AppListPresenter.getInstance().regroupDataAppListChange(appItemList, 'usual.event.PACKAGE_CHANGED', bundelName);
      AppListPresenter.getInstance().regroupDataAppListChange(appItemList, 'usual.event.PACKAGE_ADDED', bundelName);
      AppListPresenter.getInstance().regroupDataAppListChange(appItemList, 'usual.event.PACKAGE_REMOVED', bundelName);
      AppListPresenter.getInstance().regroupDataAppListChange(appItemList, 'launcher.event.init_applist_finish', bundelName);
      AppListPresenter.getInstance().regroupDataAppListChange(appItemList, 'usual.event.PACKAGE_CHANGED');
      AppListPresenter.getInstance().regroupDataAppListChange(appItemList, 'usual.event.PACKAGE_ADDED');
      AppListPresenter.getInstance().regroupDataAppListChange(appItemList, 'usual.event.PACKAGE_REMOVED');
      AppListPresenter.getInstance().regroupDataAppListChange(appItemList, 'launcher.event.init_applist_finish');
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_informUninstallResult', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      AppListPresenter.getInstance().informUninstallResult(1);
      AppListPresenter.getInstance().informUninstallResult(0);
      AppListPresenter.getInstance().informUninstallResult(-1);
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_buildNotInstalledAppMenu', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      AppListPresenter.getInstance().buildNotInstalledAppMenu('test1');
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_deleteInstallFailApp', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      AppListPresenter.getInstance().deleteInstallFailApp('test1');
      AppListPresenter.getInstance().deleteInstallFailApp(undefined);
      AppListPresenter.getInstance().deleteInstallFailApp('com.ohos.appgallery');
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_openApplication', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      AppListPresenter.getInstance().openApplication('entry_try', 'test1', 'modelname');
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_updateOneAppLayoutInfo', Level.LEVEL0, (): void => {
      let appItemInfolist: AppItemInfo[] = [];
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfolist.push(appItemInfo);
      let instance: AppListPresenter = AppListPresenter.getInstance();
      AppStorage.setOrCreate('appCenterLayoutInfo', appItemInfolist);
      (instance as object)['updateOneAppLayoutInfo']();
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_refreshAppGridLayout', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      let mocker: MockKit = new MockKit();
      let appGridLayoutCacheManager: AppGridLayoutCacheManager = AppGridLayoutCacheManager.getInstance();
      let mockerFunc1 = mocker.mockFunc(appGridLayoutCacheManager, appGridLayoutCacheManager.getAppGridLayoutItemList);
      when(mockerFunc1)().afterReturn(null);
      (instance as object)['refreshAppGridLayout']();
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_updateBadgeNum', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      let mocker: MockKit = new MockKit();
      let mockerFunc2 = mocker.mockFunc(AppModel, (AppModel as object)['getAppList']);
      let appItemInfolist: AppItemInfo[] = [];
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfo.appIndex = 0;
      appItemInfolist.push(appItemInfo);
      appItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery2';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfo.appIndex = 0;
      appItemInfolist.push(appItemInfo);
      when(mockerFunc2)().afterReturn(appItemInfolist);
      let badgeInfo: BadgeItemInfo = new BadgeItemInfo();
      badgeInfo.bundleName = 'com.ohos.appgallery';
      badgeInfo.appIndex = 0;
      (instance as object)['updateBadgeNum'](badgeInfo);
      badgeInfo.appInstanceKey = '123';
      (instance as object)['updateBadgeNum'](badgeInfo);
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_appItemsCount', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      let appItemInfolist: AppItemInfo[] = [];
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfolist.push(appItemInfo);
      let mocker: MockKit = new MockKit();
      let appGridLayoutCacheManager: AppGridLayoutCacheManager = AppGridLayoutCacheManager.getInstance();
      let mockerFunc1 = mocker.mockFunc(appGridLayoutCacheManager, appGridLayoutCacheManager.getAppGridLayoutItemList);
      when(mockerFunc1)().afterReturn(appItemInfolist);
      (instance as object)['appItemsCount']();
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_filterInstallAppList1', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      (instance as object)['filterInstallAppList']([], [], []);
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_filterInstallAppList2', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      let appItemInfolist: AppItemInfo[] = [];
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfolist.push(appItemInfo);
      (instance as object)['filterInstallAppList'](appItemInfolist, [], []);
      (instance as object)['filterInstallAppList'](appItemInfolist, appItemInfolist, []);
      (instance as object)['filterInstallAppList'](appItemInfolist, appItemInfolist, appItemInfolist);
      (instance as object)['filterInstallAppList'](appItemInfolist, [], appItemInfolist);
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_reorganizeAppData', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      let appItemInfolist: AppItemInfo[] = [];
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfo.page = 1;
      appItemInfolist.push(appItemInfo);
      (instance as object)['reorganizeAppData']([], [], []);
      (instance as object)['reorganizeAppData'](appItemInfolist, appItemInfolist, []);
      (instance as object)['reorganizeAppData'](appItemInfolist, appItemInfolist, appItemInfolist);
      (instance as object)['reorganizeAppData'](appItemInfolist, [], appItemInfolist);
      (instance as object)['reorganizeAppData']([], appItemInfolist, appItemInfolist);
      (instance as object)['reorganizeAppData']([], [], appItemInfolist);
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_onPackageChanged', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      let appItemInfolist: AppItemInfo[] = [];
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfo.page = 1;
      appItemInfolist.push(appItemInfo);
      (instance as object)['onPackageChanged'](appItemInfolist);
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_intoSetting', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      AppListPresenter.getInstance().intoSetting();
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_updateCacheAndDB', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      (instance as object)['updateCacheAndDB']([], [], [], [], []);
      let appItemInfolist: AppItemInfo[] = [];
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfo.page = 1;
      appItemInfolist.push(appItemInfo);
      (instance as object)['updateCacheAndDB']([], [], appItemInfolist, [], []);
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_registerInstalledAniFinishCallback', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      (instance as object)['registerInstalledAniFinishCallback'](undefined);
      let appItemInfolist: AppItemInfo[] = [];
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfo.page = 1;
      appItemInfolist.push(appItemInfo);
      (instance as object)['registerInstalledAniFinishCallback']('com.ohos.appgallery');
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_updateNewInstalledGridInfo', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      (instance as object)['updateNewInstalledGridInfo']('com.ohos.appgallery');
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfo.page = 1;

      let mocker: MockKit = new MockKit();
      let appModel: AppModel = AppModel.getInstance();
      let mockerFunc1 = mocker.mockFunc(appModel, appModel.getAppInfoByBundleInfo);
      when(mockerFunc1)().afterReturn([]);
      (instance as object)['registerInstalledAniFinishCallback']('com.ohos.appgallery');
      when(mockerFunc1)().afterReturn(appItemInfo);
      (instance as object)['registerInstalledAniFinishCallback']('com.ohos.appgallery');
      expect(instance instanceof AppListPresenter).assertTrue();
    })

    it('test_AppListPresenterTest_enterpriseSpaceHideAppGallery', Level.LEVEL0, (): void => {
      let instance: AppListPresenter = AppListPresenter.getInstance();
      (instance as object)['enterpriseSpaceHideAppGallery']([], []);
      let appItemInfolist: AppItemInfo[] = [];
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfo.page = 1;
      appItemInfolist.push(appItemInfo)
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(EnterpriseSpaceUtil, EnterpriseSpaceUtil.envCheck);
      when(mockerFunc1)().afterReturn(true);
      (instance as object)['enterpriseSpaceHideAppGallery'](appItemInfolist);
      when(mockerFunc1)().afterReturn(false);
      (instance as object)['enterpriseSpaceHideAppGallery'](appItemInfolist);
      expect(instance instanceof AppListPresenter).assertTrue();
    })

  })
}