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

import { IBaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import {
  WidgetAnimStateV2,
  WidgetStyleStateV2,
  WidgetCacheState,
  AnimMgr
} from '@ohos/screenlockcommon/Index';
import { IImmersiveAnimBaseVm } from '../../../common/interface/IImmersiveAnimBaseVm';
import { IImmersiveCapAnimVm } from '../../../common/interface/IImmersiveCapAnimVm';
import { IImmersiveCardAnimVm } from '../../../common/interface/IImmersiveCardAnimVm';
import { IImmersiveExtendVm } from '../../../common/interface/IImmersiveExtendVm';
import { IImmersiveListAnimVm } from '../../../common/interface/IImmersiveListAnimVm';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmersiveWholeAnimVm } from '../../../common/interface/IImmersiveWholeAnimVm';
import { ISlClockAnimVm } from '../../../common/interface/ISlClockAnimVm';

// 默认动效管理器
const defaultAnimMgr: AnimMgr = new AnimMgr();

/**
 * 沉浸模块动效管理基类
 */
export class ImmAnimBaseMgrV2 implements IImmersiveAnimBaseVm {
  // 业务注入器
  private vmInjector?: IImmersiveNtfVmInjector;

  constructor(vmInjector?: IImmersiveNtfVmInjector) {
    this.vmInjector = vmInjector;
  }

  /**
   * 动效执行管理器
   *
   * @returns 动效管理器
   */
  public getAnimExeMgr(): AnimMgr {
    // 统一使用全局动效管理器
    return defaultAnimMgr;
  }

  /**
   * 打断动效
   *
   * @param scene 动效场景
   */
  public interruptAnim(scene: string): IImmersiveAnimBaseVm {
    this.getAnimExeMgr().interruptAnim(scene);
    return this;
  }

  /**
   * 设置业务注入器
   *
   * @param vmInjector 注入器
   */
  public setVmInjector(vmInjector: IImmersiveNtfVmInjector): void {
    // 初始化一次即可
    if (!this.vmInjector) {
      this.vmInjector = vmInjector;
    }
  }

  /**
   * 业务注入器
   *
   * @returns 注入器
   */
  protected getVmInjector(): IImmersiveNtfVmInjector {
    return this.vmInjector as IImmersiveNtfVmInjector;
  }

  /**
   * 沉浸模块全局动效管理器
   *
   * @returns 全局动效管理器
   */
  protected getWholeAnim(): IImmersiveWholeAnimVm | undefined {
    return this.vmInjector?.getImmersiveWholeAnimVm();
  }

  /**
   * 沉浸模块列表动效管理器
   *
   * @returns 列表动效管理器
   */
  protected getListAnim(): IImmersiveListAnimVm | undefined {
    return this.vmInjector?.getImmersiveListAnimVm();
  }

  /**
   * 沉浸模块大卡动效管理器
   *
   * @returns 大卡动效管理器
   */
  protected getCardAnim(): IImmersiveCardAnimVm | undefined {
    return this.vmInjector?.getImmersiveCardAnimVm();
  }

  /**
   * 沉浸模块胶囊动效管理器
   *
   * @returns 胶囊动效管理器
   */
  protected getCapAnim(): IImmersiveCapAnimVm | undefined {
    return this.vmInjector?.getImmersiveCapAnimVm();
  }

  /**
   * 锁屏时钟联合动效管理器
   *
   * @returns 时钟动效管理器
   */
  protected getClockAnim(): ISlClockAnimVm | undefined {
    return this.vmInjector?.getSlClockAnimVm();
  }

  /**
   * 具体业务模块的扩展业务管理器，交由子类实现
   *
   * @returns 扩展业务管理器
   */
  protected getExtendVm(): IImmersiveExtendVm | undefined {
    return undefined;
  }

  /**
   * 具体业务静态状态
   *
   * @returns 静态状态
   */
  protected getSlStatic(): IBaseState | undefined {
    return this.getExtendVm()?.getSlStaticState();
  }

  /**
   * 具体业务UI绑定状态
   *
   * @returns UI绑定状态
   */
  protected getSlBind(): IBaseState | undefined {
    return this.getExtendVm()?.getSlBindState();
  }

  /**
   * 具体业务动效状态
   *
   * @returns 动效状态
   */
  protected getSlAnim(): WidgetAnimStateV2 | undefined {
    return this.getExtendVm()?.getSlAnimState();
  }

  /**
   * 具体业务样式状态
   *
   * @returns 样式状态
   */
  protected getSlStyle(): WidgetStyleStateV2 | undefined {
    return this.getExtendVm()?.getSlStyleState();
  }

  /**
   * 具体业务缓存状态
   *
   * @returns 缓存状态
   */
  protected getSlCache(): WidgetCacheState | undefined {
    return this.getExtendVm()?.getSlCacheState();
  }
}