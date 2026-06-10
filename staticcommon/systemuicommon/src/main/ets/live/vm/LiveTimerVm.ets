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

import { ILiveTimerVm } from '../interface/ILiveTimerVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ScreenOnOffEvent } from '@ohos/frameworkwrapper';
import { LiveTimerModel } from '../model/LiveCommonModel';
import { InnerEventUtil } from '../../utils/InnerEventUtil';
import systemDateTime from '@ohos.systemDateTime';
import { AccessibilityVm } from '../../vm/AccessibilityVm';
import { ResourceVm } from '../../vm/ResourceVm';
import { Singleton } from '../../utils/Singleton';
import { LiveNotification } from '../model/LiveNotification';
import { LiveVmInjectorFactory } from '../LiveVmInjectorFactory';
import { NotificationDataManager } from '../../manager/NotificationDataManager';
import { LiveCapsuleTextModel } from '../model/LiveCapsuleTextModel';

const TAG = 'LiveTimerVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
/**
 * 1秒对应的毫秒数
 */
const ONE_SECOND_MILLS = 1000;
/**
 * 1分钟对应的毫秒数
 */
const ONE_MINUTE_SECONDS = 60;
/**
 * 1小时对应的毫秒数
 */
const ONE_HOUR_SECONDS = 3600;
/**
 * 倒计时最大值99时59分59秒, ms数
 */
const MAX_TIMER_VALUE = ONE_HOUR_SECONDS * ONE_SECOND_MILLS * 100 - ONE_SECOND_MILLS;
/**
 * 计时器占位符
 */
const TIMER_REG = /\$\{placeholder.timer\}/;

function getNow(): number {
  return systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
}

/**
 * 实况计时器VM
 */
@ObservedV2
export class LiveTimerVm implements ILiveTimerVm {
  /**
   * 单例
   * @returns
   */
  @Singleton.decorate() static get instance() { return new LiveTimerVm(); }

  private isInit = false;

  /**
   * 是否灭屏
   */
  public isScreenOff: boolean = false;

  @Trace private tickerMap: Map<string, Ticker> = new Map();

  private constructor() {
    if (!this.isInit) {
      this.init();
      this.isInit = true;
    }
  }

  getDiffTime(live: LiveNotification, timer: LiveTimerModel): number {
    // 暂停状态不需要修正
    if (timer.isPaused) {
      return 0;
    }

    return Date.now() - live.deliveryTime;
  }

  setLiveTimer(live: LiveNotification): void {
    if (live.capsule?.isTimer() && live.capsule.timer) {
      this.setTimer(live.capsule.timer, this.getDiffTime(live, live.capsule.timer),
        this.getCapsuleTimerCountDownFinish(live));
    }
    if (live.card?.isOtherCard() && live.card.timer) {
      this.setTimer(live.card.timer, this.getDiffTime(live, live.card.timer),
        this.getCardTimerCountDownFinish(live));
    }
  }

  updateLiveTimer(live: LiveNotification, oldLive: LiveNotification): void {
    const diffTime = Date.now() - live.deliveryTime;
    const newCardTimer = live.card?.isOtherCard() ? live.card.timer : undefined;
    const oldCardTimer = oldLive.card?.isOtherCard() ? oldLive.card.timer : undefined;
    if (newCardTimer || oldCardTimer) {
      this.updateTimer(newCardTimer, oldCardTimer, diffTime,
        this.getCardTimerCountDownFinish(live));
    }

    const newCapsuleTimer = live.capsule?.isTimer() ? live.capsule.timer : undefined;
    const oldCapsuleTimer = oldLive.capsule?.isTimer() ? oldLive.capsule.timer : undefined;
    if (newCapsuleTimer || oldCapsuleTimer) {
      this.updateTimer(newCapsuleTimer, oldCapsuleTimer, diffTime,
        this.getCapsuleTimerCountDownFinish(live));
    }
    log.showInfo(`updateLiveTimer for ${live.hashCode}, live type = ${live.type}`)
  }

  deleteLiveTimer(live: LiveNotification, newLive?: LiveNotification): void {
    if (live.capsule?.isTimer() && live.capsule.timer) {
      if (!newLive || !newLive.capsule?.isTimer()) {
        log.showInfo(`deleteLiveTimer for ${live.hashCode}：newLive is not has timer`);
        this.deleteTimer(live.capsule.timer);
      } else if (newLive.capsule.timer?.uid !== live.capsule.timer.uid) {
        log.showInfo(`deleteLiveTimer for ${live.hashCode}：newLive timerId is not same to oldLive`)
        this.deleteTimer(live.capsule.timer);
      }
    }
    if (live.card?.isOtherCard() && live.card.timer) {
      if (!newLive || !newLive.card?.isOtherCard()) {
        this.deleteTimer(live.card.timer);
      } else if (newLive.card.timer?.uid !== live.card.timer.uid) {
        this.deleteTimer(live.card.timer);
      }
    }
  }

  setTimer(timer: LiveTimerModel, diffTime?: number, onCountdownFinish?: () => void): void {
    if (this.tickerMap.get(timer.uid)) {
      log.showInfo(`Set timer has exit,update ${timer.uid}`);
      const oldTicker = this.tickerMap.get(timer.uid);
      oldTicker?.update(timer);
      return;
    }
    log.showInfo(`Set timer new: ${timer.uid}`);
    this.tickerMap.set(timer.uid, new Ticker(timer, diffTime, onCountdownFinish));
  }

  updateTimer(timer?: LiveTimerModel, oldTimer?: LiveTimerModel, diffTime?: number,
    onCountdownFinish?: () => void): void {
    if (!timer && !oldTimer) {
      return;
    }
    log.showInfo(`Update timer: ${timer?.uid}, oldTimer: ${oldTimer?.uid}`);
    if (oldTimer && timer?.uid === oldTimer?.uid) {
      const oldTicker = this.tickerMap.get(oldTimer.uid);
      oldTicker?.update(timer);
      return;
    } else if (oldTimer) {
      this.deleteTimer(oldTimer);
    }
    if (timer) {
      this.setTimer(timer, diffTime, onCountdownFinish);
    }
  }

  deleteTimer(timer: LiveTimerModel): void {
    log.showInfo(`Delete timer: ${timer?.uid}`);
    const ticker = this.tickerMap.get(timer?.uid);
    if (ticker) {
      ticker.stop();
      // 等待删除动效执行完成后再清理数据
      setTimeout(() => {
        ticker.stop();
        this.tickerMap.delete(timer.uid);
      }, 1000);
    }
  }

  clearTimer(): void {
    this.tickerMap.forEach((ticker) => {
      if (ticker) {
        ticker.stop();
      }
    });

    this.tickerMap.clear();
  }

  getTimerText(timer: LiveTimerModel): string {
    if (!this.tickerMap.has(timer?.uid)) {
      log.showInfo(`getTimerText: ${timer.uid} is not in tickerMap`)
    }
    return this.tickerMap.get(timer?.uid)?.text ?? '';
  }

  getTimerAccessibilityText(timer: LiveTimerModel): string {
    return this.tickerMap.get(timer?.uid)?.accessibilityText ?? '';
  }

  private init(): void {
    InnerEventUtil.on(ScreenOnOffEvent, this.onScreenOnOffEvent);
  }

  private onScreenOnOffEvent = (event: ScreenOnOffEvent): void => {
    log.showInfo('onScreenOnOffEvent isScreenOff:' + event?.isScreenOff());
    if (!event) {
      return;
    }
    this.isScreenOff = event.isScreenOff();
    if (event.isScreenOff()) {
      this.tickerMap?.forEach((ticker, key) => {
        ticker.suspend();
      });
    } else {
      this.tickerMap?.forEach((ticker, key) => {
        ticker.restart();
      });
    }
  };

  private getCapsuleTimerCountDownFinish(live: LiveNotification): undefined | (() => void) {
    if (live.capsule?.isTimer() && live.capsule.timer && live.capsule.timer.isCountdown) {
      const capsule = live.capsule;
      const timer = live.capsule.timer;
      if (!timer.presetTitle && !timer.presetContent) {
        return undefined;
      }

      return () => {
        if (timer.presetTitle) {
          let capsuleData = new LiveCapsuleTextModel();
          capsuleData.title = timer.presetTitle;
          capsuleData.content = timer.presetContent ?? capsule.content;
          capsuleData.backgroundColor = capsule.backgroundColor;
          capsuleData.isContentDisplayed = capsule.isContentDisplayed ?? false;
          capsuleData.icon = capsule.icon;

          this.deleteTimer(timer);
          live.capsule = capsuleData;
        } else {
          capsule.content = timer.presetContent;
        }
        NotificationDataManager.instance.updateExistNtf([live]);
      };
    }
    return undefined;
  }

  private getCardTimerCountDownFinish(live: LiveNotification): undefined | (() => void) {
    if (live.card?.isOtherCard() && live.card.timer && live.card.timer.isCountdown) {
      const card = live.card;
      const timer = live.card.timer;
      if (!timer.presetTitle && !timer.presetContent) {
        return undefined;
      }

      if (card.isPickupCard() && TIMER_REG.test(card.layoutContent)) {
        return () => {
          if (timer.presetTitle) {
            card.layoutTitle = timer.presetTitle;
          }
          if (timer.presetContent) {
            card.layoutContent = timer.presetContent;
            this.deleteTimer(timer);
            card.timer = undefined;
          }
          NotificationDataManager.instance.updateExistNtf([live]);
        };
      }
    }
    return undefined;
  }
}

@ObservedV2
class Ticker {
  @Trace public text: string = '';
  @Trace public accessibilityText: string = '';

  private uid: string;
  private initialTime: number;
  private remainingTime: number;
  private isCountdown: boolean;
  private isPaused: boolean;
  private onCountdownFinish?: () => void;

  /**
   * 上一次计时时间
   */
  private lastTickTime: number = 0;

  /**
   * 计时器挂起
   */
  private isSuspended: boolean = false;

  /**
   * 下一次计时器运行的期望时间，用来修正计时器间隔
   */
  private nextRunTime?: number;
  /**
   * 计时器ID
   */
  private timerId?: number;

  constructor(timer: LiveTimerModel, diffTime: number = 0, onCountdownFinish?: () => void) {
    this.uid = timer.uid;
    this.initialTime = timer.initialTime;
    this.isCountdown = timer.isCountdown;
    this.isPaused = timer.isPaused;
    this.onCountdownFinish = onCountdownFinish;
    this.remainingTime = this.initialTime + (this.isPaused ? 0 : this.isCountdown ? -diffTime : diffTime);
    this.formatText();
    if (LiveTimerVm.instance.isScreenOff) {
      this.suspend();
    } else if (!this.isPaused) {
      this.start();
    }
  }

  @Monitor('text')
  onNameChange(monitor: IMonitor) {
    const oldText = monitor.value<string>()?.before ?? '';
    const newText = monitor.value<string>()?.now ?? '';
    if (oldText.length !== newText.length) {
      LiveVmInjectorFactory.get().getCapsuleListVm().updateLiveByTimer(this.uid);
    }
  }

  /**
   * 开启定时器
   */
  private start(): void {
    if (this.timerId !== undefined) {
      log.showInfo(`Timer ${this.uid} is already started`);
      return;
    }

    let delay: number;
    if (this.isCountdown) {
      delay = this.remainingTime % ONE_SECOND_MILLS;
    } else {
      delay = ONE_SECOND_MILLS - this.remainingTime % ONE_SECOND_MILLS;
    }
    if (delay) {
      this.runTimer(delay);
    } else {
      this.runTimer();
    }
  }

  /**
   * 暂停定时器
   */
  stop(): void {
    if (this.timerId === undefined) {
      log.showInfo(`Timer ${this.uid} is not started`);
      return;
    }

    log.showInfo(`Stop timer ${this.uid}, remainingTime: ${this.remainingTime} lastTickTime: ${this.lastTickTime}`);
    clearTimeout(this.timerId);
    this.timerId = undefined;
    this.nextRunTime = undefined;
    const now = getNow();
    if (now > this.lastTickTime) {
      this.onTick(this.lastTickTime === 0 ? 0 : now - this.lastTickTime);
    }
  }

  /**
   * 更新计时器
   * @param timer
   */
  update(timer: LiveTimerModel): void {
    if (!timer) {
      return;
    }
    this.isCountdown = timer.isCountdown;
    if (timer.isPaused !== this.isPaused) {
      this.isPaused = timer.isPaused;
      if (this.isSuspended) {
        this.updateSuspendTime();
        return;
      }
      if (this.isPaused) {
        this.stop();
      } else {
        this.start();
      }
    }
  }

  /**
   * 挂起计时器
   */
  suspend(): void {
    if (this.isSuspended) {
      log.showInfo(`Timer ${this.uid} is already suspended`);
      return;
    }

    if (this.timerId === undefined) {
      if (!this.lastTickTime && !this.isPaused) {
        this.lastTickTime = getNow();
      }
    } else {
      this.stop();
    }

    log.showInfo(`Suspend timer ${this.uid}, remainingTime: ${this.remainingTime}，isPaused: ${this.isPaused}`);
    this.isSuspended = true;
  }

  /**
   * 重启计时器
   */
  restart(): void {
    if (!this.isSuspended) {
      log.showInfo(`Timer ${this.uid} is not suspended`);
      return;
    }

    if (!this.isPaused) {
      const intervalTime = this.lastTickTime ? getNow() - this.lastTickTime : 0;
      this.onTick(intervalTime);
      this.start();
    }

    log.showInfo(`Restart timer ${this.uid}, remainingTime: ${this.remainingTime}，isPaused: ${this.isPaused}`);
    this.isSuspended = false;
  }

  /**
   * 挂起计时器更新
   */
  private updateSuspendTime(): void {
    if (this.isPaused) {
      const now = getNow();
      if (now > this.lastTickTime) {
        this.onTick(now - this.lastTickTime);
      }
    } else {
      this.lastTickTime = getNow();
    }
    log.showInfo(`In Suspended, update timer ${this.uid}, remainingTime: ${this.remainingTime}，isPaused: ${this.isPaused}`);
  }

  private runTimer(delay?: number): void {
    const intervalTime = delay ?? ONE_SECOND_MILLS;

    if (delay === undefined) {
      const now = getNow();
      if (!this.nextRunTime) {
        delay = ONE_SECOND_MILLS;
        this.nextRunTime = now + ONE_SECOND_MILLS;
      } else {
        const offset = now - this.nextRunTime;
        delay = ONE_SECOND_MILLS - offset;
        this.nextRunTime += ONE_SECOND_MILLS;
      }
    }

    this.timerId = setTimeout(() => {
      this.onTick(intervalTime);
      if (this.timerId === undefined) {
        log.showInfo('timer is stop, no need runTimer');
        return;
      }
      this.runTimer();
    }, delay);
  }

  private onTick(intervalTime: number): void {
    this.lastTickTime = getNow();
    if (this.isCountdown) {
      this.remainingTime -= intervalTime;
    } else {
      this.remainingTime += intervalTime;
    }
    if (this.remainingTime < 0) {
      this.remainingTime = 0;
    } else if (this.remainingTime > MAX_TIMER_VALUE && !this.isCountdown) {
      this.remainingTime = 0;
    }

    log.showInfo(`OnTick for ${this.uid}, intervalTime: ${intervalTime}, ` +
      `remainingTime: ${this.remainingTime}, initialTime: ${this.initialTime}`);

    if (this.isCountdown && this.remainingTime === 0 && this.timerId !== undefined) {
      this.stop();
      log.showInfo(`Countdown is finish for ${this.uid}`);
      this.onCountdownFinish?.();
    }
    this.formatText();
  }

  private formatText(): void {
    let hour: number = 0;
    let minute: number = 0;
    let second: number = 0;

    if (this.remainingTime >= MAX_TIMER_VALUE) {
      hour = 99;
      minute = 59;
      second = 59;
    } else if (this.remainingTime > 0) {
      const secondCount = this.isCountdown ? Math.ceil(this.remainingTime / ONE_SECOND_MILLS) :
      Math.floor(this.remainingTime / ONE_SECOND_MILLS);
      log.showInfo(`secondCount: ${secondCount}`);
      hour = Math.floor(secondCount / ONE_HOUR_SECONDS);
      minute = Math.floor((secondCount - hour * ONE_HOUR_SECONDS) / ONE_MINUTE_SECONDS);
      second = secondCount - hour * ONE_HOUR_SECONDS - minute * ONE_MINUTE_SECONDS;
    }

    log.showInfo(`Format ${this.uid}, hour: ${hour}, minute: ${minute}, second: ${second}`);

    this.text = `${minute.toString().padStart(2, '0')}:${second.toString().padStart(2, '0')}`;
    if (hour) {
      this.text = `${hour.toString().padStart(2, '0')}:${this.text}`;
    }
    try {
      this.formatAccessibilityText(hour, minute, second);
    } catch (e) {
      log.error(`FormatAccessibilityText for ${this.uid} error:`, e);
    }
  }

  private formatAccessibilityText(hour: number, minute: number, second: number): void {
    if (!AccessibilityVm.instance.isEnabled) {
      return;
    }
    let result = '';
    let minuteStr = ResourceVm.instance.getPluralString($r('app.plural.cc_accessibility_str_timer_str_minute'), minute);
    let secondStr = ResourceVm.instance.getPluralString($r('app.plural.cc_accessibility_str_timer_str_second'), second);
    if (hour) {
      let hourStr = ResourceVm.instance.getPluralString($r('app.plural.cc_accessibility_str_timer_str_hour'), hour);
      result = ResourceVm.instance.getString($r('app.string.cc_accessibility_str_timer_str_hour_to_minute_to_second'),
        hourStr, minuteStr, secondStr);
    } else {
      result = ResourceVm.instance.getString($r('app.string.cc_accessibility_str_timer_str_minute_to_second'),
        minuteStr, secondStr);
    }
    this.accessibilityText = result;
  }
}