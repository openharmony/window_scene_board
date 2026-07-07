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
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import { ApsUtils } from '@ohos/frameworkwrapper';
import { SCBPropertyChangeReason } from '@ohos/windowscene';
import { StateMattesSwitchStrategy } from '../mattesstrategy/StateMattesSwitchStrategy';
import { MainPageListener } from '../mattesstrategy/MattesSwitchStrategy';
// import apsManager from '@ohos.graphic.apsManager';
import { StyleConstants } from '@ohos/launchercommon';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import systemDateTime from '@ohos.systemDateTime';
import { Queue } from '@kit.ArkTS';

const TAG: string = 'PocketFoldPage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const DEFAULT_OPTICAL_FLOW_COLOR: string = 'rgba(0, 0, 0, 1)';
const OPTICAL_FLOW_ANIM_DURATION: number = 300;
const OPTICAL_FLOW_ANIM_DELAY_TIME: number = OPTICAL_FLOW_ANIM_DURATION / 3;

const OPTICAL_FLOW_ANIM_ALPHA_DURATION: number = 200;
const OPTICAL_FLOW_ANIM_ALPHA_DELAY_TIME: number = 200;

const CURSOR_POSITION_START: number = 0.2;
const CURSOR_POSITION_END: number = 1;

const ZERO_ALPHA_VALUE: number = 0;
const DEFAULT_ALPHA_VALUE: number = 1;
const FIVE_PERCENT_OFF_ALPHA: number = 0.95;

const DEFAULT_SCALE_VALUE: number = 1;
const DOUBLE_SCALE_VALUE: number = 2;

const SCREEN_ROTATION_0: number = 0;
const SCREEN_ROTATION_90: number = 90;
const SCREEN_ROTATION_180: number = 180;
const SCREEN_ROTATION_270: number = 270;

const BENDING_TIME_LIMIT: number = 60 * 1000;
const BENDING_RESET_TIME: number = 6 * 1000;
const BENDING_OPERATION_LIMIT: number = 10;

class BendingLimiter {
  private _lastTimeUpdate: number = 0;

  private _isFrequently: boolean = false;

  private _duration: number = 0;

  private _resetTimer: number = -1;

  private _timeSlotQueue: Queue<number> = new Queue<number>();

  /**
   * Obtains whether the bending behavior is frequent.
   *
   * @returns  Boolean value
   */
  public get isBendingFrequently(): boolean {
    return this._isFrequently;
  }

  /**
   * Each times of `onScreenPropertyChange` callback coming; would update this limiter records value
   */
  public updateBendingValue(): void {
    if (!this.isBendingFrequently && this.processTimeSlotQueue()) {
      this._isFrequently = true;
    }
    clearTimeout(this._resetTimer);
    this._resetTimer = setTimeout(() => {
      this._lastTimeUpdate = 0;
      this._duration = 0;
      this._isFrequently = false;
      this._timeSlotQueue = new Queue<number>();
      log.showWarn('BendingLimiter timeout Reset');
    }, BENDING_RESET_TIME);
  }

  /*
  * 频繁开合判断:
  * 1. 在时间限制`BENDING_TIME_LIMIT`内
  * 2. 开合次数大于等于BENDING_OPERATION_LIMIT
  * 则认为处于频繁开合阶段，不做动效
   */
  private processTimeSlotQueue(): boolean {
    if (this._lastTimeUpdate === 0) {
      this._lastTimeUpdate = systemDateTime.getTime();
      return false;
    }
    let currentTime: number = systemDateTime.getTime();
    let timeSlot: number = currentTime - this._lastTimeUpdate;
    this._lastTimeUpdate = currentTime;

    // 如果时间合大于限制，时间窗口滑动, 列头出队;
    while (this._duration >= BENDING_TIME_LIMIT && this._timeSlotQueue.length != 0) {
      this._duration -= this._timeSlotQueue.pop();
    }

    this._timeSlotQueue.add(timeSlot);
    this._duration += timeSlot;

    // 队列时间差个数未满阈值，未达时间限制
    if (this._timeSlotQueue.length < BENDING_OPERATION_LIMIT) {
      return false;
    }
    return this._duration < BENDING_TIME_LIMIT && this._timeSlotQueue.length >= BENDING_OPERATION_LIMIT;
  }
}

@Component
export struct PocketFoldPage {

  private animCount: number = 0;

  private bendingLimiter: BendingLimiter = new BendingLimiter();

  @State isInOuterScreen: boolean = true;
  @State outerScreenDirection: GradientDirection = GradientDirection.Right;

  @State cursorPosition: number = CURSOR_POSITION_START;
  @State componentOpacity: number = DEFAULT_ALPHA_VALUE;
  @State scaleValue: number = DEFAULT_SCALE_VALUE;

  @State opticalFlowColorStart: string = DEFAULT_OPTICAL_FLOW_COLOR;
  @State opticalFlowColorEnd: string = DEFAULT_OPTICAL_FLOW_COLOR;
  @State alphaGradientBegin: number = DEFAULT_ALPHA_VALUE;
  @State alphaGradientEnd: number = DEFAULT_ALPHA_VALUE;

  private resetGradientProp(): void {
    this.cursorPosition = CURSOR_POSITION_START;
    this.alphaGradientBegin = DEFAULT_ALPHA_VALUE;
    this.alphaGradientEnd = DEFAULT_ALPHA_VALUE;

    this.opticalFlowColorStart = DEFAULT_OPTICAL_FLOW_COLOR;
    this.opticalFlowColorEnd = DEFAULT_OPTICAL_FLOW_COLOR;

    this.scaleValue = DEFAULT_SCALE_VALUE;
    this.componentOpacity = DEFAULT_ALPHA_VALUE;
    log.showInfo('Reset all of the alpha gradient property');
  }

  private startOpticalFlowAnim() {
    let sceneName: string = 'outerOpticalFLow';
    this.onAnimationStart(sceneName);
    animateTo({
      curve: Curve.Sharp,
      duration: OPTICAL_FLOW_ANIM_DURATION,
    }, () => {
      this.cursorPosition = CURSOR_POSITION_END;
      this.alphaGradientBegin = ZERO_ALPHA_VALUE;
      this.opticalFlowColorStart = `rgba(0, 0, 0, ${this.alphaGradientBegin})`;
    });

    animateTo({
      curve: Curve.Sharp,
      duration: OPTICAL_FLOW_ANIM_ALPHA_DURATION,
      delay: OPTICAL_FLOW_ANIM_ALPHA_DELAY_TIME,
    }, () => {
      this.componentOpacity = ZERO_ALPHA_VALUE;
    });

    animateTo({
      curve: Curve.Sharp,
      duration: OPTICAL_FLOW_ANIM_DURATION,
      delay: OPTICAL_FLOW_ANIM_DELAY_TIME,
      onFinish: () => {
        this.onAnimationFinished(sceneName);
      },
    }, () => {
      this.scaleValue = DOUBLE_SCALE_VALUE;
      this.alphaGradientEnd = FIVE_PERCENT_OFF_ALPHA;
      this.opticalFlowColorEnd = `rgba(0, 0, 0, ${this.alphaGradientEnd})`;
    });
  }

  private onAnimationStart(sceneName: string): void {
    log.showInfo('startOpticalFlowAnim Begin');
    performanceMonitor.begin(sceneName, performanceMonitor.ActionType.LAST_UP);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLDING_SCREEN, StyleConstants.DEFAULT_1);
    this.animCount++;
  }

  private onAnimationFinished(sceneName: string): void {
    this.animCount--;
    if (this.animCount === 0) {
      AppStorage.setOrCreate('mattesPanelShow', false);
      this.resetGradientProp();
      performanceMonitor.end(sceneName);
      // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLDING_SCREEN, StyleConstants.DEFAULT_0);
      log.showInfo('startOpticalFlowAnim End');
    }
  }

  private interruptAnimation(): void {
    animateTo({
      duration: 0,
    }, () => {
      this.resetGradientProp();
    });
  }

  private updateOuterScreenDirection(rotation: number): void {
    if (!this.isInOuterScreen) {
      log.showInfo('updateOuterScreenDirection is not in OuterScreen');
      return;
    }
    if (rotation === SCREEN_ROTATION_0) {
      this.outerScreenDirection = GradientDirection.Bottom;
    } else if (rotation === SCREEN_ROTATION_90) {
      this.outerScreenDirection = GradientDirection.Left;
    } else if (rotation === SCREEN_ROTATION_180) {
      this.outerScreenDirection = GradientDirection.Top;
    } else if (rotation === SCREEN_ROTATION_270) {
      this.outerScreenDirection = GradientDirection.Right;
    }
    log.showInfo(`Update outerScreenDirection = ${this.outerScreenDirection}, rotation = ${rotation}.`);
  }

  private mainPageListener: MainPageListener = {
    animatorPlay: (reason, scenePanelState, rotation) => {
      log.showInfo(`PocketFoldPage listener called, reason = ${reason},
        scenePanelState = ${scenePanelState}, rotation = ${rotation}.`);
      this.bendingLimiter.updateBendingValue();
      if (reason === SCBPropertyChangeReason.FOLD_TO_EXPAND) {
        this.isInOuterScreen = false;
      }
      if (reason === SCBPropertyChangeReason.EXPAND_TO_FOLD) {
        this.isInOuterScreen = true;
      }

      if (this.bendingLimiter.isBendingFrequently) {
        log.showWarn('Unable to play Animation, cause it is reached BendingLimiter limit');
        AppStorage.setOrCreate('mattesPanelShow', false);
        performanceMonitor.begin('OpticalFlow Reject', performanceMonitor.ActionType.LAST_UP);
        performanceMonitor.end('OpticalFlow Reject');
        return;
      }

      this.updateOuterScreenDirection(rotation);
      this.interruptAnimation();
      this.startOpticalFlowAnim();
    }
  }

  aboutToAppear(): void {
    log.showInfo('PocketFoldPage aboutToAppear.');
    StateMattesSwitchStrategy.getInstance().addMainPageListener(this.mainPageListener);
  }

  aboutToDisappear(): void {
    StateMattesSwitchStrategy.getInstance().removeMainPageListener(this.mainPageListener);
    log.showInfo('PocketFoldPage aboutToDisappear.');
  }

  @Builder
  outerScreenPage() {
    Row()
      .height('100%')
      .width('100%')
      .linearGradient({
        direction: this.outerScreenDirection,
        repeating: false,
        colors: [
          [this.opticalFlowColorStart, 0],
          [this.opticalFlowColorEnd, this.cursorPosition],
          [this.opticalFlowColorEnd, 1],
        ],
      })
  }

  @Builder
  innerScreenPage() {
    Column() {
      Row()
        .height('50%')
        .width('100%')
        .linearGradient({
          direction: GradientDirection.Top,
          repeating: false,
          colors: [
            [this.opticalFlowColorStart, 0],
            [this.opticalFlowColorEnd, this.cursorPosition],
            [this.opticalFlowColorEnd, 1],
          ],
        })
        .alignItems(VerticalAlign.Top)
      Row()
        .height('50%')
        .width('100%')
        .linearGradient({
          direction: GradientDirection.Bottom,
          repeating: false,
          colors: [
            [this.opticalFlowColorStart, 0],
            [this.opticalFlowColorEnd, this.cursorPosition],
            [this.opticalFlowColorEnd, 1],
          ],
        })
        .alignItems(VerticalAlign.Bottom)
    }
    .height('100%')
    .width('100%')
  }

  build() {
    Stack() {
      if (this.isInOuterScreen) {
        this.outerScreenPage()
      } else {
        this.innerScreenPage()
      }
    }
    .scale({x: this.scaleValue, y: this.scaleValue, centerX: '50%', centerY: '50%'})
    .opacity(this.componentOpacity)
    .height('100%')
    .width('100%')
  }
}