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

export enum ArrowType {
  RESIDENT_LEFT = 0,
  RESIDENT_RIGHT = 1,
  RECENT_LEFT = 2,
  RECENT_RIGHT = 3
}

export enum PreviewScrollState {
  NORMAL = 0,
  REACH_START = 1,
  REACH_END = 2
}

export class FixedDockResource {
  public static readonly RECENT_CENTER_ICON_FOREGROUND = '/common/pics/ic_recent_ability_foreground.svg';

  public static readonly PREVIEW_ARROW_LEFT = '/common/pics/ic_light_arrow_left.svg';
  public static readonly PREVIEW_ARROW_RIGHT = '/common/pics/ic_light_arrow_right.svg';
  public static readonly PREVIEW_CLOSE_NORMAL = '/common/pics/ic_close_normal.svg';
  public static readonly SNAPSHOT_ITEM_HEIGHT = 212;
  public static readonly SNAPSHOT_ITEM_DEFAULT_WIDTH = 218;
  public static readonly SNAPSHOT_ITEM_MIN_WIDTH = 88;
  public static readonly SNAPSHOT_ITEM_MAX_WIDTH = 288;
  public static readonly SNAPSHOT_GAP = 24;
  public static readonly PREVIEW_MARGIN_WHEN_HAS_ARROW = 48;
  public static readonly PREVIEW_MARGIN_WHEN_NO_ARROW = 24;
  public static readonly PREVIEW_SCREEN_PADDING = 24;
  public static readonly PREVIEW_ARROW_MARGIN_LEFT = 8;
  public static readonly PREVIEW_ARROW_MARGIN_RIGHT = 8;
  public static readonly PREVIEW_ARROW_MARGIN_TOP = 86;
  public static readonly PREVIEW_ARROW_MARGIN_BOTTOM = 86;
  public static readonly PREVIEW_ARROW_SIZE = 32;
  public static readonly SNAPSHOT_ITEM_PADDING_TOP = 8;
  public static readonly SNAPSHOT_ITEM_PADDING_BOTTOM = 24;
  public static readonly SNAPSHOT_ITEM_PADDING_LEFT = 12;
  public static readonly SNAPSHOT_ITEM_PADDING_RIGHT = 12;
  public static readonly SNAPSHOT_CLOSE_BUTTON_SIZE = 24;
  public static readonly SNAPSHOT_TITLE_HEIGHT = 24;
  public static readonly SNAPSHOT_ITEM_TITLE_HEIGHT = 32;
  public static readonly SNAPSHOT_TITLE_MARGIN_BOTTOM = 4;
  public static readonly SNAPSHOT_IMAGE_HEIGHT = 144;
  public static readonly SNAPSHOT_IMAGE_INNER_BORDER_RADIUS = 4;
  public static readonly SNAPSHOT_IMAGE_OUTER_BORDER_RADIUS = 4;
  public static readonly SNAPSHOT_IMAGE_SHADOW_RADIUS = 4;
  public static readonly SNAPSHOT_IMAGE_SHADOW_COLOR = '#19000000';
  public static readonly PREVIEW_BORDER_RADIUS = 16;
  public static readonly LIGHT_CONTINUABLE_PREVIEW_BG_COLOR = '#99ffffff';
  public static readonly DARK_CONTINUABLE_PREVIEW_BG_COLOR = '#33ffffff';

  public static readonly TIPS_TEXT_HEIGHT = 24;
  public static readonly TIPS_TEXT_MARGIN = 6;
  public static readonly TIPS_TEXT_FONT_SIZE = 16;
  public static readonly TIPS_TEXT_MIN_WIDTH = 32;
  public static readonly TIPS_TEXT_PADDING = 2;
  public static readonly TIPS_POPUP_HEIGHT = 32;
  public static readonly TIPS_POPUP_PADDING = 8;
  public static readonly TIPS_POPUP_BORDER_RADIUS = 16;
  public static readonly POPUP_MIN_TEXT_WIDTH = 64;
  public static readonly POPUP_MIN_TEXT_HEIGHT = 24;

  public static readonly MENU_TEXT_WIDTH = 140;

  public static readonly DOCK_RESIDENT_AREA_ID = 'DOCK_RESIDENT_AREA';
  public static readonly DOCK_RECENT_AREA_ID = 'DOCK_RECENT_AREA';
  public static readonly CLEAR_RECYCLE_BIN_KEY_STRING = 'clearRecycleBin';
  public static readonly DOCK_MENU_OFFSET_X = 4;
  public static readonly DOCK_MENU_OFFSET_Y = 8;
}