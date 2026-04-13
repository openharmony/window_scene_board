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

import lazy { MashupHandler } from './MashupHandler';
import lazy { ThemeConstant, WallpaperType } from '../utils/ThemeConstant';
import { ScbState } from '../pages/WallpaperConstants';
import { Constants } from '../utils/Constants';
import { Log } from '../utils/Log';
import { GlobalContext } from '../utils/GlobalContext';

const TAG: string = 'EngineAnimationHandler';
const ANIMATION_SKIP: number = -1;

const SKIP_ANIMATION_REMAP: Map<number, number> = new Map([
  [ScbState.LOCKSCREEN, Constants.LOCKSCREEN_STATUS],
  [ScbState.DESKTOP, Constants.LAUNCHER_STATUS],
  [ScbState.AOD, Constants.AOD_STATUS],
  [ScbState.SLEEP, Constants.AOD_STATUS],
]);

/**
 * Handler class to process and manager animation request that about to be sent to ThemeEngine
 *
 * @since 2024-05-27
 */
export class EngineAnimationHandler {
  private mashupHandler: MashupHandler = MashupHandler.getInstance();

  /**
   * Handling transition animation request from SCB
   *
   * @param srcState Source SCB state
   * @param dstState Destination SCB state
   * @param isPlayAnimation If this animation request would be a 'single frame' op
   * @param taskId Used to identify animation request and its finish callback
   */
  public onTransitionAnimation(srcState: ScbState, dstState: ScbState, isPlayAnimation: boolean, taskId: number,
    sender: string): void {
    let scbStatePair: number = ThemeConstant.getStatePathIdentifier(srcState, dstState);
    Log.info(TAG, `Receiving dynamic animation play request ${srcState} - ${dstState}, ` +
      `identifier ${scbStatePair}, isPlayAnimation ${isPlayAnimation}, taskId ${taskId}, sender ${sender}`);
    AppStorage.setOrCreate<boolean>('isPlayAnimation', isPlayAnimation);

    if (!ThemeConstant.ANIMATION_MAP.has(scbStatePair)) {
      Log.warn(TAG, `Message pair ${scbStatePair} has no animation assigned.`);
      return;
    }

    let animationState: number = ThemeConstant.ANIMATION_MAP.get(scbStatePair) ?? ANIMATION_SKIP;
    if (animationState !== ANIMATION_SKIP) {
      AppStorage.setOrCreate<number>('originalAnimationState', animationState);
    }

    let candidateAnimation: number = this.mashupHandler.animationRemap(animationState);
    if (candidateAnimation === ANIMATION_SKIP) {
      Log.warn(TAG, 'Skipping transition animation. Check previous logs for reason');
      return;
    }


    // If asking not to play animation, remap to direct state
    if (!isPlayAnimation) {
      candidateAnimation = SKIP_ANIMATION_REMAP.get(dstState) ?? candidateAnimation;
    }

    // Repeat animation is allowed but won't be processed by AppStorage
    if (AppStorage.get<number>('animationState') === candidateAnimation) {
    } else {
      AppStorage.setOrCreate<number>('animationState', candidateAnimation);
    }

    Log.info(TAG, `Registering animation task id ${taskId}`);
    GlobalContext.getContext().setObject('animationTaskId', taskId);
    Log.info(TAG, `Syncing animation type ${candidateAnimation}`);
  }
}