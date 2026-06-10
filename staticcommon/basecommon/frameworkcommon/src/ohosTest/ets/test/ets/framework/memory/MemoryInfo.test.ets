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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { MemoryInfo } from '../../../../../../main/ets/memory/MemoryInfo';

export function MemoryInfoTest() {
  describe('MemoryInfoTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
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
    it('test_toString', 0, () => {
      let tempInfo: MemoryInfo = new MemoryInfo();
      expect(MemoryInfo.toString(tempInfo)).assertEqual('memory:[pss:0KB,native:0KB]');
      tempInfo.nativeHeap = BigInt(204800);
      expect(MemoryInfo.toString(tempInfo)).assertEqual('memory:[pss:0KB,native:204800KB]');
      tempInfo.pss = BigInt(102400);
      expect(MemoryInfo.toString(tempInfo)).assertEqual('memory:[pss:102400KB,native:204800KB]');
      expect(MemoryInfo.toString(new MemoryInfo())).assertEqual('memory:[pss:0KB,native:0KB]');
      expect(MemoryInfo.toString(null)).assertEqual('memory:[pss:undefinedKB,native:undefinedKB]');
      expect(MemoryInfo.toString(undefined)).assertEqual('memory:[pss:undefinedKB,native:undefinedKB]');
    })
  })
}