/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'FolderAddDialogConstant';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default class FolderAddDialogConstant {
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

  public static readonly AI_BAR_HEIGHT = '28vp';

  public static readonly DEFAULT_BUTTON_PADDING = '8vp';
}

/**
 * 弹出推荐弹框的参数类
 */
export class FolderAddEventParams {
  // 打开文件夹推荐弹框类型
  public openedBy: string;
  // 文件夹id
  public folderId: string;

  public constructor(openedBy: string, folderId: string) {
    this.openedBy = openedBy;
    this.folderId = folderId;
  }
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
    } else {
      return defaultValue;
    }
  } catch (error) {
    let code: number = (error as BusinessError).code;
    let message: string = (error as BusinessError).message;
    log.showError(`getNumberByResource error, code: ${code}, message: ${message}`);
    return defaultValue;
  }
}