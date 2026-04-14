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

import { ScreenLockPromptTone } from './ScreenLockPromptTone';
import { SettingsUtil } from '@ohos/frameworkwrapper';
import {
  CacheValue,
  GlobalStatusCache,
  ScreenLockStateManager,
  UserSwitchService,
  ScreenLockStateChangeListener,
  LockStateInfo
} from '@ohos/screenlockcommon';
import DataShareManager from '@ohos/screenlockcommon/src/main/ets/base/DataShareManager';
import taskpool from '@ohos.taskpool';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { audio } from '@kit.AudioKit';


const TAG = 'ScreenLockAVPlayerManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 文件资源的路径
 */
const REMIDE_AUDIO_BASE_PATH: string = '/sys_prod/variant/region_comm/china/';
const SCREEN_LOCK_AUDIO_PATH: string = 'resource/media/audio/ui/Lock.ogg';
const SCREEN_UNLOCK_AUDIO_PATH: string = 'resource/media/audio/ui/Unlock.ogg';

/**
 * 锁屏提示音数据库字段 & 默认值
 */
const SCREEN_LOCK_SOUNDS_ENABLE: string = 'lockscreen_sounds_enabled';
const SCREEN_LOCK_SOUNDS_DEFAULT_VALUE: string = '1';

/**
 * 提示音播放类型存值字段
 */
const SCREEN_LOCK_TONE_TYPE: string = 'screenLockToneType';

/**
 * 提示音播放类型
 */
enum ToneType {
  LOCK_TONE = 0,
  UNLOCK_TONE = 1,
  OTHER = 2,
}

/**
 * 锁屏提示音
 */
export default class ScreenLockAVPlayerManager {
  public static isScreenLockTonePlay: boolean = true;
  public static isScreenLockToneStatus: string = SCREEN_LOCK_SOUNDS_DEFAULT_VALUE;
  public static isEnterHostPlay: boolean = false;

  private static groupId: number = audio.DEFAULT_VOLUME_GROUP_ID;

  /**
   * 监听数据库的值
   *
   * 锁屏提示音开关
   * @returns Promise<void>
   */
  private static onEnableScreenLockToneListener(): void {
    DataShareManager.getInstance().registerUserSettingsDataShareListener(SCREEN_LOCK_SOUNDS_ENABLE, () => {
      ScreenLockAVPlayerManager.handleScreenLockToneStatus();
    });

  }

  private static handleScreenLockToneStatus(): void {
    ScreenLockAVPlayerManager.isScreenLockToneStatus =
      SettingsUtil.getSystemValue(SCREEN_LOCK_SOUNDS_ENABLE, SCREEN_LOCK_SOUNDS_DEFAULT_VALUE);
    ScreenLockAVPlayerManager.isScreenLockTonePlay =
      ScreenLockAVPlayerManager.isScreenLockToneStatus === SCREEN_LOCK_SOUNDS_DEFAULT_VALUE;
    log.showInfo(`screenLock tone status ${ScreenLockAVPlayerManager.isScreenLockToneStatus} isTonePlay = ${ScreenLockAVPlayerManager.isScreenLockTonePlay}`);
  }

  private static onEnableScreenLockToneListenerOff(): void {
    DataShareManager.getInstance().unregisterUserSettingsDataShareListener(SCREEN_LOCK_SOUNDS_ENABLE);
  }

  /**
   * 启动开关配置项的监听
   */
  public static onScreenLockPageTypeListener(): void {
    ScreenLockAVPlayerManager.onEnableScreenLockToneListener();
    ScreenLockAVPlayerManager.screenLockTonePlayListener();
    ScreenLockStateManager.getInstance().registerObserver(ScreenLockAVPlayerManager.screenLockStateChangeListener);
    ScreenLockAVPlayerManager.handleScreenLockToneStatus();
  }

  /**
   * 锁屏解锁事件订阅
   */
  private static screenLockStateChangeListener: ScreenLockStateChangeListener = {
    onLockStateChange: (lockStateInfo: LockStateInfo): void => {
      if (!UserSwitchService.getInstance().isCurrentUserActive) {
        log.showInfo(`user not active.`);
        return;
      }
      GlobalStatusCache.getInstance().setStatus(SCREEN_LOCK_TONE_TYPE,
        lockStateInfo.isPageShow ? ToneType.LOCK_TONE : ToneType.UNLOCK_TONE);
    }
  };


  public static onScreenLockPageTypeListenerOff(): void {
    ScreenLockStateManager.getInstance().unRegisterObserver(ScreenLockAVPlayerManager.screenLockStateChangeListener);
    ScreenLockAVPlayerManager.onEnableScreenLockToneListenerOff();
    GlobalStatusCache.getInstance().unsubscribeByType(SCREEN_LOCK_TONE_TYPE);
  }

  private static screenLockTonePlayListener(): void {
    GlobalStatusCache.getInstance().subscribe(SCREEN_LOCK_TONE_TYPE, (changed?: CacheValue) => {
      log.showInfo(`isScreenLockTonePlay: ${ScreenLockAVPlayerManager.isScreenLockTonePlay},tone type: ${changed},isEnterHostPlay: ${ScreenLockAVPlayerManager.isEnterHostPlay}`);
      if (!ScreenLockAVPlayerManager.isScreenLockTonePlay || ScreenLockAVPlayerManager.isMute() ||
        changed === ToneType.OTHER) {
        return;
      } else if (changed === ToneType.LOCK_TONE && ScreenLockAVPlayerManager.isEnterHostPlay) {
        ScreenLockAVPlayerManager.isEnterHostPlay = false;
        ScreenLockAVPlayerManager.playAudio(SCREEN_LOCK_AUDIO_PATH);
        log.showInfo('start lock screenLock tone');
        return;
      } else if (changed === ToneType.UNLOCK_TONE) {
        ScreenLockAVPlayerManager.isEnterHostPlay = true;
        ScreenLockAVPlayerManager.playAudio(SCREEN_UNLOCK_AUDIO_PATH);
        log.showInfo('start unlock screenLock tone');
        return;
      }
    });
  }

  /**
   * 获取指定音量流是否被静音,默认不禁用
   */
  private static isMute(): boolean {
    try {
      let audioManager = audio.getAudioManager();
      let audioVolumeManager: audio.AudioVolumeManager = audioManager.getVolumeManager();
      let audioVolumeGroupManager = audioVolumeManager.getVolumeGroupManagerSync(ScreenLockAVPlayerManager.groupId);
      let isMute: boolean = audioVolumeGroupManager.isMuteSync(audio.AudioVolumeType.RINGTONE);
      log.showInfo(`Obtains whether a specified volume stream is muted: ${isMute}`);
      return isMute;
    } catch (err) {
      log.showError(`get ringTone isMute error:${err?.code}`);
      return false;
    }
  }

  /**
   * 播放提示音，在子线程播放
   *
   * @param audioPath
   */
  private static playAudio(audioPath: string): void {
    ScreenLockAVPlayerManager.doTask(playScreenLockAudio, audioPath);
  }

  private static async doTask(func: Function, ...args: Object[]): Promise<Object | undefined> {
    try {
      const myTask = new taskpool.Task(func, ...args);
      taskpool.execute(myTask, taskpool.Priority.MEDIUM)
        .then((data) => {
          return data;
        })
        .catch((error: Error) => {
          log.error('taskpool execute try error', error);
        });
    } catch (e) {
      log.error(`doTask error when execute ${func.name},`, e);
    }
    return undefined;
  }
}

/**
 * 在子线程播放回调函数
 *
 * @param audioPath
 */
function playScreenLockAudio(audioPath: string): void {
  'use concurrent';
  const TAG = 'SCBScreenLock-PlayScreenLockAudio';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
  const mScreenLockPromptTone = new ScreenLockPromptTone();
  try {
    mScreenLockPromptTone.playNtfAudio(audioPath);
    log.showInfo('playNtfAudio try');
  } catch (err) {
    log.error(`playScreenLockAudio  error: ${err}`);
  }
}