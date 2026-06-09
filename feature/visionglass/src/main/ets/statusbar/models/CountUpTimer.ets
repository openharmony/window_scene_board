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

const SECONDS_PER_HOUR: number = 3600;
const SECONDS_PER_MINUTES: number = 60;
const MINUTES_PER_HOUR: number = 60;
const MILLISECONDS_PER_SECONDS: number = 1000;
const LENGTH_NEED_PREFIX: number = 2;

/**
 * 计时器
 */
@Observed
export class CountUpTimer {
  public startTime: number;
  public intervalId: number;
  public timeStr: string = '00:00';

  constructor(startTime: number) {
    this.startTime = startTime;
    this.intervalId = 0;
  }

  /*
   * 开始胶囊计时
   * */
  public start() {
    if (this.timeStr !== '00:00') {
      return;
    }
    this.intervalId = setInterval(() => {
      this.timeStr = this.formatSecondsAsHoursMinutes(++this.startTime);
    }, MILLISECONDS_PER_SECONDS);
  }

  /*
   * 停止胶囊计时
   * */
  public stop() {
    clearInterval(this.intervalId);
    this.intervalId = 0;
    this.startTime = 0;
    this.timeStr = '00:00';
  }

  private formatSecondsAsHoursMinutes(seconds: number): string {
    let hours = Math.floor(seconds / SECONDS_PER_HOUR); // 计算小时
    let minutes = Math.floor((seconds % SECONDS_PER_HOUR) / SECONDS_PER_MINUTES); // 计算分钟
    let remainingSeconds = seconds % MINUTES_PER_HOUR; // 计算剩余秒数
    if (hours > 0) {
      return `${hours.toString().padStart(LENGTH_NEED_PREFIX, '0')}:${minutes.toString()
        .padStart(LENGTH_NEED_PREFIX, '0')}:${remainingSeconds.toString().padStart(LENGTH_NEED_PREFIX, '0')}`;
    }
    return `${minutes.toString().padStart(LENGTH_NEED_PREFIX, '0')}:${remainingSeconds.toString()
      .padStart(LENGTH_NEED_PREFIX, '0')}`;
  }
}