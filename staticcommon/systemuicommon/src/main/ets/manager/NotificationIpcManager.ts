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
import { BusinessError } from '@kit.BasicServicesKit';
import { common, Want } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'NotificationIpcManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class NotificationIpcManager {
  private context?: common.UIExtensionContext | common.ServiceExtensionContext;
  private requestWant?: Want;
  private remotePromise?: Promise<rpc.IRemoteObject>;
  private connectionId?: number;

  constructor(context: common.UIExtensionContext | common.ServiceExtensionContext, requestWant: Want) {
    this.context = context;
    this.requestWant = requestWant;
  }

  /**
   * 发送请求
   */
  public async send(code: number, data: rpc.MessageSequence): Promise<void> {
    try {
      if (!this.remotePromise) {
        this.remotePromise = this.connect();
      }
      const remote = await this.remotePromise;

      const option = new rpc.MessageOption();
      const reply = rpc.MessageSequence.create();
      await remote?.sendMessageRequest(code, data, reply, option)
        .then(result => {
          log.showWarn(`send message request result ${result.code}, error ${result.errCode}`);
        })
        .catch((err: BusinessError) => {
          log.error('send request error', err);
        })
        .finally(() => {
          // 释放MessageSequence创建的内存
          reply.reclaim();
        });
    } catch (err) {
      log.error('send request fail', err);
    }
  }

  /**
   * 建立连接
   */
  private async connect(): Promise<rpc.IRemoteObject> {
    return new Promise((resolve, reject) => {
      if (!this.context) {
        log.showError('the context is null');
        reject('the context is null');
        return;
      }

      try {
        this.connectionId = this.context.connectServiceExtensionAbility(this.requestWant, {
          onConnect: (elementName, remote) => {
            log.showInfo(`onConnect, elementName ${elementName.bundleName}`);
            resolve(remote);
          },
          onDisconnect: (elementName) => {
            log.showWarn(`onDisconnect, elementName ${elementName.bundleName}`);
            this.remotePromise = undefined;
            reject('disconnect');
          },
          onFailed: (code) => {
            log.showError(`onFailed, code ${code}`);
            this.remotePromise = undefined;
            reject(`connect failed, code ${code}`);
          }
        });
        log.showInfo(`connect end, connectionId: ${this.connectionId}`);
        if (this.connectionId === undefined) {
          reject('the connection id is undefined');
        }
      } catch (err) {
        log.error('connect error', err);
        reject(`connect error, code ${err?.code}, message ${err?.message}`);
      }
    });
  }

  /**
   * 断开连接
   */
  public async disconnect(): Promise<void> {
    log.showInfo(`disconnectServiceExtensionAbility, connectId = ${this.connectionId}`);
    if (!this.context || !this.remotePromise) {
      log.showError('the context is null or already disconnect');
      return;
    }
    try {
      await this.remotePromise;
      this.context.disconnectServiceExtensionAbility(this.connectionId);
      this.remotePromise = undefined;
    } catch (err) {
      log.error('disconnect error', err);
    }
  }
}
