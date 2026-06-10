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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import StyleManager, { ReverseColor } from './StyleManager';

const TAG = 'ScreenLock-UserStyle';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Observed
export class UserStyle implements ReverseColor {

  protected static instance: UserStyle;

  public style: Style;

  public domainSlotTextMarginLeft: number = ResUtils.getNumber($r('app.float.Control_center_long_button_left_margin'));
  public domainSlotIconMarginLeft: number = ResUtils.getNumber($r('app.float.Control_center_quickToggle_padding_left'));
  public domainSlotMarginBottom: number = ResUtils.getNumber($r('app.float.Control_center_long_button_left_margin'));
  public domainSlotMarginBottom12: number = ResUtils.getNumber($r('app.float.common_size12'));
  public domainFontSize: number = ResUtils.getNumber($r('app.float.domain_font_size'));
  public userNameHeight: number = ResUtils.getNumber($r('app.float.common_size32'));
  public userNameMarginBottom: number = ResUtils.getNumber($r('app.float.common_margin7'));
  public promptMarginTop: number = ResUtils.getNumber($r('app.float.common_margin8'));

  public lostModeInfoMarginTop: number = ResUtils.getNumber($r('app.float.lost_mode_prompt_margin_top'));
  public lostModeContactMarginTop: number = ResUtils.getNumber($r('app.float.common_size10'));

  constructor() {
    this.style = Style.getInstance();
  }

  public static getInstance(): UserStyle {
    if (!UserStyle.instance) {
      UserStyle.instance = new UserStyle();
      StyleManager.registerReverseColor(TAG, UserStyle.instance);
    }
    return UserStyle.instance;
  }

  updateColor(isDarkWallPaper: boolean, degree: number): void {
    log.showInfo(`isDarkWallPaper:${isDarkWallPaper}, ${degree}`);
    if (degree === 5 || degree === 6) {
      this.style = FancyStyle.getInstance();
      return;
    }
    this.style = (isDarkWallPaper ? Style.getInstance() : LightStyle.getInstance());
  }
}

class Style {

  protected static instance?: Style;

  public lostModeTextColor: ResourceColor = $r('app.color.white');
  public multiUserItemHoverBgColor: ResourceColor = $r('app.color.wallPaper_reverse_ohos_id_color_hover_dark');
  public multiUserItemHoverBgBlur: number = ResUtils.getNumber($r('app.float.blur_style_component_default_value'));
  public multiUserItemHoverBgSaturation: number = ResUtils.getNumber($r('app.float.blur_style_component_default_value'));
  public multiUserItemHoverEnterpriseLogoBgColor: ResourceColor = $r('app.color.ohos_id_blur_style_component_ultra_thin_color');
  public multiUserItemHoverEnterpriseLogoBgBlur: number = ResUtils.getNumber($r('app.float.ohos_id_blur_style_component_ultra_thin_radius'));

  public multiUserItemHoverEnterpriseLogoBgSaturation: number = ResUtils.getNumber($r('app.float.ohos_id_blur_style_component_ultra_thin_saturation'));
  public multiUserItemHoverEnterpriseLogoBgBrightness: number = ResUtils.getNumber($r('app.float.enterprise_back_brightness'));

  public multiUserItemPressedBgColor: ResourceColor = $r('app.color.ohos_id_color_click_effect_dark');

  public userNameColor: ResourceColor = $r('app.color.white');
  public enterpriseTextColor: ResourceColor = $r('app.color.white');
  public enterpriseIcon: Resource = $r('app.media.ic_enterprise_user_icon');
  public enterpriseIconColor: ResourceColor = $r('app.color.white');
  public enterpriseBackBrightness: number = ResUtils.getNumber($r('app.float.enterprise_back_brightness'));
  public loggedIconColor: ResourceColor = $r('app.color.capsule_background_color');
  public loggedIconWidth: Resource = $r('app.float.length_16');
  public loggedIconBrightness: Resource = $r('app.float.enterprise_back_brightness');
  public loggingLimitColor: ResourceColor = $r('app.color.green_capsule_text_color');
  public loggingLimitTextShadow: ShadowOptions = {
    offsetX: 0,
    offsetY: 1,
    radius: 6,
    color: '#4d000000'
  };

  public enterpriseTextShadow: ShadowOptions = {
    offsetX: 0,
    offsetY: 1,
    radius: 4,
    color: '#4d000000'
  }
  public userNameShadows: ShadowOptions[] = [
    {
      offsetX: $r('app.float.screenLock_user_name_first_shadow_offset_x'),
      offsetY: $r('app.float.screenLock_user_name_first_shadow_offset_y'),
      radius: $r('app.float.screenLock_user_name_first_shadow_radius'),
      color: $r('app.color.user_name_first_shadow_color_pc'),
    },
    {
      offsetX: $r('app.float.screenLock_user_name_second_shadow_offset_x'),
      offsetY: $r('app.float.screenLock_user_name_second_shadow_offset_y'),
      radius: $r('app.float.screenLock_user_name_second_shadow_radio'),
      color: $r('app.color.user_name_second_shadow_color_pc'),
    }
  ];
  public promptColor: ResourceColor = $r('app.color.green_capsule_text_color');
  public promptShadow: ShadowOptions = {
    offsetX: $r('app.float.common_size0'),
    offsetY: $r('app.float.common_size1'),
    radius: $r('app.float.text_shadow_radius_6'),
    color: $r('app.color.button_background'),
  }

  public static getInstance(): Style {
    if (!Style.instance) {
      Style.instance = new Style();
    }
    return Style.instance;
  }
}

class LightStyle extends Style {

  protected static instance?: Style;

  public lostModeTextColor: ResourceColor = $r('app.color.black');
  public multiUserItemHoverBgColor: ResourceColor = $r('app.color.wallPaper_reverse_ohos_id_color_hover');
  public multiUserItemHoverEnterpriseLogoBgColor: ResourceColor = $r('app.color.ohos_id_blur_style_component_ultra_thin_color_dark');
  public multiUserItemHoverEnterpriseLogoBgBlur: number = ResUtils.getNumber($r('app.float.ohos_id_blur_style_component_ultra_thin_radius_dark'));
  public multiUserItemHoverEnterpriseLogoBgSaturation: number = ResUtils.getNumber($r('app.float.blur_style_component_default_value'));
  public multiUserItemHoverEnterpriseLogoBgBrightness: number = ResUtils.getNumber($r('app.float.enterprise_back_brightness_light'));

  public multiUserItemPressedBgColor: ResourceColor = $r('app.color.inputmethod_item_pressed_color');

  public userNameColor: ResourceColor = $r('app.color.default_color_text_primary');
  public enterpriseTextColor: ResourceColor = $r('app.color.default_color_secondary');
  public enterpriseBackBrightness: number = ResUtils.getNumber($r('app.float.enterprise_back_brightness_light'));
  public enterpriseIconColor: ResourceColor = $r('app.color.default_color_secondary');
  public loggingLimitColor: ResourceColor = $r('app.color.user_name_first_shadow_color_pc');
  public loggingLimitTextShadow: ShadowOptions = {
    offsetX: $r('app.float.common_size0'),
    offsetY: $r('app.float.common_size0'),
    radius: $r('app.float.common_size0'),
    color: $r('app.color.common_clear_color')
  };
  public enterpriseTextShadow: ShadowOptions = {
    offsetX: 0,
    offsetY: 0,
    radius: 0,
    color: '#00000000'
  };
  public userNameShadows: ShadowOptions[] = [];
  public promptColor: ResourceColor = $r('app.color.default_color_secondary');
  public promptShadow: ShadowOptions = {
    offsetX: $r('app.float.common_size0'),
    offsetY: $r('app.float.common_size0'),
    radius: $r('app.float.common_size0'),
    color: $r('app.color.common_clear_color')
  };

  public static getInstance(): Style {
    if (!LightStyle.instance) {
      LightStyle.instance = new LightStyle();
    }
    return LightStyle.instance;
  }
}

class FancyStyle extends Style {

  protected static instance?: Style;

  public multiUserItemHoverBgColor: ResourceColor = $r('app.color.control_center_panel_inner_border_color');
  public multiUserItemHoverBgBlur: number = ResUtils.getNumber($r('app.float.ohos_id_blur_style_component_ultra_thin_radius'));
  public multiUserItemHoverBgSaturation: number = ResUtils.getNumber($r('app.float.ohos_id_blur_style_component_ultra_thin_saturation'));
  public multiUserItemHoverEnterpriseLogoBgColor: ResourceColor = $r('app.color.control_center_panel_inner_border_color');
  public multiUserItemHoverEnterpriseLogoBgBlur: number = ResUtils.getNumber($r('app.float.blur_style_component_default_value'));
  public multiUserItemHoverEnterpriseLogoBgSaturation: number = ResUtils.getNumber($r('app.float.blur_style_component_default_value'));
  public multiUserItemHoverEnterpriseLogoBgBrightness: number = ResUtils.getNumber($r('app.float.enterprise_back_brightness_light'));

  public multiUserItemPressedBgColor: ResourceColor = $r('app.color.multi_user_item_pressed_bg_color');

  public static getInstance(): Style {
    if (!FancyStyle.instance) {
      FancyStyle.instance = new FancyStyle();
    }
    return FancyStyle.instance;
  }
}