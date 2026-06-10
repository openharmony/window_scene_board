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
import curves from '@ohos.curves';

export default class AnimationConstants {
  public static INITIAL_RATIO = 0.7;
  public static LARGER_RATIO = 1.03;

  public static SHOW_ANIM_CONFIG: AnimateParam = {
    duration: 200,
    tempo: 1.0,
    curve: Curve.Friction,
    delay: 0,
    iterations: 1,
    playMode: PlayMode.Normal,
  };
  public static SHOW_ANIM_CONFIG_TWO: AnimateParam = {
    duration: 100,
    tempo: 1.0,
    curve: Curve.Friction,
    delay: 0,
    iterations: 1,
    playMode: PlayMode.Normal,
  };
  public static HIDE_ANIM_CONFIG: AnimateParam = {
    duration: 100,
    tempo: 1.0,
    curve: Curve.Friction,
    delay: 0,
    iterations: 1,
    playMode: PlayMode.Normal,
  };
  public static SHOW_STATUS_BAR_ANIM_CONFIG: AnimateParam = {
    delay: 100,
    duration: 200,
    tempo: 1.0,
    curve: Curve.Friction,
    iterations: 1,
    playMode: PlayMode.Normal
  };
  public static HIDE_STATUS_BAR_ANIM_CONFIG: AnimateParam = {
    delay: 0,
    duration: 200,
    tempo: 1.0,
    curve: Curve.Linear,
    iterations: 1,
    playMode: PlayMode.Normal
  };

  // system keyboard animation params
  public static KEYBOARD_OPACITY_ANIM_CONFIG: AnimateParam = {
    curve: Curve.Sharp,
    iterations: 1,
    duration: 100
  };
  public static SHOW_TOUCHPAD_KEYBOARD_ANIM_CONFIG: AnimateParam = {
    curve: Curve.LinearOutSlowIn,
    iterations: 1,
    duration: 500
  };
  public static FIXED_KEYBOARD_ANIM_CONFIG: AnimateParam = {
    curve: Curve.FastOutSlowIn,
    iterations: 1,
    duration: 500
  };
  public static SHOW_FIXED_KEYBOARD_OPACITY_ANIM_CONFIG: AnimateParam = {
    curve: Curve.Sharp,
    iterations: 1,
    duration: 150
  };
  public static HIDE_FIXED_KEYBOARD_OPACITY_ANIM_CONFIG: AnimateParam = {
    delay: 200,
    curve: Curve.Sharp,
    iterations: 1,
    duration: 150
  };

  /**
   * the default input window enter animation, '0': the default initialVelocity,'1':the default mass,
   * '342' : the default stiffness, '37':the default damping
   */

  public static SHOW_INPUT_WINDOW_CURVE: ICurve = curves.interpolatingSpring(0, 1, 342, 37);
  /**
   * the default input window exit animation, '4': the default initialVelocity,'1':the default mass,
   * '342' : the default stiffness, '37':the default damping
   */
  public static HIDE_INPUT_WINDOW_CURVE: ICurve = curves.interpolatingSpring(4, 1, 342, 30);
  /**
   * the default floating system keyboard window animation, '0': the default initialVelocity,'1':the default mass,
   * '350' : the default stiffness, '28':the default damping
   */
  public static FLOATING_SYSTEM_KEYBOARD_CURVE: ICurve = curves.interpolatingSpring(0, 1, 350, 28);
}
