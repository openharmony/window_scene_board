/**
 * Copyright (c) 2025-2025 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { image } from '@kit.ImageKit';
import { AppResourceCacheManager } from '@ohos/frameworkwrapper';
import { fileIo as fs } from '@kit.CoreFileKit';

const TAG = 'SCBSceneResourceManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export enum SceneResourceType {
  label = 'label',
  icon = 'icon',
}

/**
 * scene cache manager for customization parameter from Eco-Apps
 */
export class SCBSceneResourceManager {
  private static instance: SCBSceneResourceManager;
  private memoryCache: AppResourceCacheManager = new AppResourceCacheManager();

  public static getInstance(): SCBSceneResourceManager {
    if (!SCBSceneResourceManager.instance) {
      SCBSceneResourceManager.instance = new SCBSceneResourceManager();
    }
    return SCBSceneResourceManager.instance;
  }

  public setSessionLabelCache(persistentId: number | string, value: string): void {
    log.showInfo(`setAppSessionLabelCache cacheKey:${persistentId}`);
    return this.memoryCache.setCache(String(persistentId), SceneResourceType.label, value);
  }

  public getSessionLabelCache<T>(persistentId: number | string): T {
    log.showInfo(`setAppSessionLabelCache cacheKey:${persistentId}`);
    return this.memoryCache.getCache<T>(String(persistentId), SceneResourceType.label);
  }

  public deleteSessionLabelCache(persistentId: number | string): void {
    log.showInfo(`deleteAppSessionLabelCache cacheKey:${persistentId}`);
    this.memoryCache.deleteCache(String(persistentId), SceneResourceType.label);
  }

  public setSessionIconCache(persistentId: number | string, value: image.PixelMap): void {
    log.showInfo(`setSessionIconCache cacheKey:${persistentId}`);
    return this.memoryCache.setCache(String(persistentId), SceneResourceType.icon, value);
  }

  public getSessionIconCache(persistentId: number | string): image.PixelMap {
    log.showInfo(`getSessionIconCache cacheKey:${persistentId}`);
    return this.memoryCache.getCache<image.PixelMap>(String(persistentId), SceneResourceType.icon);
  }

  public deleteSessionIconCache(persistentId: number | string): void {
    log.showInfo(`deleteSessionIconCache cacheKey:${persistentId}`);
    this.memoryCache.getCache<image.PixelMap>(String(persistentId), SceneResourceType.icon)?.release();
    this.memoryCache.deleteCache(String(persistentId), SceneResourceType.icon);
  }

  public clearSceneCache(persistentId: number | string): void {
    log.showInfo(`clearSceneCache ${persistentId}`);
    this.deleteSessionLabelCache(persistentId);
    this.deleteSessionIconCache(persistentId);
  }

  public async getIconByPath(iconPath: string): Promise<image.PixelMap | undefined> {
    let iconPixelMap: image.PixelMap | undefined = undefined;
    if (!iconPath) {
      log.showInfo('invalid iconPath');
      return iconPixelMap;
    }
    let file: fs.File | undefined = undefined;
    try {
      file = fs.openSync(iconPath, fs.OpenMode.READ_ONLY);
      const imageSource: image.ImageSource = image.createImageSource(file.fd);
      iconPixelMap = await imageSource.createPixelMap();
      imageSource.release();
    } catch (error) {
      log.showError(`getIconByPath error, code: ${error?.code}, message: ${error?.message}`);
    } finally {
      if (file) {
        try {
          fs.closeSync(file);
        } catch (error) {
          log.showError(`file closeSync error, code: ${error?.code}, message: ${error?.message}`);
        }
      }
    }
    return iconPixelMap;
  }

}