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
  public static readonly WINDOW_MARGIN_LEFT = 1309;
  public static readonly WINDOW_MARGIN_TOP = 60;
  public static readonly WINDOW_WIDTH: number = 360;
  public static readonly WINDOW_HEIGHT: number = 237;
  public static readonly HAD_WINDOW_HEIGHT: number = 234;
  public static readonly DEFAULT_VOLUME_INVALID: number = -1;
  public static readonly DEFAULT_WINDOW_WIDTH = 1706;
  public static readonly DEFAULT_WIFI_OPEN_STATUS: boolean = false;
  public static readonly DEFAULT_WIFI_NAME: string = 'WLAN';
  public static readonly DEFAULT_WIFI_INFO: number = 0;
  public static readonly DEFAULT_WIFI_STATUS: boolean = false;
  public static readonly DEFAULT_WIFI_RSSI: number = -200;
  public static readonly DEFAULT_MAX_VOLUME = 15;
  public static readonly DEFAULT_MIN_VOLUME = 0;
  public static readonly DEFAULT_MUTE_STATUS = false;
  public static readonly WINDOW_NAME = 'sound';
  public static readonly REQUEST_FOCUS_MENU = 'request_focus_menu_sound';
  public static readonly DEFAULT_DEVICE_ID = 1;
}

export interface DeviceInfo {
  id: number;
  name: string;
  address: string;
  deviceRole: number;
  deviceType: number;
  viewId?: number;
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
  REMOTE_CAST = 24,
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
  REMOTE_CAST = 24,
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
