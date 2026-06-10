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

export default class Constants {
  public static readonly FUNCTION_ITEN_LOCK_SCREEN = 'lockScreen';
  public static readonly FUNCTION_ITEN_TASK_MANAGER = 'taskManager';
  public static readonly FUNCTION_ITEN_LOGOUT = 'logout';
  public static readonly FUNCTION_ITEN_SWITCH_USER = 'switchUser';
  public static readonly FUNCTION_ITEN_FORCE_EXIT = 'forceExit';
  public static readonly FUNCTION_ITEN_CANEL = 'Cancel';

  public static readonly DEFAULT_FOCUS_INDEX = 0;
  public static readonly FUNCTION_LOCK_SCREEN_INDEX = 0;
  public static readonly FUNCTION_LOGOUT_INDEX = 1;
  public static readonly FUNCTION_SWITCH_USER_INDEX = 2;
  public static readonly FUNCTION_TASK_MANAGER_INDEX = 3;
  public static readonly FUNCTION_FORCE_EXIT_INDEX = 4;
  public static readonly FUNCTION_CLOSE_INDEX = 5;

  public static readonly APP_CENTER_WALLPAPER_BACKGROUND_COLOR = '#4d262626';
  public static readonly APP_CENTER_WALLPAPER_SATURATE = 1.4;
  public static readonly DEFAULT_WALLPAPER_SCALE = 1.10;
  public static readonly APP_CENTER_BK_BLUR = 233;
  public static readonly APP_CENTER_BK_OPACITY = 1;
  public static readonly EVENT_CTRL_ALT_DEL = 'usual.event.CTRL_ALT_DEL';

  public static readonly FUNCTION_ITEM_MARGIN_LEFT = 72;
  public static readonly FUNCTION_ITEM_MARGIN_RIGHT = 72;
  public static readonly FUNCTION_ITEM_FOCUS_BORDER_WIDTH = 2;
  public static readonly FUNCTION_MARGIN_TOP = 411;
  public static readonly FUNCTION_ITEM_GAP = 8;
  public static readonly CANCLE_VIEW_HEIGHT = 40;
  public static readonly CANCLE_VIEW_WIDTH = 120;
  public static readonly CANCLE_VIEW_MARGIN_TOP = 271;
  public static readonly CANCLE_VIEW_MARGIN_BOTTOM = 96;
  public static readonly CANCLE_VIEW_RADIUS = 8;
  public static readonly CANCLE_ICON_HEIGHT = 24;
  public static readonly CANCLE_ICON_WIDTH = 24;

  public static readonly FUNCTION_ITEM_HEIGHT = 48;
  public static readonly FUNCTION_ITEM_WIDTH = 200;
  public static readonly FUNCTION_ITEM_HEIGHT_LG = 56;
  public static readonly FUNCTION_ITEM_WIDTH_LG = 240;
  public static readonly FUNCTION_ITEM_RADIUS = 8;
  public static readonly FUNCTION_ICON_HEIGHT = 24;
  public static readonly FUNCTION_ICON_WIDTH = 24;
  public static readonly FUNCTION_SYMBOL_SIZE = 28;

  public static readonly FUNCTION_TEXT_HEIGHT = 21;
  public static readonly FUNCTION_TEXT_WIDTH = 147;
  public static readonly FUNCTION_TEXT_WIDTH_LG = 167;
  public static readonly FUNCTION_TEXT_SIZE = 16;
  public static readonly FUNCTION_TEXT_MARGIN_TOP = 12;

  public static readonly FORCE_EXIT_COMPONENT_HEIGHT = 560;
  public static readonly FORCE_EXIT_COMPONENT_WIDTH = 480;

  /**
   * Hopper 功能键上边距
   */
  public static readonly FUNCTION_MARGIN_TOP_HPR_FLOAT = 322;
  public static readonly FUNCTION_MARGIN_TOP_HPR_VERTICAL = 780;
  public static readonly FUNCTION_MARGIN_TOP_HPR_HORIZONTAL = 551;

  /**
   * Hopper 取消键上边距
   */
  public static readonly CANCEL_MARGIN_TOP_HPR_FLOAT = 186;
  public static readonly CANCEL_MARGIN_TOP_HPR_VERTICAL = 644;
  public static readonly CANCEL_MARGIN_TOP_HPR_HORIZONTAL = 415;

  public static readonly VIRTUAL_MACHINE_KEY = 'hwf.shutdown.allowed';
  public static readonly LOGOUT_FROM_SCREEN_LOCK: string = 'logout_from_screen_lock';
}

export interface FoldStateChangeListener { onFoldStateChange: Function };