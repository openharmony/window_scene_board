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
import { ControlCenterAccessibilityDataModel } from '@ohos/controlcentercommon/src/main/ets/accessibility/AccessibilityDataModel';
export function ControlCenterAccessibilityDataModelTest() {
  describe('ControlCenterAccessibilityDataModelTest', (): void => {
    it('test_initNoDisturbComponentViewModel', Level.LEVEL0, (): void => {
      let testInstance = new ControlCenterAccessibilityDataModel();
      expect(testInstance instanceof ControlCenterAccessibilityDataModel).assertTrue()
    });

    it('test_initNoDisturbComponentViewModel_01', Level.LEVEL0, (): void => {
      let testInstance = new ControlCenterAccessibilityDataModel();
      testInstance.set(undefined,undefined);
      testInstance.set('test','1');
      let getD = testInstance.get('test');
      expect(getD).assertEqual('1');
    });
    it('test_initNoDisturbComponentViewModel', Level.LEVEL0, (): void => {
      let testInstance = ControlCenterAccessibilityDataModel.getInstance();
      expect(testInstance instanceof ControlCenterAccessibilityDataModel).assertTrue()
    });
  })
}