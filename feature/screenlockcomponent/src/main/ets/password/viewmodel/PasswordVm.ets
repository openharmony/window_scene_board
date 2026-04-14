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

import { LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import { AccountHelper, AuthType, AuthSubType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { CoreStateType, CoreStateTypeUtils } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { vibratorMgr, VibratorManagerEffect } from '@ohos/screenlockcommon/src/main/ets/manager/VibratorManager';
import {
  ScreenLockVerifyService,
  VerifyResult,
  VerifyStateListener
} from '@ohos/screenlockcommon/src/main/ets/services/ScreenLockVerifyService';
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';
import Constants from '../../common/Constants';
import { HiDfxEventUtil } from '@ohos/frameworkwrapper';
import { PasswordManager } from '@ohos/screenlockcommon/src/main/ets/manager/PasswordManager';
import {
  VerifyDataChangeListener,
  VerifyDataManager,
  VerifyInfo
} from '@ohos/screenlockcommon/src/main/ets/manager/VerifyDataManager';
import { BaseViewVm } from '@ohos/screenlockcommon/src/main/ets/base/ScreenLockVmViewInf';
import { AccessibilityUtil, PowerUtils } from '@ohos/screenlockcommon';
import { ResUtils } from '@ohos/windowscene';

const TAG = 'PasswordVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 锁屏密码VM基类
 */
export class ScreenLockPasswordVm extends BaseViewVm {
  /**
   * 用户输入密码
   */
  protected _password: string[] = [];
  /**
   * 密码禁用状态
   */
  private _disableInput: boolean = false;
  /**
   * 密码错误动效禁用状态
   */
  private _disableInputWhenAnim: boolean = false;
  /**
   * 是否点击确认键（包括软键盘，实体键盘，无障碍）
   */
  private _isSubmit: boolean = false;
  /**
   * 认证监听
   */
  private _verifyListener: VerifyStateListener = {
    onVerifyResult: (authType: AuthType, verifyResult: VerifyResult): void => {
      if (authType !== AuthType.PIN) {
        return;
      }
      log.showInfo(`${this.verifyInfo.authSubType} PsdAuth end: ${VerifyResult[verifyResult]}`);
      this.disableInput = false;
      switch (verifyResult) {
        case VerifyResult.SUCCESS:
          this.onVerifySuccess();
          break;
        case VerifyResult.FAIL:
          this.onVerifyFail();
          break;
        default:
          break;
      }
      this.isSubmit = false;
      Trace.end(Trace.CORE_METHOD_PSD_AUTH);
    }
  };
  private readonly _verifyDataChangeListener: VerifyDataChangeListener = {
    onVerifyInfoChange: (authType: AuthType, verifyInfo: VerifyInfo): void => {
      if (authType !== AuthType.PIN) {
        return;
      }
      // 进入密码界面时，如果密码禁用，更新提示语
      if (verifyInfo.isStateLocked) {
        this.updateErrorTips();
        this.disableInput = true;
      } else {
        this.disableInput = false;
        PasswordManager.getInstance().countDownTimer.stop();
      }
    }
  };

  constructor(persistentId: number) {
    super(persistentId);
  }

  protected doInit(params?: object): void {
    log.showInfo('doInit');
    this.clearPassword();
    // 进入密码界面, 更新当前认证信息, 刷新禁用时长
    VerifyDataManager.getInstance().updateVerifyData();
    this.disableInput = this.verifyInfo.isStateLocked;
    ScreenLockVerifyService.getInstance().registerObserver(this._verifyListener);
    VerifyDataManager.getInstance().registerObserver(this._verifyDataChangeListener);
  }

  protected doRelease(): void {
    log.showInfo('doRelease');
    PasswordManager.getInstance().clearErrorTips();
    ScreenLockVerifyService.getInstance().unRegisterObserver(this._verifyListener);
    VerifyDataManager.getInstance().unRegisterObserver(this._verifyDataChangeListener);
  }

  /**
   * 更新错误密码提示语，需要考虑非定长密码场景静默校验
   */
  protected updateErrorTips(): void {
    PasswordManager.getInstance().updatePasswordErrorTip(this.verifyInfo);
  }

  protected sendAccessibilityErrorTips(): void {
    // 无障碍播报
    if (AccessibilityUtil.isAccessibilityMode()) {
      let accessibilityStr: string = this.verifyInfo.authSubType !== AuthSubType.PIN_PATTERN ?
      PasswordManager.getInstance().passwordErrorTips :
        (ResUtils.getInnerString($r('app.string.pattern_psd_drawing_completed')) + ',' +
        PasswordManager.getInstance().passwordErrorTips)
      AccessibilityUtil.sendAccessibility(accessibilityStr);
    }
  }

  /**
   * 密码认证成功
   */
  protected onVerifySuccess(): void {
    this._password = [];
  }

  /**
   * 密码认证失败
   */
  protected onVerifyFail(): void {
    if (!VerifyDataManager.getInstance().isUnfixedPwdType || this.verifyInfo.isStateLocked || this._isSubmit) {
      this.clearPassword();
    }
    if (this.verifyInfo.isStateLocked) {
      this.disableInput = true;
    }
    this.isSubmit = false;
    this.updateErrorTips();
    if (this.verifyInfo?.freezingTime > 0 && this.verifyInfo?.oldPinValidatePeriod > 0) {
      return;
    }
    this.sendAccessibilityErrorTips();
  }

  protected get verifyInfo(): VerifyInfo {
    return VerifyDataManager.getInstance().getVerifyInfo(AuthType.PIN);
  }

  /**
   * 当密码长度达到时，是否自动认证
   */
  protected get isAutoAuth(): boolean {
    return true;
  }

  public get password(): string[] {
    return this._password;
  }

  public get passwordLength(): number {
    return this._password.length;
  }

  public get disableInput(): boolean {
    return this._disableInput;
  }

  public set disableInput(disableInput: boolean) {
    if (this._disableInput !== disableInput) {
      this._disableInput = disableInput;
      log.showInfo(`disableInput: ${disableInput}`);
      PasswordManager.getInstance().onDisableChange(disableInput);
    }
  }

  public set disableInputWhenAnim(isDisable: boolean) {
    this._disableInputWhenAnim = isDisable;
  }

  protected set isSubmit(isSubmit: boolean) {
    this._isSubmit = isSubmit;
  }

  public get isSimCardAuth(): boolean {
    return false;
  }

  /**
   * 输入密码
   *
   * @param key 密码
   */
  public addPassword(key: string): void {
    PowerUtils.refreshActivity('addPassword');
    if (this._disableInput || this._disableInputWhenAnim || !key) {
      return;
    }
    if (this._password.length === 0) {
      this.authPassword();
    }
    this._password.push(key);
    this.onPasswordChange(true);
    if (this._password.length >= this.verifyInfo.credentialLength && this.isAutoAuth) {
      this.disableInput = true;
      this.authPassword();
    }
  }

  /**
   * 删除最后一位密码
   */
  public delPassword(): void {
    PowerUtils.refreshActivity('delPassword');
    if (this._disableInput || this._password.length === 0) {
      return;
    }
    HiDfxEventUtil.reportPasswordDeleteEvent();
    this._password.pop();
    this.onPasswordChange(false);
    if (this._password.length === 0) {
      this.clearPassword();
    }
  }

  /**
   * 清空密码
   */
  public clearPassword(): void {
    this._password = [];
    ScreenLockVerifyService.getInstance().cancelVerify();
    this.onPasswordChange(false);
  }

  /**
   * 密码长度改变时回调
   */
  protected onPasswordChange(isAdd: boolean): void {
    log.showInfo(`onPasswordChange, isAdd: ${isAdd}`);
    PasswordManager.getInstance().onPasswordChange(isAdd, this._password.length);
  }

  /**
   * 发起密码认证
   *
   * @param isSubmit 是否是按确认键发起认证
   */
  public authPassword(isSubmit: boolean = false): void {
    if (isSubmit) {
      PowerUtils.refreshActivity('authPassword');
    }
    if (this.passwordLength === 0) {
      // 首次输入密码时，初始化动作提前(registerInput, authUser), 降低后续凭据校验时长
      ScreenLockVerifyService.getInstance().verifyPwd();
      return;
    }

    let hasMinPasswordLength =
      this.verifyInfo.authSubType === AuthSubType.PIN_NUMBER || this.verifyInfo.authSubType === AuthSubType.PIN_MIXED ||
        this.verifyInfo.authSubType === AuthSubType.PIN_PATTERN;
    if (this.passwordLength === this.verifyInfo.credentialLength ||
      (hasMinPasswordLength && this.passwordLength >= 4)) {
      Trace.start(Trace.CORE_METHOD_PSD_AUTH);
      this.isSubmit = isSubmit;
      ScreenLockVerifyService.getInstance().verifyPwd(this._password.join(''), true);
    }
  }
}

/**
 * 自定义数字密码/混合密码
 */
export class UnfixedPasswordVm extends ScreenLockPasswordVm {
  /**
   * 是否有静默认证的错误未提醒用户
   */
  private _hasUnhandledError = false;
  /**
   * 最后一次密码长度改变时, 是否是增加
   */
  private _hasAppend = false;
  /**
   * 是否需要静默认证（错误时不提醒用户）
   */
  private _delayHandleError = false;
  /**
   * 是否支持静默认证
   */
  private _isSupportAutoVerify = true;

  protected override doInit(params?: object | undefined): void {
    super.doInit(params);
  }

  protected override doRelease(): void {
    log.showInfo('doRelease');
    let currentStateType: CoreStateType = ScreenLockFsmProxy.getInstance(this.persistentId).coreFsm.currentStateType;
    if (!CoreStateTypeUtils.isInUnlockPage(currentStateType) && this.isSupportAutoVerify) {
      if (this._hasUnhandledError) {
        // 退出密码界面，如果有未处理的错误，需要重置冻结时间
        this.resetFreezeTime();
        ScreenLockVerifyService.getInstance().cancelVerify();
      } else if (this._hasAppend && this.password.length >= 4) {
        // 没有未处理的错误，如果密码长度大于等于4，需要立即触发认证
        this.authPassword();
        this.onVerifyFail();
      } else {
        ScreenLockVerifyService.getInstance().cancelVerify();
      }
    }
    super.doRelease();
  }

  protected override updateErrorTips(): void {
    if (this._delayHandleError || this._hasUnhandledError) {
      return;
    }
    super.updateErrorTips();
  }

  public override addPassword(key: string): void {
    log.showInfo(`addPassword`);
    PowerUtils.refreshActivity('addPassword');
    if (this.disableInput || !key || this.password.length >= Constants.PASSWORD_MAX_LEN) {
      return;
    }
    if (this.password.length === 0) {
      this.authPassword();
    }
    this.password.push(key);
    this.onPasswordChange(true);
    if (this.isSupportAutoVerify) {
      this._hasAppend = true;
      if (this.password.length === this.verifyInfo.credentialLength) {
        log.showInfo(`addPassword to authPassword ${this.password.length}`);
        // 输入密码长度等于当前用户真实长度，触发认证，如果失败则不显示错误提示
        this._delayHandleError = true;
        this.authPassword(true);
      }
    }
  }

  public override delPassword(): void {
    if (this.password.length === 0) {
      return;
    }
    this.onDelPassword();
    super.delPassword();
  }

  private onDelPassword(): void {
    if (!this.isSupportAutoVerify) {
      return;
    }
    if (this._hasAppend) {
      this._hasAppend = false;
      if (this._hasUnhandledError) {
        // 首次删除密码，如果有未处理的错误，需要重置冻结时间
        this.resetFreezeTime();
      } else if (this.password.length >= 4) {
        // 没有未处理的错误，如果密码长度大于等于4，需要立即触发认证
        this.authPassword();
      }
    }
  }

  private get isSupportAutoVerify(): boolean {
    return this._isSupportAutoVerify;
  }

  public override clearPassword(): void {
    this.onDelPassword();
    this._password = [];
    this.onPasswordChange(false);
  }

  protected onVerifyFail(): void {
    // 静默认证场景，拦截错误提示
    if (this._delayHandleError) {
      this._hasUnhandledError = true;
      this._delayHandleError = false;
      return;
    }
    super.onVerifyFail();
  }

  public override set disableInput(disableInput: boolean) {
    // 静默认证场景，拦截禁用
    if (this._delayHandleError || this._hasUnhandledError) {
      return;
    }
    super.disableInput = disableInput;
  }

  public override get disableInput(): boolean {
    return super.disableInput;
  }

  public override authPassword(isSubmit: boolean = false): void {
    log.showInfo(`authPassword, isSubmit: ${isSubmit}, hasUnhandledError: ${this._hasUnhandledError}`);
    /*if (isSubmit && this.isSupportAutoVerify) {
      if (this.passwordLength >= 4) {
        // 静默认证场景，用户点击确认键发起的密码认证属于必然失败场景，同清空密码逻辑一致
        this.isSubmit = isSubmit;
        this.clearPassword();
      }
      return;
    }*/
    super.authPassword(isSubmit);
  }

  /**
   * 重置密码禁用时长
   */
  private resetFreezeTime(): void {
    this._hasUnhandledError = false;
    if (this.verifyInfo.isStateLocked) {
      AccountHelper.getInstance()
        .resetFreezeTime(AuthType.PIN, this.updateVerifyDataAndFail, this.updateVerifyDataAndFail);
    } else {
      this.onVerifyFail();
    }
  }

  private updateVerifyDataAndFail: () => void = (): void => {
    VerifyDataManager.getInstance().updateVerifyData();
    this.onVerifyFail();
  }
}

/**
 * 4位/6位密码
 */
export class DigitalPasswordVm extends ScreenLockPasswordVm {
  protected override onVerifyFail(): void {
    // 4位/6位密码，如果在用户输入密码长度未达到真实密码长度，收到了认证失败，不提醒用户
    if (this.password.length > 0 && this.password.length < this.verifyInfo.credentialLength) {
      return;
    }
    super.onVerifyFail();
  }
}

/**
 * 图案密码
 */
export class PatternPasswordVm extends ScreenLockPasswordVm {
  public patternLockController: PatternLockController = new PatternLockController();

  protected override onVerifyFail(): void {
    super.onVerifyFail();
    this.patternLockController.reset();
  }

  protected override onVerifySuccess(): void {
    super.onVerifySuccess();
    this.patternLockController.reset();
  }

  public override clearPassword(): void {
    super.clearPassword();
    this.patternLockController.reset();
  }

  public override addPassword(key: string): void {
    if (!key) {
      this.patternLockController.reset();
      return;
    }
    if (key.length > 0 && key.length < 4) {
      super.onVerifyFail();
      this.patternLockController.reset();
      return;
    }
    this._password = key.split('');

    this.onPasswordChange(true);
    this.authPassword();
  }
}

/**
 * SIM卡密码
 */
export class SimCardPasswordVm extends ScreenLockPasswordVm {
  public override get isSimCardAuth(): boolean {
    return true;
  }

  protected override get isAutoAuth(): boolean {
    return false;
  }

  public override authPassword(): void {
    // SIM卡界面只管理密码，不做认证
  }
}