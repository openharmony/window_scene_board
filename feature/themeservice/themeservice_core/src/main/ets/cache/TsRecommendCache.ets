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
import { ContextUtil, PreferenceStoreCache, Singleton } from '@ohos/themeservicebase/Index';
import { ThemeRecommendInfo, TServiceApi } from '@ohos/themeservice_inner_api/Index';

export class TsRecommendCache extends PreferenceStoreCache<ThemeRecommendInfo[]> {
  private static readonly INSTANCE: Singleton<TsRecommendCache> =
    new Singleton<TsRecommendCache>(() => new TsRecommendCache());

  private constructor() {
    super(TServiceApi.preference(ContextUtil.getTsApplicationContext(), 'ts_onlineRecommend'));
  }

  /**
   * 获取单例对象
   *
   * @returns 对象
   */
  public static getInstance(): TsRecommendCache {
    return TsRecommendCache.INSTANCE.get();
  }
}