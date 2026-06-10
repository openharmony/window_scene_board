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
import { BitSet } from '../../../../../../main/ets/TsIndex';

export default function BitSetTest() {
  describe('BitSetTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.

    const length = 128;
    const bitset = new BitSet(length);
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('test_clear', 0, () => {
      bitset.clear();
      for (let idx = 0; idx < length; idx++) {
        expect(bitset.get(idx)).assertEqual(false);
      }
    })
    it('test_get_set_bit', 0, () => {
      bitset.clear();
      let index = 20;
      bitset.set(index);
      expect(bitset.get(index)).assertEqual(true);

      index = 200;
      bitset.set(index);
      expect(bitset.get(index)).assertEqual(false);
    })

    it('test_set_out_of_range_bit', 0, () => {
      bitset.clear();
      let index = 200;
      bitset.set(index);
      expect(bitset.get(index)).assertEqual(false);
    })

    it('test_bound', 0, () => {
      bitset.clear();
      let index = 0;
      bitset.set(index);
      expect(bitset.get(index)).assertEqual(true);
      index = length;
      bitset.set(index);
      expect(bitset.get(index)).assertEqual(false);
      index = -1;
      bitset.set(index);
      expect(bitset.get(index)).assertEqual(false);
    })

    it('test_full', 0, () => {
      let bSet: BitSet = new BitSet(length);
      bSet.clear();
      let index: number = 10;
      bSet.set(index);
      expect(bSet.get(index)).assertEqual(true);
    })
  })
}