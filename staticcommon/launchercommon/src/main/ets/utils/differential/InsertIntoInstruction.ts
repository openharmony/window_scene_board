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
import { GridOccupyStatusEnum } from '@ohos/componentdrag';
import { CommonConstants } from '../../constants/CommonConstants';
import { PageDesktopModel } from '../../pagedesktop/model/PageDesktopModel';
import type GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { Instruction } from './Instruction';

const TAG = 'InsertIntoInstruction';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 InsertIntoInstruction.ts
 指定位置进行插入操作操作（仅对位于桌面上的图标生效），支持应用或者1X1文件夹，不支持卡片，如果指定位置无图标，直接插入即可；
 若该位置有图标，则将指定位置的图标以及后面的图标依次向后移动一个位置，到指定位置后面的第一个空位结束，再在指定位置插入图标，
 注意：在指定屏幕满时插入失败，打印错误日志，继续解析其他指令。定制市场布局配置时，常用命令。

 @since 2023-11-20
 */
export class InsertIntoInstruction extends Instruction {
  public constructor(rows: number, columns: number) {
    super(rows, columns);
  }

  protected realize(gridInfo: GridLayoutItemInfo[], item: GridLayoutItemInfo): GridLayoutItemInfo[] {
    const index = gridInfo.findIndex(dataItem => this.isItemExist(dataItem, item));
    if (index !== CommonConstants.INVALID_VALUE) {
      log.showError('The object to be insertinto already exists. Repeated insertion is not allowed.');
      return gridInfo;
    }
    if (item.container === CommonConstants.CONTAINER_SMARTDOCK) {
      return this.dealInsertIntoAppInDock(gridInfo, item);
    }
    if (!this.checkItem(item)) {
      log.showError('The item is invalid!');
      return gridInfo;
    }
    let gridOccupyStatusFlat: GridOccupyStatusEnum[] = PageDesktopModel.getInstance().
      getGridOccupyStatusEnumForInsertInto(gridInfo, this.rows, this.columns, item.page ?? -1).flat();
    let item2PositionMap: Map<number, GridLayoutItemInfo> = this.getItemRelatedPosition(gridInfo, item.page ?? -1);
    const toInsertPosition = (item.row ?? 0) * this.columns + (item.column ?? 0);
    let statusOfInsertPosition = gridOccupyStatusFlat[toInsertPosition];
    if (statusOfInsertPosition !== GridOccupyStatusEnum.FREE) {
      let nearFreePosition = gridOccupyStatusFlat.slice(toInsertPosition).findIndex((item) => {
        return item === GridOccupyStatusEnum.FREE;
      });
      if (nearFreePosition === CommonConstants.INVALID_VALUE) {
        log.showError('insertinto op error, no enough room!');
        return gridInfo;
      }
      let needToMoveItemsIndex: number[] = [];
      for (let index = toInsertPosition; index < toInsertPosition + nearFreePosition; index++) {
        if (gridOccupyStatusFlat[index] === GridOccupyStatusEnum.OCCUPIED) {
          needToMoveItemsIndex.push(index);
        }
      }
      // 对原有的对象进行移位操作
      this.swap(item2PositionMap, needToMoveItemsIndex, toInsertPosition + nearFreePosition);
    }
    // 将新增对象放到指定位置
    log.showInfo('Layout element inserted successfully.');
    gridInfo.push(item);
    return gridInfo;
  }

  private getItemRelatedPosition(layoutInfo: GridLayoutItemInfo[], pageIndex: number): Map<number, GridLayoutItemInfo> {
    let item2PositionMap: Map<number, GridLayoutItemInfo> = new Map();
    for (let j = 0; j < layoutInfo.length; ++j) {
      let item = layoutInfo[j];
      if (item.page === pageIndex && item.container === CommonConstants.CONTAINER_DESKTOP && this.isOnePlusOneItem(item)) {
        const position = (item.row ?? 0) * this.columns + (item.column ?? 0);
        item2PositionMap.set(position, item);
      }
    }
    return item2PositionMap;
  }

  private swap(item2PositionMap: Map<number, GridLayoutItemInfo>, needToMoveItemsIndex: number[], lastPos: number): void {
    // 对原有的元素进行挤位操作，依次往后占位
    needToMoveItemsIndex.forEach((item, index) => {
      // 获取待移位的对象
      let itemToModify: GridLayoutItemInfo | undefined = item2PositionMap.get(item);
      if (!itemToModify) {
        return;
      }
      // 判断是否是最后一个元素，如果是最后一个，直接将行列更新为空位的坐标，否则更新为下一个元素的坐标
      if (index < needToMoveItemsIndex.length - 1) {
        let itemToPlaceholder: GridLayoutItemInfo | undefined = item2PositionMap.get(needToMoveItemsIndex[index + 1]);
        itemToModify.row = itemToPlaceholder?.row;
        itemToModify.column = itemToPlaceholder?.column;
      } else {
        itemToModify.row = Math.floor(lastPos / this.columns);
        itemToModify.column = lastPos % this.columns;
      }
    });
  }

  private dealInsertIntoAppInDock(gridInfo: GridLayoutItemInfo[], item: GridLayoutItemInfo): GridLayoutItemInfo[] {
    if (!this.checkDockApp(item)) {
      log.showWarn('The attribute of the element inserted into the dock area is incorrect, please check!');
      return gridInfo;
    }
    const dockApps = gridInfo.filter(itemTemp => itemTemp.container === CommonConstants
      .CONTAINER_SMARTDOCK).sort((firstItem, secondItem) => (firstItem.column ?? 0) - (secondItem.column ?? 0));
    if (dockApps.length < this.DOCK_APP_MAX_NUMBER) {
      log.showInfo('Layout element inserted successfully.');
      let position = dockApps.findIndex(dataItem => {
        return dataItem.column === item.column;
      });
      // 判断是否位置被占用
      if (position !== CommonConstants.INVALID_VALUE) {
        // 如果占用，则要进行挤位操作,修改dock指定位置后面的app的坐标
        dockApps.forEach((dockItem, index) => {
          if (index >= position) {
            dockItem.column = ++position;
          }
        });
        // 新应用插入到dock区指定位置
        gridInfo.push(item);
        log.showInfo('Inserting the layout element to the dock area succeeded.');
      } else {
        // dock区位置没有被占用，直接插入
        gridInfo.push(item);
        log.showInfo('Inserting the layout element to the dock area succeeded.');
      }
    } else {
      log.showError(`insert op error, the dock no enough room ,the item is : ${item.bundleName}`);
    }
    return gridInfo;
  }
}

