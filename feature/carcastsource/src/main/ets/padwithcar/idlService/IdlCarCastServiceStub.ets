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

import rpc from '@ohos.rpc';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import IIdlCarCastService, { resultStringCallback } from './IIdlCarCastService';

const TAG: string = 'IdlCarCastServiceStub';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HICAR, TAG);
const PROJECTION_SERVICE_TOKEN_NAME: string = 'PROJECTION_SERVICE_TOKEN_NAME';

/**
 * Response
 *
 * @since 2025-03-12
 */
export class Response {
  public static readonly SUCCESS: number = 0;
  public static readonly FAIL: number = -1;
  public static readonly ERR_NO_PERMISSION: number = -2;
  public static readonly DEFAULT_RET: string = '';
}

/**
 * IdlCarCastServiceStub
 *
 * @since 2025-03-12
 */
export default class IdlCarCastServiceStub extends rpc.RemoteObject implements IIdlCarCastService {
  public static readonly COMMAND_SEND_SCENE_BOARD_MSG: number = 1;

  constructor(des: string) {
    super(des);
  }

  /**
   * 接收到出行助手发送过来的消息
   *
   * @param code 消息码
   * @param data 数据
   * @param reply reply
   * @param option option
   * @returns boolean
   */
  async onRemoteMessageRequest(code: number, data: rpc.MessageSequence, reply: rpc.MessageSequence,
    option: rpc.MessageOption): Promise<boolean> {
    if (CheckEmptyUtils.isEmpty(data)) {
      log.showWarn(`onRemoteMessageRequest: data is empty`);
      return false;
    }
    const token = data.readInterfaceToken();
    if (token !== PROJECTION_SERVICE_TOKEN_NAME) {
      log.showWarn(`onRemoteMessageRequest: Inconsistent tokens`);
      return false;
    }
    log.showInfo(`onRemoteMessageRequest: code = ${code}`);
    if (code === IdlCarCastServiceStub.COMMAND_SEND_SCENE_BOARD_MSG) {
      this.handleRecvMsg(data, reply);
      return true;
    }
    return false;
  }

  private async handleRecvMsg(data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      let code: number = data.readInt();
      let bundleName: string = data.readString();
      this.recvMessage(code, bundleName, (errCode, returnValue) => {
        log.showInfo(`handleRecvMsg: errCode: ${errCode}, returnValue: ${returnValue}`);
        reply.writeInt(errCode);
        if (errCode === 0) {
          reply.writeString(returnValue);
        }
        resolve();
      });
    });
  }

  recvMessage(code: number, params: string, callback: resultStringCallback): void {
  }
}