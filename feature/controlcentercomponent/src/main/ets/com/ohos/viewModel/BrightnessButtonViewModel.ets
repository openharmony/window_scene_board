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

import {
  AnimateToScheduleUtils,
  DomainName,
  LogHelper,
  LogDomain,
  Trace,
  TraceUtil
} from '@ohos/basicutils';
import {
  EvtBus,
  HiSysEventUtil,
  sEventManager,
  ConfigurationEvent,
  DeviceHelper,
  ViewManagerPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import {
  setBrightValue,
  ControlBrightnessManager
} from '@ohos/brightnesscomponent/src/main/ets/default/ControlBrightnessManager';
import {
  SliderButtonAnimViewData,
  SliderButtonViewData,
  SliderIconViewData
} from '@ohos/controlcentercommon/src/main/ets/sliderButton/SliderButtonViewData';
import { ScrollBlurEvent } from '@ohos/controlcentercommon/src/main/ets/scrollBlur/ScrollBlurEvent';
import { SliderButtonBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/sliderButton/SliderButtonBaseViewModel';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';
import { CommonData } from '@ohos/controlcentercommon/Index';
import { ToggleViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleViewData';
import { taskpool } from '@kit.ArkTS';
import { ControlCenterHiSysEventUtil } from '@ohos/controlcentercommon/src/main/ets/hiSysEvent/ControlCenterHiSysEventUtil';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import { curves } from '@kit.ArkUI';
import { BackgroundBlurOpacity, BackgroundOpacity } from '../model/BrightnessViewData';
import { BrightnessSharedViewData } from './BrightnessViewModel';
import sBrightnessController from './BrightnessController';
import { sBrightnessSubPageLayoutController } from '../controller/BrightnessSubPageLayoutController';
import { SliderButtonShareData } from '@ohos/controlcentercommon/src/main/ets/sliderButton/SliderButtonViewData';
import { RTLUtil } from '@ohos/componenthelper';
import { AutoBrightnessEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { ViewManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/ViewManagerAdapter';
import { DropDownAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/DropDownAdapter';

const TAG = 'Ctrl.BrightnessButtonViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const SLIDER_SCALE: number = 1.1;
const SCROLL_BLUR_DISAPPEAR_DELAY: number = 120;
const BRIGHTNESS_VALUE_REPORT_THRESHOLD: number = 10;
const AUTO_BRIGHTNESS_SWITCH: string = 'auto_brightness';

export class BrightnessButtonViewModel extends SliderButtonBaseViewModel {
  private backgroundOpacity: BackgroundOpacity = BrightnessSharedViewData.getInstance().getBackgroundOpacity();
  private blurOpacity: BackgroundBlurOpacity = BrightnessSharedViewData.getInstance().getBlurOpacity();
  private timeOutId: null | number = null;
  private maxBrightnessValue: number = ControlBrightnessManager.getInstance().getMax();
  private minBrightnessValue: number = ControlBrightnessManager.getInstance().getMin();
  // 控制中心头部模糊隐藏timeId
  private scrollBlurTimeId: number | null = null;
  private scrollBlurEvent: ScrollBlurEvent = new ScrollBlurEvent();
  private isRTL: boolean = RTLUtil.isRTL();
  private hidePanelTimeId: number | null = null;

  constructor(viewData: SliderButtonViewData, animData: SliderButtonAnimViewData,
    iconViewData: SliderIconViewData, logTag: string) {
    super(viewData, animData, iconViewData, logTag);
  }

  public aboutToAppear() {
    log.showInfo('aboutToAppear START');
    this.loadLottieData();
    super.aboutToAppear();
    this.applySunMaxIcon();
    if (this.getViewData().isExpand) {
      this.getLottieAnimMode().getIconViewData().iconName = $r('app.string.brightness_title');
      this.getLottieAnimMode().getIconViewData().subPageIcon = $r('sys.symbol.sun_max');
      this.executeSubpageAnim(true);
      //监听收起二级页事件
      sEventManager.subscribe('ControlCenterState', this.onControlCenterStateChange);
    }
    this.eventMgr.on(ConfigurationEvent, (event: ConfigurationEvent) => {
      log.showInfo('ConfigurationEvent');
      if (this.isRTL === RTLUtil.isRTL()) {
        return;
      }
      this.isRTL = RTLUtil.isRTL();
      sBrightnessController.loadDefaultLottie();
      this.updateLottieData();
    });
    this.eventMgr.on(AutoBrightnessEvent, (event: AutoBrightnessEvent) => {
      if (!(AppStorage.get('BrightnessController_lottieDataReady') as boolean)) {
        log.showInfo('lottieData not ready, wait initLottieData');
        return;
      }
      if (!this.getViewData().isExpand) {
        this.updateLottieData();
      }
    });
  }

  /**
   * 亮度条默认图标：鸿蒙 sun_max symbol
   */
  private applySunMaxIcon(): void {
    this.getAnimData().sliderIcon = $r('sys.symbol.sun_max');
    this.getAnimData().useSymbol = true;
    this.getAnimData().useLottieData = false;
    this.getLottieAnimMode().onCanvasDisappear();
  }

  private updateLottieData() {
    this.applySunMaxIcon();
  }

  public aboutToDisappear() {
    log.showInfo('aboutToDisappear START');
    super.aboutToDisAppear();
    //注销监听二级页事件
    sEventManager.off('ControlCenterState', this.onControlCenterStateChange);
    this.eventMgr.offAll();
  }

  /**
   * 控制中显示状态监听
   */
  private onControlCenterStateChange = (state: ControlCenterState): void => {
    log.showInfo(`ControlCenterState ${state.toString()}`)
    if (state === ControlCenterState.MAIN_LAYOUT) {
      this.executeSubpageAnim(false);
    }
  }

  /**
   * 加载lottie动画数据
   */
  public loadLottieData(isLottieDataReady: boolean = true): void {
    log.showInfo(`loadLottieData: ready=${isLottieDataReady} isExpand=${this.getViewData().isExpand}`)
    if (!isLottieDataReady && !DropDownAdapter.isDropDownShow()) {
      this.getLottieAnimMode().setLottieData(null);
      return;
    }
    this.getLottieAnimMode().setLottieData(this.getViewData().isExpand ?
      sBrightnessController.matchDefaultLottieData() : sBrightnessController.matchLottieData(false));
  }

  /**
   * 更新当前真实亮度值
   */
  public getPhysicsValue(): number {
    return AppStorage.get('BrightnessValue') as number;
  }

  /**
   * 最大亮度值
   */
  public getMaxValue(): number {
    return this.maxBrightnessValue;
  }

  /**
   * 最小亮度值
   */
  public getMinValue(): number {
    return this.minBrightnessValue;
  }

  /**
   * 将真实物理值写入数据库
   */
  public setPhysicsValue(continuous: boolean): void {
    // 收到写入数据库命令之后50ms内不再处理非写入数据库的操作，防止回调事件导致的ui跳变
    if (this.timeOutId !== null && continuous) {
      return;
    }
    if (!continuous) {
      this.timeOutId = setTimeout(() => {
        this.timeOutId = null;
      }, 50)
    }
    try {
      taskpool.execute(setBrightValue, this.physicsValue, continuous).catch((e: object) => {
        log.error(e);
      });
      let accessibilityPhysicsValue = this.getAccessibilityPhysicsValue();
      if (parseInt(accessibilityPhysicsValue) % BRIGHTNESS_VALUE_REPORT_THRESHOLD === 0) {
        AccessibilityUtil.sendAccessibility(`${accessibilityPhysicsValue}%}`);
      }
    } catch (error) {
      log.error('taskpool execute error', error);
    }
  }

  /**
   * 滑动条点击行为打点上报
   */
  public reportSliderClickEvent(): void {
    log.showInfo(`reportBrightnessSlideEvent start:${this.startPhysicsValue}  to:${this.physicsValue}`)
    ControlCenterHiSysEventUtil.reportCCBrightnessClick({
      STARTVALUE: this.startPhysicsValue,
      CLICKEDVALUE: this.physicsValue,
      ISNIGHTMODE: `${(AppStorage.get('DarkModeModel_DarkModeStatus') as CommonData)?.status}`,
      TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      LOCKSTATUS: AppStorage.get('lockStatus'),
      SCREENTYPE: 0
    })
  }

  /**
   * 滑动条滑动行为打点上报
   */
  public reportSliderSlideEvent(): void {
    log.showInfo(`reportBrightnessSlideEvent start:${this.startPhysicsValue}  to:${this.physicsValue}`)
    HiSysEventUtil.reportCCBrightnessSlide({
      STARTPROGRESS: this.startPhysicsValue,
      STOPPROGRESS: this.physicsValue,
      ISNIGHTMODE: `${(AppStorage.get('DarkModeModel_DarkModeStatus') as CommonData)?.status}`,
      TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      LOCKSTATUS: AppStorage.get('lockStatus'),
      SCREENTYPE: 0
    });
  }

  /**
   * 通过真实亮度值计算UI值
   * UI = ((physicsValue - minBrightnessValue) / physicsValueRange) ^ (1 / 1.8) * sliderWidth
   * @returns
   */
  public countUIValue(): number {
    const sliderLength: number =
      this.getViewData().isHorizontal ? this.getViewData().sliderWidth : this.getViewData().sliderHeight;
    let percentage = Math.pow(((this.physicsValue - this.minBrightnessValue) / this.physicsValueRange), 1 / 1.8);
    let brightnessUI = sliderLength * percentage;
    log.showInfo(`count ui value:${brightnessUI} according to physics value:${this.physicsValue}`)
    return brightnessUI;
  }

  /**
   * 通过UI值计算真实亮度值
   * PhysicsValue = (UI / physicsValueRange)^1.8 * physicsValueRange + minBrightnessValue
   * @returns
   */
  public countPhysicsValue(): number {
    let uiValue = this.getAnimData().uiValue;
    const sliderLength: number =
      this.getViewData().isHorizontal ? this.getViewData().sliderWidth : this.getViewData().sliderHeight;
    let brightness =
      Math.pow(uiValue / sliderLength, 1.8) * this.physicsValueRange + this.minBrightnessValue;
    log.showInfo(`count brightness value:${brightness} according to ui value:${uiValue}`)
    return Math.round(brightness);
  }

  public onLongPressAction(event: GestureEvent, isHorizontal: boolean = true): void {
    super.onLongPressAction(event);
    sBrightnessSubPageLayoutController.showWindow(isHorizontal);
  }

  /**
   * 亮度条开始拖动动效
   */
  public startDraggingAnimation(): void {
    super.startDraggingAnimation();
    this.hideControlPanel();
  }

  // 隐藏控制中心面板
  private hideControlPanel(): void {
    this.hidePanelTimeId = setTimeout(() => {
      this.executionSliderChooseAnimation();
      log.showInfo('start hide CC mainLayout');
      this.blurOpacity.blurOpacity = 0;
      animateTo({
        curve: curves.cubicBezierCurve(0.33, 0.0, 0.67, 1.0),
        duration: 150
      }, () => {
        if (this.getViewData().isHorizontal) {
          this.backgroundOpacity.verticalBrightOpacity = 0;
        } else {
          this.backgroundOpacity.horizontalBrightOpacity = 0;
        }
        this.backgroundOpacity.backgroundOpacity = 0;
        this.getAnimData().shadowRadius = 40;
        this.getAnimData().subpageHide = true;
      })
      // 隐藏顶部模糊
      if (!this.getViewData().isExpand) {
        this.scrollBlurTimeId = setTimeout(() => {
          this.scrollBlurEvent.setValue(0);
          EvtBus.post(ScrollBlurEvent, this.scrollBlurEvent);
          log.showInfo('post ScrollBlurEvent ' + this.scrollBlurEvent.command);
          this.scrollBlurTimeId = null;
        }, SCROLL_BLUR_DISAPPEAR_DELAY)
      }
      this.getAnimData().showBlurLayer = true;
      this.hidePanelTimeId = null;
    }, 300)
  }

  /**
   * 进度条整体放大动效
   */
  private executionSliderChooseAnimation(): void {
    animateTo({
      curve: curves.responsiveSpringMotion(0.28, 1, 0),
    }, () => {
      // 进度条局部放大
      if (!this.getViewData().isExpand) {
        this.getAnimData().buttonScale = { x: SLIDER_SCALE, y: SLIDER_SCALE };
      } else {
        this.getAnimData().sliderScale = { x: SLIDER_SCALE, y: SLIDER_SCALE };
        this.getAnimData().iconScale = { x: this.subpageIconScale * 1.1, y: this.subpageIconScale * 1.1 };
        // 设置图标偏移量
        let iconOffsetX =
          (this.getViewData().sliderWidth / 2 - this.getViewData().iconSize / 2 - this.getViewData().iconMargin) / 10;
        this.getAnimData().iconOffset = {
          x: (this.isRTL ? 1 : -1) * iconOffsetX
        };
      }
    })
  }

  public getAccessibility(type: string): string {
    if (type === 'text') {
      return ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_brightness'),
        `${this.getAccessibilityPhysicsValue()}%`);
    } else if (type === 'description') {
      let announceDesc = ResUtils.getInnerString(this.getViewData().isHorizontal ?
      $r('app.string.cc_accessibility_str_change_brightness_desc') :
      $r('app.string.cc_accessibility_str_change_vertical_brightness_desc'));
      if (!this.getViewData().isExpand && !this.getViewData().isSingleFoldStyle) {
        announceDesc += ' ' + ResUtils.getInnerString($r('app.string.cc_accessibility_str_long_click'));
      }
      return announceDesc;
    } else {
      return '';
    }
  }

  /**
   * 亮度条拖动结束动效
   */
  public endDraggingAnimation(): void {
    SliderButtonShareData.getInstance().isDragging = false;
    AccessibilityUtil.sendAccessibility(ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_change_brightness'),
      `${this.getAccessibilityPhysicsValue()}%}`));
    super.endDraggingAnimation();
    if (this.hidePanelTimeId !== null) {
      clearTimeout(this.hidePanelTimeId);
      this.hidePanelTimeId = null;
      return;
    }
    log.showInfo('start hide CC mainLayout');
    if (!this.getViewData().isExpand) {
      if (this.scrollBlurTimeId !== null) {
        clearTimeout(this.scrollBlurTimeId);
        this.scrollBlurTimeId = null;
      } else {
        this.scrollBlurEvent.setValue(1);
        EvtBus.post(ScrollBlurEvent, this.scrollBlurEvent);
        log.showInfo('post ScrollBlurEvent ' + this.scrollBlurEvent.command);
      }
    }
    this.blurOpacity.blurOpacity = 1;
    animateTo({
      curve: curves.cubicBezierCurve(0.33, 0.0, 0.67, 1.0),
      duration: 150,
    }, () => {
      this.backgroundOpacity.reset();
      this.getAnimData().shadowRadius = 0;
      this.getAnimData().subpageHide = false;
    });
    this.changeIconColor(false);
    animateTo({
      curve: curves.responsiveSpringMotion(0.28, 1, 0),
      onFinish: () => {
        this.physValUpdateUI = true;
      }
    }, () => {
      this.getAnimData().showBlurLayer = false;
      // 整体缩小
      this.getAnimData().buttonScale = { x: 1, y: 1 };
      if (this.getViewData().isExpand) {
        this.getAnimData().iconScale = { x: this.subpageIconScale, y: this.subpageIconScale };
        this.getAnimData().iconOffset = undefined;
      }
    })
  }

  /**
   * 点击开始
   */
  public onTapAction(event: GestureEvent): void {
    TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_TAP_BRIGHTNESS);
    super.onTapAction(event);
  }

  /**
   * 点击动效结束后记录ui值
   */
  public onTapActionEnd(): void {
    TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_TAP_BRIGHTNESS);
  }

  /**
   * 二级页开关点击回调
   *
   * @param state 开关状态
   */
  public onSwitchChange(state: boolean): void {
    sBrightnessController.setAutoBrightnessState(state);
    // 二级页开关点击打点
    HiSysEventUtil.reportCCQuickToggleClick({
      LOCKSTATUS: AppStorage.get('lockStatus'),
      TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      BUTTONNAME: AUTO_BRIGHTNESS_SWITCH,
      STATE: `${state}`,
      TYPE: 1
    });
  }

  /**
   * 获取自动亮度开关状态
   *
   * @returns 自动亮度开关状态
   */
  public getAutoBrightnessState(): boolean {
    return sBrightnessController.getAutoBrightnessState();
  }
}