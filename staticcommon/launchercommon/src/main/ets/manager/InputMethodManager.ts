/**
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

import inputMethod from '@ohos.inputMethod';

/**
 * Wrapper class for inputMethod interfaces.
 */
export class InputMethodManager {
  private static mInstance: InputMethodManager;

  static getInstance(): InputMethodManager {
    if (!InputMethodManager.mInstance) {
      InputMethodManager.mInstance = new InputMethodManager();
    }
    return InputMethodManager.mInstance;
  }

  stopInput(): void {
    inputMethod.getInputMethodController()?.stopInput();
  }

  stopInputSession(): void {
    inputMethod.getInputMethodController()?.hideSoftKeyboard();
  }
}