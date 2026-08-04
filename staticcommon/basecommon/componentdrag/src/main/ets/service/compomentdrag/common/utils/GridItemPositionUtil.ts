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
import { RTLUtil } from '@ohos/componenthelper';
import { DragGridItem, DragGridParam, DragGridPosition, DragPosition, RealPaddingParam } from '../type/CommonTypes';

const TAG: string = 'GridItemPositionUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);
const DEL: number = px2vp(1);
const DEL2: number = px2vp(0.5);
const DEL4: number = px2vp(0.25);

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
   * 宫格总高度
   */
  private itemHeight: number = 0;

  /**
   * 宫格总宽度
   */
  private gridWidth: number = 0;

  /**
   * 宫格元素高度
   */
  private gridHeight: number = 0;
  /**
   * 总行数
   */
  private row: number = 0;

  /**
   * 总列数
   */
  private column: number = 0;
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
    log.showInfo(`initPosition:${JSON.stringify(gridParam)}`);
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
    this.row = gridParam.row;
    this.column = gridParam.column;
    this.gridWidth = gridParam.gridWidth;
    this.gridHeight = gridParam.gridHeight;
    log.showInfo(`initPosition result:${this.offsetX}； ${this.offsetY}`);
  }

  /**
   * 初始化宫格位置数组，根据宫格参数进行取整计算得到左上角的坐标缓存到数组中
   *
   * @param gridParam 宫格参数
   * @param realPadding grid控件上的padding属性
   * @param centerX 宫格左上角到宫格元素中心点的x方向的距离，若不设置则默认为宫格宽度的一半
   * @param centerY 宫格左上角到宫格元素中心点的y方向的距离，若不设置则默认为宫格高度的一半
   */
  public initPositionRound(gridParam: DragGridParam, realPadding: RealPaddingParam, centerX?: number,
    centerY?: number): void {
    if (gridParam.column <= 0 || gridParam.row <= 0) {
      log.showError(`cannot init position: invalid param column:${gridParam.column} row:${gridParam.row}`);
      return;
    }
    let gridWidth = gridParam.gridWidth - px2vp(Math.floor(vp2px(realPadding.paddingLeft))) -
      px2vp(Math.floor(vp2px(realPadding.paddingRight)));
    let gridHeight = gridParam.gridHeight - px2vp(Math.floor(vp2px(realPadding.paddingTop))) -
      px2vp(Math.floor(vp2px(realPadding.paddingBottom)));
    this.itemWidth = (gridWidth - gridParam.columnGap * (gridParam.column - 1)) / gridParam.column;
    this.itemHeight = (gridHeight - gridParam.rowGap * (gridParam.row - 1)) / gridParam.row;
    this.itemWidth = this.getRoundNum2(this.itemWidth);
    this.itemHeight = this.getRoundNum2(this.itemHeight);

    this.rowGap = this.getRoundNum2(gridParam.rowGap);
    this.columnGap = this.getRoundNum2(gridParam.columnGap);

    this.calOffset(this.offsetX, this.itemWidth, this.columnGap, gridParam.column, gridParam.gridWidth);

    this.calOffset(this.offsetY, this.itemHeight, this.rowGap, gridParam.row, gridParam.gridHeight);

    this.centerX = centerX ?? (this.itemWidth / 2);
    this.centerY = centerY ?? (this.itemHeight / 2);
    this.paddingLeft = gridParam.paddingLeft;
    this.paddingTop = gridParam.paddingTop;
  }

  private calOffset(offset: number[], size: number, gap: number, count: number, gridSize: number): void {
    offset[0] = 0;
    let itemSize: number = px2vp(Math.round(vp2px(size)));
    let itemGap: number = px2vp(Math.round(vp2px(gap)));
    let gridSizeRound: number = px2vp(Math.round(vp2px(gridSize)));
    let diffSize: number = gridSizeRound - gridSize;
    log.showInfo(`calOffset start diffSize: ${vp2px(diffSize)}`);
    let delMax: number = diffSize > DEL4 ? DEL : DEL2;
    let delMin: number = diffSize > DEL4 ? 0 : -DEL2;
    for (let i = 1; i < count; i++) {
      offset[i] = offset[i - 1];
      diffSize += size - itemSize;
      log.showInfo(`calOffset widthPx diffSize: ${vp2px(diffSize)} index: ${i}`);

      // 针对宫格进行计算时会优先保证宫格的大小尽量一致，仅当当前偏差量超过阈值的时候才进行增减
      if (diffSize >= delMax) {
        diffSize -= DEL;
        offset[i] += DEL;
      } else if (diffSize < delMin) {
        diffSize += DEL;
        offset[i] -= DEL;
      }
      offset[i] = offset[i] + itemSize;
      log.showInfo(`calOffset widthPx offsetX: ${vp2px(offset[i])} index: ${i}`);

      if (itemGap === 0) {
        continue;
      }
      diffSize += gap - itemGap;
      log.showInfo(`calOffset gapPx diffSize: ${vp2px(diffSize)} index: ${i}`);

      // 针对宫格间距进行计算时需对下一个宫格的大小进行偏差补齐，如果下一个宫格计算会超过阈值则对偏差进行增减，保证宫格大小尽量一致
      if (diffSize >= delMax) {
        diffSize -= DEL;
        offset[i] += DEL;
      } else if (diffSize < delMin) {
        diffSize += DEL;
        offset[i] -= DEL;
      } else if (diffSize < 0 && diffSize + size - itemSize < delMin) {
        diffSize += DEL;
        offset[i] -= DEL;
      } else if (diffSize > 0 && diffSize + size - itemSize > delMax) {
        diffSize -= DEL;
        offset[i] += DEL;
      }
      offset[i] = offset[i] + itemGap;
      log.showInfo(`calOffset gapPx offsetX: ${vp2px(offset[i])} index: ${i}`);
    }
  }

  /**
   * 获取vp对应的px进行小数点后两位四舍五入后对应vp值
   *
   * @param size
   * @returns
   */
  private getRoundNum2(size: number): number {
    let size_px = Math.round(vp2px(size) * 100) / 100;
    return px2vp(size_px);
  }

  /**
   * 初始化宫格位置数组，强制指定宫格中的item大小进行计算得到左上角的坐标缓存到数组中
   *
   * @param gridParam 宫格参数
   * @param itemWidth 宫格左上角到宫格元素中心点的x方向的距离，若不设置则默认为宫格宽度的一半
   * @param itemHeight 宫格左上角到宫格元素中心点的y方向的距离，若不设置则默认为宫格高度的一半
   */
  public initPositionPx(gridParam: DragGridParam, itemWidth: number, itemHeight: number ): void {
    if (gridParam.column <= 0 || gridParam.row <= 0) {
      log.showError(`cannot init position: invalid param column:${gridParam.column} row:${gridParam.row}`);
      return;
    }
    this.itemWidth = itemWidth;
    this.itemHeight = itemHeight;
    this.centerX = this.itemWidth / 2;
    this.centerY = this.itemHeight / 2;
    this.paddingLeft = gridParam.paddingLeft;
    this.paddingTop = gridParam.paddingTop;

    let colGap: number = itemWidth * gridParam.column + gridParam.columnGap * (gridParam.column - 1) - gridParam.gridWidth;
    let rowGap: number = itemHeight * gridParam.row + gridParam.rowGap * (gridParam.row - 1) - gridParam.gridHeight;
    this.rowGap = gridParam.rowGap - rowGap / gridParam.row;
    this.columnGap = gridParam.columnGap - colGap / gridParam.column;

    this.setOffset(this.offsetX, itemWidth, this.columnGap, gridParam.column);
    this.setOffset(this.offsetY, itemHeight, this.rowGap, gridParam.row);
  }

  private setOffset(offset: number[], size: number, gap: number, length: number): void {
    offset[0] = 0;
    let sizePx: number = vp2px(size);
    let gapPx: number = vp2px(gap);
    for (let i = 1; i < length; i++) {
      offset[i] = offset[i - 1] + sizePx + gapPx;
    }
    for (let i = 0; i < length; i++) {
      offset[i] = px2vp(offset[i]);
    }
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
    log.showInfo(`getPosition X: ${this.offsetX} Y: ${this.offsetY}; ${gridPosition.column},${gridPosition.row};${left},${top}`);
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
   * @param isRealCenter 是否获取指定area的真正中心点
   * @returns 宫格元素的中心点坐标
   */
  public getCenterPosition(gridItem: DragGridItem, paddingLeft?: number, paddingTop?: number, isRealCenter?: boolean): DragPosition {
    let position: DragPosition = { x: -1, y: -1 };
    if (gridItem.column == null || gridItem.row == null) {
      log.showError(`cannot get center position: column or row is null`);
      return position;
    }
    let width: number = gridItem.area?.[0] ?? 1;
    let height: number = gridItem.area?.[1] ?? 1;
    if (gridItem.column < 0 || gridItem.row < 0 ||
      gridItem.column + width > this.offsetX.length || gridItem.row + height > this.offsetY.length) {
      log.showError(`cannot get center position: invalid param column:${gridItem.column} row:${gridItem.row} width:${width} height:${height}`);
      return position;
    }
    let left: number = paddingLeft ?? this.paddingLeft;
    let top: number = paddingTop ?? this.paddingTop;
    log.showInfo(`getCenterPosition X: ${this.offsetX},Y: ${this.offsetY} area: ${gridItem.area} left:${left} isRealCenter:${isRealCenter}`);
    if (isRealCenter) {
      // 定制卡中心点为真正的宫格中心点,故x为第二个宫格起点加上宫格布局距离屏幕左侧边距,y为宫格中心点距离屏幕顶部的高度
      position.x = this.offsetX[2] + left;
      position.y = (this.offsetY[gridItem.row] + this.offsetY[gridItem.row + height - 1]) / 2 + this.itemHeight / 2 + top;
    } else {
      position.x = (this.offsetX[gridItem.column] + this.offsetX[gridItem.column + width - 1]) / 2 + this.centerX + left;
      position.y = (this.offsetY[gridItem.row] + this.offsetY[gridItem.row + height - 1]) / 2 + this.centerY + top;
    }
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
    if (RTLUtil.isRTL()) {
      column = this.offsetX.length - 1 - column;
    }
    return { row: row, column: column };
  }

  /**
   * @param x 拖拽元素x轴坐标
   * @param y 拖拽元素y轴坐标
   * @returns 拖拽元素所在宫格的行列及页码
   */
  public getRowAndColumnAndPage(x: number, y: number, paddingLeft?: number, paddingTop?: number, isPortrait?: boolean): DragGridPosition {
    const position: DragGridPosition = this.getRowAndColumn(x, y, paddingLeft, paddingTop);
    const row = position.row;
    const column = position.column;
    if (isPortrait) {
      return paddingTop === undefined ? {row: row, column: column, page: 0} : {row: row, column: column, page: 1};
    }
    return paddingLeft === undefined ? {row: row, column: column, page: 0} : {row: row, column: column, page: 1};
  }

  public setPaddingLeft(paddingLeft: number): boolean {
    this.paddingLeft = paddingLeft;
    return true;
  }

  public setPaddingTop(paddingTop: number): boolean {
    this.paddingTop = paddingTop;
    return true;
  }

  public getPaddingLeft(): number {
    return this.paddingLeft;
  }

  public getPaddingTop(): number {
    return this.paddingTop;
  }

  public getItemWidth(): number {
    return this.itemWidth;
  }

  public getItemHeight(): number {
    return this.itemHeight;
  }

  public getGridWidth(): number {
    return this.gridWidth;
  }

  public getGridHeight(): number {
    return this.gridHeight;
  }

  public getRow(): number {
    return this.row;
  }

  public getColumn(): number {
    return this.column;
  }

  public getColumnGap(): number {
    return this.columnGap;
  }

  public getRowGap(): number {
    return this.rowGap;
  }

  /**
   * 获取所有网格元素的位置 从上到下，从左到右
   * @returns
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