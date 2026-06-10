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
import {
  RealPaddingParam,
  DragGridParam,
  DragGridPosition,
  DragItemPosition,
  DragPosition,
  GridItemPositionUtil
} from '@ohos/componentdrag';
import { AppItemInfo } from '@ohos/launchercommon/src/main/ets/bean/AppItemInfo';
import { Constants } from '../common/Constants';

const TAG = 'PcTrayGridLayoutUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const HALF_NUM: number = 2;

export default class PcTrayGridLayoutUtil {
  private static positionUtil: GridItemPositionUtil = new GridItemPositionUtil();

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

  private constructor() {
  }

  /**
   * 参数取整初始化
   * @param gridParam
   * @param realPadding
   * @param centerX
   * @param centerY
   */
  public static initGridPositionRound(gridParam: DragGridParam,
    realPadding: RealPaddingParam, centerX?: number, centerY?: number): void {
    log.showInfo('initGridPositionRound');
    PcTrayGridLayoutUtil.positionUtil.initPositionRound(gridParam, realPadding, centerX, centerY);
  }

  /**
   * 根据宫格行列值，获取宫格左上角坐标值
   * @param row
   * @param column
   * @param page
   * @returns
   */
  public static getGridItemPosition(row: number, column: number, page?: number): number[] {
    log.showInfo('getGridItemPosition');
    let position: DragPosition =
      PcTrayGridLayoutUtil.positionUtil.getPosition({
        row: row, column: column
      });
    let x: number = px2vp(Math.floor(vp2px(position.x)));
    let y: number = px2vp(Math.floor(vp2px(position.y)));
    return [x, y];
  }

  /**
   * 查询获取屏幕位置对应的宫格坐标
   * @param x
   * @param y
   * @returns
   */
  public static getRowAndColumn(x: number, y: number): DragGridPosition {
    return PcTrayGridLayoutUtil.positionUtil.getRowAndColumn(x, y);
  }

  /**
   * grid pos 关键信息
   * @param position
   * @returns
   */
  public static appGridPosToString(position: DragItemPosition): string {
    return position ? `x:${position.x}-y:${position.y}-row:${position.row}-column:${position.column}` : '';
  }

  /**
   * 网格初始化
   *
   * @param gridRows 最大行数
   * @param gridColumns 最大列数
   */
  public static initGridPosition(gridRows: number, gridColumns: number): void {
    log.showInfo(`initGridPosition row:${gridRows}, column:${gridColumns}`);
    PcTrayGridLayoutUtil.initGridPositionRound({
      // 配置整数
      paddingLeft: Constants.GRID_MARGIN_LR,
      // 配置整数
      paddingTop: Constants.GRID_MARGIN_TB,
      // 计算整数
      row: gridRows,
      // 计算整数
      column: gridColumns,
      // 配置整数
      rowGap: Constants.ROW_GAP,
      // 配置整数
      columnGap: Constants.COLUMN_GAP,
      // 计算值，不确保整数
      gridWidth: PcTrayGridLayoutUtil.getGridWidth(gridColumns),
      // 计算值，不确保整数
      gridHeight: PcTrayGridLayoutUtil.getGridHeight(gridRows)
    }, {
      paddingTop: 0,
      paddingBottom: 0,
      paddingLeft: 0,
      paddingRight: 0
    });
  }

  public static getWindowWidth(trayNum: number): number {
    let cols: number = (trayNum < Constants.MAX_COLUMNS) ? trayNum : Constants.MAX_COLUMNS;
    if (cols < Constants.MIN_COLUMNS) {
      cols = Constants.MIN_COLUMNS;
    }
    return cols * Constants.TRAY_ITEM_WIDTH + (cols - 1) * Constants.COLUMN_GAP + Constants.GRID_MARGIN_LR * 2;
  }

  public static getWindowHeight(trayNum: number): number {
    let rows: number = Math.ceil(trayNum / Constants.MAX_COLUMNS);
    if (rows < Constants.MIN_ROWS) {
      rows = Constants.MIN_ROWS;
    }
    return rows * Constants.TRAY_ITEM_HEIGHT + (rows - 1) * Constants.ROW_GAP + Constants.GRID_MARGIN_TB * 2;
  }

  public static getGridWidth(gridColumns: number): number {
    return Constants.TRAY_ITEM_WIDTH * gridColumns + Constants.COLUMN_GAP * (gridColumns - 1);
  }

  public static getGridHeight(gridRows: number): number {
    return Constants.TRAY_ITEM_HEIGHT * gridRows + Constants.ROW_GAP * (gridRows - 1);
  }

  public static getCols(tayNum: number): number {
    let cols: number = (tayNum < Constants.MAX_COLUMNS) ? tayNum : Constants.MAX_COLUMNS;
    if (cols < Constants.MIN_COLUMNS) {
      cols = Constants.MIN_COLUMNS;
    }
    return cols;
  }

  public static getRows(tayNum: number): number {
    let rows: number = Math.ceil(tayNum / Constants.MAX_COLUMNS);
    if (rows < Constants.MIN_ROWS) {
      rows = Constants.MIN_ROWS;
    }
    return rows;
  }

  /**
   * vp值取整, 后2位
   * @param size
   * @returns
   */
  public getRoundNum2(size: number): number {
    let sizePx = Math.round(vp2px(size) * 100) / 100;
    return px2vp(sizePx);
  }

  /**
   * vp取整
   * @param size
   * @returns
   */
  public getRoundNum(size: number): number {
    return px2vp(Math.round(vp2px(size)));
  }

  /**
   * 初始化宫格位置
   * @param gridParam
   * @param centerX
   * @param centerY
   */
  public initPosition(gridParam: DragGridParam, centerX?: number, centerY?: number ): void {
    if (gridParam.column <= 0 || gridParam.row <= 0) {
      log.showError(`cannot init position: invalid param column:${gridParam.column} row:${gridParam.row}`);
      return;
    }
    if (!this.itemWidth) {
      this.itemWidth = (gridParam.gridWidth - gridParam.columnGap * (gridParam.column - 1)) / gridParam.column;
    }
    if (!this.itemHeight) {
      this.itemHeight = (gridParam.gridHeight - gridParam.rowGap * (gridParam.row - 1)) / gridParam.row;
    }
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
    this.centerX = centerX ?? (this.itemWidth / HALF_NUM);
    this.centerY = centerY ?? (this.itemHeight / HALF_NUM);
    this.paddingLeft = gridParam.paddingLeft;
    this.paddingTop = gridParam.paddingTop;
    this.rowGap = gridParam.rowGap;
    this.columnGap = gridParam.columnGap;
  }

  /**
   * 获取图标位置
   * @param gridPosition
   * @param paddingLeft
   * @param paddingTop
   * @returns
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
   * 获取图标的行列
   * @param x
   * @param y
   * @param paddingLeft
   * @param paddingTop
   * @returns
   */
  public getRowAndColumn(x: number, y: number, paddingLeft?: number, paddingTop?: number): DragGridPosition {
    let row = this.offsetY.length - 1;
    let top: number = paddingTop ?? this.paddingTop;
    for (let index = 1; index < this.offsetY.length; index++) {
      if (top + this.offsetY[index] - this.rowGap / HALF_NUM > y) {
        row = index - 1;
        break;
      }
    }
    let column = this.offsetX.length - 1;
    let left: number = paddingLeft ?? this.paddingLeft;
    for (let index = 1; index < this.offsetX.length; index++) {
      if (left + this.offsetX[index] - this.columnGap / HALF_NUM > x) {
        column = index - 1;
        break;
      }
    }
    log.showInfo('position: [%{public}d, %{public}d], row: %{public}d, column: %{public}d', x, y, row, column);
    return { row: row, column: column };
  }
}