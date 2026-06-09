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

import byTrace from '@ohos.hiTraceMeter';
import { DomainName } from './BasicCommon';

export class Trace {
  private static readonly TRACE_BASE_INDEX = 10000;

  private static taskIdMap: Map<string, number> = new Map<string, number>();

  private static traceIndex = Trace.TRACE_BASE_INDEX;

  private static setTaskIdOfTrace(taskName: string): number {
    let taskId = Trace.taskIdMap.get(taskName);
    if (taskId === undefined) {
      taskId = Trace.traceIndex;
      Trace.traceIndex++;
      Trace.taskIdMap.set(taskName, taskId);
    }
    return taskId;
  }

  private static getTaskIdOfTrace(taskName: string): number | undefined {
    let taskId: number | undefined = Trace.taskIdMap.get(taskName);
    if (taskId === undefined) {
      return undefined;
    }
    Trace.taskIdMap.delete(taskName);
    return taskId;
  }

  /**
   * start trace method
   *
   * @param {string} methodName - methodName for tracing
   */
  public static start(methodName: string): void {
    let taskName: string = `[${DomainName.SCB}]${methodName}`;
    let curTaskId: number = Trace.setTaskIdOfTrace(taskName);
    byTrace.startTrace(taskName, curTaskId);
  }
  /**
   * stop trace method
   *
   * @param {string} methodName - methodName for tracing
   */
  public static end(methodName: string): void {
    let taskName: string = `[${DomainName.SCB}]${methodName}`;
    let taskId: number | undefined = Trace.getTaskIdOfTrace(taskName);
    if (taskId === undefined) {
      return;
    }
    byTrace.finishTrace(taskName, taskId);
  }
}