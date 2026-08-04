/**
 * Copyright (c) 2021-2025 Huawei Device Co., Ltd.
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

import { CheckEmptyUtils, LogDomain, LogHelper, PixelMapUtil } from '@ohos/basicutils';
import type { DrawableDescriptor } from '@ohos.arkui.drawableDescriptor';
import { LayeredDrawableDescriptor } from '@ohos.arkui.drawableDescriptor';
import image from '@ohos.multimedia.image';
import { GlobalContext } from '../utils/GlobalContext';
import type ctx from '@ohos.app.ability.common';
import bundleResourceManager from '@ohos.bundle.bundleResourceManager';
import type resourceManager from '@ohos.resourceManager';
import { SCBConstants } from '@ohos/commonconstants';
import { BusinessError } from '@ohos.base';
import { AppResourceCacheManager } from './AppResourceCacheManager';
import { bundleManagerFwk } from '../resourcemanager/fwk/BundleManagerFwk';
import { GraphicUtils } from '../resourcemanager/GraphicsUtils';

const KEY_ICON = 'icon';
const KEY_ICON_NO_BG = 'icon_no_bg';
const KEY_CARD_SNAPSHOT = 'cardSnapshot';
const ADAPTIVE_ICON = 'adaptiveicon';
const KEY_NAME = 'name';
const KEY_CAN_NOTICE = 'canNotice';
const DYNAMIC_ICON_RESOURCE_NAMES = [
  'ic_deskclock_background',
  'ic_deskclock_dial',
  'ic_deskclock_hour',
  'ic_deskclock_minute',
  'ic_deskclock_second',
  'ic_calendar_background'
];
const TAG = 'ResourceManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const RETRY_INTERVAL: number = 100;

/**
 * Wrapper class for resourceManager interfaces.
 */
export class ResourceManager {
  private fontWeightRegular: string;
  private fontWeightMedium: string;

  private constructor() {
    this.getStringByIdSync($r('sys.string.ohos_id_text_font_family_regular').id).then(value => {
      this.fontWeightRegular = value;
    });
    this.getStringByIdSync($r('sys.string.ohos_id_text_font_family_medium').id).then(value => {
      this.fontWeightMedium = value;
    });
  }

  static getInstance(): ResourceManager {
    if (globalThis.ResourceManager == null) {
      globalThis.ResourceManager = new ResourceManager();
    }
    return globalThis.ResourceManager;
  }

  private getAppResourceCacheManager(): AppResourceCacheManager {
    if (globalThis.AppResourceCacheManager == null) {
      globalThis.AppResourceCacheManager = new AppResourceCacheManager();
    }
    return globalThis.AppResourceCacheManager;
  }

  /**
   * 获取小文件夹在桌面的图片信息
   * @param smallFolderId 小文件夹的folderId
   * @returns 小文件夹在桌面的图片信息
   */
  public getCachedSmallFolderIcon(smallFolderId: string): image.PixelMap {
    return this.getAppResourceCacheManager().getCache<image.PixelMap>(smallFolderId, KEY_ICON_NO_BG);
  }

  getCachedAppIcon(iconId, bundleName: string, moduleName: string): string {
    const cacheKey = `${iconId}${bundleName}${moduleName}`;
    return this.getAppResourceCacheManager().getCache<string>(cacheKey, KEY_ICON);
  }

  getCachedNormalMediaAppIcon(iconId, bundleName: string, moduleName: string): string {
    const cacheKey = `${iconId}${bundleName}${moduleName}__normal_media`;
    return this.getAppResourceCacheManager().getCache<string>(cacheKey, KEY_ICON);
  }

  getCachedAppName(labelId, bundleName: string, moduleName: string): string {
    const cacheKey = `${labelId}${bundleName}${moduleName}`;
    return this.getAppResourceCacheManager().getCache<string>(cacheKey, KEY_NAME);
  }

  private getCachedBundleAppIcon(bundleName: string): string {
    const cacheKey = bundleName;
    return this.getAppResourceCacheManager().getCache<string>(cacheKey, KEY_ICON);
  }

  private getCachedAbilityAppIcon(bundleName: string, moduleName: string, abilityName: string): string {
    const cacheKey = `${bundleName}${abilityName}${moduleName}`;
    return this.getAppResourceCacheManager().getCache<string>(cacheKey, KEY_ICON);
  }

  private getCachedBundleAppName(bundleName: string): string {
    const cacheKey = bundleName;
    return this.getAppResourceCacheManager().getCache<string>(cacheKey, KEY_NAME);
  }

  private getCachedAbilityAppName(bundleName: string, moduleName: string, abilityName: string): string {
    const cacheKey = `${bundleName}${abilityName}${moduleName}`;
    return this.getAppResourceCacheManager().getCache<string>(cacheKey, KEY_NAME);
  }

  getCachedIconPixelMap(iconId, bundleName: string, moduleName: string): image.PixelMap {
    const cacheKey = `${iconId}${bundleName}${moduleName}`;
    return this.getAppResourceCacheManager().getCache<image.PixelMap>(cacheKey, KEY_ICON);
  }

  getCachedIconPixelMapByKey(cacheKey: string): image.PixelMap {
    return this.getAppResourceCacheManager().getCache<image.PixelMap>(cacheKey, KEY_ICON);
  }

  getCachedCardSnapshot(cacheKey: string): image.PixelMap {
    return this.getAppResourceCacheManager().getCache<image.PixelMap>(cacheKey, KEY_CARD_SNAPSHOT);
  }

  getCachedAppCanNotice(iconId, bundleName: string, moduleName: string): string {
    const cacheKey = `${iconId}${bundleName}${moduleName}`;
    return this.getAppResourceCacheManager().getCache<string>(cacheKey, KEY_CAN_NOTICE);
  }

  getCachedEffectKit(appIconId: number, abilityName: string): image.PixelMap {
    const cacheKey = `${appIconId}${abilityName}`;
    return this.getAppResourceCacheManager().getCache<image.PixelMap>(cacheKey, KEY_ICON);
  }

  setEffectKitCache(appIconId: number, abilityName: string, value: image.PixelMap): void {
    const cacheKey = `${appIconId}${abilityName}`;
    return this.getAppResourceCacheManager().setCache(cacheKey, KEY_ICON, value);
  }

  setBundleAppIconCache(bundleName: string, value: string): void {
    const cacheKey = bundleName;
    return this.getAppResourceCacheManager().setCache(cacheKey, KEY_ICON, value);
  }

  setAbilityAppIconCache(bundleName: string, moduleName: string, abilityName: string, value: string): void {
    const cacheKey = `${bundleName}${abilityName}${moduleName}`;
    return this.getAppResourceCacheManager().setCache(cacheKey, KEY_ICON, value);
  }

  setBundleAppNameCache(bundleName: string, value: string): void {
    const cacheKey = bundleName;
    log.info(`setBundleAppNameCache cacheKey:${cacheKey}, value: ${value}`);
    return this.getAppResourceCacheManager().setCache(cacheKey, KEY_NAME, value);
  }

  setAbilityAppNameCache(bundleName: string, moduleName: string, abilityName: string, value: string): void {
    const cacheKey = `${bundleName}${abilityName}${moduleName}`;
    log.info(`setAbilityAppNameCache cacheKey:${cacheKey}, value: ${value}`);
    return this.getAppResourceCacheManager().setCache(cacheKey, KEY_NAME, value);
  }

  setAppResourceCache(cacheKey: string, cacheType: string, value: object | string): void {
    if (cacheType === KEY_NAME) {
      log.debug(`setAppResourceCache cacheKey:${cacheKey}, value: ${value}`);
    }
    this.getAppResourceCacheManager().setCache(cacheKey, cacheType, value);
  }

  deleteAppResourceCache(cacheKey: string, cacheType: string): void {
    if (cacheType === KEY_NAME) {
      log.showInfo(`deleteAppResourceCache cacheKey:${cacheKey}`);
    }
    this.getAppResourceCacheManager().deleteCache(cacheKey, cacheType);
  }

  /**
   * 通过bundleName删除应用缓存
   *
   * @param bundleName 应用名称
   */
  deleteAppResourceCacheByBundle(bundleName: string): void {
    log.showWarn(`deleteAppResourceCacheByBundle,bundleName is ${bundleName}`);
    this.getAppResourceCacheManager().deleteCacheByBundle(bundleName);
  }

  clearAppResourceCache(): void {
    log.showWarn(`clearAppResourceCache`);
    this.getAppResourceCacheManager().clearCache();
  }

  clearAppAllResourceCache(): void {
    log.showWarn(`clearAppAllResourceCache`);
    this.getAppResourceCacheManager().clearAllCache();
  }

  async updateIconCache(iconId, bundleName: string, moduleName: string): Promise<void> {
    log.showInfo(`updateIconCache bundleName:${bundleName}, moduleName:${moduleName}, iconId:${iconId}`);
    let cacheKey = `${iconId}${bundleName}${moduleName}`;
    const iconBase64 = this.getAppResourceCache(cacheKey, KEY_ICON);
    if (!CheckEmptyUtils.isEmpty(iconBase64)) {
      log.showInfo('updateIconCache appResourceCache is existed');
      return;
    }
    await this.getAccountSAState();
    let resMgr: resourceManager.ResourceManager = null;
    try {
      resMgr = (GlobalContext.getInstance().getObject('desktopContext') as
        ctx.ServiceExtensionContext).createModuleResourceManager(bundleName, moduleName);
      let imageDescriptor: DrawableDescriptor = (resMgr.getDrawableDescriptor(Number(iconId), undefined, 1));
      let value: image.PixelMap = imageDescriptor.getPixelMap();
      log.showInfo(`updateIconCache icon from resourceManager, iconId:${iconId}`);
      this.setAppIconCache(cacheKey, value, imageDescriptor);
      return;
    } catch (error) {
      log.error('updateIconCache error:', error);
    } finally {
      // MemoryUtils.removeNapiWrap(resMgr, false);
    }
  }

  getNormalMediaAppIconWithCache(iconId, bundleName: string, moduleName: string, callback, defaultAppIcon): void {
    log.showDebug(`getNormalMediaAppIconWithCache bundleName:${bundleName},moduleName:${moduleName},iconId:${iconId}`);
    if (CheckEmptyUtils.isEmpty(callback)) {
      log.showError(`getNormalMediaAppIconWithCache callback is empty`);
      return;
    }
    if (CheckEmptyUtils.isEmpty(iconId) || iconId === 0) {
      log.showInfo('getAppIconWithCache defaultAppIcon');
      callback(defaultAppIcon);
      return;
    }

    let cacheKey = `${iconId}${bundleName}${moduleName}_normal_media`;
    const iconBase64 = this.getAppResourceCache(cacheKey, KEY_ICON);
    if (CheckEmptyUtils.isEmpty(iconBase64)) {
      if (this.isResourceManagerEmpty()) {
        log.showError('getNormalMediaAppIconWithCache resourceManager is empty');
        callback(defaultAppIcon);
        return;
      }
      this.getNormalMediaContentBase(iconId, bundleName, moduleName, callback, defaultAppIcon, cacheKey);
    } else {
      callback(iconBase64);
    }
  }

  private getNormalMediaContentBase(iconId, bundleName: string, moduleName: string,
                                    callback, defaultAppIcon, cacheKey): void {
    try {
      log.showInfo(`getNormalMediaContentBase bundleName:${bundleName}, moduleName:${moduleName}, iconId:${iconId}`);
      let resMgr: resourceManager.ResourceManager = (GlobalContext.getInstance().getObject('desktopContext') as
      ctx.ServiceExtensionContext).createModuleResourceManager(bundleName, moduleName);
      this.getAccountSAState().then((res) => {
        let imageDescriptor: DrawableDescriptor = (resMgr.getDrawableDescriptor(Number(iconId)));
        let value: image.PixelMap = imageDescriptor.getPixelMap();
        if (value != null) {
          log.showInfo(`getNormalMediaContentBase normalMediaContent from resourceManager, iconId:${iconId}`);
          this.setAppIconCache(cacheKey, value, imageDescriptor);
          callback(value);
        } else {
          resMgr.getMediaContentBase64(iconId).then((value: string) => {
            if (value != null) {
              log.showInfo(`getNormalMediaContentBase resMgr.getMediaContentBase64, iconId:${iconId}`);
              callback(value);
            } else {
              log.error('getNormalMediaContentBase resourceManager is null');
              callback(defaultAppIcon);
            }
            // MemoryUtils.removeNapiWrap(resMgr, false);
          });
        }
      }).catch((error) => {
        log.error('getNormalMediaContentBase catch error:', error);
      }).finally(() => {
        // MemoryUtils.removeNapiWrap(resMgr, false);
      });
    } catch (error) {
      log.error('getNormalMediaContentBase try error:', error);
      callback(defaultAppIcon);
    }
  }

  private getHdsIcon(image: image.PixelMap, bundleName: string): image.PixelMap {
    let hdsIcon: image.PixelMap = GraphicUtils.getHdsIcon(bundleName, bundleManagerFwk.getIconSizeOfGrid(), image,
      bundleManagerFwk.getMaskImage());
    PixelMapUtil.addName(hdsIcon, 'RM_Hds_' + bundleName);
    return hdsIcon;
  }

  getAppIconWithCache(iconId, bundleName: string, moduleName: string, callback, defaultAppIcon, type: number = 1): void {
    log.showDebug(`getAppIconWithCache get in bundleName:${bundleName}, moduleName:${moduleName}, iconId:${iconId}`);
    if (CheckEmptyUtils.isEmpty(callback)) {
      log.showError(`getAppIconWithCache callback is empty, bundleName : ${bundleName}, moduleName: ${moduleName}`);
      return;
    }
    if (CheckEmptyUtils.isEmpty(iconId) || iconId === 0) {
      log.showInfo('getAppIconWithCache defaultAppIcon');
      callback(defaultAppIcon);
    } else {
      let cacheKey = `${iconId}${bundleName}${moduleName}`;
      const iconBase64 = this.getAppResourceCache(cacheKey, KEY_ICON);
      if (CheckEmptyUtils.isEmpty(iconBase64)) {
        if (this.isResourceManagerEmpty()) {
          log.showError('getAppIconWithCache resourceManager is empty');
          callback(defaultAppIcon);
          return;
        }
        this.getMediaContentBase(iconId, bundleName, moduleName, callback, defaultAppIcon, cacheKey, type);
      } else {
        callback(iconBase64);
      }
    }
  }

  getMediaContentBase(iconId, bundleName: string, moduleName: string, callback, defaultAppIcon, cacheKey,
    type): void {
    try {
      log.showInfo(`getMediaContentBase bundleName:${bundleName}, moduleName:${moduleName}, iconId:${iconId}`);
      let resMgr: resourceManager.ResourceManager = (GlobalContext.getInstance().getObject('desktopContext') as
        ctx.ServiceExtensionContext).createModuleResourceManager(bundleName, moduleName);
      this.getAccountSAState().then((res) => {
        let imageDescriptor: DrawableDescriptor = (resMgr.getDrawableDescriptor(Number(iconId), undefined, type));
        let value: image.PixelMap = imageDescriptor.getPixelMap();
        PixelMapUtil.addName(value, 'ResMgr_origin_' + bundleName);
        if (value != null) {
          if (!type) {
            value = this.getHdsIcon(value, bundleName + '_shortcut');
            // 不能持有imageDescriptor，否则会导致PixelMap无法回收，接入hds场景不缓存imageDescriptor
            imageDescriptor = null;
          }
          log.showInfo(`getMediaContentBase mediaContent from resourceManager, iconId:${iconId}`);
          this.setAppIconCache(cacheKey, value, imageDescriptor);
          callback(value);
        } else {
          resMgr.getMediaContentBase64(iconId).then((value: string) => {
            if (value != null) {
              log.showInfo(`getMediaContentBase resMgr.getMediaContentBase64, iconId:${iconId}`);
              callback(value);
            } else {
              log.error('getMediaContentBase resourceManager is null');
              callback(defaultAppIcon);
            }
            // MemoryUtils.removeNapiWrap(resMgr, false);
          });
        }
      }).catch((error) => {
        log.error('getMediaContentBase catch error:', error);
      }).finally(() => {
        // MemoryUtils.removeNapiWrap(resMgr, false);
      });
    } catch (error) {
      log.error('getMediaContentBase try error:', error);
      callback(defaultAppIcon);
    }
  }

  async getAppIconWithCacheAsync(iconId: number, bundleName: string, moduleName: string, defaultAppIcon,
    type: number = 1): Promise<string | image.PixelMap> {
    log.showInfo(`getAppIconWithCacheAsync bundleName:${bundleName}, moduleName:${moduleName}, iconId:${iconId}`);
    if (CheckEmptyUtils.isEmpty(iconId) || iconId === 0) {
      log.showWarn('getAppIconWithCacheAsync iconId is empty');
      return defaultAppIcon;
    }
    let cacheKey = `${iconId}${bundleName}${moduleName}`;
    const iconBase64: string = <string> this.getAppResourceCache(cacheKey, KEY_ICON);
    if (!CheckEmptyUtils.isEmpty(iconBase64)) {
      log.showInfo('getAppIconWithCacheAsync appResourceCache is existed');
      return iconBase64;
    }
    if (this.isResourceManagerEmpty()) {
      log.showError('getAppIconWithCacheAsync resourceManager is empty');
      return defaultAppIcon;
    }
    let resMgr: resourceManager.ResourceManager = null;
    try {
      await this.getAccountSAState();
      resMgr = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).
        createModuleResourceManager(bundleName, moduleName);

      let imageDescriptor: DrawableDescriptor = (resMgr.getDrawableDescriptor(Number(iconId), undefined, type));
      let value: image.PixelMap = imageDescriptor.getPixelMap();
      if (value != null) {
        if (!type) {
          value = this.getHdsIcon(value, bundleName + '_shortcut');
        }
        log.showInfo(`getAppIconWithCacheAsync appIcon from resourceManager, iconId:${iconId}`);
        this.setAppIconCache(cacheKey, value, imageDescriptor);
        return value;
      }
      let iconBase: string = await resMgr.getMediaContentBase64(iconId);
      log.showInfo(`getAppIconWithCacheAsync pixelMap is null, iconId:${iconId}`);
      return iconBase;
    } catch (error) {
      log.error('getAppIconWithCacheAsync error:', error);
      return defaultAppIcon;
    } finally {
      // MemoryUtils.removeNapiWrap(resMgr, false);
    }
  }

  /**
   * 通过iconId获取图标base64
   *
   * @param iconId 图标资源id
   * @param bundleName 图标bundleName
   * @param moduleName moduleName
   * @returns string 图标资源id对应的base64
   */
  public async getBase64Image(iconId: number, bundleName: string, moduleName: string): Promise<string> {
    let resMgr: resourceManager.ResourceManager = null;
    try {
      log.showWarn(`getBase64Image bundleName:${bundleName}, moduleName:${moduleName}, iconId:${iconId}`);
      resMgr = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).
      createModuleResourceManager(bundleName, moduleName);
      return await resMgr.getMediaContentBase64(iconId);
    } catch (error) {
      log.showError(`getBase64Image error:${error?.message}`);
    } finally {
      // MemoryUtils.removeNapiWrap(resMgr, false);
    }
    return '';
  }

  setAppIconCache(cacheKey: string, value: image.PixelMap, imageDescriptor: DrawableDescriptor): void {
    this.setAppResourceCache(cacheKey, KEY_ICON, value);
    let adaptiveIconValue = new Map();
    if (imageDescriptor instanceof LayeredDrawableDescriptor) {
      let layerImageDescriptor: LayeredDrawableDescriptor = <LayeredDrawableDescriptor> imageDescriptor;
      let backgroundDescriptor: DrawableDescriptor = layerImageDescriptor.getBackground();
      let foregroundDescriptor: DrawableDescriptor = layerImageDescriptor.getForeground();
      if (backgroundDescriptor != null && foregroundDescriptor != null) {
        PixelMapUtil.addName(backgroundDescriptor.getPixelMap(), 'ResMgr_back_' + cacheKey);
        adaptiveIconValue.set('background', backgroundDescriptor);
        PixelMapUtil.addName(foregroundDescriptor.getPixelMap(), 'ResMgr_fore_' + cacheKey);
        adaptiveIconValue.set('foreground', foregroundDescriptor);
      }
    }
    this.setAppResourceCache(cacheKey, ADAPTIVE_ICON, adaptiveIconValue);
  }

  async getAccountSAState(): Promise<boolean> {
    return new Promise((resolve) => {
      if (AppStorage.get('accountSAReady')) {
        resolve(true);
        return;
      }
      let timer = setInterval(() => {
        log.showInfo('getAccountSAState');
        if (AppStorage.get('accountSAReady')) {
          clearInterval(timer);
          resolve(true);
        }
      }, RETRY_INTERVAL);
    });
  }

  /**
   * 更新名称缓存
   * @deprecated 6.0后请使用IconResourceManager的updateAppNameSync
   */
  async updateAppNameSync(labelId, bundleName: string, moduleName: string, defaultAppName: string,
                          appIndex?: number): Promise<string> {
    const cacheKey = `${labelId}${bundleName}${moduleName}`;
    this.setAppResourceCache(cacheKey, KEY_NAME, '');
    let appName = await this.getAppNameSync(labelId, bundleName, moduleName, defaultAppName, appIndex);
    return appName;
  }

  /**
   * 通过labelId获取名称的接口
   * @deprecated 6.0后请使用IconResourceManager的getAppName接口获取名称
   */
  async getAppNameSync(labelId, bundleName: string, moduleName:string, appName: string,
                       appIndex?: number): Promise<string> {
    if (CheckEmptyUtils.isEmpty(labelId) || String(labelId) === '0' || CheckEmptyUtils.checkStrIsEmpty(bundleName) ||
      CheckEmptyUtils.checkStrIsEmpty(moduleName)) {
      log.showInfo(`getAppNameSync param empty! appName: ${appName}`);
      return appName;
    }

    const cacheKey = `${labelId}${bundleName}${moduleName}`;
    log.showDebug(`getAppNameSync getResourceManager cacheKey: ${cacheKey}`);
    let resMgrName: string = this.getAppResourceCache(cacheKey, KEY_NAME) as string;
    if (!CheckEmptyUtils.isEmpty(resMgrName)) {
      return `${resMgrName}${appIndex > 0 ? appIndex : ''}`;
    }
    if (this.isResourceManagerEmpty()) {
      log.showInfo('getAppNameSync resourceManager is empty');
      return appName;
    }
    log.showDebug(`getAppNameSync bundleName:${bundleName}, moduleName:${moduleName}, labelId:${labelId}`);
    await this.getAccountSAState();
    let resMgr: resourceManager.ResourceManager = null;
    try {
        let context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
        if (context !== undefined) {
          resMgr = context.createModuleResourceManager(bundleName, moduleName);
        } else {
          // 新形态小折叠,内屏编辑外屏页面.使用uiExtension加载页面,不走桌面正常加载逻辑. 此处无法取到desktopContext.
          resMgr = (GlobalContext.getContext() as
          ctx.ServiceExtensionContext).createModuleResourceManager(bundleName, moduleName);
        }
      resMgrName = await resMgr.getString(labelId);
    } catch (err) {
      resMgrName = '';
      log.error(`getAppNameSync error:${err} bundleName:${bundleName}, labelId:${labelId}`);
    }
    // MemoryUtils.removeNapiWrap(resMgr, false);
    log.showInfo(`getAppNameSync resMgrName: ${resMgrName} bundleName:${bundleName}, labelId:${labelId}`);
    if (CheckEmptyUtils.isEmpty(resMgrName)) {
      let appNameFromBms: string = this.getBundleAppName(bundleName);
      if (!CheckEmptyUtils.isEmpty(appNameFromBms) && appNameFromBms !== bundleName) {
        resMgrName = appNameFromBms;
      }
    }
    if (resMgrName) {
      this.setAppResourceCache(cacheKey, KEY_NAME, resMgrName);
      return `${resMgrName}${appIndex > 0 ? appIndex : ''}`;
    }
    return appName;
  }

  /**
   * 通过labelId获取名称的接口，并执行回调方法
   * @deprecated 6.0后请使用IconResourceManager的getAppNameWithCallback接口获取名称
   */
  getAppNameWithCache(labelId?: number, bundleName?: string, moduleName?: string, appName?: string, callback?,
                      appIndex?: number): void {
    if (!labelId) {
      log.showInfo(`getAppNameWithCache labelId is invalid appName: ${appName}, bundleName:${bundleName}`);
      callback(appName);
    } else {
      const cacheKey = `${labelId}${bundleName}${moduleName}`;
      const name = this.getAppResourceCache(cacheKey, KEY_NAME);
      if (CheckEmptyUtils.isEmpty(name)) {
        if (this.isResourceManagerEmpty()) {
          log.showInfo('getAppNameWithCache resourceManager is empty');
          callback(appName);
        }
        try {
          log.showInfo(`getAppNameWithCache bundleName:${bundleName}, moduleName:${moduleName}, labelId:${labelId}`);
          this.getAccountSAState().then((res) => {
            let resMgr: resourceManager.ResourceManager = CheckEmptyUtils.isEmpty(moduleName) ? (GlobalContext.getInstance().getObject('desktopContext') as
            ctx.ServiceExtensionContext).createBundleContext(bundleName)?.resourceManager : (GlobalContext.getInstance().getObject('desktopContext') as
            ctx.ServiceExtensionContext).createModuleResourceManager(bundleName, moduleName);
            resMgr.getStringValue(labelId, (error, value) => {
              if (error != null || CheckEmptyUtils.checkStrIsEmpty(value)) {
                log.showInfo(`getAppNameWithCache getAppName getString ERROR! value is empty or error id ${labelId} bundleName:${bundleName}
                  moduleName:${moduleName} value ${value} error: ${error?.message}`);
                callback(appName);
              } else {
                this.setAppResourceCache(cacheKey, KEY_NAME, value);
                callback(`${value}${appIndex > 0 ? appIndex : ''}`);
              }
              // MemoryUtils.removeNapiWrap(resMgr, false);
            });
          }).catch((error) => {
            log.showError(`getAppNameWithCache error:${error} `);
            appName = this.getBundleAppNameByBms(bundleName, cacheKey);
            callback(appName);
          });
        } catch (err) {
          log.error(`getAppNameWithCache error:${err} bundleName:${bundleName}, labelId:${labelId}`);
          callback(appName);
        }
      } else {
        log.debug(`getAppNameWithCache ---> getAppResourceCache success ${name}  bundleName:${bundleName}, moduleName:${moduleName}, labelId:${labelId}`);
        callback(`${name}${appIndex > 0 ? appIndex : ''}`);
      }
    }
  }

  /**
   * 获取应用名称接口
   *
   * @param labelId 应用的labelId
   * @param bundleName 应用包名
   * @param moduleName 应用模块名
   * @returns 应用名称
   */
  async getAppName(labelId: number, bundleName: string, moduleName: string): Promise<string> {
    log.showInfo(`getAppName bundleName:${bundleName}, moduleName:${moduleName}, labelId:${labelId}`);
    await this.getAccountSAState();
    let resMgr: resourceManager.ResourceManager = null;
    let appName = '';
    try {
      let context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
      if (context !== undefined) {
        if (CheckEmptyUtils.isEmpty(moduleName)) {
          resMgr =  (GlobalContext.getInstance().getObject('desktopContext') as
          ctx.ServiceExtensionContext).createBundleContext(bundleName)?.resourceManager;
        } else {
          resMgr = (GlobalContext.getInstance().getObject('desktopContext') as
          ctx.ServiceExtensionContext).createModuleResourceManager(bundleName, moduleName);
        }
      } else {
        // 新形态小折叠,内屏编辑外屏页面.使用uiExtension加载页面,不走桌面正常加载逻辑. 此处无法取到desktopContext.
        resMgr = (GlobalContext.getContext() as
        ctx.ServiceExtensionContext).createModuleResourceManager(bundleName, moduleName);
      }
      appName = await resMgr?.getStringValue(labelId);
      log.showWarn(`getAppName success from resMgr, appName:${appName}, labelId:${labelId}`);
    } catch (err) {
      appName = '';
      log.error('getAppName error:', err);
    } finally {
      // MemoryUtils.removeNapiWrap(resMgr, false);
    }
    if (CheckEmptyUtils.isEmpty(appName)) {
      let appNameFromBms: string = this.getBundleAppName(bundleName);
      if (!CheckEmptyUtils.isEmpty(appNameFromBms) && appNameFromBms !== bundleName) {
        log.showWarn(`get appName by bundle, appname is ${appNameFromBms}`);
        appName = appNameFromBms;
      }
    }
    return appName;
  }

  /**
   * 接口功能不完善，暂勿使用，需等待BMS在5.0上的接口功能补全需求交付
   * 获取应用Bundle级别的图标, 对应app.json5中应用配置的icon
   */
  getBundleAppIcon(bundleName: string): string {
    try {
      return this.cacheableGetBundleAppIcon(bundleName);
    } catch (err) {
      log.error('getBundleAppIcon error:', err);
      return SCBConstants.DEFAULT_ICON;
    }
  }

  private cacheableGetBundleAppIcon(bundleName: string): string {
    let defaultAppIcon: string = SCBConstants.DEFAULT_ICON;

    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showWarn('getBundleAppIcon param empty!');
      return defaultAppIcon;
    }

    const cachedAppIcon: string = this.getCachedBundleAppIcon(bundleName);
    if (!CheckEmptyUtils.isEmpty(cachedAppIcon)) {
      return cachedAppIcon;
    }

    let resMgrIcon: string = this.getBundleAppIconFromBms(bundleName);
    this.setBundleAppIconCache(bundleName, resMgrIcon);
    log.showDebug(`getBundleAppIcon from BMS bundleName: ${bundleName} resMgrIcon length: ${resMgrIcon.length}`);
    return resMgrIcon;
  }

  private getBundleAppIconFromBms(bundleName: string): string {
    let resourceInfo: bundleResourceManager.BundleResourceInfo = bundleResourceManager
      .getBundleResourceInfo(bundleName, bundleResourceManager.ResourceFlag.GET_RESOURCE_INFO_WITH_ICON);
    return resourceInfo.icon;
  }

  public async retryableGetBundleAppIcon(bundle: string, retryWaitTimes: number[], retryableErrorCode: number):
          Promise<string> {
    try {
      return new ErrorRetryableExecutor(`GetBundleAppIcon-${bundle}`,
        () => Promise.resolve(this.cacheableGetBundleAppIcon(bundle)),
        (err: Error) => (err as BusinessError)?.code === retryableErrorCode,
        retryWaitTimes
      ).execute();
    } catch (err) {
      log.showError('RetryableGetBundleAppIcon error %{public}s', (err as Error)?.message);
      return SCBConstants.DEFAULT_ICON;
    }
  }

  /**
   * 接口功能不完善，暂勿使用，需等待BMS在5.0上的接口功能补全需求交付
   * 获取应用Bundle级别的名字, 对应app.json5中应用配置的label
   */
  getBundleAppName(bundleName: string): string {
    try {
      return this.cacheableGetBundleAppName(bundleName);
    } catch (err) {
      log.error('getBundleAppName error:', err);
      return bundleName;
    }
  }

  /**
   * 可缓存方式获取Bundle名，未处理异常
   * @param bundleName
   * @returns
   */
  private cacheableGetBundleAppName(bundleName: string): string {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showWarn(`getBundleAppName param empty! defaultName: ${bundleName}`);
      return bundleName;
    }

    const cachedName: string = this.getCachedBundleAppName(bundleName);
    if (!CheckEmptyUtils.isEmpty(cachedName)) {
      return cachedName;
    }

    const resMgrName: string = this.getBundleAppNameFromBms(bundleName);
    log.showInfo('getBundleAppNameFromBms for %{public}s resMgrName: %{public}s', bundleName, resMgrName);
    this.setBundleAppNameCache(bundleName, resMgrName);
    return resMgrName;
  }

  private getBundleAppNameFromBms(bundleName: string): string {
    let resourceInfo: bundleResourceManager.BundleResourceInfo = bundleResourceManager.
    getBundleResourceInfo(bundleName, bundleResourceManager.ResourceFlag.GET_RESOURCE_INFO_WITH_LABEL);
    return resourceInfo.label;
  }

  /**
   * 接口功能不完善，暂勿使用，需等待BMS在5.0上的接口功能补全需求交付
   * 获取应用ability级别的名字, 对应module.json5中应用配置的ability的label
   */
  getAbilityAppName(bundleName: string, moduleName: string, abilityName: string): string {
    let defaultName: string = bundleName;
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName) || CheckEmptyUtils.checkStrIsEmpty(abilityName) ||
      CheckEmptyUtils.checkStrIsEmpty(moduleName)) {
      log.showWarn(`getAbilityAppName param empty! defaultName:${defaultName}`);
      return defaultName;
    }
    let resMgrName: string = '';
    const cachedName: string = this.getCachedAbilityAppName(bundleName, moduleName, abilityName);
    if (!CheckEmptyUtils.isEmpty(cachedName)) {
      return cachedName;
    }

    try {
      let resourceInfo: bundleResourceManager.LauncherAbilityResourceInfo[] = bundleResourceManager.
        getLauncherAbilityResourceInfo(bundleName, bundleResourceManager.ResourceFlag.GET_RESOURCE_INFO_WITH_LABEL);
      for (let i = 0; i < resourceInfo.length; i++) {
        let curInfo: bundleResourceManager.LauncherAbilityResourceInfo = resourceInfo[i];
        if (curInfo.bundleName === bundleName && curInfo.moduleName === moduleName && curInfo.abilityName === abilityName) {
          resMgrName = curInfo.label;
          log.showDebug('getAbilityAppName resMgrName: %{public}s', resMgrName);
          this.setAbilityAppNameCache(bundleName, moduleName, abilityName, resMgrName);
          return resMgrName;
        }
      }
      return defaultName;
    } catch (err) {
      log.error('getAbilityAppName error:', err);
      return defaultName;
    }
  }

  // 场景下，通过缓存、资源管理取不到应用名字，再通过bms缓存接口取一次名字
  private getBundleAppNameByBms(bundleName: string, cacheKey: string): string {
    let appName: string = this.getBundleAppName(bundleName);
    log.showInfo(`getBundleAppNameByBms appName = ${appName}`);
    if (!CheckEmptyUtils.isEmpty(appName) && appName !== bundleName) {
      this.setAppResourceCache(cacheKey, KEY_NAME, appName);
    }
    return appName;
  }

  getBundleLabelWithCache(labelId: number, bundleName: string, moduleName: string, appName: string, callback): void {
    if (!labelId) {
      log.showInfo(`getBundleLabelWithCache invalid labelId:${labelId}`);
      callback(appName);
    } else {
      const cacheKey = `${labelId}${bundleName}${moduleName}`;
      const name = this.getAppResourceCache(cacheKey, KEY_NAME);
      if (CheckEmptyUtils.isEmpty(name)) {
        if (this.isResourceManagerEmpty()) {
          log.showInfo('getBundleLabelWithCache resourceManager is empty');
          appName = this.getBundleAppNameByBms(bundleName, cacheKey);
          callback(appName);
        }
        try {
          log.showDebug(`getBundleLabelWithCache bundleName:${bundleName}, moduleName:${moduleName} labelId:${labelId}, appName${appName}`);
          let bundleContext = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).createBundleContext(bundleName);
          bundleContext.resourceManager.getStringValue(labelId, (error, value) => {
            if (error != null || CheckEmptyUtils.checkStrIsEmpty(value)) {
              log.error(`getBundleLabelWithCache getStringValue ERROR! labelId:${labelId}`, error);
              appName = this.getBundleAppNameByBms(bundleName, cacheKey);
              callback(appName);
            } else {
              this.setAppResourceCache(cacheKey, KEY_NAME, value);
              callback(value);
            }
          })
            // @ts-ignore
            .finally(() => {
              bundleContext = null;
            });
        } catch (err) {
          log.error('getBundleLabelWithCache error:', err);
          appName = this.getBundleAppNameByBms(bundleName, cacheKey);
          callback(appName);
        }
      } else {
        callback(name);
      }
    }
  }

  /**
     * Get app resource cache.
     *
     * @param {string} cacheKey
     * @param {string} cacheType
     */
  getAppResourceCache(cacheKey, cacheType): string | Map<string, object> {
    return this.getAppResourceCacheManager().getCache(cacheKey, cacheType);
  }

  /**
   * get string by resource.id.
   *
   * @param {number} resource.id
   * @param {function} callback(value)
   */
  getStringById(resId: number, callback: (value: string) => void): void {
    if (this.isResourceManagerEmpty()) {
      log.showInfo('resourceManager is empty');
      callback('');
      return;
    }
    try {
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).resourceManager.getString(resId).then((value: string) => {
        if (CheckEmptyUtils.checkStrIsEmpty(value)) {
          log.showInfo('getStringById ERROR! value is empty:' + resId);
        }
        callback(value);
      });
    } catch (err) {
      log.error('getStringById error:', err);
      callback('');
    }
  }

  /**
   * 通过资源名称获取字符串
   *
   * @param name 资源名称
   * @returns 字符串
   */
  getStringByName(name: string, ...params: (string | number)[]): string {
    let result = '';
    try {
      result = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)
        .resourceManager.getStringByNameSync(name, ...params);
    } catch (err) {
      log.error('getStringByName error:', err);
    }
    return result;
  }

  /**
   * 通过资源名称获取复数字符串
   *
   * @param name 资源名称
   * @returns 字符串
   */
  getPluralStringByName(name: string, num: number): string {
    let result = '';
    try {
      result = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)
        .resourceManager.getPluralStringByNameSync(name, num);
    } catch (err) {
      log.error('getPluralStringByName error:', err);
    }
    return result;
  }

  /**
   * 获取指定应用的字符串
   *
   * @param resId 字串id
   * @param bundleName 应用名
   * @param moduleName 模块名
   * @param appIndex 应用分身标识
   * @returns 字符串
   */
  async getBundleStringByIdSync(resId: number, bundleName: string, moduleName: string, appIndex: number)
    : Promise<string> {
    let resMgrName = '';
    if (!resId) {
      log.showWarn(`getBundleStringByIdSync resId: ${resId}`);
      return resMgrName;
    }
    if (this.isResourceManagerEmpty()) {
      log.showWarn('getBundleStringByIdSync resourceManager is empty');
      return resMgrName;
    }
    try {
      let context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
      let resMgr: resourceManager.ResourceManager = null;
      log.showInfo(`getBundleStringByIdSync desktopContext cacheKey: ${context}`);
      if (context !== undefined) {
        resMgr = context.createModuleResourceManager(bundleName, moduleName);
      } else {
        // 新形态小折叠,内屏编辑外屏页面.使用uiExtension加载页面,不走桌面正常加载逻辑. 此处无法取到desktopContext.
        resMgr = (GlobalContext.getContext() as
        ctx.ServiceExtensionContext).createModuleResourceManager(bundleName, moduleName);
      }
      resMgrName = await resMgr.getString(resId);
    } catch (err) {
      log.error(`getBundleStringByIdSync error:${err?.code}`);
    }
    log.showInfo(`getBundleStringByIdSync resMgrName: ${resMgrName}`);
    if (resMgrName !== '') {
      resMgrName = `${resMgrName}${appIndex === 0 ? '' : appIndex}`;
    }
    return resMgrName;
  }

  private isResourceManagerEmpty(): boolean {
    return CheckEmptyUtils.isEmpty((GlobalContext.getInstance().getObject('desktopContext')) ||
    CheckEmptyUtils.isEmpty((GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)?.resourceManager));
  }

  async getStringByResource(res: Resource): Promise<string> {
    const json = JSON.parse(JSON.stringify(res));
    const id: number = json.id;
    return await this.getStringByIdSync(id);
  }

  /**
   * get string by resource.id.
   *
   * @param {number} resource.id
   * @return {string} resource name
   */
  async getStringByIdSync(resId: number): Promise<string> {
    let resMgrName = '';
    if (!resId) {
      log.showInfo(`getStringByIdSync resId: ${resId}`);
      return resMgrName;
    }
    if (this.isResourceManagerEmpty()) {
      log.showInfo('getStringByIdSync resourceManager is empty');
      return resMgrName;
    }
    try {
      resMgrName = await (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).resourceManager.getString(resId);
    } catch (err) {
      log.error('getStringByIdSync error:', err);
    }
    log.showInfo(`getStringByIdSync resMgrName: ${resMgrName}`);
    return resMgrName;
  }

  /**
   * get number by resource
   *
   * @param {Resource} resource
   * @return {number} resource name
   */
  getNumberByResource(res: Resource): number {
    const json = JSON.parse(JSON.stringify(res));
    const id: number = json.id;
    return this.getNumberById(id);
  }

  /**
   * get number by resource.id.
   *
   * @param {number} resource.id
   * @return {number} resource name
   */
  getNumberById(resId: number): number {
    let resMgrName = 0;
    if (resId <= 0) {
      log.showInfo(`getNumberById resId: ${resId}`);
      return resMgrName;
    } else {
      if (this.isResourceManagerEmpty()) {
        log.showInfo('getNumberById resourceManager is empty');
        return resMgrName;
      }
      try {
        resMgrName = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).resourceManager.getNumber(resId);
      } catch (err) {
        log.error('getNumberById error:', err);
      }
      log.showInfo(`getNumberById resMgrName: ${resMgrName}`);
      return resMgrName;
    }
  }

  getFontWeightRegular(): string {
    return this.fontWeightRegular;
  }

  getFontWeightMedium(): string {
    return this.fontWeightMedium;
  }

  /**
   * Check whether module is from scene board
   *
   * @param {bundleName} bundle name
   * @param {moduleName} module name
   * @return {boolean} result
   */
  isSCBInnerModule(bundleName: string, moduleName: string): boolean {
    return bundleName === SCBConstants.SCENE_BOARD_PKG && moduleName === SCBConstants.NTF_MANAGEMENT_MODULE;
  }

  /**
   * Get scene board inner icon resource
   *
   * @param {moduleName} module name
   * @param {function} callback(value)
   */
  getSCBInnerIcon(moduleName: string, callback: (value) => void, defaultAppIcon): void {
    if (moduleName === SCBConstants.NTF_MANAGEMENT_MODULE) {
      callback(GlobalContext.getContext().resourceManager
        .getDrawableDescriptor($r('app.media.ntf_settings_adaptiveIcon')));
      return;
    }
    callback(defaultAppIcon);
  }

  /**
   * Get scene board inner string resource
   *
   * @param {moduleName} module name
   * @param {function} callback(value)
   */
  getSCBInnerString(moduleName: string, callback: (value) => void): void {
    if (moduleName === SCBConstants.NTF_MANAGEMENT_MODULE) {
      this.getStringByResource($r('app.string.notification_and_status_bar_title')).then((str) => callback(str));
      return;
    }
    callback('');
  }

  /**
   * Read PixelMap to ArrayBuffer
   * @returns buffer
   */
  readPixelMapBuffer(pixelMap: image.PixelMap): ArrayBuffer {
    const buffer = new ArrayBuffer(pixelMap.getPixelBytesNumber());
    pixelMap.readPixelsToBuffer(buffer);
    return buffer;
  }

  getPixelMapByResourceName(resourceName: string, bundleName: string, moduleName: string): image.PixelMap | undefined {
    if (CheckEmptyUtils.isEmpty(resourceName)) {
      return undefined;
    }
    let image = this.getAppResourceCacheManager().getCache<image.PixelMap>(resourceName, KEY_ICON);
    if (CheckEmptyUtils.isEmptyPixelMap(image)) {
      let resMgr: resourceManager.ResourceManager = null;
      try {
        resMgr = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).
          createModuleResourceManager(bundleName, moduleName);
        image = resMgr.getDrawableDescriptorByName(resourceName, 0, 2).getPixelMap();
        // 动态图标(日历和时钟)的背景图接入HDS
        if (DYNAMIC_ICON_RESOURCE_NAMES.includes(resourceName)) {
          image = this.getHdsIcon(image, bundleName);
          PixelMapUtil.addName(image, 'ResMgr_dynamicIcon_' + resourceName);
        }
        this.getAppResourceCacheManager().setCache(resourceName, KEY_ICON, image);
      } catch (err) {
        log.error('getDrawableDescriptorByName error:', err);
      } finally {
        if (resMgr) {
          // MemoryUtils.removeNapiWrap(resMgr, false);
        }
      }
    }
    log.showInfo(`getPixelMapByResourceName: ${resourceName}, check image is null: ${CheckEmptyUtils.isEmptyPixelMap(image)}`);
    return image;
  }

  /**
   * whether resource with a specified resource names exist.
   *
   * @param { string[] } resourceNames - Indicates the resource names.
   * @param { string } bundleName - Indicates the bundle name of the specified application.
   * @param { string } moduleName - Indicates the module name of the specified application.
   * @return { boolean } result - whether resource with a specified resource name exist.
   */
  isExistResByResourceNames(resourceNames: string[], bundleName: string, moduleName: string): boolean {
    if (CheckEmptyUtils.isEmptyArr(resourceNames)) {
      return false;
    }
    let isExist: boolean = true;
    let resMgr: resourceManager.ResourceManager = null;
    try {
      resMgr = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).
        createModuleResourceManager(bundleName, moduleName);
      for (let i = 0; i < resourceNames.length; i++) {
        let res: DrawableDescriptor = resMgr.getDrawableDescriptorByName(resourceNames[i], 0, 2);
        if (!res) {
          isExist = false;
          break;
        }
      }
    } catch (err) {
      log.error('getDrawableDescriptorByName error:', err);
      isExist = false;
    } finally {
      if (resMgr) {
        // MemoryUtils.removeNapiWrap(resMgr, false);
      }
    }
    log.showInfo(`isExistPixelMapByResourceName: ${bundleName}, isExist: ${isExist}`);
    return isExist;
  }
}

class ErrorRetryableExecutor<T> {
  private tag: string;
  private runnable: () => Promise<T>;
  private retryableMatcher: (caughtErr: Error) => boolean;
  private waitTimes: number[] = [0];

  constructor(tag: string, runnable: () => Promise<T>, retryableMatcher: (error: Error) => boolean,
              waitTimeArr?: number[]) {
    this.tag = tag;
    this.runnable = runnable;
    this.retryableMatcher = retryableMatcher;
    if (waitTimeArr) {
      for (let waitTime of waitTimeArr) {
        this.waitTimes.push(waitTime);
      }
    }
  }

  public async execute(): Promise<T> {
    for (let i = 0; i < this.waitTimes.length; i++) {
      const wait = this.waitTimes[i];
      log.showDebug('Retryable execute %{public}d times for %{public}s need wait %{public}d', i, this.tag, wait);

      await this.sleep(wait);
      try {
        return await this.runnable();
      } catch (err) {
        if (this.retryableMatcher(err)) {
          log.showWarn('Catch an retryable error when execute for %{public}s %{public}d times', this.tag, i);
        } else {
          throw err;
        }
      }
    }

    throw new Error(`Retryable execute ${this.waitTimes.length} times. all error`);
  }

  private async sleep(ms: number): Promise<void> {
    await new Promise((resolve) => setTimeout(resolve, ms));
  }
}