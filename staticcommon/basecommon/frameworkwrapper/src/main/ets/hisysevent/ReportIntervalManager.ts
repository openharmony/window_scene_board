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

import { LogDomain, LogHelper, CheckEmptyUtils, SingletonHelper } from '@ohos/basicutils';
import {HiSysEventUtil} from './HiSysEventUtil';

const TAG = 'SysUI_ReportIntervalManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

const REPORT_INTERVAL: number = 3600000;

export class ReportIntervalManager {
  static readonly BRIGHTNESS_UP: string = 'BRIGHTNESS_UP';
  static readonly BRIGHTNESS_DOWN: string = 'BRIGHTNESS_DOWN';
  static readonly LOGO_L: string = 'LOGO_L';
  private eventCounts: Map<string, number> = new Map();
  private timerId: number = -1;
  private eventList: Array<DfxEvent> = new Array<DfxEvent>();


  addEventCount(eventFlag: string): void {
    if (CheckEmptyUtils.isEmpty(eventFlag)) {
      return;
    }
    let count: number = 0;
    if (!this.eventCounts.has(eventFlag)) {
      count = 1;
    } else {
      count = this.eventCounts.get(eventFlag) ?? 0 + 1;
    }
    this.eventCounts.set(eventFlag, count);
  }

  clearEventCounts(): void {
    this.eventCounts.clear();
  }

  createReportInterval(): void {
    if (this.timerId > 0) {
      return;
    }
    this.timerId = setInterval(() => {
      this.reportCount();
      this.reportEvent();
    }, REPORT_INTERVAL);
  }

  clearReportInterval(): void {
    if (this.timerId > 0) {
      clearTimeout(this.timerId);
      this.timerId = -1;
    }
  }

  private reportCount(): void {
    if (this.eventCounts.size === 0) {
      log.showInfo('nothing to report');
      return;
    }
    this.eventCounts.forEach((eventCount: number, eventFlag: string) => {
      log.showInfo('reportCount eventFlag eventCount, eventFlag:%{public}s , eventCount:%{public}d', eventFlag, eventCount);
      switch (eventFlag) {
        case ReportIntervalManager.LOGO_L:
          HiSysEventUtil.reportLogoL(eventCount);
          break;
        case ReportIntervalManager.BRIGHTNESS_UP:
          HiSysEventUtil.reportBrightnessDownOrUp(eventCount, false);
          break;
        case ReportIntervalManager.BRIGHTNESS_DOWN:
          HiSysEventUtil.reportBrightnessDownOrUp(eventCount, true);
          break;
        default:
          HiSysEventUtil.reportIconClick(eventCount, eventFlag);
      }
    });
    this.clearEventCounts();
  }

  registerEvent(event: DfxEvent): void {
    if (this.eventList.indexOf(event) !== -1) {
      log.showWarn(`repeat add event`);
      return;
    }
    this.eventList.push(event);
  }

  clearEvent(): void {
    this.eventList = new Array<DfxEvent>();
  }

  unRegisterEvent(event: DfxEvent): void {
    const index: number = this.eventList.indexOf(event);
    if (index !== -1) {
      this.eventList.splice(index, 1);
    }
  }

  private reportEvent(): void {
    if (this.eventList.length === 0) {
      log.showInfo('nothing to report');
      return;
    }
    this.eventList.forEach((event: DfxEvent) => { event.report(); });
  }
}


export interface DfxEvent {
  report(): void
}

// 单例
export let reportIntervalMgr: ReportIntervalManager = SingletonHelper.getInstance(ReportIntervalManager, TAG);