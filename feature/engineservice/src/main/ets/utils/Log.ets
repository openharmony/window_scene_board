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

import lazy hilog from '@ohos.hilog';

const DOMAIN: number = 0x00ff;
const TAG = 'ThemeEngine';
const SYMBOL = ' --> ';

/**
 * Basic log class
 */
export class Log {
  private static isLoggableMap: Map<number, boolean> = new Map();

  /**
   * Querying Whether Logs Support Debugging
   * @param tag Identifies the log tag.
   * @returns true:debug enable, false: debug disable
   */
  public static isDebugEnable(tag: string) {
    let isLoggable: boolean | undefined = Log.isLoggableMap.get(hilog.LogLevel.DEBUG);
    if (isLoggable === undefined) {
      isLoggable = Log.getIsLoggable(tag, hilog.LogLevel.DEBUG);
    }
    return isLoggable;
  }

  /**
   * Outputs debug-level logs.
   *
   * @param tag Identifies the log tag.
   * @param logs Indicates the log content, support any value.
   */
  public static debug(tag: string, ...logs: LogsType[]): void {
    if (Log.isDebugEnable(tag)) {
      hilog.debug(DOMAIN, TAG, Log.formatLogs(tag, logs));
    }
  }

  /**
   * Outputs info-level logs.
   *
   * @param tag Identifies the log tag.
   * @param logs Indicates the log content, support any value.
   */
  public static info(tag: string, ...logs: LogsType[]): void {
    let isLoggable: boolean | undefined = Log.isLoggableMap.get(hilog.LogLevel.INFO);
    if (isLoggable === undefined) {
      isLoggable = Log.getIsLoggable(tag, hilog.LogLevel.INFO);
    }
    if (isLoggable) {
      hilog.info(DOMAIN, TAG, Log.formatLogs(tag, logs));
    }
  }

  /**
   * Outputs warn-level logs.
   *
   * @param tag Identifies the log tag.
   * @param logs Indicates the log content, support any value.
   */
  public static warn(tag: string, ...logs: LogsType[]): void {
    let isLoggable: boolean | undefined = Log.isLoggableMap.get(hilog.LogLevel.WARN);
    if (isLoggable === undefined) {
      isLoggable = Log.getIsLoggable(tag, hilog.LogLevel.WARN);
    }
    if (isLoggable) {
      hilog.warn(DOMAIN, TAG, Log.formatLogs(tag, logs));
    }
  }

  /**
   * Outputs error-level logs.
   *
   * @param tag Identifies the log tag.
   * @param logs Indicates the log content, support any value.
   */
  public static error(tag: string, ...logs: LogsType[]): void {
    let isLoggable: boolean | undefined = Log.isLoggableMap.get(hilog.LogLevel.ERROR);
    if (isLoggable === undefined) {
      isLoggable = Log.getIsLoggable(tag, hilog.LogLevel.ERROR);
    }
    if (isLoggable) {
      hilog.error(DOMAIN, TAG, Log.formatLogs(tag, logs));
    }
  }

  /**
   * Outputs fatal-level logs.
   *
   * @param tag Identifies the log tag.
   * @param logs Indicates the log content, support any value.
   */
  public static fatal(tag: string, ...logs: LogsType[]): void {
    let isLoggable: boolean | undefined = Log.isLoggableMap.get(hilog.LogLevel.FATAL);
    if (isLoggable === undefined) {
      isLoggable = Log.getIsLoggable(tag, hilog.LogLevel.FATAL);
    }
    if (isLoggable) {
      hilog.fatal(DOMAIN, TAG, Log.formatLogs(tag, logs));
    }
  }

  /**
   * Checks whether logs of the specified tag, and level can be printed.
   *
   * @param tag Identifies the log tag.
   * @param level log level
   * @since 7
   */
  private static getIsLoggable(tag: string, level: hilog.LogLevel): boolean {
    const isLoggable: boolean = hilog.isLoggable(DOMAIN, tag, level);
    Log.isLoggableMap.set(level, isLoggable);
    return isLoggable;
  }

  /**
   * Format log content
   *
   * @param logs The array of logs needs to format
   * @returns logs after format
   */
  private static format(tag: string, logs: LogsType[]): string {
    const message: string = logs.map((log: LogsType) => {
      return Log.handleSpecialLogs(tag, log);
    }).join(' ');

    return message;
  }

  /**
   * Handle special logs format
   *
   * @param log
   * @returns logs after format
   */
  private static handleSpecialLogs(tag: string, log: LogsType): string {
    try {
      if (typeof log === 'string') {
        return log;
      }

      if (typeof log === 'number') {
        return `${log}`;
      }
      if (log instanceof Error) {
        if (Log.isDebugEnable(tag) && log.stack) {
          return log.stack;
        }
        return log.message;
      }
      return JSON.stringify(log);
    } catch (e) {
      hilog.error(DOMAIN, TAG, `handle special logs failed: ${e?.code};${e?.message}}`);
      return '';
    }
  }

  private static formatLogs(tag: string, logs: LogsType[]): string {
    return `${tag}${SYMBOL}${Log.format(tag, logs)}`;
  }
}

type LogsType = string | number | object | undefined | LogsType[];