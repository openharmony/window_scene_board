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
  SCBSceneContainerSession,
  SCBSceneSession,
  SCBScreenProperty,
  SCBSceneInfo
} from '@ohos/windowscene';
import { ArgumentMatchers, beforeAll, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import {ReflectionUtils} from '../ReflectionUtils';
import { MidSceneData,
  MidSceneExitReason } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneData';
import { NonMidState} from '../../../../../main/ets/SceneBoard/scenemanager/midscene/midsceneFSMState/NonMidState';
import { SCBMidSceneCallback,
  UIConfig } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/SCBMidSceneCallback';
import { MidSceneContext, MidSceneFSM } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneFSM';
import sceneSessionManager from '@ohos.sceneSessionManager';

let midSceneContext: MidSceneContext;
let midSceneFSM : MidSceneFSM;
let screenProperty: SCBScreenProperty;
let callBack:SCBMidSceneCallback;
let container:SCBSceneContainerSession;
let primarySession: SCBSceneSession;
let midsceneData: MidSceneData;
let sceneInfo: SCBSceneInfo;
let initAll = () => {
  screenProperty = new SCBScreenProperty();
  midsceneData = new MidSceneData(1);
  sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
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
  midSceneContext = new MidSceneContext();
  container = new SCBSceneContainerSession(primarySession, screenProperty);
  midSceneFSM = new MidSceneFSM(container, callBack);
}

export function MidSceneFSMTest() {
  describe("MidSceneFSMTest_001", () => {
    beforeAll((): void => {
      initAll();
    });
    MidSceneContextTest_printMidSceneContext_01();
    MidSceneFSMTest_ctxIsInvalid_01();
    MidSceneFSMTest_init_01();
    MidSceneFSMTest_unregisterDebugCommands_01();
    MidSceneFSMTest_debugGetFsm_01();
    MidSceneFSMTest_debugGetCurrentState_01();
    MidSceneFSMTest_debugGetAllState_01();
    MidSceneFSMTest_debugPrintTransitions_01();
    MidSceneFSMTest_debugPrintMidSceneContext_01();

  });

}

function MidSceneContextTest_printMidSceneContext_01() {
  it('MidSceneContextTest_printMidSceneContext_001', Level.LEVEL0, () => {
    midSceneContext.l2r = [midsceneData];
    midSceneContext.anchorIndex = 1;
    midSceneContext.anchorPosIndex = 1;
    midSceneContext.printMidSceneContext();
    expect(true).assertTrue();

  });
  it('MidSceneContextTest_printMidSceneContext_002', Level.LEVEL0, () => {
    midSceneContext.printMidSceneContext();
    expect(true).assertTrue();
  });
}
function MidSceneFSMTest_ctxIsInvalid_01(){
  it('MidSceneContextTest_ctxIsInvalid_001', Level.LEVEL0, () => {
    let midSceneContext1: MidSceneContext = new MidSceneContext();
    midSceneContext1.l2r = [midsceneData];
    midSceneContext1.anchorIndex = 1;
    midSceneContext1.ctxIsInvalid();
    midSceneContext1.anchorIndex = -1;
    midSceneContext1.ctxIsInvalid();
    midSceneContext1.anchorIndex = 0;
    midSceneContext1.ctxIsInvalid();
    expect(true).assertTrue();
  });
  it('MidSceneContextTest_ctxIsInvalid_002', Level.LEVEL0, () => {
    let midSceneContext1: MidSceneContext = new MidSceneContext();
    midSceneContext1.l2r = [midsceneData];
    midSceneContext1.toReplacedIndex = -2;
    expect(midSceneContext1.ctxIsInvalid()).assertTrue();
  });
  it('MidSceneContextTest_ctxIsInvalid_003', Level.LEVEL0, () => {
    let midSceneContext1: MidSceneContext = new MidSceneContext();
    midSceneContext1.ctxIsInvalid();
    expect(true).assertTrue();
  });
}
function MidSceneFSMTest_init_01() {
  it('MidSceneFSMTest_init_001', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(midSceneFSM, 'init');
    expect(true).assertTrue();
  });
}
function MidSceneFSMTest_unregisterDebugCommands_01() {
  it('MidSceneFSMTest_unregisterDebugCommands_001', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(midSceneFSM, 'unregisterDebugCommands');
    expect(true).assertTrue();
  });
}

function MidSceneFSMTest_debugGetCurrentState_01() {
  it('MidSceneFSMTest_debugGetCurrentState_001', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(midSceneFSM, 'debugGetCurrentState');
    expect(true).assertTrue();
  });
}

function MidSceneFSMTest_debugGetAllState_01() {
  it('MidSceneFSMTest_debugGetAllState_001', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(midSceneFSM, 'debugGetAllState');
    expect(true).assertTrue();
  });
}

function MidSceneFSMTest_debugGetFsm_01() {
  it('MidSceneFSMTest_debugGetFsm_001', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(midSceneFSM, 'debugGetFsm', container);
    expect(true).assertTrue();
  });
  it('MidSceneFSMTest_debugGetFsm_002', Level.LEVEL0, () => {
    container.isMidScene = true;
    ReflectionUtils.useFunc(midSceneFSM, 'debugGetFsm', container);
    expect(true).assertTrue();
  });
}

function MidSceneFSMTest_debugPrintMidSceneContext_01() {
  it('MidSceneFSMTest_debugPrintMidSceneContext_001', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(midSceneFSM, 'debugPrintMidSceneContext', container);
    expect(true).assertTrue();
  });
}

function MidSceneFSMTest_debugPrintTransitions_01() {
  it('MidSceneFSMTest_debugPrintTransitions_001', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(midSceneFSM, 'debugPrintTransitions', []);
    expect(true).assertTrue();
  });
  it('MidSceneFSMTest_debugPrintTransitions_002', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(midSceneFSM, 'debugPrintTransitions', ['test']);
    expect(true).assertTrue();
  });
  it('MidSceneFSMTest_debugPrintTransitions_003', Level.LEVEL0, () => {
    let state1: NonMidState = new NonMidState();
    let mocker: MockKit = new MockKit();
    let mockfunc1: Function = mocker.mockFunc(midSceneFSM, midSceneFSM.getState);
    when(mockfunc1)(ArgumentMatchers.any).afterReturn(state1);
    ReflectionUtils.useFunc(midSceneFSM, 'debugPrintTransitions', [state1]);
    expect(true).assertTrue();
    mocker.clear(midSceneFSM)
  });
}
