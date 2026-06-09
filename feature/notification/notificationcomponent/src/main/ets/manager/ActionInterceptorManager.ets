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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CustomPromise } from '@ohos/frameworkwrapper';
import { Singleton } from '@ohos/systemuicommon/src/main/ets/utils/Singleton';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'ActionInterceptor');
const MAX_WAIT_TIME_MS = 5000;

/**
 * 拦截器
 */
export class ActionInterceptor {
  private iPromise?: CustomPromise<void>;
  private name: string;
  private isEnabled: boolean = true;
  constructor(name: string) {
    this.name = name;
  }
  public requestInterrupt(): void {
    if (!this.iPromise) {
      this.iPromise = new CustomPromise();
    }
  }

  public releaseInterrupt(): void {
    if (this.iPromise) {
      this.iPromise.resolve();
      this.iPromise = undefined;
    }
  }

  public async awaitInterrupt(): Promise<void> {
    if (!this.isEnabled) {
      return;
    }
    if (this.iPromise) {
      let timeoutId: number | undefined = setTimeout(() => {
        this.releaseInterrupt();
        log.showWarn(`${this.name} await to timeout.`);
      }, MAX_WAIT_TIME_MS);
      await this.iPromise;
      if (timeoutId) {
        clearTimeout(timeoutId);
        timeoutId = undefined;
      }
    }
  }

  // 设置是否启用拦截
  public setIsEnabled(isEnabled: boolean): void {
    this.isEnabled = isEnabled;
  }
}

/**
 * 拦截器统一管理
 */
export class ActionInterceptorManager {
  @Singleton.decorate()
  public static get instance(): ActionInterceptorManager { return new ActionInterceptorManager(); }

  private interceptors: Map<string, ActionInterceptor> = new Map();

  public setInterceptor(interceptorName: string): void {
    if (this.interceptors.has(interceptorName)) {
      return;
    }
    this.interceptors.set(interceptorName, new ActionInterceptor(interceptorName));
  }

  public getInterceptor(interceptorName: string): ActionInterceptor {
    return this.interceptors.get(interceptorName)!;
  }

  public clearInterrupt(interceptorName: string): void {
    this.interceptors.delete(interceptorName);
  }
}

