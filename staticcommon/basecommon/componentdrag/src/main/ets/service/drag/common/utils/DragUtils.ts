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

import { DragEvent } from 'DragControllerParam';
import {
  DragGridItem,
  DragGridInfo,
  DragGridLayout,
  DragGridParam,
  DragPosition,
  DragGridPosition,
  DragCallbackParams,
} from '../../common/type/CommonTypes';
import CellLayoutDragDelegate from '../../../reorder/CellLayoutDragDelegate';
import CellAndSpan from '../../../reorder/CellAndSpan';
import GridOccupyStatus from '../../../reorder/GridOccupyStatus';

/**
 * 拖拽工具类
 */
export class DragUtils {
  /**
   * 拖拽元素的面积是否为 1x1
   *
   * @param dragItem 拖拽元素
   * @returns true 如果拖拽元素的面积为 1x1
   */
  public static isGridItem1x1(dragItem?: DragGridItem): boolean {
    return dragItem != null && dragItem.area != null && dragItem.area[0] === 1 && dragItem.area[1] === 1;
  }

  /**
   * 是否是有效拖拽元素信息
   *
   * @param dragItem 拖拽元素
   * @returns 是否是有效拖拽元素信息
   */
  public static isDragItemValid(dragItem?: DragGridItem): boolean {
    return dragItem != null && dragItem.row >= 0 && dragItem.column >= 0 && this.isAreaValid(dragItem.area);
  }

  /**
   * 是否是有效区域信息
   *
   * @param area 表示宫格元素的宽高占宫格的个数
   * @returns 是否是有效区域信息
   */
  public static isAreaValid(area?: number[]): boolean {
    return area != null && area.length === 2 && area[0] > 0 && area[1] > 0;
  }

  /**
   * 判断两个宫格位置是否相同
   *
   * @param ori 原始位置
   * @param other 另一个位置
   * @returns 两个宫格位置是否相同
   */
  public static isGridPositionEqual(ori?: DragGridPosition, other?: DragGridPosition): boolean {
    if (ori == null && other == null) {
      return true;
    }
    if (ori == null || other == null) {
      return false;
    }
    return ori.row === other.row && ori.column === other.column;
  }

  /**
   * 通过拖拽事件得到拖拽元素的中心点位置
   *
   * @param event 拖拽事件
   * @returns 拖拽元素的中心点位置坐标
   */
  public static getDragPosition(event: DragEvent): DragPosition {
    const rect = event.getPreviewRect();
    return {
      x: Number(rect.x) + Number(rect.width) / 2,
      y: Number(rect.y) + Number(rect.height) / 2,
    };
  }

  /**
   * 找到被覆盖的元素
   *
   * @param layout 宫格布局数组
   * @param dragItem 拖拽元素
   * @param gridPosition 拖拽的宫格位置
   * @returns 被覆盖的元素信息
   */
  public static getCoveredItem(layout: DragGridItem[], dragItem: DragGridItem,
    gridPosition: DragGridPosition): DragGridItem | undefined {
    for (let item of layout) {
      if (item.row == null || item.column == null || item.area == null) {
        return undefined;
      }
      if (item.column < (gridPosition.column + dragItem.area[0]) &&
        gridPosition.column < (item.column + item.area[0]) &&
        item.row < (gridPosition.row + dragItem.area[1]) &&
        gridPosition.row < (item.row + item.area[1])) {
        return item;
      }
    }
    return undefined;
  }

  /**
   * 计算当前页是否有空间容纳拖拽元素
   *
   * @param layout 当前页的布局数组(不包含被拖拽的元素）
   * @param dragItem 拖拽元素
   * @param row 宫格总行数
   * @param column 宫格总列数
   * @returns true:有空间，false无空间
   */
  public static hasEnoughArea(layout: DragGridItem[], dragItem: DragGridItem, row: number, column: number): boolean {
    if (!this.isDragItemValid(dragItem)) {
      return false;
    }
    let occupies: number = 0;
    layout.forEach(item => {
      occupies += item.area[0] * item.area[1];
    });
    let frees: number = row * column - occupies;
    let dragAreas: number = dragItem.area[0] * dragItem.area[1];
    if (frees >= dragAreas) {
      return true;
    }
    return false;
  }

  /**
   * 计算拖拽元素在当前宫格的最近落点
   *
   * @param event 拖拽事件
   * @param dragItem 拖拽元素信息
   * @param gridParam 宫格尺寸参数
   * @returns 最近落点宫格坐标
   */
  public static getNearestGridPosition(event: DragEvent,
    dragItem: DragGridItem, gridParam: DragGridParam): DragGridPosition {
    let position: DragPosition = this.getDragPosition(event);
    let cellAndSpan: CellAndSpan = new CellAndSpan(position.x, position.y, dragItem.area[0], dragItem.area[1]);
    let itemWidth: number = (gridParam.gridWidth - gridParam.columnGap * (gridParam.column - 1)) / gridParam.column;
    let itemHeight: number = (gridParam.gridHeight - gridParam.rowGap * (gridParam.row - 1)) / gridParam.row;
    let dragDelegate: CellLayoutDragDelegate = new CellLayoutDragDelegate(gridParam.paddingLeft, gridParam.paddingTop,
      gridParam.row, gridParam.column, itemWidth, itemHeight, gridParam.rowGap, gridParam.columnGap);
    let result: number[] = dragDelegate.findNearestArea(cellAndSpan);
    let gridPosition: DragGridPosition = {
      row: result[1],
      column: result[0],
    };
    return gridPosition;
  }

  /**
   * 计算拖拽元素在当前宫格的最近的可用落点
   *
   * @param dragItem 拖拽元素信息
   * @param gridParam 宫格尺寸参数
   * @param position 当前宫格的最近落点
   * @returns 可用落点宫格坐标
   */
  public static getAvailableGridPosition(dragItem: DragGridItem,
    gridLayout: DragGridLayout, position: DragGridPosition): DragGridPosition {
    let direction: number[] = [0, 0];
    let cellAndSpan: CellAndSpan = new CellAndSpan(position.column, position.row, dragItem.area[0], dragItem.area[1]);
    let gridParam: DragGridParam = gridLayout.gridParam;
    let itemWidth: number = (gridParam.gridWidth - gridParam.columnGap * (gridParam.column - 1)) / gridParam.column;
    let itemHeight: number = (gridParam.gridHeight - gridParam.rowGap * (gridParam.row - 1)) / gridParam.row;
    let dragDelegate: CellLayoutDragDelegate = new CellLayoutDragDelegate(gridParam.paddingLeft, gridParam.paddingTop,
      gridParam.row, gridParam.column, itemWidth, itemHeight, gridParam.rowGap, gridParam.columnGap);
    let gridOccupyStatus: GridOccupyStatus = dragDelegate.getGridOccupyStatus(gridLayout.layout);
    let result: number[] = dragDelegate.findNearestAreaTwo(cellAndSpan, direction, gridOccupyStatus, null, null);
    let gridPosition: DragGridPosition = {
      row: result[1],
      column: result[0],
    };
    return gridPosition;
  }

  /**
   * 获取拖拽回调通用参数
   *
   * @param event ArkUI事件的event参数
   * @param extraParams ArkUI事件的extraParams参数
   * @returns 拖拽回调通用参数
   */
  public static buildDragCallbackParams(event: DragEvent, extraParams?: string,
    dragInfo?: DragGridInfo, gridPosition?: DragGridPosition): DragCallbackParams {
    let dragPosition: DragPosition = this.getDragPosition(event);
    let dragCallbackParams: DragCallbackParams = {
      eventParams: {
        event: event,
        extraParams: extraParams,
      },
      dragInfo: dragInfo,
      position: dragPosition,
      gridPosition: gridPosition,
    };
    return dragCallbackParams;
  }
}