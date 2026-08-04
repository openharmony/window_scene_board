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

import { LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';
import { CommonConstants } from '../../TsIndex';
import { BaseTransferBean } from '../BaseTransferBean';
import ScreenTransferBean from '../ScreenTransferBean';

const TAG = 'ExtractOperator';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);

export class ExtractOperator {
  private static newScreenArea: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];

  private static findClockWeatherCardRow(lastOccupied: BaseTransferBean[][]): number {
    for (let i = 0; i < lastOccupied.length - 1; i++) {
      for (let j = 0; j < lastOccupied[i]?.length; j++) {
        // 天气时钟卡片位置，从上往下第一张
        if (lastOccupied[i][j]?.typeId === CommonConstants.TYPE_CARD &&
          CommonConstants.TRANSLUCENT_CLOCK_WEATHER_CARD.includes(lastOccupied[i][j]?.cardName ?? '')) {
          return i;
        }
      }
    }
    return CommonConstants.INVALID_VALUE;
  }

  private static findEmptyRow(lastOccupied: BaseTransferBean[][]): number[] {
    let clockWeatherCardRow: number = ExtractOperator.findClockWeatherCardRow(lastOccupied);
    let emptyRows: number[] = [];
    let cardHeight: number = CommonConstants.NUMBER_TWO;
    if (clockWeatherCardRow === CommonConstants.INVALID_VALUE) {
      clockWeatherCardRow = lastOccupied.length - 1;
    } else {
      cardHeight = lastOccupied[clockWeatherCardRow][0].area?.[1] ?? CommonConstants.NUMBER_TWO;
    }

    for (let i = clockWeatherCardRow; i >= 0; i--) {
      if (!lastOccupied[i] || lastOccupied[i].length < 1) {
        emptyRows.push(i);
      }
    }

    if (clockWeatherCardRow === lastOccupied.length - 1) {
      return emptyRows;
    }

    for (let i = lastOccupied.length - 1; i > clockWeatherCardRow + cardHeight - 1; i--) {
      if (!lastOccupied[i] || lastOccupied[i].length < 1) {
        emptyRows.push(i);
      }
    }
    log.showInfo(TAG, `findEmptyRow ${emptyRows}_${clockWeatherCardRow}`);
    return emptyRows;
  }

  private static findAppRow(lastOccupied: BaseTransferBean[][]): number[] {
    let appRow: number[] = [];
    for (let i = 0; i < lastOccupied.length; i++) {
      let isAppRow: boolean = true;
      for (let j = 0; j < lastOccupied[i]?.length; j++) {
        if (lastOccupied[i][j] && (lastOccupied[i][j].typeId !== CommonConstants.TYPE_APP &&
          lastOccupied[i][j].typeId !== CommonConstants.TYPE_SHORTCUT_ICON)) {
          isAppRow = false;
          break;
        }
      }
      if (isAppRow) {
        appRow.push(i);
      }
    }
    return appRow;
  }

  private static findSingleRow(appRow: number[], lastOccupied: BaseTransferBean[][]): number[] {
    let singleRow: number[] = [];
    let clockWeatherCardRow: number = ExtractOperator.findClockWeatherCardRow(lastOccupied);
    for (let i = 0; i < lastOccupied.length; i++) {
      if (appRow.some(row => row === i)) {
        continue;
      }
      let isSingleRow: boolean = true;
      for (let j = 0; j < lastOccupied[i]?.length; j++) {
        let mArea = lastOccupied[i][j]?.area;
        if ((lastOccupied[i][j] && mArea && mArea[1] > 1) || clockWeatherCardRow === i) {
          isSingleRow = false;
          break;
        }
      }
      if (isSingleRow) {
        singleRow.push(i);
      }
    }
    return singleRow;
  }

  private static findMultiRow(needRow: number, lastOccupied: BaseTransferBean[][]): number[] {
    let clockWeatherCardRow: number = ExtractOperator.findClockWeatherCardRow(lastOccupied);
    let cardHeight: number = CommonConstants.NUMBER_TWO;
    
    if (clockWeatherCardRow === CommonConstants.INVALID_VALUE) {
      clockWeatherCardRow = lastOccupied.length - 1;
    } else {
      cardHeight = lastOccupied[clockWeatherCardRow][0].area?.[1] ?? 0;
    }

    for (let offset = needRow; offset < lastOccupied.length; offset++) {
      for (let start = 0; start <= lastOccupied.length - offset; start++) {
        if (clockWeatherCardRow + cardHeight - 1 < lastOccupied.length && clockWeatherCardRow >= start &&
          clockWeatherCardRow <= start + needRow) {
          continue;
        }
        if (ExtractOperator.checkElementOccupied(start, start + offset - 1, lastOccupied)) {
          return ExtractOperator.getElementOccupied(start, start + offset);
        }
      }
    }
    let start = 0;
    if (clockWeatherCardRow < needRow && (clockWeatherCardRow + cardHeight + needRow) <= lastOccupied.length) {
      start = clockWeatherCardRow + cardHeight;
    }
    log.showWarn(TAG, `WeatherCar:${clockWeatherCardRow} needRow:${needRow} lastOccupied:${lastOccupied.length}`);
    return ExtractOperator.getElementOccupied(start, start + needRow);
  }

  private static checkElementOccupied(startRow: number, endRow: number, lastOccupied: BaseTransferBean[][]): boolean {
    for (let i = 0; i < lastOccupied[startRow].length; i++) {
      let tmpRow = lastOccupied[startRow][i].row;
      if (tmpRow !== undefined && tmpRow < startRow) {
        return false;
      }
    }
    for (let i = 0; i < lastOccupied[endRow].length; i++) {
      let tmpRow = lastOccupied[endRow][i].row;
      let tmpArea = lastOccupied[endRow][i].area;
      if (tmpRow === undefined || tmpArea === undefined) {
        continue;
      }
      if (tmpRow + tmpArea[1] > endRow + 1) {
        return false;
      }
    }
    return true;
  }

  private static getElementOccupied(start: number, end : number): number[] {
    let multiRow: number[] = [];
    for (let index = start; index < end; index++) {
      multiRow.push(index);
    }
    return multiRow;
  }

  private static refreshOccupied(children: BaseTransferBean[], grid: number[]): boolean[][] {
    let newOccupied: boolean[][] = [];
    for (let i = 0; i < grid[1]; i++) {
      if (!newOccupied[i]) {
        newOccupied[i] = [];
      }
      for (let j = 0; j < grid[0]; j++) {
        newOccupied[i][j] = false;
      }
    }
    children.forEach(item => {
      if (!item.area || item.row === undefined || item.column === undefined) {
        return;
      }
      for (let i = 0; i < item.area[1]; i++) {
        if (item.row + i >= grid[1]) {
          break;
        }
        for (let j = 0; j < item.area[0]; j++) {
          newOccupied[item.row + i][item.column + j] = true;
        }
      }
    });
    log.showError(TAG, `updateScreenLayoutByMultiRow lastOccupied.length:${newOccupied}`);
    return newOccupied;
  }

  private static updateElementCnt(screenLayout: ScreenTransferBean, moveChildren: BaseTransferBean[]): void {
    let childrens: BaseTransferBean[] = screenLayout.children;
    moveChildren.length > 0 && moveChildren.forEach((item: BaseTransferBean) => {
      let index: number =
        childrens.findIndex(children => item.row === children.row && item.column === children.column);
      childrens.splice(index, 1);
    });
    childrens.length > 0 && childrens.forEach(children => {
      switch (children.typeId) {
        case CommonConstants.TYPE_CARD:
        case CommonConstants.TYPE_FORM_STACK:
          if (children.area) {
            screenLayout.abilityFormUsedCellCnt =
              screenLayout.abilityFormUsedCellCnt + children.area[0] * children.area[1];
          }
          break;
        case CommonConstants.TYPE_FOLDER:
          if (children.area) {
            screenLayout.folderUsedCellCnt = screenLayout.folderUsedCellCnt + children.area[0] * children.area[1];
          }
          break;
        case CommonConstants.TYPE_SHORTCUT_ICON:
        case CommonConstants.TYPE_APP:
          if (children.area) {
            screenLayout.iconUsedCellCnt = screenLayout.iconUsedCellCnt + children.area[0] * children.area[1];
          }
          break;
        default:
          log.showWarn(TAG, `currentPageElements type:${children.typeId} key:type:${children.keyName}`);
          break;
      }
      if (children.area) {
        screenLayout.usedCellCnt = screenLayout.usedCellCnt + children.area[0] * children.area[1];
      }
    });
    log.showInfo(TAG, `updateElementCnt children ${screenLayout.children.length}_moveChildren:${moveChildren.length}`);
  }

  private static extractRow(needRow: number, lastOccupied: BaseTransferBean[][], extractRows: number[]): void {
    if (extractRows.length === 0) {
      return;
    }
    extractRows.splice(needRow);
    extractRows.sort();
    for (let i = extractRows.length - 1; i >= 0; i--) {
      lastOccupied.splice(extractRows[i], 1);
    }
    log.showInfo(TAG, `extractRow lastOccupied.length:${lastOccupied.length},needRow:${needRow} extractRows:${extractRows}`);
    for (let i = 0; i < lastOccupied.length; i++) {
      for (let index = 0; index < lastOccupied[i]?.length; index++) {
        let mRow = lastOccupied[i][index]?.row;
        if (mRow === undefined) {
          continue;
        }
        log.showInfo(TAG, `extractRow item:${lastOccupied[i][index].bundleName}_${lastOccupied[i][index].row}_${i}`);
        if (mRow > i) {
          lastOccupied[i][index].row = i;
        }
      }
    }
  }

  /**
   * 根据需要移除的行，提取待抽离元素
   */
  private static copyExtractChildrenBySingleRow(needRow: number, lastOccupied: BaseTransferBean[][],
    singleRow: number[]): BaseTransferBean[] {
    let extractChildren: BaseTransferBean[] = [];
    for (let i = 0; i < needRow; i++) {
      extractChildren.push(...lastOccupied[singleRow[i]]);
    }
    return extractChildren;
  }

  private static initLastOccupied(children: BaseTransferBean[]): BaseTransferBean[][] {
    let lastOccupied: BaseTransferBean[][] = [];
    children.length > 0 && children.forEach(children => {
      if (!children?.area || children.row === undefined) {
        return;
      }
      for (let i = 0; i < children?.area[1]; i++) {
        let row: number = children.row + i;
        if (!lastOccupied[row]) {
          lastOccupied[row] = [children];
        } else {
          lastOccupied[row].push(children);
        }
      }
    });
    return lastOccupied;
  }

  /**
   * 规则-多行移除：优先移除大元素
   */
  private static copyExtractX2Elements(lastOccupied: BaseTransferBean[][],
    mutiRows: number[], needRow: number): BaseTransferBean[] {
    let extractChildren: BaseTransferBean[] = [];
    for (let i = 0; i < mutiRows.length && i < needRow; i++) {
      ExtractOperator.moveChildren(lastOccupied, mutiRows[i], extractChildren);
    }
    log.showInfo(TAG, `copyExtractX2Elements start:${mutiRows[0]}_${mutiRows[1]}_${extractChildren.length}`);
    return extractChildren;
  }

  private static moveChildren(lastOccupied: BaseTransferBean[][], row: number,
    extractChildren: BaseTransferBean[]): void {
    let childrens: BaseTransferBean[] = lastOccupied[row];
    for (let j = childrens.length - 1; j >= 0; j--) {
      let mArea = childrens[j]?.area;
      if (!mArea) {
        continue;
      }
      if (mArea[1] > 1) {
        if (childrens[j].row === row) {
          extractChildren.push(childrens[j]);
        }
        childrens.splice(j, 1);
      }
    }
  }

  /**
   * 规则-多行移除：移除单行元素
   */
  private static copyExtractX1Elements(needRows: number, lastOccupied: BaseTransferBean[][],
    mutiRows: number[]): BaseTransferBean[] {
    let extractChildren: BaseTransferBean[] = [];
    for (let i = 0; i < needRows; i++) {
      let childrens: BaseTransferBean[] = lastOccupied[mutiRows[i]];
      if (childrens.length < 1) {
        continue;
      }
      for (let j = childrens.length - 1; j >= 0; j--) {
        let mArea = childrens[j]?.area;
        if (!mArea) {
          continue;
        }
        if (mArea[1] === 1) {
          extractChildren.push(childrens[j]);
          childrens.splice(j, 1);
        }
      }
    }
    log.showInfo(TAG, `copyExtractX1Elements start:${mutiRows[0]}_${mutiRows[1]}_${extractChildren.length}`);
    return extractChildren;
  }

  /**
   * 单行移除，更新当前页占位，元素计数，抽离元素
   */
  private static updateScreenLayoutBySingleRow(screenLayout: ScreenTransferBean, needRow: number,
    lastOccupied: BaseTransferBean[][], tag: number[], moveChildren: BaseTransferBean[]): void {
    screenLayout.moveToNextPage.push(...moveChildren);
    ExtractOperator.updateElementCnt(screenLayout, moveChildren);
    ExtractOperator.extractRow(needRow, lastOccupied, tag);
    screenLayout.occupied = ExtractOperator.refreshOccupied(screenLayout.children, ExtractOperator.newScreenArea);
  }

  /**
   * 多行移除，更新当前页占位，元素计数，抽离元素
   */
  private static updateScreenLayoutByMultiRow(screenLayout: ScreenTransferBean, moveChildren: BaseTransferBean[],
    multiRow: number[], lastOccupied: BaseTransferBean[][]): void {
    screenLayout.moveToNextPage.push(...moveChildren);
    ExtractOperator.updateElementCnt(screenLayout, moveChildren);
    multiRow.reverse();
    // 从上往下移除抽离行
    for (let i = 0; i < multiRow.length; i++) {
      if (lastOccupied[multiRow[i]].length < 1) {
        lastOccupied.splice(multiRow[i], 1);
      }
    }
    // 底部元素上移，更新row
    for (let i = 0; i < lastOccupied.length; i++) {
      for (let index = 0; index < lastOccupied[i]?.length; index++) {
        let mLastOccupied = lastOccupied[i][index];
        if (!mLastOccupied || mLastOccupied.row === undefined) {
          continue;
        }
        if (mLastOccupied.row > i) {
          lastOccupied[i][index].row = i;
        }
      }
    }
    log.showWarn(TAG, `updateScreenLayoutByMultiRow lastOccupied.length:${lastOccupied.length}`);
    screenLayout.occupied = ExtractOperator.refreshOccupied(screenLayout.children, ExtractOperator.newScreenArea);
  }

  /**
   * 抽离当前屏元素
   *
   * @param pageLayout 单屏布局
   * @param grid 新机网格大小：grid[0] 列，grid[1] 行
   */
  static extract(screenLayout: ScreenTransferBean, grid: number[]): void {
    if (!screenLayout || screenLayout.children.length < 1) {
      log.showWarn(TAG, 'screenLayout Abnormal data');
      return;
    }
    ExtractOperator.newScreenArea = grid;
    // 旧机布局占位
    let lastOccupied: BaseTransferBean[][] = ExtractOperator.initLastOccupied(screenLayout.children);
    // 没有超出新机最大行数，直接占位
    if (lastOccupied.length <= grid[1]) {
      log.showWarn(TAG, 'No need to extract');
      ExtractOperator.updateElementCnt(screenLayout, []);
      screenLayout.occupied = ExtractOperator.refreshOccupied(screenLayout.children, ExtractOperator.newScreenArea);
      return;
    }
    // 需要抽离的行数
    let needRow: number = lastOccupied.length - grid[1];
    // 规格-抽离空行：天气时钟上的空行 > 从下往上的空行
    let emptyRows: number[] = ExtractOperator.findEmptyRow(lastOccupied);
    ExtractOperator.extractRow(needRow, lastOccupied, emptyRows);
    needRow = needRow - emptyRows.length;
    if (needRow <= 0) {
      log.showWarn(TAG, `Extract empty Rows ${emptyRows}`);
      ExtractOperator.updateElementCnt(screenLayout, []);
      screenLayout.occupied = ExtractOperator.refreshOccupied(screenLayout.children, ExtractOperator.newScreenArea);
      return;
    }

    // 规格-抽离单行：图标行 > 其它元素  从上往下
    let singleRow: number[] = ExtractOperator.findAppRow(lastOccupied);
    if (needRow <= singleRow.length) {
      log.showWarn(TAG, `Extract app Rows ${singleRow}`);
      let moveChildren: BaseTransferBean[] = ExtractOperator.copyExtractChildrenBySingleRow(needRow,
        lastOccupied, singleRow);
      ExtractOperator.updateScreenLayoutBySingleRow(screenLayout, needRow, lastOccupied, singleRow, moveChildren);
      return;
    }

    singleRow.push(...ExtractOperator.findSingleRow(singleRow, lastOccupied));
    if (needRow <= singleRow.length) {
      log.showWarn(TAG, `Extract single Rows ${singleRow}`);
      let moveChildren: BaseTransferBean[] = ExtractOperator.copyExtractChildrenBySingleRow(needRow,
        lastOccupied, singleRow);
      ExtractOperator.updateScreenLayoutBySingleRow(screenLayout, needRow, lastOccupied, singleRow, moveChildren);
      return;
    }

    // 规格-直接抽取多行 从上往下
    let multiRow: number[] = ExtractOperator.findMultiRow(needRow, lastOccupied);
    if (multiRow.length >= needRow) {
      log.showWarn(TAG, `Extract multi Rows  ${multiRow}`);
      let moveChildren: BaseTransferBean[] = ExtractOperator.copyExtractX2Elements(lastOccupied, multiRow, needRow);
      moveChildren.push(...ExtractOperator.copyExtractX1Elements(needRow, lastOccupied, multiRow));
      ExtractOperator.updateScreenLayoutByMultiRow(screenLayout, moveChildren, multiRow, lastOccupied);
      return;
    }
    log.showWarn(TAG, `Extract error lastOccupied:${lastOccupied.length} need:${needRow} emptyRows:${emptyRows.length}` +
      ` singleRow:${singleRow} multiRow:${multiRow.length} `);
  }
}