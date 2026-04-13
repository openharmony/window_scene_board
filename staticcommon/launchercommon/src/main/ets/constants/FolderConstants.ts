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
 * 文件夹相关常量类
 */
export class FolderConstants {
  /**
   * 文件夹展开态grid padding top
   */
  public static readonly BORDER_PADDING_TOP = 6;

  /**
   * 文件夹展开态grid padding bottom
   */
  public static readonly BORDER_PADDING_BOTTOM = 15;

  /**
   * 小文件夹折叠态首页最大显示图标数
   */
  public static readonly MAX_ICON_LENGTH_IN_SMALL_FOLDER = 9;

  /**
   * 拖拽创建文件夹时默认文件夹内自带的图标数
   */
  public static readonly DEFAULT_APP_LENGTH_WHEN_CREATE_FOLDER = 1;

  /**
   * 编辑模式下文件夹额外背板在极浅壁纸下的压暗后亮度
   */
  public static readonly FOLDER_EXTRA_BACKGROUND_LIGHT_UNDER_WHITE_WALL_PAPER = 0.95;

  /**
   * 编辑模式下文件夹额外背板默认亮度
   */
  public static readonly FOLDER_EXTRA_BACKGROUND_DEFAULT_LIGHT = 1;

  /**
   * 展开态3*4布局时每页图标个数
   */
  public static readonly NUM_3X4_OPEN_FOLDER_ICON_PRE_PAGE = 12;

  /**
   * 展开态4*4布局时每页图标个数
   */
  public static readonly NUM_4X4_OPEN_FOLDER_ICON_PRE_PAGE = 16;

  /**
   * 拖拽元素被移出当前布局事件头
   */
  public static readonly OPEN_FOLDER_ITEM_BADGE_CHANGE: string = 'OpenFolderItemBadgeChange_';

  /**
   * 文件夹展开态补位动效元素角标在文件夹打开关闭动效完成时变化的事件头
   */
  public static readonly OPEN_CLOSE_FOLDER_ITEM_BADGE_CHANGE: string = 'OpenCloseFolderItemBadgeChange_';

  /**
   * 文件夹展开态图标圆角更新
   */
  public static readonly OPEN_FOLDER_ICON_RADIUS_CHANGE: string = 'FolderIconRadiusChange';

  /**
   * 文件夹菜单位置判定阈值
   */
  public static readonly FOLDER_MENU_POSITION_THRESHOLD: number = 0.12;
}