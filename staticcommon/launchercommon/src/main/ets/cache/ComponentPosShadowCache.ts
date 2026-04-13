/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
import { CommonConstants } from '../constants/CommonConstants';
import LruCache from './LruCache';

const TAG = 'ComponentPosShadowCache';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * A Manager class that provides get/set/clear cache methods for Component position and shadowOption
 */
export default class ComponentPosShadowCache {
  private readonly lruCache: LruCache;
  private static instance: ComponentPosShadowCache;

  constructor() {
    this.lruCache = new LruCache();
  }

  static getInstance(): ComponentPosShadowCache {
    if (ComponentPosShadowCache.instance == null) {
      ComponentPosShadowCache.instance = new ComponentPosShadowCache();
    }
    return ComponentPosShadowCache.instance;
  }

  /**
   * Get cache from disk or memory.
   *
   * @param {string} key - key of the cache map
   * @return {object} - cache get from the memory or disk
   */
  getCache(key: string): string {
    log.showInfo(`getCache key: ${key}`);
    const cache: string = this.lruCache.getCache(key) as string;
    if (cache === undefined || cache === null || cache === '') {
      return CommonConstants.INVALID_VALUE.toString();
    } else {
      return cache;
    }
  }

  /**
   * Set cache to disk or memory.
   *
   * @param {string} key - key of the cache map
   * @param {object} value - value of the cache map
   */
  setCache(key: string, value: string): void {
    log.showInfo(`setCache key:${key}, value: ${value}`);
    this.lruCache.putCache(key, value);
  }

  /**
   * remove cache.
   *
   * @param {string} key - key of the cache map
   */
  removeCache(key: string): void {
    log.showInfo(`removeCache key${key}`);
    this.lruCache.remove(key);
  }

  /**
   * Clear cache of both disk and memory.
   */
  clearCache(): void {
    log.showInfo('clearCache');
    this.lruCache.clear();
  }
}