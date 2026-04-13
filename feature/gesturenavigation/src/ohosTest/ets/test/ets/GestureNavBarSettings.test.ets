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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when,
  ArgumentMatchers,
  Level
} from '@ohos/hypium'
import { gestureNavBarCcmSettings } from '@ohos/componenthelper'
import { GestureNavBarConstants } from '../../../../main/ets/constants/CommonConstants';
import { GestureNavBarSettings } from '../../../../main/ets/GestureNavBarSettings';

export function GestureNavBarSettingsTest() {
  describe('GestureNavBarSettingsTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.·
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

    it('GestureNavBarSettingsTest_getLandscapeWindowWidthPercent_1', Level.LEVEL0, (): void => {
      let gestureNavBarSettings: GestureNavBarSettings = new GestureNavBarSettings();
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc(gestureNavBarCcmSettings,
        gestureNavBarCcmSettings.getNavBarLandscapeWindowWidthPercent);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      expect(gestureNavBarSettings.getLandscapeWindowWidthPercent(100) === 100).assertTrue();
      mocker.ignoreMock(gestureNavBarCcmSettings, gestureNavBarCcmSettings.getNavBarLandscapeWindowWidthPercent);
    });

    it('GestureNavBarSettingsTest_getLandscapeWindowWidthPercent_2', Level.LEVEL0, (): void => {
      let gestureNavBarSettings: GestureNavBarSettings = new GestureNavBarSettings();
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc(gestureNavBarCcmSettings,
        gestureNavBarCcmSettings.getNavBarLandscapeWindowWidthPercent);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(200);
      expect(gestureNavBarSettings.getLandscapeWindowWidthPercent(100) === 200).assertTrue();
      mocker.ignoreMock(gestureNavBarCcmSettings, gestureNavBarCcmSettings.getNavBarLandscapeWindowWidthPercent);
    });

    it('GestureNavBarSettingsTest_getAiBarMarginBottom_1', Level.LEVEL0, (): void => {
      let gestureNavBarSettings: GestureNavBarSettings = new GestureNavBarSettings();
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc(gestureNavBarCcmSettings, gestureNavBarCcmSettings.getAiBarMarginBottom);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      expect(gestureNavBarSettings.getAiBarMarginBottom() === GestureNavBarConstants.AIBAR_DEFAULT_BOTTOM_MARGIN)
        .assertTrue();
      mocker.ignoreMock(gestureNavBarCcmSettings, gestureNavBarCcmSettings.getAiBarMarginBottom);
    });

    it('GestureNavBarSettingsTest_getAiBarMarginBottom_2', Level.LEVEL0, (): void => {
      let gestureNavBarSettings: GestureNavBarSettings = new GestureNavBarSettings();
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc(gestureNavBarCcmSettings, gestureNavBarCcmSettings.getAiBarMarginBottom);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(8);
      expect(gestureNavBarSettings.getAiBarMarginBottom() === 8).assertTrue();
      mocker.ignoreMock(gestureNavBarCcmSettings, gestureNavBarCcmSettings.getAiBarMarginBottom);
    });
  });
}