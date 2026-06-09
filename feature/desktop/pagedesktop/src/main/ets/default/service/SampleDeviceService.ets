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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { IService } from '@ohos/componenthelper';
import { IExecutor } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { RestoringDesktopLayout } from './impl/RestoringDesktopLayout';
import { QueryAutoAlignStatus, SetAutoAlignStatus } from './impl/QueryAutoAlignStatus';
import { Response } from '@ohos/launchercommon/src/main/ets/constants/Response';

const TAG: string = 'SampleDeviceService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export const enum RequestMethod {
  RESTORING_DESKTOP_LAYOUT = 'restoringDesktopLayout',
  QUERY_AUTO_ALIGN_STATUS = 'queryAutoAlignStatus',
  SET_AUTO_ALIGN_STATUS = 'setAutoAlignStatus'
}

/**
 * 样机演示对外提供服务
 *
 * @since 2023-04-11
 */
export class SampleDeviceService implements IService {
  private static mRestoringDesktopLayout: RestoringDesktopLayout;

  private static readonly executorMap: Map<string, () => IExecutor> = new Map<string, () => IExecutor>([
    [RequestMethod.RESTORING_DESKTOP_LAYOUT, (): IExecutor => this.mRestoringDesktopLayout],
    [RequestMethod.QUERY_AUTO_ALIGN_STATUS, (): IExecutor => new QueryAutoAlignStatus()],
    [RequestMethod.SET_AUTO_ALIGN_STATUS, (): IExecutor => new SetAutoAlignStatus()]
  ]);

  constructor(mRestoringDesktopLayout: RestoringDesktopLayout) {
    SampleDeviceService.mRestoringDesktopLayout = mRestoringDesktopLayout;
  }

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
    const executor = SampleDeviceService.executorMap.get(method);
    if (!executor) {
      log.showWarn(`onCall unknown method = ${method}`);
      return Response.UNKNOWN_METHOD_ERROR;
    }
    return executor().execute(msg?.extra);
  }

  isSupportSegments(): boolean {
    return false;
  }
}

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