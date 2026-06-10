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

import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext, sSettingsUtil } from '@ohos/frameworkwrapper';
import dataShare from '@ohos.data.dataShare';
import { AsyncCallback, Callback } from '@ohos.base';
import { AccountHelper } from '../utils/AccountHelper';
import { HashMap } from '@kit.ArkTS';
import accountsModelApi from '../api/AccountsModelApi';
import { SystemSwitchUtils } from '../utils/SystemSwitchUtils';

const TAG = 'DataShareManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
// 无效用户id
const INVALID_USER_ID: number = -1;
// 常规用户id
const NORMAL_USER_ID: number = 100;

export default class DataShareManager {
  private static readonly instance: DataShareManager = new DataShareManager();
  private readonly uriBase: string =
    'datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=';
  private readonly userSettingsUriBase: string =
    'datashare:///com.ohos.settingsdata/entry/settingsdata/USER_SETTINGSDATA_';
  private readonly userSettingsUriBaseSuffix: string = '?Proxy=true&key=';
  private helper?: dataShare.DataShareHelper;
  private secureHelper?: dataShare.DataShareHelper;
  private secureHelperMap: HashMap<string, dataShare.DataShareHelper> =
    new HashMap<string, dataShare.DataShareHelper>();

  private constructor() {
  }

  public static getInstance(): DataShareManager {
    return DataShareManager.instance;
  }

  public async registerDataShareListener(key: string, callback: Callback<void>): Promise<void> {
    try {
      log.showInfo(`registerDataShareListener,key=${key}`);
      let keyUri: string = this.getKeyUri(key);

      this.helper = await dataShare.createDataShareHelper(GlobalContext.getContext(), keyUri);
      this.helper?.on('dataChange', keyUri, () => {
        callback();
      });
      log.showInfo(`registerDataShareListener end,key=${key}`);
    } catch (e) {
      log.showError(`registerDataShareListener exception: ${e?.message}`);
    }
  }

  public async registerSecureDataShareListener(key: string, callback: AsyncCallback<void>): Promise<void> {
    try {
      log.showInfo(`registerSecureDataShareListener,key=${key}`);
      let secureKeyUri: string = await this.getSecureKeyUri(key);
      let secureHelper: dataShare.DataShareHelper = await this.getSecureHelper(secureKeyUri);
      secureHelper?.on('dataChange', secureKeyUri, callback);
      log.showInfo(`registerSecureDataShareListener end,key=${key}, secureKeyUri = ${secureKeyUri} `);
    } catch (e) {
      log.showError(`registerSecureDataShareListener exception: ${e?.message}`);
    }
  }

  public async registerUserSettingsDataShareListener(key: string, callback: Callback<void>): Promise<void> {
    try {
      log.showInfo(`registerUserSettingsDataShareListener,key=${key}`);
      let keyUri: string = await this.getUserSettingsKeyUri(key);
      this.helper = await dataShare.createDataShareHelper(GlobalContext.getContext(), keyUri);
      this.helper?.on('dataChange', keyUri, () => {
        callback();
      });
      log.showInfo(`registerUserSettingsDataShareListener end,key=${key}`);
    } catch (e) {
      log.showError(`registerUserSettingsDataShareListener exception: ${e?.message}`);
    }
  }

  public async unregisterDataShareListener(key: string): Promise<void> {
    try {
      log.showInfo(`unregisterDataShareListener,key=${key}`);
      let keyUri: string = this.getKeyUri(key);
      this.helper = await dataShare.createDataShareHelper(GlobalContext.getContext(), keyUri);
      this.helper?.off('dataChange', keyUri);
      log.showInfo(`unregisterDataShareListener end,key=${key}}`);
    } catch (e) {
      log.showError(`unregisterDataShareListener exception: ${e?.message}`);
    }
  }

  public async unregisterSecureDataShareListener(key: string, callback: AsyncCallback<void> = () => {}): Promise<void> {
    try {
      log.showInfo(`unregisterSecureDataShareListener,key=${key}`);
      let secureKeyUri: string = await this.getSecureKeyUri(key);
      let secureHelper: dataShare.DataShareHelper = await this.getSecureHelper(secureKeyUri);
      secureHelper?.off('dataChange', secureKeyUri, callback);
      log.showInfo(`unregisterSecureDataShareListener end,key=${key}, secureKeyUri = ${secureKeyUri}`);
    } catch (e) {
      log.showError(`unregisterSecureDataShareListener exception: ${e?.message}`);
    }
  }

  private async getSecureHelper(secureKeyUri: string): Promise<dataShare.DataShareHelper> {
    if (this.secureHelperMap.hasKey(secureKeyUri)) {
      return this.secureHelperMap.remove(secureKeyUri);
    }
    let secureHelper: dataShare.DataShareHelper =
      await dataShare.createDataShareHelper(GlobalContext.getContext(), secureKeyUri);
    this.secureHelperMap.set(secureKeyUri, secureHelper);
    return secureHelper;
  }

  public async unregisterUserSettingsDataShareListener(key: string): Promise<void> {
    try {
      log.showInfo(`unregisterUserSettingsDataShareListener,key=${key}`);
      let keyUri: string = await this.getUserSettingsKeyUri(key);
      this.helper = await dataShare.createDataShareHelper(GlobalContext.getContext(), keyUri);
      this.helper?.off('dataChange', keyUri);
      log.showInfo(`unregisterUserSettingsDataShareListener end,key=${key}, keyUri:${keyUri}`);
    } catch (e) {
      log.showError(`unregisterUserSettingsDataShareListener exception: ${e?.message}`);
    }
  }

  public getValue(key: string, defaultVal: string): string {
    return sSettingsUtil.getValue(key, defaultVal);
  }

  private getKeyUri(key: string): string {
    return this.uriBase + key;
  }

  private async getSecureKeyUri(key: string): Promise<string> {
    let currentUser: number = NORMAL_USER_ID;
    if (SystemSwitchUtils.isUseNewScreenLock()) {
      currentUser = AccountHelper.getInstance().currentLocalId;
    } else {
      currentUser = await accountsModelApi.updateCurrentUserId();
    }
    log.showInfo(`getSecureKeyUri userId: ${currentUser}, key: ${key}`);
    if (currentUser === INVALID_USER_ID) {
      log.showWarn('userId is invaild, use NORMAL_USER_ID instead');
      currentUser = NORMAL_USER_ID;
    }

    const secureUriBase: string =
      `datashare:///com.ohos.settingsdata/entry/settingsdata/USER_SETTINGSDATA_SECURE_${currentUser}?Proxy=true&key=`;
    return secureUriBase + key;
  }

  private async getUserSettingsKeyUri(key: string): Promise<string> {
    let user: number = NORMAL_USER_ID;
    if (SystemSwitchUtils.isUseNewScreenLock()) {
      user = AccountHelper.getInstance().currentLocalId;
    } else {
      user = await accountsModelApi.updateCurrentUserId();
    }
    log.showInfo(`getUserSettingsKeyUri userId: ${user}, key: ${key}`);
    if (user === INVALID_USER_ID) {
      log.showWarn('userId is invaild, use NORMAL_USER_ID instead');
      user = NORMAL_USER_ID;
    }
    return this.userSettingsUriBase + user + this.userSettingsUriBaseSuffix + key;
  }
}


