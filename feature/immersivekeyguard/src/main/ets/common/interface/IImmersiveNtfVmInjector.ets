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

import { INotificationVmInjector } from '@ohos/systemuicommon/newIndex';
import { NotificationBase, NormalNotification } from '@ohos/systemuicommon/newTsIndex';
import { IImmersiveCapAnimVm } from './IImmersiveCapAnimVm';
import { IImmersiveCapVm } from './IImmersiveCapVm';
import { IImmersiveCardAnimVm } from './IImmersiveCardAnimVm';
import { IImmersiveCardVm } from './IImmersiveCardVm';
import { IImmDataShareVm } from './IImmDataShareVm';
import { IImmersiveListAnimVm } from './IImmersiveListAnimVm';
import { IImmersiveListHandle } from './IImmersiveListHandle';
import { IImmersiveListVm } from './IImmersiveListVm';
import { IImmersiveMeshVm } from './IImmersiveMeshVm';
import { IImmersiveNtfActionBtnVm } from './IImmersiveNtfActionBtnVm';
import { IImmersiveNtfItemVm } from './IImmersiveNtfItemVm';
import { IImmersiveNtfMenuVm } from './IImmersiveNtfMenuVm';
import { IImmersiveNtfNormalGroupVm } from './IImmersiveNtfNormalGroupVm';
import { IImmersiveNtfNormalVm } from './IImmersiveNtfNormalVm';
import { IImmersiveNtfPinTopVm } from './IImmersiveNtfPinTopVm';
import { IImmersiveNtfSettingDialogVm } from './IImmersiveNtfSettingDialogVm';
import { IImmersiveNtfStarterVm } from './IImmersiveNtfStarterVm';
import { IImmersiveNtfSwipeVm } from './IImmersiveNtfSwipeVm';
import { IImmersiveNtfTimeVm } from './IImmersiveNtfTimeVm';
import { IImmersivePanelVm } from './IImmersivePanelVm';
import { IImmersiveVmInjector } from './IImmersiveVmInjector';
import { IImmersiveWholeAnimVm } from './IImmersiveWholeAnimVm';
import { IImmLifeCycleVm } from './IImmLifeCycleVm';
import { ISlClockAnimVm } from './ISlClockAnimVm';
import { IImmersiveDataVm } from './IImmersiveDataVm';
import { IGraftNtfListVm } from './IGraftNtfListVm';
import { IImmersiveLiveVmInjector } from './IImmersiveLiveVmInjector';
import { IImmComVm } from './IImmComVm';
import { ICapAnimChainVm } from './ICapAnimChainVm';
import { ICardAnimChainVm } from './ICardAnimChainVm';
import { IImmersiveLiveTimerVm } from './IImmersiveLiveTimerVm';
import { IImmLiveDataVm } from './IImmLiveDataVm';
import { IImmersiveCapsuleHandle } from './IImmersiveCapsuleHandle';
import { IImmersiveCardHandle } from './IImmersiveCardHandle';
import { IImmGestureEventVm } from './IImmGestureEventVm';
import { IImmCapRemindVm } from './IImmCapRemindVm';
import { IImmV1StateVm } from './IImmV1StateVm';
import { ICapLifeCycleAnimFactory } from './ICapLifeCycleAnimFactory';
import { ICardLifeCycleAnimFactory } from './ICardLifeCycleAnimFactory';
import { IImmHybridAnimFactory } from './IImmHybridAnimFactory';
import { ImmColorVm } from '../color/ImmColorVm';

/**
 * 沉浸模块普通通知业务注入器抽象层
 */
export interface IImmersiveNtfVmInjector extends IImmersiveVmInjector, INotificationVmInjector {
  /**
   * 沉浸列表面板业务
   *
   * @returns 面板业务
   */
  getPanelVm(): IImmersivePanelVm;

  /**
   * 沉浸模块数据处理业务
   *
   * @returns 数据处理业务
   */
  getImmDataVm(): IImmersiveDataVm;

  /**
   * 沉浸列表布局业务
   *
   * @returns 列表业务
   */
  getImmersiveListVm(): IImmersiveListVm;

  /**
   * 通知中心嫁接列表布局业务
   *
   * @returns 嫁接列表业务
   */
  getListVm(): IGraftNtfListVm;

  /**
   * 获取颜色相关的VM
   *
   * @returns 颜色VM
   */
  getColorVm(): ImmColorVm;

  /**
   * 通知条目业务
   *
   * @param ntf 通知数据
   * @returns 条目业务
   */
  getCardVm(ntf: NotificationBase): IImmersiveNtfItemVm;

  /**
   * 组通知条目业务
   *
   * @param ntf 通知数据
   * @returns 组通知业务
   */
  getNormalGroupVm(ntf: NotificationBase): IImmersiveNtfNormalGroupVm;

  /**
   * 普通通知条目业务
   *
   * @param ntf 通知数据
   * @returns 单通知业务
   */
  getNormalVm(ntf: NormalNotification): IImmersiveNtfNormalVm;

  /**
   * 通知条目按钮业务
   *
   * @param ntf 通知数据
   * @returns 按钮业务
   */
  getActionButtonVm(ntf: NormalNotification): IImmersiveNtfActionBtnVm;

  /**
   * 通知条目横滑业务
   *
   * @param ntf 通知数据
   * @returns 横滑业务
   */
  getSwipeVm(ntf: NotificationBase): IImmersiveNtfSwipeVm | undefined;

  /**
   * 通知条目菜单业务
   *
   * @param ntf 通知
   * @returns 菜单业务
   */
  getMenuVm(ntf: NotificationBase): IImmersiveNtfMenuVm | undefined;

  /**
   * 通知条目启动业务
   *
   * @param ntf 通知
   * @returns 启动业务
   */
  getStarterVm(): IImmersiveNtfStarterVm;

  /**
   * 通知条目时钟业务
   *
   * @returns 时钟业务
   */
  getTimeVm(ntf: NotificationBase): IImmersiveNtfTimeVm;

  /**
   * 通知设置弹窗业务
   *
   * @returns 设置弹窗业务
   */
  getSettingDiagVm(): IImmersiveNtfSettingDialogVm | undefined;

  /**
   * 通知置顶超限制弹窗业务
   *
   * @returns 置顶弹窗业务
   */
  getPinTopDialogVm(): IImmersiveNtfPinTopVm;

  /**
   * 沉浸模块栅格业务
   *
   * @returns 栅格业务
   */
  getImmersiveMeshVm(): IImmersiveMeshVm;

  /**
   * 沉浸列表触摸事件处理业务
   *
   * @returns 事件处理业务
   */
  getImmersiveListHandle(): IImmersiveListHandle;

  /**
   * 沉浸胶囊触摸事件处理业务
   *
   * @returns 事件处理业务
   */
  getImmersiveCapsuleHandle(): IImmersiveCapsuleHandle;

  /**
   * 沉浸卡片触摸事件处理业务
   *
   * @returns 事件处理业务
   */
  getImmersiveCardHandle(): IImmersiveCardHandle;

  /**
   * 沉浸模块全局动效业务
   *
   * @returns 全局动效业务
   */
  getImmersiveWholeAnimVm(): IImmersiveWholeAnimVm;

  /**
   * 沉浸模块列表动效业务
   *
   * @returns 列表动效业务
   */
  getImmersiveListAnimVm(): IImmersiveListAnimVm;

  /**
   * 沉浸模块大卡动效业务
   *
   * @returns 大卡动效业务
   */
  getImmersiveCardAnimVm(): IImmersiveCardAnimVm;

  /**
   * 沉浸模块胶囊动效业务
   *
   * @returns 胶囊动效业务
   */
  getImmersiveCapAnimVm(): IImmersiveCapAnimVm;

  /**
   * 沉浸胶囊模块强提醒业务
   *
   * @returns 胶囊强提醒
   */
  getImmCapRemindVm(): IImmCapRemindVm;

  /**
   * 锁屏时钟联合动效业务
   *
   * @returns 时钟动效业务
   */
  getSlClockAnimVm(): ISlClockAnimVm;

  /**
   * 沉浸胶囊列表业务
   *
   * @returns 胶囊列表业务
   */
  getImmersiveCapVm(): IImmersiveCapVm;

  /**
   * 沉浸大卡列表业务
   *
   * @returns 大卡列表业务
   */
  getImmersiveCardVm(): IImmersiveCardVm;

  /**
   * 沉浸模块数据共享处理业务集
   *
   * @returns 数据处理业务集
   */
  getImmDataShareVmList(): IImmDataShareVm[];

  /**
   * 沉浸模块生命周期业务集
   *
   * @returns 生命周期业务集
   */
  getImmLifeCycleVmList(): IImmLifeCycleVm[];

  /**
   * 沉浸模块手势业务集
   *
   * @returns 手势业务集
   */
  getImmGestureVmList(): IImmGestureEventVm[];

  /**
   * 沉浸模块实况业务注入器集
   *
   * @returns 实况业务注入器集
   */
  getImmLiveVmInjectorList(): IImmersiveLiveVmInjector[];

  /**
   * 实况计时器业务
   *
   * @returns 实况计时器
   */
  getLiveTimerVm(): IImmersiveLiveTimerVm | undefined;

  /**
   * 沉浸模块实况数据管理
   *
   * @returns 实况数据管理器
   */
  getImmLiveDataVm(): IImmLiveDataVm;

  /**
   * 沉浸模块通用能力
   *
   * @returns 通用能力
   */
  getImmComVm(): IImmComVm;

  /**
   * 沉浸模块V1状态管理
   *
   * @returns V1状态
   */
  getImmV1StateVm(): IImmV1StateVm;

  /**
   * 沉浸胶囊生命周期动效检测业务
   *
   * @returns 动效检测器
   */
  getImmCapAnimChainVm(): ICapAnimChainVm;

  /**
   * 沉浸大卡生命周期动效检测业务
   *
   * @returns 动效检测器
   */
  getImmCardAnimChainVm(): ICardAnimChainVm;

  /**
   * 沉浸胶囊生命周期动效工厂
   *
   * @returns 动效工厂
   */
  getCapLifeCycleAnimFactory(): ICapLifeCycleAnimFactory;

  /**
   * 沉浸大卡生命周期动效工厂
   *
   * @returns 动效工厂
   */
  getCardLifeCycleAnimFactory(): ICardLifeCycleAnimFactory;

  /**
   * 沉浸锁屏模块联合动效工厂
   *
   * @returns 动效工厂
   */
  getImmHybridAnimFactory(): IImmHybridAnimFactory;
}