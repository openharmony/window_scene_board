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
import { beforeEach, describe, expect, it } from '@ohos/hypium';
import { ContextUtil, createPreference, NullableType, PreferenceStoreCache } from '@ohos/themeservicebase/Index';

class CacheData {
  id: number = 0;
  name: string = '';
}

export default function PreferenceStoreCacheTest() {

  describe('PreferenceStoreCacheTest', () => {
    let storeCache: PreferenceStoreCache<CacheData>;
    beforeEach(() => {
      storeCache = new PreferenceStoreCache<CacheData>
      (createPreference(ContextUtil.getTsApplicationContext(), 'test_Preference'),
        (_oldVersion: number, _newVersion: number, _oldData: NullableType<CacheData>) => {
          let data: CacheData = new CacheData();
          data.id = 1000;
          data.name = 'PreferenceName';
          return data;
        });
    })

    it('test001_get', 0, async () => {
      let cacheData: NullableType<CacheData> = await storeCache.get();
      expect(cacheData?.id).assertEqual(1000);
      expect(cacheData?.name).assertEqual('PreferenceName');
    })

    it('test002_update', 0, async () => {
      let data: CacheData = new CacheData();
      data.id = 1001;
      data.name = 'PreferenceName2';
      let ret: boolean = await storeCache.update(data);
      expect(ret).assertTrue();
      let cacheData: NullableType<CacheData> = await storeCache.get();
      expect(cacheData?.id).assertEqual(data.id);
      expect(cacheData?.name).assertEqual(data.name);
    })

    it('test003_clear', 0, async () => {
      await storeCache.clear();
      let cacheData: NullableType<CacheData> = await storeCache.get();
      expect(cacheData).assertUndefined();
    })
  })
}