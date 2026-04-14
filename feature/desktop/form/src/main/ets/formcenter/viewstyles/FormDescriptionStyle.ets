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

import { StyleConstants } from '@ohos/launchercommon';

export class FormDescriptionStyle {
  // config
  public isNeedDisplayName: boolean = true;
  public isNeedDescription: boolean = true;

  // common
  public maxFontScale: number = StyleConstants.FONT_MAX_SCALE_FORM_TEXT;

  // appName Style
  public appNameFontSize: number | string | Resource = $r('sys.float.ohos_id_text_size_headline7');
  public appNameFontWeight = FontWeight.Bold;
  public appNameFontFamily?: string;
  public appNameFontColor = $r('sys.color.ohos_id_color_text_primary');
  public appNameLineHeight?: number | string | Resource = 32;
  public appNameHeight?: number | string | Resource = 32;
  public appNameTextAlign? = TextAlign.Center;
  public appNameMaxLines = 1;
  public appNameTextOverflow = TextOverflow.Ellipsis;
  public appNameMargin?: Margin | Length | LocalizedMargin;
  public appNamePadding?: Padding | Length | LocalizedMargin;
  public highLightFontColor: ResourceColor = $r('sys.color.font_emphasize');

  // Description Style
  public descriptionFontSize: number | string | Resource = $r('sys.float.ohos_id_text_size_body1');
  public descriptionFontColor = $r('sys.color.ohos_id_color_text_secondary');
  public descriptionFontWeight = FontWeight.Regular;
  public descriptionFontFamily?: string;
  public descriptionLineHeight?: number | string | Resource = 20;
  public descriptionHeight?: number | string | Resource = 20;
  public descriptionTextAlign = TextAlign.Center;
  public descriptionMaxLines = 2;
  public descriptionTextOverflow = TextOverflow.Ellipsis;
  public descriptionMargin?: Margin | Length | LocalizedMargin;
  public descriptionPadding?: Padding | Length | LocalizedMargin;

  // Column Style
  public columnMargin?: Margin | Length | LocalizedMargin;
  public columnPadding?: Margin | Length | LocalizedMargin;
  public columnHeight?: Length;
  public columnWidth?: Length;
  public columAlignItems?: HorizontalAlign;
  public descriptionAccessibilityGroup?: boolean;
  public descriptionAccessibilityLevel?: boolean;
}