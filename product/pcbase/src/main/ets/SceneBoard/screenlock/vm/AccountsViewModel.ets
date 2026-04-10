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
import {
  EvtBus,
  InputMethodEvent,
  EventManager, WallpaperChangeEvent
} from '@ohos/frameworkwrapper';
import accountModel, { AuthSubType } from '../refactor/AccountsModel';
import screenLockService from '../refactor/ScreenLockService';
import PasswordViewModel from './PasswordViewModel';
import Constants from '../common/Constants';
import type { Callback } from '@ohos.base';
import osAccount from '@ohos.account.osAccount';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import inputMethod from '@ohos.inputMethod';
import { SwitchUserType, UserReportUtil } from '../../userspanel/common/UserReportUtil';
import { inputDevice } from '@kit.InputKit';
import { effectKit } from '@kit.ArkGraphics2D';
import { WallpaperConstants } from '@ohos/commonconstants';
import { resourceManager } from '@kit.LocalizationKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'ScreenLock-AccountsViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export default class AccountsViewModel extends PasswordViewModel {
  public static userLoggedAmount: number = 0;
  private static instance?: AccountsViewModel;

  public selectedUserId?: number;
  public maxLoggedAmount: number = 3;
  public requestFocus: Callback<void> = () => {};
  public passwordMixArr: string[] = [];
  public passwordNumber: Map<number, string> = new Map([
    [KeyCode.KEYCODE_0, 'KEYCODE_0'], [KeyCode.KEYCODE_1, 'KEYCODE_1'], [KeyCode.KEYCODE_2, 'KEYCODE_2'],
    [KeyCode.KEYCODE_3, 'KEYCODE_3'], [KeyCode.KEYCODE_4, 'KEYCODE_4'], [KeyCode.KEYCODE_5, 'KEYCODE_5'],
    [KeyCode.KEYCODE_6, 'KEYCODE_6'], [KeyCode.KEYCODE_7, 'KEYCODE_7'], [KeyCode.KEYCODE_8, 'KEYCODE_8'],
    [KeyCode.KEYCODE_9, 'KEYCODE_9'], [KeyCode.KEYCODE_STAR, 'KEYCODE_*'], [KeyCode.KEYCODE_POUND, 'KEYCODE_#'],
    [KeyCode.KEYCODE_A, 'KEYCODE_A'], [KeyCode.KEYCODE_B, 'KEYCODE_B'], [KeyCode.KEYCODE_C, 'KEYCODE_C'],
    [KeyCode.KEYCODE_D, 'KEYCODE_D'], [KeyCode.KEYCODE_E, 'KEYCODE_E'], [KeyCode.KEYCODE_F, 'KEYCODE_F'],
    [KeyCode.KEYCODE_G, 'KEYCODE_G'], [KeyCode.KEYCODE_H, 'KEYCODE_H'], [KeyCode.KEYCODE_I, 'KEYCODE_I'],
    [KeyCode.KEYCODE_J, 'KEYCODE_J'], [KeyCode.KEYCODE_K, 'KEYCODE_K'], [KeyCode.KEYCODE_L, 'KEYCODE_L'],
    [KeyCode.KEYCODE_M, 'KEYCODE_M'], [KeyCode.KEYCODE_N, 'KEYCODE_N'], [KeyCode.KEYCODE_O, 'KEYCODE_O'],
    [KeyCode.KEYCODE_P, 'KEYCODE_P'], [KeyCode.KEYCODE_Q, 'KEYCODE_Q'], [KeyCode.KEYCODE_R, 'KEYCODE_R'],
    [KeyCode.KEYCODE_S, 'KEYCODE_S'], [KeyCode.KEYCODE_T, 'KEYCODE_T'], [KeyCode.KEYCODE_U, 'KEYCODE_U'],
    [KeyCode.KEYCODE_V, 'KEYCODE_V'], [KeyCode.KEYCODE_W, 'KEYCODE_W'], [KeyCode.KEYCODE_X, 'KEYCODE_X'],
    [KeyCode.KEYCODE_Y, 'KEYCODE_Y'], [KeyCode.KEYCODE_Z, 'KEYCODE_Z'], [KeyCode.KEYCODE_COMMA, 'KEYCODE_,'],
    [KeyCode.KEYCODE_PERIOD, 'KEYCODE_.'], [KeyCode.KEYCODE_GRAVE, 'KEYCODE_`'],
    [KeyCode.KEYCODE_MINUS, 'KEYCODE_-'], [KeyCode.KEYCODE_EQUALS, 'KEYCODE_='],
    [KeyCode.KEYCODE_LEFT_BRACKET, 'KEYCODE_['], [KeyCode.KEYCODE_RIGHT_BRACKET, 'KEYCODE_['],
    [KeyCode.KEYCODE_SEMICOLON, 'KEYCODE_;'], [KeyCode.KEYCODE_APOSTROPHE, 'KEYCODE_'],
    [KeyCode.KEYCODE_SLASH, 'KEYCODE_/'], [KeyCode.KEYCODE_AT, 'KEYCODE_@'],
    [KeyCode.KEYCODE_PLUS, 'KEYCODE_+']
  ]);
  public focusKeyNumber:Map<number, string> = new Map([
    [KeyCode.KEYCODE_DPAD_DOWN, 'KEYCODE_DPAD_DOWN'], [KeyCode.KEYCODE_DPAD_UP, 'KEYCODE_DPAD_UP'],
    [KeyCode.KEYCODE_DPAD_LEFT, 'KEYCODE_DPAD_LEFT'], [KeyCode.KEYCODE_DPAD_RIGHT, 'KEYCODE_DPAD_RIGHT'],
    [KeyCode.KEYCODE_ESCAPE, 'KEYCODE_ESCAPE'], [KeyCode.KEYCODE_TAB, 'KEYCODE_TAB'],
    [KeyCode.KEYCODE_BACK, 'KEYCODE_BACK'], [KeyCode.KEYCODE_ENTER, 'KEYCODE_ENTER']
  ]);
  public passwordPush: string | undefined = '';
  private eventMgr: EventManager = EvtBus.createEventManager();
  public isCapsLocked: boolean = false;

  constructor() {
    super();
  }

  public updateCapsLockStatus(reason: string): void {
    inputDevice.isFunctionKeyEnabled(inputDevice.FunctionKey.CAPS_LOCK).then((result: boolean) => {
      log.showInfo(`${reason} - Caps Lock Status: ${result}`);
      this.isCapsLocked = result;
    }).catch((err: BusinessError) => {
      log.showError(`isFunctionKeyEnabled: ${err}`);
      this.isCapsLocked = false;
      log.showInfo(`updateCapsLockStatus - RESET`);
    });
  }
  /**
   * watch input
   *
   * @param value value
   * @param authType AuthSubType
   */
  onInputChange(value: string, authType: AuthSubType): void {
    if (!!value) {
      this.passwordMixArr = Array.from(value.slice(0, Constants.PASSWORD_MAX_LEN));
    } else {
      this.passwordMixArr = [];
    }
  }

  /**
   * watch DelKey LongPress
   */
  onDelKeyLongPress():void {
    this.clearPassword();
  }



  /**
   * deal with KeyEvent
   *
   * @param event touch event
   * @param type touch type
   */
  public handleKeyEvent(event: KeyEvent, type: ModelType): void {
    log.showInfo(`event.keyCode = ${event.keyCode} ,event.type = ${event.type} ModelType = ${event.type}`);

    if (!screenLockService.isScreenOn) {
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

  /**
   * Reuse color capture from wallpaper
   * @param color
   * @param info
   * @returns
   */
  public handleWallpaperAvgColor(color: effectKit.Color, info?: string ): resourceManager.Resource {
    log.showInfo('handleWallpaperAvgColor avgColor');
    const red: string = color.red.toString(WallpaperConstants.NUMBER_16).padStart(WallpaperConstants.NUMBER_2,
      WallpaperConstants.PREFIX_0);
    const green: string = color.green.toString(WallpaperConstants.NUMBER_16).padStart(WallpaperConstants.NUMBER_2,
      WallpaperConstants.PREFIX_0);
    const blue: string = color.blue.toString(WallpaperConstants.NUMBER_16).padStart(WallpaperConstants.NUMBER_2,
      WallpaperConstants.PREFIX_0);
    const finalColorForStatusBarPanel =
      `${WallpaperConstants.COLOR_PREFIX}${WallpaperConstants.ALPHA_10}${red}${green}${blue}`;
    EvtBus.post(WallpaperChangeEvent, { avgColor: finalColorForStatusBarPanel});

    log.showInfo(`${info}: ${finalColorForStatusBarPanel}`);
    return $r(finalColorForStatusBarPanel);
  }

  /**
   * clear Password
   */
  clearPassword(): void {
    super.clearPrompt();
    log.showInfo('clearPassword');
    this.passwordMixArr = [];
  }

  dispatchOtherUserEvent(event: KeyEvent): void {
    switch (event.keyCode) {
      case MultiKeyCode.ENTER:
      case MultiKeyCode.NUMPAD_ENTER:
        screenLockService.goBack();
        break;
      default:
        break;
    }
  }

  onUserClick(userNum: number): void {
    log.showInfo(`onUserClick - user: ${userNum}`);
    accountModel.onUserSwitch(userNum);
    UserReportUtil.reportSwitchUserEvent(userNum, SwitchUserType.SCREEN_LOCK);
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


  dispatchKeyEvent(keyEvent: KeyEvent, userId: number): void {
    accountModel.dispatchKeyEvent(keyEvent, userId);
    this.passwordPush = '';
  }

  passwordKeyEvent(keyEvent: KeyEvent, userId?: number): void {
    if (keyEvent.type === KeyType.Up) {
      return;
    }

    inputDevice.isFunctionKeyEnabled(inputDevice.FunctionKey.CAPS_LOCK).then((result: boolean) => {
      this.isCapsLocked = result;
      log.showInfo(`Caps Lock Status: ${this.isCapsLocked}`);
    }).catch((error: Error) => {
      log.showError(`isFunctionKeyEnabled Error: ${error}`);
    });

    if (this.passwordNumber.has(keyEvent.keyCode)) {
      AppStorage.setOrCreate('isPwdVisibleForPC', true);
      let textStr: string | undefined = this.passwordNumber.get(keyEvent.keyCode);
      this.passwordPush = textStr?.slice(-1).toLowerCase();
      if (this.isCapsLocked) {
        this.passwordPush = textStr?.slice(-1);
      }
    }
  }

  public async getMaxLoggedAmount(): Promise<number> {
    let maxLoggedAmount: number = await osAccount.getAccountManager().queryMaxLoggedInOsAccountNumber();
    log.showInfo(`maxLoggedAmount:${maxLoggedAmount}`);
    this.maxLoggedAmount = maxLoggedAmount;
    return this.maxLoggedAmount;
  }

  public isNeedLimitLogging(): boolean {
    return AccountsViewModel.userLoggedAmount >= this.maxLoggedAmount;
  }

  public isNeedLimitDeveloperMode(): boolean {
    return AccountsViewModel.userLoggedAmount >= Constants.DEV_MODE_MAX_LOGIN_USR_NUM;
  }

  public isCanUnlock(isFingerprint: boolean = false): boolean {
    if (!!AppStorage.get('accountSwitch')) {
      log.showInfo('is switching cannot click');
      return false;
    }

    if (!!AppStorage.get('remoteLocked')) {
      log.showInfo('isRemoteLocked, cannot unlock');
      return false;
    }

    if (!isFingerprint) {
      let isBeginSleepStart: boolean = (!!AppStorage.get('isBeginSleepStart'));
      if (!screenLockService.isScreenOn || isBeginSleepStart) {
        log.showInfo(`screen off, cannot unlock ${screenLockService.isScreenOn}, ${isBeginSleepStart}`);
        return false;
      }
    }
    return true;
  }

  public static getInstance(): AccountsViewModel {
    if (!AccountsViewModel.instance) {
      AccountsViewModel.instance = new AccountsViewModel();
    }
    return AccountsViewModel.instance;
  }
}

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
