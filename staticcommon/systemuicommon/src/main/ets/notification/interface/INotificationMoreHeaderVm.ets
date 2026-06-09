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

/**
 * 更多通知头部管理
 *
 * @since 2024-11-26
 */
export interface INotificationMoreHeaderVm {
  /**
   * 是否折叠
   */
  readonly isCollapsed: boolean;

  /**
   * 是否按钮折叠
   */
  readonly isButtonCollapsed: boolean;

  /**
   * 缩放值
   */
  readonly scale: number;

  /**
   * 透明度
   */
  readonly opacity: number;

  /**
   * Y轴偏移量
   */
  readonly translateY: number;

  /**
   * 更多通知header按钮组件ID
   */
  readonly moreHeaderButtonId: string;

  /**
   * 是否在一键删除动效过程中
   */
  isInClearAllAnim: boolean;

  /**
   * 更多通知文本最大宽度
   */
  moreHeaderContentMaxWidth: string;

  /**
   * 初始化
   */
  reset(): void;

  /**
   * 链式删除动效
   * @param translateY Y轴偏移量
   */
  deleteChainAnimation(translateY: number): void

  /**
   * 更多通知标题下拉出场动效
   * @param scale 缩放值
   * @param opacity 透明度
   * @param translateY 位移
   */
  moreHeaderAppearAnimation(scale?: number, opacity?: number, translateY?: number): void;

  /**
   * 更多通知标题下拉跟手动效
   * @param translateY 位移
   */
  moreHeaderFollowAnimation(translateY?: number): void;

  /**
   * 更多通知标题下拉跟手后松手回弹动效
   * @param translateY 位移
   */
  moreHeaderReboundAnimation(translateY?: number): void;

  /**
   * 一键删除动效
   *
   * @param scale 缩放值
   * @param opacity 透明度
   * @param translateY 位移
   */
  clearAllAnimation(scale?: number, opacity?: number, translateY?: number): void;

  /**
   * 折叠收起切换
   *
   * @param isFromBrief 点击事件是否由折叠态更多通知触发
   */
  toggleCollapsed(isFromBrief: boolean): void;

  /**
   * 折叠、展开按钮尺寸变化事件
   * @param _
   * @param size
   */
  collapsedButtonSizeChange: (_: SizeOptions, size: SizeOptions) => void;
}