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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';

import { AnimationDataArray } from '../../../../../../main/ets/com/ohos/model/ControlCenterAnimationData';
import {
  ControlCenterAnimationViewModel
} from '../../../../../../main/ets/com/ohos/viewModel/ControlCenterAnimationViewModel';

export function ControlCenterAnimationViewModelTest() {

  describe('ControlCenterAnimationViewModelTest', (): void => {
    beforeAll((): void => {
    })

    afterAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {

    })

    it('touchEndCheckAnim_Test', 0, (): void => {
      let viewMode = new ControlCenterAnimationViewModel(new AnimationDataArray(), 12);
      viewMode.touchEndCheckAnim(0, 7, false);
      expect(viewMode.viewDataArray.length > 0).assertTrue();
      viewMode.touchEndCheckAnim(1, 7, false);
      expect(viewMode.viewDataArray.length > 0).assertTrue();
    })

    it('viewModeShow_Test', 0, (): void => {
      let viewMode = new ControlCenterAnimationViewModel(new AnimationDataArray(), 12);
      viewMode.resetData(true);
      expect(viewMode.viewDataArray[0].scale === 1).assertTrue();
    })
  })
}