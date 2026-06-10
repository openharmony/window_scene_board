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

import { BaseTask } from '../../model/BaseTask';
import taskpool from '@ohos.taskpool';

/**
 * 任务执行对象
 */
@Observed
export class TaskExecutor extends BaseTask {
  // 基于taskType加序号方式生成
  public taskName: string | undefined;
  // 任务对象
  public task: taskpool.Task | undefined;
  // 执行参数
  public args: Object[] | undefined;
  // 实际开始执行时间
  public startTime: Date | undefined;
  // 实际结束时间
  public endTime: Date | undefined;
  // 任务执行耗时
  public useTime: number | undefined;
}