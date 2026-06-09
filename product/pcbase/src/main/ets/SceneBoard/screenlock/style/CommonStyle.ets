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
import display from '@ohos.display';

const TAG = 'ScreenLock-CommonStyle';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Observed
export class CommonStyle implements ReverseColor {

  protected static instance: CommonStyle;

  public style: Style;

  public displayWidth: number = px2vp(CommonStyle.getScreenWidth());
  public clearColor: ResourceColor = $r('app.color.common_clear_color');
  public hoverBorderCommonWidth: number = ResUtils.getNumber($r('app.float.common_size2'));
  public defaultLength: number = ResUtils.getNumber($r('app.float.common_size0'));
  public promptMargin: number = ResUtils.getNumber($r('app.float.common_size24'));
  public promptFontSize: number = ResUtils.getNumber($r('app.float.common_size16'));
  public fontFamilyHeiTi: string = 'HarmonyHeiTi';

  constructor() {
    this.style = Style.getInstance();
  }

  public static getInstance(): CommonStyle {
    if (!CommonStyle.instance) {
      CommonStyle.instance = new CommonStyle();
      StyleManager.registerReverseColor(TAG, CommonStyle.instance);
    }
    return CommonStyle.instance;
  }

  public static getScreenWidth(): number {
    try {
      return display.getDefaultDisplaySync().width;
    } catch (error) {
      log.showError(`getDefaultDisplaySync code: ${error.message}`);
      return 0;
    }
  }

  public static toastLightBrightness: BrightnessOptions = {
    rate: 0.8386,
    lightUpDegree: 0.5793,
    cubicCoeff: 0,
    quadCoeff: 0,
    saturation: 1.4,
    posRGB: [1, 0.5, 1],
    negRGB: [1.2, 1.2, 1],
    fraction: 0,
  }

  public static toastDarkBrightness: BrightnessOptions = {
    rate: 0,
    lightUpDegree: -0.18,
    cubicCoeff: 0,
    quadCoeff: 0,
    saturation: 0,
    posRGB: [0.4, 1.2, 0.2],
    negRGB: [1, 1, 0.5],
    fraction: 0,
  }

  updateColor(isDarkWallPaper: boolean): void {
    log.showInfo(`isDarkWallPaper:${isDarkWallPaper}`);
    this.style = (isDarkWallPaper ? Style.getInstance() : LightStyle.getInstance());
  }
}

class Style {

  protected static instance?: Style;

  public userNameColor: ResourceColor = $r('app.color.text_color');
  public borderWidth: Resource = $r('app.float.status_bar_panel_inner_border_width');
  public colorWhite10: Resource = $r('app.color.screenLock_user_activated_inside_border_color');
  public colorBlack10: Resource = $r('app.color.screenLock_user_activated_outside_border_color');
  public colorBlack15: Resource = $r('app.color.ntf_pc_banner_shadow_color');
  public colorWhite20: Resource = $r('app.color.control_center_panel_inner_border_color');
  public colorBlack20: Resource = $r('app.color.file_picker_textarea_border_color');

  public hoverColor: ResourceColor = $r('app.color.wallPaper_reverse_ohos_id_color_hover_dark');
  public pressedColor: ResourceColor = $r('app.color.ohos_id_color_click_effect_dark');
  public whiteColor: ResourceColor = $r('app.color.white');
  public blackColor: ResourceColor = $r('app.color.black');

  public clearRadius: number = ResUtils.getNumber($r('app.float.blur_style_component_default_value'));
  public clearSaturation: number = ResUtils.getNumber($r('app.float.blur_style_component_default_value'));
  public ultraThinRadius: number = ResUtils.getNumber($r('app.float.ohos_id_blur_style_component_ultra_thin_radius'));
  public ultraThinSaturation: number = ResUtils.getNumber($r('app.float.ohos_id_blur_style_component_ultra_thin_saturation'));
  public ultraThinColor: ResourceColor = $r('app.color.ohos_id_blur_style_component_ultra_thin_color');


  public static getInstance(): Style {
    if (!Style.instance) {
      Style.instance = new Style();
    }
    return Style.instance;
  }
}

class LightStyle extends Style {

  protected static instance?: Style;

  public userNameColor: ResourceColor = $r('app.color.user_name_bright_text_color');

  public hoverColor: ResourceColor = $r('app.color.wallPaper_reverse_ohos_id_color_hover');
  public pressedColor: ResourceColor = $r('app.color.inputmethod_item_pressed_color');
  public ultraThinRadius: number = ResUtils.getNumber($r('app.float.ohos_id_blur_style_component_ultra_thin_radius_dark'));
  public ultraThinSaturation: number = ResUtils.getNumber($r('app.float.blur_style_component_default_value'));
  public ultraThinColor: ResourceColor = $r('app.color.ohos_id_blur_style_component_ultra_thin_color_dark');

  public static getInstance(): Style {
    if (!LightStyle.instance) {
      LightStyle.instance = new LightStyle();
    }
    return LightStyle.instance;
  }
}