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
import { gestureBackCcmSettings } from '@ohos/componenthelper'
import { GestureBackConstants } from '../../../../../main/ets/common/GestureBackConstants';
import { gestureBackSettings } from '../../../../../main/ets/common/GestureBackSettings';

export function GestureBackSettingsTest() {
  describe('GestureBackSettingsTest', () => {
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

    it('GestureBackSettingsTest_getBackResponseRegionWidth_1', Level.LEVEL0, (): void => {
      let mocker = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureBackCcmSettings, gestureBackCcmSettings.getBackResponseRegionWidth);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      expect(gestureBackSettings.getBackResponseRegionWidth() === GestureBackConstants.BACK_WIDTH).assertTrue();
      mocker.ignoreMock(gestureBackCcmSettings, gestureBackCcmSettings.getBackResponseRegionWidth);
    });

    it('GestureBackSettingsTest_getBackTimeThreshold_1', Level.LEVEL0, (): void => {
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc(gestureBackCcmSettings, gestureBackCcmSettings.getBackTimeThreshold);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      expect(gestureBackSettings.getBackTimeThreshold() === GestureBackConstants.BACK_TIME_THRESHOLD).assertTrue();
      mocker.ignoreMock(gestureBackCcmSettings, gestureBackCcmSettings.getBackTimeThreshold);
    });

    it('GestureBackSettingsTest_getBackDistanceThreshold_1', Level.LEVEL0, (): void => {
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc(gestureBackCcmSettings, gestureBackCcmSettings.getBackDistanceThreshold);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      expect(gestureBackSettings.getBackDistanceThreshold() === GestureBackConstants.BACK_DISTANCE_THRESHOLD)
        .assertTrue();
      mocker.ignoreMock(gestureBackCcmSettings, gestureBackCcmSettings.getBackDistanceThreshold);
    });

    it('GestureBackSettingsTest_needBackExtrudeAnim_1', Level.LEVEL0, (): void => {
      let mocker = new MockKit();
      let mockFunc: Function = mocker.mockFunc(gestureBackCcmSettings, gestureBackCcmSettings.needBackExtrudeAnim);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      expect(gestureBackSettings.needBackExtrudeAnim() === true).assertTrue();
      mocker.ignoreMock(gestureBackCcmSettings, gestureBackCcmSettings.needBackExtrudeAnim);
    });

    it('GestureBackSettingsTest_getBackMetaBallFollowingDampX_1', Level.LEVEL0, (): void => {
      let mocker = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureBackCcmSettings, gestureBackCcmSettings.getBackMetaBallFollowingDampX);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      expect(gestureBackSettings.getBackMetaBallFollowingDampX() ===
      GestureBackConstants.BACK_METABALL_FOLLOWING_DAMP_X).assertTrue();
      mocker.ignoreMock(gestureBackCcmSettings, gestureBackCcmSettings.getBackMetaBallFollowingDampX);
    });

    it('GestureBackSettingsTest_getBackMetaBallFollowingDampY_1', Level.LEVEL0, (): void => {
      let mocker = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureBackCcmSettings, gestureBackCcmSettings.getBackMetaBallFollowingDampY);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      expect(gestureBackSettings.getBackMetaBallFollowingDampY() ===
      GestureBackConstants.BACK_METABALL_FOLLOWING_DAMP_Y).assertTrue();
      mocker.ignoreMock(gestureBackCcmSettings, gestureBackCcmSettings.getBackMetaBallFollowingDampY);
    });

    it('GestureBackSettingsTest_getBackBezierThreshold_1', Level.LEVEL0, (): void => {
      let mocker = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(gestureBackCcmSettings, gestureBackCcmSettings.getBackBezierThreshold);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      expect(gestureBackSettings.getBackBezierThreshold() ===
      GestureBackConstants.BACK_METABALL_BEZIER_THRESHOLD).assertTrue();
      mocker.ignoreMock(gestureBackCcmSettings, gestureBackCcmSettings.getBackBezierThreshold);
    });
  });
}