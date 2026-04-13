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

import { WAnimScene } from '@ohos/screenlockcommon';
import { AnimMgr } from '@ohos/screenlockcommon/Index';
import { IImmersiveNtfVmInjector } from '../../../../common/interface/IImmersiveNtfVmInjector';
import { IImmLifeCycleAnim } from '../../../../common/interface/IImmLifeCycleAnim';
import { ImmBaseAnimConfig } from '../../../../model/data/config/ImmBaseAnimConfig';
import { ImmBasePropertyConfig } from '../../../../model/data/config/ImmBasePropertyConfig';

/**
 * 沉浸模块生命周期动效基类
 */
export abstract class ImmBaseLifeCycleAnim<T extends ImmBasePropertyConfig<T>, S extends ImmBaseAnimConfig<T, S>>
  implements IImmLifeCycleAnim {
  // 动效启动场景
  private readonly animStartScene: WAnimScene;

  // 动效结束场景
  private readonly animFinishScene: WAnimScene;

  // 动效配置
  protected readonly animCfg: S;

  // 注入器
  protected vmInjector?: IImmersiveNtfVmInjector;

  constructor(vmInjector: IImmersiveNtfVmInjector) {
    this.vmInjector = vmInjector;
    let animScene = this.getAnimScene();
    this.animStartScene = { animScene: animScene, isAnimating: true };
    this.animFinishScene = { animScene: animScene, isAnimating: false };
    this.animCfg = this.createAnimCfg();
    this.initCfg();
  }

  /**
   * 动效场景
   *
   * @returns 场景标识
   */
  public abstract getAnimScene(): string;

  /**
   * 动效触发
   */
  public onLifeCycleAnim(): void {
    // 开启动效
    this.animCfg?.startAnim(this.getAnimMgr());
  }

  /**
   * 动效配置实例构造
   *
   * @returns 动效配置
   */
  protected abstract createAnimCfg(): S;

  /**
   * 初始化动效配置
   */
  protected abstract initCfg(): void;

  /**
   * 动效执行器
   *
   * @returns 动效执行器
   */
  protected getAnimMgr(): AnimMgr | undefined {
    return this.vmInjector?.getImmersiveWholeAnimVm()?.getAnimExeMgr();
  }

  /**
   * 动效启动场景
   *
   * @returns 动效场景
   */
  protected getAnimStartScene(): WAnimScene {
    return this.animStartScene;
  }

  /**
   * 动效结束场景
   *
   * @returns 动效场景
   */
  protected getAnimFinishScene(): WAnimScene {
    return this.animFinishScene;
  }
}