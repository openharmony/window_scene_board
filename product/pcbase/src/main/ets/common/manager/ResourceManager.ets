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

import { AbsResourceManager as ResourceManager } from '@ohos/frameworkwrapper';
import { StaticVariables } from '@ohos/statusbarcomponent/src/main/ets/common/StaticVariables';
import charger from '@ohos.charger';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'LocalIconResources-batteryPic';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

class LocalIconResources {
  public static readonly PC_BLACK_SOUND_LOW_ICON: Resource = $r('app.media.ic_pc_status_black_sound_low');
  public static readonly PC_BLACK_SOUND_MIDDLE_ICON: Resource = $r('app.media.ic_pc_status_black_sound_mid');
  public static readonly PC_BLACK_SOUND_HIGH_ICON: Resource = $r('app.media.ic_pc_status_black_sound_high');
  public static readonly PC_BLACK_SOUND_MUTE_ICON: Resource = $r('app.media.ic_pc_status_black_sound_mute');
  public static readonly PC_WHITE_SOUND_LOW_ICON: Resource = $r('app.media.ic_pc_status_white_sound_low');
  public static readonly PC_WHITE_SOUND_MIDDLE_ICON: Resource = $r('app.media.ic_pc_status_white_sound_mid');
  public static readonly PC_WHITE_SOUND_HIGH_ICON: Resource = $r('app.media.ic_pc_status_white_sound_high');
  public static readonly PC_WHITE_SOUND_MUTE_ICON: Resource = $r('app.media.ic_pc_status_white_sound_mute');

  public static readonly PC_BLACK_CONTROL_CENTER_ICON: Resource = $r('app.media.ic_pc_status_black_controlcenter');
  public static readonly PC_WHITE_CONTROL_CENTER_ICON: Resource = $r('app.media.ic_pc_status_white_controlcenter');
  public static readonly PC_BLACK_NOTICE_WITH_MESSAGE_ICON: Resource = $r('app.media.ic_pc_status_black_notice_msg');
  public static readonly PC_BLACK_NOTICE_ICON: Resource = $r('app.media.ic_pc_status_black_notice');
  public static readonly PC_WHITE_NOTICE_WITH_MESSAGE_ICON: Resource = $r('app.media.ic_pc_status_white_notice_msg');
  public static readonly PC_WHITE_NOTICE_ICON: Resource = $r('app.media.ic_pc_status_white_notice');
  public static readonly PC_BLACK_HOME_ICON: Resource = $r('app.media.ic_pc_status_black_home');
  public static readonly PC_WHITE_HOME_ICON: Resource = $r('app.media.ic_pc_status_white_home');

  public static readonly IC_DEVICE_BATTERY_10_NORMAL_ICON: Resource = $r('app.media.ic_device_battery_10_normal');
  public static readonly IC_DEVICE_BATTERY_20_NORMAL_ICON: Resource = $r('app.media.ic_device_battery_20_normal');

  public static readonly IC_DEVICE_BATTERY_HIDESOC_NORMAL_ARRAY: Resource[] = [
    $r('app.media.ic_device_battery_25_hidesoc_normal'), $r('app.media.ic_device_battery_30_hidesoc_normal'),
    $r('app.media.ic_device_battery_35_hidesoc_normal'), $r('app.media.ic_device_battery_40_hidesoc_normal'),
    $r('app.media.ic_device_battery_45_hidesoc_normal'), $r('app.media.ic_device_battery_50_hidesoc_normal'),
    $r('app.media.ic_device_battery_55_hidesoc_normal'), $r('app.media.ic_device_battery_60_hidesoc_normal'),
    $r('app.media.ic_device_battery_65_hidesoc_normal'), $r('app.media.ic_device_battery_70_hidesoc_normal'),
    $r('app.media.ic_device_battery_75_hidesoc_normal'), $r('app.media.ic_device_battery_80_hidesoc_normal'),
    $r('app.media.ic_device_battery_85_hidesoc_normal'), $r('app.media.ic_device_battery_90_hidesoc_normal'),
    $r('app.media.ic_device_battery_95_hidesoc_normal'), $r('app.media.ic_device_battery_99_hidesoc_normal'),
    $r('app.media.ic_device_battery_100_hidesoc_normal')
  ];
  public static readonly IC_DEVICE_BATTERY_SHOWSOC_NORMAL_ARRAY: Resource[] = [
    $r('app.media.ic_device_battery_25_showsoc_normal'), $r('app.media.ic_device_battery_30_showsoc_normal'),
    $r('app.media.ic_device_battery_35_showsoc_normal'), $r('app.media.ic_device_battery_40_showsoc_normal'),
    $r('app.media.ic_device_battery_45_showsoc_normal'), $r('app.media.ic_device_battery_50_showsoc_normal'),
    $r('app.media.ic_device_battery_55_showsoc_normal'), $r('app.media.ic_device_battery_60_showsoc_normal'),
    $r('app.media.ic_device_battery_65_showsoc_normal'), $r('app.media.ic_device_battery_70_showsoc_normal'),
    $r('app.media.ic_device_battery_75_showsoc_normal'), $r('app.media.ic_device_battery_80_showsoc_normal'),
    $r('app.media.ic_device_battery_85_showsoc_normal'), $r('app.media.ic_device_battery_90_showsoc_normal'),
    $r('app.media.ic_device_battery_95_showsoc_normal'), $r('app.media.ic_device_battery_99_showsoc_normal'),
    $r('app.media.ic_device_battery_100_showsoc_normal')
  ];
  public static readonly IC_DEVICE_BATTERY_CHARGING_SHOWSOC_ARRAY: Resource[] = [
    $r('app.media.ic_device_battery_charging_25_showsoc'), $r('app.media.ic_device_battery_charging_30_showsoc'),
    $r('app.media.ic_device_battery_charging_35_showsoc'), $r('app.media.ic_device_battery_charging_40_showsoc'),
    $r('app.media.ic_device_battery_charging_45_showsoc'), $r('app.media.ic_device_battery_charging_50_showsoc'),
    $r('app.media.ic_device_battery_charging_55_showsoc'), $r('app.media.ic_device_battery_charging_60_showsoc'),
    $r('app.media.ic_device_battery_charging_65_showsoc'), $r('app.media.ic_device_battery_charging_70_showsoc'),
    $r('app.media.ic_device_battery_charging_75_showsoc'), $r('app.media.ic_device_battery_charging_80_showsoc'),
    $r('app.media.ic_device_battery_charging_85_showsoc'), $r('app.media.ic_device_battery_charging_90_showsoc'),
    $r('app.media.ic_device_battery_charging_95_showsoc'), $r('app.media.ic_device_battery_charging_99_showsoc'),
    $r('app.media.ic_device_battery_charging_100_showsoc')
  ];

  public static readonly IC_BRIGHT_BATTERY_CHARGING_HIDESOC_ICON: Resource = $r('app.media.ic_bright_battery_charging_hidesoc');
  public static readonly IC_BRIGHT_BATTERY_NORMAL_ICON: Resource = $r('app.media.ic_bright_battery_normal');
  public static readonly IC_BRIGHT_BATTERY_CHARGING_SHOWSOC_ICON: Resource = $r('app.media.ic_bright_battery_charging_showsoc');

  public static readonly IC_DARK_BATTERY_CHARGING_HIDESOC_ICON: Resource = $r('app.media.ic_dark_battery_charging_hidesoc');
  public static readonly IC_DARK_BATTERY_NORMAL_ICON: Resource = $r('app.media.ic_dark_battery_normal');
  public static readonly IC_DARK_BATTERY_CHARGING_SHOWSOC_ICON: Resource = $r('app.media.ic_dark_battery_charging_showsoc');
  public static readonly IC_DARK_MENU_POWER_OFF_ICON: Resource = $r('app.media.menu_power_off_black');
  public static readonly IC_BRIGHT_MENU_POWER_OFF_ICON: Resource = $r('app.media.menu_power_off_white');
}

export class PcResourceManager extends ResourceManager {

  /**
   * 电池进度条图标资源
   */
  public batteryProgress: Map<string, Resource> = new Map();

  /**
   * 电池图标资源
   */
  public batteryIcons: Map<string, Resource> = new Map();

  constructor() {
    super();
    this.initProgress();
    this.initImages();
  }

  getProgress(batterySoc: number, isShowBatterySoc: boolean, isBatteryCharging: boolean): Resource | undefined {
    if (batterySoc <= StaticVariables.DEFAULT_10) {
      return this.batteryProgress.get(StaticVariables.IC_DEVICE_BATTERY_10_NORMAL);
    }

    if (batterySoc <= StaticVariables.DEFAULT_20) {
      return this.batteryProgress.get(StaticVariables.IC_DEVICE_BATTERY_20_NORMAL);
    }

    let batterySoclist: number[] = StaticVariables.BATTERY_SOC_LIST;
    for (let index = 0; index < batterySoclist.length; index++) {
      if (batterySoc <= batterySoclist[index]) {
        if (!isShowBatterySoc) {
          let batterySocKey = StaticVariables.IC_DEVICE_BATTERY_HIDESOC_NORMAL_MODDLE + `${batterySoclist[index]}`;
          return this.batteryProgress.get(batterySocKey);
        }
        if (!isBatteryCharging) {
          let batterySocKey = StaticVariables.IC_DEVICE_BATTERY_SHOWSOC_NORMAL_MODDLE + `${batterySoclist[index]}`;
          return this.batteryProgress.get(batterySocKey);
        }
        let batterySocKey = StaticVariables.IC_DEVICE_BATTERY_CHARGING_SHOWSOC_MODDLE + `${batterySoclist[index]}`;
        return this.batteryProgress.get(batterySocKey);
      }
    }
    return undefined;
  }

  getImage(isBrightOrDark: boolean, isShowBatterySoc: boolean, isBatteryCharging: boolean,
    chargerType: number): Resource | undefined {
    // 不支持ChargeType的情况用isBatteryCharging判断充电状态
    if (isBatteryCharging && chargerType === charger.ChargeType.NONE) {
      chargerType = charger.ChargeType.WIRED_NORMAL;
    }
    if (!isBatteryCharging) {
      chargerType = charger.ChargeType.NONE;
    }
    log.showInfo(`chargerType: ${chargerType} showBatterySoc: ${isShowBatterySoc} isBatteryCharging: ${isBatteryCharging}`);
    if (!isShowBatterySoc) {
      switch (chargerType) {
        case charger.ChargeType.WIRED_NORMAL:
        case charger.ChargeType.WIRED_QUICK:
          return isBrightOrDark ? this.batteryIcons.get(StaticVariables.IC_BRIGHT_BATTERY_CHARGING_HIDESOC) :
          this.batteryIcons.get(StaticVariables.IC_DARK_BATTERY_CHARGING_HIDESOC);
        case charger.ChargeType.WIRED_SUPER_QUICK:
          return isBrightOrDark ? this.batteryIcons.get(StaticVariables.IC_BRIGHT_BATTERY_SUPERCHARGING_HIDESOC) :
          this.batteryIcons.get(StaticVariables.IC_DARK_BATTERY_SUPERCHARGING_HIDESOC);
        default:
          return isBrightOrDark ? this.batteryIcons.get(StaticVariables.IC_BARIGHT_BATTERY_NORMAL) :
          this.batteryIcons.get(StaticVariables.IC_DARK_BATTERY_NORMAL);
      }
    }

    switch (chargerType) {
      case charger.ChargeType.WIRED_NORMAL:
      case charger.ChargeType.WIRED_QUICK:
        return isBrightOrDark ? this.batteryIcons.get(StaticVariables.IC_BRIGHT_BATTERY_CHARGING_SHOWSOC) :
        this.batteryIcons.get(StaticVariables.IC_DARK_BATTERY_CHARGING_SHOWSOC);
      case charger.ChargeType.WIRED_SUPER_QUICK:
        return isBrightOrDark ? this.batteryIcons.get(StaticVariables.IC_BRIGHT_BATTERY_SUPERCHARGING_SHOWSOC) :
        this.batteryIcons.get(StaticVariables.IC_DARK_BATTERY_SUPERCHARGING_SHOWSOC);
      default:
        return isBrightOrDark ? this.batteryIcons.get(StaticVariables.IC_BARIGHT_BATTERY_NORMAL) :
        this.batteryIcons.get(StaticVariables.IC_DARK_BATTERY_NORMAL);
    }
  }

  getPcSoundIcons(): Map<string, Resource> {
    return new Map<string, Resource>([
      [StaticVariables.PC_BLACK_SOUND_LOW, LocalIconResources.PC_BLACK_SOUND_LOW_ICON],
      [StaticVariables.PC_BLACK_SOUND_MIDDLE, LocalIconResources.PC_BLACK_SOUND_MIDDLE_ICON],
      [StaticVariables.PC_BLACK_SOUND_HIGH, LocalIconResources.PC_BLACK_SOUND_HIGH_ICON],
      [StaticVariables.PC_BLACK_SOUND_MUTE, LocalIconResources.PC_BLACK_SOUND_MUTE_ICON],
      [StaticVariables.PC_WHITE_SOUND_LOW, LocalIconResources.PC_WHITE_SOUND_LOW_ICON],
      [StaticVariables.PC_WHITE_SOUND_MIDDLE, LocalIconResources.PC_WHITE_SOUND_MIDDLE_ICON],
      [StaticVariables.PC_WHITE_SOUND_HIGH, LocalIconResources.PC_WHITE_SOUND_HIGH_ICON],
      [StaticVariables.PC_WHITE_SOUND_MUTE, LocalIconResources.PC_WHITE_SOUND_MUTE_ICON],
    ]);
  }

  getPcNotificationIcons(): Map<string, Resource> {
    return new Map<string, Resource>([
      [StaticVariables.PC_BLACK_NOTICE_WITH_MESSAGE, LocalIconResources.PC_BLACK_NOTICE_WITH_MESSAGE_ICON],
      [StaticVariables.PC_BLACK_NOTICE, LocalIconResources.PC_BLACK_NOTICE_ICON],
      [StaticVariables.PC_WHITE_NOTICE_WITH_MESSAGE, LocalIconResources.PC_WHITE_NOTICE_WITH_MESSAGE_ICON],
      [StaticVariables.PC_WHITE_NOTICE, LocalIconResources.PC_WHITE_NOTICE_ICON],
    ]);
  }
  
  getPcPersonalIcons(): Map<string, Resource> {
    return new Map<string, Resource>([
      [StaticVariables.PC_BLACK_HOME, LocalIconResources.PC_BLACK_HOME_ICON],
      [StaticVariables.PC_WHITE_HOME, LocalIconResources.PC_WHITE_HOME_ICON],
    ]);
  }

  getPcControlCenterIcons(): Map<string, Resource> {
    return new Map<string, Resource>([
      [StaticVariables.PC_BLACK_CONTROL_CENTER, LocalIconResources.PC_BLACK_CONTROL_CENTER_ICON],
      [StaticVariables.PC_WHITE_CONTROL_CENTER, LocalIconResources.PC_WHITE_CONTROL_CENTER_ICON],
    ]);
  }

  getPcSystemMenuOffIcon(): Map<string, Resource> {
    return new Map<string, Resource>([
      [StaticVariables.IC_DARK_MENU_POWER_OFF, LocalIconResources.IC_DARK_MENU_POWER_OFF_ICON],
      [StaticVariables.IC_BRIGHT_MENU_POWER_OFF, LocalIconResources.IC_BRIGHT_MENU_POWER_OFF_ICON],
    ]);
  }

  private initImages(): void {
    this.batteryIcons = new Map<string, Resource>([
      [StaticVariables.IC_BRIGHT_BATTERY_CHARGING_HIDESOC, LocalIconResources.IC_BRIGHT_BATTERY_CHARGING_HIDESOC_ICON],
      [StaticVariables.IC_DARK_BATTERY_CHARGING_HIDESOC, LocalIconResources.IC_DARK_BATTERY_CHARGING_HIDESOC_ICON],
      [StaticVariables.IC_BARIGHT_BATTERY_NORMAL, LocalIconResources.IC_BRIGHT_BATTERY_NORMAL_ICON],
      [StaticVariables.IC_DARK_BATTERY_NORMAL, LocalIconResources.IC_DARK_BATTERY_NORMAL_ICON],
      [StaticVariables.IC_BRIGHT_BATTERY_CHARGING_SHOWSOC, LocalIconResources.IC_BRIGHT_BATTERY_CHARGING_SHOWSOC_ICON],
      [StaticVariables.IC_DARK_BATTERY_CHARGING_SHOWSOC, LocalIconResources.IC_DARK_BATTERY_CHARGING_SHOWSOC_ICON],
    ]);
  }

  private initProgress(): void {
    let batterySoclist: number[] = StaticVariables.BATTERY_SOC_LIST;
    let progress: Map<string, Resource> = new Map();
    let hiddenSocKey: string = StaticVariables.IC_DEVICE_BATTERY_HIDESOC_NORMAL_MODDLE;
    let visibleSocNormalKey: string = StaticVariables.IC_DEVICE_BATTERY_SHOWSOC_NORMAL_MODDLE;
    let visibleSocChargingKey: string = StaticVariables.IC_DEVICE_BATTERY_CHARGING_SHOWSOC_MODDLE;

    let hiddenSocArray: Resource[] = LocalIconResources.IC_DEVICE_BATTERY_HIDESOC_NORMAL_ARRAY;
    let visibleSocNormalArray: Resource[] = LocalIconResources.IC_DEVICE_BATTERY_SHOWSOC_NORMAL_ARRAY;
    let visibleSocChargingArray: Resource[] = LocalIconResources.IC_DEVICE_BATTERY_CHARGING_SHOWSOC_ARRAY;
    for (let index = 0; index < batterySoclist.length; index++) {
      let hiddenSoc: string = hiddenSocKey + `${batterySoclist[index]}`;
      let visibleSocNormal: string = visibleSocNormalKey + `${batterySoclist[index]}`;
      let visibleSocCharging: string = visibleSocChargingKey + `${batterySoclist[index]}`;

      progress.set(hiddenSoc, hiddenSocArray[index]);
      progress.set(visibleSocNormal, visibleSocNormalArray[index]);
      progress.set(visibleSocCharging, visibleSocChargingArray[index]);
    }
    progress.set(StaticVariables.IC_DEVICE_BATTERY_10_NORMAL, LocalIconResources.IC_DEVICE_BATTERY_10_NORMAL_ICON);
    progress.set(StaticVariables.IC_DEVICE_BATTERY_20_NORMAL, LocalIconResources.IC_DEVICE_BATTERY_20_NORMAL_ICON);
    this.batteryProgress = progress;
  }
}
