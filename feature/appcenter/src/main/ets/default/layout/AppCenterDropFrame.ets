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
  AppItemInfo,
  LayoutViewModel,
  AppGridStyleConfig,
} from '@ohos/launchercommon';
import { LogDomain, LogHelper, SingleContext } from '@ohos/basicutils'
import { DragEventManager, DragEventCallback } from '@ohos/componentdrag'
import { AppCenterDragMgr } from '../controller/AppCenterDragMgr';
import AppGridLayoutUtil from '../common/util/AppGridLayoutUtil';
import AppGridLayoutCacheManager from '../common/cache/AppGridLayoutCacheManager';
import { APP_CENTER_DROP_FRAME_KEY } from '../constants/LayoutConstants';
import { FoldedDeviceAcViewModel } from '../folded/FoldedDeviceAcViewModel';
import { TranslateItem } from '../controller/CommonAcDragMgr';
import { SCBPropertyChangeReason, SCBScreenProperty, SCBScreenSessionManager } from '@ohos/windowscene';

const TAG = 'AppCenterDropFrame';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export struct AppCenterDropFrame {
  @Prop screenProp: SCBScreenProperty;
  @Prop singleContext?: SingleContext;
  @State mWhiteBoxX: number = 0;
  @State mWhiteBoxY: number = 0;
  @State mShowWhiteBox: boolean = false;
  @Prop @Watch('onPageChange') pageIndex: number;
  @Prop showDropFrame: boolean;
  private appGridStyleConfig: AppGridStyleConfig = AppGridStyleConfig.getInstance(this.singleContext);
  @State dropFrameOuterHeight: number = 0;
  @State dropFrameOuterWidth: number = 0;
  @State dropFrameInnerHeight: number = 0;
  @State dropFrameInnerWidth: number = 0;
  @State dropFrameRadius: number = 0;
  private currentScreenHeight: number = this.screenProp.height;
  private currentScreenWidth: number = this.screenProp.width;
  private appCenterDragMgr: AppCenterDragMgr = AppCenterDragMgr.getInstance();
  private mDragEventCallback: DragEventCallback = {};
  private appCenterBubbleMarginTop?: number;
  private appCenterBubbleMarginBottom?: number;
  private startTranslatePosition: number[] = [];
  private currentTranslatePosition: number[] = [];
  private isDragScene: boolean = false;

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.updateDropFrameStyle(this.screenProp);
    this.initDragEventCallback();
    this.registerDragEvent();
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.unRegisterDragEvent();
    this.mDragEventCallback = {};
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
  }

  private registerDragEvent(): void {
    log.showInfo('registerDragEvent');
    DragEventManager.getInstance().registerDragEvent(this.mDragEventCallback, APP_CENTER_DROP_FRAME_KEY);
  }

  private unRegisterDragEvent(): void {
    log.showInfo('unRegisterDragEvent');
    DragEventManager.getInstance().unRegisterDragEvent(this.mDragEventCallback, APP_CENTER_DROP_FRAME_KEY);
  }

  onScreenPropertyChange = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    if (this.screenProp.screenId !== screenProperty.screenId) {
      log.showInfo(`screen id not equal: ${this.screenProp.screenId} ${screenProperty.screenId}`);
      return;
    }
    if (this.currentScreenHeight === screenProperty.height &&
      this.currentScreenWidth === screenProperty.width) {
      log.showInfo('screen width or height not change');
      return;
    }
    if (FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      log.showInfo('fold device');
      return;
    }
    this.updateDropFrameStyle(screenProperty);
    log.showInfo(`onScreenPropertyChange ${screenProperty.width} ${screenProperty.height}`);
  }

  private updateDropFrameStyle(screenProperty: SCBScreenProperty): void {
    let result = LayoutViewModel.getInstance().calculateAppCenter(
      screenProperty.screenId, false, screenProperty.width, screenProperty.height);
    this.appCenterBubbleMarginTop = result.mAppCenterBubbleMarginTop;
    this.appCenterBubbleMarginBottom = result.mAppCenterBubbleMarginBottom;
    this.dropFrameOuterHeight = result.mAppCenterItemHeight ?? 0;
    this.dropFrameOuterWidth = result.mAppCenterItemWidth ?? 0;
    this.dropFrameInnerHeight = result.mIconSize ?? 0;
    this.dropFrameInnerWidth = result.mIconSize ?? 0;
    this.dropFrameRadius = result.mIconRadius ?? 0;
    this.currentScreenHeight = screenProperty.height;
    this.currentScreenWidth = screenProperty.width;
    log.showInfo(`updateDropFrameStyle result: ${JSON.stringify(result)}`);
  }

  private onStartSqueezedEvent(translatePosition: number[][]): void {
    if (!this.isPosChanged(translatePosition) && this.mShowWhiteBox) {
      this.mWhiteBoxX = translatePosition[1][0];
      this.mWhiteBoxY = translatePosition[1][1];
      return;
    }
    this.currentTranslatePosition = translatePosition[1];
    // 连续拖拽时落位框动效场景
    if (this.isDragScene) {
      this.animateToMove(translatePosition[1][0], translatePosition[1][1], false, true);
    } else {
      this.animateToMove(translatePosition[1][0], translatePosition[1][1], true, false);
      this.isDragScene = true;
    }
  }

  private isPosChanged(translatePosition: number[][]): boolean {
    if (!this.appCenterDragMgr.isInDragging()) {
      log.showInfo('isPosChanged not in drag');
      return false;
    }
    // 移到空白页oldPostion和newPostion相同
    if (translatePosition[0][0] === translatePosition[1][0] &&
      translatePosition[0][1] === translatePosition[1][1]) {
      log.showInfo('isPosChanged move to blank page');
      return true;
    }
    // 位置没有变化
    if (translatePosition[0].length === 0 && this.mShowWhiteBox) {
      log.showInfo('isPosChanged position not change 0');
      return false;
    }
    // 发生挤位
    let dragItemInfo = this.appCenterDragMgr.getDragItemInfo() as TranslateItem;
    if (dragItemInfo.row === dragItemInfo.newRow &&
      dragItemInfo.column === dragItemInfo.newColumn &&
      dragItemInfo.page === dragItemInfo.newPage) {
      log.showInfo(`isPosChanged position not change from,
      x: ${this.mWhiteBoxX} to ${translatePosition[1][0]}, y: ${this.mWhiteBoxY} to ${translatePosition[1][1]}`);
      return false;
    }
    log.showInfo(`isPosChanged move from row:${dragItemInfo.row}, column:${dragItemInfo.column}, page:${dragItemInfo.page} to
      newRow:${dragItemInfo.newRow}, newColumn:${dragItemInfo.newColumn}, newPage:${dragItemInfo.newPage}`);
    return true;
  }

  animateToMove(x: number, y: number, isShow: boolean, isDragScene: boolean): void {
    this.mWhiteBoxX = x;
    this.mWhiteBoxY = y;
    animateTo({
      duration: isDragScene ? 1 : 250,
      curve: Curve.Sharp,
      onFinish: () => {
        if (isDragScene && this.appCenterDragMgr.isInDragging()) {
          animateTo({
            duration: 250,
            curve: Curve.Sharp
          }, () => {
            this.mShowWhiteBox = true;
          })
        }
      }
    }, () => {
      this.mShowWhiteBox = isShow;
    });
  }

  private onPageChange(): void {
    if (this.appCenterDragMgr.isAnimating()) {
      return;
    }
    log.showInfo('onPageChange');
    this.mShowWhiteBox = this.appCenterDragMgr.getCurrentIsInAppCenterWorkBench(this.screenProp.screenId) &&
      !AppGridLayoutCacheManager.getInstance().isFullPage(this.pageIndex);
    if (this.mShowWhiteBox) {
      this.mWhiteBoxX = this.currentTranslatePosition[0];
      this.mWhiteBoxY = this.currentTranslatePosition[1];
      return;
    }
    const appGridList: AppItemInfo[] =
      AppGridLayoutCacheManager.getInstance().getAppGridLayoutItemsByPage(this.pageIndex);
    let position: number[] | undefined = [];
    const length: number = appGridList.length;
    if (length === 0) {
      position = AppGridLayoutUtil.getGridItemPosition(0, 0, undefined, this.screenProp.screenId);
    } else if (this.appCenterDragMgr.getStartDragPage() === this.pageIndex) {
      position = this.startTranslatePosition;
      this.mShowWhiteBox = true;
    } else {
      const grid: number[] | undefined =
        AppGridLayoutCacheManager.getInstance().getNextPosition(false, appGridList[length - 1].row,
          appGridList[length - 1].column);
      if (grid !== undefined) {
        position = AppGridLayoutUtil.getGridItemPosition(grid[0], grid[1], undefined, this.screenProp.screenId);
      }
    }
    if (position !== undefined) {
      this.mWhiteBoxX = position[0];
      this.mWhiteBoxY = position[1];
    }
  }

  private initDragEventCallback(): void {
    this.mDragEventCallback = {
      onItemDragStartEvent: (): void => {
        this.startTranslatePosition = this.appCenterDragMgr.getStartDragPos(this.screenProp.screenId);
        this.mWhiteBoxX = this.startTranslatePosition?.[0];
        this.mWhiteBoxY = this.startTranslatePosition?.[1];
        this.mShowWhiteBox = true;
        log.showInfo(`onItemDragStartEvent startTranslatePosition: ${this.mWhiteBoxX}, ${this.mWhiteBoxY}`);
      },
      onItemDropStartEvent: (): void => {
        log.showInfo('onItemDropStartEvent');
      },
      onItemDropEndEvent: (): void => {
        log.showInfo('onItemDropEndEvent');
        this.mShowWhiteBox = false;
        this.startTranslatePosition = [];
        this.currentTranslatePosition = [];
        this.isDragScene = false;
      },
      onStartSqueezedEvent: (translatePosition: number[][]): void => {
        log.showInfo('onStartSqueezedEvent');
        this.onStartSqueezedEvent(translatePosition);
      },
      onCancelSqueezedEvent: (hasAnimation: boolean): void => {
        log.showInfo(`onCancelSqueezedEvent-${AppCenterDragMgr.getInstance().getStartDragPage()},startAimationDrop:${ this.startAimationDrop()}`);
        if (this.needMoveBack()) {
          this.animateToMove(this.startTranslatePosition[0], this.startTranslatePosition[1], true, false);
        } else {
          this.mShowWhiteBox = false;
        }
        log.showInfo('onCancelSqueezedEvent');
      }
    }
  }
  private needMoveBack(): boolean {
    if (FoldedDeviceAcViewModel.getInstance().isFoldedDevice() && this.startAimationDrop()) {
      return this.appCenterDragMgr.getStartDragPage() !== undefined;
    } else {
      return this.appCenterDragMgr.getStartDragPage() === this.pageIndex;
    }
  }

  // 针对不在拖拽图标不在应用中心工作区，且hopper设备不在统一屏幕的B,C屏，返回false，不显示图标原位置落位框
  private startAimationDrop(): boolean {
    if (!FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      return true;
    }
    return Math.floor((this.appCenterDragMgr.getStartDragPage() ?? 0) / 2)=== Math.floor(this.pageIndex / 2);
  }

  build() {
    Column() {
      Row() {
      }
      .backgroundColor($r('sys.color.ohos_id_color_component_normal'))
      .width(this.dropFrameInnerWidth)
      .height(this.dropFrameInnerHeight)
      .borderWidth(1)
      .borderColor('#33FFFFFF')
      .borderRadius(this.dropFrameRadius)
      .outlineWidth(1)
      .outlineColor('#1A000000')
      .outlineRadius(this.dropFrameRadius)
      .margin({
        top: this.appCenterBubbleMarginTop,
        bottom: this.appCenterBubbleMarginBottom
      })
    }
    .width(this.dropFrameOuterWidth)
    .height(this.dropFrameOuterHeight)
    .key(TAG)
    .position({ x: this.mWhiteBoxX, y: this.mWhiteBoxY })
    .opacity(this.mShowWhiteBox && this.showDropFrame ? 1 : 0)
  }
}
