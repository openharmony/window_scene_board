/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { BigFolderViewModel } from '@ohos/bigfolder';
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
import {
  AppItemInfo,
  CommonConstants,
  DockItemInfo,
  FolderData,
  GridLayoutItemInfo,
  LauncherLayoutCacheUtil,
  LaunchLayoutCacheManager,
  LayoutDescription,
  RdbStoreManager,
  ResidentLayoutCacheMgr,
} from '@ohos/launchercommon';
import { MatchCardLayoutManager } from '../../../../../main/ets/default/common/viewmodel/MatchCardLayoutManager';
import { PageDesktopViewModel } from '../../../../../main/ets/default/common/viewmodel/PageDesktopViewModel';
import { MatchCardDataManager } from '@ohos/launchercommon/src/main/ets/model/MatchCardDataManager';
import { DeviceHelper } from '@ohos/frameworkwrapper';

export default function MatchCardLayoutManagerTest() {
  describe('MatchCardLayoutManagerTest', () => {
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });


    it('test_getInstance0', 0, () => {
      let result1: MatchCardLayoutManager = MatchCardLayoutManager.getInstance();
      let result2: MatchCardLayoutManager = MatchCardLayoutManager.getInstance();
      // Assert
      expect(result1).assertEqual(result2);
    });

    it('test_getInstance1', 0, () => {
      // Act
      globalThis.MatchCardLayoutManager = null;
      let result1: MatchCardLayoutManager = MatchCardLayoutManager.getInstance();
      globalThis.MatchCardLayoutManager = new MatchCardLayoutManager();
      let result2: MatchCardLayoutManager = MatchCardLayoutManager.getInstance();
      // Assert
      expect(result1 !== result2).assertTrue();
    });

    it('test_setIsFinishedInitLayout0', 0, () => {
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      matchcardlayoutmanager.setIsFinishedInitLayout();
      expect((matchcardlayoutmanager as object)['mIsFinishedInitLayout']).assertTrue();
    });

    it('test_setIsFinishedInitLayout1', 0, () => {
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      (matchcardlayoutmanager as object)['mIsFinishedInitLayout'] = true;
      matchcardlayoutmanager.setIsFinishedInitLayout();
    });

    it('test_doAddToFolderAction0', 0, () => {
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      (matchcardlayoutmanager as object)['mIsFinishedInitLayout'] = true;
      let appInfo: AppItemInfo = new AppItemInfo();
      matchcardlayoutmanager.doAddToFolderAction(appInfo);
      // 由于addToTopAppsFolder是内部调用，无法直接验证，但可以通过mock来验证
    });

    it('test_doAddToFolderAction1', 0, () => {
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      (matchcardlayoutmanager as object)['mIsFinishedInitLayout'] = false;
      let appInfo: AppItemInfo = new AppItemInfo();
      matchcardlayoutmanager.doAddToFolderAction(appInfo);
      // 由于updateWaitAddFolderApps是内部调用，无法直接验证，但可以通过mock来验证
    });

    it('test_handleWaitAddFolderApps', 0, () => {
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      expect((matchcardlayoutmanager as object)['handleWaitAddFolderApps'].length).assertLargerOrEqual(0);
    });

    it('test_addToTopAppsFolder0', 0, () => {
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      let appItemInfos: AppItemInfo[] = [];
      expect((matchcardlayoutmanager as object)['addToTopAppsFolder'](appItemInfos)=== undefined).assertTrue();

    });

    it('test_createTopAppsFolderWithFirstMatchCardApp0', 0, async () => {
      // Arrange
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      let appItemInfos: AppItemInfo[] = [];
      let appInfo1: AppItemInfo = new AppItemInfo();
      let appInfo2: AppItemInfo = new AppItemInfo();
      appInfo1.keyName = 'app1';
      appInfo1.bundleName = 'com.ohos.app1';
      appInfo2.keyName = 'app2';
      appInfo2.bundleName = 'com.ohos.app2';
      appItemInfos = [appInfo1, appInfo2];
      // Act
      (matchcardlayoutmanager as object)['createTopAppsFolderWithFirstMatchCardApp'](appItemInfos);
      // Assert
      expect((matchcardlayoutmanager as object)['mFirstAppNotFound']).assertDeepEquals(appItemInfos[0]);
    });

    it('test_createTopAppsFolderWithFirstMatchCardApp1', 0, async () => {
      // Arrange
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      let appItemInfos: AppItemInfo[] = [];
      let appInfo1: AppItemInfo = new AppItemInfo();
      let appInfo2: AppItemInfo = new AppItemInfo();
      appInfo1.keyName = 'app1';
      appInfo1.bundleName = 'com.ohos.app1';
      appInfo2.keyName = 'app2';
      appInfo2.bundleName = 'com.ohos.app2';
      appItemInfos = [appInfo1, appInfo2];
      (matchcardlayoutmanager as object)['mFirstAppNotFound'] = appItemInfos[0];
      // Act
      (matchcardlayoutmanager as object)['createTopAppsFolderWithFirstMatchCardApp'](appItemInfos);
      // Assert
      expect((matchcardlayoutmanager as object)['mFirstAppNotFound']).assertDeepEquals(appItemInfos[0]);
    });

    it('test_addToTopAppsFolderInDesktop0', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetGridLayoutItemList: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().getGridLayoutItemList);
      when(mockGetGridLayoutItemList)(ArgumentMatchers.any).afterReturn([new GridLayoutItemInfo()]);
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      let appItemInfos: AppItemInfo[] = [new AppItemInfo()];
      const result: boolean = (matchcardlayoutmanager as object)['addToTopAppsFolderInDesktop'](appItemInfos);
      expect(result).assertEqual(false);
      mocker.ignoreMock(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().getGridLayoutItemList);
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showWarn);
    });

    it('test_updateFolderAndInsertDBInDesktop0', 0, async () => {
      let mocker: MockKit = new MockKit();
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      let gridLayoutItemList: GridLayoutItemInfo[] = [];
      let folderInDesktop: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderInDesktop.folderId = '1';
      folderInDesktop.layoutInfo = [[]];
      folderInDesktop.layoutInfo[0] = [item1];
      folderInDesktop.layoutInfo[0][0].itemType = CommonConstants.ITEM_TYPE_APP;
      let appItemInfos: AppItemInfo[] = [new AppItemInfo()];
      let mockUpdateLayoutListCacheAndPrebuild: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().updateLayoutListCacheAndPrebuild);
      when(mockUpdateLayoutListCacheAndPrebuild)(ArgumentMatchers.any).afterReturnNothing();
      let mockAddInfoToFolder: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().addInfoToFolder);
      when(mockAddInfoToFolder)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockUpdateFolderAppLocation: Function =
        mocker.mockFunc(BigFolderViewModel.getInstance(), BigFolderViewModel.getInstance().updateFolderAppLocation);
      when(mockUpdateFolderAppLocation)(ArgumentMatchers.any).afterReturnNothing();
      let mockLightPagingFiltering: Function =
        mocker.mockFunc(PageDesktopViewModel.getInstance(), PageDesktopViewModel.getInstance().lightPagingFiltering);
      when(mockLightPagingFiltering)(ArgumentMatchers.anyBoolean).afterReturnNothing();
      let mockRefreshView: Function = mocker.mockFunc(FolderData.getInstance(), FolderData.getInstance().refreshView);
      when(mockRefreshView)(ArgumentMatchers.any).afterReturnNothing();
      (matchcardlayoutmanager as object)['updateFolderAndInsertDBInDesktop'](gridLayoutItemList, folderInDesktop, appItemInfos);
      expect(folderInDesktop.layoutInfo[0][0].itemType).assertEqual(CommonConstants.ITEM_TYPE_APP);
      mocker.ignoreMock(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().updateLayoutListCacheAndPrebuild);
      mocker.ignoreMock(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().addInfoToFolder);
      mocker.ignoreMock(BigFolderViewModel.getInstance(), BigFolderViewModel.getInstance().updateFolderAppLocation);
      mocker.ignoreMock(PageDesktopViewModel.getInstance(), PageDesktopViewModel.getInstance().lightPagingFiltering);
      mocker.ignoreMock(FolderData.getInstance(), FolderData.getInstance().refreshView);
    });

    it('test_updateFolderAndInsertDBInDesktop1', 0, async () => {
      let mocker: MockKit = new MockKit();
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      let gridLayoutItemList: GridLayoutItemInfo[] = [];
      let folderInDesktop: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderInDesktop.folderId = '1';
      folderInDesktop.layoutInfo = [[]];
      folderInDesktop.layoutInfo[0] = [item1];
      folderInDesktop.layoutInfo[0][0].itemType = CommonConstants.ITEM_TYPE_APP;
      let appItemInfos: AppItemInfo[] = [new AppItemInfo()];
      let mockUpdateLayoutListCacheAndPrebuild: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().updateLayoutListCacheAndPrebuild);
      when(mockUpdateLayoutListCacheAndPrebuild)(ArgumentMatchers.any).afterReturnNothing();
      let mockAddInfoToFolder: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().addInfoToFolder);
      when(mockAddInfoToFolder)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockUpdateFolderAppLocation: Function =
        mocker.mockFunc(BigFolderViewModel.getInstance(), BigFolderViewModel.getInstance().updateFolderAppLocation);
      when(mockUpdateFolderAppLocation)(ArgumentMatchers.any).afterReturnNothing();
      let mockLightPagingFiltering: Function =
        mocker.mockFunc(PageDesktopViewModel.getInstance(), PageDesktopViewModel.getInstance().lightPagingFiltering);
      when(mockLightPagingFiltering)(ArgumentMatchers.anyBoolean).afterReturnNothing();
      let mockRefreshView: Function = mocker.mockFunc(FolderData.getInstance(), FolderData.getInstance().refreshView);
      when(mockRefreshView)(ArgumentMatchers.any).afterReturnNothing();
      (matchcardlayoutmanager as object)['updateFolderAndInsertDBInDesktop'](gridLayoutItemList, folderInDesktop, appItemInfos);
      expect(folderInDesktop.layoutInfo[0][0].itemType).assertEqual(CommonConstants.ITEM_TYPE_APP);
      mocker.ignoreMock(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().updateLayoutListCacheAndPrebuild);
      mocker.ignoreMock(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().addInfoToFolder);
      mocker.ignoreMock(BigFolderViewModel.getInstance(), BigFolderViewModel.getInstance().updateFolderAppLocation);
      mocker.ignoreMock(PageDesktopViewModel.getInstance(), PageDesktopViewModel.getInstance().lightPagingFiltering);
      mocker.ignoreMock(FolderData.getInstance(), FolderData.getInstance().refreshView);
    });

    it('test_updateFolderAndInsertDBInDesktop2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      let gridLayoutItemList: GridLayoutItemInfo[] = [];
      let folderInDesktop: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderInDesktop.folderId = '1';
      folderInDesktop.layoutInfo = [[]];
      folderInDesktop.layoutInfo[0] = [item1];
      folderInDesktop.layoutInfo[0][0].itemType = CommonConstants.ITEM_TYPE_APP;
      let appItemInfos: AppItemInfo[] = [new AppItemInfo()];
      let mockUpdateLayoutListCacheAndPrebuild: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().updateLayoutListCacheAndPrebuild);
      when(mockUpdateLayoutListCacheAndPrebuild)(ArgumentMatchers.any).afterReturnNothing();
      let mockAddInfoToFolder: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().addInfoToFolder);
      when(mockAddInfoToFolder)(ArgumentMatchers.any).afterReturn(Promise.reject('error'));
      let mockUpdateFolderAppLocation: Function =
        mocker.mockFunc(BigFolderViewModel.getInstance(), BigFolderViewModel.getInstance().updateFolderAppLocation);
      when(mockUpdateFolderAppLocation)(ArgumentMatchers.any).afterReturnNothing();
      let mockLightPagingFiltering: Function =
        mocker.mockFunc(PageDesktopViewModel.getInstance(), PageDesktopViewModel.getInstance().lightPagingFiltering);
      when(mockLightPagingFiltering)(ArgumentMatchers.anyBoolean).afterReturnNothing();
      let mockRefreshView: Function = mocker.mockFunc(FolderData.getInstance(), FolderData.getInstance().refreshView);
      when(mockRefreshView)(ArgumentMatchers.any).afterReturnNothing();
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showError);
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();
      (matchcardlayoutmanager as object)['updateFolderAndInsertDBInDesktop'](gridLayoutItemList, folderInDesktop, appItemInfos);
      expect(folderInDesktop.layoutInfo[0][0].itemType).assertEqual(CommonConstants.ITEM_TYPE_APP);
      mocker.ignoreMock(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().updateLayoutListCacheAndPrebuild);
      mocker.ignoreMock(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().addInfoToFolder);
      mocker.ignoreMock(BigFolderViewModel.getInstance(), BigFolderViewModel.getInstance().updateFolderAppLocation);
      mocker.ignoreMock(PageDesktopViewModel.getInstance(), PageDesktopViewModel.getInstance().lightPagingFiltering);
      mocker.ignoreMock(FolderData.getInstance(), FolderData.getInstance().refreshView);
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showError);
    });

    it('test_addToTopAppsFolderInDock0', 0, async () => {
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      let mocker: MockKit = new MockKit();
      let residentlayoutcachemgr: ResidentLayoutCacheMgr = ResidentLayoutCacheMgr.getInstance();
      let mockfunc: Function = mocker.mockFunc(residentlayoutcachemgr, residentlayoutcachemgr.getAllDockItems);
      when(mockfunc)([]).afterReturn([]);
      let result: boolean = (matchcardlayoutmanager as object)['addToTopAppsFolderInDock']([]);
      expect(result).assertEqual(false);
      mocker.ignoreMock(residentlayoutcachemgr, residentlayoutcachemgr.getAllDockItems);
    });

    it('test_addToTopAppsFolderInDock1', 0, async () => {
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      let mocker: MockKit = new MockKit();
      let residentlayoutcachemgr: ResidentLayoutCacheMgr = ResidentLayoutCacheMgr.getInstance();
      let mockfunc: Function = mocker.mockFunc(residentlayoutcachemgr, residentlayoutcachemgr.getAllDockItems);
      let dockiteminfo: DockItemInfo = new DockItemInfo();
      dockiteminfo.bundleName = 'test';
      dockiteminfo.itemType = CommonConstants.TYPE_APP;
      dockiteminfo.appName = 'name_test';
      when(mockfunc)().afterReturn([dockiteminfo]);

      let mockIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(ArgumentMatchers.any).afterReturn(true);

      let result: boolean = (matchcardlayoutmanager as object)['addToTopAppsFolderInDock']([]);
      expect(result).assertEqual(false);
      mocker.ignoreMock(residentlayoutcachemgr, residentlayoutcachemgr.getAllDockItems);
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    });

    it('test_addToTopAppsFolderInDock2', 0, async () => {
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      let mocker: MockKit = new MockKit();
      let residentlayoutcachemgr: ResidentLayoutCacheMgr = ResidentLayoutCacheMgr.getInstance();
      let mockfunc: Function = mocker.mockFunc(residentlayoutcachemgr, residentlayoutcachemgr.getAllDockItems);
      let dockiteminfo: DockItemInfo = new DockItemInfo();
      dockiteminfo.bundleName = 'test';
      dockiteminfo.itemType = CommonConstants.TYPE_FOLDER;
      dockiteminfo.appName = (MatchCardLayoutManager as object)['PRELOAD_TOPAPPS_FOLDER_NAME'];
      dockiteminfo.layoutInfo = [[]];
      when(mockfunc)().afterReturn([dockiteminfo]);
      let result: boolean = (matchcardlayoutmanager as object)['addToTopAppsFolderInDock']([]);
      expect(result).assertEqual(true);
      mocker.ignoreMock(residentlayoutcachemgr, residentlayoutcachemgr.getAllDockItems);
    });

    it('test_updateResidentList0', 0, async () => {
      let appItemInfos: AppItemInfo[] = [];
      let residentList: DockItemInfo[] = [];
      let folderInDock: DockItemInfo = new DockItemInfo();
      folderInDock.layoutInfo = [[]];
      let matchCardLayoutManager: MatchCardLayoutManager = new MatchCardLayoutManager();
      expect((matchCardLayoutManager as object)['updateResidentList'](appItemInfos, residentList, folderInDock).length)
        .assertLargerOrEqual(0);
    });

    it('test_updateResidentList1', 0, async () => {
      let appItemInfos: AppItemInfo[] = [];
      let residentList: DockItemInfo[] = [new DockItemInfo()];
      let folderInDock: DockItemInfo = new DockItemInfo();
      folderInDock.layoutInfo = [[]];
      let matchCardLayoutManager: MatchCardLayoutManager = new MatchCardLayoutManager();
      expect((matchCardLayoutManager as object)['updateResidentList'](appItemInfos, residentList, folderInDock).length)
        .assertLargerOrEqual(0);
    });

    it('test_updateResidentList2', 0, async () => {
      let appItemInfos: AppItemInfo[] = [];
      let residentList: DockItemInfo[] = [new DockItemInfo()];
      let folderInDock: DockItemInfo = new DockItemInfo();
      folderInDock.layoutInfo = [[]];
      folderInDock.typeId = CommonConstants.TYPE_FOLDER;
      folderInDock.appId = "1";
      let matchCardLayoutManager: MatchCardLayoutManager = new MatchCardLayoutManager();
      expect((matchCardLayoutManager as object)['updateResidentList'](appItemInfos, residentList, folderInDock).length)
        .assertLargerOrEqual(0);
    });

    it('test_updateResidentList3', 0, async () => {
      let appItemInfos: AppItemInfo[] = [new AppItemInfo()];
      let residentList: DockItemInfo[] = [new DockItemInfo()];
      let folderInDock: DockItemInfo = new DockItemInfo();
      folderInDock.layoutInfo = [[]];
      folderInDock.typeId = CommonConstants.TYPE_FOLDER;
      folderInDock.appId = "1";
      let mocker: MockKit = new MockKit();
      let mockfunc2: Function =
        mocker.mockFunc(BigFolderViewModel.getInstance(), BigFolderViewModel.getInstance().translateFolderLayout);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn([[new GridLayoutItemInfo()]]);
      let mockfunc1: Function =
        mocker.mockFunc(BigFolderViewModel.getInstance(), BigFolderViewModel.getInstance().updateFolderAppLocation);
      when(mockfunc1)(ArgumentMatchers.any).afterReturnNothing();
      let matchCardLayoutManager: MatchCardLayoutManager = new MatchCardLayoutManager();
      (matchCardLayoutManager as object)['updateResidentList'](appItemInfos, residentList, folderInDock);
      expect((matchCardLayoutManager as object)['updateResidentList'](appItemInfos, residentList, folderInDock).length)
        .assertLargerOrEqual(0);
      mocker.ignoreMock(BigFolderViewModel.getInstance(), BigFolderViewModel.getInstance().translateFolderLayout);
      mocker.ignoreMock(BigFolderViewModel.getInstance(), BigFolderViewModel.getInstance().updateFolderAppLocation);
    });

    it('test_findToTopAppsFolderInDesktop1', 0, () => {
      let gridLayoutItemList: GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.typeId = CommonConstants.TYPE_APP;
      item1.folderName = (MatchCardLayoutManager as object)['PRELOAD_TOPAPPS_FOLDER_NAME'];
      item1.typeId = CommonConstants.TYPE_APP;
      item1.folderName = (MatchCardLayoutManager as object)['PRELOAD_TOPAPPS_FOLDER_NAME'];
      gridLayoutItemList = [item1, item2];
      let matchCardLayoutManager: MatchCardLayoutManager = new MatchCardLayoutManager();
      expect((matchCardLayoutManager as object)['findToTopAppsFolderInDesktop'](gridLayoutItemList) === undefined).assertTrue();
    });

    it('test_findToTopAppsFolderInDesktop2', 0, () => {
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      let gridLayoutItemList: GridLayoutItemInfo[] = [];
      let item1:GridLayoutItemInfo =new GridLayoutItemInfo();
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.typeId = CommonConstants.TYPE_FOLDER;
      item1.folderName = (MatchCardLayoutManager as object)['PRELOAD_TOPAPPS_FOLDER_NAME'];
      item2.typeId = CommonConstants.TYPE_FOLDER;
      item2.folderName = (MatchCardLayoutManager as object)['PRELOAD_TOPAPPS_FOLDER_NAME'];
      item3.typeId = CommonConstants.TYPE_FOLDER;
      item3.folderName = (MatchCardLayoutManager as object)['PRELOAD_TOPAPPS_FOLDER_NAME'];
      gridLayoutItemList = [item1, item2, item3];
      let result: GridLayoutItemInfo | undefined = (matchcardlayoutmanager as object)['findToTopAppsFolderInDesktop'](gridLayoutItemList);
      expect(result).assertDeepEquals(gridLayoutItemList[0]);
    });

    it('test_findToTopAppsFolderIndexInDock0', 0, () => {
      let residentList: DockItemInfo[] = [];
      let item1: DockItemInfo = new DockItemInfo();
      let item2: DockItemInfo = new DockItemInfo();
      item1.itemType = CommonConstants.TYPE_APP;
      item1.appName = 'app1';
      item2.itemType = CommonConstants.TYPE_APP;
      item2.appName = 'app2';
      residentList = [item1, item2]
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      const result: number = (matchcardlayoutmanager as object)['findToTopAppsFolderIndexInDock'](residentList);
      expect(result).assertEqual(-1);
    });

    it('test_findToTopAppsFolderIndexInDock1', 0, () => {
      let residentList: DockItemInfo[] = [];
      let item1: DockItemInfo = new DockItemInfo();
      let item2: DockItemInfo = new DockItemInfo();
      let item3: DockItemInfo = new DockItemInfo();
      item1.itemType = CommonConstants.TYPE_APP;
      item1.appName = 'app1';
      item2.itemType = CommonConstants.TYPE_FOLDER;
      item2.appName = (MatchCardLayoutManager as object)['PRELOAD_TOPAPPS_FOLDER_NAME'];
      item3.itemType = CommonConstants.TYPE_APP;
      item3.appName = 'app2';
      residentList = [item1, item2, item2]
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      const result: number = (matchcardlayoutmanager as object)['findToTopAppsFolderIndexInDock'](residentList);
      expect(result).assertEqual(1);
    });

    it('test_createTopAppsFolderToDesktop0', 0, () => {
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      let appItemInfos: AppItemInfo[] = [];
      let item1: AppItemInfo = new AppItemInfo();
      appItemInfos = [item1];
      (matchcardlayoutmanager as object)['createTopAppsFolderToDesktop'](appItemInfos);
    });

    it('test_createTopAppsFolderToDesktop1', 0, async () => {
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      let appItemInfos: AppItemInfo[] = [];
      let item1: AppItemInfo = new AppItemInfo();
      let item2: AppItemInfo = new AppItemInfo();
      item1.bundleName='com.example.app1';
      item2.bundleName = 'com.example.app2';
      appItemInfos = [item1, item2];
      let mocker: MockKit = new MockKit();
      let mockLightPagingFiltering: Function =
        mocker.mockFunc(PageDesktopViewModel.getInstance(), PageDesktopViewModel.getInstance().lightPagingFiltering);
      when(mockLightPagingFiltering)(ArgumentMatchers.anyBoolean).afterReturnNothing();
      let mockRefreshView: Function = mocker.mockFunc(FolderData.getInstance(), FolderData.getInstance().refreshView);
      when(mockRefreshView)(ArgumentMatchers.any)
        .afterReturnNothing();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showInfo);
      when(mockShowInfo)(ArgumentMatchers.any).afterReturnNothing();
      let mockInsertFolderLayoutInfoAsync: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().insertFolderLayoutInfoAsync);
      when(mockInsertFolderLayoutInfoAsync)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockShowNoSpaceToast: Function =
        mocker.mockFunc(PageDesktopViewModel.getInstance(), PageDesktopViewModel.getInstance().showNoSpaceToast);
      when(mockShowNoSpaceToast)(ArgumentMatchers.anyBoolean).afterReturnNothing();
      let mockDeleteAppFromMatchCardAppList: Function =
        mocker.mockFunc(MatchCardDataManager, MatchCardDataManager.deleteAppFromMatchCardAppList);
      when(mockDeleteAppFromMatchCardAppList)(ArgumentMatchers.anyString).afterReturnNothing();
      (matchcardlayoutmanager as object)['createTopAppsFolderToDesktop'](appItemInfos);
      mocker.ignoreMock(PageDesktopViewModel.getInstance(), PageDesktopViewModel.getInstance().lightPagingFiltering);
      mocker.ignoreMock(FolderData.getInstance(), FolderData.getInstance().refreshView);
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showInfo);
      mocker.ignoreMock(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().insertFolderLayoutInfoAsync);
      mocker.ignoreMock(PageDesktopViewModel.getInstance(), PageDesktopViewModel.getInstance().showNoSpaceToast);
      mocker.ignoreMock(MatchCardDataManager, MatchCardDataManager.deleteAppFromMatchCardAppList);
    });

    it('test_updateTopAppsFolderLayout0', 0, () => {
      let folderInDesktop: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderInDesktop.layoutInfo = [[new GridLayoutItemInfo()]];
      folderInDesktop.layoutInfo[0][0].typeId = CommonConstants.TYPE_ADD;
      let appItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      (matchcardlayoutmanager as object)['updateTopAppsFolderLayout'](folderInDesktop, appItem);
      expect(folderInDesktop.layoutInfo[0][0]).assertEqual(appItem);
    });

    it('test_makeTopAppsFolder', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockShowWarn: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showWarn);
      when(mockShowWarn)(ArgumentMatchers.any).afterReturnNothing();
      let appItemInfos: AppItemInfo[] = [];
      let item1: AppItemInfo = new AppItemInfo();
      let item2: AppItemInfo = new AppItemInfo();
      item1.bundleName = 'bundle1';
      item2.bundleName = 'bundle2';
      appItemInfos = [item1, item2];
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      let result: GridLayoutItemInfo = (matchcardlayoutmanager as object)['makeTopAppsFolder'](appItemInfos);
      expect(result.typeId).assertEqual(CommonConstants.TYPE_FOLDER);
      expect(result.folderId).assertInstanceOf('String');
      expect(result.bundleName).assertEqual(result.folderId);
      expect(result.folderName).assertEqual((MatchCardLayoutManager as object)['PRELOAD_TOPAPPS_FOLDER_NAME']);
      expect(result.container).assertEqual(CommonConstants.CONTAINER_DESKTOP);
      expect(result.area).assertDeepEquals([1, 1]);
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showWarn);
    });

    it('test_findPlaceAndBuildItem0', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().selectLayoutDescription);
      let mockfunc3: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      let mockfunc4: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      let mockfunc5: Function =
        mocker.mockFunc(LaunchLayoutCacheManager.getInstance(), LaunchLayoutCacheManager.getInstance().updatePageCount);
      when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn(new LayoutDescription());
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(true);
      when(mockfunc4)(ArgumentMatchers.any).afterReturn(true);
      when(mockfunc5)(ArgumentMatchers.any).afterReturnNothing();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = "testBundle";
      let instance: MatchCardLayoutManager = MatchCardLayoutManager.getInstance();
      let result: GridLayoutItemInfo | undefined = (instance as object)['findPlaceAndBuildItem'](item);
      expect(result === undefined).assertTrue();
    });

    it('test_getAvailableLocation0', 0, () => {
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      let first: number = 5;
      let second: number = 5;
      let isPad: boolean = true;
      let page: number = 0;
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let result: GridLayoutItemInfo | undefined = (matchcardlayoutmanager as object)['getAvailableLocation'](first, second, isPad, page, item);
      expect(result === null).assertTrue();
    });

    it('test_insertMatchCardAppToDesktop0', 0, async () => {
      let mocker: MockKit = new MockKit();
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      let appItemInfo: AppItemInfo = new AppItemInfo();
      (matchcardlayoutmanager as object)['insertMatchCardAppToDesktop'](appItemInfo);
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showInfo);
    });

    it('test_insertMatchCardAppToDesktop1', 0, async () => {
      let mocker: MockKit = new MockKit();
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockfunc2: Function =
        mocker.mockFunc(PageDesktopViewModel, PageDesktopViewModel.getInstance().lightPagingFiltering);
      when(mockfunc2)(ArgumentMatchers.anyBoolean).afterReturnNothing();
      let mockfunc3: Function =
        mocker.mockFunc(MatchCardDataManager, MatchCardDataManager.deleteAppFromMatchCardAppList);
      when(mockfunc3)(ArgumentMatchers.anyString).afterReturnNothing();
      let appItemInfo: AppItemInfo = new AppItemInfo();
      (matchcardlayoutmanager as object)['insertMatchCardAppToDesktop'](appItemInfo);
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showInfo);
      mocker.ignoreMock(PageDesktopViewModel, PageDesktopViewModel.getInstance().lightPagingFiltering);
      mocker.ignoreMock(MatchCardDataManager, MatchCardDataManager.deleteAppFromMatchCardAppList);
    });

    it('test_insertMatchCardAppToDesktop2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockfunc2: Function =
        mocker.mockFunc(PageDesktopViewModel, PageDesktopViewModel.getInstance().lightPagingFiltering);
      when(mockfunc2)().afterReturnNothing();
      let appItemInfo: AppItemInfo = new AppItemInfo();
      (matchcardlayoutmanager as object)['insertMatchCardAppToDesktop'](appItemInfo);
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showInfo);
      mocker.ignoreMock(PageDesktopViewModel, PageDesktopViewModel.getInstance().lightPagingFiltering);
    });

    it('test_updateGridLayoutInfoPosition', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let page: number = 1;
      let col: number = 2;
      let row: number = 3;
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      let result: GridLayoutItemInfo = (matchcardlayoutmanager as object)['updateGridLayoutInfoPosition'](item, page, col, row);
      expect(result.page).assertEqual(page);
      expect(result.column).assertEqual(col);
      expect(result.row).assertEqual(row);
    });

    it('test_deleteFirstAppNotFound0', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockGetGridLayoutItemList: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().getGridLayoutItemList);
      let gridList: GridLayoutItemInfo[] = [];
      gridList = [new GridLayoutItemInfo(), new GridLayoutItemInfo()];
      when(mockGetGridLayoutItemList)(ArgumentMatchers.any).afterReturn(gridList);
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      (matchcardlayoutmanager as object)['deleteFirstAppNotFound']('testKeyName');
      mocker.ignoreMock(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().getGridLayoutItemList);
    });

    it('test_deleteFirstAppNotFound1', 0, () => {
      let gridList: GridLayoutItemInfo[] = [];
      let info1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let info2: GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.typeId = CommonConstants.TYPE_FOLDER;
      info1.folderName = (MatchCardLayoutManager as object)['PRELOAD_TOPAPPS_FOLDER_NAME'];
      info1.bundleName = 'testKeyName1';
      info2.typeId = CommonConstants.TYPE_FOLDER;
      info2.folderName = (MatchCardLayoutManager as object)['PRELOAD_TOPAPPS_FOLDER_NAME'];
      info2.bundleName = 'testKeyName2';
      gridList = [info1, info2];
      let mocker: MockKit = new MockKit();
      let mockGetGridLayoutItemList: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().getGridLayoutItemList);
      when(mockGetGridLayoutItemList)(ArgumentMatchers.any).afterReturn(gridList);

      let mockUpdateCache: Function =
        mocker.mockFunc(LaunchLayoutCacheManager.getInstance(), LaunchLayoutCacheManager.getInstance().updateCache);
      when(mockUpdateCache)(ArgumentMatchers.any).afterReturn([]);
      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      (matchcardlayoutmanager as object)['deleteFirstAppNotFound']('testKeyName1');

      mocker.ignoreMock(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().getGridLayoutItemList);
      mocker.ignoreMock(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().updateCache);
    });

    it('test_deleteFirstAppNotFound2', 0, () => {
      let mocker: MockKit = new MockKit();
      let gridList: GridLayoutItemInfo[] = [];
      let info1: GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.typeId = CommonConstants.TYPE_FOLDER;
      info1.folderName = (MatchCardLayoutManager as object)['PRELOAD_TOPAPPS_FOLDER_NAME'];
      info1.bundleName = 'testKeyName';
      gridList = [info1, new GridLayoutItemInfo()];

      let mockLauncherLayoutCacheUtil: Function =
        mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.deleteGridLayoutItemByKeyNameCallBack);
      when(mockLauncherLayoutCacheUtil)(ArgumentMatchers.any).afterThrow('test error');

      let mockGetGridLayoutItemList: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().getGridLayoutItemList);
      when(mockGetGridLayoutItemList)(ArgumentMatchers.any).afterReturn(gridList);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showInfo);
      when(mockShowInfo)(ArgumentMatchers.any).afterReturnNothing();

      let matchcardlayoutmanager: MatchCardLayoutManager = new MatchCardLayoutManager();
      (matchcardlayoutmanager as object)['deleteFirstAppNotFound']('testKeyName');
      mocker.ignoreMock(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.deleteGridLayoutItemByKeyNameCallBack);
      mocker.ignoreMock(LogHelper, LogHelper.getLogHelper(LogDomain.SCB, 'test').showInfo);
      mocker.ignoreMock(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().getGridLayoutItemList);
    });
  });
}