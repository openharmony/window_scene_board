/**
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

import { BaseTask } from './BaseTask';

@Observed
export class DbTask extends BaseTask {
  // 任务分类
  public dataName: string = '';
}