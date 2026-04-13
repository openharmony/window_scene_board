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
export const TS_DOMAIN_NAME: string = 'DESKTOP_PREVIEW';

// 基本类型
type PrimitiveType = string | boolean | number | bigint | null | undefined;

// 非基本类型
type NonPrimitiveType = object;

// 任意类型
type AnyType = PrimitiveType | NonPrimitiveType;

enum LogDomain {
  DESKTOP_PREVIEW = 0x04500, // DESKTOP_PREVIEW
};

export class Log {
  public static showDebug(tag: string, message: string, ...args: AnyType[]): void {
    hilog.debug(LogDomain.DESKTOP_PREVIEW, TS_DOMAIN_NAME, tag + SYMBOL + message, args);
  }

  public static showInfo(tag: string, message: string, ...args: AnyType[]): void {
    hilog.info(LogDomain.DESKTOP_PREVIEW, TS_DOMAIN_NAME, tag + SYMBOL + message, args);
  }

  public static showWarn(tag: string, message: string, ...args: AnyType[]): void {
    hilog.warn(LogDomain.DESKTOP_PREVIEW, TS_DOMAIN_NAME, tag + SYMBOL + message, args);
  }

  public static showError(tag: string, message: string, ...args: AnyType[]): void {
    hilog.error(LogDomain.DESKTOP_PREVIEW, TS_DOMAIN_NAME, tag + SYMBOL + message, args);
  }
}