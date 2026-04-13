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

import { LiveRichTextModel } from '../model/LiveCommonModel';

/**
 * 三方实况左右卡片VM
 */
export interface ILiveCardOtherFlightVm {
  /**
   * 高铁拓展区标题字体大小
   */
  layoutTitleSize?: Length;

  /**
   * 高铁拓展区标题字体颜色
   */
  layoutTitleColor?: ResourceColor | undefined;

  /**
   * 高铁拓展区标题外间距
   */
  layoutTitleMargin?: Margin;

  /**
   * 高铁拓展区内容字体大小
   */
  layoutContentSize?: Length;

  /**
   * 高铁拓展区内容字体颜色
   */
  layoutContentColor?: ResourceColor | undefined;

  /**
   * 是否左侧区域文本镜像
   */
  isLayoutFirstRTL?: boolean;

  /**
   * 是否右侧区域文本镜像
   */
  isLayoutLastRTL?: boolean;

  /**
   * 右侧标题角标文本
   */
  layoutLastTitleBadgeText?: string

  /**
   * 右侧标题角标无障碍文本
   */
  layoutLastTitleBadgeAccessibilityText?: string

  /**
   * 右侧内容角标文本
   */
  layoutLastContentBadgeText?: string

  /**
   * 右侧内容角标无障碍文本
   */
  layoutLastContentBadgeAccessibilityText?: string

  /**
   * 中间文本颜色
   */
  layoutSpaceTextColor?: ResourceColor

  /**
   * 中间边框颜色
   */
  layoutSpaceTextBorderColor?: ResourceColor

  /**
   * 底部文本颜色
   */
  layoutAdditionalTextColor?: ResourceColor

  /**
   * 中间图片缩放倍数
   */
  layoutSpaceContentScale?: number
}