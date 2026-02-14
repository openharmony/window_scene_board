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
  FSM,
  FSMEvent,
  FSMState,
  FSMTransition,
  MidSceneEvents,
  SCBAppIconParam,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
} from '@ohos/windowscene';
import { MidSceneFSM } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneFSM';
import { MidSceneData,
  MidSceneExitReason,
  MidSceneStep } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneData';
import {
  SCBMidSceneCallback,
  UIConfig
} from '../../../../../main/ets/SceneBoard/scenemanager/midscene/SCBMidSceneCallback';
import { ArgumentMatchers, beforeAll, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import {ReflectionUtils} from '../ReflectionUtils';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { RecentIdle } from '../../../../../main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentIdle';
import {
  WaitingReplaceState
} from '../../../../../main/ets/SceneBoard/scenemanager/midscene/midsceneFSMState/WaitingReplaceState';

let screenProperty: SCBScreenProperty;
let waitingReplaceState: WaitingReplaceState;
let midSceneFSM : MidSceneFSM;
let primarySession: SCBSceneSession;
let sceneInfo: SCBSceneInfo;
let midsceneData: MidSceneData;
let container:SCBSceneContainerSession;
let manager:SCBScenePanelManager;
let fsm: FSM = new FSM('test');
let midsceneData0: MidSceneData
let callBack:SCBMidSceneCallback = {
  toStable(): void{},
  exitFromUnstable(reason: MidSceneExitReason): void{},
  toWaitingAdd(isInMidScene: boolean): void{},
  toWaitingReplace(): void{},
  addFromIcon(session: SCBSceneSession): void{},
  addFromOther(session: SCBSceneSession): void{},
  replaceInFilledState(session: SCBSceneSession): void{},
  toNonMidScene():void{},
  getUIConfig(): UIConfig{return new UIConfig()},
};
let initAll = () => {
  manager = SCBScenePanelManager.getInstance(screenProperty);
  waitingReplaceState = new WaitingReplaceState();
  waitingReplaceState.attachToFsm(fsm)
  screenProperty = new SCBScreenProperty();
  midsceneData0 = new MidSceneData(0);
  midsceneData = new MidSceneData(1);
  midsceneData.step = MidSceneStep.SMALL;
  sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 1, 1);
  screenProperty.width = 1;
  screenProperty.height = 1;
  primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  callBack = {
    toStable(): void{},
    exitFromUnstable(reason: MidSceneExitReason): void{},
    toWaitingAdd(isInMidScene: boolean): void{},
    toWaitingReplace(): void{},
    addFromIcon(session: SCBSceneSession): void{},
    addFromOther(session: SCBSceneSession): void{},
    replaceInFilledState(session: SCBSceneSession): void{},
    toNonMidScene():void{},
    getUIConfig(): UIConfig{return new UIConfig()},
  };
  container = new SCBSceneContainerSession(primarySession, screenProperty);
  midSceneFSM = new MidSceneFSM(container, callBack);
  container.sessionData.midSceneFSM = midSceneFSM;
  midSceneFSM.context.l2r = [midsceneData0, midsceneData];
  waitingReplaceState.attachToFsm(midSceneFSM);
}

export function WaitingReplaceStateTest() {
  describe("WaitingReplaceStateTest_001", () => {
    beforeAll((): void => {
      initAll();
    });
    WaitingReplaceState_onEnter_01();
    WaitingReplaceState_init_01();
    WaitingReplaceState_getSceneSessionFromArgs_01();
    WaitingReplaceState_handleExpandToFold_01();
    WaitingReplaceState_handleReplaceEvent_01();
    WaitingReplaceState_handleBackToLastState_01();
    WaitingReplaceState_isFilled_01();
    WaitingReplaceState_isInMidScene_01();
  });
}

function WaitingReplaceState_onEnter_01() {
  it('WaitingReplaceState_onEnter_001', Level.LEVEL0, () => {
    let FSMState1: FSMState = new RecentIdle(manager);
    let fsmEvent: FSMEvent = FSMEvent.builder(MidSceneEvents.EVENT_WINDOW_CLICK);
    waitingReplaceState.onEnter(FSMState1, fsmEvent);
    expect(true).assertTrue();
  });
}

function WaitingReplaceState_init_01() {
  it('WaitingReplaceState_init_001', Level.LEVEL0, () => {
    waitingReplaceState.init();
    let transitions: FSMTransition[] = ReflectionUtils.getProperty(waitingReplaceState, 'transitions');
    let event: FSMEvent = transitions[0].getEvent();
    expect(event.doOn([])).assertFalse();
  });
}

function WaitingReplaceState_getSceneSessionFromArgs_01() {
  it('WaitingReplaceState_getSceneSessionFromArgs_001', Level.LEVEL0, () => {
    let args: SCBSceneSession[] = [];
    waitingReplaceState.getSceneSessionFromArgs(...args);
    expect(true).assertTrue();
  });
  it('WaitingReplaceState_getSceneSessionFromArgs_002', Level.LEVEL0, () => {
    let args: SCBSceneSession[] = [primarySession];
    waitingReplaceState.getSceneSessionFromArgs(...args);
    expect(true).assertTrue();
  });
}

function WaitingReplaceState_handleReplaceEvent_01() {
  it('WaitingReplaceState_handleReplaceEvent_001', Level.LEVEL0, () => {
    let args: SCBSceneSession[] = [];
    expect(ReflectionUtils.useFunc(waitingReplaceState, 'handleReplaceEvent', ...args)).assertFalse();
  });
  it('WaitingReplaceState_handleReplaceEvent_002', Level.LEVEL0, () => {
    let session = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [session];
    midSceneFSM.context.anchorIndex = 1;
    midSceneFSM.context.toReplacedIndex = 0;
    midSceneFSM.context.l2r = [midsceneData0, midsceneData];
    midsceneData0.step = MidSceneStep.SMALL;
    expect(ReflectionUtils.useFunc(waitingReplaceState, 'handleReplaceEvent', ...args)).assertTrue();
  });
  it('WaitingReplaceState_handleReplaceEvent_003', Level.LEVEL0, () => {
    let session = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [session];
    midSceneFSM.context.anchorIndex = 0;
    midSceneFSM.context.toReplacedIndex = 0;
    midSceneFSM.context.l2r = [midsceneData0, midsceneData];
    expect(ReflectionUtils.useFunc(waitingReplaceState, 'handleReplaceEvent', ...args)).assertTrue();
  });
  it('WaitingReplaceState_handleReplaceEvent_004', Level.LEVEL0, () => {
    let session = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [session];
    midSceneFSM.context.anchorIndex = 0;
    midSceneFSM.context.toReplacedIndex = -2;
    midSceneFSM.context.l2r = [midsceneData0, midsceneData];
    expect(ReflectionUtils.useFunc(waitingReplaceState, 'handleReplaceEvent', ...args)).assertFalse();
  });
}

function WaitingReplaceState_handleExpandToFold_01() {
  it('WaitingReplaceState_handleExpandToFold_001', Level.LEVEL0, () => {
    midSceneFSM.context.l2r = [midsceneData0, midsceneData];
    midSceneFSM.context.anchorIndex = 0;
    midSceneFSM.context.anchorPosIndex = 0;
    ReflectionUtils.useFunc(waitingReplaceState, 'handleExpandToFold', ...[primarySession.session.persistentId]);
    expect((container.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex).assertEqual(0);
  });
}

function WaitingReplaceState_handleBackToLastState_01() {
  it('WaitingReplaceState_handleBackToLastState_001', Level.LEVEL0, () => {
    let session = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [session];
    midSceneFSM.context.anchorIndex = 0;
    midSceneFSM.context.toReplacedIndex = 0;
    midSceneFSM.context.l2r = [midsceneData0, midsceneData];
    midsceneData0.step = MidSceneStep.LARGE;

    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
      SCBSceneSessionManager.getInstance().getSessionById);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(session);
    expect(ReflectionUtils.useFunc(waitingReplaceState, 'handleBackToLastState')).assertTrue();
    mocker.clear(SCBSceneSessionManager.getInstance());
  });
  it('WaitingReplaceState_handleBackToLastState_002', Level.LEVEL0, () => {
    let session = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [session];
    midSceneFSM.context.anchorIndex = 0;
    midSceneFSM.context.toReplacedIndex = -2;
    midSceneFSM.context.l2r = [midsceneData0, midsceneData];
    expect(ReflectionUtils.useFunc(waitingReplaceState, 'handleBackToLastState')).assertFalse();
  });
}

function WaitingReplaceState_isFilled_01() {
  it('WaitingReplaceState_isFilled_001', Level.LEVEL0, () => {
    midSceneFSM.context.anchorIndex = 0;
    midSceneFSM.context.toReplacedIndex = 0;
    midSceneFSM.context.l2r = [midsceneData0, midsceneData];
    expect(ReflectionUtils.useFunc(waitingReplaceState, 'isFilled')).assertFalse();
  });
  it('WaitingReplaceState_isFilled_002', Level.LEVEL0, () => {
    midSceneFSM.context.anchorIndex = 0;
    midSceneFSM.context.toReplacedIndex = 0;
    midSceneFSM.context.l2r = [midsceneData0, midsceneData, midsceneData];
    expect(ReflectionUtils.useFunc(waitingReplaceState, 'isFilled')).assertTrue();
  });
  it('WaitingReplaceState_isFilled_003', Level.LEVEL0, () => {
    let session = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    midSceneFSM.context.anchorIndex = 0;
    midSceneFSM.context.toReplacedIndex = -2;
    midSceneFSM.context.l2r = [midsceneData0, midsceneData];
    expect(ReflectionUtils.useFunc(waitingReplaceState, 'isFilled')).assertFalse();
  });
}

function WaitingReplaceState_isInMidScene_01() {
  it('WaitingReplaceState_isInMidScene_001', Level.LEVEL0, () => {
    let args: SCBSceneSession[] = [];
    midSceneFSM.context.anchorIndex = 0;
    midSceneFSM.context.toReplacedIndex = -2;
    midSceneFSM.context.l2r = [midsceneData0, midsceneData];
    expect(ReflectionUtils.useFunc(waitingReplaceState, 'isInMidScene', ...args)).assertFalse();
  });
  it('WaitingReplaceState_isInMidScene_002', Level.LEVEL0, () => {
    let session = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [session];
    midSceneFSM.context.anchorIndex = 0;
    midSceneFSM.context.toReplacedIndex = 0;
    midSceneFSM.context.l2r = [midsceneData0, midsceneData];
    container.midSceneMap.set(1, primarySession)
    expect(ReflectionUtils.useFunc(waitingReplaceState, 'isInMidScene', ...args)).assertTrue();
  });
  it('WaitingReplaceState_isInMidScene_003', Level.LEVEL0, () => {
    let session = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [session];
    midSceneFSM.context.anchorIndex = 0;
    midSceneFSM.context.toReplacedIndex = 0;
    midSceneFSM.context.l2r = [midsceneData0, midsceneData];
    container.midSceneMap.clear();
    container.midSceneMap.set(3, primarySession);
    expect(ReflectionUtils.useFunc(waitingReplaceState, 'isInMidScene', ...args)).assertFalse();
  });
}



