/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import InputMethodSubtype from '@ohos.InputMethodSubtype';

export class LanguageCompareUtils {
  private swapCompare: SwapCompare = new SwapCompare();
  private normalCompare: NormalCompare = new NormalCompare();
  public getSwapCompare(): LanguageCompare {
    return this.swapCompare;
  }
  public getNormalCompare(): LanguageCompare {
    return this.normalCompare;
  }
}

export abstract class LanguageCompare {
  public abstract isInputMethodSubtypeInfoEqual(leftSubtype: InputMethodSubtype, rightSubtype: InputMethodSubtype);
}

// 用于判断多个语言项互换，只有一个会显示的情况
export class SwapCompare extends LanguageCompare {
  public isInputMethodSubtypeInfoEqual(leftSubtype: InputMethodSubtype, rightSubtype: InputMethodSubtype): boolean {
    return leftSubtype?.language === rightSubtype?.language;
  }
}

// 用于判断通常语言场景
export class NormalCompare extends LanguageCompare {
  public isInputMethodSubtypeInfoEqual(leftSubtype: InputMethodSubtype, rightSubtype: InputMethodSubtype): boolean {
    return leftSubtype?.language === rightSubtype?.language && leftSubtype?.mode === rightSubtype?.mode;
  }
}