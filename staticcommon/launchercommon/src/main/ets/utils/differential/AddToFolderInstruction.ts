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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { Instruction } from './Instruction';
import { CommonConstants } from '../../constants/CommonConstants';
import { folderLayoutInfo } from '../../folder/FolderLayoutInfo';

const TAG = 'AddToFolderInstruction';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * AddToFolderInstruction.ts
 * 在指定文件夹（包含大、小文件夹）插入应用图标，支持从文件夹头部或文件夹尾部进行插入；
 * 支持多个应用同时插入；
 * 若指定文件夹不存在，则不处理该条指令；
 */

export class AddToFolderInstruction extends Instruction {
  private readonly maxRow = folderLayoutInfo.folderOpenLayoutTable.row;
  private readonly maxColumn = folderLayoutInfo.folderOpenLayoutTable.column;

  /**
   * 构造器
   *
   * @param rows 屏幕的最大行数
   * @param columns 屏幕的最大列数
   */
  public constructor(rows: number, columns: number) {
    super(rows, columns);
  }

  protected realize(gridInfo: GridLayoutItemInfo[], item: GridLayoutItemInfo): GridLayoutItemInfo[] {
    if (gridInfo === null || item === null) {
      log.showError('GridInfo is null or item is null');
      return gridInfo;
    }
    const folderIndex = gridInfo.findIndex(dataItem => this.isTargetFolderExist(dataItem, item));
    if (folderIndex === CommonConstants.INVALID_VALUE) {
      log.showError(`Target folder not exist, target folder ID is ${item.targetFolderId}`);
      return gridInfo;
    }
    item.typeId = CommonConstants.TYPE_APP;
    item.area = [1, 1];
    return item.addPosition === this.POSITION.TOP ? this.addToTop(gridInfo, folderIndex, item)
     : this.addToBottom(gridInfo, folderIndex, item);
  }

  private addToTop(gridInfo: GridLayoutItemInfo[], folderIndex: number, item: GridLayoutItemInfo): GridLayoutItemInfo[] {
    let curFolderInfo = gridInfo[folderIndex];
    const translateStep = 1;
    log.showInfo(`Add to top start, bundle name is ${item.bundleName}, folder ID is ${curFolderInfo.folderId}`);
    item.page = 0;
    item.row = 0;
    item.column = 0;
    item.container = curFolderInfo.container;
    if (!curFolderInfo.layoutInfo) {
      return gridInfo;
    }
    curFolderInfo.layoutInfo[0].forEach((itemV, itemI, layoutArr) => {
      let curAppItem = layoutArr[itemI];
      if (itemV.column === undefined || curAppItem.column === undefined || itemV.row === undefined ||
        curAppItem.row === undefined || curAppItem.page === undefined) {
        return;
      }
      if (itemV.column < this.maxColumn - 1) {
        curAppItem.column += translateStep;
      } else if (itemV.column === this.maxColumn - 1 && itemV.row < this.maxRow - 1) {
        curAppItem.column = 0;
        curAppItem.row += translateStep;
      } else {
        curAppItem.column = 0;
        curAppItem.row = 0;
        curAppItem.page += translateStep;
      }
    });
    curFolderInfo.layoutInfo[0].unshift(item);
    log.showInfo(`Add to top success, item is ${item.bundleName}`);
    return gridInfo;
  }

  private addToBottom(gridInfo: GridLayoutItemInfo[], folderIndex: number, item: GridLayoutItemInfo): GridLayoutItemInfo[] {
    let curFolderInfo = gridInfo[folderIndex];
    if (!curFolderInfo.layoutInfo) {
      return gridInfo;
    }
    let lastIndex = curFolderInfo.layoutInfo[0].length;
    log.showInfo(`Add to bottom start, bundle name is ${item.bundleName}, folder ID is ${curFolderInfo.folderId}`);
    item.page = Math.floor(lastIndex / (this.maxColumn * this.maxRow));
    item.column = lastIndex % this.maxColumn;
    item.row = Math.floor((lastIndex % (this.maxColumn * this.maxRow)) / this.maxColumn);
    item.container = curFolderInfo.container;
    curFolderInfo.layoutInfo[0].push(item);
    log.showInfo(`Add to bottom success, item is ${item.bundleName}`);
    return gridInfo;

  }

  private isTargetFolderExist(existItem: GridLayoutItemInfo, modifyItem: GridLayoutItemInfo): boolean {
    if (existItem.folderId && modifyItem.targetFolderId && existItem.folderId === modifyItem.targetFolderId) {
      return true;
    }
    return false;
  }
}