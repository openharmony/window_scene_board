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
import { CacheValue, GlobalStatusCache } from '../base/GlobalStatusCache';

import { KeyGuardCacheKey,
  KeyguardCoverModel,
  KeyGuardLockStatus,
  KeyGuardMode,
  KeyGuardPage,
  KeyguardSlGreetModel
} from '../bean/KeyGuardStatusEnum';
import { Callback } from '@ohos.base';
import { BitStatesUtil } from '../utils/BitStatesUtil';
import { HashMap } from '@kit.ArkTS';
import { ObserverCallback } from '../monitor/AbstractObserver';
import { OccludeKeygaurdScene } from '@ohos/windowscene';

const keyguardStatusServiceMap: Map<string, HashMap<Callback<CacheValue>, ObserverCallback<CacheValue>>> = new Map();

export class KeyguardStatusService {


  /**
   * 切换到指定页面
   * @param page
   */
  public static switchToPage(page: KeyGuardPage): void {
    GlobalStatusCache.getInstance().setStatus(KeyGuardCacheKey.PAGE_TYPE, page);
  }

  public static isOnlyCurrentUser(): boolean {
    return KeyguardStatusService.isMode(KeyGuardMode.LOST_MODE);
  }

  /**
   * 设置锁屏遮盖状态
   * @param occludedState
   */
  public static switchToOccluded(occludedState: number): void {
    GlobalStatusCache.getInstance().setStatus(KeyGuardCacheKey.OCCLUDED_STATUS, occludedState);
  }

  /**
   * 返回是否是锁屏遮盖状态
   * @returns 遮盖状态
   */
  public static isOccluded(): boolean {
    return GlobalStatusCache.getInstance().getStatus(KeyGuardCacheKey.OCCLUDED_STATUS, OccludeKeygaurdScene.NONE) !==
    OccludeKeygaurdScene.NONE;
  }

  /**
   * 设置锁屏遮盖状态
   * @param occludedState
   */
  public static setCoverMode(coverState: number): void {
    GlobalStatusCache.getInstance().setStatus(KeyGuardCacheKey.COVER_MODE, coverState);
  }

  /**
   * 返回是否皮套模式
   * @returns 皮套模式
   */
  public static isCoverMode(): boolean {
    return GlobalStatusCache.getInstance().getStatus(KeyGuardCacheKey.COVER_MODE, KeyguardCoverModel.COVER_REMOVED) ===
      KeyguardCoverModel.COVER_ADDED_ON;
  }

  /**
   * 返回是否皮套模式
   * @returns 皮套模式
   */
  public static isSlGreetMode(): boolean {
    return GlobalStatusCache.getInstance()
      .getStatus(KeyGuardCacheKey.SL_GREET_MODE, KeyguardSlGreetModel.SL_GREET_OFF) ===
    KeyguardSlGreetModel.SL_GREET_ON;
  }

  /**
   * 设置锁屏遮盖状态
   * @param occludedState
   */
  public static setSlGreetMode(greetState: number): void {
    GlobalStatusCache.getInstance().setStatus(KeyGuardCacheKey.SL_GREET_MODE, greetState);
  }

  /**
   * 判断当前是否为指定页面
   * @param page
   * @returns
   */
  public static isPage(page: KeyGuardPage): boolean {
    return GlobalStatusCache.getInstance().getStatus(KeyGuardCacheKey.PAGE_TYPE, KeyGuardPage.HOME_PAGE) === page;
  }

  /**
   * 判断当前是否为指定的特殊模式
   * @param mode
   * @returns
   */
  public static isMode(mode: KeyGuardMode): boolean {
    const status = GlobalStatusCache.getInstance().getStatus(KeyGuardCacheKey.SPECIAL_MODE, KeyGuardMode.DEFAULT);
    return BitStatesUtil.hasState(status as number, mode);
  }

  /**
   * 判断当前是否为统一处理的特殊模式
   * @returns
   */
  public static isSpecialMode(): boolean {
    const status = GlobalStatusCache.getInstance().getStatus(KeyGuardCacheKey.SPECIAL_MODE, KeyGuardMode.DEFAULT);
    return BitStatesUtil.hasState(status as number, KeyGuardMode.LOST_MODE) ||
      BitStatesUtil.hasState(status as number, KeyGuardMode.THERMAL_SAFETY) ||
      BitStatesUtil.hasState(status as number, KeyGuardMode.POWER_EMERGENCY);
  }

  /**
   * 打开指定的特殊模式
   * @param mode
   * @returns
   */
  public static openMode(mode: KeyGuardMode): void {
    const status = GlobalStatusCache.getInstance().getStatus(KeyGuardCacheKey.SPECIAL_MODE, KeyGuardMode.DEFAULT);
    const newState: number = BitStatesUtil.addState(status as number, mode);
    GlobalStatusCache.getInstance().setStatus(KeyGuardCacheKey.SPECIAL_MODE, newState);
  }

  /**
   * 关闭指定的特殊模式
   * @param mode
   * @returns
   */
  public static closeMode(mode: KeyGuardMode): void {
    const status = GlobalStatusCache.getInstance().getStatus(KeyGuardCacheKey.SPECIAL_MODE, KeyGuardMode.DEFAULT);
    const newState: number = BitStatesUtil.removeState(status as number, mode);
    GlobalStatusCache.getInstance().setStatus(KeyGuardCacheKey.SPECIAL_MODE, newState);
  }

  /**
   * 获取当前特殊模式状态总值
   * @param mode
   * @returns
   */
  public static getMode(): number {
    return GlobalStatusCache.getInstance().getStatus(KeyGuardCacheKey.SPECIAL_MODE, KeyGuardMode.DEFAULT) as number;
  }

  /**
   * 设置锁定状态
   * @param lockStatus
   */
  public static setLockStatus(lockStatus: KeyGuardLockStatus): void {
    GlobalStatusCache.getInstance().setStatus(KeyGuardCacheKey.LOCK_STATUS, lockStatus);
  }

  /**
   * 判断是否为指定锁定状态
   * @param lockStatus
   * @returns
   */
  public static isLockStatus(lockStatus: KeyGuardLockStatus): boolean {
    const status: CacheValue = GlobalStatusCache.getInstance().getStatus(KeyGuardCacheKey.LOCK_STATUS,
      KeyGuardLockStatus.DEFAULT);
    return status === lockStatus;
  }

  /**
   * 注册认证方式禁用监听
   * @param callback
   */
  public static onAuthTypeDisabledChanged(callback: Callback<CacheValue>): void {
    GlobalStatusCache.getInstance().subscribe(KeyGuardCacheKey.AUTH_ENABLE, (status?: CacheValue) => {
      callback(status);
    });
  }

  /**
   * 注册锁屏状态变化监听
   * @param callback
   */
  public static onLockStateChanged(callback: Callback<CacheValue>): void {
    GlobalStatusCache.getInstance().subscribe(KeyGuardCacheKey.LOCK_STATUS, (status?: CacheValue) => {
      callback(status);
    });
  }

  /**
   * 注册特殊模式变化监听
   * @param callback
   */
  public static onModeChanged(callback: Callback<CacheValue>): void {
    KeyguardStatusService.subscribeInGeneral(KeyGuardCacheKey.SPECIAL_MODE, callback);
  }

  /**
   * @param callback
   * @param callback
   * 注册特殊模式变化监听
   * @param callback
   */
  public static onModeChangedUnsubscribe(callback: Callback<CacheValue>): void {
    KeyguardStatusService.unsubscribeInGeneral(KeyGuardCacheKey.SPECIAL_MODE, callback);
  }

  /**
   * 注册锁屏页面切换监听
   * @param callback
   */
  public static onPageChanged(callback: Callback<CacheValue>): void {
    KeyguardStatusService.subscribeInGeneral(KeyGuardCacheKey.PAGE_TYPE, callback);
  }

  public static subscribeInGeneral(eventType: string, callback: Callback<CacheValue>): void {
    const pageCallBack: ObserverCallback<CacheValue | undefined> = (status: CacheValue | undefined) => {
      callback(status);
    };
    if (!keyguardStatusServiceMap.has(eventType)) {
      keyguardStatusServiceMap.set(eventType, new HashMap<Callback<CacheValue>, ObserverCallback<CacheValue>>());
    }
    keyguardStatusServiceMap.get(eventType)?.set(callback, pageCallBack);
    GlobalStatusCache.getInstance().subscribe(eventType, pageCallBack);
  }

  /**
   * @param callback
   * 注册锁屏页面切换监听
   * @param callback
   */
  public static onPageChangedUnScribe(callback: Callback<CacheValue>): void {
    KeyguardStatusService.unsubscribeInGeneral(KeyGuardCacheKey.PAGE_TYPE, callback);
  }

  public static unsubscribeInGeneral(eventType: string, callback: Callback<CacheValue>): void {
    if (keyguardStatusServiceMap.has(eventType)) {
      let pageCallBack: ObserverCallback<CacheValue> | undefined =
        keyguardStatusServiceMap.get(eventType)?.get(callback);
      if (pageCallBack) {
        GlobalStatusCache.getInstance().unsubscribe(eventType, pageCallBack);
      }
      keyguardStatusServiceMap.get(eventType)?.remove(callback);
    }
  }
}