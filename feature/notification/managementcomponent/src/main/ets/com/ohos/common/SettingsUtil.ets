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
import { Context } from '@kit.AbilityKit';
import { SingletonHelper, LogDomain, LogHelper, DomainName } from './BasicCommon';
import { AsyncCallback } from '@kit.BasicServicesKit';

const TAG = 'SettingsUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class SettingsUtil {
  public context?: Context;

  constructor() {
    log.showDebug('constructor');
  }

  getValue(name: string, defValue?: string, context?: Context): string | undefined {
    this.initContext(context);
    log.showDebug('getValue name: %{public}s, defValue: %{public}s', name, defValue);
    let value: string | undefined = undefined;
    try {
      value = settings.getValueSync(this.context, name, defValue ? defValue : '');
    } catch (e) {
      log.error(`getValue name: ${name} error`, e);
      return value;
    }
    log.showDebug('getValue name: %{public}s, defValue: %{public}s, value: %{public}s', name, defValue, value);
    return value;
  }

  getValueEx(domainName: string, name: string, defValue?: string, context?: Context): string | undefined {
    this.initContext(context);
    log.showDebug('getValueEx domainName: %{public}s, name: %{public}s, defValue: %{public}s', domainName, name, defValue);
    let value: string | undefined = undefined;
    try {
      value = settings.getValueSync(this.context, name, defValue ? defValue : '', domainName);
    } catch (e) {
      log.error(`getValueEx domainName: ${domainName}, name: ${name} error`, e);
      return value;
    }
    log.showDebug('getValueEx domainName: %{public}s, name: %{public}s, value: %{public}s', domainName, name, value);
    return value;
  }

  getSystemValue(name: string, defValue?: string, context?: Context): string | undefined {
    return this.getValueEx(settings.domainName.USER_PROPERTY, name, defValue, context);
  }

  getSecureValue(name: string, defValue?: string, context?: Context): string | undefined {
    return this.getValueEx(settings.domainName.USER_SECURITY, name, defValue, context);
  }

  setValue(name: string, value: string, context?: Context): boolean {
    this.initContext(context);
    log.showDebug('setValue name: %{public}s, value: %{public}s', name, value);
    let result = false;
    try {
      result = settings.setValueSync(this.context, name, value);
    } catch (e) {
      log.error(`setValue name: ${name} error`, e);
      return result;
    }
    log.showInfo('setValue name: %{public}s, value: %{public}s, result: %{public}s', name, value, result);
    return result;
  }

  setValueEx(domainName: string, name: string, value: string, context?: Context): boolean {
    this.initContext(context);
    log.showDebug('setValueEx domainName: %{public}s, name: %{public}s, value: %{public}s', domainName, name, value);
    let result = false;
    try {
      result = settings.setValueSync(this.context, name, value, domainName);
    } catch (e) {
      log.error(`setValueEx domainName: ${domainName}, name: ${name} error`, e);
      return result;
    }
    log.showInfo('setValueEx domainName: %{public}s, name: %{public}s, value: %{public}s, result: %{public}s',
      domainName, name, value, result);
    return result;
  }

  setSystemValue(name: string, value: string, context?: Context): boolean {
    return this.setValueEx(settings.domainName.USER_PROPERTY, name, value, context);
  }

  setSecureValue(name: string, value: string, context?: Context): boolean {
    return this.setValueEx(settings.domainName.USER_SECURITY, name, value, context);
  }

  /**
   * settings监听secure级别
   */
  public registerKeyObserverSecure(name: string, callBack: AsyncCallback<void>, context?: Context): boolean {
    return this.registerKeyObserver(name, callBack, context, settings.domainName.USER_SECURITY);
  }

  /**
   * settings监听注销secure级别
   */
  public unregisterKeyObserverSecure(name: string, context?: Context): boolean {
    return this.unregisterKeyObserver(name, context, settings.domainName.USER_SECURITY);
  }

  private registerKeyObserver(name: string, observer: AsyncCallback<void>, context?: Context,
    domainName: string = DomainName.NC): boolean {
    if (!name || name === '') {
      return false;
    }
    this.initContext(context);
    let result = false;
    try {
      result = settings.registerKeyObserver(this.context, name, domainName, observer);
    } catch (e) {
      log.error(`registerKeyObserver setting change error: ${e?.message}`);
    }
    return result;
  }

  private unregisterKeyObserver(name: string, context?: Context, domainName: string = DomainName.SCB): boolean {
    if (!name || name === '') {
      return false;
    }
    this.initContext(context);
    let result = false;
    try {
      result = settings.unregisterKeyObserver(this.context, name, domainName);
    } catch (e) {
      log.error(`unregisterKeyObserver setting change error: ${e?.message}`);
    }
    return result;
  }

  initContext(context?: Context): void {
    if (context) {
      this.context = context;
    }
    if (!this.context) {
      log.showError('context init fail');
    }
  }

  getValueBySECURE(name: string, defValue?: string, context?: Context): string | undefined {
    this.initContext(context);
    log.showDebug(`getValue, name: ${name} defValue: ${defValue}`);
    let value: string | undefined = undefined;
    try {
      value = settings.getValueSync(this.context, name, defValue ? defValue : '', settings.domainName.USER_SECURITY);
    } catch (err) {
      log.showError('getValue err: ' + err);
    }
    log.showDebug(`getValue, value: ${value}`);
    return value;
  }
}

let sSettingsUtil = new SettingsUtil();

export default sSettingsUtil as SettingsUtil;