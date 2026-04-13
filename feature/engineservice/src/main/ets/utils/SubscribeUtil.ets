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

import lazy commonEventManager from '@ohos.commonEventManager';
import lazy { Log } from '../log/Log';

const TAG = 'SubscribeUtil';

/**
 * This module provides common event capabilities subscriber,
 * including the permission list of common events, publishing common events,
 * subscribing to or unsubscribing from common events, and obtaining common event result codes and result data.
 *
 * @since 2023-11-28
 */
export class SubscribeUtil {
  private subscriber?: commonEventManager.CommonEventSubscriber;
  private subscribeInfo: commonEventManager.CommonEventSubscribeInfo | undefined = {
    events: []
  };

  public constructor(events: string[] | undefined, permission?: string) {
    if (this.subscribeInfo && events) {
      this.subscribeInfo.events = [...this.subscribeInfo.events, ...events];
      if (permission) {
        this.subscribeInfo.publisherPermission = permission;
      }
    } else {
      this.subscribeInfo = events as undefined;
    }
  }

  /**
   * Create a System Public Event Subscriber.
   *
   * @return Promise Return an asynchronous function.
   * @throws Failed to create subscriber.
   */
  public initSubscriber(): Promise<void> {
    return new Promise((resolve, reject) => {
      try {
        commonEventManager.createSubscriber(this.subscribeInfo,
          (_, data: commonEventManager.CommonEventSubscriber) => {
            this.subscriber = data;
            resolve();
          });
      } catch (err) {
        Log.error(TAG, `Failed to create subscriber. Code is ${err?.code}, message is ${err?.message}`);
        reject();
      }
    });
  }

  /**
   * Subscribe to the specific Event.
   *
   * @param acceptInfo A function that needs to be triggered after the subscription information is obtained.
   */
  public eventSubscribe(acceptInfo: (eventData: commonEventManager.CommonEventData) => void): void {
    try {
      commonEventManager.subscribe(this.subscriber,
        (_, eventData: commonEventManager.CommonEventData) => {
          acceptInfo(eventData);
        })
    } catch (err) {
      Log.error(TAG, `Failed to create subscriber. Code is ${err?.code}, message is ${err?.message}`);
    }
  }

  /**
   * Conceal the specific Event Subscriber.
   */
  public concealSubscribe(): void {
    try {
      if (this.subscriber) {
        commonEventManager.unsubscribe(this.subscriber);
      }
    } catch (err) {
      Log.error(TAG, `Failed to concealSubscribe subscriber. Code is ${err?.code}, message is ${err?.message}`);
    }
  }
}