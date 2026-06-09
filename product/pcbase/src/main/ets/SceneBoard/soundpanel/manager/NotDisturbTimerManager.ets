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

import systemTimer from '@ohos.systemTimer';
import { BusinessError } from '@ohos.base';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { commonEventManager } from '@kit.BasicServicesKit';
import notificationManager from '@ohos.notificationManager';
import bundleManager from '@ohos.bundle.bundleManager';
import { DNDConstants } from '../common/Constants';
import NotDisturbDataUtil from '../util/NotDisturbDataUtil';
import NotDisturbUtils from '../util/NotDisturbUtils';
import { PanelManagerBase } from './PanelManager';

const TAG = 'NotDisturbTimerManager';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class NotDisturbTimerParam {
  //timer 的id
  public id: number = 0;
  public startTime: string = '';
  public endTime: string = '';
  public repeat: string = '';
  public isOpen: boolean = false;
  public repeatText?: ResourceStr = ''; //重复类型展示的文字
  // 重复类型
  public repeatType: number = 0; // 0 : 单次； 1：自定义
  public skipEndTime: number = 0; // 是否跳过本次，非0则跳过，保存需要跳过的时间段的endtime,使用场景：当定时免打扰开启了，却又提前关闭
  public onceType?: PresetOnceType;
}

export enum NotDisturbTimerRepeatType {
  ONES = 0, // 只响一次
  EVERY_WEEK = 1, // 自定义响铃
}

export enum PresetOnceType {
  DEFAULT = -1, // 默认值
  ONE_HOUR = 0, // 一小时
  TWO_HOUR = 1, // 二小时
  TONIGHT = 2 // 至今晚
}

export class NotDisturbTimerManager implements PanelManagerBase {
  private static instance: NotDisturbTimerManager;
  private timerId: number = DNDConstants.NO_TIMER;
  private timerRebootOpport: boolean = true;
  private systemTimeChangeEventSubscriber: commonEventManager.CommonEventSubscriber | undefined;
  private whiteAppList: string[] = [DNDConstants.CLOCK_BUNDLE_NAME, DNDConstants.HUAWEISHARE_BUNDLE_NAME];
  private trustAppList: notificationManager.BundleOption[] = [];
  private subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: [
      commonEventManager.Support.COMMON_EVENT_TIME_CHANGED,
      commonEventManager.Support.COMMON_EVENT_TIMEZONE_CHANGED
    ]
  };

  public static getInstance(): NotDisturbTimerManager {
    if (NotDisturbTimerManager.instance) {
      return NotDisturbTimerManager.instance;
    }
    NotDisturbTimerManager.instance = new NotDisturbTimerManager();
    return NotDisturbTimerManager.instance;
  }

  public init(): void {
    NotDisturbDataUtil.setCallMessagePolicyForbid();
    this.initTrustAppList();
    this.registerListener();
    this.createTimeAlarm().then(() => {
      this.initRefreshTimer();
    });
  }

  public destroy(): void {
    this.unregisterListener();
    this.destroyTimerTimeAlarm();
  }

  /**
   * 根据定时规则更新timer的启动、关闭
   */
  private async initRefreshTimer(): Promise<void> {
    log.info(`initManager Timer`);
    if (!await NotDisturbDataUtil.getDNDManualEnable()) {
      this.stopAlarmSelf(this.timerId);
      this.refreshTimer();
    }
  }

  /**
   * 初始化免打扰豁免应用
   */
  private async initTrustAppList(): Promise<void> {
    log.info(`initTrustAppList begin`);
    NotDisturbDataUtil.setDNDProfile();
    let templates: notificationManager.DoNotDisturbProfile[] = [
      {
        id: 1,
        name: 'Not disturb'
      }
    ];
    await notificationManager.removeDoNotDisturbProfile(templates).then(() => {
      log.info(`removeDoNotDisturbProfile success.`);
    }).catch((error: BusinessError) => {
      log.error(`removeDoNotDisturbProfile fail: ${error?.message}`);
    });
    await this.getTrustList();
    templates[0].trustlist = this.trustAppList;
    await notificationManager.addDoNotDisturbProfile(templates).then(() => {
      log.info(`addDoNotDisturbProfile success.`);
    }).catch((error: BusinessError) => {
      log.error(`addDoNotDisturbProfile fail: ${error?.message}`);
    });
  }

  /**
   * 根据定时规则更新timer的启动、关闭
   *
   * @param isNeedClose
   */
  private async getTrustList(): Promise<void> {
    log.info(`getTrustList begin`);
    let trustAppList: notificationManager.BundleOption[] = [];
    try {
      trustAppList =
        JSON.parse(await NotDisturbDataUtil.getTrustAppDataInfo()) as notificationManager.BundleOption[];
    } catch (e) {
      log.error(`get selected trustList error: ${e?.message}`);
      trustAppList = [];
    }
    let appFlags = bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT;
    for (const bundName of this.whiteAppList) {
      try {
        let appInfo = await bundleManager.getApplicationInfo(bundName, appFlags);
        if (appInfo && appInfo.systemApp) {
          trustAppList.push({ bundle: bundName, uid: appInfo.uid })
        }
      } catch (e) {
        log.error(`getApplicationInfo error: ${(e as BusinessError).message}`);
      }
    };
    this.trustAppList = trustAppList;
  }

  /**
   * 根据定时规则更新timer的启动、关闭
   *
   * @param isSkip 需要跳过当前生效的定时任务
   * @param zenTimers 定时任务列表
   */
  private async refreshTimer(isSkip: boolean = false, zenTimers: NotDisturbTimerParam[] = []): Promise<void> {
    let zenTimersArrays: NotDisturbTimerParam[] = [];
    if (zenTimers.length == 0) {
      zenTimersArrays = await this.getTimers();
    } else {
      zenTimersArrays = zenTimers;
    }
    this.updateTimer(zenTimersArrays, isSkip);
  }

  /**
   * 创建定时器
   */
  private async createTimeAlarm(): Promise<void> {
    try {
      this.timerId = await systemTimer.createTimer({
        type: systemTimer.TIMER_TYPE_EXACT | systemTimer.TIMER_TYPE_WAKEUP,
        repeat: false,
        callback: () => {
          log.info(`time to refresh focusMode status`);
          this.refreshTimer();
        }
      });
      this.timerRebootOpport = true;
      log.info(`create alarm timer success`);
    } catch (error) {
      log.error(`create timer failed : ${(error as BusinessError).message}`);
      if (this.timerRebootOpport) {
        this.timerRebootOpport = false;
        await this.createTimeAlarm();
      }
    }
  }

  /**
   * 创建定时器
   */
  private async destroyTimerTimeAlarm(): Promise<void> {
    try {
      await systemTimer.destroyTimer(this.timerId);
      log.info(`destroy alarm timer success`);
    } catch (error) {
      log.error(`destroy timer failed : ${(error as BusinessError)?.message}`);
    }
  }

  /**
   * 监听可能导致定时任务变化的事件
   */
  private registerListener(): void {
    // 监听用户手动操作
    let res = NotDisturbDataUtil.registerDNDSettingsStatusChange(DNDConstants.FOCUS_MODE_MANUAL_ENABLE, async () => {
      log.info(`listen user manual change focusMode`);
      this.stopAlarmSelf(this.timerId);
      if (!await NotDisturbDataUtil.getDNDManualEnable()) {
        this.refreshTimer(true);
      }
    });
    log.info(`regStatus listen focus mode manual res: ${res}`);

    // 监听定时任务刷新
    res = NotDisturbDataUtil.registerDNDSettingsStatusChange(DNDConstants.FOCUS_MODE_TIMER, async () => {
      log.info(`listen focus mode timer change, refreshTimer`);
      this.stopAlarmSelf(this.timerId);
      if (!await NotDisturbDataUtil.getDNDManualEnable()) {
        this.refreshTimer();
      }
    });
    log.info(`regStatus listen focus mode timer res: ${res}`);

    // 监听用户变更系统时间，创建订阅
    try {
      log.info(`createSubscriber start`);
      commonEventManager.createSubscriber(this.subscribeInfo,
        (err: BusinessError, commonEventSubscriber:commonEventManager.CommonEventSubscriber) => {
        if (err) {
          log.showError(`createSubscriber error: ${err?.message}`);
          return;
        }
        this.systemTimeChangeEventSubscriber = commonEventSubscriber;
        this.subscribeSystemTimeChangeFromUser();
      });
    } catch (e) {
      log.showError(`start listen user change system time error: ${e?.message}`);
    }
  }

  /**
   * 监听注销
   */
  private unregisterListener(): void {
    // 监听用户手动操作
    let res = NotDisturbDataUtil.unregisterDNDSettingsStatusChange(DNDConstants.FOCUS_MODE_MANUAL_ENABLE);
    log.info(`unregStatus listen focus mode manual res: ${res}`);

    // 监听定时任务刷新
    res = NotDisturbDataUtil.unregisterDNDSettingsStatusChange(DNDConstants.FOCUS_MODE_TIMER);
    log.info(`unregStatus listen focus mode timer res: ${res}`);

    // 监听用户变更系统时间，创建订阅
    try {
      log.info(`unsubscribe start`);
      commonEventManager.unsubscribe(this.systemTimeChangeEventSubscriber);
    } catch (e) {
      log.showError(`unsubscribe user change system time error: ${e?.message}`);
    }
  }

  /**
   * 订阅用户操作导致的系统时间变更
   */
  private subscribeSystemTimeChangeFromUser() {
    try {
      commonEventManager.subscribe(this.systemTimeChangeEventSubscriber, this.systemTimeChangeEventSubscriberCallback);
      log.info(`subscribe end`);
    } catch (e) {
      log.showError(`subscribe error: ${e?.message}`);
    }
  }

  private systemTimeChangeEventSubscriberCallback: (err: BusinessError,
    eventData: commonEventManager.CommonEventData) => void =
    (err: BusinessError, eventData: commonEventManager.CommonEventData) => {
      if (err || eventData === undefined) {
        log.showError(`Failed to receive commonEvent ${eventData?.event} - ${err?.message}`);
        return;
      }
      log.showInfo(`listen user change system time, event = ${eventData?.event}`);
      this.refreshTimerCaseBySystemTimeChange();
    };

  private async refreshTimerCaseBySystemTimeChange(): Promise<void> {
    let zenTimersArrays: NotDisturbTimerParam[] = await this.getTimers();
    // 通过用户手动操作时间触发的定时任务刷新，需要清除所有skipEndTime，更新进数据库，然后交由数据库监听刷新定时任务
    for (const zenTimer of zenTimersArrays) {
      zenTimer.skipEndTime = 0;
    }
    NotDisturbDataUtil.setDNDTimers(JSON.stringify(zenTimersArrays));
  }

  /**
   * 获取定时规则列表
   *
   * @param context
   * @returns 返回所有的定时规则列表
   */
  private async getTimers(): Promise<Array<NotDisturbTimerParam>> {
    let zenTimersArrays: NotDisturbTimerParam[] = [];
    let savedTimers = await NotDisturbDataUtil.getDNDTimers();
    if (savedTimers === '') {
      zenTimersArrays.push({
        id: 1,
        startTime: '22:00',
        endTime: '07:00',
        repeat: '1,7',
        isOpen: false,
        repeatType: 1,
        skipEndTime: 0
      });
      NotDisturbDataUtil.setDNDTimers(JSON.stringify(zenTimersArrays));
      return zenTimersArrays;
    }
    log.info(`getTimers getSettingsData: ${savedTimers}`);
    try {
      zenTimersArrays = JSON.parse(savedTimers);
    } catch (e) {
      log.error(`zenTimersArrays parse error`);
    }
    return zenTimersArrays;
  }
  
  private async updateTimer(zenTimersArrays: Array<NotDisturbTimerParam>, isSkip: boolean = false): Promise<void> {
    if (this.isOnceTimeUp(zenTimersArrays) && !isSkip) {
      // 若此时只重复一次的定时任务到点，则更新数据库定时任务，并交由数据库timers监听触发下一次的定时任务更新
      zenTimersArrays[0].isOpen = false;
      NotDisturbDataUtil.setDNDTimers(JSON.stringify(zenTimersArrays));
      return;
    }
    let timeArray: number[] = this.calNextTime(zenTimersArrays, isSkip);
    let startTime = timeArray[0];
    let endTime = timeArray[1];
    if (startTime == 0 && endTime == 0) {
      this.stopAlarmSelf(this.timerId);
      log.info(`no timer is openning`);
      NotDisturbDataUtil.setDNDEnable(false);
      return;
    }
    this.setTimerStatus(startTime, endTime);
  }

  //停止当前timer
  private stopAlarmSelf(timerId: number): void {
    if (!timerId || timerId === DNDConstants.NO_TIMER) {
      return;
    }
    try {
      systemTimer.stopTimer(timerId);
      log.info(`Stop stopTimer success`);
    } catch (error) {
      log.error(`Stop timer failed: ${(error as BusinessError).message}`);
    }
  }

  /**
   * 当前开启的单次定时任务是否到点
   *
   * @param zenTimersArrays 所有定时规则列表
   * @returns 是否到点结果
   */
  private isOnceTimeUp(zenTimersArrays: Array<NotDisturbTimerParam>): boolean {
    let res: boolean = false;
    let newTime = new Date().getTime();
    if (this.isOnceTimerOpen(zenTimersArrays)) {
      res = NotDisturbUtils.isOnceOverTime(zenTimersArrays[0], newTime);
    }
    return res;
  }

  /**
   * 当前是否存在开启的单次定时任务
   *
   * @param zenTimersArrays 所有定时规则列表
   * @returns 单次定时任务是否存在结果
   */
  private isOnceTimerOpen(zenTimersArrays: Array<NotDisturbTimerParam>): boolean {
    if (zenTimersArrays.length < 1) {
      return false;
    }
    return zenTimersArrays[0] && zenTimersArrays[0].repeatType === NotDisturbTimerRepeatType.ONES &&
      zenTimersArrays[0].isOpen === true;
  }

  /**
   * 计算下一次生效的时间规则区间
   *
   * @param zenTimersArrays 所有定时规则列表
   * @param isSkip 需要跳过当前生效的定时任务
   * @returns 开启时间-结束时间
   */
  private calNextTime(zenTimersArrays: Array<NotDisturbTimerParam>, isSkip: boolean = false): Array<number> {
    let startTime = 0;
    let endTime = 0;
    let isSkipChange = false;
    log.info(`calNextTime arraysize: ${zenTimersArrays.length}`);
    let newTime = new Date().getTime();
    let nextDate = new Date();
    nextDate.setHours(nextDate.getHours() + DNDConstants.ONE_DAY_HOUR);
    let nextTime = nextDate.getTime();
    for (let i = 0; i < zenTimersArrays.length; i++) {
      if (!zenTimersArrays[i].isOpen) {
        continue;
      }
      log.info(`updateTimer zenTimersArrays[${i}]: ` +
        `${zenTimersArrays[i].startTime} - ${zenTimersArrays[i].endTime} - ${zenTimersArrays[i].repeat}`);
      let skipEndTime = zenTimersArrays[i].skipEndTime;
      let isNeedSkip: boolean = !!skipEndTime && newTime <= skipEndTime;
      // 若此定时任务存在结束跳过时间，且此次跳过时间生效，则以当前时间后延24小时的方式跳过今日定时，计算下次定时任务
      let arrayTime: number[] = NotDisturbUtils.getNextTime(zenTimersArrays[i], isNeedSkip ? nextTime : newTime);
      if (arrayTime[1] <= newTime) {
        continue;
      }
      // 若为用户手动关闭免打扰，则需跳过本次所有当前正在生效的定时任务；若无需跳过任何定时任务，则继续执行业务，否则更新skipTime，并交由数据库timers监听触发下一次的定时任务更新
      if (isSkip && arrayTime[0] <= newTime && newTime < arrayTime[1]) {
        isSkipChange = true;
        zenTimersArrays[i].skipEndTime = arrayTime[1];
        if (zenTimersArrays[i].repeatType === NotDisturbTimerRepeatType.ONES) {
          // 若定时任务为仅一次任务，还需额外关闭此定时任务
          zenTimersArrays[i].isOpen = false;
        }
      }
      if (startTime == 0 && endTime == 0) {
        startTime = arrayTime[0];
        endTime = arrayTime[1];
      } else if (arrayTime[0] < startTime) {
        startTime = arrayTime[0];
        endTime = arrayTime[1];
      }
    }
    if (isSkipChange) { // 返回无效值跳过本次定时任务更新，更新数据库定时任务skipTime，并交由数据库timers监听触发下一次的定时任务更新
      NotDisturbDataUtil.setDNDTimers(JSON.stringify(zenTimersArrays));
      return [0, 0];
    }
    return [startTime, endTime];
  }

  /**
   * 根据时间生效区间，判断设置免打扰开关状态及启动timer
   *
   * @param startTime
   * @param endTime
   * @param isNeedClose 最后是否需要关闭免打扰开关
   */
  private async setTimerStatus(startTime: number, endTime: number): Promise<void> {
    let isDNDEnable: boolean = await NotDisturbDataUtil.getDNDEnable();
    log.info(`current foucusMode status: ${isDNDEnable ? 'on' : 'off'}`);
    let nowTime = new Date().getTime();
    if (isDNDEnable) {
      // 已是开启状态，需判断当前时间与startTime-endTime，看是否需要开启
      if (startTime > nowTime) {
        // 不在区间内，需先关掉开关，然后定时开启
        NotDisturbDataUtil.setDNDEnable(false);
        this.startTimeAlarm(startTime);
      } else {
        // 已在区间内，直接定时关闭
        this.startTimeAlarm(endTime);
      }
    } else {
      if (startTime <= nowTime && endTime > nowTime) {
        // 立即开启
        NotDisturbDataUtil.setDNDEnable(true);
        this.startTimeAlarm(endTime);
      } else {
        this.startTimeAlarm(startTime);
      }
    }
  }

  //启动定时timer
  private async startTimeAlarm(alarmtime: number): Promise<void> {
    log.info(`start new TimeAlarm begin`);
    if (!this.timerId || this.timerId === DNDConstants.NO_TIMER) {
      await this.createTimeAlarm();
    }
    try {
      await systemTimer.startTimer(this.timerId, alarmtime as number);
      this.timerRebootOpport = true;
      log.info(`start alarm timer success`);
    } catch (error) {
      log.error(`startTimeAlarm Start timer failed : ${(error as BusinessError).message}`);
      if (this.timerRebootOpport) {
        this.timerRebootOpport = false;
        this.startTimeAlarm(alarmtime);
      }
    }
  }
}