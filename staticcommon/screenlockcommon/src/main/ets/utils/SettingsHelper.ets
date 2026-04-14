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

import { AsyncCallback, BusinessError } from '@ohos.base';
import settings from '@ohos.settings';
import { Context } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';

const TAG = 'SettingsHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);


/**
 * 数据库工具类
 */
export class DomainName {
  public static readonly DEVICE_SHARED: string = settings.domainName.DEVICE_SHARED;

  public static readonly USER_PROPERTY: string = settings.domainName.USER_PROPERTY;

  public static readonly USER_SECURITY: string = settings.domainName.USER_SECURITY;
}

/**
 * 设置数据库工具类
 */
export class SettingsHelper {
  private readonly _context: Context;
  private readonly _domainName: string;
  private readonly _registerObservers: Map<string, Set<() => void>> = new Map();

  constructor(domainName: string, context?: Context) {
    this._domainName = domainName;
    this._context = context ?? GlobalContext.getContext();
  }

  /**
   * 同步获取数据项的值
   *
   * @param name 数据项的名称
   * @param defValue 默认值
   * @returns 返回数据项的值
   */
  public getValueSync(name: string, defValue: string): string {
    try {
      return settings.getValueSync(this._context, name, defValue, this._domainName);
    } catch (error) {
      log.showError(`getValueSync fail, error code ${error?.code}`);
    }
    return defValue;
  }

  /**
   * 异步获取数据项的值
   *
   * @param name 数据项的名称
   * @param defValue 默认值
   * @returns 返回数据项的值
   */
  public getValueAsync(name: string, defValue: string, callback: (value: string) => void): void {
    try {
      settings.getValue(this._context, name, this._domainName).then((data) => {
        callback(data);
      }).catch((err: BusinessError) => {
        callback(defValue);
        log.showError(`getValueAsync fail, err code ${err?.code}`);
      });
    } catch (error) {
      callback(defValue);
      log.showError(`getValueAsync fail, error code ${error?.code}`);
    }
  }

  /**
   * 注册数据项变化监听
   *
   * @param name 数据项的名称
   * @param inCallback 数据变化时回调
   * @returns 注册是否成功
   */
  public registerObserver(name: string, inCallback?: () => void): boolean {
    if (!inCallback) {
      log.showError('registerObserver failed, inCallback is undefined');
      return false;
    }
    if (this._registerObservers.has(name)) {
      this._registerObservers.get(name)?.add(inCallback);
      return true;
    }
    let observers: Set<() => void> = new Set();
    observers.add(inCallback);
    this._registerObservers.set(name, observers);
    return this.registerKeyObserver(name);
  }

  /**
   * 注销数据项变化监听
   *
   * @param name 数据项的名称
   * @param inCallback 数据变化时回调
   * @returns 注册是否成功
   */
  public unRegisterObserver(name: string, inCallback?: () => void): boolean {
    if (!this._registerObservers.has(name)) {
      log.showWarn(`unRegisterObserver ${name} fail, because name not register.`);
      return false;
    }

    if (!inCallback) {
      if (this.unRegisterKeyObserver(name)) {
        log.showInfo(`unRegisterObserver ${name} delete success.`);
        this._registerObservers.delete(name);
      }
      return true;
    }

    let observers: Set<() => void> | undefined = this._registerObservers.get(name);
    if (!observers || !observers.has(inCallback)) {
      log.showWarn(`unRegisterObserver ${name} fail, because callback not register.`);
      return false;
    }

    observers.delete(inCallback);
    if (observers.size === 0 && this.unRegisterKeyObserver(name)) {
      log.showInfo(`unRegisterObserver ${name} delete callback and key success.`);
      this._registerObservers.delete(name);
      return true;
    }

    log.showInfo(`unRegisterObserver ${name} delete callback success.`);
    return true;
  }

  private registerKeyObserver(name: string): boolean {
    try {
      let callback: AsyncCallback<void> = (err, data): void => {
        if (err) {
          log.showError(`registerKeyObserver ${name} error. code ${err.code}`);
        }
        this._registerObservers.get(name)?.forEach(callback => callback());
      };

      if (settings.registerKeyObserver(this._context, name, this._domainName, callback)) {
        log.showInfo(`registerKeyObserver ${name} success.`);
        return true;
      } else {
        log.showError(`registerKeyObserver ${name} return false.`);
        this._registerObservers.delete(name);
        return false;
      }
    } catch (error) {
      log.showError(`registerKeyObserver ${name} fail, error code ${error?.code}`);
    }
    return false;
  }

  private unRegisterKeyObserver(name: string): boolean {
    try {
      if (settings.unregisterKeyObserver(this._context, name, this._domainName)) {
        log.showInfo(`unRegisterKeyObserver ${name} success`);
        return true;
      } else {
        log.showInfo(`unRegisterKeyObserver ${name} fail`);
        return false;
      }
    } catch (error) {
      log.showError(`unRegisterKeyObserver ${name} fail, error code ${error?.code}`);
    }
    return false;
  }

  /**
   * 释放所有注册的监听
   */
  public release(): void {
    this._registerObservers.forEach((_value, name) => this.unRegisterKeyObserver(name));
    this._registerObservers.clear();
  }
}