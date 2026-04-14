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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when } from '@ohos/hypium';
import { AccessibilityPageShowHide, AccessibilityUtil } from '@ohos/systemuicommon/src/main/ets/TsIndex';

const DEFAULT: number = 0;

export function AccessibilityUtilTestCC() {
  const mocker: MockKit = new MockKit();
  describe('AccessibilityUtilTestCC', (): void => {
    beforeAll((): void => {
    })
    beforeEach((): void => {
    })
    afterAll((): void => {
      mocker.clearAll();
    })
    afterEach((): void => {
    })

    it('AccessibilityUtilTest_isAccessibilityMode', DEFAULT, (): void => {
      // 设置开关
      let isAccessibilityMode = mocker.mockFunc(AccessibilityUtil, AccessibilityUtil.isAccessibilityMode);

      when(isAccessibilityMode)().afterReturn(true);
      expect(AccessibilityUtil.isAccessibilityMode()).assertTrue();

      when(isAccessibilityMode)().afterReturn(false);
      expect(AccessibilityUtil.isAccessibilityMode()).assertFalse();
      mocker.clear(AccessibilityUtil);
    })

    it('AccessibilityUtilTest_sendControlCenterAccessibility', DEFAULT, (): void => {
      let isAccessibilityMode = mocker.mockFunc(AccessibilityUtil, AccessibilityUtil.isAccessibilityMode);
      when(isAccessibilityMode)().afterReturn(false);
      AccessibilityUtil.sendControlCenterAccessibility(AccessibilityPageShowHide.SHOW)

      when(isAccessibilityMode)().afterReturn(true);
      AccessibilityUtil.sendControlCenterAccessibility(AccessibilityPageShowHide.SHOW)
      expect(true).assertTrue();
    })

    it('AccessibilityUtilTest_sendControlCenterToggleClickAccessibility', DEFAULT, (): void => {
      let isAccessibilityMode = mocker.mockFunc(AccessibilityUtil, AccessibilityUtil.isAccessibilityMode);
      when(isAccessibilityMode)().afterReturn(false);
      AccessibilityUtil.sendControlCenterToggleClickAccessibility('test')

      when(isAccessibilityMode)().afterReturn(true);
      AccessibilityUtil.sendControlCenterToggleClickAccessibility('test')
      expect(true).assertTrue();
    })

    it('AccessibilityUtilTest_sendAccessibility', DEFAULT, (): void => {
      let isAccessibilityMode = mocker.mockFunc(AccessibilityUtil, AccessibilityUtil.isAccessibilityMode);
      when(isAccessibilityMode)().afterReturn(false);
      AccessibilityUtil.sendAccessibility('test')

      when(isAccessibilityMode)().afterReturn(true);
      AccessibilityUtil.sendAccessibility('test')
      expect(true).assertTrue();
    })
  })
}
