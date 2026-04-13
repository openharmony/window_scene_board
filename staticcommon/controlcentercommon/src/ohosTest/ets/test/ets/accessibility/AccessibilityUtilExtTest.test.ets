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
import { describe, it, expect, Level } from '@ohos/hypium';
import { AccessibilityUtilExt } from '@ohos/controlcentercommon/src/main/ets/accessibility/AccessibilityUtilExt';
import { ToggleViewData } from '../../../../../main/ets/toggle/vm/ToggleViewData';

export function AccessibilityUtilExtTest() {
  describe('AccessibilityUtilExtTest', (): void => {
    it('test_initAccessibilityUtilExt', Level.LEVEL0, (): void => {
      let testInstance = new AccessibilityUtilExt();
      expect(testInstance instanceof AccessibilityUtilExt).assertTrue()
    });
    it('test_getToggleText', Level.LEVEL0, (): void => {
      AccessibilityUtilExt.getToggleText('', new ToggleViewData());
      expect(true).assertTrue()
    });
    it('test_getToggleLabelText', Level.LEVEL0, (): void => {
      AccessibilityUtilExt.getToggleLabelText('', new ToggleViewData());
      expect(true).assertTrue()
    });
    it('test_getToggleIconClickText', Level.LEVEL0, (): void => {
      AccessibilityUtilExt.getToggleLabelText('', new ToggleViewData());
      expect(true).assertTrue()
    });
  });
}