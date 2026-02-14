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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBConstants, PowerStatus } from '@ohos/commonconstants';

const TAG = 'LocalEventManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * Local event management class
 * main duty:
 * 1.Registration and deregistration of event listeners
 * 2.distribution of events
 */
class LocalEventManager {
  private mEventListenerMap: Object = {};

  /**
   * Get the local event management class object
   *
   * @return Single instance of local event management class object
   */
  static getInstance(): LocalEventManager {
    if (globalThis.localEventManager == null) {
      globalThis.localEventManager = new LocalEventManager();
    }
    return globalThis.localEventManager;
  }

  /**
   * register listener
   *
   * @param listener
   * @param events
   */
  registerEventListener(listener, events: string[]): void {
    log.showDebug('registerEventListener events.length:%{public}s', events.length);
    if (listener != null && events != null) {
      for (let index = 0; index < events.length; index++) {
        const event: string = events[index];
        if (this.mEventListenerMap[event] === undefined) {
          this.mEventListenerMap[event] = new Array<any>();
        }
        if (this.mEventListenerMap[event].indexOf(listener) === SCBConstants.INVALID_VALUE) {
          this.mEventListenerMap[event].push(listener);
        }
      }
    }
  }

  /**
   * unregister listener
   *
   * @param listener
   */
  unregisterEventListener(listener): void {
    log.showDebug('unregisterEventListener event listener');
    for (const key in this.mEventListenerMap) {
      const listenerList: unknown[] = this.mEventListenerMap[key];
      const index: number = listenerList.indexOf(listener);
      if (index !== SCBConstants.INVALID_VALUE) {
        this.mEventListenerMap[key].splice(index, 1);
      }
    }
  }

  /**
   * Send local broadcasts synchronously
   *
   * @param event
   * @param params
   */
  sendLocalEvent(event, params?): void {
    if (AppStorage.get('powerStatus') === PowerStatus.SHUTDOWN ||
      AppStorage.get('powerStatus') === PowerStatus.REBOOT) {
      log.showDebug('sendLocalEvent shutting down or reboot, do not send event.');
      return;
    }

    log.showDebug('sendLocalEvent event:%{public}s', event);
    let listenerList = this.mEventListenerMap[event];
    if (listenerList !== undefined) {
      log.showDebug(`sendLocalEvent listenerList length: ${listenerList.length}`);
      for (let listener of listenerList) {
        listener.onReceiveEvent(event, params);
      }
    } else {
      log.showInfo('sendLocalEvent, send local event with no receiver');
    }
  }

  /**
   * Send local broadcast asynchronously
   *
   * @param event
   * @param params
   */
  async sendLocalEventAsync(event, params?): Promise<void> {
    this.sendLocalEvent(event, params);
  }

  /**
   * Send sticky local broadcast (async only)
   *
   * @param event
   * @param params
   */
  async sendLocalEventSticky(event, params): Promise<void> {
    if (AppStorage.get('powerStatus') === PowerStatus.SHUTDOWN ||
      AppStorage.get('powerStatus') === PowerStatus.REBOOT) {
      log.showDebug('sendLocalEvent shutting down or reboot, do not send event.');
      return;
    }

    log.showDebug(`sendLocalEventSticky, send local event sticky, event: ${event}`);
    this.sendLocalEvent(event, params);
  }
}

class DockInfo {
  public isVisible: boolean = false;
  public screenId: number = 0;
}

type ReceiveDockInfoEvent = (event: string, params: DockInfo) => void;

class DockInfoEventListener {
  public onReceiveEvent: ReceiveDockInfoEvent;
}

export const localEventManager = LocalEventManager.getInstance();

export type { DockInfo, ReceiveDockInfoEvent, DockInfoEventListener };