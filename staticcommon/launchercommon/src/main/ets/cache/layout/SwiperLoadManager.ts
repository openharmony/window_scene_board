/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { HashMap } from '@kit.ArkTS';
import { SwiperLoadData } from '@ohos/swiperdata';

const TAG = 'SwiperLoadManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const SINGLE_DISPLAY_POCKET_FOLD_DEVICE_FLAG = '4';

export class SwiperLoadManager {
  private static managerInstance: SwiperLoadManager = new SwiperLoadManager();
  private static outerManagerInstance: SwiperLoadManager;
  private loadData: SwiperLoadData = SwiperLoadData.getInstance();
  private gridOperation: GridOperationCallBack = {
    refreshPageDesktop: () => {},
    clearSwiperPages: () => {}
  };
  private swiperIndicatorOp: SwiperIndicatorCallBack = { updatePages: (pages: number[]) => {} };
  private turnToPageIndex: number = -1;
  public swiperPageMap: HashMap<number, SwiperPageLoadCallBack> = new HashMap();

  /**
   * 获取turnToPageIndex,gridswiper中刷新pagedesktop时调用
   */
  public getPageTurn(): number {
    return this.turnToPageIndex;
  }

  public clearPageTurn(): void {
    this.turnToPageIndex = -1;
  }

  public loadIndicator(): void {
    this.swiperIndicatorOp.updatePages(this.loadData.getPages());
  }

  public setGridOperation(gridOperation: GridOperationCallBack): void {
    this.gridOperation = gridOperation;
  }

  public setSwiperIndicator(swiperIndicatorOp: SwiperIndicatorCallBack): void {
    this.swiperIndicatorOp = swiperIndicatorOp;
  }

  private isOptionsEmpty(): boolean {
    if (CheckEmptyUtils.isEmpty(this.gridOperation) || CheckEmptyUtils.isEmpty(this.swiperIndicatorOp)) {
      return true;
    }
    return false;
  }

  /**
   * 添加页面到页中,并且等待页面添加完成后进行翻页动效
   *
   * @param addedPageIndex 添加到该页之后
   * @param pageNumber 添加的页数：展开态： 2， 折叠态： 1
   * @param isSwiperToNewPage 添加后是否滑动到新页
   */
  public hardCodeAddPageToMiddle(addedPageIndex: number, pageNumber: number, isSwiperToNewPage: boolean = true): void {
    if (!this.isOptionsEmpty()) {
      let addedPage: number = this.loadData.addBlankPageMiddle(addedPageIndex, pageNumber);
      if (isSwiperToNewPage) {
        this.turnToPageIndex = addedPageIndex + 1;
        if (pageNumber === 2) {
          this.turnToPageIndex = this.turnToPageIndex - (this.turnToPageIndex % 2);
        }
      }
      // 更新每一页的swiperPage的index
      this.loadData.getPages().forEach((swiperKey: number, index: number) => {
        this.swiperPageMap.get(swiperKey)?.changeSwiperPageIndex(index);
      });

      log.showInfo(`hardCodeAddPageToMiddle :${JSON.stringify(this.loadData.getPages())} addedPage ${this.turnToPageIndex}`);
    }
  }

  /**
   * 删除中间的某一页
   *
   * @param deletedPageIndex
   * @param deletedPageCount
   */
  public hardCodeDeleteBlankPageMiddle(deletedPageIndex: number, deletedPageCount: number): void {
    if (!this.isOptionsEmpty()) {
      this.loadData.deleteBlankPageMiddle(deletedPageIndex, deletedPageCount);
      // 更新被删除的页之后的所有页的索引
      log.showInfo(`hardCodeDeleteBlankPageMiddle :${JSON.stringify(this.loadData.getPages())}`);
      this.loadData.getPages().forEach((swiperKey: number, index: number) => {
        this.swiperPageMap.get(swiperKey)?.changeSwiperPageIndex(index);
      });
    }
  }

  /**
   * 拖拽页面落位
   *
   * @param startDragPageIndex
   * @param endDragPageIndex
   * @param pageNumber
   */
  public hardCodeDragPage(startDragPageIndex: number, endDragPageIndex: number, pageNumber: number): void {
    if (!this.isOptionsEmpty()) {
      this.loadData.dragPage(startDragPageIndex, endDragPageIndex, pageNumber);
      // 更新所有页的索引
      log.showInfo(`hardCodeDragPage :${JSON.stringify(this.loadData.getPages())}`);
      this.loadData.getPages().forEach((swiperKey: number, index: number) => {
        this.swiperPageMap.get(swiperKey)?.changeSwiperPageIndex(index);
      });
    }
  }

  /**
   * 对于新增页之后的swiperPage已经更改了对应的页码，直接创建新页和刷新旧页
   */
  public hardCodeRefreshPageDesktop(): void {
    if (this.isOptionsEmpty()) {
      return;
    }

    this.gridOperation?.refreshPageDesktop();
    this.loadData.getPages().forEach((swiperKey: number, index: number) => {
      this.swiperPageMap.get(swiperKey)?.reloadDataSource?.(index);
    });
    this.swiperIndicatorOp?.updatePages(this.loadData.getPages());
  }

  /**
   * 清楚桌面页数缓存
   */
  public clearSwiperPages(): void {
    this.gridOperation?.clearSwiperPages();
  }

  public constructor(isOuter: boolean = false) {
    this.loadData = SwiperLoadData.getInstance();
  }

  public static getInstance(isOuter: boolean = false): SwiperLoadManager {
    if (isOuter) {
      if (SwiperLoadManager.outerManagerInstance == null) {
        SwiperLoadManager.outerManagerInstance = new SwiperLoadManager(true);
      }
      return SwiperLoadManager.outerManagerInstance;
    }
    return SwiperLoadManager.managerInstance;
  }
}

/**
 * grid组件回调
 */
export interface GridOperationCallBack {
  /**
   * @param swiperPages 更新的页面
   *
   * @returns 新增页的swiperKey集合
   */
  refreshPageDesktop: () => void;
  clearSwiperPages: () => void;
}

/**
 * swiperPage组件回调
 */
export interface SwiperPageLoadCallBack {
  changeSwiperPageIndex: (index: number) => void;
  reloadDataSource?: (index: number) => void;
}

/**
 * SwiperIndicator组件回调
 */
export interface SwiperIndicatorCallBack {
  updatePages: (pages: number[]) => void;
}