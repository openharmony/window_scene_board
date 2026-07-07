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
import { HashMap } from '@kit.ArkTS';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'AiSuggestionCache';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 语音助手建议缓存
 */
export class AiSuggestionCache {
  private static sInstance: AiSuggestionCache;

  private iconCacheMap: HashMap<string, string> = new HashMap();

  /**
   * 获取实例
   */
  static getInstance(): AiSuggestionCache {
    if (!AiSuggestionCache.sInstance) {
      AiSuggestionCache.sInstance = new AiSuggestionCache();
    }
    return AiSuggestionCache.sInstance;
  }

  /**
   * 存储ICON到缓存
   *
   * @param cacheKey 缓存key
   * @param image icon实例
   */
  public setIconCache(cacheKey: string, image: string | undefined): void {
    if (!image || !cacheKey) {
      log.showInfo(`setIconCache, image or cacheKey is empty, cacheKey: ${cacheKey}`);
      return;
    }
    this.iconCacheMap.set(cacheKey, image);
    log.showInfo(`setIconCache success:${cacheKey}`);
  }

  /**
   * 获取缓存中的图片资源
   *
   * @param cacheKey 缓存key
   * @returns icon实例
   */
  public getIconCache(cacheKey: string): string | undefined {
    if (!cacheKey) {
      return undefined;
    }
    return this.iconCacheMap.get(cacheKey);
  }

  /**
   * 删除icon缓存
   *
   * @param cacheKey 缓存key
   */
  public deleteIconCache(cacheKey: string): void {
    if (!cacheKey && !this.iconCacheMap.hasKey(cacheKey)) {
      return;
    }
    this.iconCacheMap.remove(cacheKey);
    log.showInfo(`deleteIconCache success:${cacheKey}`);
  }

  /**
   * 清理所有缓存
   */
  public clearAllCache(): void {
    this.iconCacheMap.clear();
    log.showInfo(`clearAllCache success`);
  }
}