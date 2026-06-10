/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { DragGridItem, DragGridParam, DragGridLayout } from '../type/CommonTypes';

const EMPTY_LAYOUT: DragGridLayout = {
  gridParam: {
    paddingLeft: 0,
    paddingTop: 0,
    row: 0,
    column: 0,
    rowGap: 0,
    columnGap: 0,
    gridWidth: 0,
    gridHeight: 0,
  },
  layout: [],
  equal: (origin: DragGridItem, target: DragGridItem) => { return false },
};

/**
 * 拖拽布局数据共享类
 */
export class ShareDragLayout {
  private gridLayout: DragGridLayout;

  /**
   * 设置拖拽布局信息
   *
   * @param gridLayout 拖拽布局（宫格信息，布局数组）
   */
  public setGridLayout(gridLayout: DragGridLayout): void {
    this.gridLayout = gridLayout;
  }

  /**
   * 获取拖拽布局信息
   *
   * @returns 拖拽布局信息
   */
  public getGridLayout(): DragGridLayout {
    return this.gridLayout ?? EMPTY_LAYOUT;
  }

  /**
   * 获取宫格尺寸参数
   *
   * @returns 宫格尺寸参数
   */
  public getGridParam(): DragGridParam {
    return this.getGridLayout().gridParam;
  }

  /**
   * 获取布局数组
   *
   * @returns 布局数组
   */
  public getLayout(): DragGridItem[] {
    return this.getGridLayout().layout;
  }

  /**
   * 判断布局内元素是否相同
   *
   * @param origin 原元素
   * @param target 目标元素
   * @returns 是否相同
   */
  public equal(origin: DragGridItem, target: DragGridItem): boolean {
    return this.getGridLayout().equal(origin, target);
  }
}