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

import type inputConsumer from '@ohos.multimodalInput.inputConsumer';
import KeyCodeConstants from '@ohos/multiinput/src/main/ets/default/common/constants/KeyCodeConstants';


export class ShortcutKeyConstants {
  // ESC UP
  public static readonly ESC_UP_OPTION: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCodeConstants.KEYCODE_ESC,
    isFinalKeyDown: false,
    finalKeyDownDuration: 0
  };

  // UP UP
  public static readonly UP_OPTION: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCodeConstants.KEYCODE_DPAD_UP,
    isFinalKeyDown: false,
    finalKeyDownDuration: 0
  };

  // DOWN UP
  public static readonly DOWN_OPTION: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCodeConstants.KEYCODE_DPAD_DOWN,
    isFinalKeyDown: false,
    finalKeyDownDuration: 0
  };

  // LEFT UP
  public static readonly LEFT_OPTION: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCodeConstants.KEYCODE_DPAD_LEFT,
    isFinalKeyDown: false,
    finalKeyDownDuration: 0
  };

  // RIGHT UP
  public static readonly RIGHT_OPTION: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCodeConstants.KEYCODE_DPAD_RIGHT,
    isFinalKeyDown: false,
    finalKeyDownDuration: 0
  };

  // ALT_LEFT + UP DOWN
  public static readonly ALT_LEFT_UP_OPTION: inputConsumer.KeyOptions = {
    preKeys: [KeyCodeConstants.KEYCODE_ALT_LEFT],
    finalKey: KeyCodeConstants.KEYCODE_DPAD_UP,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  // ALT_LEFT + DOWN DOWN
  public static readonly ALT_LEFT_DOWN_OPTION: inputConsumer.KeyOptions = {
    preKeys: [KeyCodeConstants.KEYCODE_ALT_LEFT],
    finalKey: KeyCodeConstants.KEYCODE_DPAD_DOWN,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  // ALT_LEFT + LEFT DOWN
  public static readonly ALT_LEFT_LEFT_OPTION: inputConsumer.KeyOptions = {
    preKeys: [KeyCodeConstants.KEYCODE_ALT_LEFT],
    finalKey: KeyCodeConstants.KEYCODE_DPAD_LEFT,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  // ALT_LEFT + RIGHT DOWN
  public static readonly ALT_LEFT_RIGHT_OPTION: inputConsumer.KeyOptions = {
    preKeys: [KeyCodeConstants.KEYCODE_ALT_LEFT],
    finalKey: KeyCodeConstants.KEYCODE_DPAD_RIGHT,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  // ALT_RIGHT + UP DOWN
  public static readonly ALT_RIGHT_UP_OPTION: inputConsumer.KeyOptions = {
    preKeys: [KeyCodeConstants.KEYCODE_ALT_RIGHT],
    finalKey: KeyCodeConstants.KEYCODE_DPAD_UP,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  // ALT_RIGHT + DOWN DOWN
  public static readonly ALT_RIGHT_DOWN_OPTION: inputConsumer.KeyOptions = {
    preKeys: [KeyCodeConstants.KEYCODE_ALT_RIGHT],
    finalKey: KeyCodeConstants.KEYCODE_DPAD_DOWN,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  // ALT_RIGHT + LEFT DOWN
  public static readonly ALT_RIGHT_LEFT_OPTION: inputConsumer.KeyOptions = {
    preKeys: [KeyCodeConstants.KEYCODE_ALT_RIGHT],
    finalKey: KeyCodeConstants.KEYCODE_DPAD_LEFT,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  // ALT_RIGHT + RIGHT DOWN
  public static readonly ALT_RIGHT_RIGHT_OPTION: inputConsumer.KeyOptions = {
    preKeys: [KeyCodeConstants.KEYCODE_ALT_RIGHT],
    finalKey: KeyCodeConstants.KEYCODE_DPAD_RIGHT,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  // ENTER UP
  public static readonly ENTER_OPTION: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCodeConstants.KEYCODE_ENTER,
    isFinalKeyDown: false,
    finalKeyDownDuration: 0
  };

  // SPACE UP
  public static readonly SPACE_OPTION: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCodeConstants.KEYCODE_SPACE,
    isFinalKeyDown: false,
    finalKeyDownDuration: 0
  };

  // TAB UP
  public static readonly TAB_OPTION: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCodeConstants.KEYCODE_TAB,
    isFinalKeyDown: false,
    finalKeyDownDuration: 0
  };
}