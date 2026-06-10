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
import { ResUtils } from '@ohos/windowscene';
import { GlobalStatusCache } from '../base/GlobalStatusCache';
import { AbstractObserverManager } from '../base/AbstractObserverManager';
import { AuthType, AuthSubType } from '../utils/AccountHelper';
import { SlServerHelper } from '../utils/SlServerHelper';
import { VerifyDataManager } from '../manager/VerifyDataManager';
import { SystemSwitchUtils } from '../utils/SystemSwitchUtils';
import CommonConstants from '../constants/CommonConstants';
import { FaceUnlockConstants } from '../constants/FaceUnlockConstants';
import { FingerprintConstants } from '../constants/FingerprintConstants';
import accountsModelApi from '../api/AccountsModelApi';
import { ScreenLockApi } from '../api/ScreenLockApi';

const TAG = 'StrongAuthManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class StrongAuthConstants {
  public static readonly NO_NEED_STRONG_AUTH: number = 0x00000000;
  public static readonly USER_REBOOT: number = 0x00000001;
  public static readonly USER_TIMEOUT: number = 0x00000002;
  public static readonly USER_REQUEST: number = 0x00000004;

  public static readonly MAIN_USER_ID: number = 100;
  public static readonly STRONG_AUTH_CHANGED: string = 'strongAuthChanged';
  public static readonly STRONG_AUTH_MULTI_USER: string = 'multiUser';
  public static readonly STRONG_AUTH_SINGLE_USER: string = 'singleUser';
  public static readonly STRONG_AUTH_REASON: string = 'strongAuthReason';
}

/**
 * 强认证事件改变监听
 */
export interface StrongAuthListener {

  /**
   * 强认证事件改变时回调
   */
  onStrongAuthChange?: (strongAuthStatus: number) => void;
}

export class StrongAuthManager extends AbstractObserverManager<StrongAuthListener> {
  private static instance: StrongAuthManager;
  public static getInstance(): StrongAuthManager {
    if (!StrongAuthManager.instance) {
      StrongAuthManager.instance = new StrongAuthManager();
    }
    return StrongAuthManager.instance;
  }

  private strongAuthStatus: number = AppStorage.get(StrongAuthConstants.STRONG_AUTH_REASON) ??
  StrongAuthConstants.NO_NEED_STRONG_AUTH;
  private user: number | undefined = undefined;
  private strongAuthTipsPsd: Map<string, Resource> = this.strongAuthTipsInitPsd();
  private strongAuthTipsPin: Map<string, Resource> = this.strongAuthTipsInitPin();
  private fingerprintEnable: boolean = false;
  private needRequestUnlock: boolean = true;
  private authTypePinTables: AuthSubType[] = [AuthSubType.PIN_SIX, AuthSubType.PIN_NUMBER, AuthSubType.PIN_FOUR];

  private constructor() {
    super();
  }

  public setNeedRequestUnlock(needRequestUnlock: boolean): void {
    this.needRequestUnlock = needRequestUnlock;
  }

  public setAuthReason(reason: number): void {
    if (reason !== StrongAuthConstants.NO_NEED_STRONG_AUTH && !this.hasSetPasswd()) {
      log.showInfo('Strong Auth: password does not exist');
      return;
    }
    log.showInfo(`setAuthReason: ${reason}`);
    if (this.strongAuthStatus !== reason) {
      this.strongAuthStatus = reason;
      this.broadcastDataChange((observer) => observer.onStrongAuthChange?.(reason));
      AppStorage.setOrCreate(StrongAuthConstants.STRONG_AUTH_REASON, reason);
    }
  }

  public resetReason(): void {
    this.setAuthReason(StrongAuthConstants.NO_NEED_STRONG_AUTH);
  }

  private isMainUser(userId: number): boolean {
    return StrongAuthConstants.MAIN_USER_ID === userId;
  }

  public hasSetPasswd(): boolean {
    if (SystemSwitchUtils.isUseNewScreenLock()) {
      return !VerifyDataManager.getInstance().hasNoPwd;
    }
    const hasPwd: boolean =
      GlobalStatusCache.getInstance().getStatus(CommonConstants.SETTING_HAS_PASSWORD_KEY, false) as boolean;
    log.showInfo(`hasPwd: ${hasPwd}`);
    return hasPwd;
  }

  public hasFingerprint(): boolean {
    return !!AppStorage.get(FingerprintConstants.IS_CURRENT_USER_HAS_FINGERPRINT) && this.fingerprintEnable;
  }

  public setFingerprintEnable(fingerprintEnable: boolean): void {
    this.fingerprintEnable = fingerprintEnable;
    log.showInfo(`Strong Auth: fingerprintEnable ${this.fingerprintEnable}`);
  }

  private hasMultiAuthType(): boolean {
    if (SystemSwitchUtils.isUseNewScreenLock()) {
      if (VerifyDataManager.getInstance().hasNoPwd) {
        return false;
      }
      return VerifyDataManager.getInstance().getVerifyInfo(AuthType.FINGERPRINT).isSupportUnlock ||
        VerifyDataManager.getInstance().getVerifyInfo(AuthType.FACE).isSupportUnlock;
    }

    if (!this.hasSetPasswd()) {
      return false;
    }

    if (this.hasFingerprint()) {
      return true;
    }
    return !!AppStorage.get(FaceUnlockConstants.IS_FACE_UNLOCK_SWITCH_OPEN);
  }

  public getStrongAuthStatus(): number {
    return this.strongAuthStatus;
  }

  public getUserStrongAuth(userId: number): number {
    return SlServerHelper.getInstance().getStrongAuth(userId)
  }

  public triggerAuthByReboot(): void {
    if (this.user === undefined) {
      this.user = accountsModelApi.getCurrentUserId();
    }

    log.showInfo(`auth user userId: ${this.user}`);
    if (this.hasSetPasswd()) {
      const strongAuth = SlServerHelper.getInstance().getStrongAuth(this.user);

      if (strongAuth !== StrongAuthConstants.USER_REBOOT &&
        strongAuth !== StrongAuthConstants.USER_TIMEOUT) {
        return;
      }

      log.showInfo(`auth user reboot: ${this.user}`);
      let authType = StrongAuthConstants.USER_REBOOT;
      if (this.user !== undefined && !this.isMainUser(this.user) && this.needRequestUnlock) {
        if (strongAuth === StrongAuthConstants.USER_TIMEOUT) {
          authType = StrongAuthConstants.USER_TIMEOUT;
        } else {
          authType = StrongAuthConstants.USER_REQUEST;
        }
      } else if (strongAuth === StrongAuthConstants.USER_TIMEOUT) {
        this.setAuthReason(StrongAuthConstants.USER_TIMEOUT);
        return;
      }

      this.setAuthReason(authType);
      this.strongAuthRequestUnlock();
    }
  }

  public strongAuthRequestUnlock(): void {
    if (this.needRequestUnlock) {
      ScreenLockApi.requestUnlock({ success: (): void => { log.showInfo(`requestUnlock done: ${this.user}`); }});
    }
  }

  public isNeedStrongAuth(): boolean {
    return this.strongAuthStatus !== StrongAuthConstants.NO_NEED_STRONG_AUTH;
  }

  public isRebootStrongAuth(): boolean {
    return this.strongAuthStatus === StrongAuthConstants.USER_REBOOT;
  }

  private strongAuthTipsInitPsd(): Map<string, Resource> {
    const pleaseEnterPsdForSecurity = $r('app.string.please_enter_psd_for_security');
    const regularVerifyPsdForSecurity = $r('app.string.regular_verify_psd_for_security');
    const enterPsd = $r('app.string.psd_enter_psd_mix');
    const deviceRestartEnterPsd = $r('app.string.restart_enter_psd');
    return new Map<string, Resource>([
      [StrongAuthConstants.USER_REQUEST + StrongAuthConstants.STRONG_AUTH_MULTI_USER, pleaseEnterPsdForSecurity],
      [StrongAuthConstants.USER_REQUEST + StrongAuthConstants.STRONG_AUTH_SINGLE_USER, enterPsd],
      [StrongAuthConstants.USER_TIMEOUT + StrongAuthConstants.STRONG_AUTH_MULTI_USER, regularVerifyPsdForSecurity],
      [StrongAuthConstants.USER_TIMEOUT + StrongAuthConstants.STRONG_AUTH_SINGLE_USER, enterPsd],
      [StrongAuthConstants.USER_REBOOT + StrongAuthConstants.STRONG_AUTH_MULTI_USER, deviceRestartEnterPsd],
      [StrongAuthConstants.USER_REBOOT + StrongAuthConstants.STRONG_AUTH_SINGLE_USER, deviceRestartEnterPsd]
    ]);
  }

  private strongAuthTipsInitPin(): Map<string, Resource> {
    const pleaseEnterPinForSecurity = $r('app.string.please_enter_pin_for_security');
    const regularVerifyPinForSecurity = $r('app.string.regular_verify_pin_for_security');
    const enterPin = $r('app.string.psd_enter_psd');
    const deviceRestartEntePin = $r('app.string.restart_enter_pin');
    return new Map<string, Resource>([
      [StrongAuthConstants.USER_REQUEST + StrongAuthConstants.STRONG_AUTH_MULTI_USER, pleaseEnterPinForSecurity],
      [StrongAuthConstants.USER_REQUEST + StrongAuthConstants.STRONG_AUTH_SINGLE_USER, enterPin],
      [StrongAuthConstants.USER_TIMEOUT + StrongAuthConstants.STRONG_AUTH_MULTI_USER, regularVerifyPinForSecurity],
      [StrongAuthConstants.USER_TIMEOUT + StrongAuthConstants.STRONG_AUTH_SINGLE_USER, enterPin],
      [StrongAuthConstants.USER_REBOOT + StrongAuthConstants.STRONG_AUTH_MULTI_USER, deviceRestartEntePin],
      [StrongAuthConstants.USER_REBOOT + StrongAuthConstants.STRONG_AUTH_SINGLE_USER, deviceRestartEntePin]
    ]);
  }

  public getStrongAuthPwdTip(): string {
    let key = `${this.strongAuthStatus}`;

    if (this.hasMultiAuthType()) {
      key += StrongAuthConstants.STRONG_AUTH_MULTI_USER;
    } else {
      key += StrongAuthConstants.STRONG_AUTH_SINGLE_USER;
    }

    let keyType = VerifyDataManager.getInstance().getVerifyInfo(AuthType.PIN)?.authSubType;
    if (keyType && this.authTypePinTables.includes(keyType) && this.strongAuthTipsPin.has(key)) {
      return ResUtils.getInnerString(this.strongAuthTipsPin.get(key));
    } else if (this.strongAuthTipsPsd.has(key)) {
      return ResUtils.getInnerString(this.strongAuthTipsPsd.get(key));
    }
    return '';
  }

  public getStrongAuthLockTip(): string {
    let keyType = VerifyDataManager.getInstance().getVerifyInfo(AuthType.PIN)?.authSubType;
    if (keyType && this.authTypePinTables.includes(keyType)) {
      return ResUtils.getInnerString($r('app.string.restart_enter_pin'));
    } else {
      return ResUtils.getInnerString($r('app.string.restart_enter_psd'));
    }
  }
}

export const strongAuthManager: StrongAuthManager = StrongAuthManager.getInstance();
