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

/**
 * 环形数组里的动效参数
 */
class FolderAnimationRecord {
  public date: number = 0;
  public id: string = '';
  public type: string = '';
  public fromValue: number = 0;
  public toValue: number = 0;
  public duration: number = 0;
  public delay: number = 0;
  public curve: number = 0;
}

/* 环形数组动效参数帮助类，做设置、转换等功能 */
class FolderAnimationRecordHelper {
  /* 和Curve的枚举保持一致；没有直接有引用是避免变成ets */
  private static readonly curveMap: string[] = [
    'Linear',
    'Ease',
    'EaseIn',
    'EaseOut',
    'EaseInOut',
    'FastOutSlowIn',
    'LinearOutSlowIn',
    'FastOutLinearIn',
    'ExtDeceleration',
    'Sharp',
    'Rhythm',
    'Smooth'
  ];

  private getCurveDesc(curve: number): string {
    try {
      if (curve < 0) {
        return 'Right-now';
      }
      return FolderAnimationRecordHelper.curveMap[curve];
    } catch {
      return `Unrecognized-type-${curve}`;
    }
  }

  private getDateDesc(date: number): string {
    return new Date(date).toISOString();
  }

  public set(record: FolderAnimationRecord, id: string, type: string, fromValue: number, toValue: number, delay: number,
    duration?: number, curve?: number): void {
    record.date = Date.now();
    record.id = id;
    record.type = type;
    record.fromValue = fromValue;
    record.toValue = toValue;
    record.delay = delay;
    record.duration = duration ?? -1;
    record.curve = curve ?? -1;
  }

  public toString(record: FolderAnimationRecord): string {
    return 'TIME: ' + this.getDateDesc(record.date) +
      ' ID: ' + record.id.padEnd(32, ' ') +
      ' TYPE: ' + record.type.padEnd(16, ' ') +
      ' CURVE:' + this.getCurveDesc(record.curve).padEnd(16, ' ') +
      ' FROM:' + record.fromValue.toString().padEnd(8, ' ') +
      ' TO:' + record.toValue.toString().padEnd(8, ' ') +
      ' DURATION:' + record.duration.toString().padEnd(8, ' ') +
      ' DELAY:' + record.delay.toString().padEnd(8, ' ');
  }
}

/**
 * 环形数组。
 * 实现这个数组有2种方案：
 * 1. FolderAnimationCycleArray<T>，足够抽象，易扩展
 * 2. 当前方案。使用当前方案的原因还是希望在push数据的时候，不需要new一个新的item过来，减少记录数据对内存、虚拟机的影响
 */
export class FolderAnimationCycleArray {
  private helper: FolderAnimationRecordHelper = new FolderAnimationRecordHelper();
  private array: Array<FolderAnimationRecord> = [];
  private now: number = 0;
  private count: number = 0;

  constructor(length: number) {
    this.resize(length);
  }

  /**
   * 更新环形数组大小
   *
   * @param length 长度
   */
  public resize(length: number): void {
    this.array = this.initialArray(length);
    this.now = 0;
    this.count = length;
  }

  /**
   * 添加一条动画播放的记录信息
   *
   * @param id 区分更新的observer
   * @param type 区分更新操作
   * @param fromValue 更改前的值
   * @param toValue 更改后的值
   * @param delay 动效延迟时间
   * @param duration 动效执行时间
   * @param curve 动效曲线
   */
  public push(id: string, type: string, fromValue: number, toValue: number, delay: number, duration?: number,
    curve?: number): void {
    if (this.isFull()) {
      this.helper.set(this.array[0], id, type, fromValue, toValue, delay, duration, curve);
      this.now = 1;
      return;
    }
    this.helper.set(this.array[this.now], id, type, fromValue, toValue, delay, duration, curve);
    this.now++;
  }

  private initialArray(length: number): Array<FolderAnimationRecord> {
    return Array(length).fill(-1).map(() => new FolderAnimationRecord());
  }

  private isFull(): boolean {
    return this.now === this.count;
  }

  public toString(): string {
    let ret = `Now we have ${this.array.length} record data in cycle-array\n`;
    this.array.forEach((item: FolderAnimationRecord, i: number) => {
      ret += (i === (this.now - 1) ? '(*) ' : '    ') + this.helper.toString(item) + '\r\n';
    });
    return ret;
  }
}