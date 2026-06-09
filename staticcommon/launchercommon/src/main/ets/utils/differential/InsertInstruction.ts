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
import { CommonConstants } from '../../constants/CommonConstants';
import { PageDesktopModel } from '../../pagedesktop/model/PageDesktopModel';

import type GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import DefaultDesktopLayoutInfo from '../../configs/DefaultDesktopLayoutInfo';
import { Instruction } from './Instruction';
import { InstructionManager } from './InstructionManager';

const TAG = 'InsertInstruction';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * InsertInstruction.ts
 * 指定坐标进行插入操作操作（仅对位于桌面上的图标生效），支持应用或者文件夹，不支持卡片，如果指定位置无图标，直接插入即可；
 * 如果指定位置有图标，则插入指令失效，打印错误日志，继续解析其他指令；一般不使用。
 *
 * @since 2023-11-20
 */
export class InsertInstruction extends Instruction {
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
    const index = gridInfo.findIndex(dataItem => this.isItemExist(dataItem, item));
    if (index !== CommonConstants.INVALID_VALUE) {
      log.showError('The object to be inserted already exists. Repeated insertion is not allowed.');
      return gridInfo;
    }
    if (item.container === CommonConstants.CONTAINER_SMARTDOCK) {
      return this.dealInsertAppInDock(gridInfo, item);
    } else {
      let desktopLayoutInfo: DefaultDesktopLayoutInfo | null = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      desktopLayoutInfo.layoutInfo = gridInfo;
      desktopLayoutInfo.layoutDescription.column = this.columns;
      desktopLayoutInfo.layoutDescription.row = this.rows;
      if (PageDesktopModel.getInstance().isPositionValid(desktopLayoutInfo, item, item.page ?? -1,
        item.column ?? 0, item.row ?? 0)) {
        gridInfo.push(item);
        log.showInfo('Layout element inserted successfully.');
      } else {
        log.showError('insert op error, the workspace no enough room.');
      }
      desktopLayoutInfo = null;
    }
    return gridInfo;
  }

  private dealInsertAppInDock(gridInfo: GridLayoutItemInfo[], item: GridLayoutItemInfo): GridLayoutItemInfo[] {
    if (!this.checkDockApp(item)) {
      log.showWarn('The attribute of the element inserted into the dock area is incorrect, please check!');
      return gridInfo;
    }
    const dockApps = gridInfo.filter(itemTemp => itemTemp.container === CommonConstants
      .CONTAINER_SMARTDOCK);
    if (dockApps.length < this.DOCK_APP_MAX_NUMBER) {
      const position = dockApps.findIndex(dataItem => {
        return dataItem.column === item.column;
      });
      if (position === CommonConstants.INVALID_VALUE) {
        gridInfo.push(item);
        log.showInfo('Inserting the layout element to the dock area succeeded.');
      } else {
        log.showError(`insert op error, The dock area is occupied.  the column is :${item.column}`);
      }
    } else {
      log.showError(`insert op error, the dock no enough room ,the item is : ${item.bundleName}`);
    }
    return gridInfo;
  }
}


