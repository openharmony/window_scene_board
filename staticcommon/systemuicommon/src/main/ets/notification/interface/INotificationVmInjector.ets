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
import { NormalNotification } from '../../model/NormalNotification';
import { NotificationBase } from '../../model/NotificationBase';
import { LiveNotification } from '../../live/model/LiveNotification';
import { IBaseVmInjector } from '../../vm/IBaseVmInjector';
import { INotificationActionButtonVm } from './INotificationActionButtonVm';
import { INotificationCardFloatingVm } from './INotificationCardFloatingVm';
import { INotificationBannerVm } from './INotificationBannerVm';
import { INotificationCardVm } from './INotificationCardVm';
import { INotificationClearButtonVm } from './INotificationClearButtonVm';
import { INotificationHeaderVm } from './INotificationHeaderVm';
import { INotificationImmersiveVm } from './INotificationImmersiveVm';
import { INotificationListScrollerVm } from './INotificationListScrollerVm';
import { INotificationListVm } from './INotificationListVm';
import { INotificationMenuVm } from './INotificationMenuVm';
import { INotificationMoreHeaderVm } from './INotificationMoreHeaderVm';
import { INotificationLiveClickVm } from './INotificationLiveClickVm';
import { INotificationMoreVm } from './INotificationMoreVm';
import { INotificationNormalGroupVm } from './INotificationNormalGroupVm';
import { INotificationNormalVm } from './INotificationNormalVm';
import { INotificationPanelVm } from './INotificationPanelVm';
import { INotificationPinTopLimitDialogVm } from './INotificationPinTopLimitDialogVm';
import { INotificationPrivacyVm } from './INotificationPrivacyVm';
import { INotificationSettingDialogVm } from './INotificationSettingDialogVm';
import { INotificationSilenceVm } from './INotificationSilenceVm';
import { INotificationStarterVm } from './INotificationStarterVm';
import { INotificationSwipeVm } from './INotificationSwipeVm';
import { INotificationTimeVm } from './INotificationTimeVm';
import { INotificationVerticalSwipeVm } from './INotificationVerticalSwipeVm';
import { ViewName } from '../../utils/ArkUIAdapter'
import { INotificationDataPlanVm } from './INotificationDataPlanVm';

export interface INotificationVmInjector extends IBaseVmInjector {
  viewName: ViewName;

  /**
   * 获取通知面板VM
   *
   * @returns 面板VM
   */
  getPanelVm(): INotificationPanelVm;

  /**
   * 获取通知列表VM
   *
   * @returns 列表VM
   */
  getListVm(): INotificationListVm | undefined;

  /**
   * 获取通知列表滚动条VM
   *
   * @returns 滚动条VM
   */
  getListScrollerVm(): INotificationListScrollerVm | undefined;

  /**
   * 获取一键清除按钮VM
   *
   * @returns 一键清除按钮VM
   */
  getClearButtonVm(): INotificationClearButtonVm | undefined;

  /**
   * 获取通知卡片VM
   *
   * @param ntf 通知数据
   * @returns 通知卡片VM
   */
  getCardVm(ntf: NotificationBase): INotificationCardVm;

  /**
   * 获取通知卡片VM
   *
   * @param ntf 通知数据
   * @returns 通知卡片VM
   */
  getCardFloatingVm(ntf: NotificationBase): INotificationCardFloatingVm;

  /**
   * 获取通用组通知卡片VM
   *
   * @param ntf 通知数据
   * @returns 组通知卡片VM
   */
  getNormalGroupVm(ntf: NotificationBase): INotificationNormalGroupVm | undefined;

  /**
   * 获取普通通知VM
   *
   * @param ntf 通知数据
   * @returns 普通通知VM
   */
  getNormalVm(ntf: NormalNotification): INotificationNormalVm;

  /**
   * 隐私条目VM
   *
   * @param ntf 通知数据
   * @returns 隐私条目VM
   */
  getPrivacyVm(ntf: NotificationBase): INotificationPrivacyVm;

  /**
   * 获取单通知卡片按钮VM
   *
   * @param ntf 通知数据
   * @returns 单通知卡片按钮VM
   */
  getActionButtonVm(ntf: NormalNotification): INotificationActionButtonVm;

  /**
   * 获取更多通知卡片VM
   *
   * @param ntf 通知数据
   * @returns 更多通知卡片VM
   */
  getMoreVm(): INotificationMoreVm | undefined;

  /**
   * 获取通知面板头部VM
   *
   * @returns 通知面板头部VM
   */
  getHeaderVm(): INotificationHeaderVm | undefined;

  /**
   * 获取通知横滑VM
   *
   * @param ntf 通知数据
   * @returns 通知横滑VM
   */
  getSwipeVm(ntf: NotificationBase): INotificationSwipeVm | undefined;

  /**
   * 获取通知菜单VM
   *
   * @param ntf 通知
   * @returns 通知菜单VM
   */
  getMenuVm(ntf: NotificationBase): INotificationMenuVm | undefined;

  /**
   * 获取通知卡片启动的VM
   *
   * @param ntf 通知
   * @returns 通知卡片启动的VM
   */
  getStarterVm(): INotificationStarterVm;

  /**
   * 获取可扩展小外屏通知卡片启动的VM
   */
  getStarterOuterHomeVm(): INotificationStarterVm;

  /**
   * 获取时间VM
   *
   * @returns 时间VM
   */
  getTimeVm(ntf: NotificationBase): INotificationTimeVm;


  /**
   * 获取通知设置弹窗VM
   *
   * @returns 通知设置弹窗VM
   */
  getSettingDiagVm(): INotificationSettingDialogVm | undefined;

  /**
   * 获取通知置顶超限制弹窗VM
   *
   * @returns 置顶超限制弹窗VM
   */
  getPinTopDialogVm(): INotificationPinTopLimitDialogVm;

  /**
   * 获取通知静默VM
   *
   * @returns 通知静默VM
   */
  getSilenceVm(): INotificationSilenceVm;

  /**
   * 横幅通知VM
   *
   * @returns 横幅通知VM
   */
  getBannerVm(): INotificationBannerVm;

  /**
   * 获取横幅沉浸态通知VM
   * @returns 横幅沉浸态通知VM
   */
  getImmersiveVm(): INotificationImmersiveVm;

  /**
   * 垂直滑动VM
   *
   * @returns 垂直滑动VM
   */
  getVerticalSwipeVm(): INotificationVerticalSwipeVm | undefined;

  /**
   * 获取流量套餐信息VM
   *
   * @returns 流量套餐信息VM
   */
  getDataPlanVm(): INotificationDataPlanVm | undefined;

  /**
   * 获取更多通知头部VM
   *
   * @returns 更多通知头部VM
   */
  getNotificationMoreHeaderVm (): INotificationMoreHeaderVm | undefined;

  /**
   * 获取通知实况点击VM
   *
   * @returns 通知实况点击VM
   */
  getNotificationLiveClickVm?(ntf: LiveNotification): INotificationLiveClickVm;

  /**
   * 清理某个通知对应的所有VM
   *
   * @param ntf 通知数据
   */
  deleteVmByNtf(ntf: NotificationBase): void;

  /**
   * 更新某个通知对应的所有VM的数据
   *
   * @param ntf 通知数据
   */
  updateVmByNtf(ntf: NotificationBase): void;

  /**
   * 清理所有单通知对应的VM
   */
  deleteVmByAllNtf(): void;
}