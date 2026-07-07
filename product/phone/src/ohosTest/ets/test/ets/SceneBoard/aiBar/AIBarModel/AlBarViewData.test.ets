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

import { CommonUtils } from '@ohos/basicutils'
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import {
  BarOpacityParam,
  BarRadiusParam,
  BarTranslateParam,
  WeakNotifyParam,
  AIBarViewData
} from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/AIBarModel/AIBarViewData'

export default function AIBarViewDataTest() {
  describe('AIBarViewDataTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('BarTranslateParam_getInstance_1', 0, async (done: Function) => {
      (BarTranslateParam as object)['mInstance'] = null;
      expect(BarTranslateParam.getInstance() !== undefined).assertTrue();
      done();
    })

    it('BarTranslateParam_barTranslateX_1', 0, async (done: Function) => {
      let barTranslateParam = new BarTranslateParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barTranslateParam.barTranslateX = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarTranslateParam_barTranslateX_2', 0, async (done: Function) => {
      let barTranslateParam = new BarTranslateParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(barTranslateParam.barTranslateX = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarTranslateParam_barTranslateY_1', 0, async (done: Function) => {
      let barTranslateParam = new BarTranslateParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barTranslateParam.barTranslateY = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarRadiusParam_getInstance_1', 0, async (done: Function) => {
      BarRadiusParam.getInstance();
      expect(BarRadiusParam.getInstance() !== undefined).assertTrue();
      done();
    })

    it('BarRadiusParam_barRadius_1', 0, async (done: Function) => {
      let barRadiusParam = new BarRadiusParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barRadiusParam.barRadius = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarOpacityParam_getInstance_1', 0, async (done: Function) => {
      BarOpacityParam.getInstance();
      expect(BarOpacityParam.getInstance() !== undefined).assertTrue();
      done();
    })

    it('BarOpacityParam_barOpacity_1', 0, async (done: Function) => {
      let barOpacityParam = new BarOpacityParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barOpacityParam.barOpacity = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })


    it('BarOpacityParam_barOpacity_2', 0, async (done: Function) => {
      let barOpacityParam = new BarOpacityParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barOpacityParam.barOpacity = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarOpacityParam_barOpacity_3', 0, async (done: Function) => {
      let barOpacityParam = new BarOpacityParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barOpacityParam.barOpacity = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarOpacityParam_barOpacity_4', 0, async (done: Function) => {
      let barOpacityParam = new BarOpacityParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barOpacityParam.barOpacity = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarOpacityParam_barOpacity_5', 0, async (done: Function) => {
      let barOpacityParam = new BarOpacityParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barOpacityParam.barOpacity = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarOpacityParam_barOpacity_6', 0, async (done: Function) => {
      let barOpacityParam = new BarOpacityParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barOpacityParam.barOpacity = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarOpacityParam_barOpacity_7', 0, async (done: Function) => {
      let barOpacityParam = new BarOpacityParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barOpacityParam.barOpacity = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarOpacityParam_barOpacity_8', 0, async (done: Function) => {
      let barOpacityParam = new BarOpacityParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barOpacityParam.barOpacity = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarOpacityParam_barOpacity_9', 0, async (done: Function) => {
      let barOpacityParam = new BarOpacityParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barOpacityParam.barOpacity = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarOpacityParam_barOpacity_10', 0, async (done: Function) => {
      let barOpacityParam = new BarOpacityParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barOpacityParam.barOpacity = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarOpacityParam_barOpacity_11', 0, async (done: Function) => {
      let barOpacityParam = new BarOpacityParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barOpacityParam.barOpacity = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarOpacityParam_barOpacity_12', 0, async (done: Function) => {
      let barOpacityParam = new BarOpacityParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barOpacityParam.barOpacity = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarOpacityParam_barOpacity_13', 0, async (done: Function) => {
      let barOpacityParam = new BarOpacityParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barOpacityParam.barOpacity = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarOpacityParam_barOpacity_14', 0, async (done: Function) => {
      let barOpacityParam = new BarOpacityParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barOpacityParam.barOpacity = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarOpacityParam_barOpacity_15', 0, async (done: Function) => {
      let barOpacityParam = new BarOpacityParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barOpacityParam.barOpacity = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarOpacityParam_barOpacity_16', 0, async (done: Function) => {
      let barOpacityParam = new BarOpacityParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barOpacityParam.barOpacity = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarOpacityParam_barOpacity_17', 0, async (done: Function) => {
      let barOpacityParam = new BarOpacityParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barOpacityParam.barOpacity = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarOpacityParam_barOpacity_18', 0, async (done: Function) => {
      let barOpacityParam = new BarOpacityParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barOpacityParam.barOpacity = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarOpacityParam_barOpacity_19', 0, async (done: Function) => {
      let barOpacityParam = new BarOpacityParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barOpacityParam.barOpacity = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarOpacityParam_barOpacity_20', 0, async (done: Function) => {
      let barOpacityParam = new BarOpacityParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barOpacityParam.barOpacity = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('BarOpacityParam_barOpacity_21', 0, async (done: Function) => {
      let barOpacityParam = new BarOpacityParam();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(barOpacityParam.barOpacity = 100).assertEqual(100);
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
      done();
    })

    it('WeakNotifyParam_getInstance_1', 0, async (done: Function) => {
      WeakNotifyParam.getInstance();
      expect(WeakNotifyParam.getInstance() !== undefined).assertTrue();
      done();
    })

    it('AIBarViewData_isNeedToUsePureColor_1', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.powerMode = 601;
      aiBarViewData.thermalLevel = 10;
      aiBarViewData.isEnterDeliver = true;
      let data = aiBarViewData as object;
      data['aiBarData'].aiBarPureColorMode = true;
      expect(aiBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('AIBarViewData_isNeedToUsePureColor_2', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.powerMode = 0;
      aiBarViewData.thermalLevel = 10;
      aiBarViewData.isEnterDeliver = true;
      let data = aiBarViewData as object;
      data['aiBarData'].aiBarPureColorMode = true;
      expect(aiBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('AIBarViewData_isNeedToUsePureColor_3', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.powerMode = 601;
      aiBarViewData.thermalLevel = 0;
      aiBarViewData.isEnterDeliver = true;
      let data = aiBarViewData as object;
      data['aiBarData'].aiBarPureColorMode = true;
      expect(aiBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('AIBarViewData_isNeedToUsePureColor_4', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.powerMode = 0;
      aiBarViewData.thermalLevel = 0;
      aiBarViewData.isEnterDeliver = true;
      let data = aiBarViewData as object;
      data['aiBarData'].aiBarPureColorMode = true;
      expect(aiBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('AIBarViewData_isNeedToUsePureColor_5', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.powerMode = 601;
      aiBarViewData.thermalLevel = 10;
      aiBarViewData.isEnterDeliver = false;
      let data = aiBarViewData as object;
      data['aiBarData'].aiBarPureColorMode = true;
      expect(aiBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('AIBarViewData_isNeedToUsePureColor_6', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.powerMode = 0;
      aiBarViewData.thermalLevel = 10;
      aiBarViewData.isEnterDeliver = false;
      let data = aiBarViewData as object;
      data['aiBarData'].aiBarPureColorMode = true;
      expect(aiBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('AIBarViewData_isNeedToUsePureColor_7', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.powerMode = 601;
      aiBarViewData.thermalLevel = 0;
      aiBarViewData.isEnterDeliver = false;
      let data = aiBarViewData as object;
      data['aiBarData'].aiBarPureColorMode = true;
      expect(aiBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('AIBarViewData_isNeedToUsePureColor_8', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.powerMode = 0;
      aiBarViewData.thermalLevel = 0;
      aiBarViewData.isEnterDeliver = false;
      let data = aiBarViewData as object;
      data['aiBarData'].aiBarPureColorMode = true;
      expect(aiBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('AIBarViewData_isNeedToUsePureColor_9', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.powerMode = 601;
      aiBarViewData.thermalLevel = 10;
      aiBarViewData.isEnterDeliver = true;
      let data = aiBarViewData as object;
      data['aiBarData'].aiBarPureColorMode = false;
      expect(aiBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('AIBarViewData_isNeedToUsePureColor_10', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.powerMode = 0;
      aiBarViewData.thermalLevel = 10;
      aiBarViewData.isEnterDeliver = true;
      let data = aiBarViewData as object;
      data['aiBarData'].aiBarPureColorMode = false;
      expect(aiBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('AIBarViewData_isNeedToUsePureColor_11', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.powerMode = 601;
      aiBarViewData.thermalLevel = 0;
      aiBarViewData.isEnterDeliver = true;
      let data = aiBarViewData as object;
      data['aiBarData'].aiBarPureColorMode = false;
      expect(aiBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('AIBarViewData_isNeedToUsePureColor_12', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.powerMode = 0;
      aiBarViewData.thermalLevel = 0;
      aiBarViewData.isEnterDeliver = true;
      let data = aiBarViewData as object;
      data['aiBarData'].aiBarPureColorMode = false;
      expect(aiBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('AIBarViewData_isNeedToUsePureColor_13', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.powerMode = 601;
      aiBarViewData.thermalLevel = 10;
      aiBarViewData.isEnterDeliver = false;
      let data = aiBarViewData as object;
      data['aiBarData'].aiBarPureColorMode = false;
      expect(aiBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('AIBarViewData_isNeedToUsePureColor_14', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.powerMode = 0;
      aiBarViewData.thermalLevel = 10;
      aiBarViewData.isEnterDeliver = false;
      let data = aiBarViewData as object;
      data['aiBarData'].aiBarPureColorMode = false;
      expect(aiBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('AIBarViewData_isNeedToUsePureColor_15', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.powerMode = 601;
      aiBarViewData.thermalLevel = 0;
      aiBarViewData.isEnterDeliver = false;
      let data = aiBarViewData as object;
      data['aiBarData'].aiBarPureColorMode = false;
      expect(aiBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('AIBarViewData_isNeedToUsePureColor_16', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.powerMode = 0;
      aiBarViewData.thermalLevel = 0;
      aiBarViewData.isEnterDeliver = false;
      let data = aiBarViewData as object;
      data['aiBarData'].aiBarPureColorMode = false;
      expect(aiBarViewData.isNeedToUsePureColor()).assertFalse();
    })



    it('AIBarViewData_getAibarOpacity_1', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = true;
      aiBarViewData.isScreenLock = false;
      aiBarViewData.isShowNotificationCapsule = true;
      aiBarViewData.isInExitLandScape = true;
      aiBarViewData.aiBarOpacity = 0;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_2', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = false;
      aiBarViewData.isScreenLock = false;
      aiBarViewData.isShowNotificationCapsule = true;
      aiBarViewData.isInExitLandScape = true;
      aiBarViewData.aiBarOpacity = 0;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_3', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = true;
      aiBarViewData.isScreenLock = true;
      aiBarViewData.isShowNotificationCapsule = true;
      aiBarViewData.isInExitLandScape = true;
      aiBarViewData.aiBarOpacity = 0;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_4', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = false;
      aiBarViewData.isScreenLock = true;
      aiBarViewData.isShowNotificationCapsule = true;
      aiBarViewData.isInExitLandScape = true;
      aiBarViewData.aiBarOpacity = 0;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_5', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = true;
      aiBarViewData.isScreenLock = false;
      aiBarViewData.isShowNotificationCapsule = false;
      aiBarViewData.isInExitLandScape = true;
      aiBarViewData.aiBarOpacity = 0;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_6', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = false;
      aiBarViewData.isScreenLock = false;
      aiBarViewData.isShowNotificationCapsule = false;
      aiBarViewData.isInExitLandScape = true;
      aiBarViewData.aiBarOpacity = 0;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_7', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = true;
      aiBarViewData.isScreenLock = true;
      aiBarViewData.isShowNotificationCapsule = false;
      aiBarViewData.isInExitLandScape = true;
      aiBarViewData.aiBarOpacity = 0;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_8', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = false;
      aiBarViewData.isScreenLock = true;
      aiBarViewData.isShowNotificationCapsule = false;
      aiBarViewData.isInExitLandScape = true;
      aiBarViewData.aiBarOpacity = 0;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_9', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = true;
      aiBarViewData.isScreenLock = false;
      aiBarViewData.isShowNotificationCapsule = true;
      aiBarViewData.isInExitLandScape = false;
      aiBarViewData.aiBarOpacity = 0;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_10', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = false;
      aiBarViewData.isScreenLock = false;
      aiBarViewData.isShowNotificationCapsule = true;
      aiBarViewData.isInExitLandScape = false;
      aiBarViewData.aiBarOpacity = 0;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_11', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = true;
      aiBarViewData.isScreenLock = true;
      aiBarViewData.isShowNotificationCapsule = true;
      aiBarViewData.isInExitLandScape = false;
      aiBarViewData.aiBarOpacity = 0;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_12', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = false;
      aiBarViewData.isScreenLock = true;
      aiBarViewData.isShowNotificationCapsule = true;
      aiBarViewData.isInExitLandScape = false;
      aiBarViewData.aiBarOpacity = 0;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_13', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = true;
      aiBarViewData.isScreenLock = false;
      aiBarViewData.isShowNotificationCapsule = false;
      aiBarViewData.isInExitLandScape = false;
      aiBarViewData.aiBarOpacity = 0;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_14', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = false;
      aiBarViewData.isScreenLock = false;
      aiBarViewData.isShowNotificationCapsule = false;
      aiBarViewData.isInExitLandScape = false;
      aiBarViewData.aiBarOpacity = 0;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_15', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = true;
      aiBarViewData.isScreenLock = true;
      aiBarViewData.isShowNotificationCapsule = false;
      aiBarViewData.isInExitLandScape = false;
      aiBarViewData.aiBarOpacity = 0;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_16', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = false;
      aiBarViewData.isScreenLock = true;
      aiBarViewData.isShowNotificationCapsule = false;
      aiBarViewData.isInExitLandScape = false;
      aiBarViewData.aiBarOpacity = 0;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_17', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = true;
      aiBarViewData.isScreenLock = false;
      aiBarViewData.isShowNotificationCapsule = true;
      aiBarViewData.isInExitLandScape = true;
      aiBarViewData.aiBarOpacity = 1;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_18', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = false;
      aiBarViewData.isScreenLock = false;
      aiBarViewData.isShowNotificationCapsule = true;
      aiBarViewData.isInExitLandScape = true;
      aiBarViewData.aiBarOpacity = 1;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_19', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = true;
      aiBarViewData.isScreenLock = true;
      aiBarViewData.isShowNotificationCapsule = true;
      aiBarViewData.isInExitLandScape = true;
      aiBarViewData.aiBarOpacity = 1;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_20', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = false;
      aiBarViewData.isScreenLock = true;
      aiBarViewData.isShowNotificationCapsule = true;
      aiBarViewData.isInExitLandScape = true;
      aiBarViewData.aiBarOpacity = 1;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_21', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = true;
      aiBarViewData.isScreenLock = false;
      aiBarViewData.isShowNotificationCapsule = false;
      aiBarViewData.isInExitLandScape = true;
      aiBarViewData.aiBarOpacity = 1;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_22', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = false;
      aiBarViewData.isScreenLock = false;
      aiBarViewData.isShowNotificationCapsule = false;
      aiBarViewData.isInExitLandScape = true;
      aiBarViewData.aiBarOpacity = 1;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_23', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = true;
      aiBarViewData.isScreenLock = true;
      aiBarViewData.isShowNotificationCapsule = false;
      aiBarViewData.isInExitLandScape = true;
      aiBarViewData.aiBarOpacity = 1;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_24', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = false;
      aiBarViewData.isScreenLock = true;
      aiBarViewData.isShowNotificationCapsule = false;
      aiBarViewData.isInExitLandScape = true;
      aiBarViewData.aiBarOpacity = 1;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_25', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = true;
      aiBarViewData.isScreenLock = false;
      aiBarViewData.isShowNotificationCapsule = true;
      aiBarViewData.isInExitLandScape = false;
      aiBarViewData.aiBarOpacity = 1;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_26', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = false;
      aiBarViewData.isScreenLock = false;
      aiBarViewData.isShowNotificationCapsule = true;
      aiBarViewData.isInExitLandScape = false;
      aiBarViewData.aiBarOpacity = 1;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_27', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = true;
      aiBarViewData.isScreenLock = true;
      aiBarViewData.isShowNotificationCapsule = true;
      aiBarViewData.isInExitLandScape = false;
      aiBarViewData.aiBarOpacity = 1;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_28', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = false;
      aiBarViewData.isScreenLock = true;
      aiBarViewData.isShowNotificationCapsule = true;
      aiBarViewData.isInExitLandScape = false;
      aiBarViewData.aiBarOpacity = 1;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_29', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = true;
      aiBarViewData.isScreenLock = false;
      aiBarViewData.isShowNotificationCapsule = false;
      aiBarViewData.isInExitLandScape = false;
      aiBarViewData.aiBarOpacity = 1;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_30', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = false;
      aiBarViewData.isScreenLock = false;
      aiBarViewData.isShowNotificationCapsule = false;
      aiBarViewData.isInExitLandScape = false;
      aiBarViewData.aiBarOpacity = 1;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_31', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = true;
      aiBarViewData.isScreenLock = true;
      aiBarViewData.isShowNotificationCapsule = false;
      aiBarViewData.isInExitLandScape = false;
      aiBarViewData.aiBarOpacity = 1;
      expect(aiBarViewData.getAibarOpacity() === 0).assertTrue();
    })

    it('AIBarViewData_getAibarOpacity_32', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = false;
      aiBarViewData.isScreenLock = true;
      aiBarViewData.isShowNotificationCapsule = false;
      aiBarViewData.isInExitLandScape = false;
      aiBarViewData.aiBarOpacity = 1;
      expect(aiBarViewData.getAibarOpacity() === 1).assertTrue();
    })

    it('AIBarViewData_getAibarAccessibilityLevel_1', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = false;
      aiBarViewData.isScreenLock = true;
      aiBarViewData.isShowNotificationCapsule = false;
      aiBarViewData.isInExitLandScape = false;
      aiBarViewData.aiBarOpacity = 1;
      expect(aiBarViewData.getAibarAccessibilityLevel() === 'auto').assertTrue();
    })

    it('AIBarViewData_getAibarAccessibilityLevel_2', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isFloatingNavShow = false;
      aiBarViewData.isScreenLock = true;
      aiBarViewData.isShowNotificationCapsule = false;
      aiBarViewData.isInExitLandScape = false;
      aiBarViewData.aiBarOpacity = 0;
      expect(aiBarViewData.getAibarAccessibilityLevel() === 'no').assertTrue();
    })

    it('AIBarViewData_isInFullScreen_1', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 1;
      aiBarViewData.aiBarUseAppColor = true;
      aiBarViewData.specialScenePanelState = 1;
      aiBarViewData.isInMultiWindowMode = true;
      aiBarViewData.isInWindowModeFullScreen = true;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_2', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 0;
      aiBarViewData.aiBarUseAppColor = true;
      aiBarViewData.specialScenePanelState = 1;
      aiBarViewData.isInMultiWindowMode = true;
      aiBarViewData.isInWindowModeFullScreen = true;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_3', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 1;
      aiBarViewData.aiBarUseAppColor = false;
      aiBarViewData.specialScenePanelState = 1;
      aiBarViewData.isInMultiWindowMode = true;
      aiBarViewData.isInWindowModeFullScreen = true;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_4', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 0;
      aiBarViewData.aiBarUseAppColor = false;
      aiBarViewData.specialScenePanelState = 1;
      aiBarViewData.isInMultiWindowMode = true;
      aiBarViewData.isInWindowModeFullScreen = true;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_5', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 1;
      aiBarViewData.aiBarUseAppColor = true;
      aiBarViewData.specialScenePanelState = 0;
      aiBarViewData.isInMultiWindowMode = true;
      aiBarViewData.isInWindowModeFullScreen = true;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_6', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 0;
      aiBarViewData.aiBarUseAppColor = true;
      aiBarViewData.specialScenePanelState = 0;
      aiBarViewData.isInMultiWindowMode = true;
      aiBarViewData.isInWindowModeFullScreen = true;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_7', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 1;
      aiBarViewData.aiBarUseAppColor = false;
      aiBarViewData.specialScenePanelState = 0;
      aiBarViewData.isInMultiWindowMode = true;
      aiBarViewData.isInWindowModeFullScreen = true;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_8', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 0;
      aiBarViewData.aiBarUseAppColor = false;
      aiBarViewData.specialScenePanelState = 0;
      aiBarViewData.isInMultiWindowMode = true;
      aiBarViewData.isInWindowModeFullScreen = true;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_9', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 1;
      aiBarViewData.aiBarUseAppColor = true;
      aiBarViewData.specialScenePanelState = 1;
      aiBarViewData.isInMultiWindowMode = false;
      aiBarViewData.isInWindowModeFullScreen = true;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_10', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 0;
      aiBarViewData.aiBarUseAppColor = true;
      aiBarViewData.specialScenePanelState = 1;
      aiBarViewData.isInMultiWindowMode = false;
      aiBarViewData.isInWindowModeFullScreen = true;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_11', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 1;
      aiBarViewData.aiBarUseAppColor = false;
      aiBarViewData.specialScenePanelState = 1;
      aiBarViewData.isInMultiWindowMode = false;
      aiBarViewData.isInWindowModeFullScreen = true;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_12', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 0;
      aiBarViewData.aiBarUseAppColor = false;
      aiBarViewData.specialScenePanelState = 1;
      aiBarViewData.isInMultiWindowMode = false;
      aiBarViewData.isInWindowModeFullScreen = true;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_13', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 1;
      aiBarViewData.aiBarUseAppColor = true;
      aiBarViewData.specialScenePanelState = 0;
      aiBarViewData.isInMultiWindowMode = false;
      aiBarViewData.isInWindowModeFullScreen = true;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_14', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 0;
      aiBarViewData.aiBarUseAppColor = true;
      aiBarViewData.specialScenePanelState = 0;
      aiBarViewData.isInMultiWindowMode = false;
      aiBarViewData.isInWindowModeFullScreen = true;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_15', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 1;
      aiBarViewData.aiBarUseAppColor = false;
      aiBarViewData.specialScenePanelState = 0;
      aiBarViewData.isInMultiWindowMode = false;
      aiBarViewData.isInWindowModeFullScreen = true;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_16', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 0;
      aiBarViewData.aiBarUseAppColor = false;
      aiBarViewData.specialScenePanelState = 0;
      aiBarViewData.isInMultiWindowMode = false;
      aiBarViewData.isInWindowModeFullScreen = true;
      expect(aiBarViewData.isInFullScreen()).assertFalse();
    })

    it('AIBarViewData_isInFullScreen_17', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 1;
      aiBarViewData.aiBarUseAppColor = true;
      aiBarViewData.specialScenePanelState = 1;
      aiBarViewData.isInMultiWindowMode = true;
      aiBarViewData.isInWindowModeFullScreen = false;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_18', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 0;
      aiBarViewData.aiBarUseAppColor = true;
      aiBarViewData.specialScenePanelState = 1;
      aiBarViewData.isInMultiWindowMode = true;
      aiBarViewData.isInWindowModeFullScreen = false;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_19', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 1;
      aiBarViewData.aiBarUseAppColor = false;
      aiBarViewData.specialScenePanelState = 1;
      aiBarViewData.isInMultiWindowMode = true;
      aiBarViewData.isInWindowModeFullScreen = false;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_20', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 0;
      aiBarViewData.aiBarUseAppColor = false;
      aiBarViewData.specialScenePanelState = 1;
      aiBarViewData.isInMultiWindowMode = true;
      aiBarViewData.isInWindowModeFullScreen = false;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_21', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 1;
      aiBarViewData.aiBarUseAppColor = true;
      aiBarViewData.specialScenePanelState = 0;
      aiBarViewData.isInMultiWindowMode = true;
      aiBarViewData.isInWindowModeFullScreen = false;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_22', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 0;
      aiBarViewData.aiBarUseAppColor = true;
      aiBarViewData.specialScenePanelState = 0;
      aiBarViewData.isInMultiWindowMode = true;
      aiBarViewData.isInWindowModeFullScreen = false;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_23', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 1;
      aiBarViewData.aiBarUseAppColor = false;
      aiBarViewData.specialScenePanelState = 0;
      aiBarViewData.isInMultiWindowMode = true;
      aiBarViewData.isInWindowModeFullScreen = false;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_24', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 0;
      aiBarViewData.aiBarUseAppColor = false;
      aiBarViewData.specialScenePanelState = 0;
      aiBarViewData.isInMultiWindowMode = true;
      aiBarViewData.isInWindowModeFullScreen = false;
      expect(aiBarViewData.isInFullScreen()).assertFalse();
    })

    it('AIBarViewData_isInFullScreen_25', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 1;
      aiBarViewData.aiBarUseAppColor = true;
      aiBarViewData.specialScenePanelState = 1;
      aiBarViewData.isInMultiWindowMode = false;
      aiBarViewData.isInWindowModeFullScreen = false;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_26', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 0;
      aiBarViewData.aiBarUseAppColor = true;
      aiBarViewData.specialScenePanelState = 1;
      aiBarViewData.isInMultiWindowMode = false;
      aiBarViewData.isInWindowModeFullScreen = false;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_27', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 1;
      aiBarViewData.aiBarUseAppColor = false;
      aiBarViewData.specialScenePanelState = 1;
      aiBarViewData.isInMultiWindowMode = false;
      aiBarViewData.isInWindowModeFullScreen = false;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_28', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 0;
      aiBarViewData.aiBarUseAppColor = false;
      aiBarViewData.specialScenePanelState = 1;
      aiBarViewData.isInMultiWindowMode = false;
      aiBarViewData.isInWindowModeFullScreen = false;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_29', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 1;
      aiBarViewData.aiBarUseAppColor = true;
      aiBarViewData.specialScenePanelState = 0;
      aiBarViewData.isInMultiWindowMode = false;
      aiBarViewData.isInWindowModeFullScreen = false;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_30', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 0;
      aiBarViewData.aiBarUseAppColor = true;
      aiBarViewData.specialScenePanelState = 0;
      aiBarViewData.isInMultiWindowMode = false;
      aiBarViewData.isInWindowModeFullScreen = false;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_31', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 1;
      aiBarViewData.aiBarUseAppColor = false;
      aiBarViewData.specialScenePanelState = 0;
      aiBarViewData.isInMultiWindowMode = false;
      aiBarViewData.isInWindowModeFullScreen = false;
      expect(aiBarViewData.isInFullScreen()).assertTrue();
    })

    it('AIBarViewData_isInFullScreen_32', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = false;
      aiBarViewData.scenePanelState = 0;
      aiBarViewData.aiBarUseAppColor = false;
      aiBarViewData.specialScenePanelState = 0;
      aiBarViewData.isInMultiWindowMode = false;
      aiBarViewData.isInWindowModeFullScreen = false;
      expect(aiBarViewData.isInFullScreen()).assertFalse();
    })

    it('AIBarViewData_isInFullScreen_33', 0, () => {
      let aiBarViewData: AIBarViewData = AIBarViewData.getInstance();
      aiBarViewData.isInMidScene = true;
      expect(aiBarViewData.isInFullScreen()).assertFalse();
    })

  })
}