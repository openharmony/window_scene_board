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
import { FrameCount } from '../../utils/FrameCount';

/**
 * 组通知卡片ViewModel
 */
export interface INotificationNormalGroupVm {
  /**
   * 是否展开
   */
  isExpanded: boolean;
  /**
   * 是否隐藏通知内容
   */
  isHideNtfContent: boolean;
  /**
   * 通知隐藏内容
   */
  hideText: string;
  /**
   * 剩余通知数量
   */
  remainderCount: string;
  /**
   * 组通知Id
   */
  componentId: string;
  /**
   * 组通知展开态通知头Id
   */
  headerComponentId: string;
  /**
   * 是否显示时间
   */
  isShowDateTime: boolean;
  /**
   * 折叠态第一条通知Y值
   */
  briefFirstNtfY: number;
  /**
   * 折叠态图标和第一条通知距离Y值(需要移动的距离)
   */
  briefIconDiffY: number;
  /**
   * 折叠态图标Y值
   */
  briefIconY: number;
  /**
   * 子通知数组
   */
  children: NormalNotification[];
  frameCount?: FrameCount;

  /**
   * 组通知图标共享动效时过渡效果
   */
  iconTransition?: TransitionEffect | undefined;

  /**
   * 标题颜色
   */
  titleFontColor?: ResourceColor | undefined;

  /**
   * 文本颜色
   */
  textFontColor?: ResourceColor | undefined;

  /**
   * 内容文本字体前景提亮参数
   */
  fontFgBrightness?: BrightnessOptions | undefined;

  // 隐藏文本颜色
  hideFontColor?: ResourceColor | undefined;

  // 组通知个数文本颜色
  remainderCountFontColor?: ResourceColor | undefined;

  // 组通知个数文本背景颜色
  remainderCountBgColor?: ResourceColor | undefined;

  // 组通知个数文本前景提亮参数
  remainderCountFgBrightness?: BrightnessOptions | undefined;

  // 组通知个数文本背景提亮参数
  remainderCountBgBrightness?: BrightnessOptions | undefined;

  /**
   * 折叠收起切换
   * @returns
   */
  switchExpand(isMenuExpand: boolean): void;

  /**
   * 获取折叠态通知内容动效
   *
   * @param index 内容的索引值
   * @returns
   */
  getBriefTextAnimation(index: number): TransitionEffect;

  /**
   * 获取展开态通知内容动效
   *
   * @returns
   */
  getContentTextAnimation(): TransitionEffect;

  /**
   * 收起组通知
   */
  collapseGroup(): void;

  /**
   * 获取组通知标题
   */
  getBriefTitleText(entry: NormalNotification): string;

  /**
   * 获取组通知内容
   */
  getBriefContentText(entry: NormalNotification): string;

  initFrameCount(): void;

  isFrameValid(index: number): boolean;

  /**
   * 是否使用RenderGroup
   */
  isRenderGroup(textItem: string): boolean;

  /**
   * 子通知是否响应横滑点击事件
   */
  isChildEnable(): boolean

  /**
   * 点击事件处理
   */
  onClick(isMenuExpand: boolean): void;

  /**
   * 组通知图标geometryTransition动效Id
   */
  getGeometryTransitionId(): string | undefined;
}