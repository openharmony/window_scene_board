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

import { ComponentPosition, WidgetAnimStateV2, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { CapAnimScene, CapAnimSuffix, CapShowType } from '../../../../common/constants/ImmCapConst';
import { IImmersiveCapAnimVm } from '../../../../common/interface/IImmersiveCapAnimVm';
import { ImmCapAnimConfig } from '../../../../model/data/config/ImmCapAnimConfig';
import { ImmCapCfgKey } from '../../../../model/data/config/ImmCapCfgKey';
import { ImmCapPtConfig } from '../../../../model/data/config/ImmCapPtConfig';
import { ImmCapCheckData } from '../../../../model/data/v2/ImmCapCheckData';
import { ImmCapDataArray } from '../../../../model/data/v2/ImmCapDataArray';
import { SlCapBindStateV2 } from '../../../../model/data/v2/SlCapBindStateV2';
import { ICapLifeCycleAnim } from './ICapLifeCycleAnim';
import { ImmBaseLifeCycleAnim } from './ImmBaseLifeCycleAnim';

/**
 * 胶囊生命周期动效基类
 */
export abstract class CapBaseLifeCycleAnim extends ImmBaseLifeCycleAnim<ImmCapPtConfig, ImmCapAnimConfig>
  implements ICapLifeCycleAnim {
  /**
   * 动效场景
   *
   * @returns 场景
   */
  public abstract getAnimScene(): CapAnimScene;

  /**
   * 胶囊动效配置实例
   *
   * @returns 动效配置
   */
  protected createAnimCfg(): ImmCapAnimConfig {
    return ImmCapAnimConfig.wrap(this.getAnimScene());
  }

  /**
   * 胶囊根布局动效管理器
   *
   * @returns 动效管理器
   */
  protected getRootAnim(): WidgetAnimStateV2 | undefined {
    return this.getCapAnimVm()?.getRootAnimSt();
  }

  /**
   * 胶囊条目通用动效管理器
   *
   * @param capType 条目类型
   * @returns 动效管理器
   */
  protected getItemComAnim(capType: CapShowType): WidgetAnimStateV2 | undefined {
    return this.getCapAnimVm()?.getItemComAnimSt(capType);
  }

  /**
   * 胶囊条目内层布局动效管理器
   *
   * @param capType 条目类型
   * @returns 动效管理器
   */
  protected getItemInnerAnim(capType: CapShowType): WidgetAnimStateV2 | undefined {
    return this.getCapAnimVm()?.getItemInnerAnimSt(capType);
  }

  /**
   * 胶囊条目通用样式
   *
   * @param capType 条目类型
   * @returns 样式管理器
   */
  protected getItemComStyle(capType: CapShowType): WidgetStyleStateV2 | undefined {
    return this.getCapAnimVm()?.getItemComStyle(capType);
  }

  /**
   * 胶囊模块动效业务管理器
   *
   * @returns 动效业务
   */
  protected getCapAnimVm(): IImmersiveCapAnimVm | undefined {
    return this.vmInjector?.getImmersiveCapAnimVm();
  }

  /**
   * 根布局动效key
   *
   * @returns key
   */
  protected getRootKey(): ImmCapCfgKey {
    return ImmCapCfgKey.genKey();
  }

  /**
   * 通用动效key
   *
   * @param capType 胶囊类型
   * @returns key
   */
  protected getItemComKey(capType: CapShowType): ImmCapCfgKey {
    return ImmCapCfgKey.genKey(capType, CapAnimSuffix.ITEM_COMMON_ANIM);
  }

  /**
   * inner动效key
   *
   * @param capType 胶囊类型
   * @returns key
   */
  protected getItemInnerKey(capType: CapShowType): ImmCapCfgKey {
    return ImmCapCfgKey.genKey(capType, CapAnimSuffix.ITEM_INNER_ANIM);
  }

  /**
   * 胶囊UI绑定状态
   *
   * @returns 状态
   */
  protected getCapBindSt(): SlCapBindStateV2 | undefined {
    return this.vmInjector?.getImmersiveCapVm()?.getSlBindState();
  }

  /**
   * 胶囊数据列表
   *
   * @returns 数据列表
   */
  protected getCapData(): ImmCapDataArray | undefined {
    return this.vmInjector?.getImmersiveCapVm()?.getSlCapData();
  }

  /**
   * 胶囊数据动效检测列表
   *
   * @returns 数据列表
   */
  protected getCheckCapData(): ImmCapCheckData | undefined {
    return this.vmInjector?.getImmersiveCapVm()?.getCheckCapData();
  }

  /**
   * 胶囊条目位置
   *
   * @param capType 胶囊类型
   * @returns 胶囊位置
   */
  protected getItemPos(capType: CapShowType): ComponentPosition | undefined {
    return this.getCapAnimVm()?.getValidItemPos(capType);
  }
}