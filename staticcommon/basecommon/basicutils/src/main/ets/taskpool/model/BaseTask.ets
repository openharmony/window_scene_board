/**
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

@Observed
export class BaseTask {
  // 任务分类
  public taskType: string | undefined;
  // 本任务最大实例数,超过则不允许创建
  public maxInstance: number = -1;
  // 本任务超时设置,单位毫秒(底层不支持,暂时无效)
  public timeoutMs: number = -1;
  // 并发满后处理方式
  public afterFull: number = -1;
}

export enum AfterFullType {
  /**
   * 忽略不处理
   */
  IGNORE = 0,

  /**
   * 等待队列执行
   */
  WAIT_QUEUE,

  /**
   * 按校验失败处理
   */
  CHECK_FAIL
}