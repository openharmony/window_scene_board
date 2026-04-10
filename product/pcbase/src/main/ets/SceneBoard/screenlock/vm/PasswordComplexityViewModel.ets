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

import account_osAccount from '@ohos.account.osAccount';
import osAccount from '@ohos.account.osAccount'
import { BusinessError } from '@ohos.base';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import ViewModel from './MixedPSDViewModel';
import PasswordViewModel from './PasswordViewModel';
import { AuthSubType } from '../refactor/AccountsModel';
import ScreenLockService from '../refactor/ScreenLockService';
import { PsdComplexityParams, PasswordComplexityUtil } from '../common/PasswordComplexityUtil';
import { COMPLEXITY_AUTH_RESULT, PcHiSysEventMgr } from '../../../common/manager/PcHiSysEventMgr';
import {
  enterpriseSpaceVerifyService,
  MixedPwdAuthViewModelWithEnterpriseAuth
} from './enterprise/EnterpriseMultiSpaceVerifyService'
import { util } from '@kit.ArkTS';

const TAG = 'ScreenLock-PasswordComplexityModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const REMAIN_TIMES: number = 5;

/**
 * 密码输入框最大长度，超过该长度无法输入
 */
const PASSWORD_TEXT_INPUT_MAX_LENGTH: number = 32;

/**
 * 密码输入框最小长度，小于该长度无法输入
 */
const PASSWORD_TEXT_INPUT_MIN_LENGTH: number = 6;

/**
 * 密码复杂度校验失败错误码
 */
const CREDENTIAL_COMPLEXITY_VERIFICATION_FAIL = 12300116;

/**
 * Token无效或认证失败
 */
const CREDENTIAL_AUTH_FAIL = 12300101;

/**
 * Accounts Tool
 *
 * @since 2024-05-06
 */
export default class PasswordComplexityViewModel extends PasswordViewModel {
  public mViewModel: ViewModel = enterpriseSpaceVerifyService.isEnabled() ?
    new MixedPwdAuthViewModelWithEnterpriseAuth() : new ViewModel();
  public isOldPasswordChanged: boolean = false;
  public recoveryKeyInput: string = '';
  public oldPasswordInput: string = '';
  public newPasswordInput: string = '';
  public confirmPasswordInput: string = '';
  public isRecoveryKeyWarningShow: boolean = false;
  public isOldPasswordWarningShow: boolean = false;
  public isNewPasswordWarningShow: boolean = false;
  public isConfirmPasswordWarningShow: boolean = false;
  public recoveryKeyWarnMsg: Resource | string = '';
  public oldPasswordWarnMsg: Resource | string = '';
  public newPasswordWarnMsg: Resource | string = '';
  public confirmPasswordWarnMsg: Resource | string = '';
  public maxLength: number = 0;
  public minLength: number = 0;
  public isDetailIconShow: boolean = false;
  public isUpdatePinSuccess: boolean = false;
  public isUpdatePinByRecKeySuccess: boolean = false;
  public isAuthPinSuccess: boolean = false;

  constructor() {
    super();
  }

  /**
   * 旧密码校验是否输入正确
   *
   */
  public checkOldPasswordInput(successCallback?: Callback<void>, failCallback?: Callback<void>): void {
    if (this.oldPasswordInput && this.isOldPasswordChanged) {
      log.showInfo('AuthPsd start');
      this.isOldPasswordWarningShow = false;
      ScreenLockService.authUser(AuthSubType.PIN_MIXED, this.oldPasswordInput, async (
        result: number, extraInfo: account_osAccount.AuthResult) => {
        log.showInfo(`AuthPsd end result :${result}`);
        if (result !== 0) {
          failCallback?.();
          this.oldPasswordInput = '';
          this.isAuthPinSuccess = false;
        } else {
          successCallback?.();
          this.isAuthPinSuccess = true;
        }
        if (result !== 0 && extraInfo.freezingTime && extraInfo.freezingTime > 0) {
          successCallback?.();
        }
        await this.resultHandle(result, extraInfo);
      });
    } else if (!this.oldPasswordInput) {
      successCallback?.();
    } else {
    }

    this.isOldPasswordChanged = false;
  }

  public async resultHandle(result: number, extraInfo: osAccount.AuthResult): Promise<void> {
    if (result !== 0) {
      await this.changePrompt(extraInfo.remainTimes, extraInfo.freezingTime, () => {
      });
      log.showInfo(`psdcVM.prompt : ${this.prompt}`);
      this.countdown();
      log.showInfo(`psdcVM.prompt countdown: ${this.prompt}`);
      this.oldPasswordWarnMsg = this.prompt as string;
      this.isOldPasswordWarningShow = true;
      if (extraInfo.remainTimes === 0 && extraInfo.freezingTime && extraInfo.freezingTime > 0) {
        setTimeout(() => {
          log.showInfo(`extraInfo.freezingTime setTimeout: ${extraInfo.freezingTime}`);
          this.isOldPasswordWarningShow = false;
        }, extraInfo.freezingTime);
      }
    }
  }

  /**
   * 新密码默认规格：锁屏密码由6-32位字符组成，且不含非法字符
   */
  public checkNewPasswordInput(): void {
    this.isNewPasswordWarningShow = false;
    if (!this.isDetailIconShow) {
      // 新密码输入框提示6-32个字符
      if (PasswordComplexityUtil.isContainIllegalCharacter(this.newPasswordInput)) {
        // 新密码输入框提示含非法字符
        this.newPasswordWarnMsg = $r('app.string.password_contain_illegal_character');
        this.isNewPasswordWarningShow = true;
      } else if (this.newPasswordInput && (this.newPasswordInput.length < PASSWORD_TEXT_INPUT_MIN_LENGTH ||
        this.newPasswordInput.length > PASSWORD_TEXT_INPUT_MAX_LENGTH)) {
        this.newPasswordWarnMsg = PasswordComplexityUtil
          .getAnyNumFormatStringSync($r('app.string.The_password_consists_of_6_32_characters'),
            PASSWORD_TEXT_INPUT_MIN_LENGTH, PASSWORD_TEXT_INPUT_MAX_LENGTH);
        this.isNewPasswordWarningShow = true;
      } else {
      }

    } else if (this.newPasswordInput.length > 0) {
      this.checkPasswordComplexity()
    } else {
    }


  }

  /**
   * 校验新密码是否满足用户设置规格；规格通过查询EDM密码复杂度策略获取
   */
  public checkPasswordComplexity() {
    log.showInfo(`minLength: ${this.minLength}, maxLength: ${this.maxLength}, newPasswordInput length: ${this.newPasswordInput.length}`);
    this.isNewPasswordWarningShow = false;
    this.newPasswordWarnMsg = $r('app.string.lenght_is_illegal');

    if (this.newPasswordInput.length < this.minLength || this.newPasswordInput.length > this.maxLength) {
      this.isNewPasswordWarningShow = true;
    }
  }

  /**
   * 锁屏密码输入框和再次输入框文本须保持一致
   *
   */
  public checkConfirmPasswordInput(): void {
    // 优先提示密码不一致，确认密码输入框提示6-32个字符
    if (this.newPasswordInput && this.confirmPasswordInput && this.newPasswordInput !== this.confirmPasswordInput) {
      this.confirmPasswordWarnMsg = $r('app.string.password_input_warning_message_not_equal');
      this.isConfirmPasswordWarningShow = true;
    } else {
      this.isConfirmPasswordWarningShow = false;
    }
  }

  /**
   * 更新锁屏密码，分两步，先校验旧密码，再更改锁屏密码为新密码
   *
   */
  public updatePin(successCallback: Callback<void>, failCallback: Callback<void>) {
    log.showInfo('update pin by old password: start the first step updatePin , four steps in total');
    try {
      let pinAuth: osAccount.PINAuth = new osAccount.PINAuth();
      let password: Uint8Array = PasswordComplexityUtil.stringToUint8Array(this.oldPasswordInput);
      let credentialInfo: osAccount.CredentialInfo = {
        credType: osAccount.AuthType.PIN,
        credSubType: osAccount.AuthSubType.PIN_MIXED,
        token: new Uint8Array([]),
      };
      pinAuth.unregisterInputer();
      // 用旧密码注册PIN码输入器
      pinAuth.registerInputer({
        onGetData: (authSubType: osAccount.AuthSubType, callback: osAccount.IInputData) => {
          callback.onSetData(authSubType, password);
        }
      });
      this.osUpdatePin(pinAuth, credentialInfo, () => {
      }, () => {
        failCallback();
      });
    } catch (err) {
      failCallback();
      log.showError(`osUpdatePin failed, error message: ${(err as BusinessError).message}`);
    }
  }

  private osUpdatePin(pinAuth: osAccount.PINAuth, credentialInfo: osAccount.CredentialInfo,
                      successCallback: Callback<void>, failCallback: Callback<void>) {
    log.showInfo('update pin by old password: start the second step osUpdatePin , four steps in total');
    let userIDM = new osAccount.UserIdentityManager();
    let userAuth: osAccount.UserAuth = new osAccount.UserAuth();
    let authOptions: osAccount.AuthOptions = {
      authIntent: osAccount.AuthIntent.UNLOCK
    };
    userIDM.openSession((err: BusinessError, challenge: Uint8Array) => {
      try {
        userAuth.auth(challenge, credentialInfo.credType, osAccount.AuthTrustLevel.ATL4, authOptions, {
          onResult: (result: number, extraInfo: osAccount.AuthResult) => {
            this.dealPwdAuthResult(pinAuth, credentialInfo, result, extraInfo, failCallback);
          }
        });
      } catch (err) {
        failCallback();
        log.showError(`old password userAuth auth failed, error message: ${(err as BusinessError).message}`);
      }
    })
  }

  public dealPwdAuthResult(pinAuth: osAccount.PINAuth,
                            credentialInfo: osAccount.CredentialInfo,
                            result: number,
                            extraInfo: osAccount.AuthResult,
                            failCallback: Callback<void>) {
    if (result !== osAccount.ResultCode.SUCCESS) {
      pinAuth.unregisterInputer();
      return;
    }
    if (extraInfo && extraInfo.token) {
      credentialInfo.token = extraInfo.token;
    }
    pinAuth.unregisterInputer();
    this.updateCredential(credentialInfo, () => {
    }, () => {
      failCallback();
    });
  }

  /**
   * 使用新密码，更改锁屏密码
   *
   */
  public updateCredential(credentialInfo: osAccount.CredentialInfo,
                          successCallback: Callback<void>, failCallback: Callback<void>) {
    log.showInfo('update pin by old password: start the third step updateCredential , four steps in total');
    try {
      let newPassword: Uint8Array = PasswordComplexityUtil.stringToUint8Array(this.newPasswordInput);
      let pinAuth: osAccount.PINAuth = new osAccount.PINAuth();
      // 用新密码注册PIN码输入器
      pinAuth.registerInputer({
        onGetData: (authSubType: osAccount.AuthSubType, callback: osAccount.IInputData) => {
          callback.onSetData(osAccount.AuthSubType.PIN_MIXED, newPassword);
        }
      });
      this.osUpdateCredential(credentialInfo, () => {
      }, () => {
        failCallback();
      });
    } catch (err) {
      failCallback();
      log.showError(`updateCredential failed, error message: ${(err as BusinessError).message}`);
    }
  }

  private osUpdateCredential(credentialInfo: osAccount.CredentialInfo,
                             successCallback: Callback<void>, failCallback: Callback<void>) {
    log.showInfo('update pin by old password: start the fourth step osUpdateCredential , four steps in total');
    try {
      let userIDM = new osAccount.UserIdentityManager();
      userIDM.updateCredential(credentialInfo, {
        onResult: (result: number, extraInfo: osAccount.RequestResult) => {
          log.showInfo(`updateCredential result :${result}`);
          if (result === osAccount.ResultCode.SUCCESS) {
            log.showInfo('update credential success ');
            this.authPinComplexitySuccess();
            // 返回输入密码页面，且指纹和人脸禁用解除
            this.isUpdatePinSuccess = true;
          } else if (result === CREDENTIAL_COMPLEXITY_VERIFICATION_FAIL) {
            // 出现复杂度校验不通过提示
            failCallback();
            this.isNewPasswordWarningShow = true;
            this.newPasswordWarnMsg = $r('app.string.password_complexity_is_illegal');
            PcHiSysEventMgr.userPinComplexityAuthResult(COMPLEXITY_AUTH_RESULT.NEW_USER_PIN_COMPLEXITY_AUTH_FAIL);
          } else {
            log.showInfo('update credential fail ');
          }
        }
      });
    } catch (e) {
      failCallback();
      log.showError(`osUpdateCredential exception message: ${(e as BusinessError).message}`);
    }
  }

  /**
   * 更新锁屏密码，分两步，先校验旧密码，再更改锁屏密码为新密码
   *
   */
  public updatePinByRecoveryKey(password: Uint8Array, successCallback: Callback<void>,
                                failCallback: Callback<void>,
                                checkComplexFailCallback: Callback<void>) {
    log.showInfo('update pin by recovery key: start the first step updatePinByKey , four steps in total');
    try {
      const pinAuth: osAccount.PINAuth = new osAccount.PINAuth();
      let credentialInfo: osAccount.CredentialInfo = {
        credType: osAccount.AuthType.RECOVERY_KEY,
        credSubType: 0,
        token: new Uint8Array([]),
      };
      pinAuth.unregisterInputer();
      // 用恢复密钥注册PIN码输入器
      pinAuth.registerInputer({
        onGetData: (authSubType: osAccount.AuthSubType, callback: osAccount.IInputData) => {
          callback.onSetData(authSubType, password);
        }
      });
      this.osUpdatePinByRecoveryKey(pinAuth, credentialInfo, () => {
      }, () => {
        failCallback();
      }, () => {
        checkComplexFailCallback();
      });
    } catch (err) {
      failCallback();
      log.showError(`osUpdatePin failed, error message: ${(err as BusinessError).message}`);
    }
  }

  private osUpdatePinByRecoveryKey(pinAuth: osAccount.PINAuth,
                                   credentialInfo: osAccount.CredentialInfo,
                                   successCallback: Callback<void>,
                                   failCallback: Callback<void>,
                                   checkComplexFailCallback: Callback<void>) {
    log.showInfo('update pin by recovery key: start the second step osUpdatePin , four steps in total');
    let userIDM = new osAccount.UserIdentityManager();
    let userAuth: osAccount.UserAuth = new osAccount.UserAuth();
    let authOptions: osAccount.AuthOptions = {
      authIntent: osAccount.AuthIntent.UNLOCK
    };

    userIDM.openSession((err: BusinessError, challenge: Uint8Array) => {
      try {
        userAuth.auth(challenge, credentialInfo.credType, osAccount.AuthTrustLevel.ATL4, authOptions, {
          onResult: (result: number, extraInfo: osAccount.AuthResult) => {
            this.dealRecKeyAuthResult(pinAuth, credentialInfo, result,
              extraInfo, failCallback, checkComplexFailCallback);
          }
        });
      } catch (err) {
        failCallback();
        log.showError(`userAuth auth failed, error message: ${(err as BusinessError).message}`);
      }
    })
  }

  public dealRecKeyAuthResult(pinAuth: osAccount.PINAuth,
                                   credentialInfo: osAccount.CredentialInfo,
                                   result: number,
                                   extraInfo: osAccount.AuthResult,
                                   failCallback: Callback<void>,
                                   checkComplexFailCallback: Callback<void>) {
    log.showInfo(`update pin by recovery key deal recKey authResult ${result}`);
    if (result !== osAccount.ResultCode.SUCCESS) {
      pinAuth.unregisterInputer();
      if (result === CREDENTIAL_AUTH_FAIL) {
        this.recoveryKeyWarnMsg = $r('app.string.recovery_key_error');
        this.isRecoveryKeyWarningShow = true;
        return;
      }
      failCallback();
      return;
    }
    let newCredentialInfo: osAccount.CredentialInfo = {
      credType: osAccount.AuthType.PIN,
      credSubType: osAccount.AuthSubType.PIN_MIXED,
      token: new Uint8Array([]),
    };
    if (extraInfo && extraInfo.token) {
      newCredentialInfo.token = extraInfo.token;
    }
    pinAuth.unregisterInputer();
    this.updateCredentialByRecoveryKey(newCredentialInfo, () => {
    }, () => {
      failCallback();
    }, () => {
      checkComplexFailCallback();
    });
  }

  /**
   * 使用新密码，更改锁屏密码
   *
   */
  public updateCredentialByRecoveryKey(credentialInfo: osAccount.CredentialInfo,
                                       successCallback: Callback<void>,
                                       failCallback: Callback<void>,
                                       checkComplexFailCallback: Callback<void>) {
    log.showInfo('update pin by recovery key: start the third step updateCredential , four steps in total');
    try {
      let newPassword: Uint8Array = PasswordComplexityUtil.stringToUint8Array(this.newPasswordInput);
      let pinAuth: osAccount.PINAuth = new osAccount.PINAuth();
      // 用新密码注册PIN码输入器
      pinAuth.registerInputer({
        onGetData: (authSubType: osAccount.AuthSubType, callback: osAccount.IInputData) => {
          callback.onSetData(osAccount.AuthSubType.PIN_MIXED, newPassword);
        }
      });
      this.osUpdateCredentialByRecoveryKey(credentialInfo, () => {
      }, () => {
        failCallback();
      }, () => {
        checkComplexFailCallback();
      });
    } catch (err) {
      failCallback();
      log.showError(`updateCredential failed, error message: ${(err as BusinessError).message}`);
    }
  }

  private osUpdateCredentialByRecoveryKey(credentialInfo: osAccount.CredentialInfo,
                                          successCallback: Callback<void>,
                                          failCallback: Callback<void>,
                                          checkComplexFailCallback: Callback<void>) {
    log.showInfo('update pin by recovery key: start the fourth step osUpdateCredential , four steps in total');
    try {
      let userIDM = new osAccount.UserIdentityManager();
      userIDM.updateCredential(credentialInfo, {
        onResult: (result: number, extraInfo: osAccount.RequestResult) => {
          log.showInfo(`updateCredential result :${result}`);
          if (result === osAccount.ResultCode.SUCCESS) {
            log.showInfo('update credential success ');
            this.authPinComplexitySuccess();
            // 返回输入密码页面，且指纹和人脸禁用解除
            this.isUpdatePinByRecKeySuccess = true;
          } else if (result === CREDENTIAL_COMPLEXITY_VERIFICATION_FAIL) {
            // 出现复杂度校验不通过提示
            checkComplexFailCallback();
            this.isNewPasswordWarningShow = true;
            this.newPasswordWarnMsg = $r('app.string.password_complexity_is_illegal');
            PcHiSysEventMgr.userPinComplexityAuthResult(COMPLEXITY_AUTH_RESULT.NEW_USER_PIN_COMPLEXITY_AUTH_FAIL);
          } else {
            failCallback();
            log.showInfo('update credential fail ');
          }
        }
      });
    } catch (e) {
      failCallback();
      log.showError(`osUpdateCredential exception message: ${(e as BusinessError).message}`);
    }
  }

  private authPinComplexitySuccess() {
    let psdComplexity: PsdComplexityParams = PasswordComplexityUtil.getPasswordPolicy();
    if (psdComplexity.complexityRegex != '' || psdComplexity.additionalDescription !== '') {
      PcHiSysEventMgr.userPinComplexityAuthResult(COMPLEXITY_AUTH_RESULT.NEW_USER_PIN_COMPLEXITY_AUTH_SUCCESS);
    }
  }

  public refreshPrompt() {
    ScreenLockService.getAuthProperty(osAccount.AuthType.PIN, async (properties: osAccount.ExecutorProperty) => {
      if (properties.remainTimes === REMAIN_TIMES) {
        this.prompt = '';
        return;
      }
      if (properties.freezingTime && properties.freezingTime > 0) {
        this.inhibitInput = true;
      } else {
        this.inhibitInput = false;
      }
      await this.changePrompt(properties.remainTimes, properties.freezingTime, () => {
      });
      this.isOldPasswordWarningShow = true;
      log.showInfo(` this.prompt ${this.prompt}, properties.remainTimes ${properties.remainTimes}, properties.freezingTime ${properties.freezingTime}`);
      if (properties.remainTimes === 0 && properties.freezingTime && properties.freezingTime > 0) {
        setTimeout(() => {
          this.isOldPasswordWarningShow = false;
        }, properties.freezingTime);
      }
    });
  }
}



