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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AppLockManager } from '@ohos/launchercommon/src/main/ets/manager/AppLockManager';
import { AppLockStatusEnum } from '@ohos/launchercommon/src/main/ets/manager/AppLockManager';
import { CcmConfigHelper } from '@ohos/screenlockcommon/src/main/ets/utils/CcmConfigHelper';
import { NotificationEntry } from '../model/NotificationEntry';

const TAG = 'LockScreenNtfAppLockUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export default class LockScreenNtfAppLockUtils {
  private constructor() {
  }

  /**
   * 校验发送通知的应用是否有添加应用锁
   * @param entry 通知实体
   * @returns
   */
  public static checkEntryAddAppLock(entry: NotificationEntry): boolean {
    let isAppLocked: boolean =
      AppLockManager.getInstance().getAppLockStatus(entry.creatorBundleName, entry.appIndex) === AppLockStatusEnum.LOCK;
    log.showInfo(`checkEntryAddAppLock bundleName ${entry.creatorBundleName} isLocked: ${isAppLocked}`);
    return isAppLocked;
  }

  /**
   * 校验当前发通知的应用是否在豁免名单中
   * @param entry 通知实体
   * @param isSecureAndLocked 是否锁屏加锁状态
   * @param isAppLocked 应用是否添加应用锁
   * @returns boolean
   */
  public static IsNtfNeedLock(entry: NotificationEntry, isSecureAndLocked: boolean, isAppLocked: boolean): boolean {
    if (entry.isLiveType()) {
      log.showInfo(`setEntryHideContent, sysTypeCode: ${entry.getSysTypeCode()}`);
      // 豁免应用不处理加锁状态，置为false；非豁免应用加锁状态取决于加锁和是否
      isAppLocked = CcmConfigHelper.getInstance().isExemptLiveNtf(entry.creatorBundleName, entry.getSysTypeCode()) ?
        false : isAppLocked && isSecureAndLocked;
    } else {
      isAppLocked =
        CcmConfigHelper.getInstance().isExemptNormalNtf(entry.creatorBundleName ?? '') ? false : isAppLocked;
    }
    return isAppLocked;
  }
}