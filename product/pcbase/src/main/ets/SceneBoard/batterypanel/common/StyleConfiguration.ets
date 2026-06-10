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

const TAG = 'BatteryPanel-StyleConfiguration';

export class CommonComponentStyle {
  panelTitleMarginTop: Length = '0vp';
  panelTitleMargin: Length = '22vp';
  panelTitleHeight: Length = '56vp';
  panelTitleTextHeight: Length = '56vp';
  panelSubTextMargin: Length = '24vp';
  panelContentHeight: Length = '55vp';
  panelContentChargingHeight: Length = '71vp';
  panelTitleFontSize: Length = '24fp';
  panelTitleTextColor: ResourceColor = $r('app.color.font_color');
  panelSubTextFontColor: ResourceColor = $r('app.color.font_color');
  panelSubTextFontSize: Length = $r('sys.float.ohos_id_text_size_body1');
  panelSubTextHeight: Length = '24vp';
  panelChargingTextHeight: Length = '20vp';
  panelChargingTextFontSize: Length = $r('sys.float.ohos_id_text_size_over_line');
  panelSubTitleFontColor: ResourceColor = $r('app.color.sub_title_font_color');
  panelSubTextMarginTop: Length = '6vp';
  panelChargingTextMarginLeft: Length = '25vp';
  panelChargingTextMarginTop: Length = '6vp';
  panelChargingTextLineHeight: Length = '20vp';
}

export class BatteryPanelComponentStyle {
  batteryPanelChargingFullText: Resource = $r('app.string.battery_charging_full_text');
  batteryPanelChargingText: Resource = $r('app.string.battery_charging_text');
  batteryPanelSuperChargingText: Resource = $r('app.string.battery_super_charging_text');
  batteryPanelTurboChargingText: Resource = $r('app.string.battery_turbo_charging_text');
  batteryPanelSmartChargingText: Resource = $r('app.string.battery_smart_charging_text');
  batteryPanelCustomChargingText: Resource = $r('app.string.battery_custom_charging_text');
  batteryText: Resource = $r('app.string.battery_text');
  adapterText: Resource = $r('app.string.adapter_text');
  // 状态栏tips
  batteryChargingFullText: Resource = $r('app.string.full_charge');
  batteryChargingText: Resource = $r('app.string.normal_charge');
  batterySuperChargingText: Resource = $r('app.string.super_charge');
  batteryTurboChargingText: Resource = $r('app.string.turbo_charge');
  batterySmartChargingText: Resource = $r('app.string.smart_charge');
  batteryCustomChargingText: Resource = $r('app.string.custom_charge');
  batteryPower: Resource = $r('app.string.host_battery_power');
  batteryPanelMarginLeft: Length = '24vp';
  batteryPanelMarginRight: Length = '24vp';
  batteryPanelMarginTop: Length = '4vp';
  batteryPanelMarginDividerBottom: Length = '4vp';
  batteryPanelMarginBottom: Length = '4vp';
  batteryPanelBetweenSize: Length = '4vp';
  batteryPanelPadding: Length = '20vp';
  batteryPanelButtonHeight: Length = '40vp';
}

export default class StyleConfiguration {
  static getCommonComponentStyle(): CommonComponentStyle {
    const key: string = TAG + '-CommonComponent';
    return CommonStyleManager.getStyle(key, CommonComponentStyle);
  }

  static getBatteryPanelComponentStyle(): BatteryPanelComponentStyle {
    const key: string = TAG + '-BatteryPanelComponent';
    return CommonStyleManager.getStyle(key, BatteryPanelComponentStyle);
  }
}