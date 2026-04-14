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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import { LruCache } from '../../../../../../main/ets/TsIndex'

export default function LruCacheTest() {
  const VALUE_NOT_IN_CACHE = -1;
  describe('LruCacheTest', () => {
    const lruCache: LruCache = new LruCache();
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
    it('test_putGetValue', 0, () => {
      const anyKey: string = 'abc';
      const anyValue: string = 'anyValue';
      lruCache.putCache(anyKey, anyValue);
      expect(lruCache.getCache(anyKey)).assertEqual(anyValue);
      lruCache.remove(anyKey);
      expect(lruCache.getCache(anyKey)).assertEqual(VALUE_NOT_IN_CACHE);
    })

    it('test_lru', 0, () => {
      const anyKey: string[] = ['d', 'b', 'c'];
      const anyValue: string[] = ['A', 'B', 'C'];
      let smallCache: LruCache = new LruCache(2);
      for (let i = 0; i < anyKey.length; i++) {
        smallCache.putCache(anyKey[i], anyValue[i]);
      }
      expect(smallCache.getCache(anyKey[0])).assertEqual(VALUE_NOT_IN_CACHE);
      expect(smallCache.getCache(anyKey[1])).assertEqual(anyValue[1]);
      expect(smallCache.getCache(anyKey[2])).assertEqual(anyValue[2]);

      smallCache.getCache(anyKey[1])
      smallCache.putCache(anyKey[0], anyValue[0]);
      expect(smallCache.getCache(anyKey[2])).assertEqual(VALUE_NOT_IN_CACHE);
      expect(smallCache.getCache(anyKey[1])).assertEqual(anyValue[1]);
    })

    it('test_putCache_if1', 0, () => {
      const anyKey: string = 'abc';
      const anyValue: string = 'anyValue';
      lruCache.putCache(anyKey, anyValue);
      lruCache.putCache(anyKey, anyValue);
      expect(lruCache.getCache(anyKey)).assertEqual(anyValue);
    })
  })
}