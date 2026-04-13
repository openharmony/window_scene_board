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

import { IBaseVmInjector } from '../../vm/IBaseVmInjector';
import { LiveNotification } from '../model/LiveNotification';
import { ICapsuleKeepShowingVm } from './ICapsuleKeepShowingVm';
import { ILiveActionButtonVm } from './ILiveActionButtonVm';
import { ILiveCapsuleListLayoutVm } from './ILiveCapsuleLayoutVm';
import { ILiveCapsuleLifecycleVm } from './ILiveCapsuleLifecycleVm';
import { ILiveCapsuleLightWaveVm } from './ILiveCapsuleLightWaveVm';
import { ILiveCapsuleListAnimVm } from './ILiveCapsuleListAnimVm';
import { ILiveCapsuleListVm } from './ILiveCapsuleListVm';
import { ILiveCapsuleMarqueeVm } from './ILiveCapsuleMarqueeVm';
import { ILiveCapsuleVm } from './ILiveCapsuleVm';
import { ILiveCapsuleWaveVm } from './ILiveCapsuleWaveVm';
import { ILiveCardAuthorizationVm } from './ILiveCardAuthorizationVm';
import { ILiveCardListItemVm } from './ILiveCardListItemVm';
import { ILiveCardListVm } from './ILiveCardListVm';
import { ILiveCardMenuVm } from './ILiveCardMenuVm';
import { ILiveCardNavigationVm } from './ILiveCardNavigationVm';
import { ILiveCardOtherExtendVm } from './ILiveCardOtherExtendVm';
import { ILiveCardOtherFlightVm } from './ILiveCardOtherFlightVm';
import { ILiveCardOtherProgressVm } from './ILiveCardOtherProgressVm';
import { ILiveCardOtherVm } from './ILiveCardOtherVm';
import { ILiveCardSystemButtonVm } from './ILiveCardSystemButtonVm';
import { ILiveCardSystemProgressVm } from './ILiveCardSystemProgressVm';
import { ILiveCardFloatingVm } from './ILiveCardFloatingVm';
import { ILiveCardSystemVm } from './ILiveCardSystemVm';
import { ILiveDataVm } from './ILiveDataVm';
import { ILiveHeadsUpCommonCardVm } from './ILiveHeadsUpCommonCardVm';
import { ILiveHeadsUpSwipeVm } from './ILiveHeadsUpSwipeVm';
import { ILiveHeadsUpVm } from './ILiveHeadsUpVm';
import { ILiveHeadsUpWalletCardVm } from './ILiveHeadsUpWalletCardVm';
import { ILiveMediaPlayerVm } from './ILiveMediaPlayerVm';
import { ILiveMetaBallVisibleVm } from './ILiveMetaBallVisibleVm';
import { ILiveMetaBallVm } from './ILiveMetaBallVm';
import { ILiveRemindVm } from './ILiveRemindVm';
import { ILiveStarterVm } from './ILiveStarterVm';
import { ILiveSwitchVm } from './ILiveSwitchVm';
import { ILiveTimerVm } from './ILiveTimerVm';
import { ILiveHeadsUpFaceLockVm } from './ILiveHeadsUpFaceLockVm';
import { ILiveCardOtherPickupVm } from './ILiveCardOtherPickupVm';
import { ILiveCardOtherScoreVm } from './ILiveCardOtherScoreVm';
import { ILiveOverlayVm } from './ILiveOverlayVm';
import { ILiveCardMediaPlayerVm } from './ILiveCardMediaPlayerVm';
import { ILiveCapsuleFaceLockVm } from './ILiveCapsuleFaceLockVm';

/**
 * 实况VM注入器接口
 */
export interface ILiveVmInjector extends IBaseVmInjector {
  /**
   * 实况数据管理
   *
   * @returns ILiveDataVm
   */
  getLiveDataVm(): ILiveDataVm;

  /**
   * 获取胶囊列表VM
   *
   * @returns ILiveCapsuleListVm
   */
  getCapsuleListVm(): ILiveCapsuleListVm;

  /**
   * 获取覆盖层的VM
   */
  getOverlayVm?(): ILiveOverlayVm;

  /**
   * 获取胶囊VM
   *
   * @returns ILiveCapsuleVm
   */
  getCapsuleVm(live: LiveNotification): ILiveCapsuleVm;

  /**
   * 获取胶囊跑马灯VM
   *
   * @param live 实况数据
   * @returns ILiveCapsuleMarqueeVm
   */
  getCapsuleMarqueeVm(live: LiveNotification): ILiveCapsuleMarqueeVm;

  /**
   * 获取实况卡片列表VM
   *
   * @returns ILiveCardListVm
   */
  getCardListVm(): ILiveCardListVm;

  /**
   * 获取实况卡片VM
   *
   * @returns ILiveCardListItemVm
   */
  getCardListItemVm(live: LiveNotification): ILiveCardListItemVm;

  /**
   * 获取实况卡片菜单VM
   *
   * @param live 实况数据
   * @returns ILiveCardMenuVm
   */
  getCardMenuVm(live: LiveNotification): ILiveCardMenuVm;

  /**
   * 获取实况卡片滑动VM
   *
   * @param live 实况数据
   * @returns ILiveHeadsUpSwipeVm
   */
  getLiveHeadsUpSwipeVm(live: LiveNotification): ILiveHeadsUpSwipeVm;

  /**
   * 获取实况横幅悬浮窗VM
   * @param live 实况数据
   * @returns
   */
  getCardFloatingVm(live: LiveNotification): ILiveCardFloatingVm;

  /**
   * 获取系统实况卡片VM
   *
   * @param live 实况数据
   * @returns ILiveCardSystemVm
   */
  getCardSystemVm(live: LiveNotification): ILiveCardSystemVm;

  /**
   * 获取系统实况进度环VM
   *
   * @param live 实况数据
   * @returns ILiveCardSystemProgressVm
   */
  getCardSystemProgressVm(live: LiveNotification): ILiveCardSystemProgressVm;

  /**
   * 获取系统时刻按钮VM
   *
   * @param live 实况数据
   * @returns ILiveCardSystemButtonVm
   */
  getCardSystemButtonVm(live: LiveNotification): ILiveCardSystemButtonVm;

  /**
   * 获取实况计时器VM
   *
   * @returns ILiveTimerVm
   */
  getTimerVm(): ILiveTimerVm;

  /**
   * 获取三方实况卡片VM
   *
   * @param live 实况数据
   * @returns ILiveCardOtherVm
   */
  getCardOtherVm(live: LiveNotification): ILiveCardOtherVm;

  /**
   * 获取播控卡片VM
   *
   * @param live 实况数据
   * @returns ILiveCardOtherVm
   */
  getCardMediaPlayerVm?(live: LiveNotification): ILiveCardMediaPlayerVm;

  /**
   * 获取三方实况左右拓展区卡片VM
   *
   * @param live 实况数据
   * @returns ILiveCardOtherFlightVm
   */
  getCardOtherFlightVm(live: LiveNotification): ILiveCardOtherFlightVm;

  /**
   * 获取三方实况取餐卡片VM
   *
   * @param live 实况数据
   * @returns ILiveCardOtherPickupVm
   */
  getCardOtherPickupVm(live: LiveNotification): ILiveCardOtherPickupVm;

  /**
   * 获取三方实况比分卡片VM
   *
   * @param live 实况数据
   * @returns ILiveCardOtherScoreVm
   */
  getCardOtherScoreVm(live: LiveNotification): ILiveCardOtherScoreVm;

  /**
   * 获取三方实况卡片扩展区进度VM
   *
   * @param live 实况数据
   * @returns ILiveCardOtherProgressVm
   */
  getCardOtherProgressVm(live: LiveNotification): ILiveCardOtherProgressVm;

  /**
   * 获取胶囊和卡片切换VM
   *
   * @returns ILiveSwitchVm
   */
  getSwitchVm(): ILiveSwitchVm;

  /**
   * 获取导航卡片
   *
   * @param live 实况数据
   * @returns ILiveCardNavigationVm
   */
  getCardNavigationVm(live: LiveNotification): ILiveCardNavigationVm;

  /**
   * 获取卡片授权信息
   *
   * @param live 实况数据
   * @returns ILiveCardAuthorizationVm
   */
  getCardAuthorizationVm(live: LiveNotification): ILiveCardAuthorizationVm;

  /**
   * 获取三方实况卡片辅助区VM
   *
   * @param live 实况数据
   * @returns ILiveCardOtherExtendVm
   */
  getCardOtherExtendVm(live: LiveNotification): ILiveCardOtherExtendVm;

  /**
   * 获取进度类扫光动效组件VM
   *
   * @param live 实况数据
   * @returns ILiveCapsuleWaveVm
   */
  getCapsuleWaveVm(live: LiveNotification): ILiveCapsuleWaveVm;

  /**
   * 获取扫光动效组件VM
   *
   * @param live 实况数据
   * @returns ILiveCapsuleLightWaveVm
   */
  getCapsuleLightWaveVm(live: LiveNotification): ILiveCapsuleLightWaveVm;

  /**
   * 胶囊扫光VM
   *
   * @param live 实况数据
   * @returns ILiveCapsuleLightWaveVm
   */
  getCapsuleRightLightWaveVm(live: LiveNotification): ILiveCapsuleLightWaveVm;

  /**
   * 实况按钮vm
   *
   * @param live 实况数据
   * @returns ILiveActionButtonVm
   */
  getLiveActionButtonVm(live: LiveNotification): ILiveActionButtonVm;

  /**
   * 获取胶囊列表布局VM
   *
   * @returns ILiveCapsuleListLayoutVm
   */
  getCapsuleListLayoutVm(): ILiveCapsuleListLayoutVm;

  /**
   * 获取胶囊状态动效控制VM
   *
   * @returns ILiveCapsuleListAnimVm
   */
  getCapsuleListAnimVm(): ILiveCapsuleListAnimVm;

  /**
   * 获取融球VM
   *
   * @returns ILiveMetaBallVm
   */
  getMetaBallVm(): ILiveMetaBallVm;

  getMetaBallVisibleVm(): ILiveMetaBallVisibleVm;

  /**
   * 获取实况拉起wantAgent的vm
   *
   * @returns ILiveStarterVm
   */
  getStarterVm(): ILiveStarterVm;

  /**
   * 获取横幅实况Vm
   *
   * @returns ILiveHeadsUpVm
   */
  getLiveHeadsUpVm(): ILiveHeadsUpVm;

  /**
   * 获取实况横幅通用卡片VM
   *
   * @returns ILiveHeadsUpCommonCardVm
   */
  getLiveHeadsUpCommonCardVm(): ILiveHeadsUpCommonCardVm;

  /**
   * 获取实况横幅钱包卡片VM
   *
   * @returns ILiveHeadsUpWalletCardVm
   */
  getLiveHeadsUpWalletCardVm(): ILiveHeadsUpWalletCardVm;

  /**
   * 获取抢占场景VM
   *
   * @returns ILiveRemindVm
   */
  getLiveRemindVm(): ILiveRemindVm;

  /**
   * 获取播控VM
   *
   * @param live 实况数据
   * @returns ILiveMediaPlayerVm
   */
  getLiveMediaPlayerVm(live: LiveNotification): ILiveMediaPlayerVm;

  /**
   * 获取胶囊生命周期VM
   * @returns
   */
  getCapsuleLifecycleVm(): ILiveCapsuleLifecycleVm;

  /**
   * 清理某个通知对应的所有VM
   *
   * @param live 实况数据
   * @Param isUpdateToDelete 是否更新删除场景
   */
  deleteVmByLive(live: LiveNotification, isUpdateToDelete?: boolean): void;

  /**
   * 更新某个实况对应的所有VM的数据
   *
   * @param live 实况数据
   */
  updateVmByLive(live: LiveNotification, scene?: string): void;

  /**
   * 胶囊显示接续管理类
   */
  getCapsuleKeepShowingVm(): ICapsuleKeepShowingVm;

  getLiveHeadsUpFaceLockVm(): ILiveHeadsUpFaceLockVm;

  getLiveCapsuleFaceLockVm(live: LiveNotification): ILiveCapsuleFaceLockVm;
}