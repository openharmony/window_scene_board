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

import {
  LogDomain,
  Logger,
  SingletonHelper,
} from '@ohos/basicutils';

const TAG = 'DailyScheduledReporter';
const log: Logger = Logger.getLogHelper(LogDomain.NC);

/**
 * 每日定时任务
 */
export class DailyScheduledReporter {
  public static getInstance = SingletonHelper.createFactory(() => new DailyScheduledReporter());
  private constructor() {
  }
  private taskQueue: (() => void)[] = [];

  private taskId: number | null = null;

  private checkDelay: number = 1 * 60 * 60 * 1000; // 循环间隔时间1小时
  private scheduleTime: number[] = [24, 0, 0]; // [时，分，秒]
  private limitTime: number = 1 * 60 * 60 * 1000; // 误差时间范围，1小时

  /**
   * 初始化
   */
  public async init(scheduleTime?: number[]): Promise<void> {
    if (this.taskId != null) {
      clearInterval(this.taskId);
    }
    if (scheduleTime) {
      this.scheduleTime = scheduleTime;
    }
    this.checkTask();
    // setTimeout在系统休眠时会丢失任务、采用setInterval
    this.taskId = setInterval(() => this.checkTask(), this.checkDelay);
  }

  private checkTask(): void {
    log.showWarn(TAG, `DailyScheduledReporter checkTask`);
    const now: Date = new Date();
    const currentTimestamp = now.getTime();
    now.setHours(this.scheduleTime[0], this.scheduleTime[1], this.scheduleTime[2]);
    const scheduleTimestamp = now.getTime();
    log.showWarn(TAG, `DailyScheduledReporter scheduleTimestamp: ${scheduleTimestamp}, currentTimestamp: ${currentTimestamp}`);
    if (scheduleTimestamp - currentTimestamp < this.limitTime && scheduleTimestamp - currentTimestamp >= 0) {
      log.showWarn(TAG, `DailyScheduledReporter execTask`);
      this.execTask();
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