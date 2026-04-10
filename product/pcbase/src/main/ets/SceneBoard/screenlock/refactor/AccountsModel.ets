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

import {
  SingletonHelper,
  LogDomain,
  LogHelper,
  ObjUtil,
  ArrayUtils,
} from '@ohos/basicutils';
import keyManager from '@ohos.file.keyManager';
import osAccount from '@ohos.account.osAccount';
import util from '@ohos.util';
import type { Callback, AsyncCallback, BusinessError } from '@ohos.base';
import type { IUserData } from '@ohos/screenlockcommon';
import ScreenLockService from './ScreenLockService';
import { HiSysEventUtil } from '@ohos/frameworkwrapper';
import { privacySpaceManager } from './PrivacySpaceManager';
import commonEventMonitor from '@ohos/screenlockcommon/src/main/ets/base/CommonEventMonitor';
import type { IAMAuthExtraInfo } from '@ohos/screenlockcommon/src/main/ets/bean/IAMAuthExtraInfo';
import { KeyguardStatusService } from '@ohos/screenlockcommon/src/main/ets/manager/KeyguardStatusService';
import { KeyGuardMode } from '@ohos/screenlockcommon/src/main/ets/bean/KeyGuardStatusEnum';
import { FingerprintVerifyState } from '@ohos/screenlockcommon/src/main/ets/constants/FingerprintConstants';
import { GlobalStatusCache } from '@ohos/screenlockcommon/src/main/ets/base/GlobalStatusCache';
import { CommonUtil } from '@ohos/screenlockcommon/src/main/ets/utils/CommonUtil';
import lazy { SpecificScreenLockStateManager } from '../common/SpecificScreenLockStateManager';

const TAG = 'ScreenLock-AccountsModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const TYPE_ADMIN = 0;
const TYPE_NORMAL = 1;
const TYPE_GUEST = 2;
const DEFAULT_USER = 100;
const USER_LENGTH = 99;
const FREEZE_TIME = 3000;
const PIN_VALIDITY_FLAG = -1;
const INVALID_USER = -1;
const TONE_TYPE_OTHER:number = 2;
const SCREEN_LOCK_TONE_TYPE: string = 'screenLockToneType';
const UNKNOWN_AUTH_TYPE: number = -1;
const MAX_RETRY: number = 3;
export enum AuthType {
  //Authentication type pin.
  PIN = 1,
  //Authentication type face.
  FACE = 2,
  //Authentication type fingerprint
  FINGERPRINT = 4,
  //Authentication type domain.
  DOMAIN = 1024
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

export enum AuthSubType {

  PIN_NONE = 0,
  //Authentication sub type six number pin.
  PIN_SIX = 10000,
  //Authentication sub type self defined number pin.
  PIN_NUMBER = 10001,
  //Authentication sub type mixed number pin.
  PIN_MIXED = 10002,
  //Authentication sub type four number pin.
  PIN_FOUR = 10003,
  //Authentication sub type pattern pin.
  PIN_PATTERN = 10004,
  //Authentication sub type 2D face.
  FACE_2D = 20000,
  //Authentication sub type 3D face.
  FACE_3D = 20001,
  //Authentication sub type fingerprint of capacitive.
  FINGERPRINT_CAPACITIVE = 30000,
  //Authentication sub type fingerprint of optical.
  FINGERPRINT_OPTICAL = 30001,
  //Authentication sub type fingerprint of ultrasonic.
  FINGERPRINT_ULTRASONIC = 30002,
  //Authentication sub type domain mixed.
  DOMAIN_MIXED = 10240001
}

export enum AuthTurstLevel {
  //Authentication result trusted level 1.
  ATL1 = 10000,
  //Authentication result trusted level 2.
  ATL2 = 20000,
  //Authentication result trusted level 3.
  ATL3 = 30000,
  //Authentication result trusted level 4.
  ATL4 = 40000
}

export enum GetPropertyType {
  //Authentication remain times.
  AUTH_SUB_TYPE = 1,
  //Authentication remain times.
  REMAIN_TIMES = 2,
  //Authentication remain times.
  FREEZING_TIME = 3,
  ENROLLMENT_PROGRESS = 4,
  SENSOR_INFO = 5
}

export enum ResultCode {
  //success
  SUCCESS = 0,
  //fails
  FAIL = 1,
}

export enum MultiKeyCode {
  DPAD_LEFT = 2014,
  DPAD_RIGHT = 2015,
  NUMPAD_ENTER = 2119,
  ENTER = 2054
}

export class OsAccountSwitchEventData {
  fromAccountId: number = 0;
  toAccountId: number = 0;
}

enum SetPropertyType {
  INIT_ALGORITHM = 1
}

enum AuthIntentType {
  /**
   * 仅认证当前主用户
   */
  UNLOCK_CURRENT_ONLY = 10001,
}

/**
 * 用户切换回调
 */
export interface accountSwitchCallback {
  onSwitching?: Function;
  onSwitched?: Function;
}

/**
 * 孩童模式
 * */
const CHILD_MODULE: string = 'childModule';

let mCurrentUserId: number = 100;
let mForegroundUserId: number = 100;
let accountMap: Map<number, IUserData>;

/**
 * Accounts Tool
 *
 * @since 2022-06-06
 */
class AccountsModel {
  userAuthManager = new osAccount.UserAuth();
  pinAuthManager = new osAccount.PINAuth();
  private userIdentityManager: osAccount.UserIdentityManager = new osAccount.UserIdentityManager();
  userImage: string | Resource = $r('app.media.ic_user_head_default');
  userName: string = 'Default';
  isPageShow: boolean = false;
  mEventSubscriber: undefined = undefined;
  targetUser: number = INVALID_USER;
  startTime: number = 0;
  public osAccountSwitchEventData: OsAccountSwitchEventData = new OsAccountSwitchEventData();
  public inputData: osAccount.IInputData | null = null;
  public passType: osAccount.AuthSubType = osAccount.AuthSubType.PIN_SIX;
  private password: string = '';
  private isActiveUserIdInit: boolean = false;
  private accountSwitchCallbackMap: Map<string, accountSwitchCallback> = new Map();
  private accountManager: osAccount.AccountManager = osAccount.getAccountManager();
  private userSwitchingCallback: Callback<OsAccountSwitchEventData> = () => {};
  private userSwitchedCallback: Callback<OsAccountSwitchEventData> = () => {};
  private retryCount: number = 0;

  /**
   * 处理快捷键
   *
   * @param keyEvent 键盘事件
   */
  dispatchKeyEvent(keyEvent: KeyEvent, userId: number): void {
    if (!ScreenLockService.isScreenOn) {
      log.showWarn('Screen OFF, return');
      return;
    }
    if (keyEvent.type === KeyType.Up) {
      return;
    }
    log.showInfo('dispatchKeyEvent keyEvent');
    switch (keyEvent.keyCode) {
      case MultiKeyCode.ENTER:
      case MultiKeyCode.NUMPAD_ENTER:
        if (AppStorage.get('accountSwitch')) {
          log.showWarn('account switching, return');
          return;
        }
        if (userId === AppStorage.get('mCurrentUserId')) {
          log.showInfo('enter to unlock');
          ScreenLockService.unlockScreen();
        } else {
          this.onUserSwitch(userId);
        }
        break;
      default:
        break;
    }
  }

  /**
   * init
   */
  modelInit(): void {
    this.updateForegroundUserInfo();
    this.updateCurrentUserId(() => {
      ScreenLockService.updateAllUsers();
    });
    log.showInfo('start ModelInit, start ModelInit finish');
  }

  /**
   * 注册用户切换时的回调
   *
   * @param registerType 监听类型
   * @param callback 用户切换时的回调
   */
  public registerAccountSwitchCallback(registerType: string, callback: accountSwitchCallback): void {
    log.showInfo('registerAccountSwitchCallback');
    let accountSwitchCallback: accountSwitchCallback | undefined = this.accountSwitchCallbackMap.get(registerType);
    if (accountSwitchCallback) {
      log.showInfo('accountSwitch callback is not null');
    }
    this.accountSwitchCallbackMap.set(registerType, callback);
  }

  /**
   * 取消注册用户切换时的回调
   *
   * @param registerType 监听类型
   * @param callback 用户切换时的回调
   */
  public unRegisterAccountSwitchCallback(registerType: string): void {
    log.showInfo('unRegisterAccountSwitchCallback');
    let accountSwitchCallback: accountSwitchCallback | undefined= this.accountSwitchCallbackMap.get(registerType);
    if (!accountSwitchCallback) {
      log.showInfo('accountSwitch callback is null');
      return;
    }
    this.accountSwitchCallbackMap.delete(registerType);
  }

  /**
   * 处理用户切换的回调
   *
   * @param switchEventData 用户切换数据
   */
  public handleAccountSwitchCallback(typeName: 'switched' | 'switching',
    switchEventData: OsAccountSwitchEventData): void {
    log.showInfo(`${typeName} accountSwitch callback`);
    if (typeName === 'switching') {
      this.accountSwitchCallbackMap.forEach((callback: accountSwitchCallback, registerType: string) => {
        callback.onSwitching?.(switchEventData);
      });
    }

    if (typeName === 'switched') {
      this.accountSwitchCallbackMap.forEach((callback: accountSwitchCallback, registerType: string) => {
        callback.onSwitched?.(switchEventData);
      });
    }
  }

  /**
   * 注册用户切换的监听
   *
   * @param typeName switching or switched
   * @param callback callback
   */
  registerUserSwitchListener(typeName: 'switched' | 'switching', callback: Callback<OsAccountSwitchEventData>): void {
    log.showInfo(`registerUserSwitchListener, typeName: ${typeName}`);
    try {
      if (typeName === 'switching') {
        this.userSwitchingCallback = callback;
        this.accountManager.on(typeName, this.onUserSwitchingEvent);
      } else if (typeName === 'switched') {
        this.userSwitchedCallback = callback;
        this.accountManager.on(typeName, this.onUserSwitchedEvent);
      }
    } catch (error) {
      log.showError(`monitorUserSwitch ${typeName} failed.`);
    }
  }

  /**
   * 取消注册用户切换的监听
   *
   * @param typeName switching or switched
   */
  unRegisterUserSwitchListener(typeName: 'switched' | 'switching'): void {
    log.showInfo(`unRegisterUserSwitchListener, typeName: ${typeName}`);
    try {
      if (typeName === 'switching') {
        this.accountManager.off(typeName, this.onUserSwitchingEvent);
      } else if (typeName === 'switched') {
        this.accountManager.off(typeName, this.onUserSwitchedEvent);
      }
    } catch (error) {
      log.error('unRegisterUserSwitchListener error');
    }
  }

  private onUserSwitchingEvent: Callback<OsAccountSwitchEventData> =
    (switchEventData: OsAccountSwitchEventData): void => {
      log.showInfo(`monitorUserSwitch, on Switching callback from ${switchEventData.fromAccountId} to ${switchEventData.toAccountId}`);
      this.osAccountSwitchEventData = switchEventData;
      if (switchEventData.fromAccountId === switchEventData.toAccountId) {
        log.showInfo('isActivatingUser');
        return;
      }
      this.userSwitchingCallback(switchEventData);
      GlobalStatusCache.getInstance().setStatus(SCREEN_LOCK_TONE_TYPE, TONE_TYPE_OTHER);
      this.handleAccountSwitchCallback('switching', switchEventData);
    };

  private onUserSwitchedEvent: Callback<OsAccountSwitchEventData> =
    (switchEventData: OsAccountSwitchEventData): void => {
      log.showInfo(`monitorUserSwitch, on Switched callback from ${switchEventData.fromAccountId} to ${switchEventData.toAccountId}`);
      if (switchEventData.fromAccountId === switchEventData.toAccountId) {
        log.showInfo('isActivatingUser');
        return;
      }
      mForegroundUserId = switchEventData.toAccountId;
      this.userSwitchedCallback(switchEventData);
      this.handleAccountSwitchCallback('switched', switchEventData);
    };

  /**
   * register account event
   *
   * @param callback callback
   */
  accountEventListener(callback: Callback<void>): void {
    commonEventMonitor.registerUserUpdateSubscriber(this.handleSubscriberCallback);
  }

  private handleSubscriberCallback = (): void => {
    log.showInfo('handle account event');
    this.updateAllUsers((type: osAccount.AuthType) => {
      log.showInfo('accountEventListener event updateAllUsers');
    });
  };

  /**
   * unRegister account event
   *
   * @param callback callback
   */
  unRegisterAccountEventListener(): void {
    commonEventMonitor.unRegisterUserUpdateSubscriber();
  }

  private userActivated(user: IUserData, callback: Callback<osAccount.AuthType>): void {
    let toAccountId: number = user.userId;
    log.showInfo(`begin userActivated userId:${toAccountId}`);
    this.getAuthType((enrolledCredInfoArray: osAccount.EnrolledCredInfo[]) => {
      let enableAuthTypes: Array<osAccount.AuthType> = [];
      let hasPin: boolean = false;
      enrolledCredInfoArray.forEach((credInfo, index) => {
        if (credInfo.authType === osAccount.AuthType.PIN) {
          hasPin = true;
        }
        enableAuthTypes[index] = credInfo.authType;
      });
      if (!hasPin) {
        enableAuthTypes = enableAuthTypes.filter(item => item !== osAccount.AuthType.DOMAIN);
        log.showInfo(`this current user not set pin, will delete domain authType enableAuthTypes includes DOMAIN :${enableAuthTypes.includes(osAccount.AuthType.DOMAIN)}`);
      }
      user.availableAuthTypes = enableAuthTypes;
      AppStorage.setOrCreate('userName', user.userName);
      AppStorage.setOrCreate('currentUserItem', user);
      callback(enableAuthTypes.includes(osAccount.AuthType.DOMAIN) ? osAccount.AuthType.DOMAIN : osAccount.AuthType.PIN);
      this.refreshCurrentAccount();
    });
  }

  public userDeactivated(userid: number): boolean {
    if (mCurrentUserId !== userid) {
      log.showError('userId is not equal with currentUserId');
      return false;
    }
    try {
      osAccount.getAccountManager().deactivateOsAccount(userid);
    } catch (err) {
      log.showError('deactivateAccount error: ' + err.message);
      return false;
    }
    return true;
  }

  public async updateCurrentUserId(callback: Callback<void>): Promise<void> {
    await osAccount.getAccountManager().getOsAccountLocalId().then((localId: number) => {
      log.showInfo(`updateCurrentUserId localUserId:${localId}`);
      mCurrentUserId = localId;
      AppStorage.setOrCreate('mCurrentUserId', mCurrentUserId);
      this.isActiveUserIdInit = true;
      callback();
    }).catch((error: BusinessError) => {
      log.showError(`queryLocalId failed`);
    });
  }

  /**
   * updateAllUsers data
   * @param callback callback
   */
  public updateAllUsers(callback: Callback<osAccount.AuthType>): void {
    let accountList: IUserData[] = [];
    accountMap = new Map<number, IUserData>();
    log.showInfo('start updateAllUsers, start query');
    osAccount.getAccountManager().queryAllCreatedOsAccounts().then((list: osAccount.OsAccountInfo[]) => {
      AppStorage.setOrCreate('createdListLen', list.length);
      privacySpaceManager.updatePrivateUser(list);
      log.showInfo(`updateAllUsers list.length = ${list.length}, start sort`);
      for (const user of list) {
        log.showInfo('start get user');
        let type = this.transType(user.type);
        let domain: boolean = Boolean(user?.domainInfo?.accountName && user?.domainInfo?.domain);
        let userData: IUserData = {
          userId: user.localId,
          userName: user.localName,
          userIconPath: '',
          type: type,
          isDomain: domain,
          isLoggedIn: Boolean(user.isLoggedIn),
          createTime: user.createTime,
          lastLoginTime: user.lastLoginTime
        };
        accountList.push(userData);
        accountMap.set(user.localId, userData);
        if (userData.userId === mCurrentUserId) {
          this.userActivated(userData, callback);
        }
        osAccount.getAccountManager().getOsAccountProfilePhoto(user.localId).then((photoRoad: string) => {
          log.showInfo(`start get photo: ${photoRoad}`);
          if (accountMap.get(user.localId) === undefined) {
            return;
          }
          let userData: IUserData = accountMap.get(user.localId) as IUserData;
          userData.userIconPath = photoRoad;
        });
      }
      AppStorage.setOrCreate('userList', accountList);
      log.showInfo('sort end');
    }).catch((error: BusinessError) => {
      log.showError('updateAllUsers queryAllCreatedOsAccounts failed');
    });
  }

  transType(originalType: number): osAccount.OsAccountType {
    if (originalType === TYPE_ADMIN) {
      return osAccount.OsAccountType.ADMIN;
    }
    if (originalType === TYPE_NORMAL) {
      return osAccount.OsAccountType.NORMAL;
    }
    return osAccount.OsAccountType.GUEST;
  }

  refreshCurrentAccount(): void {
    let currentAccount: IUserData | undefined = accountMap?.get(mCurrentUserId);
    if (!!currentAccount && this.isPageShow) {
      if (!!currentAccount.userIconPath) {
        this.userImage = currentAccount.userIconPath;
      }
      if (!!currentAccount.userName) {
        this.userName = currentAccount.userName;
      }
      log.showInfo('begin to storage userName and userIconPath.');
      AppStorage.setOrCreate('userImage', this.userImage);
      AppStorage.setOrCreate('userName', this.userName);
    }
  }

  setPageShow(isShow: boolean): void {
    this.isPageShow = isShow;
  }
  
  activateWith(toAccountId: number,freezeTime?: number){
    osAccount.getAccountManager().activateOsAccount(toAccountId).then(() => {
        this.retryCount = 0;
        log.showInfo(`activateOsAccount: ${toAccountId}`);
        setTimeout(() => {
        log.showInfo(`accountSwitch change to: ${toAccountId}`);
        AppStorage.setOrCreate('accountSwitch', false);
        }, 5000);
        this.targetUser = INVALID_USER;
    }).catch((error: BusinessError) => {
        if(error.code === 12300010 && this.retryCount < MAX_RETRY){
            this.retryCount++;
            setTimeout(()=>{
                this.activateWith(toAccountId)
            }, 1000)
        } else {
            AppStorage.setOrCreate('accountSwitch', false);
            log.error('onUserSwitch activateOsAccount error');
        }
    });
  }
 
  onUserSwitch(toAccountId: number, freezeTime?: number): void {
    log.showInfo(`receive auth ${toAccountId} callback, will active other user ${toAccountId}, cost time ${Date.now() - this.startTime}ms`);
    try {
      log.showInfo(`onUserSwitch, start to active other user ${toAccountId}`);
      freezeTime = freezeTime ?? FREEZE_TIME;
      this.activateWith(toAccountId, freezeTime);
    } catch (error) {
      log.showError('onUserSwitch failed');
    }
    AppStorage.setOrCreate('accountSwitch', true);
  }

  clearUserInfo(): void {
    AppStorage.setOrCreate('lockStatus', 0);
    AppStorage.setOrCreate('currentUserItem', '');
    AppStorage.setOrCreate('passwordType', '');
    AppStorage.setOrCreate('userImage', '');
    AppStorage.setOrCreate('userName', '');
  }

  onAccountSwitch(toAccountId: number, callback: AsyncCallback<void>): void {
    log.showInfo(`onAccountSwitch: ${toAccountId}`);
    try {
      osAccount.getAccountManager().activateOsAccount(toAccountId, callback);
    } catch (error) {
      log.showError('onAccountSwitch failed');
    }
  }

  createUserAccount(name: string, type: osAccount.OsAccountType): Promise<osAccount.OsAccountInfo> {
    try {
      return osAccount.getAccountManager().createOsAccount(name, type);
    } catch (error) {
      log.showError('createUserAccount failed');
      return Promise.reject();
    }
  }

  numberToUint8Array(data: number): Uint8Array {
    const buffer = new ArrayBuffer(4);
    const dataview = new DataView(buffer);
    dataview.setUint32(0, data, true);

    return new Uint8Array(buffer);
  }
  /**
   * auth psd
   *
   * @param challenge challenge
   * @param authType authType
   * @param authLevel authLevel
   * @param resultCallback result callback
   * @param acquireInfoCallback acquire info callback
   */
  async authUser(challenge: number, authType: osAccount.AuthType, authLevel: number, resultCallback: Function,
    acquireInfoCallback?: (module: number, acquire: number, extraJsonInfo: IAMAuthExtraInfo) => void): Promise<Uint8Array> {
    if (!this.isActiveUserIdInit) {
      let activeIds: Array<number> = await osAccount.getAccountManager().getActivatedOsAccountLocalIds();
      if (ArrayUtils.isEmpty(activeIds)) {
        log.showError('AccountLocalIds is null');
        return Promise.reject();
      }
      mCurrentUserId = activeIds[0];
      this.isActiveUserIdInit = true;
    }
    let authOptions = this.getAuthOptions(mCurrentUserId);
    let toAccountId = mCurrentUserId;
    log.showWarn(`AuthManagerAuth start: userId ${toAccountId} challenge ${challenge}, authType = ${authType}`);
    try {
      SpecificScreenLockStateManager.setIsAuthResponded(false, authType);
      return this.userAuthManager.auth(this.numberToUint8Array(challenge), authType, authLevel, authOptions, {
        onResult: (result: number, extraInfo: osAccount.AuthResult) => {
          log.showWarn('AuthManagerAuth onResult end');
          SpecificScreenLockStateManager.setIsAuthResponded(true, authType);
          this.authOnResult(result, extraInfo, resultCallback);
        },
        onAcquireInfo: (moduleId: number, acquire: number, extraInfo: Uint8Array) => {
          this.authOnAcquireInfo(moduleId, acquire, extraInfo, acquireInfoCallback, authType);
        }
      });
    } catch (err) {
      log.showError('AuthManagerAuth error');
      SpecificScreenLockStateManager.setIsAuthResponded(true, authType);
      return Promise.reject();
    }
  }

  private authOnResult(result: number, extraInfo: osAccount.AuthResult, resultCallback: Function): void {
    log.showInfo(`authUser UserAuthManager.authUser onResult(${result}), accountId= ${extraInfo.accountId},
      pinValidityPeriod :${extraInfo.pinValidityPeriod}`);
    // 存储认证有效期，进入桌面时读取，通知用户更新。
    if (extraInfo?.pinValidityPeriod) {
      AppStorage.setOrCreate('pinValidityPeriod', extraInfo.pinValidityPeriod);
    }
    this.handlePsdExpire(result, extraInfo);
    resultCallback(result, extraInfo);
  }

  private authOnAcquireInfo(moduleId: number, acquire: number, extraInfo: Uint8Array,
    acquireInfoCallback: Function, authType: osAccount.AuthType): void {
    log.showDebug(`authUser onAcquireInfo, moduleId is ${moduleId}, acquire is ${acquire}`);
    try {
      if (!acquireInfoCallback) {
        return;
      }
      if (!extraInfo || extraInfo.length === 0) {
        log.showDebug('extraInfo is not exist');
        acquireInfoCallback(moduleId, acquire, null);
        return;
      }
      let extraJsonInfo: IAMAuthExtraInfo = CommonUtil.uint8ArrayToJson(extraInfo) as IAMAuthExtraInfo;
      if (ObjUtil.isInvalid(extraJsonInfo) || ObjUtil.isInvalid(extraJsonInfo?.authResult)) {
        log.showDebug('extraJsonInfo is not meet the requirements');
        acquireInfoCallback(moduleId, acquire, null);
        return;
      }
      this.changeFingerprintVerifyState(extraJsonInfo, moduleId);
      if (extraJsonInfo?.authResult === 0 && this.needSwitchUser(extraJsonInfo?.userId)) {
        this.handleUserSwitch(authType, extraJsonInfo);
      } else {
        acquireInfoCallback(moduleId, acquire, extraJsonInfo);
      }
    } catch (e) {
      log.showError('authUser parse acquire info fail, error');
    }
  }

  private changeFingerprintVerifyState(extraJsonInfo: IAMAuthExtraInfo, moduleId: number): void {
    if (extraJsonInfo?.authResult === 0 && moduleId === AuthType.FINGERPRINT) {
      AppStorage.setOrCreate('fingerprintVerifyState', FingerprintVerifyState.VERIFYING);
    }
  }

  /**
   * 获取密码或指纹切换目标用户的ID
   *
   * @returns user id
   */
  public getSwitchTargetUserId(): number {
    let isAccountSwitch: boolean = AppStorage.get<boolean>('accountSwitch') as boolean;
    if (!isAccountSwitch) {
      return INVALID_USER;
    }
    return this.targetUser;
  }

  private handleUserSwitch(authType: osAccount.AuthType, extraJsonInfo: IAMAuthExtraInfo): void {
    let isAccountSwitch: boolean = AppStorage.get<boolean>('accountSwitch') as boolean;
    log.showInfo(`isAccountSwitch is ${isAccountSwitch}`);
    if (!isAccountSwitch) {
      if (!this.isUserIdValid(extraJsonInfo?.userId)) {
        log.showInfo('UserSwitch, authUserId is not exist');
        return;
      }
      this.targetUser = extraJsonInfo?.userId;
      this.onUserSwitch(extraJsonInfo?.userId);
    }
  }

  public handlePsdExpire(result: number, extraInfo: osAccount.AuthResult): void {
    if (result === 0 && extraInfo?.pinValidityPeriod === 0) {
      HiSysEventUtil.userPinTimeAuth(PIN_VALIDITY_FLAG);
      log.showInfo('auth User , pin has expired');
      AppStorage.setOrCreate('isPinAvailable', false);
    } else if (result === 0 && extraInfo?.pinValidityPeriod === PIN_VALIDITY_FLAG) {
      HiSysEventUtil.userPinTimeAuth(0);
    } else if (result === 0 && extraInfo?.pinValidityPeriod && extraInfo?.pinValidityPeriod > 0) {
      HiSysEventUtil.userPinTimeAuth(extraInfo?.pinValidityPeriod);
    } else {
      log.showInfo('auth User pin , not handle');
    }
  }

  /**
   * Cancel Authentication
   *
   * @param contextId Authentication context ID.
   */
  public cancelAuth(type: string, contextId: Uint8Array, callback?: Callback<void>): void {
    log.showWarn(`AuthManagerCancelAuth start: ${type}`);
    try {
      this.userAuthManager.cancelAuth(contextId);
      log.showWarn('AuthManagerCancelAuth end');
      if (callback) {
        callback();
      }
    } catch (error) {
      log.showError(`AuthManagerCancelAuth error ${error.code}`);
      if (callback) {
        callback();
      }
    }
  }

  /**
   * Obtaining Fingerprint Component Information
   *
   * @param callback callback
   */
  public async getSensorProperty(callback: Function, errorCallback?: (err: Error) => void): Promise<void> {
    log.showInfo('getSensorProperty start.');
    let request: osAccount.GetPropertyRequest = {
      'authType': osAccount.AuthType.FINGERPRINT,
      'keys': [GetPropertyType.SENSOR_INFO]
    };
    try {
      this.userAuthManager.getProperty(request).then((properties) => {
        log.showInfo(`getSensorProperty properties ${properties.result}`);
        callback(properties);
      }).catch((err: BusinessError) => {
        log.showError('getSensorProperty error');
        errorCallback?.(err);
      });
    } catch (err) {
      log.showError('getSensorProperty exception error');
      errorCallback?.(err);
    }
  }

  /**
   * Obtaining Authentication Information
   *
   * @param authType Authentication type to be queried.
   * @param callback Callback function
   */
  public async getAuthInfo(authType: osAccount.AuthType, callback: Function, errorCallback?: (err: Error) => void) : Promise<void> {
    log.showDebug(`getAuthInfo param: authType is ${authType}`);
    try {
      await this.userIdentityManager?.getAuthInfo(authType).then((enrolledCredInfoArray) => {
        log.showDebug('getAuthInfo, the enrolledCredInfoArray');
        callback(enrolledCredInfoArray);
      });
    } catch (error) {
      log.showError('getAuthInfo failed');
      errorCallback?.(error);
    }
  }

  public loadFaceUnlockEnv(callback: Callback<void>): void {
    log.showInfo('loadFaceUnlockEnv start');
    let loadRequest: osAccount.SetPropertyRequest = {
      authType: osAccount.AuthType.FACE,
      key: osAccount.SetPropertyType.INIT_ALGORITHM,
      setInfo: this.stringToUint8Array(JSON.stringify({
        'operation': 'init',
        'caller': 'systemui'
      }))
    };
    try {
      this.userAuthManager.setProperty(loadRequest, (err, data) => {
        log.showInfo('loadFaceUnlockEnv end');
        if (err) {
          log.showError('unLoadFaceUnlockEnv error');
          return;
        }
        callback();
      });
    } catch (error) {
      log.showError('unLoadFaceUnlockEnv exception');
    }
  }

  public unLoadFaceUnlockEnv(callback: Callback<void>): void {
    log.showInfo('unLoadFaceUnlockEnv start');
    let unloadRequest: osAccount.SetPropertyRequest = {
      authType: osAccount.AuthType.FACE,
      key: SetPropertyType.INIT_ALGORITHM,
      setInfo: this.stringToUint8Array(JSON.stringify({
        'operation': 'uninit',
        'caller': 'systemui'
      }))
    };
    try {
      this.userAuthManager.setProperty(unloadRequest, (err, data) => {
        log.showInfo('unLoadFaceUnlockEnv end');
        if (err) {
          log.showError('unLoadFaceUnlockEnv error');
          return;
        }
        callback();
      });
    } catch (error) {
      log.showError('unLoadFaceUnlockEnv exception error');
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

  private needSwitchUser(toAccountId: number): boolean {
    this.startTime = Date.now();
    log.showWarn(`receive auth ${toAccountId} callback`);
    privacySpaceManager.isEnterPrivacySpace(toAccountId);
    if (!toAccountId) {
      log.showError(`enterPrivacySpace userId is undefined`);
      return false;
    }
    let curUsr = this.getCurrentUserId();
    log.showInfo(`currentUser: ${curUsr}`);
    if (toAccountId === curUsr) {
      return false;
    }
    return true;
  }

  private getAuthOptions(userId: number): osAccount.AuthOptions {
    // 丢失模式和孩童模式不能进入隐私空间
    let authIntent: number = this.isChildModule() || KeyguardStatusService.isMode(KeyGuardMode.LOST_MODE) ?
    AuthIntentType.UNLOCK_CURRENT_ONLY : osAccount.AuthIntent.UNLOCK;
    let authOptions: osAccount.AuthOptions = {
      accountId: userId,
      authIntent: authIntent,
    };
    return authOptions;
  }

  /**
   * Obtaining Authentication Information
   *
   * @param callback Callback function
   */
  public async getAuthType(callback: Callback<osAccount.EnrolledCredInfo[]>) : Promise<void> {
    log.showInfo('getAuthType');
    try {
      this.userIdentityManager?.getAuthInfo().then((enrolledCredInfoArray) => {
        log.showInfo('getAuthType, the enrolledCredInfoArray');
        callback(enrolledCredInfoArray);
      });
    } catch (error) {
      log.showError('getAuthType failed');
    }
  }

  /**
   * get psd type
   *
   * @param authType authType
   * @param callback callback
   */
  async getAuthProperty(authType: osAccount.AuthType, callback: Function): Promise<void> {
    log.showInfo(`getAuthProperty start: authType ${authType}`);
    let keyArray = [GetPropertyType.AUTH_SUB_TYPE, GetPropertyType.REMAIN_TIMES, GetPropertyType.FREEZING_TIME];
    let request: osAccount.GetPropertyRequest = {
      'authType': authType,
      'keys': keyArray,
      'accountId': mCurrentUserId
    };
    try {
      await this.userAuthManager.getProperty(request).then((properties) => {
        log.showInfo('getAuthProperty end');
        callback(properties);
      }).catch((err: BusinessError) => {
        callback({ authSubType: AuthSubType.PIN_SIX });
        log.showError('getAuthProperty error');
      });
    } catch (err) {
      log.showError('getAuthProperty exception error');
    }
  }

  /**
   * register pwd input event
   *
   * @param password password
   */
  registerPWDInputer(password: string): Promise<void> {
    log.showInfo('registerPWDInputer');
    let result = !password ? this.registerInputerWithoutPWD() : this.registerInputer(password);
    if (result) {
      return Promise.resolve();
    } else {
      return Promise.reject();
    }
  }

  registerPINSIXInputer(password: string): void {
    log.showInfo('registerPINSIXInputer');
    try {
      this.password = password;
      let textEncoder = new util.TextEncoder();
      let uint8PW = textEncoder.encode(password);
      this.inputData?.onSetData(this.passType, uint8PW);
    } catch (e) {
      this.cleanPassword();
      log.showError('registerPINSIXInputer error');
    }
  }

  /**
   * 清理锁屏密码
   */
  cleanPassword(): void {
    this.password = '';
  }

  /**
   * register pwd input event
   *
   * @param password password
   */
  private registerInputer(password: string): boolean {
    log.showWarn('registerInputer start');
    let result = false;
    try {
      result = Boolean(this.pinAuthManager.registerInputer({
        onGetData: (passType, inputData) => {
          log.showInfo(`registerInputer onSetData passType:${passType}`);
          let textEncoder = new util.TextEncoder();
          let uint8PW = textEncoder.encode(password);
          inputData.onSetData(passType, uint8PW);
        }
      }));
    } catch (e) {
      log.error('registerInputer error');
    }
    log.showWarn(`registerInputer end. result:${result}`);
    return result;
  }

  /**
   * register pwd input event
   *
   * @param password password
   */
  private registerInputerWithoutPWD(): boolean {
    log.showWarn('registerInputerWithoutPWD start');
    let result = false;
    try {
      result = Boolean(this.pinAuthManager.registerInputer({
        onGetData: (passType, inputData) => {
          this.onGetData(passType, inputData);
        }
      }));
    } catch (e) {
      log.error('registerInputerWithoutPWD error');
    }
    log.showWarn(`registerInputerWithoutPWD end. result: ${result}`);
    return result;
  }

  private onGetData(passType: osAccount.AuthSubType, inputData: osAccount.IInputData): void {
    try {
      log.showInfo(`registerInputerWithoutPWD onSetData passType:${passType}`);
      if (!this.password) {
        log.showInfo('registerInputerWithoutPWD without password');
        this.passType = passType;
        this.inputData = inputData;
      } else {
        log.showInfo('registerInputerWithoutPWD with password');
        let textEncoder = new util.TextEncoder();
        let uint8PW = textEncoder.encode(this.password);
        // 有隐私空间的时候的第二次密码下传
        inputData.onSetData(passType, uint8PW);
      }
    } catch (e) {
      log.error('onGetData error');
    }
  }

  /**
   * unregister pwd input event
   */
  unregisterInputer(): void {
    try {
      log.showWarn('unregisterInputer start');
      this.pinAuthManager.unregisterInputer();
      log.showWarn('unregisterInputer end');
    } catch (error) {
      log.showError('unregisterInputer error');
    }
  }

  /**
   * register domain pwd input event
   *
   * @param password password
   */
  async registerDomainPWDInputer(password: string): Promise<void> {
    log.showInfo('registerDomainPWDInputer');
    let authType = osAccount.AuthType.DOMAIN;
    try {
      osAccount.InputerManager.registerInputer(authType, {
        onGetData: (authSubType, inputData) => {
          let textEncoder = new util.TextEncoder();
          let uint8PW = textEncoder.encode(password);
          log.showInfo(`registerDomainInputer onSetData passType:${authSubType}, registerDomainInputer onSetData call`);
          inputData.onSetData(authSubType, uint8PW);
        }
      });
    } catch (error) {
      log.error('registerDomainPWDInputer registerInputer error', error);
    }
  }

  /**
   * unregister domain pwd input event
   */
  unregisterDomainInputer(): void {
    log.showInfo('unregisterDomainInputer');
    let authType = osAccount.AuthType.DOMAIN;
    try {
      osAccount.InputerManager.unregisterInputer(authType);
    } catch (error) {
      log.error('unregisterDomainInputer unregisterInputer error');
    }
  }

  /**
   * finish model
   */
  modelFinish(): void {
    log.showInfo('start modelFinish');
  }

  /**
   * 用户ID是否有效
   *
   * @param userId 用户ID
   * @returns boolean 是否有效
   */
  public isUserIdValid(userId: number): boolean {
    if (ObjUtil.isInvalid(userId)) {
      return false;
    }
    let accountList: IUserData[] | undefined = AppStorage.get('userList');
    let isValidResult = false;
    accountList?.forEach((accountItem, index) => {
      if (accountItem.userId === userId) {
        isValidResult = true;
      }
    });
    return isValidResult;
  }

  /**
   * 是否是孩童模式
   * @returns
   */
  public isChildModule(): boolean {
    const isChildModule: boolean = AppStorage.get<boolean>(CHILD_MODULE) as boolean;
    log.showInfo(`isChildModule: ${isChildModule}`);
    return isChildModule;
  }

  /**
   * 是否是主用户
   * @returns
   */
  public isDefaultUser(): boolean {
    return this.getCurrentUserId() === DEFAULT_USER;
  }

  /**
   * 获取当前用户的用户ID
   * @returns number: 当前用户的用户ID
   */
  getCurrentUserId(): number {
    return mCurrentUserId;
  }

  /**
   * 获取当前的前台用户ID
   * @returns number: 前台用户ID
   */
  getForegroundUserId(): number {
    return mForegroundUserId;
  }

  /**
   * 更新当前的前台用户ID
   */
  updateForegroundUserInfo(): void {
    osAccount.getAccountManager().getForegroundOsAccountLocalId().then((userId: number) => {
      mForegroundUserId = userId;
    });
  }
  getUserData(): IUserData | undefined {
    let userId: number = this.osAccountSwitchEventData.toAccountId;
    let accountList: IUserData[] | undefined = AppStorage.get('userList')
    if (accountList) {
      for (let user of accountList) {
        if (user.userId === userId) {
          return user;
        }
      }
    }
    return undefined;
  }

  /**
   * 获取数据上报时隐私空间切换模式
   * @returns
   */
  public getSwitchMode(): string {
    return this.getCurrentUserId() === privacySpaceManager.privateUser ? 'toPrivacy' : 'toMain';
  }

  /**
   * 文件加密
   * @param
   */
  public fileEncryption(userId?: number): void {
    let targetState = userId ?? this.getCurrentUserId();
    log.showInfo(`fileEncryption accountId: ${targetState}`);
    try {
      keyManager.deactivateUserKey(targetState);
      log.showInfo('fileEncryption success');
    } catch (error) {
      log.showError(`fileEncryption deactivateUserKey ${targetState} failed. code ${error.code}`);
    }
  }
}

let accountsModel = SingletonHelper.getInstance(AccountsModel, TAG);

export default accountsModel as AccountsModel;
