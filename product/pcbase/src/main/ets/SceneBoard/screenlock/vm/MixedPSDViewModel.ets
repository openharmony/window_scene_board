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
import { ResUtils } from '@ohos/windowscene';
import accountModel, { AuthSubType, IAMAuthResult, AuthType } from '../refactor/AccountsModel';
import service from '../refactor/ScreenLockService';
import PasswordViewModel from './PasswordViewModel';
import { Callback } from '@ohos.base';
import { InputMethodManager } from '@ohos/launchercommon';
import osAccount from '@ohos.account.osAccount';
import { SCBResetPwdManager } from '../common/SCBResetPwdManager';

const TAG = 'ScreenLock-MixedPSDViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const PASSWORD_MAX_LEN: number = 32;

/**
 * ModelType
 */
export enum ModelType {
  PIN_AUTH_TYPE, DOMAIN_AUTH_TYPE, OTHER_USER_TYPE
}

export enum MultiKeyCode {
  NUMPAD_ENTER = 2119,
  ENTER = 2054
}

/**
 * MixedPSD ViewModel
 *
 * @since 2022-06-09
 */
export default class MixedPSDViewModel extends PasswordViewModel {
  public passwordMixArr: string[] = [];

  constructor() {
    super();
  }

  /**
   * init
   */
  viewModelInit(): void {
    log.showInfo('ViewModelInit');
    super.ViewModelInit();
  }

  /**
   * watch input
   *
   * @param value value
   * @param authType AuthSubType
   */
  onInputChange(value: string, authType: AuthSubType): void {
    if (!!value) {
      this.passwordMixArr = Array.from(value.slice(0, PASSWORD_MAX_LEN));
    } else {
      this.passwordMixArr = [];
    }
  }

  /**
   * watch DelKey LongPress
   */
  onDelKeyLongPress(): void {
    this.clearPassword();
  }

  /**
   * auth password
   *
   * @param callback callback
   * @param authType authType
   */
  onAuthPassword(authType: AuthSubType, failedCallback: Function, succeedCallback?:
    Callback<void>): void {
    log.showInfo('AuthPsd start');
    let password = this.passwordMixArr.join('');
    if (password.length === 0 || this.inhibitInput) {
      return;
    }
    service.refreshUnlockStartTime(osAccount.AuthType.PIN);
    Trace.start(Trace.CORE_METHOD_PSD_AUTH);
    service.authUser(authType, password, (result: number, extraInfo: osAccount.AuthResult | undefined) => {
      Trace.end(Trace.CORE_METHOD_PSD_AUTH);
      log.showWarn(`PsdAuth end. result: ${result}`);
      if (extraInfo === undefined) {
        log.showWarn('authUser extraInfo is undefined');
      }
      this.clearPassword();
      if (result === IAMAuthResult.SUCCEED) {
        // pin码过期，中止解锁
        if (extraInfo?.pinValidityPeriod === 0) {
          this.prompt = ResUtils.getInnerString($r('app.string.psd_has_expired'));
          failedCallback(result);
          return;
        }
        InputMethodManager.getInstance().stopInputSession();
        //unlock the screen
        service.setScreenLockAuthState(AuthType.PIN, accountModel.getCurrentUserId(), true);
        if (succeedCallback) {
          AppStorage.setOrCreate('isLockAnimationStart', true);
          succeedCallback();
        } else {
          service.unlocking();
        }
      } else {
        this.logIAMResult(result, extraInfo?.remainTimes, extraInfo?.freezingTime);
        super.changePrompt(extraInfo?.remainTimes, extraInfo?.freezingTime, failedCallback,
            extraInfo?.nextPhaseFreezingTime);
      }
      if (extraInfo?.remainTimes) {
        SCBResetPwdManager.getInstance().setResetPwdEntry(extraInfo?.remainTimes < 3, 'mixedpsdvm');
      }
    });
  }

  /**
   * clear Password
   */
  clearPassword(): void {
    super.clearPrompt();
    log.showInfo('clearPassword');
    this.passwordMixArr = [];
  }

  /**
   * deal with KeyEvent
   *
   * @param event touch event
   * @param type touch type
   */
  public handleKeyEvent(event: KeyEvent, type: ModelType): void {
    log.showInfo(`event.keyCode = ${event.keyCode} ,event.type = ${event.type} ModelType = ${event.type}`);
    if (!service.isScreenOn) {
      log.showWarn('Screen OFF, return');
      return;
    }
    if (event.type === KeyType.Up) {
      return;
    }
    switch (type) {
      case ModelType.OTHER_USER_TYPE:
        this.dispatchOtherUserEvent(event);
        break;
      case ModelType.PIN_AUTH_TYPE:
        this.dispatchAuthTypeChangeEvent(event, true);
        break;
      case ModelType.DOMAIN_AUTH_TYPE:
        this.dispatchAuthTypeChangeEvent(event, false);
        break;
      default:
        break;
    }
  }

  dispatchOtherUserEvent(event: KeyEvent): void {
    switch (event.keyCode) {
      case MultiKeyCode.ENTER:
      case MultiKeyCode.NUMPAD_ENTER:
        service.goBack();
        break;
      default:
        break;
    }
  }

  dispatchAuthTypeChangeEvent(event: KeyEvent, isPinAuthType: boolean): void {
    switch (event.keyCode) {
      case MultiKeyCode.ENTER:
      case MultiKeyCode.NUMPAD_ENTER:
        AppStorage.setOrCreate<boolean>('isPinAuthType', isPinAuthType);
        break;
      default:
        break;
    }
  }
}