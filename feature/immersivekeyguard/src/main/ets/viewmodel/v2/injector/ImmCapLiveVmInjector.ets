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

import { LiveNotification } from '@ohos/systemuicommon/newTsIndex';
import { IImmCapLiveOtherExtVm } from '../../../common/interface/IImmCapLiveOtherExtVm';
import { IImmCapLiveSysBtnVm } from '../../../common/interface/IImmCapLiveSysBtnVm';
import { IImmCapLiveSysProgressVm } from '../../../common/interface/IImmCapLiveSysProgressVm';
import { IImmCapLiveVmInjector } from '../../../common/interface/IImmCapLiveVmInjector';
import { ImmCapLiveOtherExtVm } from '../vm/ImmCapLiveOtherExtVm';
import { ImmCapLiveSysBtnVm } from '../vm/ImmCapLiveSysBtnVm';
import { ImmCapLiveSysProgressVm } from '../vm/ImmCapLiveSysProgressVm';
import { ImmersiveLiveVmInjector } from './ImmersiveLiveVmInjector';

/**
 * 沉浸锁屏实况通知注入，胶囊场景
 */
export class ImmCapLiveVmInjector extends ImmersiveLiveVmInjector implements IImmCapLiveVmInjector {
  /**
   * 沉浸实况系统卡片按钮业务管理器
   *
   * @param live 实况数据
   * @returns 系统卡片按钮业务管理器
   */
  getCardSystemButtonVm(live: LiveNotification): IImmCapLiveSysBtnVm {
    return this.getVm(this.getKey(ImmCapLiveSysBtnVm, live), () => new ImmCapLiveSysBtnVm(this, live));
  }

  /**
   * 沉浸实况系统卡片进度环业务管理器
   *
   * @param live 实况数据
   * @returns 系统卡片进度环业务管理器
   */
  getCardSystemProgressVm(live: LiveNotification): IImmCapLiveSysProgressVm {
    return this.getVm(this.getKey(ImmCapLiveSysProgressVm, live), () => new ImmCapLiveSysProgressVm(this, live));
  }

  /**
   * 沉浸实况三方卡片辅助区业务管理器
   *
   * @param live 实况数据
   * @returns 三方卡片辅助区业务管理器
   */
  getCardOtherExtendVm(live: LiveNotification): IImmCapLiveOtherExtVm {
    return this.getVm(this.getKey(ImmCapLiveOtherExtVm, live), () => new ImmCapLiveOtherExtVm(this, live));
  }
}