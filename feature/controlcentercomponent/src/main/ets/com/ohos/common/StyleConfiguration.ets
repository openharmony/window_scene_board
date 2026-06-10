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

import { default as CommonStyleManager } from '@ohos/systemuicommon/src/main/ets/manager/CommonStyleManager';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';

const TAG: string = 'Ctrl-StyleConfiguration';

export class ControlCenterComponentStyle {
  public panelPadding: number = ResUtils.getConvertNumber($r('app.float.control_center_panel_padding'));
  public panelWidth: number = ResUtils.getConvertNumber($r('app.float.control_center_panel_width'));
  public panelListSpace: number = ResUtils.getConvertNumber($r('app.float.control_center_panel_list_space'));
  public bottomSpace: number = ResUtils.getConvertNumber($r('app.float.control_center_panel_bottom_space'));
  public bottomSpaceLand: number = ResUtils.getConvertNumber($r('app.float.control_center_panel_bottom_space_land'));
  public marginBottom: number = ResUtils.getConvertNumber($r('app.float.control_center_panel_margin_bottom'));
  public listMargin: number = ResUtils.getConvertNumber($r('app.float.control_center_panel_list_margin'));
  public borderRadius: number = ResUtils.getConvertNumber($r('app.float.control_center_panel_border_radius'));
  public bottomBankHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_bottomBankHeight'));
  public quickToggleTopMargin: number = ResUtils.getConvertNumber($r('app.float.Control_center_quickToggle_top_margin'));
  public labelColorType1: ResourceColor = $r('app.color.Control_center_label_color_on_lightBackground');
  public labelColorType2: ResourceColor = $r('app.color.Control_center_label_color_on_darkBackground');
  public labelColorType3: ResourceColor = $r('app.color.Control_center_label_color_on_ColorfulBackground');
  public iotMarginBottom: number = ResUtils.getConvertNumber($r('app.float.control_center_iot_margin_bottom'));
  public landscapeOffsetWithPrivacy: number = ResUtils.getConvertNumber($r('app.float.control_center_landscape_privacy_offset'));
  public landscapeOffset: number = ResUtils.getConvertNumber($r('app.float.control_center_landscape_offset'));
}

export class ControlCenterHeaderStyle {
  public headerHeight: number = ResUtils.getConvertNumber($r('app.float.control_center_header_height'));
  public headerHeightLand: number = ResUtils.getConvertNumber($r('app.float.control_center_header_height_land'));
  public paddingLeft: number = ResUtils.getConvertNumber($r('app.float.control_center_header_padding_left'));
  public paddingBottom: number = ResUtils.getConvertNumber($r('app.float.control_center_header_padding_bottom'));
  public tittleMarginBottom: number = ResUtils.getConvertNumber($r('app.float.control_center_title_margin_bottom'));
  public fontSize: number = ResUtils.getConvertNumber($r('app.float.control_center_title_font_size'));
  public fontColor: ResourceColor = $r('app.color.control_center_title_font_color');
  public buttonSize: number = ResUtils.getConvertNumber($r('app.float.control_center_header_button_size'));
  public buttonColor: ResourceColor = $r('app.color.control_center_header_button_color');
  public buttonPadding: number = ResUtils.getConvertNumber($r('app.float.control_center_header_button_padding'));

  //newStyle
  public buttonDiameter: number = ResUtils.getConvertNumber($r('app.float.Control_center_header_button_diameter'));
  public iconPadding: number = ResUtils.getConvertNumber($r('app.float.Control_center_header_button_icon_padding'));
  public headerWidth: number = ResUtils.getConvertNumber($r('app.float.Control_center_header_width'));
  public brightness: number = ResUtils.getConvertNumber($r('app.float.Control_center_icon_default_bg_brightness'));
  public landscapeWidth: number = ResUtils.getConvertNumber($r('app.float.Control_center_landscape_width'));
}

export class ControlCenterMediaCardLayoutStyle {
  public cardWidth: number = ResUtils.getConvertNumber($r('app.float.control_center_media_card_width'));
  public cardHeight: number = ResUtils.getConvertNumber($r('app.float.control_center_media_card_height'));
  public cardLandscapeWidth: number = ResUtils.getConvertNumber($r('app.float.control_center_landscape_media_card_width'));
  public cardLandscapeHeight: number = ResUtils.getConvertNumber($r('app.float.control_center_landscape_media_card_height'));
  public cardHeightWithoutMedia: number = ResUtils.getConvertNumber($r('app.float.control_center_media_card_height_without_media'));
  public cardGap: number = ResUtils.getConvertNumber($r('app.float.control_center_card_gap'));
  public cardMargin: number = ResUtils.getConvertNumber($r('app.float.control_center_card_margin'));
  public borderRadius: number = ResUtils.getConvertNumber($r('app.float.control_center_card_border_radius'));

  // newStyle
  public space: number = ResUtils.getConvertNumber($r('app.float.Control_center_mediaAndWifiBlue_spaceBetween'));
  public newCardWidth: number = ResUtils.getConvertNumber($r('app.float.Control_center_meidaCard_width'));
  public newCardHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_meidaCard_width'));
  public newBorderRadius: number = ResUtils.getConvertNumber($r('app.float.Control_center_meidaCard_radius'));
  public brightness: number = ResUtils.getConvertNumber($r('app.float.Control_center_icon_default_bg_brightness'));
  public landscapeWidth: number = ResUtils.getConvertNumber($r('app.float.Control_center_landscape_width'));
  public mediaLandscapeWidth: number = ResUtils.getConvertNumber($r('app.float.Control_center_meidaCard_landscape_width'));
  public terminalButtonTopMargin: number = ResUtils.getConvertNumber($r('app.float.Control_center_media_terminal_top_margin'));
}

export class ControlCenterLongButtonLayoutStyle {
  public rowSpace: number = ResUtils.getConvertNumber($r('app.float.Control_center_mediaAndWifiBlue_spaceBetween'));
  public space: number = ResUtils.getConvertNumber($r('app.float.Control_center_mediaAndWifiBlue_spaceBetween'));
  public newCardWidth: number = ResUtils.getConvertNumber($r('app.float.Control_center_superTerminal_width'));
  public newCardHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_superTerminal_height'));
}

export class SingleFoldLongButtonStyle {
  public space: number = ResUtils.getConvertNumber($r('app.float.Single_fold_control_center_long_button_spaceBetween'));
  public newCardWidth: number = ResUtils.getConvertNumber($r('app.float.Single_fold_control_center_long_button_width'));
  public newCardHeight: number = ResUtils.getConvertNumber($r('app.float.Single_fold_control_center_long_button_height'));
  public singleCardWidth: number = ResUtils.getConvertNumber($r('app.float.single_fold_control_center_single_card_width'));
}

export class SingleExpandLongButtonStyle {
  public rowSpace: number = ResUtils.getConvertNumber($r('app.float.Single_fold_control_center_long_button_spaceBetween'));
  public space: number = ResUtils.getConvertNumber($r('app.float.Single_expand_control_center_long_button_spaceBetween'));
  public newCardWidth: number = ResUtils.getConvertNumber($r('app.float.Single_expand_control_center_long_button_width'));
  public newCardHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_superTerminal_height'));
  public singleCardWidth: number = ResUtils.getConvertNumber($r('app.float.single_fold_control_center_single_card_width'));
}

export class LargeFoldSliderButtonStyle {
  public newCardWidth: number = ResUtils.getConvertNumber($r('app.float.Large_fold_control_center_slider_button_width'));
  public newCardHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_superTerminal_height'));
}

export class ControlCenterQuickToggleLayoutStyle {
  public toggleLabelHeight: number = ResUtils.getConvertNumber($r('app.float.control_center_toggle_label_height'));
  public padding: number = ResUtils.getConvertNumber($r('app.float.control_center_quick_toggle_padding'));
  public paddingBottom: number = ResUtils.getConvertNumber($r('app.float.control_center_quick_toggle_padding_bottom'));
  public columnGap: number = ResUtils.getConvertNumber($r('app.float.control_center_quick_toggle_column_gap'));
  public cellHeight: number = ResUtils.getConvertNumber($r('app.float.control_center_toggle_cell_height'));
  public borderRadius: number = ResUtils.getConvertNumber($r('app.float.control_center_card_border_radius'));
  public backgroundColor: ResourceColor = $r('app.color.control_center_component_background');

  // newStle
  public togglePanelHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_togglePanel_height'));
  public brightnessWidth: number = ResUtils.getConvertNumber($r('app.float.Control_center_brightness_width'));
  public brightnessHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_brightness_height'));
  public landscapeBrightnessHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_brightness_height_landscape'));
  public brightnessPadding: number = ResUtils.getConvertNumber($r('app.float.Control_center_brightness_padding'));
  public brightnessLeftPadding: number = ResUtils.getConvertNumber($r('app.float.Control_center_brightness_left_padding'));
  public brightnessTopMargin: number = ResUtils.getConvertNumber($r('app.float.Control_center_brightness_top_margin'));
  public brightnessBorderRadius: number = ResUtils.getConvertNumber($r('app.float.Control_center_brightness_borderRadius'));
  public defaultBrightness: number = ResUtils.getConvertNumber($r('app.float.Control_center_icon_default_bg_brightness'));
  public onBrightness: number = ResUtils.getConvertNumber($r('app.float.Control_center_icon_on_bg_brightness_for_brightness_bar'));
  public buttonDiameter: number = ResUtils.getConvertNumber($r('app.float.Control_center_button_diameter'));
  public buttonLabelSpace: number = ResUtils.getConvertNumber($r('app.float.Control_center_button_label_space'));
  public buttonLabelHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_button_font_lineheight'));
  public newIconPadding: number = ResUtils.getConvertNumber($r('app.float.Control_center_quickToggle_padding'));
  public buttonMargin: number = ResUtils.getConvertNumber($r('app.float.Control_center_button_margin'));
  public buttonPaddingTop: number = ResUtils.getConvertNumber($r('app.float.Control_center_quickToggle_padding'));
  public buttonMarginBottom: number = ResUtils.getConvertNumber($r('app.float.Control_center_button_margin_bottom'));
  public quickToggleRowsGap: number = ResUtils.getConvertNumber($r('app.float.Control_center_button_rowsGap'));
  public quickToggleColumnsGap: number = ResUtils.getConvertNumber($r('app.float.Control_center_button_columnsGap'));
  public quickToggleGridBottom: number = ResUtils.getConvertNumber($r('app.float.Control_center_grid_bottom_fix'));
  public pluginPadding: number = ResUtils.getConvertNumber($r('app.float.Control_center_quickToggle_padding'));
  public brightnessBgColor: ResourceColor = $r('app.color.Control_center_brightness_bg_color');
  public blockColor: ResourceColor = $r('app.color.Control_center_brightness_block_color');
  public dividerPaddingTop: number = ResUtils.getConvertNumber($r('app.float.Control_center_divider_padding_top'));
  public dividerPaddingBottom: number = ResUtils.getConvertNumber($r('app.float.Control_center_divider_padding_bottom'));
  public dividerWidth: number = ResUtils.getConvertNumber($r('app.float.Control_center_divider_width'));
  public dividerHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_divider_height'));
  public additionalGridHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_quickToggle_additional_grid_height'));
  public additionalQuickHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_quickToggle_additional_height'));
  public toggleIconShadowOffsetY: number = ResUtils.getConvertNumber($r('app.float.Control_center_icon_shadow_offset_y'));
  public quickToggleGridItemTopPadding: number = ResUtils.getConvertNumber($r('app.float.Control_center_quickToggle_grid_item_top_padding'));
  public quickToggleGridItemBottomPadding: number = ResUtils.getConvertNumber($r('app.float.Control_center_quickToggle_grid_item_bottom_padding'));
  public gridMarginBottom: number = ResUtils.getConvertNumber($r('app.float.Control_center_grid_margin_bottomn'));
  public gridMarginLeft: number = ResUtils.getConvertNumber($r('app.float.Control_center_grid_margin_left'));
  public gridMarginRight: number = ResUtils.getConvertNumber($r('app.float.Control_center_grid_margin_right'));
}

export class QuickToggleLayoutEditComponentStyle {
  public padding: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_padding'));
  public toggleLabelHeight: number = ResUtils.getConvertNumber($r('app.float.control_center_toggle_label_height'));
  public titleHeight: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_title_height'));
  public titleHeightLand: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_title_height_land'));
  public titleFontSize: number = ResUtils.getConvertNumber($r('app.float.control_center_title_font_size'));
  public titleFontColor: ResourceColor = $r('app.color.control_center_title_font_color');
  public titleMarginLeft: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_title_margin_left'));
  public titleMarginBottom: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_title_margin_bottom'));
  public buttonSize: number = ResUtils.getConvertNumber($r('app.float.control_center_header_button_size'));
  public buttonColor: ResourceColor = $r('app.color.control_center_header_button_color');
  public buttonPadding: number = ResUtils.getConvertNumber($r('app.float.control_center_header_button_padding'));

  public paddingBottom: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_padding_bottom'));
  public borderRadius: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_border_radius'));
  public cellHeight: number = ResUtils.getConvertNumber($r('app.float.control_center_toggle_cell_height'));
  public columnGap: number = ResUtils.getConvertNumber($r('app.float.control_center_quick_toggle_column_gap'));

  public dragBgSize: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_grid_drag_bg_size'));

  public fontSize: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_opt_msg_font_size'));
  public fontColor: ResourceColor = $r('sys.color.ohos_id_color_text_secondary');
  public height: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_opt_msg_height'));
  public msgPaddingTop: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_opt_msg_padding_top'));
  public msgPaddingBottom: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_opt_msg_padding_bottom'));
  public msgPadding: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_opt_msg_padding'));

  public editBtnHeight: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_btn_height'));
  public editAreaHeight: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_area_height'));
  public editBtnPadding: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_btn_padding'));
  public editBtnFontColor: ResourceColor = $r('app.color.batch_modif_id_color_text_primary_activated');
  public editBtnFontSize: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_btn_text_size'));
  public editBtnBgColor: ResourceColor = $r('sys.color.ohos_id_color_hover');

  public upAreaBgColor: ResourceColor = $r('app.color.control_center_component_background');
  public downAreaBgColor: ResourceColor = $r('app.color.center_edit_down_area_bg_color');

  public msgMarginLeft: number = ResUtils.getConvertNumber($r('sys.float.ohos_id_dialog_margin_start'));
  public msgMarginRight: number = ResUtils.getConvertNumber($r('sys.float.ohos_id_dialog_margin_end'));
  public msgMarginTop: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_msg_margin_top'));
  public msgMarginBottom: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_msg_margin_bottom'));

  public editDialogHeight: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_dialog_height'));
  public editDialogWidth: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_dialog_width'));
  public editDialogWidthLand: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_dialog_width_land'));
  public editDialogFontSize: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_dialog_font_size'));
  public editDialogBtnMarginLF: number = ResUtils.getConvertNumber($r('sys.float.ohos_id_dialog_margin_start'));
  public editDialogFontHeight: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_dialog_font_height'));
  public editDialogBtnMarginTop: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_dialog_btn_margin_top'));
  public editDialogButtonSize: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_dialog_btn_font_size'));
  public editDialogDividerHeight: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_dialog_divider_height'));
  public editDialogButtonHeight: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_dialog_btn_height'));
  public editDialogRadius: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_dialog_radius'));
  public editDialogBtnWidth: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_dialog_btn_width'));
  public editDialogColor: ResourceColor = $r('app.color.colorDialogBg');
  public editDialogBtnFontColor: ResourceColor = $r('app.color.batch_modif_id_color_text_primary_activated');
  public editDialogBtnBgColor: ResourceColor = $r('sys.color.ohos_id_color_activated');
  public editDialogDividerColor: ResourceColor = $r('sys.color.ohos_id_color_list_separator');
  public editDialogFontMarginTop: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_dialog_font_margin_top'));
  public editDialogDividerWidth: number = ResUtils.getConvertNumber($r('app.float.quick_toggle_edit_dialog_divider_width'));
}


export default class StyleConfiguration {
  static getControlCenterComponentStyle(): ControlCenterComponentStyle {
    const key: string = TAG + '-ControlCenterComponent';
    return CommonStyleManager.getStyle(key, ControlCenterComponentStyle);
  }

  static getControlCenterHeaderStyle(): ControlCenterHeaderStyle {
    const key: string = TAG + '-ControlCenterUpTitle';
    return CommonStyleManager.getStyle(key, ControlCenterHeaderStyle);
  }

  static getControlCenterMediaCardLayoutStyle(): ControlCenterMediaCardLayoutStyle {
    const key: string = TAG + '-ControlCenterMediaCardLayout';
    return CommonStyleManager.getStyle(key, ControlCenterMediaCardLayoutStyle);
  }

  static getSingleFoldLongButtonStyle(): SingleFoldLongButtonStyle {
    const key: string = TAG + '-SingleFoldLongButtonStyle';
    return CommonStyleManager.getStyle(key, SingleFoldLongButtonStyle);
  }

  static getSingleExpandLongButtonStyle(): SingleExpandLongButtonStyle {
    const key: string = TAG + '-SingleExpandLongButtonStyle';
    return CommonStyleManager.getStyle(key, SingleExpandLongButtonStyle);
  }

  static getLargeFoldSliderButtonStyle(): LargeFoldSliderButtonStyle {
    const key: string = TAG + '-LargeFoldSliderButtonStyle';
    return CommonStyleManager.getStyle(key, LargeFoldSliderButtonStyle);
  }

  static getControlCenterLongButtonLayoutStyle(): ControlCenterLongButtonLayoutStyle {
    const key: string = TAG + '-ControlCenterLongButtonLayoutStyle';
    return CommonStyleManager.getStyle(key, ControlCenterLongButtonLayoutStyle);
  }

  static getControlCenterQuickToggleLayoutStyle(): ControlCenterQuickToggleLayoutStyle {
    const key: string = TAG + '-ControlCenterQuickToggleLayout';
    return CommonStyleManager.getStyle(key, ControlCenterQuickToggleLayoutStyle);
  }

  static getQuickToggleLayoutEditComponentStyle(): QuickToggleLayoutEditComponentStyle {
    const key: string = TAG + '-QuickToggleLayoutEditComponent';
    return CommonStyleManager.getStyle(key, QuickToggleLayoutEditComponentStyle);
  }
}