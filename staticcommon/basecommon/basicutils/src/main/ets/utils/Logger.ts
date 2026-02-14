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
import { LogDomain, LOG_ENABLE_MAP } from './LogHelper';
import { hilog } from '@kit.PerformanceAnalysisKit';

const SYMBOL = ' --> ';
type AnyType = string | boolean | number | bigint | null | object | undefined;

interface LoggerError extends Error {
  code: number;
}

/**
 * 一个内存占用比LogHelper小的日志工具类
 *
 * 内存上的优化:
 * 一个domain对应一个Logger实例，理论上最多25个实例
 * 虚拟机占用最大值应该是2.3KB * 1 + 0.1KB * 25 = 4.8KB
 * 而LogHelper现在有2600多个实例，虚拟机内存占用约为151KB
 *
 * 缺点：
 * 调用方式比LoggerHelper稍微复杂一些，任何调用都需要传tag作为参数
 */
export class Logger {
  // 域编号
  private domainNumber: number = -1;
  // 域名称
  private domainName: string = '';
  // Logger实例缓存, key 为domain, value 为Logger实例
  private static instanceMap: Map<string, Logger> = new Map();
  // 缓存domain+Level是否可以打印日志
  private static isLoggableMap: Map<string, boolean> = new Map();

  private constructor(domain: LogDomain) {
    this.domainNumber = domain;
    let entries: [string, string | LogDomain][] = Object.entries(LogDomain);
    entries.forEach((value: [string, string | LogDomain], index: number) => {
      if (value[0] === domain.toString()) {
        this.domainName = value[1].toString();
        return;
      }
    })
  }

  /**
   * 获取一个Logger实例
   *
   * @param domain 域参数
   */
  public static getLogHelper(domain: LogDomain): Logger {
    const key = `${domain}`;
    if (!Logger.instanceMap.has(key)) {
      Logger.instanceMap.set(key, new Logger(domain));
    }
    return Logger.instanceMap.get(key)!;
  }

  /**
   * 打印 info 级别日志
   *
   * @param tag 日志标签，通常为代码文件的TAG
   * @param format 日志格式化字符串
   * @param args 日志参数
   */
  public showInfo(tag: string, format: string, ...args: AnyType[]): void {
    if (this.isLoggable(hilog.LogLevel.INFO)) {
      hilog.info(this.domainNumber, this.domainName, tag + SYMBOL + format, args);
    }
  }

  /**
   * 打印 debug 级别日志
   *
   * @param tag 日志标签，通常为代码文件的TAG
   * @param format 日志格式化字符串
   * @param args 日志参数
   */
  public showDebug(tag: string, format: string, ...args: AnyType[]): void {
    if (this.isLoggable(hilog.LogLevel.DEBUG)) {
      hilog.debug(this.domainNumber, this.domainName, tag + SYMBOL + format, args);
    }
  }

  /**
   * 打印 warning 级别日志
   *
   * @param tag 日志标签，通常为代码文件的TAG
   * @param format 日志格式化字符串
   * @param args 日志参数
   */
  public showWarn(tag: string, format: string, ...args: AnyType[]): void {
    if (this.isLoggable(hilog.LogLevel.WARN)) {
      hilog.warn(this.domainNumber, this.domainName, tag + SYMBOL + format, args);
    }
  }

  /**
   * 打印 error 级别日志
   *
   * @param tag 日志标签，通常为代码文件的TAG
   * @param format 日志格式化字符串
   * @param args 日志参数
   */
  public showError(tag: string, format: string, ...args: AnyType[]): void {
    if (this.isLoggable(hilog.LogLevel.ERROR)) {
      hilog.error(this.domainNumber, this.domainName, tag + SYMBOL + format, args);
    }
  }

  /**
   * 打印 fatal 级别日志
   *
   * @param tag 日志标签，通常为代码文件的TAG
   * @param format 日志格式化字符串
   * @param args 日志参数
   */
  public showFatal(tag: string, format: string, ...args: AnyType[]): void {
    if (this.isLoggable(hilog.LogLevel.FATAL)) {
      hilog.fatal(this.domainNumber, this.domainName, tag + SYMBOL + format, args);
    }
  }

  /**
   * 打印 debug 级别日志
   *
   * @param tag 日志标签，通常为代码文件的TAG
   * @param logs 日志内容，支持所有类型
   */
  public debug(tag: string, ...logs: AnyType[]): void {
    this.showDebug(tag, this.format(logs));
  }

  /**
   * 打印 info 级别日志
   *
   * @param tag 日志标签，通常为代码文件的TAG
   * @param logs 日志内容，支持所有类型
   */
  public info(tag: string, ...logs: AnyType[]): void {
    this.showInfo(tag, this.format(logs));
  }

  /**
   * 打印 warn 级别日志
   *
   * @param tag 日志标签，通常为代码文件的TAG
   * @param logs 日志内容，支持所有类型
   */
  public warn(tag: string, ...logs: AnyType[]): void {
    this.showWarn(tag, this.format(logs));
  }

  /**
   * 打印 error 级别日志
   *
   * @param tag 日志标签，通常为代码文件的TAG
   * @param logs 日志内容，支持所有类型
   */
  public error(tag: string, ...logs: AnyType[]): void {
    this.showError(tag, this.format(logs));
  }

  /**
   * 打印 fatal 级别日志
   *
   * @param tag 日志标签，通常为代码文件的TAG
   * @param logs 日志内容，支持所有类型
   */
  public fatal(tag: string, ...logs: AnyType[]): void {
    this.showFatal(tag, this.format(logs));
  }

  /**
   * 判断日志级别能否允许打印
   *
   * @param level 日志级别
   */
  private isLoggable(level: hilog.LogLevel): boolean {
    if (!LOG_ENABLE_MAP.has(this.domainNumber)) {
      return false;
    }
    let key: string = `${this.domainNumber}-${level}`;
    if (!Logger.isLoggableMap.has(key)) {
      Logger.isLoggableMap.set(key, hilog.isLoggable(this.domainNumber, this.domainName, level));
    }
    return Logger.isLoggableMap.get(key)!;
  }

  /**
   * 格式化日志内容
   */
  private format(logs: AnyType[]): string {
    const message = logs.map((log) => {
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