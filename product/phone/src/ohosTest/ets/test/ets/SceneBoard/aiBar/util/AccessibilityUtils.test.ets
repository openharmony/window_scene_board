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

import { AccessibilityManager } from '@ohos/frameworkwrapper'
import { ResUtils } from '@ohos/windowscene';
import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium'
import { AccessibilityUtils } from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/util/AccessibilityUtils'

export default function AccessibilityUtilsTest() {
  describe('AccessibilityUtilsTest', () => {
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

    it('isAccessibilityMode_isAccessibilityMode_when_getIsAccessibilityMode_return_true', 0, () => {
      let accessibilityManager = AccessibilityManager.getInstance();
      let mocker: MockKit = new MockKit();
      let getIsAccessibilityMode: Function =
        mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(getIsAccessibilityMode)(ArgumentMatchers.any).afterReturn(true);
      expect(AccessibilityUtils.isAccessibilityMode()).assertTrue();
      mocker.ignoreMock(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
    })

    it('isAccessibilityMode_isAccessibilityMode_when_getIsAccessibilityMode_return_false', 0, () => {
      let accessibilityManager = AccessibilityManager.getInstance();
      let mocker: MockKit = new MockKit();
      let getIsAccessibilityMode: Function =
        mocker.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(getIsAccessibilityMode)(ArgumentMatchers.any).afterReturn(true);
      expect(AccessibilityUtils.textAnnouncedForDragEnterAIBar() === undefined).assertTrue();
      mocker.ignoreMock(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
    })

    it('AccessibilityUtils_textAnnouncedForDragEnterAIBar_1', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockIsAccessibilityMode: Function =
        mocker.mockFunc(AccessibilityUtils, AccessibilityUtils.isAccessibilityMode);
      when(mockIsAccessibilityMode)(ArgumentMatchers.any).afterReturn(false);
      expect(AccessibilityUtils.textAnnouncedForDragEnterAIBar() === undefined).assertTrue();
      mocker.ignoreMock(AccessibilityUtils, AccessibilityUtils.isAccessibilityMode);
      done();
    });

    it('AccessibilityUtils_textAnnouncedForDragEnterAIBar_2', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockIsAccessibilityMode: Function =
        mocker.mockFunc(AccessibilityUtils, AccessibilityUtils.isAccessibilityMode);
      when(mockIsAccessibilityMode)(ArgumentMatchers.any).afterReturn(true);
      let mockGetInnerString: Function = mocker.mockFunc(ResUtils, ResUtils.getInnerString);
      when(mockGetInnerString)(ArgumentMatchers.any).afterReturn('');
      expect(AccessibilityUtils.textAnnouncedForDragEnterAIBar() === undefined).assertTrue();
      mocker.ignoreMock(AccessibilityUtils, AccessibilityUtils.isAccessibilityMode);
      mocker.ignoreMock(ResUtils, ResUtils.getInnerString);
      done();
    });

    it('AccessibilityUtils_textAnnouncedForDragEnterAIBar_3', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockIsAccessibilityMode: Function =
        mocker.mockFunc(AccessibilityUtils, AccessibilityUtils.isAccessibilityMode);
      when(mockIsAccessibilityMode)(ArgumentMatchers.any).afterReturn(true);
      let mockGetInnerString: Function = mocker.mockFunc(ResUtils, ResUtils.getInnerString);
      when(mockGetInnerString)(ArgumentMatchers.any).afterReturn('valid text');
      expect(AccessibilityUtils.textAnnouncedForDragEnterAIBar() === undefined).assertTrue();
      mocker.ignoreMock(AccessibilityUtils, AccessibilityUtils.isAccessibilityMode);
      mocker.ignoreMock(ResUtils, ResUtils.getInnerString);
      done();
    });
  })
}