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

const TAG = 'ExchangeInstruction';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
// 值为-1代表没有查询到索引
const FIND_STATUS_FAIL: number = -1;

/**
 * ExchangeInstruction.ts
 * 差分应用位置互换
 */

export class ExchangeInstruction extends Instruction {
  public constructor(rows: number, columns: number) {
    super(rows, columns);
  }
  protected realize(gridInfo: GridLayoutItemInfo[], item: GridLayoutItemInfo): GridLayoutItemInfo[] {
    log.showInfo('start exchange app');
    // replacementIndex settlementIndex 代表是否在桌面 replacementLayoutInfoIndex settlementLayoutInfoIndex 代表是否在文件夹内
    const mReplaceIndex: LayoutIndexInfo = this.findBundleIndex(gridInfo, item.replacement ?? '');
    const replacementIndex = mReplaceIndex.mainIndex;
    const replacementLayoutInfoIndex = mReplaceIndex.layoutInfoIndex;
    log.showInfo(`found replacement at index: ${replacementIndex}, layoutInfoIndex: ${replacementLayoutInfoIndex}`);

    const mSettleIndex: LayoutIndexInfo = this.findBundleIndex(gridInfo, item.settlement ?? '');
    const settlementIndex = mSettleIndex.mainIndex;
    const settlementLayoutInfoIndex = mSettleIndex.layoutInfoIndex;
    log.showInfo(`found settlement at index: ${settlementIndex}, layoutInfoIndex: ${settlementLayoutInfoIndex}`);

    if (this.checkReplaceSettleIndex(replacementIndex, settlementIndex) &&
      replacementLayoutInfoIndex !== FIND_STATUS_FAIL &&
      settlementLayoutInfoIndex === FIND_STATUS_FAIL) {
      let mReplaceInfo = gridInfo[replacementIndex].layoutInfo;
      if (mReplaceInfo) {
        let arr = this.exchangeLocation(mReplaceInfo[0][replacementLayoutInfoIndex],
          gridInfo[settlementIndex]);
        mReplaceInfo[0][replacementLayoutInfoIndex] = arr[1];
        gridInfo[settlementIndex] = arr[0];
      }
    }

    if (this.checkReplaceSettleIndex(replacementIndex, settlementIndex) &&
      replacementLayoutInfoIndex !== FIND_STATUS_FAIL &&
      settlementLayoutInfoIndex !== FIND_STATUS_FAIL) {
      let mReplaceInfo = gridInfo[replacementIndex].layoutInfo;
      let mSettleInfo = gridInfo[settlementIndex].layoutInfo;
      if (mReplaceInfo && mSettleInfo) {
        let arr = this.exchangeLocation(mReplaceInfo[0][replacementLayoutInfoIndex],
          mSettleInfo[0][settlementLayoutInfoIndex]);
        mReplaceInfo[0][replacementLayoutInfoIndex] = arr[0];
        mSettleInfo[0][settlementLayoutInfoIndex] = arr[1];
      }

    }

    if (this.checkReplaceSettleIndex(replacementIndex, settlementIndex) &&
      replacementLayoutInfoIndex === FIND_STATUS_FAIL &&
      settlementLayoutInfoIndex !== FIND_STATUS_FAIL) {
      let mSettleInfo = gridInfo[settlementIndex].layoutInfo;
      if (mSettleInfo) {
        let arr = this.exchangeLocation(gridInfo[replacementIndex],
          mSettleInfo[0][settlementLayoutInfoIndex]);
        gridInfo[replacementIndex] = arr[1];
        mSettleInfo[0][settlementLayoutInfoIndex] = arr[0];
      }
    }

    if (this.checkReplaceSettleIndex(replacementIndex, settlementIndex) &&
      replacementLayoutInfoIndex === FIND_STATUS_FAIL &&
      settlementLayoutInfoIndex === FIND_STATUS_FAIL) {
      let arr = this.exchangeLocation(gridInfo[replacementIndex], gridInfo[settlementIndex]);
      gridInfo[replacementIndex] = arr[0];
      gridInfo[settlementIndex] = arr[1];
    }
    log.showInfo('end exchange app');
    return gridInfo;
  }

  private checkReplaceSettleIndex(replacementIndex: number, settlementIndex: number): boolean {
    return replacementIndex !== FIND_STATUS_FAIL && settlementIndex !== FIND_STATUS_FAIL;
  }

  // 入参为需要交换位置的应用layoutInfo 返回值为交换完成后两个应用的layoutInfo
  private exchangeLocation(replacement: GridLayoutItemInfo,
    settlement: GridLayoutItemInfo): [GridLayoutItemInfo, GridLayoutItemInfo] {
    log.showInfo(`befor replacement:page:${replacement.page}row:${replacement.row}column:${replacement.column}container:${replacement.container}`);
    log.showInfo(`befor settlement:page:${settlement.page}row:${settlement.row}column:${settlement.column}container:${settlement.container}`);
    let tmpPage = replacement.page;
    replacement.page = settlement.page;
    settlement.page = tmpPage;

    let tmpRow = replacement.row;
    replacement.row = settlement.row;
    settlement.row = tmpRow;

    let tmpColumn = replacement.column;
    replacement.column = settlement.column;
    settlement.column = tmpColumn;

    let tmpContainer = replacement.container;
    replacement.container = settlement.container;
    settlement.container = tmpContainer;
    log.showInfo(`after replacement:page:${replacement.page}row:${replacement.row}column:${replacement.column}container:${replacement.container}`);
    log.showInfo(`after settlement:page:${settlement.page}row:${settlement.row}column:${settlement.column}container:${settlement.container}`);
    return [replacement, settlement];
  }

  // 入参为桌面的layoutInfo,以及应用的layoutInfo，返回值为应用的layoutInfo在桌面的layoutInfo的位置信息

  private findBundleIndex(gridInfo: GridLayoutItemInfo[],
    targetBundleName: string): LayoutIndexInfo {
    let rst: LayoutIndexInfo = new LayoutIndexInfo();

    gridInfo.forEach((info, index) => {
      if (info.bundleName === targetBundleName) {
        rst.mainIndex = index;
        return;
      }
      if (info.layoutInfo && info.layoutInfo.length > 0) {
        this.dealLayoutInfo(info.layoutInfo[0], targetBundleName, index, rst);
      }
    });
    return rst;
  }

  private dealLayoutInfo(layoutInfo: GridLayoutItemInfo[], targetBundleName: string, index: number,
    rst: LayoutIndexInfo): void {
    layoutInfo.forEach((innerInfo, innerIndex) => {
      if (innerInfo.bundleName === targetBundleName) {
        rst.mainIndex = index;
        rst.layoutInfoIndex = innerIndex;
        return;
      }
    });
  }
}

export class LayoutIndexInfo {
  mainIndex: number = -1;
  layoutInfoIndex: number = -1;
}