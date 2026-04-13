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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import type GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { CommonConstants } from '../../constants/CommonConstants';
import { SettingsModel } from '../../model/SettingsModel';

const TAG = 'Instruction';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

enum Position {
  TOP = 'top',
  BOTTOM = 'bottom',
  BEFORE = 'before',
  AFTER = 'after'
}
/**
 * 差分处理基类
 */
export abstract class Instruction {
  readonly DOCK_APP_MAX_NUMBER: number = 4;
  readonly POSITION = Position;
  protected rows: number;
  protected columns: number;

  protected constructor(rows: number, columns: number) {
    this.columns = columns;
    this.rows = rows;
  }

  /**
   * 具体的差分处理逻辑抽象方法，由各具体的差分指令子类来实现
   *
   * @param gridLayoutInfo 初始桌面布局集合
   * @param gridLayout 增量部署的单个桌面元素
   * @returns 进行差分处理以后的桌面布局集合
   */
  protected abstract realize(layoutInfo: GridLayoutItemInfo[], itemLayout: GridLayoutItemInfo): GridLayoutItemInfo[];

  /**
   * 在给定的布局的基础上进行差分元素的增强处理
   *
   * @param layoutInfo 初始桌面布局集合
   * @param item 增量部署的单个桌面元素
   * @returns 进行差分处理以后的桌面布局集合
   */
  public execute(layoutInfo: GridLayoutItemInfo[], item: GridLayoutItemInfo): GridLayoutItemInfo[] {
    // 判断输入的有效性
    if (layoutInfo === null || item === null) {
      log.showError('The layoutInfo is null or the item is null, please check!');
      return layoutInfo;
    }
    return this.realize(layoutInfo, item);
  }

  /**
   * 判断需要操作的元素是否在已有布局中存在，不支持卡片
   *
   * @param existItem  已有布局中的元素
   * @param modifyItem 待操作的布局元素
   * @returns 当待处理的元素与布局中已有元素相同时，返回 true, 否则返回 false
   */
  protected isItemExist(existItem: GridLayoutItemInfo, modifyItem: GridLayoutItemInfo): boolean {
    if (modifyItem.typeId === CommonConstants.TYPE_APP && existItem.typeId === CommonConstants.TYPE_APP) {
      if (existItem.bundleName === modifyItem.bundleName && existItem.abilityName === modifyItem.abilityName &&
        existItem.moduleName === modifyItem.moduleName) {
        return true;
      }
    }
    if (modifyItem.typeId === CommonConstants.TYPE_FOLDER && existItem.folderId === modifyItem.folderId) {
      return true;
    }
    return false;
  }

  /**
   * 判断元素的行和列是否都有效
   *
   * @param item 待检查的桌面元素
   * @returns 当行和列取值都合法时，返回true，否则返回false
   */
  protected checkItem(item: GridLayoutItemInfo): boolean {
    if (typeof item.column === 'undefined' || item.column?.valueOf() > this.columns || item.column?.valueOf() < 0) {
      log.showError(`item.column is invalid ${item.column}`);
      return false;
    }
    if (typeof item.row === 'undefined' || item.row?.valueOf() > this.rows || item.row?.valueOf() < 0) {
      log.showError(`item.row is invalid ${item.row}`);
      return false;
    }
    return true;
  }

  /**
   * 桌面元素是否是1X1的大小
   *
   * @param item  桌面元素基本信息
   * @returns true表示是1X1大小，false表示不是1X1大小
   */
  protected isOnePlusOneItem(item: GridLayoutItemInfo): boolean {
    let validItem = false;
    if (item != null) {
      if (item.area !== undefined && item.area.length > 1) {
        validItem = (item.area[0]) === 1 && (item.area[1] === 1);
      }
    }
    return validItem;
  }


  /**
   * 校验dock区的应用是否有效
   *
   * @param item 待校验的dock区应用对象
   * @returns 如果给定的应用为null ，或者没有column属性，或者属性不在有效范围内，返回false，如何合法返回true
   */
  protected checkDockApp(item: GridLayoutItemInfo): boolean {
    let isValid = true;
    if (item === null) {
      return false;
    }
    if (typeof item.column === 'undefined' || item.column < 0 || item.column >= this.DOCK_APP_MAX_NUMBER) {
      isValid = false;
    }
    return isValid;
  }
}


