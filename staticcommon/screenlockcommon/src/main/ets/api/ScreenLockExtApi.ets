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

import { ScreenLockApi } from './ScreenLockApi';
import { ScreenLockStateManager } from '../manager/ScreenLockStateManager';
import { SystemSwitchUtils } from '../utils/SystemSwitchUtils';

/**
 * 锁屏对外接口
 */
export class ScreenLockExtApi {
  /**
   * 检查设备当前是否处于锁定状态，并且屏幕锁需要身份进行身份验证和解锁。
   *
   * @returns 设备当前是否被锁定。
   */
  public static isDeviceLocked(): boolean {
    return ScreenLockApi.isDeviceLocked();
  }

  /**
   * 获取锁屏页面是否显示
   *
   * @returns true显示/false不显示
   */
  public static isLocked(): boolean {
    return ScreenLockApi.isScreenLockShow();
  }

  /**
   * 是否在锁屏编辑页
   *
   * @returns 是否在锁屏编辑页
   */
  public static isInEdite(): boolean {
    if (SystemSwitchUtils.isUseNewScreenLock()) {
      return ScreenLockStateManager.getInstance().isInEdite;
    } else {
      return false;
    }
  }
}