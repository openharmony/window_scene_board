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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlassBackManager } from '../../common/manager/GlassBackManager';
import { IExecutor } from '../callback/ServiceCallbackDispatcher';
import { ServiceResponse } from '../ServiceConstant';

const TAG: string = 'MinimizeExecutor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

/**
 * MinimizeExecutor
 */
export class MinimizeExecutor implements IExecutor {
  async execute(extra?: string): Promise<string> {
    log.info(TAG, 'received minimizeScene');
    try {
      return GlassBackManager.getInstance().handleHomeKey();
    } catch (err) {
      log.error('minimizeScene error', err);
    }
    return ServiceResponse.SUCCESS;
  }
}
