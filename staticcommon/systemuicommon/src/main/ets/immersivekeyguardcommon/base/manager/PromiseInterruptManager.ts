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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { CustomPromise } from '@ohos/frameworkwrapper';
import { ImmersiveConstants } from '../../common/ImmersiveConstants';

const TAG = 'PromiseInterruptManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const DEFAULT_INTERRUPT = 'default_interrupt';
const MAX_WAIT_TIME_MS = 3000;

/**
 * 拦截器
 */
export class PromiseInterrupt {
  private static readonly DEFAULT: PromiseInterrupt = new PromiseInterrupt(DEFAULT_INTERRUPT); // 默认拦截器
  private readonly interruptName: string; // 拦截器标示
  private iPromise?: CustomPromise<void>; // Promise拦截

  private constructor(name: string) {
    this.interruptName = name;
  }

  public getInterruptName(): string { // 标示
    return this.interruptName;
  }

  public requestInterrupt(): void { // 请求拦截
    if (!this.iPromise) {
      this.iPromise = new CustomPromise();
    }
  }

  public releaseInterrupt(): void { // 释放拦截
    if (this.iPromise) {
      this.iPromise.resolve();
      this.iPromise = undefined;
    }
  }

  public async awaitInterrupt(): Promise<void> {
    // 拦截等待
    if (this.iPromise) {
      let timeoutId = setTimeout(() => {
        timeoutId = undefined;
        this.requestInterrupt();
        log.showError(TAG, 'Await to timeout.');
      }, MAX_WAIT_TIME_MS);
      await this.iPromise;
      if (timeoutId) {
        clearTimeout(timeoutId);
        timeoutId = undefined;
      }
    }
  }

  public hasInterrupt(): boolean { // 当前是否存在拦截器
    return this.iPromise !== undefined;
  }

  /**
   * 统一构造拦截器
   *
   * @param interruptName 拦截器名
   * @returns 拦截器
   */
  public static wrap(interruptName?: string): PromiseInterrupt {
    let name = interruptName ?? DEFAULT_INTERRUPT;
    if (name === DEFAULT_INTERRUPT) {
      return PromiseInterrupt.DEFAULT;
    }
    return new PromiseInterrupt(name);
  }
}

/**
 * 拦截器统一管理
 */
class PromiseInterruptManager {
  private interruptMap: Map<string, PromiseInterrupt> = new Map();

  public getInterrupt(name?: string): PromiseInterrupt {
    let interruptName = this.getInterruptName(name);
    let interrupt = this.interruptMap.get(interruptName);
    if (!interrupt) {
      interrupt = PromiseInterrupt.wrap(interruptName);
      this.interruptMap.set(interruptName, interrupt);
    }
    return interrupt;
  }

  public clearInterrupt(name?: string): void {
    let interruptName = this.getInterruptName(name);
    this.interruptMap.delete(interruptName);
  }

  public requestInterrupt(name?: string): void { // 请求拦截
    this.getInterrupt(name).requestInterrupt();
  }

  public releaseInterrupt(name?: string): void { // 释放拦截
    this.getInterrupt(name).releaseInterrupt();
  }

  public async awaitInterrupt(name?: string): Promise<void> { // 拦截等待
    await this.getInterrupt(name).awaitInterrupt();
  }

  private getInterruptName(name?: string): string {
    return name ?? DEFAULT_INTERRUPT;
  }
}

// 单例
export let interruptMgr: PromiseInterruptManager = SingletonHelper.getInstance(PromiseInterruptManager, TAG);