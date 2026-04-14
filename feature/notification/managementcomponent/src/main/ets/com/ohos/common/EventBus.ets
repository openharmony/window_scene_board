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

import { LogDomain, LogHelper, SingletonHelper } from './BasicCommon';

const TAG = 'SysUI_EventBus';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 快速取消事件监听
 */
export type QuickOff = () => void;

/**
 * 事件监听回调器
 */
export type EventListener<T> = (data: T) => void;

/**
 * 事件生产器，用于注册时事件及时回调
 */
export type EventProduce<T> = (param?: string) => T;

/**
 * 事件类型，事件的构造函数
 */
export interface Event<T> {
  eventTypeName: string;
}

/**
 * 事件快速注销集
 * function存在bind的用法，没有bind都会是一个新对象，
 * 若on和off各自bind，将无法正常注销，可采用收集QuickOff的方式一次性注销
 */
export class OffList {
  /**
   * QuickOff集
   */
  private offList: Set<QuickOff>;

  /**
   * 构造
   */
  constructor() {
    this.offList = new Set();
  }

  /**
   * 添加off集
   *
   * @param offs off集
   * @return 链式
   */
  add(...offs: QuickOff[]): OffList {
    if (!offs || offs.length === 0) {
      return this;
    }
    offs.forEach((off) => {
      if (!off) {
        return;
      }
      this.offList.add(off);
    });
    return this;
  }

  /**
   * 全部清除
   */
  clear(): void {
    this.offList.forEach((off) => {
      off();
    });
    this.offList.clear();
  }
}

/**
 * 事件总线
 *
 * @since 2022-09-15
 */
class EventBus {
  /**
   * 事件监听集
   */
  private listenerMap: Map<string, Set<EventListener<Object>>> = new Map();

  /**
   * 事件生产集
   */
  private produceMap: Map<string, Set<EventProduce<Object>>> = new Map();

  /**
   * 创建多事件管理器
   *
   * @return 多事件管理器
   */
  createEventManager(): EventManager {
    return new EventManager();
  }

  /**
   * 注册事件监听
   *
   * @param event 需监听事件
   * @param listener 事件监听器
   * @param produceParam 生产者参数
   * @return 快速取消该事件监听
   */
  on<T>(event: Event<T> | Event<T>[], listener: EventListener<T>, produceParam?: string): QuickOff {
    if (!event || !listener) {
      log.showDebug('on invalid event');
      return () => {
      };
    }
    // 事件集
    if (Array.isArray(event)) {
      event.forEach((ev) => this.on(ev, listener));
    } else { // 单一事件
      // 键值
      let evKey = this.getEventKey(event);
      if (!evKey) {
        log.showError(`on invalid event key: ${evKey}`);
        return () => {
        };
      }
      let listenerSet = this.listenerMap.get(evKey);
      if (!listenerSet) {
        listenerSet = new Set();
        this.listenerMap.set(evKey, listenerSet);
      }
      listenerSet.add(listener as EventListener<Object>);
      // 存在生产者，则即时回调一次
      let produces = this.produceMap.get(evKey);
      if (!produces || produces.size === 0) {
        return () => this.off(event, listener);
      }
      // 不同的生产者事件属性会不一样
      produces.forEach((produce) => {
        let data = produce(produceParam) as T;
        if (!data) {
          return;
        }
        listener(data);
      });
    }
    return () => this.off(event, listener);
  }

  /**
   * 注册事件监听，一次回调
   *
   * @param event 需监听事件
   * @param listener 事件监听器
   * @param produceParam 生产者参数
   * @return 快速取消该事件监听
   */
  once<T>(event: Event<T> | Event<T>[], listener: EventListener<T>, produceParam?: string): QuickOff {
    if (!event || !listener) {
      log.showDebug('once invalid');
      return () => {
      };
    }
    return this.on(event, (data: T) => {
      listener(data);
      this.off(event, listener);
    }, produceParam);
  }

  /**
   * 注销事件监听
   *
   * @param event 需监听事件
   * @param listener 事件监听器
   */
  off<T>(event: Event<T> | Event<T>[], listener: EventListener<T>): void {
    if (!event) {
      return;
    }
    if (Array.isArray(event)) {
      event.forEach((ev) => this.off(ev, listener));
      return;
    }
    let evKey = this.getEventKey(event);
    if (!evKey) {
      log.showError(`off invalid event key: ${evKey}`);
      return;
    }
    let delResult = this.listenerMap.get(evKey)?.delete(listener as EventListener<Object>);
    log.showDebug(`off result ${delResult}, event ${evKey}`);
  }

  /**
   * 发送事件
   *
   * @param data 事件对象
   */
  post<T>(event: Event<T>, data: T): void {
    if (!data) {
      log.showDebug('post invalid data');
      return;
    }
    let evKey = this.getEventKey(event);
    if (!evKey) {
      log.showError(`post invalid event key: ${evKey}`);
      return;
    }
    this.listenerMap.get(evKey)?.forEach((listener) => {
      listener(data);
    });
  }

  /**
   * 注册事件生产者
   *
   * @param event 需生产事件
   * @param produce 事件生产者
   * @return 快速取消该事件生产
   */
  produceOn<T>(event: Event<T>, produce: EventProduce<T>): QuickOff {
    if (!event || !produce) {
      log.showDebug(`produceOn invalid event ${typeof event}`);
      return () => {
      };
    }
    let evKey = this.getEventKey(event);
    if (!evKey) {
      log.showError(`on invalid event key: ${evKey}`);
      return () => {
      };
    }
    // 一个事件允许多个生产者
    let set = this.produceMap.get(evKey);
    if (!set) {
      set = new Set();
      this.produceMap.set(evKey, set);
    }
    set.add(produce as EventProduce<Object>);
    return () => this.produceOff(event, produce);
  }

  /**
   * 注销事件生产者
   *
   * @param event 需生产事件
   * @param produce 事件生产者
   */
  produceOff<T>(event: Event<T>, produce: EventProduce<T>): void {
    if (!event) {
      return;
    }
    let evKey = this.getEventKey(event);
    if (!evKey) {
      log.showError(`produceOff invalid event key: ${evKey}`);
      return;
    }
    let delResult = this.produceMap.get(evKey)?.delete(produce as EventProduce<Object>);
    log.showDebug(`produceOff result ${delResult}, event ${evKey}`);
  }

  /**
   * 事件唯一标示
   *
   * @param event 事件
   */
  private getEventKey<T>(event: Event<T>): string {
    let eventKey: Object | undefined = (event as EventParam).eventTypeName;
    if (!eventKey || typeof eventKey !== 'string') {
      log.showError('getEventKey error: event without eventTypeName');
      return '';
    }
    return eventKey as string;
  }
}

// 单例
export let evtBus: EventBus = SingletonHelper.getInstance(EventBus, TAG);

/**
 * 多事件统一管理器
 * 解决function采用bind形式造成的对象不一致问题
 */
export class EventManager {
  /**
   * 快速注销集
   */
  private offList: OffList;

  /**
   * 构造
   */
  constructor() {
    this.offList = new OffList();
  }

  /**
   * 注册事件
   *
   * @param event 事件类型
   * @param listener 事件回调器
   * @param produceParam 注册者参数
   * @return 链式
   */
  on<T>(event: Event<T> | Event<T>[], listener: EventListener<T>, produceParam?: string): EventManager {
    this.offList.add(evtBus.on(event, listener, produceParam));
    return this;
  }

  /**
   * 注册事件生产者
   *
   * @param event 事件类型
   * @param produce 生产者
   * @return 链式
   */
  produceOn<T>(event: Event<T>, produce: EventProduce<T>): EventManager {
    this.offList.add(evtBus.produceOn(event, produce));
    return this;
  }

  /**
   * 添加快速注销
   *
   * @param off 快速注销
   * @return 链式
   */
  addOff(off: QuickOff): EventManager {
    if (!off) {
      return this;
    }
    this.offList.add(off);
    return this;
  }

  /**
   * 注销所有已注册事件
   */
  offAll(): void {
    this.offList.clear();
  }
}

class EventParam {
  public eventTypeName?: Object;
}

