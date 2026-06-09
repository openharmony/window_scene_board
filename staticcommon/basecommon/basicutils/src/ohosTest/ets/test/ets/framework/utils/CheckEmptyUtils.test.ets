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
import { CheckEmptyUtils } from '../../../../../../main/ets/utils/CheckEmptyUtils';

export function CheckEmptyUtilTest() {
  describe('CheckEmptyUtilTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })
    it('CheckEmptyUtilTest_isEmpty', 0, (): void => {
      expect(CheckEmptyUtils.isEmpty(undefined)).assertTrue();
      expect(CheckEmptyUtils.isEmpty(null)).assertTrue();
      expect(CheckEmptyUtils.isEmpty('')).assertTrue();
      expect(CheckEmptyUtils.isEmpty('checkEmpty')).assertFalse();
    })
    it('CheckEmptyUtilTest_checkStrIsEmpty', 0, (): void => {
      expect(CheckEmptyUtils.checkStrIsEmpty(undefined)).assertTrue();
      expect(CheckEmptyUtils.checkStrIsEmpty(null)).assertTrue();
      expect(CheckEmptyUtils.checkStrIsEmpty(' ')).assertTrue();
      expect(CheckEmptyUtils.checkStrIsEmpty('checkEmpty')).assertFalse();
    })
    it('CheckEmptyUtilTest_isEmptyArr', 0, (): void => {
      expect(CheckEmptyUtils.isEmptyArr(undefined)).assertTrue();
      expect(CheckEmptyUtils.isEmptyArr(null)).assertTrue();
      expect(CheckEmptyUtils.isEmptyArr([])).assertTrue();
      expect(CheckEmptyUtils.isEmptyArr(['checkEmpty'])).assertFalse();
    })
  })
}