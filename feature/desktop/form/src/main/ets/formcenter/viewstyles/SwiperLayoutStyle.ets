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

import { StyleConstants } from '@ohos/launchercommon';
import { FormDescriptionStyle } from './FormDescriptionStyle';
import { FormItemStyle } from './FormItemStyle';

export class SwiperLayoutStyle {
  // config
  public isShowThemeCard: boolean = true;
  public isShowDescription: boolean = true;
  public descriptionMargin: number = 16;

  // description
  public descriptionStyle: FormDescriptionStyle = new FormDescriptionStyle();
  public descriptionDefaultMargin: number = 32;

  // form
  public isFormClickableInAccess: boolean = false;
  public formStyle: FormItemStyle = new FormItemStyle();

  // Form ItemView Column
  public formItemColumnWidth: Length = '100%';
  public formItemColumnHeight?: Length;
  public formItemColumnAlignItem?: HorizontalAlign = HorizontalAlign.Start;
  public formItemColumnJustifyContent?: FlexAlign = FlexAlign.Center;

  // Swiper ItemView Column
  public swiperItemColumnWidth: Length = '100%';
  public swiperItemAlignItem?: HorizontalAlign = HorizontalAlign.Start;
  public swiperItemHeight?: number = 146;

  // button
  public buttonWidth?: Length;
  public buttonHeight?: Length = 40;
  public buttonBgColor?: ResourceColor;
  public buttonPadding?: Padding | Length | LocalizedPadding = {
    top: 8,
    bottom: 8,
  }
  public buttonOptions?: ButtonOptions = {type: ButtonType.Capsule};

  // button text
  public buttonText: string | Resource = $r('app.string.add_to_desktop');
  public buttonTextSize?: number | string | Resource = $r('sys.float.ohos_id_text_size_button1');
  public buttonTextColor?: ResourceColor = $r('sys.color.ohos_id_color_text_primary_contrary');
  public buttonTextWeight?: number | FontWeight | string = FontWeight.Medium;
  public maxFontScale?: number = StyleConstants.FONT_MAX_SCALE_FORM_TEXT;
  public buttonTextHeight?: Length = 24;
  // button for negative screen
  public buttonTextForNegativeScreen: Resource = $r('app.string.add_form_to_intelligent');
  public buttonStyleNormal: ButtonStyleMode = ButtonStyleMode.NORMAL;
  public buttonStyleEmphasized: ButtonStyleMode = ButtonStyleMode.EMPHASIZED;
  public buttonStyleDisableOpacity: number = 0.4;
  public buttonStyleOpacity: number = 1;

  // button column
  public buttonColumnHeight?: Length = 40;
  public buttonColumnWidth?: Length;
  public buttonColumnAlignItems?: HorizontalAlign = HorizontalAlign.Center;
  public buttonColumnMargin?: Margin | Length | LocalizedMargin = {
    left: 16,
    right: 16,
    top: 16,
    bottom: 28
  };
  public twoButtonGap: number = 12;

  // swiper
  public swiperWidth: Length = '100%'
  public swiperHeight: Length = '100%'
  public clip?: boolean = false;
  public disPlayCount?: number = 1;
  public displayMode?: SwiperDisplayMode = SwiperDisplayMode.STRETCH;
  public loop?: boolean = false;
  public indicator?: boolean = true;

  // 横屏应用
  public isLandSpace?: boolean = false;

  /**
   * 添加至桌面Text最大行数
   */
  public addToDeskTopMaxLines?: number = undefined;

  /**
   * 添加至桌面Text超过最大行数显示方式
   */
  public addToDeskTopTextOverflow?: TextOverflowOptions = undefined;

  constructor() {
    this.initFormDescription();
    this.descriptionStyle.descriptionAccessibilityGroup = true;
    this.descriptionStyle.descriptionAccessibilityLevel = false
    this.formStyle.stackAccessibilityLevel = false;
  }

  private initFormDescription(): void {
    // appName Style
    this.descriptionStyle.appNameFontSize = $r('sys.float.Title_M');
    this.descriptionStyle.appNameFontWeight = FontWeight.Bold;
    this.descriptionStyle.appNameLineHeight = undefined;
    this.descriptionStyle.appNameMargin = {
      top: 24,
      left: this.descriptionMargin,
      right: this.descriptionMargin
    }

    // Description Style
    this.descriptionStyle.descriptionLineHeight = undefined;
    this.descriptionStyle.descriptionMaxLines = 2;
    this.descriptionStyle.descriptionMargin = {
      top: 2,
      bottom: 24,
      left: this.descriptionMargin,
      right: this.descriptionMargin
    }

    // Column Style
    this.descriptionStyle.columnHeight = 102;
    this.descriptionStyle.columnWidth = '100%';
  }

  public adaptDescription(cardViewMargin: number): void {
    // 半模态左右默认显示一定宽度的其他页面卡片，设置描述信息左右间距时需要考虑默认的swiper组件的margin值
    let marginDiff: number = this.descriptionDefaultMargin - cardViewMargin;
    this.descriptionMargin = marginDiff > 0 ? marginDiff : 0;
  }
}

