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
import { beforeEach, describe, expect, it } from '@ohos/hypium';
import { ThemePackInfo } from '@ohos/themeservice_inner_api/Index';
import { ArrayUtils } from '@ohos/themeservicebase/Index';
import { ThemeCacheInfo } from '../../../../../main/ets/cache/ThemeInfoStoreCache';
import { ThemePackCache, ThemePackCacheData } from '../../../../../main/ets/cache/ThemePackCache';

export default function ThemePackCacheTest() {
  describe('ThemePresetCacheTest', () => {
    let presetCacheData: Nullable<ThemePackCacheData[]>
    beforeEach(async () => {
      presetCacheData = await ThemePackCache.getInstance().get();
    })

    it('test001_get', 0, async () => {
      expect(presetCacheData!.length > 0).assertTrue();
    })

    it('test002_addIfNot_Fail', 0, async () => {
      let themePack: ThemePackInfo = presetCacheData?.pop()?.themePack!;
      await ThemePackCache.getInstance().addIfNot(themePack);
      expect((await ThemePackCache.getInstance().get())?.length ?? 0).assertEqual(presetCacheData?.length);
    })

    it('test003_addThemesIfNot_Fail', 0, async () => {
      let themeCaches: ThemeCacheInfo[] = ArrayUtils.map(presetCacheData, (cacheData => {
        let cacheInfo: ThemeCacheInfo = new ThemeCacheInfo();
        cacheInfo.id = cacheData.id;
        return cacheInfo;
      }))
      await ThemePackCache.getInstance().addThemesIfNot(themeCaches);
      expect((await ThemePackCache.getInstance().get())?.length ?? 0).assertEqual(presetCacheData?.length);
    })

    it('test004_updatePresetFragment_Fail', 0, async () => {
      let themeCaches: ThemeCacheInfo[] = ArrayUtils.map(presetCacheData, (cacheData => {
        let cacheInfo: ThemeCacheInfo = new ThemeCacheInfo();
        cacheInfo.id = cacheData.id;
        return cacheInfo;
      }))
      await ThemePackCache.getInstance().updatePresetFragment(themeCaches);
      expect((await ThemePackCache.getInstance().get())?.length ?? 0).assertEqual(presetCacheData?.length);
    })
  })
}