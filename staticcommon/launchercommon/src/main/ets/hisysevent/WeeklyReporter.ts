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
import dataPreferences from '@ohos.data.preferences';
import {
  LogDomain,
  LogHelper,
  SingletonHelper,
  Trace,
} from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';

const TAG = 'WeeklyReporter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const PREV_REPORT_TIME = 'PREV_REPORT_TIME';

/**
 dataPreferences.getPreferences 可以实现数据持久化
 使用dataPreferences.getPreferences保存上次打点的时间、格式为年月日，初始化为-1、
 然后使用轮训的方式对比当前时间与上次打点时间
 loop应该保证只注册一次、一直存在
*/
export class WeeklyReporter {
  public static getInstance = SingletonHelper.createFactory(() => new WeeklyReporter());
  
  private constructor() {
  }

  private taskQueue: (() => void)[] = [];

  private taskId: number | null = null;

  private checkDelay: number = 8 * 60 * 60 * 1000; // 循环间隔时间8小时

  private preference: dataPreferences.Preferences | null = null; // 缓存

  private prevReportTime: string = '-1';

  private ONE_WEEK_MILL = 7 * 24 * 60 * 60 * 1000; // 一周毫秒
  /**
   * 初始化
   */
  public async init(): Promise<void> {
    if (this.taskId != null) {
      clearInterval(this.taskId);
    }
    try {
      this.preference = await dataPreferences.getPreferences(GlobalContext.getContext(), TAG);
    } catch (error) {
      log.showError('getPreferences with error %{public}s', error.message);
    }
    this.prevReportTime = await this.preference?.get(PREV_REPORT_TIME, '-1') + '';
    this.checkTask();
    // setTimeout在系统休眠时会丢失任务、采用setInterval
    this.taskId = setInterval(() => this.checkTask(), this.checkDelay);
  }

  private checkTask(): void {
    log.showInfo('weekly task check triggered');
    let current = new Date();
    let currentDate = current.toLocaleDateString(); // 年月日
    let day = current.getDay(); //周几
    if ((day === 0 && currentDate !== this.prevReportTime) ||
      (day !== 0 && this.prevReportTime !== '-1' && new Date(currentDate).getTime() -
      new Date(this.prevReportTime).getTime() >= this.ONE_WEEK_MILL)
    ) {
      // 周日、且未打过点 or 非周日、时间间隔大于等于7天(补打点)
      this.preference?.putSync(PREV_REPORT_TIME, currentDate);
      this.preference?.flush();
      this.prevReportTime = currentDate;
      log.showInfo(`weekly Task exec triggered ; taskQueue.length = ${this.taskQueue.length}`);
      Trace.start(`${TAG}-Exec`);
      this.execTask();
      Trace.end(`${TAG}-Exec`);
    }
  }

  private execTask(): void {
    for (let i = 0; i < this.taskQueue.length; i++) {
      this.taskQueue[i]();
    }
  }

  public registerTask(task: () => void): void {
    this.taskQueue.push(task);
  }

  public unRegisterTask(task: () => void): void {
    for (let i = 0; i < this.taskQueue.length; i++) {
      if (this.taskQueue[i] === task) {
        this.taskQueue.splice(i, 1);
        return;
      }
    }
  }
}