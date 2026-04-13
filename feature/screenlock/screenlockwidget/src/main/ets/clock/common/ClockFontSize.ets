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
import { clockLayoutHelper } from './ClockLayoutHelper';
import systemParameterEnhance from '@ohos.systemParameterEnhance';

// default 为默认时钟字体，pocketknives 为 VXX 外屏时钟字体
export enum FontSizeKey {
  DEFAULT = 'default',
  POCKETKNIVES = 'pocketknives'
}

export class FontSizeKeyHelper {
  /**
   * 时钟字体是否跟手 true不跟手 false跟手
   */
  private static keepClockSlideFontSize?: boolean;

  public static getFontSizeKey(): FontSizeKey {
    return FontSizeKey.DEFAULT;
  }

  /**
   * 获取时钟字体跟手配置
   */
  public static getIsKeepFontSize(): boolean {
    if (FontSizeKeyHelper.keepClockSlideFontSize === undefined) {
      let keepStr = systemParameterEnhance.getSync('const.screenLock.clock.font_size_keep', 'true');
      FontSizeKeyHelper.keepClockSlideFontSize = keepStr.trim() === 'true';
    }
    return FontSizeKeyHelper.keepClockSlideFontSize;
  }
}