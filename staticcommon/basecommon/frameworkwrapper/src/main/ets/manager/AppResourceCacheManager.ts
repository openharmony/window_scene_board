/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import HashMap from '@ohos.util.HashMap';

const TAG = 'AppResourceCacheManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * A Manager class that provides get/set/clear cache methods for app image data.
 */
export class AppResourceCacheManager {
  memoryCache: HashMap<string, object | string>;

  constructor() {
    this.memoryCache = new HashMap();
  }

  /**
   * Get cache from disk or memory.
   *
   * @param {string} cacheKey - cacheKey of the cache map
   * @return {object} - cache get from memory or disk
   */
  getCache<T>(cacheKey: string, cacheType: string): T {
    return this.getCacheFromMemory<T>(cacheKey, cacheType);
  }

  /**
   * Set cache to disk or memory.
   *
   * @param {string} cacheKey - cacheKey of the cache map
   * @param {object} value - value of the cache map
   */
  setCache(cacheKey: string, cacheType: string, value: object | string): void {
    log.showDebug(`setCache cacheKey: ${cacheKey}, cacheType: ${cacheType}`);
    this.setCacheToMemory(cacheKey, cacheType, value);
  }

  /**
   * Clear cache of memory.
   */
  clearCache(): void {
    log.showDebug('clearCache');
    this.memoryCache.clear();
  }

  /**
   * Clear cache of both disk and memory.
   */
  clearAllCache(): void {
    log.showDebug('clearAllCache');
    this.memoryCache.clear();
  }

  deleteCache(cacheKey: string, cacheType: string): void {
    this.memoryCache.remove(cacheKey);
  }

  deleteCacheByBundle(bundleName: string): void {
    let keys = this.memoryCache.keys();
    for (let key of keys) {
      if (key.indexOf(bundleName) >= 0) {
        this.memoryCache.remove(key);
      }
    }
  }

  private getCacheFromMemory<T>(cacheKey: string, cacheType: string): T {
    const cache = this.memoryCache.get(cacheKey);
    if (cache === undefined || cache === null || cache === '') {
      return null;
    } else if (cache[cacheType] === undefined || cache[cacheType] === null || cache[cacheType] === '') {
      return null;
    } else {
      return cache[cacheType];
    }
  }

  private setCacheToMemory(cacheKey: string, cacheType: string, value: object | string): void {
    let cache = this.memoryCache.get(cacheKey);
    if (cache === undefined || cache === null || cache === '') {
      cache = {};
      cache[cacheType] = value;
    } else {
      cache[cacheType] = value;
    }
    this.memoryCache.set(cacheKey, cache);
  }
}