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

import media from '@ohos.multimedia.media';
import audio from '@ohos.multimedia.audio';
import fs from '@ohos.file.fs';
import {
  CommonUtils,
  LogDomain, LogHelper,
  SingletonHelper
} from '@ohos/basicutils';
import { CustomPromise, GlobalContext } from '@ohos/frameworkwrapper';
import type { BusinessError } from '@ohos.base';
import configPolicy from '@ohos.configPolicy';
import systemSoundManager from '@ohos.multimedia.systemSoundManager';
import {
  RemindNotificationErrorCode,
  RemindNotificationMaintenance,
  RemindNotificationMaintenanceExt} from '../maintenance/RemindNotificationMaintenance';
import { LogWithHa } from '../maintenance/CommonExceptionMaintenance';
import { CommonExceptionCode } from '../maintenance/CommonExceptionCode';

const TAG = "SysUI_AudioUtils";
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const sleep = (delay: number): Promise<number> => new Promise((resolve) => setTimeout(resolve, delay));

/**
 * fd前缀
 */
const PRE_FD = "fd://";

/**
 * file前缀
 */
const PRE_FILE = "file:/";

/**
 * 铃声播放间隔时长
 */
const TIMEOUT_DURATION = 1000;

/**
 * 对应档位的轻提醒音量
 */
export const WEAK_VOLUME_ARR: number[] =
  [0, 1.00, 1.00, 1.00, 0.90, 0.75, 0.65, 0.55, 0.45, 0.40, 0.35, 0.30, 0.25, 0.25, 0.20, 0.20];

/**
 * 振动特性
 */
enum ToneHapticsFeature {
  /**
   * 正常
   */
  STANDARD = 0,
  /**
   * 弱振
   */
  GENTLE = 1,
}

/**
 * 系统通知铃声振动播放器
 */
interface CustomPlayer extends systemSoundManager.SystemTonePlayer {
  /**
   * 设置音量
   */
  setAudioVolumeScale(scale: number): void;

  /**
   * 获取支持的振动特性
   */
  getSupportedHapticsFeatures(): Promise<Array<ToneHapticsFeature>>;

  /**
   * 设置振动特性
   */
  setHapticsFeature(hapticsFeature: ToneHapticsFeature): void;
}

/**
 * 创建播放器入参
 */
interface AudioParam {
  /**
   * 播放器回收回调
   */
  onRelease?: () => void;
}

export interface PlayParams {
  isAudioMute: boolean,
  isHapticsMute: boolean,
  systemToneType: number,
  canBreak?: boolean,
  maintenanceInfo?: RemindNotificationMaintenanceExt,
};

/**
 * 音频播放
 *
 * @since 2023-01-18
 */
class AudioUtils {
  /**
   * 当前是否正在播放
   */
  private isMediaPlaying: boolean = false;

  /**
   * 当前是否正在播放
   */
  private isSysTonePlaying: boolean = false;

  /**
   * 当前是否正在播放振动
   */
  public isVibratePlaying: boolean = false;

  /**
   * 是否能被打断
   */
  private canBreak?: boolean;

  /**
   * 当前播放ID
   */
  private tonePlayingId?: number;

  /**
   * 播放完整性promise，系统铃声需播放完整才能被打断
   */
  private playCompletePromise?: CustomPromise<void>;

  /**
   * 播放通知铃声
   *
   * @param src 音频文件路径
   */
  playNtfAudio(src: string): void {
    log.showInfo('PlayNtfAudio.');
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
   * 播放系统铃声和振动
   *
   * @param isAudioMute 是否静音
   * @param isHapticsMute 是否禁振动
   * @param systemToneType 播放器类型
   * @param isWeak 是否轻提醒
   * @param canBreak 本次播放是否能被打断，自定义铃声播放时附带的短震可被打断
   */
  async playToneAndVibration(param: PlayParams): Promise<void> {
    log.showWarn(`playToneAndVibration, ${param.isAudioMute}, ${param.isHapticsMute}, ${param.canBreak}`);
    // 不打断铃声
    if (this.isSysTonePlaying && !this.canBreak) {
      log.showWarn('Notification tone is playing.');
      RemindNotificationMaintenance.get().reportRemind(RemindNotificationErrorCode.SYS_IS_PLAYING, undefined, param.maintenanceInfo);
      return;
    }
    // 标识播放中
    this.isSysTonePlaying = true;
    this.canBreak = param.canBreak;
    // 临时规避措施： 标识当前是否有系统振动，
    // 1s后设置振动标志位为false，用于长振动时判断当前是否有系统振动，避免1s内来长振动时驱动丢振
    this.isVibratePlaying = param.isHapticsMute ? false : true;
    setTimeout(() => {
      this.isVibratePlaying = false;
    }, 1000);
    // 不可被打断的播放，设置完整播放的promise
    if (!this.canBreak) {
      this.playCompletePromise = this.getPlayCompletePromise();
    }
    await this.startToneAndVibration(param);
    this.playCompletePromise?.resolve();
    this.playCompletePromise = undefined;
  }

  /**
   * 若系统铃声正在播放，需要等待系统铃声完整播放才能打断
   * @returns
   */
  public async waitForPlayComplete(): Promise<void> {
    if (this.playCompletePromise) {
      await this.playCompletePromise;
    }
  }

  private getPlayCompletePromise(): CustomPromise<void> {
    const promise = new CustomPromise<void>();
    setTimeout(() => {
      promise.resolve();
    }, 1500);
    return promise;
  }

  /**
   * 初始化播放器
   *
   * @param param 播放器参数
   * @returns 播放器
   */
  private async initAudioRenderer(param?: AudioParam): Promise<media.AVPlayer> {
    try {
      let audioRendererInfo: audio.AudioRendererInfo = {
        content: audio.ContentType.CONTENT_TYPE_UNKNOWN,
        usage: audio.StreamUsage.STREAM_USAGE_NOTIFICATION,
        rendererFlags: 0
      };
      let audioMedia = await media.createAVPlayer();
      if (CommonUtils.isInvalid(audioMedia)) {
        log.showWarn('audioMedia is null as createAVPlayer fail.');
        return undefined;
      }
      audioMedia.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
        switch (state) {
          case 'idle': // 成功调用reset接口后触发该状态机上报
            log.showDebug('AVPlayer state idle called.');
            audioMedia?.release(); // 调用release接口销毁实例对象
            break;
          case 'initialized': // avplayer 设置播放源后触发该状态上报
            log.showDebug('AVPlayer state initialized called.');
            if (audioMedia) {
              audioMedia.audioRendererInfo = audioRendererInfo;
            }
            audioMedia?.prepare();
            break;
          case 'prepared': // prepare调用成功后上报该状态机
            log.showDebug('AVPlayer state prepared called.');
            audioMedia?.play(); // 调用播放接口开始播放
            break;
          case 'playing': // play成功调用后触发该状态机上报
            log.showDebug('AVPlayer state playing called.');
            break;
          case 'paused': // pause成功调用后触发该状态机上报
            log.showDebug('AVPlayer state paused called.');
            audioMedia?.stop();
            break;
          case 'completed': // 播放结束后触发该状态机上报
            log.showDebug('AVPlayer state completed called.');
            audioMedia?.stop(); //调用播放结束接口
            break;
          case 'stopped': // stop接口成功调用后触发该状态机上报
            log.showDebug('AVPlayer state stopped called.');
            audioMedia?.reset(); // 调用reset接口初始化avplayer状态
            break;
          case 'released':
            log.showDebug('AVPlayer state released called.');
            param?.onRelease?.();
            break;
          default:
            log.showWarn('AVPlayer state unknown called.');
            break;
        }
      });
      audioMedia?.on('error', (error: BusinessError) => {
        log.error('play error code:' + error?.code + ', message:' + error?.message);
        audioMedia?.reset();
      });
      return audioMedia;
    } catch (error) {
      log.error('initAudioRenderer error code:' + error?.code + ', message:' + error?.message);
    }
    return undefined;
  }

  /**
   * 开启铃声播放准备
   *
   * @param src 铃声文件路径
   * @returns void
   */
  private async startPrePlay(src: string): Promise<void> {
    // 创建播放器后，ID不匹配则直接释放
    let param: AudioParam = {};
    let audio = await this.initAudioRenderer(param);
    if (CommonUtils.isInvalid(audio)) {
      log.showInfo('startPrePlay audio create fail. ');
      this.isMediaPlaying = false;
      return;
    }

    // 正常播放
    let file: fs.File | undefined;
    try {
      let path = await configPolicy.getOneCfgFile(src);
      file = await fs.open(this.getAudioFilePath(path));
      // 注册回调
      param.onRelease = (): void => {
        this.isMediaPlaying = false;
      };
      // 开始播放
      if (audio) {
        audio.url = PRE_FD + file.fd;
      }
    } catch (e) {
      let err = e as BusinessError;
      log.error('startPrePlay err: ' + err?.message);
      // 释放播放器
      audio?.release();
      this.isMediaPlaying = false;
    } finally {
      // 关闭文件流
      if (file) {
        fs.close(file);
      }
    }
  }

  private async startToneAndVibration(param: PlayParams): Promise<void> {
    let sysNtfPlay: CustomPlayer;

    try {
      let sysSoundMgr: systemSoundManager.SystemSoundManager = systemSoundManager.getSystemSoundManager();
      sysNtfPlay = await sysSoundMgr?.getSystemTonePlayer(GlobalContext.getContext(), param.systemToneType) as CustomPlayer;
      await sysNtfPlay?.prepare();

      if (CommonUtils.isNumber(this.tonePlayingId)) {
        await sysNtfPlay?.stop(this.tonePlayingId);
        log.showInfo(`ntf sound player stopped`);
      }
      this.tonePlayingId = await sysNtfPlay?.start({ muteAudio: param.isAudioMute, muteHaptics: param.isHapticsMute });
      log.showWarn('startToneAndVibration result: ' + this.tonePlayingId + ', ' + param.isAudioMute + ', ' + param.isHapticsMute +
        ', ' + param.systemToneType);
      RemindNotificationMaintenance.get().reportRemind(undefined, undefined, param.maintenanceInfo);
      // 铃声播放间隔时长后置位
      await sleep(TIMEOUT_DURATION);
    } catch (e) {
      let err = e as BusinessError;
      log.error('startToneAndVibration err: ' + err?.message);
      RemindNotificationMaintenance.get().reportRemind(RemindNotificationErrorCode.SYS_PLAY_ERROR, e, param.maintenanceInfo);
    } finally {
      this.isSysTonePlaying = false;
      await sysNtfPlay?.release();
    }
  }

  private async setAudioWeakModeIfNecessary(player?: CustomPlayer): Promise<void> {
    let audioManager = audio.getAudioManager();
    let valueVolume: number = await audioManager.getVolume(audio.AudioVolumeType.RINGTONE);
    let weakVolume: number = WEAK_VOLUME_ARR[valueVolume];
    log.showInfo(`setAudioWeakModeIfNecessary: valueVolume=${valueVolume}, volume =${weakVolume}`);

    try {
      // 调用媒体接口设置音量
      player?.setAudioVolumeScale(weakVolume);

      // 查询支持的振动特性
      let hapticsArr : Array<ToneHapticsFeature> = await player?.getSupportedHapticsFeatures();
      if (!hapticsArr || hapticsArr.length === 0) {
        log.showInfo(`unsupport any hapticsFeature`);
        return;
      }

      // 标准
      player?.setHapticsFeature(ToneHapticsFeature.STANDARD);
      for (let feature of hapticsArr) {
        log.showInfo(`hapticsArr feature=${feature}`);
        if (feature === ToneHapticsFeature.GENTLE) {
          // 弱振
          player?.setHapticsFeature(ToneHapticsFeature.GENTLE);
        }
      }
    } catch (error) {
      LogWithHa.error(log, `setAudioWeakModeIfNecessary error code: ${error?.code}, message: ${error?.message}`,
        CommonExceptionCode.SET_WEAK_FAIL);
    }
  }

  /**
   * 截取音频文件路径
   * 有file前缀则去掉
   *
   * @param oriSrc 原路径
   * @return 截取后路径
   */
  private getAudioFilePath(oriSrc: string): string {
    return oriSrc.replace(PRE_FILE, '');
  }
}

// 单例
export let AudioUtil: AudioUtils = SingletonHelper.getInstance(AudioUtils, TAG);