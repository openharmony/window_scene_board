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

import { RemoteReq } from './RemoteReq';
import { RemoteRsp } from './RemoteRsp';

/**
 * 远程拦截器接口
 * 定义了一个名为intercept的方法，该方法接收一个可选的RemoteReq类型的参数，并返回一个Promise<RemoteRsp>或RemoteRsp类型的值
 */
export interface RemoteInterceptor {
  /**
   * 拦截方法，接收一个可选的RemoteReq类型的请求参数
   *
   * @param timestamp 请求时间戳
   * @param req 可选的RemoteReq类型的请求参数
   * @param rsp 响应结果
   * @return 返回一个Promise<boolean>或boolean类型的响应. false不拦截结果
   */
  intercept(timestamp: number, req: RemoteReq, rsp: RemoteRsp): Promise<boolean> | boolean;
}