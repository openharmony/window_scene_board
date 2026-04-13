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

import { AsyncCallback, Callback } from '@ohos.base';
import dataShare from '@ohos.data.dataShare';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { AccountHelper } from './AccountHelper';

const TAG = 'DataShareHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const INVALID_USER_ID: number = -1; // 无效用户id
const NORMAL_USER_ID: number = 100; // 常规用户id

const URI_BASE = 'datashare:///com.ohos.settingsdata/entry/settingsdata';
const NORMAL_URI_BASE = URI_BASE + '/SETTINGSDATA?Proxy=true&key=';
const SECURE_URI_BASE = URI_BASE + '/USER_SETTINGSDATA_SECURE_100?Proxy=true&key=';
const USER_SETTINGS_URI_BASE = URI_BASE + '/USER_SETTINGSDATA_';
const USER_SETTINGS_URI_BASE_SUFFIX = '?Proxy=true&key=';

/**
 * 数据类型
 */
export enum DataType {
  NORMAL,

  SECURE,

  USER_SETTINGS
}

/**
 * 数据查询工具类
 */
export class DataShareHelper {
  private readonly _dataType: DataType;
  private readonly _uriKey: string;
  private readonly _uri: string;
  private readonly _callback: AsyncCallback<void>;
  private _dataShareHelper?: dataShare.DataShareHelper;

  constructor(dataType: DataType, uriKey: string, callback: Callback<void>) {
    this._dataType = dataType;
    this._uriKey = uriKey;
    this._uri = this.getUri();
    this._callback = (): void => callback();
  }

  public registerDataShareListener(): void {
    try {
      log.showInfo(`registerDataShareListener, dataType: ${this._dataType}, uriKey:${this._uriKey}`);
      dataShare.createDataShareHelper(GlobalContext.getContext(), this._uri, { isProxy: true },
        (err, data: dataShare.DataShareHelper) => {
          if (err) {
            log.showError(`registerDataShareListener err, dataType: ${this._dataType}, uriKey:${this._uriKey}`);
            return;
          }
          this._dataShareHelper = data;
          this._dataShareHelper?.on('dataChange', this._uri, this._callback);
        });
    } catch (error) {
      log.showError(`registerDataShareListener error, dataType: ${this._dataType}, uriKey:${this._uriKey}`);
    }
  }

  public unRegisterDataShareListener(): void {
    try {
      log.showInfo(`unRegisterDataShareListener, dataType: ${this._dataType}, uriKey:${this._uriKey}`);
      this._dataShareHelper?.off('dataChange', this._uri, this._callback);
      log.showInfo(`unRegisterDataShareListener success, dataType: ${this._dataType}, uriKey:${this._uriKey}`);
    } catch (error) {
      log.showError(`unRegisterDataShareListener error: dataType: ${this._dataType}, uriKey:${this._uriKey}`);
    }
  }

  private getUri(): string {
    switch (this._dataType) {
      case DataType.NORMAL:
        return NORMAL_URI_BASE + this._uriKey;
      case DataType.SECURE:
        return SECURE_URI_BASE + this._uriKey;
      case DataType.USER_SETTINGS:
        return this.getUserSettingsKeyUri();
      default:
        return '';
    }
  }

  private getUserSettingsKeyUri(): string {
    let user = AccountHelper.getInstance().currentLocalId;
    log.showInfo(`getUri userId: ${user}, key: ${this._uriKey}`);
    if (!CommonUtils.isNumber(user) || user === INVALID_USER_ID) {
      log.showWarn('userId is invaild, use NORMAL_USER_ID instead');
      user = NORMAL_USER_ID;
    }
    return USER_SETTINGS_URI_BASE + user + USER_SETTINGS_URI_BASE_SUFFIX + this._uriKey;
  }
}