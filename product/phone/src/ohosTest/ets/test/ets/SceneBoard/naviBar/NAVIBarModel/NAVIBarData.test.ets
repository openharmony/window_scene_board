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
import { SCBVisualEffectMgr } from '@ohos/componenthelper';
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
import { NAVIBarData } from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/NAVIBarModel/NAVIBarData';
import { NAVIBarViewData } from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/NAVIBarModel/NAVIBarViewData';
import { WallpaperManager, WallpaperType } from '@ohos/frameworkwrapper';
import image from '@ohos.multimedia.image';

export default function NAVIBarDataTest() {
  describe('NAVIBarDataTest', () => {
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

    let naviBarData: NAVIBarData = new NAVIBarData();
    let naviBarViewData: NAVIBarViewData = new NAVIBarViewData();

    it('NAVIBarDataTest_getNAVIBarColor_1', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(true);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(true);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_2', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(true);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_3', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(true);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_4', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_5', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_6', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_7', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_8', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_9', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_10', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_11', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_12', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_13', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_14', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_15', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_16', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_17', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_18', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_19', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_20', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_21', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_22', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNAVIBarColor_23', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(naviBarViewData, naviBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      naviBarData.getNAVIBarColor(naviBarViewData);
      expect(naviBarData).not().assertFail();
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isInFullScreen);
      mockKit.ignoreMock(naviBarViewData, naviBarViewData.isNeedToUsePureColor);
      done();
    })

    it('NAVIBarDataTest_getNavibarAccessibilityLevel_1', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(naviBarViewData, naviBarViewData.getNavibarOpacity);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(0);
      expect(naviBarViewData.getNavibarAccessibilityLevel()).assertEqual('no');
      mocker.ignoreMock(naviBarViewData, naviBarViewData.getNavibarOpacity)
      done();
    })

    it('NAVIBarDataTest_getNavibarAccessibilityLevel_2', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(naviBarViewData, naviBarViewData.getNavibarOpacity);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      expect(naviBarViewData.getNavibarAccessibilityLevel()).assertEqual('auto');
      mocker.ignoreMock(naviBarViewData, naviBarViewData.getNavibarOpacity)
      done();
    })

    it('NAVIBarDataTest_getNAVIBarPureColorMode_1', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getFeatureParam = mocker.mockFunc(SCBVisualEffectMgr, SCBVisualEffectMgr.getFeatureParam);
      when(getFeatureParam)(ArgumentMatchers.any).afterThrow('getFeatureParam is fail');
      expect((naviBarData as object)['getNAVIBarPureColorMode']).not().assertFail();
      mocker.ignoreMock(SCBVisualEffectMgr, SCBVisualEffectMgr.getFeatureParam);
      done();
    })
  })
}