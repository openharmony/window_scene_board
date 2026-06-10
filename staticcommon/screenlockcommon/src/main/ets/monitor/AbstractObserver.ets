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

import HashSet from '@ohos.util.HashSet';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CommonUtil } from '../utils/CommonUtil';

const TAG = 'InterceptorManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
export type ObserverCallback<T> = (args?: T) => void;

export interface ILog {
  getLogTag(): string;
}

export enum ObserverStageEnum {
  INITIAL = 'INITIAL',
  BEFORE = 'BEFORE',
  PROCESSING = 'PROCESSING',
  AFTER = 'AFTER',
}

export abstract class AbstractObserver<T> implements ILog {
  private subscribers: Map<string, HashSet<ObserverCallback<T>>> = new Map();

  public getLogTag(): string {
    return this.constructor?.name || 'AbstractObserver';
  }

  public getSubscriberNames(): IterableIterator<string> {
    this.infoLog(`subscribers size=${this.subscribers?.size}`);
    return this.subscribers.keys();
  }

  public getSubscriberSize(key: string): number {
    const count: number | undefined = this.subscribers?.get(key)?.length;
    if (count === undefined) {
      return 0;
    }
    return count;
  }

  protected infoLog(msg: string): void {
    log.info(this.getLogTag(), msg);
  }

  protected debugLog(msg: string): void {
    log.debug(this.getLogTag(), msg);
  }

  protected needNotify(): boolean {
    return this.subscribers.size !== 0;
  }

  protected publishAtStage(stage: string, data?: T): void {
    this.debugLog(`start to publish at stage ${stage}`);
    CommonUtil.runWithoutException(this.getLogTag(), 'publishAtStage', () => {
      const stageSubscribers = this.subscribers.get(stage);
      this.debugLog(`stage [${stage}] size=${stageSubscribers?.length}`);
      if (!stageSubscribers) {
        return;
      }
      stageSubscribers?.forEach((callbackFn) => {
        this.debugLog('start to notify subscriber');
        callbackFn?.(data);
      });
    });
    this.debugLog(`end to publish at stage ${stage}`);
  }

  public subscribe(stage: string, callback: ObserverCallback<T>): void {
    if (!this.subscribers.has(stage)) {
      this.subscribers.set(stage, new HashSet());
    }
    const eventSubscribers = this.subscribers.get(stage);
    if (!eventSubscribers?.has(callback)) {
      eventSubscribers?.add(callback);
    }
    this.debugLog(`subscribe end,stage=[${stage}] size=${eventSubscribers?.length}`);
  }

  public unsubscribe(eventType: string, callback: ObserverCallback<T>): void {
    this.subscribers.get(eventType)?.remove(callback);
    this.debugLog(`unsubscribe end,stage=${eventType} size=${this.subscribers.get(eventType)?.length}`);
  }

  public unsubscribeAll(): void {
    this.subscribers = new Map();
    this.infoLog('unsubscribeAll');
  }

  public unsubscribeByType(eventType: string): void {
    this.subscribers.delete(eventType);
    this.infoLog(`unsubscribeByType ${eventType} end`);
  }
}

