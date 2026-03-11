/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { LogDomain, LogHelper } from './LogHelper';

type AnyType = string | boolean | number | bigint | null | object | undefined;

/**
 * Basic log class
 */
export class Log {
  /**
   * Outputs info-level logs.
   *
   * @deprecated 应使用LogHelper打印并指定日志所属domain
   * @useinstead LogHelper#showInfo
   * @param tag Identifies the log tag.
   * @param format Indicates the log format string.
   * @param args Indicates the log parameters.
   */
  static showInfo(tag: string, format: string, ...args: AnyType[]): void {
    const log = LogHelper.getLogHelper(LogDomain.SCB, tag);
    log.showInfo(format, args);
  }

  /**
  * Outputs debug-level logs.
  *
  * @deprecated 应使用LogHelper打印并指定日志所属domain
  * @useinstead LogHelper#showDebug
  * @param tag Identifies the log tag.
  * @param format Indicates the log format string.
  * @param args Indicates the log parameters.
  */
  static showDebug(tag: string, format: string, ...args: AnyType[]): void {
    const log = LogHelper.getLogHelper(LogDomain.SCB, tag);
    log.showDebug(format, args);
  }

  /**
   * Outputs warning-level logs.
   *
   * @deprecated 应使用LogHelper打印并指定日志所属domain
   * @useinstead LogHelper#showWarn
   * @param tag Identifies the log tag.
   * @param format Indicates the log format string.
   * @param args Indicates the log parameters.
   */
  static showWarn(tag: string, format: string, ...args: AnyType[]): void {
    const log = LogHelper.getLogHelper(LogDomain.SCB, tag);
    log.showWarn(format, args);
  }

  /**
   * Outputs error-level logs.
   *
   * @deprecated 应使用LogHelper打印并指定日志所属domain
   * @useinstead LogHelper#showError
   * @param tag Identifies the log tag.
   * @param format Indicates the log format string.
   * @param args Indicates the log parameters.
   */
  static showError(tag: string, format: string, ...args: AnyType[]): void {
    const log = LogHelper.getLogHelper(LogDomain.SCB, tag);
    log.showError(format, args);
  }

  /**
   * Outputs fatal-level logs.
   *
   * @deprecated 应使用LogHelper打印并指定日志所属domain
   * @useinstead LogHelper#showFatal
   * @param tag Identifies the log tag.
   * @param format Indicates the log format string.
   * @param args Indicates the log parameters.
   */
  static showFatal(tag: string, format: string, ...args: AnyType[]): void {
    const log = LogHelper.getLogHelper(LogDomain.SCB, tag);
    log.showFatal(format, args);
  }

  /**
   * Outputs debug-level logs.
   *
   * @deprecated 应使用LogHelper打印并指定日志所属domain
   * @useinstead LogHelper#debug
   * @param tag Identifies the log tag.
   * @param logs Indicates the log content, support any value.
   */
  static debug(tag: string, ...logs: AnyType[]): void {
    const log = LogHelper.getLogHelper(LogDomain.SCB, tag);
    log.debug(...logs);
  }

  /**
   * Outputs info-level logs.
   *
   * @deprecated 应使用LogHelper打印并指定日志所属domain
   * @useinstead LogHelper#info
   * @param tag Identifies the log tag.
   * @param logs Indicates the log content, support any value.
   */
  public static info(tag: string, ...logs: AnyType[]): void {
    const log = LogHelper.getLogHelper(LogDomain.SCB, tag);
    log.info(...logs);
  }

  /**
   * Outputs warn-level logs.
   *
   * @deprecated 应使用LogHelper打印并指定日志所属domain
   * @useinstead LogHelper#warn
   * @param tag Identifies the log tag.
   * @param logs Indicates the log content, support any value.
   */
  public static warn(tag: string, ...logs: AnyType[]): void {
    const log = LogHelper.getLogHelper(LogDomain.SCB, tag);
    log.warn(...logs);
  }

  /**
   * Outputs error-level logs.
   *
   * @deprecated 应使用LogHelper打印并指定日志所属domain
   * @useinstead LogHelper#error
   * @param tag Identifies the log tag.
   * @param logs Indicates the log content, support any value.
   */
  public static error(tag: string, ...logs: AnyType[]): void {
    const log = LogHelper.getLogHelper(LogDomain.SCB, tag);
    log.error(...logs);
  }
}
