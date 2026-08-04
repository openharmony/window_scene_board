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

import audio from '@ohos.multimedia.audio';
import connection from '@ohos.bluetooth.connection';
import constant from '@ohos.bluetooth.constant';
import { LogDomain, Logger } from '@ohos/basicutils';
import { HiSysEventUtil } from '@ohos/frameworkwrapper';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import StyleConfiguration, { ClickableMenuStyle, SoundDeviceStyle } from '../common/StyleConfiguration';
import { audioDevice, AudioSoundViewModel } from '../viewmodel/AudioSoundViewModel';
import { HorizontalCardComponent } from './HorizontalCardComponent';

const TAG = 'SoundPanel-DeviceItem';
const log = Logger.getLogHelper(LogDomain.SCB);
const KEYBOARD = 4;

@Component
export default struct DeviceItem {
  @Prop device: audioDevice;
  @Link curViewIndex: number;
  @State style: SoundDeviceStyle = StyleConfiguration.getSoundDeviceStyle();
  @State styleClickable: ClickableMenuStyle = StyleConfiguration.getClickableMenuStyle();
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();

  build() {
    HorizontalCardComponent({
      title: this.device.name,
      isChecked: this.device.viewIndex === this.curViewIndex,
      imageHeader: () => {
        this.deviceImageHeader();
      },
      clickFunc: (clickEvent: ClickEvent) => this.deviceSelect(clickEvent)
    })
  }

  @Builder deviceImageHeader() {
    SymbolGlyph(this.getDeviceIcon())
      .draggable(false)
      .id(`device_image_${this.device.type}`)
      .fontColor([this.colorModeViewData.commonIconOffColor])
      .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
      .size({ width: this.style.imageWidth, height: this.style.imageHeight })
      .fontSize(this.style.imageHeight)
      .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_OPACITY)
  }

  private getDeviceIcon(): Resource {
    const deviceType: number = this.device.type;
    switch (deviceType) {
      case audio.DeviceType.EARPIECE:
        return $r('sys.symbol.ear');
      case audio.DeviceType.SPEAKER:
      case audio.DeviceType.MIC:
        return $r('sys.symbol.matebook_fill');
      case audio.DeviceType.WIRED_HEADSET:
      case audio.DeviceType.WIRED_HEADPHONES:
      case audio.DeviceType.USB_HEADSET:
      case audio.DeviceType.USB_DEVICE:
        return $r('sys.symbol.earphone_16640_fill');
      case audio.DeviceType.BLUETOOTH_SCO:
      case audio.DeviceType.BLUETOOTH_A2DP:
        return this.getBluetoothIcon(this.device.address);
      case audio.DeviceType.DISPLAY_PORT:
      case audio.DeviceType.REMOTE_CAST:
      case audio.DeviceType.HDMI:
        return $r('sys.symbol.smartscreen_fill');
      default:
        log.showError(TAG, `unknown type: ${deviceType}`);
        return $r('sys.symbol.earphone_16640_fill');
    }
  }

  private getBluetoothIcon(deviceAddress: string): Resource {
    try {
      let deviceClass = connection.getRemoteDeviceClass(deviceAddress);
      if (!deviceClass || !deviceClass.majorClass) {
        log.showError(TAG, 'deviceClass is null');
        return $r('sys.symbol.bluetooth');
      }
      log.showInfo(TAG, `getBluetoothIcon getRemoteDeviceClass success, majorClass: ${deviceClass.majorClass}`);
      switch (deviceClass.majorClass) {
        case constant.MajorClass.MAJOR_AUDIO_VIDEO:
          return $r('sys.symbol.earphone_16640_fill');
        default:
          return $r('sys.symbol.bluetooth');
      }
    } catch (error) {
      log.showError(TAG, `getBluetoothIcon getRemoteDeviceClass error: ${error?.message}`);
      return $r('sys.symbol.bluetooth');
    }
  }

  private deviceSelect(event: ClickEvent): void {
    log.showInfo(TAG, `click output device to select, type: ${this.device.type}`);
    this.curViewIndex = this.device.viewIndex;
    let eventType: string = HiSysEventUtil.TOUCH_EVENT;
    if (event.source === SourceType.Mouse) {
      eventType = HiSysEventUtil.MOUSE_EVENT;
    } else if (event.source === KEYBOARD) {
      eventType = HiSysEventUtil.SHORTCUT_EVENT;
    } else {
      eventType = HiSysEventUtil.TOUCH_EVENT;
    }
    HiSysEventUtil.reportSoundMenu(this.device.type, eventType);
    AudioSoundViewModel.getInstance().selectOutputDevice(this.device.viewIndex, TAG);
  }
}
