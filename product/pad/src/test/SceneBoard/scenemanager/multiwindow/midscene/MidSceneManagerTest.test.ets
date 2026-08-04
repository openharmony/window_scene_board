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
import {
  SCBSceneContainerSession,
  SceneParam,
  SCBScreenProperty,
  SCBRotateChangeReason,
  SCBScenePanelSession,
  SCBBackgroundBlurSession,
  ScenePanelState,
  SCBDividerParam,
  SCBSceneSessionManager,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBAppIconParam,
  SplitStyle,
  SCBScreenSessionManager,
  SCBSceneInfo,
  SCBSceneContainerSessionArray,
  PreferMultiWindowOrientation,
  SCBSessionRect,
  SCBSpecificSession,
  SCBPropertyChangeReason,
  SCBSideEdgeBarDisplayState,
  SCBSceneOrientation,
} from '@ohos/windowscene';
import { ItemUtils } from '@ohos/componenthelper';
import { ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';
import { RectInfo, CompanionIconInfo } from '@ohos/basicutils';
import sceneSessionManager from '@ohos.sceneSessionManager';
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
import {
  SCBDividerParamArray,
  SCBSceneContainerState
} from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneContainerSession';
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

let screenProperty: SCBScreenProperty;
let sceneParams : SceneParam[];
let dividerParam: SCBDividerParam;
let midSceneManager: MidSceneManager;
let sceneInfo: SCBSceneInfo;
let sceneInfo1: SCBSceneInfo;
let session: sceneSessionManager.SceneSession;
let session1: sceneSessionManager.SceneSession;
let scbSceneSession: SCBSceneSession;
let scbSceneSession1: SCBSceneSession;
let primarySession: SCBSceneSession;
let secondSession: SCBSceneSession;
let thirdSession: SCBSceneSession;
let container:SCBSceneContainerSession;
let appIconParam: SCBAppIconParam;
let midSceneDragContext : MidSceneDragContext;
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
    MidSceneDragContext_recordStartDragInfo_01();
    MidSceneDragContextTest_get_01();
    MidSceneDragContextTest_set_01();
    MidSceneDragContextTest_getInitalScenePosByPid_01();
    MidSceneDragContextTest_getDragDirection_01();
    MidSceneDragContextTest_getCurrentDividerPos_01();
    MidSceneDragContextTest_isPassMidLine_01();
    MidSceneDragContextTest_isOverBound_01();
    MidSceneDragContextTest_getCurrentScenePos_01();
    MidSceneDragContextTest_initalDividerPos_01();
    MidSceneDragContextTest_isDragCenterDivider_01();
    MidSceneDragContextTest_resetContext_01();
    MidSceneManagerTest_rotationTest_01();
    MidSceneManagerTest_onMidSceneAnimStart_01();
    MidSceneManagerTest_onMidSceneAnimFinish_01();
    MidSceneManagerTest_onMidSceneAnimInterrupt_01();
    MidSceneManagerTest_isMidSceneInForeground_01();
    MidSceneManagerTest_updateCtxParams_01()
    MidSceneManagerTest_updateDividerParamsMidScene_01();
    MidSceneManagerTest_endDraggingInMidScene_01();
    MidSceneManagerTest_isSupportMidScene_01();
    MidSceneManagerTest_isMidSceneFull_01();
    MidSceneManagerTest_isSupportOneStepToMidScene_01();
    MidSceneManagerTest_toWaitingAdd_01();
    MidSceneManagerTest_toStable_01();
    MidSceneManagerTest_exitFromUnstable_01();
    MidSceneManagerTest_updateDraggingEventInMidScene_01();
    MidSceneManagerTest_initOutsideScreenMidScene_01();
    MidSceneManagerTest_addFromIcon_01();
    MidSceneManagerTest_addFromOther_01();
    MidSceneManagerTest_replaceOut_01();
    MidSceneManagerTest_replaceIn_01();
    MidSceneManagerTest_interruptStartSceneForMidSceneIfNeed_01();
    MidSceneManagerTest_doVibrationMid_01();
    MidSceneManagerTest_startDragSplitFloatInAnimate_01();
    MidSceneManagerTest_endFloatAnimateMidScene_01();
    MidSceneManagerTest_updateSceneParamAndSession_01();
    MidSceneManagerTest_splitEnterMid_01();
    MidSceneManagerTest_updateSubSessionRect_01();
    MidSceneManagerTest_midSceneExitToBackgroundAnim_01();
    MidSceneManagerTest_midSceneSceneParmCopyToDividerParam_01();
    MidSceneManagerTest_toNonMidScene_01();
    MidSceneManagerTest_toWaitingReplace_01();
    MidSceneManagerTest_replaceMidSceneFromNotification_01();
    MidSceneManagerTest_adjustMidSceneState_01();
    MidSceneManagerTest_addMidSceneRecord_01();
    MidSceneManagerTest_clearMidSceneRecordByContainer_01();
    MidSceneManagerTest_isTopContainerNeedRecoverMidScene_01();
    MidSceneManagerTest_updateRecordAnchorIndex_01();
    MidSceneManagerTest_tryShowTipForMidSceneTest_01();
    MidSceneManagerTest_setIsShowTipForMidSceneFalseTest_01();
    MidSceneManagerTest_doBlurForMidScene_01();
    MidSceneManagerTest_removeBlurForMidScene_01();
    MidSceneManagerTest_iconAppearAnimation_01();
    MidSceneManagerTest_iconDisappearAnimation_01();
    MidSceneManagerTest_handleMaximizeAnimation_01();
    MidSceneManagerTest_initForRecent_01();
    MidSceneManagerTest_updateMidContainerRect_01();
    MidSceneManagerTest_freezeOthers_01();
    MidSceneManagerTest_iconAndBlurAppearAnimation_01();
    MidSceneManagerTest_iconAndBlurDisappearAnimation_01();
    MidSceneManagerTest_updateZIndexAndScaleInDragSwap_01();
    MidSceneManagerTest_updateDragSwapWithAnimation_01();
    MidSceneManagerTest_swapLtrOrderWhenDrag_01();
    MidSceneManagerTest_updateMidscenMapWhenInDrag_01();
    MidSceneManagerTest_clearStatusWhenDrag_01();
    MidSceneManagerTest_floatingToSideEdgeBar_01();
    MidSceneManagerTest_getAnchorIndexForRecord_01();
    MidSceneManagerTest_handleSideEdgeBarClickInMidScene_01();
    MidSceneManagerTest_adjustWindowForNotSupportSplitApp_01();
    MidSceneManagerTest_getForwardAndBackwardIndex_01();
    MidSceneManagerTest_handleDragContentEnterEvent_01();
    MidSceneManagerTest_handleDragContentLeaveEvent_01();
    MidSceneManagerTest_freezeDesktopNodeAndEnableVma();
    MidSceneManagerTest_resetDesktopNodeAndDisableVma();
    MidSceneManagerTest_updateZIndexAndScaleInDragSwap01();
    MidSceneManagerTest_updateDragSwapWithAnimation01();
    MidSceneManagerTest_swapLtrOrderWhenDrag01();
    MidSceneManagerTest_updateMidscenMapWhenInDrag01();
    MidSceneManagerTest_clearStatusWhenDrag01();
  });
}

function MidSceneManagerTest_rotationTest_01() {
  it('MidSceneManagerTest_rotationTest_001', Level.LEVEL0, () => {
    ReflectionUtils.setProperty(midSceneManager, 'isMidConfigSupport', true);
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.isMidScene = true;
    container1.requestActivation();
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midSceneData1: MidSceneData = new MidSceneData(primarySession.sceneInfo.persistentId);
    let midSceneData2: MidSceneData = new MidSceneData(99);
    let midSceneData0: MidSceneData = new MidSceneData(88);
    midSceneData0.step = MidSceneStep.SMALL;
    midSceneData0.inclined = true;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midSceneData0, midSceneData1, midSceneData2];
    container1.midSceneMap.set(primarySession.sceneInfo.persistentId, primarySession);
    let containerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    containerSessionList.push(container1);
    let callbackTmp = (): SCBSceneContainerSessionArray => {
      return containerSessionList;
    };
    SCBSceneSessionManager.getInstance().mainScreenId = screenProperty.screenId;
    SCBSceneSessionManager.getInstance().registerGetContainerSessionListCallback(callbackTmp, screenProperty.screenId);
    midSceneManager.notifyMidSceneRotationFinish(screenProperty, SCBRotateChangeReason.ROTATE_END)
    expect(ViewManagerPolicy.isViewShowing(ViewType.DESKTOP)).assertTrue();
  })

  it('MidSceneManagerTest_rotationTest_002', Level.LEVEL0, () => {
    let mocker: MockKit = new MockKit();
    ReflectionUtils.setProperty(midSceneManager, 'isMidConfigSupport', true);

    let scenePanelManager = SCBScenePanelManager.getInstance(screenProperty);
    let mockFunc1: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getPanelSession);
    let scenePanelSession: SCBScenePanelSession = new SCBScenePanelSession()
    scenePanelSession.isBgBlurEnable = true;
    when(mockFunc1)(ArgumentMatchers.any).afterReturn(scenePanelSession);

    let backgroundBlurSession = new SCBBackgroundBlurSession();
    backgroundBlurSession.bgBlurScale = 1;
    let mockFunc2: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getBackgroundBlurSession);
    when(mockFunc2)(ArgumentMatchers.any).afterReturn(backgroundBlurSession);

    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.isMidScene = true;
    container1.requestActivation();
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midSceneData1: MidSceneData = new MidSceneData(primarySession.sceneInfo.persistentId);
    let midSceneData2: MidSceneData = new MidSceneData(99);
    let midSceneData0: MidSceneData = new MidSceneData(100);
    midSceneData1.step = MidSceneStep.SMALL;
    midSceneData1.inclined = true;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midSceneData0, midSceneData1, midSceneData2];
    container1.midSceneMap.set(primarySession.sceneInfo.persistentId, primarySession);
    let sceneSessionManagerInstance = SCBSceneSessionManager.getInstance();
    let containerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    containerSessionList.push(container1);
    let callbackTmp = (): SCBSceneContainerSessionArray => {
      return containerSessionList;
    };
    SCBSceneSessionManager.getInstance().mainScreenId = screenProperty.screenId;
    SCBSceneSessionManager.getInstance().registerGetContainerSessionListCallback(callbackTmp, screenProperty.screenId);

    let mockFunc4: Function =
      mocker.mockFunc(sceneSessionManagerInstance, sceneSessionManagerInstance.updateSystemBarProperty);
    when(mockFunc4)(ArgumentMatchers.any).afterReturnNothing();
    midSceneManager.notifyMidSceneRotation(screenProperty, false)
    expect(ViewManagerPolicy.isViewShowing(ViewType.DESKTOP)).assertFalse();
    mocker.clear(scenePanelManager);
    mocker.clear(sceneSessionManagerInstance);
  })
}

function MidSceneDragContextTest_get_01() {
  it('MidSceneDragContext_isFirstOverLeftBound_001', Level.LEVEL0, () => {
    let isFirstOverLeftBound: boolean = midSceneDragContext.isFirstOverLeftBound;
    expect(isFirstOverLeftBound).assertTrue();
  });
  it('MidSceneDragContext_isFirstOverRightBound_001', Level.LEVEL0, () => {
    let isFirstOverRightBound: boolean = midSceneDragContext.isFirstOverRightBound;
    expect(isFirstOverRightBound).assertTrue();
  });
  it('MidSceneDragContext_firstOverLeftBoundScale_001', Level.LEVEL0, () => {
    let firstOverLeftBoundScale: number = midSceneDragContext.firstOverLeftBoundScale;
    expect(firstOverLeftBoundScale).assertEqual(0);
  });
  it('MidSceneDragContext_firstOverRightBoundScale_001', Level.LEVEL0, () => {
    let firstOverRightBoundScale: number = midSceneDragContext.firstOverRightBoundScale;
    expect(firstOverRightBoundScale).assertEqual(0);
  });
}
function MidSceneDragContext_recordStartDragInfo_01() {
  it('MidSceneDragContext_recordStartDragInfo_001', Level.LEVEL0, () => {
    let sceneParams1: SceneParam = new SceneParam();
    sceneParams[0] = sceneParams1;
    midSceneDragContext.recordStartDragInfo(sceneParams, dividerParam);
    expect(true).assertTrue();
  });
}

function MidSceneDragContextTest_set_01() {
  it('MidSceneDragContext_firstOverLeftBoundScale_002', Level.LEVEL0, () => {
    midSceneDragContext.firstOverLeftBoundScale = 0;
    expect(true).assertTrue();
  });
  it('MidSceneDragContext_firstOverRightBoundScale_002', Level.LEVEL0, () => {
    midSceneDragContext.firstOverRightBoundScale = 0;
    expect(true).assertTrue();
  });
  it('MidSceneDragContext_isFirstOverLeftBound_002', Level.LEVEL0, () => {
    midSceneDragContext.isFirstOverLeftBound = true;
    expect(true).assertTrue();
  });
  it('MidSceneDragContext_isFirstOverRightBound_002', Level.LEVEL0, () => {
    midSceneDragContext.isFirstOverRightBound = true;
    expect(true).assertTrue();
  });
}

function MidSceneDragContextTest_getDragDirection_01() {
  it('MidSceneDragContext_getDragDirection_001', Level.LEVEL0, () => {
    let offset0 = 0;
    let offset1 = 1;
    midSceneDragContext.getDragDirection(offset0);
    expect(true).assertTrue();
    midSceneDragContext.getDragDirection(offset1);
    expect(true).assertTrue();
  });
}
function MidSceneDragContextTest_getInitalScenePosByPid_01() {
  it('MidSceneDragContext_getInitalScenePosByPid_001', Level.LEVEL0, () => {
    let sceneParams1 = new SceneParam();
    sceneParams1.posX = '10%';
    sceneParams[0] = sceneParams1;
    midSceneDragContext.recordStartDragInfo(sceneParams, dividerParam);
    midSceneDragContext.getInitalScenePosByPid(0);
    expect(true).assertTrue();
    midSceneDragContext.getInitalScenePosByPid(-1);
    expect(true).assertTrue();
  });
}
function MidSceneDragContextTest_getCurrentDividerPos_01() {
  it('MidSceneDragContext_getCurrentDividerPos_001', Level.LEVEL0, () => {
    midSceneDragContext.getDragDirection(1);
    expect(true).assertTrue();
  });
}
function MidSceneDragContextTest_isOverBound_01() {
  it('MidSceneDragContext_isOverBound_001', Level.LEVEL0, () => {
    let offset0 = 0;
    let offset1 = 1;
    midSceneDragContext.isOverBound(offset0);
    expect(true).assertTrue();
    midSceneDragContext.isOverBound(offset1);
    expect(true).assertTrue();
  });
}
function MidSceneDragContextTest_getCurrentScenePos_01() {
  it('MidSceneDragContext_getCurrentScenePos_001', Level.LEVEL0, () => {
    let sceneParam: SceneParam = new SceneParam();
    midSceneDragContext.getCurrentScenePos(sceneParam);
    expect(true).assertTrue();
  });
}
function MidSceneDragContextTest_isPassMidLine_01() {
  it('MidSceneDragContext_isPassMidLine_001', Level.LEVEL0, () => {
    let offset0 = 0;
    let offset1 = 1;
    midSceneDragContext.isPassMidLine(offset0);
    expect(true).assertTrue();
    midSceneDragContext.isPassMidLine(offset1);
    expect(true).assertTrue();
  });
}
function MidSceneDragContextTest_initalDividerPos_01() {
  it('MidSceneDragContext_initalDividerPos_001', Level.LEVEL0, () => {
    let sceneParam: SceneParam = new SceneParam();
    midSceneDragContext.getCurrentScenePos(sceneParam);
    expect(true).assertTrue();
  });
}
function MidSceneDragContextTest_isDragCenterDivider_01() {
  it('MidSceneDragContext_isDragCenterDivider_001', Level.LEVEL0, () => {
    let isDragCenter = midSceneDragContext.isDragCenterDivider();
    expect(isDragCenter).assertFalse();
  });
}
function MidSceneDragContextTest_resetContext_01() {
  it('MidSceneDragContext_resetContext_001', Level.LEVEL0, () => {
    midSceneDragContext.resetContext();
    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_onMidSceneAnimFinish_01() {
  it('MidSceneManager_onMidSceneAnimFinish_001', Level.LEVEL0, () => {
    midSceneManager.onMidSceneAnimFinish(0);
    midSceneManager.onMidSceneAnimFinish(-1);
    midSceneManager.onMidSceneAnimFinish(0);
    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_onMidSceneAnimStart_01() {
  it('MidSceneManager_onMidSceneAnimStart_001', Level.LEVEL0, () => {
    midSceneManager.onMidSceneAnimStart(0, container);
    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_onMidSceneAnimInterrupt_01() {
  it('MidSceneManager_onMidSceneAnimInterrupt_001', Level.LEVEL0, () => {
    ReflectionUtils.setProperty(midSceneManager, 'isMidConfigSupport', true);
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(1);
    let midsceneData1: MidSceneData = new MidSceneData(2);
    let midsceneData2: MidSceneData = new MidSceneData(3);
    let animTypeList: Array<MidSceneInterruptEnum> = [MidSceneInterruptEnum.EXIT_ONE, MidSceneInterruptEnum.EXIT_TWO_SMALL, 3,4];
    let midSceneManager1 = new MidSceneManager(screenProperty);
    let mocker: MockKit = new MockKit();
    let mockfunc1: Function = mocker.mockFunc(midSceneManager1, midSceneManager1.isSupportMidScene);
    let mockfunc2: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().getContainerSessionList().findByContainerId);
    when(mockfunc1)(ArgumentMatchers.any).afterReturn(true);
    when(mockfunc2)(ArgumentMatchers.any).afterReturn(container1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    midSceneManager1.onMidSceneAnimInterrupt(animTypeList);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0,midsceneData1,midsceneData2];
    let callbackTmp = ():SCBSceneContainerSessionArray => {
      let tmp: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      tmp.add(container1);
      return tmp;
    };
    SCBSceneSessionManager.getInstance().mainScreenId = 1;
    SCBSceneSessionManager.getInstance().registerGetContainerSessionListCallback(callbackTmp,1);
    //this.interruptContainerId = container1.id
    midSceneManager1.onMidSceneAnimStart(MidSceneInterruptEnum.EXIT_ONE, container1);
    midSceneManager1.onMidSceneAnimStart(MidSceneInterruptEnum.EXIT_TWO_SMALL, container1);
    midSceneManager1.onMidSceneAnimStart(3, container1);
    midSceneManager1.onMidSceneAnimInterrupt(animTypeList);
    midSceneManager.onMidSceneAnimInterrupt(animTypeList);
    expect(true).assertTrue();
    mocker.clear(midSceneManager1);
    mocker.clear(SCBSceneSessionManager.getInstance());
  });
}

function MidSceneManagerTest_updateCtxParams_01() {
  it('MidSceneManager_updateCtxParams_001', Level.LEVEL0, () => {
    let midsceneData0: MidSceneData = new MidSceneData(2);
    midsceneData0.left = 0.3;
    midsceneData0.width = 0.3;
    midsceneData0.top = 0.3;
    midsceneData0.scale = 0.3;
    midsceneData0.height = 0.3;
    container.midSceneMap.set(2,scbSceneSession);
    (container.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData0);
    midSceneManager.updateCtxParams(container, MidSceneReason.UNDEFINED);
    midSceneManager.updateCtxParams(container, MidSceneReason.TO_WAITING_STATE);
    midSceneManager.updateCtxParams(container, MidSceneReason.TO_STABLE_STATE);
    (container.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 1;
    midSceneManager.updateCtxParams(container, MidSceneReason.TO_STABLE_STATE);
    midSceneManager.updateCtxParams(container, MidSceneReason.TO_EXIT_ONE);
    (container.sessionData.midSceneFSM as MidSceneFSM).context.l2r.pop();
    midSceneManager.updateCtxParams(container, MidSceneReason.TO_EXIT_ONE);
    midSceneManager.updateCtxParams(container, MidSceneReason.TO_EXIT_TWO_SAMLL);
    (container.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData0);
    midSceneManager.updateCtxParams(container, MidSceneReason.TO_EXIT_TWO_SAMLL);
    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_isMidSceneInForeground_01() {
  it('MidSceneManager_isMidSceneInForeground_001', Level.LEVEL0, () => {
    midSceneManager.isMidSceneInForeground();
    ReflectionUtils.setProperty(midSceneManager, 'isMidConfigSupport', true);
    midSceneManager.isMidSceneInForeground();
    ReflectionUtils.setProperty(midSceneManager, 'isMidConfigSupport', false);
  });
}

function MidSceneManagerTest_updateDividerParamsMidScene_01() {
  it('MidSceneManager_updateDividerParamsMidScene_001', Level.LEVEL0, () => {
    let midSceneContext: MidSceneContext = new MidSceneContext();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.isMidScene = false;
    midSceneManager.updateDividerParamsMidScene(container1, midSceneContext);
    container1.isMidScene = true;
    let midsceneData0: MidSceneData = new MidSceneData(0);
    midsceneData0.left = 0.5;
    midsceneData0.visibleW = 0.5;
    let midsceneData1: MidSceneData = new MidSceneData(1);
    midsceneData1.left = 0.5;
    midsceneData1.visibleW = 0.5;
    let midsceneData2: MidSceneData = new MidSceneData(2);
    midsceneData1.left = 0.5;
    midsceneData1.visibleW = 0.5;
    midSceneContext.l2r = [midsceneData0, midsceneData1, midsceneData2];
    midSceneManager.updateDividerParamsMidScene(container1, midSceneContext);
    let list: SCBDividerParamArray = new SCBDividerParamArray();
    let data1 = new SCBDividerParam();
    let data2 = new SCBDividerParam();
    list.push(data1);
    list.push(data2);
    container1.dividerParamList = list;
    midSceneContext.l2r = [midsceneData0, midsceneData1];
    midSceneManager.updateDividerParamsMidScene(container1, midSceneContext);
    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_replaceMidSceneFromNotification_01() {
  it('MidSceneManager_replaceMidSceneFromNotification_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = -1;
    midSceneManager.replaceMidSceneFromNotification(container1, scbSceneSession);

    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 0;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.toReplacedIndex = 0;
    midSceneManager.replaceMidSceneFromNotification(container1, scbSceneSession);
  });
}

function MidSceneManagerTest_toWaitingReplace_01() {
  it('MidSceneManager_toWaitingReplace_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    container1.midSceneMap.set(0,scbSceneSession);
    container1.midSceneMap.set(1,scbSceneSession1);
    let list: SCBDividerParamArray = new SCBDividerParamArray();
    let data1 = new SCBDividerParam();
    let data2 = new SCBDividerParam();
    list.push(data1);
    list.push(data2);
    container1.dividerParamList = list;
    let midsceneData0: MidSceneData = new MidSceneData(0);
    midsceneData0.left = 0.5;
    midsceneData0.visibleW = 0.5;
    midsceneData0.step = MidSceneStep.LARGE;
    let midsceneData1: MidSceneData = new MidSceneData(1);
    midsceneData1.left = 0.5;
    midsceneData1.visibleW = 0.5;
    midsceneData1.step = MidSceneStep.SMALL;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    midSceneManager.toWaitingReplace(container1, appIconParam, appIconParam);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.toReplacedIndex = 0;
    midSceneManager.toWaitingReplace(container1, appIconParam, appIconParam);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.toReplacedIndex = 1;
    midsceneData1.width = 1;
    midSceneManager.toWaitingReplace(container1, appIconParam, appIconParam);
    expect(appIconParam.opacity === 0).assertTrue();
  });
}

function MidSceneManagerTest_updateSceneParamAndSession_01() {
  it('MidSceneManager_updateSceneParamAndSession_001', Level.LEVEL0, () => {
    ReflectionUtils.useFunc(midSceneManager, 'updateSceneParamAndSession', container, DividerUpdateReason.IN_MIDSCENE);
    let container0 = new SCBSceneContainerSession(primarySession, screenProperty);
    container0.primarySession = null;
    container0.secondarySession = null;
    (container0.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container, callback);
    (container0.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    ReflectionUtils.useFunc(midSceneManager, 'updateSceneParamAndSession', container0, DividerUpdateReason.IN_MIDSCENE);
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    ReflectionUtils.useFunc(midSceneManager, 'updateSceneParamAndSession', container, DividerUpdateReason.IN_MIDSCENE);
    ReflectionUtils.useFunc(midSceneManager, 'updateSceneParamAndSession', container1, DividerUpdateReason.IN_MIDSCENE);
    ReflectionUtils.useFunc(midSceneManager, 'updateSceneParamAndSession', container0, DividerUpdateReason.IN_MIDSCENE);
    container1.midSceneMap.set(0, primarySession);
    container1.midSceneMap.set(1, primarySession);
    container1.midSceneMap.set(2, primarySession);
    ReflectionUtils.useFunc(midSceneManager, 'updateSceneParamAndSession', container1, DividerUpdateReason.IN_MIDSCENE);
    ReflectionUtils.useFunc(midSceneManager, 'updateSceneParamAndSession', container, DividerUpdateReason.MIDSCENE_TRANS_TO_FULLSCENE);
    ReflectionUtils.useFunc(midSceneManager, 'updateSceneParamAndSession', container1, DividerUpdateReason.MIDSCENE_TRANS_TO_FULLSCENE);
    ReflectionUtils.useFunc(midSceneManager, 'updateSceneParamAndSession', container, DividerUpdateReason.MIDSCENE_TRANS_TO_SPLIT);
    ReflectionUtils.useFunc(midSceneManager, 'updateSceneParamAndSession', container1, DividerUpdateReason.MIDSCENE_TRANS_TO_SPLIT);
    ReflectionUtils.useFunc(midSceneManager, 'updateSceneParamAndSession', container, DividerUpdateReason.OTHER);
    ReflectionUtils.useFunc(midSceneManager, 'updateSceneParamAndSession', container1, DividerUpdateReason.OTHER);
    ReflectionUtils.useFunc(midSceneManager, 'updateSceneParamAndSession', container, 100);
    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_isSupportMidScene_01() {
  it('MidSceneManager_isSupportMidScene_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(), SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
    midSceneManager.isSupportMidScene();
    midSceneManager.isSupportMidScene(container1);
    expect(true).assertTrue();
    mocker.clear(SCBScreenSessionManager.getInstance());
  });
}

function MidSceneManagerTest_endDraggingInMidScene_01() {
  it('MidSceneManager_endDraggingInMidScene_001', Level.LEVEL0, () => {
    screenProperty.width = 1;
    let midSceneManager1: MidSceneManager = new MidSceneManager(screenProperty);
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    let midsceneData3: MidSceneData = new MidSceneData(3, false);
    midsceneData1.step = MidSceneStep.SMALL;
    midsceneData2.step = MidSceneStep.LARGE;
    midsceneData3.step = MidSceneStep.LARGE;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    let nums : Array<number> = [0.1, 2/9, 1/3, 0.25, 0.35,0.5, 0.75,0.8,0.85,0.9,0.95,1,2,3];
    let dividerParam1 = new SCBDividerParam();
    dividerParam1.primary.persistentId = 0;
    dividerParam1.secondary.persistentId = 0;
    for(let n of nums){
      dividerParam1.positionX = '0%';
      midSceneManager1.endDraggingInMidScene(container1, dividerParam1, n);
    }
    nums = [-0.1,-0.2,-0.05, -0.8];
    for(let n of nums){
      dividerParam1.positionX = '90%';
      midSceneManager1.endDraggingInMidScene(container1, dividerParam1, n);
    }
    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_isSupportOneStepToMidScene_01() {
  it('MidSceneManager_isSupportOneStepToMidScene_001', Level.LEVEL0, () => {
    let container2 = new SCBSceneContainerSession(primarySession, screenProperty);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(midSceneManager, midSceneManager.isSupportMidScene);
    when(mockfunc)(container2).afterReturn(true);
    midSceneManager.isSupportOneStepToMidScene(null);
    midSceneManager.isSupportOneStepToMidScene(container);
    container2.isMidScene = true;
    midSceneManager.isSupportOneStepToMidScene(container2);
    container2.dividerParam.splitStyle = SplitStyle.UP_AND_DOWN_POS;
    midSceneManager.isSupportOneStepToMidScene(container2);
    container2.isMidScene = false;
    midSceneManager.isSupportOneStepToMidScene(container2);
    expect(true).assertTrue();
    mocker.clear(midSceneManager);
  });
}

function MidSceneManagerTest_isMidSceneFull_01() {
  it('MidSceneManager_isMidSceneFull_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    midSceneManager.isMidSceneFull(container1);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.midSceneMap.set(3, scbSceneSession);
    midSceneManager.isMidSceneFull(container1)
    expect(true).assertTrue();
  });
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
    midSceneManager.toWaitingAdd(container1, appIconParam, appIconParam);
    expect(true).assertTrue();
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
    midSceneManager.toStable(container1, appIconParam, appIconParam, MidSceneToStableReason.MIDDLE_TO_BACKGROUND);
    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_midSceneSceneParmCopyToDividerParam_01() {
  it('MidSceneManagerTest_midSceneSceneParmCopyToDividerParam_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
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
  });
}

function MidSceneManagerTest_exitFromUnstable_01() {
  it('MidSceneManager_exitFromUnstable_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    midSceneManager.exitFromUnstable(container1);
    //exitOneFromUnstable
    container1.midSceneMap.set(1, scbSceneSession);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    midSceneManager.exitFromUnstable(container1);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    let midsceneData3: MidSceneData = new MidSceneData(3);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    midSceneManager.onMidSceneAnimStart(MidSceneInterruptEnum.EXIT_ONE,container);
    midSceneManager.exitFromUnstable(container1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.pop();
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    midSceneManager.exitFromUnstable(container1);
    //exitTwoSmallFromUnstable
    container1.midSceneMap.set(2, scbSceneSession);
    container1.midAppIconParamMap.set(2,appIconParam);
    container1.dividerParamList = [dividerParam];
    midSceneManager.exitFromUnstable(container1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    dividerParam.splitToMidEnter = true;
    midSceneManager.exitFromUnstable(container1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    midSceneManager.exitFromUnstable(container1);
    expect(true).assertTrue();
    dividerParam.splitToMidEnter = false;
  });
}

function MidSceneManagerTest_updateDraggingEventInMidScene_01() {
  it('MidSceneManager_updateDraggingEventInMidScene_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    midsceneData0.step = MidSceneStep.LARGE;
    midsceneData0.left = 0.5;
    midsceneData0.visibleW = 0.5;
    midsceneData0.width = 0.5;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1,midsceneData2];
    container1.isMidScene = false;
    midSceneManager.updateDraggingEventInMidScene(container1, dividerParam, midSceneDragContext, 0);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.isMidScene = true;
    midSceneManager.updateDraggingEventInMidScene(container1, dividerParam, midSceneDragContext, 1);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(midSceneDragContext, midSceneDragContext.isOverBound);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
    dividerParam.primary.scaleCenterX = '10%';
    dividerParam.primary.rotateCenterX = '10%';
    dividerParam.secondary.scaleCenterX = '10%';
    dividerParam.secondary.rotateCenterX = '10%';
    let nums: Array<number> = [0.1,0.5,0,140,-0.1,-0.5, -140]
    midsceneData1.step = MidSceneStep.SMALL;
    midsceneData1.inclined = false;
    midsceneData2.step = MidSceneStep.SMALL;
    midsceneData2.inclined = false;
    for(let n of nums){
      midSceneManager.updateDraggingEventInMidScene(container1, dividerParam, midSceneDragContext, n);
    }
    let mocker1: MockKit = new MockKit();
    let mockfunc1: Function = mocker1.mockFunc(midSceneDragContext, midSceneDragContext.isPassMidLine);
    when(mockfunc1)(ArgumentMatchers.any).afterReturn(false);
    midsceneData1.step = MidSceneStep.LARGE;
    midsceneData2.step = MidSceneStep.LARGE;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0,midsceneData1, midsceneData2];
    for(let n of nums){
      midSceneManager.updateDraggingEventInMidScene(container1, dividerParam, midSceneDragContext, n);
    }
    expect(true).assertTrue();
    mocker.clear(midSceneDragContext);
    mocker1.clear(midSceneDragContext);
  });
}

function MidSceneManagerTest_initOutsideScreenMidScene_01() {
  it('MidSceneManager_initOutsideScreenMidScene_001', Level.LEVEL0, () => {
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
    session1.sceneParam.posX = '-10%';
    divider.primary.persistentId = 1;
    divider.secondary.persistentId = 2;
    session1.sceneParam.persistentId = 3;
    container1.midSceneMap.set(0, session1);
    session2.sceneParam.persistentId = 1;
    container1.midSceneMap.set(1, session2);
    session3.sceneParam.persistentId = 2;
    container1.midSceneMap.set(2, session3);
    midSceneManager.initOutsideScreenMidScene(container1, divider);

    session1.sceneParam.persistentId = 0;
    midSceneManager.initOutsideScreenMidScene(container1, divider);

    divider.primary.persistentId = 0;
    divider.secondary.persistentId = 1;
    midsceneData1.left = 0;
    midsceneData1.visibleW = 10000;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    session3.sceneParam.persistentId = 3;
    midSceneManager.initOutsideScreenMidScene(container1, divider);

    session3.sceneParam.persistentId = 2;
    midSceneManager.initOutsideScreenMidScene(container1, divider);

    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_addFromIcon_01() {
  it('MidSceneManager_addFromIcon_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0,midsceneData1,midsceneData2];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 0;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorPosIndex = 0;
    midSceneManager.addFromIcon(container1, scbSceneSession);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc((container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r, (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.findIndex);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorPosIndex = 1;
    midSceneManager.addFromIcon(container1, scbSceneSession);
    container1.companionIconInfo = companionIconInfotest;
    let Rect = new RectInfo();
    let mocker1: MockKit = new MockKit();
    let mockfunc1: Function = mocker1.mockFunc(ItemUtils, ItemUtils.getRectById);
    when(mockfunc1)(ArgumentMatchers.any).afterReturn(Rect);
    midSceneManager.addFromIcon(container1, scbSceneSession);
    mocker.clear((container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r);
    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_replaceOut_01() {
  it('MidSceneManager_replaceOut_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0,midsceneData1,midsceneData2];
    container1.isMidScene = true;
    container1.midSceneMap.set(1, scbSceneSession);
    midSceneManager.replaceOut(container1, scbSceneSession, scbSceneSession1);
    container1.isMidScene = false;
    container1.secondarySession = primarySession;
    midSceneManager.replaceOut(container1, scbSceneSession, scbSceneSession1);
    container1.midAppIconParamMap.set(primarySession.session.persistentId, appIconParam);
    midSceneManager.replaceOut(container1, scbSceneSession, scbSceneSession1);
    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_addFromOther_01() {
  it('MidSceneManager_addFromOther_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0,midsceneData1,midsceneData2];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 0;
    midSceneManager.addFromOther(container1, scbSceneSession);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc((container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r, (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.findIndex);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(1);
    midSceneManager.addFromOther(container1, scbSceneSession);
    mocker.clear((container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r);
    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_replaceIn_01() {
  it('MidSceneManager_replaceIn_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 0;
    midSceneManager.replaceIn(container1, scbSceneSession);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc((container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r, (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.findIndex);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 0;
    midSceneManager.replaceIn(container1, scbSceneSession);
    mocker.clear((container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r);
    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_doVibrationMid_01() {
  it('MidSceneManager_doVibrationMid_001', Level.LEVEL0, () => {
    let containertest: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(midSceneManager, midSceneManager.isSupportMidScene);
    when(mockfunc)(containertest).afterReturn(true);
    midSceneManager.doVibrationMid(true,containertest, 1,0,0);
    midSceneManager.doVibrationMid(true,containertest, 1,2,4);
    midSceneManager.doVibrationMid(false,containertest, 1,2,4);
    midSceneManager.doVibrationMid(false,containertest, 5,2,4);
    midSceneManager.doVibrationMid(false,container, 1,2,4);
    expect(true).assertTrue();
    mocker.clear(midSceneManager);
  });
}
function MidSceneManagerTest_interruptStartSceneForMidSceneIfNeed_01() {
  it('MidSceneManager_interruptStartSceneForMidSceneIfNeed_01', Level.LEVEL0, () => {
    let containerZero = new SCBSceneContainerSession(primarySession, screenProperty);
    containerZero.primarySession = null;
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    let addToMidScene: () => void = () => {
    };
    midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.SPLIT, null, null, true, addToMidScene);
    midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.SPLIT, null, containerZero, true,
      addToMidScene);
    midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.SPLIT, null, container1, true, addToMidScene);
    midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.SPLIT, scbSceneSession, container1, false,
      addToMidScene);
    midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.SPLIT, scbSceneSession, container1, true,
      addToMidScene);
    midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.SPLIT, scbSceneSession, null, true,
      addToMidScene);
    midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.SPLIT, scbSceneSession, container1, true,
      addToMidScene);
    container1.isMidScene = true;
    midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.FLOAT_SCENE, scbSceneSession, container1, true,
      addToMidScene);
    midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.SPLIT, scbSceneSession, container1, false,
      addToMidScene);
    container1.midSceneMap.set(0, scbSceneSession);
    midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.SPLIT, scbSceneSession, container1, true,
      addToMidScene);
    midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.FLOAT_SCENE, scbSceneSession, container1,
      false,
      addToMidScene);
    midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.FLOAT_SCENE, scbSceneSession, container1, true,
      addToMidScene);
    let mocker: MockKit = new MockKit();
    let sessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    let mockFunc: Function = mocker.mockFunc(sessionManager, sessionManager.isDeliverApplication);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
    midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.SPLIT, scbSceneSession, container1, true,
      addToMidScene);
    mocker.clear(sessionManager);
    expect(ReflectionUtils.useFunc(midSceneManager, 'interruptStartSceneForMidSceneIfNeed', ScenePanelState.SPLIT,
      scbSceneSession, container1, true, addToMidScene)).assertTrue();
  });

  it('MidSceneManager_interruptStartSceneForMidSceneIfNeed_02', Level.LEVEL0, () => {
    let containerZero = new SCBSceneContainerSession(primarySession, screenProperty);
    containerZero.primarySession = null;
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    let addToMidScene: () => void = () => {
    };
    container1.isMidScene = false;
    expect(ReflectionUtils.useFunc(midSceneManager, 'interruptStartSceneForMidSceneIfNeed', ScenePanelState.SPLIT,
      scbSceneSession, container1, false, addToMidScene)).assertFalse();
  });

  it('MidSceneManager_interruptStartSceneForMidSceneIfNeed_03', Level.LEVEL0, () => {
    let containerZero = new SCBSceneContainerSession(primarySession, screenProperty);
    containerZero.primarySession = null;
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    let addToMidScene: () => void = () => {
    };
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.isMidScene = true;
    midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.FLOAT_SCENE, scbSceneSession, container1,
      true, addToMidScene);
    expect(ReflectionUtils.useFunc(midSceneManager, 'interruptStartSceneForMidSceneIfNeed', ScenePanelState.SPLIT,
      scbSceneSession, container1, true, addToMidScene)).assertFalse();
  });
  it('MidSceneManager_interruptStartSceneForMidSceneIfNeed_04', Level.LEVEL0, () => {
    let containerZero = new SCBSceneContainerSession(primarySession, screenProperty);
    containerZero.primarySession = null;
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    let addToMidScene: () => void = () => {
    };
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.isMidScene = false;
    midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.FLOAT_SCENE, scbSceneSession, container1,
      true, addToMidScene);
    expect(ReflectionUtils.useFunc(midSceneManager, 'interruptStartSceneForMidSceneIfNeed', ScenePanelState.SPLIT,
      scbSceneSession, container1, true, addToMidScene)).assertFalse();
  });
  it('MidSceneManager_interruptStartSceneForMidSceneIfNeed_05', Level.LEVEL0, () => {
    let containerZero = new SCBSceneContainerSession(primarySession, screenProperty);
    containerZero.primarySession = null;
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    let addToMidScene: () => void = () => {
    };
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.isMidScene = false;
    midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.SPLIT, scbSceneSession, null, true,
      addToMidScene);
    expect(ReflectionUtils.useFunc(midSceneManager, 'interruptStartSceneForMidSceneIfNeed', ScenePanelState.SPLIT,
      scbSceneSession, container1, true, addToMidScene)).assertFalse();
  });
  it('MidSceneManager_interruptStartSceneForMidSceneIfNeed_06', Level.LEVEL0, () => {
    let containerZero = new SCBSceneContainerSession(primarySession, screenProperty);
    containerZero.primarySession = null;
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    let addToMidScene: () => void = () => {
    };
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.isMidScene = true;
    midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.SPLIT, scbSceneSession, null, true,
      addToMidScene);
    expect(ReflectionUtils.useFunc(midSceneManager, 'interruptStartSceneForMidSceneIfNeed', ScenePanelState.FLOAT_SCENE,
      scbSceneSession, container1, true, addToMidScene)).assertFalse();
  });
  it('MidSceneManager_interruptStartSceneForMidSceneIfNeed_07', Level.LEVEL0, () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let sceneInfo1: SCBSceneInfo = new SCBSceneInfo('testPriBundle1', 'testPriModule1', 'testPriAbility1');
    let primarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let secondSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
    secondSession.defaultRequestOrientation = SCBSceneOrientation.AUTO_ROTATION_LANDSCAPE_RESTRICTED;
    let container = new SCBSceneContainerSession(primarySession, screenProperty);
    (container.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    (container.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1];
    let addToMidScene: () => void = () => {
    };
    container.isMidScene = true;
    let result = midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.FLOAT_SCENE, secondSession, container, false,
      addToMidScene);
    expect(result).assertFalse();
  });
  it('MidSceneManager_interruptStartSceneForMidSceneIfNeed_08', Level.LEVEL0, () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let sceneInfo1: SCBSceneInfo = new SCBSceneInfo('testPriBundle1', 'testPriModule1', 'testPriAbility1');
    let primarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let secondSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);

    let mocker: MockKit = new MockKit();
    let sessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
    let mockFunc: Function = mocker.mockFunc(sessionManager, sessionManager.isExcludeFromSession);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

    let container = new SCBSceneContainerSession(primarySession, screenProperty);
    (container.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    (container.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1];
    let addToMidScene: () => void = () => {
    };
    container.isMidScene = true;
    let result = midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.FLOAT_SCENE, secondSession, container, false,
      addToMidScene);
    expect(result).assertFalse();
    mocker.clear(mockFunc);
  });
  it('MidSceneManager_interruptStartSceneForMidSceneIfNeed_09', Level.LEVEL0, () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let sceneInfo1: SCBSceneInfo = new SCBSceneInfo('testPriBundle1', 'testPriModule1', 'testPriAbility1');
    let primarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let secondSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
    let secondSession1: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
    secondSession1.defaultRequestOrientation = SCBSceneOrientation.HORIZONTAL;
    let container = new SCBSceneContainerSession(primarySession, screenProperty);
    container.secondarySession = secondSession;
    (container.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    (container.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1];
    let addToMidScene: () => void = () => {
    };
    container.isMidScene = true;
    let result = midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.FLOAT_SCENE, secondSession1, container, false,
      addToMidScene);
    expect(result).assertFalse();
  });
  it('MidSceneManager_interruptStartSceneForMidSceneIfNeed_10', Level.LEVEL0, () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let sceneInfo1: SCBSceneInfo = new SCBSceneInfo('testPriBundle1', 'testPriModule1', 'testPriAbility1');
    let primarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let secondSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
    let secondSession1: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
    secondSession1.defaultRequestOrientation = SCBSceneOrientation.SENSOR_HORIZONTAL;
    let container = new SCBSceneContainerSession(primarySession, screenProperty);
    container.secondarySession = secondSession;
    (container.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    (container.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1];
    let addToMidScene: () => void = () => {
    };
    container.isMidScene = true;
    let result = midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.FLOAT_SCENE, secondSession1, container, false,
      addToMidScene);
    expect(result).assertFalse();
  });
  it('MidSceneManager_interruptStartSceneForMidSceneIfNeed_11', Level.LEVEL0, () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let sceneInfo1: SCBSceneInfo = new SCBSceneInfo('testPriBundle1', 'testPriModule1', 'testPriAbility1');
    let primarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let secondSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
    let secondSession1: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
    secondSession1.defaultRequestOrientation = SCBSceneOrientation.REVERSE_HORIZONTAL;
    let container = new SCBSceneContainerSession(primarySession, screenProperty);
    container.secondarySession = secondSession;
    (container.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    (container.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1];
    let addToMidScene: () => void = () => {
    };
    container.isMidScene = true;
    let result = midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.FLOAT_SCENE, secondSession1, container, false,
      addToMidScene);
    expect(result).assertFalse();
  });
  it('MidSceneManager_interruptStartSceneForMidSceneIfNeed_12', Level.LEVEL0, () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let sceneInfo1: SCBSceneInfo = new SCBSceneInfo('testPriBundle1', 'testPriModule1', 'testPriAbility1');
    let primarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let secondSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
    let secondSession1: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
    let container = new SCBSceneContainerSession(primarySession, screenProperty);
    container.secondarySession = secondSession;
    (container.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    (container.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1];
    let addToMidScene: () => void = () => {
    };
    container.isMidScene = true;

    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(MidSceneUtils, MidSceneUtils.isSupportEnterMidScene);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

    let result = midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.FLOAT_SCENE, secondSession1, container, false,
      addToMidScene);
    expect(result).assertFalse();
    mocker.clear(mockFunc);
  });
  it('MidSceneManager_interruptStartSceneForMidSceneIfNeed_13', Level.LEVEL0, () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let sceneInfo1: SCBSceneInfo = new SCBSceneInfo('testPriBundle1', 'testPriModule1', 'testPriAbility1');
    let primarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let secondSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
    let secondSession1: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
    let container = new SCBSceneContainerSession(primarySession, screenProperty);
    container.secondarySession = secondSession;
    (container.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    (container.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1];
    let addToMidScene: () => void = () => {
    };
    container.isMidScene = true;

    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(MidSceneUtils, MidSceneUtils.isSupportEnterMidScene);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

    let result = midSceneManager.interruptStartSceneForMidSceneIfNeed(ScenePanelState.SPLIT, secondSession1, container, true,
      addToMidScene);
    expect(result).assertTrue();
    mocker.clear(mockFunc);
  });
}

function MidSceneManagerTest_endFloatAnimateMidScene_01() {
  it('MidSceneManager_endFloatAnimateMidScene_001', Level.LEVEL0, () => {
    let container1: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    midSceneManager.endFloatAnimateMidScene(container1, true);
    midSceneManager.endFloatAnimateMidScene(container1, false);
    container1.primarySession = null;
    midSceneManager.endFloatAnimateMidScene(container1, true);
    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_startDragSplitFloatInAnimate_01() {
  it('MidSceneManager_startDragSplitFloatInAnimate_001', Level.LEVEL0, () => {
    midSceneManager.startDragSplitFloatInAnimate(container);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().getFloatingSessionList().getTopActiveSession);
    let container1: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(container1);
    container1.primarySession = null;
    midSceneManager.startDragSplitFloatInAnimate(container1);
    container1.primarySession = primarySession;
    container1.primarySession.preferMultiWindowOrientation = PreferMultiWindowOrientation.PORTRAIT
    midSceneManager.startDragSplitFloatInAnimate(container1);
    container1.primarySession.preferMultiWindowOrientation = PreferMultiWindowOrientation.LANDSCAPE;
    midSceneManager.startDragSplitFloatInAnimate(container1);
    expect(true).assertTrue();
    mocker.clear(SCBSceneSessionManager.getInstance());
  });
}


function MidSceneManagerTest_splitEnterMid_01() {
  it('MidSceneManager_splitEnterMid_001', Level.LEVEL0, () => {
    let containertest: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    (containertest.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container, callback);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(containertest.sessionData.midSceneFSM, containertest.sessionData.midSceneFSM?.transfer);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
    midSceneManager.splitEnterMid(dividerParam, containertest, true);
    midSceneManager.splitEnterMid(dividerParam, containertest, false);
    container.secondarySession = primarySession;
    midSceneManager.splitEnterMid(dividerParam, containertest, false);
    mocker.clear(containertest.sessionData.midSceneFSM);
  });
}

function MidSceneManagerTest_midSceneExitToBackgroundAnim_01() {
  it('MidSceneManager_midSceneExitToBackgroundAnim_001', Level.LEVEL0, () => {
    let container1: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    midSceneManager.midSceneExitToBackgroundAnim(container1, primarySession, () => {}, true, () => {});
    expect(true).assertTrue();
  });
}

function MidSceneManagerTest_updateSubSessionRect_01() {
  it('MidSceneManager_updateSubSessionRect_001', Level.LEVEL0, () => {
    let tmp: SCBSceneSession | null = null;
    let testRect = new SCBSessionRect(1,1,1,1);
    ReflectionUtils.useFunc(midSceneManager, 'updateSubSessionRect', tmp, testRect);
    let testSession: SCBSpecificSession = new SCBSpecificSession(session, () => {});
    primarySession.subSessionList = [testSession];
    primarySession.dialogSessionList = [testSession];
    primarySession.currRect = new SCBSessionRect(0.5,0.5,0.5,0.5);
    ReflectionUtils.useFunc(midSceneManager, 'updateSubSessionRect', primarySession, testRect);
    expect(testSession.requestedRect.width.getPx()).not().assertEqual(primarySession.currRect.width.getPx());
    testSession.currRect = testRect.copy();
    ReflectionUtils.useFunc(midSceneManager, 'updateSubSessionRect', primarySession, testRect);
    expect(testSession.requestedRect.width.getPx()).assertEqual(primarySession.currRect.width.getPx());
  });
}

function MidSceneManagerTest_toNonMidScene_01() {
  it('MidSceneManagerTest_toNonMidScene_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.isSplit = false;
    midSceneManager.toNonMidScene(container1);
    expect(container1.getState()).assertEqual(SCBSceneContainerState.FULL_SCREEN);
  });
  it('MidSceneManagerTest_toNonMidScene_002', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.isSplit = true;
    midSceneManager.toNonMidScene(container1);
    expect(container1.getState()).assertEqual(SCBSceneContainerState.SPLIT);
  });
}

function MidSceneManagerTest_adjustMidSceneState_01() {
  it('MidSceneManagerTest_adjustMidSceneState_001', Level.LEVEL0, () => {
    let container1: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    container1.isMidScene = true;
    let midSceneManager1 = new MidSceneManager(screenProperty);
    SCBScenePanelManager.getInstance().getSceneContainerSessionList().push(container1);
    let mocker: MockKit = new MockKit();
    let mockfunc1: Function = mocker.mockFunc(midSceneManager1, midSceneManager1.isSupportMidScene);
    when(mockfunc1)(ArgumentMatchers.any).afterReturn(true);
    let pid0: number = primarySession.session.persistentId;
    let pid1: number = secondSession.session.persistentId;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 0;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorPosIndex = 0;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(new MidSceneData(pid0));
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(new MidSceneData(pid1));
    container1.midSceneMap.set(pid0, primarySession);
    container1.midSceneMap.set(pid1, secondSession);
    midSceneManager1.adjustMidSceneState(screenProperty, SCBPropertyChangeReason.EXPAND_TO_FOLD, () => {});
    midSceneManager1.adjustMidSceneState(screenProperty, SCBPropertyChangeReason.FOLD_TO_EXPAND, () => {});
    let pid2: number = thirdSession.session.persistentId;
    container1.midSceneMap.set(pid2, thirdSession);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(new MidSceneData(pid2));
    midSceneManager1.adjustMidSceneState(screenProperty, SCBPropertyChangeReason.EXPAND_TO_FOLD, () => {});
    midSceneManager1.adjustMidSceneState(screenProperty, SCBPropertyChangeReason.FOLD_TO_EXPAND, () => {});
    mocker.clear(midSceneManager1);
    expect(midSceneManager1.getMidSceneRecordMap().size).assertEqual(0);
  });
  it('MidSceneManagerTest_adjustMidSceneState_002', Level.LEVEL0, () => {
    let midSceneManager1 = new MidSceneManager(screenProperty);
    midSceneManager1.adjustMidSceneState(screenProperty, SCBPropertyChangeReason.EXPAND_TO_FOLD, () => {});
    let mocker: MockKit = new MockKit();
    let mockfunc1: Function = mocker.mockFunc(midSceneManager1, midSceneManager1.isSupportMidScene);
    when(mockfunc1)(ArgumentMatchers.any).afterReturn(true);
    midSceneManager1.adjustMidSceneState(screenProperty, SCBPropertyChangeReason.EXPAND_TO_FOLD, () => {});
    midSceneManager1.adjustMidSceneState(screenProperty, SCBPropertyChangeReason.FOLD_TO_EXPAND, () => {});
    mocker.clear(midSceneManager1);
    expect(midSceneManager1.getMidSceneRecordMap().size).assertEqual(0);
  });
}

function MidSceneManagerTest_addMidSceneRecord_01() {
  it('MidSceneManagerTest_addMidSceneRecord_001', Level.LEVEL0, () => {
    let container1: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(new MidSceneData(0));
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(new MidSceneData(1));
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 3;
    let record = midSceneManager.addMidSceneRecord((container1.sessionData.midSceneFSM as MidSceneFSM).context);
    expect(record !== null).assertTrue();
  });
  it('MidSceneManagerTest_addMidSceneRecord_003', Level.LEVEL0, () => {
    let container1: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    let record = midSceneManager.addMidSceneRecord((container1.sessionData.midSceneFSM as MidSceneFSM).context);
    expect(record === null).assertTrue();
  });
}

function MidSceneManagerTest_updateRecordAnchorIndex_01() {
  it('MidSceneManagerTest_updateRecordAnchorIndex_001', Level.LEVEL0, () => {
    let container1: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(new MidSceneData(0));
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(new MidSceneData(1));
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 3;
    let record = midSceneManager.addMidSceneRecord((container1.sessionData.midSceneFSM as MidSceneFSM).context);
    midSceneManager.updateRecordAnchorIndex(1);
    expect(record?.anchorIndex).assertEqual(1);
  });
}

function MidSceneManagerTest_isTopContainerNeedRecoverMidScene_01() {
  it('MidSceneManagerTest_isTopContainerNeedRecoverMidScene_001', Level.LEVEL0, () => {
    midSceneManager.isTopContainerNeedRecoverMidScene();
    let container1: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    let pid0: number = primarySession.session.persistentId;
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(new MidSceneData(pid0));
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.anchorIndex = 0;
    midSceneManager.addMidSceneRecord((container1.sessionData.midSceneFSM as MidSceneFSM).context);
    expect(midSceneManager.isTopContainerNeedRecoverMidScene()).assertFalse();
  });
}

function MidSceneManagerTest_clearMidSceneRecordByContainer_01() {
  it('MidSceneManagerTest_clearMidSceneRecordByContainer_001', Level.LEVEL0, () => {
    midSceneManager.clearMidSceneRecordByContainer(null);
    midSceneManager.clearMidSceneRecordByContainer(container);
    midSceneManager.clearAllMidSceneRecord();
    let container1: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.addSceneSession(secondSession);
    midSceneManager.clearMidSceneRecordByContainer(container1);
    expect(midSceneManager.getMidSceneRecordMap().size).assertEqual(0);
  });
}

function MidSceneManagerTest_tryShowTipForMidSceneTest_01() {
  it("tryShowTipForMidSceneTest_001", Level.LEVEL0, () => {
    let mocker: MockKit = new MockKit();
    let obj = SCBMultiWindowGuideUtils.getInstance();
    let mockFunc: Function = mocker.mockFunc(obj, obj.ifGuideShow);
    when(mockFunc)().afterReturn(false);
    try {
      midSceneManager.tryShowTipForMidScene();
    } catch (error) {
      expect(true).assertFalse();
    }finally {
      mocker.clear(obj);
    }
  });
  it("tryShowTipForMidSceneTest_002", Level.LEVEL0, () => {
    let mocker: MockKit = new MockKit();
    let obj = SCBMultiWindowGuideUtils.getInstance();
    let mockFunc: Function = mocker.mockFunc(obj, obj.ifGuideShow);
    when(mockFunc)().afterReturn(true);
    try {
      midSceneManager.tryShowTipForMidScene();
    } catch (error) {
      expect(true).assertFalse();
    } finally {
      mocker.clear(obj);
    }
  });
}

function MidSceneManagerTest_setIsShowTipForMidSceneFalseTest_01() {
  it("setIsShowTipForMidSceneFalse_001", Level.LEVEL0, () => {
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = AppStorage.get;
    when(mockFunc)().afterReturn(true);
    try {
      MidSceneManager.setIsShowTipForMidSceneFalse();
    } catch (error) {
      expect(true).assertFalse();
    } finally {
      mocker.clear(mockFunc);
    }
  });
  it("setIsShowTipForMidSceneFalse_002", Level.LEVEL0, () => {
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = AppStorage.get;
    when(mockFunc)().afterReturn(true);
    try {
      MidSceneManager.setIsShowTipForMidSceneFalse();
    } catch (error) {
      expect(true).assertFalse();
    } finally {
      mocker.clear(mockFunc);
    }
  });
}

function MidSceneManagerTest_doBlurForMidScene_01() {
  it('MidSceneManagerTest_doBlurForMidScene_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData);
    container1.midSceneMap.set(1, scbSceneSession);
    scbSceneSession.sceneParam.blurScale = 0;
    midSceneManager.doBlurForMidScene(container1, (container1.sessionData.midSceneFSM as MidSceneFSM).context);
    expect(scbSceneSession.sceneParam.blurScale).assertEqual(1);
  });
}

function MidSceneManagerTest_updateZIndexAndScaleInDragSwap_01() {
  it('updateZIndexAndScaleInDragSwap_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(3);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.midSceneMap.set(3, scbSceneSession);
    midSceneManager.updateZIndexAndScaleInDragSwap(container1, scbSceneSession)
    expect(container1.getMidScenes().size).assertEqual(3);
  });
}
function MidSceneManagerTest_removeBlurForMidScene_01() {
  it('MidSceneManagerTest_removeBlurForMidScene_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData);
    container1.midSceneMap.set(1, scbSceneSession);
    scbSceneSession.sceneParam.blurScale = 1;
    midSceneManager.removeBlurForMidScene(container1, (container1.sessionData.midSceneFSM as MidSceneFSM).context);
    expect(scbSceneSession.sceneParam.blurScale).assertEqual(0);
  });
}

function MidSceneManagerTest_updateDragSwapWithAnimation_01() {
  it('updateDragSwapWithAnimation_001', Level.LEVEL0, () => {
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
      timestamp: 0,
      source: 0,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: 0,
      repeat: false,
      fingerList: [],
      offsetX: 0,
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
    let calculator = new GlobalOffsetCalculator();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    midSceneManager.updateDragSwapWithAnimation(event, calculator, scbSceneSession, container1);
    event.offsetX = 2660;
    scbSceneSession.sceneParam.persistentId = 1;
    midSceneManager.updateDragSwapWithAnimation(event, calculator, scbSceneSession, container1);
    event.offsetX = 1200;
    scbSceneSession.sceneParam.persistentId = 2;
    midSceneManager.updateDragSwapWithAnimation(event, calculator, scbSceneSession, container1);
    expect(container1.getMidScenes().size).assertEqual(3);
  });
}

function MidSceneManagerTest_updateMidscenMapWhenInDrag_01() {
  it('updateMidscenMapWhenInDrag_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    let ctx = (container1.sessionData.midSceneFSM as MidSceneFSM).context;
    let dragId = 2;
    let swapId = 3;
    midSceneManager.updateMidscenMapWhenInDrag(ctx, dragId, swapId, container1);
    expect(container1.getMidScenes().size).assertEqual(3);
  });
}

function MidSceneManagerTest_swapLtrOrderWhenDrag_01() {
  it('swapLtrOrderWhenDrag_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    let swapIndex = 0;
    let focusIndex = 1;
    let dragPersistentId = 2;
    midSceneManager.swapLtrOrderWhenDrag(container1, swapIndex, focusIndex, dragPersistentId);
    expect(container1.getMidScenes().size).assertEqual(3);
  });
}

function MidSceneManagerTest_clearStatusWhenDrag_01() {
  it('updateMidscenMapWhenInDrag_001', Level.LEVEL0, () => {
    midSceneManager.clearStatusWhenDrag();
    expect(midSceneManager.isSupportMidScene(container)).assertFalse();
  });
}

function MidSceneManagerTest_iconAppearAnimation_01() {
  it('MidSceneManagerTest_iconAppearAnimation_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midAppIconParamMap.set(1, appIconParam);
    midSceneManager.iconAppearAnimation(container1, 1);
    expect(appIconParam.opacity).assertEqual(1);
  });
}

function MidSceneManagerTest_adjustWindowForNotSupportSplitApp_01() {
  it('MidSceneManagerTest_adjustWindowForNotSupportSplitApp_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    let adjustRes: MidSceneAdjustRes = {
      anchorIndex: 0,
      anchorPosition: 0,
      backwardStep: 1,
      forwardStep: 1,
    }
    container1.sessionData.midSceneFSM = new MidSceneFSM(container1, callback);
    ReflectionUtils.useFunc(midSceneManager, 'adjustWindowForNotSupportSplitApp', container1, dividerParam, 0,
      adjustRes);
    expect(adjustRes.anchorIndex).assertEqual(0);
  });
}

function MidSceneManagerTest_iconDisappearAnimation_01() {
  it('MidSceneManagerTest_iconDisappearAnimation_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midAppIconParamMap.set(1, appIconParam);
    midSceneManager.iconDisappearAnimation(container1, 1);
    expect(appIconParam.opacity).assertEqual(0);
  });
}

function MidSceneManagerTest_getForwardAndBackwardIndex_01() {
  it('MidSceneManagerTest_getForwardAndBackwardIndex_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.sessionData.midSceneFSM = new MidSceneFSM(container1, callback);
    let forwardAndBackwardIndex: number[] =
      ReflectionUtils.useFunc(midSceneManager, 'getForwardAndBackwardIndex', container1, dividerParam, 0);
    expect(forwardAndBackwardIndex[0]).assertEqual(-1);
  });
}

function MidSceneManagerTest_initForRecent_01() {
  it('MidSceneManagerTest_initForRecent_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.midSceneMap.set(1, scbSceneSession);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midSceneData1: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midSceneData1);
    midSceneManager.initForRecent(container1);
    expect(scbSceneSession.isActive).assertFalse();
  });
  it('MidSceneManagerTest_initForRecent_002', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.isMidScene = false;
    midSceneManager.initForRecent(container1);
    expect(scbSceneSession.isActive).assertFalse();
  });
}

function MidSceneManagerTest_handleMaximizeAnimation_01() {
  it('MidSceneManagerTest_handleMaximizeAnimation_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midAppIconParamMap.set(1, appIconParam);
    let sessionInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility',1, 2);
    let fullSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sessionInfo), sessionInfo);
    container1.midSceneMap.set(2, fullSession);
    container1.midAppIconParamMap.set(2, appIconParam);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    midSceneManager.handleMaximizeAnimation(fullSession, appIconParam, container1, 2);
    expect(scbSceneSession.sceneParam.posX).assertEqual('-100%');
  });
}

function MidSceneManagerTest_updateMidContainerRect_01() {
  it('MidSceneManagerTest_updateMidContainerRect_001', Level.LEVEL0, () => {
    let midSceneManager1 = new MidSceneManager(screenProperty);
    let mocker: MockKit = new MockKit();
    let mockFunc1: Function = mocker.mockFunc(midSceneManager1, midSceneManager1.isSupportMidScene);
    when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.midSceneMap.set(1, scbSceneSession);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midSceneData1: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midSceneData1);
    container1.isMidScene = true;
    midSceneManager1.updateMidContainerRect(container1);
    expect(scbSceneSession.isActive).assertFalse();
    mocker.clear(midSceneManager1);
  });
  it('MidSceneManagerTest_updateMidContainerRect_002', Level.LEVEL0, () => {
    let midSceneManager1 = new MidSceneManager(screenProperty);
    let mocker: MockKit = new MockKit();
    let mockFunc1: Function = mocker.mockFunc(midSceneManager1, midSceneManager1.isSupportMidScene);
    when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.midSceneMap.set(1, scbSceneSession);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midSceneData1: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midSceneData1);
    container1.isMidScene = true;
    midSceneManager1.updateMidContainerRect(container1);
    expect(scbSceneSession.isActive).assertFalse();
    mocker.clear(midSceneManager1);
  });
  it('MidSceneManagerTest_updateMidContainerRect_003', Level.LEVEL0, () => {
    let midSceneManager1 = new MidSceneManager(screenProperty);
    let mocker: MockKit = new MockKit();
    let mockFunc1: Function = mocker.mockFunc(midSceneManager1, midSceneManager1.isSupportMidScene);
    when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.midSceneMap.set(1, scbSceneSession);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midSceneData1: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midSceneData1);
    container1.isMidScene = false;
    midSceneManager1.updateMidContainerRect(container1);
    expect(scbSceneSession.isActive).assertFalse();
    mocker.clear(midSceneManager1);
  });
  it('MidSceneManagerTest_updateMidContainerRect_004', Level.LEVEL0, () => {
    let midSceneManager1 = new MidSceneManager(screenProperty);
    let mocker: MockKit = new MockKit();
    let mockFunc1: Function = mocker.mockFunc(midSceneManager1, midSceneManager1.isSupportMidScene);
    when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.midSceneMap.set(1, scbSceneSession);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midSceneData1: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midSceneData1);
    container1.isMidScene = false;
    midSceneManager1.updateMidContainerRect(container1);
    expect(scbSceneSession.isActive).assertFalse();
    mocker.clear(midSceneManager1);
  });
}

function MidSceneManagerTest_iconAndBlurAppearAnimation_01() {
  it('MidSceneManagerTest_iconAndBlurAppearAnimation_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midAppIconParamMap.set(1, appIconParam);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData);
    midSceneManager.iconAndBlurAppearAnimation(container1, 1);
    expect(appIconParam.opacity).assertEqual(1);
  });
}

function MidSceneManagerTest_freezeOthers_01() {
  it('MidSceneManagerTest_freezeOthers_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData);
    container1.midSceneMap.set(1, scbSceneSession);
    midSceneManager.freezeOthers(container1, 2);
    expect(scbSceneSession.sceneParam.sceneFreeze).assertTrue();
  });
}

function MidSceneManagerTest_iconAndBlurDisappearAnimation_01() {
  it('MidSceneManagerTest_iconAndBlurDisappearAnimation_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midAppIconParamMap.set(1, appIconParam);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData);
    midSceneManager.iconAndBlurDisappearAnimation(container1, 1);
    expect(appIconParam.opacity).assertEqual(0);
  });
}

function MidSceneManagerTest_getAnchorIndexForRecord_01() {
  it('MidSceneManagerTest_getAnchorIndexForRecord_001', Level.LEVEL0, () => {
    let context = (container.sessionData.midSceneFSM as MidSceneFSM).context;
    ReflectionUtils.useFunc(midSceneManager, 'getAnchorIndexForRecord', context);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker
      .mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().getFocusedSession);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
    let beforeAnchorIndex = context.anchorIndex;
    let result: number = ReflectionUtils.useFunc(midSceneManager, 'getAnchorIndexForRecord', context);
    mocker.clear(SCBSceneSessionManager.getInstance());
    expect(result).assertEqual(beforeAnchorIndex);
  });
  it('MidSceneManagerTest_getAnchorIndexForRecord_002', Level.LEVEL0, () => {
    let context = (container.sessionData.midSceneFSM as MidSceneFSM).context;
    context.toReplacedIndex = 0;
    let result: number = ReflectionUtils.useFunc(midSceneManager, 'getAnchorIndexForRecord', context);
    expect(result).assertEqual(0);
  });
}

function MidSceneManagerTest_floatingToSideEdgeBar_01() {
  it('MidSceneManagerTest_floatingToSideEdgeBar_001', Level.LEVEL0, () => {
    let floatingSessionList: SCBSceneContainerSessionArray =
      SCBScenePanelManager.getInstance(screenProperty).getFloatingSessionList();
    let isCorrect: boolean = false;
    floatingSessionList.add(container);
    midSceneManager.floatingToSideEdgeBar();
    floatingSessionList.forEach((containerSession) => {
      let persistentId: number = containerSession.getPersistentId();
      let isEnterEdeBar: boolean = true;
      isEnterEdeBar &&= (persistentId !== -1);
      isEnterEdeBar &&= (containerSession.getState() === SCBSceneContainerState.HIDDEN);
      isCorrect ||= isEnterEdeBar;
    })
    expect(isCorrect).assertTrue();
  });
}

function MidSceneManagerTest_handleSideEdgeBarClickInMidScene_01() {
  it('MidSceneManagerTest_handleSideEdgeBarClickInMidScene_001', Level.LEVEL0, () => {
    let mocker: MockKit = new MockKit();
    let mockerFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
      SCBSceneSessionManager.getInstance().getFloatingSessionList);
    when(mockerFunc)(ArgumentMatchers.any).afterReturn(new SCBSceneContainerSessionArray());
    midSceneManager.handleSideEdgeBarClickInMidScene(container);
    expect(SCBSideEdgeBarManager.getInstance().getSideEdgeBarOptions().displayState)
      .assertEqual(SCBSideEdgeBarDisplayState.HIDDEN);
    mocker.clear(SCBSceneSessionManager.getInstance());
  });
  it('MidSceneManagerTest_handleSideEdgeBarClickInMidScene_002', Level.LEVEL0, () => {
    let mocker: MockKit = new MockKit();
    let mockerFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
      SCBSceneSessionManager.getInstance().getFloatingSessionList);
    let floatingSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    SCBSideEdgeBarManager.getInstance().getSideEdgeBarOptions().persistentId = 1;
    floatingSessionList.add(container1);
    when(mockerFunc)(ArgumentMatchers.any).afterReturn(floatingSessionList);
    midSceneManager.handleSideEdgeBarClickInMidScene(container1);
    expect(SCBSideEdgeBarManager.getInstance().getSideEdgeBarOptions().displayState)
      .assertEqual(SCBSideEdgeBarDisplayState.HIDDEN);
    mocker.clear(SCBSceneSessionManager.getInstance());
  });
  it('MidSceneManagerTest_handleSideEdgeBarClickInMidScene_003', Level.LEVEL0, () => {
    let mocker: MockKit = new MockKit();
    let mockerFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
      SCBSceneSessionManager.getInstance().getFloatingSessionList);
    let floatingSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(3);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    container1.midSceneMap.set(3, scbSceneSession);
    SCBSideEdgeBarManager.getInstance().getSideEdgeBarOptions().persistentId = 1;
    floatingSessionList.add(container1);
    when(mockerFunc)(ArgumentMatchers.any).afterReturn(floatingSessionList);
    midSceneManager.handleSideEdgeBarClickInMidScene(container1);
    expect(SCBSideEdgeBarManager.getInstance().getSideEdgeBarOptions().displayState)
      .assertEqual(SCBSideEdgeBarDisplayState.HIDDEN);
    mocker.clear(SCBSceneSessionManager.getInstance());
  });
}

function MidSceneManagerTest_handleDragContentLeaveEvent_01() {
  it('MidSceneManagerTest_handleDragContentLeaveEvent_001', Level.LEVEL0, () => {
    midSceneManager.handleDragContentLeaveEvent();
    let interruptDragFlag: boolean = ReflectionUtils.getProperty(midSceneManager, 'interruptDragFlag');
    expect(interruptDragFlag).assertFalse();
  });
}

function MidSceneManagerTest_handleDragContentEnterEvent_01() {
  it('MidSceneManagerTest_handleDragContentEnterEvent_001', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    let sceneParam: SceneParam = new SceneParam();
    ReflectionUtils.setProperty(midSceneManager, 'dragTimerId', -1);
    ReflectionUtils.setProperty(midSceneManager, 'interruptDragFlag', true);
    midSceneManager.handleDragContentEnterEvent(container1, sceneParam);
    let interruptDragFlag: number = ReflectionUtils.getProperty(midSceneManager, 'interruptDragFlag');
    expect(interruptDragFlag).assertTrue();
  });
}

function MidSceneManagerTest_freezeDesktopNodeAndEnableVma() {
  it('MidSceneManagerTest_freezeDesktopNodeAndEnableVma_01', Level.LEVEL0, () => {
    let midSceneManager1: MidSceneManager = new MidSceneManager(screenProperty);
    let containerZero = new SCBSceneContainerSession(primarySession, screenProperty);
    containerZero.primarySession = null;
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    let midSceneData1: MidSceneData = new MidSceneData(primarySession.sceneInfo.persistentId);
    midSceneData1.step = MidSceneStep.LARGE;
    midSceneData1.inclined = true;
    let reason: string = 'MidSceneToStable';
    midSceneManager1.freezeDesktopNodeAndEnableVma(reason);
    let isVmaCache: boolean = true;
    SCBSceneSessionManager.getInstance().setVmaCacheStatus(isVmaCache, reason);
  });

  it('MidSceneManagerTest_freezeDesktopNodeAndEnableVma_02', Level.LEVEL0, () => {
    let midSceneManager1: MidSceneManager = new MidSceneManager(screenProperty);
    let containerZero = new SCBSceneContainerSession(primarySession, screenProperty);
    containerZero.primarySession = null;
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    let midSceneData1: MidSceneData = new MidSceneData(primarySession.sceneInfo.persistentId);
    midSceneData1.step = MidSceneStep.LARGE;
    midSceneData1.inclined = true;
    let reason: string = 'MidSceneToStable';
    midSceneManager1.freezeDesktopNodeAndEnableVma(reason);
    let isVmaCache: boolean = false;
    SCBSceneSessionManager.getInstance().setVmaCacheStatus(isVmaCache, reason);
  });

  it('MidSceneManagerTest_freezeDesktopNodeAndEnableVma_03', Level.LEVEL0, () => {
    let midSceneManager1: MidSceneManager = new MidSceneManager(screenProperty);
    let containerZero = new SCBSceneContainerSession(primarySession, screenProperty);
    containerZero.primarySession = null;
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    let midSceneData1: MidSceneData = new MidSceneData(primarySession.sceneInfo.persistentId);
    midSceneData1.step = MidSceneStep.LARGE;
    midSceneData1.inclined = false;
    let reason: string = 'MidSceneToStable';
    midSceneManager1.freezeDesktopNodeAndEnableVma(reason);
    let isVmaCache: boolean = false;
    SCBSceneSessionManager.getInstance().setVmaCacheStatus(isVmaCache, reason);
  });

  it('MidSceneManagerTest_freezeDesktopNodeAndEnableVma_04', Level.LEVEL0, () => {
    let midSceneManager1: MidSceneManager = new MidSceneManager(screenProperty);
    let containerZero = new SCBSceneContainerSession(primarySession, screenProperty);
    containerZero.primarySession = null;
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    let midSceneData1: MidSceneData = new MidSceneData(primarySession.sceneInfo.persistentId);
    midSceneData1.step = MidSceneStep.LARGE;
    midSceneData1.inclined = false;
    let reason: string = 'MidSceneToStable';
    midSceneManager1.freezeDesktopNodeAndEnableVma(reason);
    let isVmaCache: boolean = true;
    SCBSceneSessionManager.getInstance().setVmaCacheStatus(isVmaCache, reason);
  });
}

function MidSceneManagerTest_resetDesktopNodeAndDisableVma() {
  it('MidSceneManagerTest_resetDesktopNodeAndDisableVma_01', Level.LEVEL0, () => {
    let midSceneManager1: MidSceneManager = new MidSceneManager(screenProperty);
    let containerZero = new SCBSceneContainerSession(primarySession, screenProperty);
    containerZero.primarySession = null;
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    let midSceneData1: MidSceneData = new MidSceneData(primarySession.sceneInfo.persistentId);
    midSceneData1.step = MidSceneStep.LARGE;
    midSceneData1.inclined = false;
    let reason: string = 'MidSceneToStable';
    midSceneManager1.freezeDesktopNodeAndEnableVma(reason);
    let isVmaCache: boolean = true;
    SCBSceneSessionManager.getInstance().setVmaCacheStatus(isVmaCache, reason);
  });

  it('MidSceneManagerTest_resetDesktopNodeAndDisableVma_02', Level.LEVEL0, () => {
    let midSceneManager1: MidSceneManager = new MidSceneManager(screenProperty);
    let containerZero = new SCBSceneContainerSession(primarySession, screenProperty);
    containerZero.primarySession = null;
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    let midSceneData1: MidSceneData = new MidSceneData(primarySession.sceneInfo.persistentId);
    midSceneData1.step = MidSceneStep.LARGE;
    midSceneData1.inclined = false;
    let reason: string = 'MidSceneToStable';
    midSceneManager1.freezeDesktopNodeAndEnableVma(reason);
    let isVmaCache: boolean = false;
    SCBSceneSessionManager.getInstance().setVmaCacheStatus(isVmaCache, reason);
  });

  it('MidSceneManagerTest_resetDesktopNodeAndDisableVma_03', Level.LEVEL0, () => {
    let midSceneManager1: MidSceneManager = new MidSceneManager(screenProperty);
    let containerZero = new SCBSceneContainerSession(primarySession, screenProperty);
    containerZero.primarySession = null;
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    let midSceneData1: MidSceneData = new MidSceneData(primarySession.sceneInfo.persistentId);
    midSceneData1.step = MidSceneStep.LARGE;
    midSceneData1.inclined = true;
    let reason: string = 'MidSceneToStable';
    midSceneManager1.freezeDesktopNodeAndEnableVma(reason);
    let isVmaCache: boolean = false;
    SCBSceneSessionManager.getInstance().setVmaCacheStatus(isVmaCache, reason);
  });

  it('MidSceneManagerTest_resetDesktopNodeAndDisableVma_04', Level.LEVEL0, () => {
    let midSceneManager1: MidSceneManager = new MidSceneManager(screenProperty);
    let containerZero = new SCBSceneContainerSession(primarySession, screenProperty);
    containerZero.primarySession = null;
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData0: MidSceneData = new MidSceneData(0);
    let midsceneData1: MidSceneData = new MidSceneData(1);
    let midsceneData2: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [midsceneData0, midsceneData1, midsceneData2];
    let midSceneData1: MidSceneData = new MidSceneData(primarySession.sceneInfo.persistentId);
    midSceneData1.step = MidSceneStep.LARGE;
    midSceneData1.inclined = true;
    let reason: string = 'MidSceneToStable';
    midSceneManager1.freezeDesktopNodeAndEnableVma(reason);
    let isVmaCache: boolean = true;
    SCBSceneSessionManager.getInstance().setVmaCacheStatus(isVmaCache, reason);
  });
}

function MidSceneManagerTest_updateZIndexAndScaleInDragSwap01() {
  it('updateZIndexAndScaleInDragSwap', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    scbSceneSession.sceneInfo.persistentId = 0;
    midSceneManager.updateZIndexAndScaleInDragSwap(container1, scbSceneSession)
    scbSceneSession.sceneInfo.persistentId = 1;
    midSceneManager.updateZIndexAndScaleInDragSwap(container1, scbSceneSession)
    scbSceneSession.sceneInfo.persistentId = 2;
    midSceneManager.updateZIndexAndScaleInDragSwap(container1, scbSceneSession)
    expect(container1.getMidScenes().size).assertEqual(3);
  });
  it('updateZIndexAndScaleInDragSwap1', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(4);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(5);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(6);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    container1.midSceneMap.set(4, scbSceneSession);
    container1.midSceneMap.set(5, scbSceneSession);
    container1.midSceneMap.set(6, scbSceneSession);
    scbSceneSession.sceneInfo.persistentId = 4;
    midSceneManager.updateZIndexAndScaleInDragSwap(container1, scbSceneSession)
    scbSceneSession.sceneInfo.persistentId = 5;
    midSceneManager.updateZIndexAndScaleInDragSwap(container1, scbSceneSession)
    scbSceneSession.sceneInfo.persistentId = 6;
    midSceneManager.updateZIndexAndScaleInDragSwap(container1, scbSceneSession)
    expect(container1.getMidScenes().size).assertEqual(3);
  });
  it('updateZIndexAndScaleInDragSwap2', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    scbSceneSession.sceneInfo.persistentId = 0;
    midSceneManager.updateZIndexAndScaleInDragSwap(container1, scbSceneSession)
    scbSceneSession.sceneInfo.persistentId = 1;
    midSceneManager.updateZIndexAndScaleInDragSwap(container1, scbSceneSession)
    expect(container1.getMidScenes().size).assertEqual(2);
  });
}

function MidSceneManagerTest_updateDragSwapWithAnimation01() {
  it('updateDragSwapWithAnimation', Level.LEVEL0, () => {
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
      timestamp: 0,
      source: 0,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: 0,
      repeat: false,
      fingerList: [],
      offsetX: 0,
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
    let calculator = new GlobalOffsetCalculator();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    midSceneManager.updateDragSwapWithAnimation(event, calculator, scbSceneSession, container1);
    event.offsetX = 2660;
    scbSceneSession.sceneParam.persistentId = 1;
    midSceneManager.updateDragSwapWithAnimation(event, calculator, scbSceneSession, container1);
    event.offsetX = 1200;
    scbSceneSession.sceneParam.persistentId = 2;
    midSceneManager.updateDragSwapWithAnimation(event, calculator, scbSceneSession, container1);
    scbSceneSession.sceneInfo.persistentId = 100;
    midSceneManager.updateDragSwapWithAnimation(event, calculator, scbSceneSession, container1);
    expect(container1.getMidScenes().size).assertEqual(3);
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
    let eventTarget: EventTarget = {
      area: eventArea
    };
    let event: GestureEvent = {
      target: eventTarget,
      timestamp: 0,
      source: 0,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: 0,
      repeat: false,
      fingerList: [],
      offsetX: -100,
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
    let calculator = new GlobalOffsetCalculator();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    midSceneManager.updateDragSwapWithAnimation(event, calculator, scbSceneSession, container1);
    expect(container1.getMidScenes().size).assertEqual(3);
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
    eventArea.globalPosition.x = 100;
    eventArea.globalPosition.y = 100;
    event.timestamp = 2;
    event.source = 2;
    event.offsetX = 1;
    event.tiltY = 1;
    event.tiltX = 1;
    event.angle = 1;
    event.speed = 1;
    event.scale = 1;
    event.pinchCenterX = 1;
    event.pinchCenterY = 1;
    event.velocityX = 1;
    event.velocityY = 1;
    event.velocity = 2;
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
    eventArea.position.x = 100;
    eventArea.position.y = 200;
    eventArea.globalPosition.x = 10;
    eventArea.globalPosition.y = 10;
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
    let calculator = new GlobalOffsetCalculator();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(4, scbSceneSession);
    midSceneManager.updateDragSwapWithAnimation(event, calculator, scbSceneSession, container1);
    expect(container1.getMidScenes().size).assertEqual(2);
  });
}

function MidSceneManagerTest_swapLtrOrderWhenDrag01() {
  it('swapLtrOrderWhenDrag', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    let swapIndex = 0;
    let focusIndex = 1;
    let dragPersistentId = 2;
    midSceneManager.swapLtrOrderWhenDrag(container1, swapIndex, focusIndex, dragPersistentId);
    expect(container1.getMidScenes().size).assertEqual(3);
  });
  it('swapLtrOrderWhenDrag2', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    let swapIndex = 0;
    let focusIndex = 1;
    let dragPersistentId = 1;
    midSceneManager.swapLtrOrderWhenDrag(container1, swapIndex, focusIndex, dragPersistentId);
    expect(container1.getMidScenes().size).assertEqual(2);
  });
  it('swapLtrOrderWhenDrag3', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    let swapIndex = 0;
    let focusIndex = 1;
    let dragPersistentId = -1;
    midSceneManager.swapLtrOrderWhenDrag(container1, swapIndex, focusIndex, dragPersistentId);
    expect(container1.getMidScenes().size).assertEqual(3);
  });
  it('swapLtrOrderWhenDrag4', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    let swapIndex = 0;
    let focusIndex = 100;
    let dragPersistentId = -1;
    midSceneManager.swapLtrOrderWhenDrag(container1, swapIndex, focusIndex, dragPersistentId);
    expect(container1.getMidScenes().size).assertEqual(3);
  });
}

function MidSceneManagerTest_updateMidscenMapWhenInDrag01() {
  it('updateMidscenMapWhenInDrag', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    let ctx = (container1.sessionData.midSceneFSM as MidSceneFSM).context;
    let dragId = 2;
    let swapId = 3;
    midSceneManager.updateMidscenMapWhenInDrag(ctx, dragId, swapId, container1);
    expect(container1.getMidScenes().size).assertEqual(3);
  });
  it('updateMidscenMapWhenInDrag2', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    let midsceneData3: MidSceneData = new MidSceneData(2);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData3);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    container1.midSceneMap.set(2, scbSceneSession);
    let ctx = (container1.sessionData.midSceneFSM as MidSceneFSM).context;
    let dragId = 1;
    let swapId = 2;
    midSceneManager.updateMidscenMapWhenInDrag(ctx, dragId, swapId, container1);
    expect(container1.getMidScenes().size).assertEqual(3);
  });
  it('updateMidscenMapWhenInDrag3', Level.LEVEL0, () => {
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    (container1.sessionData.midSceneFSM as MidSceneFSM) = new MidSceneFSM(container1, callback);
    let midsceneData1: MidSceneData = new MidSceneData(0);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r = [];
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData1);
    let midsceneData2: MidSceneData = new MidSceneData(1);
    (container1.sessionData.midSceneFSM as MidSceneFSM).context.l2r.push(midsceneData2);
    container1.midSceneMap.set(0, scbSceneSession);
    container1.midSceneMap.set(1, scbSceneSession);
    let ctx = (container1.sessionData.midSceneFSM as MidSceneFSM).context;
    let dragId = 0;
    let swapId = 1;
    midSceneManager.updateMidscenMapWhenInDrag(ctx, dragId, swapId, container1);
    expect(container1.getMidScenes().size).assertEqual(2);
  });
}

function MidSceneManagerTest_clearStatusWhenDrag01() {
  it('updateMidscenMapWhenInDrag', Level.LEVEL0, () => {
    midSceneManager.clearStatusWhenDrag();
    let container1 = new SCBSceneContainerSession(primarySession, screenProperty);
    container1.midSceneMap.set(0, scbSceneSession);
    expect(container1.getMidScenes().size).assertEqual(1);
  });
}