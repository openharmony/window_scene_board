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

import type { Callback } from '@ohos.base';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import lazy { launcherAbilityManager } from '@ohos/launchercommon/src/main/ets/abilitymanager/LauncherAbilityManager';
import { threadCall, ThreadCallType } from '@ohos/systemuicommon/src/main/ets/messageChannel/ThreadCall';

const TAG = 'LauncherAbilityManagerAdapter';
const log = LogHelper.getLogHelper(LogDomain.CC, TAG);

interface InstalledAsyncCallback {
  bundleName: string;
  callback: Callback<boolean>;
}

interface RegisterLauncherAbilityChangeCallback {
  callback: (event: string, bundleName: string, userId: number) => void;
}

export class LauncherAbilityManagerAdapter {
  /**
   * 获取用户id
   */
  @threadCall(ThreadCallType.Sync)
  public static getUserId(): number {
    log.showInfo(`getUserId`);
    return launcherAbilityManager.getUserId();
  }

  @threadCall(ThreadCallType.RegisterOnce)
  public static isAbilityInstalledAsync(callback: InstalledAsyncCallback, tag: string): void {
    log.showInfo(`isAbilityInstalledAsync tag ${tag}`);
    launcherAbilityManager.
    isAbilityInstalledAsync(callback.bundleName, callback.callback);
  }

  @threadCall(ThreadCallType.Register)
  public static registerLauncherAbilityChangeListener(obj: RegisterLauncherAbilityChangeCallback, tag: string): void {
    log.showInfo(`registerSwitchMultiWindowModeCallback tag ${tag}`);
    launcherAbilityManager.
    registerLauncherAbilityChangeListener(obj.callback);
  }

  @threadCall(ThreadCallType.UnRegister)
  public static unregisterLauncherAbilityChangeListener(obj: RegisterLauncherAbilityChangeCallback, tag: string): void {
    log.showInfo(`unregisterLauncherAbilityChangeListener tag ${tag}`)
    launcherAbilityManager.
    unregisterLauncherAbilityChangeListener(obj.callback);
  }
}