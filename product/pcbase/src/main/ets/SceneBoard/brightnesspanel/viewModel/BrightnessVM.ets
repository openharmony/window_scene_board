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

import { LogHelper, LogDomain, AnimateToScheduleUtils } from '@ohos/basicutils';
import { viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { curves } from '@kit.ArkUI';
import mBrightnessManager from '../common/BrightnessManager';
import { RTLUtil } from '@ohos/componenthelper';
import { ResUtils } from '@ohos/windowscene';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { AccessibilityUtil } from '@ohos/screenlockcommon';

// 亮度条进度值，常态值
@Observed
export class BrightnessProgress {
  public brightnessUIValue: number = 0;
  public showBlurLayer: boolean = false;
}

@Observed
export class VolumeDraggingViewData {
  public isDragging: boolean = false;
  public currentEndPositionX: number = 0;
}

const TAG = 'BrightnessVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class BrightnessVM {
  private readonly BRIGHTNESS_WIDTH: number = 312; //vp
  private isPanelDismissing: boolean = false;
  private startBrightness: number = 0;
  public currentEndPositionX: number = 0;
  private lastX: number = 0;
  private lastEndPositionX: number = 0;
  private brightnessRange: number = mBrightnessManager.getMax() - mBrightnessManager.getMin();
  private viewData: BrightnessProgress = new BrightnessProgress();
  private draggingViewData: VolumeDraggingViewData = new VolumeDraggingViewData();
  private physicsValue: number = 0;
  private needUpdateForPhysicsChange: boolean = true;

  public getViewData(): BrightnessProgress {
    return this.viewData;
  }

  public getDraggingViewData(): VolumeDraggingViewData {
    return this.draggingViewData;
  }

  public aboutToAppear(physicsValue: number) {
    this.physicsValue = physicsValue;
    this.viewData.brightnessUIValue = this.countUIValue();
  }

  countUIValue() {
    let percentage = Math.pow(((this.physicsValue - mBrightnessManager.getMin()) / this.brightnessRange), 1 / 1.8);
    let brightnessUI = this.BRIGHTNESS_WIDTH * percentage;
    log.showInfo(`phsics value:${this.physicsValue};countUIValue percentage:${percentage};ui value:${brightnessUI}`);
    return brightnessUI;
  }

  private countPhysicsValue(uiVar: number): number {
    let range = this.brightnessRange;
    if (range <= 0) {
      return mBrightnessManager.getMin();
    }
    let brightness = Math.pow(uiVar / this.BRIGHTNESS_WIDTH, 1.8) * range + mBrightnessManager.getMin();

    if (brightness > mBrightnessManager.getMax()) {
      brightness = mBrightnessManager.getMax();
    } else if (brightness < mBrightnessManager.getMin()) {
      brightness = mBrightnessManager.getMin();
    }
    log.showInfo(`count brightness value according to ui value: ${brightness};brightnessRange: ${range}`);
    return Math.round(brightness);
  }

  public updatePhysicsValue(physicsValue: number) {
    this.physicsValue = physicsValue;
    log.showInfo(`updatePhysicsValue to: ${this.physicsValue}, current ui value is ${this.viewData.brightnessUIValue}`);
    // 当滑动亮度条时，不执行更新物理值导致的亮度条动效，避免亮度条来回跳动
    if (!this.needUpdateForPhysicsChange) {
      log.showInfo('updatePhysicsValue not need update value for physics value change');
      return;
    }
    // 二级菜单隐藏的时候不执行动效，优化性能
    if (viewMgrPolicy.isViewShowing(ViewType.BRIGHTNESS_PANEL)) {
      animateTo({
        curve: curves.responsiveSpringMotion(0.28, 0.97, 0)
      }, () => {
        this.viewData.brightnessUIValue = this.countUIValue();
      });
    } else {
      this.viewData.brightnessUIValue = this.countUIValue();
    }
    log.showInfo(`updatePhysicsValue, ui value change to: ${this.viewData.brightnessUIValue}`);
  }

  public handleOnTouch(event?: TouchEvent): void {
    if (event?.type === TouchType.Move) {
      return;
    }
    if (this.draggingViewData.isDragging) {
      return;
    }

    animateTo({
      curve: Curve.EaseOut,
      tempo: 5
    }, () => {
      this.viewData.brightnessUIValue =
        RTLUtil.isRTL() ? this.BRIGHTNESS_WIDTH - event!.touches[0]?.x : event!.touches[0]?.x;
      log.showInfo('on touch, refresh ui value: %{public}d', this.viewData.brightnessUIValue);
    });
    let physicsValue = this.countPhysicsValue(this.viewData.brightnessUIValue);

    if (event?.type === TouchType.Down) {
      this.updateScreenBrightness(physicsValue, false);
      this.physicsValue = physicsValue
    }
  }

  public onPanActionStart(event: GestureEvent) {
    this.startBrightness = this.physicsValue;
    this.isPanelDismissing = DropDownPanelManager.isPanelDismissing();
    if (this.isPanelDismissing) {
      log.showWarn('panel is dismissing');
      return;
    }

    log.showInfo('touch start');
    if (!this.draggingViewData.isDragging) {
      this.draggingViewData.isDragging = true;
    }
    this.needUpdateForPhysicsChange = false;
    this.currentEndPositionX = this.viewData.brightnessUIValue;
    AnimateToScheduleUtils.raiseAnimateToCPUPriority(0);
    this.lastX = (RTLUtil.isRTL() ? this.BRIGHTNESS_WIDTH - event?.offsetX : event?.offsetX) ?? 0;
    this.lastEndPositionX = 0;
  }

  public onPanActionUpdate(event: GestureEvent) {
    if (!event) {
      return;
    }
    if (this.isPanelDismissing) {
      log.showWarn('panel is dismissing');
      return;
    }
    if (!this.draggingViewData.isDragging) {
      log.showDebug('onActionUpdate, not dragging, return');
      return;
    }

    let moveDistance = (RTLUtil.isRTL() ? this.BRIGHTNESS_WIDTH - event?.offsetX : event?.offsetX) - this.lastX;
    if (Math.abs(moveDistance - 0) < Number.EPSILON) {
      return;
    }

    this.lastX = RTLUtil.isRTL() ? this.BRIGHTNESS_WIDTH - event?.offsetX : event?.offsetX;
    let dis = event?.offsetX - this.lastEndPositionX;
    this.currentEndPositionX = RTLUtil.isRTL() ? this.currentEndPositionX - dis :
      this.currentEndPositionX + dis;
    this.lastEndPositionX = event?.offsetX;
    this.onCurrentEndPositionXChange();
  }

  public onPanActionEnd(event: GestureEvent) {
    log.showInfo('touch end');
    if (!this.draggingViewData.isDragging) {
      log.showDebug('onActionEnd, not dragging, return');
      this.needUpdateForPhysicsChange = true;
      return;
    }
    if (this.isPanelDismissing) {
      log.showWarn('panel is dismissing');
      this.needUpdateForPhysicsChange = true;
      return;
    }

    this.draggingViewData.isDragging = false;
    let physicsValue = this.countPhysicsValue(this.viewData.brightnessUIValue);
    log.showInfo(`onActionEnd, UI value: ${this.viewData.brightnessUIValue}, physicsValue: ${physicsValue}`);
    this.updateScreenBrightness(physicsValue, false);
    this.draggingViewData.currentEndPositionX = this.viewData.brightnessUIValue;
    this.needUpdateForPhysicsChange = true;
  }

  public onActionCancel(event: GestureEvent) {
    log.showInfo('onPanActionCancel');
    this.needUpdateForPhysicsChange = true;
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
      this.viewData.brightnessUIValue = Math.min(Math.max(this.currentEndPositionX, 0), this.BRIGHTNESS_WIDTH);
    })
    let physicsValue = this.countPhysicsValue(this.viewData.brightnessUIValue);
    this.updateScreenBrightness(physicsValue, true);
    this.draggingViewData.currentEndPositionX = currentEndPositionX;
  }

  // 更新亮度条
  private updateScreenBrightness(brightness: number, isDragging: boolean): void {
    try {
      mBrightnessManager.setPCValue(brightness);
      if (!isDragging) {
        log.showInfo('write brightness %{public}d to database', brightness);
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
    return ((brightness - mBrightnessManager.getMin()) / this.brightnessRange * 100).toFixed(0);
  }
}

let brightnessVM = new BrightnessVM();

export default brightnessVM as BrightnessVM;