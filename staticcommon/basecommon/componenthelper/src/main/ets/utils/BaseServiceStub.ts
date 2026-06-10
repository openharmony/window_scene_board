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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BaseServiceStubUtils } from './BaseServiceStubUtils';

const TAG = 'BaseServiceStub';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 服务接口定义
 *
 * @since 2023-08-11
 */
export interface IService {
  /**
   * 服务接口
   *
   * @param json 客户端请求消息json
   * @param remoteObject 客户端请求remoteObject
   * @returns 服务端返回消息json
   */
  onCall(json: string, remoteObject?: rpc.IRemoteObject | null): Promise<string>;

  /**
   * 是否支持分段读写
   *
   * @returns 默认false
   */
  isSupportSegments(): boolean;

  /**
   * 断开连接业务
   */
  onDisConnect?(action: string): void;
}

export interface IRequestService {
  /**
   * 响应onRequest
   * @param want
   */
  onRequest(want: Want): void;
}

/**
 * 跨进程服务RPC通信抽象
 *
 * @since 2023-08-11
 */
export abstract class BaseServiceStub extends rpc.RemoteObject {

  private readonly serviceMap: Map<number, () => IService>;

  private static readonly WRITE_RAW_DATA_CODE = 8;

  private static readonly CLONE_CLOUD_RAW_DATA = 9;

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
    const isSupportSegments = service()?.isSupportSegments();
    log.showInfo('onRemoteMessageRequest called code = %{public}d, isSupportSegments = %{public}s', code, isSupportSegments);
    if (data === null || data === undefined || reply === null || reply === undefined) {
      log.showError('onRemoteMessageRequest param error');
      return false;
    }
    let msgJson = '';
    if (code === BaseServiceStub.CLONE_CLOUD_RAW_DATA) {
      const size: number = data.readInt();
      let buffer: ArrayBuffer = data.readRawDataBuffer(size);
      log.showDebug(`onRemoteMessageRequest restoreLauncherData size：${size},byteLength：${buffer.byteLength}`);
      msgJson = BaseServiceStubUtils.parseArrayBufferToStr(buffer);
    } else {
      msgJson = isSupportSegments ? BaseServiceStubUtils.getRemoteString(data) : data.readString();
    }
    log.showDebug(`onRemoteMessageRequest msg = ${msgJson}`);
    return service()?.onCall(msgJson, BaseServiceStubUtils.getRemoteObject(data)).then(result => {
      log.showDebug(`onRemoteMessageRequest ret = ${result}`);
      if (code === BaseServiceStub.WRITE_RAW_DATA_CODE) {
        return BaseServiceStubUtils.writeRawDataBuffer(reply, result ?? '');
      }
      return isSupportSegments ? BaseServiceStubUtils.writeStringInSegments(reply, result ?? '') :
        BaseServiceStubUtils.writeStringInNormal(reply, result ?? '');
    }).catch((err: Error) => {
      log.showError(`onRemoteMessageRequest occurs err name = ${err.name}, msg = ${err.message}`);
      return false;
    });
  }

  /**
   * getServiceMap
   *
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
}