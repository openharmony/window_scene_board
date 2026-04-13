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

import { BusinessError, commonEventManager, distributedAccount } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import Constants from './Constants';

const TAG = 'AccountManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);


export class AccountManager {
  //订阅者信息
  private static subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: [commonEventManager.Support.COMMON_EVENT_DISTRIBUTED_ACCOUNT_LOGIN,
      commonEventManager.Support.COMMON_EVENT_DISTRIBUTED_ACCOUNT_LOGOUT]
  };
  private static subscriber: commonEventManager.CommonEventSubscriber;
  private static callback: Callback<number>;

  public static getAccountState(callback: Callback<number>): void {
    try {
      const accountAbility: distributedAccount.DistributedAccountAbility =
        distributedAccount.getDistributedAccountAbility();
      log.info(TAG, 'start get account state');
      accountAbility.getOsAccountDistributedInfo(
        (err: BusinessError, data: distributedAccount.DistributedInfo) => {
          if (err) {
            log.error('getOsAccountDistributedInfo exception: ' + JSON.stringify(err));
            return;
          }
          log.info(`Succeeded in getting account state: ${data.status}`);
          if (data.status === Constants.LOGIN) {
            callback(Constants.LOGIN);
          } else {
            callback(Constants.LOGOUT);
          }
        });
    } catch (err) {
      log.error('getOsAccountDistributedInfo exception: ' + JSON.stringify(err));
    }
  }

  public static createAccountStateSubscriber(err: BusinessError,
    commonEventSubscriber: commonEventManager.CommonEventSubscriber): void {
    if (!err) {
      log.showInfo(`createAccountStateSubscriber`);
      AccountManager.subscriber = commonEventSubscriber;
      // 订阅公共事件
      try {
        commonEventManager.subscribe(AccountManager.subscriber, AccountManager.subscriberEvent);
      } catch (error) {
        let err: BusinessError = error as BusinessError;
        log.error(TAG, `subscribe account state failed, code is ${err.code}, message is ${err.message}`);
      }
    } else {
      log.error(TAG, `createAccountStateSubscriber failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  public static subscriberEvent(err: BusinessError, data: commonEventManager.CommonEventData): void {
    if (err) {
      log.error(TAG, `subscribe account state failed, code is ${err.code}, message is ${err.message}`);
    } else {
      if (data.event === commonEventManager.Support.COMMON_EVENT_DISTRIBUTED_ACCOUNT_LOGIN) {
        // 订阅到账号登录事件
        log.info(TAG, `the account state is changed:${Constants.LOGIN}`);
        AccountManager.callback(Constants.LOGIN);
      }
      if (data.event === commonEventManager.Support.COMMON_EVENT_DISTRIBUTED_ACCOUNT_LOGOUT) {
        // 订阅到账号登出事件
        log.info(TAG, `the account state is changed:${Constants.LOGOUT}`);
        AccountManager.callback(Constants.LOGOUT);
      }
    }
  }

  public static subscribeAccountStateChange(callback: Callback<number>): void {
    //创建订阅者
    AccountManager.callback = callback;

    try {
      commonEventManager.createSubscriber(AccountManager.subscribeInfo, AccountManager.createAccountStateSubscriber);
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      log.error(TAG, `createAccountStateSubscriber failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  public static unsubscribeAccountStateChange(): void {
    try {
      if (AccountManager.subscriber != undefined) {
        AccountManager.unsubscribeAccount();
      }
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      log.error(TAG, `unsubscribe account state failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  private static unsubscribeAccount(): void {
    commonEventManager.unsubscribe(AccountManager.subscriber, (err: BusinessError) => {
      if (err) {
        log.error(TAG, `unsubscribe account state failed, code is ${err.code}, message is ${err.message}`);
      } else {
        log.info(TAG, 'unsubscribe account state, success');
      }
    })
  }
}