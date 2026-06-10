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

import Prompt from '@ohos.promptAction';
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { DesktopModeManager } from '../TsIndex';
import { desktopItemDraggableManager } from './DesktopItemDraggableManager';

const TAG = 'LockLayoutManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 锁定布局管理类
 */
class LockLayoutManager {
  /**
   * 桌面设置锁定布局开关状态
   */
  private lockLayoutStatus: boolean = false;

  /**
   * 当前是否锁定布局
   *
   * @returns boolean
   */
  public isLockLayout(): boolean {
    return this.lockLayoutStatus;
  }

  /*
   * 设置桌面布局开关状态
   *
   * @param lockLayoutStatus
   */
  public setlockLayoutStatus(lockLayoutStatus: boolean): void {
    log.showInfo(`setlockLayoutStatus, value is ${this.lockLayoutStatus}`);
    this.lockLayoutStatus = lockLayoutStatus;
    desktopItemDraggableManager.setEnableDrag(!lockLayoutStatus, TAG);
  }

  /**
   * 锁定布局弹出toast框
   */
  public toastLockedLayout(): void {
    if (DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode()) {
      log.showWarn('isInEmergencyOrThermalSafeMode');
      return;
    }
    log.showWarn(`layout is locked, show Toast`);
    try {
      Prompt.showToast({
        message: $r('app.string.desktop_layout_locked'),
        duration: 1000,
        showMode: Prompt.ToastShowMode.SYSTEM_TOP_MOST,
      });
    } catch (error) {
      log.showError(`showToast args error code is ${error.code}, message is ${error.message}`);
    }
  }
}
// 单例
export let lockLayoutManager: LockLayoutManager = SingletonHelper.getInstance(LockLayoutManager, TAG);