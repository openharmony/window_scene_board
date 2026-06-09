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
import { GlobalContext, PluginSlot } from '@ohos/frameworkwrapper';
import Constants from '../common/Constants';
import StyleConfiguration, { StatusBarStarflashComponentStyle } from '../common/StyleConfiguration';
import controller, { StarflashData } from '../controller/StarflashController';
import { AccessibilityVm } from '@ohos/systemuicommon/newIndex';

// instrument ignore file

const TAG = 'starflash-StatusBarIconItemStarflashComponent';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const COMPONENT_ID = TAG + '_Image_icon';
const COMPONENT_ID_BATTERY = TAG + '_Battery_Image_icon';

interface NearlinkIconProps {
  id: string;
  icon: Resource,
  width?: Length,
  height: Length,
  fillColor: ResourceColor;
}

@Component
export default struct StatusBarStarFlashComponent {
  @State mstarflashData: StarflashData = controller.getData();
  @State style: StatusBarStarflashComponentStyle = StyleConfiguration.getStatusBarStarflashComponentStyle();
  @Consume contentColor: string;
  private nearLinkBatteryLevelLowColor: ResourceColor = Constants.NEARLINK_BATTERY_ORANGE;
  private nearLinkBatteryLevelVeryLowColor: ResourceColor = Constants.NEARLINK_BATTERY_RED;

  aboutToAppear(): void {
    log.showInfo('aboutToAppear starflash');
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear starflash');
  }

  build() {
    Row() {
      if (this.mstarflashData.isConnected) {
        // 星闪已连接
        this.renderNearlinkConnectionIcon()
      } else {
        // 星闪未连接
        this.renderNearlinkDisconnectionIcon()
      }
    }
    .height('100%')
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
  }

  private getAccessibilityText(): string {
    if (!AccessibilityVm.instance.isEnabled) {
      return '';
    }
    const res = GlobalContext.getContext()?.resourceManager;
    if (this.mstarflashData.isConnected) {
      return res.getStringByNameSync('accessibility_status_bar_nearlink_connected');
    } else {
      return res.getStringByNameSync('accessibility_status_bar_nearlink_open');
    }
  }

  @Builder
  renderNearlinkDisconnectionIcon() {
    this.renderNearlinkIcon({
      id: COMPONENT_ID,
      fillColor: this.contentColor,
      icon: $r('app.media.ic_statusbar_nearlink'),
      height: this.style.staticBarStarFlashHeight
    })
  }

  @Builder
  renderNearlinkIcon(props: NearlinkIconProps) {
    Image(props.icon)
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .width(props.width)
      .height(props.height)
      .fillColor(props.fillColor)
      .id(props.id)
  }

  @Builder
  renderNearlinkConnectionIcon() {
    if (this.mstarflashData.batteryValue === -1) {
      // 无电量信息
      this.renderNearlinkIcon({
        id: COMPONENT_ID,
        icon: $r('app.media.ic_statusbar_nearlink_connect'),
        height: this.style.staticBarStarFlashHeight,
        fillColor: this.contentColor,
      })
    } else {
      // 有电量信息
      Stack() {
        // 星闪电池外框
        this.renderNearlinkIcon({
          id: COMPONENT_ID,
          fillColor: this.contentColor,
          icon: $r('app.media.ic_statusbar_nearlink_battery'),
          height: this.style.staticBarStarFlashHeight,
        })

        // 电量进度
        this.renderNearlinkIcon({
          id: COMPONENT_ID_BATTERY,
          fillColor: this.getProgressColor(),
          icon: this.getBatteryProgressImage(),
          height: this.style.staticBarStarFlashHeight,
        })
      }
    }
  }

  private getProgressColor(): ResourceColor {
    log.showInfo(`getProgressColor ${this.mstarflashData.batteryValue}`);
    if (this.mstarflashData.batteryValue <= Constants.NEARLINK_BATTERY_LEVEL_VERY_LOW) {
      return this.nearLinkBatteryLevelVeryLowColor;
    }
    if (this.mstarflashData.batteryValue <= Constants.NEARLINK_BATTERY_LEVEL_LOW) {
      return this.nearLinkBatteryLevelLowColor;
    }
    return this.contentColor;
  }


  private getBatteryProgressImage(): Resource {
    if (this.mstarflashData.batteryValue <= 5) {
      return $r('app.media.ic_statusbar_nearlink_battery_5')
    } else if (this.mstarflashData.batteryValue <= 10) {
      return $r('app.media.ic_statusbar_nearlink_battery_10')
    } else if (this.mstarflashData.batteryValue <= 20) {
      return $r('app.media.ic_statusbar_nearlink_battery_20')
    } else if (this.mstarflashData.batteryValue <= 30) {
      return $r('app.media.ic_statusbar_nearlink_battery_30')
    } else if (this.mstarflashData.batteryValue <= 40) {
      return $r('app.media.ic_statusbar_nearlink_battery_40')
    } else if (this.mstarflashData.batteryValue <= 50) {
      return $r('app.media.ic_statusbar_nearlink_battery_50')
    } else if (this.mstarflashData.batteryValue <= 60) {
      return $r('app.media.ic_statusbar_nearlink_battery_60')
    } else if (this.mstarflashData.batteryValue <= 70) {
      return $r('app.media.ic_statusbar_nearlink_battery_70')
    } else if (this.mstarflashData.batteryValue <= 80) {
      return $r('app.media.ic_statusbar_nearlink_battery_80')
    } else if (this.mstarflashData.batteryValue <= 90) {
      return $r('app.media.ic_statusbar_nearlink_battery_90')
    } else {
      return $r('app.media.ic_statusbar_nearlink_battery_100')
    }
  }
}