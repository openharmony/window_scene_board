/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
 * 小文件夹样式默认值
 */
export class SmallFolderConstants {
  /**
   * default app width in small folder
   */
  public static readonly DEFAULT_APP_ICON_WIDTH: number = 12.6;

  /**
   * default app height in small folder
   */
  public static readonly DEFAULT_APP_ICON_HEIGHT: number = 12.6;

  /**
   * default animate interval
   */
  public static readonly SMALL_FOLDR_ANIMATE_INTERVAL: number = 16.67;

  /**
   * default small folder width
   */
  public static readonly DEFAULT_FOLDER_WIDTH: number = 64;

  /**
   * default small folder height
   */
  public static readonly DEFAULT_FOLDER_HEIGHT: number = 64;

  /**
   * default small folder padding
   */
  public static readonly DEFAULT_FOLDER_GRID_PADDING: number = 7.2;

  /**
   * default small folder gap
   */
  public static readonly DEFAULT_FOLDER_GRID_GAP: number = 2.7;

  /**
   * 100% percent
   */
  public static readonly PERCENTAGE_100: string = '100%';

  /**
   * 小文件夹内占位图标
   */
  public static readonly PLACEHOLDER_IN_SMALL_FOLDER_GRID: string = 'place_holder';
  /**
   * small folder show app icon length
   */
  public static readonly DEFAULT_FOLDER_SHOW_LENGTH: number = 9;

  /**
   * small folder middle app icon index
   */
  public static readonly DEFAULT_FOLDER_MIDDLE_INDEX: number = 4;


  /**
   * small folder page app length
   */
  public static readonly DEFAULT_FOLDER_PAGE_LENGTH: number = 12;

  /**
   * default small folder icon radius
   */
  public static readonly DEFAULT_SMALL_FOLDER_RADIUS: number = 10;

  /**
   * default small folder radius
   */
  public static readonly DEFAULT_FOLDER_RADIUS = 16;

  /**
   * 3 * 4 段落式展开矩阵, 不同的数字对应不同的层次
   */
  public static readonly FOLDER_EXPANSION_MATRIX_3x4: number[][] = [
    [5, 4, 3, 4, 3, 2, 3, 2, 1, 2, 1, 1],
    [3, 4, 5, 2, 3, 4, 1, 2, 3, 1, 1, 2],
    [3, 2, 1, 4, 3, 2, 5, 4, 3, 6, 5, 4],
    [1, 2, 3, 2, 3, 4, 3, 4, 5, 4, 5, 6],
  ];

  /**
   * 4 * 4 段落式展开矩阵, 不同的数字对应不同的层次
   */
  public static readonly FOLDER_EXPANSION_MATRIX_4x4: number[][] = [
    [6, 6, 5, 4, 6, 5, 4, 3, 5, 4, 3, 2, 4, 3, 2, 1],
    [4, 5, 6, 6, 2, 4, 5, 6, 2, 3, 4, 5, 1, 2, 3, 4],
    [4, 3, 2, 1, 5, 4, 3, 2, 6, 5, 4, 3, 6, 6, 4, 3],
    [1, 2, 3, 4, 2, 3, 4, 5, 3, 4, 5, 6, 4, 5, 6, 6],
  ];

  /**
   * 4 * 4 小文件夹图标占位矩阵, 0: 填充占位图标 1: 使用原图标
   */
  public static readonly FOlDER_EXPANSION_PLACEHOLDER_MATRIX: number[][] = [
    [0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1],
    [0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0],
    [0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1],
    [1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0],
  ];

  /**
   * 3 * 4 小文件夹图标显示矩阵, 0: 表示正常显示
   */
  public static readonly FOlDER_SHOW_MATRIX_3x4: number[] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1];

  /**
   * 4 * 4 小文件夹图标显示矩阵, 0: 表示正常显示, 1: 表示隐藏图标
   */
  public static readonly FOlDER_SHOW_MATRIX_4x4: number[][] = [
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0],
  ];

  /**
   * SmallFolder Icon Effect Duration
   */
  public static readonly ICON_EFFECT_DURATION: number = 450;

  /**
   * 深色模式colorMode：0
   */
  public static readonly DARK_COLOR_MODE: number = 0;

  /**
   *  浅色模式colorMode：1
   */
  public static readonly LIGHT_COLOR_MODE: number = 1;

  /**
   * 角标相对于小文件夹图标右上角的x轴偏移
   */
  public static readonly CUSTOM_BADGE_X_OFFSET_TIMES = 3;

  /**
   * 角标相对于文件夹图标右上角的y轴偏移
   */
  public static readonly CUSTOM_BADGE_Y_OFFSET = 0;
}