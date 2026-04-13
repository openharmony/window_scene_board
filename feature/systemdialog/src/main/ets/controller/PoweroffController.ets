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

import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { BusinessError, power, thermal, screenLock, settings } from '@kit.BasicServicesKit';
import osAccount from '@ohos.account.osAccount';
import CES from '@ohos.commonEventManager';
import { LogDomain, Logger, SingletonHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { LayoutUtils, XTLayoutType } from '@ohos/systemuicommon';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { userAuth } from '@kit.UserAuthenticationKit';
import { ResourceUtil } from '../common/ResourceUtil';
import PowerOffStyleConstants from '../common/PoweroffStyleConstants';
import { PowerOffSysEventUtil, ShutdownPanelState } from '../common/PowerOffSysEventUtil';

const TAG = 'Poweroff-Controller';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

class PoweroffController {
  public session?: UIExtensionContentSession;
  // 订阅息屏公共事件
  public subscribeScreenOffInfo: CES.CommonEventSubscribeInfo = {
    events: [
      CES.Support.COMMON_EVENT_SCREEN_OFF
    ]
  };
  // 订阅锁屏公共事件
  public subscribeScreenLockedInfo: CES.CommonEventSubscribeInfo = {
    events: [
      CES.Support.COMMON_EVENT_SCREEN_UNLOCKED,
    ]
  };

  private mSubscribers: Set<CES.CommonEventSubscriber> = new Set();
  /**
   * 关机验密认证对象
   */
  private userAuthInstance?: userAuth.UserAuthInstance;
  /**
   * 是否锁屏状态
   */
  private isScreenLocked: boolean = true;
  /**
   * 设备是否开启关机验密开关
   */
  private isEnablePowerOffPwdVerify: boolean = false;
  /**
   * 设备是否开启查找设备丢失模式
   */
  private isEnableDeviceRemoteLock: boolean = false;
  private timerId: number = -1;
  private isRequestSuccess: boolean = false;

  public setSession(session: UIExtensionContentSession): void {
    this.session = session;
  }

  /**
   * 关闭当前界面
   */
  public destroy(): void {
    log.showWarn(TAG, 'terminateSelf in file:PoweroffController>destroy');
    this.session?.terminateSelf();
    this.offUserAuth();
  }

  /**
   * 是否进入应急模式或热安全模式
   */
  public getEmergencyAndThermalSafeMode(): boolean {
    const curPowerMode = this.getPowerMode();
    const thermalLevel = this.getThermalLevel();
    // 是否进入应急模式
    const isEmergencyMode = curPowerMode === power.DevicePowerMode.MODE_EXTREME_POWER_SAVE;
    // 是否进入热安全模式
    const isThermalSafeMode = thermalLevel === thermal.ThermalLevel.ESCAPE;
    log.showInfo(TAG, `get emergency and thermal safe mode ${isEmergencyMode} ${isThermalSafeMode}`);
    return isEmergencyMode || isThermalSafeMode;
  }

  /**
   * 获取电源模式
   */
  private getPowerMode(): power.DevicePowerMode {
    let curPowerMode: power.DevicePowerMode = power.DevicePowerMode.MODE_NORMAL;
    try {
      curPowerMode = power.getPowerMode();
      log.showInfo(TAG, `getPowerMode ${curPowerMode}`);
    } catch (err) {
      log.showError(TAG, `get device power mode failed, error: ${err?.message}`);
    }
    return curPowerMode;
  }

  /**
   * 获取热档位信息
   */
  private getThermalLevel(): thermal.ThermalLevel {
    let level = thermal.ThermalLevel.NORMAL;
    try {
      level = thermal.getLevel();
      log.showInfo(TAG, `thermal level ${level}`);
    } catch (err) {
      log.showError(TAG, `get thermal level failed, error: ${err?.message}`);
    }
    return level;
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
        log.showInfo(TAG, `getOsAccountType success, osAccountType: ${osAccountType}`);
        callback(osAccountType === osAccount.OsAccountType.PRIVATE);
      }).catch(() => {
        log.showError(TAG, 'getOsAccountType error.');
      });
    } catch (error) {
      log.showError(TAG, `getOsAccountType failed. code ${error.code}`);
    }
  }

  /**
   * 是否是直板手机横屏模式
   */
  public isPhoneLandScape(): boolean {
    // Pad
    if (!DeviceHelper.isPhone()) {
      return false;
    }
    // 手机非横屏
    if (!DeviceHelper.isLandscape()) {
      return false;
    }
    // 超大屏
    if (DeviceHelper.isUltraScreenProduct()) {
      return LayoutUtils.getFoldDisplayMode() === XTLayoutType.F;
    }
    // 两折叠
    if (DeviceHelper.isLargeInFoldProduct()) {
      return !DeviceHelper.isFoldExpanded();
    }
    return true;
  }

  private registerScreenOffEvent(): void {
    CES.createSubscriber(this.subscribeScreenOffInfo).then((subscribe) => {
      try {
        CES.subscribe(subscribe, this.handleCommonEventCallback.bind(this));
        this.mSubscribers.add(subscribe);
        log.showInfo(TAG, 'register screen off subscribe success');
      } catch (err) {
        log.showError(TAG, 'register screen off subscribe try error', err);
      }
    }).catch((err: BusinessError) => {
      log.showError(TAG, 'register screen off createSubscriber error', err);
    });
  }

  private registerScreenLockedEvent(): void {
    CES.createSubscriber(this.subscribeScreenLockedInfo).then((subscribe) => {
      try {
        CES.subscribe(subscribe, this.handleCommonEventCallback.bind(this));
        this.mSubscribers.add(subscribe);
        log.showInfo(TAG, 'register screen locked subscribe success');
      } catch (err) {
        log.showError(TAG, 'register screen locked subscribe try error', err);
      }
    }).catch((err: BusinessError) => {
      log.showError(TAG, 'register screen locked createSubscriber error', err);
    });
  }

  private handleCommonEventCallback(err: BusinessError, data: CES.CommonEventData): void {
    if (err) {
      log.showError(TAG, 'rec event err: ', err);
    }
    log.showWarn(TAG, 'rec event:%{public}s', data?.event);
    if (data?.event === PowerOffStyleConstants.EVENT_SCREEN_UNLOCK) {
      this.isScreenLocked = false;
      return;
    }
    this.destroy();
  }

  public registerCommentEvent(): void {
    this.registerScreenOffEvent();
    this.registerScreenLockedEvent();
    this.getScreenLockState();
    this.getPowerOffPwdVerifyStatus();
    this.getDeviceRemoteLockStatus();
  }

  public unRegisterCommonEvent(): void {
    try {
      this.mSubscribers.forEach((subscriber) => CES.unsubscribe(subscriber));
    } catch (error) {
      log.showError(TAG, 'unregisterCommonEvent unsubscribe try error', error);
    }
    this.mSubscribers.clear();
  }

  /**
   * 查询设置数据
   */
  public getValueSyncByContext(context: Context, name: string, defValue: string, domainName: string): string {
    let value: string | null = null;
    try {
      value = settings.getValueSync(context, name, defValue, domainName);
    } catch (err) {
      log.error(TAG, `getValueSyncByContext error for ${name}`, err);
      return defValue;
    }
    return value;
  }

  /**
   * 查询设备开启关机验密开关状态，查询失败按关闭处理
   */
  private async getPowerOffPwdVerifyStatus(): Promise<void> {
    const dateKey = PowerOffStyleConstants.FIND_DEVICE_TURN_OFF_VERIFY_STATUS;
    const domainName = settings.domainName.DEVICE_SHARED;
    const value = this.getValueSyncByContext(ResourceUtil.context!, dateKey, '0', domainName);
    this.isEnablePowerOffPwdVerify = value === '1';
    log.showInfo(TAG, `isEnablePowerOffPwdVerify: ${this.isEnablePowerOffPwdVerify}`);
  }

  /**
   * 查询设备丢失模式状态，查询失败按关闭处理
   */
  private async getDeviceRemoteLockStatus(): Promise<void> {
    const dateKey = PowerOffStyleConstants.FIND_DEVICE_REMOTE_LOCK;
    const domainName = settings.domainName.USER_SECURITY;
    const value = this.getValueSyncByContext(ResourceUtil.context!, dateKey, '0', domainName);
    this.isEnableDeviceRemoteLock = value === '1';
    log.showInfo(TAG, `isEnableDeviceRemoteLock: ${this.isEnableDeviceRemoteLock}`);
  }

  /**
   * 查询锁屏状态，查询失败按已锁屏处理
   */
  private getScreenLockState(): void {
    try {
      this.isScreenLocked = screenLock.isLocked();
      log.showInfo(TAG, `isScreenLocked: ${this.isScreenLocked}`);
    } catch (err) {
      log.error(TAG, 'getScreenLockState error', err);
      this.isScreenLocked = true;
    }
  }

  /**
   * 拉起关机验密页面
   * @returns true = 未锁屏or未开启关机验密开关且未开启丢失模式or认证通过，可以执行关机
   *          false = 认证失败or取消认证or其他，不可执行关机
   */
  public async openUserAuthPage(): Promise<boolean> {
    log.showInfo(TAG, 'openUserAuthPage start');
    if (!this.isEnablePowerOffPwdVerify && !this.isEnableDeviceRemoteLock) {
      log.showWarn(TAG, 'disablePowerOffPwdVerify and disableDeviceRemoteLock');
      return true;
    }
    if (!this.isScreenLocked) {
      log.showWarn(TAG, 'is unlocked');
      return true;
    }

    // 请求拉起密码认证控件失败需重复拉起3次，3次都拉起失败则执行关机
    let retryTimes = 0;
    let isSuccess = true;
    while (retryTimes < PowerOffStyleConstants.USER_AUTH_MAX_RETRY_TIMES) {
      try {
        isSuccess = await this.onUserAuth();
        log.showInfo(TAG, `openUserAuthPage isSuccess: ${isSuccess}, retryTimes: ${retryTimes}`);
        break;
      } catch (err) {
        log.error(TAG, `openUserAuthPage error, retryTimes: ${retryTimes}`, err);
        retryTimes++;
      }
    }
    return isSuccess;
  }

  /**
   * 请求拉起密码认证控件
   */
  private onUserAuth(): Promise<boolean> {
    return new Promise((resolve, reject) => {
      try {
        log.showInfo(TAG, 'userAuth start');
        this.isRequestSuccess = false;
        this.setRequestTimeout(reject);

        const authParam: userAuth.AuthParam = this.createAuthParam();
        const widgetParam: userAuth.WidgetParam = {
          title: ' ',
        };
        this.userAuthInstance = userAuth.getUserAuthInstance(authParam, widgetParam);
        log.showInfo(TAG, 'getUserAuthInstance success');
        this.userAuthInstance.on('result', this.onAuthResultCallback(resolve));
        log.showInfo(TAG, 'userAuth on success');
        this.userAuthInstance.start();
        log.showInfo(TAG, 'userAuth start success');
        this.isRequestSuccess = true;

        PowerOffSysEventUtil.reportPowerOffEvent(PowerOffSysEventUtil.SHUTDOWN_PANEL,
          ShutdownPanelState.SHUTDOWN_USER_AUTH);
      } catch (err) {
        log.error(TAG, 'userAuth error', err);
        clearTimeout(this.timerId);
        this.timerId = setTimeout(() => { // 抛出异常后，等待100ms再重试
          reject(err);
        }, PowerOffStyleConstants.USER_AUTH_ERROR_TIMEOUT);
      }
    });
  }

  /**
   * 每次请求超时时长300ms，请求超时则认为请求失败
   */
  private setRequestTimeout(reject: (reason?: string) => void): void {
    clearTimeout(this.timerId);
    this.timerId = setTimeout(() => {
      log.showInfo(TAG, `isRequestSuccess ${this.isRequestSuccess}`);
      if (!this.isRequestSuccess) {
        this.offUserAuth();
        reject('userAuth request failed');
      }
    }, PowerOffStyleConstants.USER_AUTH_REQUEST_TIMEOUT);
  }

  private onAuthResultCallback(resolve: (value: boolean) => void): userAuth.IAuthCallback {
    return {
      onResult: (userAuthResult: userAuth.UserAuthResult): void => {
        log.showInfo(TAG, `userAuth result: ${userAuthResult.result}`);
        this.offUserAuth();
        // 认证成功 result = 12500000 | 用户未录入身份认证凭据 result = 12500010
        if (userAuthResult.result === userAuth.UserAuthResultCode.SUCCESS ||
          userAuthResult.result === userAuth.UserAuthResultCode.NOT_ENROLLED) {
          resolve(true);
          return;
        }
        resolve(false);
      }
    };
  }

  private createAuthParam(): userAuth.AuthParam {
    const rand: cryptoFramework.Random = cryptoFramework.createRandom();
    const len: number = 16;
    const randData: Uint8Array = rand?.generateRandomSync(len)?.data;
    return {
      challenge: randData,
      authType: [userAuth.UserAuthType.PIN],
      authTrustLevel: userAuth.AuthTrustLevel.ATL3,
    };
  }

  /**
   * 取消订阅用户身份认证结果
   */
  private offUserAuth(): void {
    if (this.userAuthInstance) {
      this.userAuthInstance.off('result');
      this.userAuthInstance = undefined;
    }
  }
}

export let poweroffController: PoweroffController = SingletonHelper.getInstance(PoweroffController, TAG);