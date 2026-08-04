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

import BaseColumns from './BaseColumns';

/**
 * GridLayoutInfo  Columns
 */
export default class DesktopApplicationColumns extends BaseColumns {
  public static readonly APP_NAME: string = 'app_name';
  public static readonly IS_SYSTEM_APP: string = 'is_system_app';
  public static readonly IS_UNINSTALLABLE: string = 'is_uninstallAble';
  public static readonly BADGE_NUMBER: string = 'badge_number';
  public static readonly APPICON_ID: string = 'appIcon_id';
  public static readonly APPLABEL_ID: string = 'appLabel_id';
  public static readonly BUNDLE_NAME: string = 'bundle_name';
  public static readonly MODULE_NAME: string = 'module_name';
  public static readonly ABILITY_NAME: string = 'ability_name';
  public static readonly URI: string = 'uri';
  public static readonly MODE: string = 'mode';
  public static readonly FILE_INO: string = 'file_ino';
  public static readonly FILE_SIZE: string = 'file_size';
  public static readonly FILE_CREATE_TIME: string = 'file_ctime';
  public static readonly FILE_MODIFICATION_TIME: string = 'file_mtime';
  public static readonly FILE_FOLDER_NAME: string = 'file_folder_name';
  public static readonly KEY_NAME: string = 'key_name';
  public static readonly INSTALL_TIME: string = 'install_time';
  public static readonly EXTEND1: string = 'extend1';
  public static readonly EXTEND2: string = 'extend2';
  public static readonly EXTEND3: string = 'extend3';
  public static readonly DOWNLOAD_PROGRESS: string = 'download_progress';
  public static readonly APP_STATUS: string = 'app_status';
  public static readonly ICON_RESOURCE: string = 'icon_resource';
  public static readonly CALLER_NAME: string = 'caller_name';
  public static readonly APP_INDEX: string = 'app_index';
  public static readonly INTENT: string = 'intent';
}