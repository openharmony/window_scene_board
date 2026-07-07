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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import CommonUtils from '../../Util/CommonUtils';
import audio from '@ohos.multimedia.audio';
import AVSessionManager from '@ohos.multimedia.avsession';
import { AVCastPicker } from '@kit.AVSessionKit';
import { bannerMgr } from '@ohos/systemuicommon/src/main/ets/banner/phone/BannerManager';
import { AVCastPickerState, AVCastPickerStyle } from '@ohos.multimedia.avCastPickerParam';
import Constants, { CurOutputDevTS, AVCastPickerDeviceIconName } from '../../Util/Constants';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/src/main/ets/template/newStyle/BrightnessOptionUtils';
import StyleConfiguration, { MediaControlCardLayoutStyle } from '../../Util/StyleConfiguration';
import { AodStyleType, ImmersiveAodStyle }
  from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/interface/ImmersiveAodStyle';
import { immersiveKgMgr }
  from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import BrightnessUtils from '../../Util/BrightnessUtils';

const TAG = 'DeviceSwitchButton';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

interface IconStyleTS {
  width?: string | number | Resource;
  height?: string | number | Resource;
}

const COMPONENT_ID_OUTPUT_TYPE = TAG + '_Image_outputType';

@Component
export default struct
DeviceSwitchButton {
  @Prop buttonSize: number;
  @Prop isLiveCardStyle: boolean;
  @Prop isLiveScene: boolean;
  @Prop isDarkMode: boolean;
  @StorageLink('CurDevSelect') curOutputDev: CurOutputDevTS = { deviceType: audio.DeviceType.SPEAKER, deviceId: -1 };
  @StorageLink('CurRemoteDevSelect') curRemoteOutputDev : number = -1;
  @StorageLink('MediaType') mediaType: AVSessionManager.AVSessionType = 'audio';
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State style : MediaControlCardLayoutStyle = StyleConfiguration.getMediaControlCardLayoutStyle();
  @State isPhoneOrPad: boolean = DeviceHelper.isPhoneOrPad();
  @StorageLink('isSysColor') isSysColor: boolean = true;
  /**
   * AOD显示样式
   */
  @State aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(true);

  /**
   * AVSession缺失设备类型，标识PC
   */
  private readonly LOST_DEVICE_TYPE_PC = 8;

  /**
   * AVSession缺失设备类型，标识PAD
   */
  private readonly LOST_DEVICE_TYPE_PAD = 6;
  /**
   * AVSession缺失设备类型，标识phone
   */
  private readonly LOST_DEVICE_TYPE_PHONE = 7;
  /**
   * Is small external screen.
   */
  @Prop isSmallFoldOuterScreen: boolean;

  aboutToAppear(): void {
    log.showInfo('device switch button aboutToAppear');
  }

  aboutToDisappear(): void {
    log.showInfo('device switch button aboutToDisappear');
  }

  getCurSwitchIcon() : string {
    log.showInfo(` getshowing curswitch : Localdevice: ${this.curOutputDev.deviceId?.toString().length < 10 ? '' :
      (this.curOutputDev.deviceId?.toString().substr(0, 5) + '**' + this.curOutputDev.deviceId?.toString().substr(
        this.curOutputDev.deviceId?.toString().length - 5))}, ` + `LocalType: ${this.curOutputDev.deviceType},
        remoteType: ${this.curRemoteOutputDev}`);
    if (this.curRemoteOutputDev >= 0) {
      switch (this.curRemoteOutputDev) {
        case AVSessionManager.DeviceType.DEVICE_TYPE_SMART_SPEAKER:
          return AVCastPickerDeviceIconName.SOUND_BOX_SYMBOL;
        case AVSessionManager.DeviceType.DEVICE_TYPE_BLUETOOTH:
          return AVCastPickerDeviceIconName.BLUETOOTH_SYMBOL;
        case this.LOST_DEVICE_TYPE_PAD:
          return AVCastPickerDeviceIconName.PAD_SYMBOL;
        case this.LOST_DEVICE_TYPE_PC:
          return AVCastPickerDeviceIconName.MATEBOOK_SYMBOL;
        default:
          return AVCastPickerDeviceIconName.MATEBOOK_SYMBOL;
      }
    }
    switch (this.curOutputDev.deviceType) {
      case audio.DeviceType.SPEAKER:
        if (CommonUtils.isShowCarIcon(this.curOutputDev.networkId, this.curOutputDev.deviceType)) {
          return AVCastPickerDeviceIconName.CAR_SYMBOL;
        } else {
          return this.mediaType === 'video' ?
          AVCastPickerDeviceIconName.CAST_SCREEN_SYMBOL : AVCastPickerDeviceIconName.CAST_STREAM_SYMBOL;
        }
      case audio.DeviceType.USB_HEADSET:
      case audio.DeviceType.WIRED_HEADSET:
      case audio.DeviceType.WIRED_HEADPHONES:
        return AVCastPickerDeviceIconName.WIRED_SYMBOL;
      case audio.DeviceType.BLUETOOTH_A2DP:
      case audio.DeviceType.BLUETOOTH_SCO:
        return `${CommonUtils.getBluetoothFillIcon(this.curOutputDev.deviceAddress)}`;
      case audio.DeviceType.NEARLINK:
        return `${CommonUtils.getNearlinkFillIcon(this.curOutputDev.deviceAddress)}`;
      case Constants.DEVICE_TYPE_HEARING_AID:
        return AVCastPickerDeviceIconName.HEARING_AID_SYMBOL;
      default:
        return this.mediaType === 'video' ?
          AVCastPickerDeviceIconName.CAST_SCREEN_SYMBOL : AVCastPickerDeviceIconName.CAST_STREAM_SYMBOL;
    }
  }

  isLocalSpeaker(): boolean {
    return ((this.curOutputDev.deviceType === audio.DeviceType.SPEAKER &&
      this.curOutputDev.networkId === 'LocalDevice') ||
      (this.curOutputDev.deviceType === audio.DeviceType.SPEAKER &&
      this.curOutputDev.networkId !== 'LocalDevice' &&
      !CommonUtils.isShowCarIcon(this.curOutputDev.networkId, this.curOutputDev.deviceType)) ||
      this.curOutputDev.deviceType === audio.DeviceType.EARPIECE ||
      this.curOutputDev.deviceType == audio.DeviceType.REMOTE_CAST ||
      !!this.aodStyle?.isAod) && (this.curRemoteOutputDev < 0 || !!this.aodStyle?.isAod);
  }

  getFillColor(): ResourceColor {
    if (this.isLocalSpeaker()) {
      return this.isPhoneOrPad ? $r('app.color.media_control_switch_full') :
        $r('app.color.ohos_id_color_secondary');
    }
    if (this.isLiveCardStyle) {
      return '#E5E5E5';
    }
    return this.isPhoneOrPad ? $r('app.color.media_control_switch_active_full') :
      $r('app.color.ohos_id_color_primary_contrary');
  }

  getSwitchBackground(): ResourceColor {
    if (this.isLocalSpeaker()) {
      if (this.aodStyle?.isAod) {
        return $r('app.color.ohos_id_color_component_normal');
      }
      return this.isPhoneOrPad ? $r('app.color.media_item_component_normal') :
        $r('app.color.ohos_id_color_component_normal');
    } else {
      if (this.isLiveCardStyle) {
        return '#317AF7';
      }
      return this.isPhoneOrPad ? $r('app.color.media_item_switch_active_bgc') :
        $r('app.color.ohos_id_color_emphasize');
    }
  }

  private getRenderingStrategy(iconName: string): SymbolRenderingStrategy {
    if (iconName === AVCastPickerDeviceIconName.CAST_STREAM_SYMBOL ||
      iconName === AVCastPickerDeviceIconName.CAST_SCREEN_SYMBOL) {
      return SymbolRenderingStrategy.SINGLE;
    }
    return SymbolRenderingStrategy.MULTIPLE_OPACITY;
  }

  build() {
    Row() {
      AVCastPicker({
        pickerStyle: AVCastPickerStyle.STYLE_MENU,
        customPicker: (): void => this.SwitchIconBuilder(),
        onStateChange: (state: AVCastPickerState) => {
          log.showInfo(`avcast picker state change ${state} | ${this.isLiveScene}`);
          if (this.isLiveScene && state === AVCastPickerState.STATE_APPEARING) {
            bannerMgr.enterFullPanelRegion();
            log.debug(`avcast picker enter fullPanel`);
          } else if (this.isLiveScene && state === AVCastPickerState.STATE_DISAPPEARING) {
            bannerMgr.exitFullPanelRegion();
            log.debug(`avcast picker exit fullPanel`)
          }
        },
        activeColor: this.isLiveScene ? 'liveCardLoadingColor' : undefined,
      })
        .width('100%')
        .height('100%')
        .id('controllerSwitchIcon')
    }
    .width('100%')
    .height('100%')
  }

  @Builder SymbolIconBuilder() {
    SymbolGlyph($r(this.getCurSwitchIcon()))
      .fontSize(!this.isSmallFoldOuterScreen ? Constants.COMMON_CAST_SMALL_SIZE : Constants.SMALL_SCREEN_CARD_CAST_ICON)
      .draggable(false)
      .id(COMPONENT_ID_OUTPUT_TYPE)
      .fontColor(this.aodStyle?.isAod ? [this.aodStyle?.getStyleValue(AodStyleType.MEDIA_BUTTON_COLOR)] :
        [this.getFillColor()])
      .foregroundBrightness(this.aodStyle?.isAod ? undefined :
        BrightnessUtils.getInstance().getItemTextBrightnessOption(!this.isLocalSpeaker(),
        this.isLiveCardStyle ? 'liveSwitch' : 'deviceSwitch', this.isDarkMode))
      .renderingStrategy(this.getRenderingStrategy(this.getCurSwitchIcon()))
  }

  @Builder
  SwitchIconBuilder() {
    Column() {
      Column() {
        this.SymbolIconBuilder()
      }
      .width(this.buttonSize)
      .height(this.buttonSize)
      .borderRadius(120)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.getSwitchBackground())
      .backgroundBrightnessInternal(this.aodStyle?.isAod ? undefined :
        BrightnessUtils.getInstance().getItemTextBrightnessOption(!this.isLocalSpeaker(),
        this.isLiveCardStyle ? 'liveSwitchBgc' : 'deviceSwitchBgc', this.isDarkMode))
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
