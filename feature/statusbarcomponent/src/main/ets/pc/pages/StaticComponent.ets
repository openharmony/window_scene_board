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

import { audio } from '@kit.AudioKit';
import { IconMap as SoundIconMap } from '@ohos/soundcomponent';
import { BusinessError } from '@ohos.base';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { PluginLocalInfo, PluginSlot, AbsResourceManager as ResourceManager } from '@ohos/frameworkwrapper';
import { StaticVariables } from '../../common/StaticVariables';
import { StatusBarTint } from '../../common/StatusBarTint';

const TAG = 'StaticComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const OUTPUT_DEVICE_INDEX = 0;
const OUTPUT_DEVICE_CHANGE_LISTENER = 'preferOutputDeviceChangeForRendererInfo';

/**
 *
 * 静态图标组件
 * 用于PC双中心，音量，系统菜单
 */
@Component
export struct StaticComponent {
  @StorageLink('hasUnReadNotification') @Watch('onChangeImage') hasUnReadNotification: boolean = false;
  @StorageLink('volumePercentForHoverTips') @Watch('onChangeImage') volumePercentText: number = 0;
  @StorageLink('MicrophonePanelCurrentEnable') microphonePanelCurrentEnable: boolean = true;
  @Consume @Watch('onChangeImage') contentColor: string;
  @State mImage: Resource | undefined = undefined;
  // 当前出声设备Symbol图标
  @StorageLink('VolumeSymbolIcon') volumeSymbolIcon: string | undefined = undefined;
  @State isSpeakerOutput: boolean = true;
  pluginInfo: PluginLocalInfo = new PluginLocalInfo();
  componentId: string = '';
  images: Map<string, Resource> = new Map();
  private resourceMgr: ResourceManager | null = null;
  private audioRoutingManager: audio.AudioRoutingManager | null = null;
  private outputDeviceCallback?: (descriptors: audio.AudioDeviceDescriptors) => void;
  @State shadowOptions: ShadowOptions[] | undefined = undefined;
  private bluetoothDeviceIcon?: string;

  aboutToAppear() {
    log.showInfo(`aboutToAppear icon:${this.pluginInfo?.pluginParseInfo?.pluginSlot}`);
    this.initImages();
    this.onChangeImage();
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear icon:${this.pluginInfo?.pluginParseInfo?.pluginSlot}`);
    if (this.pluginInfo?.pluginParseInfo?.pluginSlot === PluginSlot.SLOT_STATUS_SOUND_PANEL &&
    this.outputDeviceCallback) {
      this.audioRoutingManager?.off(OUTPUT_DEVICE_CHANGE_LISTENER, this.outputDeviceCallback);
    }
  }

  private onChangeImage() {
    if (this.pluginInfo?.pluginParseInfo?.pluginSlot === PluginSlot.SLOT_STATUS_SOUND_PANEL) {
      this.getSoundCurrentVolumeImage();
      return;
    }
    if (this.pluginInfo?.pluginParseInfo?.pluginSlot === PluginSlot.SLOT_STATUS_MICROPHONE_PANEL) {
      this.shadowOptions = this.contentColor === StatusBarTint.CONTENT_COLOR_WHITE ?
        [{
          radius: 2,
          color: '#33000000',
          offsetY: 1
        },
          {
            radius: 6,
            color: '#33000000',
            offsetY: 2
          }] : undefined;
      return;
    }
    if (this.pluginInfo?.pluginParseInfo?.pluginSlot === PluginSlot.SLOT_STATUS_PERSONAL) {
      this.mImage = this.contentColor === '#FFFFFF' ? $r('app.media.pc_dark_hoskey') : $r('app.media.pc_light_hoskey');
      return;
    }
    if (this.pluginInfo?.pluginParseInfo?.pluginSlot === PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL) {
      this.mImage = this.getNotificationImage(this.images);
      return;
    }
    if (this.pluginInfo?.pluginParseInfo?.pluginSlot === PluginSlot.SLOT_STATUS_CONTROL_CENTER) {
      this.mImage = $r('sys.symbol.slider_horizontal_2');
      return;
    }
  }

  private initImages(): void {
    if (!this.resourceMgr) {
      log.showError('reourceManager invalid');
      return;
    }
    let slot = this.pluginInfo?.pluginParseInfo?.pluginSlot;
    if (slot === PluginSlot.SLOT_STATUS_SOUND_PANEL) {
      this.onSoundOutputDevice();
      this.images = this.resourceMgr.getPcSoundIcons();
      return;
    }
    if (slot === PluginSlot.SLOT_STATUS_PERSONAL) {
      this.images = this.resourceMgr.getPcPersonalIcons();
      return;
    }
    if (slot === PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL) {
      this.images = this.resourceMgr.getPcNotificationIcons();
      return;
    }
    if (slot === PluginSlot.SLOT_STATUS_CONTROL_CENTER) {
      this.images = this.resourceMgr.getPcControlCenterIcons();
      return;
    }
  }

  private getNotificationImage(images: Map<string, Resource>): Resource | undefined {
    if (this.hasUnReadNotification) {
      return this.contentColor === StatusBarTint.CONTENT_COLOR_WHITE ?
      images.get(StaticVariables.PC_WHITE_NOTICE_WITH_MESSAGE) :
      images.get(StaticVariables.PC_BLACK_NOTICE_WITH_MESSAGE);
    }
    return this.contentColor === StatusBarTint.CONTENT_COLOR_WHITE ?
    images.get(StaticVariables.PC_WHITE_NOTICE) : images.get(StaticVariables.PC_BLACK_NOTICE);
  }

  private getSoundCurrentVolumeImage(): void {
    if (this.volumePercentText === 0) {
      this.mImage = this.contentColor === StatusBarTint.CONTENT_COLOR_WHITE ?
      this.images.get(StaticVariables.PC_WHITE_SOUND_MUTE) : this.images.get(StaticVariables.PC_BLACK_SOUND_MUTE);
      AppStorage.setOrCreate('VolumeSymbolIcon', undefined);
      return;
    }
    this.shadowOptions = this.contentColor === StatusBarTint.CONTENT_COLOR_WHITE ?
      [{
         radius: 2,
         color: '#33000000',
         offsetY: 1
       },
       {
         radius: 6,
         color: '#33000000',
         offsetY: 2
       }] : undefined;
    if (!this.isSpeakerOutput && this.bluetoothDeviceIcon) {
      AppStorage.setOrCreate('VolumeSymbolIcon', this.bluetoothDeviceIcon);
      return;
    }
    let volumePercent = this.volumePercentText / 100;
    if (volumePercent < 1/3) {
      this.mImage = this.contentColor === StatusBarTint.CONTENT_COLOR_WHITE ?
      this.images.get(StaticVariables.PC_WHITE_SOUND_LOW) : this.images.get(StaticVariables.PC_BLACK_SOUND_LOW);
    } else if (volumePercent < 2/3) {
      this.mImage = this.contentColor === StatusBarTint.CONTENT_COLOR_WHITE ?
      this.images.get(StaticVariables.PC_WHITE_SOUND_MIDDLE) : this.images.get(StaticVariables.PC_BLACK_SOUND_MIDDLE);
    } else {
      this.mImage = this.contentColor === StatusBarTint.CONTENT_COLOR_WHITE ?
      this.images.get(StaticVariables.PC_WHITE_SOUND_HIGH) : this.images.get(StaticVariables.PC_BLACK_SOUND_HIGH);
    }
    AppStorage.setOrCreate('VolumeSymbolIcon', undefined);
  }

  private onSoundOutputDevice(): void {
    log.showInfo(`onSoundOutputDevice pluginSlot: ${this.pluginInfo?.pluginParseInfo?.pluginSlot}`);
    try {
      this.audioRoutingManager = audio.getAudioManager().getRoutingManager();
    } catch (e) {
      log.showError(`onSoundOutputDevice getRoutingManager error: ${e?.message}`);
      return;
    }
    // init outputDevice Listener
    this.outputDeviceCallback = (descriptors: audio.AudioDeviceDescriptors) => {
      if (!descriptors || descriptors.length < 1) {
        log.showError(`onSoundOutputDevice descriptors invalid: ${descriptors}`);
        return;
      }
      const outputDevice: audio.AudioDeviceDescriptor = descriptors[OUTPUT_DEVICE_INDEX];
      log.showInfo(`onSoundOutputDevice displayName: ${outputDevice.displayName}, deviceType: ${
      outputDevice.deviceType}`);
      this.getSoundSymbolIcon(outputDevice);
    };
    const rendererInfo: audio.AudioRendererInfo = {
      usage: audio.StreamUsage.STREAM_USAGE_MEDIA,
      rendererFlags: 0
    };
    try {
      this.audioRoutingManager?.on(OUTPUT_DEVICE_CHANGE_LISTENER, rendererInfo, this.outputDeviceCallback);
    } catch (e) {
      log.showError(`onSoundOutputDevice onlisten preferOutputDeviceChangeForRendererInfo error: ${e?.message}`);
    }
    // get outputDevice initial value
    this.audioRoutingManager?.getPreferOutputDeviceForRendererInfo(rendererInfo).then((descriptors) => {
      if (!descriptors || descriptors.length < 1) {
        log.showError(`onSoundOutputDevice descriptors invalid: ${descriptors}`);
        return;
      }
      const outputDevice: audio.AudioDeviceDescriptor = descriptors[OUTPUT_DEVICE_INDEX];
      this.getSoundSymbolIcon(outputDevice);
    }).catch((e: BusinessError) => {
      log.showInfo(`onSoundOutputDevice getPreferredOutputDeviceForRendererInfoSync error: ${e?.message}`);
    })
  }

  private getSoundSymbolIcon(outputDevice: audio.AudioDeviceDescriptor) {
    if (outputDevice) {
      const icon: string = SoundIconMap.getDeviceTypeIconString(outputDevice.deviceType, outputDevice.address);
      if (SoundIconMap.isEarphoneIconString(icon)) {
        this.isSpeakerOutput = false;
        this.bluetoothDeviceIcon = icon;
        this.getSoundCurrentVolumeImage();
        return;
      }
    }
    this.isSpeakerOutput = true;
    this.bluetoothDeviceIcon = undefined;
    this.getSoundCurrentVolumeImage();
  }

  buildLog(): boolean {
    log.showInfo('slot: ' + this.pluginInfo?.pluginParseInfo?.pluginSlot +
      ',image: ' + this.mImage);
    return true;
  }

  @Builder
  SoundPanelIcon() {
    if (this.volumeSymbolIcon) {
      Text() {
        SymbolSpan($r(`${this.volumeSymbolIcon}`))
          .draggable(false)
          .fontSize(`${vp2px(20)}px`)
          .fontColor([this.contentColor])
          .fontWeight(FontWeight.Medium)
      }
      .textShadow(this.shadowOptions)
    } else {
      Image(this.mImage)
        .draggable(false)
        .id(this.componentId)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
        .interpolation(ImageInterpolation.Low)
        .syncLoad(true)
        .matchTextDirection(true)
    }
  }

  @Builder
  MicrophonePanelIcon() {
    Text() {
      SymbolSpan(this.microphonePanelCurrentEnable ? $r('sys.symbol.mic_fill') : $r('sys.symbol.mic_slash_fill'))
        .draggable(false)
        .fontSize(`${vp2px(22)}px`)
        .fontColor([this.contentColor])
        .fontWeight(FontWeight.Medium)
    }
    .textShadow(this.shadowOptions)
  }

  build() {
    if (this.buildLog()) {
      if (this.pluginInfo?.pluginParseInfo?.pluginSlot === PluginSlot.SLOT_STATUS_SOUND_PANEL) {
        this.SoundPanelIcon()
      } else if (this.pluginInfo?.pluginParseInfo?.pluginSlot === PluginSlot.SLOT_STATUS_MICROPHONE_PANEL) {
        this.MicrophonePanelIcon()
      } else { // 其他
        Image(this.mImage)
          .draggable(false)
          .id(this.componentId)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Contain)
          .interpolation(ImageInterpolation.Low)
          .syncLoad(true)
      }
    }
  }
}