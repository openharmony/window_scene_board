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
  DeviceHelper,
  EventManager,
  EvtBus,
  HiSysEventUtil,
  PluginSlot,
  ViewCallback,
  ViewManagerPolicy,
  ViewType,
  WindowEvent,
  GlobalContext
} from '@ohos/frameworkwrapper';
import {
  AnimateToScheduleUtils,
  DomainName,
  SingletonHelper,
  Trace,
  TraceUtil,
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { HoverConstants } from '@ohos/commonconstants';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { ColorResourceUtils, DarkModeEvent, ThemeChangeEvent } from '@ohos/systemuicommon';
import {
  setBrightValue,
  ControlBrightnessManager
} from '@ohos/brightnesscomponent/src/main/ets/default/ControlBrightnessManager';
import {
  BrightnessAnimViewData,
  BrightnessDraggingViewData,
  BackgroundOpacity,
  BrightnessProgress,
  BackgroundBlurOpacity
} from '../model/BrightnessViewData';
import { curves } from '@kit.ArkUI';
import sBrightnessController from './BrightnessController';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { ScrollBlurEvent } from '@ohos/controlcentercommon/src/main/ets/scrollBlur/ScrollBlurEvent';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';
import { CommonData } from '@ohos/controlcentercommon/Index';
import { taskpool } from '@kit.ArkTS';
import lottie, { AnimationItem } from '@ohos/lottie';
import { ControlCenterPluginMgr } from '@ohos/controlcentercommon/src/main/ets/base/ControlCenterPluginMgr';
import { ControlCenterHiSysEventUtil } from '@ohos/controlcentercommon/src/main/ets/hiSysEvent/ControlCenterHiSysEventUtil';

const TAG = 'Ctrl.BrightnessViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

// pc模式下的资源参数
const BRIGHTNESS_WIDTH: number = 312;
/**
 * 鼠标滚轮每次滚动触发的手势事件偏移量为21的倍数
 */
const MOUSE_SCROLL_EVENT_OFFSET = 21;

enum BrightnessStatus {
  DEFAULT = 0,
  // 根据超出范围播放动画，深浅模式均显示蓝色
  DRAGGING_BEFORE_START = 1,
  // 深色模式显示白色，浅色模式显示黑色，回弹动效
  RELEASE_BEFORE_START = 2,
  // 根据亮度值播放动画，深浅模式均显示蓝色
  DRAGGING_BEFORE_SUN = 3,
  // 深色模式显示白色，浅色模式显示黑色
  RELEASE_BEFORE_SUN = 4,
  // 根据亮度值播放动画，显示蓝色
  DRAGGING_AFTER_SUN = 5,
  // 显示黑色
  RELEASE_AFTER_SUN = 6,
  // 根据超出范围播放动画，显示蓝色
  DRAGGING_AFTER_END = 7,
  // 显示黑色，回弹动效
  RELEASE_AFTER_END = 8,
}

/**
 * 横竖屏状态两个亮度条共享的数据
 */
export class BrightnessSharedViewData {
  private backgroundOpacity: BackgroundOpacity = new BackgroundOpacity();
  private blurOpacity: BackgroundBlurOpacity = new BackgroundBlurOpacity();

  public reset() {
    this.backgroundOpacity.reset();
    this.blurOpacity.reset();
  }

  public getBackgroundOpacity(): BackgroundOpacity {
    return this.backgroundOpacity;
  }

  public getBlurOpacity(): BackgroundBlurOpacity {
    return this.blurOpacity;
  }

  public static getInstance(): BrightnessSharedViewData {
    return SingletonHelper.getInstance(BrightnessSharedViewData, 'BrightnessSharedData');
  }
}

export class BrightnessViewModel {
  private readonly INVERT_COLOR_START: number = 25; // vp
  private readonly BRIGHTNESS_WIDTH: number =
    ControlCenterPluginMgr.isPcMode ? BRIGHTNESS_WIDTH : ResUtils.getConvertNumber($r('app.float.Control_center_brightness_width')); //vp
  private readonly START_FRAME_INDEX: number = 61; // frame
  private readonly END_FRAME_INDEX: number = 300; // frame
  private readonly TOTAL_FRAMES: number = 360; // frame
  // 颜色过渡动画的帧数
  private readonly COLOR_TRANSITION_FRAMES_SHORT: number = 5;
  // 回滚动画速度
  private readonly SCROLL_SPEED: number = 3;
  public mainCanvasRenderingContext: CanvasRenderingContext2D =
    new CanvasRenderingContext2D(new RenderingContextSettings(true));
  private lottieName: string = 'CCBrightnessSunIcon';
  private isPc: boolean = DeviceHelper.isPC();
  private isHad: boolean = DeviceHelper.isHAD();
  private brightnessRange: number = ControlBrightnessManager.getInstance().getMax() - ControlBrightnessManager.getInstance().getMin();
  private mouseScrollRange: number = 15;
  private isPanelDismissing: boolean = false;
  private startBrightness: number = 0;
  private animationItem: AnimationItem | undefined = undefined;
  private brightnessStatus: BrightnessStatus = BrightnessStatus.DEFAULT;
  private lastX: number = 0;
  private lastEndPositionX: number = 0;
  private colorTranslatorIntervalId: number = -1;
  private physicsValue: number = 0;
  private eventMgr: EventManager | undefined = undefined;
  private currentEndPositionX: number = 0;
  private viewData: BrightnessProgress = new BrightnessProgress();
  private draggingViewData: BrightnessDraggingViewData = new BrightnessDraggingViewData();
  private animViewData: BrightnessAnimViewData = new BrightnessAnimViewData();
  private blurOpacity: BackgroundBlurOpacity = BrightnessSharedViewData.getInstance().getBlurOpacity();
  private backgroundOpacity: BackgroundOpacity = BrightnessSharedViewData.getInstance().getBackgroundOpacity();

  private timeId: number = -1;
  private notifyHeadBlurTimeId: number = -1;
  private isCanvasReady: boolean = false;
  private isLandscapeBrightness: boolean = false;
  private loadCount: number = 0;
  private lastLoadTime: number = 0;
  private colorTool: ColorResourceUtils = new ColorResourceUtils(GlobalContext.getContext().resourceManager);
  private scrollBlurEvent: ScrollBlurEvent = new ScrollBlurEvent();
  private offsetXOfPrevious: number = 0;
  private isMouseScroll: boolean = false;

  public getViewData(): BrightnessProgress {
    return this.viewData;
  }

  public aboutToAppear(isLandscapeBrightness: boolean, physicsValue: number) {
    log.showInfo(`aboutToAppear: landscape:${isLandscapeBrightness}`);
    this.lottieName = this.lottieName + isLandscapeBrightness;
    this.isLandscapeBrightness = isLandscapeBrightness;
    this.physicsValue = physicsValue;
    this.viewData.brightnessUIValue = this.countUIValue();
    if (this.eventMgr === undefined) {
      this.eventMgr = EvtBus.createEventManager();
    }
    this.eventMgr.on(WindowEvent, (event: WindowEvent) => {
      if (event.isMatchName(PluginSlot.SLOT_STATUS_CONTROL_CENTER) && event.isWindowEndHide()) {
        this.animViewData.animateScale = HoverConstants.HOVER_DEFAULT_SCALE;
      }
    });
    this.eventMgr.on(DarkModeEvent, (event: DarkModeEvent) => {
      this.handleDarkModeEvent(event);
    });
    ViewManagerPolicy.registerViewCallback(ViewType.DROPDOWN, this.dropDownCallback);
    this.eventMgr.on(ThemeChangeEvent, () => {
      this.refreshSun();
    });
  }

  public aboutToDisappear() {
    log.showInfo(`aboutToDisappear: ${this.lottieName}`);
    this.endDraggingWithNoAnim();
    if (this.eventMgr !== undefined) {
      this.eventMgr.offAll();
    }
    ViewManagerPolicy.unRegisterViewCallback(ViewType.DROPDOWN, this.dropDownCallback);
  }

  initData(draggingData: BrightnessDraggingViewData, animData: BrightnessAnimViewData) {
    this.draggingViewData = draggingData;
    this.animViewData = animData;
  }

  public handleOnHover(isHover?: boolean): void {
    if (isHover === undefined) {
      return;
    }
    animateTo({
      duration: HoverConstants.HOVER_ANIMATE_DURATION,
      curve: Curve.Sharp
    }, () => {
      this.animViewData.isHover = isHover;
      this.animViewData.animateScale = isHover ? this.isHad ? HoverConstants.HAD_HOVER_BRIGHTNESS_SCALE :
      HoverConstants.HOVER_BRIGHTNESS_SCALE : HoverConstants.HOVER_DEFAULT_SCALE;
    });
  }

  public handleOnTouch(event: TouchEvent): void {
    this.brightnessClickAnimateTo(event);
  }

  public onPanActionStart(event: GestureEvent) {
    if (!event) {
      return;
    }
    this.startBrightness = this.physicsValue;
    this.isPanelDismissing = DropDownPanelManager.isPanelDismissing();

    if (this.isPanelDismissing) {
      log.showWarn('panel is dismissing');
      return;
    }
    if (!this.isPc && !ViewManagerPolicy.isViewShowing(ViewType.DROPDOWN)) {
      log.showWarn('panel is not showing');
      return;
    }
    log.showInfo('onActionStart');

    if (!this.draggingViewData.isDragging) {
      this.draggingViewData.isDragging = true;
    }

    this.currentEndPositionX = this.viewData.brightnessUIValue;
    AnimateToScheduleUtils.raiseAnimateToCPUPriority(0);
    this.timeId = setTimeout(() => {
      AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START);
      log.showInfo('start hide CC mainLayout');
      this.blurOpacity.blurOpacity = 0;
      this.animViewData.showBlurLayer = true;
      animateTo({
        curve: curves.responsiveSpringMotion(0.28, 1, 0),
      }, () => {
        this.animViewData.scaleX = 1.05;
      })
      this.notifyHeadBlurTimeId = setTimeout(() => {
        this.scrollBlurEvent.setValue(0);
        EvtBus.post(ScrollBlurEvent, this.scrollBlurEvent);
        this.notifyHeadBlurTimeId = -1;
      }, 120)
      animateTo({
        curve: curves.cubicBezierCurve(0.33, 0.0, 0.67, 1.0),
        duration: 150,
      }, () => {
        this.backgroundOpacity.backgroundOpacity = 0;
        this.animViewData.shadowRadius = 40;
      })
      this.timeId = -1;
    }, 100);

    this.lastX = (RTLUtil.isRTL() ? this.BRIGHTNESS_WIDTH - event?.offsetX : event?.offsetX) ?? 0;
    this.lastEndPositionX = 0;
    TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_SLIDING_BRIGHTNESS, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    // 鼠标滚轮逻辑
    if (event?.offsetX !== 0 && event?.axisVertical !== 0 && event?.axisHorizontal === 0) {
      log.showInfo('mouse scroll event start');
      this.offsetXOfPrevious = 0;
      this.isMouseScroll = true;
    }
  }

  public brightnessClickAnimateTo(event: TouchEvent) {
    if (event?.type !== TouchType.Down || event.touches.length <= 0 || this.draggingViewData.isDragging) {
      return;
    }
    animateTo({
      curve: Curve.EaseOut,
      tempo: 5
    }, () => {
      this.viewData.brightnessUIValue = this.countBrightnessUIValue(event);
      log.showInfo('on touch, refresh ui value: %{public}d', this.viewData.brightnessUIValue);
      this.refreshSun();
    });
    this.updateScreenBrightness(this.countPhysicsValue(this.viewData.brightnessUIValue), false);
    ControlCenterHiSysEventUtil.reportCCBrightnessClick({
      STARTVALUE: this.physicsValue,
      CLICKEDVALUE: this.countPhysicsValue(this.viewData.brightnessUIValue),
      ISNIGHTMODE: `${(AppStorage.get('DarkModeModel_DarkModeStatus') as CommonData)?.status}`,
      TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      LOCKSTATUS: AppStorage.get('lockStatus')
    })
  }

  public onPanActionUpdate(event: GestureEvent) {
    if (!event) {
      return;
    }
    if (this.isPanelDismissing) {
      log.showWarn('panel is dismissing');
      return;
    }
    if (!this.isPc && !ViewManagerPolicy.isViewShowing(ViewType.DROPDOWN)) {
      log.showWarn('panel is not showing');
      return;
    }
    if (!this.draggingViewData.isDragging) {
      log.showDebug('onActionUpdate, not dragging, return');
      return;
    }
    let moveDistance = (RTLUtil.isRTL() ? this.BRIGHTNESS_WIDTH - event?.offsetX : event?.offsetX) - this.lastX;
    if (this.isMouseScroll) {
      moveDistance = this.adjustBrightWithMouseScroll(event);
    }
    if (Math.abs(moveDistance - 0) < Number.EPSILON) {
      return;
    }
    this.lastX = RTLUtil.isRTL() ? this.BRIGHTNESS_WIDTH - event?.offsetX : event?.offsetX;
    // 鼠标滚轮调节亮度时，currentEndPositionX的值不能超出最大值或最小值
    if (this.isMouseScroll) {
      this.currentEndPositionX += moveDistance;
      this.offsetXOfPrevious = event?.offsetX;
      this.currentEndPositionX = Math.min(
        Math.max(this.currentEndPositionX, 0),
        this.BRIGHTNESS_WIDTH);
    } else {
      let dis = event?.offsetX - this.lastEndPositionX;
      this.currentEndPositionX = RTLUtil.isRTL() ? this.currentEndPositionX - dis :
        this.currentEndPositionX + dis;
    }
    this.lastEndPositionX = event?.offsetX;
    this.onCurrentEndPositionXChange();
  }

  public onPanActionEnd(event: GestureEvent) {
    log.showInfo('touch cancel');
    if (!this.draggingViewData.isDragging) {
      log.showDebug('onActionEnd, not dragging, return');
      return;
    }
    if (this.isPanelDismissing) {
      log.showWarn('panel is dismissing');
      return;
    }
    if (!this.isPc && !ViewManagerPolicy.isViewShowing(ViewType.DROPDOWN)) {
      log.showWarn('panel is not showing');
      return;
    }
    TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_SLIDING_BRIGHTNESS, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    this.draggingViewData.isDragging = false;
    let physicsValue = this.countPhysicsValue(this.viewData.brightnessUIValue);
    log.showDebug(`onActionEnd, UI value: ${this.viewData.brightnessUIValue}, physicsValue: ${physicsValue}`);
    this.updateScreenBrightness(physicsValue, false);
    this.reportCCBrightnessSlide(physicsValue);

    if (this.timeId !== -1) {
      clearTimeout(this.timeId);
      TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_SLIDING_BRIGHTNESS, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    } else {
      log.showInfo('start show CC mainLayout');
      this.blurOpacity.blurOpacity = 1;

      this.doEndAnim();
    }
    this.offsetXOfPrevious = 0;
    this.isMouseScroll = false;
  }

  /**
   * PanGesture手势拖拽过程中，另外手指点击屏幕关闭会中断这个过程，导致 onActionEnd 不触发，但会触发 onActionCancel 事件；
   * 在 onActionCancel 中将状态变量复位；
   */
  public onPanActionCancel() {
    log.showInfo('onPanActionCancel');
    this.animViewData.showBlurLayer = false;
  }

  private doEndAnim() {
    if (this.notifyHeadBlurTimeId != -1) {
      clearTimeout(this.notifyHeadBlurTimeId);
    } else {
      this.scrollBlurEvent.setValue(1);
      EvtBus.post(ScrollBlurEvent, this.scrollBlurEvent);
    }
    animateTo({
      curve: curves.cubicBezierCurve(0.33, 0.0, 0.67, 1.0),
      duration: 100,
    }, () => {
      this.backgroundOpacity.backgroundOpacity = 1;
      this.animViewData.shadowRadius = 0;
    });
    animateTo({
      curve: curves.responsiveSpringMotion(0.28, 1, 0)
    }, () => {
      this.animViewData.scaleX = 1;
    });

    animateTo({
      curve: Curve.Sharp,
      duration: 150,
      delay: 100,
      onFinish: () => {
        if (!this.draggingViewData.isDragging) {
          this.animViewData.showBlurLayer = false;
          this.animViewData.brightnessBlurOpacity = 1;
          AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
          AnimateToScheduleUtils.raiseAnimateToCPUPriority(1);
        }
      }
    }, () => {
      this.animViewData.brightnessBlurOpacity = 0;
    });
  }

  countBrightnessUIValue(event: TouchEvent): number {
    return event?.touches[event.touches.length - 1]?.x === undefined ? this.viewData.brightnessUIValue :
      (RTLUtil.isRTL() ? this.BRIGHTNESS_WIDTH - event?.touches[event.touches.length - 1]?.x :
        event?.touches[event.touches.length - 1]?.x);
  }

  public onLayoutChange() {
    log.showInfo('onLayoutChange');
    this.endDraggingWithNoAnim();
  }

  public updatePhysicsValue(physicsValue: number) {
    this.physicsValue = physicsValue;
    log.showInfo(`updatePhysicsValue to: ${this.physicsValue}, current ui value is ${this.viewData.brightnessUIValue}`);
    // 亮度条拖动过程中以及拖动结束250ms内不响应回调，避免拖动中或者拖动刚结束亮度条进度和实际物理回调亮度值不同导致的突变
    if (this.animViewData.showBlurLayer === false) {
      animateTo({
        curve: curves.responsiveSpringMotion(0.28, 0.97, 0)
      }, () => {
        this.viewData.brightnessUIValue = this.countUIValue();
      })
      log.showInfo(`updatePhysicsValue, ui value change to: ${this.viewData.brightnessUIValue}`);
      this.refreshSun();
    }
  }

  public onDraggingStop() {
    log.showDebug('onDraggingStop');
    if (this.draggingViewData.isDragging === false) {
      let currentEndPositionX = this.currentEndPositionX;
      this.refreshSunAnimWhenRelease(currentEndPositionX);
    }
  }

  public onCanvasReady() {
    this.isCanvasReady = true;
    this.reloadAnim();
    log.showInfo('onCanvasReady, get total frames: ' + this.animationItem?.totalFrames);
  }

  public onCanvasDisappear() {
    log.showInfo(`canvas disappear: ${this.lottieName}`);
    this.isCanvasReady = false;
    lottie.destroy(this.lottieName);
    this.endDraggingWithNoAnim();
  }

  /**
   * 通过方向键调节亮度
   */
  public adjustBrightWithArrowKey(value: number) {
    log.showInfo(`adjustBrightWithArrowKey`);
    if (RTLUtil.isRTL()) {
      value = -value;
    }
    if (this.physicsValue + value < ControlBrightnessManager.getInstance().getMin()) {
      log.showWarn('it is currently the minimum bright, physicsValue: ' + this.physicsValue);
      return;
    }
    if (this.physicsValue + value > ControlBrightnessManager.getInstance().getMax()) {
      log.showWarn('it is currently the maximum bright, physicsValue: ' + this.physicsValue);
      return;
    }
    this.physicsValue = this.physicsValue + value;
    this.viewData.brightnessUIValue = this.countUIValue();
    this.updateScreenBrightness(this.countPhysicsValue(this.viewData.brightnessUIValue), false);
  }

  /**
   * 通过鼠标滚轮调节亮度
   */
  private adjustBrightWithMouseScroll(event: GestureEvent): number {
    let isMouseScrollToUp: boolean = (event?.offsetX - this.offsetXOfPrevious) >= 0;
    return (isMouseScrollToUp ?
      (this.BRIGHTNESS_WIDTH / this.mouseScrollRange) : -(this.BRIGHTNESS_WIDTH / this.mouseScrollRange));
  }

  private endDraggingWithNoAnim() {
    if (this.draggingViewData.isDragging) {
      log.showInfo(`endDraggingWithNoAnim, ${this.isLandscapeBrightness}`)
      clearTimeout(this.timeId);
      BrightnessSharedViewData.getInstance().reset();
      this.animViewData.reset();
      this.draggingViewData.reset();
      TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_SLIDING_BRIGHTNESS, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
      AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
      let physicsValue = this.countPhysicsValue(this.viewData.brightnessUIValue);
      // 将亮度值写入数据库
      this.updateScreenBrightness(physicsValue, false);
      this.reportCCBrightnessSlide(physicsValue);
    }
  }

  private onCurrentEndPositionXChange() {
    if (!this.draggingViewData.isDragging) {
      log.showDebug('onCurrentEndPositionXChange,but not dragging, return');
      return;
    }
    let currentEndPositionX = this.currentEndPositionX;
    // 直接下发动效指令，避免因等待帧数据和丢帧导致动效卡顿
    animateToImmediately({
      curve: curves.responsiveSpringMotion(0.1, 1, 0)
    }, () => {
      this.viewData.brightnessUIValue = Math.min(
        Math.max(this.currentEndPositionX, 0),
        this.BRIGHTNESS_WIDTH);
    })
    this.updateScreenBrightness(this.countPhysicsValue(this.viewData.brightnessUIValue), true);
    this.refreshSunAnimWhenDragging(currentEndPositionX);
  }

  private countUIValue(): number {
    let percentage = Math.pow(((this.physicsValue - ControlBrightnessManager.getInstance().getMin()) / this.brightnessRange), 1 / 1.8);
    let brightnessUI = this.BRIGHTNESS_WIDTH * percentage;
    log.showInfo(`phsics value:${this.physicsValue};countUIValue percentage:${percentage};ui value:${brightnessUI}`);
    return brightnessUI;
  }

  private countUIValueBetweenBright(currentBright: number, afterBright: number): number {
    if (afterBright > ControlBrightnessManager.getInstance().getMax()) {
      return 0;
    }
    let currentPercentage = Math.pow(((currentBright - ControlBrightnessManager.getInstance().getMin()) / this.brightnessRange), 1 / 1.8);
    let currentBrightnessUI = this.BRIGHTNESS_WIDTH * currentPercentage;
    let afterPercentage = Math.pow(((afterBright - ControlBrightnessManager.getInstance().getMin()) / this.brightnessRange), 1 / 1.8);
    let afterBrightnessUI = this.BRIGHTNESS_WIDTH * afterPercentage;
    return (afterBrightnessUI - currentBrightnessUI) || 0;
  }

  private countPhysicsValue(uiVar: number): number {
    let brightness = Math.pow(uiVar / this.BRIGHTNESS_WIDTH, 1.8) * this.brightnessRange + ControlBrightnessManager.getInstance().getMin();
    log.showInfo(`count brightness value according to ui value: ${brightness};brightnessRange: ${this.brightnessRange}`);
    return Math.round(brightness);
  }

  private refreshSunAnimWhenRelease(currentEndPositionX: number) {
    if (currentEndPositionX < 0) {
      this.scrollBeforeSun();
    } else if (currentEndPositionX < this.INVERT_COLOR_START && currentEndPositionX >= 0) {
      this.brightnessStatus = BrightnessStatus.RELEASE_BEFORE_SUN;
      let colorMode = GlobalContext.getContext().config.colorMode as number;
      if (colorMode === 0) {
        this.transitColor($r('app.color.control_center_brightness_sun_blue'), $r('app.color.control_center_brightness_sun_write'), this.COLOR_TRANSITION_FRAMES_SHORT, Curve.Linear);
      } else {
        this.transitColor($r('app.color.control_center_brightness_sun_blue'), $r('app.color.control_center_brightness_sun_black'), this.COLOR_TRANSITION_FRAMES_SHORT, Curve.Linear);
      }
      this.playCurrentFrame(currentEndPositionX);
    } else if (currentEndPositionX >= this.INVERT_COLOR_START && currentEndPositionX <= this.BRIGHTNESS_WIDTH) {
      if (this.brightnessStatus === BrightnessStatus.DRAGGING_AFTER_SUN ||
        this.brightnessStatus === BrightnessStatus.DRAGGING_BEFORE_SUN) {
        this.transitColor($r('app.color.control_center_brightness_sun_blue'), $r('app.color.control_center_brightness_sun_black'), this.COLOR_TRANSITION_FRAMES_SHORT, Curve.Linear);
      }
      this.brightnessStatus = BrightnessStatus.RELEASE_AFTER_SUN;
      this.playCurrentFrame(currentEndPositionX);
    } else if (currentEndPositionX > this.BRIGHTNESS_WIDTH) {
      this.scrollAfterSun();
    }
  }

  private refreshSunAnimWhenDragging(currentEndPositionX: number) {
    let colorMode = GlobalContext.getContext().config.colorMode as number;
    if (currentEndPositionX < this.INVERT_COLOR_START) {
      if ((this.brightnessStatus === BrightnessStatus.RELEASE_BEFORE_START) && (colorMode === 0)) {
        this.transitColor($r('app.color.control_center_brightness_sun_write'), $r('app.color.control_center_brightness_sun_blue'), 5, Curve.Linear);
      } else if (this.brightnessStatus === BrightnessStatus.DEFAULT ||
        this.brightnessStatus === BrightnessStatus.RELEASE_BEFORE_START ||
        this.brightnessStatus === BrightnessStatus.RELEASE_BEFORE_SUN) {
        this.transitColor($r('app.color.control_center_brightness_sun_black'), $r('app.color.control_center_brightness_sun_blue'), this.COLOR_TRANSITION_FRAMES_SHORT, Curve.Linear);
      }
      this.brightnessStatus = BrightnessStatus.DRAGGING_BEFORE_SUN;
      this.playCurrentFrame(currentEndPositionX);
    } else if (currentEndPositionX >= this.INVERT_COLOR_START && currentEndPositionX <= this.BRIGHTNESS_WIDTH) {
      if (this.brightnessStatus === BrightnessStatus.RELEASE_AFTER_SUN ||
        this.brightnessStatus === BrightnessStatus.RELEASE_AFTER_END ||
        this.brightnessStatus === BrightnessStatus.DEFAULT) {
        this.transitColor($r('app.color.control_center_brightness_sun_black'), $r('app.color.control_center_brightness_sun_blue'), this.COLOR_TRANSITION_FRAMES_SHORT, Curve.Linear);
      }
      this.brightnessStatus = BrightnessStatus.DRAGGING_AFTER_SUN;
      this.playCurrentFrame(currentEndPositionX);
    } else if (currentEndPositionX > this.BRIGHTNESS_WIDTH) {
      if (this.brightnessStatus == BrightnessStatus.RELEASE_AFTER_END ||
        this.brightnessStatus == BrightnessStatus.RELEASE_AFTER_SUN ||
        this.brightnessStatus == BrightnessStatus.DEFAULT) {
        this.transitColor($r('app.color.control_center_brightness_sun_black'), $r('app.color.control_center_brightness_sun_blue'), this.COLOR_TRANSITION_FRAMES_SHORT, Curve.Linear);
      }
      this.playCurrentFrame(currentEndPositionX);
      this.brightnessStatus = BrightnessStatus.DRAGGING_AFTER_END;
    }
  }

  private scrollAfterSun() {
    this.brightnessStatus = BrightnessStatus.RELEASE_AFTER_END;
    let currentFrame = this.animationItem?.currentFrame as number;
    let totalFrame = currentFrame - this.END_FRAME_INDEX;
    if (this.SCROLL_SPEED > totalFrame) {
      log.showInfo('scrollAfterSun, not enough for scroll, return');
      this.transitColor($r('app.color.control_center_brightness_sun_blue'), $r('app.color.control_center_brightness_sun_black'), this.COLOR_TRANSITION_FRAMES_SHORT, Curve.Linear);
      return;
    }

    let count = 0;
    if (this.colorTranslatorIntervalId !== -1) {
      clearInterval(this.colorTranslatorIntervalId);
    }
    const intervalId = setInterval(() => {
      count += this.SCROLL_SPEED;
      if (count > totalFrame) {
        this.colorTranslatorIntervalId = -1;
        clearInterval(intervalId); // 停止计时器
        return;
      }
      let colorXArr = this.getTransitionColorArr(
        this.colorTool.getArrayColor($r('app.color.control_center_brightness_sun_blue')),
        this.colorTool.getArrayColor($r('app.color.control_center_brightness_sun_black')), count, totalFrame);
      this.animationItem?.changeColor(colorXArr);
      this.animationItem?.goToAndStop(currentFrame - this.SCROLL_SPEED, true);
      currentFrame -= this.SCROLL_SPEED;
    }, 0);
    this.colorTranslatorIntervalId = intervalId;
  }

  private scrollBeforeSun() {
    this.brightnessStatus = BrightnessStatus.RELEASE_BEFORE_START;
    let currentFrame = this.animationItem?.currentFrame as number;
    this.animationItem?.setSpeed(6);
    let colorMode = GlobalContext.getContext().config.colorMode as number;
    if (colorMode === 0) {
      this.transitColor($r('app.color.control_center_brightness_sun_blue'), $r('app.color.control_center_brightness_sun_write'), this.COLOR_TRANSITION_FRAMES_SHORT, Curve.Linear);
    } else {
      this.transitColor($r('app.color.control_center_brightness_sun_blue'), $r('app.color.control_center_brightness_sun_black'), this.COLOR_TRANSITION_FRAMES_SHORT, Curve.Linear);
    }
    // 当playSegments起点和终点一致的时候会播放整段动画
    if (currentFrame === this.START_FRAME_INDEX) {
      return;
    }
    this.animationItem?.playSegments([currentFrame, this.START_FRAME_INDEX], true);
  }

  private handleDarkModeEvent(event: DarkModeEvent) {
    let color = $r('app.color.Control_center_brightness_icon_color');
    if ((this.viewData.brightnessUIValue <= this.INVERT_COLOR_START) && event.isDarkMode) {
      color = $r('app.color.control_center_brightness_sun_write');
    } else {
      color = $r('app.color.control_center_brightness_sun_black');
    }
    this.animationItem?.changeColor(this.colorTool.getArrayColor(color));
    this.playCurrentFrame(this.viewData.brightnessUIValue);
  }

  private refreshSun() {
    if (this.isPc) {
      return;
    }
    if (this.animationItem == null) {
      log.showInfo('refresh sun but lottie is null, reload');
      this.reloadAnim();
      return;
    }
    let colorMode: number = GlobalContext.getContext().config.colorMode as number;
    log.showInfo(`refreshSun, brightnessUIValue: ${this.viewData.brightnessUIValue}`);
    let color = $r('app.color.control_center_brightness_sun_black');
    if ((this.viewData.brightnessUIValue <= this.INVERT_COLOR_START) && (colorMode === 0)) {
      color = $r('app.color.control_center_brightness_sun_write');
    } else {
      color = $r('app.color.control_center_brightness_sun_black');
    }
    if (this.viewData.brightnessUIValue < this.INVERT_COLOR_START) {
      this.brightnessStatus = BrightnessStatus.RELEASE_BEFORE_SUN;
    } else if (this.viewData.brightnessUIValue >= this.INVERT_COLOR_START &&
      this.viewData.brightnessUIValue <= this.BRIGHTNESS_WIDTH) {
      this.brightnessStatus = BrightnessStatus.RELEASE_AFTER_SUN;
    } else if (this.viewData.brightnessUIValue > this.BRIGHTNESS_WIDTH) {
      this.brightnessStatus = BrightnessStatus.RELEASE_AFTER_END;
    }
    this.animationItem?.changeColor(this.colorTool.getArrayColor(color));
    this.playCurrentFrame(this.viewData.brightnessUIValue);
  }

  // 根据currentLoc播放指定帧
  private playCurrentFrame(currentEndPositionX: number): number {
    currentEndPositionX = Math.ceil(currentEndPositionX);
    let isOver: boolean = !(currentEndPositionX >= 0 && currentEndPositionX <= this.BRIGHTNESS_WIDTH);
    let result: number = 0;
    // 超出亮度条范围
    if (isOver) {
      if (currentEndPositionX < 0) {
        result = this.START_FRAME_INDEX -
          Math.abs(currentEndPositionX) *
          this.getFramesPerVpWhenBeforeSun(currentEndPositionX);
      } else {
        result = this.END_FRAME_INDEX +
          (currentEndPositionX - this.BRIGHTNESS_WIDTH) *
          this.getFramesPerVpWhenOverSun(currentEndPositionX);
      }
    } else {
      // 在亮度条范围内
      result = this.START_FRAME_INDEX + currentEndPositionX * this.getFramesPerVp();
    }
    if (result < 0) {
      result = 0;
    } else if (result > this.TOTAL_FRAMES) {
      result = this.TOTAL_FRAMES;
    }
    this.animationItem?.goToAndStop(result, true);
    return result;
  }

  private getFramesPerVp(): number {
    return (this.END_FRAME_INDEX - this.START_FRAME_INDEX + 1) / this.BRIGHTNESS_WIDTH;
  }

  // 超出亮度条范围滑动，需要有越滑越慢效果
  private getFramesPerVpWhenBeforeSun(currentLoc: number): number {
    let frames = this.getFramesPerVp() *
      (1 - curves.initCurve(Curve.EaseOut).interpolate((0 - currentLoc) / 500));
    return frames;
  }

  // 超出亮度条范围滑动，需要有越滑越慢效果
  private getFramesPerVpWhenOverSun(currentLoc: number): number {
    let frames = this.getFramesPerVp() *
      (1 - curves.initCurve(Curve.EaseOut).interpolate((currentLoc - this.BRIGHTNESS_WIDTH) / 500));
    return frames;
  }

  /**
   * 传入帧的序号，获取中间的过渡颜色
   *
   * @param start 开始颜色
   * @param end 结束颜色
   * @param index 帧序号
   * @param frames 总共帧数
   */
  private getTransitionColorArr(start: number[], end: number[], index: number, frames: number): number[] {
    let r1: number = start[0];
    let g1: number = start[1];
    let b1: number = start[2];
    let r2: number = end[0];
    let g2: number = end[1];
    let b2: number = end[2];
    let a2: number = end[3];
    let rDiff: number = r2 - r1;
    let gDiff: number = g2 - g1;
    let bDiff: number = b2 - b1;
    let coefficient: number = curves.initCurve(Curve.Linear).interpolate(index / frames);
    let r3 = Math.ceil(r1 + rDiff * coefficient);
    let g3 = Math.ceil(g1 + gDiff * coefficient);
    let b3 = Math.ceil(b1 + bDiff * coefficient);
    let transitionColor: number[] = [r3, g3, b3, a2];
    return transitionColor;
  }

  /**
   * 使用指定曲线使得当前帧的颜色从startR过渡到endR
   *
   * @param startR
   * @param endR
   * @param frames
   * @param curve
   */
  private transitColor(startR: Resource, endR: Resource, frames: number, curve: Curve = Curve.Sharp): void {
    if (startR == null || endR == null) {
      log.showDebug('param is invalid, not deal');
      return;
    }
    if (startR == endR) {
      log.showDebug('color is same, not deal');
      return;
    }
    // 如果之前的颜色过渡动画未完成，就停止，直接开始下一轮的颜色过渡动画，避免中间出现错误颜色
    if (this.colorTranslatorIntervalId !== -1) {
      clearInterval(this.colorTranslatorIntervalId);
    }
    let start = this.colorTool.getArrayColor(startR);
    let end = this.colorTool.getArrayColor(endR);
    let r1: number = start[0];
    let g1: number = start[1];
    let b1: number = start[2];
    let r2: number = end[0];
    let g2: number = end[1];
    let b2: number = end[2];
    let a2: number = end[3];
    let rDiff: number = r2 - r1;
    let gDiff: number = g2 - g1;
    let bDiff: number = b2 - b1;
    let interpolator = curves.initCurve(curve);

    let count = 0;
    const intervalId = setInterval(() => {
      count++;
      if (count > frames) {
        this.colorTranslatorIntervalId = -1;
        clearInterval(intervalId); // 停止计时器
        return;
      }
      let coefficient: number = interpolator.interpolate(count / frames);
      let r3 = Math.ceil(r1 + rDiff * coefficient);
      let g3 = Math.ceil(g1 + gDiff * coefficient);
      let b3 = Math.ceil(b1 + bDiff * coefficient);
      let transitionColor: number[] = [r3, g3, b3, a2];
      this.animationItem?.changeColor(transitionColor);
      this.animationItem?.goToAndStop(this.animationItem?.currentFrame, true);
    }, 0);
    this.colorTranslatorIntervalId = intervalId;
  }

  private convertRgbStringToArray(rgbString: ResourceColor): number[] {
    rgbString = rgbString.toString();
    const rgbValues = rgbString.substring(4, rgbString.length - 1).split(',');
    return rgbValues.map(value => parseInt(value.trim()));
  }

  private dropDownCallback: ViewCallback = {
    onHide: (): void => {
      log.showInfo(`dropDown onHide, ${this.isLandscapeBrightness}`);
      // 控制中心收起之后参数复原
      this.endDraggingWithNoAnim();
    }
  }

  private reloadAnim() {
    const now: number = Date.now();
    if (now - this.lastLoadTime < 1000) {
      this.loadCount++;
      if (this.loadCount >= 10) {
        log.showInfo('into dead loop')
        return;
      }
    } else {
      this.lastLoadTime = now;
      this.loadCount = 0;
    }
    let lottieData: object | null = sBrightnessController.matchLottieData(false);
    if (lottieData == null) {
      log.showInfo('sunLottieData is null, return');
      return;
    }
    if (this.isCanvasReady === false) {
      log.showInfo('canvas is not ready, return');
      return;
    }
    if (this.animationItem?.isLoaded) {
      log.showInfo('lottie has been loaded, return');
      this.refreshSun();
      return;
    }
    this.animationItem = lottie.loadAnimation({
      container: this.mainCanvasRenderingContext, // 渲染上下文
      renderer: 'canvas', // 渲染方式
      loop: false, // 是否循环播放,默认true
      autoplay: false, // 是否自动播放，默认true
      packageName: 'com.controlCenter',
      name: this.lottieName,
      animationData: lottieData// 播放的动画json数据
    })
    this.animationItem.addEventListener('DOMLoaded', (args: Object): void => {
      log.showInfo(`addEventListener DOMLoaded, ${this.animationItem?.name}`);
      this.refreshSun();
    })
    this.animationItem.addEventListener('destroy', (args: Object): void => {
      log.showInfo(`addEventListener destroy, ${this.animationItem?.name}`);
      this.animationItem = undefined;
      this.reloadAnim();
    })
  }

  /**
   * 拖拽中设置亮度值，不写入数据库
   * 结束拖动设置亮度值，写入数据库
   *
   * @param brightness
   * @param isDragging
   * @param brightness 物理亮度值
   * @param isDragging 是否拖拽中
   */
  private updateScreenBrightness(brightness: number, isDragging: boolean): void {
    if (!isDragging) {
      log.showInfo('write brightness %{public}d to database', brightness);
    }
    try {
      taskpool.execute(setBrightValue, brightness, isDragging && !this.isPc).catch((e: object) => {
        log.error(e);
      });
      if (!isDragging) {
        AccessibilityUtil.sendAccessibility(ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_change_brightness'),
          `${this.getAccessibilityBrightnessValue(brightness)}%}`));
      }
    } catch (error) {
      log.error('taskpool execute error', error);
    }
  }

  public getAccessibilityBrightnessValue(brightness: number): string {
    if (this.brightnessRange <= 0) {
      return brightness.toFixed(0);
    }
    return ((brightness - ControlBrightnessManager.getInstance().getMin()) / this.brightnessRange * 100).toFixed(0);
  }

  private reportCCBrightnessSlide(brightnessValue: number): void {
    HiSysEventUtil.reportCCBrightnessSlide({
      STARTPROGRESS: this.startBrightness,
      STOPPROGRESS: brightnessValue,
      ISNIGHTMODE: `${(AppStorage.get('DarkModeModel_DarkModeStatus') as CommonData)?.status}`,
      TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      LOCKSTATUS: AppStorage.get('lockStatus')
    });
  }
}