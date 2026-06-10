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

import audio from '@ohos.multimedia.audio';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { InnerEventUtil, Singleton } from '@ohos/systemuicommon/newTsIndex';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { NotificationExceptionCode } from '../maintenance/NotificationExceptionCode';
import { systemSoundManager } from '@kit.AudioKit';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { VibrateSwitchEvent } from '@ohos/systemuicommon/src/main/ets/datasharemanager/SysUIDataShareEvent';
import { StatisticsMaintenance } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsMaintenance';

const TAG = 'RingSettingManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export interface RingSetting {
  toneAllow?: boolean;
  vibrateAllow?: boolean;
  vibrateWhenRing?: boolean;
}

/**
 * 设置-声音与振动，自定义铃声播放时需判断使用
 */
export class RingSettingManager {
  @Singleton.decorate()
  static get instance(): RingSettingManager { return new RingSettingManager(); }

  private static readonly NO_RING_VALUE = 'no_system_sound';

  /* 响铃时是否振动 */
  private isVibrateWhenRing: boolean = true;

  private constructor() {
  }

  public init(): void {
    InnerEventUtil.on(VibrateSwitchEvent, this.onVibrateSwitch);
  }

  private onVibrateSwitch = (event: VibrateSwitchEvent): void => {
    if (this.isVibrateWhenRing !== event.isVibrateWhenRing()) {
      this.isVibrateWhenRing = event.isVibrateWhenRing();
      LogWithHa.info(log, `isVibrateWhenRing switch to ${event.shareValue}`,
        NotificationExceptionCode.VIBRATE_SWITCH_CHANGE);
    }
  };

  public async getNotificationRingSetting(type: systemSoundManager.SystemToneType): Promise<RingSetting> {
    try {
      log.showInfo(`start getSystemToneUri`);
      const context = GlobalContext.getContext();
      const sysSoundMgr: systemSoundManager.SystemSoundManager = systemSoundManager.getSystemSoundManager();
      // 获取声音与振动-通知铃声-铃声设置
      const uri = await sysSoundMgr.getSystemToneUri(context, type);
      const toneAllow = (uri !== RingSettingManager.NO_RING_VALUE);
      // 获取声音与振动-通知铃声-振动设置
      const vibrateSetting = await sysSoundMgr.getToneHapticsSettings(context, this.getHapticsType(type));
      const vibrateAllow = (vibrateSetting.mode !== systemSoundManager.ToneHapticsMode.NONE);
      log.showWarn(`[${type}] setting ring allowed ${toneAllow}, vibrateAllowed ${vibrateAllow}, isVibrateWhenRing ${this.isVibrateWhenRing}`);
      StatisticsMaintenance.get().setRingSetting(toneAllow, vibrateAllow, this.isVibrateWhenRing);
      return { toneAllow: toneAllow, vibrateAllow: vibrateAllow, vibrateWhenRing: this.isVibrateWhenRing };
    } catch (err) {
      LogWithHa.error(log, `getSystemToneUri error: ${err?.code} message:${err?.message}`,
        NotificationExceptionCode.GET_RING_SETTING_FAIL, err);
    }
    return { toneAllow: true, vibrateAllow: true, vibrateWhenRing: this.isVibrateWhenRing };
  }

  private getHapticsType(type: systemSoundManager.SystemToneType): systemSoundManager.ToneHapticsType {
    if (type === systemSoundManager.SystemToneType.SYSTEM_TONE_TYPE_SIM_CARD_0) {
      return systemSoundManager.ToneHapticsType.TEXT_MESSAGE_SIM_CARD_0;
    } else if (type === systemSoundManager.SystemToneType.SYSTEM_TONE_TYPE_SIM_CARD_1) {
      return systemSoundManager.ToneHapticsType.TEXT_MESSAGE_SIM_CARD_1;
    }
    return systemSoundManager.ToneHapticsType.NOTIFICATION;
  }

  public async getRingVolume(): Promise<number> {
    const audioManager: audio.AudioManager = audio.getAudioManager();
    const audioVolumeManager: audio.AudioVolumeManager = audioManager.getVolumeManager();
    const audioVolumeGroupManager = await audioVolumeManager.getVolumeGroupManager(audio.DEFAULT_VOLUME_GROUP_ID);
    let ringVolume: number = await audioVolumeGroupManager?.getVolume(audio.AudioVolumeType.RINGTONE);
    return ringVolume;
  }
}