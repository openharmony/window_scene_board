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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG: string = 'TimeOutUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const DEFAULT_TASK_ID: number = -1;

/**
 * 定时器工具类
 *
 * @since 2025-01-13
 */
export class TimeOutUtils {
  private taskId: number = DEFAULT_TASK_ID;
  private delayTime: number = 0;
  private callback: Function;
  private callName: string = '';

  /**
   * 构造函数
   * @param delayTime 延迟时间
   * @param callback 回调函数
   * @param callName 调用方，用于日志打印
   */
  constructor(delayTime: number, callback: Function, callName?: string) {
    this.delayTime = delayTime;
    this.callback = callback;
    this.callName = callName;
  }

  public setTimeout(delayParam?: number): void {
    let delay: number = delayParam ? delayParam : this.delayTime;
    this.clearTimeout();
    this.taskId = setTimeout(() => {
      log.showInfo(`${this.callName} set time out callback`);
      this.taskId = DEFAULT_TASK_ID;
      this.callback();
    }, delay);
    log.showInfo(`${this.callName} set time out taskId: ${this.taskId}, delay: ${delay}`);
  }

  public clearTimeout(): void {
    if (this.taskId !== DEFAULT_TASK_ID) {
      log.showInfo(`${this.callName} clear time out taskId: ${this.taskId}`);
      clearTimeout(this.taskId);
      this.taskId = DEFAULT_TASK_ID;
    }
  }
}