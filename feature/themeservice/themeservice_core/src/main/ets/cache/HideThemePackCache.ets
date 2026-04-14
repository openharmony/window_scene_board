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
import { ThemePackInfo } from '@ohos/themeservice_inner_api';
import { ArrayUtils, JsonUtils, MemoryCache, Singleton, TsLog } from '@ohos/themeservicebase';
import { PresetParser } from '../preset/PresetParser';
import { getThemePackParser } from '../preset/ThemePackParser';
import { Description } from '../service/model/Description';
import { ThemePackCacheData } from './ThemePackCache';

const TAG: string = 'HideThemePackCache';

export class HideThemePackCache extends MemoryCache<ThemePackCacheData[]> {
  private static readonly INSTANCE: Singleton<HideThemePackCache> =
    new Singleton<HideThemePackCache>(() => new HideThemePackCache());

  /**
   * 获取单例对象
   *
   * @returns 对象
   */
  public static getInstance(): HideThemePackCache {
    return HideThemePackCache.INSTANCE.get();
  }

  private constructor() {
    super(`HideThemePackCache`, () => this.init());
  }

  public get(): Promise<Nullable<ThemePackCacheData[]>> {
    return super.get().then((cacheDataList) => {
      TsLog.info(TAG, `get cache success.`);
      return cacheDataList;
    });
  }

  private async init(): Promise<ThemePackCacheData[]> {
    try {
      let parser: PresetParser<ThemePackInfo> = getThemePackParser();
      const filterThemePackageCache: ThemePackCacheData[] = [];
      let presetPackInfos: ThemePackInfo[] = await parser.parseAll('hidemanifest.json');
      if (presetPackInfos.length === 0) {
        return filterThemePackageCache;
      }
      const themePackageDataArray: ThemePackCacheData[] =
        ArrayUtils.map(presetPackInfos, packInfo => this.createCacheData(packInfo));
      themePackageDataArray.forEach((target: ThemePackCacheData) => {
        const hasTheme: boolean = Array.from(filterThemePackageCache).some((exist: ThemePackCacheData) => {
          return target.id.toString() === exist.id.toString();
        });
        if (!hasTheme) {
          filterThemePackageCache.push(target);
        }
      });
      return filterThemePackageCache;
    } catch (err) {
      TsLog.error(TAG, `init catch exception.`, err);
    }
    return [];
  }

  private createCacheData(themePack: ThemePackInfo, defaultId?: string | undefined): Nullable<ThemePackCacheData> {
    let themeId: Nullable<string> = this.getThemePackId(themePack);
    return themeId !== undefined ? new ThemePackCacheData(themeId, themePack, defaultId ? themeId === defaultId :
      false) : undefined;
  }

  private getThemePackId(themePack: ThemePackInfo): Nullable<string> {
    let id: Nullable<string> = JsonUtils.parse<Description>(themePack?.description)?.id;
    TsLog.debug(TAG, `getThemePackId :${id}`);
    if (id === undefined) {
      return;
    }
    return id.toString();
  }
}