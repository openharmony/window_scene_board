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

export default class Constants {
  public static WINDOW_MARGIN_LEFT = 1309;
  public static WINDOW_MARGIN_TOP = 60;
  public static readonly WINDOW_WIDTH: number = 360;
  public static readonly WINDOW_HEIGHT: number = 230;
  public static readonly HAD_WINDOW_HEIGHT: number = 230;
  public static readonly WINDOW_SUB_TITLE_HEIGHT: number = 32;
  public static readonly SETTING_CARD_ITEM_HEIGHT: number = 44;
  public static readonly DEVICE_ITEM_HEIGHT: number = 42;
  public static readonly CARD_DEFAULT_HEIGHT: number = 0;
  public static readonly TITLE_HEIGHT: number = 41;
  public static readonly CARD_CALL_DEFAULT_HEIGHT: number = 82;
  public static readonly CARD_CALL_HEIGHT: number = 91;
  public static readonly CARD_NOISE_HEIGHT: number = 40;
  public static readonly CARD_MORE_GAP: number = 2;

  public static DEFAULT_WINDOW_WIDTH = 1706;

  public static DEFAULT_WIFI_OPEN_STATUS: boolean = false;
  public static DEFAULT_WIFI_NAME: string = 'WLAN';
  public static DEFAULT_WIFI_INFO: number = 0;
  public static DEFAULT_WIFI_STATUS: boolean = false;
  public static DEFAULT_WIFI_RSSI: number = -200;

  public static DEFAULT_MAX_VOLUME = 15;
  public static DEFAULT_MIN_VOLUME = 0;
  public static DEFAULT_MUTE_STATUS = false;

  public static WINDOW_NAME = 'sound';
  public static readonly REQUEST_FOCUS_MENU = 'request_focus_menu_sound';
  public static DEFAULT_DEVICE_ID = 1;
  public static DEFAULT_DEVICE_CHANGE_ENABLE = true;
  public static INVALID_MAC = 'INVALID_MAC';

  public static SOUND_SETTINGS_HORIZONTAL_MARGIN = 18;
  public static SOUND_SETTINGS_TOP_MARGIN = 9;
  public static SOUND_SETTINGS_BOTTOM_MARGIN = 7;
  public static SOUND_SETTINGS_TEXT_HEIGHT = 24;

  public static SCENE_BOARD_BUNDLE_NAME = 'com.ohos.sceneboard';
}

export class AudioConstants {
  public static RINGTONE_VOLUME_TYPE = 6;

  public static readonly DEFAULT_DEVICE_ID = -1;

  public static readonly DEFAULT_MIN_VOLUME = 0;
  public static readonly DEFAULT_CUR_VOLUME = 0;
  public static readonly DEFAULT_MAX_VOLUME = 15;
  public static readonly DEFAULT_VOLUME_STEP = 1;
  public static readonly DEFAULT_MUTE_STATE = false;

  public static VALUE_DISABLE = '0';
  public static VALUE_ENABLE = '1';
}

export interface DeviceInfo {
  id: number;
  name: string;
  address: string;
  deviceRole: number;
  deviceType: number;
  viewId?: number;
}

export enum AudioVolumeType {
  VOICE_CALL = 0,
  RINGTONE = 2,
  MEDIA = 3,
}

export enum AudioDeviceType {
  INVALID = 0,
  EARPIECE = 1,
  SPEAKER = 2,
  WIRED_HEADSET = 3,
  WIRED_HEADPHONES = 4,
  BLUETOOTH_SCO = 7,
  BLUETOOTH_A2DP = 8,
  MIC = 15,
  USB_HEADSET = 22,
  DISPLAY_PORT = 23,
  REMOTE_CAST = 24
}

export enum ActiveDeviceType {
  INVALID = 0,
  EARPIECE = 1,
  SPEAKER = 2,
  WIRED_HEADSET = 3,
  WIRED_HEADPHONES = 4,
  BLUETOOTH_SCO = 7,
  BLUETOOTH_A2DP = 8,
  MIC = 15,
  USB_HEADSET = 22,
  DISPLAY_PORT = 23,
  REMOTE_CAST = 24
}

export enum MenuType {
  INVAILD_MENU = 0,
  MUTE_MENU = 1,
  SLIDER_BAR = 2,
  SETTINGS_MENU = 3,
}

export interface InputDeviceInfo {
  id: number;
  name: string;
  deviceSource: string;
  deviceChangeType: string;
}

export const VOLUME_CHANGE_EVENT = 'volumeChangeEvent';

export interface StateChangeListener { onStateChange: Function }

export interface AudioDeviceChangeListener { onAudioDeviceChange: Function }

export interface AudioVolumeChangeListener { onAudioVolumeChange: (volume: number) => void }

export interface InputDeviceChangeListener { onInputDeviceChange: Function }

export type FocusItemType = DeviceInfo | MenuType;

export const AI_NOT_SUPPORT = 'AI_SOUND_NOT_SUPPORT';

export class DNDConstants {
  public static FOCUS_MODE_PROFILE: string = 'focus_mode_profile';
  public static FOCUS_MODE_ENABLED = 'focus_mode_enable';
  public static FOCUS_MODE_TIMER = 'focus_mode_timer';
  public static FOCUS_MODE_MANUAL_ENABLE = 'focus_mode_manual_enable';
  public static FOCUS_MODE_CALL_MESSAGE_POLICY = 'focus_mode_call_message_policy';
  public static DO_NOT_DISTURB_APP_SELECTED_DATA: string = 'settings.sound.do_not_disturb.app_selected_data';

  public static EMPTY_STRING = '';
  public static NOT_DISTURB_VALUE_DISABLE = '0';
  public static NOT_DISTURB_VALUE_ENABLE = '1';
  public static NO_TIMER: number = -1;

  public static INDEX_HOUR = 0;
  public static INDEX_MIN = 1;
  public static ONE_DAY = 1;
  public static ONE_DAY_HOUR = 24;
  public static DAYS_OF_WEEK_COUNT = 7;

  public static CLOCK_BUNDLE_NAME: string = 'com.ohos.clock';
  public static HUAWEISHARE_BUNDLE_NAME: string = 'com.ohos.instantshare';
}