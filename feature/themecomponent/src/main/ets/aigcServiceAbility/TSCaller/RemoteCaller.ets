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
import { common, Want } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';
import hilog from '@ohos.hilog';

const TAG: string = '[AigcService]RemoteCaller';
const LOG_DOMAIN: number = 0x00000;
const CMD_REMOTE_METHOD: number = 0;
const CODE_SUCCESS = 110000;
const CODE_ERR_INNER_IDL: number = 110004;
const CODE_ERR_DISCONNECT: number = 110006;
// 任意类型
type AnyType = string | boolean | number | bigint | null | object | undefined;
type TsContext = common.UIAbilityContext | common.ServiceExtensionContext;

namespace TextCodec {
  const textEncoder: util.TextEncoder = new util.TextEncoder();
  const textDecoder: util.TextDecoder = util.TextDecoder.create();

  export function encodeToUint8Array(str: string): Uint8Array {
    let result = new Uint8Array();
    if (!str) {
      return result;
    }
    try {
      result = textEncoder.encodeInto(str);
    } catch (error) {
      hilog.debug(LOG_DOMAIN, TAG, 'stringToUint8Array fail');
    }
    return result;
  }

  export function decodeToString(bytes: Uint8Array): string {
    let result = '';
    if (!bytes || bytes.length === 0) {
      return result;
    }
    try {
      result = textDecoder.decodeWithStream(bytes);
    } catch (error) {
      hilog.error(LOG_DOMAIN, TAG, 'uint8ArrayToString fail');
    }
    return result;
  }
}

namespace RpcCodec {
  export function toRpc<T>(data: T, rpcMessage?: rpc.MessageSequence): rpc.MessageSequence | undefined {
    let reply: rpc.MessageSequence = rpcMessage ?? new rpc.MessageSequence();
    try {
      writeRawData(JSON.stringify(data), reply);
      return reply;
    } catch (error) {
      hilog.error(LOG_DOMAIN, TAG, `toRpc error encoding RPC message: ${error}`);
      reply.reclaim();
      return undefined;
    }
  }

  export function fromRpc<T>(rpcMessage: rpc.MessageSequence): T | undefined {
    try {
      let data: T = JSON.parse(readRawData(rpcMessage)) as T;
      return data;
    } catch (error) {
      hilog.error(LOG_DOMAIN, TAG, `fromRpc error parsing RPC message: ${error}`);
      return undefined;
    }
  }

  function writeRawData(rawData: string, reply: rpc.MessageSequence): void {
    // 写入二进制数据
    let replyBytes: Uint8Array = TextCodec.encodeToUint8Array(rawData);
    hilog.debug(LOG_DOMAIN, TAG, `rawData：${rawData}`);
    reply.writeInt(replyBytes.length);
    reply.writeRawData([...replyBytes], replyBytes.length);
  }

  function readRawData(reply: rpc.MessageSequence): string {
    // 读取二进制数据
    let inputLength: number = reply.readInt();
    let inputBytes: number[] = reply.readRawData(inputLength);
    return TextCodec.decodeToString(new Uint8Array(inputBytes));
  }

  export function decodeRsp<T>(value: string | undefined): T | undefined {
    try {
      return value !== undefined ? JSON.parse(value) as T : undefined;
    } catch (error) {
      hilog.error(LOG_DOMAIN, TAG, `decodeRsp error parsing RPC message: ${error}`);
      return undefined;
    }
  }
}

interface RemoteReq {
  /**
   * 接口名
   */
  method: string;

  /**
   * 业务请求参数
   */
  args?: AnyType[];
}

class RemoteRsp {
  /**
   * IDL内部错误响应
   */
  public static readonly ERR_INNER_IDL = new RemoteRsp(CODE_ERR_INNER_IDL, 'Inner error occurred');
  /**
   * 结果码
   */
  public code: number;
  /**
   * 描述
   */
  public desc: string;
  /**
   * 业务响应数据
   */
  public value?: string;

  constructor(code: number, desc: string, value?: string) {
    this.code = code;
    this.desc = desc;
    this.value = value;
  }
}

class RemoteProxy {
  private readonly proxy: rpc.IRemoteObject;

  constructor(proxy: rpc.IRemoteObject) {
    this.proxy = proxy;
  }

  public async request(req: RemoteReq): Promise<RemoteRsp> {
    const data: rpc.MessageSequence | undefined = RpcCodec.toRpc(req);
    if (data === undefined) {
      return RemoteRsp.ERR_INNER_IDL;
    }
    const reply: rpc.MessageSequence = new rpc.MessageSequence();
    try {
      let result: rpc.RequestResult = await this.proxy.sendMessageRequest(CMD_REMOTE_METHOD, data,
        reply, new rpc.MessageOption());
      const RESULT_SUCCESS: number = 0;
      if (result?.errCode !== RESULT_SUCCESS) {
        return RemoteRsp.ERR_INNER_IDL;
      }
      return RpcCodec.fromRpc(result.reply) ?? RemoteRsp.ERR_INNER_IDL;
    } catch (err) {
      hilog.error(LOG_DOMAIN, TAG, `request[${req.method}] catch exception: ${err?.code} - ${err?.message}`);
    } finally {
      data.reclaim();
      reply.reclaim();
    }
    return RemoteRsp.ERR_INNER_IDL;
  }
}


// 远端调用器
export class RemoteCaller {
  private readonly serviceWant: Want;
  private readonly context: TsContext;

  constructor(context: TsContext, serviceWant: Want) {
    this.context = context;
    this.serviceWant = serviceWant;
  }

  public async request<T>(method: string, ...args: AnyType[]): Promise<T> {
    const req: RemoteReq = {
      method: method,
      args: args
    };
    return this.connectCaller((remote) => new RemoteProxy(remote).request(req));
  }

  private connectCaller<T>(requestCallable: (remoteObj: rpc.IRemoteObject) => Promise<RemoteRsp>): Promise<T> {
    let connectionId: number;
    return new Promise<T>((resolve, reject) => {
      let connectOpt: common.ConnectOptions = {
        async onConnect(elementName, remote: rpc.IRemoteObject) {
          const remoteRsp: RemoteRsp = await requestCallable(remote);
          if (!remoteRsp) {
            reject(CODE_ERR_INNER_IDL);
            return;
          }
          if (remoteRsp.code !== CODE_SUCCESS) {
            reject(remoteRsp.code);
            return;
          }
          resolve(RpcCodec.decodeRsp(remoteRsp.value) as T);

        },
        onDisconnect: (elementName) => {
          hilog.info(LOG_DOMAIN, TAG, `connectCallerRpc(), onDisconnect. `);
          reject(CODE_ERR_DISCONNECT);
        },
        onFailed: (code: number) => {
          hilog.warn(LOG_DOMAIN, TAG, `connectCallerRpc(), onFailed remote connection:`, code);
          reject(code);
        },
      };
      try {
        connectionId = this.context?.connectServiceExtensionAbility(this.serviceWant, connectOpt);
      } catch (err) {
        if (err.code) {
          hilog.error(LOG_DOMAIN, TAG, 'connectCallerRpc catch exception.', err);
        }
      }
    }).finally(() => {
      this.disconnect(connectionId);
    });
  }

  private disconnect(connectId: number): void {
    try {
      this.context?.disconnectServiceExtensionAbility(connectId);
      hilog.debug(LOG_DOMAIN, TAG, `disconnect: ${connectId}`);
    } catch (err) {
      if (err.code) {
        hilog.error(LOG_DOMAIN, TAG, 'disconnectThemeService failed:', err);
      }
    }
  }
}