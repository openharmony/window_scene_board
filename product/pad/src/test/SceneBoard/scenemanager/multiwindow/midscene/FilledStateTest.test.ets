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
  FSM,
  FSMEvent,
  FSMState,
  FSMTransition,
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
  FilledState
} from '../../../../../main/ets/SceneBoard/scenemanager/midscene/midsceneFSMState/FilledState';
import {
  SCBMidSceneCallback,
  UIConfig
} from '../../../../../main/ets/SceneBoard/scenemanager/midscene/SCBMidSceneCallback';
import { RecentIdle } from '../../../../../main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentIdle';
import { ArgumentMatchers, beforeAll, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import {ReflectionUtils} from '../ReflectionUtils';
import sceneSessionManager from '@ohos.sceneSessionManager';

let filledState: FilledState;
let screenProperty: SCBScreenProperty;
let midSceneFSM : MidSceneFSM;
let primarySession: SCBSceneSession;
let oldSession: SCBSceneSession;
let container:SCBSceneContainerSession;
let manager:SCBScenePanelManager;
let sceneInfo: SCBSceneInfo;
let sceneInfo0: SCBSceneInfo;
let midsceneData: MidSceneData;
let fsm: FSM = new FSM('test');
let uiFonfig: UIConfig = {
  allWidth: 1,
  margin: 0.5,
  gutter: 0.5,
  anchorPos: [0.5,0.2]
}
let midsceneData0: MidSceneData;
let midsceneData1: MidSceneData;
let filledState1: FilledState;
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
  filledState = new FilledState();

  screenProperty = new SCBScreenProperty();
  midsceneData0 = new MidSceneData(0);
  midsceneData = new MidSceneData(1);
  midsceneData.step = MidSceneStep.SMALL;
  midsceneData1 = new MidSceneData(2);
  sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 1, 1);
  sceneInfo0 = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 0);
  screenProperty.width = 1;
  screenProperty.height = 1;
  primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  oldSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo0), sceneInfo0);
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
  midSceneFSM.context.l2r = [midsceneData0, midsceneData];
  filledState.attachToFsm(midSceneFSM);
  filledState1 = new FilledState();
  filledState1.attachToFsm(midSceneFSM);
}

export function FilledStateTest() {
  describe("FilledStateTest_001", () => {
    beforeAll((): void => {
      initAll();
    });
    FilledState_init_01();
    FilledState_onEnter_01();
    FilledState_handleCloseToUnstableState_01();
    FilledState_handleCloseToUnfilledState_01();
    FilledState_handleReplaceEvent_01();
    FilledState_replaceSceneParam_01();
    FilledState_replaceIconParam_01();
    FilledState_createIconParam_01();
    FilledState_handleActiveExistAbility_01();
    FilledState_handleSignReplacedIndex_01();
  });

}
function FilledState_init_01(){
  it('FilledState_init_001', Level.LEVEL0, () => {
    let transitions: FSMTransition[] = ReflectionUtils.getProperty(filledState1, 'transitions');
    let event: FSMEvent = transitions[0].getEvent();
    event.doOn([-1]);
    expect(true).assertTrue();
  });
  it('FilledState_init_002', Level.LEVEL0, () => {
    filledState1.init();
    let transitions: FSMTransition[] = ReflectionUtils.getProperty(filledState1, 'transitions');
    let event: FSMEvent = transitions[0].getEvent();
    event.doOn([]);
    expect(true).assertTrue();
  });
  it('FilledState_init_003', Level.LEVEL0, () => {
    midSceneFSM.context.anchorIndex = 1;
    filledState1.attachToFsm(midSceneFSM);
    let mocker: MockKit = new MockKit();
    let mockfunc1: Function = mocker.mockFunc((filledState1.myFsm as MidSceneFSM).containerCallback, (filledState1.myFsm as MidSceneFSM).containerCallback.getUIConfig);
    when(mockfunc1)(ArgumentMatchers.any).afterReturn(uiFonfig);
    let transitions: FSMTransition[] = ReflectionUtils.getProperty(filledState1, 'transitions');
    let event: FSMEvent = transitions[0].getEvent();
    event.doOn([1]);
    expect(true).assertTrue();
    mocker.clear((filledState1.myFsm as MidSceneFSM).containerCallback);
  });
  it('FilledState_init_004', Level.LEVEL0, () => {
    let mocker: MockKit = new MockKit();
    let mockfunc1: Function = mocker.mockFunc((filledState1.myFsm as MidSceneFSM).containerCallback, (filledState1.myFsm as MidSceneFSM).containerCallback.getUIConfig);
    when(mockfunc1)(ArgumentMatchers.any).afterReturn(uiFonfig);
    midSceneFSM.context.anchorIndex = 0;
    filledState1.attachToFsm(midSceneFSM);
    let transitions: FSMTransition[] = ReflectionUtils.getProperty(filledState1, 'transitions');
    let event: FSMEvent = transitions[0].getEvent();
    event.doOn([1]);
    expect(true).assertTrue();
    mocker.clear((filledState1.myFsm as MidSceneFSM).containerCallback);
  });
}
function FilledState_onEnter_01() {
  it('FilledState_onEnter_001', Level.LEVEL0, () => {
    let FSMState1: FSMState = new RecentIdle(manager);
    filledState.onEnter(FSMState1);
    expect(true).assertTrue();
  });
}
function FilledState_handleCloseToUnstableState_01() {
  it('FilledState_handleCloseToUnstableState_001', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(filledState, 'handleCloseToUnstableState', [1]);
    expect(true).assertTrue();
  });
  it('FilledState_handleCloseToUnstableState_002', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(filledState, 'handleCloseToUnstableState', []);
    expect(true).assertTrue();
  });
}

function FilledState_handleCloseToUnfilledState_01() {
  it('FilledState_handleCloseToUnfilledState_001', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(filledState, 'handleCloseToUnfilledState', [-1]);
    expect(true).assertTrue();
  });
  it('FilledState_handleCloseToUnfilledState_002', Level.LEVEL0, () => {
    midsceneData0.step = MidSceneStep.SMALL;
    midsceneData0.left = 0;
    midSceneFSM.context.anchorIndex = 0;
    ReflectionUtils.useFunc(filledState, 'handleCloseToUnfilledState', [1]);
    expect(true).assertTrue();
  });
  it('FilledState_handleCloseToUnfilledState_003', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(filledState, 'handleCloseToUnfilledState', []);
    expect(true).assertTrue();
  });
  it('FilledState_handleCloseToUnfilledState_004', Level.LEVEL0, () => {
    midsceneData0.step = MidSceneStep.LARGE;
    midSceneFSM.context.anchorIndex = 0;
    ReflectionUtils.useFunc(filledState, 'handleCloseToUnfilledState', [1]);
    expect(true).assertTrue();
  });
  it('FilledState_handleCloseToUnfilledState_005', Level.LEVEL0, () => {
    midsceneData0.step = MidSceneStep.LARGE;
    midSceneFSM.context.anchorIndex = 2;
    ReflectionUtils.useFunc(filledState, 'handleCloseToUnfilledState', [1]);
    expect(true).assertTrue();
  });
  it('FilledState_handleCloseToUnfilledState_006', Level.LEVEL0, () => {
    midsceneData0.step = MidSceneStep.SMALL;
    midsceneData0.left = container.screenProperty.width;
    midSceneFSM.context.anchorIndex = midSceneFSM.context.l2r.length - 1;
    ReflectionUtils.useFunc(filledState, 'handleCloseToUnfilledState', [1]);
    expect(true).assertTrue();
  });
}

function FilledState_handleReplaceEvent_01() {
  it('FilledState_handleReplaceEvent_001', Level.LEVEL0, () => {
    midSceneFSM.context.l2r = [midsceneData0, midsceneData];
    midSceneFSM.context.anchorIndex = 0;
    ReflectionUtils.useFunc(filledState, 'handleReplaceEvent', [primarySession]);
    expect(true).assertTrue();
  });
  it('FilledState_handleReplaceEvent_002', Level.LEVEL0, () => {
    midSceneFSM.context.l2r = [midsceneData0, midsceneData];
    midSceneFSM.context.anchorIndex = 0;
    midSceneFSM.context.toReplacedIndex = 0;
    expect(ReflectionUtils.useFunc(filledState, 'handleReplaceEvent', [primarySession, oldSession])).assertTrue();
  });
  it('FilledState_handleReplaceEvent_003', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(filledState, 'handleReplaceEvent', []);
    expect(true).assertTrue();
  });
}


function FilledState_replaceSceneParam_01() {
  it('FilledState_replaceSceneParam_001', Level.LEVEL0, () => {
    midSceneFSM.context.l2r = [midsceneData0, midsceneData];
    midSceneFSM.context.anchorIndex = 0;
    midsceneData0.step = MidSceneStep.LARGE;
    let mocker: MockKit = new MockKit();
    let mockfunc1: Function = mocker.mockFunc(primarySession, primarySession.isSupportSplitMode);
    when(mockfunc1)(ArgumentMatchers.any).afterReturn(true);
    ReflectionUtils.useFunc(filledState, 'replaceSceneParam', primarySession, primarySession);
    expect(true).assertTrue();
    mocker.clear(primarySession);
  });
  it('FilledState_replaceSceneParam_002', Level.LEVEL0, () => {
    midSceneFSM.context.l2r = [midsceneData0, midsceneData];
    midSceneFSM.context.anchorIndex = 0;
    midsceneData0.step = MidSceneStep.SMALL;
    ReflectionUtils.useFunc(filledState, 'replaceSceneParam', primarySession, primarySession);
    let replacedIndex = midSceneFSM.context.l2r.findIndex(item => item.persistentId === primarySession.session.persistentId)
    expect(replacedIndex).assertEqual(midSceneFSM.context.anchorIndex);
  });
  it('FilledState_replaceSceneParam_003', Level.LEVEL0, () => {
    midSceneFSM.context.l2r = [midsceneData0, midsceneData];
    midSceneFSM.context.anchorIndex = 0;
    midsceneData0.step = MidSceneStep.SMALL;
    ReflectionUtils.useFunc(filledState, 'replaceSceneParam', primarySession, primarySession);
    expect(true).assertTrue();
  });
}

function FilledState_replaceIconParam_01() {
  it('FilledState_replaceIconParam_001', Level.LEVEL0, () => {
    container.midAppIconParamMap.set(primarySession.session.persistentId, new SCBAppIconParam(() => primarySession));
    ReflectionUtils.useFunc(filledState, 'replaceIconParam', primarySession, primarySession);
    expect(true).assertTrue();
  });
  it('FilledState_replaceIconParam_002', Level.LEVEL0, () => {
    let sceneInfo1: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 1, -1);
    let oldsession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
    container.midAppIconParamMap.set(primarySession.session.persistentId, new SCBAppIconParam(() => primarySession));
    ReflectionUtils.useFunc(filledState, 'replaceIconParam', oldsession, primarySession);
    expect(true).assertTrue();
  });
  it('FilledState_replaceIconParam_003', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(filledState, 'replaceIconParam', primarySession, primarySession);
    expect(true).assertTrue();
  });
}

function FilledState_createIconParam_01() {
  it('FilledState_createIconParam_001', Level.LEVEL0, () => {
    sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 1, 1);
    ReflectionUtils.useFunc(filledState, 'createIconParam', primarySession, container);
    expect(true).assertTrue();
  });
}

function FilledState_handleActiveExistAbility_01() {
  it('FilledState_handleActiveExistAbility_001', Level.LEVEL0, () => {
    let primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [primarySession];
    midSceneFSM.context.l2r = [];
    ReflectionUtils.useFunc(filledState, 'handleActiveExistAbility', args);
    expect(true).assertTrue();
  });
  it('FilledState_handleActiveExistAbility_002', Level.LEVEL0, () => {
    let primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [primarySession];
    let index = -1;
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc((midSceneFSM as MidSceneFSM).context.l2r, (midSceneFSM as MidSceneFSM).context.l2r.findIndex);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(index);
    ReflectionUtils.useFunc(filledState, 'handleActiveExistAbility', args);
    mocker.clear((midSceneFSM as MidSceneFSM).context.l2r);
    expect(true).assertTrue();
  });
  it('FilledState_handleActiveExistAbility_003', Level.LEVEL0, () => {
    let args: SCBSceneSession[] = [];
    ReflectionUtils.useFunc(filledState, 'handleActiveExistAbility', args);
    expect(true).assertTrue();
  });
  it('FilledState_handleActiveExistAbility_004', Level.LEVEL0, () => {
    let primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [primarySession];
    let index = 2;
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc((midSceneFSM as MidSceneFSM).context.l2r, (midSceneFSM as MidSceneFSM).context.l2r.findIndex);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(index);
    midsceneData1.step = MidSceneStep.SMALL;
    midSceneFSM.context.l2r = [midsceneData0, midsceneData, midsceneData1];
    ReflectionUtils.useFunc(filledState, 'handleActiveExistAbility', args);
    mocker.clear((midSceneFSM as MidSceneFSM).context.l2r);
    expect(true).assertTrue();
  });
  it('FilledState_handleActiveExistAbility_005', Level.LEVEL0, () => {
    let primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [primarySession];
    midsceneData1.step = MidSceneStep.LARGE;
    midSceneFSM.context.l2r = [midsceneData, midsceneData0, midsceneData1];
    ReflectionUtils.useFunc(filledState, 'handleActiveExistAbility', args);
    expect(true).assertTrue();
  });
  it('FilledState_handleActiveExistAbility_006', Level.LEVEL0, () => {
    let primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [primarySession];
    let index = 5;
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc((midSceneFSM as MidSceneFSM).context.l2r, (midSceneFSM as MidSceneFSM).context.l2r.findIndex);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(index);
    ReflectionUtils.useFunc(filledState, 'handleActiveExistAbility', args);
    mocker.clear((midSceneFSM as MidSceneFSM).context.l2r);
    expect(true).assertTrue();
  });
}

function FilledState_handleSignReplacedIndex_01() {
  it('FilledState_handleSignReplacedIndex_001', Level.LEVEL0, () => {
    let session = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [session];
    midSceneFSM.context.anchorIndex = 0;
    midSceneFSM.context.l2r = [];
    expect(ReflectionUtils.useFunc(filledState, 'handleSignReplacedIndex', args)).assertFalse();
  });
  it('FilledState_handleSignReplacedIndex002', Level.LEVEL0, () => {
    let session = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [session];
    midSceneFSM.context.anchorIndex = 0;
    midSceneFSM.context.toReplacedIndex = -1;
    midSceneFSM.context.l2r = [midsceneData0, midsceneData1];
    expect(ReflectionUtils.useFunc(filledState, 'handleSignReplacedIndex', args)).assertFalse();
  });
  it('FilledState_handleSignReplacedIndex_003', Level.LEVEL0, () => {
    let args: SCBSceneSession[] = [];
    expect(ReflectionUtils.useFunc(filledState, 'handleSignReplacedIndex', args)).assertFalse();
  });
  it('FilledState_handleSignReplacedIndex004', Level.LEVEL0, () => {
    let session = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let args: SCBSceneSession[] = [session];
    midSceneFSM.context.anchorIndex = 0;
    midSceneFSM.context.toReplacedIndex = 0;
    midSceneFSM.context.l2r = [midsceneData0, midsceneData];
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc((midSceneFSM as MidSceneFSM).context.l2r,
      (midSceneFSM as MidSceneFSM).context.l2r.findIndex);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(0);
    let result: boolean = ReflectionUtils.useFunc(filledState, 'handleSignReplacedIndex', args);
    mocker.clear((midSceneFSM as MidSceneFSM).context.l2r);
    expect(result).assertTrue();
  });
}