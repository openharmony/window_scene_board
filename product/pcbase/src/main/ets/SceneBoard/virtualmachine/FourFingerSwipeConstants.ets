/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

export class FourFingerSwipeConstants {
  public static readonly MAX_SWIPE_WIDTH = 1919; // touch pad width
  public static readonly MAX_SWIPE_HEIGHT = 1079; // touch pad height
  public static readonly REBOUND_DISTANCE_DEFAULT = 200; // rebound distance default
  public static readonly REBOUND_DISTANCE_HOPPER_TOUCHPAD = 140; // rebound distance for Hopper TouchPad
  public static readonly CRITICAL_SPEED = -1.0; // critical speed
  public static readonly CRITICAL_ACC = 0.02;
  public static readonly MAX_SLIDE_DISTANCE = 2000;
  public static readonly MAX_PERCENT = 1;
  public static readonly MAX_SLIDE_SPEED = 1.5;
}