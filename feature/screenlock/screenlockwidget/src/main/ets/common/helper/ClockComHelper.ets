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

import { ClockLayout } from '../WidgetParam';

/**
 * 时钟通用辅助工具
 */
export class ClockComHelper {
  /**
   * 数字时钟样式判断
   *
   * @param clockLayout 时钟样式
   * @returns true 数字时钟样式
   */
  public static isComLayout(clockLayout?: ClockLayout): boolean {
    if (!clockLayout) {
      return false;
    }
    return clockLayout >= ClockLayout.DIMENSION_4_4 && clockLayout < 200;
  }

  /**
   * 数字时钟UD样式判断
   *
   * @param clockLayout 时钟样式
   * @returns true 数字时钟UD样式
   */
  public static isComUDLayout(clockLayout?: ClockLayout): boolean {
    if (!clockLayout) {
      return false;
    }
    return clockLayout > ClockLayout.CLOCK_LAYOUT_UD_FLAG && clockLayout < 200;
  }

  /**
   * 数字时钟翻转样式判断
   *
   * @param clockLayout 时钟样式
   * @returns true 数字时钟翻转样式
   */
  public static isComReverseLayout(clockLayout?: ClockLayout): boolean {
    if (!clockLayout) {
      return false;
    }
    return clockLayout === ClockLayout.DEFAULT_CLOCK_REVERSE_LAYOUT ||
      clockLayout === ClockLayout.NORMAL_CLOCK_REVERSE_LAYOUT ||
      clockLayout === ClockLayout.MOUNTAIN_CLOCK_REVERSE_LAYOUT ||
      clockLayout === ClockLayout.MOUNTAIN_CLOCK_REVERSE_LAYOUT_SEPERATOR;
  }
}