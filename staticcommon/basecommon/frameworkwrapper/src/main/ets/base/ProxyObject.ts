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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { Props } from './CommonType';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'ProxyObject');
const proxyMap: WeakMap<ProxyTarget, ProxySource<Object>> = new WeakMap();

type ProxyObjectHandler<T> = {
  set: (target: T, key: keyof T, value: Object) => boolean;
};
type ProxyObjectSetter = (value: Object) => void;
type ProxyObjectItemWatcher<K> = (keys: Set<K>) => void;
type ObjectProxyItem<T, K extends keyof T = keyof T> = {
  /**
   * 字段值是否变脏，变脏后需要触发watcher
   */
  dirty: boolean;
  /**
   * 字段值变化监听
   */
  watchers: Set<ProxyObjectItemWatcher<K>>;
};
export type ProxyObjectPropsSetter<T> = {
  [P in keyof Props<T>]?: (value: T[P], obj: T) => boolean;
};

/**
 * 代理对象默认值的setter
 */
export const proxyDefaultSetter = (): boolean => true;

/**
 * 为对象添加一层代理，可以监听字段值的变化
 */
export class ProxySource<T extends Object, K extends keyof T = keyof T> {
  private proxySetterMap: Map<ProxyTarget, Map<keyof T, ProxyObjectSetter>> = new Map();
  private items: Map<K, ObjectProxyItem<T>> = new Map();
  private dispatcher?: Promise<void>;

  /**
   * 静默更新标志，静默更新时不触发watcher
   */
  private isSilent = false;

  public readonly value: T;

  constructor(obj: T) {
    const handler: ProxyObjectHandler<T> = {
      set: (target: T, key: K, value: T[K]): boolean => {
        if (!this.isSilent && this.items.has(key) && value !== target[key]) {
          this.items.get(key)!.dirty = true;
          this.dispatchWatcher();
        }
        target[key] = value;
        this.callSetter(key, value);
        return true;
      }
    };
    this.value = new Proxy(obj, handler as Object);
  }

  private callSetter(key: K, value: T[K]): void {
    for (const proxyItems of this.proxySetterMap.values()) {
      const setter = proxyItems.get(key);
      if (!setter) {
        continue;
      }
      try {
        setter(value);
      } catch (e) {
        log.error(`Call setter for ${key as string} error:`, e);
      }
    }
  }

  /**
   * 创建一个源对象的代理子对象，即由部分源对象字段组成的子对象
   *
   * @param proxyTarget 源对象子字段组成的类
   * @param propsSetter 对象字段的setter集合，示例如下：
   * {
   *   target: (value, obj): boolean => { // 返回值为true表示该字段会更新到对象上，返回false则不更新，默认行为可不写
   *     return value === obj.target;
   *   },
   *   progress: (value, obj): boolean => {
   *     if (obj.target !== XXX) { // 如果目标不满足条件则不更新字段
   *       return false;
   *     }
   *     return value === obj.progress;
   *   },
   * }
   *
   * @returns 一个代理后的对象
   */
  public createProxy<ST extends ProxyTarget>(
    proxyTarget: ST,
    propsSetter?: ProxyObjectPropsSetter<T | ST>
  ): ST {
    const proxyItems: Map<keyof T, ProxyObjectSetter> = new Map();

    if (!propsSetter) {
      propsSetter = {};
      for (const key of Object.keys(proxyTarget)) {
        propsSetter[key] = proxyDefaultSetter;
      }
    }
    for (const key of Object.keys(propsSetter)) {
      // 为每一个字段设置setter拦截器，当源对象的值更新时，调用它检查是否需要更新到代理对象上，减少更新频率，降低对UI的影响
      proxyItems.set(key as K, (value: T[K]) => {
        const setter = propsSetter[key];
        if ((setter === proxyDefaultSetter && value !== proxyTarget[key]) || setter(value, proxyTarget)) {
          proxyTarget[key] = value;
        }
      });
      Object.defineProperty(proxyTarget, key, {
        enumerable: true,
        configurable: false,
        writable: true,
        value: this.value[key],
      });
    }
    this.proxySetterMap.set(proxyTarget, proxyItems);
    proxyMap.set(proxyTarget, this as unknown as ProxySource<Object>);

    return proxyTarget;
  }

  /**
   * 销毁代理对象
   *
   * @param proxyTarget
   */
  public destroyProxy(proxyTarget: ProxyTarget): void {
    this.proxySetterMap.delete(proxyTarget);
    proxyMap.delete(proxyTarget);
  }

  /**
   * 监听代理对象值改变
   *
   * @param proxyObj 代理对象
   * @param keys 字段名集合
   * @param watcher 监听器
   */
  public addWatcher(keys: K[], watcher: ProxyObjectItemWatcher<K>): void {
    for (const key of keys) {
      if (!this.items.has(key)) {
        this.items.set(key, {
          dirty: false,
          watchers: new Set(),
        });
      }
      this.items.get(key)!.watchers.add(watcher);
    }
  }

  /**
   * 移除代理对象字段值监听
   *
   * @param proxyObj 代理对象
   * @param keys 字段名集合，传空时移除代理对象所有的监听器，否则仅移除传入keys的监听器
   * @param watcher 监听器，传空时keys所有的监听器，否则仅移除传入的监听器
   */
  public removeWatcher(keys?: K[], watcher?: ProxyObjectItemWatcher<K>): void {
    if (!keys?.length) {
      for (const key of this.items.keys()) {
        const item = this.items.get(key as K);
        if (item) {
          item.watchers = undefined;
        }
      }
    } else {
      for (const key of keys) {
        const item = this.items.get(key as K);
        if (!item) {
          continue;
        }
        if (watcher) {
          item.watchers?.delete(watcher);
        } else {
          item.watchers = undefined;
        }
      }
    }
  }

  /**
   * 静默更新对象，不触发watcher
   */
  public updateSilent(obj: T): void {
    this.isSilent = true;
    const tmpObj: Partial<T> = {};
    Object.keys(obj).forEach(key => {
      // 避免拷贝函数类型，会导致内存泄露
      if (typeof obj[key] === 'function') {
        return;
      }
      tmpObj[key] = obj[key];
    });

    Object.assign(this.value, tmpObj);
    this.isSilent = false;
  };

  /**
   * 触发监听器，以异步的方式触发，避免一个宏任务周期内多次值改变触发多次
   *
   * @param proxyManager
   */
  private async dispatchWatcher(): Promise<void> {
    if (this.dispatcher) {
      return;
    }
    // 创建一个promise并等待其resolve后触发监听器，保证在一个宏任务内多次值改变仅触发一次监听
    this.dispatcher = Promise.resolve();
    await this.dispatcher;
    this.dispatcher = undefined;

    // 一个监听器可能对应多个字段，因此以函数为key找出与其所有相关的字段变化，再一次性触发
    const watcherMap: Map<ProxyObjectItemWatcher<K>, Set<K>> = new Map();

    for (const key of this.items.keys()) {
      const item = this.items.get(key as K);
      if (!item?.dirty) {
        continue;
      }
      for (const watcher of item.watchers) {
        if (!watcherMap.has(watcher)) {
          watcherMap.set(watcher, new Set());
        }
        watcherMap.get(watcher)!.add(key as K);
      }
      item.dirty = false;
    }

    for (const watcher of watcherMap.keys()) {
      const keys = watcherMap.get(watcher)!;
      try {
        watcher(keys);
      } catch (e) {
        log.error(`Trigger watcher for [${Array.from(keys)}] error:`, e);
      }
    }
  }
}

/**
 * 从源对象代理出来的目标对象
 */
export class ProxyTarget {
  /**
   * 销毁代理对象
   */
  public static destroy(obj: ProxyTarget): void {
    proxyMap.get(obj)?.destroyProxy(obj);
  }

  /**
   * 销毁代理对象
   */
  public destroy(): void {
    proxyMap.get(this)?.destroyProxy(this);
  }
}
