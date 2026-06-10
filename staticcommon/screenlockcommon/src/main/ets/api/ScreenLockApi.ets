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
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { GlobalStatusCache, StatusCacheConst } from '../base/GlobalStatusCache';
import { SlStorageKey } from '../constants/SlStorageKey';
import { ScreenLockStateManager } from '../manager/ScreenLockStateManager';
import { SimCardStateManager } from '../manager/SimCardStateManager';
import { LockUnlockCallback, ScreenLockUnlockService } from '../services/ScreenLockUnLockService';
import { SystemSwitchUtils } from '../utils/SystemSwitchUtils';
import type { Callback } from '@ohos.base';

const TAG = 'ScreenLockApi';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 锁屏接口，仅供内部模块使用
 */
export class ScreenLockApi {
  private static getLockCallback: Function | undefined;
  private static requestUnlockCallback: Function | undefined;
  private static unlockWhenNoPswCallback: Function | undefined;
  private static notifyUnlockTransitionCallback: Function | undefined;
  private static isScreenLockShowCallback: Function | undefined;
  private static isDeviceLockedCallback: Function | undefined;

  public static initCallback(getLockCallback: Function, requestUnlockCallback: Function,
    unlockWhenNoPswCallback: Function, notifyUnlockTransitionCallback: Function,
    isScreenLockShowCallback: Function, isDeviceLockedCallback: Function): void {
    ScreenLockApi.getLockCallback = getLockCallback;
    ScreenLockApi.requestUnlockCallback = requestUnlockCallback;
    ScreenLockApi.unlockWhenNoPswCallback = unlockWhenNoPswCallback;
    ScreenLockApi.notifyUnlockTransitionCallback = notifyUnlockTransitionCallback;
    ScreenLockApi.isScreenLockShowCallback = isScreenLockShowCallback;
    ScreenLockApi.isDeviceLockedCallback = isDeviceLockedCallback;
  }

  public static clearCallback(): void {
    ScreenLockApi.getLockCallback = undefined;
    ScreenLockApi.requestUnlockCallback = undefined;
    ScreenLockApi.unlockWhenNoPswCallback = undefined;
    ScreenLockApi.notifyUnlockTransitionCallback = undefined;
    ScreenLockApi.isScreenLockShowCallback = undefined;
    ScreenLockApi.isDeviceLockedCallback = undefined;
  }

  /**
   * 请求接口
   *
   * @param callback 成功回调接口
   * @param withDelay 是否延时
   */
  public static requestUnlock(callback?: LockUnlockCallback, withDelay: boolean = false,
    cancelCallback?: Callback<void>): void {
    log.showInfo(`requestUnlock withDelay ${withDelay} from outer`);
    if (SystemSwitchUtils.isUseNewScreenLock()) {
      ScreenLockUnlockService.getInstance().requestUnlock(callback);
    } else {
      if (ScreenLockApi.requestUnlockCallback) {
        ScreenLockApi.requestUnlockCallback?.(callback, withDelay, cancelCallback);
      } else {
        log.showError('requestUnlock requestUnlockCallback undefined');
      }
    }
  }

  /**
   * 请求解锁，携带键盘显示位置
   *
   * @param keyboardPosition 密码页键盘位置
   * @param callback 成功回调接口
   */
  public static requestUnlockWithPosition(keyboardPosition: number = 0, callback?: LockUnlockCallback): void {
    log.showInfo(`requestUnlockWithPosition keyboardPosition:${keyboardPosition}.`);
    AppStorage.setOrCreate(SlStorageKey.KEYBOARD_POSITION, keyboardPosition);
    ScreenLockUnlockService.getInstance().requestUnlock(callback);
    AppStorage.delete(SlStorageKey.KEYBOARD_POSITION);
  }

  /**
   * 通知WMS锁屏状态
   */
  public static notifyEarlyUnlockTransition(): void {
    log.showInfo('notifyEarlyUnlockTransition from outer.');
    SCBSceneSessionManager.getInstance().notifyWMSIsLockReceived(false);
  }

  /**
   * 获取锁屏页面是否显示，已废弃，推荐使用isScreenLockShow()
   *
   * @deprecated
   * @returns true显示/false不显示
   */
  public static getLock(): boolean {
    if (SystemSwitchUtils.isUseNewScreenLock()) {
      return ScreenLockStateManager.getInstance().isPageShow && !ScreenLockStateManager.getInstance().isInEdite;
    } else {
      if (ScreenLockApi.getLockCallback) {
        return ScreenLockApi.getLockCallback?.();
      } else {
        log.showError('getLock getLockCallback undefined');
        return true;
      }
    }
  }

  /**
   * 检查设备当前是否处于锁定状态，并且屏幕锁需要身份进行身份验证和解锁。
   *
   * @returns 设备当前是否被锁定。
   */
  public static isDeviceLocked(): boolean {
    if (SystemSwitchUtils.isUseNewScreenLock()) {
      return ScreenLockStateManager.getInstance().isLocked;
    } else {
      if (ScreenLockApi.isDeviceLockedCallback) {
        return ScreenLockApi.isDeviceLockedCallback?.();
      } else {
        log.showError('getLock isDeviceLockedCallback undefined');
        return true;
      }
    }
  }

  /**
   * 获取锁屏页面是否显示
   *
   * @returns true显示/false不显示
   */
  public static isScreenLockShow(): boolean {
    if (SystemSwitchUtils.isUseNewScreenLock()) {
      return ScreenLockStateManager.getInstance().isPageShow;
    } else {
      if (ScreenLockApi.isScreenLockShowCallback) {
        return ScreenLockApi.isScreenLockShowCallback?.();
      } else {
        log.showError('getLock isScreenLockShowCallback undefined');
        return true;
      }
    }
  }

  /**
   * 当没有锁屏密码时解锁
   */
  public static unlockWhenNoPsw(): void {
    log.showInfo('notifyEarlyUnlockTransition from outer.');
    if (SystemSwitchUtils.isUseNewScreenLock()) {
      ScreenLockUnlockService.getInstance().requestUnlock();
    } else {
      if (ScreenLockApi.unlockWhenNoPswCallback) {
        ScreenLockApi.unlockWhenNoPswCallback?.();
      } else {
        log.showError('unlockWhenNoPsw unlockWhenNoPswCallback undefined');
      }
    }
  }

  /**
   * 当没有锁屏密码时解锁
   */
  public static notifyUnlockTransitionForPc(): void {
    log.showInfo('notifyEarlyUnlockTransition from outer.');
    if (SystemSwitchUtils.isUseNewScreenLock()) {
      return;
    }
    if (ScreenLockApi.notifyUnlockTransitionCallback) {
      ScreenLockApi.notifyUnlockTransitionCallback?.();
    } else {
      log.showError('notifyUnlockTransitionForPc notifyUnlockTransitionCallback undefined');
    }
  }

  /**
   * 查询是否Sim卡锁定
   *
   * @returns 是否Sim卡锁定
   */
  public static isSimLocked(): boolean {
    if (SystemSwitchUtils.isUseNewScreenLock()) {
      return SimCardStateManager.getInstance().isSimLocked();
    } else {
      return !!GlobalStatusCache.getInstance().getStatus(StatusCacheConst.SIM_CARD_LOCKED_KEY, false);
    }
  }
}