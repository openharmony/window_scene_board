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

import { LogDomain, LogHelper, ThreadUtil} from '@ohos/basicutils';
import { PackageCommonEvent, TrimLevel, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import {
  BaseNotification,
  CommonEventListener,
  CommonEventSubscribeManager,
  NotificationMaintenanceNtfType,
  SystemUICommonUtil,
  TaskItem,
  TaskQueue
} from '@ohos/systemuicommon';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { NotificationEntryEvent } from '../common/event/NotificationEvent';
import CommonEventManager from '@ohos.commonEventManager';
import { systemSoundManager } from '@kit.AudioKit';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import { NotificationExceptionCode } from '../maintenance/NotificationExceptionCode';
import { Singleton } from '@ohos/systemuicommon/src/main/ets/utils/Singleton';
import { Classification, PlayerType, PlayRemindParam, StopParam, StopReason } from '../remind/RemindConstant';
import { NotificationReminder } from '../model/NotificationReminder';
import { InnerEventUtil, NotificationBase, NotificationEvent} from '@ohos/systemuicommon/newTsIndex';
import { RingSettingManager } from './RingSettingManager';
import { SysTonePlayerInstanceManager } from '../remind/SysTonePlayerInstanceManager';
import { StatisticsMaintenance } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsMaintenance';
import { notificationManager } from '@kit.NotificationKit';
import {
  RemindNotificationErrorCode,
  RemindNotificationMaintenance,
  RemindNotificationMaintenanceExt
} from '@ohos/systemuicommon/src/main/ets/maintenance/RemindNotificationMaintenance';
import { BannerSlideUpEvent, NtfCenterDropDownEvent } from '@ohos/systemuicommon/src/main/ets/event/NotificationEvent';
import { notificationConfigManager } from './NotificationConfigManager';
import { EnvVm } from '@ohos/systemuicommon/newIndex';
import { NotificationFlashReminder } from './NotificationFlashReminder';
import { OutdoorVm } from '@ohos/systemuicommon/src/main/ets/vm/OutdoorVm';
import { vibratorMgr } from '@ohos/launchercommon';
import { vibrator } from '@kit.SensorServiceKit';

/**
 * 播放器类型
 */
enum PlayingType {
  /**
   * 自定义铃声播放
   */
  NORMAL_CUSTOM = 1,
  /**
   * 系统铃声播放
   */
  SYS_TONE = 2,
}

const TAG = 'SysUI_RemindPlayManager';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const NOTIFICATION_HAPTIC_DEFAULT: string = 'haptic.common.long_press3';
const NOTIFICATION_HAPTIC: vibrator.Usage = 'notification';

export class RemindPlayManager {
  @Singleton.decorate()
  public static get instance(): RemindPlayManager {
    return new RemindPlayManager();
  }

  private static readonly QUEUE_TIMEOUT = 5000; // 队列超时5s

  private static readonly TIMEOUT = 2000;

  private static readonly INTERRUPT_TIME = 1000;

  /**
   * 播放提醒队列
   */
  private reminderPlayQueue: TaskQueue = new TaskQueue('NotificationReminder', 1);

  private normalPlayer: NotificationReminder = new NotificationReminder(PlayerType.NORMAL);

  private voipPlayer: NotificationReminder = new NotificationReminder(PlayerType.VOIP);

  private playingType?: PlayingType;

  public normalPlayStartTime: number | undefined = undefined;

  private ringParams?: PlayRemindParam; // normal通知铃声和振动参数存储Map

  private voipRingParams?: PlayRemindParam; // voip通知铃声和振动参数存储Map

  private candidates: Set<string> = new Set();

  constructor() {
    viewMgrPolicy.registerViewCallback(ViewType.DROPDOWN, {
      onTrimMemory: (level: TrimLevel): void => {
        switch (level) {
          case TrimLevel.CRITICAL:
            this.onStaticMemory();
            break;
        }
      },
    });
    CommonEventSubscribeManager.getInstance().subscribe(CommonEventSubscribeManager.KEY_PRESS_COMMON_EVENT,
      this.onKeyPress);
    this.getSystemSoundManager();
    InnerEventUtil.on(PackageCommonEvent, this.onPackageCommonEvent);
    InnerEventUtil.on(BannerSlideUpEvent, this.onBannerSlideUpEvent);
    InnerEventUtil.on(NtfCenterDropDownEvent, this.onNtfDropDown);
    InnerEventUtil.on(NotificationEvent, this.onNotificationRemoveEvent);
  }

  private getSystemSoundManager(): void {
    // systemSoundManager系统音频管理器能够在切换响铃/振动/静音时停止对应提醒方式
    // 需要提前生成systemSoundManager，避免自定义铃声播放期间切换到静音后不会停止振动
    try {
      systemSoundManager.getSystemSoundManager();
    } catch (e) {
      LogWithHa.error(log, `get system sound manager failed, ${e}`,
        NotificationExceptionCode.GET_SOUND_FAIL, e);
    }
    OutdoorVm.instance.emitter.on('outdoorRemoveApp', this.onOutdoorRemoveApp);
  }

  public destroy(): void {
    CommonEventSubscribeManager.getInstance().unsubscribe(CommonEventSubscribeManager.KEY_PRESS_COMMON_EVENT,
      this.onKeyPress);
    OutdoorVm.instance.emitter.off('outdoorRemoveApp', this.onOutdoorRemoveApp);
  }

  private onKeyPress: CommonEventListener = (data: CommonEventManager.CommonEventData): void => {
    if (!data) {
      log.showWarn(`Data invalid!`);
      return;
    }
    const keyCode: number | undefined = data.parameters?.keyCode;
    log.showInfo(`Receive onKeyPress, ${data.event}, ${keyCode}`);
    // 电源键、音量上下键停止播放自定义铃声
    if (keyCode !== KeyCode.KEYCODE_VOLUME_UP && keyCode !== KeyCode.KEYCODE_VOLUME_DOWN &&
      keyCode !== KeyCode.KEYCODE_POWER) {
      log.showInfo(`Do not deal for key ${keyCode}`);
      return;
    }
    log.showInfo(`Stop player for key press ${keyCode}`);
    this.stop(keyCode === KeyCode.KEYCODE_POWER ? StopReason.KEYPRESS_POWER_CODE : StopReason.KEYPRESS_VOLUME_CODE, []);
  };

  private onNtfDropDown = (): void => {
    this.stop(StopReason.NOTIFICATION_CENTER_DROPDOWN, []);
  };

  private addCandidate(ringParams: PlayRemindParam): void {
    if (ringParams.hashCode) {
      this.candidates.add(ringParams.hashCode);
      log.showInfo('Add candidate hashCode %{public}s, size: %{public}d', ringParams.hashCode, this.candidates.size);
    }
    if (ringParams.classification === Classification.VOIP && ringParams.bundleName !== undefined) {
      this.candidates.add(`${ringParams.bundleName}_${ringParams.appIndex ?? 0}`)
      log.showInfo('Add candidate bundleName %{public}s, size: %{public}d', ringParams.bundleName,
        this.candidates.size);
    }
  }

  private removeCandidate(ringParams: PlayRemindParam): void {
    this.removeWithLog(ringParams.hashCode);
    if (ringParams.classification === Classification.VOIP && ringParams.bundleName !== undefined) {
      this.removeWithLog(`${ringParams.bundleName}_${ringParams.appIndex ?? 0}`)
    }
  }

  private removeCandidateByStopParam(param: StopParam[]): void {
    for (let item of param) {
      this.removeWithLog(item.hashCode);
      if (item.classification === Classification.MISS_CALL && item.bundleName !== undefined) {
        this.removeWithLog(`${item.bundleName}_${item.appIndex ?? 0}`);
      }
    }
  }

  private removeWithLog(key?: string): void {
    if (key && this.candidates.has(key)) {
      this.candidates.delete(key);
      log.showInfo('Remove candidate %{public}s, size %{public}d', key, this.candidates.size);
    }
  }

  private clearCandidates(): void {
    this.candidates.clear();
    log.showInfo('Clear candidates');
  }

  private isCanceled(ringParams: PlayRemindParam): boolean {
    if (ringParams.hashCode === undefined || !this.candidates.has(ringParams.hashCode)) {
      LogWithHa.warn(log, `Is cancel return false by hashCode: ${ringParams.hashCode}`);
      return true;
    }

    if (ringParams.classification === Classification.VOIP &&
      !this.candidates.has(`${ringParams.bundleName}_${ringParams.appIndex ?? 0}`)) {
      LogWithHa.warn(log, `Is cancel return false by bundleName: ${ringParams.bundleName}`);
      return true;
    }

    return false;
  }

  /**
   * 用于处理播放自定义铃声，系统铃声和振动函数
   */
  public async play(ringParams: PlayRemindParam, classification: string): Promise<void> {
    if (!ringParams) {
      LogWithHa.error(log, `play ringParams is undefined return`);
      return;
    }
    // 声音和振动都关闭
    if (!ringParams.isTonePlayAllow && !ringParams.isVibrationAllow) {
      // 设备静音，通知支持响铃或振动，手电筒闪烁两次
      if (ringParams.isNtfFlashEnable && ringParams.flashEnableCallback?.()) {
        ringParams.startFlashCallback?.();
        new NotificationFlashReminder().flashTorchLight(ringParams.stopFlashCallback, 2);
      }
      log.showInfo(`isTonePlayAllow & isVibrationAllow all false return`);
      return;
    }
    if (notificationConfigManager.userId !== EnvVm.instance.currentUserId) {
      log.showInfo('%{public}d not in the foreground, current userId %{public}d', notificationConfigManager.userId,
        EnvVm.instance.currentUserId);
      return;
    }
    ringParams.classification = classification;
    this.addCandidate(ringParams);
    await this.getRingSettingsData(ringParams);
    // if (!ringParams.isTonePlayAllow && !ringParams.isVibrationAllow) {
    //   log.showWarn(`can not play remind after get ring setting`);
    //   this.removeCandidate(ringParams);
    //   return;
    // }
    ringParams.maintenanceInfo =
      this.getMaintenanceInfo(ringParams, classification === Classification.VOIP ? PlayerType.VOIP : PlayerType.NORMAL);
    //  自定义铃声 可以播铃声或者可以播振动且有自定义振动
    vibratorMgr.startVibration(NOTIFICATION_HAPTIC_DEFAULT, NOTIFICATION_HAPTIC, TAG);
    // 开始播放逻辑
      // 自定义铃声 可以播铃声或者可以播振动且有自定义振动
      if (ringParams.soundDescriptor && (ringParams.isTonePlayAllow || ringParams.isCustomVibration)) {
        if (classification === Classification.VOIP) {
          await this.voipPlayerPlay(ringParams);
        } else {
          await this.normalPlayerPlay(ringParams);
        }
      } else {
        // 系统自定义铃声
        await this.sysTonePlayerPlay(ringParams);
      }
  }

  private async getRingSettingsData(ringParams: PlayRemindParam): Promise<void> {
    try {
      const ringSettings =
        await SystemUICommonUtil.timeout(RingSettingManager.instance
          .getNotificationRingSetting(ringParams.systemToneType!),
          RemindPlayManager.TIMEOUT);
      const ringVolume =
        await SystemUICommonUtil.timeout(RingSettingManager.instance.getRingVolume(), RemindPlayManager.TIMEOUT);
      log.showInfo(`ring volume is ${ringVolume}`);
      StatisticsMaintenance.get().setRingVolume(ringVolume);
      ringParams.ringVolume = ringVolume;
      ringParams.isTonePlayAllow &&= (ringSettings.toneAllow && ringVolume > 0);
      ringParams.isVibrationAllow &&= (ringSettings.vibrateAllow &&
        (ringSettings.vibrateWhenRing || !ringParams.isSysTonePlayAllow));
      ringParams.isNtfTonePlayAllow &&= ringSettings.toneAllow;
    } catch (error) {
      LogWithHa.error(log,
        `${ringParams.hashCode} get ringSettings error code: ${error?.code}, message: ${error?.message}`, error);
    }
  }



  private async voipPlayerPlay(ringParams: PlayRemindParam): Promise<void> {
    const task = new TaskItem('playVoipAudio', async (): Promise<void> => {
      if (this.isCanceled(ringParams)) {
        LogWithHa.warn(log, `Play voip audio cancel because ${ringParams.bundleName} not is candidate to be played`);
        this.removeCandidate(ringParams);
        return;
      }
      this.removeCandidate(ringParams);
      this.voipRingParams = ringParams;
      log.showInfo(`voipPlayer play audio hashCode:${ringParams?.hashCode}`);
      await this.voipPlayer.play(ringParams);
    });
    task.timeout = RemindPlayManager.QUEUE_TIMEOUT;
    this.reminderPlayQueue.add(task);
  }

  private async normalPlayerPlay(ringParams: PlayRemindParam): Promise<void> {
    if (this.normalPlayStartTime === undefined) {
      log.showInfo(`normalPlayerPlay playStartDate undefined`);
      await this.startNormalPlayerPlay(ringParams);
    } else if (this.isTimeToStopPlay(ringParams)) {
      log.showInfo(`normalPlayerPlay stop and play`);
      await this.stop(StopReason.NEW_NOTIFICATION, []);
      await this.startNormalPlayerPlay(ringParams);
    }
  }

  private async startNormalPlayerPlay(ringParams: PlayRemindParam): Promise<void> {
    const task = new TaskItem('playCustomAudio', async (): Promise<void> => {
      if (this.isCanceled(ringParams)) {
        LogWithHa.warn(log, `Play custom audio cancel because ${ringParams.hashCode} not is candidate to be played`);
        this.removeCandidate(ringParams);
        return;
      }
      this.removeCandidate(ringParams);
      this.playingType = PlayingType.NORMAL_CUSTOM;
      this.ringParams = ringParams;
      this.normalPlayStartTime = Date.now();
      log.showInfo(`${TAG} normalPlayer play audio hashCode:${ringParams?.hashCode}`);
      await this.normalPlayer.play(ringParams);
    });
    task.timeout = RemindPlayManager.QUEUE_TIMEOUT;
    this.reminderPlayQueue.add(task);
  }

  private async sysTonePlayerPlay(ringParams: PlayRemindParam): Promise<void> {
    // 系统自定义铃声
    if (this.normalPlayStartTime === undefined) {
      log.showInfo(`sysTonePlayerPlay playStartDate undefined`);
      await this.startSysTonePlayerPlay(ringParams);
    } else if (this.isTimeToStopPlay(ringParams)) {
      log.showInfo(`sysTonePlayerPlay stop and play`);
      await this.stop(StopReason.NEW_NOTIFICATION, []);
      await this.startSysTonePlayerPlay(ringParams);
    }
  }

  private async startSysTonePlayerPlay(ringParams: PlayRemindParam): Promise<void> {
    const task = new TaskItem('playSysAudio', async (): Promise<void> => {
      if (this.isCanceled(ringParams)) {
        LogWithHa.warn(log, `Play sys audio cancel because ${ringParams.hashCode} not is candidate to be played`);
        this.removeCandidate(ringParams);
        return;
      }
      this.removeCandidate(ringParams);
      this.playingType = PlayingType.SYS_TONE;
      this.ringParams = ringParams;
      this.normalPlayStartTime = Date.now();
      log.showInfo(`SysTonePlayer play audio hashCode:${ringParams?.hashCode}`);
      await SysTonePlayerInstanceManager.instance().play(ringParams);
    });
    task.timeout = RemindPlayManager.QUEUE_TIMEOUT;
    this.reminderPlayQueue.add(task);
  }

  private isTimeToStopPlay(ringParams: PlayRemindParam): boolean {
    if (Math.abs(Date.now() - this.normalPlayStartTime!) > RemindPlayManager.INTERRUPT_TIME) {
      log.showInfo(`The interval is longer than one second`);
      return true;
    } else {
      log.showInfo(`the interval is less than one second`);
      RemindNotificationMaintenance.get()
        .reportRemind(RemindNotificationErrorCode.SYS_IS_PLAYING, undefined, ringParams.maintenanceInfo);
      return false;
    }
  }

  /**
   * 停止播放当前音频
   * @param reason 停止原因
   * @param param 停止参数
   */
  public async stop(reason: StopReason, params: StopParam[]): Promise<void> {
    log.showWarn(`stop play audio reason: ${reason}`);
    switch (reason) {
      case StopReason.NEW_NOTIFICATION:
        await this.stopNormalAudio(reason);
        break;
      case StopReason.NOTIFICATION_REMOVE:
        await this.stopByNtfRemove(params);
        break;
      case StopReason.DELETE_PACKAGE:
        await this.stopByPackageRemove(params);
        break;
      case StopReason.KEYPRESS_VOLUME_CODE:
        // 音量上下键，打断所有播放
        await this.stopAllAudio(StopReason.KEYPRESS_VOLUME_CODE);
        break;
      case StopReason.KEYPRESS_POWER_CODE:
        // 音量电源键，打断所有播放
        await this.stopAllAudio(StopReason.KEYPRESS_POWER_CODE);
        break;
      case StopReason.NOTIFICATION_UPDATE:
        await this.stopByUpdate(params);
        break;
      case StopReason.MISS_CALL:
        await this.stopByMissCall(params);
        break;
      case StopReason.NOTIFICATION_CENTER_DROPDOWN:
        await this.stopAllAudio(StopReason.NOTIFICATION_CENTER_DROPDOWN)
        break;
      case StopReason.BANNER_SLIDE_UP:
        await this.stopAllAudio(StopReason.BANNER_SLIDE_UP);
        break;
      case StopReason.CLOUD_REMOVE_APP:
        await this.stopByBundleName(params);
        break;
      default:
        this.removeCandidateByStopParam(params);
        LogWithHa.error(log, `unkonwn stop reason ${reason}`);
    }
  }

  private async stopByUpdate(stopParams: StopParam[]): Promise<void> {
    await this.stopByHashCode(stopParams, StopReason.NOTIFICATION_UPDATE);
  }

  private async stopByNtfRemove(stopParams: StopParam[]): Promise<void> {
    await this.stopByHashCode(stopParams, StopReason.NOTIFICATION_REMOVE);
  }

  private async stopByHashCode(stopParams: StopParam[], reason: StopReason): Promise<void> {
    this.removeCandidateByStopParam(stopParams);

    const hashCodes = new Set(stopParams.map(it => it.hashCode).filter(it => it !== undefined));
    if (hashCodes?.has(this.ringParams?.hashCode as string)) {
      // 如果当前播放的normal通知与被删除的通知是同一个通知，打断播放
      await this.stopNormalAudio(reason);
    }
    if (hashCodes?.has(this.voipRingParams?.hashCode as string)) {
      // 如果当前播放的voip通知与被删除的通知是同一个通知，打断播放
      await this.stopVoipAudio(reason);
    }
  }

  private async stopByPackageRemove(stopParams: StopParam[]): Promise<void> {
    for (const param of stopParams) {
      if (param.uid === this.ringParams?.creatorUid) {
        // 删除包，如果当前播放的normal通知属于被删除的包，打断播放
        await this.stopNormalAudio(StopReason.DELETE_PACKAGE);
      }
      if (param.uid === this.voipRingParams?.creatorUid) {
        // 删除包，如果当前播放的voip通知属于被删除的包，打断播放
        await this.stopVoipAudio(StopReason.DELETE_PACKAGE);
      }
    }
  }

  private async stopAllAudio(reason: StopReason): Promise<void> {
    this.clearCandidates();
    await this.stopNormalAudio(reason);
    await this.stopVoipAudio(reason);
  }

  private async stopByMissCall(stopParams: StopParam[]): Promise<void> {
    this.removeCandidateByStopParam(stopParams);
    for (const param of stopParams) {
      if (param.classification === Classification.MISS_CALL &&
        this.voipRingParams?.bundleName === param.bundleName && this.voipRingParams?.appIndex === param.appIndex) {
        await this.stopVoipAudio(StopReason.MISS_CALL);
      }
    }
  }

  private async stopNormalAudio(reason: StopReason): Promise<void> {
    const task = new TaskItem('stopNormalAudio', async (): Promise<void> => {
      log.showWarn(`try stop normal play by ${reason}, hashCode ${this.ringParams?.hashCode}, palyingType ${this.playingType}`);
      if (this.playingType === PlayingType.NORMAL_CUSTOM) {
        await this.normalPlayer.stop(reason);
      }
      // 由于外可能调用系统SysTonePlayer播放振动
      // 因此在每次停止播放时都要停止SysTonePlayer
      await SysTonePlayerInstanceManager.instance().stop(reason);
      this.ringParams = undefined;
      this.normalPlayStartTime = undefined;
    });
    task.timeout = RemindPlayManager.QUEUE_TIMEOUT;
    this.reminderPlayQueue.add(task);
  }

  private async stopVoipAudio(reason: StopReason): Promise<void> {
    const task = new TaskItem('stopVoipAudio', async (): Promise<void> => {
      log.showWarn(`try stop voip play by ${reason}, hashCode ${this.voipRingParams?.hashCode}`);
      await this.voipPlayer.stop(reason);
      await SysTonePlayerInstanceManager.instance().stop(reason);
      this.voipRingParams = undefined;
    });
    task.timeout = RemindPlayManager.QUEUE_TIMEOUT;
    this.reminderPlayQueue.add(task);
  }

  private async stopByBundleName(stopParams: StopParam[]): Promise<void> {
    for (const param of stopParams) {
      if (param.bundleName === this.ringParams?.bundleName) {
        // 移除应用，如果当前播放的normal通知属于被移除的应用，打断播放
        await this.stopNormalAudio(StopReason.DELETE_PACKAGE);
      }
      if (param.bundleName === this.voipRingParams?.bundleName) {
        // 移除应用，如果当前播放的voip通知属于被移除的应用，打断播放
        await this.stopVoipAudio(StopReason.DELETE_PACKAGE);
      }
    }
  }

  private getMaintenanceInfo(param: PlayRemindParam, type: PlayerType): RemindNotificationMaintenanceExt {
    const moreInfo: Record<string, Object> = {};
    if (param.traceId) {
      moreInfo.traceId = param.traceId;
    }
    return {
      ntfType: param.slotType === notificationManager.SlotType.LIVE_VIEW ? NotificationMaintenanceNtfType.LIVE_VIEW :
      NotificationMaintenanceNtfType.NORMAL,
      hashCode: param.hashCode,
      bundleName: param.bundleName,
      toneAllow: param.isTonePlayAllow,
      vibrationAllow: param.isVibrationAllow,
      customSound: Boolean(param.sound),
      errorCodes: [],
      type: type,
      moreInfo: JSON.stringify(moreInfo),
    };
  }

  /**
   * 删除应用包，自定义铃声停止
   */
  private onPackageCommonEvent = async (event: PackageCommonEvent): Promise<void> => {
    log.showInfo(`start delete package`);
    if (event.event !== PackageCommonEvent.EVENT_PACKAGE_REMOVED &&
      event.event !== PackageCommonEvent.EVENT_PACKAGE_FULL_REMOVED) {
      return;
    }
    this.stop(StopReason.DELETE_PACKAGE, [{ uid: event.uid }]);
  };

  /**
   * 删除自定义铃声通知，自定义铃声停止
   */
  private onNotificationRemoveEvent = async (event: NotificationEntryEvent | NotificationEvent): Promise<void> => {
    log.showInfo(`start delete notification`);
    if (event.eventType !== NotificationEntryEvent.EVENT_TYPE_POST_CANCEL) {
      return;
    }
    const stopParams: StopParam[] = event.notificationList?.map((ntf: NotificationBase | BaseNotification) => {
      return {
        hashCode: ntf.hashCode,
        bundleName: ntf.creatorBundleName,
        appIndex: ntf.appIndex,
        classification: ntf.classification
      } as StopParam
    }) ?? [];
    this.stop(StopReason.NOTIFICATION_REMOVE, stopParams);
  };

  /**
   * 上划横幅通知，铃声停止
   */
  private onBannerSlideUpEvent = (): void => {
    log.showInfo(`Banner Slides Up`);
    this.stop(StopReason.BANNER_SLIDE_UP, []);
  };

  /**
   * 内存回收动作
   */
  private onStaticMemory = async (): Promise<void> => {
    this.normalPlayer.onStaticMemory();
    this.voipPlayer.onStaticMemory();
  };

  /**
   * 云端模式移除自定义应用，停止通知
   */
  private onOutdoorRemoveApp = (bundleNameList: string[]): void => {
    log.showInfo('onOutdoorRemoveApp');
    const stopParams: StopParam[] = bundleNameList.map(bundleName => {
      return {
        bundleName,
      } as StopParam;
    });
    this.stop(StopReason.CLOUD_REMOVE_APP, stopParams);
  };
}