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
 * 胶囊条目布局ID
 */
export enum CapItemId {
  ROOT_ID = '__container__',
  ICON_AREA = 'icon_area',
  LARGE_ICON = 'large_icon',
  EXTEND_AREA = 'extend_area',
  TITLE_TEXT = 'title_text',
  CONTENT_TEXT = 'content_text'
}

/**
 * 胶囊渐隐文本样式
 */
export interface CapFadeTextStyle {
  textId: CapItemId;
  mainText?: ResourceStr;
  secondaryText?: ResourceStr;
  mainTextColor?: ResourceColor;
  secondaryTextColor?: ResourceColor;
  mainTextWeight?: FontWeight;
  secondaryTextWeight?: FontWeight;
  mainTextSize?: Length; // 主文本 最大值、默认值
  secondaryTextSize?: Length; // 副文本 最大值、默认值
  mainMinFontSize?: number | string | Resource; // 主文本自适应的最小值
  isMainText?: boolean;
  isAodCenter?: boolean; // 是否AOD文本居中
  itemSpace?: string | number; // 条目间距
  mainMinScale?: number | Resource; // 主文本最小缩放
  mainMaxScale?: number | Resource; // 主文本最大缩放
  secondaryMinScale?: number | Resource; // 次文本最小缩放
  secondaryMaxScale?: number | Resource; // 次文本最大缩放
  mainTextHeight?: Length; // 主文本高度
  secondaryTextHeight?: Length; // 次文本高度
  mainFgBrightness?: BrightnessOptions; // 主文本前景提亮参数
  secondaryFgBrightness?: BrightnessOptions; // 次文本前景提亮参数
  marginStart?: number;
  marginTop?: number;
  marginEnd?: number;
  marginBottom?: number;
  textAlpha?: number;
  isHideText?: boolean; // 隐藏文本样式
}