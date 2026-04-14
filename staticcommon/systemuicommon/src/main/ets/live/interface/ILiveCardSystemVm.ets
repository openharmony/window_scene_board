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

/**
 * 实况卡片VM
 */
export interface ILiveCardSystemVm {
  /**
   * 标题
   */
  title: ResourceStr;
  /**
   * 主标题是否隐藏
   */
  isHideTitleText?: boolean;
  /**
   * 标题是否显示为大文本
   */
  isBigTitle: boolean;
  /**
   * 标题颜色
   */
  titleFontColor: ResourceColor | undefined;
  /**
   * 标题字体大小
   */
  titleFontSize: Length | undefined;
  /**
   * 标题行高
   */
  titleLineHeight: Length;
  /**
   * 文本
   */
  text: ResourceStr;
  /**
   * 副文本是否允许上树
   */
  isContentAppear?: boolean;
  /**
   * 副文本是否隐藏
   */
  isHideContentText?: boolean;
  /**
   * sim卡图标
   */
  simIcon: Resource | undefined;
  /**
   * sim卡图标颜色
   */
  simIconColor: Array<ResourceColor>;
  /**
   * 文本颜色
   */
  textFontColor: ResourceColor | undefined;
  /**
   * 字体大小
   */
  textFontSize: Length | undefined;
  /**
   * 字体行高
   */
  textLineHeight: Length;
  /**
   * 内容是否需要开启缓存组
   */
  contentRenderGroup: boolean;

  /**
   * 系统实况字体覆盖区域高度
   */
  fontFixedAreaHeight: number;

  maxFontScale: number;

  /**
   * 是否存在按钮
   */
  hasActionButtons?: boolean;

  /**
   * 是否展示按钮
   */
  isShowActionButtons?: boolean;

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
   * 应用图标是否隐藏
   */
  isHideAppIcon?: boolean;

  /**
   * 图标点击事件
   */
  onIconClick?: (event: ClickEvent) => void;

  /**
   * 副字体前景提亮
   */
  textForegroundBrightness: BrightnessOptions | undefined;

  /**
   * 是否隐藏实况内容
   */
  isHideContent(): boolean;

  /**
   * 标题无障碍字符串
   */
  getTitleAccessibilityText(): string;

  /**
   * 内容无障碍字符串
   */
  getContentAccessibilityText(): string;

  /**
   * 获取卡片高度
   * @returns 卡片高度
   */
  getCardHeight(): number;

  /**
   * 副字体前景颜色
   */
  getSolidTextColor(): ResourceColor | undefined;
}