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
import { AigcConstant } from '../../AigcConstant';
import { Log } from '../Log';
import IIdlAigcExtServiceCallback, { onEventChangeCallback } from './IIdlAigcExtServiceCallback';

const TAG: string = '[AigcService]IdlAigcExtServiceCallbackProxy';

export default class IdlAigcExtServiceCallbackProxy implements IIdlAigcExtServiceCallback {
  private static readonly COMMAND_ON_EVENT_CHANGE = 1;
  private proxy: rpc.IRemoteObject;

  constructor(proxy: rpc.IRemoteObject) {
    this.proxy = proxy;
  }

  onEventChange(statusCode: number, errCode: number, themeId: string, callback: onEventChangeCallback): void {
    // Log.info(TAG, `onEventChange called stateCode: ${statusCode}, errCode: ${errCode}, themeId: ${themeId}`);
    let option = new rpc.MessageOption();
    let dataSequence = rpc.MessageSequence.create();
    let replySequence = rpc.MessageSequence.create();
    dataSequence.writeInterfaceToken(AigcConstant.INTERFACE_TOKEN);
    dataSequence.writeInt(statusCode);
    dataSequence.writeInt(errCode);
    dataSequence.writeString(themeId);
    this.proxy.sendMessageRequest(IdlAigcExtServiceCallbackProxy.COMMAND_ON_EVENT_CHANGE, dataSequence,
      replySequence, option).then((result: rpc.RequestResult) => {
      if (result.errCode === 0) {
        let errCodeVar = result.reply.readInt();
        const data = result.reply.readString();
        callback(errCodeVar, data);
      } else {
        Log.error(TAG, `sendMessageRequest failed, errCode: ${result.errCode}`);
      }
    }).catch((e: Error) => {
      Log.error(TAG, `sendMessageRequest failed, message: ${e.message}`);
    }).finally(() => {
      dataSequence.reclaim();
      replySequence.reclaim();
    });
  }
}