/**
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
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