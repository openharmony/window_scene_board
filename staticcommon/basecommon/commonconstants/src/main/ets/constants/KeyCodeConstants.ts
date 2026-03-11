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

export default class KeyCodeConstants {
  /* file operation keycode on desktop */
  static readonly KEYCODE_HOME: number = 1;
  static readonly KEYCODE_BACK: number = 2;
  static readonly KEYCODE_RECENT: number = 10011;
  static readonly KEYCODE_BACK_FLOAT: number = 10012;
  static readonly KEYCODE_ENTER: number = 2054;
  static readonly KEYCODE_CTRL: number = 2072;
  static readonly KEYCODE_CTRL_RIGHT: number = 2073;
  static readonly KEYCODE_SHIFT_LEFT: number = 2047;
  static readonly KEYCODE_SHIFT_RIGHT: number = 2048;
  static readonly KEYCODE_DELETE: number = 2071;
  static readonly KEYCODE_A: number = 2017;
  static readonly KEYCODE_C: number = 2019;
  static readonly KEYCODE_V: number = 2038;
  static readonly KEYCODE_X: number = 2040;
  static readonly KEYCODE_F2: number = 2091;


  static readonly KEYCODE_WIN: number = 2076;
  static readonly KEYCODE_D: number = 2020;
  static readonly KEYCODE_DPAD_UP: number = 2012;
  static readonly KEYCODE_TAB: number = 2049;
  static readonly KEYCODE_FUNCTION: number = 2078;
  static readonly KEYCODE_DPAD_DOWN: number = 2013;
  static readonly KEYCODE_DPAD_LEFT: number = 2014;
  static readonly KEYCODE_DPAD_RIGHT: number = 2015;
  static readonly KEYCODE_Z: number = 2042;
  static readonly KEYCODE_Y: number = 2041;
  static readonly KEYCODE_U: number = 2037;
  static readonly KEYCODE_R: number = 2034;
  static readonly KEYCODE_N: number = 2030;
  static readonly KEYCODE_ESCAPE: number = 2070;
  static readonly KEYCODE_FN_0: number = 2720;
}

export enum KeyState {
  DOWN = 0,
  UP = 1
}