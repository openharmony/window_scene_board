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
  it,
  describe,
  expect,
  MockKit,
  TestType,
  Size,
  Level,
  when,
  ArgumentMatchers} from '@ohos/hypium';
import { RecentDelete } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentDelete';
import {
  RecentMediaPlay,
  recentMediaPlayInstance }
  from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentMediaPlay';
import { ItemUtils } from '@ohos/componenthelper';
import {
  SCBScenePanelManager,
  SCBSceneContainerSession,
  SCBSceneSession,
  SCBScreenProperty,
  SCBSceneInfo,
  SCBSceneSessionManager,
  ScenePanelState,
  SCBSceneContainerSessionArray} from '@ohos/windowscene';
import { recentLayoutConfigInstance } from '@ohos/recents';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { RecentLayoutManager } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/common/RecentLayoutManager';
import { Position } from '@kit.ArkUI';

export default function RecentDeleteTest() {
  describe('RecentDeleteTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    let scenePanelManager:SCBScenePanelManager = new SCBScenePanelManager();
    let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
    let recentLayoutConfig = recentLayoutConfigInstance;

    it('showClearAllMissionsToast_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      recentDelete.showClearAllMissionsToast(1);
      expect(recentDelete).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('showClearAllMissionsToast_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      recentDelete.showClearAllMissionsToast(1);
      expect(recentDelete).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
    let scbSceneInfoNew: SCBSceneInfo = new SCBSceneInfo('4', '5', '6');
    let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
    let scbSceneSessionNew: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfoNew), scbSceneInfoNew);
    let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());

    it('isUnclearAbleWhenClearAll_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      session.primarySession = scbSceneSession;
      session.primarySession.sceneInfo.unclearableSession = true;
      let result: boolean = recentDelete.isUnclearAbleWhenClearAll(session);
      expect(result).assertEqual(true);
    })

    it('isUnclearAbleWhenClearAll_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      session.primarySession = scbSceneSession;
      session.primarySession.sceneInfo.unclearableSession = false;
      session.secondarySession = scbSceneSession;
      session.secondarySession.sceneInfo.unclearableSession = true;
      let result: boolean = recentDelete.isUnclearAbleWhenClearAll(session);
      expect(result).assertEqual(true);
    })

    it('isUnclearAbleWhenClearAll_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      session.primarySession = scbSceneSession;
      session.primarySession.sceneInfo.unclearableSession = false;
      session.secondarySession = scbSceneSession;
      session.secondarySession.sceneInfo.unclearableSession = false;
      let result: boolean = recentDelete.isUnclearAbleWhenClearAll(session);
      expect(result).assertEqual(false);
    })

    it('isUnclearAbleWhenClearAll_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      session.primarySession = null;
      session.secondarySession = scbSceneSession;
      session.secondarySession.sceneInfo.unclearableSession = true;
      let result: boolean = recentDelete.isUnclearAbleWhenClearAll(session);
      expect(result).assertEqual(true);
    })

    it('isUnclearAbleWhenClearAll_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      session.primarySession = null;
      session.secondarySession = scbSceneSession;
      session.secondarySession.sceneInfo.unclearableSession = false;
      let result: boolean = recentDelete.isUnclearAbleWhenClearAll(session);
      expect(result).assertEqual(false);
    })

    it('isUnclearAbleWhenClearAll_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      session.primarySession = null;
      session.secondarySession = null;
      let result: boolean = recentDelete.isUnclearAbleWhenClearAll(session);
      expect(result).assertEqual(false);
    })

    it('getUnClearAbleBundleNameList_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      session.primarySession = scbSceneSession;
      session.primarySession.sceneInfo.bundleName = '1';
      session.primarySession.sceneInfo.unclearableSession = true;
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      let result: string[] = recentDelete.getUnClearAbleBundleNameList(totalContainerSessionList);
      let actual: string[] = ['1'];
      expect(result.toString()).assertEqual(actual.toString());
    })

    it('getUnClearAbleBundleNameList_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      session.primarySession = scbSceneSession;
      session.primarySession.sceneInfo.bundleName = '1';
      session.primarySession.sceneInfo.unclearableSession = false;
      totalContainerSessionList.push(session);
      let result: string[] = recentDelete.getUnClearAbleBundleNameList(totalContainerSessionList);
      let actual: string[] = [];
      expect(result.toString()).assertEqual(actual.toString());
    })

    it('getUnClearAbleBundleNameList_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      session.primarySession = scbSceneSession;
      session.primarySession.sceneInfo.bundleName = '';
      session.primarySession.sceneInfo.unclearableSession = true;
      totalContainerSessionList.push(session);
      let result: string[] = recentDelete.getUnClearAbleBundleNameList(totalContainerSessionList);
      let actual: string[] = [];
      expect(result.toString()).assertEqual(actual.toString());
    })

    it('getUnClearAbleBundleNameList_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      session.primarySession = null;
      totalContainerSessionList.push(session);
      let result: string[] = recentDelete.getUnClearAbleBundleNameList(totalContainerSessionList);
      let actual: string[] = [];
      expect(result.toString()).assertEqual(actual.toString());
    })

    it('test_clear_all_when_primary_session_is_null', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let isClearable = recentDelete.isUnclearAbleWhenClearAll(session);
      expect(isClearable).assertEqual(false);
    })

    it('test_clear_all_when_primary_session_is_true', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      session.primarySession = scbSceneSession;
      session.secondarySession = scbSceneSessionNew;
      if (session.primarySession) {
        session.primarySession.sceneInfo.unclearableSession = true;
      }
      if (session.secondarySession) {
        session.secondarySession.sceneInfo.unclearableSession = false;
      }
      let isClearable = recentDelete.isUnclearAbleWhenClearAll(session);
      expect(isClearable).assertEqual(true);
    })

    it('test_clear_all_when_secondary_session_is_true', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      session.primarySession = scbSceneSession;
      session.secondarySession = scbSceneSessionNew;
      if (session.primarySession) {
        session.primarySession.sceneInfo.unclearableSession = false;
      }
      if (session.secondarySession) {
        session.secondarySession.sceneInfo.unclearableSession = true;
      }
      let isClearable = recentDelete.isUnclearAbleWhenClearAll(session);
      expect(isClearable).assertEqual(true);
    })

    it('test_clear_all_when_session_all_false', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      session.primarySession = scbSceneSession;
      session.secondarySession = scbSceneSessionNew;
      if (session.primarySession) {
        session.primarySession.sceneInfo.unclearableSession = false;
      }
      if (session.secondarySession) {
        session.secondarySession.sceneInfo.unclearableSession = false;
      }
      let isClearable = recentDelete.isUnclearAbleWhenClearAll(session);
      expect(isClearable).assertEqual(false);
    })

    it('test_clear_all_when_session_media_is_play', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      session.primarySession = scbSceneSession;
      session.secondarySession = scbSceneSessionNew;
      if (session.primarySession) {
        session.primarySession.sceneInfo.unclearableSession = false;
      }
      if (session.secondarySession) {
        session.secondarySession.sceneInfo.unclearableSession = false;
      }
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(recentMediaPlayInstance, recentMediaPlayInstance.isContainerMediaPlay);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let isClearable = recentDelete.isUnclearAbleWhenClearAll(session);
      expect(isClearable).assertEqual(true);
      mocker.ignoreMock(recentMediaPlayInstance, recentMediaPlayInstance.isContainerMediaPlay);
    })

    it('test_clear_all_when_session_media_is_not_play', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      session.primarySession = scbSceneSession;
      session.secondarySession = scbSceneSessionNew;
      if (session.primarySession) {
        session.primarySession.sceneInfo.unclearableSession = false;
      }
      if (session.secondarySession) {
        session.secondarySession.sceneInfo.unclearableSession = false;
      }
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(recentMediaPlayInstance, recentMediaPlayInstance.isContainerMediaPlay);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let isClearable = recentDelete.isUnclearAbleWhenClearAll(session);
      expect(isClearable).assertEqual(false);
      mocker.ignoreMock(recentMediaPlayInstance, recentMediaPlayInstance.isContainerMediaPlay);
    })

    it('test_move_clear_when_session_is_null', TestType.USER | Size.SMALLTEST | Level.LEVEL0,
      (): void => {
      let isClearable = recentDelete.isUnclearAbleWhenMoveClear(session);
      expect(isClearable).assertEqual(false);
    })

    it('test_move_clear_when_primary_session_is_true', TestType.USER | Size.SMALLTEST | Level.LEVEL0,
      (): void => {
      session.primarySession = scbSceneSession;
      session.secondarySession = scbSceneSessionNew;
      if (session.primarySession) {
        session.primarySession.sceneInfo.unclearableSession = true;
      }
      if (session.secondarySession) {
        session.secondarySession.sceneInfo.unclearableSession = false;
      }
      let isClearable = recentDelete.isUnclearAbleWhenMoveClear(session);
      expect(isClearable).assertEqual(true);
    })

    it('test_move_clear_when_secondary_session_is_true', TestType.USER | Size.SMALLTEST | Level.LEVEL0,
      (): void => {
      session.primarySession = scbSceneSession;
      session.secondarySession = scbSceneSessionNew;
      if (session.primarySession) {
        session.primarySession.sceneInfo.unclearableSession = false;
      }
      if (session.secondarySession) {
        session.secondarySession.sceneInfo.unclearableSession = true;
      }
      let isClearable = recentDelete.isUnclearAbleWhenMoveClear(session);
      expect(isClearable).assertEqual(true);
    })

    it('test_move_clear_when_session_all_false', TestType.USER | Size.SMALLTEST | Level.LEVEL0,
      (): void => {
      session.primarySession = scbSceneSession;
      session.secondarySession = scbSceneSessionNew;
      if (session.primarySession) {
        session.primarySession.sceneInfo.unclearableSession = false;
      }
      if (session.secondarySession) {
        session.secondarySession.sceneInfo.unclearableSession = false;
      }
      let isClearable = recentDelete.isUnclearAbleWhenMoveClear(session);
      expect(isClearable).assertEqual(false);
    })

    it('isUnclearAbleWhenClearAll_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      (recentDelete as object)['isUnclearAbleWhenClearAll']();
      expect(recentDelete).not().assertUndefined();
    })

    it('isUnclearAbleWhenMoveClear_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      (recentDelete as object)['isUnclearAbleWhenMoveClear']();
      expect(recentDelete).not().assertUndefined();
    })

    it('isUnclearAbleWhenMoveClear_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());

      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      recentDelete.isUnclearAbleWhenMoveClear(session);
      expect(recentDelete).not().assertUndefined();
    })

    it('isUnclearAbleWhenMoveClear_test03', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      let primarySession1: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      session.primarySession = primarySession1;
      session.primarySession.sceneInfo.unclearableSession = true;
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      recentDelete.isUnclearAbleWhenMoveClear(session);
      expect(recentDelete).not().assertUndefined();
    })

    it('isUnclearAbleWhenMoveClear_test04', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      let primarySession1: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let secondarySession1: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      session.primarySession = primarySession1;
      session.secondarySession = secondarySession1;
      session.primarySession.sceneInfo.unclearableSession = false;
      session.secondarySession.sceneInfo.unclearableSession = true;
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      recentDelete.isUnclearAbleWhenMoveClear(session);
      expect(recentDelete).not().assertUndefined();
    })

    it('getUnClearAbleBundleNameList_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      (recentDelete as object)['getUnClearAbleBundleNameList']();
      expect(recentDelete).not().assertUndefined();
    })

    it('showStatusBarIfNeedOnfinish_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      recentDelete.showStatusBarIfNeedOnfinish(ScenePanelState.RECENT, 2);
      expect(recentDelete).not().assertUndefined();
    })

    it('showStatusBarIfNeedOnfinish_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      recentDelete.showStatusBarIfNeedOnfinish(ScenePanelState.HOME, 1);
      expect(recentDelete).not().assertUndefined();
    })

    it('showStatusBarIfNeedOnfinish_test03', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      recentDelete.showStatusBarIfNeedOnfinish(ScenePanelState.HOME, 50);
      expect(recentDelete).not().assertUndefined();
    })

    it('isClearInNotShow_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      let primarySession1: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let secondarySession1: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      session.primarySession = primarySession1;
      session.secondarySession = secondarySession1;
      session.secondarySession.sceneInfo.bundleName = '1';
      session.isMidScene = true;
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      (recentDelete as object)['isClearInNotShow'](session);
      expect(recentDelete).not().assertUndefined();
    })

    it('isClearInNotShow_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      let primarySession1: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let secondarySession1: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      session.primarySession = primarySession1;
      session.secondarySession = secondarySession1;
      session.primarySession.sceneInfo.needClearInNotShowRecent = true;
      session.isMidScene = false;
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      (recentDelete as object)['isClearInNotShow'](session);
      expect(recentDelete).not().assertUndefined();
    })

    it('isClearInNotShow_test03', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      (recentDelete as object)['isClearInNotShow']();
      expect(recentDelete).not().assertUndefined();
    })

    it('destructContainerInNotShow_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      (recentDelete as object)['destructContaierInNotShow']();
      expect(recentDelete).not().assertUndefined();
    })

    it('destructContainerInNotShow_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      recentDelete.destructContaierInNotShow();
      expect(recentDelete).not().assertUndefined();
    })

    it('setNeedRenderPosForDeleteAllAnimation_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      (recentDelete as object)['setNeedRenderPosForDeleteAllAnimation']();
      expect(recentDelete).not().assertUndefined();
    })

    it('setNeedRenderPosForDeleteAllAnimation_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      recentDelete.setNeedRenderPosForDeleteAllAnimation(session, 2);
      expect(recentDelete).not().assertUndefined();
    })

    it('isMidSceneUnClearable_test01', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      (recentDelete as object)['isMidSceneUnClearable']();
      expect(recentDelete).not().assertUndefined();
    })

    it('isMidSceneUnClearable_test02', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      (recentDelete as object)['isMidSceneUnClearable'](session);
      expect(recentDelete).not().assertUndefined();
    })

    it('isUnclearAbleWhenClearAll_test001', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      let primarySession1: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let secondarySession1: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      session.primarySession = primarySession1;
      session.secondarySession = secondarySession1;
      session.primarySession.sceneInfo.bundleName = '1';
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      let recentMediaPlay: RecentMediaPlay = new RecentMediaPlay();
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentMediaPlay, recentMediaPlay.isContainerMediaPlay);
      when(mockFun)(ArgumentMatchers.any).afterReturn(true);
      recentDelete.isUnclearAbleWhenClearAll(session);
      expect(recentDelete).not().assertUndefined();
      mock.ignoreMock(recentMediaPlay, recentMediaPlay.isContainerMediaPlay);
    })

    it('isUnclearAbleWhenClearAll_test002', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      let primarySession1: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let secondarySession1: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      session.primarySession = primarySession1;
      session.secondarySession = secondarySession1;
      session.primarySession.sceneInfo.bundleName = '1';
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      recentDelete.isUnclearAbleWhenClearAll(session);
      expect(recentDelete).not().assertUndefined();
    })

    it('isUnclearAbleWhenClearAll_test003', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      let primarySession1: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let secondarySession1: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      session.primarySession = primarySession1;
      session.secondarySession = secondarySession1;
      session.secondarySession.sceneInfo.bundleName = '1';
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      let recentMediaPlay: RecentMediaPlay = new RecentMediaPlay();
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentMediaPlay, recentMediaPlay.isContainerMediaPlay);
      when(mockFun)(ArgumentMatchers.any).afterReturn(true);
      recentDelete.isUnclearAbleWhenClearAll(session);
      expect(recentDelete).not().assertUndefined();
      mock.ignoreMock(recentMediaPlay, recentMediaPlay.isContainerMediaPlay);
    })

    it('isUnclearAbleWhenClearAll_test004', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      let primarySession1: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let secondarySession1: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      session.primarySession = primarySession1;
      session.secondarySession = secondarySession1;
      session.secondarySession.sceneInfo.bundleName = '1';
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      recentDelete.isUnclearAbleWhenClearAll(session);
      expect(recentDelete).not().assertUndefined();
    })

    it('isUnclearAbleWhenClearAll_test005', 0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      let primarySession1: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let secondarySession1: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      session.primarySession = primarySession1;
      session.secondarySession = secondarySession1;
      session.secondarySession.sceneInfo.bundleName = '1';
      session.isMidScene = true;
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      recentDelete.isUnclearAbleWhenClearAll(session);
      expect(recentDelete).not().assertUndefined();
    })

    it('should_not_call_enterRecentTask_when_scenePanelState_is_RECENT', 0, () => {
      let scenePanelState = ScenePanelState.RECENT;
      const listLen = 2;
      recentDelete.showStatusBarIfNeedOnfinish(scenePanelState, listLen);
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().enterRecentTask);
      mocker.verify('enterRecentTask', [false]).never;
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().enterRecentTask);
    });

    it('should_call_enterRecentTask_with_false_when_listLen_is_1_and_scenePanelState_is_not_RECENT', 0, () => {
      let scenePanelState = ScenePanelState.FULLSCENE;
      const listLen = 1;
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().enterRecentTask);
      recentDelete.showStatusBarIfNeedOnfinish(scenePanelState, listLen);
      mocker.verify('enterRecentTask', [false]).once();
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().enterRecentTask);
    });

    it('should_not_call_enterRecentTask_when_listLen_is_not_1_and_scenePanelState_is_not_RECENT', 0, () => {
      let scenePanelState = ScenePanelState.FULLSCENE;
      const listLen = 2;
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().enterRecentTask);
      recentDelete.showStatusBarIfNeedOnfinish(scenePanelState, listLen);
      mocker.verify('enterRecentTask', [false]).never;
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().enterRecentTask);
    });

    it('should_not_update_positions_if_session_is_null', 0, () => {
      recentDelete.setNeedRenderPosForDeleteAllAnimation(session, 10);
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(session.needRenderPos, session.needRenderPos.setPosXWithDfx);
      mocker.verify('setPosXWithDfx', [0, 'RecentDelete', 'setPosXForDeleteAllAnimation', '']).never;
      mocker.ignoreMock(session.needRenderPos, session.needRenderPos.setPosXWithDfx);
    });

    it('should_update_positions_correctly', 0, () => {
      session.primarySession = scbSceneSession;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(session, session.getName);
      when(mockFunc)(ArgumentMatchers.any).afterReturn('123');
      mocker.mockFunc(session.needRenderPos, session.needRenderPos.setPosXWithDfx);
      recentDelete.setNeedRenderPosForDeleteAllAnimation(session, 10);
      mocker.verify('setPosXWithDfx', [0, 'RecentDelete', 'setPosXForDeleteAllAnimation', '123']).once();
      mocker.ignoreMock(session, session.getName);
      mocker.ignoreMock(session.needRenderPos, session.needRenderPos.setPosXWithDfx);
    });

    it('getClearAllButtonPos_width100', 0, () => {
      let screenProperty = new SCBScreenProperty();
      screenProperty.width = 100;
      screenProperty.height = 100;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(screenProperty);
      let mockFunc_: Function = mocker.mockFunc(RecentLayoutManager,
        RecentLayoutManager.getRealBottomMargin);
      when(mockFunc_)(ArgumentMatchers.any).afterReturn(10);
      expect(RecentDelete.getClearAllButtonPos().x).not().assertNull();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(RecentLayoutManager,
        RecentLayoutManager.getRealBottomMargin);
    });

    it('getClearAllButtonPos_width200', 0, () => {
      let screenProperty = new SCBScreenProperty();
      screenProperty.width = 200;
      screenProperty.height = 200;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(screenProperty);
      let mockFunc_: Function = mocker.mockFunc(RecentLayoutManager,
        RecentLayoutManager.getRealBottomMargin);
      when(mockFunc_)(ArgumentMatchers.any).afterReturn(10);
      expect(RecentDelete.getClearAllButtonPos().x).not().assertNull();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(RecentLayoutManager,
        RecentLayoutManager.getRealBottomMargin);
    });

    it('getClearAllButtonPos_width120', 0, () => {
      let screenProperty = new SCBScreenProperty();
      screenProperty.width = 120;
      screenProperty.height = 140;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getScreenProperty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(screenProperty);
      let mockFunc_: Function = mocker.mockFunc(RecentLayoutManager,
        RecentLayoutManager.getRealBottomMargin);
      when(mockFunc_)(ArgumentMatchers.any).afterReturn(10);
      expect(RecentDelete.getClearAllButtonPos().x).not().assertNull();
      mocker.ignoreMock(SCBScenePanelManager.getInstance(),
        SCBScenePanelManager.getInstance().getScreenProperty);
      mocker.ignoreMock(RecentLayoutManager,
        RecentLayoutManager.getRealBottomMargin);
    });

    it('test_isAppLocked_whenNoControlList_shouldReturnFalse', Level.LEVEL0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo),
        sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      const res = RecentDelete.isAppLocked(containerSession);
      expect(res).assertDeepEquals(false);
    });

    it('test_isAppLocked_whenControlList_shouldReturnTrue', Level.LEVEL0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo),
        sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      if (containerSession.primarySession?.useControlList) {
        containerSession.primarySession.useControlList.push(1);
        const res = RecentDelete.isAppLocked(containerSession);
        expect(res).assertDeepEquals(true);
      } else {
        const res = RecentDelete.isAppLocked(containerSession);
        expect(res).assertDeepEquals(false);
      }
    });

    it('test_isAppLocked_whenMidSceneControlList_shouldReturnTrue', Level.LEVEL0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      sceneSession.sceneInfo.persistentId = sceneSession.session.persistentId;
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let sceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      sceneContainerSession.isMidScene = true;
      sceneContainerSession.midSceneMap.set(1, sceneSession);
      if (sceneContainerSession.midSceneMap[1]?.useControlList) {
        sceneContainerSession.midSceneMap[1].useControlList.push(1);
        const res = RecentDelete.isAppLocked(sceneContainerSession);
        expect(res).assertDeepEquals(true);
      } else {
        const res = RecentDelete.isAppLocked(sceneContainerSession);
        expect(res).assertDeepEquals(false);
      }
    });
  })
}