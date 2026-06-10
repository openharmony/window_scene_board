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

import CommonStyleManager from '../../manager/CommonStyleManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'CommonTemplate-StyleConfiguration';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const KLV_ANTIALIAS_NUM: number = 0.4;

export class ToggleBaseComponentStyle {
  cellHeight: number = ResUtils.getConvertNumber(DeviceHelper.isPC() ? '84vp' : '94vp');
  cellWidth: number = ResUtils.getConvertNumber(DeviceHelper.isPC() ? '54vp' : '64vp');
  circleWidth: number = ResUtils.getConvertNumber(DeviceHelper.isPC() ? '42vp' : '48vp');
  circleHeight: number = ResUtils.getConvertNumber(DeviceHelper.isPC() ? '42vp' : '48vp');
  iconWidth: number = ResUtils.getConvertNumber(DeviceHelper.isPC() ? '22vp' : '24vp');
  iconHeight: number = ResUtils.getConvertNumber(DeviceHelper.isPC() ? '22vp' : '24vp');
  dragCircleWidth: number = ResUtils.getConvertNumber('60vp');
  dragCircleHeight: number = ResUtils.getConvertNumber('60vp');
  dragIconWidth: number = ResUtils.getConvertNumber('36vp');
  dragIconHeight: number = ResUtils.getConvertNumber('36vp');
  subPanelSize: number = ResUtils.getConvertNumber('8vp');
  textMargin: number = ResUtils.getConvertNumber('4vp');
  topIconPadding: number = ResUtils.getConvertNumber('12vp');
  topIconMarginRight: number = ResUtils.getConvertNumber('8vp');
  topIconMarginBottom: number = ResUtils.getConvertNumber('10vp');
  topIconMarginTop: number = ResUtils.getConvertNumber('16vp');
  marginLeft: number = ResUtils.getConvertNumber('12vp');
  marginRight: number = ResUtils.getConvertNumber('8vp');
  borderRadius: number = ResUtils.getConvertNumber('16vp');
  backgroundColor: ResourceColor = $r('app.color.control_center_component_background');
  iconOffBG: ResourceColor = $r('app.color.icon_off_bg');
  iconOnBG: ResourceColor = $r('app.color.batch_modif_id_color_emphasize');
  iconOnColor: string = '#FFFFFFFF';
  iconOffColor: ResourceColor = $r('sys.color.ohos_id_color_secondary');
  iconOffBG1: string = '#1A000000';
  iconOnBG1: string = '#0A59F7';
  iconOffColor1: string = '#99000000';
  iconMarginTop: number = ResUtils.getConvertNumber('6vp');
  iconMarginBottom: number = ResUtils.getConvertNumber($r('app.float.Control_center_icon_margin_bottom'));
  titleSize: number = ResUtils.getConvertNumber('12fp');
  titleColor: ResourceColor = $r('sys.color.ohos_id_color_text_primary');
  titleColor1: string = '#FF000000';
  textHoverWidth: number = ResUtils.getConvertNumber(DeviceHelper.isPC() ? '68vp' : '78vp');
  textHoverHeight: number = ResUtils.getConvertNumber(DeviceHelper.isPC() ? '18vp' : '18vp');
  textHoverRadius: number = ResUtils.getConvertNumber('4vp');
  hoverColor: string = 'rgba(0, 0, 0, 0.05)';
  transparentColor: string = 'rgba(255, 255, 255, 0)';

  // newStyle data for normal toggle
  iconDiameter: number = ResUtils.getConvertNumber($r('app.float.Control_center_icon_diameter'));
  newIconOffBG: ResourceColor = $r('app.color.Control_center_icon_default_bg_color');
  newIconOnBG: ResourceColor = $r('app.color.Control_center_icon_on_bg_color');
  newIconOffColor: ResourceColor = $r('app.color.Control_center_icon_default_color');
  newIconOnColor: ResourceColor = $r('app.color.Control_center_icon_on_color');
  buttonDiameter: number = ResUtils.getConvertNumber($r('app.float.Control_center_button_diameter'));
  buttonDiameterSingleFold: number = ResUtils.getConvertNumber($r('app.float.Single_fold_control_center_button_diameter'));
  buttonLabelSpace: number = ResUtils.getConvertNumber($r('app.float.Control_center_button_label_space'));
  buttonLabelHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_button_font_lineheight'));
  buttonLabelTopPadding: number = ResUtils.getConvertNumber($r('app.float.Control_center_button_label_top_padding'));
  buttonLabelPadding: number = ResUtils.getConvertNumber($r('app.float.Control_center_button_label_padding'));
  fontPaddingTop: number = ResUtils.getConvertNumber($r('app.float.Control_center_quick_toggle_label_font_padding_top'));
  labelTopPadding: number = ResUtils.getConvertNumber($r('app.float.Control_center_quick_toggle_label_top_padding'));
  buttonLabelWidth: number = ResUtils.getConvertNumber($r('app.float.Control_center_button_label_width'));
  buttonLabelHoverWidth: number = ResUtils.getConvertNumber($r('app.float.Control_center_button_label_hover_width'));
  controlCenterHoverArrowWidth: number = ResUtils.getConvertNumber($r('app.float.Control_center_hover_arrow_width'));
  iconOnBgBrightness: number = ResUtils.getConvertNumber($r('app.float.Control_center_icon_on_bg_brightness'));
  iconOffBgBrightness: number = ResUtils.getConvertNumber($r('app.float.Control_center_icon_default_bg_brightness'));
  labelFontSize: number = ResUtils.getConvertNumber($r('app.float.Control_center_button_font_size'));
  labelFontColor: ResourceColor = $r('app.color.Control_center_button_font_color');
  labelLineHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_button_font_lineheight'));
  topIconOffBgColor: ResourceColor = $r('app.color.Control_center_wifiBlue_icon_default_bg_color');
  topIconOnBgColor: ResourceColor = $r('app.color.Control_center_wifiBlue_icon_on_bg_color');
  topIconOffBgBrightness: number = ResUtils.getConvertNumber($r('app.float.Control_center_wifiblue_icon_default_bg_brightness'));
  topIconOnBgBrightness: number = ResUtils.getConvertNumber($r('app.float.Control_center_wifiblue_icon_on_bg_brightness'));
  netIconOnColor: ResourceColor = $r('app.color.Control_center_network_icon_on_color');
  topButtonDiameter: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_Diameter'));
  topButtonDiameterSingleFold: number = ResUtils.getConvertNumber($r('app.float.Single_fold_control_center_long_button_Diameter'));
  topButtonLeftPadding: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_Diameter'));
  wifiButtonDiameter: number = ResUtils.getConvertNumber($r('app.float.Control_center_wifi_icon_Diameter'));
  wifiButtonBottomPadding: number = ResUtils.getConvertNumber($r('app.float.Control_center_wifi_icon_bottom_padding'));
  topIconDiameter: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_icon_Diameter'));
  topButtonDefaultFontColor: ResourceColor = $r('app.color.Control_center_long_button_font_default_color');
  topButtonOnFontColor: ResourceColor = $r('app.color.Control_center_long_button_font_on_color');
  topButtonFontWeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_font_weight'));
  topButtonFontSize: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_font_size'));
  topButtonMainFontSize: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_main_font_size'));
  topButtonSubFontSize: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_sub_font_size'));
  topButtonLabelSpace: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_label_space'));
  topPcButtonFontSize: number = ResUtils.getConvertNumber($r('app.float.Control_center_pc_long_button_font_size'));
  topOtherButtonFontSize: number = ResUtils.getConvertNumber($r('app.float.Control_center_other_long_button_font_size'));
  lineHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_font_lineheight'));
  longButtonSpaceBetween: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_spaceBetween'));
  longButtonSpaceBetweenSingleFold: number = ResUtils.getConvertNumber($r('app.float.Single_fold_control_center_long_button_icon_label_space'));
  longButtonLabelTopPadding: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_label_top_padding'));
  longButtonLabelLeftPadding: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_label_left_padding'));
  longButtonLeftMargin: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_left_margin'));
  longButtonRightMargin: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_right_margin'));
  longButtonWidth: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_width'));
  longButtonArrowLeftPadding: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_arrow_left_padding'));
  longButtonArrowBottomPadding: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_arrow_bottom_padding'));
  longButtonHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_long_button_height'));
  rateOnValue: number = ResUtils.getConvertNumber($r('app.float.Control_center_brightness_rate_on'));
  rateOffValue: number = ResUtils.getConvertNumber($r('app.float.Control_center_brightness_rate_off'));
  lightOnValue: number = ResUtils.getConvertNumber($r('app.float.Control_center_brightness_lightUpDegree_on'));
  lightOffValue: number = ResUtils.getConvertNumber($r('app.float.Control_center_brightness_lightUpDegree_off'));
  wifiRate: number = ResUtils.getConvertNumber(('app.float.Control_center_wifi_rate'));
  wifiLightUpDegree: number = ResUtils.getConvertNumber($r('app.float.Control_center_wifi_lightUpDegree'));
  otherIconPadding: number = ResUtils.getConvertNumber($r('app.float.Control_center_other_icon_padding'));
  otherIconPaddingRight: number = ResUtils.getConvertNumber($r('app.float.Control_center_other_icon_padding_right'));
  bussinessStyleSymbolSize: number = ResUtils.getConvertNumber($r('app.float.Control_center_bussiness_style_symbol_width'));
  bussinessStyleSymbolMarginBottom: number = ResUtils.getConvertNumber($r('app.float.Control_center_bussiness_style_symbol_margin_bottom'));
  bussinessStyleTopToggleSymbolSize: number = ResUtils.getConvertNumber($r('app.float.Control_center_top_toggle_bussiness_style_symbol_width'));
  bussinessStyleToggleSymbolMarginBottom: number = ResUtils.getConvertNumber($r('app.float.Control_center_top_toggle_bussiness_style_symbol_margin_bottom'));

  // newStyle data for plugin toggle, because it cannot recognise ResourceColor
  newIconOffBGStr: string = ResUtils.getInnerString($r('app.string.Control_center_icon_default_bg_color'));
  newIconOnBGStr: string = ResUtils.getInnerString($r('app.string.Control_center_icon_on_bg_color'));
  newIconOnColorStr: string = ResUtils.getInnerString($r('app.string.Control_center_icon_on_color'));
  newIconOffColorStr: string = ResUtils.getInnerString($r('app.string.Control_center_icon_default_color'));
  newIconPadding: number = ResUtils.getConvertNumber($r('app.float.Control_center_quickToggle_padding'));
  pluginComponentPadding: number = ResUtils.getConvertNumber($r('app.float.Control_center_pluginComponent_padding'));
  pluginComponentRightPadding: number = ResUtils.getConvertNumber($r('app.float.Control_center_pluginComponent_right_padding'));
  labelFontColorStr: string = ResUtils.getInnerString($r('app.string.Control_center_button_font_color'));

  // Antialias
  antialias: number = DeviceHelper.isHYM() ? KLV_ANTIALIAS_NUM : 0;

  // shadow
  toggleIconShadowColor: string = ResUtils.getInnerString($r('app.string.Control_center_icon_shadow_color'));
  toggleIconShadowRadius: number = ResUtils.getConvertNumber($r('app.float.Control_center_icon_shadow_radius'));
  toggleIconShadowOffsetY: number = ResUtils.getConvertNumber($r('app.float.Control_center_icon_shadow_offset_y'));
}

export class ToggleLabelStyle {
  // 控制中心下方快捷开关的文字颜色
  labelColor: ResourceColor = ResUtils.getInnerString($r('app.string.Control_center_button_font_color'));
  labelStyle: BrightnessOptions | undefined = undefined;

  public setLabelColor(labelColor: ResourceColor): void {
    log.showInfo(`setLabelColor: ${labelColor}`);
    this.labelColor = labelColor;
  }

  public setLabelStyle(option: BrightnessOptions): void {
    this.labelStyle = option;
  }
}

export default class StyleConfiguration {
  static getStyle(): ToggleBaseComponentStyle {
    const key: string = TAG + '-ToggleBaseComponent';
    return CommonStyleManager.getStyle(key, ToggleBaseComponentStyle);
  }

  static getToggleLabelStyle(): ToggleLabelStyle {
    const key: string = TAG + '-ToggleLabel';
    return CommonStyleManager.getStyle(key, ToggleLabelStyle);
  }
}