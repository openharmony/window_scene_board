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
import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import { CellAndSpan, CellLayoutDragDelegate, GridItemPositionUtil } from '../../../../../TsIndex';
import { DragGridItem, DragGridPosition } from '../../../common/type/CommonTypes';
import { DragUtils } from '../../../common/utils/DragUtils';
import { SqueezeResult } from '../../../common/type/SqueezeTypes';
import { Engine } from '../Engine';

const TAG = 'SingleItemSqueezeEngine';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 单元素挤位引擎
 *
 * @since 2024/04/28
 */
export class SingleItemSqueezeEngine extends Engine {
  /**
   * 宫格位置计算工具类
   */
  protected positionUtil: GridItemPositionUtil = new GridItemPositionUtil();

  /**
   * 计算挤位结果
   *
   * @param x 被拖拽item的x坐标
   * @param y 被拖拽item的y坐标
   * @returns 挤位结果 DragGridItem:被挤位元素, SqueezeResult:被挤位元素对应宫格的起点和终点的行列值
   */
  public computeSqueezeResult(x: number, y: number, isZSqueeze: boolean): Map<DragGridItem, SqueezeResult> {
    this.moveItemTranslateList.clear();
    if (!this.updateSqueezeParam()) {
      return this.moveItemTranslateList;
    }
    this.computeSingleItemSqueeze(x, y, isZSqueeze);
    return this.moveItemTranslateList;
  }

  private computeSingleItemSqueeze(x: number, y: number, isZSqueeze: boolean): void {
    log.showDebug('in computeSingleItemSqueeze');
    const dragDelegate: CellLayoutDragDelegate = CellLayoutDragDelegate.getInstance(this.gridParam);
    const cellAndSpan: CellAndSpan = new CellAndSpan(x, y, this.dragItem.area[0], this.dragItem.area[1]);
    const result: number[] = dragDelegate.findNearestArea(cellAndSpan);
    const nearestPosition: DragGridPosition = { row: result[1], column: result[0] };

    // 拖拽元素和被挤位元素的面积中，如果有不为1x1的，调用多元素挤位算法
    let coveredItem: DragGridItem = DragUtils.getCoveredItem(this.layout, this.dragItem, nearestPosition);
    if (coveredItem == null || !DragUtils.isGridItem1x1(coveredItem) ||
      !DragUtils.isGridItem1x1(this.dragItem)) {
      log.showInfo('cannot use singleItemSqueeze');
      return;
    }

    this.positionUtil.initPosition(this.gridParam);
    const position: DragGridPosition = this.positionUtil.getRowAndColumn(x, y);
    const dragItemIndex: number = this.getItemIndex(position, isZSqueeze);
    let isSqueezeBackwards: boolean = this.getSqueezeDirection(x, y, isZSqueeze, nearestPosition);
    if (!this.computeSqueezedMoveItemList(isSqueezeBackwards, isZSqueeze, dragItemIndex)) {
      log.showInfo('computeSqueezedMoveItemList squeeze fail');
      this.moveItemTranslateList.clear();
    }
  }

  /**
   * 获取挤位方向
   *
   * @param x x坐标
   * @param y y坐标
   * @param isZSqueeze 是否是Z字形挤位
   * @param position 距离被拖拽元素最近的宫格位置坐标
   * @returns true:往后挤位（向远离坐标原点的方向挤位）; false:往前挤位
   */
  protected getSqueezeDirection(x: number, y: number, isZSqueeze: boolean, position: DragGridPosition): boolean {
    return true;
  }

  private getItemByIndex(index: number, isZSqueeze: boolean): DragGridItem {
    const column = isZSqueeze ? index % this.gridParam.column : Math.floor(index / this.gridParam.row);
    const row = isZSqueeze ? Math.floor(index / this.gridParam.column) : index % this.gridParam.row;
    const itemInfo = this.layout.find(item => {
      if (DragUtils.isGridItem1x1(item)) {
        return item.column === column && item.row === row;
      } else {
        return this.isItemInRowColumn(row, column, item);
      }
      return false;
    });
    log.showInfo('get item by index: %{public}d, index position: [%{public}d, %{public}d]' +
      ', item position: [%{public}d, %{public}d], item area: [%{public}d, %{public}d]',
      index, column, row, itemInfo?.column, itemInfo?.row, itemInfo?.area?.[0], itemInfo?.area?.[1]);
    return itemInfo;
  }

  // 根据item的行列获取item的索引
  private getItemIndex(position: DragGridPosition, isZSqueeze: boolean): number {
    const row: number = position.row;
    const column: number = position.column;
    const totalRow: number = this.gridParam.row;
    const totalColumn: number = this.gridParam.column;
    let itemIndex = isZSqueeze ? row * totalColumn + column : column * totalRow + row;
    log.showInfo('get item index by position: [%{public}d, %{public}d], total row: %{public}d, ' +
      'total column: %{public}d, item index: %{public}d', column, row, totalRow, totalColumn, itemIndex);
    return itemIndex;
  }

  // 计算被挤位元素，在挤位前后的位置信息，并存入map中
  private computeSqueezedMoveItemList(isSqueezeBackwards: boolean, isZSqueeze: boolean, itemIndex: number): boolean {
    // 计算挤位序列
    let squeezeIndexList = this.initialSqueezeSequence(isSqueezeBackwards, itemIndex);
    let startSqueezeIndex: number = squeezeIndexList[0];
    let endSqueezeIndex: number = squeezeIndexList[1];
    // 计算最终的挤位序列和挤位后的位置
    for (let i = startSqueezeIndex; isSqueezeBackwards ? i <= endSqueezeIndex : i >= endSqueezeIndex;
         isSqueezeBackwards ? i++ : i--) {
      let thisItem = this.getItemByIndex(i, isZSqueeze);
      // 如果当前位置的item为空，则不需要计算挤位后的位置
      if (CheckEmptyUtils.isEmpty(thisItem)) {
        endSqueezeIndex = isSqueezeBackwards ? i - 1 : i + 1;
        log.showDebug(`thisItem is blank, index=${i}`);
        break;
      }
      // 如果当前item为大文件夹或者卡片，不会被挤位
      if (!DragUtils.isGridItem1x1(thisItem)) {
        log.showInfo('thisItem is card or bigFolder');
        continue;
      }

      // 计算挤位前的位置信息
      let itemRow = thisItem.row;
      let itemColumn = thisItem.column;
      let originPosition: DragGridPosition = { row: itemRow, column: itemColumn };
      log.showDebug('computeSqueezedMoveItemList, oldRow: %{public}d, oldColumn: %{public}d', itemRow, itemColumn);

      // 计算挤位后的位置信息
      let squeezedPosition: DragGridPosition =
        this.computeSqueezedPosition(itemRow, itemColumn, isSqueezeBackwards, isZSqueeze);
      itemRow = squeezedPosition.row;
      itemColumn = squeezedPosition.column;
      if (!this.isValidIndex(itemRow, this.gridParam.row) || !this.isValidIndex(itemColumn, this.gridParam.column)) {
        log.showInfo('row or column will be exceed');
        return false;
      }
      let targetPosition: DragGridPosition = { row: itemRow, column: itemColumn };
      log.showDebug('computeSqueezedMoveItemList, newRow: %{public}d, newColumn: %{public}d', itemRow, itemColumn);

      let squeezeResult: SqueezeResult = { origin: originPosition, target: targetPosition };
      this.moveItemTranslateList.set(thisItem, squeezeResult);
    }
    return true;
  }

  private isValidIndex(index, totalIndex): boolean {
    return index >= 0 && index <= totalIndex - 1;
  }

  // 计算初始的挤位序列
  private initialSqueezeSequence(isSqueezeBackwards: boolean, itemIndex: number): number[] {
    let startSqueezeIndex: number;
    let endSqueezeIndex: number;
    if (isSqueezeBackwards) {
      startSqueezeIndex = itemIndex;
      endSqueezeIndex = this.gridParam.row * this.gridParam.column - 1;
    } else {
      startSqueezeIndex = itemIndex;
      endSqueezeIndex = 0;
    }
    log.showDebug(`startSqueezeIndex:${startSqueezeIndex}, endSqueezeIndex:${endSqueezeIndex}`);
    return [startSqueezeIndex, endSqueezeIndex];
  }

  // 计算挤位后的位置信息
  private computeSqueezedPosition(itemRow: number, itemColumn: number, isSqueezeBackwards: boolean,
    isZSqueeze: boolean): DragGridPosition {
    let gridPosition: DragGridPosition = { row: itemRow, column: itemColumn };
    let itemInfo: DragGridItem = DragUtils.getCoveredItem(this.layout, this.dragItem, gridPosition);
    let squeezedPosition: DragGridPosition = { row: -1, column: -1 };
    if (CheckEmptyUtils.isEmpty(itemInfo)) {
      log.showInfo('computeSqueezedPosition, itemInfo is invalid');
      return squeezedPosition;
    }
    if (isSqueezeBackwards) {
      squeezedPosition = this.computeBackwardSqueeze(itemInfo, itemRow, itemColumn, isZSqueeze);
    } else {
      squeezedPosition = this.computeForwardSqueeze(itemInfo, itemRow, itemColumn, isZSqueeze);
    }
    return squeezedPosition;
  }

  private computeBackwardSqueeze(itemInfo: DragGridItem, itemRow: number, itemColumn: number,
    isZSqueeze: boolean): DragGridPosition {
    let count: number = 0;
    let tempPosition: DragGridPosition = { row: itemRow, column: itemColumn };
    while (count === 0 || !CheckEmptyUtils.isEmpty(itemInfo) && !DragUtils.isGridItem1x1(itemInfo)) {
      if (isZSqueeze) {
        if (itemColumn < this.gridParam.column - 1) {
          itemColumn = itemColumn + 1;
        } else {
          itemColumn = 0;
          itemRow = itemRow + 1;
        }
      } else {
        if (itemRow < this.gridParam.row - 1) {
          itemRow = itemRow + 1;
        } else {
          itemRow = 0;
          itemColumn = itemColumn + 1;
        }
      }
      tempPosition = { row: itemRow, column: itemColumn };
      itemInfo = DragUtils.getCoveredItem(this.layout, this.dragItem, tempPosition);
      count += 1;
      log.showDebug(`computeBackwardSqueeze, count:${count}, row:${itemRow}, column:${itemColumn}`);
    }
    return { row: itemRow, column: itemColumn };
  }

  private computeForwardSqueeze(itemInfo: DragGridItem, itemRow: number, itemColumn: number,
    isZSqueeze: boolean): DragGridPosition {
    let count: number = 0;
    let tempPosition: DragGridPosition = { row: itemRow, column: itemColumn };
    while (count === 0 || !CheckEmptyUtils.isEmpty(itemInfo) && !DragUtils.isGridItem1x1(itemInfo)) {
      if (isZSqueeze) {
        if (itemColumn > 0) {
          itemColumn = itemColumn - 1;
        } else {
          itemColumn = this.gridParam.column - 1;
          itemRow = itemRow - 1;
        }
      } else {
        if (itemRow > 0) {
          itemRow = itemRow - 1;
        } else {
          itemRow = this.gridParam.row - 1;
          itemColumn = itemColumn - 1;
        }
      }
      tempPosition = { row: itemRow, column: itemColumn };
      itemInfo = DragUtils.getCoveredItem(this.layout, this.dragItem, tempPosition);
      count += 1;
      log.showDebug(`computeForwardSqueeze, count:${count}, row:${itemRow}, column:${itemColumn}`);
    }
    return { row: itemRow, column: itemColumn };
  }

  // 判断元素是否在目标行列
  private isItemInRowColumn(row: number, column: number, item: DragGridItem): boolean {
    return item.column <= column && column < item.column + item.area[0] &&
      item.row <= row && row < item.row + item.area[1];
  }
}