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
 * 实况卡片自定义样式
 */
@Observed
export class LiveCustomerStyle {
  /**
   * 实况卡片上边距
   */
  cardMarginTop: Length;

  /**
   * 实况卡片下边距
   */
  cardMarginBottom: Length;

  /**
   * 实况卡片水平边距
   */
  cardMarginHorizontal: Length;

  /**
   * 标题字重
   */
  titleFontWeight: FontWeight;

  /**
   * 标题字号
   */
  titleFontSize: Resource;

  /**
   * 标题最小字号
   */
  titleMinFontSize?: Resource;

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
  titleLineHeight?: Resource;

  /**
   * 富文本行高
   */
  richTextLineHeight?: Resource;

  /**
   * 固定区域高度
   */
  fixedAreaHeight?: Resource;

  /**
   * 标题字体最大放大倍数
   */
  titleMaxFontScale?: number;
}