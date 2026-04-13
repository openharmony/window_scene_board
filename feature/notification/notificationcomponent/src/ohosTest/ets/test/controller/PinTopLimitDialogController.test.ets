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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { pinTopLimitDC } from '../../../../main/ets/controller/PinTopLimitDialogController'

export default function PinTopLimitDialogControllerTest() {
  describe('PinTopLimitDialogControllerTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('pin_top_limit_dialog_test_hide_dialog', 0, () => {
      const ntfType = 1;
      pinTopLimitDC.hideDialog(ntfType);
      expect((pinTopLimitDC as object)['settingsControllers'].has(ntfType)).assertFalse();
    })
  })
}