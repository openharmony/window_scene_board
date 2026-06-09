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
export class ThreeFingerSwipeConstants {
  public static readonly MAX_SWIPE_WIDTH = 1919; // touch pad width
  public static readonly MAX_SWIPE_HEIGHT = 1079; // touch pad height
  public static readonly REBOUND_DISTANCE = 100; // rebound distance
  public static readonly FOLLOW_UP_DISTANCE = 300; // follow up distance
  public static readonly CRITICAL_SPEED = -1.0; // critical speed
  public static readonly CRITICAL_ACC = 0.02;
  public static readonly MAX_SLIDE_DISTANCE = 1000;
  public static readonly MAX_PERCENT = 1.05;
  public static readonly MAX_SLIDE_SPEED = 1.5;
  public static readonly MIN_SCALE = 0.25;
  public static readonly DISTANCE_Y = 35;
  public static readonly PIXEL_PER_INCH = 400;
  public static readonly MM_TO_INCH = 25.4;
  public static readonly MIN_SPEED = 20;
  public static readonly MIN_DURATION = 183.3;
  public static readonly SPEED_FACTOR = 0.5;
  public static readonly DEFAULT_SPEED = 3;
  public static readonly QUADRATIC_TERM_FACTOR = -0.66;
  public static readonly ONE_TIME_FACTOR = 1.02;
  public static readonly CONSTANT_TERM_FACTOR = 440.5;
  public static readonly HOT_AREA_WIDTH_PCT: number = 0.5;
  public static readonly HOT_AREA_HEIGHT_PCT: number = 0.55;
  public static readonly DEFAULT_2: number = 2;
  public static readonly ANGLE_15: number = 15;
  public static readonly ANGLE_75: number = 75;
  public static readonly ANGLE_105: number = 105;
  public static readonly ANGLE_165: number = 165;
  public static readonly ANGLE_180: number = 180;
}

export enum ThreeFingerSwipeDirection {
  NONE = -1,
  UP = 0,
  DOWN = 1,
  LEFT = 2,
  RIGHT = 3,
  LEFT_UP = 4,
  RIGHT_UP = 5
}

export enum ThreeFingerSwipeType {
  BEGIN = 'BEGIN',
  UPDATE = 'UPDATE',
  END = 'END',
  CANCEL = 'CANCEL'
}