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
import { LiveRichTextModel, LiveTimerModel } from '../model/LiveCommonModel';

export interface ILiveCardNavigationVm {
  /**
   * 触摸缩放参数
   */
  cardScale?: number;
  /**
   * 导航图标透明度
   */
  navDirectionOpacity?: number | undefined;
  /**
   * 导航标题颜色
   */
  titleFontColor?: ResourceColor | undefined;
  /**
   * 富文本颜色
   */
  richTextColor?: ResourceColor | undefined;
  /**
   * 是否融合绘制
   */
  renderGroup: boolean;
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

  cardMarginUpperHalf?: Margin;

  cardMarginBottomHalf?: Margin;
  /**
   * 卡片上半区 -- 当前导航方向图标
   */
  currNavDirectionHeight?: string;

  currNavDirectionWidth?: string;

  /**
   * 卡片上半区 -- 导航信息
   */
  navInfoMargin?: LocalizedPadding,

  navInfoAlignRule?: AlignRuleOption,

  /**
   * 卡片上半区 -- 主要导航信息
   */
  mainNavInfoSizeRes?: Resource;

  mainNavInfoSize?: Length | undefined;

  mainNavInfoWeight?: number | FontWeight | string | undefined;

  mainNavInfoColor?: ResourceColor | undefined;

  mainViceSpace?: Resource;
  /**
   * 卡片上半区 -- 次要导航信息
   */
  viceNavInfoSize?: Length | undefined;

  viceNavInfoWeight?: FontWeight | undefined;

  viceNavInfoColor?: ResourceColor | undefined;
  /**
   * 卡片上半区 -- 应用图标属性
   */
  appIconHeight?: string;

  appIconWidth?: string;

  appIconAlignRule?: AlignRuleOption;

  hasNavDirectionIcons?: boolean;

  navDirsWidth: number;

  navDirsSize: Length;

  /**
   * 导航实况固定区域字体覆盖区域高度
   */
  fontFixedAreaHeight: number;

  /**
   * 字体最大缩放倍数
   */
  maxFontScale: number;

  /**
   * 图标点击事件
   */
  onIconClick?: (event: ClickEvent) => void;

  /**
   * 获取图标颜色赋色：仅为svg或png的导航图标赋色
   */
  imgColorFilter: ColorFilter | undefined;

  /**
   * 获取车道图标赋色
   */
  navDirsColorFilter: ColorFilter | undefined;

  /**
   * 获取车道图标透明度
   */
  navDirsOpacity?: number | undefined;

  /**
   * 导航应用图标是否隐藏
   */
  isHideAppIcon?: boolean;

  /**
   * 是否隐藏实况内容
   */
  isHideContent(): boolean;

  /**
   * 将文本转换为带倒计时文本
   * @param text
   * @param timer
   * @returns
   */
  getTimerText(text: string, timer?: LiveTimerModel): string;
  /**
   * 设置卡片上半区数据(无车道2*4)
   */
  setParamWithoutNavigationIcons(): void;
  /**
   * 设置卡片上半区数据
   */
  setParamWithBottom(): void;
  /**
   * 设置导航icon
   */
  setNavDirectIcons(hasNavDirectionIcons: boolean): void;
  /**
   * 设置卡片缩放参数
   */
  getCardScale(): string;
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
   * 获取内容区字体颜色
   * @param richText
   * @returns
   */
  getContentFontColor(richText: LiveRichTextModel): ResourceColor | undefined;
}

