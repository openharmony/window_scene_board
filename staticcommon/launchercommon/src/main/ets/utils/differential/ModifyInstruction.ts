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
import type GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { PageDesktopModel } from '../../pagedesktop/model/PageDesktopModel';
import { Instruction } from './Instruction';
import DefaultDesktopLayoutInfo from '../../configs/DefaultDesktopLayoutInfo';
import { CommonConstants } from '../../constants/CommonConstants';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'ModifyInstruction';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const APP_2_DOCK = 'APP_2_DOCK';
const DOCK_2_APP = 'DOCK_2_APP';
const NOT_SUPPORT = 'NOT_SUPPORT';
const TYPE_NO_CHANGE = 'TYPE_NO_CHANGE';

/**
 * ModifyInstruction
 */
export default class ModifyInstruction extends Instruction {
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
    if (index === CommonConstants.INVALID_VALUE) {
      log.showError('The item to be modified does not exist.');
      return gridInfo;
    }
    const changeType = this.getModifyType(gridInfo[index], item);
    log.showInfo(`changeType: ${changeType}`);
    // 拷贝副本，为后面判断是否有空间进行修改提前准备
    let desktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
    desktopLayoutInfo.layoutInfo = JSON.parse(JSON.stringify(gridInfo));
    switch (changeType) {
      case DOCK_2_APP:
      case TYPE_NO_CHANGE: {
        // 先删除当前元素,腾出空间
        desktopLayoutInfo.layoutInfo.splice(index, 1);
        // dock区的app不参与workspace 空间计算，过滤掉，避免影响计算
        desktopLayoutInfo.layoutInfo = desktopLayoutInfo.layoutInfo.filter(itemTemp => itemTemp.container !==
        CommonConstants.CONTAINER_SMARTDOCK);
        // 判断修改后的位置是否可以存放当前的元素
        if (PageDesktopModel.getInstance().isPositionValid(desktopLayoutInfo, item, item.page ?? -1,
          item.column ?? 0, item.row ?? 0)) {
          gridInfo[index].page = item.page;
          gridInfo[index].column = item.column;
          gridInfo[index].row = item.row;
          gridInfo[index].area = item.area;
          gridInfo[index].container = item.container;
          log.showInfo('Succeeded in modifying the layout element.');
        } else {
          log.showError('modify op error, the workspace no enough room.');
        }
        break;
      }
      case APP_2_DOCK: {
        const dockAppSize = desktopLayoutInfo.layoutInfo.filter(itemTemp => itemTemp.container === CommonConstants
          .CONTAINER_SMARTDOCK).length;
        if (dockAppSize < this.DOCK_APP_MAX_NUMBER) {
          gridInfo[index].column = item.column;
          gridInfo[index].container = item.container;
          log.showInfo('Succeeded in modifying the layout element.');
        } else {
          log.showError(`modify op error, the dock no enough room ,the item is : ${item.bundleName}`);
        }
        break;
      }
      default:
        break;
    }
    return gridInfo;
  }

  /**
   * 判断桌面元素的修改类型，当前只支持修改app和文件夹，不支持修改卡片。
   *
   * @param existItem 当前元素
   * @param modifyItem 需要修改的元素
   * @returns 获取修改类型
   */
  private getModifyType(existItem: GridLayoutItemInfo, modifyItem: GridLayoutItemInfo): string {
    if (!this.isOnePlusOneItem(existItem) || !this.isOnePlusOneItem(modifyItem)) {
      log.showError(`The object cannot be modified. the : ${JSON.stringify(existItem)}`);
      return NOT_SUPPORT;
    }
    if (modifyItem.typeId === CommonConstants.TYPE_APP && existItem.typeId === CommonConstants.TYPE_APP) {
      if (existItem.bundleName === modifyItem.bundleName && existItem.abilityName === modifyItem.abilityName &&
        existItem.moduleName === modifyItem.moduleName) {
        if (existItem.container === modifyItem.container) {
          return TYPE_NO_CHANGE;
        } else if (existItem.container === CommonConstants.CONTAINER_DESKTOP && modifyItem.container ===
        CommonConstants.CONTAINER_SMARTDOCK) {
          return APP_2_DOCK;
        } else if (existItem.container === CommonConstants.CONTAINER_SMARTDOCK && modifyItem.container ===
        CommonConstants.CONTAINER_DESKTOP) {
          return DOCK_2_APP;
        } else {
          return NOT_SUPPORT;
        }
      }
    }
    // 小文件夹支持修改，大文件不支持修改
    if (existItem.typeId === CommonConstants.TYPE_FOLDER && modifyItem.typeId === CommonConstants.TYPE_FOLDER &&
      existItem.folderId === modifyItem.folderId) {
      return TYPE_NO_CHANGE;
    }
    return NOT_SUPPORT;
  }
}

