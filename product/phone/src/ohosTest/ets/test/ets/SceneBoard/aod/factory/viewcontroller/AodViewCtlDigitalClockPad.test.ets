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
import AodViewCtlDigitalClockPad
  from '@ohos/phonebase/src/main/ets/SceneBoard/aod/factory/viewcontroller/AodViewCtlDigitalClockPad';
import { AnimationParam, DigitalClockParam } from '@ohos/aod/src/main/ets/theme/viewmodel/AodViewModel';
import image from '@ohos.multimedia.image';

export function AodViewCtlDigitalClockPadTest() {
  describe('AodViewCtlDigitalClockPadTest', () => {

    it('test_getInstance', 0, () => {
      const instance0 = AodViewCtlDigitalClockPad.getInstance();
      const instance1 = AodViewCtlDigitalClockPad.getInstance();
      expect(instance0).not().assertUndefined();
    });

  });

  class TestAodViewCtlDigitalClockPad extends AodViewCtlDigitalClockPad {
    constructor() {
      super();
    }

    public async prepareResTest(): Promise<void> {
      await this.prepareRes(false);
    }

    public updateAodThemeParamTest(animationParam: AnimationParam, backgroundImage?: image.PixelMap): void {
      let digitalClockParam = this.aodViewModel.aodThemeParam as DigitalClockParam;
      digitalClockParam.animationParam = animationParam;
      digitalClockParam.backgroundImage = backgroundImage;
    }
  }
}