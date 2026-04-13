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


import settings from '@ohos.settings';
import commonEvent from '@ohos.commonEvent';
import {
  SingletonHelper,
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import { sEventManager, obtainLocalEvent, getCommonEventManager, POLICY } from '@ohos/frameworkwrapper';
import type { CommonEventManager } from '@ohos/frameworkwrapper';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { i18n } from '@kit.LocalizationKit';
import commonEventManager from '@ohos.commonEventManager';

const TAG = 'TimeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);


export const TIME_CHANGE_EVENT = 'Time_Change_Event';

export interface TimeEventArgs {
  date: Date;
  timeFormat: boolean;
};

/**
 * 时间变化监听
 */
const TIME_SUBSCRIBE_INFO = {
  events: [
    commonEvent.Support.COMMON_EVENT_TIME_CHANGED, // 时间被设置
    commonEvent.Support.COMMON_EVENT_TIMEZONE_CHANGED, // 时区变化
    commonEvent.Support.COMMON_EVENT_TIME_TICK, // 当前时间变化
  ],
};

function fill(value: number): string {
  return (value > 9 ? '' : '0') + value;
}

export function concatTime(h: number, m: number): string {
  return `${fill(h)}:${fill(m)}`;
}

class TimeManager {
  private mUse24hFormat: boolean = false;
  private mManager?: CommonEventManager;

  public init(context: ServiceExtensionContext): void {
    this.mManager = getCommonEventManager(
      TAG,
      TIME_SUBSCRIBE_INFO, 
      (data: commonEventManager.CommonEventData) => this.updateTimeFormat(data),
      (isSubscribe) => isSubscribe && this.notifyTimeChange()
    );
    this.mManager.subscriberCommonEvent();
    this.mManager.applyPolicy([POLICY.SCREEN_POLICY]);
    this.initTimeFormat(context);
  }

  public release(): void {
    this.mManager?.release();
    this.mManager = undefined;
  }

  public formatTime(date: Date): string {
    if (this.mUse24hFormat) {
      return concatTime(date.getHours() % 24, date.getMinutes());
    } else {
      let mHour = date.getHours() % 12;
      if (!mHour) {
        mHour = 12;
      }
      return concatTime(mHour, date.getMinutes());
    }
  }

  /**
   * 触发刷新时间二十四小时制
   */
  public refreshTimeFormat(): void {
    this.mUse24hFormat = i18n.System.is24HourClock();
    log.showInfo('refreshTimeFormat:' + this.mUse24hFormat);
  }

  private async initTimeFormat(context: ServiceExtensionContext): Promise<void> {
    this.mUse24hFormat = i18n.System.is24HourClock();
    log.showInfo('initTimeFormat:' + this.mUse24hFormat);
    this.notifyTimeChange();
  }

  private async updateTimeFormat(data: commonEventManager.CommonEventData): Promise<void> {
    if (data.event === commonEvent.Support.COMMON_EVENT_TIME_CHANGED) {
      this.mUse24hFormat = i18n.System.is24HourClock();
      log.showInfo('updateTimeFormat:' + this.mUse24hFormat);
    }
    this.notifyTimeChange();
  }

  private notifyTimeChange(): void {
    log.showDebug('notifyTimeChange');
    let args: TimeEventArgs = {
      date: new Date(),
      timeFormat: this.mUse24hFormat,
    };
    sEventManager.publish(obtainLocalEvent(TIME_CHANGE_EVENT, args));
  }
}

let sTimeManager = SingletonHelper.getInstance(TimeManager, TAG);

export default sTimeManager as TimeManager;
