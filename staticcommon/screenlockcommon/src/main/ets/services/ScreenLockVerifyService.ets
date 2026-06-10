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

import osAccount from '@ohos.account.osAccount';
import util from '@ohos.util';
import { CheckEmptyUtils, LogDomain, LogHelper, ObjUtil, Trace } from '@ohos/basicutils';
import { DeviceHelper, EvtBus, HiDfxEventUtil, OuterHomeCallbackEvent } from '@ohos/frameworkwrapper';
import { AbstractInitialAble } from '../base/AbstractInitialAble';
import { AbstractObserverManager } from '../base/AbstractObserverManager';
import { KeyGuardCacheKey, KeyGuardMode } from '../bean/KeyGuardStatusEnum';
import { KeyguardStatusService } from '../manager/KeyguardStatusService';
import {
  LockState,
  LockStateInfo,
  ScreenLockStateChangeListener,
  ScreenLockStateManager
} from '../manager/ScreenLockStateManager';
import { StrongAuthStateManager } from '../manager/StrongAuthStateManager';
import {
  VerifyDataChangeListener,
  VerifyDataManager,
  VerifyInfo
} from '../manager/VerifyDataManager';
import { SimCardStateManager } from '../manager/SimCardStateManager';
import { CameraStateManager } from '../manager/CameraStateManager';
import { CacheValue, GlobalStatusCache } from '../base/GlobalStatusCache';
import { SLFaultTag } from '../record/report/ReportTag';
import { AccountHelper, AuthTrustLevel, AuthType, IAMAuthResult, SwitchEventData } from '../utils/AccountHelper';
import { FingerAuthReportHelper } from '../utils/FingerAuthReportHelper';
import { HiKGReportTimeout, HiKGReportBase, TIMEOUT_PARAMS } from '../record/report/PerformanceMonitorUtil';
import { SlServerHelper } from '../utils/SlServerHelper';
import { SlUnlockReportHelper } from '../record/report/SlUnlockReportHelper';
import { UserSwitchListener, UserSwitchService } from './UserSwitchService';

const TAG = 'ScreenLockVerifyService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const EVENT_CODE_KEYGUARD_AUTH_RESULT: number = 1;
const UNLOCK_ASSIGN_USER: number = 10001; // 仅认证指定用户
const UNLOCK_SILENCE: number = 10006; // 静默认证 | 联动认证
const UNLOCK_SILENCE_ASSIGN_USER: number = 10007; // 静默认证 | 仅认证指定用户
const INVALID_HANDLE_TOKEN = ''; // 默认无效TOKEN

/**
 * 验证结果
 */
export enum VerifyResult {
  /**
   * 验证成功
   */
  SUCCESS = 1,

  /**
   * 验证失败
   */
  FAIL = 2,

  /**
   * 其他用户验证成功
   */
  OTHER_SUCCESS = 3,
  /**
   * 用户取消
   */
  CANCEL = 4,

  /*
   * 强认证禁止跨设备解锁
  */
  FAIL_STRONG_AUTH = 1001,

  /*
   * SIM卡锁定禁止跨设备解锁
  */
  FAIL_SIM_LOCKED = 1002,

  /*
   * 锁屏已退出禁止跨设备解锁
  */
  FAIL_UNLOCK_ALREADY = 1003,
}

/**
 * 密码提示码
 */
export enum PasswordAcquireCode {
  /**
   * 密码结果
   */
  PASSWORD_ACQUIRE_RESULT = 1,
}

export enum IAMResultCode {
  SUCCESS = 0,
  FAIL = 12300101,
  CANCEL = 12300109,
}

/**
 * 提示额外信息
 */
export interface AcquireExtraInfo {
  authResult: number;
  authRemainAttempts: number;
  lockoutDuration: number;
  userId: number;
}

export interface OnAcquireInfo {
  authType: number;
  moduleId: number;
  acquire: number;
  extraInfo: Uint8Array;
}

/**
 * 验证阶段监听器
 */
export interface VerifyStateListener {
  /**
   * 验证状态变更
   *
   * @param authType 验证类型
   * @param verifyResult 验证结果
   */
  onVerifyResult?: (authType: AuthType, verifyResult: VerifyResult) => void;

  /**
   * 身份认证信息回调
   *
   * @param authType 验证类型
   * @param module 用于身份验证的执行器类型
   * @param acquire 不同身份验证执行器的tip代码
   * @param extraInfo 额外信息
   */
  onAcquireInfo?: (authType: AuthType, module: number, acquire: number, extraInfo?: AcquireExtraInfo) => void;

  /**
   * 验证状态变更
   *
   * @param authType 验证类型
   * @param isVerifying 是否验证中
   */
  onVerifyStateChange?: (authType: AuthType, isVerifying: boolean) => void;

  /**
   * 认证成功并收到result回调，代表文件解密
   *
   * @param authType 验证类型
   */
  onAuthSuccessResult?: (authType: AuthType) => void;
};

/**
 * 结果处理接口
 */
export interface ResultHandler {
  get authType(): AuthType;

  get authTypeStr(): string;

  /**
   * 设置已处理结果，阻止后续处理
   */
  setHasHandleResult(): void;

  /**
   * 设置已处理验证信息，阻止后续处理
   */
  setHasHandleAcquireInfo(): void;

  /**
   * 标记onAcquire已经认证成功
   */
  setMarkAcquireSuccess(): void;

  /**
   * 各种认证方式提前认证成功的统一回调
   */
  onPreVerifySuccess?(): void;

  /**
   * 广播验证结果
   *
   * @param result 认证结果
   */
  broadcastResult(result: number, authType?: AuthType): void;

  /**
   * 广播身份验证信息
   *
   * @param acquireInfo 身份验证信息
   * @param listener 监听器
   */
  broadcastAcquireInfo(module: number, acquire: number, extraInfo: AcquireExtraInfo): void;

  /**
   * 向OuterHome发送认证结果
   *
   * @param result 认证结果
   */
  sendAuthResultToOuterHome(result: number): void;
}

/**
 * 验证拦截器
 */
export abstract class VerifyInterceptor extends AbstractInitialAble {
  public readonly authType: AuthType;
  private _next?: VerifyInterceptor;

  constructor(authType: AuthType) {
    super();
    this.authType = authType;
  }

  public endTrace(): void {
  }

  public get next(): VerifyInterceptor | undefined {
    return this._next;
  }

  public set next(nextInterceptor: VerifyInterceptor | undefined) {
    this._next = nextInterceptor;
  }

  public get verifyInfo(): VerifyInfo {
    return VerifyDataManager.getInstance().getVerifyInfo(this.authType);
  }

  /**
   * 结果回调拦截
   *
   * @param _handler 结果处理器
   * @param _result 验证结果
   * @param _extraInfo 验证结果额外信息
   * @returns 是否中止处理
   */
  public onVerifyResult(handler: ResultHandler, result: number, extraInfo?: osAccount.AuthResult): boolean {
    return false;
  }

  /**
   * 身份认证信息回调拦截
   *
   * @param _handler 结果处理器
   * @param _module 验证器
   * @param _acquire Tips提示码
   * @param _extraInfo 额外信息
   * @returns 是否中止处理
   */
  public onAcquireInfo(handler: ResultHandler, module: number, acquire: number, extraInfo?: AcquireExtraInfo): boolean {
    return false;
  }

  protected doInit(params?: number | object | undefined): void {
  }

  protected doRelease(): void {
  }
}

/**
 * 验证状态监听管理器
 */
abstract class VerifyListenerManager extends AbstractObserverManager<VerifyStateListener> {
  private _lastSuccessAuthType: number = 0; // 记录最好验证成功的验证类型

  public set lastSuccessAuthType(lastSuccessAuthType: number) {
    this._lastSuccessAuthType = lastSuccessAuthType;
  }

  public get lastSuccessAuthType(): number {
    return this._lastSuccessAuthType;
  }

  /**
   * 触发结果回调
   *
   * @param authType 验证类型
   * @param verifyState 验证状态
   */
  public broadcastResult(authType: AuthType, verifyStep: VerifyResult): void {
    log.showInfo(`broadcastVerifyResult authType ${AuthType[authType]}, verifyStep ${VerifyResult[verifyStep]}`);
    this.broadcastDataChange(listener => listener?.onVerifyResult?.(authType, verifyStep));
  }

  /**
   * 认证成功并收到result回调，代表文件解密
   *
   * @param authType 验证类型
   */
  public broadcastAuthSuccessResult(authType: AuthType): void {
    log.showInfo(`broadcastAuthSuccessResult authType ${AuthType[authType]}`);
    this.broadcastDataChange(listener => listener?.onAuthSuccessResult?.(authType));
  }

  /**
   * 触发身份验证信息回调
   *
   * @param authType 验证类型
   * @param module 用于身份验证的执行器类型
   * @param acquire 不同身份验证执行器的tip代码
   * @param extraInfo 额外信息
   */
  public broadcastAcquireInfo(authType: AuthType, module: number, acquire: number, extraInfo?: AcquireExtraInfo): void {
    this.broadcastDataChange(listener => listener?.onAcquireInfo?.(authType, module, acquire, extraInfo));
  }

  /**
   * 触发验证状态变更通知
   *
   * @param authType 验证类型
   * @param isVerifying 是否验证中
   */
  public broadcastVerifyStateChange(authType: AuthType, isVerifying: boolean): void {
    super.broadcastDataChange(listener => listener?.onVerifyStateChange?.(authType, isVerifying));
  }
}

/**
 * 抽象结果处理器
 */
abstract class AbstractResultHandler extends AbstractInitialAble implements ResultHandler {
  public readonly authType: AuthType;
  protected readonly _listenerManager: VerifyListenerManager;
  protected _hasHandleResult: boolean = false; // 是否已处理结果
  protected _hasHandleAcquireInfo: boolean = false; // 是否已处理acquireInfo
  protected _isAcquireSuccess: boolean; // 标记onAcquire是否已经认证成功

  constructor(authType: AuthType, listenerManager: VerifyListenerManager) {
    super();
    this.authType = authType;
    this._listenerManager = listenerManager;
    this._isAcquireSuccess = false;
  }

  public get authTypeStr(): string {
    return AuthType[this.authType];
  }

  public setHasHandleResult(): void {
    this._hasHandleResult = true;
  }

  public setHasHandleAcquireInfo(): void {
    this._hasHandleAcquireInfo = true;
  }

  public setMarkAcquireSuccess(): void {
    this._isAcquireSuccess = true;
  }

  public broadcastResult(result: number, authType: AuthType = this.authType): void {
    let verifyResult: VerifyResult = VerifyResult.FAIL;
    switch (result) {
      case IAMResultCode.SUCCESS:
        verifyResult = VerifyResult.SUCCESS;
        break;
      case IAMResultCode.CANCEL:
        verifyResult = VerifyResult.CANCEL;
        break;
      default:
        verifyResult = VerifyResult.FAIL;
    }
    if (verifyResult === VerifyResult.SUCCESS) {
      this._listenerManager.lastSuccessAuthType = authType;
      VerifyDataManager.getInstance().updateVerifyData();
    }
    this._listenerManager.broadcastResult(authType, verifyResult);
  }

  public broadcastAcquireInfo(module: number, acquire: number, extraInfo?: AcquireExtraInfo): void {
    this._listenerManager.broadcastAcquireInfo(this.authType, module, acquire, extraInfo);
  }

  public broadcastStateChange(isVerifying: boolean): void {
    this._listenerManager.broadcastVerifyStateChange(this.authType, isVerifying);
  }

  public sendAuthResultToOuterHome(result: number): void {
    if (DeviceHelper.isSmallFoldProduct()) {
      const eventData = JSON.stringify({
        authType: this.authType, result: result
      });
      let outerHomeCallbackEvent = new OuterHomeCallbackEvent(EVENT_CODE_KEYGUARD_AUTH_RESULT, eventData);
      EvtBus.post(OuterHomeCallbackEvent, outerHomeCallbackEvent);
    }
  }
}

/**
 * 认证的识别上下文对象
 */
interface VerifyContextId {
  contextId: Uint8Array;
  verifySuccess: boolean;
}

/**
 * 抽象监听器
 */
abstract class AbstractVerifier extends AbstractResultHandler {
  protected readonly _isAutoOpen: boolean;
  protected _authLevel: AuthTrustLevel;
  protected _isVerifying: boolean = false;

  private readonly _cancelContextIds: Map<String, VerifyContextId> = new Map();
  private readonly _interceptors: VerifyInterceptor[] = [];
  private _isPageStateOpen: boolean = true; // 页面状态是否可解锁，由根页控制
  private _isOperateOpen: boolean = true; // 叠加在页面状态上的交互状态，例如解锁页被覆盖时，此时操作状态为false
  private _handleResultToken: string = INVALID_HANDLE_TOKEN; // 标记可处理结果的令牌

  constructor(authType: AuthType, authLevel: AuthTrustLevel, isAutoOpen: boolean,
    listenerManager: VerifyListenerManager) {
    super(authType, listenerManager);
    this._authLevel = authLevel;
    this._isAutoOpen = isAutoOpen;
  }

  /**
   * 注册拦截器
   *
   * @param authType 验证类型
   * @param observer 拦截器
   */
  public registerInterceptor(interceptor: VerifyInterceptor): void {
    log.showInfo(`add ${this.authTypeStr} verify interceptor.`);
    if (!this._interceptors.includes(interceptor)) {
      this._interceptors.push(interceptor);
    }
  }

  /**
   * 注销拦截器
   *
   * @param authType 验证类型
   * @param observer 拦截器
   */
  public unRegisterInterceptor(interceptor: VerifyInterceptor): void {
    log.showInfo(`delete ${this.authTypeStr} verify interceptor.`);
    let index = this._interceptors.indexOf(interceptor);
    if (index >= 0) {
      this._interceptors.slice(index, 1);
    }
  }

  /**
   * 页面状态是否开启解锁
   *
   * @param isPageStateOpen 页面状态
   * @param isAutoVerify isPageStateOpen为true时是否自动认证
   */
  public setIsPageStateOpen(isPageStateOpen: boolean, isAutoVerify: boolean = true): void {
    if (this._isPageStateOpen !== isPageStateOpen) {
      this._isPageStateOpen = isPageStateOpen;
      if (!isPageStateOpen || isAutoVerify) {
        this.autoUpdateState();
      }
    }
  }

  /**
   * 更新交互状态
   *
   * @param isOperateOpen 交互状态
   * @param isAutoVerify isOperateOpen为true时是否自动认证
   */
  public setIsOperateOpen(isOperateOpen: boolean, isAutoVerify: boolean = true): void {
    if (this._isOperateOpen !== isOperateOpen) {
      this._isOperateOpen = isOperateOpen;
    }
    if (isOperateOpen && !isAutoVerify) {
      return;
    }
    this.autoUpdateState();
  }

  /**
   * 是否正在验证中
   *
   * @returns true验证中/false不在验证中
   */
  public get isVerifying(): boolean {
    return this._isVerifying;
  }

  /**
   * 自动更新验证状态
   */
  public autoUpdateState(): void {
    if (this.verifyInfo.isSupportUnlock) {
      if (!this.hasInit()) {
        this.init();
      }
      if (this._isAutoOpen) {
        this.isCanVerify() ? this.verify() : this.cancelVerify();
      }
    } else {
      this.release();
    }
  }

  /**
   * 验证密码接口
   *
   * @param pwd 密码
   * @param isAddPwd 是否追加密码
   * @returns true下发成功/false下发失败
   */
  public verify(_pwd?: string, isAddPwd: boolean = false): boolean {
    log.showInfo(`${this.authTypeStr} verify isAddPwd ${isAddPwd}.`);
    return !!this.authCurrentUser();
  }

  /**
   * 取消验证
   */
  public cancelVerify(isFinish: boolean = false): void {
    this.cancelAuth(this._handleResultToken, isFinish);
    if (this.isVerifying !== false) {
      log.showInfo(`cancelVerify ${this.authTypeStr} isVerifying false`);
    }
    this.isVerifying = false;
  }

  /**
   * 重置认证次数
   */
  public resetAuthRemainCount(): void {
  }

  private cancelAuth(handleToken?: string, isFinish: boolean = false): void {
    let deleteText = handleToken ?? this._handleResultToken;
    let verifyContextId: VerifyContextId | undefined = this._cancelContextIds.get(deleteText);
    if (deleteText && deleteText.length !== 0) {
      log.showInfo(`cancelVerify ${this.authTypeStr} ${deleteText}` + (verifyContextId ? ` skip` : ``));
    }
    if (!verifyContextId) {
      return;
    }
    if (isFinish || !verifyContextId.verifySuccess) {
      let isCancelCurrent = handleToken === this._handleResultToken;
      log.showInfo(`already success, cancel auth, isCancelCurrent: ${isCancelCurrent}`);
      AccountHelper.getInstance().cancelAuth(verifyContextId.contextId);
      this._cancelContextIds.delete(deleteText);
      if (isCancelCurrent) {
        this._handleResultToken = INVALID_HANDLE_TOKEN;
      }
    }
  }

  protected doInit(): void {
    log.showInfo(`doInit verifier authType ${this.authTypeStr}`);
  }

  protected doRelease(): void {
    log.showInfo(`doRelease verifier authType ${this.authTypeStr}`);
    this.cancelVerify();
  }

  /**
   * 获取验证信息
   *
   * @returns 验证信息
   */
  protected get verifyInfo(): VerifyInfo {
    return VerifyDataManager.getInstance().getVerifyInfo(this.authType);
  }

  /**
   * 更新验证状态
   *
   * @param isVerifying 是否验证中
   */
  protected set isVerifying(isVerifying: boolean) {
    if (this._isVerifying !== isVerifying) {
      this._isVerifying = isVerifying;
      this.broadcastStateChange(isVerifying);
    }
  }

  public isCanVerify(): boolean {
    if (!UserSwitchService.getInstance().isCurrentUserActive) {
      log.showInfo(`auth ${this.authTypeStr} encounter user inactive.`);
      return false;
    }
    if (this._isAutoOpen && !(this._isPageStateOpen && this._isOperateOpen)) {
      log.showInfo(`auth ${this.authTypeStr} pageState: ${this._isPageStateOpen}, Operate: ${this._isOperateOpen}`);
      return false;
    }

    let isCanVerify: boolean = this.verifyInfo.isSupportUnlock;
    if (!isCanVerify) {
      log.showInfo(`auth ${this.authTypeStr} encounter not support unlock.`);
    }
    return this.verifyInfo.isSupportUnlock;
  }

  /**
   * 验证当前用户
   *
   * @param verifyParam 验证参数
   * @returns 取消的上下文ID
   */
  protected authCurrentUser(): boolean {
    if (!this.isCanVerify()) {
      return false;
    }
    if (this._isAutoOpen && this.isVerifying) {
      log.showWarn(`${this.authTypeStr} verifying`);
      return false;
    }
    this._hasHandleResult = false;
    let handleToken: string = util.generateRandomUUID();
    log.showWarn(`auth start: ${this.authType}`);
    let cancelContextId: Uint8Array | undefined = AccountHelper.getInstance().authUser(this.authType, this._authLevel,
      this.getAuthOptions(), this.generateOnResultHandler(handleToken));
    this.isVerifying = !!cancelContextId;
    if (this.isVerifying && cancelContextId) {
      log.showInfo(`authUser ${this.authTypeStr} isVerifying ${this.isVerifying}.`);
      let verifyContextId: VerifyContextId = {
        contextId: cancelContextId,
        verifySuccess: false
      };
      this._cancelContextIds.set(handleToken, verifyContextId);
      this._handleResultToken = handleToken;
    } else {
      log.showError(`authUser ${this.authTypeStr} failed.`);
    }
    return this.isVerifying;
  }

  private generateOnResultHandler(handleNote: string): osAccount.IUserAuthCallback {
    return {
      onResult: (result: number, extraInfo: osAccount.AuthResult): void => {
        // Token发生变化，如果是解锁结果是成功或者是抢占导致，不需要处理
        log.showWarn(`onResult: ${result} of ${this.authTypeStr}`);
        if (this._handleResultToken !== handleNote &&
          (result === IAMResultCode.SUCCESS || this._handleResultToken !== INVALID_HANDLE_TOKEN)) {
          log.showInfo(`onResult: ${result} of ${this.authTypeStr} --> invalid handleToken ${handleNote}.`);
          this.cancelAuth(handleNote, false);
          return;
        }
        this.handleOnResult(result, extraInfo);
      },
      onAcquireInfo: (module: number, acquire: number, extraInfo: Uint8Array): void => {
        if (this._handleResultToken !== handleNote) {
          log.showInfo(`onAcquireInfo invalid handleToken ${handleNote}.`);
          return;
        }
        this.handleOnAcquireInfo(module, acquire, extraInfo);
      }
    };
  }

  private handleOnResult(result: number, extraInfo: osAccount.AuthResult): void {
    this.cancelVerify(true);
    if (this._hasHandleResult) {
      log.showWarn(`onResult: ${result} of ${this.authTypeStr} --> has handle result already.`);
      this.updateVerifyInfo(result);
      this.handleAuthSuccessAfterResult(result, extraInfo);
      return;
    }
    this.handleOnResultReal(result, extraInfo);
  }

  protected handleOnResultReal(result: number, extraInfo: osAccount.AuthResult): void {
    if (this._isAcquireSuccess && result !== IAMResultCode.SUCCESS) {
      log.showError(`${this.authTypeStr} acquire and result is different`);
      HiKGReportBase.reportFault(SLFaultTag.ACQUIRE_RESULT_DIFF, Object({
        TYPE: this.authType,
        CODE: result,
      }));
    }
    if (result === IAMResultCode.SUCCESS && this.isNeedSwitchUser(extraInfo?.accountId)) {
      Trace.end(Trace.CORE_METHOD_PSD_AUTH);
      log.showInfo(`onResult: ${result} of ${this.authTypeStr} --> needSwitchUser.`);
      this.switchUser(extraInfo?.accountId);
    } else {
      log.showInfo(`onResult: ${result} of ${this.authTypeStr} --> handleOnResult`);
      this.updateVerifyInfo(result, extraInfo);
      this.onResult(result, extraInfo);
      this.handleAuthSuccessAfterResult(result, extraInfo);
    }
  }

  // onVerifyResult之后处理，确保在锁头和锁屏状态后执行
  private handleAuthSuccessAfterResult(result: number, extraInfo: osAccount.AuthResult): void {
    if (result === IAMResultCode.SUCCESS && !this.isNeedSwitchUser(extraInfo?.accountId)) {
      this._listenerManager.broadcastAuthSuccessResult(this.authType);
    }
  }

  // public只可以被debugCommand使用，高危接口
  public handleOnAcquireInfo(moduleId: number, acquire: number, extraInfo: Uint8Array): void {
    if (this._hasHandleResult) {
      log.showWarn(`onAcquire: ${acquire} of ${this.authTypeStr} --> has handle result already.`);
      return;
    }
    this.handleOnAcquireInfoReal(moduleId, acquire, extraInfo);
  }

  protected handleOnAcquireInfoReal(moduleId: number, acquire: number, extraInfo: Uint8Array): void {
    log.showDebug(`onAcquire: ${acquire} of ${this.authTypeStr} --> moduleId is ${moduleId}`);
    let acquireExtraInfo: AcquireExtraInfo | undefined = this.parseAcquireExtraInfo(extraInfo);
    if (acquireExtraInfo?.authResult === 0 && this.isNeedSwitchUser(acquireExtraInfo?.userId)) {
      log.showInfo(`onAcquire: ${acquire} of ${this.authTypeStr} --> needSwitchUser.`);
      this.switchUser(acquireExtraInfo?.userId);
    } else {
      this._hasHandleAcquireInfo = false;
      this._isAcquireSuccess = false;
      this.onAcquireInfo(moduleId, acquire, acquireExtraInfo);
    }
  }

  /**
   * 标记此次提前认证成功
   */
  public onPreVerifySuccess(): void {
    let verifyContextId: VerifyContextId | undefined = this._cancelContextIds.get(this._handleResultToken);
    if (verifyContextId) {
      log.showInfo(`onPreVerifySuccess ${this.authTypeStr} acquire is success`);
      verifyContextId.verifySuccess = true;
    }
  }

  /**
   * 处理验证结果
   *
   * @param result 验证结果
   * @param extraInfo 验证额外信息
   */
  protected onResult(result: number, extraInfo: osAccount.AuthResult): void {
    // 记录验证上报
    SlUnlockReportHelper.getInstance().recordAuthEndTime(this.authType);
    if (result === IAMResultCode.SUCCESS) {
      FingerAuthReportHelper.getInstance().unlockReport(this.authType, true);
    }
    if (!this._hasHandleResult) {
      this.onInterceptorHandleResult(result, extraInfo);
    }
    // 条件可能改变，保证时序正确
    if (!this._hasHandleResult) {
      this.broadcastResult(result);
    }
  }

  /**
   * 处理验证中提示信息
   *
   * @param module
   * @param acquire
   * @param extraInfo
   */
  protected onAcquireInfo(module: number, acquire: number, extraInfo?: AcquireExtraInfo): void {
    this.onInterceptorHandleAcquireInfo(module, acquire, extraInfo);
    if (!this._hasHandleAcquireInfo) {
      this.broadcastAcquireInfo(module, acquire, extraInfo);
    }
  }

  /**
   * 更新验证信息
   *
   * @param result 验证结果
   * @param extraInfo 验证信息
   */
  protected updateVerifyInfo(result: number, extraInfo?: osAccount.AuthResult): void {
    VerifyDataManager.getInstance().updateVerifyInfo(this.authType, result, extraInfo);
  }

  protected getAuthOptions(): osAccount.AuthOptions {
    // 丢失模式、孩童模式、远程锁定模式、QXS PC模式不能进入隐私空间
    let isAuthCurrentOnly = (AppStorage.get<boolean>('childModule') ?? false) ||
    KeyguardStatusService.isOnlyCurrentUser() ||
    DeviceHelper.is2In1DevicePcType();
    let authIntent: number = isAuthCurrentOnly ? UNLOCK_ASSIGN_USER : osAccount.AuthIntent.UNLOCK;
    log.showInfo(`getAuthOptions authIntent: ${authIntent}.`);
    return {
      accountId: AccountHelper.getInstance().currentLocalId,
      authIntent: authIntent,
    };
  }

  private isNeedSwitchUser(user: number | undefined): boolean {
    if (!user) {
      log.showError(`invalid userId.`);
      return false;
    }
    let currentUser = AccountHelper.getInstance().currentLocalId;
    log.showWarn(`receive auth ${user} currentUser ${currentUser}`);
    return user !== currentUser;
  }

  private switchUser(user?: number): void {
    if (user === undefined) {
      log.showError('switchUser failed, user is undefined');
      return;
    }
    log.showInfo(`authUser ${this.authTypeStr} needSwitchUser. start to active other user ${user}`);

    // 处理用户切换事件
    AccountHelper.getInstance().activateOsAccount(user);
    // 上报其他用户验证成功
    this._hasHandleResult = true;
    this.onPreVerifySuccess();
    SlServerHelper.getInstance().setScreenLockAuthState(this.authType, user, true);
    this._listenerManager.broadcastResult(this.authType, VerifyResult.OTHER_SUCCESS);
  }

  private parseAcquireExtraInfo(originalExtraInfo: Uint8Array): AcquireExtraInfo | undefined {
    if (!originalExtraInfo || originalExtraInfo.length === 0) {
      log.showDebug('parseAcquireExtraInfo invalid param.');
      return undefined;
    }

    let extraInfo: AcquireExtraInfo | undefined = undefined;
    try {
      let originalExtraInfoStr: string = String.fromCharCode(...originalExtraInfo);
      if (CheckEmptyUtils.isEmpty(originalExtraInfoStr)) {
        log.showInfo('parseAcquireExtraInfo originalExtraInfo is empty.');
        return undefined;
      }
      extraInfo = JSON.parse(originalExtraInfoStr) as AcquireExtraInfo;
    } catch (error) {
      log.showError(`parseAcquireExtraInfo failed. code: ${error.code}`);
    }

    if (ObjUtil.isInvalid(extraInfo) || ObjUtil.isInvalid(extraInfo?.authResult)) {
      log.showDebug('parseAcquireExtraInfo not meet the requirements.');
      return undefined;
    }
    return extraInfo;
  }

  private onInterceptorHandleResult(result: number, extraInfo: osAccount.AuthResult): boolean {
    for (let interceptor of this._interceptors) {
      let current: VerifyInterceptor | undefined = interceptor;
      while (current) {
        current.endTrace();
        if (current.onVerifyResult(this, result, extraInfo)) {
          log.showInfo(`Interceptor ${this.authTypeStr} onVerifyResult stop. handled: ${this._hasHandleResult}`);
          return true;
        } else {
          log.showInfo(`Interceptor ${this.authTypeStr} onVerifyResult continue. handled: ${this._hasHandleResult}`);
        }
        current = current.next;
      }
    }
    return false;
  }

  private onInterceptorHandleAcquireInfo(module: number, acquire: number, extraInfo?: AcquireExtraInfo): boolean {
    for (let interceptor of this._interceptors) {
      let current: VerifyInterceptor | undefined = interceptor;
      while (current) {
        this._isAcquireSuccess = false;
        if (current.onAcquireInfo(this, module, acquire, extraInfo)) {
          log.showDebug(`${this.authTypeStr} onAcquireInfo stop. handled: ${this._hasHandleResult}`);
          return true;
        } else {
          log.showDebug(`${this.authTypeStr} onAcquireInfo continue. handled: ${this._hasHandleResult}`);
        }
        current = current.next;
      }
    }
    return false;
  }
}

/**
 * 密码验证器
 */
class PwdVerifier extends AbstractVerifier {
  private _pwd?: string;
  private _authSubType: number = 0;
  private _pinInputData?: osAccount.IInputData;
  protected _setTimeOutId: number = -1; // 监控认证耗时打点

  constructor(listenerManager: VerifyListenerManager) {
    super(AuthType.PIN, AuthTrustLevel.ATL3, false, listenerManager);
  }

  public isCanVerify(): boolean {
    if (!ScreenLockStateManager.getInstance().isLocked) {
      log.showInfo(`auth ${this.authTypeStr} encounter unlock scene.`);
      return false;
    }
    return super.isCanVerify();
  }

  public verify(pwd?: string, isAddPwd: boolean = false): boolean {
    if (isAddPwd && this._pinInputData) {
      log.showInfo('PwdVerifier addPwd.');
      return this.submitPwd(pwd, this._authSubType, this._pinInputData);
    }

    AccountHelper.getInstance().unregisterInputer();
    this._pwd = pwd;
    if (!AccountHelper.getInstance().registerInputer(this.onGetData.bind(this))) {
      log.showError('PwdVerifier registerInputer failed.');
      return false;
    }

    let isSuccess: boolean = !!super.verify();
    return isSuccess;
  }

  protected getAuthOptions(): osAccount.AuthOptions {
    // 主空间和隐私空间密码长度不一致时，不开启静默认证
    if (!VerifyDataManager.getInstance().isUnfixedPwdType) {
      return super.getAuthOptions();
    }
    // 丢失模式、孩童模式、QXS PC模式不能进入隐私空间
    let isAuthCurrentOnly = (AppStorage.get<boolean>('childModule') ?? false) ||
    KeyguardStatusService.isOnlyCurrentUser() || DeviceHelper.is2In1DevicePcType();
    let authIntent: number = isAuthCurrentOnly ? UNLOCK_SILENCE_ASSIGN_USER : UNLOCK_SILENCE;
    log.showInfo(`getAuthOptions authIntent: ${authIntent}.`);
    return {
      accountId: AccountHelper.getInstance().currentLocalId,
      authIntent: authIntent
    };
  }

  public cancelVerify(): void {
    super.cancelVerify();
    this._pinInputData = undefined;
    this._authSubType = 0;
    this._pwd = undefined;
    AccountHelper.getInstance().unregisterInputer();
  }

  public autoUpdateState(): void {
    if (this._isVerifying && !ScreenLockStateManager.getInstance().isLocked) {
      this.cancelVerify();
    }
  }

  protected handleOnAcquireInfoReal(moduleId: number, acquire: number, extraInfo: Uint8Array): void {
    HiKGReportTimeout.getInstance().rollbackTimeout(TIMEOUT_PARAMS.PSD_AUTH.NAME);
    super.handleOnAcquireInfoReal(moduleId, acquire, extraInfo);
  }

  protected handleOnResultReal(result: number, extraInfo: osAccount.AuthResult): void {
    HiKGReportTimeout.getInstance().rollbackTimeout(TIMEOUT_PARAMS.PSD_AUTH.NAME);
    super.handleOnResultReal(result, extraInfo);
  }

  private onGetData(passType: number, inputData: osAccount.IInputData): void {
    // 注意：多用户场景，此处会多次调用，因此需要保存密码
    if (this._pwd) {
      this.submitPwd(this._pwd, passType, inputData);
    } else {
      log.showInfo(`registerInputer tmp save passType: ${passType}`);
      this._pinInputData = inputData;
      this._authSubType = passType;
    }
  }

  /**
   * 主动提交密码
   */
  private submitPwd(pwd: string | undefined, authSubType: number, inputData: osAccount.IInputData): boolean {
    // 锁屏打点记录开始认证时间
    SlUnlockReportHelper.getInstance().recordAuthStartTime(AuthType.PIN);
    // 输入完离手打点
    HiDfxEventUtil.reportStartUnlockEvent();
    // 锁屏打点记录解锁认证时间
    SlUnlockReportHelper.getInstance().recordUnlockStartTime(AuthType.PIN);
    // 超时打点计时起点
    HiKGReportTimeout.getInstance().logTimeout(TIMEOUT_PARAMS.PSD_AUTH.NAME, TIMEOUT_PARAMS.PSD_AUTH.TIME_OUT);

    this._pwd = pwd;
    return AccountHelper.getInstance().submitInputData(new util.TextEncoder().encodeInto(pwd), authSubType, inputData);
  }
}

/**
 * 锁屏验证服务
 */
export class ScreenLockVerifyService extends VerifyListenerManager {
  private static sInstance: ScreenLockVerifyService;

  public static getInstance(): ScreenLockVerifyService {
    if (ScreenLockVerifyService.sInstance == null) {
      ScreenLockVerifyService.sInstance = new ScreenLockVerifyService();
    }
    return ScreenLockVerifyService.sInstance;
  }

  private readonly _verifiers: Map<AuthType, AbstractVerifier> = new Map();

  private readonly _verifyDataChangeListener: VerifyDataChangeListener = {
    onVerifyStateChange: (authType: AuthType, _verifyInfo: VerifyInfo): void => {
      log.showInfo(`receive VerifyState change authType ${authType}`);
      this._verifiers.get(authType)?.autoUpdateState();
      if (authType === AuthType.PIN && _verifyInfo.isStateLocked) {
        VerifyDataManager.getInstance().updateVerifyData();
      }
    }
  };

  private readonly _lockStateChangeListener: ScreenLockStateChangeListener = {
    onLockStateChange: (lockStateInfo: LockStateInfo): void => {
      log.showInfo(`lockStateInfo change. ${lockStateInfo.toString()}`);
      this._verifiers.forEach((verifier) => verifier.autoUpdateState());
      if (lockStateInfo.lockState === LockState.UNLOCKED) {
        this._verifiers.forEach((verifier) => verifier.resetAuthRemainCount());
      }
    }
  };

  private readonly _userActiveChangeListener: UserSwitchListener = {
    onSwitched: (switchEventData: SwitchEventData): void => {
      log.showInfo(`receive user switched. isCurrentUserActive: ${UserSwitchService.getInstance().isCurrentUserActive}`);
      this._verifiers.forEach((verifier) => verifier.autoUpdateState());
    }
  };

  private readonly _specialModelListener = (isSpecialModel?: CacheValue): void => {
    log.showWarn(`receive isSpecialModel is. ${isSpecialModel}`);
    this._verifiers.forEach((verifier) => verifier.autoUpdateState());
  };

  private readonly _coverModelListener = (isCoverModel?: CacheValue): void => {
    log.showInfo(`receive coverMode is. ${isCoverModel}`);
    this._verifiers.forEach((verifier) => verifier.autoUpdateState());
  };

  private constructor() {
    super();
    this._verifiers.set(AuthType.PIN, new PwdVerifier(this));
  }

  /**
   * 验证密码
   *
   * @param pwd 密码
   * @param isAddPwd 是否追加密码
   * @param listener 验证状态监听
   * @returns true下发成功/false下发失败
   */
  public verifyPwd(pwd?: string, isAddPwd: boolean = false, authType: AuthType = AuthType.PIN): boolean {
    return this._verifiers.get(authType)?.verify(pwd, isAddPwd) ?? false;
  }

  /**
   * 主动取消验证
   *
   * @param authType 验证类型
   */
  public cancelVerify(authType: AuthType = AuthType.PIN): void {
    return this._verifiers.get(authType)?.cancelVerify();
  }

  // 锁屏自动化测试 -> public只可以被debugCommand使用，高危接口
  public launchAcquire(onAcquireInfo: OnAcquireInfo): void {
    if (!onAcquireInfo) {
      log.showError('launchAcquire params is null');
      return;
    }
    this._verifiers.get(onAcquireInfo.authType)?.handleOnAcquireInfo(onAcquireInfo.moduleId,
      onAcquireInfo.acquire, onAcquireInfo.extraInfo);
    this._verifiers.get(onAcquireInfo.authType)?.cancelVerify(true);
  }

  /**
   * 判断指定验证类型是否正在验证中
   *
   * @param authType 验证类型
   * @returns 是否在验证中
   */
  public isVerifying(authType: AuthType): boolean {
    return this._verifiers.get(authType)?.isVerifying ?? false;
  }

  /**
   * 判断当前是否支持认证
   *
   * @param authType 验证类型
   * @returns 是否支持认证
   */
  public isCanVerify(authType: AuthType): boolean {
    return this._verifiers.get(authType)?.isCanVerify() ?? false;
  }

  /**
   * [根页接口]设置页面开启状态
   *
   * @param isOpen 是否打开
   * @param isAutoVerify isOpen为true时是否自动认证
   */
  public setPageOpenState(authType: AuthType, isOpen: boolean, isAutoVerify: boolean = true,
    reason: string = 'Unknown'): void {
    let verifier: AbstractVerifier | undefined = this._verifiers.get(authType);
    if (verifier) {
      log.showInfo(`setPageOpenState ${AuthType[authType]}, isoepn ${isOpen}, verify ${isAutoVerify}` +
        (reason === 'Unknown' ? `` : `, reason: ${reason}`));
      verifier.setIsPageStateOpen(isOpen, isAutoVerify);
    } else {
      log.showError(`setPageOpenState invalid authType ${authType}`);
    }
  }

  /**
   * [子页接口]设置交互开启状态
   *
   * @param isOpen 是否打开
   * @param isAutoVerify isOpen为true时是否自动认证
   */
  public setOperateOpenState(authType: AuthType, isOpen: boolean, isAutoVerify: boolean = true,
    reason: string = 'NoConfig'): void {
    let verifier: AbstractVerifier | undefined = this._verifiers.get(authType);
    if (verifier) {
      log.showInfo(`setOperateOpenState ${AuthType[authType]}, isoepn: ${isOpen}, verify: ${isAutoVerify}` +
        (reason === 'NoConfig' ? `` : `, reason: ${reason}`));
      verifier.setIsOperateOpen(isOpen, isAutoVerify);
    } else {
      log.showError(`setOperateOpenState invalid authType ${authType}`);
    }
  }

  /**
   * 注册验证拦截器
   *
   * @param interceptor 验证拦截器
   */
  public registerInterceptor(interceptor: VerifyInterceptor): void {
    this._verifiers.get(interceptor?.authType)?.registerInterceptor(interceptor);
  }

  /**
   * 注销验证拦截器
   *
   * @param interceptor 验证拦截器
   */
  public unRegisterInterceptor(interceptor: VerifyInterceptor): void {
    this._verifiers.get(interceptor?.authType)?.unRegisterInterceptor(interceptor);
  }

  protected doInit(): void {
    log.showInfo('doInit');
    StrongAuthStateManager.getInstance().updateStrongAuth();
    VerifyDataManager.getInstance().init();
    VerifyDataManager.getInstance().registerObserver(this._verifyDataChangeListener);
    ScreenLockStateManager.getInstance().registerObserver(this._lockStateChangeListener);
    UserSwitchService.getInstance().registerObserver(this._userActiveChangeListener);
    GlobalStatusCache.getInstance().subscribe(KeyGuardCacheKey.COVER_MODE, this._coverModelListener);
    GlobalStatusCache.getInstance().subscribe(KeyGuardCacheKey.SPECIAL_MODE, this._specialModelListener);
  }

  protected doRelease(): void {
    log.showInfo('doRelease');
    VerifyDataManager.getInstance().release();
    VerifyDataManager.getInstance().unRegisterObserver(this._verifyDataChangeListener);
    ScreenLockStateManager.getInstance().unRegisterObserver(this._lockStateChangeListener);
    UserSwitchService.getInstance().unRegisterObserver(this._userActiveChangeListener);
    GlobalStatusCache.getInstance().unsubscribe(KeyGuardCacheKey.COVER_MODE, this._coverModelListener);
    GlobalStatusCache.getInstance().unsubscribe(KeyGuardCacheKey.SPECIAL_MODE, this._specialModelListener);
  }
}