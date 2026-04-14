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

/**
 * Constant class for wallpaper data source
 *
 * @since 2024-02-27
 */
export class WallpaperConstants {
  // Component identifier for the lock component, used for AOD dimming
  public static readonly ID_LOCK: string = 'lock';

  // Component identifier for the home component
  public static readonly ID_HOME: string = 'home';

  // Storage key to control blur radius
  public static readonly KEY_BLUR_RADIUS: string = 'blurRadius';

  // Dirty mask to identify blur radius
  public static readonly DIRTY_MASK_BLUR: number = 0x1;

  // Storage key to control light up
  public static readonly KEY_LIGHT_UP_FACTOR: string = 'lightUpFactor';

  // Dirty mask to identify light up
  public static readonly DIRTY_MASK_LIGHT_UP: number = 0x2;

  // Storage key to control dimming
  public static readonly KEY_AOD_DIM_FACTOR: string = 'aodDimFactor';

  // Dirty mask to identify dimming
  public static readonly DIRTY_MASK_DIM: number = 0x4;

  // Storage key to control lock opacity
  public static readonly KEY_LOCK_OPACITY: string = 'lockOpacity';

  // Dirty mask to identify lock opacity
  public static readonly DIRTY_MASK_LOCK_OPACITY: number = 0x8;

  // Setting entry key to get AOD dimming factor
  public static readonly KEY_AOD_DIM_KS: string = 'aod_wallpaper_dim_ks';

  // Storage key to video frame
  public static readonly KEY_VIDEO_FRAME: string = 'videoFrame';

  // Available properties to be altered with animation
  public static readonly WALLPAPER_PROPERTY_LIST: string[] = [
    WallpaperConstants.KEY_BLUR_RADIUS,
    WallpaperConstants.KEY_LIGHT_UP_FACTOR,
    WallpaperConstants.KEY_AOD_DIM_FACTOR,
    WallpaperConstants.KEY_LOCK_OPACITY,
  ];
}

export enum WallpaperType {
  STATIC = 0,
  DYNAMIC = 1,
  DEFAULT = 2,
  UNKNOWN = 3,
}

export enum ScbState {
  SLEEP,
  LOCKSCREEN,
  DESKTOP,
  AOD,
  UNKNOWN,

  // 接近光亮屏
  PROXIMITY_SCREEN_ON = 5,

  // 接近光灭屏
  PROXIMITY_SCREEN_OFF = 6,

  // 开盖亮屏
  LID_OPEN = 7,

  // 桌面双击
  DOUBLE_CLICK = 8,

  // 壁纸在内屏
  SOURCE_MODE_MAIN = 13,

  // 壁纸在外屏
  SOURCE_MODE_EXTEND = 14,
}

export enum ScenePanelState {
  HOME,
  FULL_SCENE,
}