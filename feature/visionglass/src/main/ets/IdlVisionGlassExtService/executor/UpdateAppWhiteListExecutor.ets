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

import { ServiceResponse } from '../ServiceConstant';
import { IExecutor } from '../callback/ServiceCallbackDispatcher';
import { GlassAppWhiteListManager } from './../../common/manager/GlassAppWhiteListManager';
import Want from '@ohos.app.ability.Want';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG: string = 'UpdateAppWhiteListExecutor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

/**
 * UpdateAppWhiteListExecutor
 */
export class UpdateAppWhiteListExecutor implements IExecutor {
  async execute(extra?: string): Promise<string> {
    log.info(TAG, 'received updateAppWhiteList');
    try {
      if (extra === undefined) {
        log.showInfo(`UpdateAppWhiteListExecutor cancel,extra is undefined`);
        return ServiceResponse.FAIL;
      }
      let list: Want[] = JSON.parse(extra);
      GlassAppWhiteListManager.getInstance().updateWhiteList(list)
    } catch (err) {
      log.error('UpdateAppWhiteListExecutor error');
    }
    return ServiceResponse.SUCCESS;
  }
}