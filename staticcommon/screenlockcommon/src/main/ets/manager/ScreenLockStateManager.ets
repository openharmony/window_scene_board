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
import { EvtBus, ScreenLockEvent } from '@ohos/frameworkwrapper';
import { AbstractObserverManager } from '../base/AbstractObserverManager';
import { SCBSceneSessionManager } from '@ohos/windowscene/src/main/ets/TsIndex';
import { ScreenLockStatus } from '../interface/ScreenOnOffMediator';
import { AuthState, LockEventType, SlServerHelper } from '../utils/SlServerHelper';
import { AccountHelper, AuthType } from '../utils/AccountHelper';
import { VerifyDataManager, VerifyDataChangeListener, VerifyInfo} from './VerifyDataManager';
import { VerifyStateListener, ScreenLockVerifyService } from '../services/ScreenLockVerifyService';
import { ScreenLockUnlockService } from '../services/ScreenLockUnLockService';
import { SystemSwitchUtils } from '../utils/SystemSwitchUtils';

const TAG = 'ScreenLockStateManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 页面状态
 */
export enum PageState {
  /**
   * 未初始化
   */
  NONE = 0,

  /**
   * 显示
   */
  SHOW = 1,

  /**
   * 隐藏
   */
  HIDE = 2,
}

/**
 * 锁定状态
 */
export enum LockState {
  /**
   * 未初始化
   */
  NONE = 0,

  /**
   * 锁定
   */
  LOCKED = 1,

  /**
   * 已解锁
   */
  UNLOCKED = 2,
}

/**
 * 锁定状态信息
 */
export class LockStateInfo {
  /**
   * 页面状态
   */
  private _pageState: PageState = PageState.NONE;

  /**
   * 锁定状态
   */
  private _lockState: LockState = LockState.NONE;

  public get pageState(): PageState {
    return this._pageState;
  }

  protected set pageState(pageState: PageState) {
    this._pageState = pageState;
  }

  public get lockState(): LockState {
    return this._lockState;
  }

  protected set lockState(lockState: LockState) {
    this._lockState = lockState;
  }

  public get isPageShow(): boolean {
    return this._pageState === PageState.SHOW;
  }

  public get isLocked(): boolean {
    return this._lockState === LockState.LOCKED;
  }

  public toString(): string {
    return `<PageState: ${PageState[this._pageState]}, LockState: ${LockState[this._lockState]}>`;
  }
}

/**
 * 锁定状态信息
 */
class InnerLockStateInfo extends LockStateInfo {
  public get pageState(): PageState {
    return super.pageState;
  }

  public set pageState(pageState: PageState) {
    super.pageState = pageState;
  }

  public get lockState(): LockState {
    return super.lockState;
  }

  public set lockState(lockState: LockState) {
    super.lockState = lockState;
  }
}

/**
 * 状态信息
 */
export interface StateInfo {
  /**
   * 页面状态
   */
  pageState?: PageState;

  /**
   * 锁定状态
   */
  lockState?: LockState;

  /**
   * 是否在密码页
   */
  isInBouncer?: boolean;

  /**
   * 是否在编辑态
   */
  isInEdite?: boolean;
}

/**
 * 锁定状态变化监听器
 */
export interface ScreenLockStateChangeListener {
  /**
   * 变更函数
   *
   * @param lockStateInfo 锁定状态信息
   */
  onLockStateChange?: (lockStateInfo: LockStateInfo) => void;
}

/**
 * 锁屏状态管理器（注：这里必须有一个清晰的认识，锁屏状态本质是界面状态，状态的更新应该依赖于界面状态机）
 * 仅供锁屏内部模块使用
 */
export class ScreenLockStateManager extends AbstractObserverManager<ScreenLockStateChangeListener> {
  private static sInstance: ScreenLockStateManager;

  public static getInstance(): ScreenLockStateManager {
    if (ScreenLockStateManager.sInstance == null) {
      ScreenLockStateManager.sInstance = new ScreenLockStateManager();
    }
    return ScreenLockStateManager.sInstance;
  }

  private _lockStateInfo: InnerLockStateInfo;
  private _screenLockEvent: ScreenLockEvent = new ScreenLockEvent();

  private _hasBeenUnlocked: boolean = false; // 是否解锁过
  private _isInBouncer: boolean = false; // 是否在密码页
  private _isInEdite: boolean = false; // 是否在编辑态
  private _hasNoPwd: boolean = false; // 是否有设置密码
  private _isDeviceLocked: boolean = true; // 锁头状态，跟随onResult

  private constructor() {
    super();
    this._lockStateInfo = new InnerLockStateInfo();
    if (!SystemSwitchUtils.isUseNewScreenLock()) {
      log.showError('not support');
      return;
    }
    this.updateScreenLockState();
  }

  public get lockStateInfo(): LockStateInfo {
    return this._lockStateInfo;
  }

  public get isPageShow(): boolean {
    return this._lockStateInfo.isPageShow;
  }

  public get isLocked(): boolean {
    return this._lockStateInfo.isLocked;
  }

  public get isInBouncer(): boolean {
    return this._isInBouncer;
  }

  public get isInEdite(): boolean {
    return this._isInEdite;
  }

  public get isDeviceLocked(): boolean {
    return this._isDeviceLocked;
  }

  /**
   * 更新状态
   *
   * @param newStateInfo 新状态
   */
  public updateStateInfo(newStateInfo: StateInfo): void {
    if (newStateInfo.isInBouncer !== undefined && newStateInfo.isInBouncer !== this._isInBouncer) {
      this._isInBouncer = newStateInfo.isInBouncer;
    }
    if (newStateInfo.isInEdite !== undefined && newStateInfo.isInEdite !== this._isInEdite) {
      this._isInEdite = newStateInfo.isInEdite;
    }
    if ((newStateInfo.pageState && newStateInfo.pageState !== this._lockStateInfo.pageState) ||
      (newStateInfo.lockState && newStateInfo.lockState !== this._lockStateInfo.lockState)) {
      let oldState: string = this._lockStateInfo.toString();
      this._lockStateInfo.pageState = newStateInfo.pageState ?? this._lockStateInfo.pageState;
      this._lockStateInfo.lockState = newStateInfo.lockState ?? this._lockStateInfo.lockState;
      log.showWarn(`updateStateInfo oldState: ${oldState}, newState: ${this._lockStateInfo.toString()}`);
      const isUnLocked: boolean = this._lockStateInfo.lockState === LockState.UNLOCKED;
      SCBSceneSessionManager.getInstance().setUserAuthPassed(isUnLocked);
      this.broadcastDataChange(callback => callback.onLockStateChange?.(this._lockStateInfo));
      this.updateScreenLockState(true);
    }
  }

  /**
   * 更新锁头状态
   *
   * @param lockState 新状态
   * @param authType 认证类型
   */
  public updateLockAuthState(lockState: LockState, authType?: AuthType): void {
    if (this._hasNoPwd || SlServerHelper.getInstance().isScreenLockDisabled()) {
      return;
    }

    let oldAuthState = SlServerHelper.getInstance().getScreenLockAuthState();
    if (!this._hasBeenUnlocked && SlServerHelper.getInstance().isPreVerifyState(oldAuthState) &&
      authType === undefined) {
      // 隐私空间冷切首次进锁屏不修改预认证值
      log.showInfo('private space cold swith, no need to setAuthState null');
      return;
    }

    if (lockState === LockState.UNLOCKED && authType !== undefined) {
      this.updateDeviceLockState(authType);
    }

    if (lockState === LockState.LOCKED) {
      this.fileEncryptionStateChange();
    }
  }

  /**
   * 文件加密状态变更
   */
  public fileEncryptionStateChange(): void {
    if (!VerifyDataManager.getInstance().hasNoPwd) {
      // 文件加密
      AccountHelper.getInstance().fileEncryption();
      // 锁头状态变化
      this.updateDeviceLockState(null);
    }
    // onResult标记位重置
    ScreenLockUnlockService.getInstance().hasReceiveResult = false;
  }

  /**
   *  锁头状态变化
   */
  public updateDeviceLockState(authType: AuthType | null): void {
    this._isDeviceLocked = !authType;
    SlServerHelper.getInstance().setScreenLockAuthState(authType);
  }

  /**
   * 发布锁屏事件
   */
  public publishScreenLockEvent(): void {
    this.postScreenLockEvent();
  }

  protected doInit(): void {
    log.showInfo('doInit');
    // 注册锁屏状态事件生产者
    EvtBus.produceOn(ScreenLockEvent, this.onProduceScreenLockEvent.bind(this));
    // 监听密码变化
    VerifyDataManager.getInstance().registerObserver(this._verifyDataListener);
    // 监听认证结果
    ScreenLockVerifyService.getInstance().registerObserver(this._verifyResultListener);
  }

  protected doRelease(): void {
    log.showInfo('doRelease');
    // 注销锁屏状态事件生产者
    EvtBus.produceOff(ScreenLockEvent, this.onProduceScreenLockEvent.bind(this));
    // 注销密码变化
    VerifyDataManager.getInstance().unRegisterObserver(this._verifyDataListener);
    // 注销监听认证结果
    ScreenLockVerifyService.getInstance().unRegisterObserver(this._verifyResultListener);
  }

  private onProduceScreenLockEvent(): ScreenLockEvent {
    return this._screenLockEvent;
  }

  private updateScreenLockState(isNeedBroadcast: boolean = false): void {
    if (this._lockStateInfo.pageState === PageState.HIDE) {
      this._screenLockEvent.isLockScreen = false;
      AppStorage.setOrCreate('lockStatus', ScreenLockStatus.UNLOCK);
    } else {
      this._screenLockEvent.isLockScreen = true;
      AppStorage.setOrCreate('lockStatus', ScreenLockStatus.LOCKING);
    }
    if (this._lockStateInfo.lockState === LockState.UNLOCKED) {
      this._screenLockEvent.lockStatus = ScreenLockEvent.LOCK_STATUS_UNLOCK;
      this._hasBeenUnlocked = true;
    } else {
      this._screenLockEvent.lockStatus = ScreenLockEvent.LOCK_STATUS_SECURE;
    }
    // 发送事件
    if (isNeedBroadcast) {
      this.postScreenLockEvent();
    }
  }

  private postScreenLockEvent(): void {
    EvtBus.post(ScreenLockEvent, this._screenLockEvent);
  }

  private readonly _verifyDataListener : VerifyDataChangeListener = {
    onVerifyInfoChange: (authType: AuthType, verifyInfo: VerifyInfo) => {
      if (authType !== AuthType.PIN || VerifyDataManager.getInstance().hasNoPwd === this._hasNoPwd) {
        return;
      }
      if (VerifyDataManager.getInstance().hasNoPwd) {
        // 监听首次无密码，设为PIN解锁
        this.updateDeviceLockState(AuthType.PIN);
        this._hasNoPwd = true;
      } else {
        this._hasNoPwd = false;
      }
    }
  };

  private readonly _verifyResultListener: VerifyStateListener = {
    onAuthSuccessResult: (authType: AuthType): void => {
      if (this._lockStateInfo.pageState === PageState.HIDE && !ScreenLockUnlockService.getInstance().hasReceiveResult) {
        // 锁屏退出且首次onResult执行
        log.showInfo('send unlock screenlockEvent after receive onResult');
        SlServerHelper.getInstance().sendScreenLockEvent(LockEventType.UNLOCK_SCREEN_RESULT);
      }
      if (this._lockStateInfo.lockState !== LockState.LOCKED) {
        this.updateDeviceLockState(authType);
      }
      ScreenLockUnlockService.getInstance().hasReceiveResult = true;
    }
  };
}