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

import { LogDomain, Logger } from '@ohos/basicutils';
import { BaseViewController } from '@ohos/frameworkcommon';
import {
  reportIntervalMgr,
  ReportIntervalManager,
  viewMgrPolicy,
  ViewArea,
  ViewType,
  ViewCallback,
  GlobalContext,
  EventManager,
  EvtBus,
  WallpaperChangeEvent,
  AccessibilityManager
} from '@ohos/frameworkwrapper';
import { SCBScreenProperty, SCBScreenSessionManager, SCBPropertyChangeReason } from '@ohos/windowscene'
import StyleConfiguration, { BrightnessPanelComponentStyle } from '../common/StyleConfiguration';
import systemParameter from '@ohos.systemparameter';
import lazy { multiInputManager } from '@ohos/multiinput/src/main/ets/default/common/MultiInputManager';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import mBrightnessManager from '../common/BrightnessManager';
import display from '@ohos.display';
import { ColorModeViewModel, ColorModeViewData } from '@ohos/systemuicommon/Index';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { ConfigurationConstant } from '@kit.AbilityKit';
import lazy { AccessibilityUtil } from '@ohos/screenlockcommon';

const TAG = 'BrightnessPanel-Index';
const TIMEOUT_SHORT = 2000;
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

@Component
export struct SCBBrightnessPanel {
  persistentId: number = 0;
  mInterval: number = TIMEOUT_SHORT;
  screenProp: SCBScreenProperty | null = null;
  screenWidth: number = 0;
  screenHeight: number = 0;
  @State mWallpaperAvgColor: string = '#00ffffff';
  @State brightnessPanelCtrl: BaseViewController = new BaseViewController(ViewType.BRIGHTNESS_PANEL);
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @StorageLink('BrightnessValue4Panel') brightnessValue: number = 0;
  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext().config.colorMode as number;
  @State draggingViewData: BrightnessDraggingViewData = new BrightnessDraggingViewData();
  private mViewCallback: ViewCallback = {
    onShow: (): void => undefined
  };
  private previousShowTimerHandle: number = 0;
  private eventManager: EventManager = EvtBus.createEventManager();
  private minNum: number = 0;
  private maxNum: number = 0;
  private mComponentStyle: BrightnessPanelComponentStyle = StyleConfiguration.getBrightnessPanelComponentStyle();
  private defaultDisplay: display.Display | undefined = undefined;
  private isSupportBrightnessMultiInputFeature: boolean = false;
  private currentEndPositionX: number = 0;
  private lastX: number = 0;
  public brightnessUIValue: number = 0;

  async init(): Promise<void> {
    multiInputManager.registerFnF1Event(() => {this.onBrightnessDownChange()});
    multiInputManager.registerFnF2Event(() => {this.onBrightnessUpChange()});
    this.brightnessPanelCtrl.registerCallback(this.mViewCallback);
  }

  onBrightnessDownChange(): void {
    log.showInfo(TAG, 'onBrightnessDownChange');
    viewMgrPolicy.showView(ViewType.BRIGHTNESS_PANEL);
    const updatedValue = mBrightnessManager.subValue();
    if (updatedValue) {
      this.sendAccessibilityOnBrightnessChange(mBrightnessManager.countUIValue(updatedValue));
    }
    this.autoDismissBrightnessWindow();
    reportIntervalMgr.addEventCount(ReportIntervalManager.BRIGHTNESS_DOWN);
  }

  onBrightnessUpChange(): void {
    log.showInfo(TAG, 'onBrightnessUpChange');
    viewMgrPolicy.showView(ViewType.BRIGHTNESS_PANEL);
    const updatedValue = mBrightnessManager.addValue();
    if (updatedValue) {
      this.sendAccessibilityOnBrightnessChange(mBrightnessManager.countUIValue(updatedValue));
    }
    this.autoDismissBrightnessWindow();
    reportIntervalMgr.addEventCount(ReportIntervalManager.BRIGHTNESS_UP);
  }

  autoDismissBrightnessWindow() {
    log.showInfo(TAG, 'autoDismissBrightnessWindow');
    if (!this.draggingViewData.isDragging) {
      this.clearWindowTimer();
      this.previousShowTimerHandle = setTimeout(() => {
        viewMgrPolicy.hideView(ViewType.BRIGHTNESS_PANEL);
      }, this.mInterval);
    }
  }

  onDraggingStop() {
    log.showDebug(TAG, 'onDraggingStop');
    if (this.draggingViewData.isDragging) {
      this.autoDismissBrightnessWindow();
    }
  }

  private clearWindowTimer(): void {
    if (this.previousShowTimerHandle > 0) {
      clearTimeout(this.previousShowTimerHandle);
      this.previousShowTimerHandle = 0;
    }
  }

  screenPropertyChangeCallbacks = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    if (reason === SCBPropertyChangeReason.CHANGE_MODE || reason === SCBPropertyChangeReason.FOLD_SCREEN_ROTATION ||
      reason === SCBPropertyChangeReason.FOLD_TO_EXPAND || reason == SCBPropertyChangeReason.EXPAND_TO_FOLD ||
      reason === SCBPropertyChangeReason.FOLD_LANDSCAPE_START || reason === SCBPropertyChangeReason.ROTATION ||
      reason === SCBPropertyChangeReason.PAGE_ROTATION) {
      const brightnessPanelWidth: number = this.mComponentStyle.panelWidth;
      const brightnessPanelHeight: number = this.mComponentStyle.panelHeight;
      const brightnessWindowTop = px2vp(this.mComponentStyle.panelTop) + (brightnessPanelHeight / 2);
      const brightnessWindowLeft = (px2vp(screenProperty.width) - brightnessPanelWidth) / 2;
      log.showInfo(TAG, `brightnessWindowLeft: ${brightnessWindowLeft}`);
      this.brightnessPanelCtrl.updateId(this.persistentId);
      const rect: ViewArea = {
        left: brightnessWindowLeft,
        top: brightnessWindowTop,
        width: brightnessPanelWidth,
        height: brightnessPanelHeight
      }
      this.brightnessPanelCtrl.updateRect(rect);
    }
  }

  private registerScreenPropertyChange(): void {
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(this.screenPropertyChangeCallbacks, undefined, false, this.persistentId);
  }

  private unregisterScreenPropertyChange(): void {
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenPropertyChangeCallbacks(this.screenPropertyChangeCallbacks, undefined, false, this.persistentId);
  }

  private getBrightnessVolumeBlackBg(): BrightnessOptions | undefined {
    return this.isSupportBrightnessMultiInputFeature ? BrightnessOptionUtils.brightnessVolumeBlackBg :
      this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
      BrightnessOptionUtils.brightnessVolumeBlackBgDark : BrightnessOptionUtils.brightnessVolumeBlackBgLight
  }

  private getBrightnessVolumeWhiteBg(): BrightnessOptions | undefined {
    return this.isSupportBrightnessMultiInputFeature ? BrightnessOptionUtils.brightnessVolumeWhiteBg :
      this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
      BrightnessOptionUtils.brightnessVolumeWhiteBgDark : BrightnessOptionUtils.brightnessVolumeWhiteBgLight
  }

  private sendAccessibilityOnBrightnessChange(uiValue: number): void {
    if (AccessibilityManager.getInstance().getIsAccessibilityMode()) {
      const percentage: string = mBrightnessManager.getBrightnessPercentage(uiValue);
      const accessibilityText: string =
        ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_change_brightness'), `${percentage}%}`)
      AccessibilityUtil.sendAccessibility(accessibilityText);
    }
  }

  public handleOnTouch(event?: TouchEvent): void {
    if (this.draggingViewData.isDragging && event && event?.type === TouchType.Move) {
      event?.stopPropagation();
    }
    return;
  }

  public onPanActionStart(event: GestureEvent) {
    log.showInfo(TAG, 'onActionStart');
    if (!this.draggingViewData.isDragging) {
      this.draggingViewData.isDragging = true;
    }
    this.currentEndPositionX = mBrightnessManager.countUIValue(this.brightnessValue);
    this.lastX = event?.offsetX ?? 0;
  }

  public onPanActionUpdate(event: GestureEvent) {
    if (!this.draggingViewData.isDragging) {
      log.showDebug(TAG, 'onActionUpdate, not dragging, return');
      return;
    }
    if (event?.offsetX) {
      let moveDistance: number = event?.offsetX - this.lastX;
      if (Math.abs(moveDistance) < Number.EPSILON) {
        return;
      }
      this.lastX = event?.offsetX;
      this.currentEndPositionX += moveDistance;
      this.brightnessUIValue = this.currentEndPositionX;
      this.onCurrentEndPositionXChange();
    }
  }

  private onCurrentEndPositionXChange() {
    if (!this.draggingViewData.isDragging) {
      log.showDebug(TAG, 'onCurrentEndPositionXChange,but not dragging, return');
      return;
    }
    mBrightnessManager.setBrightnessValue(mBrightnessManager.countPhysicalValue(this.brightnessUIValue));
    this.sendAccessibilityOnBrightnessChange(this.brightnessUIValue);
  }

  public onPanActionEnd(event: GestureEvent) {
    log.showInfo(TAG, 'touch cancel');
    if (!this.draggingViewData.isDragging) {
      log.showDebug(TAG, 'onActionEnd, not dragging, return');
      return;
    }
    this.draggingViewData.isDragging = false;
    log.showInfo(TAG, `isDragging: ${this.draggingViewData.isDragging}`);
    let physicsValue: number = mBrightnessManager.countPhysicalValue(this.brightnessUIValue);
    log.showDebug(TAG, `onActionEnd, UI value: ${this.brightnessUIValue}, physicsValue: ${physicsValue}`);
    mBrightnessManager.setBrightnessValue(physicsValue);
    this.sendAccessibilityOnBrightnessChange(this.brightnessUIValue);
    this.autoDismissBrightnessWindow();
  }

  public onTapAction(event: GestureEvent) {
    animateTo({
      curve: Curve.EaseOut,
      tempo: 5
    }, () => {
      if (event?.fingerList[0]?.localX === undefined) {
        return;
      }
      this.brightnessUIValue = event?.fingerList[0]?.localX === undefined ? this.brightnessUIValue :
        event?.fingerList[0]?.localX;
    });
    mBrightnessManager.setBrightnessValue(mBrightnessManager.countPhysicalValue(this.brightnessUIValue));
    this.sendAccessibilityOnBrightnessChange(this.brightnessUIValue);
  }

  aboutToAppear() {
    log.showInfo(TAG, 'aboutToAppear Start');
    try {
      this.defaultDisplay = display.getDefaultDisplaySync();
    } catch (error) {
      log.showError(TAG, '[aboutToAppear] display.getDefaultDisplaySync error' + JSON.stringify(error));
      return;
    }
    if (mBrightnessManager.isSupportBrightnessMultiInputFeature()) {
      this.isSupportBrightnessMultiInputFeature = true;
    }
    viewMgrPolicy.registerViewController(ViewType.BRIGHTNESS_PANEL, this.brightnessPanelCtrl);
    this.maxNum = Number.parseInt(systemParameter.getSync('const.display.brightness.max'));
    this.minNum = Number.parseInt(systemParameter.getSync('const.display.brightness.min'));
    log.showInfo(TAG, `minNum: ${this.minNum} maxNum: ${this.maxNum}`);
    this.init();
    this.screenWidth = this.screenProp ? px2vp(this.screenProp?.width) : 0;
    this.screenHeight = this.screenProp ? px2vp(this.screenProp?.height) : 0;
    const brightnessPanelWidth: number = this.mComponentStyle.panelWidth;
    const brightnessPanelHeight: number = this.mComponentStyle.panelHeight;
    const brightnessWindowTop = px2vp(this.mComponentStyle.panelTop) + (brightnessPanelHeight / 2);
    const brightnessWindowLeft = (px2vp(this.defaultDisplay.width) - brightnessPanelWidth) / 2;
    log.showInfo(TAG, `brightnessWindowLeft: ${brightnessWindowLeft}`);
    this.brightnessPanelCtrl.updateId(this.persistentId);
    const rect: ViewArea = {
      left: brightnessWindowLeft,
      top: brightnessWindowTop,
      width: brightnessPanelWidth,
      height: brightnessPanelHeight
    }
    this.brightnessPanelCtrl.updateArea(rect);
    this.brightnessPanelCtrl.updateRect(rect);
    this.registerScreenPropertyChange();
    this.eventManager.on(WallpaperChangeEvent, (data: WallpaperChangeEvent) => {
      this.mWallpaperAvgColor = data.avgColor;
    });
  }

  aboutToDisappear() {
    this.unregisterScreenPropertyChange();
    this.brightnessPanelCtrl.unRegisterCallback(this.mViewCallback);
    multiInputManager.unregisterFnF1Event();
    multiInputManager.unregisterFnF2Event();
    this.eventManager.offAll();
    log.showInfo(TAG, 'aboutToDisAppear');
  }

  build() {
    if (mBrightnessManager.isSupportBrightnessMultiInputFeature()) {
      Row() {
        Row() {
          this.brightnessBuilder();
        }
      }
      .backgroundColor(this.mWallpaperAvgColor)
      .width(this.mComponentStyle.panelBorderWidth)
      .height(this.mComponentStyle.panelHeight)
      .borderRadius(this.mComponentStyle.brightnessBorderRadius)
      .visibility(this.brightnessPanelCtrl.isShowing() ? Visibility.Visible : Visibility.Hidden)
    }
  }

  @Builder
  brightnessBuilder() {
    Stack() {
      Column()
        .width(this.mComponentStyle.brightnessWidth)
        .height(this.mComponentStyle.brightnessHeight)
        .backgroundColor(this.mComponentStyle.brightnessBgColor)
        .backgroundBrightnessInternal(this.getBrightnessVolumeBlackBg())
      Column()
        .width(mBrightnessManager.countUIValue(this.brightnessValue))
        .height(this.mComponentStyle.brightnessHeight)
        .backgroundColor(this.mComponentStyle.brightnessBlockColor)
        .backgroundBrightnessInternal(this.getBrightnessVolumeWhiteBg())
      Image($r('app.media.ic_brightness')).draggable(false)
        .width(this.mComponentStyle.imageWidth)
        .height(this.mComponentStyle.imageHeight)
        .margin({left:5})
        .fillColor(this.mComponentStyle.sunFillColor)
        .hitTestBehavior(HitTestMode.Transparent)
    }
    .gesture(GestureGroup(GestureMode.Exclusive,
      PanGesture({ direction: PanDirection.Horizontal, distance: 2, fingers: 1 })
        .onActionStart((event: GestureEvent) => this.onPanActionStart(event))
        .onActionUpdate((event: GestureEvent) => this.onPanActionUpdate(event))
        .onActionEnd((event: GestureEvent) => this.onPanActionEnd(event)),
      TapGesture()
        .onAction((event: GestureEvent) => {
          this.onTapAction(event);
        }))
    )
    .onTouch((event?: TouchEvent) => this.handleOnTouch(event))
    .alignContent(Alignment.Start)
    .clip(true)
    .width(this.mComponentStyle.brightnessWidth)
    .height(this.mComponentStyle.brightnessHeight)
    .borderRadius(this.mComponentStyle.brightnessBorderRadius)
    .hitTestBehavior(this.isSupportBrightnessMultiInputFeature ? HitTestMode.Transparent : HitTestMode.Default)
    .backgroundEffect({
      policy: 1,
      radius: 200,
      saturation: 1.2
    })
    .opacity(1)
    .accessibilityDefaultFocus(true)
    .accessibilityGroup(true)
    .accessibilityLevel('yes')
    .accessibilityText(ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_brightness'),
      `${mBrightnessManager.getBrightnessPercentage(mBrightnessManager.countUIValue(this.brightnessValue))}%`))
    .accessibilityDescription(ResUtils.getInnerString($r('app.string.cc_accessibility_str_change_brightness_desc')))
  }
}

@Observed
export class BrightnessDraggingViewData {
  public isDragging: boolean = false;
  public currentEndPositionX: number = 0;

  public reset(): void {
    this.isDragging = false;
    this.currentEndPositionX = 0;
  }
}