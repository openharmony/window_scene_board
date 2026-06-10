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

const TAG = 'SoundPanel-StyleConfiguration';

export class CommonComponentStyle {
  panelTitleMarginTop: Length = '4vp';
  panelTitlePaddingTop: Length = '4vp';
  panelTitleMarginBottom: Length = '12vp';
  panelTitleMargin: Length = '24vp';
  panelTitleHeight: Length = '56vp';
  panelTitleFontSize: Length = '24fp';
  panelSubTitleFontSize: Length = '14fp';
  panelTitleTextHeight: Length = '32vp';
  panelTitleTextColor: ResourceColor = $r('app.color.sound_device_panel_title_color');
}

export class SoundPanelComponentStyle {
  soundPanelDividerMarginTop: Length = '4vp';
  soundPanelDividerHeight: Length = $r('app.float.sound_panel_divider_height');
  soundPanelDividerWidth: Length = $r('app.float.sound_divider_width');
  soundPanelDividerColor: ResourceColor = $r('app.color.sound_divider_color');
  soundPanelSubTitleFontSize: Length = '12fp';
  soundPanelContentFontSize: Resource = $r('sys.float.ohos_id_text_size_body1');
  soundPanelTitleTextColor: ResourceColor = $r('app.color.sound_device_panel_text_color');
  soundPanelFontColor: ResourceColor = $r('app.color.sound_device_panel_subtext_color');
  soundPanelLeftSize: Length = '4vp';
  soundPanelBetweenSize: Length = '4vp';
  soundPanelIconWidth: Length = '24vp';
  soundPanelIconHeight: Length = '24vp';
  soundPanelMarginLeft: Length = '24vp';
  soundPanelMarginRight: Length = '24vp';
  soundPanelMarginTop: Length = '6vp';
  soundPanelMarginVertical: Length = '4vp';
  marginTop: Length = $r('app.float.sound_device_margin_top');
  marginBottom: Length = $r('app.float.sound_device_margin_bottom');
  menuHeight: Length = '40vp';
  soundPanelPaddingLeft: Length = '24vp';
  soundPanelPaddingRight: Length = '24vp';
  soundPanelPaddingTop: Length = '6vp';
  soundPanelPaddingBottom: Length = '6vp';
}

export class SoundSliderStyle {
  marginLeft: Length = $r('app.float.sound_slider_margin_left');
  marginRight: Length = $r('app.float.sound_slider_margin_right');
  fontSize: Length = $r('sys.float.ohos_id_text_size_sub_title2');
  fontColor: ResourceColor = $r('sys.color.ohos_id_color_text_primary');
  imageIconColor: ResourceColor = $r('sys.color.ohos_fa_icon_primary');
  imageWidth: Length = $r('app.float.sound_slider_icon_width');
  imageHeight: Length = $r('app.float.sound_slider_icon_height');
  imageHoverWidth: Length = $r('app.float.sound_slider_icon_hover_width');
  imageHoverHeight: Length = $r('app.float.sound_slider_icon_hover_height');
  imageHoverRadius: Length = $r('app.float.sound_slider_icon_hover_radius');
  imageHoverColor: ResourceColor = $r('app.color.sound_slider_icon_hover_color');
  imageTransparentColor: ResourceColor = $r('app.color.sound_slider_icon_transparent_color');
  soundSliderGap: Length = $r('app.float.sound_slider_gap');
  soundPanSliderWidth: Length = $r('app.float.sound_panel_component_slider_width');
  soundPanSliderHeight: Length = $r('app.float.sound_panel_component_slider_height');
  soundPanelSliderBlockColor: ResourceColor = $r('app.color.sound_slider_block_color');
  soundSliderTrackColor: ResourceColor = $r('app.color.sound_slider_track_color');
  soundSelectedColor: ResourceColor = $r('app.color.sound_slider_selected_color');
  soundSliderBarHeight: Length = $r('app.float.sound_slider_bar_height');
  soundPanSliderMarginLeft: Length = $r('app.float.sound_slider_bar_margin_left');
}

export class SoundDeviceStyle {
  marginTop: Length = $r('app.float.sound_device_margin_top');
  marginBottom: Length = $r('app.float.sound_device_margin_bottom');
  fontSize: Length = '14fp';
  fontColor: ResourceColor = '#e6000000';
  imageIconColor: ResourceColor = $r('sys.color.ohos_fa_icon_primary');
  imageWidth: Length = $r('app.float.sound_device_icon_width');
  imageHeight: Length = $r('app.float.sound_device_icon_height');
  soundDeviceGap: Length = $r('app.float.sound_device_gap');
  soundDeviceRadioColor: ResourceColor = $r('app.color.sound_button_background_color');
  menuMarginLeftRight: Length = '4vp';
  menuHeight: Length = '56vp';
  checkedColor: ResourceColor = $r('app.color.img_checked_color');
}

export class ClickableMenuStyle {
  stackHeight: Length = '40vp';
  stackPadding: Length = '18vp';
  stackBorderRadius: Length = '20vp';
  stackBgColorHover: ResourceColor = $r('sys.color.ohos_id_color_hover');
  stackBgColorSelected: ResourceColor = $r('sys.color.ohos_id_color_click_effect');
  stackBgColorUnSelected: ResourceColor = '#00000000';
}

export default class StyleConfiguration {
  static getCommonComponentStyle(): CommonComponentStyle {
    const key: string = TAG + '-CommonComponent';
    return CommonStyleManager.getStyle(key, CommonComponentStyle);
  }

  static getSoundPanelComponentStyle(): SoundPanelComponentStyle {
    const key: string = TAG + '-SoundPanelComponent';
    return CommonStyleManager.getStyle(key, SoundPanelComponentStyle);
  }

  static getSoundSliderStyle(): SoundSliderStyle {
    const key: string = TAG + '-SoundSlider';
    return CommonStyleManager.getStyle(key, SoundSliderStyle);
  }

  static getSoundDeviceStyle(): SoundDeviceStyle {
    const key: string = TAG + '-SoundDevice';
    return CommonStyleManager.getStyle(key, SoundDeviceStyle);
  }

  static getClickableMenuStyle(): ClickableMenuStyle {
    const key: string = TAG + '-ClickableMenu';
    return CommonStyleManager.getStyle(key, ClickableMenuStyle);
  }
}