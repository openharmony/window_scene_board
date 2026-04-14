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

import { afterAll, beforeAll, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import { TContentPrivStatus } from '@ohos/themeservice_inner_api/Index';
import { JsonUtils, NullableType, TsLog } from '@ohos/themeservicebase/Index';
import { RemoteCode } from '@ohos/themeservicebase/src/main/ets/remote/RemoteCode';
import {
  ThemeCacheInfo,
  ThemeExtendInfo,
  ThemeInfoStoreCache
} from '../../../../../main/ets/cache/ThemeInfoStoreCache';
import { OnlineThemeInfo } from '../../../../../main/ets/remote/model/OnlineThemeInfo';
import { themeInfoService } from '../../../../../main/ets/service/impl/ThemeInfoServiceImpl';
import { TSOhosTestManger } from '../../../core/TSOhosTestManger';
import { AssertUtils } from '../../../core/util/AssertUtils';

const TAG: string = 'ThemeVipService_Test';

export default function ThemeVipServiceTest() {
  describe('ThemeVipServiceTest', () => {
    let initData: ThemeCacheInfo[] = [];
    let tempData: NullableType<ThemeCacheInfo[]>;

    // 获取数据
    beforeAll(async () => {
      tempData = await ThemeInfoStoreCache.getInstance().get();
      handleInitData(tempData, initData);
    });

    // 恢复数据
    afterAll(async () => {
      await themeInfoService.get().updateCacheThemeList(initData ?? []);
    })

    it('getOnlineThemeList01', 0, async () => {
      let mocker: MockKit = new MockKit()
      let fun: Function = mocker.mockFunc(themeInfoService.get(), themeInfoService.get().getCacheThemeList)
      when(fun)().afterReturn(undefined);
      await themeInfoService.get().updateCacheThemeList([]);
      const onlineThemeInfo: Nullable<OnlineThemeInfo[]> =
        await TSOhosTestManger.hwAppCallApi(api => api.getOnlineThemeList());
      TsLog.info(TAG, `getOnlineThemeList01 = ${JsonUtils.stringify(onlineThemeInfo)}`);
      expect(onlineThemeInfo).assertUndefined();
      mocker.clear(themeInfoService.get());
      mocker.clearAll();
    });

    it('getOnlineThemeList02', 0, async () => {
      await getOnlineThemeListTest(tempData);
    });

    it('updateOnlineTheme01', 0, async () => {
      await updateOnlineData(-1, 'disable');
      await updateOnlineData(0, 'disable');
      await updateOnlineData(1, 'enable');
      await updateOnlineData(2, 'vip');
      await updateOnlineData(3, 'disable');
    });
  })
}

function handleInitData(tempData: ThemeCacheInfo[] | undefined, initData: ThemeCacheInfo[]): void {
  tempData?.forEach((item: ThemeCacheInfo) => {
    let newItem: Nullable<ThemeCacheInfo> = JsonUtils.parse(JsonUtils.stringify(item)??'');
    if (newItem) {
      initData.push(newItem);
    }
  });
}

async function getOnlineThemeListTest(tempData: NullableType<ThemeCacheInfo[]>): Promise<void> {
  tempData?.forEach((item: ThemeCacheInfo) => {
    item.originType = 'preset';
    item.themeEditInfo?.forEach((itemExtent: ThemeExtendInfo) => {
      itemExtent.type = 'preset';
    });
  });
  await themeInfoService.get().updateCacheThemeList(tempData ?? []);
  expect(await TSOhosTestManger.hwAppCallApi(api => api.getOnlineThemeList())).assertUndefined();
  tempData?.forEach((item: ThemeCacheInfo) => {
    item.originType = 'online';
  });
  await themeInfoService.get().updateCacheThemeList(tempData ?? []);
  expect(await TSOhosTestManger.hwAppCallApi(api => api.getOnlineThemeList())).not().assertUndefined();
}

async function updateOnlineData(contentStatus: number, contentPrivStatus: TContentPrivStatus): Promise<void> {
  let initThemeList: Nullable<OnlineThemeInfo[]> = await TSOhosTestManger.hwAppCallApi(api => api
    .getOnlineThemeList());
  initThemeList?.forEach((item: OnlineThemeInfo) => {
    item.contentPrivStatus = contentStatus;
  });
  await TSOhosTestManger.hwAppCallApi(api => api.updateOnlineTheme(initThemeList ?? [], 10));
  let storeCache: NullableType<ThemeCacheInfo[]> = await ThemeInfoStoreCache.getInstance().get();
  TsLog.info(TAG, `updateOnlineData = ${JsonUtils.stringify(storeCache)}`);
  expect(storeCache).not().assertUndefined();
}
