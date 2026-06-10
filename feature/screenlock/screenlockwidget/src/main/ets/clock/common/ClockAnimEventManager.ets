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

import { sEventManager, unsubscribe } from '@ohos/frameworkwrapper';
import { HashSet } from '@kit.ArkTS';
import { LogDomain, Logger, LogHelper } from '@ohos/basicutils';

const TAG = 'ClockAnimEventManager';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

/**
 * 时钟一镜到底事件管理类
 */
export class ClockAnimEventManager {
  private unsubscribeSet: HashSet<unsubscribe> = new HashSet();

  /**
   * 订阅时钟一镜到底事件
   *
   * @param eventKey 事件名
   * @param fun 回调
   */
  public subscribeClockEvent(eventKey: string, fun: (val: number) => void): void {
    this.unsubscribeSet.add(
      sEventManager.subscribe(eventKey, (val: number) => {
          log.showInfo(TAG, `oneShot receive: ${eventKey}`);
          try {
            fun?.(val);
          } catch (e) {
            log.showInfo(TAG, `oneShot receive error. : ${eventKey}, msg: ${e?.message}`);
          }
        })
    );
  }

  /**
   * 事件取消注册
   */
  public unsubscribeClockEvent(): void {
    log.showInfo(TAG, 'unsubscribeForOneShotAnim');
    for (let item of this.unsubscribeSet) {
      if (item && typeof item === 'function') {
        item();
      }
    }
    this.unsubscribeSet.clear();
  }

  /**
   * 当前是否已经注册过事件
   *
   * @returns boolean
   */
  public isEmpty(): boolean {
    return this.unsubscribeSet.isEmpty();
  }
}