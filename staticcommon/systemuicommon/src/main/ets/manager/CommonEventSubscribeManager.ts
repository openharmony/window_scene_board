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
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ThemeActiveEvent } from '../event/ThemeActiveEvent';
import { InnerEventUtil } from '../utils/InnerEventUtil';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'CommonEventSubscribeManager');

export class CommonEventSubscribeManager {
  /**
   * 隐藏下拉面板事件
   */
  public static readonly HIDE_DROPDOWN_PANEL_COMMON_EVENT: commonEventManager.CommonEventSubscribeInfo = {
    events: ['sceneboard.event.HIDE_DROPDOWN_WINDOW'],
    publisherPermission: 'ohos.permission.SUBSCRIBE_NOTIFICATION_WINDOW_STATE'
  };

  /**
   * 静音按键公共事件
   */
  public static readonly KEY_PRESS_COMMON_EVENT: commonEventManager.CommonEventSubscribeInfo = {
    events: ['multimodal.event.MUTE_KEY_PRESS'],
    publisherPermission: 'ohos.permission.MANAGE_LOCAL_ACCOUNTS',
  };

  /**
   * Push HA地址共享事件
   */
  public static readonly PUSH_AGENT_EVENT: commonEventManager.CommonEventSubscribeInfo = {
    events: ['push.event.PUSH_AGENT'],
    publisherPermission: 'ohos.permission.NOTIFICATION_AGENT_CONTROLLER',
  };

  /**
   * 第三方应用延迟安装事件. 系统公共事件
   */
  public static readonly COMMON_EVENT_RESTORE_START: commonEventManager.CommonEventSubscribeInfo = {
    events: ['usual.event.RESTORE_START']
  };

  private static INSTANCE?: CommonEventSubscribeManager;

  private subListenerMapping: Map<commonEventManager.CommonEventSubscribeInfo, Subscriber> = new Map();

  private constructor() {
    this.subscribe({
      events: [ThemeActiveEvent.EVENT_NAME],
      publisherPermission: ThemeActiveEvent.PERMISSION,
    }, (events) => {
      InnerEventUtil.post(ThemeActiveEvent, new ThemeActiveEvent(events));
    });
  }

  public static getInstance(): CommonEventSubscribeManager {
    if (CommonEventSubscribeManager.INSTANCE) {
      return CommonEventSubscribeManager.INSTANCE;
    } else {
      CommonEventSubscribeManager.INSTANCE = new CommonEventSubscribeManager();
      return CommonEventSubscribeManager.INSTANCE;
    }
  }

  public async subscribe(event: commonEventManager.CommonEventSubscribeInfo,
    listener: CommonEventListener): Promise<void> {
    this.getOrCreateSubscriber(event).subscribe(listener);
  }

  public unsubscribe(event: commonEventManager.CommonEventSubscribeInfo, listener: CommonEventListener): void {
    this.subListenerMapping.get(event)?.unsubscribe(listener);
  }

  private getOrCreateSubscriber(subInfo: commonEventManager.CommonEventSubscribeInfo): Subscriber {
    let subscriber = this.subListenerMapping.get(subInfo);
    if (!subscriber) {
      subscriber = new Subscriber(subInfo);
      this.subListenerMapping.set(subInfo, subscriber);
    }
    return subscriber;
  }
}

class Subscriber {
  private subInfo: commonEventManager.CommonEventSubscribeInfo;

  private listeners: Set<CommonEventListener> = new Set();

  private subscriber: commonEventManager.CommonEventSubscriber;

  private promise?: Promise<void>;

  constructor(subInfo: commonEventManager.CommonEventSubscribeInfo) {
    this.subInfo = subInfo;
  }

  public async subscribe(listener: CommonEventListener): Promise<void> {
    this.listeners.add(listener);
    if (this.subscriber) {
      return;
    }

    if (this.promise) {
      await this.promise;
    } else {
      this.promise = this.doSubscribe();
    }
  }

  private async doSubscribe(): Promise<void> {
    try {
      this.subscriber = await commonEventManager.createSubscriber(this.subInfo);
      commonEventManager.subscribe(this.subscriber, (err: BusinessError, event: commonEventManager.CommonEventData) => {
        if (err) {
          log.showError('DoSubscribe error. {%{public}d - %{public}s}', err.code, err.message);
        } else {
          this.onSuccReceiveEvent(event);
        }
      });
    } catch (e) {
      this.subscriber = undefined;
      log.error(`DoSubscribe ${this.subInfo.events} error.`, e);
    }
  }

  private onSuccReceiveEvent(data: commonEventManager.CommonEventData): void {
    log.showInfo('Succeed receive %{public}s listener size %{public}d', data.event, this.listeners.size);
    for (let listener of this.listeners) {
      try {
        listener(data);
      } catch (e) {
        log.error(`Handle ${data.event} error`, e);
      }
    }
  }

  unsubscribe(listener: CommonEventListener): void {
    const result = this.listeners.delete(listener);
    log.showWarn('UnSubscribe listener not exists');
    if (result && this.listeners.size === 0) {
      commonEventManager.unsubscribe(this.subscriber);
    }
  }
}

export type CommonEventListener = (data: commonEventManager.CommonEventData) => void;