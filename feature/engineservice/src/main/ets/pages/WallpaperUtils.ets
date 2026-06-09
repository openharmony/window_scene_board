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

import lazy fs from '@ohos.file.fs';
import { ResourceQualifierChecker } from '../reloadmanager/ResourceQualifierChecker';
import { Constants, VersionCode } from '../utils/Constants';
import { DeviceUtil } from '../utils/DeviceUtil';
import { FileUtils } from '../utils/FileUtils';
import { GlobalContext } from '../utils/GlobalContext';
import { JsonUtil } from '../utils/JsonUtil';
import { Log } from '../utils/Log';
import { StringUtil } from '../utils/StringUtil';
import { ContentDescription } from './ContentDescription';
import lazy { WallpaperConfig } from './WallpaperConfig';

const TAG: string = 'WallpaperUtils';

/**
 * Utility class to check Theme package's version and parse the correct image path from it
 *
 * @since 2024-04-16
 */
export class WallpaperUtils {
  private static homeResourceChecker: ResourceQualifierChecker;

  private static legacyHomeResourceChecker: ResourceQualifierChecker;

  private static lockResourceChecker: ResourceQualifierChecker;

  private static legacyLockResourceChecker: ResourceQualifierChecker;

  /**
   * Get wallpaper path for desktop.
   * If using NG theme package, such path is parsed from the manifest.json
   * Otherwise, legacy path would be provided
   *
   * @param activeThemePath Current active theme path (a/b)
   * @param qualifierIdx Resource qualifier that indicates current device's state
   * @param wallpaperConfig content of wallpaper_config.json
   * @returns Desktop wallpaper path
   */
  public static getHomeWallpaperPath(activeThemePath: string, qualifierIdx: number,
    wallpaperConfig: Nullable<WallpaperConfig>): string {
    let homeManifest: string = WallpaperUtils.getResourceManifest(activeThemePath, 'home', qualifierIdx);

    // If using NG theme package
    if (fs.accessSync(homeManifest)) {
      Log.info(TAG, 'Attempting to parse desktop wallpaper path as NG theme');
      let manifestContent: object | undefined = JsonUtil.jsonParse(fs.readTextSync(homeManifest));
      if (!manifestContent) {
        return '';
      }
      if (manifestContent['image'] !== undefined && manifestContent['image']['src'] !== undefined) {
        let wallpaperFile: string = manifestContent['image']['src'];
        WallpaperUtils.homeResourceChecker =
          new ResourceQualifierChecker(`${activeThemePath}/home`, `resources/${wallpaperFile}`);
        let resourceQualifierByQualifierIdx: string =
          WallpaperUtils.homeResourceChecker.getQualifierByIndex(qualifierIdx);
        let isNormalizedResource: boolean =
          WallpaperUtils.isNormalizedResource(wallpaperConfig, resourceQualifierByQualifierIdx);

        // 判断归一化资源是从base中获取还是从origin中获取
        let isBaseNormalized: boolean = isNormalizedResource &&
          (wallpaperConfig?.versionCode === VersionCode.VERSION_CODE_FIVE_ONE);
        let resourceQualifier: string = !isNormalizedResource ? resourceQualifierByQualifierIdx :
          (isBaseNormalized ? 'base' : 'origin');
        Log.info(TAG, `home wallpaper path resourceQualifier:${resourceQualifier}, normalized:${isNormalizedResource},`,
          ` originQualifier: ${resourceQualifierByQualifierIdx}, name: ${manifestContent['image']['src']}`);
        let wallpaperPath: string = `${activeThemePath}/home/${resourceQualifier}/resources/${wallpaperFile}`;
        if (((resourceQualifier === 'origin') || isBaseNormalized) && !fs.accessSync(wallpaperPath)) {
          Log.info(TAG, `home wallpaper path normalized do not exist.`);
          resourceQualifier = resourceQualifierByQualifierIdx;
          wallpaperPath = `${activeThemePath}/home/${resourceQualifier}/resources/${wallpaperFile}`;
        }
        GlobalContext.getContext().setObject(Constants.IS_HOME_NEW_RESOURCE_READING, false);
        if (fs.accessSync(wallpaperPath)) {
          // 壁纸归一标识，存在则走壁纸归一化逻辑
          if ((resourceQualifier === 'origin') || isBaseNormalized) {
            GlobalContext.getContext().setObject(Constants.IS_HOME_NEW_RESOURCE_READING, true);
          }
          return wallpaperPath;
        }
      }
    }

    // Fallback to legacy resource path if no resource were found
    WallpaperUtils.legacyHomeResourceChecker =
      new ResourceQualifierChecker(`${activeThemePath}/home`, 'home_wallpaper_0.jpg');
    let resourceQualifier: string = WallpaperUtils.legacyHomeResourceChecker.getQualifierByIndex(qualifierIdx);
    Log.info(TAG, 'Providing legacy desktop wallpaper path');
    GlobalContext.getContext().setObject(Constants.IS_HOME_NEW_RESOURCE_READING, false);
    return `${activeThemePath}/home/${resourceQualifier}/home_wallpaper_0.jpg`;
  }

  /**
   * Get aod manifest path
   *
   * @returns Aod manifest path
   */
  public static getAodWallpaperPath(): string {
    let latestRoot: string = GlobalContext.getContext().getObject(Constants.SANDBOX) as string;
    if (!latestRoot) {
      latestRoot = AppStorage.get<string>('activeThemePath') ?? '';
      Log.info(TAG, 'getAodWallpaperPath latestRoot is ' + latestRoot);
    }
    return `${latestRoot}/aod/manifest.json`;
  }

  /**
   * 获取主题包中Aod的manifest.json文件路径
   *
   * @returns Aod manifest.json文件路径
   */
  public static getAodManifestPath(): string {
    let latestRoot: string = AppStorage.get<string>('activeThemePath') ??
      GlobalContext.getContext().getObject(Constants.SANDBOX) as string;
    if (!latestRoot) { // 当SANDBOX不存在，根据flag获取主题包沙箱根路径
      if (FileUtils.isExists(Constants.FLAG_PATH_A)) {
        Log.info(TAG, 'getAodManifestPath A');
        latestRoot = Constants.SANDBOX_PATH_A;
      } else if (FileUtils.isExists(Constants.FLAG_PATH_B)) {
        Log.info(TAG, 'getAodManifestPath B');
        latestRoot = Constants.SANDBOX_PATH_B;
      } else {
        Log.error(TAG, 'current device has neither directory A nor B , getAodWallpaperPath latestRoot is empty');
        return '';
      }
    }
    return `${latestRoot}/aod/manifest.json`;
  }

  /**
   * Get wallpaper path for lockscreen.
   * If using NG theme package, such path is parsed from the manifest.json
   * Otherwise, legacy path would be provided
   *
   * @param activeThemePath Current active theme path (a/b)
   * @param qualifierIdx Resource qualifier that indicates current device's state
   * @param wallpaperConfig content of wallpaper_config.json
   * @returns Lockscreen wallpaper path
   */
  public static getLockWallpaperPath(activeThemePath: string, qualifierIdx: number,
    wallpaperConfig: Nullable<WallpaperConfig>): string {
    let lockManifest: string = WallpaperUtils.getResourceManifest(activeThemePath, 'lock', qualifierIdx);

    if (fs.accessSync(lockManifest)) {
      Log.info(TAG, 'Attempting to parse lockscreen wallpaper path as NG theme');
      let manifestContent: object | undefined = JsonUtil.jsonParse(fs.readTextSync(lockManifest));
      if (!manifestContent) {
        return '';
      }
      if (manifestContent['image'] !== undefined && manifestContent['image']['src'] !== undefined) {
        let wallpaperFile: string = manifestContent['image']['src'];
        WallpaperUtils.lockResourceChecker =
          new ResourceQualifierChecker(`${activeThemePath}/lock`, `resources/${wallpaperFile}`);
        let resourceQualifierByQualifierIdx: string =
          WallpaperUtils.lockResourceChecker.getQualifierByIndex(qualifierIdx);
        let isNormalizedResource: boolean =
          WallpaperUtils.isNormalizedResource(wallpaperConfig, resourceQualifierByQualifierIdx);
        let isBaseNormalized: boolean = isNormalizedResource &&
          (wallpaperConfig?.versionCode === VersionCode.VERSION_CODE_FIVE_ONE);
        let resourceQualifier: string = !isNormalizedResource ? resourceQualifierByQualifierIdx :
          (isBaseNormalized ? 'base' : 'origin');
        Log.info(TAG, `lock wallpaper path resourceQualifier:${resourceQualifier}, normalized:${isNormalizedResource},`,
          ` originQualifier: ${resourceQualifierByQualifierIdx}, name: ${manifestContent['image']['src']}`);
        let wallpaperPath: string = `${activeThemePath}/lock/${resourceQualifier}/resources/${wallpaperFile}`;
        if (((resourceQualifier === 'origin') || isBaseNormalized) && !fs.accessSync(wallpaperPath)) {
          Log.info(TAG, `lock wallpaper path normalized do not exist.`);
          resourceQualifier = resourceQualifierByQualifierIdx;
          wallpaperPath = `${activeThemePath}/lock/${resourceQualifier}/resources/${wallpaperFile}`;
        }
        GlobalContext.getContext().setObject(Constants.IS_LOCK_NEW_RESOURCE_READING, false);
        if (fs.accessSync(wallpaperPath)) {
          // 壁纸归一标识，存在则走壁纸归一化逻辑
          if ((resourceQualifier === 'origin') || isBaseNormalized) {
            GlobalContext.getContext().setObject(Constants.IS_LOCK_NEW_RESOURCE_READING, true);
          }
          return wallpaperPath;
        }
      }
    }

    // Fallback to legacy resource path if no resource were found
    WallpaperUtils.legacyLockResourceChecker =
      new ResourceQualifierChecker(`${activeThemePath}/unlock`, 'unlock_wallpaper_0.jpg');
    let resourceQualifier: string = WallpaperUtils.legacyLockResourceChecker.getQualifierByIndex(qualifierIdx);
    Log.info(TAG, 'Providing legacy lockscreen wallpaper path');
    GlobalContext.getContext().setObject(Constants.IS_LOCK_NEW_RESOURCE_READING, false);
    return `${activeThemePath}/unlock/${resourceQualifier}/unlock_wallpaper_0.jpg`;
  }


  /**
   * Get get moving photo first frame image path. The resource is currently in the lock path only.
   *
   * @param activeThemePath Current active theme path (a/b)
   * @param lockWallpaperConfig Current lockWallpaperConfig
   * @returns There is a return file path, and there is no return undefined
   */
  public static getMovingPhotoFirstImgPath(activeThemePath: string,
    lockWallpaperConfig: Nullable<WallpaperConfig>): Nullable<string> {
    let isNormalized: boolean =
      (lockWallpaperConfig !== undefined) && (lockWallpaperConfig.versionCode === VersionCode.VERSION_CODE_FIVE_ONE);
    let resourceQualifier: string = isNormalized ? 'base' : 'origin';
    let firstImgPath: string = `${activeThemePath}/lock/${resourceQualifier}/resources/lock_wallpaper_for_aod.jpg`;
    try {
      let accessible = fs.accessSync(firstImgPath);
      if (!accessible) {
        Log.warn(TAG, 'Moving photo first img is not accessible');
      }
      return accessible ? firstImgPath : undefined;
    } catch (err) {
      Log.error(TAG, `Moving photo first img is error. Code: ${err?.code}, message is ${err?.message}`);
      return undefined;
    }
  }

  /**
   * Get ContentDescription from description.json
   *
   * @param activeThemePath Current active theme path (a/b)
   * @param resourceType Resource type，only 'home'、'lock'
   * @returns ContentDescription
   */
  public static getContentDescription(activeThemePath: string, resourceType: string): Nullable<ContentDescription> {
    let path: string = `${activeThemePath}/${resourceType}/description.json`;
    let value: Nullable<string> = FileUtils.readTextSync(path);
    if (!value) {
      Log.warn(TAG, 'GetContentDescription , content is null');
      return undefined;
    }
    let contentDescription: object | undefined = JsonUtil.jsonParse(value);
    if (!contentDescription) {
      Log.warn(TAG, 'GetContentDescription , json is null');
      return undefined;
    }
    return contentDescription as ContentDescription;
  }

  /**
   * Get get WallpaperConfig.
   * The resource is currently in the lock or home only.
   *
   * @param activeThemePath Current active theme path (a/b)
   * @param resourceType Resource type，only 'home'、'lock'
   * @param qualifierIdx Resource qualifier that indicates current device's state
   * @returns WallpaperConfig
   */
  public static getWallpaperConfig(activeThemePath: string, resourceType: 'home' | 'lock',
    qualifierIdx: number): Nullable<WallpaperConfig> {
    let path: string = WallpaperUtils.getWallpaperConfigPath(activeThemePath, resourceType, qualifierIdx);
    Log.info(TAG, `GetWallpaperConfig , resourceType = ${resourceType}}`);
    try {
      if (!fs.accessSync(path)) {
        Log.info('config file not exists');
        return undefined;
      }
      let content: Nullable<string> = fs.readTextSync(path);
      if (!content) {
        Log.error(TAG, 'Failed to read wallpaper config');
        return undefined;
      }
      let config: WallpaperConfig = JsonUtil.jsonParse(content) as WallpaperConfig;
      if (!config) {
        Log.error(TAG, 'Failed to parse wallpaper config');
        return undefined;
      }

      const needBlur: boolean = (resourceType === 'home' && config.isHomeScreenBlur) ||
        (resourceType === 'lock' && config.isLockScreenBlur);

      if (needBlur) {
        // 未指定模糊半径取默认值
        config.blurRadius = config.blurRadius ?? Constants.DEFAULT_STATIC_WALLPAPER_BLUR_RADIUS;

        // 模糊半径超出上下界则按上下界取值
        config.blurRadius = config.blurRadius < Constants.MIN_STATIC_WALLPAPER_BLUR_RADIUS ?
          Constants.MIN_STATIC_WALLPAPER_BLUR_RADIUS :
          config.blurRadius > Constants.MAX_STATIC_WALLPAPER_BLUR_RADIUS ?
          Constants.MAX_STATIC_WALLPAPER_BLUR_RADIUS : config.blurRadius;
      } else {
        config.blurRadius = 0;
      }

      return config;
    } catch (e) {
      Log.error(TAG, `getWallpaperConfig failed. code: ${e?.code}, message: ${e?.message}`);
      return undefined;
    }
  }

  private static getWallpaperNormalizedPath(activeThemePath: string, resourceType: 'home' | 'lock',
    lockWallpaperConfig: Nullable<WallpaperConfig>,
    fileName?: string): string {
    let isNormalized: boolean =
      (lockWallpaperConfig !== undefined) && (lockWallpaperConfig.versionCode === VersionCode.VERSION_CODE_FIVE_ONE);
    return StringUtil.join('/',
      [activeThemePath, resourceType, (isNormalized ? 'base' : 'origin'), 'resources', fileName]);
  }

  private static getWallpaperConfigPath(activeThemePath: string, resourceType: 'home' | 'lock',
    qualifierIdx: number): string {
    let configChecker: ResourceQualifierChecker =
      new ResourceQualifierChecker(`${activeThemePath}/${resourceType}`, `wallpaper_config.json`);
    let configQualifier: string = configChecker.getQualifierByIndex(qualifierIdx);
    Log.info(TAG, `GetWallpaperConfigPath , configQualifier = ${configQualifier}`);
    return StringUtil.join('/', [activeThemePath, resourceType, configQualifier, 'wallpaper_config.json']);
  }

  private static getResourceManifest(activeThemePath: string, resourceType: string, qualifierIdx: number): string {
    let manifestCheck: ResourceQualifierChecker =
      new ResourceQualifierChecker(`${activeThemePath}/${resourceType}`, `manifest.json`);
    let manifestQualifier: string = manifestCheck.getQualifierByIndex(qualifierIdx);
    let resourceManifest: string = `${activeThemePath}/${resourceType}/${manifestQualifier}/manifest.json`;
    return resourceManifest;
  }

  private static isNormalizedResource(wallpaperConfig: Nullable<WallpaperConfig>, resourceQualifier: string): boolean {
    if (wallpaperConfig === undefined) {
      return false;
    }
    if (!DeviceUtil.isTriFoldProduct()) {
      return true;
    }
    return (wallpaperConfig.rectData?.qualifier ?? '') === resourceQualifier ||
      resourceQualifier === Constants.QUALIFIER_BASE;
  }
}