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

import { CommonStyleManager } from '@ohos/systemuicommon';
import { LengthMetrics } from '@kit.ArkUI';

const TAG = 'InputMethodPanel-StyleConfiguration';

export class CommonComponentStyle {
  inputMethodPanelTitleMarginBottom: Length = '12vp';
  inputMethodPanelTitleMargin: Length = '24vp';
  inputMethodPanelTitleHeight: Length = '56vp';
  inputMethodPanelTextWidth: Length = '226vp';
  inputMethodPanelTitleFontSize: Length = '24fp';
  inputMethodPanelSubTitleFontSize: Length = '14fp';
  inputMethodPanelTitleTextColor: ResourceColor = '#e6000000';
  inputMethodPanelTitleTextMarginTop: Length = '15vp';
}

export class InputMethodPanelComponentStyle {
  inputMethodPanelDividerWidth: string = '1vp';
  inputMethodPanelDividerColor: ResourceColor = '#0d000000';
  inputMethodPanelItemDividerMarginLeft: LengthMetrics = LengthMetrics.vp(60);
  inputMethodPanelDividerMarginTopBottom: LengthMetrics = LengthMetrics.vp(4);
  inputMethodPanelMarginLeft: LengthMetrics = LengthMetrics.vp(24);
  inputMethodPanelMarginRight: LengthMetrics = LengthMetrics.vp(24);
  inputMethodPanelItemGap: Length = '4vp';
  inputMethodLanguageListTitleMarginTop: LengthMetrics = LengthMetrics.vp(12);
  inputMethodLanguageListTitleMarginBottom: LengthMetrics = LengthMetrics.vp(4);
  inputMethodLanguageListTitleHeight: Length = '32vp';
  inputMethodLanguageListTitleFontSize: Length = '12vp';
  inputMethodLanguageListTitleFontColor: ResourceColor = '#99000000';
}

export class InputMethodItemStyle {
  inputMethodItemWidth: Length = '324vp';
  inputMethodItemHeight: Length = '40vp';
  inputMethodSubTypeArrowSize: Length = '26vp';
  inputMethodItemMarginLeft: LengthMetrics = LengthMetrics.vp(4);
  inputMethodItemZhListPaddingLeft: LengthMetrics = LengthMetrics.vp(36);
  inputMethodItemMarginRight: LengthMetrics = LengthMetrics.vp(4);
  inputMethodItemMarginTop: LengthMetrics = LengthMetrics.vp(2);
  inputMethodFirstItemMarginTop: LengthMetrics = LengthMetrics.vp(0);
  inputMethodItemMarginBottom: LengthMetrics = LengthMetrics.vp(4);
  inputMethodItemGap: Length = '10vp';
  inputMethodItemPressedColor = $r('app.color.inputmethod_item_pressed_color');

  inputMethodItemIconSize: Length = '24vp';
  inputMethodItemSmallIconSize: Length = '24vp';
  inputMethodItemIconMarginLeft: LengthMetrics = LengthMetrics.vp(18);
  inputMethodItemSmallIconMarginLeft: LengthMetrics = LengthMetrics.vp(18);
  inputMethodItemIconMarginRight: LengthMetrics = LengthMetrics.vp(12);
  inputMethodItemSmallIconMarginRight: LengthMetrics = LengthMetrics.vp(12);

  inputMethodItemTextFontSize: Length = '14vp';
  inputMethodItemTextWidth: Length = '252vp';
  inputMethodZhItemTextWidth: Length = '216vp';
  inputMethodItemTextHeight: Length = '20vp';
  inputMethodItemTextMarginLeft: LengthMetrics = LengthMetrics.vp(2);
  inputMethodItemTextMarginRight: LengthMetrics = LengthMetrics.vp(6);
  inputMethodItemBorderRadius: Length = '16vp';
  inputMethodItemTextColor: ResourceColor = '#e6000000';
  inputMethodItemTextCheckedColor: ResourceColor = '#0A59F7';

  inputMethodSelectedIconSize: Length = '24vp';
  inputMethodSelectedIconMarginLeft: LengthMetrics = LengthMetrics.vp(6);
  inputMethodSelectedIconMarginRight: LengthMetrics = LengthMetrics.vp(18);

  inputMethodItemBorderWidth: Length = '2vp';
  inputMethodItemBorderColor = $r('app.color.inputmethod_item_border_color');

  inputMethodItemHoverColor = $r('app.color.inputmethod_item_hover_color');
}

export default class StyleConfiguration {
  static getCommonComponentStyle(): CommonComponentStyle {
    const key: string = TAG + '-CommonComponent';
    return CommonStyleManager.getStyle(key, CommonComponentStyle);
  }

  static getInputMethodPanelComponentStyle(): InputMethodPanelComponentStyle {
    const key: string = TAG + '-InputMethodPanelComponent';
    return CommonStyleManager.getStyle(key, InputMethodPanelComponentStyle);
  }

  static getInputMethodItemStyle(): InputMethodItemStyle {
    const key: string = TAG + '-InputMethodPanelItem';
    return CommonStyleManager.getStyle(key, InputMethodItemStyle);
  }
}