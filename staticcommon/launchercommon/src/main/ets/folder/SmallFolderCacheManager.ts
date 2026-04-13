/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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
import { SmallFolderIconFileUtil } from '../utils/SmallFolderIconFileUtil';

const TAG = 'SmallFolderCacheManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * A Manager class that provides get/set/clear cache methods for small folder showList
 */
export class SmallFolderCacheManager {
  private static mInstance: SmallFolderCacheManager;
  private readonly cache: Map<string, string> = new Map();

  private readonly capacity: number = 100;

  static getInstance(): SmallFolderCacheManager {
    if (!SmallFolderCacheManager.mInstance) {
      SmallFolderCacheManager.mInstance = new SmallFolderCacheManager();
    }
    return SmallFolderCacheManager.mInstance;
  }

  /**
   * Get cache from memory.
   *
   * @param {string} key - key of the cache map
   * @return {object} - cache get from the memory
   */
  getFolderIconCache(key: string): string | undefined {
    log.showDebug(`getCache key: ${key}`);
    const cache: string | undefined = this.getCache(key);
    if (cache === undefined || cache === null) {
      return undefined;
    } else {
      return cache;
    }
  }

  getCache(key: string): string | undefined {
    if (this.cache.has(key)) {
      return this.cache.get(key);
    }
    return undefined;
  }

  /**
   * Set cache to memory.
   *
   * @param {string} key - key of the cache map
   * @param {object} value - value of the cache map
   */
  setCache(key: string, value: string): void {
    log.showDebug(`setCache key:${key}, value: ${value}`);
    if (this.cache.has(key)) {
      this.cache.delete(key);
    } else if (this.cache.size >= this.capacity) {
      // if size > capacity ,remove the old
      this.cache.delete(this.cache.keys().next().value);
    }
    this.cache.set(key, value);
  }

  /**
   * delete cache cache of memory.
   */
  deleteCache(cacheKey: string): void {
    log.showDebug('deleteCache');
    this.cache.delete(cacheKey);
  }

  private deleteCacheByFolderId(folderId: string): void {
    this.deleteCache(folderId);
    this.deleteCache(folderId + SmallFolderIconFileUtil.END_PAGE_IMAGE);
    this.deleteCache(folderId + SmallFolderIconFileUtil.RTL_PAGE_IMAGE);
    this.deleteCache(folderId + SmallFolderIconFileUtil.END_PAGE_IMAGE + SmallFolderIconFileUtil.RTL_PAGE_IMAGE);
    this.deleteCache(folderId + SmallFolderIconFileUtil.END_PAGE_IMAGE + SmallFolderIconFileUtil.Expand_PAGE_IMAGE);
    this.deleteCache(folderId + SmallFolderIconFileUtil.END_PAGE_IMAGE + SmallFolderIconFileUtil.Expand_PAGE_IMAGE +
      SmallFolderIconFileUtil.RTL_PAGE_IMAGE);
  }

  /**
   * 删除小文件夹截图缓存及截图文件
   * @param folderId 文件夹ID
   */
  deleteCacheAndFile(folderId: string): void {
    this.deleteCacheByFolderId(folderId);
    SmallFolderIconFileUtil.deleteFolderIcon(folderId);
  }

  /**
   * Clear cache of memory.
   */
  clearCache(): void {
    log.showDebug('clearCache');
    this.cache.clear();
  }
}
