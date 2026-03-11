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

import Account from '@ohos.account.osAccount';
import { AccountEvent, AccountSwitchEvent } from '../eventbus/events/Events';
import { EvtBus } from '../eventbus/EventBus';
import CommonEventManager from '@ohos.commonEventManager';
import type { CommonEventSubscriber } from 'commonEvent/commonEventSubscriber';
import {
  SingletonHelper,
  CommonUtils,
  ArrayUtils,
  LogDomain,
  LogHelper,
  CheckEmptyUtils,
} from '@ohos/basicutils';
import { BusinessError } from '@ohos.base';

const TAG = 'SysUI_AccountManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 延时初始化，确保有有效账号
 */
const DELAY_INIT_DURATION = 5000;

/**
 * account信息等待
 */
type AccountResolve = (accountInfo: Account.OsAccountInfo | PromiseLike<Account.OsAccountInfo>) => void;

/**
 * 常量
 */
export class AccountConstants {
  /**
   * 无效用户id
   */
  static readonly INVALID_ID: number = -1;
}

/**
 * 多用户管理
 *
 * @since 2022-10-06
 */
class AccountManager {
  /**
   * 多用户管理器
   */
  private accountMgr: Account.AccountManager = Account.getAccountManager();

  /**
   * 当前用户信息事件
   */
  private currentAccountInfo: AccountEvent = new AccountEvent();

  /**
   * 等待集
   */
  private accountResolves: Set<AccountResolve> | null = new Set();

  /**
   * 主用户
   */
  private adminAccountInfo?: Account.OsAccountInfo;

  /**
   * 延时任务id
   */
  private delayInitAccount?: number | null;

  /**
   * 账号SA启动事件subscriber
   */
  private subscriber?: CommonEventSubscriber | null;

  /**
   * 进程初始化时的accountId
   */
  private initAccountId?: number;
  /**
   * 初始化
   */
  init(): void {
  // 生产者
  EvtBus.produceOn(AccountEvent, (): AccountEvent | null => {
    if (CommonUtils.isInvalid(this.currentAccountInfo?.accountInfo)) {
      return null;
    }
    return this.currentAccountInfo;
  });
    // 生产者
    EvtBus.produceOn(AccountSwitchEvent, (): AccountSwitchEvent => {
      if (CommonUtils.isInvalid(this.currentAccountInfo?.accountInfo)) {
        return { currentUserId: undefined };
      }
      return { currentUserId: this.currentAccountInfo.accountInfo?.localId };
    });
    log.showInfo('init start on activate');
  // 开机阶段，账号服务概率不回调activate
  this.delayInitAccount = setTimeout(() => {
    this.initActivateAccount();
  }, DELAY_INIT_DURATION);
  // 初始化活跃用户
  this.initActivateAccount();
  this.subscribeUserSwitched();
  }

  /**
   * 去初始化
   */
  unInit(): void {
    if (this.subscriber) {
      try {
        CommonEventManager.unsubscribe(this.subscriber);
      } catch (error) {
        log.error('unInit unsubscribe try error', error);
      }
      this.subscriber = null;
    }
  }

  /**
   * 获取当前用户信息
   *
   * return 当前活跃用户
   */
  async getCurrentAccountInfo(): Promise<Account.OsAccountInfo> {
    if (this.currentAccountInfo?.accountInfo) {
      if (CheckEmptyUtils.isEmpty(this.initAccountId)) {
        this.initAccountId = this.currentAccountInfo?.accountInfo?.localId ?? AccountConstants.INVALID_ID;
      }
      return this.currentAccountInfo?.accountInfo;
    }
    return new Promise((resolve) => {
      this.accountResolves?.add(resolve);
    });
  }

  /**
   * 获取当前用户id
   *
   * @return 当前活跃用户id
   */
  async getCurrentAccountId(): Promise<number> {
    return new Promise((resolve) => {
      this.getCurrentAccountInfo()
        .then((accountInfo) => resolve(accountInfo?.localId ?? AccountConstants.INVALID_ID));
    });
  }

  /**
   * 获取进程初始化用户ID
   */
  async getInitAccountId(): Promise<number> {
    return new Promise((resolve) => {
      this.getCurrentAccountInfo().then(() => {
        resolve(this.initAccountId ?? AccountConstants.INVALID_ID);
      });
    })
  }

  /**
   * 判断主用户id
   *
   * @param accountId 用户id
   * @return true主用户id
   */
  isAdminAccount(accountId: number): boolean {
    return accountId === this.adminAccountInfo?.localId;
  }

  /**
   * 是否为无效用户
   *
   * @param accountId 用户id
   * @return true无效用户
   */
  isInvalidAccount(accountId: number | undefined): boolean {
    if (accountId == null || accountId === undefined) {
      return true;
    }
    return accountId === AccountConstants.INVALID_ID;
  }

  /**
   * 初始化活跃用户
   */
  private initActivateAccount(): void {
    this.accountMgr.queryAllCreatedOsAccounts().then(async (accountInfos) => {
      let currentInfo: Account.OsAccountInfo | null = null;
      // 当前进程所属用户
      let nowLocalId = await this.accountMgr.getOsAccountLocalId();
      if (CheckEmptyUtils.isEmpty(this.initAccountId) && !CommonUtils.isInvalid(nowLocalId)) {
        this.initAccountId = nowLocalId;
      }
      for (let info of accountInfos) {
        if (info.localId === nowLocalId) {
          currentInfo = info;
        }
        // 主用户
        if (info.type === Account.OsAccountType.ADMIN) {
          this.adminAccountInfo = info;
        }
        // 均找到
        if (!CommonUtils.isInvalid(this.currentAccountInfo?.accountInfo) &&
          !CommonUtils.isInvalid(this.adminAccountInfo)) {
          break;
        }
      }
      log.showInfo('initActivateAccount current , localId:%{public}d', currentInfo?.localId);
      // 发送事件
      if (currentInfo !== null && !CommonUtils.isInvalid(currentInfo)) {
        this.clearDelayRunnable();
        this.resolveAccountInfo(currentInfo);
        if (currentInfo && this.currentAccountInfo && this.currentAccountInfo?.accountInfo?.localId !== currentInfo?.localId) {
          this.currentAccountInfo.accountInfo = currentInfo;
          this.postAccountEvent();
        }
      }
    }).catch((err: Error) => {
      log.error(`queryAllCreatedOsAccounts Error:${err}`);
      clearTimeout(this.delayInitAccount);
      this.delayInitAccount = setTimeout(() => {
        this.initActivateAccount();
      }, DELAY_INIT_DURATION);
    });
  }

  /**
   * 用户切换处理
   *
   * @param currentActivateId 切换后活跃用户id
   */
  private handleAccountActivateChange(currentActivateId: number): void {
    log.showInfo('handleAccountActivateChange:%{public}s', currentActivateId);
    this.accountMgr
      .queryOsAccountById(currentActivateId)
      .then((accountInfo) => {
        // 发送用户切换事件
        this.clearDelayRunnable();
        this.resolveAccountInfo(accountInfo);
        if (this.currentAccountInfo && this.currentAccountInfo?.accountInfo?.localId !== accountInfo.localId) {
          this.currentAccountInfo.accountInfo = accountInfo;
          this.postAccountEvent();
        }
      })
      .catch((err: BusinessError) => {
        log.error('handleAccountActivateChange query account err, id: ', currentActivateId);
      });
  }

  /**
   * 发送事件
   */
  private postAccountEvent(): void {
    EvtBus.post(AccountEvent, this.currentAccountInfo);
    log.showInfo('postAccountEvent current id:%{public}s ', this.currentAccountInfo?.accountInfo?.localId);
  }

  /**
   * 等待回调
   *
   * @param currentAccount 当前account
   */
  private resolveAccountInfo(currentAccount: Account.OsAccountInfo): void {
  if (CommonUtils.isInvalid(currentAccount)) {
    return;
  }
    log.showInfo(`resolveAccountInfo ${currentAccount?.localId}`);
  AppStorage.setOrCreate('accountSAReady', true);
  if (ArrayUtils.isEmpty(this.accountResolves)) {
    return;
  }
  this.accountResolves?.forEach((resolve) => {
    if (CheckEmptyUtils.isEmpty(this.initAccountId)) {
      this.initAccountId = currentAccount?.localId ?? AccountConstants.INVALID_ID;
    }
    resolve(currentAccount);
  });
  this.accountResolves?.clear();
  this.accountResolves = null;
  }

  /**
   * 清除任务
   */
  private clearDelayRunnable(): void {
    if (CommonUtils.isInvalid(this.delayInitAccount)) {
      return;
    }
    clearTimeout(this.delayInitAccount);
    this.delayInitAccount = null;
  }

  /**
   * 订阅用户切换事件
   */
  private subscribeUserSwitched(): void {
    const subscribeInfo: CommonEventManager.CommonEventSubscribeInfo = {
      events: [CommonEventManager.Support.COMMON_EVENT_USER_SWITCHED],
    };
    try {
      CommonEventManager.createSubscriber(subscribeInfo).then((res) => {
        this.subscriber = res;
        try {
          CommonEventManager.subscribe(this.subscriber, (err, data) => {
            if (err && err.code !== 0) {
              log.error('subscribe callback err:', err);
              return;
            }
            log.showInfo('receive subscribe callback data.event:%{public}s', data.event);
            AppStorage.setOrCreate('accountSAReady', true);
            EvtBus.post(AccountSwitchEvent, { currentUserId: data.code });
          })
        } catch (err) {
          log.error('subscribe err:', err);
        }
      }).catch((error: BusinessError) => {
        log.error('createSubscriber error:', error);
      });
    } catch (error) {
      log.error('createSubscriber try error:', error);
    }
  }
}

// 单例
export let AccountMgr = SingletonHelper.getInstance(AccountManager, TAG);