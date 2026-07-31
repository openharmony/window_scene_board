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

import type { HostType } from '@ohos/systemuicommon';
import audio from '@ohos.multimedia.audio';

export default class Constants {
  public static readonly DEFAULT_MAX_VOLUME: number = 15;
  public static readonly PC_DEFAULT_MAX_VOLUME: number = 15;
  public static readonly DEFAULT_MIN_VOLUME: number = 0;
  public static readonly DEFAULT_VOLUME_INVALID: number = -1;
  public static readonly DEFAULT_MUTE_STATUS: boolean = false;
  public static readonly DEFAULT_SHOW_STATUS: boolean = true;
  public static readonly HOLD_SHOW: boolean = false;
  public static readonly HOLD_TIME: number = 2000;
  public static readonly RTL_KEY_FRAMES: number = 3;
  public static readonly DEFAULT_POPUP_FONT_SIZE: number = 14;
  public static readonly DEFAULT_LOTTIE_ICON_COLOR: number = 0x80000000;
  public static readonly ICON_MARGIN_BOTTOM: number = 11;
  public static readonly SET_VOLUME_DELAY_TIME: number = 100;
  public static readonly VOLUME_BAR_TIMEOUT: number = 2000;
  public static readonly VOLUME_DIALOG_TIMEOUT: number = 5000;
  public static readonly VIBRATION_DELAY_TIME: number = 220;
  public static readonly ACCESSIBILITY_SECONDS: number = 5;
  public static readonly SYMBOL_GLYPH_FONT_SIZE: string = '18vp';
  public static readonly SYMBOL_PHONE_FILL: Resource = $r('sys.symbol.phone_fill');
  public static readonly SYMBOL_ALARM_FILL: Resource = $r('sys.symbol.alarm_fill');
  public static readonly SYMBOL_VOICE_FILL: Resource = $r('sys.symbol.Voice_fill');
  public static readonly SYMBOL_BELL_SLASH_FILL: Resource = $r('sys.symbol.bell_slash_fill');
  public static readonly SYMBOL_BELL_FILL: Resource = $r('sys.symbol.bell_fill');
  public static readonly SYMBOL_RECTANGLE_PORTRAIT_WAVE_2_FILL: Resource = $r('sys.symbol.rectangle_portrait_wave_2_fill');
  public static readonly SYMBOL_SPEAKER_WAVE_3_FILL: Resource = $r('sys.symbol.speaker_wave_3_fill');
  public static readonly SYMBOL_SPEAKER_WAVE_2_FILL: Resource = $r('sys.symbol.speaker_wave_2_fill');
  public static readonly SYMBOL_SPEAKER_WAVE_1_FILL: Resource = $r('sys.symbol.speaker_wave_1_fill');
  public static readonly VOLUME_TYPE_WEIGHTS =
    [audio.AudioVolumeType.VOICE_CALL, audio.AudioVolumeType.RINGTONE,
      audio.AudioVolumeType.ALARM,
      audio.AudioVolumeType.MEDIA, audio.AudioVolumeType.ACCESSIBILITY];
  public static readonly PANEL_CHANNELS =
    [audio.AudioVolumeType.VOICE_CALL, audio.AudioVolumeType.ALARM, audio.AudioVolumeType.RINGTONE,
      audio.AudioVolumeType.MEDIA];
  public static readonly MAX_FORCE_VOLUME_CONTROL_TYPE_SECONDS: number = 10;
  public static readonly RESPONSE_REGION_FOR_VOLUME_TOP: number = 16;
  public static readonly RESPONSE_REGION_FOR_VOLUME_BOTTOM: number = 22;
  public static readonly VIBRATION_INTENSITY_FOR_TOP: number = 100;
  public static readonly VIBRATION_INTENSITY_FOR_DOWN: number = 40;
  public static readonly MOVE_DISTANCE_THRESHOLD: number = 2;
  public static readonly VOLUME_BAR_STRETCH_WIDTH_RATIO: number = 0.9;
  public static readonly VOLUME_IS_ACTIVE_TIMEOUT: number = 200;
}

export const SYSTEM_VOLUME_TYPE = 6;

export interface VolumeInfo {
  volumeType: audio.AudioVolumeType;
  volume: number;
  maxVolume: number;
  minVolume: number;
  lastVolume: number;
  isMute: boolean;
  isActive: boolean;
  updateUi: boolean;
  hostType?: HostType;
}

export interface VolumeChannel {
  volumeType: audio.AudioVolumeType;
  channelId: string;
  channelName: Resource;
}

export interface VolumeRingModeParam {
  ringerMode: audio.AudioRingMode;
  volumeInfo?: VolumeInfo;
}

export class VolumeAnimType {
  public static readonly TYPE_NONE = 0; // 0
  public static readonly TYPE_IN = VolumeAnimType.TYPE_NONE + 1; // 1
  public static readonly TYPE_OUT = VolumeAnimType.TYPE_IN + 1; // 2
  public static readonly TYPE_THICK_TO_THIN = VolumeAnimType.TYPE_OUT + 1; // 3
  public static readonly TYPE_KEY_DOWN_THIN = VolumeAnimType.TYPE_THICK_TO_THIN + 1; // 4
  public static readonly TYPE_KEY_UP_THIN = VolumeAnimType.TYPE_KEY_DOWN_THIN + 1; // 5
  public static readonly TYPE_THIN_TO_THICK = VolumeAnimType.TYPE_KEY_UP_THIN + 1; // 6
  public static readonly TYPE_THIN_TO_THICK_STOP = VolumeAnimType.TYPE_THIN_TO_THICK + 1; // 7
  public static readonly TYPE_THICK_DOWN_START = VolumeAnimType.TYPE_THIN_TO_THICK_STOP + 1; // 8
  public static readonly TYPE_THICK_DOWN_STOP = VolumeAnimType.TYPE_THICK_DOWN_START + 1; // 9
  public static readonly TYPE_ALL_CONTROL_START = VolumeAnimType.TYPE_THICK_DOWN_STOP + 1; // 10
  public static readonly TYPE_ALL_CONTROL_IN = VolumeAnimType.TYPE_ALL_CONTROL_START + 1; // 11
  public static readonly TYPE_ALL_CONTROL_OUT = VolumeAnimType.TYPE_ALL_CONTROL_IN + 1; // 12
}

export class AnimViewData {
  @Track public useSliderIcon: boolean = false;
  @Track public sliderIcon?: Resource;
}

export enum SCBFoldState {
  UNKNOWN = 0,
  HALF_FOLDED_VIRTUAL_KEYBOARD,
  HALF_FOLDED_PHYSICAL_KEYBOARD,
  HALF_FOLDED,
  UNFOLDED_VERTICAL,
  UNFOLDED_HORIZONTAL
};

export enum VolumeBarAlignRule {
  DEFAULT = 'default',
  TOP = 'top',
  DOWN = 'down',
};
