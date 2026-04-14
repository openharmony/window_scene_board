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
import { afterAll, beforeAll, describe, expect, it, Level, TestType } from '@ohos/hypium';
import { NullableType } from '@ohos/themeservicebase';
import {
  IgnoreUpdateThemeInfoCache,
  UpdateResourceInfo,
  UpdateThemeInfoCache,
} from '../../../../../main/ets/cache/UpdateThemeInfoCache';
import { updateThemeInfoService } from '../../../../../main/ets/service/impl/UpdateThemeInfoServiceImpl';
import { TSOhosTestManger } from '../../../core/TSOhosTestManger';
import { AssertUtils } from '../../../core/util/AssertUtils';

const defaultInfo: UpdateResourceInfo = {
  id: '1',
  localVersion: '1.0',
  latestVersion: '2.0',
};

const newUpdateInfo: UpdateResourceInfo = {
  id: '1',
  localVersion: '2.0',
  latestVersion: '3.0',
};

const otherUpdateInfo: UpdateResourceInfo = {
  id: '2',
  localVersion: '3.0',
  latestVersion: '4.0',
};

export default function UpdateThemeInfoServiceTest() {
  describe('UpdateThemeInfoServiceTest', () => {
    beforeAll(async () => {
      await UpdateThemeInfoCache.getInstance().clear();
      await IgnoreUpdateThemeInfoCache.getInstance().clear();
    });

    it('test001_get_update_theme_list_no_ignore', 0, async () => {
      await UpdateThemeInfoCache.getInstance().clear();
      await UpdateThemeInfoCache.getInstance().update([defaultInfo]);
      let ret: NullableType<UpdateResourceInfo[]> = await TSOhosTestManger.getTsCoreRemoteApi().getUpdateThemeList();
      expect(ret).not().assertUndefined();
      expect(ret).not().assertNull();
      if (ret) {
        expect(ret.length).assertEqual(1);
        expect(ret[0].id).assertEqual(defaultInfo.id);
        expect(ret[0].localVersion).assertEqual(defaultInfo.localVersion);
        expect(ret[0].latestVersion).assertEqual(defaultInfo.latestVersion);
      }
    });

    it('test002_get_update_theme_list_has_ignore', 0, async () => {
      await UpdateThemeInfoCache.getInstance().clear();
      await UpdateThemeInfoCache.getInstance().update([defaultInfo]);
      await IgnoreUpdateThemeInfoCache.getInstance().clear();
      await IgnoreUpdateThemeInfoCache.getInstance().update([defaultInfo]);
      let ret: NullableType<UpdateResourceInfo[]> = await TSOhosTestManger.getTsCoreRemoteApi().getUpdateThemeList();
      expect(ret).not().assertUndefined();
      expect(ret).not().assertNull();
      if (ret) {
        expect(ret.length).assertEqual(0);
      }
    });

    it('test003_get_update_theme_list_has_invalid_ignore', 0, async () => {
      await UpdateThemeInfoCache.getInstance().clear();
      await UpdateThemeInfoCache.getInstance().update([newUpdateInfo]);
      await IgnoreUpdateThemeInfoCache.getInstance().clear();
      await IgnoreUpdateThemeInfoCache.getInstance().update([defaultInfo]);
      let ret: NullableType<UpdateResourceInfo[]> = await TSOhosTestManger.getTsCoreRemoteApi().getUpdateThemeList();
      expect(ret).not().assertUndefined();
      expect(ret).not().assertNull();
      if (ret) {
        expect(ret.length).assertEqual(1);
        expect(ret[0].id).assertEqual(newUpdateInfo.id);
        expect(ret[0].localVersion).assertEqual(newUpdateInfo.localVersion);
        expect(ret[0].latestVersion).assertEqual(newUpdateInfo.latestVersion);
      }
    });

    it('test004_ignore_set_success', 0, async () => {
      await IgnoreUpdateThemeInfoCache.getInstance().clear();
      let ret: boolean =
        await TSOhosTestManger.getTsCoreRemoteApi()
          .ignoreUpdateTheme(defaultInfo.id, defaultInfo.latestVersion as string);
      expect(ret).assertTrue();
      let ignoreThemes: Nullable<UpdateResourceInfo[]> = await IgnoreUpdateThemeInfoCache.getInstance().get();
      expect(ignoreThemes).not().assertUndefined();
      expect(ignoreThemes?.length).assertEqual(1);
      if (ignoreThemes) {
        expect(ignoreThemes[0].id).assertEqual(defaultInfo.id);
        expect(ignoreThemes[0].latestVersion).assertEqual(defaultInfo.latestVersion);
      }
    });

    it('test005_ignore_update_success', 0, async () => {
      await IgnoreUpdateThemeInfoCache.getInstance().clear();
      await TSOhosTestManger.getTsCoreRemoteApi()
        .ignoreUpdateTheme(defaultInfo.id, defaultInfo.latestVersion as string);
      let newIgnoreTheme: UpdateResourceInfo = {
        id: defaultInfo.id,
        latestVersion: '3.0',
      };
      await TSOhosTestManger.getTsCoreRemoteApi()
        .ignoreUpdateTheme(newIgnoreTheme.id, newIgnoreTheme.latestVersion as string);
      let ignoreThemes: Nullable<UpdateResourceInfo[]> = await IgnoreUpdateThemeInfoCache.getInstance().get();
      expect(ignoreThemes).not().assertUndefined();
      expect(ignoreThemes?.length).assertEqual(1);
      if (ignoreThemes) {
        expect(ignoreThemes[0].id).assertEqual(defaultInfo.id);
        expect(ignoreThemes[0].latestVersion).assertEqual(newIgnoreTheme.latestVersion);
      }
    });

    it('test006_resource_change_success', 0, async () => {
      await UpdateThemeInfoCache.getInstance().clear();
      await UpdateThemeInfoCache.getInstance().update([otherUpdateInfo, defaultInfo]);
      await updateThemeInfoService.get().resourceChangeNotification([defaultInfo.id]);
      let ret: Nullable<UpdateResourceInfo[]> = await updateThemeInfoService.get().getUpdateThemeListAndRefresh();
      expect(ret).not().assertUndefined();
      expect(ret?.length).assertEqual(1);
    });

    it('test007_ignore_update_theme_parallel', TestType.SECURITY | Level.LEVEL1, async () => {
      await AssertUtils.expectParallelInvoke(() => TSOhosTestManger.getTsCoreRemoteApi()
        .ignoreUpdateTheme(defaultInfo.id, defaultInfo.latestVersion as string));
    });

    it('test008_clear_all_cache_success', 0, async () => {
      let ret: boolean = await TSOhosTestManger.hwAppCallApi(api => api.clearUpdateThemeAllCache());
      expect(ret).assertTrue();
    });

    it('test009_clear_all_cache_parallel', TestType.SECURITY | Level.LEVEL1, async () => {
      await AssertUtils.expectParallelInvoke(() => TSOhosTestManger.hwAppCallApi(api => api.clearUpdateThemeAllCache()));
    });
  });
}
