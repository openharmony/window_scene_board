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

import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { CommonStyleManager } from '@ohos/systemuicommon';

const TAG = 'battery-StyleConfiguration';

export class BatteryComponentStyle {
  public componentGap: Length = $r('app.float.battery_component_gap');
  public statusBarBatteryWidth: Length = $r('app.float.battery_image_width');
  public statusBarBatteryHeight: Length = $r('app.float.battery_image_height');
  public statusBarBatteryChargingWidth: Length = $r('app.float.battery_charging_image_width');
  public statusBarBatteryChargingHeight: Length = $r('app.float.battery_charging_image_height');
  public statusBarPowerSaveWidth: Length = $r('app.float.battery_power_save_image_width');
  public statusBarPowerSaveHeight: Length = $r('app.float.battery_power_save_image_height');

  initStyle(): void {
    if (DeviceHelper.isPad()) {
      this.statusBarBatteryWidth = $r('app.float.battery_image_width_pad');
      this.statusBarBatteryHeight = $r('app.float.battery_image_height_pad');
    }
    this.componentGap = ResUtils.getNumberFromLength(this.componentGap);
    this.statusBarBatteryWidth = ResUtils.getNumberFromLength(this.statusBarBatteryWidth);
    this.statusBarBatteryHeight = ResUtils.getNumberFromLength(this.statusBarBatteryHeight);
    this.statusBarBatteryChargingWidth = ResUtils.getNumberFromLength(this.statusBarBatteryChargingWidth);
    this.statusBarBatteryChargingHeight = ResUtils.getNumberFromLength(this.statusBarBatteryChargingHeight);
    this.statusBarPowerSaveWidth = ResUtils.getNumberFromLength(this.statusBarPowerSaveWidth);
    this.statusBarPowerSaveHeight = ResUtils.getNumberFromLength(this.statusBarPowerSaveHeight);
  }
}

export class BatteryPicStyle {
  public picBodyWidth: Length = $r('app.float.battery_component_pic_body_width');
  public picBodyHeight: Length = $r('app.float.battery_component_pic_body_height');
  public picLevelLowColor: ResourceColor = $r('app.color.battery_component_pic_level_low_color');
  public picLevelVeryLowColor: ResourceColor = $r('app.color.battery_component_pic_level_very_low_color');
  public chargingPicInnerPaddingRight: Length = $r('app.float.charging_pic_inner_padding_right');
  public normalPicInnerPaddingRight: Length = $r('app.float.normal_pic_inner_padding_right');
  public batteryPicInnerPaddingTop: Length = $r('app.float.battery_pic_inner_padding_top');
  public hadChargingPicInnerPaddingRight: Length = $r('app.float.had_charging_pic_inner_padding_right');
  public hadNormalPicInnerPaddingRight: Length = $r('app.float.had_normal_pic_inner_padding_right');
  public batteryPicImageWidth: Length = $r('app.float.battery_pic_image_width');
  public batteryPicImageHeight: Length = $r('app.float.battery_pic_image_height');
  public hadBatteryPicImageWidth: Length = $r('app.float.had_battery_pic_image_width');
  public hadBatteryPicImageHeight: Length = $r('app.float.had_battery_pic_image_height');
  public batteryPicSocBackgroundColor: ResourceColor = $r('app.color.battery_pic_soc_background_color');
  public batteryPicSocDarkBackgroundColor: ResourceColor = $r('app.color.battery_pic_soc_background_color');
  public batteryPicSocBrightBackgroundColor: ResourceColor = $r('app.color.battery_pic_soc_bright_background_color');
  public batteryPicOuterChargingWidth: Length = $r('app.float.battery_pic_outer_charging_width');
  public batteryPicOuterChargingHeight: Length = $r('app.float.battery_pic_outer_charging_height');
  public batteryPicOuterChargingMarginLeft: Length = $r('app.float.battery_pic_outer_charging_margin_left');
  public batteryPicSocFontSize: Length = $r('app.float.battery_pic_soc_font_size');
  public hadBatteryPicSocFontSize: Length = $r('app.float.had_battery_pic_soc_font_size');
  public batteryPicSocLineHeight: Length = $r('app.float.battery_pic_soc_line_height');
  public batteryPicSocMarginTop: Length = $r('app.float.battery_pic_soc_margin_top');
  public hadBatteryPicSocMarginTop: Length = $r('app.float.had_battery_pic_soc_margin_top');
  public batteryChargingImageOffsetX: Length = $r('app.float.battery_charging_image_offset_x');

  initStyle(): void {
    this.picBodyWidth = ResUtils.getNumberFromLength(this.picBodyWidth);
    this.picBodyHeight = ResUtils.getNumberFromLength(this.picBodyHeight);
    this.batteryPicImageWidth = ResUtils.getNumberFromLength(this.batteryPicImageWidth);
    this.batteryPicImageHeight = ResUtils.getNumberFromLength(this.batteryPicImageHeight);
    this.hadBatteryPicImageWidth = ResUtils.getNumberFromLength(this.hadBatteryPicImageWidth);
    this.hadBatteryPicImageHeight = ResUtils.getNumberFromLength(this.hadBatteryPicImageHeight);
    this.batteryPicOuterChargingWidth = ResUtils.getNumberFromLength(this.batteryPicOuterChargingWidth);
    this.batteryPicOuterChargingHeight = ResUtils.getNumberFromLength(this.batteryPicOuterChargingHeight);
    this.batteryPicOuterChargingMarginLeft = ResUtils.getNumberFromLength(this.batteryPicOuterChargingMarginLeft);
    this.normalPicInnerPaddingRight = ResUtils.getNumberFromLength(this.normalPicInnerPaddingRight);
    this.chargingPicInnerPaddingRight = ResUtils.getNumberFromLength(this.chargingPicInnerPaddingRight);
    this.hadNormalPicInnerPaddingRight = ResUtils.getNumberFromLength(this.hadNormalPicInnerPaddingRight);
    this.hadChargingPicInnerPaddingRight = ResUtils.getNumberFromLength(this.hadChargingPicInnerPaddingRight);
    this.batteryPicSocFontSize = ResUtils.getNumberFromLength(this.batteryPicSocFontSize);
    this.hadBatteryPicSocFontSize = ResUtils.getNumberFromLength(this.hadBatteryPicSocFontSize);
    this.batteryChargingImageOffsetX = ResUtils.getNumberFromLength(this.batteryChargingImageOffsetX);
    this.batteryPicSocLineHeight = ResUtils.getNumberFromLength(this.batteryPicSocLineHeight);
    this.batteryPicInnerPaddingTop = ResUtils.getNumberFromLength(this.batteryPicInnerPaddingTop);
  }
}

export default class StyleConfiguration {
  static getBatteryComponentStyle(): BatteryComponentStyle {
    const key: string = TAG + '-BatteryComponent';
    return CommonStyleManager.getStyle(key, BatteryComponentStyle);
  }

  static getBatteryPicStyle(): BatteryPicStyle {
    const key: string = TAG + '-BatteryPicComponent';
    return CommonStyleManager.getStyle(key, BatteryPicStyle);
  }

  static getBatteryPicStyleForScreenLock(): BatteryPicStyle {
    const key: string = TAG + '-BatteryPicComponentForScreenLock';
    return CommonStyleManager.getStyle(key, BatteryPicStyle);
  }
}