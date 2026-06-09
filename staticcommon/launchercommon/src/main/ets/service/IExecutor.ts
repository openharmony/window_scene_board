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

import { rpc } from '@kit.IPCKit';

/**
 * 执行接口定义
 *
 * @since 2023-08-11
 */
export interface IExecutor {
  /**
   * 根据数据执行返回结果
   *
   * @param extra 数据
   * @returns 服务端消息json
   */
  execute(extra?: object, remoteObject?: rpc.IRemoteObject | null): Promise<string>;
}
