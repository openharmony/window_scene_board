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
import { TaskInfo } from './TaskInfo';

const TAG = 'IconTaskManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class IconTaskManager {
  private static maxPoolSize = 5;

  public static spliceTask(taskInfos: TaskInfo[]): TaskInfo[][] {
    let addNum: number = taskInfos.length % this.maxPoolSize === 0 ? 0 : 1;
    let singleTaskSize = (taskInfos.length / this.maxPoolSize) + addNum;
    let task: TaskInfo[][] = [];
    let index: number = 0;
    while (taskInfos.length > 0) {
      task[index++] = taskInfos.splice(0, singleTaskSize);
    }
    log.showInfo(`singleTaskSize is ${singleTaskSize}, task length is ${task.length} taskInfos length ${taskInfos.length}`);
    return task;
  }

}