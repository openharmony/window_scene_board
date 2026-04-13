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

import {
  EventListener,
  EventManager,
  EventProduce,
  Event,
  EvtBus,
  QuickOff
} from '@ohos/frameworkwrapper';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'StatusBarEventManager';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 状态栏事件管理类
 * 管理状态栏事件分发
 *
 * @since 2024-7-28
 */
export class StatusBarEventManager extends Map<string, EventManager> {
  private static mInstance: StatusBarEventManager;
  private listeners: Map<string, Map<StatusBarEventId, Set<EventListener<Object>>>> = new Map();

  public static getInstance(): StatusBarEventManager {
    if (!StatusBarEventManager.mInstance) {
      StatusBarEventManager.mInstance = new StatusBarEventManager();
    }
    return StatusBarEventManager.mInstance;
  }

  /**
   * 注册外部事件监听，用于模块间通信
   *
   * @param key key值
   * @param event 事件类型
   * @param listener 事件回调器
   * @param produceParam 注册者参数
   * @return 链式
   */
  on<T>(key: string, event: Event<T> | Event<T>[], listener: EventListener<T>,
    produceParam?: string | undefined): StatusBarEventManager {
    let manager = super.get(key);
    if (!manager) {
      manager = EvtBus.createEventManager();
      super.set(key, manager);
    }
    manager.on(event, listener, produceParam);
    return this;
  }

  /**
   * 发送事件
   *
   * @param data 事件对象
   */
  post<T>(event: Event<T>, data: T): void {
    if (CommonUtils.isInvalid(data) || CommonUtils.isInvalid(event)) {
      log.showDebug('post invalid');
      return;
    }
    EvtBus.post(event, data);
  }

  /**
   * 注册事件生产者，用于模块间通信
   *
   * @param key key值
   * @param event 事件类型
   * @param produce 生产者
   * @return 链式
   */
  produceOn<T>(key: string, event: Event<T>, produce: EventProduce<T>): StatusBarEventManager {
    let manager = super.get(key);
    if (!manager) {
      manager = EvtBus.createEventManager();
      super.set(key, manager);
    }
    manager.produceOn(event, produce);
    return this;
  }

  /**
   * 注销所有已注册的事件
   *
   * @param key值
   */
  offAll(key: string): void {
    super.get(key)?.offAll();
    this.listeners.get(key)?.clear();
  }

  /**
   * 添加快速注销外部监听
   *
   * @param key值
   * @param off 快速注销
   * @return 链式
   */
  addOff(key: string, off: QuickOff): StatusBarEventManager {
    let manager = super.get(key);
    if (!manager) {
      manager = EvtBus.createEventManager();
      super.set(key, manager);
    }
    manager.addOff(off);
    return this;
  }

  /**
   * 状态栏内部事件监听，用于状态栏内部通信
   *
   * @param key值
   * @param eventId 状态栏事件id
   * @param listener 状态栏事件监听器
   */
  onSpecial<T extends Object>(key: string, eventId: StatusBarEventId,
    listener: EventListener<T>): StatusBarEventManager {
    let listeners = this.listeners.get(key);
    if (!listeners) {
      listeners = new Map();
      this.listeners.set(key, listeners);
    }
    let listenerSet = listeners.get(eventId);
    if (!listenerSet) {
      listenerSet = new Set();
      listeners.set(eventId, listenerSet);
    }
    listenerSet.add(listener as EventListener<Object>);
    return this;
  }
  /**
   * 状态栏内部事件监听注销
   *
   * @param key值
   * @param eventId 状态栏事件id
   * @param listener 状态栏事件监听器
   * **/
  offSpecial<T extends Object>(key: string, eventId: StatusBarEventId, listener: EventListener<T>): void {
    let listeners = this.listeners.get(key)!;
    if (!listener) {
      log.showWarn(`Listeners of ${key} is empty.`);
      return;
    }
    let listenerSet = listeners.get(eventId);
    if (!listenerSet) {
      log.showWarn(`${eventId} listeners of ${key} is empty.`);
      return;
    }
    listenerSet.delete(listener as EventListener<Object>);
  }

  /**
   * 发送状态栏内部事件，用于状态栏内部通信
   *
   * @param eventId 状态栏事件id
   * @param data 状态栏事件数据
   */
  postSpecial<T extends Object>(eventId: StatusBarEventId, data: T): void {
    if (CommonUtils.isInvalid(data)) {
      log.showDebug('post invalid data');
      return;
    }
    this.listeners.forEach((listener, key) => {
      listener.get(eventId)?.forEach((callback) => {
        callback(data);
      });
    });
  }
}

export enum StatusBarEventId {
  CUSTOM_EVENT = 'CUSTOM_EVENT',
  PLUGIN_AREA_EVENT = 'PLUGIN_AREA_EVENT',
  PLUGIN_CHANGE_EVENT = 'PLUGIN_CHANGE_EVENT',
  CAPSULE_SORT_EVENT = 'CAPSULE_SORT_EVENT',
  PANEL_CHANGE_EVENT = 'PANEL_CHANGE_EVENT',
  PLUGIN_DRAG_EVENT = 'PLUGIN_DRAG_EVENT'
}