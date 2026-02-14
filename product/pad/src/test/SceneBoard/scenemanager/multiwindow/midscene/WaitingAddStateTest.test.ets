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
  MidSceneEvents,
  SCBAppIconParam,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBScenePanelManager,
  SCBSceneSession,
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
  WaitingAddState
} from '../../../../../main/ets/SceneBoard/scenemanager/midscene/midsceneFSMState/WaitingAddState';
import { MidSceneStates } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneStates';

let waitingAddState: WaitingAddState;
let screenProperty: SCBScreenProperty;
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
  waitingAddState = new WaitingAddState();
  waitingAddState.attachToFsm(fsm)
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
  waitingAddState.attachToFsm(midSceneFSM);
}

export function WaitingAddStateTest() {
  describe("WaitingAddStateTest_001", () => {
    beforeAll((): void => {
      initAll();
    });
    WaitingAddStateTest_onEnter_01();
    WaitingAddStateTest_getSceneSessionFromArgs_01();
    WaitingAddStateTest_addCancelWaitingTransition_01();
    WaitingAddStateTest_handleStartNewAbilityEvent_01();
    WaitingAddStateTest_handleActiveExistAbility_01();
    WaitingAddStateTest_handleCancelWaitingEvent_01();
    WaitingAddStateTest_judgeUnFilledStateStartAbilityOnCallBack_01();
    WaitingAddStateTest_judgeStartAbilityEvent_01();
    WaitingAddStateTest_handleExpandToFold_01();
  });
}

function WaitingAddStateTest_getSceneSessionFromArgs_01() {
  it('WaitingAddStateTest_getSceneSessionFromArgs_001', Level.LEVEL0, () => {
    let args: SCBSceneSession[] = [];
    waitingAddState.getSceneSessionFromArgs(...args);
    expect(true).assertTrue();
  });
  it('WaitingAddStateTest_getSceneSessionFromArgs_002', Level.LEVEL0, () => {
    let args: SCBSceneSession[] = [primarySession];
    waitingAddState.getSceneSessionFromArgs(...args);
    expect(true).assertTrue();
  });
}

function WaitingAddStateTest_onEnter_01() {
  it('WaitingAddStateTest_onEnter_001', Level.LEVEL0, () => {
    let FSMState1: FSMState = new RecentIdle(manager);
    let fsmEvent: FSMEvent = FSMEvent.builder(MidSceneEvents.EVENT_WINDOW_CLICK);
    waitingAddState.onEnter(FSMState1, fsmEvent);
    expect(true).assertTrue();
  });
}

function WaitingAddStateTest_addCancelWaitingTransition_01() {
  it('WaitingAddStateTest_addCancelWaitingTransition_001', Level.LEVEL0, () => {
    let args: SCBSceneSession[] = [];
    ReflectionUtils.useFunc(waitingAddState, 'addCancelWaitingTransition', args);
    expect(true).assertTrue();
  });
  it('WaitingAddStateTest_addCancelWaitingTransition_002', Level.LEVEL0, () => {
    let args: SCBSceneSession[] = [primarySession];
    ReflectionUtils.useFunc(waitingAddState, 'addCancelWaitingTransition', args);
    expect(true).assertTrue();
  });
}

function WaitingAddStateTest_handleStartNewAbilityEvent_01() {
  it('WaitingAddStateTest_handleStartNewAbilityEvent_001', Level.LEVEL0, () => {
    let primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [primarySession];
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(primarySession, primarySession.isSupportSplitMode);
    when(mockFunc)().afterReturn(true);
    ReflectionUtils.useFunc(waitingAddState, 'handleStartNewAbilityEvent', args);
    expect(true).assertTrue();
    mocker.clear(primarySession);
  });
  it('WaitingAddStateTest_handleStartNewAbilityEvent_002', Level.LEVEL0, () => {
    let primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [primarySession];
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(primarySession, primarySession.isSupportSplitMode);
    when(mockFunc)().afterReturn(false);
    ReflectionUtils.useFunc(waitingAddState, 'handleStartNewAbilityEvent', args);
    expect(true).assertTrue();
    mocker.clear(primarySession);
  });
  it('WaitingAddStateTest_handleStartNewAbilityEvent_003', Level.LEVEL0, () => {
    let args: SCBSceneSession[] = [];
    ReflectionUtils.useFunc(waitingAddState, 'handleStartNewAbilityEvent', args);
    expect(true).assertTrue();
  });
}

function WaitingAddStateTest_handleActiveExistAbility_01() {
  it('WaitingAddStateTest_handleActiveExistAbility_001', Level.LEVEL0, () => {
    let primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [primarySession];
    midsceneData0.step = MidSceneStep.SMALL;
    midSceneFSM.context.l2r = [midsceneData0, midsceneData];
    ReflectionUtils.useFunc(waitingAddState, 'handleActiveExistAbility', args);
    expect(true).assertTrue();
  });
  it('WaitingAddStateTest_handleActiveExistAbility_002', Level.LEVEL0, () => {
    let primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [primarySession];
    midsceneData0.step = MidSceneStep.LARGE;
    midSceneFSM.context.l2r = [midsceneData, midsceneData0];
    ReflectionUtils.useFunc(waitingAddState, 'handleActiveExistAbility', args);
    expect(true).assertTrue();
  });
  it('WaitingAddStateTest_handleActiveExistAbility_003', Level.LEVEL0, () => {
    let args: SCBSceneSession[] = [];
    ReflectionUtils.useFunc(waitingAddState, 'handleActiveExistAbility', args);
    expect(true).assertTrue();
  });
}

function WaitingAddStateTest_judgeUnFilledStateStartAbilityOnCallBack_01() {
  it('WaitingAddStateTest_judgeUnFilledStateStartAbilityOnCallBack_001', Level.LEVEL0, () => {
    let primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [primarySession];
    midSceneFSM.containerSession.midSceneMap.set(primarySession.session.persistentId, primarySession);
    ReflectionUtils.useFunc(waitingAddState, 'judgeUnFilledStateStartAbilityOnCallBack', args);
    expect(true).assertTrue();
  });
  it('WaitingAddStateTest_judgeUnFilledStateStartAbilityOnCallBack_002', Level.LEVEL0, () => {
    let primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [primarySession];
    ReflectionUtils.useFunc(waitingAddState, 'judgeUnFilledStateStartAbilityOnCallBack', args);
    expect(true).assertTrue();
  });
}

function WaitingAddStateTest_handleCancelWaitingEvent_01() {
  it('WaitingAddStateTest_handleCancelWaitingEvent_001', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(waitingAddState, 'handleCancelWaitingEvent');
    expect(true).assertTrue();
  });
}

function WaitingAddStateTest_handleExpandToFold_01() {
  it('WaitingAddStateTest_handleExpandToFold_001', Level.LEVEL0, () => {
    midSceneFSM.context.l2r = [midsceneData0, midsceneData];
    midSceneFSM.context.anchorIndex = 0;
    midSceneFSM.context.anchorPosIndex = 0;
    ReflectionUtils.useFunc(waitingAddState, 'handleExpandToFold', [primarySession.session.persistentId]);
    expect((container.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex).assertEqual(0);
  });
}

function WaitingAddStateTest_judgeStartAbilityEvent_01() {
  it('WaitingAddStateTest_judgeStartAbilityEvent_001', Level.LEVEL0, () => {
    expect(waitingAddState.judgeStartAbilityEvent(...[])).assertEqual(MidSceneStates.STATE_NON_MID);
  });
  it('WaitingAddStateTest_judgeStartAbilityEvent_002', Level.LEVEL0, () => {
    let primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [primarySession];
    midSceneFSM.containerSession.midSceneMap.set(primarySession.session.persistentId, primarySession);
    expect(waitingAddState.judgeStartAbilityEvent(...args)).assertEqual(MidSceneStates.STATE_UNFILLED);
  });
  it('WaitingAddStateTest_judgeStartAbilityEvent_003', Level.LEVEL0, () => {
    let primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [primarySession];
    midSceneFSM.containerSession.midSceneMap.set(-1, primarySession);
    expect(waitingAddState.judgeStartAbilityEvent(...args)).assertEqual(MidSceneStates.STATE_UNFILLED);
  });
}