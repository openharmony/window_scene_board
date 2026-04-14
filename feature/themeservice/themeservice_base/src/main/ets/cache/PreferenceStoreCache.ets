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
import { JsonUtils } from '../utils/JsonUtils';
import { PreferenceApi } from './PreferenceApi';
import { StoreCache, StoreManager, StoreMigrator } from './StoreCache';

class PreferenceStoreManager<T> implements StoreManager<T, string> {
  private readonly preferenceApi: PreferenceApi;

  constructor(preferenceApi: PreferenceApi) {
    this.preferenceApi = preferenceApi;
  }

  put(key: string, value: string | number): Promise<void> {
    return this.preferenceApi.put(key, value);
  }

  get(key: string, def?: string | number | undefined): Promise<string | number | undefined> {
    return this.preferenceApi.get(key, def).then((value) => {
      return value as string | number | undefined;
    });
  }

  decode(value: string): T | undefined {
    return JsonUtils.parse(value);
  }

  encode(data: T): string | undefined {
    return JsonUtils.stringify(data);
  }

  public getName(): string {
    return this.preferenceApi.getName();
  }

  public clear(): Promise<void> {
    return this.preferenceApi.clear();
  }
}

/**
 * 首选项存储能力缓存
 */
export class PreferenceStoreCache<T> extends StoreCache<T, string> {
  constructor(preferenceApi: PreferenceApi, migrator?: StoreMigrator<T> | undefined, version?: number) {
    super(new PreferenceStoreManager<T>(preferenceApi), migrator, version);
  }
}