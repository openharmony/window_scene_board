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
import { AIBarData } from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/AIBarModel/AIBarData';
import { AIBarViewData } from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/AIBarModel/AIBarViewData';
import { WallpaperManager, WallpaperType } from '@ohos/frameworkwrapper';
import image from '@ohos.multimedia.image';

export default function AIBarDataTest() {
  describe('AIBarDataTest', () => {
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

    let aiBarData: AIBarData = new AIBarData();
    let aiBarViewData: AIBarViewData = new AIBarViewData();

    it('AIBarDataTest_getAIBarColor_1', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(true);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(true);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_2', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(true);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_3', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(true);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_4', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_5', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_6', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_7', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_8', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_9', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_10', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_11', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_12', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_13', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_14', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_15', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_16', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_17', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_18', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_19', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_20', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_21', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_22', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAIBarColor_23', 0, async (done: Function) => {
      let mockKit = new MockKit();
      let isInFullScreen = mockKit.mockFunc(aiBarViewData, aiBarViewData.isInFullScreen);
      when(isInFullScreen)(ArgumentMatchers.any).afterReturn(false);
      let isNeedToUsePureColor = mockKit.mockFunc(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      when(isNeedToUsePureColor)(ArgumentMatchers.any).afterReturn(false);
      aiBarData.getAIBarColor(aiBarViewData);
      expect(aiBarData).not().assertFail();
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isInFullScreen);
      mockKit.ignoreMock(aiBarViewData, aiBarViewData.isNeedToUsePureColor);
      done();
    })

    it('AIBarDataTest_getAibarAccessibilityLevel_1', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(aiBarViewData, aiBarViewData.getAibarOpacity);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(0);
      expect(aiBarViewData.getAibarAccessibilityLevel()).assertEqual('no');
      mocker.ignoreMock(aiBarViewData, aiBarViewData.getAibarOpacity)
      done();
    })

    it('AIBarDataTest_getAibarAccessibilityLevel_2', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(aiBarViewData, aiBarViewData.getAibarOpacity);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      expect(aiBarViewData.getAibarAccessibilityLevel()).assertEqual('auto');
      mocker.ignoreMock(aiBarViewData, aiBarViewData.getAibarOpacity)
      done();
    })

    it('AIBarDataTest_getAIBarPureColorMode_1', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getFeatureParam = mocker.mockFunc(SCBVisualEffectMgr, SCBVisualEffectMgr.getFeatureParam);
      when(getFeatureParam)(ArgumentMatchers.any).afterThrow('getFeatureParam is fail');
      expect((aiBarData as object)['getAIBarPureColorMode']).not().assertFail();
      mocker.ignoreMock(SCBVisualEffectMgr, SCBVisualEffectMgr.getFeatureParam);
      done();
    })
  })
}