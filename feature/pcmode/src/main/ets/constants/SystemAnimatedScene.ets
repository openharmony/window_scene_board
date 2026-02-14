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
export class SystemAnimatedScene {
  public static readonly ENTER_MISSION_CENTER = 0;
  public static readonly EXIT_MISSION_CENTER = 1;
  public static readonly EXIT_TFU_WINDOW = 3;
  public static readonly ENTER_WINDOW_FULL_SCREEN = 4;
  public static readonly EXIT_WINDOW_FULL_SCREEN = 5;
  public static readonly ENTER_MAX_WINDOW = 6;
  public static readonly EXIT_MAX_WINDOW = 7;
  public static readonly ENTER_SPLIT_WINDOW = 8;
  public static readonly EXIT_SPLIT_WINDOW = 9;
  public static readonly ENTER_APP_CENTER = 10;
  public static readonly EXIT_APP_CENTER = 11;
  public static readonly APPEAR_MISSION_CENTER = 12;
  public static readonly ENTER_WIND_CLEAR = 13;
  public static readonly ENTER_WIND_RECOVER = 14;
  // 以下ENTER_RECENTS,EXIT_RECENTS为手机使用场景，pc不使用
  public static readonly ENTER_RECENTS = 15;
  public static readonly EXIT_RECENTS = 16;
  public static readonly LOCKSCREEN_TO_LAUNCHER = 17;
  public static readonly ENTER_MIN_WINDOW = 18;
  public static readonly RECOVER_MIN_WINDOW = 19;
  public static readonly OTHERS = 20;
}