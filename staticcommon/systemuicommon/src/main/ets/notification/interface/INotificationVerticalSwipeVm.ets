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
import { RectItem } from '@ohos/basicutils';
import { NotificationBannerDeformState } from '../../model/NotificationBannerDeformState';
import { NotificationBase } from '../../model/NotificationBase';

export interface INotificationVerticalSwipeVm {
  bannerTransY: number;

  /**
   * 是否处于下拉形变流程
   */
  isDeformFlag: boolean;

  /**
   * 是否初始化
   */
  isInitParam: boolean;

  /**
   * 形变相关参数
   */
  bannerDeformState: NotificationBannerDeformState;

  /**
   * 是否支持悬浮窗
   */
  isSupportFloating: boolean;

  /**
   * 初始化
   */
  init(): void;

  /**
   * 销毁
   */
  destroy(): void;

  updateFloatingWindowStatus(entry: NotificationBase, isMidScene: boolean): void;

  /**
   * 获取竖直滑动手势handler
   * @returns
   */
  getVerticalSwipeGesture(): GestureGroupHandler;

  /**
   * 横幅消失
   *
   */
  onVanish(): void;

  /**
   * 初始化形变相关参数
   *
   * @param height 卡片高度
   */
  initBannerDeformParam(height: number): void;

  /**
   * 能否打开悬浮窗
   * @param isSwipe
   * @returns
   */
  canOpenFloating(isSwipe: boolean): Promise<boolean>;

  /**
   * 点击打开悬浮窗
   */
  startFloatingForClick(): void;

  /**
   * 更新点击形变事件
   */
  clickToFloating(floatingRect: RectItem): void;

  /**
   * 通知删除后重置基础信息
   */
  reset(): void;
}