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

import { DeviceHelper } from '@ohos/frameworkwrapper';

export default class Constants {
  // 小外屏定制参数，后续重构掉
  public static readonly OUTER_SCREEN_LETTER_TEXT_LINE_HEIGHT: string = '8vp';
  public static readonly OUTER_SCREEN_LOCK_ICON_FONT_SIZE: string = '10vp';
  public static readonly OUTER_SCREEN_UNLOCK_ICON_FONT_SIZE: string = '12vp';
  public static readonly OUTER_SCREEN_NUM_BUTTON_OFFEST: number = 0;
  public static readonly OUTER_SCREEN_NUM_BUTTON_OFFEST_SPECIALKEY: number = -2;
  public static readonly OUTER_SCREEN_NUM_BUTTON_LETTER_OFFEST: number = 29;
  public static readonly OUTER_SCREEN_PLUS_SING_OFFEST: number = 31;

  public static readonly SCREENLOCK_LETTER_TEXT_LINE_HEIGHT: number = 16;
  public static readonly SCREENLOCK_LOCK_ICON_FONT_SIZE: number = 14;
  public static readonly SCREENLOCK_UNLOCK_ICON_FONT_SIZE: number = 16;
  public static readonly SCREENLOCK_NUM_BUTTON_OFFEST: number = -3.3;
  public static readonly SCREENLOCK_NUM_BUTTON_OFFEST_SPECIALKEY: number = -2.5;
  public static readonly SCREENLOCK_NUM_BUTTON_LETTER_OFFEST: number = 38.3;
  public static readonly SCREENLOCK_PLUS_SING_OFFEST: number = 40.8;

  // PAD定制参数后续重构掉
  public static readonly SCREENLOCK_LOCK_ICON_HEIGHT: number = 44;
  public static readonly SCREENLOCK_LOCK_ICON_HEIGHT_PAD: number = 44;
  public static readonly SCREENLOCK_LOCK_ICON_MARGIN_TOP: number = 55;
  public static readonly SCREENLOCK_LOCK_ICON_MARGIN_TOP_PAD: number = 55;
  public static readonly SCREENLOCK_CLOCK_TOP = DeviceHelper.isPhone() ?
    this.SCREENLOCK_LOCK_ICON_HEIGHT + this.SCREENLOCK_LOCK_ICON_MARGIN_TOP :
    this.SCREENLOCK_LOCK_ICON_HEIGHT_PAD + this.SCREENLOCK_LOCK_ICON_MARGIN_TOP_PAD;

  // 艺术签名非中文文本支持的最大字符长度
  public static readonly SIGN_TEXT_LEN_LIMIT: number = 200;

  // 艺术签名中文文本支持的最大字符长度
  public static readonly SIGN_CHINESE_TEXT_LEN_LIMIT: number = 6;

  // 艺术签名中文正则表达式
  public static readonly INPUT_FILTER_CHINESE_REG_EXP = '\\u4e00-\\u9fff\\u3400-\\u4dbf';

  public static readonly CLOCK_DEFAULT_FOREGROUND_COLOR: string = '#FFFFFF';
}