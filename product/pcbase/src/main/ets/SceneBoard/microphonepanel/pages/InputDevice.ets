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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { HiSysEventUtil } from '@ohos/frameworkwrapper';
import audio from '@ohos.multimedia.audio';
import bluetooth from '@ohos.bluetooth.connection';
import bluetoothmojor from '@ohos.bluetooth.constant';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { NormalPanelInfo, StatusBarPanelManager } from '../../../common/manager/StatusBarPanelManager';
import MicrophonePanelViewModel, { CurrentInputDeviceChangeForUIListener } from '../viewmodel/MicrophonePanelViewModel';
import StyleConfiguration, { ClickableMenuStyle, SoundDeviceStyle } from '../common/StyleConfiguration';
import Constants from '../common/Constants';

const TAG = 'MicrophonePanel-InputDevice';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const COMPONENT_ID_DEVICE_ICON = TAG + '_image_deviceIcon';
const COMPONENT_ID_DEVICE_NAME = TAG + '_text_deviceName';
const COMPONENT_ID_RADIO = TAG + '_checked_Image';
const SEMIBOLD = 600;
const KEYBOARD = 4;

@Component
export default struct InputDevice {
  // setting for UI
  private mDeviceType: number = audio.DeviceType.SPEAKER;
  private mDeviceIndex: number = Constants.DEFAULT_DEVICE_ID;
  private mDeviceAddress: string = '';
  style: SoundDeviceStyle = StyleConfiguration.getSoundDeviceStyle();
  @State mDeviceName: string = '';
  @State styleClickable: ClickableMenuStyle = StyleConfiguration.getClickableMenuStyle();
  @State isSelected: boolean = false;
  @State isHover: boolean = false;
  @Consume isRTL: boolean;
  @State panelInfo: NormalPanelInfo | undefined = undefined;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @Consume persistentId: number;
  // settings for status
  @State currentInputAudioDeviceIndex: number = Constants.DEFAULT_DEVICE_ID;

  @Styles normalStyles() {
    .border( {
      width: '2vp',
      color: '#00000000'
    })
  }

  @Styles focusedStyles() {
    .border( {
      width: '2vp',
      color: '#ff0a59f7'
    })
  }

  aboutToAppear() {
    log.showInfo(`${TAG} aboutToAppear`);
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId) as NormalPanelInfo;
    MicrophonePanelViewModel.registerStateChangeListener(this);
    MicrophonePanelViewModel.registerCurrentInputDeviceForUIListener(this.currentInputDeviceChangeForUIListener);
    this.currentInputAudioDeviceIndex = MicrophonePanelViewModel.getCurrentInputAudioDeviceIndex();
  }

  aboutToDisappear() {
    log.showInfo(`${TAG} aboutToDisappear`);
    MicrophonePanelViewModel.unregisterStateChangeListener(this);
    MicrophonePanelViewModel.unregisterCurrentInputDeviceForUIListener(this.currentInputDeviceChangeForUIListener);
  }

  // 输入焦点设备UI参数变更的监听回调
  private currentInputDeviceChangeForUIListener: CurrentInputDeviceChangeForUIListener = {
    onCurrentInputDeviceChangeForUI: (idex: number) => {
      this.currentInputAudioDeviceIndex = idex;
    }
  };

  build() {
    Row() {
      Row() {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
          SymbolGlyph(this.getDeviceIcon())
            .draggable(false)
            .id(COMPONENT_ID_DEVICE_ICON)
            .fontColor([this.colorModeViewData.commonIconOffColor])
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .size({ width: this.style.imageWidth,
              height: this.style.imageHeight })
            .fontSize(this.style.imageHeight)
            .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_OPACITY)

          Text(this.mDeviceName).draggable(false)
            .id(COMPONENT_ID_DEVICE_NAME)
            .fontColor(this.getCheckedColor())
            .foregroundBrightness(this.isChecked() ? undefined : this.colorModeViewData.foregroundPrimaryOption)
            .fontSize(this.panelInfo?.listTextSize)
            .fontWeight(this.getCheckedFontWeight())
            .fontFamily('HarmonyHeiTi')
            .focusable(true)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({
              left: this.style.soundDeviceGap,
              right: this.style.soundDeviceGap
            })
            .layoutWeight(1)

          Blank()

          if (this.isChecked()) {
            Image($r('app.media.ic_selected')).draggable(false)
              .id(COMPONENT_ID_RADIO)
              .width(this.style.imageWidth)
              .height(this.style.imageHeight)
              .fillColor(this.getCheckedColor())
              .edgeAntialiasing(Constants.EDGEANTIALIASING_VALUE)
          }
        }
        .key(this.getDeviceCode())
        .backgroundColor(this.getBackgroundColor())
        .height(this.styleClickable.stackHeight)
        .borderRadius(this.panelInfo?.hoverRadius)
        .padding({
          left: this.styleClickable.stackPadding,
          right: this.styleClickable.stackPadding,
        })
        .onClick((event?: ClickEvent): void => {
          if (event) {
            this.onClickEvent(event);
          }
        })
        .onHover((isHover) => {
          this.isHover = !!isHover;
        })
        .onTouch((event?: TouchEvent): void => {
          if (event) {
            this.onTouchEvent(event);
          }
        })
      }
      .justifyContent(FlexAlign.Center)
      .height(Constants.CARD_NOISE_HEIGHT)
      .borderRadius(this.panelInfo?.hoverRadius)
      .stateStyles({
        normal: this.normalStyles,
        focused: this.focusedStyles
      })
    }
    .padding({ left: this.style.menuMarginLeftRight, right: this.style.menuMarginLeftRight})
    .width(Constants.CARD_WIDTH)
    .height(Constants.CARD_NOISE_HEIGHT)
  }

  getCheckedColor(): ResourceColor | undefined {
    return this.isChecked() ? this.panelInfo?.selectedListTextColor : this.colorModeViewData.wifiOffTextColor;
  }

  getCheckedFontWeight(): string | FontWeight {
    return this.isChecked() ? SEMIBOLD : FontWeight.Medium;
  }

  private getBackgroundColor(): ResourceColor {
    if (this.isSelected) {
      return this.styleClickable.stackBgColorSelected;
    }
    if (this.isHover) {
      return this.styleClickable.stackBgColorHover;
    }
    return this.styleClickable.stackBgColorUnSelected;
  }

  private onTouchEvent(event: TouchEvent) {
    if (event.type === TouchType.Down) {
      this.isSelected = true;
    } else if (event.type === TouchType.Up) {
      this.isSelected = false;
    }
  }

  private getDeviceIcon(): Resource {
    switch (this.mDeviceType) {
      case audio.DeviceType.EARPIECE:
        return $r('sys.symbol.ear');
      case audio.DeviceType.SPEAKER:
      case audio.DeviceType.MIC:
        return $r('sys.symbol.matebook_fill');
      case audio.DeviceType.WIRED_HEADSET:
      case audio.DeviceType.WIRED_HEADPHONES:
      case audio.DeviceType.USB_HEADSET:
        return $r('sys.symbol.earphone_16640_fill');
      case audio.DeviceType.BLUETOOTH_SCO:
      case audio.DeviceType.BLUETOOTH_A2DP:
        return this.getBluetoothIcon(this.mDeviceAddress);
      case audio.DeviceType.DISPLAY_PORT:
      case audio.DeviceType.REMOTE_CAST:
        return $r('sys.symbol.smartscreen_fill');
      default:
        log.showError(`unknown type: ${JSON.stringify(this.mDeviceType)}`);
        return $r('sys.symbol.earphone_16640_fill');
    }
  }

  private isChecked() {
    log.showInfo(`${TAG} inputDevice checked info: ` +
      `${this.mDeviceIndex}-${this.currentInputAudioDeviceIndex === this.mDeviceIndex}`);
    return this.currentInputAudioDeviceIndex === this.mDeviceIndex;
  }

  private getDeviceCode() {
    switch (this.mDeviceType) {
      case audio.DeviceType.MIC:
        return 'microphone_input_device_local_machine';
      case audio.DeviceType.WIRED_HEADSET:
      case audio.DeviceType.WIRED_HEADPHONES:
      case audio.DeviceType.USB_HEADSET:
        return 'microphone_input_device_wired_headphones';
      case audio.DeviceType.BLUETOOTH_SCO:
      case audio.DeviceType.BLUETOOTH_A2DP:
        return 'microphone_input_device_bluetooth_device';
      case audio.DeviceType.DISPLAY_PORT:
        return 'microphone_input_device_display_port';
      case audio.DeviceType.REMOTE_CAST:
        return 'microphone_input_device_remote_cast';
      default:
        log.showError(`${TAG} unknown type: ${JSON.stringify(this.mDeviceType)}`);
        return 'microphone_input_device_local_machine';
    }
  }

  private onClickEvent(event: ClickEvent) {
    log.showInfo(`inputDeviceClickEvent, isChecked: ${this.isChecked()}, Type: ${this.mDeviceType}, event: ${event.source}`);
    if (this.isChecked()) {
      return;
    }
    let eventType = HiSysEventUtil.TOUCH_EVENT;
    if (event.source === SourceType.Mouse) {
      eventType = HiSysEventUtil.MOUSE_EVENT;
    } else if (event.source === KEYBOARD) {
      eventType = HiSysEventUtil.SHORTCUT_EVENT;
    }
    HiSysEventUtil.reportSoundMenu(this.mDeviceType, eventType);
    MicrophonePanelViewModel.selectAudioInputDevice(this.mDeviceIndex, TAG);
  }

  private getBluetoothIcon(deviceAddress: string): Resource {
    if (!deviceAddress) {
      log.showError('getDeviceType empty param');
      return $r('sys.symbol.bluetooth');
    }
    try {
      let deviceClass = bluetooth.getRemoteDeviceClass(deviceAddress);
      if (!deviceClass || !deviceClass.majorClass) {
        log.showError('deviceClass is null');
        return $r('sys.symbol.bluetooth');
      }
      log.showInfo(`getBluetoothIcon , majorClass : ${deviceClass.majorClass}`);
      switch (deviceClass.majorClass) {
        case bluetoothmojor.MajorClass.MAJOR_AUDIO_VIDEO:
          return $r('sys.symbol.earphone_16640_fill');
        default:
          return $r('sys.symbol.bluetooth');
      }
    } catch (error) {
      log.showError('[getBluetoothIcon] getRemoteDeviceClass error: ' + error?.message);
      return $r('sys.symbol.bluetooth');
    }
  }

  private reset(): void {
    this.isSelected = false;
    this.isHover = false;
  }

  onStateChange(panelState: boolean): void {
    log.showInfo(`onStateChange panelState: ${panelState}`);
    if (!panelState) {
      this.reset();
    }
  }
}
