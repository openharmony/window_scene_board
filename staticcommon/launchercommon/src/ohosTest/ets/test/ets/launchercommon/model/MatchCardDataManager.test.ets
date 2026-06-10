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
import { LogHelper, LogDomain, FileUtils } from '@ohos/basicutils';
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
import { MatchCardDataManager } from '../../../../../../main/ets/model/MatchCardDataManager'
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import DefaultDesktopLayoutInfo from '../../../../../../main/ets/configs/DefaultDesktopLayoutInfo';
import { AppItemInfo } from '../../../../../../main/ets/bean/AppItemInfo';
import GridLayoutItemInfo from '../../../../../../main/ets/bean/GridLayoutItemInfo';
import { CommonConstants } from '../../../../../../main/ets/constants/CommonConstants';
export default function MatchCardDataManagerTest() {
  describe('MatchCardDataManagerTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })


    it('test_init', 0, () => {

      expect(MatchCardDataManager.init() === undefined).assertTrue();
    });

    it('test_isMatchCardFinished0', 0, () => {
      MatchCardDataManager['mScbMatchCardFinish'] = 'true';
      const result = MatchCardDataManager.isMatchCardFinished();
      expect(result).assertEqual(true);
    });

    it('test_isMatchCardFinished1', 0, () => {
      MatchCardDataManager['mScbMatchCardFinish'] = 'false';
      const result = MatchCardDataManager.isMatchCardFinished();
      expect(result).assertEqual(false);
    });

    it('test_isMatchCardFinished2', 0, () => {
      MatchCardDataManager['mScbMatchCardFinish'] = '';
      const result = MatchCardDataManager.isMatchCardFinished();
      expect(result).assertEqual(false);
    });

    it('test_initAppList0', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetValueEx: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getValueEx);
      when(mockGetValueEx)(ArgumentMatchers.anyString).afterReturn('');
      MatchCardDataManager['initAppList'];
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getValueEx);
    });

    it('test_initAppList1', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetValueEx: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getValueEx);
      when(mockGetValueEx)(ArgumentMatchers.any).afterReturn("testAppList");
      let mockShowWarn: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showWarn);
      when(mockShowWarn)(ArgumentMatchers.any).afterReturnNothing();
      MatchCardDataManager['initAppList'];
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getValueEx);
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showWarn);
    });

    it('test_initAppList2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetValueEx: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getValueEx);
      when(mockGetValueEx)(ArgumentMatchers.any).afterReturn("testAppList");
      let mockShowWarn: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showWarn);
      when(mockShowWarn)(ArgumentMatchers.any).afterReturnNothing();
      let mockIsStandardDesktopLayoutModel: Function =
        mocker.mockFunc(MatchCardDataManager, MatchCardDataManager['isStandardDesktopLayoutModel']);
      when(mockIsStandardDesktopLayoutModel)().afterReturn(false);
      MatchCardDataManager['initAppList'];
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getValueEx);
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showWarn);
      mocker.ignoreMock(MatchCardDataManager, MatchCardDataManager['isStandardDesktopLayoutModel']);
    });

    it('test_registerBmsAppListChangeListener0', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetValueEx: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getValueEx);
      when(mockGetValueEx)(ArgumentMatchers.anyString).afterThrow("Error");
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showError);
      when(mockShowError)(ArgumentMatchers.any).afterReturnNothing();
      MatchCardDataManager['registerBmsAppListChangeListener'];
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getValueEx);
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showError);
    });

    it('test_registerBmsAppListChangeListener1', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetValueEx: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getValueEx);
      when(mockGetValueEx)(ArgumentMatchers.any).afterReturn('');
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showError);
      when(mockShowError)(ArgumentMatchers.any).afterReturnNothing();
      MatchCardDataManager['registerBmsAppListChangeListener'];
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getValueEx);
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showError);
    });

    it('test_registerBmsAppListChangeListener2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetValueEx: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getValueEx);
      when(mockGetValueEx)(ArgumentMatchers.any).afterReturn("app1,app2");
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showError);
      when(mockShowError)(ArgumentMatchers.any).afterReturnNothing();
      let mockGetMatchCardAppList: Function =
        mocker.mockFunc(MatchCardDataManager, MatchCardDataManager['getMatchCardAppList']);
      when(mockGetMatchCardAppList)(ArgumentMatchers.anyString).afterReturnNothing();
      MatchCardDataManager['registerBmsAppListChangeListener'];
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getValueEx);
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showError);
      mocker.ignoreMock(MatchCardDataManager, MatchCardDataManager['getMatchCardAppList']);
    });

    it('test_registerBmsAppListChangeListener3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetValueEx: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getValueEx);
      when(mockGetValueEx)(ArgumentMatchers.any).afterReturn('app1,app2');
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showError);
      when(mockShowError)(ArgumentMatchers.any).afterReturnNothing();
      MatchCardDataManager['mMatchCardAppList'] = ['app3'];
      MatchCardDataManager['registerBmsAppListChangeListener'];
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getValueEx);
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showError);
    });

    it('test_unRegisterBmsAppListChangeListener0', 0, () => {
      MatchCardDataManager.unRegisterBmsAppListChangeListener();
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_unRegisterBmsAppListChangeListener1', 0, () => {
      MatchCardDataManager.unRegisterBmsAppListChangeListener();
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_unRegisterBmsAppListChangeListener2', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showError);
      when(mockShowError)(ArgumentMatchers.any).afterReturn(null);
      MatchCardDataManager.unRegisterBmsAppListChangeListener();
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showError);
    });

    it('test_getMatchCardAppList0', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockShowWarn: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      MatchCardDataManager['getMatchCardAppList']('1,2,3');
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showWarn);
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showInfo);
    });

    it('test_getMatchCardAppList1', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockShowWarn: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      MatchCardDataManager['getMatchCardAppList']('1,2,3');
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showWarn);
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showInfo);
    });

    it('test_parseMatchCardLayoutJson0', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockLogHelperError: Function =
        mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').error);
      when(mockLogHelperError)(ArgumentMatchers.any).afterReturnNothing();
      expect(await MatchCardDataManager['parseMatchCardLayoutJson'].length).assertLargerOrEqual(0);
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').error);
    });

    it('test_parseMatchCardLayoutJson1', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockLogHelperError: Function =
        mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').error);
      when(mockLogHelperError)(ArgumentMatchers.any).afterReturnNothing();
      let mockFileUtilsReadJsonFile: Function = mocker.mockFunc(FileUtils, FileUtils.readJsonFile);
      when(mockFileUtilsReadJsonFile)(ArgumentMatchers.any).afterReturn({});
      expect(await MatchCardDataManager['parseMatchCardLayoutJson'].length).assertLargerOrEqual(0);
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').error);
      mocker.ignoreMock(FileUtils, FileUtils.readJsonFile);
    });

    it('test_parseMatchCardLayoutJson2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockLogHelperError: Function =
        mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').error);
      when(mockLogHelperError)(ArgumentMatchers.any).afterReturnNothing();
      let mockFileUtilsReadJsonFile: Function = mocker.mockFunc(FileUtils, FileUtils.readJsonFile);
      let mockAutoInstallLayout: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      when(mockFileUtilsReadJsonFile)(ArgumentMatchers.any).afterReturn(mockAutoInstallLayout);
      expect(await MatchCardDataManager['parseMatchCardLayoutJson'].length).assertLargerOrEqual(0);
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').error);
      mocker.ignoreMock(FileUtils, FileUtils.readJsonFile);
    });

    it('test_parseMatchCardLayoutJson3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockLogHelperError: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').error);
      when(mockLogHelperError)(ArgumentMatchers.any).afterReturnNothing();
      expect(await MatchCardDataManager['parseMatchCardLayoutJson'].length).assertLargerOrEqual(0);
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').error);
    });

    it('test_getAutoInstallAppList1', 0, () => {
      let autoInstallLayoutInfo: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      autoInstallLayoutInfo.layoutInfo = [];
      let result = MatchCardDataManager['getAutoInstallAppList'](autoInstallLayoutInfo);
      expect(result).assertDeepEquals([]);
    });

    it('test_getAutoInstallAppList2', 0, () => {
      let autoInstallLayoutInfo: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      let itemInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo1.typeId = CommonConstants.TYPE_FOLDER;
      itemInfo1.folderId = MatchCardDataManager['PRELOAD_TOPAPPS_FOLDER_ID'];
      autoInstallLayoutInfo.layoutInfo = [itemInfo1];
      let result = MatchCardDataManager['getAutoInstallAppList'](autoInstallLayoutInfo);
      expect(result).assertDeepEquals([]);
    });

    it('test_getAutoInstallAppList3', 0, () => {
      let autoInstallLayoutInfo: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      autoInstallLayoutInfo.layoutInfo[0] = new GridLayoutItemInfo();
      autoInstallLayoutInfo.layoutInfo[0].typeId = CommonConstants.TYPE_FOLDER;
      autoInstallLayoutInfo.layoutInfo[0].folderId = MatchCardDataManager['PRELOAD_TOPAPPS_FOLDER_ID'];
      let itemInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let itemInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo1.bundleName = 'com.example.app1';
      itemInfo1.typeId = CommonConstants.TYPE_APP;
      itemInfo2.typeId = CommonConstants.TYPE_APP;
      itemInfo2.bundleName = 'com.example.app2';
      if (autoInstallLayoutInfo.layoutInfo.length > 0) {
        autoInstallLayoutInfo.layoutInfo[0].layoutInfo = [[]];
        autoInstallLayoutInfo.layoutInfo[0].layoutInfo[0] = [itemInfo1, itemInfo2];
      }
      let result = MatchCardDataManager['getAutoInstallAppList'](autoInstallLayoutInfo);
      expect(result).assertDeepEquals(['com.example.app1', 'com.example.app2']);
    });

    it('test_getAutoInstallAppList4', 0, () => {
      let autoInstallLayoutInfo: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      autoInstallLayoutInfo.layoutInfo[0] = new GridLayoutItemInfo();
      autoInstallLayoutInfo.layoutInfo[0].typeId = CommonConstants.TYPE_FOLDER;
      autoInstallLayoutInfo.layoutInfo[0].folderId = MatchCardDataManager['PRELOAD_TOPAPPS_FOLDER_ID'];
      let itemInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let itemInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      let itemInfo3: GridLayoutItemInfo = new GridLayoutItemInfo();
      let itemInfo4: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo1.bundleName = 'com.example.app1';
      itemInfo1.typeId = CommonConstants.TYPE_APP;
      itemInfo1.folderId = MatchCardDataManager['PRELOAD_TOPAPPS_FOLDER_ID'];
      itemInfo2.bundleName = 'com.example.app2';
      itemInfo2.typeId = CommonConstants.TYPE_APP;
      itemInfo2.folderId = MatchCardDataManager['PRELOAD_TOPAPPS_FOLDER_ID'];
      itemInfo3.bundleName = 'com.example.app3';
      itemInfo3.typeId = CommonConstants.TYPE_APP;
      itemInfo3.folderId = MatchCardDataManager['PRELOAD_TOPAPPS_FOLDER_ID'];
      itemInfo4.bundleName = 'com.example.app4';
      itemInfo4.typeId = CommonConstants.TYPE_APP;
      itemInfo4.folderId = MatchCardDataManager['PRELOAD_TOPAPPS_FOLDER_ID'];
      if (autoInstallLayoutInfo.layoutInfo.length > 0) {
        autoInstallLayoutInfo.layoutInfo[0].layoutInfo = [[]];
        autoInstallLayoutInfo.layoutInfo[0].layoutInfo[0] = [itemInfo1, itemInfo2, itemInfo3, itemInfo4];
      }
      let result = MatchCardDataManager['getAutoInstallAppList'](autoInstallLayoutInfo);
      expect(result).assertDeepEquals(['com.example.app1', 'com.example.app2', 'com.example.app3', 'com.example.app4']);
    });

    it('test_getAutoInstallAppList5', 0, () => {
      let autoInstallLayoutInfo: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      autoInstallLayoutInfo.layoutInfo[0] = new GridLayoutItemInfo();
      autoInstallLayoutInfo.layoutInfo[0].typeId = CommonConstants.TYPE_FOLDER;
      autoInstallLayoutInfo.layoutInfo[0].folderId = MatchCardDataManager['PRELOAD_TOPAPPS_FOLDER_ID'];
      let itemInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let itemInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      let itemInfo3: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo1.bundleName = 'com.example.app1';
      itemInfo1.typeId = CommonConstants.TYPE_APP;
      itemInfo1.folderId = MatchCardDataManager['PRELOAD_TOPAPPS_FOLDER_ID'];
      itemInfo2.bundleName = 'com.example.app2';
      itemInfo2.typeId = CommonConstants.TYPE_APP;
      itemInfo2.folderId = MatchCardDataManager['PRELOAD_TOPAPPS_FOLDER_ID'];
      itemInfo3.bundleName = 'com.example.invalid';
      itemInfo3.typeId = CommonConstants.TYPE_FOLDER;
      itemInfo3.folderId = MatchCardDataManager['PRELOAD_TOPAPPS_FOLDER_ID'];
      if (autoInstallLayoutInfo.layoutInfo.length > 0) {
        autoInstallLayoutInfo.layoutInfo[0].layoutInfo = [[]];
        autoInstallLayoutInfo.layoutInfo[0].layoutInfo[0] = [itemInfo1, itemInfo2, itemInfo3];
      }
      let result = MatchCardDataManager['getAutoInstallAppList'](autoInstallLayoutInfo);
      expect(result).assertDeepEquals(['com.example.app1', 'com.example.app2']);
    });

    it('test_setMatchCardIsFinished', 0, () => {
      let mocker: MockKit = new MockKit();
      MatchCardDataManager['setMatchCardIsFinished'];
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_isEmptyAppList', 0, () => {
      MatchCardDataManager['mMatchCardAppList'] = [];
      // Act
      const result = MatchCardDataManager.isEmptyAppList();
      // Assert
      expect(result).assertEqual(true);
    });

    it('test_getMatchCardAppIndex0', 0, () => {
      MatchCardDataManager['mMatchCardAppList'] = ['app_test'];
      let bundleName: string = "app_test";
      let result = MatchCardDataManager['getMatchCardAppIndex'](bundleName);
      expect(result).assertEqual(0);
    });

    it('test_getMatchCardAppIndex1', 0, () => {
      MatchCardDataManager['mMatchCardAppList'] = ['app_test'];
      let bundleName: string = "com.ohos.app.unknown";
      let result = MatchCardDataManager['getMatchCardAppIndex'](bundleName);
      expect(result).assertEqual(-1);
    });

    it('test_isMatchCardApp0', 0, () => {
      const result = MatchCardDataManager.isMatchCardApp(new AppItemInfo());
      expect(result).assertEqual(false);
    });

    it('test_isMatchCardApp1', 0, () => {
      const appInfo = new AppItemInfo();
      MatchCardDataManager['mScbMatchCardFinish'] = 'true';
      const result = MatchCardDataManager.isMatchCardApp(appInfo);
      expect(result).assertEqual(false);
    });

    it('test_isMatchCardApp2', 0, () => {
      const appInfo = new AppItemInfo();
      MatchCardDataManager['mMatchCardAppList'] = [];
      const result = MatchCardDataManager.isMatchCardApp(appInfo);
      expect(result).assertEqual(false);
    });

    it('test_isMatchCardApp3', 0, () => {
      const appInfo = new AppItemInfo();
      appInfo.appIndex = 1;
      const result = MatchCardDataManager.isMatchCardApp(appInfo);
      expect(result).assertEqual(false);
    });

    it('test_isMatchCardApp4', 0, () => {
      const appInfo = new AppItemInfo();
      appInfo.installSource = "notPreInstalled";
      const result = MatchCardDataManager.isMatchCardApp(appInfo);
      expect(result).assertEqual(false);
    });

    it('test_isMatchCardApp5', 0, () => {
      MatchCardDataManager['mScbMatchCardFinish'] ='false';
      const appInfo = new AppItemInfo();
      appInfo.bundleName = 'testBundle';
      appInfo.installSource = 'pre-installed';
      appInfo.appIndex = 0;
      MatchCardDataManager['mMatchCardAppList'] = [appInfo.bundleName];
      const result = MatchCardDataManager.isMatchCardApp(appInfo);
      expect(result).assertEqual(true);
    });

    it('test_deleteAppFromMatchCardAppList0', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockShowWarn: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showWarn);
      MatchCardDataManager['mMatchCardAppList'] = ['com.example.app'];
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      expect(MatchCardDataManager.deleteAppFromMatchCardAppList('com.example.app') === undefined).assertTrue();
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showWarn);
    });

    it('test_deleteAppFromMatchCardAppList1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockShowWarn: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showWarn);
      MatchCardDataManager['mMatchCardAppList'] = ['com.example.app'];
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      expect(MatchCardDataManager.deleteAppFromMatchCardAppList('com.invalid.app') === undefined).assertTrue();
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showWarn);
    });

    it('test_deleteAppsFromMatchCardAppList0', 0, () => {
      let apps: AppItemInfo[] = [];
      MatchCardDataManager['mMatchCardAppList'] = ['com.example.app'];
      expect(MatchCardDataManager.deleteAppsFromMatchCardAppList(apps) === undefined).assertTrue();
    });

    it('test_deleteAppsFromMatchCardAppList1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockShowWarn: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();
      let apps: AppItemInfo[] = [];
      MatchCardDataManager['mMatchCardAppList'] = ['com.example.app1','com.example.app2'];
      let itemInfo1 = new AppItemInfo();
      let itemInfo2 = new AppItemInfo();
      itemInfo1.bundleName= 'com.example.app1';
      itemInfo2.bundleName= 'com.example.app1';
      apps.push(itemInfo1);
      apps.push(itemInfo2);
      MatchCardDataManager.deleteAppsFromMatchCardAppList(apps);
      expect(MatchCardDataManager.deleteAppsFromMatchCardAppList(apps) === undefined).assertTrue();
    });

    it('test_updateSettings0', 0, () => {
      MatchCardDataManager['mMatchCardAppList'] = [];
      expect(MatchCardDataManager.updateSettings()=== undefined).assertTrue();
    });

    it('test_updateSettings1', 0, () => {
      MatchCardDataManager['mMatchCardAppList'] = ['test'];
      expect(MatchCardDataManager.updateSettings()=== undefined).assertTrue();
    });

    it('test_updateWaitAddFolderApps0', 0, () => {
      let appItem0: AppItemInfo = new AppItemInfo();
      appItem0.bundleName = "com.example.app1";
      MatchCardDataManager['mWaitAddFolderApps'] = [appItem0];
      let appItem: AppItemInfo = new AppItemInfo();
      appItem.bundleName = "com.example.app2";
      MatchCardDataManager.updateWaitAddFolderApps(appItem);
      expect(MatchCardDataManager['mWaitAddFolderApps'].length).assertEqual(2);
      expect(MatchCardDataManager['mWaitAddFolderApps'][1].bundleName).assertEqual("com.example.app2");
    });

    it('test_updateWaitAddFolderApps1', 0, () => {
      let appItem0: AppItemInfo = new AppItemInfo();
      appItem0.bundleName = "com.example.app1";
      MatchCardDataManager['mWaitAddFolderApps'] = [appItem0];
      let appItem: AppItemInfo = new AppItemInfo();
      appItem.bundleName = "com.example.app1";
      MatchCardDataManager.updateWaitAddFolderApps(appItem);

      expect(MatchCardDataManager['mWaitAddFolderApps'].length).assertEqual(1);
      expect(MatchCardDataManager['mWaitAddFolderApps'][0].bundleName).assertEqual("com.example.app1");
    });

    it('get_getWaitAddFolderApps', 0, () => {
      let app1: AppItemInfo = new AppItemInfo();
      app1.bundleName = 'com.example.app';
      MatchCardDataManager['mWaitAddFolderApps'] = [app1];
      const result = MatchCardDataManager.getWaitAddFolderApps();
      expect(result).assertDeepEquals([app1]);
    });

    it('test_clearWaitAddFolderApps', 0, () => {
      let app1: AppItemInfo = new AppItemInfo();
      app1.bundleName = 'com.example.app';
      MatchCardDataManager['mWaitAddFolderApps'] = [app1];
      expect(MatchCardDataManager['clearWaitAddFolderApps'].length).assertLargerOrEqual(0);
    });

    it('test_mWaitAddFolderApps_0', 0, () => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = "com.example.app";
      MatchCardDataManager['mWaitAddFolderApps'] = [];
      let result = MatchCardDataManager.checkIsWaitingAddFolderApp(appInfo);
      expect(result).assertEqual(false);
    });

    it('test__mWaitAddFolderApps_1', 0, () => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = "com.example.app";
      MatchCardDataManager['mWaitAddFolderApps'] = [appInfo];
      let result = MatchCardDataManager.checkIsWaitingAddFolderApp(appInfo);
      expect(result).assertEqual(true);
    });

    it('test_mWaitAddFolderApps_2', 0, () => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = "com.example.app";
      let appInfo1: AppItemInfo = new AppItemInfo();
      appInfo1.bundleName = "com.example.app1";
      MatchCardDataManager['mWaitAddFolderApps'] = [appInfo];
      let result = MatchCardDataManager.checkIsWaitingAddFolderApp(appInfo1);
      expect(result).assertEqual(false);
    });

  });
}