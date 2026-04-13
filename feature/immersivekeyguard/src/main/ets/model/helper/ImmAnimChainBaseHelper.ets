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

import { IImmAnimChainVm } from '../../common/interface/IImmAnimChainVm';
import { IImmersiveNtfVmInjector } from '../../common/interface/IImmersiveNtfVmInjector';
import { ImmAnimBaseChain } from './chain/ImmAnimBaseChain';

/**
 * 沉浸模块生命周期动效检测器链条辅助工具基类
 */
export abstract class ImmAnimChainBaseHelper<S extends string, T extends ImmAnimBaseChain<S>>
  implements IImmAnimChainVm<S> {
  // 动效检测器根节点
  private rootChain?: T;

  // 通用注入器
  protected readonly vmInjector: IImmersiveNtfVmInjector;

  constructor(vmInjector: IImmersiveNtfVmInjector) {
    this.vmInjector = vmInjector;
  }

  /**
   * 初始化时加入检测链条
   */
  init(): void {
    this.initAddChain();
  }

  /**
   * 资源回收
   */
  destroy(): void {
    // 清空链条
    this.rootChain = undefined;
  }

  /**
   * 检测生命周期动效
   *
   * @returns 动效场景
   */
  checkLifeCycleAnim(): S | undefined {
    return this.rootChain?.checkLifeCycleAnim();
  }

  /**
   * 初始化添加动效检测链条
   */
  protected abstract initAddChain(): void;

  /**
   * 添加动效检测链条
   *
   * @param chain 动效检测链条
   */
  protected addAnimChain(chain: T): void {
    if (!this.rootChain) {
      this.rootChain = chain;
      return;
    }
    this.rootChain.addNextChain(chain);
  }
}