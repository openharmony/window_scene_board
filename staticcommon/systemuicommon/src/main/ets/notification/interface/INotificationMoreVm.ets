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

import { NotificationBase } from '../../model/NotificationBase';

/**
 * 更多通知ViewModel
 */
export interface INotificationMoreVm {
  /**
   * 简要描述
   */
  readonly briefContent: string;
  /**
   * 更多通知应用列表
   */
  readonly moreNtfAppList: NotificationBase[];

  textTranEffect: TransitionEffect;

  isCreatedExtraBriefWhenCollapsed: boolean;

  isExtraNtfsCollapseStatusChanging: boolean;

  isAccessibilityFocused: boolean;

  /**
   * 获得通知图标的横向位移
   *
   * @param index 图标索引值
   * @returns 位移距离
   */
  getStartMargin(ntf: NotificationBase): string;

  /**
   * 获取通知图标的层级
   *
   * @param index 图标索引值
   * @returns 层级
   */
  getZIndex(ntf: NotificationBase): number;

  /**
   * 获取图标宽度
   *
   * @returns 宽度大小
   */
  getIconWidth(): string;

  /**
   * 获取更多通知图标动效
   *
   * @param index 图标索引值
   * @returns 图标动效
   */
  getIconAnimation(ntf: NotificationBase): TransitionEffect;

  getTextTranEffectWhenCollapsed(): void;

  getIconTranEffectWhenCollapsed(): void;

  getFirstExtraNtfDelayTime(): number;

  /**
   * 获取更多通知折叠态卡片背景
   *
   * @returns 背景颜色
   */
  getMoreBriefBgColor(): ResourceColor | undefined;
}