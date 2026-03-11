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
import taskPool from '@ohos.taskpool';
import { LogDomain, LogHelper } from '../../../utils/LogHelper';
import { Trace } from '../../../utils/Trace';
import { AfterFullType, BaseTask } from '../../model/BaseTask';
import { TaskCallBack } from '../../model/TaskCallBack';
import { TaskExecutor } from '../viewdata/TaskExecutor';
import { TaskException, TaskExceptionType } from '../viewdata/TaskException';
import { Queue } from '@kit.ArkTS';
import List from '@ohos.util.List';
import { TaskPool } from '../../TaskPool';

const TAG = 'TaskPoolManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 任务管理
 */
export class TaskManager {
  public pool: BaseTask | undefined;
  // 任务回调
  private _callBack: TaskCallBack | undefined;
  // 排队队列
  public waitQueue?: Queue<TaskExecutor> = new Queue<TaskExecutor>();
  // 执行中
  public runningTasks: List<TaskExecutor> = new List<TaskExecutor>();

  /**
   * 执行任务
   * @param task 任务
   */
  public callBack(callBack: TaskCallBack): TaskManager {
    this._callBack = callBack;
    return this;
  }

  /**
   * 任务取消
   * @param task 任务
   */
  public cancel(task: TaskExecutor): void {
    if (task.task) {
      log.showWarn(`${this.pool?.taskType} cancel task ${task.taskName}`)
      taskPool.cancel(task.task);
      this._callBack?.onCancel(task);
    }
  }

  /**
   * 按照任务类型创建任务
   * @param type 任务类型
   * @param func 任务
   * @param args 参数
   * @returns 任务对象
   */
  private createTask(type: TaskType, func: Function, ...args: Object[]): Promise<TaskExecutor> {
    return new Promise((resolve, reject) => {
      if (!this.pool?.taskType) {
        log.showError('BaseTask.taskType is empty');
        reject(new Error('Invalid task pool.'))
        return;
      }
      // 执行校验
      if (this.checkTask(reject)) {
        return;
      }
      let myTask: taskPool.Task;
      // 校验通过,创建任务
      if (type === TaskType.TASK) {
        myTask = new taskPool.Task(func, ...args);
      } else if (type === TaskType.LONG_TASK) {
        myTask = new taskPool.LongTask(func, ...args);
      } else {
        log.showError(`type is error :${type}`);
        throw new Error('type is error');
      }
      const task: TaskExecutor = new TaskExecutor();
      task.taskType = this.pool?.taskType;
      task.taskName = this.pool?.taskType + '_' + myTask.taskId;
      task.task = myTask;
      task.args = args;
      log.showInfo(`task new task:${task.taskName}`);
      resolve(task);
      this.execute(task);
    });
  }

  /**
   * 执行普通任务
   * @param task 任务
   */
  public submit(func: Function, ...args: Object[]): Promise<TaskExecutor> {
    log.showInfo(`${this.pool?.taskType} submit task`);
    return this.createTask(TaskType.TASK, func, ...args);
  }

  /**
   * 执行长时间任务
   * @param task 任务
   */
  public longTask(func: Function, ...args: Object[]): Promise<TaskExecutor> {
    log.showInfo(`${this.pool?.taskType} submit longTask`);
    return this.createTask(TaskType.LONG_TASK, func, ...args);
  }

  /**
   * 执行校验
   * @returns
   */
  private checkTask(reject: Function): boolean {
    if (this._callBack === undefined) {
      log.showInfo(`checkTask fail; callBack is must.`);
      reject(new Error('callBack is must.'));
      return true;
    }
    if (!this.pool) {
      this.reportError(reject, 'pool is must.')
      return true;
    }
    if (this.pool.afterFull < 0 || this.pool.afterFull > AfterFullType.CHECK_FAIL) {
      this.reportError(reject, 'afterFull is error.')
      return true;
    }
    if (this.pool.maxInstance <= 0) {
      this.reportError(reject, 'maxInstance need > 0.');
      return true;
    }
    if (this.runningTasks.length >= this.pool.maxInstance) {
      if (this.pool?.afterFull === AfterFullType.CHECK_FAIL) {
        // 线程池已满,并且按校验失败处理
        this.reportError(reject, 'The task pool is full.');
      }
      log.showInfo(`The task pool is full. afterFull: ${this.pool?.afterFull}`);
      // 设置忽略,则返回true,任务终止,否则继续,流程后续判断是否添加到队列
      return this.pool?.afterFull === AfterFullType.IGNORE;
    }
    return false;
  }

  /**
   * 异常上报
   * @param reject 异常回调
   * @param error 错误信息
   */
  private reportError(reject: Function, error: string): void {
    log.showInfo(`checkTask fail; ${error}`);
    const exception: TaskException = new TaskException(TaskExceptionType.CHECK_FAIL, error);
    this._callBack?.onCheckFail(exception);
    reject(new Error(error));
  }

  /**
   * 执行任务
   * @param task 任务
   */
  private execute(task: TaskExecutor): void {
    if (this.runningTasks.length + 1 > (this.pool?.maxInstance || 0)) {
      if (this.pool?.afterFull === AfterFullType.WAIT_QUEUE) {
        // 任务池满时,加入等待队列
        this.waitQueue?.add(task);
      }
      return;
    }
    const myTask: taskPool.Task = this.getTask(task);
    taskPool.execute(myTask)
      .then((data) => {
        log.showInfo(`task finish:${this.pool?.taskType}_${myTask?.taskId}`);
        this._callBack?.onFinish(task, data);
      })
      .catch((error: Error) => {
        log.error(`task ${task.taskName} error`, error);
      }).finally(() => {
      Trace.end('TASK_POOL_' + task.taskName);
      task.endTime = new Date();
      if (task.startTime && task.endTime) {
        task.useTime = task.endTime.getTime() - task.startTime.getTime();
      }
      log.showInfo(`task end:${task.taskName}; useTime:${task.useTime}`);
      this.runningTasks.remove(task);
      // 任务结束,检查队列,执行下一个
      let waitTask = this.waitQueue?.pop();
      if (waitTask) {
        log.showInfo(`execute wait task:${task.taskName}`);
        this.execute(waitTask);
      } else if (this.runningTasks.length === 0) {
        log.showInfo(`task pool finish:${task.taskType}`);
        // 任务结束,清理pool
        TaskPool.clearTask(this.pool);
      }
      log.showWarn(`pool status: ${task.taskType}; running:${this.runningTasks.length};wait:${this.waitQueue?.length}`);
    });
  }

  private getTask(task: TaskExecutor): taskPool.Task {
    if (!task.task) {
      throw new Error('task is null');
    }
    const myTask: taskPool.Task = task.task;
    log.showInfo(`task start:${task.taskName}`);
    this.runningTasks.add(task);
    myTask?.onStartExecution(() => {
      Trace.start('TASK_POOL_' + task.taskName);
      task.startTime = new Date();
      log.showInfo(`task start execution:${task.taskName}`);
    });
    myTask?.onExecutionFailed((e: Error) => {
      log.error(`task failed:${task.taskName} ${e.message}`, e);
      this._callBack?.onException(task, e);
    });
    return myTask;
  }
}

export enum TaskType {
  /**
   * 限时TASK
   */
  TASK = 0,

  /**
   * 长时间任务
   */
  LONG_TASK
}