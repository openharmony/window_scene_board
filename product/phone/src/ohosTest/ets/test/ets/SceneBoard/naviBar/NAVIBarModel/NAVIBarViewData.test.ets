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
  NAVIBarViewData
} from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/NAVIBarModel/NAVIBarViewData'

export default function NAVIBarViewDataTest() {
  describe('NAVIBarViewDataTest', () => {
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

    it('NAVIBarViewData_isNeedToUsePureColor_1', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.powerMode = 601;
      naviBarViewData.thermalLevel = 10;
      naviBarViewData.isEnterDeliver = true;
      let data = naviBarViewData as object;
      data['naviBarData'].naviBarPureColorMode = true;
      expect(naviBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('NAVIBarViewData_isNeedToUsePureColor_2', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.powerMode = 0;
      naviBarViewData.thermalLevel = 10;
      naviBarViewData.isEnterDeliver = true;
      let data = naviBarViewData as object;
      data['naviBarData'].naviBarPureColorMode = true;
      expect(naviBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('NAVIBarViewData_isNeedToUsePureColor_3', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.powerMode = 601;
      naviBarViewData.thermalLevel = 0;
      naviBarViewData.isEnterDeliver = true;
      let data = naviBarViewData as object;
      data['naviBarData'].naviBarPureColorMode = true;
      expect(naviBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('NAVIBarViewData_isNeedToUsePureColor_4', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.powerMode = 0;
      naviBarViewData.thermalLevel = 0;
      naviBarViewData.isEnterDeliver = true;
      let data = naviBarViewData as object;
      data['naviBarData'].naviBarPureColorMode = true;
      expect(naviBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('NAVIBarViewData_isNeedToUsePureColor_5', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.powerMode = 601;
      naviBarViewData.thermalLevel = 10;
      naviBarViewData.isEnterDeliver = false;
      let data = naviBarViewData as object;
      data['naviBarData'].naviBarPureColorMode = true;
      expect(naviBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('NAVIBarViewData_isNeedToUsePureColor_6', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.powerMode = 0;
      naviBarViewData.thermalLevel = 10;
      naviBarViewData.isEnterDeliver = false;
      let data = naviBarViewData as object;
      data['naviBarData'].naviBarPureColorMode = true;
      expect(naviBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('NAVIBarViewData_isNeedToUsePureColor_7', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.powerMode = 601;
      naviBarViewData.thermalLevel = 0;
      naviBarViewData.isEnterDeliver = false;
      let data = naviBarViewData as object;
      data['naviBarData'].naviBarPureColorMode = true;
      expect(naviBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('NAVIBarViewData_isNeedToUsePureColor_8', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.powerMode = 0;
      naviBarViewData.thermalLevel = 0;
      naviBarViewData.isEnterDeliver = false;
      let data = naviBarViewData as object;
      data['naviBarData'].naviBarPureColorMode = true;
      expect(naviBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('NAVIBarViewData_isNeedToUsePureColor_9', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.powerMode = 601;
      naviBarViewData.thermalLevel = 10;
      naviBarViewData.isEnterDeliver = true;
      let data = naviBarViewData as object;
      data['naviBarData'].naviBarPureColorMode = false;
      expect(naviBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('NAVIBarViewData_isNeedToUsePureColor_10', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.powerMode = 0;
      naviBarViewData.thermalLevel = 10;
      naviBarViewData.isEnterDeliver = true;
      let data = naviBarViewData as object;
      data['naviBarData'].naviBarPureColorMode = false;
      expect(naviBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('NAVIBarViewData_isNeedToUsePureColor_11', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.powerMode = 601;
      naviBarViewData.thermalLevel = 0;
      naviBarViewData.isEnterDeliver = true;
      let data = naviBarViewData as object;
      data['naviBarData'].naviBarPureColorMode = false;
      expect(naviBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('NAVIBarViewData_isNeedToUsePureColor_12', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.powerMode = 0;
      naviBarViewData.thermalLevel = 0;
      naviBarViewData.isEnterDeliver = true;
      let data = naviBarViewData as object;
      data['naviBarData'].naviBarPureColorMode = false;
      expect(naviBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('NAVIBarViewData_isNeedToUsePureColor_13', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.powerMode = 601;
      naviBarViewData.thermalLevel = 10;
      naviBarViewData.isEnterDeliver = false;
      let data = naviBarViewData as object;
      data['naviBarData'].naviBarPureColorMode = false;
      expect(naviBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('NAVIBarViewData_isNeedToUsePureColor_14', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.powerMode = 0;
      naviBarViewData.thermalLevel = 10;
      naviBarViewData.isEnterDeliver = false;
      let data = naviBarViewData as object;
      data['naviBarData'].naviBarPureColorMode = false;
      expect(naviBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('NAVIBarViewData_isNeedToUsePureColor_15', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.powerMode = 601;
      naviBarViewData.thermalLevel = 0;
      naviBarViewData.isEnterDeliver = false;
      let data = naviBarViewData as object;
      data['naviBarData'].naviBarPureColorMode = false;
      expect(naviBarViewData.isNeedToUsePureColor()).assertTrue();
    })

    it('NAVIBarViewData_isNeedToUsePureColor_16', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.powerMode = 0;
      naviBarViewData.thermalLevel = 0;
      naviBarViewData.isEnterDeliver = false;
      let data = naviBarViewData as object;
      data['naviBarData'].naviBarPureColorMode = false;
      expect(naviBarViewData.isNeedToUsePureColor()).assertFalse();
    })



    it('NAVIBarViewData_getNavibarOpacity_1', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = true;
      naviBarViewData.isScreenLock = false;
      naviBarViewData.isShowNotificationCapsule = true;
      naviBarViewData.isInExitLandScape = true;
      naviBarViewData.naviBarOpacity = 0;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_2', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = false;
      naviBarViewData.isScreenLock = false;
      naviBarViewData.isShowNotificationCapsule = true;
      naviBarViewData.isInExitLandScape = true;
      naviBarViewData.naviBarOpacity = 0;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_3', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = true;
      naviBarViewData.isScreenLock = true;
      naviBarViewData.isShowNotificationCapsule = true;
      naviBarViewData.isInExitLandScape = true;
      naviBarViewData.naviBarOpacity = 0;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_4', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = false;
      naviBarViewData.isScreenLock = true;
      naviBarViewData.isShowNotificationCapsule = true;
      naviBarViewData.isInExitLandScape = true;
      naviBarViewData.naviBarOpacity = 0;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_5', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = true;
      naviBarViewData.isScreenLock = false;
      naviBarViewData.isShowNotificationCapsule = false;
      naviBarViewData.isInExitLandScape = true;
      naviBarViewData.naviBarOpacity = 0;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_6', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = false;
      naviBarViewData.isScreenLock = false;
      naviBarViewData.isShowNotificationCapsule = false;
      naviBarViewData.isInExitLandScape = true;
      naviBarViewData.naviBarOpacity = 0;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_7', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = true;
      naviBarViewData.isScreenLock = true;
      naviBarViewData.isShowNotificationCapsule = false;
      naviBarViewData.isInExitLandScape = true;
      naviBarViewData.naviBarOpacity = 0;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_8', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = false;
      naviBarViewData.isScreenLock = true;
      naviBarViewData.isShowNotificationCapsule = false;
      naviBarViewData.isInExitLandScape = true;
      naviBarViewData.naviBarOpacity = 0;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_9', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = true;
      naviBarViewData.isScreenLock = false;
      naviBarViewData.isShowNotificationCapsule = true;
      naviBarViewData.isInExitLandScape = false;
      naviBarViewData.naviBarOpacity = 0;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_10', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = false;
      naviBarViewData.isScreenLock = false;
      naviBarViewData.isShowNotificationCapsule = true;
      naviBarViewData.isInExitLandScape = false;
      naviBarViewData.naviBarOpacity = 0;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_11', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = true;
      naviBarViewData.isScreenLock = true;
      naviBarViewData.isShowNotificationCapsule = true;
      naviBarViewData.isInExitLandScape = false;
      naviBarViewData.naviBarOpacity = 0;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_12', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = false;
      naviBarViewData.isScreenLock = true;
      naviBarViewData.isShowNotificationCapsule = true;
      naviBarViewData.isInExitLandScape = false;
      naviBarViewData.naviBarOpacity = 0;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_13', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = true;
      naviBarViewData.isScreenLock = false;
      naviBarViewData.isShowNotificationCapsule = false;
      naviBarViewData.isInExitLandScape = false;
      naviBarViewData.naviBarOpacity = 0;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_14', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = false;
      naviBarViewData.isScreenLock = false;
      naviBarViewData.isShowNotificationCapsule = false;
      naviBarViewData.isInExitLandScape = false;
      naviBarViewData.naviBarOpacity = 0;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_15', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = true;
      naviBarViewData.isScreenLock = true;
      naviBarViewData.isShowNotificationCapsule = false;
      naviBarViewData.isInExitLandScape = false;
      naviBarViewData.naviBarOpacity = 0;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_16', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = false;
      naviBarViewData.isScreenLock = true;
      naviBarViewData.isShowNotificationCapsule = false;
      naviBarViewData.isInExitLandScape = false;
      naviBarViewData.naviBarOpacity = 0;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_17', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = true;
      naviBarViewData.isScreenLock = false;
      naviBarViewData.isShowNotificationCapsule = true;
      naviBarViewData.isInExitLandScape = true;
      naviBarViewData.naviBarOpacity = 1;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_18', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = false;
      naviBarViewData.isScreenLock = false;
      naviBarViewData.isShowNotificationCapsule = true;
      naviBarViewData.isInExitLandScape = true;
      naviBarViewData.naviBarOpacity = 1;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_19', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = true;
      naviBarViewData.isScreenLock = true;
      naviBarViewData.isShowNotificationCapsule = true;
      naviBarViewData.isInExitLandScape = true;
      naviBarViewData.naviBarOpacity = 1;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_20', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = false;
      naviBarViewData.isScreenLock = true;
      naviBarViewData.isShowNotificationCapsule = true;
      naviBarViewData.isInExitLandScape = true;
      naviBarViewData.naviBarOpacity = 1;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_21', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = true;
      naviBarViewData.isScreenLock = false;
      naviBarViewData.isShowNotificationCapsule = false;
      naviBarViewData.isInExitLandScape = true;
      naviBarViewData.naviBarOpacity = 1;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_22', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = false;
      naviBarViewData.isScreenLock = false;
      naviBarViewData.isShowNotificationCapsule = false;
      naviBarViewData.isInExitLandScape = true;
      naviBarViewData.naviBarOpacity = 1;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_23', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = true;
      naviBarViewData.isScreenLock = true;
      naviBarViewData.isShowNotificationCapsule = false;
      naviBarViewData.isInExitLandScape = true;
      naviBarViewData.naviBarOpacity = 1;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_24', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = false;
      naviBarViewData.isScreenLock = true;
      naviBarViewData.isShowNotificationCapsule = false;
      naviBarViewData.isInExitLandScape = true;
      naviBarViewData.naviBarOpacity = 1;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_25', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = true;
      naviBarViewData.isScreenLock = false;
      naviBarViewData.isShowNotificationCapsule = true;
      naviBarViewData.isInExitLandScape = false;
      naviBarViewData.naviBarOpacity = 1;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_26', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = false;
      naviBarViewData.isScreenLock = false;
      naviBarViewData.isShowNotificationCapsule = true;
      naviBarViewData.isInExitLandScape = false;
      naviBarViewData.naviBarOpacity = 1;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_27', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = true;
      naviBarViewData.isScreenLock = true;
      naviBarViewData.isShowNotificationCapsule = true;
      naviBarViewData.isInExitLandScape = false;
      naviBarViewData.naviBarOpacity = 1;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_28', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = false;
      naviBarViewData.isScreenLock = true;
      naviBarViewData.isShowNotificationCapsule = true;
      naviBarViewData.isInExitLandScape = false;
      naviBarViewData.naviBarOpacity = 1;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_29', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = true;
      naviBarViewData.isScreenLock = false;
      naviBarViewData.isShowNotificationCapsule = false;
      naviBarViewData.isInExitLandScape = false;
      naviBarViewData.naviBarOpacity = 1;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_30', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = false;
      naviBarViewData.isScreenLock = false;
      naviBarViewData.isShowNotificationCapsule = false;
      naviBarViewData.isInExitLandScape = false;
      naviBarViewData.naviBarOpacity = 1;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_31', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = true;
      naviBarViewData.isScreenLock = true;
      naviBarViewData.isShowNotificationCapsule = false;
      naviBarViewData.isInExitLandScape = false;
      naviBarViewData.naviBarOpacity = 1;
      expect(naviBarViewData.getNavibarOpacity() === 0).assertTrue();
    })

    it('NAVIBarViewData_getNavibarOpacity_32', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = false;
      naviBarViewData.isScreenLock = true;
      naviBarViewData.isShowNotificationCapsule = false;
      naviBarViewData.isInExitLandScape = false;
      naviBarViewData.naviBarOpacity = 1;
      expect(naviBarViewData.getNavibarOpacity() === 1).assertTrue();
    })

    it('NAVIBarViewData_getNavibarAccessibilityLevel_1', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = false;
      naviBarViewData.isScreenLock = true;
      naviBarViewData.isShowNotificationCapsule = false;
      naviBarViewData.isInExitLandScape = false;
      naviBarViewData.naviBarOpacity = 1;
      expect(naviBarViewData.getNavibarAccessibilityLevel() === 'auto').assertTrue();
    })

    it('NAVIBarViewData_getNavibarAccessibilityLevel_2', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isFloatingNavShow = false;
      naviBarViewData.isScreenLock = true;
      naviBarViewData.isShowNotificationCapsule = false;
      naviBarViewData.isInExitLandScape = false;
      naviBarViewData.naviBarOpacity = 0;
      expect(naviBarViewData.getNavibarAccessibilityLevel() === 'no').assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_1', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 1;
      naviBarViewData.naviBarUseAppColor = true;
      naviBarViewData.specialScenePanelState = 1;
      naviBarViewData.isInMultiWindowMode = true;
      naviBarViewData.isInWindowModeFullScreen = true;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_2', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 0;
      naviBarViewData.naviBarUseAppColor = true;
      naviBarViewData.specialScenePanelState = 1;
      naviBarViewData.isInMultiWindowMode = true;
      naviBarViewData.isInWindowModeFullScreen = true;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_3', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 1;
      naviBarViewData.naviBarUseAppColor = false;
      naviBarViewData.specialScenePanelState = 1;
      naviBarViewData.isInMultiWindowMode = true;
      naviBarViewData.isInWindowModeFullScreen = true;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_4', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 0;
      naviBarViewData.naviBarUseAppColor = false;
      naviBarViewData.specialScenePanelState = 1;
      naviBarViewData.isInMultiWindowMode = true;
      naviBarViewData.isInWindowModeFullScreen = true;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_5', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 1;
      naviBarViewData.naviBarUseAppColor = true;
      naviBarViewData.specialScenePanelState = 0;
      naviBarViewData.isInMultiWindowMode = true;
      naviBarViewData.isInWindowModeFullScreen = true;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_6', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 0;
      naviBarViewData.naviBarUseAppColor = true;
      naviBarViewData.specialScenePanelState = 0;
      naviBarViewData.isInMultiWindowMode = true;
      naviBarViewData.isInWindowModeFullScreen = true;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_7', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 1;
      naviBarViewData.naviBarUseAppColor = false;
      naviBarViewData.specialScenePanelState = 0;
      naviBarViewData.isInMultiWindowMode = true;
      naviBarViewData.isInWindowModeFullScreen = true;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_8', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 0;
      naviBarViewData.naviBarUseAppColor = false;
      naviBarViewData.specialScenePanelState = 0;
      naviBarViewData.isInMultiWindowMode = true;
      naviBarViewData.isInWindowModeFullScreen = true;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_9', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 1;
      naviBarViewData.naviBarUseAppColor = true;
      naviBarViewData.specialScenePanelState = 1;
      naviBarViewData.isInMultiWindowMode = false;
      naviBarViewData.isInWindowModeFullScreen = true;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_10', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 0;
      naviBarViewData.naviBarUseAppColor = true;
      naviBarViewData.specialScenePanelState = 1;
      naviBarViewData.isInMultiWindowMode = false;
      naviBarViewData.isInWindowModeFullScreen = true;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_11', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 1;
      naviBarViewData.naviBarUseAppColor = false;
      naviBarViewData.specialScenePanelState = 1;
      naviBarViewData.isInMultiWindowMode = false;
      naviBarViewData.isInWindowModeFullScreen = true;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_12', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 0;
      naviBarViewData.naviBarUseAppColor = false;
      naviBarViewData.specialScenePanelState = 1;
      naviBarViewData.isInMultiWindowMode = false;
      naviBarViewData.isInWindowModeFullScreen = true;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_13', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 1;
      naviBarViewData.naviBarUseAppColor = true;
      naviBarViewData.specialScenePanelState = 0;
      naviBarViewData.isInMultiWindowMode = false;
      naviBarViewData.isInWindowModeFullScreen = true;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_14', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 0;
      naviBarViewData.naviBarUseAppColor = true;
      naviBarViewData.specialScenePanelState = 0;
      naviBarViewData.isInMultiWindowMode = false;
      naviBarViewData.isInWindowModeFullScreen = true;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_15', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 1;
      naviBarViewData.naviBarUseAppColor = false;
      naviBarViewData.specialScenePanelState = 0;
      naviBarViewData.isInMultiWindowMode = false;
      naviBarViewData.isInWindowModeFullScreen = true;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_16', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 0;
      naviBarViewData.naviBarUseAppColor = false;
      naviBarViewData.specialScenePanelState = 0;
      naviBarViewData.isInMultiWindowMode = false;
      naviBarViewData.isInWindowModeFullScreen = true;
      expect(naviBarViewData.isInFullScreen()).assertFalse();
    })

    it('NAVIBarViewData_isInFullScreen_17', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 1;
      naviBarViewData.naviBarUseAppColor = true;
      naviBarViewData.specialScenePanelState = 1;
      naviBarViewData.isInMultiWindowMode = true;
      naviBarViewData.isInWindowModeFullScreen = false;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_18', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 0;
      naviBarViewData.naviBarUseAppColor = true;
      naviBarViewData.specialScenePanelState = 1;
      naviBarViewData.isInMultiWindowMode = true;
      naviBarViewData.isInWindowModeFullScreen = false;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_19', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 1;
      naviBarViewData.naviBarUseAppColor = false;
      naviBarViewData.specialScenePanelState = 1;
      naviBarViewData.isInMultiWindowMode = true;
      naviBarViewData.isInWindowModeFullScreen = false;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_20', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 0;
      naviBarViewData.naviBarUseAppColor = false;
      naviBarViewData.specialScenePanelState = 1;
      naviBarViewData.isInMultiWindowMode = true;
      naviBarViewData.isInWindowModeFullScreen = false;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_21', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 1;
      naviBarViewData.naviBarUseAppColor = true;
      naviBarViewData.specialScenePanelState = 0;
      naviBarViewData.isInMultiWindowMode = true;
      naviBarViewData.isInWindowModeFullScreen = false;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_22', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 0;
      naviBarViewData.naviBarUseAppColor = true;
      naviBarViewData.specialScenePanelState = 0;
      naviBarViewData.isInMultiWindowMode = true;
      naviBarViewData.isInWindowModeFullScreen = false;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_23', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 1;
      naviBarViewData.naviBarUseAppColor = false;
      naviBarViewData.specialScenePanelState = 0;
      naviBarViewData.isInMultiWindowMode = true;
      naviBarViewData.isInWindowModeFullScreen = false;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_24', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 0;
      naviBarViewData.naviBarUseAppColor = false;
      naviBarViewData.specialScenePanelState = 0;
      naviBarViewData.isInMultiWindowMode = true;
      naviBarViewData.isInWindowModeFullScreen = false;
      expect(naviBarViewData.isInFullScreen()).assertFalse();
    })

    it('NAVIBarViewData_isInFullScreen_25', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 1;
      naviBarViewData.naviBarUseAppColor = true;
      naviBarViewData.specialScenePanelState = 1;
      naviBarViewData.isInMultiWindowMode = false;
      naviBarViewData.isInWindowModeFullScreen = false;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_26', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 0;
      naviBarViewData.naviBarUseAppColor = true;
      naviBarViewData.specialScenePanelState = 1;
      naviBarViewData.isInMultiWindowMode = false;
      naviBarViewData.isInWindowModeFullScreen = false;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_27', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 1;
      naviBarViewData.naviBarUseAppColor = false;
      naviBarViewData.specialScenePanelState = 1;
      naviBarViewData.isInMultiWindowMode = false;
      naviBarViewData.isInWindowModeFullScreen = false;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_28', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 0;
      naviBarViewData.naviBarUseAppColor = false;
      naviBarViewData.specialScenePanelState = 1;
      naviBarViewData.isInMultiWindowMode = false;
      naviBarViewData.isInWindowModeFullScreen = false;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_29', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 1;
      naviBarViewData.naviBarUseAppColor = true;
      naviBarViewData.specialScenePanelState = 0;
      naviBarViewData.isInMultiWindowMode = false;
      naviBarViewData.isInWindowModeFullScreen = false;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_30', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 0;
      naviBarViewData.naviBarUseAppColor = true;
      naviBarViewData.specialScenePanelState = 0;
      naviBarViewData.isInMultiWindowMode = false;
      naviBarViewData.isInWindowModeFullScreen = false;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_31', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 1;
      naviBarViewData.naviBarUseAppColor = false;
      naviBarViewData.specialScenePanelState = 0;
      naviBarViewData.isInMultiWindowMode = false;
      naviBarViewData.isInWindowModeFullScreen = false;
      expect(naviBarViewData.isInFullScreen()).assertTrue();
    })

    it('NAVIBarViewData_isInFullScreen_32', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = false;
      naviBarViewData.scenePanelState = 0;
      naviBarViewData.naviBarUseAppColor = false;
      naviBarViewData.specialScenePanelState = 0;
      naviBarViewData.isInMultiWindowMode = false;
      naviBarViewData.isInWindowModeFullScreen = false;
      expect(naviBarViewData.isInFullScreen()).assertFalse();
    })

    it('NAVIBarViewData_isInFullScreen_33', 0, () => {
      let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
      naviBarViewData.isInMidScene = true;
      expect(naviBarViewData.isInFullScreen()).assertFalse();
    })

  })
}