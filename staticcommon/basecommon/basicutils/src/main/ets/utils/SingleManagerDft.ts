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

/* 注意！本文件不允许引入非ohos底座以外的模块，否则容易导致SingleManager循环依赖 */
import systemDateTime from '@ohos.systemDateTime';
import hilog from '@ohos.hilog';

const TAG = 'SingleManagerDft';
const SCB = 0x01b00;
/**
 * SingleInstance的DFT组件。
 * 可以记录instance创建时间、instance获取时间集合
 */
export class SingleManagerDft {
  private createUpTime: number = 0;
  private createTime: number = 0;
  private getTimes?: CycleArray = undefined;

  /**
   * 构造函数
   * @param lastGetTimes 需要记录的最大获取时间次数
   */
  constructor(lastGetTimes: number) {
    this.setGetTimeSize(lastGetTimes);
  }

  /**
   * 记录创建时间
   */
  public recordCreateTime(): void {
    if (this.createUpTime > 0) {
      hilog.warn(SCB, TAG, `This instance has been created before at ${this.createUpTime} / ${this.createTime}`);
    }
    this.createUpTime = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, true);
    this.createTime = systemDateTime.getTime(false);
  }

  /**
   * 记录获取时间
   */
  public recordGetTime(): void {
    this.getTimes?.push();
  }

  /**
   * 启用获取时间集合记录功能
   * @param size 允许保存的获取时间的数组大小
   */
  public setGetTimeSize(size: number): void {
    if (size === 0) {
      this.getTimes = undefined;
      return;
    }

    this.getTimes = new CycleArray(size);
  }

  /**
   * 获取基本信息描述
   * @returns 字符串
   */
  public toBasicString(): string {
    let date = new Date(this.createTime);
    return `CreateTime: ${date.getFullYear()}/${date.getMonth().toString() + 1}/${date.getDate()}` +
      ` ${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}.${date.getMilliseconds()} / ${this.createUpTime}`;
  }

  /**
   * 获取使用集合记录描述
   * @returns 字符串
   */
  public toDetailString(): string {
    if (!this.getTimes) {
      return `Disabled detail usage info`;
    }
    return 'Detail usage info: ' + this.getTimes.toString();
  }
}

/**
 * 环形数组
 */
class CycleArray {
  private array: Array<number> = [];
  private now: number = 0;
  private size: number = 0;

  /**
   * 构造函数
   * @param size 环形数组长度
   */
  constructor(size: number) {
    this.size = size;
    this.array = new Array<number>(size).fill(-1).map(() => 0);
  }

  /**
   * 记录当前时间
   */
  public push(): void {
    let nowTime = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, true);
    if (this.isFull()) {
      this.array[0] = nowTime;
      this.now = 1;
      return;
    }
    this.array[this.now] = nowTime;
    this.now++;
  }

  /**
   * 输出环形数组记录
   * @returns 形如[xx, xx, xx]的格式
   */
  public toString(): string {
    let str = '[';

    this.array.forEach((time: number, index: number) => {
      str += time + ((index === (this.array.length - 1)) ? '' : ', ');
    });
    str += ']';
    return str;
  }

  private isFull(): boolean {
    return this.now === this.size;
  }
}