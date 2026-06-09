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
export class TaskException {
  // 异常编号
  public errorCode: TaskExceptionType = -1;
  // 异常概述
  public msg: string | undefined;
  // 异常信息
  public error: Error | undefined;

  /**
   * 初始化异常对象
   * @param errorCode 错误编码
   * @param args 异常信息
   */
  constructor(errorCode: TaskExceptionType, ...args: Object[]) {
    this.errorCode = errorCode;
    if (args) {
      for (let i: number = 0; i < args.length; i++) {
        switch (i) {
          case 0:
            this.msg = args[0] as string;
            break;
          case 1:
            this.error = args[1] as Error;
            break;
          default:
            break;
        }
      }
    }
  }
}

export enum TaskExceptionType {
  /**
   * 校验失败,不执行
   */
  CHECK_FAIL = 0,

  /**
   * 执行失败
   */
  RUN_ERROR
}