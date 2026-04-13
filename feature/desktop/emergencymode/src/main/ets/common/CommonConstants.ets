/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
 * Common constants
 */
export class CommonConstants {
  /**
   * Grid gutter of all devices
   */
  public static readonly GRID_GUTTER = 12;

  /**
   * Grid small margin of phone and fold
   */
  public static readonly GRID_SMALL_MARGIN = 12;

  /**
   * Grid big margin of pad
   */
  public static readonly GRID_BIG_MARGIN = 24;

  /**
   * Grid number of small device
   */
  public static readonly GRID_SMALL_NUMBER = 4;

  /**
   * Grid number of middle size device
   */
  public static readonly GRID_MIDDLE_NUMBER = 8;

  /**
   * Grid number of large size device
   */
  public static readonly GRID_LARGE_NUMBER = 12;

  /**
   * App item width of folder in folded status
   */
  public static readonly APP_WIDTH_IN_FOLDED = 56;

  /**
   * App item width of folder in expanded status
   */
  public static readonly APP_WIDTH_IN_EXPANDED = 64;

  /**
   * App item height of folder in folded status
   */
  public static readonly APP_HEIGHT_IN_FOLDED = 76;

  /**
   * App item height of folder in expanded status
   */
  public static readonly APP_HEIGHT_IN_EXPANDED = 84;

  /**
   * App item grid gutter y in folder status
   */
  public static readonly APP_GRID_GUTTER_Y_IN_FOLDED = 36;

  /**
   * App item grid gutter y in expanded status
   */
  public static readonly APP_GRID_GUTTER_Y_IN_EXPANDED = 44;

  /**
   * App grid columns
   */
  public static readonly APP_GRID_COLUMNS = 3;

  /**
   * App name height
   */
  public static readonly APP_NAME_HEIGHT = 16;

  /**
   * App name line height
   */
  public static readonly APP_NAME_LINE_HEIGHT = 16;

  /**
   * App name size
   */
  public static readonly APP_NAME_SIZE = 12;

  /**
   * App name margin top
   */
  public static readonly APP_NAME_MARGIN_TOP = 4;

  /**
   * Text height
   */
  public static readonly TEXT_HEIGHT = 20;

  /**
   * Text line height
   */
  public static readonly TEXT_LINE_HEIGHT = 22;

  /**
   * Text title font size
   */
  public static readonly TEXT_TITLE_FONT_SIZE = 16;

  /**
   * Text title font size 14
   */
  public static readonly TEXT_TITLE_FONT_SIZE_14 = 14;

  /**
   * Text note font size
   */
  public static readonly TEXT_NOTE_FONT_SIZE = 12;

  /**
   * Emergency button size
   */
  public static readonly BUTTON_SIZE = 40;

  /**
   * Emergency button padding
   */
  public static readonly BUTTON_PADDING = 16;

  /**
   * Resource path of enter edit icon
   */
  public static readonly RESOURCE_PATH_ENTER_EDIT = 'app.media.icon_enter_edit';

  /**
   * Resource path of exit emc icon
   */
  public static readonly RESOURCE_PATH_EXIT_EMC = 'app.media.icon_exit_emc';

  /**
   * Resource path of save edit icon
   */
  public static readonly RESOURCE_PATH_SAVE_EDIT = 'app.media.icon_save_edit';

  /**
   * Resource path of drop edit icon
   */
  public static readonly RESOURCE_PATH_DROP_EDIT = 'app.media.icon_drop_edit';

  /**
   * Resource path of back search icon
   */
  public static readonly RESOURCE_PATH_BACK_SEARCH = 'app.media.icon_back_search';

  /**
   * Max application number
   */
  public static readonly MAX_APP_NUMBER = 6;

  /**
   * Thermal key
   */
  public static readonly THERMAL_KEY = 'ThermalKey';

  /**
   * Emergency key
   */
  public static readonly EMERGENCY_KEY = 'EmergencyKey';

  /**
   * Emergency notify key
   */
  public static readonly EMERGENCY_NOTIFY_KEY = 'EmergencyNotifyKey';

  /**
   * Thermal safe notify key
   */
  public static readonly THERMAL_NOTIFY_KEY = 'ThermalNotifyKey';

  /**
   * settings bundle name
   */
  public static readonly SETTINGS_BUNDLE_NAME:string = 'com.ohos.settings';

  /**
   * settings ablility name
   */
  public static readonly SETTINGS_ABILITY_NAME: string = 'com.ohos.settings.MainAbility';

  /**
   * Text padding of left and right
   */
  public static readonly TEXT_PADDING: number = 24;

  /**
   * emergency model type 1
   */
  public static readonly EMERGENCY_MODEL_TYPE: number = 1;

  /**
   * thermal model type 2
   */
  public static readonly THERMAL_MODEL_TYPE: number = 2;

}

export class UltraScreenConstants {
  /**
   * Grid number between icon of F
   */
  public static readonly GRID_NUMBER_BETWEEN_ICON_F = 2;

  /**
   * Gutter number between icon of F
   */
  public static readonly GUTTER_NUMBER_BETWEEN_ICON_F = 1;

  /**
   * Grid number of F
   */
  public static readonly GRID_NUMBER_F = 4;

  /**
   * Grid margin of F
   */
  public static readonly GRID_MARGIN_F = 16;

  /**
   * Emergency common padding F
   */
  public static readonly COMMON_PADDING_F = 16;

  /**
   * Grid number between icon of M
   */
  public static readonly GRID_NUMBER_BETWEEN_ICON_M = 4;

  /**
   * Gutter number between icon of M
   */
  public static readonly GUTTER_NUMBER_BETWEEN_ICON_M = 3;

  /**
   * Grid number of M
   */
  public static readonly GRID_NUMBER_M = 8;

  /**
   * Grid margin of M
   */
  public static readonly GRID_MARGIN_M = 24;

  /**
   * Emergency common padding M
   */
  public static readonly COMMON_PADDING_M = 24;

  /**
   * Grid number between icon of G
   */
  public static readonly GRID_NUMBER_BETWEEN_ICON_G = 4;

  /**
   * Gutter number between icon of G
   */
  public static readonly GUTTER_NUMBER_BETWEEN_ICON_G = 5;

  /**
   * Grid number of G
   */
  public static readonly GRID_NUMBER_G = 12;

  /**
   * Grid margin of G
   */
  public static readonly GRID_MARGIN_G = 32;

  /**
   * Emergency common padding G
   */
  public static readonly COMMON_PADDING_G = 32;

  /**
   * App item grid gutter y
   */
  public static readonly APP_GRID_GUTTER_Y = 32;

  /**
   * App item width of folder in ULTRA SCREEN
   */
  public static readonly APP_WIDTH = 52;

  /**
   * App item height of folder in ULTRA SCREEN
   */
  public static readonly APP_HEIGHT = 72;

}

export class AppSearchUltraScreenConstants {
  /**
   * Emergency col num F
   */
  public static readonly COLNUM_F = 4;

  /**
   * Emergency row gap F
   */
  public static readonly ROWGAP_F = 16;

  /**
   * Emergency common padding F
   */
  public static readonly GRID_PADDING_F = 26;

  /**
   * Emergency col num M
   */
  public static readonly COLNUM_M = 8;

  /**
   * Emergency row gap M
   */
  public static readonly ROWGAP_M = 16;

  /**
   * Emergency common padding M
   */
  public static readonly GRID_PADDING_M = 34;

  /**
   * Emergency col num G
   */
  public static readonly COLNUM_G = 11;

  /**
   * Emergency row gap G
   */
  public static readonly ROWGAP_G = 16;

  /**
   * Emergency common padding G
   */
  public static readonly GRID_PADDING_G = 42;
}

export class AppSearchConstants {
  /**
   * Emergency col num expanded
   */
  public static readonly COLNUM_EXPANDED = 7;

  /**
   * Emergency col gap expanded
   */
  public static readonly COLGAP_EXPANDED = 37;

  /**
   * Emergency row gap expanded
   */
  public static readonly ROWGAP_EXPANDED = 16;

  /**
   * Emergency common padding expanded
   */
  public static readonly COMMON_PADDING_EXPANDED = 24;

  /**
   * Emergency grid padding expanded
   */
  public static readonly GRID_PADDING_EXPANDED = 34;

  /**
   * Emergency col num folded
   */
  public static readonly COLNUM_FOLDED = 4;

  /**
   * Emergency col gap folded
   */
  public static readonly COLGAP_FOLDED = 28;

  /**
   * Emergency row gap folded
   */
  public static readonly ROWGAP_FOLDED = 16;

  /**
   * Emergency common padding folded
   */
  public static readonly COMMON_PADDING_FOLDED = 16;

  /**
   * Emergency common padding folded
   */
  public static readonly GRID_PADDING_FOLDED = 26;
}

export class DialogConstants {
  public static readonly DIALOG_OFFSET_Y = -16;

  public static readonly DIALOG_PADDING = 24;

  public static readonly MARGIN_TOP_OF_TITLE = 24;

  public static readonly MARGIN_BOTTOM_OF_TITLE = 12;

  public static readonly MARGIN_TOP_OF_TITLE_EXIT = 17;

  public static readonly GAP_BETWEEN_RADIO = 12;

  public static readonly MARGIN_TOP_OF_KNOW = 29;

  public static readonly MARGIN_BOTTOM_OF_KNOW = 26;

  public static readonly MARGIN_BOTTOM_OF_BUTTON_EXIT = 26;

  public static readonly BACKGROUND_COLOR = '#E61A1A1A';

  public static readonly BORDER_RADIUS = 32;

  public static readonly BLUR = 20;

  public static readonly SATURATE = 0.5;

  public static readonly ENTER_TITLE_FONT_SIZE = 16;

  public static readonly ENTER_REMIND_FONT_SIZE = 14;

  public static readonly ENTER_TITLE_LINE_HEIGHT = 26;

  public static readonly ENTER_CONTENT_LINE_HEIGHT = 21;

  public static readonly ENTER_REMIND_LINE_HEIGHT = 19;

  public static readonly RADIO_ICON_SIZE = 20;

  public static readonly RESOURCE_PATH_RADIO_SELECT = 'app.media.icon_radio_select';

  public static readonly RESOURCE_PATH_RADIO_ENABLED = 'app.media.icon_radio_enabled';

  public static readonly DIALOG_TITLE_OF_EMC = 'app.string.Emergency_title_dialog_enter';

  public static readonly DIALOG_TITLE_OF_THERMAL = 'app.string.Thermal_safe_dialog_title_enter';

  public static readonly DIALOG_TITLE_OF_EXIT_EMC_CHARGE = 'app.string.Emergency_dialog_title_exit';

  public static readonly DIALOG_TITLE_OF_EXIT_EMC_SHUTDOWN = 'app.string.Emergency_shutdown_dialog_title_exit';

  public static readonly DIALOG_BUTTON_EXIT = 'app.string.Emergency_button_exit';

  public static readonly DIALOG_BUTTON_CANCEL = 'app.string.Emergency_button_cancel';

  public static readonly DIALOG_BUTTON_DETERMINED = 'app.string.Emergency_button_determined';

  public static readonly EMERGENCY_ENTER_DIALOG_TITLE = 'app.string.emergency_enter_dialog_title';

  public static readonly EMERGENCY_ENTER_DIALOG_CONTENT = 'app.string.emergency_enter_dialog_content';

  public static readonly EMERGENCY_EXIT_WITHOUT_CHARGE_DIALOG_CONTENT = 'app.string.emergency_exit_without_charge_dialog_content';

  public static readonly EMERGENCY_EXIT_WITH_CHARGE_DIALOG_CONTENT = 'app.string.emergency_exit_with_charge_dialog_content';

  public static readonly THERMAL_SAFE_ENTER_DIALOG_DIALOG_TITLE = 'app.string.thermal_safe_enter_dialog_dialog_title';

  public static readonly THERMAL_SAFE_ENTER_DIALOG_DIALOG_CONTENT = 'app.string.thermal_safe_enter_dialog_dialog_content';

  public static readonly DIALOG_MARIN = 32;

  public static readonly DIALOG_MAX_WIDTH = 400;

  public static readonly DIALOG_TITLE_FONT_SIZE = 20;

  public static readonly TITLE_HEIGHT = 56;

  public static readonly BUTTON_TOTAL_HEIGHT = 56;

  public static readonly BUTTON_TOTAL_MARGIN_TOP = 8;

  /**
   * 竖线width 2px
   */
  public static readonly DIALOG_BLANK_WIDTH = px2vp(2);

  public static readonly DIALOG_BLANK_MARGIN = 8;

  public static readonly DIALOG_BUTTON_HEIGHT = 40;

  public static readonly DIALOG_BLANK_HEIGHT = 24;

  public static readonly DIALOG_RADIUS = 32;

  public static readonly DIALOG_BACKGROUND_BLUR = 40;
}