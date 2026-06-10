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

import dataShare from '@ohos.data.dataShare';
import type common from '@ohos.app.ability.common';
import Settings from '@ohos.settings';
import osAccount from '@ohos.account.osAccount';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import Constants from '../model/Constants';

const TAG = 'utils.SettingsDataUtil: ';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 设置数据库工具类
 *
 * @since 2024-09-15
 */
export class SettingsDataUtils {
  public static readonly settingsDataUrl = 'datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=';
  public static readonly settingsDataUserUrl = 'datashare:///com.ohos.settingsdata/entry/settingsdata/USER_SETTINGSDATA_';
  private static instance: SettingsDataUtils | undefined;
  private context?: common.Context;

  private constructor() {
  }

  public static getInstance(): SettingsDataUtils {
    if (!SettingsDataUtils.instance) {
      SettingsDataUtils.instance = new SettingsDataUtils();
    }
    return SettingsDataUtils.instance;
  }

  public initSettings(context: common.Context): void {
    this.context = context;
  }

  static createDataHelper(key: string): Promise<dataShare.DataShareHelper> | undefined {
    let uri: string = SettingsDataUtils.getSettingsUri(key);
    if (!uri) {
      log.showError('createDataHelper uri invalid');
      return undefined;
    }
    return dataShare.createDataShareHelper(SettingsDataUtils.getInstance().context, uri);
  }

  static registerDataChange(dataHelper: dataShare.DataShareHelper, key: string, onDataChange: () => void): void {
    if (!dataHelper || !onDataChange) {
      log.warn(TAG + 'registerDataChange params invalid');
      return;
    }
    let uri = SettingsDataUtils.getSettingsUri(key);
    if (!uri) {
      log.error(TAG + 'registerDataChange uri invalid');
      return;
    }
    dataHelper.on('dataChange', uri, onDataChange);
  }

  static unRegisterDataChange(dataHelper: dataShare.DataShareHelper, key: string, offDataChange?: () => void): void {
    if (!dataHelper) {
      log.warn(TAG + 'unRegisterDataChange params invalid');
      return;
    }
    let uri = SettingsDataUtils.getSettingsUri(key);
    if (!uri) {
      log.error(TAG + 'unRegisterDataChange uri invalid');
      return;
    }
    if (offDataChange) {
      dataHelper.off('dataChange', uri, offDataChange);
    } else {
      dataHelper.off('dataChange', uri);
    }
  }

  static registerSecurityDataChange(dataHelper: dataShare.DataShareHelper, key: string,
    onDataChange: () => void): void {
    if (!dataHelper || !onDataChange) {
      log.showWarn(`${TAG}  registerDataChange params invalid`);
      return;
    }

    log.showInfo('register setting data change');
    SettingsDataUtils.getSettingsSecurityUri(key)
      .then((uri) => {
        dataHelper.on('dataChange', uri, onDataChange);
      });
  }

  static unRegisterSecurityDataChange(dataHelper: dataShare.DataShareHelper | undefined, key: string,
    offDataChange?: () => void): void {
    if (!dataHelper) {
      log.warn(`${TAG}  unRegisterSecurityDataChange params invalid`);
      return;
    }
    SettingsDataUtils.getSettingsSecurityUri(key)
      .then((uri) => {
        if (offDataChange) {
          dataHelper.off('dataChange', uri, offDataChange);
        } else {
          dataHelper.off('dataChange', uri);
        }
        log.showInfo('unregister setting success');
      });
  }

  static async getSettingsSecurityUri(key: string): Promise<string> {
    try {
      let accountManager: osAccount.AccountManager = osAccount.getAccountManager();
      let id: number = await accountManager.getOsAccountLocalId();
      let url =
        `datashare:///com.ohos.settingsdata/entry/settingsdata/USER_SETTINGSDATA_SECURE_${id}?Proxy=true&key=${key}`;
      return url;
    } catch (err) {
      log.showError(`${TAG} key: ${key} getOsAccountLocalId fail: ${err?.code}`);
      return '';
    }
  }

  static getSettingsData(key: string, defaultValue: string, domain: string | undefined = undefined): string {
    if (key === undefined || key === null || key.length === 0) {
      log.warn(`${TAG} getSettingsData key invalid`);
      return '';
    }

    try {
      if (domain) {
        return Settings.getValueSync(SettingsDataUtils.getInstance().context, key, defaultValue ?? '', domain);
      }
      return Settings.getValueSync(SettingsDataUtils.getInstance().context, key, defaultValue ?? '');
    } catch (error) {
      log.error(`${TAG} getValueSync failed, ${error?.message}`);
    }
    return defaultValue ?? '';
  }

  static setSwitchSync(key: string, value: string, domain?: string): void {
    if (!SettingsDataUtils.getInstance().context) {
      log.error(TAG, `write switch this.context is undefined, can not write`);
      return;
    }
    try {
      let writeResult: boolean = false;
      if (domain) {
        writeResult = Settings.setValueSync(SettingsDataUtils.getInstance().context, key,
          value ?? Constants.STATE_ON_FLAG, domain);
      } else {
        writeResult = Settings.setValueSync(SettingsDataUtils.getInstance().context, key,
          value);
      }
      log.info(TAG, `write switch writeResult = ${writeResult}`);
    } catch (e) {
      log.error(TAG, `write switch set value error = ${JSON.stringify(e)}`);
    }
  }

  static isSwitchOff(): boolean {
    return SettingsDataUtils.getSettingsData(Constants.STATE_KEY, Constants.STATE_ON_FLAG,
      Settings.domainName.USER_SECURITY) === Constants.STATE_OFF_FLAG
      ? true : false;
  }

  static getSettingsUri(key: string): string {
    if (!key) {
      log.warn('getSettingsUri key invalid');
      return '';
    }
    return SettingsDataUtils.settingsDataUrl + key;
  }
}