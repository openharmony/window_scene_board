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
import { FASlotName } from '@ohos/commonconstants';
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import {
  ControlCenterAccessibilityDataModel
} from '@ohos/controlcentercommon/src/main/ets/accessibility/AccessibilityDataModel';

const DEFAULT: number = 0;

export function AccessibilityDataModelTest() {
  describe('AccessibilityDataModelTest', (): void => {
    beforeAll((): void => {
    })
    beforeEach((): void => {
    })
    afterAll((): void => {
    })
    afterEach((): void => {
    })

    it('AccessibilityDataModelTest_getInstance', DEFAULT, (): void => {
      let init = ControlCenterAccessibilityDataModel.getInstance();
      expect(init === undefined).assertFalse();
    })

    it('AccessibilityDataModelTest_set1', DEFAULT, (): void => {
      ControlCenterAccessibilityDataModel.getInstance().set(FASlotName.WIFI, 'WLAN');
      expect(true).assertTrue();
    })

    it('AccessibilityDataModelTest_set2', DEFAULT, (): void => {
      ControlCenterAccessibilityDataModel.getInstance().set(undefined, 'WLAN');
      ControlCenterAccessibilityDataModel.getInstance().set(FASlotName.WIFI, 'WLAN');
      expect(true).assertTrue();
    })

    it('AccessibilityDataModelTest_get', DEFAULT, (): void => {
      let instance = ControlCenterAccessibilityDataModel.getInstance();
      instance.set(FASlotName.BLUETOOTH, 'BlueTooth');
      let label = instance.get(FASlotName.BLUETOOTH) as string;
      expect(typeof label === 'string').assertTrue();
    })
  })
}
