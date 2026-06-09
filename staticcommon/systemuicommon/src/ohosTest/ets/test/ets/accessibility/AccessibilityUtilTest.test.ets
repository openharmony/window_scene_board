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
import { describe, it, expect, Level } from '@ohos/hypium';
import { AccessibilityUtil } from '../../../../../main/ets/accessibility/AccessibilityUtil';
export function AccessibilityUtilTest() {
  describe('AccessibilityUtillTest', (): void => {
    it('test_initAccessibilityUtil', Level.LEVEL0, (): void => {
      let testInstance = new AccessibilityUtil();
      expect(testInstance instanceof AccessibilityUtil).assertTrue()
    });
    it('test_isAccessibilityMode', Level.LEVEL0, (): void => {
      AccessibilityUtil.isAccessibilityMode();
      expect(true).assertTrue();
    });
    it('test_sendAccessibility', Level.LEVEL0, (): void => {
      AccessibilityUtil.sendAccessibility('test');
      expect(true).assertTrue();
    });
    it('test_sendControlCenterAccessibility', Level.LEVEL0, (): void => {
      AccessibilityUtil.sendControlCenterAccessibility(1);
      expect(true).assertTrue();
    });
    it('test_sendControlCenterToggleClickAccessibility', Level.LEVEL0, (): void => {
      AccessibilityUtil.sendControlCenterToggleClickAccessibility('test');
      expect(true).assertTrue();
    });
    it('test_requestFocusAccessibility', Level.LEVEL0, (): void => {
      AccessibilityUtil.requestFocusAccessibility('test');
      expect(true).assertTrue();
    });
  });
}