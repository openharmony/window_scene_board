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
import keyManager from '@ohos.file.keyManager';
import osAccount from '@ohos.account.osAccount';
import process from '@ohos.process';
import { LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  DfxFaultEventTag,
  HiKGReportBase,
  HiKGReportTimeout,
  TIMEOUT_PARAMS
} from '../record/report/PerformanceMonitorUtil';
import { ScreenLockStateManager } from '../manager/ScreenLockStateManager';
import { VerifyDataManager } from '../manager/VerifyDataManager';
import { TraceTag } from '../record/trace/TraceTag';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'AccountHelper';
const log = LogHelper.getLogHelper(LogDomain.KG, TAG);

const INVALID_LOCAL_ID = -1;
const DEFAULT_CHALLENGE: Uint8Array = new Uint8Array(0);
const EVENT_KEY_RESET_FREEZE_TIME: number = 10001;
const DEFAULT_USER = 100;

/**
 * 身份验证的凭据类型的枚举
 */
export enum AuthType {
  PIN = osAccount.AuthType.PIN,
  FACE = osAccount.AuthType.FACE,
  FINGERPRINT = osAccount.AuthType.FINGERPRINT,
  DOMAIN = osAccount.AuthType.DOMAIN,
  REMOTE_UNLOCK,
}

/**
 * 解锁类型
 */
export enum AuthSubType {
  PIN_SIX = osAccount.AuthSubType.PIN_SIX,
  PIN_NUMBER = osAccount.AuthSubType.PIN_NUMBER,
  PIN_MIXED = osAccount.AuthSubType.PIN_MIXED,
  PIN_FOUR = osAccount.AuthSubType.PIN_FOUR,
  PIN_PATTERN = osAccount.AuthSubType.PIN_PATTERN,
  FACE_2D = osAccount.AuthSubType.FACE_2D,
  FACE_3D = osAccount.AuthSubType.FACE_3D,
  FINGERPRINT_CAPACITIVE = osAccount.AuthSubType.FINGERPRINT_CAPACITIVE,
  FINGERPRINT_OPTICAL = osAccount.AuthSubType.FINGERPRINT_OPTICAL,
  FINGERPRINT_ULTRASONIC = osAccount.AuthSubType.FINGERPRINT_ULTRASONIC,
  DOMAIN_MIXED = osAccount.AuthSubType.DOMAIN_MIXED,
}

/**
 * 认证结果的受信任级别的枚举
 */
export enum AuthTrustLevel {
  ATL1 = osAccount.AuthTrustLevel.ATL1,
  ATL2 = osAccount.AuthTrustLevel.ATL2,
  ATL3 = osAccount.AuthTrustLevel.ATL3,
  ATL4 = osAccount.AuthTrustLevel.ATL4,
}

/**
 * 要获取的属性类型的枚举
 */
export enum GetPropertyType {
  AUTH_SUB_TYPE = osAccount.GetPropertyType.AUTH_SUB_TYPE,
  REMAIN_TIMES = osAccount.GetPropertyType.REMAIN_TIMES,
  FREEZING_TIME = osAccount.GetPropertyType.FREEZING_TIME,
  ENROLLMENT_PROGRESS = osAccount.GetPropertyType.ENROLLMENT_PROGRESS,
  SENSOR_INFO = osAccount.GetPropertyType.SENSOR_INFO
}

/**
 * 指纹传感器类型
 */
export enum SensorType {
  OUT_OF_SCREEN_SENSOR = 'OUT_OF_SCREEN_SENSOR',
  UNDER_SCREEN_SENSOR = 'UNDER_SCREEN_SENSOR',
  BOTH_SENSOR = 'BOTH_SENSOR',
  NON_SENSOR = 'NON_SENSOR'
}

/**
 * 切换数据
 */
export type SwitchEventData = osAccount.OsAccountSwitchEventData;

/**
 * 获取属性类型
 */
export enum PropertyType {
  /**
   * 验证信息
   */
  VERIFY_INFO = 0x1,

  /**
   * 传感器信息
   */
  SENSOR_INFO = 0x2,
}

/**
 * IAM ResultCode
 */
export enum IAMAuthResult {
  SUCCEED = 0,
  FAIL = 1,
  PERMISSION_DENIED = 201,
  NOT_SYSTEM_APPLICATION = 202,
  PARAM_CHECK_FAILED = 401,
  SYS_SERVICE_EXCEPTION = 12300001,
  INVALID_PARAM = 12300002,
  INCORRECT_CREDENTIAL = 12300101, // 认证失败
  CREDENTIAL_NOT_ENROLLED = 12300102,
  UNSUPPORTED_AUTH_TRUST_LEVEL = 12300105,
  UNSUPPORTED_AUTH_TYPE = 12300106,
  AUTH_IS_CANCELED = 12300109,
  AUTH_LOCKED = 12300110, // 认证被锁定
  AUTH_TIMEOUT = 12300111, // 认证超时
  AUTH_SERVICE_BUSY = 12300112
}

/**
 * 账号工具类
 */
export class AccountHelper {
  private static sInstance: AccountHelper;

  public static getInstance(): AccountHelper {
    if (AccountHelper.sInstance == null) {
      AccountHelper.sInstance = new AccountHelper();
    }
    return AccountHelper.sInstance;
  }

  private readonly _userAuth: osAccount.UserAuth;
  private readonly _pinAuth: osAccount.PINAuth;
  private readonly _userIdentityManager: osAccount.UserIdentityManager;
  private _currentLocalId: number = INVALID_LOCAL_ID;
  private _canReEncryption = true;

  private constructor() {
    this._userAuth = new osAccount.UserAuth();
    this._pinAuth = new osAccount.PINAuth();
    this._userIdentityManager = new osAccount.UserIdentityManager();
  }

  public get currentLocalId(): number {
    if (this._currentLocalId === INVALID_LOCAL_ID) {
      this._currentLocalId = this.getAccountLocalId();
      AppStorage.setOrCreate('mCurrentUserId', this._currentLocalId);
    }
    return this._currentLocalId;
  }

  /**
   * 判断当前用户是否为前台用户
   *
   * @param callback 回调函数
   * @returns 是否为前台用户
   */
  public isForegroundUser(callback: (isForegroundUser: boolean) => void, userId?: number): void {
    try {
       osAccount.getAccountManager().getForegroundOsAccountLocalId().then(foregroundUserId => {
         log.showInfo('getForegroundOsAccountLocalId success.');
         callback(foregroundUserId === (userId ?? this.currentLocalId));
       }).catch(() => {
         log.showError('osAccount error -> getForegroundOsAccountLocalId');
         HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
           Object({INTERFACE_NAME: 'getForegroundOsAccountLocalId', ERROR_CODE: 0}));
       });
    } catch (error) {
      log.showError(`osAccount error -> getForegroundOsAccountLocalId. code ${error?.code}`);
      HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
        Object({INTERFACE_NAME: 'getForegroundOsAccountLocalId', ERROR_CODE: error?.code}));
    }
  }

  /**
   * 判断当前用户是否为隐私空间用户
   *
   * @param callback 回调函数
   * @returns 是否为隐私空间用户
   */
  public isPrivacySpaceUser(callback: (isPrivacySpaceUser: boolean) => void): void {
    try {
      osAccount.getAccountManager().getOsAccountType().then(osAccountType => {
        log.showInfo(`getOsAccountType success, osAccountType: ${osAccountType}`);
        callback(osAccountType === osAccount.OsAccountType.PRIVATE);
      }).catch(() => {
        log.showError('osAccount error -> getOsAccountType');
        HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
          Object({INTERFACE_NAME: 'getOsAccountType', ERROR_CODE: 0}));
      });
    } catch (error) {
      log.showError(`osAccount error -> getOsAccountType. code ${error?.code}`);
      HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
        Object({INTERFACE_NAME: 'getOsAccountType', ERROR_CODE: error?.code}));
    }
  }

  /**
   * 是否是主用户
   *
   * @returns 是否是主用户
   */
  public isDefaultUser(): boolean {
    return this.currentLocalId === DEFAULT_USER;
  }

  /**
   * 激活账户
   *
   * @param localId Local ID
   * @param callback 回调
   */
  public activateOsAccount(localId: number, success?: () => void, fail?: (errCode: number) => void): void {
    let currentLocalId: number = AccountHelper.getInstance().currentLocalId;
    try {
      osAccount.getAccountManager().activateOsAccount(localId, (err, _data) => {
        if (err) {
          log.showError(`osAccount error -> ${currentLocalId} activateOsAccount ${localId}. code: ${err?.code}.`);
          HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
            Object({ INTERFACE_NAME: 'activateOsAccount', ERROR_CODE: err?.code }));
          fail?.(err?.code);
        } else {
          log.showInfo(`${currentLocalId} activateOsAccount ${localId} success.`);
          success?.();
        }
      });
    } catch (error) {
      log.showError(`osAccount error -> ${currentLocalId} activateOsAccount ${localId}. code ${error?.code}`);
      HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
        Object({ INTERFACE_NAME: 'activateOsAccount', ERROR_CODE: error?.code }));
      fail?.(-1);
    }
  }

  /**
   * 注册用户切换的监听
   *
   * @param typeName 切换中或已切换
   * @param callback 用户切换时回调
   */
  public registerUserSwitchListener(typeName: 'switched' | 'switching', callback: Callback<SwitchEventData>): void {
    log.showInfo(`registerUserSwitchListener, typeName: ${typeName}`);
    try {
      if (typeName === 'switched') {
        osAccount.getAccountManager().on(typeName, callback);
      } else if (typeName === 'switching') {
        osAccount.getAccountManager().on(typeName, callback);
      }
    } catch (error) {
      log.showError(`osAccount error -> getAccountManagerOn ${typeName}. code ${error?.code}`);
      HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
        Object({ INTERFACE_NAME: 'getAccountManagerOn', ERROR_CODE: error?.code }));
    }
  }

  /**
   * 注销用户切换的监听
   *
   * @param typeName 切换中或已切换
   * @param callback 用户切换时回调
   */
  public unRegisterUserSwitchListener(typeName: 'switched' | 'switching', callback: Callback<SwitchEventData>): void {
    log.showInfo(`unRegisterUserSwitchListener, typeName: ${typeName}`);
    try {
      if (typeName === 'switched') {
        osAccount.getAccountManager().off(typeName, callback);
      } else if (typeName === 'switching') {
        osAccount.getAccountManager().off(typeName, callback);
      }
    } catch (error) {
      log.error(`osAccount error -> getAccountManagerOff ${typeName}. code ${error?.code}`);
      HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
        Object({ INTERFACE_NAME: 'getAccountManagerOff', ERROR_CODE: error?.code }));
    }
  }

  /**
   * 获取指纹传感器信息
   *
   * @param callback 获取成功时回调
   * @returns true下发成功/false下发失败
   */
  public getFingerprintSensorProperty(callback: (sensorInfo?: string) => void): boolean {
    log.showInfo('getFingerprintSensorProperty.');
    let request: osAccount.GetPropertyRequest = {
      'authType': osAccount.AuthType.FINGERPRINT,
      'keys': [osAccount.GetPropertyType.SENSOR_INFO]
    };
    try {
      this._userAuth.getProperty(request, (err, data) => {
        if (err) {
          log.showError(`osAccount error -> getSensorProperty, errCode ${err?.code}`);
          HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
            Object({ INTERFACE_NAME: 'getProperty', ERROR_CODE: err?.code }));
          return;
        }
        callback(data.sensorInfo);
      });
      return true;
    } catch (error) {
      log.showError(`osAccount error -> getSensorProperty. code ${error?.code}`);
      HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
        Object({ INTERFACE_NAME: 'getProperty', ERROR_CODE: error?.code }));
    }
    return false;
  }

  /**
   * 验证当前用户
   *
   * @param authType 权限类型
   * @param authLevel 权限级别
   * @param options 认证参数
   * @param callback 认证回调
   * @returns 取消的上下文ID
   */
  public authUser(authType: number, authLevel: number, options: osAccount.AuthOptions,
    callback: osAccount.IUserAuthCallback): Uint8Array | undefined {
    log.showInfo(`authUser: userId ${this.currentLocalId}, type: ${authType}, level: ${authLevel}`);
    try {
      return this._userAuth.auth(DEFAULT_CHALLENGE, authType, authLevel, options, callback);
    } catch (error) {
      log.showError(`osAccount error -> authUser. code ${error?.code}`);
      HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
        Object({ INTERFACE_NAME: 'authUser', ERROR_CODE: error?.code }));
      return undefined;
    }
  }

  /**
   * 取消验证
   *
   * @param contextId 身份验证上下文ID
   */
  public cancelAuth(contextId: Uint8Array): void {
    if (!contextId) {
      return;
    }
    log.showInfo(`cancelAuth ${contextId}`);
    try {
      HiKGReportTimeout.getInstance().logTimeout(TIMEOUT_PARAMS.OSACCOUNT_CANCEL.NAME,
        TIMEOUT_PARAMS.OSACCOUNT_CANCEL.TIME_OUT);
      Trace.start(TraceTag.CANCEL_VERIFY);
      this._userAuth.cancelAuth(contextId);
      Trace.end(TraceTag.CANCEL_VERIFY);
      HiKGReportTimeout.getInstance().rollbackTimeout(TIMEOUT_PARAMS.OSACCOUNT_CANCEL.NAME);
    } catch (error) {
      Trace.end(TraceTag.CANCEL_VERIFY);
      HiKGReportTimeout.getInstance().rollbackTimeout(TIMEOUT_PARAMS.OSACCOUNT_CANCEL.NAME);
      log.showError(`osAccount error -> cancelAuth. code ${error?.code}`);
    }
  }

  /**
   * 注册PIN码输入器
   *
   * @param password 密码
   * @returns true成功/false失败
   */
  public registerInputer(onGetData: (authSubType: number, callback: osAccount.IInputData) => void): boolean {
    log.showInfo('registerInputer');
    try {
      this._pinAuth.registerInputer({
        onGetData: (passType: osAccount.AuthSubType, inputData: osAccount.IInputData) => {
          // 注意：多用户场景，此处会多次调用
          onGetData(passType, inputData);
        }
      });
      log.showInfo('registerInputer success.');
      return true;
    } catch (error) {
      log.showError(`osAccount error -> registerInputer. code ${error?.code}`);
      HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
        Object({ INTERFACE_NAME: 'registerInputer', ERROR_CODE: error?.code }));
      return false;
    }
  }

  /**
   * 注销PIN码输入器
   *
   * @returns true成功/false失败
   */
  public unregisterInputer(): boolean {
    try {
      log.showInfo('unregisterInputer success');
      this._pinAuth.unregisterInputer();
      return true;
    } catch (error) {
      log.error(`osAccount error -> unregisterInputer. code ${error?.code}`);
      HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
        Object({ INTERFACE_NAME: 'unregisterInputer', ERROR_CODE: error?.code }));
      return false;
    }
  }

  /**
   * 提交输入数据
   *
   * @param data 数据数据
   * @param authSubType 密码类型
   * @param inputData 数据注入器
   * @returns true成功/false失败
   */
  public submitInputData(data: Uint8Array, authSubType: number, inputData: osAccount.IInputData): boolean {
    try {
      inputData?.onSetData(authSubType, data);
      log.showInfo(`submitInputData success. authSubType: ${authSubType}`);
      return true;
    } catch (error) {
      log.showError(`osAccount error -> submitInputData. code ${error?.code}`);
      HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
        Object({ INTERFACE_NAME: 'onSetData', ERROR_CODE: error?.code }));
    }
    return false;
  }

  /**
   * 查询所有认证信息
   *
   * @param callback 回调函数
   */
  public getAllAuthInfo(callback: (data: Array<osAccount.EnrolledCredInfo>) => void, errCallback?: () => void): void {
    try {
      this._userIdentityManager.getAuthInfo({
        accountId: this.currentLocalId
      })
        .then(data => callback(data))
        .catch((err: Error) => {
          let error: BusinessError = err as BusinessError;
          log.showError(`osAccount error -> getAuthInfo. errCode ${error?.code}`);
          HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
            Object({ INTERFACE_NAME: 'getAuthInfo', ERROR_CODE: error?.code }));
          errCallback?.();
        });
    } catch (error) {
      log.error(`osAccount error -> getAllAuthInfo. code ${error?.code}`);
      HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
        Object({ INTERFACE_NAME: 'getAuthInfo', ERROR_CODE: error?.code }));
      errCallback?.();
    }
  }

  /**
   * 查询所有认证信息
   *
   * @param authType 验证类型
   * @param callback 回调函数
   * @param propertyType 属性类型
   * @returns 是否成功下发
   */
  public getProperty(authType: number, callback: (data: osAccount.ExecutorProperty) => void,
    propertyType: number = PropertyType.VERIFY_INFO): boolean {
    log.showInfo(`getProperty authType ${authType}`);
    let requestKeys: osAccount.GetPropertyType[] = [];
    if ((propertyType & PropertyType.VERIFY_INFO) === PropertyType.VERIFY_INFO) {
      requestKeys.push(osAccount.GetPropertyType.AUTH_SUB_TYPE, osAccount.GetPropertyType.REMAIN_TIMES,
        osAccount.GetPropertyType.FREEZING_TIME, osAccount.GetPropertyType.NEXT_PHASE_FREEZING_TIME);
    }
    if (authType === AuthType.PIN) {
      requestKeys.push(osAccount.GetPropertyType.CREDENTIAL_LENGTH);
    }
    if ((propertyType & PropertyType.SENSOR_INFO) === PropertyType.SENSOR_INFO) {
      requestKeys.push(osAccount.GetPropertyType.SENSOR_INFO);
    }
    if (requestKeys.length === 0) {
      log.showError(`invalid propertyType: ${propertyType}`);
      return false;
    }
    let request: osAccount.GetPropertyRequest = {
      authType: authType,
      keys: requestKeys,
      accountId: this.currentLocalId
    };
    try {
      this._userAuth.getProperty(request, (err, data) => {
        if (err) {
          log.showError(`osAccount error -> getProperty authType ${authType}. err code ${err?.code}`);
          HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
            Object({ INTERFACE_NAME: 'getProperty', ERROR_CODE: err?.code }));
          return;
        }
        callback(data);
      });
      return true;
    } catch (error) {
      log.showError(`osAccount error -> getProperty authType ${authType}. code ${error?.code}`);
      HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
        Object({ INTERFACE_NAME: 'getProperty', ERROR_CODE: error?.code }));
    }
    return false;
  }

  /**
   * 查询其他用户的密码信息(认证类型和密码长度)，用于非定长密码联动认证
   *
   * @param user 用户Id
   * @param callback 回调函数
   * @returns 是否成功下发
   */
  public getOtherUserProperty(user: number, callback: (data: osAccount.ExecutorProperty) => void): boolean {
    log.showInfo(`getOtherUserProperty user ${user}`);
    let requestKeys = [osAccount.GetPropertyType.AUTH_SUB_TYPE, osAccount.GetPropertyType.CREDENTIAL_LENGTH];
    let request: osAccount.GetPropertyRequest = {
      authType: osAccount.AuthType.PIN,
      keys: requestKeys,
      accountId: user
    };
    try {
      this._userAuth.getProperty(request, (err, data) => {
        if (err) {
          log.showError(`osAccount error -> getOtherUserProperty user ${user}. err code ${err?.code}`);
          return;
        }
        callback(data);
      });
      return true;
    } catch (error) {
      log.showError(`osAccount error -> getOtherUserProperty user ${user}. code ${error?.code}`);
    }
    return false;
  }

  /**
   * 查询其他用户的UserId，（仅隐私空间和主空间场景）
   *
   * @param callback 回调函数
   */
  public getOtherUserId(callback: (otherUser: number) => void): void {
    try {
      osAccount.getAccountManager().queryAllCreatedOsAccounts((err, list: Array<osAccount.OsAccountInfo>) => {
        if (err) {
          log.showError(`osAccount error -> getOtherUserId. err code ${err?.code}`);
          return;
        }
        if (list.length <= 1) {
          callback?.(INVALID_LOCAL_ID);
          return;
        }
        for (let userInfo of list) {
          if (userInfo.type !== osAccount.OsAccountType.ADMIN && userInfo.type !== osAccount.OsAccountType.PRIVATE) {
            continue;
          }
          if (userInfo.localId !== this._currentLocalId) {
            log.showInfo(`getOtherUserId userId ${userInfo.localId}`);
            callback?.(userInfo.localId);
          }
        }
        callback?.(INVALID_LOCAL_ID);
      });
    } catch (error) {
      log.showError(`osAccount error -> getOtherUserId. code ${error?.code}`);
    }
    callback?.(INVALID_LOCAL_ID);
  }

  /**
   * 显示锁屏时需加载人脸识别算法，加快解锁速度
   * 锁屏退出后延时10s卸载，降低人脸内存
   *
   * @param isOpen 加载或卸载
   * @param callback 成功后回调
   */
  public openFaceUnlock(isOpen: boolean, callback: () => void): void {
    log.showInfo(`openFaceUnlock. isOpen: ${isOpen}`);

    this.setProperty({
      authType: osAccount.AuthType.FACE,
      key: osAccount.SetPropertyType.INIT_ALGORITHM,
      setInfo: this.stringToUint8Array(JSON.stringify({
        'operation': isOpen ? 'init' : 'uninit',
        'caller': 'systemui'
      }))
    }, callback);
  }

  /**
   * 重置冻结时间
   *
   * @param callback 成功后回调
   */
  public resetFreezeTime(authType: AuthType, callback: () => void, errorCallback?: () => void): void {
    log.showInfo(`resetFreezeTime. authType: ${authType}`);
    const buffer = new ArrayBuffer(4);
    const view = new DataView(buffer);
    view.setInt32(0, this.currentLocalId, true);
    const uint8Array = new Uint8Array(buffer);

    this.setProperty({
      authType: osAccount.AuthType.PIN,
      key: EVENT_KEY_RESET_FREEZE_TIME,
      setInfo: uint8Array
    }, callback, errorCallback);
  }

  /**
   * 文件加密
   *
   * @param userId 用户ID
   */
  public fileEncryption(userId?: number): void {
    // 智慧屏在锁屏显示时，不需要进行存储加密
    let targetUser = userId ?? this.currentLocalId;
    log.showWarn(`fileEncryption userId: ${targetUser}`);
    try {
      keyManager.deactivateUserKey(targetUser);
      this._canReEncryption = true;
      log.showDebug('fileEncryption success');
    } catch (error) {
      if (this.canReTryFileEncryption()) {
        this.fileEncryption(userId);
        this._canReEncryption = false;
      }
      log.showError(`osAccount error -> fileEncryption deactivateUserKey ${targetUser}. code ${error?.code}`);
      HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
        Object({ INTERFACE_NAME: 'deactivateUserKey', ERROR_CODE: error?.code }));
    }
  }

  /**
   * 判断文件加密失败后是否重试
   */
  private canReTryFileEncryption(): boolean {
    // 重试唯一一次
    if (!this._canReEncryption) {
      log.showInfo('Retry only once. Do not try again');
      return false;
    }
    // 无密码不重试
    if (VerifyDataManager.getInstance().hasNoPwd) {
      log.showInfo('The user is not encrypted. Do not try again');
      return false;
    }
    // 未上锁不重试
    if (!ScreenLockStateManager.getInstance().isLocked) {
      log.showInfo('The user is not locked. Do not try again');
      return false;
    }
    return true;
  }

  private setProperty(request: osAccount.SetPropertyRequest, callback: () => void, errorCallback?: () => void): void {
    try {
      this._userAuth.setProperty(request, (err) => {
        if (err) {
          log.showError(`osAccount error -> setProperty. code ${err?.code}}`);
          errorCallback?.();
          HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
            Object({ INTERFACE_NAME: 'setProperty', ERROR_CODE: err?.code }));
          return;
        }
        callback();
      });
    } catch (error) {
      log.showError(`osAccount error -> setProperty. code ${error?.code}`);
      errorCallback?.();
      HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
        Object({ INTERFACE_NAME: 'setProperty', ERROR_CODE: error?.code }));
    }
  }

  private getAccountLocalId(): number {
    try {
      return osAccount.getAccountManager().getOsAccountLocalIdForUidSync(process.uid);
    } catch (error) {
      log.showError(`osAccount error -> getOsAccountLocalIdForUidSync. code ${error?.code}`);
      HiKGReportBase.reportFault(DfxFaultEventTag.ACCOUNT_INTERFACE_ABNORMAL,
        Object({ INTERFACE_NAME: 'getOsAccountLocalIdForUidSync', ERROR_CODE: error?.code }));
      return INVALID_LOCAL_ID;
    }
  }

  private stringToUint8Array(str: string): Uint8Array {
    let arr: number[] = [];
    for (let i = 0, j = str.length; i < j; ++i) {
      arr.push(str.charCodeAt(i));
    }
    arr.push(0);

    let tmpUint8Array: Uint8Array = new Uint8Array(arr);
    return tmpUint8Array;
  }
}