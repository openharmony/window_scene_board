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

import { IImmAnimFactory } from '../../../../common/interface/IImmAnimFactory';
import { IImmBaseAnim } from '../../../../common/interface/IImmBaseAnim';
import { IImmersiveNtfVmInjector } from '../../../../common/interface/IImmersiveNtfVmInjector';

/**
 * 沉浸锁屏模块动效工厂基类
 */
export abstract class ImmBaseAnimFactory<T extends IImmBaseAnim, S = string> implements IImmAnimFactory<T, S> {
  // 通用业务注入器
  protected readonly vmInjector: IImmersiveNtfVmInjector;

  // 动效实例缓存
  private readonly animMap: Map<S, T> = new Map();

  constructor(vmInjector: IImmersiveNtfVmInjector) {
    this.vmInjector = vmInjector;
  }

  public createImmAnim(animScene: S): T | undefined {
    // 优先取用缓存动效
    let cacheAnim = this.animMap.get(animScene);
    if (cacheAnim) {
      return cacheAnim;
    }
    // 新构造动效实例，并缓存
    let newAnim = this.createAnim(animScene);
    if (newAnim) {
      this.animMap.set(animScene, newAnim);
    }
    return newAnim;
  }

  /**
   * 创建对应场景的动效实例
   *
   * @param animScene 动效场景
   * @returns 动效实例
   */
  protected abstract createAnim(animScene: S): T | undefined;
}