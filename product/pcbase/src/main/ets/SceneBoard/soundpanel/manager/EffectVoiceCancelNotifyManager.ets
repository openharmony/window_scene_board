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

import systemTimer from '@ohos.systemTimer';
import notificationManager from '@ohos.notificationManager';
import type NtfMgr from '@ohos.notificationManager';
import { CheckEmptyUtils, CommonUtils, LogDomain, Logger } from '@ohos/basicutils';
import { BusinessError } from '@ohos.base';
import { GlobalContext, ResourceManager } from '@ohos/frameworkwrapper';
import { image } from '@kit.ImageKit';
import osAccount from '@ohos.account.osAccount';
import { RTLUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';
import audioEffectSettingModel, {
  AudioEffectProp,
  voiceCancelStatusChangeListener
} from '../../microphonepanel/model/AudioEffectSettingModel';
import XmlParseUtil from '../../microphonepanel/util/XmlParseUtil';
import {
  AudioOutputChangeListener4V,
  AudioSoundViewModel,
  AudioRendererStream,
  AudioUsage,
  AudioRendererState
} from '../viewmodel/AudioSoundViewModel';
import { PanelManager, PanelManagerBase, PanelStateChangeListener } from './PanelManager';
import Constants, { AudioConstants } from '../common/Constants';

const TAG: string = 'EffectVoiceCancelNotifyManager';
const log = Logger.getLogHelper(LogDomain.SCB);
const HIDE_TITLE_MODE: string = '012';
const NOTIFICATION_ID = 2122;
const NOTIFICATION_TIME_GAP = 6;

enum NotifyType {
  EFFECT_CANCEL,
  EFFECT_EXTRACT,
  AUTO_CLOSE
}

/**
 * AI声音消除音效通知
 */
export class EffectVoiceCancelNotifyManager implements PanelManagerBase {
  private static instance: EffectVoiceCancelNotifyManager;
  private effectEnable: boolean = XmlParseUtil.getVocalCancelSupport();
  private readonly EFFECT_ENABLE_USAGE: AudioUsage[] = [AudioUsage.STREAM_USAGE_UNKNOWN, AudioUsage.STREAM_USAGE_MUSIC,
    AudioUsage.STREAM_USAGE_VOICE_MESSAGE, AudioUsage.STREAM_USAGE_ACCESSIBILITY, AudioUsage.STREAM_USAGE_MOVIE,
    AudioUsage.STREAM_USAGE_AUDIOBOOK, AudioUsage.STREAM_USAGE_VOICE_CALL_ASSISTANT];
  private timerId: number = AudioConstants.DEFAULT_DEVICE_ID;
  private isTimerRunning: boolean = false;
  private voiceCancelStatus: string = AudioEffectProp.EFFECT_DEFAULT;
  private beforeVoiceCancelStatus: string = AudioEffectProp.EFFECT_DEFAULT;
  private isMediaStreamRunning: boolean = false;
  private shouldNotifyAutoClose: boolean = false;

  public static getInstance(): EffectVoiceCancelNotifyManager {
    if (EffectVoiceCancelNotifyManager.instance) {
      return EffectVoiceCancelNotifyManager.instance;
    }
    EffectVoiceCancelNotifyManager.instance = new EffectVoiceCancelNotifyManager();
    return EffectVoiceCancelNotifyManager.instance;
  }

  public init(): void {
    if (!this.effectEnable) {
      return;
    }
    this.createAlarmTimer();
    audioEffectSettingModel.registerVoiceCancelStatusChangeListener(this.voiceCancelStatusChangeListener);
    AudioSoundViewModel.getInstance().registerOutputChangeListener(this.audioOutputChangeListener, TAG);
    PanelManager.getInstance().registerPanelStateChangeListener(this.panelStateChangeListener, TAG);
  }

  public destroy(): void {
    if (!this.effectEnable) {
      return;
    }
    this.destroyAlarmTimer()
    audioEffectSettingModel.unregisterVoiceCancelStatusChangeListener(this.voiceCancelStatusChangeListener);
    AudioSoundViewModel.getInstance().unregisterOutputChangeListener(this.audioOutputChangeListener, TAG);
    PanelManager.getInstance().unregisterPanelStateChangeListener(this.panelStateChangeListener, TAG);
  }

  private async createAlarmTimer(): Promise<void> {
    try {
      this.timerId = await systemTimer.createTimer({
        type: systemTimer.TIMER_TYPE_EXACT | systemTimer.TIMER_TYPE_WAKEUP,
        repeat: false,
        callback: () => {
          log.info(TAG, `time to auto close effect`);
          this.shouldNotifyAutoClose = true;
          audioEffectSettingModel.setVoiceCancelStatus(AudioEffectProp.EFFECT_DEFAULT);
        }
      });
      log.info(TAG, `createAlarmTimer create timer alarm success`);
    } catch (error) {
      log.error(TAG, `createAlarmTimer create timer alarm error: ${error?.message}`);
    }
  }

  private async destroyAlarmTimer(): Promise<void> {
    try {
      await systemTimer.destroyTimer(this.timerId);
      this.timerId = AudioConstants.DEFAULT_DEVICE_ID;
      log.info(TAG, `destroyAlarmTimer destroy timer alarm success`);
    } catch (error) {
      log.error(TAG, `destroyAlarmTimer destroy timer alarm error: ${error?.message}`);
    }
  }

  private async startTimeAlarm(alarmtime: number): Promise<void> {
    if (this.timerId === AudioConstants.DEFAULT_DEVICE_ID) {
      await this.createAlarmTimer();
    }
    try {
      await systemTimer.startTimer(this.timerId, alarmtime as number);
      this.isTimerRunning = true;
      log.info(TAG, `startTimeAlarm start timer alarm success`);
    } catch (error) {
      log.error(TAG, `startTimeAlarm start timer alarm error: ${error?.message}`);
    }
  }

  private stopAlarmSelf(timerId: number): void {
    if (timerId === AudioConstants.DEFAULT_DEVICE_ID) {
      return;
    }
    try {
      systemTimer.stopTimer(timerId);
      this.isTimerRunning = false;
      log.info(TAG, `stopAlarmSelf stop timer alarm success`);
    } catch (error) {
      log.error(TAG, `stopAlarmSelf stop timer alarm error: ${error?.message}`);
    }
  }

  private voiceCancelStatusChangeListener: voiceCancelStatusChangeListener = {
    onVoiceCancelStatusChange: (effectProp: string) => {
      log.showInfo(TAG, `voiceCancelStatusChangeListener onVoiceCancelStatusChange info: ` +
        `${effectProp} - ${this.voiceCancelStatus} - ${this.beforeVoiceCancelStatus}`);
      if (this.voiceCancelStatus === effectProp) {
        // 若音效未发生变更，跳过此业务
        return;
      }
      this.beforeVoiceCancelStatus = this.voiceCancelStatus;
      this.voiceCancelStatus = effectProp;
      if (effectProp === AudioEffectProp.EFFECT_CANCEL) {
        this.publishNotification(NotifyType.EFFECT_CANCEL, effectProp);
      } else if (effectProp === AudioEffectProp.EFFECT_EXTRACT) {
        this.publishNotification(NotifyType.EFFECT_EXTRACT, effectProp);
      } else {
        this.cancelNotification().then(() => {
          if (this.shouldNotifyAutoClose) {
            this.shouldNotifyAutoClose = false;
            this.publishNotification(NotifyType.AUTO_CLOSE, this.beforeVoiceCancelStatus);
          }
        });
      }
      this.processAutoCloseEffect();
    }
  }

  private audioOutputChangeListener: AudioOutputChangeListener4V = {
    onAudioRendererStreamChange: (rendererInfoArray: AudioRendererStream[]) => {
      let hasMediaStreamRunning: boolean = false;
      for (const rendererInfo of rendererInfoArray) {
        if (rendererInfo.rendererState === AudioRendererState.STATE_RUNNING &&
        this.EFFECT_ENABLE_USAGE.includes(rendererInfo.usage)) {
          hasMediaStreamRunning = true;
          break;
        }
      }
      if (this.isMediaStreamRunning === hasMediaStreamRunning) {
        // 若状态未发生变更，跳过此业务
        return;
      }
      this.isMediaStreamRunning = hasMediaStreamRunning;
      log.showInfo(TAG, `audioOutputChangeListener onAudioRendererStreamChange res: ${hasMediaStreamRunning}`);
      this.processAutoCloseEffect();
    }
  };

  private panelStateChangeListener: PanelStateChangeListener = {
    onLanguageChange: () => {
      log.info(TAG, 'panelStateChangeListener onLanguageChange callback');
      // 系统语言更新时，重新静默更新通知
      this.republishNotification();
    }
  };

  private async republishNotification(): Promise<void> {
    if (!await this.isUserProcessMatching()) {
      log.warn(TAG, `republishNotification fail, user not match process`);
      return;
    }
    let isEffectNotificationActive: boolean = false;
    try {
      let notifyList: notificationManager.NotificationRequest[] = await notificationManager.getActiveNotifications();
      for (const notify of notifyList) {
        if (notify.id === NOTIFICATION_ID && notify.creatorBundleName === Constants.SCENE_BOARD_BUNDLE_NAME) {
          isEffectNotificationActive = true;
          break;
        }
      }
    } catch (e) {
      log.showError(TAG, `isNotifyActive getActiveNotifications error: ${e?.message}`);
    }
    if (!isEffectNotificationActive) {
      log.warn(TAG, `republishNotification fail, not exist active effect notification`);
      return;
    }
    if (this.voiceCancelStatus === AudioEffectProp.EFFECT_CANCEL) {
      this.publishNotification(NotifyType.EFFECT_CANCEL, this.voiceCancelStatus, true);
    } else if (this.voiceCancelStatus === AudioEffectProp.EFFECT_EXTRACT) {
      this.publishNotification(NotifyType.EFFECT_EXTRACT, this.voiceCancelStatus, true);
    } else {
      this.publishNotification(NotifyType.AUTO_CLOSE, this.beforeVoiceCancelStatus, true);
    }
  }

  private async isUserProcessMatching(): Promise<boolean> {
    let isUserProcessMatching: boolean = false;
    try {
      let osAccountManager: osAccount.AccountManager = osAccount.getAccountManager();
      const currentId: number = await osAccountManager.getOsAccountLocalId();
      const currentForegroundId: number = await osAccountManager.getForegroundOsAccountLocalId();
      isUserProcessMatching = currentId === currentForegroundId;
      log.info(TAG, `isUserProcessMatching get user foreground status success: ${isUserProcessMatching}`);
    } catch(e) {
      log.showError(TAG, `isUserProcessMatching get user process match error: ${e?.message}`);
    }
    return isUserProcessMatching;
  }

  /**
   * @param type 所需的通知类型
   * @param effectProp 当前音效状态
   * @param isAlertOnce 重复通知时，是否静默通知
   */
  private async publishNotification(type: NotifyType, effectProp: string, isAlertOnce: boolean = false): Promise<void> {
    if (effectProp === AudioEffectProp.EFFECT_DEFAULT) {
      // 无音效不执行发送通知
      return;
    }
    try {
      await notificationManager.publish(await this.getNotificationRequest(type, effectProp, isAlertOnce));
      log.info(TAG, 'publishNotification success');
    } catch (e) {
      log.error(TAG, `publishNotification error: ${e?.message}`);
    }
  }

  /**
   * 获取通知的请求体
   * @param type 所需的通知类型
   * @param effectProp 当前音效状态
   * @param isAlertOnce 重复通知时，是否静默通知
   *
   * @returns 发送通知所需的请求体
   */
  private async getNotificationRequest(type: NotifyType, effectProp: string,
    isAlertOnce: boolean = false): Promise<NtfMgr.NotificationRequest> {
    const isCancel: boolean = effectProp === AudioEffectProp.EFFECT_CANCEL;
    let title: string = '';
    let text: string = '';
    const head: string = ResourceManager.getInstance().getStringByName(isCancel ? 'voice_cancel' : 'voice_extract');
    let slotType: notificationManager.SlotType = notificationManager.SlotType.SERVICE_INFORMATION;
    if (type === NotifyType.AUTO_CLOSE) {
      title = ResourceManager.getInstance().getStringByName('voice_default_title', head);
      text = ResourceManager.getInstance().getStringByName('voice_default_desc', head, head);
      slotType = notificationManager.SlotType.OTHER_TYPES;
    } else {
      title = ResourceManager.getInstance().getStringByName('voice_effect_title', head);
      text = ResourceManager.getInstance().getStringByName(
        type === NotifyType.EFFECT_CANCEL ? 'voice_cancel_desc' : 'voice_extract_desc');
    }
    let notificationRequest: NtfMgr.NotificationRequest = {
      id: NOTIFICATION_ID,
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: title,
          text: text,
        }
      },
      notificationSlotType: slotType,
      isAlertOnce: isAlertOnce,
      extraInfo: {
        'creatorBundleName': Constants.SCENE_BOARD_BUNDLE_NAME,
        'appName': '',
        'hideTitleCategory': HIDE_TITLE_MODE
      },
      notificationControlFlags: 1 << 9 | 1 << 0
    };

    const pixelMap = await this.getRawPixelMap(isCancel ? 'notify_pc_voice_cancel.png' : 'notify_pc_voice_booster.png');
    if (!CheckEmptyUtils.isEmpty(pixelMap)) {
      notificationRequest.smallIcon = pixelMap;
    }

    return notificationRequest;
  }

  private async cancelNotification(): Promise<void> {
    try {
      await notificationManager.cancel(NOTIFICATION_ID);
      log.info(TAG, 'cancelNotification success');
    } catch (e) {
      log.error(TAG, `cancelNotification error: ${e?.message}`);
    }
  }

  /**
   * 从rawfile路径获取PixelMap
   *
   * @param path 图片资源rawfile路径
   * @returns PixelMap对象
   */
  private async getRawPixelMap(path: string): Promise<image.PixelMap | undefined> {
    let pixelMap: image.PixelMap | undefined;
    let imageSource: image.ImageSource | undefined;
    if (CommonUtils.isEmpty(path)) {
      return pixelMap;
    }
    let context = GlobalContext.getContext();
    try {
      const content = await context?.resourceManager?.getRawFileContent(path);
      if (CheckEmptyUtils.isEmpty(content)) {
        log.showError(TAG, 'getRawPixelMap: content is null');
        return pixelMap;
      }
      let buffer = content?.buffer;
      imageSource = image.createImageSource(buffer);
      if (!CheckEmptyUtils.isEmpty(imageSource)) {
        let decodingOptions: image.DecodingOptions = {
          editable: false,
          desiredPixelFormat: image.PixelMapFormat.RGBA_8888,
        };
        pixelMap = await imageSource.createPixelMap(decodingOptions);
      }
      pixelMap?.flipSync(RTLUtil.isRTL(), false);
    } catch (err) {
      log.showError(TAG, `getRawPixelMap: err:${err?.message}`);
    } finally {
      this.releaseImageSource(imageSource);
    }
    return pixelMap;
  }

  private releaseImageSource(imageSource: image.ImageSource | undefined): void {
    if (!CheckEmptyUtils.isEmpty(imageSource)) {
      imageSource?.release((err: BusinessError) => {
        if (err) {
          log.showError(TAG, `${err.message} releaseImageSource release imageSource object`);
        }
      });
    }
  }

  private async processAutoCloseEffect(): Promise<void> {
    if (!await this.isUserProcessMatching()) {
      // 适配音频框架renderer监听不隔离用户，用户处于后台时忽略计时操作，避免A用户音频流影响B用户计时状态
      return;
    }
    if (this.voiceCancelStatus === AudioEffectProp.EFFECT_DEFAULT || this.isMediaStreamRunning) {
      // 音效未开启或者当前存在运行的媒体流，停止计时
      this.stopAutoCloseTimer();
    } else {
      this.reStartAutoCloseTimer();
    }
  }

  private reStartAutoCloseTimer(): void {
    if (this.isTimerRunning) {
      log.warn(TAG, `reStartAutoCloseTimer already start timer alarm`);
      return;
    }
    let targetTimer: Date = new Date();
    targetTimer.setHours(targetTimer.getHours() + NOTIFICATION_TIME_GAP);
    this.startTimeAlarm(targetTimer.getTime());
  }

  private stopAutoCloseTimer(): void {
    if (!this.isTimerRunning) {
      log.warn(TAG, `stopAutoCloseTimer already stop timer alarm`);
      return;
    }
    this.stopAlarmSelf(this.timerId);
  }
}
