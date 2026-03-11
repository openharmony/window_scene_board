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

import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBScreenProperty,
  SCBSceneContainerSession,
  SCBSceneSession,
  SCBSceneInfo,
  RecentViewParam,
  SCBKeyboardSession,
  SCBKeyboardPanelSession,
  ScenePanelState,
  SCBScenePanelSession,
  SCBSceneContainerSessionArray,
} from '@ohos/windowscene/src/main/ets/TsIndex';
import { describe, beforeAll, it, expect, Level, beforeEach, afterEach, afterAll } from '@ohos/hypium';
import {
  SCBScenePanelViewModel,
  ScenePanelDataCollectionHandler,
  ScenePanelStateCollectionHandler
} from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/viewmodel/SCBScenePanelViewModel';
import { RecentStateManager } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/innerstate/RecentStates';
import { RecentDelete } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentDelete';
import { UIContext } from '@kit.ArkUI';
import { ReflectionUtils } from '../../multiwindow/ReflectionUtils';
import {
  QuickSwitchAnimations
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/quickswitchpanel/QuickSwitchAnimations';
import { AppFloating } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/apppanel/AppFloating';

let uiContext: UIContext = new UIContext();
const vm = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
// collectionHandler实现
let handlerViewParam: RecentViewParam;
let handlerKeyboardSession: SCBKeyboardSession;
let handleKeyboardPanelSession: SCBKeyboardPanelSession;
let handleVisibility: Visibility;
let handleScenePanelState: ScenePanelState;
let handleRecentStateManager: RecentStateManager = new RecentStateManager();
let handleScreenProperty: SCBScreenProperty;
let handlerScenePanelSession: SCBScenePanelSession;
let handlerAppFloating: AppFloating;

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
  getPanelSession: (): SCBScenePanelSession => {
    return handlerScenePanelSession;
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
  updateUnLockScale: () => {
  },
  getNeedScrollClip: (): boolean => {
    return true;
  },
  getIsEmptyRecentViewCallback: (): Function => {
    return () => {};
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


export function StartSceneFromRecentOnPanelTest() {
  describe('StartSceneFromRecentOnPanelTest_testsuite', () => {
    let scbScenePanelViewModel: SCBScenePanelViewModel;
    beforeAll(() => {
      scbScenePanelViewModel = new SCBScenePanelViewModel(uiContext, new SCBScreenProperty());
      scbScenePanelViewModel.init(panelStateCollectionHandler, panelDataCollectionHandler);
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });

    /**
     * 用例描述: 从多任务启动应用成功
     * 预置条件: containerSessionList存在目标Container
     * 测试场景: 从多任务启动应用
     * 预期结果: 启动成功，生命周期各状态正常
     */
    it('test_whenExistContainerStartSceneFromRecent_thenSuccess', Level.LEVEL0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 999);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      scbScenePanelViewModel.getContainerSessionList().push(containerSession);
      let beforeLength: number = scbScenePanelViewModel.getContainerSessionList().length;
      scbScenePanelViewModel.onStartSceneFromRecent(sceneSession.sceneInfo.persistentId);

      expect(beforeLength).assertEqual(scbScenePanelViewModel.getContainerSessionList().length);
      expect(containerSession.isActive).assertTrue();
      expect(ReflectionUtils.getProperty(scbScenePanelViewModel, 'stateCollectionHandler')?.getPanelState())
        .assertEqual(ScenePanelState.FULLSCENE);
    });

    /**
     * 用例描述: 从多任务启动应用失败
     * 预置条件: containerSessionList不存在目标Container
     * 测试场景: 从多任务启动应用
     * 预期结果: 启动失败
     */
    it('test_whenStartSceneFromRecent_thenFailed', Level.LEVEL0, () => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 998);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      let beforeLength: number = scbScenePanelViewModel.getContainerSessionList().length;
      ReflectionUtils.getProperty(scbScenePanelViewModel,
        'stateCollectionHandler')?.updatePanelState(ScenePanelState.HOME);
      scbScenePanelViewModel.onStartSceneFromRecent(sceneSession.sceneInfo.persistentId);

      expect(beforeLength).assertEqual(scbScenePanelViewModel.getContainerSessionList().length);
      expect(containerSession.isActive).assertFalse();
      expect(ReflectionUtils.getProperty(scbScenePanelViewModel, 'stateCollectionHandler')?.getPanelState())
        .assertEqual(ScenePanelState.HOME);
    });
  });
}