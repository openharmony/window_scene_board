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