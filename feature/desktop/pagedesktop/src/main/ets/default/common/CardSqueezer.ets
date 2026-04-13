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
  LogDomain,
  LogHelper,
  RectItem,
  SingleBase,
  SingleContext,
  singleManager
} from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import {
  CellAndSpan,
  CellLayoutDragDelegate,
  DragGridPosition,
  GridOccupyStatus,
  GridOccupyStatusEnum
} from '@ohos/componentdrag';
import {
  CommonConstants,
  GridLayoutConfig,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LaunchLayoutCacheManager,
} from '@ohos/launchercommon';
import { BusinessType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { MoveItem, PageDesktopDragHandler } from './PageDesktopDragHandler';

const TAG = 'CardSqueezer';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DEFAULT_PAGE = 0;

export class CardSqueezer extends SingleBase {
  public static singleName: string = 'CardSqueezer';
  private squeezeEnable: boolean = DeviceHelper.isPC();
  private isBigScreen: boolean = DeviceHelper.isBigScreenMachine();
  private squeezeSuccess: boolean = false;
  private dragItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  // 原始布局
  private originLayout: Map<string, GridLayoutItemInfo> = new Map();
  // 缓存布局
  private cacheLayout: Map<string, GridLayoutItemInfo> = new Map();
  // 上一轮拖拽中已挤位元素
  private movedItems: Set<string> = new Set();
  private isPortrait: boolean = false;
  private isExpandStatus: boolean = false;
  private mGridConfig: GridLayoutConfig = new GridLayoutConfig();

  constructor(ctx?: SingleContext) {
    super(ctx);
  }

  /**
   * 处理拖拽状态变更
   */
  public onDragItemChange(): void {
    if (!this.squeezeEnable) {
      return;
    }
    let dragItem: GridLayoutItemInfo = GridLayoutUtil.getSingleDragItemInfo();
    let key: string = this.getItemKey(dragItem);
    // 拖拽卡片结束时获取已挤位元素
    if (!GridLayoutUtil.isValidLayoutItem(dragItem) &&
      (this.dragItem.typeId === CommonConstants.TYPE_CARD ||
        this.dragItem.typeId === CommonConstants.TYPE_REGION_FOLDER)) {
      this.getMovedItems();
      return;
    }
    // 拖拽非卡片时重置相关信息
    if (dragItem.typeId !== CommonConstants.TYPE_CARD && dragItem.typeId !== CommonConstants.TYPE_REGION_FOLDER) {
      log.showInfo('clear info when drag non-card: %{public}s', key);
      this.dragItem = new GridLayoutItemInfo();
      this.movedItems.clear();
      return;
    }
    // 首次拖拽某卡片获取相关信息
    if (!GridLayoutUtil.isValidLayoutItem(this.dragItem)) {
      log.showInfo('get info when drag card: %{public}s', key);
      this.dragItem = dragItem;
      this.getLayouts();
      return;
    }
    // 切换卡片时重新获取相关信息
    if (!GridLayoutUtil.checkGridItemEqual(this.dragItem, dragItem)) {
      log.showInfo('get info when drag different card: %{public}s', key);
      this.dragItem = dragItem;
      this.movedItems.clear();
      this.getLayouts();
      return;
    }
    // 拖拽相同卡片时仍需要更新布局信息，避免拖拽间隙中添加元素或者手动触发排序等
    this.updateLayouts();
  }

  public setBigScreenStatus(isPortrait: boolean, isExpandStatus: boolean, config: GridLayoutConfig): void {
    if (this.isExpandStatus !== isExpandStatus) {
      this.originLayout.clear();
      this.cacheLayout.clear();
      this.movedItems.clear();
    }
    this.mGridConfig = config;
    this.isExpandStatus = isExpandStatus;
    this.isPortrait = isPortrait;
  }

  /**
   * 获取挤位方案
   *
   * @param dragDelegate 拖拽代理类
   * @param position 当前落点
   * @returns 需挤位元素
   */
  public getSolution(dragDelegate: CellLayoutDragDelegate, position: DragGridPosition): MoveItem[] {
    if (!this.dragItem || !this.dragItem.area){
      return [];
    }
    this.squeezeSuccess = true;
    let dragRect: RectItem = new RectItem(position.column, position.row,
      position.column + this.dragItem.area[0], position.row + this.dragItem.area[1]);
    // 计算原始布局中当前落点的已有元素
    let crossItems: GridLayoutItemInfo[] = this.getCrossItems(dragRect);
    if (!this.squeezeSuccess) {
      // 已有元素包含卡片时无法挤位
      return [];
    }
    // 计算当前落点已有元素的挤位信息
    let crossMoveItems: MoveItem[] = this.getCrossMoveItems(dragRect, crossItems, dragDelegate);
    if (!this.squeezeSuccess) {
      // 覆盖元素无法找到有效位置时无法挤位
      return [];
    }
    // 计算实际所需挤位元素的挤位信息
    let moveItems: MoveItem[] = this.getRealMoveItems(crossMoveItems);
    return moveItems;
  }

  /**
   * 获取挤位有效性
   */
  public getSqueezeSuccess(): boolean {
    return this.squeezeSuccess;
  }

  /**
   * 获取上轮拖拽中已挤位元素
   */
  private getMovedItems(): void {
    this.movedItems.clear();
    this.originLayout.forEach((origin: GridLayoutItemInfo, key: string) => {
      let cache: GridLayoutItemInfo | undefined = this.cacheLayout.get(key);
      if (!cache) {
        return;
      }
      let cachePosition: DragGridPosition = { row: cache.row ?? 0, column: cache.column ?? 0, page: cache.page };
      if (this.isBigScreen && this.isExpandStatus) {
        cachePosition = GridLayoutUtil.changeDragGridPositionToExpand(cachePosition, this.isPortrait,
          this.mGridConfig.row, this.mGridConfig.column);
      }
      // 通过比对原始布局和缓存布局中元素行列信息获取已挤位元素
      if (origin.row !== cachePosition.row || origin.column !== cachePosition.column) {
        this.movedItems.add(key);
        log.showInfo('item: %{public}s moved from [%{public}d, %{public}d] to [%{public}d, %{public}d]',
          key, origin.row, origin.column, cache.row, cache.column);
      }
    });
  }

  /**
   * 获取布局信息，按先行后列排序
   */
  private getLayouts(): void {
    this.originLayout.clear();
    this.cacheLayout.clear();
    let layoutInfo = this.isBigScreen ?
    LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList(BusinessType.BUSINESS_BASIC_DESKTOP) :
    LaunchLayoutCacheManager.getInstance().selectGridLayoutItemsByPage(DEFAULT_PAGE);
    layoutInfo.sort((a: GridLayoutItemInfo, b: GridLayoutItemInfo) => {
      return a.row === b.row ? (a.column ?? 0) - (b.column ?? 0) : (a.row ?? 0) - (b.row ?? 0);
    });
    let key: string = this.getItemKey(this.dragItem);
    layoutInfo.forEach((item: GridLayoutItemInfo) => {
      let itemKey: string = this.getItemKey(item);
      if (key !== itemKey) {
        // 原始布局需要深拷贝，不能直接使用缓存数据
        let newItem: GridLayoutItemInfo = ObjectCopyUtil.deepClone(item);
        if (this.isBigScreen && this.isExpandStatus) {
          const position: DragGridPosition =
            GridLayoutUtil.changeDragGridPositionToExpand({ row: newItem.row, column: newItem.column,
              page: newItem.page }, this.isPortrait, this.mGridConfig.row, this.mGridConfig.column);
          newItem.row = position.row;
          newItem.column = position.column;
        }
        this.originLayout.set(itemKey, newItem);
        this.cacheLayout.set(itemKey, item);
      }
    });
  }

  /**
   * 更新布局信息
   */
  private updateLayouts(): void {
    let key: string = this.getItemKey(this.dragItem);
    let layoutInfo = this.isBigScreen ?
    LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList(BusinessType.BUSINESS_BASIC_DESKTOP) :
    LaunchLayoutCacheManager.getInstance().selectGridLayoutItemsByPage(DEFAULT_PAGE);
    // 遍历缓存时同步删除共同元素，剩余元素即为删除元素
    let deleteItems: Set<string> = new Set(this.originLayout.keys());
    let addItems: Map<string, GridLayoutItemInfo> = new Map();
    let reInit: boolean = false;
    for (let i = 0; i < layoutInfo.length; i++) {
      let item: GridLayoutItemInfo = layoutInfo[i];
      let itemKey: string = this.getItemKey(item);
      if (itemKey === key) {
        continue;
      }
      if (deleteItems.has(itemKey)) {
        // 删除共同元素
        deleteItems.delete(itemKey);
        let originItem: GridLayoutItemInfo | undefined = this.originLayout.get(itemKey);
        let position: DragGridPosition = { row: (item.row ?? 0), column: (item.column ?? 0), page: item.page };
        if (this.isBigScreen && this.isExpandStatus) {
          position = GridLayoutUtil.changeDragGridPositionToExpand(position, this.isPortrait,
            this.mGridConfig.row, this.mGridConfig.column);
        }
        // 存在上轮挤位元素以外的位置出现变化的元素时，重新初始化布局信息，如两次卡片拖拽中手动触发排序
        if (originItem && (originItem.row !== position.row || originItem.column !== position.column) &&
          !this.movedItems.has(itemKey)) {
          reInit = true;
          break;
        }
      } else {
        // 记录新插入元素
        addItems.set(itemKey, item);
      }
    }

    if (reInit) {
      this.getLayouts();
      this.movedItems.clear();
      log.showInfo('update info when drag same card: %{public}s', key);
    } else {
      addItems.forEach((item: GridLayoutItemInfo, key: string) => {
        let newItem: GridLayoutItemInfo = ObjectCopyUtil.deepClone(item);
        if (this.isBigScreen && this.isExpandStatus) {
          const position: DragGridPosition =
            GridLayoutUtil.changeDragGridPositionToExpand({ row: newItem.row, column: newItem.column,
              page: newItem.page }, this.isPortrait, this.mGridConfig.row, this.mGridConfig.column);
          newItem.row = position.row;
          newItem.column = position.column;
        }
        this.originLayout.set(key, newItem);
        this.cacheLayout.set(key, item);
        log.showInfo('add info when drag same card: %{public}s', key);
      });
      deleteItems.forEach((key: string) => {
        this.originLayout.delete(key);
        this.cacheLayout.delete(key);
        this.movedItems.delete(key);
        log.showInfo('delete info when drag same card: %{public}s', key);
      });
    }
  }

  /**
   * 获取目标落点已有元素
   */
  private getCrossItems(dragRect: RectItem): GridLayoutItemInfo[] {
    let crossItems: GridLayoutItemInfo[] = [];
    this.originLayout.forEach((item: GridLayoutItemInfo) => {
      if (this.isBigScreen &&
        item.page !== PageDesktopDragHandler.getInstance(this.singleContext).getCurrentPageIndex()) {
        return;
      }
      if (!item.area) {
        return;
      }
      let itemRect = new RectItem(item.column ?? 0, item.row ?? 0, (item.column ?? 0) + item.area[0],
        (item.row ?? 0) + item.area[1]);
      if (RectItem.intersects(dragRect, itemRect)) {
        if (item.typeId === CommonConstants.TYPE_CARD || item.typeId === CommonConstants.TYPE_REGION_FOLDER) {
          log.showWarn('desktop drag cross items contain card or region folder: %{public}s', this.getItemKey(item));
          this.squeezeSuccess = false;
        }
        crossItems.push(item);
      }
    });
    return crossItems;
  }

  /**
   * 获取覆盖元素的挤位信息
   */
  private getCrossMoveItems(dragRect: RectItem, crossItems: GridLayoutItemInfo[],
    dragDelegate: CellLayoutDragDelegate): MoveItem[] {
    let crossMoveItems: MoveItem[] = [];
    // 标记布局占用状态
    let layout: GridLayoutItemInfo[] = Array.from(this.originLayout.values());
    if (this.isBigScreen && !this.isExpandStatus) {
      layout = layout.filter(item =>
        item.page === PageDesktopDragHandler.getInstance(this.singleContext).getCurrentPageIndex());
    }
    let gridOccupyStatus: GridOccupyStatus = dragDelegate.getGridOccupyStatus(layout);
    gridOccupyStatus.markGridForRect(dragRect, GridOccupyStatusEnum.OCCUPIED);

    // 计算覆盖元素挤位信息
    for (let i = 0; i < crossItems.length; i++) {
      let item: GridLayoutItemInfo = crossItems[i];
      let itemKey: string = this.getItemKey(item);
      if (!item || item.column === undefined || item.row === undefined || !item.area) {
        return [];
      }
      let cellAndSpan: CellAndSpan = new CellAndSpan(item.column, item.row, item.area[0], item.area[1]);
      let res: number[] = dragDelegate.findNearestAreaTwo(cellAndSpan, [0, 0], gridOccupyStatus, null, null);
      // 任一元素无法落位视为挤位失败
      if (res[0] < 0 || res[1] < 0) {
        log.showWarn('unable to find solution for item: %{public}s', itemKey);
        this.squeezeSuccess = false;
        return [];
      }
      cellAndSpan.setCellX(res[0]);
      cellAndSpan.setCellY(res[1]);
      gridOccupyStatus.markGridForCellAndSpan(cellAndSpan, GridOccupyStatusEnum.OCCUPIED);
      let origin: DragGridPosition = { row: item.row, column: item.column };
      let target: DragGridPosition = { row: res[1], column: res[0] };
      if (this.isBigScreen && this.isExpandStatus) {
        origin = GridLayoutUtil.changeDragGridPositionToFold(origin, this.isPortrait,
          this.mGridConfig.row, this.mGridConfig.column);
        target = GridLayoutUtil.changeDragGridPositionToFold(target, this.isPortrait,
          this.mGridConfig.row, this.mGridConfig.column);
      }
      crossMoveItems.push(this.getMoveItem(item, origin, target));
    }
    return crossMoveItems;
  }

  /**
   * 获取实际所需挤位元素的挤位信息，包括本轮挤位中落点处已有元素，上轮挤位中待归位元素等
   */
  private getRealMoveItems(moveItems: MoveItem[]): MoveItem[] {
    let realMoveItems: MoveItem[] = [];
    let deleteIndex: number[] = [];

    let moveItemsMap: Map<string, number> = new Map();
    moveItems.forEach((item: MoveItem, index: number) => moveItemsMap.set(this.getItemKey(item), index));

    // 处理上一轮挤位元素
    this.movedItems.forEach((key: string) => {
      // 获取上一轮挤位元素的当前位置
      let originItem: GridLayoutItemInfo | undefined = this.cacheLayout.get(key);
      if (!originItem || originItem.row === undefined || originItem.column === undefined) {
        return;
      }
      let origin: DragGridPosition = { row: originItem.row, column: originItem.column, page: originItem.page };
      let target: DragGridPosition = { row: CommonConstants.INVALID_VALUE, column: CommonConstants.INVALID_VALUE };

      if (!moveItemsMap.has(key)) {
        // 上一轮挤位元素本轮无需挤位时，挤位终点为原始布局中位置
        let targetItem: GridLayoutItemInfo | undefined = this.originLayout.get(key);
        if (!targetItem || targetItem.row === undefined || targetItem.column === undefined) {
          return;
        }
        target = { row: targetItem.row, column: targetItem.column };
        if (this.isBigScreen && this.isExpandStatus) {
          target = GridLayoutUtil.changeDragGridPositionToFold({ row: target.row, column: target.column, page: 0 },
            this.isPortrait, this.mGridConfig.row, this.mGridConfig.column);
        }
      } else {
        // 上一轮挤位元素本轮仍需挤位时，挤位终点为本轮终点
        let index: number | undefined = moveItemsMap.get(key);
        if (index === undefined) {
          return;
        }
        let moveItem: MoveItem = moveItems[index];
        target = { row: moveItem.row, column: moveItem.column, page: moveItem.page };
        deleteIndex.push(index);
      }

      realMoveItems.push(this.getMoveItem(originItem, origin, target));
      log.showDebug('desktop drag item: %{public}s move to [%{public}d, %{public}d]', key, target.row, target.column);
    });

    // 倒序删除上轮挤位和本轮挤位的重复元素
    deleteIndex.sort((a, b) => b - a).forEach((index: number) => moveItems.splice(index, 1));
    // 处理本轮拖拽中新增挤位元素
    moveItems.forEach((item: MoveItem) => {
      let key: string = this.getItemKey(item);
      realMoveItems.push(item);
      log.showDebug('desktop drag item: %{public}s move to [%{public}d, %{public}d]', key, item.row, item.column);
    });
    return realMoveItems;
  }

  /**
   * 更新moveItem 信息
   * @param item 对于super fold传入的position都是单屏信息
   * @param origin
   * @param target
   * @returns
   */
  private getMoveItem(item: GridLayoutItemInfo, origin: DragGridPosition, target: DragGridPosition): MoveItem {
    let moveItem: MoveItem = MoveItem.fromGridItem(item);
    let translatePosition: number[][] = [];
    // 获取原始位置
    translatePosition[0] = GridLayoutUtil.getGridItemPosition(origin.row, origin.column);
    moveItem.row = target.row;
    moveItem.column = target.column;
    // 获取目标位置
    translatePosition[1] = GridLayoutUtil.getGridItemPosition(target.row, target.column);
    if (this.isBigScreen && this.isExpandStatus) {
      translatePosition[0] = GridLayoutUtil.getBigScreenGridItemPosition(origin.row, origin.column,
        origin.page, this.isPortrait);
      translatePosition[1] = GridLayoutUtil.getBigScreenGridItemPosition(target.row, target.column,
        target.page, this.isPortrait);
      moveItem.page = target.page ?? 0;
    }
    moveItem.position = translatePosition;
    return moveItem;
  }

  private getItemKey(item: GridLayoutItemInfo | MoveItem): string {
    return GridLayoutUtil.generateUniqueKey(item as GridLayoutItemInfo);
  }

  static getInstance(ctx?: SingleContext): CardSqueezer {
    return singleManager.get<CardSqueezer>(CardSqueezer, ctx);
  }
}