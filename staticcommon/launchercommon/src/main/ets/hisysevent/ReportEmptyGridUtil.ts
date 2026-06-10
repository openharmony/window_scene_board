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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { CheckGridReq, GridOccupyStatusEnum } from '@ohos/componentdrag/src/main/ets/service/reorder/GridOccupyStatus';
import { CellAndSpan, CellLayoutDragDelegate, GridOccupyStatus } from '@ohos/componentdrag/src/main/ets/TsIndex';
import { DefaultDesktopLayoutInfo, GridLayoutItemInfo, SCBHiSysEventUtil } from '../TsIndex';
import { EmptyGridInfoBean } from './ReportParams';

const TAG = 'ReportEmptyGridUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class Grid {
  public x: number = 0;
  public y: number = 0;
  public area: number[] = [];
  public sum: number = 0;
}

/**
 * 桌面_网格报告(状态点,周报,周日报)
 */
export class ReportEmptyGridUtil {
  /**
   * 桌面_网格报告
   */
  public static reportEmptyGridInfo(info: DefaultDesktopLayoutInfo, dragDelegate: CellLayoutDragDelegate): void {
    let infos: EmptyGridInfoBean[] = [];
    for (let pageIndex = 0; pageIndex < info.layoutDescription.pageCount; pageIndex++) {
      let pageItems: GridLayoutItemInfo[] = info.layoutInfo.filter(item => item.page === pageIndex);
      let gridOccupyStatus: GridOccupyStatus = dragDelegate.getGridOccupyStatus(pageItems);
      let list: EmptyGridInfoBean[] = ReportEmptyGridUtil.buildGridInfo(pageIndex, gridOccupyStatus);
      if (!CheckEmptyUtils.isEmptyArr(list)) {
        for (let one of list) {
          infos.push(one);
        }
      }
    }
    SCBHiSysEventUtil.reportEmptyGridInfo(infos);
  }

  /**
   * 根据网格数据构造矩形数据
   * 遍历每一行,处理脏数据，可能存在U，这些数据改为O
   * 先将 F -> U，构造返回空网格数据
   * 再将 O -> U，构造返回非空网格数据
   * @param page 页数
   * @param gridOccupyStatus 网格数据
   * @returns
   */
  private static buildGridInfo(page: number, gridOccupyStatus: GridOccupyStatus): EmptyGridInfoBean[] {
    let emptyGridInfos: EmptyGridInfoBean[] = [];
    if (CheckEmptyUtils.isEmpty(gridOccupyStatus) || CheckEmptyUtils.isEmptyArr(gridOccupyStatus.mStatus)) {
      return emptyGridInfos;
    }
    ReportEmptyGridUtil.checkDirtyData(gridOccupyStatus);
    let checkReq: CheckGridReq = {
      startCellX: 0,
      startCellY: 0,
      spanX: gridOccupyStatus.getSizeX(),
      spanY: gridOccupyStatus.getSizeY(),
      status: GridOccupyStatusEnum.FREE
    };
    ReportEmptyGridUtil.buildGrid(page, gridOccupyStatus, checkReq, emptyGridInfos);
    checkReq.status = GridOccupyStatusEnum.OCCUPIED;
    ReportEmptyGridUtil.buildGrid(page, gridOccupyStatus, checkReq, emptyGridInfos);
    return emptyGridInfos;
  }

  /**
   * 遍历每一行,处理脏数据，可能存在U，这些数据改为O
   */
  private static checkDirtyData(gridOccupyStatus: GridOccupyStatus): void {
    let m = gridOccupyStatus.getSizeX();
    let n = gridOccupyStatus.getSizeY();
    for (let row = 0; row < m; row++) {
      for (let col = 0; col < n; col++) {
        if (gridOccupyStatus.getStatus(row, col) === GridOccupyStatusEnum.UNKNOWN) {
          gridOccupyStatus.markStatus(row, col, GridOccupyStatusEnum.OCCUPIED);
        }
      }
    }
  }

  /**
   * 为了减少数据量，采取每次只获取最大的矩形
   */
  private static buildGrid(page: number, gridOccupyStatus: GridOccupyStatus, checkReq: CheckGridReq,
    emptyGridInfos: EmptyGridInfoBean[]): void {
    let count = 0;
    let maxCount = gridOccupyStatus.getSizeX() * gridOccupyStatus.getSizeY();
    while (gridOccupyStatus.checkHasStatusForGrid(checkReq)) {
      count++;
      if (count > maxCount) {
        break;
      }
      let grid: Grid | null = ReportEmptyGridUtil.maximalRectangle(gridOccupyStatus, checkReq.status);
      if (!grid) {
        break;
      }
      let cellToSetup: CellAndSpan = new CellAndSpan(grid.x, grid.y, grid.area[0], grid.area[1]);
      gridOccupyStatus.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.UNKNOWN);
      emptyGridInfos.push(ReportEmptyGridUtil.convertInfo(grid, page, checkReq.status));
    }
  }

  private static convertInfo(grid: Grid, page: number, status: GridOccupyStatusEnum): EmptyGridInfoBean {
    let target = new EmptyGridInfoBean();
    target.SCREENID = page;
    target.SIZE = grid.area[0] + '*' + grid.area[1];
    target.CELLX = grid.x;
    target.CELLY = grid.y;
    target.EMPTYFLAG = status === GridOccupyStatusEnum.FREE ? 1 : 0;
    return target;
  }

  /**
   * 查询最大矩形
   *
   * @param gridOccupyStatus [{'O','O','F','O','O','O'},{'O','O','F','O','O','O'},{'O','O','F','O','O','O'},{'O','O','F','O','O','O'}]
   * @param status GridOccupyStatusEnum
   * @returns
   */
  private static maximalRectangle(gridOccupyStatus: GridOccupyStatus, status: GridOccupyStatusEnum): Grid | null {
    let res: Grid | null = null;
    try {
      let m = gridOccupyStatus.getSizeX();
      let n = gridOccupyStatus.getSizeY();
      let width = new Array<Array<number>>(m);
      for (let i = 0; i < m; ++i) {
        width[i] = new Array<number>(n);
        width[i].fill(0, 0, n);
      }
      let maxArea: number = 0;
      for (let row = 0; row < m; row++) {
        for (let col = 0; col < n; col++) {
          if (gridOccupyStatus.getStatus(row, col) === status) {
            if (col === 0) {
              width[row][col] = 1;
            } else {
              width[row][col] = width[row][col - 1] + 1;
            }
          } else {
            width[row][col] = 0;
          }
          let minWidth: number = width[row][col];
          for (let up_row = row; up_row >= 0; up_row--) {
            let height = row - up_row + 1;
            minWidth = Math.min(minWidth, width[up_row][col]);
            let tempRectangle = height * minWidth;
            if (tempRectangle > maxArea) {
              let one = new Grid();
              one.y = (col - minWidth + 1);
              one.x = (row - height + 1);
              one.sum = (tempRectangle);
              one.area = [height, minWidth];
              res = one;
            }
            maxArea = Math.max(maxArea, tempRectangle);
          }
        }
      }
    } catch (error) {
      log.showError(`maximalRectangle failed, error code: ${error.code}, message: ${error.message}.`);
    }
    return res;
  }
}
