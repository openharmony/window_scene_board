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

import { SqueezeExtraParam } from '@ohos/componentdrag';
import type GridLayoutItemInfo from './GridLayoutItemInfo';

export class MoveItem {
  public page?: number;
  public typeId?: number;
  public cardId?: string;
  public folderId?: string;
  public folderName?: string;
  public formStackId?: string;
  public appName?: string;
  public keyName?: string;
  public row?: number;
  public column?: number;
  public position?: number[][];
  public shake?: number;
  public abilityName?: string;
  public moduleName?: string;
  public isRepeatItem?: boolean;
  public area?: number[];
  public uri?: string;
  public ino?: string;
  public layoutInfo?: Array<GridLayoutItemInfo[]>;
  public infoId?: string;
  public bundleName?: string;
  public appIndex?: number;
  public isDrag?: boolean;
  public shortcutId?: string;
  public isShowSqueezeAnimation?: boolean;
  public squeezeExtraParam?: SqueezeExtraParam;

  public static fromGridItem(item: GridLayoutItemInfo): MoveItem {
    let moveItem = new MoveItem();
    moveItem.page = item.page;
    moveItem.typeId = item.typeId;
    moveItem.cardId = item.cardId;
    moveItem.folderId = item.folderId;
    moveItem.folderName = item.folderName;
    moveItem.formStackId = item.formStackId;
    moveItem.appName = item.appName;
    moveItem.keyName = item.keyName;
    moveItem.area = item.area;
    moveItem.uri = item.uri;
    moveItem.infoId = item.infoId;
    moveItem.ino = item.ino;
    moveItem.bundleName = item.bundleName;
    moveItem.appIndex = item.appIndex;
    moveItem.shortcutId = item.shortcutId;
    moveItem.abilityName = item.abilityName;
    moveItem.moduleName = item.moduleName;
    return moveItem;
  }
}