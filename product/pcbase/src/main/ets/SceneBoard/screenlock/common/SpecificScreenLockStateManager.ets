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
import osAccount from '@ohos.account.osAccount';

const TAG = 'ScreenLock-SpecificScreenLockStateManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class SpecificScreenLockStateManager {
  private static isAuthResponded: boolean = true;
  private static authRespondedTimeout: number | null = null;
  private static readonly timeoutDelay: number = 2000;

  private static isNotifyLockScreen: boolean = false;

  public static setIsAuthResponded(state: boolean, authType: osAccount.AuthType): void {
    if (authType === osAccount.AuthType.PIN || authType === osAccount.AuthType.DOMAIN) {
      log.info(`setIsAuthResponsed state: ${state}`);
      SpecificScreenLockStateManager.isAuthResponded = state;
      // 如果设置为false了，有一个保底恢复的方法
      if (!state) {
        SpecificScreenLockStateManager.resetIsAuthResponded();
      }
    }
  }

  public static getIsAuthResponded(): boolean {
    log.info(`getIsAuthResponsed state: ${SpecificScreenLockStateManager.isAuthResponded}`);
    return SpecificScreenLockStateManager.isAuthResponded;
  }

  private static resetIsAuthResponded(): void {
    if (SpecificScreenLockStateManager.authRespondedTimeout) {
      log.info(`clearAuthRespondedTimeout`);
      clearTimeout(SpecificScreenLockStateManager.authRespondedTimeout);
    }
    SpecificScreenLockStateManager.authRespondedTimeout = setTimeout(() => {
      log.info(`resetIsAuthResponded`);
      SpecificScreenLockStateManager.authRespondedTimeout = null;
      SpecificScreenLockStateManager.setIsAuthResponded(true, osAccount.AuthType.PIN);
    }, SpecificScreenLockStateManager.timeoutDelay);
  }

  public static setIsNotifyLockScreen(state: boolean): void {
    log.info(`setIsNotifyLockScreen state: ${state}`);
    SpecificScreenLockStateManager.isNotifyLockScreen = state;
  }

  public static getIsNotifyLockScreen(): boolean {
    log.info(`getIsNotifyLockScreen state: ${SpecificScreenLockStateManager.isNotifyLockScreen}`);
    return SpecificScreenLockStateManager.isNotifyLockScreen;
  }

  public static resetIsNotifyLockScreen(): void {
    log.info('resetIsNotifyLockScreen');
    SpecificScreenLockStateManager.isNotifyLockScreen = false;
  }

}
