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
import { bundleManager } from '@kit.AbilityKit';
import { SCBSceneSession, SCBSessionEventId } from '@ohos/windowscene';
import { inputConsumer } from '@kit.InputKit';
import KeyCodeConstants from '@ohos/multiinput/src/main/ets/default/common/constants/KeyCodeConstants';

export const HOT_AREA_TYPE_C_SIDE_TOP_HEIGHT = 56;

export const MINI_VALUE: number = 0.000001;

export const DEFAULT_RATIO: number = 0.67;

export const HALF = 0.5;

/**
 * window hot area margin
 */
export const WINDOW_HOTAREA_MARGIN = 20;
export const INVALID_INDEX = -1;
export const INVALID_POSITION = -1;
export const INVALID_DPI: number = -1;
export const ROTATE_DURATION: number = 600;
export const WINDOW_AVOIDANCE = 40;
export const SCREEN_INDEX = 1000;
export const WINDOW_INTERVAL = 15;
export const SMARTDOCK_APPICON_CONTAINER = 'SmartDock_AppIcon_Container_';
export const SUBWINDOW_SECURITY_PREFIX: string = 'com.ohos.security';
export const MIDSCENE_SWITCH_TO_PCMODE: number = 3;

export enum PolicyType {
  POLICY_LIFECYCLE,
  POLICY_LAYOUT,
  POLICY_ANIMATION,
  POLICY_EXTENSION_DISPLAY,
  POLICY_FOLD_DISPLAY,
  POLICY_FOLD_STATE,
  POLICY_GESTURE,
}

export enum ViewModelType {
  VIEW_MODEL_PC,
  VIEW_MODEL_PAD,
  VIEW_MODEL_FOLD_PC
}

export enum MonitorExitSplitName {
  DEFAULT = 'DEFAULT',
  MINIMIZE = 'ON_MINIMIZE',
  MAXIMIZE = 'ON_MAXIMIZE',
  RECOVER = 'ON_RECOVER',
  CLOSE = 'ON_CLOSE',
  REASSEMBLY_SPLIT = 'ON_SPLIT',
  DRAG_TITLE = 'ON_DRAG',
}

export class ViewModelConstant {
  public static readonly BASE_DENSITY: number = 160;
  public static readonly INVALID_SCREEN_ID: number = -1;
  public static readonly MAX_NUMBER_RECT_SAVE: number = 1000;
  public static readonly FOLD_HEIGHT_DEFAULT_RATIO: number = 0.54;
  public static readonly FOLD_WIDTH_HEIGHT_RATIO: number = 1.5;
  public static readonly MAX_SESSION_LIMIT_ALL_APP = 512;
  // ESC UP
  public static readonly ESC_UP_OPTION: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCodeConstants.KEYCODE_ESC,
    isFinalKeyDown: false,
    finalKeyDownDuration: 0
  };
  public static readonly WECHAT_BUNDLE_NAME: string[] = ['com.tencent.wechat.pc', 'com.tencent.debug.xwechat']
}

export class WindowSizeResult {
  public width: number = 0;
  public height: number = 0;

  constructor() {
  }
}

export class WindowSizeLimits {
  public maxWindowWidth: number = 0;
  public minWindowWidth: number = 0;
  public maxWindowHeight: number = 0;
  public minWindowHeight: number = 0;
  public maxWindowRatio: number = 0;
  public minWindowRatio: number = 0;

  constructor() {
  }

  public initAll(windowLimits: bundleManager.WindowSize): void {
    this.maxWindowWidth = windowLimits.maxWindowWidth;
    this.minWindowWidth = windowLimits.minWindowWidth;
    this.maxWindowHeight = windowLimits.maxWindowHeight;
    this.minWindowHeight = windowLimits.minWindowHeight;
    this.maxWindowRatio = windowLimits.maxWindowRatio;
    this.minWindowRatio = windowLimits.minWindowRatio;
  }

  public initAllWithSceneSession(windowLimits: bundleManager.WindowSize, scbSceneSession: SCBSceneSession): void {
    this.maxWindowWidth = scbSceneSession.sceneInfo.maxWindowWidth ?? windowLimits.maxWindowWidth;
    this.minWindowWidth = scbSceneSession.sceneInfo.minWindowWidth ?? windowLimits.minWindowWidth;
    this.maxWindowHeight = scbSceneSession.sceneInfo.maxWindowHeight ?? windowLimits.maxWindowHeight;
    this.minWindowHeight = scbSceneSession.sceneInfo.minWindowHeight ?? windowLimits.minWindowHeight;
    this.maxWindowRatio = windowLimits.maxWindowRatio;
    this.minWindowRatio = windowLimits.minWindowRatio;
  }

  public initSize(maxWindowWidth: number, minWindowWidth: number,
    maxWindowHeight: number, minWindowHeight: number): void {
    this.maxWindowWidth = maxWindowWidth;
    this.minWindowWidth = minWindowWidth;
    this.maxWindowHeight = maxWindowHeight;
    this.minWindowHeight = minWindowHeight;
  }
}

/**
 * Current display screen form
 */
export enum ScreenForm {
  FULL_SCREEN = 0,
  FOLD_MAIN_SCREEN,
  FOLD_VIRTUAL_SCREEN,
  FOLD_MAIN_SCREEN_WITH_DOCK,
  UNFOLDED_WITH_KEYBOARD,
}

/**
 * Information about the actual display range on the current screen
 */
export class RealScreenInfo {
  public screenWidth: number = 0;
  public screenHeight: number = 0;
  public screenHeightLimit: number = 0;
  public maxTop: number = 0;
  public maxBottom: number = 0;
  public fullScreenTop: number = 0;

  constructor(screenWidth: number, screenHeight: number, screenHeightLimit: number, maxTop: number,
    maxBottom: number, fullScreenTop: number) {
    this.screenWidth = screenWidth;
    this.screenHeight = screenHeight;
    this.screenHeightLimit = screenHeightLimit;
    this.maxTop = maxTop;
    this.maxBottom = maxBottom;
    this.fullScreenTop = fullScreenTop;
  }
}

export class InitPosType {
  public translateX: number = 0;
  public translateY: number = 0;

  constructor(translateX: number, translateY: number) {
    this.translateX = translateX;
    this.translateY = translateY;
  }
}

export class ExitSplitParam {
  public needExitSplitRecent: boolean = true;
  public needRaise: boolean = true;
  public displayId: number = ViewModelConstant.INVALID_SCREEN_ID;
  public exitSplitEvent: SCBSessionEventId = SCBSessionEventId.EVENT_RECOVER;
  public exitSplitCommand = MonitorExitSplitName.DEFAULT;

  constructor() {
  }
}