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
import taskpool from '@ohos.taskpool';
import { LogDomain, LogHelper } from './LogHelper';

const TAG = 'TaskpoolUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class TaskpoolUtil {

  public static async execute(func: Function, ...args: unknown[]): Promise<unknown> {
    try {
      taskpool.execute(func, ...args)
        .then((data) => {
          return data;
        })
        .catch((error) => {
          log.error('taskpool execute try error', error);
        });
    } catch (error) {
      log.error(`execute error when execute ${func.name},`, error);
    }
    return undefined;
  }

  public static async doTask(func: Function, ...args: unknown[]): Promise<unknown> {
    try {
      const myTask = new taskpool.Task(func, ...args);
      taskpool.execute(myTask)
        .then((data) => {
          return data;
        })
        .catch((error) => {
          log.error('taskpool execute try error', error);
        });
    } catch (e) {
      log.error(`doTask error when execute ${func.name},`, e);
    }
    return undefined;
  }

}