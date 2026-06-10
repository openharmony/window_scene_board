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
import { JsonUtils } from '../utils/JsonUtils';
import { getRawDataCodec } from './codec/RawDataCodec';

const TAG: string = 'RpcCodec';

export namespace RpcCodec {
  /**
   * 将数据转换为RPC消息序列
   * @param version 跨端接口版本号
   * @param data 数据
   * @param rpcMessage RPC消息序列
   * @returns RPC消息序列
   */
  export function toRpc<T>(version: number, data: T, rpcMessage: rpc.MessageSequence): rpc.MessageSequence {
    let reply: rpc.MessageSequence = rpcMessage;
    getRawDataCodec(version).writeRawData(JsonUtils.stringify(data), reply);
    return reply;
  }

  /**
   * 从RPC消息序列中提取数据
   * @param version 跨端接口版本号
   * @param rpcMessage RPC消息序列
   * @returns 数据
   */
  export function fromRpc<T>(version: number, rpcMessage: rpc.MessageSequence | undefined): T | undefined {
    return rpcMessage === undefined ? undefined : JsonUtils.parse(getRawDataCodec(version).readRawData(rpcMessage));
  }

  /**
   * 解码RPC响应
   * @param value RPC响应字符串
   * @returns 解码对象
   */
  export function decodeRsp<T>(value: string | undefined): T | undefined {
    return value !== undefined ? JsonUtils.parse(value) : undefined;
  }

  /**
   * 编码RPC响应
   * @param rsp PPC对象
   * @returns 编码字符串
   */
  export function encodeRsp<T>(rsp: T): string | undefined {
    return rsp !== undefined ? JsonUtils.stringify(rsp) : undefined;
  }
}
