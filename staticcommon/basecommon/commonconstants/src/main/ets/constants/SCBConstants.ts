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

/**
 * SceneBoard相关常量定义
 */
export class SCBConstants {
  /**
   * Bundle name of camera
   */
  static readonly CAMERA_BUNDLE = 'com.ohos.camera';

  /**
   * 通知和状态栏Module名
   */
  static readonly NTF_MANAGEMENT_MODULE: string = 'default_notificationmanagement';

  /**
   * 关闭2x4大文件夹事件通知
   */
  static readonly EVENT_BIG_FOLDER_GUIDANCE_ALREADY_OPEN: string = 'event.EVENT_BIG_FOLDER_GUIDANCE_ALREADY_OPEN';

  /**
   * SceneBoard应用包名
   */
  static readonly SCENE_BOARD_PKG: string = 'com.ohos.sceneboard';

  /**
   * oobe应用包名
   */
  static readonly OOBE_PKG: string = 'com.ohos.startupguide';

  /**
   * 玩机技巧包名
   */
  static readonly TIPS_BUNDLE_NAME = 'com.ohos.tips';

  /**
   * 负一屏包名
   */
  static readonly INTELLIGENT_BUNDLE_NAME = 'com.ohos.sceneboard.intelligent';

  /**
   * Bundle name of QuickAccessMenu
   */
  static readonly QUICK_ACCESS_MENU_BUNDLE: string = 'com.ohos.quickaccessmenu';

  /**
   * 默认图标
   */
  static readonly DEFAULT_ICON = '/common/pics/icon.png';

  /**
   * 默认系统颜色
   */
  static readonly DEFAULT_SYSTEM_UI_COLOR = '#00ffffff';

  /**
   * Default invalid value.
   */
  static INVALID_VALUE = -1;

  /**
   * Status code if Failed to StartAbility because enterprise device management disallow.
   */
  static readonly START_ABILITY_ENTERPRISE_LIMIT = 16000013;

  /**
   * Default WindowRadius 38.
   */
  static readonly DEFAULT_WINDOWS_RADIUS = 38;

  /**
   * Default WindowRadius 0.
   */
  static readonly DEFAULT_WINDOWS_RADIUS_0 = 0;

  /**
   * NOH WindowRadius 32.
   */
  static readonly DEFAULT_WINDOWS_RADIUS_N = '32';

  /**
   * CMS WindowRadius 36.
   */
  static readonly DEFAULT_WINDOWS_RADIUS_A = '36';

  /**
   * ALT WindowRadius 16.
   */
  static readonly DEFAULT_WINDOWS_RADIUS_T = '16';

  /**
   * WGR WindowRadius 16.
   */
  static readonly DEFAULT_WINDOWS_RADIUS_W = '16';

  /**
   * XYAO WindowRadius 19.
   */
  static readonly DEFAULT_WINDOWS_RADIUS_X = '19';

  /**
   * PCE WindowRadius 20.
   */
  static readonly DEFAULT_WINDOWS_RADIUS_P = '20';

  /**
   * BRA WindowRadius 38.
   */
  static readonly DEFAULT_WINDOWS_RADIUS_B = '38';

  /**
   * LEM WindowRadius 30.
   */
  static readonly DEFAULT_WINDOWS_RADIUS_L = '30';

  /**
   * ICL WindowRadius external screen is 17, main screen is 15.
   */
  static readonly DEFAULT_WINDOWS_RADIUS_I = '17,15';

  /**
   * MotionBlurRadius 0.5.
   */
  static readonly MOTION_BLUR_RADIUS = 0.5;

  /**
   * 无效的文件夹id
   */
  static readonly INVALID_FOLDER_ID = '-1';

  /**
   * FolderComponent max show length
   */
  static FOLDER_STATIC_SHOW_LENGTH = 11;

  /**
   *  type for cubic
   */
  static readonly CUBIC = 'cubic';

  /**
   * eventhub of theme edit
   */
  static readonly THEME_EDIT = 'theme_edit';

  /**
   *  type for easeOut
   */
  static readonly EASE_OUT = 'easeOut';

  /**
   * 浅色模式融球亮度
   */
  static readonly LIGHT_COLOR_MODE_MELTBALL_BRIGHTNESS = 'brightness(0.95)';

  /**
   * 深色模式融球亮度
   */
  static readonly DARK_COLOR_MODE_MELTBALL_BRIGHTNESS = 'brightness(1.05)';

  /**
   * 融球颜色
   */
  static readonly MELTBALL_COLOR = ' #2E3033';

  /**
   * 融球透明度
   */
  static readonly MELTBALL_TRANSPARENCY = 0.7;

  static readonly COMPATIBILITYMODE_SCENE_BG_COLOR = '#40ffffff';

  static readonly START_SCENE_BG_COLOR = '#33000000';

  static readonly START_SCENE_BG_BLUR_SCALE = 1.0;

  static readonly DEFAULT_SCENE_BG_COLOR = '#00000000';

  static readonly APP_CENTER_BG_BLUR_COLOR = '#4d1a1a1a';

  static readonly APP_CENTER_BG_BLUR_RADIUS = 75;

  static readonly SCENE_PANEL_BG_BLUR_COLOR = this.APP_CENTER_BG_BLUR_COLOR;

  static readonly SCENE_PANEL_BG_BLUR_RADIUS = this.APP_CENTER_BG_BLUR_RADIUS;

  static readonly CTRL_ALT_DELETE_PANEL_BG_BLUR_COLOR = this.APP_CENTER_BG_BLUR_COLOR;

  static readonly CTRL_ALT_DELETE_PANEL_BG_BLUR_RADIUS = this.APP_CENTER_BG_BLUR_RADIUS;

  static readonly CTRL_ALT_DELETE_PANEL_SATURATION = 1.4;

  static readonly DESKTOP_IS_FREEZE = 'isFreeze';

  static readonly EXIT_APP_ANIMATE = 'exitAppAnimate';

  static readonly DESKTOP_BG_IMAGE = 'desktopBgImage';

  static readonly IS_FREEZE_FOR_QUICKSWITCH = 'isFreezeForQuickSwitch';

  static readonly IS_ACCESSIBILITY_MODE_OPEN = 'isAccessibilityModeOpen';

  static readonly IS_START_BY_LAUNCHTYPE_CONFIG = 'isStartByLaunchTypeConfig';

  static readonly START_APP_CLONE_INDEX = 'ohos.extra.param.key.appCloneIndex';

  static readonly EVENT_UPDATE_FONT_COLOR = 'updateFontColorEvent';

  static readonly KEY_SCREEN_ID = 'screenId';

  static readonly BACK_PLANE_BRIGHTNESS_UP_FIVE_PERCENT = 1.05;

  static readonly BACK_PLANE_BRIGHTNESS_UP_TEN_PERCENT = 1.1;

  static readonly BACK_PLANE_BRIGHTNESS_UP_FIFTEEN_PERCENT = 1.15;

  static readonly BACK_PLANE_BRIGHTNESS_DOWN_FIVE_PERCENT = 0.95;

  static readonly BACK_PLANE_BRIGHTNESS_DOWN_EIGHT_PERCENT = 0.92;

  static readonly BACK_PLANE_BRIGHTNESS_DEFAULT = 1;

  static readonly DEFAULT_DOTS_PER_INCH = 200;

  /**
   *  type for uiType
  */
  static readonly UITYPE_PC = 'pc';

  static readonly UITYPE_PHONE = 'phone';

  static readonly UITYPE_PAD = 'pad';

  /**
   *  type for rotation mode
   */
  static readonly WINDOW_ROTATION = 'windowRotation';

  static readonly SCREEN_ROTATION = 'screenRotation';

  /**
   * default window offset of Quick_Access_Menu
   */
  static readonly QUICK_ACCESS_MENU_TOP_OFFSET: number = 274;

  static readonly QUICK_ACCESS_MENU_RIGHT_OFFSET: number = 6;

  static readonly QUICK_ACCESS_MENU_CONFIG_FILE_PATH: string = 'etc/quickaccessmenu/phone_param_config.json';

  static readonly DEFAULT_QUICK_ACCESS_MENU_HEIGHT = 68;

  static readonly DEFAULT_QUICK_ACCESS_MENU_WIDTH = 6;

  static readonly QUICK_ACCESS_MENU_XKEY_TOP_OFFSET: number = 190.4;

  static readonly QUICK_ACCESS_MENU_LEFT_OFFSET: number = 20;

  static readonly DEFAULT_QUICK_ACCESS_MENU_SIZE = 40;

  public static readonly QUICK_ACCESS_FUNCTION_TYPE: string = 'const.quickaccess.function_type';

  public static readonly QUICK_ACCESS_FUNCTION_SMART_KEY: string = '0';

  public static readonly QUICK_ACCESS_FUNCTION_X_KEY: string = '1';

  public static readonly QUICK_ACCESS_FUNCTION_NOT_SUPPORT: string = '-1';

  public static readonly START_BY_PANEL: string = 'start_by_panel';

  /**
   * multi instance
   */
  static readonly CREATE_NEW_APP_INSTANCE_KEY = 'ohos.extra.param.key.createNewAppInstance';

  static readonly OPEN_IN_NEW_WINDOW = 'openInNewWindow';

  /**
   * 杀死进程返回桌面动效开始
   */
  static readonly SCENE_CONTAINER_DESTRUCTION_START = 'SceneContainerDestructionStart';

  /**
   * 上划返回桌面动效开始
   */
  static readonly SCENE_CONTAINER_TRANSITION_OUT_START = 'sceneContainerTransitionOutStart';

  /**
   * 退出多任务动效开始
   */
  static readonly EXIT_RECENT = 'exitRecent';

  /**
   * 多出多任务动效结束
   */
  static readonly RESET_DESKTOP_AFTER_EXIT_RECENT = 'resetDesktopAfterExitRecent';

  /**
   * 返回桌面动效结束
   */
  static readonly SCENE_CONTAINER_TRANSITION_OUT_END = 'sceneContainerTransitionOutEnd';


  static readonly START_FROM_SHORTCUT_ID = 'START_FROM_SHORTCUT_ID';

  static readonly DIVIDER_WIDTH = 12;

  /**
   * 取hds固定模版图标，包名需添加的后缀
   */
  static readonly BUNDLENAME_APPEND_TEMPLATE = '_template';

  /**
   * PAD 竖扫屏类型
   */
  static readonly SCREEN_SCAN_TYPE_VERTICAL = 1;

  static readonly ICON_DATA_DEBUG = 'ICON_DATA_DEBUG'

  static readonly NEAR_ZERO_VALUE = 0.01;
}

/**
 * rotation for phone
 */
export class RotationConstants {
  /**
   * INVALIDED
   */
  static readonly ROTATION_INVALIDED = -1;
  /**
   * 0°
   */
  static readonly ROTATION_0 = 0;
  /**
   * 90°
   */
  static readonly ROTATION_90 = 90;
  /**
   * 180°
   */
  static readonly ROTATION_180 = 180;
  /**
   * 270°
   */
  static readonly ROTATION_270 = 270;
  /**
   * 360°
   */
  static readonly ROTATION_360 = 360;
}

export class DividerStyleConstants {
  static readonly DEFAULT_SPLIT_MIN_SCENE_WIDTH = 320;
  static readonly DEFAULT_SPLIT_MIN_SCENE_HEIGHT = 320;
  static readonly SPLIT_COVER_DEFAULT_COLOR = '#00000000';
  static readonly PERCENT = 100;
  static readonly DIVIDER_CIRCLE_MARGIN = 2;
  static readonly DIVIDER_HEIGHT = 8;
  static readonly DIVIDER_WIDTH_FOLD_SCENE = 12;
  static readonly DIVIDER_CIRCLE_WIDTH = 6;
  static readonly DIVIDER_CIRCLE_HEIGHT = 4;
  static readonly DIVIDER_BUTTON_WIDTH = 4;
  static readonly DIVIDER_BUTTON_HEIGHT = 64;
  static readonly DIVIDER_BUTTON_HOT_WIDTH = 24;
  static readonly DIVIDER_BUTTON_HOT_HEIGHT = 96;
  static readonly SPLIT_COVER_DRAGGING_COLOR = '#CCFFFFFF';
  static readonly SPLIT_COVER_EXIT_COLOR = '#99000000';
  static readonly SPLIT_BORDER_RADIUS = 16;
  static readonly SPLIT_RATIO_HALF = 0.5;
  static readonly RATIO_ONE_TO_THREE = 1 / 3;
  static readonly RATIO_TWO_TO_THREE = 2 / 3;
}

export class MidSceneConstants {
  static readonly MAX_SCENE_INDEX: number = 5;
  static readonly MARGIN:number = 40;
  static readonly GUTTER:number = 12;
  static readonly ROTATE_ANGLE:number = 40;
  static readonly LEFT_ROTATE_RATIO = 1 / 3;
  static readonly RIGHT_ROTATE_RATIO = 2 / 3;
  static readonly SCALE_RATIO = 1 / 2;
}

export class MultiWindowEventConstants {
  // event for one step split
  static readonly EVENT_ONE_STEP_SPLIT = 'multiwindow.event.EVENT_ONE_STEP_SPLIT';
}

export class HoverConstants {

  /**
   * the scale of hover animation
   */
  static readonly HOVER_DEFAULT_SCALE: number = 1.0;
  static readonly HOVER_SETTING_BTN_SCALE: number = 1.1;
  static readonly HOVER_QUICK_BTN_SCALE: number = 1.05;
  static readonly HOVER_MEDIA_CARD_SCALE: number = 1.03;
  static readonly HOVER_BRIGHTNESS_SCALE: number = 1.02;
  static readonly HAD_HOVER_BRIGHTNESS_SCALE: number = 1.04;

  /**
   * the duration of hover animate
   */
  static readonly HOVER_ANIMATE_DURATION: number = 250;
}

/**
 * cmd id for increase frequency
 */
export class PerfCmdId {
  /**
   * app cold start boost cmdId
   */
  static readonly APP_START: number = 10000;

  /**
   * animation boost cmdId
   */
  static readonly ANIMATION_BOOST: number = 10030;

  /**
   * animation rotation cmdId
   */
  static readonly ANIMATION_ROTATION: number = 10027;
}

/**
 * 资源更新类型:更新、删除、全量、未更新
 */
export enum UpdateType {
  UPDATE,
  DELETE,
  FULL,
  NONE
}

/**
 * multi-widow SplitType
 */
export enum SplitType {
  UNKNOWN,
  FULL_SCREEN,
  UP_DOWN_SPLIT,
  LEFT_RIGHT_SPLIT
}

/**
 * multi-widow OneStepSplitType
 */
export enum OneStepSplitType {
  UNKNOWN,
  UP_POS,
  LEFT_POS,
  RIGHT_POS
}

/**
 * 卡片类型, 0-普通卡片 1-互动卡片-场景动效 2-互动卡片-趣味交互
 */
export enum FormType {
  COMMON_FORM_TYPE,
  ANIMATION_FORM_TYPE,
  INTERACTION_FORM_TYPE,
}

export class OverflowConstants {
  public static readonly INTENT_KEY_GAMECARD = 'gameCardInfo';

  public static readonly INTENT_KEY_LIVE_FORM_CARD = 'liveFormCardInfo';

  public static readonly QUICK_TYPE_GAMECARD: string = 'quick';

  public static readonly INTENT_KEY_FORM_ABILITY = 'formBindAbility';

  public static readonly ANIMATION_TYPE: string = 'sceneAnimation';

  public static readonly INTERACTION_TYPE: string = 'funInteraction';

  public static readonly RADIUS_CHANGE_CALLBACK_TYPE: string = 'radiusChange';

  public static readonly EMPTY_FORM_ID: string = 'emptyFormId';

  public static readonly CONFIG_PARAM_LENGTH_LIMIT: number = 256;

  public static readonly QUICK_GAME_START_FLAG: number = 1;

  public static readonly OVERFLOW_ACTIVE_TIMER: number = 10000;

  public static readonly GAME_CARD_MAX_PAUSE_TIME: string = '10000';

  public static readonly MAX_ANIMATION_DURATION_DEFAULT: number = 3500;

  public static readonly LIVE_FORM_MAX_ANIMATION_DURATION: string = '3500';

  public static readonly LONG_OVERFLOW_DURATION_DEFAULT: number = 60000;

  public static readonly LIVE_FORM_LONG_OVERFLOW_DURATION: string = '60000';

  public static readonly LIVE_FORM_SCALE_RATIO: string = '2,1.5,1.25,1.1';

  public static readonly FORM_BIND_ABILITY_DEFAULT: string = 'GameLoaderExtensionAbility';

  public static readonly LIVE_FORM_MAX_ACTIVATION_NUMBER_DEFAULT: string = '5';

  // 互动卡片触发信息
  public static readonly CONNECTION_INFO: string = 'connection_info';

  /**
   * 异常断开时长: 2小时
   */
  public static readonly OVERFLOW_FORM_PAUSE_TOTAL_DURATION: number = 2 * 60 * 60 * 1000;

  /**
   * 首次激活或者间隔超过2小时，打点上报-1
   */
  public static readonly INIT_INTERVAL: number = -1;

  /**
   * 溢出卡片打点相关变量
   */
  public static readonly SUBBUNDLENAME_DEFAULT: string = 'None';

  /**
   * 溢出效果终止
   */
  public static readonly STOP_OVERFLOW: string = 'stopOverflow';

  /**
   * 横竖屏旋转
   */
  public static readonly SCREEN_ROTATION: string = 'screenRotation';

  /**
   * 水平滑动翻页手势启动
   */
  public static readonly START_SWIPE: string = 'startSwipe';

  /**
   * 水平滑动翻页手势停止
   */
  public static readonly END_SWIPE: string = 'endSwipe';

  /**
   * 溢出卡片进入后台
   */
  public static readonly ON_BACKGROUND: string = 'onBackground';

  /**
   * 溢出卡片进入前台
   */
  public static readonly ON_FOREGROUND: string = 'onForeground';

  /**
   * 卡片切换到激活态处理完毕
   */
  public static readonly EXTENSION_READY: string = 'extensionReady';

  /**
   * 长按卡片
   */
  public static readonly LONG_PRESS: string = 'longPress';

  /**
   * 溢出失败
   */
  public static readonly OVERFLOW_FAILED: string = 'overflowFailed';
}

export class SceneConstants {
  /* transform scene id */
  static readonly TRANSFORM_SCENE: number = -1;
}

/**
 * 相机预启动类型
 */
export enum PreLaunchType {
  TOUCH_DOWN = 0,
  TOUCH_UP = 1,
  TOUCH_CANCEL = 2,
}

/**
 * RDB错误码
 */
export enum DBErrorCode {
  DEVICE_VERSION_GET_FAILED = 100001,
}
