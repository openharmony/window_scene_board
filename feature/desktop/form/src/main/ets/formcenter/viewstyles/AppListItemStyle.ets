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

import { LengthMetrics } from '@kit.ArkUI';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';

export class AppListItemStyle {
  // config
  public isNeedArrow: boolean = true;

  // row item
  public itemHeight?: number = 64;
  public itemHeightSearch?: number;
  public itemWidth?: number;
  public rowMargin?: Margin | Length | LocalizedMargin;
  public rowPadding?: Padding | Length | LocalizedMargin = {
    start: LengthMetrics.vp(8),
    end: LengthMetrics.vp(8),
  };
  public itemRadius: number = 12;
  public hoverColor?: ResourceColor;
  public pressColor?: ResourceColor = $r('sys.color.ohos_id_color_click_effect');
  public selectColor?: ResourceColor;
  public selectColorDark?: ResourceColor;
  public rowAlignItems?: VerticalAlign = VerticalAlign.Center;

  // app icon
  public appSize: number = 48;
  public appRadius: number = 13.24;
  public appBorder?: BorderOptions = { width: '1px', color: '#33808080' };
  public appMargin?: Margin | Length | LocalizedMargin;
  public appPadding?: Padding | Length | LocalizedMargin;
  public interpolation?:ImageInterpolation = ImageInterpolation.Medium;
  public autoResize?: boolean = false;

  // text
  public textFontSize: string | number | Resource = $r('sys.float.ohos_id_text_size_body1');
  public textFontWeight: string | number | FontWeight = FontWeight.Medium;
  public selectTextFontWeight: string | number | FontWeight = FontWeight.Medium;
  public textFontColor: ResourceColor = $r('sys.color.ohos_id_color_text_primary');
  public maxLines?: number = 1;
  public lineHeight?: number = 21;
  public layoutWeight?: number = 1;
  public maxFontScale: number = StyleConstants.FONT_MAX_SCALE_FORM_TEXT;
  public textMargin?: Margin | Length | LocalizedMargin = {
    start: LengthMetrics.vp(16),
  };
  public appNameMargin?: Margin | Length | LocalizedMargin = {
    start: LengthMetrics.vp(16),
    end: LengthMetrics.vp(16),
  };
  public disPlayNamePadding?: Margin | Length | LocalizedMargin = {
    top: LengthMetrics.vp(1),
    end: LengthMetrics.vp(9),
  };
  public textPadding?: Padding | Length | LocalizedMargin;
  public textOverflow?:TextOverflow = TextOverflow.Ellipsis;

  // arrow
  public rightArrowIcon: Resource | string = $r('sys.media.ohos_ic_public_arrow_right');
  public arrowFillColor: ResourceColor = $r('sys.color.ohos_id_color_fourth');
  public arrowWidth: number = 12;
  public arrowHeight: number = 24;

  public needInnerFocusStyle: boolean = false;
  public defaultBorderColor: string = '#00ffffff';
  public defaultBorderWidth: number = 0;
  public innerFocusColor: ResourceStr = '#00ffffff';
  public innerFocusWidth: number = 0;
}