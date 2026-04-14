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

import screenLock from '@ohos.screenLock';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AbstractObserverManager } from '../base/AbstractObserverManager';
import { AccountHelper, AuthType } from './AccountHelper';
import { DfxFaultEventTag, HiKGReportBase } from '../record/report/PerformanceMonitorUtil';

const TAG = 'SlServerHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const SCREEN_LOCK_SERVICE_RETRY_INTERVAL: number = 2000;
const UNKNOWN_AUTH_TYPE: number = -1;

/**
 * 锁屏事件类型
 */
export enum LockEventType {
  /**
   * 锁屏事件通知
   */
  LOCK_SCREEN_RESULT = 'lockScreenResult',

  /**
   * 解锁事件通知，当前只有密码
   */
  UNLOCK_SCREEN_RESULT = 'unlockScreenResult',

  /**
   * 此事件用于通知锁屏已经绘制，可以进行后续操作，亮屏时需要重新进行通知
   */
  SCREEN_DRAW_DONE = 'screenDrawDone',
}

/**
 * 锁屏相关操作结果
 */
export enum LockOperateResult {
  Success = 0,
  Fail = 1,
  Cancel = 2,
  EarlySuccess = 3, // 更新isLocked状态但是不发解锁广播
  AlreadyUnlocked = 4,
}

/**
 * 验证状态
 */
export enum AuthState {
  UNAUTH = 0,

  PRE_AUTHED_BY_CREDENTIAL = 1,

  PRE_AUTHED_BY_FINGERPRINT = 2,

  PRE_AUTHED_BY_FACE = 3,

  AUTHED_BY_CREDENTIAL = 4,

  AUTHED_BY_FINGERPRINT = 5,

  AUTHED_BY_FACE = 6,
}

/**
 * 锁屏管理服务事件监听
 */
export interface SlEventListener {
  /**
   * 服务侧事件回调
   *
   * @param event 服务侧事件
   */
  onSystemEvent?: (event: screenLock.SystemEvent) => void;

  /**
   * 服务重启开始回调
   */
  onBeginServiceRestart?: () => void;

  /**
   * 服务重启结束回调
   */
  onEndServiceRestart?: () => void;

  /**
   * 连接时回调
   */
  onConnect?: () => void;
}

/**
 * 锁屏管理服务工具类
 */
export class SlServerHelper extends AbstractObserverManager<SlEventListener> {
  private static sInstance: SlServerHelper;

  public static getInstance(): SlServerHelper {
    if (!SlServerHelper.sInstance) {
      SlServerHelper.sInstance = new SlServerHelper();
    }
    return SlServerHelper.sInstance;
  }

  private _currentUserActive: boolean = true;

  private _restartTimeoutId: number = 0;

  private constructor() {
    super();
  }

  public setCurrentUserActive(isActive: boolean): void {
    this._currentUserActive = isActive;
  }

  /**
   * 检查当前用户锁屏是否去使能
   *
   * @returns true是/false否
   */
  public isScreenLockDisabled(): boolean {
    try {
      let isDisabled: boolean = screenLock.isScreenLockDisabled(AccountHelper.getInstance().currentLocalId);
      if (isDisabled) {
        log.showInfo(`isScreenLockDisabled ${isDisabled}`);
      }
      return isDisabled;
    } catch (error) {
      log.showError(`screenLockMgr error -> isScreenLockDisabled, errorCode: ${error?.code}`);
      HiKGReportBase.reportFault(DfxFaultEventTag.SCREEN_LOCK_MGR_ERROR,
        Object({ NAME: 'isScreenLockDisabled', CODE: error?.code }));
    }
    return false;
  }

  /**
   * 监听事件回调
   *
   * @param callback 回调
   */
  public onSystemEvent(): void {
    log.showInfo('onSystemEvent start.');
    try {
      let isSuccess = screenLock.onSystemEvent((event: screenLock.SystemEvent) => {
        log.showDebug('onSystemEvent callback');
        if (event?.eventType === 'serviceRestart') {
          this.handleSlException();
        } else {
          this.broadcastDataChange(observer => observer?.onSystemEvent?.(event));
        }
      });
      log.showInfo(`onSystemEvent result is : ${isSuccess}`);
      this.broadcastDataChange(observer => observer?.onConnect?.());
    } catch (error) {
      log.showError(`screenLockMgr error -> onSystemEvent, errorCode: ${error?.code}`);
      HiKGReportBase.reportFault(DfxFaultEventTag.SCREEN_LOCK_MGR_ERROR,
        Object({ NAME: 'onSystemEvent', CODE: error?.code }));
      this.handleSlException();
    }
    log.showInfo('onSystemEvent end.');
  }

  /**
   * 发送锁屏事件
   *
   * @param eventType 事件类型
   * @param result 操作结果
   */
  public sendScreenLockEvent(eventType: LockEventType, result: LockOperateResult = LockOperateResult.Success): void {
    if (!this._currentUserActive) {
      // 此处是一个非常不合理的方案设计，只有前台用户能够发送，后台用户不能发送
      log.showInfo('sendScreenLockEvent not ForegroundUser, do nothing.');
      return;
    }
    try {
      screenLock.sendScreenLockEvent(eventType, result, (err) => {
        if (err) {
          log.showError(`screenLockMgr error -> sendScreenLockEvent ${eventType}:
          ${LockOperateResult[result]}. code ${err.code}`);
          HiKGReportBase.reportFault(DfxFaultEventTag.SCREEN_LOCK_MGR_ERROR,
            Object({ NAME: 'sendScreenLockEvent', CODE: err?.code }));
          return;
        }
        log.showInfo(`sendScreenLockEvent ${eventType}: ${LockOperateResult[result]} success`);
      });
    } catch (error) {
      log.showError(`screenLockMgr error -> sendScreenLockEvent ${eventType}: ${LockOperateResult[result]} failed.`);
      HiKGReportBase.reportFault(DfxFaultEventTag.SCREEN_LOCK_MGR_ERROR,
        Object({ NAME: 'sendScreenLockEvent', CODE: error?.code }));
    }
  }

  /**
   * 获取强制认证原因
   *
   * @param userId 账号ID
   */
  public getStrongAuth(userId?: number): number {
    try {
      return screenLock.getStrongAuth(userId ?? AccountHelper.getInstance().currentLocalId);
    } catch (error) {
      log.showError(`screenLockMgr error -> getStrongAuth failed. code ${error?.code}`);
      HiKGReportBase.reportFault(DfxFaultEventTag.SCREEN_LOCK_MGR_ERROR,
        Object({ NAME: 'getStrongAuth', CODE: error?.code }));
    }
    return 0;
  }

  /**
   * 设置其他账号的解锁类型
   *
   * @param authType 解锁类型
   * @param userId 账号ID
   * @param isSwitch 切换账号
   */
  public setScreenLockAuthState(authType: AuthType | null, userId?: number, isSwitch: boolean = false): void {
    let authState: number;
    switch (authType) {
      case AuthType.PIN:
        authState = isSwitch ? AuthState.PRE_AUTHED_BY_CREDENTIAL : AuthState.AUTHED_BY_CREDENTIAL;
        break;
      case AuthType.FINGERPRINT:
        authState = isSwitch ? AuthState.PRE_AUTHED_BY_FINGERPRINT : AuthState.AUTHED_BY_FINGERPRINT;
        break;
      case AuthType.FACE:
        authState = isSwitch ? AuthState.PRE_AUTHED_BY_FACE : AuthState.AUTHED_BY_FACE;
        break;
      default:
        authState = AuthState.UNAUTH;
        break;
    }
    try {
      let realUser: number = userId ?? AccountHelper.getInstance().currentLocalId;
      log.showInfo(`setScreenLockAuthState, authState: ${authState}, userId: ${realUser}`);
      screenLock.setScreenLockAuthState(authState, realUser, new Uint8Array([realUser]));
      log.showDebug('setScreenLockAuthState success');
    } catch (error) {
      log.showError(`screenLockMgr error -> setScreenLockAuthState failed. code: ${error?.code}`);
      HiKGReportBase.reportFault(DfxFaultEventTag.SCREEN_LOCK_MGR_ERROR,
        Object({ NAME: 'setScreenLockAuthState', CODE: error?.code }));
    }
  }

  /**
   * 切换账号后获取解锁类型
   *
   * @param userId 账号ID
   * @returns 解锁类型
   */
  public getSwitchAccountAuthState(userId?: number): AuthType {
    let authState: number;
    try {
      authState = screenLock.getScreenLockAuthState(userId ?? AccountHelper.getInstance().currentLocalId);
    } catch (error) {
      log.showError(`screenLockMgr error -> getSwitchAccountAuthState. code: ${error?.code}`);
      HiKGReportBase.reportFault(DfxFaultEventTag.SCREEN_LOCK_MGR_ERROR,
        Object({ NAME: 'getScreenLockAuthState', CODE: error?.code }));
      authState = screenLock.AuthState.UNAUTH;
    }
    let authType: AuthType;
    if (authState === AuthState.PRE_AUTHED_BY_CREDENTIAL) {
      authType = AuthType.PIN;
    } else if (authState === AuthState.PRE_AUTHED_BY_FINGERPRINT) {
      authType = AuthType.FINGERPRINT;
    } else {
      authType = UNKNOWN_AUTH_TYPE;
    }
    log.showInfo(`getSwitchAccountAuthState, authType: ${authType}, authState: ${authState}`);
    return authType;
  }

  public isPreVerifyState(authSate: AuthState): boolean {
    return authSate === AuthState.PRE_AUTHED_BY_CREDENTIAL || authSate === AuthState.PRE_AUTHED_BY_FINGERPRINT ||
      authSate === AuthState.PRE_AUTHED_BY_FACE;
  }

  public getScreenLockAuthState(userId?: number): AuthState {
    let authState: number;
    try {
      authState = screenLock.getScreenLockAuthState(userId ?? AccountHelper.getInstance().currentLocalId);
    } catch (error) {
      log.showError(`getScreenLockAuthState failed. code: ${error.code}`);
      authState = screenLock.AuthState.UNAUTH;
    }
    log.showInfo(`getScreenLockAuthState, authState: ${authState}`);
    return authState;
  }

  private handleSlException(): void {
    log.showInfo('handleSlException');
    if (this._restartTimeoutId) {
      clearTimeout(this._restartTimeoutId);
    } else {
      this.broadcastDataChange(observer => observer?.onBeginServiceRestart?.());
    }
    this._restartTimeoutId = setTimeout(() => {
      this.onSystemEvent();
      this.broadcastDataChange(observer => observer?.onEndServiceRestart?.());
    }, SCREEN_LOCK_SERVICE_RETRY_INTERVAL);
  }
}