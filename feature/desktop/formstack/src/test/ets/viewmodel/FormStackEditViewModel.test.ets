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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { FormStackEditViewModel } from '../../../main/ets/viewmodel/FormStackEditViewModel';

export function FormStackEditViewModelTest() {
  describe('TraceUtilTest', function () {
    beforeAll(function () {
    })

    beforeEach(function () {
    })

    afterAll(function () {
    })

    afterEach(function () {
    })

    it('initItemInfo', 0 , function () {
      let viewModel : FormStackEditViewModel = new FormStackEditViewModel();
      expect(viewModel.initItemInfo(null)).assertEqual(false);
    })

    it('initFormStackHotArea', 0 , function () {
      let viewModel : FormStackEditViewModel = new FormStackEditViewModel();
      expect(viewModel.initFormStackHotArea()).not().assertFalse();
    })
  })
}