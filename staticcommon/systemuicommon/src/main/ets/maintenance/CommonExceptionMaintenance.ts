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
import { Logger, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { ICommonExceptionReporter } from './ICommonExceptionMaintenance';

/**
 * 调用异常打点
 */
export class CommonExceptionMaintenance {
  public static get = SingletonHelper.createFactory(() => new CommonExceptionMaintenance());

  private reporter: ICommonExceptionReporter;

  public init(reporter: ICommonExceptionReporter): void {
    this.reporter = reporter;
  }

  public report(desc: string, info?: number | Error, stack?: string, tag?: string): void {
    if (!this.reporter) {
      return;
    }
    if (info instanceof Error) {
      // 无指定code场景
      this.reporter.reportInfo(desc, undefined, info?.stack, tag);
    } else {
      // 指定code场景
      this.reporter.reportInfo(desc, info, stack, tag);
    }
  }
}

/**
 * 日志+打点工具类
 */
export class LogWithHa {
  /**
   * info日志+打点
   * @param log logger
   * @param desc info描述
   * @param info HA打点错误码或错误信息
   * @param e 错误信息
   * @param tag 限频维度
   */
  public static info(log: LogHelper, desc: string, info?: number | Error, e?: Error, tag?: string): void {
    log.showInfo(desc);
    CommonExceptionMaintenance.get().report(desc, info, e?.stack, tag);
  }

  /**
   * warning日志+打点
   * @param log logger
   * @param desc warn描述
   * @param info HA打点错误码或错误信息
   * @param e 错误信息
   * @param tag 限频维度
   */
  public static warn(log: LogHelper, desc: string, info?: number | Error, e?: Error, tag?: string): void {
    log.showWarn(desc);
    CommonExceptionMaintenance.get().report(desc, info, e?.stack, tag);
  }

  /**
   * error日志+打点
   * @param log logger
   * @param desc error描述
   * @param info HA打点错误码或错误信息
   * @param e 错误信息
   * @param tag 限频维度
   */
  public static error(log: LogHelper, desc: string, info?: number | Error, e?: Error, tag?: string): void {
    log.showError(desc);
    CommonExceptionMaintenance.get().report(desc, info, e?.stack, tag);
  }

  /**
   * 打印Info日志并打点
   * @param log logger
   * @param tag TAG
   * @param msg 日志信息
   * @param haCode Ha错误码
   * @param error 异常信息
   */
  public static showInfo(log: Logger, tag: string, msg: string, haCode?: number, error?: Error): void {
    log.showInfo(tag, msg);
    CommonExceptionMaintenance.get().report(msg, haCode, error?.stack, tag);
  }

  /**
   * 打印Warn日志并打点
   * @param log logger
   * @param tag TAG
   * @param msg 日志信息
   * @param haCode Ha错误码
   * @param error 异常信息
   */
  public static showWarn(log: Logger, tag: string, msg: string, haCode?: number, error?: Error): void {
    log.showWarn(tag, msg);
    CommonExceptionMaintenance.get().report(msg, haCode, error?.stack, tag);
  }

  /**
   * 打印Error日志并打点
   * @param log logger
   * @param tag TAG
   * @param msg 日志信息
   * @param haCode Ha错误码
   * @param error 异常信息
   */
  public static showError(log: Logger, tag: string, msg: string, haCode?: number, error?: Error): void {
    log.showError(tag, msg);
    CommonExceptionMaintenance.get().report(msg, haCode, error?.stack, tag);
  }
}