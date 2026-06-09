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
import { BusinessError, runningLock } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EventManager, EvtBus, ScreenOnOffEvent } from '@ohos/frameworkwrapper';
import { LimitSet } from '../../base/utils/LimitSet';

const TAG = 'ImmRunningLockMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

// 持有亮屏锁时长
const MAX_RUNNING_LOCK_TIME_MS: number = 5 * 60 * 1000;

// 亮屏锁最大重试次数
const MAX_CREATE_RETRY_COUNT = 3;

// 影响亮屏锁开关的参数
class RunningLockEnableParam {
  // 当前显示沉浸大卡标识
  public curShowingImmHash?: string;

  // 锁屏主页面状态
  public isSlMainPage: boolean = false;

  // 锁屏页面覆盖状态
  public isSlOccluded: boolean = false;

  // 当前是否亮屏
  public isScreenOn: boolean = false;

  // 亮屏锁开关是否开启
  private _isRunningLockEnable: boolean = false;

  /**
   * 亮屏锁开关
   *
   * @returns true开启亮屏锁
   */
  public isRunningLockEnable(): boolean {
    return this._isRunningLockEnable;
  }

  /**
   * 刷新亮屏锁开关状态
   */
  public updateRunningLockEnable(): void {
    // 亮屏锁开启 = 沉浸UI显示 + 锁屏主页面 + 非覆盖模式 + 亮屏状态
    this._isRunningLockEnable = Boolean(this.curShowingImmHash) && this.isSlMainPage &&
      !this.isSlOccluded && this.isScreenOn;
  }
}

/**
 * 沉浸态屏幕常亮管理器
 */
export class ImmRunningLockMgr {
  // 单例
  private static instance?: ImmRunningLockMgr;

  // 申请开启亮屏锁的沉浸应用标识
  private readonly runningLockSet: LimitSet<string> = new LimitSet();

  // 亮屏锁开关状态管理
  private readonly runningLockEnable: RunningLockEnableParam = new RunningLockEnableParam();

  // 当前亮屏锁是否开启
  private isRecordLockEnable: boolean = this.runningLockEnable.isRunningLockEnable();

  // 亮屏锁
  private immRunningLock?: runningLock.RunningLock;

  // 亮屏锁创建重试次数
  private createRetryCount: number = 0;

  // 亮屏锁管理器是否正在运行
  private isMgrRunning: boolean = false;

  // 事件管理器
  private readonly eventMgr: EventManager = EvtBus.createEventManager();

  // 亮屏锁管理能力是否使能，默认使能
  private isMgrEnable: boolean = true;

  // 亮灭屏事件回调
  private readonly onScreenOnOffEvent = (event: ScreenOnOffEvent): void => {
    const isScreenOn = event?.isScreenOn() ?? false;
    if (this.runningLockEnable.isScreenOn !== isScreenOn) {
      log.showInfo(`onScreenOnOffEvent: ${isScreenOn}`);
      this.runningLockEnable.isScreenOn = isScreenOn;
      this.runningLockEnable.updateRunningLockEnable();
      // 状态无变化时，主动刷新锁状态
      if (!this.checkRunningLockEnableChange()) {
        this.updateRunningLockState();
      }
    }
  };

  /**
   * 单例
   *
   * @returns 单例
   */
  public static getInstance(): ImmRunningLockMgr {
    if (!ImmRunningLockMgr.instance) {
      ImmRunningLockMgr.instance = new ImmRunningLockMgr();
    }
    return ImmRunningLockMgr.instance;
  }

  /**
   * 初始化
   */
  public init(): void {
    if (!this.isMgrEnable) {
      return;
    }
    // 已开启运行，无需重复初始化
    if (this.isMgrRunning) {
      return;
    }
    this.isMgrRunning = true;
    // 注册亮灭屏事件
    this.eventMgr.on(ScreenOnOffEvent, this.onScreenOnOffEvent);
    // 创建亮屏锁
    this.createRunningLock();
  }

  /**
   * 资源回收
   */
  public destroy(): void {
    if (!this.isMgrEnable) {
      return;
    }
    if (!this.isMgrRunning) {
      return;
    }
    // 注销亮灭屏事件
    this.eventMgr.offAll();
    // 释放全部亮屏锁申请
    this.releaseAllRunningLock();
    // 清除亮屏锁
    this.immRunningLock = undefined;
    // 重试次数复位
    this.createRetryCount = 0;
    this.isMgrRunning = false;
  }

  /**
   * 沉浸态数据刷新时，主动请求刷新锁状态
   */
  public requestUpdateRunningLockState(hashcode: string): void {
    if (!this.isMgrEnable) {
      return;
    }
    // 当前显示沉浸态应用，持续刷新锁状态
    if (this.runningLockEnable.curShowingImmHash === hashcode && this.runningLockSet.has(hashcode)) {
      this.updateRunningLockState();
    }
  }

  /**
   * 缓存沉浸数据常亮开关状态
   *
   * @param hashcode 应用标识
   * @param isEnable true常亮开启
   */
  public cacheRunningLockState(hashcode: string, isEnable: boolean): void {
    if (!this.isMgrEnable) {
      return;
    }
    if (isEnable) {
      this.requestRunningLock(hashcode);
    } else {
      this.releaseRunningLock(hashcode);
    }
  }

  /**
   * 设置当前沉浸态显示的应用标识
   *
   * @param hashcode 标识
   */
  public setCurShowingImmersive(hashcode?: string): void {
    if (!this.isMgrEnable) {
      return;
    }
    if (this.runningLockEnable.curShowingImmHash !== hashcode) {
      this.runningLockEnable.curShowingImmHash = hashcode;
      this.runningLockEnable.updateRunningLockEnable();
      // 状态无变化时，主动刷新锁状态
      if (!this.checkRunningLockEnableChange()) {
        this.updateRunningLockState();
      }
    }
  }

  /**
   * 设置锁屏主页面显示状态
   *
   * @param isMainPage true显示主页面
   */
  public setSlMainPageState(isMainPage: boolean): void {
    if (!this.isMgrEnable) {
      return;
    }
    if (this.runningLockEnable.isSlMainPage !== isMainPage) {
      this.runningLockEnable.isSlMainPage = isMainPage;
      this.runningLockEnable.updateRunningLockEnable();
      this.checkRunningLockEnableChange();
    }
  }

  /**
   * 设置锁屏覆盖显示状态
   *
   * @param isOccluded true锁屏被覆盖
   */
  public setSlOccluded(isOccluded: boolean): void {
    if (!this.isMgrEnable) {
      return;
    }
    if (this.runningLockEnable.isSlOccluded !== isOccluded) {
      this.runningLockEnable.isSlOccluded = isOccluded;
      this.runningLockEnable.updateRunningLockEnable();
      this.checkRunningLockEnableChange();
    }
  }

  /**
   * 请求加入持有亮屏锁
   *
   * @param hashcode 应用标识
   */
  private requestRunningLock(hashcode: string): void {
    if (this.runningLockSet.has(hashcode)) {
      return;
    }
    // 新增当前显示数据，则刷新亮屏锁状态
    this.runningLockSet.add(hashcode);
    if (this.isCurHashcode(hashcode)) {
      this.updateRunningLockState();
    }
  }

  /**
   * 释放持有亮屏锁
   *
   * @param hashcode 应用标识
   */
  private releaseRunningLock(hashcode: string): void {
    // 当前显示数据清除，则刷新亮屏锁状态
    if (this.runningLockSet.delete(hashcode) && this.isCurHashcode(hashcode)) {
      this.updateRunningLockState();
    }
  }

  /**
   * 释放全部申请亮屏锁的应用标识
   */
  private releaseAllRunningLock(): void {
    this.runningLockSet.clear();
    // 清除当前沉浸应用信息
    this.setCurShowingImmersive();
  }

  private checkRunningLockEnableChange(): boolean {
    // 检测亮屏锁开关切换
    if (this.isRecordLockEnable !== this.runningLockEnable.isRunningLockEnable()) {
      this.isRecordLockEnable = this.runningLockEnable.isRunningLockEnable();
      log.showInfo(`checkRunningLockEnableChange: ${this.isRecordLockEnable}`);
      // 刷新当前亮屏锁状态
      this.updateRunningLockState();
      return true;
    }
    return false;
  }

  private updateRunningLockState(): void {
    // 刷新当前持锁状态
    if (!this.immRunningLock) {
      return;
    }
    // 开启亮屏持锁
    let curHash = this.runningLockEnable.curShowingImmHash;
    if (this.isRecordLockEnable && curHash !== undefined && this.runningLockSet.has(curHash)) {
      log.showInfo(`updateRunningLockState hold: ${curHash}`);
      this.requestHoldRunningLock();
    } else {
      // 释放亮屏持锁
      this.releaseHoldRunningLock();
    }
  }

  private requestHoldRunningLock(): void {
    // 请求持有亮屏锁
    if (!this.immRunningLock) {
      return;
    }
    // 释放后，重新持锁
    try {
      if (this.immRunningLock.isHolding()) {
        this.immRunningLock.unhold();
      }
      this.immRunningLock.hold(MAX_RUNNING_LOCK_TIME_MS);
    } catch (e) {
      log.showError(`requestHoldRunningLock err: ${(e as BusinessError)?.code}`);
    }
  }

  private releaseHoldRunningLock(): void {
    // 释放已持有亮屏锁
    if (!this.immRunningLock) {
      return;
    }
    try {
      if (this.immRunningLock.isHolding()) {
        this.immRunningLock.unhold();
        log.showInfo('releaseHoldRunningLock unhold success.');
      }
    } catch (e) {
      log.showError(`releaseHoldRunningLock err: ${(e as BusinessError)?.code}`);
    }
  }

  private isCurHashcode(hashcode: string): boolean {
    // 当前显示沉浸数据匹配
    return this.runningLockEnable.curShowingImmHash === hashcode;
  }

  private async createRunningLock(): Promise<void> {
    // 创建亮屏锁
    if (this.immRunningLock || this.createRetryCount >= MAX_CREATE_RETRY_COUNT) {
      log.showWarn(`createRunningLock interrupt: ${this.createRetryCount}`);
      return;
    }
    try {
      let lock = await runningLock.create('immRunningLock', 0);
      log.showInfo(`createRunningLock success: ${this.isMgrRunning}`);
      // 异步回调时，若已资源回收，则不使能亮屏锁
      if (this.isMgrRunning) {
        this.immRunningLock = lock;
        // 刷新亮屏锁状态
        this.updateRunningLockState();
      }
    } catch (e) {
      log.showError(`createRunningLock err: ${(e as BusinessError)?.code}`);
      // 亮屏锁创建失败，允许重试
      if (this.isMgrRunning) {
        this.createRetryCount++;
        this.createRunningLock();
      }
    }
  }
}