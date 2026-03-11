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

import { BusinessError } from '@ohos.base';
import dataShare from '@ohos.data.dataShare';
import { Context } from '@kit.AbilityKit';
import settings from '@ohos.settings';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import type ServiceExtensionContext from 'application/ServiceExtensionContext';
import { obtainLocalEvent } from '@ohos/frameworkwrapper';
import { SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants';
import { sEventManager } from '@ohos/frameworkwrapper';
import { SingletonHelper } from '@ohos/basicutils';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { DomainName, LogDomain, LogHelper } from '@ohos/basicutils';
import { ADMIN_USERID, BaseOobeManager } from './BaseOobeManager';
import osAccount from '@ohos.account.osAccount';
import { HiSysEventUtil } from '@ohos/frameworkwrapper';
import sSCBOtaManager from './SCBOtaManager';
import sTrustListOobeManager from './trustlist/TrustListOobeManager';
import sPrivateOobeManager from './PrivateOobeManager';
import { OobePreferences } from './preferences/OobePreferences';
import { checkOobeSettingsDataByTaskpool } from './preferences/OobeTask';
import { TraceUtil } from '@ohos/basicutils';
import { TaskpoolUtil } from '@ohos/basicutils';
import { commonBundleManager } from '@ohos/frameworkwrapper';
import { ExtAppConstants } from '@ohos/commonconstants';

export const OOBE_CHANGE_EVENT = 'Oobe_Change_Event';

const TAG = 'SCBOobeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const SETTINGS_DATA_URI = 'datashare:///com.ohos.settingsdata.DataAbility';
const SETTINGS_DATA_QUERY_URI = 'datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=';
const RETRY_INTERVAL_MS: number = 1000; // retry interval
const FIRST_RETRY_TIMES: number = 1;
const KEY_DEVICE_PROVISIONED = SettingsKeyConstants.DEVICE_PROVISIONED;

enum AuthType {
  //Authentication type pin.
  PIN = 1,
  //Authentication type pin.
  DOMAIN = 1024
}

interface GetAuthInfoOptions {
  authType?: AuthType;
  accountId?: number;
}

/**
 * 开机向导管理类（不含OTA）
 */
export class SCBOobeManager extends BaseOobeManager {
  private isOobeEnable: boolean = false;
  private isReadyOfInit: boolean = false;
  private isReadyOfSwitchUser: boolean = false;
  // 防止重复拉起
  private isOobeStart: boolean = false;
  private userAuthManager = new osAccount.UserIdentityManager();
  private isScreenlockReady: boolean = false;

  public async init(context: ServiceExtensionContext): Promise<void> {
    TraceUtil.startTrace(DomainName.SCB, 'SCBOobeManager');
    log.showInfo('init start');
    this.context = context;
    await this.initDeviceProvisioned();
    log.showInfo('init end');
    TraceUtil.endTrace(DomainName.SCB, 'SCBOobeManager');
  }

  private async initDeviceProvisioned(): Promise<void> {
    if (await OobePreferences.getInstance().hasValue(KEY_DEVICE_PROVISIONED)) {
      // device_provisioned在SP中有值
      let provisionedSp = await OobePreferences.getInstance().getValue(KEY_DEVICE_PROVISIONED, SettingsConstants.OOBE_STATUS_OFF) as string;
      log.showInfo('getDeviceProvisioned from sp. provisionedSp: %{public}s', provisionedSp);
      await this.startOobeAfterInit(provisionedSp);

      settings.getValue(this.context as Context, KEY_DEVICE_PROVISIONED).then((res: string) => {
        res = res ?? '0';
        log.showInfo('SettingsValue: %{public}s provisioned: %{public}s', res, provisionedSp);
        if (provisionedSp !== res) {
          log.showWarn('SettingsValue and provisioned not equal,will startifneed by %{public}s', res);
          HiSysEventUtil.reportSkipOOBE(SettingsKeyConstants.DEVICE_PROVISIONED, res);
          this.startOobeAfterInit(res);
          OobePreferences.getInstance().setValue(KEY_DEVICE_PROVISIONED, res);
        }
      }).catch((err: BusinessError) => {
        log.showError('settings getValue KEY_DEVICE_PROVISIONED error:' + err);
        this.startOobeAfterInit(SettingsConstants.OOBE_STATUS_OFF);
        OobePreferences.getInstance().setValue(KEY_DEVICE_PROVISIONED, SettingsConstants.OOBE_STATUS_OFF);
      });
    } else {
      let provisioned = await this.getSettingsValue(KEY_DEVICE_PROVISIONED, SettingsConstants.OOBE_STATUS_OFF);
      log.showInfo('getDeviceProvisioned from settingsdata. provisioned: %{public}s', provisioned);
      await this.startOobeAfterInit(provisioned);

      // 优化启动耗时：把从settingsdata查到的device_provisioned，写入SP(不需要await)
      OobePreferences.getInstance().setValue(KEY_DEVICE_PROVISIONED, provisioned);
    }
  }

  private async startOobeAfterInit(provisioned: string): Promise<void> {
    this.isOobeEnable = provisioned !== SettingsConstants.OOBE_STATUS_ON && await this.getOobeEnableByBms();
    log.showInfo('init ok, provisioned: %{public}s, isOobeEnable: %{public}s', provisioned, this.isOobeEnable);
    this.isReadyOfInit = true;
    this.startOobeIfNeed();
  }

  // 从settings的secure表中获取子用户是否走完向导
  private getOobeEnableBySecure(): boolean {
    let userSetupComplete: string = sSettingsUtil.getSecureValue(SettingsKeyConstants.USER_SETUP_COMPLETE, SettingsConstants.OOBE_STATUS_OFF, this.context);
    log.showInfo('getOobeEnableBySecure user[%{public}d] user_setup_complete is %{public}s', this.spaceNumber, userSetupComplete);
    return userSetupComplete === SettingsConstants.OOBE_STATUS_OFF;
  }

  /**
   * 检查UIAbility是否在白名单内
   * @param bundleName 应用的bundleName
   * @param abilityName 应用的abilityName
   * @param moduleName 应用的moduleName
   *
   * @return {boolean} true-在白名单内
   */
  public isTrustlistForWms(bundleName: string, moduleName: string, abilityName: string): boolean {
    return sTrustListOobeManager.isTrustlistForWms(bundleName, moduleName, abilityName);
  }

  /**
   * 判断当前是否在OOBE阶段(推荐)
   *
   * @return {boolean} true-在OOBE阶段；false-不在OOBE阶段
   */
  public isOobeActivated(): boolean {
    if (this.isReadyOfInit === false) {
      // 不能频繁打印，启动优化后，用于判断时序是否OK
      log.warn('get oobe status is too early for init isOobeActivated not finishd');
    }
    return this.isOobeEnable || sSCBOtaManager.isOtaEnable();
  }

  /**
   * (一般不使用)(不含OTA升级拉起的OOBE)
   *
   * @return {boolean} true-在OOBE阶段，需要霸屏等；false-不在OOBE阶段
   */
  public isEnable(): boolean {
    if (this.isReadyOfInit === false) {
      // 不能频繁打印，启动优化后，用于判断时序是否OK
      log.warn('get oobe status is too early for init isEnable not finishd');
    }
    return this.isOobeEnable;
  }

  /**
   * 提供给外部更新OOBE阶段的能力
   *
   * @param isOobeEnable 是否oobe阶段
   */
  public updateOobeEnable(isOobeEnable: boolean): void {
    this.isOobeEnable = isOobeEnable;
  }

  /**
   * 拉起settingsdata，并查询key
   *
   * @param key key
   * @param defValue 默认值
   * @returns value
   */
  private async getSettingsValue(key: string, defValue: string): Promise<string> {
    log.showInfo('getSettingsValue start');
    let value: string = defValue;
    try {
      let dsHelper: dataShare.DataShareHelper = await dataShare.createDataShareHelper(
        this.context as ServiceExtensionContext, SETTINGS_DATA_URI);
      if (!dsHelper) {
        log.showWarn('getSettingsValue %{public}s dataSharePredicates: is null', key);
        return value;
      }
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo('KEYWORD', key);
      let queryUri: string = SETTINGS_DATA_QUERY_URI + key;
      let result = await dsHelper.query(queryUri, predicates, ['*']);
      log.showInfo('getSettingsValue %{public}s query end, count: %{public}d', key, result?.rowCount);
      if (!result || result.rowCount === 0) {
        log.showWarn('getSettingsValue %{public}s result is null or empty', key);
        result?.close();
        return value;
      }
      result.goToFirstRow();
      value = result.getString(result.getColumnIndex('VALUE'));
      result.close();
      if (CheckEmptyUtils.checkStrIsEmpty(value)) {
        log.showWarn('getSettingsValue %{public}s return defValue %{public}s', key, value);
        return defValue;
      }
      log.showInfo('getSettingsValue %{public}s return value %{public}s', key, value);
      return value;
    } catch (err) {
      log.error('getSettingsValue catch error:', err);
    }
    return value;
  }

  /**
   * 从BMS那里获取OOBE的安装和禁用状态
   */
  private async getOobeEnableByBms(): Promise<boolean> {
    if (!(await this.isStartupGuideInstalled())) {
      log.showError('getOobeEnableByBms oobe not install');
      return false;
    }
    await commonBundleManager.setApplicationEnabled(ExtAppConstants.PKG_OOBE, true);
    await super.setOobeMainAbilityEnable(true);
    if (!(await this.isOobeMainAbilityEnable())) {
      // 拉起禁用状态的OOBE，会导致白屏。因此拉起前，先判断
      log.showWarn('getOobeStatus oobe ability is disabled');
      return false;
    }
    return true;
  }

  private async registerOobeSettings(): Promise<void> {
    this.uri = await this.getSecureUri(SettingsKeyConstants.USER_SETUP_COMPLETE, this.spaceNumber);
    this.registerSettings(FIRST_RETRY_TIMES);
  }

  private async registerSettings(retryTimes: number): Promise<void> {
    log.showInfo(`registerSettings retry times:${retryTimes}`);
    try {
      dataShare.createDataShareHelper(this.context, this.uri).then((dataShareHelper) => {
        if (!dataShareHelper) {
          log.error('registerSettings init helper failed');
          setTimeout(this.registerSettings.bind(this, retryTimes++), RETRY_INTERVAL_MS);
          return;
        }
        if (!this.maybeFinishOobe()) {
          log.info('registerSettings oobe settings data is finished');
          return;
        }
        log.info('registerSettings init helper success');
        this.helper = dataShareHelper;
        dataShareHelper.on('dataChange', this.uri, this.maybeFinishOobe.bind(this));
      }).catch((error: BusinessError) => {
        log.error('registerSettings init helper error:', error);
        setTimeout(this.registerSettings.bind(this, retryTimes++), RETRY_INTERVAL_MS);
      });
    } catch (error) {
      log.error('registerSettings init helper catch error:', error);
      setTimeout(this.registerSettings.bind(this, retryTimes++), RETRY_INTERVAL_MS);
    }
  }

  private maybeFinishOobe(): boolean {
    // 用户走完向导/跳过向导，先写入device_provisioned，后写入user_setup_complete。因此我们要监听user_setup_complete，恢复手势和霸屏
    this.isOobeEnable = this.getOobeEnableBySecure();
    log.showInfo('user[%{public}d] oobe settings data changed, isOobeEnable: %{public}s', this.spaceNumber, this.isOobeEnable);
    if (!this.isOobeEnable) {
      sEventManager.publish(obtainLocalEvent(OOBE_CHANGE_EVENT, this.isOobeEnable));
      this.finishOobe();
    }
    return this.isOobeEnable;
  }

  /**
   * 结束开机向导
   */
  protected finishOobe(): void {
    super.finishOobe();

    // 优化启动耗时：把从settingsdata查到的device_provisioned，写入SP(不需要await)
    let provisioned: string = sSettingsUtil.getValue(KEY_DEVICE_PROVISIONED, SettingsConstants.OOBE_STATUS_ON, this.context);
    OobePreferences.getInstance().setValue(KEY_DEVICE_PROVISIONED, provisioned);
  }

  /**
   * 切换用户后，拉起OOBE
   * */
  public async startOobeAfterSwitchUser(spaceNumber: number): Promise<void> {
    log.showInfo('startOobeAfterSwitchUser user[%{public}d] start', spaceNumber);
    this.spaceNumber = spaceNumber;
    this.isReadyOfSwitchUser = true;
    // 其他用户无密码直接拉起OOBE
    if (this.spaceNumber !== ADMIN_USERID) {
      let hasPassword: boolean = await this.hasPassword();
      log.showInfo(`startOobeAfterSwitchUser hasPassword: ${hasPassword}`);
      if (!hasPassword) {
        this.isScreenlockReady = true;
      }
    }
    this.startOobeIfNeed();
  }



  private async startOobeIfNeed(): Promise<void> {
    log.showInfo('startOobeIfNeed start');
    if (this.isReadyOfInit === false) {
      log.showInfo('startOobeIfNeed return for init is not ready');
      return;
    }
    if (this.isReadyOfSwitchUser === false) {
      log.showInfo('startOobeIfNeed return for switch user is not ready');
      return;
    }

    log.showInfo('startOobeIfNeed user[%{public}d] start', this.spaceNumber);
    if (this.spaceNumber !== ADMIN_USERID) {
      // 子用户
      this.isOobeEnable = this.getOobeEnableBySecure() && await this.getOobeEnableByBms();
    }

    if (!this.isOobeEnable) {
      log.showInfo('startOobeIfNeed user[%{public}d] return for isOobeEnable is false', this.spaceNumber);
      TaskpoolUtil.doTask(checkOobeSettingsDataByTaskpool, this.context);
      return;
    }

    if (await sPrivateOobeManager.isPrivateUserOobe(this.spaceNumber)) {
      log.showInfo('startOobeIfNeed user[%{public}d] return for private space', this.spaceNumber);
      this.isOobeEnable = false;
      return;
    }
    if (this.isOobeStart) {
      return;
    }

    // 为保证子用户进入场景先起锁屏再起OOBE，所以对除隐私空间以外的其他子用户，需要判断是否需要等待锁屏拉起
    if (!this.isScreenlockReady && this.spaceNumber !== ADMIN_USERID && !sPrivateOobeManager.getPrivateUserState()) {
      log.showInfo(`startOobeIfNeed isScreenlockReady: ${this.isScreenlockReady}, spaceNumber: ${this.spaceNumber}`);
      return;
    }

    await this.startOobe();
    this.registerOobeSettings();
    log.showInfo('startOobeIfNeed user[%{public}d] end', this.spaceNumber);
    this.isOobeStart = true;
  }

  public async startOobeAfterScreenLockReady(): Promise<void> {
    log.showInfo('startOobeAfterScreenLockReady start');
    this.isScreenlockReady = true;
    this.startOobeIfNeed();
  }

  private async hasPassword(): Promise<boolean> {
    let option: GetAuthInfoOptions = {
      accountId: this.spaceNumber
    };
    let hasPassword: boolean = false;
    try {
      await this.userAuthManager.getAuthInfo(option).then((enrolledCredInfoArray) => {
        log.showInfo(`enrolledCredInfoArray, lenth: ${enrolledCredInfoArray.length}`);
        hasPassword = enrolledCredInfoArray.length > 0;
      });
    } catch (err) {
      log.showError('getAuthProperty exception error');
    }
    return hasPassword;
  }

}

let sSCBOobeManager = SingletonHelper.getInstance(SCBOobeManager, TAG);

export default sSCBOobeManager as SCBOobeManager;