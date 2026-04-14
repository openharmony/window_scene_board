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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/utils/GlobalContext';
import sSettingsUtil from '@ohos/frameworkwrapper/src/main/ets/setting/SettingsUtil';
import { audio } from '@kit.AudioKit';
import { NotificationBase } from '@ohos/systemuicommon/src/main/ets/model/NotificationBase';
import { InnerEventUtil } from '@ohos/systemuicommon/src/main/ets/utils/InnerEventUtil'
import { StatisticsMaintenance } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsMaintenance';
import { RingSettingManager } from './RingSettingManager';
import { EmergencyThermalSafeManager } from '@ohos/systemuicommon/src/main/ets/manager/EmergencyThermalSafeManager';
import { RemindPlayManager } from './RemindPlayManager';
import { Classification, StopReason } from '../remind/RemindConstant';
import { Callback, power } from '@kit.BasicServicesKit';
import {
  FlashReminderSwitchEvent,
  FlashReminderSlotChangeEvent
} from '@ohos/systemuicommon/src/main/ets/datasharemanager/SysUIDataShareEvent';
import { EnvVm } from '@ohos/systemuicommon/src/main/ets/vm/EnvVm';
import { SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants/src/main/ets/constants/Constants';

const TAG = 'NotificationRemindManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const ACCESSIBILITY_FLICKERING_REMINDER_NOTIFY = 'NOTIFY';

/**
 * 通知提醒管理
 */
export class NotificationRemindManager {
  /**
   * 获取单例
   */
  public static get = SingletonHelper.createFactory(() => new NotificationRemindManager());

  private isSysTonePlayAllow: boolean = true;

  private isSysVibrationAllow: boolean = true;

  private audioVolumeGroupManager?: audio.AudioVolumeGroupManager;
  /**
   * 是否持续闪烁
   */
  private isCurrentFlashing: boolean = false;

  private isFlashReminderEnable: boolean =
    sSettingsUtil.getSecureValue(SettingsKeyConstants.ACCESSIBILITY_FLASH_REMINDER_SWITCH,
      SettingsConstants.ACCESSIBILITY_FLASH_REMINDER_SWITCH_DEFAULT) === '1';

  private flashReminderSlot: string =
    sSettingsUtil.getSecureValue(SettingsKeyConstants.ACCESSIBILITY_REMINDER_FUNCTION_ENABLED,
      SettingsConstants.ACCESSIBILITY_REMINDER_FUNCTION_ENABLED_DEFAULT);

  private onRingModeChange: Callback<audio.AudioRingMode> = (ringMode: audio.AudioRingMode) => {
    log.showInfo(`Ring mode change: ${ringMode}`);
    switch (ringMode) {
      case audio.AudioRingMode.RINGER_MODE_SILENT:
        this.isSysTonePlayAllow = false;
        this.isSysVibrationAllow = false;
        break;
      case audio.AudioRingMode.RINGER_MODE_NORMAL:
        this.isSysTonePlayAllow = true;
        this.isSysVibrationAllow = true;
        break;
      case audio.AudioRingMode.RINGER_MODE_VIBRATE:
        this.isSysTonePlayAllow = false;
        this.isSysVibrationAllow = true;
        break;
      default:
        break;
    }
    StatisticsMaintenance.get().setRingMode(ringMode);
  };

  /**
   * 初始化
   */
  public async init(): Promise<void> {
    try {
      RingSettingManager.instance.init();
      this.audioVolumeGroupManager =
        await audio.getAudioManager().getVolumeManager().getVolumeGroupManager(audio.DEFAULT_VOLUME_GROUP_ID);
      if (this.audioVolumeGroupManager) {
        this.audioVolumeGroupManager.on('ringerModeChange', this.onRingModeChange);
        this.onRingModeChange(await this.audioVolumeGroupManager.getRingerMode());
      }
      InnerEventUtil.on(FlashReminderSwitchEvent, this.onFlashReminderSwitchEvent);
      InnerEventUtil.on(FlashReminderSlotChangeEvent, this.onFlashReminderSlotChangeEvent);
    } catch (e) {
      log.showError('Init remind manager error:' + e);
    }
  }

  /**
   * 通知提醒
   * @param ntfEntry 通知
   * @param isUpdate 是否更新通知
   * @param requestSound request数据中的sound信息
   */
  public remind(ntfEntry: NotificationBase, isUpdate: boolean, requestSound?: string): void {
    if (!EmergencyThermalSafeManager.instance.isShowNotification(ntfEntry.creatorBundleName)) {
      return;
    }
    // 普通通知更新停止自定义铃声
    if (ntfEntry.isNormal() && isUpdate) {
      log.showInfo(`stop custom sound when ntf update ${ntfEntry.hashCode}`);
      RemindPlayManager.instance.stop(StopReason.NOTIFICATION_UPDATE, [{
        hashCode: ntfEntry.hashCode,
        bundleName: ntfEntry.creatorBundleName,
        appIndex: ntfEntry.appIndex,
        classification: ntfEntry.classification
      }]);
    }
    // MissCall消息打断
    if (ntfEntry?.classification === Classification.MISS_CALL) {
      log.showWarn('try stop player due to MissCall.');
      RemindPlayManager.instance.stop(StopReason.MISS_CALL, [{
        bundleName: ntfEntry.creatorBundleName,
        classification: ntfEntry.classification as string,
        appIndex: ntfEntry.appIndex
      }]);
    }
    if (!ntfEntry.isSoundEnable && !ntfEntry.isVibrationEnable) {
      log.showInfo(`No need to remind, isSilence ${ntfEntry.hashCode}`);
      return;
    }

    RemindPlayManager.instance.play({
      context: GlobalContext.getContext(),
      isTonePlayAllow: ntfEntry.isSoundEnable && this.isSysTonePlayAllow,
      isVibrationAllow: ntfEntry.isVibrationEnable && this.isSysVibrationAllow,
      soundDescriptor: ntfEntry.customSound,
      sound: requestSound,
      systemToneType: ntfEntry.systemToneType,
      bundleName: ntfEntry.creatorBundleName,
      slotType: ntfEntry.slotType,
      ntfId: ntfEntry.id,
      creatorUid: ntfEntry.creatorUid,
      hashCode: ntfEntry.hashCode,
      isCustomVibration: ntfEntry.controlConfig.isCustomVibration(),
      isNtfTonePlayAllow: ntfEntry.isSoundEnable,
      soundDuration: ntfEntry.soundDuration,
      isSysTonePlayAllow: this.isSysTonePlayAllow,
      channelId: ntfEntry.channelId,
      appIndex: ntfEntry.appIndex,
      traceId: ntfEntry.traceId,
      isNtfFlashEnable: (ntfEntry.isVibrationEnable || ntfEntry.isSoundEnable) && !ntfEntry.isLiveView(),
      startFlashCallback: this.startFlashCallback,
      stopFlashCallback: this.stopFlashCallback,
      flashEnableCallback: this.flashEnableCallback
    }, ntfEntry.classification ?? '');
  }

  /**
   * 判断通知是否支持闪烁
   * @param ntfEntry 通知
   * @returns enable 通知是否闪烁
   */
  private flashEnableCallback: () => boolean = () => {
    if (this.isCurrentFlashing) {
      log.showInfo(`not support flash, reason: is current flashing`);
      return false;
    }
    if (!EnvVm.instance.isScreenLock) {
      log.showInfo(`not support flash, reason: is not screenLock`);
      return false;
    }
    const powerMode = power.getPowerMode();
    if (powerMode === power.DevicePowerMode.MODE_POWER_SAVE ||
      powerMode === power.DevicePowerMode.MODE_EXTREME_POWER_SAVE) {
      log.showInfo(`not support flash, reason: is in powerSaveMode`);
      return false;
    }
    if (!this.isFlashReminderEnable || !this.flashReminderSlot.includes(ACCESSIBILITY_FLICKERING_REMINDER_NOTIFY)) {
      log.showInfo(`not support flash, reason: ntf flash not enable`);
      return false;
    }
    return true;
  }

  /**
   * 通知开始闪烁回调
   */
  private startFlashCallback = () => {
    log.showInfo(`startFlashCallback`)
    this.isCurrentFlashing = true;
  };

  /**
   * 通知停止闪烁回调
   */
  private stopFlashCallback = () => {
    log.showInfo(`stopFlashCallback`)
    this.isCurrentFlashing = false;
  };

  /**
   * 闪烁提醒开关切换事件回调
   */
  private onFlashReminderSwitchEvent = (event: FlashReminderSwitchEvent) => {
    const enable: boolean = event.isFlashReminderSwitchEnable()
    log.showInfo(`onFlashReminderSwitchChange, isEnable is: ${enable}`);
    this.isFlashReminderEnable = enable;
  };

  /**
   * 闪烁提醒方式变化回调
   */
  private onFlashReminderSlotChangeEvent = (event: FlashReminderSlotChangeEvent) =>  {
    const slot: string = event.getFlashReminderSlot();
    log.showInfo(`onFlashReminderSlotChange, mode is: ${slot}`);
    this.flashReminderSlot = slot;
  };
}