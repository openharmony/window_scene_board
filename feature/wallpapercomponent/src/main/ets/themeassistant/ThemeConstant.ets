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

import curves from '@ohos.curves';

const SPRING_VELOCITY: number = 10;
const SPRING_MASS: number = 1;
const SPRING_STIFFNESS: number = 128;
const SPRING_DAMPING: number = 23;

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

  // Storage key for wallpaper scale
  public static readonly KEY_ENGINE_SCALE: string = 'engineScale';

  // Storage key for lockscreen opacity
  public static readonly KEY_ENGINE_OPACITY_LOCK: string = 'engineLockOpacity';

  // Storage key for desktop opacity
  public static readonly KEY_ENGINE_OPACITY_HOME: string = 'engineHomeOpacity';

  // Storage key for lockscreen pixel map
  public static readonly KEY_ENGINE_PIXMAP_LOCK: string = 'engineLockPixelMap';

  // Storage key for desktop pixel map
  public static readonly KEY_ENGINE_PIXMAP_HOME: string = 'engineHomePixelMap';

  // Storage key for activate theme flag
  public static readonly KEY_THEME_ACTIVATE: string = 'engineThemeActivate';

  // Storage key for dynamic theme reload flag
  public static readonly KEY_ENGINE_DYNAMIC_RELOAD: string = 'engineDynamicReload';

  // Maximum retry count for restarting dynamic theme before being forcibly fallback to static
  public static readonly ENGINE_DYNAMIC_RESTART_MAX: number = 5;

  // Store value of current SCB status for engine to initialise
  public static readonly KEY_ENGINE_INIT_STATE: string = 'engineInitState';

  // Spring curve definition used for scaling animation
  public static readonly SPRING_CURVE: ICurve =
    curves.interpolatingSpring(SPRING_VELOCITY, SPRING_MASS, SPRING_STIFFNESS, SPRING_DAMPING);

  // Home manifest file that unique in NG theme specification
  public static readonly MANIFEST_HOME: string = 'home/manifest.json';

  // Lockscreen manifest file that unique in NG theme specification
  public static readonly MANIFEST_LOCK: string = 'lock/manifest.json';

  // Lockscreen description file
  public static readonly DESCRIPTION_LOCK: string = 'lock/description.json';

  // CutePet description file path
  public static readonly DESCRIPTION_CUTE_PET_PATH: string = '/description.json';
}

/**
 * Distinguish different scene of SceneBoard
 */
export enum ScbState {
  SLEEP = 0,
  LOCKSCREEN = 1,
  DESKTOP = 2,
  UNKNOWN = 4,

  // 接近光亮屏
  PROXIMITY_SCREEN_ON = 5,

  // 接近光灭屏
  PROXIMITY_SCREEN_OFF = 6,

  // 开盖亮屏
  LID_OPEN = 7,

  // 桌面双击
  DOUBLE_CLICK = 8,

  // 进入控制中心
  DROPDOWN_PANEL_DOWN = 9,

  // 退出控制中心
  DROPDOWN_PANEL_UP = 10,

  // 进入全搜
  GLOBAL_SEARCH_PANEL_DOWN = 11,

  // 退出全搜
  GLOBAL_SEARCH_PANEL_UP = 12,
}

/**
 * Theme freeze reason
 */
export enum ThemeFreezeReason {
  ON_BACKGROUND = 0,
  PROXIMITY_SCREEN_OFF = 1,
  ENTER_EDIT_TOOL = 2,
  OS_ACCOUNT_SWITCHED = 3,
  MASHUP_STATIC_WALLPAPER = 4,
  DROPDOWN_PANEL = 5,
  GLOBAL_SEARCH_PANEL = 6,
  IMMERSIVE_PANEL = 7,
  POWER_SAVING_MODE = 8,
  SCREEN_LOCK_ON_BACKGROUND = 9,
}

/**
 * Definition of current theme's type
 */
export enum ThemeType {
  STATIC = 0,
  DYNAMIC = 1,
  DEFAULT = 2,
  UNKNOWN = 3,
}