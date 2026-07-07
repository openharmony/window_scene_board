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
  AIBarClickBackgroundData
} from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/AIBarModel/AIBarClickBackgroundData';
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
import { CommonUtils } from '@ohos/basicutils';

export default function AIBarClickBackgroundDataTest() {
  describe('AIBarClickBackgroundDataTest', () => {
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

    it('AIBarClickBackgroundDataTest_get_aiBarBackgroundOpacity_0', 0, () => {
      let instance = AIBarClickBackgroundData.getInstance();
      instance.aiBarBackgroundOpacity_ = 0;
      expect(instance.aiBarBackgroundOpacity).assertEqual(0);
    })

    it('AIBarClickBackgroundDataTest_get_aiBarBackgroundOpacity_1', 0, () => {
      let instance = AIBarClickBackgroundData.getInstance();
      instance.aiBarBackgroundOpacity_ = 1;
      expect(instance.aiBarBackgroundOpacity).assertEqual(1);
    })

    it('AIBarClickBackgroundDataTest_get_aiBarBackgroundWidth_0', 0, () => {
      let instance = AIBarClickBackgroundData.getInstance();
      instance.aiBarBackgroundWidth_ = 0;
      expect(instance.aiBarBackgroundWidth).assertEqual(0);
    })

    it('AIBarClickBackgroundDataTest_get_aiBarBackgroundWidth_1', 0, () => {
      let instance = AIBarClickBackgroundData.getInstance();
      instance.aiBarBackgroundWidth_ = 1;
      expect(instance.aiBarBackgroundWidth).assertEqual(1);
    })

    it('AIBarClickBackgroundDataTest_set_aiBarBackgroundOpacity_0', 0, () => {
      let instance = AIBarClickBackgroundData.getInstance();
      instance.aiBarBackgroundOpacity = 0;
      expect(instance.aiBarBackgroundOpacity_).assertEqual(0);
    })

    it('AIBarClickBackgroundDataTest_set_aiBarBackgroundOpacity_1', 0, () => {
      let instance = AIBarClickBackgroundData.getInstance();
      instance.aiBarBackgroundOpacity = 1;
      expect(instance.aiBarBackgroundOpacity_).assertEqual(1);
    })

    it('AIBarClickBackgroundDataTest_set_aiBarBackgroundWidth_0', 0, () => {
      let instance = AIBarClickBackgroundData.getInstance();
      instance.aiBarBackgroundWidth = 0;
      expect(instance.aiBarBackgroundWidth_).assertEqual(0);
    })

    it('AIBarClickBackgroundDataTest_set_aiBarBackgroundWidth_1', 0, () => {
      let instance = AIBarClickBackgroundData.getInstance();
      instance.aiBarBackgroundWidth = 1;
      expect(instance.aiBarBackgroundWidth_).assertEqual(1);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_1', 0, () => {
      let aiBarClickBackgroundData = new AIBarClickBackgroundData();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarClickBackgroundData.aiBarBackgroundOpacity !== 0).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_2', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_3', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_4', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_5', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_6', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_7', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_8', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_9', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_10', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_11', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_12', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_13', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_14', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_15', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_16', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_17', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_18', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_19', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_20', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_21', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_22', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_23', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_24', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_25', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_26', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_27', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_28', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_29', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_30', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_31', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundOpacity_32', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundWidth_1', 0, () => {
      let aiBarClickBackgroundData = new AIBarClickBackgroundData();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarClickBackgroundData.aiBarBackgroundWidth === 0).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('AIBarClickBackgroundDataTest_aiBarBackgroundWidth_2', 0, () => {
      let aiBarClickBackgroundData = AIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((aiBarClickBackgroundData.aiBarBackgroundWidth = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })
  })
}