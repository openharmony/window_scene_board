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
import DefaultDesktopLayoutInfo from '../../configs/DefaultDesktopLayoutInfo';
import { Instruction } from './Instruction';

const TAG = 'AddInstruction';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * AddInstruction.ts
 * 在指定屏幕或者最后一屏的最后一个图标后面添加图标，支持应用或者1X1文件夹，不支持卡片与大文件夹，不需要指定位置x和y，由程序自动计算，
 * 如果配置了screen，则在指定的screen的最后一个图标后面添加，若指定的screen上没有位置，则在日志中增加一条错误记录："Add op error, no enough room!"；
 * 如果没有配置screen，则在最后一屏的最后一个图标后面追加，若最右一屏上没有位置，则新增一屏，并在第一个位置添加图标。
 *
 * @since 2023-11-21
 */
export class AddInstruction extends Instruction {

  /**
   * 构造器
   *
   * @param rows 屏幕的最大行数
   * @param columns 屏幕的最大列数
   */
  public constructor(rows: number, columns: number) {
    super(rows, columns);
  }

  protected realize(gridInfo: GridLayoutItemInfo[], item: GridLayoutItemInfo): GridLayoutItemInfo[] {
    if (gridInfo === null || item === null) {
      log.showError('AddInstruction gridInfo is null or item is null');
      return gridInfo;
    }

    if (!this.isOnePlusOneItem(item)) {
      log.showError('This layout element cannot be added.');
      return gridInfo;
    }
    const index = gridInfo.findIndex(dataItem => this.isItemExist(dataItem, item));
    if (index !== CommonConstants.INVALID_VALUE) {
      log.showError('Layout element exists.');
      return gridInfo;
    }

    if (item.container === CommonConstants.CONTAINER_SMARTDOCK) {
      return this.dealAddAppInDock(gridInfo, item);
    } else {
      return this.dealAddAppInDesktop(gridInfo, item);
    }
  }

  private dealAddAppInDock(gridInfo: GridLayoutItemInfo[], item: GridLayoutItemInfo): GridLayoutItemInfo[] {
    const dockAppSize = gridInfo.filter(itemTemp => itemTemp.container === CommonConstants
      .CONTAINER_SMARTDOCK).length;
    if (dockAppSize < this.DOCK_APP_MAX_NUMBER) {
      gridInfo.push(item);
      log.showInfo('Adding the layout element to the dock area succeeded.');
    } else {
      log.showError(`add op error, the dock no enough room ,the item is : ${item.bundleName}`);
    }
    return gridInfo;
  }

  private dealAddAppInDesktop(gridInfo: GridLayoutItemInfo[], item: GridLayoutItemInfo): GridLayoutItemInfo[] {
    // 指定page属性的处理逻辑 ：在指定的screen的最后一个图标后面添加，若指定的screen上没有位置，则在日志中增加一条错误记录："Add op error, no enough room!"
    if (typeof item.page !== 'undefined') {
      let gridOccupyStatusFlat = PageDesktopModel.getInstance().getGridOccupyStatusEnum(gridInfo, this.rows, this.columns, item.page).flat();
      let lastIndex = gridOccupyStatusFlat.lastIndexOf(GridOccupyStatusEnum.OCCUPIED);
      if (lastIndex === gridOccupyStatusFlat.length - 1) {
        log.showError('Add op error, no enough room!');
      } else {
        item.row = Math.floor((lastIndex + 1) / this.columns);
        item.column = (lastIndex + 1) % this.columns;
        gridInfo.push(item);
        log.showInfo('Adding the layout element to the desktop succeeded.');
      }
      return gridInfo;
    }
    // 未指定page场景的处理逻辑：先获取最后一页，然后判断最后一页最后一个元素后面是否有空位
    let maxPage = gridInfo?.filter((item => {
      return item.container?.valueOf() !== CommonConstants.CONTAINER_SMARTDOCK;
    })).sort((item1, item2) => {
      return (item2.page ?? 0) - (item1.page ?? 0);
    })[0]?.page?.valueOf();
    let gridOccupyStatusFlat = PageDesktopModel.getInstance().getGridOccupyStatusEnum(gridInfo, this.rows,
      this.columns, maxPage ?? 0).flat();
    let lastIndex = gridOccupyStatusFlat.lastIndexOf(GridOccupyStatusEnum.OCCUPIED);
    if (lastIndex === gridOccupyStatusFlat.length - 1) {
      // 最后一页已经没有空位，需要新增一页
      item.page = (maxPage?.valueOf() ?? 0) + 1;
      item.row = 0;
      item.column = 0;
    } else {
      // 在当前页最后一个占位后面增加一个元素
      item.page = maxPage?.valueOf();
      item.row = Math.floor((lastIndex + 1) / this.columns);
      item.column = (lastIndex + 1) % this.columns;
    }
    gridInfo.push(item);
    log.showInfo('Adding the layout element to the desktop succeeded.');
    return gridInfo;
  }
}