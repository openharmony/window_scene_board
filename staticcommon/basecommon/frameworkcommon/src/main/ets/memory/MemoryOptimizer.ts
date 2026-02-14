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
import { LogDomain, Logger } from '@ohos/basicutils';

const TAG = 'MemoryOptimizer';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);

class MemoryOptimizer<K, T extends Object> {
  private map: Map<K, WeakRef<T>> = new Map();

  /**
   * 注册
   * @param key 观察者key
   * @param listener 观察者对象
   */
  public register(key: K, listener: T): void {
    this.map.set(key, new WeakRef(listener));
  }

  /**
   * 反注册
   * @param key
   * @returns
   */
  public unregister(key: K): boolean {
    return this.map.delete(key);
  }

  /**
   * 根据key获取观察者对象
   * @param key
   * @returns
   */
  public get(key: K): T | undefined {
    const ref = this.map.get(key);
    return ref && ref.deref();
  }

  /**
   * 获取所有观察者对象
   * @param key
   * @returns
   */
  public getAll(): T[] {
    let result: T[] = [];
    let temp: (T | undefined)[] = Array
      .from(this.map.values())
      .map(item => item.deref());
    if (temp) {
      for (let idx = 0; idx < temp.length; idx++) {
        if (temp[idx] !== undefined) {
          result.push(temp[idx] as T);
        }
      }
    }
    return result;
  }

  /**
   * 清理
   */
  public release(): void {
    this.map.clear();
  }
}

export class GridlayoutMemoryListener {
  onOptimize: () => void = () => {
  };
  onRecover: () => void = () => {
  };
}

export class GridLayoutMemoryOptimizer extends MemoryOptimizer<string, GridlayoutMemoryListener> {
  private active: MemoryStateEx<boolean> = new MemoryStateEx(false);
  private enable: boolean = true;

  /**
   * 开始优化
   */
  public start(): void {
    if (!this.enable) {
      log.showWarn(TAG, 'optimizer is disabled, cannot start');
      return;
    }
    if (this.active.value) {
      log.showWarn(TAG, 'optimizer is already started');
      return;
    }
    log.showWarn(TAG, 'start optimize');
    this.active.value = true;
    this.optimize();
  }

  /**
   * 优化结束
   */
  public end(): void {
    if (!this.active.value) {
      return;
    }
    log.showWarn(TAG, 'end optimize');
    this.active.value = false;
    this.recover();
  }

  /**
   * 中断
   */
  public cancel(msg: string): void {
    if (!this.active.value) {
      return;
    }
    log.showWarn(TAG, `cancel optimize by ${msg}`);
    this.active.value = false;
    this.recover();
  }

  private optimize(): void {
    this.getAll().forEach(item => {
      item.onOptimize();
    });
  }

  private recover(): void {
    this.getAll().forEach(item => {
      item.onRecover();
    });
  }

  /**
   * 设置优化器是否使能
   *
   * @param enable 优化器是否使能
   */
  public setEnable(enable: boolean): void {
    this.enable = enable;
  }

  public getEnableState(): MemoryStateEx<boolean> {
    return this.active;
  }
}

@Observed
export class MemoryStateEx<T> {
  private _value: T;

  /**
   * @param defaultVal 默认值
   * @param logMsg 日志描述 传了之后变量修改时会打印日志
   */
  constructor(defaultVal: T, logMsg: string = '') {
    this._value = defaultVal;
  }

  get value(): T {
    return this._value;
  }

  set value(val: T) {
    if (this._value !== val) {
      this._value = val;
    }
  }
}