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

import { Singleton } from '@ohos/systemuicommon/src/main/ets/utils/Singleton';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { PlayRemindParam, StopReason, TIMEOUT_DURATION } from '../remind/RemindConstant';
import { BasePlayer } from '../remind/BasePlayer';
import { systemSoundManager } from '@kit.AudioKit';
import { GlobalContext, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { BusinessError } from '@kit.BasicServicesKit';
import { LogWithHa, RemindNotificationErrorCode, RemindNotificationMaintenance } from '@ohos/systemuicommon';
import { WEAK_VOLUME_ARR } from '@ohos/systemuicommon/src/main/ets/utils/AudioUtils';

import { CommonExceptionCode } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionCode';
import { NotificationExceptionCode } from '../maintenance/NotificationExceptionCode';
import { NotificationFlashReminder } from '../manager/NotificationFlashReminder';

const TAG = 'SysTonePlayer';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);


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

export class SysTonePlayer implements BasePlayer {
  private player: CustomPlayer | undefined;

  private playType?: number;

  private isPlaying: boolean = false;

  private timeOutId: number = SysTonePlayer.INVALID_TIMEOUTID;

  private static readonly TIMEOUT = 2000;

  private static readonly INVALID_TIMEOUTID = -1;

  /**
   * 播放系统铃声
   * @param ringParams
   * @returns
   */
  public async play(ringParams: PlayRemindParam): Promise<void> {
    this.playType = ringParams.systemToneType;
    log.showInfo(`begin play playType: ${this.playType}, weak ${ringParams.isWeak}, cur player: ${this.player === undefined}`);
    if (this.player) {
      try {
        await this.player.release();
      } catch (err) {
        log.showError('release existing player err, code:%{public}d, msg:%{public}s', err?.code, err?.message);
      }
      this.player = undefined;
    }
    this.player = await this.getPlayerWithTimeout(SysTonePlayer.TIMEOUT, this.playType!);
    if (!this.player) {
      log.showError(`get player fail`);
      RemindNotificationMaintenance.get()
        .reportRemind(RemindNotificationErrorCode.GET_SYS_PLAYER_ERROR, undefined, ringParams.maintenanceInfo);
      return;
    }
    try {
      this.isPlaying = true;
      if (ringParams.isWeak) {
        await this.setAudioWeakModeIfNecessary(this.player, ringParams.ringVolume!);
      }
      await this.player.prepare();
      if (ringParams.isNtfFlashEnable && ringParams?.flashEnableCallback?.()) {
        ringParams.startFlashCallback?.();
        new NotificationFlashReminder().flashTorchLight(ringParams.stopFlashCallback, 2);
      }
      let tonePlayingId =
        await this.player.start({ muteAudio: !ringParams.isTonePlayAllow, muteHaptics: !ringParams.isVibrationAllow });
      log.showInfo(`startToneAndVibration result: ${tonePlayingId} , ${!ringParams.isTonePlayAllow} , ` +
        ` ${!ringParams.isVibrationAllow} , ${ringParams.systemToneType}`);
      RemindNotificationMaintenance.get().reportRemind(undefined, undefined, ringParams.maintenanceInfo);
      // 铃声播放间隔时长后置位
      this.timeOutId = setTimeout(async () => {
          await this.timeOutStopPlay(tonePlayingId, ringParams);
      }, TIMEOUT_DURATION);
    } catch (error) {
      let err = error as BusinessError;
      log.showError(`play start error code is ${error?.code} message is ${error?.message}`);
      RemindNotificationMaintenance.get()
        .reportRemind(RemindNotificationErrorCode.SYS_PLAY_ERROR, err, ringParams.maintenanceInfo);
    }
  }

  private async timeOutStopPlay(tonePlayingId: number, ringParams: PlayRemindParam): Promise<void> {
    try {
      log.showInfo(`timeout stop play playType: ${tonePlayingId} , ${!ringParams.isTonePlayAllow} ,` +
        ` ${!ringParams.isVibrationAllow} , ${ringParams.systemToneType}`);
      this.timeOutId = SysTonePlayer.INVALID_TIMEOUTID;
      this.stop(StopReason.TIMEOUT);
    } catch (error) {
      log.showError(`timeout stop play error code is ${error?.code} message is ${error?.message}`);
    }
  }

  private async getPlayerWithTimeout(time: number, playType: number): Promise<CustomPlayer | undefined> {
    let isTimeout: boolean = false;
    let timer: number | undefined;
    log.showInfo(`get player with timeout`);
    try {
      let sysSoundMgr: systemSoundManager.SystemSoundManager = systemSoundManager.getSystemSoundManager();
      const createPromise = sysSoundMgr?.getSystemTonePlayer(GlobalContext.getContext(), playType).then((player) => {
        if (isTimeout) {
          player.release();
          return undefined;
        }
        return player as CustomPlayer;
      });
      const timeoutPromise = new Promise<CustomPlayer>((resolve, reject) => {
        timer = setTimeout(() => {
          isTimeout = true;
          reject(new Error(`[${playType}] Timeout in ${time} ms`));
        }, time);
      });
      const res = await Promise.race([createPromise, timeoutPromise]);
      clearTimeout(timer);
      return res;
    } catch (error) {
      LogWithHa.error(log,
        `get player error type is [${playType}] code is ${error?.code} message is ${error?.message}`,
        NotificationExceptionCode.GET_SYS_TONE_PLAYER_ERROR, error);
      return undefined;
    }
  }

  public async stop(reason: StopReason): Promise<void> {
    if (this.timeOutId !== SysTonePlayer.INVALID_TIMEOUTID) {
      clearTimeout(this.timeOutId);
      this.timeOutId = SysTonePlayer.INVALID_TIMEOUTID;
    }
    log.showInfo(`begin stop play playType: ${this.playType} isPlaying: ${this.isPlaying}`);
    if (this.isPlaying) {
      LogWithHa.warn(log, `sys tone stop play by ${reason}`);
      try {
        await this.player?.release();
        this.player = undefined;
        this.isPlaying = false;
        log.showInfo(`player stopped`);
      } catch (error) {
        LogWithHa.error(log, `SysTonePlayer stop error code: ${error?.code}, message: ${error?.message}`,
          NotificationExceptionCode.STOP_PLAYER_FAIL);
      }
    }
  }

  private async setAudioWeakModeIfNecessary(player: CustomPlayer, valueVolume: number): Promise<void> {
    let weakVolume: number = WEAK_VOLUME_ARR[valueVolume];
    log.showInfo(`setAudioWeakModeIfNecessary: valueVolume=${valueVolume}, volume =${weakVolume}`);
    try {
      // 调用媒体接口设置音量
      player.setAudioVolumeScale(weakVolume);
      // 查询支持的振动特性
      let hapticsArr: ToneHapticsFeature[] = await player.getSupportedHapticsFeatures();
      if (!hapticsArr || hapticsArr.length === 0) {
        log.showInfo(`unsupport any hapticsFeature`);
        return;
      }
      if (hapticsArr.some((feature) => feature === ToneHapticsFeature.GENTLE)) {
        // 弱振
        player.setHapticsFeature(ToneHapticsFeature.GENTLE);
      } else {
        // 标准
        player.setHapticsFeature(ToneHapticsFeature.STANDARD);
      }
    } catch (error) {
      LogWithHa.error(log, `setAudioWeakModeIfNecessary error code: ${error?.code}, message: ${error?.message}`,
        CommonExceptionCode.SET_WEAK_FAIL);
    }
  }
}
