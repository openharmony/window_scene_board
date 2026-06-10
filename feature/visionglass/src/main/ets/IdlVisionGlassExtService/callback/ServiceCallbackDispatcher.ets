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

import { BackEventExecutor } from '../executor/BackEventExecutor';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { MinimizeExecutor } from '../executor/MinimizeExecutor';
import { StartSceneExecutor } from '../executor/StartSceneExecutor';
import { RequestAction, ServiceResponse } from '../ServiceConstant';
import { VisionGlassExtServiceEventListener, VisionGlassResourceManager } from '../VisionGlassResourceManager';
import { UpdateAppWhiteListExecutor } from '../executor/UpdateAppWhiteListExecutor';
import { SetGestureNavigationEnabled } from '../executor/SetGestureNavigationEnabled';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, 'VisionGlassExtCallbackDispatcher');

export interface IExecutor {
  /**
   * 根据数据执行返回结果
   *
   * @param extra 数据
   * @returns 服务端消息json
   */
  execute(extra?: string): Promise<string>;
}

/**
 * VisionGlassExtService 回调回来后的事件分发器
 */
export class ServiceCallbackDispatcher implements VisionGlassExtServiceEventListener {
  private static readonly executorMap: Map<string, (() => IExecutor)> = new Map([
    [RequestAction.MINIMIZE_ALL_SCENE, () => new MinimizeExecutor()],
    [RequestAction.PROCESS_BACK_EVENT, () => new BackEventExecutor()],
    [RequestAction.START_SCENE, () => new StartSceneExecutor()],
    [RequestAction.UPDATE_APP_WHITE_LIST, () => new UpdateAppWhiteListExecutor()],
    [RequestAction.SET_GESTURE_ENABLED, () => new SetGestureNavigationEnabled()],
  ]);

  constructor() {
    VisionGlassResourceManager.getInstance().registerVisionGlassExtServiceEventListener(this);
  }

  public async onEventChange(event: string, data: string): Promise<string> {
    if (!event) {
      log.showWarn('onEventChange invalid event');
      return ServiceResponse.FAIL;
    }

    const executor = ServiceCallbackDispatcher.executorMap.get(event);
    if (!executor) {
      log.showWarn(`onCall unknown event ${event}`);
      return ServiceResponse.FAIL;
    }
    return await executor()?.execute(data);
  }
}