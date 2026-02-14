/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import CommonEvent from '@ohos.commonEvent';
import type { AsyncCallback } from '@ohos.base';
import type { CommonEventData } from 'commonEvent/commonEventData';
import type { CommonEventSubscriber } from 'commonEvent/commonEventSubscriber';

const TAG = 'WindowCommonEventManager';

/**
 * Wrapper class for CommonEvent.
 */
export class WindowCommonEventManager {
  readonly RECENT_FULL_SCREEN = 'CREATE_RECENT_WINDOW_EVENT';
  readonly TOUCH_PINCH_BEGIN_EVENT = 'TOUCH_PINCH_BEGIN_EVENT';
  readonly RECENT_SPLIT_SCREEN = 'common.event.SPLIT_SCREEN';
  readonly RECENT_UNLOCK_SCREEN = 'common.event.UNLOCK_SCREEN';
  readonly RECENT_LOCK_SCREEN = 'common.event.LOCK_SCREEN';
  readonly RECENT_REFRESH_EVENT = 'BOX_REFRESH_EVENT';
  readonly THREE_FINGER_SWIPER_BEGIN = 'THREE_FINGER_SWIPER_BEGIN';
  readonly FOUR_FINGER_SWIPER_BEGIN = 'FOUR_FINGER_SWIPER_BEGIN';

  private callbackList: AsyncCallback<CommonEventData>[] = [];
  private subscriberList: CommonEventSubscriber[] = [];

  /**
   * get WindowCommonEventManager instance
   *
   * @return WindowCommonEventManager singleton
   */
  static getInstance(): WindowCommonEventManager {
    if (globalThis.WindowCommonEventManager == null) {
      globalThis.WindowCommonEventManager = new WindowCommonEventManager();
    }
    return globalThis.WindowCommonEventManager;
  }

  private constructor() {
  }

  /**
   * Register common event listener.
   */
  public registerCommonEvent(subscriber: CommonEventSubscriber, eventCallback: AsyncCallback<CommonEventData>): void {
    if (this.subscriberList.indexOf(subscriber) !== -1) {
      return;
    }
    CommonEvent.subscribe(subscriber, eventCallback);
    this.subscriberList.push(subscriber);
    this.callbackList.push(eventCallback);
  }

  /**
   * Unregister common event listener.
   */
  public unregisterCommonEvent(subscriber: CommonEventSubscriber, eventCallback: AsyncCallback<CommonEventData>): void {
    const subscriberIndex: number = this.subscriberList.indexOf(subscriber);
    const callbackIndex: number = this.callbackList.indexOf(eventCallback);
    if (subscriberIndex !== -1) {
      CommonEvent.unsubscribe(subscriber);
      this.subscriberList.splice(subscriberIndex, 1);
    }
    callbackIndex !== -1 && this.callbackList.splice(callbackIndex, 1);
  }
}

export let windowCommonEventManager = WindowCommonEventManager.getInstance();

