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
import osAccount from '@ohos.account.osAccount';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG: string = 'EnterpriseSpaceIcon-ViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const accountManager: osAccount.AccountManager = osAccount.getAccountManager();

enum SpaceIdEnum {
  ENTERPRISE = 100,
  PERSONAL = 101
}

interface IEnterpriseSpaceIconContext {
  symbol: Resource;
}

export class EnterpriseSpaceSymbol {
  public static readonly ENTERPRISE: Resource = $r('sys.symbol.company_fill');
  public static readonly PERSON: Resource = $r('sys.symbol.person_fill');
}

export class EnterpriseSpaceIconVM {
  public context: IEnterpriseSpaceIconContext;
  public switchedEventHandler = (event: osAccount.OsAccountSwitchEventData): void => {
    log.showInfo('os account switched id');
    this.updateSymbol(event.toAccountId);
  };

  constructor(context: IEnterpriseSpaceIconContext) {
    this.context = context;
  }

  public async init(): Promise<void> {
    log.showInfo('init invoked');
    try {
      const currentUserId: number = await accountManager.getForegroundOsAccountLocalId();
      this.updateSymbol(currentUserId);
    } catch (err) {
      log.showError(`get current user id failed. Error ${err?.code} ${err?.message}`);
    }
    this.subscribeSwitchedEvent();
  }

  public clear(): void {
    this.context = {} as IEnterpriseSpaceIconContext;
    this.unsubscribeSwitchedEvent();
  }

  public updateSymbol(id: number): void {
    log.showInfo('updateSymbol invoked');
    let symbol: Resource = EnterpriseSpaceSymbol.PERSON;
    try {
      if (id === SpaceIdEnum.ENTERPRISE) {
        symbol = EnterpriseSpaceSymbol.ENTERPRISE;
      } else {
        symbol = EnterpriseSpaceSymbol.PERSON;
      }
    } catch (err) {
      log.showError(`getSymbol failed. error ${err?.code} ${err?.message}`);
    }
    if (this.context.symbol?.id !== symbol.id) {
      log.showInfo('update symbol');
      this.context.symbol = symbol;
    }
  }

  public subscribeSwitchedEvent(): void {
    log.showInfo('subscribeSwitchedEvent invoked');
    try {
      accountManager.on('switched', this.switchedEventHandler);
    } catch (err) {
      log.showError(`subscribeSwitchedEvent failed. Error ${err?.code} ${err?.message}`);
    }
  }

  public unsubscribeSwitchedEvent(): void {
    log.showInfo('unsubscribeSwitchedEvent invoked');
    try {
      accountManager.off('switched', this.switchedEventHandler);
    } catch (err) {
      log.showError(`unsubscribeSwitchedEvent failed. Error ${err?.code} ${err?.message}`);
    }
  }
}