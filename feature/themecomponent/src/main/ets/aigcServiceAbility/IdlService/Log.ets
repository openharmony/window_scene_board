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

import hilog from '@ohos.hilog';

export const SYMBOL: string = ' --> ';

export const TS_DOMAIN_NAME: string = 'WALLPAPER_EDIT';

// 基本类型
type PrimitiveType = string | boolean | number | bigint | null | undefined;

// 非基本类型
type NonPrimitiveType = object;

// 任意类型
type AnyType = PrimitiveType | NonPrimitiveType;

export enum LogDomain {
  WALLPAPER_EDIT = 0x04500, // WallpaperEdit
}
;

export class Log {
  public static debug(tag: string, message: string, ...args: AnyType[]): void {
    hilog.debug(LogDomain.WALLPAPER_EDIT, TS_DOMAIN_NAME, tag + SYMBOL + message, args);
  }

  public static info(tag: string, message: string, ...args: AnyType[]): void {
    hilog.info(LogDomain.WALLPAPER_EDIT, TS_DOMAIN_NAME, tag + SYMBOL + message, args);
  }

  public static warn(tag: string, message: string, ...args: AnyType[]): void {
    hilog.warn(LogDomain.WALLPAPER_EDIT, TS_DOMAIN_NAME, tag + SYMBOL + message, args);
  }

  public static error(tag: string, message: string, ...args: AnyType[]): void {
    hilog.error(LogDomain.WALLPAPER_EDIT, TS_DOMAIN_NAME, tag + SYMBOL + message, args);
  }

  // log in @Builder functions
  public static printBuilderLog(msg: string): boolean {
    hilog.info(LogDomain.WALLPAPER_EDIT, TS_DOMAIN_NAME, msg);
    return true;
  }
}