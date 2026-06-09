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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';

const TAG = 'RegisterAPIProtector';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);


type RetryCallback = (...args: Object[]) => void;

interface IFailedAPIs {
  callback: RetryCallback,
  args: Object[]
}

export class RegisterAPIProtector {
  public static get = SingletonHelper.createFactory(() => new RegisterAPIProtector);

  private failedAPIs: Map<string, IFailedAPIs> = new Map();

  public registerFailedAPI(apiKey: string, retryCallback: RetryCallback, ...args: Object[]): void {
    if (!this.failedAPIs.has(apiKey)) {
      this.failedAPIs.set(apiKey, { callback: retryCallback, args });
    }
  }

  public run(tag: string, apiName: string, callback: RetryCallback, ...args: Object[]): void {
    const apiKey: string = tag + '->' + apiName;
    try {
      log.showInfo(`register API: ${apiKey}`);
      callback(...args);
    } catch (error) {
      log.showError(`register API error. API: ${apiKey}, error: ${error.message}`);
      this.registerFailedAPI(apiKey, callback, ...args);
    }
  }

  public unRegisterFailedAPI(apiKey: string): void {
    if (this.failedAPIs.has(apiKey)) {
      this.failedAPIs.delete(apiKey);
    }
  }

  public retryFailedAPIs(): void {
    for (let item of this.failedAPIs.entries()) {
      const apiKey = item[0];
      const failedAPI = item[1];
      try {
        log.showInfo(`execute API: ${apiKey}`);
        const callback = failedAPI.callback;
        const args = failedAPI.args;
        callback(...args);
        this.failedAPIs.delete(apiKey);
      } catch (error) {
        log.showError(`register API error. API: ${apiKey}, error: ${error.message}`);
      }
    }
  }
}