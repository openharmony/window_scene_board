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
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { SlVisualSolidUtils } from './SlVisualUtils';
import { SLWallpaperType } from '../wallpaper/ScreenLockWallpaperState';
import CommonConstants from '../constants/CommonConstants';
import { BackCacheUnit } from './SlVisualData';

const TAG: string = 'ColorCacheManager';
const log = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 纯色计算缓存加速模块
 */
export class SlColorCacheManager {
  /**
   * 缓存最大容量
   */
  private capacity: number = CommonConstants.BACK_COLOR_CACHE_CAPACITY;

  /**
   * 计算的颜色色缓存
   */
  private colorCache: Map<string, BackCacheUnit> = new Map();

  /**
   * 缓存命中次数
   */
  private hits: number = 0;

  /**
   * 缓存未命中次数
   */
  private misses: number = 0;

  /**
   * 用于壁纸更新时，移除失效壁纸的所有缓存
   */
  private colorRemoveKeyMap: Map<SLWallpaperType, Set<string>> = new Map();

  /**
   * 查询壁纸背景颜色缓存
   *
   * @param wallPaperType 壁纸类型
   * @param position 组件区域
   * @returns 计算的壁纸背景信息
   */
  getBackColorCache(wallPaperType: SLWallpaperType, position: number[]): BackCacheUnit | undefined {
    let cacheKey = this.getBackColorCacheKey(wallPaperType, position);
    if (!cacheKey) {
      return undefined;
    }

    this.printCacheHit(cacheKey);
    return this.colorCache.get(cacheKey);
  }

  /**
   * 设置壁纸背景颜色缓存
   *
   * @param wallPaperType 壁纸类型
   * @param position 组件区域
   * @param cache 缓存壁纸背景信息
   */
  setBackColorCache(wallPaperType: SLWallpaperType, position: number[], cache: BackCacheUnit): void {
    let key = this.getBackColorCacheKey(wallPaperType, position);
    if (!key || !cache) {
      return;
    }

    this.checkCapacity(wallPaperType);
    let keySet = this.colorRemoveKeyMap.get((wallPaperType));
    if (!keySet) {
      keySet = new Set();
      this.colorRemoveKeyMap.set(wallPaperType, keySet);
    }

    keySet.add(key);
    this.colorCache.set(key, cache);
  }

  /**
   * 壁纸刷新时，依据旧壁纸计算的所有颜色缓存均视效
   *
   * @param wallPaperType 壁纸类型
   */
  invalidBackColorByWallPaperType(wallPaperType: SLWallpaperType): void {
    log.showInfo( `invalidBackColorByWallPaperType wallPaPerType:${wallPaperType}`);
    this.colorRemoveKeyMap.get(wallPaperType)?.forEach((cacheKey: string) => {
      this.colorCache.delete(cacheKey);
    });
    this.colorRemoveKeyMap.get(wallPaperType)?.clear();
    this.colorRemoveKeyMap.delete(wallPaperType);
  }

  /**
   * 壁纸刷新时，依据旧壁纸计算的所有颜色缓存均视效
   *
   * @param wallPaperType 壁纸类型
   * @param position 组件区域
   */
  invalidBackColor(wallPaperType: SLWallpaperType, position: number[]): void {
    let key = this.getBackColorCacheKey(wallPaperType, position);
    this.colorCache.delete(key);
    this.colorRemoveKeyMap.get(wallPaperType)?.delete(key);
  }

  private printCacheHit(key: string): void {
    if (this.colorCache.has(key)) {
      this.hits++;
    } else {
      this.misses++;
    }

    if (this.hits + this.misses < CommonConstants.MAX_CACHE_COUNT_SIZE) {
      return;
    }

    log.showInfo(`printCacheHit hits: ${this.hits}, miss: ${this.misses}`);
    this.hits = 0;
    this.misses = 0;
  }

  /**
   * 新增缓存时检测存储的背景颜色是否超出容量
   *
   * @param wallPaperType 新增缓存的壁纸类型
   */
  private checkCapacity(wallPaperType: SLWallpaperType): void {
    if (this.colorCache.size < this.capacity) {
      return;
    }
    this.colorRemoveKeyMap.forEach((value: Set<string>, type: SLWallpaperType) => {
      if (type !== wallPaperType) {
        this.invalidBackColorByWallPaperType(type);
      }
    });
  }

  /**
   * 根据当前的壁纸类型，和壁纸上的区域，生成缓存唯一标识key
   * 用以缓存通过colorPicker计算的壁纸背景颜色
   *
   * @param wallPaperType 壁纸类型
   * @param position 组件区域
   * @returns 唯一标识
   */
  private getBackColorCacheKey(wallPaperType: SLWallpaperType, position: number[]): string {
    let realPosition = position;
    if (!realPosition || realPosition.length < 4) {
      realPosition = CommonConstants.DEFAULT_WIDGET_AREA;
    }
    let standXLeft = SlVisualSolidUtils.getStandPos(realPosition[0]).toString();
    let standTop = SlVisualSolidUtils.getStandPos(realPosition[1]).toString();
    let standRight = SlVisualSolidUtils.getStandPos(realPosition[2]).toString();
    let standBottom = SlVisualSolidUtils.getStandPos(realPosition[3]).toString();
    return [wallPaperType, standXLeft, standTop, standRight, standBottom].join('');
  }
}