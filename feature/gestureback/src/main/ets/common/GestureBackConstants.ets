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

/**
 * GestureBack参数
 */
export class GestureBackConstants {
  public static readonly ARROW_MOVE_QUICK_MAX_DISTANCE = 42.5 / 5; // metaBall Arrow moves quickly to maximum distance
  public static readonly BACK_DISTANCE_THRESHOLD = 15; // Distance threshold for back gesture recognition, px
  public static readonly BACK_ANGLE_THRESHOLD = 75; // Angle threshold for back gesture recognition, °
  public static readonly BACK_TIME_THRESHOLD = 120; // Time threshold for back gesture recognition, ms
  public static readonly BACK_WIDTH = 16; // Back gesture width, vp
  public static readonly BACK_METABALL_FOLLOWING_DAMP_Y = 4; // Metaball following damp y, vp
  public static readonly BACK_METABALL_FOLLOWING_DAMP_X = 8; // Metaball following damp x, vp
  public static readonly BACK_METABALL_BEZIER_THRESHOLD = 180; // Metaball following damp x, vp
  // Distance threshold for cancel back gesture,vp
  public static readonly CANCEL_BACK_DISTANCE_THRESHOLD = this.BACK_WIDTH * 2;
  public static readonly CANCEL_BACK_DISTANCE_THRESHOLD_120 = 64;
  public static readonly CANCEL_BACK_TIME_THRESHOLD = 150; // Time threshold for cancel back gesture, ms
  public static readonly NS_TO_MS = 1000000; // 1ms = 1000000ns
  public static readonly GESTURE_NAVIGATION_BACK_QUICK_CHANGE_MAX_DISTANCE = 100;
  public static readonly GESTURE_NAVIGATION_BACK_SLOW_CHANGE_MAX_DISTANCE = 260;
  public static readonly DARK_COLOR_MODE = 0;
}