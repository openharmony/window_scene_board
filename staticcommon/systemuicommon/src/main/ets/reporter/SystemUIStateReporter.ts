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
import { NotificationConfigStateEvent } from './NotificationConfigStateEvent';
import { NotificationAppConfigStateEvent } from './NotificationAppConfigStateEvent';
import { NotificationNumberStateEvent } from './NotificationNumberStateEvent';
import { EventManager, EvtBus, TimeChangeEvent } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';

const TAG = 'SystemUIStateReporter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const ONE_WEEK_DAYS: number = 0;

enum SystemUIStateReportDuration {
  DAILY = 0,
  WEEKLY = 1,
  MONTHLY = 2,
}

export class SystemUIStateEventReporter {
  public static get = SingletonHelper.createFactory(() => new SystemUIStateEventReporter());

  protected eventMgr: EventManager = EvtBus.createEventManager();
  private notificationAppConfigStateEvent = new NotificationAppConfigStateEvent();
  private notificationNumberStateEvent = new NotificationNumberStateEvent();
  private notificationConfigStateEvent = new NotificationConfigStateEvent();

  /**
   * 初始化
   */
  public init(): void {
    this.eventMgr.on(TimeChangeEvent, this.onTimeChangeEvent);
  }
  /**
   * 更新通知最大数量
   */
  public updateNtfNum(notificationCount: number): void {
    this.notificationNumberStateEvent.updateMaxNumber(notificationCount);
  }
  /**
   * 周期打点
   */
  private doReport(duration: SystemUIStateReportDuration): void {
    try {
      if (SystemUIStateReportDuration.DAILY === duration) {
        this.notificationNumberStateEvent.report();
      }
      if (SystemUIStateReportDuration.WEEKLY === duration) {
        this.notificationConfigStateEvent.report();
        this.notificationAppConfigStateEvent.report();
      }
      log.showInfo('Notification report success.');
    }
    catch (error) {
      log.error(`Notification report error code:` + error?.code + ' , message:' + error?.message);
    }
  }

  /**
   * 日期变化事件
   */
  private onTimeChangeEvent = (event: TimeChangeEvent): void => {
    if (TimeChangeEvent.EVENT_TIME_TICK === event.event) {
      let date = new Date();
      if (date.getHours() === 0 && date.getMinutes() === 0) {
        this.doReport(SystemUIStateReportDuration.DAILY);
        if (date.getDay() === ONE_WEEK_DAYS) {
          this.doReport(SystemUIStateReportDuration.WEEKLY);
        }
      }
    }
  };
}