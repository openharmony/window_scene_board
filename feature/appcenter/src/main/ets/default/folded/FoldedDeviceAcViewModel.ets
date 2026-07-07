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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AppCenterGridStyleConfig } from '../common/AppCenterGridStyleConfig';
import { AppGridItemInfo } from '@ohos/launchercommon/src/main/ets/bean/AppGridItemInfo';
import { SCBSessionRect } from '@ohos/windowscene';

const TAG = 'FoldedDeviceAcViewModel';
const logger: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'AC-' + TAG);
const INVALID_SCREEN_ID: number = -1;

export enum SCBFoldedState {
  UNKNOWN = 0,
  HALF_FOLDED_VIRTUAL_KEYBOARD,
  HALF_FOLDED_PHYSICAL_KEYBOARD,
  HALF_FOLDED,
  UNFOLDED_VERTICAL,
  UNFOLDED_HORIZONTAL
}

export class FoldStatusChangeEvent {
  public screenId: number = INVALID_SCREEN_ID
  public curState: number = 0;
  public tarState: number = 0;
  public foldCreaseRegion: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  public bSideWidth: number = 0;
  public bSideHeight: number = 0;
  public cSideWidth: number = 0;
  public cSideHeight: number = 0;
  public rotation: number = 0;
}

export enum FoldAcGridLayoutConstants {
  DEFAULT_HPR_APP_CENTER_GRID_ROWS = 5,
  DEFAULT_HPR_APP_CENTER_GRID_COLUMNS = 8,
  DEFAULT_HPR_APP_CENTER_HORIZONTAL_GRID_ROWS = 4,
  DEFAULT_HPR_APP_CENTER_HORIZONTAL_GRID_COLUMNS = 10
}

/**
 * 折叠机专用VM
 */
export class FoldedDeviceAcViewModel {
  public static readonly FOLD_STATE_CHANGE_EVT_NAME = 'hopper_state_change';
  public static readonly ROTATE_DOOR_VALUE = 300;
  public static readonly SQUEEZE_TRIGGER_Y_OFFSET_VALUE = 41.3;
  private static mInstance: Map<number, FoldedDeviceAcViewModel> = new Map();
  private static readonly ANIMATION_TIME_UNFOLDED_ASC: number[] = [418, 385, 334, 300];
  private static readonly ANIMATION_TIME_FOLDED_ASC: number[] = [300, 400, 405];
  private static readonly ANIMATION_TIME_UNFOLDED_OPACITY_ASC: number[] = [518, 495, 384, 197];
  private static readonly ANIMATION_TIME_FOLDED_OPACITY_ASC: number[] = [518, 495, 384];
  private static readonly ANIMATION_TIME_FOLDED_DESC: number[] = [310, 305, 300];
  private static readonly ANIMATION_TIME_UNFOLDED_DESC: number[] = [380, 350, 320, 300];
  /**
   * 是否折叠机设备
   */
  private mIsFoldedDevice: boolean = false;
  private mCurrentFoldState: SCBFoldedState;
  private mLastFoldState: SCBFoldedState;
  private mCurrentRotation: number = 0;
  private swiperItemSpace: number = 0;
  private mLastColumns: number = 8;
  private mAcGridPaddingTop: number = 0;
  private mAcDraggableAreaBottom: number = 0;
  private mAcBSideBottom: number = 0;
  private mUnfoldedAcBSideBottom: number = 0;
  private mAcCSideTop: number = 0;
  private squeezeTriggerYOffsetValue: number = 41.34;
  private screenId: number = 0;

  protected foldedVerticalAppItemPosX: number[] = [];
  protected foldedVerticalAppItemRtlPosX: number[] = [];
  protected foldedVerticalAppItemPosY: number[] = [];
  protected foldedVerticalAppItemEdgePos: Array<Array<number>> = [];
  protected foldedVerticalCircleMap: Map<number, number[]> = new Map();
  protected foldedHorizontalAppItemPosX: number[] = [];
  protected foldedHorizontalAppItemRtlPosX: number[] = [];
  protected foldedHorizontalAppItemPosY: number[] = [];
  protected foldedHorizontalAppItemEdgePos: Array<Array<number>> = [];
  protected foldedHorizontalCircleMap: Map<number, number[]> = new Map();
  protected foldedDefaultAppItemPosX: number[] = [];
  protected foldedDefaultAppItemRtlPosX: number[] = [];
  protected foldedDefaultAppItemPosY: number[] = [];
  protected foldedDefaultAppItemEdgePos: Array<Array<number>> = [];
  protected foldedDefaultCircleMap: Map<number, number[]> = new Map();
  protected foldedAppItemOpacity: number[] = [];

  private constructor() {
    this.mCurrentFoldState = SCBFoldedState.UNKNOWN;
    this.mLastFoldState = SCBFoldedState.UNKNOWN;
    logger.showInfo(`Construct Current state is ${this.mCurrentFoldState}`);
  }

  public static getInstance(screenId: number = 0): FoldedDeviceAcViewModel {
    if (!FoldedDeviceAcViewModel.mInstance.has(screenId)) {
      FoldedDeviceAcViewModel.mInstance.set(screenId, new FoldedDeviceAcViewModel());
      FoldedDeviceAcViewModel.mInstance.get(screenId)?.setScreenId(screenId);
    }
    return FoldedDeviceAcViewModel.mInstance.get(screenId)!;
  }

  public static deleteInstance(screenId: number = 0): void {
    if (FoldedDeviceAcViewModel.mInstance.has(screenId)) {
      logger.showInfo(`mInstance delete: ${screenId}`);
      FoldedDeviceAcViewModel.mInstance.delete(screenId);
    }
  }

  public getCurrentRotation(): number {
    return this.mCurrentRotation;
  }

  public setScreenId(screenId: number): void {
    this.screenId = screenId;
  }

  /**
   * 角度变化设定
   * @param rot
   */
  public setCurrentRotation(rot: number): void {
    logger.showInfo(`Rotation change from ${this.mCurrentRotation} to ${rot} screenId: ${this.screenId}`);
    this.mCurrentRotation = rot;
  }

  public getLastFoldState(): SCBFoldedState {
    return this.mLastFoldState;
  }

  /**
   * 获取折叠机状态
   * @returns
   */
  public getCurrentFoldState(): SCBFoldedState {
    return this.mCurrentFoldState;
  }

  /**
   * 设置折叠机状态
   * @param cs
   */
  public setFoldState(cs: number): void {
    if (!this.validateFoldStateValue(cs)) {
      logger.showWarn(`Invalid Fold State value ${cs}`);
      return;
    }
    FoldedDeviceAcViewModel.mInstance.forEach((value) => {
      value.mLastFoldState = this.mCurrentFoldState;
      value.mCurrentFoldState = this.convertStateEnum(cs);
    });
    logger.showInfo(`Current status is ${this.mCurrentFoldState} from ${this.mLastFoldState}-${cs}`);
  }

  private validateFoldStateValue(cs: number): boolean {
    return cs >= SCBFoldedState.UNKNOWN && cs <= SCBFoldedState.UNFOLDED_HORIZONTAL;
  }

  private convertStateEnum(cs: number): SCBFoldedState {
    switch (cs) {
      case 0:
        return SCBFoldedState.UNKNOWN;
      case 1:
        return SCBFoldedState.HALF_FOLDED_VIRTUAL_KEYBOARD;
      case 2:
        return SCBFoldedState.HALF_FOLDED_PHYSICAL_KEYBOARD;
      case 3:
        return SCBFoldedState.HALF_FOLDED;
      case 4:
        return SCBFoldedState.UNFOLDED_VERTICAL;
      case 5:
        return SCBFoldedState.UNFOLDED_HORIZONTAL;
    }
    return SCBFoldedState.UNKNOWN;
  }

  /**
   * 是否是折叠机-PC
   * @returns 是否是折叠机设备
   */
  public isFoldedDevice(): boolean {
    return this.mIsFoldedDevice;
  }

  /**
   * 设置-是否折叠机-PC
   * @param fd
   */
  public setIsFoldedDevice(fd: boolean): void {
    logger.showInfo(`Current device is folded: ${fd}`);
    FoldedDeviceAcViewModel.mInstance.forEach((value) => {
      value.mIsFoldedDevice = fd;
    });
  }

  /**
   * 是否是横屏展开态
   *
   * @returns
   */
  public isUnFoldedHorizontal(): boolean {
    return this.mCurrentFoldState === SCBFoldedState.UNFOLDED_HORIZONTAL;
  }

  public isUnFoldedVertical(): boolean {
    return this.mCurrentFoldState === SCBFoldedState.UNFOLDED_VERTICAL;
  }

  public isUnFolded(): boolean {
    return this.mCurrentFoldState === SCBFoldedState.UNFOLDED_VERTICAL ||
      this.mCurrentFoldState === SCBFoldedState.UNFOLDED_HORIZONTAL;
  }

  /**
   * 是否折叠态
   * @returns
   */
  public isHalfFolded(): boolean {
    return this.mCurrentFoldState === SCBFoldedState.HALF_FOLDED;
  }

  /**
   * 是否磁吸态
   * @returns
   */
  public isKeyboardOnCSide(): boolean {
    return this.mCurrentFoldState === SCBFoldedState.HALF_FOLDED_VIRTUAL_KEYBOARD ||
      this.mCurrentFoldState === SCBFoldedState.HALF_FOLDED_PHYSICAL_KEYBOARD;
  }

  /**
   * 是否是虚拟键盘态
   * @returns
   */
  public isHalfFoldedVirtualKeyboard(): boolean {
    return this.mCurrentFoldState === SCBFoldedState.HALF_FOLDED_VIRTUAL_KEYBOARD;
  }

  /**
   * 获取表格间距
   *
   * @returns
   */
  public getSwiperItemSpace(): number {
    return this.swiperItemSpace;
  }

  /**
   * 更新表格间距
   * @param space
   */
  public setSwiperItemSpace(space: number): void {
    logger.showInfo(`setSwiperItemSpace-${this.swiperItemSpace}-${space} screenId: ${this.screenId}`);
    const dif: number = space - this.swiperItemSpace;
    this.swiperItemSpace = space;
    this.mAcCSideTop += dif;
  }

  /**
   * 上一回合的列数
   * @param cols
   */
  public setLastColumns(cols: number): void {
    this.mLastColumns = cols;
  }

  /**
   * 获取上次的表格列数
   * @returns
   */
  public getLastColumns(): number {
    return this.mLastColumns;
  }

  /**
   * 获取表格上间距
   * @returns
   */
  public getAcGridPaddingTop(): number {
    return this.mAcGridPaddingTop;
  }

  /**
   * 设置表格上间距
   * @param top
   */
  public setAcGridPaddingTop(top: number): void {
    logger.showInfo(`setAcGridPaddingTop-${this.mAcGridPaddingTop}-${top} screenId: ${this.screenId}`);
    this.mAcGridPaddingTop = top;
  }

  /**
   *  获取可拖拽区域的底边位置-VP
   * @returns
   */
  public getAcDraggableAreaBottom(): number {
    return this.mAcDraggableAreaBottom;
  }

  public isNearBSideBottom(y: number): boolean {
    logger.showInfo(`isNearBSideBottom-${this.mUnfoldedAcBSideBottom}-${y} screenId: ${this.screenId}`);
    return y >= this.mUnfoldedAcBSideBottom - this.squeezeTriggerYOffsetValue;
  }

  /**
   * 重新计算拖拽区域的底边
   * @param gridStyleConfig
   */
  public recalculateAcDraggableAreaBottom(gridStyleConfig: AppCenterGridStyleConfig): void {
    if (this.mCurrentFoldState === SCBFoldedState.HALF_FOLDED_VIRTUAL_KEYBOARD ||
      this.mCurrentFoldState === SCBFoldedState.HALF_FOLDED_PHYSICAL_KEYBOARD) {
      this.mAcDraggableAreaBottom = gridStyleConfig.mAppCenterMarginTop + gridStyleConfig.mGridHeight;
    } else {
      this.updateDraggableAreaBottom(gridStyleConfig.mAppCenterMarginTop, gridStyleConfig.mGridHeight);
      this.mUnfoldedAcBSideBottom = gridStyleConfig.mAppCenterMarginTop + gridStyleConfig.mGridHeight;
      logger.showInfo(`mAcDraggableAreaBottom-${gridStyleConfig.mAppCenterMarginTop}-${gridStyleConfig.mGridHeight}-${this.swiperItemSpace}`);
    }
    if (this.mCurrentFoldState === SCBFoldedState.HALF_FOLDED) {
      this.mAcBSideBottom = gridStyleConfig.mAppCenterMarginTop + gridStyleConfig.mGridHeight;
      this.mAcCSideTop = gridStyleConfig.mAppCenterMarginTop + gridStyleConfig.mGridHeight + this.swiperItemSpace;
    }

    logger.showInfo(`recalculateAcDraggableAreaBottom-${this.mAcDraggableAreaBottom}-${this.mCurrentFoldState} screenId: ${this.screenId}`);
  }

  public updateDraggableAreaBottom(mrgTop: number, gh: number): void {
    this.mAcDraggableAreaBottom = mrgTop + gh * 2 + this.swiperItemSpace;
    logger.showInfo(`updateDraggableAreaBottom ${this.mAcDraggableAreaBottom} screenId: ${this.screenId}`);
  }

  public isRotating(oldH: number, newH: number): boolean {
    return Math.abs(oldH - newH) > FoldedDeviceAcViewModel.ROTATE_DOOR_VALUE;
  }

  public isDragInMiddleArea(y: number): boolean {
    return y > this.mAcBSideBottom && y < this.mAcCSideTop;
  }
  public getMiddleAreaHeight(): number {
    return this.mAcCSideTop - this.mAcBSideBottom;
  }

  public calculateRectMap(rows: number, cols: number): Map<number, number[]> {
    const map = new Map<number, number[]>();
    let circle = 0;
    let left = 0;
    let right = cols - 1;
    let top = 0;
    let bottom = rows - 1;

    while (left <= right && top <= bottom) {
      const circleElement: number[] = [];

      // 从左到右遍历顶部行
      for (let j = left; j <= right; j++) {
        const index = top * cols + j;
        circleElement.push(index);
      }

      // 从上到下遍历右侧列
      for (let i = top + 1; i < bottom; i++) {
        const index = i * cols + right;
        circleElement.push(index);
      }

      // 从右到左遍历底部行
      if (top < bottom) {
        for (let j = right; j >= left; j--) {
          const index = bottom * cols + j;
          circleElement.push(index);
        }
      }

      // 从下到上遍历左侧列
      if (left < right) {
        for (let i = bottom - 1; i > top; i--) {
          const index = i * cols + left;
          circleElement.push(index);
        }
      }

      map.set(circle, circleElement);
      circle++;
      left++;
      right--;
      top++;
      bottom--;
    }
    let resultMap: Map<number, number[]> = new Map();
    for (let i = 0, j = map.size - 1; j >= 0; i++, j--) {
      const arr: number[] | undefined = map.get(j);
      arr?.sort();
      resultMap.set(i, arr ?? []);
    }
    return resultMap;
  }

  public initFoldedAnimationData(): void {
    if (!FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      return;
    }

    let acRow: number = FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_HORIZONTAL_GRID_COLUMNS;
    let acColumn: number = FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_GRID_COLUMNS;

    let centerRow: number = (acRow - 1) / 2;
    if (centerRow === 0) {
      centerRow = 1;
    }
    let centerColumn: number = (acColumn - 1) / 2;
    if (centerColumn === 0) {
      centerColumn = 1;
    }
    logger.showInfo(`Folded init animation data - vertical - [acRow, acColumn]=[${acRow}, ${acColumn}], horizontal - [acRow, acColumn]=[${acColumn}, ${acRow}] screenId: ${this.screenId}`);

    //展开态
    let total = acRow * acColumn;
    for (let index = 0; index < total; index++) {
      this.foldedAppItemOpacity.push(0);

      let rawRow = index / acColumn;
      let rawColumn = index % acColumn;
      let transX = (rawColumn - centerColumn) / centerColumn * 100;
      let rtlTransX = (centerColumn - rawColumn) / centerColumn * 100;
      let transY = (Math.floor(rawRow) - centerRow) / centerRow * 100;

      //竖屏
      this.foldedVerticalAppItemEdgePos.push([transX, transY, rtlTransX]);
      this.foldedVerticalAppItemPosX.push(transX);
      this.foldedVerticalAppItemPosY.push(transY);
      this.foldedVerticalAppItemRtlPosX.push(rtlTransX);

      rawRow = index / acRow;
      rawColumn = index % acRow;
      transX = (rawColumn - centerRow) / centerRow * 100;
      rtlTransX = (centerRow - rawColumn) / centerRow * 100;
      transY = (Math.floor(rawRow) - centerColumn) / centerColumn * 100;

      //横屏
      this.foldedHorizontalAppItemEdgePos.push([transX, transY, rtlTransX]);
      this.foldedHorizontalAppItemPosX.push(transX);
      this.foldedHorizontalAppItemRtlPosX.push(rtlTransX);
      this.foldedHorizontalAppItemPosY.push(transY);

    }

    // 折叠、磁吸
    let halfTotal = total / 2;
    centerRow = (FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_GRID_ROWS - 1) / 2;
    if (centerRow === 0) {
      centerRow = 1;
    }
    for (let index = 0; index < halfTotal; index++) {
      let rawRow = index / acColumn;
      let rawColumn = index % acColumn;
      let transX = (rawColumn - centerColumn) / centerColumn * 100;
      let rtlTransX = (centerColumn - rawColumn) / centerColumn * 100;
      let transY = (Math.floor(rawRow) - centerRow) / centerRow * 100;

      this.foldedDefaultAppItemEdgePos.push([transX, transY, rtlTransX]);
      this.foldedDefaultAppItemPosX.push(transX);
      this.foldedDefaultAppItemPosY.push(transY);
      this.foldedDefaultAppItemRtlPosX.push(rtlTransX);
    }

    this.foldedVerticalCircleMap =
      this.calculateRectMap(FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_HORIZONTAL_GRID_COLUMNS,
        FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_GRID_COLUMNS);
    this.foldedHorizontalCircleMap =
      this.calculateRectMap(FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_GRID_COLUMNS,
        FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_HORIZONTAL_GRID_COLUMNS);
    this.foldedDefaultCircleMap = this.calculateRectMap(FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_GRID_ROWS,
      FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_GRID_COLUMNS);
  }

  public transformToPortrait(aii: AppGridItemInfo): AppGridItemInfo {
    if (!this.isFoldedDevice) {
      return aii;
    }

    if (this.isUnFoldedHorizontal()) {
      let r = aii.row;
      let c = aii.column;
      let idx = ((r ?? 0) * FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_HORIZONTAL_GRID_COLUMNS) + (c ?? 0);
      let newMappedRow = Math.floor(idx / FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_GRID_COLUMNS);
      let newMappedCol = idx % FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_GRID_COLUMNS;
      aii.row = newMappedRow;
      aii.column = newMappedCol;
      logger.showInfo(`transformToPortrait-${r}-${c}-${idx}-${newMappedRow}-${newMappedCol}-${aii.bundleName}`);
    }

    return aii;
  }

  public getFoldedVerticalAppItemPosX(): number[] {
    return this.foldedVerticalAppItemPosX;
  }

  public getFoldedVerticalAppItemRtlPosX(): number[] {
    return this.foldedVerticalAppItemRtlPosX;
  }

  public getFoldedVerticalAppItemPosY(): number[] {
    return this.foldedVerticalAppItemPosY;
  }

  public getFoldedVerticalAppItemEdgePos(): Array<Array<number>> {
    return this.foldedVerticalAppItemEdgePos;
  }

  public getFoldedVerticalCircleMap(): Map<number, number[]> {
    return this.foldedVerticalCircleMap;
  }

  public getFoldedHorizontalAppItemPosX(): number[] {
    return this.foldedHorizontalAppItemPosX;
  }

  public getFoldedHorizontalAppItemRtlPosX(): number[] {
    return this.foldedHorizontalAppItemRtlPosX;
  }


  public getFoldedHorizontalAppItemPosY(): number[] {
    return this.foldedHorizontalAppItemPosY;
  }

  public getFoldedHorizontalAppItemEdgePos(): Array<Array<number>> {
    return this.foldedHorizontalAppItemEdgePos;
  }

  public getFoldedHorizontalCircleMap(): Map<number, number[]> {
    return this.foldedHorizontalCircleMap;
  }

  public getFoldedDefaultAppItemPosX(): number[] {
    return this.foldedDefaultAppItemPosX;
  }

  public getFoldedDefaultAppItemRtlPosX(): number[] {
    return this.foldedDefaultAppItemRtlPosX;
  }

  public getFoldedDefaultAppItemPosY(): number[] {
    return this.foldedDefaultAppItemPosY;
  }

  public getFoldedDefaultAppItemEdgePos(): Array<Array<number>> {
    return this.foldedDefaultAppItemEdgePos;
  }

  public getFoldedDefaultCircleMap(): Map<number, number[]> {
    return this.foldedDefaultCircleMap;
  }

  public getFoldedAppItemOpacity(): number[] {
    return this.foldedAppItemOpacity;
  }

  public getFoldedTimeAsc(): Array<number> {
    return this.isUnFolded() ? FoldedDeviceAcViewModel.ANIMATION_TIME_UNFOLDED_ASC :
    FoldedDeviceAcViewModel.ANIMATION_TIME_FOLDED_ASC;
  }

  public getFoldedOpacityTimeAsc(): number[] {
    return FoldedDeviceAcViewModel.ANIMATION_TIME_FOLDED_OPACITY_ASC;
  }

  public getUnFoldedOpacityTimeAsc(): number[] {
    return FoldedDeviceAcViewModel.ANIMATION_TIME_UNFOLDED_OPACITY_ASC;
  }
}