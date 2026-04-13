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

export default class Constants {
  // support LottieComponent module names
  static readonly CONTROL_CENTER = 'status_bar_control_center';
  static readonly NOTIFICATION_CENTER = 'status_bar_notification_panel';
  static readonly SOUND_COMPONENT = 'status_bar_sound_panel';

  // control center quick toggle animate names
  static readonly AUTO_ROTATE_COMPONENT_OPEN = 'auto_rotate_open';
  static readonly AUTO_ROTATE_COMPONENT_CLOSE = 'auto_rotate_close';

  static readonly DEFAULT_MAX_VOLUME = 15;
  static readonly DEFAULT_MIN_VOLUME = 0;
  static readonly DEFAULT_MUTE_STATUS = false;

  static readonly FRAMES_INTERVAL: number = 1000;
  static readonly FRAMES_CONTROL_CENTER: number = 46;
  static readonly FRAMES_SOUND: number = 50;
  static readonly FRAMES_NOTIFICATION_UNREAD: number = 47;
  static readonly FRAMES_NOTIFICATION_READ: number = 42;
}

export enum AudioVolumeType {
  VOICE_CALL = 0,
  RINGTONE = 2,
  MEDIA = 3,
}

export enum HostType {
  UNKNOWN_HOST = -1,
  AUDIO_SYSTEM = 0,
  VOLUME_PANEL = 1,
  SOUND_PANEL = 2
}

export interface VolumeInfo {
  volumeType: AudioVolumeType;
  volume: number;
  isMute: boolean;
  updateUi: boolean;
  hostType?: HostType;
}