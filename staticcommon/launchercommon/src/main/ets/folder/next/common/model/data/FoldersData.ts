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

import {
  CommonConstants,
  DockItemInfo,
  FolderAppItemInfo,
  FolderModel,
  GridLayoutItemInfo
} from '../../../../../TsIndex';
import { FolderCommonConstants } from '../../FolderCommonConstant';
import { FolderCommonUtil } from '../../FolderCommonUtil';
import { FolderStyleManager } from '../../FolderStyleManager';
import { image } from '@kit.ImageKit';
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'FoldersData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DEFAULT_NUM: number = 9;

/**
 * 文件夹数据类
 */
export class FoldersData {
  private gridInfo: GridLayoutItemInfo;

  constructor(grid: GridLayoutItemInfo) {
    if (!grid) {
      grid = new GridLayoutItemInfo();
    }
    this.gridInfo = grid;
  }

  /**
   * 获取文件夹GridLayoutItemInfo
   *
   * @returns GridLayoutItemInfo
   */
  public getGridInfo(): GridLayoutItemInfo {
    return this.gridInfo;
  }

  /**
   * 获取文件夹内所有应用列表
   *
   * @returns 文件夹内的应用
   */
  public getItems(): GridLayoutItemInfo[] {
    let itemList: GridLayoutItemInfo[] = this.gridInfo.layoutInfo?.flat() ?? [];
    return FolderCommonUtil.getFilterAddIconList(itemList);
  }

  /**
   * 获取文件夹名字
   *
   * @returns 文件夹名字
   */
  public getFolderName(): string {
    return this.gridInfo.folderName ?? '';
  }

  /**
   * 获取文件夹Id
   * @returns 文件夹Id
   */
  public getFolderId(): string {
    return this.gridInfo.folderId ?? '';
  }

  /**
   * 获取最后一个元素
   *
   * @returns lastItem
   */
  public getLastItem(): GridLayoutItemInfo {
    let items: GridLayoutItemInfo[] = this.getItems();
    return items[items.length - 1];
  }

  /**
   * 是否是空元素
   *
   * @returns ture空的item
   */
  public isEmptyGrid(): boolean {
    return this.gridInfo.folderId === FolderCommonUtil.getEmptyFolderData().folderId;
  }

  /**
   * 获取文件夹显示的item
   *
   * @param itemList 文件夹的应用列表
   * @returns 显示的应用列表
   */
  public getContractedFolderShowItems(itemList?: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    let items: GridLayoutItemInfo[] = itemList ?? this.getItems();
    let isSmall: boolean = FolderCommonUtil.isLayout1X1(this.gridInfo.area ?? []);
    let maxShowNum: number = this.getFolderMaxShowNum(this.gridInfo.area ?? [], isSmall);
    maxShowNum = Math.min(items.length, maxShowNum);
    let result: GridLayoutItemInfo[] = items.slice(0, maxShowNum);
    return result;
  }

  /**
   * 改变文件夹大小到1x2或2x1时，数量不足需要补充空图标
   */
  public getShowItems4Resize(): GridLayoutItemInfo[] {
    if (ArrayUtils.equalsArr(this.gridInfo.area, [1, 2]) || ArrayUtils.equalsArr(this.gridInfo.area, [2, 1])) {
      return [];
    }
    let items: GridLayoutItemInfo[] = this.getItems();
    let count: number = items.length;
    let showCount1x2: number = this.getFolderMaxShowNum([1, 2], false);
    let maxCount1x2: number = showCount1x2;
    if (count > showCount1x2 && count < maxCount1x2) {
      let addCount: number = maxCount1x2 - count;
      log.showWarn(`add ${addCount} items for resize`);
      for (let i = 0; i < addCount; i++) {
        let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        itemInfo.isEmpty = true;
        itemInfo.keyName = `empty_show_${i}`;
        items.push(itemInfo);
      }
      return items;
    } else {
      return [];
    }
  }

  private getFolderMaxShowNum(area: number[], isSmall: boolean): number {
    let countInRow: number = FolderStyleManager.getInstance().getCountPerRowInFolder(area);
    let countInCol: number = FolderStyleManager.getInstance().getCountPerColumnInFolder(area);
    if (isSmall) {
      return countInRow * countInCol;
    } else {
      return countInRow * countInCol - 1;
    }
  }

  /**
   * 获取文件夹某页的item图标
   *
   * @param pageIndex 页数
   * @returns 某页的图标列表
   */
  public getItemsByPageIndex(pageIndex: number): GridLayoutItemInfo[] {
    try {
      return FolderCommonUtil.getFilterAddIconList(this.gridInfo.layoutInfo?.[pageIndex] ?? []);
    } catch {
      log.showError('get the item for folder %{public}s in page %{public}d error', this.gridInfo.folderId, pageIndex);
    }
    return [];
  }

  /**
   * 获取文件夹最后一页截图的item列表,文件夹只有一页时，最后一页返回未空。
   *
   * @param itemList 应用列表
   * @returns 文件夹最后一页元素列表
   */
  public getLastPageItems(itemList?: GridLayoutItemInfo[]): FolderImageItemInfo[] {
    let items: GridLayoutItemInfo[] = itemList ?? this.getItems();
    let folderAppLength: number = items.length;
    let maxPerPage: number = FolderModel.getInstance().getOpenFolderMaxPerPage() ?? DEFAULT_NUM;
    let result: FolderImageItemInfo[] = [];
    if (folderAppLength <= maxPerPage) {
      result = [];
    } else if (folderAppLength === FolderCommonUtil.getMaxAppCount()) {
      result = items.slice(folderAppLength - maxPerPage + 1) as FolderImageItemInfo[];
    } else {
      let sliceNum: number = (folderAppLength % maxPerPage === 0) ? maxPerPage : folderAppLength % maxPerPage;
      result = items.slice(folderAppLength - sliceNum) as FolderImageItemInfo[];
    }
    return result;
  }

  /**
   * 获取文件夹页数
   *
   * @returns
   */
  public getFolderPages(): number {
    return this.gridInfo.layoutInfo?.length ?? 0;
  }

  /**
   * 获取首页截图的元素
   *
   * @param itemList 应用列表
   * @returns 文件夹首页的元素列表
   */
  public getMainPageItems(itemList?: GridLayoutItemInfo[]): FolderImageItemInfo[] {
    let items: GridLayoutItemInfo[] = itemList ?? this.getItems();
    return this.getContractedFolderShowItems(items) as FolderImageItemInfo[];
  }

  /**
   * 当前folderData是否是小文件夹数据
   *
   * @returns true小文件夹
   */
  public isSmall(): boolean {
    return FolderCommonUtil.isLayout1X1(this.gridInfo.area ?? []);
  }

  /**
   * 是否在dock区
   *
   * @returns true在dock
   */
  public isInDock(): boolean {
    return this.gridInfo.container === CommonConstants.CONTAINER_DOCK;
  }

  /**
   * 获取调整文件夹大小时，需要做动效的隐藏图标
   * @returns
   */
  public getResizeHideItems(): FolderAppItemInfo[] {
    let items: GridLayoutItemInfo[] = this.getItems();
    let count4x2: number = this.getFolderMaxShowNum([4, 2], false);
    let maxCount4x2: number = count4x2;
    let currentCount: number = FolderCommonUtil.getContractedFolderMaxShowIconNum(this.gridInfo.area ?? []);
    if (currentCount < items?.length && currentCount < maxCount4x2) {
      let result: FolderAppItemInfo[] = items.slice(currentCount, Math.min(maxCount4x2, items.length)) as
      Object[] as FolderAppItemInfo[];
      let count2x2: number = this.getFolderMaxShowNum([2, 2], false);
      let maxCount2x2: number = count2x2;
      if (items?.length > count2x2 && items?.length < maxCount2x2) {
        // 补充到2x2的堆叠空图标
        let count: number = maxCount2x2 - items?.length;
        for (let i = 0; i < count; i++) {
          let appItemInfo: FolderAppItemInfo = new FolderAppItemInfo();
          appItemInfo.isEmpty = true;
          appItemInfo.keyName = `empty_hide_${i}`;
          result.push(appItemInfo);
        }
        return result;
      }
      if (items?.length > count4x2 && items?.length < maxCount4x2) {
        // 补充到4x2的堆叠空图标
        let count: number = maxCount4x2 - items?.length;
        for (let i = 0; i < count; i++) {
          let appItemInfo: FolderAppItemInfo = new FolderAppItemInfo();
          appItemInfo.isEmpty = true;
          appItemInfo.keyName = `empty_hide_${i}`;
          result.push(appItemInfo);
        }
      }
      return result;
    }
    return [];
  }
}

/**
 * 用于文件夹截图中的图标对象
 */
export class FolderImageItemInfo extends GridLayoutItemInfo {
  public icon?: string | image.PixelMap;
  public snapShortCutBackgroundImage?: string | image.PixelMap;
  public isGrayIcon: boolean = false;
}

/**
 * 拖拽到文件夹的应用数据
 */
export class DragAppToFolderData {
  public folderId: string = '';
  public appKeyName: string = '';
  public appPositionX: number = 0;
  public appPositionY: number = 0;
}

/**
 * 拖拽覆盖的元素信息
 */
export class DragCoveredItem {
  public isCreateSmallFolder: boolean = false;

  public coveredAppPositionX: number = 0;

  public coveredAppPositionY: number = 0;

  public dragItemInfo?: GridLayoutItemInfo | DockItemInfo;

  public coveredItemInfo?: GridLayoutItemInfo | DockItemInfo;

  public folderId: string = '';

  public folderType: number = 0;

  public dragItemInfoX: number = 0;

  public dragItemInfoY: number = 0;

  public coveredItemUpperLeftPosition: number[] = [];
}