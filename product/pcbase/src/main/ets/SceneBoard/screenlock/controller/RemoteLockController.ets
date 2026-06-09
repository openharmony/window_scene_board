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
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import ScreenLockMediator from '../refactor/ScreenLockMediator';
import DataShareManager from '@ohos/screenlockcommon/src/main/ets/base/DataShareManager';
import { Callback } from '@ohos.base';

const TAG = 'ScreenLock-RemoteLockController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

class RemoteLockModeConst {
  public static readonly REMOTE_LOCK_STATUS_KEY: string = 'settings.edm.lock_device_enable';
  public static readonly REMOTE_LOCK_TIPS_KEY: string = 'settings.edm.lock_device_info';
  public static readonly LOCK_STATUS_DEFAULT_VALUE: string = 'false';
  public static readonly LOCK_TIPS_DEFAULT_VALUE: string = 'The device has been locked by the administrator.';
  public static readonly LOCAL_EDM_LOCKED_KEY: string = 'remoteLocked';
  public static readonly LOCAL_EDM_LOCK_TIPS_KEY: string = 'remoteLockedTips';
}

/**
 * remote lock for pc controller
 *
 * @since 2023-11-6
 */
export class RemoteLockController {
  private isLocked: boolean;
  private lockedTips: string;

  constructor() {
    let currentStatus: string = sSettingsUtil.getValue(RemoteLockModeConst.REMOTE_LOCK_STATUS_KEY,
      RemoteLockModeConst.LOCK_STATUS_DEFAULT_VALUE);
    let currentTips: string = sSettingsUtil.getValue(RemoteLockModeConst.REMOTE_LOCK_TIPS_KEY,
      RemoteLockModeConst.LOCK_TIPS_DEFAULT_VALUE);
    this.isLocked = currentStatus === 'true' ? true : false;
    AppStorage.setOrCreate(RemoteLockModeConst.LOCAL_EDM_LOCKED_KEY, this.isLocked);
    this.lockedTips = currentTips;
    this.setDarkWallpaper();
  }

  public getLockedTips(): string {
    return this.lockedTips;
  }

  public isRemoteLocked(specialHandleIfNeed?: Callback<void>): boolean {
    specialHandleIfNeed?.();
    return this.isLocked;
  }

  public setDarkWallpaper(): void {
    // 企业远程锁屏场景，锁屏背景为空，但是没有背景图片，以此模拟黑色壁纸
    if (this.isLocked) {
      AppStorage.setOrCreate('isScreenLockWallpaperBrightOrDark', false);
      log.showInfo('set dark wallpaper for remote lock mode');
    }
  }

  public registerRemoteLockListener(): void {
    log.showInfo('register data listener for remote lock mode');

    DataShareManager.getInstance().registerDataShareListener(RemoteLockModeConst.REMOTE_LOCK_STATUS_KEY, () => {
      this.handleRemoteLockStatus();
    });
    log.showInfo('register data listener end');

  }

  public unregisterRemoteLockListener(): void {
    log.showInfo('unregister data listener for remote lock mode');

    DataShareManager.getInstance().unregisterDataShareListener(RemoteLockModeConst.REMOTE_LOCK_STATUS_KEY);
  }

  private handleRemoteLockStatus(): void {
    try {
      log.showInfo('receive dataChange notify');
      let lockStatusStr: string = sSettingsUtil.getValue(RemoteLockModeConst.REMOTE_LOCK_STATUS_KEY,
        RemoteLockModeConst.LOCK_STATUS_DEFAULT_VALUE);
      let currentTips: string = sSettingsUtil.getValue(RemoteLockModeConst.REMOTE_LOCK_TIPS_KEY,
        RemoteLockModeConst.LOCK_TIPS_DEFAULT_VALUE);
      let latestStatus: boolean = lockStatusStr === 'true' ? true : false;
      let isChanged: boolean = this.isLocked !== latestStatus;
      if (isChanged) {
        log.showInfo(`remote locked status changed: ${this.isLocked} -> ${latestStatus}`);
        this.isLocked = lockStatusStr === 'true' ? true : false;
      }
      AppStorage.setOrCreate(RemoteLockModeConst.LOCAL_EDM_LOCKED_KEY, latestStatus);
      if (this.lockedTips !== currentTips) {
        log.showInfo(`remote locked tips changed: ${this.lockedTips} -> ${currentTips}`);
        this.lockedTips = currentTips;
      }
      if (isChanged) {
        ScreenLockMediator.doScreenLock();
        log.showInfo('lock screen by remote lock done');
      }
    } catch (e) {
      log.showError(`handle error ${e}`);
    }
  }
}

