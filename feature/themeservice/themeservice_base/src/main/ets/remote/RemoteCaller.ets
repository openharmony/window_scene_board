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
import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import rpc from '@ohos.rpc';
import { TsLog } from '../log/TsLog';
import { AnyType, TsContext } from '../utils/Types';
import { RemoteCode } from './RemoteCode';
import { RemoteReq } from './RemoteReq';
import { RemoteRsp } from './RemoteRsp';
import { RpcCodec } from './RpcCodec';

class RemoteProxy {
  private readonly proxy: rpc.IRemoteObject;

  constructor(proxy: rpc.IRemoteObject) {
    this.proxy = proxy;
  }

  public async sendMessageRequest<T>(cmd: number,
    reqEncoder: (request: rpc.MessageSequence) => void,
    replyDecoder: (reply: rpc.MessageSequence) => T): Promise<T | undefined> {
    const data: rpc.MessageSequence = rpc.MessageSequence.create();
    const reply: rpc.MessageSequence = rpc.MessageSequence.create();
    try {
      reqEncoder(data);
      let result: rpc.RequestResult =
        await this.proxy.sendMessageRequest(cmd, data, reply, new rpc.MessageOption());
      const RESULT_SUCCESS: number = 0;
      if (result?.errCode !== RESULT_SUCCESS) {
        TsLog.error(TAG, `request[${cmd}] fail`);
        return undefined;
      }
      return replyDecoder ? replyDecoder(result.reply) : undefined;
    } catch (err) {
      TsLog.error(TAG, `request[${cmd}] catch exception.`, err);
    } finally {
      data.reclaim();
      reply.reclaim();
    }
    return undefined;
  }
}

const TAG: string = 'RemoteCaller';

/**
 * RemoteCaller类，用于处理远程调用
 */
export class RemoteCaller {
  private readonly serviceWant: Want;
  private readonly context: TsContext;

  constructor(context: TsContext, serviceWant: Want) {
    this.context = context;
    this.serviceWant = serviceWant;
  }


  /**
   * 发送异步请求（Ts内部UT使用）
   * @param version 跨端接口版本号
   * @param method 请求方法
   * @param args 请求参数
   * @return 返回一个Promise对象，该对象在请求成功时resolve，失败时reject
   */
  public async request<T>(version: number, method: string, ...args: AnyType[]): Promise<Nullable<T>> {
    return this.request2<T>(version, method, RpcCodec.decodeRsp, ...args);
  }

  /**
   * 发送请求并获取响应结果（Ts内部UT使用）
   * @param version 跨端接口版本号
   * @param method 请求方法名
   * @param rspContentDecoder 响应内容解码器
   * @param args 请求参数
   * @return 返回解码后的响应结果
   */
  public async request2<T>(version: number, method: string,
    rspContentDecoder: (value: string | undefined) => Nullable<T>,
    ...args: AnyType[]): Promise<Nullable<T>> {
    return this.sendMessageRequest<RemoteRsp>(version,
      req => RpcCodec.toRpc<RemoteReq>(version, { method: method, args: args }, req), // 请求消息编码
      reply => RpcCodec.fromRpc<RemoteRsp>(version, reply))// 响应消息解码
      .then(remoteRsp => {
        // 响应内容解码
        if (remoteRsp?.code !== RemoteCode.SUCCESS) {
          const error: BusinessError<string> = {
            name: `remote ${method} Error`,
            message: remoteRsp?.desc ?? '',
            code: remoteRsp?.code ?? RemoteCode.ERR_UNKNOWN
          }
          throw error as Error;
        }
        return rspContentDecoder(remoteRsp?.value);
      });
  }

  /**
   * 发送消息请求
   * @param cmd 命令编号
   * @param reqEncoder 请求编码器，用于编码请求消息
   * @param replyDecoder 响应解码器，用于解码响应消息
   * @return 返回一个Promise，如果请求成功，Promise将会resolve，否则reject
   */
  public async sendMessageRequest<T>(cmd: number, reqEncoder: (req: rpc.MessageSequence) => void,
    replyDecoder: (reply: rpc.MessageSequence) => Nullable<T>): Promise<Nullable<T>> {
    return this.connectSendMessage(remote => new RemoteProxy(remote).sendMessageRequest(cmd, reqEncoder, replyDecoder));
  }

  private async connectSendMessage<T>(sendMessage: (remoteObj: rpc.IRemoteObject) => Promise<Nullable<T>>): Promise<T> {
    let connectionId: number;
    const context = this.context;
    return new Promise<T>((resolve, reject) => {
      let connectOpt: common.ConnectOptions = {
        async onConnect(_elementName, remote: rpc.IRemoteObject) {
          try {
            let result: T | undefined = await sendMessage(remote);
            if (result === undefined) {
              reject(RemoteCaller.getRejectError(RemoteCode.ERR_INNER_IDL, `The IDL result invalid.`));
              return;
            }
            resolve(result);
          } catch (err) {
            TsLog.error(TAG, `connectService sendMessage catch exception.`, err);
            reject(err);
          } finally {
            RemoteCaller.disconnect(connectionId, context);
          }
        },
        onDisconnect: () => {
          TsLog.info(TAG, `connectCallerRpc(), onDisconnect. `);
          reject(RemoteCaller.getRejectError(RemoteCode.ERR_DISCONNECT, `IDL disconnect`));
        },
        onFailed: (code: number) => {
          TsLog.warning(TAG, `connectCallerRpc(), onFailed remote connection:`, code);
          reject(RemoteCaller.getRejectError(code, `The IDL connection fails, and error code ${code} is returned.`));
        },
      };
      try {
        connectionId = this.context?.connectServiceExtensionAbility(this.serviceWant, connectOpt);
      } catch (err) {
        if (err.code) {
          TsLog.error(TAG, 'connectCallerRpc catch exception.', err);
        }
      }
    });
  }

  private static getRejectError(code: number, message: string): Error {
    return { code: code, message: message } as BusinessError;
  }

  private static disconnect(connectId: number, context: TsContext): void {
    try {
      context?.disconnectServiceExtensionAbility(connectId);
      TsLog.debug(TAG, `disconnect: ${connectId}`);
    } catch (err) {
      if (err.code) {
        TsLog.error(TAG, 'disconnectThemeService failed:', err);
      }
    }
  }
}
