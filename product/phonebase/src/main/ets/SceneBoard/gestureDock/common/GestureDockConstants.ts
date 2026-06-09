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

import { ResUtils } from '@ohos/windowscene';
/**
 * GestureDock数据类型
 */
export enum DockType {
  RECENT,
  RESIDENT,
}

/**
 * GestureDock状态
 */
export enum GestureDockMode {
  INVISIBLE = 0,
  APPEAR = 1,
  ALL_APPS = 2,
  EDIT = 3,
}

/**
 * GestureDock常量
 */
export class GestureDockConstants {
  static readonly GESTURE_DOCK_WIDTH = ResUtils.getNumber($r('app.float.gesture_dock_width'));

  static readonly GESTURE_DOCK_RADIUS = ResUtils.getNumber($r('app.float.gesture_dock_radius'));

  static readonly GESTURE_DOCK_BLUR_RADIUS = ResUtils.getNumber($r('app.float.ohos_id_blur_style_thin_radius'));

  static readonly GESTURE_DOCK_PADDING = 16;

  static readonly GESTURE_DOCK_ITEM_DISTANCE = 12;

  static readonly GESTURE_DOCK_ICON_SIZE = ResUtils.getNumber($r('app.float.gesture_dock_icon_size'));

  static readonly GESTURE_DOCK_EDIT_ICON_SIZE = 24;

  static readonly GESTURE_DOCK_ICON_RADIUS = 14 * 40 / 54;

  static readonly GESTURE_DOCK_ALL_APP_ICON_RADIUS = 14 * 48 / 54;

  static readonly GESTURE_DOCK_DIVIDER_OPACITY = 0.4;

  static readonly GESTURE_DOCK_MAX_RECENT = 3;

  static readonly GESTURE_DOCK_MAX_PAD = 7;

  static readonly GESTURE_DOCK_BAR_MAX_COUNT = ResUtils.getNumber($r('app.float.gesture_dock_bar_max_count'));

  static readonly GESTURE_DOCK_BAR_MAX_COUNT_HORIZONTAL = 4;

  static readonly GESTURE_DOCK_ALLAPPS_MAX_RECENT = 8;

  static readonly GESTURE_DOCK_MAX_COUNT = 20;

  static readonly GESTURE_DOCK_RECENT_NAME = 'gesture_dock_recent';

  static readonly GESTURE_DOCK_APPS_NAME = 'gesture_dock_apps';

  static readonly GESTURE_DOCK_RATIO = 0.333;

  static readonly GESTURE_DOCK_RATIO_CHANGE = 0.75;

  static readonly APP_ICON_OPACITY_60 = 0.6;

  static readonly APP_ICON_OPACITY_100 = 1;

  static readonly GESTURE_DOCK_DISTANCE_VP = 120;

  static readonly GESTURE_DOCK_TIME = 100 * 1000000;

  static readonly GESTURE_DOCK_REVERT_DISTANCE = 30;

  static readonly GESTURE_DOCK_IN_POSITION = 80;

  static readonly GESTURE_DOCK_OUT_POSITION = 0;

  static readonly GESTURE_DOCK_OUT_EDGE = 10;

  static readonly APPEAR_DELAY = 200;

  static readonly DISAPPEAR_DELAY = 80;

  static readonly DOCK_OUT_DELAY = 1000;

  static readonly CUSTOM_SHOW_COUNT = 5;

  static readonly EDIT_ICON_COUNT = 1;

  static readonly MAX_CUSTOM_COUNT = 15;

  static readonly BLEND_MODE_HEIGHT = 12;

  static readonly BLEND_MODE_DEFAULT_RATIO = 0.025;

  static readonly INVALID_VALUE = -1;

  static readonly BLUR_RADIUS = 50;

  /**
   * GestureDock app item for ID.
   */
  static readonly GESTURE_DOCK_ITEM_TAG = 'Gesture_Dock_AppItem_';

  /**
   * GestureDock scale animate
   */
  static readonly GESTURE_DOCK_SCALE_ANIMATE_TIME = 300;

  /**
   * GestureDock opacity animate
   */
  static readonly GESTURE_DOCK_OPACITY_ANIMATE_TIME = 200;

  /**
   * GestureDock scale
   */
  static readonly GESTURE_DOCK_SCALE = 0.4;

  /**
   * GestureDock scale
   */
  static readonly GESTURE_DOCK_SYMBOL_OPACITY = 0.4;

  /**
   * dock栏元素挤位事件
   */
  static readonly GESTURE_DOCK_ITEM_SQUEEZE_START = 'gesture_dock_item_squeeze_start_';

  /**
   * dock栏元素落位事件
   */
  static readonly GESTURE_DOCK_ITEM_DROP = 'gesture_dock_item_drop_';

  /**
   * dock栏元素复位事件
   */
  static readonly GESTURE_DOCK_ITEM_SQUEEZE_CANCEL = 'gesture_dock_item_squeeze_cancel';

  /**
   * allApps给dock栏添加元素
   */
  static readonly GESTURE_DOCK_ADD_ITEM = 'gesture_dock_add_item';

  /**
   * allApps给dock栏移除元素
   */
  static readonly GESTURE_DOCK_REMOVE_ITEM = 'gesture_dock_remove_item';

  /**
   * allApps中元素
   */
  static readonly GESTURE_DOCK_ALL_APPS = 'gesture_dock_all_apps_';

  static readonly ALL_APPS_SEARCH_RADIUS = 20;

  static readonly GESTURE_DOCK_EDIT_ICON_ALL_APPS = 18;

  static readonly GESTURE_DOCK_EDIT_ICON = 16;

  static readonly GESTURE_DOCK_EDIT_ICON_PADDING = 8;

  /**
   * gestureDock滑动距离
   */
  static readonly GESTURE_DOCK_SCROLL = 'gesture_dock_scroller_';

  /**
   * dock栏删除元素事件
   */
  static readonly GESTURE_DOCK_DELETE_ITEM = 'gesture_dock_delete_item_';

  /**
   * dock栏元素drop事件
   */
  static readonly GESTURE_DOCK_DROP_ITEM = 'gestureDock_drop';

  /**
   * dock栏元素显示事件
   */
  static readonly GESTURE_DOCK_VISIBLE = 'gesture_dock_item_visible_';

  /**
   * gestureDock滑动距离
   */
  static readonly GESTURE_DOCK_DIVIDER_PADDING = 6;

  static readonly SYS_STANDARD_HEIGHT = 56;

  static readonly ALL_APPS_PADDING = 16;

  static readonly ALL_APPS_GUTTER = 16;

  static readonly ALL_APPS_APP_SIZE = 48;

  static readonly ALL_APPS_NAME_WIDTH = 66;

  static readonly ALL_APPS_LINE_COUNT = 4;

  static readonly ALL_APPS_PADDING_FOLDER = 48;

  static readonly ALL_APPS_APP_SIZE_FOLDER = 56;

  static readonly ALL_APPS_NAME_WIDTH_FOLDER = 96;

  static readonly ALL_APPS_LINE_COUNT_FOLDER = 6;

  static readonly ALL_APPS_COMMON_PADDING = 4;

  static readonly ALL_APPS_NAME_HEIGHT = 12;

  static readonly ALL_APPS_NAME_TOP_MARGIN = 4;

  // allApps返回键id
  static readonly ALL_APPS_TITLEBAR_ID: string = 'GestureDockAllAppsView_titleBarBuilder';

  /**
   * 深色模式colorMode：0
   */
  static readonly DARK_COLOR_MODE: number = 0;

  /**
   *  浅色模式colorMode：1
   */
  static readonly LIGHT_COLOR_MODE: number = 1;

  static readonly DIVIDER_COLOR: Resource = $r('sys.color.comp_divider');

  // 深色浅色模式均使用同一个颜色
  static readonly COLOR_TEXT_SECONDARY: string = '#99FFFFFF';

  static readonly COLOR_TEXT_PRIMARY: string = '#E6FFFFFF';

  static readonly ALL_APPS_BACKGROUND_COLOR: string = '#33000000';

  static readonly ALL_APPS_BACKGROUND_RADIUS: number = 100;

  static readonly RECENT_COUNT_TWO: number = 2;

  static readonly RECENT_COUNT_ONE: number = 1;

  static readonly GESTURE_DOCK_TAG: string = 'SCBGestureDock';

  static readonly UPDATE_ITEM_OPACITY: string = 'UPDATE_ITEM_OPACITY';

  static readonly GESTURE_DOCK_APPEAR = 'GestureDockAppear';

  static readonly GESTURE_DOCK_SHOW = 'gestureDockShow';

  static readonly GESTURE_DOCK_DISAPPEAR = 'GestureDockDisappear';

  static readonly REAL_BUNDLE_NAME = 'realBundleName';

  static readonly REAL_ABILITY_NAME = 'realAbilityName';

  static readonly REAL_MODULE_NAME = 'realModuleName';

  // 呼出Dock栏停留时间
  static readonly GESTURE_DOCK_STAY_DURATION: number = 80;
}