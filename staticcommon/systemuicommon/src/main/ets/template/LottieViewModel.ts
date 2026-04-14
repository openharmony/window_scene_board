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
import { LogDomain, LogHelper} from '@ohos/basicutils';
import { PluginSlot, DeviceHelper, sEventManager} from '@ohos/frameworkwrapper';
import type { VolumeInfo } from './common/Constants';
import { AudioVolumeType } from './common/Constants';
import Constants from './common/Constants';

const TAG = 'LottieViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class LottieViewModel {
  readonly VolumePanelMaxVolumeKey = 'VolumePanelMaxVolume';
  readonly VolumePanelMinVolumeKey = 'VolumePanelMinVolume';
  readonly VolumePanelCurrentVolumeValueKey = 'VolumePanelCurrentVolumeValue';
  readonly VolumePanelIsMuteKey = 'VolumePanelIsMute';

  mMaxVolume: AbstractProperty<number>;
  mMinVolume: AbstractProperty<number>;
  mCurrentAudioVolume: number;
  mVolumeBeforeMute: number = 0;

  constructor() {
    log.showInfo('Constructor');
    this.initViewModel();
  }

  static getInstance(): LottieViewModel {
    if (globalThis.LottieViewModelInstance == null) {
      globalThis.LottieViewModelInstance = new LottieViewModel();
    }
    return globalThis.LottieViewModelInstance as LottieViewModel;
  }

  private initViewModel(): void {
    log.showInfo('initViewModel');
    this.mMaxVolume = AppStorage.setAndRef(this.VolumePanelMaxVolumeKey, Constants.DEFAULT_MAX_VOLUME);
    this.mMinVolume = AppStorage.setAndRef(this.VolumePanelMinVolumeKey, Constants.DEFAULT_MIN_VOLUME);
    let initCurrentVolume = AppStorage.get('VolumePanelCurrentVolumeValue');
    AppStorage.setOrCreate('LottieSoundCurrentVolume', initCurrentVolume);
    sEventManager.subscribe('volumeChangeEvent', (volumeInfo: VolumeInfo) => {
      this.updateVolumeInfo(volumeInfo);
    });
    sEventManager.subscribe('VolumeChangeEvent', (volumeInfo: VolumeInfo) => {
      this.updateVolumeInfo(volumeInfo);
    });
  }

  private updateVolumeInfo(volumeInfo: VolumeInfo): void {
    log.showInfo(`updateVolumeInfo, volumeInfo: ${volumeInfo?.volumeType}--${volumeInfo?.volume}
      --${volumeInfo?.isMute}--${volumeInfo?.updateUi}--${volumeInfo?.hostType} `);
    if (!this.updateUi(volumeInfo)) {
      return;
    }
    this.mCurrentAudioVolume = volumeInfo.volume;
    log.showInfo(`updateVolumeInfo, mCurrentAudioVolume: ${this.mCurrentAudioVolume} `);
    log.showInfo(`updateVolumeInfo, mMaxVolume: ${this.mMaxVolume.get()} `);
    log.showInfo(`updateVolumeInfo, mMinVolume: ${this.mMinVolume.get()} `);
    let isMute = this.adjustMuteState(volumeInfo);
    if (!isMute) {
      this.mVolumeBeforeMute = volumeInfo.volume;
    }
    log.showInfo(`updateVolumeInfo, ajust mute: ${isMute} `);
    log.showInfo(`updateVolumeInfo, mVolumeBeforeMute: ${this.mVolumeBeforeMute} `);
    this.updateDisplayVolume(isMute ? (this.mMinVolume.get() as number) : (volumeInfo.volume as number),
      (this.mMaxVolume.get() as number), (this.mMinVolume.get() as number));
    AppStorage.set('LottieSoundCurrentVolume', volumeInfo.volume);
  }

  private updateUi(volumeInfo: VolumeInfo): boolean {
    if (volumeInfo.volumeType !== AudioVolumeType.MEDIA) {
      return false;
    }
    return true;
  }

  private adjustMuteState(volumeInfo: VolumeInfo): boolean {
    if (this.mMinVolume.get() === this.mCurrentAudioVolume) {
      return true;
    }
    return volumeInfo.isMute as boolean;
  }

  private updateDisplayVolume(volume: number, maxVolume: number, minVolume: number): void {
    log.showInfo(`updateDisplayVolume, volume: ${volume} maxVolume: ${maxVolume} minVolume: ${minVolume}`);
    let displayVolume: number = volume;
  }

  getAnimationLastTime(animateName: string): number {
    log.showInfo(`getAnimationLastTime start, animateName:${animateName}`);
    let framePerSecond = 60;
    let frames = this.getFrames(animateName);
    let animationLastTime = frames / framePerSecond * Constants.FRAMES_INTERVAL;
    log.showInfo(`animateName:${animateName}, animationLastTime:${animationLastTime}`);
    return animationLastTime;
  }

  private getFrames(animateName: string): number {
    switch (animateName) {
      case PluginSlot.SLOT_STATUS_CONTROL_CENTER:
        return Constants.FRAMES_CONTROL_CENTER;
      case PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL:
        return this.getNotificationFrames();
      case PluginSlot.SLOT_STATUS_SOUND_PANEL:
        return Constants.FRAMES_SOUND;
      default:
        // default: no animation, animateName error ?
        log.showError(`get Frames failed, no animation, animateName:${animateName}`);
        return 0;
    }
  }

  private getNotificationFrames(): number {
    const hasUnReadNotification: boolean = AppStorage.get('hasUnReadNotification');
    return hasUnReadNotification ? Constants.FRAMES_NOTIFICATION_UNREAD : Constants.FRAMES_NOTIFICATION_READ;
  }

  static isLottieComponent(pluginSlot: string): boolean {
    if (DeviceHelper.isPC() &&
      (pluginSlot === PluginSlot.SLOT_STATUS_CONTROL_CENTER ||
      pluginSlot === PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL ||
      pluginSlot === PluginSlot.SLOT_STATUS_SOUND_PANEL)) {
      return true;
    }
    return false;
  }

  static isNeedHoverAnimation(pluginSlot: string): boolean {
    if (DeviceHelper.isPC() && PluginSlot.defaultAnimSet.has(pluginSlot)) {
      return true;
    }
    return false;
  }
}

/**
 * 绑定数据基类
 */
export class CommonData {
  public status: boolean = false;
}