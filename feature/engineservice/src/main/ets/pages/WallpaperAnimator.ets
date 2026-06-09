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
import { WallpaperAnimationConstant } from "./WallpaperAnimationConstant";

/**
 * Actor object to use ArkUI interface to play the wallpaper animation requested by the Choreographer
 *
 * @since 2024-04-28
 */
export class WallpaperAnimator {
  private static frictionAnimationParam: AnimateParam = {
    curve: Curve.Friction,
    duration: WallpaperAnimationConstant.FRICTION_ANIMATION_DURATION,
    onFinish: () => {},
  };

  private static smoothAnimationParam: AnimateParam = {
    delay: WallpaperAnimationConstant.ALPHA_DELAY_DEFAULT,
    duration: WallpaperAnimationConstant.ALPHA_DURATION,
    curve: WallpaperAnimationConstant.SMOOTH_CURVE,
    onFinish: () => {},
  };

  /**
   * Set smooth animation delay
   *
   * @param delay Smooth animation delay in ms
   */
  public static setSmoothAnimationDelay(delay: number): void {
    WallpaperAnimator.smoothAnimationParam.delay = delay;
  }

  /**
   * Set smooth animation duration
   *
   * @param delay Smooth animation duration in ms
   */
  public static setSmoothAnimationDuration(duration: number): void {
    WallpaperAnimator.smoothAnimationParam.duration = duration;
  }

  /**
   * Play spring animation
   *
   * @param callback Animated properties function calls
   * @param onFinish Callback to be executed after animation is played
   */
  public static submitFrictionAnimation(callback: () => void, onFinish?: () => void) {
    if (!onFinish) {
      WallpaperAnimator.frictionAnimationParam.onFinish = () => {};
    } else {
      WallpaperAnimator.frictionAnimationParam.onFinish = onFinish;
    }

    animateToImmediately(WallpaperAnimator.frictionAnimationParam, callback);
  }

  /**
   * Play smooth animation
   *
   * @param callback Animated properties function calls
   * @param onFinish Callback to be executed after animation is played
   */
  public static submitSmoothAnimation(callback: () => void, onFinish?: () => void) {
    if (!onFinish) {
      WallpaperAnimator.smoothAnimationParam.onFinish = () => {};
    } else {
      WallpaperAnimator.smoothAnimationParam.onFinish = onFinish;
    }

    animateToImmediately(WallpaperAnimator.smoothAnimationParam, callback);
  }

  /**
   * Using animateToImmediately interface to put prop change into effect immediately
   *
   * @param callback Properties function calls
   * @param onFinish Callback to be executed after it's been applied.
   */
  public static applyImmediately(callback: () => void, onFinish?: () => void) {
    let immediateParam: AnimateParam = {
      duration: 0,
      tempo: 0,
      iterations: 0,
      onFinish: () => {},
    };

    if (onFinish) {
      immediateParam.onFinish = onFinish;
    }

    animateToImmediately(immediateParam, callback);
  }
}