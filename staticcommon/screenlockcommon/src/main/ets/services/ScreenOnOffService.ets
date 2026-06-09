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

import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, EvtBus, HiDfxEventUtil, OuterHomeCallbackEvent } from '@ohos/frameworkwrapper';
import { SCBScreenSessionManager, SCBTransitionManager, SCBWindowRotateController } from '@ohos/windowscene';
import { AbstractObserverManager } from '../base/AbstractObserverManager';
import screenOnOffMediator from '../interface/ScreenOnOffMediator';
import { PowerState, PowerStateChangeListener, PowerStateManager } from '../manager/PowerStateManager';
import { ScreenLockStateManager } from '../manager/ScreenLockStateManager';
import { PowerUtils } from '../utils/PowerUtils';
import { LockEventType, SlServerHelper } from '../utils/SlServerHelper';
import {  ScreenLockUnlockService } from './ScreenLockUnLockService';

const TAG = 'ScreenOnOffService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const CODE_BEGIN_WAKE_UP: number = 3;
const EVENT_DATA_BEGIN_WAKE_UP: string = 'BEGIN_WAKE_UP';
const STATE_CHANGE_REASON_PRE_BRIGHT: number = 26;
const STATE_CHANGE_REASON_PRE_BRIGHT_AUTH_FAIL_SCREEN_OFF: number = 29;
const STATE_CHANGE_REASON_AOD_SLIDING: number = 40;
const STATE_CHANGE_REASON_PROXIMITY: number = 32;

/**
 * WakeUp原因
 */
export enum WakeUpReason {
  /**
   * 底部上滑亮屏
   */
  AOD_SLIDING,

  /**
   * 接近光
   */
  PROXIMITY,

  /**
   * 其他亮屏
   */
  OTHER,
}

/**
 * Sleep原因
 */
export enum SleepReason {
  /**
   * 接近光
   */
  PROXIMITY,

  /**
   * 其他亮屏
   */
  OTHER,
}

/**
 * 亮灭屏监听
 */
export interface ScreenOnOffListener {
  /**
   * 通知预亮屏处理
   */
  onPreBright?: () => void;

  /**
   * 通知预亮屏失败灭屏处理
   */
  onPreBrightFailSleep?: () => void;

  /**
   * 通知开始亮屏处理
   *
   * @param reason 亮屏原因
   */
  onBeginWakeUp?: (reason: WakeUpReason) => void;

  /**
   * 开始点亮屏幕
   */
  onBeginDisplayOn?: () => void;

  /**
   * 屏幕点亮
   */
  onEndDisplayOn?: () => void;

  /**
   * 开始熄屏前回调
   */
  onPreBeginSleep?: (reason: SleepReason) => void;

  /**
   * 开始熄屏
   */
  onBeginSleep?: (reason: SleepReason) => void;

  /**
   * 屏幕熄灭结束
   */
  onEndDisplayOff?: () => void;

  /**
   * 熄屏结束
   */
  onEndSleep?: () => void;

  /**
   * 屏幕亮灭变化通知
   *
   * @param isScreenOn 屏幕是否亮
   */
  onScreenOnChange?: (isScreenOn: boolean) => void;

  /**
   * 屏幕亮灭变化通知
   *
   * @param isIntoSleep 是否处于熄屏过程中
   */
  onIntoSleepChange?: (isIntoSleep: boolean) => void;
}

/**
 * 定制动效管理
 */
export interface CustomScreenOffAnimationManager {
  /**
   * 处理定制灭屏事件业务
   *
   * @param powerState 电源状态
   */
  handlePowerEventNext(powerState: string): Promise<void>;

  /**
   * 处理定制电源Begin Sleep事件
   *
   * @param callback 定制需要回调的callback
   */
  handleBeginSleep(callback: () => void): void;
}

/**
 * 亮灭屏服务
 */
export class ScreenOnOffService extends AbstractObserverManager<ScreenOnOffListener> {
  public static readonly ENABLE_ROTATE_REASON: string = TAG;
  private static sInstance: ScreenOnOffService;

  public static getInstance(): ScreenOnOffService {
    if (ScreenOnOffService.sInstance == null) {
      ScreenOnOffService.sInstance = new ScreenOnOffService();
    }
    return ScreenOnOffService.sInstance;
  }

  private _powerStateChangeListener: PowerStateChangeListener = {
    onStateChange: (powerState: string, reason: number) => {
      this.handlePowerEvent(powerState, reason);
    }
  };

  /**
   * 是否亮屏
   */
  private _isScreenOn: boolean = true;

  /**
   * 是否处于熄屏过程中（从BEGIN_SLEEP到END_SLEEP)
   */
  private _isIntoSleep: boolean = false;

  private _customAnimation?: CustomScreenOffAnimationManager;

  /**
   * 灭屏原因
   * 在每次灭屏时候刷新，亮屏时候获取的是上次灭屏值
   */
  private _sleepReason: SleepReason = SleepReason.OTHER;

  private constructor() {
    super();
  }

  public get sleepReason(): SleepReason {
    return this._sleepReason;
  }

  public get isScreenOn(): boolean {
    return this._isScreenOn;
  }

  /**
   * 设置定制灭屏动效
   *
   * @param customAnimation 定制动效
   */
  public setCustomAnimation(customAnimation: CustomScreenOffAnimationManager | undefined): void {
    this._customAnimation = customAnimation;
  }

  private set isScreenOn(isScreenOn: boolean) {
    if (this._isScreenOn !== isScreenOn) {
      this._isScreenOn = isScreenOn;
      log.showInfo(`isScreenOn to: ${isScreenOn}`);
      this.broadcastDataChange(listener => listener?.onScreenOnChange?.(isScreenOn));
    }
  }

  public get isIntoSleep(): boolean {
    return this._isIntoSleep;
  }

  private set isIntoSleep(isIntoSleep: boolean) {
    if (this._isIntoSleep !== isIntoSleep) {
      this._isIntoSleep = isIntoSleep;
      log.showInfo(`isIntoSleep to: ${isIntoSleep}`);
      this.broadcastDataChange(listener => listener?.onScreenOnChange?.(isIntoSleep));
    }
  }

  protected doInit(): void {
    log.showInfo('doInit');

    // 电源监听初始化
    PowerStateManager.getInstance().init();

    // 注册电源事件监听
    PowerStateManager.getInstance().registerObserver(this._powerStateChangeListener);
  }

  protected doRelease(): void {
    log.showInfo('doRelease');

    // 电源监听释放
    PowerStateManager.getInstance().release();

    // 注销电源事件监听
    PowerStateManager.getInstance().unRegisterObserver(this._powerStateChangeListener);
  }

  private handlePowerEvent(powerState: string, reason: number): void {
    if (this._customAnimation) {
      this.handlePowerEventCustom(powerState, reason);
    } else {
      this.handlePowerEventNext(powerState, reason);
    }
  }

  private async handlePowerEventCustom(powerState: string, reason: number): Promise<void> {
    await this._customAnimation?.handlePowerEventNext(powerState);
    this.handlePowerEventNext(powerState, reason);
  }

  private handlePowerEventNext(powerState: string, reason: number): void {
    log.showInfo(`powerState: ${powerState}, reason: ${reason}`);
    switch (powerState) {
      case PowerState.BEGIN_WAKE_UP:
        this.isIntoSleep = false; // 打断场景下，恢复
        this.handleBeginWakeUp(reason);
        screenOnOffMediator.setScreenOn(true);
        break;
      case PowerState.BEGIN_DISPLAY_ON:
        this.handleBeginDisplayOn(reason);
        break;
      case PowerState.END_DISPLAY_ON:
        this.isScreenOn = true;
        this.handleEndDisplayOn(reason);
        screenOnOffMediator.setScreenOnEnd(true);
        break;
      case PowerState.BEGIN_SLEEP:
        // 请求锁屏
        ScreenLockUnlockService.getInstance().requestLock();
        this.isIntoSleep = true;
        this.handleBeginSleep(reason);
        break;
      case PowerState.END_SLEEP:
        this.isIntoSleep = false;
        this.handleEndSleep(reason);
        screenOnOffMediator.setScreenOnEnd(false);
        screenOnOffMediator.setScreenOn(false);
        break;
      case PowerState.END_DISPLAY_OFF:
        this.isScreenOn = false;
        this.handleEndDisplayOff(reason);
        break;
    }
  }

  private handleBeginWakeUp(reason: number): void {
    this.setEnableRotate(true);
    // 亮屏时重置BeginSleepStart为false
    AppStorage.setOrCreate('isBeginSleepStart', false);
    switch (reason) {
      case STATE_CHANGE_REASON_PRE_BRIGHT:
        log.showDebug('reason is STATE_CHANGE_REASON_PRE_BRIGHT.');
        this.broadcastDataChange(listener => listener?.onPreBright?.());
        break;
      case STATE_CHANGE_REASON_AOD_SLIDING:
        log.showDebug('reason is STATE_CHANGE_REASON_AOD_SLIDING.');
        this.handleNormalBeginWakeUp(WakeUpReason.AOD_SLIDING);
        break;
      case STATE_CHANGE_REASON_PROXIMITY:
        log.showDebug('reason is STATE_CHANGE_REASON_PROXIMITY.');
        this.handleNormalBeginWakeUp(WakeUpReason.PROXIMITY);
        break;
      default:
        log.showDebug(`reason is ${reason}.`);
        this.handleNormalBeginWakeUp(WakeUpReason.OTHER);
        break;
    }
  }

  private handleNormalBeginWakeUp(wakeUpReason: WakeUpReason): void {
    // 外部依赖，AOD依赖此设置，否则无法正常启动AOD
    screenOnOffMediator.ableToSendScreenOffNotifyEvent = false;
    // 外部依赖，outerHome依赖此设置，否则外屏时间不会刷新。如果outerHome自己监听亮屏广播，则会有时间跳变的问题。
    this.sendBeginWakeUpToOuterHome();

    this.rotateFoldFullScreen();
    this.broadcastDataChange(listener => listener?.onBeginWakeUp?.(wakeUpReason));
  }

  /**
   * 向OuterHome发送begin wake up消息
   */
  public sendBeginWakeUpToOuterHome(): void {
    if (DeviceHelper.isSmallFoldProduct() && DeviceHelper.isSubDisplayMode()) {
      log.showInfo('sendBeginWakeUpToOuterHome');
      let outerHomeCallbackEvent = new OuterHomeCallbackEvent(CODE_BEGIN_WAKE_UP, EVENT_DATA_BEGIN_WAKE_UP);
      EvtBus.post(OuterHomeCallbackEvent, outerHomeCallbackEvent);
    }
  }

  private setEnableRotate(enableRotate: boolean): void {
    try {
      const session = SCBScreenSessionManager.getInstance().getMainScreenSession();
      if (session) {
        session.setEnableRotate(enableRotate, ScreenOnOffService.ENABLE_ROTATE_REASON);
      }
    } catch (error) {
      log.showError(`setEnableRotate fail. code ${error.code}`);
    }
  }

  /**
   * 由于灭屏后，AOD显示期间，Sceneboard窗口不可旋转。
   * 如果用户在灭屏以后旋转了设备，
   * 在收到亮屏事件以后需要恢复窗口到当前设备状态
   */
  private rotateFoldFullScreen(): void {
    try {
      if (DeviceHelper.isPcNot2in1Device() || DeviceHelper.isBarPhone() ||
      DeviceHelper.isWatch()) {
        return;
      }
      const session = SCBScreenSessionManager.getInstance().getMainScreenSession();
      if (!CommonUtils.isInvalid(session) && SCBWindowRotateController.getInstance().isDesktopRotatable()) {
        log.showInfo('rotateFoldFullScreen.');
        session.rotationChangeEntry(session.sensorScreenProperty.rotation, 'aod exit');
      }
    } catch (error) {
      log.showError(`rotateFoldFullScreen fail. code ${error.code}`);
    }
  }

  private handleBeginDisplayOn(_reason: number): void {
    log.showDebug('notifyBeginScreenOnTransition');
    SCBTransitionManager.getInstance().notifyBeginScreenOnTransition();
    if (ScreenLockStateManager.getInstance().isPageShow || !ScreenLockStateManager.getInstance().isLocked) {
      // 亮屏时：锁屏已经绘制完成或者锁屏已经解锁，直接通知DMS，不阻塞屏幕上电
      SlServerHelper.getInstance().sendScreenLockEvent(LockEventType.SCREEN_DRAW_DONE);
    }

    this.broadcastDataChange(listener => listener?.onBeginDisplayOn?.());

    // 外部依赖，状态栏依赖
    AppStorage.setOrCreate('isScreenOnStart', true);
  }

  private handleEndDisplayOn(_reason: number): void {
    log.showDebug('notifyEndScreenOnTransition');
    SCBTransitionManager.getInstance().notifyEndScreenOnTransition();
    this.broadcastDataChange(listener => listener?.onEndDisplayOn?.());
    HiDfxEventUtil.reportScreenOnEvent();
  }

  private handleBeginSleep(reason: number): void {
    if (SlServerHelper.getInstance().isScreenLockDisabled()) {
      log.showInfo(`isScreenLockDisabled, no need do screen lock.`);
      SCBScreenSessionManager.getInstance().notifyScreenLockEvent(PowerUtils.NOTIFY_OFF_SCREEN_CLOSE_LCD);
      return;
    }
    this.setEnableRotate(false);
    this._sleepReason = this.convertSleepReason(reason);
    this.broadcastDataChange(listener => listener?.onPreBeginSleep?.(this._sleepReason));

    AppStorage.setOrCreate('isBeginSleepStart', true);
    // 外部依赖
    AppStorage.setOrCreate('isShortcutKeyPanelShow', false);

    switch (reason) {
      case STATE_CHANGE_REASON_PRE_BRIGHT_AUTH_FAIL_SCREEN_OFF:
        log.showDebug('reason is STATE_CHANGE_REASON_PRE_BRIGHT_AUTH_FAIL_SCREEN_OFF.');
        this.broadcastDataChange(listener => listener?.onPreBrightFailSleep?.());
        break;
      case STATE_CHANGE_REASON_PROXIMITY:
        log.showDebug('The screen is powered off without locking the screen when the proximity sensor is off.');
        SCBScreenSessionManager.getInstance().notifyScreenLockEvent(PowerUtils.NOTIFY_OFF_SCREEN_CLOSE_LCD);
        break;
      default:
        this.handleBeginSleepDefaultReason(this._sleepReason);
        break;
    }
  }

  private handleBeginSleepDefaultReason(sleepReason: SleepReason): void {
    // 外部依赖，AOD依赖此设置，否则无法正常启动AOD
    screenOnOffMediator.ableToSendScreenOffNotifyEvent = true;
    if (this._customAnimation) {
      this._customAnimation.handleBeginSleep(() => {
        this.broadcastDataChange(listener => listener?.onBeginSleep?.(sleepReason));
      });
    } else {
      this.broadcastDataChange(listener => listener?.onBeginSleep?.(sleepReason));
    }
  }

  private convertSleepReason(reason: number): SleepReason {
    return reason === STATE_CHANGE_REASON_PROXIMITY ? SleepReason.PROXIMITY : SleepReason.OTHER;
  }

  private handleEndDisplayOff(_reason: number): void {
    log.showDebug('handleEndDisplayOff');
    this.broadcastDataChange(listener => listener?.onEndDisplayOff?.());
  }

  private handleEndSleep(_reason: number): void {
    this.broadcastDataChange(listener => listener?.onEndSleep?.());
    // 外部依赖，状态栏依赖
    AppStorage.setOrCreate('isScreenOnStart', false);
    AppStorage.setOrCreate('isBeginSleepStart', false);
    HiDfxEventUtil.reportScreenOffEvent();
  }
}