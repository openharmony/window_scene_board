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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { systemDateTime } from '@kit.BasicServicesKit';
import { AbstractObserverManager } from '../base/AbstractObserverManager';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';

const TAG: string = 'CountDownTimer';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const INVALID_ID: number = -1;

/**
 * 倒计时接口定义
 */
export interface CountDownTimerListener {
  /**
   * 在倒计时期间触发的回调
   *
   * @param millisUntilFinished 锁屏倒计时完成剩余时间
   */
  onTick: (millisUntilFinished: number) => void;

  /**
   * 锁屏倒计时结束触发的回调
   */
  onFinish: () => void;
}

/**
 * 锁屏倒计时器
 */
export default class CountDownTimer extends AbstractObserverManager<CountDownTimerListener> {
  private intervalId: number = INVALID_ID;

  // 获取被锁定之后的解锁时间
  private stopTimeInFuture: number = 0;

  private _millisLeft: number = 0;

  public get millisLeft(): number {
    return this._millisLeft;
  }


  /**
   * 开始倒计时
   *
   * @param millisInFuture 需要倒计时的时间
   * @returns time 被锁定之后的解锁时间
   */
  public start(millisInFuture: number): number {
    try {
      // 获取自系统启动以来经过的时间
      let realActiveTime = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
      // 获取被锁定之后的解锁时间
      this.stopTimeInFuture = realActiveTime + millisInFuture;
      if (this.intervalId !== -1) {
        this._millisLeft = millisInFuture;
        log.showInfo('intervalId failed, msg is null');
        this.stop();
      }
      // 立即显示错误消息
      this.broadcastDataChange((observer) => observer?.onTick?.(millisInFuture));
      log.showInfo('countdown start');
      this.intervalId = setInterval(() => {
        let millisLeft = this.stopTimeInFuture - systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
        this._millisLeft = Math.max(0, millisLeft);
        if (millisLeft <= 0) {
          this.stop();
        } else {
          this.broadcastDataChange((observer) => observer?.onTick?.(millisLeft));
        }
      }, 1000);
    } catch (error) {
      log.showError('start error');
    }
    return this.stopTimeInFuture;
  }

  /**
   * 取消倒计时.
   */
  public stop(): void {
    if (this.intervalId !== -1) {
      clearInterval(this.intervalId);
      this.intervalId = INVALID_ID;
      log.showInfo('countdown stop');
      this.broadcastDataChange((observer) => observer?.onFinish?.());
    }
  }

  /**
   * 格式化时间
   *
   * @param freezingMillisecond
   * @returns
   */
  public static formatTime(freezingMillisecond: number): string {
    let minute = Math.floor(freezingMillisecond / (60 * 1000));
    let second = Math.round((freezingMillisecond % (60 * 1000)) / 1000);
    let time = '';
    if (minute !== 0) {
      let strTipMinute: string = ResUtils.getInnerPluralByResource($r('app.plural.psd_incorrect_will_locked2'), minute);
      time += strTipMinute + ' ';
    }
    if (second !== 0) {
      let strTipSecond: string = ResUtils.getInnerPluralByResource($r('app.plural.psd_incorrect_will_locked3'), second);
      time += strTipSecond;
    }
    return time;
  }
}