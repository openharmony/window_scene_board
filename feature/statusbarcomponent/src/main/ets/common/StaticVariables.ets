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

export class StaticVariables {
  public static readonly DEFAULT_10 = 10;
  public static readonly DEFAULT_20 = 20;
  public static readonly DEFAULT_25 = 25;
  public static readonly DEFAULT_30 = 30;
  public static readonly DEFAULT_35 = 35;
  public static readonly DEFAULT_40 = 40;
  public static readonly DEFAULT_45 = 45;
  public static readonly DEFAULT_50 = 50;
  public static readonly DEFAULT_55 = 55;
  public static readonly DEFAULT_60 = 60;
  public static readonly DEFAULT_65 = 65;
  public static readonly DEFAULT_70 = 70;
  public static readonly DEFAULT_75 = 75;
  public static readonly DEFAULT_80 = 80;
  public static readonly DEFAULT_85 = 85;
  public static readonly DEFAULT_90 = 90;
  public static readonly DEFAULT_95 = 95;
  public static readonly DEFAULT_100 = 100;

  public static readonly PC_BLACK_SOUND_LOW: string = 'pc_black_sound_low';
  public static readonly PC_BLACK_SOUND_MIDDLE: string = 'pc_black_sound_middle';
  public static readonly PC_BLACK_SOUND_HIGH: string = 'pc_black_sound_high';
  public static readonly PC_BLACK_SOUND_MUTE: string = 'pc_black_sound_mute';
  public static readonly PC_WHITE_SOUND_LOW: string = 'pc_white_sound_low';
  public static readonly PC_WHITE_SOUND_MIDDLE: string = 'pc_white_sound_middle';
  public static readonly PC_WHITE_SOUND_HIGH: string = 'pc_white_sound_high';
  public static readonly PC_WHITE_SOUND_MUTE: string = 'pc_white_sound_mute';

  public static readonly PC_BLACK_CONTROL_CENTER: string = 'pc_black_control_center';
  public static readonly PC_WHITE_CONTROL_CENTER: string = 'pc_white_control_center';
  public static readonly PC_BLACK_NOTICE_WITH_MESSAGE: string = 'pc_black_notice_with_message';
  public static readonly PC_BLACK_NOTICE: string = 'pc_black_notice';
  public static readonly PC_WHITE_NOTICE_WITH_MESSAGE: string = 'pc_white_notice_with_message';
  public static readonly PC_WHITE_NOTICE: string = 'pc_white_notice';
  public static readonly PC_BLACK_HOME: string = 'pc_black_home';
  public static readonly PC_WHITE_HOME: string = 'pc_white_home';

  public static readonly IC_DEVICE_BATTERY_10_NORMAL: string = 'ic_device_battery_10_normal';
  public static readonly IC_DEVICE_BATTERY_20_NORMAL: string = 'ic_device_battery_20_normal';

  public static readonly BATTERY_SOC_LIST: number[] = [
    StaticVariables.DEFAULT_25, StaticVariables.DEFAULT_30, StaticVariables.DEFAULT_35, StaticVariables.DEFAULT_40,
    StaticVariables.DEFAULT_45, StaticVariables.DEFAULT_50, StaticVariables.DEFAULT_55, StaticVariables.DEFAULT_60,
    StaticVariables.DEFAULT_65, StaticVariables.DEFAULT_70, StaticVariables.DEFAULT_75, StaticVariables.DEFAULT_80,
    StaticVariables.DEFAULT_85, StaticVariables.DEFAULT_90, StaticVariables.DEFAULT_95, StaticVariables.DEFAULT_100];
  public static readonly IC_DEVICE_BATTERY_HIDESOC_NORMAL_MODDLE: string = 'ic_device_battery_hidesoc_normal_';
  public static readonly IC_DEVICE_BATTERY_SHOWSOC_NORMAL_MODDLE: string = 'ic_device_battery_showsoc_normal_';
  public static readonly IC_DEVICE_BATTERY_CHARGING_SHOWSOC_MODDLE: string = 'ic_device_battery_charging_showsoc_';

  public static readonly IC_BRIGHT_BATTERY_CHARGING_HIDESOC: string = 'ic_bright_battery_charging_hidesoc';
  public static readonly IC_BRIGHT_BATTERY_SUPERCHARGING_HIDESOC: string = 'ic_bright_battery_supercharging_hidesoc';
  public static readonly IC_DARK_BATTERY_CHARGING_HIDESOC: string = 'ic_dark_battery_charging_hidesoc';
  public static readonly IC_DARK_BATTERY_SUPERCHARGING_HIDESOC: string = 'ic_dark_battery_supercharging_hidesoc';
  public static readonly IC_BARIGHT_BATTERY_NORMAL: string = 'ic_bright_battery_normal';
  public static readonly IC_DARK_BATTERY_NORMAL: string = 'ic_dark_battery_normal';
  public static readonly IC_BRIGHT_BATTERY_CHARGING_SHOWSOC: string = 'ic_bright_battery_charging_showsoc';
  public static readonly IC_BRIGHT_BATTERY_SUPERCHARGING_SHOWSOC: string = 'ic_bright_battery_supercharging_showsoc';
  public static readonly IC_DARK_BATTERY_CHARGING_SHOWSOC: string = 'ic_dark_battery_charging_showsoc';
  public static readonly IC_DARK_BATTERY_SUPERCHARGING_SHOWSOC: string = 'ic_dark_battery_supercharging_showsoc';

  public static readonly FETCH_SOUND_ICON_FUNC: string = 'fetch_sound_icon_func';
  public static readonly FETCH_NOTIFICATION_ICON_FUNC: string = 'fetch_notification_icon_func';
  public static readonly FETCH_PERSONAL_ICON_FUNC: string = 'fetch_personal_icon_func';
  public static readonly FETCH_CONTROL_CENTER_ICON_FUNC: string = 'fetch_control_center_icon_func';

  public static readonly IC_DARK_MENU_POWER_OFF: string = 'ic_dark_menu_power_off';
  public static readonly IC_BRIGHT_MENU_POWER_OFF: string = 'ic_bright_menu_power_off';
}