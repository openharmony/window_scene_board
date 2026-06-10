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


import { Log } from '../utils/Log';
import { WallpaperAnimationConstant } from './WallpaperAnimationConstant';
import lazy { WallpaperAnimator } from './WallpaperAnimator';
import { WallpaperConstants } from './WallpaperConstants';
import { ScbState } from './WallpaperConstants';

const TAG: string = 'WallpaperChoreographer';

/**
 * Coordinates the request and mark property dirtiness of wallpaper animation
 *
 * To mark properties that need to be animated, call setDirtyMask before submitting animation
 *
 * Specify animation type and callbacks for animation by calling submitAnimation
 *
 * @since 2024-04-28
 */
export class WallpaperChoreographer {
  private dirtyMask: number = 0x0;

  /**
   * Mark dirty mask of certain wallpaper component property. Mask list as follows:
   * 00001 - blur radius
   * 00010 - light up effect
   * 00100 - Fullscreen AOD dimming
   * 01000 - Lockscreen opacity
   *
   * @param propertyMask Property that about to be marked as dirty.
   */
  public setDirtyMask(propertyMask: number): void {
    this.dirtyMask |= propertyMask;
  }

  /**
   * Query and filter unneeded value change and return the actual dirty mask for reference
   *
   * @param targetScbState Used to get the target value which will be compared with existing value
   * @returns Filtered dirty mask
   */
  public getActualDirtyMask(targetScbState: ScbState): number {
    let counter: number = 0;
    while (counter < WallpaperConstants.WALLPAPER_PROPERTY_LIST.length) {
      if (((this.dirtyMask >> counter) & 1) === 1) {
        const propKey: string = WallpaperConstants.WALLPAPER_PROPERTY_LIST[counter];
        const value: number = WallpaperAnimationConstant.ANIMATION_PARAMETER_LIST[counter][targetScbState];

        // Wipe dirty status if there's no actual value change
        if (!this.isValChange(propKey, value)) {
          this.dirtyMask &= ~(1 << counter);
          Log.info(TAG, `${propKey} removed from dirty mask as there's no actual value change.`);
        }
      }
      counter++;
    }

    return this.dirtyMask;
  }

  /**
   * Requesting animation to be submitted and played by the wallpaper animator
   *
   * @param animationType Type of animation which would decide which AnimateParam to be used
   * @param displayList List of operations that would be presented with the selected animation
   * @param onFinish Request to be executed when the animation is done
   */
  public submitAnimation(animationType: string, displayList: () => void, onFinish?: () => void): void {
    switch (animationType) {
      case WallpaperAnimationConstant.ID_ANIMATION_SPRING: {
        WallpaperAnimator.submitFrictionAnimation(displayList, onFinish);
        break;
      }
      case WallpaperAnimationConstant.ID_ANIMATION_SMOOTH: {
        WallpaperAnimator.submitSmoothAnimation(displayList, onFinish);
        break;
      }
      case WallpaperAnimationConstant.ID_ANIMATION_QUICK_APPLY:
      default: {
        Log.warn(TAG, `Invalid animation type ${animationType}, will apply without animation.`);
        WallpaperAnimator.applyImmediately(displayList, onFinish);
        break;
      }
    }
  }

  private isValChange(key: string, val: number): boolean {
    return AppStorage.get<number>(key) !== val;
  }
}