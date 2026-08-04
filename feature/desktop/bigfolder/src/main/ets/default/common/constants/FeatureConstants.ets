/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

export default class FeatureConstants {
  public static readonly FEATURE_NAME = 'featureBigFolder';

  /**
   * 文件夹静态状态
   */
  public static readonly OPEN_FOLDER_STATUS_STATIC = -1;

  /**
   * 文件夹关闭状态
   */
  public static readonly OPEN_FOLDER_STATUS_CLOSE = 0;

  /**
   * 文件夹打开状态
   */
  public static readonly OPEN_FOLDER_STATUS_OPEN = 1;

  /**
   * 文件夹刷新状态
   */
  public static readonly OPEN_FOLDER_STATUS_REFRESH = 2;

  /**
   * 文件夹正在打开或关闭动效开始
   */
  public static readonly OPEN_FOLDER_STATUS_TRANSITION_START = 3;

  /**
   * 文件夹正在打开或关闭动效结束
   */
  public static readonly OPEN_FOLDER_STATUS_TRANSITION_END = 4;

  /**
   * 文件夹待关闭
   */
  public static readonly FOLDER_STATUS_PENDING_CLOSE = 5;

  /**
   * 文件夹请求关闭
   */
  public static readonly FOLDER_STATUS_REQUEST_CLOSE = 6;

  /**
   * 文件夹内占位图标
   */
  public static readonly PLACEHOLDER_IN_OPEN_FOLDER_GRID = 'place_holder';

  public static readonly HOVER_BACKGROUND_COLOR = 0x0D0A59F7;
  public static readonly PRESS_BACKGROUND_COLOR = 0x1A0A59F7;
  public static readonly DEFAULT_BACKGROUND_COLOR = 'rgba(0,0,0,0)';
  public static readonly COLUMN_GAP = 8;
  public static readonly ROW_GAP = 8;
  public static readonly BORDER_COLOR = 0x33FFFFFF;
  public static readonly BORDER_WIDTH = 1;
  public static readonly BORDER_RADIUS = 8;
  public static readonly BORDER_PADDING_TOP = 6;
  public static readonly BORDER_PADDING_BOTTOM = 15;
  public static readonly ADD_ICON_MARGIN_TOP = 2;

  /**
   * 文件夹内动效常量
   */
  public static readonly SMALL_FOLDER_REMOVE_APP_DELAY = 1000;
  public static readonly BIG_FOLDER_REMOVE_APP_DELAY = 800;
  public static readonly FOLDER_OPEN_COMPONENT_REMOVE_APP_DELAY = 50;
  public static readonly FOLDER_OPEN_FILL_POSITION_DURATION = 200;
  public static readonly FOLDER_DRAG_LEAVE_DELAY_TIME = 300;
  public static readonly FOLDER_DISSOLVE_LENGTH = 2;

  /**
   * 文件夹展开态常量
   */
  public static readonly GROUP_ONE = 1;
  public static readonly GROUP_TWO = 2;
  public static readonly GROUP_THREE = 3;
  public static readonly GROUP_FOUR = 4;
  public static readonly GROUP_FIVE = 5;
  public static readonly GROUP_SIX = 6;
  public static readonly ANIMATE_INTERVAL = 16.67;
  public static readonly OPEN_FOLDER_ADD_APP_ICON = 'open_folder_add_app_icon';
  public static readonly STATUS_WAIT_ITEM_MOVE_ANIMATION = 'waitFolderMoveAniamtion';
  public static readonly STATUS_NO_WAIT_ITEM_MOVE_ANIMATION = 'no waitFolderMoveAniamtion';
  public static readonly DOUBLE_CLICK_COUNT = 2;
  public static readonly SINGLE_CLICK_COUNT = 1;
  public static readonly OPEN_FOLDER_ANI_PARAM_LENGTH = 3;
  public static readonly OPEN_FOLDER_ADD_ICON_SRC = '/common/pics/ic_public_add.svg';
  public static readonly OPEN_FOLDER_ADD_ICON_BACKGROUND_COLOR = '#33FFFFFF';
  public static readonly OPEN_FOLDER_ADD_ICON_IMAGE_SIZE = '59%';

  public static readonly OPEN_FOLDER_SPRINGBACK_SCROLL_ANI = 'OpenFolderSpringbackScrollAni';
  public static readonly OPEN_FOLDER_OVER_SCROLL_ANI = 'OpenFolderOverScrollAni';
}