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

import resourceManager from '@ohos.resourceManager';
import { BusinessError } from '@ohos.base';
import { LogDomain, Logger, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'DesktopAddDialogConstant';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

export default class DesktopAddDialogConstant {
  /**
   * Dialog最大高度占屏幕的百分比
   */
  public static readonly DIALOG_HEIGHT_PERCENT = 0.7;

  /**
   * 标题高度
   */
  public static readonly DIALOG_TITLE_HEIGHT = 56;

  /**
   * 标题最大行数
   */
  public static readonly DIALOG_TITLE_MAX_LINES = 2;

  /**
   * 分栏的高度
   */
  public static readonly SUB_HEADING_HEIGHT = 19;

  /**
   * “其他应用”的margin
   */
  public static readonly SUB_OTHERS_MARGIN = 8;

  /**
   * Grid行间距
   */
  public static readonly GRID_ROW_GAP = 22;

  /**
   * “已有应用”的margin
   */
  public static readonly GRID_MARGIN_TOP = 2;

  /**
   * Grid底部margin
   */
  public static readonly GRID_MARGIN_BOTTOM = 8;

  /**
   * Checkbox大小
   */
  public static readonly CHECKBOX_SIZE = 24;

  /**
   * Checkbox间距
   */
  public static readonly CHECKBOX_MARGIN = 6;

  /**
   * Checkbox内间距
   */
  public static readonly CHECKBOX_PADDING = 2;

  /**
   * 数据类型：已有应用，用于Dialog中进行数据分栏
   */
  public static readonly ITEM_TYPE_CONTAINS = 'type_add_contains';

  /**
   * 数据类型：其他应用，用于Dialog中进行数据分栏
   */
  public static readonly ITEM_TYPE_OTHERS = 'type_add_others';

  public static readonly DEFAULT_ZERO = 0;

  /**
   * 文件夹反选后事件通知
   */
  public static readonly EVENT_FOLDER_REFRESH_DIALOG = 'event.folder.refresh_add_dialog';

  public static readonly BUTTON_SPACE = 12;

  public static readonly GRID_ITEM_PADDING_BOTTOM = '16vp';

  public static readonly GRID_ITEM_DEFAULT_PADDING_BOTTOM = '2vp';

  public static readonly GRID_ITEM_PADDING_TOP = '6vp';

  public static readonly GRID_TITLE_PADDING_BOTTOM = '8vp';

  public static readonly GRID_SUBTITLE_PADDING_BOTTOM = '9vp';

  public static readonly TITLE_PADDING_TOP = '22vp';

  public static readonly TITLE_PADDING_BOTTOM = '2vp';

  public static readonly OTHER_TITLE_PADDING_TOP = '12vp';

  public static readonly COLUMN_MARGIN_BOTTOM = '-8vp';

  public static readonly BUTTON_MARGIN = 16;

  public static readonly MAX_FONT_SCALE: number = 2;

  public static readonly BUTTON_MIN_FONT_SIZE = 9;

  public static readonly BODY_L = getNumberByResource($r('sys.float.Body_L'), 16);

  public static readonly TITLE_S = getNumberByResource($r('sys.float.Title_S'), 20);

  public static readonly SUBTITLE_L = getNumberByResource($r('sys.float.Subtitle_L'), 18);

  public static readonly SUBTITLE_S = getNumberByResource($r('sys.float.Subtitle_S'), 14);

  public static readonly FONT_FAMILY_ohos: string = 'HarmonyHeiTi';

  public static readonly DEFAULT_ZERO_VP = '0vp';

  public static readonly DEFAULT_SUBTITLE_TOP_PADDING = '2vp';

  public static readonly DEFAULT_BUTTON_HEIGHT = '40vp';

  public static readonly NAVI_BAR_HEIGHT = DeviceHelper.isPad() || DeviceHelper.isFold() ? '0vp' : '28vp';

  public static readonly DEFAULT_BUTTON_PADDING = '8vp';

  public static readonly DESKTOP_ITEMS_LIMIT_TOAST = 'app.string.desktop_items_limit_toast';

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

  /**
   * 图标组件使用属性
   */
  public static readonly DESKTOP_ADD_ICON_NAME_WIDTH = 48;
  public static readonly DESKTOP_ADD_ICON_NAME_HEIGHT = 16;
  public static readonly DESKTOP_ADD_ICON_NAME_MARGIN_TOP = 4;
}

/**
 * get resource size
 *
 * @param resource resource
 * @param defaultValue default value
 * @returns resource size
 */
function getNumberByResource(resource: Resource, defaultValue: number): number {
  try {
    let sourceValue: number = resourceManager.getSystemResourceManager().getNumber(resource);
    if (sourceValue > 0) {
      return sourceValue;
    }
  } catch (error) {
    let code: number = (error as BusinessError).code;
    let message: string = (error as BusinessError).message;
    log.showError(TAG, `getNumberByResource error, code: ${code}, message: ${message}`);
  }
  return defaultValue;
}