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
  EvtBus,
  Event,
  EventListener,
  EventProduce,
  QuickOff
} from '@ohos/frameworkwrapper/src/main/ets/eventbus/EventBus';

/**
 * 内部事件管理器
 */
export class InnerEventUtil {
  private static listenerMap: Map<Event<Object>, Map<EventListener<Object>, QuickOff>> = new Map();

  /**
   * 注册事件
   *
   * @param event 事件类型
   * @param listener 事件回调器
   * @return 链式
   */
  public static on<T>(event: Event<T>, listener: EventListener<T>): typeof InnerEventUtil {
    this.register(event, listener, () => EvtBus.on(event, listener));
    return this;
  }

  /**
   * 注册事件生产者
   *
   * @param event 事件类型
   * @param produce 生产者
   * @return 链式
   */
  public static produceOn<T>(event: Event<T>, produce: EventProduce<T>): typeof InnerEventUtil {
    this.register(event, produce, () => EvtBus.produceOn(event, produce));
    return this;
  }

  /**
   * 发送事件
   *
   * @param event 事件类型
   * @param data 事件对象
   */
  public static post<T>(event: Event<T>, data: T): void {
    EvtBus.post(event, data);
  }

  /**
   * 注销事件
   *
   * @param event 事件类型
   * @param listener 事件回调器
   * @return 链式
   */
  public static off<T>(event: Event<T>, listener: EventListener<T>): typeof InnerEventUtil {
    if (!this.listenerMap.has(event)) {
      return this;
    }
    const quickOff = this.listenerMap.get(event).get(listener);
    if (quickOff) {
      quickOff();
      this.listenerMap.get(event).delete(listener);
      if (!this.listenerMap.get(event).size) {
        this.listenerMap.delete(event);
      }
    }
    return this;
  }

  private static register<T>(event: Event<T>, listener: EventListener<T> | EventProduce<T>, registerFn: () => QuickOff): void {
    if (!this.listenerMap.has(event)) {
      this.listenerMap.set(event, new Map());
    }
    // 避免重复监听
    if (this.listenerMap.get(event).has(listener)) {
      return;
    }
    const quickOff = registerFn();
    this.listenerMap.get(event).set(listener, quickOff);
  }
}