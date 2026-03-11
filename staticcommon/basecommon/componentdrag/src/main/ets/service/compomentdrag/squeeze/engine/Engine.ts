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
import { ShareDataManager } from '../../common/share/ShareDataManager';
import { ShareDragInfo } from '../../common/share/ShareDragInfo';
import { ShareDragLayout } from '../../common/share/ShareDragLayout';
import { SqueezeResult } from '../../common/type/SqueezeTypes';
import { DragGridItem, DragGridLayout, DragGridParam } from '../../common/type/CommonTypes';

const TAG = 'Engine';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 引擎模板
 *
 * @since 2024/04/28
 */
export abstract class Engine {
  protected moveItemTranslateList: Map<DragGridItem, SqueezeResult> = new Map();
  protected shareDragInfo: ShareDragInfo = ShareDataManager.getInstance(ShareDragInfo, 'ShareDragInfo');
  protected shareDragLayout: ShareDragLayout = ShareDataManager.getInstance(ShareDragLayout, 'ShareDragLayout');
  protected gridLayout: DragGridLayout = this.shareDragLayout.getGridLayout();
  protected layout: DragGridItem[] = this.shareDragLayout.getLayout();
  protected gridParam: DragGridParam = this.shareDragLayout.getGridParam();
  protected dragItem: DragGridItem = this.shareDragInfo.getDragItem();

  /**
   * 计算挤位结果
   *
   * @param x 被拖拽item的x坐标
   * @param y 被拖拽item的y坐标
   * @param isZSqueeze 是否为Z字形挤位
   * @returns 挤位结果 DragGridItem:被挤位元素, SqueezeResult:被挤位元素对应宫格的起点和终点的行列值
   */
  public abstract computeSqueezeResult(x: number, y: number, isZSqueeze: boolean): Map<DragGridItem, SqueezeResult>;

  /**
   * 更新挤位参数
   *
   * @returns true:挤位参数有效，false:挤位参数无效
   */
  protected updateSqueezeParam(): boolean {
    this.gridLayout = this.shareDragLayout.getGridLayout();
    this.layout = this.shareDragLayout.getLayout();
    this.gridParam = this.shareDragLayout.getGridParam();
    this.dragItem = this.shareDragInfo.getDragItem();
    if (CheckEmptyUtils.isEmpty(this.layout) || CheckEmptyUtils.isEmpty(this.gridParam) ||
    CheckEmptyUtils.isEmpty(this.dragItem)) {
      log.showWarn('updateSqueezeParam, squeezeParam is invalid');
      return false;
    }
    return true;
  }
}