/**
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
import { CommonConstants } from '../constants/CommonConstants';
import { AppItemInfo } from '../bean/AppItemInfo';

/**
 * Item info of folders.
 */
export default class FolderItemInfo {
  public readonly typeId: number = CommonConstants.TYPE_FOLDER;

  /**
   * folder id.
   */
  public folderId: string | undefined;

  /**
   * folder name to display
   */
  public folderName: string | undefined;

  /**
   * Application list of this folder.
   */
  public appList: string[] | undefined;

  public layoutInfo: FolderAppItemInfo[][] = [];

  public badgeNumber: number = 0;

  public column: number = 0;

  public row: number = 0;

  public area: number[] = [1, 1];

  public page: number = -1;

  public addIconGeometryId: string = '';

  public totalBadgeGeometryId?: string;

  public backgroundGeometryId: string = '';

  public enterEditing: boolean = false;

  public extend1: string = '';

  public shortcutId?: string;

  public container?: number;
}

export class FolderAppItemInfo extends AppItemInfo {
  public isEmpty: boolean = true;
  public alignContent?: Alignment;
  public isOpenFolder: boolean = false;
  public geometryId: string = '';
  public folderId?: string = '';
}

export enum FolderBadgeAnimType {
  DEFAULT = -1,
  BIG_TO_SMALL = 0,
  SMALL_TO_BIG = 1,
}

export class FolderBadgeAnimInfo {
  public animType: FolderBadgeAnimType = FolderBadgeAnimType.DEFAULT;
  public folderId: string = '';
}