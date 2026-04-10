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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  LaunchLayoutCacheManager
} from '@ohos/launchercommon/src/main/ets/cache/layout/LaunchLayoutCacheManager';
import { BusinessType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import {
  GridLayoutItemInfo,
  GridLayoutUtil,
  LauncherLayoutCacheUtil,
  LayoutDescription,
  LayoutViewModel,
  RdbStoreManager
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import PcPresetStyleConstants from '../../common/constants/PcPresentConstants';
import { ItemLocation } from '@ohos/launchercommon/Index';

const TAG = 'PcLayoutCacheManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class PcLayoutCacheManager extends LaunchLayoutCacheManager {

  private static mInstance: PcLayoutCacheManager;

  private constructor() {
    super();
  }

  static getInstance(): PcLayoutCacheManager {
    if (PcLayoutCacheManager.mInstance == null) {
      PcLayoutCacheManager.mInstance = new PcLayoutCacheManager();
    }
    return PcLayoutCacheManager.mInstance;
  }

  public updateLayoutIfDuplicate(): void {
    log.showInfo('updateLayoutIfDuplicate');
    this.reFindPosForDuplicate();
  }

  public checkIfDuplicatePosition() : boolean {
    let isDuplicate: boolean = super.checkIfDuplicatePosition();
    let isItemOverScreen: boolean = this.filterItemsPosOverScreen().length > 0;
    log.showInfo(`checkIfDuplicatePosition, isDuplicate: ${isDuplicate}, isItemOverScreen: ${isItemOverScreen}`);
    return isDuplicate || isItemOverScreen;
  }

  private updateItemsPositionToDB(items: GridLayoutItemInfo[]): void {
    log.showInfo(`updateItemsPositionToDB: ${items?.length}`);
    if (!items) {
      log.showWarn('updateItemsPositionToDB, invalid items');
      return;
    }
    const itemsForDb: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.getChangeItems(items);
    RdbStoreManager.getInstance().updateInfoPosition(itemsForDb, 'PcUpdateItemsPositionToDB');
  }

  /**
   * 为重复元素找位
   * @returns 是否完全找位成功
   */
  private reFindPosForDuplicate(): boolean {
    // 从缓存中找出重复元素，按从大到小
    let reArrangeElements: GridLayoutItemInfo[] =
      this.reArrangeLayoutInfo(LayoutViewModel.getInstance().getDesktopModel());
    log.showInfo(`reFindPosForDuplicate, find duplicate items: ${reArrangeElements?.length}`);
    // 找出当前超出屏幕坐标的元素，当作重复元素找位
    let posOverScreen: GridLayoutItemInfo[] = this.filterItemsPosOverScreen(true);
    posOverScreen.forEach(item => {
      // 重复坐标已入列，则不再添加
      if (reArrangeElements.indexOf(item) < 0) {
        log.showInfo(`add posOverScreen item: ${GridLayoutUtil.generateUniqueKey(item)}`);
        reArrangeElements.push(item);
      }
    })
    // 分成大尺寸元素和1x1元素
    let bigSizeElements: GridLayoutItemInfo[] = [];
    let oneSizeElement: GridLayoutItemInfo[] = [];
    for (let item of reArrangeElements) {
      const sizeRow: number = item.area?.[1] ?? 1;
      const sizeColumn: number = item.area?.[0] ?? 1;
      if (sizeRow === 0 || sizeColumn === 0) {
        log.showWarn(`skip invalid size item: ${GridLayoutUtil.generateUniqueKey(item)}`);
        continue;
      } else if (sizeRow > 1 || sizeColumn > 1) {
        bigSizeElements.push(item);
      } else if (sizeRow === 1 && sizeColumn === 1) {
        oneSizeElement.push(item);
      }
    }
    let noPosItemsOfBigItem: GridLayoutItemInfo[] = this.updateAppItemLayoutInfo(bigSizeElements, false, 'findForBigSize');
    let noPosItemsOf1x1Element: GridLayoutItemInfo[] =
      this.updateAppItemLayoutInfo(oneSizeElement, true, 'findFor1x1Element');
    if (noPosItemsOfBigItem.length > 0 || noPosItemsOf1x1Element.length > 0) {
      log.showWarn(`reFindPosForDuplicate, left cards: ${noPosItemsOfBigItem?.length}, 1x1 items: ${noPosItemsOf1x1Element?.length}`);
      this.printItemInfo(noPosItemsOfBigItem);
      this.printItemInfo(noPosItemsOf1x1Element);
      return false;
    }
    return true;
  }

  private buildItemLocation(startPage: number, startRow: number, startCol: number): ItemLocation {
    let itemLocation: ItemLocation = new ItemLocation();
    itemLocation.curPage = startPage;
    itemLocation.curRow = startRow;
    itemLocation.curCol = startCol;
    itemLocation.findPage = startPage;
    itemLocation.findRow = 0;
    itemLocation.findCol = 0;
    return itemLocation;
  }

  /**
   * 移动到下一个位置
   * @param maxRow 最大行数
   * @param maxCol 最大列数
   * @param itemLocation 当前坐标指针
   * @returns 本页是否有位置, true 有位置
   */
  private moveNext(maxRow: number, maxCol: number, itemLocation: ItemLocation,
    leftToRight: boolean = true, portrait: boolean = true, moveStep: number = 1): boolean {
    let findNextPage: boolean = false;
    // 自上往下找
    const nextRow: number = itemLocation.curRow + moveStep;
    itemLocation.curRow = (nextRow + maxRow) % maxRow;
    if (portrait) {
      // 从左往右找
      if (leftToRight) {
        itemLocation.curCol = itemLocation.curCol + Math.floor(nextRow / maxRow);
        findNextPage = itemLocation.curCol >= maxCol;
      } else {
        itemLocation.curCol = itemLocation.curCol - Math.floor(nextRow / maxRow);
        findNextPage = itemLocation.curCol < 0;
      }
    } else {
      if (leftToRight) {
        itemLocation.curCol = itemLocation.curCol + Math.floor(nextRow / maxRow);
        findNextPage = itemLocation.curCol >= maxCol;
      } else {
        itemLocation.curCol = itemLocation.curCol - Math.floor(nextRow / maxRow);
        findNextPage = itemLocation.curCol < 0;
      }
    }
    if (findNextPage) {
      // 横屏找卡片需从右页到左页找
      itemLocation.curPage = ((!portrait) && (!leftToRight)) ? itemLocation.curPage - 1 : itemLocation.curRow + 1;
      itemLocation.curRow = 0;
      itemLocation.curCol = (!leftToRight) ? maxCol - 1 : 0;
    }
    return !findNextPage;
  }

  /**
   * 在本页查找空位
   * @param maxRow 最大行数
   * @param maxCol 最大列数
   * @param item 待找位元素
   * @param itemLocation 起始查找位置
   * @returns 本页是否找到位置
   */
  private findPositionOnCurrentPage(maxRow: number, maxCol: number, item: GridLayoutItemInfo,
    itemLocation: ItemLocation, leftToRight: boolean = true): boolean {
    if (maxRow <= 0 || maxCol <= 0) {
      log.showWarn('findPositionOnCurrentPage, maxRow or maxCol not legal');
      return false;
    }
    // 单页宫格数，最大循环次数
    const exceedTimes: number = maxRow * maxCol;
    let count: number = 0;
    do {
      count++;
      if (this.isPositionValid(item, itemLocation.curPage, itemLocation.curCol, itemLocation.curRow)) {
        itemLocation.findCol = itemLocation.curCol;
        itemLocation.findRow = itemLocation.curRow;
        itemLocation.findPage = itemLocation.curPage;
        log.showInfo(`findPositionOnCurrentPage page:${itemLocation.curPage} x:${itemLocation.findCol} y:${itemLocation.findRow},
         keyName: ${item?.bundleName} result: true`);
        this.moveNext(maxRow, maxCol, itemLocation, leftToRight, false, item.area?.[1] ?? 1);
        return true;
      }
      if (count > exceedTimes) {
        // 循环保护
        log.showWarn('findPositionOnCurrentPage, loop exceed max times');
        return false;
      }
    } while (this.moveNext(maxRow, maxCol, itemLocation, leftToRight, false));
    log.showInfo(`findPositionOnCurrentPage false and change next page: ${itemLocation.curPage}, keyName: ${item.bundleName}`);
    return false;
  }

  private getStartFindPage(maxPage: number, leftToRight: boolean = true): number {
    if (maxPage < 1) {
      return 0;
    }
    return leftToRight ? 0 : maxPage - 1;
  }

  /**
   * 获取起始查找位置
   * @param maxRow
   * @param maxColumn
   * @param leftToRight
   * @returns [column, row]
   */
  private getStartFindPos(maxColumn: number, leftToRight: boolean = true): number[] {
    if (leftToRight || maxColumn < 1) {
      return [0, 0];
    } else {
      return [maxColumn - 1, 0];
    }
  }

  /**
   * 为这些元素在桌面上找位
   * @param itemList
   * @returns 未能找到合适位置的元素
   */
  private updateAppItemLayoutInfo(itemList: GridLayoutItemInfo[], leftToRight: boolean = true,
    callerTag: string = ''): GridLayoutItemInfo[] {
    log.showInfo(`updateAppItemLayoutInfo item length: ${itemList?.length}, callerTag: ${callerTag}`);
    if (CheckEmptyUtils.isEmptyArr(itemList)) {
      log.showWarn('updateAppItemLayoutInfo, empty');
      return [];
    }
    let pageCount: number = this.selectPageCount();
    let layoutDescription: LayoutDescription = this.selectLayoutDescription();
    let maxRow: number = layoutDescription.row;
    let maxCol: number = layoutDescription.column;
    let maxPage: number = layoutDescription.maxPage;
    let startFindPage: number = this.getStartFindPage(maxPage, leftToRight);
    let startFindPos: number[] = this.getStartFindPos(maxCol, leftToRight);
    // 每个元素都从起始位置开始找
    let itemLocation: ItemLocation = this.buildItemLocation(startFindPage, startFindPos[1], startFindPos[0]);
    let locationItemList: GridLayoutItemInfo[] = [];
    log.showInfo('updateAppItemLayoutInfo pageCount: %{public}d maxPage: %{public}d, maxCol: %{public}d,' +
      ' maxRow: %{public}d, startPage: %{public}d, startRow: %{public}d, startColumn: %{public}d', pageCount, maxPage,
      maxCol, maxRow, startFindPage, startFindPos[1], startFindPos[1]);
    // 超出范围，无法安排位置
    let itemOverMaxPageList: GridLayoutItemInfo[] = [];
    for (const item of itemList) {
      log.showInfo(`updateAppItemLayoutInfo item: ${GridLayoutUtil.generateUniqueKey(item)}`);
      // 桌面可用空位已经找完了，放不下了
      if (itemLocation.curPage >= maxPage) {
        itemOverMaxPageList.push(item);
        continue;
      }
      let needNextPage: boolean = true;
      let count: number = 0;
      while (needNextPage) {
        if (itemLocation.curPage >= maxPage || itemLocation.curPage < 0) {
          log.showInfo(`current find page exceed, stop find, curPage: ${itemLocation.curPage}`);
          itemOverMaxPageList.push(item);
          needNextPage = true;
          break;
        }
        needNextPage = !this.findPositionOnCurrentPage(maxRow, maxCol, item, itemLocation, leftToRight);
        count++;
        if (count > maxPage) {
          // 循环保护
          log.showWarn('updateAppItemLayoutInfo, exceed find times');
          if (needNextPage) {
            itemOverMaxPageList.push(item);
          }
          break;
        }
      }
      if (!needNextPage) {
        item.page = itemLocation.findPage;
        item.column = itemLocation.findCol;
        item.row = itemLocation.findRow;
        locationItemList.push(item);
      }
    }
    if (!CheckEmptyUtils.isEmptyArr(locationItemList)) {
      // 重排这些元素并入库
      this.insertGridLayoutItemList(locationItemList, BusinessType.BUSINESS_BASIC_DESKTOP, false);
      const newItems: GridLayoutItemInfo[] =
        LauncherLayoutCacheUtil.getLazyRotateChangeItemsForCache(locationItemList);
      this.updateItemsPositionToDB(newItems);
    }
    return itemOverMaxPageList;
  }

  private printItemInfo(items: GridLayoutItemInfo[]): void {
    items?.forEach((item: GridLayoutItemInfo) => {
      log.showError('itemOverMaxPageList. layout info is {page:%{public}d, column:%{public}d, row:%{public}d, ' +
        'width:%{public}d, height:%{public}d, typeId:%{public}d, bundleName:%{public}s, cardId:%{public}S, ' +
        'folderId:%{public}s, formStackId:%{public}s}', item.page, item.column, item.row, item.area?.[0],
        item.area?.[1], item.typeId, item.bundleName, item.cardId, item.folderId, item.formStackId);
    })
  }

  private checkPositionValid(item: GridLayoutItemInfo, maxRow: number, maxColumn: number): boolean {
    if (!item.area) {
      log.showWarn(`checkPositionValid item ${item.keyName} area is undefined`);
      return false;
    }
    const row: number = item.row as number;
    const column: number = item.column as number;
    if ((row < 0 || (row + item.area?.[1]) > maxRow) || (column < 0 || (column + item.area?.[0]) > maxColumn)) {
      return false;
    }
    return true;
  }

  private filterItemsPosOverScreen(removeInvalidItem: boolean = false): GridLayoutItemInfo[] {
    log.showInfo('filterItemsPosOverScreen start');
    let layoutItems: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    let layoutDescription: LayoutDescription = this.layoutCacheData.getGridLayoutInfo().layoutDescription;
    if (CheckEmptyUtils.isEmpty(layoutItems)) {
      log.showWarn('correctItemPosition items is empty');
      return [];
    }
    // 获取屏幕的宽高属性
    let maxRows: number = layoutDescription.row;
    let maxCols: number = layoutDescription.column;

    if (!this.isMatchDeviceMainGrid(maxRows, maxCols)) {
      log.showWarn('not MainGrid');
      return [];
    }
    log.showInfo(`filterItemsPosOverScreen maxRow: ${maxRows}, maxCols: ${maxCols}`);
    let inVaLidItemList: GridLayoutItemInfo[] = [];
    for (let i = 0; i < layoutItems.length; i++) {
      const item: GridLayoutItemInfo = layoutItems[i];
      if (!item.area) {
        log.showWarn(`item ${item.keyName} area is undefined, skip`);
        continue;
      }
      if (!this.checkPositionValid(item, maxRows, maxCols)) {
        log.showWarn(`checkPositionValid item ${item.keyName}, row: ${item.row}, column ${item.column}, page: ${item.page}`);
        inVaLidItemList.push(item);
      }
    }
    log.showInfo(`filterItemsPosOverScreen length: ${inVaLidItemList.length}, origin size ${layoutItems.length}`);
    if (removeInvalidItem) {
      // 缓存中清除重复位置元素
      layoutItems = layoutItems.filter(item => {
        if (inVaLidItemList.indexOf(item) >= 0) {
          return false;
        }
        return true;
      });
      this.layoutCacheData.updateLayoutListCache(layoutItems);
    }
    return inVaLidItemList;
  }

  private isMatchDeviceMainGrid(maxRows: number, maxCols: number): boolean {
    if (!DeviceHelper.isHAD()) {
      return false;
    }
    let matchHadMainGrid: boolean = (maxRows === PcPresetStyleConstants.DEFAULT_HAD_MDPI_ROW) &&
        (maxCols === PcPresetStyleConstants.DEFAULT_HAD_MDPI_COLUMN);
    return matchHadMainGrid;
  }
}