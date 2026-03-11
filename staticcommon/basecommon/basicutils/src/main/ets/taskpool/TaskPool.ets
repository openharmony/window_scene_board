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

import { CheckEmptyUtils } from '../utils/CheckEmptyUtils';
import FileUtils from '../utils/FileUtils';
import { LogDomain, LogHelper } from '../utils/LogHelper';
import { BaseTask } from './model/BaseTask';
import { TaskCallBack } from './model/TaskCallBack';
import { TaskManager } from './viewmodel/viewhandler/TaskManager';
import { HashMap } from '@kit.ArkTS';

const TAG = 'basicUtilsTaskPool';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 任务池入口
 */
export class TaskPool {
  private static taskPool: HashMap<string, TaskManager> = new HashMap();
  public static config: HashMap<string, BaseTask> = new HashMap();

  /**
   * 获取任务池
   * @param taskType 任务信息
   * @param args 回调可选参数
   * @returns 任务池对象
   */
  public static getPool(taskType: string, ...args: Object[]): TaskManager {
    if (!TaskPool.config.hasKey(taskType)) {
      log.showError(`taskType is error;${TaskPool.config.length};Please check in file:resources/rawfile/basicutils_taskpool.json`);
      return new TaskManager();
    }
    if (TaskPool.taskPool.hasKey(taskType)) {
      const manager: TaskManager | undefined = TaskPool.taskPool.get(taskType);
      if (manager) {
        if (!CheckEmptyUtils.isEmptyArr(args)) {
          manager.callBack(args[0] as TaskCallBack);
        }
        return manager;
      }
    }
    // 当前没有执行中的任务池,创建一个新的
    let baseTask: BaseTask = JSON.parse(JSON.stringify(TaskPool.config.get(taskType)));
    if (!baseTask?.taskType) {
      log.showError('BaseTask.taskType is empty');
      return new TaskManager();
    }
    const manager: TaskManager = new TaskManager();
    manager.pool = baseTask;
    if (!CheckEmptyUtils.isEmptyArr(args)) {
      manager.callBack(args[0] as TaskCallBack);
    }
    TaskPool.taskPool.set(baseTask.taskType, manager);
    log.showWarn(`task pool size:${TaskPool.taskPool.length}`);
    return manager;
  }

  /**
   * 任务终止
   * @param options clearTask
   */
  public static clearTask(options: BaseTask | undefined): void {
    if (CheckEmptyUtils.checkStrIsEmpty(options?.taskType)) {
      log.showError('options.taskType is empty');
      return;
    }
    if (options?.taskType && TaskPool.taskPool.hasKey(options?.taskType)) {
      TaskPool.taskPool.remove(options?.taskType);
      log.showWarn(`task pool size:${TaskPool.taskPool.length}`);
    }
  }
}

export { BaseTask, AfterFullType } from './model/BaseTask';

export { TaskException, TaskExceptionType } from './viewmodel/viewdata/TaskException';

export { TaskExecutor } from './viewmodel/viewdata/TaskExecutor';

export { TaskManager } from './viewmodel/viewhandler/TaskManager';