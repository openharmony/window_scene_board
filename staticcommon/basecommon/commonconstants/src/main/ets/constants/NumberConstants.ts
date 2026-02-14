/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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
 * NumberConstants
 */
export class NumberConstants {
  /**
   * Constant Number 0
   */
  static readonly CONSTANT_NUMBER_ZERO = 0;

  /**
   * Constant Number 0.13
   */
  static readonly CONSTANT_NUMBER_ZERO_POINT_ONE_THREE = 0.13;

  /**
   * Constant Number 0.2
   */
  static readonly CONSTANT_NUMBER_ZERO_POINT_TWO = 0.2;
  /**
   * Constant Number 1.15
   */
  static readonly CONSTANT_ZOOM_IN = 1.15;

  /**
   * Constant Number 1.5
   */
  static readonly CONSTANT_ADAPTIVE_SCALE = 1.5;

  /**
   * Constant Number 1
   */
  static readonly CONSTANT_NUMBER_ONE = 1;


  /**
   * Constant Number 2
   */
  static readonly CONSTANT_NUMBER_TWO = 2;

  /**
   * Constant Number 4
   */
  static readonly CONSTANT_NUMBER_FOUR = 4;

  /**
   * Constant Number 7
   */
  static readonly CONSTANT_NUMBER_SEVEN = 7;

  /**
   * Constant Number 8
   */
  static readonly CONSTANT_NUMBER_EIGHT = 8;

  /**
   * Constant Number 3
   */
  static readonly CONSTANT_NUMBER_THREE = 3;

  /**
   * Constant Number 5
   */
  static readonly CONSTANT_NUMBER_FIVE = 5;

  /**
   * Constant Number 5
   */
  static readonly CONSTANT_NUMBER_SIX = 6;

  /**
   * Constant Number 9
   */
  static readonly CONSTANT_NUMBER_NINE = 9;

  /**
   * Constant Number 9
   */
  static readonly CONSTANT_NUMBER_TEN = 10;
  /**
   * Constant Number 9
   */
  static readonly CONSTANT_NUMBER_TWELVE = 12;

  /**
   * Constant Number 15
   */
  static readonly LEFT_UP_REGION_LAST_INDEX = 15;

  /**
   * Constant Number 14
   */
  static readonly RIGHT_UP_REGION_LAST_INDEX = 14;

  /**
   * Constant Number 11
   */
  static readonly LEFT_DOWN_REGION_LAST_INDEX = 11;

  /**
   * Constant Number 10
   */
  static readonly RIGHT_DOWN_REGION_LAST_INDEX = 10;
  /**
   * Constant Number 24
   */
  static readonly CONSTANT_NUMBER_HOUR_TWENTY_FOUR = 24;

  /**
   * Constant Number 60
   */
  static readonly CONSTANT_NUMBER_SIXTY = 60;

  /**
   * Constant Number 100
   */
  static readonly CONSTANT_NUMBER_100 = 100;

  /**
   * Constant Number 150
   */
  static readonly CONSTANT_NUMBER_150 = 150;

  /**
   * Constant Number 250
   */
  static readonly CONSTANT_NUMBER_250 = 250;

  /**
   * 长按200ms，文件夹开始做隐藏角标动效
   */
  static readonly LONG_PRESS_HIDE_BADGE_FOLDER = 200;

  /**
   * 长按350ms，开始做隐藏角标动效
   */
  static readonly LONG_PRESS_HIDE_BADGE = 350;

  /**
   * Constant Number 400
   */
  static readonly CONSTANT_NUMBER_400 = 400;

  /**
   * Constant Number 500
   */
  static readonly CONSTANT_NUMBER_FIVE_HUNDRED = 500;

  /**
   * Constant Number 550
   */
  static readonly CONSTANT_NUMBER_550 = 550;

  /**
   * Time to trigger long press zoom in
   */
  static readonly LONG_PRESS_ZOOM_IN = 550;

  /**
   * 有菜单的桌面元素按压缩小后长按开始放大的时间
   */
  static readonly LONG_PRESS_ZOOM_IN_WITH_MENU = 250;

  /**
   * Time to trigger long press vibration
   */
  static readonly LONG_PRESS_VIBRATOR_TIME = 500;

  /**
   * long press Time to show menu
   */
  static readonly LONG_PRESS_MENU_SHOW_TIME = 500;

  /**
   * Constant Number 1000
   */
  static readonly CONSTANT_NUMBER_ONE_THOUSAND = 1000;

  /**
   * Constant Number 2000
   */
  static readonly CONSTANT_NUMBER_TWO_THOUSAND = 2000;

  /**
   * Constant Number 3000
   */
  static readonly CONSTANT_NUMBER_THREE_THOUSAND = 3000;

  /**
   * OPEN_FOLDER_SWIPER_BORDER_WIDTH 1
   */
  static readonly OPEN_FOLDER_SWIPER_BORDER_WIDTH = 1;

  /**
   * this limit  rdb error need retry times
   */
  static readonly RDB_ERROR_RETRY_TIMES_LIMIT = 3;

  /**
   * this is rdb error wait milliseconds to retry
   */
  static readonly RDB_ERROR_RETRY_WAIT_MILLISECONDS = 300;

  /**
   * Constant Number 1000
   */
  static readonly CONSTANT_DAY_TIME_MILLIS = NumberConstants.CONSTANT_NUMBER_HOUR_TWENTY_FOUR *
    NumberConstants.CONSTANT_NUMBER_SIXTY * NumberConstants.CONSTANT_NUMBER_SIXTY *
    NumberConstants.CONSTANT_NUMBER_ONE_THOUSAND;

  /**
   * OpenHarmony键相关常量
   */
  static readonly HOSKEY_WIDTH = 640;
  static readonly HOSKEY_BOTTOM_SPACE = 8;
  static readonly HOSKEY_HEIGHT = 792;
  static readonly DEFAULT_0 = 0;
}
