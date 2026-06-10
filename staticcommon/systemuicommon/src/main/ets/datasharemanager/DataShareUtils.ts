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

import Settings from '@ohos.settings';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { taskpool } from '@kit.ArkTS';
import { Context } from '@kit.AbilityKit';
import { SettingUtil } from '../utils/SettingUtil';
import { osAccount } from '@kit.BasicServicesKit';
import { LogWithHa } from '../maintenance/CommonExceptionMaintenance';
import { StatusBarExceptionCode } from '../statusbar/enum/StatusBarExceptionCode';
import { SystemUICommonUtil } from '../utils/SystemUICommonUtil';

const TAG = 'SysUI_DataShareUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const RETRY_MAX_COUNT = 3; // 数据获取重试最大次数
const RETRY_DELAY_STEP_MS = 2000; // 数据获取重试增量间隔，单位毫秒
const ERROR_VALUE = 'error:';

/**
 * 设置数据库键值拼接
 * 用于解决SettingsData去常驻
 */
const SETTINGS_URI_KEY = 'datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=';
const SETTINGS_USER_URI_PREFIX = 'datashare:///com.ohos.settingsdata/entry/settingsdata/USER_SETTINGSDATA_';
const SETTINGS_SECURE_URI_KEY = 'datashare:///com.ohos.settingsdata/entry/settingsdata/USER_SETTINGSDATA_SECURE_100?Proxy=true&key=';
const SETTINGS_SECURE_URI_PREFIX = 'datashare:///com.ohos.settingsdata/entry/settingsdata/USER_SETTINGSDATA_SECURE_';

/**
 * 设置数据库共享常量
 */
export class SettingsConstant {
  /**
   * 设置数据库共享路径
   */
  static readonly SETTINGS_URI: string = 'datashare:///com.ohos.settingsdata.DataAbility';

  /**
   * 设置数据库键值，时间小时制(12/24)
   */
  static readonly KEY_TIME_FORMAT = Settings.date.TIME_FORMAT;
}

export interface GetSettingSwitchParam {
  uriKey: string;
  defaultValue: string;
  isCmpEqual: boolean;
  cmpValue: string;
  needRetry?: boolean;
}

interface TaskParam {
  uriKey: string;
  defaultValue: string;
  domainName?: string;
}

/**
 * 数据共享工具
 *
 * @since 2022-12-10
 */
export class DataShareUtils {
  private static taskParams?: TaskParam[];
  private static debouncePromise?: Promise<string[]>;

  /**
   * 获取设置数据库共享uri
   *
   * @param uriKey uri参数
   */
  static getSettingsUriSync(uriKey: string): string {
    return SETTINGS_URI_KEY + uriKey;
  }

  /**
   * 获取设置数据库共享uri,多用户隔离
   *
   * @param uriKey uri参数
   */
  static getSettingsSecureUriSync(uriKey: string): string {
    return SETTINGS_SECURE_URI_KEY + uriKey;
  }

  /**
   * 获取设置数据库共享uri,多用户隔离(异步)
   *
   * @param uriKey uri参数
   */
  static async getSettingsSecureUriAsync(uriKey: string): Promise<string> {
    const currentUserId = await osAccount.getAccountManager().getOsAccountLocalId();
    return SETTINGS_SECURE_URI_PREFIX + currentUserId + '?Proxy=true&key=' + uriKey;
  }

  /**
   * 获取设置数据库共享uri,多用户隔离(异步)
   *
   * @param uriKey uri参数
   */
  static async getSettingsUserUriAsync(uriKey: string): Promise<string> {
    const currentUserId = await osAccount.getAccountManager().getOsAccountLocalId();
    return SETTINGS_USER_URI_PREFIX + currentUserId + '?Proxy=true&key=' + uriKey;
  }

  /**
   * 获取设置数据库值
   *
   * @param uriKey 数据库键值
   * @param defaultValue 默认值
   */
  static getSettingsValueSync(uriKey: string, defaultValue: string): string {
    let context = GlobalContext.getContext();
    return SettingUtil.getValueSyncByContext(context, uriKey, defaultValue);
  }

  /**
   * 获取设置数据库值(分用户)
   *
   * @param uriKey 数据库键值
   * @param defaultValue 默认值
   */
  static getSettingsUserValueSync(uriKey: string, defaultValue: string): string {
    let context = GlobalContext.getContext();
    return SettingUtil.getValueSyncByContext(context, uriKey, defaultValue, Settings.domainName.USER_PROPERTY);
  }

  /**
   * 获取设置数据库值
   *
   * @param uriKey 数据库键值
   * @param defaultValue 默认值
   */
  static getSettingsSecureValueSync(uriKey: string, defaultValue: string): string {
    let context = GlobalContext.getContext();
    return SettingUtil.getValueSyncByContext(context, uriKey, defaultValue, Settings.domainName.USER_SECURITY);
  }

  /**
   * 异步获取设置字段是否使能
   * @param param 获取参数（包含获取的字段key，默认值，比较值，是否进行相等比较）
   * @param isAsync 是否异步获取
   * @returns 是否使能
   */
  static async getSettingEnableValue(param: GetSettingSwitchParam, isAsync?: boolean): Promise<boolean> {
    return this.getSettingValue(param, isAsync);
  }

  /**
   * 异步获取设置字段是否使能（分用户）
   * @param param 获取参数（包含获取的字段key，默认值，比较值，是否进行相等比较）
   * @param isAsync 是否异步获取
   * @returns 是否使能
   */
  static async getSettingUserEnableValue(param: GetSettingSwitchParam, isAsync?: boolean): Promise<boolean> {
    return this.getSettingValue(param, isAsync, Settings.domainName.USER_PROPERTY);
  }

  /**
   * 异步获取安全域设置字段是否使能
   * @param param 获取参数（包含获取的字段key，默认值，比较值，是否进行相等比较）
   * @param isAsync 是否异步获取
   * @returns 是否使能
   */
  static async getSettingSecureEnableValue(param: GetSettingSwitchParam, isAsync?: boolean): Promise<boolean> {
    return this.getSettingValue(param, isAsync, Settings.domainName.USER_SECURITY);
  }

  static async getSettingSecureValue(param: GetSettingSwitchParam, isAsync?: boolean): Promise<string> {
    return DataShareUtils.getOriginalSettingValue(param, isAsync, Settings.domainName.USER_SECURITY);
  }

  private static async getOriginalSettingValue(param: GetSettingSwitchParam, isAsync?: boolean, domainName?: string):
    Promise<string> {
    let context = GlobalContext.getContext();
    let resultValue: string = param.defaultValue;
    let executeTimes = param.needRetry ? 0 : RETRY_MAX_COUNT;
    if (isAsync) {
      do {
        try {
          resultValue = await DataShareUtils.getValue(param, domainName);
        } catch (e) {
          LogWithHa.warn(log, `getOriginalSettingValue for ${param.uriKey} with times ${executeTimes} error`,
            StatusBarExceptionCode.SETTING_FAIL, e, TAG);
        }
        if (resultValue !== ERROR_VALUE) {
          break;
        }
        if (executeTimes < RETRY_MAX_COUNT) {
          executeTimes++;
          await SystemUICommonUtil.sleep(RETRY_DELAY_STEP_MS * executeTimes);
          log.showInfo(`getOriginalSettingValue for ${param.uriKey} with times ${executeTimes}`);
        }
      } while (executeTimes < RETRY_MAX_COUNT)
      // 如果返回值等于ERROR_VALUE则表示查询失败
      if (resultValue === ERROR_VALUE) {
        resultValue = param.defaultValue;
        LogWithHa.warn(log, `getOriginalSettingValue for ${param.uriKey} failed`,
          StatusBarExceptionCode.SETTING_COMMON_FAIL, new Error(), TAG);
      }
    } else {
      resultValue = SettingUtil.getValueSyncByContext(context, param.uriKey, param.defaultValue, domainName);
    }
    log.showInfo(`get ${param.uriKey} value is ${resultValue}`);
    return resultValue;
  }

  private static async getSettingValue(param: GetSettingSwitchParam, isAsync?: boolean, domainName?: string):
    Promise<boolean> {
    const resultValue = await DataShareUtils.getOriginalSettingValue(param, isAsync, domainName);
    return (param.isCmpEqual ? resultValue === param.cmpValue : resultValue !== param.cmpValue);
  }

  private static async getValue(param: GetSettingSwitchParam, domainName?: string): Promise<string> {
    if (!DataShareUtils.taskParams) {
      DataShareUtils.taskParams = [];
    }
    const index = DataShareUtils.taskParams.length;
    DataShareUtils.taskParams.push({ uriKey: param.uriKey, defaultValue: param.defaultValue, domainName });
    const results = await DataShareUtils.debounceGetValue();
    return results[index];
  }

  private static debounceGetValue(): Promise<string[]> {
    if (DataShareUtils.debouncePromise) {
      return DataShareUtils.debouncePromise;
    }
    DataShareUtils.debouncePromise = Promise.resolve().then(() => {
      const taskParams = DataShareUtils.taskParams;
      // 本次周期内执行下发后需要把debouncePromise清空，下一次周期内查询重新起一个
      DataShareUtils.debouncePromise = undefined;
      DataShareUtils.taskParams = undefined;
      if (!taskParams?.length) {
        return [];
      }
      return taskpool.execute(batchGetValue, GlobalContext.getContext(), taskParams, ERROR_VALUE) as Promise<string[]>;
    });
    return DataShareUtils.debouncePromise;
  }
}

async function batchGetValue(context: Context, params: TaskParam[], errorValue: string): Promise<string[]> {
  'use concurrent';
  console.log(`SysUI_DataShareUtils batchGetValue, keys: ${params.map((param) => param.uriKey)}`);
  return await Promise.all(params.map((param) => {
    try {
      if (param.domainName) {
        return Settings.getValueSync(context, param.uriKey, param.defaultValue, param.domainName);
      } else {
        return Settings.getValueSync(context, param.uriKey, param.defaultValue);
      }
    } catch (e) {
      console.log(`SysUI_DataShareUtils batchGetValue for ${param.uriKey} error: ${e.message}, stack: ${e.stack}`);
      return errorValue;
    }
  }));
}