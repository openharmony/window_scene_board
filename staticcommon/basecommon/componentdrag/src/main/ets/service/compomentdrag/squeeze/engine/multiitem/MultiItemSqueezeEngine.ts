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
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import { CellAndSpan, CellLayoutDragDelegate, ItemConfiguration } from '../../../../../TsIndex';
import { SqueezeResult } from '../../../common/type/SqueezeTypes';
import { DragGridItem, DragGridPosition } from '../../../common/type/CommonTypes';
import { Engine } from '../Engine';
import { DragUtils } from '../../../common/utils/DragUtils';

const TAG = 'MultiItemSqueezeEngine';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 多元素挤位引擎（拖拽元素和被挤位元素的面积中，只要有不为1x1的，调用该方法挤位）
 *
 * @since 2024/04/28
 */
export class MultiItemSqueezeEngine extends Engine {
  /**
   * 计算挤位结果
   *
   * @param x 被拖拽ITEM的x坐标
   * @param y 被拖拽ITEM的y坐标
   * @returns 挤位结果 DragGridItem:被挤位元素, SqueezeResult:被挤位元素对应宫格的起点和终点的行列值
   */
  public computeSqueezeResult(x: number, y: number, isZSqueeze: boolean): Map<DragGridItem, SqueezeResult> {
    this.moveItemTranslateList.clear();
    if (!this.updateSqueezeParam()) {
      return this.moveItemTranslateList;
    }
    let dragDelegate: CellLayoutDragDelegate = CellLayoutDragDelegate.getInstance(this.gridParam);
    let cellAndSpan: CellAndSpan = new CellAndSpan(x, y, this.dragItem.area[0], this.dragItem.area[1]);
    this.computeMultiItemSqueeze(dragDelegate, this.dragItem, cellAndSpan);
    return this.moveItemTranslateList;
  }

  private computeMultiItemSqueeze(dragDelegate: CellLayoutDragDelegate, dragItem: DragGridItem,
    cellAndSpan: CellAndSpan): void {
    log.showDebug('in computeMultiItemSqueeze');
    // 如果支持双屏挤位（布局数组中有特殊元素），需要把布局数组分为当前屏数组和附近屏数组
    let specialItemIndex: number = this.getSpecialItemIndex(this.layout);
    let supportDualSqueeze: boolean = specialItemIndex >= 0;
    let curPageItems: DragGridItem[] = this.layout;
    if (supportDualSqueeze) {
      curPageItems = this.layout.slice(0, specialItemIndex);
    }
    log.showDebug(`specialItemIndex:${specialItemIndex}`);

    // 当拖拽元素和被覆盖元素都为1*1，且支持双屏挤位，只有在空间不足情况下，才能调用多元素挤位算法
    const result: number[] = dragDelegate.findNearestArea(cellAndSpan);
    const nearestPosition: DragGridPosition = { row: result[1], column: result[0] };
    let coveredItem: DragGridItem = DragUtils.getCoveredItem(curPageItems, dragItem, nearestPosition);
    if (DragUtils.isGridItem1x1(coveredItem) && DragUtils.isGridItem1x1(dragItem)) {
      if (supportDualSqueeze &&
        !DragUtils.hasEnoughArea(curPageItems, dragItem, this.gridParam.row, this.gridParam.column)) {
        log.showInfo('not enough area, use multiItemSqueeze');
      } else {
        log.showInfo('cannot use multiItemSqueeze');
        return;
      }
    }

    // 计算所有元素挤位方向
    dragDelegate.getDirectionVectorForDrop(cellAndSpan, dragItem, curPageItems);
    // 获取所有元素的挤位重排列方案
    let reorderSolution: ItemConfiguration = dragDelegate.getReorderSolution(cellAndSpan, dragItem, curPageItems);

    // 折叠屏展开态 且 单屏挤位失败，尝试双屏挤位
    if (supportDualSqueeze && !dragDelegate.isReArrangeSolutionSuccess()) {
      let nearPageItems: DragGridItem[] = this.layout.slice(specialItemIndex + 1);
      reorderSolution =
        this.tryFoldExpandDualSqueeze(dragDelegate, dragItem, cellAndSpan, curPageItems, nearPageItems);
    }

    if (CheckEmptyUtils.isEmpty(reorderSolution)) {
      log.showError('reorderSolution is invalid');
      return;
    }
    if (dragDelegate.isReArrangeSolutionSuccess()) {
      log.showDebug('start to getSqueezedPosition');
      this.getSqueezedPosition(reorderSolution, dragDelegate.isNearReArrangeSolutionSuccess());
    }
  }

  private getSpecialItemIndex(gridItems: DragGridItem[]): number {
    for (let i = 0; i < gridItems.length; ++i) {
      if (!CheckEmptyUtils.isEmpty(gridItems[i]) && gridItems[i].row === undefined &&
        gridItems[i].column === undefined && gridItems[i].area === undefined) {
        return i;
      }
    }
    return -1;
  }

  // 折叠屏展开态双屏挤位
  private tryFoldExpandDualSqueeze(dragDelegate: CellLayoutDragDelegate, dragItemInfo: DragGridItem,
    cellAndSpan: CellAndSpan, curPageItems: DragGridItem[], nearPageItems: DragGridItem[]): ItemConfiguration {
    let solution = dragDelegate.getNearReorderSolution(cellAndSpan, dragItemInfo, curPageItems,
      nearPageItems, new ItemConfiguration(0, 0, 0, 0));
    return solution;
  }

  // 获取挤位前后的位置信息，并保存在map中
  private getSqueezedPosition(reorderSolution: ItemConfiguration, dualSqueezeSuccess: boolean): void {
    // 获取与被拖拽View最优落点产生冲突的view和位置信息
    let translateViews: Map<DragGridItem, number[][]> = reorderSolution.getIntersectingViewsTranslate();
    if (translateViews && translateViews.size > 0) {
      translateViews.forEach((value, key) => {
        if (CheckEmptyUtils.isEmpty(value) || CheckEmptyUtils.isEmpty(key)) {
          log.showWarn('item or item position is invalid');
          return;
        }
        let originPosition: DragGridPosition = { row: value[0][1], column: value[0][0] };
        // 折叠屏展开态跨屏挤位的场景，跨屏之后目标位置的列数会加上宫格的最大列数，表示是下一屏的位置
        let targetPosition: DragGridPosition = {
          row: value[1][1],
          column: dualSqueezeSuccess ? value[1][0] + this.gridParam.column : value[1][0],
        };
        let squeezeResult: SqueezeResult = { origin: originPosition, target: targetPosition};
        this.moveItemTranslateList.set(key, squeezeResult);
      });
    }
  }
}