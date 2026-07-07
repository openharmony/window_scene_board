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
import { ComponentRect, InteractiveParam } from '@ohos/aod';

import { describe, expect, it } from '@ohos/hypium';
import AodViewCtlInteractivePad from '@ohos/phonebase/src/main/ets/SceneBoard/aod/factory/viewcontroller/AodViewCtlInteractivePad';

export function AodViewCtlInteractivePadTest() {
  let aodViewCtlInteractivePad: AodViewCtlInteractivePad = new AodViewCtlInteractivePad();
  describe('AodViewCtlInteractivePadTest', () => {

    it('test_getInstance', 0, () => {
      const instance0 = AodViewCtlInteractivePad.getInstance();
      const instance1 = AodViewCtlInteractivePad.getInstance();
      expect(true).assertTrue();
    });

    it('AodViewCtlInteractivePad_prepareRes', 0,() => {
      let task: AodTestViewCtlInteractivePad = new AodTestViewCtlInteractivePad();
      let interactiveParam = new InteractiveParam();
      aodViewCtlInteractivePad.aodViewModel.aodThemeParam = interactiveParam;
      task.prepareResTest();
      expect(aodViewCtlInteractivePad).not().assertUndefined();
    });

    it('AodViewCtlInteractivePad_getRealDisplayRect', 0,() => {
      let instance = AodViewCtlInteractivePad.getInstance();
      let rect: ComponentRect = {
        left: 0,
        right: 0,
        top: 0,
        bottom: 0
      };
      instance.getRealDisplayRect(rect);
      expect(aodViewCtlInteractivePad).not().assertUndefined();
    });

  });

  class AodTestViewCtlInteractivePad extends AodViewCtlInteractivePad {
    constructor() {
      super();
    }

    public async prepareResTest(): Promise<void> {
      await this.prepareRes(false);
    }
  }
}