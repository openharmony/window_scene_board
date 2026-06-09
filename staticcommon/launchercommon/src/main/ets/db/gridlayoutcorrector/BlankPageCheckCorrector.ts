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

import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { RdbStoreConfig, DeviceHelper} from '@ohos/frameworkwrapper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { GridLayoutItemInfo } from '../../TsIndex';
import { AbstractGridLayoutCorrector } from './AbstractGridLayoutCorrector';
import rdb from '@ohos.data.relationalStore';
import { rdbTaskPool } from '../RdbTaskPool';
import GridLayoutInfoColumns, { GridLayoutInfoEnums } from '../column/GridLayoutInfoColumns';

const TAG = 'BlankPageCheckCorrector';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 数据库中数据存在空白页的情况,需要删除异常的空白页,大折叠场景仅区分设备不区分当前设备的展开折叠状态,以相邻两页为区分空白页
 */
export class BlankPageCheckCorrector extends AbstractGridLayoutCorrector {
  handleData(girdLayoutInfo: GridLayoutItemInfo[], isOuter?: boolean | undefined): void {
    if (ArrayUtils.isEmpty(girdLayoutInfo)) {
      return;
    }
    const cacheList: Array<GridLayoutItemInfo[]> = [];
    for (let i = 0; i < 18; i++) {
      cacheList[i] = [];
    }
    let pageCount: number = 0;
    girdLayoutInfo.forEach(item => {
      if (item.page === undefined) {
        return;
      }
      cacheList[item.page].push(item);
      pageCount = Math.max(pageCount, item.page + 1);
    });
    log.showWarn('BlankPageCheckCorrector pageCount: %{public}d', pageCount);
    let blankPages: number[] = new Array(pageCount).fill(0);

    let isFolderDevices: boolean = DeviceHelper.isLargeInFoldProduct();
    let adaptivePage: number = isFolderDevices ? 2 : 1;
    let indexChanges: number[] = this.initIndexChanges(cacheList, isFolderDevices, blankPages, adaptivePage, pageCount);
    let deletePage: number = indexChanges[indexChanges.length - 1];
    if (deletePage === 0) {
      log.showWarn('have not abnormal blank page.');
      this.recordNormalBlankPage(isFolderDevices, blankPages);
      return;
    }
    log.showWarn('need delete blank page: %{public}d', deletePage);

    // 获取需要去数据库中更新页码的元素，同步将当前缓存数组中的元素页码更新为正确页码
    const updateInfos: Array<GridLayoutItemInfo[]> = this.initUpdateInfos(cacheList, indexChanges);

    this.updateRdbGridLayoutItemInfoPage(updateInfos, isOuter);

    this.recordNormalBlankPage(isFolderDevices, blankPages);
  }

  private recordNormalBlankPage(isFolderDevices: boolean, blankPages: number[]): void {
    if (isFolderDevices) {
      let pageIndexes: number[] = [];
      if (blankPages[blankPages.length - 1] === 0) {
        blankPages.length = blankPages.length - 1;
      }
      blankPages.forEach((pageIndex: number, index: number) => {
        if (pageIndex === 0) {
          pageIndexes.push(index);
        }
      });
    }
  }

  private initUpdateInfos(cacheList: GridLayoutItemInfo[][], indexChanges: number[]): Array<GridLayoutItemInfo[]> {
    const updateInfo: Array<GridLayoutItemInfo[]> = [];
    for (let i = 0; i < 18; i++) {
      updateInfo[i] = [];
    }
    for (let i = 0; i < 18; i++) {
      if (cacheList[i].length === 0 || indexChanges[i] === 0) {
        log.showInfo('delete blankPage pageIndex: %{public}d not change, indexChanges : %{public}d', i, indexChanges[i]);
        continue;
      }
      log.showInfo('delete blankPage pageIndex: %{public}d change to %{public}d', i, i - indexChanges[i]);
      cacheList[i].forEach(item => {
        if (item.page === undefined) {
          return;
        }
        item.page = item.page - indexChanges[i];
        updateInfo[i].push(item);
      });
    }
    return updateInfo;
  }

  private initIndexChanges(cacheList: Array<GridLayoutItemInfo[]>, isFolder: boolean, blankPages: number[],
    adaptivePage: number, pageCount: number): number[] {
    let change: number = 0;
    let indexChanges: number[] = new Array(pageCount).fill(0);

    if (isFolder) {
      for (let i = 0; i < pageCount; i = i + adaptivePage) {
        if (cacheList[i].length === 0 && cacheList[i + 1].length === 0) {
          change = change + adaptivePage;
          blankPages.length = blankPages.length - adaptivePage;
        } else {
          blankPages[i - change] = cacheList[i].length;
          blankPages[i + 1 - change] = cacheList[i + 1].length;
        }
        indexChanges[i] = change;
        indexChanges[i + 1] = change;
      }
    } else {
      for (let i = 0; i < pageCount; i++) {
        if (cacheList[i].length === 0) {
          change = change + adaptivePage;
        }
        indexChanges[i] = change;
      }
    }
    return indexChanges;
  }

  private async updateRdbGridLayoutItemInfoPage(updateInfos: Array<GridLayoutItemInfo[]>,
    isOuter?: boolean): Promise<void> {
    let tableName: string = RdbStoreConfig.gridLayoutInfo.tableName;
    if (isOuter === undefined) {
      if (launcherStatusUtil.getShowOutLauncherStatus()) {
        tableName = RdbStoreConfig.outerGridLayoutInfo.tableName;
      }
    }
    if (isOuter) {
      tableName = RdbStoreConfig.outerGridLayoutInfo.tableName;
    }
    for (let i = 0; i < updateInfos.length; i++) {
      if (updateInfos[i].length === 0) {
        continue;
      }
      for (let j = 0; j < updateInfos[i].length; i++) {
        let mId = updateInfos[i][j].id;
        let mPage = updateInfos[i][j].page;
        if (mId === undefined || mPage === undefined) {
          continue;
        }
        let conditions: Map<string, rdb.ValueType> = new Map();
        conditions.set(GridLayoutInfoColumns.ID, mId);
        const updateBucket: rdb.ValuesBucket = {
          [GridLayoutInfoEnums.PAGE_INDEX]: mPage,
        };
        const changeRows: number = await rdbTaskPool.update(tableName, conditions, updateBucket);
        if (changeRows < 1) {
          log.showError('updateRdbGridLayoutItemInfoPage error page: %{public}d, changeRow: %{public}d',
            updateInfos[i][0].page, changeRows);
        }
      }
    }
  }
}