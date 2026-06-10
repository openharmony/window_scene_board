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
import { HiDfxEventUtil } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import CommonConstants from '@ohos/screenlockcommon/src/main/ets/constants/CommonConstants';
import service, { UnlockResult } from '../refactor/ScreenLockService';
import { Callback } from '@ohos.base';
import osAccount from '@ohos.account.osAccount';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';
import { GlobalStatusCache, StatusCacheConst } from '@ohos/screenlockcommon/src/main/ets/base/GlobalStatusCache';
import { IAMAuthResult, AuthSubType, AuthType } from '../refactor/AccountsModel';
import { AuthType as authType} from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { SystemSwitchUtils } from '@ohos/screenlockcommon/src/main/ets/utils/SystemSwitchUtils';
import { LockEventType, LockOperateResult, SlServerHelper } from '@ohos/screenlockcommon/src/main/ets/utils/SlServerHelper';
import { SlUnlockReportHelper } from '@ohos/screenlockcommon/src/main/ets/record/report/SlUnlockReportHelper';
import { VerifyDataManager } from '@ohos/screenlockcommon';
import { PasswordManager } from '@ohos/screenlockcommon/src/main/ets/manager/PasswordManager';
import { SCBResetPwdManager } from '../common/SCBResetPwdManager';

const TAG = 'ScreenLock-PasswordViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const MAX_REMAIN_TIMES: number = 2;

export { service, UnlockResult, AuthType, AuthSubType };

/**
 * password base
 *
 * @since 2022-06-09
 */
export default class PasswordViewModel {
  public prompt: string | null = null;
  public inhibitInput: boolean = false;
  public isAuthLocked: boolean = false;
  public counter: number = 0;
  public start: number = new Date().getTime();
  public timeoutTask: number | null = null;
  private isCancelTimeOutTask = true;
  private passwordType: string = service.unlockTypeStr;
  private psdIncorrectPsdTryagain: Resource = $r('app.string.psd_incorrect_psd_try_again');
  private psdIncorrectPsdLeftTimes: Resource = $r('app.plural.psd_incorrect_psd_left_times');
  private psdIncorrectWillLocked: Resource = $r('app.string.psd_incorrect_will_locked');
  private psdHardwareError: Resource = $r('app.string.psd_incorrect_hardware_error');
  private psdDrawingCompleted: string = '';
  private isOnCheck: boolean = true;

  constructor() {
    this.ViewModelInit();
  }

  /**
   * init
   */
  ViewModelInit(): void {
    log.showInfo('ViewModelInit');
    this.getScreenDensity();
    this.prompt = null;
    this.passwordType = AuthSubType[VerifyDataManager.getInstance().getVerifyInfo(authType.PIN).authSubType] ??
    CommonConstants.PIN_TYPE_NONE;
    if (this.passwordType === CommonConstants.PIN_TYPE_PATTERN) {
      this.psdIncorrectPsdTryagain = $r('app.string.pattern_psd_incorrect_psd_try_again');
      this.psdIncorrectWillLocked = $r('app.string.pattern_incorrect_will_locked');
    }
  }

  async getScreenDensity() {
    let screenDensity = await ResUtils.getDeviceScreenDensity();
    log.showInfo(`getScreenDensity = ${screenDensity}`);
  }
  
  protected logIAMResult(result: number, remainTimes: number = -1, freezingTime: number = -1): void {
    switch (result) {
      case IAMAuthResult.AUTH_IS_CANCELED:
        log.showWarn('PsdAuth cancel');
        break;
      case IAMAuthResult.INCORRECT_CREDENTIAL:
        log.showWarn(`PsdAuth fail. remainTimes: ${remainTimes}, freezingTime:${freezingTime}`);
        break;
      default:
        log.showError(`PsdAuth exception: ${result}`);
        break;
    }
  }

  /**
   * countdown
   */
  countdown(): void {
    log.showDebug('countdown');
    let authType: AuthType = service.isDomainAuthType() ? AuthType.DOMAIN : AuthType.PIN;
    service.getAuthProperty(authType, async (properties: osAccount.ExecutorProperty) => {
      let promptText: string = '';
      let freezingMillisecond = properties.freezingTime;
      log.showDebug(`countdown freezingMillisecond:${freezingMillisecond}`);
      if (freezingMillisecond && freezingMillisecond > 0) {
        let freezingTimeStr = await this.getFreezingTimeNm(freezingMillisecond);
        if (!!freezingTimeStr) {
          promptText = await ResUtils.getInnerStringNum($r('app.string.psd_try_again_after_time1'), freezingTimeStr);
        }
        this.bindCountdown();
      } else {
        this.counter = 0;
        log.showInfo('countdown clearInterval');
        this.inhibitInput = false;
        this.isAuthLocked = false;
        promptText = '';
      }
      log.showDebug(`countdown promptText:${promptText}`);
      this.prompt = promptText;
    });
  }

  /**
   * Correct the timer difference
   */
  bindCountdown(): void {
    log.showDebug('bind count down!');
    if (this.isCancelTimeOutTask) {
      return;
    }
    let ideal = (this.counter * CommonConstants.INTERVAL);
    let real = (new Date().getTime() - this.start);
    // 倒计时更新时间，刷新start
    if (Math.abs(real) > 60 * CommonConstants.INTERVAL) {
      log.showInfo(`bindCountdown real:${real}`);
      this.start = new Date().getTime() - ideal;
      real = (new Date().getTime() - this.start);
    }
    this.counter++;
    let diff = (real - ideal);
    this.timeoutTask = setTimeout(this.countdown.bind(this), CommonConstants.INTERVAL - diff);
  }

  /**
   * Prompt txt show
   *
   * @param remainTimes  remain Times
   * @param freezingTime freezing Time
   * @param callback callback
   */
  async changePrompt(remainTimes: number | undefined = undefined, freezingTime: number | undefined = undefined,
    callback: Function, nextPhaseFreezingTime: number = 0,
    psdDrawingCompleted: string = ''): Promise<void> {
    if (!PasswordManager.getInstance().isHardwareError) {
      this.changePromptInner(remainTimes, freezingTime, callback, nextPhaseFreezingTime, psdDrawingCompleted);
      return;
    }
    service.getAuthProperty(AuthType.PIN, (properties: osAccount.ExecutorProperty) => {
      let remain = properties?.remainTimes ?? remainTimes;
      let freezing = properties?.freezingTime ?? freezingTime;
      this.changePromptInner(remain, freezing, callback, nextPhaseFreezingTime, psdDrawingCompleted);
    });
  }

  private async changePromptInner(remainTimes: number | undefined = undefined,
    freezingTime: number | undefined = undefined, callback: Function, nextPhaseFreezingTime: number = 0,
                     psdDrawingCompleted: string = ''): Promise<void> {
    log.showError(`changePrompt remainTimes:${remainTimes} freezingTime:${freezingTime}`);
    this.psdDrawingCompleted = psdDrawingCompleted;
    let promptText: string = (this.passwordType !== CommonConstants.PIN_TYPE_MIX) ?
    ResUtils.getInnerString(this.psdIncorrectPsdTryagain) :
    ResUtils.getInnerString($r('app.string.psd_incorrect_psd_try_again_mix'));
    if (remainTimes && 0 < remainTimes && remainTimes <= MAX_REMAIN_TIMES) {
      if (nextPhaseFreezingTime > 0) {
        this.getWillLockTxt(remainTimes, nextPhaseFreezingTime, callback);
        return;
      } else {
        promptText = (this.passwordType !== CommonConstants.PIN_TYPE_MIX) ?
          await ResUtils.getInnerPlural(this.psdIncorrectPsdLeftTimes, remainTimes) :
          await ResUtils.getInnerPlural($r('app.plural.psd_incorrect_psd_left_times_mix'), remainTimes);
      }
    } else if (0 === remainTimes) {
      if (freezingTime && freezingTime > 0) {
        this.inhibitInput = true;
        this.isAuthLocked = true;
        promptText = await ResUtils.getInnerStringNum($r('app.string.psd_try_again_after_time1'), await this.getFreezingTimeNm(freezingTime));
        this.isCancelTimeOutTask = false;
        this.bindCountdown();
      }
    }
    this.prompt = promptText;
    if (PasswordManager.getInstance().isHardwareError && remainTimes && remainTimes > 0) {
      this.prompt = ResUtils.getInnerString(this.psdHardwareError);
    }
    if (AccessibilityUtil.isAccessibilityMode() && !this.isOnCheck) {
      AccessibilityUtil.sendAccessibility(`${this.psdDrawingCompleted},${this.prompt}`);
    }
    this.updateStorage(callback);
    //notify the base service that the unlock is fail
    if (SystemSwitchUtils.isUseNewScreenLock()) {
      SlServerHelper.getInstance().sendScreenLockEvent(LockEventType.UNLOCK_SCREEN_RESULT, LockOperateResult.Fail);
    } else {
      service.notifyUnlockScreenResult(UnlockResult.Fail);
      service.unlockReport(osAccount.AuthType.PIN, UnlockResult.Fail);
    }
    log.showInfo('changePrompt end');
  }

  /**
   * lock txt show
   *
   * @param remainTimes  remain Times
   * @param freezingTime freezing Time
   * @param callback callback
   */
  async getWillLockTxt(remainTimes: number, freezingTime: number, callback: Function) {
    let freezingTimeNm = await this.getFreezingTimeNm(freezingTime);
    let lockTxt: string = await ResUtils.getInnerPlural($r('app.plural.psd_incorrect_will_locked1'), remainTimes);
    let promptText = ResUtils.getInnerStringNumS(this.psdIncorrectWillLocked, lockTxt, freezingTimeNm);
    this.prompt = promptText;
    if (PasswordManager.getInstance().isHardwareError) {
      this.prompt = ResUtils.getInnerString(this.psdHardwareError);
    }
    this.updateStorage(callback);
    //notify the base service that the unlock is fail
    log.showInfo('changePrompt end');
    if (AccessibilityUtil.isAccessibilityMode()) {
      AccessibilityUtil.sendAccessibility(`${this.psdDrawingCompleted},${this.prompt}`);
    }
    if (SystemSwitchUtils.isUseNewScreenLock()) {
      SlServerHelper.getInstance().sendScreenLockEvent(LockEventType.UNLOCK_SCREEN_RESULT, LockOperateResult.Fail);
    } else {
      service.notifyUnlockScreenResult(UnlockResult.Fail);
    }
  }

  /**
   * Remaining time
   *
   * @param freezingMillisecond freezing Millisecond
   */
  async getFreezingTimeNm(freezingMillisecond: number): Promise<string> {
    let minute = Math.floor(freezingMillisecond / (60 * 1000));
    let second = Math.round((freezingMillisecond % (60 * 1000)) / 1000);
    log.showDebug(`getFreezingTimeNm start, getFreezingTimeNm minute:${minute}, getFreezingTimeNm second:${second}`);
    let timeName = '';
    if (minute !== 0) {
      let strTipMinute: string = await ResUtils.getInnerPlural($r('app.plural.psd_incorrect_will_locked2'), minute);
      timeName += strTipMinute;
    }
    if (second !== 0) {
      if (!!timeName) {
        timeName += ' ';
      }
      let strTipSecond: string = await ResUtils.getInnerPlural($r('app.plural.psd_incorrect_will_locked3'), second);
      timeName += strTipSecond;
    }
    log.showDebug(`getFreezingTimeNm end ${timeName}`);
    return timeName;
  }

  updateStorage(callback: Function): void {
    log.showDebug('updateStorage');
    this.isOnCheck = false;
    callback();
  }

  /**
   * Check the freezing time. If freezing time > 0, begin to count down
   *
   * @param callback callback
   */
  checkFreezingTime(callback: Callback<void>, notFreezingCallback?: Callback<void>): void {
    log.showInfo('checkFreezingTime');
    if (!this.isCancelTimeOutTask || !!this.timeoutTask) {
      log.showInfo('clearTimeout in check');
      this.clearTimeOutTask();
    }
    this.start = new Date().getTime();
    let authType: AuthType = service.isDomainAuthType() ? AuthType.DOMAIN : AuthType.PIN;
    service.getAuthProperty(authType, (properties: osAccount.ExecutorProperty) => {
      log.showInfo(`checkFreezingTime getAuthProperty param: authType ${authType}, properties`);
      this.isOnCheck = true;
      if (properties.freezingTime && properties.freezingTime > 0) {
        this.inhibitInput = true;
        this.isAuthLocked = true;
        //Clear the entered password
        this.changePromptInner(properties.remainTimes, properties.freezingTime, callback);
      } else {
        this.inhibitInput = false;
        this.isAuthLocked = false;
        notFreezingCallback?.();
        this.countDownEndHandlePrompt(properties.freezingTime, properties.remainTimes);
      }
    });
  }

  /**
   * PC端倒计时结束后，从重置密码页，返回来，处理倒计时提示
   *
   */
  protected countDownEndHandlePrompt(freezingTime: number | undefined, remainTimes: number | undefined): void {}

  /**
   * 查询当前PIN校验的状态
   *
   */
  public GetPinAuthProperty(): void {
    service.getAuthProperty(osAccount.AuthType.PIN, (properties: osAccount.ExecutorProperty) => {
      if (properties.remainTimes === undefined) {
        log.showInfo('remainTimes is undefined');
        return;
      }
      SCBResetPwdManager.getInstance().setResetPwdEntry(properties.remainTimes < 3, 'pwdvm');
      log.showInfo(`getPinAuthProperty, remainTimes(${properties.remainTimes}) , freezingTime(${properties.freezingTime}) `);
    });
  }

  clearTimeOutTask(): void {
    log.showInfo('clearTimeOutTask');
    if (!!this.timeoutTask) {
      clearTimeout(this.timeoutTask);
      this.timeoutTask = null;
    }
    this.counter = 0; // 不置零会导致delay很大，任务启动的较准时延错误
    this.isCancelTimeOutTask = true;
  }

  clearPrompt(): void {
    this.prompt = null;
  }

  /**
   * 切换到密码界面打点 不做上报!!
   */
  public switchToPwdPageReport(): void {
    let endSlidingUnlock: number = new Date().getTime();
    let startSlidingUnlock: number = AppStorage.get<number>(CommonConstants.START_SLIDING_UNLOCK_KEY) ?? 0;
    let slidingUnlockTime = endSlidingUnlock - startSlidingUnlock;
    HiDfxEventUtil.reportSwitchToPassword(AppStorage.get<string>(CommonConstants.PASSWORD_TYPE_KEY) ?? 'NONE',
      slidingUnlockTime);
  }

  /**
   * password page back to dynamic effect
   *
   * @returns true: start playing
   */
  public isPwdBackEffect(): boolean {
    return GlobalStatusCache.getInstance().getStatus(StatusCacheConst.IS_PLAY_PWD_BACK_ANIMATION, false) as boolean;
  }

  public getPwdViewScale(isFullShowPwd: boolean, psdViewScale: number):
    ScaleOptions {
    if (isFullShowPwd) {
      return {x: psdViewScale, y: psdViewScale};
    } else {
      return {x: 1, y: 1};
    }
  }

  public getPwdViewOpacity(isFullShowPwd: boolean, psdViewOpacity: number): number {
    if (isFullShowPwd) {
      return psdViewOpacity;
    } else {
      return 1;
    }
  }

  onKeyPress(index: number, updateCallback: Callback<void>, authSuccessCallBack?: Callback<void>,
    authFailCallBack?: Callback<void>, lockedCallback?: Callback<number>): void {
  }

  onKeyDelPress(index: number, callback: Callback<void>): void {
  }

  onKeyLongDelPress(index: number, callback: Callback<void>): void {
  }
}
