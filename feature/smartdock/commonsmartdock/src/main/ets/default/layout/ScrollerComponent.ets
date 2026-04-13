/**
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

import { LogDomain, LogHelper, CheckEmptyUtils, RectInfo, SingleContext } from '@ohos/basicutils';
import {
  GlobalContext,
  IconResourceManager,
  HiSysEventUtil,
  ResourceManager,
  viewMgrPolicy,
  StartAppFromPopupParams,
  ReportParams,
  ViewType
} from '@ohos/frameworkwrapper';
import {
  SCBSceneSessionManager,
  SCBSceneContainerSession,
  SceneInfoAdapterUtil,
  SCBSceneResourceManager,
} from '@ohos/windowscene';
import { ItemUtils } from '@ohos/componenthelper';
import {
  AppModel,
  AppItemInfo,
  StyleConstants,
  SnapshotInfo,
  DesktopFontScaleState,
  desktopFontScaleManager,
  DockContinuableInfo,
  SCBHiSysEventUtil,
  HiSysContinueFuncResult,
  CommonConstants
} from '@ohos/launchercommon';
import measure from '@ohos.measure';
import animator from '@ohos.animator';
import image from '@ohos.multimedia.image';
import { LazyDataSource } from '@ohos/launchercommon/Index';
import SmartDockModel from '../model/SmartDockModel';
import { FixedDockResource, PreviewScrollState } from '../common/constants/PcModeDockConstants';
import type { SessionLabelListener } from '@ohos/windowscene';
import { DockHiSysEventMgr } from '../manager/DockHiSysEventMgr';
import SmartDockConstants from '../common/constants/SmartDockConstants';
import RecentDockModel from '../model/RecentDockModel';

let scrollerComponentTimer: number | null = null;
let moveToFrontDelayTimer: number | null = null;
const TAG = 'ScrollerComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PcModeDock-' + TAG);

const CONTINUE_ABILITY = 'continueAbility';
const CONTINUE_IMAGE_HEIGHT = 36;

@Component
export struct ScrollerComponent {
  @Prop singleContext?: SingleContext;
  private player = animator.create({
    duration: 250,
    easing: 'friction',
    begin: 0,
    end: 1,
    delay: 0,
    iterations: 1,
    fill: 'forwards',
    direction: 'normal'
  })
  private popupHide: Function = (): void => {
  };
  private updateData: Function = (): void => {
  };
  private popupOffsetUpdate: Function = (): void => {
  };
  private leftArrowPicPath: string = FixedDockResource.PREVIEW_ARROW_LEFT;
  private rightArrowPicPath: string = FixedDockResource.PREVIEW_ARROW_RIGHT;
  private closePicPath: string = FixedDockResource.PREVIEW_CLOSE_NORMAL;
  private mPopItem: AppItemInfo = new AppItemInfo();
  private mSmartDockModel: SmartDockModel = SmartDockModel.getInstance(this.singleContext);
  private mMaxWidth = 0;
  @State mCurrentBoxWidth: number = 0;
  private mMaxBoxWidth = 0;
  private mScroller: Scroller = new Scroller();
  private hoverFlag: boolean = false;
  private previewScrollState: PreviewScrollState = PreviewScrollState.NORMAL;
  private isDragging: boolean = false;
  private fontSize: number = StyleConstants.DEFAULT_14;
  @State isLeftArrowClickable: boolean = false;
  @State isRightArrowClickable: boolean = true;
  @StorageLink('snapshotList') @Watch('onSnapshotListChange') mSnapshotList: SnapshotInfo[] = [];
  @StorageProp('screenWidth') screenWidth: number = 0;
  @StorageProp('screenHeight') screenHeight: number = 0;
  @State dataList: SnapshotInfo[] = [];
  @State data: LazyDataSource<SnapshotInfo> = new LazyDataSource<SnapshotInfo>();
  @State missionId: number = -1;
  @State isLeftArrowShow: boolean = false;
  @State isRightArrowShow: boolean = false;
  @State isArrowShow: boolean = false;
  @State leftArrowBackgroundColor: Resource | null = null;
  @State rightArrowBackgroundColor: Resource | null = null;
  @State leftArrowOpacity: Resource | number = 1;
  @State rightArrowOpacity: Resource | number = 1;
  @State closePicBackgroundColor: Resource | null = null;
  @State currentWidth: number = 0;
  @State hoverNum: number = 0;
  @State hoverScale: number = 0;
  @State isHover?: boolean = false;
  @State maxCards: number = 0;
  @State appName: string = '';
  @State isOpen: boolean = false;
  @State baseNum: number = 0;
  @State isBig: boolean = false;
  @State isScale: boolean = false;
  @State isRunning: boolean = false;
  @State continuableItemBgColor: string = FixedDockResource.LIGHT_CONTINUABLE_PREVIEW_BG_COLOR;
  @State fontScaleState: DesktopFontScaleState = desktopFontScaleManager.getSysFontScaleState();
  @Prop @Watch('onContinueDeviceChange') deviceInfo: DockContinuableInfo = new DockContinuableInfo();
  //深色模式colorMode：0， 浅色模式colorMode：1
  @StorageLink('currColorMode') @Watch('onColorModeChange') currColorMode: number =
    GlobalContext.getContext().config.colorMode as number;

  private onColorModeChange(): void {
    if (this.currColorMode === ColorMode.DARK) {
      this.continuableItemBgColor = FixedDockResource.LIGHT_CONTINUABLE_PREVIEW_BG_COLOR;
    } else {
      this.continuableItemBgColor = FixedDockResource.DARK_CONTINUABLE_PREVIEW_BG_COLOR;
    }
  }

  private onContinueDeviceChange(): void {
    const isContinueItemExist: boolean = RecentDockModel.getInstance().continuableItemExists(this.deviceInfo);
    const index = this.dataList.findIndex((info: SnapshotInfo) => info.bundleName === CONTINUE_ABILITY);
    log.showInfo(`onContinueDeviceChange isContinueItemExist: ${isContinueItemExist}, index: ${index}`);
    if (!isContinueItemExist && index >= 0) {
      this.dataList.splice(index, 1);
      this.data.deleteItemByIndex(index);
      this.data.notifyDataReload();
      this.updateWidthAndArrow();
    }
    if (isContinueItemExist && index === -1) {
      this.onSnapshotListChange();
    }
  }

  private isContinueMerged(): boolean {
    return this.deviceInfo.bundleName === this.mPopItem?.bundleName && (this.mPopItem.appIndex ?? 0) === 0;
  }

  private checkIsAddContinuableItem(): void {
    // 预览窗列表为空时不添加, 避免接续预览窗重新刷新
    if (!this.isContinueMerged() || !this.isRunning || this.dataList.length === 0) {
      return;
    }
    log.showInfo('addContinuableItemData');
    let snapshot: SnapshotInfo = new SnapshotInfo();
    snapshot.left = StyleConstants.DEFAULT_12;
    snapshot.missionId = -1;
    snapshot.boxSize = StyleConstants.DEFAULT_SMART_DOCK_MISSION_IMAGE_WIDTH;
    snapshot.bundleName = CONTINUE_ABILITY;
    snapshot.shortcutId = this.mPopItem.shortcutId;
    this.dataList.push(snapshot);
  }

  private loadData(): void {
    this.checkIsAddContinuableItem();
    log.showInfo(`${this.mPopItem.bundleName} loadData start ${this.dataList.length}`);
    this.previewScrollState = PreviewScrollState.NORMAL;
    this.isArrowShow = false;
    this.isLeftArrowClickable = false;
    this.isRightArrowClickable = true;
    this.data.clear();
    let sumBoxWidth = 0;
    for (let index = this.baseNum; index < this.dataList.length; index++) {
      if (this.dataList[index]) {
        this.data.insertItem(this.dataList[index], index);
        sumBoxWidth += this.getSnapshotWidth(this.dataList[index]) + FixedDockResource.SNAPSHOT_GAP;
        if (sumBoxWidth + FixedDockResource.SNAPSHOT_GAP / 2 > this.mMaxBoxWidth) {
          break;
        }
      } else {
        log.showError(`loadData dataList[${index}] is invalid!`);
      }
    }
    this.data.notifyDataReload();
    log.showInfo(`${this.mPopItem.bundleName} loadData end ${this.dataList.length} ${this.data.totalCount()}`);
  }

  private calculatePopupOffsetX(): void {
    let position: Position = {
      x: 0,
      y: 0,
    };
    let iconRect: RectInfo = ItemUtils.getRectById(AppModel.getInstance().getAppIconContainerId(
      'SmartDock_AppIcon', this.mPopItem.bundleName as string, this.mPopItem.abilityName as string, this.mPopItem.appIndex as number));
    let scrollerComponentWidth = this.currentWidth > this.mMaxWidth ? this.mMaxWidth : this.currentWidth;
    /* popup优先在用户设置的位置展示
     如果该位置会导致popup距离屏幕边缘小于8vp，就认为显示不下，就会通过避障算法调整位置，默认在屏幕边缘8vp，基于边缘8vp设置偏移量。
     不超边界不调整位置
     */
    let iconMiddleX: number = iconRect.left + (iconRect.width ?? 0) / 2.0;
    let scHalfWidth: number = scrollerComponentWidth / 2.0;
    let margin: number = FixedDockResource.PREVIEW_SCREEN_PADDING;
    // 8vp，arkui之popup的规格
    let defaultMargin: number = 8;
    log.showDebug(
      `${this.screenWidth},[${iconRect.left},${iconRect.top},${iconRect.right},${iconRect.bottom}],${scHalfWidth}`);

    if (iconMiddleX - scHalfWidth > margin && this.screenWidth - iconMiddleX - scHalfWidth > margin) {
      return;
    }

    if (iconMiddleX - scHalfWidth < defaultMargin) {
      // 距离左边缘小于8vp，触发arkui避障
      position.x = margin - defaultMargin;
    } else if (iconMiddleX - scHalfWidth < margin) {
      // 未超出左边界，但是距离左边界小于24vp
      position.x = margin - iconMiddleX + scHalfWidth;
    } else if (this.screenWidth - iconMiddleX - scHalfWidth < defaultMargin) {
      // 距离右边缘小于8vp，触发arkui避障
      position.x = defaultMargin - margin;
    } else if (this.screenWidth - iconMiddleX - scHalfWidth < margin) {
      // 未超出右边界，但是距离右边界小于24vp
      position.x = this.screenWidth - iconMiddleX - scHalfWidth - margin;
    }
    this.popupOffsetUpdate(position);
    log.showInfo(`${this.mPopItem.bundleName} calculatePopupOffsetX end:${position?.x}`);
  }

  private updateName(): void {
    if (CheckEmptyUtils.isEmpty(this.appName)) {
      if (this.mPopItem?.typeId === CommonConstants.TYPE_SHORTCUT_ICON || !!this.mPopItem?.shortcutId &&
        !CheckEmptyUtils.isEmpty(this.mPopItem?.appName)) {
        this.setAppNameWithCacheCallback(this.mPopItem?.appName);
        return;
      }
      ResourceManager.getInstance().getAppNameWithCache(this.mPopItem?.appLabelId, this.mPopItem?.bundleName,
        this.mPopItem?.moduleName, '', (name: string): void => this.setAppNameWithCacheCallback(name));
    }
  }

  private setAppNameWithCacheCallback(name: string) {
    this.appName = name;
    log.showDebug(`updateName end: ${name}`);
  }

  private onSnapshotListChange(): void {
    log.showInfo(`${this.mPopItem.bundleName} snapshotListChange start:${this.mSnapshotList.length}`);
    if (this.mSnapshotList.length === 0) {
      log.showInfo(`onSnapshotListChange return. snapshotList has been cleared`);
      return;
    }
    this.dataList = ([] as SnapshotInfo[]).concat(this.mSnapshotList as SnapshotInfo[]);
    if (!CheckEmptyUtils.isEmptyArr(this.mSnapshotList)) {
      return;
    }
    this.baseNum = 0;
    this.updateIsRunning();
    this.loadData();
    this.updateWidthAndArrow();
    this.calculatePopupOffsetX();
    log.showInfo(`${this.mPopItem.bundleName} snapshotListChange end:${this.dataList.length}`);
  }

  private updateIsRunning(): void {
    this.isRunning = this.mSmartDockModel.checkAppIsRunning(this.mPopItem);
    log.showDebug(`${this.mPopItem?.bundleName} isRunning: ${this.isRunning}`);
  }

  private addOneMoreItemIfNeed(sumBoxWidth: number): void {
    if (sumBoxWidth <= this.mMaxBoxWidth) {
      if (this.dataList[this.baseNum + this.data.totalCount()]) {
        this.data.insertItem(this.dataList[this.baseNum + this.data.totalCount()], this.data.totalCount());
        log.showInfo('add one more item from right');
      } else if (this.dataList[this.baseNum - 1]) {
        this.data.insertItem(this.dataList[this.baseNum - 1], 0);
        log.showInfo('add one more item from left');
      } else {
        log.showWarn('no available item can be added');
      }
    }
  }

  private updateWidthAndArrow(): void {
    log.showInfo(
      `updateWidthAndArrow start: ${this.mPopItem.bundleName} ${this.currentWidth} ${this.mCurrentBoxWidth}`);
    if (CheckEmptyUtils.isEmptyArr(this.dataList)) {
      this.currentWidth = 0;
      return;
    }

    let sumBoxWidth = 0;
    for (let index = 0; index < this.data.totalCount(); index++) {
      const mission = this.data.getData(index);
      if (mission) {
        sumBoxWidth += this.getSnapshotWidth(mission) + FixedDockResource.SNAPSHOT_GAP;
      } else {
        log.showError(`updateCurrentWidth error, dataList[${index}] is invalid!`);
      }
    }

    if (sumBoxWidth > this.mMaxBoxWidth || this.data.totalCount() < this.dataList.length) {
      this.addOneMoreItemIfNeed(sumBoxWidth);
      sumBoxWidth = this.mMaxBoxWidth;
      this.isArrowShow = true;
    } else {
      this.isArrowShow = false;
    }
    this.mCurrentBoxWidth = sumBoxWidth;

    if (this.isArrowShow) {
      this.currentWidth = this.mCurrentBoxWidth + FixedDockResource.PREVIEW_MARGIN_WHEN_HAS_ARROW * 2;
    } else {
      this.currentWidth = this.mCurrentBoxWidth + FixedDockResource.PREVIEW_MARGIN_WHEN_NO_ARROW;
    }
    log.showInfo(`updateWidthAndArrow end: ${this.mPopItem.bundleName} ${this.currentWidth} ${this.mCurrentBoxWidth}`);
  }

  private getWidth(): number {
    if (this.currentWidth > this.mMaxWidth) {
      return this.mMaxWidth;
    } else {
      return this.currentWidth;
    }
  }

  private setLeftData(isClickClose: boolean): void {
    let baseI: number = isClickClose ? 0 : 1;
    let curBoxWidth: number = 0;
    for (let i: number = 0; i < this.data.totalCount() - baseI; i++) {
      curBoxWidth += (this.getSnapshotWidth(this.data.getData(i)) + 24);
    }
    const startIndex = this.baseNum - 1;
    let isSetEnough: boolean = false;
    for (let index = startIndex; index >= 0; index--) {
      const mission = this.dataList[index];
      if (mission) {
        log.showInfo(`setLeftData insert ${index}`);
        this.baseNum--;
        this.data.insertItem(this.dataList[index], 0);
        curBoxWidth += (this.getSnapshotWidth(mission) + FixedDockResource.SNAPSHOT_GAP);
        if (curBoxWidth + FixedDockResource.SNAPSHOT_GAP / 2 > this.mMaxBoxWidth) {
          isSetEnough = true;
          break;
        }
      }
    }

    if (!isClickClose && isSetEnough) {
      this.data.deleteItemByIndex(this.data.totalCount() - 1);
      log.showInfo(`enouhgh, delete the last item, baseNum: ${this.baseNum}`);
    }
    this.updateWidthAndArrow();
    this.forceScrollToStart();
    this.isRightArrowClickable = true;
  }

  private forceScrollToStart(): void {
    if (this.baseNum === 0) {
      log.showInfo('forceScrollToStart: force scroll to start');
      this.mScroller.scrollEdge(Edge.Start);
      this.isLeftArrowClickable = false;
    }
  }

  private moveToLeft(): void {
    if (!this.isArrowShow || !this.isLeftArrowClickable) {
      log.showInfo('can not move to left!');
      return;
    }
    log.showInfo(
      `left start ${this.mPopItem.bundleName}, ${this.dataList.length} ${this.data.totalCount()} ${this.baseNum}`);
    if (this.dataList.length === this.data.totalCount()) {
      log.showInfo('datalist and data is same, force scroll to start');
      this.mScroller.scrollEdge(Edge.Start);
      this.isRightArrowClickable = true;
      this.isLeftArrowClickable = false;
      return;
    }
    animateTo({ curve: Curve.Friction, duration: 250 }, () => {
      this.setLeftData(false);
    });
    log.showInfo(
      `left end ${this.mPopItem.bundleName}, ${this.dataList.length} ${this.data.totalCount()} ${this.baseNum}`);
  }

  private forceScrollToEnd(): void {
    if (this.baseNum + this.data.totalCount() === this.dataList.length) {
      log.showInfo('forceScrollToEnd: force scroll to end');
      this.mScroller.scrollEdge(Edge.End);
      this.isRightArrowClickable = false;
    }
  }

  private setRightData(isClickClose: boolean): void {
    let baseI: number = isClickClose ? 0 : 1;
    let curBoxWidth: number = 0;
    for (let i: number = baseI; i < this.data.totalCount(); i++) {
      curBoxWidth += (this.getSnapshotWidth(this.data.getData(i)) + 24);
    }
    const startIndex = this.baseNum + this.data.totalCount();
    let isSetEnough: boolean = false;
    for (let index = startIndex; index < this.dataList.length; index++) {
      const mission = this.dataList[index];
      if (mission) {
        log.showInfo(`setRightData insert ${index}`);
        this.data.insertItem(this.dataList[index], this.data.totalCount());
        curBoxWidth += (this.getSnapshotWidth(mission) + FixedDockResource.SNAPSHOT_GAP);
        if (curBoxWidth + FixedDockResource.SNAPSHOT_GAP / 2 > this.mMaxBoxWidth) {
          isSetEnough = true;
          break;
        }
      }
    }

    if (!isClickClose && isSetEnough) {
      this.data.deleteItemByIndex(0);
      this.baseNum++;
      log.showInfo(`enouhgh, delete the first item, baseNum: ${this.baseNum}`);
    }
    this.updateWidthAndArrow();
    this.forceScrollToEnd();
    this.isLeftArrowClickable = true;
  }

  private moveToRight(): void {
    if (!this.isArrowShow || !this.isRightArrowClickable) {
      log.showInfo('can not move to right!');
      return;
    }
    log.showInfo(
      `right start ${this.mPopItem.bundleName}, ${this.dataList.length} ${this.data.totalCount()} ${this.baseNum}`);
    if (this.dataList.length === this.data.totalCount()) {
      log.showInfo('datalist and data is same, force scroll to end');
      this.mScroller.scrollEdge(Edge.End);
      this.isRightArrowClickable = false;
      this.isLeftArrowClickable = true;
      return;
    }

    animateTo({ curve: Curve.Friction, duration: 250 }, () => {
      this.setRightData(false);
    });
    log.showInfo(
      `right end ${this.mPopItem.bundleName}, ${this.dataList.length} ${this.data.totalCount()} ${this.baseNum}`);
  }

  private getScreenId(sceneSession: SCBSceneContainerSession, missionId: number): number {
    let screenId: number;
    if (missionId === sceneSession.primarySession?.session?.persistentId) {
      screenId = sceneSession.primarySession?.sceneInfo?.screenId as number;
    } else {
      screenId = sceneSession.secondarySession?.sceneInfo?.screenId as number;
    }
    return screenId;
  }

  private getPersistentId(sceneSession: SCBSceneContainerSession, missionId: number): number {
    let persistentId: number;
    if (missionId === sceneSession.primarySession?.session?.persistentId) {
      persistentId = sceneSession.primarySession?.sceneInfo?.persistentId as number;
    } else {
      persistentId = sceneSession.secondarySession?.sceneInfo?.persistentId as number;
    }
    return persistentId;
  }

  private close(sceneSession: SCBSceneContainerSession, missionId: number): void {
    if (!sceneSession) {
      return;
    }
    let screenId: number = this.getScreenId(sceneSession, missionId);
    SCBSceneSessionManager.getInstance().asyncPrepareTerminate(missionId, (err, isPrepareTerminate) => {
      if (isPrepareTerminate) {
        log.showInfo('deleteRecentSession isPrepareTerminate');
        return;
      }
      try {
        SCBSceneSessionManager.getInstance().close(screenId, missionId);
      } catch (error) {
        log.showError(`close error= ${error}`);
        return;
      }
    });
  }

  private moveToFront(sceneSession: SCBSceneContainerSession, missionId: number): void {
    if (!sceneSession) {
      return;
    }
    log.showInfo(`moveToFront ${sceneSession.primarySession?.sceneInfo.bundleName}`);
    let screenId: number = this.getScreenId(sceneSession, missionId);
    let persistentId: number = this.getPersistentId(sceneSession, missionId);
    SCBSceneSessionManager.getInstance().startSceneFromRecent(screenId, persistentId, sceneSession.containerId);
    SCBSceneSessionManager.getInstance().requestFocus(persistentId, false);
  }

  private clearMoveToFrontDelayTimer(): void {
    if (moveToFrontDelayTimer) {
      clearTimeout(moveToFrontDelayTimer);
      moveToFrontDelayTimer = null;
    }
  }

  private moveToFrontWithDelay(sceneSession: SCBSceneContainerSession, missionId: number, delay: number): void {
    this.clearMoveToFrontDelayTimer();
    moveToFrontDelayTimer = setTimeout(() => {
      if (missionId === this.missionId && AppStorage.get('isHoverSnapshot') as boolean &&
      this.isDragging) {
        this.popupHide?.();
        this.hoverFlag = false;
        AppStorage.setOrCreate('isHoverSnapshot', false);
        this.isDragging = false;
        ContextMenu.close();
        this.moveToFront(sceneSession, missionId);
        this.clearMoveToFrontDelayTimer();
      }
      log.showInfo(`${this.mPopItem?.bundleName} moveToFront missionId: ${missionId} ${this.missionId}`);
    }, delay);
  }

  private getAppNameTextWidth(appName: string): number | string {
    let width: number | string = FixedDockResource.POPUP_MIN_TEXT_WIDTH;
    if (CheckEmptyUtils.checkStrIsEmpty(appName)) {
      return width;
    }
    const maxWidth: number = this.screenWidth * 2 / 3;
    width = this.getTextWidth(appName, width, maxWidth);
    return width;
  }

  private getAppNameTextHeight(appName: string): number | string {
    let height: number | string = FixedDockResource.POPUP_MIN_TEXT_HEIGHT;
    if (CheckEmptyUtils.checkStrIsEmpty(appName)) {
      return height;
    }
    const maxHeight: number = this.screenHeight * 2 / 3;
    height = this.getTextHeight(appName, height, maxHeight);
    return height;
  }

  private getTextWidth(appName: string, width: number, maxWidth: number): number {
    let needTextWidth: number = Math.round(px2vp(measure.measureTextSize({
      textContent: appName,
      fontSize: this.fontScaleState.getScaleSize(this.fontSize),
      fontWeight: FontWeight.Regular,
      overflow: TextOverflow.Ellipsis,
      maxLines: 1
    }).width as number)) + StyleConstants.DEFAULT_16;
    needTextWidth = needTextWidth > maxWidth ? maxWidth : needTextWidth;
    return needTextWidth > width ? needTextWidth : width;
  }

  private getTextHeight(appName: string, height: number, maxHeight: number): number {
    let needTextHeight: number = Math.round(px2vp(measure.measureTextSize({
      textContent: appName,
      fontSize: this.fontScaleState.getScaleSize(this.fontSize),
      fontWeight: FontWeight.Regular,
      overflow: TextOverflow.Ellipsis,
      maxLines: 1
    }).height as number));
    needTextHeight = needTextHeight > maxHeight ? maxHeight : needTextHeight;
    return needTextHeight > height ? needTextHeight : height;
  }

  private getSnapshotWidth(item: SnapshotInfo): number {
    if (CheckEmptyUtils.isEmpty(item)) {
      return FixedDockResource.SNAPSHOT_ITEM_DEFAULT_WIDTH;
    } else if (item.boxSize < FixedDockResource.SNAPSHOT_ITEM_MIN_WIDTH) {
      return FixedDockResource.SNAPSHOT_ITEM_MIN_WIDTH;
    } else {
      return item.boxSize;
    }
  }

  private clearTimer(): void {
    if (scrollerComponentTimer) {
      clearTimeout(scrollerComponentTimer);
      scrollerComponentTimer = null;
    }
  }

  private closeSnapshotWithDelay(delay: number): void {
    this.clearTimer();
    scrollerComponentTimer = setTimeout(() => {
      if (!this.hoverFlag) {
        this.popupHide?.();
        this.clearTimer();
        this.isDragging = false;
        log.showInfo(`${this.mPopItem.bundleName} closeSnapshotWithDelay`);
      }
    }, delay);
  }

  private closeClickAction(item: SnapshotInfo): void {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showError('onClick close, item is empty!');
      return;
    }

    let num: number = this.data.indexOf(item);
    let missionId: number = this.missionId;
    log.showInfo(
      `close ${item?.bundleName}, ${this.missionId} ${this.dataList.length} ${this.data.totalCount()} ${this.baseNum}`);
    if (this.dataList.length <= 1) {
      this.updateData?.(false, '', () => this.close(item.sceneSession as SCBSceneContainerSession, missionId));
      this.hoverFlag = false;
      AppStorage.setOrCreate('isHoverSnapshot', false);
      this.popupHide?.();
      ContextMenu.close();
    } else if (this.dataList?.length > 1 && this.dataList?.length === this.data.totalCount()) {
      this.player.onframe = (num: number) => {
        this.updateWidthAndArrow();
      }
      this.player.play();
      animateTo({
        curve: Curve.Friction,
        duration: 250,
        onFinish: () => {
          this.updateData(true, item?.bundleName, () => this.close(item?.sceneSession, missionId));
        }
      }, () => {
        log.showInfo(`before delete: ${this.data.totalCount()} ${this.dataList?.length} ${num} ${num + this.baseNum}`);
        this.dataList.splice(num + this.baseNum, 1);
        this.data.deleteItemByIndex(num);
        log.showInfo(`after delete: ${this.data.totalCount()} ${this.dataList?.length} ${num} ${num + this.baseNum}`);
      });
    } else {
      animateTo({
        curve: Curve.Friction,
        duration: 250,
        onFinish: () => {
          this.updateData(true, item?.bundleName, () => this.close(item?.sceneSession, missionId));
        }
      }, () => {
        log.showInfo(`before delete: ${this.data.totalCount()} ${this.dataList?.length} ${num} ${num + this.baseNum}`);
        this.dataList.splice(num + this.baseNum, 1);
        this.data.deleteItemByIndex(num);
        log.showInfo(`after delete: ${this.data.totalCount()} ${this.dataList?.length} ${num} ${num + this.baseNum}`);
        if (this.dataList[this.baseNum + this.data.totalCount()]) {
          // 最后面还有数据，从最后面取
          this.setRightData(true);
        } else {
          // 最后面没有数据，从前面取
          this.setLeftData(true);
        }
      });
    }
    this.updateWidthAndArrow();
  }

  private itemClickAction(item: SnapshotInfo, event?: ClickEvent): void {
    log.showInfo(`onClick:${item?.bundleName}, containerId: ${item?.sceneSession?.containerId}`);
    this.popupHide?.();
    this.hoverFlag = false;
    AppStorage.setOrCreate('isHoverSnapshot', false);
    ContextMenu.close();
    if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER) &&
    GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
      let hideAppCenterWithAnimation = (
      GlobalContext.getInstance().getObject('hideAppCenterWithAnimation')) as Function;
      hideAppCenterWithAnimation();
    }
    AppStorage.setOrCreate('cardWidth', this.getSnapshotWidth(item));
    AppStorage.setOrCreate('isOpenFromPopup', true);
    AppStorage.setOrCreate('cardPositionX', event?.target.area.globalPosition.x);
    AppStorage.setOrCreate('cardPositionY', event?.target.area.globalPosition.y);
    AppStorage.setOrCreate('isDockMissionsPopupShow', false);
    if (!CheckEmptyUtils.isEmpty(item)) {
      if (item.bundleName === CONTINUE_ABILITY) {
        SCBHiSysEventUtil.reportUserClickContinueIconEvent('continueMission',
          HiSysContinueFuncResult.SUCCESS);
      } else {
        DockHiSysEventMgr.reportStartAppFromPopup(item.bundleName);
        this.moveToFront(item.sceneSession as SCBSceneContainerSession, item.missionId);
      }
    } else {
      log.showError('onClick, item is empty!');
    }
  }

  private itemHoverAction(item: SnapshotInfo, isHover?: boolean): void {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showError('onHover, item is empty!');
      return;
    }
    log.showDebug(`onHover: ${item.bundleName}, missionId=${item.missionId}`);
    this.missionId = isHover ? item.missionId ?? -1 : -1;
    let missionId: number = this.missionId;
    if (isHover) {
      if (this.isDragging) {
        this.moveToFrontWithDelay(item.sceneSession as SCBSceneContainerSession, missionId, 800);
      }
    } else {
      this.clearMoveToFrontDelayTimer();
    }
    animateTo({ curve: Curve.Friction, duration: 300 }, () => {
      this.isHover = isHover;
      this.hoverNum = item.missionId ?? 0;
      this.hoverScale = 1.05;
    })
  }

  private getImage(item: SnapshotInfo): string | image.PixelMap {
    if (item?.image) {
      return item?.image;
    }
    log.showWarn(`item ${item?.missionId} image is invalid!`);
    let appIcon: string | image.PixelMap = ResourceManager.getInstance().getCachedAppIcon(this.mPopItem?.appIconId,
      this.mPopItem?.bundleName as string, this.mPopItem?.moduleName as string);
    if (CheckEmptyUtils.isEmpty(appIcon)) {
      // 增加兜底机制
      appIcon = IconResourceManager.getInstance().getCachedCombIconSync(this.mPopItem?.bundleName,
        this.mPopItem?.moduleName as string, this.mPopItem?.abilityName);
    }
    return CheckEmptyUtils.isEmpty(appIcon) ? '' : appIcon;
  }

  private getName(): string {
    return this.appName;
  }

  private getArrowOpacity(isLeftArrow: boolean): Resource | number {
    if (isLeftArrow) {
      return this.isLeftArrowClickable ? 1 : $r('sys.float.ohos_id_alpha_disabled');
    } else {
      return this.isRightArrowClickable ? 1 : $r('sys.float.ohos_id_alpha_disabled');
    }
  }

  @Builder
  ContinueItemTipsBuilder() {
    Column() {
      Text(this.deviceInfo?.appName ? this.deviceInfo?.appName : this.appName)
        .draggable(false)
        .fontSize(SmartDockConstants.CONTINUABLE_ICON_POPUP_TITLE_SIZE)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .margin(SmartDockConstants.CONTINUABLE_ICON_POPUP_TEXT_MARGIN)
      Text(getContext().resourceManager.getStringSync($r('app.string.continue_hap_come_from').id, this.deviceInfo?.sourceDeviceName ?? ''))
        .draggable(false)
        .fontSize(SmartDockConstants.CONTINUABLE_ICON_POPUP_DESC_SIZE)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .margin(SmartDockConstants.CONTINUABLE_ICON_POPUP_TEXT_MARGIN)
    }
    .alignItems(HorizontalAlign.Start)
    .padding(SmartDockConstants.CONTINUABLE_ICON_POPUP_PADDING)
  }

  @Builder
  tipsBuilder() {
    if (this.isContinueMerged() && RecentDockModel.getInstance().continuableItemExists(this.deviceInfo)) {
      this.ContinueItemTipsBuilder();
    } else {
      Row() {
        Text(this.getName())
          .draggable(false)
          .width(this.getAppNameTextWidth(this.appName))
          .height(this.getAppNameTextHeight(this.appName))
          .fontSize(this.fontScaleState.getScaleSize(this.fontSize))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontWeight(FontWeight.Regular)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .textAlign(TextAlign.Center)
          .maxLines(1)
          .align(Alignment.Center)
      }
      .id(`${TAG}_Text_appName${this.mPopItem?.bundleName}`)
      .height(FixedDockResource.TIPS_POPUP_HEIGHT)
      .justifyContent(FlexAlign.Center)
      .padding({ top: FixedDockResource.TIPS_TEXT_PADDING })
    }
  }

  @Builder
  leftArrowBuilder() {
    Row() {
      Image(this.leftArrowPicPath)
        .draggable(false)
        .id(`${TAG}_Image_leftArrow`)
        .width(FixedDockResource.PREVIEW_ARROW_SIZE)
        .height(FixedDockResource.PREVIEW_ARROW_SIZE)
        .objectFit(ImageFit.Contain)
        .fillColor($r('sys.color.ohos_id_color_primary'))
        .opacity(this.getArrowOpacity(true))
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.leftArrowBackgroundColor)
    .width(FixedDockResource.PREVIEW_ARROW_SIZE)
    .height(FixedDockResource.PREVIEW_ARROW_SIZE)
    .clip(
      new Circle({
        width: FixedDockResource.PREVIEW_ARROW_SIZE,
        height: FixedDockResource.PREVIEW_ARROW_SIZE
      }))
    .onClick((event: ClickEvent) => {
      log.showInfo('leftArrow onclick');
      this.moveToLeft();
    })
    .onTouch((event?: TouchEvent): void => {
      if (event?.type === TouchType.Down && this.isLeftArrowClickable) {
        this.leftArrowBackgroundColor = $r('sys.color.ohos_id_color_click_effect');
      } else if (event?.type === TouchType.Up && this.isLeftArrowClickable) {
        this.leftArrowBackgroundColor = $r('sys.color.ohos_id_color_hover');
      } else {
        this.leftArrowBackgroundColor = null;
      }
    })
    .onHover((isHover): void => {
      if (isHover && this.isLeftArrowClickable) {
        this.leftArrowBackgroundColor = $r('sys.color.ohos_id_color_hover');
      } else {
        this.leftArrowBackgroundColor = null;
      }
    })
    .margin({
      left: FixedDockResource.PREVIEW_ARROW_MARGIN_LEFT,
      right: FixedDockResource.PREVIEW_ARROW_MARGIN_RIGHT,
      top: FixedDockResource.PREVIEW_ARROW_MARGIN_TOP,
      bottom: FixedDockResource.PREVIEW_ARROW_MARGIN_BOTTOM
    })
  }

  private getForeachKey(item: SnapshotInfo): string {
    return item.missionId + item.bundleName + item.boxSize;
  }

  @Builder
  previewImageBuilder() {
    List({ scroller: this.mScroller }) {
      LazyForEach(this.data, (item: SnapshotInfo) => {
        ListItem() {
          Column() {
            Flex({
              direction: FlexDirection.Row,
              alignItems: ItemAlign.Center,
              justifyContent: FlexAlign.SpaceBetween
            }) {
              PreviewImageLabelName({
                snapShotItem: item,
                appInfo: this.mPopItem,
                appName: this.appName,
                deviceInfo: this.deviceInfo,
                fontSize: this.fontScaleState.getScaleSize(this.fontSize)
              })
                .id(`${TAG}_Text_${item?.bundleName}`)

              Stack() {
                Row()
                  .width(FixedDockResource.SNAPSHOT_CLOSE_BUTTON_SIZE)
                  .height(FixedDockResource.SNAPSHOT_CLOSE_BUTTON_SIZE)
                  .backgroundColor(this.closePicBackgroundColor)
                  .clip(
                    new Circle({
                      width: FixedDockResource.SNAPSHOT_CLOSE_BUTTON_SIZE,
                      height: FixedDockResource.SNAPSHOT_CLOSE_BUTTON_SIZE
                    }))

                Image(this.closePicPath ?? '')
                  .draggable(false)
                  .id(`${TAG}_Image_closePic`)
                  .fillColor($r('sys.color.ohos_id_color_primary'))
                  .width(FixedDockResource.SNAPSHOT_CLOSE_BUTTON_SIZE)
                  .height(FixedDockResource.SNAPSHOT_CLOSE_BUTTON_SIZE)
                  .objectFit(ImageFit.Contain)
                  .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
                  .clip(
                    new Circle({
                      width: FixedDockResource.SNAPSHOT_CLOSE_BUTTON_SIZE,
                      height: FixedDockResource.SNAPSHOT_CLOSE_BUTTON_SIZE
                    }))
                  .syncLoad(true)
              }
              .width(FixedDockResource.SNAPSHOT_CLOSE_BUTTON_SIZE)
              .height(FixedDockResource.SNAPSHOT_CLOSE_BUTTON_SIZE)
              .onClick((event?: ClickEvent) => {
                this.closeClickAction(item);
              })
              .onTouch((event?: TouchEvent) => {
                if (event?.type === TouchType.Down) {
                  this.closePicBackgroundColor = $r('sys.color.ohos_id_color_click_effect');
                } else if (event?.type === TouchType.Up) {
                  this.closePicBackgroundColor = $r('sys.color.ohos_id_color_hover');
                }
              })
              .onHover((isHover) => {
                if (isHover) {
                  this.closePicBackgroundColor = $r('sys.color.ohos_id_color_hover');
                } else {
                  this.closePicBackgroundColor = null;
                }
              })
              .visibility(this.missionId === item?.missionId && item.bundleName !== CONTINUE_ABILITY ?
                Visibility.Visible : Visibility.None)
            }
            .width(this.getSnapshotWidth(item))
            .height(FixedDockResource.SNAPSHOT_ITEM_TITLE_HEIGHT)
            .margin({
              bottom: FixedDockResource.SNAPSHOT_TITLE_MARGIN_BOTTOM
            })

            Row() {
              Image(this.getImage(item))
                .draggable(false)
                .id(`${TAG}_Image_${item?.bundleName}`)
                .width(item.bundleName === CONTINUE_ABILITY ? CONTINUE_IMAGE_HEIGHT : item?.boxSize ?? 0)
                .height(item.bundleName === CONTINUE_ABILITY ?
                  CONTINUE_IMAGE_HEIGHT : FixedDockResource.SNAPSHOT_IMAGE_HEIGHT)
                .objectFit(ImageFit.Contain)
                .interpolation(ImageInterpolation.Medium)
                .autoResize(false)
                .borderRadius(FixedDockResource.SNAPSHOT_IMAGE_INNER_BORDER_RADIUS)
                .syncLoad(true)
            }
            .width(this.getSnapshotWidth(item))
            .height(FixedDockResource.SNAPSHOT_IMAGE_HEIGHT)
            .justifyContent(FlexAlign.Center)
            .backgroundColor(item.bundleName === CONTINUE_ABILITY ? this.continuableItemBgColor :
              (this.getSnapshotWidth(item) === item?.boxSize ? Color.Transparent : '#F1F3F5'))
            .shadow({
              radius: FixedDockResource.SNAPSHOT_IMAGE_SHADOW_RADIUS,
              color: FixedDockResource.SNAPSHOT_IMAGE_SHADOW_COLOR
            })
            .borderRadius(FixedDockResource.SNAPSHOT_IMAGE_OUTER_BORDER_RADIUS)
            .clip(true)
          }
          .scale((this.hoverNum === item?.missionId && this.isHover) ?
            { x: this.hoverScale, y: this.hoverScale } : { x: 1.0, y: 1.0 })
          .width(this.getSnapshotWidth(item) + FixedDockResource.SNAPSHOT_GAP)
          .height(FixedDockResource.SNAPSHOT_ITEM_HEIGHT)
          .padding({
            top: FixedDockResource.SNAPSHOT_ITEM_PADDING_TOP,
            bottom: FixedDockResource.SNAPSHOT_ITEM_PADDING_BOTTOM,
            left: FixedDockResource.SNAPSHOT_ITEM_PADDING_LEFT,
            right: FixedDockResource.SNAPSHOT_ITEM_PADDING_RIGHT
          })
          .alignItems(HorizontalAlign.Center)
          .onClick((event?: ClickEvent) => {
            this.itemClickAction(item, event);
          })
          .onHover((isHover?: boolean) => {
            this.itemHoverAction(item, isHover);
          })
          .onDrop((event?: DragEvent, extraParams?: string) => {
          })
          .onDragEnter((event: DragEvent, extraParams?: string) => {
            this.isDragging = true;
            this.clearTimer();
            this.hoverFlag = true;
            AppStorage.setOrCreate('isHoverSnapshot', this.hoverFlag);
            this.itemHoverAction(item, this.hoverFlag);
          })
          .onDragLeave((event: DragEvent, extraParams?: string) => {
            this.hoverFlag = false;
            AppStorage.setOrCreate('isHoverSnapshot', this.hoverFlag);
            this.itemHoverAction(item, this.hoverFlag);
            this.closeSnapshotWithDelay(150);
          })
        }
        .transition(TransitionEffect.asymmetric(
          TransitionEffect.scale({ x: 0.5, y: 0.5 })
            .combine(TransitionEffect.opacity(0.0))
            .combine(TransitionEffect.scale({ x: 1.0, y: 1.0 }).animation({ duration: 250, curve: Curve.Friction }))
            .combine(TransitionEffect.opacity(1.0).animation({ duration: 250, curve: Curve.Friction })),
          TransitionEffect.scale({ x: 0.5, y: 0.5 })
            .combine(TransitionEffect.opacity(0.0)
            .animation({ duration: this.missionId === item.missionId ? 250 : 0, curve: Curve.Friction }))
        ))
      }, (item: SnapshotInfo) => this.getForeachKey(item))
    }
    .listDirection(Axis.Horizontal)
    .align(Alignment.Center)
    .width(this.mCurrentBoxWidth)
    .height(FixedDockResource.SNAPSHOT_ITEM_HEIGHT)
    .onReachStart(() => {
      log.showInfo(`onReachStart happen ${this.baseNum}`);
      this.previewScrollState = PreviewScrollState.REACH_START;
    })
    .onReachEnd(() => {
      log.showInfo(`onReachEnd happen ${this.baseNum}`);
      this.previewScrollState = PreviewScrollState.REACH_END;
    })
    .onScroll((scrollOffset: number, scrollState: ScrollState) => {
      log.showInfo(`onScroll ${scrollOffset} ${this.mScroller.currentOffset().xOffset} ${this.previewScrollState}`);
      if (scrollOffset === 0 && this.previewScrollState === PreviewScrollState.REACH_START) {
        this.moveToLeft();
      }
      if (scrollOffset === 0 && this.previewScrollState === PreviewScrollState.REACH_END) {
        this.moveToRight();
      }
    })
    .edgeEffect(EdgeEffect.None)
    .margin({
      left: this.isArrowShow ? 0 : FixedDockResource.SNAPSHOT_GAP / 2,
      right: this.isArrowShow ? 0 : FixedDockResource.SNAPSHOT_GAP / 2
    })
    .scrollBar(BarState.Off)
  }

  @Builder
  rightArrowBuilder() {
    Row() {
      Image(this.rightArrowPicPath)
        .draggable(false)
        .id(`${TAG}_Image_rightArrow`)
        .width(FixedDockResource.PREVIEW_ARROW_SIZE)
        .height(FixedDockResource.PREVIEW_ARROW_SIZE)
        .objectFit(ImageFit.Contain)
        .fillColor($r('sys.color.ohos_id_color_primary'))
        .opacity(this.getArrowOpacity(false))
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.rightArrowBackgroundColor)
    .width(FixedDockResource.PREVIEW_ARROW_SIZE)
    .height(FixedDockResource.PREVIEW_ARROW_SIZE)
    .clip(
      new Circle({
        width: FixedDockResource.PREVIEW_ARROW_SIZE,
        height: FixedDockResource.PREVIEW_ARROW_SIZE
      }))
    .onClick((event: ClickEvent) => {
      log.showInfo('rightArrow onclick');
      this.moveToRight();
    })
    .onTouch((event?: TouchEvent): void => {
      if (event?.type === TouchType.Down && this.isRightArrowClickable) {
        this.rightArrowBackgroundColor = $r('sys.color.ohos_id_color_click_effect');
      } else if (event?.type === TouchType.Up && this.isRightArrowClickable) {
        this.rightArrowBackgroundColor = $r('sys.color.ohos_id_color_hover');
      } else {
        this.rightArrowBackgroundColor = null;
      }
    })
    .onHover((isHover): void => {
      if (isHover && this.isRightArrowClickable) {
        this.rightArrowBackgroundColor = $r('sys.color.ohos_id_color_hover');
      } else {
        this.rightArrowBackgroundColor = null;
      }
    })
    .margin({
      left: FixedDockResource.PREVIEW_ARROW_MARGIN_LEFT,
      right: FixedDockResource.PREVIEW_ARROW_MARGIN_RIGHT,
      top: FixedDockResource.PREVIEW_ARROW_MARGIN_TOP,
      bottom: FixedDockResource.PREVIEW_ARROW_MARGIN_BOTTOM
    })
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear happened:${this.mPopItem.bundleName}-${this.isContinueMerged()}`);
    this.updateName();
    this.updateIsRunning();
    this.mMaxWidth = this.screenWidth - FixedDockResource.PREVIEW_SCREEN_PADDING * 2;
    this.mMaxBoxWidth = this.mMaxWidth - 2 * FixedDockResource.PREVIEW_MARGIN_WHEN_HAS_ARROW;
    this.dataList = ([] as SnapshotInfo[]).concat(this.mSnapshotList as SnapshotInfo[]);
    this.baseNum = 0;
    this.loadData();
    this.updateWidthAndArrow();
    this.calculatePopupOffsetX();
    this.continuableItemBgColor = this.currColorMode === ColorMode.DARK ?
      FixedDockResource.LIGHT_CONTINUABLE_PREVIEW_BG_COLOR : FixedDockResource.DARK_CONTINUABLE_PREVIEW_BG_COLOR;
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisAppear happened:${this.mPopItem.bundleName}`);
  }

  build() {
    if (!this.isRunning) {
      this.tipsBuilder();
    } else {
      if (this.dataList.length >= 1) {
        Flex({
          direction: FlexDirection.Row,
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.Center
        }) {
          if (this.isArrowShow) {
            this.leftArrowBuilder();
          }
          this.previewImageBuilder();
          if (this.isArrowShow) {
            this.rightArrowBuilder();
          }
        }
        .id(`ScrollerComponent_showPopup`)
        .width(this.getWidth())
        .height(FixedDockResource.SNAPSHOT_ITEM_HEIGHT)
        .onHover((isHover) => {
          if (isHover) {
            this.clearTimer();
            this.hoverFlag = true;
            AppStorage.setOrCreate('isHoverSnapshot', true);
            log.showDebug(`onhover true isHoverSnapshot true, ${isHover}`);
          } else {
            this.hoverFlag = false;
            AppStorage.setOrCreate('isHoverSnapshot', false);
            log.showDebug(`onhover false isHoverSnapshot false, ${isHover}`);
            this.closeSnapshotWithDelay(150);
          }
        })
        .onMouse((event?: MouseEvent) => {
          if (event && this.isDragging && event.action === MouseAction.Release) {
            log.showInfo('onMouse isDragging and release');
            this.isDragging = false;
            this.clearMoveToFrontDelayTimer();
          }
        })
      }
    }
  }
}

@Component
export struct PreviewImageLabelName {
  private snapShotItem: SnapshotInfo = new SnapshotInfo();
  private appName: string = '';
  private appInfo: AppItemInfo = new AppItemInfo();
  private scbSceneSessionManager = SCBSceneSessionManager.getInstance();
  @State labelName: string = '';
  @State fontSize: string = StyleConstants.DEFAULT_14 + 'vp';
  @Link deviceInfo: DockContinuableInfo;

  private sessionLabelListener: SessionLabelListener = {
    onUpdate: (label: string) => {
      this.labelName = label;
    }
  }

  private initLabelName(item: SnapshotInfo): void {
    if (item.bundleName === CONTINUE_ABILITY) {
      this.labelName = getContext().resourceManager.getStringSync($r('app.string.continue_hap_come_from').id, this.deviceInfo.sourceDeviceName ?? '');
      return;
    }

    const sessionLabel: string = SCBSceneResourceManager.getInstance().getSessionLabelCache(item.missionId);
    if (!CheckEmptyUtils.isEmpty(sessionLabel)) {
      log.showDebug(`labelName from sessionLabel,${this.appInfo?.bundleName}`);
      this.labelName = sessionLabel;
      return;
    }

    if (CheckEmptyUtils.isEmpty(this.appName)) {
      ResourceManager.getInstance().getAppNameWithCache(this.appInfo?.appLabelId, this.appInfo?.bundleName,
        this.appInfo?.moduleName, '', (name: string): void => { this.labelName = name; });
      log.showDebug(`labelName from AppNamecache ${this.appInfo?.bundleName}`);
      return;
    }

    this.labelName = this.appName;
    log.showDebug(`labelName from appName, ${this.appInfo?.bundleName}`);
  }

  private getSnapshotWidth(item: SnapshotInfo): number {
    if (CheckEmptyUtils.isEmpty(item)) {
      return FixedDockResource.SNAPSHOT_ITEM_DEFAULT_WIDTH;
    } else if (item.boxSize < FixedDockResource.SNAPSHOT_ITEM_MIN_WIDTH) {
      return FixedDockResource.SNAPSHOT_ITEM_MIN_WIDTH;
    } else {
      return item.boxSize;
    }
  }

  aboutToAppear(): void {
    this.initLabelName(this.snapShotItem);
    this.scbSceneSessionManager.registerSessionLabelListener(this.snapShotItem.missionId, this.sessionLabelListener);
    log.showInfo(`aboutToAppear ${this.snapShotItem.bundleName}, ${this.snapShotItem.missionId}`);
  }

  aboutToDisappear(): void {
    this.scbSceneSessionManager.unRegisterSessionLabelListener(this.snapShotItem.missionId, this.sessionLabelListener);
    log.showInfo(`aboutToDisappear ${this.snapShotItem.bundleName}, ${this.snapShotItem.missionId}`);
  }

  build() {
    Row() {
      Text(this.labelName)
        .draggable(false)
        .width(this.getSnapshotWidth(this.snapShotItem) - FixedDockResource.SNAPSHOT_CLOSE_BUTTON_SIZE)
        .height(FixedDockResource.SNAPSHOT_TITLE_HEIGHT)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontSize(this.fontSize)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .textAlign(TextAlign.Start)
        .maxLines(1)
        .hoverEffect(HoverEffect.None)
        .fontWeight(FontWeight.Medium)
    }
    .padding({ top: FixedDockResource.TIPS_TEXT_PADDING })
  }
}