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
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'AnimMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

// 默认管理器名
const DEFAULT_MGR = 'defaultAnimMgr';

// 动效事件类型
export type AnimEvent = () => void;

// 动效入参
export interface AnimParamWrap {
  // 动效场景，主要标识
  mainScene: string;
  // 动效次要标识，用于同动效场景时辅助区分
  secondaryKey?: string;
  // 冲突动效场景，主要标识
  conflictScene?: string;
  // 冲突动效次要标识
  conflictKey?: string;
  // 动效参数
  oriParam: AnimateParam;
  // 动效执行事件
  oriEvent: AnimEvent;
}

// 动效参数缓存
class AnimCache {
  private mainScene?: string;
  private secondaryKey?: string;
  private conflictScene?: string;
  private conflictKey?: string;
  private animFinish?: AnimEvent;
  private animEvent?: AnimEvent;
  // 动效曲线复制
  private readonly animParam: AnimateParam;

  private constructor(wrap: AnimParamWrap) {
    this.mainScene = wrap?.mainScene;
    this.secondaryKey = wrap?.secondaryKey;
    this.conflictScene = wrap?.conflictScene;
    this.conflictKey = wrap?.conflictKey;
    this.animFinish = wrap?.oriParam?.onFinish;
    this.animEvent = wrap?.oriEvent;
    this.animParam = {
      duration: wrap?.oriParam?.duration,
      tempo: wrap?.oriParam?.tempo,
      curve: wrap?.oriParam?.curve,
      delay: wrap?.oriParam?.delay,
      iterations: wrap?.oriParam?.iterations,
      playMode: wrap?.oriParam?.playMode,
      finishCallbackType: wrap?.oriParam?.finishCallbackType,
      expectedFrameRateRange: wrap?.oriParam?.expectedFrameRateRange,
    };
  }

  /**
   * 唯一标识拼接
   *
   * @returns 唯一标识
   */
  getKey(): string {
    return `${this.mainScene}_${this.secondaryKey}`;
  }

  /**
   * 冲突动效唯一标识拼接
   *
   * @returns 唯一标识
   */
  getConflictKey(): string {
    return `${this.conflictScene}_${this.conflictKey}`;
  }

  /**
   * 复制后的动线曲线参数，无finish
   *
   * @returns 动效曲线参数
   */
  getAnimParam(): AnimateParam {
    return this.animParam;
  }

  /**
   * 动效执行回调
   *
   * @returns 执行回调
   */
  getAnimEvent(): AnimEvent | undefined {
    return this.animEvent;
  }

  /**
   * 消费动效执行回调
   */
  exeAnimEvent(): void {
    if (this.animEvent) {
      this.animEvent();
      this.animEvent = undefined;
    }
  }

  /**
   * 消费动效结束回调
   */
  exeAnimFinish(): void {
    if (this.animFinish) {
      this.animFinish();
      this.animFinish = undefined;
    }
  }

  /**
   * 构造
   *
   * @param wrap 动效参数
   * @returns 实例
   */
  static wrap(wrap: AnimParamWrap): AnimCache {
    return new AnimCache(wrap);
  }
}

/**
 * 动效管理器
 */
export class AnimMgr {
  // 主动效缓存
  private readonly animCache: Map<string, AnimCache> = new Map();

  // 次要动效缓存
  private readonly animSecondaryCache: Map<string, Set<AnimCache>> = new Map();

  // 管理器名
  private readonly mgrName: string;

  // 内部参数转换
  private readonly innerParam: AnimParamWrap = {
    mainScene: '',
    oriParam: {},
    oriEvent: () => {}
  };

  constructor(mgrName: string = DEFAULT_MGR) {
    this.mgrName = mgrName;
  }

  /**
   * 动效执行
   *
   * @param param 动效参数
   */
  public animateTo(param: AnimParamWrap): void {
    if (!param) {
      log.showWarn(`animateTo invalid param: ${this.mgrName}`);
      return;
    }
    this.animateToInner(param);
  }

  /**
   * 动效执行
   *
   * @param param 动效参数
   */
  public animateToImmediately(param: AnimParamWrap): void {
    if (!param) {
      log.showWarn(`animateToImmediately invalid param: ${this.mgrName}`);
      return;
    }
    this.animateToInner(param, true);
  }

  /**
   * 次要动效执行
   *
   * @param param 动效参数
   */
  public animateToSecondary(param: AnimParamWrap): void {
    if (!param) {
      log.showWarn(`animateToSecondary invalid param: ${this.mgrName}`);
      return;
    }
    this.secondaryAnimateToInner(param);
  }

  /**
   * 次要动效执行
   *
   * @param param 动效参数
   */
  public animateToImmediatelySecondary(param: AnimParamWrap): void {
    if (!param) {
      log.showWarn(`animateToImmediatelySecondary invalid param: ${this.mgrName}`);
      return;
    }
    this.secondaryAnimateToInner(param, true);
  }

  /**
   * 打断动效执行
   *
   * @param mainScene 动效场景
   * @param secondaryKey 动效次要标识
   */
  public interruptAnim(mainScene: string, secondaryKey?: string): AnimMgr {
    this.innerParam.mainScene = mainScene;
    this.innerParam.secondaryKey = secondaryKey;
    let innerCache = AnimCache.wrap(this.innerParam);
    let tarCache = this.getCache(innerCache.getKey());
    if (tarCache) {
      this.deleteCache(tarCache.getKey());
      // 次要动效同步复位
      this.resetSecondaryCache(tarCache);
      tarCache.exeAnimEvent();
      tarCache.exeAnimFinish();
      log.showInfo(`interruptAnim success: ${tarCache.getKey()}, ${this.mgrName}`);
    } else {
      log.showWarn(`interruptAnim fail: ${innerCache.getKey()}, ${this.mgrName}`);
    }
    return this;
  }

  /**
   * 动效开启
   *
   * @param param 动效参数
   * @param isImmediately true立即执行
   */
  private animateToInner(param: AnimParamWrap, isImmediately: boolean = false): void {
    let newAnimCache = AnimCache.wrap(param);
    let animKey = newAnimCache.getKey();
    let conflictKey = newAnimCache.getConflictKey();
    let oldAnimCache = this.getCache(animKey);
    // 已有动效未消费，快速消费
    this.quickEndAnim(oldAnimCache);
    this.addCache(newAnimCache);
    // 动效结束，清除缓存
    let animParam = newAnimCache.getAnimParam();
    animParam.onFinish = () => {
      // 使用取值回调，打断后将取值为空
      let animCache = this.getCache(animKey);
      // 当前最新的cache不匹配，表示已被打断过，无需处理
      if (animCache !== newAnimCache) {
        log.showWarn(`animateToInner has interrupt old: ${animKey}, ${this.mgrName}`);
        return;
      }
      this.deleteCache(animKey);
      animCache?.exeAnimFinish();
      log.showInfo(`animateToInner finish anim: ${animKey}, ${this.mgrName}`);
    };
    // 动效执行
    let innerEvent = () => {
      // 动效启动时，若冲突动效还未执行，则快速结束冲突动效，防止冲突动效滞后执行影响参数设置
      let conflictCache = this.getCache(conflictKey);
      if (conflictCache && conflictCache.getAnimEvent()) {
        this.quickEndAnim(conflictCache);
      }
      // 继续当前动效
      newAnimCache.exeAnimEvent();
    };
    log.showInfo(`animateToInner start anim: ${animKey}, ${this.mgrName}`);
    if (isImmediately) {
      animateToImmediately(animParam, innerEvent);
    } else {
      animateTo(animParam, innerEvent);
    }
  }

  /**
   * 次要动效开启
   *
   * @param param 动效参数
   * @param isImmediately true立即执行
   */
  private secondaryAnimateToInner(param: AnimParamWrap, isImmediately: boolean = false): void {
    let newAnimCache = AnimCache.wrap(param);
    let animKey = newAnimCache.getKey();
    this.addSecondaryCache(newAnimCache);
    // 动效结束，清除缓存
    let animParam = newAnimCache.getAnimParam();
    animParam.onFinish = () => {
      // 打断移除后，避免重复调用
      let hasAnimCache = this.hasSecondaryCache(newAnimCache);
      this.deleteSecondaryCache(animKey, newAnimCache);
      if (hasAnimCache) {
        newAnimCache.exeAnimFinish();
      }
      log.showInfo(`secondaryAnimateToInner finish anim: ${animKey}, ${this.mgrName}`);
    };
    // 动效执行
    let innerEvent = () => {
      newAnimCache.exeAnimEvent();
    };
    log.showInfo(`secondaryAnimateToInner start anim: ${animKey}, ${this.mgrName}`);
    if (isImmediately) {
      animateToImmediately(animParam, innerEvent);
    } else {
      animateTo(animParam, innerEvent);
    }
  }

  /**
   * 快速结束动效
   *
   * @param cache 缓存动效
   */
  private quickEndAnim(cache?: AnimCache): void {
    if (cache) {
      log.showWarn(`quickEndAnim: ${cache.getKey()}, ${this.mgrName}`);
      // 次要动效同步复位
      this.resetSecondaryCache(cache);
      // 快速结束动效，复位
      cache.exeAnimEvent();
      cache.exeAnimFinish();
      this.deleteCache(cache.getKey());
    }
  }

  /**
   * 缓存动效
   *
   * @param cache 动效缓存参数
   */
  private addCache(cache: AnimCache): void {
    if (cache) {
      this.animCache.set(cache.getKey(), cache);
    }
  }

  /**
   * 取出缓存
   *
   * @param key 键值
   * @returns 缓存动效
   */
  private getCache(key: string): AnimCache | undefined {
    return this.animCache.get(key);
  }

  /**
   * 清除缓存
   *
   * @param key 键值
   */
  private deleteCache(key: string): void {
    this.animCache.delete(key);
  }

  /**
   * 同步回收次要动效
   *
   * @param mainCache 主动效
   */
  private resetSecondaryCache(mainCache: AnimCache): void {
    if (mainCache) {
      let caches = this.getSecondaryCache(mainCache.getKey());
      this.deleteSecondaryCache(mainCache.getKey());
      caches?.forEach((cache) => {
        cache.exeAnimEvent();
        cache.exeAnimFinish();
      });
    }
  }

  /**
   * 缓存次要动效
   *
   * @param cache 动效缓存参数
   */
  private addSecondaryCache(cache: AnimCache): void {
    if (cache) {
      let cacheSet = this.animSecondaryCache.get(cache.getKey());
      if (!cacheSet) {
        cacheSet = new Set();
        this.animSecondaryCache.set(cache.getKey(), cacheSet);
      }
      cacheSet.add(cache);
    }
  }

  /**
   * 次要动效是否存在
   *
   * @param cache 动效缓存参数
   * @returns true 缓存参数存在
   */
  private hasSecondaryCache(cache: AnimCache): boolean {
    return this.getSecondaryCache(cache?.getKey())?.has(cache) ?? false;
  }

  /**
   * 取出次要缓存
   *
   * @param key 键值
   * @returns 缓存动效
   */
  private getSecondaryCache(key: string): Set<AnimCache> | undefined {
    return this.animSecondaryCache.get(key);
  }

  /**
   * 清除次要缓存
   *
   * @param key 键值
   * @param cache 删除目标
   */
  private deleteSecondaryCache(key: string, cache?: AnimCache): void {
    if (cache) {
      let cacheSet = this.animSecondaryCache.get(key);
      cacheSet?.delete(cache);
      if (cacheSet && cacheSet.size === 0) {
        this.animSecondaryCache.delete(key);
      }
      return;
    }
    this.animSecondaryCache.delete(key);
  }
}