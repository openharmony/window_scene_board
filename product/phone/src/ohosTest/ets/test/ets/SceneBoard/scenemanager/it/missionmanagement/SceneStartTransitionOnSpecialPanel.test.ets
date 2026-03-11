/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { SCBScreenProperty } from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { describe, beforeAll, it, Level, beforeEach, afterEach, afterAll, expect, } from '@ohos/hypium';
import {
  SCBSpecialScenePanelViewModel,
  SpecialScenePanelStateCollectionHandler
} from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/viewmodel/SCBSpecialScenePanelViewModel';
import {
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  RecentViewParam,
  SCBKeyboardSession,
  KeyboardChangeCallback,
} from '@ohos/windowscene';
import { DeviceState } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { ReflectionUtils } from '../../multiwindow/ReflectionUtils';

enum ScenePanelState {
  HOME,
  FULLSCENE,
  RECENT
}

let keyboardChangeCallbackMap: Map<string, KeyboardChangeCallback> = new Map<string, KeyboardChangeCallback>();
let keyboardChangeListenerList: Array<KeyboardChangeCallback> = new Array();
let handlerViewParam: RecentViewParam;
let handlerStates: ScenePanelState;
let blackBackgroundState: boolean;
let isShowCompanionIcon: boolean;
const panelStateCollectionHandler: SpecialScenePanelStateCollectionHandler = {
  getPanelState: (): ScenePanelState => {
    return handlerStates;
  },

  updatePanelState: (state: ScenePanelState) => {
    handlerStates = state;
  },

  getViewParam: (): RecentViewParam => {
    return handlerViewParam;
  },
  getPanelName: (): string => {
    return '';
  },

  getScreenRotationAnimCnt: (): number => {
    return 0;
  },

  updateBlackBackgroundState: (state: boolean): void => {
    blackBackgroundState = state;
  },

  getMattesLockState: (): boolean => {
    return true;
  },

  getFoldStatus: (): number => {
    return DeviceState.DEFAULT_STATE;
  },

  getShowCompanionIconState: (): boolean => {
    return true;
  },

  updateShowCompanionIconState: (state:boolean): void => {
    isShowCompanionIcon = state;
  },
}

export function SceneStartTransitionOnSpecialPanelTest() {
  describe('SceneStartTransitionOnSpecialOnSpecialPanel_testSuite', (): void => {
    let screenProperty: SCBScreenProperty;
    let phyScreenProperty: SCBScreenProperty;
    let viewModel: SCBSpecialScenePanelViewModel;

    beforeAll(() => {
      screenProperty = new SCBScreenProperty();
      phyScreenProperty = new SCBScreenProperty();
      viewModel = new SCBSpecialScenePanelViewModel(screenProperty, phyScreenProperty);
      let sceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 12345);
      let keyboardSession = new SCBKeyboardSession(sceneSessionManager.requestSceneSession(sceneInfo),
        () => {
        }, keyboardChangeCallbackMap, keyboardChangeListenerList);
      viewModel.init(keyboardSession, panelStateCollectionHandler);
    });

    /**
     * 用例描述: 锁屏之上应用拉应用冷启动成功
     * 预置条件:
     * 测试场景: 锁屏之上应用拉应用
     * 预期结果: 应用成功被拉起
     */
    it('test_sceneStartTransitionOnSpecial_thenSuccess', Level.LEVEL0, () => {
      let toSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9999999);
      let fromSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 9999998);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(toSceneInfo), toSceneInfo);
      let sceneContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

      let fromSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(fromSceneInfo), fromSceneInfo);
      let fromSceneContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(fromSceneSession, new SCBScreenProperty());
      viewModel.getContainerSessionList().push(sceneContainerSession);
      viewModel.getContainerSessionList().push(fromSceneContainerSession);

      viewModel.onSceneStartTransition(sceneSession.sceneInfo, fromSceneSession.sceneInfo);
      expect(sceneContainerSession.isActive).assertTrue();
    });
  });
}