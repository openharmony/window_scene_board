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

import type { operateResult } from './IIdlVisionGlassExtService';
import rpc from '@ohos.rpc';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import IIdlVisionGlassExtServiceCallback from './callback/IIdlVisionGlassExtServiceCallback';
import IdlVisionGlassExtServiceCallbackStub from './callback/IdlVisionGlassExtServiceCallbackStub';
import IIdlVisionGlassExtService from './IIdlVisionGlassExtService';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'IdlVisionGlassExtServiceProxy';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

export default class IdlVisionGlassExtServiceProxy implements IIdlVisionGlassExtService {
  private proxy: rpc.IRemoteObject;
  private static readonly COMMAND_REGISTER_CALLBACK = 1;
  private static readonly COMMAND_UNREGISTER_CALLBACK = 2;
  private static readonly COMMAND_SEND_ACTIVE_WANT = 3;
  private static readonly COMMAND_SAVE_IMAGE = 4;
  private static readonly COMMAND_SET_CURSOR_VISIBLE = 5;
  private static readonly COMMAND_SHOW_RIGHT_DIALOG = 6;

  constructor(proxy: rpc.IRemoteObject) {
    this.proxy = proxy;
  }

  register(key: string, cb: IIdlVisionGlassExtServiceCallback, operateResult: operateResult): void {
    let option = new rpc.MessageOption();
    let dataSequence = rpc.MessageSequence.create();
    let replySequence = rpc.MessageSequence.create();
    dataSequence.writeInterfaceToken(this.proxy.getDescriptor());
    dataSequence.writeString(key);
    dataSequence.writeRemoteObject(cb as IdlVisionGlassExtServiceCallbackStub);
    this.proxy.sendMessageRequest(IdlVisionGlassExtServiceProxy.COMMAND_REGISTER_CALLBACK, dataSequence, replySequence,
      option)
      .then((result: rpc.RequestResult) => {
        if (result.errCode === 0) {
          let errCodeVar = result.reply.readInt();
          operateResult(errCodeVar);
        } else {
          log.error(`sendMessageRequest failed, errCode: ${result.errCode}`);
        }
      })
      .catch((error: Error) => {
        log.error(`sendMessageRequest failed, message: ${error.message}`);
      })
      .finally(() => {
        dataSequence.reclaim();
        replySequence.reclaim();
      });
  }

  unRegister(key: string, operateResult: operateResult): void {
    let option = new rpc.MessageOption();
    let dataSequence = rpc.MessageSequence.create();
    let replySequence = rpc.MessageSequence.create();
    dataSequence.writeInterfaceToken(this.proxy.getDescriptor());
    dataSequence.writeString(key);
    this.proxy.sendMessageRequest(IdlVisionGlassExtServiceProxy.COMMAND_UNREGISTER_CALLBACK, dataSequence,
      replySequence,
      option)
      .then((result: rpc.RequestResult) => {
        if (result.errCode === 0) {
          let errCodeVar = result.reply.readInt();
          operateResult(errCodeVar);
        } else {
          log.error(`sendMessageRequest failed, errCode: ${result.errCode}`);
        }
      })
      .catch((error: Error) => {
        log.error(`sendMessageRequest failed, message: ${error.message}`);
      })
      .finally(() => {
        dataSequence.reclaim();
        replySequence.reclaim();
      });
  }

  sendActiveWant(want: string): void {
    const option: rpc.MessageOption = new rpc.MessageOption();
    const data: rpc.MessageSequence = new rpc.MessageSequence();
    data.writeInterfaceToken(this.proxy.getDescriptor());
    const reply: rpc.MessageSequence = new rpc.MessageSequence();
    if (want) {
      data.writeString(want);
    }
    this.proxy.sendMessageRequest(IdlVisionGlassExtServiceProxy.COMMAND_SEND_ACTIVE_WANT, data, reply, option)
      .then((result: rpc.RequestResult) => {
        log.error(`sendActiveWant errCode: ${result.errCode}`);
      })
      .catch((e: Error) => {
        log.error(`sendActiveWant failed, message:${e.message}`);
      })
      .finally(() => {
        data.reclaim();
        reply.reclaim();
      });
  }

  public async saveImage(imageName: string, packImage: ArrayBuffer): Promise<number> {
    log.info(`saveImage start, imageName:${imageName}, packImage len: ${packImage.byteLength}`);
    const option: rpc.MessageOption = new rpc.MessageOption();
    const data: rpc.MessageSequence = new rpc.MessageSequence();
    const reply: rpc.MessageSequence = new rpc.MessageSequence();
    try {
      data.writeInterfaceToken(this.proxy.getDescriptor());
      data.writeString(imageName);
      data.writeInt(packImage.byteLength);
      data.writeRawDataBuffer(packImage, packImage.byteLength);
      const result: rpc.RequestResult =
        await this.proxy.sendMessageRequest(IdlVisionGlassExtServiceProxy.COMMAND_SAVE_IMAGE, data, reply, option);
      if (result.errCode !== 0) {
        log.error('saveImage, sendMessageRequest failed');
        return Promise.reject();
      }
      const code = result.reply.readInt();
      log.info(`saveImage, code:${code}`);
      return code;
    } catch (err) {
      const error = err as BusinessError;
      log.error(`saveImage failed, code:${error.code}, message:${error.message}`);
      return Promise.reject(err);
    } finally {
      data.reclaim();
      reply.reclaim();
    }
  }

  public async changePointerVisible(isVisible: boolean): Promise<void> {
    const option: rpc.MessageOption = new rpc.MessageOption();
    const data: rpc.MessageSequence = new rpc.MessageSequence();
    data.writeInterfaceToken(this.proxy.getDescriptor());
    const reply: rpc.MessageSequence = new rpc.MessageSequence();
    data.writeBoolean(isVisible);
    await this.proxy.sendMessageRequest(IdlVisionGlassExtServiceProxy.COMMAND_SET_CURSOR_VISIBLE, data, reply, option)
      .then((result: rpc.RequestResult) => {
        log.info(`changePointerVisible code: ${result.errCode},isVisible ${isVisible}`);
      })
      .catch((e: Error) => {
        log.error(`changePointerVisible failed, message:${e.message}`);
      })
      .finally(() => {
        data.reclaim();
        reply.reclaim();
      });
  }

  public showRightDialogOnPhone(): void {
    const option: rpc.MessageOption = new rpc.MessageOption();
    const data: rpc.MessageSequence = new rpc.MessageSequence();
    data.writeInterfaceToken(this.proxy.getDescriptor());
    const reply: rpc.MessageSequence = new rpc.MessageSequence();
    this.proxy.sendMessageRequest(IdlVisionGlassExtServiceProxy.COMMAND_SHOW_RIGHT_DIALOG, data, reply, option)
      .then((result: rpc.RequestResult) => {
        log.info(`showRightDialogOnPhone code: ${result.errCode}`);
      })
      .catch((e: Error) => {
        log.error(`showRightDialogOnPhone failed, message:${e.message}`);
      })
      .finally(() => {
        data.reclaim();
        reply.reclaim();
      });
  }
}

/**
 * Message from client
 */
export interface RpcMessage {
  /**
   * request action
   */
  action: string;

  /**
   * extra data
   */
  extra?: object;
}