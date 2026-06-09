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

import { systemParameterEnhance } from '@kit.BasicServicesKit';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { ModeChangeUtils } from '../../../../../../main/ets/utils/ModeChangeUtils';


export default function ModeChangeUtilsTest() {
  describe('ModeChangeUtilsTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('isSupportWindowPcModeSwitch', 0, () => {
      let res: string = systemParameterEnhance.getSync('const.window.support_window_pcmode_switch', 'false');
      let result: boolean = res === 'true';
      expect(ModeChangeUtils.isSupportWindowPcModeSwitch()).assertEqual(result);
    })

    it('isPcMode', 0, () => {
      let res: string = systemParameterEnhance.getSync('persist.sceneboard.ispcmode', 'true');
      let result: boolean = res === 'true';
      if (!ModeChangeUtils.isSupportWindowPcModeSwitch()) {
        expect(ModeChangeUtils.isPcMode()).assertFalse();
      } else {
        expect(ModeChangeUtils.isPcMode()).assertEqual(result);
      }
    })
  })
}