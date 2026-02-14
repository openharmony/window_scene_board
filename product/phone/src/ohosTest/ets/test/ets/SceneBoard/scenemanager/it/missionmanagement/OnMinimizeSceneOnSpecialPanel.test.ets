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

import { SCBKeyboardSession, SCBScreenProperty } from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  describe,
  beforeAll,
  it,
  Level,
  expect,
} from '@ohos/hypium';
import {
  SCBSpecialScenePanelViewModel,
  SpecialScenePanelStateCollectionHandler
} from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/viewmodel/SCBSpecialScenePanelViewModel';
import {
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  RecentViewParam,
  KeyboardChangeCallback
} from '@ohos/windowscene';
import { DeviceState } from '@ohos/launchercommon/src/main/ets/TsIndex';

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

  updateShowCompanionIconState: (isShowCompanionIcon: boolean): void => {
  }
}

export default function OnMinimizeSceneOnSpecialPanelTest() {
  // minimizeAllScene集成测试
  describe('OnMinimizeSceneOnSpecialPanel_testSuite', () => {
    const persistentId = 9234;
    let viewModel: SCBSpecialScenePanelViewModel =
      new SCBSpecialScenePanelViewModel(new SCBScreenProperty(), new SCBScreenProperty());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, persistentId);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sceneContainerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    beforeAll(() => {
      viewModel.getContainerSessionList().clear();
      viewModel.getContainerSessionList().push(sceneContainerSession);
      let sceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, 12345);
      let keyboardSession: SCBKeyboardSession = new SCBKeyboardSession(sceneSessionManager.requestSceneSession(sceneInfo),
        () => {}, keyboardChangeCallbackMap, keyboardChangeListenerList);
      viewModel.init(keyboardSession, panelStateCollectionHandler);
    })

    /**
     * 用例描述: 锁屏之上应用退后台
     * 预置条件: 存在锁屏之上containerSession
     * 测试场景: 锁屏之上应用退后台
     * 预期结果: 应用成功退后台，生命周期各状态正常
     */
    it('test_whenOnMinimizeSceneOnSpecialPanel_thenSuccess', Level.LEVEL0, () => {
      sceneContainerSession.requestActivation();
      viewModel.onMinimizeScene(persistentId);
      expect(sceneContainerSession.isActive).assertFalse();
      expect(panelStateCollectionHandler.getPanelState()).assertEqual(ScenePanelState.HOME);
      expect(sceneContainerSession.isDisappearing).assertTrue();
    });
  });
}