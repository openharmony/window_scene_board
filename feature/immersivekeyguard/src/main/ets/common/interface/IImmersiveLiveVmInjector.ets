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

import { ILiveVmInjector, LiveNotification } from '@ohos/systemuicommon/newIndex';
import { IImmersiveLiveAuthorizationVm } from './IImmersiveLiveAuthorizationVm';
import { IImmersiveLiveCardOtherVm } from './IImmersiveLiveCardOtherVm';
import { IImmersiveLiveCardSystemVm } from './IImmersiveLiveCardSystemVm';
import { IImmersiveLiveItemVm } from './IImmersiveLiveItemVm';
import { IImmersiveLiveMenuVm } from './IImmersiveLiveMenuVm';
import { IImmersiveLiveNavigationVm } from './IImmersiveLiveNavigationVm';
import { IImmersiveLiveOtherExtendVm } from './IImmersiveLiveOtherExtendVm';
import { IImmersiveLiveOtherProgressVm } from './IImmersiveLiveOtherProgressVm';
import { IImmersiveLiveSysBtnVm } from './IImmersiveLiveSysBtnVm';
import { IImmersiveLiveSysProgressVm } from './IImmersiveLiveSysProgressVm';
import { IImmersiveLiveTimerVm } from './IImmersiveLiveTimerVm';
import { IImmersiveNtfVmInjector } from './IImmersiveNtfVmInjector';
import { IImmersiveVmInjector } from './IImmersiveVmInjector';
import { IImmLiveActionBtnVm } from './IImmLiveActionBtnVm';

/**
 * 沉浸模块实况通知业务注入器抽象层
 */
export interface IImmersiveLiveVmInjector extends IImmersiveVmInjector, ILiveVmInjector {
  /**
   * 通用注入器
   *
   * @param vmInjector 通用注入器
   */
  getNtfVmInjector(): IImmersiveNtfVmInjector | undefined;

  /**
   * 清理所有实况item对应的VM
   */
  deleteVmByAllLive(): void;

  /**
   * 沉浸实况侧滑菜单业务管理器
   *
   * @param live 实况数据
   * @returns 侧滑菜单业务管理器
   */
  getCardMenuVm(live: LiveNotification): IImmersiveLiveMenuVm;

  /**
   * 沉浸实况三方卡片业务管理器
   *
   * @param live 实况数据
   * @returns 三方卡片业务管理器
   */
  getCardOtherVm(live: LiveNotification): IImmersiveLiveCardOtherVm;

  /**
   * 沉浸实况系统卡片业务管理器
   *
   * @param live 实况数据
   * @returns 系统卡片业务管理器
   */
  getCardSystemVm(live: LiveNotification): IImmersiveLiveCardSystemVm;

  /**
   * 沉浸实况条目业务管理器
   *
   * @param live 实况数据
   * @returns 条目业务管理器
   */
  getCardListItemVm(live: LiveNotification): IImmersiveLiveItemVm;

  /**
   * 沉浸实况导航模板业务管理器
   *
   * @param live 实况数据
   * @returns 导航模板业务管理器
   */
  getCardNavigationVm(live: LiveNotification): IImmersiveLiveNavigationVm;

  /**
   * 沉浸实况三方卡片扩展区业务管理器
   *
   * @param live 实况数据
   * @returns 三方卡片扩展区业务管理器
   */
  getCardOtherExtendVm(live: LiveNotification): IImmersiveLiveOtherExtendVm;

  /**
   * 沉浸实况系统卡片按钮业务管理器
   *
   * @param live 实况数据
   * @returns 系统卡片按钮业务管理器
   */
  getCardSystemButtonVm(live: LiveNotification): IImmersiveLiveSysBtnVm;

  /**
   * 沉浸实况卡片授权业务管理器
   *
   * @param live 实况数据
   * @returns 卡片授权业务管理器
   */
  getCardAuthorizationVm(live: LiveNotification): IImmersiveLiveAuthorizationVm;

  /**
   * 实况按钮vm
   *
   * @param live 实况数据
   * @returns 实况按钮业务
   */
  getLiveActionButtonVm(live: LiveNotification): IImmLiveActionBtnVm;

  /**
   * 沉浸实况三方卡片进度条业务管理器
   *
   * @param live 实况数据
   * @returns 三方卡片业务管理器
   */
  getCardOtherProgressVm(live: LiveNotification): IImmersiveLiveOtherProgressVm;

  /**
   * 沉浸实况系统卡片进度环业务管理器
   *
   * @param live 实况数据
   * @returns 系统卡片进度环业务管理器
   */
  getCardSystemProgressVm(live: LiveNotification): IImmersiveLiveSysProgressVm;

  /**
   * 获取沉浸实况计时器业务管理器
   *
   * @returns 实况计时器业务管理器
   */
  getTimerVm(): IImmersiveLiveTimerVm;
}

// 实况业务注入器集
export class IImmersiveLiveVmInjectorArr extends Array<IImmersiveLiveVmInjector> {
}