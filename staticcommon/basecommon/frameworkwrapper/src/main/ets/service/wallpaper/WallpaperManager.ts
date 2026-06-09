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

import image from '@ohos.multimedia.image';
import WallpaperMar from '@ohos.wallpaper';
import fs from '@ohos.file.fs';
import { DomainName, LogDomain, Logger, PixelMapUtil } from '@ohos/basicutils';
import { DeviceHelper } from '../../base/DeviceHelper';
import { EventManager, EvtBus, EventListener } from '../../eventbus/EventBus';
import { GlobalContext } from '../../utils/GlobalContext';
import { Trace } from '@ohos/basicutils';
import display from '@ohos.display';
import List from '@ohos.util.List';
import { ThemeActivationEvent } from '../../eventbus/events/Events';
import { CheckEmptyUtils, TraceUtil } from '@ohos/basicutils';
import { CommonUtils } from '@ohos/basicutils';
import { TimeOutUtils } from '../../utils/TimeOutUtils';

const TAG = 'WallpaperManager';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

const HALF: number = 2;
const HEX: number = 16;
const SANDBOX_THEME_PATH_FLAG_A: string = '/data/themes/a/app/flag';
const SANDBOX_THEME_PATH_FLAG_B: string = '/data/themes/b/app/flag';

const MANIFEST_PATH: string = 'manifest.json';
const WALLPAPER_CONFIG_PATH: string = 'wallpaper_config.json';
const VERSION_CODE: number = 500100000;

/*
 * 当前设备不存在主题包，如果2v版本或模拟器
 */
const SANDBOX_THEME_PATH_FLAG_NONE: number = 0x0000;

// 主题路径类型
const SANDBOX_THEME_PATH_FLAG_TYPE_A: number = 0x1000;
const SANDBOX_THEME_PATH_FLAG_TYPE_B: number = 0x2000;

// 壁纸场景类型
const SANDBOX_THEME_WALLPAPER_TYPE_DESKTOP: number = 0x0100;
const SANDBOX_THEME_WALLPAPER_TYPE_LOCKSCREEN: number = 0x0200;
const SANDBOX_THEME_WALLPAPER_TYPE_AOD: number = 0x0300;
const SANDBOX_THEME_WALLPAPER_TYPE_SUBSCREEN_DESKTOP: number = 0x0400;
const SANDBOX_THEME_WALLPAPER_TYPE_SUBSCREEN_LOCK: number = 0x0500;

// 系统当前模式
const SANDBOX_THEME_WALLPAPER_MODE_NORMAL: number = 0x0010;

/*
 * 深色模式
 */
const SANDBOX_THEME_WALLPAPER_MODE_DARK: number = 0x0020;

// 壁纸文件格式,当前主题包资源未适配astc格式，待主题适配启用该类型判断
const SANDBOX_THEME_WALLPAPER_FILE_JPG: number = 0x0001;
const SANDBOX_THEME_WALLPAPER_FILE_ASTC: number = 0x0002;

const SANDBOX_THEME_PATH_MAP: Map<number, string | null> = new Map([
  [SANDBOX_THEME_PATH_FLAG_NONE, null],

  [0x1111, '/data/themes/a/system/home/base/resources/'],
  [0x1121, '/data/themes/a/system/home/dark/resources/'],

  [0x1211, '/data/themes/a/system/lock/base/resources/'],
  [0x1221, '/data/themes/a/system/lock/dark/resources/'],

  [0x1311, '/data/themes/a/system/aod/base/resources/'],
  [0x1321, '/data/themes/a/system/aod/dark/resources/'],

  [0x1411, '/data/themes/a/system/sub_screen/home/base/resources/'],
  [0x1421, '/data/themes/a/system/sub_screen/home/dark/resources/'],

  [0x1511, '/data/themes/a/system/sub_screen/lock/base/resources/'],
  [0x1521, '/data/themes/a/system/sub_screen/lock/dark/resources/'],

  [0x2111, '/data/themes/b/system/home/base/resources/'],
  [0x2121, '/data/themes/b/system/home/dark/resources/'],

  [0x2211, '/data/themes/b/system/lock/base/resources/'],
  [0x2221, '/data/themes/b/system/lock/dark/resources/'],

  [0x2311, '/data/themes/b/system/aod/base/resources/'],
  [0x2321, '/data/themes/b/system/aod/dark/resources/'],

  [0x2411, '/data/themes/b/system/sub_screen/home/base/resources/'],
  [0x2421, '/data/themes/b/system/sub_screen/home/dark/resources/'],

  [0x2511, '/data/themes/b/system/sub_screen/lock/base/resources/'],
  [0x2521, '/data/themes/b/system/sub_screen/lock/dark/resources/'],
]);

const MANIFEST_PATH_MAP: Map<number, string | null> = new Map([
  [SANDBOX_THEME_PATH_FLAG_NONE, null],

  [0x1111, '/data/themes/a/system/home/'],
  [0x1121, '/data/themes/a/system/home/'],

  [0x1211, '/data/themes/a/system/lock/'],
  [0x1221, '/data/themes/a/system/lock/'],

  [0x1311, '/data/themes/a/system/aod/'],
  [0x1321, '/data/themes/a/system/aod/'],

  [0x1411, '/data/themes/a/system/sub_screen/home/'],
  [0x1421, '/data/themes/a/system/sub_screen/home/'],

  [0x1511, '/data/themes/a/system/sub_screen/lock/'],
  [0x1521, '/data/themes/a/system/sub_screen/lock/'],

  [0x2111, '/data/themes/b/system/home/'],
  [0x2121, '/data/themes/b/system/home/'],

  [0x2211, '/data/themes/b/system/lock/'],
  [0x2221, '/data/themes/b/system/lock/'],

  [0x2311, '/data/themes/b/system/aod/'],
  [0x2321, '/data/themes/b/system/aod/'],

  [0x2411, '/data/themes/b/system/sub_screen/home/'],
  [0x2421, '/data/themes/b/system/sub_screen/home/'],

  [0x2511, '/data/themes/b/system/sub_screen/lock/'],
  [0x2521, '/data/themes/b/system/sub_screen/lock/'],
]);

/*
 * 壁纸缓存自动释放的时间：3分钟
 */
const DELAY_TIMEOUT = 3 * 60 * 1000;

interface ImageSrc {
  src: string;
}

interface WallpaperImageSrcConfig {
  image: ImageSrc;
}

interface WallpaperTypeConfig {
  type: string;
}

interface WallpaperCache {
  wallpaper: Promise<image.PixelMap>;
  releaseTimeout?: TimeOutUtils;
  tagSet?: Set<string>;
}

/**
 * ScreenLock wallpaper
 *
 * @since 2022-05-06
 */
export class WallpaperManager {
  private wallpaperChangeListeners: List<WallpaperChangeListener> = new List();
  /*
   * 事件管理，便于后续加入新的事件监听统一管理
   */
  private evtMgr: EventManager = EvtBus.createEventManager();
  /**
   * 壁纸数据
   */
  public wallpaperData: WallpaperData = new WallpaperData();
  /**
   * 获取壁纸路径
   */
  public themePath: string = '';
  /**
   * 壁纸缓存
   */
  private wallpaperCacheMap?: Map<WallpaperType, WallpaperCache>;

  private wallpaperChangeCallback: EventListener<ThemeActivationEvent> = (event: ThemeActivationEvent): void => {
    // 壁纸改变时，先释放所有之前的图片资源缓存
    this.releaseWallpaperCacheMap(true);
    this.wallpaperChangeListeners.forEach(listener => {
      // 当前暂时无法区分壁纸切换范围，待切换范围属性加入事件后适配
      let traceTag: string = `${listener.registeredTag}_wallpaperChange`;
      Trace.start(traceTag);
      listener.onWallPaperChange(event);
      log.showInfo(TAG, `wallpaperChange ${listener.registeredTag}`);
      Trace.end(traceTag);
    });
  };

  static getInstance(): WallpaperManager {
    if (globalThis.WallpaperManager == null) {
      log.showInfo(TAG, 'getInstance');
      globalThis.WallpaperManager = new WallpaperManager();
    }
    return globalThis.WallpaperManager;
  }

  /**
   * 注册事件监听
   */
  public registerEventChange(): void {
    TraceUtil.startTrace(DomainName.SCB, 'WallpaperManager.registerEventChange');
    this.evtMgr.on(ThemeActivationEvent, this.wallpaperChangeCallback);
    TraceUtil.endTrace(DomainName.SCB, 'WallpaperManager.registerEventChange');
  }

  /**
   * 注销事件监听
   */
  public unregisterEventChange(): void {
    this.evtMgr.offAll();
  }

  /**
   * 加入壁纸监听回调
   *
   * @param listener 壁纸监听回调
   */
  public addWallpaperChangeListener(listener: WallpaperChangeListener): void {
    if (listener) {
      log.showInfo(TAG, 'addWallpaperChangeListener, listener: %{public}s', listener.registeredTag);
      this.wallpaperChangeListeners.add(listener);
    }
  }

  /**
   * 去除壁纸监听回调
   *
   * @param listener 壁纸监听回调
   */
  public removeWallpaperChangeListener(listener: WallpaperChangeListener): void {
    if (listener) {
      log.showInfo(TAG, 'removeWallpaperChangeListener, listener: %{public}s', listener.registeredTag);
      this.wallpaperChangeListeners.remove(listener);
    }
  }

  /**
   * 根据壁纸类型创建壁纸，当前仅支持获取桌面和锁屏类型的壁纸，更多类型后期适配
   *
   * @param wallpaperType 壁纸类型
   * @param tag 调用方tag
   * @returns 壁纸图片
   */
  private async createWallpaper(wallpaperType: WallpaperType, tag: string): Promise<image.PixelMap> {
    log.showInfo(TAG, `${tag} creat new Wallpaper, wallpaperType: ${wallpaperType}`);
    let wallpaper: image.PixelMap | null = null;
    let themeWallpaperPath: WallpaperPath = new ThemePath(new WallpaperPath());
    let darkPath: WallpaperPath = new WallpaperModePath(themeWallpaperPath);
    let typePath: WallpaperPath = new WallpaperTypePath(darkPath, wallpaperType);
    let filePath: WallpaperPath = new WallpaperFileTypePath(typePath);
    let themePath: string | null = filePath.getWallpaperFilePath();
    let manifestPath: string | null = filePath.getManifestFilePath();
    if (themePath === null) {
      log.showInfo(TAG, 'getWallpaper error, reason: can not resolve unlockThemePath');
      // 对于没有主题路径的场景（2v版本或模拟器）,则读取默认壁纸资源
      return this.getDefaultsWallpaper(wallpaperType);
    }
    themePath = this.getWallpaperName(themePath, manifestPath);
    this.themePath = themePath;
    let wallPaperConfigPath: string | null = filePath.getWallPaperConfigPath();
    let rect: WallpaperConfigRect | undefined = this.getWallpaperConfigRect(wallPaperConfigPath);
    Trace.start('getWallpaper');
    let fd: number | undefined = undefined;
    let imageSource: image.ImageSource | undefined = undefined;
    try {
      fd = (await fs.open(themePath, fs.OpenMode.READ_ONLY)).fd;
      imageSource = image.createImageSource(fd);
      //如果存在对应目录下的wallpaper_config.json文件并且versionCode是5.1的版本，使用新的获取壁纸方式
      if (typeof rect === 'undefined') {
        const imageInfo: image.ImageInfo = await imageSource.getImageInfo();
        // 当前壁纸图片大小为2772*2772，而直板机仅需1344*2772大小即可，对壁纸进行裁切保证内存最小
        const decodingOptions: image.DecodingOptions = this.getDecodingOptions(imageInfo);
        wallpaper = await imageSource.createPixelMap(decodingOptions);
      } else {
        log.showInfo(TAG, `crop by wallpaper config`);
        wallpaper = await imageSource.createPixelMap(this.getFoldExpandOptions());
        await wallpaper.crop({x: rect.x, y: rect.y, size: { height: rect.height, width: rect.width } });
      }
      PixelMapUtil.addName(wallpaper, `WPM_${wallpaperType}_${tag}`);
      log.showInfo(TAG, 'getWallpaper end');
    } catch (error) {
      log.error(TAG, 'getWallpaper error, error :', error);
    } finally {
      if (imageSource) {
        imageSource.release();
      }
      if (!CheckEmptyUtils.isEmpty(fd)) {
        fs.closeSync(fd);
      }
    }
    if (wallpaper === null || !wallpaper) {
      throw new Error(`Failed to createWallpaper, wallpaperType: ${wallpaperType}`);
    }
    Trace.end('getWallpaper');
    return wallpaper;
  }

  private getWallpaperConfigRect(wallPaperConfigPath: string | null): WallpaperConfigRect | undefined {
    let rect: WallpaperConfigRect | undefined = undefined;
    if (!wallPaperConfigPath) {
      return rect;
    }
    try {
      if (fs.accessSync(wallPaperConfigPath)) {
        let text: string = fs.readTextSync(wallPaperConfigPath);
        let wallpaperConfig: WallpaperConfig = JSON.parse(text);
        if (wallpaperConfig && wallpaperConfig.versionCode === VERSION_CODE) {
          rect = wallpaperConfig?.rectData?.rect;
        }
        log.showInfo(TAG, `wallpaper config is exist. rect:${JSON.stringify(rect)}`);
      }
    } catch (e) {
      log.showError(TAG, `Can not resolve wallpaper config rect, ${e?.message}`);
    }
    return rect;
  }

  /**
   * 根据壁纸类型获取壁纸
   *
   * @param wallpaperType 壁纸类型
   * @param tag 调用方tag
   * @returns 壁纸图片
   */
  public async getWallpaper(wallpaperType: WallpaperType, tag: string): Promise<image.PixelMap> {
    log.showInfo(TAG, `getWallpaper wallpaperType: ${wallpaperType} by ${tag}`);
    const wallpaper = await this.createWallpaper(wallpaperType, tag);
    if (wallpaper === null) {
      throw new Error('Failed to create wallpaper');
    }
    return wallpaper;
  }

  /**
   * 根据壁纸类型获取壁纸缓存，此方法获取到的缓存资源禁止手动释放，若autoRelease为true，则WallpaperManager会定时自动释放，
   * 若autoRelease为false，则需使用方调用releaseWallpaperCache接口释放
   *
   * @param wallpaperType 壁纸类型
   * @param tag 调用方TAG
   * @param autoRelease 是否可自动释放
   * @returns 壁纸图片
   */
  public async getWallpaperCache(wallpaperType: WallpaperType, tag: string, autoRelease: boolean = true):
    Promise<image.PixelMap> {
    log.showInfo(TAG, `getWallpaperCache wallpaperType: ${wallpaperType} by ${tag} ` +
      `${autoRelease ? 'allow' : 'not allow'} to auto release`);
    if (this.wallpaperCacheMap == null) {
      this.wallpaperCacheMap = new Map();
    }
    const cache: WallpaperCache = this.wallpaperCacheMap.get(wallpaperType);
    if (cache != null) {
      if (cache.releaseTimeout != null) {
        if (autoRelease) {
          cache.releaseTimeout.setTimeout();
        } else {
          cache.releaseTimeout.clearTimeout();
          cache.releaseTimeout = undefined;
        }
      }
      if (cache.releaseTimeout == null && !autoRelease) {
        if (cache.tagSet == null) {
          cache.tagSet = new Set();
        }
        cache.tagSet.add(tag);
      }
      return cache.wallpaper;
    }
    // 首次使用缓存场景，缓存中无资源，需创建缓存。
    log.showWarn(TAG, `WallpaperType: %{public}d pixmap does not exist in the cache`, wallpaperType);
    let wallpaper: Promise<image.PixelMap> = this.createWallpaper(wallpaperType, tag);
    let releaseTimeout: TimeOutUtils | undefined;
    let tagSet: Set<string> | undefined;
    if (autoRelease) {
      releaseTimeout = new TimeOutUtils(DELAY_TIMEOUT,
        () => this.releaseWallpaperCache(wallpaperType, TAG), TAG);
      releaseTimeout.setTimeout();
    } else {
      tagSet = new Set();
      tagSet.add(tag);
    }
    this.wallpaperCacheMap.set(wallpaperType, { wallpaper, releaseTimeout, tagSet });
    return wallpaper;
  }

  /**
   * 释放缓存中的图片资源，对于可自动释放的缓存直接释放，对于不可自动释放的缓存则只当isForce为true时才释放
   *
   * @param isForce 是否强制释放所有壁纸缓存
   */
  public releaseWallpaperCacheMap(isForce: boolean): void {
    log.showInfo(TAG, `${isForce ? 'force to' : ''} release all pixmap`);
    if (this.wallpaperCacheMap == null) {
      return;
    }
    for (let wallpaperType of this.wallpaperCacheMap.keys()) {
      this.releaseWallpaperCache(wallpaperType, TAG, isForce);
    }
  }

  /**
   * 释放指定类型的壁纸缓存
   *
   * @param wallpaperType 壁纸类型
   * @param tag 调用方TAG
   */
  public async releaseWallpaperCache(wallpaperType: WallpaperType, tag: string, isForce: boolean = false): Promise<void> {
    log.showInfo(TAG, `${isForce ? 'force to' : ''} release cached wallpaper of type ${wallpaperType} by ${tag}`);
    if (this.wallpaperCacheMap == null) {
      return;
    }
    const cache: WallpaperCache = this.wallpaperCacheMap.get(wallpaperType);
    if (cache == null) {
      return;
    }
    if (!isForce) {
      if (cache.tagSet != null) {
        cache.tagSet.delete(tag);
        if (cache.tagSet.size > 0) {
          log.showInfo(TAG, `cannot release wallpaper because it's still used by ${Array.from(cache.tagSet)}`);
          return;
        }
        cache.tagSet = null;
      } else if (tag !== TAG) {
        log.showInfo(TAG, `cannot release wallpaper because it's flaged auto release`);
        return;
      }
    }
    this.wallpaperCacheMap.delete(wallpaperType);
    if (this.wallpaperCacheMap.size === 0) {
      this.wallpaperCacheMap = null;
    }
    cache.releaseTimeout?.clearTimeout();
    cache.tagSet?.clear();
    const wallpaper: image.PixelMap | undefined = await cache.wallpaper;
    await wallpaper?.release();
  }

  /**
   * 根据壁纸类型获取壁纸，当前仅支持获取桌面和锁屏类型的壁纸，更多类型后期适配
   *
   * @param wallpaperType 壁纸类型
   * @returns 壁纸实现类型
   */
  public getType(wallpaperType: WallpaperType): string {
    log.showInfo(TAG, 'getWallpaperType: %{public}d', wallpaperType);

    let themeWallpaperPath: WallpaperPath = new ThemePath(new WallpaperPath());
    let darkPath: WallpaperPath = new WallpaperModePath(themeWallpaperPath);
    let typePath: WallpaperPath = new WallpaperTypePath(darkPath, wallpaperType);
    let filePath: WallpaperPath = new WallpaperFileTypePath(typePath);
    let themePath: string | null = filePath.getWallpaperFilePath();
    let manifestPath: string | null = filePath.getManifestFilePath();

    if (themePath === null) {
      log.showInfo(TAG, 'getWallpaper error, reason: can not resolve unlockThemePath');
      // 对于没有主题路径的场景（2v版本或模拟器）,则读取默认壁纸资源
      return '';
    }
    return this.getWallpaperType(manifestPath);
  }

  private async getDefaultsWallpaper(wallpaperType: WallpaperType): Promise<image.PixelMap> {
    log.showInfo(TAG, 'getDefaultsWallpaper ' + wallpaperType);
    try {
      let paperType: WallpaperMar.WallpaperType = wallpaperType === WallpaperType.DESKTOP ?
        WallpaperMar.WallpaperType.WALLPAPER_SYSTEM : WallpaperMar.WallpaperType.WALLPAPER_LOCKSCREEN;
      let result = await WallpaperMar.getImage(paperType);
      PixelMapUtil.addName(result, 'WPM_Default_Wallpaper');
      return result;
    } catch (error) {
      log.error(TAG, 'getDefaultsWallpaper error', error);
    }
    throw new Error('fail to get default wallpaper');
  }

  private getWallpaperName(themePath: string, manifestPath: string | null): string {
    if (!manifestPath) {
      return '';
    }
    try {
      const text = fs.readTextSync(manifestPath);
      const test: WallpaperImageSrcConfig = JSON.parse(text);
      let wallpaperName: string = test.image.src;
      return themePath + wallpaperName;
    } catch (e) {
      log.showError(TAG, `Can not resolve wallpaper name, ${e?.message}`);
    }
    return '';
  }

  private getWallpaperType(manifestPath: string | null): string {
    if (!manifestPath) {
      return '';
    }
    try {
      const text = fs.readTextSync(manifestPath);
      const manifestJson: WallpaperTypeConfig = JSON.parse(text);
      let wallpaperType: string = manifestJson.type;
      return wallpaperType;
    } catch (e) {
      log.showError(TAG, `Can not resolve wallpaper type, error: ${e}`);
    }
    return '';
  }

  private getDecodingOptions(imageInfo: image.ImageInfo): image.DecodingOptions {
    /*
     * 为避免壁纸在折叠屏展开和关闭场景显示不一致，当设备为折叠屏时则不对壁纸图片做裁剪。
     * 后期壁纸完全由主题引擎显示后此判断还原为仅折叠屏展开态不做裁切
     */
    if (DeviceHelper.isFold() && !DeviceHelper.isSmallFoldProduct()) {
      return this.getFoldExpandOptions();
    }
    return this.getNormalOptions(imageInfo);
  }

  private getFoldExpandOptions(): image.DecodingOptions {
    let decodingOptions: image.DecodingOptions = {
      editable: true,
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888,
    };
    return decodingOptions;
  }

  private getNormalOptions(imageInfo: image.ImageInfo): image.DecodingOptions {
    let decodingOptions: image.DecodingOptions = {
      editable: true,
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888,
    };
    try {
      const displayData: display.Display = display.getDefaultDisplaySync();
      const imageWidth: number = imageInfo.size.width;
      const imageHeight: number = imageInfo.size.height;
      const screenWidth: number = displayData.width;
      const screenHeight: number = displayData.height;
      let x: number = 0;
      let y: number = 0;
      if (imageHeight > screenHeight) {
        y = (imageHeight - screenHeight) / HALF;
      }
      if (imageWidth > screenWidth) {
        x = (imageWidth - screenWidth) / HALF;
      }
      decodingOptions = {
        editable: true,
        desiredPixelFormat: image.PixelMapFormat.RGBA_8888,
        desiredRegion: {
          size: {
            height: screenHeight, width: screenWidth
          }, x: x, y: y
        }
      };
    } catch (e) {
      log.showError(TAG, 'Can not get decodingOptions');
    }
    return decodingOptions;
  }
}

class WallpaperConfig {
  public versionCode?: number;
  public rectData?: WallpaperConfigRectData;
}

export class WallpaperConfigRectData {
  public rect?: WallpaperConfigRect;
  public qualifier?: string;
}

export class WallpaperConfigRect {
  public x: number = 0;
  public y: number = 0;
  public width: number = 0;
  public height: number = 0;
}

/**
 * 壁纸路径获取基类
 */
class WallpaperPath {
  wallpaperPathKey: number = SANDBOX_THEME_PATH_FLAG_NONE;

  /**
   * 获取当前壁纸文件的相对路径
   *
   * @returns 当前壁纸文件的相对路径
   */
  public getWallpaperFilePath(): string | null {
    if (SANDBOX_THEME_PATH_MAP.has(this.wallpaperPathKey)) {
      let path: string | null | undefined = SANDBOX_THEME_PATH_MAP.get(this.wallpaperPathKey);
      return path === undefined ? null : path;
    }
    log.showError(TAG, 'getWallpaperFilePath error, wallpaperPathKey: %{public}s', this.wallpaperPathKey.toString(HEX));
    return null;
  }

  /**
   * 获取当前壁纸配置文件的相对路径
   *
   * @returns 当前壁纸配置文件的相对路径
   */
  public getManifestFilePath(): string | null {
    if (MANIFEST_PATH_MAP.has(this.wallpaperPathKey)) {
      return MANIFEST_PATH_MAP.get(this.wallpaperPathKey) + MANIFEST_PATH;
    }
    log.showError(TAG, 'getManifestFilePath error, wallpaperPathKey: %{public}s', this.wallpaperPathKey.toString(HEX));
    return null;
  }

  /**
   * 获取wallpaper_config.json文件的相对路径
   *
   * @returns wallpaper_config.json文件的相对路径
   */
  public getWallPaperConfigPath(): string | null {
    let prefix: string = 'base/';
    if (DeviceHelper.isFoldExpanded()) {
      prefix = 'unfolded/';
    } else if (DeviceHelper.isLandscape()) {
      prefix = 'unfolded-land/';
    }
    if (MANIFEST_PATH_MAP.has(this.wallpaperPathKey)) {
      return MANIFEST_PATH_MAP.get(this.wallpaperPathKey) + prefix + WALLPAPER_CONFIG_PATH;
    }
    log.showError(TAG, 'getWallPaperConfigPath error, wallpaperPathKey: %{public}s', this.wallpaperPathKey.toString(HEX));
    return null;
  }
}

/**
 * 壁纸主题路径装饰器
 */
class ThemePath extends WallpaperPath {
  constructor(wallpaperPath: WallpaperPath) {
    super();
    this.wallpaperPathKey = wallpaperPath.wallpaperPathKey;
    if (fs.accessSync(SANDBOX_THEME_PATH_FLAG_A)) {
      this.wallpaperPathKey = this.wallpaperPathKey | SANDBOX_THEME_PATH_FLAG_TYPE_A;
    } else if (fs.accessSync(SANDBOX_THEME_PATH_FLAG_B)) {
      this.wallpaperPathKey = this.wallpaperPathKey | SANDBOX_THEME_PATH_FLAG_TYPE_B;
    }
  }
}

/**
 * 系统模式路径装饰器
 */
class WallpaperModePath extends WallpaperPath {
  constructor(wallpaperPath: WallpaperPath) {
    super();
    let isDarkMode: boolean = !GlobalContext.getContext()?.config.colorMode;
    if (isDarkMode) {
      this.wallpaperPathKey = wallpaperPath.wallpaperPathKey | SANDBOX_THEME_WALLPAPER_MODE_DARK;
    } else {
      this.wallpaperPathKey = wallpaperPath.wallpaperPathKey | SANDBOX_THEME_WALLPAPER_MODE_NORMAL;
    }
  }
}

/**
 * 壁纸类型路径装饰器
 */
class WallpaperTypePath extends WallpaperPath {
  private wallpaperTypeMap: Map<WallpaperType, number> = new Map([
    [WallpaperType.DESKTOP, SANDBOX_THEME_WALLPAPER_TYPE_DESKTOP],
    [WallpaperType.SCEENLOCK, SANDBOX_THEME_WALLPAPER_TYPE_LOCKSCREEN],
    [WallpaperType.AOD, SANDBOX_THEME_WALLPAPER_TYPE_AOD],
    [WallpaperType.DESKTOP_SUBSCREEN, SANDBOX_THEME_WALLPAPER_TYPE_SUBSCREEN_DESKTOP],
    [WallpaperType.SCREENLOCK_SUBSCREEN, SANDBOX_THEME_WALLPAPER_TYPE_SUBSCREEN_LOCK],
  ]);

  constructor(wallpaperPath: WallpaperPath, wallpaperType: WallpaperType) {
    super();
    let type: number | undefined = this.wallpaperTypeMap.get(wallpaperType);
    if (!type) {
      type = 0;
    }
    this.wallpaperPathKey = wallpaperPath.wallpaperPathKey | type;
  }
}

/**
 * 壁纸文件类型路径装饰器
 */
class WallpaperFileTypePath extends WallpaperPath {
  constructor(wallpaperPath: WallpaperPath) {
    super();
    this.wallpaperPathKey = wallpaperPath.wallpaperPathKey | SANDBOX_THEME_WALLPAPER_FILE_JPG;
    if ((this.wallpaperPathKey & SANDBOX_THEME_PATH_FLAG_TYPE_A) === SANDBOX_THEME_PATH_FLAG_NONE &&
      (this.wallpaperPathKey & SANDBOX_THEME_PATH_FLAG_TYPE_B) === SANDBOX_THEME_PATH_FLAG_NONE) {
      // 模拟器或2v版本场景下无AB目录，返回空路径依靠壁纸服务获取默认壁纸
      log.showInfo(TAG, 'not find theme path');
      this.wallpaperPathKey = SANDBOX_THEME_PATH_FLAG_NONE;
      return;
    }
    let filePath: string = this.getFilePathInMap(this.wallpaperPathKey);
    if (fs.accessSync(filePath)) {
      return;
    }

    // 如果当前深色路径下没有对应壁纸文件，则在正常路径下获取对应壁纸文件
    if ((wallpaperPath.wallpaperPathKey & SANDBOX_THEME_WALLPAPER_MODE_DARK) !== SANDBOX_THEME_WALLPAPER_MODE_DARK) {
      return;
    }
    log.showInfo(TAG, 'no wallpaper in dark Theme path');
    let normalPathKey: number = wallpaperPath.wallpaperPathKey - SANDBOX_THEME_WALLPAPER_MODE_DARK |
      SANDBOX_THEME_WALLPAPER_MODE_NORMAL;
    this.wallpaperPathKey = normalPathKey | SANDBOX_THEME_WALLPAPER_FILE_JPG;
  }

  private getFilePathInMap(pathKey: number):string {
    if (SANDBOX_THEME_PATH_MAP.has(pathKey)) {
      let path: string | null | undefined = SANDBOX_THEME_PATH_MAP.get(pathKey);
      return (path === undefined || path === null) ? '' : path;
    }
    log.showError(TAG, 'pathMap has not pathKey, pathKey: %{public}s', pathKey.toString(HEX));
    return '';
  }
}

export interface WallpaperChangeListener {
  /*
   * 注册方的tag，建议唯一标识，用于区分注册方
   */
  registeredTag: string;

  /*
   * 指定监听某种类型壁纸的切换,非指定类型壁纸切换时不触发监听回调，功能未实现，待主题使能后适配
   */
  listenerType: WallpaperType;
  onWallPaperChange: (event: ThemeActivationEvent) => void;
}

export const enum WallpaperType {
  DESKTOP,
  SCEENLOCK,
  DESKTOP_SUBSCREEN,
  SCREENLOCK_SUBSCREEN,

  // 暂未适配以下类型场景待主题事件完善后适配
  AOD,
  ALL,
};

export class WallpaperData {
  private _scale: number = 1;
  private _shouldShow: boolean = false;

  public get wallpaperScale(): number {
    return this._scale;
  }

  public get showBackWallpaper(): boolean {
    return this._shouldShow;
  }

  public set wallpaperScale(scale: number) {
    if (CommonUtils.equals(this._scale, scale)) {
      return;
    }
    log.showInfo(TAG, `updateDeskTopWallpaperScale scale = ${scale};`);
    this._scale = scale;
  }

  public set showBackWallpaper(state: boolean) {
    log.showInfo(TAG, `updateShowBackWallpaper = ${this._shouldShow} and ${state}`);
    this._shouldShow = state;
  }

  /**
   * get upper-level caller stack
   */
  public getCallerStack(): string {
    try {
      const err = new Error();
      const source = err.stack?.split('\n').map(item => item.split('/').pop()).filter(x => x)?.slice(3, 6);
      if (!source) {
        return '';
      }
      return source.join(' -> ');
    } catch (error) {
      return `getCallerStack error: ${error?.code}`;
    }
  }
}
