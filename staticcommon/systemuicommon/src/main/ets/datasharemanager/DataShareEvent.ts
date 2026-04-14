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
import { EvtBus, Event } from '@ohos/frameworkwrapper';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'DataShareEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 数据共享数据变化事件
 *
 * @since 2022-12-10
 */
export abstract class DataShareEvent<T> {
  /**
   * 事件class
   */
  private eventClass: Event<DataShareEvent<T>>;

  /**
   * 数据共享路径
   */
  dataShareUri: string;

  /**
   * 数据共享数据值
   */
  shareValue: T;

  /**
   * 是否调用同步查询
   */
  isAsyncQuery: boolean = false;

  /**
   * 构造
   *
   * @param event 事件class
   */
  constructor(event: Event<DataShareEvent<T>>) {
    this.eventClass = event;
  }

  /**
   * 获取事件class
   *
   * @return 事件class
   */
  getEventClass(): Event<DataShareEvent<T>> {
    return this.eventClass;
  }

  /**
   * 共享数据库对应数据变化回调
   */
  onDataChange(isAsync: boolean = false): Promise<void> {
    return new Promise<void>((resolve) => {
      try {
        // 刷新数据值
        this.isAsyncQuery = isAsync;
        this.refreshShareValue(isAsync).then((value) => {
          this.eventPost(isAsync, value);
          resolve();
        }).catch((error: BusinessError) => {
          log.showError('refresh share value error ' + error);
          resolve();
        });
      } catch (e) {
        log.showError('refresh share value catch error', e);
        resolve();
      }
    });
  }

  private eventPost(isAsync: boolean, value: T): void {
    if (!(!this.isAsyncQuery && isAsync)) {
      log.showDebug(`onDataChange isAsyncQuery ${this.isAsyncQuery}`);
      this.shareValue = value;
    }
    // 数据更新，发送事件
    EvtBus.post(this.eventClass, this);
  }

  /**
   * 刷新数据值
   */
  abstract refreshShareValue(isAsync?: boolean): Promise<T>;
}