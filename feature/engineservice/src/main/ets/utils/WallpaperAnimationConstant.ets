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

import lazy curves from '@ohos.curves';

const SPRING_VELOCITY: number = 10;
const SPRING_MASS: number = 1;
const SPRING_STIFFNESS: number = 228;
const SPRING_DAMPING: number = 30;
const SMOOTH_CURVE_BEZIER_X: number = 0.4;
const SMOOTH_CURVE_BEZIER_Y: number = 1;

/**
 * Storing and managing basic animation params used for wallpaper
 *
 * @since 2024-04-29
 */
export class WallpaperAnimationConstant {
  // AOD dimming factor param for 4 Scb States - SLEEP LOCK HOME AOD
  // Same param order applies to the reset of param groups
  public static AOD_DIM_FACTOR: number[] = [1, 1, 1, 0.35];

  // Lock opacity configurations
  public static readonly LOCK_OPACITY: number[] = [1, 1, 0, 1];

  // Light up factor configurations
  public static LIGHT_UP_FACTOR: number[] = [0, 1, 1, 1];

  // Blur radius configurations
  public static BLUR_RADIUS: number[] = [50, 0, 0, 0];

  // Available animation param list
  public static readonly ANIMATION_PARAMETER_LIST: number[][] = [
    this.BLUR_RADIUS,
    this.LIGHT_UP_FACTOR,
    this.AOD_DIM_FACTOR,
    this.LOCK_OPACITY,
  ];

  // Default alpha animation delay in ms
  public static readonly ALPHA_DELAY_DEFAULT: number = 150;

  // Alpha animation without delay
  public static readonly ALPHA_NO_DELAY: number = 0;

  // Alpha animation duration in ms
  public static readonly ALPHA_DURATION: number = 150;

  // Alpha animation duration 0
  public static readonly ALPHA_NO_DURATION: number = 0;

  // Spring curve definition
  public static readonly SPRING_CURVE: ICurve =
    curves.interpolatingSpring(SPRING_VELOCITY, SPRING_MASS, SPRING_STIFFNESS, SPRING_DAMPING);

  // Smooth curve definition
  public static readonly SMOOTH_CURVE: ICurve =
    curves.cubicBezierCurve(SMOOTH_CURVE_BEZIER_X, 0, SMOOTH_CURVE_BEZIER_X, SMOOTH_CURVE_BEZIER_Y);

  // Smooth animation identifier
  public static readonly ID_ANIMATION_SMOOTH: string = 'smooth';

  // Spring animation identifier
  public static readonly ID_ANIMATION_SPRING: string = 'spring';

  // Quick apply via animation
  public static readonly ID_ANIMATION_QUICK_APPLY: string = 'quickApply';

  // Friction animation duration
  public static readonly FRICTION_ANIMATION_DURATION: number = 400;
}