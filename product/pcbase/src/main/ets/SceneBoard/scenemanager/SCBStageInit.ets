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
import { LogDomain, Logger } from '@ohos/basicutils';
import { Alarm } from '@ohos/componenthelper';

export enum SCBInitStage {
  STAGE0 = 0,
  STAGE1 = 1,
  STAGE2 = 2,
  STAGE_END
}

const TAG = 'SCBStageInit';
const log = Logger.getLogHelper(LogDomain.SCB);

export class SCBStageInit {
  private readonly BASE_DELAY_TIME = 500;
  private alarm: Alarm = new Alarm;
  private stageChangeCallback: Function;

  constructor(callback: Function) {
    this.stageChangeCallback = callback;
    this.alarm.setHandler({
      onAlarm: () => {
        this.onAlarm();
      }
    });
  }

  private _currentStage = SCBInitStage.STAGE0;

  public get currentStage(): SCBInitStage {
    return this._currentStage;
  }

  /**
   * sceneboard中零层组件加载第0阶段，主要包括壁纸及壁纸之上可见的组件
   */
  public static STAGE0(stage: SCBInitStage): boolean {
    return stage >= SCBInitStage.STAGE0;
  }

  /**
   * sceneboard中零层组件加载第1阶段，主要包括锁屏之下，可见的组件
   */
  public static STAGE1(stage: SCBInitStage): boolean {
    return stage >= SCBInitStage.STAGE1;
  }

  /**
   * sceneboard中零层组件加载第2阶段，包括锁屏之下，隐层的组件
   */
  public static STAGE2(stage: SCBInitStage): boolean {
    return stage >= SCBInitStage.STAGE2;
  }

  /**
   * 执行alarm
   */
  public onAlarm(): void {
    log.showInfo(TAG, `onAlarm now, current stage: ${this._currentStage}`);
    if (this._currentStage >= SCBInitStage.STAGE_END - 1) {
      log.showWarn(TAG, `current stage reach max stage, stop alarm now`);
      this.reset();
      return;
    }
    this._currentStage = this._currentStage + 1;
    log.showInfo(TAG, `start next stage alarm, next stage: ${this._currentStage}`);
    this.stageChangeCallback(this._currentStage);
    this.start('onAlarm');
  }

  /**
   * 启动alarm
   */
  public start(label?: string): void {
    const delayTime = this.getDelayTime();
    log.showInfo(TAG, `[${label}] start stage init now, stage: ${this._currentStage}, delay time: ${delayTime}`);
    this.alarm.setAlarm(delayTime);
    this.alarm.run();
  }

  /**
   * 取消alarm
   */
  public reset(): void {
    this.alarm.cancelAlarm();
  }

  /**
   * 获取每个阶段定时器时长, 根据stage指数性增长, 500 * (1,2,4,8...)
   */
  private getDelayTime(): number {
    if (this._currentStage === SCBInitStage.STAGE0) {
      return this.BASE_DELAY_TIME * Math.pow(2, this._currentStage);
    }
    // 由于定时器是串行之下, 当前阶段结束之后, 下一阶段再开始, 因此时长需要减去上一阶段时长
    return this.BASE_DELAY_TIME *
      (Math.pow(2, this._currentStage) - Math.pow(2, this._currentStage - 1));
  }
}
