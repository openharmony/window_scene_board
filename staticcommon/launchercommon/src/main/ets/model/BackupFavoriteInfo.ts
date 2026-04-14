/**
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
export enum BackupItemType {
  BACKUP_ITEM_TYPE_APP = 0,
  BACKUP_ITEM_TYPE_SPECIAL_SHORTCUT = 1,
  BACKUP_ITEM_FOLDER = 2,
  BACKUP_ITEM_LIVE_FOLDER = 3,
  BACKUP_ITEM_TYPE_WIDGET = 4,
  BACKUP_ITEM_TYPE_SHORTCUT = 7,
  BACKUP_ITEM_TYPE_CARD = 9,
  BACKUP_ITEM_BIG_FOLDER = 10,
  BACKUP_ITEM_TYPE_STACK_CARD = 11,
  BACKUP_ITEM_TYPE_COMBINE_CARD = 12
}

/**
 * back up favorite info used to transfer data
 */
export class BackupFavoriteInfo {
  public id: number = 0;

  public title: string = '';

  public intent: string = '';

  public container: number = -100;

  public screen: number = 0;

  public cellX: number = 0;

  public cellY: number = 0;

  public spanX: number = 0;

  public spanY: number = 0;

  public itemType: number = 0;

  public appWidgetId?: string;

  public iconType?: number;

  public iconPackage?: string;

  public iconResource?: string;

  public icon?: string;

  public uri?: string;

  public displayMode?: number;

  public appId?: string;

  public isNewInstalled?: number;

  public sdAppStatus?: number;

  public profileId?: number;

  public downloadAppId?: string;

  public downloadProgress?: number;

  public downloadStatus?: number;

  public downloadIcon?: string;

  public downloadLastModified?: number;

  public downloadAppType?: number;

  public extendInfo1?: string;

  public extendInfo2?: string;

  public extendInfo3?: string;
}
