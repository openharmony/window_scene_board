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
import { BusinessError } from '@ohos.base';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CustomPromise } from '@ohos/frameworkwrapper';
import { AudioUtil, NotificationSysEventReporter } from '@ohos/systemuicommon';
import audio from '@ohos.multimedia.audio';
import NotificationVibratorManager from '../manager/NotificationVibratorManager';
import {
  RemindNotificationErrorCode,
  RemindNotificationMaintenance,
  RemindNotificationMaintenanceExt
} from '@ohos/systemuicommon/src/main/ets/maintenance/RemindNotificationMaintenance';
import { systemDateTime } from '@kit.BasicServicesKit';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import { NotificationExceptionCode } from '../maintenance/NotificationExceptionCode';
import { WEAK_VOLUME_ARR } from '@ohos/systemuicommon/src/main/ets/utils/AudioUtils';
import {
  DEFAULT_PLAY_TIME,
  PlayerType,
  PlayingParam,
  PlayRemindParam,
  StopParam,
  StopReason
} from '../remind/RemindConstant';
import { BasePlayer } from '../remind/BasePlayer';
import { SysTonePlayer } from '../remind/SysTonePlayer';
import { SysTonePlayerInstanceManager } from '../remind/SysTonePlayerInstanceManager';
import { NotificationFlashReminder } from '../manager/NotificationFlashReminder';

const TAG = 'SysUI_NotificationReminder';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

enum ReportStatus {
  COMPLETE = 0,
  INTERRUPT = 1,
  NOT_EXIST = 2,
  ERROR = 3,
  RELEASE = 4,
  STOPPED = 5,
}

export class NotificationReminder implements BasePlayer {
  private static readonly MAX_PLAY_TIME: number = 60000;

  private static readonly TIMEOUT = 2000;

  private reportStatus: number; // 打点状态变量
  private ringParams?: PlayRemindParam; // 铃声和振动参数存储Map
  private playerPromise?: Promise<media.AVPlayer | undefined>;
  private playingParams: PlayingParam = new PlayingParam(); // 播放时参数
  private maintenanceInfo?: RemindNotificationMaintenanceExt; // 打点维测信息
  private systemPlayer?: SysTonePlayer;
  private flashPlayer?: NotificationFlashReminder;

  /**
   * 每一次play都设置一个promise，表示player准备工作完成，可以播放或者被下一次播放打断
   */
  private prepareFinishPromise?: CustomPromise<void>;
  public readonly type: PlayerType;

  constructor(type: PlayerType) {
    this.type = type;
    this.reportStatus = -1;
  }

  private async getPlayer(needReCreate: boolean = false): Promise<media.AVPlayer | undefined> {
    try {
      if (this.playerPromise && !needReCreate) {
        return await this.playerPromise;
      }
      if (needReCreate) {
        log.showInfo('reCreate player, release old');
        const oldPlayer = await this.playerPromise;
        await this.releaseOldPlayer(oldPlayer);
      }
      this.playerPromise = this.getPlayerWithTimeout(NotificationReminder.TIMEOUT);
      return await this.playerPromise;
    } catch (e) {
      RemindNotificationMaintenance.get().addError(RemindNotificationErrorCode.GET_AVPLAYER_ERROR);
      LogWithHa.error(log, `[${this.type}] avplayer create error, code is ${e?.code}, message is ${e?.message}`,
        NotificationExceptionCode.GET_AVPLAYER_FAIL, e);
      this.playerPromise = undefined;
    }
    return undefined;
  }

  public async getPlayerWithTimeout(time: number): Promise<media.AVPlayer | undefined> {
    let isTimeout: boolean = false;
    let timer: number | undefined;
    const createPromise = media.createAVPlayer().then((avPlayer) => {
      log.showInfo(`[${this.type}] create player callback, isTimeout ${isTimeout}`);
      if (isTimeout) {
        avPlayer.release();
        return undefined;
      }
      return avPlayer;
    });

    const timeoutPromise = new Promise<media.AVPlayer>((resolve, reject) => {
      timer = setTimeout(() => {
        isTimeout = true;
        reject(new Error(`[${this.type}] Timeout in ${time} ms`));
      }, time);
    });

    const res = await Promise.race([createPromise, timeoutPromise]);
    clearTimeout(timer);
    return res;
  }

  private stateChangeCallBack(avPlayer: media.AVPlayer): void {
    // 状态机变化回调函数
    avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      log.showWarn(`[${this.type}] AVPlayer state is: ${state}, soundDuration is: ${this.ringParams?.soundDuration}`);
      switch (state) {
        case 'idle': // 成功调用reset接口后触发该状态机上报
          this.idleProcess(avPlayer);
          break;
        case 'initialized': // avplayer 设置播放源后触发该状态上报
          log.showInfo(`[${this.type}] AVPlayer state initialized called.`);
          this.setAVPlayerUsage(avPlayer);
          avPlayer.prepare();
          break;
        case 'prepared': // prepare调用成功后上报该状态机
          log.showInfo(`[${this.type}] AVPlayer state prepared called.`);
          avPlayer.seek(0);
          this.setAVPlayerVolume(avPlayer, this.playingParams.ringVolume);
          this.setInterruptMode(avPlayer);
          avPlayer.play();// 调用播放接口开始播放
          this.playingParams.startTime = this.getTime();
          log.showInfo(`[${this.type}] AVPlayer play, startTime: ${this.playingParams.startTime}`);
          break;
        case 'playing': // play成功调用后触发该状态机上报
          log.showInfo(`[${this.type}] AVPlayer state playing called, times: ` + this.playingParams.playTimes);
          // 首次播放的时候起振动，循环播放期间不会停止振动，非首次播放不用再起振动
          if (this.playingParams.playTimes === 0) {
            this.playVibration();
          }
          this.playingParams.playTimes++;
          this.prepareFinishPromise?.resolve();
          break;
        case 'completed': // 播放结束后触发该状态机上报
          log.showInfo(`[${this.type}] AVPlayer state completed called.`);
          this.reportStatus = ReportStatus.COMPLETE;
          await this.checkTimeWhenComplete(avPlayer);
          break;
        case 'stopped':
          log.showInfo(`[${this.type}] AVPlayer state stopped called.`);
          this.stopCustomVibration();
          break;
        case 'paused':
          // 焦点打断回调paused
          log.showInfo(`[${this.type}] AVPlayer state paused called.`);
          this.stopCustomVibration();
          break;
        case 'released':
          log.showInfo(`[${this.type}] AVPlayer state released called.`);
          this.stopCustomVibration();
          break;
        default:
          log.showInfo(`[${this.type}] AVPlayer state unknown called.`);
          break;
      }
    });
  }

  /**
   * idle状态处理函数
   * @param avPlayer
   */
  private idleProcess(avPlayer: media.AVPlayer): void {
    this.playingParams.endTime = this.getTime();
    log.showInfo(`[${this.type}] AVPlayer state idle called. endTime: ${this.playingParams.endTime}, needPlay ${this.playingParams.needSetSrc}`);
    this.playbackEventReporter(this.ringParams, this.reportStatus);
    this.reportStatus = -1;
    this.stopCustomVibration();
    // 需要播放，idle回调时设置播放源
    if (this.playingParams.needSetSrc) {
      this.setAVPlayerFile(avPlayer);
      this.playingParams.needSetSrc = false;
    }
    if (this.type === PlayerType.VOIP) {
      log.showWarn('voip player release when idle');
      this.releaseOldPlayer(avPlayer);
    }
  }

  private playVibration(): void {
    if (this.ringParams?.isNtfFlashEnable && this.ringParams?.flashEnableCallback?.()) {
      this.flashPlayer = new NotificationFlashReminder();
      if (this.ringParams.startFlashCallback) {
        this.ringParams.startFlashCallback();
      }
      this.flashPlayer.startFlashTorchLight();
    }
    if (this.playingParams.customVibrateAllow) {
      NotificationVibratorManager.instance.startVibration(this.ringParams?.isWeak!, this.type === PlayerType.VOIP);
    } else if (this.ringParams?.isVibrationAllow) {
      const playRemindParam: PlayRemindParam = {
        isTonePlayAllow: false,
        isVibrationAllow: true,
        systemToneType: this.ringParams.systemToneType,
        isWeak: this.ringParams.isWeak,
        maintenanceInfo: this.ringParams.maintenanceInfo
      };
      // 特殊情况：不携带长振动的VOIP通知，使用单独的系统播放器去播放振动，避免与普通的系统铃声冲突
      if (this.type === PlayerType.VOIP) {
        this.systemPlayer = SysTonePlayerInstanceManager.voipSysToneInstance();
        this.systemPlayer.play(playRemindParam);
      } else {
        SysTonePlayerInstanceManager.instance().play(playRemindParam);
      }
    }
  }

  private async checkTimeWhenComplete(avPlayer: media.AVPlayer): Promise<void> {
    const playedTime = this.getTime() - this.playingParams.startTime;
    const remainTime = this.ringParams?.soundDuration ? this.ringParams.soundDuration - playedTime : 0;
    log.showInfo(`[${this.type}] current play time ${playedTime}, remain time ${remainTime}`);

    if (remainTime > 0) {
      await avPlayer.play();
      this.playingParams.remainTime = remainTime;
    } else {
      this.stopCustomVibration();
      avPlayer.reset();
    }
  }

  // 注册avplayer回调函数
  private setAVPlayerCallback(avPlayer: media.AVPlayer, info?: RemindNotificationMaintenanceExt): void {
    // error回调监听函数,当avPlayer在操作过程中出现错误时调用 reset接口触发重置流程
    avPlayer.on('error', (err: BusinessError) => {
      log.showError(`[${this.type}] Invoke avPlayer failed, code is ${err?.code}, message is ${err?.message}`);
      this.reportStatus = ReportStatus.ERROR;
      this.stopCustomVibration();
      RemindNotificationMaintenance.get().reportRemind(RemindNotificationErrorCode.AVPLAYER_CALLBACK_ERROR, err, info);
      this.prepareFinishPromise?.resolve();
    });

    this.checkDuration(avPlayer);
    this.stateChangeCallBack(avPlayer);
  }

  private checkDuration(avPlayer: media.AVPlayer): void {
    avPlayer.on('durationUpdate', (duration: number) => {
      // prepare时候会调用
      log.showInfo(`[${this.type}] current media duration is : ` + duration + ' soundDuration is: ' + this.ringParams?.soundDuration);
      if (this.ringParams) {
        this.ringParams.soundDuration = this.checkAndGetSoundDuration(this.ringParams?.soundDuration);
      }
      if (!this.ringParams?.soundDuration) {
        this.playingParams.remainTime = DEFAULT_PLAY_TIME;
        this.checkPlayTime(avPlayer);
        return;
      }
      this.ringParams.soundDuration = Math.min(this.ringParams.soundDuration, NotificationReminder.MAX_PLAY_TIME);
      this.playingParams.remainTime = this.ringParams.soundDuration;
      this.checkPlayTime(avPlayer);
    });
  }

  private checkAndGetSoundDuration(soundDuration?: number): number | undefined {
    if (!soundDuration || soundDuration <= 0) {
      return undefined;
    }
    if (soundDuration > NotificationReminder.MAX_PLAY_TIME / 1000) {
      return NotificationReminder.MAX_PLAY_TIME;
    }
    return soundDuration * 1000; // to ms
  }

  private checkPlayTime(avPlayer: media.AVPlayer): void {
    avPlayer.on('timeUpdate', (newTime: number) => {
      if (newTime >= this.playingParams.remainTime) {
        log.showInfo(`[${this.type}] AVPlayer timeUpdate reset: ${newTime}`);
        this.reportStatus = ReportStatus.INTERRUPT;
        this.stopCustomVibration();
        avPlayer.reset();
      }
    });
  }

  /**
   * 用于处理播放自定义铃声，系统铃声和振动函数
   */
  public async play(ringParams: PlayRemindParam): Promise<void> {
    try {
      log.showInfo(`[${this.type}] Start play, is weak ${ringParams.isWeak}, isTonePlayAllow ${ringParams
        .isTonePlayAllow}, isVibrationAllow ${ringParams.isVibrationAllow}`);
      this.maintenanceInfo = ringParams.maintenanceInfo;
      this.checkSound(ringParams);
      await this.playCustomSound(ringParams, ringParams.ringVolume ?? 0);
    } catch (e) {
      LogWithHa.error(log, `[${this.type}] play failed ${e}`, e);
      RemindNotificationMaintenance.get()
        .reportRemind(RemindNotificationErrorCode.PLAY_ERROR, e as BusinessError, this.maintenanceInfo);
    }
  }

  /**
   * 停止播放当前音频
   * @param reason 停止原因
   * @param param 停止参数
   */
  public async stop(reason: StopReason): Promise<void> {
    const player = await this.playerPromise;
    if (!player || (player.state === 'idle' || player.state === 'released')) {
      await this.stopCustomVibration(reason);
      return;
    }
    this.reportStatus = ReportStatus.STOPPED;
    try {
      await player.reset();
      LogWithHa.warn(log, `[${this.type}] stop play by ${reason}, hashCode ${this.ringParams?.hashCode}`);
    } catch (e) {
      LogWithHa.error(log, `[${this.type}] reset player ${reason} failed, hashCode ${this.ringParams?.hashCode}, ${e}`,
        NotificationExceptionCode.STOP_PLAYER_FAIL, e);
      this.stopCustomVibration(reason);
    }
  }

  private async playCustomSound(ringParams: PlayRemindParam, ringVolume: number): Promise<void> {
    let player = await this.getPlayer(this.type === PlayerType.VOIP); // voip的播放器每次重新创建，播放完释放
    if (player && player.state === 'error') {
      player = await this.getPlayer(true);
    }
    if (!player) {
      if (ringParams.isNtfFlashEnable && this.ringParams?.flashEnableCallback?.()) {
        ringParams.startFlashCallback?.();
        new NotificationFlashReminder().flashTorchLight(ringParams.stopFlashCallback, 2);
      }
      await SysTonePlayerInstanceManager.instance().play(ringParams);
      LogWithHa.warn(log, `[${this.type}] get avplayer fail, play systone`, NotificationExceptionCode.PLAY_SYS_INSTEAD);
      return;
    }
    this.ringParams = ringParams;
    this.playingParams = new PlayingParam();
    this.playingParams.customToneAllow = ringParams.isNtfTonePlayAllow ?? true;
    this.playingParams.customVibrateAllow = (ringParams.isCustomVibration && ringParams.isVibrationAllow) ?? true;
    this.playingParams.ringVolume = ringVolume;
    if (this.type === PlayerType.NORMAL) {
      await AudioUtil.waitForPlayComplete();
    }
    const info: RemindNotificationMaintenanceExt | undefined = this.maintenanceInfo;
    this.setAVPlayerCallback(player, info);
    log.showInfo(`[${this.type}] player.state = ${player.state}`);
    if (player.state === 'idle') {
      /* idle状态直接设置播放源 */
      this.setAVPlayerFile(player);
    } else {
      this.reportStatus = ReportStatus.INTERRUPT;
      this.playingParams.needSetSrc = true;
      await player.reset();
      log.showInfo(`[${this.type}] player reset success, current state ${player.state}`);
    }
    this.prepareFinishPromise = this.getPrepareFinishPromise();
    await this.prepareFinishPromise;
    RemindNotificationMaintenance.get().reportRemind(undefined, undefined, info);
    this.prepareFinishPromise = undefined;
  }

  private async releaseOldPlayer(player?: media.AVPlayer): Promise<void> {
    if (!player) {
      return;
    }
    try {
      log.showWarn(`[${this.type}] try release old player.`);
      await player?.release();
    } catch (e) {
      LogWithHa.error(log, `[${this.type}] release error player failed ${e}`, NotificationExceptionCode.RELEASE_PLAYER_FAIL, e, 'reminder');
    }
  }

  private getPrepareFinishPromise(): CustomPromise<void> {
    const promise = new CustomPromise<void>();
    // 兜底promise
    setTimeout(() => {
      promise.resolve();
    }, 500);
    return promise;
  }

  private checkSound(ringParams: PlayRemindParam): void {
    // 有sound属性，但无实际音频，打点
    if (ringParams.isTonePlayAllow && !ringParams.soundDescriptor && ringParams.sound) {
      this.playbackEventReporter(ringParams, ReportStatus.NOT_EXIST);
      this.addError(RemindNotificationErrorCode.CUSTOM_SOUND_INVALID);
    }
  }

  private setAVPlayerFile(avPlayer: media.AVPlayer): void {
    const avFileDescriptor: media.AVFileDescriptor = {
      fd: this.ringParams?.soundDescriptor?.fd ?? 0,
      offset: this.ringParams?.soundDescriptor?.offset,
      length: this.ringParams?.soundDescriptor?.length
    };
    avPlayer.fdSrc = avFileDescriptor;
  }

  private setAVPlayerUsage(avPlayer: media.AVPlayer): void {
    avPlayer.audioRendererInfo = {
      usage: this.type === PlayerType.NORMAL ? audio.StreamUsage.STREAM_USAGE_NOTIFICATION :
      audio.StreamUsage.STREAM_USAGE_RINGTONE,
      rendererFlags: 0,
    };
  }

  private setAVPlayerVolume(avPlayer: media.AVPlayer, ringVolume: number): void {
    // 只有因为通知本身不能响铃时才能设置为0，否则在控制中心切换到响铃模式时无法继续播放铃声
    if (!this.playingParams.customToneAllow) {
       avPlayer.setVolume(0);
       return;
    }
    // 铃声弱化百分比
    if (this.ringParams?.isWeak) {
      const weakPercent = WEAK_VOLUME_ARR[ringVolume];
      log.showInfo(`[${this.type}] Ring is weak, cur volume ${ringVolume}, set weak percent ${weakPercent}`);
      avPlayer.setVolume(weakPercent);
    } else {
      avPlayer.setVolume(1);
    }
  }

  private setInterruptMode(avPlayer: media.AVPlayer): void {
    // 设置音频焦点模式
    if (this.type === PlayerType.NORMAL) {
      avPlayer.audioInterruptMode = audio.InterruptMode.INDEPENDENT_MODE;
    }
  }

  private async stopCustomVibration(reason?: StopReason): Promise<void> {
    this.flashPlayer?.stopFlashTorchLight();
    this.flashPlayer = undefined;
    if (this.ringParams?.stopFlashCallback) {
      this.ringParams?.stopFlashCallback();
    }
    await NotificationVibratorManager.instance.stopVibration(this.type === PlayerType.VOIP);
    // 不携带长震动的VoIP通知会使用单独的系统播放器播放振动，需要一起stop
    if (this.systemPlayer) {
      await this.systemPlayer.stop(reason ?? StopReason.DEFAULT);
      this.systemPlayer = undefined;
    }
  }

  /**
   * 自定义铃声打点函数
   */
  private playbackEventReporter(ringParams: PlayRemindParam | undefined, reportStatus: number): void {
    NotificationSysEventReporter.ntfPlaybackRingtonesItem({
      STARTTIME: this.playingParams.startTime,
      ENDTIME: this.playingParams.endTime,
      STATUS: reportStatus,
      BUNDLE_NAME: ringParams?.bundleName,
      NTF_SLOT_TYPE: ringParams?.slotType,
      NTF_ID: ringParams?.ntfId,
      VIBRATION_MODE: this.getVibrationMode(ringParams)
    });
  }

  private getVibrationMode(ringParams: PlayRemindParam): number {
    const customVibration: number = 2;
    const normalVibration: number = 1;
    if (ringParams.isVibrationAllow) {
      if (ringParams.isCustomVibration) {
        return customVibration;
      }
      return normalVibration;
    }
    return 0;
  }

  private addError(errorCode: number): void {
    this.maintenanceInfo?.errorCodes?.push(errorCode);
  }

  private getTime(): number {
    return systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
  }

  /**
   * 内存回收动作
   */
  public async onStaticMemory(): Promise<void> {
    try {
      if (!this.playerPromise) {
        return;
      }
      this.playbackEventReporter(this.ringParams, ReportStatus.RELEASE);
      log.showInfo(`[${this.type}] avplayer released`);
      const player = await this.playerPromise;
      await player?.release();
      this.playerPromise = undefined;
    } catch (e) {
      log.error('memory release failed, ' + e);
    }
  };
}