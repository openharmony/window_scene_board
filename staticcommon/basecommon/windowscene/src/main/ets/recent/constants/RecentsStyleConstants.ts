/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

export class RecentsStyleConstants {

  // image resources
  static readonly DEFAULT_BG_COLOR = '#00000000';
  static readonly DEFAULT_APP_ICON_IMAGE: Resource = $r('app.media.icon');

  // font style resources
  static readonly DEFAULT_FONT_COLOR = '#ffffff';

  // layout percentage adaptation resources
  static readonly DEFAULT_LAYOUT_PERCENTAGE = '100%';

  // style resources
  static readonly RECENT_APP_ICON_BORDER_RADIUS = 6;

  // recent
  static readonly VERTICAL_RECENT_SCALE = 0.65;
  static readonly HORIZONTAL_RECENT_SCALE = 0.5;
  static readonly MULTI_RECENT_SCALE = 0.3;
  static readonly MULTI_RECENT_RATIO_MIDDLE_MARGIN = 0.08;
  static readonly PAD_RECENT_PORTRAIT_RATIO_MIDDLE_MARGIN = 0.06;
  static readonly MULTI_RECENT_LANDSCAPE_RATIO_BOTTOM_MARGIN = 0.15;
  static readonly MULTI_RECENT_PORTRAIT_RATIO_BOTTOM_MARGIN = 0.17;
  static readonly PAD_RECENT_LANDSCAPE_RATIO_BOTTOM_MARGIN = 0.17;
  static readonly PAD_RECENT_PORTRAIT_RATIO_BOTTOM_MARGIN = 0.16;
  static readonly RECENT_DISTANCE_TO_BOTTOM_RATIO = 0.2;
  static readonly RECENT_DISTANCE_TO_BOTTOM_RATIO_OUTER = 0.175;
  static readonly HORIZONTAL_RECENT_DISTANCE_TO_BOTTOM_RATIO = 0.25;
  static readonly LEFT_MARGIN_BETWEEN_ICON_NAME = 6.0;

  static readonly RECENT_SINGLE_MIDWAY_SCALE = 0.6;

  static readonly HORIZONTAL_RECENT_SINGLE_MIDWAY_SCALE = 0.45;
  static readonly SCALE_DEFAULT = 1;
  static readonly RECENT_VIEW_COUNT = 3;
  static readonly RECENT_VIEW_COUNT_FROM_HOME = 2;
  static readonly RECENT_VIEW_COUNT_MULTI = 8;
  static readonly GESTURE_NAVIGATION_HEIGHT_DISTANCE_COEFFICIENTS = 0.875;
  static readonly GESTURE_NAVIGATION_HEIGHT_DISTANCE_EXP = -0.0456;
  static readonly SINGLE_LIST_SCALE_MOVE_FROM_DESKTOP_PARA1 = 0.52;
  static readonly SINGLE_LIST_SCALE_MOVE_FROM_DESKTOP_PARA2 = 0.34;
  static readonly SINGLE_LIST_SCALE_MOVE_FROM_DESKTOP_PARA3 = 0.176;
  static readonly SINGLE_LIST_SCALE_MAX = 0.85;
  static readonly DESKTOP_SCALE_FROM_HOME_TO_RECENT = 0.88;
  static readonly DESKTOP_SCALE_MAX = 1.0;
  static readonly FOREGROUND_BLUR_RADIUS = 200;
  static readonly MIN_DEL_ANI_ANGLE = -20;
  static readonly MAX_DEL_ANI_ANGLE = -85;
  static readonly IN_OUT_RECENT_BLUR_RADIUS = 52;
  static readonly EXTRA_EXIT_RECENT_MOVE_DISTANCE = 0.25;
  static readonly RECENT_EMPTY_FONT_SIZE = 16;
  static readonly NORMAL_CUTOUT_HEIGHT_PERCENT = 0.05;
  static readonly RECENT_DISTANCE_LIMIT_MAX = 0.6;
  static readonly RECENT_LEAVE_LIMIT_LANDSCAPE = 0.5;
  static readonly RECENT_LANDSCAPE_RATIO = 2;
  static readonly RECENT_DISTANCE_LIMIT_MIN = 0.05;
  // 单行多任务卡片最大下滑距离
  static readonly SINGLE_ROW_MAX_SLIDE_DISTANCE = 30;
  // 双行多任务卡片最大下滑距离
  static readonly MULTI_ROW_MAX_SLIDE_DISTANCE = 20;
  // 卡片跟手最大聚拢距离
  static readonly MAX_GATHER_DISTANCE = 4;
  // 下滑卡片跟手率
  static readonly SLIDE_FOLLOWING_RATE = 0.3;
  // 下滑相邻卡片聚拢跟手率
  static readonly SLIDE_GATHER_RATE = 0.04;
  // 手势异常时返回默认值
  static readonly DEFAULT_FINGER_POS_X = -1;

  // pad tab selected border style
  static readonly DEFAULT_SELECTED_BORDER_COLOR = '#0A59F7';
  static readonly DEFAULT_SELECTED_BORDER_WIDTH = 4;
  static readonly DEFAULT_BORDER_WIDTH = 0;
  static readonly DEFAULT_MAX_RECENT_NUM = 1000;
  static readonly SETTING_ITEM_RECENT_LOCK = 'RECENT_LOCK_INIT_STATUS';
}