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
  NAVIBarClickBackgroundData
} from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/NAVIBarModel/NAVIBarClickBackgroundData';
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

export default function NAVIBarClickBackgroundDataTest() {
  describe('NAVIBarClickBackgroundDataTest', () => {
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

    it('NAVIBarClickBackgroundDataTest_get_naviBarBackgroundOpacity_0', 0, () => {
      let instance = NAVIBarClickBackgroundData.getInstance();
      instance.naviBarBackgroundOpacity_ = 0;
      expect(instance.naviBarBackgroundOpacity).assertEqual(0);
    })

    it('NAVIBarClickBackgroundDataTest_get_naviBarBackgroundOpacity_1', 0, () => {
      let instance = NAVIBarClickBackgroundData.getInstance();
      instance.naviBarBackgroundOpacity_ = 1;
      expect(instance.naviBarBackgroundOpacity).assertEqual(1);
    })

    it('NAVIBarClickBackgroundDataTest_get_naviBarBackgroundWidth_0', 0, () => {
      let instance = NAVIBarClickBackgroundData.getInstance();
      instance.naviBarBackgroundWidth_ = 0;
      expect(instance.naviBarBackgroundWidth).assertEqual(0);
    })

    it('NAVIBarClickBackgroundDataTest_get_naviBarBackgroundWidth_1', 0, () => {
      let instance = NAVIBarClickBackgroundData.getInstance();
      instance.naviBarBackgroundWidth_ = 1;
      expect(instance.naviBarBackgroundWidth).assertEqual(1);
    })

    it('NAVIBarClickBackgroundDataTest_set_naviBarBackgroundOpacity_0', 0, () => {
      let instance = NAVIBarClickBackgroundData.getInstance();
      instance.naviBarBackgroundOpacity = 0;
      expect(instance.naviBarBackgroundOpacity_).assertEqual(0);
    })

    it('NAVIBarClickBackgroundDataTest_set_naviBarBackgroundOpacity_1', 0, () => {
      let instance = NAVIBarClickBackgroundData.getInstance();
      instance.naviBarBackgroundOpacity = 1;
      expect(instance.naviBarBackgroundOpacity_).assertEqual(1);
    })

    it('NAVIBarClickBackgroundDataTest_set_naviBarBackgroundWidth_0', 0, () => {
      let instance = NAVIBarClickBackgroundData.getInstance();
      instance.naviBarBackgroundWidth = 0;
      expect(instance.naviBarBackgroundWidth_).assertEqual(0);
    })

    it('NAVIBarClickBackgroundDataTest_set_naviBarBackgroundWidth_1', 0, () => {
      let instance = NAVIBarClickBackgroundData.getInstance();
      instance.naviBarBackgroundWidth = 1;
      expect(instance.naviBarBackgroundWidth_).assertEqual(1);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_1', 0, () => {
      let naviBarClickBackgroundData = new NAVIBarClickBackgroundData();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarClickBackgroundData.naviBarBackgroundOpacity !== 0).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_2', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_3', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_4', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_5', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_6', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_7', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_8', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_9', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_10', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_11', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_12', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_13', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_14', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_15', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_16', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_17', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_18', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_19', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_20', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_21', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_22', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_23', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_24', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_25', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_26', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_27', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_28', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_29', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_30', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_31', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundOpacity_32', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundOpacity = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundWidth_1', 0, () => {
      let naviBarClickBackgroundData = new NAVIBarClickBackgroundData();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarClickBackgroundData.naviBarBackgroundWidth === 0).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })

    it('NAVIBarClickBackgroundDataTest_naviBarBackgroundWidth_2', 0, () => {
      let naviBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.equals);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((naviBarClickBackgroundData.naviBarBackgroundWidth = 1) === undefined).assertFalse();
      mocker.ignoreMock(CommonUtils, CommonUtils.equals);
    })
  })
}