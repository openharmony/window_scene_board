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

const DPI_RATIO = 1.16;

export default class PhonePresetConstants {
  //----------- desktop layout-------------

  /**
   * UninstallDialog width
   */
  public static readonly DEFAULT_UNINSTALLDIALOG_WIDTH = '100%';

  /**
   * systemUI top height
   */
  public static readonly DEFAULT_SYS_TOP_HEIGHT = 39;

  /**
   * systemUI bottom height
   */
  public static readonly DEFAULT_SYS_BOTTOM_HEIGHT = 0;

  /**
   * systemui bottom padding
   */
  public static readonly DEFAULT_SYSTEM_UI_BOTTOM_PADDING = 12;

  /**
   * indicator height
   */
  public static readonly DEFAULT_PHONE_INDICATOR_HEIGHT = 10;

  /**
   * desktop item size
   */
  public static readonly DEFAULT_APP_LAYOUT_SIZE = 84 / DPI_RATIO;

  /**
   * desktop container margin
   */
  public static readonly DEFAULT_LAYOUT_MARGIN = 25 / DPI_RATIO;

  /**
   * desktop appItem padding
   */
  public static readonly DEFAULT_LAYOUT_ITEM_PADDING = 10 / DPI_RATIO;

  /**
   * desktop container minimum gutter
   */
  public static readonly DEFAULT_APP_LAYOUT_MIN_GUTTER = 10 / DPI_RATIO;
  //----------- desktop icon-------------
  /**
   * desktop item padding top
   */
  public static readonly DEFAULT_APP_TOP_RATIO = 0.1 / DPI_RATIO;

  /**
   * desktop item name lines
   */
  public static readonly DEFAULT_APP_NAME_LINES = 1;

  /**
   * desktop item name size
   */
  public static readonly DEFAULT_APP_NAME_TEXT_SIZE = 14 / DPI_RATIO;

  /**
   * desktop icon name margin top
   */
  public static readonly DEFAULT_ICON_NAME_GAP = 0;

  /**
   * desktop item icon and name gap
   */
  public static readonly DEFAULT_ICON_NAME_MARGIN_TOP = 4 / DPI_RATIO;

  /**
   * desktop icon name height
   */
  public static readonly DEFAULT_DESKTOP_NAME_HEIGHT = 20 / DPI_RATIO;

  /**
   * desktop icon name width
   */
  public static readonly DEFAULT_DESKTOP_NAME_WIDTH = 80 / DPI_RATIO;

  //----------- desktop folder-----------
  /**
   * folder gutter with container size
   */
  public static readonly DEFAULT_FOLDER_GUTTER_RATIO = 0.043 / DPI_RATIO;

  /**
   * folder padding with container size
   */
  public static readonly DEFAULT_FOLDER_PADDING_RATIO = 0.07 / DPI_RATIO;

  //----------- desktop open --------------
  /**
   * gutter of open folder
   */
  public static readonly DEFAULT_OPEN_FOLDER_GUTTER = 4;

  /**
   * margin of open folder tittle
   */
  public static readonly DEFAULT_OPEN_FOLDER_TITTLE_MARGIN = 46;

  /**
   * gutter of open folder in expand
   */
  public static readonly FOLDABLE_EXPAND_OPEN_FOLDER_GUTTER = 16;

  /**
   * padding of open folder
   */
  public static readonly DEFAULT_OPEN_FOLDER_PADDING = 18 / DPI_RATIO;

  /**
   * margin top of open folder
   */
  public static readonly DEFAULT_OPEN_FOLDER_MARGIN_TOP = 100 / DPI_RATIO;

  /**
   * margin top of open folder
   */
  public static readonly DEFAULT_OPEN_FOLDER_TITLE_TOP = 90 / DPI_RATIO;

  //----------- folder add list ------------------
  /**
   * max height of container
   */
  public static readonly DEFAULT_FOLDER_ADD_MAX_HEIGHT = 0.8 / DPI_RATIO;

  /**
   * margin of container
   */
  public static readonly DEFAULT_FOLDER_ADD_MARGIN = 18 / DPI_RATIO;

  /**
   * gutter of container
   */
  public static readonly DEFAULT_FOLDER_ADD_GAP = 12 / DPI_RATIO;

  /**
   * toggle of item
   */
  public static readonly DEFAULT_APP_GRID_TOGGLE_SIZE = 20 / DPI_RATIO;

  /**
   * icon padding of item with item size
   */
  public static readonly DEFAULT_FOLDER_ADD_ICON_TOP_RATIO = -0.03 / DPI_RATIO;

  /**
   * name size of container
   */
  public static readonly DEFAULT_FOLDER_ADD_GRID_TEXT_SIZE = 12 / DPI_RATIO;

  /**
   * title size of container
   */
  public static readonly DEFAULT_FOLDER_ADD_TITLE_TEXT_SIZE = 20 / DPI_RATIO;

  /**
   * name lines of item
   */
  public static readonly DEFAULT_FOLDER_ADD_TEXT_LINES = 1;

  /**
   * button size of container
   */
  public static readonly DEFAULT_FOLDER_ADD_BUTTON_SIZE = 16 / DPI_RATIO;

  //----------- app center--------------
  /**
   * margin left of app center
   */
  public static readonly DEFAULT_APP_CENTER_MARGIN = 215 / DPI_RATIO;

  /**
   * gutter of app center
   */
  public static readonly DEFAULT_APP_CENTER_GUTTER = 18 / DPI_RATIO;

  /**
   * item size of app center
   */
  public static readonly DEFAULT_APP_CENTER_SIZE = 106 / DPI_RATIO;

  /**
   * icon padding top with item size
   */
  public static readonly DEFAULT_APP_CENTER_TOP_RATIO = 0.01 / DPI_RATIO;

  /**
   * name lines of app center
   */
  public static readonly DEFAULT_APP_CENTER_NAME_LINES = 2 / DPI_RATIO;

  /**
   * name size of app center
   */
  public static readonly DEFAULT_APP_CENTER_NAME_TEXT_SIZE = 18 / DPI_RATIO;

  //----------- dock----------------
  /**
   * icon size of dock
   */
  public static readonly DEFAULT_DOCK_ICON_SIZE = 52;

  /**
   * portrait icon size of dock
   */
  public static readonly DEFAULT_PORTRAIT_DOCK_ICON_SIZE = 54;

  /**
   * padding of dock
   */
  public static readonly DEFAULT_DOCK_PADDING = 12;

  /**
   * gap of dock container
   */
  public static readonly DEFAULT_DOCK_ITEM_GAP = 31.33;

  /**
   * gap with resident and recent
   */
  public static readonly DEFAULT_DOCK_GUTTER = 18;

  /**
   * save margin of dock
   */
  public static readonly DEFAULT_DOCK_SAVE_MARGIN = 10;

  /**
   * margin bottom of dock
   */
  public static readonly DEFAULT_DOCK_MARGIN_BOTTOM = 27;

  /**
   * margin bottom of dock(Immersive navigation bar)
   */
  public static readonly DEFAULT_DOCK_MARGIN_BOTTOM_HIDE_BAR = 28;

  /**
   * open folder grid height
   */
  public static readonly DEFAULT_OPEN_FOLDER_GRID_HEIGHT = 566 / DPI_RATIO;

  /**
   * open folder swiper height
   */
  public static readonly DEFAULT_OPEN_FOLDER_SWIPER_HEIGHT = 650 / DPI_RATIO;
}
