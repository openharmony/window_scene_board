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

import commonEventManager from '@ohos.commonEventManager';
import { AsyncCallback, BusinessError } from '@ohos.base';
import { LogDomain, Logger } from '@ohos/basicutils';

const TAG = 'ScreenOffObserver';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

export class ScreenOffObserver {
  private subscriber: commonEventManager.CommonEventSubscriber | undefined = undefined;
  private subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: [
      commonEventManager.Support.COMMON_EVENT_SCREEN_OFF,
      commonEventManager.Support.COMMON_EVENT_SCREEN_LOCKED,
      commonEventManager.Support.COMMON_EVENT_SCREEN_UNLOCKED
    ]
  };

  /**
   * 注册监听屏幕休眠和屏幕锁屏事件
   *
   * @param callback 监听回调
   */
  public register(callback: AsyncCallback<commonEventManager.CommonEventData>): void {
    if (!callback) {
      log.error(TAG, 'callback is undefined');
      return;
    }
    try {
      commonEventManager.createSubscriber(this.subscribeInfo).then(subscriber => {
        if (subscriber === undefined) {
          log.error(TAG, 'To subscribe, but subscriber is undefined');
          return;
        }
        this.subscriber = subscriber;
        try {
          commonEventManager.subscribe(this.subscriber, callback);
          log.info(TAG, 'subscribe success.');
        } catch (error) {
          log.error(TAG, `subscribe failed, code is ${error?.code}, message is ${error?.message}`);
        }
      }).catch((err: BusinessError) => {
        log.error(TAG, `createSubscriber failed, code is ${err?.code}, message is ${err?.message}`);
      });
    } catch (err) {
      log.error(TAG, `create subscriber failed, code = ${err?.code}, message is ${err?.message}`);
    }
  }

  /**
   * 解注册
   */
  public unregister() {
    if (this.subscriber === undefined) {
      log.error(TAG, 'To unsubscribe, but subscriber is undefined');
      return;
    }
    try {
      let subscriber = this.subscriber;
      commonEventManager.unsubscribe(subscriber, (err) => {
        if (err) {
          log.error(TAG, `unsubscribe failed, code is ${err.code}, message is ${err.message}`);
        } else {
          log.info(TAG, 'unsubscribe success.');
        }
      });
    } catch (error) {
      log.error(TAG, `unsubscribe failed, code is ${error?.code}, message is ${error?.message}`);
    }
  }
}