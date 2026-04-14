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

import { ThreadUtil } from '@ohos/basicutils/src/main/ets/utils/ThreadUtil';
import lazy { ScreenStatusVm } from '@ohos/systemuicommon/src/main/ets/vm/ScreenStatusVm';
import lazy { EnvVm } from '@ohos/systemuicommon/src/main/ets/vm/EnvVm';
import lazy { ScreenLockExtApi } from '@ohos/screenlockcommon/src/main/ets/api/ScreenLockExtApi';
import lazy { SystemSwitchUtils } from '@ohos/screenlockcommon/src/main/ets/utils/SystemSwitchUtils';

export class ScreenLockApiAdapter {

  /**
   * 获取是否使用重构后的锁屏逻辑
   */
  public static isUseNewScreenLock(): boolean | undefined {
    if (ThreadUtil.isMainThread) {
      return SystemSwitchUtils.isUseNewScreenLock();
    } else {
      return ScreenStatusVm.instance.isUseNewScreenLock;
    }
  }

  /**
   * 获取锁屏页面是否显示
   */
  public static isScreenLockShow(): boolean {
    if (ThreadUtil.isMainThread) {
      return ScreenLockExtApi.isLocked();
    } else {
      return EnvVm.instance.isScreenLock;
    }
  }

  /**
   * 检查设备当前是否处于锁定状态，并且屏幕锁需要身份进行身份验证和解锁。
   */
  public static isDeviceLocked(): boolean {
    if (ThreadUtil.isMainThread) {
      return ScreenLockExtApi.isDeviceLocked();
    } else {
      return EnvVm.instance.isSecureAndLocked;
    }
  }
}