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

const TAG = 'SystemSwitchUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 系统开关工具类
 */
export class SystemSwitchUtils {
  private static sIsNewScreenLock: boolean = false;

  private constructor() {
  }

  /**
   * 设置使用重构后的锁屏逻辑
   */
  public static setUseNewScreenLock(): void {
    log.showWarn('setUseNewScreenLock');
    SystemSwitchUtils.sIsNewScreenLock = true;
  }

  /**
   * 获取是否使用重构后的锁屏逻辑
   */
  public static isUseNewScreenLock(): boolean {
    return SystemSwitchUtils.sIsNewScreenLock;
  }
}