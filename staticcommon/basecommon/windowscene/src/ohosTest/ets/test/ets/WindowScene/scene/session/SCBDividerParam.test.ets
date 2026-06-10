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
import { beforeAll, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import {
  SCBDividerParam,
  SCBSceneMode,
  SCBScreenProperty,
  SCBScreenSession,
  SCBScreenSessionManager,
  SplitStyle,
} from '../../../../../../../main/ets/TsIndex';
import { ReflectionUtils } from './ReflectionUtils';
import { borderRadiuses } from '@kit.ArkUI';
import { RotationConstants } from '@ohos/commonconstants';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const DEFAULT: number = 0;
let scbDividerParam: SCBDividerParam = new SCBDividerParam();
let screenProperty = new SCBScreenProperty();
let mocker: MockKit;
let screenSessionManager = SCBScreenSessionManager.getInstance();

export function SCBDividerParamTest() {

  describe('SCBCommonDividerParamTest', (): void => {
    beforeAll((): void => {
      scbDividerParam.init();
      screenProperty.width = 2000;
      screenProperty.height = 2000;
      scbDividerParam = new SCBDividerParam();
      mocker = new MockKit();
    })

    it('initTest', Level.LEVEL0, () => {
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
    })

    it('initInMid', Level.LEVEL0, () => {
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

    it("updateDynamicVariableTest", Level.LEVEL0, () => {
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

    it('getPriPosXPctTest', Level.LEVEL0, () => {
      let scbDividerParam: SCBDividerParam = new SCBDividerParam();
      expect(scbDividerParam.getPriPosXPct()).assertEqual(0);
    })

    it('getPriPosYPctTest', Level.LEVEL0, () => {
      let scbDividerParam: SCBDividerParam = new SCBDividerParam();
      expect(scbDividerParam.getPriPosYPct()).assertEqual(0);
    })

    it('getSecPosXPctTest', Level.LEVEL0, () => {
      let scbDividerParam: SCBDividerParam = new SCBDividerParam();
      expect(scbDividerParam.getSecPosXPct()).assertEqual(0);
    })

    it('getSecPosYPctTest', Level.LEVEL0, () => {
      let scbDividerParam: SCBDividerParam = new SCBDividerParam();
      expect(scbDividerParam.getSecPosYPct()).assertEqual(0);
    })

    it('clearDynamicVariableTest', Level.LEVEL0, () => {
      let scbDividerParam: SCBDividerParam = new SCBDividerParam();
      scbDividerParam.clearDynamicVariable();
      expect(scbDividerParam.secondary.translateX).assertEqual(0);
      expect(scbDividerParam.secondary.translateY).assertEqual(0);
    })

    it('updateSplitContainerPositionTest', Level.LEVEL0, updateSplitContainerPositionTest)

    it('doPrimaryTranslateTest', Level.LEVEL0, () => {
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

    it('doOneStepTranslateTest', Level.LEVEL0, () => {
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

    it('doSecondSceneTranslateTest', Level.LEVEL0, () => {
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

    it('setAngGetIsVerticalTest', Level.LEVEL0, () => {
      let scbDividerParam: SCBDividerParam = new SCBDividerParam();
      scbDividerParam.setIsVertical(true);
      expect(scbDividerParam.getIsVertical()).assertTrue();
      scbDividerParam.setIsVertical(false);
      expect(scbDividerParam.getIsVertical()).assertFalse();
    });

    it('setAndGetSplitStyle', Level.LEVEL0, () => {
      let scbDividerParam: SCBDividerParam = new SCBDividerParam();
      scbDividerParam.setSplitStyle(SplitStyle.LEFT_AND_RIGHT_POS);
      expect(scbDividerParam.getSplitStyle()).assertEqual(SplitStyle.LEFT_AND_RIGHT_POS);
    });

    it('notifyAvoidAreaChangeTest', Level.LEVEL0, notifyAvoidAreaChangeTest);

    it('doOneStepVerticalTranslateTest', Level.LEVEL0, () => {
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

    it('setBorderRadiusTest', Level.LEVEL0, setBorderRadiusTest);

    it('doPrimRotateTest', Level.LEVEL0, doPrimRotateTest);

    it('doSecRotateTest', Level.LEVEL0, doSecRotateTest);

    it('doContainerRotateTest', Level.LEVEL0, doContainerRotateTest);

    it('doSceneSessionScaleTest', Level.LEVEL0, doSceneSessionScaleTest);

    it('resetSceneSessionScaleTest', Level.LEVEL0, resetSceneSessionScaleTest);

    it('doSceneTouchScaleTest', Level.LEVEL0, doSceneTouchScaleTest);

    it('doDividerTranslateTest', Level.LEVEL0, doDividerTranslateTest);

    it('doSceneTouchTranslateTest', Level.LEVEL0, doSceneTouchTranslateTest);

    it('resetDividerPositionAndTransTest', Level.LEVEL0, resetDividerPositionAndTransTest);

    it('updateDividerParamTest', Level.LEVEL0, updateDividerParamTest);

    it('updateDividerParamWithRatioTest', Level.LEVEL0, updateDividerParamWithRatioTest);

    it('updateSplitStackPositionTest', Level.LEVEL0, updateSplitStackPositionTest);

    it('updateSplitStackPositionAndSizeTest', Level.LEVEL0, updateSplitStackPositionAndSizeTest);

    it('updateDividerPositionTest', Level.LEVEL0, updateDividerPositionTest);

    it('resetBlurOpacityTest', Level.LEVEL0, resetBlurOpacityTest);

    it('testSetDeviceRadius', Level.LEVEL0, testSetDeviceRadius);

    it('testIsUpDownSplit', Level.LEVEL0, testIsUpDownSplit);

    it('testInteractiveStateChangeCallback', Level.LEVEL0, testInteractiveStateChangeCallback);

    it('testMarkEvent', Level.LEVEL0, testMarkEvent);

    it('testSetOpacity', Level.LEVEL0, testSetOpacity);

    it('testSetZIndex', Level.LEVEL0, testSetZIndex);

    it('testFreeze', Level.LEVEL0, testFreeze);

    it('testGetAvoidPctIfNeeded', Level.LEVEL0, testGetAvoidPctIfNeeded);

    it('testNotifyPositionChange', Level.LEVEL0, testNotifyPositionChange);

    it('testAnimFunc', Level.LEVEL0, testAnimFunc);

    it('testAnimFuncWithSplitOrderIsNotReverse', Level.LEVEL0, testAnimFuncWithSplitOrderIsNotReverse);

    it('testGetSceneScaleX', Level.LEVEL0, testGetSceneScaleX);

    it('testSetShadowOptions', Level.LEVEL0, testSetShadowOptions);

    it('testCalOneStepDefaultTrans', Level.LEVEL0, testCalOneStepDefaultTrans);
    it('testSetOneStepDefaultTranslate', Level.LEVEL0, testSetOneStepDefaultTranslate);
    it('testSetOneStepDefaultPos', Level.LEVEL0, testSetOneStepDefaultPos);

    it('testSetMinValue', Level.LEVEL0, testSetMinValue);
  })
}

function testCalOneStepDefaultTrans() {
  scbDividerParam.primSizePct = 0;
  scbDividerParam.secSizePct = 0;
  scbDividerParam.calOneStepDefaultTrans(screenProperty, false);
  let res = scbDividerParam.calOneStepDefaultTrans(screenProperty, true);
  expect(res).assertLarger(0);
}

function testSetOneStepDefaultTranslate() {
  scbDividerParam.setOneStepDefaultTranslate(0, true);
  scbDividerParam.setOneStepDefaultTranslate(0, false);
  expect(scbDividerParam.primary.posX).assertEqual('0');
}

function testSetOneStepDefaultPos() {
  scbDividerParam.setOneStepDefaultPos(0, screenProperty);
  expect(scbDividerParam.primary.translateX).assertEqual(0);
}

function testGetAvoidPctIfNeeded() {
  let func_01: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
  when(func_01)().afterReturn(false);
  screenProperty.rotation = 90;
  mocker.clear(func_01);
}

function testAnimFuncWithSplitOrderIsNotReverse() {
  // isUpDownSplit
  let list: boolean[] = [true, false];
  let func_01: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
  when(func_01)().afterReturn(false);
  let borderRadius = borderRadiuses(0);
  // is up down split
  list.forEach((isVertical: boolean) => {
    scbDividerParam.setIsVertical(isVertical);
    testWithIsUpDown();
    // is Not reverse
    list.forEach((isNotReverse: boolean) => {
      scbDividerParam.splitOrderIsNotReverse = isNotReverse;
      // isNotReverse
      testWithSplitOrderIsNotReverse(list, borderRadius);
    })
  })
  mocker.clear(func_01);
}

function testWithIsUpDown() {
  scbDividerParam.getDividerPctPositionX();
  scbDividerParam.getDividerPctPositionY();
  scbDividerParam.getDividerSameDirectionScreenLength(0, 0);
  scbDividerParam.getDividerVerticalDirectionScreenLength(0, 0);
}

function testWithSplitOrderIsNotReverse(list: boolean[], borderRadius: BorderRadiuses) {
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
    scbDividerParam.getScenePositionX(primary, 0);
    scbDividerParam.getScenePositionY(primary, 0);
    scbDividerParam.getSceneWidth(primary, 0);
    scbDividerParam.getSceneHeight(primary, 0);
    scbDividerParam.getSceneScaleY(primary);
    testWithDifferentMode();
  });
}

function testWithDifferentMode() {
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

function testAnimFunc() {
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

function testNotifyPositionChange() {
  let key: number = 1;
  let callback = () => {
  };
  scbDividerParam.registerPositionChangeCallback(key, callback);
  scbDividerParam.setNeedNotifyPositionChange(true);
  scbDividerParam.notifyPositionChange();
  scbDividerParam.setNeedNotifyPositionChange(false);
  scbDividerParam.notifyPositionChange();
  scbDividerParam.unregisterPositionChangeCallback(key);
}

function testFreeze() {
  let str: string = "fake reason";
  scbDividerParam.freezeScene(str);
  scbDividerParam.releaseSceneFreeze(str);
}

function testSetOpacity() {
  scbDividerParam.setPrimaryOpacity(0);
  scbDividerParam.setSecondaryOpacity(0);
  scbDividerParam.setDividerOpacity(0);
  scbDividerParam.setBlackBackgroundOpacity(0);
}

function testSetZIndex() {
  scbDividerParam.setPrimaryZIndex(0);
  scbDividerParam.setSecondaryZIndex(0);
}

function testSetDeviceRadius() {
  scbDividerParam.deviceRadius = 0;
  expect(0).assertEqual(scbDividerParam.deviceRadius);
}

function testIsUpDownSplit() {
  let func_01: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
  let func_02: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLargeInFoldProduct);
  when(func_01)().afterReturn(true);
  when(func_02)().afterReturn(false);
  scbDividerParam.splitStyle = SplitStyle.UP_AND_DOWN_POS;
  expect(scbDividerParam.isUpDownSplit()).assertEqual(false);
  mocker.clear(screenSessionManager);
  mocker.clear(DeviceHelper);
}

function testInteractiveStateChangeCallback() {
  let callback = (state: boolean) => {
  }
  scbDividerParam.registerInteractiveStateChangeCallback(callback);
  scbDividerParam.notifyInteractiveStateChange(true);
  scbDividerParam.unregisterInteractiveStateChangeCallback();
  scbDividerParam.notifyInteractiveStateChange(false);
}

function testMarkEvent() {
  scbDividerParam.markEventFromGesture();
}

function test2BoolArgsFunctionInLoop(func: Function) {
  [true, false].forEach((value0, index0) => {
    [true, false].forEach((value1, index1) => {
      func(value0, value1);
    })
  })
}

function updateSplitContainerPositionTest() {
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

function notifyAvoidAreaChangeTest() {
  SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()
  let func_01: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
  let func_02: Function = mocker.mockFunc(scbDividerParam, scbDividerParam.isUpDownSplit);
  scbDividerParam.needCutOut = false;
  const STATUS_BAR_PCT = 0.2;
  const avoidPct = 0.15;
  scbDividerParam.statusBarPct = STATUS_BAR_PCT;
  expect(scbDividerParam.needCutOut).assertFalse();
  scbDividerParam.notifyAvoidAreaChange(screenProperty);
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
  expect(scbDividerParam.needCutOut).assertTrue();
  scbDividerParam.notifyAvoidAreaChange(screenProperty);
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

function setBorderRadiusTest() {
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

function doPrimRotateTest() {
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

function doSecRotateTest() {
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

function doContainerRotateTest() {
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

function doSceneSessionScaleTest() {
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

function resetSceneSessionScaleTest() {
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

function doSceneTouchScaleTest() {
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

function doSceneTouchTranslateTest() {
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

function doDividerTranslateTest() {
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

function updateDividerPositionTest() {
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
    expect(scbDividerParam.positionY).assertInstanceOf('String');
    expect(scbDividerParam.positionX).assertInstanceOf('String');
  }
  test2BoolArgsFunctionInLoop(testFunction);
  mocker.clear(func_01);
}

function updateDividerParamTest() {
  testUpdateSceneSizeFunction(() => {
    scbDividerParam.updateDividerParam(screenProperty);
  });
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
  expect(scbDividerParam.primary.width).assertInstanceOf('String');
  expect(scbDividerParam.primary.height).assertInstanceOf('String');
  expect(scbDividerParam.secondary.width).assertInstanceOf('String');
  expect(scbDividerParam.secondary.height).assertInstanceOf('String');
}

function resetDividerPositionAndTransTest() {
  const translate = 10;
  scbDividerParam.dividerTranslateX = translate;
  scbDividerParam.dividerTranslateY = translate;
  scbDividerParam.resetDividerPositionAndTrans();
  expect(scbDividerParam.dividerTranslateX).assertEqual(0);
  expect(scbDividerParam.dividerTranslateY).assertEqual(0);
}

function updateSplitStackPositionAndSizeTest() {
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

function updateDividerParamWithRatioTest() {
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

function resetBlurOpacityTest() {
  scbDividerParam.primary.blurScale = 1;
  scbDividerParam.secondary.blurScale = 1;
  scbDividerParam.resetBlurOpacity();
  expect(scbDividerParam.primary.blurScale).assertEqual(0);
  expect(scbDividerParam.secondary.blurScale).assertEqual(0);
}

function updateSplitStackPositionTest() {
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
    expect(scbDividerParam.primary.posY).assertInstanceOf('String');
    expect(scbDividerParam.secondary.posY).assertInstanceOf('String');
    mocker.clear(func_01);
  }
  test2BoolArgsFunctionInLoop(testFunction);
}

function testGetSceneScaleX() {
  scbDividerParam.primary.scaleX = 0;
  scbDividerParam.secondary.scaleX = 1;
  scbDividerParam.splitOrderIsNotReverse = true;
  expect(scbDividerParam.getSceneScaleX(true)).assertEqual(0);
  expect(scbDividerParam.getSceneScaleX(false)).assertEqual(1);
  scbDividerParam.splitOrderIsNotReverse = false;
  expect(scbDividerParam.getSceneScaleX(true)).assertEqual(1);
  expect(scbDividerParam.getSceneScaleX(false)).assertEqual(0);
}

function testSetShadowOptions() {
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

function testSetMinValue() {
  scbDividerParam.setPrimaryMinWidth(500);
  expect(scbDividerParam.primary.minWidth).assertEqual(500);
  scbDividerParam.setPrimaryMinHeight(600);
  expect(scbDividerParam.primary.minHeight).assertEqual(600);
  scbDividerParam.setSecondaryMinWidth(700);
  expect(scbDividerParam.secondary.minWidth).assertEqual(700);
  scbDividerParam.setSecondaryMinHeight(800);
  expect(scbDividerParam.secondary.minHeight).assertEqual(800);
}