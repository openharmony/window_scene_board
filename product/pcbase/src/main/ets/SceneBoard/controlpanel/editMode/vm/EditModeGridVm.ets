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
import { ResUtils } from '@ohos/windowscene';
import {
  QuickToggleController
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/QuickToggleController';

import { EditModeVisitor, EditModeGridIface, EditModeDragIface } from '../interfaces/EditModeIface';
import { EditModeCommonStyle, EditModeStyleParam } from '../style/EditModeStyle';
import { EditModeDragHandler } from './EditModeDragHandler';
import { EditModeGridData } from '../viewData/EditModeGridViewData';
import { EditModeDragViewData } from '../viewData/EditModeDragViewData';

// 当备选库为空时，高度默认为-2，加上提示词的22vp padding，总共20vp的padding
const BOTTOM_PADDING = -2;

export class EditModeGridVm implements EditModeGridIface {
  private isSelectedGrid: boolean = false;
  private gridButton: string[] = [];
  private snapshots: string[] = [];
  private viewData: EditModeGridData = new EditModeGridData();
  private dragHandler?: EditModeDragHandler;
  private visitor?: EditModeVisitor;

  constructor(viewData: EditModeGridData, isSelectedGrid: boolean) {
    this.viewData = viewData;
    this.isSelectedGrid = isSelectedGrid;
  }

  public initDragHandler(viewData: EditModeDragViewData, itemWidth: number,
    itemHeight: number, itemColumNumber: number, context: UIContext): void {
    if (!this.dragHandler) {
      this.dragHandler = new EditModeDragHandler(viewData, itemWidth, itemHeight, itemColumNumber, context);
    }
  }

  public onSnapShot(): void {
    this.snapshots = [];
    this.snapshots.push(...this.gridButton);
  }

  public onGetSnapShot(): string[] {
    return this.snapshots;
  }

  public onBtnClick(slot: string): void {
    this.visitor?.onBtnClickCb(slot, this.isSelectedGrid);
  }

  public getDragHandler(): EditModeDragIface | undefined {
    return this.dragHandler;
  }

  public setIsEditMode(isEditMode: boolean): void {
    if (this.dragHandler) {
      this.dragHandler.setIsEditMode(isEditMode);
    }
  }

  public acceptModeVisitor(visitor: EditModeVisitor): void {
    this.visitor = visitor;
  }

  public onGetViewData(): EditModeGridData {
    return this.viewData;
  }

  public onUpdateToggleData(toggleData: string[]): boolean {
    const before = this.gridButton.join(',');
    const after = toggleData.join(',');
    if (before != after) {
      this.gridButton.splice(0, this.gridButton.length);
      this.gridButton.push(...toggleData);
      return true;
    }
    return false;
  }

  public linkToggleData(toggleData: string[]): void {
    this.gridButton = toggleData;
    if (this.dragHandler) {
      this.dragHandler.setToggleDragItems(toggleData);
    }
  }

  public onGetToggleData(isDeepCopy: boolean = true): string[] {
    if (!isDeepCopy) {
      return this.gridButton;
    }
    return new Array(...this.gridButton);
  }

  public updateGridLayout(param: EditModeStyleParam): void {
    this.viewData.updateGridLayout(param);
  }

  public updateGridVisibility(isVisible: boolean): void {
    if (this.viewData.isShowing !== isVisible) {
      this.viewData.isShowing = isVisible;
    }
  }

  public calculateGridHeight(isAddToggle?: boolean): number {
    let toggleLength = this.gridButton.length;
    if (isAddToggle !== undefined) {
      toggleLength = isAddToggle ? toggleLength + 1 : toggleLength - 1;
    }
    const toggleColumn = QuickToggleController.getInstance().getToggleColumn();
    const maxRowCount = Math.ceil(toggleLength / toggleColumn);
    const itemHeight = EditModeCommonStyle.getInstance().getItemHeight();
    let gridHeight = itemHeight * maxRowCount +
      (EditModeCommonStyle.getInstance().getGridParam(this.isSelectedGrid).rowsGap ?? 0) * (maxRowCount - 1);
    gridHeight = (gridHeight < 0) ? 0 : gridHeight;
    if (!this.isSelectedGrid && gridHeight <= 0) {
      return BOTTOM_PADDING;
    }
    let margin = EditModeCommonStyle.getInstance().getGridParam(this.isSelectedGrid).padding as Margin;
    if (margin) {
      gridHeight += ResUtils.getConvertNumber(margin.top) + ResUtils.getConvertNumber(margin.bottom);
      return gridHeight;
    }

    let length = EditModeCommonStyle.getInstance().getGridParam(this.isSelectedGrid).padding as Length;
    if (length) {
      gridHeight += ResUtils.getConvertNumber(length) * 2;
      return gridHeight;
    }
    return gridHeight;
  }
}