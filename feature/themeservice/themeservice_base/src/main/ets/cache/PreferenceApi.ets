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

import { Context } from '@kit.AbilityKit';
import preferences from '@ohos.data.preferences';
import { TsLog } from '../log/TsLog';
import { BusinessError } from '@kit.BasicServicesKit';

export interface PreferenceApi {
  /**
   * 获取名称
   * @return {string} 返回名称
   */
  getName(): string;

  /**
   * 获取指定键的值
   * @param {string} key - 需要获取值的键
   * @param {preferences.ValueType} defValue - 默认值，如果键不存在，则返回此默认值
   * @return {Promise<preferences.ValueType>} 返回键对应的值，如果键不存在，则返回默认值
   */
  get(key: string, defValue?: preferences.ValueType): Promise<preferences.ValueType>;

  /**
   * 设置键值对
   * @param {string} key - 需要设置的键
   * @param {preferences.ValueType} value - 需要设置的值
   * @return {Promise<void>} 返回Promise对象，无返回值
   */
  put(key: string, value: preferences.ValueType): Promise<void>;

  /**
   * 设置数字类型的键值对
   * @param {string} key - 需要设置的键
   * @param {number} value - 需要设置的数字值
   * @return {Promise<void>} 返回Promise对象，无返回值
   */
  putNumber(key: string, value: number): Promise<void>;

  /**
   * 获取数字类型的键值
   * @param {string} key - 需要获取值的键
   * @param {number} defValue - 默认值，如果键不存在，则返回此默认值
   * @return {Promise<number>} 返回键对应的数字值，如果键不存在，则返回默认值
   */
  getNumber(key: string, defValue: number): Promise<number>;

  /**
   * 设置字符串类型的键值对
   * @param {string} key - 需要设置的键
   * @param {string} value - 需要设置的字符串值
   * @return {Promise<void>} 返回Promise对象，无返回值
   */
  putString(key: string, value: string): Promise<void>;

  /**
   * 获取字符串类型的键值
   * @param {string} key - 需要获取值的键
   * @param {string} defValue - 默认值，如果键不存在，则返回此默认值
   * @return {Promise<string>} 返回键对应的字符串值，如果键不存在，则返回默认值
   */
  getString(key: string, defValue: string): Promise<string>;

  /**
   * 设置布尔类型的键值对
   * @param {string} key - 需要设置的键
   * @param {boolean} value - 需要设置的布尔值
   * @return {Promise<void>} 返回Promise对象，无返回值
   */
  putBoolean(key: string, value: boolean): Promise<void>;

  /**
   * 获取布尔类型的键值
   * @param {string} key - 需要获取值的键
   * @param {boolean} defValue - 默认值，如果键不存在，则返回此默认值
   * @return {Promise<boolean>} 返回键对应的布尔值，如果键不存在，则返回默认值
   */
  getBoolean(key: string, defValue: boolean): Promise<boolean>;

  /**
   * 检查键是否存在
   * @param {string} key - 需要检查的键
   * @return {Promise<boolean>} 返回布尔值，如果键存在，则返回true，否则返回false
   */
  has(key: string): Promise<boolean>;

  /**
   * 删除指定键
   * @param {string} key - 需要删除的键
   * @return {Promise<void>} 返回Promise对象，无返回值
   */
  delete(key: string): Promise<void>;

  /**
   * 清除所有键值对
   * @return {Promise<void>} 返回Promise对象，无返回值
   */
  clear(): Promise<void>;
}

class PreferenceDefaultImpl implements PreferenceApi {
  private readonly _name: string;

  constructor(name: string) {
    this._name = name;
  }

  getName(): string {
    return this._name;
  }

  get(_key: string, defValue: preferences.ValueType): Promise<preferences.ValueType> {
    TsLog.error(TAG, `${this._name} get() not implemented.`);
    return Promise.resolve(defValue);
  }

  put(_key: string, _value: preferences.ValueType): Promise<void> {
    TsLog.error(TAG, `${this._name} put() not implemented.`);
    return Promise.resolve();
  }

  putNumber(_key: string, _value: number): Promise<void> {
    TsLog.error(TAG, `${this._name} putNumber() not implemented.`);
    return Promise.resolve();
  }

  getNumber(_key: string, defValue: number): Promise<number> {
    TsLog.error(TAG, `${this._name} getNumber() not implemented.`);
    return Promise.resolve(defValue);
  }

  putString(_key: string, _value: string): Promise<void> {
    TsLog.error(TAG, `${this._name} putString() not implemented.`);
    return Promise.resolve();
  }

  getString(_key: string, defValue: string): Promise<string> {
    TsLog.error(TAG, `${this._name} getString() not implemented.`);
    return Promise.resolve(defValue);
  }

  putBoolean(_key: string, _value: boolean): Promise<void> {
    TsLog.error(TAG, `${this._name} putBoolean() not implemented.`);
    return Promise.resolve();
  }

  getBoolean(_key: string, defValue: boolean): Promise<boolean> {
    TsLog.error(TAG, `${this._name} getBoolean() not implemented.`);
    return Promise.resolve(defValue);
  }

  has(_key: string): Promise<boolean> {
    TsLog.error(TAG, `${this._name} has() not implemented.`);
    return Promise.resolve(false);
  }

  delete(_key: string): Promise<void> {
    TsLog.error(TAG, `${this._name} delete() not implemented.`);
    return Promise.resolve();
  }

  clear(): Promise<void> {
    TsLog.error(TAG, `${this._name} clear() not implemented.`);
    return Promise.resolve();
  }
}

/**
 * 创建一个首选项实例
 *
 * @param {Context} context - 上下文环境，提供相关的运行环境信息
 * @param {string} name - 首选项的名称
 * @return {PreferenceApi} 返回首选项的API接口实例
 */
export function createPreference(context: Context, name: string): PreferenceApi {
  // 创建一个新的偏好设置实现实例
  try {
    return new PreferenceImpl(context, name);
  } catch (err) {
    TsLog.error(TAG, `createPreference catch exception.`, err);
    return new PreferenceDefaultImpl(name);
  }
}

const TAG: string = 'PreferenceApi';

/**
 * theme service preference
 */
class PreferenceImpl implements PreferenceApi {
  private readonly _preferences: Promise<preferences.Preferences>;

  private readonly _name: string;

  public constructor(context: Context, name: string) {
    try {
      this._preferences = preferences.getPreferences(context, name);
      this._name = name;
    } catch (err) {
      const error: BusinessError<string> = { name: `get preferences error`, message: err?.message, code: err?.code };
      throw error as Error;
    }
  }

  getName(): string {
    return this._name;
  }

  public put(key: string, value: preferences.ValueType): Promise<void> {
    return this._preferences.then(pref => pref.put(key, value).then(() => pref.flush()));
  }

  public get(key: string, defValue: preferences.ValueType): Promise<preferences.ValueType> {
    return this._preferences.then(pref => {
      return pref.get(key, defValue).then((result: preferences.ValueType) => {
        return result;
      });
    });
  }

  public putNumber(key: string, value: number): Promise<void> {
    return this._preferences.then(pref => pref.put(key, value).then(() => pref.flush()));
  }

  public getNumber(key: string, defValue: number): Promise<number> {
    return this._preferences.then(pref => {
      return pref.get(key, defValue)
        .then(v => {
          return v as number;
        });
    });
  }

  public putString(key: string, value: string): Promise<void> {
    return this._preferences.then(pref => pref.put(key, value).then(() => pref.flush()));
  }

  public getString(key: string, defValue: string): Promise<string> {
    return this._preferences.then(pref => {
      return pref.get(key, defValue)
        .then(v => {
          return v as string;
        });
    });
  }

  public putBoolean(key: string, value: boolean): Promise<void> {
    return this._preferences.then(pref => pref.put(key, value).then(() => pref.flush()));
  }

  public getBoolean(key: string, defValue: boolean): Promise<boolean> {
    return this._preferences.then(pref => {
      return pref.get(key, defValue)
        .then(v => {
          return v as boolean;
        });
    });
  }

  public has(key: string): Promise<boolean> {
    return this._preferences.then(pref => {
      return pref.has(key);
    });
  }

  public delete(key: string): Promise<void> {
    return this._preferences.then(pref => pref.delete(key).then(() => pref.flush()));
  }

  public clear(): Promise<void> {
    return this._preferences.then(pref => pref.clear().then(() => pref.flush()));
  }
}