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
import uiEffect from '@ohos.graphics.uiEffect';
import { LiveCardShowAnimationEvent } from '../../event/LiveCardShowAnimationEvent';

/**
 * 三方实况卡片VM
 */
export interface ILiveCardOtherVm {
  /**
   * 标题
   */
  title: string;
  /**
   * 是否隐藏标题文本
   */
  isHideTitleText?: boolean;
  /**
   * 是否隐藏副文本
   */
  isHideContentText?: boolean;
  /**
   * 标题字重
   */
  titleFontWeight: number | FontWeight | string | undefined;
  /**
   * 标题字体最小大小
   */
  titleMinFontSize: Length;
  /**
   * 标题字体最大大小
   */
  titleMaxFontSize: Length;
  /**
   * 标题颜色
   */
  titleFontColor: ResourceColor | undefined;
  /**
   * 内容区字体大小
   */
  contentTextFontSize: Length | undefined;
  /**
   * 内容区字体颜色
   */
  contentFontColor: ResourceColor | undefined;
  /**
   * 内容是否需要开启缓存组
   */
  contentRenderGroup: boolean;
  /**
   * 富文本line高度
   */
  richTextLineHeight: Length;
  /**
   * 分割线颜色
   */
  dividerFgColor: ResourceColor;
  /**
   * 分割线亮度
   */
  dividerBrightness: BrightnessOptions | undefined;
  /**
   * 服务提供商字体颜色
   */
  providerNameColor: ResourceColor;
  /**
   * 扩展区透明度
   */
  extendOpacity: number | undefined;
  /**
   * 下划线透明度
   */
  underlineOpacity: number;
  /**
   * 下划线宽度
   */
  contentLayoutLength: number;
  /**
   * 是否展示下划线
   */
  isShowUnderline: boolean;
  /**
   * 标题边界
   */
  titleMargin: Resource
  /**
   * 上半区padding
   */
  topZonePadding: Padding | undefined;

  //沉浸态参数
  /**
   * 实况卡片上边距
   */
  cardMarginTop: Length | undefined;

  /**
   * 实况卡片下边距
   */
  cardMarginBottom: Length | undefined;

  /**
   * 实况卡片水平边距
   */
  cardMarginHorizontal: Length | undefined;

  /**
   * 天气动效
   */
  visualEffect: uiEffect.VisualEffect | undefined;

  /**
   * 副文本字号
   */
  richTextFontSize: Resource;

  /**
   * 扩展区高度
   */
  bottomHalfHeight?: Length;

  /**
   * 标题行高
   */
  titleLineHeight?: Length;

  /**
   * 三方实况固定区域字体覆盖区域高度
   */
  fontFixedAreaHeight: number;

  /**
   * 字体最大缩放倍数
   */
  maxFontScale: number;

  /**
   * 图标的透明度
   */
  iconAlpha?: number | undefined;

  /**
   * 图标的背板可见性
   */
  iconBgVisible?: Visibility | undefined;

  /**
   * 图标的背板颜色
   */
  iconBgColor?: ResourceColor | undefined;

  /**
   * 覆盖在右上角的图标的透明度
   */
  topIconAlpha?: number | undefined;

  /**
   * 覆盖在右上角的图标背板可见性
   */
  topBgVisible?: Visibility | undefined;

  /**
   * 覆盖在右上角的图标背板颜色
   */
  topBgColor?: ResourceColor | undefined;

  /**
   * 图标点击事件
   */
  onIconClick?: (event: ClickEvent) => void;

  /**
   * 左右文本的分隔原点颜色
   */
  flightCircleColor: ResourceColor;

  /**
   * 应用图标是否隐藏
   */
  isHideAppIcon?: boolean;

  /**
   * 是否隐藏实况内容
   */
  isHideContent(): boolean;

  /**
   * 获取内容区的文本
   * @param richText
   * @returns
   */
  getContentText(richText: LiveRichTextModel): string;

  /**
   * 获取内容区字体颜色
   * @param richText
   * @returns
   */
  getContentFontColor(richText: LiveRichTextModel): ResourceColor | undefined;

  /**
   * 获取内容区字重
   * @param richText
   * @returns
   */
  getContentFontWeight(richText: LiveRichTextModel): FontWeight;

  /**
   * 获取待计时器文本
   * @param context
   * @returns
   */
  getTimerContent(context: string): string;

  /**
   * 获取文本显示的宽度
   */
  getContentWidth(text: string): number;

  /**
   * 设置卡片上半区高度
   */
  getFixedAreaHeight(): number;

  /**
   * 获取卡片高度
   * @returns 卡片高度
   */
  getCardHeight(): number;

  /**
   * 获取无障碍朗读文本
   * @returns
   */
  getAccessibilityText(text: string): string;

  /**
   * 获取内容无障碍朗读文本
   * @returns
   */
  getContentAccessibilityText(): string;
  /**
   * 场景触发动画
   * @returns
   */
  onLiveCardAnimationEventChange(event: LiveCardShowAnimationEvent): void;
  /**
   * 上树触发动画
   * @returns
   */
  setAppearAnimation(): void;

  /**
   * 获取天气背景高度
   * @returns
   */
  getWeatherBackgroundHeight(): number;
}