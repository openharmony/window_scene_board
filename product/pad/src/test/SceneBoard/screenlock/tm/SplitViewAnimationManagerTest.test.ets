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
  SCBScreenProperty,
  SCBSceneInfo,
  SCBSceneSession,
  SCBSceneContainerSession,
  SCBSceneMode,
  SCBDividerParam,
  SCBScreenSessionManager
} from '@ohos/windowscene';
import { beforeAll, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import {
  SplitViewAnimationManager,
  SplitViewBreakAnimationFlag
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBSplitViewAnimationManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { ReflectionUtils } from '../../../../ohosTest/ets/test/ets/SceneBoard/scenemanager/multiwindow/ReflectionUtils';

const VOID_FUNC = (): void => {
};
const MAXIMIZE_SCENE_SCALE: number = 1;
const MAX_OPACITY: number = 1;
const MIN_FOREGROUND_EFFECT_RADIO = 0;
const DEFAULT_SCALE_CENTER_X = 0;
const DEFAULT_SCALE_CENTER_Y = 0;
let mocker: MockKit;
let animationManager = new SplitViewAnimationManager();
let screenProperty: SCBScreenProperty = new SCBScreenProperty();
let sceneInfo: SCBSceneInfo;
let secSceneInfo: SCBSceneInfo;
let primSession: SCBSceneSession;
let secondarySession: SCBSceneSession;
let containerSession: SCBSceneContainerSession;

let initAll = () => {
  sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
  secSceneInfo = new SCBSceneInfo('testSecBundle', 'testSecModule', 'testSecAbility');
  primSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  secondarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(secSceneInfo), sceneInfo);
  containerSession = new SCBSceneContainerSession(primSession, screenProperty);
  containerSession.addSceneSession(secondarySession);
  mocker = new MockKit();
}

export function SplitViewAnimationManagerTest() {
  describe('SplitViewAnimationManagerTest', () => {
    beforeAll(initAll);
    oneSplitFullViewWithAnimationTest();
    oneSplitFullAnimationLandscapeTest_False();
    oneSplitFullAnimationLandscapeTest_True();
    sessionBlurAnimationTest();
    priBackSecOneSplitAnimationTest();
    secBackPriOneSplitAnimationTest();
    backAndOneSplitAnimationBreakTest();
    breakSplitAnimationFinishTest();
    exitSplitViewWithAnimationTest();
    doDividerAppearAnimationTest();
    doDividerExchangeAnimation();
    initPrimTransInLandscapeTest();
    postExitSplitViewTaskTest();
    exitSplitViewWithAnimationFinishTest();
    prepareSplitRotationInFoldTest();
    clearSnapshotAttrTest();
    priBackSecOneSplitParamRecoverTest();
    secBackPriOneSplitParamRecoverTest();
  })
}

function breakSplitAnimationFinishTest() {
  it('breakSplitAnimationFinishTest', Level.LEVEL0, (): void => {
    let flag: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    flag.setMaxSplitViewAnimationBreak(true);
    expect(flag.getMaxSplitViewAnimationBreak()).assertTrue();
    animationManager.breakSplitAnimationFinish(flag, VOID_FUNC);
    expect(flag.getMaxSplitViewAnimationBreak()).assertFalse();
    expect(flag.getExitSplitPersistentId()).assertEqual(-1);
    flag.setExitSplitPersistentId(0);
    animationManager.breakSplitAnimationFinish(flag, VOID_FUNC);
    expect(flag.getExitSplitPersistentId()).assertEqual(-1);
  });
}

function doDividerExchangeAnimation() {
  it('doDividerExchangeAnimation_01', Level.LEVEL0, (): void => {
    animationManager.doDividerExchangeAnimation(containerSession, true);
    expect(containerSession.dividerParam.dividerAlpha).assertEqual(0);
    expect(containerSession.dividerParam.dividerOpacity).assertEqual(1);
  });
  it('doDividerExchangeAnimation_02', Level.LEVEL0, (): void => {
    animationManager.doDividerExchangeAnimation(containerSession, false);
    expect(containerSession.dividerParam.dividerAlpha).assertEqual(1);
    expect(containerSession.dividerParam.dividerOpacity).assertEqual(0);
  });
}

function doDividerAppearAnimationTest() {
  it('doDividerAppearAnimationTest_01', Level.LEVEL0, (): void => {
    animationManager.doDividerAppearAnimation(containerSession, true);
    expect(containerSession.dividerParam.dividerOpacity).assertEqual(1);
  });
  it('doDividerAppearAnimationTest_02', Level.LEVEL0, (): void => {
    animationManager.doDividerAppearAnimation(containerSession, false);
    expect(containerSession.dividerParam.dividerAlpha).assertEqual(1);
  });
}

function exitSplitViewWithAnimationTest() {
  it('exitSplitViewWithAnimationTest_01', Level.LEVEL0, exitSplitViewWithAnimationTest_01);

  it('exitSplitViewWithAnimationTest_02', Level.LEVEL0, exitSplitViewWithAnimationTest_02);

  it('exitSplitViewWithAnimationTest_03', Level.LEVEL0, (): void => {
    initAll();
    let flag: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    containerSession.primarySession = null;
    animationManager.exitSplitViewWithAnimation(flag, containerSession, false, secondarySession.session.persistentId,
      screenProperty.width, screenProperty.height, (): void => {});
    expect(flag.getExitSplitPersistentId()).assertEqual(secondarySession.session.persistentId);
  });

  it('exitSplitViewWithAnimationTest_04', Level.LEVEL0, (): void => {
    initAll();
    let flag: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    containerSession.secondarySession = null;
    animationManager.exitSplitViewWithAnimation(flag, containerSession, false, secondarySession.session.persistentId,
      screenProperty.width, screenProperty.height, (): void => {});
    expect(flag.getExitSplitPersistentId()).assertEqual(secondarySession.session.persistentId);
  });
}

function backAndOneSplitAnimationBreakTest() {
  it('backAndOneSplitAnimationBreakTest_01', Level.LEVEL0, (): void => {
    let flag: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    flag.setPriBackSecOneSplitBreak(true);
    expect(flag.getPriBackSecOneSplitBreak()).assertTrue();
    animationManager.backAndOneSplitAnimationBreak(flag, containerSession, () => {});
    expect(flag.getPriBackSecOneSplitBreak()).assertFalse();
  });
  it('backAndOneSplitAnimationBreakTest_02', Level.LEVEL0, (): void => {
    initAll();
    let mocker = new MockKit();
    let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    let isFoldablePhoneExpandStatus = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
    when(isFoldablePhoneExpandStatus)().afterReturn(false);
    containerSession.dividerParam.setIsVertical(true);
    let flag: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    flag.setPriBackSecOneSplitBreak(true);
    expect(flag.getPriBackSecOneSplitBreak()).assertTrue();
    containerSession.dividerParam.splitOrderIsNotReverse = true;
    containerSession.dividerParam.needCutOut = false;
    animationManager.backAndOneSplitAnimationBreak(flag, null, () => {});
    expect(flag.getPriBackSecOneSplitBreak()).assertTrue();
    mocker.clear(manager);
  });
  it('backAndOneSplitAnimationBreakTest_03', Level.LEVEL0, (): void => {
    initAll();
    let flag: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    flag.setPriBackSecOneSplitBreak(true);
    expect(flag.getPriBackSecOneSplitBreak()).assertTrue();
    containerSession.primarySession = null;
    animationManager.backAndOneSplitAnimationBreak(flag, containerSession, () => {});
    expect(flag.getPriBackSecOneSplitBreak()).assertTrue();
  });
  it('backAndOneSplitAnimationBreakTest_04', Level.LEVEL0, (): void => {
    initAll();
    let flag: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    flag.setPriBackSecOneSplitBreak(true);
    expect(flag.getPriBackSecOneSplitBreak()).assertTrue();
    containerSession.secondarySession = null;
    animationManager.backAndOneSplitAnimationBreak(flag, containerSession, () => {});
    expect(flag.getPriBackSecOneSplitBreak()).assertTrue();
  });
  it('backAndOneSplitAnimationBreakTest_05', Level.LEVEL0, (): void => {
    initAll();
    let flag: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    flag.setSecBackPriOneSplitBreak(true);
    expect(flag.getSecBackPriOneSplitBreak()).assertTrue();
    animationManager.backAndOneSplitAnimationBreak(flag, containerSession, () => {});
    expect(flag.getSecBackPriOneSplitBreak()).assertFalse();
  });
  it('backAndOneSplitAnimationBreakTest_06', Level.LEVEL0, (): void => {
    initAll();
    let mocker = new MockKit();
    let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    let isFoldablePhoneExpandStatus = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
    when(isFoldablePhoneExpandStatus)().afterReturn(false);
    containerSession.dividerParam.setIsVertical(false);
    let flag: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    flag.setPriBackSecOneSplitBreak(true);
    expect(flag.getPriBackSecOneSplitBreak()).assertTrue();
    containerSession.dividerParam.splitOrderIsNotReverse = false;
    containerSession.dividerParam.needCutOut = true;
    animationManager.backAndOneSplitAnimationBreak(flag, containerSession, () => {});
    expect(flag.getPriBackSecOneSplitBreak()).assertFalse();
    mocker.clear(manager);
  });
}

function sessionBlurAnimationTest() {
  it('sessionBlurAnimationTest_01', Level.LEVEL0, (): void => {
    animationManager.sessionBlurAnimation(containerSession, true);
    expect(containerSession.dividerParam.primary.blurScale).assertEqual(0);
  });
  it('sessionBlurAnimationTest_02', Level.LEVEL0, (): void => {
    animationManager.sessionBlurAnimation(containerSession, false);
    expect(containerSession.dividerParam.primary.blurScale).assertEqual(0);
  });
}

function secBackPriOneSplitAnimationTest() {
  it('secBackPriOneSplitAnimationTest_01', Level.LEVEL0, (): void => {
    let mocker = new MockKit();
    let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    let isFoldablePhoneExpandStatus = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
    when(isFoldablePhoneExpandStatus)().afterReturn(false);
    containerSession.dividerParam.setIsVertical(true);
    containerSession.dividerParam.secondary.opacity = 1;
    containerSession.dividerParam.blackBackgroundOpacity = 1;
    animationManager.secBackPriOneSplitAnimation(new SplitViewBreakAnimationFlag(),
      sceneInfo.persistentId, containerSession, false, () => {});
    expect(containerSession.dividerParam.secondary.opacity).assertEqual(0);
    expect(containerSession.dividerParam.blackBackgroundOpacity).assertEqual(0);
    mocker.clear(manager);
  });
  it('secBackPriOneSplitAnimationTest_02', Level.LEVEL0, (): void => {
    let mocker = new MockKit();
    let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    let isFoldablePhoneExpandStatus = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
    when(isFoldablePhoneExpandStatus)().afterReturn(false);
    containerSession.dividerParam.setIsVertical(false);
    containerSession.dividerParam.secondary.opacity = 1;
    containerSession.dividerParam.blackBackgroundOpacity = 1;
    animationManager.secBackPriOneSplitAnimation(new SplitViewBreakAnimationFlag(),
      sceneInfo.persistentId, containerSession, false, () => {});
    expect(containerSession.dividerParam.secondary.opacity).assertEqual(0);
    expect(containerSession.dividerParam.blackBackgroundOpacity).assertEqual(0);
    mocker.clear(manager);
  });
}

function priBackSecOneSplitAnimationTest() {
  it('priBackSecOneSplitAnimationTest_01', Level.LEVEL0, (): void => {
    let mocker = new MockKit();
    let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    let isFoldablePhoneExpandStatus = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
    when(isFoldablePhoneExpandStatus)().afterReturn(false);
    containerSession.dividerParam.setIsVertical(true);
    containerSession.dividerParam.needCutOut = true;
    animationManager.priBackSecOneSplitAnimation(new SplitViewBreakAnimationFlag(), sceneInfo.persistentId,
      containerSession, false, () => {});
    expect(containerSession.dividerParam.needCutOut).assertFalse();
    mocker.clear(manager);
  });
  it('priBackSecOneSplitAnimationTest_02', Level.LEVEL0, (): void => {
    let mocker = new MockKit();
    let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    let mockFunc = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(false);
    containerSession.dividerParam.needCutOut = true;
    containerSession.dividerParam.setIsVertical(false);
    animationManager.priBackSecOneSplitAnimation(new SplitViewBreakAnimationFlag(), sceneInfo.persistentId,
      containerSession, false, () => {});
    expect(containerSession.dividerParam.needCutOut).assertFalse();
    mocker.clear(manager);
  });
}

function oneSplitFullViewWithAnimationTest() {
  it('oneSplitFullViewWithAnimationTest_01', Level.LEVEL0, (): void => {
    let mocker = new MockKit();
    let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    let mockFunc = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(false);
    containerSession.dividerParam.setIsVertical(true);
    animationManager.oneSplitFullViewWithAnimation(containerSession, 100, 100);
    expect(containerSession.dividerParam.doHideAnimation).assertFalse();
    mocker.clear(manager);
  });

  it('oneSplitFullViewWithAnimationTest_02', Level.LEVEL0, (): void => {
    let mocker = new MockKit();
    let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    let mockFunc = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(false);
    containerSession.dividerParam.setIsVertical(false);
    animationManager.oneSplitFullViewWithAnimation(containerSession, 100, 100);
    expect(containerSession.dividerParam.doHideAnimation).assertFalse();
    mocker.clear(manager);
  });

  it('oneSplitFullViewWithAnimationTest_03', Level.LEVEL0, (): void => {
    containerSession.needRenderScale.setScaleX(1);
    containerSession.needRenderScale.setScaleY(1);
    containerSession.isSplit = false;
    containerSession.isFloat = false;
    animationManager.oneSplitFullViewWithAnimation(containerSession, 100, 100);
    expect(containerSession.dividerParam.doHideAnimation).assertFalse();
  });

  it('oneSplitFullViewWithAnimationTest_04', Level.LEVEL0, (): void => {
    containerSession.isSplit = true;
    containerSession.isFloat = false;
    animationManager.oneSplitFullViewWithAnimation(containerSession, 100, 100);
    expect(containerSession.dividerParam.doHideAnimation).assertFalse();
  });
}

function oneSplitFullAnimationLandscapeTest_False() {
  it('oneSplitFullAnimationLandscapeTest_1', Level.LEVEL0, (): void => {
    let mocker = new MockKit();
    let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    let mockFunc = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(false);
    containerSession.dividerParam.setIsVertical(false);
    animationManager.oneSplitFullAnimationLandscape(containerSession, 100, 100, 90);
    expect(containerSession.dividerParam.dividerOpacity).assertEqual(0);
    expect(containerSession.dividerParam.primary.translateX).assertEqual(0);
    mocker.clear(manager);
  });
  it('oneSplitFullAnimationLandscapeTest_2', Level.LEVEL0, (): void => {
    let mocker = new MockKit();
    let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    let mockFunc = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(false);
    containerSession.dividerParam.setIsVertical(false);
    animationManager.oneSplitFullAnimationLandscape(containerSession, 100, 100, 180);
    expect(containerSession.dividerParam.dividerOpacity).assertEqual(0);
    expect(containerSession.dividerParam.primary.translateX).assertEqual(0);
    mocker.clear(manager);
  });
  it('oneSplitFullAnimationLandscapeTest_3', Level.LEVEL0, (): void => {
    let mocker = new MockKit();
    let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    let mockFunc = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(false);
    containerSession.dividerParam.setIsVertical(false);
    animationManager.oneSplitFullAnimationLandscape(containerSession, 100, 100, 270);
    expect(containerSession.dividerParam.dividerOpacity).assertEqual(0);
    expect(containerSession.dividerParam.primary.translateX).assertEqual(0);
    mocker.clear(manager);
  });
}

function oneSplitFullAnimationLandscapeTest_True() {
  it('oneSplitFullAnimationLandscapeTest_4', Level.LEVEL0, (): void => {
    let mocker = new MockKit();
    let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    let mockFunc = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(false);
    containerSession.dividerParam.setIsVertical(true);
    animationManager.oneSplitFullAnimationLandscape(containerSession, 100, 100, 90);
    expect(containerSession.dividerParam.dividerOpacity).assertEqual(0);
    expect(containerSession.dividerParam.primary.translateX).assertEqual(0);
    mocker.clear(manager);
  });
  it('oneSplitFullAnimationLandscapeTest_5', Level.LEVEL0, (): void => {
    let mocker = new MockKit();
    let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    let mockFunc = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(false);
    containerSession.dividerParam.setIsVertical(true);
    containerSession.screenProperty.rotation = 180;
    animationManager.oneSplitFullAnimationLandscape(containerSession, 100, 100, 90);
    expect(containerSession.dividerParam.dividerOpacity).assertEqual(0);
    expect(containerSession.dividerParam.primary.translateX).assertEqual(0);
    mocker.clear(manager);
  });
  it('oneSplitFullAnimationLandscapeTest_6', Level.LEVEL0, (): void => {
    let mocker = new MockKit();
    let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
    let mockFunc = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(false);
    containerSession.dividerParam.setIsVertical(true);
    containerSession.screenProperty.rotation = 270;
    animationManager.oneSplitFullAnimationLandscape(containerSession, 100, 100, 90);
    expect(containerSession.dividerParam.dividerOpacity).assertEqual(0);
    expect(containerSession.dividerParam.primary.translateX).assertEqual(0);
    mocker.clear(manager);
  });
}

function initPrimTransInLandscapeTest() {
  it('initPrimTransInLandscapeTest_Rotation_0', Level.LEVEL0, (): void => {
    containerSession.currentRotation = 0;
    animationManager.initPrimTransInLandscape(containerSession, 1024);
    expect(containerSession.dividerParam.needClip).assertTrue();
  });
  it('initPrimTransInLandscapeTest_Rotation_270', Level.LEVEL0, (): void => {
    containerSession.currentRotation = 270;
    animationManager.initPrimTransInLandscape(containerSession, 1024);
    expect(containerSession.dividerParam.needClip).assertTrue();
  });
}

function postExitSplitViewTaskTest() {
  it('postExitSplitViewTaskTest', Level.LEVEL0, postExitSplitViewTaskTestFunction)
}

function postExitSplitViewTaskTestFunction(): void {
  let dividerParam = containerSession.dividerParam;
  let mockFunc = mocker.mockFunc(dividerParam, dividerParam.isUpDownSplit);
  let splitOrderIsNotReverse: boolean;
  let isUpDownSplit: boolean;
  let isMaximizePrimary: boolean;
  for (let i = 0; i < 2; i++) {
    for (let j = 0; j < 2; j++) {
      for (let k = 0; k < 2; k++) {
        postExitSplitViewTaskTestFunction_01(mockFunc, splitOrderIsNotReverse = (i === 0),
          isMaximizePrimary = (j === 0), isUpDownSplit = (k === 0));
      }
    }
  }
  mocker.clear(mockFunc);
}

function postExitSplitViewTaskTestFunction_01(mockFunc: Function, splitOrderIsNotReverse: boolean,
  isMaximizePrimary: boolean, isUpDownSplit: boolean) {
  let flag: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
  containerSession.dividerParam.splitOrderIsNotReverse = splitOrderIsNotReverse;
  ReflectionUtils.setProperty(animationManager, 'isMaximizePrimary', isMaximizePrimary);
  when(mockFunc)().afterReturn(isUpDownSplit);
  containerSession.dividerParam.primary.sceneFreeze = false;
  containerSession.dividerParam.secondary.sceneFreeze = false;
  let postExitSplitViewTask: (breakFlag: SplitViewBreakAnimationFlag,
    currContainerSession: SCBSceneContainerSession, exitPersistentId: number, screenW: number, screenH: number,
    exitSplitView: ((persistentId: number) => void)) => void =
    ReflectionUtils.getProperty(animationManager, 'postExitSplitViewTask');
  postExitSplitViewTask(flag, containerSession, secondarySession.session.persistentId,
    screenProperty.width, screenProperty.height, (): void => {
    });
  expect(containerSession.dividerParam.primary.sceneFreeze).assertFalse();
  expect(containerSession.dividerParam.secondary.sceneFreeze).assertFalse();
}

function exitSplitViewWithAnimationFinishTest() {
  it('exitSplitViewWithAnimationFinishTest', Level.LEVEL0, (): void => {
    initAll();
    let flag: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    let exitSplitViewWithAnimationFinish: (currContainerSession: SCBSceneContainerSession,
      breakFlag: SplitViewBreakAnimationFlag, exitSplitView: Function) => void =
      ReflectionUtils.getProperty(animationManager, 'exitSplitViewWithAnimationFinish');
    flag.setMaxSplitViewAnimationBreak(true);
    exitSplitViewWithAnimationFinish(containerSession, flag, VOID_FUNC);
    expect(flag.getMaxSplitViewAnimationBreak()).assertFalse();
    containerSession.secondarySession = null;
    flag.setMaxSplitViewAnimationBreak(false);
    exitSplitViewWithAnimationFinish(containerSession, flag, VOID_FUNC);
    expect(flag.getMaxSplitViewAnimationBreak()).assertFalse();
  });
}

function exitSplitViewWithAnimationTest_01(): void {
  let dividerParam = containerSession.dividerParam;
  let mockFunc = mocker.mockFunc(dividerParam, dividerParam.isUpDownSplit);
  let splitOrderIsNotReverse: boolean;
  let isUpDownSplit: boolean;
  for (let i = 0; i < 2; i++) {
    for (let j = 0; j < 2; j++) {
      exitSplitViewWithAnimationTestFunction_01(mockFunc, splitOrderIsNotReverse = (i === 0),
        isUpDownSplit = (j === 0));
    }
  }
}

function exitSplitViewWithAnimationTest_02(): void {
  let dividerParam = containerSession.dividerParam;
  let mockFunc = mocker.mockFunc(dividerParam, dividerParam.isUpDownSplit);
  let splitOrderIsNotReverse: boolean;
  let isUpDownSplit: boolean;
  for (let i = 0; i < 2; i++) {
    for (let j = 0; j < 2; j++) {
      exitSplitViewWithAnimationTestFunction_02(mockFunc, splitOrderIsNotReverse = (i === 0),
        isUpDownSplit = (j === 0));
    }
  }
  mocker.clear(mockFunc);
  let flag: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
  containerSession.secondarySession = null;
  animationManager.exitSplitViewWithAnimation(flag, containerSession, false, primSession.session.persistentId,
    screenProperty.width, screenProperty.height, VOID_FUNC);
  containerSession.primarySession = null;
  animationManager.exitSplitViewWithAnimation(flag, containerSession, false, primSession.session.persistentId,
    screenProperty.width, screenProperty.height, VOID_FUNC);
}

function exitSplitViewWithAnimationTestFunction_01(mockFunc: Function,
  splitOrderIsNotReverse: boolean, isUpDownSplit: boolean) {
  let flag: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
  when(mockFunc)().afterReturn(isUpDownSplit);
  containerSession.dividerParam.splitOrderIsNotReverse = splitOrderIsNotReverse;
  animationManager.exitSplitViewWithAnimation(flag, containerSession, true, primSession.session.persistentId,
    screenProperty.width, screenProperty.height, VOID_FUNC);
}

function exitSplitViewWithAnimationTestFunction_02(mockFunc: Function, splitOrderIsNotReverse: boolean,
  isUpDownSplit: boolean) {
  let flag: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
  when(mockFunc)().afterReturn(isUpDownSplit);
  containerSession.dividerParam.splitOrderIsNotReverse = splitOrderIsNotReverse;
  animationManager.exitSplitViewWithAnimation(flag, containerSession, false, secondarySession.session.persistentId,
    screenProperty.width, screenProperty.height, VOID_FUNC);
}

function prepareSplitRotationInFoldTest() {
  it('prepareSplitRotationInFoldTest_Rotation_90', Level.LEVEL0, (): void => {
    screenProperty.rotation = 90;
    containerSession.screenProperty.rotation = 0;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(containerSession.snapshotAnimateAlpha).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
  });
  it('prepareSplitRotationInFoldTest_Rotation_270', Level.LEVEL0, (): void => {
    screenProperty.rotation = 270;
    containerSession.screenProperty.rotation = 0;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(containerSession.snapshotAnimateAlpha).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
  });
  it('prepareSplitRotationInFoldTest_Rotation_0', Level.LEVEL0, (): void => {
    screenProperty.rotation = 0;
    containerSession.screenProperty.rotation = 90;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(containerSession.snapshotAnimateAlpha).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
  });
}

function clearSnapshotAttrTest() {
  it('clearSnapshotAttrTest', Level.LEVEL0, (): void => {
    animationManager.clearSnapshotAttr(containerSession);
    expect(containerSession.snapshotSource).assertEqual(null);
    animationManager.clearSnapshotAttr(null);
  });
}

function priBackSecOneSplitParamRecoverTest() {
  it('priBackSecOneSplitParamRecoverTest', Level.LEVEL0, (): void => {
    containerSession.dividerParam.primary.scaleX = 0.9;
    containerSession.dividerParam.primary.scaleY = 0.9;
    containerSession.dividerParam.primary.opacity = 0.9;
    containerSession.dividerParam.primary.effectRatio = 0.9;
    containerSession.dividerParam.primary.scaleCenterX = 0.9;
    containerSession.dividerParam.primary.scaleCenterY = 0.9;
    animationManager.priBackSecOneSplitParamRecover(containerSession);
    expect(containerSession.dividerParam.primary.scaleX).assertEqual(MAXIMIZE_SCENE_SCALE);
    expect(containerSession.dividerParam.primary.scaleY).assertEqual(MAXIMIZE_SCENE_SCALE);
    expect(containerSession.dividerParam.primary.opacity).assertEqual(MAX_OPACITY);
    expect(containerSession.dividerParam.primary.effectRatio).assertEqual(MIN_FOREGROUND_EFFECT_RADIO);
    expect(containerSession.dividerParam.primary.scaleCenterX).assertEqual(DEFAULT_SCALE_CENTER_X);
    expect(containerSession.dividerParam.primary.scaleCenterY).assertEqual(DEFAULT_SCALE_CENTER_Y);

    containerSession.dividerParam.primary.scaleX = -1;
    containerSession.dividerParam.primary.scaleY = -1;
    containerSession.dividerParam.primary.opacity = -1;
    containerSession.dividerParam.primary.effectRatio = -1;
    containerSession.dividerParam.primary.scaleCenterX = -1;
    containerSession.dividerParam.primary.scaleCenterY = -1;
    animationManager.priBackSecOneSplitParamRecover(containerSession);
    expect(containerSession.dividerParam.primary.opacity).assertEqual(MAX_OPACITY);
    expect(containerSession.dividerParam.primary.effectRatio).assertEqual(MIN_FOREGROUND_EFFECT_RADIO);
    expect(containerSession.dividerParam.primary.scaleX).assertEqual(MAXIMIZE_SCENE_SCALE);
    expect(containerSession.dividerParam.primary.scaleY).assertEqual(MAXIMIZE_SCENE_SCALE);
    expect(containerSession.dividerParam.primary.scaleCenterX).assertEqual(DEFAULT_SCALE_CENTER_X);
    expect(containerSession.dividerParam.primary.scaleCenterY).assertEqual(DEFAULT_SCALE_CENTER_Y);
  })
}

function secBackPriOneSplitParamRecoverTest() {
  it('secBackPriOneSplitParamRecoverTest', Level.LEVEL0, (): void => {
    containerSession.dividerParam.secondary.scaleX = 0.8;
    containerSession.dividerParam.secondary.scaleY = 0.8;
    containerSession.dividerParam.secondary.opacity = 0.8;
    containerSession.dividerParam.secondary.effectRatio = 0.8;
    containerSession.dividerParam.secondary.scaleCenterX = 0.8;
    containerSession.dividerParam.secondary.scaleCenterY = 0.8;
    animationManager.secBackPriOneSplitParamRecover(containerSession);
    expect(containerSession.dividerParam.secondary.scaleX).assertEqual(MAXIMIZE_SCENE_SCALE);
    expect(containerSession.dividerParam.secondary.scaleY).assertEqual(MAXIMIZE_SCENE_SCALE);
    expect(containerSession.dividerParam.secondary.opacity).assertEqual(MAX_OPACITY);
    expect(containerSession.dividerParam.secondary.effectRatio).assertEqual(MIN_FOREGROUND_EFFECT_RADIO);
    expect(containerSession.dividerParam.secondary.scaleCenterX).assertEqual(DEFAULT_SCALE_CENTER_X);
    expect(containerSession.dividerParam.secondary.scaleCenterY).assertEqual(DEFAULT_SCALE_CENTER_Y);
    containerSession.dividerParam.secondary.scaleX = -1;
    containerSession.dividerParam.secondary.scaleY = -1;
    containerSession.dividerParam.secondary.opacity = -1;
    containerSession.dividerParam.secondary.effectRatio = -1;
    containerSession.dividerParam.secondary.scaleCenterX = -1;
    containerSession.dividerParam.secondary.scaleCenterY = -1;
    animationManager.secBackPriOneSplitParamRecover(containerSession);
    expect(containerSession.dividerParam.secondary.opacity).assertEqual(MAX_OPACITY);
    expect(containerSession.dividerParam.secondary.effectRatio).assertEqual(MIN_FOREGROUND_EFFECT_RADIO);
    expect(containerSession.dividerParam.secondary.scaleX).assertEqual(MAXIMIZE_SCENE_SCALE);
    expect(containerSession.dividerParam.secondary.scaleY).assertEqual(MAXIMIZE_SCENE_SCALE);
    expect(containerSession.dividerParam.secondary.scaleCenterX).assertEqual(DEFAULT_SCALE_CENTER_X);
    expect(containerSession.dividerParam.secondary.scaleCenterY).assertEqual(DEFAULT_SCALE_CENTER_Y);
    containerSession.dividerParam.secondary.scaleX = 0;
    containerSession.dividerParam.secondary.scaleY = 0;
    containerSession.dividerParam.secondary.opacity = 0;
    containerSession.dividerParam.secondary.effectRatio = 0;
    containerSession.dividerParam.secondary.scaleCenterX = 0;
    containerSession.dividerParam.secondary.scaleCenterY = 0;
    animationManager.secBackPriOneSplitParamRecover(containerSession);
    expect(containerSession.dividerParam.secondary.scaleCenterX).assertEqual(DEFAULT_SCALE_CENTER_X);
    expect(containerSession.dividerParam.secondary.scaleCenterY).assertEqual(DEFAULT_SCALE_CENTER_Y);
    expect(containerSession.dividerParam.secondary.opacity).assertEqual(MAX_OPACITY);
    expect(containerSession.dividerParam.secondary.effectRatio).assertEqual(MIN_FOREGROUND_EFFECT_RADIO);
    expect(containerSession.dividerParam.secondary.scaleX).assertEqual(MAXIMIZE_SCENE_SCALE);
    expect(containerSession.dividerParam.secondary.scaleY).assertEqual(MAXIMIZE_SCENE_SCALE);
  });
}

function resetPriBackOneSplitTest() {
  it('resetPriBackOneSplitTest', Level.LEVEL0, (): void => {
    containerSession.primarySession = primSession;
    let breakSplitFlag01: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    breakSplitFlag01.setPriBackSecOneSplitBreak(true);
    animationManager.resetPriBackOneSplit(containerSession, breakSplitFlag01, () => {});
    expect(breakSplitFlag01.getPriBackSecOneSplitBreak()).assertEqual(true);

    containerSession.primarySession = secondarySession;
    let breakSplitFlag02: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    breakSplitFlag02.setPriBackSecOneSplitBreak(true);
    animationManager.resetPriBackOneSplit(containerSession, breakSplitFlag02, () => {});
    expect(breakSplitFlag02.getPriBackSecOneSplitBreak()).assertEqual(true);

    containerSession.primarySession = primSession;
    containerSession.secondarySession = secondarySession;
    let breakSplitFlag: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    breakSplitFlag.setPriBackSecOneSplitBreak(true);
    animationManager.resetPriBackOneSplit(containerSession, breakSplitFlag, () => {});
    expect(breakSplitFlag.getPriBackSecOneSplitBreak()).assertEqual(true);

    containerSession.primarySession = secondarySession;
    containerSession.secondarySession = primSession;
    let breakSplitFlag03: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    breakSplitFlag03.setPriBackSecOneSplitBreak(true);
    animationManager.resetPriBackOneSplit(containerSession, breakSplitFlag03, () => {});
    expect(breakSplitFlag03.getPriBackSecOneSplitBreak()).assertEqual(true);

    containerSession.primarySession = primSession;
    containerSession.secondarySession = secondarySession;
    let breakFlag: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    breakFlag.setPriBackSecOneSplitBreak(false);
    animationManager.resetPriBackOneSplit(containerSession, breakFlag, () => {});
    expect(breakFlag.getPriBackSecOneSplitBreak()).assertEqual(false);

    containerSession.primarySession = primSession;
    let breakFlag01: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    breakFlag01.setPriBackSecOneSplitBreak(false);
    animationManager.resetPriBackOneSplit(containerSession, breakFlag01, () => {});
    expect(breakFlag01.getPriBackSecOneSplitBreak()).assertEqual(false);

    containerSession.primarySession = secondarySession;
    let breakFlag02: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    breakFlag02.setPriBackSecOneSplitBreak(false);
    animationManager.resetPriBackOneSplit(containerSession, breakFlag02, () => {});
    expect(breakFlag02.getPriBackSecOneSplitBreak()).assertEqual(false);

    containerSession.primarySession = secondarySession;
    containerSession.secondarySession = primSession;
    let breakFlag03: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    breakFlag03.setPriBackSecOneSplitBreak(false);
    animationManager.resetPriBackOneSplit(containerSession, breakFlag03, () => {});
    expect(breakFlag03.getPriBackSecOneSplitBreak()).assertEqual(false);
  });
}

function resetPriBackOneSplitTest_2() {
  it('resetPriBackOneSplitTest_2', Level.LEVEL0, (): void => {
    let container = containerSession;
    let manager = animationManager;
    container.primarySession = primSession;
    let flag01: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    flag01.setPriBackSecOneSplitBreak(true);
    manager.resetPriBackOneSplit(container, flag01, () => {});
    expect(flag01.getPriBackSecOneSplitBreak()).assertEqual(true);

    container.primarySession = secondarySession;
    let flag02: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    flag02.setPriBackSecOneSplitBreak(true);
    manager.resetPriBackOneSplit(container, flag02, () => {});
    expect(flag02.getPriBackSecOneSplitBreak()).assertEqual(true);

    container.primarySession = primSession;
    container.secondarySession = secondarySession;
    let flag: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    flag.setPriBackSecOneSplitBreak(true);
    manager.resetPriBackOneSplit(container, flag, () => {});
    expect(flag.getPriBackSecOneSplitBreak()).assertEqual(true);

    container.primarySession = secondarySession;
    container.secondarySession = primSession;
    let flag03: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    flag03.setPriBackSecOneSplitBreak(true);
    manager.resetPriBackOneSplit(container, flag03, () => {});
    expect(flag03.getPriBackSecOneSplitBreak()).assertEqual(true);

    container.primarySession = primSession;
    container.secondarySession = secondarySession;
    let flag04: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    flag04.setPriBackSecOneSplitBreak(false);
    manager.resetPriBackOneSplit(container, flag04, () => {});
    expect(flag04.getPriBackSecOneSplitBreak()).assertEqual(false);

    container.primarySession = primSession;
    let flag05: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    flag05.setPriBackSecOneSplitBreak(false);
    manager.resetPriBackOneSplit(container, flag05, () => {});
    expect(flag05.getPriBackSecOneSplitBreak()).assertEqual(false);

    container.primarySession = secondarySession;
    let flag06: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    flag06.setPriBackSecOneSplitBreak(false);
    manager.resetPriBackOneSplit(container, flag06, () => {});
    expect(flag06.getPriBackSecOneSplitBreak()).assertEqual(false);

    container.primarySession = secondarySession;
    container.secondarySession = primSession;
    let flag07: SplitViewBreakAnimationFlag = new SplitViewBreakAnimationFlag();
    flag07.setPriBackSecOneSplitBreak(false);
    manager.resetPriBackOneSplit(container, flag07, () => {});
    expect(flag07.getPriBackSecOneSplitBreak()).assertEqual(false);
  });
}

function prepareSplitRotationInFoldTestAdd() {
  it('prepareSplitRotationInFoldTestAdd', Level.LEVEL0, (): void => {
    screenProperty.rotation = 0;
    containerSession.screenProperty.rotation = 0;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(screenProperty.rotation).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 0;
    containerSession.screenProperty.rotation = 45;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(screenProperty.rotation).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 0;
    containerSession.screenProperty.rotation = 90;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(screenProperty.rotation).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 0;
    containerSession.screenProperty.rotation = 120;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(screenProperty.rotation).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 0;
    containerSession.screenProperty.rotation = 180;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(screenProperty.rotation).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 0;
    containerSession.screenProperty.rotation = 210;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(screenProperty.rotation).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 0;
    containerSession.screenProperty.rotation = 270;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(screenProperty.rotation).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 0;
    containerSession.screenProperty.rotation = 300;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(screenProperty.rotation).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 0;
    containerSession.screenProperty.rotation = 360;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(screenProperty.rotation).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 0;
    containerSession.screenProperty.rotation = 361;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(screenProperty.rotation).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 45;
    containerSession.screenProperty.rotation = 0;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(containerSession.screenProperty.rotation).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 90;
    containerSession.screenProperty.rotation = 0;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(containerSession.screenProperty.rotation).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 120;
    containerSession.screenProperty.rotation = 0;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(containerSession.screenProperty.rotation).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 180;
    containerSession.screenProperty.rotation = 0;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(containerSession.screenProperty.rotation).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 210;
    containerSession.screenProperty.rotation = 0;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(containerSession.screenProperty.rotation).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 270;
    containerSession.screenProperty.rotation = 0;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(containerSession.screenProperty.rotation).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 300;
    containerSession.screenProperty.rotation = 0;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(containerSession.screenProperty.rotation).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 360;
    containerSession.screenProperty.rotation = 0;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(containerSession.screenProperty.rotation).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 361;
    containerSession.screenProperty.rotation = 0;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(containerSession.screenProperty.rotation).assertEqual(0);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 90;
    containerSession.screenProperty.rotation = 90;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(screenProperty.rotation).assertEqual(90);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 90;
    containerSession.screenProperty.rotation = 180;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(screenProperty.rotation).assertEqual(90);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 90;
    containerSession.screenProperty.rotation = 270;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(screenProperty.rotation).assertEqual(90);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 90;
    containerSession.screenProperty.rotation = 360;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(screenProperty.rotation).assertEqual(90);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 180;
    containerSession.screenProperty.rotation = 180;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(screenProperty.rotation).assertEqual(180);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 180;
    containerSession.screenProperty.rotation = 270;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(screenProperty.rotation).assertEqual(180);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 180;
    containerSession.screenProperty.rotation = 360;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(screenProperty.rotation).assertEqual(180);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 270;
    containerSession.screenProperty.rotation = 270;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(screenProperty.rotation).assertEqual(270);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
    screenProperty.rotation = 270;
    containerSession.screenProperty.rotation = 360;
    animationManager.prepareSplitRotationInFold(containerSession, screenProperty);
    expect(screenProperty.rotation).assertEqual(270);
    animationManager.prepareSplitRotationInFold(null, screenProperty);
  });
}

function prepareSplitRotationInFoldTestAdd_2() {
  it('prepareSplitRotationInFoldTestAdd_2', Level.LEVEL0, (): void => {
    let container = containerSession;
    let screenInfo = container.screenProperty;
    let manager = animationManager;
    screenInfo.rotation = 0;
    screenInfo.rotation = 0;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(0);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 0;
    screenInfo.rotation = 45;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(0);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 0;
    screenInfo.rotation = 90;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(0);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 0;
    screenInfo.rotation = 120;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(0);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 0;
    screenInfo.rotation = 180;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(0);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 0;
    screenInfo.rotation = 210;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(0);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 0;
    screenInfo.rotation = 270;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(0);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 0;
    screenInfo.rotation = 300;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(0);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 0;
    screenInfo.rotation = 360;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(0);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 0;
    screenInfo.rotation = 361;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(0);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 45;
    screenInfo.rotation = 0;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(0);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 90;
    screenInfo.rotation = 0;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(0);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 120;
    screenInfo.rotation = 0;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(0);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 180;
    screenInfo.rotation = 0;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(0);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 210;
    screenInfo.rotation = 0;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(0);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 270;
    screenInfo.rotation = 0;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(0);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 300;
    screenInfo.rotation = 0;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(0);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 360;
    screenInfo.rotation = 0;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(0);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 361;
    screenInfo.rotation = 0;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(0);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 90;
    screenInfo.rotation = 90;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(90);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 90;
    screenInfo.rotation = 180;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(90);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 90;
    screenInfo.rotation = 270;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(90);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 90;
    screenInfo.rotation = 360;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(90);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 180;
    screenInfo.rotation = 180;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(180);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 180;
    screenInfo.rotation = 270;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(180);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 180;
    screenInfo.rotation = 360;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(180);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 270;
    screenInfo.rotation = 270;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(270);
    manager.prepareSplitRotationInFold(null, screenInfo);
    screenInfo.rotation = 270;
    screenInfo.rotation = 360;
    manager.prepareSplitRotationInFold(container, screenInfo);
    expect(screenInfo.rotation).assertEqual(270);
    manager.prepareSplitRotationInFold(null, screenInfo);
  });
}

function prepareSplitRotationInFoldTestAdd_3() {
  it('prepareSplitRotationInFoldTestAdd_3', Level.LEVEL0, (): void => {
    let testSplitContainer = containerSession;
    testSplitContainer.isSplit = true;
    let testGlobalScreenInfo = screenProperty;
    let testScreenInfo = testSplitContainer.screenProperty;
    let teatManager = animationManager;
    testGlobalScreenInfo.rotation = 0;
    testScreenInfo.rotation = 0;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(0);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 0;
    testScreenInfo.rotation = 45;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(0);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 0;
    testScreenInfo.rotation = 90;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(0);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 0;
    testScreenInfo.rotation = 120;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(0);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 0;
    testScreenInfo.rotation = 180;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(0);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 0;
    testScreenInfo.rotation = 210;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(0);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 0;
    testScreenInfo.rotation = 270;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(0);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 0;
    testScreenInfo.rotation = 300;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(0);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 0;
    testScreenInfo.rotation = 360;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(0);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 0;
    testScreenInfo.rotation = 361;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(0);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 45;
    testScreenInfo.rotation = 0;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(0);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 90;
    testScreenInfo.rotation = 0;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(0);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 120;
    testScreenInfo.rotation = 0;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(0);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 180;
    testScreenInfo.rotation = 0;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(0);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 210;
    testScreenInfo.rotation = 0;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(0);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 270;
    testScreenInfo.rotation = 0;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(0);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 300;
    testScreenInfo.rotation = 0;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(0);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 360;
    testScreenInfo.rotation = 0;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(0);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 361;
    testScreenInfo.rotation = 0;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(0);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 90;
    testScreenInfo.rotation = 90;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(90);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 90;
    testScreenInfo.rotation = 180;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(90);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 90;
    testScreenInfo.rotation = 270;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(90);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 90;
    testScreenInfo.rotation = 360;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(90);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 180;
    testScreenInfo.rotation = 180;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(180);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 180;
    testScreenInfo.rotation = 270;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(180);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 180;
    testScreenInfo.rotation = 360;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(180);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 270;
    testScreenInfo.rotation = 270;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(270);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
    testGlobalScreenInfo.rotation = 270;
    testScreenInfo.rotation = 360;
    teatManager.prepareSplitRotationInFold(testSplitContainer, testScreenInfo);
    expect(testScreenInfo.rotation).assertEqual(270);
    teatManager.prepareSplitRotationInFold(null, testScreenInfo);
  });
}

function prepareSplitRotationInFoldTestAdd_4() {
  it('prepareSplitRotationInFoldTestAdd_4', Level.LEVEL0, (): void => {
    let testFloatContainer = containerSession;
    let globalScreenInfo = screenProperty;
    let testFloatScreenInfo = testFloatContainer.screenProperty;
    let teatAnimationManager = animationManager;
    globalScreenInfo.rotation = 0;
    testFloatScreenInfo.rotation = 0;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(0);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 0;
    testFloatScreenInfo.rotation = 45;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(0);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 0;
    testFloatScreenInfo.rotation = 90;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(0);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 0;
    testFloatScreenInfo.rotation = 120;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(0);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 0;
    testFloatScreenInfo.rotation = 180;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(0);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 0;
    testFloatScreenInfo.rotation = 210;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(0);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 0;
    testFloatScreenInfo.rotation = 270;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(0);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 0;
    testFloatScreenInfo.rotation = 300;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(0);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 0;
    testFloatScreenInfo.rotation = 360;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(0);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 0;
    testFloatScreenInfo.rotation = 361;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(0);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 45;
    testFloatScreenInfo.rotation = 0;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(0);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 90;
    testFloatScreenInfo.rotation = 0;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(0);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 120;
    testFloatScreenInfo.rotation = 0;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(0);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 180;
    testFloatScreenInfo.rotation = 0;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(0);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 210;
    testFloatScreenInfo.rotation = 0;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(0);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 270;
    testFloatScreenInfo.rotation = 0;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(0);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 300;
    testFloatScreenInfo.rotation = 0;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(0);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 360;
    testFloatScreenInfo.rotation = 0;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(0);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 361;
    testFloatScreenInfo.rotation = 0;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(0);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 90;
    testFloatScreenInfo.rotation = 90;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(90);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 90;
    testFloatScreenInfo.rotation = 180;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(90);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 90;
    testFloatScreenInfo.rotation = 270;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(90);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 90;
    testFloatScreenInfo.rotation = 360;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(90);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 180;
    testFloatScreenInfo.rotation = 180;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(180);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 180;
    testFloatScreenInfo.rotation = 270;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(180);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 180;
    testFloatScreenInfo.rotation = 360;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(180);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 270;
    testFloatScreenInfo.rotation = 270;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(270);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
    globalScreenInfo.rotation = 270;
    testFloatScreenInfo.rotation = 360;
    teatAnimationManager.prepareSplitRotationInFold(testFloatContainer, testFloatScreenInfo);
    expect(testFloatScreenInfo.rotation).assertEqual(270);
    teatAnimationManager.prepareSplitRotationInFold(null, testFloatScreenInfo);
  });
}
