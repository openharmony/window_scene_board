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

import IIdlVisionGlassExtServiceCallback from './callback/IIdlVisionGlassExtServiceCallback';

export default interface IIdlVisionGlassExtService {
  /**
   * 向服务端注册回调接口，用于服务端主动向客户端通信
   * @param key 区分接口的键
   * @param cb 回调接口
   * @param operateResult 注册动作执行的结果
   */
  register(key: string, cb: IIdlVisionGlassExtServiceCallback, operateResult: operateResult): void;

  /**
   * 向服务端注销回调接口
   * @param key 区分接口的键
   * @param operateResult 注销动作执行的结果
   */
  unRegister(key: string, operateResult: operateResult): void;
}

export type operateResult = (errCode: number) => void;

export class IdlErrorCode {
  public static readonly SUCCESS: number = 0;
  public static readonly FAIL: number = -1;
}

export type GetVisionGlassAppListCallBack = (errCode: number, data: string) => void;

export type ResultBooleanCallback = (errCode: number, isSuccess: boolean) => void;

export type CommonCallBack = (data?: string, errCode?: number) => void;