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

import { TaskException } from '../viewmodel/viewdata/TaskException';
import { TaskExecutor } from '../viewmodel/viewdata/TaskExecutor';

/**
 * 任务感知回调接口
 */
export interface TaskCallBack {

  /**
   * 任务取消时触发回调
   * @param error 异常信息
   */
  onCheckFail: (error: TaskException) => void;

  /**
   * 任务取消时触发回调
   * @param task 任务对象
   */
  onCancel: (task: TaskExecutor) => void;

  /**
   * 任务异常时触发回调
   * @param task 任务对象
   * @param error 异常信息
   */
  onException: (task: TaskExecutor, error: Error) => void;

  /**
   * 任务异常时触发回调
   * @param task 任务对象
   * @param args 结束参数
   */
  onFinish: (task: TaskExecutor, ...args: Object[]) => void;
}