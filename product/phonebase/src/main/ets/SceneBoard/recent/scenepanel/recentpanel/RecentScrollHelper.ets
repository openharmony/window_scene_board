/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import systemDateTime from '@ohos.systemDateTime';

export class RecentScrollHelper {
  private readonly ONE_FRAME_DEFAULT_TIME: number = 8.3;
  private readonly ONE_FRAME_MAX_TIME: number = 14;
  private readonly DEFAULT_RATE: number = 120;
  private name: string = '';
  private preTimestamp: number = 0;
  private abnormalTimestamp: number = 0;
  private abnormalPreOffset: number = 0;
  private preOffset: number = Number.NaN;
  private speed: number = 0;
  private delta: number = 0;
  private oneFrameTime: number = this.ONE_FRAME_DEFAULT_TIME;
  private oneFrameMaxTime: number = this.ONE_FRAME_MAX_TIME;

  constructor(name: string) {
    this.name = name;
  }

  private calcSpeed(delta: number, diffTime: number) {
    let speed = 0;
    if (diffTime !== 0) {
      speed = delta / diffTime * 1000;
    }
    return speed;
  }

  public get deltaOffset(): number {
    return this.delta;
  }

  public invoke(delta: number, offset: number): void {
    let timestamp = (systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, true) ?? 0) / 1000 / 1000;
    if (this.preTimestamp === 0) {
      this.preTimestamp = timestamp;
      this.preOffset = offset;
      // 第一帧无法计算时间差值，所以按一帧平均8.2ms进行计算速度
      this.speed = delta / this.oneFrameTime * 1000;
      return;
    }
    this.delta = offset - this.preOffset;
    // 间隔时间四舍五入为单帧耗时的整倍数,避免时间间隔波动导致的离手速度不稳定
    this.speed = this.calcSpeed(this.delta,
      Math.max(Math.round((timestamp - this.preTimestamp) / this.oneFrameTime), 1) * this.oneFrameTime);
    this.doAbnormalTimestamp(offset, timestamp);
    this.preOffset = offset;
    this.preTimestamp = timestamp;
  }

  /**
   * 跟手过程出现丢帧情况，速度按丢帧开始的位移/时间间隔计算
   * 在丢帧情况先记录丢帧的时间以及偏移量，再在正常的时候用丢帧到正常的偏移量/丢帧到正常的时间再计算一遍速度
   * @returns
   */
  private doAbnormalTimestamp(offset: number, timestamp: number): void {
    let diffTime = timestamp - this.preTimestamp;
    if (diffTime > this.oneFrameMaxTime) {
      this.abnormalTimestamp = this.preTimestamp;
      this.abnormalPreOffset = this.preOffset;
      return;
    }
    if (this.abnormalTimestamp !== 0) {
      this.speed = this.calcSpeed(offset - this.abnormalPreOffset,
        Math.max(Math.round((timestamp - this.abnormalTimestamp) / this.oneFrameTime), 1) * this.oneFrameTime);
      this.abnormalTimestamp = 0;
      this.abnormalPreOffset = 0;
    }
  }

  public updateOneFrameTime(reFreshRate: number): void {
    let ratio = this.DEFAULT_RATE / reFreshRate;
    this.oneFrameMaxTime = this.ONE_FRAME_MAX_TIME * ratio;
    this.oneFrameTime = this.ONE_FRAME_DEFAULT_TIME * ratio;
  }

  public reset(): void {
    this.speed = 0;
    this.preOffset = Number.NaN;
    this.delta = 0;
    this.preTimestamp = 0;
    this.abnormalTimestamp = 0;
    this.abnormalPreOffset = 0;
  }

  public getSpeed(): number {
    return this.speed;
  }

  public isScrollRightForward(): boolean {
    return (this.delta < 0);
  }

  public isScrollLeftForward(): boolean {
    return (this.delta > 0);
  }

  public static isScrollLeftForward(delta: number): boolean {
    return (delta > 0);
  }

  public static isScrollRightForward(delta: number): boolean {
    return (delta < 0);
  }
}