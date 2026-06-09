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

import { TaskpoolUtil } from './TaskpoolUtil';
import hidebug from '@ohos.hidebug';
import systemparameter from '@ohos.systemparameter';
import { LogDomain, LogHelper } from './LogHelper';

const TAG = 'LogCollectUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const COLLECT_INTERVAL: number = 9000000;

/**
 * 日志收集器
 */
export class LogCollectUtil {
  private static mInstance: LogCollectUtil;
  private mTimerId: number = -1;
  private mCollectLogCallbacksMap: Map<string, Function> = new Map();
  private mCollectInterval: number = COLLECT_INTERVAL; // 定时收集日志间隔时间（15分钟收集一次）
  private mLogCollectEnable: boolean = true;

  /**
   * 获取日志收集器实例
   *
   * @return 日志收集器实例
   */
  static getInstance(): LogCollectUtil {
    if (LogCollectUtil.mInstance == null) {
      LogCollectUtil.mInstance = new LogCollectUtil();
    }
    return LogCollectUtil.mInstance;
  }

  private constructor() {
    try {
      this.mCollectInterval = Number.parseInt(systemparameter.getSync('const.collect.log.interval', this
        .mCollectInterval.toString()));
      this.mLogCollectEnable = systemparameter.getSync('collect.log.enable', this.mLogCollectEnable
        .toString()) === 'true';
      log.showInfo(`mCollectInterval = ${this.mCollectInterval}, mLogCollectEnable = ${this.mLogCollectEnable}`);
    } catch (error) {
      log.showError(`getSync unexcepted error: ${error}`);
    }
  }

  /**
   * 注册收集日志函数回调
   *
   * @param logFunType 注册函数类型，用TAG标识唯一
   * @param collectLogCallback 日志收集函数回调
   */
  public registerCollectLogCallback(logFunType: string, collectLogCallback: Function): void {
    this.mCollectLogCallbacksMap.set(logFunType, collectLogCallback);
  }

  /**
   * 反注册收集日志函数回调
   *
   * @param logFunType 注册函数类型，用TAG标识唯一
   */
  public unregisterCollectLogCallback(logFunType: string): void {
    if (!this.mCollectLogCallbacksMap.has(logFunType)) {
      return;
    }
    this.mCollectLogCallbacksMap.delete(logFunType);
  }

  /**
   * 创建定时收集日志任务
   */
  public createCollectLogInterval(): void {
    if (this.mTimerId > 0) {
      return;
    }
    if (!this.mLogCollectEnable) {
      return;
    }
    this.mTimerId = setInterval(() => {
      this.collectLogs();
      TaskpoolUtil.doTask(collectMemory);
    }, this.mCollectInterval);
  }

  /**
   * 清理定时收集日志任务
   */
  public clearCollectLogInterval(): void {
    if (this.mTimerId > 0) {
      clearTimeout(this.mTimerId);
      this.mTimerId = -1;
    }
    this.mCollectLogCallbacksMap.clear();
  }

  private collectLogs(): void {
    this.mCollectLogCallbacksMap.forEach((collectLogCallback: Function, key: string) => {
      if (collectLogCallback) {
        collectLogCallback(TAG);
      }
    });
  }
}

function collectMemory(): void {
  'use concurrent';
  const TAG = 'LogCollectUtil';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
  let pssSize = hidebug.getPss() / BigInt(1024);
  const PSS_SIZE_THRESHOLD: number = 500;
  if (pssSize > PSS_SIZE_THRESHOLD) {
    let nativeHeapSize = hidebug.getNativeHeapSize() / BigInt(1024) / BigInt(1024);
    let nativeHeapAllocatedSize = hidebug.getNativeHeapAllocatedSize() / BigInt(1024) / BigInt(1024);

    log.showInfo(`current pssSize = ${pssSize}M, nativeHeapAllocatedSize = ${nativeHeapAllocatedSize}M, ` +
      `nativeHeapSize = ${nativeHeapSize}M`);
  }
}