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
import { AnyType } from '../utils/Types';

export class TsLog {
  private static readonly TS_DOMAIN: number = 0x00ff;

  private static _sLogPrefix: string = `[ThemeService] `;

  public static isDebug(tag: string): boolean {
    return hilog.isLoggable(TsLog.TS_DOMAIN, tag, hilog.LogLevel.DEBUG);
  }

  public static logPrefix(...value: string[]): void {
    TsLog._sLogPrefix = `[ThemeService-${value.join('-')}] `;
  }

  public static debug(tag: string, message: string, ...args: AnyType[]): void {
    hilog.debug(TsLog.TS_DOMAIN, tag, TsLog._sLogPrefix + message, args);
  }

  public static info(tag: string, message: string, ...args: AnyType[]): void {
    hilog.info(TsLog.TS_DOMAIN, tag, TsLog._sLogPrefix + message, args);
  }

  public static warning(tag: string, message: string, ...args: AnyType[]): void {
    hilog.warn(TsLog.TS_DOMAIN, tag, TsLog._sLogPrefix + message, args);
  }

  public static error(tag: string, message: string): void;

  public static error(tag: string, message: string, error: Error): void;

  public static error(tag: string, message: string, error?: Error): void {
    if (error) {
      const codeProperty: string = 'code';
      let code: string = Reflect.get(error, codeProperty);
      if (TsLog.isDebug(tag)) {
        if (code) {
          message = message.concat(` code:${code}, message:${error.stack ? error.stack : error.message}`);
        } else {
          message = message.concat(` message:${error.stack ? error.stack : error.message}`);
        }
      } else {
        if (code) {
          message = message.concat(` code:${code}, message:${error.message}`);
        } else {
          message = message.concat(` message:${error.message}`);
        }
      }
    }
    hilog.error(TsLog.TS_DOMAIN, tag, TsLog._sLogPrefix + message);
  }
}