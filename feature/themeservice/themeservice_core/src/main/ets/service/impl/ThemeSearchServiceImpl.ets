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

import { Configuration, EnvironmentCallback } from '@kit.AbilityKit';
import { HashMap } from '@kit.ArkTS';
import { systemTimer } from '@kit.BasicServicesKit';
import { i18n, resourceManager } from '@kit.LocalizationKit';
import osAccount from '@ohos.account.osAccount';
import { PRESET_RES_THEME } from '@ohos/themeservice_inner_api';
import { ContextUtil, FileUtil, JsonUtils, Singleton } from '@ohos/themeservicebase';
import { TsLog } from '@ohos/themeservicebase/src/main/ets/log/TsLog';
import { SearchCache, SearchVersion, SearchVersionExt } from '../../cache/SearchVersionCache';
import { ThemeCategory } from '../../preset/ThemePackParser';
import { ThemeSearchResult, TSRemoteCaller } from '../../remote/caller/TSRemoteCaller';
import { SearchItemInfo, SearchItems } from '../../remote/model/ThemeSearchInfo';
import { HiSysEventUtils } from '../../util/HiSysEventUtils';
import { ThemeI18n } from '../../util/ThemeI18n';
import { TSPathUtils } from '../../util/TSPathUtils';
import { PathValidateUtil } from '../../validate/PathValidateUtil';
import { ThemeSearchService } from '../api/ThemeSearchService';

const TAG: string = 'ThemeSearchServiceImpl';
const DEFAULT_ENTRY_KEY: string = 'theme_settings';
const ITEM_NAME_PREFIX: string = 'themeId_';
const PARAM_PREFIX: string = 'themeDetail_';
const DEFAULT_ICON: string = '$media:ic_public_themes';
const DEFAULT_BUSINESS_ID: string = '100001';
const DEFAULT_BUNDLE_NAME: string = 'com.ohos.sceneboard';
const SEARCH_RESULT_SUCCESS: string = 'success';

const enum InjectSearchStatus {
  FAIL = 0,
  SUCCESS = 1,
  DELETE_FAIL = 2,
  UPDATE_FAIL = 3
}

export class ThemeSearchServiceImpl implements ThemeSearchService {
  private callbackId: number = -1;
  private locale: string = i18n.System.getSystemLocale();
  private isInjecting: boolean = false;

  async init(subscribe: boolean): Promise<void> {
    TsLog.info(TAG, `ThemeSearchServiceImpl init, subcribe: ${subscribe}`);
    let isOsAccountUnlocked: boolean = await osAccount.getAccountManager().isOsAccountUnlocked();
    if (!isOsAccountUnlocked) {
      TsLog.warning(TAG, `OS account is locked.`);
      return;
    }
    if (subscribe) {
      await this.injectSearch(this.locale);
      await this.subscribeLanguageChangeEvent();
      return;
    }
    let options: systemTimer.TimerOptions = {
      // 精确定时唤醒，采用开机时长
      type: systemTimer.TIMER_TYPE_WAKEUP | systemTimer.TIMER_TYPE_EXACT | systemTimer.TIMER_TYPE_REALTIME,
      // 一次性不重复
      repeat: false,
      // 定时回调
      callback: async () => {
        await this.injectSearch(this.locale);
        await this.subscribeLanguageChangeEvent();
      }
    }
    // 创建定时器
    let timerId: number = await systemTimer.createTimer(options);
    // 启动定时器（Id，定时器到期时间）
    await systemTimer.startTimer(timerId, 60 * 1000);
  }

  public async injectSearch(locale: string): Promise<void> {
    if (this.isInjecting) {
      TsLog.warning(TAG, `search item is being injected`);
      return;
    }
    this.isInjecting = true;
    TsLog.info(TAG, `inject search locale: ${locale}`);
    let searchVersionExtArray: SearchVersionExt[] = [];
    let cacheMap: HashMap<string, HashMap<string, string>> = new HashMap();
    try {
      await this.readSearchVersionExt(searchVersionExtArray);
      cacheMap = await this.readVersionCache();
      let versionMap: HashMap<string, string> = cacheMap.get(locale) ?? new HashMap();
      TsLog.info(TAG, `searchVersionExtArray: ${searchVersionExtArray.length}, cache: ${versionMap.length}`);
      let itemsNotInCache: SearchVersion[] = await this.getItemsNotInCache(searchVersionExtArray, versionMap);
      let itemsNeedUpdate: SearchVersionExt[] = await this.getItemsNeedUpdate(searchVersionExtArray, versionMap);
      await this.updateSearchAndCache(itemsNeedUpdate, itemsNotInCache, cacheMap, locale);
    } catch (err) {
      TsLog.error(TAG, `check and update error`, err);
    } finally {
      this.isInjecting = false;
    }
  }

  async subscribeLanguageChangeEvent(): Promise<void> {
    if (this.callbackId > -1) {
      TsLog.warning(TAG, 'Language change has been registered.');
      return;
    }
    let environmentCallBack: EnvironmentCallback = {
      async onConfigurationUpdated(config: Configuration) {
        if (config.language && this.locale !== config.language) {
          this.locale = config.language;
          await themeSearchService.get().injectSearch(this.locale);
        }
      },
      onMemoryLevel(level) {
        TsLog.info(TAG, `onMemoryLevel level: ${level}`)
      }
    };
    try {
      this.callbackId = ContextUtil.getTsServiceContext().getApplicationContext().on('environment', environmentCallBack);
    } catch (err) {
      TsLog.error(TAG, `failed to register applicationContext`, err);
    }
  }

  async readSearchVersionExt(searchVersionExtArray: SearchVersionExt[]): Promise<void> {
    const themeDirList: string[] = await TSPathUtils.getTsPresetRootPath(PRESET_RES_THEME);
    for (const themeDir of themeDirList) {
      // 从json文件中获取主题清单，将主题清单解析为ThemeCategory数组。当前json文件为manifest.json
      const themeManifest: string = FileUtil.getStringByFile(`${themeDir}/manifest.json`);
      const themeCategoryArray: ThemeCategory[] | undefined = JsonUtils.parse(themeManifest);
      if (!themeCategoryArray || themeCategoryArray.length === 0) {
        TsLog.error(TAG, `parseAll is null`);
        continue;
      }
      for (let themeCategory of themeCategoryArray) {
        if (!themeCategory.dir) {
          continue;
        }
        await this.handleThemeCategory(themeCategory, themeDir, searchVersionExtArray);
      }
    }
  }

  async handleThemeCategory(themeCategory: ThemeCategory, presetThemeRootPath: string,
    searchVersionExtArray: SearchVersionExt[]): Promise<void> {
    if (themeCategory.dir.length === 0) {
      TsLog.warning(TAG, `handleThemeCategory, empty dir`);
      return;
    }
    const tsResourceManager: resourceManager.ResourceManager = ContextUtil.getTsServiceContext().resourceManager;
    if (!tsResourceManager) {
      TsLog.warning(TAG, `resourceManager does not exist`);
      return;
    }
    for (let themeDir of themeCategory.dir) {
      // 解析dir对应路径下的主题包配置信息
      try {
        const presetThemePath: string = `${presetThemeRootPath}/${themeDir.theme}`;
        const validate: boolean = await PathValidateUtil.validatePath(presetThemePath);
        if (!validate) {
          TsLog.warning(TAG, `handleThemeCategory path validate fail`);
          continue;
        }
        const descriptionPath: string = `${presetThemePath}/description.json`;
        if (!FileUtil.isFileExists(descriptionPath)) {
          TsLog.warning(TAG, `description does not exist`);
          continue;
        }
        const descriptionManifest: string = await FileUtil.readFileContent(descriptionPath);
        const descriptionContent: object = JSON.parse(descriptionManifest);
        const id: string = descriptionContent['id'];
        const titleName: string = descriptionContent['title'];
        const version: string = descriptionContent['version'];
        let themeSearchItem: string[] = descriptionContent['theme_search_item'] ?? [];
        themeSearchItem.push(titleName);
        let alias: string = await ThemeI18n.getInstance().getI18nAlias(`${presetThemePath}/i18n`, themeSearchItem);
        const itemTitle: string = await ThemeI18n.getInstance().getI18nGlobal(titleName, presetThemePath);
        const searchItemInfo: SearchItemInfo = {
          itemName: `${ITEM_NAME_PREFIX}${id}`,
          itemTitle: itemTitle,
          entryKey: DEFAULT_ENTRY_KEY,
          pageTitle: itemTitle,
          params: `${PARAM_PREFIX}${id}`,
          enable: '1',
          path: `${tsResourceManager.getStringByNameSync('Desktop_individuation')} > ${tsResourceManager.getStringByNameSync('theme_title')}`,
          icon: DEFAULT_ICON,
          alias: alias,
          bundleName: DEFAULT_BUNDLE_NAME
        }
        const searchVersionExt: SearchVersionExt = new SearchVersionExt(id, searchItemInfo);
        searchVersionExt.version = version;
        searchVersionExtArray.push(searchVersionExt);
      } catch (error) {
        TsLog.error(TAG, `handleThemeCategory failed`, error);
      }
    }
  }

  async getItemsNotInCache(searchVersionExtArray: SearchVersionExt[],
    versionMap: HashMap<string, string>): Promise<SearchVersion[]> {
    let itemsNotInCache: SearchVersion[] = [];
    let searchVersionIds: Set<string> = new Set(searchVersionExtArray.map(ext => ext.id));
    versionMap.forEach((value, key) => {
      if (key && !searchVersionIds.has(key)) {
        itemsNotInCache.push(new SearchVersion(key, value ?? ''));
      }
    });
    TsLog.info(TAG, `itemsNotInArray: ${itemsNotInCache.length}`);
    return itemsNotInCache;
  }

  async getItemsNeedUpdate(searchVersionExtArray: SearchVersionExt[],
    versionMap: HashMap<string, string>): Promise<SearchVersionExt[]> {
    let itemsNeedUpdate: SearchVersionExt[] = [];
    for (const searchVersionExt of searchVersionExtArray) {
      let versionCache: Nullable<string> = versionMap?.get(searchVersionExt.id);
      if (searchVersionExt.version !== versionCache) {
        // 版本号只比较不同
        TsLog.info(TAG,
          `update id: ${searchVersionExt.id}, cache: ${versionCache}, version: ${searchVersionExt.version}`);
        itemsNeedUpdate.push(searchVersionExt);
      }
    }
    TsLog.info(TAG, `itemsNeedUpdate: ${itemsNeedUpdate.length}`);
    return itemsNeedUpdate;
  }

  async updateSearchAndCache(itemsNeedUpdate: SearchVersionExt[], itemsNotInCache: SearchVersion[],
    cacheMap: HashMap<string, HashMap<string, string>>, locale: string): Promise<void> {
    let updateResult: boolean = false;
    let deleteResult: boolean = false;
    let versionMap: HashMap<string, string> = cacheMap.get(locale) ?? new HashMap();
    let ids: string[] = [];
    let versions: string[] = [];
    if (itemsNeedUpdate.length > 0) {
      itemsNeedUpdate.forEach((itemExt) => {
        ids.push(itemExt.id);
        versions.push(itemExt.version);
      })
      let itemList: SearchItemInfo[] = itemsNeedUpdate.map(itemExt => itemExt.itemInfo);
      let result: string = await this.updateSearchItems(itemList);
      TsLog.info(TAG, `updateSearchItems result: ${result}`);
      if (result === SEARCH_RESULT_SUCCESS) {
        itemsNeedUpdate.forEach(itemExt => versionMap.set(itemExt.id, itemExt.version));
        updateResult = true;
      }
    }
    updateResult = updateResult || (itemsNeedUpdate.length <= 0);
    if (itemsNotInCache.length > 0) {
      itemsNotInCache.forEach((item) => {
        ids.push(item.id);
        versions.push('d');
      })
      const deleteItems: string[] = itemsNotInCache.map(item => `${ITEM_NAME_PREFIX}${item.id}`);
      const result = await this.deleteSearchItems(deleteItems);
      TsLog.info(TAG, `deleteSearchItems result: ${result}`);
      if (result === SEARCH_RESULT_SUCCESS) {
        itemsNotInCache.forEach(itemExt => {
          versionMap.remove(itemExt.id);
        });
        deleteResult = true;
      }
    }
    deleteResult = deleteResult || (itemsNotInCache.length <= 0);
    if (itemsNeedUpdate.length <= 0 && itemsNotInCache.length <= 0) {
      TsLog.warning(TAG, `no need update or delete`);
      return;
    }
    let status: number =
      (updateResult === deleteResult) ? (updateResult ? InjectSearchStatus.SUCCESS : InjectSearchStatus.FAIL) :
        (updateResult ? InjectSearchStatus.DELETE_FAIL : InjectSearchStatus.UPDATE_FAIL);
    if (status !== InjectSearchStatus.FAIL) {
      cacheMap.set(locale, versionMap);
      await this.updateVersionCache(cacheMap);
    }
    HiSysEventUtils.reportThemeSearch(locale, status, ids, versions);
  }

  async readVersionCache(): Promise<HashMap<string, HashMap<string, string>>> {
    const cachePath: string = `${TSPathUtils.getTsCachePath()}`;
    if (!FileUtil.createDirRecur(cachePath)) {
      TsLog.warning(TAG, `read version cache failed`);
      return new HashMap();
    }
    const cacheContent: string = await FileUtil.readFileContent(`${cachePath}/theme_search.json`);
    let caches: SearchCache[] = JsonUtils.parse(cacheContent) ?? [];
    let cacheMap: HashMap<string, HashMap<string, string>> = new HashMap();
    caches.forEach(cache => {
      let versionMap: HashMap<string, string> = new HashMap();
      cache.versions.forEach(item => versionMap.set(item.id, item.version));
      cacheMap.set(cache.locale, versionMap);
    });
    return cacheMap;
  }

  async updateVersionCache(cacheMap: HashMap<string, HashMap<string, string>>): Promise<void> {
    const cachePath: string = `${TSPathUtils.getTsCachePath()}`;
    if (!FileUtil.createDirRecur(cachePath)) {
      TsLog.warning(TAG, `update version cache failed`);
      return;
    }
    const searchCachePath: string = `${cachePath}/theme_search.json`;
    await FileUtil.deleteAsync(searchCachePath);
    let newCaches: SearchCache[] = [];
    cacheMap.forEach((map, locale) => {
      let newVersions: SearchVersion[] = [];
      map?.forEach((value, key) => {
        if (key) {
          newVersions.push(new SearchVersion(key, value ?? ''));
        }
      })
      if (locale) {
        newCaches.push(new SearchCache(locale, newVersions));
      }
    });
    FileUtil.writeFileSync(searchCachePath, JsonUtils.stringify(newCaches));
  }

  async deleteSearchItems(itemList: string[]): Promise<string> {
    let searchItems: SearchItems = {
      businessId: DEFAULT_BUSINESS_ID,
      bundleName: DEFAULT_BUNDLE_NAME,
      itemList: itemList
    };
    let result: Nullable<ThemeSearchResult>;
    try {
      result = await TSRemoteCaller.notifySearchItems('deleteSearchItems', searchItems);
    } catch (err) {
      TsLog.error(TAG, `deleteSearchItems error`, err);
    }
    return result?.resultValue ?? '';
  }

  async updateSearchItems(itemList: object[]): Promise<string> {
    let searchItems: SearchItems = {
      businessId: DEFAULT_BUSINESS_ID,
      bundleName: DEFAULT_BUNDLE_NAME,
      itemList: itemList
    };
    let result: Nullable<ThemeSearchResult>;
    try {
      result = await TSRemoteCaller.notifySearchItems('updateSearchItems', searchItems);
    } catch (err) {
      TsLog.error(TAG, `updateSearchItems error`, err);
    }
    return result?.resultValue ?? '';
  }
}

export const themeSearchService: Singleton<ThemeSearchService> =
  new Singleton<ThemeSearchService>(() => new ThemeSearchServiceImpl());
