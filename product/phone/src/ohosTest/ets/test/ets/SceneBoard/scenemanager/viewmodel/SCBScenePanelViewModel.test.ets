/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import Want from '@ohos.app.ability.Want';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CallerInfo } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneInfo';
import {
  SCBScreenProperty,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBSceneInfo,
  SCBSceneSessionManager,
  SCBScreenSession,
  SCBContainerRotationReason,
  SCBSceneMode,
  RecentViewParam,
  SCBKeyboardSession,
  SCBKeyboardPanelSession,
  ScenePanelState,
  SCBScenePanelSession,
  SCBSceneSessionArray,
  SCBScreenSessionManager,
  SCBScreenSession
} from '@ohos/windowscene/src/main/ets/TsIndex';
import {
  describe,
  beforeAll,
  it,
  expect,
  Level,
  beforeEach,
  MockKit,
  when,
  ArgumentMatchers,
  afterEach,
  afterAll
} from '@ohos/hypium';
import {
  SCBScenePanelViewModel,
  ScenePanelDataCollectionHandler,
  ScenePanelStateCollectionHandler,
  TerminateSceneEntryParam
} from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/viewmodel/SCBScenePanelViewModel';
import screenSessionManager from '@ohos.screenSessionManager';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { ReflectionUtils } from '../multiwindow/ReflectionUtils';
import { bundleManager } from '@kit.AbilityKit';
import { RecentStateManager } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/innerstate/RecentStates';
import { RecentDelete } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentDelete';
import { UIContext } from '@kit.ArkUI';
import { AppFloating } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/apppanel/AppFloating';
import {
  QuickSwitchAnimations
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/quickswitchpanel/QuickSwitchAnimations';
import { SCBPhoneSceneUtils } from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/utils/SCBPhoneSceneUtils';
import { CloseAppManager } from '@ohos/launchercommon';

const MOCK_TAG = 'SCBScenePanelViewModel';
const mockLog = LogHelper.getLogHelper(LogDomain.WINDOW, MOCK_TAG);
const RECENT_TAG = 'RecentPanel';
const recentLog = LogHelper.getLogHelper(LogDomain.RECENT, RECENT_TAG);
const TAG = 'SCBScenePanelViewModelTest';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

// 最大app打开数量限制
const MAX_SESSION_LIMIT_ALL_APP = 512;

// collectionHandler实现
let handlerViewParam: RecentViewParam;
let handlerKeyboardSession: SCBKeyboardSession;
let handleKeyboardPanelSession: SCBKeyboardPanelSession;
let handleVisibility: Visibility;
let handleScenePanelState: ScenePanelState;
let handleRecentStateManager: RecentStateManager;
let handleScreenProperty: SCBScreenProperty;
let handlerScenePanelSession: SCBScenePanelSession;
let handlerAppFloating: AppFloating;
let uiContext: UIContext = new UIContext();
const vm = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());

enum SCBTripleStateChange {
  INVALID,
  F_TO_M,
  F_TO_G,
  M_TO_F,
  M_TO_G,
  G_TO_F,
  G_TO_M,
}

let foldExpandStateChange: SCBTripleStateChange;
let needFoldExpandSnapShot: boolean;
let foldExpandSnapShotSessionId: number;
let foldAnimNum: number;
const panelStateCollectionHandler: ScenePanelStateCollectionHandler = {
  getPanelState: (): ScenePanelState => {
    return handleScenePanelState;
  },

  updatePanelState: (state: ScenePanelState) => {
    handleScenePanelState = state;
  },

  getViewParam: (): RecentViewParam => {
    return handlerViewParam;
  },

  getKeyboardSession: (): SCBKeyboardSession => {
    return handlerKeyboardSession;
  },

  getKeyboardPanelSession: (): SCBKeyboardPanelSession => {
    return handleKeyboardPanelSession;
  },

  getBlackBackgroundState: (): boolean => {
    return true;
  },

  updateBlackBackgroundState: () => {
  },

  getRecentInnerState: (): RecentStateManager => {
    return handleRecentStateManager;
  },

  getMattesLockState: (): boolean => {
    return true;
  },

  updateMattesLockState: () => {
  },

  getBgGrayScaleDisableState: (): boolean => {
    return true;
  },

  updateBgGrayScaleDisableState: () => {
  },

  getPanelVisibleState: (): Visibility => {
    return handleVisibility;
  },

  updatePanelVisibleState: () => {
  },

  getScrollingState: (): boolean => {
    return true;
  },

  updateScrollingState: () => {
  },

  getPhysicalScreenProperty: (): SCBScreenProperty => {
    return handleScreenProperty;
  },

  updateNeedScrollClip: () => {
  },
  updateUnLockScale: () => {
  },
  getCompanionIconShowState: (): boolean => {
    return true;
  },
  updateCompanionIconShowState: () => {
  },
  getIconWithBadgeState: (): boolean => {
    return true;
  },
  updateIconWithBadgeState: () => {
  },
  getPanelSession: (): SCBScenePanelSession => {
    return handlerScenePanelSession;
  },
  getNeedScrollClip: (): boolean => {
    return true;
  },
  getIsEmptyRecentViewCallback: (): Function => {
    throw new Error('Function not implemented.');
  },
  getFoldExpandStateChange: (): SCBTripleStateChange => {
    return foldExpandStateChange;
  },
  setFoldExpandStateChange: (change: SCBTripleStateChange): void => {
  },
  getNeedFoldExpandSnapShot: (): boolean => {
    return needFoldExpandSnapShot;
  },
  setNeedFoldExpandSnapShot: (isNeed: boolean): void => {
  },
  getFoldExpandSnapShotSessionId: (): number => {
    return foldExpandSnapShotSessionId;
  },
  setFoldExpandSnapShotSessionId: (sessionId: number): void => {
  },
  getFoldAnimNum: (): number => {
    return foldAnimNum;
  },
  setFoldAnimNum: (animNum: number): void => {
  }
};

const panelDataCollectionHandler: ScenePanelDataCollectionHandler = {
  getIsTouchableByNavBar: (): boolean => {
    return true;
  },

  getFromScenePanelState: (): ScenePanelState => {
    return handleScenePanelState;
  },

  setFromScenePanelState: () => {
  },

  setCurrRotation: () => {
  },

  getCurrRotation: (): number => {
    return 0;
  },

  getRotationAnimCnt: (): number => {
    return 0;
  },

  setRotationAnimCnt: () => {
  },

  addRotationAnimCnt: () => {
  },

  decRotationAnimCnt: () => {
  },

  getRotateFinishTimerId: (): number => {
    return 0;
  },

  setRotateFinishTimerId: () => {
  },

  getPanelName: (): string => {
    return '';
  },

  getRecentStartNotifyRotation: (): number | undefined => {
    return 0;
  },

  setRecentStartNotifyRotation: () => {
  },

  setExpandStartContainerSession: () => {
  },

  getIsSupportMaximizeScene: (): boolean => {
    return true;
  },

  setIsSupportMaximizeScene: () => {
  },

  getIsNeedChangeToMultiRow: (): boolean => {
    return true;
  },

  setIsNeedChangeToMultiRow: () => {
  },

  getNeedRemoveBlank: (): boolean => {
    return true;
  },

  setNeedRemoveBlank: () => {
  },

  getClearAllAnimCnt: (): number => {
    return 0;
  },

  getRecentDelete: (): RecentDelete => {
    return new RecentDelete(vm.getPanelManager());
  },
  updateLandscapeExitTimeOutId: (timerID: number): void => {
  },
  getQuickSwitchAnimations: (): QuickSwitchAnimations => {
    return new QuickSwitchAnimations(vm.getPanelManager());
  },
  getOneStepSplitExitFlag: (): boolean => {
    return true;
  },
  setOneStepSplitExitFlag: (oneStepSplitExitFlag: boolean): void => {
  },
  getOneStepSplitContainerID: (): number => {
    return 0;
  },
  setOneStepSplitContainerID: (oneStepSplitContainerID: number): void => {
  },
  getAppFloating: (): AppFloating => {
    return handlerAppFloating;
  },
  getAnimationFinishedCallback: () => {
    return panelDataCollectionHandler.getOneStepSplitExitFlag;
  }
}

export default function SCBScenePanelViewModelTest() {

  describe('SCBScenePanelViewModel_getSceneSessionByPersistentId_testSuite', () => {
    let scbScenePanelViewModel: SCBScenePanelViewModel;
    let mocker: MockKit;

    beforeAll(() => {
      scbScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    });

    beforeEach(() => {
      mocker = new MockKit();
      let panelMgr = scbScenePanelViewModel.getPanelManager();
      panelMgr.getSceneContainerSessionList().clear();
      panelMgr.getFloatingSessionList().clear();
      panelMgr.getNotShowRecentList().clear();
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().clear();
    });

    it('test_whenContainerSessionListIsEmpty_thenReturnNull', Level.LEVEL0, () => {
      const result: SCBSceneSession | null = scbScenePanelViewModel.getSceneSessionByPersistentId(123);
      expect(result).assertNull();
    });

    it('test_whenContainerSessionListIncludeSession_thenSuccess', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbScenePanelViewModel.getContainerSessionList()
        .push(new SCBSceneContainerSession(sceneSession, new SCBScreenProperty()));

      const result: SCBSceneSession | null = scbScenePanelViewModel.getSceneSessionByPersistentId(123);
      expect(result).assertEqual(sceneSession);
    });

    it('test_whenFloatContainerSessionListIncludeSession_thenSuccess', Level.LEVEL0, () => {
      let mockLogShowInfo: Function = mocker.mockFunc(mockLog, mockLog.showInfo);
      when(mockLogShowInfo)(ArgumentMatchers.any).afterReturnNothing();

      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbScenePanelViewModel.getFloatingSessionList()
        .push(new SCBSceneContainerSession(sceneSession, new SCBScreenProperty()));

      const result: SCBSceneSession | null = scbScenePanelViewModel.getSceneSessionByPersistentId(123);
      expect(result).assertEqual(sceneSession);
    });

    it('test_whenFloatContainerSessionListIncludeAndSessionUnavailable_thenReturnNull',
      Level.LEVEL0, () => {
      let mockLogShowError: Function = mocker.mockFunc(mockLog, mockLog.showError);
      when(mockLogShowError)(ArgumentMatchers.any).afterReturnNothing();

      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      ReflectionUtils.setProperty(sceneSession, "session", null);
      scbScenePanelViewModel.getFloatingSessionList().push(containerSession);

      const result: SCBSceneSession | null = scbScenePanelViewModel.getSceneSessionByPersistentId(123, true);
      expect(result).assertNull();
    });

    it('test_whenSpecialContainerSessionListIncludeSession_thenSuccess', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList()
        .push(new SCBSceneContainerSession(sceneSession, new SCBScreenProperty()));

      const result: SCBSceneSession | null =
        scbScenePanelViewModel.getSceneSessionByPersistentId(sceneSession.sceneInfo.persistentId);
      expect(result).assertEqual(sceneSession);
    });
  });

  describe('SCBScenePanelViewModel_getFloatSessionWithPersistentIdWhenInRecent_testSuite', () => {

    let scbScenePanelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());

    beforeAll(() => {
      scbScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    });

    it('test_whenFloatContainerSessionListIsNull_thenReturnNull', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();

      const result: SCBSceneContainerSession | null =
        scbScenePanelViewModel.getFloatSessionWithPersistentIdWhenInRecent(123);
      expect(result).assertNull();

      mocker.verify('getInstance', []).atLeast(1);
    });

    it('test_whenPadFloatingSessionListIsEmpty_thenReturnNull', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();

      const result: SCBSceneContainerSession | null =
        scbScenePanelViewModel.getFloatSessionWithPersistentIdWhenInRecent(123);
      expect(result).assertNull();

      mocker.verify('getInstance', []).atLeast(1);
    });

    it('test_whenPadFloatingSessionListNotIncludeSession_thenReturnNull', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let floatingSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 100);
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      floatingSessionList.push(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));

      const result: SCBSceneContainerSession | null =
        scbScenePanelViewModel.getFloatSessionWithPersistentIdWhenInRecent(123);
      expect(result).assertNull();

      mocker.verify('getInstance', []).atLeast(1);
    });

    it('test_whenPadFloatingSessionListIncludeSession_thenSuccess', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let floatingSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let primarySession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      floatingSessionList.push(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));

      const result: SCBSceneContainerSession | null =
        scbScenePanelViewModel.getFloatSessionWithPersistentIdWhenInRecent(123);
      expect(result).assertDeepEquals(floatingSessionList[0]);

      mocker.verify('getInstance', []).atLeast(1);
    });
  })

  describe('SCBScenePanelViewModel_clearToPersistentIdForSession_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel;
    beforeAll(() => {
      panelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('should_not_process_when_persistentId_is_zero', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let mockGetSceneSessionByPersistentId: Function = mocker.mockFunc(panelViewModel,
        panelViewModel.getSceneSessionByPersistentId);
      when(mockGetSceneSessionByPersistentId)(0).afterReturn(null);
      panelViewModel.clearToPersistentIdForSession(0);
      mocker.verify('getSceneSessionByPersistentId', [0]).never();
      mocker.ignoreMock(panelViewModel, panelViewModel.getSceneSessionByPersistentId);
    });

    it('should_clear_toPersistentId_when_session_exists_and_sceneInfo_is_not_null', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let mockGetSceneSessionByPersistentId: Function = mocker.mockFunc(panelViewModel,
        panelViewModel.getSceneSessionByPersistentId);
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let session = sceneSessionManager.requestSceneSession(sceneInfo);
      let mockSceneSession: SCBSceneSession = new SCBSceneSession(session, sceneInfo);
      sceneInfo.toPersistentId = 111;
      mockSceneSession.sceneInfo = sceneInfo;
      when(mockGetSceneSessionByPersistentId)(1).afterReturn(mockSceneSession);
      panelViewModel.clearToPersistentIdForSession(1);
      expect(mockSceneSession.sceneInfo.toPersistentId).assertEqual(0);
      mocker.verify('getSceneSessionByPersistentId', [1]).atLeast(1);
      mocker.ignoreMock(panelViewModel, panelViewModel.getSceneSessionByPersistentId);
    });

    it('should_not_clear_toPersistentId_when_session_does_not_exist', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let mockGetSceneSessionByPersistentId: Function = mocker.mockFunc(panelViewModel,
        panelViewModel.getSceneSessionByPersistentId);
      let mockLogShowInfo: Function = mocker.mockFunc(mockLog, mockLog.showInfo);
      when(mockGetSceneSessionByPersistentId)(1).afterReturn(null);
      when(mockLogShowInfo)(ArgumentMatchers.any).afterReturnNothing();
      panelViewModel.clearToPersistentIdForSession(1);
      mocker.verify('getSceneSessionByPersistentId', [1]).atLeast(1);
      mocker.ignoreMock(panelViewModel, panelViewModel.getSceneSessionByPersistentId);
      mocker.ignoreMock(mockLog, mockLog.showError);
    });
  });

  describe('SCBScenePanelViewModel_clearCallerPersistentIdForSession_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel;
    let mocker: MockKit = new MockKit();
    beforeAll(() => {
      panelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('should_not_clear_callerPersistentId_when_persistentId_is_zero', Level.LEVEL0, () => {
      let mockLogShowInfo: Function = mocker.mockFunc(mockLog, mockLog.showInfo);
      panelViewModel.clearCallerPersistentIdForSession(0);
      mocker.verify('showInfo', []).never();
      mocker.ignoreMock(mockLog, mockLog.showInfo);
    });

    it('should_not_clear_callerPersistentId_when_persistentId_is_negative', Level.LEVEL0, () => {
      let mockLogShowInfo: Function = mocker.mockFunc(mockLog, mockLog.showInfo);
      panelViewModel.clearCallerPersistentIdForSession(-1);
      mocker.verify('showInfo', []).never();
      mocker.ignoreMock(mockLog, mockLog.showInfo);
    });

    it('should_clear_callerPersistentId_when_session_exists_and_persistentId_is_positive', Level.LEVEL0, () => {
      let mockLogShowInfo: Function = mocker.mockFunc(mockLog, mockLog.showInfo);
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let session = sceneSessionManager.requestSceneSession(sceneInfo);
      let mockSceneSession: SCBSceneSession = new SCBSceneSession(session, sceneInfo);
      mockSceneSession.sceneInfo.callerPersistentId = 1;
      let mockGetSession: Function = mocker.mockFunc(panelViewModel, panelViewModel.getSceneSessionByPersistentId);
      when(mockGetSession)(1).afterReturn(mockSceneSession);
      panelViewModel.clearCallerPersistentIdForSession(1);
      expect(mockSceneSession.sceneInfo.callerPersistentId).assertEqual(0);
      mocker.ignoreMock(panelViewModel, panelViewModel.getSceneSessionByPersistentId);
    });

    it('should_not_clear_callerPersistentId_when_session_does_not_exist', Level.LEVEL0, () => {
      let mockLogShowInfo: Function = mocker.mockFunc(mockLog, mockLog.showInfo);
      let mockGetSession: Function = mocker.mockFunc(panelViewModel, panelViewModel.getSceneSessionByPersistentId);
      when(mockGetSession)(1).afterReturn(null);
      panelViewModel.clearCallerPersistentIdForSession(1);
      mocker.verify('showInfo', []).never();
      mocker.ignoreMock(panelViewModel, panelViewModel.getSceneSessionByPersistentId);
    });
  });

  describe('SCBScenePanelViewModel_getSceneSession_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    let mocker: MockKit = new MockKit();
    let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let panelMgr = panelViewModel.getPanelManager();

    beforeAll(() => {
      panelMgr.getSceneContainerSessionList().clear();
      panelMgr.getFloatingSessionList().clear();
      panelMgr.getNotShowRecentList().clear();
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().clear();
    });

    beforeEach(() => {
    });

    afterEach(() => {
      panelMgr.getSceneContainerSessionList().clear();
      panelMgr.getFloatingSessionList().clear();
      panelMgr.getNotShowRecentList().clear();
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().clear();
    });

    afterAll(() => {
    });

    it('should_return_session_from_containerSessionList', Level.LEVEL0, () => {
      panelViewModel.getContainerSessionList().push(new SCBSceneContainerSession(sceneSession, new SCBScreenProperty()));
      const result: SCBSceneSession | null = panelViewModel.getSceneSession(sceneInfo);
      expect(result).assertEqual(sceneSession);
    });

    it('should_return_session_from_floatingSessionList', Level.LEVEL0, () => {
      panelViewModel.getFloatingSessionList().push(new SCBSceneContainerSession(sceneSession, new SCBScreenProperty()));
      const result: SCBSceneSession | null = panelViewModel.getSceneSession(sceneInfo);
      expect(result).assertEqual(sceneSession);
    });

    it('should_return_session_from_padFloatingSessionList', Level.LEVEL0, () => {
      const result: SCBSceneSession | null = panelViewModel.getSceneSession(sceneInfo);
      expect(result).assertEqual(sceneSession);
    });

    it('should_return_session_from_containerSessionListNotShowRecent', Level.LEVEL0, () => {
      panelViewModel.getContainerSessionListNotShowRecent()
        .push(new SCBSceneContainerSession(sceneSession, new SCBScreenProperty()));
      const result: SCBSceneSession | null = panelViewModel.getSceneSession(sceneInfo);
      expect(result).assertEqual(sceneSession);
    });

    it('should_return_session_from_specialContainerSessionList', Level.LEVEL0, () => {
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList()
        .push(new SCBSceneContainerSession(sceneSession, new SCBScreenProperty()));
      const result: SCBSceneSession | null = panelViewModel.getSceneSession(sceneInfo);
      expect(result).assertEqual(sceneSession);
    });

    it('should_return_null_when_no_session_found', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundleFail', 'testPriModuleFail', 'testPriAbilityFail', 0, 456);
      const result: SCBSceneSession | null = panelViewModel.getSceneSession(sceneInfo);
      expect(result).assertEqual(null);
    });
  });

  describe('SCBScenePanelViewModel_linkCallerAndToPersistentForSession_testSuite', () => {

    let scbScenePanelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    let sceneSession: SCBSceneSession;
    let toSceneSession: SCBSceneSession;
    let callerSceneSession: SCBSceneSession;
    let toSceneInfo: SCBSceneInfo;
    let sceneInfo: SCBSceneInfo;
    let callerSceneInfo: SCBSceneInfo;
    let mocker: MockKit;
    mocker = new MockKit();
    beforeAll(() => {
      scbScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    });

    beforeEach(() => {
      sceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 123);
      sceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

      toSceneInfo = new SCBSceneInfo('testToBundle', 'testToModule', 'testToAbility', 0, 124);
      toSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(toSceneInfo), toSceneInfo);

      callerSceneInfo = new SCBSceneInfo('testCallerBundle', 'testCallerModule', 'testCallerAbility', 0, 122);
      callerSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(callerSceneInfo), callerSceneInfo);

      scbScenePanelViewModel.getPanelManager()
        .addSceneContainerSession(new SCBSceneContainerSession(sceneSession, new SCBScreenProperty()));
      scbScenePanelViewModel.getPanelManager()
        .addSceneContainerSession(new SCBSceneContainerSession(toSceneSession, new SCBScreenProperty()));
      scbScenePanelViewModel.getPanelManager()
        .addSceneContainerSession(new SCBSceneContainerSession(callerSceneSession, new SCBScreenProperty()));
    });

    afterEach(() => {
      scbScenePanelViewModel.getContainerSessionList().clear();
    });


    /**
     * 用例描述: 连接当前session的callerSession和toSession
     * 预置条件: 当前session的callerSession不为空，toSession为空
     * 测试场景: 连接当前session的callerSession和toSession
     * 预期结果: callerSession的toSession置为空，当前session的caller和to均为空
     */
    it('test_whenCallerPersistentIdIsValid_thenSuccess', Level.LEVEL0, () => {
      // 前置条件
      sceneInfo.callerPersistentId = 122;
      sceneInfo.toPersistentId = 0;

      scbScenePanelViewModel.linkCallerAndToPersistentForSession(sceneSession);

      expect(callerSceneSession.sceneInfo.toPersistentId).assertEqual(0);
      expect(sceneSession.sceneInfo.callerPersistentId).assertEqual(0);
      expect(toSceneSession.sceneInfo.toPersistentId).assertEqual(0);
      mocker.ignoreMock(scbScenePanelViewModel, scbScenePanelViewModel.getSceneSessionByPersistentId);
    });

    /**
     * 用例描述: 连接当前session的callerSession和toSession
     * 预置条件: 当前session的callerSession为空，toSession不为空
     * 测试场景: 连接当前session的callerSession和toSession
     * 预期结果: toSession的callerSession置为空，当前session的caller和to均为空
     */
    it('test_whenToPersistentIdIsValid_thenSuccess', Level.LEVEL0, () => {
      // 前置条件
      sceneInfo.toPersistentId = 124;
      sceneInfo.callerPersistentId = 0;

      scbScenePanelViewModel.linkCallerAndToPersistentForSession(sceneSession);

      expect(toSceneSession.sceneInfo.callerPersistentId).assertEqual(0);
      expect(sceneSession.sceneInfo.callerPersistentId).assertEqual(0);
      expect(toSceneSession.sceneInfo.toPersistentId).assertEqual(0);
      mocker.ignoreMock(scbScenePanelViewModel, scbScenePanelViewModel.getSceneSessionByPersistentId);
    });
  });

  describe('SCBScenePanelViewModel_updateCallerSessionIdAndToSessionId_testSuite', () => {

    let scbScenePanelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    let sceneSession: SCBSceneSession;
    let sceneInfo: SCBSceneInfo;
    let callerSceneSession: SCBSceneSession;
    let callerSceneInfo: SCBSceneInfo;

    beforeAll(() => {
      scbScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
      sceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 123);
      sceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    });

    beforeEach(() => {
      scbScenePanelViewModel.getContainerSessionList().clear();


      callerSceneInfo = new SCBSceneInfo('testCallerBundle', 'testCallerModule', 'testCallerAbility', 0, 122);
      callerSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(callerSceneInfo), callerSceneInfo);
    });

    /**
     * 用例描述: 更新当前session的caller
     * 预置条件: newCallerSession与当前session的caller不同
     * 测试场景: 更新当前session的caller为入参newCallerPersistentId
     * 预期结果: 当前session链接到newCallerSession之后
     */
    it('test_whenNewCallerPersistentIdIsDifferentFromCurrentCallerPersistentId_thenSuccess',
      Level.LEVEL0, () => {

        scbScenePanelViewModel.getPanelManager()
          .addSceneContainerSession(new SCBSceneContainerSession(callerSceneSession, new SCBScreenProperty()));
        scbScenePanelViewModel.getPanelManager()
          .addSceneContainerSession(new SCBSceneContainerSession(sceneSession, new SCBScreenProperty()));

        // 更新session:123的caller为122
        scbScenePanelViewModel.updateCallerSessionIdAndToSessionId(sceneSession, 122);
        // session:123链接到session:122之后
        expect(sceneSession.sceneInfo.callerPersistentId).assertEqual(callerSceneSession.sceneInfo.persistentId);
        expect(callerSceneSession.sceneInfo.toPersistentId).assertEqual(sceneSession.sceneInfo.persistentId);
      });

    /**
     * 用例描述: 更新当前session的caller
     * 预置条件: newCallerSession已存在toSession
     * 测试场景: 更新当前session的caller为入参newCallerPersistentId
     * 预期结果: 当前session链接到newCallerSession之后
     */
    it('test_whenNewCallerPersistentIdIsEqualCurrentCallerPersistentId_thenSuccess', Level.LEVEL0, () => {
      sceneSession.sceneInfo.callerPersistentId = callerSceneSession.sceneInfo.persistentId;
      sceneSession.sceneInfo.toPersistentId = 128;
      scbScenePanelViewModel.getPanelManager()
        .addSceneContainerSession(new SCBSceneContainerSession(callerSceneSession, new SCBScreenProperty()));
      scbScenePanelViewModel.getPanelManager()
        .addSceneContainerSession(new SCBSceneContainerSession(sceneSession, new SCBScreenProperty()));

      // 更新session:123的caller为122
      scbScenePanelViewModel.updateCallerSessionIdAndToSessionId(sceneSession,
        callerSceneSession.sceneInfo.persistentId);

      // session:123链接到session:122之后
      expect(sceneSession.sceneInfo.callerPersistentId).assertEqual(0);
      expect(callerSceneSession.sceneInfo.toPersistentId).assertEqual(128);
    });

    /**
     * 用例描述: 更新当前session的caller
     * 预置条件: newCallerSession已存在toSession
     * 测试场景: 更新当前session的caller为入参newCallerPersistentId
     * 预期结果: 当前session链接到newCallerSession链的末尾
     */
    it('test_whenNewCallerPersistentIdIsEqualCurrentCallerPersistentId_thenReturnSuccess', Level.LEVEL0, () => {
      // 构造122 -> 126的调用链
      sceneSession.sceneInfo.callerPersistentId = callerSceneSession.sceneInfo.persistentId;
      sceneSession.sceneInfo.toPersistentId = 124;

      let midSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 126);
      midSceneInfo.callerPersistentId = callerSceneSession.sceneInfo.persistentId;
      let midSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(midSceneInfo), midSceneInfo);

      callerSceneSession.sceneInfo.toPersistentId = midSceneSession.sceneInfo.persistentId;
      scbScenePanelViewModel.getPanelManager()
        .addSceneContainerSession(new SCBSceneContainerSession(callerSceneSession, new SCBScreenProperty()));
      scbScenePanelViewModel.getPanelManager()
        .addSceneContainerSession(new SCBSceneContainerSession(sceneSession, new SCBScreenProperty()));
      scbScenePanelViewModel.getPanelManager()
        .addSceneContainerSession(new SCBSceneContainerSession(midSceneSession, new SCBScreenProperty()));

      // 更新session:123的caller为122
      scbScenePanelViewModel.updateCallerSessionIdAndToSessionId(sceneSession,
        callerSceneSession.sceneInfo.persistentId);

      // session:123链接到session:126之后
      expect(sceneSession.sceneInfo.callerPersistentId).assertEqual(0);
      expect(midSceneSession.sceneInfo.toPersistentId).assertEqual(0);
    });

    /**
     * 测试场景: 初始全屏session拉起悬浮窗session后再拉起全屏session
     * 预期结果: 悬浮窗session和拉起的全屏session的callerPersistentId为初始全屏session
     */
    it('test_openFloatingWindowInFullScreenScene_thenReturnSuccess', Level.LEVEL0, () => {
      // 构造sceneSession -> callerSceneSession的调用链
      sceneSession.sceneInfo.callerPersistentId = callerSceneSession.sceneInfo.persistentId;
      sceneSession.sceneInfo.toPersistentId = 124;
      let containerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      scbScenePanelViewModel.getFloatingSessionList().push(containerSession);
      containerSession.isFloat = true;

      let midSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 126);
      midSceneInfo.callerPersistentId = callerSceneSession.sceneInfo.persistentId;
      let midSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(midSceneInfo), midSceneInfo);

      sceneSession.sceneInfo.toPersistentId = midSceneSession.sceneInfo.persistentId;
      midSceneSession.sceneInfo.callerPersistentId = callerSceneSession.sceneInfo.toPersistentId;

      scbScenePanelViewModel.getPanelManager()
        .addSceneContainerSession(new SCBSceneContainerSession(callerSceneSession, new SCBScreenProperty()));
      scbScenePanelViewModel.getPanelManager()
        .addSceneContainerSession(new SCBSceneContainerSession(sceneSession, new SCBScreenProperty()));
      scbScenePanelViewModel.getPanelManager()
        .addSceneContainerSession(new SCBSceneContainerSession(midSceneSession, new SCBScreenProperty()));

      scbScenePanelViewModel.updateCallerSessionIdAndToSessionId(midSceneSession,
        callerSceneSession.sceneInfo.persistentId);

      expect(sceneSession.sceneInfo.callerPersistentId).assertEqual(callerSceneSession.sceneInfo.persistentId);
      expect(midSceneSession.sceneInfo.callerPersistentId).assertEqual(callerSceneSession.sceneInfo.persistentId);
    });
  })

  describe('SCBScenePanelViewModel_deleteCallerChainForSceneSession_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
    let panelMgr = panelViewModel.getPanelManager();

    beforeAll(() => {
      panelMgr.getSceneContainerSessionList().clear();
      panelMgr.getFloatingSessionList().clear();
      panelMgr.getNotShowRecentList().clear();
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().clear();
    });

    beforeEach(() => {
    });

    afterEach(() => {
      panelMgr.getSceneContainerSessionList().clear();
      panelMgr.getFloatingSessionList().clear();
      panelMgr.getNotShowRecentList().clear();
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().clear();
    });

    afterAll(() => {
    });

    /**
     * 用例描述: 清理调用链上游和自己
     * 预置条件: 创建调用链上游和自己，放入containerSessionList，
     * 测试场景: 当callerPersistentId存在，需要清理调用链上游和自己
     * 预期结果: callerSceneSession的toPersistentId为0，sceneSession的callerPersistentId为0
     */
    it('test_should_clear_caller_persistent_id_and_persistent_id_when_sceneInfo_defined_and_has_callerPersistentId',
      Level.LEVEL0, () => {
      // 构造调用链上游和自己
      let callerSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 9527);
      callerSceneInfo.toPersistentId = sceneInfo.persistentId;
      let callerSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(callerSceneInfo), callerSceneInfo);
      sceneInfo.callerPersistentId = callerSceneInfo.persistentId;
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      panelViewModel.getContainerSessionList().
        push(new SCBSceneContainerSession(callerSceneSession, new SCBScreenProperty()));
      panelViewModel.getContainerSessionList().push(new SCBSceneContainerSession(sceneSession, new SCBScreenProperty()));

      // 清理调用链
      panelViewModel.deleteCallerChainForSceneSession(sceneInfo);

      // 判断调用链清理结果
      expect(callerSceneSession.sceneInfo.toPersistentId).assertEqual(0);
      expect(sceneSession.sceneInfo.callerPersistentId).assertEqual(0);
    });

    /**
     * 用例描述: 清理调用链上游和自己
     * 预置条件: 创建调用链上游和自己，放入containerSessionList，
     * 测试场景: 当callerPersistentId不存在，不需要清理调用链上游，只清理自己
     * 预期结果: callerSceneSession的toPersistentId不变，sceneSession的callerPersistentId为0
     */
    it('test_should_only_clear_persistent_id_when_sceneInfo_is_defined_and_has_no_callerPersistentId', Level.LEVEL0, () => {
      // 构造调用链上游和自己
      let callerSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 9527);
      callerSceneInfo.toPersistentId = sceneInfo.persistentId;
      let callerSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(callerSceneInfo), callerSceneInfo);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      sceneSession.sceneInfo.callerPersistentId = undefined;
      panelViewModel.getContainerSessionList()
        .push(new SCBSceneContainerSession(callerSceneSession, new SCBScreenProperty()));
      panelViewModel.getContainerSessionList().push(new SCBSceneContainerSession(sceneSession, new SCBScreenProperty()));

      // 清理调用链
      panelViewModel.deleteCallerChainForSceneSession(sceneInfo);

      // 判断调用链清理结果
      expect(callerSceneSession.sceneInfo.toPersistentId).assertEqual(123);
      expect(sceneSession.sceneInfo.callerPersistentId).assertEqual(0);
    });
  });

  describe('SCBScenePanelViewModel_deleteToChainForSceneSession_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
    let panelMgr = panelViewModel.getPanelManager();

    beforeAll(() => {
      panelMgr.getSceneContainerSessionList().clear();
      panelMgr.getFloatingSessionList().clear();
      panelMgr.getNotShowRecentList().clear();
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().clear();
    });

    beforeEach(() => {
    });

    afterEach(() => {
      panelMgr.getSceneContainerSessionList().clear();
      panelMgr.getFloatingSessionList().clear();
      panelMgr.getNotShowRecentList().clear();
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().clear();
    });

    afterAll(() => {
    });

    /**
     * 用例描述: 清理调用链下游和自己
     * 预置条件: 创建调用链下游和自己，放入containerSessionList，
     * 测试场景: 当toPersistentId存在，需要清理调用链下游和自己
     * 预期结果: toSceneSession的callerPersistentId为0，sceneSession的toPersistentId为0
     */
    it('test_should_clear_caller_persistent_id_and_persistent_id_when_sceneInfo_is_defined_and_has_callerPersistentId',
      Level.LEVEL0, () => {
      // 构造调用链下游和自己
      let toSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 9527);
      toSceneInfo.callerPersistentId = sceneInfo.persistentId;
      let toSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(toSceneInfo), toSceneInfo);
      sceneInfo.toPersistentId = toSceneInfo.persistentId;
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      panelViewModel.getContainerSessionList().push(new SCBSceneContainerSession(sceneSession, new SCBScreenProperty()));
      panelViewModel.getContainerSessionList().push(new SCBSceneContainerSession(toSceneSession, new SCBScreenProperty()));

      // 清理调用链
      panelViewModel.deleteToChainForSceneSession(sceneInfo);

      // 判断调用链清理结果
      expect(toSceneSession.sceneInfo.callerPersistentId).assertEqual(0);
      expect(sceneSession.sceneInfo.toPersistentId).assertEqual(0);
    });

    /**
     * 用例描述: 清理调用链下游和自己
     * 预置条件: 创建调用链下游和自己，放入containerSessionList，
     * 测试场景: 当toPersistentId不存在，不需要清理调用链下游，只清理自己
     * 预期结果: toSceneSession的callerPersistentId不变，sceneSession的toPersistentId为0
     */
    it('test_should_only_clear_persistent_id_when_sceneInfo_is_defined_and_has_no_callerPersistentId', Level.LEVEL0, () => {
      // 构造调用链下游和自己
      let toSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 9527);
      toSceneInfo.callerPersistentId = sceneInfo.persistentId;
      let toSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(toSceneInfo), toSceneInfo);
      sceneInfo.toPersistentId = 0;
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      panelViewModel.getContainerSessionList().push(new SCBSceneContainerSession(sceneSession, new SCBScreenProperty()));
      panelViewModel.getContainerSessionList().push(new SCBSceneContainerSession(toSceneSession, new SCBScreenProperty()));

      // 清理调用链
      panelViewModel.deleteToChainForSceneSession(sceneInfo);

      // 判断调用链清理结果
      expect(toSceneSession.sceneInfo.callerPersistentId).assertEqual(123);
      expect(sceneSession.sceneInfo.toPersistentId).assertEqual(0);
    });
  });

  describe('SCBScenePanelViewModel_needStartCallerFromException_testSuite', () => {
    let scbScenePanelViewModel: SCBScenePanelViewModel;
    let mocker: MockKit;

    beforeAll(() => {
      scbScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
      mocker = new MockKit();
      scbScenePanelViewModel.getContainerSessionList().clear();
    });

    /**
     * 用例描述: session异常退出时是否需要返回调用方
     * 预置条件: 根据当前persistentId找不到session
     * 测试场景: 判断是否需要返回调用方
     * 预期结果: 需要返回调用方
     */
    it('test_whenSceneSessionIsNull_thenReturnTrue', Level.LEVEL0, () => {
      let mockFunc: Function =
        mocker.mockFunc(scbScenePanelViewModel, scbScenePanelViewModel.getSceneSessionByPersistentId);
      when(mockFunc)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);

      let result: boolean = scbScenePanelViewModel.needStartCallerFromException(1);

      expect(result).assertTrue();
      mocker.verify('getSceneSessionByPersistentId', [1, true]).atLeast(1);
      mocker.ignoreMock(scbScenePanelViewModel, scbScenePanelViewModel.getSceneSessionByPersistentId);
    });

    /**
     * 用例描述: session异常退出时是否需要返回调用方
     * 预置条件: 根据当前session的caller为空
     * 测试场景: 判断是否需要返回调用方
     * 预期结果: 需要返回调用方
     */
    it('test_whenCallerContainerSessionIsNull_thenReturnTrue', Level.LEVEL0, () => {
      let mockFunc: Function =
        mocker.mockFunc(scbScenePanelViewModel, scbScenePanelViewModel.getSceneSessionByPersistentId);
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      when(mockFunc)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(sceneSession);

      let result: boolean = scbScenePanelViewModel.needStartCallerFromException(1);

      expect(result).assertTrue();
      mocker.verify('getSceneSessionByPersistentId', [1, true]).atLeast(1);
      mocker.ignoreMock(scbScenePanelViewModel, scbScenePanelViewModel.getSceneSessionByPersistentId);
    });

    /**
     * 用例描述: session异常退出时是否需要返回调用方
     * 预置条件: 根据当前session的caller不为空且caller与当前session在同一应用，caller在主分屏
     * 测试场景: 判断是否需要返回调用方
     * 预期结果: 无需返回调用方
     */
    it('test_whenCallerContainerSessionPrimarySessionMatches_thenReturnFalse', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      sceneSession.sceneInfo.callerPersistentId = 122;
      scbScenePanelViewModel.getContainerSessionList().push(new SCBSceneContainerSession(sceneSession, new SCBScreenProperty()));

      // 构造callerContainer中存在一个session且与session为同一应用
      let callerSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 122);
      let callerSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(callerSceneInfo), callerSceneInfo);
      let callerContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(callerSceneSession, new SCBScreenProperty());
      scbScenePanelViewModel.getContainerSessionList().push(callerContainerSession);

      let result: boolean = scbScenePanelViewModel.needStartCallerFromException(123);
      expect(result).assertFalse();

      mocker.ignoreMock(scbScenePanelViewModel, scbScenePanelViewModel.getSceneSessionByPersistentId);
      mocker.ignoreMock(scbScenePanelViewModel, scbScenePanelViewModel.getSceneContainerSessionWithPersistentId);
    });

    /**
     * 用例描述: session异常退出时是否需要返回调用方
     * 预置条件: 根据当前session的caller不为空且caller与当前session在同一应用,caller在副分屏
     * 测试场景: 判断是否需要返回调用方
     * 预期结果: 无需返回调用方
     */
    it('test_whenCallerContainerSessionSecondarySessionMatches_thenReturnFalse', Level.LEVEL0, () => {
      // 构造session caller为122
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      sceneSession.sceneInfo.callerPersistentId = 122;
      scbScenePanelViewModel.getContainerSessionList().push(new SCBSceneContainerSession(sceneSession, new SCBScreenProperty()));

      // 构造callerContainer中存在两个session，且secondarySession与session为同一应用
      let callerSceneInfo = new SCBSceneInfo('testCallerBundle', 'testCallerModule', 'testCallerAbility', 0, 122);
      let callerSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(callerSceneInfo), callerSceneInfo);
      let secondCallerSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriBundle', 'testPriBundle', 0, 124);
      let secondCallerSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(secondCallerSceneInfo), secondCallerSceneInfo);
      let callerContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(callerSceneSession, new SCBScreenProperty());
      callerContainerSession.secondarySession = secondCallerSceneSession;
      scbScenePanelViewModel.getContainerSessionList().push(callerContainerSession);

      let result: boolean = scbScenePanelViewModel.needStartCallerFromException(123);
      expect(result).assertFalse();

      mocker.ignoreMock(scbScenePanelViewModel, scbScenePanelViewModel.getSceneSessionByPersistentId);
      mocker.ignoreMock(scbScenePanelViewModel, scbScenePanelViewModel.getSceneContainerSessionWithPersistentId);
    });

    /**
     * 用例描述: session异常退出时是否需要返回调用方
     * 预置条件: 根据当前session的caller不为空且caller与当前session不在同一应用
     * 测试场景: 判断是否需要返回调用方
     * 预期结果: 需返回调用方
     */
    it('test_whenCallerContainerSessionNotMatch_whenReturnTrue', Level.LEVEL0, () => {
      let mockFunc: Function =
        mocker.mockFunc(scbScenePanelViewModel, scbScenePanelViewModel.getSceneSessionByPersistentId);
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      sceneSession.sceneInfo.callerPersistentId = 2;
      let mockFuncGetContainer: Function =
        mocker.mockFunc(scbScenePanelViewModel, scbScenePanelViewModel.getSceneContainerSessionWithPersistentId);

      // 构造caller且caller与当前session不属于同一应用
      let callerSceneInfo = new SCBSceneInfo('testCallerBundle', 'testCallerModule', 'testCallerAbility', 0, 2);
      let callerSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(callerSceneInfo), callerSceneInfo);
      let secondCallerSceneInfo = new SCBSceneInfo('testCallerBundle', 'testCallerModule', 'testCallerAbility', 0, 3);
      let secondCallerSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(secondCallerSceneInfo), secondCallerSceneInfo);
      let callerContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(callerSceneSession, new SCBScreenProperty());
      callerContainerSession.addSceneSession(secondCallerSceneSession);

      when(mockFuncGetContainer)(ArgumentMatchers.any).afterReturn(callerContainerSession);
      when(mockFunc)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(sceneSession);

      let result: boolean = scbScenePanelViewModel.needStartCallerFromException(1);
      expect(result).assertTrue();

      mocker.ignoreMock(scbScenePanelViewModel, scbScenePanelViewModel.getSceneSessionByPersistentId);
      mocker.ignoreMock(scbScenePanelViewModel, scbScenePanelViewModel.getSceneContainerSessionWithPersistentId);
    });
  });

  describe('SCBScenePanelViewModel_getSceneContainerSessionWithPersistentId_testSuite', () => {
    let scbScenePanelViewModel: SCBScenePanelViewModel;
    let mocker: MockKit;

    beforeAll(() => {
      scbScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
      mocker = new MockKit();
    });

    beforeEach(() => {
      let panelMgr = scbScenePanelViewModel.getPanelManager();
      panelMgr.getSceneContainerSessionList().clear();
      panelMgr.getFloatingSessionList().clear();
      panelMgr.getNotShowRecentList().clear();
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().clear();
    });

    /**
     * 用例描述: 根据session的persistentId查找所属containerSession
     * 预置条件: 所有containerSessionList均为空
     * 测试场景: 查找session的persistentId为-1所属的containerSession
     * 预期结果: 查找失败，返回null
     */
    it('test_whenNoSessionFoundShould_thenReturnNull', Level.LEVEL0, () => {
      let mockLogShowWarn: Function = mocker.mockFunc(mockLog, mockLog.showWarn);
      when(mockLogShowWarn)(ArgumentMatchers.any).afterReturnNothing();

      let result: SCBSceneContainerSession | null =
        scbScenePanelViewModel.getSceneContainerSessionWithPersistentId(-1);
      expect(result).assertNull();
    });

    /**
     * 用例描述: 根据session的persistentId查找所属containerSession
     * 预置条件: 在锁屏之下containerSessionList中存在id为123的container
     * 测试场景: 查找session的persistentId为123所属的containerSession
     * 预期结果: 查找成功
     */
    it('test_whenContainerSessionListIncludeSession_thenSuccess', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      scbScenePanelViewModel.getContainerSessionList().push(containerSession);

      let result: SCBSceneContainerSession | null =
        scbScenePanelViewModel.getSceneContainerSessionWithPersistentId(123);
      expect(result).assertEqual(containerSession);
    });

    /**
     * 用例描述: 根据session的persistentId查找所属containerSession
     * 预置条件: 在悬浮窗floatingSessionList中存在id为123的container
     * 测试场景: 查找session的persistentId为123所属的containerSession
     * 预期结果: 查找成功
     */
    it('test_whenFloatingSessionListIncludeSession_thenSuccess', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      scbScenePanelViewModel.getFloatingSessionList().push(containerSession);

      const result: SCBSceneContainerSession | null =
        scbScenePanelViewModel.getSceneContainerSessionWithPersistentId(123);
      expect(result).assertEqual(containerSession);
    });

    /**
     * 用例描述: 根据session的persistentId查找所属containerSession
     * 预置条件: 在多任务containerSessionListNotShowRecent中存在id为123的container
     * 测试场景: 查找session的persistentId为123所属的containerSession
     * 预期结果: 查找成功
     */
    it('test_whenContainerSessionListNotShowRecentIncludeSession_thenSuccess', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      scbScenePanelViewModel.getContainerSessionListNotShowRecent().push(containerSession);

      const result: SCBSceneContainerSession | null =
        scbScenePanelViewModel.getSceneContainerSessionWithPersistentId(123);
      expect(result).assertEqual(containerSession);
    });
  });

  describe('SCBScenePanelViewModel_getFloatSceneSessionByPersistentId_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel;
    let mocker: MockKit;
    let handler: ScenePanelStateCollectionHandler;

    beforeAll(() => {
      panelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
      panelViewModel.init(panelStateCollectionHandler, panelDataCollectionHandler);
      handler = ReflectionUtils.getProperty(panelViewModel, "stateCollectionHandler");
      mocker = new MockKit();
    });

    /**
     * 用例描述: 根据persistentId查找所属sceneSession
     * 预置条件: scenePanelState为RECENT，floatList中不存在目标session
     * 测试场景: 查找persistentId为123的floatSceneSession
     * 预期结果: 返回null
     */
    it('test_whenScenePanelStateIsNotRecent_thenReturnNull', Level.LEVEL0, () => {
      let mockGetFloatSessionWithPersistentIdWhenInRecent: Function =
        mocker.mockFunc(panelViewModel, panelViewModel.getFloatSessionWithPersistentIdWhenInRecent);
      let mockGetFloatSessionWithPersistentId: Function =
        mocker.mockFunc(panelViewModel, panelViewModel.getFloatSessionWithPersistentId);
      handler.updatePanelState(ScenePanelState.RECENT);
      when(mockGetFloatSessionWithPersistentIdWhenInRecent)(123).afterReturn(null);
      when(mockGetFloatSessionWithPersistentId)(123).afterReturn(null);

      let result: SCBSceneSession | null = panelViewModel.getFloatSceneSessionByPersistentId(123);

      expect(result).assertNull();
      mocker.ignoreMock(panelViewModel, panelViewModel.getFloatSessionWithPersistentIdWhenInRecent);
      mocker.ignoreMock(panelViewModel, panelViewModel.getFloatSessionWithPersistentId);
    });

    /**
     * 用例描述: 根据persistentId查找所属sceneSession
     * 预置条件: scenePanelState为RECENT，floatList中存在目标session
     * 测试场景: 查找persistentId为123的floatSceneSession
     * 预期结果: 返回id为123的session
     */
    it('test_whenScenePanelStateIsNotRecent_thenSuccess', Level.LEVEL0, () => {
      let mockGetFloatSessionWithPersistentIdWhenInRecent: Function =
        mocker.mockFunc(panelViewModel, panelViewModel.getFloatSessionWithPersistentIdWhenInRecent);
      let mockGetFloatSessionWithPersistentId: Function =
        mocker.mockFunc(panelViewModel, panelViewModel.getFloatSessionWithPersistentId);
      handler.updatePanelState(ScenePanelState.RECENT);
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      when(mockGetFloatSessionWithPersistentIdWhenInRecent)(123).afterReturn(null);
      when(mockGetFloatSessionWithPersistentId)(123).afterReturn(sceneSession);

      let result: SCBSceneSession | null = panelViewModel.getFloatSceneSessionByPersistentId(123);

      expect(result).assertEqual(sceneSession)
      mocker.ignoreMock(panelViewModel, panelViewModel.getFloatSessionWithPersistentIdWhenInRecent);
      mocker.ignoreMock(panelViewModel, panelViewModel.getFloatSessionWithPersistentId);
    });

    /**
     * 用例描述: 根据persistentId查找所属sceneSession
     * 预置条件: scenePanelState为RECENT，PadFloatingSessionList中存在目标session
     * 测试场景: 查找persistentId为123的floatSceneSession
     * 预期结果: 返回id为123的session
     */
    it('test_whenScenePanelStateIsNotRecent_thenSuccess', Level.LEVEL0, () => {
      let mockGetFloatSessionWithPersistentIdWhenInRecent: Function =
        mocker.mockFunc(panelViewModel, panelViewModel.getFloatSessionWithPersistentIdWhenInRecent);
      handler.updatePanelState(ScenePanelState.RECENT);
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      when(mockGetFloatSessionWithPersistentIdWhenInRecent)(123).afterReturn(containerSession);

      let result: SCBSceneSession | null = panelViewModel.getFloatSceneSessionByPersistentId(123);

      expect(result).assertEqual(sceneSession)
      mocker.ignoreMock(panelViewModel, panelViewModel.getFloatSessionWithPersistentIdWhenInRecent);
    });

    /**
     * 用例描述: 根据persistentId查找所属sceneSession
     * 预置条件: scenePanelState不等于RECENT，PadFloatingSessionList中存在目标session
     * 测试场景: 查找persistentId为123的floatSceneSession
     * 预期结果: 返回id为123的session
     */
    it('test_whenScenePanelStateIsNotRecent_thenSuccess', Level.LEVEL0, () => {
      let mockGetFloatSessionWithPersistentId: Function =
        mocker.mockFunc(panelViewModel, panelViewModel.getFloatSessionWithPersistentId);
      handler.updatePanelState(ScenePanelState.HOME);
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      when(mockGetFloatSessionWithPersistentId)(123).afterReturn(sceneSession);

      let result: SCBSceneSession | null = panelViewModel.getFloatSceneSessionByPersistentId(123);

      expect(result).assertEqual(sceneSession)
      mocker.ignoreMock(panelViewModel, panelViewModel.getFloatSessionWithPersistentIdWhenInRecent);
    });
  });

  describe('SCBScenePanelViewModel_getSpecialContainerSessionById_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel;
    let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let containerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    beforeAll(() => {
      panelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    });

    /**
     * 用例描述: 根据persistentId查找所属锁屏之上containerSession
     * 预置条件: 无
     * 测试场景: 查找persistentId为123的containerSession
     * 预期结果: success
     */
    it('test_whenSpecialContainerSessionListIncludeSession_thenSuccess', Level.LEVEL0, () => {
      panelViewModel.addSpecialContainerSession(containerSession);
      let ret: SCBSceneContainerSession | null =
        panelViewModel.getSpecialContainerSessionById(sceneSession.sceneInfo.persistentId);
      expect(ret).assertEqual(containerSession);
    });
  });

  describe('SCBScenePanelViewModel_addSpecialContainerSession_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel;
    let mocker: MockKit;

    beforeAll(() => {
      panelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
      mocker = new MockKit();
    });

    it('test_whenAddSpecialContainerSession_thenSuccess', Level.LEVEL0, () => {
      let mockOnAddSpecialContainerSession: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().onAddSpecialContainerSession);
      when(mockOnAddSpecialContainerSession)(ArgumentMatchers.any).afterReturnNothing();
      let addSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      addSessionList.add(containerSession);

      panelViewModel.addSpecialContainerSession(containerSession);

      mocker.verify("onAddSpecialContainerSession", [addSessionList]).once();
      mocker.ignoreMock(mockLog, mockLog.showInfo);
    });
  });

  describe('SCBScenePanelViewModel_getContainerSessionById_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel;

    beforeAll(() => {
      panelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    });

    it('test_whenContainerSessionListIsEmpty_thenReturnNull', Level.LEVEL0, () => {
      let panelMgr = panelViewModel.getPanelManager();
      panelMgr.getSceneContainerSessionList().clear();
      panelMgr.getFloatingSessionList().clear();
      panelMgr.getNotShowRecentList().clear();
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().clear();

      let result = panelViewModel.getContainerSessionById(-1);

      expect(result).assertNull();
    });
  });

  describe('SCBScenePanelViewModel_getSessionFromFloatingScene_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel;
    let mocker: MockKit;

    beforeAll(() => {
      panelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
      mocker = new MockKit();
    });

    beforeEach(() => {
      let panelMgr = panelViewModel.getPanelManager();
      panelMgr.getFloatingSessionList().clear();
    });

    /**
     * 用例描述: 根据persistentId查找所属锁屏之上containerSession
     * 预置条件: 无
     * 测试场景: 查找persistentId为123的containerSession
     * 预期结果: success
     */
    it('test_whenFloatingSessionListIncludeSession_thenSuccess', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      panelViewModel.getFloatingSessionList().push(containerSession);

      let result = panelViewModel.getSessionFromFloatingScene(123);

      expect(result).assertEqual(containerSession);
    });

    it('test_whenFloatingSessionListNotIncludeSession_thenReturnNull', Level.LEVEL0, () => {
      let result = panelViewModel.getSessionFromFloatingScene(123);

      expect(result).assertNull();
    });
  });

  describe('SCBScenePanelViewModel_isReachMaxSessionNum_testSuite', () => {
    const BundleName = 'testPriBundle';
    let panelViewModel: SCBScenePanelViewModel;
    let sceneInfo = new SCBSceneInfo(BundleName, BundleName, 'testPriAbility', 0, 123);
    sceneInfo.appInstanceKey = BundleName;
    sceneInfo.updateWindowModeAndSync(SCBSceneMode.PRIMARY);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    beforeAll(() => {
      panelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    })
    afterAll(() => {
      panelViewModel.getContainerSessionList().clear();
    });

    /**
     * 用例描述: 达到系统设置限制数量，需先销毁最老应用
     * 预置条件: 当系统设置了max_session_limit_one_ability
     * 测试场景: 连续打开多个应用
     * 预期结果: 最老应用被销毁
     */
    it('test_shouldCloseOldestSceneSessionWhenReachMaxSessionNum_success', Level.LEVEL0, () => {
      let containerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      if (containerSession.primarySession?.sceneInfo) {
        containerSession.primarySession.sceneInfo.appInstanceKey = BundleName;
      }
      // sessionList添加mockGetSysSessionLimit个session
      for (let i = 0; i < 10; i++) {
        panelViewModel.getContainerSessionList().push(containerSession);
      }

      panelViewModel.isReachMaxSessionNum(sceneInfo);

      // 分屏场景，销毁session，needDestructedInSplit需要置为true
      let res = panelViewModel.getContainerSessionList()[0]?.primarySession?.needDestructedInSplit ?? '';
      expect(res).assertTrue();
    });

    /**
     * 用例描述: 达到应用限制数量，需先销毁最老应用
     * 预置条件: 打开超过MAX_SESSION_LIMIT_ALL_APP个应用
     * 测试场景: 连续打开多个应用
     * 预期结果: 最老应用被销毁
     */
    it('test_shouldCloseOldestContainerSessionWhenReachMaxSessionNum_success', Level.LEVEL0, () => {
      // sessionList添加MAX_SESSION_LIMIT_ALL_APP个session
      for (let i = 0; i < MAX_SESSION_LIMIT_ALL_APP; i++) {
        panelViewModel.getContainerSessionList().push(new SCBSceneContainerSession(sceneSession, new SCBScreenProperty()));
      }
      panelViewModel.isReachMaxSessionNum(sceneInfo);

      // 分屏场景，销毁session，needDestructedInSplit需要置为true
      let res = panelViewModel.getContainerSessionList()[MAX_SESSION_LIMIT_ALL_APP - 1]?.primarySession?.needDestructedInSplit ?? '';
      expect(res).assertTrue();
    });
  });

  describe('SCBScenePanelViewModel_getContainerSessionByPersistentIdOrContainerId_testSuite', () => {

    let scbScenePanelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());;
    let mocker: MockKit = new MockKit();;
    let panelMgr: SCBScenePanelManager = scbScenePanelViewModel.getPanelManager();

    beforeAll(() => {
      panelMgr.getSceneContainerSessionList().clear();
      panelMgr.getFloatingSessionList().clear();
      panelMgr.getNotShowRecentList().clear();
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().clear();
    });

    afterEach(() => {
      panelMgr.getSceneContainerSessionList().clear();
      panelMgr.getFloatingSessionList().clear();
      panelMgr.getNotShowRecentList().clear();
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().clear();
    });

    /**
     * 用例描述: 根据persistentID查找containerSession
     * 预置条件: 创建containerSession，放入containerSessionList中
     * 测试场景: 根据传入的persistentId 查找对应的containerSession
     * 预期结果: 查找成功
     */
    it('test_should_return_session_when_persistentId_is_provided', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 889);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      scbScenePanelViewModel.getContainerSessionList().push(containerSession);

      let result: SCBSceneContainerSession | null =
        scbScenePanelViewModel.getContainerSessionByPersistentIdOrContainerId(sceneSession.sceneInfo.persistentId);

      expect(result).assertEqual(containerSession);
    });

    /**
     * 用例描述: 根据containerId查找containerSession
     * 预置条件: 创建containerSession，放入containerSessionList中
     * 测试场景: 根据传入的containerId 查找对应的containerSession
     * 预期结果: 查找成功
     */
    it('test_should_return_session_when_containerId_is_provided', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      scbScenePanelViewModel.getContainerSessionList().push(containerSession);

      let result: SCBSceneContainerSession | null =
        scbScenePanelViewModel.getContainerSessionByPersistentIdOrContainerId(undefined, containerSession.containerId);

      expect(result).assertEqual(containerSession);
    });

    /**
     * 用例描述: 无persistentID和containerId的情况下查找containerSession
     * 预置条件: 无
     * 测试场景: 不传入参数，直接调用getContainerSessionByPersistentIdOrContainerId
     * 预期结果: 查找为空
     */
    it('test_should_return_null_when_no_parameters_are_provided', Level.LEVEL0, () => {
      let viewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
      let result: SCBSceneContainerSession | null = viewModel.getContainerSessionByPersistentIdOrContainerId();
      expect(result).assertNull();
    });
  });

  describe('SCBScenePanelViewModel_getSceneContainerSessionWithContainerId_testSuite', () => {

    let scbScenePanelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    let mocker: MockKit = new MockKit();;
    let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let containerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
    let panelMgr: SCBScenePanelManager = scbScenePanelViewModel.getPanelManager();

    beforeAll(() => {
      panelMgr.getSceneContainerSessionList().clear();
      panelMgr.getFloatingSessionList().clear();
      panelMgr.getNotShowRecentList().clear();
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().clear();
    });

    afterEach(() => {
      panelMgr.getSceneContainerSessionList().clear();
      panelMgr.getFloatingSessionList().clear();
      panelMgr.getNotShowRecentList().clear();
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().clear();
    });


    /**
     * 用例描述: 根据containerId查找containerSession
     * 预置条件: 创建containerSession，放入containerSessionList中
     * 测试场景: 根据传入的containerId 查找对应的containerSession
     * 预期结果: 查找成功
     */
    it('test_should_return_session_from_containerSessionList_when_found', Level.LEVEL0, () => {
      scbScenePanelViewModel.getContainerSessionList().push(containerSession);

      let result: SCBSceneContainerSession | null =
        scbScenePanelViewModel.getSceneContainerSessionWithContainerId(containerSession.containerId);

      expect(result).assertEqual(containerSession);
    });

    /**
     * 用例描述: 根据containerId查找containerSession
     * 预置条件: 创建containerSession，放入floatingSessionList中
     * 测试场景: 根据传入的containerId 查找对应的containerSession
     * 预期结果: 查找成功
     */
    it('test_should_return_session_from_floatingSessionList_when_found', Level.LEVEL0, () => {
      scbScenePanelViewModel.getFloatingSessionList().push(containerSession);

      let result: SCBSceneContainerSession | null =
        scbScenePanelViewModel.getSceneContainerSessionWithContainerId(containerSession.containerId);

      expect(result).assertEqual(containerSession);
    });

    /**
     * 用例描述: 根据containerId查找containerSession
     * 预置条件: 创建containerSession，放入containerSessionListNotShowRecent中
     * 测试场景: 根据传入的containerId 查找对应的containerSession
     * 预期结果: 查找成功
     */
    it('test_should_return_session_from_containerSessionListNotShowRecent_when_found', Level.LEVEL0, () => {
      scbScenePanelViewModel.getContainerSessionListNotShowRecent().push(containerSession);

      let result: SCBSceneContainerSession | null =
        scbScenePanelViewModel.getSceneContainerSessionWithContainerId(containerSession.containerId);

      expect(result).assertEqual(containerSession);
    });

    /**
     * 用例描述: 根据containerId查找containerSession
     * 预置条件: 无
     * 测试场景: 根据传入的containerId 查找对应的containerSession
     * 预期结果: 查找结果为空
     */
    it('test_should_return_null_when_no_session_found', Level.LEVEL0, () => {
      let result: SCBSceneContainerSession | null =
        scbScenePanelViewModel.getSceneContainerSessionWithContainerId(containerSession.containerId);

      expect(result).assertNull();
    });
  });

  describe('SCBScenePanelViewModel_requestNewSceneSession_testSuite', () => {

    let scbScenePanelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    let mocker: MockKit = new MockKit();;
    let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 9527);
    let sdkSceneSession = sceneSessionManager.requestSceneSession(sceneInfo)
    let sceneSession: SCBSceneSession = new SCBSceneSession(sdkSceneSession, sceneInfo);
    let containerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
    let panelMgr: SCBScenePanelManager = scbScenePanelViewModel.getPanelManager();

    beforeAll(() => {
      panelMgr.getSceneContainerSessionList().clear();
      panelMgr.getFloatingSessionList().clear();
      panelMgr.getNotShowRecentList().clear();
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().clear();
    });

    afterEach(() => {
      panelMgr.getSceneContainerSessionList().clear();
      panelMgr.getFloatingSessionList().clear();
      panelMgr.getNotShowRecentList().clear();
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().clear();
    });

    /**
     * 用例描述: 测试requestNewSceneSession方法
     * 预置条件: mock SCBSceneSessionManager的requestSceneSession方法，无论参数是什么都返回null
     * 测试场景: 当SCBSceneSessionManager的requestSceneSession方法返回结果为null时，直接返回null
     * 预期结果: 返回结果为null
     */
    it('test_should_return_null_when_requestSceneSession_returns_null', Level.LEVEL0, () => {
      let mockRequestSceneSession: Function =
        mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().requestSceneSession);
      when(mockRequestSceneSession)(ArgumentMatchers.any).afterReturn(null);

      let result: SCBSceneSession | null = scbScenePanelViewModel.requestNewSceneSession(sceneInfo);

      expect(result).assertNull();
      mocker.verify('requestSceneSession', [sceneInfo]).atLeast(1);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().requestSceneSession);
    });

    /**
     * 用例描述: 测试requestNewSceneSession方法
     * 预置条件: mock requestSceneSession方法和isDeliverApplication方法
     * 测试场景: 当requestSceneSession方法正常返回sceneSession，且是deliverApp并且在containerSessionList中
     * 预期结果: 从containerSessionList中获取对应的sceneSession
     */
    it('test_should_return_SCBSceneSession_when_requestSceneSession_returns_valid_session', Level.LEVEL0, () => {
      let mockRequestSceneSession: Function =
        mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().requestSceneSession);
      let mockIsDeliverApplication: Function =
        mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isDeliverApplication);
      when(mockRequestSceneSession)(ArgumentMatchers.any).afterReturn(sdkSceneSession);
      when(mockIsDeliverApplication)(ArgumentMatchers.any).afterReturn(true);
      scbScenePanelViewModel.getContainerSessionList().push(containerSession);

      let result: SCBSceneSession | null = scbScenePanelViewModel.requestNewSceneSession(sceneInfo);

      expect(result).assertEqual(sceneSession);
      mocker.verify('isDeliverApplication', [sceneInfo.bundleName]).atLeast(1);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().requestSceneSession);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isDeliverApplication);
    });

    /**
     * 用例描述: 测试requestNewSceneSession方法
     * 预置条件: mock requestSceneSession方法
     * 测试场景: 当requestSceneSession方法抛异常
     * 预期结果: 返回结果为null
     */
    it('test_should_handle_exception_when_requestSceneSession_throws_error', Level.LEVEL0, () => {
      let mockRequestSceneSession: Function =
        mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().requestSceneSession);
      when(mockRequestSceneSession)(ArgumentMatchers.any).afterThrow('Error');

      let result: SCBSceneSession | null = scbScenePanelViewModel.requestNewSceneSession(sceneInfo);

      expect(result).assertNull();
      mocker.verify('requestSceneSession', [sceneInfo]).atLeast(1);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().requestSceneSession);
    });
  });

  describe('SCBScenePanelViewModel_getSceneSessionFromOtherScreen_testSuite', () => {
    let scbScenePanelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    let mocker: MockKit = new MockKit();;
    let sceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9527);

    /**
     * 用例描述: 测试getSceneSessionFromOtherScreen方法
     * 预置条件: mock popSceneFromOtherScreen方法，无论参数是什么都返回undefined
     * 测试场景: 当没找到sceneSession时，直接返回undefined
     * 预期结果: 返回结果为undefined
     */
    it('test_should_return_undefined_when_sceneSession_is_undefined', Level.LEVEL0, () => {
      let mockFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().popSceneFromOtherScreen);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);

      let result: SCBSceneSession | undefined = scbScenePanelViewModel.getSceneSessionFromOtherScreen(sceneInfo);

      expect(result).assertUndefined();
      mocker.verify('popSceneFromOtherScreen', [sceneInfo]).atLeast(1);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().popSceneFromOtherScreen);
    });

    /**
     * 用例描述: 测试getSceneSessionFromOtherScreen方法
     * 预置条件: mock popSceneFromOtherScreen方法,返回预期的sceneSession，但isAvailable是false
     * 测试场景: 当sceneSession的isAvailable是false时，直接返回undefined
     * 预期结果: 返回结果为undefined
     */
    it('test_should_return_undefined_when_sceneSession_is_unavailable', Level.LEVEL0, () => {
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      ReflectionUtils.getProperty(sceneSession, 'sessionDataInner').nativeCacheRefAvailable = false;
      let mockFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().popSceneFromOtherScreen);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(sceneSession);

      let result: SCBSceneSession | undefined = scbScenePanelViewModel.getSceneSessionFromOtherScreen(sceneInfo);

      expect(result).assertUndefined();
      mocker.verify('popSceneFromOtherScreen', [sceneInfo]).atLeast(1);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().popSceneFromOtherScreen);
    });

    /**
     * 用例描述: 测试getSceneSessionFromOtherScreen方法
     * 预置条件: mock popSceneFromOtherScreen方法,返回预期的sceneSession，isAvailable为true
     * 测试场景: 找到sceneSession
     * 预期结果: 返回预期的sceneSession
     */
    it('test_should_return_SCBSceneSession_when_sceneSession_is_available', Level.LEVEL0, () => {
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      ReflectionUtils.getProperty(sceneSession, 'sessionDataInner').nativeCacheRefAvailable = true;
      let mockFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().popSceneFromOtherScreen);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(sceneSession);

      let result: SCBSceneSession | undefined = scbScenePanelViewModel.getSceneSessionFromOtherScreen(sceneInfo);

      expect(result).not().assertUndefined();
      mocker.verify('popSceneFromOtherScreen', [sceneInfo]).atLeast(1);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().popSceneFromOtherScreen);
    });
  });

  describe('SCBScenePanelViewModel_checkIsInContainerSessionList_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel;

    beforeAll(() => {
      panelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    });

    beforeEach(() => {
      panelViewModel.getContainerSessionList().clear();
    });

    /**
     * 用例描述: 根据sceneInfo查找锁屏之下containerSession
     * 预置条件: 锁屏之下containerSessionList为空
     * 测试场景: 查找sceneInfo.persistentId为123的containerSession
     * 预期结果: 返回空
     */
    it('test_whenSceneIsNotInContainerSessionList_thenReturnNull', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);

      let result: SCBSceneContainerSession | null = panelViewModel.checkIsInContainerSessionList(sceneInfo);

      expect(result).assertNull();
    });

    /**
     * 用例描述: 根据sceneInfo查找锁屏之下containerSession
     * 预置条件: 锁屏之下containerSessionList存在为分屏状态的containerSession
     * 测试场景: 查找sceneInfo.persistentId为123的containerSession
     * 预期结果: 返回空
     */
    it('test_whenSceneIsInContainerSessionListWhenSessionIsSplit_thenReturnNull', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      containerSession.isSplit = true;
      panelViewModel.getContainerSessionList().push(containerSession);

      let result: SCBSceneContainerSession | null = panelViewModel.checkIsInContainerSessionList(sceneInfo);

      expect(result).assertNull();
    });

    /**
     * 用例描述: 根据sceneInfo查找锁屏之下containerSession
     * 预置条件: 锁屏之下containerSessionList存在id为123的containerSession,且不处于分屏
     * 测试场景: 查找sceneInfo.persistentId为123的containerSession
     * 预期结果: 返回id为123的containerSession
     */
    it('test_whenSceneIsInContainerSessionListWhenSessionIsNotSplit_thenSuccess', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      containerSession.isSplit = false;
      panelViewModel.getContainerSessionList().push(containerSession);

      let result: SCBSceneContainerSession | null = panelViewModel.checkIsInContainerSessionList(sceneInfo);

      expect(result).assertEqual(containerSession);
    });
  });

  describe('SCBScenePanelViewModel_getCallerContainerSession_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel;
    let mocker: MockKit;

    beforeAll(() => {
      panelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
      mocker = new MockKit();
    });

    beforeEach(() => {
      panelViewModel.getContainerSessionListNotShowRecent().clear();
    });

    /**
     * 用例描述: 根据sceneInfo查找callerContainerSession
     * 预置条件: 入参sceneInfo不存在caller
     * 测试场景: 查找sceneInfo.persistentId为123的callerSession
     * 预期结果: 返回Null
     */
    it('test_whenSceneIsNotExistCaller_thenReturnNull', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      sceneInfo.callerPersistentId = 0;

      let result: SCBSceneContainerSession | null = panelViewModel.getCallerContainerSession(sceneInfo);

      expect(result).assertNull();
    });

    /**
     * 用例描述: 根据sceneInfo查找callerContainerSession
     * 预置条件: panelViewModel中不存在任何containerSession
     * 测试场景: 查找sceneInfo.persistentId为123的callerSession
     * 预期结果: 返回Null
     */
    it('test_whenContainerSessionListInPanelViewModelIsEmpty_thenReturnNull', Level.LEVEL0, () => {
      let mockGetSession: Function =
        mocker.mockFunc(panelViewModel, panelViewModel.getSceneContainerSessionWithPersistentId);
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      sceneInfo.callerPersistentId = 122;
      when(mockGetSession)(ArgumentMatchers.any).afterReturn(null);

      let result: SCBSceneContainerSession | null = panelViewModel.getCallerContainerSession(sceneInfo);

      mocker.verify("getSceneContainerSessionWithPersistentId", [122]).atLeast(1);
      expect(result).assertNull();
      mocker.ignoreMock(panelViewModel, panelViewModel.getSceneContainerSessionWithPersistentId);
    });

    /**
     * 用例描述: 根据sceneInfo查找callerContainerSession
     * 预置条件: containerSessionListNotShowRecent中存在入参sceneInfo的callerSession
     * 测试场景: 查找sceneInfo.persistentId为123的callerSession
     * 预期结果: 返回callerSession
     */
    it('test_whenContainerSessionListNotShowRecentInclude_thenSuccess', Level.LEVEL0, () => {
      let mockGetSession: Function =
        mocker.mockFunc(panelViewModel, panelViewModel.getSceneContainerSessionWithPersistentId);
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      sceneInfo.callerPersistentId = 122;
      // 构造callerContainerSession
      let callerSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 122);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(callerSceneInfo), callerSceneInfo);
      let containerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      panelViewModel.getContainerSessionListNotShowRecent().push(containerSession);
      when(mockGetSession)(ArgumentMatchers.any).afterReturn(null);

      let result: SCBSceneContainerSession | null = panelViewModel.getCallerContainerSession(sceneInfo);

      mocker.verify("getSceneContainerSessionWithPersistentId", [122]).atLeast(1);
      expect(result).assertEqual(containerSession);
      mocker.ignoreMock(panelViewModel, panelViewModel.getSceneContainerSessionWithPersistentId);
    });

    /**
     * 用例描述: 根据sceneInfo查找callerContainerSession
     * 预置条件: containerSessionListNotShowRecent中不存在入参sceneInfo的callerSession,containerSessionList中存在
     * 测试场景: 查找sceneInfo.persistentId为123的callerSession
     * 预期结果: 返回callerSession
     */
    it('test_whenContainerSessionListNotShowRecentIsNullAndContainerSessionListInclude_thenSuccess', Level.LEVEL0, () => {
      let mockGetSession: Function =
        mocker.mockFunc(panelViewModel, panelViewModel.getSceneContainerSessionWithPersistentId);
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      sceneInfo.callerPersistentId = 122;
      // 构造callerContainerSession
      let callerSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 122);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(callerSceneInfo), callerSceneInfo);
      let containerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      when(mockGetSession)(ArgumentMatchers.any).afterReturn(containerSession);

      let result: SCBSceneContainerSession | null = panelViewModel.getCallerContainerSession(sceneInfo);

      mocker.verify("getSceneContainerSessionWithPersistentId", [122]).atLeast(1);
      expect(result).assertEqual(containerSession);
      mocker.ignoreMock(panelViewModel, panelViewModel.getSceneContainerSessionWithPersistentId);
    });
  });

  describe('SCBScenePanelViewModel_needMinimizeActiveContainer_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel;
    let mocker: MockKit;

    beforeAll(() => {
      panelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
      mocker = new MockKit();
    });

    /**
     * 用例描述: 判断是否需要最小化当前处于active的containerSession
     * 预置条件: 无
     * 测试场景: 传入相同的currentContainer和activeContainer
     * 预期结果: 返回false
     */
    it('test_whenCurrentContainerIsSameActiveContainer_thenReturnFalse', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

      let result: boolean = panelViewModel.needMinimizeActiveContainer(containerSession, containerSession);

      expect(result).assertFalse();
    });

    /**
     * 用例描述: 判断是否需要最小化当前处于active的containerSession
     * 预置条件: currentContainer和activeContainer均处于全屏模式
     * 测试场景: 传入currentContainer和activeContainer判断会否需要最小化activeContainer
     * 预期结果: 返回True
     */
    it('test_whenCurrentContainerAndActiveContainerAreInFullScreenMode_thenReturnTrue', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let currContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let curMockFunction = mocker.mockFunc(currContainerSession, currContainerSession.getContainerWindowMode);

      let activeSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let activeSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(activeSceneInfo), activeSceneInfo);
      let activeContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(activeSceneSession, new SCBScreenProperty());
      let activeMockFunction = mocker.mockFunc(activeContainerSession, activeContainerSession.getContainerWindowMode)

      when(curMockFunction)(ArgumentMatchers.any).afterReturn(SCBSceneMode.FULLSCREEN);
      when(activeMockFunction)(ArgumentMatchers.any).afterReturn(SCBSceneMode.FULLSCREEN);

      let result: boolean = panelViewModel.needMinimizeActiveContainer(currContainerSession, activeContainerSession);

      expect(result).assertTrue();
      mocker.ignoreMock(currContainerSession, currContainerSession.getContainerWindowMode);
      mocker.ignoreMock(activeContainerSession, activeContainerSession.getContainerWindowMode);
    });

    /**
     * 用例描述: 判断是否需要最小化当前处于active的containerSession
     * 预置条件: 仅activeContainer均处于全屏模式
     * 测试场景: 传入currentContainer和activeContainer判断会否需要最小化activeContainer
     * 预期结果: 返回True
     */
    it('test_whenOnlyActiveContainerInFullScreenMode_thenReturnFalse', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let currContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let curMockFunction = mocker.mockFunc(currContainerSession, currContainerSession.getContainerWindowMode);

      let activeSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let activeSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(activeSceneInfo), activeSceneInfo);
      let activeContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(activeSceneSession, new SCBScreenProperty());
      let activeMockFunction = mocker.mockFunc(activeContainerSession, activeContainerSession.getContainerWindowMode)

      when(curMockFunction)(ArgumentMatchers.any).afterReturn(SCBSceneMode.PRIMARY);
      when(activeMockFunction)(ArgumentMatchers.any).afterReturn(SCBSceneMode.FULLSCREEN);

      let result: boolean = panelViewModel.needMinimizeActiveContainer(currContainerSession, activeContainerSession);

      expect(result).assertFalse();
      mocker.ignoreMock(currContainerSession, currContainerSession.getContainerWindowMode);
      mocker.ignoreMock(activeContainerSession, activeContainerSession.getContainerWindowMode);
    });

    /**
     * 用例描述: 判断是否需要最小化当前处于active的containerSession
     * 预置条件: 仅currentContainer均处于全屏模式
     * 测试场景: 传入currentContainer和activeContainer判断会否需要最小化activeContainer
     * 预期结果: 返回True
     */
    it('test_whenOnlyCurrentContainerInFullScreenMode_thenReturnFalse', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let currContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let curMockFunction = mocker.mockFunc(currContainerSession, currContainerSession.getContainerWindowMode);

      let activeSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let activeSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(activeSceneInfo), activeSceneInfo);
      let activeContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(activeSceneSession, new SCBScreenProperty());
      let activeMockFunction = mocker.mockFunc(activeContainerSession, activeContainerSession.getContainerWindowMode)

      when(curMockFunction)(ArgumentMatchers.any).afterReturn(SCBSceneMode.FULLSCREEN);
      when(activeMockFunction)(ArgumentMatchers.any).afterReturn(SCBSceneMode.PRIMARY);

      let result: boolean = panelViewModel.needMinimizeActiveContainer(currContainerSession, activeContainerSession);

      expect(result).assertFalse();
      mocker.ignoreMock(currContainerSession, currContainerSession.getContainerWindowMode);
      mocker.ignoreMock(activeContainerSession, activeContainerSession.getContainerWindowMode);
    });
  });

  describe('SCBScenePanelViewModel_removeNotShowContainerSession_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel;
    let mocker: MockKit;
    beforeAll(() => {
      panelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
      mocker = new MockKit();
    });

    beforeEach(() => {
      panelViewModel.getContainerSessionListNotShowRecent().clear();
    });

    /**
     * 用例描述: 删除notShowContainerSession
     * 预置条件: notShowList中存在containerSession
     * 测试场景: 入参needRemoveSession为false
     * 预期结果: 不删除containerSession
     */
    it('test_whenNotShowListNotIncludeSession_thenSuccess', Level.LEVEL0, () => {
      let mockLogFunc = mocker.mockFunc(mockLog, mockLog.showInfo);
      when(mockLogFunc)(ArgumentMatchers.any).afterReturnNothing();
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      panelViewModel.getContainerSessionListNotShowRecent().push(containerSession);

      // 从notShowList中删除containerSession
      panelViewModel.removeNotShowContainerSession(containerSession, false);

      expect(panelViewModel.getContainerSessionListNotShowRecent().length).assertEqual(1);
      mocker.ignoreMock(mockLog, mockLog.showInfo);
    });

    /**
     * 用例描述: 删除notShowContainerSession
     * 预置条件: notShowList中存在containerSession
     * 测试场景: 入参needRemoveSession为false
     * 预期结果: 删除containerSession
     */
    it('test_whenNotShowListIncludeSession_thenSuccess', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      panelViewModel.getContainerSessionListNotShowRecent().push(containerSession);

      // 从notShowList中删除containerSession
      panelViewModel.removeNotShowContainerSession(containerSession, true);

      expect(panelViewModel.getContainerSessionListNotShowRecent().isEmpty()).assertTrue();
    });
  });

  describe('SCBScenePanelViewModel_requestSceneSession_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    let mocker: MockKit = new MockKit();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9527);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    beforeAll(() => {
      panelViewModel.getContainerSessionList().clear();
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().clear();
    })
    afterEach(() => {
      panelViewModel.getContainerSessionList().clear();
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().clear();
    });

    it('test_getSceneSessionFromOtherScreen_success_when_sceneSession_is_not_undefined', Level.LEVEL0, () => {
      let mockFunc: Function = mocker.mockFunc(panelViewModel, panelViewModel.getSceneSessionFromOtherScreen);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(sceneSession);

      let result: SCBSceneSession | null = panelViewModel.requestSceneSession(sceneInfo);

      expect(result).assertEqual(sceneSession);
      mocker.verify('getSceneSessionFromOtherScreen', [sceneInfo]).atLeast(1);
      mocker.ignoreMock(panelViewModel, panelViewModel.getSceneSessionFromOtherScreen);
    });

    it('test_persistentIdNotEqualZero_getSceneSessionByPersistentId_and_requestSceneSession_return_null',
      Level.LEVEL0, () => {
        let mockGetSceneSessionFromOtherScreen: Function =
          mocker.mockFunc(panelViewModel, panelViewModel.getSceneSessionFromOtherScreen);
        let mockGetSceneSessionByPersistentId: Function =
          mocker.mockFunc(panelViewModel, panelViewModel.getSceneSessionByPersistentId);
        let mockRequestNewSceneSession: Function = mocker.mockFunc(panelViewModel, panelViewModel.requestNewSceneSession);
        when(mockGetSceneSessionFromOtherScreen)(ArgumentMatchers.any).afterReturn(undefined);
        when(mockGetSceneSessionByPersistentId)(ArgumentMatchers.any).afterReturn(null);
        when(mockRequestNewSceneSession)(ArgumentMatchers.any).afterReturn(null);

        let result: SCBSceneSession | null = panelViewModel.requestSceneSession(sceneInfo);

        expect(result).assertEqual(null);
        mocker.verify('requestNewSceneSession', [sceneInfo]).atLeast(1);
        mocker.ignoreMock(panelViewModel, panelViewModel.getSceneSessionFromOtherScreen);
        mocker.ignoreMock(panelViewModel, panelViewModel.getSceneSessionByPersistentId);
        mocker.ignoreMock(panelViewModel, panelViewModel.requestNewSceneSession);
    });

    it('test_when_persistentIdNotEqualZero_updateCallerSessionIdAndToSessionId_success', Level.LEVEL0, () => {
      let sceneInfo01: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9528);
      sceneInfo01.callerPersistentId = 9527;
      let sceneSession01: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo01), sceneInfo01);
      let mockGetSceneSessionFromOtherScreen: Function =
        mocker.mockFunc(panelViewModel, panelViewModel.getSceneSessionFromOtherScreen);
      let mockGetSceneSessionByPersistentId: Function =
        mocker.mockFunc(panelViewModel, panelViewModel.getSceneSessionByPersistentId);
      when(mockGetSceneSessionFromOtherScreen)(ArgumentMatchers.any).afterReturn(undefined);
      when(mockGetSceneSessionByPersistentId)(9528).afterReturn(sceneSession01);
      when(mockGetSceneSessionByPersistentId)(9527).afterReturn(sceneSession);
      panelViewModel.getContainerSessionList().push(containerSession);

      let result: SCBSceneSession | null = panelViewModel.requestSceneSession(sceneInfo01, true);

      expect(result).assertEqual(sceneSession01);
      if(result != null && result.sceneInfo != null){
        mockLog.showInfo('result persistentID ' + result.sceneInfo.persistentId);
        mockLog.showInfo('result callerPersistentId ' + result.sceneInfo.callerPersistentId);
        expect(result.sceneInfo.callerPersistentId).assertEqual(9527);
      }
      expect(containerSession.primarySession).not().assertNull();
      if(containerSession.primarySession){
        expect(containerSession.primarySession.sceneInfo).not().assertNull();
      }
      if(containerSession && containerSession.primarySession && containerSession.primarySession.sceneInfo){
        expect(containerSession.primarySession.sceneInfo.toPersistentId).assertEqual(9528);
        containerSession.primarySession.sceneInfo.toPersistentId = 0;
      }
      mocker.verify('requestNewSceneSession', [sceneInfo01]).atLeast(1);
      mocker.ignoreMock(panelViewModel, panelViewModel.getSceneSessionFromOtherScreen);
      mocker.ignoreMock(panelViewModel, panelViewModel.getSceneSessionByPersistentId);
    });

    it('test_when_persistentId==0_callerPersistentId!=0', Level.LEVEL0, () => {
      let sceneInfo01: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 0);
      sceneInfo01.callerPersistentId = 9527;
      let sceneSession01: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo01), sceneInfo01);
      let mockGetSceneSessionFromOtherScreen: Function =
        mocker.mockFunc(panelViewModel, panelViewModel.getSceneSessionFromOtherScreen);
      let mockRequestNewSceneSession: Function = mocker.mockFunc(panelViewModel, panelViewModel.requestNewSceneSession);
      let mockGetSceneSessionByPersistentId: Function =
        mocker.mockFunc(panelViewModel, panelViewModel.getSceneSessionByPersistentId);
      when(mockGetSceneSessionFromOtherScreen)(ArgumentMatchers.any).afterReturn(undefined);
      when(mockRequestNewSceneSession)(ArgumentMatchers.any).afterReturn(sceneSession01);
      when(mockGetSceneSessionByPersistentId)(9527).afterReturn(sceneSession);
      panelViewModel.getContainerSessionList().push(containerSession);

      let result: SCBSceneSession | null = panelViewModel.requestSceneSession(sceneInfo01);

      expect(result).assertEqual(sceneSession01);
      if(result != null && result.sceneInfo != null){
        mockLog.showInfo('result persistentID ' + result.sceneInfo.persistentId);
        mockLog.showInfo('result callerPersistentId ' + result.sceneInfo.callerPersistentId);
        expect(result.sceneInfo.callerPersistentId).assertEqual(9527);
      }
      expect(containerSession.primarySession).not().assertNull();
      if(containerSession.primarySession){
        expect(containerSession.primarySession.sceneInfo).not().assertNull();
      }
      if(containerSession && containerSession.primarySession && containerSession.primarySession.sceneInfo){
        expect(containerSession.primarySession.sceneInfo.toPersistentId).assertEqual(0);
        containerSession.primarySession.sceneInfo.toPersistentId = 0;
      }
      mocker.verify('requestNewSceneSession', [sceneInfo01]).atLeast(1);
      mocker.ignoreMock(panelViewModel, panelViewModel.getSceneSessionFromOtherScreen);
      mocker.ignoreMock(panelViewModel, panelViewModel.requestNewSceneSession);
      mocker.ignoreMock(panelViewModel, panelViewModel.getSceneSessionByPersistentId);
    });

    it('test_when_persistentId_and_callerPersistentId_are_zero_NewInstance_is_true', Level.LEVEL0, () => {
      let sceneInfo01: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 0);
      sceneInfo01.callerPersistentId = 0;
      sceneInfo01.isNewInstance = true;
      let sceneSession01: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo01), sceneInfo01);
      let mockGetSceneSessionFromOtherScreen: Function =
        mocker.mockFunc(panelViewModel, panelViewModel.getSceneSessionFromOtherScreen);
      let mockGetSceneSession: Function = mocker.mockFunc(panelViewModel, panelViewModel.getSceneSession);
      let mockRequestNewSceneSession: Function = mocker.mockFunc(panelViewModel, panelViewModel.requestNewSceneSession);
      let mockIsDeliverApplication: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().isDeliverApplication);
      when(mockGetSceneSessionFromOtherScreen)(ArgumentMatchers.any).afterReturn(undefined);
      when(mockGetSceneSession)(ArgumentMatchers.any).afterReturn(null);
      when(mockRequestNewSceneSession)(ArgumentMatchers.any).afterReturn(sceneSession01);
      when(mockIsDeliverApplication)(ArgumentMatchers.any).afterReturn(true);

      let result: SCBSceneSession | null = panelViewModel.requestSceneSession(sceneInfo01);

      expect(result).assertEqual(sceneSession01);
      if(result != null && result.sceneInfo != null){
        mockLog.showInfo('result persistentID ' + result.sceneInfo.persistentId);
        mockLog.showInfo('result callerPersistentId ' + result.sceneInfo.callerPersistentId);
        expect(result.sceneInfo.callerPersistentId).assertEqual(0);
      }
      mocker.verify('requestNewSceneSession', [sceneInfo01]).atLeast(1);
      mocker.ignoreMock(panelViewModel, panelViewModel.getSceneSessionFromOtherScreen);
      mocker.ignoreMock(panelViewModel, panelViewModel.getSceneSession);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isDeliverApplication);
      mocker.ignoreMock(panelViewModel, panelViewModel.requestNewSceneSession);
    });

    it('test_when_persistentId_and_callerPersistentId_are_zero_notNewInstance_notDeliverApp_and_want_is_not_Null',
      Level.LEVEL0, () => {
        let sceneInfo01: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 0);
        sceneInfo01.callerPersistentId = 0;
        sceneInfo01.isNewInstance = false
        let want: Want = {
          abilityName: '',
          bundleName: ''
        };
        sceneInfo01.want = want;
        let sceneSession01: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo01), sceneInfo01);
        let mockGetSceneSessionFromOtherScreen: Function =
          mocker.mockFunc(panelViewModel, panelViewModel.getSceneSessionFromOtherScreen);
        let mockGetSceneSession: Function = mocker.mockFunc(panelViewModel, panelViewModel.getSceneSession);
        let mockIsDeliverApplication: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
          SCBSceneSessionManager.getInstance().isDeliverApplication);
        when(mockGetSceneSessionFromOtherScreen)(ArgumentMatchers.any).afterReturn(undefined);
        when(mockGetSceneSession)(ArgumentMatchers.any).afterReturn(sceneSession01);
        when(mockIsDeliverApplication)(ArgumentMatchers.any).afterReturn(false);

        let result: SCBSceneSession | null = panelViewModel.requestSceneSession(sceneInfo01);

        expect(result).assertEqual(sceneSession01);
        if(result != null && result.sceneInfo != null){
          expect(result.sceneInfo.callerPersistentId).assertEqual(0);
        }
        mocker.verify('getSceneSession', [sceneInfo01]).atLeast(1);
        mocker.ignoreMock(panelViewModel, panelViewModel.getSceneSessionFromOtherScreen);
        mocker.ignoreMock(panelViewModel, panelViewModel.getSceneSession);
        mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isDeliverApplication);
      });
  });

  describe('SCBScenePanelViewModel_succeedBackToCaller_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9600);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let containerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    /**
     * 用例描述: 是否成功返回拉起方
     * 预置条件: 被拉起方的callerPersistentId为undefined
     * 测试场景: 被拉起方的callerPersistentId为undefined
     * 预期结果: 返回拉起方失败
     */
    it('test_whenCallerPersistentIdIsUndefined_thenReturnFalse', Level.LEVEL0, () => {
      sceneSession.sceneInfo.callerPersistentId = undefined;

      let ret:boolean = panelViewModel.succeedBackToCaller(containerSession, sceneSession.sceneInfo.persistentId);

      expect(ret).assertFalse();
    });
  });

  describe('SCBScenePanelViewModel_getToContainerSessionOfTransition_testSuite', () => {
    let mocker = new MockKit();
    let panelViewModel: SCBScenePanelViewModel;

    beforeAll(() => {
      panelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    })
    afterAll(() => {
      panelViewModel.getContainerSessionList().clear();
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().clear();
    });
    /**
     * 用例描述: 根据sceneSession的persistentId,获取containerSession
     * 预置条件: 不再锁屏之上显示
     * 测试场景: 根据sceneSession的persistentId,获取containerSession
     * 预期结果: 返回specialContainerSession
     */
    it('test_sessionInSpecialContainerSessionList_returnSpSession', Level.LEVEL0, () => {
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 123);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let containerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(scbSceneSession, screenProperty);

      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().push(containerSession)

      let toContainerSession = panelViewModel.getToContainerSessionOfTransition(scbSceneSession, scbSceneInfo, false);
      expect(toContainerSession.primarySession).assertEqual(scbSceneSession);
    })

    /**
     * 用例描述: 创建锁屏之上session数据
     * 预置条件: isFromShowAboveKeyguard 配置在锁屏之上显示
     * 测试场景: 在锁屏之上打开应用
     * 预期结果: 返回新建的session数据
     */
    it('test_isFromShowAboveKeyguardIsTrue_returnCreateSession', Level.LEVEL0, () => {
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 123);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let toContainerSession: SCBSceneContainerSession;
      // 用例异步执行，需要先清理
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().clear();

      toContainerSession = panelViewModel.getToContainerSessionOfTransition(scbSceneSession, scbSceneInfo, true);
      expect(toContainerSession.needRenderAlpha.sceneAlpha).assertEqual(1);

      // 已经根据callerId启动
      scbSceneInfo.isCalledRightlyByCallerId = true;
      toContainerSession = panelViewModel.getToContainerSessionOfTransition(scbSceneSession, scbSceneInfo, true);
      expect(scbSceneSession.sessionData.isTemporarilyShowWhenLocked).assertTrue();
      // 执行了2次push进containerSessionList
      expect(panelViewModel.getContainerSessionList().length).assertEqual(1);
    })

    /**
     * 用例描述: 打开锁屏之下的应用
     * 预置条件: session不存在于specialContainerSession中，且配置在锁屏之上不显示
     * 测试场景: 打开锁屏下的应用
     * 预期结果: 返回锁屏之下session数据
     */
    it('test_createContainerSessionBelowKeyguard_returnNull', Level.LEVEL0, () => {
      let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 123);
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      // 用例异步执行，需要先清理
      SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().clear();

      let toContainerSession = panelViewModel.getToContainerSessionOfTransition(scbSceneSession, scbSceneInfo, false);

      expect(toContainerSession).not().assertNull();
      // 执行第3次push进containerSessionList
      expect(panelViewModel.getContainerSessionList().length).assertEqual(2);
    });
  });

  describe('SCBScenePanelViewModel_onStartSceneFromRecent_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9527);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let containerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());


    it('test_whenContainerSessionListHasContainer_thenSuccess', Level.LEVEL0, () => {
      panelViewModel.getContainerSessionList().push(containerSession);
      panelViewModel.onStartSceneFromRecent(sceneSession.sceneInfo.persistentId);
      expect(panelViewModel.getContainerSessionList().length).assertLarger(0);
    });
  });

  describe('SCBScenePanelViewModel_startSceneFromRecent_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    let mocker: MockKit = new MockKit();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9527);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let containerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    beforeAll(() => {
    })
    afterEach(() => {
    });

    it('test_whenContainerSessionIsInMidScene_thenSuccess', Level.LEVEL0, () => {
      let mockRecentLog: Function = mocker.mockFunc(recentLog, recentLog.showWarn)
      when(mockRecentLog)(ArgumentMatchers.any).afterReturnNothing();
      containerSession.isMidScene = true;

      panelViewModel.startSceneFromRecent(containerSession);

      expect(sceneSession.sceneParam.persistentId).assertEqual(0);
      mocker.ignoreMock(recentLog, recentLog.showWarn);
    });
  });

  describe('SCBScenePanelViewModel_getFloatSessionWithPersistentId_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9555);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let containerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    beforeAll(() => {
      panelViewModel.getFloatingSessionList().clear();
    })
    afterEach(() => {
      panelViewModel.getFloatingSessionList().clear();
    });

    it('test_whenContainerSessionInFloatingSessionList_thenSuccess', Level.LEVEL0, () => {
      panelViewModel.getFloatingSessionList().push(containerSession);

      let ret: SCBSceneSession | null = panelViewModel.getFloatSessionWithPersistentId(sceneInfo.persistentId);

      expect(ret).not().assertNull();
    });
  });

  describe('SCBScenePanelViewModel_needRemoveSessionAfterSceneTerminate_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    let mocker: MockKit = new MockKit();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9527);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

    it('test_whenContainerSessionListIsEmpty_thenSuccess', Level.LEVEL0, () => {
      let mockFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().isRemoveSessionAfterTerminate)
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();

      panelViewModel.needRemoveSessionAfterSceneTerminate(sceneSession, sceneInfo);

      mocker.verify('isRemoveSessionAfterTerminate',
        [sceneSession.sceneInfo.bundleName, sceneSession.sceneInfo.moduleName, sceneSession.sceneInfo.abilityName,
          sceneInfo]).atLeast(1);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().isRemoveSessionAfterTerminate);
    });
  });

  describe('SCBScenePanelViewModel_clearAllContainerSession_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9527);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let containerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    it('test_whenFloatContainerSessionListIsNotEmpty_thenSuccess', Level.LEVEL0, () => {
      panelViewModel.getFloatingSessionList().push(containerSession);

      panelViewModel.clearAllContainerSession();

      expect(panelViewModel.getFloatingSessionList().length).assertEqual(0);
    });
  });

  describe('SCBScenePanelViewModel_deleteToChainForContainerSession_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9527);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let containerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    /**
     * 用例描述: 清理containerSession toPersistentId
     * 预置条件: containerSessionList中存在两个container，且存在caller关系
     * 测试场景: 清理containerSession toPersistentId
     * 预期结果: containerSession的toPersistentId被重置为0
     */
    it('test_whenSessionToPersistentIdIsNotUndefined_thenSuccess', Level.LEVEL0, () => {
      let toSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9528);
      let toSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(toSceneInfo), toSceneInfo);
      let toContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(toSceneSession, new SCBScreenProperty());
      sceneInfo.toPersistentId = 9528;
      panelViewModel.getContainerSessionList().push(containerSession);
      panelViewModel.getContainerSessionList().push(toContainerSession);

      panelViewModel.deleteToChainForContainerSession(containerSession);
      expect(sceneSession.sceneInfo.toPersistentId).assertEqual(0);
    });
  });

  describe('SCBScenePanelViewModel_deleteCallerChainForContainerSession_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9527);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let containerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    /**
     * 用例描述: 清理containerSession callerPersistentId
     * 预置条件: containerSessionList中存在两个container，且存在caller关系
     * 测试场景: 清理containerSession callerPersistentId
     * 预期结果: containerSession的callerPersistentId被重置为0
     */
    it('test_whenSessionCallerPersistentIdIsNotUndefined_thenSuccess', Level.LEVEL0, () => {
      let callerSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9526);
      let callerSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(callerSceneInfo), callerSceneInfo);
      let callerContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(callerSceneSession, new SCBScreenProperty());
      sceneSession.sceneInfo.callerPersistentId = callerSceneSession.sceneInfo.persistentId;
      panelViewModel.getContainerSessionList().clear();
      panelViewModel.getContainerSessionList().push(containerSession);
      panelViewModel.getContainerSessionList().push(callerContainerSession);

      panelViewModel.deleteCallerChainForContainerSession(containerSession);
      expect(sceneSession.sceneInfo.callerPersistentId).assertEqual(0);
    });
  });

  describe('OnTerminateSceneOnPanelClearSessionAndCallerLink_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
    let panelMgr = panelViewModel.getPanelManager();

    beforeAll(() => {
      panelViewModel.getContainerSessionList().clear();
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('test_should_keep_caller_keep_session_when_needRemoveSession_false_needClearCallerLink_false',
      Level.LEVEL0, () => {
        let callerSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 9624);
        let callerSceneSession: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(callerSceneInfo), callerSceneInfo);
        let callerContainerSession = new SCBSceneContainerSession(callerSceneSession, new SCBScreenProperty());
        panelViewModel.getContainerSessionList().
        push(new SCBSceneContainerSession(callerSceneSession, new SCBScreenProperty()));
        let len = panelViewModel.getContainerSessionList().length;
        let needRemoveSession = false;
        let needClearCallerLink = false;
        let terminateSceneEntryParam: TerminateSceneEntryParam = {
          containerSession: callerContainerSession,
          needRemoveSession: needRemoveSession,
          needClearData: needClearCallerLink,
          isForceClean: false,
          isSessionException: false
        };
        panelViewModel.onTerminateSceneFromBackgroundOrRecent(terminateSceneEntryParam);

        expect(len === panelViewModel.getContainerSessionList().length).assertTrue();
    });

    it('test_should_clear_caller_keep_session_when_needRemoveSession_false_needClearCallerLink_true',
      Level.LEVEL0, () => {
        let toSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 9625);
        toSceneInfo.callerPersistentId = sceneInfo.persistentId;
        let toSceneSession: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(toSceneInfo), toSceneInfo);
        sceneInfo.toPersistentId = toSceneInfo.persistentId;
        let sceneSession: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        panelViewModel.getContainerSessionList().push(new SCBSceneContainerSession(sceneSession, new SCBScreenProperty()));
        panelViewModel.getContainerSessionList().push(new SCBSceneContainerSession(toSceneSession, new SCBScreenProperty()));
        let toContainerSession = new SCBSceneContainerSession(toSceneSession, new SCBScreenProperty());

        let len = panelViewModel.getContainerSessionList().length;
        panelViewModel.deleteCallerChainForSceneSession(sceneInfo);
        let needRemoveSession = false;
        let needClearCallerLink = true;
        let terminateSceneEntryParam: TerminateSceneEntryParam = {
          containerSession: toContainerSession,
          needRemoveSession: needRemoveSession,
          needClearData: needClearCallerLink,
          isForceClean: false,
          isSessionException: false
        };
        panelViewModel.onTerminateSceneFromBackgroundOrRecent(terminateSceneEntryParam);

        expect(toSceneSession.sceneInfo.toPersistentId).assertEqual(0);
        expect(sceneSession.sceneInfo.callerPersistentId).assertEqual(0);
        expect(len === panelViewModel.getContainerSessionList().length).assertTrue();
    });
  });

  describe('test_notifySystemSceneRotationWithAnimation_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    beforeAll(() => {
      panelViewModel.getContainerSessionList().clear();
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('test_notify_systemScene_rotation_with_animation_01',
      Level.LEVEL0, () => {
        let scbscreenProperty = new SCBScreenProperty();
        panelViewModel.notifySystemSceneRotationWithAnimation(new SCBScreenProperty());
        scbscreenProperty.left = 0;
        expect(scbscreenProperty.left).assertEqual(0);
      });

    it('test_notify_systemScene_rotation_with_animation_02',
      Level.LEVEL0, () => {
        let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 1235);
        let sceneSession: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        let scbscreenProperty = new SCBScreenProperty();
        let currContainerSession: SCBSceneContainerSession =
          new SCBSceneContainerSession(sceneSession, scbscreenProperty);
        panelViewModel.notifySystemSceneRotationWithAnimation(scbscreenProperty, currContainerSession);
        scbscreenProperty.left = 0;
        expect(scbscreenProperty.left).assertEqual(0);
      });
  });

  describe('test_getRotateDuration_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    beforeAll(() => {
      panelViewModel.getContainerSessionList().clear();
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('test_get_rotate_duration_testSuite_01',
      Level.LEVEL0, () => {
        let rotation = 0;
        panelViewModel.getRotateDuration(rotation);
        expect(rotation).assertEqual(0);
      });

    it('test_get_rotate_duration_testSuite_02',
      Level.LEVEL0, () => {
        let rotation = 90;
        panelViewModel.getRotateDuration(rotation);
        expect(rotation).assertEqual(90);
      });
  });

  describe('test_getAllSceneSessionInOneApp_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    beforeAll(() => {
      panelViewModel.getContainerSessionList().clear();
    });

    it('test_whenContainerSessionListIsNotNull_thenSuccess', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle2', 'testPriModule', 'testPriAbility', 0, 200);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      panelViewModel.getContainerSessionList()
        .push(new SCBSceneContainerSession(sceneSession, new SCBScreenProperty()));

      let ret = panelViewModel.getAllSceneSessionInOneApp(sceneInfo);
      expect(ret.length).assertLarger(0);
    });
  });


  describe('test_findRecentUsedSceneSession_testSuite', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    beforeAll(() => {
      panelViewModel.getContainerSessionList().clear();
    });

    it('test_whenSceneArrayNotNull_thenSuccess', Level.LEVEL0, () => {
      let sceneInfo = new SCBSceneInfo('testPriBundle2', 'testPriModule', 'testPriAbility', 0, 201);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      sceneSession.lastUsedTimestamp = 1;
      let sceneInfo2 = new SCBSceneInfo('testPriBundle2', 'testPriModule2', 'testPriAbility2', 0, 202);
      let sceneSession2: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
      sceneSession2.lastUsedTimestamp = 2;
      let sceneArray = new SCBSceneSessionArray();
      sceneArray.push(sceneSession);
      sceneArray.push(sceneSession2);

      let ret: SCBSceneSession | null = panelViewModel.findRecentUsedSceneSession(sceneArray, 'testPriAbility');
      expect(ret).assertEqual(sceneSession2);
    });

    it('test_whenSceneArrayIsNull_thenReturnNull', Level.LEVEL0, () => {
      let ret: SCBSceneSession | null = panelViewModel.findRecentUsedSceneSession(new SCBSceneSessionArray(), 'testPriAbility');

      expect(ret).assertNull();
    });
  });

  describe('SCBScenePanelViewModel_checkIfNeedChangeScreenProperty', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    beforeAll(() => {
      panelViewModel.getContainerSessionList().clear();
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('test_check_if_need_change_screen_property_01',
      Level.LEVEL0, () => {
        panelViewModel.updateScreenRotationPropertyForExit();
        let screenSession: SCBScreenSession = SCBScreenSessionManager.getInstance().getScreenSession(0);
        let rotation: number = screenSession.scbScreenProperty.rotation;
        screenSession.scbScreenProperty.rotation = -1;
        panelViewModel.checkIfNeedChangeScreenProperty(screenSession);
        screenSession.scbScreenProperty.rotation = rotation;
        expect(screenSession.scbScreenProperty.left).assertEqual(0);
      });
  });

  describe('SCBScenePanelViewModel_startFadeInAnimationForCallUI', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    beforeAll(() => {
      panelViewModel.getContainerSessionList().clear();
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('test_start_fadeIn_animation_for_CallUI_01',
      Level.LEVEL0, () => {
        let containerSession: SCBSceneContainerSession | null = null;
        ReflectionUtils.useFunc(panelViewModel, 'startFadeInAnimationForCallUI', containerSession);
        expect(containerSession === null).assertTrue();

        containerSession = buildContainer();
        if (containerSession === null) {
          return;
        }
        containerSession.mainSession.isBufferAvailable = true;
        containerSession.needRenderAlpha.setNeedRenderAlpha(1.0); // alpha 1.0
        ReflectionUtils.useFunc(panelViewModel, 'startFadeInAnimationForCallUI', containerSession);
        expect(containerSession.needRenderAlpha.sceneAlpha).assertEqual(1.0); // alpha 1.0

        containerSession.needRenderAlpha.setNeedRenderAlpha(0); // alpha 0
        containerSession.isFloat = true;
        ReflectionUtils.useFunc(panelViewModel, 'startFadeInAnimationForCallUI', containerSession);
        expect(containerSession.needRenderAlpha.sceneAlpha).assertEqual(0); // alpha 0
      });
    it('test_start_fadeIn_animation_for_CallUI_02',
      Level.LEVEL0, () => {
        expect(SCBPhoneSceneUtils.isCallUIScene(null)).assertFalse();
        // appIndex: 0, id: 0
        let toSceneInfo = new SCBSceneInfo('com.ohos.callui', 'com.ohos.callui', 'com.ohos.callui.MainAbility', 0, 0);
        // appIndex: 0, id: 0
        let fromSceneInfo = new SCBSceneInfo('com.ohos.callui', 'testPriModule', 'testPriAbility', 0, 0);
        expect(SCBPhoneSceneUtils.isCallUIScene(fromSceneInfo)).assertFalse();
        // appIndex: 0, id: 0
        fromSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 0);
        expect(SCBPhoneSceneUtils.isCallUIScene(fromSceneInfo)).assertFalse();
        panelViewModel.onStartSceneFromOther(toSceneInfo, fromSceneInfo);
        expect(SCBPhoneSceneUtils.isCallUIScene(toSceneInfo)).assertTrue();
      });
  });
  describe('SCBScenePanelViewModel_executeFadeInAnimation', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    beforeAll(() => {
      panelViewModel.getContainerSessionList().clear();
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('test_execute_fadeIn_animation_01',
      Level.LEVEL0, () => {
        let duration: number = 150; // duration 150ms
        let curve: Curve = Curve.FastOutSlowIn;
        let containerSession: SCBSceneContainerSession | null = null;
        ReflectionUtils.useFunc(panelViewModel, 'executeFadeInAnimation', containerSession, duration, curve, null);
        expect(containerSession === null).assertTrue();

        containerSession = buildContainer();
        if (containerSession === null) {
          return;
        }
        containerSession.needRenderAlpha.setNeedRenderAlpha(0); // alpha 0
        ReflectionUtils.useFunc(panelViewModel, 'executeFadeInAnimation', containerSession, duration, curve, null);
        expect(containerSession.needRenderAlpha.sceneAlpha).assertEqual(0); // alpha 0

        let callback = () => {};
        containerSession.needRenderAlpha.setNeedRenderAlpha(1.0); // alpha 1.0
        ReflectionUtils.useFunc(panelViewModel, 'executeFadeInAnimation', containerSession, duration, curve, callback);
        expect(containerSession.needRenderAlpha.sceneAlpha).assertEqual(1.0); // alpha 1.0
      });
  });

  describe('SCBScenePanelViewModel_addAdditionalCallers', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 1235);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    const caller: CallerInfo = {
      persistentId: 111,
      windowMode: SCBSceneMode.FLOATING
    };

    beforeEach(() => {
      panelViewModel.clearAdditionalCallers(sceneSession);
    });

    it('test_addNewCallerWhichDoesNotExist_thenAddSuccess', Level.LEVEL0, () => {
      expect(sceneSession.sceneInfo.additionalCallers.length).assertEqual(0);
      panelViewModel.addAdditionalCallers(sceneSession, caller);

      expect(sceneSession.sceneInfo.additionalCallers.length).assertEqual(1);
      expect(sceneSession.sceneInfo.additionalCallers[0].persistentId).assertEqual(111);
      expect(sceneSession.sceneInfo.additionalCallers[0].windowMode).assertEqual(SCBSceneMode.FLOATING);
    });

    it('test_addNewCallerWhichAlreadyExist_thenAddFailed', Level.LEVEL0, () => {
      panelViewModel.addAdditionalCallers(sceneSession, caller);
      expect(sceneSession.sceneInfo.additionalCallers.length).assertEqual(1);
      panelViewModel.addAdditionalCallers(sceneSession, caller);

      expect(sceneSession.sceneInfo.additionalCallers.length).assertEqual(1);
    });

    it('test_addNewCallerWithSamePersistentIdButDifferentWindowMode_thenAddSuccess', Level.LEVEL0, () => {
      // 添加一个调用者，persistentId相同但windowMode不同
      const newCaller:CallerInfo = {
        persistentId: 111,
        windowMode: SCBSceneMode.FULLSCREEN
      };
      panelViewModel.addAdditionalCallers(sceneSession, caller);
      panelViewModel.addAdditionalCallers(sceneSession, newCaller);

      expect(sceneSession.sceneInfo.additionalCallers.length).assertEqual(2);
      expect(sceneSession.sceneInfo.additionalCallers[1].persistentId).assertEqual(111);
      expect(sceneSession.sceneInfo.additionalCallers[1].windowMode).assertEqual(SCBSceneMode.FULLSCREEN);
    });
  });

  describe('SCBScenePanelViewModel_clearAdditionalCallers', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 1235);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    const caller: CallerInfo = {
      persistentId: 111,
      windowMode: SCBSceneMode.FLOATING
    };

    beforeEach(() => {
      panelViewModel.clearAdditionalCallers(sceneSession);
    });

    it('test_addNewCallerWhichDoesNotExist_thenAddSuccess', Level.LEVEL0, () => {
      expect(sceneSession.sceneInfo.additionalCallers.length).assertEqual(0);
      panelViewModel.addAdditionalCallers(sceneSession, caller);
      expect(sceneSession.sceneInfo.additionalCallers.length).assertEqual(1);
      panelViewModel.clearAdditionalCallers(sceneSession);

      expect(sceneSession.sceneInfo.additionalCallers.length).assertEqual(0);
    });
  });

  describe('SCBScenePanelViewModel_atomicServiceScene', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());

    it('SCBScenePanelViewModel_atomicServiceScene_01', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let containerSession: SCBSceneContainerSession = buildContainer();
      containerSession.needRenderAlpha.setNeedRenderAlpha(0); // alpha 0
      let toSceneInfo = new SCBSceneInfo('com.ohos.callui', 'com.ohos.callui', 'com.ohos.callui.MainAbility', 0, 0);
      let fromSceneInfo = new SCBSceneInfo('com.ohos.callui', 'testPriModule', 'testPriAbility', 0, 0);

      let closeAppManager = CloseAppManager.getInstance();
      let fun_01: Function = mocker.mockFunc(closeAppManager, closeAppManager.getAndResetIsStartCard);
      when(fun_01)(ArgumentMatchers.any).afterReturn(true);

      let fun_02: Function = mocker.mockFunc(panelViewModel, panelViewModel.searchInScreen);
      when(fun_02)(ArgumentMatchers.any).afterReturn(true);
      containerSession.needRenderAlpha.setNeedRenderAlpha(1.0); // alpha 0
      panelViewModel.onStartSceneFromOther(toSceneInfo, fromSceneInfo);
      expect(closeAppManager.getAndResetIsStartCard() && panelViewModel.searchInScreen()).assertTrue();
      mocker.clear(closeAppManager);
      mocker.clear(panelViewModel);
    });
  });

  describe('SCBScenePanelViewModel_rotateWindowPolicy', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());

    it('testRotateWindowPolicy_requestPIPScenePanelRotation', Level.LEVEL0, () => {
      let containerSession = buildContainer();
      let scbScreenSession = new SCBScreenSession(buildScreenSession());
      let mocker = new MockKit();
      let func1 = mocker.mockFunc(panelViewModel, panelViewModel.requestPIPScenePanelRotation);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        log.showInfo('test_rotateWindowPolicy requestPIPScenePanelRotation action');
        count++;
      });
      log.showInfo('test_rotateWindowPolicy requestPIPScenePanelRotation begin');
      panelViewModel.rotateWindowPolicy(containerSession, true, 90, scbScreenSession, true, true, false);
      log.showInfo('test_rotateWindowPolicy requestPIPScenePanelRotation end');
      expect(count).assertEqual(1);
      mocker.ignoreMock(panelViewModel, panelViewModel.requestPIPScenePanelRotation);
    });

    it('testRotateWindowPolicy_notifySystemSceneToUpdateSizeChangeReason', Level.LEVEL0, () => {
      let containerSession = buildContainer();
      let scbScreenSession = new SCBScreenSession(buildScreenSession());
      let mocker = new MockKit();
      let func1 = mocker.mockFunc(panelViewModel, panelViewModel.notifySystemSceneToUpdateSizeChangeReason);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        log.showInfo('test_rotateWindowPolicy notifySystemSceneToUpdateSizeChangeReason action');
        count++;
      });
      log.showInfo('test_rotateWindowPolicy notifySystemSceneToUpdateSizeChangeReason begin');
      panelViewModel.rotateWindowPolicy(containerSession, true, 90, scbScreenSession, true, true, false);
      log.showInfo('test_rotateWindowPolicy notifySystemSceneToUpdateSizeChangeReason end');
      expect(count).assertEqual(1);
      mocker.ignoreMock(panelViewModel, panelViewModel.notifySystemSceneToUpdateSizeChangeReason);
    });

    it('testRotateWindowPolicy_updateVisibleSystemRotation', Level.LEVEL0, () => {
      let containerSession = buildContainer();
      let scbScreenSession = new SCBScreenSession(buildScreenSession());
      let mocker = new MockKit();
      let func1 = mocker.mockFunc(panelViewModel, panelViewModel.updateVisibleSystemRotation);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        log.showInfo('test_rotateWindowPolicy updateVisibleSystemRotation action');
        count++;
      });
      log.showInfo('test_rotateWindowPolicy updateVisibleSystemRotation begin');
      panelViewModel.rotateWindowPolicy(containerSession, true, 90, scbScreenSession, true, true, false);
      log.showInfo('test_rotateWindowPolicy updateVisibleSystemRotation end');
      expect(count).assertEqual(1);
      mocker.ignoreMock(panelViewModel, panelViewModel.updateVisibleSystemRotation);
    });

    it('testRotateWindowPolicy_showDividerAfterRotation', Level.LEVEL0, () => {
      let containerSession = buildContainer();
      let scbScreenSession = new SCBScreenSession(buildScreenSession());
      let mocker = new MockKit();
      let func1 = mocker.mockFunc(panelViewModel, panelViewModel.showDividerAfterRotation);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        log.showInfo('test_rotateWindowPolicy showDividerAfterRotation action');
        count++;
      });
      log.showInfo('test_rotateWindowPolicy showDividerAfterRotation begin');
      panelViewModel.rotateWindowPolicy(containerSession, true, 90, scbScreenSession, true, true, false);
      log.showInfo('test_rotateWindowPolicy showDividerAfterRotation end');
      expect(count).assertEqual(1);
      mocker.ignoreMock(panelViewModel, panelViewModel.showDividerAfterRotation);
    });

    it('testRotateWindowPolicy_updateInVisibleSystemRotation', Level.LEVEL0, () => {
      let containerSession = buildContainer();
      let scbScreenSession = new SCBScreenSession(buildScreenSession());
      let mocker = new MockKit();
      let func1 = mocker.mockFunc(panelViewModel, panelViewModel.updateInVisibleSystemRotation);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        log.showInfo('test_rotateWindowPolicy updateInVisibleSystemRotation action');
        count++;
      });
      log.showInfo('test_rotateWindowPolicy updateInVisibleSystemRotation begin');
      panelViewModel.rotateWindowPolicy(containerSession, true, 90, scbScreenSession, true, true, false);
      log.showInfo('test_rotateWindowPolicy updateInVisibleSystemRotation end');
      expect(count).assertEqual(1);
      mocker.ignoreMock(panelViewModel, panelViewModel.updateInVisibleSystemRotation);
    });

    it('testRotateWindowPolicy_updateScreenRotationProperty', Level.LEVEL0, () => {
      let containerSession = buildContainer();
      let scbScreenSession = new SCBScreenSession(buildScreenSession());
      let mocker = new MockKit();
      let func1 = mocker.mockFunc(panelViewModel, panelViewModel.updateScreenRotationProperty);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        log.showInfo('test_rotateWindowPolicy updateScreenRotationProperty action');
        count++;
      });
      log.showInfo('test_rotateWindowPolicy updateScreenRotationProperty begin');
      panelViewModel.rotateWindowPolicy(containerSession, true, 90, scbScreenSession, true, false, false);
      log.showInfo('test_rotateWindowPolicy updateScreenRotationProperty end');
      expect(count).assertEqual(1);
      mocker.ignoreMock(panelViewModel, panelViewModel.updateScreenRotationProperty);
    });

    it('testRotateWindowPolicy_notifySetSystemSceneRotaion', Level.LEVEL0, () => {
      let containerSession = buildContainer();
      let scbScreenSession = new SCBScreenSession(buildScreenSession());
      let mocker = new MockKit();
      let func1 = mocker.mockFunc(panelViewModel, panelViewModel.notifySetSystemSceneRotaion);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        log.showInfo('test_rotateWindowPolicy notifySetSystemSceneRotaion action');
        count++;
      });
      log.showInfo('test_rotateWindowPolicy notifySetSystemSceneRotaion begin');
      panelViewModel.rotateWindowPolicy(containerSession, true, 90, scbScreenSession, true, false, false);
      log.showInfo('test_rotateWindowPolicy notifySetSystemSceneRotaion end');
      expect(count).assertEqual(1);
      mocker.ignoreMock(panelViewModel, panelViewModel.notifySetSystemSceneRotaion);
    });

    it('testRotateWindowPolicy_notifyUpdateSystemScenePropertyWithoutAnimation', Level.LEVEL0, () => {
      let containerSession = buildContainer();
      let scbScreenSession = new SCBScreenSession(buildScreenSession());
      let mocker = new MockKit();
      let func1 = mocker.mockFunc(panelViewModel, panelViewModel.notifyUpdateSystemScenePropertyWithoutAnimation);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        log.showInfo('test_rotateWindowPolicy notifyUpdateSystemScenePropertyWithoutAnimation action');
        count++;
      });
      log.showInfo('test_rotateWindowPolicy notifyUpdateSystemScenePropertyWithoutAnimation begin');
      panelViewModel.rotateWindowPolicy(containerSession, true, 90, scbScreenSession, true, false, false);
      log.showInfo('test_rotateWindowPolicy notifyUpdateSystemScenePropertyWithoutAnimation end');
      expect(count).assertEqual(1);
      mocker.ignoreMock(panelViewModel, panelViewModel.notifyUpdateSystemScenePropertyWithoutAnimation);
    });

    it('testRotateWindowPolicy_updateRotateAnimationConfig', Level.LEVEL0, () => {
      let containerSession = buildContainer();
      let scbScreenSession = new SCBScreenSession(buildScreenSession());
      let mocker = new MockKit();
      let func1 = mocker.mockFunc(panelViewModel, panelViewModel.updateRotateAnimationConfig);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        log.showInfo('test_rotateWindowPolicy updateRotateAnimationConfig action');
        count++;
      });
      log.showInfo('test_rotateWindowPolicy updateRotateAnimationConfig begin');
      panelViewModel.rotateWindowPolicy(containerSession, true, 90, scbScreenSession, true, false, false);
      log.showInfo('test_rotateWindowPolicy updateRotateAnimationConfig end');
      expect(count).assertEqual(1);
      mocker.ignoreMock(panelViewModel, panelViewModel.updateRotateAnimationConfig);
    });

    it('testRotateWindowPolicy_notifyUpdateSystemScenePropertyWithAnimation', Level.LEVEL0, () => {
      let containerSession = buildContainer();
      let scbScreenSession = new SCBScreenSession(buildScreenSession());
      let mocker = new MockKit();
      let func1 = mocker.mockFunc(panelViewModel, panelViewModel.notifyUpdateSystemScenePropertyWithAnimation);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        log.showInfo('test_rotateWindowPolicy notifyUpdateSystemScenePropertyWithAnimation action');
        count++;
      });
      log.showInfo('test_rotateWindowPolicy notifyUpdateSystemScenePropertyWithAnimation begin');
      panelViewModel.rotateWindowPolicy(containerSession, true, 90, scbScreenSession, true, false, false);
      log.showInfo('test_rotateWindowPolicy notifyUpdateSystemScenePropertyWithAnimation end');
      expect(count).assertEqual(1);
      mocker.ignoreMock(panelViewModel, panelViewModel.notifyUpdateSystemScenePropertyWithAnimation);
    });
  })

  describe('SCBScenePanelViewModel_rotateScreenPolicy', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    it('testRotateScreenPolicy_setExpandStartContainerSessionInvokeTwice', Level.LEVEL0, () => {
      let containerSession = buildContainer();
      let scbScreenSession = new SCBScreenSession(buildScreenSession());
      let mocker = new MockKit();
      let func1 = mocker.mockFunc(panelViewModel, panelViewModel.setExpandStartContainerSession);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`test_rotateWindowPolicy setExpandStartContainerSession action ${count}`);
      });
      log.showInfo('testRotateScreenPolicy setExpandStartContainerSession begin');
      panelViewModel.rotateScreenPolicy(scbScreenSession, containerSession, true, false, 0);
      log.showInfo('testRotateScreenPolicy setExpandStartContainerSession end');
      expect(count).assertEqual(2);
      mocker.ignoreMock(panelViewModel, panelViewModel.setExpandStartContainerSession);
    });

    it('testRotateScreenPolicy_clearRecentStartNotifyRotation', Level.LEVEL0, () => {
      let containerSession = buildContainer();
      let scbScreenSession = new SCBScreenSession(buildScreenSession());
      let mocker = new MockKit();
      let func1 = mocker.mockFunc(panelViewModel, panelViewModel.clearRecentStartNotifyRotation);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`test_rotateWindowPolicy clearRecentStartNotifyRotation action ${count}`);
      });
      log.showInfo('testRotateScreenPolicy clearRecentStartNotifyRotation begin');
      panelViewModel.rotateScreenPolicy(scbScreenSession, containerSession, true, false, 0);
      log.showInfo('testRotateScreenPolicy clearRecentStartNotifyRotation end');
      expect(count).assertEqual(1);
      mocker.ignoreMock(panelViewModel, panelViewModel.clearRecentStartNotifyRotation);
    });
  })

  describe('SCBScenePanelViewModel_updateScenePanelWhenRotate', () => {
    let panelViewModel: SCBScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
    it('testUpdateScenePanelWhenRotate_notifyUpdateScenePanelWhenRotate', Level.LEVEL0, () => {
      let containerSession = buildContainer();
      let mocker = new MockKit();
      let func1 = mocker.mockFunc(panelViewModel, panelViewModel.notifyUpdateScenePanelWhenRotate);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`test_updateScenePanelWhenRotate notifyUpdateScenePanelWhenRotate action ${count}`);
      });
      log.showInfo('test_updateScenePanelWhenRotate notifyUpdateScenePanelWhenRotate begin');
      let screenProperty = new SCBScreenProperty();
      panelViewModel.updateScenePanelWhenRotate(screenProperty, screenProperty,
        SCBContainerRotationReason.PANEL_ROTATION, containerSession);
      log.showInfo('test_updateScenePanelWhenRotate notifyUpdateScenePanelWhenRotate end');
      expect(count).assertEqual(1);
      mocker.ignoreMock(panelViewModel, panelViewModel.notifyUpdateScenePanelWhenRotate);
    });

    it('testUpdateScenePanelWhenRotate_updateFloatContainerWithScreenChange', Level.LEVEL0, () => {
      let containerSession = buildContainer();
      let mocker = new MockKit();
      let func1 = mocker.mockFunc(panelViewModel, panelViewModel.updateFloatContainerWithScreenChange);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`test_updateScenePanelWhenRotate updateFloatContainerWithScreenChange action ${count}`);
      });
      log.showInfo('test_updateScenePanelWhenRotate updateFloatContainerWithScreenChange begin');
      let screenProperty = new SCBScreenProperty();
      panelViewModel.updateScenePanelWhenRotate(screenProperty, screenProperty,
        SCBContainerRotationReason.PANEL_ROTATION, containerSession);
      log.showInfo('test_updateScenePanelWhenRotate updateFloatContainerWithScreenChange end');
      expect(count).assertEqual(1);
      mocker.ignoreMock(panelViewModel, panelViewModel.updateFloatContainerWithScreenChange);
    });

    it('testUpdateScenePanelWhenRotate_updateSystemBarProperty', Level.LEVEL0, () => {
      let containerSession = buildContainer();
      let mocker = new MockKit();
      let func1 = mocker.mockFunc(panelViewModel, panelViewModel.updateSystemBarProperty);
      let count = 0;
      when(func1)(ArgumentMatchers.any).afterAction(() => {
        count++;
        log.showInfo(`test_updateScenePanelWhenRotate updateSystemBarProperty action ${count}`);
      });
      log.showInfo('test_updateScenePanelWhenRotate updateSystemBarProperty begin');
      let screenProperty = new SCBScreenProperty();
      panelViewModel.updateScenePanelWhenRotate(screenProperty, screenProperty,
        SCBContainerRotationReason.PANEL_ROTATION, containerSession);
      log.showInfo('test_updateScenePanelWhenRotate updateSystemBarProperty end');
      expect(count).assertEqual(1);
      mocker.ignoreMock(panelViewModel, panelViewModel.updateSystemBarProperty);
    });
  })
}

function buildContainer(): SCBSceneContainerSession {
  let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 9624);
  let sceneSession: SCBSceneSession =
    new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  let containerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
  return containerSession;
}

function buildScreenSession(): screenSessionManager.ScreenSession {
  let screenSession: screenSessionManager.ScreenSession = {
    screenId: -1,
    name: 'testScreen',
    on: (type: string, callback: Function): void => undefined,
    setScreenRotationLocked: (isLocked: boolean): void => undefined,
    loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => undefined,
    setTouchEnabled: (isTouchEnabled: boolean): void => undefined,
    getScreenUIContext: (): UIContext => {
      return sceneSessionManager.getRootSceneUIContext();
    }
  };
  return screenSession;
}