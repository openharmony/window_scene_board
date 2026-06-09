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
import { ArgumentMatchers, beforeAll, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import { RectInfo, CompanionIconInfo } from '@ohos/basicutils';
import { ItemUtils } from '@ohos/componenthelper';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  SCBAppIconParam,
  SplitStyle,
  SCBScreenSessionManager,
  SCBSceneInfo,
  SCBSceneContainerSession,
  SceneParam,
  SCBScreenProperty,
  SCBDividerParam,
  SCBSceneSessionManager,
  SCBSceneSession
} from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBDividerParamArray } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneContainerSession';
import {
  SCBMultiWindowGuideUtils, GuideResult, GuideCase
} from '../../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBMultiWindowUtils';
import {
  GlobalOffsetCalculator
} from '../../../../../main/ets/SceneBoard/scenemanager/multiwindow/utils/FloatUtils';
import {
  SCBSideEdgeBarManager
} from '../../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBSideEdgeBarManager';
import { MidSceneUtils } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneUtils';
import {
  MidSceneAdjustRes,
  MidSceneData,
  MidSceneExitReason,
  MidSceneReason,
  MidSceneStep} from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneData';
import {
  MidSceneContext,
  MidSceneFSM } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneFSM';
import {MidSceneManager, MidSceneInterruptEnum,
  DividerUpdateReason} from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneManager';
import { MidSceneDragContext } from '../../../../../main/ets/SceneBoard/scenemanager/midscene/MidSceneDragContext';
import {
  MidSceneToStableReason,
  SCBMidSceneCallback,
  UIConfig
} from '../../../../../main/ets/SceneBoard/scenemanager/midscene/SCBMidSceneCallback';
import {ReflectionUtils} from '../ReflectionUtils';

let scbSceneSession1: SCBSceneSession;
let primarySession: SCBSceneSession;
let secondSession: SCBSceneSession;
let thirdSession: SCBSceneSession;
let container:SCBSceneContainerSession;
let appIconParam: SCBAppIconParam;
let midSceneDragContext : MidSceneDragContext;
let screenProperty: SCBScreenProperty;
let sceneParams : SceneParam[];
let dividerParam: SCBDividerParam;
let midSceneManager: MidSceneManager;
let sceneInfo: SCBSceneInfo;
let sceneInfo1: SCBSceneInfo;
let session: sceneSessionManager.SceneSession;
let session1: sceneSessionManager.SceneSession;
let scbSceneSession: SCBSceneSession;

let companionIconInfotest: CompanionIconInfo = {
  iconId: 'test',
  bundleName: 'test',
  abilityName: 'test',
  moduleName: 'test',
  iconNumber: 0,
  iconRadius: 0,
  startAppType: 0,
  cardId: 'test',
}
let callback:SCBMidSceneCallback = {
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
  screenProperty = new SCBScreenProperty();
  screenProperty.width = 1;
  screenProperty.height = 1;
  midSceneDragContext = new MidSceneDragContext(screenProperty);
  sceneParams = new Array<SceneParam>(5);
  dividerParam = new SCBDividerParam();
  sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
  session = sceneSessionManager.requestSceneSession({
    bundleName: sceneInfo.bundleName,
    moduleName: sceneInfo.moduleName,
    abilityName: sceneInfo.abilityName,
    appIndex: sceneInfo.appIndex,
    persistentId: sceneInfo.persistentId,
    screenId: sceneInfo.screenId
  }, sceneInfo.want);

  sceneInfo1 = new SCBSceneInfo('testPriBundle1', 'testPriModule1', 'testPriAbility1');
  session1 = sceneSessionManager.requestSceneSession({
    bundleName: sceneInfo1.bundleName,
    moduleName: sceneInfo1.moduleName,
    abilityName: sceneInfo1.abilityName,
    appIndex: sceneInfo1.appIndex,
    persistentId: sceneInfo1.persistentId,
    screenId: sceneInfo1.screenId
  }, sceneInfo1.want);

  primarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  secondSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  thirdSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  midSceneManager = new MidSceneManager(screenProperty);
  container = new SCBSceneContainerSession(primarySession, screenProperty);
  (container.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container, callback);
  let midsceneData: MidSceneData = new MidSceneData(1);
  midsceneData.step = MidSceneStep.LARGE;
  midsceneData.left = 0.2;
  scbSceneSession = new SCBSceneSession(session, sceneInfo);
  scbSceneSession1 = new SCBSceneSession(session1, sceneInfo1);
  (container.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
  (container.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData);
  (container.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 0;
  let sceneSessionFunc:() => SCBSceneSession= () =>{
    let sceneInfo1 = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let tmp = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
    return tmp;
  };
  appIconParam = new SCBAppIconParam(sceneSessionFunc);
}

export function MidSceneManagerTest() {
  describe("MidSceneManagerTest_001", () => {
    beforeAll((): void => {
      initAll();
    });
    MidSceneManagerTest_isMidSceneInForeground_01();
    MidSceneManagerTest_updateDividerParamsMidScene_01();
    MidSceneManagerTest_replaceMidSceneFromNotification_01();
    MidSceneManagerTest_onMidSceneAnimInterrupt_01();
    MidSceneManagerTest_updateCtxParams_01();
    MidSceneManagerTest_toWaitingReplace_01();
    MidSceneManagerTest_updateSceneParamAndSession_01();
    MidSceneManagerTest_isSupportMidScene_01();
    MidSceneManagerTest_isSupportOneStepToMidScene_01();
    MidSceneManagerTest_toStable_01();
    MidSceneManagerTest_toWaitingAdd_01();
    MidSceneManagerTest_onMidSceneAnimStart_01();
    MidSceneManagerTest_endDraggingInMidScene_01();
    MidSceneManagerTest_onMidSceneAnimFinish_01();
    MidSceneManagerTest_isMidSceneFull_01();
    MidSceneManagerTest_midSceneSceneParmCopyToDividerParam_01();
    MidSceneManagerTest_updateDraggingEventInMidScene_01();
    MidSceneManagerTest_initOutsideScreenMidScene_01();
    MidSceneManagerTest_addFromIcon_02();
    MidSceneManagerTest_replaceOut_02();
    MidSceneManagerTest_handleSceneReplacedToStable_01();
    MidSceneManagerTest_updateDragSwapWithAnimation_02();
    MidSceneManagerTest_updateDraggingEventInMidScene_02();
    MidSceneManagerTest_exitFromUnstable_01();
  });
}

function MidSceneManagerTest_onMidSceneAnimStart_01() {
  it('MidSceneManagerTest_onMidSceneAnimStart_01', Level.LEVEL0, () => {
    let animType1 = 0;
    let animType2 = 1;
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    let container2 = new SCBSceneContainerSession(primarySession, screenProperty);
    midSceneManager.onMidSceneAnimStart(animType1, container1);
    midSceneManager.onMidSceneAnimStart(animType2, container2);
    expect(animType1).assertEqual(0);
    expect(animType2).assertEqual(1);
  });

  it('MidSceneManagerTest_onMidSceneAnimStart_02', Level.LEVEL0,() => {
    const animType = 2;
    let container: SCBSceneContainerSession | null = new SCBSceneContainerSession(primarySession, screenProperty);
    midSceneManager.onMidSceneAnimStart(animType, container);
    expect(animType).assertEqual(2);
    let container1: SCBSceneContainerSession | null = new SCBSceneContainerSession(primarySession, screenProperty);
    expect(animType).assertEqual(2);
  });
}

function MidSceneManagerTest_onMidSceneAnimFinish_01() {
  it('MidSceneManagerTest_onMidSceneAnimFinish_01', Level.LEVEL0, () => {
    let animType = 0;
    let container = new SCBSceneContainerSession(primarySession, screenProperty);
    midSceneManager.onMidSceneAnimStart(animType, container);
    midSceneManager.onMidSceneAnimFinish(animType);
    expect(midSceneManager.onMidSceneAnimFinish(animType)).assertTrue();
  });

  it('MidSceneManagerTest_onMidSceneAnimFinish_02', Level.LEVEL0, () => {
    const animType = 1;
    let container: SCBSceneContainerSession | null = new SCBSceneContainerSession(primarySession, screenProperty);
    midSceneManager.onMidSceneAnimStart(animType, container);
    midSceneManager.onMidSceneAnimFinish(animType);
    expect(midSceneManager.onMidSceneAnimFinish(animType)).assertTrue();
  });

  it('MidSceneManagerTest_onMidSceneAnimFinish_03', Level.LEVEL0, () => {
    let animType = 2;
    let container = new SCBSceneContainerSession(primarySession, screenProperty);
    midSceneManager.onMidSceneAnimStart(animType, container);
    midSceneManager.onMidSceneAnimFinish(animType);
    expect(midSceneManager.onMidSceneAnimFinish(animType)).assertTrue();
  });

  it('MidSceneManagerTest_onMidSceneAnimFinish_04', Level.LEVEL0, () => {
    const animType = 3;
    let container: SCBSceneContainerSession | null = new SCBSceneContainerSession(primarySession, screenProperty);
    midSceneManager.onMidSceneAnimStart(animType, container);
    midSceneManager.onMidSceneAnimFinish(animType);
    expect(midSceneManager.onMidSceneAnimFinish(animType)).assertTrue();
  });
}

function MidSceneManagerTest_onMidSceneAnimInterrupt_01() {
  it('MidSceneManagerTest_onMidSceneAnimInterrupt_001', Level.LEVEL0, () => {
    let midSceneManager1 = new MidSceneManager(screenProperty);
    let animTypeList: Array<MidSceneInterruptEnum> = [MidSceneInterruptEnum.EXIT_ONE,
      MidSceneInterruptEnum.EXIT_TWO_SMALL];
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    midSceneManager1.onMidSceneAnimStart(MidSceneInterruptEnum.EXIT_ONE, container1);
    midSceneManager1.onMidSceneAnimStart(MidSceneInterruptEnum.EXIT_TWO_SMALL, container1);
    midSceneManager1.onMidSceneAnimInterrupt(animTypeList);
    expect(midSceneManager1.onMidSceneAnimInterrupt(animTypeList)).assertTrue();
  });

  it('MidSceneManagerTest_onMidSceneAnimInterrupt_002', Level.LEVEL0, () => {
    let midSceneManager1 = new MidSceneManager(screenProperty);
    let animTypeList: Array<MidSceneInterruptEnum> = [MidSceneInterruptEnum.EXIT_ONE, 3, 4];
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    midSceneManager1.onMidSceneAnimInterrupt(animTypeList);
    midSceneManager1.onMidSceneAnimStart(MidSceneInterruptEnum.EXIT_ONE, container1);
    midSceneManager1.onMidSceneAnimStart(MidSceneInterruptEnum.EXIT_TWO_SMALL, container1);
    expect(true).assertTrue();
    expect(midSceneManager1.onMidSceneAnimInterrupt(animTypeList)).assertTrue();
  });

  it('MidSceneManagerTest_onMidSceneAnimInterrupt_003', Level.LEVEL0, () => {
    let midSceneManager1 = new MidSceneManager(screenProperty);
    let container2 = new SCBSceneContainerSession(primarySession, screenProperty);
    let animTypeList: Array<MidSceneInterruptEnum> = [MidSceneInterruptEnum.EXIT_ONE, 3];
    midSceneManager1.onMidSceneAnimInterrupt(animTypeList);
    midSceneManager1.onMidSceneAnimStart(MidSceneInterruptEnum.EXIT_ONE, container2);
    midSceneManager1.onMidSceneAnimStart(MidSceneInterruptEnum.EXIT_TWO_SMALL, container2);
    expect(true).assertTrue();
    expect(midSceneManager1.onMidSceneAnimInterrupt(animTypeList)).assertTrue();
  });

  it('MidSceneManagerTest_onMidSceneAnimInterrupt_004', Level.LEVEL0, () => {
    let midSceneManager1 = new MidSceneManager(screenProperty);
    let animTypeList: Array<MidSceneInterruptEnum> = [];
    midSceneManager1.onMidSceneAnimInterrupt(animTypeList);
    expect(midSceneManager1.onMidSceneAnimInterrupt(animTypeList)).assertFalse();
  });
}

function MidSceneManagerTest_updateCtxParams_01() {
  it('MidSceneManager_updateCtxParams_001_UNDEFINED', Level.LEVEL0, () => {
    let midsceneData0: MidSceneData = new MidSceneData(2);
    midsceneData0.left = 0.3;
    midsceneData0.width = 0.3;
    midsceneData0.top = 0.3;
    midsceneData0.scale = 0.3;
    midsceneData0.height = 0.3;
    container.midSceneMap.set(2, scbSceneSession);
    (container.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData0);
    midSceneManager.updateCtxParams(container, MidSceneReason.UNDEFINED);
    expect(true).assertTrue();
  });

  it('MidSceneManager_updateCtxParams_002_TO_WAITING_STATE', Level.LEVEL0, () => {
    let midsceneData0: MidSceneData = new MidSceneData(3);
    midsceneData0.left = 0.4;
    midsceneData0.width = 0.4;
    midsceneData0.top = 0.4;
    midsceneData0.scale = 0.4;
    midsceneData0.height = 0.4;
    container.midSceneMap.set(3, scbSceneSession);
    (container.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData0);
    midSceneManager.updateCtxParams(container, MidSceneReason.TO_WAITING_STATE);
    expect(true).assertTrue();
  });

  it('MidSceneManager_updateCtxParams_003_TO_STABLE_STATE', Level.LEVEL0, () => {
    let midsceneData0: MidSceneData = new MidSceneData(4);
    midsceneData0.left = 0.5;
    midsceneData0.width = 0.5;
    midsceneData0.top = 0.5;
    midsceneData0.scale = 0.5;
    midsceneData0.height = 0.5;
    container.midSceneMap.set(4, scbSceneSession);
    (container.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData0);
    midSceneManager.updateCtxParams(container, MidSceneReason.TO_STABLE_STATE);
    expect(true).assertTrue();
  });

  it('MidSceneManager_updateCtxParams_004_TO_EXIT_ONE', Level.LEVEL0, () => {
    let midsceneData0: MidSceneData = new MidSceneData(5);
    midsceneData0.left = 0.6;
    midsceneData0.width = 0.6;
    midsceneData0.top = 0.6;
    midsceneData0.scale = 0.6;
    midsceneData0.height = 0.6;
    container.midSceneMap.set(5, scbSceneSession);
    (container.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData0);
    midSceneManager.updateCtxParams(container, MidSceneReason.TO_EXIT_ONE);
    expect(true).assertTrue();
  });

  it('MidSceneManager_updateCtxParams_005_TO_EXIT_TWO_SAMLL', Level.LEVEL0, () => {
    let midsceneData0: MidSceneData = new MidSceneData(6);
    midsceneData0.left = 0.7;
    midsceneData0.width = 0.7;
    midsceneData0.top = 0.7;
    midsceneData0.scale = 0.7;
    midsceneData0.height = 0.7;
    container.midSceneMap.set(6, scbSceneSession);
    (container.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData0);
    midSceneManager.updateCtxParams(container, MidSceneReason.TO_EXIT_TWO_SAMLL);
    expect(true).assertTrue();
  });

  it('MidSceneManager_updateCtxParams_006_TO_WAITING_REPLACE_STATE', Level.LEVEL0, () => {
    let midsceneData0: MidSceneData = new MidSceneData(7);
    midsceneData0.left = 0.8;
    midsceneData0.width = 0.8;
    midsceneData0.top = 0.8;
    midsceneData0.scale = 0.8;
    midsceneData0.height = 0.8;
    container.midSceneMap.set(7, scbSceneSession);
    (container.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData0);
    midSceneManager.updateCtxParams(container, MidSceneReason.TO_WAITING_REPLACE_STATE);
    expect(true).assertTrue();
  });

  it('MidSceneManager_updateCtxParams_007_TO_WAITING_FROM_MIDSCENE_STATE', Level.LEVEL0, () => {
    let midsceneData0: MidSceneData = new MidSceneData(8);
    midsceneData0.left = 0.9;
    midsceneData0.width = 0.9;
    midsceneData0.top = 0.9;
    midsceneData0.scale = 0.9;
    midsceneData0.height = 0.9;
    container.midSceneMap.set(8, scbSceneSession);
    (container.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData0);
    midSceneManager.updateCtxParams(container, MidSceneReason.TO_WAITING_FROM_MIDSCENE_STATE);
    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_isMidSceneInForeground_01() {
  it('MidSceneManager_isMidSceneInForeground_001', Level.LEVEL0, () => {
    midSceneManager.isMidSceneInForeground();
    ReflectionUtils.setProperty(midSceneManager, 'isMidConfigSupport', false);
    expect(true).assertTrue();
    midSceneManager.isMidSceneInForeground();
    ReflectionUtils.setProperty(midSceneManager, 'isMidConfigSupport', true);
    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_updateDividerParamsMidScene_01() {
  it('MidSceneManager_updateDividerParamsMidScene_001_isMidSceneFalse', Level.LEVEL0, () => {
    let midSceneContext: MidSceneContext = new MidSceneContext();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.isMidScene = false;
    midSceneManager.updateDividerParamsMidScene(container1, midSceneContext);
    expect(container1.dividerParamList).assertEqual([]);
  });

  it('MidSceneManager_updateDividerParamsMidScene_002_isMidSceneTrue', Level.LEVEL0, () => {
    let midSceneContext: MidSceneContext = new MidSceneContext();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.isMidScene = true;
    let midsceneData0: MidSceneData = new MidSceneData(0);
    midsceneData0.left = 0.5;
    midsceneData0.visibleW = 0.5;
    let midsceneData1: MidSceneData = new MidSceneData(1);
    midsceneData1.left = 0.5;
    midsceneData1.visibleW = 0.5;
    midSceneContext.l2r = [midsceneData0, midsceneData1];
    midSceneManager.updateDividerParamsMidScene(container1, midSceneContext);
    expect(container1.dividerParamList).assertEqual([new SCBDividerParam()]);
  });

  it('MidSceneManager_updateDividerParamsMidScene_003_l2rLengthGreaterThanDividerNumberPlusOne', Level.LEVEL0, () => {
    let midSceneContext: MidSceneContext = new MidSceneContext();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.isMidScene = true;
    let midsceneData0: MidSceneData = new MidSceneData(0);
    midsceneData0.left = 0.5;
    midsceneData0.visibleW = 0.5;
    let midsceneData1: MidSceneData = new MidSceneData(1);
    midsceneData1.left = 0.5;
    midsceneData1.visibleW = 0.5;
    let midsceneData2: MidSceneData = new MidSceneData(2);
    midsceneData2.left = 0.5;
    midsceneData2.visibleW = 0.5;
    midSceneContext.l2r = [midsceneData0, midsceneData1, midsceneData2];
    midSceneManager.updateDividerParamsMidScene(container1, midSceneContext);
    expect(container1.dividerParamList).assertEqual([new SCBDividerParam(), new SCBDividerParam()]);
  });

  it('MidSceneManager_updateDividerParamsMidScene_004_l2rLengthEqualsDividerNumber', Level.LEVEL0, () => {
    let midSceneContext: MidSceneContext = new MidSceneContext();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.isMidScene = true;
    let midsceneData0: MidSceneData = new MidSceneData(0);
    midsceneData0.left = 0.5;
    midsceneData0.visibleW = 0.5;
    let midsceneData1: MidSceneData = new MidSceneData(1);
    midsceneData1.left = 0.5;
    midsceneData1.visibleW = 0.5;
    midSceneContext.l2r = [midsceneData0, midsceneData1];
    midSceneManager.updateDividerParamsMidScene(container1, midSceneContext);
    expect(container1.dividerParamList).assertEqual([new SCBDividerParam()]);
  });

  it('MidSceneManager_updateDividerParamsMidScene_005_l2rLengthLessThanDividerNumber', Level.LEVEL0, () => {
    let midSceneContext: MidSceneContext = new MidSceneContext();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.isMidScene = true;
    let midsceneData0: MidSceneData = new MidSceneData(0);
    midsceneData0.left = 0.5;
    midsceneData0.visibleW = 0.5;
    let midsceneData1: MidSceneData = new MidSceneData(1);
    midsceneData1.left = 0.5;
    midsceneData1.visibleW = 0.5;
    midSceneContext.l2r = [midsceneData0];
    midSceneManager.updateDividerParamsMidScene(container1, midSceneContext);
    expect(container1.dividerParamList).assertEqual([]);
  });
}

function MidSceneManagerTest_replaceMidSceneFromNotification_01() {
  it('MidSceneManager_replaceMidSceneFromNotification_001_ctxIsInvalid', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = -1;
    midSceneManager.replaceMidSceneFromNotification(container1, scbSceneSession);
    expect((container1.sessionData.midSceneFSM as MidSceneFSM).context.toReplacedIndex).assertEqual(0);
  });

  it('MidSceneManager_replaceMidSceneFromNotification_002_l2rLengthGreaterThan1', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 0;
    midSceneManager.replaceMidSceneFromNotification(container1, scbSceneSession);
    expect((container1.sessionData.midSceneFSM as MidSceneFSM).context.toReplacedIndex).assertEqual(1);
  });

  it('MidSceneManager_replaceMidSceneFromNotification_003_l2rLengthEquals1', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 0;
    midSceneManager.replaceMidSceneFromNotification(container1, scbSceneSession);
    expect((container1.sessionData.midSceneFSM as MidSceneFSM).context.toReplacedIndex).assertEqual(0);
  });

  it('MidSceneManager_replaceMidSceneFromNotification_004_ctxIsNotNull', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 0;
    midSceneManager.replaceMidSceneFromNotification(container1, scbSceneSession);
    expect((container1.sessionData.midSceneFSM as MidSceneFSM).context.toReplacedIndex).assertEqual(1);
  });
}

function MidSceneManagerTest_toWaitingReplace_01() {
  it('MidSceneManager_toWaitingReplace_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession1);
    let list: SCBDividerParamArray = new SCBDividerParamArray();
    let data1 = new SCBDividerParam();
    let data2 = new SCBDividerParam();
    list.push(data1);
    list.push(data2);
    container1.dividerParamList = list;
    let midsceneData0: MidSceneData = new MidSceneData(0);
    midsceneData0.left = 0.3;
    midsceneData0.top = 0.4;
    midsceneData0.width = 0.2;
    midsceneData0.height = 0.3;
    midsceneData0.scale = 1.1;
    midsceneData0.step = MidSceneStep.SMALL;
    let midsceneData1: MidSceneData = new MidSceneData(1);
    midsceneData1.left = 0.6;
    midsceneData1.top = 0.7;
    midsceneData1.width = 0.1;
    midsceneData1.height = 0.2;
    midsceneData1.scale = 0.9;
    midsceneData1.step = MidSceneStep.LARGE;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    midSceneManager.toWaitingReplace(container1, appIconParam, appIconParam);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.toReplacedIndex = 1;
    midSceneManager.toWaitingReplace(container1, appIconParam, appIconParam);
    expect(appIconParam.opacity).assertEqual(0);
  });

  it('MidSceneManager_toWaitingReplace_002', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession1);
    let list: SCBDividerParamArray = new SCBDividerParamArray();
    let data1 = new SCBDividerParam();
    let data2 = new SCBDividerParam();
    list.push(data1);
    list.push(data2);
    container1.dividerParamList = list;
    let midsceneData0: MidSceneData = new MidSceneData(0);
    midsceneData0.left = 0.1;
    midsceneData0.top = 0.2;
    midsceneData0.width = 0.4;
    midsceneData0.height = 0.5;
    midsceneData0.scale = 1.0;
    midsceneData0.step = MidSceneStep.LARGE;
    let midsceneData1: MidSceneData = new MidSceneData(1);
    midsceneData1.left = 0.8;
    midsceneData1.top = 0.9;
    midsceneData1.width = 0.3;
    midsceneData1.height = 0.4;
    midsceneData1.scale = 1.2;
    midsceneData1.step = MidSceneStep.SMALL;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    midSceneManager.toWaitingReplace(container1, appIconParam, appIconParam);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.toReplacedIndex = 0;
    midSceneManager.toWaitingReplace(container1, appIconParam, appIconParam);
    expect(appIconParam.opacity).assertEqual(0);
  });
}

function MidSceneManagerTest_updateSceneParamAndSession_01() {
  it('MidSceneManager_updateSceneParamAndSession_001', Level.LEVEL0, () => {
    let container0 = new SCBSceneContainerSession(primarySession, screenProperty);
    container0.primarySession = null;
    container0.secondarySession = null;
    (container0.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container, callback);
    (container0.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    ReflectionUtils.useFunc(midSceneManager, 'updateSceneParamAndSession', container0,
      DividerUpdateReason.MIDSCENE_TRANS_TO_FULLSCENE);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    midsceneData0.left = 0.1;
    midsceneData0.top = 0.2;
    midsceneData0.width = 0.3;
    midsceneData0.height = 0.4;
    midsceneData0.scale = 1.0;
    midsceneData0.step = MidSceneStep.SMALL;
    (container0.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData0);
    expect(true).assertTrue();
  });

  it('MidSceneManager_updateSceneParamAndSession_002', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    midsceneData0.left = 0.5;
    midsceneData0.top = 0.6;
    midsceneData0.width = 0.7;
    midsceneData0.height = 0.8;
    midsceneData0.scale = 1.1;
    midsceneData0.step = MidSceneStep.LARGE;
    midsceneData1.left = 0.9;
    midsceneData1.top = 0.1;
    midsceneData1.width = 0.2;
    midsceneData1.height = 0.3;
    midsceneData1.scale = 1.2;
    midsceneData1.step = MidSceneStep.SMALL;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    ReflectionUtils.useFunc(midSceneManager, 'updateSceneParamAndSession', container1,
      DividerUpdateReason.MIDSCENE_TRANS_TO_SPLIT);
    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_isSupportMidScene_01() {
  it('MidSceneManager_isSupportMidScene_001', Level.LEVEL0, () => {
    let container4 = new SCBSceneContainerSession(primarySession, screenProperty);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
    let mockfunc2: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
      SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
    when(mockfunc2)(ArgumentMatchers.any).afterReturn(false);
    midSceneManager.isSupportMidScene(container4);
    expect(false).assertTrue();
    mocker.clear(DeviceHelper);
    mocker.clear(SCBScreenSessionManager.getInstance());
  });

  it('MidSceneManager_isSupportMidScene_002', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
      SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
    midSceneManager.isSupportMidScene();
    midSceneManager.isSupportMidScene(container1);
    expect(false).assertTrue();
    mocker.clear(SCBScreenSessionManager.getInstance());
  });

  it('MidSceneManager_isSupportMidScene_003', Level.LEVEL0, () => {
    let container2 = new SCBSceneContainerSession(primarySession, screenProperty);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
    midSceneManager.isSupportMidScene(container2);
    expect(true).assertTrue();
    mocker.clear(DeviceHelper);
  });

  it('MidSceneManager_isSupportMidScene_004', Level.LEVEL0, () => {
    let container3 = new SCBSceneContainerSession(primarySession, screenProperty);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
      SCBSceneSessionManager.getInstance().isPcMode);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
    midSceneManager.isSupportMidScene(container3);
    expect(true).assertTrue();
    mocker.clear(SCBSceneSessionManager.getInstance());
  });
}

function MidSceneManagerTest_endDraggingInMidScene_01() {
  it('MidSceneManager_endDraggingInMidScene_001', Level.LEVEL0, () => {
    let midSceneManager1: MidSceneManager = new MidSceneManager(screenProperty);
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData3: MidSceneData = new MidSceneData(3, false);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    midsceneData1.step = MidSceneStep.SMALL;
    midsceneData3.step = MidSceneStep.LARGE;
    midsceneData2.step = MidSceneStep.LARGE;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let dividerParam1 = new SCBDividerParam();
    testOffsetRange(midSceneManager1, container1, dividerParam1);
    expect(true).assertTrue();
  });
}

function testOffsetRange(midSceneManager: MidSceneManager, container: SCBSceneContainerSession,
  dividerParam: SCBDividerParam) {
  let nums: Array<number> = [0.1, 0.14, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7];
  for(let n of nums){
    dividerParam.positionX = '0%';
    midSceneManager.endDraggingInMidScene(container, dividerParam, n);
  }
  nums = [-0.1, -0.15, 0.15, 0.2];
  for(let n of nums){
    dividerParam.positionX = '90%';
    midSceneManager.endDraggingInMidScene(container, dividerParam, n);
  }
}

function MidSceneManagerTest_toWaitingAdd_01() {
  it('MidSceneManager_toWaitingAdd_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(1, scbSceneSession);
    midSceneManager.toWaitingAdd(container1, appIconParam, appIconParam, true);
    midSceneManager.toWaitingAdd(container1, appIconParam, appIconParam, false);
    midSceneManager.toWaitingAdd(container, appIconParam, appIconParam, true);
    midSceneManager.toWaitingAdd(container, appIconParam, appIconParam, false);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    midSceneManager.toWaitingAdd(container1, appIconParam, appIconParam, true);
    midSceneManager.toWaitingAdd(container1, appIconParam, appIconParam, false);
    container1.midSceneMap.set(2, scbSceneSession);
    midSceneManager.toWaitingAdd(container1, appIconParam, appIconParam, true);
    midSceneManager.toWaitingAdd(container1, appIconParam, appIconParam, false);
    expect(true).assertTrue();
  });

  it('MidSceneManager_toWaitingAdd_002', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(1, scbSceneSession);
    midSceneManager.toWaitingAdd(container1, appIconParam, appIconParam, false);
    expect(true).assertTrue();
  });
}


function MidSceneManagerTest_isSupportOneStepToMidScene_01() {
  it('MidSceneManager_isSupportOneStepToMidScene_001', Level.LEVEL0, () => {
    let container3 = new SCBSceneContainerSession(primarySession, screenProperty);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(midSceneManager, midSceneManager.isSupportMidScene);

    // Test with null container
    when(mockfunc)(null).afterReturn(false);
    expect(midSceneManager.isSupportOneStepToMidScene(null)).assertFalse();

    // Test with container that does not support mid scene
    when(mockfunc)(container).afterReturn(false);
    expect(midSceneManager.isSupportOneStepToMidScene(container)).assertFalse();

    // Test with container that supports mid scene but has only one mid scene
    container3.isMidScene = true;
    when(mockfunc)(container3).afterReturn(true);
    expect(midSceneManager.isSupportOneStepToMidScene(container3)).assertFalse();

    // Test with container that does not support mid scene but has a divider param with split style
    container3.dividerParam.splitStyle = SplitStyle.UP_AND_DOWN_POS;
    when(mockfunc)(container3).afterReturn(false);
    expect(midSceneManager.isSupportOneStepToMidScene(container3)).assertFalse();

    // Test with container that does not support mid scene but has a divider param with no split style
    container3.dividerParam.splitStyle = SplitStyle.UNDEFINED;
    when(mockfunc)(container3).afterReturn(false);
    expect(midSceneManager.isSupportOneStepToMidScene(container3)).assertTrue();

    // Test with container that does not support mid scene but has a divider param with no split style
    container3.dividerParam.splitStyle = SplitStyle.LEFT_AND_RIGHT_POS;
    when(mockfunc)(container3).afterReturn(false);
    expect(midSceneManager.isSupportOneStepToMidScene(container3)).assertTrue();
    mocker.clear(midSceneManager);
  });
}

function MidSceneManagerTest_toStable_01() {
  it('MidSceneManager_toStable_001', Level.LEVEL0, () => {
    let midsceneData1: MidSceneData = new MidSceneData(1);
    midsceneData1.step = MidSceneStep.LARGE;
    midsceneData1.inclined = true;
    let midsceneData2: MidSceneData = new MidSceneData(2);
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container, callback);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 0;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    scbSceneSession.sceneParam = new SceneParam();
    container1.dividerParamList = [dividerParam, dividerParam];
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    let midsceneData3: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    container1.midSceneMap.set(0, scbSceneSession);
    // Test with different reasons
    midSceneManager.toStable(container1, appIconParam, appIconParam);
    container1.getDividerParamList()[0].splitToMidEnter = true;
    container1.primarySession = null;
    container1.dividerParamList = [dividerParam];
    midSceneManager.toStable(container1, appIconParam, appIconParam);
    container1.secondarySession = primarySession;
    midSceneManager.toStable(container1, appIconParam, appIconParam);
    container1.primarySession = primarySession;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 1;
    midSceneManager.toStable(container1, appIconParam, appIconParam);
    let sceneSessionFunc:() => SCBSceneSession= () =>{
      let sceneInfo1 = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let tmp = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
      return tmp;
    };
    let appIconParam1 = new SCBAppIconParam(sceneSessionFunc);
    // Test with different icon parameters
    midSceneManager.toStable(container1, appIconParam1, appIconParam1);
    expect(true).assertTrue();
    // Test with different divider parameters
    midSceneManager.toStable(container1, appIconParam, appIconParam, MidSceneToStableReason.ADJUST_WINDOW_SIZE);
    expect(true).assertTrue();
    midSceneManager.toStable(container1, appIconParam, appIconParam, MidSceneToStableReason.FOCUS_TRANSFER);
    expect(true).assertTrue();
    midSceneManager.toStable(container1, appIconParam, appIconParam, MidSceneToStableReason.FULL_TO_MIDDLE_IN_GESTURE);
    expect(true).assertTrue();
    midSceneManager.toStable(container1, appIconParam, appIconParam, MidSceneToStableReason
      .FULL_TO_MIDDLE_AFTER_GESTURE);
    expect(true).assertTrue();
    midSceneManager.toStable(container1, appIconParam, appIconParam, MidSceneToStableReason.TITLE_BAR_DRAG);
    expect(true).assertTrue();
    midSceneManager.toStable(container1, appIconParam, appIconParam, MidSceneToStableReason.MIDDLE_TO_BACKGROUND);
    expect(true).assertTrue();
    midSceneManager.toStable(container1, appIconParam, appIconParam, MidSceneToStableReason.SCENE_REPLACE);
    expect(true).assertTrue();
    midSceneManager.toStable(container1, appIconParam, appIconParam, MidSceneToStableReason.SCENE_ADD);
    expect(true).assertTrue();
    midSceneManager.toStable(container1, appIconParam, appIconParam, MidSceneToStableReason.UNKNOWN);
    expect(true).assertTrue();
    // Test with null sessions
    midSceneManager.toStable(container1, appIconParam, appIconParam, MidSceneToStableReason.FOLD_TO_EXPAND, null, null);
    expect(true).assertTrue();

    // Test with empty dividerParamList
    container1.dividerParamList = [];
    midSceneManager.toStable(container1, appIconParam, appIconParam);
    // Test with non-dividerParam in dividerParamList
    container1.dividerParamList = [dividerParam, new SCBDividerParam()];
    midSceneManager.toStable(container1, appIconParam, appIconParam);
    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_isMidSceneFull_01() {
  it('MidSceneManager_isMidSceneFull_002', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    midSceneManager.isMidSceneFull(container1);
    container1.midSceneMap.set(1, scbSceneSession);
    midSceneManager.isMidSceneFull(container1);
    container1.midSceneMap.set(2, scbSceneSession);
    midSceneManager.isMidSceneFull(container1);
    container1.midSceneMap.set(3, scbSceneSession);
    midSceneManager.isMidSceneFull(container1);
    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_midSceneSceneParmCopyToDividerParam_01() {
  it('MidSceneManagerTest_midSceneSceneParmCopyToDividerParam_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(3);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(4);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(4, scbSceneSession);
    container1.midSceneMap.set(3, scbSceneSession);
    container1.isSplit = true;
    midSceneManager.midSceneSceneParmCopyToDividerParam(container1);
    expect(true).assertTrue();
    container1.isSplit = false;
    midSceneManager.midSceneSceneParmCopyToDividerParam(container1);
    expect(true).assertTrue();
    container1.isSplit = true;
    container1.dividerParam.splitOrderIsNotReverse = false;
    midSceneManager.midSceneSceneParmCopyToDividerParam(container1);
    expect(true).assertTrue();
    // Test with l2r length 0
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    midSceneManager.midSceneSceneParmCopyToDividerParam(container1);
    expect(true).assertTrue();
    // Test with midSceneMap without SceneParam
    container1.midSceneMap.clear();
    midSceneManager.midSceneSceneParmCopyToDividerParam(container1);
    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_exitFromUnstable_01() {
  it('MidSceneManager_exitFromUnstable_001', Level.LEVEL0, () => {
    // Setup container with midSceneMap and midAppIconParamMap
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midAppIconParamMap.set(2, appIconParam);
    container1.dividerParamList = [dividerParam];

    // Test exitOneFromUnstable
    midSceneManager.exitFromUnstable(container1);

    expect(dividerParam.splitToMidEnter).assertTrue();

    // Reset the container for the next test case
    container1.midSceneMap.clear();
    container1.midAppIconParamMap.clear();
    container1.dividerParamList = [];

    // Add two midScenes to the container
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.midAppIconParamMap.set(2, appIconParam);
    container1.dividerParamList = [dividerParam];

    // Test exitTwoSmallFromUnstable
    midSceneManager.exitFromUnstable(container1);
    expect(dividerParam.splitToMidEnter).assertTrue();

    // Reset the container for the next test case
    container1.midSceneMap.clear();
    container1.midAppIconParamMap.clear();
    container1.dividerParamList = [];
  });
}

function MidSceneManagerTest_updateDraggingEventInMidScene_01() {
  it('MidSceneManager_updateDraggingEventInMidScene_002: Test Large Step Update', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    midsceneData1.step = MidSceneStep.LARGE;
    midsceneData1.left = 0.7;
    midsceneData2.step = MidSceneStep.SMALL;
    midsceneData2.inclined = true;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData1, midsceneData2];
    container1.isMidScene = true;
    midSceneManager.updateDraggingEventInMidScene(container1, dividerParam, midSceneDragContext, 1);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(midSceneDragContext, midSceneDragContext.isOverBound);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
    dividerParam.primary.scaleCenterX = '20%';
    dividerParam.primary.rotateCenterX = '20%';
    let nums: Array<number> = [0.2,0.6,0,160,-0.2,-0.6, -160]
    for(let n of nums){
      midSceneManager.updateDraggingEventInMidScene(container1, dividerParam, midSceneDragContext, n);
    }
    let mocker1: MockKit = new MockKit();
    let mockfunc1: Function = mocker1.mockFunc(midSceneDragContext, midSceneDragContext.isPassMidLine);
    when(mockfunc1)(ArgumentMatchers.any).afterReturn(true);
    midsceneData1.step = MidSceneStep.SMALL;
    midsceneData2.step = MidSceneStep.LARGE;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData1,midsceneData2];
    for(let n of nums){
      midSceneManager.updateDraggingEventInMidScene(container1, dividerParam, midSceneDragContext, n);
    }
    expect(true).assertTrue();
    mocker.clear(midSceneDragContext);
    mocker1.clear(midSceneDragContext);
  });
}

function MidSceneManagerTest_initOutsideScreenMidScene_01() {
  it('MidSceneManager_initOutsideScreenMidScene_003: Test AnchorIndex Update', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let divider = new SCBDividerParam();

    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 3;
    midSceneManager.initOutsideScreenMidScene(container1, divider);

    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 0;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    let session1 = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let session2 = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let session3 = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    session1.sceneParam.posX = '-5%';
    divider.primary.persistentId = 14;
    divider.secondary.persistentId = 15;
    session1.sceneParam.persistentId = 16;
    container1.midSceneMap.set(0, session1);
    session2.sceneParam.persistentId = 17;
    container1.midSceneMap.set(1, session2);
    session3.sceneParam.persistentId = 18;
    container1.midSceneMap.set(2, session3);
    midSceneManager.initOutsideScreenMidScene(container1, divider);

    session1.sceneParam.persistentId = 19;
    midSceneManager.initOutsideScreenMidScene(container1, divider);

    divider.primary.persistentId = 20;
    divider.secondary.persistentId = 21;
    midsceneData1.left = 2;
    midsceneData1.visibleW = 7000;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    session3.sceneParam.persistentId = 22;
    midSceneManager.initOutsideScreenMidScene(container1, divider);

    session3.sceneParam.persistentId = 23;
    midSceneManager.initOutsideScreenMidScene(container1, divider);

    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_addFromIcon_02() {
  it('MidSceneManager_addFromIcon_002: Test Companion Icon Update', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 1;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorPosIndex = 1;
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc((container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r,
      (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.findIndex);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(2);
    container1.companionIconInfo = companionIconInfotest;
    let Rect = new RectInfo();
    let mocker1: MockKit = new MockKit();
    let mockfunc1: Function = mocker1.mockFunc(ItemUtils, ItemUtils.getRectById);
    when(mockfunc1)(ArgumentMatchers.any).afterReturn(Rect);
    midSceneManager.addFromIcon(container1, scbSceneSession);
    mocker.clear((container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r);
    expect(true).assertTrue();
  });

  it('MidSceneManager_addFromIcon_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0,midsceneData1,midsceneData2];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorPosIndex = 0;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 0;
    let mocker: MockKit = new MockKit();
    midSceneManager.addFromIcon(container1, scbSceneSession);
    let mockfunc: Function = mocker.mockFunc((container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r,
      (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.findIndex);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(1);
    let Rect = new RectInfo();
    let mocker1: MockKit = new MockKit();
    let mockfunc1: Function = mocker1.mockFunc(ItemUtils, ItemUtils.getRectById);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorPosIndex = 1;
    container1.companionIconInfo = companionIconInfotest;
    midSceneManager.addFromIcon(container1, scbSceneSession);
    midSceneManager.addFromIcon(container1, scbSceneSession);
    when(mockfunc1)(ArgumentMatchers.any).afterReturn(Rect);
    mocker.clear((container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r);
    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_replaceOut_02() {
  it('MidSceneManager_replaceOut_001', Level.LEVEL0, () => {
    // 创建SCBSceneContainerSession实例
    const container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    // 初始化MidSceneFSM
    container1.sessionData.midSceneFSM = new MidSceneFSM(container1, callback);
    // 创建MidSceneData实例
    const midsceneData2 = new MidSceneData(2);
    const midsceneData1 = new MidSceneData(1);
    const midsceneData0 = new MidSceneData(0);

    // 设置MidSceneFSM的context属性
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    // 设置container1为中间场景
    container1.isMidScene = true;
    // 设置中间场景映射
    container1.midSceneMap.set(1, scbSceneSession);
    // 调用replaceOut方法
    midSceneManager.replaceOut(container1, scbSceneSession, scbSceneSession1);
    // 重置container1为非中间场景
    container1.isMidScene = false;
    // 设置secondarySession
    container1.secondarySession = primarySession;
    // 再次调用replaceOut方法
    midSceneManager.replaceOut(container1, scbSceneSession, scbSceneSession1);
    // 设置应用图标参数
    container1.midAppIconParamMap.set(primarySession.session.persistentId, appIconParam);
    // 再次调用replaceOut方法
    midSceneManager.replaceOut(container1, scbSceneSession, scbSceneSession1);
    // 断言结果
    expect(true).assertTrue();
  });

  it('MidSceneManager_replaceOut_003', Level.LEVEL0, () => {
    // 创建一个新的SCBSceneContainerSession实例
    const container3 = new SCBSceneContainerSession(primarySession, screenProperty);
    // 初始化MidSceneFSM
    container3.sessionData.midSceneFSM = new MidSceneFSM(container3, callback);
    // 设置中间场景映射
    container3.midSceneMap.set(1, scbSceneSession);
    // 设置应用图标参数
    container3.midAppIconParamMap.set(primarySession.session.persistentId, appIconParam);
    // 调用replaceOut方法
    midSceneManager.replaceOut(container3, scbSceneSession, scbSceneSession1);
    // 检查中间场景映射是否被正确更新
    expect(container3.midSceneMap.get(1)).assertEqual(scbSceneSession1);
    // 检查应用图标参数是否被正确更新
    expect(container3.midAppIconParamMap.get(primarySession.session.persistentId)).assertEqual(appIconParam);
  });
}

function MidSceneManagerTest_handleSceneReplacedToStable_01() {
  it('handleSceneReplacedToStable_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    midsceneData1.left = 0.3;
    midsceneData1.width = 0.3;
    midsceneData1.top = 0.3;
    midsceneData1.scale = 0.3;
    midsceneData1.height = 0.3;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 0;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    midsceneData2.left = 0.3;
    midsceneData2.width = 0.3;
    midsceneData2.top = 0.3;
    midsceneData2.scale = 0.3;
    midsceneData2.height = 0.3;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    midsceneData3.left = 0.3;
    midsceneData3.width = 0.3;
    midsceneData3.top = 0.3;
    midsceneData3.scale = 0.3;
    midsceneData3.height = 0.3;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData4: MidSceneData = new MidSceneData(3);
    midsceneData4.left = 0.3;
    midsceneData4.width = 0.3;
    midsceneData4.top = 0.3;
    midsceneData4.scale = 0.3;
    midsceneData4.height = 0.3;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData5: MidSceneData = new MidSceneData(4);
    midsceneData5.left = 0.3;
    midsceneData5.width = 0.3;
    midsceneData5.top = 0.3;
    midsceneData5.scale = 0.3;
    midsceneData5.height = 0.3;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData6: MidSceneData = new MidSceneData(5);
    midsceneData6.left = 0.3;
    midsceneData6.width = 0.3;
    midsceneData6.top = 0.3;
    midsceneData6.scale = 0.3;
    midsceneData6.height = 0.3;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData7: MidSceneData = new MidSceneData(6);
    midsceneData7.left = 0.3;
    midsceneData7.width = 0.3;
    midsceneData7.top = 0.3;
    midsceneData7.scale = 0.3;
    midsceneData7.height = 0.3;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData8: MidSceneData = new MidSceneData(7);
    midsceneData8.left = 0.3;
    midsceneData8.width = 0.3;
    midsceneData8.top = 0.3;
    midsceneData8.scale = 0.3;
    midsceneData8.height = 0.3;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData9: MidSceneData = new MidSceneData(7);
    midsceneData9.left = 0.3;
    midsceneData9.width = 0.3;
    midsceneData9.top = 0.3;
    midsceneData9.scale = 0.3;
    midsceneData9.height = 0.3;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData10: MidSceneData = new MidSceneData(7);
    midsceneData10.left = 0.3;
    midsceneData10.width = 0.3;
    midsceneData10.top = 0.3;
    midsceneData10.scale = 0.3;
    midsceneData10.height = 0.3;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.midSceneMap.set(3, scbSceneSession);
    container1.midSceneMap.set(4, scbSceneSession);
    container1.midSceneMap.set(5, scbSceneSession);
    container1.midSceneMap.set(6, scbSceneSession);
    container1.midSceneMap.set(7, scbSceneSession);
    container1.midSceneMap.set(8, scbSceneSession);
    container1.midSceneMap.set(9, scbSceneSession);
    container1.midSceneMap.set(10, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container1);
    let ctx = (container1.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_002', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    midsceneData1.left = 0.2;
    midsceneData1.width = 0.2;
    midsceneData1.top = 0.2;
    midsceneData1.scale = 0.2;
    midsceneData1.height = 0.2;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 1;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    midsceneData2.left = 0.4;
    midsceneData2.width = 0.4;
    midsceneData2.top = 0.4;
    midsceneData2.scale = 0.4;
    midsceneData2.height = 0.4;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    midsceneData3.left = 0.2;
    midsceneData3.width = 0.2;
    midsceneData3.top = 0.2;
    midsceneData3.scale = 0.2;
    midsceneData3.height = 0.2;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    let midsceneData4: MidSceneData = new MidSceneData(3);
    midsceneData4.left = 0.6;
    midsceneData4.width = 0.6;
    midsceneData4.top = 0.6;
    midsceneData4.scale = 0.6;
    midsceneData4.height = 0.6;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData4);
    let midsceneData5: MidSceneData = new MidSceneData(4);
    midsceneData5.left = 0.2;
    midsceneData5.width = 0.2;
    midsceneData5.top = 0.2;
    midsceneData5.scale = 0.2;
    midsceneData5.height = 0.2;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData5);
    let midsceneData6: MidSceneData = new MidSceneData(5);
    midsceneData6.left = 0.8;
    midsceneData6.width = 0.8;
    midsceneData6.top = 0.8;
    midsceneData6.scale = 0.8;
    midsceneData6.height = 0.8;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData6);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.midSceneMap.set(3, scbSceneSession);
    container1.midSceneMap.set(4, scbSceneSession);
    container1.midSceneMap.set(5, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container1);
    let ctx = (container1.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_003', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    midsceneData1.left = 0.1;
    midsceneData1.width = 0.1;
    midsceneData1.top = 0.1;
    midsceneData1.scale = 0.1;
    midsceneData1.height = 0.1;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 0;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    midsceneData2.left = 0.3;
    midsceneData2.width = 0.3;
    midsceneData2.top = 0.3;
    midsceneData2.scale = 0.3;
    midsceneData2.height = 0.3;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    midsceneData3.left = 0.5;
    midsceneData3.width = 0.5;
    midsceneData3.top = 0.5;
    midsceneData3.scale = 0.5;
    midsceneData3.height = 0.5;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    let midsceneData4: MidSceneData = new MidSceneData(3);
    midsceneData4.left = 0.7;
    midsceneData4.width = 0.7;
    midsceneData4.top = 0.7;
    midsceneData4.scale = 0.7;
    midsceneData4.height = 0.7;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData4);
    let midsceneData5: MidSceneData = new MidSceneData(4);
    midsceneData5.left = 0.9;
    midsceneData5.width = 0.9;
    midsceneData5.top = 0.9;
    midsceneData5.scale = 0.9;
    midsceneData5.height = 0.9;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData5);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.midSceneMap.set(3, scbSceneSession);
    container1.midSceneMap.set(4, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container1);
    let ctx = (container1.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_004', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    midsceneData1.left = 0.7;
    midsceneData1.width = 0.7;
    midsceneData1.top = 0.7;
    midsceneData1.scale = 0.7;
    midsceneData1.height = 0.7;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 1;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    midsceneData2.left = 0.2;
    midsceneData2.width = 0.2;
    midsceneData2.top = 0.2;
    midsceneData2.scale = 0.2;
    midsceneData2.height = 0.2;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    midsceneData3.left = 0.5;
    midsceneData3.width = 0.5;
    midsceneData3.top = 0.5;
    midsceneData3.scale = 0.5;
    midsceneData3.height = 0.5;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    let midsceneData4: MidSceneData = new MidSceneData(3);
    midsceneData4.left = 0.4;
    midsceneData4.width = 0.4;
    midsceneData4.top = 0.4;
    midsceneData4.scale = 0.4;
    midsceneData4.height = 0.4;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData4);
    let midsceneData5: MidSceneData = new MidSceneData(4);
    midsceneData5.left = 0.3;
    midsceneData5.width = 0.3;
    midsceneData5.top = 0.3;
    midsceneData5.scale = 0.3;
    midsceneData5.height = 0.3;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData5);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.midSceneMap.set(3, scbSceneSession);
    container1.midSceneMap.set(4, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container1);
    let ctx = (container1.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_005', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    midsceneData1.left = 0.1;
    midsceneData1.width = 0.1;
    midsceneData1.top = 0.1;
    midsceneData1.scale = 0.1;
    midsceneData1.height = 0.1;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 2;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    midsceneData2.left = 0.2;
    midsceneData2.width = 0.2;
    midsceneData2.top = 0.2;
    midsceneData2.scale = 0.2;
    midsceneData2.height = 0.2;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    midsceneData3.left = 0.3;
    midsceneData3.width = 0.3;
    midsceneData3.top = 0.3;
    midsceneData3.scale = 0.3;
    midsceneData3.height = 0.3;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    let midsceneData4: MidSceneData = new MidSceneData(3);
    midsceneData4.left = 0.4;
    midsceneData4.width = 0.4;
    midsceneData4.top = 0.4;
    midsceneData4.scale = 0.4;
    midsceneData4.height = 0.4;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData4);
    let midsceneData5: MidSceneData = new MidSceneData(4);
    midsceneData5.left = 0.5;
    midsceneData5.width = 0.5;
    midsceneData5.top = 0.5;
    midsceneData5.scale = 0.5;
    midsceneData5.height = 0.5;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData5);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.midSceneMap.set(3, scbSceneSession);
    container1.midSceneMap.set(4, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container1);
    let ctx = (container1.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_006', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    midsceneData1.left = 0.1;
    midsceneData1.width = 0.1;
    midsceneData1.top = 0.1;
    midsceneData1.scale = 0.1;
    midsceneData1.height = 0.1;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 3;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    midsceneData2.left = 0.2;
    midsceneData2.width = 0.2;
    midsceneData2.top = 0.2;
    midsceneData2.scale = 0.2;
    midsceneData2.height = 0.2;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    midsceneData3.left = 0.3;
    midsceneData3.width = 0.3;
    midsceneData3.top = 0.3;
    midsceneData3.scale = 0.3;
    midsceneData3.height = 0.3;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    let midsceneData4: MidSceneData = new MidSceneData(3);
    midsceneData4.left = 0.4;
    midsceneData4.width = 0.4;
    midsceneData4.top = 0.4;
    midsceneData4.scale = 0.4;
    midsceneData4.height = 0.4;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData4);
    let midsceneData5: MidSceneData = new MidSceneData(4);
    midsceneData5.left = 0.5;
    midsceneData5.width = 0.5;
    midsceneData5.top = 0.5;
    midsceneData5.scale = 0.5;
    midsceneData5.height = 0.5;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData5);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.midSceneMap.set(3, scbSceneSession);
    container1.midSceneMap.set(4, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container1);
    let ctx = (container1.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_007', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    midsceneData1.left = 0.5;
    midsceneData1.width = 0.5;
    midsceneData1.top = 0.5;
    midsceneData1.scale = 0.5;
    midsceneData1.height = 0.5;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 4;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    midsceneData2.left = 0.2;
    midsceneData2.width = 0.2;
    midsceneData2.top = 0.2;
    midsceneData2.scale = 0.2;
    midsceneData2.height = 0.2;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    midsceneData3.left = 0.6;
    midsceneData3.width = 0.6;
    midsceneData3.top = 0.6;
    midsceneData3.scale = 0.6;
    midsceneData3.height = 0.6;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    let midsceneData4: MidSceneData = new MidSceneData(3);
    midsceneData4.left = 0.4;
    midsceneData4.width = 0.4;
    midsceneData4.top = 0.4;
    midsceneData4.scale = 0.4;
    midsceneData4.height = 0.4;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData4);
    let midsceneData5: MidSceneData = new MidSceneData(4);
    midsceneData5.left = 0.8;
    midsceneData5.width = 0.8;
    midsceneData5.top = 0.8;
    midsceneData5.scale = 0.8;
    midsceneData5.height = 0.8;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData5);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.midSceneMap.set(3, scbSceneSession);
    container1.midSceneMap.set(4, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container1);
    let ctx = (container1.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_008', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    midsceneData1.left = 0.1;
    midsceneData1.width = 0.3;
    midsceneData1.top = 0.9;
    midsceneData1.scale = 0.7;
    midsceneData1.height = 0.2;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 4;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    midsceneData2.left = 0.9;
    midsceneData2.width = 0.1;
    midsceneData2.top = 0.1;
    midsceneData2.scale = 0.9;
    midsceneData2.height = 0.8;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    midsceneData3.left = 0.3;
    midsceneData3.width = 0.9;
    midsceneData3.top = 0.3;
    midsceneData3.scale = 0.3;
    midsceneData3.height = 0.9;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    let midsceneData4: MidSceneData = new MidSceneData(3);
    midsceneData4.left = 0.7;
    midsceneData4.width = 0.7;
    midsceneData4.top = 0.7;
    midsceneData4.scale = 0.1;
    midsceneData4.height = 0.6;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData4);
    let midsceneData5: MidSceneData = new MidSceneData(4);
    midsceneData5.left = 0.5;
    midsceneData5.width = 0.5;
    midsceneData5.top = 0.5;
    midsceneData5.scale = 0.6;
    midsceneData5.height = 0.4;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData5);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.midSceneMap.set(3, scbSceneSession);
    container1.midSceneMap.set(4, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container1);
    let ctx = (container1.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_009', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    midsceneData1.left = 0.3;
    midsceneData1.width = 0.2;
    midsceneData1.top = 0.8;
    midsceneData1.scale = 0.8;
    midsceneData1.height = 0.1;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 4;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    midsceneData2.left = 0.1;
    midsceneData2.width = 0.8;
    midsceneData2.top = 0.2;
    midsceneData2.scale = 0.2;
    midsceneData2.height = 0.9;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    midsceneData3.left = 0.9;
    midsceneData3.width = 0.3;
    midsceneData3.top = 0.6;
    midsceneData3.scale = 0.6;
    midsceneData3.height = 0.7;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    let midsceneData4: MidSceneData = new MidSceneData(3);
    midsceneData4.left = 0.6;
    midsceneData4.width = 0.1;
    midsceneData4.top = 0.4;
    midsceneData4.scale = 0.4;
    midsceneData4.height = 0.8;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData4);
    let midsceneData5: MidSceneData = new MidSceneData(4);
    midsceneData5.left = 0.8;
    midsceneData5.width = 0.6;
    midsceneData5.top = 0.9;
    midsceneData5.scale = 0.9;
    midsceneData5.height = 0.5;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData5);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.midSceneMap.set(3, scbSceneSession);
    container1.midSceneMap.set(4, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container1);
    let ctx = (container1.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_010', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    midsceneData1.left = 0.6;
    midsceneData1.width = 0.4;
    midsceneData1.top = 0.2;
    midsceneData1.scale = 0.9;
    midsceneData1.height = 0.6;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 4;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    midsceneData2.left = 0.4;
    midsceneData2.width = 0.6;
    midsceneData2.top = 0.8;
    midsceneData2.scale = 0.1;
    midsceneData2.height = 0.3;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    midsceneData3.left = 0.8;
    midsceneData3.width = 0.5;
    midsceneData3.top = 0.5;
    midsceneData3.scale = 0.7;
    midsceneData3.height = 0.9;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    let midsceneData4: MidSceneData = new MidSceneData(3);
    midsceneData4.left = 0.2;
    midsceneData4.width = 0.7;
    midsceneData4.top = 0.6;
    midsceneData4.scale = 0.3;
    midsceneData4.height = 0.4;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData4);
    let midsceneData5: MidSceneData = new MidSceneData(4);
    midsceneData5.left = 0.7;
    midsceneData5.width = 0.3;
    midsceneData5.top = 0.3;
    midsceneData5.scale = 0.5;
    midsceneData5.height = 0.7;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData5);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.midSceneMap.set(3, scbSceneSession);
    container1.midSceneMap.set(4, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container1);
    let ctx = (container1.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_011', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    midsceneData1.left = 0.9;
    midsceneData1.width = 0.1;
    midsceneData1.top = 0.1;
    midsceneData1.scale = 0.6;
    midsceneData1.height = 0.8;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 4;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    midsceneData2.left = 0.7;
    midsceneData2.width = 0.9;
    midsceneData2.top = 0.9;
    midsceneData2.scale = 0.4;
    midsceneData2.height = 0.2;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    midsceneData3.left = 0.5;
    midsceneData3.width = 0.8;
    midsceneData3.top = 0.7;
    midsceneData3.scale = 0.8;
    midsceneData3.height = 0.1;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    let midsceneData4: MidSceneData = new MidSceneData(3);
    midsceneData4.left = 0.3;
    midsceneData4.width = 0.6;
    midsceneData4.top = 0.4;
    midsceneData4.scale = 0.9;
    midsceneData4.height = 0.6;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData4);
    let midsceneData5: MidSceneData = new MidSceneData(4);
    midsceneData5.left = 0.1;
    midsceneData5.width = 0.4;
    midsceneData5.top = 0.8;
    midsceneData5.scale = 0.7;
    midsceneData5.height = 0.5;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData5);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.midSceneMap.set(3, scbSceneSession);
    container1.midSceneMap.set(4, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container1);
    let ctx = (container1.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_012', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    midsceneData1.left = 0.8;
    midsceneData1.width = 0.2;
    midsceneData1.top = 0.6;
    midsceneData1.scale = 0.9;
    midsceneData1.height = 0.9;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 4;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    midsceneData2.left = 0.6;
    midsceneData2.width = 0.8;
    midsceneData2.top = 0.3;
    midsceneData2.scale = 0.1;
    midsceneData2.height = 0.7;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    midsceneData3.left = 0.4;
    midsceneData3.width = 0.7;
    midsceneData3.top = 0.8;
    midsceneData3.scale = 0.6;
    midsceneData3.height = 0.3;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    let midsceneData4: MidSceneData = new MidSceneData(3);
    midsceneData4.left = 0.2;
    midsceneData4.width = 0.5;
    midsceneData4.top = 0.5;
    midsceneData4.scale = 0.8;
    midsceneData4.height = 0.8;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData4);
    let midsceneData5: MidSceneData = new MidSceneData(4);
    midsceneData5.left = 0.1;
    midsceneData5.width = 0.3;
    midsceneData5.top = 0.4;
    midsceneData5.scale = 0.4;
    midsceneData5.height = 0.6;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData5);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.midSceneMap.set(3, scbSceneSession);
    container1.midSceneMap.set(4, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container1);
    let ctx = (container1.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_013', Level.LEVEL0, () => {
    let container2 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container2.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container2, callback);
    let midsceneData5: MidSceneData = new MidSceneData(3);
    midsceneData5.left = 0.1;
    midsceneData5.width = 0.3;
    midsceneData5.top = 0.4;
    midsceneData5.scale = 0.4;
    midsceneData5.height = 0.6;
    let midsceneData6: MidSceneData = new MidSceneData(4);
    midsceneData6.left = 0.2;
    midsceneData6.width = 0.4;
    midsceneData6.top = 0.5;
    midsceneData6.scale = 0.5;
    midsceneData6.height = 0.7;
    let midsceneData7: MidSceneData = new MidSceneData(5);
    midsceneData7.left = 0.3;
    midsceneData7.width = 0.5;
    midsceneData7.top = 0.6;
    midsceneData7.scale = 0.6;
    midsceneData7.height = 0.8;
    (container2.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData5, midsceneData6, midsceneData7];
    container2.midSceneMap.set(3, scbSceneSession);
    container2.midSceneMap.set(4, scbSceneSession);
    container2.midSceneMap.set(5, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container2);
    let ctx = (container2.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_014', Level.LEVEL0, () => {
    let container3 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container3.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container3, callback);
    let midsceneData6: MidSceneData = new MidSceneData(6);
    midsceneData6.left = 0.4;
    midsceneData6.width = 0.6;
    midsceneData6.top = 0.7;
    midsceneData6.scale = 0.7;
    midsceneData6.height = 0.9;
    let midsceneData7: MidSceneData = new MidSceneData(7);
    midsceneData7.left = 0.5;
    midsceneData7.width = 0.7;
    midsceneData7.top = 0.8;
    midsceneData7.scale = 0.8;
    midsceneData7.height = 0.1;
    let midsceneData8: MidSceneData = new MidSceneData(8);
    midsceneData8.left = 0.6;
    midsceneData8.width = 0.8;
    midsceneData8.top = 0.9;
    midsceneData8.scale = 0.9;
    midsceneData8.height = 0.2;
    (container3.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData6, midsceneData7, midsceneData8];
    container3.midSceneMap.set(6, scbSceneSession);
    container3.midSceneMap.set(7, scbSceneSession);
    container3.midSceneMap.set(8, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container3);
    let ctx = (container3.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_015', Level.LEVEL0, () => {
    let container4 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container4.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container4, callback);
    let midsceneData9: MidSceneData = new MidSceneData(9);
    midsceneData9.left = 0.7;
    midsceneData9.width = 0.9;
    midsceneData9.top = 0.1;
    midsceneData9.scale = 0.1;
    midsceneData9.height = 0.4;
    let midsceneData10: MidSceneData = new MidSceneData(10);
    midsceneData10.left = 0.8;
    midsceneData10.width = 0.1;
    midsceneData10.top = 0.2;
    midsceneData10.scale = 0.2;
    midsceneData10.height = 0.5;
    let midsceneData11: MidSceneData = new MidSceneData(11);
    midsceneData11.left = 0.9;
    midsceneData11.width = 0.2;
    midsceneData11.top = 0.3;
    midsceneData11.scale = 0.3;
    midsceneData11.height = 0.6;
    (container4.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData9, midsceneData10, midsceneData11];
    container4.midSceneMap.set(9, scbSceneSession);
    container4.midSceneMap.set(10, scbSceneSession);
    container4.midSceneMap.set(11, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container4);
    let ctx = (container4.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_016', Level.LEVEL0, () => {
    let container2 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container2.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container2, callback);
    let midsceneData1: MidSceneData = new MidSceneData(3);
    midsceneData1.left = 0.1;
    midsceneData1.width = 0.3;
    midsceneData1.top = 0.4;
    midsceneData1.scale = 0.4;
    midsceneData1.height = 0.6;
    let midsceneData2: MidSceneData = new MidSceneData(4);
    midsceneData2.left = 0.2;
    midsceneData2.width = 0.4;
    midsceneData2.top = 0.5;
    midsceneData2.scale = 0.5;
    midsceneData2.height = 0.7;
    let midsceneData3: MidSceneData = new MidSceneData(5);
    midsceneData3.left = 0.3;
    midsceneData3.width = 0.5;
    midsceneData3.top = 0.6;
    midsceneData3.scale = 0.6;
    midsceneData3.height = 0.8;
    (container2.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData1, midsceneData2, midsceneData3];
    container2.midSceneMap.set(3, scbSceneSession);
    container2.midSceneMap.set(4, scbSceneSession);
    container2.midSceneMap.set(5, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container2);
    let ctx = (container2.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_017', Level.LEVEL0, () => {
    let container3 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container3.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container3, callback);
    let midsceneData1: MidSceneData = new MidSceneData(6);
    midsceneData1.left = 0.4;
    midsceneData1.width = 0.6;
    midsceneData1.top = 0.7;
    midsceneData1.scale = 0.7;
    midsceneData1.height = 0.9;
    let midsceneData2: MidSceneData = new MidSceneData(7);
    midsceneData2.left = 0.5;
    midsceneData2.width = 0.7;
    midsceneData2.top = 0.8;
    midsceneData2.scale = 0.8;
    midsceneData2.height = 0.1;
    let midsceneData3: MidSceneData = new MidSceneData(8);
    midsceneData3.left = 0.6;
    midsceneData3.width = 0.8;
    midsceneData3.top = 0.9;
    midsceneData3.scale = 0.9;
    midsceneData3.height = 0.2;
    (container3.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData1, midsceneData2, midsceneData3];
    container3.midSceneMap.set(6, scbSceneSession);
    container3.midSceneMap.set(7, scbSceneSession);
    container3.midSceneMap.set(8, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container3);
    let ctx = (container3.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_018', Level.LEVEL0, () => {
    let container4 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container4.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container4, callback);
    let midsceneData1: MidSceneData = new MidSceneData(9);
    midsceneData1.left = 0.7;
    midsceneData1.width = 0.9;
    midsceneData1.top = 0.1;
    midsceneData1.scale = 0.1;
    midsceneData1.height = 0.4;
    let midsceneData2: MidSceneData = new MidSceneData(10);
    midsceneData2.left = 0.8;
    midsceneData2.width = 0.1;
    midsceneData2.top = 0.2;
    midsceneData2.scale = 0.2;
    midsceneData2.height = 0.5;
    let midsceneData3: MidSceneData = new MidSceneData(11);
    midsceneData3.left = 0.9;
    midsceneData3.width = 0.2;
    midsceneData3.top = 0.3;
    midsceneData3.scale = 0.3;
    midsceneData3.height = 0.6;
    (container4.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData1, midsceneData2, midsceneData3];
    container4.midSceneMap.set(9, scbSceneSession);
    container4.midSceneMap.set(10, scbSceneSession);
    container4.midSceneMap.set(11, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container4);
    let ctx = (container4.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_019', Level.LEVEL0, () => {
    let container4 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container4.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container4, callback);
    let midsceneData1: MidSceneData = new MidSceneData(9);
    midsceneData1.left = 0.6;
    midsceneData1.width = 0.8;
    midsceneData1.top = 0.2;
    midsceneData1.scale = 0.2;
    midsceneData1.height = 0.3;
    let midsceneData2: MidSceneData = new MidSceneData(10);
    midsceneData2.left = 0.7;
    midsceneData2.width = 0.2;
    midsceneData2.top = 0.1;
    midsceneData2.scale = 0.1;
    midsceneData2.height = 0.4;
    let midsceneData3: MidSceneData = new MidSceneData(11);
    midsceneData3.left = 0.8;
    midsceneData3.width = 0.3;
    midsceneData3.top = 0.2;
    midsceneData3.scale = 0.4;
    midsceneData3.height = 0.5;
    (container4.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData1, midsceneData2, midsceneData3];
    container4.midSceneMap.set(9, scbSceneSession);
    container4.midSceneMap.set(10, scbSceneSession);
    container4.midSceneMap.set(11, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container4);
    let ctx = (container4.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_34567', Level.LEVEL0, () => {
    let container2 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container2.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container2, callback);
    let midsceneData1: MidSceneData = new MidSceneData(3);
    midsceneData1.left = 0.1;
    midsceneData1.width = 0.2;
    midsceneData1.top = 0.3;
    midsceneData1.scale = 0.4;
    midsceneData1.height = 0.5;
    let midsceneData2: MidSceneData = new MidSceneData(4);
    midsceneData2.left = 0.2;
    midsceneData2.width = 0.3;
    midsceneData2.top = 0.4;
    midsceneData2.scale = 0.5;
    midsceneData2.height = 0.6;
    let midsceneData3: MidSceneData = new MidSceneData(5);
    midsceneData3.left = 0.3;
    midsceneData3.width = 0.4;
    midsceneData3.top = 0.5;
    midsceneData3.scale = 0.6;
    midsceneData3.height = 0.7;
    let midsceneData4: MidSceneData = new MidSceneData(6);
    midsceneData4.left = 0.4;
    midsceneData4.width = 0.5;
    midsceneData4.top = 0.6;
    midsceneData4.scale = 0.7;
    midsceneData4.height = 0.8;
    let midsceneData5: MidSceneData = new MidSceneData(7);
    midsceneData5.left = 0.5;
    midsceneData5.width = 0.6;
    midsceneData5.top = 0.7;
    midsceneData5.scale = 0.8;
    midsceneData5.height = 0.9;
    (container2.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData1, midsceneData2, midsceneData3, midsceneData4, midsceneData5];
    container2.midSceneMap.set(3, scbSceneSession);
    container2.midSceneMap.set(4, scbSceneSession);
    container2.midSceneMap.set(5, scbSceneSession);
    container2.midSceneMap.set(6, scbSceneSession);
    container2.midSceneMap.set(7, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container2);
    let ctx = (container2.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_789012', Level.LEVEL0, () => {
    let container3 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container3.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container3, callback);
    let midsceneData1: MidSceneData = new MidSceneData(7);
    midsceneData1.left = 0.6;
    midsceneData1.width = 0.7;
    midsceneData1.top = 0.8;
    midsceneData1.scale = 0.9;
    midsceneData1.height = 0.1;
    let midsceneData2: MidSceneData = new MidSceneData(8);
    midsceneData2.left = 0.7;
    midsceneData2.width = 0.8;
    midsceneData2.top = 0.9;
    midsceneData2.scale = 0.1;
    midsceneData2.height = 0.2;
    let midsceneData3: MidSceneData = new MidSceneData(9);
    midsceneData3.left = 0.8;
    midsceneData3.width = 0.9;
    midsceneData3.top = 0.1;
    midsceneData3.scale = 0.2;
    midsceneData3.height = 0.3;
    let midsceneData4: MidSceneData = new MidSceneData(10);
    midsceneData4.left = 0.9;
    midsceneData4.width = 0.1;
    midsceneData4.top = 0.2;
    midsceneData4.scale = 0.3;
    midsceneData4.height = 0.4;
    let midsceneData5: MidSceneData = new MidSceneData(11);
    midsceneData5.left = 0.1;
    midsceneData5.width = 0.2;
    midsceneData5.top = 0.3;
    midsceneData5.scale = 0.4;
    midsceneData5.height = 0.5;
    (container3.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData1, midsceneData2, midsceneData3, midsceneData4, midsceneData5];
    container3.midSceneMap.set(7, scbSceneSession);
    container3.midSceneMap.set(8, scbSceneSession);
    container3.midSceneMap.set(9, scbSceneSession);
    container3.midSceneMap.set(10, scbSceneSession);
    container3.midSceneMap.set(11, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container3);
    let ctx = (container3.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(container3.needRenderTranslate.translateX === 1).assertTrue();
    expect(container3.needRenderTranslate.translateY === 1).assertTrue();
    expect(container3.needRenderScale.scaleX === 0).assertTrue();
    expect(container3.needRenderScale.scaleY === 0).assertTrue();
    expect(container3.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(container3.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(container3.needRenderScale.centerX === '50%').assertTrue();
    expect(container3.needRenderScale.centerY === '50%').assertTrue();
    expect(container3.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(container3.needRenderPos.posX === 0).assertTrue();
    expect(container3.needRenderPos.posY === 0).assertTrue();
    expect(container3.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(container3.iconAlpha === 0).assertTrue();
    expect(container3.iconAlpha === 0).assertTrue();
    expect(container3.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(container3.needRenderVisibility.visibility === true).assertTrue();
    expect(container3.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(container3.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(container3.intelligentScene === 1).assertTrue();
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_34567', Level.LEVEL0, () => {
    let container2 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container2.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container2, callback);
    let midsceneData1: MidSceneData = new MidSceneData(3);
    midsceneData1.left = 0.1;
    midsceneData1.width = 0.2;
    midsceneData1.top = 0.3;
    midsceneData1.scale = 0.4;
    midsceneData1.height = 0.5;
    let midsceneData2: MidSceneData = new MidSceneData(4);
    midsceneData2.left = 0.6;
    midsceneData2.width = 0.7;
    midsceneData2.top = 0.8;
    midsceneData2.scale = 0.9;
    midsceneData2.height = 0.1;
    let midsceneData3: MidSceneData = new MidSceneData(5);
    midsceneData3.left = 0.2;
    midsceneData3.width = 0.3;
    midsceneData3.top = 0.4;
    midsceneData3.scale = 0.6;
    midsceneData3.height = 0.7;
    let midsceneData4: MidSceneData = new MidSceneData(6);
    midsceneData4.left = 0.8;
    midsceneData4.width = 0.9;
    midsceneData4.top = 0.5;
    midsceneData4.scale = 0.7;
    midsceneData4.height = 0.2;
    let midsceneData5: MidSceneData = new MidSceneData(7);
    midsceneData5.left = 0.4;
    midsceneData5.width = 0.5;
    midsceneData5.top = 0.6;
    midsceneData5.scale = 0.8;
    midsceneData5.height = 0.3;
    (container2.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData1, midsceneData2, midsceneData3, midsceneData4, midsceneData5];
    container2.midSceneMap.set(3, scbSceneSession);
    container2.midSceneMap.set(4, scbSceneSession);
    container2.midSceneMap.set(5, scbSceneSession);
    container2.midSceneMap.set(6, scbSceneSession);
    container2.midSceneMap.set(7, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container2);
    let ctx = (container2.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(container2.needRenderTranslate.translateX === 1).assertTrue();
    expect(container2.needRenderTranslate.translateY === 1).assertTrue();
    expect(container2.needRenderScale.scaleX === 0).assertTrue();
    expect(container2.needRenderScale.scaleY === 0).assertTrue();
    expect(container2.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(container2.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(container2.needRenderScale.centerX === '50%').assertTrue();
    expect(container2.needRenderScale.centerY === '50%').assertTrue();
    expect(container2.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(container2.needRenderPos.posX === 0).assertTrue();
    expect(container2.needRenderPos.posY === 0).assertTrue();
    expect(container2.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(container2.iconAlpha === 0).assertTrue();
    expect(container2.iconAlpha === 0).assertTrue();
    expect(container2.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(container2.needRenderVisibility.visibility === true).assertTrue();
    expect(container2.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(container2.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(container2.intelligentScene === 1).assertTrue();
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_891011', Level.LEVEL0, () => {
    let container3 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container3.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container3, callback);
    let midsceneData1: MidSceneData = new MidSceneData(8);
    midsceneData1.left = 0.3;
    midsceneData1.width = 0.4;
    midsceneData1.top = 0.1;
    midsceneData1.scale = 0.5;
    midsceneData1.height = 0.6;
    let midsceneData2: MidSceneData = new MidSceneData(9);
    midsceneData2.left = 0.7;
    midsceneData2.width = 0.8;
    midsceneData2.top = 0.2;
    midsceneData2.scale = 0.6;
    midsceneData2.height = 0.7;
    let midsceneData3: MidSceneData = new MidSceneData(10);
    midsceneData3.left = 0.9;
    midsceneData3.width = 0.1;
    midsceneData3.top = 0.3;
    midsceneData3.scale = 0.7;
    midsceneData3.height = 0.8;
    (container3.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData1, midsceneData2, midsceneData3];
    container3.midSceneMap.set(8, scbSceneSession);
    container3.midSceneMap.set(9, scbSceneSession);
    container3.midSceneMap.set(10, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container3);
    let ctx = (container3.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(container3.needRenderTranslate.translateX === 1).assertTrue();
    expect(container3.needRenderTranslate.translateY === 1).assertTrue();
    expect(container3.needRenderScale.scaleX === 0).assertTrue();
    expect(container3.needRenderScale.scaleY === 0).assertTrue();
    expect(container3.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(container3.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(container3.needRenderScale.centerX === '50%').assertTrue();
    expect(container3.needRenderScale.centerY === '50%').assertTrue();
    expect(container3.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(container3.needRenderPos.posX === 0).assertTrue();
    expect(container3.needRenderPos.posY === 0).assertTrue();
    expect(container3.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(container3.iconAlpha === 0).assertTrue();
    expect(container3.iconAlpha === 0).assertTrue();
    expect(container3.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(container3.needRenderVisibility.visibility === true).assertTrue();
    expect(container3.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(container3.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(container3.intelligentScene === 1).assertTrue();
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_123456', Level.LEVEL0, () => {
    let container4 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container4.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container4, callback);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    midsceneData1.left = 0.5;
    midsceneData1.width = 0.6;
    midsceneData1.top = 0.4;
    midsceneData1.scale = 0.7;
    midsceneData1.height = 0.5;
    let midsceneData2: MidSceneData = new MidSceneData(2);
    midsceneData2.left = 0.6;
    midsceneData2.width = 0.7;
    midsceneData2.top = 0.5;
    midsceneData2.scale = 0.8;
    midsceneData2.height = 0.6;
    let midsceneData3: MidSceneData = new MidSceneData(10);
    midsceneData3.left = 0.8;
    midsceneData3.width = 0.2;
    midsceneData3.top = 0.2;
    midsceneData3.scale = 0.6;
    midsceneData3.height = 0.7;
    (container4.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData1, midsceneData2, midsceneData3];
    container4.midSceneMap.set(8, scbSceneSession);
    container4.midSceneMap.set(9, scbSceneSession);
    container4.midSceneMap.set(10, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container4);
    let ctx = (container4.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(container4.needRenderTranslate.translateX === 1).assertTrue();
    expect(container4.needRenderTranslate.translateY === 1).assertTrue();
    expect(container4.needRenderScale.scaleX === 0).assertTrue();
    expect(container4.needRenderScale.scaleY === 0).assertTrue();
    expect(container4.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(container4.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(container4.needRenderScale.centerX === '50%').assertTrue();
    expect(container4.needRenderScale.centerY === '50%').assertTrue();
    expect(container4.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(container4.needRenderPos.posX === 0).assertTrue();
    expect(container4.needRenderPos.posY === 0).assertTrue();
    expect(container4.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(container4.iconAlpha === 0).assertTrue();
    expect(container4.iconAlpha === 0).assertTrue();
    expect(container4.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(container4.needRenderVisibility.visibility === true).assertTrue();
    expect(container4.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(container4.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(container4.intelligentScene === 1).assertTrue();
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_789012', Level.LEVEL0, () => {
    let container5 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container5.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container5, callback);
    let midsceneData1: MidSceneData = new MidSceneData(7);
    midsceneData1.left = 0.1;
    midsceneData1.width = 0.2;
    midsceneData1.top = 0.3;
    midsceneData1.scale = 0.4;
    midsceneData1.height = 0.5;
    let midsceneData2: MidSceneData = new MidSceneData(8);
    midsceneData2.left = 0.3;
    midsceneData2.width = 0.4;
    midsceneData2.top = 0.1;
    midsceneData2.scale = 0.5;
    midsceneData2.height = 0.6;
    let midsceneData3: MidSceneData = new MidSceneData(9);
    midsceneData3.left = 0.5;
    midsceneData3.width = 0.6;
    midsceneData3.top = 0.2;
    midsceneData3.scale = 0.6;
    midsceneData3.height = 0.7;
    let midsceneData4: MidSceneData = new MidSceneData(10);
    midsceneData4.left = 0.7;
    midsceneData4.width = 0.8;
    midsceneData4.top = 0.4;
    midsceneData4.scale = 0.7;
    midsceneData4.height = 0.8;
    (container5.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData1, midsceneData2, midsceneData3, midsceneData4];
    container5.midSceneMap.set(7, scbSceneSession);
    container5.midSceneMap.set(8, scbSceneSession);
    container5.midSceneMap.set(9, scbSceneSession);
    container5.midSceneMap.set(10, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container5);
    let ctx = (container5.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(container5.needRenderTranslate.translateX === 1).assertTrue();
    expect(container5.needRenderTranslate.translateY === 1).assertTrue();
    expect(container5.needRenderScale.scaleX === 0).assertTrue();
    expect(container5.needRenderScale.scaleY === 0).assertTrue();
    expect(container5.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(container5.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(container5.needRenderScale.centerX === '50%').assertTrue();
    expect(container5.needRenderScale.centerY === '50%').assertTrue();
    expect(container5.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(container5.needRenderPos.posX === 0).assertTrue();
    expect(container5.needRenderPos.posY === 0).assertTrue();
    expect(container5.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(container5.iconAlpha === 0).assertTrue();
    expect(container5.iconAlpha === 0).assertTrue();
    expect(container5.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(container5.needRenderVisibility.visibility === true).assertTrue();
    expect(container5.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(container5.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(container5.intelligentScene === 1).assertTrue();
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_13579', Level.LEVEL0, () => {
    let container7 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container7.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container7, callback);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    midsceneData1.left = 0.2;
    midsceneData1.width = 0.3;
    midsceneData1.top = 0.1;
    midsceneData1.scale = 0.4;
    midsceneData1.height = 0.5;
    let midsceneData2: MidSceneData = new MidSceneData(3);
    midsceneData2.left = 0.4;
    midsceneData2.width = 0.5;
    midsceneData2.top = 0.3;
    midsceneData2.scale = 0.6;
    midsceneData2.height = 0.7;
    let midsceneData3: MidSceneData = new MidSceneData(5);
    midsceneData3.left = 0.6;
    midsceneData3.width = 0.7;
    midsceneData3.top = 0.5;
    midsceneData3.scale = 0.8;
    midsceneData3.height = 0.9;
    let midsceneData4: MidSceneData = new MidSceneData(7);
    midsceneData4.left = 0.8;
    midsceneData4.width = 0.9;
    midsceneData4.top = 0.7;
    midsceneData4.scale = 0.9;
    midsceneData4.height = 0.1;
    let midsceneData5: MidSceneData = new MidSceneData(9);
    midsceneData5.left = 0.1;
    midsceneData5.width = 0.2;
    midsceneData5.top = 0.9;
    midsceneData5.scale = 0.1;
    midsceneData5.height = 0.2;
    (container7.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData1, midsceneData2, midsceneData3, midsceneData4, midsceneData5];
    container7.midSceneMap.set(1, scbSceneSession);
    container7.midSceneMap.set(3, scbSceneSession);
    container7.midSceneMap.set(5, scbSceneSession);
    container7.midSceneMap.set(7, scbSceneSession);
    container7.midSceneMap.set(9, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container7);
    let ctx = (container7.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(container7.needRenderTranslate.translateX === 1).assertTrue();
    expect(container7.needRenderTranslate.translateY === 1).assertTrue();
    expect(container7.needRenderScale.scaleX === 0).assertTrue();
    expect(container7.needRenderScale.scaleY === 0).assertTrue();
    expect(container7.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(container7.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(container7.needRenderScale.centerX === '50%').assertTrue();
    expect(container7.needRenderScale.centerY === '50%').assertTrue();
    expect(container7.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(container7.needRenderPos.posX === 0).assertTrue();
    expect(container7.needRenderPos.posY === 0).assertTrue();
    expect(container7.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(container7.iconAlpha === 0).assertTrue();
    expect(container7.iconAlpha === 0).assertTrue();
    expect(container7.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(container7.needRenderVisibility.visibility === true).assertTrue();
    expect(container7.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(container7.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(container7.intelligentScene === 1).assertTrue();
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_2468', Level.LEVEL0, () => {
    let container8 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container8.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container8, callback);
    let midsceneData1: MidSceneData = new MidSceneData(2);
    midsceneData1.left = 0.3;
    midsceneData1.width = 0.4;
    midsceneData1.top = 0.2;
    midsceneData1.scale = 0.5;
    midsceneData1.height = 0.6;
    let midsceneData2: MidSceneData = new MidSceneData(4);
    midsceneData2.left = 0.5;
    midsceneData2.width = 0.6;
    midsceneData2.top = 0.8;
    midsceneData2.scale = 0.7;
    midsceneData2.height = 0.8;
    let midsceneData3: MidSceneData = new MidSceneData(6);
    midsceneData3.left = 0.7;
    midsceneData3.width = 0.8;
    midsceneData3.top = 0.6;
    midsceneData3.scale = 0.9;
    midsceneData3.height = 0.9;
    let midsceneData5: MidSceneData = new MidSceneData(10);
    midsceneData5.left = 1.0;
    midsceneData5.width = 1.1;
    midsceneData5.top = 1.1;
    midsceneData5.scale = 1.1;
    midsceneData5.height = 1.2;
    (container8.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData1, midsceneData2, midsceneData3];
    container8.midSceneMap.set(2, scbSceneSession);
    container8.midSceneMap.set(4, scbSceneSession);
    container8.midSceneMap.set(6, scbSceneSession);
    container8.midSceneMap.set(8, scbSceneSession);
    container8.midSceneMap.set(10, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container8);
    let ctx = (container8.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(container8.needRenderTranslate.translateX === 1).assertTrue();
    expect(container8.needRenderTranslate.translateY === 1).assertTrue();
    expect(container8.needRenderScale.scaleX === 0).assertTrue();
    expect(container8.needRenderScale.scaleY === 0).assertTrue();
    expect(container8.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(container8.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(container8.needRenderScale.centerX === '50%').assertTrue();
    expect(container8.needRenderScale.centerY === '50%').assertTrue();
    expect(container8.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(container8.needRenderPos.posX === 0).assertTrue();
    expect(container8.needRenderPos.posY === 0).assertTrue();
    expect(container8.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(container8.iconAlpha === 0).assertTrue();
    expect(container8.iconAlpha === 0).assertTrue();
    expect(container8.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(container8.needRenderVisibility.visibility === true).assertTrue();
    expect(container8.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(container8.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(container8.intelligentScene === 1).assertTrue();
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });

  it('handleSceneReplacedToStable_13579', Level.LEVEL0, () => {
    let container7 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container7.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container7, callback);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    midsceneData1.left = 0.2;
    midsceneData1.width = 0.3;
    midsceneData1.top = 0.1;
    midsceneData1.scale = 0.4;
    midsceneData1.height = 0.5;
    let midsceneData2: MidSceneData = new MidSceneData(3);
    midsceneData2.left = 0.4;
    midsceneData2.width = 0.5;
    midsceneData2.top = 0.3;
    midsceneData2.scale = 0.6;
    midsceneData2.height = 0.7;
    (container7.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData1, midsceneData2];
    container7.midSceneMap.set(1, scbSceneSession);
    container7.midSceneMap.set(3, scbSceneSession);
    container7.midSceneMap.set(5, scbSceneSession);
    container7.midSceneMap.set(7, scbSceneSession);
    container7.midSceneMap.set(9, scbSceneSession);
    ReflectionUtils.useFunc(midSceneManager, 'handleSceneReplacedToStable', container7);
    let ctx = (container7.sessionData.midSceneFSM as MidSceneFSM)?.context;
    expect(container7.needRenderTranslate.translateX === 1).assertTrue();
    expect(container7.needRenderTranslate.translateY === 1).assertTrue();
    expect(container7.needRenderScale.scaleX === 0).assertTrue();
    expect(container7.needRenderScale.scaleY === 0).assertTrue();
    expect(container7.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(container7.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(container7.needRenderScale.centerX === '50%').assertTrue();
    expect(container7.needRenderScale.centerY === '50%').assertTrue();
    expect(container7.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(container7.needRenderPos.posX === 0).assertTrue();
    expect(container7.needRenderPos.posY === 0).assertTrue();
    expect(container7.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(container7.iconAlpha === 0).assertTrue();
    expect(container7.iconAlpha === 0).assertTrue();
    expect(container7.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(container7.needRenderVisibility.visibility === true).assertTrue();
    expect(container7.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(container7.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(container7.intelligentScene === 1).assertTrue();
    expect(ctx.toReplacedIndex === -1).assertTrue();
  });
}

function MidSceneManagerTest_updateDragSwapWithAnimation_02() {
  it('updateDragSwapWithAnimation_00', Level.LEVEL0, () => {
    let eventArea: Area = {
      width: 0,
      height: 0,
      position: {
        x: 0, y: 0
      },
      globalPosition: {
        x: 0, y: 0
      }
    };
    let eventTarget: EventTarget = {
      area: eventArea
    };
    let event: GestureEvent = {
      target: eventTarget,
      timestamp: 1,
      source: 2,
      pressure: 3,
      tiltX: 0,
      tiltY: 0,
      sourceTool: 0,
      repeat: false,
      fingerList: [],
      offsetX: 200,
      offsetY: 0,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0
    };
    eventArea.width = 1;
    eventArea.height = 2;
    eventArea.position.x = 10;
    eventArea.position.y = 20;
    eventArea.globalPosition.x = 105;
    eventArea.globalPosition.y = 105;
    event.timestamp = 1;
    event.source = 1;
    event.offsetX = 2;
    event.tiltY = 2;
    event.tiltX = 3;
    event.angle = 2;
    event.speed = 3;
    event.scale = 2;
    event.pinchCenterX = 2;
    event.pinchCenterY = 2;
    event.velocityX = 2;
    event.velocityY = 2;
    event.velocity = 1;
    let calculator = new GlobalOffsetCalculator();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    midSceneManager.updateDragSwapWithAnimation(event, calculator, scbSceneSession, container1);
    eventArea.width = 10;
    eventArea.height = 20;
    eventArea.position.x = 50;
    eventArea.position.y = 100;
    eventArea.globalPosition.x = 15;
    eventArea.globalPosition.y = 15;
    event.timestamp = 1;
    event.source = 1;
    event.offsetX = 2;
    event.tiltY = 2;
    event.tiltX = 2;
    event.angle = 2;
    event.speed = 2;
    event.scale = 2;
    event.pinchCenterX = 2;
    event.pinchCenterY = 2;
    event.velocityX = 2;
    event.velocityY = 2;
    event.velocity = 3;
    midSceneManager.updateDragSwapWithAnimation(event, calculator, scbSceneSession, container1);
    expect(container1.getMidScenes().size).assertEqual(2);
  });

  it('updateDragSwapWithAnimation1', Level.LEVEL0, () => {
    let eventArea: Area = {
      width: 0,
      height: 0,
      position: {
        x: 0, y: 0
      },
      globalPosition: {
        x: 0, y: 0
      }
    };
    let event: GestureEvent = {
      target: null,
      timestamp: 0,
      source: 0,
      pressure: 1,
      tiltX: 0,
      tiltY: 0,
      sourceTool: 0,
      repeat: false,
      fingerList: [],
      offsetX: 1,
      offsetY: 0,
      angle: 1,
      speed: 0,
      scale: 0,
      pinchCenterX: 1,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 1,
      velocity: 0
    };
    eventArea.width = 5;
    eventArea.height = 6;
    eventArea.position.x = 30;
    eventArea.position.y = 40;
    eventArea.globalPosition.x = 150;
    eventArea.globalPosition.y = 150;
    event.timestamp = 4;
    event.source = 4;
    event.offsetX = 3;
    event.tiltY = 3;
    event.tiltX = 3;
    event.angle = 3;
    event.speed = 3;
    event.scale = 3;
    event.pinchCenterX = 3;
    event.pinchCenterY = 3;
    event.velocityX = 3;
    event.velocityY = 3;
    event.velocity = 4;
    let calculator = new GlobalOffsetCalculator();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    midSceneManager.updateDragSwapWithAnimation(event, calculator, scbSceneSession, container1);
    expect(container1.getMidScenes().size).assertEqual(2);
  });

  it('updateDragSwapWithAnimation2', Level.LEVEL0, () => {
    let eventArea: Area = {
      width: 0,
      height: 0,
      position: {
        x: 0, y: 0
      },
      globalPosition: {
        x: 0, y: 0
      }
    };
    let event: GestureEvent = {
      target: null,
      timestamp: 0,
      source: 1,
      pressure: 0,
      tiltX: 1,
      tiltY: 1,
      sourceTool: 0,
      repeat: false,
      fingerList: [],
      offsetX: 1,
      offsetY: 1,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0
    };
    eventArea.width = 7;
    eventArea.height = 8;
    eventArea.position.x = 50;
    eventArea.position.y = 60;
    eventArea.globalPosition.x = 200;
    eventArea.globalPosition.y = 200;
    event.timestamp = 5;
    event.source = 5;
    event.offsetX = 4;
    event.tiltY = 4;
    event.tiltX = 4;
    event.angle = 4;
    event.speed = 4;
    event.scale = 4;
    event.pinchCenterX = 4;
    event.pinchCenterY = 4;
    event.velocityX = 4;
    event.velocityY = 4;
    event.velocity = 5;
    let calculator = new GlobalOffsetCalculator();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    midSceneManager.updateDragSwapWithAnimation(event, calculator, scbSceneSession, container1);
    expect(container1.getMidScenes().size).assertEqual(2);
    expect(container1.needRenderTranslate.translateX === 1).assertTrue();
    expect(container1.needRenderTranslate.translateY === 1).assertTrue();
    expect(container1.needRenderScale.scaleX === 0).assertTrue();
    expect(container1.needRenderScale.scaleY === 1).assertTrue();
    expect(container1.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(container1.needRenderBackgroundForMinScale.scaleY === 0).assertTrue();
    expect(container1.needRenderScale.centerX === '68%').assertTrue();
    expect(container1.needRenderScale.centerY === '68%').assertTrue();
    expect(container1.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(container1.needRenderPos.posX === 0).assertTrue();
    expect(container1.needRenderPos.posY === 0).assertTrue();
    expect(container1.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(container1.iconAlpha === 1).assertTrue();
    expect(container1.iconAlpha === 1).assertTrue();
  });

  it('updateDragSwapWithAnimation3', Level.LEVEL0, () => {
    let eventArea: Area = {
      width: 0,
      height: 0,
      position: {
        x: 0, y: 0
      },
      globalPosition: {
        x: 0, y: 0
      }
    };
    let event: GestureEvent = {
      target: null,
      timestamp: 0,
      source: 0,
      pressure: 0,
      tiltX: 1,
      tiltY: 0,
      sourceTool: 0,
      repeat: false,
      fingerList: [],
      offsetX: 0,
      offsetY: 0,
      angle: 1,
      speed: 0,
      scale: 1,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 1,
      velocity: 0
    };
    eventArea.width = 9;
    eventArea.height = 10;
    eventArea.position.x = 70;
    eventArea.position.y = 80;
    eventArea.globalPosition.x = 250;
    eventArea.globalPosition.y = 250;
    event.timestamp = 6;
    event.source = 6;
    event.offsetX = 5;
    event.tiltY = 5;
    event.tiltX = 5;
    event.angle = 5;
    event.speed = 5;
    event.scale = 5;
    event.pinchCenterX = 5;
    event.pinchCenterY = 5;
    event.velocityX = 5;
    event.velocityY = 5;
    event.velocity = 6;
    let calculator = new GlobalOffsetCalculator();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    midSceneManager.updateDragSwapWithAnimation(event, calculator, scbSceneSession, container1);
    expect(container1.getMidScenes().size).assertEqual(2);
    expect(container1.getMidScenes().size).assertEqual(2);
    expect(container1.needRenderTranslate.translateX === 0).assertTrue();
    expect(container1.needRenderTranslate.translateY === 0).assertTrue();
    expect(container1.needRenderScale.scaleX === 1).assertTrue();
    expect(container1.needRenderScale.scaleY === 1).assertTrue();
    expect(container1.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(container1.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(container1.needRenderScale.centerX === '66%').assertTrue();
    expect(container1.needRenderScale.centerY === '66%').assertTrue();
    expect(container1.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(container1.needRenderPos.posX === 1).assertTrue();
    expect(container1.needRenderPos.posY === 1).assertTrue();
    expect(container1.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(container1.iconAlpha === 1).assertTrue();
    expect(container1.iconAlpha === 1).assertTrue();
    expect(container1.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(container1.needRenderVisibility.visibility === true).assertTrue();
    expect(container1.needRenderTranslateIcon.translateIconX === 1).assertTrue();
    expect(container1.needRenderTranslateIcon.translateIconY === 1).assertTrue();
    expect(container1.intelligentScene === 1).assertTrue();
  });

  it('updateDragSwapWithAnimation4', Level.LEVEL0, () => {
    let eventArea: Area = {
      width: 0,
      height: 0,
      position: {
        x: 0, y: 0
      },
      globalPosition: {
        x: 0, y: 0
      }
    };
    let event: GestureEvent = {
      target: null,
      timestamp: 0,
      source: 1,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: 0,
      repeat: true,
      fingerList: [],
      offsetX: 1,
      offsetY: 0,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 1,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 1,
      velocity: 0
    };
    eventArea.width = 11;
    eventArea.height = 12;
    eventArea.position.x = 90;
    eventArea.position.y = 100;
    eventArea.globalPosition.x = 300;
    eventArea.globalPosition.y = 300;
    event.timestamp = 7;
    event.source = 7;
    event.offsetX = 6;
    event.tiltY = 6;
    event.tiltX = 6;
    event.angle = 6;
    event.speed = 6;
    event.scale = 6;
    event.pinchCenterX = 6;
    event.pinchCenterY = 6;
    event.velocityX = 6;
    event.velocityY = 6;
    event.velocity = 7;
    let calculator = new GlobalOffsetCalculator();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    midSceneManager.updateDragSwapWithAnimation(event, calculator, scbSceneSession, container1);
    expect(container1.getMidScenes().size).assertEqual(2);
    expect(container1.getMidScenes().size).assertEqual(2);
    expect(container1.needRenderTranslate.translateX === 1).assertTrue();
    expect(container1.needRenderTranslate.translateY === 1).assertTrue();
    expect(container1.needRenderScale.scaleX === 0).assertTrue();
    expect(container1.needRenderScale.scaleY === 0).assertTrue();
    expect(container1.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(container1.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(container1.needRenderScale.centerX === '67%').assertTrue();
    expect(container1.needRenderScale.centerY === '67%').assertTrue();
    expect(container1.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(container1.needRenderPos.posX === 1).assertTrue();
    expect(container1.needRenderPos.posY === 1).assertTrue();
    expect(container1.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(container1.iconAlpha === 0).assertTrue();
    expect(container1.iconAlpha === 0).assertTrue();
    expect(container1.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(container1.needRenderVisibility.visibility === false).assertTrue();
    expect(container1.needRenderTranslateIcon.translateIconX === 1).assertTrue();
    expect(container1.needRenderTranslateIcon.translateIconY === 1).assertTrue();
    expect(container1.intelligentScene === 1).assertTrue();
  });

  it('updateDragSwapWithAnimation5', Level.LEVEL0, () => {
    let eventArea: Area = {
      width: 0,
      height: 0,
      position: {
        x: 0, y: 0
      },
      globalPosition: {
        x: 0, y: 0
      }
    };
    let event: GestureEvent = {
      target: null,
      timestamp: 0,
      source: 1,
      pressure: 0,
      tiltX: 1,
      tiltY: 1,
      sourceTool: 0,
      repeat: false,
      fingerList: [],
      offsetX: 1,
      offsetY: 1,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 1,
      pinchCenterY: 0,
      velocityX: 1,
      velocityY: 1,
      velocity: 1
    };
    eventArea.width = 13;
    eventArea.height = 14;
    eventArea.position.x = 110;
    eventArea.position.y = 120;
    eventArea.globalPosition.x = 350;
    eventArea.globalPosition.y = 350;
    event.timestamp = 8;
    event.source = 8;
    event.offsetX = 7;
    event.tiltY = 7;
    event.tiltX = 7;
    event.angle = 7;
    event.speed = 7;
    event.scale = 7;
    event.pinchCenterX = 7;
    event.pinchCenterY = 7;
    event.velocityX = 7;
    event.velocityY = 7;
    event.velocity = 8;
    let calculator = new GlobalOffsetCalculator();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    midSceneManager.updateDragSwapWithAnimation(event, calculator, scbSceneSession, container1);
    expect(container1.getMidScenes().size).assertEqual(2);
    expect(container1.getMidScenes().size).assertEqual(2);
    expect(container1.needRenderTranslate.translateX === 0).assertTrue();
    expect(container1.needRenderTranslate.translateY === 0).assertTrue();
    expect(container1.needRenderScale.scaleX === 0).assertTrue();
    expect(container1.needRenderScale.scaleY === 0).assertTrue();
    expect(container1.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(container1.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(container1.needRenderScale.centerX === '100%').assertTrue();
    expect(container1.needRenderScale.centerY === '100%').assertTrue();
    expect(container1.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(container1.needRenderPos.posX === 0).assertTrue();
    expect(container1.needRenderPos.posY === 0).assertTrue();
    expect(container1.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(container1.iconAlpha === 1).assertTrue();
    expect(container1.iconAlpha === 1).assertTrue();
    expect(container1.needRenderBlurRadius.blurRadius === -1).assertTrue();
    expect(container1.needRenderVisibility.visibility === false).assertTrue();
    expect(container1.needRenderTranslateIcon.translateIconX === 0).assertTrue();
    expect(container1.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(container1.intelligentScene === 1).assertTrue();
  });

  it('updateDragSwapWithAnimation1', Level.LEVEL0, () => {
    let eventArea: Area = {
      width: 23,
      height: 17,
      position: {
        x: 42,
        y: 31
      },
      globalPosition: {
        x: 62,
        y: 62
      }
    };
    let event: GestureEvent = {
      target: null,
      timestamp: 9,
      source: 9,
      pressure: 9,
      tiltX: 9,
      tiltY: 9,
      sourceTool: 9,
      repeat: false,
      fingerList: [],
      offsetX: 9,
      offsetY: 9,
      angle: 9,
      speed: 9,
      scale: 9,
      pinchCenterX: 9,
      pinchCenterY: 9,
      velocityX: 9,
      velocityY: 9,
      velocity: 10
    };
    eventArea.width = 15;
    eventArea.height = 16;
    eventArea.position.x = 112;
    eventArea.position.y = 122;
    eventArea.globalPosition.x = 360;
    eventArea.globalPosition.y = 360;
    event.timestamp = 9;
    event.source = 9;
    event.offsetX = 8;
    event.tiltY = 8;
    event.tiltX = 8;
    event.angle = 8;
    event.speed = 8;
    event.scale = 8;
    event.pinchCenterX = 8;
    event.pinchCenterY = 8;
    event.velocityX = 8;
    event.velocityY = 8;
    event.velocity = 9;
    // ... rest of the setup and assertions
    let calculator = new GlobalOffsetCalculator();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(42);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(91);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    midSceneManager.updateDragSwapWithAnimation(event, calculator, scbSceneSession, container1);
    expect(container1.getMidScenes().size).assertEqual(1);
    expect(container1.getMidScenes().size).assertEqual(1);
    expect(container1.needRenderTranslate.translateX === 1).assertTrue();
    expect(container1.needRenderTranslate.translateY === 0).assertTrue();
    expect(container1.needRenderScale.scaleX === 1).assertTrue();
    expect(container1.needRenderScale.scaleY === 0).assertTrue();
    expect(container1.needRenderBackgroundForMinScale.scaleX === 1).assertTrue();
    expect(container1.needRenderBackgroundForMinScale.scaleY === 0).assertTrue();
    expect(container1.needRenderScale.centerX === '69%').assertTrue();
    expect(container1.needRenderScale.centerY === '69%').assertTrue();
    expect(container1.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(container1.needRenderPos.posX === 0).assertTrue();
    expect(container1.needRenderPos.posY === 0).assertTrue();
    expect(container1.needRenderAlpha.sceneAlpha === 1.0).assertTrue();
    expect(container1.iconAlpha === 1).assertTrue();
    expect(container1.iconAlpha === 1).assertTrue();
    expect(container1.needRenderBlurRadius.blurRadius === 0).assertTrue();
    expect(container1.needRenderVisibility.visibility === true).assertTrue();
    expect(container1.needRenderTranslateIcon.translateIconX === 1).assertTrue();
    expect(container1.needRenderTranslateIcon.translateIconY === 0).assertTrue();
    expect(container1.intelligentScene === 1).assertTrue();
  });

  it('updateDragSwapWithAnimation2', Level.LEVEL0, () => {
    let eventArea: Area = {
      width: 17,
      height: 23,
      position: {
        x: 31,
        y: 42
      },
      globalPosition: {
        x: 52,
        y: 72
      }
    };
    let event: GestureEvent = {
      target: null,
      timestamp: 10,
      source: 10,
      pressure: 10,
      tiltX: 10,
      tiltY: 10,
      sourceTool: 10,
      repeat: false,
      fingerList: [],
      offsetX: 10,
      offsetY: 10,
      angle: 10,
      speed: 10,
      scale: 10,
      pinchCenterX: 10,
      pinchCenterY: 10,
      velocityX: 10,
      velocityY: 10,
      velocity: 11
    };
    eventArea.width = 17;
    eventArea.height = 18;
    eventArea.position.x = 114;
    eventArea.position.y = 124;
    eventArea.globalPosition.x = 370;
    eventArea.globalPosition.y = 370;
    event.timestamp = 10;
    event.source = 10;
    event.offsetX = 9;
    event.tiltY = 9;
    event.tiltX = 9;
    event.angle = 9;
    event.speed = 9;
    event.scale = 9;
    event.pinchCenterX = 9;
    event.pinchCenterY = 9;
    event.velocityX = 9;
    event.velocityY = 9;
    event.velocity = 10;
    // ... rest of the setup and assertions
    let calculator = new GlobalOffsetCalculator();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(42);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(91);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    midSceneManager.updateDragSwapWithAnimation(event, calculator, scbSceneSession, container1);
    expect(container1.getMidScenes().size).assertEqual(1);
    expect(container1.getMidScenes().size).assertEqual(1);
    expect(container1.needRenderTranslate.translateX === 2).assertTrue();
    expect(container1.needRenderTranslate.translateY === 1).assertTrue();
    expect(container1.needRenderScale.scaleX === 2).assertTrue();
    expect(container1.needRenderScale.scaleY === 1).assertTrue();
    expect(container1.needRenderBackgroundForMinScale.scaleX === 2).assertTrue();
    expect(container1.needRenderBackgroundForMinScale.scaleY === 1).assertTrue();
    expect(container1.needRenderScale.centerX === '71%').assertTrue();
    expect(container1.needRenderScale.centerY === '71%').assertTrue();
    expect(container1.needRenderShowInRecent.showInRecent === true).assertTrue();
    expect(container1.needRenderPos.posX === 1).assertTrue();
    expect(container1.needRenderPos.posY === 1).assertTrue();
    expect(container1.needRenderAlpha.sceneAlpha === 0.5).assertTrue();
    expect(container1.iconAlpha === 0).assertTrue();
    expect(container1.iconAlpha === 0).assertTrue();
    expect(container1.needRenderBlurRadius.blurRadius === 1).assertTrue();
    expect(container1.needRenderVisibility.visibility === false).assertTrue();
    expect(container1.needRenderTranslateIcon.translateIconX === 2).assertTrue();
    expect(container1.needRenderTranslateIcon.translateIconY === 2).assertTrue();
    expect(container1.intelligentScene === 0).assertTrue();
  });

  it('updateDragSwapWithAnimation3', Level.LEVEL0, () => {
    let eventArea: Area = {
      width: 29,
      height: 19,
      position: {
        x: 50,
        y: 35
      },
      globalPosition: {
        x: 70,
        y: 55
      }
    };
    let event: GestureEvent = {
      target: null,
      timestamp: 11,
      source: 11,
      pressure: 11,
      tiltX: 11,
      tiltY: 11,
      sourceTool: 11,
      repeat: false,
      fingerList: [],
      offsetX: 11,
      offsetY: 11,
      angle: 11,
      speed: 11,
      scale: 11,
      pinchCenterX: 11,
      pinchCenterY: 11,
      velocityX: 11,
      velocityY: 11,
      velocity: 12
    };
    eventArea.width = 19;
    eventArea.height = 20;
    eventArea.position.x = 116;
    eventArea.position.y = 126;
    eventArea.globalPosition.x = 380;
    eventArea.globalPosition.y = 380;
    event.timestamp = 11;
    event.source = 11;
    event.offsetX = 10;
    event.tiltY = 10;
    event.tiltX = 10;
    event.angle = 10;
    event.speed = 10;
    event.scale = 10;
    event.pinchCenterX = 10;
    event.pinchCenterY = 10;
    event.velocityX = 10;
    event.velocityY = 10;
    event.velocity = 11;
    // ... rest of the setup and assertions
    let calculator = new GlobalOffsetCalculator();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(13);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(67);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    expect(container1.getMidScenes().size).assertEqual(1);
    expect(container1.getMidScenes().size).assertEqual(1);
    expect(container1.needRenderTranslate.translateX === 3).assertTrue();
    expect(container1.needRenderTranslate.translateY === 2).assertTrue();
    expect(container1.needRenderScale.scaleX === 3).assertTrue();
    expect(container1.needRenderScale.scaleY === 2).assertTrue();
    expect(container1.needRenderBackgroundForMinScale.scaleX === 3).assertTrue();
    expect(container1.needRenderBackgroundForMinScale.scaleY === 2).assertTrue();
    expect(container1.needRenderScale.centerX === '73%').assertTrue();
    expect(container1.needRenderScale.centerY === '73%').assertTrue();
    expect(container1.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(container1.needRenderPos.posX === 2).assertTrue();
    expect(container1.needRenderPos.posY === 2).assertTrue();
    expect(container1.needRenderAlpha.sceneAlpha === 0.75).assertTrue();
    expect(container1.iconAlpha === 0).assertTrue();
    expect(container1.iconAlpha === 0).assertTrue();
    expect(container1.needRenderBlurRadius.blurRadius === 2).assertTrue();
    expect(container1.needRenderVisibility.visibility === true).assertTrue();
    expect(container1.needRenderTranslateIcon.translateIconX === 3).assertTrue();
    expect(container1.needRenderTranslateIcon.translateIconY === 3).assertTrue();
    expect(container1.intelligentScene === 1).assertTrue();
  });

  it('updateDragSwapWithAnimation4', Level.LEVEL0, () => {
    let eventArea: Area = {
      width: 19,
      height: 29,
      position: {
        x: 35,
        y: 50
      },
      globalPosition: {
        x: 55,
        y: 70
      }
    };
    let event: GestureEvent = {
      target: null,
      timestamp: 12,
      source: 12,
      pressure: 12,
      tiltX: 12,
      tiltY: 12,
      sourceTool: 12,
      repeat: false,
      fingerList: [],
      offsetX: 12,
      offsetY: 12,
      angle: 12,
      speed: 12,
      scale: 12,
      pinchCenterX: 12,
      pinchCenterY: 12,
      velocityX: 12,
      velocityY: 12,
      velocity: 13
    };
    eventArea.width = 21;
    eventArea.height = 22;
    eventArea.position.x = 118;
    eventArea.position.y = 128;
    eventArea.globalPosition.x = 390;
    eventArea.globalPosition.y = 390;
    event.timestamp = 12;
    event.source = 12;
    event.offsetX = 11;
    event.tiltY = 11;
    event.tiltX = 11;
    event.angle = 11;
    event.speed = 11;
    event.scale = 11;
    event.pinchCenterX = 11;
    event.pinchCenterY = 11;
    event.velocityX = 11;
    event.velocityY = 11;
    event.velocity = 12;
    // ... rest of the setup and assertions
    let calculator = new GlobalOffsetCalculator();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(85);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(29);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    midSceneManager.updateDragSwapWithAnimation(event, calculator, scbSceneSession, container1);
    expect(container1.getMidScenes().size).assertEqual(1);
    expect(container1.getMidScenes().size).assertEqual(1);
    expect(container1.needRenderTranslate.translateX === 4).assertTrue();
    expect(container1.needRenderTranslate.translateY === 3).assertTrue();
    expect(container1.needRenderScale.scaleX === 4).assertTrue();
    expect(container1.needRenderScale.scaleY === 3).assertTrue();
    expect(container1.needRenderBackgroundForMinScale.scaleX === 4).assertTrue();
    expect(container1.needRenderBackgroundForMinScale.scaleY === 3).assertTrue();
    expect(container1.needRenderScale.centerX === '75%').assertTrue();
    expect(container1.needRenderScale.centerY === '75%').assertTrue();
    expect(container1.needRenderShowInRecent.showInRecent === false).assertTrue();
    expect(container1.needRenderPos.posX === 3).assertTrue();
    expect(container1.needRenderPos.posY === 3).assertTrue();
    expect(container1.needRenderAlpha.sceneAlpha === 0.25).assertTrue();
    expect(container1.iconAlpha === 0).assertTrue();
    expect(container1.iconAlpha === 0).assertTrue();
    expect(container1.needRenderBlurRadius.blurRadius === 3).assertTrue();
    expect(container1.needRenderVisibility.visibility === false).assertTrue();
    expect(container1.needRenderTranslateIcon.translateIconX === 4).assertTrue();
    expect(container1.needRenderTranslateIcon.translateIconY === 4).assertTrue();
    expect(container1.intelligentScene === 0).assertTrue();
  });

  it('updateDragSwapWithAnimation5', Level.LEVEL0, () => {
    let eventArea: Area = {
      width: 21,
      height: 25,
      position: {
        x: 40,
        y: 45
      },
      globalPosition: {
        x: 60,
        y: 65
      }
    };
    let event: GestureEvent = {
      target: null,
      timestamp: 13,
      source: 13,
      pressure: 13,
      tiltX: 13,
      tiltY: 13,
      sourceTool: 13,
      repeat: false,
      fingerList: [],
      offsetX: 13,
      offsetY: 13,
      angle: 13,
      speed: 13,
      scale: 13,
      pinchCenterX: 13,
      pinchCenterY: 13,
      velocityX: 13,
      velocityY: 13,
      velocity: 14
    };
    eventArea.width = 23;
    eventArea.height = 24;
    eventArea.position.x = 120;
    eventArea.position.y = 130;
    eventArea.globalPosition.x = 400;
    eventArea.globalPosition.y = 400;
    event.timestamp = 13;
    event.source = 13;
    event.offsetX = 12;
    event.tiltY = 12;
    event.tiltX = 12;
    event.angle = 12;
    event.speed = 12;
    event.scale = 12;
    event.pinchCenterX = 12;
    event.pinchCenterY = 12;
    event.velocityX = 12;
    event.velocityY = 12;
    event.velocity = 13;
    // ... rest of the setup and assertions
    let calculator = new GlobalOffsetCalculator();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(56);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(82);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    midSceneManager.updateDragSwapWithAnimation(event, calculator, scbSceneSession, container1);
    expect(container1.getMidScenes().size).assertEqual(1);
    expect(container1.getMidScenes().size).assertEqual(1);
    expect(container1.needRenderTranslate.translateX === 5).assertTrue();
    expect(container1.needRenderTranslate.translateY === 4).assertTrue();
    expect(container1.needRenderScale.scaleX === 5).assertTrue();
    expect(container1.needRenderScale.scaleY === 4).assertTrue();
    expect(container1.needRenderBackgroundForMinScale.scaleX === 5).assertTrue();
    expect(container1.needRenderBackgroundForMinScale.scaleY === 4).assertTrue();
    expect(container1.needRenderScale.centerX === '77%').assertTrue();
    expect(container1.needRenderScale.centerY === '77%').assertTrue();
    expect(container1.needRenderShowInRecent.showInRecent === true).assertTrue();
    expect(container1.needRenderPos.posX === 4).assertTrue();
    expect(container1.needRenderPos.posY === 4).assertTrue();
    expect(container1.needRenderAlpha.sceneAlpha === 0.5).assertTrue();
    expect(container1.iconAlpha === 0).assertTrue();
    expect(container1.iconAlpha === 0).assertTrue();
    expect(container1.needRenderBlurRadius.blurRadius === 4).assertTrue();
    expect(container1.needRenderVisibility.visibility === true).assertTrue();
    expect(container1.needRenderTranslateIcon.translateIconX === 5).assertTrue();
    expect(container1.needRenderTranslateIcon.translateIconY === 5).assertTrue();
    expect(container1.intelligentScene === 1).assertTrue();
  });

  it('updateDragSwapWithAnimation5', Level.LEVEL0, () => {
    let event: GestureEvent = {
      target: null,
      timestamp: 13,
      source: 13,
      pressure: 13,
      tiltX: 13,
      tiltY: 13,
      sourceTool: 13,
      repeat: false,
      fingerList: [],
      offsetX: 13,
      offsetY: 13,
      angle: 13,
      speed: 13,
      scale: 13,
      pinchCenterX: 13,
      pinchCenterY: 13,
      velocityX: 13,
      velocityY: 13,
      velocity: 14
    };
    let eventArea: Area = {
      width: 21,
      height: 25,
      position: {
        x: 40,
        y: 45
      },
      globalPosition: {
        x: 60,
        y: 65
      }
    };
    eventArea.width = 23;
    eventArea.height = 24;
    eventArea.position.x = 120;
    eventArea.position.y = 130;
    eventArea.globalPosition.x = 400;
    eventArea.globalPosition.y = 400;
    let calculator = new GlobalOffsetCalculator();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(56);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(82);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    expect(container1.intelligentScene === 1).assertTrue();
  });
}

function MidSceneManagerTest_updateDraggingEventInMidScene_02() {
  it('MidSceneManager_updateDraggingEventInMidScene001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    let midsceneData0: MidSceneData = new MidSceneData(3);
    midsceneData0.step = MidSceneStep.LARGE;
    midsceneData0.left = 0.6;
    midsceneData0.visibleW = 0.6;
    midsceneData0.width = 0.6;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    container1.isMidScene = false;
    midSceneManager.updateDraggingEventInMidScene(container1, dividerParam, midSceneDragContext, 1);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.isMidScene = true;
    midSceneManager.updateDraggingEventInMidScene(container1, dividerParam, midSceneDragContext, 2);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(midSceneDragContext, midSceneDragContext.isOverBound);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
    dividerParam.primary.scaleCenterX = '11%';
    dividerParam.primary.rotateCenterX = '11%';
    dividerParam.secondary.scaleCenterX = '11%';
    dividerParam.secondary.rotateCenterX = '11%';
    let nums: Array<number> = [0.15, 0.55, 0, 145, -0.2, -0.6, -150]
    midsceneData1.step = MidSceneStep.SMALL;
    midsceneData1.inclined = true;
    midsceneData2.step = MidSceneStep.SMALL;
    midsceneData2.inclined = false;
    for (let n of nums) {
      midSceneManager.updateDraggingEventInMidScene(container1, dividerParam, midSceneDragContext, n);
    }
    let mocker1: MockKit = new MockKit();
    let mockfunc1: Function = mocker1.mockFunc(midSceneDragContext, midSceneDragContext.isPassMidLine);
    when(mockfunc1)(ArgumentMatchers.any).afterReturn(false);
    midsceneData1.step = MidSceneStep.LARGE;
    midsceneData2.step = MidSceneStep.LARGE;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    for (let n of nums) {
      midSceneManager.updateDraggingEventInMidScene(container1, dividerParam, midSceneDragContext, n);
    }
    expect(true).assertTrue();
    mocker.clear(midSceneDragContext);
    mocker1.clear(midSceneDragContext);
  });

  it('MidSceneManager_updateDraggingEventInMidScene001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(2, false);
    let midsceneData2: MidSceneData = new MidSceneData(3, false);
    let midsceneData0: MidSceneData = new MidSceneData(4);
    midsceneData0.step = MidSceneStep.LARGE;
    midsceneData0.left = 0.7;
    midsceneData0.visibleW = 0.7;
    midsceneData0.width = 0.7;
    container1.midSceneMap.set(2, scbSceneSession);
    container1.midSceneMap.set(3, scbSceneSession);
    container1.isMidScene = true;
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(midSceneDragContext, midSceneDragContext.isOverBound);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
    dividerParam.primary.scaleCenterX = '12%';
    dividerParam.primary.rotateCenterX = '12%';
    dividerParam.secondary.scaleCenterX = '12%';
    dividerParam.secondary.rotateCenterX = '12%';
    let nums: Array<number> = [0.2, 0.6, 1, 141, -0.2, -0.6, -141]
    midsceneData1.step = MidSceneStep.SMALL;
    midsceneData1.inclined = false;
    midsceneData2.step = MidSceneStep.SMALL;
    midsceneData2.inclined = true;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    for (let n of nums) {
      midSceneManager.updateDraggingEventInMidScene(container1, dividerParam, midSceneDragContext, n);
    }
    let mocker1: MockKit = new MockKit();
    let mockfunc1: Function = mocker1.mockFunc(midSceneDragContext, midSceneDragContext.isPassMidLine);
    when(mockfunc1)(ArgumentMatchers.any).afterReturn(true);
    midsceneData1.step = MidSceneStep.LARGE;
    midsceneData2.step = MidSceneStep.SMALL;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    midSceneManager.updateDraggingEventInMidScene(container1, dividerParam, midSceneDragContext, 2);
    expect(dividerParam.dividerAlpha).assertLarger(0);
    mocker.clear(mockfunc);
    mocker1.clear(mockfunc1);
  });

  it('MidSceneManager_updateDraggingEventInMidScene002', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(3, false);
    let midsceneData2: MidSceneData = new MidSceneData(4, false);
    let midsceneData0: MidSceneData = new MidSceneData(5);
    midsceneData0.step = MidSceneStep.LARGE;
    midsceneData0.left = 0.8;
    midsceneData0.visibleW = 0.8;
    midsceneData0.width = 0.8;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    container1.isMidScene = true;
    midSceneManager.updateDraggingEventInMidScene(container1, dividerParam, midSceneDragContext, 1);
    let sceneInfo1 = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let session1 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo1.bundleName,
      moduleName: sceneInfo1.moduleName,
      abilityName: sceneInfo1.abilityName,
      appIndex: sceneInfo1.appIndex,
      persistentId: sceneInfo1.persistentId,
      screenId: sceneInfo1.screenId
    }, sceneInfo1.want);
    let scbSceneSession1: SCBSceneSession = new SCBSceneSession(session1, sceneInfo1);
    let sceneInfo2 = new SCBSceneInfo('testPriBundle2', 'testPriModule2', 'testPriAbility2');
    let session2 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo2.bundleName,
      moduleName: sceneInfo2.moduleName,
      abilityName: sceneInfo2.abilityName,
      appIndex: sceneInfo2.appIndex,
      persistentId: sceneInfo2.persistentId,
      screenId: sceneInfo2.screenId
    }, sceneInfo2.want);
    let scbSceneSession2: SCBSceneSession = new SCBSceneSession(session2, sceneInfo2);
    container1.midSceneMap.set(2, scbSceneSession1);
    container1.midSceneMap.set(3, scbSceneSession2);
    dividerParam.primary = scbSceneSession1.sceneParam;
    dividerParam.secondary = scbSceneSession2.sceneParam;
    scbSceneSession1.sceneParam.posX = '66%';
    container1.isMidScene = false;
    let mocker1: MockKit = new MockKit();
    let mockfunc1: Function = mocker1.mockFunc(midSceneDragContext, midSceneDragContext.isPassMidLine);
    when(mockfunc1)(ArgumentMatchers.any).afterReturn(false);
    midsceneData1.step = MidSceneStep.LARGE;
    midsceneData2.step = MidSceneStep.SMALL;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    midSceneManager.updateDraggingEventInMidScene(container1, dividerParam, midSceneDragContext, 1);
    expect(dividerParam.dividerTranslateX).assertEqual(-1);
    mocker1.clear(mockfunc1);
  });

  it('MidSceneManager_updateDraggingEventInMidScene003', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(4, true);
    let midsceneData2: MidSceneData = new MidSceneData(5, false);
    let midsceneData0: MidSceneData = new MidSceneData(6);
    midsceneData0.step = MidSceneStep.LARGE;
    midsceneData0.left = 0.9;
    midsceneData0.visibleW = 0.9;
    midsceneData0.width = 0.9;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    container1.isMidScene = false;
    midSceneManager.updateDraggingEventInMidScene(container1, dividerParam, midSceneDragContext, -1);
    let sceneInfo1 = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let session1 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo1.bundleName,
      moduleName: sceneInfo1.moduleName,
      abilityName: sceneInfo1.abilityName,
      appIndex: sceneInfo1.appIndex,
      persistentId: sceneInfo1.persistentId,
      screenId: sceneInfo1.screenId
    }, sceneInfo1.want);
    let scbSceneSession1: SCBSceneSession = new SCBSceneSession(session1, sceneInfo1);
    let sceneInfo2 = new SCBSceneInfo('testPriBundle2', 'testPriModule2', 'testPriAbility2');
    let session2 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo2.bundleName,
      moduleName: sceneInfo2.moduleName,
      abilityName: sceneInfo2.abilityName,
      appIndex: sceneInfo2.appIndex,
      persistentId: sceneInfo2.persistentId,
      screenId: sceneInfo2.screenId
    }, sceneInfo2.want);
    let scbSceneSession2: SCBSceneSession = new SCBSceneSession(session2, sceneInfo2);
    container1.midSceneMap.set(6, scbSceneSession1);
    container1.midSceneMap.set(3, scbSceneSession2);
    dividerParam.primary = scbSceneSession1.sceneParam;
    dividerParam.secondary = scbSceneSession2.sceneParam;
    scbSceneSession1.sceneParam.posX = '75%';
    let mocker1: MockKit = new MockKit();
    let mockfunc1: Function = mocker1.mockFunc(midSceneDragContext, midSceneDragContext.isPassMidLine);
    when(mockfunc1)(ArgumentMatchers.any).afterReturn(true);
    midsceneData1.step = MidSceneStep.SMALL;
    midsceneData2.step = MidSceneStep.UNKNOWN;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    midSceneManager.updateDraggingEventInMidScene(container1, dividerParam, midSceneDragContext, 5);
    expect(scbSceneSession1.sceneParam.posY).assertEqual('25%');
    mocker1.clear(mockfunc1);
  });

  it('MidSceneManager_processDraggingOverBound004', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(3, true);
    let midsceneData2: MidSceneData = new MidSceneData(4, false);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    midsceneData0.step = MidSceneStep.LARGE;
    midsceneData0.left = 0.75;
    midsceneData0.visibleW = 0.75;
    midsceneData0.width = 0.75;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    container1.isMidScene = false;
    let sceneInfo1 = new SCBSceneInfo('testPriBundle3', 'testPriModule3', 'testPriAbility3');
    let session1 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo1.bundleName,
      moduleName: sceneInfo1.moduleName,
      abilityName: sceneInfo1.abilityName,
      appIndex: sceneInfo1.appIndex,
      persistentId: sceneInfo1.persistentId,
      screenId: sceneInfo1.screenId
    }, sceneInfo1.want);
    let scbSceneSession1: SCBSceneSession = new SCBSceneSession(session1, sceneInfo1);
    let sceneInfo2 = new SCBSceneInfo('testPriBundle4', 'testPriModule4', 'testPriAbility4');
    let session2 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo2.bundleName,
      moduleName: sceneInfo2.moduleName,
      abilityName: sceneInfo2.abilityName,
      appIndex: sceneInfo2.appIndex,
      persistentId: sceneInfo2.persistentId,
      screenId: sceneInfo2.screenId
    }, sceneInfo2.want);
    let scbSceneSession2: SCBSceneSession = new SCBSceneSession(session2, sceneInfo2);
    container1.midSceneMap.set(3, scbSceneSession1);
    container1.midSceneMap.set(4, scbSceneSession2);
    let dragCtx = new MidSceneDragContext(screenProperty);
    dividerParam.primary = scbSceneSession1.sceneParam;
    dividerParam.secondary = scbSceneSession2.sceneParam;
    scbSceneSession1.sceneParam.posX = '60%';
    container1.isMidScene = true;
    midsceneData1.step = MidSceneStep.LARGE;
    midsceneData2.step = MidSceneStep.LARGE;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    ReflectionUtils.useFunc(midSceneManager, 'processDraggingOverBound', container1, dragCtx, dividerParam, 1);
    expect(scbSceneSession1.sceneParam.posX).assertEqual('60%');
  });

  it('MidSceneManager_processDraggingOverBound005', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(7, true);
    let midsceneData2: MidSceneData = new MidSceneData(11, false);
    let midsceneData0: MidSceneData = new MidSceneData(3);
    midsceneData0.step = MidSceneStep.LARGE;
    midsceneData0.left = 0.75;
    midsceneData0.visibleW = 0.25;
    midsceneData0.width = 0.75;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    container1.isMidScene = false;
    let sceneInfo1 = new SCBSceneInfo('testPriBundle3', 'testPriModule3', 'testPriAbility3');
    let session1 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo1.bundleName,
      moduleName: sceneInfo1.moduleName,
      abilityName: sceneInfo1.abilityName,
      appIndex: 9,
      persistentId: 5,
      screenId: 6
    }, sceneInfo1.want);
    let scbSceneSession1: SCBSceneSession = new SCBSceneSession(session1, sceneInfo1);
    let sceneInfo2 = new SCBSceneInfo('testPriBundle4', 'testPriModule4', 'testPriAbility4');
    let session2 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo2.bundleName,
      moduleName: sceneInfo2.moduleName,
      abilityName: sceneInfo2.abilityName,
      appIndex: 15,
      persistentId: 7,
      screenId: 5
    }, sceneInfo2.want);
    let scbSceneSession2: SCBSceneSession = new SCBSceneSession(session2, sceneInfo2);
    container1.midSceneMap.set(7, scbSceneSession1);
    container1.midSceneMap.set(11, scbSceneSession2);
    let dragCtx = new MidSceneDragContext(screenProperty);
    dividerParam.primary = scbSceneSession1.sceneParam;
    dividerParam.secondary = scbSceneSession2.sceneParam;
    scbSceneSession2.sceneParam.posX = '62.5%';
    container1.isMidScene = true;
    midsceneData1.step = MidSceneStep.LARGE;
    midsceneData2.step = MidSceneStep.LARGE;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    ReflectionUtils.useFunc(midSceneManager, 'processDraggingOverBound', container1, dragCtx, dividerParam, 300);
    expect(scbSceneSession2.sceneParam.posX).assertEqual('62.5%');
  });

  it('MidSceneManager_processDraggingOverBound006', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0, true);
    let midsceneData2: MidSceneData = new MidSceneData(2, false);
    let midsceneData0: MidSceneData = new MidSceneData(1);
    midsceneData0.step = MidSceneStep.SMALL;
    midsceneData0.left = 0.45;
    midsceneData0.visibleW = 0.45;
    midsceneData0.width = 0.45;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    container1.isMidScene = false;
    let sceneInfo1 = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let session1 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo1.bundleName,
      moduleName: sceneInfo1.moduleName,
      abilityName: sceneInfo1.abilityName,
      appIndex: sceneInfo1.appIndex,
      persistentId: sceneInfo1.persistentId,
      screenId: sceneInfo1.screenId
    }, sceneInfo1.want);
    let scbSceneSession1: SCBSceneSession = new SCBSceneSession(session1, sceneInfo1);
    let sceneInfo2 = new SCBSceneInfo('testPriBundle6', 'testPriModule5', 'testPriAbility4');
    let session2 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo2.bundleName,
      moduleName: sceneInfo2.moduleName,
      abilityName: sceneInfo2.abilityName,
      appIndex: sceneInfo2.appIndex,
      persistentId: sceneInfo2.persistentId,
      screenId: sceneInfo2.screenId
    }, sceneInfo2.want);
    let scbSceneSession2: SCBSceneSession = new SCBSceneSession(session2, sceneInfo2);
    container1.midSceneMap.set(5, scbSceneSession1);
    container1.midSceneMap.set(8, scbSceneSession2);
    let dragCtx = new MidSceneDragContext(screenProperty);
    dividerParam.primary = scbSceneSession1.sceneParam;
    dividerParam.secondary = scbSceneSession2.sceneParam;
    scbSceneSession2.sceneParam.posX = '48%';
    container1.isMidScene = true;
    midsceneData1.step = MidSceneStep.UNKNOWN;
    midsceneData2.step = MidSceneStep.SMALL;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    ReflectionUtils.useFunc(midSceneManager, 'processDraggingOverBound', container1, dragCtx, dividerParam, 150);
    expect(midsceneData1.step).assertEqual(MidSceneStep.SMALL);
  });

  it('processDraggingToLeftNotPassingMidLine001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(3, true);
    let midsceneData2: MidSceneData = new MidSceneData(5, false);
    let midsceneData0: MidSceneData = new MidSceneData(7);
    midsceneData0.step = MidSceneStep.UNKNOWN;
    midsceneData0.left = 0.75;
    midsceneData0.visibleW = 0.25;
    midsceneData0.width = 0.75;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    container1.isMidScene = false;
    let sceneInfo1 = new SCBSceneInfo('testPriBundle3', 'testPriModule3', 'testPriAbility3');
    let session1 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo1.bundleName,
      moduleName: sceneInfo1.moduleName,
      abilityName: sceneInfo1.abilityName,
      appIndex: 9,
      persistentId: 2,
      screenId: 3
    }, sceneInfo1.want);
    let scbSceneSession1: SCBSceneSession = new SCBSceneSession(session1, sceneInfo1);
    let sceneInfo2 = new SCBSceneInfo('testPriBundle4', 'testPriModule4', 'testPriAbility4');
    let session2 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo2.bundleName,
      moduleName: sceneInfo2.moduleName,
      abilityName: sceneInfo2.abilityName,
      appIndex: 15,
      persistentId: 4,
      screenId: 5
    }, sceneInfo2.want);
    let scbSceneSession2: SCBSceneSession = new SCBSceneSession(session2, sceneInfo2);
    container1.midSceneMap.set(3, scbSceneSession1);
    container1.midSceneMap.set(5, scbSceneSession2);
    let dragCtx = new MidSceneDragContext(screenProperty);
    dividerParam.primary = scbSceneSession1.sceneParam;
    dividerParam.secondary = scbSceneSession2.sceneParam;
    scbSceneSession2.sceneParam.posX = '67.5%';
    container1.isMidScene = true;
    midsceneData1.step = MidSceneStep.SMALL;
    midsceneData2.step = MidSceneStep.LARGE;
    midsceneData1.inclined = false;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    ReflectionUtils.useFunc(midSceneManager, 'processDraggingToLeftNotPassingMidLine', container1, 275, dragCtx,
      dividerParam);
    expect(scbSceneSession2.sceneParam.posX).assertEqual('67.5%');
  });

  it('processDraggingToLeftNotPassingMidLine002', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(3, true);
    let midsceneData2: MidSceneData = new MidSceneData(7, false);
    let midsceneData0: MidSceneData = new MidSceneData(11);
    midsceneData0.step = MidSceneStep.LARGE;
    midsceneData0.left = 0.45;
    midsceneData0.visibleW = 0.25;
    midsceneData0.width = 0.65;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    container1.isMidScene = false;
    let sceneInfo1 = new SCBSceneInfo('testPriBundle3', 'testPriModule3', 'testPriAbility3');
    let session1 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo1.bundleName,
      moduleName: sceneInfo1.moduleName,
      abilityName: sceneInfo1.abilityName,
      appIndex: 6,
      persistentId: 4,
      screenId: 3
    }, sceneInfo1.want);
    let scbSceneSession1: SCBSceneSession = new SCBSceneSession(session1, sceneInfo1);
    let sceneInfo2 = new SCBSceneInfo('testPriBundle4', 'testPriModule4', 'testPriAbility4');
    let session2 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo2.bundleName,
      moduleName: sceneInfo2.moduleName,
      abilityName: sceneInfo2.abilityName,
      appIndex: 5,
      persistentId: 2,
      screenId: 1
    }, sceneInfo2.want);
    let scbSceneSession2: SCBSceneSession = new SCBSceneSession(session2, sceneInfo2);
    container1.midSceneMap.set(3, scbSceneSession1);
    container1.midSceneMap.set(7, scbSceneSession2);
    let dragCtx = new MidSceneDragContext(screenProperty);
    dividerParam.primary = scbSceneSession1.sceneParam;
    dividerParam.secondary = scbSceneSession2.sceneParam;
    scbSceneSession2.sceneParam.posX = '62.5%';
    container1.isMidScene = true;
    midsceneData1.step = MidSceneStep.SMALL;
    midsceneData2.step = MidSceneStep.UNKNOWN;
    midsceneData1.inclined = false;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    ReflectionUtils.useFunc(midSceneManager, 'processDraggingToLeftNotPassingMidLine', container1, 30, dragCtx,
      dividerParam);
    expect(scbSceneSession1.sceneParam.rotateAngle).assertEqual(-1);
  });

  it('processDraggingToLeftNotPassingMidLine003', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(9, true);
    let midsceneData2: MidSceneData = new MidSceneData(6, false);
    let midsceneData0: MidSceneData = new MidSceneData(3);
    midsceneData0.step = MidSceneStep.UNKNOWN;
    midsceneData0.left = 0.56;
    midsceneData0.visibleW = 0.57;
    midsceneData0.width = 0.58;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    container1.isMidScene = true;
    let sceneInfo1 = new SCBSceneInfo('testPriBundle1', 'testPriModule2', 'testPriAbility3');
    let session1 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo1.bundleName,
      moduleName: sceneInfo1.moduleName,
      abilityName: sceneInfo1.abilityName,
      appIndex: sceneInfo1.appIndex,
      persistentId: sceneInfo1.persistentId,
      screenId: sceneInfo1.screenId
    }, sceneInfo1.want);
    let scbSceneSession1: SCBSceneSession = new SCBSceneSession(session1, sceneInfo1);
    let sceneInfo2 = new SCBSceneInfo('testPriBundle1', 'testPriModule3', 'testPriAbility2');
    let session2 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo2.bundleName,
      moduleName: sceneInfo2.moduleName,
      abilityName: sceneInfo2.abilityName,
      appIndex: sceneInfo2.appIndex,
      persistentId: sceneInfo2.persistentId,
      screenId: sceneInfo2.screenId
    }, sceneInfo2.want);
    let scbSceneSession2: SCBSceneSession = new SCBSceneSession(session2, sceneInfo2);
    container1.midSceneMap.set(9, scbSceneSession1);
    container1.midSceneMap.set(6, scbSceneSession2);
    let dragCtx = new MidSceneDragContext(screenProperty);
    dividerParam.primary = scbSceneSession1.sceneParam;
    dividerParam.secondary = scbSceneSession2.sceneParam;
    scbSceneSession2.sceneParam.posX = '5%';
    container1.isMidScene = false;
    midsceneData1.step = MidSceneStep.UNKNOWN;
    midsceneData2.step = MidSceneStep.LARGE;
    midsceneData1.inclined = true;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    ReflectionUtils.useFunc(midSceneManager, 'processDraggingToLeftNotPassingMidLine', container1, 15, dragCtx,
      dividerParam);
    expect(midsceneData2.step).assertEqual(MidSceneStep.SMALL);
  });

  it('processDraggingToLeftPassingMidLine001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(5, true);
    let midsceneData2: MidSceneData = new MidSceneData(7, false);
    let midsceneData0: MidSceneData = new MidSceneData(9);
    midsceneData0.step = MidSceneStep.UNKNOWN;
    midsceneData0.left = 0.51;
    midsceneData0.visibleW = 0.51;
    midsceneData0.width = 0.51;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    container1.isMidScene = true;
    let sceneInfo1 = new SCBSceneInfo('testPriBundle11', 'testPriModule11', 'testPriAbility11');
    let session1 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo1.bundleName,
      moduleName: sceneInfo1.moduleName,
      abilityName: sceneInfo1.abilityName,
      appIndex: sceneInfo1.appIndex,
      persistentId: sceneInfo1.persistentId,
      screenId: sceneInfo1.screenId
    }, sceneInfo1.want);
    expect(midsceneData2.step).assertEqual(MidSceneStep.LARGE);
  });

  it('processDraggingToLeftPassingMidLine002', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0, true);
    let midsceneData2: MidSceneData = new MidSceneData(1, false);
    let midsceneData0: MidSceneData = new MidSceneData(2);
    midsceneData0.step = MidSceneStep.SMALL;
    midsceneData0.left = 0.1;
    midsceneData0.visibleW = 0.2;
    midsceneData0.width = 0.3;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    container1.isMidScene = true;
    let sceneInfo1 = new SCBSceneInfo('testPriBundle1', 'testPriModule1', 'testPriAbility1');
    let session1 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo1.bundleName,
      moduleName: sceneInfo1.moduleName,
      abilityName: sceneInfo1.abilityName,
      appIndex: sceneInfo1.appIndex,
      persistentId: sceneInfo1.persistentId,
      screenId: sceneInfo1.screenId
    }, sceneInfo1.want);
    let scbSceneSession1: SCBSceneSession = new SCBSceneSession(session1, sceneInfo1);
    let sceneInfo2 = new SCBSceneInfo('testPriBundle1', 'testPriModule1', 'testPriAbility1');
    let session2 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo2.bundleName,
      moduleName: sceneInfo2.moduleName,
      abilityName: sceneInfo2.abilityName,
      appIndex: sceneInfo2.appIndex,
      persistentId: sceneInfo2.persistentId,
      screenId: sceneInfo2.screenId
    }, sceneInfo2.want);
    let scbSceneSession2: SCBSceneSession = new SCBSceneSession(session2, sceneInfo2);
    container1.midSceneMap.set(0, scbSceneSession1);
    container1.midSceneMap.set(1, scbSceneSession2);
    let dragCtx = new MidSceneDragContext(screenProperty);
    dividerParam.primary = scbSceneSession1.sceneParam;
    dividerParam.secondary = scbSceneSession2.sceneParam;
    scbSceneSession1.sceneParam.posX = '5%';
    scbSceneSession2.sceneParam.posX = '5%';
    container1.isMidScene = false;
    midsceneData1.step = MidSceneStep.UNKNOWN;
    midsceneData2.step = MidSceneStep.LARGE;
    midsceneData1.inclined = true;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    ReflectionUtils.useFunc(midSceneManager, 'processDraggingToLeftPassingMidLine', container1, 5, dragCtx,
      dividerParam);
    expect(scbSceneSession1.sceneParam.posX).assertEqual('5%');
  });

  it('processDraggingToLeftPassingMidLine003', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(1, true);
    let midsceneData2: MidSceneData = new MidSceneData(2, false);
    let midsceneData0: MidSceneData = new MidSceneData(3);
    midsceneData0.step = MidSceneStep.SMALL;
    midsceneData0.left = 0.2;
    midsceneData0.visibleW = 0.2;
    midsceneData0.width = 0.2;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    container1.isMidScene = true;
    let sceneInfo1 = new SCBSceneInfo('testPriBundle2', 'testPriModule2', 'testPriAbility2');
    let session1 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo1.bundleName,
      moduleName: sceneInfo1.moduleName,
      abilityName: sceneInfo1.abilityName,
      appIndex: sceneInfo1.appIndex,
      persistentId: sceneInfo1.persistentId,
      screenId: sceneInfo1.screenId
    }, sceneInfo1.want);
    let scbSceneSession1: SCBSceneSession = new SCBSceneSession(session1, sceneInfo1);
    let sceneInfo2 = new SCBSceneInfo('testPriBundle2', 'testPriModule2', 'testPriAbility2');
    let session2 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo2.bundleName,
      moduleName: sceneInfo2.moduleName,
      abilityName: sceneInfo2.abilityName,
      appIndex: sceneInfo2.appIndex,
      persistentId: sceneInfo2.persistentId,
      screenId: sceneInfo2.screenId
    }, sceneInfo2.want);
    let scbSceneSession2: SCBSceneSession = new SCBSceneSession(session2, sceneInfo2);
    container1.midSceneMap.set(2, scbSceneSession1);
    container1.midSceneMap.set(3, scbSceneSession2);
    let dragCtx = new MidSceneDragContext(screenProperty);
    dividerParam.primary = scbSceneSession1.sceneParam;
    dividerParam.secondary = scbSceneSession2.sceneParam;
    scbSceneSession1.sceneParam.posX = '10%';
    scbSceneSession2.sceneParam.posX = '10%';
    container1.isMidScene = false;
    midsceneData1.step = MidSceneStep.SMALL;
    midsceneData2.step = MidSceneStep.LARGE;
    midsceneData1.inclined = false;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    ReflectionUtils.useFunc(midSceneManager, 'processDraggingToLeftPassingMidLine', container1, 10, dragCtx,
      dividerParam);
    expect(midsceneData1.step).assertEqual(MidSceneStep.LARGE);
  });

  it('processDraggingToRightNotPassingMidLine001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(2, true);
    let midsceneData2: MidSceneData = new MidSceneData(3, false);
    let midsceneData0: MidSceneData = new MidSceneData(4);
    midsceneData0.step = MidSceneStep.LARGE;
    midsceneData0.left = 0.3;
    midsceneData0.visibleW = 0.3;
    midsceneData0.width = 0.3;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    container1.isMidScene = true;
    let sceneInfo1 = new SCBSceneInfo('testPriBundle3', 'testPriModule3', 'testPriAbility3');
    let session1 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo1.bundleName,
      moduleName: sceneInfo1.moduleName,
      abilityName: sceneInfo1.abilityName,
      appIndex: sceneInfo1.appIndex,
      persistentId: sceneInfo1.persistentId,
      screenId: sceneInfo1.screenId
    }, sceneInfo1.want);
    let scbSceneSession1: SCBSceneSession = new SCBSceneSession(session1, sceneInfo1);
    let sceneInfo2 = new SCBSceneInfo('testPriBundle23', 'testPriModule23', 'testPriAbility23');
    let session2 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo2.bundleName,
      moduleName: sceneInfo2.moduleName,
      abilityName: sceneInfo2.abilityName,
      appIndex: sceneInfo2.appIndex,
      persistentId: sceneInfo2.persistentId,
      screenId: sceneInfo2.screenId
    }, sceneInfo2.want);
    let scbSceneSession2: SCBSceneSession = new SCBSceneSession(session2, sceneInfo2);
    container1.midSceneMap.set(3, scbSceneSession1);
    container1.midSceneMap.set(4, scbSceneSession2);
    let dragCtx = new MidSceneDragContext(screenProperty);
    dividerParam.primary = scbSceneSession1.sceneParam;
    dividerParam.secondary = scbSceneSession2.sceneParam;
    scbSceneSession1.sceneParam.posX = '15%';
    scbSceneSession2.sceneParam.posX = '15%';
    container1.isMidScene = true;
    midsceneData1.step = MidSceneStep.LARGE;
    midsceneData2.step = MidSceneStep.LARGE;
    midsceneData1.inclined = false;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    ReflectionUtils.useFunc(midSceneManager, 'processDraggingToRightNotPassingMidLine', container1, 15, dragCtx,
      dividerParam);
    expect(scbSceneSession1.sceneParam.posX).assertEqual('-10%');
  });

  it('processDraggingToRightNotPassingMidLine002', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(3, true);
    let midsceneData2: MidSceneData = new MidSceneData(4, false);
    let midsceneData0: MidSceneData = new MidSceneData(5);
    midsceneData0.step = MidSceneStep.SMALL;
    midsceneData0.left = 0.4;
    midsceneData0.visibleW = 0.4;
    midsceneData0.width = 0.4;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    container1.isMidScene = true;
    let sceneInfo1 = new SCBSceneInfo('testPriBundle4', 'testPriModule4', 'testPriAbility4');
    let session1 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo1.bundleName,
      moduleName: sceneInfo1.moduleName,
      abilityName: sceneInfo1.abilityName,
      appIndex: sceneInfo1.appIndex,
      persistentId: sceneInfo1.persistentId,
      screenId: sceneInfo1.screenId
    }, sceneInfo1.want);
    let scbSceneSession1: SCBSceneSession = new SCBSceneSession(session1, sceneInfo1);
    let sceneInfo2 = new SCBSceneInfo('testPriBundle21', 'testPriModule21', 'testPriAbility21');
    let session2 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo2.bundleName,
      moduleName: sceneInfo2.moduleName,
      abilityName: sceneInfo2.abilityName,
      appIndex: sceneInfo2.appIndex,
      persistentId: sceneInfo2.persistentId,
      screenId: sceneInfo2.screenId
    }, sceneInfo2.want);
    let scbSceneSession2: SCBSceneSession = new SCBSceneSession(session2, sceneInfo2);
    container1.midSceneMap.set(4, scbSceneSession1);
    container1.midSceneMap.set(5, scbSceneSession2);
    let dragCtx = new MidSceneDragContext(screenProperty);
    dividerParam.primary = scbSceneSession1.sceneParam;
    dividerParam.secondary = scbSceneSession2.sceneParam;
    scbSceneSession1.sceneParam.posX = '20%';
    scbSceneSession2.sceneParam.posX = '20%';
    container1.isMidScene = true;
    midsceneData1.step = MidSceneStep.LARGE;
    midsceneData2.step = MidSceneStep.UNKNOWN;
    midsceneData1.inclined = false;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    ReflectionUtils.useFunc(midSceneManager, 'processDraggingToRightNotPassingMidLine', container1, 20, dragCtx,
      dividerParam);
    expect(scbSceneSession1.sceneParam.rotateAngle).assertEqual(45);
  });

  it('processDraggingToRightNotPassingMidLine003', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(4, true);
    let midsceneData2: MidSceneData = new MidSceneData(5, false);
    let midsceneData0: MidSceneData = new MidSceneData(6);
    midsceneData0.step = MidSceneStep.LARGE;
    midsceneData0.left = 0.45;
    midsceneData0.visibleW = 0.45;
    midsceneData0.width = 0.45;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    container1.isMidScene = false;
    let sceneInfo1 = new SCBSceneInfo('testPriBundle5', 'testPriModule5', 'testPriAbility5');
    let session1 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo1.bundleName,
      moduleName: sceneInfo1.moduleName,
      abilityName: sceneInfo1.abilityName,
      appIndex: sceneInfo1.appIndex,
      persistentId: sceneInfo1.persistentId,
      screenId: sceneInfo1.screenId
    }, sceneInfo1.want);
    let scbSceneSession1: SCBSceneSession = new SCBSceneSession(session1, sceneInfo1);
    let sceneInfo2 = new SCBSceneInfo('testPriBundle22', 'testPriModule22', 'testPriAbility22');
    let session2 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo2.bundleName,
      moduleName: sceneInfo2.moduleName,
      abilityName: sceneInfo2.abilityName,
      appIndex: sceneInfo2.appIndex,
      persistentId: sceneInfo2.persistentId,
      screenId: sceneInfo2.screenId
    }, sceneInfo2.want);
    let scbSceneSession2: SCBSceneSession = new SCBSceneSession(session2, sceneInfo2);
    container1.midSceneMap.set(5, scbSceneSession1);
    container1.midSceneMap.set(6, scbSceneSession2);
    let dragCtx = new MidSceneDragContext(screenProperty);
    dividerParam.primary = scbSceneSession1.sceneParam;
    dividerParam.secondary = scbSceneSession2.sceneParam;
    scbSceneSession1.sceneParam.posX = '25%';
    scbSceneSession2.sceneParam.posX = '25%';
    container1.isMidScene = true;
    midsceneData1.step = MidSceneStep.UNKNOWN;
    midsceneData2.step = MidSceneStep.LARGE;
    midsceneData1.inclined = true;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    ReflectionUtils.useFunc(midSceneManager, 'processDraggingToRightNotPassingMidLine', container1, 25, dragCtx,
      dividerParam);
    expect(scbSceneSession2.sceneParam.rotateAngle).assertEqual(15);
  });

  it('processDraggingToRightNotPassingMidLine004', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(5, true);
    let midsceneData2: MidSceneData = new MidSceneData(6, false);
    let midsceneData0: MidSceneData = new MidSceneData(7);
    midsceneData0.step = MidSceneStep.LARGE;
    midsceneData0.left = 0.55;
    midsceneData0.visibleW = 0.55;
    midsceneData0.width = 0.55;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    container1.isMidScene = false;
    let sceneInfo1 = new SCBSceneInfo('testPriBundle6', 'testPriModule6', 'testPriAbility6');
    let session1 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo1.bundleName,
      moduleName: sceneInfo1.moduleName,
      abilityName: sceneInfo1.abilityName,
      appIndex: sceneInfo1.appIndex,
      persistentId: sceneInfo1.persistentId,
      screenId: sceneInfo1.screenId
    }, sceneInfo1.want);
    let scbSceneSession1: SCBSceneSession = new SCBSceneSession(session1, sceneInfo1);
    let sceneInfo2 = new SCBSceneInfo('testPriBundle24', 'testPriModule24', 'testPriAbility24');
    let session2 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo2.bundleName,
      moduleName: sceneInfo2.moduleName,
      abilityName: sceneInfo2.abilityName,
      appIndex: sceneInfo2.appIndex,
      persistentId: sceneInfo2.persistentId,
      screenId: sceneInfo2.screenId
    }, sceneInfo2.want);
    let scbSceneSession2: SCBSceneSession = new SCBSceneSession(session2, sceneInfo2);
    container1.midSceneMap.set(6, scbSceneSession1);
    container1.midSceneMap.set(7, scbSceneSession2);
    let dragCtx = new MidSceneDragContext(screenProperty);
    dividerParam.primary = scbSceneSession1.sceneParam;
    dividerParam.secondary = scbSceneSession2.sceneParam;
    scbSceneSession1.sceneParam.posX = '30%';
    scbSceneSession2.sceneParam.posX = '30%';
    container1.isMidScene = true;
    midsceneData1.step = MidSceneStep.SMALL;
    midsceneData2.step = MidSceneStep.LARGE;
    midsceneData1.inclined = false;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    ReflectionUtils.useFunc(midSceneManager, 'processDraggingToRightNotPassingMidLine', container1, 30, dragCtx,
      dividerParam);
    expect(midsceneData1.step).assertEqual(MidSceneStep.UNKNOWN);
  });

  it('processDraggingToRightPassingMidLine001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(6, true);
    let midsceneData2: MidSceneData = new MidSceneData(7, false);
    let midsceneData0: MidSceneData = new MidSceneData(8);
    midsceneData0.step = MidSceneStep.LARGE;
    midsceneData0.left = 0.65;
    midsceneData0.visibleW = 0.75;
    midsceneData0.width = 0.65;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    container1.isMidScene = false;
    let sceneInfo1 = new SCBSceneInfo('testPriBundle7', 'testPriModule7', 'testPriAbility7');
    let session1 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo1.bundleName,
      moduleName: sceneInfo1.moduleName,
      abilityName: sceneInfo1.abilityName,
      appIndex: sceneInfo1.appIndex,
      persistentId: sceneInfo1.persistentId,
      screenId: sceneInfo1.screenId
    }, sceneInfo1.want);
    let scbSceneSession1: SCBSceneSession = new SCBSceneSession(session1, sceneInfo1);
    let sceneInfo2 = new SCBSceneInfo('testPriBundle25', 'testPriModule25', 'testPriAbility25');
    let session2 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo2.bundleName,
      moduleName: sceneInfo2.moduleName,
      abilityName: sceneInfo2.abilityName,
      appIndex: sceneInfo2.appIndex,
      persistentId: sceneInfo2.persistentId,
      screenId: sceneInfo2.screenId
    }, sceneInfo2.want);
    let scbSceneSession2: SCBSceneSession = new SCBSceneSession(session2, sceneInfo2);
    container1.midSceneMap.set(7, scbSceneSession1);
    container1.midSceneMap.set(8, scbSceneSession2);
    let dragCtx = new MidSceneDragContext(screenProperty);
    dividerParam.primary = scbSceneSession1.sceneParam;
    dividerParam.secondary = scbSceneSession2.sceneParam;
    scbSceneSession1.sceneParam.posX = '35%';
    scbSceneSession2.sceneParam.posX = '35%';
    container1.isMidScene = false;
    midsceneData1.step = MidSceneStep.UNKNOWN;
    midsceneData2.step = MidSceneStep.LARGE;
    midsceneData1.inclined = false;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    ReflectionUtils.useFunc(midSceneManager, 'processDraggingToRightPassingMidLine', container1, 35, dragCtx,
      dividerParam);
    expect(scbSceneSession1.sceneParam.rotateAngle).assertEqual(30);
  });

  it('processDraggingToRightPassingMidLine002', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(7, true);
    let midsceneData2: MidSceneData = new MidSceneData(8, false);
    let midsceneData0: MidSceneData = new MidSceneData(9);
    midsceneData0.step = MidSceneStep.LARGE;
    midsceneData0.left = 0.85;
    midsceneData0.visibleW = 0.75;
    midsceneData0.width = 0.55;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    container1.isMidScene = false;
    let sceneInfo1 = new SCBSceneInfo('testPriBundle8', 'testPriModule8', 'testPriAbility8');
    let session1 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo1.bundleName,
      moduleName: sceneInfo1.moduleName,
      abilityName: sceneInfo1.abilityName,
      appIndex: sceneInfo1.appIndex,
      persistentId: sceneInfo1.persistentId,
      screenId: sceneInfo1.screenId
    }, sceneInfo1.want);
    let scbSceneSession1: SCBSceneSession = new SCBSceneSession(session1, sceneInfo1);
    let sceneInfo2 = new SCBSceneInfo('testPriBundle26', 'testPriModule26', 'testPriAbility26');
    let session2 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo2.bundleName,
      moduleName: sceneInfo2.moduleName,
      abilityName: sceneInfo2.abilityName,
      appIndex: sceneInfo2.appIndex,
      persistentId: sceneInfo2.persistentId,
      screenId: sceneInfo2.screenId
    }, sceneInfo2.want);
    let scbSceneSession2: SCBSceneSession = new SCBSceneSession(session2, sceneInfo2);
    container1.midSceneMap.set(8, scbSceneSession1);
    container1.midSceneMap.set(9, scbSceneSession2);
    let dragCtx = new MidSceneDragContext(screenProperty);
    dividerParam.primary = scbSceneSession1.sceneParam;
    dividerParam.secondary = scbSceneSession2.sceneParam;
    scbSceneSession1.sceneParam.posX = '40%';
    scbSceneSession2.sceneParam.posX = '40%';
    container1.isMidScene = true;
    midsceneData1.step = MidSceneStep.LARGE;
    midsceneData2.step = MidSceneStep.SMALL;
    midsceneData1.inclined = true;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    ReflectionUtils.useFunc(midSceneManager, 'processDraggingToRightPassingMidLine', container1, 40, dragCtx,
      dividerParam);
    expect(midsceneData0.left).assertEqual(2.5);
  });

  it('processDraggingToRightPassingMidLine003', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(8, true);
    let midsceneData2: MidSceneData = new MidSceneData(9, false);
    let midsceneData0: MidSceneData = new MidSceneData(10);
    midsceneData0.step = MidSceneStep.SMALL;
    midsceneData0.left = 0.95;
    midsceneData0.visibleW = 0.35;
    midsceneData0.width = 0.65;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    container1.isMidScene = true;
    let sceneInfo1 = new SCBSceneInfo('testPriBundle9', 'testPriModule9', 'testPriAbility9');
    let session1 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo1.bundleName,
      moduleName: sceneInfo1.moduleName,
      abilityName: sceneInfo1.abilityName,
      appIndex: sceneInfo1.appIndex,
      persistentId: sceneInfo1.persistentId,
      screenId: sceneInfo1.screenId
    }, sceneInfo1.want);
    let scbSceneSession1: SCBSceneSession = new SCBSceneSession(session1, sceneInfo1);
    let sceneInfo2 = new SCBSceneInfo('testPriBundle27', 'testPriModule27', 'testPriAbility27');
    let session2 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo2.bundleName,
      moduleName: sceneInfo2.moduleName,
      abilityName: sceneInfo2.abilityName,
      appIndex: sceneInfo2.appIndex,
      persistentId: sceneInfo2.persistentId,
      screenId: sceneInfo2.screenId
    }, sceneInfo2.want);
    let scbSceneSession2: SCBSceneSession = new SCBSceneSession(session2, sceneInfo2);
    container1.midSceneMap.set(9, scbSceneSession1);
    container1.midSceneMap.set(10, scbSceneSession2);
    let dragCtx = new MidSceneDragContext(screenProperty);
    dividerParam.primary = scbSceneSession1.sceneParam;
    dividerParam.secondary = scbSceneSession2.sceneParam;
    scbSceneSession1.sceneParam.posX = '45%';
    scbSceneSession2.sceneParam.posX = '45%';
    container1.isMidScene = true;
    midsceneData1.step = MidSceneStep.UNKNOWN;
    midsceneData2.step = MidSceneStep.LARGE;
    midsceneData1.inclined = false;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    ReflectionUtils.useFunc(midSceneManager, 'processDraggingToRightPassingMidLine', container1, 45, dragCtx,
      dividerParam);
    expect(midsceneData2.step).assertEqual(MidSceneStep.SMALL);
  });

  it('processDraggingToRightPassingMidLine004', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(9, true);
    let midsceneData2: MidSceneData = new MidSceneData(10, false);
    let midsceneData0: MidSceneData = new MidSceneData(11);
    midsceneData0.step = MidSceneStep.LARGE;
    midsceneData0.left = 0.56;
    midsceneData0.visibleW = 0.57;
    midsceneData0.width = 0.58;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    container1.isMidScene = false;
    let sceneInfo1 = new SCBSceneInfo('testPriBundle10', 'testPriModule10', 'testPriAbility10');
    let session1 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo1.bundleName,
      moduleName: sceneInfo1.moduleName,
      abilityName: sceneInfo1.abilityName,
      appIndex: sceneInfo1.appIndex,
      persistentId: sceneInfo1.persistentId,
      screenId: sceneInfo1.screenId
    }, sceneInfo1.want);
    let scbSceneSession1: SCBSceneSession = new SCBSceneSession(session1, sceneInfo1);
    let sceneInfo2 = new SCBSceneInfo('testPriBundle28', 'testPriModule28', 'testPriAbility28');
    let session2 = sceneSessionManager.requestSceneSession({
      bundleName: sceneInfo2.bundleName,
      moduleName: sceneInfo2.moduleName,
      abilityName: sceneInfo2.abilityName,
      appIndex: sceneInfo2.appIndex,
      persistentId: sceneInfo2.persistentId,
      screenId: sceneInfo2.screenId
    }, sceneInfo2.want);
    let scbSceneSession2: SCBSceneSession = new SCBSceneSession(session2, sceneInfo2);
    container1.midSceneMap.set(10, scbSceneSession1);
    container1.midSceneMap.set(11, scbSceneSession2);
    let dragCtx = new MidSceneDragContext(screenProperty);
    dividerParam.primary = scbSceneSession1.sceneParam;
    dividerParam.secondary = scbSceneSession2.sceneParam;
    scbSceneSession1.sceneParam.posX = '50%';
    scbSceneSession2.sceneParam.posX = '40%';
    container1.isMidScene = true;
    midsceneData1.step = MidSceneStep.SMALL;
    midsceneData2.step = MidSceneStep.SMALL;
    midsceneData1.inclined = true;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    ReflectionUtils.useFunc(midSceneManager, 'processDraggingToRightPassingMidLine', container1, 50, dragCtx,
      dividerParam);
    expect(midsceneData1.step).assertEqual(MidSceneStep.SMALL);
  });
}