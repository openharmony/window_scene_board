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
import type { IService } from '@ohos/componenthelper';
import { CloneCloudRequestMethod,
  CloneCloudServiceResponse } from '@ohos/launchercommon/src/main/ets/constants/DesktopServiceConstant';
import { IExecutor } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { RestoreLauncherData } from '@ohos/launchercommon/src/main/ets/service/impl/RestoreLauncherData';
import { CancelRestoreLauncherData } from './CancelRestoreLauncherData';

const TAG: string = 'CloneCloudService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 克隆云备份业务服务
 *
 * @since 2024-10-15
 */
export class CloneCloudService implements IService {
  private static readonly executorMap: Map<string, () => IExecutor> = new Map<string, () => IExecutor>([
    [CloneCloudRequestMethod.RESTORE_LAUNCHER_DATA, (): IExecutor => new RestoreLauncherData()],
    [CloneCloudRequestMethod.CANCEL_RESTORE_LAUNCHER_DATA, (): IExecutor => new CancelRestoreLauncherData()]
  ]);

  async onCall(json: string): Promise<string> {
    let msg: CallMessage | null = null;
    try {
      msg = JSON.parse(json) as CallMessage;
    } catch (error) {
      log.showError('CloneCloudService json error');
    }
    if (!msg) {
      return '';
    }
    const method: string = msg?.method;
    log.showInfo(`onCall method = ${method}`);
    if (!method) {
      log.showWarn('onCall invalid method');
      return CloneCloudServiceResponse.INVALID_METHOD_ERROR;
    }

    const executor = CloneCloudService.executorMap.get(method);
    if (!executor) {
      log.showWarn(`onCall unknown method = ${method}`);
      return CloneCloudServiceResponse.UNKNOWN_METHOD_ERROR;
    }
    return executor()?.execute(msg?.extra);
  }

  isSupportSegments(): boolean {
    return false;
  }
}

/**
 * 请求消息
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