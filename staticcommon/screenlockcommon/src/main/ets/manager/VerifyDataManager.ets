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

import osAccount from '@ohos.account.osAccount';
import commonEventManager from '@ohos.commonEventManager';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DisplayMgr } from '@ohos/windowscene';
import screenSessionManager from '@ohos.screenSessionManager';
import { AbstractObserverManager, ObserverAble } from '../base/AbstractObserverManager';
import commonEventMonitor from '../base/CommonEventMonitor';
import { AccountHelper, AuthSubType, AuthType, PropertyType, SensorType } from '../utils/AccountHelper';
import { DomainName, SettingsHelper } from '../utils/SettingsHelper';
import { StrongAuthStateListener, StrongAuthStateManager, StrongAuthReasonFlags } from './StrongAuthStateManager';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { FingerprintType } from '../constants/FingerprintConstants';
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import { SLAutoTestService } from '../services/autoTest/SLAutoTestService';
import { DfxFaultEventTag, HiKGReportBase } from '../record/report/PerformanceMonitorUtil';

const TAG = 'VerifyDataManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const USER_CREDENTIAL_UPDATED_EVENT = 'USER_CREDENTIAL_UPDATED_EVENT';
const UPDATE_VERIFY_INFO_TIMEOUT = 500;
const MAX_NR_RETRIES = 10;
const MAX_WAITING = 2000;
const LOW_FINGERPRINT: number = vp2px(96);
const KEY_FACE_KEYGUARD_ENABLE = 'face_bind_with_lock';
const FACE_RECOGNIZE_SLIDE_UNLOCK = 'face_recognize_slide_unlock';
const KEY_FINGERPRINT_KEYGUARD_ENABLE = 'fp_keyguard_enable';
const DEFAULT_VALUE: string = '-1';
const FACE_UNLOCK_ENABLE: string = '1';
const FACE_DIRECT_UNLOCK_ENABLE: string = '0';
const FINGERPRINT_UNLOCK_ENABLE: string = '1';
const SILENT_CRED_CHANGE: string = '1';
const PIN_TYPE_SIX_PASSWORD_LENGTH: number = 6;
const PIN_TYPE_FOUR_PASSWORD_LENGTH: number = 4;

/**
 * 凭据状态
 */
export enum HasCredential {
  /**
   * 未知状态
   */
  UNKNOWN = 0,

  /**
   * 有凭据
   */
  HAS_CREDENTIAL = 1,

  /**
   * 无凭据
   */
  NO_CREDENTIAL = 2,
}

/**
 * 验证状态
 */
export enum VerifyState {
  /**
   * 正常状态
   */
  NORMAL = 0,

  /**
   * 锁定态
   */
  LOCKED = 1,

  /**
   * 过期
   */
  EXPIRED = 2,
}

/**
 * 屏下指纹类型
 */
export enum UnderScreenType {
  /**
   * 无
   */
  NONE,

  /**
   * 低指纹
   */
  LOW,

  /**
   * 高指纹
   */
  HIGH,
}

/**
 * 强制认证原因
 */
export enum StrongAuthReason {
  /**
   * 无须强制认证
   */
  NONE = 0x0,

  /**
   * 重启
   */
  AFTER_BOOT = 0x1,

  /**
   * 超时（目前是3天）
   */
  AFTER_TIMEOUT = 0x2,

  /**
   * 请求强制认证
   */
  ACTIVE_REQUEST = 0x4,

  /**
   * 策略限制
   */
  POLICY_RESTRICT = 0x8,
}

/**
 * 强制认证原因工具类
 */
export class StrongAuthReasonUtils {
  private constructor() {
  }

  /**
   * 是否包含强制认证标志
   *
   * @param strongAuthReason 强制认证原因
   * @param reasonFlag 认证标志
   * @returns 是否包含
   */
  public static hasReasonFlag(strongAuthReason: number, reasonFlag: StrongAuthReason): boolean {
    return (strongAuthReason & reasonFlag) === reasonFlag;
  }
}

export class SensorInfoDataJson {
  public sensorType: SensorType = SensorType.NON_SENSOR;
  public udSensorCenterXInThousandth: number = 0;
  public udSensorCenterYInThousandth: number = 0;
  public udSensorRadiusInPx: number = 0;
}

/**
 * 指纹传感器信息
 */
export class FingerprintData {
  /**
   * 传感器类型
   */
  public readonly sensorType: string;

  /**
   * 传感器中心点X轴坐标，单位px
   */
  public readonly centerX: number;

  /**
   * 传感器中心点Y轴坐标，单位px
   */
  public readonly centerY: number;

  /**
   * 传感器圆角率，也即半径，单位px
   */
  public readonly radius: number;

  /**
   * 顶点X轴坐标，单位px
   */
  public readonly coordinateX: number;

  /**
   * 顶点Y轴坐标，单位px
   */
  public readonly coordinateY: number;

  /**
   * 屏下指纹类型
   */
  public readonly underScreenType: UnderScreenType;

  constructor(sensorType: string, centerX?: number, centerY?: number, radius?: number, displayHeight?: number) {
    this.sensorType = sensorType;
    this.centerX = centerX ?? 0;
    this.centerY = centerY ?? 0;
    this.radius = radius ?? 0;
    this.coordinateX = this.centerX - this.radius;
    this.coordinateY = this.centerY - this.radius;
    this.underScreenType = this.computeType(displayHeight ?? 0);
  }

  /**
   * 是否存在屏下指纹
   *
   * @returns true存在/false不存在
   */
  public isUnderFingerprint(): boolean {
    return this.sensorType === SensorType.UNDER_SCREEN_SENSOR || this.sensorType === SensorType.BOTH_SENSOR;
  }

  /**
   * 是否存在高指纹
   *
   * @returns true存在/false不存在
   */
  public isHighFingerprint(): boolean {
    return this.underScreenType === UnderScreenType.HIGH;
  }

  /**
   * 是否存在低指纹
   *
   * @returns true存在/false不存在
   */
  public isLowFingerprint(): boolean {
    return this.underScreenType === UnderScreenType.LOW;
  }

  /**
   * 是否存在屏外指纹
   *
   * @returns true存在/false不存在
   */
  public isOuterFingerprint(): boolean {
    return this.sensorType === SensorType.OUT_OF_SCREEN_SENSOR;
  }

  private computeType(displayHeight: number): UnderScreenType {
    switch (this.sensorType) {
      case SensorType.UNDER_SCREEN_SENSOR:
      case SensorType.BOTH_SENSOR:
        if (displayHeight <= 0 || this.coordinateY <= 0 || this.radius <= 0) {
          return UnderScreenType.NONE;
        }
        if (displayHeight - this.coordinateY - this.radius < LOW_FINGERPRINT) {
          return UnderScreenType.LOW;
        } else {
          return UnderScreenType.HIGH;
        }
      default:
        return UnderScreenType.NONE;
    }
  }
}

type SensorInfo = FingerprintData;

/**
 * 验证信息
 */
export class VerifyInfo {
  /**
   * 验证类型
   */
  public readonly authType: AuthType;

  /**
   * 验证子类型
   */
  protected _authSubType: AuthSubType = AuthSubType.PIN_SIX;

  /**
   * 认证方式是否支持（从系统账号系统读取）
   */
  protected _hasCredential: HasCredential = HasCredential.UNKNOWN;

  /**
   * 开关是否已打开（从设置数据库读取）
   */
  protected _isSwitchOpen: boolean = false;

  /**
   * 是否彻底禁用认证
   */
  protected _isVerifyDisable: boolean = false;

  /**
   * 强制认证原因
   */
  protected _strongAuthReason: number = StrongAuthReason.NONE;

  /**
   * 验证状态
   */
  protected _verifyState: VerifyState = VerifyState.NORMAL;

  /**
   * 验证结果
   */
  protected _verifyResult: number = 0;

  /**
   * 剩余次数（解锁后重置）
   */
  protected _remainTimes: number = 0;

  /**
   * 冻结时间
   */
  protected _freezingTime: number = 0;

  /**
   * 下次冻结时间
   */
  protected _nextPhaseFreezingTime: number = 0;

  /**
   * 密码长度
   */
  protected _credentialLength: number = 0;

  /**
   * 其他用户的密码类型，用于非定长密码的联动认证
   */
  protected _otherUserAuthSubType: AuthSubType = AuthSubType.PIN_SIX;

  /**
   * 其他用户的密码长度，用于非定长密码的联动认证
   */
  protected _otherUserCredLength: number = 0;

  /**
   * 是否已同步传感器信息
   */
  protected _hasSyncSensorInfo: boolean = true;

  /**
   * 传感器信息（当前只有指纹需要）
   */
  protected _sensorInfo?: SensorInfo;

  /**
   * 是否直接解锁
   */
  protected _isDirectUnlock: boolean = true;

  /**
   * 是否直接解锁一次（临时授权）
   */
  protected _isDirectUnlockOnce: boolean = false;

  /**
   * 认证有效期
   */
  protected _pinValidityPeriod?: number;

  protected _oldPinValidatePeriod: number = -1;

  constructor(authType: AuthType) {
    this.authType = authType;
    switch (authType) {
      case AuthType.PIN:
        this._authSubType = AuthSubType.PIN_SIX;
        this._isSwitchOpen = true;
        break;
      case AuthType.FACE:
        this._isDirectUnlock = false;
        break;
      case AuthType.FINGERPRINT:
        this._hasSyncSensorInfo = false;
      default:
        break;
    }
  }

  public get oldPinValidatePeriod(): number {
    return this._oldPinValidatePeriod;
  }

  public get isSupportUnlock(): boolean {
    return this._hasCredential !== HasCredential.NO_CREDENTIAL && this._isSwitchOpen && !this._isVerifyDisable;
  }

  public get strongAuthReason(): number {
    return this._strongAuthReason;
  }

  public get isNeedStrongAuth(): boolean {
    return this._strongAuthReason !== StrongAuthReason.NONE && this.authType !== AuthType.PIN;
  }

  public get authSubType(): number {
    return this._authSubType;
  }

  public get verifyState(): VerifyState {
    return this._verifyState;
  }

  public get verifyResult(): number {
    return this._verifyResult;
  }

  public get isStateLocked(): boolean {
    return this._verifyState === VerifyState.LOCKED;
  }

  public get remainTimes(): number {
    return this._remainTimes;
  }

  public get freezingTime(): number {
    return this._freezingTime;
  }

  public get nextPhaseFreezingTime(): number {
    return this._nextPhaseFreezingTime;
  }

  public get credentialLength(): number {
    return this._credentialLength;
  }

  public get otherUserCredLength(): number {
    return this._otherUserCredLength;
  }

  public get otherUserAuthSubType(): number {
    return this._otherUserAuthSubType;
  }

  public get hasSyncSensorInfo(): boolean {
    return this._hasSyncSensorInfo;
  }

  public get sensorInfo(): SensorInfo | undefined {
    return this._sensorInfo;
  }

  public get hasUnderFingerprint(): boolean {
    return this._sensorInfo?.isUnderFingerprint() ?? false;
  }

  public get hasOuterFingerprint(): boolean {
    return this._sensorInfo?.sensorType === SensorType.OUT_OF_SCREEN_SENSOR;
  }

  public get hasLowFingerprint(): boolean {
    return this._sensorInfo?.isLowFingerprint() ?? false;
  }

  public get hasHighFingerprint(): boolean {
    return this._sensorInfo?.isHighFingerprint() ?? false;
  }

  public get isDirectUnlock(): boolean {
    return this._isDirectUnlock;
  }

  public get isDirectUnlockOnce(): boolean {
    return this._isDirectUnlockOnce;
  }

  public set isDirectUnlockOnce(isDirectUnlockOnce: boolean) {
    this._isDirectUnlockOnce = isDirectUnlockOnce;
  }

  public get pinValidityPeriod(): number | undefined {
    return this._pinValidityPeriod;
  }

  public get isVerifyDisable(): boolean {
    return this._isVerifyDisable;
  }
}

/**
 * 内部使用的验证信息
 */
class InnerVerifyInfo extends VerifyInfo {
  private _broadcastTimeoutId: number = 0;

  private _refreshTimeoutId: number = 0;

  /**
   * 当isSupport开关或VerifyState变化时，需要通知到外部，此字段在通知发送后设置为false
   */
  private _isStateChanged: boolean = false;

  /**
   * 配置变更时回调
   */
  private _changedCallback?: () => void;

  public get isSupportUnlock(): boolean {
    return super.isSupportUnlock;
  }

  public get hasCredential(): boolean {
    return this._hasCredential !== HasCredential.NO_CREDENTIAL;
  }

  public set hasCredential(hasCredential: boolean) {
    let isSupportUnlock: boolean = super.isSupportUnlock;
    this._hasCredential = hasCredential ? HasCredential.HAS_CREDENTIAL : HasCredential.NO_CREDENTIAL;
    if (super.isSupportUnlock !== isSupportUnlock) {
      this._isStateChanged = true;
    }
  }

  public get isSwitchOpen(): boolean {
    return this._isSwitchOpen;
  }

  public set isSwitchOpen(isSwitchOpen: boolean) {
    let isSupportUnlock: boolean = super.isSupportUnlock;
    this._isSwitchOpen = isSwitchOpen;
    if (super.isSupportUnlock !== isSupportUnlock) {
      this._isStateChanged = true;
    }
  }

  public set setVerifyDisable(isVerifyDisable: boolean) {
    let isSupportUnlock: boolean = super.isSupportUnlock;
    this._isVerifyDisable = isVerifyDisable;
    if (super.isSupportUnlock !== isSupportUnlock) {
      this._isStateChanged = true;
    }
  }

  public get strongAuthReason(): number {
    return this._strongAuthReason;
  }

  public set strongAuthReason(strongAuthReason: number) {
    if (this.authType === AuthType.PIN) {
      // PIN场景无须设置
      return;
    }
    if (this._strongAuthReason !== strongAuthReason) {
      if (this._strongAuthReason === StrongAuthReason.NONE || strongAuthReason === StrongAuthReason.NONE) {
        this._isStateChanged = true;
      }
      this._strongAuthReason = strongAuthReason;
    }
  }

  public get authSubType(): number {
    return this._authSubType;
  }

  public set authSubType(authSubType: number) {
    this._authSubType = authSubType;
  }

  public get verifyState(): VerifyState {
    return this._verifyState;
  }

  public set verifyState(verifyState: VerifyState) {
    this._verifyState = verifyState;
  }

  public get verifyResult(): number {
    return this._verifyResult;
  }

  public set verifyResult(verifyResult: number) {
    this._verifyResult = verifyResult;
  }

  public get remainTimes(): number {
    return this._remainTimes;
  }

  public set remainTimes(remainTimes: number) {
    this._remainTimes = remainTimes;
  }

  public get freezingTime(): number {
    return this._freezingTime;
  }

  public set freezingTime(freezingTime: number) {
    this._freezingTime = freezingTime;
  }

  public get nextPhaseFreezingTime(): number {
    return this._nextPhaseFreezingTime;
  }

  public set nextPhaseFreezingTime(nextPhaseFreezingTime: number) {
    this._nextPhaseFreezingTime = nextPhaseFreezingTime;
  }

  public get credentialLength(): number {
    return this._credentialLength;
  }

  public set credentialLength(credentialLength: number) {
    this._credentialLength = credentialLength;
  }

  public get otherUserCredLength(): number {
    return this._otherUserCredLength;
  }

  public set otherUserCredLength(otherUserCredLength: number) {
    this._otherUserCredLength = otherUserCredLength;
  }

  public get otherUserAuthSubType(): number {
    return this._otherUserAuthSubType;
  }

  public set otherUserAuthSubType(otherUserAuthSubType: number) {
    this._otherUserAuthSubType = otherUserAuthSubType;
  }

  public get hasSyncSensorInfo(): boolean {
    return this._hasSyncSensorInfo;
  }

  public set hasSyncSensorInfo(hasSyncSensorInfo: boolean) {
    this._hasSyncSensorInfo = hasSyncSensorInfo;
  }

  public get sensorInfo(): SensorInfo | undefined {
    return this._sensorInfo;
  }

  public set sensorInfo(sensorInfo: SensorInfo | undefined) {
    this._sensorInfo = sensorInfo;
  }

  public set isDirectUnlock(isDirectUnlock: boolean) {
    this._isDirectUnlock = isDirectUnlock;
  }

  public get isDirectUnlock(): boolean {
    return this._isDirectUnlock;
  }

  public get pinValidityPeriod(): number | undefined {
    return this._pinValidityPeriod;
  }

  public set pinValidityPeriod(pinValidityPeriod: number | undefined) {
    this._pinValidityPeriod = pinValidityPeriod;
  }

  public get oldPinValidatePeriod(): number {
    return this._oldPinValidatePeriod;
  }

  public set oldPinValidatePeriod(odPinValidityPeriod: number) {
    this._oldPinValidatePeriod = odPinValidityPeriod;
  }

  public get broadcastTimeoutId(): number {
    return this._broadcastTimeoutId;
  }

  public set broadcastTimeoutId(broadcastTimeoutId: number) {
    this._broadcastTimeoutId = broadcastTimeoutId;
  }

  public get refreshTimeoutId(): number {
    return this._refreshTimeoutId;
  }

  public set refreshTimeoutId(refreshTimeoutId: number) {
    this._refreshTimeoutId = refreshTimeoutId;
  }

  public get isStateChanged(): boolean {
    return this._isStateChanged;
  }

  public set isStateChanged(isStateChanged: boolean) {
    this._isStateChanged = isStateChanged;
  }

  public get changedCallback(): (() => void) | undefined {
    return this._changedCallback;
  }

  public set changedCallback(changedCallback: (() => void) | undefined) {
    this._changedCallback = changedCallback;
  }

  public reset(): void {
    this.authSubType = 0;
    this.verifyResult = 0;
    this.remainTimes = 0;
    this.freezingTime = 0;
    this.nextPhaseFreezingTime = 0;
  }

  public toString(): string {
    let authSubType = '';
    let freezingTime = '';
    let isDirectUnlock = '';
    if (this.authType === AuthType.PIN) {
      authSubType = `, subType: ${AuthSubType[this._authSubType]}`
    }
    if (this.authType === AuthType.FACE) {
      isDirectUnlock = `, faceDirect: ${this._isDirectUnlock}`
    }
    if (this._verifyState === VerifyState.LOCKED || this._freezingTime > 0) {
      freezingTime = `, freezing: ${this._freezingTime}`
    }

    return `<type: ${AuthType[this.authType]}${authSubType}, credential: ${this._hasCredential}` +
    `, switch: ${this._isSwitchOpen}, lockState: ${VerifyState[this._verifyState]}${freezingTime}${isDirectUnlock}>`;
  }
}

/**
 * 验证数据变化监听器
 */
export interface VerifyDataChangeListener extends ObserverAble {
  /**
   * 验证数据更新通知
   *
   * @param authType 验证类型
   * @param verifyInfo 验证信息
   */
  onVerifyInfoChange?: (authType: AuthType, verifyInfo: VerifyInfo) => void;

  /**
   * 验证状态变更通知
   *
   * @param authType 验证类型
   * @param verifyInfo 验证信息
   */
  onVerifyStateChange?: (authType: AuthType, verifyInfo: VerifyInfo) => void;
}

/**
 * 验证状态管理器
 */
export class VerifyDataManager extends AbstractObserverManager<VerifyDataChangeListener> {
  private static sInstance: VerifyDataManager;

  public static getInstance(): VerifyDataManager {
    if (VerifyDataManager.sInstance == null) {
      VerifyDataManager.sInstance = new VerifyDataManager();
    }
    return VerifyDataManager.sInstance;
  }

  private readonly _verifyInfos: Map<AuthType, InnerVerifyInfo> = new Map();
  private readonly _settingHelper: SettingsHelper = new SettingsHelper(DomainName.USER_SECURITY);

  private readonly _strongAuthStateListener: StrongAuthStateListener = {
    onStrongAuthStateChange: (strongAuthStatus: StrongAuthReasonFlags): void => {
      this.updateStrongAuth(strongAuthStatus);
    }
  };

  /**
   * 获取认证信息异常次数
   */
  private _verifyDataErrCount: number = 0;

  private constructor() {
    super();
    this._verifyInfos.set(AuthType.PIN, new InnerVerifyInfo(AuthType.PIN));
    this._verifyInfos.set(AuthType.FACE, new InnerVerifyInfo(AuthType.FACE));
    this._verifyInfos.set(AuthType.FINGERPRINT, new InnerVerifyInfo(AuthType.FINGERPRINT));
  }

  /**
   * 查询用户是否未设置密码
   *
   * @returns true未设置/false已设置
   */
  public get hasNoPwd(): boolean {
    return this._verifyDataErrCount === 0 && !this.getVerifyInfo(AuthType.PIN)?.isSupportUnlock;
  }

  /**
   * 查询用户设置的密码类型
   *
   * @returns 用户设置的密码类型
   */
  public get pwdType(): number {
    return this.getVerifyInfo(AuthType.PIN).authSubType;
  }

  /**
   * 查询面部直接解锁
   *
   * @returns true直接解锁/false滑动解锁
   */
  public get faceDirectUnlock(): boolean {
    return this.getVerifyInfo(AuthType.FACE).isDirectUnlock;
  }

  /**
   * 查询是否非定长密码类型（自定义数字密码、混合密码）
   *
   * @returns true: 非定长
   */
  public get isUnfixedPwdType(): boolean {
    return this.pwdType === AuthSubType.PIN_NUMBER || this.pwdType === AuthSubType.PIN_MIXED;
  }

  /**
   * 通过验证类型获取验证信息
   *
   * @param authType 验证类型
   * @returns 验证信息
   */
  public getVerifyInfo(authType: AuthType): VerifyInfo {
    let verifyInfo: InnerVerifyInfo | undefined = this._verifyInfos.get(authType);
    if (verifyInfo) {
      return verifyInfo;
    }
    verifyInfo = new InnerVerifyInfo(authType);
    this._verifyInfos.set(authType, verifyInfo);
    return verifyInfo;
  }

  /**
   * 底层安工恢复后刷新
   */
  public userIamReadyUpdateVerifyInfo(): void {
    if (this._verifyDataErrCount > 0) {
      log.showWarn('userIam is Ready, UpdateVerifyInfo');
      this.updateVerifyDataInner();
    }
  }

  /**
   * 更新验证信息
   *
   * @param authType 验证类型
   * @param extraInfo 验证信息
   */
  public updateVerifyInfo(authType: AuthType, result: number, extraInfo?: osAccount.AuthResult): void {
    let verifyInfo: InnerVerifyInfo | undefined = this._verifyInfos.get(authType);
    if (!verifyInfo) {
      log.showError(`updateVerifyInfo encounter invalid authType ${authType}`);
      return;
    }

    verifyInfo.verifyResult = result;
    if (extraInfo) {
      verifyInfo.remainTimes = extraInfo?.remainTimes ?? verifyInfo.remainTimes;
      verifyInfo.freezingTime = extraInfo?.freezingTime ?? verifyInfo.freezingTime;
      verifyInfo.nextPhaseFreezingTime = extraInfo?.nextPhaseFreezingTime ?? verifyInfo.nextPhaseFreezingTime;
      verifyInfo.pinValidityPeriod = extraInfo?.pinValidityPeriod ?? verifyInfo.pinValidityPeriod;
      this.updateLockState(verifyInfo);
      this.broadcastVerifyInfo(verifyInfo);
    } else {
      if (result === 0) {
        verifyInfo.remainTimes = 0;
        verifyInfo.freezingTime = 0;
        verifyInfo.nextPhaseFreezingTime = 0;
        verifyInfo.pinValidityPeriod = 0;
        this.updateLockState(verifyInfo);
      }
      this.updateInnerVerifyInfo(verifyInfo);
    }
  }

  /**
   * 刷新验证数据信息
   */
  public updateVerifyData(fakeData?: Array<osAccount.EnrolledCredInfo>): void {
    log.showInfo('updateVerifyData');
    // 锁屏自动化测试 -> fakeData来自于测试注入数据
    this.updateVerifyDataInner(fakeData);
  }

  /**
   * 刷新其他用户的密码信息
   */
  public updateOtherUserProperty(): void {
    log.showInfo('updateOtherUserProperty');
    AccountHelper.getInstance().getOtherUserId((otherAccountId: number) => {
      log.showInfo(`updateOtherUserProperty, otherUserId: ${otherAccountId}`);
      let verifyInfo: InnerVerifyInfo | undefined = this._verifyInfos.get(AuthType.PIN);
      // 删除隐私空间用户时，清空缓存的其他用户的数据
      if (otherAccountId < 0 && verifyInfo && verifyInfo.otherUserCredLength > 0) {
        verifyInfo.otherUserAuthSubType = AuthSubType.PIN_SIX;
        verifyInfo.otherUserCredLength = 0;
        return;
      }
      AccountHelper.getInstance().getOtherUserProperty(otherAccountId, (data): void => {
        let verifyInfo: InnerVerifyInfo | undefined = this._verifyInfos.get(AuthType.PIN);
        if (!verifyInfo) {
          log.showError('getOtherUserProperty failed, verifyInfo is undefined');
          return;
        }
        verifyInfo.otherUserAuthSubType = data?.authSubType ?? verifyInfo.authSubType;
        verifyInfo.otherUserCredLength = data?.credentialLength ?? verifyInfo.credentialLength;
        this.broadcastVerifyInfo(verifyInfo);
        log.showInfo(`updateOtherUserProperty, otherUserAuthSubType: ${verifyInfo.otherUserAuthSubType}`);
      });
    });
  }

  /**
   * 更新是否禁用认证
   *
   * @param authType 验证类型
   * @param isVerifyDisable 禁用结果
   */
  public updateVerifyDisable(authType: AuthType, isVerifyDisable: boolean): void {
    let verifyInfo: InnerVerifyInfo | undefined = this._verifyInfos.get(authType);
    if (!verifyInfo || verifyInfo.isVerifyDisable === isVerifyDisable) {
      return;
    }
    log.showInfo(`updateVerifyDisable isVerifyDisable: ${isVerifyDisable}`);
    verifyInfo.setVerifyDisable = isVerifyDisable;
    this.broadcastVerifyInfo(verifyInfo);
  }

  protected doInit(): void {
    log.showInfo('doInit');
    this.updateVerifyDataInner();
    this.registerDataChangeListener();
    StrongAuthStateManager.getInstance().registerObserver(this._strongAuthStateListener);
  }

  protected doRelease(): void {
    log.showInfo('doRelease');
    this._settingHelper.release();
    this.unRegisterDataChangeListener();
    StrongAuthStateManager.getInstance().unRegisterObserver(this._strongAuthStateListener);
  }

  private updateLockState(verifyInfo: InnerVerifyInfo): void {
    if (verifyInfo.refreshTimeoutId > 0) {
      clearTimeout(verifyInfo.refreshTimeoutId);
      verifyInfo.refreshTimeoutId = 0;
    }
    let newVerifyState: VerifyState;
    if (verifyInfo.remainTimes <= 0 && verifyInfo.freezingTime > 0) {
      newVerifyState = VerifyState.LOCKED;
      verifyInfo.refreshTimeoutId = setTimeout(() => {
        verifyInfo.refreshTimeoutId = 0;
        this.updateInnerVerifyInfo(verifyInfo);
      }, verifyInfo.freezingTime);
    } else {
      newVerifyState = VerifyState.NORMAL;
    }
    if (verifyInfo.verifyState !== newVerifyState) {
      verifyInfo.verifyState = newVerifyState;
      verifyInfo.isStateChanged = true;
    }
  }

  private updateVerifyDataInner(fakeData?: Array<osAccount.EnrolledCredInfo>): void {
    log.showInfo('updateVerifyDataInner.');
    AccountHelper.getInstance().getAllAuthInfo((data: Array<osAccount.EnrolledCredInfo>) => {
      this._verifyDataErrCount = 0;
      // 锁屏自动化测试 -> 当服务存活，生物解锁开关打开，且没有测试注入数据，则此时来源于锁屏默认规格刷新，此时不更新
      if (SLAutoTestService.getInstance().isAlive && SLAutoTestService.getInstance().isSwitchAbilityOpen && !fakeData) {
        log.showInfo('SLAutoTestService isSwitchAbilityOpen, do not update real authInfo');
        return;
      }
      this.updateOldPinValidity(data);
      let strongAuth: number = StrongAuthStateManager.getInstance().getStrongAuthStatus();
      log.showInfo(`updateVerifyDataInner: data size: ${data.length}, strongAuth: ${strongAuth}`);
      // 锁屏自动化测试 -> 当服务存活，生物解锁开关打开，且有测试注入数据，则使用注入数据更新，不用底层数据
      let handledAuthTypes: Set<AuthType> = this.handlerQueryAuthResult(
        (SLAutoTestService.getInstance().isAlive && SLAutoTestService.getInstance().isSwitchAbilityOpen && !!fakeData) ?
          fakeData : data, strongAuth);
      this._verifyInfos.forEach((verifyInfo, authType) => {
        if (!handledAuthTypes.has(authType)) {
          verifyInfo.hasCredential = false;
          verifyInfo.isSwitchOpen = false;
          verifyInfo.strongAuthReason = strongAuth;
          this.updateInnerVerifyInfo(verifyInfo);
        }
      });
    }, () => {
      log.showInfo('updateVerifyDataInner error.');
      this._verifyDataErrCount++;
      if (this._verifyDataErrCount === 1) {
        HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
          Object({ INTERFACE_NAME: 'updateVerifyData', ERROR_CODE: 1 }));
      }
      if (this._verifyDataErrCount >= MAX_NR_RETRIES) {
        if (this._verifyDataErrCount === MAX_NR_RETRIES) {
          HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
            Object({ INTERFACE_NAME: 'updateVerifyData', ERROR_CODE: 10 }));
        }
        return;
      }
      setTimeout(() => {
        this.updateVerifyDataInner();
      }, MAX_WAITING);
    });
  }

  private updateOldPinValidity(data: osAccount.EnrolledCredInfo[]): void {
    let verifyInfo: InnerVerifyInfo | undefined = this._verifyInfos.get(AuthType.PIN);
    if (!verifyInfo) {
      log.showError('updateOldPinValidity failed, verifyInfo is undefined');
      return;
    }
    verifyInfo.oldPinValidatePeriod = data.filter(osInfo => osInfo.isAbandoned)
      .map(osInfo => osInfo.validityPeriod)
      .shift() ?? -1;
  }

  public updateOldPassWordValidatePeriod(): void {
    log.showInfo('updateOldPassWordValidatePeriod');
    AccountHelper.getInstance().getAllAuthInfo((data: Array<osAccount.EnrolledCredInfo>) => {
      this.updateOldPinValidity(data);
      let verifyInfo: InnerVerifyInfo | undefined = this._verifyInfos.get(AuthType.PIN);
      log.showInfo(`updateOldPassWordValidatePeriod ${verifyInfo?.oldPinValidatePeriod}`);
    });
  }

  private handlerQueryAuthResult(data: Array<osAccount.EnrolledCredInfo>, strongAuth: number): Set<AuthType> {
    let handledAuthTypes: Set<AuthType> = new Set();
    for (let enrolledCredInfo of data) {
      let authType = (enrolledCredInfo?.authType ?? 0) as number;
      let verifyInfo: InnerVerifyInfo | undefined = this._verifyInfos.get(authType);
      if (!verifyInfo || handledAuthTypes.has(authType)) {
        log.showWarn(`authType ${authType} not has initial verifyInfo, or has handled already.`);
        continue;
      }
      let hasCredential = !!enrolledCredInfo?.credentialId;
      if (hasCredential) {
        verifyInfo.hasCredential = hasCredential;
        verifyInfo.isSwitchOpen = this.getSwitchStatus(authType, verifyInfo.hasCredential);
        verifyInfo.strongAuthReason = strongAuth;
        this.updateInnerVerifyInfo(verifyInfo);
        handledAuthTypes.add(authType);
      }
    }
    return handledAuthTypes;
  }

  private updateInnerVerifyInfo(verifyInfo: InnerVerifyInfo): void {
    log.showInfo(`updateInnerVerifyInfo authType ${verifyInfo.authType} newSupport ${verifyInfo.isSupportUnlock}`);
    let isNeedDelayBroadcast: boolean = false;
    if (verifyInfo.isSupportUnlock) {
      this.fillVerifyInfoFromProperty(verifyInfo,
        verifyInfo.hasSyncSensorInfo ? PropertyType.VERIFY_INFO : PropertyType.VERIFY_INFO | PropertyType.SENSOR_INFO);
      isNeedDelayBroadcast = true;
    } else {
      verifyInfo.reset();
      if (!verifyInfo.hasSyncSensorInfo) {
        // 提前获取传感器信息
        this.fillVerifyInfoFromProperty(verifyInfo, PropertyType.SENSOR_INFO);
        isNeedDelayBroadcast = true;
      } else {
        this.updateLockState(verifyInfo);
        this.broadcastVerifyInfo(verifyInfo);
      }
    }
    if (isNeedDelayBroadcast) {
      verifyInfo.broadcastTimeoutId = setTimeout(() => {
        verifyInfo.broadcastTimeoutId = 0;
        this.broadcastVerifyInfo(verifyInfo);
      }, UPDATE_VERIFY_INFO_TIMEOUT);
    }
  }

  private fillVerifyInfoFromProperty(verifyInfo: InnerVerifyInfo, propertyType: number): void {
    AccountHelper.getInstance().getProperty(verifyInfo.authType, (data): void => {
      verifyInfo.authSubType = data?.authSubType ?? verifyInfo.authSubType;
      verifyInfo.remainTimes = data?.remainTimes ?? verifyInfo.remainTimes;
      verifyInfo.freezingTime = data?.freezingTime ?? verifyInfo.freezingTime;
      verifyInfo.nextPhaseFreezingTime = data?.nextPhaseFreezingTime ?? verifyInfo.nextPhaseFreezingTime;
      verifyInfo.credentialLength = data?.credentialLength ?? verifyInfo.credentialLength;
      this.updateLockState(verifyInfo);

      if (verifyInfo.authType === AuthType.PIN) {
        // 异常保护，避免获取到密码长度不正确，4位/6位使用固定密码长度
        verifyInfo.credentialLength = verifyInfo.authSubType === AuthSubType.PIN_SIX ? PIN_TYPE_SIX_PASSWORD_LENGTH :
          verifyInfo.authSubType === AuthSubType.PIN_FOUR ? PIN_TYPE_FOUR_PASSWORD_LENGTH : verifyInfo.credentialLength;
      }

      if (data?.sensorInfo && verifyInfo.authType === AuthType.FINGERPRINT) {
        // 更新指纹信息后再更新
        DisplayMgr.getCurrentDisplay().then(display => {
          this.fillFingerprintSensorInfo(verifyInfo, display, data?.sensorInfo);
          this.broadcastVerifyInfo(verifyInfo);
        });
      } else {
        this.broadcastVerifyInfo(verifyInfo);
      }
    }, propertyType);
  }

  private getSwitchStatus(authType: AuthType, hasCredential: boolean): boolean {
    switch (authType) {
      case AuthType.FACE:
        if (hasCredential) {
          return this.updateFaceVerifyInfo(true);
        } else {
          this._settingHelper.unRegisterObserver(KEY_FACE_KEYGUARD_ENABLE);
          this._settingHelper.unRegisterObserver(FACE_RECOGNIZE_SLIDE_UNLOCK);
        }
        return hasCredential;
      case AuthType.FINGERPRINT:
        if (hasCredential) {
          return this.updateFingerprintVerifyInfo(true);
        } else {
          this._settingHelper.unRegisterObserver(KEY_FINGERPRINT_KEYGUARD_ENABLE);
        }
        return hasCredential;
      default:
        return hasCredential;
    }
  }

  private updateFaceVerifyInfo(withObserver: boolean = false): boolean {
    let verifyInfo: InnerVerifyInfo | undefined = this._verifyInfos.get(AuthType.FACE);
    if (!verifyInfo) {
      log.showError(`updateFaceVerifyInfo encounter invalid authType ${withObserver}`);
      return false;
    }
    verifyInfo.isSwitchOpen = (this._settingHelper.getValueSync(KEY_FACE_KEYGUARD_ENABLE, FACE_UNLOCK_ENABLE) ===
      FACE_UNLOCK_ENABLE);
    verifyInfo.isDirectUnlock = (this._settingHelper.getValueSync(FACE_RECOGNIZE_SLIDE_UNLOCK, DEFAULT_VALUE) ===
      FACE_DIRECT_UNLOCK_ENABLE);
    log.showInfo(`Face isSwitchOpen: ${verifyInfo.isSwitchOpen}, isDirectUnlock: ${verifyInfo.isDirectUnlock}`);
    if (!withObserver) {
      return verifyInfo.isSwitchOpen;
    }
    if (!verifyInfo.changedCallback) {
      verifyInfo.changedCallback = (): void => {
        log.showInfo('receive face config changed.');
        this.updateFaceVerifyInfo();
        if (verifyInfo && verifyInfo.isStateChanged) {
          this.updateInnerVerifyInfo(verifyInfo);
        }
      };
    }
    this._settingHelper.registerObserver(KEY_FACE_KEYGUARD_ENABLE, verifyInfo.changedCallback);
    this._settingHelper.registerObserver(FACE_RECOGNIZE_SLIDE_UNLOCK, verifyInfo.changedCallback);
    return verifyInfo.isSwitchOpen;
  }

  private updateFingerprintVerifyInfo(withObserver: boolean = false): boolean {
    let verifyInfo: InnerVerifyInfo | undefined = this._verifyInfos.get(AuthType.FINGERPRINT);
    if (!verifyInfo) {
      log.showError(`updateFingerprintVerifyInfo encounter invalid authType ${withObserver}`);
      return false;
    }
    verifyInfo.isSwitchOpen = this._settingHelper.getValueSync(KEY_FINGERPRINT_KEYGUARD_ENABLE, DEFAULT_VALUE) ===
      FINGERPRINT_UNLOCK_ENABLE;
    log.showInfo(`Fingerprint: isSwitchOpen: ${verifyInfo.isSwitchOpen}`);
    if (!withObserver) {
      return verifyInfo.isSwitchOpen;
    }
    if (!verifyInfo.changedCallback) {
      verifyInfo.changedCallback = (): void => {
        log.showInfo('receive fingerprint config changed.');
        this.updateFingerprintVerifyInfo();
        if (verifyInfo && verifyInfo.isStateChanged) {
          this.updateInnerVerifyInfo(verifyInfo);
        }
      };
    }
    this._settingHelper.registerObserver(KEY_FINGERPRINT_KEYGUARD_ENABLE, verifyInfo.changedCallback);
    return verifyInfo.isSwitchOpen;
  }

  private registerDataChangeListener(): void {
    commonEventMonitor.registerCredentialSubscriber(this.handleSubscriberCallback.bind(this));
  }

  private unRegisterDataChangeListener(): void {
    commonEventMonitor.unRegisterCredentialSubscriber();
  }

  private handleSubscriberCallback(eventData: commonEventManager.CommonEventData): void {
    log.showInfo(`receive commonEvent ${eventData?.event}, parameters: ${eventData?.parameters?.credentialCount}`);
    if (eventData?.event !== USER_CREDENTIAL_UPDATED_EVENT || CheckEmptyUtils.isEmpty(eventData?.parameters)) {
      log.showInfo(`is not ${USER_CREDENTIAL_UPDATED_EVENT} or parameters is invalid`);
      return;
    }
    if (eventData?.event === USER_CREDENTIAL_UPDATED_EVENT &&
      eventData?.parameters?.isSilentCredChange === SILENT_CRED_CHANGE) {
      log.showInfo(`SilentCredChange not deal`);
      return;
    }
    let parameters = eventData?.parameters;
    if (AccountHelper.getInstance().currentLocalId.toString() !== parameters?.userId) {
      log.showInfo('received commonEvent userId is not currentUserId');
      return;
    }

    this.updateVerifyDataInner();
  }

  private fillFingerprintSensorInfo(verifyInfo: InnerVerifyInfo, display: screenSessionManager.RRect,
    sensorInfoStr?: string): void {
    if (sensorInfoStr === undefined) {
      log.showError('There is no sensorInfoStr under screen.');
      return;
    }
    try {
      let sensorInfo = JSON.parse(sensorInfoStr) as SensorInfoDataJson;
      let sensorType = sensorInfo?.sensorType;
      if (!sensorType) {
        log.showInfo('There is no sensor under screen.');
        return;
      }
      let fingerprintSensorInfo: FingerprintData;
      if (sensorType === SensorType.UNDER_SCREEN_SENSOR || sensorType === SensorType.BOTH_SENSOR) {
        log.showInfo(`sensorType: ${sensorType}`);
        fingerprintSensorInfo = new FingerprintData(sensorType,
          (sensorInfo.udSensorCenterXInThousandth / 1000) * display.width,
          (sensorInfo.udSensorCenterYInThousandth / 1000) * display.height, sensorInfo.udSensorRadiusInPx,
          display.height);
        log.showDebug(`coordinate: [${fingerprintSensorInfo.coordinateX}, ${fingerprintSensorInfo.coordinateY}]`);
      } else {
        log.showInfo('There is no sensor under screen.');
        fingerprintSensorInfo = new FingerprintData(sensorType);
      }
      verifyInfo.sensorInfo = fingerprintSensorInfo;
      verifyInfo.hasSyncSensorInfo = true;
      this.syncFingerprintTypeToDB(fingerprintSensorInfo.underScreenType);
    } catch (error) {
      log.showError(`fillFingerprintSensorInfo, error: code ${error.code}`);
    }
  }

  private syncFingerprintTypeToDB(underScreenType: UnderScreenType): void {
    let type = FingerprintType.NONE;
    switch (underScreenType) {
      case UnderScreenType.LOW:
        type = FingerprintType.UNDER_SCREEN_SENSOR_LOW;
        break;
      case UnderScreenType.HIGH:
        type = FingerprintType.UNDER_SCREEN_SENSOR_HIGH;
        break;
      case UnderScreenType.NONE:
      default:
        type = FingerprintType.NONE;
        break;
    }
    log.showInfo(`syncFingerprintTypeToDB:${type} underScreenType:${underScreenType}`);
    sSettingsUtil.setSecureValue('fingerprint_type', String(type));
  }

  private updateStrongAuth(strongAuth: number): void {
    this._verifyInfos.forEach((verifyInfo, _authType) => {
      verifyInfo.strongAuthReason = strongAuth;
      this.broadcastVerifyInfo(verifyInfo);
    });
  }

  private broadcastVerifyInfo(verifyInfo: InnerVerifyInfo): void {
    if (verifyInfo.broadcastTimeoutId !== 0) {
      clearTimeout(verifyInfo.broadcastTimeoutId);
      verifyInfo.broadcastTimeoutId = 0;
    }
    log.showWarn(`broadcastVerifyInfo ${verifyInfo.toString()}`);
    if (verifyInfo.isStateChanged) {
      verifyInfo.isStateChanged = false;
      this.broadcastDataChange(callback => callback.onVerifyStateChange?.(verifyInfo.authType, verifyInfo));
    }
    this.broadcastDataChange(callback => callback.onVerifyInfoChange?.(verifyInfo.authType, verifyInfo));
  }
}