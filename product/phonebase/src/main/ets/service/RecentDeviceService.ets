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
import type { IExecutor } from '@ohos/launchercommon';
import { ClearRecentCards } from './impl/ClearRecentCards';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { Response } from '@ohos/launchercommon/src/main/ets/constants/Response';

const TAG: string = 'ClearRecentCards';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

/**
 * 请求方法
 */
export const enum RequestMethod {
  /**
   * 多任务清除任务卡片
   */
  CLEAR_RECENT_CARDS = 'ClearRecentCards',
}

export class RecentDeviceService implements IService {
  private static readonly executorMap: Map<string, () => IExecutor> = new Map<string, () => IExecutor>([
    [RequestMethod.CLEAR_RECENT_CARDS, (): IExecutor => new ClearRecentCards()],
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
    const executor = RecentDeviceService.executorMap.get(method);
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