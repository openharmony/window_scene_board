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

import { LogDomain, Logger } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { AbstractObserverManager } from '../base/AbstractObserverManager';
import { AccountHelper, AuthType, AuthSubType } from '../utils/AccountHelper';
import { ScreenLockUnlockService } from '../services/ScreenLockUnLockService';
import { SlServerHelper } from '../utils/SlServerHelper';
import { VerifyDataManager } from '../manager/VerifyDataManager';
import screenLock from '@ohos.screenLock';

const TAG = 'StrongAuthStateManager';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

export enum StrongAuthReasonFlags {
  NO_NEED_STRONG_AUTH = 0x00000000,
  USER_REBOOT = 0x00000001,
  USER_TIMEOUT = 0x00000002,
  USER_REQUEST = 0x00000004,
}

const MAIN_USER_ID: number = 100;
const STRONG_AUTH_MULTI_USER: string = 'strongAuthChanged';
const STRONG_AUTH_SINGLE_USER: string = 'singleUser';

/**
 * 强认证事件改变监听
 */
export interface StrongAuthStateListener {

  /**
   * 强认证事件改变时回调
   */
  onStrongAuthStateChange?: (strongAuthStatus: StrongAuthReasonFlags) => void;
}

export class StrongAuthStateManager extends AbstractObserverManager<StrongAuthStateListener> {
  private static instance: StrongAuthStateManager;

  public static getInstance(): StrongAuthStateManager {
    if (!StrongAuthStateManager.instance) {
      StrongAuthStateManager.instance = new StrongAuthStateManager();
    }
    return StrongAuthStateManager.instance;
  }

  private strongAuthStatus: StrongAuthReasonFlags = StrongAuthReasonFlags.NO_NEED_STRONG_AUTH;
  private user: number | undefined = undefined;
  private promptAuthStatus: StrongAuthReasonFlags = StrongAuthReasonFlags.NO_NEED_STRONG_AUTH;

  private strongAuthTipsPsd: Map<string, Resource> = this.strongAuthTipsInitPsd();
  private strongAuthTipsPin: Map<string, Resource> = this.strongAuthTipsInitPin();
  private authTypePinTables: AuthSubType[] = [AuthSubType.PIN_SIX, AuthSubType.PIN_NUMBER, AuthSubType.PIN_FOUR];

  private constructor() {
    super();
  }

  /**
   * 从锁屏管理服务更新强认证状态
   */
  public updateStrongAuth(): void {
    if (this.user === undefined) {
      this.user = AccountHelper.getInstance().currentLocalId;
    }
    const strongAuthState: number = SlServerHelper.getInstance().getStrongAuth(this.user);
    log.showWarn(TAG, `updateStrongAuth strongAuthState: ${strongAuthState}, user: ${this.user}`);
    this.setStrongAuth(strongAuthState);
  }

  /**
   * 获取强认证状态
   *
   * @return StrongAuthReasonFlags: 强认证状态
   */
  public getStrongAuthStatus(): StrongAuthReasonFlags {
    return this.strongAuthStatus;
  }

  /**
   * 获取提示语状态
   *
   * @return StrongAuthReasonFlags: 提示语状态
   */
  public getPromptAuthStatus(): StrongAuthReasonFlags {
    return this.promptAuthStatus;
  }

  public isNeedStrongAuth(): boolean {
    return this.strongAuthStatus !== StrongAuthReasonFlags.NO_NEED_STRONG_AUTH;
  }

  public isRebootStrongAuth(): boolean {
    return this.strongAuthStatus === StrongAuthReasonFlags.USER_REBOOT;
  }

  /**
   * 重启触发强认证
   */
  public triggerAuthByReboot(): void {
    if (VerifyDataManager.getInstance().hasNoPwd) {
      return;
    }
    this.updateStrongAuth();
    if (this.isNeedStrongAuth()) {
      log.showWarn(TAG, `triggerAuthByReboot strongAuthStatus: ${this.strongAuthStatus}`);
      this.strongAuthRequestUnlock();
    }
  }

  public getStrongAuthPwdTip(): string {
    let key = `${this.promptAuthStatus}`;

    if (this.hasMultiAuthType()) {
      key += STRONG_AUTH_MULTI_USER;
    } else {
      key += STRONG_AUTH_SINGLE_USER;
    }

    return this.getTipFromPromptMap(key);
  }

  public getStrongAuthLockTip(): string {
    let keyType = VerifyDataManager.getInstance().getVerifyInfo(AuthType.PIN).authSubType;
    if (this.authTypePinTables.includes(keyType)) {
      return ResUtils.getInnerString($r('app.string.restart_enter_pin'));
    } else {
      return ResUtils.getInnerString($r('app.string.restart_enter_psd'));
    }
  }

  /**
   * c++侧强认证状态修改
   *
   * @param reasonFlag: 强认证标识
   * @param userId: 需要强认证的用户ID，默认为当前用户
   */
  public setServiceStrongAuth(reasonFlag: StrongAuthReasonFlags, userId?: number): void {
    if (VerifyDataManager.getInstance().hasNoPwd) {
      return;
    }
    try {
      screenLock.requestStrongAuth(reasonFlag, userId ?? AccountHelper.getInstance().currentLocalId);
    } catch (err) {
      log.showError(TAG, `setServiceStrongAuth failed, err: ${err.code}`);
    }
  }

  private strongAuthRequestUnlock(): void {
    ScreenLockUnlockService.getInstance().requestUnlock({
      success: (): void => {
        log.showInfo(TAG, `requestUnlock done: ${this.user}`);
      }
    });
  }

  /**
   * 应用层强认证状态修改，该方法不会改变底层强认证状态
   *
   * @param strongAuthState: 强认证状态
   */
  private setStrongAuth(strongAuthState: number): void {
    if (!Object.values(StrongAuthReasonFlags).includes(strongAuthState)) {
      log.showError(TAG, `setStrongAuth wrong state:${strongAuthState}`);
      return;
    }
    this.setStrongAuthStatus(strongAuthState);
  }

  /**
   * 本地强认证状态修改
   */
  private setStrongAuthStatus(strongAuthStatus: StrongAuthReasonFlags): void {
    log.showInfo(TAG, `old strongAuthStatus: ${this.strongAuthStatus}, new strongAuthStatus: ${strongAuthStatus}`);
    if (this.strongAuthStatus !== strongAuthStatus) {
      this.strongAuthStatus = strongAuthStatus;
      this.updatePromptAuthStatus();
      this.broadcastDataChange((observer) => observer.onStrongAuthStateChange?.(strongAuthStatus));
    }
  }

  /**
   * 更新提示语
   */
  private updatePromptAuthStatus(): void {
    if (!Object.values(StrongAuthReasonFlags).includes(this.strongAuthStatus)) {
      this.promptAuthStatus = StrongAuthReasonFlags.USER_REQUEST;
      return;
    }

    if (this.user !== MAIN_USER_ID && this.strongAuthStatus !== StrongAuthReasonFlags.USER_TIMEOUT) {
      // 隐私空间重启时，打印USER_REQUEST提示语
      this.promptAuthStatus = StrongAuthReasonFlags.USER_REQUEST;
      return;
    }

    this.promptAuthStatus = this.strongAuthStatus;
  }

  private hasMultiAuthType(): boolean {
    if (VerifyDataManager.getInstance().hasNoPwd) {
      return false;
    }

    return VerifyDataManager.getInstance().getVerifyInfo(AuthType.FINGERPRINT).isSupportUnlock ||
    VerifyDataManager.getInstance().getVerifyInfo(AuthType.FACE).isSupportUnlock;
  }

  private strongAuthTipsInitPsd(): Map<string, Resource> {
    const pleaseEnterPsdForSecurity = $r('app.string.please_enter_psd_for_security');
    const regularVerifyPsdForSecurity = $r('app.string.regular_verify_psd_for_security');
    const enterPsd = $r('app.string.psd_enter_psd_mix');
    const deviceRestartEnterPsd = $r('app.string.restart_enter_psd');
    return new Map<string, Resource>([
      [StrongAuthReasonFlags.USER_REQUEST + STRONG_AUTH_MULTI_USER, pleaseEnterPsdForSecurity],
      [StrongAuthReasonFlags.USER_REQUEST + STRONG_AUTH_SINGLE_USER, enterPsd],
      [StrongAuthReasonFlags.USER_TIMEOUT + STRONG_AUTH_MULTI_USER, regularVerifyPsdForSecurity],
      [StrongAuthReasonFlags.USER_TIMEOUT + STRONG_AUTH_SINGLE_USER, enterPsd],
      [StrongAuthReasonFlags.USER_REBOOT + STRONG_AUTH_MULTI_USER, deviceRestartEnterPsd],
      [StrongAuthReasonFlags.USER_REBOOT + STRONG_AUTH_SINGLE_USER, deviceRestartEnterPsd]
    ]);
  }

  private strongAuthTipsInitPin(): Map<string, Resource> {
    const pleaseEnterPinForSecurity = $r('app.string.please_enter_pin_for_security');
    const regularVerifyPinForSecurity = $r('app.string.regular_verify_pin_for_security');
    const enterPin = $r('app.string.psd_enter_psd');
    const deviceRestartEntePin = $r('app.string.restart_enter_pin');
    return new Map<string, Resource>([
      [StrongAuthReasonFlags.USER_REQUEST + STRONG_AUTH_MULTI_USER, pleaseEnterPinForSecurity],
      [StrongAuthReasonFlags.USER_REQUEST + STRONG_AUTH_SINGLE_USER, enterPin],
      [StrongAuthReasonFlags.USER_TIMEOUT + STRONG_AUTH_MULTI_USER, regularVerifyPinForSecurity],
      [StrongAuthReasonFlags.USER_TIMEOUT + STRONG_AUTH_SINGLE_USER, enterPin],
      [StrongAuthReasonFlags.USER_REBOOT + STRONG_AUTH_MULTI_USER, deviceRestartEntePin],
      [StrongAuthReasonFlags.USER_REBOOT + STRONG_AUTH_SINGLE_USER, deviceRestartEntePin]
    ]);
  }

  private getTipFromPromptMap(key: string): string {
    let keyType = VerifyDataManager.getInstance().getVerifyInfo(AuthType.PIN).authSubType;
    if (this.authTypePinTables.includes(keyType) && this.strongAuthTipsPin.has(key)) {
      return ResUtils.getInnerString(this.strongAuthTipsPin.get(key));
    } else if (this.strongAuthTipsPsd.has(key)) {
      return ResUtils.getInnerString(this.strongAuthTipsPsd.get(key));
    }
    return '';
  }
}