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

import { LogDomain, Logger } from '@ohos/basicutils';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { AppItemInfo } from '../bean/AppItemInfo'
import { LaunchLayoutCacheManager } from '../cache/layout/LaunchLayoutCacheManager';

const TAG = 'GridPositionFindUtil';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 用于宫格找位工具类
 */
export class GridPositionFindUtil {
  /**
   * 直接插入空位，新机空白页后找位使用
   *
   * @param maxRow 最大行
   * @param maxCol 最大列
   * @param itemLocation 存在位置信息
   */
  public static findBlankPositionWithoutVerify(maxRow: number, maxCol: number, itemLocation: ItemLocation): void {
    if (maxRow <= 0 || maxCol <= 0) {
      return;
    }
    // 更新当前位置
    itemLocation.findRow = itemLocation.curRow;
    itemLocation.findCol = itemLocation.curCol;
    itemLocation.findPage = itemLocation.curPage;

    // 更新到下一个位置
    GridPositionFindUtil.hasNextItemLocationInOnePage(maxRow, maxCol, itemLocation);
  }

  private static hasNextItemLocationInOnePage(maxRow: number, maxCol: number, itemLocation: ItemLocation): boolean {
    const nextCol: number = itemLocation.curCol + 1;
    itemLocation.curCol = (nextCol) % maxCol;
    itemLocation.curRow = (itemLocation.curRow) + Math.floor(nextCol / maxCol);
    let isNeedFindNextPage: boolean = itemLocation.curRow >= maxRow;
    if (isNeedFindNextPage) {
      itemLocation.curPage = itemLocation.curPage + 1;
      itemLocation.curRow = 0;
      itemLocation.curCol = 0;
    }
    return !isNeedFindNextPage;
  }

  /**
   * 当前页找空位
   *
   * @param maxRow 最大行
   * @param maxCol 最大列
   * @param maxPage 最大页
   * @param item 找位元素item
   * @param itemLocation 保存找位的位置信息
   * @returns true找位成功，否则找位失败
   */
  public static findBlankPositionFromOnePage(maxRow: number, maxCol: number, maxPage: number, item: GridLayoutItemInfo,
    itemLocation: ItemLocation): boolean {
    if (maxRow <= 0 || maxCol <= 0) {
      return false;
    }
    do {
      if (LaunchLayoutCacheManager.getInstance().isPositionValid(item, itemLocation.curPage % maxPage,
        itemLocation.curCol, itemLocation.curRow)) {
        itemLocation.findCol = itemLocation.curCol;
        itemLocation.findRow = itemLocation.curRow;
        itemLocation.findPage = itemLocation.curPage;
        log.showInfo(TAG, `findBlankPosition page:${itemLocation.curPage % maxPage} x:${itemLocation.findCol},
          y:${itemLocation.findRow}, keyName: ${item?.bundleName} result: true`);
        GridPositionFindUtil.hasNextItemLocationInOnePage(maxRow, maxCol, itemLocation);
        return true;
      }
    } while (GridPositionFindUtil.hasNextItemLocationInOnePage(maxRow, maxCol, itemLocation));
    log.showInfo(TAG,
      `findBlankPosition false and change next page:${itemLocation.curPage}, keyName: ${item.bundleName}`);
    return false;
  }

  /**
   * 创建一个找位的起始位置
   *
   * @param startPage 开始页
   * @param sRow 行
   * @param sCol 列
   * @returns 起始位置的对象
   */
  public static getStartFindItemLocation(startPage: number, sRow: number, sCol: number): ItemLocation {
    const itemLocation: ItemLocation = new ItemLocation();
    itemLocation.curPage = startPage;
    itemLocation.curRow = sRow;
    itemLocation.curCol = sCol;
    itemLocation.findPage = startPage;
    itemLocation.findRow = 0;
    itemLocation.findCol = 0;
    return itemLocation;
  }
}

/**
 * 用于记录找位过程中位置信息
 */
export class ItemLocation {
  public curPage: number = 0;
  public curRow: number = 0;
  public curCol: number = 0;
  public findPage: number = 0;
  public findRow: number = 0;
  public findCol: number = 0;
}