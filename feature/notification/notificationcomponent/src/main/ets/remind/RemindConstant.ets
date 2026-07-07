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
import { audio } from '@kit.AudioKit';
import { resourceManager } from '@kit.LocalizationKit';
import { common } from '@kit.AbilityKit';
import { notificationManager } from '@kit.NotificationKit';
import {
  RemindNotificationMaintenanceExt
} from '@ohos/systemuicommon/src/main/ets/maintenance/RemindNotificationMaintenance';

export const DEFAULT_PLAY_TIME: number = 30000;

/**
 * 铃声播放间隔时长
 */
export const TIMEOUT_DURATION = 60000;

export enum PlayerType {
  NORMAL = 0,
  VOIP = 1,
}

export enum StopReason {
  DEFAULT = 0,
  NEW_NOTIFICATION = 1,
  NOTIFICATION_REMOVE = 2,
  DELETE_PACKAGE = 3,
  KEYPRESS_VOLUME_CODE = 4,
  KEYPRESS_POWER_CODE = 5,
  NOTIFICATION_UPDATE = 6,
  MISS_CALL = 7,
  TIMEOUT = 8,
  NOTIFICATION_CENTER_DROPDOWN = 9,
  BANNER_SLIDE_UP = 10,
  CLOUD_REMOVE_APP = 11,
}

export enum Classification {
  VOIP = 'ANS_VOIP',
  MISS_CALL = 'ANS_MISS_CALL',
}

export interface StopParam {
  hashCode?: string,
  classification?: string,
  bundleName?: string,
  appIndex?: number,
  uid?: number,
}

/**
 * 铃声和振动Map
 */
export class PlayRemindParam {
  public context?: common.Context;
  public isTonePlayAllow?: boolean;
  public isVibrationAllow?: boolean;
  public soundDescriptor?: resourceManager.RawFileDescriptor;
  public sound?: string;
  public systemToneType?: number;
  public bundleName?: string;
  public slotType?: notificationManager.SlotType;
  public ntfId?: number;
  public creatorUid?: number;
  public hashCode?: string;
  public isWeak?: boolean;
  public isCustomVibration?: boolean;
  public isNtfTonePlayAllow?: boolean;
  public soundDuration?: number;
  public isSysTonePlayAllow?: boolean;
  public isDeliverPush?: boolean;
  public channelId?: string;
  public appIndex?: number;
  public ringVolume?: number;
  public classification?: string;
  public maintenanceInfo?: RemindNotificationMaintenanceExt;
  public traceId?: string;
  public isNtfFlashEnable?: boolean;
  public startFlashCallback?: () => void;
  public stopFlashCallback?: () => void;
  public flashEnableCallback?: () => boolean;
}

/**
 * 自定义铃声播放时参数
 */
export class PlayingParam {
  /* 实际开始播放时间戳 */
  public startTime: number = 0;
  /* 实际结束播放时间戳 */
  public endTime: number = 0;
  /* 剩余播放时长 */
  public remainTime: number = DEFAULT_PLAY_TIME;
  /* 铃声音量 */
  public ringVolume: number = 0;
  /* 是否需要设置播放源 */
  public needSetSrc: boolean = false;
  /* 播放次数 */
  public playTimes: number = 0;
  /* 通知本身是否允许自定义铃声，设置音量时使用 */
  public customToneAllow: boolean = true;
  /* 是否允许自定义振动 */
  public customVibrateAllow: boolean = true;
  /* 使用音频流 */
  public usage: audio.StreamUsage = audio.StreamUsage.STREAM_USAGE_UNKNOWN;
}