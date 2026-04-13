/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import image from '@ohos.multimedia.image';
import drawableDescriptor from '@ohos.arkui.drawableDescriptor';
import {
  BadgeListener,
  BadgeManager,
  CommonConstants,
  DockItemInfo,
  StyleConstants
} from '@ohos/launchercommon';
import {
  LogDomain,
  LogHelper,
  ResourceManager,
  CheckEmptyUtils,
  ItemUtils,
  RectInfo } from '@ohos/basiccommon';
import { BadgeItemInfo, AppModel, AppItemInfo } from '@ohos/launchercommon';
import HoverEffectConstants from '../common/constants/HoverEffectConstants';
import SmartDockConstants from '@ohos/smartdock/src/main/ets/default/common/constants/SmartDockConstants';
import animator from '@ohos.animator';
import { LazyDataSource } from '@ohos/launchercommon/Index';
import SmartDockModel from '@ohos/smartdock/src/main/ets/default/model/SmartDockModel';
import { SnapshotInfo } from '@ohos/launchercommon';
import { FixedDockResource, PreviewScrollState } from '../common/constants/FixedDockConstants';
import { PCDockUtils } from '../utils/PCDockUtils';


const TAG = 'PcAppFixedHoverEffectComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export default struct PcAppFixedHoverEffectComponent {
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
  private icon: string | image.PixelMap = '';
  private backgroundDescriptor: drawableDescriptor.DrawableDescriptor | null = null;
  private foregroundDescriptor: drawableDescriptor.DrawableDescriptor | null = null;
  private iconSize: number = 0;
  private appInfo: DockItemInfo = new DockItemInfo();
  private isAdaptiveIcon: boolean = false;
  private shadowPixelmap: image.PixelMap | null = null;
  private mBaseBorderRadius: number = 12;
  private mBaseShadowTranslateOffset: number = 3;
  private badgeFontSize: number = StyleConstants.PC_BADGE_FONT_SIZE;
  private mBadgeSize: number = StyleConstants.PC_BADGE_SIZE;
  private mBadgeScale: number = 1;
  private badgeManager: BadgeManager = BadgeManager.getInstance();

  @Consume hoverVisibility: Visibility;
  @Consume rotateX: number;
  @Consume rotateY: number;
  @Consume backgroundRotateAngle: number;
  @Consume foregroundRotateAngle: number;
  @Consume foregroundTranslateX: number;
  @Consume foregroundTranslateY: number;
  @Consume highlightingTranslateX: number;
  @Consume highlightingTranslateY: number;
  @Consume shadowTranslateX: number;
  @Consume shadowTranslateY: number;
  @Consume baseScale: number;
  @Consume shadowScale: number;
  @Consume foregroundScale: number;
  @Consume shadowOpacity: number;
  @Consume adapterScale: number;
  @State updateIconReady: boolean = false;
  @State badgeNumber: number = 0;

  private popupHide: Function = (): void => {
  };
  private updateData: Function = (): void => {
  };
  private popupOffsetUpdate: Function = (): void => {
  };
  private mPopItem: AppItemInfo = new AppItemInfo();
  private mSmartDockModel: SmartDockModel = SmartDockModel.getInstance();
  private mMaxWidth = 0;
  private mCurrentBoxWidth = 0;
  private mMaxBoxWidth = 0;
  private mScroller: Scroller = new Scroller();
  private previewScrollState: PreviewScrollState = PreviewScrollState.NORMAL;
  @State isLeftArrowClickable: boolean = false;
  @State isRightArrowClickable: boolean = true;
  @StorageLink('snapshotList') @Watch('onSnapshotListChange') mSnapshotList: SnapshotInfo[] = [];
  @StorageProp('screenWidth') screenWidth: number = 0;
  @State dataList: SnapshotInfo[] = ([] as SnapshotInfo[]).concat(this.mSnapshotList as SnapshotInfo[]);
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

  private updateIsRunning(): void {
    this.isRunning = this.mSmartDockModel.checkAppIsRunning(this.mPopItem.bundleName, this.mPopItem.appIndex);
    log.showDebug(`${this.mPopItem.bundleName} isRunning: ${this.isRunning}`);
  }

  private calculatePopupOffsetX(): void {
    let position: Position = {
      x: 0,
      y: 0,
    }
    let iconRect: RectInfo = ItemUtils.getRectById(AppModel.getInstance().getAppIconContainerId(
      'SmartDock_AppIcon', this.mPopItem.bundleName as string, this.mPopItem.abilityName as string));
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
  private loadData(): void {
    log.showInfo(`${this.mPopItem.bundleName} loadData start ${this.dataList.length}`);
    this.previewScrollState = PreviewScrollState.NORMAL;
    this.isArrowShow = false;
    this.isLeftArrowClickable = false;
    this.isRightArrowClickable = true;
    this.data.clear();
    let sumBoxWidth = 0;
    for (let index = this.baseNum; index < this.dataList.length; index++) {
      this.data.insertItem(this.dataList[index], index);
      sumBoxWidth += this.getSnapshotWidth(this.dataList[index]) + FixedDockResource.SNAPSHOT_GAP;
      if (sumBoxWidth + FixedDockResource.SNAPSHOT_GAP / 2 > this.mMaxBoxWidth) {
        break;
      }
    }
    this.data.notifyDataReload();
    log.showInfo(`${this.mPopItem.bundleName} loadData end ${this.dataList.length} ${this.data.totalCount()}`);
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

  private onSnapshotListChange(): void {
    log.showInfo(`${this.mPopItem.bundleName} snapshotListChange start:${this.mSnapshotList.length}`);
    this.dataList = ([] as SnapshotInfo[]).concat(this.mSnapshotList as SnapshotInfo[]);
    if (!CheckEmptyUtils.isEmptyArr(this.mSnapshotList) &&
      this.mSnapshotList[0].bundleName != this.mPopItem.bundleName) {
      return;
    }
    if (this.mSnapshotList.length > 15) {
      log.showInfo('snapshotList len more than 15, no need to refresh');
      return;
    }
    this.baseNum = 0;
    this.loadData();
    this.updateWidthAndArrow();
    this.calculatePopupOffsetX();
    this.updateIsRunning();
    log.showInfo(`${this.mPopItem.bundleName} snapshotListChange end:${this.dataList.length}`);
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
  private isPcResidentAbility(): boolean {
    return this.appInfo.abilityName === CommonConstants.APPCENTER_ABILITY ||
      this.appInfo.abilityName === CommonConstants.RECENT_ABILITY ||
      this.appInfo.abilityName === CommonConstants.RECYCLE_BIN_ABILITY;
  }

  private getAppIcon() {
    if (this.appInfo.bundleName && this.appInfo.moduleName) {
      ResourceManager.getInstance().getAppIconWithCache(this.appInfo.appIconId, this.appInfo.bundleName,
        this.appInfo.moduleName, (value: string | PixelMap) => {
          this.icon = value;
          this.updateIconReady = true;
        }, this.icon);
    }
  }

  private badgeListener: BadgeListener = {
    onUpdate: (badgeInfo: BadgeItemInfo) => {
      log.showDebug(`update badge.badgeNumber=${badgeInfo?.badgeNumber}, badge.isShow=${badgeInfo?.isShow}`);
      this.badgeManager.getBadgeDisplayNumberByBundle(this.appInfo, (num: number) => this.badgeNumber = num);
    }
  };

  getPresetBackground(): Resource | null {
    let backgroundResource: Resource | null = null;
    switch (this.appInfo.abilityName) {
      case CommonConstants.APPCENTER_ABILITY:
        backgroundResource = $r('app.media.adaptive_appcenter_background');
        break;
      case CommonConstants.RECENT_ABILITY:
        backgroundResource = $r('app.media.adaptive_multitask_background');
        break;
      case CommonConstants.RECYCLE_BIN_ABILITY:
        backgroundResource = $r('app.media.adaptive_recycle_bin_background');
        break;
      default:
        break;
    }
    return backgroundResource;
  }

  getPresetForeground(): Resource | null {
    let foregroundResource: Resource | null = null;
    switch (this.appInfo.abilityName) {
      case CommonConstants.APPCENTER_ABILITY:
        foregroundResource = $r('app.media.adaptive_appcenter_foreground');
        break;
      case CommonConstants.RECENT_ABILITY:
        foregroundResource = $r('app.media.adaptive_multitask_foreground');
        break;
      default:
        break;
    }
    return foregroundResource;
  }

  aboutToAppear() {
    log.showInfo(`PcAppFixedHoverEffectComponent aboutToAppear ${this.appInfo.bundleName}`);
    this.badgeManager.getBadgeDisplayNumberByBundle(this.appInfo, (num: number) => this.badgeNumber = num);
    if (this.appInfo != null && this.appInfo.bundleName != CommonConstants.LAUNCHER_BUNDLE) {
      log.showInfo(`PcAppFixedHoverEffectComponent aboutToAppear isAdaptiveIcon ${this.isAdaptiveIcon}`);
      if (this.isAdaptiveIcon) {
        if (this.foregroundDescriptor) {
          this.shadowPixelmap = ResourceManager.getInstance().getCachedEffectKit(this.appInfo?.appIconId,
            this.appInfo?.abilityName);
        }
      } else {
        this.getAppIcon();
      }
    } else if (this.appInfo != null && this.isPcResidentAbility()) {
      log.showInfo(`PcAppFixedHoverEffectComponent aboutToAppear resident ${this.appInfo.abilityName}`);
      this.isAdaptiveIcon = true;
      this.shadowPixelmap = ResourceManager.getInstance().getCachedEffectKit(this.appInfo?.appIconId,
        this.appInfo?.abilityName);
    }
    this.badgeManager.registerBadgeListener(this.appInfo, this.badgeListener);
    log.showInfo(`PcAppFixedHoverEffectComponent aboutToAppear end ${this.appInfo.bundleName}`);
  }

  aboutToDisappear() {
    this.badgeManager.unRegisterBadgeListener(this.appInfo, this.badgeListener);
  }

  @Builder
  alignmentCenterBuilder() {
    Stack({ alignContent: Alignment.Center }) {
      Image(this.isPcResidentAbility() ? this.getPresetBackground() : this.backgroundDescriptor)
        .draggable(false)
        .height(this.iconSize * HoverEffectConstants.ADAPTIVE_SCALE)
        .width(this.iconSize * HoverEffectConstants.ADAPTIVE_SCALE)
        .interpolation(ImageInterpolation.Medium)
        .autoResize(false)
        .syncLoad(true)
    }
    .height(this.iconSize)
    .width(this.iconSize)
    .clip(true)
    .borderRadius(this.mBaseBorderRadius)
  }

  @Builder
  shadowPixelmapBuilder() {
    Image(this.shadowPixelmap)
      .draggable(false)
      .height(this.iconSize * HoverEffectConstants.ADAPTIVE_SCALE)
      .width(this.iconSize * HoverEffectConstants.ADAPTIVE_SCALE)
      .objectFit(ImageFit.Contain)
      .interpolation(ImageInterpolation.Medium)
      .autoResize(false)
      .scale({ x: this.shadowScale, y: this.shadowScale })
      .opacity(this.shadowOpacity)
      .syncLoad(true)
      .translate({
        x: this.shadowTranslateX + this.mBaseShadowTranslateOffset,
        y: this.shadowTranslateY + this.mBaseShadowTranslateOffset,
      })
      .rotate({
        x: this.rotateX,
        y: this.rotateY,
        z: 0,
        centerX: '50%',
        centerY: '50%',
        perspective: HoverEffectConstants.CAMERA_DISTANCE,
        angle: this.foregroundRotateAngle
      })

    Image(this.isPcResidentAbility() ? this.getPresetForeground() : this.foregroundDescriptor)
      .draggable(false)
      .height(this.iconSize * HoverEffectConstants.ADAPTIVE_SCALE)
      .width(this.iconSize * HoverEffectConstants.ADAPTIVE_SCALE)
      .objectFit(ImageFit.Contain)
      .interpolation(ImageInterpolation.Medium)
      .autoResize(false)
      .syncLoad(true)
      .scale({ x: this.foregroundScale, y: this.foregroundScale })
      .translate({
        x: this.foregroundTranslateX,
        y: this.foregroundTranslateY,
      })
      .rotate({
        x: this.rotateX,
        y: this.rotateY,
        z: 0,
        centerX: '50%',
        centerY: '50%',
        perspective: HoverEffectConstants.CAMERA_DISTANCE,
        angle: this.foregroundRotateAngle
      })
  }

  @Builder
  updateAlignmentCenterBuilder() {
    Stack({ alignContent: Alignment.Center }) {
      if (this.updateIconReady) {
        Image(this.icon).draggable(false)
          .interpolation(ImageInterpolation.Medium)
          .autoResize(false)
          .syncLoad(true)
      }
    }
    .height(this.iconSize)
    .width(this.iconSize)
    .clip(true)
    .borderRadius(this.mBaseBorderRadius)
    .rotate({
      x: this.rotateX,
      y: this.rotateY,
      z: 0,
      centerX: '50%',
      centerY: '50%',
      perspective: HoverEffectConstants.CAMERA_DISTANCE,
      angle: this.backgroundRotateAngle
    })
  }

  build() {
    Badge({
      count: this.badgeNumber,
      maxCount: StyleConstants.MAX_BADGE_COUNT,
      style: {
        color: StyleConstants.DEFAULT_FONT_COLOR,
        fontSize: this.badgeFontSize * this.mBadgeScale,
        badgeSize: (this.badgeNumber > 0 ? this.mBadgeSize * this.mBadgeScale : 0),
        badgeColor: Color.Red
      },
      position: this.badgeManager.getBadgePostion(this.badgeNumber, this.badgeFontSize * this.mBadgeScale,
        this.iconSize)
    }) {
      Flex() {
        Stack({ alignContent: Alignment.Center }) {
          if (this.isAdaptiveIcon) {
            this.alignmentCenterBuilder();
            this.shadowPixelmapBuilder();
          } else {
            this.updateAlignmentCenterBuilder();
          }
        }
      }
      .clip(true)
      .borderRadius(this.mBaseBorderRadius)
      .enabled(false)
      .shadow({
        radius: SmartDockConstants.DOCK_ITEM_HOVER_SHADOW_RADIUS,
        color: SmartDockConstants.DOCK_ITEM_HOVER_SHADOW_COLOR,
        offsetY: SmartDockConstants.DOCK_ITEM_HOVER_SHADOW_OFFSETY_ONE,
        offsetX: SmartDockConstants.DOCK_ITEM_HOVER_SHADOW_OFFSETX_ONE
      })
    }
    .visibility(this.hoverVisibility)
    .scale({ x: this.baseScale, y: this.baseScale })
    .enabled(false)
    .height(this.iconSize)
    .width(this.iconSize)
  }
}