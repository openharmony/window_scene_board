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

import type { IExecutor } from '@ohos/launchercommon';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import type { IService } from '@ohos/componenthelper';

const TAG: string = 'AiBarService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * 响应消息
 */
export class Response {
  public static readonly success = 'OK';
  public static readonly fail = 'fail';
  public static readonly invalidMethodError = 'invalid method';
  public static readonly unknownMethodError = 'unknown method';
}

/**
 * 导航条对外提供的服务
 *
 */
export class AiBarService implements IService {
  private static readonly executorMap: Map<string, () => IExecutor> = new Map<string, () => IExecutor>([
  ]);

  async onCall(json: string): Promise<string> {
    try {
      let msg: CallMessage | undefined;
      try {
        msg = JSON.parse(json) as CallMessage;
      } catch (err) {
        log.error('onCall parse message failed, ', err);
      }
      if (!msg || !msg.method) {
        log.showWarn('onCall invalid method');
        return Response.invalidMethodError;
      }
      const method: string = msg.method;
      log.showInfo(`onCall method = ${method}`);
      if (!method) {
        log.showWarn('onCall invalid method');
        return Response.invalidMethodError;
      }
      const executor = AiBarService.executorMap.get(method);
      if (!executor) {
        log.showWarn(`onCall unknown method = ${method}`);
        return Response.unknownMethodError;
      }
      return executor()?.execute(msg.extra);
    } catch (err) {
      log.showError(`try catch err code:${err?.code} msg:${err?.message}`);
      return Response.unknownMethodError;
    }
  }

  isSupportSegments(): boolean {
    return false;
  }
}

/**
 * 请求消息
 *
 */
export interface CallMessage {
  /**
   * 方法名
   */
  method: string;

  /**
   * 附加参数
   */
  extra: object;
}