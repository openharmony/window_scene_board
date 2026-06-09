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

import rpc from '@ohos.rpc';

/**
 * 执行接口定义
 *
 * @since 2024-03-28
 */
export interface IExecutor {
  /**
   * 调用执行
   *
   * @param extra 数据
   */
  execute(extra?: boolean, remoteObject?: rpc.IRemoteObject | null): Promise<void>;
}

/**
 * 响应状态
 *
 * @since 2024-04-11
 */
export enum CallResult {
  /**
   * 处理成功
   */
  SUCCESS = 'success',
  /**
   * 处理失败
   */
  FAIL = 'fail',
  /**
   * 非法的方法名称
   */
  INVALID_METHOD = 'invalid method',
  /*
   * 方法名称不存在
   */
  UNKNOWN_METHOD = 'unknown method',
  /**
   * 认证失败
   */
  VERIFY_FAILED = 'verify failed'
}