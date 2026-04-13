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
import base from '@ohos.base';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import commonEventManager from '@ohos.commonEventManager';
import type { CommonEventSubscribeInfo } from 'commonEvent/commonEventSubscribeInfo';
import CommonEventConstants from '../constants/CommonEventConstants';
import { UserSwitchListener, UserSwitchService } from '../services/UserSwitchService';
import { AccountHelper, SwitchEventData } from '../utils/AccountHelper';
import { SystemSwitchUtils } from '../utils/SystemSwitchUtils';

const TAG = 'CommonEventMonitor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 公共事件订阅的封装类
 */
class CommonEventInfo {
  public describe: string;
  public subscribeInfo: CommonEventSubscribeInfo;
  public callback: Function = () => {
  };

  public setCallback(callback: Function): void {
    this.callback = callback;
  }

  constructor(describe: string, subscribeInfo: CommonEventSubscribeInfo) {
    this.describe = describe;
    this.subscribeInfo = subscribeInfo;
  }
}

/**
 * 公共事件管理类
 *
 * @since 2024-03-22
 */
class CommonEventMonitor {
  private static instance: CommonEventMonitor;
  private subscriberMap: Map<string, commonEventManager.CommonEventSubscriber> = new Map();

  /**
   * 凭证公共事件订阅类
   */
  public credentialCommonEvent: CommonEventInfo =
    new CommonEventInfo('credential', CommonEventConstants.CREDENTIAL_SUBSCRIBE_INFO);
  /**
   * 主题公共事件订阅类
   */
  public themeCommonEvent: CommonEventInfo = new CommonEventInfo('theme', CommonEventConstants.THEME_SUBSCRIBE_INFO);
  /**
   * 锁屏公共事件订阅类
   */
  public screenLockCommonEvent: CommonEventInfo = new CommonEventInfo('screenlock', CommonEventConstants.SCREENLOCK_SUBSCRIBE_INFO);

  /**
   * 用户更新公共事件订阅类
   */
  public userUpdateCommonEvent: CommonEventInfo =
    new CommonEventInfo('userUpdate', CommonEventConstants.USER_SUBSCRIBE_INFO);

  public pkgChangeCommonEvent: CommonEventInfo =
    new CommonEventInfo('pkgChange', CommonEventConstants.PKGCHANGE_SUBSCRIBE_INFO);

  private registerObserverCallback: Function | undefined;
  private unRegisterObserverCallback: Function | undefined;

  private userSwitchListener: UserSwitchListener = {
    onSwitched: (switchEventData: SwitchEventData): void => {
      const mCurrentId = AccountHelper.getInstance().currentLocalId;
      log.showInfo(`onSwitched currentUserId: ${mCurrentId}, toAccountId: ${switchEventData.toAccountId}`);
      this.userSwitched(mCurrentId === switchEventData.toAccountId);
    }
  };

  private userSwitched(isCurrent: boolean): void {
    if (isCurrent) {
      this.createSubscriber(this.credentialCommonEvent);
      this.createSubscriber(this.themeCommonEvent);
      this.createSubscriber(this.screenLockCommonEvent);
    } else {
      this.unRegisterCredentialSubscriber();
      this.unRegisterThemeSubscriber();
      this.unRegisterScreenLockSubscriber();
    }
  }

  init(): void {
    if (SystemSwitchUtils.isUseNewScreenLock()) {
      UserSwitchService.getInstance().registerObserver(this.userSwitchListener);
    } else {
      if (this.registerObserverCallback) {
        this.registerObserverCallback?.((isCurrent: boolean) => {
          this.userSwitched(isCurrent);
        });
      } else {
        log.showError('init registerObserverCallback undefined');
      }
    }
  }

  destroy(): void {
    if (SystemSwitchUtils.isUseNewScreenLock()) {
      UserSwitchService.getInstance().unRegisterObserver(this.userSwitchListener);
    } else {
      if (this.unRegisterObserverCallback) {
        this.unRegisterObserverCallback?.();
      } else {
        log.showError('destroy unRegisterObserverCallback undefined');
      }
    }
  }

  public initCallback(registerObserverCallback: Function, unRegisterObserverCallback: Function): void {
    log.showInfo(`initCallback`);
    this.registerObserverCallback = registerObserverCallback;
    this.unRegisterObserverCallback = unRegisterObserverCallback;
  }

  public clearCallback(): void {
    log.showInfo(`clearCallback`);
    this.registerObserverCallback = undefined;
    this.unRegisterObserverCallback = undefined;
  }

  /**
   * 订阅公共事件
   * @param commonEventInfo 公共事件信息
   * @param subscribeCallback 事件订阅回调
   */
  private createSubscriber(commonEventInfo: CommonEventInfo): void {
    commonEventManager.createSubscriber(commonEventInfo.subscribeInfo, (err, commonEventSubscriber) => {
      if (err) {
        log.showError(`Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
        return;
      }
      if (CheckEmptyUtils.isEmpty(commonEventSubscriber)) {
        log.showInfo('Failed to subscribe to common event. subscriber is undefined.');
        return;
      }
      this.subscriberMap.set(commonEventInfo.describe, commonEventSubscriber);
      log.showInfo(`Succeeded in create ${commonEventInfo.describe} subscriber, subscriberMap size: ${this.subscriberMap.size}`);
      commonEventManager.subscribe(commonEventSubscriber, (err: base.BusinessError,
        eventData: commonEventManager.CommonEventData): void => {
        if (err) {
          log.showInfo(`Failed to recive commoneEvent ${eventData?.event}. Code is ${err.code}, message is ${err.message}`);
          return;
        }
        if (CheckEmptyUtils.isEmpty(eventData?.parameters)) {
          log.showError('Event parameters is empty');
          return;
        }
        if (!commonEventInfo.subscribeInfo.events.includes(eventData?.event)) {
          log.showInfo(`Event is not include`);
          return;
        }
        log.showInfo(`Receive commoneEvent: ${eventData?.event}`);
        if (commonEventInfo.callback) {
          commonEventInfo.callback(eventData);
        }
      });
    });
  }

  /**
   * 取消订阅公共事件
   * @param commonEventInfo 公共事件信息
   */
  private unSubscribe(commonEventInfo: CommonEventInfo): void {
    if (!this.subscriberMap.get(commonEventInfo.describe)) {
      log.showInfo('can not get Subscriber');
      return;
    }
    log.showInfo(`unSubscribe commonEvent: ${commonEventInfo.describe}`);
    commonEventManager.unsubscribe(this.subscriberMap.get(commonEventInfo.describe), (): void => {
      log.showInfo('destroySubscriber end');
    });
    this.subscriberMap.delete(commonEventInfo.describe);
  }

  /**
   * notification state manager instance
   */
  public static getInstance(): CommonEventMonitor {
    if (!CommonEventMonitor.instance) {
      CommonEventMonitor.instance = new CommonEventMonitor();
    }
    return CommonEventMonitor.instance;
  }

  /**
   * 订阅凭证公共事件
   */
  public registerCredentialSubscriber(callback: Function): void {
    this.credentialCommonEvent.setCallback(callback);
    this.createSubscriber(this.credentialCommonEvent);
  }

  /**
   * 订阅主题公共事件
   */
  public registerThemeSubscriber(callback: Function): void {
    this.themeCommonEvent.setCallback(callback);
    this.createSubscriber(this.themeCommonEvent);
  }

  /**
   * 订阅锁屏公共事件
   */
  public registerScreenLockSubscriber(callback: Function): void {
    this.screenLockCommonEvent.setCallback(callback);
    this.createSubscriber(this.screenLockCommonEvent);
  }

  /**
   * 订阅用户更新公共事件
   */
  public registerUserUpdateSubscriber(callback: Function): void {
    this.userUpdateCommonEvent.setCallback(callback);
    this.createSubscriber(this.userUpdateCommonEvent);
  }

  public registerPkgSubscriber(callback: Function): void {
    this.pkgChangeCommonEvent.setCallback(callback);
    this.createSubscriber(this.pkgChangeCommonEvent);
  }

  /**
   * 取消订阅凭证公共事件
   */
  public unRegisterCredentialSubscriber(): void {
    this.unSubscribe(this.credentialCommonEvent);
  }

  /**
   * 取消订阅主题公共事件
   */
  public unRegisterThemeSubscriber(): void {
    this.unSubscribe(this.themeCommonEvent);
  }

  /**
   * 取消锁屏主题公共事件
   */
  public unRegisterScreenLockSubscriber(): void {
    this.unSubscribe(this.screenLockCommonEvent);
  }

  /**
   * 取消订阅用户更新公共事件
   */
  public unRegisterUserUpdateSubscriber(): void {
    this.unSubscribe(this.userUpdateCommonEvent);
  }

  public unRegisterPkgChangeSubscriber(): void {
    this.unSubscribe(this.pkgChangeCommonEvent);
  }
}

let commonEventMonitor: CommonEventMonitor = CommonEventMonitor.getInstance();

export default commonEventMonitor as CommonEventMonitor;