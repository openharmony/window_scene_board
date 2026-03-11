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

import type CellAndSpan from './CellAndSpan';
import type ItemConfiguration from './ItemConfiguration';
import { RectItem } from '@ohos/basicutils';
import List from '@ohos.util.List';
import { DragGridItem } from '../compomentdrag/common/type/CommonTypes';

/**
 * 图标重排列运算类
 */
export default class ViewCluster {
  private static LEFT: number = 1; // 挤位方向：从右往左

  private static TOP: number = 1 << 1; // 挤位方向：上下往上

  private static RIGHT: number = 1 << 2; // 挤位方向：从左往右

  private static BOTTOM: number = 1 << 3; // 挤位方向：从上往下

  /**
   * 重排列过程中需要改变原生位置的View集合
   */
  private mViews: List<DragGridItem> = new List();

  /**
   * 重排列View及其对应的位置信息
   */
  private mConfig: ItemConfiguration;

  private mBoundingRect: RectItem = new RectItem(0, 0, 0, 0);

  private mRow: number; // 行数

  private mColumn: number; // 列数

  private mLeftEdge: number[];

  private mRightEdge: number[];

  private mTopEdge: number[];

  private mBottomEdge: number[];

  private mDirtyEdges: number;

  private mIsBoundingRectDirty: boolean;

  private whichEdge: number;

  /**
   * 构造函数
   *
   * @param views 需要重排列的View
   * @param config 当前重排列CellLayout上所有的view信息
   * @param countX cellLayout纵向网格数量
   * @param countY cellLayou横向网格数量
   */
  constructor(views: List<DragGridItem>, config: ItemConfiguration, countX: number, countY: number) {
    this.copyViews(views);
    this.mConfig = config;
    this.mRow = countX;
    this.mColumn = countY;
    this.mLeftEdge = new Array<number>(countX);
    this.mRightEdge = new Array<number>(countX);
    this.mTopEdge = new Array<number>(countY);
    this.mBottomEdge = new Array<number>(countY);
    this.resetEdges();
  }

  private copyViews(views: List<DragGridItem>): void {
    for (let view of views) {
      this.mViews.add(view);
    }
  }

  private resetEdges(): void {
    for (let i = 0; i < this.mColumn; i++) {
      this.mTopEdge[i] = -1;
      this.mBottomEdge[i] = -1;
    }
    for (let i = 0; i < this.mRow; i++) {
      this.mLeftEdge[i] = -1;
      this.mRightEdge[i] = -1;
    }
    this.mDirtyEdges = ViewCluster.LEFT | ViewCluster.TOP | ViewCluster.RIGHT | ViewCluster.BOTTOM;
    this.mIsBoundingRectDirty = true;
  }

  /**
   * 获取当前重排列View占用的矩形区域
   *
   * @return 当前重排列View占用的矩形区域
   */
  public getBoundingRect(): RectItem {
    if (this.mIsBoundingRectDirty) {
      this.mConfig.getBoundingRectForViews(this.mViews, this.mBoundingRect);
    }
    return this.mBoundingRect;
  }

  /**
   * 将当前cellLayout里的所有子View按照碰撞边界进行排序
   *
   * @param edge 碰撞边界，由碰撞方向决定
   */
  public sortConfigurationForEdgePush(edge: number): void {
    this.whichEdge = edge;
    this.mConfig.getSortedViews().sort((left: DragGridItem, right: DragGridItem) => {
      let leftSpan: CellAndSpan = this.mConfig.getCellAndSpan(left);
      let rightSpan: CellAndSpan = this.mConfig.getCellAndSpan(right);
      if (leftSpan != null && rightSpan != null) {
        switch (this.whichEdge) {
          case ViewCluster.LEFT:
            return (rightSpan.getCellX() + rightSpan.getSpanX()) -
              (leftSpan.getCellX() + leftSpan.getSpanX());
          case ViewCluster.RIGHT:
            return leftSpan.getCellX() - rightSpan.getCellX();
          case ViewCluster.TOP:
            return (rightSpan.getCellY() + rightSpan.getSpanY()) -
              (leftSpan.getCellY() + leftSpan.getSpanY());
          case ViewCluster.BOTTOM:
          default:
            return leftSpan.getCellY() - rightSpan.getCellY();
        }
      } else if (leftSpan == null && rightSpan != null) {
        return -1;
      } else if (leftSpan != null) {
        return 1;
      } else {
        return 0;
      }
    });
  }

  public isViewTouchingEdge(view: DragGridItem, whichEdge: number): boolean {
    let cs: CellAndSpan = this.mConfig.getCellAndSpan(view);
    if (cs == null) {
      return false;
    }
    if ((this.mDirtyEdges & whichEdge) === whichEdge) {
      this.computeEdge(whichEdge);
      this.mDirtyEdges &= ~whichEdge;
    }
    switch (whichEdge) {
      case ViewCluster.LEFT:
        for (let i = cs.getCellY(); i < cs.getCellY() + cs.getSpanY(); i++) {
          if (this.mLeftEdge[i] === cs.getCellX() + cs.getSpanX()) {
            return true;
          }
        }
        break;
      case ViewCluster.RIGHT:
        for (let i = cs.getCellY(); i < cs.getCellY() + cs.getSpanY(); i++) {
          if (this.mRightEdge[i] === cs.getCellX()) {
            return true;
          }
        }
        break;
      case ViewCluster.TOP:
        for (let i = cs.getCellX(); i < cs.getCellX() + cs.getSpanX(); i++) {
          if (this.mTopEdge[i] === cs.getCellY() + cs.getSpanY()) {
            return true;
          }
        }
        break;
      case ViewCluster.BOTTOM:
        for (let i = cs.getCellX(); i < cs.getCellX() + cs.getSpanX(); i++) {
          if (this.mBottomEdge[i] === cs.getCellY()) {
            return true;
          }
        }
        break;
      default:
        break;
    }
    return false;
  }

  private computeEdge(which: number): void {
    for (let view of this.mViews) {
      let cs: CellAndSpan = this.mConfig.getCellAndSpan(view);
      if (cs == null) {
        continue;
      }
      switch (which) {
        case ViewCluster.LEFT:
          let left = cs.getCellX();
          for (let j = cs.getCellY(); j < cs.getCellY() + cs.getSpanY(); j++) {
            if (left < this.mLeftEdge[j] || this.mLeftEdge[j] < 0) {
              this.mLeftEdge[j] = left;
            }
          }
          break;
        case ViewCluster.RIGHT:
          let right = cs.getCellX() + cs.getSpanX();
          for (let j = cs.getCellY(); j < cs.getCellY() + cs.getSpanY(); j++) {
            if (right > this.mRightEdge[j]) {
              this.mRightEdge[j] = right;
            }
          }
          break;
        case ViewCluster.TOP:
          let top = cs.getCellY();
          for (let j = cs.getCellX(); j < cs.getCellX() + cs.getSpanX(); j++) {
            if (top < this.mTopEdge[j] || this.mTopEdge[j] < 0) {
              this.mTopEdge[j] = top;
            }
          }
          break;
        case ViewCluster.BOTTOM:
          let bottom = cs.getCellY() + cs.getSpanY();
          for (let j = cs.getCellX(); j < cs.getCellX() + cs.getSpanX(); j++) {
            if (bottom > this.mBottomEdge[j]) {
              this.mBottomEdge[j] = bottom;
            }
          }
          break;
        default:
          break;
      }
    }
  }

  /**
   *
   * @param whichEdge 方向
   * @param typeId 拖拽图标类型（app、card、folder）
   */
  public shift(whichEdge: number): void {
    for (let view of this.mViews) {
      let cellSpan = this.mConfig.getCellAndSpan(view);

      if (cellSpan == null) {
        continue;
      }

      switch (whichEdge) {
        case ViewCluster.LEFT:
          cellSpan.setCellX(cellSpan.getCellX() - 1);
          break;
        case ViewCluster.RIGHT:
          cellSpan.setCellX(cellSpan.getCellX() + 1);
          break;
        case ViewCluster.TOP:
          cellSpan.setCellY(cellSpan.getCellY() - 1);
          break;
        case ViewCluster.BOTTOM:
          cellSpan.setCellY(cellSpan.getCellY() + 1);
          break;
        default:
          break;
      }
    }
    this.resetEdges();
  }

  /**
   * 添加需要重排列的View
   *
   * @param view 需要重排列的View
   */
  public addView(view: DragGridItem): void {
    this.mViews.add(view);
    this.resetEdges();
  }

  /**
   * 当前View是否在需要重排列的范围
   *
   * @param view 待检测的View
   * @return 是否在需要重排列的范围
   */
  public isContainView(view: DragGridItem): boolean {
    if (this.mViews == null || this.mViews.isEmpty()) {
      return false;
    }
    return this.mViews.has(view);
  }

  /**
   * 获取所有需要重排列的View
   *
   * @return 所有需要重排列的View
   */
  public getClusterViews(): List<DragGridItem> {
    return this.mViews;
  }
}


