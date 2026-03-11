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

import { CheckEmptyUtils, RectItem } from '@ohos/basicutils';
import CellAndSpan from './CellAndSpan';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG: string = 'GridOccupyStatus';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 网格占用标记工具类
 *
 * @date 2023-2-20
 */
export default class GridOccupyStatus {
  public mStatus: GridOccupyStatusEnum[][]; // 网格占用装填标记

  /**
   * 构造函数，创建一个网格占用状态实例，初始化为指定状态
   *
   * @param gridSizeX Grid size in the x direction
   * @param gridSizeY Grid size in the y direction
   */
  constructor(gridSizeX: number, gridSizeY: number, defaultStatus: GridOccupyStatusEnum) {
    if (gridSizeX <= 0 || gridSizeY <= 0) {
      this.mStatus = new Array<Array<GridOccupyStatusEnum>>();
      log.showDebug(`constructor param invalid, gridSizeX${gridSizeX}, gridSizeY${gridSizeY}`);
      return;
    }
    this.mStatus = new Array<Array<GridOccupyStatusEnum>>(gridSizeX);
    for (let i = 0; i < gridSizeX; ++i) {
      this.mStatus[i] = new Array<GridOccupyStatusEnum>(gridSizeY);
      this.mStatus[i].fill(defaultStatus, 0, gridSizeY);
    }
  }

  /**
   * 复制其他实例的占用状态到本实例
   *
   * @param other Other instance
   */
  public copyFrom(other: GridOccupyStatus): void {
    if (other === null) {
      return;
    }
    if (this.mStatus.length === 0 || this.mStatus.length !== other.mStatus.length) {
      return;
    }
    if (this.mStatus[0].length === 0 || this.mStatus[0].length !== other.mStatus[0].length) {
      return;
    }
    for (let i = 0; i < this.mStatus.length; ++i) {
      this.mStatus[i] = other.mStatus[i].concat();
    }
  }

  /**
   * 标记网格占用状态
   *
   * @param cellX Cell x of grid
   * @param cellY Cell y of grid
   * @param status New status
   */
  public markStatus(cellX: number, cellY: number, status: GridOccupyStatusEnum): void {
    if (this.checkGridIndex(cellX, cellY)) {
      this.mStatus[cellX][cellY] = status;
    }
  }

  /**
   * 获取网格状态
   *
   * @param cellX Cell x of grid
   * @param cellY Cell y of grid
   * @return Occupy status of cell
   * @return Occupy status of cell
   */
  public getStatus(cellX: number, cellY: number): GridOccupyStatusEnum {
    if (this.checkGridIndex(cellX, cellY)) {
      return this.mStatus[cellX][cellY];
    }
    return null;
  }

  /**
   * 检查网格是否被占用
   *
   * @param cellX Cell x of grid
   * @param cellY Cell y of grid
   * @return True for matched
   */
  public isOccupied(cellX: number, cellY: number): boolean {
    return this.isInStatus(cellX, cellY, GridOccupyStatusEnum.OCCUPIED);
  }

  /**
   * 检查网格是否可用
   *
   * @param cellX Cell x of grid
   * @param cellY Cell y of grid
   * @return True for free
   */
  public isFree(cellX: number, cellY: number): boolean {
    return this.isInStatus(cellX, cellY, GridOccupyStatusEnum.FREE);
  }

  /**
   * 获取Grid x方向size
   *
   * @return Grid size of X
   */
  public getSizeX(): number {
    return this.mStatus.length;
  }

  /**
   * 获取Grid y方向size
   *
   * @return Grid size of y
   */
  public getSizeY(): number {
    if (this.mStatus.length === 0) {
      return 0;
    }
    return this.mStatus[0].length;
  }

  /**
   * 获取Grid x方向size
   *
   * @param cellX Cell x of grid
   * @param cellY Cell y of grid
   * @param status Status to match
   * @return True for matched
   */
  public isInStatus(cellX: number, cellY: number, status: GridOccupyStatusEnum): boolean {
    if (this.checkGridIndex(cellX, cellY)) {
      return this.mStatus[cellX][cellY] === status;
    }
    return false;
  }

  /**
   * 检查给定的grid中的所有cell是否满足给定状态
   *
   * @param startCellX Start cell-X
   * @param startCellY Start cell-Y
   * @param spans Spans of target grid
   * @param status Status to match
   * @return True if all cell in grid-zone in given status
   */
  public isInStatusForGrid(startCellX: number, startCellY: number, spanX: number, spanY: number, status: GridOccupyStatusEnum): boolean {
    if (spanX < 1 || spanY < 1) {
      return false;
    }

    let endCellX: number = startCellX + spanX;
    let endCellY: number = startCellY + spanY;
    if (endCellX > this.getSizeX() || endCellY > this.getSizeY()) {
      // out of bounds
      return false;
    }
    for (let x = startCellX; x < endCellX; ++x) {
      for (let y = startCellY; y < endCellY; ++y) {
        if (!this.isInStatus(x, y, status)) {
          return false;
        }
      }
    }
    return true;
  }

  /**
   * 检查给定的grid中的所有cell是否[存在]给定状态
   *
   * @param startCellX Start cell-X
   * @param startCellY Start cell-Y
   * @param spans Spans of target grid
   * @param status Status to match
   * @return True if one cell in grid-zone in given status
   */
  public checkHasStatusForGrid(checkReq: CheckGridReq): boolean {
    if (CheckEmptyUtils.isEmpty(checkReq) || checkReq.startCellX < 0 || checkReq.startCellY < 0 || checkReq.spanX < 1 ||
      checkReq.spanY < 1 || CheckEmptyUtils.isEmpty(checkReq.status)) {
      return false;
    }
    let endCellX: number = checkReq.startCellX + checkReq.spanX;
    let endCellY: number = checkReq.startCellY + checkReq.spanY;
    if (endCellX > this.getSizeX() || endCellY > this.getSizeY()) {
      // out of bounds
      return false;
    }
    for (let x = checkReq.startCellX; x < endCellX; ++x) {
      for (let y = checkReq.startCellY; y < endCellY; ++y) {
        if (this.isInStatus(x, y, checkReq.status)) {
          return true;
        }
      }
    }
    return false;
  }

  /**
   * 检查所有grid中的所有cell都满足给定状态
   *
   * @param startCellX Start cell-X
   * @param startCellY Start cell-Y
   * @param spans Spans of target grid
   * @param status Status to match
   * @return True if one cell in grid-zone in given status
   */
  public checkAllStatusForGrid(checkReq: CheckGridReq): boolean {
    if (CheckEmptyUtils.isEmpty(checkReq) || checkReq.startCellX < 0 || checkReq.startCellY < 0 || checkReq.spanX < 1 ||
      checkReq.spanY < 1 || CheckEmptyUtils.isEmpty(checkReq.status)) {
      return false;
    }
    let endCellX: number = checkReq.startCellX + checkReq.spanX;
    let endCellY: number = checkReq.startCellY + checkReq.spanY;
    if (endCellX > this.getSizeX() || endCellY > this.getSizeY()) {
      // out of bounds
      return false;
    }
    for (let x = checkReq.startCellX; x < endCellX; ++x) {
      for (let y = checkReq.startCellY; y < endCellY; ++y) {
        if (!this.isInStatus(x, y, checkReq.status)) {
          return false;
        }
      }
    }
    return true;
  }

  /**
   * 检查网格参数是否合理
   *
   * @param cellX Cell x of grid
   * @param cellY Cell y of grid
   * @return True if valid
   */
  private checkGridIndex(cellX: number, cellY: number): boolean {
    if (cellX < 0 || cellX >= this.mStatus.length) {
      log.showDebug(`Invalid grid index x: ${cellX}`);
      return false;
    }
    if (cellY < 0 || cellY >= this.mStatus[0].length) {
      log.showDebug(`Invalid grid index y: ${cellY}`);
      return false;
    }
    return true;
  }

  /**
   * 标记网络占用状态
   *
   * @param cellToSetup 需要标记的网格范围
   * @param status 标记已使用或者未使用
   */
  public markGridForCellAndSpan(cellToSetup: CellAndSpan, status: GridOccupyStatusEnum): void {
    if (cellToSetup === null || status === null) {
      return;
    }

    for (let x = cellToSetup.getCellX(); x < cellToSetup.getCellX() + cellToSetup.getSpanX() && x < this.getSizeX(); ++x) {
      for (let y = cellToSetup.getCellY(); y < cellToSetup.getCellY() + cellToSetup.getSpanY() && y < this.getSizeY(); ++y) {
        this.markStatus(x, y, status);
      }
    }
  }

  /**
   * 标记网格的占用状态
   *
   * @param rect 需要标记的网格范围
   * @param status 标记已使用或者未使用
   */
  public markGridForRect(rect: RectItem, status: GridOccupyStatusEnum): void {
    let cellAndSpan: CellAndSpan = new CellAndSpan(rect.left, rect.top, rect.width(), rect.height());
    this.markGridForCellAndSpan(cellAndSpan, status);
  }

  /**
   * 获取网格占用状态
   *
   * @return 网格占用状态
   */
  public getGridOccupyStatus(): GridOccupyStatusEnum[][] {
    return this.mStatus;
  }

  public toString(): string {
    let result = [];
    result.push('[');
    for (let i = 0; i < this.mStatus.length; ++i) {
      result.push(this.mStatus[i].toString());
    }
    result.push(']');
    return result.join(';');
  }
}

/**
 * 网格占用情况枚举
 */
export enum GridOccupyStatusEnum {
  FREE = 'F', // Free status
  OCCUPIED = 'O', // Occupied status
  UNKNOWN = 'U' // Unknown status
}

/**
 * 检查网格请求
 */
export class CheckGridReq {
  startCellX: number = 0;
  startCellY: number = 0;
  spanX: number = 0;
  spanY: number = 0;
  status: GridOccupyStatusEnum;
}