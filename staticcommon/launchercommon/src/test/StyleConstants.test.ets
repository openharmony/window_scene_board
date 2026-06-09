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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { StyleConstants } from '../main/ets/TsIndex'

export default function StyleConstantsTest() {
  describe('StyleConstantsTest', () => {
    beforeAll(() => {

    })
    beforeEach(() => {

    })
    afterEach(() => {

    })
    afterAll(() => {

    })
    it('StyleConstantsTest_assertEqual', 0, () => {
      expect(StyleConstants.DEFAULT_45).assertEqual(45);
      expect(StyleConstants.DEFAULT_96).assertEqual(96);
      expect(StyleConstants.DEFAULT_FOLD_PHONE_EXPANDED_LANDSCAPE_ROW_GAP).assertEqual(30);
      expect(StyleConstants.DEFAULT_FOLD_PHONE_EXPANDED_LANDSCAPE_COLUMN_GAP).assertEqual(30);
    })
  })
}