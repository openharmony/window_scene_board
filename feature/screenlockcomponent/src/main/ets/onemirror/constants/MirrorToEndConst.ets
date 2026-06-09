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

export class MirrorToEndConst {
  public static readonly ANIMATION_DELAY_MS: number = 50;

  public static readonly NOTIFY_OFF_SCREEN_OPEN_LCD: number = 2;

  public static readonly NOTIFY_OFF_SCREEN_CLOSE_LCD: number = 3;

  public static readonly NOTIFY_CANCEL_OFF_SCREEN: number = 4;

  public static readonly SCREEN_LOCK_CLOCK_VIEW_MARGIN_TOP_DEFAULT: number = 8;

  public static readonly SCREEN_LOCK_CLOCK_VIEW_MARGIN_LEFT_DEFAULT: number = 0;

  public static readonly IMMERSIVE_ONE_MIRROR_SCENE: string = 'oneMirror';

  public static readonly NORMAL_BEZIER_TIME: number = 400;
}

export enum MirrorsScene {
  // AOD到桌面
  AOD_TO_DESKTOP = 'AOD_TO_DESKTOP',
  // AOD到锁屏
  AOD_TO_SL = 'AOD_TO_SL',
  // 黑屏到锁屏第一帧
  SCREEN_OFF_TO_SL = 'SCREEN_OFF_TO_SL_BEGIN',
  // 黑屏到锁屏结束
  SCREEN_OFF_TO_SL_END = 'SCREEN_OFF_TO_SL_END',
  // 桌面到AOD
  DESKTOP_TO_AOD = 'DESKTOP_TO_AOD',
  // 锁屏到AOD
  SL_TO_AOD = 'SL_TO_AOD',
  // 解锁到桌面
  SL_UNLOCKING_TO_DESKTOP = 'SL_UNLOCKING_TO_DESKTOP',
  // 锁屏解锁到桌面
  SCREEN_LOCK_TO_UNLOCK = 'SCREEN_LOCK_TO_UNLOCK',
  // 锁屏到黑屏
  SL_TO_SCREEN_OFF = 'SL_TO_SCREEN_OFF',
  // 桌面到黑屏
  DESKTOP_TO_SCREEN_OFF = 'DESKTOP_TO_SCREEN',
  // 桌面到锁屏
  DESKTOP_TO_SL = 'DESKTOP_TO_SL',
}

// 灭屏到AOD场景集
export const TO_AOD_SCENE: Set<MirrorsScene> = new Set([
  MirrorsScene.DESKTOP_TO_AOD,
  MirrorsScene.SL_TO_AOD,
  MirrorsScene.SL_TO_SCREEN_OFF,
  MirrorsScene.DESKTOP_TO_SCREEN_OFF,
]);

export enum MirrorComponent {
  SL_ROOT = 'SL_ROOT', // 锁屏根节点
  LOCK_ICON = 'LOCK_ICON',
  CLOCK = 'CLOCK',
  SL_GREET = 'SL_GREET',
  FORM_CARD = 'FORM_CARD',
  NTF_LIST = 'NTF_LIST',
  NTF_IMMERSIVE = 'NTF_IMMERSIVE',
  QUICK_TOOL = 'QUICK_TOOL',
  NTF_CAPSULE = 'NTF_CAPSULE',
  CAMERA = 'CAMERA',
  SIGN = 'SIGN',
  DOF_WALLPAPER = 'DOF_WALLPAPER',
  ART_SIGN = 'ART_SIGN',
}

export enum MirrorAnimState {
  START = '_anim_start',
  END = '_anim_end',
  NONE = '',
}

/**
 * 不支持一镜到底原因
 */
export enum NoMirrorReason {
  WALLPAPER = 'Wallpaper not support',
  HDR = 'HDR is showing',
  AOD_STYLE = 'Aod style not support',
  SL_SPECIAL_MODEL = 'ScreenLock Cover or Special model',
  AOD_INVALID = 'Aod data inValid',
  WINDOW_OCCLUDED = 'Window Occluded',
}