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
import { LogDomain, Logger, RectItem } from '@ohos/basicutils';
import { GridOccupyStatus, GridOccupyStatusEnum } from '@ohos/componentdrag';
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import { ItemLocation } from '@ohos/launchercommon/Index';

const TAG: string = 'PageFindPositionHelper';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 桌面Grid网格找位辅助类
 */
export class PageFindPositionHelper {

  private gridOccupyStatus: GridOccupyStatus;

  constructor(maxCol: number, maxRow: number) {
    this.gridOccupyStatus = new GridOccupyStatus(maxCol, maxRow, GridOccupyStatusEnum.FREE);
  }

  /**
   * 重置页面网格状态
   */
  public resetGridStatus(): void {
    this.gridOccupyStatus.markGridForRect(new RectItem(0, 0,
      this.gridOccupyStatus.getSizeX(), this.gridOccupyStatus.getSizeY()), GridOccupyStatusEnum.FREE);
  }

  /**
   * 标注多个布局元素在网格为已使用状态
   *
   * @param pageItems
   */
  public markMultiItemsPosition(pageItems: GridLayoutItemInfo[]) {
    for (let i = 0; i < pageItems.length; ++i) {
      let item = pageItems[i];
      this.markItemPosition(item);
    }
    log.showInfo(TAG, this.gridOccupyStatus.toString());
  }

  /**
   * 标注单个布局元素在网格为已使用状态
   *
   * @param item
   */
  public markItemPosition(item: GridLayoutItemInfo): boolean {
    log.showInfo(TAG, `markItemPosition ${item.bundleName}, ${item.column}, ${item.row}, ${item.area}`);
    if (item.column === undefined || item.row === undefined || item.area === undefined || item.area.length < 2) {
      log.showError(TAG, `markItemPosition ${item.bundleName}, ${item.column}, ${item.row}, ${item.area} error`);
      return false;
    }

    this.gridOccupyStatus.markGridForRect(new RectItem(item.column, item.row,
      item.column + item.area[0], item.row + item.area[1]), GridOccupyStatusEnum.OCCUPIED);
    return true;
  }

  /**
   * 当页寻找空位
   *
   * @param item 待摆放元素
   * @param itemLocation 如果找到位置,则刷新该入参对象find的位置
   * @returns 找位位置返回true; 无空位返回false;
   */
  public findBlankPosition(item: GridLayoutItemInfo, itemLocation: ItemLocation): boolean {
    if (item.column === undefined || item.row === undefined || item.area === undefined || item.area.length < 2) {
      log.showError(TAG, `findBlankPosition ${item.bundleName}, ${item.column}, ${item.row}, ${item.area} error`);
      return false;
    }

    let posAvailable = false;
    log.showInfo(TAG, `bundle:${item.bundleName}, startRow:${itemLocation.curRow}, startCol:${itemLocation.curCol}`);
    for (let r = itemLocation.curRow; r < this.gridOccupyStatus.getSizeY(); r++) {
      for (let c = 0; c < this.gridOccupyStatus.getSizeX(); c++) {
        if (this.gridOccupyStatus.isOccupied(c, r)) {
          continue;
        }

        // 检查是否有空位摆放元素
        posAvailable = this.gridOccupyStatus.checkAllStatusForGrid({
          startCellX: c,
          startCellY: r,
          spanX: item.area[0],
          spanY: item.area[1],
          status: GridOccupyStatusEnum.FREE
        });

        if (posAvailable) {
          itemLocation.findRow = r;
          itemLocation.findCol = c;
          itemLocation.findPage = itemLocation.curPage;
          if (item.area[0] === 1 && item.area[1] === 1) {
            itemLocation.curRow = r;
            itemLocation.curCol = c;
          }
          log.showInfo(TAG, `bundle:${item.bundleName} find [${itemLocation.findPage}, ${itemLocation.findRow}, ${itemLocation.findCol}]`);
          return true;
        }
      }
    }

    return false;
  }
}