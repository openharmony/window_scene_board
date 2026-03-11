/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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
export class ThreeFingerSwipeConstants {
  public static readonly MAX_SWIPE_WIDTH = 1919; // touch pad width
  public static readonly MAX_SWIPE_HEIGHT = 1079; // touch pad height
  public static readonly REBOUND_DISTANCE = 60; // rebound distance
  public static readonly FOLLOW_UP_DISTANCE = 300; // follow up distance
  public static readonly CRITICAL_SPEED = 0.6; // critical speed
  public static readonly CRITICAL_ACC = 0.06;
  public static readonly CRITICAL_STOP_TIME = 80;
  public static readonly LAST_JUDGE_DISTANCE = 50;
  public static readonly MIN_JUDGE_DISTANCE = 15;
  public static readonly MIN_SPEED = 15;
  public static readonly MIN_DURATION = 207;
  public static readonly FACTOR_ONE = 7.05;
  public static readonly FACTOR_TWO = 5.72;
  public static readonly ZERO = 0;
  public static readonly ONE = 1;
  public static readonly TWO = 2;
  public static readonly THREE = 3;
  public static readonly EIGHT = 8;
  public static readonly TEN = 10;
  public static readonly ANIMATION_DELAY = 40;
  public static readonly ANIMATION_DURATION = 120;
  public static readonly DEFAULT_SPEED = 3;
  public static readonly QUADRATIC_TERM_FACTOR = -0.66;
  public static readonly ONE_TIME_FACTOR = 1.02;
  public static readonly CONSTANT_TERM_FACTOR = 440.5;
  public static readonly FOLD_MACHINE_CLEAR_ANIMATION_DELAY = 50;
  public static readonly FOLD_MACHINE_RESTORED_ANIMATION_DELAY = 10;
}