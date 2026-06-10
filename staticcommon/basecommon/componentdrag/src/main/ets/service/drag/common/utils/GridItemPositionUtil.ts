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
import { DragGridItem, DragGridParam, DragGridPosition, DragPosition } from '../type/CommonTypes';

const TAG: string = 'GridItemPositionUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 宫格位置计算工具类
 */
export class GridItemPositionUtil {
  /**
   * 缓存每个宫格左上角相对于第一个宫格左上角的x坐标，数组长度为宫格的最大列数
   */
  private offsetX: number[] = [];

  /**
   * 缓存每个宫格左上角相对于第一个宫格左上角的y坐标，数组长度为宫格的最大行数
   */
  private offsetY: number[] = [];

  /**
   * 宫格左上角到宫格元素中心点的x方向的距离
   */
  private centerX: number = 0;

  /**
   * 宫格左上角到宫格元素中心点的y方向的距离
   */
  private centerY: number = 0;

  /**
   * 第一个宫格左上角离屏幕左边缘的距离
   */
  private paddingLeft: number = 0;

  /**
   * 第一个宫格左上角离屏幕上边缘的距离
   */
  private paddingTop: number = 0;

  /**
   * 宫格元素宽度
   */
  private itemWidth: number = 0;

  /**
   * 宫格元素高度
   */
  private itemHeight: number = 0;

  /**
   * 宫格行间距
   */
  private rowGap: number = 0;

  /**
   * 宫格列间距
   */
  private columnGap: number = 0;

  /**
   * 初始化宫格位置数组，根据宫格参数计算得到左上角的坐标缓存到数组中
   *
   * @param gridParam 宫格参数
   * @param centerX 宫格左上角到宫格元素中心点的x方向的距离，若不设置则默认为宫格宽度的一半
   * @param centerY 宫格左上角到宫格元素中心点的y方向的距离，若不设置则默认为宫格高度的一半
   */
  public initPosition(gridParam: DragGridParam, centerX?: number, centerY?: number ): void {
    if (gridParam.column <= 0 || gridParam.row <= 0) {
      log.showError(`cannot init position: invalid param column:${gridParam.column} row:${gridParam.row}`);
      return;
    }
    this.itemWidth = (gridParam.gridWidth - gridParam.columnGap * (gridParam.column - 1)) / gridParam.column;
    this.itemHeight = (gridParam.gridHeight - gridParam.rowGap * (gridParam.row - 1)) / gridParam.row;
    this.offsetX = [];
    this.offsetY = [];
    this.offsetX[0] = 0;
    this.offsetY[0] = 0;
    for (let i = 1; i < gridParam.column; i++) {
      this.offsetX[i] = this.offsetX[i - 1] + this.itemWidth + gridParam.columnGap;
    }
    for (let i = 1; i < gridParam.row; i++) {
      this.offsetY[i] = this.offsetY[i - 1] + this.itemHeight + gridParam.rowGap;
    }
    this.centerX = centerX ?? (this.itemWidth / 2);
    this.centerY = centerY ?? (this.itemHeight / 2);
    this.paddingLeft = gridParam.paddingLeft;
    this.paddingTop = gridParam.paddingTop;
    this.rowGap = gridParam.rowGap;
    this.columnGap = gridParam.columnGap;
  }

  /**
   * 获取指定宫格的左上角的坐标，参数无效时返回值的x和y均为-1
   *
   * @param gridPosition 宫格位置
   * @param paddingLeft 第一个宫格左上角到屏幕左边缘的距离，若不设置则为初始化位置时设置的距离
   * @param paddingTop 第一个宫格左上角到屏幕上边缘的距离，若不设置则为初始化位置时设置的距离
   * @returns 宫格的左上角坐标
   */
  public getPosition(gridPosition: DragGridPosition, paddingLeft?: number, paddingTop?: number): DragPosition {
    if (gridPosition.column < 0 || gridPosition.row < 0 ||
      gridPosition.column >= this.offsetX.length || gridPosition.row >= this.offsetY.length) {
      log.showError(`cannot get position: invalid param column:${gridPosition.column} row:${gridPosition.row} `);
      return { x: -1, y: -1 };
    }
    let left: number = paddingLeft ?? this.paddingLeft;
    let top: number = paddingTop ?? this.paddingTop;
    return {
      x: this.offsetX[gridPosition.column] + left,
      y: this.offsetY[gridPosition.row] + top,
    };
  }

  /**
   * 获取指定宫格元素的中心点的坐标，宫格元素宽高若不设置则默认为1x1大小，行列参数无效时返回值的x和y均为-1
   *
   * @param gridItem 宫格元素信息
   * @param paddingLeft 第一个宫格左上角到屏幕左边缘的距离，若不设置则为初始化位置时设置的距离
   * @param paddingTop 第一个宫格左上角到屏幕上边缘的距离，若不设置则为初始化位置时设置的距离
   * @returns 宫格元素的中心点坐标
   */
  public getCenterPosition(gridItem: DragGridItem, paddingLeft?: number, paddingTop?: number): DragPosition {
    let position: DragPosition = { x: -1, y: -1 };
    if (gridItem.column == null || gridItem.row == null) {
      log.showError(`cannot get center position: column or row is null`);
      return position;
    }
    let width: number = gridItem.area?.[0] ?? 1;
    let height: number = gridItem.area?.[1] ?? 1;
    if (gridItem.column < 0 || gridItem.row < 0 ||
      gridItem.column + width > this.offsetX.length || gridItem.row + height > this.offsetY.length) {
      log.showError(`cannot get center position: invalid param column:${gridItem.column} row:${gridItem.row} ` +
        `width:${width} height:${height}`);
      return position;
    }
    let left: number = paddingLeft ?? this.paddingLeft;
    let top: number = paddingTop ?? this.paddingTop;
    position.x = (this.offsetX[gridItem.column] + this.offsetX[gridItem.column + width - 1]) / 2 +
      this.centerX + left;
    position.y = (this.offsetY[gridItem.row] + this.offsetY[gridItem.row + height - 1]) / 2 +
      this.centerY + top;
    return position;
  }

  /**
   * 根据坐标获取拖拽元素所在网格的行列
   *
   * @param x 拖拽元素x轴坐标
   * @param y 拖拽元素y轴坐标
   * @returns 拖拽元素所在宫格的行列
   */
  public getRowAndColumn(x: number, y: number, paddingLeft?: number, paddingTop?: number): DragGridPosition {
    // 计算item所在行，且行数位于【0,宫格总行数-1】
    let row = this.offsetY.length - 1;
    let top: number = paddingTop ?? this.paddingTop;
    for (let index = 1; index < this.offsetY.length; index++) {
      if (top + this.offsetY[index] - this.rowGap / 2 > y) {
        row = index - 1;
        break;
      }
    }
    // 计算item所在列，且列数位于【0,宫格总列数-1】
    let column = this.offsetX.length - 1;
    let left: number = paddingLeft ?? this.paddingLeft;
    for (let index = 1; index < this.offsetX.length; index++) {
      if (left + this.offsetX[index] - this.columnGap / 2 > x) {
        column = index - 1;
        break;
      }
    }
    log.showInfo('position: [%{public}d, %{public}d], row: %{public}d, column: %{public}d', x, y, row, column);
    return { row: row, column: column };
  }

  /**
   * 获取所有网格元素的位置 从上到下，从左到右
   * @returns 所有网格元素的位置
   */
  public getAllGridItemPosition(needCenterPosition: boolean = false): DragPosition[] {
    if (this.offsetX.length === 0 || this.offsetY.length === 0) {
      return undefined;
    }
    const offsetX = needCenterPosition ? this.centerX : 0;
    const offsetY = needCenterPosition ? this.centerY : 0;
    let list: DragPosition[] = [];
    for (let row = 0; row < this.offsetY.length; row++) {
      for (let col = 0; col < this.offsetX.length; col++) {
        list.push({
          x: this.paddingLeft + this.offsetX[col] + offsetX,
          y: this.paddingTop + this.offsetY[row] + offsetY
        });
      }
    }
    return list;
  }
}