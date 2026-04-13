/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { AbstractObserver } from '../monitor/AbstractObserver';

export class StatusCacheConst {
  public static readonly NEED_SCREEN_TO_END_KEY: string = 'needScreenToEnd';
  public static readonly SIM_CARD_LOCKED_KEY: string = 'screenSimLocked';
  public static readonly CLOCK_LAYOUT_KEY: string = 'clockLayout';
  public static readonly CLOCK_STARTX_KEY: string = 'clockStartx';
  public static readonly CLOCK_STARTY_KEY: string = 'clockStarty';
  public static readonly CLOCK_GRIDWIDTH_KEY: string = 'clockGridwidth';
  public static readonly SCREEN_WIDTH_KEY: string = 'screenWidth';
  public static readonly SCREEN_HEIGHT_KEY: string = 'screenHeight';
  public static readonly SCREEN_ON_KEY: string = 'screenOnStatus';
  public static readonly IS_SCREEN_LOCK_FOCUS: string = 'isScreenLockFocus';
  public static readonly IS_SPECIAL_MODE_BOUNCER_FOCUS_KEY: string = 'isSpecialModeBouncerFocus';
  public static readonly IS_PIN_SAVING_SUPPORTED: string = 'isPinSavingSupported';
  public static readonly IS_SCREEN_OFF_FINGERPRINT_UNLOCK_ANI: string = 'screenOffFingerprintUnlockAni';
  public static readonly IS_PLAY_PWD_BACK_ANIMATION: string = 'playPwdBack';
  public static readonly IS_SPECIAL_MODE_PAGE_EXIT: string = 'isSpecialModePageExit';
}

export type CacheValue = boolean | number | string;

export class GlobalStatusCache extends AbstractObserver<CacheValue> {
  private statusMap: Map<string, CacheValue> = new Map();
  private static instance: GlobalStatusCache;

  private constructor() {
    super();
  }

  public static getInstance(): GlobalStatusCache {
    if (!GlobalStatusCache.instance) {
      GlobalStatusCache.instance = new GlobalStatusCache();
    }
    return GlobalStatusCache.instance;
  }

  public setStatus(key: string, value: CacheValue): void {
    const oldValue = this.statusMap.get(key);
    if (oldValue === undefined || oldValue !== value) {
      this.statusMap.set(key, value);
      this.publishAtStage(key, value);
    }
  }

  public getStatus(key: string, defaultValue: CacheValue): CacheValue {
    const res = this.statusMap.get(key);
    return res !== undefined ? res : defaultValue;
  }

  public hasStatus(key: string): boolean {
    return this.statusMap.has(key);
  }
}