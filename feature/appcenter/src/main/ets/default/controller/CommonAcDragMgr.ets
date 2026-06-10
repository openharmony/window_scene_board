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

import { LogDomain, LogHelper, Trace, StartType, CheckEmptyUtils, RectInfo } from '@ohos/basicutils';
import { SCBTransitionManager, ResUtils } from '@ohos/windowscene';
import { ItemUtils, SceneSessionUIContextManager } from '@ohos/componenthelper';
import { localEventManager, GlobalContext } from '@ohos/frameworkwrapper';
import { DragEventManager, DragItemPosition, DragGridPosition } from '@ohos/componentdrag';
import { SCBCompanionManager } from '@ohos/windowscene/Index';
import { AppCenterGridStyleConfig } from '../common/AppCenterGridStyleConfig';
import {
  AppItemInfo,
  CalculateAppCenterRst,
  CommonConstants,
  EventConstants,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LaunchLayoutCacheManager,
  layoutConfigManager,
  LayoutViewModel,
  PageDesktopModel
} from '@ohos/launchercommon';
import FeatureConstants from '../common/constants/FeatureConstants';
import { AppLayoutInfo } from '../common/viewmodel/AppLayoutInfo';
import AppGridLayoutUtil from '../common/util/AppGridLayoutUtil';
import AppGridLayoutCacheManager from '../common/cache/AppGridLayoutCacheManager';
import { AppIconModel } from '@ohos/launchercommon/src/main/ets/launchericon/common/AppIconModel';
import { HashMap } from '@kit.ArkTS';
import { APP_CENTER_DROP_FRAME_KEY, AC_DRAG_SQUEEZE_DURATION } from '../constants/LayoutConstants';
import { AppCenterViewModel } from '../common/viewmodel/AppCenterViewModel';
import { dragTriggerUtil } from '@ohos/launchercommon/src/main/ets/utils/DragTriggerUtil';
import { SCBScreenProperty } from '@ohos/windowscene';
import { AcDragStatusMgr } from './AcDragStatusMgr';
import { ObjectCopyUtil } from '@ohos/componenthelper';

const TAG = 'CommonAcDragMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class CommonAcDragMgr {
  /**
   * 起拖图标的拖拽位置
   */
  protected mLastPosOnMoving: DragItemPosition | undefined;
  protected mEndPosition: DragItemPosition | undefined;
  protected mStartPosition: DragItemPosition | undefined;
  protected mAnimEndPosition: DragItemPosition | undefined;
  /**
   * 暂存endPosition, 因mEndPosition会在拖拽到尾部等情况做调整
   */
  protected mCurrEndPosition: DragItemPosition | undefined;
  /**
   * 被拖拽元素位移值
   */
  protected dragItemTranslationX: number = 0;
  protected dragItemTranslationY: number = 0;
  protected currentMouseX: number = 0;
  protected currentMouseY: number = 0;
  protected appGridRect: RectInfo | undefined;
  protected extAppGridRect: RectInfo | undefined;
  protected lastDragX: number = 0;
  protected lastDragY: number = 0;
  protected lastDragTime: number = 0;
  protected isSpeedValid: boolean = false;
  protected speedValidCount: number = 0;
  protected iconRadius: number = 16;
  protected minValidCount: number = 1;
  protected minMoveSpeed: number = 0.07;
  /**
   * 鼠标在拖动截图的相对位置
   */
  protected dragSnapshotRelativeRect: Rectangle | undefined = undefined;
  protected mDragPageIndex: number = 0;
  protected mIsDockDropShow: boolean = false;
  protected mIsSwaggingPage: boolean = false;
  protected isDropAnimating: boolean = false;
  protected isSqueezing: boolean = false;
  protected mGridStyleConfig: AppCenterGridStyleConfig;
  protected mExtGridStyleConfig: AppCenterGridStyleConfig;
  protected mAppCenterRst?: CalculateAppCenterRst;
  protected dragItemInfo: AppItemInfo | undefined;
  protected mTranslateItemList: Array<TranslateItem>;
  protected mLastTranslateItemList: Array<TranslateItem>;
  protected hasCancelSqueezeAnimation: boolean = true;
  protected mLayoutCacheManager: AppGridLayoutCacheManager;
  protected isAppCenterViewShow: boolean = false;
  protected appGridList: AppLayoutInfo[] = [];
  protected appGridListChanged: boolean = false;
  protected needBackToOriginPage: boolean = false;
  protected movingItemMap: Map<string, TranslateItem> = new Map<string, TranslateItem>();
  protected dropOnPage: boolean = false;
  protected droppedOnDock: boolean = false;
  protected isDragging: boolean = false;
  protected removeCompIconView: () => void = () => {};
  protected pageIndex: number = -1;
  protected toastHeight: number = 0;
  protected RESET_SQZ_TXY_SCENE_DFT: number = 1;
  protected RESET_SQZ_TXY_SCENE_DROP_ANIM_DONE: number = 2;
  protected RESET_SQZ_TXY_SCENE_DRAG_FINAL_UPD_CROSS_PAGE_FAIL: number = 3;
  protected RESET_SQZ_TXY_SCENE_DRAG_FINAL_NO_DROP: number = 4;
  protected RESET_SQZ_TXY_SCENE_DRAG_LEAVE: number = 5;
  protected RESET_SQZ_TXY_SCENE_DRAG_MOVE_INVALID_END_POS: number = 6;
  protected RESET_SQZ_TXY_SCENE_DRAG_MOVE_CROSS_PAGE_NO_AVAIL: number = 7;
  protected RESET_SQZ_TXY_SCENE_CROSS_PAGE_DRAG_UPD: number = 8;
  protected RESET_SQZ_TXY_SCENE_CROSS_PAGE_DRAG_IDX_UPD: number = 9;

  protected moveOutOfPage: boolean = false;
  protected movingItemMapForFullPage: Map<string, TranslateItem> = new Map<string, TranslateItem>();
  protected appGridListChangedPages: number[] = [];
  protected resetDelayForFullPageTimerId: number | undefined = undefined;
  protected resetDelayForFullPage: boolean = false;
  protected setDragPageIndexForDelay: number = -1;
  protected screenId: number = 0;
  public constructor() {
    this.mGridStyleConfig = layoutConfigManager.getStyleConfig(AppCenterGridStyleConfig.APP_GRID_STYLE_CONFIG,
      FeatureConstants.FEATURE_NAME);
    this.mExtGridStyleConfig = layoutConfigManager.getStyleConfig(AppCenterGridStyleConfig.EXT_APP_GRID_STYLE_CONFIG,
      FeatureConstants.FEATURE_NAME);
    this.mAppCenterRst = LayoutViewModel.getInstance().calculateAppCenter();
    this.mLayoutCacheManager = AppGridLayoutCacheManager.getInstance();
    this.mTranslateItemList = [];
    this.mLastTranslateItemList = [];
    this.initToastHeight();
    this.initAppGridRect();
  }

  public setIconRadius(iconRadius: number): void {
    this.iconRadius = iconRadius;
  }

  public isInDragging(): boolean {
    log.showInfo(`isInDragging ${this.isDragging}`);
    return this.isDragging;
  }

  /**
   * 更新应用中心拖拽相关参数，拓展屏拖拽适配
   */
  public updateAppCenterDragData(screenId?: number, isRefresh?: boolean, width?: number, height?: number): void {
    this.getGridStyleConfig(screenId).initConfig(screenId, isRefresh, width, height);
    this.mAppCenterRst = LayoutViewModel.getInstance().calculateAppCenter(screenId, isRefresh, width, height);
    if (!this.isDragging) {
      this.mTranslateItemList = [];
      this.mLastTranslateItemList = [];
    }
    this.initAppGridRect(screenId);
  }

  /**
   * 更新应用列表信息
   */
  public updateAppCenterLayoutInfo(scene: number, reason?: number): void {
    log.showInfo(`updateAppCenterLayoutInfo: scene-${scene}-${reason}`);

    if (this.isDragging && scene === FeatureConstants.AC_SCENE_APP_LIFE_PKG_ADD_INSTALLED) {
      log.showInfo('updateAppCenterLayoutInfo no need to update local app page list');
      return;
    }

    if (this.isDragging && scene === FeatureConstants.AC_SCENE_DFT &&
      reason === FeatureConstants.AC_UPDATE_PAGE_REASON_NEW_BLANK_PAGE) {
      log.showInfo('updateAppCenterLayoutInfo no need to update local app list as new blank page');
      return;
    }

    this.appGridList = this.mLayoutCacheManager.getAppGridLayoutItemList();
    let appLayoutInfo: AppItemInfo[] = [];
    this.appGridList?.forEach((page: AppLayoutInfo) => {
      page?.pageInfo?.forEach((item: AppItemInfo) => {
        log.showDebug(`updateAppCenterLayoutInfo : ${item.bundleName}, [${item.row}, ${item.column}, ${item.page}]`);
        appLayoutInfo.push(item);
      });
    });
    LaunchLayoutCacheManager.getInstance().registerAppcenter(appLayoutInfo);
  }

  public setWhiteBoxState(state: boolean): void {
    log.showInfo(`setWhiteBoxState param: ${state}`);
    this.mIsDockDropShow = state;
  }

  public setDragItemInfo(item: AppItemInfo): void {
    this.dragItemInfo = item;
  }

  public getDragItemInfo(): AppItemInfo {
    return this.dragItemInfo as AppItemInfo;
  }

  public initToastHeight(): void {
    let dockHeight = LayoutViewModel.getInstance().getDockHeight();
    this.toastHeight = dockHeight + 80;
    log.showInfo(`dockHeight_${dockHeight}_toastHeight_${this.toastHeight}`);
  }

  public setAppCenterViewShow(isShow: boolean): void {
    log.showInfo(`setAppCenterViewShow: ${isShow}`);
    this.isAppCenterViewShow = isShow;
  }

  public getAppCenterViewShow(): boolean {
    return this.isAppCenterViewShow;
  }

  /**
   * 是否拖拽元素
   * @param item
   * @returns
   */
  public isDragItem(item: AppItemInfo): boolean {
    if (!this.dragItemInfo || !item) {
      return false;
    }
    return this.checkAppItemEqual(item, this.dragItemInfo);
  }

  /**
   * 判断两个appItem是否相同
   * @param itemA
   * @param itemB
   * @returns
   */
  public checkAppItemEqual(itemA: AppItemInfo, itemB: AppItemInfo): boolean {
    if (!itemA || !itemB) {
      return false;
    }
    return itemA.bundleName === itemB.bundleName && itemA.appIndex === itemB.appIndex;
  }

  public setDragSnapshotRelativeRect(rect: Rectangle): void {
    log.showInfo(`setDragSnapshotRelativeRect x: ${rect?.x}, width: ${rect?.width}`);
    this.dragSnapshotRelativeRect = rect;
    dragTriggerUtil.setDragItemRect(rect);
  }

  public resetDragSnapshotRelativeRect(): void {
    log.showInfo('resetDragSnapshotRelativeRect');
    this.dragSnapshotRelativeRect = undefined;
    dragTriggerUtil.resetDragItemRect();
  }

  /**
   * 起拖
   * @param event
   * @param item
   */
  public onDragStart(event: DragEvent, item?: AppItemInfo, screenProp?: SCBScreenProperty): void {
    const x: number = event?.getWindowX();
    const y: number = event?.getWindowY();
    if (isNaN(x) || isNaN(y)) {
      log.showWarn('onDragStart x or y is NaN');
      return;
    }
    this.isDragging = true;
    this.screenId = screenProp?.screenId ?? 0;
    AcDragStatusMgr.getInstance().setDraggingStatus(this.isDragging);
    log.showInfo(`onDragStart: x is ${x}, y is ${y}`);
    this.currentMouseX = x;
    this.currentMouseY = y;
    Trace.start(Trace.CORE_METHOD_DRAG_START);
    if (item) {
      this.setDragItemInfo(item);
      log.showInfo(`onDragStart: drag item info-${item.row}-${item.column}-${item.page}`);
      this.resetDragStartPositionInNeed(x, y, item.page, screenProp?.screenId);
    }
    this.dropOnPage = false;
    this.hasCancelSqueezeAnimation = true;
    this.mStartPosition = this.getCurrentGridPos(this.currentMouseX,
      this.currentMouseY, item?.page, screenProp?.screenId);
    if (this.mStartPosition) {
      this.mLastPosOnMoving = {
        column: this.mStartPosition.column,
        row: this.mStartPosition.row,
        page: this.mStartPosition.page,
        x: this.mStartPosition.x,
        y: this.mStartPosition.y
      };
    } else {
      this.mLastPosOnMoving = undefined;
    }

    DragEventManager.getInstance().dragStartInDesktop(APP_CENTER_DROP_FRAME_KEY);
    log.showInfo(`onDragStart item：${item?.bundleName} pos on: ${AppGridLayoutUtil.appGridPosToString(this.mStartPosition)}`);
    this.prepareDragParams(screenProp);
    this.mLastTranslateItemList = [];
    Trace.end(Trace.CORE_METHOD_DRAG_START);
  }

  protected resetDragStartPositionInNeed(x: number, y: number, page?: number, screenId?: number): void {
    if (!this.dragItemInfo) {
      return;
    }

    let inputGridPos: DragGridPosition | undefined = AppGridLayoutUtil.getRowAndColumn(x, y, page, screenId);
    if (!inputGridPos) {
      log.showInfo(`Can not find app in grid page-${x}-${y}`);
      return;
    }

    let item = this.dragItemInfo;
    log.showInfo(`resetDragStartPositionInNeed: item rcp-${item.row}-${item.column}-${item.page}-` +
      `${inputGridPos.row}-${inputGridPos.column}`);

    let isDifferent = inputGridPos.column != item.column || inputGridPos.row !== item.row;
    if (!isDifferent) {
      return;
    }

    if (isDifferent) {
      let r = AppGridLayoutCacheManager.getInstance().findApp(item.bundleName, item.page ?? 0, item.appIndex);
      if (!r) {
        log.showInfo('can not find app in cache');
        return;
      }

      let notSame = inputGridPos.column != r.column || inputGridPos.row !== r.row;
      log.showInfo(`resetDragStartPositionInNeed: cache coord=> ${r.row}-${r.column}-${notSame}`);
      if (notSame) {
        let appPos: number[] = AppGridLayoutUtil.getGridItemPosition(r.row ?? 0, r.column ?? 0, item.page, screenId);
        log.showInfo(`resetDragStartPositionInNeed: xy=> ${appPos?.[0]}-${appPos?.[1]}`);
        this.currentMouseX = appPos[0];
        this.currentMouseY = appPos[1];
      }
    }
  }

  /**
   * 拖拽结束
   * @param event
   */
  public onDragEnd(event?: DragEvent, screenId?: number): void {
    log.showInfo(`onDragEnd ${this.isDropAnimating}`);
    if (!this.isDropAnimating) {
      // 如果没有落位成功，重置数据
      this.onDragFinal(undefined, screenId);
      this.onDropAnimationEnd(true);
    }
  }

  /**
   * 落位
   */
  public onDrop(context?: UIContext, screenProp?: SCBScreenProperty): void {
    log.showInfo('onDrop');
    this.dropOnPage = true;
    Trace.start(Trace.CORE_METHOD_DRAG_DROP);
    // 落位时需要直接取消当前正在进行的挤位动效，避免位置刷新后元素仍具有挤位偏移量
    this.hasCancelSqueezeAnimation = false;
    if (this.isAppCenterViewShow) {
      if (!this.mEndPosition || !this.isInAppCenterWorkBench(
        this.mEndPosition.x, this.mEndPosition.y, screenProp?.screenId)) {
        log.showInfo(`getCurrentGridPos， not isInAppCenterWorkBench pos:
        ${AppGridLayoutUtil.appGridPosToString(this.mEndPosition)}`);
        this.mAnimEndPosition = this.mStartPosition;
      } else {
        this.updateEndPosIfDragToTail(this.mEndPosition, screenProp?.screenId);
        this.mAnimEndPosition = this.mCurrEndPosition;
      }

      if (this.droppedOnDock) {
        log.showInfo('End the drop animation when out of app center');
        this.onDropAnimationEnd(true);
        this.droppedOnDock = false;
        return;
      }

      this.onDropAnim(context, screenProp);
    }
    this.onDragFinal(undefined, screenProp?.screenId);
  }
  private squeezeForFullPage(startItemPos: DragItemPosition, endItemPos: DragItemPosition): boolean {
    if (this.movingItemMap.size > 0 || this.movingItemMapForFullPage.size > 0) {
      log.showError(`squeezeForFullPage failed. movingItemMap.size: ${this.movingItemMap.size}, movingCacheItemMap.size: ${this.movingItemMapForFullPage.size}`);
      return false;
    }
    if (this.mLastPosOnMoving?.row !== this.mStartPosition?.row ||
      this.mLastPosOnMoving?.column !== this.mStartPosition?.column ||
      this.mLastPosOnMoving?.page !== this.mStartPosition?.page) {
      log.showError(`squeezeForFullPage failed. not reset to drag start. mLastPosOnMoving: (${this.mLastPosOnMoving?.row}, ${this.mLastPosOnMoving?.column}, ${this.mLastPosOnMoving?.page}), mStartPosition: (${this.mStartPosition?.row}, ${this.mStartPosition?.column}, ${this.mStartPosition?.page})`);
      return false;
    }
    log.showInfo(`squeezeForFullPage start. startItemPos: (${startItemPos.row}, ${startItemPos.column}, ${startItemPos.page}), endItemPos: (${endItemPos.row}, ${endItemPos.column}, ${endItemPos.page}), mLastPosOnMoving: (${this.mLastPosOnMoving?.row}, ${this.mLastPosOnMoving?.column}, ${this.mLastPosOnMoving?.page}), mStartPosition: (${this.mStartPosition?.row}, ${this.mStartPosition?.column}, ${this.mStartPosition?.page})`);
    this.calculateSqueezePos(startItemPos, endItemPos);
    const ret: boolean = this.updateMoveListForFullPage(true);
    if (ret) {
      this.refreshUIForFullPage(startItemPos, endItemPos);
      this.mLastPosOnMoving = {
        column:endItemPos.column,
        row: endItemPos.row,
        page: endItemPos.page,
        x: endItemPos.x,
        y: endItemPos.y
      };
      log.showInfo(`squeezeForFullPage success. mLastPosOnMoving: (${this.mLastPosOnMoving?.row}, ${this.mLastPosOnMoving?.column}, ${this.mLastPosOnMoving?.page})`);
      return true;
    }
    log.showError(`squeezeForFullPage failed. mLastPosOnMoving: (${this.mLastPosOnMoving?.row}, ${this.mLastPosOnMoving?.column}, ${this.mLastPosOnMoving?.page})`);
    return false;
  }
  private calculateSqueezePos(startItemPos: DragItemPosition, endItemPos: DragItemPosition): void {
    if (!this.dragItemInfo || !endItemPos) {
      log.showWarn('calculateSqueezePos return. dragItemInfo undefined');
      return;
    }
    log.showInfo(`calculateSqueezePos start. drag from (${startItemPos.row}, ${startItemPos.column}, ${startItemPos.page}) to (${endItemPos.row}, ${endItemPos.column}, ${endItemPos.page})`);
    let startIndex: number = startItemPos.column + startItemPos.row * this.mGridStyleConfig.mColumns;
    let endIndex: number = endItemPos.column + endItemPos.row * this.mGridStyleConfig.mColumns;
    let isSqueezeBack: boolean = startIndex < endIndex;
    if (startItemPos.page !== endItemPos.page) {
      isSqueezeBack = startItemPos.page < endItemPos.page;
    }
    this.moveOutOfPage = false;
    this.mTranslateItemList = [];
    this.appGridListChangedPages = [];
    let curPage = startItemPos.page < endItemPos.page ? startItemPos.page : endItemPos.page;
    for (; curPage < this.mLayoutCacheManager.getPageCount(); curPage++) {
      let startIndexInPage: number = -1;
      let endIndexInPage: number = -1;
      let isMoveBack: boolean = true;
      const curPageLastIndex: number = this.mLayoutCacheManager.getAppGridLayoutItemsByPage(curPage).length - 1;
      if (curPageLastIndex < 0) {
        continue;
      }
      if (curPage === startItemPos.page && curPage === endItemPos.page && startIndex !== endIndex) {
        isMoveBack = !isSqueezeBack;
        startIndexInPage = isSqueezeBack ? startIndex + 1 : endIndex;
        endIndexInPage = isSqueezeBack ? (endIndex <= curPageLastIndex ? endIndex : curPageLastIndex) : startIndex - 1;
      } else if (curPage === startItemPos.page && curPage !== endItemPos.page) {
        if (this.moveOutOfPage) {
          isMoveBack = true;
          startIndexInPage = 0;
          endIndexInPage = startIndex - 1;
        } else if (startIndex < curPageLastIndex) {
          isMoveBack = false;
          startIndexInPage = startIndex + 1;
          endIndexInPage = curPageLastIndex;
        }
      } else if (curPage !== startItemPos.page && curPage === endItemPos.page && endIndex <= curPageLastIndex) {
        isMoveBack = true;
        startIndexInPage = endIndex;
        endIndexInPage = curPageLastIndex;
      } else if (curPage > endItemPos.page && this.moveOutOfPage) {
        isMoveBack = true;
        startIndexInPage = 0;
        endIndexInPage = curPageLastIndex;
      } else {
        this.moveOutOfPage = false;
        continue;
      }
      log.showInfo(`calculateSqueezePos page: ${curPage}, moveOutOfPage: ${this.moveOutOfPage}, curPageLastIndex: ${curPageLastIndex}, move ${startIndexInPage} - ${endIndexInPage}, isMoveBack: ${isMoveBack}`);
      if (!this.moveInPage(curPage, startIndexInPage, endIndexInPage, isMoveBack)) {
        log.showError(`calculateSqueezePos failed. moveInPage ${curPage} failed`);
        this.mTranslateItemList = [];
        return;
      }
      this.appGridListChangedPages.push(curPage);
    }
    let translateDragItem: TranslateItem = this.dragItemInfo as TranslateItem;
    translateDragItem.newColumn = endItemPos.column;
    translateDragItem.newRow = endItemPos.row;
    translateDragItem.newPage = endItemPos.page;
    const oldItemIndex: number = this.mTranslateItemList.findIndex((value: TranslateItem) => {
      return value.bundleName === this.dragItemInfo?.bundleName && value.appIndex === this.dragItemInfo?.appIndex;
    });
    if (oldItemIndex >= 0 && oldItemIndex < this.mTranslateItemList.length) {
      this.mTranslateItemList.splice(oldItemIndex, 1);
    }
    if (this.appGridListChangedPages.findIndex((page: number) => {
      return translateDragItem.newPage == page;
    }) < 0) {
      this.appGridListChangedPages.push(translateDragItem.newPage);
    }
    this.mTranslateItemList.push(translateDragItem);
    log.showInfo(`calculateSqueezePos end. mTranslateItemList.length: ${this.mTranslateItemList.length}, appGridListChangedPages: ${this.appGridListChangedPages}`);
  }
  public getAppGridListByPage(pageIndex: number): AppItemInfo[] {
    if (pageIndex < 0 || pageIndex >= this.appGridList.length) {
      return [];
    }
    let sourcePageInfo: AppItemInfo[] = this.appGridList[pageIndex]?.pageInfo ?? [];
    let destItemList: AppItemInfo[] = [];
    sourcePageInfo.forEach((item: AppItemInfo) => {
      destItemList.push(ObjectCopyUtil.deepClone(item, new AppItemInfo()));
    });
    return destItemList;
  }
  public getDragRefreshPageEventKey(pageIndex: number): string {
    return `${FeatureConstants.EVENT_UPDATE_CURRENT_PAGE}_drag_${pageIndex}`;
  }
  private refreshUIForFullPage(startItemPos: DragItemPosition | undefined,
    endItemPos: DragItemPosition | undefined): void {
    if (this.movingItemMap.size > 0) {
      log.showError('refreshUIForFullPage failed. mLastTranslateItemList is not reset');
      return;
    }
    if (startItemPos && endItemPos) {
      const oldPosition: number[] = AppGridLayoutUtil.getGridItemPosition(startItemPos.row,
        startItemPos.column, startItemPos.page, this.screenId);
      const newPosition: number[] = AppGridLayoutUtil.getGridItemPosition(endItemPos.row,
        endItemPos.column, endItemPos.page, this.screenId);
      DragEventManager.getInstance().startSqueezedInDesktop(APP_CENTER_DROP_FRAME_KEY, [oldPosition, newPosition]);
    }
    AppStorage.setOrCreate('appCenterLayoutInfo', this.appGridList);
    AppStorage.setOrCreate('updateAppGridPageData', !AppStorage.get<boolean>('updateAppGridPageData'));
    this.appGridListChangedPages.forEach((pageIndex: number) => {
      log.showInfo(`refreshUIForFullPage refreshAppGridLayout page: ${pageIndex}`);
      GlobalContext.getContext()?.eventHub.emit(this.getDragRefreshPageEventKey(pageIndex));
    });
    this.checkResetDelayForFullPage();
  }
  private updateMoveListForFullPage(updateLocal: boolean = false): boolean {
    if (this.movingItemMapForFullPage.size > 0) {
      log.showError('updateMoveListForFullPage failed. last full page squeeze not reset');
      return false;
    }
    log.showInfo(`updateMoveListForFullPage start. updateLocal: ${updateLocal}`);
    let itemInfoList: AppItemInfo[] = [];
    this.mTranslateItemList.forEach((item: TranslateItem) => {
      const key: string = this.getItemEventKey(item);
      this.movingItemMapForFullPage.set(key, item);
      log.showInfo(`updateMoveListForFullPage, ${item.bundleName}(${item.row}, ${item.column}, ${item.page}) to (${item.newRow}, ${item.newColumn}, ${item.newPage})`);
      item.column = item.newColumn;
      item.row = item.newRow;
      item.page = item.newPage;
      itemInfoList.push(item as Object as AppItemInfo);
    });
    if (updateLocal && itemInfoList.length > 0) {
      this.appGridListChanged = true;
    }
    const ret: boolean = AppGridLayoutCacheManager.getInstance()
      .updateItemPositionById(itemInfoList, updateLocal ? this.appGridList : undefined);
    if (ret) {
      log.showInfo(`updateMoveListForFullPage success. mTranslateItemList.length: ${this.mTranslateItemList.length}, movingItemMapForFullPage.size: ${this.movingItemMapForFullPage.size}`);
      return true;
    } else {
      log.showError(`updateMoveListForFullPage failed. mTranslateItemList.length: ${this.mTranslateItemList.length}, movingItemMapForFullPage.size: ${this.movingItemMapForFullPage.size}`);
      this.resetLastGridList();
      return false;
    }
  }
  private moveInPage(page: number, startIndex: number, endIndex: number, isMoveBack: boolean): boolean {
    this.moveOutOfPage = false;
    if (!this.appGridList || page >= this.appGridList.length || page < 0) {
      log.showError(`moveInPage failed. page ${page} is invalid. ${this.appGridList.length}`);
      return false;
    }
    const appLayout: AppItemInfo[] = this.appGridList[page].pageInfo;
    if (startIndex < 0 || startIndex >= appLayout.length ||
      endIndex < 0 || endIndex >= appLayout.length || startIndex > endIndex) {
      log.showInfo(`moveInPage directly return. params invalid. page: ${page}, appLayout.length: ${appLayout.length}, startIndex: ${startIndex}, endIndex: ${endIndex}`);
      return true;
    }
    log.showInfo(`moveInPage page: ${page}, startIndex: ${startIndex} - ${appLayout[startIndex].bundleName}(${appLayout[startIndex].row}, ${appLayout[startIndex].column}, ${appLayout[startIndex].page}), endIndex: ${endIndex} - ${appLayout[endIndex].bundleName}(${appLayout[endIndex].row}, ${appLayout[endIndex].column}, ${appLayout[endIndex].page}), isMoveBack: ${isMoveBack}`);
    for (let i = startIndex; i <= endIndex; i++) {
      const item: AppItemInfo = appLayout[i];
      const key: string = this.getItemEventKey(item);
      let oldTranslateItem: TranslateItem | undefined = this.mTranslateItemList.find((i) => {
        return this.getItemEventKey(i) === key;
      });
      let nextGridPos: number[] | undefined = undefined;
      if (oldTranslateItem) {
        nextGridPos = this.mLayoutCacheManager.getNextPosition(!isMoveBack,
          oldTranslateItem.newRow, oldTranslateItem.newColumn, oldTranslateItem.newPage);
      } else {
        nextGridPos = this.mLayoutCacheManager.getNextPosition(!isMoveBack, item.row, item.column, item.page);
      }
      if (!nextGridPos) {
        log.showError(`moveInPage failed. find nextGridPos failed. isMoveBack: ${isMoveBack}, of ${oldTranslateItem?.bundleName}(${oldTranslateItem?.newRow}, ${oldTranslateItem?.newColumn}, ${oldTranslateItem?.newPage}) / ${item.bundleName}(${item.row}, ${item.column}, ${item.page})`);
        return false;
      }
      let translateItem: TranslateItem = TranslateItem.fromAppItemInfo(item);
      translateItem.newRow = nextGridPos[0];
      translateItem.newColumn = nextGridPos[1];
      translateItem.newPage = nextGridPos[2];
      if (translateItem.page !== translateItem.newPage) {
        this.moveOutOfPage = true;
      }
      log.showDebug(`moveInPage loop: index ${i} squeeze ${item.bundleName} from (${item.row}, ${item.column}, ${item.page}) to (${translateItem.newRow}, ${translateItem.newColumn}, ${translateItem.newPage})`);
      this.mTranslateItemList.push(translateItem);
    }
    return true;
  }

  private onDragFinalForFullPage(): void {
    if (this.movingItemMapForFullPage.size === 0) {
      return;
    }
    log.showInfo(`onDragFinalForFullPage start. movingItemMap.size: ${this.movingItemMap.size}, movingItemMapForFullPage.size: ${this.movingItemMapForFullPage.size}`);
    let itemInfoList: AppItemInfo[] = [];
    this.appGridList.forEach((appLayout: AppLayoutInfo) => {
      appLayout.pageInfo.forEach((appItem: AppItemInfo) => {
        const key = this.getItemEventKey(appItem);
        if (this.movingItemMapForFullPage.get(key) || this.movingItemMap.get(key)) {
          log.showInfo(`onDragFinalForFullPage ${appItem.bundleName} (${appItem.row}, ${appItem.column}, ${appItem.page})`);
          itemInfoList.push(appItem);
        }
      });
    });
    log.showInfo(`onDragFinalForFullPage end. itemInfoList.length: ${itemInfoList.length}, movingItemMap.size: ${this.movingItemMap.size}, movingItemMapForFullPage.size: ${this.movingItemMapForFullPage.size}`);
    AppGridLayoutCacheManager.getInstance().updateItemPositionById(itemInfoList, undefined);
    this.movingItemMapForFullPage.clear();
  }
  /**
   * 拖拽移动
   * @param event
   * @param callback
   */
  public onDragMove(event: DragEvent, callback?: Function, uiContext?: UIContext, screenId?: number): void {
    // 获取鼠标位置
    // 获取当前页数
    // 判断所属宫格
    // 是否需要挤位
    // 若是，则发通知，被拖起元素是否离开了原位，到达了哪个位置
    const x: number = event?.getWindowX();
    const y: number = event?.getWindowY();
    if (isNaN(x) || isNaN(y)) {
      log.showWarn('onDragMove x or y is NaN');
      return;
    }
    if (this.resetDelayForFullPage) {
      log.showInfo('onDragMove directly return. resetDelayForFullPage true');
      return;
    }
    if (this.setDragPageIndexForDelay > 0) {
      log.showWarn(`onDragMove setDragPageIndex ${this.setDragPageIndexForDelay}`)
      this.setDragPageIndex(this.setDragPageIndexForDelay);
    }
    this.currentMouseX = x;
    this.currentMouseY = y;
    this.mEndPosition = this.getCurrentGridPosForMove(x, y, this.mDragPageIndex, screenId);
    if (this.mEndPosition) {
      this.mCurrEndPosition = {
        column: this.mEndPosition.column,
        row: this.mEndPosition.row,
        page: this.mEndPosition.page,
        x: this.mEndPosition.x,
        y: this.mEndPosition.y
      };
    } else {
      this.mCurrEndPosition = undefined;
    }
    this.needBackToOriginPage = false;
    if (this.checkIfCrossPageAndInvalid()) {
      // 跨页且落点空位
      log.showWarn('onDragMove mEndPosition undefined and skip page');
      this.resetLastItemList(this.RESET_SQZ_TXY_SCENE_DRAG_MOVE_CROSS_PAGE_NO_AVAIL);
      this.resetLastGridList();
      this.isSqueezing = false;
      this.mCurrEndPosition = undefined;
      this.needBackToOriginPage = true;
      this.mLastPosOnMoving = this.mStartPosition;
      DragEventManager.getInstance().cancelSqueezedInDesktop(APP_CENTER_DROP_FRAME_KEY, false);
      return;
    }
    if (!this.mEndPosition || !this.mLastPosOnMoving) {
      log.showWarn('onDragMove mEndPosition or mLastPosOnMoving is undefined');
      // 终点位置不合法，重置resetMoveList
      this.resetLastItemList(this.RESET_SQZ_TXY_SCENE_DRAG_MOVE_INVALID_END_POS);
      this.resetLastGridList();
      this.isSqueezing = false;
      this.mLastPosOnMoving = this.mStartPosition;
      if (this.dragItemInfo && this.mStartPosition) {
        log.showInfo(`End pos invalid then reset SQZ drag item-${this.dragItemInfo.row}-${this.dragItemInfo.column}` +
          `-${this.dragItemInfo.page}-${this.mStartPosition.row}-${this.mStartPosition.column}` +
          `-${this.mStartPosition.page}`);
        this.dragItemInfo.column = this.mStartPosition.column;
        this.dragItemInfo.row = this.mStartPosition.row;
        this.dragItemInfo.page = this.mStartPosition.page;
      }
      DragEventManager.getInstance().cancelSqueezedInDesktop(APP_CENTER_DROP_FRAME_KEY, false);
      return;
    }
    this.mEndPosition.page = this.mDragPageIndex;
    log.showInfo(`onDragMove x: ${x}, y: ${y}, mDragPageIndex: ${this.mDragPageIndex}. item pos on: ${AppGridLayoutUtil.appGridPosToString(this.mEndPosition)}`);

    if (this.isSqueezing || !this.isStatusChange(x, y)) {
      log.showInfo('onDragMove directly return. isSqueezing true or isStatusChange false');
      return;
    }
    if (this.mCurrEndPosition && this.mStartPosition &&
      this.mLastPosOnMoving?.page !== this.mDragPageIndex &&
    AppGridLayoutCacheManager.getInstance().isFullPage(this.mDragPageIndex)) {
      log.showInfo(`onDragMove, enter full page squeeze. mLastPosOnMoving.page: ${this.mLastPosOnMoving?.page}, mCurrEndPosition.page: ${this.mCurrEndPosition.page}`);
      this.isSqueezing = true;
      this.squeezeForFullPage(this.mStartPosition, this.mCurrEndPosition);
      this.isSqueezing = false;
      return;
    }
    this.isSqueezing = true;
    let ret: boolean = this.startSqueeze(this.mLastPosOnMoving, this.mEndPosition, uiContext, screenId);
    log.showInfo('onDragMove startSqueeze result: ' + ret);
    if (ret && this.dragItemInfo) {
      this.dragItemInfo.column = this.mEndPosition.column;
      this.dragItemInfo.row = this.mEndPosition.row;
      let oldPageIdx = this.dragItemInfo.page;
      this.dragItemInfo.page = this.mDragPageIndex;
      log.showInfo(`onDragMove update drag item info : ` +
        `${this.dragItemInfo.row}-${this.dragItemInfo.column}-${this.dragItemInfo.page}-${oldPageIdx}`);
      this.updateMoveList(true);
      this.checkResetDelayForFullPage();
    }
    if (this.mCurrEndPosition) {
      this.mLastPosOnMoving = {
        column: this.mCurrEndPosition.column as number,
        row: this.mCurrEndPosition.row as number,
        page: this.mCurrEndPosition.page as number,
        x: this.mCurrEndPosition.x as number,
        y: this.mCurrEndPosition.y as number
      }
    }
    this.isSqueezing = false;
    log.showInfo(`onDragMove mLastPosOnMoving update: ${AppGridLayoutUtil.appGridPosToString(this.mLastPosOnMoving)}`);
  }

  private checkResetDelayForFullPage(): void {
    if (this.movingItemMapForFullPage.size > 0) {
      clearTimeout(this.resetDelayForFullPageTimerId);
      this.resetDelayForFullPage = true;
      this.resetDelayForFullPageTimerId = setTimeout(() => {
        this.resetDelayForFullPage = false;
        this.resetDelayForFullPageTimerId = undefined;
      }, AC_DRAG_SQUEEZE_DURATION);
    }
  }

  /**
   * 拖拽中断重置
   */
  public onDragCancel(): void {
    this.hasCancelSqueezeAnimation = false;
    this.dropOnPage = true;
    this.mAnimEndPosition = this.mStartPosition;
    this.droppedOnDock = false;
    this.onDragEnd(undefined, 0)
    AcDragStatusMgr.getInstance().setDraggingStatus(false);
  }

  /**
   * 拖拽进入当前区域
   */
  public onDragEnter(screenProp?: SCBScreenProperty): void {
    log.showInfo('onDragEnter');
    this.prepareDragParams(screenProp);
    this.droppedOnDock = false;
  }

  /**
   * 拖拽离开当前区域
   */
  public onDragLeave(): void {
    log.showInfo('onDragLeave');
    this.resetLastItemList(this.RESET_SQZ_TXY_SCENE_DRAG_LEAVE);
    this.resetLastGridList();
    this.resetDragItemInfoInNeed();
    this.mLastPosOnMoving = this.mStartPosition;
    this.droppedOnDock = true;
  }

  public resetLastMovPosIfDragLeave(): void {
    if (this.isDragging && this.mDragPageIndex > 0 && this.mStartPosition?.page === 0) {
      log.showInfo(`resetLastMovPos-lastmovpos-${AppGridLayoutUtil.appGridPosToString(this.mLastPosOnMoving)}` +
        `-startpos-${AppGridLayoutUtil.appGridPosToString(this.mStartPosition)}`);
      this.mLastPosOnMoving = this.mStartPosition;
    }
  }

  /**
   * 重置行列信息
   */
  protected resetDragItemInfoInNeed(): void {
  }

  /**
   * 更新当前拖拽到达页
   * @param index
   */
  public setDragPageIndex(index: number): void {
    if (index < 0 || index >= AppGridLayoutCacheManager.getInstance().getPageCount()) {
      log.showError(`setDragPageIndex invalid index ${index}`);
      return;
    }
    if (this.resetDelayForFullPage && (this.movingItemMapForFullPage.size > 0)) {
      this.setDragPageIndexForDelay = index;
      log.showWarn(`setDragPageIndex ${index} directly return with full page delay`);
      return;
    }
    if (this.setDragPageIndexForDelay > 0) {
      this.setDragPageIndexForDelay = -1;
    }
    if (this.mDragPageIndex !== index) {
      // 换页了，原有移动需要重置
      this.resetLastItemList(this.RESET_SQZ_TXY_SCENE_CROSS_PAGE_DRAG_IDX_UPD);
      this.resetLastGridList();
      this.mLastPosOnMoving = this.mStartPosition;
    }
    this.mDragPageIndex = index;
    // 拖拽时停在翻页箭头的情况会翻页且不执行拖拽计算，需要判断是否需要回弹
    if (this.checkIfCrossPageAndInvalid()) {
      this.needBackToOriginPage = true;
    }
    log.showWarn(`setDragPageIndex ${this.mDragPageIndex}`);
  }

  public setIsSwaggingPage(isSwaggingPage: boolean): void {
    this.mIsSwaggingPage = isSwaggingPage;
  }

  public getIsSwaggingPage(): boolean {
    return this.mIsSwaggingPage;
  }

  /**
   * 落位动画结束
   * @param allowEnd 是否允许无动画结束
   */
  public onDropAnimationEnd(allowEnd: boolean = false): void {
    log.showInfo('onDropAnimationEnd');
    if (!this.mIsDockDropShow) {
      Trace.end(Trace.CORE_METHOD_DRAG_DROP);
    }
    if (!allowEnd && !this.isDropAnimating) {
      log.showError('onDropAnimationEnd interceptDropAnim');
      return;
    }
    this.isDropAnimating = false;
    DragEventManager.getInstance().dropEnd(this.getItemEventKey(this.dragItemInfo));
    DragEventManager.getInstance().dropEnd(APP_CENTER_DROP_FRAME_KEY);
    this.refreshAppGridLayout();
    this.afterDrop();
  }

  private resetLastGridList(): void {
    log.showInfo(`resetLastGridList appGridListChanged: ${this.appGridListChanged}, movingItemMapForFullPage.size: ${this.movingItemMapForFullPage.size}`);
    if (this.appGridListChanged || this.movingItemMapForFullPage.size > 0) {
      this.updateAppCenterLayoutInfo(FeatureConstants.AC_SCENE_DFT);
      this.appGridListChanged = false;
    }
    if (this.movingItemMapForFullPage.size > 0) {
      this.refreshUIForFullPage(this.mLastPosOnMoving, this.mStartPosition);
      this.movingItemMapForFullPage.clear();
    }
  }

  /**
   * 应用中心相关拖拽数据准备
   */
  private prepareDragParams(screenProp?: SCBScreenProperty): void {
    if (!this.dragItemInfo) {
      log.showInfo('prepareDragParams dragItemInfo undefined');
      return;
    }
    // 准备数据
    const itemKey: string = this.getItemEventKey(this.dragItemInfo);
    let removeCompIconView = SCBCompanionManager.getInstance().getController(screenProp?.screenId)?.quickAdd?.({
      iconId: '',
      bundleName: this.dragItemInfo?.bundleName ?? '',
      abilityName: this.dragItemInfo?.abilityName ?? '',
      moduleName: this.dragItemInfo?.moduleName as string,
      iconNumber: this.dragItemInfo?.appIconId ?? 0,
      appIndex: this.dragItemInfo?.appIndex ?? 0,
      iconRadius: this.iconRadius,
      startAppType: StartType.APP,
      cardId: '',
      extraId: '',
      needBadge: false,
    });
    if (removeCompIconView) {
      this.removeCompIconView = removeCompIconView;
    }
    log.showInfo(`dealDragParams success. ${itemKey}, x: ${this.dragSnapshotRelativeRect?.x},
    width: ${this.dragSnapshotRelativeRect?.width} ${this.iconRadius}`);
  }

  /**
   * 落位后状态重置
   */
  private afterDrop(): void {
    log.showInfo('afterDrop');
    this.pageIndex = -1;
    this.dragItemTranslationX = 0;
    this.dragItemTranslationY = 0;
    this.mLastPosOnMoving = undefined;
    this.mStartPosition = undefined;
    this.mEndPosition = undefined;
    this.currentMouseX = 0;
    this.currentMouseY = 0;
    this.isDropAnimating = false;
    this.resetDragSnapshotRelativeRect();
    this.mTranslateItemList = [];
    this.appGridListChanged = false;
    this.needBackToOriginPage = false;
    this.dropOnPage = false;
    this.movingItemMap.clear();
    this.deleteBlankPage();
    this.dragItemInfo = undefined;
    this.movingItemMapForFullPage.clear();
    this.resetDelayForFullPage = false;
    this.setDragPageIndexForDelay = -1;
    this.isDragging = false;
    AcDragStatusMgr.getInstance().setDraggingStatus(this.isDragging);
    // 拖向dock，无需回收
    if (!this.mIsDockDropShow) {
      this.removeCompIconView();
      this.removeCompIconView = () => {};
    }
  }

  public removeDropAnim(): void {
    if (!this.isDropAnimating) {
      log.showDebug('removeDropAnim return. isDropAnimating false');
      return;
    }
    if (this.needBackToOriginPage && this.mStartPosition) {
      log.showDebug('removeDropAnim return. needBackToOriginPage');
      return;
    }
    log.showInfo('removeDropAnim');
    this.removeCompIconView();
    this.removeCompIconView = () => {};
    DragEventManager.getInstance().dropEnd(this.getItemEventKey(this.dragItemInfo));
    DragEventManager.getInstance().dropEnd(APP_CENTER_DROP_FRAME_KEY);
  }

  public initCurrentMouse() {
    this.currentMouseX = 0;
    this.currentMouseY = 0;
  }

  private deleteBlankPage(): void {
    let deleteRet: boolean = this.mLayoutCacheManager.deleteBlankPage();
    log.showInfo(`sendLocalEventSticky-deleteRet-${deleteRet}`);
    if (deleteRet) {
      setTimeout(() => {
        log.showInfo('sendLocalEventSticky');
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_APP_GRID_REFRESH_FINISHED, null);
      }, 50);
    }
  }

  /**
   * 是否正在动画中
   */
  public isAnimating(): boolean {
    log.showInfo(`onDropAnim isAnimating: ${this.isDropAnimating}`);
    return this.isDropAnimating;
  }

  private onDropAnim(context?: UIContext, screenProp?: SCBScreenProperty): void {
    if (this.mIsDockDropShow) {
      // 正拖往dock
      this.onDropAnimationEnd(true);
      return;
    }
    this.isDropAnimating = true;
    const compViewController = SCBTransitionManager.getInstance().findTransitionController('SCBCompanionView', () => {
      return PageDesktopModel.getInstance().getCloseAppData('SCBCompanionView', '', StartType.APP,
        undefined, undefined, undefined, undefined, undefined, screenProp?.screenId);
    });
    let itemRect: RectInfo | undefined;
    const componentId: string =
      AppIconModel.getInstance().getIconId(this.dragItemInfo, CommonConstants.APPCENTER_ICON_EXTRA_ID);
    log.showInfo(`onDropAnim componentId: ${componentId}`);
    itemRect = this.getAppGridIconRectByPosition(this.mAnimEndPosition, screenProp?.screenId);
    if (this.mStartPosition && this.mEndPosition && this.mStartPosition.page === this.mEndPosition.page && !itemRect) {
      log.showInfo(`onDropAnim at same page`);
      // 拿到带绘制属性的位置大小信息，这里不需要补齐挤位过程中的位移
      SceneSessionUIContextManager.getInstance().setUiContext(context);
      itemRect = ItemUtils.getFrameNodeRectById(componentId);
    }
    log.showInfo(`onDropAnim itemRect: left: ${itemRect?.left}, top: ${itemRect?.top}`);
    if (!itemRect) {
      log.showWarn('onDropAnim itemRect undefined');
      this.onDropAnimationEnd();
      return;
    }
    log.showInfo(`onDropAnim translate offset x: ${this.dragItemTranslationX}, y: ${this.dragItemTranslationY}`);
    if (!this.dragSnapshotRelativeRect) {
      log.showWarn('onDropAnim dragSnapshotRelativeRect undefined');
      this.onDropAnimationEnd();
      return;
    }
    AppStorage.setOrCreate<boolean>('isDropAnimationGoing', true);
    let translateX: number = this.currentMouseX - ResUtils.getNumberFromLength(this.dragSnapshotRelativeRect.x) +
      ResUtils.getNumberFromLength(this.dragSnapshotRelativeRect.width) / 2 -
    ResUtils.getNumberFromLength(itemRect.left) - ResUtils.getNumberFromLength(itemRect.width) / 2;
    let translateY: number = this.currentMouseY - ResUtils.getNumberFromLength(this.dragSnapshotRelativeRect.y) +
      ResUtils.getNumberFromLength(this.dragSnapshotRelativeRect.height) / 2 -
    ResUtils.getNumberFromLength(itemRect.top) - ResUtils.getNumberFromLength(itemRect.height) / 2;
    const want: HashMap<string, number | string> = new HashMap();
    want.set('width', ResUtils.getNumberFromLength(itemRect.width));
    want.set('height', ResUtils.getNumberFromLength(itemRect.height));
    want.set('posX', ResUtils.getNumberFromLength(itemRect.left));
    want.set('posY', ResUtils.getNumberFromLength(itemRect.top));
    want.set('translateX', translateX);
    want.set('translateY', translateY);
    want.set('scaleX', 1.1);
    want.set('scaleY', 1.1);
    want.set('bundleName', this.dragItemInfo?.bundleName);
    want.set('abilityName', this.dragItemInfo?.abilityName);
    want.set('containerId', '');
    log.showInfo(`generateDropAnim end, drop to area: x: ${want.get('posX')}, y: ${want.get('posY')}, width: ${want.get('width')}, from translateX: ${want.get('translateX')},translateY: ${want.get('translateY')}`);
    compViewController?.backward?.(want);
  }

  private getAppGridIconRectByPosition(
    position: DragItemPosition | undefined, screenId?: number): RectInfo | undefined {
    if (!position) {
      log.showWarn('getAppGridIconRectByPosition param undefined');
      return undefined;
    }
    log.showInfo(`getAppGridIconRectByPosition position: ${AppGridLayoutUtil.appGridPosToString(position)}`);

    let iconRect: RectInfo = new RectInfo();
    // [0] for x, and [1] for y
    const appGridPos: number[] = AppGridLayoutUtil.getGridItemPosition(
      position.row, position.column, position.page, screenId);
    iconRect.left = appGridPos[0] +
      (this.getGridStyleConfig(screenId).mAppCenterItemWidth - this.getGridStyleConfig(screenId).mIconSize) / 2;
    iconRect.top =
      appGridPos[1] + (this.mAppCenterRst?.mAppCenterBubbleMarginTop ?? 0) +
      this.getGridStyleConfig(screenId).mIconMarginVertical;
    iconRect.width = this.getGridStyleConfig(screenId).mIconSize;
    iconRect.height = this.getGridStyleConfig(screenId).mIconSize;
    iconRect.right = iconRect.left + iconRect.width;
    iconRect.bottom = iconRect.top + iconRect.height;
    return iconRect;
  }

  public getAppItemRectByPosition(row: number | undefined, column: number | undefined,
    page: number | undefined, screenId: number = 0): RectInfo | undefined {
    let iconRect: RectInfo = new RectInfo();
    if (row === undefined || column === undefined) {
      return iconRect;
    }
    // [0] for x, and [1] for y
    const appGridPos: number[] = AppGridLayoutUtil.getGridItemPosition(row, column, page, screenId);
    iconRect.left = appGridPos[0] +
      (this.getGridStyleConfig(screenId).mAppCenterItemWidth - this.getGridStyleConfig(screenId).mIconSize) / 2;
    iconRect.top =
      appGridPos[1] + (this.mAppCenterRst?.mAppCenterBubbleMarginTop ?? 0) +
      this.getGridStyleConfig(screenId).mIconMarginVertical;
    iconRect.width = this.getGridStyleConfig(screenId).mIconSize;
    iconRect.height = this.getGridStyleConfig(screenId).mIconSize;
    iconRect.right = iconRect.left + iconRect.width;
    iconRect.bottom = iconRect.top + iconRect.height;
    return iconRect;
  }

  /**
   * 更新dragPageIndex
   * @param showNext true 下一页，false 上一页
   */
  public updateDragPageIndex(showNext: boolean): void {
    let modifyCount: number = showNext ? 1 : -1;
    let targetPageIndex: number = this.mDragPageIndex + modifyCount;
    let curPageCount: number = this.mLayoutCacheManager.getPageCount();
    if (targetPageIndex >= 0 && targetPageIndex < curPageCount) {
      this.setDragPageIndex(targetPageIndex);
    }
  }

  protected resetDragItemDataOnDragFinal(): void {
  }

  protected getToastHeight(): number | undefined {
    return this.toastHeight;
  }

  /**
   * 针对拖拽结束落点位置做矫正
   *
   * @param screenId
   */
  protected reviseEndPosInNeed(screenId?: number): void {
  }

  /**
   * 改变应用中心数据
   * @param event 拖拽事件
   */
  protected onDragFinal(event?: DragEvent, screenId?: number): void {
    log.showInfo('onDragFinal');
    const x: number = event?.getWindowX() as number;
    const y: number = event?.getWindowY() as number;
    if (!isNaN(x) && !isNaN(y)) {
      log.showWarn('onDragFinal x or y is not NaN');
      this.mEndPosition = this.getCurrentGridPos(x, y);
    } else {
      this.mEndPosition = this.getCurrentGridPos(this.currentMouseX, this.currentMouseY, this.mDragPageIndex, screenId);

      // 针对跨页拖拽场景，在落点位于空位区时做一下终点坐标的矫正
      this.reviseEndPosInNeed(screenId);
    }
    if (!this.mEndPosition || !this.dragItemInfo || !this.mStartPosition || !this.mLastPosOnMoving) {
      log.showWarn(`onDragFinal mEndPosition is null, ${this.needBackToOriginPage}`);
      if (this.needBackToOriginPage && this.mStartPosition) {
        AppCenterViewModel.getInstance().goExactPage(this.mStartPosition.page,
          AppGridLayoutCacheManager.getInstance().getPageCount());
        this.resetDragItemDataOnDragFinal();
      }
      return;
    }
    let dOriginCol = this.dragItemInfo.column;
    let dOriginRow = this.dragItemInfo.row;
    let dOriginPage = this.dragItemInfo.page;
    this.dragItemInfo.column = this.mEndPosition.column;
    this.dragItemInfo.row = this.mEndPosition.row;
    this.dragItemInfo.page = this.mDragPageIndex;
    // 不在同页
    log.showWarn(`onDragFinal pos, mStartPos: ${AppGridLayoutUtil.appGridPosToString(this.mStartPosition)},
    mEndPos: ${AppGridLayoutUtil.appGridPosToString(this.mEndPosition)}`);

    if (!this.dropOnPage) {
      this.resetLastItemList(this.RESET_SQZ_TXY_SCENE_DRAG_FINAL_NO_DROP);
      this.resetLastGridList();
      this.dragItemInfo.column = dOriginCol;
      this.dragItemInfo.row = dOriginRow;
      this.dragItemInfo.page = dOriginPage;
      return;
    }
    if (this.mStartPosition?.page !== this.mEndPosition.page) {
      if (this.movingItemMapForFullPage.size > 0) {
        // 拖拽到满页
        this.onDragFinalForFullPage();
      } else {
        const oldPages: number = this.mLayoutCacheManager.getAppGridLayoutItemList(false)?.length ?? 0;
        let ret: boolean = this.mLayoutCacheManager.updateItemForDifferentPage(this.mStartPosition, this.dragItemInfo);
        const newPages: number = this.mLayoutCacheManager.getAppGridLayoutItemList(false)?.length ?? 0;
        let isBlankPageDeleted: boolean = (oldPages - newPages) === 1;
        if (!ret) {
          if (this.needBackToOriginPage && this.mStartPosition) {
            log.showInfo('onDragFinal full drag And backTo originPage');
            AppCenterViewModel.getInstance().goExactPage(this.mStartPosition.page,
              AppGridLayoutCacheManager.getInstance().getPageCount());
            this.dragItemInfo.page = dOriginPage;
            return;
          } else {
            log.showInfo('onDragFinal, updateDifferentPage Failed, then reset');
            this.resetLastItemList(this.RESET_SQZ_TXY_SCENE_DRAG_FINAL_UPD_CROSS_PAGE_FAIL);
            this.resetLastGridList();
            log.showInfo(`onDragFinal reset drag item to origin: ${dOriginRow}-${dOriginCol}-${dOriginPage}` +
              `-${this.mEndPosition.row}-${this.mEndPosition.column}-${this.mDragPageIndex}`);
            this.dragItemInfo.column = dOriginCol;
            this.dragItemInfo.row = dOriginRow;
            this.dragItemInfo.page = dOriginPage;
            return;
          }
        }
      }
    } else {
      this.updateMoveList();
    }
  }

  private refreshAppGridLayout(): void {
    log.showInfo(`refreshAppGridLayout fixedPageIndex: ${this.pageIndex}`);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_APP_GRID_REFRESH_FINISHED, null);
    log.showInfo(`Squeeze app anim reset txy-${this.mLastTranslateItemList?.length}`);
    this.resetLastItemList(this.RESET_SQZ_TXY_SCENE_DROP_ANIM_DONE);
  }

  protected updateEndPosIfDragToTailOrCrossPage(endItemPos: DragItemPosition, screenId?: number): void {
    this.updateEndPosIfDragToTail(endItemPos, screenId);
  }

  private updateEndPosIfDragToTail(endItemPos: DragItemPosition, screenId: number = 0): void {
    let endIndex: number = endItemPos.column +
      endItemPos.row * this.getGridStyleConfig(screenId).mColumns;
    let maxIndexOnEndPage: number = this.mLayoutCacheManager.getAppGridLayoutItemsByPage(endItemPos.page).length - 1;
    log.showInfo(`updateEndPosIfDragToTail start. page: ${endItemPos.page}, maxIndexOnEndPage: ${maxIndexOnEndPage}, start page: ${this.mStartPosition?.page}, end page: ${this.mEndPosition?.page}`);
    if (this.mStartPosition?.page !== this.mEndPosition?.page) {
      // 跨页拖拽未完成时，当前页面上的元素已增加1
      maxIndexOnEndPage = maxIndexOnEndPage + 1;
    }
    if (endIndex > maxIndexOnEndPage) {
      // 如果拖到尾部空白位置，则替换为尾部的元素
      log.showInfo('updateEndPosIfDragToTail drag to end space of page, index: ' + endIndex);
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

  private oldCalculateSqueezePos(startIndex: number,
    endIndex: number, page: number, isSqueezeBack: boolean, screenId?: number): void {
    log.showInfo(`oldCalculateSqueezePos start. startIndex: ${startIndex}, endIndex: ${endIndex}, page: ${page}, isSqueezeBack: ${isSqueezeBack}, screenId: ${screenId}, mTranslateItemList.length: ${this.mTranslateItemList.length}`);
    for (let i = isSqueezeBack ? startIndex + 1 : startIndex - 1; isSqueezeBack ? i <= endIndex : i >= endIndex;
      isSqueezeBack ? i++ : i--) {
      if (i < 0 || i >= this.getGridStyleConfig(screenId).mRows * this.getGridStyleConfig(screenId).mColumns) {
        continue;
      }
      let item: AppItemInfo | undefined = this.getAppItemByIndex(i, page, screenId);
      if (!item) {
        log.showError(`oldCalculateSqueezePos failed. getAppItemByIndex failed at index ${i}, page ${page}`);
        this.mTranslateItemList = [];
        return;
      }
      let translateItem: TranslateItem = TranslateItem.fromAppItemInfo(item);
      let translatePosition: number[][] = [];
      let oldPosition: number[] =
        AppGridLayoutUtil.getGridItemPosition(item.row ?? 0, item.column ?? 0, item.page, screenId);
      let nextGridPos: number[] | undefined =
        this.mLayoutCacheManager.getNextPosition(isSqueezeBack, item.row, item.column);
      if (!nextGridPos) {
        log.showError('oldCalculateSqueezePos failed. find nextGridPos failed');
        this.mTranslateItemList = [];
        return;
      }
      let newPosition: number[] = AppGridLayoutUtil.getGridItemPosition(
        nextGridPos[0], nextGridPos[1], item.page, screenId);
      log.showInfo(`oldCalculateSqueezePos: offset ${item.bundleName} from (${item.row}, ${item.column}, ${item.page}) to (${nextGridPos[0]}, ${nextGridPos[1]}, ${item.page})`);
      translatePosition[0] = oldPosition;
      translatePosition[1] = newPosition;
      translateItem.newColumn = nextGridPos[1];
      translateItem.newRow = nextGridPos[0];
      translateItem.newPage = translateItem.page as number;
      translateItem.position = translatePosition;
      this.mTranslateItemList.push(translateItem);
    }
    log.showInfo(`oldCalculateSqueezePos end. mTranslateItemList.length: ${this.mTranslateItemList.length}`);
  }

  private startSqueeze(
    startItemPos: DragItemPosition, endItemPos: DragItemPosition, context?: UIContext, screenId?: number): boolean {
    if (!startItemPos || !endItemPos) {
      log.showWarn('startSqueeze illegal input params');
      return false;
    }
    if (!this.isAppCenterViewShow) {
      log.showWarn('no squeeze after exit app center');
      return false;
    }

    // 获取待移动的元素
    // 计算移动位置列表
    // 遍历列表，发送动画事件
    // 更新布局信息
    const atSamePage: boolean = startItemPos.page === endItemPos.page;
    this.updateEndPosIfDragToTailOrCrossPage(endItemPos, screenId);
    let startIndex: number = startItemPos.column + startItemPos.row * this.getGridStyleConfig(screenId).mColumns;
    let endIndex: number = endItemPos.column + endItemPos.row * this.getGridStyleConfig(screenId).mColumns;
    let isSqueezeBack: boolean = startIndex < endIndex;
    if (startIndex === endIndex && atSamePage) {
      log.showWarn('startSqueeze startIndex is same to endIndex');
      // 没挤位但在有效区，落位框放在下一个位置
      const grid: number[] = this.getGridPositionByIndex(endIndex, screenId);
      const position: number[] = AppGridLayoutUtil.getGridItemPosition(grid[0], grid[1], startItemPos.page, screenId);
      DragEventManager.getInstance().startSqueezedInDesktop(APP_CENTER_DROP_FRAME_KEY, [[], position]);
      return false;
    }
    log.showInfo(`startSqueeze start. startItemPos: ${AppGridLayoutUtil.appGridPosToString(startItemPos)},
    endItemPos: ${AppGridLayoutUtil.appGridPosToString(endItemPos)}`);
    this.mTranslateItemList = [];
    if (!atSamePage) {
      this.oldCalculateSqueezePos(startIndex,
        this.appGridList[startItemPos.page]?.pageInfo.length - 1, startItemPos.page, true, screenId);
      if (this.mLayoutCacheManager.isBlankPage(endItemPos.page)) {
        let oldPosition: number[] = AppGridLayoutUtil.getGridItemPosition(0, 0, undefined, screenId);
        DragEventManager.getInstance().startSqueezedInDesktop(APP_CENTER_DROP_FRAME_KEY, [oldPosition, oldPosition]);
        // 空白页，无需挤位
        return false;
      }
      startIndex = this.appGridList[endItemPos.page]?.pageInfo.length;
      isSqueezeBack = false;
    }
    this.oldCalculateSqueezePos(startIndex, endIndex, endItemPos.page, isSqueezeBack, screenId);
    if (this.mTranslateItemList.length === 0) {
      log.showError('startSqueeze failed');
      return false;
    }
    // 被拖拽元素也要位移动，可以不用动画
    let translateDragItem: TranslateItem = this.dragItemInfo as TranslateItem;
    let translatePosition: number[][] = [];
    let oldPosition: number[] =
      AppGridLayoutUtil.getGridItemPosition(this.mLastPosOnMoving?.row ?? 0, this.mLastPosOnMoving?.column ?? 0,
        this.mLastPosOnMoving?.page, screenId);
    let newPosition: number[] =
      AppGridLayoutUtil.getGridItemPosition(endItemPos.row, endItemPos.column, endItemPos.page, screenId);
    log.showInfo(`startSqueeze: dragItem oldPosition: ${AppGridLayoutUtil.appGridPosToString(startItemPos)},
    newPosition: ${AppGridLayoutUtil.appGridPosToString(endItemPos)}`);
    translatePosition[0] = oldPosition;
    translatePosition[1] = newPosition;
    translateDragItem.newColumn = endItemPos.column;
    translateDragItem.newRow = endItemPos.row;
    translateDragItem.position = translatePosition;
    translateDragItem.newPage = this.mDragPageIndex;
    // 可能存在连续多次位移, 若有翻页，需要加上翻页的位移
    this.dragItemTranslationX += (translatePosition[1][0] - translatePosition[0][0]);
    this.dragItemTranslationY += (translatePosition[1][1] - translatePosition[0][1]);
    this.mTranslateItemList.push(translateDragItem);
    this.backupMovedItemList();
    let t = Date.now();
    log.showInfo(`Squeeze app anim start-${t}-${this.mTranslateItemList.length}`);
    this.mTranslateItemList.forEach((item: TranslateItem) => {
      if (!item.isRepeatItem) {
        log.showInfo(`${item.bundleName} squeeze from r:${item.row}-c:${item.column} to r:${item.newRow}-c:${item.newColumn}`);
        DragEventManager.getInstance().startSqueezedInDesktop(this.getItemEventKey(item), item.position);
        DragEventManager.getInstance().startSqueezedInDesktop(APP_CENTER_DROP_FRAME_KEY, item.position);
      }
    });
    log.showInfo(`startSqueeze success. time: ${t}, mTranslateItemList.length: ${this.mTranslateItemList.length}, movingItemMap.size: ${this.movingItemMap.size}, movingCacheItemMap.size: ${this.movingItemMapForFullPage.size}, mLastPosOnMoving: (${this.mLastPosOnMoving?.row}, ${this.mLastPosOnMoving?.column}, ${this.mLastPosOnMoving?.page})`);
    return true;
  }

  private backupMovedItemList(): void {
    log.showInfo(`backupMovedItemList: ${this.mTranslateItemList?.length}-${this.mLastTranslateItemList?.length}`);
    if (CheckEmptyUtils.isEmptyArr(this.mTranslateItemList)) {
      return;
    }
    for (let index = 0; index < this.mTranslateItemList.length; index++) {
      const key: string = this.getItemEventKey(this.mTranslateItemList[index]);
      if (!this.movingItemMap.has(key)) {
        this.movingItemMap.set(key, this.mTranslateItemList[index]);
        this.mLastTranslateItemList.push(this.mTranslateItemList[index]);
      } else {
        // 已经存在，更新元素
        let item = this.movingItemMap.get(key) as TranslateItem;
        item.page = this.mTranslateItemList[index].page;
        item.column = this.mTranslateItemList[index].column;
        item.row = this.mTranslateItemList[index].row;
        item.newPage = this.mTranslateItemList[index].newPage;
        item.newColumn = this.mTranslateItemList[index].newColumn;
        item.newRow = this.mTranslateItemList[index].newRow;
      }
    }
    log.showInfo(`backupMovedItemList after backup: ${this.mLastTranslateItemList?.length}`);
  }

  protected resetLastItemList(reason: number): void {
    log.showInfo(`resetLastItemList: ${reason}-${this.mLastTranslateItemList?.length}, movingItemMapForFullPage.size: ${this.movingItemMapForFullPage.size}`);
    const hasAnim: boolean = this.movingItemMapForFullPage.size > 0 ? false : this.hasCancelSqueezeAnimation;
    this.mLastTranslateItemList?.forEach((item: TranslateItem) => {
      log.showInfo(`resetLastItemList item: ${this.getItemEventKey(item)} ${hasAnim}`);
      DragEventManager.getInstance().cancelSqueezedInDesktop(this.getItemEventKey(item), hasAnim);
    });
    this.doResetLastItemList();
  }

  protected doResetLastItemList(): void {
    this.mLastTranslateItemList = [];
    this.movingItemMap.clear();
    this.dragItemTranslationX = 0;
    this.dragItemTranslationY = 0;
  }

  /**
   * 更新挤位元素的位置到缓存中
   */
  private updateMoveList(updateLocal: boolean = false): void {
    log.showInfo(`updateMoveList: updateLocal: ${updateLocal}， length ${this.mLastTranslateItemList?.length}`);
    let itemInfoList: AppItemInfo[] = [];
    this.mLastTranslateItemList?.forEach((item: TranslateItem) => {
      log.showInfo(`updateMoveList move item from: ${AppGridLayoutUtil.appGridItemToString(item)}`);
      // 更新位置
      item.column = item.newColumn;
      item.row = item.newRow;
      item.page = item.newPage;
      log.showInfo(`updateMoveList move item to: ${AppGridLayoutUtil.appGridItemToString(item)}`);
      itemInfoList.push(item as Object as AppItemInfo);
    })
    if (updateLocal && itemInfoList.length > 0) {
      this.appGridListChanged = true;
    }
    let ret: boolean = AppGridLayoutCacheManager.getInstance()
      .updateItemPositionById(itemInfoList, updateLocal ? this.appGridList : undefined);
    if (ret) {
      log.showInfo('updateMoveList success');
    } else {
      log.showError('updateMoveList failed');
    }
  }

  protected getItemEventKey(item: AppItemInfo | TranslateItem | undefined): string {
    if (item) {
      item.typeId = CommonConstants.TYPE_APP;
      return 'AppGrid_' + GridLayoutUtil.generateUniqueKey(item as GridLayoutItemInfo);
    }
    return '';
  }

  /**
   * 判断是否跨页且不可落位
   */
  private checkIfCrossPageAndInvalid(): boolean {
    if (!this.mStartPosition) {
      return false;
    }
    return (!this.mEndPosition || !this.mLastPosOnMoving) && this.mStartPosition.page !== this.mDragPageIndex;
  }

  /**
   * 判断当前拖拽元素是否跨越了宫格
   * @returns
   */
  private isStatusChange(x: number, y: number): boolean {
    if (!this.mLastPosOnMoving || !this.mEndPosition) {
      log.showInfo(`isStatusChange item pos on mEndPosition: ${this.mEndPosition} not legal`);
      return false;
    }
    const curIsSpeedValid: boolean = this.calculateSpeed(x, y);
    //拖拽元素落点变化
    if (this.mLastPosOnMoving.row !== this.mEndPosition.row ||
      this.mLastPosOnMoving.column !== this.mEndPosition.column ||
      this.mLastPosOnMoving.page !== this.mEndPosition.page) {
      log.showInfo('isStatusChange， current grid change');
      this.isSpeedValid = curIsSpeedValid;
      return true;
    }
    if (!curIsSpeedValid) {
      log.showInfo('isStatusChange curIsSpeedValid is false');
      return false;
    }

    // 当落点无变化但速度变为有效时触发挤位
    if (this.needTriggerSqueeze() && curIsSpeedValid && !this.isSqueezing) {
      this.isSpeedValid = curIsSpeedValid;
      log.showInfo('isStatusChange curIsSpeedValid');
      return true;
    }
    log.showInfo(`isStatusChange return false. mLastPosOnMoving: (${this.mLastPosOnMoving.row}, ${this.mLastPosOnMoving.column}, ${this.mLastPosOnMoving.page}), mEndPosition: (${this.mEndPosition.row}, ${this.mEndPosition.column}, ${this.mEndPosition.page}), curIsSpeedValid: ${curIsSpeedValid}`);
    return false;
  }

  protected needTriggerSqueeze(): boolean {
    return !this.isSpeedValid;
  }

  protected calculateSpeed(x: number, y: number): boolean {
    // calculate the move speed
    const nowTime = Date.now();
    const speed = Math.hypot(x - this.lastDragX, y - this.lastDragY) / (nowTime - this.lastDragTime);
    log.showInfo(`calculateSpeed x: %{public}d, y: %{public}d, lastDragY: %{public}d, lastDragX: %{public}d,
      nowTime: %{public}s, lastDragTime: %{public}s, speed: %{public}d`, x, y, this.lastDragY, this.lastDragX, nowTime, this.lastDragTime, speed);
    this.lastDragX = x;
    this.lastDragY = y;
    this.lastDragTime = nowTime;
    if (typeof speed === 'number' && speed < this.minMoveSpeed) {
      // 过滤拖拽速度在挤位阈值上下波动的场景
      this.speedValidCount++;
      return this.speedValidCount >= this.minValidCount;
    }
    this.speedValidCount = 0;
    return false;
  }

  protected getAppItemByIndex(index: number, page: number, screenId: number = 0): AppItemInfo | undefined {
    log.showInfo(`getAppItemByIndex start. index: ${index}, page: ${page}, screenId: ${screenId}`);
    let row: number = Math.floor(index / this.getGridStyleConfig(screenId).mColumns);
    let column: number = Math.floor(index % this.getGridStyleConfig(screenId).mColumns);
    if (!this.appGridList || page >= this.appGridList.length || page < 0) {
      log.showError(`getAppItemByIndex failed. Invalid appLayoutInfo: ${this.appGridList?.length}`);
      return undefined;
    }
    const result: AppItemInfo | undefined = this.appGridList[page]?.pageInfo?.find((item: AppItemInfo) => {
      log.showInfo(`getAppItemByIndex， find row ${item.row}, column ${item.column}, page ${item.page}, bundleName ${item.bundleName}`);
      return item.page === page && item.row === row && item.column === column;
    });
    log.showInfo(`getAppItemByIndex end. find ${result?.bundleName} at pos: (${row}, ${column}, ${page})`);
    return result;
  }

  protected getGridPositionByIndex(index: number, screenId: number = 0): number[] {
    let row: number = Math.floor(index / this.getGridStyleConfig(screenId).mColumns);
    let column: number = Math.floor(index % this.getGridStyleConfig(screenId).mColumns);
    return [row, column];
  }

  protected getCurrentGridPos(x: number, y: number, page?: number, screenId: number = 0): DragItemPosition | undefined {
    // 需要先判断该x,y值是否在应用中心工作区
    if (!this.isInAppCenterWorkBench(x, y, screenId)) {
      log.showInfo(`getCurrentGridPos， not isInAppCenterWorkBench x: ${x}, y: ${y}`);
      return undefined;
    }
    let dragGridPos: DragGridPosition | undefined = AppGridLayoutUtil.getRowAndColumn(x, y, page, screenId);
    if (!dragGridPos) {
      log.showInfo(`getCurrentGridPos， getRowAndColumn invalid, x: ${x}, y: ${y}`);
      return undefined;
    }
    let dragItemPos: DragItemPosition = {
      column: dragGridPos.column,
      row: dragGridPos.row,
      page: this.mDragPageIndex,
      x: x,
      y: y
    };
    log.showInfo(`getCurrentGridPos r:${dragItemPos.row}-c:${dragItemPos.column}-p:${this.mDragPageIndex}`);
    return dragItemPos;
  }

  protected getCurrentGridPosForMove(
    x: number, y: number, page?: number, screenId?: number): DragItemPosition | undefined {
    // 需要先判断该x,y值是否在应用中心工作区
    if (!this.isInAppCenterWorkBench(x, y, screenId)) {
      log.showInfo(`getCurrentGridPosForMove， not isInAppCenterWorkBench x: ${x}, y: ${y}`);
      return undefined;
    }
    let dragGridPos: DragGridPosition | undefined = AppGridLayoutUtil.getRowAndColumn(x, y, page, screenId);
    if (!dragGridPos) {
      log.showInfo(`getCurrentGridPosForMove， getRowAndColumn invalid, x: ${x}, y: ${y}`);
      return undefined;
    }
    let dragItemPos: DragItemPosition = {
      column: dragGridPos.column,
      row: dragGridPos.row,
      page: this.mDragPageIndex,
      x: x,
      y: y
    };
    log.showInfo(`getCurrentGridPosForMove r:${dragItemPos.row}-c:${dragItemPos.column}-p:${this.mDragPageIndex} by (${x}, ${y})`);
    return dragItemPos;
  }

  protected isInAppCenterWorkBench(x: number, y: number, screenId: number = 0): boolean {
    log.info(`isInAppCenterWorkBench screenId: ${screenId}`)
    if (screenId === 0) {
      return (this.appGridRect !== undefined &&
        x >= this.appGridRect.left &&
        x <= this.appGridRect.right &&
        y >= this.appGridRect.top &&
        y <= this.appGridRect.bottom);
    } else {
      return (this.extAppGridRect !== undefined &&
        x >= this.extAppGridRect.left &&
        x <= this.extAppGridRect.right &&
        y >= this.extAppGridRect.top &&
        y <= this.extAppGridRect.bottom);
    }
  }

  protected initAppGridRect(screenId: number = 0): void {
    log.info(`initAppGridRect screenId: ${screenId}`)
    if (screenId === 0) {
      this.appGridRect = new RectInfo();
      this.appGridRect.left = this.mGridStyleConfig.mAppCenterMarginLeft;
      this.appGridRect.top = this.mGridStyleConfig.mAppCenterMarginTop;
      this.appGridRect.right = this.mGridStyleConfig.mAppCenterMarginLeft + this.mGridStyleConfig.mGridWidth;
      this.appGridRect.bottom = this.mGridStyleConfig.mAppCenterMarginTop + this.mGridStyleConfig.mGridHeight;
    } else {
      this.extAppGridRect = new RectInfo();
      this.extAppGridRect.left = this.mExtGridStyleConfig.mAppCenterMarginLeft;
      this.extAppGridRect.top = this.mExtGridStyleConfig.mAppCenterMarginTop;
      this.extAppGridRect.right = this.mExtGridStyleConfig.mAppCenterMarginLeft + this.mExtGridStyleConfig.mGridWidth;
      this.extAppGridRect.bottom = this.mExtGridStyleConfig.mAppCenterMarginTop + this.mExtGridStyleConfig.mGridHeight;
    }
  }

  public getStartDragPage(): number | undefined {
    return this.mStartPosition?.page;
  }

  public getDraggingPageIndex(): number {
    return this.mDragPageIndex;
  }

  public getStartDragPos(screenId?: number): number[] {
    if (!this.mStartPosition) {
      return [0, 0];
    }
    return AppGridLayoutUtil.getGridItemPosition(this.mStartPosition?.row, this.mStartPosition?.column,
      this.mStartPosition?.page, screenId);
  }

  public getCurrentIsInAppCenterWorkBench(screenId?: number): boolean {
    const currentIsInAppCenterWorkBench: boolean = this.isInAppCenterWorkBench(
      this.currentMouseX, this.currentMouseY, screenId);
    log.showInfo(`getCurrentIsInAppCenterWorkBench: ${currentIsInAppCenterWorkBench}`);
    return currentIsInAppCenterWorkBench;
  }

  public setDragCrossScreen(crossScreen: boolean = true): void {
  }

  public getDragCrossScreen(): boolean {
    return false;
  }

  public setDraggingCrossScreen(draggingCrossScreen: boolean = true): void {
  }

  public setCrossFullPage(crossFullPage: boolean = false): void {
  }

  protected getGridStyleConfig(screenId: number = 0): AppCenterGridStyleConfig {
    if (screenId === 0) {
      return this.mGridStyleConfig;
    } else {
      return this.mExtGridStyleConfig;
    }
  }
}

export class TranslateItem extends AppItemInfo {
  public isRepeatItem = false;
  public position: number[][] = [];
  public newColumn: number = 0;
  public newRow: number = 0;
  public newPage: number = 0;

  public static fromAppItemInfo(itemInfo: AppItemInfo): TranslateItem {
    let newInstance: TranslateItem = new TranslateItem();
    newInstance.abilityName = itemInfo.abilityName;
    newInstance.bundleName = itemInfo.bundleName;
    newInstance.applicationName = itemInfo.applicationName;
    newInstance.appIndex = itemInfo.appIndex;
    newInstance.badgeNumber = itemInfo.badgeNumber;
    newInstance.page = itemInfo.page;
    newInstance.column = itemInfo.column;
    newInstance.row = itemInfo.row;
    newInstance.typeId = itemInfo.typeId;
    return newInstance;
  }
}