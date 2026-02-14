/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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

import type AlarmListener from './AlarmListener';

/**
 * 定时器工具类
 */
export default class Alarm {
  private mAlarmId: number = -1; // 定时器ID
  private mAlarmListener: AlarmListener = null; // 定时器到期后需要执行的函数
  private mIsWaitingForCallback: boolean = false; // 标记位，表示当前是否有定时任务等待执行，避免重复执行
  private mAlarmTriggerTime: number = Number.MAX_VALUE; // 定时时长，单位ms
  private mCurrentTime: number = -1; // 当前时间，单位ms
  private mIsAlarmPending: boolean = false; // 标记当前是否有定时任务

  /**
   * 构造函数
   */
  constructor() {}

  /**
   * 设置定时器任务
   *
   * @param callbackFunction 定时任务
   */
  setHandler(alarmListener: AlarmListener): void {
    this.mAlarmListener = alarmListener;
  }

  /**
   * 设置定时器，如果当前定时任务已经被设置，刷新相关设置
   *
   * @param millisecondsInFuture 定时任务时长
   */
  setAlarm(millisecondsInFuture: number): void {
    this.mIsAlarmPending = true;
    this.mCurrentTime = Date.now();
    let oldTriggerTime: number = this.mAlarmTriggerTime;
    this.mAlarmTriggerTime = this.mCurrentTime + millisecondsInFuture;

    // 如果已经设置过定时任务且旧定时任务的等待时间更久，就取消旧的定时任务，刷新为新的定时任务
    if (this.mIsWaitingForCallback && oldTriggerTime > this.mAlarmTriggerTime) {
      this.clearAlarmId();
      this.mIsWaitingForCallback = false;
    }
    if (!this.mIsWaitingForCallback) {
      this.mAlarmId = setTimeout(this.run.bind(this), this.mAlarmTriggerTime - this.mCurrentTime);
      this.mIsWaitingForCallback = true;
    }
  }

  /**
   * 取消定时任务
   */
  cancelAlarm(): void {
    this.mIsAlarmPending = false;
    this.clearAlarmId();
  }

  /**
   * 是否有定时器任务等待执行
   */
  isAlarmPending(): boolean {
    return this.mIsAlarmPending;
  }

  /**
   * 定时任务执行
   */
  run(): void {
    this.mIsWaitingForCallback = false;
    if (this.mIsAlarmPending) {
      this.mCurrentTime = Date.now();
      /*
       * 还未到定时时间，取消原来定时任务，重新设置定时
       * 否则就执行定时任务，并重置相关标志位
       */
      if (this.mAlarmTriggerTime > this.mCurrentTime) {
        this.clearAlarmId();
        this.mAlarmId = setTimeout(this.run.bind(this), this.mAlarmTriggerTime - this.mCurrentTime);
        this.mIsWaitingForCallback = true;
      }
      else {
        this.mIsAlarmPending = false;
        if (this.mAlarmListener !== null) {
          this.mAlarmListener.onAlarm();
        }
      }
    }
  }

  private clearAlarmId(): void {
    if (this.mAlarmId !== -1) {
      clearTimeout(this.mAlarmId);
      this.mAlarmId = -1;
    }
  }
}