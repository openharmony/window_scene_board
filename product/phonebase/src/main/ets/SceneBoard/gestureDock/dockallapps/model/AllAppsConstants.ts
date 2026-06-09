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
 * allApps常量
 */
export class AllAppsConstants {
  static readonly GESTURE_DOCK_WIDTH = ResUtils.getNumber($r('app.float.gesture_dock_width'));

  static readonly GESTURE_DOCK_RADIUS = ResUtils.getNumber($r('app.float.gesture_dock_radius'));

  static readonly GESTURE_DOCK_PADDING = 16;

  static readonly GESTURE_DOCK_ITEM_DISTANCE = 12;

  static readonly GESTURE_DOCK_ICON_SIZE = ResUtils.getNumber($r('app.float.gesture_dock_icon_size'));

  static readonly GESTURE_DOCK_ICON_RADIUS = 14 * 40 / 54;

  static readonly GESTURE_DOCK_DIVIDER_OPACITY = 0.4;

  static readonly GESTURE_DOCK_MAX_RECENT = 3;

  static readonly GESTURE_DOCK_ALLAPPS_MAX_RECENT = 8;

  static readonly GESTURE_DOCK_MAX_COUNT = 20;

  static readonly GESTURE_DOCK_RECENT_NAME = 'gesture_dock_recent';

  static readonly GESTURE_DOCK_APPS_NAME = 'gesture_dock_apps';

  static readonly GESTURE_DOCK_RATIO = 0.333;

  static readonly GESTURE_DOCK_RATIO_CHANGE = 0.75;

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

  static readonly ALL_APPS_TEXT_SIZE_BODY2 = ResUtils.getNumber($r('sys.float.ohos_id_text_size_body2'));

  static readonly ALL_APPS_SEARCH_BOX_WIDTH = 264;

  static readonly ALL_APPS_SEARCH_RADIUS = 20;

  static readonly SYS_STANDARD_HEIGHT = 56;

  static readonly ALL_APPS_PADDING = 16;

  static readonly ALL_APPS_GUTTER = 7;

  static readonly ALL_APPS_APP_SIZE = 48;

  static readonly ALL_APPS_NAME_WIDTH = 66;

  static readonly ALL_APPS_LINE_COUNT = 4;

  static readonly ALL_APPS_PADDING_FOLDER = 48;

  static readonly ALL_APPS_PADDING_PADDING = 90;

  static readonly ALL_APPS_PADDING_LANDSCAPE = 60;

  static readonly ALL_APPS_APP_SIZE_FOLDER = 56;

  static readonly ALL_APPS_NAME_WIDTH_FOLDER = 96;

  static readonly ALL_APPS_LINE_COUNT_FOLDER = 6;

  static readonly ALL_APPS_COMMON_PADDING = 4;

  static readonly ALL_APPS_NAME_HEIGHT = 18;

  static readonly ALL_APPS_TITLE_ICON_SIZE = 24;

  static readonly ALL_APPS_ICON_RADIO = 14 / 54 * 48;

  static readonly ALL_APPS_ICON_RADIO_FOLDER = 14 / 54 * 56;

  static readonly ALL_APPS_BOTTOM_PADDING = 30;

  static readonly ALL_APPS_RECENT_GRADIENT_TOP = 20;

  static readonly ALL_APPS_RECENT_GRADIENT_BOTTOM = 70;

  static readonly ALL_APPS_SEARCH_NO_RESULT_WIDTH = 110;

  static readonly ALL_APPS_SEARCH_NO_RESULT_HEIGHT = 89;

  static readonly ALL_APPS_BLUR = 50;

  static readonly ALL_APPS_COLUMN_GUTTER = 52;

  static readonly SYS_SUBTITLE_SIZE = $r('sys.float.ohos_id_text_size_sub_title1');

  static readonly SYS_TEXTSIZE_BODY = $r('sys.float.ohos_id_text_size_body1');

  static readonly ALL_APPS_WIDTH_WATERSHED = 400;

  static readonly ALL_APPS_PADDING_SMALL_RATE = 0.055;

  static readonly ALL_APPS_PADDING_LARGE_RATE = 0.07;

  static readonly ALL_APPS_FLING_SPEED = 3000;

  static readonly ALL_APPS_FLING_CACHE_COUNT = 3;

  static readonly ALL_APPS_APP_NAME_COLOR = $r('sys.color.font_on_primary');

  /**
   * 空格
   */
  static readonly WHITESPACE: RegExp = /\s*/g;
}