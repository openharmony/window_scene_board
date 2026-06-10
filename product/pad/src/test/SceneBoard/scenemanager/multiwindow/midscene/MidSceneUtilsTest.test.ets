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
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty,
  FSMState,
} from '@ohos/windowscene';
import {
  MidSceneFSM } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneFSM';
import { MidSceneUtils } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneUtils';
import {
  MidSceneData,
  MidSceneStep } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneData';
import { MidSceneStates } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneStates';
import {
  SCBMidSceneCallback,
  UIConfig } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/SCBMidSceneCallback';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { beforeAll, describe, expect, it, Level } from '@ohos/hypium';


let container:SCBSceneContainerSession;
let screenProperty: SCBScreenProperty;
let midSceneFSM : MidSceneFSM;
let primarySession: SCBSceneSession;
let secondSession: SCBSceneSession;
let sceneInfo: SCBSceneInfo;
let midsceneData: MidSceneData;
let midsceneData0: MidSceneData;

let callBack:SCBMidSceneCallback = {
  toStable(): void{},
  exitFromUnstable(): void{},
  toWaitingAdd(isInMidScene: boolean): void{},
  toWaitingReplace(): void{},
  addFromIcon(session: SCBSceneSession): void{},
  addFromOther(session: SCBSceneSession): void{},
  replaceInFilledState(session: SCBSceneSession): void{},
  getUIConfig(): UIConfig{return new UIConfig()},
  toNonMidScene(): void{},
};

let initAll = () => {
  screenProperty = new SCBScreenProperty();
  midsceneData0 = new MidSceneData(0);
  midsceneData = new MidSceneData(1);
  midsceneData.step = MidSceneStep.SMALL;
  sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 1, 1);
  screenProperty.width = 1;
  screenProperty.height = 1;
  screenProperty = new SCBScreenProperty();
  primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  secondSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  container = new SCBSceneContainerSession(primarySession, screenProperty);
  midSceneFSM = new MidSceneFSM(container, callBack);
  container.sessionData.midSceneFSM = midSceneFSM;
  midSceneFSM.context.l2r = [midsceneData0, midsceneData];
  midSceneFSM.currentState = midSceneFSM.getState(MidSceneStates.STATE_UNFILLED) as FSMState;
}

export function MidSceneUtilsTest() {
  describe("MidSceneUtilsTest_001", () => {
    beforeAll((): void => {
      initAll();
    });
    MidSceneUtils_updateMidSceneInfoWhenFold_01();
    MidSceneUtils_isNeedSplitContainer_01();
    MidSceneUtils_isTwoSmall_01();
  });

}

function MidSceneUtils_isNeedSplitContainer_01() {
  it('MidSceneUtils_isNeedSplitContainer_001', Level.LEVEL0, () => {
    let container1:SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callBack);
    expect(MidSceneUtils.isNeedSplitContainer(container1)).assertFalse();
    expect(MidSceneUtils.isNeedSplitContainer(container)).assertTrue();
  });
}

function MidSceneUtils_updateMidSceneInfoWhenFold_01() {
  it('MidSceneUtils_updateMidSceneInfoWhenFold_001', Level.LEVEL0, () => {
    MidSceneUtils.updateMidSceneInfoWhenFold(container, primarySession.session.persistentId);
    expect((container.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex).assertEqual(0);
  });
}

function MidSceneUtils_isTwoSmall_01() {
  it('MidSceneUtils_isTwoSmall_001', Level.LEVEL0, () => {
    let container1: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callBack);
    let pid0: number = primarySession.session.persistentId;
    let pid1: number = secondSession.session.persistentId;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    let data0 = new MidSceneData(pid0);
    let data1 = new MidSceneData(pid0);
    data0.step = MidSceneStep.SMALL;
    data1.step = MidSceneStep.SMALL;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(data0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(data1);
    container1.midSceneMap.set(pid0, primarySession);
    container1.midSceneMap.set(pid1, secondSession);
    expect(MidSceneUtils.isTwoSmall(container1)).assertTrue();
  });
  it('MidSceneUtils_isTwoSmall_002', Level.LEVEL0, () => {
    let container1: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callBack);
    expect(MidSceneUtils.isTwoSmall(container1)).assertFalse();
  });
}

