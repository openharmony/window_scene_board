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

import { LogDomain, LogHelper, UIContextHelper, RectInfo } from '@ohos/basicutils';
import { AppItemInfo, LayoutViewModel } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { DragEventManager, DragItemPosition } from '@ohos/componentdrag';
import { promptAction } from '@kit.ArkUI';
import { GlobalContext, ResourceManager } from '@ohos/frameworkwrapper';
import { CommonAcDragMgr, TranslateItem } from '../controller/CommonAcDragMgr';
import { FoldedDeviceAcViewModel } from './FoldedDeviceAcViewModel';
import AppGridLayoutUtil from '../common/util/AppGridLayoutUtil';
import AppGridLayoutCacheManager from '../common/cache/AppGridLayoutCacheManager';
import { SCBScreenProperty } from '@ohos/windowscene';
import { SceneSessionUIContextManager } from '@ohos/componenthelper';

const TAG = 'FoldedAcDragMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class FoldedAcDragMgr extends CommonAcDragMgr {
  private isDragCrossScreen: boolean = false;
  private isDraggingCrossScreen: boolean = false;
  private isCrossFullPage: boolean = false;

  public setDragItemInfo(item: AppItemInfo): void {
    this.dragItemInfo = item;
    let r = AppGridLayoutCacheManager.getInstance().findApp(item.bundleName, item.page ?? 0, item.appIndex);
    if (!r) {
      log.showInfo(`setDragItemInfo-can not find app in cache on page-${item.page}`);
      this.resetDragItemInfoInNeed();
    }
    if (this.mDragPageIndex !== this.dragItemInfo.page && this.dragItemInfo.page !== undefined) {
      log.showInfo(`setDragItemInfo-${this.mDragPageIndex}-${item.page}-${this.dragItemInfo.page}`);
      this.setDragPageIndex(this.dragItemInfo.page);
    }
  }

  protected getToastHeight(): number | undefined {
    return undefined;
  }

  protected initAppGridRect(screenId: number = 0): void {
    log.showInfo(`initAppGridRect screenId: ${screenId}`);
    if (screenId === 0) {
      this.appGridRect = new RectInfo();
      this.appGridRect.left = this.mGridStyleConfig.mAppCenterMarginLeft;
      this.appGridRect.top = this.mGridStyleConfig.mAppCenterMarginTop;
      this.appGridRect.right = this.mGridStyleConfig.mAppCenterMarginLeft + this.mGridStyleConfig.mGridWidth;
      this.appGridRect.bottom = FoldedDeviceAcViewModel.getInstance(screenId).getAcDraggableAreaBottom();
      log.showInfo(`initAppGridRect2-${this.appGridRect.bottom}`);
    } else {
      this.extAppGridRect = new RectInfo();
      this.extAppGridRect.left = this.mExtGridStyleConfig.mAppCenterMarginLeft;
      this.extAppGridRect.top = this.mExtGridStyleConfig.mAppCenterMarginTop;
      this.extAppGridRect.right = this.mExtGridStyleConfig.mAppCenterMarginLeft + this.mExtGridStyleConfig.mGridWidth;
      this.extAppGridRect.bottom = FoldedDeviceAcViewModel.getInstance(screenId).getAcDraggableAreaBottom();
      log.showInfo(`initAppGridRect2-${this.extAppGridRect.bottom}`);
    }
  }

  protected isInAppCenterWorkBench(x: number, y: number, screenId: number = 0): boolean {
    let wholeValid = super.isInAppCenterWorkBench(x, y, screenId);
    if (!FoldedDeviceAcViewModel.getInstance().isHalfFolded()) {
      return wholeValid;
    } else {
      return wholeValid && !FoldedDeviceAcViewModel.getInstance(screenId).isDragInMiddleArea(y);
    }
  }

  protected resetDragStartPositionInNeed(x: number, y: number, page?: number): void {
    if (FoldedDeviceAcViewModel.getInstance().isUnFoldedHorizontal()) {
      return;
    } else {
      super.resetDragStartPositionInNeed(x, y, page);
    }
  }

  protected resetDragItemDataOnDragFinal(): void {
    if (!this.dragItemInfo) {
      return;
    }

    if (this.dragItemInfo.page !== this.mStartPosition?.page) {
      log.showInfo(`resetDragItemDataOnDragFinal-${this.dragItemInfo.page}-${this.mStartPosition?.page}`);
      this.dragItemInfo.page = this.mStartPosition?.page;
    }
  }
  protected resetDragItemInfoInNeed(): void {
    if (!this.dragItemInfo) {
      return;
    }
    log.showInfo(`resetDragItemInfoInNeed drag item-old: ${this.dragItemInfo?.row}` +
      `-${this.dragItemInfo?.column}-${this.dragItemInfo?.page}-${this.dragItemInfo?.bundleName}`);
    let app = AppGridLayoutCacheManager.getInstance()
      .lookForApp(this.appGridList, this.dragItemInfo?.bundleName, this.dragItemInfo?.appIndex);
    if (!app) {
      log.showInfo(`Can't find app in drag cache list for ${this.dragItemInfo?.bundleName}`);
      return;
    }
    let isDifferent = app.column !== this.dragItemInfo?.column || app.row !== this.dragItemInfo?.row ||
      app.page !== this.dragItemInfo?.page;
    if (isDifferent) {
      this.dragItemInfo.row = app.row;
      this.dragItemInfo.column = app.column;
      this.dragItemInfo.page = app.page;
      log.showInfo(`resetDragItemInfoInNeed drag item-new: ${app.row}-${app.column}-${app.page}-${app.bundleName}`);
    }
  }

  public resetLastMovPosIfDragLeave(): void {
  }

  /**
   * 起拖
   * @param event
   * @param item
   */
  public onDragStart(event: DragEvent, item?: AppItemInfo, screenProp?: SCBScreenProperty): void {
    this.isDragCrossScreen = false;
    this.isDraggingCrossScreen = false;
    super.onDragStart(event, item, screenProp);
  }

  public setDragCrossScreen(crossScreen: boolean = true): void {
    this.isDragCrossScreen = crossScreen;
  }

  public getDragCrossScreen(): boolean {
    return this.isDragCrossScreen;
  }

  public setDraggingCrossScreen(draggingCrossScreen: boolean = true): void {
    this.isDraggingCrossScreen = draggingCrossScreen;
  }

  public setCrossFullPage(crossFullPage: boolean = false): void {
    this.isCrossFullPage = crossFullPage;
  }

  /**
   * 更新应用中心拖拽相关参数，拓展屏拖拽适配
   */
  public updateAppCenterDragData(screenId?: number, isRefresh?: boolean, width?: number, height?: number): void {
    this.mAppCenterRst = LayoutViewModel.getInstance().calculateAppCenter(screenId, isRefresh, width, height);

    log.showInfo(`updateAppCenterDragData-${this.mTranslateItemList?.length}-${this.mLastTranslateItemList?.length}` +
      `-${this.isDragging}-${this.dropOnPage}`);
    if (!this.isDragging) {
      this.mTranslateItemList = [];
      this.mLastTranslateItemList = [];
    }

    if (this.isDragging && this.dragItemInfo && this.mStartPosition && !this.dropOnPage) {
      log.showInfo(`updateAppCenterDragData then reset SQZ drag item-${this.dragItemInfo.row}-${this.dragItemInfo.column}` +
        `-${this.dragItemInfo.page}-${this.mStartPosition.row}-${this.mStartPosition.column}` +
        `-${this.mStartPosition.page}`);
      this.dragItemInfo.column = this.mStartPosition.column;
      this.dragItemInfo.row = this.mStartPosition.row;
      this.dragItemInfo.page = this.mStartPosition.page;
    }

    this.initAppGridRect(screenId);
  }

  /**
   * 落位动画结束
   * @param allowEnd 是否允许无动画结束
   */
  public onDropAnimationEnd(allowEnd: boolean = false): void {
    super.onDropAnimationEnd(allowEnd);
    this.isDragCrossScreen = false;
    this.isDraggingCrossScreen = false;
  }

  /**
   * 更新dragPageIndex
   * @param showNext true 下一页，false 上一页
   */
  public updateDragPageIndex(showNext: boolean): void {
    let modifyCount: number = showNext ? 1 : -1;
    if (this.isDraggingCrossScreen && this.mDragPageIndex % 2 === 0) {
      modifyCount = showNext ? 2 : -2;
    }
    let targetPageIndex: number = this.mDragPageIndex + modifyCount;
    let curPageCount: number = this.mLayoutCacheManager.getPageCount();
    if (targetPageIndex >= 0 && targetPageIndex < curPageCount) {
      this.setDragPageIndex(targetPageIndex);
    }
  }

  protected needTriggerSqueeze(): boolean {
    let s = FoldedDeviceAcViewModel.getInstance().isHalfFolded() ||
    FoldedDeviceAcViewModel.getInstance().isUnFolded();
    let isFromBSide = this.mStartPosition !== undefined && this.mStartPosition.page % 2 === 0;
    let notCrossPageYet = this.mStartPosition?.page === this.mDragPageIndex;
    return !this.isSpeedValid || (s && isFromBSide && notCrossPageYet);
  }

  /**
   * 针对拖拽结束落点位置做矫正
   *
   * @param screenId
   */
  protected reviseEndPosInNeed(screenId?: number): void {
    // 终点落位点合法且跨页
    if (this.mEndPosition && this.mStartPosition?.page !== this.mEndPosition.page) {
      // 落点初步计算的坐标对应的Z序索引
      let endIndex: number =
        this.mEndPosition.column + this.mEndPosition.row * this.getGridStyleConfig(screenId).mColumns;
      // 落点目标页面上的最大索引值，因为是跨页所以目标页原始最大索引需加1
      let maxIndexOnEndPage: number =
        this.mLayoutCacheManager.getAppGridLayoutItemsByPage(this.mEndPosition.page).length;
      log.showInfo(`onDragFinal revise end pos-${this.mEndPosition.row}-${this.mEndPosition.column}-` +
        `${this.mEndPosition.page}-${endIndex}-${maxIndexOnEndPage}-${this.mCurrEndPosition?.row}-` +
        `${this.mCurrEndPosition?.column}`);
      // 如果落点是在本页末尾的空位区域，且上一次drag move时的最后一次实时落点位置合法则实施末尾空位区位置重置
      if (endIndex > maxIndexOnEndPage && this.mCurrEndPosition) {
        this.mEndPosition.row = this.mCurrEndPosition.row;
        this.mEndPosition.column = this.mCurrEndPosition.column;
      }
    }
  }

  protected updateEndPosIfDragToTailOrCrossPage(endItemPos: DragItemPosition, screenId: number = 0): void {
    let endIndex: number = endItemPos.column + endItemPos.row * this.mGridStyleConfig.mColumns;
    let maxIndexOnEndPage: number = this.mLayoutCacheManager.getAppGridLayoutItemsByPage(endItemPos.page).length - 1;
    if ((this.mStartPosition?.page !== this.mEndPosition?.page) &&
      (maxIndexOnEndPage < (this.mGridStyleConfig.mRows * this.mGridStyleConfig.mColumns - 1))) {
      // 跨页拖拽未完成时，当前页面上的元素已增加1
      maxIndexOnEndPage = maxIndexOnEndPage + 1;
    }
    if (endIndex > maxIndexOnEndPage) {
      // 如果拖到尾部空白位置，则替换为尾部的元素
      log.showInfo(`updateEndPosIfDragToTail ept drag to end space of page index ${endIndex} to ${maxIndexOnEndPage}`);
      endIndex = maxIndexOnEndPage;
      log.showInfo('updateEndPosIfDragToTail drag to end space of page update to: ' + endIndex);
      let cEndItem: number[] = this.getGridPositionByIndex(endIndex, screenId);
      if (cEndItem) {
        endItemPos.column = cEndItem[1];
        endItemPos.row = cEndItem[0];
        log.showInfo(`startSqueeze drag to end space of page update to: ${AppGridLayoutUtil.appGridPosToString(endItemPos)} `);
      }
      if (this.mCurrEndPosition) {
        log.showInfo(`updateEndPosIfDragToTail, mCurrEndPosition r:${endItemPos.row}-c:${endItemPos.column}`);
        this.mCurrEndPosition.row = endItemPos.row;
        this.mCurrEndPosition.column = endItemPos.column;
      }
    } else if (endIndex < maxIndexOnEndPage) {
      let needToTail = (endItemPos.page % 2 === 0) && endItemPos.row >= 4 &&
        (FoldedDeviceAcViewModel.getInstance().isHalfFolded() ||
        FoldedDeviceAcViewModel.getInstance().isUnFolded()) &&
      FoldedDeviceAcViewModel.getInstance(screenId).isNearBSideBottom(endItemPos.y);
      log.showInfo(`updateEndPosIfDragToTailOrCrossPage-${needToTail}-${endIndex}-${maxIndexOnEndPage}-${endItemPos.page}-${endItemPos.y}`);
      if (needToTail) {
        log.showInfo(`updateEndPosIfDragToTail drag to end space of page index ${endIndex} to ${maxIndexOnEndPage}`);
        endIndex = maxIndexOnEndPage;
        log.showInfo('updateEndPosIfDragToTail drag to end space of page update to: ' + endIndex);
        let cEndItem: number[] = this.getGridPositionByIndex(endIndex, screenId);
        if (cEndItem) {
          endItemPos.column = cEndItem[1];
          endItemPos.row = cEndItem[0];
          log.showInfo(`startSqueeze drag to end space of page update to: ${AppGridLayoutUtil.appGridPosToString(endItemPos)} `);
        }
        if (this.mCurrEndPosition) {
          log.showInfo(`updateEndPosIfDragToTail, mCurrEndPosition r:${endItemPos.row}-c:${endItemPos.column}`);
          this.mCurrEndPosition.row = endItemPos.row;
          this.mCurrEndPosition.column = endItemPos.column;
        }
      }
    }
  }
}