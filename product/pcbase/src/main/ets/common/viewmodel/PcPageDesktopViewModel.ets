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
import { ResourceManager } from '@ohos/frameworkwrapper';
import {
  BaseViewModel,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
  layoutConfigManager,
  CommonConstants,
  FileType,
  LayoutViewModel,
} from '@ohos/launchercommon';
import { BusinessType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import FeatureConstants from '@ohos/pagedesktop/src/main/ets/default/common/constants/FeatureConstants';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import { PageDesktopViewModel } from '@ohos/pagedesktop/src/main/ets/default/common/viewmodel/PageDesktopViewModel';
import CommonEventManager from '@ohos.commonEventManager';
import { BusinessError } from '@kit.BasicServicesKit';
import Prompt from '@ohos.promptAction';

const EVENT_CREASE_REGION_TIP = 'usual.event.FOLDING_AREA_TOUCH';

const TAG = 'PcPageDesktopViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class PcPageDesktopViewModel extends BaseViewModel {
  public static mInstance: PcPageDesktopViewModel;

  private readonly mPageDesktopViewModel: PageDesktopViewModel;
  private readonly pageDesktopStyleConfig: PageDesktopGridStyleConfig;
  private readonly mLauncherLayoutCacheManager: LaunchLayoutCacheManager;
  private appGridLayoutItems: GridLayoutItemInfo[] = [];
  private folderGridLayoutItems: GridLayoutItemInfo[] = [];
  private fileGridLayoutItems: GridLayoutItemInfo[] = [];
  private cardGridLayoutItems: GridLayoutItemInfo[] = [];
  private regionFolderGridLayoutItems: GridLayoutItemInfo[] = [];
  private creaseRegionTipSubscriber: CommonEventManager.CommonEventSubscriber | null = null;

  private constructor() {
    super();
    this.mPageDesktopViewModel = PageDesktopViewModel.getInstance();
    this.pageDesktopStyleConfig = layoutConfigManager.getStyleConfig(PageDesktopGridStyleConfig.APP_GRID_STYLE_CONFIG,
      FeatureConstants.FEATURE_NAME);
    this.mLauncherLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
  }

  static getInstance(): PcPageDesktopViewModel {
    if (!PcPageDesktopViewModel.mInstance) {
      PcPageDesktopViewModel.mInstance = new PcPageDesktopViewModel();
    }
    return PcPageDesktopViewModel.mInstance;
  }

  /**
   * Get PageDesktopStyleConfig.
   */
  private getPageDesktopStyleConfig(): PageDesktopGridStyleConfig {
    return this.pageDesktopStyleConfig;
  }

  private checkAppGridLayoutItems(): void {
    let length = this.appGridLayoutItems.length;
    for (let i = 0; i < length; i++) {
      if (!this.appGridLayoutItems[i]) {
        continue;
      }
      if (CheckEmptyUtils.checkStrIsEmpty(this.appGridLayoutItems[i].appName) &&
        (!CheckEmptyUtils.checkStrIsEmpty(this.appGridLayoutItems[i].bundleName))) {
        this.appGridLayoutItems[i].appName =
          ResourceManager.getInstance().getBundleAppName(this.appGridLayoutItems[i].bundleName);
        log.showInfo(`checkAppGridLayoutItems appName: ${this.appGridLayoutItems[i].appName}`);
      }
    }
  }

  private dumpGridLayoutPosInfo(items: GridLayoutItemInfo[]): void {
    for (let item of items) {
      log.showInfo(`dump appName: ${item.appName}, ino: ${item.ino}, ` +
        `cardName: ${item.cardName}, column: ${item.column}, row: ${item.row}, ` +
        `page: ${item.page} ` + `size: ${item.size}, ctime: ${item.ctime}, mtime: ${item.mtime}`);
    }
  }
  
  private prepareSortParam(): boolean {
    try {
      let allGridLayoutItems: GridLayoutItemInfo[] =
        this.mLauncherLayoutCacheManager.getAllGridLayoutItemList(BusinessType.BUSINESS_BASIC_DESKTOP);
      if (CheckEmptyUtils.isEmptyArr(allGridLayoutItems)) {
        log.showInfo(`prepareSortParam allGridLayoutItems is empty`);
        return false;
      }
      const pageDesktopGridStyleConfig: PageDesktopGridStyleConfig = this.getPageDesktopStyleConfig();
      let column: number = pageDesktopGridStyleConfig.mColumns;
      let row: number = pageDesktopGridStyleConfig.mRows;
      log.showInfo(`prepareSortParam column: ${column}, row: ${row}`);
      let length = allGridLayoutItems.length;
      for (let i = 0; i < length; i++) {
        if (allGridLayoutItems[i].typeId === CommonConstants.TYPE_APP ||
          allGridLayoutItems[i].typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
          this.appGridLayoutItems.push(allGridLayoutItems[i]);
          continue;
        }
        if (allGridLayoutItems[i].typeId === CommonConstants.TYPE_FILE_FOLDER &&
          allGridLayoutItems[i].fileType === FileType.TYPE_FOLDER) {
          this.folderGridLayoutItems.push(allGridLayoutItems[i]);
          continue;
        }
        if (allGridLayoutItems[i].typeId === CommonConstants.TYPE_FILE_FOLDER &&
          allGridLayoutItems[i].fileType === FileType.TYPE_FILE) {
          this.fileGridLayoutItems.push(allGridLayoutItems[i]);
          continue;
        }
        if (allGridLayoutItems[i].typeId === CommonConstants.TYPE_CARD) {
          this.cardGridLayoutItems.push(allGridLayoutItems[i]);
          continue;
        }
        if (allGridLayoutItems[i].typeId === CommonConstants.TYPE_REGION_FOLDER) {
          this.regionFolderGridLayoutItems.push(allGridLayoutItems[i]);
          continue;
        }
      }
      this.checkAppGridLayoutItems();
      this.dumpGridLayoutPosInfo(allGridLayoutItems);
      return true;
    } catch (err) {
      log.showInfo(`prepareSortParam error，code: ${err?.code}, message: ${err?.message}`);
      return false;
    }
  }

  private clearSortParam(): void {
    this.appGridLayoutItems = [];
    this.folderGridLayoutItems = [];
    this.fileGridLayoutItems = [];
    this.cardGridLayoutItems = [];
    this.regionFolderGridLayoutItems = [];
  }

  private canPlaceMultiAreaLayoutItem(row: number, column: number, cardWidth: number, cardHeight: number,
    gridRows: number, gridColumns: number, gridOccupiedArray: boolean[][]): boolean {
    if (row + cardHeight > gridRows || column + cardWidth > gridColumns) {
      return false;
    }

    for (let i = row; i < row + cardHeight; i++) {
      for (let j = column; j < column + cardWidth; j++) {
        if (gridOccupiedArray[i][j]) {
          return false;
        }
      }
    }
    return true;
  }

  private markOccupied(row: number, column: number, cardWidth: number, cardHeight: number,
    gridOccupiedArray: boolean[][]): void {
    for (let i = row; i < row + cardHeight; i++) {
      for (let j = column; j < column + cardWidth; j++) {
        gridOccupiedArray[i][j] = true;
      }
    }
  }

  private getAvailableRow(column: number, availableRow: number[]): number {
    return availableRow[column] || 0;
  }

  private updateAvailableRow(row: number, column: number, cardWidth: number, cardHeight: number,
    availableRow: number[]): void {
    for (let i = column; i < column + cardWidth; i++) {
      availableRow[i] = Math.max(availableRow[i], row + cardHeight);
    }
  }

  private reorderMultiAreaLayoutItem(multiAreaLayoutItem: GridLayoutItemInfo, gridRows: number, gridColumns: number,
    gridOccupiedArray: boolean[][], availableRow: number[]): boolean {
    if (!multiAreaLayoutItem?.area) {
      log.showInfo('reorderMultiAreaLayoutItem invalid multiAreaLayoutItem.area');
      return false;
    }
    const cardWidth: number = multiAreaLayoutItem.area[0];
    const cardHeight: number = multiAreaLayoutItem.area[1];

    for (let column = gridColumns - cardWidth; column >= 0; column--) {
      let row = this.getAvailableRow(column, availableRow);
      if (row + cardHeight > gridRows) {
        continue;
      }
      if (this.canPlaceMultiAreaLayoutItem(row, column, cardWidth, cardHeight, gridRows, gridColumns,
        gridOccupiedArray)) {
        this.markOccupied(row, column, cardWidth, cardHeight, gridOccupiedArray);
        this.updateAvailableRow(row, column, cardWidth, cardHeight, availableRow);
        multiAreaLayoutItem.row = row;
        multiAreaLayoutItem.column = column;
        log.showDebug(`the row after reOrder is ${row}, the column after reOrder is ${column}`);
        return true;
      }
    }
    return false;
  }

  private reorderMultiAreaLayoutItems(multiAreaLayoutItems: GridLayoutItemInfo[], gridRows: number, gridColumns: number,
    gridOccupiedArray: boolean[][], availableRow: number[]): GridLayoutItemInfo[] {
    multiAreaLayoutItems.sort((first: GridLayoutItemInfo, second: GridLayoutItemInfo) => {
      if (!first.area || !second.area) {
        log.showError('reorderMultiAreaLayoutItems invalid first.area or second.area');
        return 0;
      }
      if (first.area[0] === undefined || first.area[1] === undefined || second.area[0] === undefined ||
        second.area[1] === undefined) {
        log.showWarn(`${first.area[0]}, ${first.area[1]}, ${second.area[0]}, ${second.area[1]}, can't compare`);
        return 0;
      }
      return first.area[0] * first.area[1] - second.area[0] * second.area[1];
    });
    const overFlowMultiAreaLayoutItems: GridLayoutItemInfo[] = [];
    for (let i = multiAreaLayoutItems.length - 1; i >= 0; i--) {
      if (!this.reorderMultiAreaLayoutItem(multiAreaLayoutItems[i], gridRows, gridColumns, gridOccupiedArray,
        availableRow)) {
        overFlowMultiAreaLayoutItems.push(multiAreaLayoutItems[i]);
        multiAreaLayoutItems.splice(i, 1);
      }
    }
    return overFlowMultiAreaLayoutItems;
  }

  private placeSingleAreaLayoutItem(singleAreaLayoutItem: GridLayoutItemInfo, gridRows: number, gridColumns: number,
    gridOccupiedArray: boolean[][]): boolean {
    for (let column = 0; column < gridColumns; column++) {
      for (let row = 0; row < gridRows; row++) {
        if (!gridOccupiedArray[row][column]) {
          gridOccupiedArray[row][column] = true;
          singleAreaLayoutItem.row = row;
          singleAreaLayoutItem.column = column;
          return true;
        }
      }
    }
    return false;
  }

  private placeSingleAreaLayoutItems(singleAreaLayoutItems: GridLayoutItemInfo[], gridRows: number, gridColumns: number,
    gridOccupiedArray: boolean[][]): GridLayoutItemInfo[] {
    const overFlowSingleAreaLayoutItems: GridLayoutItemInfo[] = [];
    for (let i = singleAreaLayoutItems.length - 1; i >= 0; i--) {
      if (!this.placeSingleAreaLayoutItem(singleAreaLayoutItems[i], gridRows, gridColumns, gridOccupiedArray)) {
        overFlowSingleAreaLayoutItems.push(singleAreaLayoutItems[i]);
        singleAreaLayoutItems.splice(i, 1);
      }
    }
    return overFlowSingleAreaLayoutItems;
  }

  private getAvailableRowArray(columnOccupiedArray: boolean[], cardHeight: number): number[] {
    const availableRowArray: number[] = [];
    for (let i = 0; i < columnOccupiedArray.length; i++) {
      if (columnOccupiedArray[i]) {
        continue;
      }
      let length: number = 1;
      for (let j = i + 1; j < columnOccupiedArray.length; j++) {
        if (!columnOccupiedArray[j]) {
          length += 1;
        } else {
          break;
        }
      }
      if (length >= cardHeight) {
        availableRowArray.push(i);
      }
    }
    return availableRowArray;
  }

  private createColumnOccupiedArray(column: number, gridRows: number, gridOccupiedArray: boolean[][]): boolean[] {
    const columnOccupiedArray: boolean[] = [];
    for (let row = 0; row < gridRows; row++) {
      columnOccupiedArray.push(gridOccupiedArray[row][column]);
    }
    return columnOccupiedArray;
  }

  private tryPlaceItemInGrid(
    item: GridLayoutItemInfo,
    cardWidth: number,
    cardHeight: number,
    gridRows: number,
    gridColumns: number,
    gridOccupiedArray: boolean[][],
    availableRow: number[]
  ): boolean {
    for (let column = gridColumns - cardWidth; column >= 0; column--) {
      const columnOccupiedArray: boolean[] = this.createColumnOccupiedArray(column, gridRows, gridOccupiedArray);
      const availableRowArray: number[] = this.getAvailableRowArray(columnOccupiedArray, cardHeight);

      for (const row of availableRowArray) {
        if (this.canPlaceMultiAreaLayoutItem(row, column, cardWidth, cardHeight, gridRows, gridColumns,
          gridOccupiedArray)) {
          this.markOccupied(row, column, cardWidth, cardHeight, gridOccupiedArray);
          this.updateAvailableRow(row, column, cardWidth, cardHeight, availableRow);
          item.row = row;
          item.column = column;
          log.showDebug(`insert multiAreaItem completed, the row after reOrder is ${row}, the column after reOrder is ${column}`);
          return true;
        }
      }
    }
    return false;
  }

  private insertMultiAreaLayoutItemsOutOfGrid(
    multiAreaLayoutItemsOutOfGrid: GridLayoutItemInfo[],
    gridRows: number,
    gridColumns: number,
    gridOccupiedArray: boolean[][],
    availableRow: number[]
  ): boolean {
    log.showInfo(`multiAreaLayoutItems out of grid length is ${multiAreaLayoutItemsOutOfGrid.length}`);
    return multiAreaLayoutItemsOutOfGrid.every(item => {
      if (!item?.area) {
        log.showError('insertMultiAreaLayoutItemsOutOfGrid invalid item.area');
        return false;
      }
      const cardWidth: number = item.area[0];
      const cardHeight: number = item.area[1];
      return this.tryPlaceItemInGrid(item, cardWidth, cardHeight, gridRows, gridColumns,
        gridOccupiedArray, availableRow);
    });
  }

  private insertSingleAreaLayoutItemsOutOfGrid(singleAreaLayoutItems: GridLayoutItemInfo[], gridRows: number,
    gridColumns: number, gridOccupiedArray: boolean[][]): boolean {
    log.showInfo(`singleAreaLayoutItems out of grid length is ${singleAreaLayoutItems.length}`);
    singleAreaLayoutItems.sort((first: GridLayoutItemInfo, second: GridLayoutItemInfo) => {
      if (first.row === undefined || first.column === undefined || second.row === undefined ||
        second.column === undefined) {
        log.showWarn(`Item row or column invalid`);
        return 0;
      }
      if (first.page && second.page && first.page !== second.page) {
        return first.page - second.page;
      }
      if (first.column !== second.column) {
        return first.column - second.column;
      }
      return first.row - second.row;
    });
    return singleAreaLayoutItems.every((item) => {
      return this.placeSingleAreaLayoutItem(item, gridRows, gridColumns, gridOccupiedArray);
    });
  }

  private extractMultiAreaLayoutItemsOutOfGrid(multiAreaLayoutItems: GridLayoutItemInfo[], gridRows: number,
    gridColumns: number): GridLayoutItemInfo[] {
    const multiAreaLayoutItemsOutOfGrid: GridLayoutItemInfo[] = [];
    for (let i = multiAreaLayoutItems.length - 1; i >= 0; i--) {
      const multiAreaLayoutItem = multiAreaLayoutItems[i];
      const column = Number(multiAreaLayoutItem.column);
      const row = Number(multiAreaLayoutItem.row);
      let area0 = Number.MIN_VALUE;
      let area1 = Number.MIN_VALUE;
      if (multiAreaLayoutItem?.area) {
        area0 = Number(multiAreaLayoutItem.area[0]);
        area1 = Number(multiAreaLayoutItem.area[1]);
      }
      log.showDebug(`the column of multiAreaLayoutItem is ${column}, the row is ${row},
      the width is ${area0}, the height is ${area1}`);
      if (column + area0 > gridColumns || row + area1 > gridRows) {
        multiAreaLayoutItemsOutOfGrid.push(multiAreaLayoutItem);
        multiAreaLayoutItems.splice(i, 1);
      }
    }
    return multiAreaLayoutItemsOutOfGrid;
  }

  private extractSingleAreaLayoutItemsOutOfGrid(singleAreaLayoutItems: GridLayoutItemInfo[], gridRows: number,
    gridColumns: number): GridLayoutItemInfo[] {
    const singleAreaLayoutItemsOutOfGrid: GridLayoutItemInfo[] = [];
    for (let i = singleAreaLayoutItems.length - 1; i >= 0; i--) {
      const singleAreaLayoutItem = singleAreaLayoutItems[i];
      const row = Number(singleAreaLayoutItem.row);
      const column = Number(singleAreaLayoutItem.column);
      if (row >= gridRows || column >= gridColumns) {
        singleAreaLayoutItemsOutOfGrid.push(singleAreaLayoutItem);
        singleAreaLayoutItems.splice(i, 1);
      }
    }
    return singleAreaLayoutItemsOutOfGrid;
  }

  private createMatrixAndInit<T>(row: number, column: number, initialValue: T): T[][] {
    let matrix: T[][] = [];
    for (let rowIndex = 0; rowIndex < row; rowIndex++) {
      matrix[rowIndex] = new Array<T>(column).fill(initialValue);
    }
    return matrix;
  }

  private adjustOutOfGridItems(gridRows: number, gridColumns: number): boolean {
    let ret: boolean = this.prepareSortParam();
    if (!ret) {
      this.clearSortParam();
      return false;
    }

    const multiAreaLayoutItems = this.cardGridLayoutItems.concat(this.regionFolderGridLayoutItems);
    const singleAreaLayoutItems = this.appGridLayoutItems.concat(this.folderGridLayoutItems)
      .concat(this.fileGridLayoutItems);
    const multiAreaLayoutItemsOutOfGrid: GridLayoutItemInfo[] =
      this.extractMultiAreaLayoutItemsOutOfGrid(multiAreaLayoutItems, gridRows, gridColumns);
    const singleAreaLayoutItemsOutOfGrid: GridLayoutItemInfo[] =
      this.extractSingleAreaLayoutItemsOutOfGrid(singleAreaLayoutItems, gridRows, gridColumns);
    log.showInfo(`multi area layout items out Of grid length is ${multiAreaLayoutItemsOutOfGrid.length},
      single area layout items out of grid length is ${singleAreaLayoutItemsOutOfGrid.length}`);

    const girdOccupyArray: boolean[][] = this.createMatrixAndInit<boolean>(gridRows, gridColumns, false);
    const availableRow: number[] = new Array(gridColumns).fill(0);

    singleAreaLayoutItems.forEach((singleAreaLayoutItem) => {
      girdOccupyArray[Number(singleAreaLayoutItem.row)][Number(singleAreaLayoutItem.column)] = true;
    });
    multiAreaLayoutItems.forEach((multiAreaLayoutItem) => {
      if (!multiAreaLayoutItem.area) {
        log.showError('adjustOutOfGridItems invalid multiAreaLayoutItem.area');
        return;
      }
      this.markOccupied(Number(multiAreaLayoutItem.row), Number(multiAreaLayoutItem.column),
        multiAreaLayoutItem.area[0], multiAreaLayoutItem.area[1], girdOccupyArray);
    });

    for (let column = 0; column < gridColumns; column++) {
      for (let row = 0; row < gridRows; row++) {
        if (!girdOccupyArray[row][column]) {
          availableRow[column] = row;
          break;
        }
      }
    }
    const insertMultiAreaLayoutItemsRet: boolean =
      this.insertMultiAreaLayoutItemsOutOfGrid(multiAreaLayoutItemsOutOfGrid, gridRows, gridColumns, girdOccupyArray,
        availableRow);
    const insertSingleAreaLayoutItemsRet: boolean =
      this.insertSingleAreaLayoutItemsOutOfGrid(singleAreaLayoutItemsOutOfGrid, gridRows, gridColumns, girdOccupyArray);
    log.showInfo(`the insertMultiAreaLayoutItemsRet is ${insertMultiAreaLayoutItemsRet},
      and the insertSingleAreaLayoutItemsRet is ${insertSingleAreaLayoutItemsRet}`);
    if (insertMultiAreaLayoutItemsRet && insertSingleAreaLayoutItemsRet) {
      let newGridLayoutItems: GridLayoutItemInfo[] =
        multiAreaLayoutItems.concat(multiAreaLayoutItemsOutOfGrid).concat(singleAreaLayoutItems)
          .concat(singleAreaLayoutItemsOutOfGrid);
      LaunchLayoutCacheManager.getInstance().updateGridLayoutItems(newGridLayoutItems,
        BusinessType.BUSINESS_BASIC_DESKTOP, true);
      log.showInfo(`adjust out of grid items success`);
      return true;
    }

    log.showInfo('adjust out of grid items failed');
    return false;
  }

  private placeOverFlowLayoutItems(overFlowLayoutItems: GridLayoutItemInfo[], gridRows: number,
    gridColumns: number): void {
    let row = gridRows + 1;
    overFlowLayoutItems.forEach((item) => {
      item.row = row;
      item.column = gridColumns + 1;
      if (!item.area) {
        log.showError('placeOverFlowLayoutItems invalid item.area');
        return;
      }
      row += item.area[1];
    });
  }

  private reOrderGridLayoutItems(gridRows: number, gridColumns: number): void {
    log.showInfo('reOrder gird layout items');
    this.clearSortParam();
    let ret: boolean = this.prepareSortParam();
    if (!ret) {
      this.clearSortParam();
      return;
    }

    const girdOccupyArray: boolean[][] = this.createMatrixAndInit<boolean>(gridRows, gridColumns, false);
    const availableRow: number[] = new Array(gridColumns).fill(0);
    const multiAreaLayoutItems: GridLayoutItemInfo[] =
      this.cardGridLayoutItems.concat(this.regionFolderGridLayoutItems);
    let singleAreaLayoutItems: GridLayoutItemInfo[] =
      this.fileGridLayoutItems.concat(this.folderGridLayoutItems)
        .concat(this.appGridLayoutItems);

    const overFlowMultiAreaLayoutItems: GridLayoutItemInfo[] =
      this.reorderMultiAreaLayoutItems(multiAreaLayoutItems, gridRows, gridColumns, girdOccupyArray, availableRow);
    const overFlowSingleAreaLayoutItems: GridLayoutItemInfo[] =
      this.placeSingleAreaLayoutItems(singleAreaLayoutItems, gridRows, gridColumns, girdOccupyArray);

    const overFlowLayoutItems: GridLayoutItemInfo[] =
      overFlowMultiAreaLayoutItems.concat(overFlowSingleAreaLayoutItems);
    this.placeOverFlowLayoutItems(overFlowLayoutItems, gridRows, gridColumns);
    let newGridLayoutItems: GridLayoutItemInfo[] =
      multiAreaLayoutItems.concat(singleAreaLayoutItems).concat(overFlowLayoutItems);
    LaunchLayoutCacheManager.getInstance().updateGridLayoutItems(newGridLayoutItems,
      BusinessType.BUSINESS_BASIC_DESKTOP, true);
  }

  public placeGridLayoutItems(): void {
    log.showInfo(`desktopTrim on screen id change`);
    const pageDesktopGridStyleConfig: PageDesktopGridStyleConfig = this.getPageDesktopStyleConfig();
    const gridRows: number = pageDesktopGridStyleConfig.mRows;
    const gridColumns: number = pageDesktopGridStyleConfig.mColumns;

    if (!this.adjustOutOfGridItems(gridRows, gridColumns)) {
      this.reOrderGridLayoutItems(gridRows, gridColumns);
    }
    this.mPageDesktopViewModel.initGridList();
    this.clearSortParam();
  }

  /**
   * 注册监听折叠屏中轴区提示
   * @returns
   */
  private registerCreaseRegionTipCallback(offsetY: number, uiContext: UIContext): void {
    this.unRegisterCreaseRegionTipCallback();
    this.creaseRegionTipSubscriber = CommonEventManager.createSubscriberSync({
      events: [EVENT_CREASE_REGION_TIP],
      publisherPermission: 'ohos.permission.RECEIVER_STARTUP_COMPLETED',
    });
    try {
      CommonEventManager.subscribe(this.creaseRegionTipSubscriber,
        (err: BusinessError, data: CommonEventManager.CommonEventData) => {
          if (err) {
            log.showError(`CreaseRegionTipCallback callback failed, ${err.code}, ${err.message}`);
            return;
          }
          log.showInfo(`CreaseRegionTipCallback success ${offsetY}`);
          uiContext.getPromptAction()?.showToast({
            message: this.mResourceManager.getStringByName('crease_region_tip'),
            duration: 2000,
            bottom: LayoutViewModel.getInstance().getDockHeight() + CommonConstants.TOAST_SHOW_DEFAULT_HEIGHT + offsetY
          });
        }
      );
      log.showInfo(`registerCreaseRegionTipCallback success ${offsetY}`);
    } catch (error) {
      log.showError(`registerCreaseRegionTipCallback error ${error?.code}, ${error?.message}`);
    }
  }

  /**
   * 取消注册监听折叠屏中轴区提示
   */
  public unRegisterCreaseRegionTipCallback(): void {
    if (this.creaseRegionTipSubscriber) {
      try {
        CommonEventManager.unsubscribe(this.creaseRegionTipSubscriber);
        this.creaseRegionTipSubscriber = null;
      } catch (err) {
        log.error(`unRegisterCreaseRegionTipCallback unsubscribe error ${err?.code}, ${err?.message}`);
      }
    }
  }

}