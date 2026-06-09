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

import { preferences } from '@kit.ArkData';
import {
  ArrayUtils,
  ContextUtil,
  PreferenceApi,
  JsonUtils,
  Singleton,
  StoreManager,
  StoreCache,
  TsLog
} from '@ohos/themeservicebase/Index';
import { TServiceApi } from '@ohos/themeservice_inner_api/Index';

export class ThemePropertyInfo {
  /**
   * 关联主题属性的id
   */
  public id: string = '';

  /**
   * 主题属性集合
   */
  public property: Map<string, string>;

  constructor(id: string, property: Map<string, string>) {
    this.id = id;
    this.property = property;
  }
}

export class ThemePropertyStoreManager implements StoreManager<ThemePropertyInfo[], string[]> {
  private readonly preferenceApi: PreferenceApi;

  constructor() {
    this.preferenceApi = TServiceApi.preference(ContextUtil.getTsApplicationContext(), 'ts_themeProperty');
  }

  getName(): string {
    return `ThemePropertyStoreManager`;
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

  decode(values: string[]): ThemePropertyInfo[] {
    let themePropertyList: ThemePropertyInfo[] = [];
    for (const themeProperty of values) {
      try {
        let id: string = JSON.parse(themeProperty)['id'];
        let objMap: string = JSON.parse(themeProperty)['property'];
        let targetMap: Map<string, string> = new Map<string, string>(Object.entries(objMap));
        themePropertyList.push(new ThemePropertyInfo(id, targetMap));
      } catch (e) {
        TsLog.error(this.getName(), `${themeProperty}, parse failed:${e}`);
      }
    }
    return themePropertyList;
  }

  encode(cacheInfos: ThemePropertyInfo[]): string[] {
    return ArrayUtils.map(cacheInfos, (cacheInfo: ThemePropertyInfo) => JsonUtils.stringify(cacheInfo));
  }
}

export class ThemePropertyCache extends StoreCache<ThemePropertyInfo[], string[]> {
  private static readonly INSTANCE: Singleton<ThemePropertyCache> =
    new Singleton<ThemePropertyCache>(() => new ThemePropertyCache());

  private constructor() {
    super(new ThemePropertyStoreManager());
  }

  /**
   * 获取单例对象
   *
   * @returns 对象
   */
  public static getInstance(): ThemePropertyCache {
    return ThemePropertyCache.INSTANCE.get();
  }
}