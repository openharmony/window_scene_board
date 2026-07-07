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

import hilog from '@ohos.hilog';

const SYMBOL = ' --> ';

export enum LogDomain {
  SCB = 0x01b00, // Scene board
  HOME = 0x01b01, // Launcher
  SYS_UI = 0x01b02, // SystemUI
  NC = 0x01b03, // Notification Center
  CC = 0x01b04, // Control Center
  AOD = 0x01b05, // AOD
  KG = 0x01b06, // Keyguard
  AA = 0x01b07, // Negative Screen
  SEARCH = 0x01b08, // Global Search
  RECENT = 0x01b09, // Recent
  GESTURE = 0x01b0a, // Gesture
  AISUGGESTION = 0x01b0b, // AISuggestion
  WINDOW = 0x01b0c, // Window
  HICAR = 0x01b0d, // HiCar
  SCS = 0x01b0e, // Desktop setting
}

export const enum DomainName {
  SCB = 'SCB', // Scene board
  HOME = 'Home', // Launcher
  SYS_UI = 'SysUI', // SystemUI
  NC = 'NC', // Notification Center
  CC = 'CC', // Control Center
  AOD = 'AOD', // AOD
  KG = 'KG', // Keyguard
  AA = 'AA', // Negative Screen
  SEARCH = 'Search', // Global Search
  RECENT = 'Recent', // Recent
  GESTURE = 'Gesture', // Gesture
  AISUGGESTION = 'AISuggestion', // AISuggestion
  WINDOW = 'Window', // Window
  HICAR = 'HiCar', // HiCar
  DESKTOPSETTING = 'DesktopSetting'// Desktop setting
};

/**
 * Whether enables logs of each domain, used for debugging
 */
const LOG_ENABLE_MAP: Map<LogDomain, boolean> = new Map([
  [LogDomain.SCB, true],
  [LogDomain.HOME, true],
  [LogDomain.SYS_UI, true],
  [LogDomain.NC, true],
  [LogDomain.CC, true],
  [LogDomain.AOD, true],
  [LogDomain.KG, true],
  [LogDomain.AA, true],
  [LogDomain.SEARCH, true],
  [LogDomain.RECENT, true],
  [LogDomain.GESTURE, true],
  [LogDomain.AISUGGESTION, true],
  [LogDomain.WINDOW, true],
  [LogDomain.HICAR, true],
  [LogDomain.SCS, true]
]);

/**
 * log util class
 */
export class LogHelper {
  domain: number;
  domainName: string;
  tag: string;

  private static instanceMap: Map<string, LogHelper> = new Map();
  private static isLoggableMap: Map<string, boolean> = new Map();

  private constructor(domain: LogDomain, tag: string) {
    this.domain = domain;
    for (const [key, value] of Object.entries(LogDomain)) {
      if (value === domain) {
        this.domainName = key;
        break;
      }
    }
    this.tag = tag;
  }

  /**
   * get LogHelper instance.
   *
   * @param domain Indicates the log domain.
   * @param tag Indicates the log tag.
   */
  public static getLogHelper(domain: LogDomain, tag: string): LogHelper {
    const key = `${domain}-${tag}}`;
    if (!LogHelper.instanceMap.has(key)) {
      LogHelper.instanceMap.set(key, new LogHelper(domain, tag));
    }
    return LogHelper.instanceMap.get(key)!;
  }

  /**
   * Outputs info-level logs.
   *
   * @param format Indicates the log format string.
   * @param args Indicates the log parameters.
   */
  public showInfo(format: string, ...args: any[]): void {
    if (this.isLoggable(hilog.LogLevel.INFO)) {
      hilog.info(this.domain, this.domainName, this.tag + SYMBOL + format, args);
    }
  }

  /**
   * Outputs debug-level logs.
   *
   * @param format Indicates the log format string.
   * @param args Indicates the log parameters.
   */
  public showDebug(format: string, ...args: any[]): void {
    if (this.isLoggable(hilog.LogLevel.DEBUG)) {
      hilog.debug(this.domain, this.domainName, this.tag + SYMBOL + format, args);
    }
  }

  /**
   * Outputs warning-level logs.
   *
   * @param format Indicates the log format string.
   * @param args Indicates the log parameters.
   */
  public showWarn(format: string, ...args: any[]): void {
    if (this.isLoggable(hilog.LogLevel.WARN)) {
      hilog.warn(this.domain, this.domainName, this.tag + SYMBOL + format, args);
    }
  }

  /**
   * Outputs error-level logs.
   *
   * @param format Indicates the log format string.
   * @param args Indicates the log parameters.
   */
  public showError(format: string, ...args: any[]): void {
    if (this.isLoggable(hilog.LogLevel.ERROR)) {
      hilog.error(this.domain, this.domainName, this.tag + SYMBOL + format, args);
    }
  }

  /**
   * Outputs fatal-level logs.
   *
   * @param format Indicates the log format string.
   * @param args Indicates the log parameters.
   */
  public showFatal(format: string, ...args: any[]): void {
    if (this.isLoggable(hilog.LogLevel.FATAL)) {
      hilog.fatal(this.domain, this.domainName, this.tag + SYMBOL + format, args);
    }
  }

  /**
   * Outputs debug-level logs.
   *
   * @param logs Indicates the log content, support any value.
   */
  public debug(...logs: unknown[]): void {
    this.showDebug(this.format(logs));
  }

  /**
   * Outputs info-level logs.
   *
   * @param logs Indicates the log content, support any value.
   */
  public info(...logs: unknown[]): void {
    this.showInfo(this.format(logs));
  }

  /**
   * Outputs warn-level logs.
   *
   * @param logs Indicates the log content, support any value.
   */
  public warn(...logs: unknown[]): void {
    this.showWarn(this.format(logs));
  }

  /**
   * Outputs error-level logs.
   *
   * @param logs Indicates the log content, support any value.
   */
  public error(...logs: unknown[]): void {
    this.showError(this.format(logs));
  }

  /**
   * Outputs fatal-level logs.
   *
   * @param logs Indicates the log content, support any value.
   */
  public fatal(...logs: unknown[]): void {
    this.showFatal(this.format(logs));
  }

  /**
   * Checks whether logs of the specified tag, and level can be printed.
   *
   * @param level log level
   */
  public isLoggable(level: hilog.LogLevel): boolean {
    if (!LOG_ENABLE_MAP.has(this.domain)) {
      return false;
    }
    let key: string = `${this.domain}-${level}`;
    if (!LogHelper.isLoggableMap.has(key)) {
      LogHelper.isLoggableMap.set(key, hilog.isLoggable(this.domain, this.domainName, level));
    }
    return LogHelper.isLoggableMap.get(key)!;
  }

  /**
   * Format log content
   */
  private format(logs: unknown[]): string {
    const message = logs.map((log) => {
      try {
        if (typeof log === 'string') {
          return log;
        }

        if (log instanceof Error) {
          return this.formatError(log);
        }

        return JSON.stringify(log);
      } catch {
        return log;
      }
    }).join(' ');

    return message;
  }

  /**
   * Format Error content
   */
  private formatError(log: Error): string {
    let errorMessage = '';
    if (Object.prototype.hasOwnProperty.call(log, 'code')) {
      const code = (log as Error & { code: number }).code;
      errorMessage += code !== undefined ? `[${code}]` : '';
    }
    errorMessage += log.message;
    return errorMessage;
  }

}