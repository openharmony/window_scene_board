/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
  /*
   * 密码失效重置按钮参数
   */
  public static readonly RESET_PIN_TEXT_HEIGHT = 64;
  public static readonly RESET_PIN_TEXT_DARK = '#99000000';
  public static readonly RESET_PIN_TEXT_BRIGHT = '#e6ffffff';

  public static readonly FOLDED_ANGEL: number = 30;

  public static readonly INVALID_USER_ID: number = -1;
  public static readonly SOURCE_TYPE_KEYBOARD: number = 4;
  public static readonly A_HALF: number = 0.5;
  /**
   * 四分之一
   */
  public static QUARTER = 4;
  /**
   * 锁屏元素偏移网格数
   */
  public static NO_OFFSET = 0;
  public static OFFSET_UP_1 = -1;
  public static OFFSET_DOWN_2 = 2;
  /**
   * 锁屏时钟和用户占用的网格数
   */
  public static BASE_GIRD_NUM = 6;
  /**
   * 时钟到状态栏所占用网格数（不包含padding）
   */
  public static CLOCK_TO_STATUSBAR_GIRD_NUM = 3;
  /**
   *状态栏到网格布局(包含16vp padding）
   */
  public static PADDING_AND_STATUS_BAR = 56;
  /**
   * 锁屏横向最大宫格数
   */
  public static HORIZONTAL_GRID_CNT = 12;
  /**
   * Toast
   */
  public static TOAST_LINE_HEIGHT = 19;
  public static TOAST_MAXLINES = 2;
  public static TOAST_FONT_FAMILY = 'HarmonyHeiTi';

  public static PASSWORD_MAX_LEN = 32;
  public static ITEM_WIDTH = '100%';
  public static DEFAULT_COLOR = '#00000000';
  public static BACKGROUND_ITEM_MARGIN = 8;
  public static ITEM_MARGIN = 28;
  public static DEV_MODE_MAX_LOGIN_USR_NUM: number = 1;
  public static UP_AND_LOWER_HEIGHT = 120;
  public static GRID_WIDTH = 106;
  public static GRID_WIDTH_HPR = 110;
  public static TIME_SCALE_HPR = 1.12;
  public static TIME_SCALE_DEFAULT = 1;
  public static ACCOUNTS_MARGIN_TOP_HPR = 72;
  public static ACCOUNTS_MARGIN_TOP = 48;
  public static CLOCK_GRID_COL = 5;
  public static CLOCK_GRID_COL_HPR = 5;
  public static CLOCK_GRID_ROW = 2;
  public static CLOCK_GRID_ROW_HPR = 2;
  public static TIME_DATE_SPACE = 8;
  public static TIME_DATE_SPACE_HPR = 20;
  public static readonly PWD_DEFAULTMARGIN = 0;
  public static readonly VERTICAL_FORGET_PWD_MARGIN = 956;
  public static readonly HORIZONTAL_FORGET_PWD_MARGIN = 0;
  public static readonly VERTICAL_LOST_MODE_MARGIN = 702;
  public static readonly HORIZONTAL_LOST_MODE_MARGIN = 768;

  /**
   * Hopper ScreenLock Layout padding
   */
  public static UF_HORIZONTAL_OFFSET: number = 20;
  public static UF_VERTICAL_OFFSET: number = 10;
  public static UF_HORIZONTAL_PADDING: number = 30;

  /**
   * Power Panel
   */
  public static readonly POWER_PANEL_WIDTH = 180;

  public static readonly POWER_PANEL_ITEM_HEIGHT = 44;

  public static readonly POWER_MENU_ITEM_HEIGHT = 40;
  /**
   * Icon
   */
  public static readonly ICON_SIZE: number = 36;

  public static readonly IMAGE_SIZE: number = 24;

  public static readonly PANEL_MARGIN_LEFT = 12;

  public static readonly PANEL_MARGIN_RIGHT = 12;

  public static readonly STATUS_BAR_HEIGHT = 48;

  public static readonly BLENDMODE_SRC_OVER: number = 1000;
  
  public static readonly BLENDMODE_DESTINATION_IN: number = 6;

  /**
   * UserItem
   */
  public static readonly USER_ITEM_SIZE: number = 80;

  /**
   * Password TextInput
   */
  public static readonly PWD_WIDTH: number = 242;

  public static readonly PWD_HEIGHT: number = 42;

  public static readonly PWD_TO_USERITEM: number = 127;

  /*
    项目初始化时 简体中文值为  zh-Hans  设置应用设置的 简体中文值为 zh-Hans-CN
   */
  public static readonly SYSTEM_LANGUAGE_CHINESE: string = 'zh-Hans';

  public static readonly REQUEST_FOCUS_MENU: string = 'h1_systemUI_product_pc_ScreenLock_PowerMenu_sleep';

  public static readonly IS_SHOULD_UNLOCK: string = 'isShouldUnlock';
  public static readonly CHECK_USER_ID: string = 'checkUserID';

  /**
   * screenLock key
   */
  public static readonly KEY_POWER_KEY = 'h1_systemUI_product_pc_ScreenLock_PowerKey';

  public static readonly KEY_POWER_MENU = 'h1_systemUI_product_pc_ScreenLock_PowerMenu';
  public static readonly KEY_SHIFT_TOGGLE = 'systemUI_pc_ScreenLock_shift_toggle';
  public static readonly KEY_USER_ICON = 'ScreenLock-Accounts_Image_userIcon';

  /**
   * PWD
   */
  public static readonly PC_COMPONENT_ID_PASSWORD = 'screenLock_pc_TextInput_password';

  /**
   * RESET PWD UEC
   */
  public static readonly PC_COMPONENT_ID_RESET_PASSWORD_UEC = 'screenLock_pc_ResetPwd_UIExtensionComponent';

  /**
   * SlideScreenLock
   */
  public static readonly PC_COMPONENT_SLIDE_SCREEN_LOCK = 'slide_screen_lock';

  /**
   * Recover Key
   */
  public static readonly PC_ID_Recovery_Key = 'screenLock_pc_recovery_key';

  /**
   * Old Pwd
   */
  public static readonly PC_ID_OLD_PASSWORD = 'screenLock_pc_old_password';

  /**
   * New Pwd
   */
  public static readonly PC_ID_NEW_PASSWORD = 'screenLock_pc_new_password';

  /**
   * Confrim Pwd
   */
  public static readonly PC_ID_CONFIRM_PASSWORD = 'screenLock_pc_confirm_password';

  /**
   * image detail component id
   */
  public static readonly PC_ID_IMAGE_DETAIL = 'screenLock_pc_Image_detail';

  /**
   * image back component id
   */
  public static readonly PC_ID_IMAGE_BACK = 'screenLock_pc_Image_back';

  /**
   * image confirm component id
   */
  public static readonly PC_ID_IMAGE_NEXT = 'screenLock_pc_Image_next';

  /**
   * How long millisecond is the space long press?
   */
  public static readonly LONG_PRESS_SPACE_DURATION: number = 600;

  /**
   * key board press delay millisecond?
   */
  public static readonly KEY_BOARD_DELAY: number = 200;
  /**
   * When the enterprise space exists, HosKey switches the space.
   */
  public static readonly SPACE_SWITCH = 'spaceSwitch';
  /**
   * When ready to remove personal space.
   */
  public static readonly SPACE_REMOVE = 'spaceRemove';

  public static readonly POWER_HOVER_RADIUS = 4;
  public static readonly POWER_PANEL_RADIUS = 8;
  public static readonly STATUSBAR_INPUT_METHOD_WIDTH = 16.67;
  public static readonly STATUSBAR_INPUT_METHOD_HEIGHT = 16.67;
  public static readonly BACKGROUND_BLUR = 103;
}