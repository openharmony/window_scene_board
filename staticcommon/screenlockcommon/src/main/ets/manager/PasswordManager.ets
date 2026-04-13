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
import { AuthSubType, AuthType } from '../utils/AccountHelper';
import { AcquireResultCode } from '../base/ScreenLockVerifyVm';
import {
  AcquireExtraInfo,
  ScreenLockVerifyService,
  VerifyStateListener,
  PasswordAcquireCode
} from '../services/ScreenLockVerifyService';
import { VerifyDataManager, VerifyInfo } from './VerifyDataManager';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import CountDownTimer, { CountDownTimerListener } from '../utils/CountDownTimer';
import { AbstractObserverManager } from '../base/AbstractObserverManager';

const TAG = 'PasswordManager';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const MAX_REMAIN_TIMES: number = 2;

/**
 * 密码错误提示语监听
 */
export interface PasswordChangeListener {

  /**
   * 密码错误提示改变时回调
   */
  onPasswordTipsChange?: (passwordTips: string) => void;

  /**
   * 密码增删时回调
   */
  onPasswordChange?: (isAdd: boolean, passwordLength: number) => void;

  /**
   * 密码禁用状态改变时回调
   */
  onDisableChange?: (isDisableInput: boolean) => void;
}

/**
 * 密码提示语管理
 */
export class PasswordManager extends AbstractObserverManager<PasswordChangeListener> {
  private static sInstance: PasswordManager;
  private _isHardwareError: boolean = false;

  /**
   * 倒计时管理
   */
  private _countDownTimer: CountDownTimer = new CountDownTimer();

  public get countDownTimer(): CountDownTimer {
    return this._countDownTimer;
  }


  /**
   * 错误密码提示
   */
  private _errorTips: string = '';

  private readonly _verifyStateListener: VerifyStateListener = {
    onAcquireInfo: (authType: AuthType, module: number, acquire: number, extraInfo?: AcquireExtraInfo): void => {
      if (authType !== AuthType.PIN) {
        return;
      }
      if (acquire === PasswordAcquireCode.PASSWORD_ACQUIRE_RESULT) {
        this.isHardwareError = extraInfo?.authResult === AcquireResultCode.HARDWARE_ERROR;
      }
    }
  };

  private readonly _countDownListener: CountDownTimerListener = {
    onTick: this.handleFreezeTimeTick.bind(this),
    onFinish: this.handleFreezeFinish.bind(this)
  };

  public static getInstance(): PasswordManager {
    if (PasswordManager.sInstance == null) {
      PasswordManager.sInstance = new PasswordManager();
    }
    return PasswordManager.sInstance;
  }

  public get isHardwareError(): boolean {
    return this._isHardwareError;
  }

  public set isHardwareError(isHardwareError: boolean) {
    if (isHardwareError !== this._isHardwareError) {
      this._isHardwareError = isHardwareError;
      log.showWarn(`isHardwareError : ${isHardwareError}`);
    }
  }

  public set passwordErrorTips(errorTips: string) {
    if (this._errorTips !== errorTips) {
      this._errorTips = errorTips;
      log.showWarn(`update password error tips: ${this._errorTips}`);
      this.broadcastDataChange(observer => observer?.onPasswordTipsChange?.(this._errorTips));
    }
  }

  public get passwordErrorTips(): string {
    return this._errorTips;
  }

  public clearErrorTips(): void {
    this.passwordErrorTips = '';
    if (!VerifyDataManager.getInstance().getVerifyInfo(AuthType.FINGERPRINT).isSupportUnlock) {
      this._countDownTimer.stop();
    }
  }

  protected doInit(): void {
    this._countDownTimer.registerObserver(this._countDownListener);
    ScreenLockVerifyService.getInstance().registerObserver(this._verifyStateListener);
  }

  protected doRelease(): void {
    ScreenLockVerifyService.getInstance().unRegisterObserver(this._verifyStateListener);
    this._countDownTimer.stop();
    this._countDownTimer.unRegisterObserver(this._countDownListener);
  }

  private getDefaultErrorTips(authSubType: AuthSubType): string {
    if (authSubType === AuthSubType.PIN_MIXED) {
      return ResUtils.getInnerString($r('app.string.psd_incorrect_psd_try_again_mix'));
    } else if (authSubType === AuthSubType.PIN_PATTERN) {
      return ResUtils.getInnerString($r('app.string.pattern_psd_incorrect_psd_try_again'));
    } else {
      return ResUtils.getInnerString($r('app.string.psd_incorrect_psd_try_again'));
    }
  }

  private getDefaultWillLockTips(authSubType: AuthSubType): Resource {
    if (authSubType === AuthSubType.PIN_PATTERN) {
      return $r('app.string.pattern_incorrect_will_locked');
    } else {
      return $r('app.string.psd_incorrect_will_locked');
    }
  }

  private getDefaultRemainTips(authSubType: AuthSubType): Resource {
    if (authSubType === AuthSubType.PIN_MIXED) {
      return $r('app.plural.psd_incorrect_psd_left_times_mix');
    } else {
      return $r('app.plural.psd_incorrect_psd_left_times');
    }
  }

  private handleFreezeTimeTick(millisUntilFinished: number): void {
    let freezingTimeStr = CountDownTimer.formatTime(millisUntilFinished);
    if (!!freezingTimeStr) {
      this.passwordErrorTips = ResUtils.getInnerStringNumS($r('app.string.psd_try_again_after_time1'), freezingTimeStr);
    }
  }

  private handleFreezeFinish(): void {
    this.clearErrorTips();
    this._countDownTimer.stop();
  }

  public updatePasswordErrorTip(verifyInfo?: VerifyInfo): void {
    if (!verifyInfo || verifyInfo.authType !== AuthType.PIN) {
      verifyInfo = VerifyDataManager.getInstance().getVerifyInfo(AuthType.PIN);
    }
    let errorTips: string = this.getDefaultErrorTips(verifyInfo.authSubType);
    if (verifyInfo.remainTimes === 0 && verifyInfo.freezingTime > 0) {
      // 密码已禁用，倒计时提示用户
      errorTips = ResUtils.getInnerStringNumS($r('app.string.psd_try_again_after_time1'),
        CountDownTimer.formatTime(verifyInfo.freezingTime));
      this._countDownTimer.start(verifyInfo.freezingTime);
    } else if (this._isHardwareError && verifyInfo.remainTimes > 0) {
      // 芯片故障
      errorTips = ResUtils.getInnerString($r('app.string.psd_incorrect_hardware_error'));
    } else if (verifyInfo.remainTimes > 0 && verifyInfo.remainTimes <= MAX_REMAIN_TIMES) {
      if (verifyInfo.nextPhaseFreezingTime > 0) {
        // 剩余认证次数小于等于2，提示用户下一次禁用时长
        let remainStr =
          ResUtils.getInnerPluralByResource($r('app.plural.psd_incorrect_will_locked1'), verifyInfo.remainTimes);
        errorTips = ResUtils.getInnerStringNumS(this.getDefaultWillLockTips(verifyInfo.authSubType), remainStr,
          CountDownTimer.formatTime(verifyInfo.nextPhaseFreezingTime));
      } else {
        // 无下一次禁用时长，提示用户剩余认证次数
        errorTips =
          ResUtils.getInnerPluralByResource(this.getDefaultRemainTips(verifyInfo.authSubType), verifyInfo.remainTimes);
      }
    }
    this.passwordErrorTips = errorTips;
  }

  /**
   * 密码长度改变时回调
   */
  public onPasswordChange(isAdd: boolean, passwordLength: number): void {
    this.broadcastDataChange((observer) => observer?.onPasswordChange?.(isAdd, passwordLength));
  }

  /**
   * 密码禁用状态改变时回调
   */
  public onDisableChange(isDisableInput: boolean): void {
    this.broadcastDataChange((observer) => observer?.onDisableChange?.(isDisableInput));
  }
}