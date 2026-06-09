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

import { LogDomain, LogHelper, PluginLocalInfo, PluginSlot } from '@ohos/basicutils';
import { PluginLocalInfo, PluginSlot } from '@ohos/frameworkwrapper';
import { Constants } from '@ohos/systemuicommon';
import { StatusBarTint } from '../common/StatusBarTint';
import { AbsResourceManager as ResourceManager } from '@ohos/frameworkwrapper';
import { StaticVariables } from '../common/StaticVariables';

const TAG = 'StaticComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 *
 * 静态图标组件
 * 用于PC双中心，音量，系统菜单
 */
@Component
export struct StaticComponent {
  @StorageLink('hasUnReadNotification') @Watch('onChangeImage') hasUnReadNotification: boolean = false;
  @StorageLink('VolumePanelMaxVolume') volumePanelMaxVolume: number = Constants.DEFAULT_MAX_VOLUME;
  @StorageLink('VolumePanelMinVolume') volumePanelMinVolume: number = Constants.DEFAULT_MIN_VOLUME;
  @StorageLink('VolumePanelCurrentVolumeValue') @Watch('onChangeImage') volumePanelCurrentVolumeValue: number = Constants.DEFAULT_MIN_VOLUME;
  @Consume @Watch('onChangeImage') contentColor: string;
  pluginInfo: PluginLocalInfo = new PluginLocalInfo();
  @State mImage: Resource | undefined = undefined;
  componentId: string = '';
  images: Map<string, Resource> = new Map();
  private resourceMgr: ResourceManager | null = null;

  aboutToAppear() {
    log.showInfo(`aboutToAppear icon:${this.pluginInfo?.pluginParseInfo?.pluginSlot}`);
    this.initImages();
    this.onChangeImage();
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear icon:${this.pluginInfo?.pluginParseInfo?.pluginSlot}`);
  }

  private onChangeImage() {
    if (this.pluginInfo?.pluginParseInfo?.pluginSlot === PluginSlot.SLOT_STATUS_SOUND_PANEL) {
      this.mImage = this.getSoundCurrentVolumeImage(this.images);
    } else if (this.pluginInfo?.pluginParseInfo?.pluginSlot === PluginSlot.SLOT_STATUS_PERSONAL) {
      this.mImage = this.getPersonalImage(this.images);
    } else if (this.pluginInfo?.pluginParseInfo?.pluginSlot === PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL) {
      this.mImage = this.getNotificationImage(this.images);
    } else if (this.pluginInfo?.pluginParseInfo?.pluginSlot === PluginSlot.SLOT_STATUS_CONTROL_CENTER) {
      this.mImage = this.getControlCenterImage(this.images);
    }
  }

  private initImages(): void {
    if (this.pluginInfo?.pluginParseInfo?.pluginSlot === PluginSlot.SLOT_STATUS_SOUND_PANEL &&
      this.resourceMgr?.getPcSoundIcons) {
      this.images = this.resourceMgr?.getPcSoundIcons();
    } else if (this.pluginInfo?.pluginParseInfo?.pluginSlot === PluginSlot.SLOT_STATUS_PERSONAL &&
      this.resourceMgr?.getPcPersonalIcons) {
      this.images = this.resourceMgr?.getPcPersonalIcons();
    } else if (this.pluginInfo?.pluginParseInfo?.pluginSlot === PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL &&
      this.resourceMgr?.getPcNotificationIcons) {
      this.images = this.resourceMgr?.getPcNotificationIcons();
    } else if (this.pluginInfo?.pluginParseInfo?.pluginSlot === PluginSlot.SLOT_STATUS_CONTROL_CENTER &&
      this.resourceMgr?.getPcControlCenterIcons) {
      this.images = this.resourceMgr?.getPcControlCenterIcons();
    }
  }

  private getPersonalImage(images: Map<string, Resource>): Resource | undefined {
    return this.contentColor === StatusBarTint.CONTENT_COLOR_WHITE ?
    images.get(StaticVariables.PC_WHITE_HOME) : images.get(StaticVariables.PC_BLACK_HOME);
  }

  private getControlCenterImage(images: Map<string, Resource>): Resource | undefined {
    return this.contentColor === StatusBarTint.CONTENT_COLOR_WHITE ?
    images.get(StaticVariables.PC_WHITE_CONTROL_CENTER) : images.get(StaticVariables.PC_BLACK_CONTROL_CENTER);
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

  private getSoundCurrentVolumeImage(images: Map<string, Resource>): Resource | undefined {
    if (this.volumePanelCurrentVolumeValue === this.volumePanelMinVolume) {
      return this.contentColor === StatusBarTint.CONTENT_COLOR_WHITE ?
      images.get(StaticVariables.PC_WHITE_SOUND_MUTE) : images.get(StaticVariables.PC_BLACK_SOUND_MUTE);
    } else {
      let thirdOfMaxVolume = (this.volumePanelMaxVolume - this.volumePanelMinVolume) / 3;
      if (this.volumePanelCurrentVolumeValue < (thirdOfMaxVolume + this.volumePanelMinVolume)) {
        return this.contentColor === StatusBarTint.CONTENT_COLOR_WHITE ?
        images.get(StaticVariables.PC_WHITE_SOUND_LOW) : images.get(StaticVariables.PC_BLACK_SOUND_LOW);
      } else if (this.volumePanelCurrentVolumeValue < (thirdOfMaxVolume * 2 + this.volumePanelMinVolume)) {
        return this.contentColor === StatusBarTint.CONTENT_COLOR_WHITE ?
        images.get(StaticVariables.PC_WHITE_SOUND_MIDDLE) : images.get(StaticVariables.PC_BLACK_SOUND_MIDDLE);
      } else {
        return this.contentColor === StatusBarTint.CONTENT_COLOR_WHITE ?
        images.get(StaticVariables.PC_WHITE_SOUND_HIGH) : images.get(StaticVariables.PC_BLACK_SOUND_HIGH);
      }
    }
  }

  buildLog(): boolean {
    log.showInfo('slot: ' + this.pluginInfo?.pluginParseInfo?.pluginSlot +
      ',image: ' + this.mImage);
    return true;
  }

  build() {
    if (this.buildLog()) {
      Image(this.mImage)
        .draggable(false)
        .id(this.componentId)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
        .interpolation(ImageInterpolation.Low)
    }
  }
}