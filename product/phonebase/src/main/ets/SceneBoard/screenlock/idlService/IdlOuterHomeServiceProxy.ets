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

import IIdlOuterHomeService, { GetScreenOffDelayOfOuterHomeCallback } from './IIdlOuterHomeService';
import rpc from '@ohos.rpc';
import { LogDomain, LogHelper, } from '@ohos/basicutils';

const TAG: string = 'IdlOuterHomeServiceProxy';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const COMMAND_MIRROR_TO_END = 1;
const METHOD_GET_PLAY_TIME = 'getPlayTime';
const RESULT_SUCCESS = 0;
const DEFAULT_DELAY_TIME = 0;
const INTERFACE_TOKEN = 'com.ohos.outerhome.CoverHomeProviderAbility';

export class ParseInfoDataJson {
  public castPlayTime: number = DEFAULT_DELAY_TIME;
}

export default class IdlOuterHomeServiceProxy implements IIdlOuterHomeService {
  private proxy: rpc.IRemoteObject;

  constructor(proxy: rpc.IRemoteObject) {
    this.proxy = proxy;
  }

  /**
   * 查询外屏灭屏动效时间
   *
   * @param callback 回调
   */
  public getScreenOffDelayOfOuterHome(callback: GetScreenOffDelayOfOuterHomeCallback): void {
    let option = new rpc.MessageOption();
    let data = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();
    const jsonString = JSON.stringify({
      method: METHOD_GET_PLAY_TIME, extra: 'null'
    });
    data.writeInterfaceToken(INTERFACE_TOKEN);
    data.writeString(jsonString);
    this.proxy.sendMessageRequest(COMMAND_MIRROR_TO_END, data, reply, option).then((result: rpc.RequestResult) => {
      if (result.errCode === RESULT_SUCCESS) {
        let returnValue = result.reply.readString();
        let parseInfo = JSON.parse(returnValue) as ParseInfoDataJson;
        let screenOffDelay: number = parseInfo?.castPlayTime;
        if (typeof screenOffDelay !== 'number') {
          screenOffDelay = DEFAULT_DELAY_TIME;
        }
        log.showInfo(`getScreenOffDelayOfOuterHome : ${screenOffDelay} ms`);
        callback(RESULT_SUCCESS, screenOffDelay);
      } else {
        log.showError(`getScreenOffDelayOfOuterHome, failed errCode : ${result.errCode}`);
        callback(result.errCode, DEFAULT_DELAY_TIME);
      }
    }).catch((err: Error) => {
      log.showError(`getScreenOffDelayOfOuterHome occurs error : ${err}`);
    }).finally(() => {
      data.reclaim();
      reply.reclaim();
    });
  }
}