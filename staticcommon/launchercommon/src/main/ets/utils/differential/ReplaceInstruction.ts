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
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { Instruction } from './Instruction';
import { CommonConstants } from '../../constants/CommonConstants';
import { PageDesktopModel } from '../../pagedesktop/model/PageDesktopModel';
import { folderLayoutInfo } from '../../folder/FolderLayoutInfo';

const TAG = 'ReplaceInstruction';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

enum DealingType {
  INSERT_INTO_DESKTOP = 'INSERT_INTO_DESKTOP',
  INSET_INTO_DOCK = 'INSET_INTO_DOCK',
  ADD_TO_FOLDER = 'ADD_TO_FOLDER',
  NO_CHANGE_INVALID_REPLACEMENT = 'NO_CHANGE_INVALID_REPLACEMENT',
  NO_CHANGE_FULL_SCREEN = 'NO_CHANGE_FULL_SCREEN',
  NO_CHANGE_FULL_DOCK = 'NO_CHANGE_FULL_DOCK'
}

/**
 * ReplaceInstruction.ts
 * 差分应用替换预置布局应用或小文件夹
 * 被替换应用或小文件夹支持插入到指定应用或小文件夹前/后
 * 被替换应用支持插入到指定小文件夹头/尾
 */

export class ReplaceInstruction extends Instruction {
  private readonly maxFolderRow = folderLayoutInfo.folderOpenLayoutTable.row;
  private readonly maxFolderColumn = folderLayoutInfo.folderOpenLayoutTable.column;

  public constructor(rows: number, columns: number) {
    super(rows, columns);
  }

  protected realize(gridInfo: GridLayoutItemInfo[], item: GridLayoutItemInfo): GridLayoutItemInfo[] {
    log.showInfo(`ReplaceInstruction starts, the appItem is ${item.bundleName}`);
    const replacementIndex = gridInfo.findIndex(dataItem => this.isReplacementExist(dataItem, item));
    if (replacementIndex === CommonConstants.INVALID_VALUE || !this.isOnePlusOneItem(gridInfo[replacementIndex])) {
      log.showError('Replacement not exist or it is not one plus one element');
      return gridInfo;
    }
    if (item.settlement === undefined) {
      this.dealInsertIntoScreenEnd(gridInfo, item, replacementIndex);
      return gridInfo;
    }
    const settlementIndex = gridInfo.findIndex(dataItem => this.isSettlementExist(dataItem, item));
    if (settlementIndex === CommonConstants.INVALID_VALUE || !this.isOnePlusOneItem(gridInfo[settlementIndex])) {
      log.showError(`Settlement not exist or it is not one plus one element`);
      return gridInfo;
    }
    const dealingType: DealingType = this.getDealingType(gridInfo, item, replacementIndex, settlementIndex);
    switch (dealingType) {
      case DealingType.NO_CHANGE_INVALID_REPLACEMENT:
        log.showError(`Can not add a folder into a folder`);
        return gridInfo;
      case DealingType.NO_CHANGE_FULL_SCREEN:
        log.showError(`Screen to be inserted is full`);
        return gridInfo;
      case DealingType.NO_CHANGE_FULL_DOCK:
        log.showError(`SmartDock is full`);
        return gridInfo;
      case DealingType.INSERT_INTO_DESKTOP:
        return this.dealInsertIntoDesktop(gridInfo, item, replacementIndex, settlementIndex);
      case DealingType.INSET_INTO_DOCK:
        return this.dealInsertIntoDock(gridInfo, item, replacementIndex, settlementIndex);
      case DealingType.ADD_TO_FOLDER:
        return this.dealAddToFolder(gridInfo, item, replacementIndex, settlementIndex);
      default:
        return gridInfo;
    }
  }

  private isReplacementExist(existItem: GridLayoutItemInfo, modifyItem: GridLayoutItemInfo): boolean {
    if (modifyItem.replacementTypeId === CommonConstants.TYPE_APP) {
      return existItem.bundleName === modifyItem.replacement;
    } else if (modifyItem.replacementTypeId === CommonConstants.TYPE_FOLDER) {
      return existItem.folderId === modifyItem.replacement;
    }
    return false;
  }

  private isSettlementExist(existItem: GridLayoutItemInfo, modifyItem: GridLayoutItemInfo): boolean {
    if (modifyItem.settlementTypeId === CommonConstants.TYPE_APP) {
      return existItem.bundleName === modifyItem.settlement;
    } else if (modifyItem.settlementTypeId === CommonConstants.TYPE_FOLDER) {
      return existItem.folderId === modifyItem.settlement;
    }
    return false;
  }

  private getDealingType(gridInfo: GridLayoutItemInfo[], modifyItem: GridLayoutItemInfo, replacementIndex: number,
    settlementIndex: number): DealingType {
    const oriSettlement = gridInfo[settlementIndex];
    const oriReplacement = gridInfo[replacementIndex];
    if (oriSettlement.container === CommonConstants.CONTAINER_DESKTOP && modifyItem.settlementPosition !== this.POSITION.TOP &&
      modifyItem.settlementPosition !== this.POSITION.BOTTOM) {
        const pageOccupyStatusFlat: GridOccupyStatusEnum[] = PageDesktopModel.getInstance().
        getGridOccupyStatusEnumForInsertInto(gridInfo, this.rows, this.columns, oriSettlement.page ?? -1).flat();
        if (pageOccupyStatusFlat[pageOccupyStatusFlat.length - 1] === GridOccupyStatusEnum.FREE) {
          return DealingType.INSERT_INTO_DESKTOP;
        } else {
          return DealingType.NO_CHANGE_FULL_SCREEN;
        }
    };
    if (oriSettlement.container === CommonConstants.CONTAINER_SMARTDOCK && modifyItem.settlementPosition !== this.POSITION.TOP &&
      modifyItem.settlementPosition !== this.POSITION.BOTTOM) {
        if (gridInfo.filter(dataItem => dataItem.container === CommonConstants.CONTAINER_SMARTDOCK).length < this.DOCK_APP_MAX_NUMBER) {
          return DealingType.INSET_INTO_DOCK;
        } else {
          return DealingType.NO_CHANGE_FULL_DOCK;
        }
    }
    if (oriSettlement.typeId === CommonConstants.TYPE_FOLDER && (modifyItem.settlementPosition === this.POSITION.TOP ||
      modifyItem.settlementPosition === this.POSITION.BOTTOM) && oriReplacement.typeId !== CommonConstants.TYPE_FOLDER) {
      return DealingType.ADD_TO_FOLDER;
    }
    return DealingType.NO_CHANGE_INVALID_REPLACEMENT;
  }

  private dealInsertIntoDesktop(gridInfo: GridLayoutItemInfo[], item: GridLayoutItemInfo, replacementIndex: number,
    settlementIndex: number): GridLayoutItemInfo[] {
    log.showInfo(`dealInsertIntoDesktop start, appItem is ${item.bundleName}, indexes are ${replacementIndex}, ${settlementIndex}`);
    let replacementItem = JSON.parse(JSON.stringify(gridInfo[replacementIndex])) as GridLayoutItemInfo;
    let settlementItem = JSON.parse(JSON.stringify(gridInfo[settlementIndex])) as GridLayoutItemInfo;
    this.setModifyItemStatus(item, replacementItem);
    replacementItem.container = CommonConstants.CONTAINER_DESKTOP;
    replacementItem.page = settlementItem.page;
    let indexToChange: number[] = [];
    let occupyFlat = PageDesktopModel.getInstance().getGridOccupyStatusEnumForInsertInto(gridInfo, this.rows,
      this.columns, settlementItem.page ?? -1).flat();
    const settlementOccupy = (settlementItem.row ?? 0) * this.columns + (settlementItem.column ?? 0);
    const firstFree = occupyFlat.findIndex((itemData, itemIndex)=> itemData === GridOccupyStatusEnum.FREE && itemIndex > settlementOccupy);
    if (item.settlementPosition === this.POSITION.BEFORE) {
      gridInfo.forEach((itemV, itemI) => {
        if (this.isElementBetweenSettleAndFree(itemV, settlementItem.page ?? -1, settlementOccupy, firstFree)) {
          indexToChange.push(itemI);
        }
      });
      indexToChange.unshift(settlementIndex);
      this.handleItemSwap(gridInfo, indexToChange, firstFree);
      replacementItem.row = settlementItem.row;
      replacementItem.column = settlementItem.column;
      gridInfo.splice(replacementIndex, 1, item);
      settlementIndex === 0 ? gridInfo.unshift(replacementItem) : gridInfo.splice(settlementIndex - 1, 0, replacementItem);
      log.showInfo(`Insert into desktop success`);
    } else if (item.settlementPosition === this.POSITION.AFTER) {
      gridInfo.forEach((itemV, itemI) => {
        if (this.isElementBetweenSettleAndFree(itemV, settlementItem.page ?? -1, settlementOccupy, firstFree)) {
          indexToChange.push(itemI);
        }
      });
      if (indexToChange.length === 0) {
        replacementItem.row = Math.floor(firstFree / this.columns);
        replacementItem.column = firstFree % this.columns;
      } else {
        replacementItem.row = gridInfo[indexToChange[0]].row;
        replacementItem.column = gridInfo[indexToChange[0]].column;
        this.handleItemSwap(gridInfo, indexToChange, firstFree);
      }
      gridInfo.splice(replacementIndex, 1, item);
      gridInfo.splice(settlementIndex, 0, replacementItem);
      log.showInfo(`Insert into desktop success`);
    } else {
      log.showError(`Settlement position is invalid, insert into desktop failed`);
    }
    return gridInfo;
  }

  private dealInsertIntoDock(gridInfo: GridLayoutItemInfo[], item: GridLayoutItemInfo, replacementIndex: number,
    settlementIndex: number): GridLayoutItemInfo[] {
    log.showInfo(`dealInsertIntoDock start, appItem is ${item.bundleName}, indexes are ${replacementIndex}, ${settlementIndex}`);
    let replacementItem = JSON.parse(JSON.stringify(gridInfo[replacementIndex])) as GridLayoutItemInfo;
    const settlementItem = JSON.parse(JSON.stringify(gridInfo[settlementIndex])) as GridLayoutItemInfo;
    this.setModifyItemStatus(item, replacementItem);
    if (item.settlementPosition === this.POSITION.BEFORE) {
      replacementItem.column = settlementItem.column;
      gridInfo.forEach((itemV, itemI, arr) => {
        if (itemV.container === CommonConstants.CONTAINER_SMARTDOCK && itemI >= settlementIndex) {
          arr[itemI].column = (arr[itemI].column ?? 0) + 1;
        }
      });
    } else if (item.settlementPosition === this.POSITION.AFTER) {
      gridInfo.forEach((itemV, itemI, arr) => {
        if (itemV.container === CommonConstants.CONTAINER_SMARTDOCK && itemI > settlementIndex) {
          arr[itemI].column = (arr[itemI].column ?? 0) + 1;
        }
      });
      replacementItem.column = (settlementItem.column ?? 0) + 1;
    } else {
      log.showError(`Settlement position is invalid, insert into desktop failed`);
      return gridInfo;
    }
    replacementItem.container = CommonConstants.CONTAINER_SMARTDOCK;
    gridInfo.splice(replacementIndex, 1, item);
    gridInfo.push(replacementItem);
    log.showInfo(`Insert into dock success`);
    return gridInfo;
  }

  private dealAddToFolder(gridInfo: GridLayoutItemInfo[], item: GridLayoutItemInfo, replacementIndex: number,
    settlementIndex: number): GridLayoutItemInfo[] {
    log.showInfo(`dealAddToFolder start, appItem is ${item.bundleName}, indexes are ${replacementIndex}, ${settlementIndex}`);
    let replacementItem = JSON.parse(JSON.stringify(gridInfo[replacementIndex])) as GridLayoutItemInfo;
    const targetFolderLayout = gridInfo[settlementIndex].layoutInfo?.[0];
    if (!targetFolderLayout) {
      return gridInfo;
    }
    this.setModifyItemStatus(item, replacementItem);
    if (item.settlementPosition === this.POSITION.TOP) {
      targetFolderLayout.forEach((itemV, itemI, arr) => {
        let curItem = arr[itemI];
        if (itemV.column === undefined || curItem.column === undefined ||
          itemV.row === undefined || curItem.row === undefined || curItem.page === undefined) {
          return;
        }
        if (itemV.column < this.maxFolderColumn - 1) {
          curItem.column += 1;
        } else if (itemV.column === this.maxFolderColumn - 1 && itemV.row < this.maxFolderRow - 1) {
          curItem.column = 0;
          curItem.row += 1;
        } else {
          curItem.page += 1;
          curItem.column = 0;
          curItem.row = 0;
        }
      });
      replacementItem.container = gridInfo[settlementIndex].container;
      replacementItem.page = 0;
      replacementItem.column = 0;
      replacementItem.row = 0;
      gridInfo.splice(replacementIndex, 1, item);
      targetFolderLayout.unshift(replacementItem);
      log.showInfo(`Add into folder success`);
    } else if (item.settlementPosition === this.POSITION.BOTTOM) {
      let itemCount = targetFolderLayout.length;
      replacementItem.container = gridInfo[settlementIndex].container;
      replacementItem.page = Math.floor(itemCount / (this.maxFolderColumn * this.maxFolderRow));
      replacementItem.column = itemCount % this.maxFolderColumn;
      replacementItem.row = Math.floor((itemCount % (this.maxFolderColumn * this.maxFolderRow)) / this.maxFolderColumn);
      gridInfo.splice(replacementIndex, 1, item);
      targetFolderLayout.push(replacementItem);
      log.showInfo(`Add into folder success`);
    } else {
      log.showError(`Settlement position is invalid, insert into desktop failed`);
    }
    return gridInfo;
  }

  private dealInsertIntoScreenEnd(gridInfo: GridLayoutItemInfo[], item: GridLayoutItemInfo,
    replacementIndex: number): GridLayoutItemInfo[] {
    log.showInfo(`dealInsertIntoScreenEnd start, appItem is ${item.bundleName} index is ${replacementIndex}`);
    let replacementItem = JSON.parse(JSON.stringify(gridInfo[replacementIndex])) as GridLayoutItemInfo;
    this.setModifyItemStatus(item, replacementItem);
    // 将被替换元素插入到最后一屏第一个空位，若最后一屏满，则新增一屏，插入到新一屏中
    const lastPageBadge = gridInfo[gridInfo.length - 1].page;
    let lastPageOccupyFlat = PageDesktopModel.getInstance().getGridOccupyStatusEnumForInsertInto(gridInfo, this.rows,
      this.columns, lastPageBadge ?? -1).flat();
    let lastOccupyIndex = Math.max(lastPageOccupyFlat.lastIndexOf(GridOccupyStatusEnum.OCCUPIED),
      lastPageOccupyFlat.lastIndexOf(GridOccupyStatusEnum.UNKNOWN));
    if (lastOccupyIndex === lastPageOccupyFlat.length - 1) {
      replacementItem.page = (lastPageBadge?.valueOf() ?? 0) + 1;
      replacementItem.column = 0;
      replacementItem.row = 0;
    } else {
      replacementItem.page = lastPageBadge?.valueOf();
      replacementItem.column = (lastOccupyIndex + 1) % this.columns;
      replacementItem.row = Math.floor((lastOccupyIndex + 1) / this.columns);
    };
    replacementItem.container = CommonConstants.CONTAINER_DESKTOP;
    gridInfo.splice(replacementIndex, 1, item);
    gridInfo.push(replacementItem);
    log.showInfo(`Insert into screen's end success`);
    return gridInfo;
  }

  private setModifyItemStatus(modifyItem: GridLayoutItemInfo, replacementItem: GridLayoutItemInfo): void {
    modifyItem.typeId = CommonConstants.TYPE_APP;
    modifyItem.area = [1, 1];
    modifyItem.container = replacementItem.container;
    modifyItem.page = replacementItem.page;
    modifyItem.column = replacementItem.column;
    modifyItem.row = replacementItem.row;
  }

  private handleItemSwap(gridInfo: GridLayoutItemInfo[], indexToChange: number[], lastIndex: number): void {
    for (let j = 0; j < indexToChange.length; j++) {
      let curItem = gridInfo[indexToChange[j]];
      if (j === indexToChange.length - 1) {
        curItem.row = Math.floor(lastIndex / this.columns);
        curItem.column = lastIndex % this.columns;
      } else {
        curItem.row = gridInfo[indexToChange[j + 1]].row;
        curItem.column = gridInfo[indexToChange[j + 1]].column;
      }
    }
  }

  private isElementBetweenSettleAndFree(element: GridLayoutItemInfo, settlementPage: number, settleOccupy: number, firstFree: number): boolean {
    const elementOccupy = (element.row ?? 0) * this.columns + (element.column ?? 0);
    return element.page === settlementPage && elementOccupy > settleOccupy && elementOccupy < firstFree &&
      this.isOnePlusOneItem(element);
  }
}