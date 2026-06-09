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
import { BluetoothController, BluetoothData } from '../controller/BluetoothController';
import { StyleConfigurationCommon, CommonStyle } from '@ohos/systemuicommon/Index';
import StyleConfiguration from '../common/StyleConfiguration';
import { StatusBarBluetoothComponentStyle } from '../common/StyleConfiguration';
import Constants from '../common/Constants';
import { GlobalContext, PluginSlot } from '@ohos/frameworkwrapper';
import { AccessibilityVm } from '@ohos/systemuicommon/newIndex';

// instrument ignore file
const TAG = 'bluetooth-StatusBarIconItemBluetoothComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const COMPONENT_ID = TAG + '_Image_icon';
const COMPONENT_ID_BATTERY = TAG + '_Battery_Image_icon';

interface IconConfig {
  isAlwaysShown: boolean
}

interface BluetoothIconProps {
  id: string;
  icon: Resource,
  width: Length,
  height: Length,
  fillColor: ResourceColor;
}

@Component
export default struct StatusBarIconItemBluetoothComponent {
  private batteryLevelLowColor: ResourceColor = Constants.BATTERY_ORANGE;
  private batteryLevelVeryLowColor: ResourceColor = Constants.BATTERY_RED;

  private mIconConfig: IconConfig = {
    isAlwaysShown: false,
  };
  @State mBluetoothData: BluetoothData = BluetoothController.getInstance().getData();
  @State styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  @State style: StatusBarBluetoothComponentStyle = StyleConfiguration.getStatusBarBluetoothComponentStyle();

  /**
   * 内容颜色
   */
  @Consume contentColor: string;

  private getAccessibilityText(): string {
    if (!AccessibilityVm.instance.isEnabled) {
      return '';
    }
    if (!BluetoothController.getInstance().getViewData().isOn && !this.mIconConfig.isAlwaysShown) {
      return '';
    }
    const res = GlobalContext.getContext()?.resourceManager;
    if (this.mBluetoothData.isConnected) {
      return res.getStringByNameSync('accessibility_status_bar_bluetooth_connected');
    } else {
      return res.getStringByNameSync('accessibility_status_bar_bluetooth_open');
    }
  }


  aboutToAppear() {
    log.showInfo(`aboutToAppear, mIconConfig: ${this.mIconConfig?.isAlwaysShown},
    --mBluetoothData: ${BluetoothController.getInstance().getViewData().isOn},${this.mBluetoothData?.isConnected}`);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  build() {
    Row() {
      if (this.mBluetoothData.isConnected) {
        // 蓝牙已连接
        this.renderBluetoothConnectionIcon()
      } else {
        // 蓝牙未连接
        this.renderBluetoothDisconnectionIcon()
      }
    }
    .height('100%')
    .opacity($r('app.float.icon_component_opacity'))
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
  }

  @Builder
  renderBluetoothIcon(props: BluetoothIconProps) {
    Image(props.icon)
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .width(props.width)
      .height(props.height)
      .fillColor(props.fillColor)
      .id(props.id)
  }

  @Builder
  renderBluetoothDisconnectionIcon() {
    this.renderBluetoothIcon({
      id: COMPONENT_ID,
      fillColor: this.contentColor,
      icon: $r('app.media.ic_public_bluetooth_filled'),
      width: this.style.staticBarBluetoothWidth,
      height: this.style.staticBarBluetoothHeight
    })
  }

  @Builder
  renderBluetoothConnectionIcon() {
    if (this.mBluetoothData.batteryValue === -1) {
      // 无电量信息
      this.renderBluetoothIcon({
        id: COMPONENT_ID,
        fillColor: this.contentColor,
        icon: $r('app.media.ic_statusbar_bluetooth_connected'),
        width: this.style.staticBarBluetoothWidth,
        height: this.style.staticBarBluetoothHeight
      })
    } else {
      // 有电量信息
      Stack() {
        // 蓝牙电池外框
        this.renderBluetoothIcon({
          id: COMPONENT_ID,
          fillColor: this.contentColor,
          icon: $r('app.media.ic_statusbar_bluetooth_battery'),
          width: this.style.staticBarBluetoothBatteryWidth,
          height: this.style.staticBarBluetoothHeight
        })

        // 电量进度
        this.renderBluetoothIcon({
          id: COMPONENT_ID_BATTERY,
          fillColor: this.getProgressColor(),
          icon: this.getBatteryProgressImage(),
          width: this.style.staticBarBluetoothBatteryWidth,
          height: this.style.staticBarBluetoothHeight
        })
      }
    }
  }

  private getProgressColor(): ResourceColor {
    if (this.mBluetoothData.batteryValue <= Constants.BATTERY_LEVEL_VERY_LOW) {
      return this.batteryLevelVeryLowColor
    }
    if (this.mBluetoothData.batteryValue <= Constants.BATTERY_LEVEL_LOW) {
      return this.batteryLevelLowColor
    }
    return this.contentColor
  }

  private getBatteryProgressImage(): Resource {
    if (this.mBluetoothData.batteryValue <= 5) {
      return $r('app.media.ic_statusbar_bluetooth_battery_5')
    } else if (this.mBluetoothData.batteryValue <= 10) {
      return $r('app.media.ic_statusbar_bluetooth_battery_10')
    } else if (this.mBluetoothData.batteryValue <= 20) {
      return $r('app.media.ic_statusbar_bluetooth_battery_20')
    } else if (this.mBluetoothData.batteryValue <= 30) {
      return $r('app.media.ic_statusbar_bluetooth_battery_30')
    } else if (this.mBluetoothData.batteryValue <= 40) {
      return $r('app.media.ic_statusbar_bluetooth_battery_40')
    } else if (this.mBluetoothData.batteryValue <= 50) {
      return $r('app.media.ic_statusbar_bluetooth_battery_50')
    } else if (this.mBluetoothData.batteryValue <= 60) {
      return $r('app.media.ic_statusbar_bluetooth_battery_60')
    } else if (this.mBluetoothData.batteryValue <= 70) {
      return $r('app.media.ic_statusbar_bluetooth_battery_70')
    } else if (this.mBluetoothData.batteryValue <= 80) {
      return $r('app.media.ic_statusbar_bluetooth_battery_80')
    } else if (this.mBluetoothData.batteryValue <= 90) {
      return $r('app.media.ic_statusbar_bluetooth_battery_90')
    } else {
      return $r('app.media.ic_statusbar_bluetooth_battery_100')
    }


  }
}