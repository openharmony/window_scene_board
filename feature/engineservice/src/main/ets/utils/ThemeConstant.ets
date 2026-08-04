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

import lazy systemParameterEnhance from '@ohos.systemParameterEnhance';
import { ScbState } from '../pages/WallpaperConstants';
import { Constants } from './Constants';

const SRC_STATE_SHIFT: number = 3;

const SUPER_FOLD_DEVICE_FLAG: string = '5';
const FOLD_SCREEN_FLAG: String = systemParameterEnhance.getSync('const.window.foldscreen.type', '0,0,0,0');

/**
 * 权限类型
 */
export enum PermissionType {
  MICROPHONE = 'ohos.permission.MICROPHONE',
  LOCATION = 'ohos.permission.APPROXIMATELY_LOCATION',
  ACTIVITY_MOTION = 'ohos.permission.ACTIVITY_MOTION',
}

/**
 * Utility class to store common constants for ThemeEngine
 *
 * @since 2023-12-26
 */
export class ThemeConstant {
  // Flag path to identify theme A is currently active
  public static readonly THEME_A_FLAG: string = '/data/themes/a/app/flag';

  // Flag path to identify theme B is currently active
  public static readonly THEME_B_FLAG: string = '/data/themes/b/app/flag';

  // Actual resource path for theme A
  public static readonly THEME_A_PATH: string = '/data/themes/a/system';

  // Actual resource path for theme B
  public static readonly THEME_B_PATH: string = '/data/themes/b/system';

  // sandbox path
  public static readonly SANDBOX = 'sandbox';

  // Storage key for base wallpaper scale, which is from SCBWallpaper
  public static readonly KEY_ENGINE_BASE_SCALE: string = 'engineBaseScale';

  // Storage key for recording SCB state
  public static readonly KEY_ENGINE_STATE_SCB: string = 'engineScbState';

  // Storage key for marking if current theme is static
  public static readonly KEY_ENGINE_IS_STATIC: string = 'engineThemeStatic';

  // Storage key for marking if current theme is pandora
  public static readonly KEY_ENGINE_IS_PANDORA: string = 'isPandoraTheme';

  // Storage key for marking source state for dynamic animation
  public static readonly KEY_ENGINE_DYNAMIC_ANI_SRC: string = 'dynamicStateSrc';

  // Storage key for marking destination state for dynamic animation
  public static readonly KEY_ENGINE_DYNAMIC_ANI_DST: string = 'dynamicStateDst';

  // Black attribute value
  public static readonly COLOR_BLACK_STRING: string = '#000000';

  // Resource reloading policy
  public static readonly RESOURCE_RELOAD: number = 0;

  // Window reloading policy
  public static readonly WINDOW_RELOAD: number = 1;

  // Layout reloading policy
  public static readonly LAYOUT_RELOAD: number = 2;

  // Unknown colorMode
  public static readonly SYSTEM_NOT_SUPPORT: number = -1;

  private static readonly PATH_AOD_STILL: number =
    ThemeConstant.getStatePathIdentifier(ScbState.AOD, ScbState.AOD);

  private static readonly PATH_AOD_LOCK: number =
    ThemeConstant.getStatePathIdentifier(ScbState.AOD, ScbState.LOCKSCREEN);

  private static readonly PATH_AOD_HOME: number =
    ThemeConstant.getStatePathIdentifier(ScbState.AOD, ScbState.DESKTOP);

  private static readonly PATH_LOCK_STILL: number =
    ThemeConstant.getStatePathIdentifier(ScbState.LOCKSCREEN, ScbState.LOCKSCREEN);

  private static readonly PATH_LOCK_AOD: number =
    ThemeConstant.getStatePathIdentifier(ScbState.LOCKSCREEN, ScbState.AOD);

  private static readonly PATH_LOCK_HOME: number =
    ThemeConstant.getStatePathIdentifier(ScbState.LOCKSCREEN, ScbState.DESKTOP);

  private static readonly PATH_LOCK_SLEEP: number =
    ThemeConstant.getStatePathIdentifier(ScbState.LOCKSCREEN, ScbState.SLEEP);

  private static readonly PATH_HOME_STILL: number =
    ThemeConstant.getStatePathIdentifier(ScbState.DESKTOP, ScbState.DESKTOP);

  private static readonly PATH_HOME_AOD: number =
    ThemeConstant.getStatePathIdentifier(ScbState.DESKTOP, ScbState.AOD);

  private static readonly PATH_HOME_LOCK: number =
    ThemeConstant.getStatePathIdentifier(ScbState.DESKTOP, ScbState.LOCKSCREEN);

  private static readonly PATH_HOME_SLEEP: number =
    ThemeConstant.getStatePathIdentifier(ScbState.DESKTOP, ScbState.SLEEP);

  private static readonly PATH_SLEEP_LOCK: number =
    ThemeConstant.getStatePathIdentifier(ScbState.SLEEP, ScbState.LOCKSCREEN);

  private static readonly PATH_SLEEP_HOME: number =
    ThemeConstant.getStatePathIdentifier(ScbState.SLEEP, ScbState.DESKTOP);

  private static readonly PATH_PRE_BEGIN_ON: number =
    ThemeConstant.getStatePathIdentifier(ScbState.SLEEP, ScbState.UNKNOWN);

  private static readonly PATH_LID_OPEN: number =
    ThemeConstant.getStatePathIdentifier(ScbState.LID_OPEN, ScbState.LOCKSCREEN);

  private static readonly PATH_DOUBLE_CLICK: number =
    ThemeConstant.getStatePathIdentifier(ScbState.DOUBLE_CLICK, ScbState.DESKTOP);

  private static readonly PATH_SOURCE_MODE_MAIN_HOME: number =
    ThemeConstant.getStatePathIdentifier(ScbState.SOURCE_MODE_MAIN, ScbState.DESKTOP);

  private static readonly PATH_SOURCE_MODE_MAIN_LOCK: number =
    ThemeConstant.getStatePathIdentifier(ScbState.SOURCE_MODE_MAIN, ScbState.LOCKSCREEN);

  private static readonly PATH_SOURCE_MODE_MAIN_AOD: number =
    ThemeConstant.getStatePathIdentifier(ScbState.SOURCE_MODE_MAIN, ScbState.AOD);

  private static readonly PATH_SOURCE_MODE_EXTEND_HOME: number =
    ThemeConstant.getStatePathIdentifier(ScbState.SOURCE_MODE_EXTEND, ScbState.DESKTOP);

  private static readonly PATH_SOURCE_MODE_EXTEND_LOCK: number =
    ThemeConstant.getStatePathIdentifier(ScbState.SOURCE_MODE_EXTEND, ScbState.LOCKSCREEN);

  private static readonly PATH_SOURCE_MODE_EXTEND_AOD: number =
    ThemeConstant.getStatePathIdentifier(ScbState.SOURCE_MODE_EXTEND, ScbState.AOD);

  /**
   * Combine source and destination SCB state to get a single digit as dynamic animation scene identifier
   * Using following algorithm: id = (src << 3) + dst
   * e.g.: if src is AOD(3, 011), dst is HOME(2, 010), then AOD->HOME would be 011010(26), which is (3 << 3) + 2
   *
   * @param srcState Source SCB state
   * @param dstState Destination SCB state
   * @returns Unique scenario identifier used as key for getting animation type
   */
  public static getStatePathIdentifier(srcState: ScbState, dstState: ScbState): number {
    return (srcState << SRC_STATE_SHIFT) + dstState;
  }

  /**
   * Definition of SCB state path and TE animation type
   */
  public static readonly ANIMATION_MAP: Map<number, number> = new Map<number, number>([
    [this.PATH_AOD_STILL, Constants.AOD_STATUS],
    [this.PATH_AOD_LOCK, Constants.AOD_TO_LOCKSCREEN],
    [this.PATH_AOD_HOME, Constants.AOD_TO_LAUNCHER],
    [this.PATH_LOCK_STILL, Constants.LOCKSCREEN_STATUS],
    [this.PATH_LOCK_SLEEP, Constants.LOCKSCREEN_TO_AOD],
    [this.PATH_LOCK_AOD, Constants.LOCKSCREEN_TO_AOD],
    [this.PATH_LOCK_HOME, Constants.LOCKSCREEN_TO_LAUNCHER],
    [this.PATH_HOME_STILL, Constants.LAUNCHER_STATUS],
    [this.PATH_HOME_AOD, Constants.LAUNCHER_TO_AOD],
    [this.PATH_HOME_LOCK, Constants.LAUNCHER_TO_LOCKSCREEN],
    [this.PATH_HOME_SLEEP, Constants.LAUNCHER_TO_AOD],
    [this.PATH_SLEEP_LOCK, Constants.AOD_TO_LOCKSCREEN],
    [this.PATH_SLEEP_HOME, Constants.AOD_TO_LAUNCHER],
    [this.PATH_PRE_BEGIN_ON, Constants.PRE_BEGIN_ON],
    [this.PATH_LID_OPEN, Constants.AOD_TO_LOCKSCREEN_LID_OPEN],
    [this.PATH_DOUBLE_CLICK, Constants.LAUNCHER_STATUS_DOUBLE_CLICK],
    [this.PATH_SOURCE_MODE_MAIN_HOME, Constants.SOURCE_MODE_MAIN],
    [this.PATH_SOURCE_MODE_MAIN_LOCK, Constants.SOURCE_MODE_MAIN],
    [this.PATH_SOURCE_MODE_MAIN_AOD, Constants.SOURCE_MODE_MAIN],
    [this.PATH_SOURCE_MODE_EXTEND_HOME, Constants.SOURCE_MODE_EXTEND],
    [this.PATH_SOURCE_MODE_EXTEND_LOCK, Constants.SOURCE_MODE_EXTEND],
    [this.PATH_SOURCE_MODE_EXTEND_AOD, Constants.SOURCE_MODE_EXTEND],
  ])

  /**
   * json文件中的permissions字段
   */
  public static readonly PERMISSIONS: string = 'permissions';

  /**
   * 判断设备是否为超级折叠设备
   */
  public static getIsSuperFoldDevices(): boolean {
    if (FOLD_SCREEN_FLAG === '' || FOLD_SCREEN_FLAG === null) {
      return false;
    }
    return FOLD_SCREEN_FLAG.substring(0, 1) === SUPER_FOLD_DEVICE_FLAG;
  }

  /**
   * Json文件中权限列表的对应值
   */
  public static readonly PERMISSION_MAP: Map<string, string> = new Map([
    ['LOCATION', PermissionType.LOCATION],
    ['ACTIVITY_MOTION', PermissionType.ACTIVITY_MOTION],
    ['MICROPHONE', PermissionType.MICROPHONE],
  ])
}

export enum WallpaperType {
  STATIC = 0,
  DYNAMIC = 1,
  DEFAULT = 2,
  UNKNOWN = 3,
}

export enum DesktopModeEnum {
  BASE_MODE = 0,
  EMERGENCY_MODE = 1,
  THERMAL_SAFE_MODE = 2,
  THER_EMC_OVERLAY_MODE = -1
}