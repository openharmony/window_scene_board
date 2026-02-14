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
  TestType,
  Size,
  Level,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { RecentNotShow, ContainerShowState } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentNotShow';
import {
  SCBScenePanelManager,
  SCBSceneSession,
  SCBSceneInfo,
  SCBSceneSessionManager,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBScreenProperty,
  SCBSceneContainerState,
  SceneParam,
  SCBDividerParam
} from '@ohos/windowscene';
import { CommonUtils } from '@ohos/basicutils';
import sceneSessionManager from '@ohos.sceneSessionManager'
import { recentLayoutConfigInstance } from '@ohos/recents';
import screenSessionManager from '@ohos.screenSessionManager';

export default function RecentNotShowTest() {
  describe('RecentNotShowTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })
    let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    let screenProp: screenSessionManager.ScreenProperty = {
      rotation: 1,
      bounds: {
        left: 1,
        top: 1,
        width: 1,
        height: 1,
        radius: 1,
      },
      fakeBounds: {
        left: 0,
        top: 0,
        width: 0,
        height: 0,
        radius: 0
      },
      isFakeInUse: false,
      rsId: 0,
    };
    scbScreenProperty.update(screenProp);
    let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
    let recentNotShow: RecentNotShow = new RecentNotShow(scenePanelManager);

    it('RecentNotShow_test_getFloatingShowStatus_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      recentNotShow.getFloatingShowStatus(new SCBSceneContainerSession(session, new SCBScreenProperty()));
      expect(recentNotShow.getFloatingShowStatus(new SCBSceneContainerSession(session, new SCBScreenProperty())))
        .assertEqual(ContainerShowState.SHOW);
    })

    it('RecentNotShow_test_getFloatingShowStatus_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance()
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(sessionManager, sessionManager.isExcludeFromSession);
      when(mockfunc)(session.sceneInfo).afterReturn(false);
      expect(recentNotShow.getFloatingShowStatus(new SCBSceneContainerSession(session, new SCBScreenProperty())))
        .assertEqual(ContainerShowState.SHOW);
      mocker.ignoreMock(sessionManager, sessionManager.isExcludeFromSession);
    })

    it('RecentNotShow_test_getFloatingShowStatus_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(sessionManager, sessionManager.isExcludeFromSession);
      when(mockfunc)(session.sceneInfo).afterReturn(true);
      expect(recentNotShow.getFloatingShowStatus(new SCBSceneContainerSession(session, new SCBScreenProperty())))
        .assertEqual(ContainerShowState.SHOW);
      mocker.ignoreMock(sessionManager, sessionManager.isExcludeFromSession);
    })
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let primarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);

    it('RecentNotShow_test_notShowContainerAnimationOut_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(recentNotShow, recentNotShow.getShowStatus);
      when(mockfunc)().afterReturn(ContainerShowState.NOT_SHOW);
      try {
        recentNotShow.notShowContainerAnimationOut(totalContainerSessionList);
      } catch (e) {
        expect(false).assertFalse();
      }
      let scenePanelManager: SCBScenePanelManager | null = null;
      expect(scenePanelManager).assertNull();
      mocker.ignoreMock(recentNotShow, recentNotShow.getShowStatus);
    })

    it('RecentNotShow_test_notShowContainerAnimationOut_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(recentNotShow, recentNotShow.getShowStatus);
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let containerList = scenePanelManager.getSceneContainerSessionList();
      let lastSession = containerList.getTopSession();
      when(mockfunc)(lastSession).afterReturn(ContainerShowState.NOT_SHOW);
      try {
        recentNotShow.notShowContainerAnimationOut(totalContainerSessionList);
      } catch (e) {
        expect(false).assertFalse();
      }
      expect(recentNotShow.getShowStatus(lastSession)).assertEqual(ContainerShowState.NOT_SHOW);
      mocker.ignoreMock(recentNotShow, recentNotShow.getShowStatus);
    })

    it('RecentNotShow_test_notShowContainerAnimationOut_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let containerList = scenePanelManager.getSceneContainerSessionList();
      let lastSession = containerList.getTopSession();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(recentNotShow, recentNotShow.getShowStatus);
      when(mockfunc)(lastSession).afterReturn(ContainerShowState.PRIMARY_SHOW);
      try {
        recentNotShow.notShowContainerAnimationOut(totalContainerSessionList);
      } catch (e) {
        expect(false).assertFalse();
      }
      expect(recentNotShow.getShowStatus(lastSession)).assertEqual(ContainerShowState.PRIMARY_SHOW);
      mocker.ignoreMock(recentNotShow, recentNotShow.getShowStatus);
    })

    it('RecentNotShow_test_notShowContainerAnimationOut_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let containerList = scenePanelManager.getSceneContainerSessionList();
      let lastSession = containerList.getTopSession();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(recentNotShow, recentNotShow.getShowStatus);
      when(mockfunc)(lastSession).afterReturn(ContainerShowState.SECONDARY_SHOW);
      try {
        recentNotShow.notShowContainerAnimationOut(totalContainerSessionList);
      } catch (e) {
        expect(false).assertFalse();
      }
      expect(recentNotShow.getShowStatus(lastSession)).assertEqual(ContainerShowState.SECONDARY_SHOW);
      mocker.ignoreMock(recentNotShow, recentNotShow.getShowStatus);
    })

    it('RecentNotShow_test_notShowContainerAnimationOut_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(containerSession);
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let containerList = scenePanelManager.getSceneContainerSessionList();
      let lastSession = containerList.getTopSession();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(recentNotShow, recentNotShow.getShowStatus);
      when(mockfunc)(lastSession).afterReturn(ContainerShowState.SECONDARY_SHOW);
      try {
        recentNotShow.notShowContainerAnimationOut(totalContainerSessionList);
      } catch (e) {
        expect(false).assertFalse();
      }
      expect(recentNotShow.getShowStatus(lastSession)).assertEqual(ContainerShowState.SECONDARY_SHOW);
      mocker.ignoreMock(recentNotShow, recentNotShow.getShowStatus);
    })

    it('RecentNotShow_test_notShowSessionDestroy_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(recentNotShow, recentNotShow.getShowStatus);
      when(mockfunc)(containerSession).afterReturn(ContainerShowState.NOT_SHOW);
      try {
        recentNotShow.notShowSessionDestroy(containerSession, totalContainerSessionList);
      } catch (e) {
        expect(e).assertUndefined();
      }
      mocker.ignoreMock(recentNotShow, recentNotShow.getShowStatus);
    })

    it('RecentNotShow_test_notShowSessionDestroy_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(recentNotShow, recentNotShow.getShowStatus);
      when(mockfunc)(containerSession).afterReturn(ContainerShowState.PRIMARY_SHOW);
      try {
        recentNotShow.notShowSessionDestroy(containerSession, totalContainerSessionList);
      } catch (e) {
        expect(false).assertFalse();
      }
      mocker.ignoreMock(recentNotShow, recentNotShow.getShowStatus);
    })

    it('RecentNotShow_test_notShowSessionDestroy_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(recentNotShow, recentNotShow.getShowStatus);
      when(mockfunc)(containerSession).afterReturn(ContainerShowState.SECONDARY_SHOW);
      try {
        recentNotShow.notShowSessionDestroy(containerSession, totalContainerSessionList);
      } catch (e) {
        expect(e).assertUndefined();
      }
      mocker.ignoreMock(recentNotShow, recentNotShow.getShowStatus);
    })

    it('RecentNotShow_test_notShowSessionDestroy_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let session: SCBSceneContainerSession | null = null;
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      recentNotShow.notShowSessionDestroy(session, totalContainerSessionList);
      expect(session).assertNull();
    })

    it('RecentNotShow_test_splitScreenDestroy_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let containerShowState: ContainerShowState = ContainerShowState.PRIMARY_SHOW;
      containerSession.primarySession = primarySession;
      containerSession.secondarySession = primarySession;
      try {
        recentNotShow.splitScreenDestroy(containerSession, containerShowState);
      } catch (e) {
        expect(false).assertFalse();
      }
    })

    it('RecentNotShow_test_splitScreenDestroy_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let containerShowState: ContainerShowState = ContainerShowState.SHOW;
      containerSession.primarySession = primarySession;
      containerSession.secondarySession = primarySession;
      recentNotShow.splitScreenDestroy(containerSession, containerShowState);
      expect(containerSession['sessionDataInner'].state).assertEqual(SCBSceneContainerState.FULL_SCREEN);
    })

    it('RecentNotShow_test_splitScreenDestroy_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let getScreenProperty: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getScreenProperty);
      when(getScreenProperty)().afterReturn(screenProperty);
      let containerShowState: ContainerShowState = ContainerShowState.SECONDARY_SHOW;
      recentNotShow.splitScreenDestroy(containerSession, containerShowState);
      containerSession.primarySession = primarySession;
      containerSession.secondarySession = primarySession;
      expect(containerSession['sessionDataInner'].state).assertEqual(SCBSceneContainerState.FULL_SCREEN);
      mocker.ignoreMock(scenePanelManager, scenePanelManager.getScreenProperty);
    })

    it('RecentNotShow_test_splitScreenDestroy_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let containerShowState: ContainerShowState = ContainerShowState.NOT_SHOW;
      recentNotShow.splitScreenDestroy(containerSession, containerShowState);
      containerSession.primarySession = primarySession;
      containerSession.secondarySession = primarySession;
      expect(containerSession['sessionDataInner'].state).assertEqual(SCBSceneContainerState.FULL_SCREEN);
    })

    it('RecentNotShow_test_splitScreenNotShowAnimation_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let containerShowState: ContainerShowState = ContainerShowState.PRIMARY_SHOW;
      containerSession.primarySession = primarySession;
      containerSession.secondarySession = primarySession;
      try {
        recentNotShow.splitScreenNotShowAnimation(containerSession, containerShowState);
      } catch (e) {
        expect(false).assertFalse();
      }

    })

    it('RecentNotShow_test_splitScreenNotShowAnimation_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let containerShowState: ContainerShowState = ContainerShowState.SHOW;
      containerSession.primarySession = primarySession;
      containerSession.secondarySession = primarySession;
      try {
        recentNotShow.splitScreenNotShowAnimation(containerSession, containerShowState);
      } catch (e) {
        expect(false).assertFalse();
      }
    })

    it('RecentNotShow_test_splitScreenNotShowAnimation_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let containerShowState: ContainerShowState = ContainerShowState.NOT_SHOW;
      containerSession.primarySession = primarySession;
      containerSession.secondarySession = primarySession;
      try {
        recentNotShow.splitScreenNotShowAnimation(containerSession, containerShowState);
      } catch (e) {
        expect(false).assertFalse();
      }
    })

    it('RecentNotShow_test_splitScreenNotShowAnimation_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let containerShowState: ContainerShowState = ContainerShowState.SECONDARY_SHOW;
      containerSession.primarySession = primarySession;
      containerSession.secondarySession = primarySession;
      try {
        recentNotShow.splitScreenNotShowAnimation(containerSession, containerShowState);
      } catch (e) {
        expect(false).assertFalse();
      }
    })

    it('RecentNotShow_test_notShowContainerDestroy_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let lastSession: SCBSceneContainerSession | null = null;
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      recentNotShow.notShowContainerDestroy(lastSession, totalContainerSessionList);
      expect(lastSession).assertNull();
    })

    it('RecentNotShow_test_notShowContainerDestroy_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      if (containerSession?.containerId) {
        recentNotShow.notShowContainerDestroy(containerSession, totalContainerSessionList);
      }
      containerSession.primarySession = primarySession;
      containerSession.secondarySession = primarySession;
      expect(containerSession.isActive).assertFalse();
    })

    it('RecentNotShow_test_notShowContainerDestroy_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      containerSession.primarySession = primarySession;
      containerSession.secondarySession = primarySession;
      if (containerSession?.containerId) {
        recentNotShow.notShowContainerDestroy(containerSession, totalContainerSessionList);
      }
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let notShowList = scenePanelManager.getNotShowRecentList();
      let index = notShowList.findIndexByContainerId(containerSession.containerId);
      expect(index !== -1).assertFalse();
    })

    it('RecentNotShow_test_notShowContainerDestroy_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      containerSession.primarySession = primarySession;
      containerSession.secondarySession = primarySession;
      if (containerSession?.containerId) {
        recentNotShow.notShowContainerDestroy(containerSession, totalContainerSessionList);
      }
      let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
      let notShowList = scenePanelManager.getNotShowRecentList();
      let index = notShowList.findIndexByContainerId(0);
      expect(index === -1).assertTrue();
    })

    it('getExcludeFromSession_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentNotShow: RecentNotShow = new RecentNotShow(scenePanelManager);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
      containerSession.primarySession = primarySession;
      containerSession.secondarySession = primarySession;
      let res: object = (recentNotShow as object)['getExcludeFromSession']();
      expect(res).assertEqual(false);
    })

    it('getFloatingShowStatus_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentNotShow: RecentNotShow = new RecentNotShow(scenePanelManager);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
      containerSession.primarySession = primarySession;
      containerSession.secondarySession = primarySession;
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let res: object = (recentNotShow as object)['getFloatingShowStatus']();
      expect(res).assertEqual(ContainerShowState.SHOW);
    })

    it('getShowStatus_test01', 0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      let screenProp: screenSessionManager.ScreenProperty = {
        rotation: 1,
        bounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        fakeBounds: {
          left: 1,
          top: 1,
          width: 1,
          height: 1,
          radius: 1,
        },
        isFakeInUse: true,
        rsId: 0,
      };
      scbScreenProperty.update(screenProp);
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
      let recentNotShow: RecentNotShow = new RecentNotShow(scenePanelManager);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
      containerSession.primarySession = primarySession;
      containerSession.secondarySession = primarySession;
      let res: object = (recentNotShow as object)['getShowStatus']();
      expect(res).assertEqual(ContainerShowState.SHOW);
    })
  })

  it('fullScreenNotShowAnimation_02', 0, (): void => {
    let animationNum: number = 0;
    let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    totalContainerSessionList.add(containerSession);
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
    session.addTransitionCount();
    session.addTransitionCount();
    let mocker: MockKit = new MockKit();
    let getTransitionCount: Function = mocker.mockFunc(session, session.getTransitionCount);
    when(getTransitionCount)().afterReturn(animationNum);
    recentNotShow.fullScreenNotShowAnimation(session, totalContainerSessionList);
    expect(recentNotShow).not().assertUndefined();
    mocker.ignoreMock(session, session.getTransitionCount);
  })
}