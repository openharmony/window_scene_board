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
import { describe, expect, it, Level } from '@ohos/hypium';
import { ORIGIN_ONLINE, ORIGIN_PRESET_FRAGMENT } from '@ohos/themeservice_inner_api/src/main/ets/constant/TSTypes';
import { ArrayUtils, NullableType, TsLog } from '@ohos/themeservicebase/Index';
import { RemoteCode } from '@ohos/themeservicebase/src/main/ets/remote/RemoteCode';
import { ThemeCacheInfo, ThemeInfoStoreCache } from '../../../../../main/ets/cache/ThemeInfoStoreCache';
import { getThemePackParser } from '../../../../../main/ets/preset/ThemePackParser';
import { themeInfoService } from '../../../../../main/ets/service/impl/ThemeInfoServiceImpl';
import { ThemeInfoV2 } from '../../../core/remote/model/ThemeInfo';
import { TSOhosTestManger } from '../../../core/TSOhosTestManger';
import { AssertUtils } from '../../../core/util/AssertUtils';

const TAG: string = 'HostedThemeDownloadedTest';

export default function HostedThemeDownloadedTest() {
  describe('hostedThemeDownloadedTest_Illegal_caller', () => {
    it('hostedThemeDownloaded',  Level.LEVEL0, async () => {
      await AssertUtils.expectErrorCode(() => TSOhosTestManger.getTsCoreRemoteApi().hostedThemeDownloaded('', ''),
        RemoteCode.ERR_ILLEGAL_CALLER);
    })
  });
  describe('hostedThemeDownloadedTest', () => {
    it('test001_invalid_themeId', 0, async () => {
      let ret: boolean = await TSOhosTestManger.hwAppCallApi(api => api.hostedThemeDownloaded('', ''));
      expect(ret).assertFalse();
    });

    it('test002_invalid_path', 0, async () => {
      let ret: boolean = await TSOhosTestManger.hwAppCallApi(api => api.hostedThemeDownloaded('90000', ''));
      expect(ret).assertFalse();
    });

    it('test003_success', 0, async () => {
      await themeInfoService.get().init();
      let id: Nullable<string> = await mockPresetFragment();
      expect(id).not().assertUndefined();
      TsLog.debug(TAG, `mockPresetFragment id:` + id)

      let defaultPath: string = await getThemePackParser().getDefaultDir();
      let ret: boolean = await TSOhosTestManger.hwAppCallApi(api => api.hostedThemeDownloaded(id!, defaultPath));
      expect(ret).assertTrue()

      let galleryThemes: NullableType<ThemeInfoV2[]> = await TSOhosTestManger.getTsCoreRemoteApi().getThemeListV2(0);
      TsLog.debug(TAG, `test003_success galleryThemes:` + JSON.stringify(galleryThemes))
      const downLoadThemeInfo: Nullable<ThemeInfoV2> = galleryThemes?.find(theme => theme.id === id);
      expect(downLoadThemeInfo).not().assertUndefined()
    });
  })
}

async function mockPresetFragment(): Promise<Nullable<string>> {
  let caches: NullableType<ThemeCacheInfo[]> = themeInfoService.get().getCacheThemeList();
  TsLog.info(TAG, "mockPresetFragment caches:" + ArrayUtils.size(caches ?? []));
  if (!caches || ArrayUtils.isNull(caches)) {
    return undefined;
  }
  for (const cache of caches) {
    if (!cache.isUsing) {
      cache.originType = ORIGIN_PRESET_FRAGMENT;
      TsLog.info(TAG, "mockPresetFragment caches:" + JSON.stringify(caches));
      await ThemeInfoStoreCache.getInstance().update(caches);
      return cache.id;
    }
  }
  return undefined;
}