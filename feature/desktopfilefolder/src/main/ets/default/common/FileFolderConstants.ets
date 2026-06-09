/**
 * Copyright (c) 2023-Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

export class FileFolderConstants {
  public static readonly FILE_NAME_MAX_LENGTH = 128;
  public static readonly TYPE_FOLDER = 14;
  public static readonly TYPE_FILE = 1;
  public static readonly TYPE_IMAGE = 2;
  public static readonly DOCUMENT_TYPE = ['PPS', 'PPT', 'PPTX', 'POT', 'POTX', 'PPSX', 'ODP', 'PPTM', 'DOCX', 'DOC', 'DOCM',
    'DOTM', 'RTF', 'WPS', 'DOTX', 'DOT', 'MD', 'MOBI', 'LTX', 'LST', 'ODT', 'OTT', 'TEX', 'TXT', 'TEXT', 'XLS', 'XLSX',
    'XLT', 'XLTX', 'CSV', 'ODS', 'XLSM', 'PDF'];
  public static readonly VIDEO_TYPE = ['F4V', 'DIVX', 'TS', 'RV', '3GP', 'RM', 'MPE', 'WMV', '3G2', 'M2TS', 'FLV', 'AVI',
    'ASX', 'ASF', '3GPP', 'WEBM', 'MKV', 'MPG4', 'MP4', 'MOV', 'M4V', 'M4U', 'RMVB', '3GPP2', 'MPG', 'MPEG'];
  /**
   * PC文管视图区
   */
  public static readonly FROM_FILE_VIEW = 'fromFileView';
  /**
   * PC 文管侧边栏 普通文件夹
   */
  public static readonly FROM_USER_SIDEBAR = 'fromUserSidebar';
  /**
   * 手机文管
   */
  public static readonly PHONE_FILE = 'phoneFile';
  /**
   * 起拖设备SN号
   */
  public static readonly DRAG_FROM_DEVICE_SN = 'drag_from_device';
  /**
   * 拖拽元素类型
   */
  public static readonly DRAG_DATA_TYPE = 'drag_data_type';
}

export enum SelectStatus {
  UNSELECT = 0,
  SELECT = 1,
  RENAME = 2
}

export class ExtraData {
  public isFileCover: boolean = false;
  public isCtrlKeyDown: boolean = false;
  public isAltKeyDown: boolean = false;
  public isShiftKeyDown: boolean = false;
  public column: number = 0;
  public row: number = 0;
  public page: number = 0;
}

export enum FileEventStatus {
  ABORT = -1,
  START = 0,
  COMPLETED = 1,
  RUNNING = 2,
  CANCEL = 3
}

/**
 * 文件文件夹菜单常量
 */
export class MenuConstants {
  public static readonly MENU_ITEM_HEIGHT: number = 40;
  public static readonly MENU_ITEM_MIN_WIDTH: number = 160;
  public static readonly PADDING_ARROW_RIGHT: number = 12;
  public static readonly PADDING_ARROW_LEFT: number = 11;
  public static readonly CLICK_DELAY: number = 300;
  public static readonly DEFAULT_MENU_ITEM_SIDE_PADDING: number = 17;
  public static readonly DEFAULT_FONT_SIZE: number = 16;
  public static readonly FILE_MENU_MORE_INDEX: string = '35';
  public static readonly SMART_FOLDER_MENU_INDEX: string = '47';
  public static readonly COMPRESS_FILE_INDEX: string = '39';
  public static readonly OPEN_MORE_MENU_INDEX: string = '14';
  public static readonly GRANT_NETWORK_SHARING_PERMISSION_INDEX: string = '52';
  public static readonly GRANT_PERMISSION_TO_SPECIFIC_USERS_INDEX: string = '53';
  public static readonly DELETE_NETWORK_SHARING_ACCESS_INDEX: string = '54';
  public static readonly SEPARATOR_COLOR: ResourceColor = $r('sys.color.ohos_id_color_list_separator');
  /**
   * key 一级菜单
   * value 二级菜单列表
   */
  public static readonly MENU_LEVEL_INDEX_CONFIG: Map<string, string[]> = new Map([
    [MenuConstants.FILE_MENU_MORE_INDEX, []],
    [MenuConstants.SMART_FOLDER_MENU_INDEX, []],
    [MenuConstants.COMPRESS_FILE_INDEX, []],
    [MenuConstants.OPEN_MORE_MENU_INDEX, []],
    [MenuConstants.GRANT_NETWORK_SHARING_PERMISSION_INDEX, [MenuConstants.GRANT_PERMISSION_TO_SPECIFIC_USERS_INDEX,
      MenuConstants.DELETE_NETWORK_SHARING_ACCESS_INDEX]
    ]
  ]);
}