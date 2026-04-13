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
  AccountHelper,
  SlServerHelper,
  SwitchEventData,
  VerifyDataManager,
  UserSwitchListener,
  UserSwitchService,
  StrongAuthStateManager,
  ScreenLockStateManager,
  ScreenLockUnlockService,
  PowerUtils,
  LockState,
  LockEventType,
  ScreenLockVerifyService,
  FingerAuthReportHelper
} from '@ohos/screenlockcommon';
import { RemoteLockStateManager } from '@ohos/screenlockcommon/Index';
import { ScreenOnOffService } from '@ohos/screenlockcommon/src/main/ets/services/ScreenOnOffService';
import { SCBScreenSessionManager } from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSessionManager';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { CoreEventType, CoreStateTypeUtils } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { AbstractEventAdapter } from './AbstractEventAdapter';
import sSCBOobeManager from '@ohos/windowscene/src/main/ets/oobe/SCBOobeManager';

const TAG = 'UserSwitchEventAdapter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const UNLOCK_INACTIVE_DELAY: number = 15000;

/**
 * 用户切换事件适配器
 */
export class UserSwitchEventAdapter extends AbstractEventAdapter {
  private _userSwitchListener: UserSwitchListener = {
    onSwitching: this.handleSwitchingEvent.bind(this),
    onSwitched: this.handleSwitchedEvent.bind(this),
  };
  private _inactiveTimeout: number = 0;

  protected doInit(): void {
    log.showInfo('doInit');
    UserSwitchService.getInstance().registerObserver(this._userSwitchListener);

    // 启动即默认当前用户激活
    this.handleCurrentUserActive(true);
  }

  protected doRelease(): void {
    log.showInfo('doRelease');
    UserSwitchService.getInstance().unRegisterObserver(this._userSwitchListener);
    this.clearInactiveTimeout();
  }

  private clearInactiveTimeout(): boolean {
    if (this._inactiveTimeout !== 0) {
      clearTimeout(this._inactiveTimeout);
      this._inactiveTimeout = 0;
      return true;
    }
    return false;
  }

  private handleSwitchingEvent(switchData: SwitchEventData): void {
    VerifyDataManager.getInstance().updateVerifyData();
    VerifyDataManager.getInstance().updateOtherUserProperty();
    log.showInfo(`receive user switching, <${switchData?.fromAccountId} -> ${switchData?.toAccountId}>`);
  }

  private handleSwitchedEvent(switchData: SwitchEventData): void {
    log.showInfo(`receive user switched, <${switchData?.fromAccountId} -> ${switchData?.toAccountId}>`);
    this.enableRotate();
    if (!switchData) {
      log.showWarn('handleSwitchedEvent invalid switchData.');
      return;
    }
    if (AccountHelper.getInstance().currentLocalId === switchData.toAccountId) {
      // 处理当前用户激活
      this.handleCurrentUserActive(false);
    } else {
      if (CoreStateTypeUtils.isInUnlockPage(this.fsmProxy.coreFsm.currentStateType)) {
        // 从非锁屏页（例如：设置）进入隐私空间场景，避免页面被遮挡影响体验，不能马上切换，但由于无法获取前台进程遮盖时机，因此当前采用延时机制。
        log.showWarn('current user delay be inactive.');
        this._inactiveTimeout = setTimeout(() => {
          this._inactiveTimeout = 0;
          this.fsmProxy.submitCoreEvent(CoreEventType.USER_DEACTIVATE);
        }, UNLOCK_INACTIVE_DELAY);
        ScreenLockStateManager.getInstance().updateLockAuthState(LockState.LOCKED);
      } else {
        // 当前用户去激活，则上锁
        log.showWarn('current user be inactive.');
        this.fsmProxy.submitCoreEvent(CoreEventType.USER_DEACTIVATE);
      }
    }
  }

  private enableRotate(): void {
    try {
      const session = SCBScreenSessionManager.getInstance().getMainScreenSession();
      if (session) {
        session.setEnableRotate(true, ScreenOnOffService.ENABLE_ROTATE_REASON);
      }
    } catch (error) {
      log.showError(`enableRotate fail. code ${error.code}`);
    }
  }

  private handleCurrentUserActive(isStartScene: boolean): void {
    if (isStartScene && !PowerUtils.isActive()) {
      // 启动场景下，由于耗时较长，电源会处于活动状态，若处于掉电状态，说明进行了熄屏操作，此时需要进行强制下电
      this.handlePowerOffUserActive();
      if (!VerifyDataManager.getInstance().hasNoPwd) {
        ScreenLockStateManager.getInstance().fileEncryptionStateChange();
      }
    } else {
      this.handlePowerOnUserActive(isStartScene);
    }
  }

  private handlePowerOffUserActive(): void {
    log.showInfo('handlePowerOffUserActive');
    if (sSCBOobeManager.isEnable() && VerifyDataManager.getInstance().hasNoPwd &&
      CoreStateTypeUtils.isInUnlockPage(this.fsmProxy.coreFsm.currentStateType)) {
      log.showInfo('no pwd and in oobe, do nothing.');
    } else if (CoreStateTypeUtils.isInScreenOn(this.fsmProxy.coreFsm.currentStateType)) {
      this.fsmProxy.submitCoreEvent(CoreEventType.FORCE_SCREEN_OFF);
    }
  }

  private UserSwitchBroadcast(authType: AuthType): void {
    FingerAuthReportHelper.getInstance().unlockReport(authType, true);
    ScreenLockStateManager.getInstance().updateLockAuthState(LockState.UNLOCKED, authType);
    ScreenLockUnlockService.getInstance().unlockUserSwitch = true;
    ScreenLockVerifyService.getInstance().lastSuccessAuthType = authType;
    this.fsmProxy.submitCoreEvent(CoreEventType.UNLOCK_DIRECT);
  }

  private handlePowerOnUserActive(isStartScene: boolean): void {
    log.showInfo('handlePowerOnUserActive');
    // 切换用户场景，电源事件分发具有不确定性，此处为容错处理
    if (CoreStateTypeUtils.isInScreenOff(this.fsmProxy.coreFsm.currentStateType)) {
      this.fsmProxy.submitCoreEvent(CoreEventType.SCREEN_ON);
    }

    let isInInactiveTimeout: boolean = this.clearInactiveTimeout();
    let authType: AuthType = SlServerHelper.getInstance().getSwitchAccountAuthState();
    switch (authType) {
      case AuthType.FINGERPRINT:
        if (StrongAuthStateManager.getInstance().isNeedStrongAuth()) {
          log.showInfo(TAG, 'handlePowerOnUserActive fingerprint REQUEST_UNLOCK.');
          if (isInInactiveTimeout) {
            this.fsmProxy.submitCoreEvent(CoreEventType.USER_DEACTIVATE);
          }
          this.fsmProxy.submitCoreEvent(CoreEventType.REQUEST_UNLOCK);
        } else {
          log.showInfo('handlePowerOnUserActive fingerprint UNLOCK_DIRECT.');
          if (isInInactiveTimeout && CoreStateTypeUtils.isInUnlockPage(this.fsmProxy.coreFsm.currentStateType)) {
            // 目标空间未上锁，需要发送解锁广播
            SlServerHelper.getInstance().sendScreenLockEvent(LockEventType.UNLOCK_SCREEN_RESULT);
          }
          this.UserSwitchBroadcast(authType);
        }
        break;
      case AuthType.PIN:
        log.showInfo('handlePowerOnUserActive pwd UNLOCK_DIRECT.');
        if (isInInactiveTimeout && CoreStateTypeUtils.isInUnlockPage(this.fsmProxy.coreFsm.currentStateType)) {
          // 目标空间未上锁，需要发送解锁广播
          SlServerHelper.getInstance().sendScreenLockEvent(LockEventType.UNLOCK_SCREEN_RESULT);
        }
        this.UserSwitchBroadcast(authType);
        break;
      default:
        if (isInInactiveTimeout) {
          this.fsmProxy.submitCoreEvent(CoreEventType.USER_DEACTIVATE);
        } else if (!isStartScene && !CoreStateTypeUtils.isUnlockState(this.fsmProxy.coreFsm.currentStateType)) {
          // 切到目标空间，目标空间需要上锁
          ScreenLockStateManager.getInstance().fileEncryptionStateChange();
          SlServerHelper.getInstance().sendScreenLockEvent(LockEventType.LOCK_SCREEN_RESULT);
        }
        if (!VerifyDataManager.getInstance().hasNoPwd && StrongAuthStateManager.getInstance().isNeedStrongAuth() &&
          !RemoteLockStateManager.getInstance().isRemoteLocked) {
          log.showInfo(TAG, 'handlePowerOnUserActive current user has pwd and need strong auth.');
          this.fsmProxy.submitCoreEvent(CoreEventType.REQUEST_UNLOCK);
        } else {
          log.showInfo('handlePowerOnUserActive from other.');
          this.fsmProxy.submitCoreEvent(CoreEventType.USER_ACTIVATE);
        }
        break;
    }
  }
}
