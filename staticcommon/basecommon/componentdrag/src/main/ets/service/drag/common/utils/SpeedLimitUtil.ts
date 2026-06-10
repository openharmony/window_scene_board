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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBConstants } from '@ohos/commonconstants';
import { DragPosition } from '../type/CommonTypes';

const TAG: string = 'Drag-SpeedLimitUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);
const DEFAULT_CHECK_TIMES = 1;

/**
 * 计算速度和设置速度限制的辅助类
 */
export class SpeedLimitUtil {
  /**
   * 速度阈值，超出该速度即为无效速度
   */
  private speedLimit: number = SCBConstants.INVALID_VALUE;

  /**
   * 校验速度的次数，只有连续多次速度有效才返回有效，用于过滤速度跳变的场景
   */
  private speedCheckTimes: number = DEFAULT_CHECK_TIMES;
  private speedValidTimes: number = 0;
  private lastPosition?: DragPosition;
  private lastTime?: number;

  /**
   * 构造函数，可设置速度阈值和速度校验的次数
   *
   * @param speedLimit 速度阈值，若设置为NaN则表示无阈值，所有速度均为有效慢速
   * @param speedCheckTimes 速度校验的次数，若设置NaN则表示无校验次数，此时次数为默认值1
   */
  constructor(speedLimit: number, speedCheckTimes?: number) {
    if (!isNaN(speedLimit)) {
      this.speedLimit = speedLimit;
    }
    if (speedCheckTimes != null && !isNaN(speedCheckTimes)) {
      this.speedCheckTimes = Math.max(speedCheckTimes, DEFAULT_CHECK_TIMES);
    }
  }

  /**
   * 设置保存的位置和时间
   *
   * @param position 坐标位置
   * @param time 时间
   */
  public setData(position: DragPosition, time?: number): void {
    if (position && !isNaN(position.x) && !isNaN(position.y)) {
      this.lastPosition = position;
    }
    if (time != null) {
      this.lastTime = time;
    } else {
      this.lastTime = Date.now();
    }
  }

  /**
   * 判断是否是慢速
   *
   * @param position 坐标位置
   * @returns 速度是否有效
   */
  public isSlowSpeed(position: DragPosition): boolean {
    if (position == null) {
      return false;
    }
    if (this.speedLimit < 0) {
      return true;
    }
    const x: number = position.x;
    const y: number = position.y;
    if (isNaN(x) || isNaN(y)) {
      log.showWarn(`isSpeedValid invalid parameter x:${x} y:${y}`);
      return false;
    }
    const nowTime = Date.now();
    if (!this.lastPosition) {
      this.setData(position, nowTime);
      return false;
    }
    if (this.lastTime >= nowTime) {
      log.showWarn(`isSpeedValid invalid lastTime:${this.lastTime} now:${nowTime}`);
      return false;
    }
    const speed = Math.hypot(x - this.lastPosition.x, y - this.lastPosition.y) / (nowTime - this.lastTime);
    log.showInfo(`speed:${speed} nowTime:${nowTime}`);
    this.setData(position, nowTime);
    if (speed < this.speedLimit) {
      if (this.speedValidTimes >= this.speedCheckTimes) {
        return true;
      } else {
        this.speedValidTimes++;
        return false;
      }
    }
    this.speedValidTimes = 0;
    return false;
  }
}