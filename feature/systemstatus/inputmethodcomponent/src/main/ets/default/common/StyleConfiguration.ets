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

import { CommonStyleManager } from '@ohos/systemuicommon';

const TAG = 'inputMethod-StyleConfiguration';

export class StartsBarInputMethodComponentStyle {
  public statusBarInputMethodWidth: Length = $r('app.float.status_bar_input_method_width');
  public statusBarInputMethodHeight: Length = $r('app.float.status_bar_input_method_height');
  public hadStatusBarInputMethodWidth: Length = $r('app.float.had_status_bar_input_method_width');
  public hadStatusBarInputMethodHeight: Length = $r('app.float.had_status_bar_input_method_height');
}

export default class StyleConfiguration {
  static getStartsBarInputMethodComponentStyle(): StartsBarInputMethodComponentStyle {
    const key: string = TAG + '-startsBarInputMethod';
    return CommonStyleManager.getStyle(key, StartsBarInputMethodComponentStyle);
  }
}