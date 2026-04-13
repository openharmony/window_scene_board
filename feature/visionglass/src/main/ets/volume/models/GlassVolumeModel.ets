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

import { audio } from '@kit.AudioKit';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlassVolumePanelManager } from '../Index';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, 'GlassVolumeModel');

export class GlassVolumeModel {
  @Track public maxVolumeValue: number = 0;
  @Track public minVolumeValue: number = 0;
  @Track public volumeValue: number | undefined = 0;
  private audioManager: audio.AudioManager | null = null;
  private audioVolumeManager: audio.AudioVolumeManager | null = null;
  private audioVolumeGroupManager: audio.AudioVolumeGroupManager | null = null;

  constructor() {
    try {
      this.audioManager = audio.getAudioManager();
      this.audioVolumeManager = this.audioManager.getVolumeManager();
      this.audioVolumeGroupManager = this.audioVolumeManager.getVolumeGroupManagerSync(audio.DEFAULT_VOLUME_GROUP_ID);
      log.showInfo(`init volumeVM success`);
    } catch (err) {
      log.showError(`fail init volumeVM, code: ${err?.code}, message: ${err?.message}`);
    }
  }

  /*
   * 初始化音量条相关数值
   * */
  public init(): void {
    this.getVolume();
    this.getMaxVolume();
    this.getMinVolume();
    this.onVolumeChange((value: number) => {
      this.volumeValue = value;
    })
  }

  /*
   * 获取音量条最大音量
   * */
  public getMaxVolume(): void {
    try {
      this.maxVolumeValue =
        this.audioVolumeGroupManager?.getMaxVolumeSync(audio.AudioVolumeType.MEDIA) ?? this.maxVolumeValue;
      log.showInfo(`Indicate that the maximum volume is obtained. ${this.maxVolumeValue}`);
    } catch (err) {
      log.showError(`Failed to obtain the maximum volume, code: ${err?.code}, message: ${err?.message}`);
    }
  }

  /*
   * 获取音量条最小音量
   * */
  public getMinVolume(): void {
    try {
      this.minVolumeValue =
        this.audioVolumeGroupManager?.getMinVolumeSync(audio.AudioVolumeType.MEDIA) ?? this.minVolumeValue;
      log.showInfo(`Indicate that the minimum volume is obtained ${this.minVolumeValue}.`);
    } catch (err) {
      log.showError(`Failed to obtain the minimum volume, code: ${err?.code}, message: ${err?.message}`);
    }
  }

  /*
   * 更新当前音量
   * */
  public getVolume(): void {
    try {
      this.volumeValue = this.audioVolumeGroupManager?.getVolumeSync(audio.AudioVolumeType.MEDIA);
      log.showInfo(`Indicate that the volume is obtained ${this.volumeValue}.`);
    } catch (err) {
      log.showError(`Failed to obtain the volume, code: ${err?.code}, message: ${err?.message}`);
    }
  }

  /*
   * 设置音量
   *
   * @param volume
   * */
  public async setVolume(volume: number): Promise<void> {
    let interfaceVolumeType = audio.AudioVolumeType.MEDIA;
    try {
      await this.audioVolumeGroupManager?.setVolume(interfaceVolumeType, volume);
      log.showInfo(`sound setVolume media ${volume}`);
    } catch (err) {
      log.showError(`sound setVolume media ${volume} fail, code: ${err?.code}, message: ${err?.message}`);
    }
  }

  /*
   * 音量变化回调
   *
   * @param callback
   * */
  public onVolumeChange(callback: (value: number) => void): void {
    this.audioVolumeManager?.on('volumeChange', (volumeEvent: audio.VolumeEvent) => {
      log.showInfo(`onVolumeChange stream: ${volumeEvent.volumeType}, level: ${volumeEvent.volume}`);
      if (volumeEvent.volumeType === audio.AudioVolumeType.MEDIA) {
        callback(volumeEvent.volume);
        GlassVolumePanelManager.getInstance().showVolumePanel();
      }
    });
  }

  /*
   * 去初始化
   * */
  public unInit(): void {
    try {
      this.audioVolumeManager?.off('volumeChange');
    } catch (err) {
      log.showError(`uninit fail,error is ${err.message}`);
    }
  }
}