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
import { DragGridParam, DragGridPosition, DragPosition, RealPaddingParam } from '@ohos/componentdrag';
import { RTLUtil } from '@ohos/componenthelper';

import { AppItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';

const TAG: string = 'CommonAppGridLayoutUtility';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DEL: number = px2vp(1);
const DEL2: number = px2vp(0.5);
const DEL4: number = px2vp(0.25);

/**
 * 通用宫格位置计算工具类
 */
export class CommonAppGridLayoutUtility {
  /**
   * 缓存每个宫格左上角相对于第一个宫格左上角的x坐标，数组长度为宫格的最大列数
   */
  protected offsetX: number[] = [];

  /**
   * 缓存每个宫格左上角相对于第一个宫格左上角的y坐标，数组长度为宫格的最大行数
   */
  protected offsetY: number[] = [];

  /**
   * 宫格左上角到宫格元素中心点的x方向的距离
   */
  protected centerX: number = 0;

  /**
   * 宫格左上角到宫格元素中心点的y方向的距离
   */
  protected centerY: number = 0;

  /**
   * 第一个宫格左上角离屏幕左边缘的距离
   */
  protected paddingLeft: number = 0;

  /**
   * 第一个宫格左上角离屏幕上边缘的距离
   */
  protected paddingTop: number = 0;

  /**
   * 宫格元素宽度
   */
  protected itemWidth: number = 0;

  /**
   * 宫格元素高度
   */
  protected itemHeight: number = 0;

  /**
   * 宫格行间距
   */
  protected rowGap: number = 0;

  /**
   * 宫格列间距
   */
  protected columnGap: number = 0;

  /**
   * Max Column count in a single page
   */
  public maxColumnCount = 7;

  /**
   * Max Column index in a row
   */
  public maxColumnIndex = 7;

  /**
   * Max Row count in a single page
   */
  public maxRowCount = 4;

  /**
   * 是否一屏一页：默认是一屏两页
   */
  protected singlePage: boolean = true;

  /**
   * 表格间距
   */
  protected gridSpace: number = 0;

  /**
   * 同屏第二页表格间距
   */
  protected nextPaddingTop: number = 0;

  /**
   * 初始化应用中心的宫格参数
   *
   * @param gridParam
   * @param realPadding
   */
  public initGridParameter(gridParam: DragGridParam, realPadding: RealPaddingParam, gridSpace?: number): void {
    if (gridParam.column <= 0 || gridParam.row <= 0) {
      log.showError(`cannot init position: invalid param column:${gridParam.column} row:${gridParam.row}`);
      return;
    }

    // 关键列参数设定
    this.maxColumnCount = gridParam.column > 0 ? gridParam.column : this.maxColumnCount;
    this.maxRowCount = gridParam.row > 0 ? gridParam.row : this.maxRowCount;
    this.maxColumnIndex = this.maxColumnCount - 1;
    log.showInfo(`initGridParameter-${this.maxColumnCount}-${this.maxRowCount}-${this.maxColumnIndex}`);

    // 水平方向 - 同一行 - 第一个元素左边到末尾元素右边之间的距离 - VP
    let gwInner = gridParam.gridWidth - this.doFloor(realPadding.paddingLeft) -
    this.doFloor(realPadding.paddingRight);

    // 垂直方向 - 同一列 - 第一个元素顶端到末尾元素底部之间的距离 - VP
    let ghInner = gridParam.gridHeight - this.doFloor(realPadding.paddingTop) -
    this.doFloor(realPadding.paddingBottom);

    // 网格单元格的宽高
    this.itemWidth = (gwInner - gridParam.columnGap * (gridParam.column - 1)) / gridParam.column;
    this.itemHeight = (ghInner - gridParam.rowGap * (gridParam.row - 1)) / gridParam.row;
    this.itemWidth = this.doRoundTwo(this.itemWidth);
    this.itemHeight = this.doRoundTwo(this.itemHeight);

    // 单元格间距
    this.rowGap = this.doRoundTwo(gridParam.rowGap);
    this.columnGap = this.doRoundTwo(gridParam.columnGap);

    // 计算横竖各自方向上的单元格相对偏移量
    this.calculateXYOffset(this.offsetX, this.itemWidth, this.columnGap, gridParam.column, gridParam.gridWidth);
    this.calculateXYOffset(this.offsetY, this.itemHeight, this.rowGap, gridParam.row, gridParam.gridHeight);

    this.centerX = this.itemWidth / 2;
    this.centerY = this.itemHeight / 2;
    this.paddingLeft = gridParam.paddingLeft;
    this.paddingTop = gridParam.paddingTop;

    log.showInfo(`initGridParameter-${gwInner}-${ghInner}-${this.itemWidth}-${this.itemHeight}-${this.rowGap}` +
      `-${this.columnGap}-${this.centerX}-${this.centerY}-${this.paddingLeft}-${this.paddingTop}-${this.offsetX}` +
      `-${this.offsetY}`);
  }

  protected calculateXYOffset(offset: number[], size: number, gap: number, count: number, gridSize: number): void {
    offset[0] = 0;
    let itemSize: number = this.doRound(size);
    let itemGap: number = this.doRound(gap);
    let gridSizeRound: number = this.doRound(gridSize);
    let diffSize: number = gridSizeRound - gridSize;
    log.showInfo(`calculateXYOffset start diffSize: ${vp2px(diffSize)}`);
    let delMax: number = diffSize > DEL4 ? DEL : DEL2;
    let delMin: number = diffSize > DEL4 ? 0 : -DEL2;
    for (let i = 1; i < count; i++) {
      offset[i] = offset[i - 1];
      diffSize += size - itemSize;
      log.showInfo(`calculateXYOffset widthPx diffSize: ${vp2px(diffSize)} index: ${i}`);

      // 针对宫格进行计算时会优先保证宫格的大小尽量一致，仅当当前偏差量超过阈值的时候才进行增减
      if (diffSize >= delMax) {
        diffSize -= DEL;
        offset[i] += DEL;
      } else if (diffSize < delMin) {
        diffSize += DEL;
        offset[i] -= DEL;
      }
      offset[i] = offset[i] + itemSize;
      log.showInfo(`calculateXYOffset widthPx offsetX: ${vp2px(offset[i])} index: ${i}`);

      if (itemGap === 0) {
        continue;
      }
      diffSize += gap - itemGap;
      log.showInfo(`calculateXYOffset gapPx diffSize: ${vp2px(diffSize)} index: ${i}`);

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
      log.showInfo(`calculateXYOffset gapPx offsetX: ${vp2px(offset[i])} index: ${i}`);
    }
  }

  /**
   * 根据xy值计算坐标
   * @param x
   * @param y
   * @param page
   * @returns
   */
  public getRowAndColumn(x: number, y: number, page?: number): DragGridPosition {
    // 计算item所在行，且行数位于【0,宫格总行数-1】
    let row = this.offsetY.length - 1;
    let top: number = this.getRealPaddingTop(page);
    log.showInfo(`getRowAndColumn2-${top}`);
    for (let index = 1; index < this.offsetY.length; index++) {
      if (top + this.offsetY[index] - this.rowGap / 2 > y) {
        row = index - 1;
        break;
      }
    }

    // 计算item所在列，且列数位于【0,宫格总列数-1】
    let column = this.offsetX.length - 1;
    let left: number = this.paddingLeft;
    for (let index = 1; index < this.offsetX.length; index++) {
      if (left + this.offsetX[index] - this.columnGap / 2 > x) {
        column = index - 1;
        break;
      }
    }

    log.showInfo('position: [%{public}d, %{public}d], row: %{public}d, column: %{public}d, top:%{public}d', x, y, row,
      column,
      top);
    if (RTLUtil.isRTL()) {
      column = this.offsetX.length - 1 - column;
    }

    return { row: row, column: column };
  }

  protected getRealPaddingTop(page?: number): number {
    return this.paddingTop;
  }

  /**
   * 通过行列号计算单元格的left top值
   * @param gridCoord
   * @returns
   */
  public getPosition(gridCoord: DragGridPosition, page?: number): DragPosition {
    if (gridCoord.column < 0 || gridCoord.row < 0 ||
      gridCoord.column >= this.offsetX.length || gridCoord.row >= this.offsetY.length) {
      log.showError(`cannot get position: invalid param column:${gridCoord.column} row:${gridCoord.row} `);
      return { x: -1, y: -1 };
    }

    let left: number = this.paddingLeft;
    let top: number = this.getRealPaddingTop(page);
    return {
      x: this.offsetX[gridCoord.column] + left,
      y: this.offsetY[gridCoord.row] + top,
    };
  }

  /**
   * 获取行、列信息
   *
   * @param appListInfo
   * @returns
   */
  public getGridLayoutOptions(appListInfo: AppItemInfo[], oldColMax?: number, newColMax?: number): GridLayoutOptions {
    if (CheckEmptyUtils.isEmpty(appListInfo)) {
      return { regularSize: [1, 1] };
    }

    return {
      onGetRectByIndex: (index: number): [number, number, number, number] => {
        if (index >= appListInfo.length) {
          return [-1, 1, -1, 1];
        }
        return [appListInfo[index].row ?? 0, appListInfo[index].column ?? 0, 1, 1];
      },
      regularSize: [1, 1]
    };
  }

  public setIsSinglePage(single: boolean): void {
    log.showInfo(`setIsSinglePage-${single}-${this.singlePage}`);
    this.singlePage = single;
  }

  /**
   * 是否一屏一页
   * @returns
   */
  public isSinglePage(): boolean {
    return this.singlePage;
  }

  /**
   * 附加偏移量-如：大屏幕机
   * @param space
   */
  public setExtraPaddingTopOffset(space: number): void {
  }
  /**
   * 精度处理-向下
   *
   * @param size
   * @returns
   */
  public doFloor(size: number): number {
    return px2vp(Math.floor(vp2px(size)));
  }

  /**
   * 精度处理-向上
   *
   * @param size
   * @returns
   */
  public doRound(size: number): number {
    return px2vp(Math.round(vp2px(size)));
  }

  /**
   * 精度处理-小数点后两位
   *
   * @param size
   * @returns
   */
  public doRoundTwo(size: number): number {
    let sizePx = Math.round(vp2px(size) * 100) / 100;
    return px2vp(sizePx);
  }
}