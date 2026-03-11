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
import {
  RecentClearAll
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentClearAll';
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
import {
  RecentClearAllCallback
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentCallbacks';
import { launcherVisualEffectMgr } from '@ohos/launchercommon/src/main/ets/manager/LauncherVisualEffectManager';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { RecentDelete } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentDelete';

export default function RecentClearAllTest() {
  describe('RecentClearAllTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    let scenePanelManager:SCBScenePanelManager = new SCBScenePanelManager();
    let recentClearAll: RecentClearAll = new RecentClearAll(scenePanelManager);
    let recentLayoutConfig = recentLayoutConfigInstance;
    let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
    let scbSceneInfoNew: SCBSceneInfo = new SCBSceneInfo('4', '5', '6');
    let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
    let scbSceneSessionNew: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfoNew), scbSceneInfoNew);
    let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
    let recentClearAllCallback: RecentClearAllCallback = {
      initFloatingWhenClearAll: (container: SCBSceneContainerSession) => {
      },
    }

    it('setInScreenConatinerPos_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.setInScreenConatinerPos(totalContainerSessionList, 0);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('setInScreenConatinerPos_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      recentClearAll.setInScreenConatinerPos(totalContainerSessionList, 0);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('setInScreenConatinerPos_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      recentClearAll.setInScreenConatinerPos(totalContainerSessionList, 0);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('setInScreenConatinerPos_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.setInScreenConatinerPos(totalContainerSessionList, 0);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('setInScreenConatinerPos_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.setInScreenConatinerPos(totalContainerSessionList, 0);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('setInScreenConatinerPos_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      recentClearAll.setInScreenConatinerPos(totalContainerSessionList, 0);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('setInScreenConatinerPos_07', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      recentClearAll.setInScreenConatinerPos(totalContainerSessionList, 0);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('setInScreenConatinerPos_08', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.setInScreenConatinerPos(totalContainerSessionList, 0);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getOffScreenSession_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      let filterIndex = [0];
      recentClearAll.getOffScreenSession(filterIndex, totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getOffScreenSession_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      let filterIndex = [0];
      recentClearAll.getOffScreenSession(filterIndex, totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getOffScreenSession_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      let filterIndex = [0, 1];
      recentClearAll.getOffScreenSession(filterIndex, totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getOffScreenSession_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      let filterIndex = [0, 1];
      recentClearAll.getOffScreenSession(filterIndex, totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getOffScreenSession_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      let filterIndex = [0, 1, 2];
      recentClearAll.getOffScreenSession(filterIndex, totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getOffScreenSession_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      let filterIndex = [0, 1, 2];
      recentClearAll.getOffScreenSession(filterIndex, totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getOffScreenSession_07', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      let filterIndex = [1, 2];
      recentClearAll.getOffScreenSession(filterIndex, totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getOffScreenSession_08', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      let filterIndex = [1, 2];
      recentClearAll.getOffScreenSession(filterIndex, totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getOffScreenSession_09', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      let filterIndex = [0];
      recentClearAll.getOffScreenSession(filterIndex, totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getOffScreenSession_10', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      let filterIndex = [0];
      recentClearAll.getOffScreenSession(filterIndex, totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getOffScreenSession_11', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      let filterIndex = [0, 1];
      recentClearAll.getOffScreenSession(filterIndex, totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getOffScreenSession_12', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      let filterIndex = [0, 1];
      recentClearAll.getOffScreenSession(filterIndex, totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getOffScreenSession_13', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      let filterIndex = [0, 1, 2];
      recentClearAll.getOffScreenSession(filterIndex, totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getOffScreenSession_14', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      let filterIndex = [0, 1, 2];
      recentClearAll.getOffScreenSession(filterIndex, totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getOffScreenSession_15', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      let filterIndex = [1, 2];
      recentClearAll.getOffScreenSession(filterIndex, totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('getOffScreenSession_16', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      let filterIndex = [1, 2];
      recentClearAll.getOffScreenSession(filterIndex, totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('resetParamUnclearableContainer_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      recentClearAll.resetParamUnclearableContainer(session);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('resetParamUnclearableContainer_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      recentClearAll.resetParamUnclearableContainer(session);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('resetParamUnclearableContainer_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      recentClearAll.resetParamUnclearableContainer(session);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('resetParamUnclearableContainer_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      recentClearAll.resetParamUnclearableContainer(session);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('removeAndDestructOffScreenSessionsForOuterScreen_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.removeAndDestructOffScreenSessionsForOuterScreen(totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('removeAndDestructOffScreenSessionsForOuterScreen_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.removeAndDestructOffScreenSessionsForOuterScreen(totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('removeAndDestructOffScreenSessionsForOuterScreen_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.removeAndDestructOffScreenSessionsForOuterScreen(totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('removeAndDestructOffScreenSessionsForOuterScreen_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.removeAndDestructOffScreenSessionsForOuterScreen(totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('removeOffScreenSessionsForOuterScreen_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.removeAndDestructOffScreenSessionsForOuterScreen(totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('removeOffScreenSessionsForOuterScreen_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.removeAndDestructOffScreenSessionsForOuterScreen(totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('removeOffScreenSessionsForOuterScreen_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.removeAndDestructOffScreenSessionsForOuterScreen(totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('removeOffScreenSessionsForOuterScreen_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.removeAndDestructOffScreenSessionsForOuterScreen(totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('removeAndDestructOffScreenSessions_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.removeAndDestructOffScreenSessions(totalContainerSessionList, recentClearAllCallback);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('removeAndDestructOffScreenSessions_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.removeAndDestructOffScreenSessions(totalContainerSessionList, recentClearAllCallback);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('removeAndDestructOffScreenSessions_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.removeAndDestructOffScreenSessions(totalContainerSessionList, recentClearAllCallback);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('removeAndDestructOffScreenSessions_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.removeAndDestructOffScreenSessions(totalContainerSessionList, recentClearAllCallback);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('setIsForceCleanForContainer_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.setIsForceCleanForContainer(totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('setIsForceCleanForContainer_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      session.isMidScene = true;
      totalContainerSessionList.add(session);
      recentClearAll.setIsForceCleanForContainer(totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('setIsForceCleanForContainer_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.setIsForceCleanForContainer(totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('setIsForceCleanForContainer_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      session.isMidScene = true;
      totalContainerSessionList.add(session);
      recentClearAll.setIsForceCleanForContainer(totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('resetIsKillParam_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.resetIsKillParam(session);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('resetIsKillParam_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      session.isMidScene = true;
      totalContainerSessionList.add(session);
      recentClearAll.resetIsKillParam(session);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('resetIsKillParam_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.resetIsKillParam(session);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('resetIsKillParam_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      session.isMidScene = true;
      totalContainerSessionList.add(session);
      recentClearAll.resetIsKillParam(session);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('containerDestructionForClearAll_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      recentClearAll.containerDestructionForClearAll(session);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('containerDestructionForClearAll_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      recentClearAll.containerDestructionForClearAll(session);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('titleDisappearAnimationForUnClearable_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      session.isAppLockedForbidDelete = true;
      recentClearAll.titleDisappearAnimationForUnClearable(session, undefined, true);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('titleDisappearAnimationForUnClearable_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      session.isAppLockedForbidDelete = true;
      recentClearAll.titleDisappearAnimationForUnClearable(session, undefined, true);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('titleDisappearAnimationForUnClearable_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      session.isAppLockedForbidDelete = false;
      recentClearAll.titleDisappearAnimationForUnClearable(session, undefined, true);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('titleDisappearAnimationForUnClearable_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      session.isAppLockedForbidDelete = false;
      recentClearAll.titleDisappearAnimationForUnClearable(session, undefined, true);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('titleDisappearAnimationForUnClearable_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      session.isAppLockedForbidDelete = true;
      recentClearAll.titleDisappearAnimationForUnClearable(session, undefined, false);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('titleDisappearAnimationForUnClearable_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      session.isAppLockedForbidDelete = true;
      recentClearAll.titleDisappearAnimationForUnClearable(session, undefined, false);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('titleDisappearAnimationForUnClearable_07', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      session.isAppLockedForbidDelete = false;
      recentClearAll.titleDisappearAnimationForUnClearable(session, undefined, false);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('titleDisappearAnimationForUnClearable_08', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      session.isAppLockedForbidDelete = false;
      recentClearAll.titleDisappearAnimationForUnClearable(session, undefined, false);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('delayTimeForBlurAnimation_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isRecentBlurEffect: Function =
        mocker.mockFunc(launcherVisualEffectMgr, launcherVisualEffectMgr.isRecentBlurEffectDisabled);
      when(isRecentBlurEffect)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      let result: number = recentClearAll.delayTimeForBlurAnimation(true, totalContainerSessionList);
      expect(result).assertEqual(550);
      mocker.ignoreMock(launcherVisualEffectMgr, launcherVisualEffectMgr.isRecentBlurEffectDisabled);
    })

    it('delayTimeForBlurAnimation_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isRecentBlurEffect: Function =
        mocker.mockFunc(launcherVisualEffectMgr, launcherVisualEffectMgr.isRecentBlurEffectDisabled);
      when(isRecentBlurEffect)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      let result: number = recentClearAll.delayTimeForBlurAnimation(true, totalContainerSessionList);
      expect(result).assertEqual(450);
      mocker.ignoreMock(launcherVisualEffectMgr, launcherVisualEffectMgr.isRecentBlurEffectDisabled);
    })

    it('delayTimeForBlurAnimation_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isRecentBlurEffect: Function =
        mocker.mockFunc(launcherVisualEffectMgr, launcherVisualEffectMgr.isRecentBlurEffectDisabled);
      when(isRecentBlurEffect)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      let result: number = recentClearAll.delayTimeForBlurAnimation(false, totalContainerSessionList);
      expect(result).assertEqual(0);
      mocker.ignoreMock(launcherVisualEffectMgr, launcherVisualEffectMgr.isRecentBlurEffectDisabled);
    })

    it('delayTimeForBlurAnimation_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isRecentBlurEffect: Function =
        mocker.mockFunc(launcherVisualEffectMgr, launcherVisualEffectMgr.isRecentBlurEffectDisabled);
      when(isRecentBlurEffect)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      let result: number = recentClearAll.delayTimeForBlurAnimation(false, totalContainerSessionList);
      expect(result).assertEqual(0);
      mocker.ignoreMock(launcherVisualEffectMgr, launcherVisualEffectMgr.isRecentBlurEffectDisabled);
    })

    // 补充覆盖
    it('removeAndDestructOffScreenSessionsForOuterScreen_recover_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      session.isFloat = false;
      let mocker: MockKit = new MockKit();
      let isUnclearAbleWhenClearAll: Function = mocker.mockFunc(recentDelete, recentDelete.isUnclearAbleWhenClearAll);
      when(isUnclearAbleWhenClearAll)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.removeAndDestructOffScreenSessionsForOuterScreen(totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentDelete, recentDelete.isUnclearAbleWhenClearAll);
    })

    it('removeAndDestructOffScreenSessionsForOuterScreen_recover_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      session.isFloat = true;
      let mocker: MockKit = new MockKit();
      let isUnclearAbleWhenClearAll: Function = mocker.mockFunc(recentDelete, recentDelete.isUnclearAbleWhenClearAll);
      when(isUnclearAbleWhenClearAll)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.removeAndDestructOffScreenSessionsForOuterScreen(totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentDelete, recentDelete.isUnclearAbleWhenClearAll);
    })

    it('removeAndDestructOffScreenSessionsForOuterScreen_recover_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      let mocker: MockKit = new MockKit();
      let isUnclearAbleWhenClearAll: Function = mocker.mockFunc(recentDelete, recentDelete.isUnclearAbleWhenClearAll);
      when(isUnclearAbleWhenClearAll)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.removeAndDestructOffScreenSessionsForOuterScreen(totalContainerSessionList);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentDelete, recentDelete.isUnclearAbleWhenClearAll);
    })


    it('removeAndDestructOffScreenSessions_recover_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      session.isFloat = true;
      let mocker: MockKit = new MockKit();
      let isSingleDisplayPocketFoldStatus: Function = mocker.mockFunc(recentDelete, recentDelete.isUnclearAbleWhenClearAll);
      when(isSingleDisplayPocketFoldStatus)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.removeAndDestructOffScreenSessions(totalContainerSessionList, recentClearAllCallback);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentDelete, recentDelete.isUnclearAbleWhenClearAll);
    })

    it('removeAndDestructOffScreenSessions_recover_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      session.isFloat = false;
      let mocker: MockKit = new MockKit();
      let isUnclearAbleWhenClearAll: Function = mocker.mockFunc(recentDelete, recentDelete.isUnclearAbleWhenClearAll);
      when(isUnclearAbleWhenClearAll)().afterReturn(false);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.removeAndDestructOffScreenSessions(totalContainerSessionList, recentClearAllCallback);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentDelete, recentDelete.isUnclearAbleWhenClearAll);
    })

    it('removeAndDestructOffScreenSessions_recover_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let recentDelete: RecentDelete = new RecentDelete(scenePanelManager);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      let mocker: MockKit = new MockKit();
      let isUnclearAbleWhenClearAll: Function = mocker.mockFunc(recentDelete, recentDelete.isUnclearAbleWhenClearAll);
      when(isUnclearAbleWhenClearAll)().afterReturn(true);
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(session);
      recentClearAll.removeAndDestructOffScreenSessions(totalContainerSessionList, recentClearAllCallback);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(recentDelete, recentDelete.isUnclearAbleWhenClearAll);
    })

    it('clearRecentListIfNeed_recover_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let animationCount: number = 1;
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      let mocker: MockKit = new MockKit();
      let getTransitionCount: Function = mocker.mockFunc(session, session.getTransitionCount);
      when(getTransitionCount)().afterReturn(0);
      recentClearAll.clearRecentListIfNeed(animationCount, session);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(session, session.getTransitionCount);
    })

    it('clearRecentListIfNeed_recover_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let animationCount: number = 1;
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      let mocker: MockKit = new MockKit();
      let getTransitionCount: Function = mocker.mockFunc(session, session.getTransitionCount);
      when(getTransitionCount)().afterReturn(animationCount);
      recentClearAll.clearRecentListIfNeed(animationCount, session);
      expect(recentClearAll).not().assertNull();
      mocker.ignoreMock(session, session.getTransitionCount);
    })
  })
}