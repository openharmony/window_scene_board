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

import emitter from '@ohos.events.emitter';
import { Logger } from './Logger';

const TAG: string = 'EventEmitter';
type EventType = string | boolean | number | bigint | null | undefined | object;

/**
 * 封装Emitter进行线程间通信
 */
export class EventEmitter {
  /**
   * 发送事件，立即发送
   * @param eventId
   * @param eventData
   */
  public static emit(eventId: string, eventData?: EventType): void {
    Logger.info(TAG, `emit:eventId = ${eventId} `);
    emitter.emit(
      // 发送的事件ID，不支持空字符串
      eventId,
      // 事件优先级,IMMEDIATE:表示事件被立即发送
      {
        priority: emitter.EventPriority.IMMEDIATE
      },
      // 事件携带的数据
      {
        data: {
          'eventData': eventData
        }
      });
  }

  /**
   * 订阅事件
   * @param eventId
   * @param callBack
   */
  public static on<T extends EventType>(eventId: string, callBack?: (data: T) => void): void {
    emitter.on(
      eventId,
      (eventData) => {
        if (callBack) {
          Logger.info(TAG, `on:eventId = ${eventId}`);
          callBack(eventData?.data?.eventData);
        }
      });
  }

  /**
   * 取消订阅
   * @param eventId
   */
  public static off(eventId: string): void {
    Logger.info(TAG, `off:eventId = ${eventId}`);
    emitter.off(eventId);
  }
}