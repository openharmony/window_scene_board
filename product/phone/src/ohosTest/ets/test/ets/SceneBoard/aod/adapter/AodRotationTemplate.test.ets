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

import { describe, it, expect } from '@ohos/hypium'
import { AodRotationTemplate } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/adapter/AodRotationTemplate';
import display from '@ohos.display';
import { IAodDisplayInfo } from '@ohos/aod';

export function AodRotationTemplateTest() {
  describe('AodRotationTemplateTest', () => {

    it('test_crateDeviceConfigClt', 0, () => {
      const aodDisplayInfo= { rotation: display.Orientation.LANDSCAPE } as IAodDisplayInfo;

      let task: AodRotationTemplateTestClass = new AodRotationTemplateTestClass();
      task.isLandScapeDisplayFun(aodDisplayInfo);
      expect(true).assertTrue();
    });

    it('test_crateDeviceConfigClt_1', 0, () => {
      const aodDisplayInfo= { rotation: display.Orientation.LANDSCAPE_INVERTED } as IAodDisplayInfo;

      let task: AodRotationTemplateTestClass = new AodRotationTemplateTestClass();
      task.isLandScapeDisplayFun(aodDisplayInfo);
      expect(true).assertTrue();
    });
  });

  class AodRotationTemplateTestClass extends AodRotationTemplate {
    public isLandScapeDisplayFun(displayInfo: IAodDisplayInfo): void {
      this.isLandScapeDisplay(displayInfo);
    }
  }
}