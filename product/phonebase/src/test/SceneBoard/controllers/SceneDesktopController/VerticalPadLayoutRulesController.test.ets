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

import { LayoutViewModel } from '@ohos/launchercommon/src/main/ets/viewmodel/LayoutViewModel'
import { VerticalPadLayoutRulesController } from '../../../../main/ets/SceneBoard/controllers/SceneDesktopController/VerticalPadLayoutRulesController'

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, TestType, Size, Level } from '@ohos/hypium'

export default function VerticalPadLayoutRulesControllerTest() {
  describe('VerticalPadLayoutRulesControllerTest', () => {
    let mLayoutViewModel = LayoutViewModel.getInstance();
    let baseConfig = mLayoutViewModel.getBaseConfig();
    let veritcalPad = VerticalPadLayoutRulesController.getInstance(baseConfig);
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });
    it('calculateDesktop', TestType.USER | Size.SMALLTEST | Level.LEVEL0, () => {
      veritcalPad.calculateDesktop();
    });
  })
}