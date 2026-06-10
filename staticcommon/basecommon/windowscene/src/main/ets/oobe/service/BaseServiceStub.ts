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
import { Want } from '@kit.AbilityKit';
import { LogHelper, LogDomain, CheckEmptyUtils } from '@ohos/basicutils';

const TAG = 'BaseServiceStub';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 服务接口定义
 */
export interface IService {
  /**
   * 服务接口
   * @param json 客户端请求消息json
   * @param remoteObject 客户端请求remoteObject
   * @returns 服务端返回消息json
   */
  onCall(json: string, remoteObject?: rpc.IRemoteObject | null): Promise<string>;

  /**
   * 断开连接业务
   */
  onDisconnect?(action: string): void;
}

/**
 * 执行接口定义
 */
export interface IExecutor {
  /**
   * 接口执行器
   * @param extra 接口参数
   * @param remoteObject 远端对象
   * @returns 接口执行返回结果
   */
  execute(extra?: object, remoteObject?: rpc.IRemoteObject | null): Promise<string>;
}

export interface CallMessage {
  /**
   * 方法名
   */
  method: string;

  /**
   * 接口参数
   */
  extra?: object;
}

/**
 * 响应消息
 */
export enum Response {
  INVALID_METHOD = 'invalid method',
  UNKNOWN_METHOD = 'unknown method',
}

/**
 * 跨进程服务RPC通信抽象
 */
export abstract class BaseServiceStub extends rpc.RemoteObject {
  private readonly serviceMap: Map<number, () => IService>;
  constructor(des: string) {
    super(des);
    this.serviceMap = this.initServiceMap();
  }

  async onRemoteMessageRequest(
    code: number,
    data: rpc.MessageSequence,
    reply: rpc.MessageSequence,
    option: rpc.MessageOption
  ): Promise<boolean> {
    const service = this.serviceMap.get(code);
    if (!service) {
      log.showWarn(`onRemoteMessageRequest invalid request code = ${code}`);
      return false;
    }
    log.showInfo('onRemoteMessageRequest called code = %{public}d', code);
    if (data === null || data === undefined || reply === null || reply === undefined) {
      log.showError('onRemoteMessageRequest param error');
      return false;
    }
    let msgJson = data.readString();
    return service()?.onCall(msgJson, this.getRemoteObject(data)).then(result => {
      log.showInfo(`onRemoteMessageRequest ret = ${result}`);
      return this.writeStringInNormal(reply, result ?? '');
    }).catch((err: Error) => {
      log.showError(`onRemoteMessageRequest occurs err name = ${err.name}, msg = ${err.message}`);
      return false;
    });
  }

  /**
   * 获取服务映射map
   * @returns serviceMap
   */
  public getServiceMap(): Map<number, () => IService> {
    return this.serviceMap;
  }

  /**
   * 服务标记
   * 子类实现
   * @returns 服务标记
   */
  protected abstract getTag(): string;

  /**
   * 初始化请求码映射服务接口
   * 子类实现
   */
  protected abstract initServiceMap(): Map<number, () => IService>;

  /**
   * 非分段场景下写数据
   * @param data 待发送给对端的MessageSequence
   * @param result 待发送的字符串
   * @returns 写数据是否成功
   */
  protected writeStringInNormal(data: rpc.MessageSequence, result: string): boolean {
    if (CheckEmptyUtils.isEmpty(data) || CheckEmptyUtils.checkStrIsEmpty(result)) {
      log.showError('writeStringInNormal params error');
      return false;
    }
    data.writeString(result);
    return true;
  }

  /**
   * 获取remoteObject
   * @param data client发送的数据
   * @returns remoteObject
   */
  protected getRemoteObject(data: rpc.MessageSequence): rpc.IRemoteObject | null {
    if (CheckEmptyUtils.isEmpty(data)) {
      log.showError('getRemoteObject params error');
      return null;
    }
    try {
      return data.readRemoteObject();
    } catch (e) {
      return null;
    }
  }
}