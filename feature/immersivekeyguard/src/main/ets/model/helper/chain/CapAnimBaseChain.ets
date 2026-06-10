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

import { CapAnimScene } from '../../../common/constants/ImmCapConst';
import { IImmersiveCapVm } from '../../../common/interface/IImmersiveCapVm';
import { ImmCapCheckData } from '../../data/v2/ImmCapCheckData';
import { ImmCapDataArray } from '../../data/v2/ImmCapDataArray';
import { SlCapBindStateV2 } from '../../data/v2/SlCapBindStateV2';
import { ICapLifeCycleAnimChain } from './ICapLifeCycleAnimChain';
import { ImmAnimBaseChain } from './ImmAnimBaseChain';

/**
 * 胶囊生命周期动效检测链条基类
 */
export class CapAnimBaseChain extends ImmAnimBaseChain<CapAnimScene> implements ICapLifeCycleAnimChain {
  // 链条下游检测器
  protected nextChain?: CapAnimBaseChain;

  /**
   * 添加检测链条
   *
   * @param nextChain 检测链条
   */
  public addNextChain(nextChain: CapAnimBaseChain): void {
    super.addNextChain(nextChain);
  }

  /**
   * 检测胶囊生命周期动效
   *
   * @returns 动效场景
   */
  public checkLifeCycleAnim(): CapAnimScene | undefined {
    return super.checkLifeCycleAnim();
  }

  /**
   * 胶囊列表UI显示数据
   *
   * @returns 胶囊数据
   */
  protected getCapList(): ImmCapDataArray {
    return this.getCapVm()?.getSlCapData();
  }

  /**
   * 胶囊列表动效检测数据
   *
   * @returns 胶囊数据
   */
  protected getCapCheckList(): ImmCapCheckData {
    return this.getCapVm()?.getCheckCapData();
  }

  /**
   * 胶囊列表业务
   *
   * @returns 胶囊业务
   */
  protected getCapVm(): IImmersiveCapVm {
    return this.ntfInjector?.getImmersiveCapVm();
  }

  /**
   * 胶囊UI绑定状态
   *
   * @returns 状态
   */
  protected getCapBindSt(): SlCapBindStateV2 | undefined {
    return this.getCapVm()?.getSlBindState();
  }
}