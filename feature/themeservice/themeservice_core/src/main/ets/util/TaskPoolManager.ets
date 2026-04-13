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
import { Singleton, TsLog } from '@ohos/themeservicebase/Index';

const TAG: string = 'TaskPoolManager';

/**
 * 线程池管理类
 */
export default class TaskPoolManager {
  private static readonly INSTANCE: Singleton<TaskPoolManager> =
    new Singleton<TaskPoolManager>(() => new TaskPoolManager());

  public static getInstance(): TaskPoolManager {
    return TaskPoolManager.INSTANCE.get();
  }

  /**
   * 串行任务队列（低优先级）
   */
  private sequenceRunner: taskPool.SequenceRunner = new taskPool.SequenceRunner(taskPool.Priority.LOW);

  /**
   * 在taskPool子线程中处理任务
   *
   * @param task 待处理的任务
   * @returns Promise<boolean> 缓存优化结果
   */
  async processTask(task: taskPool.Task): Promise<Nullable<Object>> {
    TsLog.debug(TAG, `start processTask`);
    let result: Nullable<Object>;
    try {
      result = await this.sequenceRunner.execute(task);
    } catch (e) {
      TsLog.error(TAG, 'processTask failed:', e);
    }
    return result;
  }
}
