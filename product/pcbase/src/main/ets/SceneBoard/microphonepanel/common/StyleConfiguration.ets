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

const TAG = 'MicrophonePanel-StyleConfiguration';

export class CommonComponentStyle {
  panelTitleMarginTop: Length = '4vp';
  panelTitlePaddingTop: Length = '4vp';
  panelTitleMarginBottom: Length = '12vp';
  panelTitleMargin: Length = '22vp';
  panelTitleHeight: Length = '56vp';
  panelTitleFontSize: Length = '24fp';
  panelSubTitleFontSize: Length = '14fp';
  panelTitleTextHeight: Length = '56vp';
  panelTitleTextColor: ResourceColor = $r('app.color.sound_device_panel_title_color');
  panelTitleToggleHeight: Length = '20vp';
}

export class MicrophonePanelComponentStyle {
  microphonePanelDividerMarginTop: Length = '4vp';
  microphonePanelDividerHeight: Length = $r('app.float.sound_panel_divider_height');
  microphonePanelDividerWidth: Length = $r('app.float.sound_divider_width');
  microphonePanelDividerColor: ResourceColor = $r('app.color.sound_divider_color');
  microphonePanelSubTitleFontSize: Length = '12fp';
  microphonePanelContentFontSize: Resource = $r('sys.float.ohos_id_text_size_body1');
  microphonePanelTitleTextColor: ResourceColor = $r('app.color.sound_device_panel_text_color');
  microphonePanelFontColor: ResourceColor = $r('app.color.sound_device_panel_subtext_color');
  microphonePanelBetweenSize: Length = '4vp';
  microphonePanelIconWidth: Length = '24vp';
  microphonePanelIconHeight: Length = '24vp';
  microphonePanelMarginLeft: Length = '24vp';
  microphonePanelMarginRight: Length = '24vp';
  microphonePanelMarginTop: Length = '6vp';
  microphonePanelMarginVertical: Length = '4vp';
  marginTop: Length = $r('app.float.sound_device_margin_top');
  marginBottom: Length = $r('app.float.sound_device_margin_bottom');
  menuHeight: Length = '40vp';
  microphonePanelPaddingLeft: Length = '24vp';
  microphonePanelPaddingRight: Length = '24vp';
  microphonePanelPaddingTop: Length = '6vp';
  microphonePanelPaddingBottom: Length = '6vp';
  microphonePanelTextUsingHeight: Length = '32vp';
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

  static getMicrophonePanelComponentStyle(): MicrophonePanelComponentStyle {
    const key: string = TAG + '-MicrophonePanelComponent';
    return CommonStyleManager.getStyle(key, MicrophonePanelComponentStyle);
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