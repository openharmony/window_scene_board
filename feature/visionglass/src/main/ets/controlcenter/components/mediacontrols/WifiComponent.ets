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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { ControlCenterConstants } from '../constants/ControlCenterConstants';
import { calculateSize, WifiConstants } from '../constants/WifiConstants';
import { GlassWifiManager } from '../manager/GlassWifiManager';

const TAG = 'WifiComponent';
const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export default struct WifiComponent {
  @State glassWifiManager: GlassWifiManager = GlassWifiManager.getInstance();
  @Consume windowSize: SizeOptions;
  @State wifiIconColor: ResourceColor = WifiConstants.CAPSULE_ICON_OPEN_COLOR;
  @State wifiIconBgColor: ResourceColor = WifiConstants.CAPSULE_OPEN_COLOR;
  @State wifiName: ResourceStr = $r('app.string.control_center_wlan');

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    GlassWifiManager.getInstance().registerUpdateWifiIconColorCallback(this.updateWifiIconColor);
    GlassWifiManager.getInstance().registerUpdateWifiIconBgColorCallback(this.updateWifiIconBgColor);
    GlassWifiManager.getInstance().registerUpdateWifiNameCallback(this.updateWifiName);
    GlassWifiManager.getInstance().updateStatus();
    GlassWifiManager.getInstance().onWifiStateChangeListener();
    GlassWifiManager.getInstance().onWifiConnectionChangeListener();
  }

  updateWifiIconColor = (color: ResourceColor): void => {
    this.wifiIconColor = color;
  }
  updateWifiIconBgColor = (color: ResourceColor): void => {
    this.wifiIconBgColor = color;
  }
  updateWifiName = (name: ResourceStr): void => {
    this.wifiName = name;
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    GlassWifiManager.destroyInstance();
  }

  build() {
    Row() {
      Row() {
        Button({
          type: ButtonType.Circle,
          stateEffect: true,
        }) {
          Image($r('app.media.glass_ic_wifi'))
            .width(calculateSize(this.windowSize.height as number, ControlCenterConstants.CAPSULE_ICON_SIZE_SCALE))
            .height(calculateSize(this.windowSize.height as number, ControlCenterConstants.CAPSULE_ICON_SIZE_SCALE))
            .fillColor(this.wifiIconColor)
        }
        .width(calculateSize(this.windowSize.height as number, ControlCenterConstants.CAPSULE_ICON_BG_SIZE_SCALE))
        .height(calculateSize(this.windowSize.height as number, ControlCenterConstants.CAPSULE_ICON_BG_SIZE_SCALE))
        .backgroundColor(this.wifiIconBgColor)
      }
      .width(calculateSize(this.windowSize.height as number, WifiConstants.CAPSULE_HEIGHT_SCALE))
      .height(calculateSize(this.windowSize.height as number, WifiConstants.CAPSULE_HEIGHT_SCALE))
      .borderRadius(calculateSize(this.windowSize.height as number, WifiConstants.CAPSULE_HEIGHT_SCALE))
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        this.glassWifiManager.wifiSwitch();
      })

      Text(this.wifiName)
        .fontColor(WifiConstants.CAPSULE_ICON_CLOSE_COLOR)
        .fontSize(WifiConstants.FONT_SIZE)
        .fontWeight(FontWeight.Bold)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Start)
    }
    .backgroundColor(ControlCenterConstants.BUTTON_BACKGROUND_COLOR)
    .borderRadius(calculateSize(this.windowSize.height as number, WifiConstants.CAPSULE_HEIGHT_SCALE))
    .width(calculateSize(this.windowSize.height as number, WifiConstants.CAPSULE_WIDTH_SCALE))
    .height(calculateSize(this.windowSize.height as number, WifiConstants.CAPSULE_HEIGHT_SCALE))
  }
}