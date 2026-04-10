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
import { AsyncCallback } from '@kit.BasicServicesKit';
import settings from '@ohos.settings';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { DomainName, LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'SettingsUtilForPCSound';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class SettingsUtil {
  context?: Context;

  constructor() {
    log.info('constructor');
  }

  /**
   * settings监听
   */
  public registerKeyObserverGeneral(name: string, callBack: AsyncCallback<void>, context?: Context): boolean {
    return this.registerKeyObserver(name, callBack, context, DomainName.SCB);
  }

  /**
   * settings监听注销
   */
  public unregisterKeyObserverGeneral(name: string, context?: Context): boolean {
    return this.unregisterKeyObserver(name, context, DomainName.SCB);
  }

  /**
   * settings监听system级别
   */
  public registerKeyObserverSystem(name: string, callBack: AsyncCallback<void>, context?: Context): boolean {
    return this.registerKeyObserver(name, callBack, context, settings.domainName.USER_PROPERTY);
  }

  /**
   * settings监听注销system级别
   */
  public unregisterKeyObserverSystem(name: string, context?: Context): boolean {
    return this.unregisterKeyObserver(name, context, settings.domainName.USER_PROPERTY);
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

  /**
   * settings获取值
   */
  public async getValue(name: string, defValue: string = '', context?: Context): Promise<string> {
    if (!name || name === '') {
      return defValue;
    }
    this.initContext(context);
    let value: string = defValue;
    try {
      if (this.context) {
        value = await settings.getValue(this.context, name);
      }
    } catch (e) {
      log.error(`getValue from settings error: ${e?.message}`);
    }
    return value;
  }

  /**
   * settings获取值system级别
   */
  public async getSystemValue(name: string, defValue?: string, context?: Context): Promise<string> {
    return await this.getValueEx(settings.domainName.USER_PROPERTY, name, defValue, context);
  }

  /**
   * settings获取值secure级别
   */
  public async getSecureValue(name: string, defValue?: string, context?: Context): Promise<string> {
    return await this.getValueEx(settings.domainName.USER_SECURITY, name, defValue, context);
  }

  /**
   * settings设置值
   */
  public async setValue(name: string, value: string, context?: Context): Promise<boolean> {
    if (!name || name === '') {
      return false;
    }
    this.initContext(context);
    let result: boolean = false;
    try {
      result = (await settings.setValue(this.context, name, value)) ?? false;
    } catch (e) {
      log.error(`setValue to settings error: ${e?.message}`);
    }
    return result;
  }

  /**
   * settings设置值system级别
   */
  public async setSystemValue(name: string, value: string, context?: Context): Promise<boolean> {
    return await this.setValueEx(settings.domainName.USER_PROPERTY, name, value, context);
  }

  /**
   * settings设置值secure级别
   */
  public async setSecureValue(name: string, value: string, context?: Context): Promise<boolean> {
    return await this.setValueEx(settings.domainName.USER_SECURITY, name, value, context);
  }

  private registerKeyObserver(name: string, observer: AsyncCallback<void>, context?: Context,
    domainName: string = DomainName.SCB): boolean {
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

  private async getValueEx(domainName: string = settings.domainName.USER_PROPERTY,
    name: string, defValue: string = '', context?: Context): Promise<string> {
    if (!name || name === '') {
      return defValue;
    }
    this.initContext(context);
    let value: string = defValue;
    try {
      if (this.context) {
        value = await settings.getValue(this.context, name, domainName);
      }
    } catch (e) {
      log.error(`getValueEx from settings error: ${e?.message}`);
    }
    return value;
  }

  private async setValueEx(domainName: string = settings.domainName.USER_PROPERTY,
    name: string, value: string, context?: Context): Promise<boolean> {
    if (!name || name === '') {
      return false;
    }
    this.initContext(context);
    let result: boolean = false;
    try {
      result = (await settings.setValue(this.context, name, value, domainName)) ?? false;
    } catch (e) {
      log.error(`setValueEx to settings error: ${e?.message}`);
    }
    return result;
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
      log.warn('context init fail');
    }
  }
}

let settingsUtil = new SettingsUtil();

export default settingsUtil as SettingsUtil;