/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
  SCBSceneMode,
  SCBScreenProperty,
  SCBScreenSession,
  SCBScreenSessionManager,
  SplitStyle,
} from '@ohos/windowscene';
import { RotationConstants } from '@ohos/commonconstants';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level, MockKit, when } from '@ohos/hypium'
import { ReflectionUtils } from './ReflectionUtils';
import { BorderRadiuses, borderRadiuses } from '@ohos.arkui.node';
import sceneSessionManager from '@ohos.sceneSessionManager';

const DEFAULT: number = 0;
let scbDividerParam: SCBDividerParam = new SCBDividerParam();
let screenProperty = new SCBScreenProperty();
let mocker: MockKit;
let screenSessionManager = SCBScreenSessionManager.getInstance();

export function SCBDividerParamTest() {

  describe('SCBDividerParamTest_001', (): void => {
    beforeAll((): void => {
      scbDividerParam.init();
      screenProperty.width = 2000;
      screenProperty.height = 2000;
      scbDividerParam = new SCBDividerParam();
      mocker = new MockKit();
    })

    it('initInMid_001', Level.LEVEL0, () => {
      scbDividerParam.initInMid();
      expect(scbDividerParam.dividerTranslateX).assertEqual(0);
      expect(scbDividerParam.dividerTranslateY).assertEqual(0);
      expect(scbDividerParam.scaleX).assertEqual(1);
      expect(scbDividerParam.scaleY).assertEqual(1);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertEqual(true);
      expect(scbDividerParam.isDividerDragging).assertEqual(false);
      expect(scbDividerParam.dividerOpacity).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.needCutOut).assertEqual(false);

    })

    it('initTest_001', Level.LEVEL0, () => {
      scbDividerParam.init();
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.primary.translateY).assertEqual(0);
      expect(scbDividerParam.primary.translateX).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.dividerAlpha).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
      expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
      expect(scbDividerParam.primary.opacity).assertEqual(1);
      expect(scbDividerParam.primary.blurScale).assertEqual(0);
      expect(scbDividerParam.secondary.opacity).assertEqual(1);
      expect(scbDividerParam.secondary.blurScale).assertEqual(0);
      expect(scbDividerParam.primary.rotateX).assertEqual(0);
      expect(scbDividerParam.primary.rotateY).assertEqual(0);
      expect(scbDividerParam.primary.rotateZ).assertEqual(0);
      expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
      expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
      expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
      expect(scbDividerParam.splitOrderIsNotReverse).assertEqual(true);
      expect(scbDividerParam.primary.posX).assertEqual('0%');
      expect(scbDividerParam.primary.posY).assertEqual('0%');
      expect(scbDividerParam.secondary.posX).assertEqual('0%');
      expect(scbDividerParam.secondary.posY).assertEqual('0%');
    })

    it("updateDynamicVariableTest_001", Level.LEVEL0, () => {
      let func_01: Function = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
      when(func_01)().afterReturn(true);
      scbDividerParam.updateDynamicVariable(1, 2, 100, 200);
      expect(scbDividerParam.primary.scaleY).assertEqual(1);
      expect(scbDividerParam.secondary.scaleY).assertEqual(2);
      expect(scbDividerParam.secondary.translateY).assertEqual(100);
      expect(scbDividerParam.primary.translateY).assertEqual(200);

      when(func_01)().afterReturn(false);
      scbDividerParam.updateDynamicVariable(1, 2, 100, 200);
      expect(scbDividerParam.primary.scaleX).assertEqual(1);
      expect(scbDividerParam.secondary.scaleX).assertEqual(2);
      expect(scbDividerParam.secondary.translateX).assertEqual(100);
      expect(scbDividerParam.primary.translateX).assertEqual(200);
      mocker.clear(func_01);
    })

    it('getPriPosYPctTest_001', Level.LEVEL0, () => {
      let scbDividerParam: SCBDividerParam = new SCBDividerParam();
      expect(scbDividerParam.getPriPosYPct()).assertEqual(0);
    })

    it('getSecPosXPctTest_001', Level.LEVEL0, () => {
      let scbDividerParam: SCBDividerParam = new SCBDividerParam();
      expect(scbDividerParam.getSecPosXPct()).assertEqual(0);
    })

    it('getSecPosYPctTest_001', Level.LEVEL0, () => {
      let scbDividerParam: SCBDividerParam = new SCBDividerParam();
      expect(scbDividerParam.getSecPosYPct()).assertEqual(0);
    })

    it('getPriPosXPctTest_001', Level.LEVEL0, () => {
      let scbDividerParam: SCBDividerParam = new SCBDividerParam();
      expect(scbDividerParam.getPriPosXPct()).assertEqual(0);
    })

    it('clearDynamicVariableTest_001', Level.LEVEL0, () => {
      let scbDividerParam: SCBDividerParam = new SCBDividerParam();
      scbDividerParam.clearDynamicVariable();
      expect(scbDividerParam.secondary.translateX).assertEqual(0);
      expect(scbDividerParam.secondary.translateY).assertEqual(0);
    })

    it('updateSplitContainerPositionTest_001', Level.LEVEL0, updateSplitContainerPositionTest_01)

    it('doOneStepTranslateTest_001', Level.LEVEL0, () => {
      let scbDividerParam: SCBDividerParam = new SCBDividerParam();
      let func_01: Function = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
      when(func_01)().afterReturn(true);
      let translate = 100;
      scbDividerParam.doOneStepTranslate(translate);
      expect(scbDividerParam.primary.translateY).assertEqual(translate);
      expect(scbDividerParam.dividerTranslateY).assertEqual(translate);

      when(func_01)().afterReturn(false);
      scbDividerParam.doOneStepTranslate(translate);
      expect(scbDividerParam.primary.translateX).assertEqual(translate);
      expect(scbDividerParam.dividerTranslateX).assertEqual(translate);
      mocker.clear(func_01);
    })

    it('doPrimaryTranslateTest_001', Level.LEVEL0, () => {
      let scbDividerParam: SCBDividerParam = new SCBDividerParam();
      let func_01: Function = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
      when(func_01)().afterReturn(true);
      // mock data translate of primaryScene
      let translate = 100;
      scbDividerParam.doPrimaryTranslate(translate);
      expect(scbDividerParam.primary.translateY).assertEqual(translate);

      when(func_01)().afterReturn(false);
      scbDividerParam.doPrimaryTranslate(translate);
      expect(scbDividerParam.primary.translateX).assertEqual(translate);
      mocker.clear(func_01);
    })

    it('setAngGetIsVerticalTest_001', Level.LEVEL0, () => {
      let scbDividerParam: SCBDividerParam = new SCBDividerParam();
      scbDividerParam.setIsVertical(true);
      expect(scbDividerParam.getIsVertical()).assertTrue();
      scbDividerParam.setIsVertical(false);
      expect(scbDividerParam.getIsVertical()).assertFalse();
    });

    it('doSecondSceneTranslateTest_001', Level.LEVEL0, () => {
      let scbDividerParam: SCBDividerParam = new SCBDividerParam();
      let func_01: Function = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
      when(func_01)().afterReturn(true);
      let translate = 100;
      scbDividerParam.doSecondSceneTranslate(translate);
      expect(scbDividerParam.secondary.translateY).assertEqual(translate);
      expect(scbDividerParam.dividerTranslateY).assertEqual(translate);

      when(func_01)().afterReturn(false);
      scbDividerParam.doSecondSceneTranslate(translate);
      expect(scbDividerParam.secondary.translateX).assertEqual(translate);
      expect(scbDividerParam.dividerTranslateX).assertEqual(translate);
      mocker.clear(func_01);
    })

    it('setAndGetSplitStyle_001', Level.LEVEL0, () => {
      let scbDividerParam: SCBDividerParam = new SCBDividerParam();
      scbDividerParam.setSplitStyle(SplitStyle.LEFT_AND_RIGHT_POS);
      expect(scbDividerParam.getSplitStyle()).assertEqual(SplitStyle.LEFT_AND_RIGHT_POS);
    });

    it('notifyAvoidAreaChangeTest_001', Level.LEVEL0, notifyAvoidAreaChangeTest_01);

    it('updateSplitStackSizeAndPositionBeforeRotationTest_001', Level.LEVEL0, updateSplitStackSizeAndPositionBeforeRotationTest_01);

    it('doOneStepVerticalTranslateTest_001', Level.LEVEL0, () => {
      SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()
      let func_01: Function = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
      when(func_01)().afterReturn(true);
      const translate = 10;
      scbDividerParam.clearDynamicVariable();
      scbDividerParam.doOneStepVerticalTranslate(translate);
      expect(scbDividerParam.primary.translateX).assertEqual(translate);
      expect(scbDividerParam.dividerTranslateX).assertEqual(translate);
      when(func_01)().afterReturn(false);
      scbDividerParam.clearDynamicVariable();
      scbDividerParam.doOneStepVerticalTranslate(translate);
      expect(scbDividerParam.primary.translateY).assertEqual(translate);
      expect(scbDividerParam.dividerTranslateY).assertEqual(translate);
      mocker.clear(func_01);
    });

    it('setBorderRadiusTest_001', Level.LEVEL0, setBorderRadiusTest_01);

    it('doPrimRotateTest_001', Level.LEVEL0, doPrimRotateTest_01);

    it('doSecRotateTest_001', Level.LEVEL0, doSecRotateTest_01);

    it('doContainerRotateTest_001', Level.LEVEL0, doContainerRotateTest_01);

    it('doSceneSessionScaleTest_001', Level.LEVEL0, doSceneSessionScaleTest_01);

    it('resetSceneSessionScaleTest_001', Level.LEVEL0, resetSceneSessionScaleTest_01);

    it('doSceneTouchScaleTest_001', Level.LEVEL0, doSceneTouchScaleTest_01);

    it('doDividerTranslateTest_001', Level.LEVEL0, doDividerTranslateTest_01);

    it('doSceneTouchTranslateTest_001', Level.LEVEL0, doSceneTouchTranslateTest_01);

    it('resetDividerPositionAndTransTest_001', Level.LEVEL0, resetDividerPositionAndTransTest_01);

    it('updateDividerParamTest_001', Level.LEVEL0, updateDividerParamTest_01);

    it('updateDividerParamWithRatioTest_001', Level.LEVEL0, updateDividerParamWithRatioTest_01);

    it('updateSplitStackPositionTest_001', Level.LEVEL0, updateSplitStackPositionTest_01);

    it('updateSplitStackPositionAndSizeTest_001', Level.LEVEL0, updateSplitStackPositionAndSizeTest_01);

    it('updateDividerPositionTest_001', Level.LEVEL0, updateDividerPositionTest_01);

    it('resetBlurOpacityTest_001', Level.LEVEL0, resetBlurOpacityTest_01);

    it('testSetDeviceRadius_001', Level.LEVEL0, testSetDeviceRadius_01);

    it('testIsUpDownSplit_001', Level.LEVEL0, testIsUpDownSplit_01);

    it('testInteractiveStateChangeCallback_001', Level.LEVEL0, testInteractiveStateChangeCallback_01);

    it('testMarkEvent_001', Level.LEVEL0, testMarkEvent_01);

    it('testSetOpacity_001', Level.LEVEL0, testSetOpacity_01);

    it('testSetZIndex_001', Level.LEVEL0, testSetZIndex_01);

    it('testFreeze_001', Level.LEVEL0, testFreeze_01);

    it('testGetAvoidPctIfNeeded_001', Level.LEVEL0, testGetAvoidPctIfNeeded_01);

    it('testNotifyPositionChange_001', Level.LEVEL0, testNotifyPositionChange_01);

    it('testAnimFunc_001', Level.LEVEL0, testAnimFunc_01);

    it('testAnimFuncWithSplitOrderIsNotReverse_001', Level.LEVEL0, testAnimFuncWithSplitOrderIsNotReverse_01);

    it('testGetSceneScaleX_001', Level.LEVEL0, testGetSceneScaleX_01);

    it('testSetShadowOptions_001', Level.LEVEL0, testSetShadowOptions_01);

    it('testCalOneStepDefaultTrans_001', Level.LEVEL0, testCalOneStepDefaultTrans_01);
    it('testSetOneStepDefaultTranslate_001', Level.LEVEL0, testSetOneStepDefaultTranslate_01);
    it('testSetOneStepDefaultPos_001', Level.LEVEL0, testSetOneStepDefaultPos_01);
  })
}

function testSetOneStepDefaultTranslate_01() {
  scbDividerParam.setOneStepDefaultTranslate(0, true);
  scbDividerParam.setOneStepDefaultTranslate(0, false);
  expect(scbDividerParam.primary.posX).assertEqual('0');
}

function testSetOneStepDefaultPos_01() {
  scbDividerParam.setOneStepDefaultPos(0, screenProperty);
  expect(scbDividerParam.primary.translateX).assertEqual(0);
}

function testGetAvoidPctIfNeeded_01() {
  let func_01: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
  when(func_01)().afterReturn(false);
  screenProperty.rotation = 90;
  mocker.clear(func_01);
}

function testCalOneStepDefaultTrans_01() {
  scbDividerParam.primSizePct = 0;
  scbDividerParam.secSizePct = 0;
  scbDividerParam.calOneStepDefaultTrans(screenProperty, false);
  let res = scbDividerParam.calOneStepDefaultTrans(screenProperty, true);
  expect(res).assertLarger(0);
}

function testAnimFuncWithSplitOrderIsNotReverse_01() {
  // isUpDownSplit
  let list: boolean[] = [true, false];
  let func_01: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
  when(func_01)().afterReturn(false);
  let borderRadius = borderRadiuses(0);
  // is up down split
  list.forEach((isVertical: boolean) => {
    scbDividerParam.setIsVertical(isVertical);
    testWithIsUpDown_01();
    // is Not reverse
    list.forEach((isNotReverse: boolean) => {
      scbDividerParam.splitOrderIsNotReverse = isNotReverse;
      // isNotReverse
      testWithSplitOrderIsNotReverse_01(list, borderRadius);
    })
  })
  mocker.clear(func_01);
}

function testWithSplitOrderIsNotReverse_01(list: boolean[], borderRadius: BorderRadiuses) {
  scbDividerParam.setBorderRadius(true);
  scbDividerParam.setBorderRadius(false);
  scbDividerParam.doSceneScale(0, 0);
  scbDividerParam.doSceneScale(0, 0);
  scbDividerParam.preSplitScale(0);
  scbDividerParam.doSceneTouchScale(0, 0, 0, 0);
  scbDividerParam.updateDividerParamWithDefaultRatio(screenProperty);
  scbDividerParam.updateDividerParamWithRatio(screenProperty);
  scbDividerParam.getFirstSceneTranslateX();
  scbDividerParam.getSecondSceneTranslateX();
  scbDividerParam.getFirstSceneTranslateY();
  scbDividerParam.getSecondSceneTranslateY();
  scbDividerParam.getFirstScenePct();
  scbDividerParam.setFirstScenePct(0);
  scbDividerParam.getSecondScenePct();
  scbDividerParam.setSecondScenePct(0);
  scbDividerParam.setFirstSceneScaleX(0);
  scbDividerParam.getFirstSceneScaleX();
  scbDividerParam.setFirstSceneScaleY(0);
  scbDividerParam.getFirstSceneScaleY();
  scbDividerParam.setSecondSceneScaleX(0);
  scbDividerParam.getSecondSceneScaleX();
  scbDividerParam.setSecondSceneScaleY(0);
  scbDividerParam.getSecondSceneScaleX();
  scbDividerParam.reverseDividerTrans(0, 0);
  scbDividerParam.updateSplitStackSize();
  let newScreenProperty = new SCBScreenProperty();
  scbDividerParam.restoreToDefaultRatio(newScreenProperty);
  list.forEach((isNeedCutOut: boolean) => {
    scbDividerParam.needCutOut = isNeedCutOut;
    // reversePrimaryTrans
    scbDividerParam.reverseSecondaryTrans(0, 0);
    scbDividerParam.restoreToDefaultRatio(screenProperty);
  })
  // test is primary flag
  list.forEach((primary: boolean) => {
    scbDividerParam.reverseSplitSceneBorderRadius(primary);
    scbDividerParam.setSceneScale(0, 0, primary);
    scbDividerParam.setScenePctPosition(0, 0, primary);
    scbDividerParam.setScenePctSize(0, 0, primary);
    scbDividerParam.setSceneBorderRadius(borderRadius, primary);
    scbDividerParam.getScenePositionX(primary, 0);
    scbDividerParam.getScenePositionY(primary, 0);
    scbDividerParam.getSceneWidth(primary, 0);
    scbDividerParam.getSceneHeight(primary, 0);
    scbDividerParam.getSceneScaleY(primary);
    testWithDifferentMode_01();
  });
}

function testWithIsUpDown_01() {
  scbDividerParam.getDividerPctPositionX();
  scbDividerParam.getDividerPctPositionY();
  scbDividerParam.getDividerSameDirectionScreenLength(0, 0);
  scbDividerParam.getDividerVerticalDirectionScreenLength(0, 0);
}

function testWithDifferentMode_01() {
  scbDividerParam.getScenePctPositionX(SCBSceneMode.PRIMARY);
  scbDividerParam.getScenePctPositionX(SCBSceneMode.SECONDARY);
  scbDividerParam.getScenePctPositionY(SCBSceneMode.PRIMARY);
  scbDividerParam.getScenePctPositionY(SCBSceneMode.SECONDARY);
  scbDividerParam.getSceneTotalTranslateX(SCBSceneMode.PRIMARY);
  scbDividerParam.getSceneTotalTranslateX(SCBSceneMode.SECONDARY);
  scbDividerParam.getScenePctWidth(SCBSceneMode.PRIMARY);
  scbDividerParam.getScenePctWidth(SCBSceneMode.SECONDARY);
  scbDividerParam.getScenePctHeight(SCBSceneMode.PRIMARY);
  scbDividerParam.getScenePctHeight(SCBSceneMode.SECONDARY);
}

function testNotifyPositionChange_01() {
  let key: number = 1;
  let callback = () => {};
  scbDividerParam.registerPositionChangeCallback(key, callback);
  scbDividerParam.setNeedNotifyPositionChange(true);
  scbDividerParam.notifyPositionChange();
  scbDividerParam.setNeedNotifyPositionChange(false);
  scbDividerParam.notifyPositionChange();
  scbDividerParam.unregisterPositionChangeCallback(key);
}

function testAnimFunc_01() {
  scbDividerParam.clearPrimaryDynamicVariable();
  scbDividerParam.applyDevicesRadius(0, true);
  scbDividerParam.resetSplitStackSize();
  scbDividerParam.setSecondaryTrans(0, 0);
  scbDividerParam.setPrimaryTrans(0, 0);
  scbDividerParam.setSecondaryScale(0, 0);
  scbDividerParam.setPrimaryScale(0, 0);
  scbDividerParam.setSecondaryScaleCenter(0, 0);
  scbDividerParam.setPrimaryScaleCenter(0, 0);
  scbDividerParam.setDividerTrans(0, 0);
  scbDividerParam.resetContainerRotate();
  scbDividerParam.primSetDeviceBorderRadius();
}

function testFreeze_01() {
  let str: string = "fake reason";
  scbDividerParam.freezeScene(str);
  scbDividerParam.releaseSceneFreeze(str);
}

function testSetOpacity_01() {
  scbDividerParam.setPrimaryOpacity(0);
  scbDividerParam.setSecondaryOpacity(0);
  scbDividerParam.setDividerOpacity(0);
  scbDividerParam.setBlackBackgroundOpacity(0);
}

function testSetZIndex_01() {
  scbDividerParam.setPrimaryZIndex(0);
  scbDividerParam.setSecondaryZIndex(0);
}

function testInteractiveStateChangeCallback_01() {
  let callback = (state: boolean) => {}
  scbDividerParam.registerInteractiveStateChangeCallback(callback);
  scbDividerParam.notifyInteractiveStateChange(true);
  scbDividerParam.unregisterInteractiveStateChangeCallback();
  scbDividerParam.notifyInteractiveStateChange(false);
}

function updateSplitContainerPositionTest_01() {
  let mockFunc: Function = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
  const testFunction = (isUpDownSplit: boolean, splitOrderIsNotReverse: boolean) => {
    when(mockFunc)().afterReturn(isUpDownSplit);
    scbDividerParam.splitOrderIsNotReverse = splitOrderIsNotReverse;
    scbDividerParam.updateSplitStackPosition(screenProperty);
    expect(scbDividerParam.primary.borderRadius.topLeft).assertEqual(0);
    expect(scbDividerParam.primary.borderRadius.topRight).assertEqual(0);
    expect(scbDividerParam.primary.borderRadius.bottomLeft).assertEqual(0);
    expect(scbDividerParam.primary.borderRadius.bottomRight).assertEqual(0);
    expect(scbDividerParam.secondary.borderRadius.topLeft).assertEqual(0);
    expect(scbDividerParam.secondary.borderRadius.topRight).assertEqual(0);
    expect(scbDividerParam.secondary.borderRadius.bottomLeft).assertEqual(0);
    expect(scbDividerParam.secondary.borderRadius.bottomRight).assertEqual(0);
  }
  test2BoolArgsFunctionInLoop(testFunction);
  mocker.clear(mockFunc);
}

function test2BoolArgsFunctionInLoop(func: Function) {
  [true, false].forEach((value0, index0) => {
    [true, false].forEach((value1, index1) => {
      func(value0, value1);
    })
  })
}

function notifyAvoidAreaChangeTest_01() {
  SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()
  let func_01: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
  let func_02: Function = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
  scbDividerParam.needCutOut = false;
  const STATUS_BAR_PCT = 0.2;
  const avoidPct = 0.15;
  scbDividerParam.statusBarPct = STATUS_BAR_PCT;
  scbDividerParam.notifyAvoidAreaChange(screenProperty);
  expect(scbDividerParam.needCutOut).assertFalse();
  scbDividerParam.needCutOut = true;
  let newScreenProperty = new SCBScreenProperty();
  scbDividerParam.notifyAvoidAreaChange(newScreenProperty);
  scbDividerParam.needCutOut = true;
  when(func_01)().afterReturn(true);
  when(func_02)().afterReturn(true);
  scbDividerParam.needCutOut = true;
  ReflectionUtils.setProperty(scbDividerParam, 'avoidXPct', avoidPct);
  scbDividerParam.notifyAvoidAreaChange(screenProperty);
  expect(scbDividerParam.getAvoidXPct()).assertEqual(0);
  when(func_02)().afterReturn(false);
  scbDividerParam.needCutOut = true;
  scbDividerParam.statusBarPct = STATUS_BAR_PCT;
  scbDividerParam.notifyAvoidAreaChange(screenProperty);
  expect(scbDividerParam.needCutOut).assertFalse();
  when(func_01)().afterReturn(false);
  [RotationConstants.ROTATION_0, RotationConstants.ROTATION_90, RotationConstants.ROTATION_270,
    RotationConstants.ROTATION_180, RotationConstants.ROTATION_360].forEach((value) => {
    scbDividerParam.needCutOut = true;
    screenProperty.rotation = value;
    ReflectionUtils.setProperty(scbDividerParam, 'avoidXPct', avoidPct);
    ReflectionUtils.setProperty(scbDividerParam, 'avoidYPct', avoidPct);
    scbDividerParam.notifyAvoidAreaChange(screenProperty);
    if (RotationConstants.ROTATION_270 === value) {
      expect(scbDividerParam.getAvoidYPct()).assertEqual(0);
    } else {
      expect(scbDividerParam.getAvoidXPct()).assertEqual(0);
    }
  })
  mocker.clear(func_01);
  mocker.clear(func_02);
}

function testMarkEvent_01() {
  scbDividerParam.markEventFromGesture();
}

function updateSplitStackSizeAndPositionBeforeRotationTest_01() {
  SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
  let func_01: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
  let func_02: Function = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
  scbDividerParam.needCutOut = false;
  scbDividerParam.updateSplitStackSizeAndPositionBeforeRotation(screenProperty);
  scbDividerParam.needCutOut = true;
  let newScreenProperty = new SCBScreenProperty();
  scbDividerParam.updateSplitStackSizeAndPositionBeforeRotation(newScreenProperty);
  scbDividerParam.needCutOut = true;
  when(func_01)().afterReturn(true);
  when(func_02)().afterReturn(true);
  scbDividerParam.needCutOut = true;
  scbDividerParam.updateSplitStackSizeAndPositionBeforeRotation(screenProperty);
  when(func_02)().afterReturn(false);
  scbDividerParam.needCutOut = true;
  scbDividerParam.updateSplitStackSizeAndPositionBeforeRotation(screenProperty);
  when(func_01)().afterReturn(false);
  [RotationConstants.ROTATION_0, RotationConstants.ROTATION_90, RotationConstants.ROTATION_270,
    RotationConstants.ROTATION_180, RotationConstants.ROTATION_360].forEach((value) => {
    scbDividerParam.needCutOut = true;
    screenProperty.rotation = value;
    scbDividerParam.updateSplitStackSizeAndPositionBeforeRotation(screenProperty);
  })
  mocker.clear(func_01);
  mocker.clear(func_02);
}

function testSetDeviceRadius_01() {
  scbDividerParam.deviceRadius = 0;
  expect(0).assertEqual(scbDividerParam.deviceRadius);
}

function setBorderRadiusTest_01() {
  scbDividerParam.needCutOut = false;
  scbDividerParam.setBorderRadius();
  expect(scbDividerParam.needClip).assertTrue();
  scbDividerParam.needCutOut = true;
  scbDividerParam.setBorderRadius();
  expect(scbDividerParam.needClip).assertTrue();
  let func_01: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
  let func_02: Function = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
  const testFunction = (isUpDownSplit: boolean, splitOrderIsNotReverse: boolean) => {
    scbDividerParam.needClip = false;
    when(func_01)().afterReturn(isUpDownSplit);
    when(func_02)().afterReturn(splitOrderIsNotReverse);
    scbDividerParam.setBorderRadius(true);
    expect(scbDividerParam.needClip).assertTrue();
  }
  scbDividerParam.setBorderRadius(false);
  expect(scbDividerParam.needClip).assertTrue();
  test2BoolArgsFunctionInLoop(testFunction);
  const avoidPct = 0.1;
  ReflectionUtils.setProperty(scbDividerParam, 'avoidXPct', 0);
  ReflectionUtils.setProperty(scbDividerParam, 'avoidYPct', avoidPct);
  scbDividerParam.setBorderRadius(true);
  expect(scbDividerParam.needClip).assertTrue();
  ReflectionUtils.setProperty(scbDividerParam, 'avoidXPct', avoidPct);
  ReflectionUtils.setProperty(scbDividerParam, 'avoidYPct', 0);
  scbDividerParam.setBorderRadius(true);
  expect(scbDividerParam.needClip).assertTrue();
  ReflectionUtils.setProperty(scbDividerParam, 'avoidXPct', 0);
  ReflectionUtils.setProperty(scbDividerParam, 'avoidYPct', 0);
  scbDividerParam.setBorderRadius(true);
  expect(scbDividerParam.needClip).assertTrue();
  scbDividerParam.statusBarPct = 0.1;
  scbDividerParam.setBorderRadius(true);
  expect(scbDividerParam.needClip).assertTrue();
  mocker.clear(func_01);
  mocker.clear(func_02);
}

function doSecRotateTest_01() {
  let func_01: Function = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
  const testFunction = (isUpDownSplit: boolean, splitOrderIsNotReverse: boolean) => {
    const angle = 10;
    when(func_01)().afterReturn(isUpDownSplit);
    scbDividerParam.splitOrderIsNotReverse = splitOrderIsNotReverse;
    scbDividerParam.secondary.rotateAngle = 0;
    scbDividerParam.doSecRotate(angle);
    if (isUpDownSplit) {
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(angle);
    } else {
      expect(scbDividerParam.secondary.rotateAngle).assertEqual(-angle);
    }
  }
  scbDividerParam.setBorderRadius(false);
  expect(scbDividerParam.needClip).assertTrue();
  test2BoolArgsFunctionInLoop(testFunction);
  mocker.clear(func_01);
}

function doPrimRotateTest_01() {
  let func_01: Function = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
  const angle = 10;
  const testFunction = (isUpDownSplit: boolean, splitOrderIsNotReverse: boolean) => {
    scbDividerParam.primary.rotateAngle = 0;
    when(func_01)().afterReturn(isUpDownSplit);
    scbDividerParam.splitOrderIsNotReverse = splitOrderIsNotReverse;
    scbDividerParam.doPrimRotate(angle);
    if (isUpDownSplit) {
      expect(scbDividerParam.primary.rotateAngle).assertEqual(angle);
    } else {
      expect(scbDividerParam.primary.rotateAngle).assertEqual(-angle);
    }
  }
  scbDividerParam.needClip = false;
  scbDividerParam.setBorderRadius(false);
  expect(scbDividerParam.needClip).assertTrue();
  test2BoolArgsFunctionInLoop(testFunction);
  mocker.clear(func_01);
}

function doSceneSessionScaleTest_01() {
  let func_01: Function = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
  const testFunction = (isUpDownSplit: boolean, splitOrderIsNotReverse: boolean) => {
    when(func_01)().afterReturn(isUpDownSplit);
    scbDividerParam.splitOrderIsNotReverse = splitOrderIsNotReverse;
    const scale = 0.1;
    scbDividerParam.doSceneSessionScale(scale, scale);
    if (isUpDownSplit) {
      expect(scbDividerParam.primary.sessionScaleCenterX).assertEqual('50%');
      expect(scbDividerParam.primary.sessionScaleCenterY).assertEqual('0%');
      expect(scbDividerParam.secondary.sessionScaleCenterX).assertEqual('50%');
      expect(scbDividerParam.secondary.sessionScaleCenterY).assertEqual('0%');
    } else {
      expect(scbDividerParam.primary.sessionScaleCenterX).assertEqual('0%');
      expect(scbDividerParam.primary.sessionScaleCenterY).assertEqual('50%');
      expect(scbDividerParam.secondary.sessionScaleCenterX).assertEqual('0%');
      expect(scbDividerParam.secondary.sessionScaleCenterY).assertEqual('50%');
    }
  }
  scbDividerParam.setBorderRadius(false);
  expect(scbDividerParam.needClip).assertTrue();
  test2BoolArgsFunctionInLoop(testFunction);
  mocker.clear(func_01);
}

function doContainerRotateTest_01() {
  const testFunction = (isLeftRotate: boolean, isUpDownSplit: boolean,) => {
    const angle = 10;
    scbDividerParam.containerRotateAngle = 0;
    scbDividerParam.doContainerRotate(angle, isLeftRotate, isUpDownSplit);
    if (isUpDownSplit === isLeftRotate) {
      expect(scbDividerParam.containerRotateAngle).assertEqual(angle);
    } else {
      expect(scbDividerParam.containerRotateAngle).assertEqual(-angle);
    }
  }
  scbDividerParam.setBorderRadius(false);
  expect(scbDividerParam.needClip).assertTrue();
  test2BoolArgsFunctionInLoop(testFunction);
}

function resetSceneSessionScaleTest_01() {
  const primarySessionScaleCenterX = 1;
  let func_01: Function = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
  scbDividerParam.primary.sessionScaleCenterX = primarySessionScaleCenterX;
  when(func_01)().afterReturn(true);
  scbDividerParam.resetSceneSessionScale();
  expect(scbDividerParam.primary.sessionScaleCenterX).assertEqual(0);
  scbDividerParam.primary.sessionScaleCenterX = primarySessionScaleCenterX;
  when(func_01)().afterReturn(false);
  scbDividerParam.resetSceneSessionScale();
  expect(scbDividerParam.primary.sessionScaleCenterX).assertEqual(0)
  mocker.clear(func_01);
}

function doSceneTouchTranslateTest_01() {
  let func_01: Function = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
  const testFunction = (isUpDownSplit: boolean, splitOrderIsNotReverse: boolean) => {
    when(func_01)().afterReturn(isUpDownSplit);
    scbDividerParam.splitOrderIsNotReverse = splitOrderIsNotReverse;
    const translate = 10;
    scbDividerParam.doSceneTouchTranslate(translate);
    if (isUpDownSplit) {
      expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
    } else {
      expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
    }
  }
  test2BoolArgsFunctionInLoop(testFunction);
  mocker.clear(func_01);
}

function doSceneTouchScaleTest_01() {
  const scale = 0.5;
  let func_01: Function = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
  when(func_01)().afterReturn(true);
  scbDividerParam.primary.scaleX = 0;
  scbDividerParam.primary.scaleY = 0;
  scbDividerParam.doSceneTouchScale(scale, scale, scale, scale);
  expect(scbDividerParam.primary.scaleX).assertEqual(scale);
  expect(scbDividerParam.primary.scaleY).assertEqual(scale);
  when(func_01)().afterReturn(false);
  scbDividerParam.primary.scaleX = 0;
  scbDividerParam.primary.scaleY = 0;
  scbDividerParam.doSceneTouchScale(scale, scale, scale, scale);
  expect(scbDividerParam.primary.scaleX).assertEqual(scale);
  expect(scbDividerParam.primary.scaleY).assertEqual(scale);
  mocker.clear(func_01);
}

function doDividerTranslateTest_01() {
  const dividerTranslate = 10;
  let func_01: Function = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
  when(func_01)().afterReturn(true);
  scbDividerParam.dividerTranslateY = dividerTranslate;
  scbDividerParam.doDividerTranslate(dividerTranslate);
  expect(scbDividerParam.dividerTranslateY).assertEqual(dividerTranslate);
  when(func_01)().afterReturn(false);
  scbDividerParam.dividerTranslateX = dividerTranslate;
  scbDividerParam.doDividerTranslate(dividerTranslate);
  expect(scbDividerParam.dividerTranslateX).assertEqual(dividerTranslate);
  mocker.clear(func_01);
}

function updateDividerParamTest_01() {
  testUpdateSceneSizeFunction(() => {
    scbDividerParam.updateDividerParam(screenProperty);
  });
}

function updateDividerPositionTest_01() {
  let func_01: Function = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
  const testFunction = (isUpDownSplit: boolean, splitOrderIsNotReverse: boolean) => {
    scbDividerParam.init();
    when(func_01)().afterReturn(isUpDownSplit);
    scbDividerParam.splitOrderIsNotReverse = splitOrderIsNotReverse;
    scbDividerParam.positionX = '0%';
    scbDividerParam.positionY = '0%';
    scbDividerParam.primSizePct = 0.4;
    scbDividerParam.secSizePct = 0.4;
    scbDividerParam.updateDividerPosition();
    if (isUpDownSplit) {
      expect(parseFloat(scbDividerParam.positionY)).assertLarger(0);
    } else {
      expect(parseFloat(scbDividerParam.positionX)).assertLarger(0);
    }
  }
  test2BoolArgsFunctionInLoop(testFunction);
  mocker.clear(func_01);
}

function testUpdateSceneSizeFunction(func: Function) {
  scbDividerParam.init();
  scbDividerParam.primSizePct = 0.4;
  scbDividerParam.secSizePct = 0.4;
  scbDividerParam.primary.width = '0%';
  scbDividerParam.primary.height = '0%';
  scbDividerParam.secondary.width = '0%';
  scbDividerParam.secondary.height = '0%';
  func();
  expect(Math.abs(parseFloat(scbDividerParam.primary.width))).assertLarger(0);
  expect(Math.abs(parseFloat(scbDividerParam.primary.height))).assertLarger(0);
  expect(Math.abs(parseFloat(scbDividerParam.secondary.width))).assertLarger(0);
  expect(Math.abs(parseFloat(scbDividerParam.secondary.height))).assertLarger(0);
}

function updateSplitStackPositionAndSizeTest_01() {
  let func_01: Function = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
  const testFunction = (isUpDownSplit: boolean, needCutOut: boolean) => {
    testUpdateSceneSizeFunction(() => {
      when(func_01)().afterReturn(isUpDownSplit);
      scbDividerParam.needCutOut = needCutOut;
      scbDividerParam.needClip = false;
      scbDividerParam.updateDividerParamWithRatio(screenProperty);
      expect(scbDividerParam.needClip).assertTrue();
      scbDividerParam.updateSplitStackPositionAndSize(screenProperty);
    });
  }
  mocker.clear(func_01);
  test2BoolArgsFunctionInLoop(testFunction);
}

function resetDividerPositionAndTransTest_01() {
  const translate = 10;
  scbDividerParam.dividerTranslateX = translate;
  scbDividerParam.dividerTranslateY = translate;
  scbDividerParam.resetDividerPositionAndTrans();
  expect(scbDividerParam.dividerTranslateX).assertEqual(0);
  expect(scbDividerParam.dividerTranslateY).assertEqual(0);
}

function updateDividerParamWithRatioTest_01() {
  let func_01: Function = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
  const testFunction = (isUpDownSplit: boolean, needCutOut: boolean) => {
    testUpdateSceneSizeFunction(() => {
      when(func_01)().afterReturn(isUpDownSplit);
      scbDividerParam.needCutOut = needCutOut;
      scbDividerParam.needClip = false;
      scbDividerParam.updateDividerParamWithRatio(screenProperty);
      expect(scbDividerParam.needClip).assertTrue();
    });
  }
  test2BoolArgsFunctionInLoop(testFunction);
  mocker.clear(func_01);
}

function updateSplitStackPositionTest_01() {
  const testFunction = (isUpDownSplit: boolean, splitOrderIsNotReverse: boolean) => {
    let func_01: Function = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
    scbDividerParam.init();
    scbDividerParam.needCutOut = true;
    scbDividerParam.primSizePct = 0.4;
    scbDividerParam.secSizePct = 0.4;
    scbDividerParam.statusBarPct = 0.05;
    const avoidPct = 0.05;
    scbDividerParam.primary.posX = '0%';
    scbDividerParam.primary.posY = '0%';
    scbDividerParam.secondary.posX = '0%';
    scbDividerParam.secondary.posY = '0%';
    when(func_01)().afterReturn(isUpDownSplit);
    scbDividerParam.splitOrderIsNotReverse = splitOrderIsNotReverse;
    ReflectionUtils.setProperty(scbDividerParam, 'avoidXPct', avoidPct);
    ReflectionUtils.setProperty(scbDividerParam, 'avoidYPct', avoidPct);
    scbDividerParam.updateSplitStackPosition(screenProperty);
    if (isUpDownSplit) {
      expect(parseFloat(scbDividerParam.primary.posY)).assertLarger(0);
      expect(parseFloat(scbDividerParam.secondary.posY)).assertLarger(0);
    } else {
      expect(parseFloat(scbDividerParam.primary.posX)).assertLarger(0);
      expect(parseFloat(scbDividerParam.secondary.posX)).assertLarger(0);
    }
    mocker.clear(func_01);
  }
  test2BoolArgsFunctionInLoop(testFunction);
}

function resetBlurOpacityTest_01() {
  scbDividerParam.primary.blurScale = 1;
  scbDividerParam.secondary.blurScale = 1;
  scbDividerParam.resetBlurOpacity();
  expect(scbDividerParam.primary.blurScale).assertEqual(0);
  expect(scbDividerParam.secondary.blurScale).assertEqual(0);
}

function testSetShadowOptions_01 () {
  scbDividerParam.splitOrderIsNotReverse = true;
  scbDividerParam.setShadowOptions({ radius: 112 }, true);
  scbDividerParam.setShadowOptions({ radius: 102 }, false);
  expect(scbDividerParam.primary.shadowOptions.radius).assertEqual(112);
  expect(scbDividerParam.secondary.shadowOptions.radius).assertEqual(102);
  scbDividerParam.splitOrderIsNotReverse = false;
  scbDividerParam.setShadowOptions({ radius: 212 }, true);
  scbDividerParam.setShadowOptions({ radius: 202 }, false);
  expect(scbDividerParam.primary.shadowOptions.radius).assertEqual(202);
  expect(scbDividerParam.secondary.shadowOptions.radius).assertEqual(212);
}

function testGetSceneScaleX_01 () {
  scbDividerParam.primary.scaleX = 0;
  scbDividerParam.secondary.scaleX = 1;
  scbDividerParam.splitOrderIsNotReverse = true;
  expect(scbDividerParam.getSceneScaleX(true)).assertEqual(0);
  expect(scbDividerParam.getSceneScaleX(false)).assertEqual(1);
  scbDividerParam.splitOrderIsNotReverse = false;
  expect(scbDividerParam.getSceneScaleX(true)).assertEqual(1);
  expect(scbDividerParam.getSceneScaleX(false)).assertEqual(0);
}

it('init_test_01', Level.LEVEL0, () => {
  let scbDividerParam: SCBDividerParam | null = new SCBDividerParam();
  scbDividerParam.init();
  expect(scbDividerParam.primary.translateX).assertEqual(0);
  expect(scbDividerParam.primary.translateY).assertEqual(0);
  expect(scbDividerParam.primary.translateX).assertEqual(0);
  expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
  expect(scbDividerParam.dividerAlpha).assertEqual(0);
  expect(scbDividerParam.primary.touchTranslateX).assertEqual(0);
  expect(scbDividerParam.primary.touchTranslateY).assertEqual(0);
  expect(scbDividerParam.secondary.touchTranslateX).assertEqual(0);
  expect(scbDividerParam.secondary.touchTranslateY).assertEqual(0);
  expect(scbDividerParam.primary.opacity).assertEqual(1);
  expect(scbDividerParam.primary.blurScale).assertEqual(0);
  expect(scbDividerParam.secondary.opacity).assertEqual(1);
  expect(scbDividerParam.secondary.blurScale).assertEqual(0);
  expect(scbDividerParam.primary.rotateX).assertEqual(0);
  expect(scbDividerParam.primary.rotateY).assertEqual(0);
  expect(scbDividerParam.primary.rotateZ).assertEqual(0);
  expect(scbDividerParam.primary.rotateAngle).assertEqual(0);
  expect(scbDividerParam.primary.rotateCenterX).assertEqual(0);
  expect(scbDividerParam.primary.rotateCenterY).assertEqual(0);
  expect(scbDividerParam.secondary.rotateX).assertEqual(0);
  expect(scbDividerParam.secondary.rotateX).assertEqual(0);
  expect(scbDividerParam.secondary.rotateZ).assertEqual(0);
  expect(scbDividerParam.secondary.rotateAngle).assertEqual(0);
  expect(scbDividerParam.secondary.rotateCenterX).assertEqual(0);
  expect(scbDividerParam.secondary.rotateCenterY).assertEqual(0);
  expect(scbDividerParam.blackBackgroundOpacity).assertEqual(0);
  expect(scbDividerParam.splitOrderIsNotReverse).assertEqual(true);
  expect(scbDividerParam.primary.posX).assertEqual('0%');
  expect(scbDividerParam.primary.posY).assertEqual('0%');
  expect(scbDividerParam.secondary.posX).assertEqual('0%');
  expect(scbDividerParam.secondary.posY).assertEqual('0%');
  expect(scbDividerParam.primary.blurRadius).assertEqual(-1);
  expect(scbDividerParam.secondary.blurRadius).assertEqual(-1);
  scbDividerParam = null;
})

it('init_test_02', Level.LEVEL0, () => {
  let scbDividerParam: SCBDividerParam | null = new SCBDividerParam();
  scbDividerParam.init();
  expect(scbDividerParam.primary.translateX === 0).assertTrue();
  expect(scbDividerParam.primary.translateY === 0).assertTrue();
  expect(scbDividerParam.primary.translateX === 0).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity === 0).assertTrue();
  expect(scbDividerParam.dividerAlpha === 0).assertTrue();
  expect(scbDividerParam.primary.touchTranslateX === 0).assertTrue();
  expect(scbDividerParam.primary.touchTranslateY === 0).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateX === 0).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateY === 0).assertTrue();
  expect(scbDividerParam.primary.opacity === 1).assertTrue();
  expect(scbDividerParam.primary.blurScale === 0).assertTrue();
  expect(scbDividerParam.secondary.opacity === 1).assertTrue();
  expect(scbDividerParam.secondary.blurScale === 0).assertTrue();
  expect(scbDividerParam.primary.rotateX === 0).assertTrue();
  expect(scbDividerParam.primary.rotateY === 0).assertTrue();
  expect(scbDividerParam.primary.rotateZ === 0).assertTrue();
  expect(scbDividerParam.primary.rotateAngle === 0).assertTrue();
  expect(scbDividerParam.primary.rotateCenterX === 0).assertTrue();
  expect(scbDividerParam.primary.rotateCenterY === 0).assertTrue();
  expect(scbDividerParam.secondary.rotateX === 0).assertTrue();
  expect(scbDividerParam.secondary.rotateZ === 0).assertTrue();
  expect(scbDividerParam.secondary.rotateAngle === 0).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterX === 0).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterY === 0).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity === 0).assertTrue();
  expect(scbDividerParam.splitOrderIsNotReverse === true).assertTrue();
  expect(scbDividerParam.primary.posX === '0%').assertTrue();
  expect(scbDividerParam.primary.posY === '0%').assertTrue();
  expect(scbDividerParam.secondary.posX === '0%').assertTrue();
  expect(scbDividerParam.secondary.posY === '0%').assertTrue();
  expect(scbDividerParam.primary.blurRadius === -1).assertTrue();
  expect(scbDividerParam.secondary.blurRadius === -1).assertTrue();
  scbDividerParam = null;
})

it('init_test_03', Level.LEVEL0, () => {
  let scbDividerParam: SCBDividerParam | null = new SCBDividerParam();
  scbDividerParam.init();
  expect(scbDividerParam.primary.translateX !== -1).assertTrue();
  expect(scbDividerParam.primary.translateY !== -1).assertTrue();
  expect(scbDividerParam.primary.translateX !== -1).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity !== -1).assertTrue();
  expect(scbDividerParam.dividerAlpha !== -1).assertTrue();
  expect(scbDividerParam.primary.touchTranslateX !== -1).assertTrue();
  expect(scbDividerParam.primary.touchTranslateY !== -1).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateX !== -1).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateY !== -1).assertTrue();
  expect(scbDividerParam.primary.opacity !== -1).assertTrue();
  expect(scbDividerParam.primary.blurScale !== -1).assertTrue();
  expect(scbDividerParam.secondary.opacity !== -1).assertTrue();
  expect(scbDividerParam.secondary.blurScale !== -1).assertTrue();
  expect(scbDividerParam.primary.rotateX !== -1).assertTrue();
  expect(scbDividerParam.primary.rotateY !== -1).assertTrue();
  expect(scbDividerParam.primary.rotateZ !== -1).assertTrue();
  expect(scbDividerParam.primary.rotateAngle !== -1).assertTrue();
  expect(scbDividerParam.primary.rotateCenterX !== -1).assertTrue();
  expect(scbDividerParam.primary.rotateCenterY !== -1).assertTrue();
  expect(scbDividerParam.secondary.rotateX !== -1).assertTrue();
  expect(scbDividerParam.secondary.rotateZ !== -1).assertTrue();
  expect(scbDividerParam.secondary.rotateAngle !== -1).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterX !== -1).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterY !== -1).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity !== -1).assertTrue();
  expect(scbDividerParam.splitOrderIsNotReverse !== false).assertTrue();
  expect(scbDividerParam.primary.posX !== '-1%').assertTrue();
  expect(scbDividerParam.primary.posY !== '-1%').assertTrue();
  expect(scbDividerParam.secondary.posX !== '-1%').assertTrue();
  expect(scbDividerParam.secondary.posY !== '-1%').assertTrue();
  expect(scbDividerParam.primary.blurRadius !== -2).assertTrue();
  expect(scbDividerParam.secondary.blurRadius !== -2).assertTrue();
  scbDividerParam = null;
})

it('init_test_04', Level.LEVEL0, () => {
  let scbDividerParam: SCBDividerParam | null = new SCBDividerParam();
  scbDividerParam.init();
  expect(scbDividerParam.primary.translateX !== -2).assertTrue();
  expect(scbDividerParam.primary.translateY !== -3).assertTrue();
  expect(scbDividerParam.primary.translateX !== -4).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity !== -5).assertTrue();
  expect(scbDividerParam.dividerAlpha !== -6).assertTrue();
  expect(scbDividerParam.primary.touchTranslateX !== -7).assertTrue();
  expect(scbDividerParam.primary.touchTranslateY !== -8).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateX !== -9).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateY !== -10).assertTrue();
  expect(scbDividerParam.primary.opacity !== -11).assertTrue();
  expect(scbDividerParam.primary.blurScale !== -12).assertTrue();
  expect(scbDividerParam.secondary.opacity !== -13).assertTrue();
  expect(scbDividerParam.secondary.blurScale !== -14).assertTrue();
  expect(scbDividerParam.primary.rotateX !== -15).assertTrue();
  expect(scbDividerParam.primary.rotateY !== -16).assertTrue();
  expect(scbDividerParam.primary.rotateZ !== -17).assertTrue();
  expect(scbDividerParam.primary.rotateAngle !== -18).assertTrue();
  expect(scbDividerParam.primary.rotateCenterX !== -19).assertTrue();
  expect(scbDividerParam.primary.rotateCenterY !== -20).assertTrue();
  expect(scbDividerParam.secondary.rotateX !== -21).assertTrue();
  expect(scbDividerParam.secondary.rotateZ !== -22).assertTrue();
  expect(scbDividerParam.secondary.rotateAngle !== -23).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterX !== -24).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterY !== -25).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity !== -26).assertTrue();
  expect(scbDividerParam.splitOrderIsNotReverse !== false).assertTrue();
  expect(scbDividerParam.primary.posX !== '-27%').assertTrue();
  expect(scbDividerParam.primary.posY !== '-28%').assertTrue();
  expect(scbDividerParam.secondary.posX !== '-29%').assertTrue();
  expect(scbDividerParam.secondary.posY !== '-30%').assertTrue();
  expect(scbDividerParam.primary.blurRadius !== -31).assertTrue();
  expect(scbDividerParam.secondary.blurRadius !== -32).assertTrue();
  scbDividerParam = null;
})

it('init_test_05', Level.LEVEL0, () => {
  let scbDividerParam: SCBDividerParam | null = new SCBDividerParam();
  scbDividerParam.init();
  expect(scbDividerParam.primary.translateX !== -2).assertTrue();
  expect(scbDividerParam.primary.translateY !== -3).assertTrue();
  expect(scbDividerParam.primary.translateX !== -4).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity !== -5).assertTrue();
  expect(scbDividerParam.dividerAlpha !== -6).assertTrue();
  expect(scbDividerParam.primary.touchTranslateX !== -7).assertTrue();
  expect(scbDividerParam.primary.touchTranslateY !== -8).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateX !== -9).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateY !== -10).assertTrue();
  expect(scbDividerParam.primary.opacity !== -11).assertTrue();
  expect(scbDividerParam.primary.blurScale !== -12).assertTrue();
  expect(scbDividerParam.secondary.opacity !== -13).assertTrue();
  expect(scbDividerParam.secondary.blurScale !== -14).assertTrue();
  expect(scbDividerParam.primary.rotateX !== -15).assertTrue();
  expect(scbDividerParam.primary.rotateY !== -16).assertTrue();
  expect(scbDividerParam.primary.rotateZ !== -17).assertTrue();
  expect(scbDividerParam.primary.rotateAngle !== -18).assertTrue();
  expect(scbDividerParam.primary.rotateCenterX !== -19).assertTrue();
  expect(scbDividerParam.primary.rotateCenterY !== -20).assertTrue();
  expect(scbDividerParam.secondary.rotateX !== -21).assertTrue();
  expect(scbDividerParam.secondary.rotateZ !== -22).assertTrue();
  expect(scbDividerParam.secondary.rotateAngle !== -23).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterX !== -24).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterY !== -25).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity !== -26).assertTrue();
  expect(scbDividerParam.splitOrderIsNotReverse !== false).assertTrue();
  expect(scbDividerParam.primary.posX !== '-27%').assertTrue();
  expect(scbDividerParam.primary.posY !== '-28%').assertTrue();
  expect(scbDividerParam.secondary.posX !== '-29%').assertTrue();
  expect(scbDividerParam.secondary.posY !== '-30%').assertTrue();
  expect(scbDividerParam.primary.blurRadius !== -31).assertTrue();
  expect(scbDividerParam.secondary.blurRadius !== -32).assertTrue();
  scbDividerParam = null;
})

it('init_test_06', Level.LEVEL0, () => {
  let scbDividerParam: SCBDividerParam | null = new SCBDividerParam();
  scbDividerParam.init();
  expect(scbDividerParam.primary.translateX !== -33).assertTrue();
  expect(scbDividerParam.primary.translateY !== -34).assertTrue();
  expect(scbDividerParam.primary.translateX !== -35).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity !== -36).assertTrue();
  expect(scbDividerParam.dividerAlpha !== -37).assertTrue();
  expect(scbDividerParam.primary.touchTranslateX !== -38).assertTrue();
  expect(scbDividerParam.primary.touchTranslateY !== -39).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateX !== -40).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateY !== -41).assertTrue();
  expect(scbDividerParam.primary.opacity !== -42).assertTrue();
  expect(scbDividerParam.primary.blurScale !== -43).assertTrue();
  expect(scbDividerParam.secondary.opacity !== -44).assertTrue();
  expect(scbDividerParam.secondary.blurScale !== -45).assertTrue();
  expect(scbDividerParam.primary.rotateX !== -46).assertTrue();
  expect(scbDividerParam.primary.rotateY !== -47).assertTrue();
  expect(scbDividerParam.primary.rotateZ !== -48).assertTrue();
  expect(scbDividerParam.primary.rotateAngle !== -49).assertTrue();
  expect(scbDividerParam.primary.rotateCenterX !== -50).assertTrue();
  expect(scbDividerParam.primary.rotateCenterY !== -51).assertTrue();
  expect(scbDividerParam.secondary.rotateX !== -52).assertTrue();
  expect(scbDividerParam.secondary.rotateZ !== -53).assertTrue();
  expect(scbDividerParam.secondary.rotateAngle !== -54).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterX !== -55).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterY !== -56).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity !== -57).assertTrue();
  expect(scbDividerParam.splitOrderIsNotReverse !== false).assertTrue();
  expect(scbDividerParam.primary.posX !== '-58%').assertTrue();
  expect(scbDividerParam.primary.posY !== '-59%').assertTrue();
  expect(scbDividerParam.secondary.posX !== '-60%').assertTrue();
  expect(scbDividerParam.secondary.posY !== '-61%').assertTrue();
  expect(scbDividerParam.primary.blurRadius !== -62).assertTrue();
  expect(scbDividerParam.secondary.blurRadius !== -63).assertTrue();
  scbDividerParam = null;
})

it('init_test_07', Level.LEVEL0, () => {
  let scbDividerParam: SCBDividerParam | null = new SCBDividerParam();
  scbDividerParam.init();
  expect(scbDividerParam.primary.translateX !== -64).assertTrue();
  expect(scbDividerParam.primary.translateY !== -65).assertTrue();
  expect(scbDividerParam.primary.translateX !== -66).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity !== -67).assertTrue();
  expect(scbDividerParam.dividerAlpha !== -68).assertTrue();
  expect(scbDividerParam.primary.touchTranslateX !== -69).assertTrue();
  expect(scbDividerParam.primary.touchTranslateY !== -70).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateX !== -71).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateY !== -72).assertTrue();
  expect(scbDividerParam.primary.opacity !== -73).assertTrue();
  expect(scbDividerParam.primary.blurScale !== -74).assertTrue();
  expect(scbDividerParam.secondary.opacity !== -75).assertTrue();
  expect(scbDividerParam.secondary.blurScale !== -76).assertTrue();
  expect(scbDividerParam.primary.rotateX !== -77).assertTrue();
  expect(scbDividerParam.primary.rotateY !== -78).assertTrue();
  expect(scbDividerParam.primary.rotateZ !== -79).assertTrue();
  expect(scbDividerParam.primary.rotateAngle !== -80).assertTrue();
  expect(scbDividerParam.primary.rotateCenterX !== -81).assertTrue();
  expect(scbDividerParam.primary.rotateCenterY !== -82).assertTrue();
  expect(scbDividerParam.secondary.rotateX !== -83).assertTrue();
  expect(scbDividerParam.secondary.rotateZ !== -84).assertTrue();
  expect(scbDividerParam.secondary.rotateAngle !== -85).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterX !== -86).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterY !== -87).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity !== -88).assertTrue();
  expect(scbDividerParam.splitOrderIsNotReverse !== false).assertTrue();
  expect(scbDividerParam.primary.posX !== '-89%').assertTrue();
  expect(scbDividerParam.primary.posY !== '-90%').assertTrue();
  expect(scbDividerParam.secondary.posX !== '-91%').assertTrue();
  expect(scbDividerParam.secondary.posY !== '-92%').assertTrue();
  expect(scbDividerParam.primary.blurRadius !== -93).assertTrue();
  expect(scbDividerParam.secondary.blurRadius !== -94).assertTrue();
  scbDividerParam = null;
})

it('init_test_08', Level.LEVEL0, () => {
  let scbDividerParam: SCBDividerParam | null = new SCBDividerParam();
  scbDividerParam.init();
  expect(scbDividerParam.primary.translateX !== -95).assertTrue();
  expect(scbDividerParam.primary.translateY !== -96).assertTrue();
  expect(scbDividerParam.primary.translateX !== -97).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity !== -98).assertTrue();
  expect(scbDividerParam.dividerAlpha !== -99).assertTrue();
  expect(scbDividerParam.primary.touchTranslateX !== -100).assertTrue();
  expect(scbDividerParam.primary.touchTranslateY !== -101).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateX !== -102).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateY !== -103).assertTrue();
  expect(scbDividerParam.primary.opacity !== -104).assertTrue();
  expect(scbDividerParam.primary.blurScale !== -105).assertTrue();
  expect(scbDividerParam.secondary.opacity !== -106).assertTrue();
  expect(scbDividerParam.secondary.blurScale !== -107).assertTrue();
  expect(scbDividerParam.primary.rotateX !== -108).assertTrue();
  expect(scbDividerParam.primary.rotateY !== -109).assertTrue();
  expect(scbDividerParam.primary.rotateZ !== -110).assertTrue();
  expect(scbDividerParam.primary.rotateAngle !== -111).assertTrue();
  expect(scbDividerParam.primary.rotateCenterX !== -112).assertTrue();
  expect(scbDividerParam.primary.rotateCenterY !== -113).assertTrue();
  expect(scbDividerParam.secondary.rotateX !== -114).assertTrue();
  expect(scbDividerParam.secondary.rotateZ !== -115).assertTrue();
  expect(scbDividerParam.secondary.rotateAngle !== -116).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterX !== -117).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterY !== -118).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity !== -119).assertTrue();
  expect(scbDividerParam.splitOrderIsNotReverse !== false).assertTrue();
  expect(scbDividerParam.primary.posX !== '-120%').assertTrue();
  expect(scbDividerParam.primary.posY !== '-121%').assertTrue();
  expect(scbDividerParam.secondary.posX !== '-122%').assertTrue();
  expect(scbDividerParam.secondary.posY !== '-123%').assertTrue();
  expect(scbDividerParam.primary.blurRadius !== -124).assertTrue();
  expect(scbDividerParam.secondary.blurRadius !== -125).assertTrue();
  scbDividerParam = null;
})

it('init_test_09', Level.LEVEL0, () => {
  let scbDividerParam: SCBDividerParam | null = new SCBDividerParam();
  scbDividerParam.init();
  expect(scbDividerParam.primary.translateX !== -126).assertTrue();
  expect(scbDividerParam.primary.translateY !== -127).assertTrue();
  expect(scbDividerParam.primary.translateX !== -128).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity !== -129).assertTrue();
  expect(scbDividerParam.dividerAlpha !== -130).assertTrue();
  expect(scbDividerParam.primary.touchTranslateX !== -131).assertTrue();
  expect(scbDividerParam.primary.touchTranslateY !== -132).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateX !== -133).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateY !== -134).assertTrue();
  expect(scbDividerParam.primary.opacity !== -135).assertTrue();
  expect(scbDividerParam.primary.blurScale !== -136).assertTrue();
  expect(scbDividerParam.secondary.opacity !== -137).assertTrue();
  expect(scbDividerParam.secondary.blurScale !== -138).assertTrue();
  expect(scbDividerParam.primary.rotateX !== -139).assertTrue();
  expect(scbDividerParam.primary.rotateY !== -140).assertTrue();
  expect(scbDividerParam.primary.rotateZ !== -141).assertTrue();
  expect(scbDividerParam.primary.rotateAngle !== -142).assertTrue();
  expect(scbDividerParam.primary.rotateCenterX !== -143).assertTrue();
  expect(scbDividerParam.primary.rotateCenterY !== -144).assertTrue();
  expect(scbDividerParam.secondary.rotateX !== -145).assertTrue();
  expect(scbDividerParam.secondary.rotateZ !== -146).assertTrue();
  expect(scbDividerParam.secondary.rotateAngle !== -147).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterX !== -148).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterY !== -149).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity !== -150).assertTrue();
  expect(scbDividerParam.splitOrderIsNotReverse !== false).assertTrue();
  expect(scbDividerParam.primary.posX !== '-151%').assertTrue();
  expect(scbDividerParam.primary.posY !== '-152%').assertTrue();
  expect(scbDividerParam.secondary.posX !== '-153%').assertTrue();
  expect(scbDividerParam.secondary.posY !== '-154%').assertTrue();
  expect(scbDividerParam.primary.blurRadius !== -155).assertTrue();
  expect(scbDividerParam.secondary.blurRadius !== -156).assertTrue();
  scbDividerParam = null;
})

it('init_test_10', Level.LEVEL0, () => {
  let scbDividerParam: SCBDividerParam | null = new SCBDividerParam();
  scbDividerParam.init();
  expect(scbDividerParam.primary.translateX !== -157).assertTrue();
  expect(scbDividerParam.primary.translateY !== -158).assertTrue();
  expect(scbDividerParam.primary.translateX !== -159).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity !== -160).assertTrue();
  expect(scbDividerParam.dividerAlpha !== -161).assertTrue();
  expect(scbDividerParam.primary.touchTranslateX !== -162).assertTrue();
  expect(scbDividerParam.primary.touchTranslateY !== -163).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateX !== -164).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateY !== -165).assertTrue();
  expect(scbDividerParam.primary.opacity !== -166).assertTrue();
  expect(scbDividerParam.primary.blurScale !== -167).assertTrue();
  expect(scbDividerParam.secondary.opacity !== -168).assertTrue();
  expect(scbDividerParam.secondary.blurScale !== -169).assertTrue();
  expect(scbDividerParam.primary.rotateX !== -170).assertTrue();
  expect(scbDividerParam.primary.rotateY !== -171).assertTrue();
  expect(scbDividerParam.primary.rotateZ !== -172).assertTrue();
  expect(scbDividerParam.primary.rotateAngle !== -173).assertTrue();
  expect(scbDividerParam.primary.rotateCenterX !== -174).assertTrue();
  expect(scbDividerParam.primary.rotateCenterY !== -175).assertTrue();
  expect(scbDividerParam.secondary.rotateX !== -176).assertTrue();
  expect(scbDividerParam.secondary.rotateZ !== -177).assertTrue();
  expect(scbDividerParam.secondary.rotateAngle !== -178).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterX !== -179).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterY !== -180).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity !== -181).assertTrue();
  expect(scbDividerParam.splitOrderIsNotReverse !== false).assertTrue();
  expect(scbDividerParam.primary.posX !== '-182%').assertTrue();
  expect(scbDividerParam.primary.posY !== '-183%').assertTrue();
  expect(scbDividerParam.secondary.posX !== '-184%').assertTrue();
  expect(scbDividerParam.secondary.posY !== '-185%').assertTrue();
  expect(scbDividerParam.primary.blurRadius !== -186).assertTrue();
  expect(scbDividerParam.secondary.blurRadius !== -187).assertTrue();
  scbDividerParam = null;
})

it('init_test_11', Level.LEVEL0, () => {
  let scbDividerParam: SCBDividerParam | null = new SCBDividerParam();
  scbDividerParam.init();
  expect(scbDividerParam.primary.translateX !== -188).assertTrue();
  expect(scbDividerParam.primary.translateY !== -189).assertTrue();
  expect(scbDividerParam.primary.translateX !== -190).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity !== -191).assertTrue();
  expect(scbDividerParam.dividerAlpha !== -192).assertTrue();
  expect(scbDividerParam.primary.touchTranslateX !== -193).assertTrue();
  expect(scbDividerParam.primary.touchTranslateY !== -194).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateX !== -195).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateY !== -196).assertTrue();
  expect(scbDividerParam.primary.opacity !== -197).assertTrue();
  expect(scbDividerParam.primary.blurScale !== -198).assertTrue();
  expect(scbDividerParam.secondary.opacity !== -199).assertTrue();
  expect(scbDividerParam.secondary.blurScale !== -200).assertTrue();
  expect(scbDividerParam.primary.rotateX !== -201).assertTrue();
  expect(scbDividerParam.primary.rotateY !== -202).assertTrue();
  expect(scbDividerParam.primary.rotateZ !== -203).assertTrue();
  expect(scbDividerParam.primary.rotateAngle !== -204).assertTrue();
  expect(scbDividerParam.primary.rotateCenterX !== -205).assertTrue();
  expect(scbDividerParam.primary.rotateCenterY !== -206).assertTrue();
  expect(scbDividerParam.secondary.rotateX !== -207).assertTrue();
  expect(scbDividerParam.secondary.rotateZ !== -208).assertTrue();
  expect(scbDividerParam.secondary.rotateAngle !== -209).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterX !== -210).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterY !== -211).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity !== -212).assertTrue();
  expect(scbDividerParam.splitOrderIsNotReverse !== false).assertTrue();
  expect(scbDividerParam.primary.posX !== '-213%').assertTrue();
  expect(scbDividerParam.primary.posY !== '-214%').assertTrue();
  expect(scbDividerParam.secondary.posX !== '-215%').assertTrue();
  expect(scbDividerParam.secondary.posY !== '-216%').assertTrue();
  expect(scbDividerParam.primary.blurRadius !== -217).assertTrue();
  expect(scbDividerParam.secondary.blurRadius !== -218).assertTrue();
  scbDividerParam = null;
});

it('init_test_12', Level.LEVEL0, () => {
  let scbDividerParam: SCBDividerParam | null = new SCBDividerParam();
  scbDividerParam.init();
  expect(scbDividerParam.primary.translateX !== -219).assertTrue();
  expect(scbDividerParam.primary.translateY !== -220).assertTrue();
  expect(scbDividerParam.primary.translateX !== -221).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity !== -222).assertTrue();
  expect(scbDividerParam.dividerAlpha !== -223).assertTrue();
  expect(scbDividerParam.primary.touchTranslateX !== -224).assertTrue();
  expect(scbDividerParam.primary.touchTranslateY !== -225).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateX !== -226).assertTrue();
  expect(scbDividerParam.secondary.touchTranslateY !== -227).assertTrue();
  expect(scbDividerParam.primary.opacity !== -228).assertTrue();
  expect(scbDividerParam.primary.blurScale !== -229).assertTrue();
  expect(scbDividerParam.secondary.opacity !== -230).assertTrue();
  expect(scbDividerParam.secondary.blurScale !== -231).assertTrue();
  expect(scbDividerParam.primary.rotateX !== -232).assertTrue();
  expect(scbDividerParam.primary.rotateY !== -233).assertTrue();
  expect(scbDividerParam.primary.rotateZ !== -234).assertTrue();
  expect(scbDividerParam.primary.rotateAngle !== -235).assertTrue();
  expect(scbDividerParam.primary.rotateCenterX !== -236).assertTrue();
  expect(scbDividerParam.primary.rotateCenterY !== -237).assertTrue();
  expect(scbDividerParam.secondary.rotateX !== -238).assertTrue();
  expect(scbDividerParam.secondary.rotateZ !== -239).assertTrue();
  expect(scbDividerParam.secondary.rotateAngle !== -240).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterX !== -241).assertTrue();
  expect(scbDividerParam.secondary.rotateCenterY !== -242).assertTrue();
  expect(scbDividerParam.blackBackgroundOpacity !== -243).assertTrue();
  expect(scbDividerParam.splitOrderIsNotReverse !== false).assertTrue();
  expect(scbDividerParam.primary.posX !== '-244%').assertTrue();
  expect(scbDividerParam.primary.posY !== '-245%').assertTrue();
  expect(scbDividerParam.secondary.posX !== '-246%').assertTrue();
  expect(scbDividerParam.secondary.posY !== '-247%').assertTrue();
  expect(scbDividerParam.primary.blurRadius !== -248).assertTrue();
  expect(scbDividerParam.secondary.blurRadius !== -249).assertTrue();
  scbDividerParam = null;
});
