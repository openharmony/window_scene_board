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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GcController } from './GcController';
import { MemoryInfo } from './MemoryInfo';
import type { GcDecider } from './GcDecider';
import { DEFAULT_PSS_DECIDER } from './GcDecider';
import { taskpool } from '@kit.ArkTS';

const TAG: string = 'MemoryMonitor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 内存监控器
 */
export class MemoryMonitor {
  private static mInstance: MemoryMonitor;

  private taskId: number | null = null;

  private mMonitorInterval: number = 0;

  private mDefaultGcDecider: GcDecider | undefined = undefined;

  private constructor() {
  }

  /**
   * 获取内存监视器单例
   *
   * @return 单例实例
   */
  public static getInstance(): MemoryMonitor {
    if (MemoryMonitor.mInstance == null) {
      MemoryMonitor.mInstance = new MemoryMonitor();
    }
    return MemoryMonitor.mInstance;
  }

  /**
   * 启动定时内存监控程序
   *
   * @returns void
   */
  public async startMonitor(): Promise<void> {
    // this.mMonitorInterval = MemoryUtils.getMemoryMonitorInterval();
    this.mDefaultGcDecider = DEFAULT_PSS_DECIDER;
    // log.showInfo(`startMonitor -> mMonitorInterval:${this.mMonitorInterval}`);
    this.resetMonitorInterval();
  }

  /**
   * 触发一次内存监控
   *
   * @param reason 执行原因
   * @param decider Gc决策器
   * @returns void
   */
  public async trimMonitorOnce(reason: string, decider?: GcDecider): Promise<void> {
    this.doMonitor(reason, decider);
    this.resetMonitorInterval();
  }

  /**
   * 异步获取内存信息
   *
   * @returns 内存信息
   */
  public async getMemoryInfo(): Promise<MemoryInfo | undefined> {
    try {
      const task = new taskpool.Task(getMemoryInfo);
      return await taskpool.execute(task) as MemoryInfo;
    } catch (error) {
      log.error(`getMemoryInfo error ${error.code}`);
    }
    return undefined;
  }

  private resetMonitorInterval(): void {
    if (this.taskId != null) {
      clearInterval(this.taskId);
    }
    this.taskId = setInterval(() => {
      this.doMonitor('monitor by interval task');
    }, this.mMonitorInterval);
  }

  private async doMonitor(reason: string, decider?: GcDecider): Promise<void> {
    let info: MemoryInfo | undefined = await this.getMemoryInfo();
    if (decider === undefined || decider === null) {
      decider = this.mDefaultGcDecider;
    }
    log.showInfo(`doMonitor -> reason:${reason}, memoryInfo:${MemoryInfo.toString(info)}, gcDecider:${decider?.toString()}`);
    if (info && decider?.isNeedRequestGc(info)) {
      GcController.getInstance().requestGcTask(reason);
    }
  }
}

/**
 * 内存查询任务子线程回调
 *
 * @returns 内存信息
 */
async function getMemoryInfo(): Promise<MemoryInfo> {
  'use concurrent';
  let memoryInfo: MemoryInfo = new MemoryInfo();
  // memoryInfo.pss = MemoryUtils.getPss();
  // memoryInfo.nativeHeap = MemoryUtils.getNativeHeapSize();
  return memoryInfo;
}