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

import { IImmComVm } from '../../../common/interface/IImmComVm';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmLifeCycleAnimChain } from './IImmLifeCycleAnimChain';

/**
 * 沉浸模块生命周期动效检测链条基类
 */
export class ImmAnimBaseChain<T extends string> implements IImmLifeCycleAnimChain {
  // 通用注入器
  protected readonly ntfInjector: IImmersiveNtfVmInjector;

  // 链条下游检测器
  protected nextChain?: ImmAnimBaseChain<T>;

  constructor(ntfInjector: IImmersiveNtfVmInjector) {
    this.ntfInjector = ntfInjector;
  }

  /**
   * 添加检测链条
   *
   * @param nextChain 下游链条
   */
  public addNextChain(nextChain: ImmAnimBaseChain<T>): void {
    if (this.nextChain) {
      this.nextChain.addNextChain(nextChain);
      return;
    }
    this.nextChain = nextChain;
  }

  /**
   * 生命周期动效检测
   *
   * @returns 动效场景
   */
  public checkLifeCycleAnim(): T | undefined {
    // 交由下游处理
    return this.nextChain?.checkLifeCycleAnim();
  }

  /**
   * 通用能力
   *
   * @returns 通用能力
   */
  protected getImmComVm(): IImmComVm {
    return this.ntfInjector?.getImmComVm();
  }
}