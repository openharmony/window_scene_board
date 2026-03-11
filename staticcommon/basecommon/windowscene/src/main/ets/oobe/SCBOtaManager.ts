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

import dataShare from '@ohos.data.dataShare';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import sSCBOobeManager from './SCBOobeManager';
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import { AccountMgr } from '@ohos/frameworkwrapper';
import { CheckEmptyUtils, CommonUtils } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { obtainLocalEvent } from '@ohos/frameworkwrapper';
import { SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants';
import { sEventManager } from '@ohos/frameworkwrapper';
import { SingletonHelper } from '@ohos/basicutils';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { BaseOobeManager } from './BaseOobeManager';
import sPrivateOobeManager from './PrivateOobeManager';

export const OTA_OOBE_CHANGE_EVENT = 'Ota_Oobe_Change_Event';

const TAG = 'SCBOtaManager-OobeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const SETTINGS_DATAABILITY_URI = 'datashare:///com.ohos.settingsdata.DataAbility';
// PC上，OTA场景OOBE白名单拦截了用户设置的自启动的三方应用。新增一个系统参数来判断允不允许拉起应用
const SETTING_IF_STARTUP: string = 'persist.sys.abilityms.if_startup_ready';

export class SCBOtaManager extends BaseOobeManager {
  private isOtaOobeEnable: boolean = false;
  private currentVersion?: string;
  private firstStartOobeInOta: boolean = true;

  private async registerOtaSettings(): Promise<void> {
    try {
      this.uri = await this.getSecureUri(SettingsKeyConstants.IS_OTA_FINISHED);
      await this.getDataShareHelper(this.uri);
      if (!this.helper) {
        log.error('registerOtaSettings fail to create helper with silent uri');
        await this.getDataShareHelper(SETTINGS_DATAABILITY_URI);
      }
      log.showInfo(`init ota helper ${this.helper}`);
      this.helper?.on('dataChange', this.uri, () => {
        this.isOtaOobeEnable = this.getOtaOobeState();
        log.showInfo('registerOtaSettings ota change: %{public}s', this.isOtaOobeEnable);
        sEventManager.publish(obtainLocalEvent(OTA_OOBE_CHANGE_EVENT, this.isOtaOobeEnable));
        if (!this.isOtaOobeEnable) {
          this.finishOobe();
          this.resetIfStartup('true'); // 完成oobe，重置if_startup_ready为true
        }
      });
    } catch (err) {
      log.error('registerOtaSettings catch error:', err);
    }
  }

  private async getDataShareHelper(uri: string): Promise<void> {
    try {
      this.helper = await dataShare.createDataShareHelper(GlobalContext.getContext(), uri);
    } catch (err) {
      log.error('getDataShareHelper init helper catch error:', err);
    }
  }

  private getOtaOobeState(): boolean {
    let isOtaFinished = sSettingsUtil.getSecureValue(SettingsKeyConstants.IS_OTA_FINISHED, '');
    log.showInfo('getOtaOobeState ota is finished: %{public}s', isOtaFinished);
    return isOtaFinished === SettingsConstants.OTA_NOT_FINISHED;
  }

  public isOtaEnable(): boolean {
    return this.isOtaOobeEnable;
  }

  /**
   * 判断当前是否在OOBE阶段
   *
   * @return {boolean} true-在OOBE阶段，需要霸屏等；false-不在OOBE阶段
   */
  public isOobeActivated(): boolean {
    return sSCBOobeManager.isOobeActivated();
  }

  private async isMigrateClientNeedShow(): Promise<boolean> {
    let dseUri = 'datashare:///com.ohos.migrateclient/migrate_client_base/migrate_client/oobe_info?Proxy=false';
    let bundleName = 'com.ohos.migrateclient';
    try {
      let dsProxyHelper = await dataShare.createDataShareHelper(GlobalContext.getContext(), dseUri);
      if (!dsProxyHelper) {
        log.showWarn('isMigrateClientNeedShow dsProxyHelper is null');
        return false;
      }
      let predicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo('bundleName', bundleName);
      let result = await dsProxyHelper.query(dseUri, predicates, ['*']);
      log.showInfo('isMigrateClientNeedShow query end, count: %{public}d', result?.rowCount);
      if (!result || result.rowCount === 0) {
        log.showInfo('isMigrateClientNeedShow result is null or empty');
        result?.close();
        return false;
      }
      result.goToFirstRow();
      let ret = result.getString(result.getColumnIndex('isVisible')) === '1';
      result.close();
      log.showInfo('isMigrateClientNeedShow return value %{public}s', ret);
      return ret;
    } catch (err) {
      log.error('isMigrateClientNeedShow catch error:', err);
    }
    return false;
  }

  private async isOtaScene(): Promise<boolean> {
    if (!DeviceHelper.isPhoneOrPad() && !DeviceHelper.isPC()) {
      log.showInfo('the device is not phone, pad, pc or tv');
      return false;
    }
    if (sSCBOobeManager.isEnable()) {
      log.showInfo('oobe enable is true');
      return false;
    }
    if (!(await this.isStartupGuideInstalled())) {
      log.showWarn('startup guide not installed');
      return false;
    }
    let spaceNumber: number = await AccountMgr.getCurrentAccountId();
    this.spaceNumber = spaceNumber;
    log.showInfo('spaceNumber value is %{public}d', spaceNumber);
    let isOtaFinished: string = sSettingsUtil.getSecureValue(SettingsKeyConstants.IS_OTA_FINISHED, '');
    if (isOtaFinished === SettingsConstants.OTA_NOT_FINISHED) {
      log.showInfo('ota is not finished');
      return true;
    }
    let oldVersion: string = sSettingsUtil.getSecureValue(SettingsKeyConstants.BUILD_VERSION_RELEASE, '');
    this.saveOldVersion(oldVersion);
    if (CheckEmptyUtils.checkStrIsEmpty(oldVersion)) {
      log.showInfo('old version is empty');
      let isNeedShowMigrateClient = await this.isMigrateClientNeedShow();
      return isNeedShowMigrateClient;
    }
    let userSetupComplete: string = sSettingsUtil.getSecureValue(SettingsKeyConstants.USER_SETUP_COMPLETE, '');
    log.showInfo('userSetupComplete value is %{public}s, oldVersion is %{public}s', userSetupComplete, oldVersion);
    if (oldVersion !== this.currentVersion && userSetupComplete === SettingsConstants.USER_HAS_SETUP_COMPLETE) {
      if (await sPrivateOobeManager.isPrivateUserOobe(spaceNumber)) {
        log.showInfo('is private and  not need migrate');
        return false;
      }
      log.showInfo('version has changed');
      return true;
    }
    return false;
  }

  private prepareForOtaScene(): void {
    sSettingsUtil.setSecureValue(SettingsKeyConstants.IS_OTA_FINISHED, SettingsConstants.OTA_NOT_FINISHED);
    sSettingsUtil.setSecureValue(SettingsKeyConstants.BUILD_VERSION_RELEASE, this.currentVersion);
  }

  protected async beforeStartOobe(): Promise<void> {
    await super.beforeStartOobe();
    await this.registerOtaSettings();
    this.prepareForOtaScene();
  }

  private saveOldVersion(oldVersion: string): void {
    if (CheckEmptyUtils.checkStrIsEmpty(oldVersion)) {
      return;
    }
    let oldVerInDB = sSettingsUtil.getValue(SettingsKeyConstants.OTA_OLD_VERSION, '');
    if (CheckEmptyUtils.checkStrIsEmpty(oldVerInDB) || oldVerInDB.localeCompare(oldVersion) === 1) {
      sSettingsUtil.setValue(SettingsKeyConstants.OTA_OLD_VERSION, oldVersion);
    }
  }

  private resetIfStartup(value: string): void {
    if (!DeviceHelper.isPC()) {
      log.showError(`resetIfStartup is not pc, return`);
      return;
    }
    if (CommonUtils.isEmpty(value)) {
      log.showError(`resetIfStartup value is empty, return`);
      return;
    }
    try {
      systemParameterEnhance.set(SETTING_IF_STARTUP, value)
        .then(() => {
          log.showInfo(`systemParameterEnhance set key: ${SETTING_IF_STARTUP} value: ${value} success`);
        })
        .catch((error) => {
          log.showError(`systemParameterEnhance set key: ${SETTING_IF_STARTUP} value: ${value} error: ${error?.code}, ${error?.message}`);
        });
    } catch (err) {
      log.showError(`systemParameterEnhance set key: ${SETTING_IF_STARTUP} value: ${value} error: ${err?.code}, ${err?.message}`);
    }
  }

  public async startOobeForOta(): Promise<void> {
    if (!this.firstStartOobeInOta) {
      log.showInfo('not first in startOobeForOta');
      return;
    }
    this.firstStartOobeInOta = false;
    this.currentVersion = this.getDisplayVersion();
    let otaScene: boolean = await this.isOtaScene();

    log.showInfo('is in ota scene: %{public}s', otaScene);
    if (!otaScene) {
      log.showWarn('not in ota scene');
      return;
    }
    await this.setOobeMainAbilityEnable(true);
    let oobeAbilityEnable = await this.isOobeMainAbilityEnable();
    if (!oobeAbilityEnable) {
      log.showWarn('isOobeMainAbilityEnable false return');
      return;
    }
    this.isOtaOobeEnable = otaScene;
    this.resetIfStartup('false'); // ota升级拉起oobe前，设置if_startup_ready为false
    this.startOobe();
  }
}

let sSCBOtaManager = SingletonHelper.getInstance(SCBOtaManager, TAG);

export default sSCBOtaManager as SCBOtaManager;