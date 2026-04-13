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

export class QuickToolConstants {
  public static readonly CACHE_KEY_TOOLS_STATE: string = 'quickToolsState';
  public static readonly CACHE_KEY_IS_TOOLS_USING: string = 'quickToolsIsToolsUsing';
  public static readonly CACHE_KEY_IS_FLASH_OPEN: string = 'quickToolsIsFlashOpen';
  public static readonly CACHE_KEY_IS_FLASH_AVAILABLE: string = 'quickToolsIsFlashAvailable';
  public static readonly CACHE_KEY_HOT_ZONE_ID: string = 'QuickToolsHotZone';
  public static readonly CACHE_KEY_QUICK_TOOLS_ICON_ID: string = 'ScreenLock-QuickToolBar';
  public static readonly CACHE_KEY_HOT_ZONE_X: string = 'QuickToolsHotZoneX';
  public static readonly CACHE_KEY_HOT_ZONE_Y: string = 'QuickToolsHotZoneY';
  public static readonly HOT_ZONE_DISTANCE: number = 24;
  public static readonly BUTTON_SIZE: number = 48;
  public static readonly ICON_SIZE: number = 24;
  public static readonly QUICK_ICON_SIZE: Dimension = '24vp';
  public static readonly LOW_BATTERY_LIMIT = 6;
  public static readonly TOOLS_COUNT: number = 4;
  public static readonly TOOLS_ANGLE: number = 90;
  public static readonly SECTOR_RADIUS: number = 174;
  public static readonly BACK_PANEL_DEFAULT_BACKGROUND_EFFECT: BackgroundEffectOptions = {
    policy: 1,
    radius: 0,
    saturation: 1,
    brightness: 1,
    blurOptions: {
      grayscale: [0, 0]
    }
  };
  public static readonly BACK_PANEL_BACKGROUND_EFFECT: BackgroundEffectOptions = {
    policy: 1,
    radius: 45,
    saturation: 1.12,
    brightness: 1,
    blurOptions: {
      grayscale: [38, 38]
    }
  };
  public static readonly LIGHT_INTENSITY_HIT: number = 1;
  public static readonly BLOOM_HIT: number = 1;
  public static readonly LIGHT_POSITION_Z_CLOSE: Dimension = '100vp';
  public static readonly LIGHT_POSITION_Z_OPEN: Dimension = '200vp';
  public static readonly MARGIN_LEFT: number = 16;
  public static readonly MARGIN_LEFT_FOLD: number = 32;
  public static readonly MARGIN_LEFT_PAD: number = 48;
  public static readonly MARGIN_BOTTOM: number = 52;
  public static readonly MARGIN_BOTTOM_SMALL_FOLD: number = 20;
  public static readonly TOOLS_BOUNDARY_SIZE: number = 222;
  public static readonly ANIMATE_TIME: number = 200;
  public static readonly BACK_PLANE_TIME: number = 400;
  public static readonly ANIMATE_DELAY: number = 17;
  public static readonly ASH_OPACITY: number = 0.2;
  public static readonly HIT_SCALE: number = 1.4;
  public static readonly NEAR_SCALE: number = 1.3;
  public static readonly HIT_THRESHOLD_MIN: number = 126;
  public static readonly HIT_THRESHOLD_MAX: number = 270;
  public static readonly CLICK_SCALE: number = 1.3;
  public static readonly CLICK_ICON_SCALE: number = 1.25;
  public static readonly SCREEN_LOCK_SCALE: number = 0.9;
  public static readonly BAR_RADIUS: number = 25;
  public static readonly ENTER_EDITOR_DELAY: number = 100;
  public static readonly QUICK_TOOLS_EXIT_ANIMATE_TIME: number = 150;
  public static readonly CHILD_INDEX_NONE: number = -1;
  public static readonly DEFAULT_USER_ID: number = 100;
  public static readonly QUICK_TOOLS_ON_ACTION_END: string = 'quickToolsOnActionEnd';
  public static readonly QUICK_TOOLS_ON_ACTION_UPDATE: string = 'quickToolsOnActionUpdate';
  public static readonly QUICK_TOOLS_FOLD_STATE_CHANGE: string = 'quickToolsFoldStateChange';
  public static readonly QUICK_TOOLS_ICON_IMAGE: Resource = $r('sys.symbol.ring');
  public static readonly FLASH_ICON_IMAGE: Resource = $r('sys.symbol.flashlight_off_fill');
  public static readonly FLASH_HIT_ICON_IMAGE: Resource = $r('sys.symbol.flashlight_on_fill');
  public static readonly CLOCK_ICON_IMAGE: Resource = $r('sys.symbol.timer_circle_fill');
  public static readonly CALCULATOR_ICON_IMAGE: Resource = $r('sys.symbol.calculator_fill');
  public static readonly MEMORANDUM_ICON_IMAGE: Resource = $r('sys.symbol.doc_plaintext_fill');
  public static readonly CHILD_UNIVERSAL_DELAY_ANIMATE: string = 'quickToolChildUniversalDelayAnimate';
  public static readonly BAR_ICON_DELAY_ANIMATE: string = 'quickToolBarIconDelayAnimate';
  public static readonly CHILD_ICON_DELAY_ANIMATE: string = 'quickToolChildIconDelayAnimate';
  public static readonly BAR_ICON_ANIMATE: string = 'quickToolBarIconAnimate';
  public static readonly CHILD_ICON_ANIMATE: string = 'quickToolChildIconAnimate';
  public static readonly CHILD_UNIVERSAL_ANIMATE: string = 'quickToolChildUniversalAnimate';
  public static readonly IS_ACCESSIBILITY_ENABLE: boolean = false;
  public static readonly STRING_EMPTY: string = '';
  public static readonly START_MODE_SLIDE: string = 'slide';
  public static readonly START_MODE_CLICK: string = 'click';
  public static readonly OPEN_STATUS_ON: string = 'on';
  public static readonly OPEN_STATUS_OFF: string = 'off';
}

export enum DragState {
  NO_HIT = 1,
  NEAR = 2,
  HIT = 3
}

export enum DisableReason {
  REBOOT_LOCK = 1,
  BATTERY_LOW = 2,
  CAMERA_OPEN = 3,
  OOBE_ENABLE = 4,
}

export enum ComponentFlag {
  FLASH = 'Flash',
  MEMORANDUM = 'Memorandum',
  CLOCK = 'Clock',
  CALCULATOR = 'Calculator'
}

export enum QuickToolsState {
  OPEN = 1,
  CLOSE = 0
}
