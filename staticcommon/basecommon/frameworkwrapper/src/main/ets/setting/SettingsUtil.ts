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
import settings from '@ohos.settings';
import { SingletonHelper, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '../utils/GlobalContext';
import { HashMap } from '@kit.ArkTS';

const TAG = 'SettingsUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class SettingsUtil {
  context: Context = GlobalContext.getContext();

  private domainKeyValueCacheMap: HashMap<string, HashMap<string, string>> = new HashMap();

  constructor() {
    log.showDebug('constructor');
  }

  getValue(name: string, defValue?: string, context?: Context): string {
    this.initContext(context);
    let value: string = '';
    try {
      value = settings.getValueSync(this.context, name, defValue ? defValue : '');
    } catch (e) {
      log.error(`getValue name: ${name} error`, e);
      return value;
    }
    log.showDebug('getValue name: %{public}s success', name);
    return value;
  }

  /**
   * getValueDfx 该接口会打印value内容，可能会导致安全隐私风险，需谨慎使用。
   * 
   * @param name 名称
   * @param defValue 内容
   * @param context 上下文
   * @returns 设置成功返回值
   */
  getValueDfx(name: string, defValue?: string, context?: Context): string {
    this.initContext(context);
    let value: string = '';
    try {
      value = settings.getValueSync(this.context, name, defValue ? defValue : '');
    } catch (e) {
      log.error(`getValueDfx name: ${name} error`, e);
      return value;
    }
    log.showInfo('getValueDfx name: %{public}s, value: %{public}s', name, value);
    return value;
  }

  /**
   * 异步获取数据库中指定数据项的值
   */
  async getValueAsync(name: string, defValue?: string, context?: Context): Promise<string> {
    this.initContext(context);
    log.showDebug('getValueAsync name: %{public}s, defValue: %{public}s', name, defValue);
    try {
      const value = await settings.getValue(this.context, name);
      return value?.toString();
    } catch (e) {
      log.error(`getValueExAsync name: ${name} error`, e);
      return defValue ?? '';
    }
  }

  getValueEx(domainName: string, name: string, defValue?: string, context?: Context): string {
    this.initContext(context);
    let value: string = '';
    try {
      value = settings.getValueSync(this.context, name, defValue ? defValue : '', domainName);
    } catch (e) {
      log.error(`getValueEx domainName: ${domainName}, name: ${name} error`, e);
      return value;
    }
    log.showDebug('getValueEx domainName: %{public}s, name: %{public}s success', domainName, name);
    return value;
  }

  /**
   * getValueExDfx 该接口会打印value内容，可能会导致安全隐私风险，需谨慎使用。
   * 
   * @param domainName 域名
   * @param name 名称
   * @param defValue 内容
   * @param context 上下文
   * @returns 设置成功返回值
   */
  getValueExDfx(domainName: string, name: string, defValue?: string, context?: Context): string {
    this.initContext(context);
    let value: string = '';
    try {
      value = settings.getValueSync(this.context, name, defValue ? defValue : '', domainName);
    } catch (e) {
      log.error(`getValueExDfx domainName: ${domainName}, name: ${name} error`, e);
      return value;
    }
    log.showInfo('getValueExDfx domainName: %{public}s, name: %{public}s, defValue: %{public}s  value: %{public}s', domainName, name,
      defValue, value);
    return value;
  }

  /**
   * 异步获取数据库中指定数据项的值
   */
  async getValueExAsync(domainName: string, name: string, defValue?: string, context?: Context): Promise<string> {
    this.initContext(context);
    log.showDebug('getValueExAsync domainName: %{public}s, name: %{public}s, defValue: %{public}s', domainName, name, defValue);
    try {
      const value = await settings.getValue(this.context, name, domainName);
      return value;
    } catch (e) {
      log.error(`getValueExAsync domainName: ${domainName}, name: ${name} error`, e);
      return defValue ?? '';
    }
  }

  getSystemValue(name: string, defValue?: string, context?: Context): string {
    return this.getValueExDfx(settings.domainName.USER_PROPERTY, name, defValue, context);
  }

  getSecureValue(name: string, defValue?: string, context?: Context): string {
    return this.getValueEx(settings.domainName.USER_SECURITY, name, defValue, context);
  }

  /**
   * 异步获取用户安全属性域中的值
   */
  async getSecureValueAsync(name: string, defValue?: string, context?: Context): Promise<string> {
    return this.getValueExAsync(settings.domainName.USER_SECURITY, name, defValue, context);
  }

  setValue(name: string, value: string, context?: Context): boolean {
    this.initContext(context);
    let result = false;
    try {
      result = settings.setValueSync(this.context, name, value);
    } catch (e) {
      log.error(`setValue name: ${name} error`, e);
      return result;
    }
    log.showInfo('setValue name: %{public}s, result: %{public}s', name, result);
    return result;
  }

  /**
   * setValueDfx 该接口会打印value内容，可能会导致安全隐私风险，需谨慎使用。
   * @param name 名称
   * @param value 内容
   * @param context 上下文
   * @returns 设置成功返回值
   */
  setValueDfx(name: string, value: string, context?: Context): boolean {
    this.initContext(context);
    log.showDebug('setValueDfx name: %{public}s, value: %{public}s', name, value);
    let result = false;
    try {
      result = settings.setValueSync(this.context, name, value);
    } catch (e) {
      log.error(`setValueDfx name: ${name} error`, e);
      return result;
    }
    log.showInfo('setValueDfx result: %{public}s', result);
    return result;
  }

  setValueEx(domainName: string, name: string, value: string, context?: Context): boolean {
    this.initContext(context);
    let result = false;
    try {
      result = settings.setValueSync(this.context, name, value, domainName);
    } catch (e) {
      log.error(`setValueEx domainName: ${domainName}, name: ${name} error`, e);
      return result;
    }
    log.showInfo('setValueEx domainName: %{public}s, name: %{public}s, result: %{public}s', domainName, name, result);
    return result;
  }

  /**
   * setValueExDfx 该接口会打印value内容，可能会导致安全隐私风险，需谨慎使用。
   * 
   * @param domainName 域名
   * @param name 名称
   * @param value 内容
   * @param context 上下文
   * @returns 设置成功返回值
   */
  setValueExDfx(domainName: string, name: string, value: string, context?: Context): boolean {
    this.initContext(context);
    log.showDebug('setValueExDfx domainName: %{public}s, name: %{public}s, value: %{public}s',
      domainName, name, value);
    let result = false;
    try {
      result = settings.setValueSync(this.context, name, value, domainName);
    } catch (e) {
      log.error(`setValueExDfx domainName: ${domainName}, name: ${name} error`, e);
      return result;
    }
    log.showInfo('setValueExDfx result: %{public}s', result);
    return result;
  }

  setSystemValue(name: string, value: string, context?: Context): boolean {
    return this.setValueExDfx(settings.domainName.USER_PROPERTY, name, value, context);
  }

  setSecureValue(name: string, value: string, context?: Context): boolean {
    return this.setValueEx(settings.domainName.USER_SECURITY, name, value, context);
  }

  private initContext(context?: Context): void {
    if (context) {
      this.context = context;
    }
    if (this.context === undefined || this.context === null) {
      this.context = GlobalContext.getContext();
    }
    if (this.context === undefined || this.context === null) {
      this.context = GlobalContext.getInstance().getObject('ablitycontext') as Context;
    }
    if (this.context === undefined || this.context === null) {
      log.showError('context init fail');
    }
  }

  getValueBySECURE(name: string, defValue?: string, context?: Context): string {
    this.initContext(context);
    log.showDebug(`getValue, name: ${name} defValue: ${defValue}`);
    let value: string = '';
    try {
      value = settings.getValueSync(this.context, name, defValue ? defValue : '', settings.domainName.USER_SECURITY);
    } catch (err) {
      log.showError('getValue err: ' + err);
    }
    log.showDebug(`getValue, value: ${value}`);
    return value;
  }

  private assureDomainKeyValueMap(domainName: string): HashMap<string, string> {
    let keyValueMap = this.domainKeyValueCacheMap.get(domainName);
    if (!keyValueMap) {
      let newKeyValueMap: HashMap<string, string> = new HashMap();
      this.domainKeyValueCacheMap.set(domainName, newKeyValueMap);
      log.showInfo(`Supply domainMap for ${domainName}`);
      return newKeyValueMap;
    }
    return keyValueMap;
  }
}

let sSettingsUtil = SingletonHelper.getInstance(SettingsUtil, TAG);

export default sSettingsUtil as SettingsUtil;