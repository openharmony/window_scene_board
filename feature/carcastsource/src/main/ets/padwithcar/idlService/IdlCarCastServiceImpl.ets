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
import { PadWithCarSceneManager } from '../manager/PadWithCarSceneManager';
import IdlCarCastServiceStub from './IdlCarCastServiceStub';
import { resultStringCallback } from './IIdlCarCastService';

const TAG = 'IdlCarCastServiceImpl';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HICAR, TAG);

/**
 * PadWithCar对外接口实现
 *
 * @since 2025-03-12
 */
export class IdlCarCastServiceImpl extends IdlCarCastServiceStub {
  constructor(des: string) {
    super(des);
  }

  recvMessage(code: number, params: string, callback: resultStringCallback): void {
    if (CheckEmptyUtils.isEmpty(callback)) {
      log.showWarn('recvMessage: callback is undefined');
      return;
    }
    log.showInfo('recvMessage');
    PadWithCarSceneManager.getInstance().recvMessage(code, params, callback);
  }
}