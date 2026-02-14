/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

export default class WallpaperConstants {

  /**
   * 壁纸类型一，极浅壁纸
   */
  static readonly WALLPAPER_TYPE_ONE = 1;

  /**
   * 壁纸类型二，浅色壁纸
   */
  static readonly WALLPAPER_TYPE_TWO = 2;

  /**
   * 壁纸类型三，深色壁纸
   */
  static readonly WALLPAPER_TYPE_THREE = 3;

  /**
   * 壁纸类型四，极深壁纸
   */
  static readonly WALLPAPER_TYPE_FOUR = 4;

  /**
   * 壁纸类型五，普通花壁纸
   */
  static readonly WALLPAPER_TYPE_FIVE = 5;

  /**
   * 壁纸类型六，极花壁纸
   */
  static readonly WALLPAPER_TYPE_SIX = 6;

  /**
   * 黑色
   */
  static readonly COLOR_BLACK_STRING = '#000000';

  /**
   * 白色
   */
  static readonly COLOR_WHITE_STRING = '#ffffff';

  /**
   * 壁纸蒙黑-无
   */
  static readonly NO_WALLPAPER_COVER_COLOR = '#00000000';

  /**
   * 壁纸蒙黑-5%
   */
  static readonly WALLPAPER_COVER_5 = '#0d000000';

  /**
   * 壁纸蒙黑-15%
   */
  static readonly WALLPAPER_COVER_15 = '#1a000000';

  /**
   * 壁纸蒙黑-3%
   */
  static readonly WALLPAPER_COVER_3 = '#08000000';

  /**
   * 0
   */
  static readonly NUMBER_0 = 0;

  /**
   * 16
   */
  static readonly NUMBER_16 = 16;

  /**
   * 20
   */
  static readonly NUMBER_20 = 20;

  /**
   * 255
   */
  static readonly NUMBER_255 = 255;

  /**
   * 颜色前缀
   */
  static readonly COLOR_PREFIX = '#';

  /**
   * 不透明度40%
   */
  static readonly ALPHA_40 = '66';

  /**
   * 不透明度80%
   */
  static readonly ALPHA_80 = 'cc';

  /**
   * 不透明度100%
   */
  static readonly ALPHA_0 = 'ff';

  /**
   * 跟随壁纸Swiper导航点颜色 type2-6
   */
  static readonly SWIPER_WHITE_COLOR = '#66ffffff';

  /**
   * 跟随壁纸Swiper导航点选中颜色 type2-6
   */
  static readonly SWIPER_WHITE_COLOR_SELECTED = '#ffffffff';

  /**
   * 跟随壁纸Swiper导航点颜色 type1
   */
  static readonly SWIPER_BLACK_COLOR = '#33000000';

  /**
   * 跟随壁纸Swiper导航点选中颜色 type1
   */
  static readonly SWIPER_BLACK_COLOR_SELECTED = '#ff3c3c3c';

  /**
   * opacity 3%
   */
  static readonly ALPHA_3 = '08';

  /**
   * 不透明度10%
   */
  static readonly ALPHA_10 = '1A';

  /**
   * 2
   */
  static readonly NUMBER_2 = 2;

  /**
   * '0'
   */
  static readonly PREFIX_0 = '0';

  /**
   * 不需要桌面文字投影的壁纸类型
   */
  static readonly WALLPAPER_TYPE_NO_NEED_TXT_SHADOW = [WallpaperConstants.WALLPAPER_TYPE_ONE,
    WallpaperConstants.WALLPAPER_TYPE_FOUR];

  /**
   * 桌面壁纸为深色
   */
  static readonly WALLPAPER_TYPE_DARK = [WallpaperConstants.WALLPAPER_TYPE_THREE,
    WallpaperConstants.WALLPAPER_TYPE_FOUR];
}