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
import { ArrayList } from '@kit.ArkTS';
import { Description } from 'ets/service/model/Description';
import { systemDateTime } from '@kit.BasicServicesKit';
import {
  EventId,
  OriginType,
  ORIGIN_ONLINE,
  ORIGIN_PRESET,
  ORIGIN_PRESET_FRAGMENT,
  TargetType,
  ThemeCode,
  ThemeInfo,
  ThemeMixInfo,
  ThemeOnlineInfo,
  ThemePackInfo
} from '@ohos/themeservice_inner_api';
import {
  EventEmitter,
  FileUtil,
  JsonUtils,
  MapUtils,
  NullableType,
  ObjectUtils,
  Singleton,
  StringUtils,
  TsLog
} from '@ohos/themeservicebase';
import { GetThemeType, TsGetThemeType } from 'ets/contant/TSTypes';
import { ActivatedThemeCache } from '../../cache/ActivatedThemeCache';
import { HideThemePackCache } from '../../cache/HideThemePackCache';
import { PresetThemeExtCache, PresetThemeIdCache } from '../../cache/PresetThemeCache';
import { OnlineInfo, ThemeCacheInfo, ThemeEditInfo, ThemeInfoStoreCache } from '../../cache/ThemeInfoStoreCache';
import { ThemeOptimizeCache } from '../../cache/ThemeOptimizeCache';
import { ThemePackCache, ThemePackCacheData } from '../../cache/ThemePackCache';
import { getCustomThemePack, getThemePackParser } from '../../preset/ThemePackParser';
import { ActivatedThemeUtil } from '../../util/ActivatedThemeUtil';
import { TSPathUtils } from '../../util/TSPathUtils';
import { PathValidateUtil } from '../../validate/PathValidateUtil';
import { ThemeInfoService } from '../api/ThemeInfoService';
import { FontInfo } from '../model/FontInfo';
import { excludedThemeList } from './activate/ThemeMixedExecutor';
import { themeResourceOptService } from './optimize/ThemeResourceOptimizeServiceImpl';
import { themeTrialService } from './ThemeTrialServiceImpl';
import { tsOnlineRecommend } from './TsOnlineRecommendImpl';
import { updateThemeInfoService } from './UpdateThemeInfoServiceImpl';
import { setWallPaperImageService } from './activate/SetWallpaperImageImpl';


interface CategorizedData {
  invalidCache: ThemeCacheInfo[],

  validCache: ThemeCacheInfo[],

  maxAddOrder: number;

  maxOrder: number;
}

const TAG: string = 'ThemeInfoServiceImpl';
const MAX_NUM: number = 31;

export class ThemeInfoServiceImpl implements ThemeInfoService {
  private maxAddOrder: number = 0;

  private maxOrder: number = 0;

  private userThemeList: Nullable<ThemeCacheInfo[]>;

  async init(): Promise<void> {
    let categorizedData: CategorizedData = await this.classifyCache(true);
    TsLog.info(TAG, `categorizedData maxAddOrder:${categorizedData.maxAddOrder}`);
    TsLog.info(TAG, `categorizedData maxOrder:${categorizedData.maxOrder}`);
    TsLog.info(TAG, `categorizedData invalidCache:${categorizedData.invalidCache?.length}`);
    TsLog.info(TAG, `categorizedData validCache:${categorizedData.validCache?.length}`);
    if (categorizedData?.validCache?.length <= 0) {
      // 无有效数据重新从预置数据更新缓存
      await ThemeInfoStoreCache.getInstance().reset();
      TsLog.info(TAG, `The theme pack has been replaced and the cache has been reset.`);
      categorizedData = await this.classifyCache(false);
    } else {
      //更新有效数据（删除无效数据）
      if (categorizedData?.invalidCache.length > 0) {
        await ThemeInfoStoreCache.getInstance().update(categorizedData.validCache);
      }
    }
    // 初始化非预置数据包缓存
    let themeCacheInfos: Nullable<ThemeCacheInfo[]> = categorizedData.validCache?.
    filter(cache => cache.originType !== ORIGIN_PRESET);
    TsLog.info(TAG, `Non-preset theme caches: ${themeCacheInfos?.length}`);
    if (themeCacheInfos) {
      await ThemePackCache.getInstance().updatePresetFragment(themeCacheInfos);
      await ThemePackCache.getInstance().addThemesIfNot(themeCacheInfos);
    }
    this.maxAddOrder = categorizedData?.maxAddOrder;
    this.maxOrder = categorizedData?.maxOrder;
    this.userThemeList = categorizedData?.validCache;
    this.updateActivatedThemeCache()
    TsLog.info(TAG,
      `maxAddOrder:${this.maxAddOrder}, maxOrder:${this.maxOrder},userThemes:${this.userThemeList?.length}`);
    themeResourceOptService.get().subscribeOptEvent();
    setWallPaperImageService.get().subscribeWallpaperEvent();
    ThemeOptimizeCache.getInstance().refreshCache();
  }

  async reset(): Promise<void> {
    await ThemePackCache.getInstance().reset();
    return ThemeInfoStoreCache.getInstance().reset()
      .then((resetRet) => {
        if (resetRet) {
          return this.init();
        }
        return;
      });
  }

  async classifyCache(correctionOrder: boolean): Promise<CategorizedData> {
    let maxAddOrder: number = Number.MIN_VALUE;
    let maxOrder: number = Number.MIN_VALUE;
    let cacheInfos: NullableType<ThemeCacheInfo[]> = await ThemeInfoStoreCache.getInstance().get();
    if (correctionOrder && cacheInfos) {
      await this.correctionOrder(cacheInfos)
    }
    let invalidCache: ThemeCacheInfo[] = [];
    let validCache: ThemeCacheInfo[] = [];
    // 预置数据
    let themePackList: NullableType<ThemePackCacheData[]> = await ThemePackCache.getInstance().get();
    let hideThemePackList: NullableType<ThemePackCacheData[]> = await HideThemePackCache.getInstance().get();
    if (cacheInfos && themePackList) {
      for (let cache of cacheInfos) {
        // 由于升级主题包删除等问题，可能丢失画廊默认主题
        if (!this.isThemeCacheValid(cache, themePackList, hideThemePackList)) {
          // 预置包已经删除的数据，识别为失效缓存
          invalidCache.push(cache);
          continue;
        }
        validCache.push(cache);
        maxAddOrder = maxAddOrder > cache.addOrder ? maxAddOrder : cache.addOrder;
        maxOrder = maxOrder > cache.order ? maxOrder : cache.order;
      }
    }
    await this.addNewPresetTheme(validCache);
    return {
      invalidCache: invalidCache,
      validCache: validCache,
      maxAddOrder: maxAddOrder,
      maxOrder: maxOrder
    }
  }

  private async correctionOrder(cacheInfos: ThemeCacheInfo[]): Promise<void> {
    let minAddOrder: number | undefined = undefined;
    cacheInfos.forEach((themeCache: ThemeCacheInfo) => {
      if (themeCache.addOrder != undefined) {
        if (minAddOrder == undefined) {
          minAddOrder = themeCache.addOrder;
        } else {
          minAddOrder = Math.min(minAddOrder, themeCache.addOrder);
        }
      }
    });
    minAddOrder = minAddOrder ?? 0;
    TsLog.info(TAG, `correctionOrder minAddOrder:${minAddOrder}`);
    let corrected: boolean = false;
    for (const cache of cacheInfos) {
      if (cache.addOrder == undefined) {
        --minAddOrder;
        cache.addOrder = minAddOrder
        corrected = true;
      }
    }
    if (corrected) {
      await ThemeInfoStoreCache.getInstance().update(cacheInfos);
    }
  }

  private async addNewPresetTheme(validCache: ThemeCacheInfo[]): Promise<void> {
    let cachedPresetThemeList: NullableType<string[]> = await PresetThemeIdCache.getInstance().get();
    let presetThemeList: NullableType<ThemePackCacheData[]> = await ThemePackCache.getInstance().get();
    if (!presetThemeList || presetThemeList.length === 0) {
      return;
    }
    const presetThemeIdList: string[] = [];
    for (let themeCacheData of presetThemeList) {
      presetThemeIdList.push(themeCacheData.id.toString());
    }
    await PresetThemeIdCache.getInstance().update(presetThemeIdList);
    if (!cachedPresetThemeList || cachedPresetThemeList.length === 0) {
      TsLog.info(TAG, `no cached preset theme data,ignore`);
      return;
    }
    const newAddPresetThemeList: ThemePackCacheData[] = [];
    for (let presetTheme of presetThemeList) {
      let existCachedPreset: NullableType<string> =
        cachedPresetThemeList.find((cachedThemeId: string) => StringUtils.equals(cachedThemeId, presetTheme.id));
      if (!existCachedPreset) {
        newAddPresetThemeList.push(presetTheme);
      }
    }
    if (newAddPresetThemeList.length === 0) {
      return;
    }
    const addOrderList: number[] = [];
    const orderList: number[] = [];
    validCache.forEach((themeCache: ThemeCacheInfo) => {
      addOrderList.push(themeCache.addOrder);
      orderList.push(themeCache.order);
    });
    let minAddOrder: number = addOrderList.length > 0 ? Math.min(...addOrderList) : 0;
    let minOrder: number = orderList.length > 0 ? Math.min(...orderList) : 0;
    TsLog.info(TAG, `minOrder:` + minOrder);
    for (const newPresetTheme of newAddPresetThemeList) {
      if (validCache.length >= MAX_NUM - 1) {
        return;
      }
      let cacheInfo: ThemeCacheInfo = new ThemeCacheInfo();
      cacheInfo.id = newPresetTheme.id.toString();
      cacheInfo.addOrder = --minAddOrder
      cacheInfo.order = --minOrder;
      cacheInfo.originType = newPresetTheme.themePack?.origin ?? ORIGIN_PRESET;
      cacheInfo.isPresetFragment = cacheInfo.originType === ORIGIN_PRESET_FRAGMENT;
      cacheInfo.srcPath = newPresetTheme.themePack?.srcPath;
      cacheInfo.editorId = systemDateTime.getTime(true).toString();
      validCache.push(cacheInfo);
      TsLog.info(TAG, `new preset theme add:${newPresetTheme.id}`);
    }
    await ThemeInfoStoreCache.getInstance().update(validCache);
  }

  private async updateActivatedThemeCache(): Promise<void> {
    let presetThemeList: NullableType<ThemePackCacheData[]> = await ThemePackCache.getInstance().get();
    let themeInfo: NullableType<ThemeCacheInfo> = await ActivatedThemeCache.getInstance().get();
    let cachedPreset: NullableType<ThemePackCacheData> =
      presetThemeList?.find((cachedTheme: ThemePackCacheData) => StringUtils.equals(cachedTheme.id, themeInfo?.id));
    TsLog.info(TAG, `updateActivatedThemeCache themeInfo id : ${themeInfo?.id}`);
    if (themeInfo && cachedPreset && themeInfo.srcPath !== cachedPreset.themePack.srcPath) {
      themeInfo.srcPath = cachedPreset.themePack.srcPath
      ActivatedThemeCache.getInstance().update(themeInfo);
    }
  }

  private isThemeCacheValid(themeCache: ThemeCacheInfo, themePackList: NullableType<ThemePackCacheData[]>,
    hideThemePackList: NullableType<ThemePackCacheData[]>): boolean {
    if (themeCache.originType === ORIGIN_ONLINE && !themeCache.isPresetFragment) {
      if (!FileUtil.isFileExists(themeCache.srcPath)) {
        TsLog.info(TAG, `Theme lost id:${themeCache.id},filename:${FileUtil.getFileName(themeCache.srcPath)}`);
        return false;
      }
    }
    if (themeCache.originType === ORIGIN_PRESET || themeCache.originType === ORIGIN_PRESET_FRAGMENT ||
      (themeCache.originType === ORIGIN_ONLINE && themeCache.isPresetFragment)) {
      let presetCache: Nullable<ThemePackCacheData> = themePackList?.find(presetInfo =>
        presetInfo.id.toString() === themeCache.id.toString());
      if (!presetCache) {
        TsLog.info(TAG, `get theme from hide theme pack list.`);
        presetCache = hideThemePackList?.find(presetInfo => presetInfo.id.toString() === themeCache.id.toString());
      }
      // 预置主题包对应的资源ID已经不存在了
      if (!presetCache) {
        TsLog.info(TAG, `Theme preset lost id:${themeCache.id},filename:${FileUtil.getFileName(themeCache.srcPath)}`);
        return false;
      }
    }
    return true;
  }

  getCacheThemeList(): NullableType<ThemeCacheInfo[]> {
    return this.userThemeList;
  }

  async updateCacheThemeList(themeCacheInfoArray: ThemeCacheInfo[]): Promise<boolean> {
    if (!themeCacheInfoArray || themeCacheInfoArray.length === 0) {
      return false;
    }
    this.userThemeList = themeCacheInfoArray;
    let result: boolean = await ThemeInfoStoreCache.getInstance().update(this.userThemeList);
    return result;
  }

  async getCurrentCacheTheme(): Promise<NullableType<ThemeCacheInfo>> {
    let currentCacheTheme: NullableType<ThemeCacheInfo> = await ActivatedThemeCache.getInstance().get();
    return currentCacheTheme;
  }

  async updateCurrentCacheTheme(themeCacheInfo: ThemeCacheInfo): Promise<boolean> {
    if (!themeCacheInfo) {
      return false;
    }
    TsLog.info(TAG, `updateCurrentCacheTheme`);
    // 更新当前主题缓存信息
    let resultCurrent: boolean = await ActivatedThemeCache.getInstance().update(themeCacheInfo);
    // 更新全部主题内存态缓存信息
    let resultAll: boolean = await this.updateThemePackCache(themeCacheInfo.id, themeCacheInfo.srcPath);
    // 更新全部主题SP缓存信息
    let resultAllCache: boolean = await this.updateThemeInfoStoreCache(themeCacheInfo.id, themeCacheInfo.srcPath);
    return resultCurrent && resultAll && resultAllCache;
  }

  /**
   * 更新ThemePackCache
   */
  private async updateThemePackCache(themeId: string, path: string): Promise<boolean> {
    const newThemePack: ThemePackInfo = await getThemePackParser().parse(path);
    if (!newThemePack) {
      return false;
    }
    const cacheDataList: NullableType<ThemePackCacheData[]> = await ThemePackCache.getInstance().get();
    if (cacheDataList) {
      let success: boolean = false;
      for (const cache of cacheDataList) {
        if (!StringUtils.equals(cache.id, themeId)) {
          continue;
        }
        cache.themePack = newThemePack;
        success = true;
      }
      if (success) {
        TsLog.info(TAG, `updateThemePackCache`);
        return ThemePackCache.getInstance().update(cacheDataList);
      }
    }
    return false;
  }

  /**
   * 更新ThemeInfoStoreCache
   */
  private async updateThemeInfoStoreCache(themeId: string, path: string): Promise<boolean> {
    if (this.userThemeList === undefined) {
      return false;
    }
    for (const cache of this.userThemeList) {
      if (!StringUtils.equals(cache.id, themeId)) {
        continue;
      }
      cache.srcPath = path;
    }
    TsLog.info(TAG, `updateThemeInfoStoreCache`);
    return ThemeInfoStoreCache.getInstance().update(this.userThemeList);
  }

  async getThemeList(type: TsGetThemeType): Promise<NullableType<ThemeInfo[]>> {
    TsLog.info(TAG, `getThemeList by type... : ${type}`);
    let validThemeCacheList: Nullable<ThemeCacheInfo[]>;
    if (type === GetThemeType.TS_GET_THEME_UNLOCK) {
      validThemeCacheList = this.userThemeList?.sort((themeFirst: ThemeCacheInfo, themeSecond: ThemeCacheInfo) =>
      themeSecond.order - themeFirst.order)?.filter(themeCacheInfo =>!themeCacheInfo.isUsing);
    } else if (type === GetThemeType.TS_GET_THEME_SETTING) {
      validThemeCacheList = this.userThemeList?.sort((themeFirst: ThemeCacheInfo, themeSecond: ThemeCacheInfo) =>
      themeFirst.addOrder - themeSecond.addOrder);
    } else {
      TsLog.warning(TAG, `getThemeList error type: ${type}`);
    }
    TsLog.info(TAG, `getThemeList by type: ${type} , validThemeCacheList size:${validThemeCacheList?.length}`);
    if (!validThemeCacheList) {
      TsLog.info(TAG, `getThemeList by type: ${type} ,no validThemeCacheList.`);
      return;
    }
    let themeInfoList: ThemeInfo[] = [];
    for (const themeCacheInfo of validThemeCacheList) {
      try {
        themeInfoList.push(await this.toThemeInfo(themeCacheInfo));
      } catch (err) {
        TsLog.error(TAG, `getThemeList.toThemeInfo catch exception.`, err);
      }
    }
    TsLog.info(TAG, `getThemeList by type: ${type} , themeInfoList size:${themeInfoList.length}`);
    let currentTheme: ThemeInfo = await this.getCurrentTheme();
    for (let themeInfo of themeInfoList) {
      if (currentTheme.editorId === themeInfo.editorId) {
        themeInfo.isDefault = true;
        themeInfo.isTrial = currentTheme.isTrial;
      }
    }
    // 保存当前画廊数据的缩略图文件
    EventEmitter.emit(EventId.EVENT_GET_THEME_LIST, themeInfoList);
    return themeInfoList;
  }

  private async getOriginThemePackData(themeId: string): Promise<Nullable<ThemePackCacheData>> {
    let themePackList: NullableType<ThemePackCacheData[]> = await HideThemePackCache.getInstance().get();
    let matchThemes: NullableType<ThemePackCacheData[]> =
      themePackList?.filter(themePack => themePack.id.toString() === themeId.toString());
    if (matchThemes && matchThemes.length !== 0) {
      TsLog.info(TAG, `get origin theme pack data from hide theme pack list.`);
      return matchThemes.shift();
    }
    themePackList = await ThemePackCache.getInstance().get();
    matchThemes = themePackList?.filter(themePack => themePack.id.toString() === themeId.toString());
    if (!matchThemes || matchThemes.length === 0) {
      TsLog.warning(TAG, `get origin theme pack data from theme pack list is empty.`);
    }
    return matchThemes?.shift();
  }

  private async toThemeInfo(themeCacheInfo: ThemeCacheInfo): Promise<ThemeInfo> {
    let customThemePack: Nullable<ThemePackInfo> = await getCustomThemePack(themeCacheInfo.editorId);
    // 补充增量包优化后的缩略图文件路径
    if (customThemePack) {
      customThemePack.optPath = TSPathUtils.getThemeCustomPackageOptPath(themeCacheInfo.editorId);
    }
    let originThemePackData: Nullable<ThemePackCacheData> = await this.getOriginThemePackData(themeCacheInfo.id);

    // 补充原始包优化后的缩略图文件路径
    if (originThemePackData?.themePack) {
      originThemePackData.themePack.optPath = TSPathUtils.getThemeOriginPackageOptPath(themeCacheInfo.id);
    }
    let themeInfo: ThemeInfo = new ThemeInfo(themeCacheInfo.id, themeCacheInfo.editorId);
    themeInfo.originThemePack = originThemePackData?.themePack;
    themeInfo.isDownLoaded = this.isOnlineSrc(originThemePackData?.themePack?.srcPath);
    themeInfo.customThemePack = customThemePack;
    themeInfo.themeIndex = themeCacheInfo.themeIndex;
    themeInfo.isPresetFragment = this.isPresetFragment(themeInfo, themeCacheInfo);
    themeInfo.isMixedOnlineResource = this.isMixedOnlineResource(themeCacheInfo);
    themeInfo.mixThemeInfos = this.getThemeMixInfo(themeCacheInfo.themeEditInfo);
    themeInfo.themeOnlineInfo = this.toThemeOnlineInfo(themeCacheInfo.onlineInfo);
    themeInfo.interactive = this.getInteractive(themeInfo);
    themeInfo.isUsable = themeCacheInfo.isUsable ?? true;
    return themeInfo;
  }

  private getInteractive(themeInfo: ThemeInfo): string[] {
    let description: Nullable<string> = JsonUtils.parse(themeInfo.originThemePack?.description ?? '');
    if (description) {
      return description['interactive'];
    }
    return [];
  }

  private isPresetFragment(themeInfo: ThemeInfo, themeCacheInfo: ThemeCacheInfo): boolean {
    if (!themeInfo || !themeCacheInfo) {
      TsLog.error(TAG, `isPresetFragment themeInfo or themeCacheInfo is null`);
      return false;
    }
    let description: Nullable<Description> = JsonUtils.parse<Description>(themeInfo.originThemePack?.description ?? '');
    if (description && description.origin === ORIGIN_PRESET_FRAGMENT) {
      return true;
    }
    return themeCacheInfo.isPresetFragment;
  }

  private isOnlineSrc(srcPath: Nullable<string>): boolean {
    return srcPath ? srcPath.startsWith(TSPathUtils.getTsOnlineThemePath()) : false;
  }

  private toThemeOnlineInfo(onlineInfo?: OnlineInfo): Nullable<ThemeOnlineInfo> {
    if (onlineInfo === undefined) {
      return undefined;
    }
    let themeOnlineInfo: ThemeOnlineInfo = {
      vipExpirationDate: onlineInfo.vipExpirationDate,
      contentPrivStatus: onlineInfo.contentPrivStatus
    }
    return themeOnlineInfo;
  }

  private getThemeMixInfo(themeEditInfo: ThemeEditInfo): Nullable<Map<TargetType, ThemeMixInfo>> {
    if (!themeEditInfo) {
      return undefined;
    }
    let mixInfos: Map<TargetType, ThemeMixInfo> = new Map<TargetType, ThemeMixInfo>();
    themeEditInfo.forEach((extendInfo, target) => {
      if (!excludedThemeList.includes(target)) {
        mixInfos.set(target, {
          id: extendInfo.resourceId,
          originType: extendInfo.type,
          themeOnlineInfo: this.toThemeOnlineInfo(extendInfo.onlineInfo)
        });
      }
    })
    return mixInfos;
  }

  async getCurrentTheme(): Promise<ThemeInfo> {
    TsLog.info(TAG, `getCurrentTheme enter`);
    let applyCache: Nullable<ThemeCacheInfo> = await ActivatedThemeCache.getInstance().get();
    const realActivatedThemeInfo: ThemeInfo = await this.getRealActivatedThemeInfo();
    if (!applyCache) {
      // 不存在当前主题缓存
      TsLog.warning(TAG, `unexpected not fond activatedThemeCache`);
      return realActivatedThemeInfo;
    }
    if (!StringUtils.equals(realActivatedThemeInfo.id, applyCache.id.toString())) {
      // 当前主题缓存与实际主题不匹配
      TsLog.warning(TAG, `current theme not match,activated:${realActivatedThemeInfo.id},applyed:${applyCache.id}`);
      return realActivatedThemeInfo;
    }
    const applyData: Nullable<ThemePackCacheData> = await this.getOriginThemePackData(applyCache.id);
    if (!applyData) {
      // 主题id对应的主题原始包不存在
      TsLog.warning(TAG, `theme id lost:${applyCache.id}`);
      return realActivatedThemeInfo;
    }
    const theme: NullableType<ThemeInfo> = await this.getThemeByEditorId(applyCache.editorId);
    if (theme) {
      theme.isTrial = await themeTrialService().isTrialTheme(theme.editorId);
      TsLog.info(TAG, `current theme from eid`);
      return theme;
    }
    TsLog.info(TAG, `current theme from apply cache`);
    const themeInfo: ThemeInfo = new ThemeInfo(applyCache.id, applyCache.editorId);
    themeInfo.originThemePack = applyData?.themePack;
    themeInfo.customThemePack = await getCustomThemePack(applyCache.editorId);
    themeInfo.isUsable = applyCache.isUsable?? true;
    // 判断当前主题是否试用主题
    themeInfo.isTrial = await themeTrialService().isTrialTheme(themeInfo.editorId);
    return themeInfo;
  }

  async getCurrentFont(): Promise<FontInfo> {
    const presetDefault: NullableType<FontInfo> = await PresetThemeExtCache.getInstance().getDefaultFont();
    const ttfSrc: string | undefined = presetDefault?.src ?? presetDefault?.ttfFileSrc;
    const ttfSrcExt: string[] | undefined = presetDefault?.srcExt ?? presetDefault?.ttfFileSrcExt;
    const defaultFont: FontInfo = {
      id: presetDefault?.id ?? '',
      origin: presetDefault?.origin ?? 'preset',
      src: FileUtil.getFileName(ttfSrc),
      srcExt: TSPathUtils.getFontNameExt(ttfSrc, ttfSrcExt),
      ttfFileSrc: presetDefault?.ttfFileSrc ?? '',
      multiWeight: presetDefault?.multiWeight ?? true,
      ttfFileSrcExt: presetDefault?.ttfFileSrcExt
    }
    const manifestContent: string =
      await FileUtil.readFileContent(`${ActivatedThemeUtil.getActivatedThemePath()}/app/fonts/manifest.json`);
    if (StringUtils.isEmpty(manifestContent)) {
      return defaultFont;
    }
    try {
      const fontManifest: object = JSON.parse(manifestContent);
      let multiWeight: boolean = false;
      if (StringUtils.equals(fontManifest['id'], defaultFont.id) && ObjectUtils.isNull(fontManifest['multiWeight'])) {
        multiWeight = defaultFont.multiWeight;
      } else {
        multiWeight = fontManifest['multiWeight'];
      }
      const ttfSrc: string = fontManifest['src'] ?? fontManifest['ttfFileSrc'];
      const ttfSrcExt: string[] = fontManifest['srcExt'] ?? fontManifest['ttfFileSrcExt'];
      const activatedFont: FontInfo = {
        id: fontManifest['id'],
        origin: fontManifest['origin'],
        src: FileUtil.getFileName(ttfSrc),
        srcExt: TSPathUtils.getFontNameExt(ttfSrc, ttfSrcExt),
        ttfFileSrc: fontManifest['ttfFileSrc'],
        multiWeight: multiWeight,
        ttfFileSrcExt: fontManifest['ttfFileSrcExt']
      }
      return activatedFont;
    } catch (error) {
      TsLog.warning(TAG, `get activated font manifest error`);
    }
    return defaultFont;
  }

  private async getRealActivatedThemeInfo(): Promise<ThemeInfo> {
    let activatedPath: string = ActivatedThemeUtil.getActivatedThemePath();
    let realActivatedThemePackInfo: ThemePackInfo = await getThemePackParser().parse(`${activatedPath}system`);
    let themeId: string = 'default';
    try {
      let id: object = JSON.parse(realActivatedThemePackInfo?.description)['id'];
      themeId = typeof id === 'string' ? id : id?.toString();
    } catch (error) {
      TsLog.warning(TAG, `Parse activated theme id fail:${realActivatedThemePackInfo?.description}`);
    }
    const themeInfo: ThemeInfo = new ThemeInfo(themeId, ActivatedThemeUtil.ACTIVATED_TMP_EID);
    themeInfo.originThemePack = realActivatedThemePackInfo;
    return themeInfo;
  }


  private isMixedOnlineResource(theme: ThemeCacheInfo): boolean {
    if (!theme) {
      TsLog.error(TAG, `get theme : ${theme} not exist`);
      return false;
    }
    // 判断是否是混搭主题，非混搭主题 主题app卸载无影响
    if (!theme.themeEditInfo || theme.themeEditInfo.size === 0) {
      TsLog.info(TAG, `theme: ${theme.editorId} not mixed`);
      return false;
    }
    let status: boolean = false;
    theme?.themeEditInfo?.forEach((info, key) => {
      // 混搭在线资源的主题，主题app卸载后不能继续使用
      if (!excludedThemeList.includes(key)) {
        TsLog.debug(TAG, `info type is: ${info.type}`);
        if (info?.type === ORIGIN_ONLINE || info?.type === ORIGIN_PRESET_FRAGMENT) {
          status = true;
        }
      }
    });
    return status;
  }

  async getThemeByEditorId(editorId: string): Promise<NullableType<ThemeInfo>> {
    let theme: NullableType<ThemeCacheInfo> = this.userThemeList?.find(theme => theme.editorId === editorId);
    if (!theme) {
      TsLog.error(TAG, `activate theme editorId: ${editorId} not exist`);
      return;
    }
    return await this.toThemeInfo(theme);
  }

  async removeTheme(editorIds: string[], notifyChange: boolean = true): Promise<void> {
    TsLog.info(TAG, `removeTheme enter`);
    if (this.userThemeList) {
      const userEditorIdList: ArrayList<string> = new ArrayList();
      for (let themeCache of this.userThemeList) {
        userEditorIdList.add(themeCache.editorId);
      }
      editorIds.forEach(editorId => {
        if (userEditorIdList.has(editorId)) {
          // 外部数据校验，确保eid是内部产生的
          TsLog.info(TAG, `removeTheme, editorId:${editorId}`);
          FileUtil.rmdirAsync(TSPathUtils.getThemeCustomPackagePath(editorId));
        }
        this.userThemeList = this.userThemeList?.filter(themeInfo => themeInfo.editorId !== editorId);
      });
      let ret: boolean = await ThemeInfoStoreCache.getInstance().update(this.userThemeList);
      TsLog.info(TAG, `ret:${ret}, userThemeList length:${this.userThemeList.length}`);
      if (notifyChange) {
        ActivatedThemeUtil.notifyApplyTheme();
      }
    }
  }

  private async isMixedThemeInfo(themeCacheInfo: Nullable<ThemeCacheInfo>): Promise<boolean> {
    if (themeCacheInfo === undefined || themeCacheInfo.themeEditInfo === undefined) {
      return false;
    }
    let mixThemeInfos: Nullable<Map<TargetType, ThemeMixInfo>> = this.getThemeMixInfo(themeCacheInfo.themeEditInfo);
    if (mixThemeInfos === undefined) {
      return false;
    }
    let isThemeHomeMixed: boolean = mixThemeInfos.has('home');
    let isThemeLockMixed: boolean = mixThemeInfos.has('lock');
    let originThemePackData: Nullable<ThemePackCacheData> = await this.getOriginThemePackData(themeCacheInfo.id);
    let originType: OriginType = ORIGIN_PRESET;
    // 获取主题包的originType
    if (originThemePackData?.themePack) {
      originType = originThemePackData.themePack.origin ?? ORIGIN_PRESET;
    }
    if (originType === ORIGIN_PRESET_FRAGMENT) {
      let isDownLoaded: boolean = this.isOnlineSrc(originThemePackData?.themePack?.srcPath);
      return isDownLoaded ? (isThemeHomeMixed || isThemeLockMixed) : (isThemeHomeMixed && isThemeLockMixed);
    }
    return isThemeHomeMixed || isThemeLockMixed;
  }

  async applyTheme(themeInfo: ThemeInfo, themeEditInfo?: ThemeEditInfo, notifyChange: boolean = true,
    isUsing: boolean = true): Promise<void> {
    TsLog.info(TAG, `applyTheme enter`);
    if (!this.userThemeList) {
      TsLog.error(TAG, 'userThemeList is null');
      return;
    }
    this.maxOrder++;
    try {
      let newThemeCacheInfo: Nullable<ThemeCacheInfo> = await this.createNewTheme(themeInfo, themeEditInfo, isUsing);
      if (!newThemeCacheInfo) {
        TsLog.error(TAG, `newThemeCacheInfo is null`);
        return;
      }
      TsLog.info(TAG, `applyTheme newThemeCacheInfo id : ${newThemeCacheInfo.id}, isUsing: ${isUsing}`);
      if (!StringUtils.equals(themeInfo.editorId, ActivatedThemeUtil.ACTIVATED_TMP_EID)) {
        FileUtil.rmdirAsync(TSPathUtils.getThemeCustomPackagePath(ActivatedThemeUtil.ACTIVATED_TMP_EID));
      }
      let index: number = this.userThemeList.findIndex(theme => themeInfo.editorId === theme.editorId);
      if (index !== -1) {
        this.userThemeList.splice(index, 1);
      }

      // isUsing为true时表示应用当前主题，isUsing为false时表示仅保存不应用
      if (isUsing) {
        await ActivatedThemeCache.getInstance().update(newThemeCacheInfo);
        this.userThemeList.forEach(theme => theme.isUsing = false);
      }
      this.userThemeList.push(newThemeCacheInfo);
      // 排序，超过MaxNum后删除最早的主题
      this.userThemeList.sort((themeFirst: ThemeCacheInfo, themeSecond: ThemeCacheInfo) => {
        return themeSecond.order - themeFirst.order;
      });

      if (this.userThemeList.length >= MAX_NUM) {
        let themeCacheInfo = this.userThemeList.pop();
        if (themeCacheInfo) {
          FileUtil.rmdirAsync(TSPathUtils.getThemeCustomPackagePath(themeCacheInfo.editorId));
        }
      }
      await ThemeInfoStoreCache.getInstance().update(this.userThemeList);
      TsLog.info(TAG, `applyTheme, editorId:${themeInfo.editorId}, userThemeList length:${this.userThemeList.length}`);
    } catch (err) {
      TsLog.error(TAG, `applyTheme catch exception.`, err);
    }
    if (notifyChange) {
      ActivatedThemeUtil.notifyApplyTheme();
    }
    let updateRet: number = await tsOnlineRecommend().updateOnlineRecommendWhenApplyTheme(themeInfo.id);
    if (updateRet !== ThemeCode.SUCCESS) {
      TsLog.info(TAG, `update OnlineRecommendation when apply theme faild`);
    }
  }

  private async calculateThemeIndex(themeInfo: ThemeInfo, theme: ThemeCacheInfo,
    isSameCallback: (themeInfo: ThemeInfo, theme: ThemeCacheInfo) => Promise<boolean>): Promise<void> {
    if (!this.userThemeList) {
      TsLog.error(TAG, 'userThemeList is null');
      return;
    }
    if (!themeInfo) {
      TsLog.warning(TAG, 'unexpected not fond themeInfo');
      return;
    }
    let index: number = this.userThemeList.findIndex(async theme => await isSameCallback(themeInfo, theme));
    let newThemeIndex: number = 0;
    // 不同主题themeIndex初始化为0
    if (index === -1) {
      theme.themeIndex = newThemeIndex;
    } else {
      // 新建主题在已用主题List中有相同主题；
      let maxThemeIndex: number = 0;
      let minThemeIndex: number = 0;
      // 获取theme的最大最小order
      for (let index = 0; index < this.userThemeList.length; index++) {
        if (!await isSameCallback(themeInfo, this.userThemeList[index])) {
          continue;
        }
        if (this.userThemeList[index]?.themeIndex > maxThemeIndex) {
          maxThemeIndex = this.userThemeList[index]?.themeIndex ?? 0;
        }
        if (this.userThemeList[index]?.themeIndex < minThemeIndex) {
          minThemeIndex = this.userThemeList[index]?.themeIndex ?? 0;
        }
      }
      TsLog.info(TAG, `maxThemeIndex: ${maxThemeIndex}, minThemeIndex: ${minThemeIndex}`);
      // 是否涉及序号中断，例如list中只存在theme 1、3，新增为2;
      let orderList: number[] = [];
      let sameThemeNum: number = 0;
      for (let index = 0; index < this.userThemeList.length; index++) {
        if (!await isSameCallback(themeInfo, this.userThemeList[index])) {
          continue;
        }
        orderList[sameThemeNum] = this.userThemeList[index]?.themeIndex ?? 0;
        sameThemeNum++;
      }

      // 涉及序号中断时，将已有的主题序号，从小到大排列，取最小的序号插入；
      for (let order = minThemeIndex; order <= maxThemeIndex; order++) {
        // 如原相同主题无themeIndex字段，则匹配为0；
        let index: number = orderList.findIndex(themeIndex => order === themeIndex);
        if (index === -1) {
          newThemeIndex = order;
          theme.themeIndex = newThemeIndex;
          TsLog.info(TAG, 'themeIndex needs insert, newThemeIndex: ' + newThemeIndex);
          return;
        }
      }

      newThemeIndex = maxThemeIndex + 1;
      theme.themeIndex = newThemeIndex;
      TsLog.info(TAG, 'themeIndex no needs insert, newThemeIndex is: ' + newThemeIndex);
    }
  }

  private async updateMixedThemeCacheInfo(newThemeCacheInfo: Nullable<ThemeCacheInfo>,
    oldThemeIndex: number): Promise<void> {
    if (!newThemeCacheInfo || !(await this.isMixedThemeInfo(newThemeCacheInfo))) {
      TsLog.info(TAG, 'newThemeCacheInfo is null or not mixed');
      return;
    }
    if (!this.userThemeList) {
      TsLog.error(TAG, 'userThemeList is null');
      return;
    }
    let index = 0;
    for (index = 0; index < this.userThemeList.length; index++) {
      let curCacheInfo: Nullable<ThemeCacheInfo> = this.userThemeList[index];
      if (!(await this.isMixedThemeInfo(curCacheInfo)) && curCacheInfo.id === newThemeCacheInfo.id &&
        curCacheInfo.themeIndex > oldThemeIndex) {
        this.userThemeList[index].themeIndex--;
      }
    }
  }

  private async updateThemeIndexWhenAddNewTheme(themeInfo: ThemeInfo, theme: ThemeCacheInfo): Promise<void> {
    let callback: (themeInfo: ThemeInfo, newTheme: ThemeCacheInfo) => Promise<boolean>;
    if (await this.isMixedThemeInfo(theme)) {
      callback = async (themeInfo, newTheme) => {
        let ret = await this.isMixedThemeInfo(newTheme);
        return ret;
      };
    } else {
      callback = async (themeInfo, newTheme) => {
        return themeInfo.id === newTheme.id && !(await this.isMixedThemeInfo(newTheme));
      };
    }
    await this.calculateThemeIndex(themeInfo, theme, callback);
    TsLog.info(TAG, 'not found, add new theme, after calculate themeIndex is: ' + theme.themeIndex);
  }

  private async updateThemeIndexWhenReuseTheme(themeInfo: ThemeInfo, theme: ThemeCacheInfo): Promise<void> {
    let oldThemeIndex: number = theme.themeIndex;
    // 更新我的主题，我的主题+1，
    await this.calculateThemeIndex(themeInfo, theme, async (themeInfo, newTheme) => {
      return await this.isMixedThemeInfo(newTheme) && themeInfo.editorId !== newTheme.editorId;
    });

    // 其他主题-1
    this.updateMixedThemeCacheInfo(theme, oldThemeIndex);
    TsLog.info(TAG, 'has found, reuse theme, after calculate my theme themeIndex is: ' + theme.themeIndex);
  }

  async createNewTheme(themeInfo: ThemeInfo, themeEditInfo?: ThemeEditInfo,
    isUsing: boolean = true): Promise<Nullable<ThemeCacheInfo>> {
    if (!this.userThemeList) {
      TsLog.error(TAG, 'userThemeList is null');
      return;
    }
    let index: number = this.userThemeList.findIndex(theme => themeInfo.editorId === theme.editorId);
    let newTheme: ThemeCacheInfo = new ThemeCacheInfo();
    let isPreMixedTheme: boolean = false;
    if (index !== -1) {
      newTheme = this.userThemeList[index];
      isPreMixedTheme = await this.isMixedThemeInfo(newTheme);
    } else {
      this.maxAddOrder++;
      newTheme.addOrder = this.maxAddOrder;
    }
    newTheme.id = themeInfo.id;
    newTheme.editorId = themeInfo.editorId;
    newTheme.order = this.maxOrder;
    newTheme.isUsing = isUsing;
    newTheme.isUsable = themeInfo.isUsable;
    try {
      newTheme.srcPath = themeInfo.originThemePack?.srcPath ?? '';
      let description: Nullable<string> = JsonUtils.parse(themeInfo.originThemePack?.description ?? '');
      if (!description) {
        TsLog.error(TAG, `description is null`);
        return;
      }
      if (description['origin'] === ORIGIN_PRESET_FRAGMENT) {
        newTheme.isPresetFragment = true;
      }
      newTheme.originType = this.isOnlineSrc(newTheme.srcPath) ? ORIGIN_ONLINE : description['origin'];
      TsLog.info(TAG, `applyTheme id:${newTheme.id}, originType:${newTheme.originType}, editorId:${newTheme.editorId}`);
      if (newTheme.originType !== ORIGIN_PRESET) {
        if (themeInfo.originThemePack) {
          await ThemePackCache.getInstance().addIfNot(themeInfo.originThemePack);
        }
      }
      if (!themeEditInfo || themeEditInfo.size === 0) {
        TsLog.info(TAG, `themeEditInfo is null`);
        if (index === -1) {
          // 新增主题
          this.updateThemeIndexWhenAddNewTheme(themeInfo, newTheme);
        }
        return newTheme;
      }
      if (!MapUtils.isMapType(newTheme.themeEditInfo) || !newTheme.themeEditInfo ||
        newTheme.themeEditInfo?.size === 0) {
        newTheme.themeEditInfo = themeEditInfo;
      } else {
        themeEditInfo.forEach((info, key) => newTheme.themeEditInfo.set(key, info));
      }

      if (index !== -1) {
        //复用之前的主题，老的主题是不混搭的，新的主题是混搭
        let isMixedNewTheme = await this.isMixedThemeInfo(newTheme);
        if (isMixedNewTheme && !isPreMixedTheme) {
          this.updateThemeIndexWhenReuseTheme(themeInfo, newTheme);
        }
      } else {
        // 新增主题
        this.updateThemeIndexWhenAddNewTheme(themeInfo, newTheme);
      }
    } catch (err) {
      TsLog.error(TAG, `CreateNewTheme catch exception.`, err);
    }
    return newTheme;
  }

  async updateHostedTheme(themeId: string, path: string): Promise<boolean> {
    const validate: boolean = await PathValidateUtil.validatePath(path);
    if (!validate) {
      TsLog.warning(TAG, `validate updateHostedTheme fail:${path}`);
      return false;
    }
    return UpdateHostTheme.update(this.userThemeList, themeId, path);
  }
}

namespace UpdateHostTheme {
  export async function update(themeList: Nullable<ThemeCacheInfo[]>, themeId: string, path: string): Promise<boolean> {
    if (StringUtils.isEmpty(themeId)) {
      TsLog.error(TAG, `UpdateHostTheme fail, themeId invalid.`);
      return false;
    }
    if (!FileUtil.isFileExists(path)) {
      TsLog.error(TAG, `UpdateHostTheme fail, filename:${FileUtil.getFileName(path)} invalid.`);
      return false;
    }
    await updateThemeInfoService.get().resourceChangeNotification([themeId]);
    if (!themeList) {
      TsLog.warning(TAG, `No gallery data available`);
      return false;
    }
    // 更新主题包缓存
    if (!await updateThemePackToOnline(themeId, path)) {
      TsLog.warning(TAG, `UpdateHostTheme fail,themeId:${themeId}.`);
      return false;
    }
    // 更新画廊缓存
    TsLog.info(TAG, `UpdateHostTheme ,themeId:${themeId}.`);
    return updateGalleryCacheToOnline(themeList, themeId, path);
  }

  async function updateGalleryCacheToOnline(galleryThemeList: ThemeCacheInfo[], themeId: string,
    path: string): Promise<boolean> {
    let origin: string = '';
    try {
      const description: object = JSON.parse(await FileUtil.readFileContent(`${path}/description.json`));
      origin = description?.['origin'];
    } catch (e) {
      TsLog.error(TAG, `themeId:${themeId}, parse description failed:${e}`);
    }
    for (const cache of galleryThemeList) {
      if (!StringUtils.equals(cache.id, themeId)) {
        continue;
      }
      cache.srcPath = path;
      cache.originType = ORIGIN_ONLINE;
      cache.isPresetFragment = origin === ORIGIN_PRESET_FRAGMENT;
      TsLog.info(TAG, `updateGalleryCacheToOnline themeId:${themeId} ,origin:${origin}`);
    }
    return ThemeInfoStoreCache.getInstance().update(galleryThemeList);
  }

  async function updateThemePackToOnline(themeId: string, path: string): Promise<boolean> {
    const downloadThemePack: ThemePackInfo = await getThemePackParser().parse(path);
    const cacheDataList: NullableType<ThemePackCacheData[]> = await ThemePackCache.getInstance().get();
    if (cacheDataList) {
      let success: boolean = false;
      for (const cache of cacheDataList) {
        if (!StringUtils.equals(cache.id, themeId)) {
          continue;
        }
        cache.themePack = downloadThemePack;
        success = true;
      }
      if (success) {
        return ThemePackCache.getInstance().update(cacheDataList);
      }
    }
    return false;
  }
}

export const themeInfoService: Singleton<ThemeInfoService> =
  new Singleton<ThemeInfoService>(() => new ThemeInfoServiceImpl());
