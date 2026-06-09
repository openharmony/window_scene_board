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
  TestType,
  Size,
  Level,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBScreenProperty,
  SCBSessionShowInScreenIndex,
  ScenePanelState
} from '@ohos/windowscene';

import { RecentExitCallback } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentCallbacks';
import { recentRuntimeInstance } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentRuntimeModel';
import { RecentExit } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentExit';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { recentLayoutConfigInstance } from '@ohos/recents';
import { RecentLayoutManager } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/common/RecentLayoutManager';
import SceneSessionManager from '@ohos.sceneSessionManager';
import curves from '@ohos.curves';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  SCBScenePanelViewModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/viewmodel/SCBScenePanelViewModel';
import { UIContext } from '@kit.ArkUI';

function getContainerSession(): SCBSceneContainerSession {
  let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
  let sceneSession = new SCBSceneSession(SceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  let screenProperty: SCBScreenProperty = new SCBScreenProperty();
  let session = new SCBSceneContainerSession(sceneSession, screenProperty);
  return session;
}

export default function RecentExitTest() {
  describe('RecentExitTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })
    let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
    let recentExit: RecentExit = new RecentExit(scenePanelManager);
    let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
    let primarySession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
    let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let scbSceneContainer: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    totalContainerSessionList.add(scbSceneContainer);
    totalContainerSessionList.add(scbSceneContainer);
    let recentLayoutConfig = recentLayoutConfigInstance;
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(new UIContext(), screenProperty);

    it('exitRecentWithAnimation_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbSceneContainer.needRenderShowInRecent.setShowInRecentWithDfx(false, 'exitRecentWithAnimation', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      recentExit.exitRecentWithAnimation(panelViewModel, 0, false);
      expect(recentExit).not().assertUndefined();
    })

    it('exitRecentWithAnimation_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbSceneContainer.needRenderShowInRecent.setShowInRecentWithDfx(true, 'exitRecentWithAnimation', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      let mocker: MockKit = new MockKit();
      let getSessionContainerRelativePos: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getSessionContainerRelativePos);
      when(getSessionContainerRelativePos)(ArgumentMatchers.any).afterReturn(SCBSessionShowInScreenIndex.INDEX_NONE);
      recentExit.exitRecentWithAnimation(panelViewModel, 0, false);
      expect(recentExit).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getSessionContainerRelativePos);
    })

    it('exitRecentWithAnimation_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbSceneContainer.needRenderShowInRecent.setShowInRecentWithDfx(true, 'exitRecentWithAnimation', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      let mocker: MockKit = new MockKit();
      let getSessionContainerRelativePos: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getSessionContainerRelativePos);
      when(getSessionContainerRelativePos)(ArgumentMatchers.any).afterReturn(SCBSessionShowInScreenIndex.INDEX_NONE);
      recentExit.exitRecentWithAnimation(panelViewModel, 0, true);
      expect(recentExit).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getSessionContainerRelativePos);
    })

    it('exitRecentWithAnimation_test_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbSceneContainer.needRenderShowInRecent.setShowInRecentWithDfx(true, 'exitRecentWithAnimation', 'test');
      recentRuntimeInstance.notRemovingSessionList = new SCBSceneContainerSessionArray();
      recentExit.exitRecentWithAnimation(panelViewModel, 0, true);
      expect(recentExit).not().assertUndefined();
    })

    it('exitRecentWithAnimation_test_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbSceneContainer.needRenderShowInRecent.setShowInRecentWithDfx(true, 'exitRecentWithAnimation', 'test');
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      (scenePanelManager as object)['screenProperty'] = screenProperty;
      let mocker: MockKit = new MockKit();
      let getSessionContainerRelativePos: Function = mocker.mockFunc(RecentLayoutManager, RecentLayoutManager.getSessionContainerRelativePos);
      when(getSessionContainerRelativePos)(ArgumentMatchers.any).afterReturn(SCBSessionShowInScreenIndex.INDEX_MIDDLE);
      panelViewModel.updateScenePanelState(ScenePanelState.HOME, false);
      recentExit.exitRecentWithAnimation(panelViewModel, 0, true);
      expect(recentExit).not().assertUndefined();
      mocker.ignoreMock(RecentLayoutManager, RecentLayoutManager.getSessionContainerRelativePos);
    })

    it('RecentExit_test_resetSessionParam_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbSceneContainer.isFloat = false;
      recentExit.resetSessionParam(scbSceneContainer);
      expect(recentExit).not().assertNull();
    })

    it('RecentExit_test_resetSessionParam_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbSceneContainer.isFloat = true;
      recentExit.resetSessionParam(scbSceneContainer);
      expect(recentExit).not().assertNull();
    })

    it('RecentExit_test_resetSessionParam_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbSceneContainer.isFloat = false;
      scbSceneContainer.setActivationAtToggleHomeScenario();
      recentExit.resetSessionParam(scbSceneContainer);
      expect(recentExit).not().assertNull();
    })

    it('RecentExit_test_resetSessionParam_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      scbSceneContainer.isFloat = true;
      scbSceneContainer.setActivationAtToggleHomeScenario();
      recentExit.resetSessionParam(scbSceneContainer);
      expect(recentExit).not().assertNull();
    })

    it('RecentExit_test_getContainerOutAnimParam_01_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentExit as object)['isNewStyle'] = true;
      let param: AnimateParam = {
        finishCallbackType: FinishCallbackType.LOGICALLY,
        curve: curves.springMotion(0.314, 1, 0)
      }
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      recentExit.getContainerOutAnimParam(0);
      expect(recentExit.getContainerOutAnimParam(0).finishCallbackType).assertEqual(param.finishCallbackType);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentExit_test_getContainerOutAnimParam_01_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentExit as object)['isNewStyle'] = true;
      let param: AnimateParam = {
        finishCallbackType: FinishCallbackType.LOGICALLY,
        curve: curves.springMotion(0.363, 1, 0)
      }
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      recentExit.getContainerOutAnimParam(1);
      expect(recentExit.getContainerOutAnimParam(1).finishCallbackType).assertEqual(param.finishCallbackType);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentExit_test_getContainerOutAnimParam_01_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentExit as object)['isNewStyle'] = true;
      let param: AnimateParam = {
        finishCallbackType: FinishCallbackType.LOGICALLY,
        curve: curves.springMotion(0.41, 0.99, 0)
      }
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      recentExit.getContainerOutAnimParam(2);
      expect(recentExit.getContainerOutAnimParam(2).finishCallbackType).assertEqual(param.finishCallbackType);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentExit_test_getContainerOutAnimParam_01_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentExit as object)['isNewStyle'] = false;
      let param: AnimateParam = {
        duration: 400,
        delay: 0,
        curve: Curve.Linear
      }
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      recentExit.getContainerOutAnimParam(0);
      expect(recentExit.getContainerOutAnimParam(0).curve).assertEqual(param.curve);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentExit_test_getContainerOutAnimParam_02_1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentExit as object)['isNewStyle'] = true;
      let param: AnimateParam = {
        duration: 400,
        delay: 0,
        curve: Curve.Friction
      }
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentExit.getContainerOutAnimParam(0);
      expect(recentExit.getContainerOutAnimParam(0).curve).assertEqual(param.curve);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentExit_test_getContainerOutAnimParam_02_2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentExit as object)['isNewStyle'] = true;
      let param: AnimateParam = {
        duration: 400,
        delay: 0,
        curve: curves.cubicBezierCurve(0.3, 0, 0.3, 1)
      }
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentExit.getContainerOutAnimParam(1);
      expect(recentExit.getContainerOutAnimParam(1).duration).assertEqual(param.duration);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentExit_test_getContainerOutAnimParam_02_3', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentExit as object)['isNewStyle'] = true;
      let param: AnimateParam = {
        duration: 400,
        delay: 0,
        curve: curves.cubicBezierCurve(0.35, 0, 0.35, 1)
      }
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentExit.getContainerOutAnimParam(2);
      expect(recentExit.getContainerOutAnimParam(2).duration).assertEqual(param.duration);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentExit_test_getContainerOutAnimParam_02_4', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      (recentExit as object)['isNewStyle'] = false;
      let param: AnimateParam = {
        duration: 400,
        delay: 0,
        curve: Curve.Linear
      }
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      recentExit.getContainerOutAnimParam(0);
      expect(recentExit.getContainerOutAnimParam(0).curve).assertEqual(param.curve);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('resetSessionParam_test01', 0, (): void => {
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      (recentExit as object)['resetSessionParam']();
      expect(scbSceneContainer).not().assertUndefined();
    })

    it('getContainerMoveDistance_test01', 0, (): void => {
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      let mockFun1 = mock.mockFunc((recentExit as object), (recentExit as object)['getSessionInMiddleColumn']);
      when(mockFun)(ArgumentMatchers.any).afterReturn(true);
      when(mockFun1)(ArgumentMatchers.any).afterReturnNothing;
      recentExit.getContainerMoveDistance(1);
      expect(recentExit).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      mock.ignoreMock((recentExit as object), (recentExit as object)['getSessionInMiddleColumn']);
    })

    it('getContainerMoveDistance_test02', 0, (): void => {
      screenProperty.height = 4;
      screenProperty.width = 4;
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      recentRuntimeInstance.containerCountsShowInRecent = 1;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      let mockFun2 = mock.mockFunc(scenePanelManager, scenePanelManager.getScreenProperty);
      let mockFun1 = mock.mockFunc((recentExit as object), (recentExit as object)['getSessionInMiddleColumn']);
      when(mockFun)(ArgumentMatchers.any).afterReturn(true);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(scbSceneContainer);
      when(mockFun2)(ArgumentMatchers.any).afterReturn(screenProperty);
      recentExit.getContainerMoveDistance(1);
      expect(recentExit).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      mock.ignoreMock((recentExit as object), (recentExit as object)['getSessionInMiddleColumn']);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
    })

    it('getContainerMoveDistance_test03', 0, (): void => {
      screenProperty.height = 4;
      screenProperty.width = 4;
      let scbSceneContainer: SCBSceneContainerSession =
        new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
      recentRuntimeInstance.containerCountsShowInRecent = 3;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      let mockFun1 = mock.mockFunc((recentExit as object), (recentExit as object)['getSessionInMiddleColumn']);
      let mockFun2 = mock.mockFunc(scenePanelManager, scenePanelManager.getScreenProperty);
      when(mockFun)(ArgumentMatchers.any).afterReturn(false);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(scbSceneContainer);
      when(mockFun2)(ArgumentMatchers.any).afterReturn(screenProperty);
      recentExit.getContainerMoveDistance(1);
      expect(recentExit).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mock.ignoreMock((recentExit as object), (recentExit as object)['getSessionInMiddleColumn']);
    })

    it('getSessionInMiddleColumn_test01', 0, (): void => {
      (recentExit as object)['getSessionInMiddleColumn'](true);
      expect(recentExit).not().assertUndefined();
      (recentExit as object)['getSessionInMiddleColumn'](false);
      expect(recentExit).not().assertUndefined();
    })

    it('getExitFinalPositionX_test01', 0, (): void => {
      screenProperty.height = 4;
      screenProperty.width = 4;
      recentRuntimeInstance.containerCountsShowInRecent = 1;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      let mockFun1 = mock.mockFunc(scenePanelManager, scenePanelManager.getScreenProperty);
      let mockFun2 = mock.mockFunc(RecentLayoutManager, RecentLayoutManager.getScale);
      when(mockFun)(ArgumentMatchers.any).afterReturn(true);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(screenProperty);
      when(mockFun2)(ArgumentMatchers.any).afterReturn(1);
      (recentExit as object)['getExitFinalPositionX'](1);
      expect(recentExit).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      mock.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
      mock.ignoreMock(RecentLayoutManager, RecentLayoutManager.getScale);
    })

    it('getSessionContainerOutAnimInMultiRow_test01', 0, (): void => {
      (recentExit as object)['isNewStyle'] = false;
      (recentExit as object)['getSessionContainerOutAnimInMultiRow'](1);
      expect(recentExit).not().assertUndefined();
    })

    it('getSessionContainerOutAnimInSingleRow_test01', 0, (): void => {
      (recentExit as object)['isNewStyle'] = false;
      (recentExit as object)['getSessionContainerOutAnimInSingleRow'](1);
      expect(recentExit).not().assertUndefined();
      (recentExit as object)['isNewStyle'] = true;
      (recentExit as object)['getSessionContainerOutAnimInSingleRow'](1);
      expect(recentExit).not().assertUndefined();
      (recentExit as object)['isNewStyle'] = true;
      (recentExit as object)['getSessionContainerOutAnimInSingleRow'](2);
      expect(recentExit).not().assertUndefined();
    })
  })
}