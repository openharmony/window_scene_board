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
import { BusinessError } from '@ohos.base';
import Media from '@ohos.multimedia.media';
import Audio from '@ohos.multimedia.audio';
import resourceManager from '@ohos.resourceManager';
import type abilityCommon from '@ohos.app.ability.common';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { CommonUtils } from '@ohos/basicutils/src/main/ets/utils/CommonUtils';

const TAG = 'ScreenLockPromptTone';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

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

  private rawFilePath?: string;
  private rawFileRm?: resourceManager.ResourceManager;

  /**
   * 解析用于 rawfile 的 ResourceManager。
   * GlobalContext.getContext() 依赖 MainAbility/SystemUI 等注入 globalThis.mContext，早于注入或竞态时可能为空；
   * 与桌面等逻辑一致，再尝试 desktopContext；最后回退 ApplicationContext。
   */
  private resolveResourceManager(): resourceManager.ResourceManager | undefined {
    log.showInfo('resolveResourceManager start');
    const host = GlobalContext.getContext();
    log.showInfo(`resolveResourceManager host:${host == null} resourceManager:${host?.resourceManager == null}`);
    if (host?.resourceManager) {
      log.showInfo(`resolveResourceManager from host`);
      return host.resourceManager;
    }
    const desktop = GlobalContext.getInstance().getObject('desktopContext') as abilityCommon.ServiceExtensionContext | undefined;
    if (desktop?.resourceManager) {
      log.showInfo(`resolveResourceManager from desktop`);
      return desktop.resourceManager;
    }
    try {
      const base: abilityCommon.ServiceExtensionContext | undefined = host ?? desktop;
      log.showInfo(`resolveResourceManager from base`);
      return base?.getApplicationContext()?.resourceManager;
    } catch {
      log.showInfo(`resolveResourceManager is undefined`);
      return undefined;
    }
  }

  /**
   * 播放提示音
   *
   * @param src 模块 rawfile 下相对路径，例如 media/audio/ui/Lock.ogg
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
          audioMedia?.reset(); // 调用reset接口初始化avplayer状态
          break;
        case 'released':
          log.showInfo('AVPlayer state released called.');
          param?.onRelease?.();
          break;
        default:
          log.showWarn('AVPlayer state unknown called.');
          break;
      }
    });
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
   * 开启提示音播放准备（bundle rawfile 资源）
   *
   * @param src 提示音在 rawfile 目录下的相对路径
   * @returns void
   */
  protected async startPrePlay(src: string): Promise<void> {
    let rm: resourceManager.ResourceManager | undefined = this.resolveResourceManager();
    if (!rm) {
      log.showError('startPrePlay resourceManager unavailable (GlobalContext / desktopContext / application).');
      this.isMediaPlaying = false;
      return;
    }
    // 创建播放器后，ID不匹配则直接释放
    let param: AudioParam = {};
    let audio = await this.initAudioRenderer(param);
    if (CommonUtils.isInvalid(audio)) {
      log.showInfo('startPrePlay audio create fail.');
      this.isMediaPlaying = false;
      return;
    }
    try {
      let fileDescriptor: resourceManager.RawFileDescriptor = await rm.getRawFd(src);
      log.showInfo(`audio play rawfile fd = ${fileDescriptor.fd}`);
      if (!fileDescriptor || fileDescriptor.fd <= 0 || (fileDescriptor.length !== undefined && fileDescriptor.length <= 0)) {
        log.showError(`startPrePlay invalid rawfile descriptor, fd=${fileDescriptor?.fd}, length=${fileDescriptor?.length}`);
        audio?.release();
        this.isMediaPlaying = false;
        try {
          rm.closeRawFd(src);
        } catch (closeErr) {
          log.showWarn(`closeRawFd fail: ${(closeErr as BusinessError)?.message}`);
        }
        return;
      }

      // keep fd alive until player released
      this.rawFilePath = src;
      this.rawFileRm = rm;
      param.onRelease = (): void => {
        try {
          if (this.rawFileRm && this.rawFilePath) {
            this.rawFileRm.closeRawFd(this.rawFilePath);
          }
        } catch (closeErr) {
          log.showWarn(`closeRawFd onRelease fail: ${(closeErr as BusinessError)?.message}`);
        } finally {
          this.rawFilePath = undefined;
          this.rawFileRm = undefined;
          this.isMediaPlaying = false;
        }
      };
      if (audio) {
        let avFileDescriptor: Media.AVFileDescriptor = {
          fd: fileDescriptor.fd,
          offset: fileDescriptor.offset,
          length: fileDescriptor.length
        };
        audio.fdSrc = avFileDescriptor;
      }
    } catch (e) {
      let err = e as BusinessError;
      log.error(`startPrePlay err: ${err?.message}`);
      audio?.release();
      this.isMediaPlaying = false;
    }
  }
}
