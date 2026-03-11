/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { SCBScreen } from '../SCBScreen';
import { curves } from '@kit.ArkUI';
import { LogDomain, LogHelper, AnimateToScheduleUtils, TraceUtil, DomainName } from '@ohos/basicutils';
import { CommonConstants } from '@ohos/launchercommon';
import lazy { OneHandModeBackground } from './OneHandModeBackground';
import {
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray
} from '@ohos/windowscene';
import lazy { SCBSingleHandController, SingleHandManagerInfo, SingleHandExitReason } from './SCBSingleHandController';
import { ScenePanelState } from '../SCBScenePanel';
import sceneSessionManager from '@ohos.sceneSessionManager';
import screenSessionManager from '@ohos.screenSessionManager';
import { image } from '@kit.ImageKit';
import { display } from '@kit.ArkUI';

const TAG = 'OneHandModeBox';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

@Component
export struct OneHandModeBox {
  @BuilderParam contextBuilder: void | undefined;

  build() {
    this.contextBuilder;
  }
}

export class OneHandModeManager {
  public screen: SCBScreen | null = null;
  public oneHandModeBackground: OneHandModeBackground | null = null;
  public screenSnapshot: image.PixelMap | null = null;
  public isAnimating: boolean = false;
  private transitionAnimationCount: number = 0;

  /**
   * Get the singleton of the one hand mode manager.
   */
  public static getInstance(): OneHandModeManager {
    if (!globalThis.oneHandModeManagerInstance) {
      log.showInfo(`OneHandModeManager init`);
      globalThis.oneHandModeManagerInstance = new OneHandModeManager();
    }
    return globalThis.oneHandModeManagerInstance;
  }

  switchOneHandMode(enableShow: boolean, singleHandManagerInfo: SingleHandManagerInfo,
    rect: sceneSessionManager.SessionRect, reason?: SingleHandExitReason): void {
    AnimateToScheduleUtils.raiseAnimateToCPUPriority(0);
    if (enableShow) {
      this.screen?.syncOneHandModeScreenWidthAndHeightByDisplay();
    }
    this.switchOneHandNormalMode(enableShow, singleHandManagerInfo);
  }

  private switchOneHandNormalMode(enableShow: boolean, singleHandManagerInfo: SingleHandManagerInfo): void {
    if (enableShow) {
      this.screen?.setEnableShowOneHandModeBackground(true);
      this.screen?.setRadius(CommonConstants.getDeviceRadius());
    } else {
      this.isAnimating = true;
    }
    this.addTransitionCount();
    let count: number = this.getTransitionCount();
    animateTo({
      curve: curves.responsiveSpringMotion(0.3, 1),
      onFinish: () => {
        if (!enableShow) {
          SCBSingleHandController.getInstance().notifySingleHandModeAnimationFinish(false);
          if (count === this.getTransitionCount()) {
            // radius should be zero when exit one hand mode
            this.screen?.setRadius(0);
            this.screen?.setEnableShowOneHandModeBackground(false);
            this.clearTransitionCount();
          }
        }
      }
    }, () => {
      this.screen?.updateScale(singleHandManagerInfo.x, singleHandManagerInfo.y, singleHandManagerInfo.centerX,
        singleHandManagerInfo.centerY);
      if (!enableShow) {
        this.oneHandModeBackground?.setOpacity(0);
        this.screen?.setOneHandModeBoxBorderProperties(0, '#00ffffff');
      } else {
        this.screen?.setOneHandModeBoxBorderProperties(1.5, '#33b3b6b7');
      }
    });
    animateTo({
      curve: curves.responsiveSpringMotion(0.3, 1),
      delay: 50,
      onFinish: () => {
        this.isAnimating = false;
      }
    }, () => {
      if (enableShow) {
        this.oneHandModeBackground?.setOpacity(0.5);
      }
    });
  }

  private addTransitionCount(): void {
    log.showInfo(`addTransitionCount: ${this.transitionAnimationCount}`);
    this.transitionAnimationCount++;
    AnimateToScheduleUtils.raiseAnimateToCPUPriority(0);
  }

  private getTransitionCount(): number {
    log.showInfo(`getTransitionCount: ${this.transitionAnimationCount}`);
    return this.transitionAnimationCount;
  }

  private clearTransitionCount(): void {
    log.showInfo(`clearTransitionCount: ${this.transitionAnimationCount}`);
    this.transitionAnimationCount = 0;
  }
}