/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { audio } from '@kit.AudioKit';
import { media } from '@kit.MediaKit';
import { BusinessError, osAccount } from '@kit.BasicServicesKit';
import resourceManager from '@ohos.resourceManager';
import { sSettingsUtil} from '@ohos/frameworkwrapper';
import { SettingsKeyConstants } from '@ohos/commonconstants';
import screenLockService from '../screenlock/refactor/ScreenLockService';
import CommonEventManager from '@ohos.commonEventManager';
import type { CommonEventSubscriber } from 'commonEvent/commonEventSubscriber';

const TAG = 'FoldScreenReminder';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const DEFAULT_VOLUME: number = 1.0;
const CREATE_PLAYER_MAX_COUNT: number = 3;

export class FoldScreenReminder {
  private static mInstance: FoldScreenReminder;
  private audioPlayer?: media.AVPlayer = undefined;
  private isPlaying: boolean = false;
  private curSpeed: media.PlaybackSpeed | undefined = undefined;
  private audioManager?: audio.AudioManager = undefined;
  private audioVolumeManager?: audio.AudioVolumeManager = undefined;
  private audioVolumeGroupManager?:audio.AudioVolumeGroupManager = undefined;
  private audioRoutingManager?:audio.AudioRoutingManager = undefined;
  private systemVolume: number | undefined = undefined;
  private mediaVolume: number | undefined = undefined;
  private playFailCount: number = 0;
  private isScreenOn: boolean = true;
  private subscriber: CommonEventSubscriber | undefined = undefined;
  private isForegroundOsAccount: boolean = true;
  private AUDIO_RENDERER_INFO: audio.AudioRendererInfo = {
    usage: audio.StreamUsage.STREAM_USAGE_SYSTEM,
    rendererFlags: 0
  }

  private constructor() {};

  /**
   * 获取实例
   * @returns
   */
  public static getInstance(): FoldScreenReminder {
    if (!FoldScreenReminder.mInstance) {
      FoldScreenReminder.mInstance = new FoldScreenReminder();
    }
    return FoldScreenReminder.mInstance;
  }

  /**
   * 开关提示音
   * @param enabled false为关，true为开
   * @param speed 播放速度
   * @returns
   */
  public async enableAudioPlayer(enabled: boolean, speed: media.PlaybackSpeed | undefined): Promise<void> {
    if (this.audioPlayer === undefined) {
      if (!enabled) {
        this.playFailCount = 0;
      }

      if (this.isScreenOn !== screenLockService.isScreenOn && this.playFailCount >= CREATE_PLAYER_MAX_COUNT) {
        log.showWarn(`reset fail count when screen state change: ${screenLockService.isScreenOn}`);
        this.playFailCount = 0;
        this.isScreenOn = screenLockService.isScreenOn;
      }

      if (this.playFailCount >= CREATE_PLAYER_MAX_COUNT) {
        log.showDebug(`play fail count: ${this.playFailCount}`);
        this.isScreenOn = screenLockService.isScreenOn;
        return;
      }

      if (enabled) {
        this.createAudioPlayer();
      }
    }

    if (this.isPlaying && enabled && this.curSpeed !== speed && speed !== undefined) {
      log.showInfo(`set speed: ${speed}`);
      this.audioPlayer?.setSpeed(speed);
      this.curSpeed = speed;
      return;
    }

    if (this.isPlaying === enabled && this.curSpeed === speed) {
      return;
    }

    if (!this.isPlaying && !this.getScreenClosedWarningToneSwitchState()) {
      return;
    }
    if (!this.isForegroundOsAccount && enabled) { return; }

    log.showInfo(`enableAudioPlayer enabled: ${enabled}, speed:${speed}`);

    if (enabled && speed != undefined) {
      await this.prepareAudioPlayer(speed);
    } else {
      await this.stopAudioPlayer();
    }
  }

  /**
   * 创建AudioPlayer
   * @returns
   */
  public async createAudioPlayer(): Promise<void> {
    if (this.audioPlayer !== undefined) {
      return;
    }
    log.showInfo(`createAudioPlayer`);
    try {
      this.audioPlayer = await media.createAVPlayer();
      this.setAudioPlayerFdSrc();
      this.startPlayerStateListener(this.audioPlayer);
      if (this.audioVolumeGroupManager === undefined) {
        this.getAudioVolumeManager();
      }
      this.curSpeed = undefined;
      this.subscribeUserSwitched();
      this.updateForegroundOsAccount();
    } catch (err) {
      log.showError(`create error, code:${err?.code}, message:${err?.message}`);
      this.audioPlayer?.release();
    }
  }

  /**
   * 释放avplayer
   */
  public releaseAudioPlayer(): void {
    try {
      log.showInfo(`releaseAudioPlayer`);
      this.recoverVolume();
      this.audioPlayer?.release();
      this.isPlaying = false;
      this.curSpeed = undefined;
      this.unsubscribeUserSwitched();
    } catch (err) {
      log.showError(`release error, code:${err?.code}, message:${err?.message}`);
    }
  }

  private async subscribeUserSwitched(): Promise<void> {
    if (this.subscriber !== undefined) { return; }
    let subscribeInfo: CommonEventManager.CommonEventSubscribeInfo = {
      events: [CommonEventManager.Support.COMMON_EVENT_USER_SWITCHED]
    };
    try {
      this.subscriber = await CommonEventManager.createSubscriber(subscribeInfo);
      CommonEventManager.subscribe(this.subscriber, async (err, data: CommonEventManager.CommonEventData) => {
        if (err && err?.code !== 0) { return; }
        this.updateForegroundOsAccount();
      });
    } catch (err) {
      log.showError(`subscribeUserSwitched, code:${err?.code}, message:${err?.message}`);
    }
  }

  private async unsubscribeUserSwitched(): Promise<void> {
    if (this.subscriber === undefined) { return; }
    try {
      CommonEventManager.unsubscribe(this.subscriber);
      this.subscriber = undefined;
    } catch (err) {
      log.showError(`unsubscribeUserSwitched, code:${err?.code}, message:${err?.message}`);
    }
  }

  private async updateForegroundOsAccount(): Promise<void> {
    try {
      let accountManager: osAccount.AccountManager = osAccount.getAccountManager();
      let localId: number = await accountManager.getOsAccountLocalId();
      let foregroundLocalId: number = await accountManager.getForegroundOsAccountLocalId();
      this.isForegroundOsAccount = (localId === foregroundLocalId);
      log.showInfo(`isForegroundOsAccount result:${this.isForegroundOsAccount}, localId:${localId}`);
    } catch (err) {
      log.showError(`updateForegroundOsAccount, code:${err?.code}, message:${err?.message}`);
    }
  }

  private async prepareAudioPlayer(speed: media.PlaybackSpeed): Promise<void> {
    this.isPlaying = true;
    await this.audioPlayer?.prepare().then(() => {
      this.setVolumeMax();
      this.audioPlayer?.setSpeed(speed);
      this.curSpeed = speed;
    }).catch((err: BusinessError) => {
      log.showError(`prepare error, code:${err?.code}, message:${err?.message}`);
      this.releaseAudioPlayer();
      this.isPlaying = false;
    });
  }

  private async stopAudioPlayer(): Promise<void> {
    this.isPlaying = false;
    this.curSpeed = undefined;
    this.recoverVolume();
    await this.audioPlayer?.stop().then().catch((err: BusinessError) => {
      log.showError(`stop error, code:${err?.code}, message:${err?.message}`);
    });
  }


  /**
   * 判断是否播放对应速率的音频
   * @param speed 播放速率
   * @returns
   */
  public isWarningTonePlaying(speed: media.PlaybackSpeed): boolean {
    return this.isPlaying && speed === this.curSpeed;
  }

  private getAudioVolumeManager(): void {
    try {
      this.audioManager = audio.getAudioManager();
      this.audioVolumeManager = this.audioManager?.getVolumeManager();
      this.audioVolumeGroupManager = this.audioVolumeManager?.getVolumeGroupManagerSync(audio.DEFAULT_VOLUME_GROUP_ID);
      this.audioRoutingManager = this.audioManager?.getRoutingManager();
    } catch (err) {
      log.showError(`getAudioVolumeManager error, code:${err?.code}, message:${err?.message}`);
    }
  }

  private async isSpeaker(): Promise<boolean> {
    let desc: audio.AudioDeviceDescriptors | undefined =
      await this.audioRoutingManager?.getPreferOutputDeviceForRendererInfo(this.AUDIO_RENDERER_INFO);
    if (desc !== undefined && desc.length > 0) {
      return desc[0].deviceType == audio.DeviceType.SPEAKER;
    }
    return true;
  }

  private async setVolumeMax(): Promise<void> {
    this.mediaVolume = undefined;
    this.systemVolume = undefined;
    if (this.audioVolumeGroupManager === undefined) {
      this.getAudioVolumeManager();
    }

    let isSpeaker: boolean = await this.isSpeaker();

    if (!isSpeaker) {
      log.showInfo(`not seaker`);
      return;
    }

    try {
      log.showInfo(`start set volume`);
      let currentMediaVolume = this.audioVolumeGroupManager?.getVolumeSync(audio.AudioVolumeType.MEDIA);
      if (currentMediaVolume === 0) {
        await this.audioVolumeGroupManager?.setVolume(audio.AudioVolumeType.MEDIA, 1);
        this.mediaVolume = 0;
      }

      let volumeType = 6;
      let currentSystemVolume: number | undefined = this.audioVolumeGroupManager?.getVolumeSync(volumeType);
      let maxVolume = this.audioVolumeGroupManager?.getMaxVolumeSync(volumeType);
      if (currentSystemVolume !== maxVolume) {
        await this.audioVolumeGroupManager?.setVolume(volumeType, maxVolume);
        this.systemVolume = currentSystemVolume;
      }
    } catch (err) {
      log.showError(`setVolumeMax error, code:${err?.code}, message:${err?.message}`);
    }
  }

  private async recoverVolume(): Promise<void> {
    try {
      let volumeType = 6;
      let currentSystemVolume: number | undefined =
        this.audioVolumeGroupManager?.getVolumeSync(volumeType);
      let currentMediaVolume: number | undefined =
        this.audioVolumeGroupManager?.getVolumeSync(audio.AudioVolumeType.MEDIA);
      let maxVolume = this.audioVolumeGroupManager?.getMaxVolumeSync(volumeType);

      // recover system volume
      if (((this.systemVolume !== maxVolume && currentSystemVolume === maxVolume) || currentMediaVolume === 0) &&
        this.systemVolume !== undefined) {
        log.showInfo(`recover system volume: ${this.systemVolume}`);
        await this.audioVolumeGroupManager?.setVolume(volumeType, this.systemVolume);
      }

      // recover media volume
      if (this.mediaVolume === 0 && currentMediaVolume === 1) {
        log.showInfo(`recover media volume: ${this.mediaVolume}`);
        await this.audioVolumeGroupManager?.setVolume(audio.AudioVolumeType.MEDIA, 0);
      }
    } finally {
      this.systemVolume = undefined;
      this.mediaVolume = undefined;
    }
  }

  private async setAudioPlayerFdSrc(): Promise<void> {
    if (this.audioPlayer === undefined) {
      log.showError(`setAudioPlayerFdSrc, player is undefined`);
      return;
    }

    try {
      let fileDescriptor: resourceManager.RawFileDescriptor =
        await getContext(this).resourceManager.getRawFd('screen_closed_warning_tone.wav');
      log.showInfo(`useInnerRing fd:${fileDescriptor.fd}`);
      let avFileDescriptor: media.AVFileDescriptor = {
        fd: fileDescriptor.fd,
        offset: fileDescriptor.offset,
        length: fileDescriptor.length,
      };
      this.audioPlayer.fdSrc = avFileDescriptor;
    } catch (err) {
      log.showError(`setAudioPlayerFdSrc error, code:${err?.code}, message:${err?.message}`);
    } finally {
      getContext(this).resourceManager.closeRawFd('screen_closed_warning_tone.wav');
    }
  }

  /**
   * 监听播放器状态
   * @param player 播放器
   */
  private startPlayerStateListener(player: media.AVPlayer): void {
    if (player === undefined) {
      return;
    }
    player.on('stateChange', async (state) => {
      log.showInfo(TAG, 'audioStateHandle stateChange:' + state);
      switch (state) {
        case 'idle':
        case 'stopped':
          this.isPlaying = false;
          break;
        case 'initialized':
          player.audioRendererInfo = this.AUDIO_RENDERER_INFO;
          break;
        case 'prepared':
          player.loop = true;
          player.setVolume(DEFAULT_VOLUME);
          player.play();
          break;
        case 'playing':
          this.isPlaying = true;
          break;
        case 'completed':
        case 'paused':
          player.loop = true;
          this.isPlaying = false;
          this.enableAudioPlayer(true, this.curSpeed);
          break;
        case 'released':
          this.isPlaying = false;
          this.audioPlayer = undefined;
          this.curSpeed = undefined;
          this.systemVolume = undefined;
          this.mediaVolume = undefined;
          this.playFailCount++;
          break;
        case 'error':
          this.releaseAudioPlayer();
          this.isPlaying = false;
          break;
        default:
          log.showError(TAG, 'unknown state: ' + state);
      }
    });

    player.on('error', async (error: BusinessError) => {
      log.showError(`avPlayer failed, code is ${error.code}, message is ${error.message}`);
      this.isPlaying = false;
    });

    player.on('audioInterrupt', async (interruptEvent: audio.InterruptEvent) => {
      this.handleAudioInterruptEvent(interruptEvent);
    });
  }

  private handleAudioInterruptEvent(interruptEvent: audio.InterruptEvent): void {
    log.showError('audioInterrupt:' + JSON.stringify(interruptEvent));
    if (interruptEvent.forceType === audio.InterruptForceType.INTERRUPT_FORCE) {
      switch (interruptEvent.hintType) {
        case audio.InterruptHint.INTERRUPT_HINT_PAUSE:
        case audio.InterruptHint.INTERRUPT_HINT_STOP:
          this.releaseAudioPlayer();
          this.isPlaying = false;
          break;
        default:
          break;
      }
    } else if (interruptEvent.forceType === audio.InterruptForceType.INTERRUPT_SHARE) {
      switch (interruptEvent.hintType) {
        case audio.InterruptHint.INTERRUPT_HINT_RESUME:
          this.isPlaying = false;
          this.enableAudioPlayer(true, this.curSpeed);
          break;
        default:
          break;
      }
    }
  }

  private getScreenClosedWarningToneSwitchState(): boolean {
    let switchState: boolean = true;
    try {
      let value = sSettingsUtil.getSystemValue(SettingsKeyConstants.SCREEN_CLOSED_WARNING_TONE_SWITCH, 'true');
      log.showDebug(`getScreenClosedWarningToneSwitchState: ${value}`);
      switchState = (value === 'true');
    } catch (err) {
      log.showError(`getScreenClosedWarningToneSwitchState error, code:${err?.code}, message:${err?.message}`);
    }
    return switchState;
  }
}