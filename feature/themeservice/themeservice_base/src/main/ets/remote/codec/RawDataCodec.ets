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
import { TsLog } from '../../log/TsLog';
import { TextCodec } from '../../utils/TextCodec';
import { VERSION_0, VERSION_1 } from '../RemoteCode';

const TAG: string = 'RawDataCodec';

/**
 * 根据版本号获取对应的原始数据编解码器
 * @param version 跨端接口版本号
 * @return 返回对应版本的原始数据编解码器
 */
export function getRawDataCodec(version: number): RawDataCodec {
  // 如果版本号为0，返回原始数据编解码器V0
  if (version === VERSION_0) {
    return new RawDataCodecV0();
  }
  // 如果版本号为1，返回原始数据编解码器V1
  if (version === VERSION_1) {
    return new RawDataCodecV1();
  }
  // 如果版本号既不是0,也不是1，返回原始数据编解码器V1
  return new RawDataCodecV0();
}

/**
 * 处理Raw数据的编解码器
 */
export interface RawDataCodec {
  /**
   * 将原始数据写入RPC消息序列
   * @param {(string | undefined)} rawData 原始数据，可能为undefined
   * @param {rpc.MessageSequence} reply RPC消息序列
   */
  writeRawData(rawData: string | undefined, reply: rpc.MessageSequence): void;

  /**
   * 从RPC消息序列中读取原始数据
   * @param {rpc.MessageSequence} reply RPC消息序列
   * @returns {string} 返回读取到的原始数据
   */
  readRawData(reply: rpc.MessageSequence): string
}

/**
 * 编解码，版本0
 */
class RawDataCodecV0 implements RawDataCodec {
  writeRawData(rawData: string | undefined, reply: rpc.MessageSequence): void {
    if (rawData === undefined || !reply) {
      TsLog.error(TAG, 'writeRawData arg is empty');
      return;
    }
    // 写入二进制数据
    let replyBytes: Uint8Array = TextCodec.encodeToUint8Array(rawData);
    reply.writeInt(replyBytes.length);
    reply.writeRawData([...replyBytes], replyBytes.length);
  }

  readRawData(reply: rpc.MessageSequence): string {
    // 读取二进制数据
    let inputLength: number = reply.readInt();
    let inputBytes: number[] = reply.readRawData(inputLength);
    return TextCodec.decodeToString(new Uint8Array(inputBytes));
  }
}

/**
 * 编解码，版本1
 */
class RawDataCodecV1 implements RawDataCodec {
  writeRawData(rawData: string | undefined, reply: rpc.MessageSequence): void {
    if (rawData === undefined || !reply) {
      TsLog.error(TAG, 'writeRawData arg is empty');
      return;
    }
    // 写入二进制数据
    let replyBytes: Uint8Array = TextCodec.encodeToUint8Array(rawData);
    reply.writeInt(replyBytes.length);
    reply.writeRawDataBuffer(replyBytes.buffer, replyBytes.length);
  }

  readRawData(reply: rpc.MessageSequence): string {
    // 读取二进制数据
    let inputLength: number = reply.readInt();
    let inputBytes: ArrayBuffer = reply.readRawDataBuffer(inputLength);
    return TextCodec.decodeToString(new Uint8Array(inputBytes));
  }
}