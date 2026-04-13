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

import { text } from '@kit.ArkGraphics2D';

/**
 * 文本信息
 */
export interface TextInfo {
  /**
   * 文本内容
   */
  textContent: string,

  /**
   * 文本字体大小，与字体引擎调试后确认此单位为vp
   */
  fontSize?: number,

  /**
   * 字重，text.FontWeight定义的枚举值
   */
  fontWeight?: number,

  /**
   * 字体
   */
  fontFamilies?: string[],

  /**
   * 文本最大行数
   */
  maxLines?: number,

  /**
   * Text组件的宽度，单位vp
   */
  textBoxWidth?: number
}

export class TextUtil {
  /**
   * 获取Text组件中文本实际显示内容的最长宽度，显示内容的宽度可能与控件宽度不一致
   * @param textInfo 文本信息
   * @returns 最长行的实际显示宽度,单位vp
   */
  public static getLongestLineActualWidth(textInfo: TextInfo): number {
    const paragraphStyle: text.ParagraphStyle = {
      textStyle: {
        fontSize: textInfo.fontSize,
        fontWeight: textInfo.fontWeight,
        fontFamilies: textInfo.fontFamilies
      },
      maxLines: textInfo.maxLines
    };
    const fontCollection = new text.FontCollection();
    const paragraphGraphBuilder = new text.ParagraphBuilder(paragraphStyle, fontCollection);
    paragraphGraphBuilder.addText(textInfo.textContent);
    const paragraph = paragraphGraphBuilder.build();
    paragraph.layoutSync(textInfo.textBoxWidth);
    return Math.ceil(paragraph.getLongestLine());
  }
}