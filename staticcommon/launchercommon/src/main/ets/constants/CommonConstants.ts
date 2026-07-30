/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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

import deviceInfo from '@ohos.deviceInfo';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBScreenSessionManager } from '@ohos/windowscene';

/**
 * Common constants for all features.
 */
export class CommonConstants {
  public static GRIDSWIPER_STACK_ID = 'GridSwiper_Stack_Swiper';

  /**
   * Dock Feature Layout Configuration Index
   */
  public static readonly SMART_DOCK_LAYOUT_INFO: string = 'SmartDockLayoutInfo';

  /**
   * 预置布局卡片无ID时，默认ID前缀
   */
  public static readonly CARD_DEFAULT_ID_PREFIX: string = 'cid';

  /**
   * Workspace Feature Layout Configuration Index
   */
  public static readonly DESKTOP_APPLICATION_INFO: string = 'DesktopApplicationInfo';

  /**
   * Workspace Feature Layout Configuration Index.
   */
  public static readonly GRID_LAYOUT_INFO: string = 'GridLayoutInfo';

  /**
   * dock space
   */
  public static DOCK_SPACE = 0.1;

  /**
   * default recent dock max num
   */
  public static readonly DEFAULT_RECENT_DOCK_MAX_NUM: number = 4;

  /**
   * 桌面图标默认放大系数
   */
  public static readonly ICON_DEFAULT_SCALE: number = 1.05;

  // 一天的毫秒数
  public static readonly ONE_DAY_MILL: number = 86400000;

  /**
   * 游戏应用的一级分类信息
   */
  public static readonly GAME_APP_PRIMARY_CATEGORY_ID: number = 2;

  /**
   * 来源为克隆
   */
  public static readonly SOURCE_CLONE: string = 'com.ohos.dataclone';

  /**
   * 来源为升级
   */
  public static readonly SOURCE_UPGRADE: string = 'migrate_server';

  /**
   * Bundle name of launcher
   */
  public static LAUNCHER_BUNDLE = 'com.ohos.sceneboard';

  /**
   * Bundle name of fileManager
   */
  public static readonly FILE_MANAGER_BUNDLE = 'com.ohos.filemanager';
  public static readonly PHONE_FILE_MANAGER_BUNDLE = 'com.ohos.files';

  public static readonly INTELLIGENT_BUNDLE: string = 'com.ohos.intelligent';

  /**
   * SystemUI应用包名
   */
  public static readonly SYSTEMUI_PKG: string = 'com.ohos.sceneboard';

  /**
   * 通知和状态栏Ability名
   */
  public static readonly NTF_MANAGEMENT_ABILITY: string = 'com.ohos.sceneboard.notificationmanagement.MainAbility';

  /**
   * 通知和状态栏Module名
   */
  public static readonly NTF_MANAGEMENT_MODULE: string = 'default_notificationmanagement';

  /**
   * Module name of AppCenter.
   */
  public static MODULE_NAME = 'pad-launcher';

  /**
   * app center extra id
   */
  public static readonly APPCENTER_ICON_EXTRA_ID = 'AppCenterItem';

  /**
   * Ability name of AppCenter.
   */
  public static readonly APPCENTER_ABILITY = 'com.ohos.sceneboard.appcenter.MainAbility';

  /**
   * Ability name of launcher settings.
   */
  public static SETTING_ABILITY = 'com.ohos.sceneboard.settings.MainAbility';
  /**
   * Ability name of launcher Recents.
   */
  public static readonly RECENT_ABILITY = 'com.ohos.sceneboard.recents.MainAbility';

  /**
   * Launcher Ability name.
   */
  public static LAUNCHER_ABILITY = 'com.ohos.sceneboard.MainAbility';

  /**
   *  Ability name of launcher Thememanager.
   */
  public static readonly THEME_MANAGER_ABILITY = 'com.ohos.thememanager.MainAbility';

  /**
   *  Ability name of launcher Settins.
   */
  public static readonly SETTINGS_ABILITY = 'com.ohos.settings.MainAbility';

  /**
   *  Ability name of launcher Clock.
   */
  public static readonly CLOCK_ABILITY = 'com.ohos.clock.phone';

  /**
   *  Ability name of launcher Photos.
   */
  public static readonly PHOTOS_ABILITY = 'com.ohos.photos.MainAbility';

  /**
   *  Ability name of launcher Notepad.
   */
  public static readonly NOTEPAD_ABILITY = 'com.ohos.notepad.MainAbility';

  /**
   *  Ability name of launcher Music.
   */
  public static readonly MUSIC_ABILITY = 'com.ohos.music.MainAbility';

  /**
   *  Ability name of launcher Browser.
   */
  public static readonly BROWSER_ABILITY = 'com.ohos.browser.MainAbility';

  /**
   *  Ability name of launcher Calendar.
   */
  public static readonly CALENDAR_ABILITY = 'com.ohos.calendar.MainAbility';

  /**
   *  Ability name of launcher Calculator.
   */
  public static readonly CALCULATOR_ABILITY = 'com.ohos.calculator.MainAbility';

  /**
   * Long press the vibration effect of the desktop element
   */
  public static readonly VIBRATION_EFFECT_LONG_PRESS = 'haptic.common.long_press3';

  /**
   * Long press the vibration attribute of the desktop element
   */
  public static readonly VIBRATION_ATTRIBUTE_LONG_PRESS = 'touch';

  /**
   * Long press the vibration effect of the desktop element
   */
  public static readonly VIBRATION_EFFECT_SLIDE = 'haptic.slide';

  /**
   *  the vibration effect of one step/float to full & delete/dock
   */
  public static readonly VIBRATION_EFFECT_DRAG = 'haptic.drag';

  /**
   * Long press the vibration effect of the desktop element
   */
  public static readonly VIBRATION_EFFECT_SLIDE_TYPE6 = 'haptic.slide.type6';

  /**
   * Long press the vibration effect of the AIbar
   */
  public static readonly VIBRATION_EFFECT_AIBAR = 'haptic.AIbar';

  /**
   * the vibration effect of the recent element
   */
  public static readonly VIBRATION_EFFECT_RECENT = 'haptic.upglide';

  /**
   * Long press the vibration effect of the dock element
   */
  public static readonly VIBRATION_EFFECT_LIGHT = 'haptic.long_press_light';

  /**
   * Long press the vibration effect of the dock element
   */
  public static readonly VIBRATION_EFFECT_MEDIUM = 'haptic.long_press_medium';

  /**
   * the vibration effect of the open Control Center Vibration Mode
   */
  public static readonly VIBRATION_EFFECT_NOTICE = 'haptic.notice.mode';

  public static readonly VIBRATION_EFFECT_UPGLIDE = 'haptic.upglide';

  /**
   * 搜索
   */
  public static HISEARCH_BUNDLE = 'com.ohos.hisearch';

  /**
   * Ability name of recycleBin.
   */
  public static readonly RECYCLE_BIN_ABILITY: string = 'com.ohos.sceneboard.recycleBin';

  /**
   * BundleName of upgrade guide
   */
  public static readonly HWUPGRADEDUIDE_BUNDLE: string = 'com.ohos.hwupgradeguide';

  /**
   * Ability name of upgrade guide
   */
  public static readonly HWUPGRADEDUIDE_ABILITY: string = 'GuideHomeAbility';

  /**
   * Bundle name of sceneboard
   */
  public static readonly SCENEBOARD_BUNDLE = 'com.ohos.sceneboard';

  /**
   * Ability name of sceneboard
   */
  public static readonly ONEKEY_LOCK_UIABILITY = 'OnekeylockUiAbility';

  /**
   * Bundle name of camera
   */
  public static readonly CAMERA_BUNDLE = 'com.ohos.camera';

  /**
   * Bundle name of thememanager
   */
  public static readonly THEME_MANAGER_BUNDLE = 'com.ohos.thememanager';

  /**
   * 一键锁屏快捷方式id
   */
  static readonly ONEKEY_LOCK_SHORTCUT_ID = 'oneKeyLockFormShortCut';

  /**
   * Bundle name of settings
   */
  public static readonly SETTINGS_BUNDLE = 'com.ohos.settings';

  /**
   * Bundle name of clock
   */
  public static readonly CLOCK_BUNDLE = 'com.ohos.clock';

  /**
   * Bundle name of photos
   */
  public static readonly PHOTOS_BUNDLE = 'com.ohos.photos';

  /**
   * Bundle name of notepad
   */
  public static readonly NOTEPAD_BUNDLE = 'com.ohos.notepad';

  /**
   * Bundle name of ai service
   */
  public static readonly AI_SERVICE_BUNDLE = 'com.ohos.vassistant';

  /**
   * Bundle name of music
   */
  public static readonly MUSIC_BUNDLE = 'com.ohos.music';

  /**
   * Bundle name of browser
   */
  public static readonly BROWSER_BUNDLE = 'com.ohos.browser';

  /**
   * Bundle name of hinotepad
   */
  public static readonly HINOTEPAD_BUNDLE = 'com.ohos.hinotepad';

  /**
   * Bundle name of hishell
   */
  public static readonly HISHELL = 'com.ohos.hishell';

  /**
   * Bundle name of htrlbrowser
   */
  public static readonly HTRL_BROWSER_BUNDLE = 'com.haitai.htrlbrowser';

  /**
   * Bundle name of htbrowser
   */
  public static readonly HT_BROWSER_BUNDLE = 'com.haitai.htbrowser';

  /**
   * Bundle name of calendar
   */
  public static readonly CALENDAR_BUNDLE = 'com.ohos.calendar';

  /**
   * Bundle name of calculator
   */
  public static readonly CALCULATOR_BUNDLE = 'com.ohos.calculator';

  /**
   * ability name of contact with no HasVoiceCapability in pad
   */
  public static readonly CONTACT_PAD_NO_VOICE_CAPABILITY: string = 'com.ohos.contacts.EntryAbility';

  /**
   * ability name of contact in phone
   */
  public static readonly CONTACT_HAS_VOICE_CAPABILITY: string = 'com.ohos.contacts.MainAbility';

  /**
   * 预置的应用文件夹id
   */
  public static readonly PRESET_OpenHarmony_FOLDER_ID: string = 'lkqkw4s76q0592qwa4g';

  /**
   * 数字2
   */
  public static readonly NUMBER_TWO = 2;

  /**
   * Default invalid value.
   */
  public static INVALID_VALUE = -1;

  /**
   * folder min app count
   */
  public static FOLDER_APP_VALUE = 1;

  /**
   * FolderComponent max show length
   */
  public static FOLDER_STATIC_SHOW_LENGTH = 11;

  /**
   * Status code if uninstal succeeded, success, successful.
   */
  public static UNINSTALL_SUCCESS = 0;

  /**
   * Status code if uninstall is forbidden.
   */
  public static UNINSTALL_FORBID = 1;

  /**
   * Grid item type for apps.
   */
  public static ITEM_TYPE_APP = '0';

  /**
   * Grid item type for apps.
   */
  public static TYPE_APP = 0;

  /**
   * Grid item type for cards.
   */
  public static TYPE_CARD = 1;

  /**
   * Grid item type for functions.
   */
  public static TYPE_FUNCTION = 2;

  /**
   * folder type in desktop
   */
  public static TYPE_FOLDER = 3;

  /**
   * add icon type in opening folder
   */
  public static TYPE_ADD = 4;

  /**
   * fileFolder type in desktop
   */
  public static readonly TYPE_FILE_FOLDER = 5;

  /**
   * formstack type in desktop
   */
  public static TYPE_FORM_STACK = 6;

  /**
   * shortcutIcon type in desktop
   */
  public static TYPE_SHORTCUT_ICON = 7;

  /**
   *  formCombine type in desktop
   */
  public static TYPE_FORM_COMBINE = 8;

  /**
   * region folder type in desktop (only used in pc)
   */
  public static TYPE_REGION_FOLDER = 9;

  /**
   * desk top area type
   */
  public static TYPE_AREA_DESKTOP = 0;

  /**
   * dock area type
   */
  public static TYPE_AREA_DOCK = 1;

  /**
   *  app center area type
   */
  public static TYPE_AREA_APP_CENTER = 2;

  /**
   * Card dimension constants for 1 row 2 columns.
   */
  public static CARD_DIMENSION_1x2 = 1;

  /**
   * Card dimension constants for 2 rows 2 columns.
   */
  public static CARD_DIMENSION_2x2 = 2;

  /**
   * Card dimension constants for 2 rows 4 columns.
   */
  public static CARD_DIMENSION_2x4 = 3;

  /**
   * Card dimension constants for 4 rows 4 columns.
   */
  public static CARD_DIMENSION_4x4 = 4;

  /**
   * Card dimension constants for 2 rows 3 columns.
   */
  public static CARD_DIMENSION_2x3 = 5;

  /**
   * Card dimension constants for 6 rows 4 columns.
   */
  public static CARD_DIMENSION_6x4 = 7;

  /**
   * Card dimension constants for 1 rows 1 columns.
   */
  public static CARD_DIMENSION_1x1 = 6;

  /**
   * card auto rending mode, both full color and single color are supported
   */
  public static readonly CARD_RENDERING_AUTO_COLOR: number = 0;

  /**
   * card only support full color rendering mode
   */
  public static readonly CARD_RENDERING_MODE_FULL_COLOR: number = 1;

  /**
   * card only support single color rendering mode
   */
  public static readonly CARD_RENDERING_MODE_SINGLE_COLOR: number = 2;

  /**
   * Common level layout config. Default config for common components.
   */
  public static LAYOUT_CONFIG_LEVEL_COMMON = 'common';

  /**
   * Feature level layout config. Default config for components in this feature.
   */
  public static LAYOUT_CONFIG_LEVEL_FEATURE = 'feature';

  /**
   * Product level layout config. Custom config for this product.
   */
  public static LAYOUT_CONFIG_LEVEL_PRODUCT = 'product';

  /**
   * Layout config type for layout mode.
   */
  public static LAYOUT_CONFIG_TYPE_MODE = 0;

  /**
   * Layout config type for layout style.
   */
  public static LAYOUT_CONFIG_TYPE_STYLE = 1;

  /**
   * Layout config type for layout function.
   */
  public static LAYOUT_CONFIG_TYPE_FUNCTION = 2;

  /**
   * Default device type constant.
   */
  public static DEFAULT_DEVICE_TYPE = 'phone';

  /**
   * Device type constant for tablet.
   */
  public static PAD_DEVICE_TYPE = 'pad';

  /**
   * Device type constant for pc
   */
  public static PC_DEVICE_TYPE = 'PC';

  /**
   * default id
   */
  public static DEFAULT_ID = '-1';

  /**
   * Overlay blur radius.
   */
  public static readonly OVERLAY_BLUR_RADIUS = 40;

  /**
   * Overlay type for hidden items.
   */
  public static OVERLAY_TYPE_HIDE = -1;

  /**
   * Overlay type for app menus.
   */
  public static OVERLAY_TYPE_APP_MENU = 0;

  /**
   * Overlay type for app icons.
   */
  public static OVERLAY_TYPE_APP_ICON = 1;

  /**
   * Overlay type for folders.
   */
  public static OVERLAY_TYPE_FOLDER = 2;

  /**
   * Overlay type for forms
   */
  public static OVERLAY_TYPE_CARD = 3;

  /**
   * Overlay type for residential.
   */
  public static OVERLAY_TYPE_APP_RESIDENTIAL = 4;

  /**
   * Overlay type for recentdock.
   */
  public static OVERLAY_TYPE_APP_RECENT = 5;
  /**
   * Overlay type for recent image
   */
  public static OVERLAY_TYPE_RECENT_IMAGE = 5;
  /**
   * Menu type for fixed items.
   */
  public static MENU_TYPE_FIXED = 0;

  /**
   * Menu type for dynamic items.
   */
  public static MENU_TYPE_DYNAMIC = 1;

  /**
   * Menu type for dynamic items.
   */
  static MENU_TYPE_TASK = 2;

  /**
   * Light mode menus.
   */
  public static MENU_UI_MODE_LIGHT = 0;

  /**
   * Dark mode menus.
   */
  public static MENU_UI_MODE_DARK = 1;

  /**
   * Drag item type for apps.
   */
  public static APP_TYPE_DRAG_ITEM = 0;

  /**
   * Touch event type for down events.
   */
  public static TOUCH_TYPE_DOWN = 0;

  /**
   * Touch event type for move events.
   */
  public static TOUCH_TYPE_MOVE = 2;

  /**
   * Touch event type for up events.
   */
  public static TOUCH_TYPE_UP = 1;

  /**
   * folder name max length
   */
  public static FOLDER_NAME_MAX_LENGTH = 100;

  /**
   * distance for two app,on transition animation
   */
  public static readonly DISTANCE_APP_TRANSITION = 30;

  /**
   * hide badge
   */
  public static BADGE_DISPLAY_HIDE = -1;

  /**
   * show badge
   */
  public static BADGE_DISPLAY_SHOW = 1;

  /**
   * badge fixed type push
   */
  public static BADGE_FIXED_TYPE_PUSH = 1;

  /**
   * badge fixed type NMS
   */
  public static BADGE_FIXED_TYPE_NMS = 2;

  /**
   * default user id
   */
  public static DEFAULT_USER_ID = 0;

  /**
   * main app index
   */
  public static MAIN_APP_INDEX = 0;

  /**
   * form config ability prefix
   */
  public static FORM_CONFIG_ABILITY_PREFIX: string = 'ability://';

  /**
   * navigationbar status settingDataKey.
   */
  public static NAVIGATION_BAR_STATUS_KEY: string = 'settings.display.navigationbar_status';

  /**
   * navigationbar status open
   */
  public static NAVIGATION_BAR_OPEN = '0';

  /**
   * navigationbar status close
   */
  public static NAVIGATION_BAR_CLOSE = '1';

  /**
   * setting data ability uri
   */
  public static SETTING_DATA_ABILITY_URI: string = 'dataability:///com.ohos.settingsdata.DataAbility';

  /**
   * string refresh, use in right menu item key
   */
  public static REFRESH_FOR_KEY: string = 'refresh';

  /**
   * string opacity, use in right menu item key
   */
  public static OPACITY_FOR_KEY: string = 'opacity';

  /**
   * string blur, use in right menu item key
   */
  public static BLUR_FOR_KEY: string = 'blur';

  /**
   * string unknown, use in right menu item key
   */
  public static UNKNOWN_FOR_KEY: string = 'unknown';

  /**
   * string id, use to contracted folder in muti drag
   */
  public static CONTRACTED_FOLDER_MULTI_DRAG: string = 'ContractedFolderMultiDrag';

  /**
   * file box sort type, use in default type
   */
  public static SORT_TYPE = 5;

  /**
   * file box view type, use in grid view
   */
  public static VIEW_TYPE = 0;

  /**
   * event type, use in unknown source type
   */
  public static EVENT_TYPE = 0;

  /**
   * desktop right menu item selected status
   */
  public static DESKTOP_MENU_STATE_OPEN = 1;

  /**
   * desktop right menu item unselected status
   */
  public static DESKTOP_MENU_STATE_CLOSE = 2;

  /**
   * default drag from type
   */
  public static DRAG_FROM_UNKNOWN = -1;

  public static DRAG_FROM_DOCK = 1;

  /**
   * Drag events from the workspace.
   */
  public static DRAG_FROM_DESKTOP = 2;

  /**
   * Drag events from the folder.
   */
  public static DRAG_FROM_FOLDER = 3;

  /**
   * Drag events from the formManage.
   */
  public static readonly DRAG_FROM_MANAGE = 4;

  /**
   * Drag events from the SwipeUpForm
   */
  public static readonly DRAG_FROM_SWIPE_UP = 5;

  /**
   * Drag events from the formService .
   */
  public static readonly DRAG_FROM_FORM_SERVICE = 6;

  /**
   * Drag events from Intelligent
   */
  public static readonly DRAG_FROM_FORM_INTELLIGENT = 7;

  /**
   * Drag events from folder in dock
   */
  public static readonly DRAG_FROM_FOLDER_IN_DOCK = 8;

  /**
   * Drag events from FormStack
   */
  public static readonly DRAG_FROM_FORM_STACK: number = 9;

  /**
   * Drag events from shortcut
   */
  public static readonly DRAG_FROM_SHORTCUT: number = 10;

  /**
   * Drag events from appcenter
   */
  public static readonly DRAG_FROM_APPCENTER: number = 11;

  /**
   * Drag events from app
   */
  public static readonly DRAG_FROM_APP: number = 12;
  /**
   * Drag events from region folder
   */
  public static readonly DRAG_FROM_REGION_FOLDER = 13;
  /**
   * Drag events from app icon
   */
  public static readonly DRAG_FROM_APP_ICON = 14;
  /**
   * Grid span is 1, for row or column
   */
  public static readonly GRID_SPAN_1 = 1;

  /**
   * Grid span is 2, for row or column
   */
  public static readonly GRID_SPAN_2 = 2;

  /**
   * Grid span is 3, for row or column
   */
  public static readonly GRID_SPAN_3 = 3;

  /**
   * Grid span is 4, for row or column
   */
  public static readonly GRID_SPAN_4 = 4;

  /**
   * Grid span is 6, for row or column
   */
  public static readonly GRID_SPAN_6 = 6;

  /**
   * App number when span is 1, whether row or column
   */
  public static readonly BIG_FOLDER_APP_NUM_SPAN_1 = 1;

  /**
   * App number when span is 2, whether row or column
   */
  public static readonly BIG_FOLDER_APP_NUM_SPAN_2 = 3;

  /**
   * App number when span is 4, for row only
   */
  public static readonly BIG_FOLDER_APP_NUM_SPAN_4 = 6;

  /**
   * Module name of launcher settings.
   */
  public static readonly SETTING_MODULE = 'launcher_settings';

  /**
   * SwiperPage AppItem for ID.
   */
  public static readonly SWIPER_APP_TAG = 'SwiperPage_AppItem_';

  /**
   * SwiperPage FolderItem for ID.
   */
  public static readonly SWIPER_FOLDER_TAG = 'SwiperPage_FolderItem_';

  /**
   * SwiperPage SmallFolderItem for ID.
   */
  public static readonly SWIPER_SMALL_FOLDER_TAG = 'SwiperPage_SmallFolderItem_';

  /**
   * SwiperPage FormItem for ID.
   */
  public static readonly SWIPER_FORM_TAG = 'SwiperPage_FormItem_';

  /**
   * SwiperPage FormStackItem for ID.
   */
  public static readonly SWIPER_FORM_STACK_TAG = 'SwiperPage_FormStackItem_';

  /**
   * SwiperPage GridItem for ID.
   */
  public static readonly SWIPER_GRID_TAG = 'SwiperPage_GridItem_';

  /**
   * SwiperPage Grid WorkSpace for ID.
   */
  public static readonly SWIPER_GRID_WORKSPACE_TAG = 'SwiperPage_Grid_WorkSpace_';

  /**
   * ResidentLayout AppItem for ID.
   */
  public static readonly RESIDENT_LAYOUT_APP_TAG = 'ResidentLayout_AppItem_';

  /**
   * AppItem AppBubble for ID.
   */
  public static readonly APP_ITEM_APP_BUBBLE_TAG = 'AppItem_AppBubble_';

  /**
   * AppIcon AppBubble Image for ID.
   */
  public static readonly APP_ITEM_APP_BUBBLE_ICON_TAG = 'AppIcon_Image_';

  public static readonly Folder_BUBBLE_APP_ICON_TAG = 'FolderAppBubble_FolderIcon_';

  /**
   * SmallFolderComponent Grid for ID
   */
  public static readonly SMALL_FOLDER_GRID_TAG = 'SmallFolderComponent_grid_';

  /**
   * FolderComponent Grid组件 for ID
   */
  public static readonly FOLDER_GRID_TAG = 'FolderComponent_grid_';

  /**
   * FolderComponent Group组件 for ID
   */
  public static readonly FOLDER_GROUP_TAG = 'FolderComponent_group_';

  /**
   * 文件夹无障碍焦点id
   */
  static readonly FOLDER_ACCESSIBILITY_TAG = 'Folder_accessibility_';

  /**
   * 文件夹图标ID
   */
  public static readonly FOLDER_APP_TAG = 'FolderComponent_AppIcon_';

  /**
   * SceneBoard卡片映射关系
   */
  public static readonly SCENE_BOARD_FORM_RELATION_INFO = 'scene_board_form_relation_info.json';

  /**
   * Default WindowRadius 0.
   */
  public static readonly DEFAULT_WINDOWS_RADIUS_0 = 0;

  /**
   * Default WindowRadius 38.
   */
  public static readonly DEFAULT_WINDOWS_RADIUS = 38;

  /**
   * Default IconSize.
   */
  public static readonly DEFAULT_ICON_SIZE = deviceInfo.deviceType === '2in1' ? 56 : 54;

  /**
   * Default IconRadius（圆形：边长一半）.
   */
  public static readonly DEFAULT_ICON_RADIUS = deviceInfo.deviceType === '2in1' ? 28 : 27;

  /**
   * Default Phone FormCenter IconRadius.
   */
  public static readonly DEFAULT_PHONE_FORM_CENTER_ICON_RADIUS = 14.2;

  /**
   * Default PC FormCenter IconRadius.
   */
  public static readonly DEFAULT_PC_FORM_CENTER_ICON_RADIUS = 12;

  /**
   * Default clip false
   */
  public static readonly DEFAULT_CLIP_FALSE = false;

  /**
   * Page index of waterfall page
   */
  public static readonly WATERFALL_PAGE_INDEX = -100;

  /**
   * Page index of waterfall page
   */
  public static readonly WATERFALL_PAGE_COUNT = 5;

  /**
   * whether to show waterfall page
   */
  public static readonly IS_WATERFALL_PAGE_SHOW = false;

  /**
   * scale factor when long pressing to display menu
   */
  public static readonly SCALE_FACTOR_WHEN_MENU_SHOW = 0.97;

  /**
   * desktop container
   */
  public static readonly CONTAINER_DESKTOP = -100;

  /**
   * smartdock container
   */
  public static readonly CONTAINER_SMARTDOCK = -101;

  /**
   * smartdock recent container
   */
  public static readonly CONTAINER_RECENT = -102;

  /**
   * area length
   */
  public static readonly AREA_LENGTH = 2;

  /**
   * card size small length
   */
  public static readonly CARD_SIZE_SMALL_LENGTH = 1;

  /**
   * card size middle length
   */
  public static readonly CARD_SIZE_MIDDLE_LENGTH = 2;

  /**
   * card size large length
   */
  public static readonly CARD_SIZE_LARGE_LENGTH = 4;

  // 卡片编辑页类型
  public static readonly FORM_EDIT_UI_EXTENSION_TYPE = 'formEdit';

  /**
   * toast 时间
   */
  public static readonly TOAST: IToast = {
    LENGTH_LONG: 3500,
    LENGTH_SHORT: 2000,
    NORMAL: 1000
  };

  /**
   * pc toast 显示默认高度
   */
  public static readonly TOAST_SHOW_DEFAULT_HEIGHT = 80;

  /**
   * OPACITY ZERO
   */
  public static readonly OPACITY_ZERO = 0;

  /**
   * OPACITY ONE
   */
  public static readonly OPACITY_ONE = 1;


  /**
   * type of start app from launcher
   */
  public static readonly TYPE_START_APP_FROM_LAUNCHER = 1;

  /**
   *  type for start app from dock
   */
  public static readonly TYPE_START_APP_FROM_DOCK = 2;

  /**
   *  type for start app from folder
   */
  public static readonly TYPE_START_APP_FROM_FOLDER = 3;

  /**
   *  type for start app from recent
   */
  public static readonly TYPE_START_APP_FROM_RECENT = 4;

  /**
   *  type for start app from app center
   */
  public static readonly TYPE_START_APP_FROM_APPCENTER = 5;

  public static readonly FORM_MANAGER_SHOW_FROM_FORM_SERVICE_GRID_FORM = 1;

  public static readonly FORM_MANAGER_SHOW_FROM_FORM_SERVICE_FORM_APP = 2;

  /**
   * 设置卡片隐藏时对应的透明度
   */
  public static readonly FORM_HIDDEN_OPACITY = 0.005;

  /**
   *  type for start app from other
   */
  public static readonly TYPE_START_APP_FROM_OTHER = 6;

  /**
   * 正常启动退出过渡时长
   */
  static readonly START_AND_EXIT_NORMAL_DURATION: number = 800;

  /**
   * 负一屏启动退出过渡时长
   */
  static readonly START_AND_EXIT_INTELLIGENT_DURATION: number = 200;

  /**
   * mid启动退出过渡时长
   */
  static readonly START_AND_EXIT_MID_SCENE_DURATION: number = 300;

  /**
   *  type for folder
   */
  public static readonly FOLDER = 'folder';

  /**
   *  type for sources
   */
  public static readonly OPEN_SOURCES = 'isOpenFromDock';

  /**
   *  type for image
   */
  public static readonly IMAGE = 'image';

  /**
   *  type for video
   */
  public static readonly VIDEO = 'video';

  /**
   *  type for audio
   */
  public static readonly AUDIO = 'audio';

  /**
   *  type for file
   */
  public static readonly FILE = 'file';

  public static readonly APP_GRID_STYLE_CONFIG = 'AppGridStyleConfig';

  public static readonly PAGE_DESKTOP_FEATURE_NAME = 'pageDesktop';

  public static readonly INVALID_SHADOW_CACHE_KEY = 'Invalid';

  public static readonly DEFAULT_SUPPORT_INDICATOR = false;

  /**
   *  default clone icon uri
   */
  public static readonly DEFAULT_CLONE_ICON_URI = '/RestoreIconData/default_icon.png';

  public static readonly DEFAULT_CLONE_SHORTCUT_ICON_URI = '/RestoreIconData/default_shortcut_icon.png';

  /**
   * shortcut supported clone
   */
  public static readonly SHORTCUT_CLONE: string = 'shortcutCloneFlag';

  /**
   * shortcut supported clone flag
   */
  public static readonly SHORTCUT_CLONE_FLAG: boolean = true;

  /**
   *  Restore Launcher Data
   */
  public static readonly RESTORE_LAUNCHER_DATA = 'RestoreLauncherData';

  /**
   * folder static status
   */
  public static readonly OPEN_FOLDER_STATUS_STATIC = -1;

  /**
   * folder close status
   */
  public static readonly OPEN_FOLDER_STATUS_CLOSE = 0;

  /**
   * folder open status
   */
  public static readonly OPEN_FOLDER_STATUS_OPEN = 1;

  /**
   * folder refresh status
   */
  public static readonly OPEN_FOLDER_STATUS_REFRESH = 2;

  /**
   * folder opening or closing animation start
   */
  public static readonly OPEN_FOLDER_STATUS_TRANSITION_START = 3;

  /**
   * folder opening or closing animation end
   */
  public static readonly OPEN_FOLDER_STATUS_TRANSITION_END = 4;

  /**
   * rename status
   */
  public static readonly RENAME_STATUS = 1;

  /**
   * 桌面缩放系数
   */
  public static readonly DESKTOP_ANIMATE_SCALE: number = 0.88;

  /**
   * default rename status
   */
  public static readonly DEFAULT_RENAME_STATUS = -1;

  /**
   * folder pending close
   */
  public static readonly FOLDER_STATUS_PENDING_CLOSE = 5;

  /**
   * folder request close
   */
  public static readonly FOLDER_STATUS_REQUEST_CLOSE = 6;

  /**
   * 无效的文件夹id
   */
  public static readonly INVALID_FOLDER_ID = '-1';

  /**
   * custom dialog grid count
   */
  public static readonly CUSTOM_DIALOG_GRID_COUNT = 4;

  public static readonly CREATE_SMALL_FOLDER_STATUS = 1;

  public static readonly DEFAULT_CREATE_SMALL_FOLDER_STATUS = -1;

  /**
   * init convert
   */
  public static readonly START_CONVERT_ANIMATE = 0;

  /**
   * start convert
   */
  public static readonly DEFAULT_CONVERT = -1;

  /**
   * end convert
   */
  public static readonly END_CONVERT_ANIMATE = 1;


  /**
   * DEFAULT COL
   */
  public static readonly DEFAULT_COL = 4;

  public static readonly DEFAULT_COL_PC = 15;

  /**
   * DEFAULT ROW
   */
  public static readonly DEFAULT_ROW = 6;

  public static readonly DEFAULT_ROW_PC = 9;

  /**
   * OUTER DEFAULT COL
   */
  public static readonly OUTER_DEFAULT_COL = 4;

  /**
   * OUTER DEFAULT ROW
   */
  public static readonly OUTER_DEFAULT_ROW = 4;

  /**
   * form require params
   */
  public static readonly OHOS_EXTRA_PARAM_KEY_MIGRATE_FORM = 'ohos.extra.param.key.migrate_form';

  /**
   * container dock
   */
  public static readonly CONTAINER_DOCK = -101;

  /**
   * used to save Unique application of a single framework
   */
  public static readonly CONTAINER_UNIQUE_SINGLE = -102;

  /**
   * create form location parameter key
   */
  public static readonly FORM_LOCATION_KEY = 'ohos.extra.param.key.form_location';

  /**
   * form background transparency
   */
  public static readonly FORM_BACKGROUND_TRANSPARENCY = 'ohos.extra.param.key.form_background_transparency';

  /**
   * form disable blur background
   */
  public static readonly FORM_DISABLE_BLUR_BACKGROUND = 'ohos.extra.param.key.form_disable_blur_background';

  /**
   * form disable gesture
   */
  public static readonly FORM_DISABLE_GESTURE_KEY = 'ohos.extra.param.key.form_disable_gesture';

  public static readonly FORM_ENABLE_SKELETON_KEY = 'ohos.extra.param.key.enable_skeleton';

  public static readonly FORM_TARGET_FORM_DATA = 'ohos.extra.param.key.target_form_data';

  public static readonly EDIT_FORM_ID = 'ohos.extra.param.key.edit_form_id';

  /**
   * in outer screen
   */
  public static readonly IS_OUTER_DESKTOP = 'isOuter';

  /**
   * weather form clock style
   */
  public static readonly FORM_CLOCK_STYLE_KEY = 'STYLE_PARAMETERS';

  /**
   * db home screen index
   */
  public static readonly DB_HOME_SCREEN_INDEX = 'DB_HOME_SCREEN_INDEX';

  /**
   * db easy mode home screen index
   */
  public static readonly DB_EASY_HOME_SCREEN_INDEX = 'DB_EASY_HOME_SCREEN_INDEX';

  /**
   * weather form clock style
   */
  public static readonly FORM_CLOCK_STYLE_FLAG_KEY = 'ONE_MIRROR_CHANGE';

  /**
   * transparent form background color
   */
  public static readonly TRANSPARENT_FORM_BG_COLOR = '#19FFFFFF';

  /**
   * transparent form panel background color
   */
  public static readonly TRANSPARENT_FORM_BG_PANEL_COLOR = '#4D000000';

  /**
   * desktop edit: the time of long press item with menu to enter edit mode
   */
  public static readonly LONG_PRESS_ITEM_WITH_MENU_DURATION = 2050;

  /**
   * desktop edit: the time of long press app bubble without menu to enter edit mode
   */
  public static readonly LONG_PRESS_ITEM_WITHOUT_MENU_DURATION = 1600;

  /**
   * ArkUI Long press time for floating effect
   */
  public static readonly LONG_PRESS_TIME_FOR_FLOATING_EFFECT = 800;

  /**
   * 桌面元素长按截图的时间，该截图用于拖拽或者落位场景，从touch截图改为长按截图是为了提升点击场景的性能
   */
  public static readonly LONG_PRESS_TIME_FOR_SNAPSHOT = 350;

  /**
   * 大文件夹按压图标后,取消蒙层的时间,避免长按和拖拽带上蒙层
   */
  public static readonly LONG_PRESS_TIME_FOR_BIG_FOLDER_CANCEL = 100;

  /**
   * ArkUI restore time for floating effect
   */
  public static readonly RESTORE_TIME_FOR_FLOATING_EFFECT = 420;

  /**
   * desktop recover show from other scene
   */
  public static readonly DESKTOP_RECOVER_STATE = 'desktopRecoverState';

  /**
   * desktop change to invisible state
   */
  public static readonly DESKTOP_INVISIBLE_STATE = 'desktopInvisibleState';

  /**
   * desktop change to invisible state
   */
  public static readonly NEGATIVE_SCREEN_SHOW_EVENT = 'negativeScreenShowEvent';

  /**
   * negative screen hidden event
   */
  public static readonly NEGATIVE_SCREEN_HIDDEN_EVENT = 'negativeScreenHiddenEvent';

  /**
   * text shadow change
   */
  public static readonly TEXT_SHADOW_CHANGE = 'textShadowChange';

  /**
   * gridSwiper Drag delegate
   */
  public static readonly GRID_SWIPER_DELEGATE_TO_MOVE = 'gridSwiperDelegateToMove';

   /**
   * gridSwiper Drop delegate
   */
  public static readonly GRID_SWIPER_DELEGATE_TO_DROP = 'gridSwiperDelegateToDrop';

   /**
   *  编辑模式长按展示or隐藏删除按钮
   */
  public static readonly LONG_PRESS_TO_SHOW_OR_HIDE_DELETE_ICON = 'longPressToShowOrHideDeleteIcon';

  /**
   *  编辑模式展示卸载对话框
   */
  public static readonly SHOW_BATCH_UNINSTALL_DIALOG = 'SHOW_BATCH_UNINSTALL_DIALOG';

  /**
   *  编辑模式移除事件头
   */
  public static readonly EDIT_MODE_ITEM_REMOVE_EVENT = 'editModeItemRemoveEvent';

  /**
   *  编辑模式卸载事件头
   */
  static readonly EDIT_MODE_ITEM_UNINSTALL_EVENT = 'editModeItemUninstallEvent';

  /**
   * desktop focus change
   */
  public static readonly DESKTOP_FOCUS_CHANGE = 'desktopFocusChange';

  /**
   * desktop select status change
   */
  public static readonly DESKTOP_SELECT_STATUS_CHANGE = 'selectStatusChange';

  /**
   * 打断添加卡片落位动效
   */
  public static readonly CANCEL_ADD_FORM_ANIMATION = 'cancelAddFormAnimation';

  /**
   * SCBFormCenter的去聚焦事件
   */
  public static readonly UNFOCUS_SCB_FORM_CENTER = 'unfocusSCBFormCenter';

  /**
   * desktop GridConfig init finish,cache refresh
   */
  public static readonly DESKTOP_PAGING_REFRESH = 'desktopPagingFiltering';

  /**
   * 桌面图标、文件夹、卡片、语音助手建议大小调整范围
   */
  public static readonly DESKTOP_ICON_CHANGE_SIZE_MIN = -6;
  public static readonly DESKTOP_ICON_CHANGE_SIZE_MAX = 8;

  public static getDeviceRadius(): number {
    return DeviceHelper.getDeviceRadius(SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus());
  }

  /**
   * temperate key IS_IN_FOLDER for GridItemInfo
   */
  public static readonly IS_IN_FOLDER = 'IS_IN_FOLDER';

  /**
   * temperate key IS_LOCKED_APP for GridItemInfo
   */
  public static readonly IS_LOCKED_APP = 'IS_LOCKED_APP';

  /**
   * eventhub prefix of app launch state
   */
  public static readonly EVENTHUB_APP_LAUNCH_STATE = 'appLaunchState';

  /**
   * eventhub of big folder open status
   */
  public static readonly EVENTHUB_BIG_FOLDER_OPEN_STATUS = 'bigFolderOpenStatus';

  /**
   * res id when max number of items in folder reached
   */
  public static readonly RES_FOLDER_ITEMS_FULL = 'app.string.folder_items_limit_toast';

  /**
   * res id when max number of items in desktop add
   */
  public static readonly RES_DESKTOP_ADD_ITEMS_FULL = 'app.string.desktop_add_items_limit_toast';

  /**
   * eventhub of status bar hide animation finish
   */
  public static readonly EVENTHUB_STATUS_BAR_HIDE_ANIMATION_FINISH = 'statusBarHideAnimationFinish';

  /**
   * eventhub of small folder badge rebound
   */
  public static readonly EVENTHUB_SMALL_FOLDER_BADGE_REBOUND = 'smallFolderBadgeRebound';

  /**
   * eventhub of folder switch anim status
   */
  public static readonly EVENTHUB_FOLDER_SWITCH_ANIM_STATUS = 'folderSwitchAnimStatus';

  /**
   * eventhub of animate back to icon
   */
  public static readonly EVENTHUB_ANIMATE_BACK_TO_ICON = 'animateBackToIcon';

  /**
   * eventhub of app icon long press
   */
  public static readonly EVENTHUB_APP_ICON_LONG_PRESS = 'appIconLongPress';

  /**
   * eventhub of drag icon from small folder in advance
   */
  public static readonly EVENTHUB_DRAG_LEAVE_FROM_SMALL_FOLDER_ADVANCE = 'dragLeaveFromSmallFolderAdvance';

  /**
   * 翻页找位更新startType事件
   */
  public static readonly EVENTHUB_UPDATE_START_APP_TYPE = 'updateStartAppType';

  /**
   * Folder mission timeout
   */
  public static readonly FOLDER_MISSION_TIMEOUT = 300;

  /**
   * small folder exit app animation duration
   */
  public static readonly FOLDER_EXIT_APP_DURATION = 400;

  /**
   * eventhub of form menu disappear
   */
  public static readonly EVENTHUB_APP_MENU_DISAPPEAR = 'onAppMenuDisappear';

  /**
   * eventhub of form menu disappear
   */
  public static readonly EVENTHUB_FORM_MENU_DISAPPEAR = 'onFormMenuDisappear';

  /**
   * eventhub of outer form menu disappear
   */
  public static readonly EVENTHUB_OUTER_CARD_MENU_DISAPPEAR = 'onOuterCardMenuDisappear';

  /**
   * eventhub of folder menu disappear
   */
  public static readonly EVENTHUB_FOLDER_MENU_DISAPPEAR = 'onFolderMenuDisappear';

  /**
   * eventhub of hide a folder menu
   */
  public static readonly EVENTHUB_FOLDER_HIDE_MENU = 'folderHideMenu';

  /**
   * eventhub of desk App of enter recentView displaying badgeNumber
   */
  public static readonly EVENTHUB_SHOW_BADGE = 'enterRecentAppShowBadge';

  /**
   * eventhub of form manager exit animate
   */
  public static readonly EVENTHUB_FORM_MANAGER_EXIT = 'onFormManagerExit';

  /**
   * eventhub of form edit exit animate
   */
  public static readonly EVENTHUB_FORM_EDIT_EXIT = 'onFormEditExit';

  /**
   * eventhub of folder name show
   */
  public static readonly EVENTHUB_SHOW_NAME = 'folderLongPressShow';

  /**
   * eventhub of folder name hide
   */
  public static readonly EVENTHUB_HIDE_NAME = 'folderLongPressHide';

  /**
   * eventhub of shortcut Menu disappear
   */
  public static readonly EVENTHUB_MENU_DISAPPEAR = 'menuDisappear';

  /**
   * eventhub of theme edit
   */
  public static readonly EVENTHUB_THEME_EDIT = 'theme_edit';

  /**
   * eventhub of mark desktop freeze
   */
  public static readonly EVENTHUB_MARK_DESKTOP_FREEZE = 'mark_desktop_freeze';

  /**
   * eventhub of icon or card drop in desktop
   */
  public static readonly EVENTHUB_ICON_OR_CARD_DROP = 'icon_or_card_drop';

  /**
   * 简易模式切换开发
   */
  public static readonly SIMPLE_MODE_KEY: string = 'simple_ui_mode_switch';

  /**
   * 云端2切换开发
   */
  public static readonly LIGHT_OUTDOOR_MODE_KEY: string = 'outdoor_mode_switch';

  /**
   * 简易模式桌面页数
   */
  public static readonly SIMPLE_DESKTOP_PAGE_COUNT: string = 'simple_page_count';

  /**
   * 普通桌面页数
   */
  public static readonly DESKTOP_PAGE_COUNT: string = 'page_count';

  /**
   * 户外模式模式页数
   */
  public static readonly OUTDOOR_PAGE_COUNT: string = 'outdoor_page_cout';

  /**
   * 云端2 页数
   */
  public static readonly LIGHT_OUTDOOR_PAGE_COUNT: string = 'outdoor_page_cout';

  /**
   * dock栏元素复位事件
   */
  public static readonly DOCK_ITEM_SQUEEZE_CANCEL = 'dock_item_squeeze_cancel';

  /**
   * dock减少图标事件
   */
  public static readonly DOCK_ICON_REDUCTION: string = 'dock_icon_reduction';

  /**
   * dock常驻区
   */
  public static readonly DOCK_RESIDENT: string = 'dock_resident';

  public static readonly MAX_DOWNLOAD_VALUE = 500;

  public static readonly DOCK_THRESHOLD_ONE = 20;

  public static readonly DOCK_THRESHOLD_TWO = 40;

  public static readonly DOCK_THRESHOLD_THREE = 80;

  public static readonly DOCK_OPACITY_RATIO = 150;

  public static readonly OPEN_FOLDER_ANIMATE_SCALE = 0.9;

  public static readonly GESTURE_VELOCITY_THRESHOLD = 450;

  /**
   * container app kind
   */
  public static readonly CONTAINER_APP_KIND_ID = -999;

  /**
   * 系统迁移应用旧图标占位缩放
   */
  public static readonly MIGRATE_PLACEHOLDER_ICON_SCALE = 1.12;

  /**
   * 启用的操作反馈效果标志，二进制按位与运算，从左至右标志位分别为：消息角标（1000，即8）、长按效果（0100，即4）、点击显隐效果（0010，即2）、缩放效果（0001，即1）
   * 应用图标默认支持的反馈效果15（1111），即默认支持所有效果
   */
  public static readonly DEFAULT_ENABLE_EFFECT_FLAG = 15;

  /**
   * 启用的操作标志，二进制按位与运算，从左至右标志位分别为：文件夹背板（10000，即16）、菜单（01000，即8）、编辑（00100，即4）、拖拽（00010，即2）、点击（00001，即1）
   * 应用图标默认支持的反馈效果31（111111），即默认支持所有操作
   */
  public static readonly DEFAULT_ENABLE_FOLDER_ACTION_FLAG = 31;

  public static readonly INSTALLING_ANIMATE_MAX_COUNT = 240;

  /**
   * click gesture
   */
  public static readonly GESTURE_SINGLE_CLICK = 1;

  public static readonly GESTURE_DOUBLE_CLICK = 2;

  /*
   * 每页文件夹个数
   */
  public static readonly NUM_OPEN_FOLDER_ICON_PRE_PAGE = 12;

  public static readonly APP_CENTER_REQUEST_FOCUS_KEY: string = 'app_center_request_focus';

  /*
   * 文件夹名字颜色
   */
  public static readonly FOLDER_APP_NAME_COLOR = $r('sys.color.ohos_id_color_text_primary');

  /*
   * 小文件夹Tag
   */
  public static readonly SMALL_FOLDER_IMAGE_TAG = 'SmallFolderImage';

  /*
   * 文件夹添加页Tag
   */
  public static readonly FOLDER_ADD_IMAGE_TAG = 'FolderAddImage';

  /**
   * folder open state, app name opacity animate
   */
  public static readonly DRAG_FOLDER_OPEN_APP_NAME_ANIMATE = 'drag_folder_open_app_name_animate';

  // 通栏hover动效参数
  public static readonly FIXED_SHADOW_SCALE: number = 1.02;
  public static readonly FIXED_FOREGROUND_BASE_TRANSLATE: number = 4;
  public static readonly FIXED_SHADOW_BASE_TRANSLATE: number = 4;
  public static readonly FIXED_HOVER_MASTER_SCALE: number = 1.15;
  public static readonly FIXED_HOVER_COMPANION_SCALE: number = 1.05;
  public static readonly FIXED_HOVER_RESET: number = 1;
  public static readonly BACKGROUND_ROTATE_ANGLE_X: number = -5;
  public static readonly BACKGROUND_ROTATE_ANGLE_Y: number = 5;
  public static readonly FOREGROUND_BASE_TRANSLATE: number = 8;
  public static readonly SHADOW_BASE_TRANSLATE: number = 7;
  public static readonly FOREGROUND_ROTATE_ANGLE_MULTIPLE: number = 3;
  public static readonly SHADOW_OPACITY: number = 0.2;
  public static readonly PC_SHADOW_OPACITY: number = 0.15;

  /*
 * 控制中心跳转设置时隐藏桌面，提升性能
 */
  public static readonly HIDE_DESKTOP_EVENT = 'isHideDesktop';

  /*
 * 一帧的时长
 */
  public static readonly ONE_FRAME_RATE = 16;

  /**
   * 已存在快捷方式的keyName的前缀
   */
  public static readonly EXIST_SHORTCUT_PREFIX = 'exist_shortcut_';

  public static readonly SIMPLE_MODEL_CARD_SIZE: number[] = [3, 2];

  /*
 * 待分屏避让
 * */
  public static readonly SPLIT_LEFT_PADDING: number = 4;
  public static readonly SPLIT_EXPAND_DISTANCE: number = 44;
  public static readonly SPLIT_FOLDED_DISTANCE: number = 0;
  //待分屏避让方向 上 下 左 右 无
  public static readonly SPLIT_TOP_DIRECTION: number = 0;
  public static readonly SPLIT_BOTTOM_DIRECTION: number = 1;
  public static readonly SPLIT_LEFT_DIRECTION: number = 2;
  public static readonly SPLIT_RIGHT_DIRECTION: number = 3;
  public static readonly SPLIT_NONE_DIRECTION: number = 4;

  /**
   * 应用名称出现的延迟
   */
  public static readonly APP_NAME_APPEAR_DELAY = 50;

  /**
   * 备份状态Preferences实例名称
   */
  public static readonly BACK_UP_STATUS = 'back_up_status';

  /**
   * 备份完成key
   */
  public static readonly BACK_UP_FINISH = 'back_up_finish';

  /**
   * 加载默认简易dock布局
   */
  public static readonly LOAD_DEFAULT_SIMPLE_DOCK_LAYOUT = 'load_default_simple_dock_layout';

  /**
   打点屏幕类型, 1为其他屏（默认值）， 2为新形态小外屏（新增)
   */
  public static readonly NORMAL_SCREEN_TYPE = 1;
  public static readonly OUTER_SCREEN_TYPE = 2;

  /**
   * 小折叠外屏编辑模式半模态页面默认高度
   */
  public static readonly OUTER_EDIT_HALF_MODE_DEFAULT_HEIGHT: number = 322;

  /**
   * 灭屏桌面图标动效时长参数
   */
  public static readonly DESKTOP_TO_AOD_ICON_DELAY: number = 300;


  public static readonly DRAG_RDB_EVENT: string = 'cache_to_rdb_after_drag';

  /**
   * 虚拟文件uri
   */
  public static readonly MOCK_URI: string = 'mock_uri';

  /**
   * 小折叠-内屏编辑外屏-读取布局锁定状态key
   */
  public static readonly OUTER_HOME_LAYOUT_LOCK = 'OuterHomeLayoutLock';

  /**
   小折叠外屏新增应用+号名
   */
  public static readonly OUTER_ADD_APP_ICON_BUNDLE_NAME = 'outer_add_app_icon_bundle_name';
  /**
   verde外屏桌面偏移量
   */
  public static readonly OUTER_SCREEN_OFFSET: number = 10;

  /**
   * 小折叠外屏卡片菜单截图位移px
   */
  public static readonly OUTER_CARD_PER_GRID_SIZE = 210;
  public static readonly OUTER_DESKTOP_SIZE = 980;
  public static readonly OUTER_CARD_AREA_TOP = 108;
  public static readonly OUTER_CARD_AREA_LEFT = 97;

  // 磁吸键盘状态：无键盘/有键盘B面/有键盘C面
  public static readonly NO_KEYBOARD = -1;
  public static readonly KEYBOARD_PAGE_B = 0;
  public static readonly KEYBOARD_PAGE_C = 1;

  /**
   * 适老化放大倍数1.45
   */
  public static readonly AGING_FONT_SCALE = 1.45;

  /**
   * 沙箱路径前缀
   */
  public static readonly SANDBOX_FILE_PREFIX: string = 'file://com.ohos.sceneboard';

  /**
   * 透明天气时钟卡片名称
   */
  public static readonly TRANSLUCENT_CLOCK_WEATHER_CARD: string[] =
    ['ClockWeatherCard', 'ClockWeatherHoriCard', 'OneMulFourClockCard'];

  /**
   * 卡片限制最小值
   */
  public static readonly MIN_FORM_LIMIT_COUNT: number = 50;

  /**
   *5000毫秒
   */
  public static readonly FIVE_THOUSAND_MSECOND = 5000;

  /**
   *应用最大数量 200个
   */
  public static readonly ITEM_MAX_NUM = 200;

  /**
   * 常驻区应用最大数量 100个
   */
  public static readonly RESIDENT_ITEM_MAX_NUM = 100;

  /**
   *文件夹数量 16个
   */
  public static readonly FOLDER_MAX_NUM = 16;

  /*
   * 联系人bundleName
   */
  static readonly CONTACTS_BUNDLE_NAME: string = 'com.ohos.contacts';

  /**
   * 助手bundleName
   */
  static readonly DISTRIBUTED_ASSIST: string = 'com.ohos.cardistributedassist';

  /**
   * 换壁纸大文件截图
   */
  static readonly BIG_FOLDER_TIMEOUT: number = 9000;

  /**
   * 云端2下面添加应用按钮的infoId
   */
  static readonly LIGHT_OUTDOOR_ADD_ICON_INFO_ID = 'light_outdoor_add_icon_id';
  
  /**
   * start renderGroup or not
   */
  public static readonly DESKTOP_ITEM_ENABLE_RENDER_GROUP = 'DesktopItemEnableRenderGroup';

  /**
   * SCB bundleName
   */
  public static readonly SCB_BUNDLENAME = 'com.ohos.sceneboard';

  /**
   * EngineServiceAbility
   */
  public static readonly ENGINESERVICE_ABILITY = 'EngineServiceAbility';
}

/**
 * 操作标志定义
 */
export enum FolderActionFlag {
  ACTION_CLICK = 1, // 0001, 可点击
  ACTION_DRAG = 2, // 0010，可拖拽
  ACTION_EDIT = 4, // 0100，可编辑
  ACTION_MENU = 8, // 1000，支持菜单
  ACTION_BACKGROUND = 16, // 10000，文件夹背板
}

export enum DeleteAction {
  //0 代表卸载， 1 代表移除
  ACTION_UNINSTALL = 0,
  ACTION_REMOVE = 1,
}

/**
 * 操作反馈效果定义
 */
export enum ActionEffectFlag {
  EFFECT_SCALE = 1, // 001, 缩放效果
  EFFECT_SHOW = 2, // 010，显隐效果
  EFFECT_LONG_PRESS = 4, // 100，长按效果
  EFFECT_BADGE = 8, // 1000，未读消息角标
}

/**
 * 组件布局相关常量
 */
export class ComponentConstants {
  /**
   * 默认模糊半径
   */
  public static readonly DEFAULT_BLUR_RADIUS = 50;
}

/**
 * cmd id for increase frequency
 */
export class PerfCmdId {
  /**
   * app cold start boost cmdId
   */
  public static readonly APP_START: number = 10000;

  /**
   * animation boost cmdId
   */
  public static readonly ANIMATION_BOOST: number = 10030;

  /**
   * animation rotation cmdId
   */
  public static readonly ANIMATION_ROTATION: number = 10027;
}

/*
 * dock栏图标位置相关常量
 */
export class CenterConstants {
  /*
   * 图标及小文件夹中心x坐标
   */
  public static itemCenterX: number[][] = [];
}

/**
 * device type and status
 */
export enum DeviceState {
  EXPAND_STATE = 1,
  FOLDED_STATE = 0,
  DEFAULT_STATE = FOLDED_STATE
}

/**
 * key constants
 */
export class KeyConstants {
  /**
   * key for item rectangle info
   */
  public static readonly ITEM_RECT = 'itemRect';
}

export enum AppStatus {
  INSTALLED, /** The app is already installed **/
  PENDING, /** Prepare to download app **/
  WAITING, /** The app store is ready for download the app and has not started **/
  DOWNLOADING, /** The app is being downloaded **/
  PAUSING, /** The app download task has been paused **/
  INSTALL_WAITING, /** The app is prepare install **/
  INSTALLING, /** The app is installing **/
  WIFI_WAITING, /** The progress is waiting wifi **/
  CREATED, /** for test **/
  WAIT_FOR_HARMONY, /** The app is waiting for harmony*/
  UPDATING, /** The app is update*/
  INSTALL_FAIL, /** The app is install FAIL **/
}

export interface AppGalleryEventInfo {
  bundleName: string,
  appName?: string,
  iconUrl?: string,
  status: number,
  totalSize?: number,
  downloadedSize?: number,
  errorCode?: number,
  errorDesc?: string,
  eventType: string,
  distributeType?: string,
  intent?: Map<string, object>,
}

export interface AppInstallStatusInfo {
  bundleName: string,
  taskContext?: string,
  errorCode?: number,
  errorDesc?: string
}

export interface DownloadStatusInfo {
  taskId?: string,
  bundleName: string,
  taskContext?: string,
  appName?: string,
  versionCode?: number,
  versionName?: string,
  iconUrl?: string,
  status: number,
  totalSize?: number,
  downloadedSize?: number,
  updateStatus?: number | undefined,
  legacyInfos?: LegacyInfo[] | undefined,
  oldBundleNames?: string[] | undefined,
  isSupportShare?: boolean
}

export interface AppDownloadInfo {
  taskId?: string,
  bundleName: string,
  moduleName?: string,
  totalSize: number,
  downloadedSize: number
}

/**
 *  桌面需要保存的信息，后续需要通过接口返回给应用市场
 */
export class LegacyInfo {
  // 对应包名 必传
  public pkgName: string = '';
  // 桌面上显示的应用包名（不会跟随小语种变化）
  public pkgLableName: string = '';
  // 应用签名信息（从迁移服务的app_list.json文件中获取，或克隆通过接口传递）  必传
  public pkgSignature: string = '';
  // App安装路径 （从迁移服务的app_list.json文件中获取，克隆场景不需要传入）
  public pkgSourceDir?: string;
  // 应用对应版本名（从迁移服务的app_list.json文件中获取，或克隆通过接口传递）
  public versionName?: string;
  // 应用对应版本code（从迁移服务的app_list.json文件中获取，或克隆通过接口传递）
  public versionCode?: string;
  // cpu类型（从迁移服务的app_list.json文件中获取），克隆当前无此信息
  public primaryCpuAbi?: string;
  // cpu类型（从迁移服务的app_list.json文件中获取），克隆当前无此信息
  public secondaryCpuAbi?: string;
  // 应用安装来源
  public installSource?: string;
  // 应用置灰状态
  public maskState?: number;
  // 快捷方式id
  public shortcutId?: string;
}

export interface DeleteItemType {
  bundleName: string | undefined,
  keyName: string | undefined,
  abilityName?: string,
  moduleName?: string,
  folderId?: string | undefined,
  deleteByDockDrop?: boolean,
  appIndex?: number,
  shortcutId?: string,
  isUninstalled?: boolean,
  container?: number,
  typeId?: number,
  isRemove?: boolean,
  isDeleteMainAppAndTwinApp?: boolean
}

export interface StartAppType {
  abilityName: string | undefined,
  bundleName: string | undefined,
  moduleName: string | undefined,
  appIndex?: number
}

export interface PageType {
  curPage: number | undefined,
  totalPage: number | undefined
}

export interface DownloadInfoItem {
  bundleName: string,
  iconResource?: string,
  appStatus?: AppStatus,
  downloadProgress?: number,
  abilityName?: string,
  moduleName?: string,
  callerName?: string,
  oldBundleName?: string,
  appIndex?: number,
  updateTwinApp?: boolean,
  intent?: string
}

/**
 * 克隆备份数据格式
 */
export interface CloneItemInfo {
  callerName?: string;
  callerType?: number;
  bundleName: string;
  packageName: string;
  title?: string;
  iconUri: string;
  isUsed?: boolean;
  intent?: string;
  appType?: number;
  enterpriseLink?: string;
  appIndex?: number;
  isInContainer?: boolean;
}

/**
 * GridLayoutItemInfo参数
 */
export interface ItemParameter {
  area: number[];
}

/**
 * 全搜定位图标类型
 */
export enum SearchLocationType {
  NULL_TYPE = -1,
  DOCK_TYPE = 0,
  DESKTOP_ITEM = 1,
  BIG_FOLDER_ITEM_TYPE = 2,
  SMALL_FOLDER_ITEM_TYPE = 3,
  DOCK_FOLDER_ITEM_TYPE = 4,
}

export enum AppGalleryEventStatus {
  /**
   * 创建任务
   */
  DOWNLOAD_CREATE_EVENT_ID = 501,

  /**
   * 等待下载
   */
  DOWNLOAD_WAIT_EVENT_ID = 502,

  /**
   * 暂停
   */
  DOWNLOAD_PAUSE_EVENT_ID = 503,

  /**
   * 恢复下载
   */
  DOWNLOAD_RESUME_EVENT_ID = 504,

  /**
   * WLAN预约
   */
  DOWNLOAD_WLAN_EVENT_ID = 505,

  /**
   * 下载失败
   */
  DOWNLOAD_FAILED_EVENT_ID = 506,

  /**
   * 下载成功
   */
  DOWNLOAD_SUCCEED_EVENT_ID = 507,

  /**
   * 下载取消
   */
  DOWNLOAD_CANCEL_EVENT_ID = 508,

  /**
   * 下载进度
   */
  DOWNLOAD_PROGRESS_EVENT_ID = 509,

  /**
   * 开始安装
   */
  INSTALL_START_EVENT_ID = 510,

  /**
   * 安装失败
   */
  INSTALL_FAILED_EVENT_ID = 511,

  /**
   * 安装成功
   */
  INSTALL_SUCCEED_EVENT_ID = 512,

  /**
   * 企业应用重置通知
   */
  COMPANY_APP_RESET_EVENT_ID = 518,
}

/**
 * constatns to calculate grid
 */
export class GridConstants {
  // 1 2 4 8 12 num of grid
  public static readonly RESPECT_NUM_DEFAULT: number = 1;
  public static readonly RESPECT_NUM_MIN: number = 2;
  public static readonly RESPECT_NUM_SMALL: number = 4;
  public static readonly RESPECT_NUM_BIG: number = 8;
  public static readonly RESPECT_NUM_MAX: number = 12;

  public static readonly RESPECT_VP_MIN: number = 320;
  public static readonly RESPECT_VP_MIDDLE: number = 600;
  public static readonly RESPECT_VP_MAX: number = 840;
}

/**
 * desktop mode enum
 */
export enum DesktopMode {
  NORMAL_MODE = 0,
  EDIT_MODE = 1,
  PREVIEW_MODE = 2
}

/**
 * bundle name constants enum
 */
export enum BundleConstants {
  /**
   * the bundle name of ai suggestion
   */
  AI_SUGGESTION_BUNDLE = 'com.ohos.suggestion',

  /**
   * the module name of ai suggestion
   */
  AI_SUGGESTION_MODULE = 'entry',

  /**
   * the ability name of ai suggestion
   */
  AI_SUGGESTION_ABILITY = 'ParentFormAbility',


  /**
   * the min card name of ai suggestion
   */
  AI_SUGGESTION_MIN_CARD = 'minVoiceRecCard',



  /**
   * the med card name of ai suggestion
   */
  AI_SUGGESTION_MED_CARD = 'medVoiceRecCard',



  /**
   * the max card name of ai suggestion
   */
  AI_SUGGESTION_MAX_CARD = 'maxVoiceRecCard'
}

/**
 * 系统栏（状态栏、导航条）沉浸式显隐变化类型
 */
export enum SystemBarChangeType {
  SHOW_BAR,
  HIDE_BAR,
  CANCEL_TASK, // 取消沉浸式隐藏的计时任务
  SET_TASK, // 设置沉浸式隐藏的计时任务
  AI_BAR_IMMERSE_TASK
}

/**
 * create form location parameter value enum
 */
export enum FormLocation {
  /**
   * form is on the other location
   */
  OTHER = -1,

  /**
   * form is on the desktop
   */
  DESKTOP = 0,

  /**
   * form is on the form center
   */
  FORM_CENTER = 1,

  /**
   * form is on the form manager
   */
  FORM_MANAGER = 2,

  /**
   * form is on the ai suggestion
   */
  AI_SUGGESTION = 7,
}

/**
 * constants for phone call animation
 */
export class PhoneCallAnimationConstants {
  public static readonly PHONE_CALL_TRANSITION_DURATION = 150;
  public static readonly PHONE_CALL_TRANSITION_DELAY = 160;
  public static readonly PHONE_CALL_TRANSITION_TO_DURATION = 200;
  public static readonly BACK_TRANSITION_DELAY = 0;
  public static readonly BACK_TRANSITION_DURATION = 150;
}

/**
 * 业务类型
 */
export enum BusinessType
{
  BUSINESS_BASIC_DESKTOP = 'basic desktop',
  BUSINESS_OUTER_DESKTOP = 'outer desktop',
  BUSINESS_CARD = 'card',
  BUSINESS_APP = 'app',
  BUSINESS_FOLDER = 'folder',
  BUSINESS_REGION_FOLDER = 'region_folder',
  BUSINESS_FOLDER_UNINSTALL = 'folder_uninstall',
  BUSINESS_MULTISELECT = 'multiSelect',
  BUSINESS_DRAG = 'drag',
  BUSINESS_APP_INSTALL = 'app_install',
  BUSINESS_EDITMODE_PAGEEDIT = 'editMode_pageEdit',
}

export enum DesktopLayoutState {
  HOME_LAUNCHER_MODE = 0,
  SIMPLE_LAUNCHER_MODEL = 1,
  PC_MODE_MODEL = 2,
  OUTDOOR_MODE = 3, // 户外模式模式
  LIGHT_OUTDOOR_MODE = 4, // 轻户外模式(云端2)
}

/**
 * 折叠pc宫格相关
 */
export class SuperFoldConstants {
  public static readonly DEFAULT_PAGE_COUNT = 2;

  public static readonly DEFAULT_PORTRAIT_COLUMN = 12;

  public static readonly DEFAULT_NON_PORTRAIT_COLUMN = 8;

  public static readonly DEFAULT_PORTRAIT_ROW = 7;

  public static readonly DEFAULT_NON_PORTRAIT_ROW = 11;
}

/**
 * 桌面设置相关
 */
export class DesktopSettingConstants {
  /**
   * 桌面设置Preferences名
   */
  public static readonly PREFERENCES_NAME = 'DesktopSetting';

  /**
   * 桌面下滑在设备中key值
   */
  public static readonly HI_SEARCH_OPEN_PREFERENCE = 'hisearch_open_preference';

  /**
   * 桌面下滑在设备中key值
   */
  public static readonly HI_SEARCH_OPEN_STATE = 'hiSearchStatus';

  /**
   * 桌面下滑在设备中默认值
   */
  public static readonly DEFAULT_VALUE_HI_SEARCH_OPEN_STATE = true;

  /**
   * 自动补位在设备中key值
   */
  public static readonly AUTOMATIC_FILLING_PREFERENCE = 'auto_align';

  /**
   * 自动补位在设备中key值
   */
  public static readonly AUTOMATIC_FILLING_STATE = 'autoAlignStatus';

  /**
   * 桌面下滑在设备中默认值
   */
  public static readonly DEFAULT_VALUE_AUTOMATIC_FILLING_STATE = false;

  /**
   * 锁定布局在设备中key值
   */
  public static readonly LOCK_LAYOUT_PREFERENCE = 'HOME_LOCK_SWITCH';

  /**
   * 锁定布局在设备中key值
   */
  public static readonly LOCK_LAYOUT_STATE = 'lockLayoutStatus';

  /**
   * 锁定布局在设备中默认值
   */
  public static readonly DEFAULT_VALUE_LOCK_LAYOUT_STATE = false;
}

export enum DesktopSortRule {
  SORT_NONE = 0,
  SORT_BY_NAME = 1,
  SORT_BY_MODIFY_TIME = 2,
  SORT_BY_CREATE_TIME = 3,
  SORT_BY_SIZE = 4,
  SORT_BY_TYPE = 5,
}

/**
 * 数据库操作结果
 */
export enum RdbHandleResult {
  // 操作成功
  SUCCESS = 0,
  // 操作失败
  FAIL = 1,
  // 操作取消
  CANCEL = 2,
}

export interface DesktopSortInfo {
  sortRule: DesktopSortRule,
  isAscend: boolean,
  page: number
}

/**
 * 应用分发类型
 */
export enum AppDistributionType {
  /**
   * 应用市场下载
   */
  APP_GALLERY = 'app_gallery',

  /**
   * 企业应用
   */
  ENTERPRISE = 'enterprise',

  /**
   * 预装应用
   */
  OS_INTEGRATION = 'os_integration',

  /**
   * 尝鲜应用
   */
  CROWDTESTING = 'crowdtesting',
}

/**
 * 克隆类型
 */
export enum SceneType {
  /**
   * 系统迁移
   */
  FROM_HW_LAUNCHER = 0,
  /**
   * 单窗口单屏
   */
  FROM_SCENE_BOARD = 1,

  /**
   * 系统迁移
   */
  HWLAUNCHER_MIGRATE_ohos = 2,
}

/**
 * 克隆过程卡片状态
 */
export enum CardCloneStatus {
  /**
   * 参数异常
   */
  PARAMS_ERROR = -1,

  /**
   * 正常使用
   */
  NORMAL = 0,

  /**
   * 应用不存在，需要创建占位卡
   */
  ABNORMAL_WITHOUT_APP = 1,

  /**
   * 应用存在，卡片不存在
   */
  ABNORMAL_WITHOUT_CARD = 2,
}

export class DeleteDockItem {
  public bundleName: string = '';
  public keyName?: string;
  public appIndex?: number;
  public shortcutId?: string;
  public appInstanceKey?: string;
  public isDeleteAppToUninstallFolder?: boolean;
  public typeId?: number
}

/**
 * 不同场景下图标的canvas蒙层类型
 */
export enum IconCanvasType {
  /**
   * 按压场景下的蒙层
   */
  TOUCH_MASK = 0,
  /**
   * 菜单预览场景下的按压蒙层
   */
  PRESS_MASK = 1,
  /**
   * 禁用场景下的蒙层
   */
  DISABLE_MASK = 2,
  /**
   * 拖拽场景下的蒙层
   */
  DRAG_MASK = 3,
  /**
   * 菜单预览场景下的蒙层
   */
  LONG_PRESS_MASK = 4,
  /**
   * 下载安装场景下的蒙层
   */
  INSTALL_MASK = 5,
  /**
   * 自定义蒙层
   */
  CUSTOM_MASK = 6,
}

/**
 * 翻页类型
 */
export enum SwiperPageType {
  FOLDER_SWIPER = 'FOLDER_SWIPER',
  DESKTOP_SWIPER = 'DESKTOP_SWIPER',
  STOP_SWIPER = 'STOP_SWIPER'
}

export interface IToast {
  LENGTH_LONG: number,
  LENGTH_SHORT: number,
  NORMAL: number
}