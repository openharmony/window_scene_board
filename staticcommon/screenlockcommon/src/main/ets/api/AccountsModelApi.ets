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
import { SystemSwitchUtils } from '../utils/SystemSwitchUtils';
import { AccountHelper } from '../utils/AccountHelper';

const TAG = 'AccountsModelApi';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

class AccountsModelApi {
  private static instance: AccountsModelApi;
  private getCurrentUserIdCallback: Function | undefined;
  private updateCurrentUserIdCallback: Function | undefined;

  public static getInstance(): AccountsModelApi {
    if (!AccountsModelApi.instance) {
      AccountsModelApi.instance = new AccountsModelApi();
    }
    return AccountsModelApi.instance;
  }

  public initAccountsModelCallback(getCurrentUserIdCallback: Function, updateCurrentUserIdCallback: Function): void {
    this.getCurrentUserIdCallback = getCurrentUserIdCallback;
    this.updateCurrentUserIdCallback = updateCurrentUserIdCallback;
  }

  public clearAccountsModelCallback(): void {
    this.getCurrentUserIdCallback = undefined;
    this.updateCurrentUserIdCallback = undefined;
  }

  public getCurrentUserId(): number {
    if (SystemSwitchUtils.isUseNewScreenLock()) {
      return AccountHelper.getInstance().currentLocalId;
    } else {
      if (!this.getCurrentUserIdCallback) {
        log.showError(`getCurrentUserId getCurrentUserIdCallback undefined`);
        return AccountHelper.getInstance().currentLocalId;
      }
      return this.getCurrentUserIdCallback?.();
    }
  }

  public async updateCurrentUserId(): Promise<number> {
    if (!this.updateCurrentUserIdCallback) {
      log.showError(`updateCurrentUserId updateCurrentUserIdCallback undefined`);
      return AccountHelper.getInstance().currentLocalId;
    }
    return await this.updateCurrentUserIdCallback?.();
  }
}

let accountsModelApi: AccountsModelApi = AccountsModelApi.getInstance();
export default accountsModelApi as AccountsModelApi;