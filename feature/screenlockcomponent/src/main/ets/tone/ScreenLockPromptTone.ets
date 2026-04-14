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
import configPolicy from '@ohos.configPolicy';
import { BusinessError } from '@ohos.base';
import Media from '@ohos.multimedia.media';
import Audio from '@ohos.multimedia.audio';
import FileIo from '@ohos.file.fs';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { CommonUtils } from '@ohos/basicutils/src/main/ets/utils/CommonUtils';

const TAG = 'ScreenLockPromptTone';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * fd前缀
 */
const PRE_FD = 'fd://';

/**
 * file前缀
 */
const PRE_FILE = 'file:/';

/**
 * 创建播放器入参
 */
export interface AudioParam {
  /**
   * 播放器回收回调
   */
  onRelease?: () => void;
}

/**
 * 锁屏提示音播放器
 */
export class ScreenLockPromptTone {
  /**
   * 当前是否正在播放
   */
  private isMediaPlaying: boolean = false;

  private file?: FileIo.File;

  /**
   * 播放提示音
   *
   * @param src 音频文件路径
   * @return void
   */
  public playNtfAudio(src: string): void {
    // 不支持打断正在播放中的通知铃声
    if (this.isMediaPlaying) {
      log.showDebug('Notification audio is playing.');
      return;
    }
    // 标识播放中
    this.isMediaPlaying = true;
    this.startPrePlay(src);
  }

  /**
   * 初始化播放器
   *
   * @param param 播放器参数
   * @returns 播放器
   */
  protected async initAudioRenderer(param?: AudioParam): Promise<Media.AVPlayer | undefined> {
    try {
      let audioRendererInfo: Audio.AudioRendererInfo = {
        content: Audio.ContentType.CONTENT_TYPE_UNKNOWN,
        usage: Audio.StreamUsage.STREAM_USAGE_SYSTEM,
        rendererFlags: 0
      };
      let audioMedia = await Media.createAVPlayer();
      if (CommonUtils.isInvalid(audioMedia)) {
        log.showWarn('audioMedia is null as createAVPlayer fail.');
        return undefined;
      }
      this.audioMediaOnStateChange(audioMedia, audioRendererInfo, param);
      this.audioMediaOnError(audioMedia);
      return audioMedia;
    } catch (error) {
      log.error('initAudioRenderer error');
    }
    return undefined;
  }

  /**
   * 播放器播放状态监听
   *
   * @param audioMedia
   * @param audioRendererInfo
   * @param param
   */
  protected audioMediaOnStateChange(audioMedia: Media.AVPlayer, audioRendererInfo: Audio.AudioRendererInfo,
    param?: AudioParam): void {
    audioMedia.on('stateChange', async (state: string, reason: Media.StateChangeReason) => {
      switch (state) {
        case 'idle': // 成功调用reset接口后触发该状态机上报
          log.showInfo('AVPlayer state idle called.');
          audioMedia?.release(); // 调用release接口销毁实例对象
          break;
        case 'initialized': // avplayer 设置播放源后触发该状态上报
          log.showInfo('AVPlayer state initialized called.');
          if (audioMedia) {
            audioMedia.audioRendererInfo = audioRendererInfo;
          }
          audioMedia?.prepare();
          break;
        case 'prepared': // prepare调用成功后上报该状态机
          log.showInfo('AVPlayer state prepared called.');
          audioMedia?.play(); // 调用播放接口开始播放
          break;
        case 'playing': // play成功调用后触发该状态机上报
          log.showInfo('AVPlayer state playing called.');
          break;
        case 'paused': // pause成功调用后触发该状态机上报
          log.showInfo('AVPlayer state paused called.');
          audioMedia?.stop();
          break;
        case 'completed': // 播放结束后触发该状态机上报
          log.showInfo('AVPlayer state completed called.');
          audioMedia?.stop(); //调用播放结束接口
          break;
        case 'stopped': // stop接口成功调用后触发该状态机上报
          log.showInfo('AVPlayer state stopped called.');
          // 关闭文件流
          this.closeAudioFile();
          audioMedia?.reset(); // 调用reset接口初始化avplayer状态
          break;
        case 'released':
          log.showInfo('AVPlayer state released called.');
          this.closeAudioFile();
          param?.onRelease?.();
          break;
        default:
          log.showWarn('AVPlayer state unknown called.');
          break;
      }
    });
  }

  private closeAudioFile(): void {
    if (this.file) {
      FileIo.close(this.file);
      this.file = undefined;
    }
  }

  /**
   * 播放器error状态监听
   *
   * @param audioMedia
   */
  protected audioMediaOnError(audioMedia: Media.AVPlayer):void {
    audioMedia?.on('error', (error: BusinessError) => {
      log.error('play error:', error);
      audioMedia?.reset();
    });
  }

  /**
   * 开启提示音播放准备
   *
   * @param src 提示音文件路径
   * @returns void
   */
  protected async startPrePlay(src: string): Promise<void> {
    // 创建播放器后，ID不匹配则直接释放
    let param: AudioParam = {};
    let audio = await this.initAudioRenderer(param);
    if (CommonUtils.isInvalid(audio)) {
      log.showInfo('startPrePlay audio create fail.');
      this.isMediaPlaying = false;
      return;
    }
    // 正常播放
    try {
      let path = await configPolicy.getOneCfgFile(src);
      this.file = await FileIo.open(this.getAudioFilePath(path));
      log.showInfo(`audio play file = ${this.file.fd}`);
      // 注册回调
      param.onRelease = (): void => {
        this.isMediaPlaying = false;
      };
      // 开始播放
      if (audio) {
        audio.url = PRE_FD + `${this.file.fd}`;
      }
    } catch (e) {
      let err = e as BusinessError;
      log.error(`startPrePlay err: ${err?.message}`);
      // 释放播放器
      audio?.release();
      this.isMediaPlaying = false;
      this.closeAudioFile();
    }
  }

  /**
   * 截取音频文件路径，有file前缀则去掉
   *
   * @param oriSrc 原路径
   * @return 截取后路径
   */
  protected getAudioFilePath(oriSrc: string): string {
    return oriSrc.replace(PRE_FILE, '');
  }
}
