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

import { LogDomain, LogHelper, SingletonHelper, Trace } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import osAccount from '@ohos.account.osAccount';
import accountModel, { AuthSubType, AuthType } from '../../refactor/AccountsModel';
import service from '../../refactor/ScreenLockService';
import { Callback } from '@ohos.base';
import { InputMethodManager } from '@ohos/launchercommon';
import { PCMixedPSDViewModel } from '../PCMixedPSDViewModel';
import { BiometricsDisAbleReason, biometricsVerifyService } from '../../common/BiometricsVerifyService';
import { AcquireResultCode } from '@ohos/screenlockcommon';
import { SCBResetPwdManager } from '../../common/SCBResetPwdManager';
import { StrongAuthManager, StrongAuthConstants } from '@ohos/screenlockcommon/src/main/ets/manager/StrongAuthManager';

const TAG = 'ScreenLock-EnterpriseSpaceVerifyService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const enterpriseSpaceEnabled =
  systemParameterEnhance.getSync('persist.space_mgr_service.enterprise_space_enable', 'empty') === 'true';
/**
 * 身份认证服务器连接失败，请确保服务器和WLAN配置正确
 */
const CONNECT_SEVER_AUTH_FAIL = 12300211;

/**
 * 账号已锁定，待企业服务器解锁后再试
 */
const ENTERPRISE_ACCOUNT_LOCKED = 12300110;

/**
 * 认证超时，请稍后重试
 */
const AUTH_TIMEOUT = 12300111;

/**
 * 认证取消
 */
const AUTH_CANCELED = 12300109;

export class EnterpriseSpaceVerifyService {
  private curAccountInfo?: osAccount.OsAccountInfo;

  isEnabled(): boolean {
    return true;
  }

  /**
   * 重置为未超期
   */
  public reset(): void {
    if (enterpriseSpaceEnabled) {
      log.showInfo('reset to not expired');
      AppStorage.setOrCreate('domainAccountIsExpired', false);
    }
  }

  /**
   * 当前域账号登录是否超期，并domainAccountIsExpired创建全局状态
   *
   * @returns
   */
  public async isAuthExpired(): Promise<boolean> {
    let result = false;
    try {
      result = await this.checkExpired();
    } catch (error) {
      log.showError(`Check isAuthenticationExpired failed. err.code:${error?.code}, err.msg: ${error?.message}`);
      result = false;
    }
    log.showInfo(`isAuthExpired=${result}`);
    AppStorage.setOrCreate('domainAccountIsExpired', result);
    return Promise.resolve(result);
  }

  private async checkExpired(): Promise<boolean> {
    log.showInfo('start checkExpired');
    try {
      this.curAccountInfo = await osAccount.getAccountManager().queryOsAccount();
      StrongAuthManager.getInstance()
          .setAuthReason(StrongAuthManager.getInstance().getUserStrongAuth(this.curAccountInfo?.localId));
      log.showInfo(`checkExpired, curUserId=${this.curAccountInfo?.localId}, isDomain=${!!this.curAccountInfo?.domainInfo?.domain}`);
      if (!this.curAccountInfo?.domainInfo?.domain) {
        // 非域账户，判断为不会超期
        return Promise.resolve(false);
      }
      return osAccount.DomainAccountManager.isAuthenticationExpired(this.curAccountInfo?.domainInfo);
    } catch (error) {
      log.showError(`checkExpired failed. err.code:${error?.code}, err.msg: ${error?.message}`);
      return Promise.resolve(false);
    }
  }
}

export let enterpriseSpaceVerifyService = SingletonHelper.getInstance(EnterpriseSpaceVerifyService, TAG);

export class MixedPwdAuthViewModelWithEnterpriseAuth extends PCMixedPSDViewModel {
  onAuthPassword(authType: AuthSubType, failedCallback: Callback<number>, succeedCallback?:
    Callback<void>): void {
    log.showInfo(`AuthPsd start, authType=${authType}`);
    let password: number[] | string = this.passwordMixArr.join('');
    if (!password || password.length === 0 || this.inhibitInput) {
      log.showInfo('AuthPsd is empty');
      return;
    }
    service.refreshUnlockStartTime(osAccount.AuthType.PIN);
    Trace.start(Trace.CORE_METHOD_PSD_AUTH);
    service.authUser(authType, password, async (result: number, extraInfo: osAccount.AuthResult) => {
      Trace.end(Trace.CORE_METHOD_PSD_AUTH);
      this.haveTryUnlock = true;
      this.userRetry = true;
      log.showInfo(`AuthPsd end, result=${result}`);
      if (extraInfo === undefined) {
        log.showWarn('authUser extraInfo is undefined');
      }
      this.clearPassword();
      if (result === CONNECT_SEVER_AUTH_FAIL) {
        this.prompt = ResUtils.getInnerString($r('app.string.multispace_enterprise_connect_failed'));
        log.showWarn('server connect failed');
        failedCallback(result);
        return;
      } else if (result === ENTERPRISE_ACCOUNT_LOCKED) {
        this.prompt = ResUtils.getInnerString($r('app.string.enterprise_account_locked'));
        log.showInfo('enterprise_account_locked');
        failedCallback(result);
        return;
      } else if (result === AcquireResultCode.HARDWARE_ERROR) {
        this.prompt = ResUtils.getInnerString($r('app.string.psd_incorrect_hardware_error'));
        log.showInfo('hardware error');
        failedCallback(result);
        return;
      } else if (result === AUTH_TIMEOUT) {
        this.prompt = ResUtils.getInnerString($r('app.string.enterprise_auth_timeout'));
        log.showInfo('Enterprise authentication timed out');
        failedCallback(result);
        return;
      } else if (result === AUTH_CANCELED) {
        log.showWarn('Authentication is canceled');
        failedCallback(result);
        return;
      } else if (result === 0) {
        log.showInfo(`authUser result : start unlock`);
        // pin码过期，中止解锁
        if (extraInfo?.pinValidityPeriod === 0) {
          log.showInfo('pinValidityPeriod: 0');
          this.prompt = ResUtils.getInnerString($r('app.string.psd_has_expired'));
          failedCallback(result);
          return;
        }
        InputMethodManager.getInstance().stopInputSession();
        // 企业账号登录成功后，不用检查UT有效性，直接解锁
        if (AppStorage.get('isPinAuthType')) {
          const expired = await enterpriseSpaceVerifyService.isAuthExpired();
          log.showInfo(`isAuthExpired finish, expired: ${expired}`);
          if (expired) {
            // 设置全局状态isPinAuthType为false，会切换到企业账号登录
            if (authType === AuthSubType.PIN_MIXED) {
              AppStorage.setOrCreate('isPinAuthType', false);
            }
            this.prompt = ResUtils.getInnerString($r('app.string.multispace_enterprise_login_expired'));
            log.showWarn('current domain account is authentication expired');
            failedCallback(result);
            return;
          }
        }
        service.setScreenLockAuthState(AuthType.PIN, accountModel.getCurrentUserId(), true);
        this.unlockScreen(succeedCallback);
      } else {
        super.changePrompt(extraInfo.remainTimes, extraInfo.freezingTime, () => {
          if (this.inhibitInput) {
            biometricsVerifyService.pushDisableReason(BiometricsDisAbleReason.PASSWORD_FREEZING);
          }
          failedCallback(result);
        },
          extraInfo.nextPhaseFreezingTime);
      }
      SCBResetPwdManager.getInstance()
        .setResetPwdEntry((extraInfo?.remainTimes !== undefined && authType !== AuthSubType.DOMAIN_MIXED) ?
          extraInfo?.remainTimes < 3 : false, 'enterprise');
      log.showInfo(`authUser AuthSubType: ${authType}, extraInfo?.remainTimes: ${extraInfo?.remainTimes}`);
    });
  }

  private unlockScreen(succeedCallback?: Callback<void>): void {
    //unlock the screen
    if (succeedCallback) {
      log.showInfo('unlockScreen succeedCallback');
      AppStorage.setOrCreate('isLockAnimationStart', true);
      succeedCallback();
    } else {
      service.unlocking();
    }
  }
}