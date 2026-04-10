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

interface IUserTextStyle {
  family?: ResourceStr;
  size?: Length;
  weight?: FontWeight;
  color?: ResourceColor;
  lineHeight?: Length;
  textAlign?: TextAlign;
  maxLines?: number;
  opacity?: number | Resource;
  maxFontSize?: number | Resource;
  maxFontScale?: number | Resource;
}

/**
 * 自定义文本样式类，用于传递和修改 Text 组件样式
 * @since 2024-07-25
 */
@Observed
export class UserTextStyle {
  public family?: ResourceStr | undefined;
  public size?: Length | undefined;
  public weight?: FontWeight | undefined;
  public color?: ResourceColor | undefined;
  public lineHeight?: Length | undefined;
  public textAlign?: TextAlign | undefined;
  public maxLines?: number | undefined;
  public opacity?: number | Resource | undefined;
  public maxFontSize?: number | Resource | undefined;
  public maxFontScale?: number | Resource | undefined;
  public textOverflow?: TextOverflow | undefined;

  constructor(style: IUserTextStyle, textOverflow?: TextOverflow) {
    this.family = style.family;
    this.size = style.size;
    this.weight = style.weight;
    this.color = style.color;
    this.lineHeight = style.lineHeight;
    this.textAlign = style.textAlign;
    this.maxLines = style.maxLines;
    this.opacity = style.opacity;
    this.maxFontSize = style.maxFontSize;
    this.maxFontScale = style.maxFontScale;
    this.textOverflow = textOverflow;
  }

  /**
   * 合并样式
   * @param style 新样式
   */
  public merge(style: UserTextStyle | undefined) {
    if (!style) {
      return;
    }
    this.family = style.family || this.family;
    this.size = style.size || this.size;
    this.weight = style.weight || this.weight;
    this.color = style.color || this.color;
    this.lineHeight = style.lineHeight || this.lineHeight;
    this.textAlign = style.textAlign || this.textAlign;
    this.maxLines = style.maxLines || this.maxLines;
    this.maxFontSize = style.maxFontSize || this.maxFontSize;
    this.maxFontScale = style.maxFontScale || this.maxFontScale;
  }
}

/**
 * Text 组件的自定义 Builder，读取 UserTextStyle 的样式创建一个 Text 组件
 * @param text 文本内容
 * @param style 使用 UserTextStyle 定义的文本样式
 */
@Builder
export function UserTextBuilder(text: ResourceStr, style: UserTextStyle) {
  Text(text)
    .draggable(false)
    .font(style)
    .fontColor(style.color)
    .maxFontSize(style.maxFontSize)
    .maxFontScale(style.maxFontScale)
    .opacity(style.opacity)
    .lineHeight(style.lineHeight)
    .textAlign(style.textAlign)
    .maxLines(style.maxLines)
    .textOverflow({ overflow: style.textOverflow ?? TextOverflow.Ellipsis })
}