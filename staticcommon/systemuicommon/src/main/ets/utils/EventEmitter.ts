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

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'EventEmitter');

type Listener = (data: Object) => void;

/**
 * 事件监听和触发机制
 */
export class EventEmitter<EventDefinition> {
  private listenerMap: Map<keyof EventDefinition, Set<Listener>> = new Map();

  /**
   * 监听事件
   * @param eventName 事件名称
   * @param listener 事件监听函数
   */
  public on<M extends keyof EventDefinition>(eventName: M, listener: (data: EventDefinition[M]) => void): void {
    if (!this.listenerMap.has(eventName)) {
      this.listenerMap.set(eventName, new Set());
    }
    this.listenerMap.get(eventName)!.add(listener);
  }

  /**
   * 取消监听事件
   * @param eventName 事件名称
   * @param listener 事件监听函数
   */
  public off<M extends keyof EventDefinition>(eventName: M, listener: (data: EventDefinition[M]) => void): void {
    if (!this.listenerMap.has(eventName)) {
      this.listenerMap.set(eventName, new Set());
    }
    this.listenerMap.get(eventName)!.delete(listener);
  }

  /**
   * 取消所有监听事件
   */
  public offAll(): void {
    this.listenerMap.clear();
  }

  /**
   * 向对端线程发送消息，不需要等待结果
   * @param eventName 消息名称
   * @param data 消息携带的数据
   */
  public emit<M extends keyof EventDefinition>(eventName: M, data: EventDefinition[M]): void {
    const listeners = this.listenerMap.get(eventName);
    if (listeners) {
      listeners.forEach((listener) => {
        try {
          listener(data);
        } catch (e) {
          log.error(`Diapatch event for ${eventName as string} error code:` + e?.code + ', message:' + e?.message);
        }
      });
    }
  }
}