/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

export class OneHandDialogConstants {
  public static readonly TABLE_NAME: string = 'one_hand_dialog_table';
  public static readonly ID: string = 'id';
  public static readonly BUNDLE_NAME: string = 'bundleName';
  public static readonly POPUP_COUNT: string = 'popupCount';
  public static readonly EXTEND_ID: string = 'extendId';
  public static readonly CREATE_TABLE: string = 'CREATE TABLE IF NOT EXISTS one_hand_dialog_table (' +
    'id INTEGER PRIMARY KEY AUTOINCREMENT, bundleName TEXT, popupCount INTEGER, extendId TEXT)';

  public static readonly TIP_FUN_NUM: string = 'SF-10044746_f102';
  public static readonly TIP_FUN_TYPE: string = '133';
  public static readonly LOTTIE_NAME: string = 'OneHandModeDialog-LottieName';
  public static readonly LOTTIE_PKG_NAME: string = 'OneHandModeDialog-LottiePackageName';
  public static readonly LOTTIE_DATA_PATH: string = '/sys_prod/etc/launcher/single_hand_guide.json';
  public static readonly CONFIG_PATH: string = '/sys_prod/etc/launcher/appdisplay_truncate_config.xml';
  public static readonly ONE_HAND_MODE_DIALOG_PAGE_PATH: string = 'SceneBoard/oneHandModeDialog/view/OneHandModeDialog';

  // 用于记录进入单手模式的总次数
  public static readonly OPEN_ONE_HAND_MODE_NUM: string = 'OpenOneHandModeNumber';
}
