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

import { SingletonHelper, LogDomain, LogHelper } from '@ohos/basicutils';
import rpc from '@ohos.rpc';

const TAG = 'RpcShutdownPolicy:';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

class RpcShutdownPolicy {
  private isRpcView: boolean = false;
  private rpcClientObj?: rpc.IRemoteObject;

  public getRpcView(): boolean {
    return this.isRpcView;
  }

  public setRpcView(rpcView: boolean): void {
    this.isRpcView = rpcView;
  }

  public getRpcClientObj(): rpc.IRemoteObject | undefined {
    return this.rpcClientObj;
  }

  public setRpcClientObj(rpcObj?: rpc.IRemoteObject): void {
    this.rpcClientObj = rpcObj;
  }

  public rpcShutDownView(type: string): void {
    try {
      // 将没有需要保存的应用的结果返回给rpcClient
      rpcShutdownPolicy.setRpcView(false);
      let rpcClientObject = rpcShutdownPolicy.getRpcClientObj();
      if (rpcClientObject) {
        const codeReplyOuc = 6;
        let data = rpc.MessageSequence.create();
        let reply = rpc.MessageSequence.create();
        let options = new rpc.MessageOption();
        data.writeInterfaceToken(rpcClientObject.getDescriptor());
        data.writeString(`${type}`);
        rpcClientObject.sendMessageRequest(codeReplyOuc, data, reply, options);
        log.showInfo(`send ${type} to rpcClient.`);
        data.reclaim();
        reply.reclaim();
      }
    } catch (error) {
      log.showError(`rpcShutDownView fail, error -> ${error?.code} ${error?.message}`);
    }
    rpcShutdownPolicy.setRpcClientObj();
  }
}

// 单例
export const rpcShutdownPolicy = SingletonHelper.getInstance(RpcShutdownPolicy, TAG);
export default rpcShutdownPolicy;