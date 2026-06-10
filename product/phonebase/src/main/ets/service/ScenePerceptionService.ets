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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import type { IService } from '@ohos/componenthelper';
import { PerceptionSceneType } from '@ohos/launchercommon/src/main/ets/bean/DockItemInfo';
import { IExecutor, StoreAppNameController } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { Response } from '@ohos/smartdock/src/main/ets/default/common/constants/Response';
import { CarControlNotify } from './CarControlNotify';

const TAG: string = 'ScenePerceptionService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 请求方法
 */
export const enum RequestMethod {
  /**
   *分布式通信
   */
  DISTRIBUTED_COMM = 'distributedComm',

  /**
   * 车控消息传递
   */
  CAR_CONTROL_NOTIFY = 'CarControlNotify',

  /**
   * 门店控制名称显示
   */
  STORE_APP_NAME_CONTROL = 'storeAppNameControl'
}

/**
 * 桌面图标业务服务
 */
export class ScenePerceptionService implements IService {
  private readonly CAR_CONTROL = 0;
  private static readonly executorMap: Map<string, () => IExecutor> = new Map<string, () => IExecutor>([
    [RequestMethod.CAR_CONTROL_NOTIFY, (): IExecutor => new CarControlNotify()],
    [RequestMethod.STORE_APP_NAME_CONTROL, (): IExecutor => new StoreAppNameController()]
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
      return Response.invalidMethodError;
    }
    const sceneType = 'sceneType';
    log.showInfo(`onCall sceneType = ${msg.extra[sceneType]}`);
    switch (msg.extra[sceneType]) {
      case this.CAR_CONTROL:
        const carExecutor = ScenePerceptionService.executorMap.get(RequestMethod.CAR_CONTROL_NOTIFY);
        return carExecutor ? carExecutor().execute(msg.extra) : Response.fail;
    }
    const method: string = msg.method;
    log.showWarn(`onCall method = ${method}`);
    let executor = ScenePerceptionService.executorMap.get(method);
    if (!executor) {
      log.showWarn(`onCall unknown method = ${method}`);
      return Response.unknownMethodError;
    }
    return executor().execute(msg.extra);
  }

  isSupportSegments(): boolean {
    return true;
  }

  onDisConnect(action: string): void {
    if (CheckEmptyUtils.isEmpty(action)) {
      return;
    }
    log.showWarn(`onDisConnect action = ${action}`);
    switch (action) {
      case PerceptionSceneType.CAR_SCENE:
        // 这里需添加车机相关调用
        CarControlNotify.changeCollaboration(1);
        log.showInfo('update Collaboration State');
        break;
      case PerceptionSceneType.STORE_APP_SCENE:
        // 门店暂时无需处理
        break;
      default:
        break;
    }

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