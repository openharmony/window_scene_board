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

/**
 * 隐藏保护通知VM，如应用锁隐藏，智能提醒隐藏，锁屏隐藏等
 */
export interface INotificationPrivacyVm {
  /**
   * 加锁通知中的最新通知
   */
  latestNotification: NormalNotification;

  /**
   * 当前通知是否处于应用锁保护状态
   */
  isProtected: boolean;

  /**
   * 当前通知是否处于隐藏状态
   */
  isHidden: boolean;

  /**
   * 隐藏状态通知内容
   */
  content: ResourceStr;

  /**
   * 隐私保护卡片点击直接跳转，不会展开按钮
   */
  onClick: () => void;

  /**
   * 是否为底部扩展实况通知
   */
  isExpandedLive?: boolean;

  /**
   * 标题字号
   */
  titleFontSize?: Length;

  /**
   * 标题行高
   */
  titleLineHeight?: Length;
}