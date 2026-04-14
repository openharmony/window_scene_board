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

import { LiveNotification } from '@ohos/systemuicommon/newIndex';
import { IImmCardLiveAuthorizationVm } from '../../../common/interface/IImmCardLiveAuthorizationVm';
import { IImmCardLiveCardOtherVm } from '../../../common/interface/IImmCardLiveCardOtherVm';
import { IImmCardLiveCardSystemVm } from '../../../common/interface/IImmCardLiveCardSystemVm';
import { IImmCardLiveNavigationVm } from '../../../common/interface/IImmCardLiveNavigationVm';
import { IImmCardLiveOtherExtendVm } from '../../../common/interface/IImmCardLiveOtherExtendVm';
import { IImmCardLiveOtherProgressVm } from '../../../common/interface/IImmCardLiveOtherProgressVm';
import { IImmCardLiveOtherFlightVm } from '../../../common/interface/IImmCardLiveOtherFlightVm';
import { IImmCardLiveSysBtnVm } from '../../../common/interface/IImmCardLiveSysBtnVm';
import { IImmCardLiveSysProgressVm } from '../../../common/interface/IImmCardLiveSysProgressVm';
import { IImmCardLiveVmInjector } from '../../../common/interface/IImmCardLiveVmInjector';
import { ImmCardLiveAuthorizationVm } from '../vm/ImmCardLiveAuthorizationVm';
import { ImmCardLiveCardOtherVm } from '../vm/ImmCardLiveCardOtherVm';
import { ImmCardLiveCardSystemVm } from '../vm/ImmCardLiveCardSystemVm';
import { ImmCardLiveNavigationVm } from '../vm/ImmCardLiveNavigationVm';
import { ImmCardLiveOtherExtendVm } from '../vm/ImmCardLiveOtherExtendVm';
import { ImmCardLiveOtherProgressVm } from '../vm/ImmCardLiveOtherProgressVm';
import { ImmCardLiveSysBtnVm } from '../vm/ImmCardLiveSysBtnVm';
import { ImmCardLiveSysProgressVm } from '../vm/ImmCardLiveSysProgressVm';
import { ImmersiveLiveVmInjector } from './ImmersiveLiveVmInjector';
import { ImmCardLiveOtherFlightVm } from '../vm/ImmCardLiveOtherFlightVm';

/**
 * 沉浸锁屏实况通知注入，大卡场景
 */
export class ImmCardLiveVmInjector extends ImmersiveLiveVmInjector implements IImmCardLiveVmInjector {
  /**
   * 沉浸大卡中实况三方卡片业务管理器
   *
   * @param live 实况数据
   * @returns 三方卡片业务管理器
   */
  getCardOtherVm(live: LiveNotification): IImmCardLiveCardOtherVm {
    return this.getVm(this.getKey(ImmCardLiveCardOtherVm, live), () => new ImmCardLiveCardOtherVm(this, live));
  }

  /**
   * 沉浸大卡中实况系统卡片业务管理器
   *
   * @param live 实况数据
   * @returns 系统卡片业务管理器
   */
  getCardSystemVm(live: LiveNotification): IImmCardLiveCardSystemVm {
    return this.getVm(this.getKey(ImmCardLiveCardSystemVm, live), () => new ImmCardLiveCardSystemVm(this, live));
  }

  /**
   * 沉浸大卡中实况导航模板业务管理器
   *
   * @param live 实况数据
   * @returns 导航模板业务管理器
   */
  getCardNavigationVm(live: LiveNotification): IImmCardLiveNavigationVm {
    return this.getVm(this.getKey(ImmCardLiveNavigationVm, live), () => new ImmCardLiveNavigationVm(this, live));
  }

  /**
   * 沉浸大卡中实况三方卡片扩展区业务管理器
   *
   * @param live 实况数据
   * @returns 三方卡片扩展区业务管理器
   */
  getCardOtherExtendVm(live: LiveNotification): IImmCardLiveOtherExtendVm {
    return this.getVm(this.getKey(ImmCardLiveOtherExtendVm, live), () => new ImmCardLiveOtherExtendVm(this, live));
  }

  /**
   * 沉浸大卡中实况系统卡片按钮业务管理器
   *
   * @param live 实况数据
   * @returns 系统卡片按钮业务管理器
   */
  getCardSystemButtonVm(live: LiveNotification): IImmCardLiveSysBtnVm {
    return this.getVm(this.getKey(ImmCardLiveSysBtnVm, live), () => new ImmCardLiveSysBtnVm(this, live));
  }

  /**
   * 沉浸大卡中实况卡片授权业务管理器
   *
   * @param live 实况数据
   * @returns 卡片授权业务管理器
   */
  getCardAuthorizationVm(live: LiveNotification): IImmCardLiveAuthorizationVm {
    return this.getVm(this.getKey(ImmCardLiveAuthorizationVm, live), () => new ImmCardLiveAuthorizationVm(this, live));
  }

  /**
   * 沉浸大卡中实况三方卡片进度条业务管理器
   *
   * @param live 实况数据
   * @returns 三方卡片业务管理器
   */
  getCardOtherProgressVm(live: LiveNotification): IImmCardLiveOtherProgressVm {
    return this.getVm(this.getKey(ImmCardLiveOtherProgressVm, live), () => new ImmCardLiveOtherProgressVm(this, live));
  }

  /**
   * 沉浸大卡中实况系统卡片进度环业务管理器
   *
   * @param live 实况数据
   * @returns 系统卡片进度环业务管理器
   */
  getCardSystemProgressVm(live: LiveNotification): IImmCardLiveSysProgressVm {
    return this.getVm(this.getKey(ImmCardLiveSysProgressVm, live), () => new ImmCardLiveSysProgressVm(this, live));
  }

  /**
   * 沉浸大卡中实况系统卡片左右卡片类型业务管理器
   *
   * @param live 实况数据
   * @returns 系统卡片左右卡片类型业务管理器
   */
  getCardOtherFlightVm(live: LiveNotification): IImmCardLiveOtherFlightVm {
    return this.getVm(this.getKey(ImmCardLiveOtherFlightVm, live), () => new ImmCardLiveOtherFlightVm(this, live));
  }
}