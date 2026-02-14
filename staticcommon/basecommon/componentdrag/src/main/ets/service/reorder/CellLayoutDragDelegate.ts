/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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

import { GridOccupyStatusEnum } from './GridOccupyStatus';
import ViewCluster from './ViewCluster';
import GridOccupyStatus from './GridOccupyStatus';
import ItemConfiguration from './ItemConfiguration';
import List from '@ohos.util.List';
import { RectItem } from '@ohos/basicutils';
import Stack from '@ohos.util.Stack';
import CellAndSpan from './CellAndSpan';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import { DragGridItem, DragGridParam } from '../compomentdrag/common/type/CommonTypes';
import { RTLUtil } from '@ohos/componenthelper';

const TAG = 'CellLayoutDragDelegate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default class CellLayoutDragDelegate {
  private mTempRectStack = new Stack<RectItem>();
  private mPaddingLeft: number;
  private mPaddingTop: number;
  private mRow: number;
  private mColumn: number;
  private mGridItemWidth: number;
  private mGridItemHeight: number;
  private mColumnsGap: number;
  private mRowsGap: number;
  private mDirectionVector: number[];
  private mIntersectingViews: List<DragGridItem> = new List();
  private mOccupiedRect: RectItem = new RectItem(0, 0, 0, 0);
  private reArrangeSolutionSuccess: boolean;
  private reNearArrangeSolutionSuccess: boolean = false;
  private mIconSize: number = 0;

  constructor(paddingLeft: number, paddingTop: number, row: number, column: number,
              gridItemWidth: number, gridItemHeight: number, rowsGap: number, columnsGap: number) {
    this.mPaddingLeft = paddingLeft;
    this.mPaddingTop = paddingTop;
    this.mRow = row;
    this.mColumn = column;
    this.mGridItemWidth = gridItemWidth;
    this.mGridItemHeight = gridItemHeight;
    this.mRowsGap = rowsGap;
    this.mColumnsGap = columnsGap;
  }

  /**
   * 根据宫格参数生成实例
   *
   * @param gridParam 宫格参数
   * @returns 拖拽委托类实例
   */
  public static getInstance(gridParam: DragGridParam): CellLayoutDragDelegate {
    if (gridParam != null) {
      return new CellLayoutDragDelegate(gridParam.paddingLeft, gridParam.paddingTop, gridParam.row, gridParam.column,
        gridParam.itemWidth, gridParam.itemHeight, gridParam.rowGap, gridParam.columnGap);
    }
    return null;
  }

  /**
   * 记录用于拖拽挤位的图标尺寸，当前仅在非PC设备的1*1元素拖拽场景中使用
   *
   * @param iconSize 用于拖拽挤位的图标尺寸
   */
  public recordIconSize(iconSize: number): void {
    this.mIconSize = iconSize;
  }

  /**
   *
   * @param x
   * @param y
   * @param isIgnoreOccupied 找寻的可用空位是否包含已经被占用的位置，true代表不能是已经被占用的位置，false代表可以是已
   *     经被占用的位置
   */
  public findNearestArea(cellAndSpan: CellAndSpan): number[] {
    let result: [number, number];
    let resultSpan: [number, number];
    this.lazyInitTempRectStack();
    // 对触点坐标信息进行一定程度的偏移，所有的距离运算都基于网格左上角进行
    let pixelX: number = cellAndSpan.getCellX();
    let pixelY: number = cellAndSpan.getCellY();
    let spanX: number = cellAndSpan.getSpanX();
    let spanY: number = cellAndSpan.getSpanY();

    // bestLocation用于保存最终的计算结果
    let bestDistance: number = Number.MAX_VALUE;
    let bestRect: RectItem = new RectItem(-1, -1, -1, -1);
    const validRegions: Stack<RectItem> = new Stack<RectItem>();
    let colRange: number[] = this.calculateNearestAreaRange(pixelX, spanX, true);
    let rowRange: number[] = this.calculateNearestAreaRange(pixelY, spanY, false);
    for (let i = rowRange[0]; i <= rowRange[1]; i++) {
      for (let j = colRange[0]; j <= colRange[1]; j++) {
        let cellCoords: number[];
        cellCoords = this.cellToCenterPoint(j, i, spanX, spanY);
        // 验证当前矩形不是以前任何候选矩形的子矩形,需要尽可能选择一个较大的矩形区域
        let currentRect: RectItem = this.mTempRectStack.pop();
        if (!currentRect) {
          continue;
        }
        currentRect.set(j, i, j - 1, i - 1);
        let isContained: boolean = this.isContained4FindNearestArea(validRegions, currentRect);
        validRegions.push(currentRect);
        let distance: number = Math.hypot(cellCoords[0] - pixelX, cellCoords[1] - pixelY);

        // 最佳落点有两种情况。第一种是所有网格均可用，这种情况下网格中心点与被拖拽View中心点距离最短的网格坐标
        // 即可。第二种情况是不能使用占用的网格区域，在这种情况下，可能需要对spanX或者spanY进行缩放，找到一个
        // 可用的位置。此时距离最短不再是唯一条件，尽可能使可用尺寸接近spanX和spanY同样是需要考虑的条件
        if ((distance <= bestDistance && !isContained) || currentRect.containsRect(bestRect)) {
          bestDistance = distance;
          result = [j, i];
          if (resultSpan != null) {
            resultSpan = [-1, -1];
          }
          bestRect.setRect(currentRect);
        }
      }
    }
    if (bestDistance === Number.MAX_VALUE) {
      result = [-1, -1];
    }
    this.recycleTempRects(validRegions);
    return result;
  }

  /**
   * 计算最佳落点的取值范围，减少循环次数
   *
   * @param pixel 拖拽元素中心
   * @param span 拖拽元素尺寸
   * @param direction 目标维度，true时计算列column，false时计算行row
   * @returns 目标维度的最佳落点取值范围
   */
  private calculateNearestAreaRange(pixel: number, span: number, direction: boolean): number[] {
    let padding: number = direction ? this.mPaddingLeft : this.mPaddingTop;
    let size: number = direction ? this.mGridItemWidth : this.mGridItemHeight;
    let gap: number = direction ? this.mColumnsGap : this.mRowsGap;
    let length = direction ? this.mColumn : this.mRow;
    // 当拖拽元素整体位于宫格内时，最近落点为元素左上角所处宫格或相邻宫格
    let startIndex: number = Math.floor((pixel - padding - (span * size - gap) / NumberConstants.CONSTANT_NUMBER_TWO) / (size + gap));
    let endIndex: number = startIndex + 1;
    // 当拖拽元素左上角位于宫格外时，最近落点为坐标0对应宫格
    if (startIndex < 0) {
      startIndex = 0;
      endIndex = 0;
    }
    // 当拖拽元素右上角位于宫格外时，最近落点为总数减去尺寸后对应宫格
    if (startIndex >= length - span) {
      startIndex = length - span;
      endIndex = length - span;
    }
    return [startIndex, endIndex];
  }

  public isReArrangeSolutionSuccess(): boolean {
    return this.reArrangeSolutionSuccess;
  }

  public isNearReArrangeSolutionSuccess(): boolean {
    return this.reNearArrangeSolutionSuccess;
  }

  private lazyInitTempRectStack(): void {
    if (this.mTempRectStack.isEmpty()) {
      for (let i = 0; i < this.mRow * this.mColumn; i++) {
        this.mTempRectStack.push(new RectItem(0, 0, 0, 0));
      }
    }
  }

  private recycleTempRects(used: Stack<RectItem>): void {
    while (!used.isEmpty()) {
      this.mTempRectStack.push(used.pop());
    }
  }

  /**
   * 给定网格坐标，返回CellLayout中该网格中心实际的坐标位置
   *
   * @param cellX X轴坐标
   * @param cellY Y轴坐标
   * @param spanX X轴尺寸
   * @param spanY Y轴尺寸
   * @param result 计算结果
   */
  public cellToCenterPoint(cellX: number, cellY: number, spanX: number, spanY: number): number[] {
    return this.regionToCenterPoint(cellX, cellY, spanX, spanY);
  }

  /**
   * 给定网格坐标，返回CellLayout中该网格中心实际的坐标位置
   *
   * @param cellX X轴坐标
   * @param cellY Y轴坐标
   * @param spanX X轴尺寸
   * @param spanY Y轴尺寸
   * @param result 计算结果
   */
  public regionToCenterPoint(cellX: number, cellY: number, spanX: number, spanY: number): number[] {
    const horizontalStartPadding: number = this.mPaddingLeft;
    const verticalStartPadding: number = this.mPaddingTop;
    let cellWidth: number = this.mGridItemWidth;
    let cellHeight: number = this.mGridItemHeight;
    let fixedCellX: number = cellX;
    if (spanX === 1 && spanY === 1 && this.mIconSize) {
      // 元素图片距离宫格顶部的距离
      const padding: number = AppStorage.get<number>('itemPadding') ?? 0;
      // 1*1的元素，使用新规格中铭取得图标图片中心点而非宫格中心点进行判断
      return [horizontalStartPadding + fixedCellX * cellWidth + (spanX * cellWidth - this.mColumnsGap) / 2,
        verticalStartPadding + cellY * cellHeight + padding + this.mIconSize / 2];
    }
    return [horizontalStartPadding + fixedCellX * cellWidth + (spanX * cellWidth - this.mColumnsGap) / 2,
      verticalStartPadding + cellY * cellHeight + (spanY * cellHeight - this.mRowsGap) / 2];
  }

  private isContained4FindNearestArea(validRegions: Stack<RectItem>, currentRect: RectItem): boolean {
    for (let rect of validRegions) {
      if (rect.containsRect(currentRect)) {
        return true;
      }
    }
    return false;
  }

  /**
   * 计算当前重排列过程中的图标挤位方向
   *
   * @param itemInfo 拖拽View的位置信息
   * @param dragItemInfo 被拖拽的view
   * @param resultDirection 方向计算结果
   */
  public getDirectionVectorForDrop(cellAndSpan: CellAndSpan, dragItemInfo: DragGridItem,
    layoutInfo: DragGridItem[]): number[] {
    let dragViewCenterX: number = cellAndSpan.getCellX();
    let dragViewCenterY: number = cellAndSpan.getCellY();
    let spanX: number = cellAndSpan.getSpanX();
    let spanY: number = cellAndSpan.getSpanY();
    let targetDestination: number[] = this.findNearestArea(cellAndSpan);
    if (RTLUtil.isRTL()) {
      // 镜像模式参照点从左上角变成了右上角、column从前往后数调整成从后往前数
      targetDestination[0] = this.mColumn - cellAndSpan.getSpanX() - targetDestination[0];
    }
    let dragRect: RectItem = this.regionToRect(targetDestination[0], targetDestination[1],
      cellAndSpan.getSpanX(), cellAndSpan.getSpanY());
    dragRect.offset(dragViewCenterX - dragRect.centerX(), dragViewCenterY - dragRect.centerY());
    // 计算落点处View的矩形区域位置及中心点
    let rect: RectItem = this.getViewsIntersectingRegion(targetDestination, dragItemInfo, layoutInfo,
      this.mIntersectingViews);
    let dropRegionSpanX: number = rect.width();
    let dropRegionSpanY: number = rect.height();

    rect = this.regionToRect(rect.left, rect.top, rect.width(), rect.height());
    // 计算x轴与y轴差值
    let deltaX: number = (rect.centerX() - dragViewCenterX) / spanX;

    let deltaY: number = (rect.centerY() - dragViewCenterY) / spanY;

    if (dropRegionSpanX === this.mRow || spanX === this.mRow) {
      deltaX = 0;
    }
    if (dropRegionSpanY === this.mColumn || spanY === this.mColumn) {
      deltaY = 0;
    }
    let resultDirection: number[];
    if (deltaX === 0 && deltaY === 0) {
      // 若出现差值均为0的情况，给一个随机方向
      resultDirection = [1, 0];
    } else {
      resultDirection = this.computeDirectionVector(deltaX, deltaY);
    }
    this.mDirectionVector = resultDirection;
    log.showInfo(`resultDirection:${resultDirection[0]}, ${resultDirection[1]}`);
    return resultDirection;
  }

  private regionToRect(cellX: number, cellY: number, spanX: number, spanY: number): RectItem {
    const horizontalStartPadding: number = this.mPaddingLeft;
    const verticalStartPadding: number = this.mPaddingTop;
    let cellWidth: number = this.mGridItemWidth;
    let cellHeight: number = this.mGridItemHeight;
    let fixedCellX: number = cellX;
    const left: number = horizontalStartPadding + fixedCellX * cellWidth;
    const top: number = verticalStartPadding + cellY * cellHeight;
    let result: RectItem = new RectItem(left, top, left + (spanX * cellWidth), top + (spanY * cellHeight));
    return result;
  }

  private getViewsIntersectingRegion(destination: number[], dragItemInfo: DragGridItem,
    layoutInfo: DragGridItem[], intersectingViews: List<DragGridItem>): RectItem {
    let cellX: number = destination[0];
    let cellY: number = destination[1];
    let spanX: number = dragItemInfo.area[0];
    let spanY: number = dragItemInfo.area[1];
    let boundingRect = new RectItem(cellX, cellY, cellX + spanX, cellY + spanY);

    intersectingViews.clear();
    let r0: RectItem = new RectItem(cellX, cellY, cellX + spanX, cellY + spanY);
    let r1: RectItem = new RectItem(0, 0, 0, 0);
    for (let i = 0; i < layoutInfo.length; i++) {
      r1.set(layoutInfo[i].column, layoutInfo[i].row, layoutInfo[i].column + layoutInfo[i].area[0], layoutInfo[i].row + layoutInfo[i].area[1]);
      if (RectItem.intersects(r0, r1)) {
        intersectingViews.add(layoutInfo[i]);
        boundingRect.union(r1);
      }
    }
    return boundingRect;
  }

  /**
   * 根据两个坐标之间的相对位置，计算相对位置方向
   *
   * @param deltaX X轴位置差值
   * @param deltaY Y轴位置差值
   * @param result 计算结果
   */
  private computeDirectionVector(deltaX: number, deltaY: number): number[] {
    let angle: number = Math.atan(deltaY / deltaX);
    let result = [0, 0];
    if (Math.abs(Math.cos(angle)) > 0.5) {
      result[0] = deltaX > 0 ? 1 : -1;
    }
    if (Math.abs(Math.sin(angle)) > 0.5) {
      result[1] = deltaY > 0 ? 1 : -1;
    }
    return result;
  }

  public getReorderSolution(cellAndSpan: CellAndSpan, dragItem: DragGridItem,
    layoutInfo: DragGridItem[]): ItemConfiguration {
    // 通过某个方向的推动，或者图标位置替换找寻重排列方案
    let swapSolution = this.findReorderSolution(cellAndSpan, this.mDirectionVector, dragItem,
      layoutInfo, new ItemConfiguration(0, 0, 0, 0));
    return swapSolution;
  }

  private findReorderSolution(cellAndSpan: CellAndSpan, direction: number[], dragItem: DragGridItem,
    layoutInfo: DragGridItem[], solution: ItemConfiguration): ItemConfiguration {
    // 在计算开始前，先保存未挤位前的图标位置信息与状态，当挤位失败或者取消拖拽到当前位置时，可以进行状态恢复
    this.copyCurrentStateToSolution(solution, layoutInfo);

    // 计算离拖拽View最近的网格位置
    let result = this.findNearestArea(cellAndSpan);
    if (RTLUtil.isRTL()) {
      result[0] = this.mColumn - cellAndSpan.getSpanX() - result[0];
    }
    let spanX: number = cellAndSpan.getSpanX();
    let spanY: number = cellAndSpan.getSpanY();

    // 基于最近网格位置进行图标重排列尝试
    let isSuccess: boolean = this.rearrangementExists(new CellAndSpan(result[0], result[1], spanX, spanY),
      dragItem, direction, layoutInfo, solution);
    this.reArrangeSolutionSuccess = isSuccess;
    if (isSuccess) {
      // 重排列方案生效，记录相关信息
      solution.setIsSolutionValid(true);
      solution.setCellX(result[0]);
      solution.setCellY(result[1]);
      solution.setSpanX(spanX);
      solution.setSpanY(spanY);
    }
    return solution;
  }

  public getNearReorderSolution(cellAndSpan: CellAndSpan, dragItemInfo: DragGridItem, layoutInfo: DragGridItem[],
                                nearLayoutInfo: DragGridItem[], solution: ItemConfiguration): ItemConfiguration {
    // 在计算开始前，先保存未挤位前的图标位置信息与状态，当挤位失败或者取消拖拽到当前位置时，可以进行状态恢复
    this.copyCurrentStateToSolution(solution, layoutInfo);
    solution.save();
    this.reNearArrangeSolutionSuccess = false;

    // 计算离拖拽View最近的网格位置
    let result: number[] = this.findNearestArea(cellAndSpan);
    if (RTLUtil.isRTL()) {
      result[0] = this.mColumn - cellAndSpan.getSpanX() - result[0];
    }
    let spanX: number = cellAndSpan.getSpanX();
    let spanY: number = cellAndSpan.getSpanY();
    // 基于最近网格位置进行图标重排列尝试
    let isSuccess: boolean = this.nearRearRangementExits(new CellAndSpan(result[0], result[1], spanX, spanY),
      dragItemInfo, layoutInfo, nearLayoutInfo, solution);
    this.reArrangeSolutionSuccess = isSuccess;
    // 标记是否双屏挤位，双屏挤位，冲突序列改变了page
    this.reNearArrangeSolutionSuccess = isSuccess;
    if (isSuccess) {
      // 重排列方案生效，记录相关信息
      solution.setIsSolutionValid(true);
      solution.setCellX(result[0]);
      solution.setCellY(result[1]);
      solution.setSpanX(spanX);
      solution.setSpanY(spanY);
    }
    return solution;
  }

  public nearRearRangementExits(cellAndSpan: CellAndSpan, dragItemInfo: DragGridItem, layoutInfo: DragGridItem[],
                                nearLayoutInfo: DragGridItem[], solution: ItemConfiguration): boolean {
    let cellX: number = cellAndSpan.getCellX();
    let cellY: number = cellAndSpan.getCellY();
    let spanX: number = cellAndSpan.getSpanX();
    let spanY: number = cellAndSpan.getSpanY();

    if (cellX < 0 || cellY < 0) {
      return false;
    }
    if (nearLayoutInfo === undefined || nearLayoutInfo === null) {
      log.showError('nearRearRangementExits, nearLayoutInfo is invalid');
      return false;
    }

    this.mIntersectingViews.clear();
    this.mOccupiedRect.set(cellX, cellY, cellX + spanX, cellY + spanY);

    let r0 = new RectItem(cellX, cellY, cellX + spanX, cellY + spanY);
    let r1: RectItem = new RectItem(0, 0, 0, 0,);
    for (let i = 0; i < layoutInfo.length; i++) {
      r1.set(layoutInfo[i].column, layoutInfo[i].row, layoutInfo[i].column + layoutInfo[i].area[0],
        layoutInfo[i].row + layoutInfo[i].area[1]);
      if (RectItem.intersects(r0, r1)) {
        this.mIntersectingViews.add(layoutInfo[i]);
      }
    }
    if (this.mIntersectingViews.length === 0) {
      return false;
    }
    solution.setIntersectingViews(this.mIntersectingViews);

    if (!this.mIntersectingViews || !solution) {
      log.showError('nearRearRangementExits, direction or solution or mIntersectingViews is invalid');
      return false;
    }

    // 若从单一方向推动无效，则尝试将所有与落点冲突的View集合视为一个整体进行移动,不考虑方向
    if (this.addViewsToNearTempLocation(this.mIntersectingViews, nearLayoutInfo, r0, solution, dragItemInfo)) {
      return true;
    }

    // 若整体移动也失败，则将所有冲突的View单独进行找位，此时需要有一个共用的网格占用情况标记
    let gridOccupyStatus: GridOccupyStatus = this.getGridOccupyStatus(nearLayoutInfo);

    // 针对单个控件找位
    let isSolutionThreeSuccess: boolean = true;
    for (let view of this.mIntersectingViews) {
      if (!this.addViewToNearTempLocation(view, r0, gridOccupyStatus, solution)) {
        isSolutionThreeSuccess = false;
        break;
      }
    }
    return isSolutionThreeSuccess;
  }

  private addViewsToNearTempLocation(affectedViews: List<DragGridItem>, nearLayout: DragGridItem[],
    dragViewPotentialDrop: RectItem, currentState: ItemConfiguration, dragItemInfo: DragGridItem): boolean {
    if (affectedViews.length === 0) {
      return true;
    }
    if (nearLayout === undefined || nearLayout === null) {
      log.showError('addViewsToNearTempLocation, nearLayout is invalid');
      return false;
    }

    // 获取当前页宫格网格占位情况
    let pageOccupyStatus: GridOccupyStatus = this.getGridOccupyStatus(nearLayout);
    // 将受影响的占位取消，并准备一个相对占位网格用于比较
    let boundingRect: RectItem = new RectItem(0, 0, 0, 0);
    currentState.getBoundingRectForViews(affectedViews, boundingRect);
    let blockOccupied: GridOccupyStatus = new GridOccupyStatus(boundingRect.width(), boundingRect.height(), GridOccupyStatusEnum.FREE);
    for (let view of affectedViews) {
      let cellAndSpan: CellAndSpan = currentState.getCellAndSpan(view);
      if (cellAndSpan === null) {
        log.showError(`addViewsToNearTempLocation getCellAndSpan is null, view.row: ${view.row},
        view.column: ${view.column}, view.area[0]: ${view.area[0]}, view.area[1]: ${view.area[1]}`);
        return false;
      }
      cellAndSpan.setCellX(cellAndSpan.getCellX() - boundingRect.left); // x坐标相对偏移
      cellAndSpan.setCellY(cellAndSpan.getCellY() - boundingRect.top); // y坐标相对偏移
      blockOccupied.markGridForCellAndSpan(cellAndSpan, GridOccupyStatusEnum.OCCUPIED); // 进行相对占位
      cellAndSpan.setCellX(cellAndSpan.getCellX() + boundingRect.left); // x坐标相对偏移还原
      cellAndSpan.setCellY(cellAndSpan.getCellY() + boundingRect.top); // y坐标相对偏移还原
    }

    // 接下来就可以比较当前页面宫格占位找一个可以放下小型网格的位置，先不考虑挤位方向实现
    let tempLocation: number[] = [-1, -1];
    let boundingCellAndSpan: CellAndSpan = new CellAndSpan(boundingRect.left, boundingRect.top, boundingRect.width(), boundingRect.height());
    let isSwapSuccess = this.findAreaInNearLayout(boundingCellAndSpan, pageOccupyStatus, blockOccupied, tempLocation, true);
    if (!isSwapSuccess) {
      this.findAreaInNearLayout(boundingCellAndSpan, pageOccupyStatus, blockOccupied, tempLocation, false);
    }

    // 找到的位置有效时，则当前方案有效，前后偏移量即为每个app的偏移量
    let isSuccess: boolean = false;
    if (tempLocation[0] >= 0 && tempLocation[1] >= 0) {
      let deltaX: number = tempLocation[0] - boundingRect.left;
      let deltaY: number = tempLocation[1] - boundingRect.top;
      for (let view of affectedViews) {
        let cellAndSpan: CellAndSpan = currentState.getCellAndSpan(view);
        if (cellAndSpan != null) {
          cellAndSpan.setCellX(cellAndSpan.getCellX() + deltaX);
          cellAndSpan.setCellY(cellAndSpan.getCellY() + deltaY);
        }
      }
      isSuccess = true;
    }
    return isSuccess;
  }

  private addViewToNearTempLocation(view: DragGridItem, dragViewPotentialDrop: RectItem,
    gridOccupyStatus: GridOccupyStatus, currentState: ItemConfiguration): boolean {
    let cellAndSpan: CellAndSpan = currentState.getCellAndSpan(view);
    if (cellAndSpan == null) {
      return false;
    }

    let isSuccess: boolean = false;

    let tempLocation: number[] = [-1, -1];
    this.findAreaInNearLayout(cellAndSpan, gridOccupyStatus, null, tempLocation, false);
    if (tempLocation[0] >= 0 && tempLocation[1] >= 0) {
      isSuccess = true;
      cellAndSpan.setCellX(tempLocation[0]);
      cellAndSpan.setCellY(tempLocation[1]);
      gridOccupyStatus.markGridForCellAndSpan(cellAndSpan, GridOccupyStatusEnum.OCCUPIED);
    }
    return isSuccess;
  }

  public findAreaInNearLayout(cellAndSpan: CellAndSpan, pageOccupied: GridOccupyStatus,
                            blockOccupied: GridOccupyStatus, result: number[], isSwap: boolean): boolean {

    let countX: number = pageOccupied.getSizeX();
    let countY: number = pageOccupied.getSizeY();
    let spanX: number = cellAndSpan.getSpanX();
    let spanY: number = cellAndSpan.getSpanY();
    const dragItem: DragGridItem = AppStorage.get<DragGridItem>('dragItemInfo') as DragGridItem;
    let startX = 0;
    let startY = 0;
    if (isSwap) {
      startX = dragItem.column;
      startY = dragItem.row;
    }
    for (let y = startY; y < countY - (spanY - 1); ++y) {
      inner: for (let x = startX; x < countX - (spanX - 1); ++x) {
        for (let i = 0; i < spanX; ++i) {
          for (let j = 0; j < spanY; ++j) {
            // 当前宫格上被占用的地方，不能被再次占用
            if (pageOccupied.isOccupied(x + i, y + j) && (blockOccupied === null || blockOccupied.isOccupied(i, j))) {
              continue inner;
            }
          }
        }
        result[0] = x;
        result[1] = y;
        return true;
      }
    }
    result[0] = -1;
    result[1] = -1;
    return false;
  }


  private copyCurrentStateToSolution(solution: ItemConfiguration, layoutInfo: DragGridItem[]): void {
    for (let i = 0; i < layoutInfo.length; i++) {
      let cellSpan: CellAndSpan;
      let cellX = layoutInfo[i].column;
      let cellY = layoutInfo[i].row;
      cellSpan = new CellAndSpan(cellX, cellY, layoutInfo[i].area[0], layoutInfo[i].area[1]);
      solution.add(layoutInfo[i], cellSpan);
    }
  }

  private rearrangementExists(cellAndSpan: CellAndSpan, dragItem: DragGridItem, direction: number[],
    layoutInfo: DragGridItem[], solution: ItemConfiguration): boolean {
    let cellX: number = cellAndSpan.getCellX();
    let cellY: number = cellAndSpan.getCellY();
    let spanX: number = cellAndSpan.getSpanX();
    let spanY: number = cellAndSpan.getSpanY();

    if (cellX < 0 || cellY < 0) {
      return false;
    }

    this.mIntersectingViews.clear();
    this.mOccupiedRect.set(cellX, cellY, cellX + spanX, cellY + spanY);

    let r0 = new RectItem(cellX, cellY, cellX + spanX, cellY + spanY);
    let r1: RectItem = new RectItem(0, 0, 0, 0,);
    for (let i = 0; i < layoutInfo.length; i++) {
      r1.set(layoutInfo[i].column, layoutInfo[i].row, layoutInfo[i].column + layoutInfo[i].area[0],
        layoutInfo[i].row + layoutInfo[i].area[1]);
      if (RectItem.intersects(r0, r1)) {
        this.mIntersectingViews.add(layoutInfo[i]);
      }
    }

    if (this.mIntersectingViews.length === 0) {
      return false;
    }
    solution.setIntersectingViews(this.mIntersectingViews);

    if (!direction || !this.mIntersectingViews || !solution) {
      log.showError('rearrangementExists, direction or solution or mIntersectingViews is invalid');
      return false;
    }

    // 首先通过尝试从某个方向进行推动，从而达到重排列的目的
    if (this.attemptPushInDirection(r0, direction, dragItem, this.mIntersectingViews, solution)) {
      return true;
    }

    // 若从单一方向推动无效，则尝试将所有与落点冲突的View集合视为一个整体进行移动
    if (this.addViewsToTempLocation(dragItem, layoutInfo, r0, direction, solution)) {
      return true;
    }

    // 若整体移动也失败，则将所有冲突的View单独进行找位，此时需要有一个共用的网格占用情况标记
    let gridOccupyStatus: GridOccupyStatus = this.getGridOccupyStatus(layoutInfo);
    log.showInfo(`rearrangementExists solutionThree, gridOccupyStatus:${gridOccupyStatus.mStatus.toString()}`);

    // 针对潜在落位进行占位
    gridOccupyStatus.markGridForRect(r0, GridOccupyStatusEnum.OCCUPIED);

    // 针对单个控件找位
    let isSolutionThreeSuccess: boolean = true;
    for (let view of this.mIntersectingViews) {
      if (!this.addViewToTempLocation(view, r0, direction, gridOccupyStatus, solution)) {
        isSolutionThreeSuccess = false;
        break;
      }
    }

    return isSolutionThreeSuccess;
  }

  /**
   * 尝试通过不同方向的推动找寻重排列方案
   *
   * @param occupied 拖拽落点占用的区域
   * @param direction 挤位方向
   * @param dragItemInfo 被拖拽的View
   * @param intersectingViews 与拖拽落点产生的冲突的View集合
   * @param solution 重排列解决方案
   * @return 是否有可用解决方案
   */
  private attemptPushInDirection(occupied: RectItem, direction: number[], dragItemInfo: DragGridItem,
    intersectingViews: List<DragGridItem>, solution: ItemConfiguration): boolean {
    if ((Math.abs(direction[0]) + Math.abs(direction[1])) > 1) {
      // 如果X和Y两个方向都不为0，分别从X和Y单独进行尝试
      // 第一次尝试
      if (this.checkPushViewsToTempLocation(intersectingViews, occupied, direction, dragItemInfo, solution)) {
        return true;
      }
      // 第二次反向尝试
      if (this.checkPushViewsToTempLocation(intersectingViews, occupied, direction, dragItemInfo, solution)) {
        return true;
      }
    } else {
      // 如果X和Y仅有一个方向不为0，优先从该方向进行尝试
      if (this.pushViewsToTempLocation(intersectingViews, occupied, direction, dragItemInfo, solution)) {
        return true;
      }
      // 进行反向尝试
      direction[0] = -direction[0];
      direction[1] = -direction[1];
      if (this.pushViewsToTempLocation(intersectingViews, occupied, direction, dragItemInfo, solution)) {
        return true;
      }
      // 如果上面的方向无法获取到重排列方案，尝试从另外一个方向获取交换方向（先恢复，再尝试）
      let temp: number = -direction[1];
      direction[1] = -direction[0];
      direction[0] = temp;
      if (this.pushViewsToTempLocation(intersectingViews, occupied, direction, dragItemInfo, solution)) {
        return true;
      }

      // 进行反向尝试
      direction[0] = -direction[0];
      direction[1] = -direction[1];
      if (this.pushViewsToTempLocation(intersectingViews, occupied, direction, dragItemInfo, solution)) {
        return true;
      }
      // 反向恢复并恢复到原始方向
      temp = -direction[1];
      direction[1] = -direction[0];
      direction[0] = temp;
    }
    return false;
  }

  private checkPushViewsToTempLocation(intersectingViews: List<DragGridItem>, occupied: RectItem, direction: number[],
    dragItemInfo: DragGridItem, solution: ItemConfiguration): boolean {
    // 首先从X方向进行尝试
    let temp = direction[1];
    direction[1] = 0;
    if (this.pushViewsToTempLocation(intersectingViews, occupied, direction, dragItemInfo, solution)) {
      return true;
    }
    direction[1] = temp;

    // 从Y方向进行尝试
    temp = direction[0];
    direction[0] = 0;
    if (this.pushViewsToTempLocation(intersectingViews, occupied, direction, dragItemInfo, solution)) {
      return true;
    }
    // 反向
    direction[0] = -temp;
    direction[1] = -direction[1];
    return false;
  }

  /**
   *
   * @param intersectingViews 与拖拽落点产生的冲突的View集合
   * @param occupied 拖拽落点占用的区域
   * @param direction 挤位方向
   * @param dragItemInfo 被拖拽的View
   * @param solution 解决方案
   */
  private pushViewsToTempLocation(intersectingViews: List<DragGridItem>, occupied: RectItem, direction: number[],
    dragItemInfo: DragGridItem, solution: ItemConfiguration): boolean {
    // cluster中保存了需要改变位置的View集合，后面简称为集群
    let cluster: ViewCluster = new ViewCluster(intersectingViews, solution, this.mRow, this.mColumn);
    let clusterRect: RectItem = cluster.getBoundingRect();

    let pair = this.calculatePushDirectionAndDistance(direction, clusterRect, occupied);
    let whichEdge: number = pair[0];
    let pushDistance: number = pair[1];

    if (pushDistance <= 0) {
      return false;
    }

    // 保存当前CellLayout上所有View的位置和尺寸信息。若挤位失败，可用过保存状态进行恢复。
    solution.save();

    // 对当前CellLayout上所有的View进行排序。排序的优先级是按照推动方向以及View的网格边缘综合考虑。
    // 例如，当推动方向是从左往右时，则左边缘与被推动区域更加靠近的View优先级更高。
    // 这么做的目的主要在于优化算法的时间复杂度
    cluster.sortConfigurationForEdgePush(whichEdge);
    let isFail: boolean = false;

    while (pushDistance > 0 && !isFail) {
      for (let view of solution.getSortedViews()) {
        if (view == null) {
          continue;
        }

        if (cluster.isContainView(view)) {
          continue;
        }
        // 若当前View还不在集群中，但是边缘与集群产生碰撞，则将其加入集群中
        if (!cluster.isViewTouchingEdge(view, whichEdge)) {
          continue;
        }

        // 将符合推动要求的View加入集群，并释放其原有位置
        cluster.addView(view);
      }
      // 需要推动的距离决定循环次数
      pushDistance--;
      // 将集群中所有的View根据推动方向更新位置
      cluster.shift(whichEdge);
    }
    let isFoundSolution: boolean = false;
    // 对算法结果进行校验，若最终坐标范围有效，则解决方案可行
    if (!isFail && this.isClusterRectValid(cluster.getBoundingRect())) {
      isFoundSolution = true;
      solution.setIntersectingViews(cluster.getClusterViews());
    } else {
      solution.restore();
    }
    log.showInfo(`pushViewsToTempLocation isFoundSolution:${isFoundSolution},cluster.getBoundingRect():${cluster.getBoundingRect().toString()}`);

    return isFoundSolution;
  }

  private isClusterRectValid(clusterRect: RectItem): boolean {
    return clusterRect.left >= 0 && clusterRect.right <= this.mColumn &&
      clusterRect.top >= 0 && clusterRect.bottom <= this.mRow;
  }

  /**
   *
   * @param direction
   * @param clusterRect
   * @param potentialDropRect
   */
  private calculatePushDirectionAndDistance(direction: number[], clusterRect: RectItem, potentialDropRect: RectItem): number[] {
    let whichEdge: number;
    let pushDistance: number;

    // 计算将引导推动的边缘，以及需要推动的距离。其中边缘根据推动方向决定
    if (direction[0] < 0) {
      whichEdge = 1;
      pushDistance = clusterRect.right - potentialDropRect.left;
    } else if (direction[0] > 0) {
      whichEdge = 1 << 2;
      pushDistance = potentialDropRect.right - clusterRect.left;
    } else if (direction[1] < 0) {
      whichEdge = 1 << 1;
      pushDistance = clusterRect.bottom - potentialDropRect.top;
    } else {
      whichEdge = 1 << 3;
      pushDistance = potentialDropRect.bottom - clusterRect.top;
    }

    return [whichEdge, pushDistance];
  }

  /**
   * 为多个被挤位影响到的view找一块可用区域，找位后的结果需要保证相对位置不变
   *
   * @param affectedViews         被影响的view集合
   * @param dragViewPotentialDrop 拖拽View当前潜在落位
   * @param direction             拖拽View挤位方向
   * @param currentState          当前CellLayout所有View的位置与尺寸信息
   * @return true即找位成功，否则失败
   * @date 2023-02-20
   */
  private addViewsToTempLocation(dragItemInfo: DragGridItem, layout: DragGridItem[], dragViewPotentialDrop: RectItem,
                                 direction: number[], currentState: ItemConfiguration): boolean {
    let affectedViews: List<DragGridItem> = this.mIntersectingViews;
    log.showInfo(`addViewsToTempLocation start, affectedViews length:${affectedViews.length}, dragViewPotentialDrop:${dragViewPotentialDrop.toString()}, direction:${direction.toString()}`);
    if (affectedViews.length === 0) {
      return true;
    }

    // 获取当前页宫格网格占位情况
    let pageOccupyStatus: GridOccupyStatus = this.getGridOccupyStatus(layout);
    // 将受影响的占位取消，并准备一个相对占位网格用于比较
    let boundingRect: RectItem = new RectItem(0, 0, 0, 0);
    currentState.getBoundingRectForViews(affectedViews, boundingRect);
    let blockOccupied: GridOccupyStatus = new GridOccupyStatus(boundingRect.width(), boundingRect.height(), GridOccupyStatusEnum.FREE);
    for (let view of affectedViews) {
      let cellAndSpan: CellAndSpan = currentState.getCellAndSpan(view);
      if (cellAndSpan === null) {
        log.showError(`addViewsToTempLocation getCellAndSpan is null, view.row: ${view.row},
        view.column: ${view.column}, view.area[0]: ${view.area[0]}, view.area[1]: ${view.area[1]}`);
        return false;
      }
      pageOccupyStatus.markGridForCellAndSpan(cellAndSpan, GridOccupyStatusEnum.FREE); // 取消页面占位
      cellAndSpan.setCellX(cellAndSpan.getCellX() - boundingRect.left); // x坐标相对偏移
      cellAndSpan.setCellY(cellAndSpan.getCellY() - boundingRect.top); // y坐标相对偏移
      blockOccupied.markGridForCellAndSpan(cellAndSpan, GridOccupyStatusEnum.OCCUPIED); // 进行相对占位
      cellAndSpan.setCellX(cellAndSpan.getCellX() + boundingRect.left); // x坐标相对偏移还原
      cellAndSpan.setCellY(cellAndSpan.getCellY() + boundingRect.top); // y坐标相对偏移还原
    }

    // 针对drop项的潜在落位需要在当前宫格页面占位
    pageOccupyStatus.markGridForRect(dragViewPotentialDrop, GridOccupyStatusEnum.OCCUPIED);

    // 接下来就可以比较当前页面宫格占位找一个可以放下小型网格的位置，先不考虑挤位方向实现
    let tempLocation: number[] = [-1, -1];
    let boundingCellAndSpan: CellAndSpan = new CellAndSpan(boundingRect.left, boundingRect.top, boundingRect.width(), boundingRect.height());
    this.findNearestAreaTwo(boundingCellAndSpan, direction, pageOccupyStatus, blockOccupied, tempLocation);

    // 找到的位置有效时，则当前方案有效，前后偏移量即为每个app的偏移量
    let isSuccess: boolean = false;
    if (tempLocation[0] >= 0 && tempLocation[1] >= 0) {
      // 被挤位app进行移位
      let deltaX: number = tempLocation[0] - boundingRect.left;
      let deltaY: number = tempLocation[1] - boundingRect.top;

      for (let view of affectedViews) {
        let cellAndSpan: CellAndSpan = currentState.getCellAndSpan(view);
        if (cellAndSpan != null) {
          cellAndSpan.setCellX(cellAndSpan.getCellX() + deltaX);
          cellAndSpan.setCellY(cellAndSpan.getCellY() + deltaY);
        }
      }
      isSuccess = true;
    }

    return isSuccess;
  }

  /**
   * 获取grid占位状态
   * @param layoutInfo
   * @date 2023-02-20
   */
  public getGridOccupyStatus(layoutInfo: DragGridItem[]): GridOccupyStatus {
    let gridOccupyStatus: GridOccupyStatus = new GridOccupyStatus(this.mColumn, this.mRow,
    GridOccupyStatusEnum.FREE);

    for (let i = 0; i < layoutInfo?.length; ++i) {
      gridOccupyStatus.markGridForRect(new RectItem(layoutInfo[i].column, layoutInfo[i].row,
        layoutInfo[i].column + layoutInfo[i].area[0], layoutInfo[i].row + layoutInfo[i].area[1]), GridOccupyStatusEnum.OCCUPIED);
    }

    return gridOccupyStatus;
  }

  /**
   * 在当前CellLayout上，为给定的位置信息找一个最近的可用网格。此方法比较的是网格坐标之间的距离，而不是像素距离，需要考虑占位信息
   *
   * @param cellAndSpan   当前被挤位的view的位置信息
   * @param direction     移动方向
   * @param occupied      当前页的网格占用状态
   * @param blockOccupied 表示指定的矩形区域中网格占用状态。当尝试移动一整组View时使用
   * @param result        保存计算结果
   * @return 最近的可用网格
   * @date 2023-02-20
   */
  public findNearestAreaTwo(cellAndSpan: CellAndSpan, direction: number[], pageOccupied: GridOccupyStatus,
                            blockOccupied: GridOccupyStatus, result: number[]): number[] {
    log.showInfo(`findNearestAreaTwo start cellAndSpan:${cellAndSpan.toString()}, direction:${direction.toString()}`);
    let bestLocation: number[] = result !== null ? result : [-1, -1];
    let bestDistance: number = Number.MAX_SAFE_INTEGER;
    let bestDirectionScore: number = Number.MIN_SAFE_INTEGER;

    let countX: number = pageOccupied.getSizeX();
    let countY: number = pageOccupied.getSizeY();
    let cellX: number = cellAndSpan.getCellX();
    let cellY: number = cellAndSpan.getCellY();
    let spanX: number = cellAndSpan.getSpanX();
    let spanY: number = cellAndSpan.getSpanY();

    for (let y = 0; y < countY - (spanY - 1); ++y) {
      inner: for (let x = 0; x < countX - (spanX - 1); ++x) {
        for (let i = 0; i < spanX; ++i) {
          for (let j = 0; j < spanY; ++j) {
            // 当前宫格上被占用的地方，不能被再次占用
            if (pageOccupied.isOccupied(x + i, y + j) && (blockOccupied == null || blockOccupied.isOccupied(i, j))) {
              continue inner;
            }
          }
        }

        // 分别计算每种可用情况的距离和得分，取最优的方案
        let distance: number = Math.hypot(x - cellX, y - cellY);
        let curDirection: number[] = this.computeDirectionVector(x - cellX, y - cellY);
        let curDirectionScore: number = direction[0] * curDirection[0] + direction[1] * curDirection[1];
        if (distance < bestDistance || (Math.abs(distance - bestDistance) < 0.000001 && curDirectionScore > bestDirectionScore)) {
          bestDistance = distance;
          bestDirectionScore = curDirectionScore;
          bestLocation[0] = x;
          bestLocation[1] = y;
        }
      }
    }

    if (bestDistance === Number.MAX_SAFE_INTEGER) {
      bestLocation[0] = Number.MIN_SAFE_INTEGER;
      bestLocation[1] = Number.MIN_SAFE_INTEGER;
    }
    return bestLocation;
  }

  /**
   * 为单个View寻找可用区域
   *
   * @param view                  目标View
   * @param dragViewPotentialDrop 拖拽View落点占用区域
   * @param direction             找位方向
   * @param currentState          当前CellLayout所有View的位置与尺寸信息
   * @return 是否找位成功
   * @date 2023-02-20
   */
  private addViewToTempLocation(view: DragGridItem, dragViewPotentialDrop: RectItem, direction: number[],
    gridOccupyStatus: GridOccupyStatus, currentState: ItemConfiguration): boolean {
    log.showInfo(`addViewToTempLocation start, dragViewPotentialDrop:${dragViewPotentialDrop.toString()}, direction:${direction.toString()}`);

    let cellAndSpan: CellAndSpan = currentState.getCellAndSpan(view);
    if (cellAndSpan == null) {
      return false;
    }

    let isSuccess: boolean = false;

    let tempLocation: number[] = [-1, -1];
    this.findNearestAreaTwo(cellAndSpan, direction, gridOccupyStatus, null, tempLocation);
    if (tempLocation[0] >= 0 && tempLocation[1] >= 0) {
      isSuccess = true;
      cellAndSpan.setCellX(tempLocation[0]);
      cellAndSpan.setCellY(tempLocation[1]);
      gridOccupyStatus.markGridForCellAndSpan(cellAndSpan, GridOccupyStatusEnum.OCCUPIED);
    }

    return isSuccess;
  }
}