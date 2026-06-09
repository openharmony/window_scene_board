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

import { LogHelper, LogDomain } from '@ohos/basicutils';
import { IAudioPlayerHelper } from './IAudioPlayerHelper';
import media from '@ohos.multimedia.media';
import resourceManager from '@ohos.resourceManager';
import common from '@ohos.app.ability.common';
import audio from '@ohos.multimedia.audio';
import { BusinessError } from '@ohos.base';

const TAG = 'AudioPlayerHelper';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
// 每次播放间隔时间
const PER_PLAY_ONCE_DURATION = 250;
// 最大播放音频时间
const PLAY_ONCE_MAX_DURATION = 400;

class AudioPlayerHelper implements IAudioPlayerHelper {
  private audioPlayer: media.SoundPool | null = null;
  private soundId: number = 0;
  private pcAudioFd?: resourceManager.RawFileDescriptor;
  private context: common.Context;
  private maxStreams: number = 1;
  private lastPlayTime: number = new Date().getTime();
  private isPlaying: boolean = false;
  private isFirstPlay: boolean = true;
  private loadCompleted: boolean = false;

  public constructor(ctx: common.Context) {
    this.context = ctx;
  }
  // 音频渲染器信息
  private audioRendererInfo: audio.AudioRendererInfo = {
    usage: audio.StreamUsage.STREAM_USAGE_MUSIC,
    rendererFlags: 0
  }
  // 播放参数

  private PlayParameters: media.PlayParameters = {
    loop: 0, // 循环1次
    rate: audio.AudioRendererRate.RENDER_RATE_NORMAL, // 正常倍速
    leftVolume: 1.0, // range = 0.0-1.0
    rightVolume: 1.0, // range = 0.0-1.0
    priority: 0, // 最低优先级
    parallelPlayFlag: true // 和其它正在播放的音频并行播放
  }

  public async playAudioOnce(): Promise<void> {
    log.showInfo('playAudioOnce begin');
    let currentTime = new Date().getTime();
    if (currentTime - this.lastPlayTime < PER_PLAY_ONCE_DURATION) {
      log.showInfo('Too fast, so wait for the next audio play');
      return;
    }

    // 如果播放间隔超过单次最大播放时长，可认为音频播放完成
    if (currentTime - this.lastPlayTime > PLAY_ONCE_MAX_DURATION) {
      this.isPlaying = false;
    }

    // 执行声音播放
    await this.doPlayAudioOnce(currentTime);

    log.showInfo('playAudioOnce end');
  }

  private async doPlayAudioOnce(currentTime: number): Promise<void> {
    await this.getAudioPlayer();

    if (!this.audioPlayer) {
      log.showWarn('playAudioOnce player invalid : null ');
      return;
    }

    if (this.isPlaying) {
      log.showInfo('isPlaying, waiting...');
      return;
    }
    this.lastPlayTime = currentTime;

    if (this.isFirstPlay) {
      let fdPath = await this.getAudioFd();
      log.showInfo('getAudioFd');

      // 第一次播放，加载音频资源,触发加载完成监听
      this.audioPlayer.load(fdPath.fd, fdPath.offset, fdPath.length).then((soundId_: number) => {
        this.soundId = soundId_;
        log.showInfo('load success, soundId: ' + soundId_);
      }).catch((err: BusinessError) => {
        log.showError('audioPlayer load failed, error message: ' + err.message);
      });
      this.isFirstPlay = false;
    } else {
      if (!this.loadCompleted) {
        log.showInfo('loading, waiting...');
        return;
      }
      // 后续点击直接播放，触发播放完成监听
      this.isPlaying = true;
      this.playAudio();
    }
  }

  private async getAudioPlayer(): Promise<media.SoundPool | null> {
    log.showInfo('getAudioPlayer begin');

    if (this.audioPlayer) {
      log.showInfo('audioPlayer is already exist');
      return this.audioPlayer;
    }

    // 创建一个音频池实例
    await media.createSoundPool(this.maxStreams, this.audioRendererInfo).then((soundPool: media.SoundPool) => {
      if (soundPool != null) {
        this.audioPlayer = soundPool;
        // 开启监听
        this.loadCallback();
        this.finishPlayCallback();
        log.showInfo('create SoundPool success');
      } else {
        log.showError('create SoundPool fail');
      }
    }).catch((error: BusinessError) => {
      log.showError(`soundpool catchCallback, error message:${error.message}`);
    });

    log.showInfo('getAudioPlayer end');
    return this.audioPlayer;
  }

  private async loadCallback(): Promise<void> {
    // 加载完成回调
    (this.audioPlayer as media.SoundPool).on('loadComplete', (soundId_: number) => {
      if (this.isPlaying) {
        return;
      }
      this.isPlaying = true;
      this.loadCompleted = true;
      log.showInfo('load complete, soundId: ' + soundId_);
      // 开始播放
      this.playAudio();
    })
  }

  private async finishPlayCallback(): Promise<void> {
    // 播放完成回调
    (this.audioPlayer as media.SoundPool).on('playFinished', () => {
      log.showInfo('play finished');
      this.isPlaying = false;
    })
  }

  private playAudio(): void {
    (this.audioPlayer as media.SoundPool).play(this.soundId, this.PlayParameters).then((streamId_: number) => {
      log.showInfo('play success, streamId: ' + streamId_);
    }).catch((err: BusinessError) => {
      log.showError('audioPlayer play failed, error message: ' + err.message);
    });
  }

  private async getAudioFd(): Promise<resourceManager.RawFileDescriptor> {
    if (this.pcAudioFd) {
      return this.pcAudioFd;
    }

    log.showInfo('init audio wav file');
    let resourceManager = this.context.resourceManager;
    let rawFileDescriptor: resourceManager.RawFileDescriptor = await resourceManager.getRawFd('volume_adjust.wav');

    log.showInfo('init audio wav file end');
    this.pcAudioFd = rawFileDescriptor;
    return this.pcAudioFd;
  }
}

export { AudioPlayerHelper };