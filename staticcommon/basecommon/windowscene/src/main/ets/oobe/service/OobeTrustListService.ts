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

import { LogHelper, LogDomain } from '@ohos/basicutils';
import type { IService, IExecutor } from './BaseServiceStub';
import { Response, CallMessage } from './BaseServiceStub';
import { AddOobeTrustList } from './impl/AddOobeTrustList';

const TAG: string = 'OobeTrustListService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export const enum RequestMethod {
  /**
   * 添加OOBE支持拉起应用白名单
   */
  ADD_OOBE_TRUST_LIST = 'addOobeTrustList',
}

/**
 * 开机向导信任列表业务服务
 */
export class OobeTrustListService implements IService {
  private static readonly executorMap: Map<string, () => IExecutor> = new Map<string, () => IExecutor>([
    [RequestMethod.ADD_OOBE_TRUST_LIST, (): IExecutor => new AddOobeTrustList()],
  ]);

  /**
   * 根据入参查找服务执行器, 执行相关接口函数
   * @param json 客户端请求消息json, CallMessage格式: 接口名及接口参数数据
   * @returns 参数或获取执行器异常返回Response中异常字符串, 正常则返回执行器执行结果
   */
  public async onCall(json: string): Promise<string> {
    let msg: CallMessage | undefined = undefined;
    try {
      const jsonObject: CallMessage = JSON.parse(json);
      if (!this.isCallMessage(jsonObject)) {
        return Response.INVALID_METHOD;
      }
      msg = jsonObject;
    } catch (error) {
      log.warn(`onCall parse message failed, Code: ${error?.code}, msg: ${error?.message}`);
      return Response.INVALID_METHOD;
    }
    if (!msg || !msg.method) {
      log.warn('onCall invalid method');
      return Response.INVALID_METHOD;
    }
    const method: string = msg.method;
    const executor = OobeTrustListService.executorMap.get(method);
    if (!executor) {
      log.warn(`onCall unknown method: ${method}`);
      return Response.UNKNOWN_METHOD;
    }
    return executor().execute(msg?.extra);
  }

  protected isCallMessage(input: CallMessage): boolean {
    return input && typeof input === 'object' && typeof input.method === 'string';
  }
}
