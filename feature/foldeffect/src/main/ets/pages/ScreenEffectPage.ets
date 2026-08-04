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
import { ApsUtils, DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBPropertyChangeReason } from '@ohos/windowscene';
import { ScenePanelState } from '@ohos/windowscene';
import mattes from 'libeffectrender.so';
import animator, { AnimatorResult } from '@ohos.animator';
import { StateMattesSwitchStrategy } from '../mattesstrategy/StateMattesSwitchStrategy';
import { MainPageListener } from '../mattesstrategy/MattesSwitchStrategy';
// import apsManager from '@ohos.graphic.apsManager';
import {
  StyleConstants,
  AppBubbleEventData
} from '@ohos/launchercommon';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { ScreenLockApi } from '@ohos/screenlockcommon';

const TAG: string = 'ScreenMattes';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const ANIMATION_DURATION: number = 450;
const ANIMATION_DELAY: number = 0;
const ANIMATION_ITERATION: number = 1;
const TEXTURE_BEGIN: number = -0.2;
const TEXTURE_END: number = 2.8;
const LIGHT_BEGIN: number = 0;
const LIGHT_END: number = 0.7;
const INTENSITY_BEGIN: number = 0.07;
const INTENSITY_END: number = 0;
const ANIMATION_BEGIN: number = 0;
const ANIMATION_END: number = 1;
const SUB_ANIMATOR_START_NUM: number = 2;
const SUB_ANIMATOR_BACKGROUND_CHANGE_NUM: number = 1;
const DIRECT_TO_BOTTOM: number = 0;
const DIRECT_TO_LEFT: number = 90;
const DIRECT_TO_TOP: number = 180;
const DIRECT_TO_RIGHT: number = 270;

const EXPECTED_FRAME_RATE_RANGE: ExpectedFrameRateRange = {
  expected: 120,
  min: 120,
  max: 120,
};

enum MattesDeviceType {
  LARGE_FOLD = 0,
  SMALL_NEXT_FOLD = 1,
  INVALID = -1,
}

enum MattesDirection {
  VERTICAL_DEFAULT = 0,
  VERTICAL_REVERSE = 1,
  HORIZONTAL_DEFAULT = 2,
  HORIZONTAL_REVERSE = 3,
  INVALID = -1,
}

@Component
export struct ScreenEffectPage {
  private textureProgress: number = -0.15;
  private lightProgress: number = 0;
  private intensityProgress: number = 0;
  private isFold: boolean = true;
  private isRunning: boolean = false;
  private isSubAnimationRunning: boolean = false;
  private isUsingSubThread: boolean = false;
  private panelState: ScenePanelState = ScenePanelState.HOME;
  private frameNum: number = 0;
  private subFrameNum: number = 0;
  private deviceType: MattesDeviceType = MattesDeviceType.INVALID;
  private rotation: number = 0;
  @State pageBackgroundColor: Color = Color.Transparent;

  private mainAnimator: AnimatorResult = animator.create({
    duration: ANIMATION_DURATION,
    easing: 'sharp',
    delay: ANIMATION_DELAY,
    fill: 'both',
    direction: 'normal',
    iterations: ANIMATION_ITERATION,
    begin: ANIMATION_BEGIN,
    end: ANIMATION_END
  })

  private subAnimator: AnimatorResult = animator.create({
    duration: ANIMATION_DURATION,
    easing: 'sharp',
    delay: ANIMATION_DELAY,
    fill: 'both',
    direction: 'normal',
    iterations: ANIMATION_ITERATION,
    begin: ANIMATION_BEGIN,
    end: ANIMATION_END
  })

  private calculateDirection(): MattesDirection {
    if (this.deviceType === MattesDeviceType.SMALL_NEXT_FOLD) {
      switch (this.rotation) {
        case DIRECT_TO_BOTTOM:
          return MattesDirection.VERTICAL_REVERSE;
        case DIRECT_TO_LEFT:
          return MattesDirection.HORIZONTAL_REVERSE;
        case DIRECT_TO_TOP:
          return MattesDirection.VERTICAL_DEFAULT;
        case DIRECT_TO_RIGHT:
          return MattesDirection.HORIZONTAL_DEFAULT;
        default:
          return MattesDirection.INVALID;
      }
    } else if (this.deviceType === MattesDeviceType.LARGE_FOLD) {
      return MattesDirection.HORIZONTAL_DEFAULT;
    } else {
      return MattesDirection.INVALID;
    }
  }

  private callNapiInit(): void {
    try {
      let mattesDirection: number = this.calculateDirection();
      if (mattesDirection !== -1) {
        log.showInfo(`set mattes direction: ${mattesDirection}`);
        mattes.setDirection(mattesDirection);
      } else {
        log.showWarn(`callNapiInit gets mattes direction failed, direction is ${mattesDirection}`);
      }
    } catch (err) {
      log.showWarn(`callNapiInit end catch error. Code is ${err?.code}, message is ${err?.message}`);
    }
  }

  private callNapiDraw(): void {
    try {
      mattes.draw(this.textureProgress, this.lightProgress, this.intensityProgress, this.isFold, this.isUsingSubThread);
    } catch (err) {
      log.showWarn(`callNapiDraw end catch error. Code is ${err?.code}, message is ${err?.message}`);
    }
  }

  private callNapiFinish(): void {
    try {
      mattes.finishDraw();
    } catch (err) {
      log.showWarn(`callNapiFinish end catch error. Code is ${err?.code}, message is ${err?.message}`);
    }
  }

  private calculateProgressValue(start: number, end: number, progress: number): number {
    return (end - start) * progress + start;
  }

  private drawAnimation(animationValue: number): void {
    this.textureProgress = this.calculateProgressValue(TEXTURE_BEGIN, TEXTURE_END, animationValue);
    this.lightProgress = this.calculateProgressValue(LIGHT_BEGIN, LIGHT_END, animationValue);
    this.intensityProgress = this.calculateProgressValue(INTENSITY_BEGIN, INTENSITY_END, animationValue);
    log.showInfo(`OnFrame progress: animationValue: ${animationValue},` +
      `texture:  ${this.textureProgress}, light: ${this.lightProgress}, intensity: ${this.intensityProgress}.`);
    this.callNapiDraw();
  }

  private initAnimation(): void {
    this.subAnimator.onFrame = (animationValue: number) => {
      this.subFrameNum++;
      log.showInfo(`subAnimation drawing：${this.subFrameNum}`);
      if (this.subFrameNum === SUB_ANIMATOR_BACKGROUND_CHANGE_NUM) {
        this.pageBackgroundColor = Color.Transparent;
      }
      this.drawAnimation(animationValue);
    }
    this.mainAnimator.onFrame = (animationValue: number) => {
      this.frameNum++;
      log.showInfo(`mainAnimator frameNum: ${this.frameNum}. animationValue: ${animationValue} subFrameNum: ${this.subFrameNum}`);
      if (this.frameNum < SUB_ANIMATOR_START_NUM && animationValue === ANIMATION_END) {
        log.showInfo(`mainAnimation ended unexpectedly at: ${this.frameNum}`);
        this.isRunning = false;
        this.mainAnimator.finish();
        this.frameNum = 0;
        if (!this.isSubAnimationRunning) {
          log.showInfo(`subAnimation starts unexpectedly`);
          this.isSubAnimationRunning = true;
          this.subFrameNum = 0;
          this.subAnimator.play();
        }
        log.showInfo(`mainAnimator frameNum return`);
        return;
      }
      if (this.frameNum === SUB_ANIMATOR_START_NUM) {
        log.showInfo(`mainAnimator finish, subAnimator playstart.`);
        log.showInfo(`mainAnimation ended at：${this.frameNum}`);
        this.isRunning = false;
        this.mainAnimator.finish();
        this.frameNum = 0;
        if (!this.isSubAnimationRunning) {
          log.showInfo(`subAnimation starts`);
          this.isSubAnimationRunning = true;
          this.subFrameNum = 0;
          this.subAnimator.play();
        }
        return;
      }
      if (this.isRunning) {
        log.showInfo(`mainAnimation drawing：${this.frameNum}`);
        this.drawAnimation(animationValue);
        this.pageBackgroundColor = Color.Black;
      }
    }
    this.subAnimator.onFinish = () => {
      log.showInfo(`subAnimation ended at：${this.subFrameNum}`);
      if (this.isSubAnimationRunning) {
        this.isSubAnimationRunning = false;
        AppStorage.setOrCreate('mattesPanelShow', false);
        this.callNapiFinish();
        if (this.panelState === ScenePanelState.FULLSCENE) {
          let sceneName = this.isFold ? 'EXPAND_TO_FOLD_WINDOWS' : 'FOLD_TO_EXPAND_WINDOWS';
          performanceMonitor.end(sceneName);
          // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLDING_SCREEN, StyleConstants.DEFAULT_0);
        }
        this.pageBackgroundColor = Color.Transparent;
        log.showInfo(`Mattes FoldedExpand animation now finish, mattesPanelShow = false, ` +
          `pageBackgroundColor ${this.pageBackgroundColor}`);
      }
    }
  }

  private animatorPlay(): void {
    log.showInfo('Mattes FoldedExpand animation Play');
    this.isRunning = true;
    this.mainAnimator.setExpectedFrameRateRange(EXPECTED_FRAME_RATE_RANGE);
    if (this.panelState === ScenePanelState.FULLSCENE) {
      let sceneName = this.isFold ? 'EXPAND_TO_FOLD_WINDOWS' : 'FOLD_TO_EXPAND_WINDOWS';
      performanceMonitor.begin(sceneName, performanceMonitor.ActionType.LAST_UP);
      // Aps control for window is FULLSCENE state
      // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLDING_SCREEN, StyleConstants.DEFAULT_1);
    }
    this.frameNum = 0;
    if (!ScreenLockApi.getLock()) {
      log.showInfo('animatorPlay: double animators');
      this.mainAnimator.play();
    }
    log.showInfo(`backgroundColor ${this.pageBackgroundColor}`);
  }

  private animatorFinish(): void {
    this.isRunning = false;
    this.isSubAnimationRunning = false;
    this.mainAnimator.finish();
    this.subAnimator.finish();
    this.callNapiFinish();
    log.showInfo('Mattes FoldedExpand animation Finish.');
  }

  private refreshIsFold(reason: SCBPropertyChangeReason): void {
    if (reason === SCBPropertyChangeReason.FOLD_TO_EXPAND) {
      this.isFold = false;
    }
    if (reason === SCBPropertyChangeReason.EXPAND_TO_FOLD) {
      this.isFold = true;
    }
  }

  private judgeUsingSubThread(): void {
    if (this.panelState === ScenePanelState.HOME) {
      this.isUsingSubThread = true;
    } else {
      this.isUsingSubThread = false;
    }
  }

  private drawBlackCover(): void {
    this.textureProgress = TEXTURE_BEGIN;
    this.lightProgress = LIGHT_BEGIN;
    this.intensityProgress = INTENSITY_BEGIN;
    this.callNapiDraw();
    this.pageBackgroundColor = Color.Black;
  }

  private mainPageListener: MainPageListener = {
    animatorPlay: (reason, scenePanelState, rotation) => {
      log.showInfo(`ScreenEffectPage listener called, reason = ${reason},
        scenePanelState = ${scenePanelState}, rotation = ${rotation}.`);
      // proceed interruption then play new animation.
      this.drawBlackCover();
      this.panelState = scenePanelState;
      this.rotation = rotation;
      if (this.isRunning || this.isSubAnimationRunning) {
        this.animatorFinish();
      }
      this.refreshIsFold(reason);
      this.callNapiInit();
      log.showInfo(`Status: isFold = ${this.isFold}, isUsingSubThread = ${this.isUsingSubThread},` +
        `pageBackgroundColor = ${this.pageBackgroundColor}`);
      this.animatorPlay();
    }
  }

  private initDeviceType(): void {
    if (DeviceHelper.isLargeInFoldProduct()) {
      this.deviceType = MattesDeviceType.LARGE_FOLD;
    } else {
      this.deviceType = MattesDeviceType.INVALID;
    }
  }

  aboutToAppear(): void {
    log.showInfo('ScreenMattesPage aboutToAppear.');
    this.initAnimation();
    this.initDeviceType();
    StateMattesSwitchStrategy.getInstance().addMainPageListener(this.mainPageListener);
  }

  aboutToDisappear(): void {
    StateMattesSwitchStrategy.getInstance().removeMainPageListener(this.mainPageListener);
    log.showInfo('ScreenMattesPage aboutToDisappear.');
  }

  build() {
    Stack() {
      XComponent({
        id: 'xcomponent-effectpage',
        type: XComponentType.SURFACE,
        libraryname: 'effectrender'
      })
        .backgroundColor(this.pageBackgroundColor)
        .onDestroy(() => {
          log.showInfo('the xcomponent destroy.');
        })
    }
    .width('100%')
    .height('100%')
  }
}