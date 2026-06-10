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
import { DeviceHelper } from '@ohos/frameworkwrapper';

/**
 * cons data
 *
 * @since 2022-06-09
 */
export default class Constants {
  public static readonly WIN_NAME = 'ScreenLockWindow';

  /**
   * Seconds to minutes
   */
  public static readonly SECOND_TO_MINUTE: number = 60;

  /**
   * 解锁成功后延迟1帧通知桌面绘制
   */
  public static readonly NOTIFICATION_DELAY: number = 10;

  /**
   * milliseconds to seconds
   */
  public static readonly MILLISECOND_TO_SECOND: number = 1000;

  /**
   * min unlock sliding distance
   */
  public static readonly SLIDING_LENGTH: number = 100;

  /**
   * min unlock sliding distance
   */
  public static readonly MIN_SLIDING_Y_DISTANCE: number = 80;

  /**
   * unlock animation duration
   */
  public static readonly UNLOCK_ANIMATION_DURATION: number = 200;

  /**
   * remove brightness animation duration
   */
  public static readonly REMOVE_BRIGHTNESS_ANIMATION_DURATION: number = 100;

  /**
   * remove brightness animation duration for aod to desktop
   */
  public static readonly AOD_REMOVE_BRIGHTNESS_DURATION: number = 200;

  /**
   * remove brightness animation delay for aod to desktop
   */
  public static readonly AOD_REMOVE_BRIGHTNESS_DELAY: number = 100;

  /**
   * max password length
   */
  public static readonly PASSWORD_MAX_LEN: number = 32;

  /**
   * max password length in SIM locked
   */
  public static readonly SIM_PASSWORD_MAX_LEN: number = 8;

  /**
   * call phone key in digital keyboard
   */
  public static readonly CALL_PHONE: number = -1;

  /**
   * delete in digital keyboard
   */
  public static readonly DEL_PWD: number = -2;

  /**
   * back in digital keyboard
   */
  public static readonly GO_BACK: number = -3;

  /**
   * emergency call in digital keyboard
   */
  public static readonly EMERGENCY_CALL: number = -4;

  /**
   * back in pattern keyboard
   */
  public static readonly GO_BACK_PATTERN: number = -5;

  /**
   * emergency call in pattern keyboard
   */
  public static readonly EMERGENCY_CALL_PATTERN: number = -6;

  /**
   * delete index in digital keyboard
   */
  public static readonly DEL_PWD_INDEX: number = 11;

  public static readonly DEL_PWD_INDEX_RTL: number = 9;

  /**
   * Pattern drawing completed
   */
  public static readonly PATTERN_DRAW_COMPLETED: number = 12;

  /**
   * Start drawing the pattern
   */
  public static readonly START_DRAW_PATTERN: number = 13;

  /**
   * call bundleName
   */
  public static readonly EMERGENCY_CALL_BUNDLE_NAME: string = 'com.ohos.emergencycommunication';

  /**
   * call abilityName
   */
  public static readonly EMERGENCY_CALL_ABILITY_NAME: string = 'com.ohos.emergencycommunication.EmergencyCallAbility';

  /**
   * call moduleName
   */
  public static readonly EMERGENCY_CALL_MODULE_NAME: string = 'entry';

  /**
   * image solid dot component id
   */
  public static readonly COMPONENT_ID_SOLID_DOT = 'screenLock_Image_solidDot';

  /**
   * image back component id
   */
  public static readonly COMPONENT_ID_BACK = 'screenLock_Image_back';

  /**
   * contact component id
   */
  public static readonly COMPONENT_ID_CONTACTS_GROUP = 'screenLock_Image_contactsGroup';

  /**
   * other users component id
   */
  public static readonly COMPONENT_ID_OTHER_USERS = 'screenLock_Text_otherUsers';

  /**
   * password tip component id
   */
  public static readonly COMPONENT_ID_ENTER_PSD = 'screenLock_Text_enterPsd';

  /**
   * password prompt component id
   */
  public static readonly COMPONENT_ID_PROMPT = 'screenLock_Text_prompt';

  /**
   * password input component id
   */
  public static readonly COMPONENT_ID_PASSWORD = 'screenLock_TextInput_password';

  /**
   * time view default size
   */
  public static readonly SIZE_TIME_DEFAULT: number = 96;

  /**
   * notification mode time view size
   */
  public static readonly SIZE_TIME_NOTIFICATION: number = 78;

  /**
   * date view default size
   */
  public static readonly SIZE_DATA_DEFAULT: number = 16;

  /**
   * notification mode date view size
   */
  public static readonly SIZE_DATA_NOTIFICATION: number = 14;

  /**
   * screen lock psd init scale
   */
  public static readonly PSD_INIT_SCALE: number = 0.8;

  /**
   * screen lock number keyboard init scale
   */
  public static readonly NUM_KEYBOARD_INIT_SCALE: number = 0.6;

  /**
   * screen lock adjacent number dist in x
   */
  public static readonly PRE_NUMBER_BIAS_X: number = 121.6;

  /**
   * screen lock adjacent number dist in y
   */
  public static readonly PRE_NUMBER_BIAS_Y: number = 76.8;

  /**
   * distance per turn in screen lock psd enter animation
   */
  public static readonly DIST_PER_TURN: number = 18;

  /**
   * psd translation factor in x
   */
  public static readonly PSD_TRANS_X_FACTOR: number = 0.43;

  /**
   * psd translation factor in y
   */
  public static readonly PSD_TRANS_Y_FACTOR: number = 1.3;

  /**
   * psd animation delay time per turn
   */
  public static readonly DELAY_TIME_PER_TURN: number = 33;

  /**
   * 进入紧急呼叫后返回锁屏主页面延迟时间
   */
  public static readonly DELAY_TIME_BACK_TO_KEYGUARD: number = 300;

  /**
   * psd animation mass
   */
  public static readonly PSD_MASS: number = 1;

  /**
   * psd animation stiffness
   */
  public static readonly PSD_STIFFNESS: number = 1500;

  /**
   * psd animation damping
   */
  public static readonly PSD_DAMPING: number = 77;

  /**
   * psd enter delay time (ms)
   */
  public static readonly PSD_ENTER_DELAY: number = 190;

  /**
   * max screen slide unlock speed
   */
  public static readonly MAX_SLIDE_UNLOCK_SPEED = 30000;

  /**
   * unlock animation response
   */
  public static readonly UNLOCK_TRANSITION_RESPONSE: number = 0.416;

  /**
   * unlock animation fraction
   */
  public static readonly UNLOCK_TRANSITION_FRACTION: number = 0.99;

  /**
   * default zoom ratio
   */
  public static readonly DEFAULT_ZOOM_RATIO: number = 1.0;

  /**
   * default slide ratio
   */
  public static readonly DEFAULT_SLIDE_RATIO: number = 1.0;

  /**
   * default scale ratio
   */
  public static readonly DEFAULT_SCALE: number = 1.0;

  /**
   * psd enter icon background blur
   */
  public static readonly ENTER_BACKGROUND_BLUR: number = 50;

  /**
   * password view default opacity
   */
  public static readonly DEFAULT_OPACITY_PWD: number = 1.0;

  /**
   * state bar view default opacity
   */
  public static readonly DEFAULT_OPACITY_STATE_BAR: number = 1.0;

  /**
   * password view default scale
   */
  public static readonly DEFAULT_ZOOM_RATIO_PWD: number = 1.0;

  /**
   * home view default opacity
   */
  public static readonly DEFAULT_HOME_VIEW_OPACITY: number = 0;

  /**
   * wallpaper default opacity
   */
  public static readonly DEFAULT_WALLPAPER_OPACITY: number = 1.0;

  /**
   * default blur radius
   */
  public static readonly DEFAULT_BLUR_RADIUS: number = 0;

  /**
   * wallpaper default scale
   */
  public static readonly DEFAULT_WALLPAPER_SCALE: number = 1.1;

  /**
   * wallpaper default scale, pad only
   */
  public static readonly DEFAULT_WALLPAPER_SCALE_PAD: number = 1.0;

  /**
   * scb wallpaper default scale
   */
  public static readonly DEFAULT_SCB_WALLPAPER_SCALE: number = 1.05;

  /**
   * scenePanel scale in screen lock
   */
  public static readonly MAX_SCENE_SCALE = 1.1;

  /**
   * max scale in unlock animate
   */
  public static readonly MAX_ZOOM_RATIO: number = 1.1;

  /**
   * max scale in slide animate
   */
  public static readonly MAX_SLIDE_RATIO: number = 1.1;

  /**
   * used for animation abort
   */
  public static readonly DIFF_RATIO: number = 0.001;

  /**
   * used for unlock blur animation
   */
  public static readonly MAX_FOREGROUND_BLUR_RADIUS: number = 29;

  /**
   * default opacity of account in unlock animation
   */
  public static readonly DEFAULT_ACCOUNT_OPACITY: number = 0;

  /**
   * default account offset in unlock animate
   */
  public static readonly DEFAULT_ACCOUNT_OFFSET: number = 0;

  /**
   * max account offset in unlock animate
   */
  public static readonly MAX_ACCOUNT_OFFSET: number = 30;

  /**
   * min opacity of passwordView in unlock animation
   */
  public static readonly MIN_OPACITY_PWD: number = 0;

  /**
   * min opacity of state bar in unlock animation
   */
  public static readonly MIN_OPACITY_STATER_BAR: number = 0;

  /**
   *  min scale of passwordView in unlock animation
   */
  public static readonly MIN_ZOOM_RATIO_PWD: number = 0.9;

  /**
   *  max scale of passwordView in unlock animation
   */
  public static readonly MAX_ZOOM_RATIO_PWD: number = 1.1;

  /**
   * min opacity of wallpaper in unlock animation
   */
  public static readonly MIN_WALLPAPER_OPACITY: number = 0;

  /**
   * min scale of wallpaper in unlock animation
   */
  public static readonly MIN_WALLPAPER_SCALE: number = 1.05;

  /**
   * max opacity in unlock animation
   */
  public static readonly MAX_VIEW_OPACITY: number = 150;

  /**
   *  max scale of passwordView in auth success animation
   */
  public static readonly MAX_SCALE_WHEN_PWD_CHECKED: number = 1.1;

  /**
   * scenePanel scale in screen unlock
   */
  public static readonly MIN_SCENE_SCALE: number = 1.0;

  /**
   * wallpaper pwd blur
   */
  public static readonly MAX_WALLPAPER_BLUR: number = 1;

  /**
   * 锁屏页面通知小图标显隐动画时长
   * 需要与NotificationListComponent页面动画时长保持一致
   */
  public static readonly ANIMATION_DURATION_DEFAULT: number = 500;

  /**
   * Screen lock psd enter opacity duration (ms)
   */
  public static readonly PSD_ENTER_OPACITY_TIME = 150;

  /**
   * 沉浸式列表态锁屏卡片大小
   */
  public static readonly IMMERSIVE_LIST_CARD_SCALE: number = 0.9;
  /**
   * AOD状态下锁屏卡片大小
   */
  public static readonly AOD_CARD_SCALE: number = 0.95;

  /**
   * Hour to day
   */
  public static readonly HOURS_TO_DAY: number = 24;

  /**
   * Minute to hour
   */
  public static readonly MINUTE_TO_HOURS: number = 60;

  /**
   * power event(BEGIN_WAKEUP)
   */
  public static readonly SCREEN_LOCK_BEGIN_WAKEUP: string = 'ScreenLockBeginWakeup';

  /**
   * power event(END_SLEEP)
   */
  public static readonly SCREEN_LOCK_END_SLEEP: string = 'ScreenLockEndSleep';

  /**
   * Camera movement exceeding the threshold is considered a sliding operation, the unit is vp
   */
  public static readonly CAMERA_MOVE_ACTION_THRESHOLD: number = 8;

  /**
   * If the camera moves beyond the threshold, the camera is fully displayed.
   */
  public static readonly CAMERA_MOVE_UP_THRESHOLD: number = 0.5;
  public static readonly CAMERA_WALLPAPER_MOVE_UP_VELOCITY: number = 3;

  /**
   * vp/ms
   */
  public static readonly CAMERA_MOVE_VELOCITY_THRESHOLD: number = 1600;

  public static readonly CAMERA_SCALE_START: number = 0.8;
  public static readonly CAMERA_SCALE_END: number = 1;
  public static readonly CAMERA_OPACITY_START: number = 0;
  public static readonly CAMERA_OPACITY_END: number = 1;
  public static readonly CAMERA_OFFSET_START: number = 0.123;
  // vp
  public static readonly CAMERA_OFFSET_END: number = 0;

  public static readonly CAMERA_VELOCITY: number = 0;
  public static readonly CAMERA_MASS: number = 1;
  public static readonly CAMERA_UP_STIFFNESS: number = 600;
  public static readonly CAMERA_UP_DAMPING: number = 49;
  public static readonly CAMERA_UP_DURATION: number = 440;
  public static readonly CAMERA_DOWN_STIFFNESS: number = 288;
  public static readonly CAMERA_DOWN_DAMPING: number = 34;
  public static readonly CAMERA_DOWN_DURATION: number = 630;
  public static readonly CAMERA_ENABLE_OPACITY: number = 1;
  public static readonly CAMERA_DISABLE_OPACITY: number = 0.6;

  public static readonly CAMERA_MOVE_X1: number = 0.2;
  public static readonly CAMERA_MOVE_Y1: number = 0;
  public static readonly CAMERA_MOVE_X2: number = 0.2;
  public static readonly CAMERA_MOVE_Y2: number = 1.0;

  public static readonly CAMERA_TIPS_HEIGHT: number = 150;

  public static readonly FINGERPRINT_OPACITY_START: number = 1;
  public static readonly FINGERPRINT_OPACITY_END: number = 0;
  public static readonly FINGERPRINT_OPACITY_THRESHOLD: number = 18;
  public static readonly FINGERPRINT_OPACITY_STIFFNESS: number = 300;
  public static readonly FINGERPRINT_OPACITY_DAMPING: number = 28;

  public static readonly CAMERA_PAN_GESTURE_START_THRESHOLD: number = 18;
  public static readonly CAMERA_PAN_GESTURE_DISTANCE_THRESHOLD: number = 10;

  public static readonly SCREEN_LEFT: number = -1;
  public static readonly SCREEN_RIGHT: number = 1;
  public static readonly NO_TOUCH_OR_SCREEN_MIDDLE: number = 0;

  // screenLock second level's animation delay time
  public static readonly SCREEN_LOCK_SECOND_LEVEL_DELAY: number = 50;
  // screenLock third level's animation delay time
  public static readonly SCREEN_LOCK_THIRD_LEVEL_DELAY: number = 100;
  // screenLock fourth level's animation delay time
  public static readonly SCREEN_LOCK_FOURTH_LEVEL_DELAY: number = 150;
  public static readonly SCREEN_LOCK_SCREEN_CHANGE_ANIMATION_VELOCITY: number = 0;
  public static readonly SCREEN_LOCK_SCREEN_CHANGE_ANIMATION_MASS: number = 0;
  public static readonly SCREEN_LOCK_SCREEN_CHANGE_ANIMATION_STIFFNESS: number = 128;
  public static readonly SCREEN_LOCK_SCREEN_CHANGE_ANIMATION_DAMPING: number = 17;
  public static readonly SCREEN_LOCK_TO_AOD_OFF_SCREEN_ANIMATION_NUMBER: number = 5;
  public static readonly DESKTOP_TO_AOD_OFF_SCREEN_ANIMATION_NUMBER: number = 2;
  public static readonly NOTIFY_OFF_SCREEN_OPEN_LCD: number = 2;
  public static readonly NOTIFY_OFF_SCREEN_CLOSE_LCD: number = 3;
  public static readonly LIGHT: number = 1;
  public static readonly EXTREME_LIGHT: number = 2;

  public static readonly SCREENLOCK_LOCK_ICON_HEIGHT: number = 44;
  public static readonly SMALL_SCREENLOCK_LOCK_ICON_HEIGHT: number = 36;
  public static readonly SINGLE_POCKET_SCREENLOCK_LOCK_ICON_HEIGHT: number = 42;
  public static readonly SCREENLOCK_LOCK_ICON_HEIGHT_PAD: number = 44;
  public static readonly SCREENLOCK_LOCK_ICON_MARGIN_TOP: number = 55;
  public static readonly LOAD_REMIND_TEXT_MARGIN_BOTTOM: string = '56vp';
  public static readonly LOAD_REMIND_TEXT_WIDTH: string = '86.67%';
  public static readonly SMALL_LOAD_REMIND_TEXT_MARGIN_BOTTOM: string = '24vp';
  public static readonly SMALL_LOAD_REMIND_TEXT_WIDTH: string = '85.37%';
  public static readonly SMALL_SCREENLOCK_CLOCK_WIDGET_MARGIN_TOP: number = 0;
  public static readonly SCREENLOCK_LOCK_ICON_MARGIN_TOP_SMALL_FOLD: number = 10;
  public static readonly SCREENLOCK_LOCK_ICON_MARGIN_TOP_PAD: number = 55;
  public static readonly SCREENLOCK_LOCK_DISABLE_TOAST_SHOW: number = 1500;
  public static readonly SCREENLOCK_LOCK_DISABLE_TOAST_BOTTOM_MARGIN: number = 90;

  public static readonly SETTINGS_BUNDLE_NAME: string = 'com.ohos.settings';

  public static readonly OUTER_SCREEN_UNLOCK_ERROR_TOAST_TOP_MARGIN: number = 36;
  /**
   * 直板机锁屏页面快捷工具和相机图标边距
   */
  public static readonly SCREEN_LOCK_GADGET_MARGIN: number = 16;
  /**
   * 折叠屏展开锁屏页面快捷工具和相机图标边距
   */
  public static readonly SCREEN_LOCK_GADGET_MARGIN_EXPAND: number = 32;
  /**
   * 小折叠屏折叠态锁屏页面快捷工具和相机图标边距
   */
  public static readonly SCREEN_LOCK_GADGET_MARGIN_SMALL_FOLD: number = 20;
  /**
   * 外屏卡片面板宽度
   */
  public static readonly OUTER_PANEL_WIDTH: number = 190.67;
  /**
   * 外屏卡片面板高度
   */
  public static readonly OUTER_SCREEN_FORM_PANEL_HEIGHT: number = 68;
  /**
   * 外屏卡片容器高度
   */
  public static readonly OUTER_SCREEN_GRID_HEIGHT: number = 88;
  /**
   * 外屏卡片容器上下内边距
   */
  public static readonly OUTER_SCREEN_GRID_PADDING_HEIGHT: number = 20;
  /**
   * 外屏卡片容器左右内边距
   */
  public static readonly OUTER_SCREEN_GRID_PADDING_WIDTH: number = 31.56;
  /**
   * 外屏卡片组件高度
   */
  public static readonly OUTER_SCREEN_FORM_COMPONENT_HEIGHT: number = 48;
  /**
   * 外屏卡片组件距离屏幕边缘外间距
   */
  public static readonly OUTER_SCREEN_FORM_COMPONENT_MARGIN: number = 20;
  /**
   * 外屏卡片半径
   */
  public static readonly OUTER_SCREEN_FORM_COMPONENT_RADIUS: number = 24;
  /**
   * 外屏卡片尺寸
   */
  public static readonly OUTER_SCREEN_SINGLE_CARD_SIZE: number = 48;
  /**
   * 外屏卡片间隔
   */
  public static readonly OUTER_SCREEN_GRID_GAP: number = 31.56;
  /**
   * 外屏卡片显隐动效时长
   */
  public static readonly OUTER_SCREEN_CARD_OPACITY_DURATION: number = 150;
  /**
   * 外屏卡片显隐动效延迟
   */
  public static readonly OUTER_SCREEN_CARD_OPACITY_DELAY: number = 100;
  /**
   * pad横屏锁屏页面快捷工具和相机图标边距
   */
  public static readonly SCREEN_LOCK_GADGET_MARGIN_PAD: number = 48;
  /**
   * pad竖屏锁屏页面快捷工具和相机图标边距
   */
  public static readonly SCREEN_LOCK_GADGET_MARGIN_PAD_PORTRAIT: number = 64;

  // screenLock space animate view ids
  public static readonly SCREENLOCK_LOCK_ID_ICON: string = 'lockIconId';
  public static readonly SCREENLOCK_LOCK_ID_FROM: string = 'lockFromId';
  public static readonly SCREENLOCK_LOCK_ID_CLOCK_WIDGET: string = 'clockWidgetId';
  public static readonly SCREENLOCK_LOCK_ID_QUICK_TOOLS: string = 'lockQuickToolsId';
  public static readonly SCREENLOCK_LOCK_ID_IMMERSIVE_CAP: string = 'immersiveCapId';
  public static readonly SCREENLOCK_LOCK_ID_IMMERSIVE_LIST: string = 'immersiveListId';
  public static readonly SCREENLOCK_LOCK_ID_IMMERSIVE_CARD: string = 'immersiveCardId';
  public static readonly SCREENLOCK_LOCK_ID_GREET: string = 'slGreetId';
  public static readonly SCREENLOCK_LOCK_ID_CAMERA: string = 'cameraId';

  public static readonly FEATURE_NAME = 'featureScreenLockShortcut';

  public static readonly FINGER_PRINT_SHRINKING_SIZE :number = 10;
  public static readonly FINGER_PRINT_POSITION_SHRINKING :number = 5;

  public static readonly SCREEN_LOCK_CLOCK_LIMIT_ACCESSIBILITY: number = 6;
  public static readonly PIN_TYPE_MIX: string = 'PIN_MIXED';
  public static readonly CLOCK_DEFAULT_FOREGROUND_COLOR: string = '#FFFFFF';
  public static readonly EMOJI_REGEX =
    /(?:[\u2700-\u27bf]|(?:\ud83c[\udde6-\uddff]){2}|[\ud800-\udbff][\udc00-\udfff]|[\u0023-\u0039]\ufe0f?\u20e3|\u3299|\u3297|\u303d|\u3030|\u24c2|\ud83c[\udd70-\udd71]|\ud83c[\udd7e-\udd7f]|\ud83c\udd8e|\ud83c[\udd91-\udd9a]|\ud83c[\udde6-\uddff]|\ud83c[\ude01-\ude02]|\ud83c\ude1a|\ud83c\ude2f|\ud83c[\ude32-\ude3a]|\ud83c[\ude50-\ude51]|\u203c|\u2049|[\u25aa-\u25ab]|\u25b6|\u25c0|[\u25fb-\u25fe]|\u00a9|\u00ae|\u2122|\u2139|\ud83c\udc04|[\u2600-\u26FF]|\u2b05|\u2b06|\u2b07|\u2b1b|\u2b1c|\u2b50|\u2b55|\u231a|\u231b|\u2328|\u23cf|[\u23e9-\u23f3]|[\u23f8-\u23fa]|\ud83c\udccf|\u2934|\u2935|[\u2190-\u21ff])/g;
  ;
  public static readonly AOD_BRIGHTNESS: number = 1.03;
  public static readonly AOD_RADIUS: number = 35;

  public static readonly IMMEDIATELY_UNLOCK_EXIT_KEYGUARD_TIMEOUT: number = 900;

  public static readonly SCREEN_LOCK_EDIT_ACCESSIBLE = $r('app.string.screen_lock_edit_accessible');
  public static readonly ENTER_EDIT_ACCESSIBLE = $r('app.string.enter_edit_mode_accessible');
  public static readonly ENTER_CLOCK_EDIT_ACCESSIBLE = $r('app.string.enter_clock_edit_mode_accessible');
  public static readonly EXIT_CLOCK_EDIT_ACCESSIBLE = $r('app.string.exit_clock_edit_mode_accessible');
  public static readonly ENTER_OUTSCREEN_THEME_SELECTION_ACCESSIBLE = $r('app.string.enter_outscreen_theme_selection_accessible');
  public static readonly EXIT_EDIT_ACCESSIBLE = $r('app.string.exit_edit_mode_accessible');
  public static readonly EXIT_OUTSCREEN_THEME_SELECTION_ACCESSIBLE = $r('app.string.exit_outscreen_theme_selection_accessible');
  public static readonly DOUBLE_CLICK_ACCESSIBLE = $r('app.string.widgets_two_click_accessible');
}

/**
 * 锁屏壁纸模糊默认常量
 */
export class WallpaperEffectOptions {
  public static readonly DEFAULT_POLICY = 1;
  public static readonly DEFAULT_RADIUS = 45;
  public static readonly DEFAULT_SATURATION = 1.2;
  public static readonly DEFAULT_BRIGHTNESS = 1;
  public static readonly DEFAULT_BLUR_OPTIONS_GRAYSCALE = 38;
}

/**
 * 锁屏编辑拖拽卡片移动
 */
export const SCREEN_LOCK_EDIT_CARD_DRAG: string = 'SCREEN_LOCK_EDIT_CARD_DRAG';