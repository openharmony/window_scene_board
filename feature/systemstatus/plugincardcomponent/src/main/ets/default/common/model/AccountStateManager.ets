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

import { AccountManager } from './AccountManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'AccountStateManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class AccountStateManager {
  private static instance?: AccountStateManager;
  private accountState: number = 0;

  public initState(): void {
    AccountManager.getAccountState((state: number) => this.onAccountStateChange(state));
  }

  /**
   * Get the instance of the SuperDeviceController class
   */
  static getInstance(): AccountStateManager {
    if (!AccountStateManager.instance) {
      AccountStateManager.instance = new AccountStateManager();
    }
    ;
    return AccountStateManager.instance;
  };


  public getAccountState(): void {
    AccountManager.getAccountState((state: number) => this.onAccountStateChange(state));
  }

  private subscribe(): void {
    AccountManager.subscribeAccountStateChange((state: number) => this.onAccountStateChange(state));
  }

  public unSubscribe(): void {
    AccountManager.unsubscribeAccountStateChange();
  }

  public isAccountStateReady(): boolean {
    let state: boolean = this.accountState === 1;
    log.info(TAG, `account is ready ? ${state}`);
    return state;
  }

  public onAccountStateChange(state: number): void {
    this.accountState = state;
    this.onSystemStateChanged();
  }

  public registerAccountStateListener(): void {
    this.subscribe();
    // 订阅时通知一次
    this.onSystemStateChanged();
  }

  public onSystemStateChanged(): void {
    log.info(`account state change: ${this.accountState}`);
    let isAccountReady: boolean = this.isAccountStateReady();
    AppStorage.setOrCreate<boolean>('isAccountReady', isAccountReady);
  }

  public unRegisterAccountStateListener(): void {
    this.unSubscribe();
  }
}