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
import { describe, expect, it, TestType } from '@ohos/hypium';
import { MemoryCache, NullableType } from '@ohos/themeservicebase/Index';

class TestCacheData {
  public value: string | undefined;
}

class TestStoreCache extends MemoryCache<TestCacheData> {
  constructor() {
    super(`TestStoreCache`, () => {
      let cacheData: TestCacheData = new TestCacheData();
      cacheData.value = 'TestStoreCache_value';
      console.log(`loader`);
      return cacheData;
    });
  }
}

export default function MemoryCacheTest() {
  describe('MemoryCacheTest', () => {
    it('test01_MemoryStore_get', TestType.FUNCTION, async () => {
      let cache: TestStoreCache = new TestStoreCache();
      let cacheData: NullableType<TestCacheData> = await cache.get();
      expect(cacheData?.value).assertEqual('TestStoreCache_value');
    })

    it('test02_MemoryStore_update', TestType.FUNCTION, async () => {
      let cache: TestStoreCache = new TestStoreCache();
      let cacheData: TestCacheData = new TestCacheData();
      cacheData.value = 'TestStoreCache_value_new';
      await cache.update(cacheData);
      expect((await cache.get())?.value).assertEqual('TestStoreCache_value_new');
    })

    it('test03_MemoryStore_clear1', TestType.FUNCTION, async () => {
      let cache: TestStoreCache = new TestStoreCache();
      await cache.clear();
      expect((await cache.get())?.value).assertUndefined();
    })

    it('test04_MemoryStore_clear2', TestType.FUNCTION, async () => {
      let cache: TestStoreCache = new TestStoreCache();
      let cacheData: NullableType<TestCacheData> = await cache.get();
      expect(cacheData?.value).assertEqual('TestStoreCache_value');
      await cache.clear();
      expect((await cache.get())?.value).assertUndefined();
    })
  });
}