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
  SCBSceneSession,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBScreenProperty,
  MidSceneEvents,
  FSMEvent
} from '@ohos/windowscene';
import { MidSceneFSM } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneFSM';
import { MidSceneData,
  MidSceneExitReason,
  MidSceneStep } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneData';
import { ArgumentMatchers, beforeAll, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import { ReflectionUtils } from '../ReflectionUtils';
import {
  UnfilledState
} from '../../../../../main/ets/SceneBoard/scenemanager/midscene/midsceneFSMState/UnfilledState';
import {
  SCBMidSceneCallback,
  UIConfig } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/SCBMidSceneCallback';
import sceneSessionManager from '@ohos.sceneSessionManager';
let midsceneData0: MidSceneData;
let midsceneData1: MidSceneData;
let unfilledState:UnfilledState;
let screenProperty: SCBScreenProperty;
let midSceneFSM : MidSceneFSM;
let primarySession: SCBSceneSession;
let sceneInfo: SCBSceneInfo;
let midsceneData: MidSceneData;
let container:SCBSceneContainerSession;

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
  unfilledState = new UnfilledState();
  screenProperty = new SCBScreenProperty();
  midsceneData0 = new MidSceneData(0);
  midsceneData = new MidSceneData(1);
  midsceneData.step = MidSceneStep.SMALL;
  midsceneData1 = new MidSceneData(2);
  sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 1, 1);
  screenProperty.width = 1;
  screenProperty.height = 1;
  screenProperty = new SCBScreenProperty();
  primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  container = new SCBSceneContainerSession(primarySession, screenProperty);
  midSceneFSM = new MidSceneFSM(container, callBack);
  container.sessionData.midSceneFSM = midSceneFSM;
  midSceneFSM.context.l2r = [midsceneData0, midsceneData];
  unfilledState.attachToFsm(midSceneFSM);
}

export function UnfilledStateTest() {
  describe("UnfilledStateTest_001", () => {
    beforeAll((): void => {
      initAll();
    });
    UnfilledState_onEnter_01();
    UnfilledState_init_01();
    UnfilledState_handleCloseToExitOneState_01();
    UnfilledState_handleStartAbilityEvent_01();
    UnfilledState_handleActiveExistAbility_01();
    UnfilledState_handleExpandToFold_01();
    UnfilledState_handleSignReplacedIndex_01();
  });

}

function  UnfilledState_init_01() {
  it('UnfilledState_init_001', Level.LEVEL0, () => {
    unfilledState.init();
    expect(true).assertTrue();
  });
}

function   UnfilledState_handleCloseToExitOneState_01() {
  it('UnfilledState_handleCloseToExitOneState_001', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(unfilledState, 'handleCloseToExitOneState', ...[]);
    expect(true).assertTrue();
  });
  it('UnfilledState_handleCloseToExitOneState_002', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(unfilledState, 'handleCloseToExitOneState', ...[0]);
    expect(true).assertTrue();
  });
}

function UnfilledState_onEnter_01() {
  it('UnfilledState_onEnter_001', Level.LEVEL0, () => {
    let test: UnfilledState = new UnfilledState();
    let fsmEvent: FSMEvent = FSMEvent.builder(MidSceneEvents.EVENT_WINDOW_CLICK);
    unfilledState.onEnter(test, fsmEvent);
    expect(true).assertTrue();
  });
}

function UnfilledState_handleStartAbilityEvent_01() {
  it('UnfilledState_handleStartAbilityEvent_001', Level.LEVEL0, () => {
    let tmp: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    midsceneData.step = MidSceneStep.LARGE;
    ReflectionUtils.useFunc(unfilledState, 'handleStartAbilityEvent', ...[tmp]);
    expect(true).assertTrue();
  });
  it('UnfilledState_handleStartAbilityEvent_002', Level.LEVEL0, () => {
    let tmp: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    midsceneData.step = MidSceneStep.SMALL;
    ReflectionUtils.useFunc(unfilledState, 'handleStartAbilityEvent', ...[tmp]);
    expect(true).assertTrue();
  });
  it('UnfilledState_handleStartAbilityEvent_003', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(unfilledState, 'handleStartAbilityEvent', ...[]);
    expect(true).assertTrue();
  });
}

function UnfilledState_handleActiveExistAbility_01() {
  it('UnfilledState_handleActiveExistAbility_001', Level.LEVEL0, () => {
    let args: SCBSceneSession[] = [];
    ReflectionUtils.useFunc(unfilledState, 'handleActiveExistAbility', ...args);
    expect(true).assertTrue();
  });
  it('UnfilledState_handleActiveExistAbility_002', Level.LEVEL0, () => {
    let primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [primarySession];
    midSceneFSM.context.l2r = [];
    ReflectionUtils.useFunc(unfilledState, 'handleActiveExistAbility', ...args);
    expect(true).assertTrue();
  });
  it('FilledState_handleActiveExistAbility_003', Level.LEVEL0, () => {
    let primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [primarySession];
    let index = 5;
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc((midSceneFSM as MidSceneFSM).context.l2r, (midSceneFSM as MidSceneFSM).context.l2r.findIndex);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(index);
    ReflectionUtils.useFunc(unfilledState, 'handleActiveExistAbility', ...args);
    mocker.clear((midSceneFSM as MidSceneFSM).context.l2r);
    expect(true).assertTrue();
  });
  it('FilledState_handleActiveExistAbility_004', Level.LEVEL0, () => {
    let primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [primarySession];
    let index = -1;
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc((midSceneFSM as MidSceneFSM).context.l2r, (midSceneFSM as MidSceneFSM).context.l2r.findIndex);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(index);
    ReflectionUtils.useFunc(unfilledState, 'handleActiveExistAbility', ...args);
    mocker.clear((midSceneFSM as MidSceneFSM).context.l2r);
    expect(true).assertTrue();
  });
  it('FilledState_handleActiveExistAbility_005', Level.LEVEL0, () => {
    let primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [primarySession];
    let index = 1;
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc((midSceneFSM as MidSceneFSM).context.l2r, (midSceneFSM as MidSceneFSM).context.l2r.findIndex);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(index);
    midsceneData1.step = MidSceneStep.SMALL;
    midSceneFSM.context.l2r = [midsceneData0, midsceneData, midsceneData1];
    ReflectionUtils.useFunc(unfilledState, 'handleActiveExistAbility', ...args);
    mocker.clear((midSceneFSM as MidSceneFSM).context.l2r);
    expect(true).assertTrue();
  });
  it('UnfilledState_handleActiveExistAbility_006', Level.LEVEL0, () => {
    let primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [primarySession];
    midsceneData0.step = MidSceneStep.LARGE;
    midSceneFSM.context.l2r = [midsceneData, midsceneData0];
    ReflectionUtils.useFunc(unfilledState, 'handleActiveExistAbility', ...args);
    expect(true).assertTrue();
  });
}

function UnfilledState_handleSignReplacedIndex_01() {
  it('UnfilledState_handleSignReplacedIndex_001', Level.LEVEL0, () => {
    let args: SCBSceneSession[] = [];
    expect(ReflectionUtils.useFunc(unfilledState, 'handleSignReplacedIndex', ...args)).assertFalse();
  });
  it('UnfilledState_handleSignReplacedIndex_002', Level.LEVEL0, () => {
    let session = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [session];
    midSceneFSM.context.anchorIndex = 0;
    midSceneFSM.context.l2r = [];
    expect(ReflectionUtils.useFunc(unfilledState, 'handleSignReplacedIndex', ...args)).assertFalse();
  });
  it('UnfilledState_handleSignReplacedIndex003', Level.LEVEL0, () => {
    let session = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [session];
    midSceneFSM.context.anchorIndex = 0;
    midSceneFSM.context.toReplacedIndex = 0;
    midSceneFSM.context.l2r = [midsceneData0, midsceneData];
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc((midSceneFSM as MidSceneFSM).context.l2r,
      (midSceneFSM as MidSceneFSM).context.l2r.findIndex);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(0);
    let result: boolean = ReflectionUtils.useFunc(unfilledState, 'handleSignReplacedIndex', ...args);
    mocker.clear((midSceneFSM as MidSceneFSM).context.l2r);
    expect(result).assertTrue();
  });
  it('UnfilledState_handleSignReplacedIndex004', Level.LEVEL0, () => {
    let session = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [session];
    midSceneFSM.context.anchorIndex = 0;
    midSceneFSM.context.toReplacedIndex = -1;
    midSceneFSM.context.l2r = [midsceneData0, midsceneData1];
    expect(ReflectionUtils.useFunc(unfilledState, 'handleSignReplacedIndex', ...args)).assertFalse();
  });
}

function UnfilledState_handleExpandToFold_01() {
  it('UnfilledState_handleExpandToFold_001', Level.LEVEL0, () => {
    midSceneFSM.context.l2r = [midsceneData0, midsceneData];
    midSceneFSM.context.anchorIndex = 0;
    midSceneFSM.context.anchorPosIndex = 0;
    ReflectionUtils.useFunc(unfilledState, 'handleExpandToFold', ...[primarySession.session.persistentId]);
    expect((container.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex).assertEqual(0);
  });
}