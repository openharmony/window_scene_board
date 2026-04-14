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
import { preferences } from '@kit.ArkData';
import { TServiceApi, TsPreferenceName } from '@ohos/themeservice_inner_api';
import {
  ArrayUtils,
  ContextUtil,
  JsonUtils,
  PreferenceApi,
  PreferenceStoreCache,
  Singleton,
  StoreCache,
  StoreManager,
} from '@ohos/themeservicebase';

export interface UpdateResourceInfo {
  id: string;
  localVersion?: string;
  latestVersion?: string;
}

export class UpdateThemeInfoCache extends StoreCache<UpdateResourceInfo[], string[]> {
  private static readonly INSTANCE: Singleton<UpdateThemeInfoCache> =
    new Singleton<UpdateThemeInfoCache>(() => new UpdateThemeInfoCache());

  private constructor() {
    super(new UpdateThemeInfoStoreManger('ts_update_theme'));
  }

  public static getInstance(): UpdateThemeInfoCache {
    return UpdateThemeInfoCache.INSTANCE.get();
  }
}

export class UpdateThemeRefreshTimeCache extends PreferenceStoreCache<number> {
  private static readonly INSTANCE: Singleton<UpdateThemeRefreshTimeCache> =
    new Singleton<UpdateThemeRefreshTimeCache>(() => new UpdateThemeRefreshTimeCache());

  private constructor() {
    super(TServiceApi.preference(ContextUtil.getTsApplicationContext(), 'ts_update_theme_time'));
  }

  public static getInstance(): UpdateThemeRefreshTimeCache {
    return UpdateThemeRefreshTimeCache.INSTANCE.get();
  }
}

export class IgnoreUpdateThemeInfoCache extends StoreCache<UpdateResourceInfo[], string[]> {
  private static readonly INSTANCE: Singleton<IgnoreUpdateThemeInfoCache> =
    new Singleton<IgnoreUpdateThemeInfoCache>(() => new IgnoreUpdateThemeInfoCache());

  private constructor() {
    super(new UpdateThemeInfoStoreManger('ts_ignore_update_theme'));
  }

  public static getInstance(): UpdateThemeInfoCache {
    return IgnoreUpdateThemeInfoCache.INSTANCE.get();
  }
}

class UpdateThemeInfoStoreManger implements StoreManager<UpdateResourceInfo[], string[]> {
  private readonly preferenceApi: PreferenceApi;

  constructor(name: TsPreferenceName) {
    this.preferenceApi = TServiceApi.preference(ContextUtil.getTsApplicationContext(), name);
  }

  getName(): string {
    return `UpdateThemeInfoStoreManger`;
  }

  clear(): Promise<void> {
    return this.preferenceApi.clear();
  }

  put(key: string, value: number | string[]): Promise<void> {
    return this.preferenceApi.put(key, value);
  }

  get(key: string, def?: number | string[] | undefined): Promise<number | string[] | undefined> {
    return this.preferenceApi.get(key, def)
      .then((result: preferences.ValueType) => result as number | string[] | undefined);
  }

  decode(values: string[]): UpdateResourceInfo[] {
    return ArrayUtils.map(values,
      (value: string) => JsonUtils.parse<UpdateResourceInfo>(value));
  }

  encode(data: UpdateResourceInfo[]): string[] | undefined {
    return ArrayUtils.map(data, (cacheInfo: UpdateResourceInfo) => JsonUtils.stringify(cacheInfo));
  }
}
