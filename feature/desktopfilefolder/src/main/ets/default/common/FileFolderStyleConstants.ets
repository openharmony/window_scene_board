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
 * 文件文件夹UI相关常量
 */
export class FileFolderStyleConstants {
  public static readonly TEXT_FONT_COLOR = '#FFFFFFFF';
  public static readonly GRID_VIDEO_THUMBNAIL_PLAY_CIRCLE_SIZE = 24;

  /**
   * long press Time to show menu
   */
  public static readonly LONG_PRESS_MENU_SHOW_TIME = 500;

  /**
   * 重命名输入框可显示的最小高度
   */
  public static readonly TEXTAREA_MIN_HEIGHT = 22;

  /**
   * 重命名输入框可显示的最小宽度
   */
  public static readonly TEXTAREA_MIN_WIDTH = 16;

  /**
   * 重命名输入框可显示的最大高度距离dock 8vp
   */
  public static readonly TEXTAREA_DISTANCE_TO_DOCK = 8;

  /**
   * 文件文件夹文本输入框 padding
   */
  public static readonly TEXTAREA_PADDING: Padding = {
    top: 2,
    bottom: 2,
    right: 2,
    left: 2
  }

  /**
   * 文件文件夹文本输入框 边框宽度
   */
  public static readonly TEXTAREA_BORDER_WIDTH = 2;

  /**
   * 文件文件夹文本输入框 字体粗细
   */
  public static readonly TEXTAREA_FONT_WEIGHT = FontWeight.Medium;
}