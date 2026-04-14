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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GridLayoutItemInfo, LaunchLayoutCacheManager, StyleConstants } from '@ohos/launchercommon';
import {
  BusinessType,
  CommonConstants,
  DeviceState
} from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import { PageDesktopViewModel } from './PageDesktopViewModel';
import { DisplayCountViewModel } from '@ohos/launchercommon/src/main/ets/displaycount/DisplayCountViewModel';
import { HashMap } from '@kit.ArkTS';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'SwiperPageVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const INVALID_IDX = -1;

export class SwiperPageVM {
  private static instance: SwiperPageVM;
  private mPageItemsMap: Map<number, GridLayoutItemInfo[]> = new Map();
  private mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
  private mPageDesktopStyleConfig: PageDesktopGridStyleConfig = this.mPageDesktopViewModel.getPageDesktopStyleConfig();

  // 图标距离屏幕中心点最大距离
  private maxDistance: number = 0;

  // 图标距离屏幕中心点最小距离
  private minDistance: number = Number.MAX_VALUE;

  public setMaxDistance(distance: number): void{
    this.maxDistance = distance;
  }

  public setMinDistance(distance: number): void {
    this.minDistance = distance;
  }

  public getMaxDistance(): number {
    return this.maxDistance;
  }

  public getMinDistance(): number {
    return this.minDistance;
  }

  public static getInstance(): SwiperPageVM {
    if (SwiperPageVM.instance == null) {
      SwiperPageVM.instance = new SwiperPageVM();
    }
    return SwiperPageVM.instance;
  }

  public setPageItems(index: number, items: GridLayoutItemInfo[]): void {
    this.mPageItemsMap.set(index, items);
  }

  private getPageItems(index: number): GridLayoutItemInfo[] {
    return this.mPageItemsMap.get(index) || [];
  }

  public doSelect(startRow: number, startColumn: number, endRow: number, endColumn: number,
    pageIndex: number): void {
    if (startColumn > endColumn) {
      const tmpRow: number = startRow;
      const tmpColumn: number = startColumn;
      startRow = endRow;
      startColumn = endColumn;
      endRow = tmpRow;
      endColumn = tmpColumn;
    }
    if (startColumn === endColumn && startRow > endRow) {
      const temp: number = startRow;
      startRow = endRow;
      endRow = temp;
    }
    log.showInfo(`shift from start: ${startRow}, ${startColumn}, end: ${endRow}, ${endColumn} pageIndex ${pageIndex}`);
    const isBigScreen: boolean = DeviceHelper.isBigScreenMachine();
    const isPortrait: boolean = AppStorage.get('isPortrait') ?? true;
    const data: GridLayoutItemInfo[] = isBigScreen ?
    LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList(BusinessType.BUSINESS_BASIC_DESKTOP) :
    this.getPageItems(pageIndex);
    data?.forEach((item: GridLayoutItemInfo) => {
      if (item.row === undefined || item.column === undefined) {
        log.showWarn('item.row or item.column is undefined');
        return;
      }
      let itemRow: number = 0;
      let itemColumn: number = 0;
      if (isBigScreen) {
        if (item.page === undefined) {
          log.showWarn('item page is undefined');
          return;
        }
        if (isPortrait) {
          itemRow = item.row + item.page * this.mPageDesktopStyleConfig.mRows;
          itemColumn = item.column;
        } else {
          itemRow = item.row;
          itemColumn = item.column + item.page * this.mPageDesktopStyleConfig.mColumns;
        }
      } else {
        itemRow = item.row;
        itemColumn = item.column;
      }
      if (startColumn === endColumn) {
        item.isSelect = false;
        if (itemColumn === startColumn && itemRow >= startRow && itemRow <= endRow) {
          item.isSelect = true;
        }
      } else {
        if (itemColumn === startColumn) {
          item.isSelect = itemRow >= startRow;
        } else if (itemColumn === endColumn) {
          item.isSelect = itemRow <= endRow;
        } else {
          item.isSelect = (itemColumn >= startColumn && itemColumn <= endColumn);
        }
      }
      if (item.isSelect) {
        let key: string = this.mPageDesktopViewModel.getItemKeyByType(item);
        const selectedItemList: string[] = AppStorage.get('selectedItemList') || [];
        if (selectedItemList.indexOf(key) === INVALID_IDX && item.typeId !== CommonConstants.TYPE_CARD) {
          selectedItemList.push(key);
        }
        AppStorage.setOrCreate('selectedItemList', selectedItemList);
        item.isSelect = false;
      }
    });
  }

  /**
   * 获取屏幕的左右padding，折叠屏多屏之间左右间的偏移
   * @param indexInSwiperInput
   * @param folderStatus
   * @returns
   */
  public getPaddingSide(indexInSwiper: number, folderStatus: DeviceState): number[] {
    // 单屏设备直接返回
    if (folderStatus === DeviceState.DEFAULT_STATE) {
      return [0, 0];
    }
    let displayCount = DisplayCountViewModel.getInstance().getDisplayCount();
    let foldPaddingSide = this.mPageDesktopViewModel.getPageDesktopStyleConfig().mFoldPaddingSide as number;
    log.showWarn('foldPaddingSide: %{public}d', foldPaddingSide);
    // 3屏设备
    if (displayCount === StyleConstants.DEFAULT_3) {
      if (indexInSwiper % displayCount === 0) {
        return [-foldPaddingSide, foldPaddingSide];
      } else if (indexInSwiper % displayCount === 2) {
        return [foldPaddingSide, -foldPaddingSide];
      } else {
        return [0, 0];
      }
    }
    // 2屏设备
    if (indexInSwiper % StyleConstants.DEFAULT_2 === 0) {
      return [0, foldPaddingSide];
    } else {
      return [foldPaddingSide, 0];
    }
  }

  public printPageInfo(index: number, items: GridLayoutItemInfo[], isOuter: boolean): void {
    try {
      if (CheckEmptyUtils.isEmpty(items)) {
        log.showInfo(`appListInfoChange and isOuter:${isOuter},pageIndex:${index} is empty`);
        return;
      }
      let countMaps: HashMap<string, number> = new HashMap<string, number>();
      items.forEach((item) => {
        let countKey: string = `${item.typeId}`;
        countMaps.set(countKey, (countMaps.get(countKey) ?? 0) + 1);
      })
      let pageInfo: string = '';
      countMaps.forEach((value, key) => {
        pageInfo += `${key}:${value},`;
      })
      pageInfo = pageInfo.slice(0, -1);
      log.showWarn(`appListInfoChange and isOuter:${isOuter},pageIndex:${index},size:${items.length},pageInfo:${pageInfo}`);
    } catch (e) {
      log.error(`printPageInfo failed,code: ${e?.code}, msg:${e?.message}`);
    }
  }
}