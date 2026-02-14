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
  SCBDividerParam,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty,
  SCBTransitionController,
  SceneParam,
} from '@ohos/windowscene';
import {
  MidSceneContext,
  MidSceneFSM } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneFSM';
import { MidSceneData,
  MidSceneExitReason,
  MidSceneStep } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneData';
import {NonMidState} from '../../../../../main/ets/SceneBoard/scenemanager/midscene/midsceneFSMState/NonMidState';
import {
  SCBMidSceneCallback,
  UIConfig } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/SCBMidSceneCallback';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import { ReflectionUtils } from '../ReflectionUtils';

let dividerParam: SCBDividerParam;
let nonMidState: NonMidState;
let screenProperty: SCBScreenProperty;
let midSceneFSM : MidSceneFSM;
let primarySession: SCBSceneSession;
let secondarySession: SCBSceneSession;
let sceneInfo0:SCBSceneInfo;
let sceneInfo: SCBSceneInfo;
let midsceneData: MidSceneData;
let container:SCBSceneContainerSession;
let sceneParam: SceneParam = new SceneParam();
let ctx: MidSceneContext;
let midsceneData0: MidSceneData;
let scbTransitionController: SCBTransitionController = {
  appData: {
    bundleName: '',
    abilityName: '',
    appIconId: 'OpenFolderGridSwiperGlobal',
    appIconNumber: 0,
    iconRadius: 0
  },
  onActive: (): void => {},
  onInactive: (): void =>{}
};
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
  nonMidState = new NonMidState();
  ctx = new MidSceneContext();
  ctx.l2r = [];
  dividerParam = new SCBDividerParam();
  screenProperty = new SCBScreenProperty();
  midsceneData0 = new MidSceneData(0);
  midsceneData = new MidSceneData(1);
  midsceneData.step = MidSceneStep.SMALL;
  sceneInfo0 = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 1, 0);
  sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 1, 1);
  screenProperty.width = 1;
  screenProperty.height = 1;
  primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  secondarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo0), sceneInfo0);
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
  nonMidState.attachToFsm(midSceneFSM);
}

export function NonMidStateTest() {
  describe("NonMidStateTest_001", () => {
    beforeAll((): void => {
      initAll();
    });
    NonMidState_handleEnterBySplitEvent_01();
    NonMidState_judgeEnterBySplitFloat_01();
    NonMidState_setFloatContainerInMidScene_01();
    NonMidState_handleClickDesktopIconAddEvent_01();
    NonMidState_calculateParam_01();
    NonMidState_handleEnterByOneStepEvent_01();
    NonMidState_initSessionToMidSceneMap_01();
    NonMidState_handleMenuAddClickEvent_01();
  });

}

function  NonMidState_judgeEnterBySplitFloat_01() {
  it('NonMidState_judgeEnterBySplitFloat_001', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(nonMidState, 'judgeEnterBySplitFloat', ...[]);
    expect(true).assertTrue();
  });
  it('NonMidState_judgeEnterBySplitFloat_001', Level.LEVEL0, () => {
    let tmpList = new SCBSceneContainerSessionArray();
    tmpList.add(container);
    let args: SCBSceneContainerSessionArray[] = [tmpList];
    ReflectionUtils.useFunc(nonMidState, 'judgeEnterBySplitFloat', ...args);
    expect(true).assertTrue();
  });
}

function  NonMidState_handleEnterBySplitEvent_01() {
  it('NonMidState_handleEnterBySplitEvent_001', Level.LEVEL0, () => {
    secondarySession.sceneParam.posX = '50%';
    container.secondarySession = secondarySession;
    let tmp: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    tmp.add(container);
    let args: SCBSceneContainerSessionArray[] = [tmp];
    ReflectionUtils.useFunc(nonMidState, 'handleEnterBySplitEvent', ...args);
    expect(true).assertTrue();
  });
}

function  NonMidState_setFloatContainerInMidScene_01() {
  it('NonMidState_setFloatContainerInMidScene_001', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(nonMidState, 'setFloatContainerInMidScene', ...[], container, ctx);
    expect(true).assertTrue();
  });
  it('NonMidState_setFloatContainerInMidScene_002', Level.LEVEL0, () => {
    container.midSceneMap.set(primarySession.session.persistentId, primarySession);
    let tmpList = new SCBSceneContainerSessionArray();
    tmpList.add(container);
    let args:SCBSceneContainerSessionArray[] = [tmpList];
    ReflectionUtils.useFunc(nonMidState, 'setFloatContainerInMidScene', ...args, container, ctx);
    expect(true).assertTrue();
  });
}

function  NonMidState_calculateParam_01() {
  it('NonMidState_calculateParam_001', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(nonMidState, 'calculateParam', container, midsceneData, sceneParam);
    expect(true).assertTrue();
  });
  it('NonMidState_calculateParam_002', Level.LEVEL0, () => {
    container.initCompanionIconInfo(sceneInfo, scbTransitionController);
    ReflectionUtils.useFunc(nonMidState, 'calculateParam', container, midsceneData, sceneParam);
    expect(true).assertTrue();
  });
}

function  NonMidState_handleClickDesktopIconAddEvent_01() {
  it('NonMidState_handleClickDesktopIconAddEvent_001', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(nonMidState, 'handleClickDesktopIconAddEvent', ...[]);
    expect(true).assertTrue();
  });
  it('NonMidState_handleClickDesktopIconAddEvent_002', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(nonMidState, 'handleClickDesktopIconAddEvent', ...[primarySession, primarySession]);
    expect(true).assertTrue();
  });
}

function  NonMidState_handleEnterByOneStepEvent_01() {
  it('NonMidState_handleEnterByOneStepEvent_001', Level.LEVEL0, () => {
    primarySession.setFocused(true);
    container.midSceneMap.set(primarySession.session.persistentId, primarySession);
    container.midSceneMap.set(secondarySession.session.persistentId, secondarySession);
    expect(nonMidState.handleEnterByOneStepEvent()).assertTrue();
  });
  it('NonMidState_handleEnterByOneStepEvent_002', Level.LEVEL0, () => {
    primarySession.setFocused(true);
    container.midSceneMap.set(primarySession.session.persistentId, primarySession);
    expect(nonMidState.handleEnterByOneStepEvent()).assertTrue();
  });
}

function NonMidState_handleMenuAddClickEvent_01() {
  it('NonMidState_handleMenuAddClickEvent_001', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(nonMidState, 'handleMenuAddClickEvent');
    expect((nonMidState.myFsm as MidSceneFSM).context.anchorIndex).assertEqual(1);
  });
  it('NonMidState_handleMenuAddClickEvent_002', Level.LEVEL0, () => {
    dividerParam.primary.persistentId = primarySession.session.persistentId
    dividerParam.secondary.persistentId = secondarySession.session.persistentId
    container.dividerParam = dividerParam;
    ReflectionUtils.useFunc(nonMidState, 'handleMenuAddClickEvent');
    expect((nonMidState.myFsm as MidSceneFSM).context.anchorIndex).assertEqual(1);
  });
}

function NonMidState_initSessionToMidSceneMap_01() {
  it('NonMidState_initSessionToMidSceneMap_001', Level.LEVEL0, () => {
    container.primarySession = primarySession;
    container.secondarySession = secondarySession;
    container.midSceneMap.set(primarySession.session.persistentId, primarySession);
    container.midSceneMap.set(secondarySession.session.persistentId, secondarySession);
    container.isSplit = true;
    ReflectionUtils.useFunc(nonMidState, 'initSessionToMidSceneMap', container);
    expect(true).assertTrue();
  });
  it('NonMidState_initSessionToMidSceneMap_002', Level.LEVEL0, () => {
    container.primarySession = primarySession;
    container.secondarySession = secondarySession;
    container.midSceneMap.set(primarySession.session.persistentId, primarySession);
    container.midSceneMap.set(secondarySession.session.persistentId, secondarySession);
    container.isSplit = false;
    ReflectionUtils.useFunc(nonMidState, 'initSessionToMidSceneMap', container);
    expect(true).assertTrue();
  });
}