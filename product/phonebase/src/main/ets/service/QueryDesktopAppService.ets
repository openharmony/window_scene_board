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

import {IService } from '@ohos/componenthelper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import type { IExecutor } from '@ohos/launchercommon';
import { QueryDesktopApp } from './impl/QueryDesktopApp';
import { GetAppDisplayInfos } from './impl/GetAppDisplayInfos';
import { Response } from '@ohos/launchercommon/src/main/ets/constants/Response';

const TAG: string = 'QueryDesktopAppService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

/**
 * 请求方法
 */
export const enum RequestMethod {
  /**
   * 查询任务清单
   */
  QUERY_DESKTOP_APPS = 'queryDesktopApps',
  GET_APP_DISPLAY_INFOS = 'getAppDisplayInfos',
}

/**
 * 响应消息
 */
export class QueryAppResponse {
  public static readonly success = 'OK';

  public static readonly fail = 'fail';

  public static readonly invalidMethodError = 'invalid method';

  public static readonly unknownMethodError = 'unknown method';
}

export class QueryDesktopAppService implements IService {
  private static readonly executorMap: Map<string, () => IExecutor> = new Map<string, () => IExecutor>([
    [RequestMethod.QUERY_DESKTOP_APPS, (): IExecutor => new QueryDesktopApp()],
    [RequestMethod.GET_APP_DISPLAY_INFOS, (): IExecutor => new GetAppDisplayInfos()],
  ]);

  async onCall(json: string): Promise<string> {
    let msg: CallMessage | undefined;
    try {
      msg = JSON.parse(json) as CallMessage;
    } catch (err) {
      log.error('onCall parse message failed, ', err);
    }
    if (!msg || !msg.method) {
      log.showWarn('onCall invalid method');
      return Response.INVALID_METHOD_ERROR;
    }
    const method: string = msg.method;
    log.showInfo(`onCall method = ${method}`);
    const executor = QueryDesktopAppService.executorMap.get(method);
    if (!executor) {
      log.showWarn(`onCall unknown method = ${method}`);
      return Response.UNKNOWN_METHOD_ERROR;
    }
    return executor()?.execute(msg?.extra);
  }

  isSupportSegments(): boolean {
    return false;
  }
}

/**
 * 请求销毁进程，清空卡片
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