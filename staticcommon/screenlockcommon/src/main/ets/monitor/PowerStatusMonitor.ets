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

import screenSessionManager from '@ohos.screenSessionManager';
import { sEventManager } from '@ohos/frameworkwrapper';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { GlobalStatusCache } from '../base/GlobalStatusCache';
import { BaseStatusMonitor } from './AbstractStatusMonitor';

/**
 * @deprecated 替换为PowerStateManager.ts
 */
export enum PowerStatusEnum {
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
 * @deprecated 替换为PowerStateManager.ts
 */
export class PowerStatusNotice {
  public powerStatus: PowerStatusEnum;
  public changeReason: screenSessionManager.PowerStateChangeReason;

  constructor(powerStatus: PowerStatusEnum, changeReason: screenSessionManager.PowerStateChangeReason) {
    this.powerStatus = powerStatus;
    this.changeReason = changeReason;
  }
}

export interface PowerOriginNotice {
  displayPowerEvent: screenSessionManager.DisplayPowerEvent,
  eventStatus: screenSessionManager.EventStatus,
  reason: screenSessionManager.PowerStateChangeReason
}
;

const DISPLAY_POWER_EVENT_CANCEL_SCREEN_OFF = 7;

/**
 * @deprecated 替换为PowerStateManager.ts
 */
export class PowerStatusMonitor extends BaseStatusMonitor<PowerStatusNotice> {
  private static instance: PowerStatusMonitor;
  private displayPowerEventKeys: string[] = ['WAKE_UP', 'SLEEP', 'DISPLAY_ON', 'DISPLAY_OFF', 'DESKTOP_READY'];
  private eventStatusKeys: string[] = ['BEGIN', 'END'];
  private statusTmp: Array<string> = this.getPowerStatus();

  private constructor() {
    super();
  }

  public static getInstance(): PowerStatusMonitor {
    if (!PowerStatusMonitor.instance) {
      PowerStatusMonitor.instance = new PowerStatusMonitor();
    }
    return PowerStatusMonitor.instance;
  }

  public initStatus(): void {
    this.initEmptyStatus();
  }

  public register(): void {
    sEventManager.subscribe('powerStatusChange', (data: PowerOriginNotice) => {
      if (data.displayPowerEvent === DISPLAY_POWER_EVENT_CANCEL_SCREEN_OFF) {
        this.cancelScreenOff(data.reason);
        return;
      }
      const state = `${this.eventStatusKeys[data.eventStatus]}_${this.displayPowerEventKeys[data.displayPowerEvent]}`;
      this.onPowerStatusChange(state, data.reason);
    });
  }

  public unregister(): void {
    this.infoLog('no need unregister');
  }

  private onPowerStatusChange(state: string, reason: screenSessionManager.PowerStateChangeReason): void {
    this.infoLog(`powerState=[${state}],reason=${reason}`);
    const notice: PowerStatusNotice = new PowerStatusNotice(PowerStatusEnum[state], reason);
    this.updateStatusCache(notice.powerStatus);
    this.handleStatusChange(notice, () => {
      this.publishAtStage(state, notice);
    });
  }

  public cancelScreenOff(reason: screenSessionManager.PowerStateChangeReason): void {
    this.onPowerStatusChange(PowerStatusEnum.END_DISPLAY_OFF, reason);
    this.onPowerStatusChange(PowerStatusEnum.END_SLEEP, reason);
    this.onPowerStatusChange(PowerStatusEnum.BEGIN_WAKE_UP, reason);
    this.onPowerStatusChange(PowerStatusEnum.BEGIN_DISPLAY_ON, reason);
    this.onPowerStatusChange(PowerStatusEnum.END_DISPLAY_ON, reason);
    this.onPowerStatusChange(PowerStatusEnum.END_WAKE_UP, reason);
  }

  private updateStatusCache(status: string): void {
    for (let element of this.statusTmp) {
      if (element === status) {
        GlobalStatusCache.getInstance().setStatus(element, true);
      } else {
        GlobalStatusCache.getInstance().setStatus(element, false);
      }
    }
  }

  private getPowerStatus(): Array<string> {
    const status: string[] = [];
    let ind = 0;
    this.eventStatusKeys.forEach((event) => {
      this.displayPowerEventKeys.forEach((display) => {
        status[ind++] = `${event}_${display}`;
      });
    });
    return status;
  }
}
