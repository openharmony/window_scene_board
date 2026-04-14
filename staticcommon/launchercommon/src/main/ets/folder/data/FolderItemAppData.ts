/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { CheckEmptyUtils, LogDomain, LogHelper, } from '@ohos/basicutils';

import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { FolderModel } from '../FolderModel';


const TAG = 'FolderItemAppData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class FolderItemAppData {
  private mFolderGridLayoutItem: GridLayoutItemInfo = new GridLayoutItemInfo();

  constructor(item: GridLayoutItemInfo) {
    this.formatFolderInfo(item);
    log.showInfo(`FolderItemAppData constructor`);
  }

  private formatFolderInfo(item: GridLayoutItemInfo): void {
    this.mFolderGridLayoutItem = item;
    let column: number | undefined = FolderModel.getInstance().getFolderOpenLayout()?.column;
    let row: number | undefined = FolderModel.getInstance().getFolderOpenLayout()?.row;
    if (column === undefined || row === undefined) {
      return;
    }
    const allCount = column * row;
    try {
      if (this.getFolderGridLayoutItemLength(this.mFolderGridLayoutItem) > allCount) {
        let folderLayoutInfoList: GridLayoutItemInfo[][] = [];
        if (!this.mFolderGridLayoutItem.layoutInfo) {
          return;
        }
        let integer = Math.floor(this.mFolderGridLayoutItem.layoutInfo[0].length / allCount);
        let remainder = this.mFolderGridLayoutItem.layoutInfo[0].length % allCount;
        for (let i = 0; i < integer; i++) {
          folderLayoutInfoList.push(this.mFolderGridLayoutItem.layoutInfo[0].slice(i * allCount, (i + 1) * allCount));
        }
        if (remainder !== 0) {
          folderLayoutInfoList.push(this.mFolderGridLayoutItem.layoutInfo[0].slice(integer * allCount,
            integer * allCount + remainder));
        }
        (this.mFolderGridLayoutItem.layoutInfo as object[]).splice(0, 1);
        this.mFolderGridLayoutItem.layoutInfo = folderLayoutInfoList;
      }
    } catch (err) {
      log.showError('formatFolderInfo result: failed %{public}d:%{public}s', err.code, err.message);
    }
  }

  private getFolderGridLayoutItemLength(itemInfo: GridLayoutItemInfo): number {
    if (itemInfo && itemInfo.layoutInfo && !CheckEmptyUtils.isEmptyArr(itemInfo.layoutInfo) &&
      itemInfo.layoutInfo.length > 0 && !CheckEmptyUtils.isEmptyArr(itemInfo.layoutInfo[0])) {
      return itemInfo.layoutInfo[0].length;
    }
    return 0;
  }

  /**
   * 获取文件夹布局信息
   *
   * @returns GridLayoutItemInfo 文件夹布局信息
   */
  public getFolderItemAppData(): GridLayoutItemInfo {
    return this.mFolderGridLayoutItem;
  }

  /**
   * 设置文件夹布局信息
   *
   * @returns GridLayoutItemInfo 文件夹布局信息
   */
  public setFolderItemAppData(item: GridLayoutItemInfo): void {
    this.formatFolderInfo(item);
  }
}

