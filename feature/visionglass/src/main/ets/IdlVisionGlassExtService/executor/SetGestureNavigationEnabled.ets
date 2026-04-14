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

import { ServiceResponse } from '../ServiceConstant';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { IExecutor } from '../callback/ServiceCallbackDispatcher';
import { GestureEnableCaller, scbGestureManager } from '@ohos/windowscene/src/main/ets/TsIndex';

const TAG: string = 'SetGestureNavigationEnabled';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);


/**
 * setGestureNavigationEnabled
 */
export class SetGestureNavigationEnabled implements IExecutor {
  async execute(extra?: string): Promise<string> {
    log.info(TAG, 'received SetGestureNavigationEnabled');
    if (!extra) {
      return ServiceResponse.FAIL;
    }
    try {
      const option = JSON.parse(extra) as boolean
      scbGestureManager.setGestureNavigationEnable(GestureEnableCaller.VISION_GLASS, option, true);
    } catch (err) {
      log.error('SetGestureNavigationEnabled error: ' + err.message);
    }
    return ServiceResponse.SUCCESS;
  }
}