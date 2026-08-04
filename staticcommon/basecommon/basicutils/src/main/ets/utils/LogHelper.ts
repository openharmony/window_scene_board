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

const SYMBOL = ': ';
type AnyType = string | boolean | number | bigint | null | object | undefined;

interface LoggerError extends Error {
  code: number;
}

export enum LogDomain {
  SCB = 0x01b00, // Scene board
  HOME = 0x01b01, // Launcher
  SYS_UI = 0x01a00, // SystemUI
  NC = 0x01a01, // Notification Center
  CC = 0x01b04, // Control Center
  AOD = 0x01b05, // AOD
  KG = 0x01b06, // Keyguard
  AA = 0x0001b, // Negative Screen
  SEARCH = 0x0ff00, // Global Search
  RECENT = 0x01b09, // Recent
  GESTURE = 0x01b0a, // Gesture
  WINDOW = 0x04200, // Window
  HICAR = 0x01b0d, // HiCar
  SCS = 0x01b0e, // Desktop setting
  TE = 0x01b0f, // Theme Editor
  PRIVACY_INDICATOR = 0x01b10, // Privacy Indicator
  WATCH_WF = 0X01c01, // watchface
  WATCH_BC = 0X01c02, // borderless canvas
  LM = 0x01c03, // Layout Manager
  MC = 0x01c04, // Media Control
  FORM = 0x01c05, // SceneBoard Card
  ICON = 0x01c06, // SceneBoard Icon
  VISION_GLASS = 0x01c07, // Vision Glass
  BACKUP = 0x01c08, // Back Up
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
  WINDOW = 'Window', // Window
  HICAR = 'HiCar', // HiCar
  DESKTOPSETTING = 'DesktopSetting', // Desktop setting
  TE = 'ThemeEditor', // Theme Editor
  PRIVACY_INDICATOR = 'PrivacyIndicator', // Privacy Indicator
  WATCH_WF = 'Watchface', // Watchface
  WATCH_BC = 'BorderlessCanvas', // Borderless Canvas
  LM = 'LayoutManager', // Layout Manager
  MC = 'MediaControl', // Media Control
  FORM = 'SceneBoardCard', // SceneBoard Card
  ICON = 'SceneBoardIcon', // SceneBoard Icon
  BACKUP = 'DesktopBackUp', // Desktop Back Up
};

/**
 * Whether enables logs of each domain, used for debugging
 */
export const LOG_ENABLE_MAP: Map<LogDomain, boolean> = new Map([
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
  [LogDomain.WINDOW, true],
  [LogDomain.HICAR, true],
  [LogDomain.SCS, true],
  [LogDomain.TE, true],
  [LogDomain.PRIVACY_INDICATOR, true],
  [LogDomain.WATCH_WF, true],
  [LogDomain.WATCH_BC, true],
  [LogDomain.LM, true],
  [LogDomain.MC, true],
  [LogDomain.FORM, true],
  [LogDomain.ICON, true],
  [LogDomain.VISION_GLASS, true],
  [LogDomain.BACKUP, true]
]);

/**
 * log util class
 * @deprecated 这个类的实现会造成每个tag一个实例，在大桌面业务中内存使用效率太低，所以后面要转为使用Logger
 */
export class LogHelper {
  domain: number;
  domainName: string;
  tag: string;

  private static instanceMap: Map<string, LogHelper> = new Map();
  private static isLoggableMap: Map<string, boolean> = new Map();

  private constructor(domain: LogDomain, tag: string) {
    this.domain = domain;
    let entries: [string, string | LogDomain][] = Object.entries(LogDomain);
    entries.forEach((value: [string, string | LogDomain], index: number) => {
      if (value[0] === domain.toString()) {
        this.domainName = value[1].toString();
        return;
      }
    })
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
   * delete LogHelper instance by domain and tag
   *
   * @param domain Indicates the log domain.
   * @param tag Indicates the log tag.
   */
  public static deleteLogHelper2(domain: LogDomain, tag: string): void {
    const key = `${domain}-${tag}}`;
    LogHelper.instanceMap.delete(key);
  }

  /**
   * delete LogHelper instance.
   *
   * @param instance: LogHelper instance.
   */
  public static deleteLogHelper(instance: LogHelper): void {
    if (!instance) {
      return;
    }
    const key = `${instance.domain}-${instance.tag}}`;
    LogHelper.instanceMap.delete(key);
  }

  /**
   * Outputs info-level logs.
   *
   * @param format Indicates the log format string.
   * @param args Indicates the log parameters.
   */
  public showInfo(format: string, ...args: AnyType[]): void {
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
  public showDebug(format: string, ...args: AnyType[]): void {
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
  public showWarn(format: string, ...args: AnyType[]): void {
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
  public showError(format: string, ...args: AnyType[]): void {
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
  public showFatal(format: string, ...args: AnyType[]): void {
    if (this.isLoggable(hilog.LogLevel.FATAL)) {
      hilog.fatal(this.domain, this.domainName, this.tag + SYMBOL + format, args);
    }
  }

  /**
   * Outputs debug-level logs.
   *
   * @param logs Indicates the log content, support any value.
   */
  public debug(...logs: AnyType[]): void {
    this.showDebug(this.format(logs));
  }

  /**
   * Outputs info-level logs.
   *
   * @param logs Indicates the log content, support any value.
   */
  public info(...logs: AnyType[]): void {
    this.showInfo(this.format(logs));
  }

  /**
   * Outputs warn-level logs.
   *
   * @param logs Indicates the log content, support any value.
   */
  public warn(...logs: AnyType[]): void {
    this.showWarn(this.format(logs));
  }

  /**
   * Outputs error-level logs.
   *
   * @param logs Indicates the log content, support any value.
   */
  public error(...logs: AnyType[]): void {
    this.showError(this.format(logs));
  }

  /**
   * Outputs fatal-level logs.
   *
   * @param logs Indicates the log content, support any value.
   */
  public fatal(...logs: AnyType[]): void {
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
  private format(logs: AnyType[]): string {
    const message = logs.map((log: AnyType) => {
      try {
        if (typeof log === 'string') {
          return log;
        }

        if (log instanceof Error) {
          let errorMessage = '';
          if (Object.keys(log).includes('code')) {
            const code: number = (log as LoggerError).code;
            errorMessage += code !== undefined ? `[${code}]` : '';
          }
          errorMessage += log.message;
          return errorMessage + (log.stack ? '\n' + log.stack : '');
        }

        return JSON.stringify(log);
      } catch {
        return log;
      }
    }).join(' ');

    return message;
  }
}