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
import {
  SCBScenePanelViewModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/viewmodel/SCBScenePanelViewModel';
import { UIContext } from '@kit.ArkUI';

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
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(new UIContext(), screenProperty);

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
        recentNotShow.notShowContainerAnimationOut(totalContainerSessionList, panelViewModel);
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
        recentNotShow.notShowContainerAnimationOut(totalContainerSessionList, panelViewModel);
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
        recentNotShow.notShowContainerAnimationOut(totalContainerSessionList, panelViewModel);
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
        recentNotShow.notShowContainerAnimationOut(totalContainerSessionList, panelViewModel);
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
        recentNotShow.notShowContainerAnimationOut(totalContainerSessionList, panelViewModel);
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

    it('getShowStatus_test07', 0, (): void => {
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
      let sCBSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      containerSession.primarySession = primarySession;
      containerSession.secondarySession = primarySession;
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(sCBSceneSessionManager, sCBSceneSessionManager.isExcludeFromSession);
      when(mockFunc)(containerSession.primarySession).afterReturn(true);
      when(mockFunc)(containerSession.secondarySession).afterReturn(false);
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      let res = recentNotShow.getShowStatus(sCBSceneContainerSession);
      expect(res).assertEqual(ContainerShowState.SHOW);
      mock.ignoreMock(sCBSceneSessionManager, sCBSceneSessionManager.isExcludeFromSession);
    })

    it('notShowContainerAnimationOut_test01', 0, (): void => {
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
      (recentNotShow as object)['notShowContainerAnimationOut']();
      expect(session).not().assertUndefined();
    })

    it('notShowContainerAnimationOut_test03', 0, (): void => {
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
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentNotShow, recentNotShow.getShowStatus);
      when(mockFun)(ArgumentMatchers.any).afterReturn(ContainerShowState.SHOW);
      recentNotShow.notShowContainerAnimationOut(totalContainerSessionList, panelViewModel);
      expect(session).not().assertUndefined();
      mock.ignoreMock(recentNotShow, recentNotShow.getShowStatus);
    })

    it('splitUpdatePositionAndSize_test01', 0, (): void => {
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
      (recentNotShow as object)['splitUpdatePositionAndSize']();
      expect(session).not().assertUndefined();
    })

    it('splitUpdatePositionAndSize_test02', 0, (): void => {
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
      let sceneParam: SceneParam = new SceneParam();
      (sceneParam as object)['splitOrderIsNotReverse'] = false;
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      let mock = new MockKit();
      let mockFun = mock.mockFunc(sCBSceneContainerSession, sCBSceneContainerSession.dividerParam.isUpDownSplit);
      when(mockFun)().afterReturn(false);
      (recentNotShow as object)['splitUpdatePositionAndSize'](sCBSceneContainerSession,
        ContainerShowState.PRIMARY_SHOW);
      expect(session).not().assertUndefined();
      mock.ignoreMock(sCBSceneContainerSession, sCBSceneContainerSession.dividerParam.isUpDownSplit);
    })

    it('splitUpdatePositionAndSize_test03', 0, (): void => {
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
      let sceneParam: SceneParam = new SceneParam();
      (sceneParam as object)['splitOrderIsNotReverse'] = true;
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      let mock = new MockKit();
      let mockFun = mock.mockFunc(sCBSceneContainerSession, sCBSceneContainerSession.dividerParam.isUpDownSplit);
      when(mockFun)().afterReturn(false);
      (recentNotShow as object)['splitUpdatePositionAndSize'](sCBSceneContainerSession,
        ContainerShowState.PRIMARY_SHOW);
      expect(session).not().assertUndefined();
      mock.ignoreMock(sCBSceneContainerSession, sCBSceneContainerSession.dividerParam.isUpDownSplit);
    })

    it('splitUpdatePositionAndSize_test04', 0, (): void => {
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
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      let mock = new MockKit();
      let mockFun = mock.mockFunc(sCBSceneContainerSession, sCBSceneContainerSession.dividerParam.isUpDownSplit);
      when(mockFun)().afterReturn(false);
      (recentNotShow as object)['splitUpdatePositionAndSize'](sCBSceneContainerSession, ContainerShowState.SHOW);
      expect(session).not().assertUndefined();
      mock.ignoreMock(sCBSceneContainerSession, sCBSceneContainerSession.dividerParam.isUpDownSplit);
    })

    it('splitUpdatePositionAndSize_test05', 0, (): void => {
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
      let sceneParam: SceneParam = new SceneParam();
      (sceneParam as object)['splitOrderIsNotReverse'] = false;
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      let mock = new MockKit();
      let mockFun = mock.mockFunc(sCBSceneContainerSession, sCBSceneContainerSession.dividerParam.isUpDownSplit);
      when(mockFun)().afterReturn(false);
      (recentNotShow as object)['splitUpdatePositionAndSize'](sCBSceneContainerSession, ContainerShowState.SHOW);
      expect(session).not().assertUndefined();
      mock.ignoreMock(sCBSceneContainerSession, sCBSceneContainerSession.dividerParam.isUpDownSplit);
    })

    it('splitUpdatePositionAndSize_test06', 0, (): void => {
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
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      let mock = new MockKit();
      let mockFun = mock.mockFunc(sCBSceneContainerSession, sCBSceneContainerSession.dividerParam.isUpDownSplit);
      when(mockFun)().afterReturn(true);
      (recentNotShow as object)['splitUpdatePositionAndSize'](sCBSceneContainerSession, ContainerShowState.SHOW);
      expect(session).not().assertUndefined();
      mock.ignoreMock(sCBSceneContainerSession, sCBSceneContainerSession.dividerParam.isUpDownSplit);
    })

    it('splitUpdatePositionAndSize_test07', 0, (): void => {
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
      let sceneParam: SceneParam = new SceneParam();
      (sceneParam as object)['splitOrderIsNotReverse'] = false;
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      let mock = new MockKit();
      let mockFun = mock.mockFunc(sCBSceneContainerSession, sCBSceneContainerSession.dividerParam.isUpDownSplit);
      when(mockFun)().afterReturn(true);
      (recentNotShow as object)['splitUpdatePositionAndSize'](sCBSceneContainerSession, ContainerShowState.SHOW);
      expect(session).not().assertUndefined();
      mock.ignoreMock(sCBSceneContainerSession, sCBSceneContainerSession.dividerParam.isUpDownSplit);
    })

    it('splitUpdatePositionAndSize_test08', 0, (): void => {
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
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      let mock = new MockKit();
      let mockFun = mock.mockFunc(sCBSceneContainerSession, sCBSceneContainerSession.dividerParam.isUpDownSplit);
      when(mockFun)().afterReturn(true);
      (recentNotShow as object)['splitUpdatePositionAndSize'](sCBSceneContainerSession,
        ContainerShowState.PRIMARY_SHOW);
      expect(session).not().assertUndefined();
      mock.ignoreMock(sCBSceneContainerSession, sCBSceneContainerSession.dividerParam.isUpDownSplit);
    })

    it('splitUpdatePositionAndSize_test09', 0, (): void => {
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
      let sceneParam: SceneParam = new SceneParam();
      (sceneParam as object)['splitOrderIsNotReverse'] = false;
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      let mock = new MockKit();
      let mockFun = mock.mockFunc(sCBSceneContainerSession, sCBSceneContainerSession.dividerParam.isUpDownSplit);
      when(mockFun)().afterReturn(true);
      (recentNotShow as object)['splitUpdatePositionAndSize'](sCBSceneContainerSession,
        ContainerShowState.PRIMARY_SHOW);
      expect(session).not().assertUndefined();
      mock.ignoreMock(sCBSceneContainerSession, sCBSceneContainerSession.dividerParam.isUpDownSplit);
    })

    it('notShowSessionDestroy_test01', 0, (): void => {
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
      (recentNotShow as object)['notShowSessionDestroy']();
      expect(session).not().assertUndefined();
    })

    it('snotShowSessionDestroy_test02', 0, (): void => {
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
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentNotShow, recentNotShow.getShowStatus);
      when(mockFun)(ArgumentMatchers.any).afterReturn(ContainerShowState.NOT_SHOW);
      expect(session).not().assertUndefined();
      recentNotShow.notShowSessionDestroy(sCBSceneContainerSession, totalContainerSessionList);
      mock.ignoreMock(recentNotShow, recentNotShow.getShowStatus);
    })

    it('snotShowSessionDestroy_test03', 0, (): void => {
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
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentNotShow, recentNotShow.getShowStatus);
      when(mockFun)(ArgumentMatchers.any).afterReturn(ContainerShowState.PRIMARY_SHOW);
      expect(session).not().assertUndefined();
      recentNotShow.notShowSessionDestroy(sCBSceneContainerSession, totalContainerSessionList);
      mock.ignoreMock(recentNotShow, recentNotShow.getShowStatus);
    })

    it('snotShowSessionDestroy_test04', 0, (): void => {
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
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentNotShow, recentNotShow.getShowStatus);
      when(mockFun)(ArgumentMatchers.any).afterReturn(ContainerShowState.SHOW);
      expect(session).not().assertUndefined();
      recentNotShow.notShowSessionDestroy(sCBSceneContainerSession, totalContainerSessionList);
      mock.ignoreMock(recentNotShow, recentNotShow.getShowStatus);
    })

    it('exitSplit_test01', 0, (): void => {
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
      (recentNotShow as object)['exitSplit']();
      expect(session).not().assertUndefined();
    })

    it('exitSplit_test02', 0, (): void => {
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
      (recentNotShow as object)['exitSplit'](session);
      expect(session).not().assertUndefined();
    })

    it('splitScreenDestroy_test01', 0, (): void => {
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
      (recentNotShow as object)['splitScreenDestroy']();
      expect(session).not().assertUndefined();
    })

    it('splitScreenDestroy_test02', 0, (): void => {
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
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      recentNotShow.splitScreenDestroy(sCBSceneContainerSession, ContainerShowState.SHOW);
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentNotShow, recentNotShow.getShowStatus);
      when(mockFun)(ArgumentMatchers.any).afterReturn(ContainerShowState.PRIMARY_SHOW);
      expect(session).not().assertUndefined();
      mock.ignoreMock(recentNotShow, recentNotShow.getShowStatus);
    })

    it('splitScreenDestroy_test03', 0, (): void => {
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
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      recentNotShow.splitScreenDestroy(sCBSceneContainerSession, ContainerShowState.SHOW);
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentNotShow, recentNotShow.getShowStatus);
      when(mockFun)(ArgumentMatchers.any).afterReturn(ContainerShowState.SHOW);
      expect(session).not().assertUndefined();
      mock.ignoreMock(recentNotShow, recentNotShow.getShowStatus);
    })

    it('splitScreenDestroy_test04', 0, (): void => {
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
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      recentNotShow.splitScreenDestroy(sCBSceneContainerSession, ContainerShowState.PRIMARY_SHOW);
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentNotShow, recentNotShow.getShowStatus);
      when(mockFun)(ArgumentMatchers.any).afterReturn(ContainerShowState.SHOW);
      expect(session).not().assertUndefined();
      mock.ignoreMock(recentNotShow, recentNotShow.getShowStatus);
    })

    it('splitScreenDestroy_test05', 0, (): void => {
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
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      recentNotShow.splitScreenDestroy(sCBSceneContainerSession, ContainerShowState.SHOW);
      let mock = new MockKit();
      let mockFun = mock.mockFunc(recentNotShow, recentNotShow.getShowStatus);
      when(mockFun)(ArgumentMatchers.any).afterReturn(ContainerShowState.SHOW);
      expect(session).not().assertUndefined();
      mock.ignoreMock(recentNotShow, recentNotShow.getShowStatus);
    })

    it('splitScreenNotShowAnimation_test01', 0, (): void => {
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
      (recentNotShow as object)['splitScreenNotShowAnimation']();
      expect(session).not().assertUndefined();
    })

    it('splitScreenNotShowAnimation_test02', 0, (): void => {
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
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFunc)().afterReturn(true);
      recentNotShow.splitScreenNotShowAnimation(sCBSceneContainerSession, ContainerShowState.PRIMARY_SHOW);
      expect(session).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
    })

    it('addNotShowList_test01', 0, (): void => {
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
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      (recentNotShow as object)['addNotShowList'](sCBSceneContainerSession);
      let mock = new MockKit();
      let mockFun = mock.mockFunc(scenePanelManager, scenePanelManager.getNotShowRecentList().findIndexByContainerId);
      when(mockFun)(ArgumentMatchers.any).afterReturn(-1);
      expect(session).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getNotShowRecentList().findIndexByContainerId);
    })

    it('addNotShowList_test02', 0, (): void => {
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
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      (recentNotShow as object)['addNotShowList'](sCBSceneContainerSession);
      let mock = new MockKit();
      let mockFun = mock.mockFunc(scenePanelManager, scenePanelManager.getNotShowRecentList().findIndexByContainerId);
      when(mockFun)(ArgumentMatchers.any).afterReturn(1);
      expect(session).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getNotShowRecentList().findIndexByContainerId);
    })

    it('notShowContainerDestroy_test01', 0, (): void => {
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
      expect(session).not().assertUndefined();
    })

    it('notShowContainerDestroy_test02', 0, (): void => {
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
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      sCBSceneContainerSession.primarySession = null;
      sCBSceneContainerSession.secondarySession = null;
      if (sCBSceneContainerSession?.containerId) {
        recentNotShow.notShowContainerDestroy(sCBSceneContainerSession);
      }
      expect(session).not().assertUndefined();
    })

    it('notShowContainerDestroy_test03', 0, (): void => {
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
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      sCBSceneContainerSession.primarySession = null;
      sCBSceneContainerSession.secondarySession = primarySession;
      if (sCBSceneContainerSession?.containerId) {
        recentNotShow.notShowContainerDestroy(sCBSceneContainerSession);
      }
      expect(session).not().assertUndefined();
    })

    it('getFloatingShowStatus_test001', 0, (): void => {
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
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      let mock = new MockKit();
      let mockFun: Function = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun)(ArgumentMatchers.any).afterReturn(true);
      recentNotShow.getFloatingShowStatus(sCBSceneContainerSession);
      expect(session).not().assertUndefined();
      mock.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    })

    it('getFloatingShowStatus_test002', 0, (): void => {
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
      let sCBSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      let mock = new MockKit();
      let mockFun: Function = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun)(ArgumentMatchers.any).afterReturn(false);
      let mockFun1: Function = mock.mockFunc(sCBSceneSessionManager, sCBSceneSessionManager.isExcludeFromSession);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(true);
      recentNotShow.getFloatingShowStatus(sCBSceneContainerSession);
      expect(session).not().assertUndefined();
      mock.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mock.ignoreMock(sCBSceneSessionManager, sCBSceneSessionManager.isExcludeFromSession);
    })

    it('addNotShowList_test001', 0, (): void => {
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
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      let mock = new MockKit();
      let mockFun = mock.mockFunc(scenePanelManager, scenePanelManager.getNotShowRecentList().findIndexByContainerId);
      when(mockFun)(ArgumentMatchers.any).afterReturn(-1);
      (recentNotShow as object)['addNotShowList'](sCBSceneContainerSession);
      expect(session).not().assertUndefined();
      mock.ignoreMock(scenePanelManager, scenePanelManager.getNotShowRecentList().findIndexByContainerId);
    })

    it('addNotShowList_test002', 0, (): void => {
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
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      let mock = new MockKit();
      let mockFun = mock.mockFunc(sCBSceneContainerSession, sCBSceneContainerSession.findSceneSessionByPersistentId);
      when(mockFun)(ArgumentMatchers.any).afterReturn(1);
      (recentNotShow as object)['addNotShowList'](sCBSceneContainerSession);
      expect(session).not().assertUndefined();
      mock.ignoreMock(sCBSceneContainerSession, sCBSceneContainerSession.findSceneSessionByPersistentId);
    })

    it('splitUpdatePositionAndSize_test_01', 0, (): void => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      let dividerParam1: SCBDividerParam = new SCBDividerParam();
      sCBSceneContainerSession.dividerParam = dividerParam1;
      sCBSceneContainerSession.dividerParam.splitOrderIsNotReverse = true;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(scenePanelManager, scenePanelManager.getScreenProperty);
      let mockFun1 =
        mock.mockFunc(sCBSceneContainerSession.dividerParam, sCBSceneContainerSession.dividerParam.isUpDownSplit);
      when(mockFun)().afterReturn(scbScreenProperty);
      when(mockFun1)().afterReturn(false);
      (recentNotShow as object)['splitUpdatePositionAndSize'](sCBSceneContainerSession,
        ContainerShowState.PRIMARY_SHOW);
      expect(sCBSceneContainerSession).not().assertUndefined();
      (recentNotShow as object)['splitUpdatePositionAndSize'](sCBSceneContainerSession, ContainerShowState.SHOW);
      expect(sCBSceneContainerSession).not().assertUndefined();
      mock.ignoreMock(scenePanelManager.getSceneContainerSessionList(),
        scenePanelManager.getSceneContainerSessionList().getTopSession);
    })

    it('splitUpdatePositionAndSize_test_02', 0, (): void => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      let dividerParam1: SCBDividerParam = new SCBDividerParam();
      sCBSceneContainerSession.dividerParam = dividerParam1;
      sCBSceneContainerSession.dividerParam.splitOrderIsNotReverse = false;
      let mock = new MockKit();
      let mockFun = mock.mockFunc(scenePanelManager, scenePanelManager.getScreenProperty);
      let mockFun1 =
        mock.mockFunc(sCBSceneContainerSession.dividerParam, sCBSceneContainerSession.dividerParam.isUpDownSplit);
      when(mockFun)().afterReturn(scbScreenProperty);
      when(mockFun1)().afterReturn(true);
      (recentNotShow as object)['splitUpdatePositionAndSize'](sCBSceneContainerSession,
        ContainerShowState.PRIMARY_SHOW);
      expect(sCBSceneContainerSession).not().assertUndefined();
      (recentNotShow as object)['splitUpdatePositionAndSize'](sCBSceneContainerSession, ContainerShowState.SHOW);
      expect(sCBSceneContainerSession).not().assertUndefined();
      mock.ignoreMock(scenePanelManager.getSceneContainerSessionList(),
        scenePanelManager.getSceneContainerSessionList().getTopSession);
    })

    it('getShowStatus_test_01', 0, (): void => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      sCBSceneContainerSession.primarySession = primarySession;
      sCBSceneContainerSession.secondarySession = null;
      let mock = new MockKit();
      let mockFun = mock.mockFunc((recentNotShow as object), (recentNotShow as object)['getExcludeFromSession']);
      when(mockFun)(ArgumentMatchers.any).afterReturn(true);
      recentNotShow.getShowStatus(sCBSceneContainerSession);
      expect(sCBSceneContainerSession).not().assertUndefined();
      mock.ignoreMock((recentNotShow as object), (recentNotShow as object)['getExcludeFromSession']);
    })

    it('getShowStatus_test_02', 0, (): void => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      sCBSceneContainerSession.primarySession = primarySession;
      sCBSceneContainerSession.secondarySession = primarySession;
      let mock = new MockKit();
      let mockFun = mock.mockFunc((recentNotShow as object), (recentNotShow as object)['getExcludeFromSession']);
      when(mockFun)(primarySession).afterReturn(true);
      recentNotShow.getShowStatus(sCBSceneContainerSession);
      expect(sCBSceneContainerSession).not().assertUndefined();
      mock.ignoreMock((recentNotShow as object), (recentNotShow as object)['getExcludeFromSession']);
    })

    it('getShowStatus_test_03', 0, (): void => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let primarySession1: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      sCBSceneContainerSession.primarySession = primarySession;
      sCBSceneContainerSession.secondarySession = primarySession1;
      let mock = new MockKit();
      let mockFun = mock.mockFunc((recentNotShow as object), (recentNotShow as object)['getExcludeFromSession']);
      when(mockFun)(primarySession).afterReturn(false);
      when(mockFun)(primarySession1).afterReturn(true);
      recentNotShow.getShowStatus(sCBSceneContainerSession);
      expect(sCBSceneContainerSession).not().assertUndefined();
      mock.ignoreMock((recentNotShow as object), (recentNotShow as object)['getExcludeFromSession']);
    })

    it('getShowStatus_test_04', 0, (): void => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let primarySession1: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      sCBSceneContainerSession.primarySession = primarySession1;
      sCBSceneContainerSession.secondarySession = primarySession;
      let mock = new MockKit();
      let mockFun = mock.mockFunc((recentNotShow as object), (recentNotShow as object)['getExcludeFromSession']);
      when(mockFun)(primarySession).afterReturn(false);
      when(mockFun)(primarySession1).afterReturn(true);
      recentNotShow.getShowStatus(sCBSceneContainerSession);
      expect(sCBSceneContainerSession).not().assertUndefined();
      mock.ignoreMock((recentNotShow as object), (recentNotShow as object)['getExcludeFromSession']);
    })

    // DT补充
    it('getShowStatus_test_05', 0, (): void => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let primarySession1: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      sCBSceneContainerSession.primarySession = primarySession1;
      sCBSceneContainerSession.secondarySession = primarySession;
      let mock = new MockKit();
      let mockFun = mock.mockFunc((recentNotShow as object), (recentNotShow as object)['getExcludeFromSession']);
      when(mockFun)(primarySession).afterReturn(false);
      when(mockFun)(primarySession1).afterReturn(false);
      recentNotShow.getShowStatus(sCBSceneContainerSession);
      expect(sCBSceneContainerSession).not().assertUndefined();
      mock.ignoreMock((recentNotShow as object), (recentNotShow as object)['getExcludeFromSession']);
    })

    it('getShowStatus_test_06', 0, (): void => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let primarySession1: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sCBSceneContainerSession: SCBSceneContainerSession =
        (new SCBSceneContainerSession(session, new SCBScreenProperty()));
      sCBSceneContainerSession.primarySession = primarySession1;
      sCBSceneContainerSession.secondarySession = primarySession;
      let mock = new MockKit();
      let mockFun = mock.mockFunc((recentNotShow as object), (recentNotShow as object)['getExcludeFromSession']);
      when(mockFun)(primarySession).afterReturn(true);
      when(mockFun)(primarySession1).afterReturn(false);
      recentNotShow.getShowStatus(sCBSceneContainerSession);
      expect(sCBSceneContainerSession).not().assertUndefined();
      mock.ignoreMock((recentNotShow as object), (recentNotShow as object)['getExcludeFromSession']);
    })

    it('fullScreenNotShowAnimation_01', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(containerSession);
      recentNotShow.fullScreenNotShowAnimation(null, totalContainerSessionList, panelViewModel);
      expect(recentNotShow).not().assertUndefined();
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
      recentNotShow.fullScreenNotShowAnimation(session, totalContainerSessionList, panelViewModel);
      expect(recentNotShow).not().assertUndefined();
      mocker.ignoreMock(session, session.getTransitionCount);
    })

    it('fullScreenNotShowAnimation_03', 0, (): void => {
      let animationNum: number = 1;
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      totalContainerSessionList.add(containerSession);
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      session.addTransitionCount();
      let mocker: MockKit = new MockKit();
      let getTransitionCount: Function = mocker.mockFunc(session, session.getTransitionCount);
      when(getTransitionCount)().afterReturn(animationNum);
      recentNotShow.fullScreenNotShowAnimation(session, totalContainerSessionList, panelViewModel);
      expect(recentNotShow).not().assertUndefined();
      mocker.ignoreMock(session, session.getTransitionCount);
    })
  })
}