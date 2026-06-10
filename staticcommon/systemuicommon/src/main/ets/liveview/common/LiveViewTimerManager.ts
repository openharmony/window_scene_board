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
import {
  SingletonHelper,
  CommonUtils,
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import { LiveViewCommonConstants } from './LiveConstants';
import { systemDateTime } from '@kit.BasicServicesKit';

const TAG = LiveViewCommonConstants.LOG_PREFIX + 'LiveViewTimeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 计时器参数
 */
interface CountdownOptions {
  // 倒计时总时间（单位：ms）
  initialTime?: number;

  // 是否倒计时
  isCountDown?: boolean;

  // 是否暂停计时，默认false
  isPause?: boolean;

  // 是否更新胶囊时间
  isUpdateTimer?: boolean

  /**
   * 通知启动计时器时的时间与通知通知发送时的时间差
   */
  diffTime?: number;

  // 每次倒计时更新时的回调函数
  onTick?: (remainingTime: number) => void;

  // 倒计时结束时的回调函数
  onFinish?: () => void;

  // 数据更新
  update?: (other: object, forceRefresh?: boolean) => void;
}

/**
 * 计时器
 */
class Countdown {
  private initialTime: number = 0;
  private remainingTime: number;
  private delayTimerId?: number;
  private timerId?: number;
  private options: CountdownOptions;

  /**
   * 上一次计时时间
   */
  private lastTickTime: number = 0;

  /**
   * 下一次计时器运行的期望时间，用来修正计时器间隔
   */
  private nextRunTime?: number;

  constructor(options: CountdownOptions) {
    this.options = options;
    this.lastTickTime = this.getNow();
    if ((options?.initialTime ?? 0) >= 0) {
      this.initialTime = options?.initialTime ?? 0;
      this.remainingTime = this.initialTime;
    }
  }

  /**
   * 定时处理逻辑
   */
  private processTimer(intervalTime: number): void {
    if (CommonUtils.isInvalid(this.options) || this.options.isPause || CommonUtils.isInvalid(this.remainingTime)) {
      this.stop(true);
      return;
    }

    if (this.options.isCountDown) {
      this.remainingTime -= intervalTime;
    } else {
      this.remainingTime += intervalTime;
    }
    if (this.remainingTime < 0) {
      this.remainingTime = 0;
    } else if (this.remainingTime > LiveViewCommonConstants.MAX_TIME_MILLS && !this.options.isCountDown) {
      this.remainingTime = 0;
    }

    log.showInfo(`Process timer, intervalTime: ${intervalTime}, ` +
      `remainingTime: ${this.remainingTime}, initialTime: ${this.initialTime}`);
    if (this.options.onTick) {
      this.options.onTick(this.remainingTime);
    }
    if (this.options.isCountDown && this.remainingTime === 0) {
      this.stop(true);
    }
  }

  private runTimer(): void {
    const now = this.getNow();
    let delay: number = 0;
    if (!this.nextRunTime) {
      delay = LiveViewCommonConstants.INITIAL_TIME;
      this.nextRunTime = now + LiveViewCommonConstants.INITIAL_TIME;
    } else {
      const offset = now - this.nextRunTime;
      delay = LiveViewCommonConstants.INITIAL_TIME - offset;
      this.nextRunTime += LiveViewCommonConstants.INITIAL_TIME;
    }
    this.timerId = setTimeout(() => {
      this.lastTickTime = this.getNow();
      this.runTimer();
      this.processTimer(LiveViewCommonConstants.INITIAL_TIME);
    }, delay);
  }

  /**
   * 开启定时器
   */
  start(): void {
    if (CommonUtils.isInvalid(this.options) || this.options.isPause) {
      log.showInfo('no need to start timer');
      return;
    }

    if (this.isStarted()) {
      log.showInfo('timer is already started');
      return;
    }

    let delay: number;
    if (this.options.isCountDown) {
      delay = this.remainingTime % LiveViewCommonConstants.ONE_SECOND_TO_MILLISECOND;
    } else {
      delay = LiveViewCommonConstants.ONE_SECOND_TO_MILLISECOND -
        this.remainingTime % LiveViewCommonConstants.ONE_SECOND_TO_MILLISECOND;
    }
    log.showInfo(`Start timer, remainingTime: ${this.remainingTime}, initialTime: ${this.initialTime}` +
      `delay: ${delay}, isPause: ${this.options?.isPause}`);
    if (delay) {
      this.delayTimerId = setTimeout(() => {
        this.lastTickTime = this.getNow();
        this.runTimer();
        this.processTimer(delay);
      }, delay);
    } else {
      this.runTimer();
    }
  }

  /**
   * 暂停定时器
   *
   * @param isFinalize 是否销毁定时器，为true表示销毁
   */
  stop(isFinalize: boolean): void {
    log.showInfo('Stop timer, remainingTime:' + this.remainingTime + ', initialTime:' + this.initialTime);

    if (!this.isStarted()) {
      log.showInfo('Timer is already stop');
      return;
    }
    clearTimeout(this.timerId);
    clearTimeout(this.delayTimerId);
    this.timerId = undefined;
    this.delayTimerId = undefined;
    this.nextRunTime = undefined;
    if (isFinalize === false) {
      return;
    }
    if (this.options?.onFinish) {
      this.options?.onFinish();
    }
    this.options = undefined;
  }

  /**
   * 更新计时器内部数据
   *
   * @param options 新的计时器数据
   */
  update(options: CountdownOptions): void {
    if (!options) {
      return;
    }

    log.showInfo('Update timer, initialTime:' + options.initialTime + ', isCountDown:' + options.isCountDown +
      ', isPause:' + options.isPause);
    if (options.isUpdateTimer) {
      this.initialTime = options.initialTime ?? 0;
      this.remainingTime = this.initialTime;
    }
    this.lastTickTime = this.getNow();
    if (CommonUtils.isInvalid(this.options) || CommonUtils.isInvalid(options)) {
      this.options = options;
      return;
    }
    this.options.update(options);
  }

  restart(): void {
    if (!this.lastTickTime) {
      return;
    }
    const intervalTime = this.getNow() - this.lastTickTime;
    this.lastTickTime = this.getNow();
    log.showInfo(`Restart timer, intervalTime: ${intervalTime}`);
    this.processTimer(intervalTime);
    this.start();
  }

  fixTime(diff?: number): void {
    if (!diff || !this.options) {
      return;
    }
    if (this.options.isCountDown) {
      this.remainingTime -= diff;
    } else {
      this.remainingTime += diff;
    }
    this.options.onTick(this.remainingTime);
    log.showInfo(`Fix timer with diff: ${diff}, remainingTime: ${this.remainingTime}`);
  }

  /**
   * 计时器是否开启
   * @returns
   */
  private isStarted(): boolean {
    return !CommonUtils.isInvalid(this.timerId) || !CommonUtils.isInvalid(this.delayTimerId);
  }

  private getNow(): number {
    return systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
  }
}

/**
 * 实况计时器统一管理类
 *
 */
class LiveViewTimerManager {
  /**
   * 实况通知对应的计时数据
   */
  private timers: Map<string, Countdown> = new Map();

  /**
   * 当前亮屏还是灭屏的标识位
   * 1. true表示亮屏
   * 2. false表示灭屏
   */
  private isScreenOn: boolean = true;

  /**
   * 监听亮灭屏
   *
   * @param on
   */
  notifyScreenOnOff(screenOn?: boolean): void {
    log.showInfo('notifyScreenOnOff, screenOn:' + screenOn);
    this.isScreenOn = screenOn ?? false;
    if (CommonUtils.isInvalid(screenOn)) {
      log.showInfo('listening notifyScreenOnOff failed');
      return;
    }

    if (screenOn) {
      this.timers?.forEach((timer, key) => {
        log.showInfo(`Restart timer for ${key}`);
        timer.restart();
      });
    } else {
      this.timers?.forEach((timer, key) => {
        log.showInfo(`Stop timer for ${key}`);
        timer.stop(false);
      });
    }
  }

  /**
   * 开启或更新计时器
   *
   * @param hashCode 实况通知的唯一标识
   * @param data 计时器数据
   */
  startOrUpdateTimer(hashCode: string, data: CountdownOptions): void {
    log.showInfo('startTimer, time:' + data?.initialTime + ', isCountDown:' + data?.isCountDown +
      ', isPause:' + data?.isPause + ', hashCode: ' + hashCode);
    if (CommonUtils.isInvalid(hashCode)) {
      log.showWarn('startTimer data fail');
      return;
    }
    if (CommonUtils.isInvalid(data)) {
      this.stopTimer(hashCode);
      return;
    }

    let timer: Countdown = this.timers.get(hashCode);
    if (!CommonUtils.isInvalid(timer)) {
      timer.update(data);
    } else {
      timer = new Countdown(data);
      this.timers.set(hashCode, timer);
    }
    timer.fixTime(data.diffTime);
    data.diffTime = 0;
    // 当前如果是灭屏状态，不能启动定时器
    if (!this.isScreenOn) {
      log.showInfo(`startTimer fail, current is ScreenOff`);
      return;
    }
    timer.start();
  }

  /**
   * 删除计时器
   *
   * @param hashCode 实况通知的唯一标识
   */
  stopTimer(hashCode: string): void {
    log.showInfo('stopTimer, hashCode:' + hashCode);
    this.timers.get(hashCode)?.stop(true);
    this.timers.delete(hashCode);
  }
}

let liveViewTimerManager = SingletonHelper.getInstance(LiveViewTimerManager, TAG);

export default liveViewTimerManager as LiveViewTimerManager;