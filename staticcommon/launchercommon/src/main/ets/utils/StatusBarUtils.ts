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

/**
 * 状态栏类型
 *
 */
export class StatusBarUtils {
  /**
   * 主类型，mac风格状态栏
   */
  static readonly TYPE_MAIN_MAC_STATUS_BAR: number = 0x0080;

  /**
   * 主类型，window类型状态栏
   */
  static readonly TYPE_MAIN_WINDOW_STATUS_BAR: number = 0x0800;


  /**
   * 是否为mac风格状态栏
   *
   * @param statusBarType 状态栏类型
   * @return true PC状态栏
   */

  static isMacStyle(statusBarType: number): boolean {
    return (statusBarType & StatusBarUtils.TYPE_MAIN_MAC_STATUS_BAR) !== 0;
  }

  /**
   * 是否为window风格状态栏
   *
   * @param statusBarType 状态栏类型
   * @return true PC状态栏
   */
  static isWindowStyle(statusBarType: number): boolean {
    return (statusBarType & StatusBarUtils.TYPE_MAIN_WINDOW_STATUS_BAR) !== 0;
  }

}