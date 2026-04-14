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

import type { IExecutor } from '@ohos/launchercommon';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { IService } from '@ohos/componenthelper';

const TAG: string = 'GlobalSearchLocationService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 请求方法
 *
 */
export const enum RequestMethod {
  /**
   * 开始全局搜索
   */
  BEGIN_GLOBAL_SEARCH = 'beginGlobalSearch',
}

/**
 * 响应消息
 */
export class GSResponse {
  public static readonly success: string = 'OK';

  public static readonly fail: string = 'fail';

  public static readonly invalidMethodError: string = 'invalid method';

  public static readonly unknownMethodError: string = 'unknown method';
}

/**
 * 导航条对外提供的服务
 *
 */
export class GlobalSearchLocationService implements IService {
  private static readonly executorMap: Map<string, () => IExecutor> = new Map<string, () => IExecutor>([
  ]);

  async onCall(json: string): Promise<string> {
    let msg: CallMessage | undefined = undefined;
    try {
      msg = JSON.parse(json) as CallMessage;
    } catch (error) {
      log.error(`json parse error: ${error.code}: ${error.message}`);
    }
    if (!msg || !msg.method) {
      log.showWarn('onCall invalid method');
      return GSResponse.invalidMethodError;
    }
    const method: string = msg.method;
    log.showInfo(`onCall method = ${method}`);
    const executor = GlobalSearchLocationService.executorMap.get(method);
    if (!executor) {
      log.showWarn(`onCall unknown method = ${method}`);
      return GSResponse.unknownMethodError;
    }
    return executor()?.execute(msg.extra);
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