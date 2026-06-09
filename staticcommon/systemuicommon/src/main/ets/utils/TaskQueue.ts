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

import { CustomPromise } from '@ohos/frameworkwrapper/src/main/ets/base/CustomPromise';
import { DomainName, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { SystemUICommonUtil, TimeoutError } from './SystemUICommonUtil';
import { TraceUtil } from '@ohos/basicutils/src/main/ets/utils/TraceUtil';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, 'TaskQueue');
const TAG: string = 'TaskQueue';

/**
 * 通知冻结原因
 */
export enum TaskQueueFrozenReason {
  /**
   * 应用回胶囊动效
   */
  LIVE_APP_2_CAPSULE = 'LIVE_APP_2_CAPSULE',
}

/**
 * 任务项
 */
export class TaskItem<T = void> {
  public resultPromise: CustomPromise<T> = new CustomPromise();
  /**
   * 任务超时时间
   */
  public timeout?: number;
  /**
   * 任务超时后重试次数
   */
  public timeoutRetryTimes?: number;

  public isTimeout = false;

  /**
   * 任务执行次数
   */
  public currentTimes: number = 0;

  public startTime?: number;

  constructor(public taskName: string, public action: (times: number) => T | Promise<T>) { }
}

interface TaskException {
  taskQueueName: string;
  taskName: string;
  taskCount: number;
}

/**
 * 任务队列功能：
 * 1、支持指定并发数量
 * 2、支持异步任务排队
 */
export class TaskQueue {
  /**
   * task运行超过1min视为异常，统计时触发上报
   */
  private static readonly TASK_RUN_EXCEPTION_TIME = 60000;
  /**
   * 所有taskQueue列表
   */
  private static queueList: TaskQueue[] = [];
  /**
   * 正在执行的任务数量
   */
  private runningCount: number = 0;
  /**
   * 当前任务队列
   */
  public tasks: TaskItem<Object | void>[] = [];
  /**
   * 是否暂停
   */
  private isFreeze: boolean = false;
  /**
   * 正在运行的task
   */
  private runningTasks: Set<TaskItem<Object | void>> = new Set();

  private freezeReasonMap: Map<TaskQueueFrozenReason, number> = new Map();

  /**
   * 创建任务队列
   * @param concurrent 并发数量
   * @param interval   两次任务之间是否需要延时, 默认为0
   */
  constructor(private queueName, private concurrent: number, private interval: number = 0) {
    TaskQueue.queueList.push(this);
  }

  /**
   * 获取所有taskQueue的异常队列
   * @returns
   */
  public static getExceptionTaskQueue(): TaskException[] {
    const taskExceptions: TaskException[] = [];
    for (const taskQueue of TaskQueue.queueList) {
      const taskException = taskQueue.getExceptionInfo();
      if (taskException) {
        taskExceptions.push(taskException);
      }
    }
    return taskExceptions;
  }

  /**
   * 获取异常的task，如果一个任务执行时间超过1分钟，则视为异常
   * @returns
   */
  private getExceptionInfo(): TaskException | undefined {
    for (const task of this.runningTasks.values()) {
      log.showInfo(`Queue ${this.queueName} task ${task.taskName}, start at ${task.startTime}`);
      if (task.startTime !== undefined && (Date.now() - task.startTime) > TaskQueue.TASK_RUN_EXCEPTION_TIME) {
        log.showWarn(`Queue ${this.queueName} task ${task.taskName}, start at ${task.startTime} run too long`);
        return {
          taskQueueName: this.queueName,
          taskName: task.taskName,
          taskCount: this.tasks.length,
        };
      }
    }
    return undefined;
  }

  /**
   * 冻结队列执行
   */
  public freeze(reason: TaskQueueFrozenReason, timeout = 1500): void {
    log.showInfo(`Freeze with reason: ${reason}`);
    TraceUtil.startTrace(DomainName.SYS_UI, `${TAG}_Freeze:${reason}`);
    this.isFreeze = true;
    if (this.freezeReasonMap.has(reason)) {
      clearTimeout(this.freezeReasonMap.get(reason));
    }
    // 设置超时1500ms后自动解冻，避免业务不调用解冻导致通知数据一直不更新
    const freezeTimerId = setTimeout(() => {
      log.showWarn(`Timeout for freeze reason: ${reason}`);
      this.unfreeze(reason);
    }, timeout);
    this.freezeReasonMap.set(reason, freezeTimerId);
  }

  /**
   * 解除队列冻结
   */
  public unfreeze(reason: TaskQueueFrozenReason): void {
    log.showInfo(`Unfreeze with reason: ${reason}`);
    if (this.freezeReasonMap.has(reason)) {
      clearTimeout(this.freezeReasonMap.get(reason));
      this.freezeReasonMap.delete(reason);
    }

    if (this.isFreeze && this.freezeReasonMap.size === 0) {
      this.isFreeze = false;
      this.run();
    }

    TraceUtil.endTrace(DomainName.SYS_UI, `${TAG}_Freeze:${reason}`);
  }

  /**
   * 添加任务
   * @param task
   */
  public add(task: TaskItem<Object> | TaskItem<void>): void {
    this.tasks.push(task);
    log.showInfo(`Add task ${this.queueName}_${task.taskName}, count: ${this.tasks.length}`);
    this.run();
  }

  /**
   * 移除任务
   * @param task
   */
  public removeTask(task: TaskItem<Object> | TaskItem<void>): void {
    this.tasks = this.tasks.filter((t) => t !== task);
    log.showInfo(`Remove task ${this.queueName}_${task.taskName}, left task count: ${this.tasks.length}`);
  }

  /**
   * 递归并发执行任务
   * @returns
   */
  private async run(): Promise<void> {
    if (!this.tasks.length || this.runningCount >= this.concurrent || this.isFreeze) {
      log.showWarn(`stop run task, queueName ${this.queueName}, isFreeze: ${this.isFreeze}, runningCount: ${this.runningCount}, tasks length: ${this.tasks.length}`);
      return;
    }

    const task = this.tasks.shift()!;
    this.runningCount++;
    this.runningTasks.add(task);
    task.startTime = Date.now();
    log.showInfo(`execute queueName ${this.queueName}, task ${task.taskName}, runningCount ${this.runningCount}, startTime ${task.startTime}`);
    await this.executeTask(task);
    const consumeTime = Date.now() - task.startTime;
    log.showInfo(`Run task ${this.queueName}_${task.taskName}, time: ${consumeTime}, count: ${this.tasks.length}`);
    this.runningTasks.delete(task);
    // 两次任务之间是否需要延时
    if (this.interval >　0) {
      await SystemUICommonUtil.sleep(this.interval);
    }

    this.runningCount--;
    this.run();
  }

  private async executeTask(task: TaskItem<void | Object>, times: number = 0): Promise<void> {
    try {
      let result: void | Object;
      task.currentTimes = times;
      const retValue = Promise.resolve(task.action(times));
      if (task.timeout !== undefined) {
        log.showInfo('Run queue %{public}s %{public}s after %{public}d', this.queueName, task.taskName, task.timeout);
        result = await SystemUICommonUtil.timeout(retValue, task.timeout);
      } else {
        result = await retValue;
      }
      task.resultPromise.resolve(result);
    } catch (e) {
      log.error(`Run quque ${this.queueName} task ${task.taskName} error on times: ${times}:`, e);
      if (e instanceof TimeoutError && task.timeoutRetryTimes !== undefined && times < task.timeoutRetryTimes) {
        await this.executeTask(task, ++times);
      } else {
        task.isTimeout = e instanceof TimeoutError;
        task.resultPromise.reject(e);
      }
    }
  }
}