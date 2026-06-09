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

import { LiveNotification } from '@ohos/systemuicommon/newIndex';
import { IImmCardLiveAuthorizationVm } from './IImmCardLiveAuthorizationVm';
import { IImmCardLiveCardOtherVm } from './IImmCardLiveCardOtherVm';
import { IImmCardLiveCardSystemVm } from './IImmCardLiveCardSystemVm';
import { IImmCardLiveNavigationVm } from './IImmCardLiveNavigationVm';
import { IImmCardLiveOtherExtendVm } from './IImmCardLiveOtherExtendVm';
import { IImmCardLiveOtherProgressVm } from './IImmCardLiveOtherProgressVm';
import { IImmCardLiveSysBtnVm } from './IImmCardLiveSysBtnVm';
import { IImmCardLiveSysProgressVm } from './IImmCardLiveSysProgressVm';
import { IImmersiveLiveVmInjector } from './IImmersiveLiveVmInjector';

/**
 * 实况通知在大卡上使用时业务注入器抽象层
 */
export interface IImmCardLiveVmInjector extends IImmersiveLiveVmInjector {
  /**
   * 沉浸大卡中实况三方卡片业务管理器
   *
   * @param live 实况数据
   * @returns 三方卡片业务管理器
   */
  getCardOtherVm(live: LiveNotification): IImmCardLiveCardOtherVm;

  /**
   * 沉浸大卡中实况系统卡片业务管理器
   *
   * @param live 实况数据
   * @returns 系统卡片业务管理器
   */
  getCardSystemVm(live: LiveNotification): IImmCardLiveCardSystemVm;

  /**
   * 沉浸大卡中实况导航模板业务管理器
   *
   * @param live 实况数据
   * @returns 导航模板业务管理器
   */
  getCardNavigationVm(live: LiveNotification): IImmCardLiveNavigationVm;

  /**
   * 沉浸大卡中实况三方卡片扩展区业务管理器
   *
   * @param live 实况数据
   * @returns 三方卡片扩展区业务管理器
   */
  getCardOtherExtendVm(live: LiveNotification): IImmCardLiveOtherExtendVm;

  /**
   * 沉浸大卡中实况系统卡片按钮业务管理器
   *
   * @param live 实况数据
   * @returns 系统卡片按钮业务管理器
   */
  getCardSystemButtonVm(live: LiveNotification): IImmCardLiveSysBtnVm;

  /**
   * 沉浸大卡中实况卡片授权业务管理器
   *
   * @param live 实况数据
   * @returns 卡片授权业务管理器
   */
  getCardAuthorizationVm(live: LiveNotification): IImmCardLiveAuthorizationVm;

  /**
   * 沉浸大卡中实况三方卡片进度条业务管理器
   *
   * @param live 实况数据
   * @returns 三方卡片业务管理器
   */
  getCardOtherProgressVm(live: LiveNotification): IImmCardLiveOtherProgressVm;

  /**
   * 沉浸大卡中实况系统卡片进度环业务管理器
   *
   * @param live 实况数据
   * @returns 系统卡片进度环业务管理器
   */
  getCardSystemProgressVm(live: LiveNotification): IImmCardLiveSysProgressVm;
}