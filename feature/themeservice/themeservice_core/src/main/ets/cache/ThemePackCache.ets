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
import { ORIGIN_PRESET_FRAGMENT, ThemePackInfo } from '@ohos/themeservice_inner_api';
import { ArrayUtils, FileUtil, JsonUtils, MemoryCache, Singleton, StringUtils, TsLog } from '@ohos/themeservicebase';
import { PresetParser } from '../preset/PresetParser';
import { getThemePackParser } from '../preset/ThemePackParser';
import { Description } from '../service/model/Description';
import { ThemePackUtils } from '../util/ThemePackUtils';
import { ThemeCacheInfo } from './ThemeInfoStoreCache';

export class ThemePackCacheData {
  /**
   * 主题id
   */
  private readonly _id: string;
  /**
   * 主题包内容
   */
  private _themePack: ThemePackInfo;
  /**
   * 是否是默认主题
   */
  private readonly _isDefault: boolean;

  constructor(id: string, themePack: ThemePackInfo, isDefault: boolean) {
    this._id = id;
    this._themePack = themePack;
    this._isDefault = isDefault;
  }

  public get isDefault(): boolean {
    return this._isDefault;
  }

  public get themePack(): ThemePackInfo {
    return this._themePack;
  }

  public set themePack(value: ThemePackInfo) {
    this._themePack = value;
  }

  public get id(): string {
    return this._id;
  }
}

const TAG: string = 'ThemePackCache';

export class ThemePackCache extends MemoryCache<ThemePackCacheData[]> {
  private static readonly INSTANCE: Singleton<ThemePackCache> =
    new Singleton<ThemePackCache>(() => new ThemePackCache());

  /**
   * 获取单例对象
   *
   * @returns 对象
   */
  public static getInstance(): ThemePackCache {
    return ThemePackCache.INSTANCE.get();
  }

  private constructor() {
    super(`ThemePackCache`, () => this.init());
  }

  public get(): Promise<Nullable<ThemePackCacheData[]>> {
    return super.get().then((cacheDataList) => {
      if (cacheDataList) {
        TsLog.debug(TAG,
          `get cache: ${cacheDataList.map(cacheData =>
          `id:${cacheData.id}, src filename:${FileUtil.getFileName(cacheData?.themePack?.srcPath)}`)
            .join(';')}`);
      } else {
        TsLog.debug(TAG, `get No cache`);
      }
      return cacheDataList;
    });
  }

  private async init(): Promise<ThemePackCacheData[]> {
    try {
      let parser: PresetParser<ThemePackInfo> = getThemePackParser();
      let defaultId: Nullable<string> = await this.getDefaultId(parser);
      let presetPackInfos: ThemePackInfo[] = await parser.parseAll('manifest.json');
      const themePackageDataArray: ThemePackCacheData[] =
        ArrayUtils.map(presetPackInfos, packInfo => this.createCacheData(packInfo, defaultId));
      const filterThemePackageCache: ThemePackCacheData[] = [];
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

  public async reset(): Promise<void> {
    let initData: ThemePackCacheData[] = await this.init();
    if (initData?.length > 0) {
      await this.update(initData);
    } else {
      await this.clear();
    }
  }

  private async getDefaultId(parser: PresetParser<ThemePackInfo>): Promise<Nullable<string>> {
    let defaultPackInfo: ThemePackInfo = await parser.parseDefault();
    return this.getThemePackId(defaultPackInfo);
  }

  private createCacheData(themePack: ThemePackInfo, defaultId?: string | undefined): Nullable<ThemePackCacheData> {
    let themeId: Nullable<string> = this.getThemePackId(themePack);
    return themeId !== undefined ? new ThemePackCacheData(themeId, themePack, defaultId ? themeId === defaultId :
      false) :
      undefined;
  }

  private getThemePackId(themePack: ThemePackInfo): Nullable<string> {
    let id: Nullable<string> = JsonUtils.parse<Description>(themePack?.description)?.id;
    TsLog.debug(TAG, `getThemePackId :${id}`);
    if (id === undefined) {
      return;
    }
    return id.toString();
  }

  public async addThemesIfNot(themeCaches: ThemeCacheInfo[]): Promise<void> {
    let parser: PresetParser<ThemePackInfo> = getThemePackParser();
    let dataList: ThemePackCacheData[] = [];
    let themeCacheIds: string[] = [];
    for (const themeCache of themeCaches) {
      if (!FileUtil.isFileExists(themeCache.srcPath)) {
        continue;
      }
      if (await this.contains(themeCache.id) || themeCacheIds.indexOf(themeCache.id) >= 0) {
        continue;
      }
      themeCacheIds.push(themeCache.id);
      let themePackInfo: ThemePackInfo = await parser.parse(themeCache.srcPath);
      const cacheData: Nullable<ThemePackCacheData> = this.createCacheData(themePackInfo);
      if (cacheData) {
        dataList.push(cacheData);
      }
    }

    TsLog.info(TAG, `addThemes size:${dataList.length}`);
    return this.updateCache(...dataList);
  }

  // 上云主题已经被下载，重启后需要更新包
  public async updatePresetFragment(cacheInfoList: ThemeCacheInfo[]): Promise<void> {
    let parser: PresetParser<ThemePackInfo> = getThemePackParser();
    let themePackCaches: ThemePackCacheData[] = await this.get() ?? [];
    for (const cacheInfo of cacheInfoList) {
      if (cacheInfo.originType === ORIGIN_PRESET_FRAGMENT) {
        continue;
      }
      if (!FileUtil.isFileExists(cacheInfo.srcPath)) {
        continue;
      }
      const themePackInfo: ThemePackInfo = await parser.parse(cacheInfo.srcPath);
      for (const themePackCache of themePackCaches) {
        if (!StringUtils.equals(cacheInfo.id, themePackCache.id)) {
          continue;
        }
        if (ThemePackUtils.getDescription(themePackCache.themePack?.description, 'origin') === ORIGIN_PRESET_FRAGMENT) {
          themePackCache.themePack = themePackInfo;
        }
      }
    }
    await this.update(themePackCaches);
  }

  public async removeOriginThemePack(themeIds: string[]): Promise<void> {
    let cacheDataList: ThemePackCacheData[] = await this.get() ?? [];
    TsLog.info(TAG, `removeOriginThemePack...  before cacheSize:${cacheDataList.length}`);
    if (cacheDataList.length === 0) {
      return;
    }
    themeIds.forEach(id => cacheDataList = cacheDataList.filter(cache => cache.id !== id));
    TsLog.info(TAG, `removeOriginThemePack...  after cacheSize:${cacheDataList.length}`);
    await this.update(cacheDataList);
  }

  public async addIfNot(themePack: ThemePackInfo): Promise<void> {
    if (themePack?.description === undefined) {
      return
    }
    let id: object = JSON.parse(themePack.description)['id'];
    let themeId: string = typeof id === 'string' ? id : id?.toString();
    let defId: Nullable<string> = await this.getDefaultId(getThemePackParser());
    const cacheData: Nullable<ThemePackCacheData> = this.createCacheData(themePack, defId);
    this.addIfNotUpdateCache(themeId, cacheData);
  }

  private async addIfNotUpdateCache(id: string, cacheData: Nullable<ThemePackCacheData>): Promise<void> {
    let cacheDataList: ThemePackCacheData[] = await this.get() ?? [];
    TsLog.info(TAG, `addIfNotUpdateCach..  before cacheSize:${cacheDataList.length}`);
    if (cacheDataList.filter(data => data.id === id)?.length > 0) {
      cacheDataList = cacheDataList.filter(cache => cache.id !== id);
    }
    TsLog.info(TAG, `addIfNotUpdateCach..  cacheSize:${cacheDataList.length}`);
    if (cacheData) {
      cacheDataList.push(cacheData);
    }
    TsLog.info(TAG, `addIfNotUpdateCach..  end cacheSize:${cacheDataList.length}`);
    if (id && cacheDataList.length > 0) {
      await this.update(cacheDataList);
    }
  }

  private async contains(id: string): Promise<boolean> {
    let cacheDataList: ThemePackCacheData[] = await this.get() ?? [];
    return cacheDataList.filter(data => data.id === id)?.length > 0;
  }

  private async updateCache(...cacheData: ThemePackCacheData[]): Promise<void> {
    let cacheDataList: ThemePackCacheData[] = await this.get() ?? [];
    TsLog.info(TAG, `updateCache...  cacheSize:${cacheDataList.length}`);
    cacheDataList.push(...cacheData);
    TsLog.info(TAG, `updateCache. cacheSize:${cacheDataList.length}, add newCache:${cacheData.length}`);
    if (cacheDataList.length > 0) {
      await this.update(cacheDataList);
    }
  }
}