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

import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';
import { CommonConstants } from '../../TsIndex';
import { BaseTransferBean } from '../BaseTransferBean';
import ScreenTransferBean from '../ScreenTransferBean';

const TAG = 'CoverPositionOperator';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);

/**
 * 补位操作
 */
export class CoverPositionOperator {
  /**
   * 单屏补位
   *
   * @param screenLayout 单屏布局
   */
  public static coverPosition(screenLayout: ScreenTransferBean): void {
    if (CheckEmptyUtils.isEmptyArr(screenLayout.children)) {
      log.showError(TAG, `screen layout is null`);
      return;
    }
    log.showInfo(TAG, `coverPosition`);

    //排序
    this.sortScreenLayoutChildren(screenLayout);

    screenLayout.children.forEach((item) => {
      CoverPositionOperator.fillOccupied(screenLayout.occupied, true, item);
    });

    //找该页是否存在时钟卡片
    for (let item of screenLayout.children) {
      if (CommonConstants.TRANSLUCENT_CLOCK_WEATHER_CARD.includes(item.cardName ?? '')) {
        CoverPositionOperator.handleWeatherForm(item, screenLayout);
      }
    }

    //occupied全置为false
    screenLayout.occupied.forEach((row) => {
      row.fill(false);
    });

    //区分出所有图标以及快捷方式，以及其他元素(固定非1*1元素)
    screenLayout.children.forEach((item) => {
      if (item.typeId !== CommonConstants.TYPE_APP && item.typeId !== CommonConstants.TYPE_SHORTCUT_ICON) {
        CoverPositionOperator.markArea(screenLayout.occupied, item.row ?? 0, item.column ?? 0, item);
      }
    });
    screenLayout.children.forEach((item) => {
      if (item.typeId === CommonConstants.TYPE_APP || item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        CoverPositionOperator.layoutElem(screenLayout.occupied, item);
      }
    });
    //处理小文件夹
    screenLayout.children.forEach((item) => {
      if (!item.area) {
        return;
      }
      if (item.typeId === CommonConstants.TYPE_FOLDER && item.area[0] === 1 && item.area[1] === 1) {
        CoverPositionOperator.fillOccupied(screenLayout.occupied, false, item);
        CoverPositionOperator.layoutElem(screenLayout.occupied, item);
      }
    });
    //若还有空位再次补位
    screenLayout.children.forEach((item) => {
      if (item.typeId !== CommonConstants.TYPE_APP &&
          !CommonConstants.TRANSLUCENT_CLOCK_WEATHER_CARD.includes(item.cardName ?? '')) {
        CoverPositionOperator.fillOccupied(screenLayout.occupied, false, item);
        CoverPositionOperator.layoutElem(screenLayout.occupied, item);
      }
    });
  }

  private static sortScreenLayoutChildren(screenLayout: ScreenTransferBean): void {
    screenLayout.children.sort((a, b): number => {
      if (a.row === b.row) {
        return (a.column ?? 0) - (b.column ?? 0);
      }
      return (a.row ?? 0) - (b.row ?? 0);
    });
  }

  private static handleWeatherForm(item: BaseTransferBean, screenLayout: ScreenTransferBean): void {
    const cardRow: number = item.row ?? 0;
    const emptyRow: number[] = CoverPositionOperator.findRowEmpty(screenLayout.occupied, cardRow);
    if (!emptyRow) {
      return;
    }
    for (let i = 0; i < emptyRow.length; ++i) {
      CoverPositionOperator.shiftElementsUp(screenLayout.children, emptyRow[i]);
    }
    CoverPositionOperator.upDateOccupied(screenLayout);
  }

  private static upDateOccupied(screenLayout: ScreenTransferBean): void {
    screenLayout.occupied.forEach((row) => {
      row.fill(false);
    });
    screenLayout.children.forEach((item) => {
      CoverPositionOperator.fillOccupied(screenLayout.occupied, true, item);
    });
  }

  //填充Occupied
  private static fillOccupied(occupied: boolean[][], fillValue: boolean, transferBean?: BaseTransferBean): void {
    if (transferBean && transferBean.row !== undefined && transferBean.area && transferBean.column !== undefined) {
      let rowSpan: number = transferBean.row + transferBean.area[1];
      for (let i = transferBean.row; i < rowSpan; i++) {
        occupied[i].fill(fillValue, transferBean.column, transferBean.column + transferBean.area[0]);
      }
    }
  }

  //找天气时钟卡片上方的空行
  private static findRowEmpty(layoutMatrix: boolean[][], cardRow: number): number[] {
    let emptyRow: number[] = [];
    for (let i = cardRow; i >= 0; --i) {
      if (layoutMatrix[i].every(item => !item)) {
        emptyRow.push(i);
      }
    }
    log.showInfo(TAG, `emptyRow length: ${emptyRow.length}`);
    return emptyRow;
  }

  private static shiftElementsUp(originLayout: BaseTransferBean[], emptyRow: number): void {
    originLayout.forEach((item) => {
      if (item.row === undefined) {
        return;
      }
      if (item.row > emptyRow) {
        item.row--;
      }
    });
  }

  private static isAreaFree(layoutMatrix: boolean[][], startRow: number, startCol: number,
    curElem: BaseTransferBean): boolean {
    if (!curElem.area) {
      return false;
    }
    if (startRow + curElem.area[1] > layoutMatrix.length) {
      return false;
    }
    if (startCol + curElem.area[0] > layoutMatrix[0].length) {
      return false;
    }
    for (let row = startRow; row < startRow + curElem.area[1]; row++) {
      for (let col = startCol; col < startCol + curElem.area[0]; col++) {
        if (layoutMatrix[row][col] === true) {
          return false;
        }
      }
    }
    log.showInfo(TAG, `${curElem.bundleName} has free area ${curElem.area}`);
    return true;
  }

  private static markArea(layoutMatrix: boolean[][], startRow: number, startCol: number,
    curElem: BaseTransferBean): void {
    if (!curElem.area) {
      return;
    }
    for (let row = startRow; row < startRow + curElem.area[1]; row++) {
      for (let col = startCol; col < startCol + curElem.area[0]; col++) {
        layoutMatrix[row][col] = true;
      }
    }
    log.showInfo(TAG, `${curElem.bundleName} mark area: ${curElem.area} row: ${curElem.row}, col: ${curElem.column}`);
  }

  private static layoutElem(layoutMatrix: boolean[][], element: BaseTransferBean): void {
    if (!element.area) {
      return;
    }
    // 从上到下遍历行
    for (let row = 0; row <= layoutMatrix.length - element.area[1]; row++) {
      // 从左到右遍历列
      for (let col = 0; col <= layoutMatrix[0].length - element.area[0]; col++) {
        if (CoverPositionOperator.isAreaFree(layoutMatrix, row, col, element)) {
          //找到新位置释放原位置
          // 更新元素位置
          element.row = row;
          element.column = col;
          // 标记矩阵占用
          CoverPositionOperator.markArea(layoutMatrix, row, col, element);
          return;
        }
      }
    }
  }
}