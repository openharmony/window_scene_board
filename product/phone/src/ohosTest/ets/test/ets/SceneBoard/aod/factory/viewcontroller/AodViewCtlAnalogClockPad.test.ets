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

import { describe, expect, it } from '@ohos/hypium';
import {
  AodViewCtlAnalogClockPad
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/factory/viewcontroller/AodViewCtlAnalogClockPad';

export function AodViewCtlAnalogClockPadTest() {
  describe('AodViewCtlAnalogClockPadTest', () => {

    it('test_getInstance', 0, () => {
      const instance0 = AodViewCtlAnalogClockPad.getInstance();
      const instance1 = AodViewCtlAnalogClockPad.getInstance();
      expect(true).assertTrue();
    });

  });
}