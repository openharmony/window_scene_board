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

import { IconCacheInterface } from '../IconCacheInterface';
import IconInfo, { IconPicType } from '../IconInfo';
import HashMap from '@ohos.util.HashMap';
import { LogDomain, Logger, CheckEmptyUtils } from '@ohos/basicutils';
import { image } from '@kit.ImageKit';
import { IconExtendParam } from '../IconExtendParam';
import { GraphicUtils } from '../GraphicsUtils';
import { default as sSettingsUtil } from '../../setting/SettingsUtil';
import { SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants';
import { settings } from '@kit.BasicServicesKit';

const TAG = 'MemoryCache';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);

export class MemoryCache implements IconCacheInterface {
  private memoryCombIconCacheMap: HashMap<string, image.PixelMap>;
  private memoryNameCacheMap: HashMap<string, string>;
  private memoryIconPicTypeMap: HashMap<string, IconPicType>;
  private memoryLayeredIconMap: HashMap<string, IconInfo>;

  constructor() {
    this.memoryCombIconCacheMap = new HashMap();
    this.memoryNameCacheMap = new HashMap();
    this.memoryIconPicTypeMap = new HashMap();
    this.memoryLayeredIconMap = new HashMap();
  }

  private static sInstance: MemoryCache | null = null;

  public static getInstance(): MemoryCache {
    if (MemoryCache.sInstance == null) {
      MemoryCache.sInstance = new MemoryCache();
    }
    return MemoryCache.sInstance;
  }

  private getCacheKey(bundleName: string, moduleName?: string, abilityName?: string, appIndex?: number): string {
    // 需要获取bundleName删除缓存，所以用#进行分割
    return `${bundleName}#${moduleName ?? ''}${abilityName ?? ''}${appIndex ?? 0}`;
  }

  async setIconResource(bundleName: string, moduleName: string, abilityName: string, iconInfo: IconInfo,
    param: IconExtendParam): Promise<void> {
    // systemUI不缓存图标，即用即销毁
    if (param.hasBorder) {
      return;
    }

    const cacheKey = this.getCacheKey(bundleName, moduleName, abilityName, param.appIndex);
    this.setCacheToMemory(cacheKey, iconInfo.combinePicSrc);
    log.showInfo(TAG, `setIconResource cacheKey ${cacheKey}, iconInfo.iconType ${iconInfo.iconType}, iconInfo.combinePicSrc ${iconInfo.combinePic?.length}`);
    this.setCacheIconPicTypeToMemory(bundleName, moduleName, abilityName, iconInfo);
  }

  /**
   * 批量缓存图标
   *
   * @param iconInfos 需要缓存的图标信息
   * @returns
   */
  public async setIconResourceArray(iconInfos: IconInfo[]): Promise<void> {
    log.showWarn(TAG, 'setIconResourceArray, size: ' + iconInfos.length);
    for (let iconInfo of iconInfos) {
      await this.setIconResource(iconInfo.bundleName, iconInfo.moduleName, iconInfo.abilityName, iconInfo,
        iconInfo.param);
    }
    log.showWarn(TAG, `setIconResourceArray finish, size: ${this.memoryCombIconCacheMap.length}`);
  }

  getCombIconSync(bundleName: string, moduleName: string, abilityName: string, appIndex?: number): image.PixelMap {
    const cacheKey = this.getCacheKey(bundleName, moduleName, abilityName, appIndex);
    log.showInfo(TAG, `getCombIconSync cacheKey ${cacheKey}`);
    return this.getCacheFromMemory(cacheKey);
  }

  /**
   * 获取图标base64字符串
   *
   * @param bundleName 包名
   * @param moduleName 模块名
   * @param abilityName 应用的ability
   * @returns 图标转base64的字符串
   */
  public async getIconresourceBase64(bundleName: string, moduleName: string, abilityName: string): Promise<string> {
    const cacheKey = this.getCacheKey(bundleName, moduleName, abilityName);
    return await GraphicUtils.changePixelToBase64(this.getCacheFromMemory(cacheKey));
  }

  async getCombIcon(bundleName: string, moduleName: string, abilityName: string, param: IconExtendParam):
    Promise<IconInfo> {
    const cacheKey = this.getCacheKey(bundleName, moduleName, abilityName, param.appIndex);
    log.showInfo(TAG, `getCombIcon cacheKey ${cacheKey}`);
    let iconInfo = new IconInfo();
    iconInfo.combinePicSrc = this.getCacheFromMemory(cacheKey);
    return iconInfo;
  }

  getIconResource(bundleName: string, moduleName: string, abilityName: string, appIndex?: number, combIconFlag?: boolean): Promise<IconInfo> {
    throw new Error('Method not implemented.');
  }

  getIconResourceBySize(bundleName: string, moduleName: string, abilityName: string, size: number): IconInfo {
    if (size > 0) {
      const key = this.getIconResourceCacheKey(bundleName, moduleName, abilityName, size);
      return this.memoryLayeredIconMap.get(key);
    }
    log.showWarn(TAG, `getIconResourceBySize, bundleName: ${bundleName}, size = ${size} is invalid`);
    return new IconInfo();
  }

  setIconResourceBySize(bundleName: string, moduleName: string, abilityName: string, size: number,
    iconInfo: IconInfo): void {
    if (size > 0) {
      const key = this.getIconResourceCacheKey(bundleName, moduleName, abilityName, size);
      this.memoryLayeredIconMap.set(key, iconInfo);
      return;
    }
    log.showWarn(TAG, `setIconResourceBySize, bundleName: ${bundleName}, size = ${size} is invalid`);
  }

  getIconResourceCacheKey(bundleName: string, moduleName: string, abilityName: string, size: number): string {
    return `${bundleName}#${moduleName ?? ''}${abilityName ?? ''}${size}`;
  }

  async deleteAllCache(): Promise<void> {
    log.showWarn(TAG, 'deleteAllMemoryCache start');
    for (let cacheKey of this.memoryCombIconCacheMap.keys()) {
      this.memoryCombIconCacheMap.get(cacheKey)?.release();
    }
    this.memoryCombIconCacheMap.clear();
    this.memoryIconPicTypeMap.clear();
    this.memoryLayeredIconMap.clear();
    log.showWarn(TAG, 'deleteAllMemoryCache end');
  }

  deleteAllNameCache(): void {
    log.showWarn(TAG, 'deleteAllNameCache');
    this.memoryNameCacheMap.clear();
  }

  async deleteCache(bundleName: string): Promise<void> {
    log.showWarn(TAG, `delete all memory cache ${bundleName}`);
    this.deleteCacheByBundle(bundleName, this.memoryCombIconCacheMap);
    this.deleteCacheByBundle(bundleName, this.memoryNameCacheMap);
    this.deleteCacheByBundle(bundleName, this.memoryIconPicTypeMap);
    this.deleteCacheByBundle(bundleName, this.memoryLayeredIconMap);
  }

  private deleteCacheByBundle(bundleName: string,
    memoryCache: HashMap<string, string | IconInfo | image.PixelMap>): void {
    let delKeys: string[] = [];
    for (let key of memoryCache.keys()) {
      let bundleNameInKey: string = key.substring(0, key.indexOf('#'));
      if (!CheckEmptyUtils.checkStrIsEmpty(bundleNameInKey) && bundleNameInKey === bundleName) {
        log.showWarn(TAG, `delete memory cache key: ${key}`);
        delKeys.push(key);
      }
    }
    for (let delKey of delKeys) {
      memoryCache.remove(delKey);
    }
  }

  private getCacheFromMemory(cacheKey: string): image.PixelMap {
    return this.memoryCombIconCacheMap.get(cacheKey);
  }

  private setCacheToMemory(cacheKey: string, value: image.PixelMap): void {
    this.memoryCombIconCacheMap.set(cacheKey, value);
  }

  /**
   * 同步获取图标类型
   *
   * @param bundleName 应用包名
   * @param moduleName 模块名
   * @param abilityName Ability名称
   * @param appIndex appIndex
   * @returns 图标类型
   */
  getCacheIconPicTypeSync(bundleName: string, moduleName: string, abilityName: string): IconPicType {
    log.showInfo(TAG, `getCacheIconPicTypeSync ${bundleName}`);
    const cacheKey = this.getCacheKey(bundleName, moduleName, abilityName);
    return this.getCacheIconPicTypeFromMemory(cacheKey);
  }

  /**
   * 从缓存获取图标类型
   *
   * @param cacheKey key
   * @returns 图标类型
   */
  getCacheIconPicTypeFromMemory(cacheKey: string): IconPicType {
    return this.memoryIconPicTypeMap.get(cacheKey);
  }

  /**
   * 设置图标类型到缓存
   *
   * @param bundleName 应用包名
   * @param moduleName 模块名
   * @param abilityName ability名称
   * @param iconInfo 图标信息
   * @param appIndex appIndex
   */
  setCacheIconPicTypeToMemory(bundleName: string, moduleName: string, abilityName: string, iconInfo: IconInfo): void {
    if (CheckEmptyUtils.isEmpty(bundleName) || CheckEmptyUtils.isEmpty(iconInfo) ||
      (iconInfo.iconType === IconPicType.NONE && CheckEmptyUtils.isEmpty(iconInfo.combinePic))) {
      log.showWarn(TAG, `setCacheIconPicTypeToMemory fail, bundleName ${bundleName}, iconType ${iconInfo?.iconType}, combinePic ${iconInfo?.combinePic}`);
      return;
    }
    const cacheKey = this.getCacheKey(bundleName, moduleName, abilityName);
    const iconType = iconInfo.iconType;
    const foregroundLength = iconInfo.adaptivePic[1]?.length;
    const backgroundLength = iconInfo.adaptivePic[0]?.length;
    const combinePicLength = iconInfo.combinePic?.length;
    log.showWarn(TAG, `setCacheIconPicTypeToMemory: cacheKey ${cacheKey} iconType ${iconType}, foregroundLength:${foregroundLength}, backgroundLength:${backgroundLength}, combinePicLength:${combinePicLength}`);
    if (iconType === IconPicType.ADAPTIVE || (foregroundLength && backgroundLength && foregroundLength > 0 && backgroundLength > 0)) {
      this.memoryIconPicTypeMap.set(cacheKey, IconPicType.ADAPTIVE);
      return;
    }
    this.memoryIconPicTypeMap.set(cacheKey, IconPicType.NORMAL);
  }

  async setIconNameResource(bundleName: string, moduleName: string, abilityName: string,
    appName: string, appIndex?: number): Promise<void> {
    const cacheKey = this.getCacheKey(bundleName, moduleName, abilityName, appIndex);
    this.memoryNameCacheMap.set(cacheKey, appName);
  }

  /**
   * @deprecated 6.0后不再使用此接口
   */
  getIconNameSync(bundleName: string, moduleName: string, abilityName: string, appIndex?: number): string {
    const cacheKey = this.getCacheKey(bundleName, moduleName, abilityName, appIndex);
    let iconName: string | undefined = this.memoryNameCacheMap.get(cacheKey);
    return iconName ? iconName : '';
  }

  getAppNameCacheKey(labelId: number, bundleName: string, moduleName: string): string {
    // 需要获取bundleName删除缓存，所以用#进行分割
    return `${bundleName}#${moduleName}${labelId}`;
  }

  getAppName(labelId: number, bundleName: string, moduleName: string): string {
    const cacheKey = this.getAppNameCacheKey(labelId, bundleName, moduleName);
    return this.memoryNameCacheMap.get(cacheKey) ?? '';
  }

  setAppName(labelId: number, bundleName: string, moduleName: string, appName: string): void {
    const cacheKey = this.getAppNameCacheKey(labelId, bundleName, moduleName);
    this.memoryNameCacheMap.set(cacheKey, appName);
  }

  setAppNameCacheByCacheKey(cacheKey: string, appName: string): void {
    this.memoryNameCacheMap.set(cacheKey, appName);
  }

  getIconNameByBundleNameSync(bundleName: string): string {
    let keys: string[] = Object.keys(this.memoryNameCacheMap);
    for (let idx = 0; idx < keys.length; idx++) {
      const key: string = keys[idx];
      if (key.includes(bundleName)) {
        return this.memoryNameCacheMap.get(key);
      }
    }
    return '';
  }

  isNameCacheEmpty(): boolean {
    return this.memoryNameCacheMap.isEmpty();
  }
}
export const memoryCache = MemoryCache.getInstance();