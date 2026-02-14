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
import { CommonUtils } from './CommonUtils';
import { LogDomain, LogHelper } from './LogHelper';

const TAG = 'ExtendMap';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class ExtendMap<T> {
  private multiInstanceMap: Map<number, Map<string, T> | T> = new Map();

  constructor() {
  }

  getData(slot: number, instanceName: string | undefined): T | undefined {
    if (CommonUtils.isInvalid(slot) || CommonUtils.isInvalid(instanceName)) {
      log.showError(`getData param invalid slot: ${slot} instanceName: ${instanceName}`);
      return undefined;
    }
    // 如果instanceName为空字符串，直接返回T; 如果不为空，则从map<string, T>查询返回T
    log.showInfo(`getData param slot: ${slot} instanceName: ${instanceName}`);
    if (!instanceName || instanceName === '') {
      let data = this.multiInstanceMap.get(slot) as T;
      log.showInfo(`getData param data1: ${slot} ${instanceName}`);
      return data;
    }
    let data = this.multiInstanceMap.get(slot) as Map<string, T>;
    if (data) {
      log.showInfo(`getData param data2: ${slot} ${instanceName}`);
      return data.get(instanceName as string);
    }
    return undefined;
  }

  setData(slot: number, instanceName: string, data: T): void {
    if (CommonUtils.isInvalid(slot) || CommonUtils.isInvalid(instanceName)) {
      log.showError(`setData param invalid slot: ${slot} instanceName: ${instanceName}`);
      return;
    }
    // 如果instanceName为空字符串，直接插入T; 如果不为空，设置往map<string, T>里插入T
    log.showInfo(`setData param slot: ${slot} instanceName: ${instanceName}`);
    if (instanceName === '') {
      this.multiInstanceMap.set(slot, data);
      log.showInfo(`setData param data1: ${slot} ${instanceName}`);
      return;
    }
    let instanceNameMap = this.multiInstanceMap.get(slot);
    if (!instanceNameMap) {
      instanceNameMap = new Map();
      this.multiInstanceMap.set(slot, instanceNameMap);
    }
    (instanceNameMap as Map<string, T>)?.set(instanceName, data);
    log.showInfo(`setData param data2: ${slot} ${instanceName}`);
  }

  deleteData(slot: number, instanceName: string): void {
    if (CommonUtils.isInvalid(slot) || CommonUtils.isInvalid(instanceName)) {
      log.showError(`deleteData param invalid slot: ${slot} instanceName: ${instanceName}`);
      return;
    }
    // 如果instanceName为空字符串，直接插入T; 如果不为空，设置往map<string, T>里插入T
    log.showInfo(`deleteData param slot: ${slot} instanceName: ${instanceName}`);
    if (instanceName === '') {
      this.multiInstanceMap.delete(slot);
      log.showInfo(`deleteData param data1: ${slot}`);
      return;
    }
    let instanceNameMap = this.multiInstanceMap.get(slot) as Map<string, T>;
    if (instanceNameMap) {
      instanceNameMap.delete(instanceName);
      log.showInfo(`deleteData param data2: ${slot} ${instanceName}`);
      if (instanceNameMap.size === 0) {
        this.multiInstanceMap.delete(slot);
        log.showInfo(`deleteData param data3: ${slot} ${instanceName}`);
      }
    }
  }

  hasData(slot: number, instanceName: string): boolean {
    if (CommonUtils.isInvalid(slot) || CommonUtils.isInvalid(instanceName)) {
      log.showError(`hasData param invalid slot: ${slot} instanceName: ${instanceName}`);
      return false;
    }
    // 如果instanceName为空字符串，直接插入T; 如果不为空，设置往map<string, T>里插入T
    log.showInfo(`hasData param slot: ${slot} instanceName: ${instanceName}`);
    if (instanceName === '') {
      log.showInfo(`hasData param data1: ${slot} ${instanceName}`);
      return this.multiInstanceMap.has(slot);
    }
    let instanceNameMap = this.multiInstanceMap.get(slot);
    if (instanceNameMap) {
      log.showInfo(`hasData param data2: ${slot} ${instanceName}`);
      return (instanceNameMap as Map<string, T>)?.has(instanceName);
    }
    return false;
  }

  getSize(): number {
    return this.multiInstanceMap.size;
  }

  forEach(callbackfn: (value: T, key: number, instanceKey: string) => void): void {
    this.multiInstanceMap.forEach((value, k1) => {
      if (value instanceof Map) {
        value.forEach((v, k2) => {
          callbackfn(v, k1, k2);
        });
      } else {
        callbackfn(value, k1, '');
      }
    });
  }
}