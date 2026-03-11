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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level} from '@ohos/hypium';
import { AppResourceCacheManager } from '../../../../../../main/ets/manager/AppResourceCacheManager';

export function AppResourceCacheManagerTest() {
  describe('AppResourceCacheManagerTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_getCache', Level.LEVEL0, (): void => {
      let cacheKey: string = 'key';
      let cacheType: string = 'type';
      let cache: TestCache = {};
      let cacheManager: AppResourceCacheManager = new AppResourceCacheManager();
      expect(cacheManager.getCache(cacheKey, cacheType)).assertNull();
      cacheManager.memoryCache.set(cacheKey, null);
      expect(cacheManager.getCache(cacheKey, cacheType)).assertNull();
      cacheManager.memoryCache.set(cacheKey, '');
      expect(cacheManager.getCache(cacheKey, cacheType)).assertNull();

      cacheManager.memoryCache.set(cacheKey, cache);
      expect(cacheManager.getCache(cacheKey, cacheType)).assertNull();
      cache.type = null;
      expect(cacheManager.getCache(cacheKey, cacheType)).assertNull();
      cache.type = '';
      expect(cacheManager.getCache(cacheKey, cacheType)).assertNull();
      cache.type = '1';
      expect(cacheManager.getCache(cacheKey, cacheType)).assertEqual('1');
    })

    it('test_setCache', Level.LEVEL0, (): void => {
      let cacheKey: string = 'key';
      let cacheType: string = 'type';
      let value: string = '1';
      let cache: TestCache = {};
      let cacheManager: AppResourceCacheManager = new AppResourceCacheManager();
      cacheManager.setCache(cacheKey, cacheType, value);
      expect(cacheManager.memoryCache.get(cacheKey)[cacheType]).assertEqual(value);

      cacheManager.memoryCache.set(cacheKey, null);
      cacheManager.setCache(cacheKey, cacheType, value);
      expect(cacheManager.memoryCache.get(cacheKey)[cacheType]).assertEqual(value);

      cacheManager.memoryCache.set(cacheKey, '');
      cacheManager.setCache(cacheKey, cacheType, value);
      expect(cacheManager.memoryCache.get(cacheKey)[cacheType]).assertEqual(value);

      cacheManager.memoryCache.set(cacheKey, cache);
      cacheManager.setCache(cacheKey, cacheType, value);
      expect(cacheManager.memoryCache.get(cacheKey)[cacheType]).assertEqual(value);
    })

    it('test_clearCache_clearAllCache', Level.LEVEL0, (): void => {
      let cacheKey: string = 'key';
      let value: string = '1';
      let cacheManager: AppResourceCacheManager = new AppResourceCacheManager();
      expect(cacheManager.memoryCache.isEmpty()).assertTrue();
      cacheManager.memoryCache.set(cacheKey, value);
      expect(cacheManager.memoryCache.isEmpty()).assertFalse();
      cacheManager.clearCache();
      expect(cacheManager.memoryCache.isEmpty()).assertTrue();

      cacheManager.memoryCache.set(cacheKey, value);
      expect(cacheManager.memoryCache.isEmpty()).assertFalse();
      cacheManager.clearAllCache();
      expect(cacheManager.memoryCache.isEmpty()).assertTrue();
    })

    it('test_deleteCache', Level.LEVEL0, (): void => {
      let cacheKey: string = 'key';
      let cacheType: string = 'type';
      let value: string = '1';
      let cacheManager: AppResourceCacheManager = new AppResourceCacheManager();

      cacheManager.memoryCache.set(cacheKey, value);
      expect(cacheManager.memoryCache.get(cacheKey)).assertEqual(value);
      cacheManager.deleteCache(cacheKey, cacheType);
      expect(cacheManager.memoryCache.get(cacheKey)).assertEqual(undefined);
    })
  })
}

class TestCache {
  type?: string | null;
}