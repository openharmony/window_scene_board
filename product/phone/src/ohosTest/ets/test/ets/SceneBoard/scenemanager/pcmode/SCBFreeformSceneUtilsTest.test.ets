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
  AbilityItemInfo,
  SCBSceneInfo,
  SCBSceneOrientation,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSession,
  SCBScreenSessionManager
} from '@ohos/windowscene';
import { CommonUtils } from '@ohos/basicutils';
import { describe, it, expect, beforeAll, Level, beforeEach, MockKit, when, ArgumentMatchers } from '@ohos/hypium'
import { sFreeformSceneUtils } from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/pcmode/SCBFreeformSceneUtils'
import sceneSessionManager from '@ohos.sceneSessionManager'

let sceneInfo: SCBSceneInfo;
let sceneSession: SCBSceneSession;
let screenProperty: SCBScreenProperty;
let undefinedSceneSession: SCBSceneSession;

export function SCBFreeformSceneUtilsTest() {
  describe('SCBFreeformSceneUtilsTest', () => {
    beforeEach(() => {
      sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      sceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    });
    beforeAll(() => {
      screenProperty = new SCBScreenProperty();
      screenProperty.width = 2560;
      screenProperty.height = 1600;
      screenProperty.screenId = 0;
      screenProperty.rotation = 270;
      screenProperty.setRotationOffset(90);
      addAbilityInfo();
    });
    isOnlyPortraitTest();
    calcDefaultSizeInPcModeTest();
    calcWindowSizeByLimitsTest();
    px2vpWithDpiRatioTest();
    vp2pxWithDpiRatioTest();
  });
}

function addAbilityInfo() {
  let queryKey = 'testPriBundle' + 'testPriModule' + 'testPriAbility';
  let abilityInfoMap = SCBSceneSessionManager.getInstance()['abilityInfoMap'];
  let info: AbilityItemInfo = new AbilityItemInfo();
  info.windowSize = {
    maxWindowRatio: 0,
    minWindowRatio: 0,
    maxWindowWidth: 0,
    minWindowWidth: 0,
    maxWindowHeight: 0,
    minWindowHeight: 0
  }
  abilityInfoMap.set(queryKey, info);
}

function isOnlyPortraitTest() {
  it('isOnlyPortraitTest_01', Level.LEVEL0, () => {
    sceneSession.sessionData.requestOrientation = SCBSceneOrientation.UNSPECIFIED;
    let rst = sFreeformSceneUtils.isOnlyPortrait(sceneSession);
    expect(rst).assertEqual(false);
  });
  it('isOnlyPortraitTest_02', Level.LEVEL0, () => {
    sceneSession.sessionData.requestOrientation = SCBSceneOrientation.VERTICAL;
    let rst = sFreeformSceneUtils.isOnlyPortrait(sceneSession);
    expect(rst).assertEqual(true);
  });
  it('isOnlyPortraitTest_03', Level.LEVEL0, () => {
    sceneSession.sessionData.requestOrientation = SCBSceneOrientation.HORIZONTAL;
    let rst = sFreeformSceneUtils.isOnlyPortrait(sceneSession);
    expect(rst).assertEqual(false);
  });
  it('isOnlyPortraitTest_04', Level.LEVEL0, () => {
    sceneSession.sessionData.requestOrientation = SCBSceneOrientation.REVERSE_VERTICAL;
    let rst = sFreeformSceneUtils.isOnlyPortrait(sceneSession);
    expect(rst).assertEqual(true);
  });
  it('isOnlyPortraitTest_05', Level.LEVEL0, () => {
    sceneSession.sessionData.requestOrientation = SCBSceneOrientation.REVERSE_HORIZONTAL;
    let rst = sFreeformSceneUtils.isOnlyPortrait(sceneSession);
    expect(rst).assertEqual(false);
  });
  it('isOnlyPortraitTest_06', Level.LEVEL0, () => {
    sceneSession.sessionData.requestOrientation = SCBSceneOrientation.SENSOR;
    let rst = sFreeformSceneUtils.isOnlyPortrait(sceneSession);
    expect(rst).assertEqual(false);
  });
  it('isOnlyPortraitTest_07', Level.LEVEL0, () => {
    sceneSession.sessionData.requestOrientation = SCBSceneOrientation.SENSOR_VERTICAL;
    let rst = sFreeformSceneUtils.isOnlyPortrait(sceneSession);
    expect(rst).assertEqual(true);
  });
  it('isOnlyPortraitTest_08', Level.LEVEL0, () => {
    sceneSession.sessionData.requestOrientation = SCBSceneOrientation.SENSOR_HORIZONTAL;
    let rst = sFreeformSceneUtils.isOnlyPortrait(sceneSession);
    expect(rst).assertEqual(false);
  });
  it('isOnlyPortraitTest_09', Level.LEVEL0, () => {
    sceneSession.sessionData.requestOrientation = SCBSceneOrientation.AUTO_ROTATION_RESTRICTED;
    let rst = sFreeformSceneUtils.isOnlyPortrait(sceneSession);
    expect(rst).assertEqual(false);
  });
  it('isOnlyPortraitTest_10', Level.LEVEL0, () => {
    sceneSession.sessionData.requestOrientation = SCBSceneOrientation.AUTO_ROTATION_PORTRAIT_RESTRICTED;
    let rst = sFreeformSceneUtils.isOnlyPortrait(sceneSession);
    expect(rst).assertEqual(true);
  });
  it('isOnlyPortraitTest_11', Level.LEVEL0, () => {
    sceneSession.sessionData.requestOrientation = SCBSceneOrientation.AUTO_ROTATION_LANDSCAPE_RESTRICTED;
    let rst = sFreeformSceneUtils.isOnlyPortrait(sceneSession);
    expect(rst).assertEqual(false);
  });
  it('isOnlyPortraitTest_12', Level.LEVEL0, () => {
    sceneSession.sessionData.requestOrientation = SCBSceneOrientation.LOCKED;
    let rst = sFreeformSceneUtils.isOnlyPortrait(sceneSession);
    expect(rst).assertEqual(false);
  });
  it('isOnlyPortraitTest_13', Level.LEVEL0, () => {
    sceneSession.sessionData.requestOrientation = SCBSceneOrientation.FOLLOW_RECENT;
    let rst = sFreeformSceneUtils.isOnlyPortrait(sceneSession);
    expect(rst).assertEqual(false);
  });
  it('isOnlyPortraitTest_14', Level.LEVEL0, () => {
    sceneSession.sessionData.requestOrientation = SCBSceneOrientation.AUTO_ROTATION_UNSPECIFIED;
    let rst = sFreeformSceneUtils.isOnlyPortrait(sceneSession);
    expect(rst).assertEqual(false);
  });
  it('isOnlyPortraitTest_15', Level.LEVEL0, () => {
    sceneSession.sessionData.requestOrientation = SCBSceneOrientation.USER_ROTATION_LANDSCAPE;
    let rst = sFreeformSceneUtils.isOnlyPortrait(sceneSession);
    expect(rst).assertEqual(false);
  });
  it('isOnlyPortraitTest_16', Level.LEVEL0, () => {
    sceneSession.sessionData.requestOrientation = SCBSceneOrientation.USER_ROTATION_LANDSCAPE_INVERTED;
    let rst = sFreeformSceneUtils.isOnlyPortrait(sceneSession);
    expect(rst).assertEqual(false);
  });
  it('isOnlyPortraitTest_17', Level.LEVEL0, () => {
    sceneSession.sessionData.requestOrientation = SCBSceneOrientation.FOLLOW_DESKTOP;
    let rst = sFreeformSceneUtils.isOnlyPortrait(sceneSession);
    expect(rst).assertEqual(false);
  });
}

function calcDefaultSizeInPcModeTest() {
  const ratio = 0.67;
  const landscapeAspect = 4.0 / 3.0;
  const portraitAspect = 3.0 / 4.0;
  it('calcDefaultSizeInPcModeTest_01', Level.LEVEL0, () => {
    let expectSize: Size = { width: 0, height: 0 }
    let rstSize = sFreeformSceneUtils.calcDefaultSizeInPcMode(undefinedSceneSession, screenProperty);
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
  });

  it('calcDefaultSizeInPcModeTest_02', Level.LEVEL0, () => {
    let expectSize: Size = { width: 0, height: 0 };
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, sFreeformSceneUtils.isOnlyPortrait);
    when(func1)(ArgumentMatchers.any).afterReturn(true);
    sceneSession.sessionData.requestOrientation = SCBSceneOrientation.VERTICAL;
    expectSize.height = screenProperty.height * ratio;
    expectSize.width = expectSize.height * portraitAspect;
    let rstSize = sFreeformSceneUtils.calcDefaultSizeInPcMode(sceneSession, screenProperty);
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcDefaultSizeInPcModeTest_03', Level.LEVEL0, () => {
    let expectSize: Size = { width: 0, height: 0 };
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, sFreeformSceneUtils.isOnlyPortrait);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    expectSize.height = screenProperty.height * ratio;
    expectSize.width = expectSize.height * landscapeAspect;
    let rstSize = sFreeformSceneUtils.calcDefaultSizeInPcMode(sceneSession, screenProperty);
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcDefaultSizeInPcModeTest_04', Level.LEVEL0, () => {
    let expectSize: Size = { width: 0, height: 0 };
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, sFreeformSceneUtils.isOnlyPortrait);
    when(func1)(ArgumentMatchers.any).afterReturn(true);
    sceneSession.sceneInfo.windowHeight = 500;
    expectSize.height = 500;
    expectSize.width = expectSize.height * portraitAspect;
    let rstSize = sFreeformSceneUtils.calcDefaultSizeInPcMode(sceneSession, screenProperty);
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcDefaultSizeInPcModeTest_05', Level.LEVEL0, () => {
    let expectSize: Size = { width: 0, height: 0 };
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, sFreeformSceneUtils.isOnlyPortrait);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    sceneSession.sceneInfo.windowHeight = 500;
    expectSize.height = 500;
    expectSize.width = expectSize.height * landscapeAspect;
    let rstSize = sFreeformSceneUtils.calcDefaultSizeInPcMode(sceneSession, screenProperty);
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcDefaultSizeInPcModeTest_06', Level.LEVEL0, () => {
    let expectSize: Size = { width: 0, height: 0 };
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, sFreeformSceneUtils.isOnlyPortrait);
    when(func1)(ArgumentMatchers.any).afterReturn(true);
    sceneSession.sceneInfo.windowWidth = 500;
    expectSize.width = 500;
    expectSize.height = 500 / portraitAspect;
    let rstSize = sFreeformSceneUtils.calcDefaultSizeInPcMode(sceneSession, screenProperty);
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcDefaultSizeInPcModeTest_07', Level.LEVEL0, () => {
    let expectSize: Size = { width: 0, height: 0 };
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, sFreeformSceneUtils.isOnlyPortrait);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    sceneSession.sceneInfo.windowWidth = 500;
    expectSize.width = 500;
    expectSize.height = 500 / landscapeAspect;
    let rstSize = sFreeformSceneUtils.calcDefaultSizeInPcMode(sceneSession, screenProperty);
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcDefaultSizeInPcModeTest_08', Level.LEVEL0, () => {
    let expectSize: Size = { width: 0, height: 0 };
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, sFreeformSceneUtils.isOnlyPortrait);
    when(func1)(ArgumentMatchers.any).afterReturn(true);
    sceneSession.sceneInfo.windowWidth = 500;
    sceneSession.sceneInfo.windowHeight = 300;
    expectSize.width = 500;
    expectSize.height = 300;
    let rstSize = sFreeformSceneUtils.calcDefaultSizeInPcMode(sceneSession, screenProperty);
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcDefaultSizeInPcModeTest_09', Level.LEVEL0, () => {
    let expectSize: Size = { width: 0, height: 0 };
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, sFreeformSceneUtils.isOnlyPortrait);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    sceneSession.sceneInfo.windowWidth = 500;
    sceneSession.sceneInfo.windowHeight = 300;
    expectSize.width = 500;
    expectSize.height = 300;
    let rstSize = sFreeformSceneUtils.calcDefaultSizeInPcMode(sceneSession, screenProperty);
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });
}

function calcWindowSizeByLimitsTest() {
  it('calcWindowSizeByLimitsTest_01', Level.LEVEL0, () => {
    let rstSize = sFreeformSceneUtils.calcWindowSizeByLimits(undefinedSceneSession, 500, 300);
    let expectSize: Size = { width: 0, height: 0 };
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
  });

  it('calcWindowSizeByLimitsTest_02', Level.LEVEL0, () => {
    clearAbilityWindowSize();
    let rstSize = sFreeformSceneUtils.calcWindowSizeByLimits(sceneSession, 500, 300);
    let expectSize: Size = { width: 500, height: 300 };
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
  });

  it('calcWindowSizeByLimitsTest_03', Level.LEVEL0, () => {
    modifyAbilityWindowSize(0, 0, 300, 300, 500, 0);
    let mocker: MockKit = new MockKit();
    const func: Function = Reflect.get(sFreeformSceneUtils, 'isInappropriateLimits');
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, func);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let rstSize = sFreeformSceneUtils.calcWindowSizeByLimits(sceneSession, 500, 300);
    let expectSize: Size = { width: 320, height: 300 };
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcWindowSizeByLimitsTest_04', Level.LEVEL0, () => {
    modifyAbilityWindowSize(0, 0, 300, 0, 500, 0);
    let mocker: MockKit = new MockKit();
    const func: Function = Reflect.get(sFreeformSceneUtils, 'isInappropriateLimits');
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, func);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let rstSize = sFreeformSceneUtils.calcWindowSizeByLimits(sceneSession, 500, 300);
    let expectSize: Size = { width: 320, height: 300 };
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcWindowSizeByLimitsTest_05', Level.LEVEL0, () => {
    modifyAbilityWindowSize(0, 0, 0, 600, 500, 0);
    let mocker: MockKit = new MockKit();
    const func: Function = Reflect.get(sFreeformSceneUtils, 'isInappropriateLimits');
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, func);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let rstSize = sFreeformSceneUtils.calcWindowSizeByLimits(sceneSession, 500, 300);
    let expectSize: Size = { width: 600, height: 300 };
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcWindowSizeByLimitsTest_06', Level.LEVEL0, () => {
    modifyAbilityWindowSize(0, 0, 700, 600, 500, 0);
    let mocker: MockKit = new MockKit();
    const func: Function = Reflect.get(sFreeformSceneUtils, 'isInappropriateLimits');
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, func);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let rstSize = sFreeformSceneUtils.calcWindowSizeByLimits(sceneSession, 500, 300);
    let expectSize: Size = { width: 600, height: 300 };
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcWindowSizeByLimitsTest_07', Level.LEVEL0, () => {
    modifyAbilityWindowSize(0, 0, 600, 400, 500, 0);
    let mocker: MockKit = new MockKit();
    const func: Function = Reflect.get(sFreeformSceneUtils, 'isInappropriateLimits');
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, func);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let rstSize = sFreeformSceneUtils.calcWindowSizeByLimits(sceneSession, 500, 300);
    let expectSize: Size = { width: 500, height: 300 };
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcWindowSizeByLimitsTest_08', Level.LEVEL0, () => {
    modifyAbilityWindowSize(0, 0, 0, 600, 200, 0);
    let mocker: MockKit = new MockKit();
    const func: Function = Reflect.get(sFreeformSceneUtils, 'isInappropriateLimits');
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, func);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let rstSize = sFreeformSceneUtils.calcWindowSizeByLimits(sceneSession, 500, 300);
    let expectSize: Size = { width: 600, height: 200 };
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcWindowSizeByLimitsTest_09', Level.LEVEL0, () => {
    modifyAbilityWindowSize(0, 0, 0, 600, 200, 200);
    let mocker: MockKit = new MockKit();
    const func: Function = Reflect.get(sFreeformSceneUtils, 'isInappropriateLimits');
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, func);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let rstSize = sFreeformSceneUtils.calcWindowSizeByLimits(sceneSession, 500, 300);
    let expectSize: Size = { width: 600, height: 200 };
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcWindowSizeByLimitsTest_10', Level.LEVEL0, () => {
    modifyAbilityWindowSize(0, 0, 0, 600, 400, 200);
    let mocker: MockKit = new MockKit();
    const func: Function = Reflect.get(sFreeformSceneUtils, 'isInappropriateLimits');
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, func);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let rstSize = sFreeformSceneUtils.calcWindowSizeByLimits(sceneSession, 500, 300);
    let expectSize: Size = { width: 600, height: 300 };
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcWindowSizeByLimitsTest_11', Level.LEVEL0, () => {
    modifyAbilityWindowSize(0, 0, 0, 600, 600, 400);
    let mocker: MockKit = new MockKit();
    const func: Function = Reflect.get(sFreeformSceneUtils, 'isInappropriateLimits');
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, func);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let rstSize = sFreeformSceneUtils.calcWindowSizeByLimits(sceneSession, 500, 300);
    let expectSize: Size = { width: 600, height: 400 };
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcWindowSizeByLimitsTest_12', Level.LEVEL0, () => {
    modifyAbilityWindowSize(0, 0, 0, 600, 0, 400);
    let mocker: MockKit = new MockKit();
    const func: Function = Reflect.get(sFreeformSceneUtils, 'isInappropriateLimits');
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, func);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let rstSize = sFreeformSceneUtils.calcWindowSizeByLimits(sceneSession, 500, 300);
    let expectSize: Size = { width: 600, height: 400 };
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcWindowSizeByLimitsTest_13', Level.LEVEL0, () => {
    modifyAbilityWindowSize(0, 0, 400, 0, 500, 0);
    let mocker: MockKit = new MockKit();
    const func: Function = Reflect.get(sFreeformSceneUtils, 'isInappropriateLimits');
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, func);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let rstSize = sFreeformSceneUtils.calcWindowSizeByLimits(sceneSession, 500, 300);
    let expectSize: Size = { width: 400, height: 300 };
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcWindowSizeByLimitsTest_14', Level.LEVEL0, () => {
    modifyAbilityWindowSize(0, 0, 400, 400, 500, 0);
    let mocker: MockKit = new MockKit();
    const func: Function = Reflect.get(sFreeformSceneUtils, 'isInappropriateLimits');
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, func);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let rstSize = sFreeformSceneUtils.calcWindowSizeByLimits(sceneSession, 500, 300);
    let expectSize: Size = { width: 400, height: 300 };
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcWindowSizeByLimitsTest_15', Level.LEVEL0, () => {
    modifyAbilityWindowSize(0, 0, 0, 600, 0, 200);
    let mocker: MockKit = new MockKit();
    const func: Function = Reflect.get(sFreeformSceneUtils, 'isInappropriateLimits');
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, func);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let rstSize = sFreeformSceneUtils.calcWindowSizeByLimits(sceneSession, 500, 300);
    let expectSize: Size = { width: 600, height: 300 };
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcWindowSizeByLimitsTest_16', Level.LEVEL0, () => {
    modifyAbilityWindowSize(0, 0, 0, 600, 0, 0);
    let mocker: MockKit = new MockKit();
    const func: Function = Reflect.get(sFreeformSceneUtils, 'isInappropriateLimits');
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, func);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let rstSize = sFreeformSceneUtils.calcWindowSizeByLimits(sceneSession, 500, 50);
    let expectSize: Size = { width: 600, height: 100 };
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcWindowSizeByLimitsTest_17', Level.LEVEL0, () => {
    modifyAbilityWindowSize(0, 0, 0, 600, 50, 50);
    let mocker: MockKit = new MockKit();
    const func: Function = Reflect.get(sFreeformSceneUtils, 'isInappropriateLimits');
    let func1: Function = mocker.mockFunc(sFreeformSceneUtils, func);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let rstSize = sFreeformSceneUtils.calcWindowSizeByLimits(sceneSession, 500, 200);
    let expectSize: Size = { width: 600, height: 100 };
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcWindowSizeByLimitsTest_18', Level.LEVEL0, () => {
    modifyAbilityWindowSize(0, 0, 600, 0, 400, 0);
    let mocker: MockKit = new MockKit();
    let sceneSessionManager = SCBSceneSessionManager.getInstance();
    let func1: Function = mocker.mockFunc(sceneSessionManager, sceneSessionManager.getAspectRatioFromPreference);
    when(func1)(ArgumentMatchers.any).afterReturn(2);
    const func: Function = Reflect.get(sFreeformSceneUtils, 'isInappropriateLimits');
    let func2: Function = mocker.mockFunc(sFreeformSceneUtils, func);
    when(func2)(ArgumentMatchers.any).afterReturn(false);
    let rstSize = sFreeformSceneUtils.calcWindowSizeByLimits(sceneSession, 500, 300);
    let expectSize: Size = { width: 500, height: 287 };
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sceneSessionManager);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcWindowSizeByLimitsTest_19', Level.LEVEL0, () => {
    modifyAbilityWindowSize(0, 0, 600, 0, 400, 0);
    let mocker: MockKit = new MockKit();
    let sceneSessionManager = SCBSceneSessionManager.getInstance();
    let func1: Function = mocker.mockFunc(sceneSessionManager, sceneSessionManager.getAspectRatioFromPreference);
    when(func1)(ArgumentMatchers.any).afterReturn(2);
    const func: Function = Reflect.get(sFreeformSceneUtils, 'isInappropriateLimits');
    let func2: Function = mocker.mockFunc(sFreeformSceneUtils, func);
    when(func2)(ArgumentMatchers.any).afterReturn(false);
    let rstSize = sFreeformSceneUtils.calcWindowSizeByLimits(sceneSession, 500, 200);
    let expectSize: Size = { width: 326, height: 200 };
    expect(expectSize.width).assertEqual(rstSize.width);
    expect(expectSize.height).assertEqual(rstSize.height);
    mocker.clear(sceneSessionManager);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });

  it('calcWindowSizeByLimitsTest_20', Level.LEVEL0, () => {
    modifyAbilityWindowSize(0, 0, 600, 0, 400, 0);
    let mocker: MockKit = new MockKit();
    const func: Function = Reflect.get(sFreeformSceneUtils, 'isInappropriateLimits');
    let func2: Function = mocker.mockFunc(sFreeformSceneUtils, func);
    when(func2)(ArgumentMatchers.any).afterReturn(true);
    let screenManager = SCBScreenSessionManager.getInstance();
    let mockGetScreenSession: Function = mocker.mockFunc(screenManager, screenManager.getScreenSession);
    let screenSession: ESObject = mocker.mockObject(SCBScreenSession);
    screenSession.scbScreenProperty = new SCBScreenProperty();
    screenSession.scbScreenProperty.width = 500;
    screenSession.scbScreenProperty.height = 400;
    when(mockGetScreenSession)(ArgumentMatchers.any).afterReturn(screenSession);
    sFreeformSceneUtils.calcWindowSizeByLimits(sceneSession, 500, 200);
    expect(sceneSession.isResizeableInCompatibleMode).assertFalse();
    mocker.clear(screenSession);
    mocker.clear(screenManager);
    mocker.clear(sFreeformSceneUtils);
    mocker.clearAll();
  });
}

function px2vpWithDpiRatioTest() {
  it('px2vpWithDpiRatioTest_01', Level.LEVEL0, () => {
    const px = 100;
    const ratio = 1.5;
    const expectVp = px / ratio;
    let value: number = sFreeformSceneUtils.px2vpWithDpiRatio(px, ratio);
    expect(CommonUtils.equals(value, expectVp)).assertTrue();
  });

  it('px2vpWithDpiRatioTest_02', Level.LEVEL0, () => {
    const px = 100;
    const ratio = -1;
    const expectVp = px2vp(px);
    let value: number = sFreeformSceneUtils.px2vpWithDpiRatio(px, ratio);
    expect(CommonUtils.equals(value, expectVp)).assertTrue();
  });
}

function vp2pxWithDpiRatioTest() {
  it('vp2pxWithDpiRatioTest_01', Level.LEVEL0, () => {
    const vp = 100;
    const ratio = 1.5;
    const expectPx = vp * ratio;
    let value: number = sFreeformSceneUtils.vp2pxWithDpiRatio(vp, ratio);
    expect(CommonUtils.equals(value, expectPx)).assertTrue();
  });

  it('vp2pxWithDpiRatioTest_02', Level.LEVEL0, () => {
    const vp = 100;
    const ratio = -1;
    const expectPx = vp2px(vp);
    let value: number = sFreeformSceneUtils.vp2pxWithDpiRatio(vp, ratio);
    expect(CommonUtils.equals(value, expectPx)).assertTrue();
  });
}

function clearAbilityWindowSize() {
  let queryKey = 'testPriBundle' + 'testPriModule' + 'testPriAbility';
  let abilityInfoMap = SCBSceneSessionManager.getInstance()['abilityInfoMap'];
  abilityInfoMap.delete(queryKey);
}

function modifyAbilityWindowSize(maxRatio: number, minRatio: number, maxWidth: number, minWidth: number,
  maxHeight: number, minHeight: number) {
  let queryKey = 'testPriBundle' + 'testPriModule' + 'testPriAbility';
  let abilityInfoMap = SCBSceneSessionManager.getInstance()['abilityInfoMap'];
  let info: AbilityItemInfo = new AbilityItemInfo();
  info.windowSize = {
    maxWindowRatio: maxRatio,
    minWindowRatio: minRatio,
    maxWindowWidth: maxWidth,
    minWindowWidth: minWidth,
    maxWindowHeight: maxHeight,
    minWindowHeight: minHeight
  }
  abilityInfoMap.set(queryKey, info);
}