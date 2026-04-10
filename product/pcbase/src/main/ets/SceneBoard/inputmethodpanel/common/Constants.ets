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

import inputMethod from '@ohos.inputMethod';
import InputMethodSubtype from '@ohos.InputMethodSubtype';

export default class Constants {
  static readonly WINDOW_WIDTH: number = 360;
  static readonly REQUEST_FOCUS_MENU = 'request_focus_input_method';
  static readonly DARK_COLOR_FILTER = [0, 0, 0, 0, 255, 0, 0, 0, 0, 255, 0, 0, 0, 0, 255, 0, 0, 0, 1, 0];
  static readonly LIGHT_COLOR_FILTER = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0];
}

export enum SwitchType {
  SWITCH_INPUT_METHOD = 0,
  SWITCH_LANGUAGE = 1
}

export enum ReportType {
  REPORT_RESTART = 0,
  REPORT_SWITCH_INPUT_METHOD,
  REPORT_SWITCH_LANGUAGE
}

export interface InputMethodInfo {
  /**
   * 用于联合类型区分具体类型
   */
  vType: 'InputMethodInfo';
  property: inputMethod.InputMethodProperty;
}

export interface InputMethodSubtypeInfo {
  /**
   * 用于联合类型区分具体类型
   */
  vType: 'InputMethodSubtypeInfo';
  subtype: InputMethodSubtype;
}

export interface InputMethodSubtypeGroup {
  /**
   * 用于记录输入法分组
   */
  languageLocale: string;
  subtypeList: Array<InputMethodSubtypeInfo>;
}

export type InputMethodItemType = InputMethodInfo | InputMethodSubtypeInfo;

export interface StateChangeListener { onStateChange: Function }

export interface InputMethodUpdateListener { updateInputMethodInfo: Function }

export interface InputMethodItemChangeListener { updateInputMethodPanelWindow: Function }