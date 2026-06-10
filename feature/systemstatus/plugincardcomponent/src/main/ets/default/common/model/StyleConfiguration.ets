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

import { CommonStyleManager } from '@ohos/systemuicommon';
import { ResUtils } from '@ohos/windowscene';

const TAG = 'PluginCard-StyleConfiguration';

export class PluginCardComponentStyle {
  public topButtonFontWeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_font_weight'));
  public topButtonFontSize: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_font_size'));
  public topPcButtonFontSize: number = ResUtils.getConvertNumber($r('app.float.Control_center_pc_long_button_font_size'));
  public topOtherButtonFontSize: number = ResUtils.getConvertNumber($r('app.float.Control_center_other_long_button_font_size'));
  public lineHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_font_lineheight'));
  public longButtonLeftMargin: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_left_margin'));
  public longButtonRightMargin: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_right_margin'));
  public buttonLabelWidth: number = ResUtils.getConvertNumber($r('app.float.Control_center_button_label_width'));
  public symbolMarginBottom: number = ResUtils.getNumber($r('app.float.Control_center_top_toggle_bussiness_style_symbol_margin_bottom'));
  public newIconOffColor: ResourceColor = $r('sys.color.icon_secondary');
  public newIconOnColor: ResourceColor = $r('sys.color.icon_on_primary');
  // shadow
  public toggleIconShadowColor: string = ResUtils.getInnerString($r('app.string.Control_center_icon_shadow_color'));
  public toggleIconShadowRadius: number = ResUtils.getConvertNumber($r('app.float.Control_center_icon_shadow_radius'));
  public toggleIconShadowOffsetY: number = ResUtils.getConvertNumber($r('app.float.Control_center_icon_shadow_offset_y'));
}

export default class StyleConfiguration {
  static getPluginCardComponentStyle(): PluginCardComponentStyle {
    const key: string = TAG + '-StatusBarBluetoothComponent';
    return CommonStyleManager.getStyle(key, PluginCardComponentStyle);
  }
}