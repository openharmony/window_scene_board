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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { PcSmartDockModel } from '../../../../../main/ets/default/model/PcSmartDockModel'
import { SCBSceneContainerSession, SCBSceneSession, SCBSceneSessionManager } from '@ohos/windowscene';
import {
  DockItemInfo,
  CommonConstants,
  RecentBundleMissionInfo,
  AppModel,
  AppItemInfo,
  ResidentLayoutCacheMgr
} from '@ohos/launchercommon';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { SCBConstants } from '@ohos/commonconstants';

const TAG = 'PcSmartDockModelTest';

export default function PcSmartDockModelTest() {
  describe('PcSmartDockModelTest', () => {
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

    it('test_initRecentDataList', 0, test_initRecentDataList)
    it('test_reOrderRecentList_01', 0, test_reOrderRecentList_01)
    it('test_reOrderRecentList_02', 0, test_reOrderRecentList_02)
    it('test_reOrderRecentList_03', 0, test_reOrderRecentList_03)
    it('test_fillRecentMissionInfoList', 0, test_fillRecentMissionInfoList)
    it('test_checkAppInstanceKey_01', 0, test_checkAppInstanceKey_01)
    it('test_checkAppInstanceKey_02', 0, test_checkAppInstanceKey_02)
    it('test_checkAppInstanceKey_03', 0, test_checkAppInstanceKey_03)
    it('test_checkAppInstanceKey_04', 0, test_checkAppInstanceKey_04)
    it('test_oobeEventListen', 0, test_oobeEventListen)
    it('test_onOOBEChange_01', 0, test_onOOBEChange_01)
    it('test_onOOBEChange_02', 0, test_onOOBEChange_02)
    it('test_vpnEventListen', 0, test_vpnEventListen)
    it('test_checkIsSameItem', 0, test_checkIsSameItem)
    it('test_excludeInCollaborationList_01', 0, test_excludeInCollaborationList_01)
    it('test_excludeInCollaborationList_02', 0, test_excludeInCollaborationList_02)
    it('test_updateAppInstanceKeyInResident_01', 0, test_updateAppInstanceKeyInResident_01)
    it('test_updateAppInstanceKeyInResident_02', 0, test_updateAppInstanceKeyInResident_02)
    it('test_updateAppInstanceKeyInResident_03', 0, test_updateAppInstanceKeyInResident_03)
    it('test_updateAppInstanceKeyInResident_04', 0, test_updateAppInstanceKeyInResident_04)
    it('test_updateAppInstanceKeyInResident_05', 0, test_updateAppInstanceKeyInResident_05)
    it('test_updateAppInstanceKeyInResident_06', 0, test_updateAppInstanceKeyInResident_06)
    it('test_updateAppInstanceKeyInResident_07', 0, test_updateAppInstanceKeyInResident_07)
    it('test_updateAppInstanceKeyInResident_08', 0, test_updateAppInstanceKeyInResident_08)
    it('test_clearAppInstanceKeyInResident', 0, test_clearAppInstanceKeyInResident)
    it('test_isDuplicate', 0, test_isDuplicate)
    it('test_excludeInResidentFrom_01', 0, test_excludeInResidentFrom_01)
    it('test_excludeInResidentFrom_02', 0, test_excludeInResidentFrom_02)
    it('test_excludeInResidentFrom_03', 0, test_excludeInResidentFrom_03)
    it('test_fillRecentTaskInfoWithPersistentId', 0, test_fillRecentTaskInfoWithPersistentId)
    it('test_buildMissionInfo', 0, test_buildMissionInfo)
    it('test_addHideInRecentListSessions', 0, test_addHideInRecentListSessions)
    it('test_getAbilityItemInfo', 0, test_getAbilityItemInfo)
    it('test_getAllSession', 0, test_getAllSession)
  })
}

function test_initRecentDataList() {
  try {
    let containerSessionList: SCBSceneContainerSession[] =
      SCBSceneSessionManager.getInstance().getContainerSessionList();
    PcSmartDockModel.getInstance().initRecentDataList(containerSessionList);
  } catch {
    expect(false).assertTrue();
  }
}

function test_reOrderRecentList_01() {
  try {
    let recentMissionsList: Array<RecentBundleMissionInfo> = new Array<RecentBundleMissionInfo>();
    let recentBundleMissionItem: RecentBundleMissionInfo = new RecentBundleMissionInfo();
    recentBundleMissionItem.componentId = `${TAG}_componentId_test_reOrderRecentList_01`;
    recentBundleMissionItem.appId = `${TAG}_appId_test_reOrderRecentList_01`;
    recentBundleMissionItem.appIndex = 0;
    recentBundleMissionItem.bundleName = CommonConstants.LAUNCHER_BUNDLE;
    recentBundleMissionItem.abilityName = CommonConstants.BROWSER_ABILITY;
    recentBundleMissionItem.typeId = 0;
    recentBundleMissionItem.areaType = CommonConstants.TYPE_AREA_DOCK;
    recentBundleMissionItem.keyName = CommonConstants.LAUNCHER_BUNDLE + CommonConstants.BROWSER_ABILITY;
    recentMissionsList.push(recentBundleMissionItem);

    let result: Array<RecentBundleMissionInfo> = PcSmartDockModel.getInstance().reOrderRecentList(recentMissionsList);
    expect(result).not().assertUndefined();
  } catch {
    expect(false).assertTrue();
  }
}

// 覆盖  if (openAppNameList.includes(item.bundleName) && CheckEmptyUtils.isEmpty(newItem) &&
function test_reOrderRecentList_02() {
  let recentList_Original = AppStorage.get('recentList') as Array<RecentBundleMissionInfo>;
  let openAppNameList_Original = AppStorage.get('openAppNameList') as Array<string>;

  let recentList: Array<RecentBundleMissionInfo> = [];
  let recentItem: RecentBundleMissionInfo = new RecentBundleMissionInfo();
  recentItem.persistentId = ``;
  recentItem.shortcutId = `${TAG}_reOrderRecentList_02_shortcutId_1`;
  recentItem.componentId = `${TAG}_reOrderRecentList_02_componentId`;
  recentItem.appId = `${TAG}_reOrderRecentList_02_appId`;
  recentItem.appIndex = 0;
  recentItem.bundleName = CommonConstants.LAUNCHER_BUNDLE;
  recentItem.abilityName = CommonConstants.BROWSER_ABILITY;
  recentItem.typeId = 0;
  recentItem.areaType = CommonConstants.TYPE_AREA_DOCK;
  recentItem.keyName = CommonConstants.LAUNCHER_BUNDLE + CommonConstants.BROWSER_ABILITY;
  recentList.push(recentItem);
  AppStorage.setOrCreate('recentList', recentList);

  let openAppNameList: Array<string> = [];
  openAppNameList.push(recentItem.bundleName);
  AppStorage.setOrCreate('openAppNameList', openAppNameList);

  let recentMissionsList: Array<RecentBundleMissionInfo> = new Array<RecentBundleMissionInfo>();
  let recentMissionsItem: RecentBundleMissionInfo = new RecentBundleMissionInfo();
  recentMissionsItem.persistentId = '';
  recentMissionsItem.shortcutId = `${TAG}_reOrderRecentList_02_shortcutId_2`;
  recentMissionsList.push(recentMissionsItem);

  try {
    let result: Array<RecentBundleMissionInfo> = PcSmartDockModel.getInstance().reOrderRecentList(recentMissionsList);
    expect(result).not().assertUndefined();
  } catch {
    expect(false).assertTrue();
  } finally {
    AppStorage.setOrCreate('recentList', recentList_Original);
    AppStorage.setOrCreate('openAppNameList', openAppNameList_Original);
  }
}

// 覆盖  } else if (!CheckEmptyUtils.isEmpty(newItem)) {
function test_reOrderRecentList_03() {
  let recentList_Original = AppStorage.get('recentList') as Array<RecentBundleMissionInfo>;
  let openAppNameList_Original = AppStorage.get('openAppNameList') as Array<string>;

  let recentList: Array<RecentBundleMissionInfo> = [];
  let recentItem: RecentBundleMissionInfo = new RecentBundleMissionInfo();
  recentItem.persistentId = `${TAG}_reOrderRecentList_03_persistentId`;
  recentItem.componentId = `${TAG}_reOrderRecentList_03_componentId`;
  recentItem.appId = `${TAG}_reOrderRecentList_03_appId`;
  recentItem.appIndex = 0;
  recentItem.bundleName = CommonConstants.LAUNCHER_BUNDLE;
  recentItem.abilityName = CommonConstants.BROWSER_ABILITY;
  recentItem.typeId = 0;
  recentItem.areaType = CommonConstants.TYPE_AREA_DOCK;
  recentItem.keyName = CommonConstants.LAUNCHER_BUNDLE + CommonConstants.BROWSER_ABILITY;
  recentList.push(recentItem);
  AppStorage.setOrCreate('recentList', recentList);

  let openAppNameList: Array<string> = [];
  openAppNameList.push(recentItem.bundleName);
  AppStorage.setOrCreate('openAppNameList', openAppNameList);

  let recentMissionsList: Array<RecentBundleMissionInfo> = new Array<RecentBundleMissionInfo>();
  recentItem.persistentId = `${TAG}_reOrderRecentList_03_persistentId`;
  recentMissionsList.push(recentItem);
  try {
    let result: Array<RecentBundleMissionInfo> = PcSmartDockModel.getInstance().reOrderRecentList(recentMissionsList);
    expect(result).not().assertUndefined();
  } catch {
    expect(false).assertTrue();
  } finally {
    AppStorage.setOrCreate('recentList', recentList_Original);
    AppStorage.setOrCreate('openAppNameList', openAppNameList_Original);
  }
}

function test_fillRecentMissionInfoList() {
  try {
    let appList = AppModel.getInstance().getAppList();
    let containerSessionList: SCBSceneContainerSession[] =
      SCBSceneSessionManager.getInstance().getContainerSessionList();
    let recentMissionsList: Array<RecentBundleMissionInfo> = Array<RecentBundleMissionInfo>();
    PcSmartDockModel.getInstance().fillRecentMissionInfoList(appList, containerSessionList, recentMissionsList);
    expect(recentMissionsList).not().assertUndefined();
  } catch {
    expect(false).assertTrue();
  }
}

function test_checkAppInstanceKey_01() {
  try {
    let appInstanceKey: string = '';
    let toAppInstanceKey: string = '';
    let result: boolean = PcSmartDockModel.getInstance().checkAppInstanceKey(appInstanceKey, toAppInstanceKey);
    expect(result).assertTrue();
  } catch {
    expect(false).assertTrue();
  }
}

function test_checkAppInstanceKey_02() {
  try {
    let appInstanceKey: string = CommonConstants.GRIDSWIPER_STACK_ID;
    let toAppInstanceKey: string = '';
    let result: boolean = PcSmartDockModel.getInstance().checkAppInstanceKey(appInstanceKey, toAppInstanceKey);
    expect(result).assertFalse();
  } catch {
    expect(false).assertTrue();
  }
}

function test_checkAppInstanceKey_03() {
  try {
    let appInstanceKey: string = '';
    let toAppInstanceKey: string = CommonConstants.GRIDSWIPER_STACK_ID;
    let result: boolean = PcSmartDockModel.getInstance().checkAppInstanceKey(appInstanceKey, toAppInstanceKey);
    expect(result).assertFalse();
  } catch {
    expect(false).assertTrue();
  }
}

function test_checkAppInstanceKey_04() {
  try {
    let appInstanceKey: string = CommonConstants.GRIDSWIPER_STACK_ID;
    let toAppInstanceKey: string = CommonConstants.GRIDSWIPER_STACK_ID;
    let result: boolean = PcSmartDockModel.getInstance().checkAppInstanceKey(appInstanceKey, toAppInstanceKey);
    expect(result).assertTrue();
  } catch {
    expect(false).assertTrue();
  }
}

function test_oobeEventListen() {
  try {
    PcSmartDockModel.getInstance().oobeEventListen();
  } catch {
    expect(false).assertTrue();
  }
}

function test_onOOBEChange_01() {
  try {
    PcSmartDockModel.getInstance().onOOBEChange(true);
  } catch {
    expect(false).assertTrue();
  }
}

function test_onOOBEChange_02() {
  try {
    PcSmartDockModel.getInstance().onOOBEChange(false);
  } catch {
    expect(false).assertTrue();
  }
}

function test_vpnEventListen() {
  try {
    PcSmartDockModel.getInstance().vpnEventListen();
  } catch {
    expect(false).assertTrue();
  }
}

function test_checkIsSameItem() {
  try {
    let dockItem: DockItemInfo = new DockItemInfo();
    dockItem.bundleName = "test_bundleName";
    dockItem.abilityName = "test_abilityName";
    dockItem.appIndex = 0;
    dockItem.appInstanceKey = "test_appInstanceKey";
    dockItem.persistentId = "test_persistentId";
    let item: DockItemInfo = new DockItemInfo();
    item.bundleName = "test_bundleName";
    item.abilityName = "test_abilityName";
    item.appIndex = 0;
    item.appInstanceKey = "test_appInstanceKey";
    item.persistentId = "test_persistentId";
    let result: boolean = PcSmartDockModel.getInstance().checkIsSameItem(dockItem, item);
    expect(result).assertTrue();
  } catch {
    expect(false).assertTrue();
  }
}

function test_excludeInCollaborationList_01() {
  let collaborationDataList_originalData: RecentBundleMissionInfo[] | undefined =
    AppStorage.get('collaborationDataList');
  try {
    let recentMissionsList: Array<RecentBundleMissionInfo> = new Array<RecentBundleMissionInfo>();
    let recentInfo: RecentBundleMissionInfo = new RecentBundleMissionInfo();
    recentInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
    recentInfo.abilityName = CommonConstants.BROWSER_ABILITY;
    recentInfo.typeId = 0;
    recentInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
    recentInfo.appIndex = 0;
    recentMissionsList.push(recentInfo);

    let collaborationDataList: RecentBundleMissionInfo[] = [];
    AppStorage.setOrCreate('collaborationDataList', collaborationDataList);

    let result: Array<RecentBundleMissionInfo> =
      PcSmartDockModel.getInstance().excludeInCollaborationList(recentMissionsList);
    let isEmpty: boolean = CheckEmptyUtils.isEmptyArr(result);
    expect(isEmpty).assertFalse();
  } catch {
    expect(false).assertTrue();
  } finally {
    AppStorage.setOrCreate('collaborationDataList', collaborationDataList_originalData);
  }
}

function test_excludeInCollaborationList_02() {
  let collaborationDataList_originalData: RecentBundleMissionInfo[] | undefined =
    AppStorage.get('collaborationDataList');
  try {
    let recentMissionsList: Array<RecentBundleMissionInfo> = new Array<RecentBundleMissionInfo>();
    let recentInfo: RecentBundleMissionInfo = new RecentBundleMissionInfo();
    recentInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
    recentInfo.abilityName = CommonConstants.BROWSER_ABILITY;
    recentInfo.typeId = 0;
    recentInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
    recentInfo.appIndex = 0;
    recentMissionsList.push(recentInfo);

    let collaborationDataList: RecentBundleMissionInfo[] = [];
    let collaborationData: RecentBundleMissionInfo = new RecentBundleMissionInfo();
    collaborationData.bundleName = CommonConstants.LAUNCHER_BUNDLE;
    collaborationData.abilityName = CommonConstants.BROWSER_ABILITY;
    collaborationData.typeId = 0;
    collaborationData.areaType = CommonConstants.TYPE_AREA_DOCK;
    collaborationData.appIndex = 1;
    collaborationDataList.push(collaborationData);
    AppStorage.setOrCreate('collaborationDataList', collaborationDataList);

    let result: Array<RecentBundleMissionInfo> =
      PcSmartDockModel.getInstance().excludeInCollaborationList(recentMissionsList);
    let isEmpty: boolean = CheckEmptyUtils.isEmptyArr(result);
    expect(isEmpty).assertFalse();
  } catch {
    expect(false).assertTrue();
  } finally {
    AppStorage.setOrCreate('collaborationDataList', collaborationDataList_originalData);
  }
}

// 覆盖updateAppInstanceKeyInResident：if (!bundleName) {
function test_updateAppInstanceKeyInResident_01() {
  try {
    PcSmartDockModel.getInstance().updateAppInstanceKeyInResident();
  } catch {
    expect(false).assertTrue();
  }
}

// 覆盖updateAppInstanceKeyInResident：this.clearAppInstanceKeyInResident(bundleName);
function test_updateAppInstanceKeyInResident_02() {
  try {
    let persistentId: number = 0;
    let bundleName: string = 'test_bundleName';
    let appInstanceKey: string = 'test_appInstanceKey';
    PcSmartDockModel.getInstance().addItemToSessionMap(persistentId, bundleName, appInstanceKey);
    PcSmartDockModel.getInstance().updateAppInstanceKeyInResident(persistentId);
  } catch {
    expect(false).assertTrue();
  } finally {
    PcSmartDockModel.getInstance().clearSessionMap();
  }
}

// 覆盖swapAppInstanceKeyInResident: if (!appInstanceKey) {
function test_updateAppInstanceKeyInResident_03() {
  try {
    let bundleName: string = 'test_bundleName';
    let persistentId1: number = 1;
    let appInstanceKey1: string = '';
    let persistentId2: number = 2;
    let appInstanceKey2: string = 'test_appInstanceKey2';
    let persistentId3: number = 3;
    let appInstanceKey3: string = 'test_appInstanceKey3';
    PcSmartDockModel.getInstance().addItemToSessionMap(persistentId1, bundleName, appInstanceKey1);
    PcSmartDockModel.getInstance().addItemToSessionMap(persistentId2, bundleName, appInstanceKey2);
    PcSmartDockModel.getInstance().addItemToSessionMap(persistentId3, bundleName, appInstanceKey3);
    PcSmartDockModel.getInstance().updateAppInstanceKeyInResident(persistentId1);
  } catch {
    expect(false).assertTrue();
  } finally {
    PcSmartDockModel.getInstance().clearSessionMap();
  }
}

// 覆盖swapAppInstanceKeyInResident：if (!itemInResident?.appInstanceKey) {
function test_updateAppInstanceKeyInResident_04() {
  try {
    let bundleName: string = 'test_bundleName';
    let persistentId1: number = 1;
    let appInstanceKey1: string = 'test_appInstanceKey1';
    let persistentId2: number = 2;
    let appInstanceKey2: string = 'test_appInstanceKey2';
    let persistentId3: number = 3;
    let appInstanceKey3: string = 'test_appInstanceKey3';
    PcSmartDockModel.getInstance().addItemToSessionMap(persistentId1, bundleName, appInstanceKey1);
    PcSmartDockModel.getInstance().addItemToSessionMap(persistentId2, bundleName, appInstanceKey2);
    PcSmartDockModel.getInstance().addItemToSessionMap(persistentId3, bundleName, appInstanceKey3);

    let residentList: DockItemInfo[] = [];
    let dockItem: DockItemInfo = new DockItemInfo();
    dockItem.bundleName = bundleName;
    dockItem.appInstanceKey = "";
    residentList.push(dockItem);
    ResidentLayoutCacheMgr.getInstance().updateAllDockItems("", residentList);

    PcSmartDockModel.getInstance().updateAppInstanceKeyInResident(persistentId1);
  } catch {
    expect(false).assertTrue();
  } finally {
    ResidentLayoutCacheMgr.getInstance().clearCacheAndInit("");
    PcSmartDockModel.getInstance().clearSessionMap();
  }
}

// 覆盖swapAppInstanceKeyInResident：if (isFromResident && !hasRunningAppInResident) {
function test_updateAppInstanceKeyInResident_05() {
  try {
    let bundleName: string = 'test_bundleName';
    let persistentId1: number = 1;
    let appInstanceKey1: string = 'test_appInstanceKey1';
    let persistentId2: number = 2;
    let appInstanceKey2: string = 'test_appInstanceKey2';
    let persistentId3: number = 3;
    let appInstanceKey3: string = 'test_appInstanceKey3';
    PcSmartDockModel.getInstance().addItemToSessionMap(persistentId1, bundleName, appInstanceKey1);
    PcSmartDockModel.getInstance().addItemToSessionMap(persistentId2, bundleName, appInstanceKey2);
    PcSmartDockModel.getInstance().addItemToSessionMap(persistentId3, bundleName, appInstanceKey3);

    let residentList: DockItemInfo[] = [];
    let dockItem: DockItemInfo = new DockItemInfo();
    dockItem.bundleName = bundleName;
    dockItem.appInstanceKey = appInstanceKey1;
    residentList.push(dockItem);
    ResidentLayoutCacheMgr.getInstance().updateAllDockItems("", residentList);

    PcSmartDockModel.getInstance().updateAppInstanceKeyInResident(persistentId1);
  } catch {
    expect(false).assertTrue();
  } finally {
    ResidentLayoutCacheMgr.getInstance().clearCacheAndInit("");
    PcSmartDockModel.getInstance().clearSessionMap();
  }
}

// 覆盖swapAppInstanceKeyInResident：if (!isFromResident && hasRunningAppInResident) {
function test_updateAppInstanceKeyInResident_06() {
  let missionInfoList: RecentBundleMissionInfo[] = AppStorage.get('missionInfoList') as RecentBundleMissionInfo[];
  try {
    let bundleName: string = 'test_bundleName';
    let persistentId1: number = 1;
    let appInstanceKey1: string = 'test_appInstanceKey1';
    let persistentId2: number = 2;
    let appInstanceKey2: string = 'test_appInstanceKey2';
    let persistentId3: number = 3;
    let appInstanceKey3: string = 'test_appInstanceKey3';
    PcSmartDockModel.getInstance().addItemToSessionMap(persistentId1, bundleName, appInstanceKey1);
    PcSmartDockModel.getInstance().addItemToSessionMap(persistentId2, bundleName, appInstanceKey2);
    PcSmartDockModel.getInstance().addItemToSessionMap(persistentId3, bundleName, appInstanceKey3);

    let residentList: DockItemInfo[] = [];
    let dockItem: DockItemInfo = new DockItemInfo();
    dockItem.bundleName = bundleName;
    dockItem.appInstanceKey = "test_appInstanceKey4";
    dockItem.appIndex = 0;
    residentList.push(dockItem);
    ResidentLayoutCacheMgr.getInstance().updateAllDockItems("", residentList);

    let list: RecentBundleMissionInfo[] = [];
    list.push(dockItem);
    AppStorage.setOrCreate("missionInfoList", list);

    PcSmartDockModel.getInstance().updateAppInstanceKeyInResident(persistentId1);
  } catch {
    expect(false).assertTrue();
  } finally {
    ResidentLayoutCacheMgr.getInstance().clearCacheAndInit("");
    AppStorage.setOrCreate("missionInfoList", missionInfoList);
    PcSmartDockModel.getInstance().clearSessionMap();
  }
}

// 覆盖swapAppInstanceKeyInResident：if (instanceIds.includes(NaN)) {
function test_updateAppInstanceKeyInResident_07() {
  let missionInfoList: RecentBundleMissionInfo[] = AppStorage.get('missionInfoList') as RecentBundleMissionInfo[];
  try {
    let bundleName: string = 'test_bundleName';
    let persistentId1: number = 1;
    let appInstanceKey1: string = 'test_appInstanceKey1';
    let persistentId2: number = 2;
    let appInstanceKey2: string = 'test_appInstanceKey2';
    let persistentId3: number = 3;
    let appInstanceKey3: string = 'test_appInstanceKey3';
    PcSmartDockModel.getInstance().addItemToSessionMap(persistentId1, bundleName, appInstanceKey1);
    PcSmartDockModel.getInstance().addItemToSessionMap(persistentId2, bundleName, appInstanceKey2);
    PcSmartDockModel.getInstance().addItemToSessionMap(persistentId3, bundleName, appInstanceKey3);

    let residentList: DockItemInfo[] = [];
    let dockItem: DockItemInfo = new DockItemInfo();
    dockItem.bundleName = bundleName;
    dockItem.appInstanceKey = appInstanceKey1;
    residentList.push(dockItem);
    ResidentLayoutCacheMgr.getInstance().updateAllDockItems("", residentList);

    let list: RecentBundleMissionInfo[] = [];
    list.push(dockItem);
    AppStorage.setOrCreate("missionInfoList", list);

    PcSmartDockModel.getInstance().updateAppInstanceKeyInResident(persistentId1);
  } catch {
    expect(false).assertTrue();
  } finally {
    ResidentLayoutCacheMgr.getInstance().clearCacheAndInit("");
    AppStorage.setOrCreate("missionInfoList", missionInfoList);
    PcSmartDockModel.getInstance().clearSessionMap();
  }
}

// 覆盖swapAppInstanceKeyInResident：let max = Math.max(...instanceIds);
function test_updateAppInstanceKeyInResident_08() {
  let missionInfoList: RecentBundleMissionInfo[] = AppStorage.get('missionInfoList') as RecentBundleMissionInfo[];
  try {
    let bundleName: string = 'test_bundleName';
    let persistentId1: number = 1;
    let appInstanceKey1: string = 'test_appInstanceKey_1';
    let persistentId2: number = 2;
    let appInstanceKey2: string = 'test_appInstanceKey_2';
    let persistentId3: number = 3;
    let appInstanceKey3: string = 'test_appInstanceKey_3';
    PcSmartDockModel.getInstance().addItemToSessionMap(persistentId1, bundleName, appInstanceKey1);
    PcSmartDockModel.getInstance().addItemToSessionMap(persistentId2, bundleName, appInstanceKey2);
    PcSmartDockModel.getInstance().addItemToSessionMap(persistentId3, bundleName, appInstanceKey3);

    let residentList: DockItemInfo[] = [];
    let dockItem: DockItemInfo = new DockItemInfo();
    dockItem.bundleName = bundleName;
    dockItem.appInstanceKey = appInstanceKey1;
    residentList.push(dockItem);
    ResidentLayoutCacheMgr.getInstance().updateAllDockItems("", residentList);

    let list: RecentBundleMissionInfo[] = [];
    list.push(dockItem);
    AppStorage.setOrCreate("missionInfoList", list);

    PcSmartDockModel.getInstance().updateAppInstanceKeyInResident(persistentId1);
  } catch {
    expect(false).assertTrue();
  } finally {
    ResidentLayoutCacheMgr.getInstance().clearCacheAndInit("");
    AppStorage.setOrCreate("missionInfoList", missionInfoList);
    PcSmartDockModel.getInstance().clearSessionMap();
  }
}

function test_clearAppInstanceKeyInResident() {
  try {
    let residentList: DockItemInfo[] = [];
    let dockItem: DockItemInfo = new DockItemInfo();
    dockItem.bundleName = "test_bundleName";
    dockItem.appInstanceKey = "test_appInstanceKey";
    residentList.push(dockItem);
    ResidentLayoutCacheMgr.getInstance().updateAllDockItems('', residentList);
    PcSmartDockModel.getInstance().clearAppInstanceKeyInResident(dockItem.bundleName);
  } catch {
    expect(false).assertTrue();
  } finally {
    ResidentLayoutCacheMgr.getInstance().clearCacheAndInit("");
  }
}

function test_isDuplicate() {
  try {
    let list: AppItemInfo[] = [];
    let appInfo: AppItemInfo = new AppItemInfo();
    appInfo.keyName = "test_keyName";
    appInfo.appIndex = 0;
    appInfo.shortcutId = "test_shortcutId";
    list.push(appInfo);

    let result: boolean = PcSmartDockModel.getInstance().isDuplicate(list, appInfo);
    expect(result).assertTrue();
  } catch {
    expect(false).assertTrue();
  }
}

// 覆盖isInResidentList：if (recent.persistentId) {
function test_excludeInResidentFrom_01() {
  try {
    let residentList: DockItemInfo[] = [];
    let recentMissionsList: RecentBundleMissionInfo[] = [];
    let recentInfo: RecentBundleMissionInfo = new RecentBundleMissionInfo();
    recentInfo.persistentId = 'test_persistentId';
    recentMissionsList.push(recentInfo);

    PcSmartDockModel.getInstance().excludeInResidentFrom(residentList, recentMissionsList).then((infos) => {
      expect(infos).not().assertNull();
    });
  } catch {
    expect(false).assertTrue();
  }
}

// 覆盖isInResidentList：if (!SmartDockModel.getInstance().checkSameDockItem(dockItem, recent)) {
function test_excludeInResidentFrom_02() {
  try {
    let residentList: DockItemInfo[] = [];
    let residentItem: DockItemInfo = new DockItemInfo();
    residentItem.bundleName = 'test_bundleName';
    residentItem.appInstanceKey = '';
    residentItem.appIndex = 1;
    residentList.push(residentItem)

    let recentMissionsList: RecentBundleMissionInfo[] = [];
    let recentItem: RecentBundleMissionInfo = new RecentBundleMissionInfo();
    recentItem.bundleName = 'test_bundleName';
    recentItem.appInstanceKey = 'test_appInstanceKey';
    recentItem.appIndex = 0;
    recentMissionsList.push(recentItem);

    PcSmartDockModel.getInstance().excludeInResidentFrom(residentList, recentMissionsList).then((infos) => {
      expect(infos).not().assertNull();
    });
  } catch {
    expect(false).assertTrue();
  }
}

// 覆盖isInResidentList：if (!!dockItem.shortcutId || !!recent.shortcutId) {
function test_excludeInResidentFrom_03() {
  try {
    let residentList: DockItemInfo[] = [];
    let residentItem: DockItemInfo = new DockItemInfo();
    residentItem.bundleName = 'test_bundleName';
    residentItem.appInstanceKey = 'test_appInstanceKey';
    residentItem.appIndex = 0;
    residentItem.shortcutId = 'test_shortcutId';
    residentList.push(residentItem)

    let recentMissionsList: RecentBundleMissionInfo[] = [];
    let recentItem: RecentBundleMissionInfo = new RecentBundleMissionInfo();
    recentItem.bundleName = 'test_bundleName';
    recentItem.appInstanceKey = 'test_appInstanceKey';
    recentItem.appIndex = 0;
    recentItem.shortcutId = 'test_shortcutId';
    recentMissionsList.push(recentItem);

    PcSmartDockModel.getInstance().excludeInResidentFrom(residentList, recentMissionsList).then((infos) => {
      expect(infos).not().assertNull();
    });
  } catch {
    expect(false).assertTrue();
  }
}

function test_fillRecentTaskInfoWithPersistentId() {
  try {
    let recentInfo: RecentBundleMissionInfo = new RecentBundleMissionInfo();
    let containerSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList();
    if (!CheckEmptyUtils.isEmptyArr(containerSessionList)) {
      let sessions: SCBSceneSession[] = PcSmartDockModel.getInstance().getAllSession(containerSessionList[0]);
      if (!CheckEmptyUtils.isEmptyArr(sessions)) {
        PcSmartDockModel.getInstance().fillRecentTaskInfoWithPersistentId(recentInfo, sessions[0], true);
      }
    }
  } catch {
    expect(false).assertTrue();
  }
}

function test_buildMissionInfo() {
  try {
    let recentInfo: RecentBundleMissionInfo = new RecentBundleMissionInfo();
    recentInfo.bundleName = 'test_bundleName';
    recentInfo.appIndex = 0;
    recentInfo.appInstanceKey = 'test_appInstanceKey';
    recentInfo.persistentId = 'test_persistentId';

    let result: RecentBundleMissionInfo = PcSmartDockModel.getInstance().buildMissionInfo(recentInfo);
    let isSame: boolean = PcSmartDockModel.getInstance().checkSameDockItem(recentInfo, result);
    expect(isSame).assertTrue();
  } catch {
    expect(false).assertTrue();
  }
}

function test_addHideInRecentListSessions() {
  let containerSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList();
  try {

    if (!CheckEmptyUtils.isEmptyArr(containerSessionList)) {
      PcSmartDockModel.getInstance().addHideInRecentListSessions(containerSessionList[0]);
      PcSmartDockModel.getInstance().addHideInRecentListSessions(containerSessionList[0]);
    }
  } catch {
    expect(false).assertTrue();
  } finally {
    if (!CheckEmptyUtils.isEmptyArr(containerSessionList)) {
      PcSmartDockModel.getInstance().deleteHideInRecentListSessions(containerSessionList[0]);
      PcSmartDockModel.getInstance().deleteHideInRecentListSessions(containerSessionList[0]);
    }
  }
}

function test_getAbilityItemInfo() {
  let original_shortcutID: object | undefined = undefined;
  let parameters: Record<string, Object> | undefined = undefined;
  try {
    let containerSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList();
    if (!CheckEmptyUtils.isEmptyArr(containerSessionList)) {
      let allSession: Array<SCBSceneSession> = PcSmartDockModel.getInstance().getAllSession(containerSessionList[0]);
      if (!CheckEmptyUtils.isEmpty(allSession)) {
        parameters = allSession[0].sceneInfo?.want?.parameters;
        if (parameters) {
          original_shortcutID = parameters[SCBConstants.START_FROM_SHORTCUT_ID];
          parameters[SCBConstants.START_FROM_SHORTCUT_ID] = "test_shortcutID";
          PcSmartDockModel.getInstance().getAbilityItemInfo(allSession[0]);
        }
      }
    }
  } catch {
    expect(false).assertTrue();
  } finally {
    if (parameters && original_shortcutID) {
      parameters[SCBConstants.START_FROM_SHORTCUT_ID] = original_shortcutID;
    }
  }
}

function test_getAllSession() {
  try {
    let containerSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList();
    if (!CheckEmptyUtils.isEmptyArr(containerSessionList)) {
      containerSessionList[0].secondarySession = containerSessionList[0].primarySession;
      let allSession: Array<SCBSceneSession> = PcSmartDockModel.getInstance().getAllSession(containerSessionList[0]);
      expect(allSession).not().assertNull();
    }
  } catch {
    expect(false).assertTrue();
  }
}
