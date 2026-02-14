/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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

import CellAndSpan from './CellAndSpan';
import type { RectItem } from '@ohos/basicutils';
import List from '@ohos.util.List';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DragGridItem } from '../compomentdrag/common/type/CommonTypes';

const TAG: string = 'ItemConfiguration';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 图标挤位过程中用于保存重排列方案的类
 *
 * @date 2023-2-18
 */
export default class ItemConfiguration extends CellAndSpan {
  private mSolutionGridLayout: Map<DragGridItem, CellAndSpan> = new Map(); // 保存重排列之后的图标位置信息
  private mOriginalGridLayout: Map<DragGridItem, CellAndSpan> = new Map(); // 保存重排列之前的图标位置信息
  private mSortedViews: List<DragGridItem> = new List<DragGridItem>(); // 对于当前页面的View按照碰撞优先级进行顺序排列
  private mIsSolutionValid: boolean = false; // 当前重排列方案是否生效
  private mIntersectingViews: List<DragGridItem>; // 当次重排列与被拖拽View最优落点产生冲突的view集合
  private mTranslateViews: Map<DragGridItem, number[][]> = new Map(); // 保存重排列之后的图标和位移信息

  public save(): void {
    // 保存当前的状态到mOriginalMap
    for (let [key, value] of this.mSolutionGridLayout.entries()) {
      if (this.mOriginalGridLayout.get(key) !== null) {
        this.mOriginalGridLayout.get(key).copyFrom(value);
      }
    }
  }

  /**
   * Get the item to be rearranged and its translation.
   *
   * @returns <item, translation>
   */
  public getIntersectingViewsTranslate(): Map<DragGridItem, number[][]> {
    if (this.mSolutionGridLayout && this.mOriginalGridLayout && this.mIntersectingViews) {
      log.showDebug('in getIntersectingViewsTranslate start..');
      this.mIntersectingViews.forEach(item => {
        let originItem: CellAndSpan = this.mOriginalGridLayout.get(item);
        let solutionItem: CellAndSpan = this.mSolutionGridLayout.get(item);
        if (originItem && solutionItem) {
          let translateArray: number[][] = [[originItem.getCellX(), originItem.getCellY()],
            [solutionItem.getCellX(), solutionItem.getCellY()]];
          log.showDebug('getIntersectingViewsTranslate');
          this.mTranslateViews.set(item, translateArray);
        }
      });
    }
    return this.mTranslateViews;
  }

  /**
   * 在mSortedViews中新增一个view，如appItem，card等
   *
   * @param layoutInfo view信息
   * @param cellSpan view坐标、尺寸信息
   */
  public add(layoutInfo: DragGridItem, cellSpan: CellAndSpan): void {
    this.mSolutionGridLayout.set(layoutInfo, cellSpan);

    this.mOriginalGridLayout.set(layoutInfo, new CellAndSpan(0, 0, 0, 0));
    this.mSortedViews.add(layoutInfo);
  }

  /**
   * 获取按照碰撞优先级排列的view集合
   *
   * @return view集合
   */
  public getSortedViews(): List<DragGridItem> {
    return this.mSortedViews;
  }

  /**
   * 设置冲突的ViewList
   *
   * @param intersectingViews 与拖拽落点冲突的View列表
   */
  public setIntersectingViews(intersectingViews: List<DragGridItem>): void {
    this.mIntersectingViews = intersectingViews;
    log.showDebug('setIntersectingViews mIntersectingViews');
  }

  /**
   * 设置冲突的ViewList
   *
   * @param intersectingViews 与拖拽落点冲突的View列表
   */
  public getIntersectingViews(): List<DragGridItem> {
    return this.mIntersectingViews;
  }

  public getIntersectingGridLayout(): Map<DragGridItem, CellAndSpan> {
    let intersectingGridLayout: Map<DragGridItem, CellAndSpan> = new Map();
    this.mIntersectingViews.forEach(view => {
      if (this.mSolutionGridLayout.get(view) !== null) {
        intersectingGridLayout.set(ObjectCopyUtil.deepClone(view), this.mSolutionGridLayout.get(view));
      }
    });
    return intersectingGridLayout;
  }
  /**
   * 获取当前view的位置信息
   *
   * @param view 待获取对象
   * @return 对应的位置信息
   */
  public getCellAndSpan(view: DragGridItem): CellAndSpan {
    return this.mSolutionGridLayout.get(view);
  }

  /**
   * 从mOriginalMap进行状态恢复
   */
  public restore(): void {
    for (let [key, value] of this.mOriginalGridLayout.entries()) {
      if (this.mSolutionGridLayout.get(key) !== null) {
        this.mSolutionGridLayout.get(key).copyFrom(value);
      }
    }
  }

  /**
   * 获取多个views的最小外边框
   *
   * @param views 涉及到的views
   * @param outRect 保存的边界信息
   */
  public getBoundingRectForViews(views: List<DragGridItem>, outRect: RectItem): void {
    let isFirst = true;

    for (let view of views) {
      let cellSpan = this.mSolutionGridLayout.get(view);
      if (cellSpan == null) {
        continue;
      }
      if (isFirst) {
        outRect.set(cellSpan.getCellX(),
        cellSpan.getCellY(),
          cellSpan.getCellX() + cellSpan.getSpanX(),
          cellSpan.getCellY() + cellSpan.getSpanY());
        isFirst = false;
      } else {
        outRect.union4(cellSpan.getCellX(), cellSpan.getCellY(),
          cellSpan.getCellX() + cellSpan.getSpanX(),
          cellSpan.getCellY() + cellSpan.getSpanY());
      }
    }
  }

  /**
   * 设置重排列方案是否有效
   *
   * @param isSolutionValid 重排列方案是否有效
   */
  public setIsSolutionValid(isSolutionValid: boolean): void {
    this.mIsSolutionValid = isSolutionValid;
  }

  /**
   * 设置重排列方案是否有效
   *
   * @param isSolutionValid 重排列方案是否有效
   */
  public getIsSolutionValid(): boolean {
    return this.mIsSolutionValid;
  }
}