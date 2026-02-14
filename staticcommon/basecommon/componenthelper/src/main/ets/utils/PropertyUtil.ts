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

import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG: string = 'PropertyUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class FieldEx<T> {
  private _value: T;
  private logMsg: string = '';

  /**
   * @param defaultVal 默认值
   * @param logMsg 日志描述 传了之后变量修改时会打印日志
   */
  constructor(defaultVal: T, logMsg: string = '') {
    this._value = defaultVal;
    this.logMsg = logMsg;
  }

  get value(): T {
    return this._value;
  }

  set value(val: T) {
    if (this._value !== val) {
      const originVal = this._value;
      this._value = val;
      if (this.logMsg) {
        log.showInfo(`${this.logMsg} changed, from ${originVal} to ${val}`);
      }
    }
  }
}

/**
 * UI变量封装
 */
@Observed
export class StateEx<T> extends FieldEx<T> {}

/**
 * 弱引用观察者 <key, listener>
 */
export class WeakObserver<U, T extends object> {
  private map: Map<U, WeakRef<T>> = new Map();

  /**
   * 注册
   * @param key 观察者key
   * @param listener 观察者对象
   */
  public register(key: U, listener: T): void {
    this.map.set(key, new WeakRef(listener));
  }

  /**
   * 反注册
   * @param key
   * @returns
   */
  public unregister(key: U): boolean {
    return this.map.delete(key);
  }

  /**
   * 根据key获取观察者对象
   * @param key
   * @returns
   */
  public get(key: U): T | undefined {
    const ref = this.map.get(key);
    return ref && ref.deref();
  }

  /**
   * 清理
   */
  public release(): void {
    this.map.clear();
  }
}