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

import screenSessionManager from '@ohos.screenSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { sEventManager } from '@ohos/frameworkwrapper';
import { AbstractObserverManager, ObserverAble } from '../base/AbstractObserverManager';
import PerformanceMonitorUtil from '../record/report/PerformanceMonitorUtil';

const TAG = 'PowerStateManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const DISPLAY_POWER_EVENT_KEYS: string[] = ['WAKE_UP', 'SLEEP', 'DISPLAY_ON', 'DISPLAY_OFF', 'DESKTOP_READY'];
const EVENT_STATUS_KEYS: string[] = ['BEGIN', 'END'];
const DISPLAY_POWER_EVENT_CANCEL_SCREEN_OFF = 7;

interface PowerOriginNotice {
  displayPowerEvent: screenSessionManager.DisplayPowerEvent,
  eventStatus: screenSessionManager.EventStatus,
  reason: screenSessionManager.PowerStateChangeReason
}

/**
 * 电源状态
 */
export enum PowerState {
  BEGIN_WAKE_UP = 'BEGIN_WAKE_UP',
  END_WAKE_UP = 'END_WAKE_UP',
  BEGIN_SLEEP = 'BEGIN_SLEEP',
  END_SLEEP = 'END_SLEEP',
  BEGIN_DISPLAY_ON = 'BEGIN_DISPLAY_ON',
  END_DISPLAY_ON = 'END_DISPLAY_ON',
  BEGIN_DISPLAY_OFF = 'BEGIN_DISPLAY_OFF',
  END_DISPLAY_OFF = 'END_DISPLAY_OFF',
  BEGIN_DESKTOP_READY = 'BEGIN_DESKTOP_READY',
  END_DESKTOP_READY = 'END_DESKTOP_READY',
}

/**
 * 电源状态变化监听
 */
export interface PowerStateChangeListener extends ObserverAble {
  /**
   * 变更函数
   *
   * @param powerState 电源状态
   * @param reason 变更原因
   */
  onStateChange: (powerState: string, reason: number) => void;
}

/**
 * 电源状态管理器
 */
export class PowerStateManager extends AbstractObserverManager<PowerStateChangeListener> {
  private static sInstance: PowerStateManager;
  private powerStatusReport: Array<string> = [];

  public static getInstance(): PowerStateManager {
    if (PowerStateManager.sInstance == null) {
      PowerStateManager.sInstance = new PowerStateManager();
    }
    return PowerStateManager.sInstance;
  }

  private readonly _callback = (data: PowerOriginNotice): void => {
    if (data.displayPowerEvent === DISPLAY_POWER_EVENT_CANCEL_SCREEN_OFF) {
      this.cancelScreenOff(data.reason);
      return;
    }
    const state = `${EVENT_STATUS_KEYS[data.eventStatus]}_${DISPLAY_POWER_EVENT_KEYS[data.displayPowerEvent]}`;
    log.showInfo(`powerState=[${state}],reason=${data.reason}`);
    if (PowerState[state]) {
      this.broadcastDataChange(callback => callback.onStateChange(state, data.reason));
    }
    this.powerStateEventUtil(state, data);
  };

  private powerStateEventUtil(state: string, data: PowerOriginNotice): void {
    if (state === 'BEGIN_SLEEP' || state === 'BEGIN_WAKE_UP') {
      this.powerStatusReport.splice(0, this.powerStatusReport.length);
      this.powerStatusReport.push(state);
    } else if (state === 'END_SLEEP' || state === 'END_WAKE_UP') {
      this.powerStatusReport.push(state);
      let powerStatus = JSON.stringify(this.powerStatusReport);
      PerformanceMonitorUtil.reportPowerStateEvent({
        powerStatus,
        changeReason: data.reason
      });
      this.powerStatusReport.splice(0, this.powerStatusReport.length);
    } else {
      this.powerStatusReport.push(state)
    }
  }

  /**
   * 初始化
   */
  protected doInit(): void {
    log.showInfo('doInit');
    super.doInit();
    sEventManager.subscribe('powerStatusChange', this._callback);
  }

  protected doRelease(): void {
    log.showInfo('doRelease');
    super.doRelease();
    sEventManager.off('powerStatusChange', this._callback);
  }

  private cancelScreenOff(reason: screenSessionManager.PowerStateChangeReason): void {
    log.showInfo(`cancelScreenOff, reason=${reason}`);
    this.broadcastDataChange(callback => callback.onStateChange(PowerState.END_DISPLAY_OFF, reason));
    this.broadcastDataChange(callback => callback.onStateChange(PowerState.END_SLEEP, reason));
    this.broadcastDataChange(callback => callback.onStateChange(PowerState.BEGIN_WAKE_UP, reason));
    this.broadcastDataChange(callback => callback.onStateChange(PowerState.BEGIN_DISPLAY_ON, reason));
    this.broadcastDataChange(callback => callback.onStateChange(PowerState.END_DISPLAY_ON, reason));
    this.broadcastDataChange(callback => callback.onStateChange(PowerState.END_WAKE_UP, reason));
  }
}