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

import { AnimateToScheduleUtils, DomainName, LogDomain, Trace, TraceUtil } from '@ohos/basicutils';
import { HoverConstants } from '@ohos/commonconstants';
import {
  EventManager,
  EvtBus,
  GlobalContext,
  ViewCallback,
  ViewManagerPolicy,
  ViewType,
} from '@ohos/frameworkwrapper';
import { LogHelper } from '@ohos/basicutils';
import { curves } from '@kit.ArkUI';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import {
  SliderButtonAnimViewData,
  SliderButtonShareData,
  SliderButtonViewData,
  SliderIconViewData
} from './SliderButtonViewData';
import { SliderLottieViewMode } from './SliderLottieViewMode';
import DropDownPanelManager from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/src/main/ets/template/newStyle/BrightnessOptionUtils';
import { RTLUtil } from '@ohos/componenthelper';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { ColorResourceUtils } from '@ohos/systemuicommon/src/main/ets/template/common/ColorResourceUtils';
import { ThemeChangeEvent } from '@ohos/systemuiutils/src/main/ets/sysdialog/CommonEvent';
import { KeyCode } from '@kit.InputKit';
import { VibratorUtil } from '@ohos/systemuiutils';

const TAG = 'Ctrl.SliderButtonBaseViewModel';
const sliderMoveRange: number = 8.5;
const THRESHOLD_SLIDE: number = 5;
const focusKeyArr: number[] = [KeyCode.KEYCODE_TAB, KeyCode.KEYCODE_DPAD_LEFT, KeyCode.KEYCODE_DPAD_DOWN,
  KeyCode.KEYCODE_DPAD_RIGHT, KeyCode.KEYCODE_DPAD_UP]

export abstract class SliderButtonBaseViewModel {
  public readonly subpageIconScale: number = 0.857;
  // 进度条开始拖动，放大动效延迟执时间
  public readonly startDraggingTimeDelay: number = 100;
  public startDraggingTimeId: number | null = null;
  // 是否通过物理值变化更新ui值，拖动期间该值为false
  public physValUpdateUI: boolean = true;
  public panelNeedHide: boolean = false;
  public physicsValue: number = 0;
  public startPhysicsValue: number = 0;
  public physicsValueRange: number = 0;
  public colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  public currentEndPosition: number = 0;
  public colorTool: ColorResourceUtils = new ColorResourceUtils(GlobalContext.getContext().resourceManager);
  public eventMgr: EventManager = EvtBus.createEventManager();
  public currentColorMode: number = ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
  private log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
  private isPanelDismissing: boolean = false;
  private lastOffsetX: number = 0;
  private lastOffsetY: number = 0;
  private touchStartY: number = 0;
  private touchStartX: number = 0;
  private viewData: SliderButtonViewData;
  private animData: SliderButtonAnimViewData;
  private sliderLottieViewMode: SliderLottieViewMode;
  private onKeyActionTaskId: number | null = null;

  constructor(viewData: SliderButtonViewData, animData: SliderButtonAnimViewData,
    iconViewData: SliderIconViewData, logTag: string) {
    this.log = LogHelper.getLogHelper(LogDomain.CC, TAG + '_' + logTag)
    this.viewData = viewData;
    this.animData = animData;
    this.sliderLottieViewMode = new SliderLottieViewMode(iconViewData, viewData, animData);
  }

  public updateLogTag(newLogTag: string): void {
    this.log = LogHelper.getLogHelper(LogDomain.CC, TAG + '_' + newLogTag)
  }

  /**
   * 更新当前真实物理值
   */
  abstract getPhysicsValue(): number;

  /**
   * 物理值的最大值
   */
  abstract getMaxValue(): number;

  /**
   * 物理值的最小值
   */
  abstract getMinValue(): number;

  /**
   *
   * 将真实物理值写入数据库
   * @param continuous 是否连续操作
   */
  abstract setPhysicsValue(continuous: boolean): void;

  /**
   * 滑动条点击行为打点上报
   */
  abstract reportSliderClickEvent(): void;

  /**
   * 滑动条滑动行为打点上报
   */
  abstract reportSliderSlideEvent(): void;

  public getViewData(): SliderButtonViewData {
    return this.viewData;
  }

  public getAnimData(): SliderButtonAnimViewData {
    return this.animData;
  }

  public getLottieAnimMode(): SliderLottieViewMode {
    return this.sliderLottieViewMode;
  }

  public aboutToAppear() {
    this.physicsValue = this.getPhysicsValue();
    this.physicsValueRange = this.getMaxValue() - this.getMinValue();
    this.animData.uiValue = this.countUIValue();
    ViewManagerPolicy.registerViewCallback(ViewType.DROPDOWN, this.dropDownCallback);
    this.log.showInfo(`aboutToAppear: physicsValue:${this.physicsValue} uiValue:${this.animData.uiValue}`);
    this.currentColorMode = GlobalContext.getContext().config.colorMode as number;
    this.initIconColor();
    this.eventMgr.on(ThemeChangeEvent, this.onProduceThemeUsingEvent);
  }

  public aboutToDisAppear() {
    ViewManagerPolicy.unRegisterViewCallback(ViewType.DROPDOWN, this.dropDownCallback);
    this.eventMgr.offAll();
  }

  /**
   * 监听控制中心面板收起，将拖动参数回归
   */
  private dropDownCallback: ViewCallback = {
    onHide: (): void => {
      if (this.animData.sliderChosen) {
        this.log.showInfo(`need to reset slider position`);
        this.endDraggingAnimation();
      }
      this.animData.isSliderButtonFocused = false;
    }
  }

  /**
   * 主题换肤事件生产者
   *
   * @returns 事件
   */
  private onProduceThemeUsingEvent = (event: ThemeChangeEvent): void => {
    this.log.showInfo('onProduceThemeUsingEvent' + event.isThemeChanged);
    let iconColor =
      this.currentColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
      $r('app.color.control_center_brightness_sun_write') :
      $r('app.color.control_center_brightness_sun_black');
    this.getLottieAnimMode().changeLottieColor(this.colorTool.getArrayColor(iconColor));
    this.getAnimData().iconColor = iconColor;
  }

  /**
   * 初始化图标颜色
   */
  private initIconColor(): void {
    this.log.showInfo(`initIconColor, currentColorMode is ${this.currentColorMode}`);
    let iconColor =
      this.currentColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
      $r('app.color.control_center_brightness_sun_write') :
      $r('app.color.control_center_brightness_sun_black');
    this.getAnimData().iconColor = iconColor;
  }

  /**
   * 开始拖动动效
   */
  public startDraggingAnimation(): void {
    this.startDraggingTimeId = setTimeout(() => {
      if (!this.viewData.isExpand) {
        this.changeIconColor(true);
      }
      animateTo({
        curve: curves.responsiveSpringMotion(0.28, 1, 0),
      }, () => {
        this.animData.sliderChosen = true;
        // 进度条局部放大
        if (!this.viewData.isExpand) {
          this.animData.sliderScale = {
            x: this.viewData.buttonWidth / this.viewData.sliderWidth,
            y: this.viewData.buttonHeight / this.viewData.sliderHeight
          }
        }
      })
      this.startDraggingTimeId = null;
    }, this.startDraggingTimeDelay)
  }

  /**
   * 进度条拖拽场景改变图标颜色
   *
   * @param isChosen 是否是拖动进度条的高亮状态
   */
  public changeIconColor(isChosen: boolean): void {
    this.log.showInfo(`changeIconColor isChosen: ${isChosen}`)
    // 换肤场景的深色模式在拖动进图条时需要改变颜色
    let isSysColor = AppStorage.get('isSysColor') as boolean;
    let darkColorMode = this.currentColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
    if (isSysColor || !darkColorMode) {
      return;
    }
    let changeColor = isChosen ? $r('app.color.control_center_brightness_sun_black') :
    $r('app.color.control_center_brightness_sun_write');
    if (this.getAnimData().useLottieData) {
      this.getLottieAnimMode().changeLottieColor(this.colorTool.getArrayColor(changeColor));
    } else {
      this.getAnimData().iconColor = changeColor;
    }
  }

  /**
   * 拖动结束动效
   */
  public endDraggingAnimation(): void {
    SliderButtonShareData.getInstance().isDragging = false;
    if (this.startDraggingTimeId !== null) {
      clearTimeout(this.startDraggingTimeId);
      this.startDraggingTimeId = null;
      return;
    }
    this.changeIconColor(false);
    animateTo({
      curve: curves.responsiveSpringMotion(0.28, 1, 0),
    }, () => {
      this.animData.sliderChosen = false;
      this.animData.sliderScale = { x: 1, y: 1 };
    })
  }

  /**
   * 物理值->ui值映射，默认线性映射，子类可修改
   * @returns
   */
  public countUIValue(): number {
    const sliderLength: number =
      this.getViewData().isHorizontal ? this.viewData.sliderWidth : this.viewData.sliderHeight;
    const uiValue = sliderLength * (this.physicsValue - this.getMinValue()) / this.physicsValueRange;
    this.log.showInfo(`physics value:${this.physicsValue} uiValue:${uiValue}`);
    return uiValue;
  }

  /**
   * ui值->物理值映射，默认线性关系，向上取整，子类可修改
   * @returns
   */
  public countPhysicsValue(): number {
    const uiValue = this.animData.uiValue;
    const sliderLength: number =
      this.viewData.isHorizontal ? this.viewData.sliderWidth : this.viewData.sliderHeight;
    let physicsValue = Math.ceil(this.physicsValueRange * uiValue / sliderLength) + this.getMinValue();
    if (physicsValue > this.getMaxValue()) {
      physicsValue = this.getMaxValue();
    }
    if (physicsValue < this.getMinValue()) {
      physicsValue = this.getMinValue();
    }
    this.log.showInfo(`count uiValue: ${uiValue} according to physicsValue: ${physicsValue}`);
    return physicsValue;
  }

  /**
   * 物理值变化监听更新ui
   * @param physicsValue
   */
  public onPhysicsValueChange(physicsValue: number): void {
    this.log.showInfo(`physicsValue: ${physicsValue}, currentUI: ${this.animData.uiValue}, physValUpdateUI: ${this.physValUpdateUI}`);
    this.physicsValue = physicsValue;
    if (this.physValUpdateUI) {
      animateTo({
        curve: curves.responsiveSpringMotion(0.28, 0.97, 0)
      }, () => {
        this.animData.uiValue = this.countUIValue();
      })
      this.log.showInfo(`ui value change to: ${this.animData.uiValue}`);
      this.refreshIcon();
    }
  }

  /**
   * hover效果
   * @param isHover
   */
  public handleOnHover(isHover: boolean): void {
    animateTo({
      duration: HoverConstants.HOVER_ANIMATE_DURATION,
      curve: Curve.Sharp
    }, () => {
      this.getAnimData().buttonScale =
        isHover ? { x: HoverConstants.HOVER_QUICK_BTN_SCALE, y: HoverConstants.HOVER_QUICK_BTN_SCALE } : { x: 1, y: 1 }
    });
  }

  public onTouchEvent = (event: TouchEvent) => {
    if (this.getViewData().isExpand) {
      return;
    }
    if (event.type === TouchType.Down) {
      this.touchStartY = event.touches[0].y;
      this.touchStartX = event.touches[0].x;
      animateTo({
        curve: curves.springMotion(0.31, 0.94)
      }, () => {
        this.getAnimData().buttonScale = { x: 0.9, y: 0.9 };
      })
    } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      this.TopToggleTouchOff();
    } else if (event.type === TouchType.Move) {
      if (Math.abs(event.touches[0].y - this.touchStartY) > THRESHOLD_SLIDE ||
        Math.abs(event.touches[0].x - this.touchStartX) > THRESHOLD_SLIDE) {
        this.TopToggleTouchOff();
      }
    }
  }

  TopToggleTouchOff() {
    // 如果正在拖动进度条则不做处理
    if (SliderButtonShareData.getInstance().isDragging) {
      return;
    }
    animateTo({
      curve: curves.springMotion(0.31, 0.94)
    }, () => {
      this.getAnimData().buttonScale = { x: 1, y: 1 };
    })
  }

  /**
   * 长按事件
   * @param event
   */
  public onLongPressAction(event: GestureEvent, isHorizontal: boolean = true): void {
    VibratorUtil.startVibration(VibratorUtil.VIBRATION_EFFECT_MEDIUM, VibratorUtil.VIBRATION_ATTRIBUTE_LONG_PRESS);
  }

  public onPanActionStart(event: GestureEvent) {
    this.startPhysicsValue = this.physicsValue;
    this.isPanelDismissing = DropDownPanelManager.isPanelDismissing();
    if (this.isPanelDismissing) {
      this.log.showWarn('panel is dismissing');
      return;
    }
    this.log.showInfo('onActionStart');
    if (this.physValUpdateUI) {
      this.physValUpdateUI = false;
    }

    this.currentEndPosition = this.animData.uiValue;
    AnimateToScheduleUtils.raiseAnimateToCPUPriority(0);
    SliderButtonShareData.getInstance().isDragging = true;
    animateTo({
      curve: curves.springMotion(0.31, 0.94)
    }, () => {
      this.getAnimData().buttonScale = { x: 1, y: 1 };
    })
    this.startDraggingAnimation();
    this.lastOffsetX = event?.offsetX ?? 0;
    this.lastOffsetY = event?.offsetY ?? 0;
  }

  public onPanActionUpdate(event: GestureEvent) {
    if (this.isPanelDismissing) {
      this.log.showWarn('panel is dismissing');
      return;
    }
    let moveDistance = 0;
    if (this.getViewData().isHorizontal) {
      moveDistance = (event?.offsetX - this.lastOffsetX) * (RTLUtil.isRTL() ? -1 : 1);
    } else {
      moveDistance = this.lastOffsetY - event?.offsetY;
    }
    if (Math.abs(moveDistance - 0) < Number.EPSILON) {
      return;
    }
    this.lastOffsetX = event?.offsetX;
    this.lastOffsetY = event?.offsetY;
    this.currentEndPosition += moveDistance;
    this.onCurrentEndPositionChange();
  }

  public onPanActionEnd(event?: GestureEvent) {
    this.log.showInfo('PanAction ' + (event ? 'end' : 'cancel'));
    if (this.isPanelDismissing) {
      this.log.showWarn('panel is dismissing');
      return;
    }
    TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_SLIDING_BRIGHTNESS, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    this.physicsValue = this.countPhysicsValue();
    this.log.showInfo(`onActionEnd, UI value: ${this.animData.uiValue}, physicsValue: ${this.physicsValue}`);
    this.setPhysicsValue(false);
    this.reportSliderSlideEvent();
    this.endDraggingAnimation();
    setTimeout(() => {
      this.physValUpdateUI = true;
      //根据真实物理值刷新UI
      this.onPhysicsValueChange(this.physicsValue);
    }, 50)
  }

  public onTapAction(event: GestureEvent) {
    if (event?.fingerList[0] === undefined) {
      return;
    }
    let uiValue = this.getUIValueOfTapAction(event);
    this.log.showInfo(`TapGesture ${event.fingerList[0].localX} , ${event.fingerList[0].localY}, uivalue: ${uiValue}`);
    this.startPhysicsValue = this.physicsValue;
    if (this.physValUpdateUI) {
      this.physValUpdateUI = false;
    }
    animateTo({
      curve: Curve.EaseOut,
      tempo: 5,
      onFinish: () => {
        this.onTapActionEnd()
        setTimeout(() => {
          this.physValUpdateUI = true;
          // 判断当前物理值和UI值映射是否一致，不一致触发刷新UI
          if (this.countPhysicsValue() !== this.physicsValue) {
            this.onPhysicsValueChange(this.physicsValue);
          }
        }, 50)
      }
    }, () => {
      this.animData.uiValue = uiValue;
    });
    this.physicsValue = this.countPhysicsValue();
    this.refreshIcon();
    this.log.showInfo(`onTapAction, UI value: ${this.animData.uiValue}, physicsValue: ${this.physicsValue}`);
    this.setPhysicsValue(false);
    this.reportSliderClickEvent();
  }

  // 音量条与亮度条走焦按键处理
  public onKeyPreAction(event: KeyEvent): boolean {
    if (this.animData.isSliderButtonFocused && event.keyCode === KeyCode.KEYCODE_ESCAPE) {
      this.animData.isSliderButtonFocused = false;
    } else if (!this.animData.isSliderButtonFocused && focusKeyArr.includes(event.keyCode)) {
      return false;
    } else if (!this.animData.isSliderButtonFocused && event.keyCode === KeyCode.KEYCODE_ENTER &&
      event.type === KeyType.Down) {
      this.animData.isSliderButtonFocused = true;
    } else if (this.animData.isSliderButtonFocused) {
      if (event.type === KeyType.Down && event.keyCode === KeyCode.KEYCODE_DPAD_LEFT) {
        this.animData.uiValue > sliderMoveRange ? this.animData.uiValue -= sliderMoveRange : this.animData.uiValue = 0;
      } else if (event.type === KeyType.Down && event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT) {
        this.animData.uiValue + sliderMoveRange < this.viewData.sliderWidth ?
          this.animData.uiValue += sliderMoveRange : this.viewData.sliderWidth;
      }
      this.onKeyAction?.()
    }
    return true;
  }

  public onKeyAction(event?: GestureEvent) {
    this.startPhysicsValue = this.physicsValue;
    if (this.physValUpdateUI) {
      this.physValUpdateUI = false;
    }
    this.physicsValue = this.countPhysicsValue();
    this.refreshIcon();
    this.log.showInfo(`onKeyAction, UI value: ${this.animData.uiValue}, physicsValue: ${this.physicsValue}`);
    this.setPhysicsValue(true);
    if (this.onKeyActionTaskId !== null) {
      clearTimeout(this.onKeyActionTaskId);
    }
    this.onKeyActionTaskId = setTimeout(() => {
      this.physValUpdateUI = true;
      this.onKeyActionTaskId = null;
    }, 50)
    this.reportSliderClickEvent();
  }

  /**
   * 点击调整进度，获取ui
   * @param event
   * @returns 点击位置对应的ui值
   */
  getUIValueOfTapAction(event: GestureEvent): number {
    if (this.getViewData().isHorizontal) {
      return RTLUtil.isRTL() ? this.getViewData().sliderWidth - event.fingerList[0].localX : event.fingerList[0].localX;
    } else {
      return this.getViewData().sliderHeight - event.fingerList[0].localY;
    }
  }

  /**
   * 刷新icon，默认直接播放至指定帧
   */
  public refreshIcon() {
    this.sliderLottieViewMode.refreshIcon();
  }

  /**
   * 点击动效结束后操作，由子类实现
   */
  public onTapActionEnd(): void {
  }

  private onCurrentEndPositionChange() {
    let currentEndPosition = this.currentEndPosition;
    let uiValue = this.getUIValueOfPanAction();
    animateTo({
      curve: curves.responsiveSpringMotion(0.1, 1, 0)
    }, () => {
      this.animData.uiValue = uiValue;
    })
    this.physicsValue = this.countPhysicsValue()
    this.log.showInfo(`onActionUpdate, UI value: ${this.animData.uiValue}, physicsValue: ${this.physicsValue}`);
    this.setPhysicsValue(true);
    this.playCurrentFrame(currentEndPosition);
  }

  /**
   * 滑动调整进度，获取ui
   * @returns
   */
  public getUIValueOfPanAction(): number {
    const sliderLength: number =
      this.getViewData().isHorizontal ? this.viewData.sliderWidth : this.viewData.sliderHeight;
    return Math.min(Math.max(this.currentEndPosition, 0), sliderLength);
  }

  public playCurrentFrame(currentEndPosition: number): void {
    this.sliderLottieViewMode.playCurrentFrame(currentEndPosition);
  }

  public getAccessibilityPhysicsValue(): string {
    if (this.getMaxValue() <= this.getMinValue()) {
      return this.physicsValue.toFixed(0);
    }
    const uiValue = this.animData.uiValue;
    const sliderLength: number =
      this.getViewData().isHorizontal ? this.viewData.sliderWidth : this.viewData.sliderHeight;
    let value = ((uiValue / sliderLength) * 100).toFixed(0);
    this.log.showInfo(`getAccessibilityPhysicsValue ${value}`);
    return value;
  }

  /**
   * 执行二级页展开收起动效
   * @param isShow
   */
  public executeSubpageAnim(isShow: boolean): void {
    if (isShow) {
      this.getAnimData().iconScale = { x: this.subpageIconScale, y: this.subpageIconScale };
    }
    animateTo({
      duration: 340,
      curve: Curve.Friction,
      onFinish: () => {
        if (!isShow) {
          this.getLottieAnimMode().onCanvasDisappear();
        }
      }
    }, () => {
      if (isShow) {
        this.getAnimData().sliderProgressBrightnessInternal = this.colorModeViewData.subpageBrightnessChoosenOption;
        this.getAnimData().iconBrightnessInternal = BrightnessOptionUtils.getInstance().foregroundPrimaryOptionLight;
        this.getAnimData().sliderProgressColor = this.colorModeViewData.subpageBrightnessBlockColor;
        return;
      }
      this.getAnimData().iconScale = { x: 1, y: 1 };
      this.getAnimData().sliderProgressBrightnessInternal = this.colorModeViewData.brightnessNotChosenOption;
      this.getAnimData().iconBrightnessInternal = this.colorModeViewData.foregroundPrimaryOptionOnBackground;
      this.getAnimData().sliderProgressColor = this.colorModeViewData.wifiBgOffColor;
    })
    // 二级页文字动效
    if (this.getViewData().isExpand) {
      if (isShow) {
        animateTo({
          delay: 100,
          duration: 150,
          curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
        }, () => {
          this.getAnimData().subpageOpacity = 1;
          this.getAnimData().subpageScale = { x: 1, y: 1, centerY: 0.3 };
        })
      } else {
        this.log.showInfo(`executeSubpageAnim false`);
        animateTo({
          duration: 100,
          curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
        }, () => {
          this.getAnimData().subpageOpacity = 0;
          this.getAnimData().subpageScale = {
            x: 0.8,
            y: 0.8,
            centerY: 0.3
          };
        })
      }
    }
  }

  /**
   * 深浅色模式切换改变切换图标颜色，包含图片和lottie
   * @param mode 深浅色模式
   */
  public onColorModeChange(mode: number): void {
    this.log.showInfo(`onColorModeChange, mode is ${mode} currentColorMode ${this.currentColorMode} `);
    if (this.currentColorMode === mode) {
      return;
    }
    this.currentColorMode = mode;
    let iconColor =
      mode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? $r('app.color.control_center_brightness_sun_write') :
      $r('app.color.control_center_brightness_sun_black');
    this.getLottieAnimMode().changeLottieColor(this.colorTool.getArrayColor(iconColor));
    this.getAnimData().iconColor = iconColor;
  }
}