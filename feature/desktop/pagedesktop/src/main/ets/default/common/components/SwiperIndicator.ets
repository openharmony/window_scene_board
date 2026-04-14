/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  LogDomain,
  LogHelper,
  TraceUtil,
  DomainName,
  CheckEmptyUtils,
  RectInfo,
  SingleContext
} from '@ohos/basicutils'
import {
  SCBUnlockTransitionController,
  SCBTransitionManager,
  SCBSceneSessionManager
} from '@ohos/windowscene';
import { RTLUtil, ItemUtils } from '@ohos/componenthelper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { StyleConstants, LayoutViewModel, PageInfoManager } from '@ohos/launchercommon';
import { WallpaperConstants } from '@ohos/commonconstants';
import curves from '@ohos.curves';
// import apsManager from '@hms.graphic.apsManager';
import {
  ViewCallback,
  viewMgrPolicy,
  ViewType,
  TextColor,
  ApsUtils,
  HiSysEventUtil,
  WallpaperColorManager,
  DeviceHelper
} from '@ohos/frameworkwrapper';
import { AttributeUpdater } from '@ohos.arkui.modifier';
import { DeviceState } from '@ohos/launchercommon';
import DesktopUtils from '../DesktopUtils';
import IndicatorConstants from '../constants/IndicatorConstants';
import systemParameter from '@ohos.systemparameter';
import { EditModeState } from '@ohos/launchercommon/src/main/ets/editmode/data/EditModeState';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import { JSON } from '@kit.ArkTS';
import { EventConstants } from '@ohos/launchercommon';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { SwiperIndicatorCallBack,
  SwiperLoadManager } from '@ohos/launchercommon/src/main/ets/cache/layout/SwiperLoadManager';
import { ItemAnimationParams } from '@ohos/launchercommon/Index';
import { DisplayCountViewModel } from '@ohos/launchercommon/src/main/ets/displaycount/DisplayCountViewModel';
import { DisplayCountData } from '@ohos/launchercommon/src/main/ets/displaycount/DisplayCountData';
import { PageDesktopViewModel } from '../viewmodel/PageDesktopViewModel';
import { LengthMetrics } from '@kit.ArkUI';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import {
  EditModeDragPageData,
  EditModeDragPageTipTextData,
  pageEditManager } from '@ohos/launchercommon/Index';

const TAG = 'SwiperIndicator';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const SELECT_SWIPER_SATURATE: number = 1.3;
const LIGHT_COLOR: string = '#33000000';
const LIGHT_SELECT_COLOR: string = '#FF3C3C3C';

export enum IndicatorStatus {
  UNSELECTED,
  CURRENT_SELECTED,
  NEXT_SELECTED,
}

export class IndicatorController {
  private indicator: SwiperIndicator | null = null
  updateValues(offsetX: number) {
    if (this.indicator) {
      this.indicator.updateValues(offsetX);
    }
  }
  bindSwiperIndicator(indicator: SwiperIndicator) {
    this.indicator = indicator;
  }
}

// 使用Stack替换Rect修复AttributeModify更新问题
class RectModifier extends AttributeUpdater<StackAttribute> {
  private offset: number = 0;
  private width: number = 0;
  public initValues(offset: number, width: number) {
    this.offset = offset;
    this.width = width;
  }
  initializeModifier(instance: StackAttribute) {
    instance.translate({ x: this.offset, y: 0 })
      .width(this.width)
  }
}

// 使用Stack替换Circle修复AttributeModify更新问题
class CircleModifier extends AttributeUpdater<StackAttribute> {
  private color: ResourceColor = '';

  constructor(color: ResourceColor = '') {
    super();
    this.color = color;
  }

  public initValues(color: ResourceColor) {
    this.color = color;
  }
  initializeModifier(instance: StackAttribute) {
    instance.backgroundColor(this.color)
  }
}

class CircleModifierManager {
  private circleModifierArray: Array<CircleModifier> = [];
  getModifierByIndex(index: number, defaultColor: ResourceColor = '') {
    if (!this.circleModifierArray[index] || !this.circleModifierArray[index].attribute) {
      this.circleModifierArray[index] = new CircleModifier(defaultColor);
    }
    this.circleModifierArray[index].attribute?.backgroundColor(defaultColor);
    return this.circleModifierArray[index];
  }
}

@Component
export default struct SwiperIndicator {
  private offsetX: number = 0;
  @Prop singleContext?: SingleContext;
  @StorageLink('pageIndex') @Watch('refreshModifier') pageIndex: number = 0;
  @StorageLink('outerPageIndex') @Watch('refreshModifier') outerPageIndex: number = 0;
  private pagesLength: number = 0;
  private pages: number[] = [];
  @State indicatorArray: number[] = [];
  @State swiperColor: string = WallpaperConstants.SWIPER_WHITE_COLOR;
  @State swiperSelectedColor: string = WallpaperConstants.SWIPER_WHITE_COLOR_SELECTED;
  @StorageLink('folderStatus') folderStatus: number = DeviceState.DEFAULT_STATE;
  @StorageLink('screenWidth') screenWidth: number = 0;
  @StorageProp('screenHeight') screenHeight: number = 0;
  @StorageProp('wallpaperChangeFlag') @Watch('updateSwiperColor') wallpaperValue : boolean = true;
  @State @Watch('updateSwiperColor') isInEditMode: boolean = editModeManager.isInEditMode();
  @State translateX: number = 0;
  @State translateY: number = 0;
  @State scaleSize: number = 1;
  @State alpha: number = 1;
  @State visible: Visibility = Visibility.Visible;
  @State @Watch('onUnLockReceived') isUnLockReceived: boolean = false;
  @State @Watch('refreshModifier') editModeState: EditModeState = editModeManager.getEditModeState();
  private unLockTransitionController: SCBUnlockTransitionController = {
    name: `${TAG}_indicator`,
    onLock: (): void => this.IndicatorOnLockReceived(),
    onUnlock: (): void => {},
    onUnlockStartScene: (): void => this.onUnLockReceivedPrepare(),
    onUnlockAnimation: (): void => this.IndicatorOnUnLockReceived(),
  };
  private controller: IndicatorController | null = null;
  private rectModifier: RectModifier = new RectModifier();
  private circleModifierManager: CircleModifierManager = new CircleModifierManager();
  private expandPages: number[] = [0];
  private curveValueTranslate: curves.ICurve = curves.cubicBezierCurve(0.4, 0, 1, 1);
  private curveValueLeft: curves.ICurve = curves.cubicBezierCurve(1, 0, 1, 1);
  private curveValueRight: curves.ICurve = curves.cubicBezierCurve(0.2, 0, 1, 1);
  private isFactoryMode: boolean = systemParameter.getSync('const.runmode', 'default') === 'factory';
  private isOuterDesktop: boolean = false;
  private textColor: TextColor | undefined = this.isOuterDesktop ? WallpaperColorManager.getInstance().mOuterTextColor :
  WallpaperColorManager.getInstance().mTextColor;
  private mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance(this.singleContext);
  private centerX: number = 0;
  private centerY: number = 0;
  private RTL_X: number = px2vp(5);
  @State @Watch('updateAddIndicatorShow') canAddPageShow: boolean = pageEditManager.canAddPageShow();
  @State editModeDragPageTipTextData: EditModeDragPageTipTextData = pageEditManager.editModeDragPageTipTextData;
  @State @Watch('updateAddPageShow') editModeDragPageData: EditModeDragPageData = pageEditManager.dragPageData;
  private displayCountViewModel: DisplayCountViewModel = DisplayCountViewModel.getInstance();
  @State @Watch('refreshModifier') displayCountData: DisplayCountData = this.displayCountViewModel.getDisplayCountData();
  @State addIndicatorList: number[] = [0];

  aboutToAppear(): void {
    SCBSceneSessionManager.getInstance().registerUnlockTransitionCallback(this.unLockTransitionController);
    viewMgrPolicy.registerViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
    if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
      this.visible = Visibility.Hidden;
    }
    if (this.controller) {
      this.controller.bindSwiperIndicator(this);
    }
    this.rectModifier.initValues(this.getBgTranslate(), this.getBgWidth());
    this.indicatorArray = this.pages;
    this.indicatorArray.forEach((val: number, index: number) => {
      let circleModifier = this.circleModifierManager.getModifierByIndex(index, this.swiperColor);
      circleModifier.initValues(this.swiperColor)
    });
    this.initIndicatorCallBack();
    this.updateSwiperColor();
  }


  aboutToDisappear(): void {
    SCBSceneSessionManager.getInstance().unregisterUnlockTransitionCallback(this.unLockTransitionController);
    viewMgrPolicy.unRegisterViewCallback(ViewType.KEYGUARD, this.keyguardCallback);
  }

  private updateAddPageShow(): void {
    this.canAddPageShow = pageEditManager.canAddPageShow();
  }

  private updateAddIndicatorShow(): void {
    this.addIndicatorList = new Array(this.displayCountViewModel.getDisplayCount()).fill(0);
  }

  private initIndicatorCallBack(): void {
    let callBack: SwiperIndicatorCallBack = {
      updatePages: (pages: number[]) => { this.updatePages(pages)}
    }
    SwiperLoadManager.getInstance(this.isOuterDesktop).setSwiperIndicator(callBack);
  }

  updatePages(pages: number[]): void {
    this.pages = pages;
    this.updateAddPageShow();
    this.indicatorArray = this.pages;
    this.refreshModifier();
  }

  updateSwiperColor(): void {
    let wallpaperColorManager : WallpaperColorManager = WallpaperColorManager.getInstance();
    this.editModeDragPageTipTextData.dragPageTipTextColor = wallpaperColorManager.mTextColor?.mTextColor ?? '';
    let swiperColor: string | undefined = this.isOuterDesktop ?
    wallpaperColorManager.mOuterSwiperColor : wallpaperColorManager.mSwiperColor;
    let swiperSelectedColor: string | undefined = this.isOuterDesktop ?
    wallpaperColorManager.mOuterSwiperSelectedColor : wallpaperColorManager.mSwiperSelectedColor;
    // 获取导航点颜色为空异常处理
    if (!swiperColor || !swiperSelectedColor) {
      log.showError(`updateSwiperColor mSwiperColor or mSwiperSelectedColor error`);
      return;
    }
    this.swiperColor = this.isInEditMode && this.IsWhiteWallPaper() ? LIGHT_COLOR : swiperColor;
    this.swiperSelectedColor =
      this.isInEditMode && this.IsWhiteWallPaper() ? LIGHT_SELECT_COLOR : swiperSelectedColor;
    log.showDebug('swiperColor is' + this.swiperColor);
    log.showDebug('swiperSelectedColor is' + this.swiperSelectedColor);
    this.refreshModifier();
  }

  refreshModifier(): void {
    if (!launcherStatusUtil.isCurrentDesktopVisible(this.isOuterDesktop)) {
      return;
    }
    this.updateAddPageShow();
    this.updateValues(0);
  }

  updateValues(offsetX: number) {
    log.showInfo(`offsetX = ${offsetX}`)
    this.offsetX = offsetX;
    this.rectModifier.attribute?.width(this.getBgWidth())
      .translate({ x: this.getBgTranslate() });
    this.indicatorArray.forEach((val: number, index: number) => {
      let circleModifier = this.circleModifierManager.getModifierByIndex(index, this.swiperColor);
      circleModifier.attribute?.backgroundColor(this.getFillColor(index));
    })
  }

  private getBgWidth(): number {
    if (this.folderStatus === DeviceState.DEFAULT_STATE) {
      return IndicatorConstants.FOLD_WIDTH_OF_SELECTED_INDICATOR;
    }

    let displayCount = this.displayCountData.getDisplayCount();
    if (displayCount === 1) {
      return IndicatorConstants.FOLD_WIDTH_OF_SELECTED_INDICATOR;
    }
    let isRTL = RTLUtil.isRTL();
    let rightValue: number = isRTL ? this.getSelectIndicatorForRTL(false) : this.getSelectIndicator(false);
    let leftValue: number = isRTL ? this.getSelectIndicatorForRTL(true) : this.getSelectIndicator(true);
    let width =
      IndicatorConstants.WIDTH_OF_INDICATOR * displayCount + IndicatorConstants.EXPAND_INDICATOR_SELECTED_PADDING * 2 +
        IndicatorConstants.INDICATOR_SPACE * (displayCount - 1);
    log.showInfo('displayCount:%{public}d, right:%{public}d, left:%{public}d, width:%{public}d, result:%{public}d',
      displayCount, rightValue, leftValue, width, rightValue - leftValue + width);
    return rightValue - leftValue + width;
  }

  private getBgTranslate(): number {
    if (RTLUtil.isRTL()) {
      return this.getBgTranslateForRTL();
    }
    let leftVaule: number = this.getSelectIndicator(true);
    log.showDebug(`getBgTranslate leftVaule = ${leftVaule}`)
    return leftVaule;
  }

  private getBgTranslateForRTL(): number {
    let leftValue: number = this.getSelectIndicatorForRTL(true);
    let distX: number = IndicatorConstants.INDICATOR_DISTANCE;
    if (this.folderStatus === DeviceState.DEFAULT_STATE) {
      leftValue = leftValue + (this.isOuterDesktop ? 0 : distX);
      return this.offsetX === 0 ? -1 * leftValue : -1 * leftValue - distX * (this.offsetX / this.screenWidth);
    }
    // 折叠屏场景
    leftValue = leftValue + this.RTL_X;
    leftValue = this.isOuterDesktop ? leftValue : leftValue + distX;
    if (this.offsetX === 0) {
      return -1 * leftValue;
    }
    let displayCount = this.displayCountData.getDisplayCount();
    // 根据屏幕数量计算时间值
    let realX = displayCount * distX;
    let curveL = this.curveValueLeft;
    let curveR = this.curveValueRight;
    if (this.offsetX > 0) {
      return -1 * leftValue + realX * curveL.interpolate((this.screenWidth - this.offsetX) / this.screenWidth) -
        realX * curveR.interpolate((this.offsetX / this.screenWidth)) - realX;
    }
    return -1 * leftValue + realX * curveL.interpolate(Math.abs(this.offsetX) / this.screenWidth) -
      realX * curveL.interpolate((this.screenWidth + this.offsetX) / this.screenWidth) + realX;
  }

  private IsWhiteWallPaper(): boolean {
    this.textColor = this.isOuterDesktop ? WallpaperColorManager.getInstance().mOuterTextColor :
    WallpaperColorManager.getInstance().mTextColor;
    if (this.textColor == null || this.textColor.mWallpaperType == null) {
      log.showError('textColor params error');
      return false;
    }
    log.showInfo(`mWallpaperType ${this.textColor.mWallpaperType}`)
    return this.textColor.mWallpaperType === WallpaperConstants.WALLPAPER_TYPE_ONE;
  }

  private getSelectBackGroundColor(): ResourceColor {
    if (this.folderStatus === DeviceState.DEFAULT_STATE) {
      return this.swiperSelectedColor;
    } else {
      return this.swiperColor;
    }
  }

  build() {
    Stack() {
      Row({ space: IndicatorConstants.INDICATOR_SPACE }) {
        ForEach(this.indicatorArray, (val: number, index: number) => {
          Stack()
            .width(IndicatorConstants.WIDTH_OF_INDICATOR)
            .height(IndicatorConstants.HEIGHT_OF_INDICATOR)
            .borderRadius(IndicatorConstants.WIDTH_OF_INDICATOR / 2)
            .visibility(this.folderStatus === DeviceState.DEFAULT_STATE && index >= this.pages.length ?
              Visibility.None : Visibility.Visible)
            .hitTestBehavior(HitTestMode.Transparent)
            .attributeModifier(this.circleModifierManager.getModifierByIndex(index, this.getFillColor(index)))
        }, (val: object, index: number) => {
          return JSON.stringify(index);
        })
        ForEach(this.addIndicatorList, (val: number, index: number) => {
          Image($r('app.media.ic_edit_add_indicator')).draggable(false)
            .id(`${TAG}_ic_edit_add_indicator`)
            .height(IndicatorConstants.HEIGHT_OF_NEGATIVE_SCREEN_INDICATOR)
            .width(IndicatorConstants.WIDTH_OF_NEGATIVE_SCREEN_INDICATOR)
            .objectFit(ImageFit.Contain)
            .fillColor(this.getFillColor(this.indicatorArray.length))
            .visibility(this.canAddPageShow ? Visibility.Visible : Visibility.None)
        }, (val: object, index: number) => {
          return JSON.stringify(index);
        })
      }
      .padding({ right: IndicatorConstants.WIDTH_OF_INDICATOR })
      .justifyContent(FlexAlign.Start)

      Stack()
        .hitTestBehavior(HitTestMode.Transparent)
        .borderRadius(IndicatorConstants.RADIUS_OF_INDICATOR)
        .padding(0)
        .height(this.displayCountData.getDisplayCount() !== 1 ? IndicatorConstants.EXPAND_HEIGHT_OF_SELECTED_INDICATOR :
        IndicatorConstants.FOLD_HEIGHT_OF_SELECTED_INDICATOR)
        .align(Alignment.Top)
        .backgroundColor(this.getSelectBackGroundColor())
        .saturate(SELECT_SWIPER_SATURATE)
        .attributeModifier(this.rectModifier)
    }
    // 编辑模式下点击导航点，拦截点击GridSwiper空白处退出编辑模式的事件
    .onTouchIntercept(() => {
      if (editModeManager.isInEditMode()) {
        return HitTestMode.Block
      }
      return HitTestMode.Default
    })
    .align(Alignment.Start)
    .height(IndicatorConstants.HEIGHT_OF_NEGATIVE_SCREEN_INDICATOR)
    .id(`${TAG}_indicator`)
    .translate({ x: this.translateX, y: this.translateY })
    .scale(this.getScaleOption())
    .onAppear(() => {
      SwiperLoadManager.getInstance(this.isOuterDesktop).loadIndicator();
    })
    .opacity(this.alpha)
    .visibility(this.visible)
  }

  private getScaleOption(): ScaleOptions {
    return {
      x: this.scaleSize,
      y: this.scaleSize,
      centerX: this.centerX,
      centerY: this.centerY,
    };
  }

  private getFillColorOpacity(indicatorStatus: IndicatorStatus): number {
    // 以偏移量和屏宽的比值为基础，线性计算indicator滑动时的模糊度
    let colorOpacity: number = Number(('0x' + this.swiperColor.slice(1, 3)));
    let selectedColorOpacity: number = Number(('0x' + this.swiperSelectedColor.slice(1, 3)));
    let opacityDiff: number = Math.abs(this.offsetX) / this.screenWidth * (selectedColorOpacity - colorOpacity);
    let opacity: number = colorOpacity;
    if (indicatorStatus === IndicatorStatus.CURRENT_SELECTED) {
      opacity = Math.round(Number(selectedColorOpacity - opacityDiff));
    } else if (indicatorStatus === IndicatorStatus.NEXT_SELECTED) {
      let opacityNum = Math.floor(Number(colorOpacity + opacityDiff)) < ((1 << StyleConstants.DEFAULT_8) - 1) ?
      Number(colorOpacity + opacityDiff) : Number((1 << StyleConstants.DEFAULT_8) - 1);
      opacity = Math.round(opacityNum);
    }
    return opacity;
  }

  private getPageIndex(): number {
    let curPageIndex: number = this.pageIndex;
    if (this.folderStatus !== DeviceState.DEFAULT_STATE) {
      let displayCount = this.displayCountViewModel.getDisplayCount();
      let yu = curPageIndex % displayCount;
      curPageIndex = curPageIndex - yu;
    }
    return this.isOuterDesktop ? this.outerPageIndex : curPageIndex;
  }

  private getFillColor(index: number): number {
    if (CheckEmptyUtils.isEmpty(this.swiperColor)) {
      log.showError('swiperColor is empty');
      this.swiperColor = WallpaperConstants.SWIPER_WHITE_COLOR;
    }
    if (CheckEmptyUtils.isEmpty(this.swiperSelectedColor)) {
      log.showError('swiperSelectedColor is empty');
      this.swiperSelectedColor = WallpaperConstants.SWIPER_WHITE_COLOR_SELECTED;
    }

    if (this.screenWidth === 0) {
      return Number(('0x' + this.swiperColor.slice(1, 9)));
    }

    if (this.folderStatus === DeviceState.DEFAULT_STATE) {
      return Number(('0x' + this.swiperColor.slice(1, 9)));
    }
    let curOffsetX: number = this.offsetX;
    let indicatorStatus: IndicatorStatus = IndicatorStatus.UNSELECTED;
    let curPageIndex: number = this.getPageIndex();
    if (this.displayCountData.getDisplayCount() === 2) {
      if (index === curPageIndex || index === curPageIndex + 1) {
        indicatorStatus = IndicatorStatus.CURRENT_SELECTED;
      } else if ((curOffsetX > 0 && !RTLUtil.isRTL() && (index === curPageIndex - 1 || index === curPageIndex - 2)) ||
        (curOffsetX <= 0 && !RTLUtil.isRTL() && (index === curPageIndex + 2 || index === curPageIndex + 3))) {
        indicatorStatus = IndicatorStatus.NEXT_SELECTED;
      } else if ((curOffsetX > 0 && RTLUtil.isRTL() && (index === curPageIndex + 2 || index === curPageIndex + 3)) ||
        (curOffsetX <= 0 && RTLUtil.isRTL() && (index === curPageIndex - 1 || index === curPageIndex - 2))) {
        indicatorStatus = IndicatorStatus.NEXT_SELECTED;
      }
    } else {
      if (PageInfoManager.getInstance().isCurrentPageShow(index, curPageIndex)) {
        indicatorStatus = IndicatorStatus.CURRENT_SELECTED;
      } else if (this.isNextPage(curOffsetX, index, curPageIndex)) {
        indicatorStatus = IndicatorStatus.NEXT_SELECTED;
      } else {
        indicatorStatus = IndicatorStatus.UNSELECTED;
      }
    }
    return (this.getFillColorOpacity(indicatorStatus) * Math.pow(16, 6)) + Number(('0x' + this.swiperSelectedColor.slice(3, 9)));
  }

  private isNextPage(curOffsetX: number, indexInSwiper: number, curPageIndex: number): boolean {
    let displayCount = this.displayCountViewModel.getDisplayCount();
    let isNext = RTLUtil.isRTL() && curOffsetX > 0 || !RTLUtil.isRTL() && curOffsetX < 0;
    if (isNext) {
      return indexInSwiper >= curPageIndex + displayCount && indexInSwiper < curPageIndex + displayCount * 2;
    }
    let min = Math.max(0, curPageIndex - displayCount);
    return indexInSwiper >= min && indexInSwiper < curPageIndex;
  }

  private keyguardCallback: ViewCallback = {
    onHide: (): void => this.onScreenOn(),
    onShow: (): void => this.onScreenOff()
  };

  private onScreenOff(): void {
    log.showInfo(' onScreenOff');
    this.visible = Visibility.Hidden;
    this.isUnLockReceived = false;
  }

  // ScreenOn 状态，主要避免锁屏状态下三方应用拉起，桌面无锁屏通知无法刷新界面
  // 此次修改和需要this.visible协同
  private onScreenOn(): void {
    log.showInfo(`onScreenOn and this.visible:${this.visible}`);
    if (this.visible != Visibility.Visible) {
      this.visible = Visibility.Visible;
    }
  }

  private onUnLockReceived() {
    if (!DesktopUtils.isSupportLockAnimation()) {
      return;
    }
    log.showInfo('onUnLockReceived    ' + this.isUnLockReceived);
    if (this.isUnLockReceived === false) {
      this.visible = Visibility.Hidden;
      return;
    }
    this.refreshModifier();
    this.visible = Visibility.Visible;
    if (!(AppStorage.get<boolean>('shieldAnim') ?? false)) {
      this.onUnlockReceiveWithSpaceAni();
    }
  }

  private onUnlockReceiveWithSpaceAni() {
    let obj: RectInfo = ItemUtils.getRectById(`${TAG}_indicator`);
    let itemAnimation: ItemAnimationParams = new ItemAnimationParams();
    itemAnimation.calUnlock(this.screenWidth, this.screenHeight, obj);
    this.centerX = itemAnimation.screenCenterX - itemAnimation.itemCenterX + itemAnimation.rectInfoWidth / 2;
    // 指示器和dock栏缩放中心在屏幕高度的0.6处
    this.centerY = itemAnimation.screenCenterY * 1.5 - itemAnimation.itemCenterY + itemAnimation.rectInfoHeight / 2;
    this.translateX = 0;
    this.translateY = 0;
    this.alpha = 0;
    this.scaleSize = 0.6;
    let delayValue: number =
      itemAnimation.getDelay(this.mPageDesktopViewModel.unlockMin, this.mPageDesktopViewModel.unlockMax);
    log.showInfo(HiSysEventUtil.INTO_HOME_ANI + ' begin');
    TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_LAUNCHER_ANIMATION);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.UNLOCK_TO_ENTER_DESKTOP, StyleConstants.DEFAULT_1);
    animateTo({
      delay: delayValue,
      curve: curves.springMotion(0.35, 0.8, 0),
      onFinish: () => {
        log.showInfo(HiSysEventUtil.INTO_HOME_ANI + ' end');
        TraceUtil.endAnimTrace(DomainName.KG, TraceUtil.UNLOCK_TO_HOME_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
        TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_LAUNCHER_ANIMATION);
        // ApsUtils.setApsScene(apsManager.SceneAnimation.UNLOCK_TO_ENTER_DESKTOP, StyleConstants.DEFAULT_0);
      },
    }, () => {
      this.translateX = 0;
      this.translateY = 0;
      this.scaleSize = 1;
      this.alpha = 1;
    });
  }

  private IndicatorOnLockReceived(): void {
    this.isUnLockReceived = false;
  }

  private onUnLockReceivedPrepare(): void {
    log.showInfo(`onUnLockReceivedPrepare`);
    this.visible = Visibility.Hidden;
  }

  private IndicatorOnUnLockReceived(): void {
    log.showInfo('IndicatorOnUnLockReceived');
    this.updateSwiperColor();
    this.isUnLockReceived = true;
  }

  private getSelectIndicator(isLeftSelectIndicator: boolean): number {
    let curScreenWidth: number = this.screenWidth;
    if (curScreenWidth === 0) {
      return 0;
    }
    let curPageIndex: number = this.getPageIndex();
    let curOffsetX: number = this.offsetX;
    const distanceX = IndicatorConstants.INDICATOR_DISTANCE;
    const currentPosX = distanceX * curPageIndex - (this.folderStatus !== DeviceState.DEFAULT_STATE ?
      IndicatorConstants.EXPAND_TRANSLATE_DIFF : IndicatorConstants.FOLD_TRANSLATE_DIFF);

    if (this.folderStatus !== DeviceState.DEFAULT_STATE) {
      let curveValue = isLeftSelectIndicator ? this.curveValueLeft : this.curveValueRight;
      let displayCount = this.displayCountData.getDisplayCount();
      if (curOffsetX > 0) {
        return (currentPosX +
          (distanceX * curveValue.interpolate((curScreenWidth - curOffsetX) / curScreenWidth) - distanceX) *
            displayCount);
      } else {
        return (currentPosX + distanceX * curveValue.interpolate(Math.abs(curOffsetX) / curScreenWidth) * displayCount);
      }
    } else {
      if (curOffsetX > 0) {
        return currentPosX - distanceX + distanceX * (curScreenWidth - curOffsetX) / curScreenWidth;
      } else {
        return currentPosX + distanceX * (Math.abs(curOffsetX) / curScreenWidth);
      }
    }
  }

  private getSelectIndicatorForRTL(isLeftSelectIndicator: boolean): number {
    let curScreenWidth: number = this.screenWidth;
    if (curScreenWidth === 0) {
      return 0;
    }
    let curPageIndex: number = this.getPageIndex();
    let curOffsetX: number = this.offsetX;
    const distanceX = IndicatorConstants.INDICATOR_DISTANCE;
    const currentPosX = distanceX * curPageIndex + (this.folderStatus !== DeviceState.DEFAULT_STATE ?
      IndicatorConstants.EXPAND_TRANSLATE_DIFF : IndicatorConstants.FOLD_TRANSLATE_DIFF);

    if (this.folderStatus === DeviceState.DEFAULT_STATE) {
      return currentPosX;
    }
    let displayCount = this.displayCountData.getDisplayCount();
    let curveValue = isLeftSelectIndicator ? this.curveValueLeft : this.curveValueRight;
    if (curOffsetX > 0) {
      return currentPosX +
        (distanceX * curveValue.interpolate((curScreenWidth - curOffsetX) / curScreenWidth) - distanceX) * displayCount;
    } else {
      return currentPosX + distanceX * curveValue.interpolate(Math.abs(curOffsetX) / curScreenWidth) * displayCount;
    }
  }
}