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
  public static BATTERY_LEVEL_LOW = 20;
  public static BATTERY_LEVEL_VERY_LOW = 10;
  public static BATTERY_LEVEL_LOW_TO_SHUTDOWN = 2;
  public static PERCENT_NUMBER = 100;
  public static BATTERY_LEVEL_LOW_TIMEOUT = 30;
  public static FONT_SIZE_MAX_SCALE = 1.45;
  public static readonly IMAGE_EDGE = 0.5;
  public static readonly BATTERY_RED = '#FF3320';
  public static readonly BATTERY_ORANGE = '#FF9B1A';
  public static readonly BRIGHT_CONTENT_COLOR = '#FFFFFF';
  public static readonly DARK_CONTENT_COLOR = '#000000';
  public static readonly POWER_SAVE_MODE_OFF: number = 600;
  public static readonly POWER_SAVE_MODE_ON: number = 601;

  public static readonly PC_SHUTDOWN_NTF_ID = 1121;
  public static readonly PC_LOW_BATTERY_NTF_ID = 1122;
  public static readonly LOW_BATTERY_ERROR_ID = 1123;
  public static readonly LOW_BATTERY_NTF_ID = 1124;
  public static readonly LOW_BATTERY_NTF_ID_2IN1 = 1125;
  public static readonly VERY_LOW_BATTERY_NTF_ID_2IN1 = 1126;
  public static readonly LOW_BATTERY_NTF_ICON = 'ic_low_battery';
  public static readonly LOW_BATTERY_NTF_EVENT = 'power.event.SET_DEVICE_MODE';
  public static readonly LOW_BATTERY_NTF_REQUEST_CODE = 0;
  public static readonly POWER_MODE_STATUS_KET: string = 'settings.power.smart_mode_status';
  public static readonly LOW_BATTERY_POWER_OFF_CONTROL: string = 'const.low_battery.power_off_control';
}

export const TAG = 'BatteryComponent-batteryIcon';

export const COMPONENT_ID_BATTERY_BORDER = TAG + '_Image_batteryBorder';

export const COMPONENT_ID_BATTERY_PROGRESS = TAG + '_Image_batteryProgress';

export const COMPONENT_ID_BATTERY_SOC = TAG + '_Text_batterySoc';

export const COMPONENT_ID_BATTERY_CHARGING = TAG + '_Image_batteryCharging';

export const COMPONENT_ID_BATTERY_ICON = TAG + '_Image_batteryIcon';

export const COMPONENT_ID_POWER_SAVE_MODE = TAG + '_Image_PowerSaveMode';