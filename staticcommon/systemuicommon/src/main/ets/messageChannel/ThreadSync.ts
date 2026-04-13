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

import { SystemUICommonUtil } from '../utils/SystemUICommonUtil';
import { cloneSerializableProperties, messageChannel } from './MessageChannel';
import util from '@ohos.util';
import { LogDomain, LogHelper, ThreadUtil } from '@ohos/basicutils/src/main/ets/TsIndex';
import { EventEmitter } from '../utils/EventEmitter';

const TAG = 'ThreadSync';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const TYPE_CHECKER = new util.types();

interface ThreadSyncData {
  name: string;
  obj: Record<string, Object>;
}

export interface ThreadSyncCallback {
  /**
   * 从对端同步数据过来并更新本端数据之后的回调
   */
  afterSync?(data?: Record<string, Object>): void;
}

/**
 * 线程间同步对象值的功能
 */
export class ThreadSync {
  /**
   * 装饰器 将vm标记为支持线程间同步
   * @param vm
   * @returns
   */
  public static VmDecorator<T extends { new(...args): {} }>(vm: T): T {
    return class extends vm {
      constructor(...args) {
        super(...args);
        const v1VmName: string = Reflect.get(this, 'threadSyncName') as string;
        // V1装饰器场景，vm.name为空字符串，需要手动指定名称，否则会同步失败
        return ThreadSync.create(this, vm?.name || v1VmName);
      }
    };
  }

  private static instanceMap: Record<string, ThreadSync> = {};

  /**
   * 本次同步的对象数据
   */
  private syncObj: Record<string, Object> = {};
  /**
   * 标记本次变化是否需要同步到对端线程。当变化是由对端线程同步导致的时候需要设置为false，避免形成同步死循环
   */
  private isNeedSync: boolean = true;

  /**
   * 初始化
   */
  public static init(): void {
    try {
      messageChannel.onMessage<ThreadSyncData>(TAG, (data) => {
        ThreadSync.instanceMap[data.name]?.doSync(data.obj);
      });

      if (ThreadUtil.isMainThread) {
        // 主线程场景，监听子线程请求vm数据同步（子线程初始化或重启时同步数据）
        messageChannel.onMessage<string>('syncFormMain', (name) => {
          ThreadSync.instanceMap[name]?.syncFormMain();
        });
      }
    } catch (e) {
      log.error('Init error:', e);
    }
  }

  /**
   * 创建一个对象的代理，被代理的对象会在线程间同步所有字段的属性值
   * @param target 被代理的对象
   * @returns 新的代理对象
   */
  public static create<T extends Object>(target: T, name?: string): T {
    const targetName = name ?? target.constructor.name;
    if (!targetName) {
      log.error(`targetName is empty: ${targetName}`);
      return target;
    }
    const handler: ProxyHandler<T> = {};
    const proxy = new Proxy<T>(target, handler);
    ThreadSync.instanceMap[targetName] = new ThreadSync(targetName, proxy, handler);

    if (!ThreadUtil.isMainThread) {
      // 子线程vm初始化时，通知主线程将vm的数据同步至子线程
      messageChannel.sendMessage<string>('syncFormMain', name);
    }
    return proxy;
  }

  /**
   * 主线程将vm数据同步至子线程
   */
  public syncFormMain = (): void => {
    let tmpSyncObj: Record<string, Object> = {};
    cloneSerializableProperties(this.proxy, tmpSyncObj, (key, value): boolean => {
      return this.syncIgnoreProp(value);
    });
    /* 为了确保Monitor能够触发，去除key中的__ob_前缀 */
    Object.keys(tmpSyncObj).forEach(key => {
      const realKey = this.getRealKey(key);
      this.syncObj[realKey] = tmpSyncObj[key];
    });
    this.sendSyncMessage();
  };

  /**
   * 对于ObserveV2装饰的类来说，获取的getOwnPropertyNames获取的字段包含__ob_，在同步时需要去除，否则会导致Monitor不会触发
   * @param key 字段
   * @returns 去除到__ob_前缀的key字段
   */
  private getRealKey(key: string): string {
    return key.replace(/^__ob_/, '');
  }

  /**
   * 构造线程同步实例
   * @param name 同步对象名称
   * @param proxy 目标代理对象值
   * @param handler 目标代理对象Proxy handler
   */
  private constructor(private name: string, private proxy: Object, private handler: ProxyHandler<Object>) {
    this.setHandler();
  }

  private setHandler(): void {
    this.handler.set = (target: Object, prop: string, value: Object): boolean => {
      if (target[prop] === value) {
        return true;
      }

      if (this.isTraceInnerProp(prop, value)) {
        return true;
      }

      target[prop] = value;
      if (typeof prop === 'string' && typeof value !== 'function' && this.isNeedSync) {
        if (Array.isArray(value)) {
          // 数组类型结构赋值一份，否则会序列化失败
          this.syncObj[prop] = [...value];
        } else {
          this.syncObj[prop] = value;
        }
        this.sendSyncMessage();
      }
      return true;
    };
    log.showInfo(`Set handler for ${this.name} success`);
  }

  private sendSyncMessage = SystemUICommonUtil.debouncePromise((): void => {
    messageChannel.sendMessage<ThreadSyncData>(TAG, { name: this.name, obj: this.syncObj });
    this.syncObj = {};
  });

  private doSync(data: Record<string, Object>): void {
    this.isNeedSync = false;
    try {
      for (const key of Object.keys(data)) {
        if (this.proxy[key] !== data[key]) {
          this.proxy[key] = data[key];
        }
      }
      (this.proxy as ThreadSyncCallback).afterSync?.(data);
    } catch (e) {
      log.error(`Dn sync for ${this.name} error:`, e);
    }
    this.isNeedSync = true;
  }

  /**
   * 数组类型的成员属性，@Trace装饰会生成内部对象，无需处理同步，否则postMessage会序列化失败。
   * @param prop
   * @returns
   */
  private isTraceInnerProp(prop: string, value: Object): boolean {
    return Array.isArray(value) && typeof prop === 'string' && prop.startsWith('__ob_');
  }

  /**
   * 无法序列化的类和对象，避免同步后覆盖对端导致异常
   * @param value
   * @returns
   */
  private syncIgnoreProp(value: Object): boolean {
    return TYPE_CHECKER.isProxy(value) || TYPE_CHECKER.isPromise(value) || value instanceof EventEmitter;
  }
}